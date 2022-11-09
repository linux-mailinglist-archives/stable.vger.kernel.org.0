Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 983BC62224F
	for <lists+stable@lfdr.de>; Wed,  9 Nov 2022 03:57:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230031AbiKIC5H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 21:57:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229850AbiKIC5G (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 21:57:06 -0500
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C35D27CC1;
        Tue,  8 Nov 2022 18:57:05 -0800 (PST)
Received: by mail-oi1-x22a.google.com with SMTP id q83so5828621oib.10;
        Tue, 08 Nov 2022 18:57:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=h6Sux44Q2CGgE7BKTrONowpFACwKq+Ls//yVTckb6pI=;
        b=c/9bXMN26wLnDTvuugz+DlxuIfXoiIlZwrPZLxEQ5EAhCJgJy6It3ck+1RNQ031AOu
         jteokKeSxiYGnpy3h0yscWs47IMrLPKerdpHnpQqlrVJuXaXlYEN257FAkecbOjT5XJE
         M9A0Dfg6v+H7N1ZOadfC/xMNn66aO6qSt08SX7MGRaWBq/YWjW5ShOUu/hjXl78ELH8w
         YrfLy0gBJSE5r3OrR4+B7WK0wqy0oGd7yERCeDYu80tRuuOCKuGdzkg8gxdikwOfNmnm
         3BfpWBVOKHO6hs2dYt28FEl63fGJHvj7CU+RRGovU4Mlax7cM/poYOrMxJBWAq5Mdtfu
         T0+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h6Sux44Q2CGgE7BKTrONowpFACwKq+Ls//yVTckb6pI=;
        b=TcGm4oBJ1C0MJbSNTrYYOVVNxLQ51jl0aX8dVL9761M90ithLkiqy0BW/je7aBlmwy
         YgmRznUHW9lgIQoMzn8sNeMWUalx26yZoM0AhGRgeTuU3cPjCgw353U7q5gyNrnuHRQK
         GyOuD5YP1jDbevQsGT4uQmCUSb1UgoBt9CFRspIw359kVIHdRck4FQp0wXG9LiQ5SK/O
         zDZHXxQbVeirlfqtJBxj8hno71RWAcEYwUTiC6qdZ+bbfWPFJo6d9fKIbMDlGoL0dkw0
         Iv8qsStb2grgOoMNuu5FtmjQbaJ52eaqtxosBfy5JHCmCtDTVxLFLciRgC39fIcn6KJj
         GlRg==
X-Gm-Message-State: ACrzQf1+G0GSg3SOCYglyDzd9JIoxfA1R6hzPchB7SxVSmEQWpzP+jYC
        PaK8OXMgzVrrRTs6kUt4DcU=
X-Google-Smtp-Source: AMsMyM6wrj/dg1ngX6eKsKdZsDhM2BciITU0IfeI50LyDeoheTooyX+pOUKnVmc3hxW7We/dd9E5Mg==
X-Received: by 2002:a54:448b:0:b0:359:da58:1073 with SMTP id v11-20020a54448b000000b00359da581073mr31570108oiv.159.1667962624912;
        Tue, 08 Nov 2022 18:57:04 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id bg36-20020a056820082400b004956ee06cadsm3846520oob.43.2022.11.08.18.57.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 18:57:04 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 8 Nov 2022 18:57:03 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Subject: Re: [PATCH 5.4 00/74] 5.4.224-rc1 review
Message-ID: <20221109025703.GD2033086@roeck-us.net>
References: <20221108133333.659601604@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221108133333.659601604@linuxfoundation.org>
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

On Tue, Nov 08, 2022 at 02:38:28PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.224 release.
> There are 74 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Nov 2022 13:33:17 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 161 pass: 161 fail: 0
Qemu test results:
	total: 447 pass: 447 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
