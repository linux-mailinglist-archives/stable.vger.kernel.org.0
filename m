Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20AA059B119
	for <lists+stable@lfdr.de>; Sun, 21 Aug 2022 02:57:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232315AbiHUAyW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 20 Aug 2022 20:54:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbiHUAyV (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 20 Aug 2022 20:54:21 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBD5A1BEB6;
        Sat, 20 Aug 2022 17:54:20 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id bh13so6537730pgb.4;
        Sat, 20 Aug 2022 17:54:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=PCxima2KTl4dbZZJZqOAMZu94ede6JMCiv4Ny/WuIoM=;
        b=pf0olPkW5pLb6dNK0x+UZEcYJtC2hs2b+FNzqOpylTyOa5XwRIk2SvuI25LE0F6Ziz
         ZdpnkCjTEvFLcSCsGua2awkwlGot4WD2IF7L347rN7wXp1N8GA6EfAdO9MkReDolBlv9
         vR/M+B3Y8fNumkhsg9CDdsS8hWOhilOP51x5JckY91iyyEaFL1OsWaAtmuGGrmIXzppa
         y17mghYG6VpDXN4lVWu5nJX/e4qJhmCW9OynTTsIqfp3T7ZcqOCTdDqNV2QhMNSQrjQH
         9VhrIq5q1WrkX9MEw5HQimwjVkhPRnUEk7CggteeXif/GWPo/KkoLAW2L8mTZMxvv854
         wZOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc;
        bh=PCxima2KTl4dbZZJZqOAMZu94ede6JMCiv4Ny/WuIoM=;
        b=NQKKt5itti0S/s5tmX4ncuYn3cx/J8HKAI2g46b7OaqySHG2H2I58uSgPbqJs+CtW+
         gKmedT0u3sSJ/qd4jmfh654jIvydvCwbqPuvOcvRdwFR5B6NZeHMqP5ARsji+oBHa+LJ
         q0vtUEHUCd9rD7SkFJOyJuY5o6ZRixrYAfhWi+HqAfJHYIFCokLLBQiPh71kPLk/FNib
         sLV3ywLGI+QJ5UdZp/X6YhHsKRC/m4ASlOaqMYIAgAmfl87OwEvnFhNeDv2PmISFrC5f
         YufSrFX3igfIIPwd2h8oxcCwIimy9rn0FXIaGRv4iQ6z5ilZaOE9ooZuw5Y7IlkXSp6i
         KHrA==
X-Gm-Message-State: ACgBeo2fBMV7LmMbMiiELP5doP7Icxj1qQdsPu4MYeDgnSAFlboYTKYg
        P4EhD7/DQlCRjGQE/TgLajw=
X-Google-Smtp-Source: AA6agR5QknamWuWqNixSaz/XGNDdKDqylwqlclf0kgAFJtl9bo4fjyS8pbimCD49ZlTG+teoCMmULQ==
X-Received: by 2002:a62:be0e:0:b0:536:76fe:ee96 with SMTP id l14-20020a62be0e000000b0053676feee96mr256340pff.44.1661043260290;
        Sat, 20 Aug 2022 17:54:20 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id s24-20020a639258000000b0042a3d9a1275sm3042008pgn.16.2022.08.20.17.54.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Aug 2022 17:54:19 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sat, 20 Aug 2022 17:54:18 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.19 0/7] 5.19.3-rc1 review
Message-ID: <20220821005418.GB990187@roeck-us.net>
References: <20220819153711.552247994@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220819153711.552247994@linuxfoundation.org>
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 19, 2022 at 05:39:16PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.19.3 release.
> There are 7 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 21 Aug 2022 15:36:59 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 150 pass: 150 fail: 0
Qemu test results:
	total: 489 pass: 489 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
