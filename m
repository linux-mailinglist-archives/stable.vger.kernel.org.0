Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E6005ED284
	for <lists+stable@lfdr.de>; Wed, 28 Sep 2022 03:13:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230172AbiI1BNL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Sep 2022 21:13:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiI1BNK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Sep 2022 21:13:10 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD8041166C5;
        Tue, 27 Sep 2022 18:13:09 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id v186so11160773pfv.11;
        Tue, 27 Sep 2022 18:13:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date;
        bh=320wQge/QyZxWjDttZAyDxA6PNv8cziLieA8apMW6/w=;
        b=UrZ0okq+n3xsnzEudQmxUQXSdxqiS1pEpDuWXZ3h4txRdoUScrD1MG7ANe1QY4axZX
         WF1bYbYgr5qhfdCYncalaYxFD+OGCMIK6esoi0DCId7QSyhfanLtW6kK0t6XEHs0K5uA
         QFnXhkyfSCWRwGH2QU2RoSzm8tr4SJFZyZ1yOzul+AsSq1XIgTbsbxK9A7tlzrEkIDVh
         vC5mkAUsV2Bxdd7HioMAsMBkqKN50ZyQzRh5eYXX6zZw4JA6jbtcPhIf6hwbvUUf1zTx
         8s+1e38FuH3WIwSdmYH7sdHhkxQFreZqGs/+GvsQVJKdUQ/BvKns6S3y2YSqMcATgWW1
         gR9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date;
        bh=320wQge/QyZxWjDttZAyDxA6PNv8cziLieA8apMW6/w=;
        b=G2oQ1NqvcK4jjzLYOBciQUZqz/r014L9OlEPu0UgVYvOLcNyhS+haYkC/6xvYSC45S
         CwULFuRj5Q9xUS19SSvBv6BunftcEUYtNQziUAcR7Fm5EYFPsJKEQSEspLzapcfFHbIG
         +LCV3/dm4VPM4d3ryYpR2NeRWsDkpthMNPfChbL+J+g7Jnms+IPBVNUgFz6U6rCv0JGT
         K3t2fuxH2NlJ222uoKQaK99djHAuzyRTBk1kddnhZ+aHI6QyH/TghBOqFI2RkIAenxvw
         eF/hdniRZQ/1UEbQMQqAmJ6BHT9KQmUf7rQq0GypckQJOU4TAT0CbHD/ifNTCwz/gORU
         OtDA==
X-Gm-Message-State: ACrzQf3bw3mGWeMPV8+UJk/oTmnZt40zaivZ2Rq8i4mT/qSh6JuZ8Sfm
        8tAF9oZ21n/DRh5pOFU0r5g=
X-Google-Smtp-Source: AMsMyM6RZgXXNK+GCS+Az1eWBg5DJpMsKtUR6LjH9ughbqgEguZAq4P6eya4aiQZkRXKYAQ/hiquxQ==
X-Received: by 2002:a63:778d:0:b0:438:5c5b:f2ac with SMTP id s135-20020a63778d000000b004385c5bf2acmr26994263pgc.401.1664327589371;
        Tue, 27 Sep 2022 18:13:09 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id s22-20020a170902b19600b0015e8d4eb1f7sm2213864plr.65.2022.09.27.18.13.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Sep 2022 18:13:08 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 27 Sep 2022 18:13:07 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 4.9 00/21] 4.9.330-rc2 review
Message-ID: <20220928011307.GA1700196@roeck-us.net>
References: <20220926163533.310693334@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220926163533.310693334@linuxfoundation.org>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 26, 2022 at 06:36:31PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.330 release.
> There are 21 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 28 Sep 2022 16:35:25 +0000.
> Anything received after that time might be too late.
> 
Build results:
	total: 164 pass: 164 fail: 0
Qemu test results:
	total: 395 pass: 395 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
