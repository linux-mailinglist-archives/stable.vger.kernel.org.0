Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9036C636676
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 18:03:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237705AbiKWRDa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 12:03:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236541AbiKWRDZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 12:03:25 -0500
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 841CA25D1;
        Wed, 23 Nov 2022 09:03:24 -0800 (PST)
Received: by mail-oi1-x229.google.com with SMTP id q83so19631825oib.10;
        Wed, 23 Nov 2022 09:03:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Xvt9NMUMshKq6vZrNophFamB+BPLohd5Icmfx4xFrM8=;
        b=bm9/oOvAW0+K3TJJ7Gj5sl3POoljrlM5fVEpGzyPYDn4OCbo2EeE67VBrIOriN/jqg
         ht41OZVqCMlusFwyludo9TG2r5836OGVFluTeXayWnJN3BwV1XlA3NC5EVlIkCH5gHPJ
         HN27HGz0DIoa4TEqjlB9O3zEO5gvarItsEocQ3K+jerWc0/bh90xxvNYnOYfAv/nSFQw
         gMQOc6drXwiicuWIoc7v0eKNzPfOY3raHDwtA6vTKMmZbIBh/28u++jjNJblBh8RKK07
         Io7YWkQaVhSTvIaweIs8MKe40rxEWQFmw7loCuk+6YlBZZUerx9FXPWKZgeSKXnez3Nu
         U+mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Xvt9NMUMshKq6vZrNophFamB+BPLohd5Icmfx4xFrM8=;
        b=6L3rxPJMpOBZyxIH0mTPnahaBzVr1YgnbhcxYGpPWb1+MemObpznsx6NY5aCNT0qUY
         Hi6EMGuLJoN+crUpcHSpWfcBJABi3Cup1+YgsM94VuXRc+8jOXjzdIwjXM8ta9d/vUeR
         q45l8/GCEVXywGtiGdQgH02j66ZKXlGd8OhcPlSFQ/bwSg6dzftU14u+6bxLrfDWRV9y
         UxV4yHgPnv9YT7vcMopdpE1M4kopz/1vZvG4S9Wm4dyTb0tPY4Pop+MtmCmV3T6OuZSG
         DmNNwXl+uV78SLq7mjFpSL5tbA1wNP/HWcNlUkm4Jx+kIbKCUtEnjK/ltXARKkIVs6p7
         eiEg==
X-Gm-Message-State: ANoB5pkKT3EQ6DOpx6OExzpWSrMQSCW6UdQexLz7bzWIdWkS/s5vu4qK
        CrGEnEI55tH74eMl3L9jER0=
X-Google-Smtp-Source: AA0mqf5wBlGvPRLvp/pTWhAa3z7dqWlSRK2KNfpsujr/Ynf5V+BHlGBDdSDKcoDbs2wesz+bqx1Fbw==
X-Received: by 2002:a05:6808:1115:b0:359:cb71:328b with SMTP id e21-20020a056808111500b00359cb71328bmr14023971oih.282.1669223003837;
        Wed, 23 Nov 2022 09:03:23 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id s8-20020a056870248800b001431bf4e5a0sm2090707oaq.38.2022.11.23.09.03.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Nov 2022 09:03:23 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 23 Nov 2022 09:03:22 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.0 000/314] 6.0.10-rc1 review
Message-ID: <20221123170322.GB3745358@roeck-us.net>
References: <20221123084625.457073469@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 23, 2022 at 09:47:25AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.10 release.
> There are 314 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 25 Nov 2022 08:45:20 +0000.
> Anything received after that time might be too late.
> 

Build reference: v6.0.9-315-gdcf677c
Compiler version: arm-linux-gnueabi-gcc (GCC) 11.3.0
Assembler version: GNU assembler (GNU Binutils) 2.39

Building arm:allmodconfig ... failed
--------------
Error log:
drivers/rtc/rtc-cmos.c:1347:13: error: 'rtc_wake_setup' defined but not used [-Werror=unused-function]
 1347 | static void rtc_wake_setup(struct device *dev)

Guenter
