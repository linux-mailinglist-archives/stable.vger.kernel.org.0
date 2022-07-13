Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81247573F82
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 00:19:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232210AbiGMWTC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jul 2022 18:19:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbiGMWTB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jul 2022 18:19:01 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 024AD1EAD6;
        Wed, 13 Jul 2022 15:19:00 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id y9so189157pff.12;
        Wed, 13 Jul 2022 15:18:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xGBxqPuFGrutfvt0y81KMUI3WAcQcdp0CLaFIz10IWY=;
        b=e4O9uHrjLlyxPUgjNF0931x4rbwAC4jUrCZgpEm8Q9+COH/gaDEUtwF5T/WIunXw2D
         YIjp5KnBVCf1rfck11K4i1Z5LIMa6z4caZsvUPsrz7XtMzHHFWhb3MXy2AHLcPY8d6VV
         4gVNhn9e0K+z39TO11jmmSCXgqk1GtZH3Fv6jcv5VDdaA8SLT0CmCX1UYUjcQCW3MG+W
         ZcD9KjZGBUFJ+VLAq+G9LzvtHJWhV0ux/WE+wcUTZpQ+vK/KtsnDHfN3gwmWR2wqEkPA
         OsteLfV7mBapQYM2yTYQtW62BukBDyiEv7Byyl7rSbPXuIjAqkckfjeUZNP1cWh1TTUX
         8QYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=xGBxqPuFGrutfvt0y81KMUI3WAcQcdp0CLaFIz10IWY=;
        b=cnH6DDNfr1XodEiCiQDok7iLYfnjYx+nsAwBE5jJf4cmgGugM8KLl3fRzopZY+cwtL
         5CNkCV0sb3v33eShVT6vc3HU1KnNHKRRIv2bVLbLHF1s12yuigIo+P5aeSF/wCAzLIZe
         B4Lnezk/EVTbJ+EzIhntOtrTTWnSM53fcKC6u6Eh5fskSojxYB6KU0MWnLx4X+bkHfEQ
         3Q2X9gWvF9R0V+ecNRMcXdOKGJQ9hLuQuMpWqFVfeQ/goYFMqVkp3nbDvnA6fD5RmcgS
         0JZ0kTS1yrmNFr8gOQKqAlBWpEBCJokhKeFwEVgolIU8Azb4Xn0oNLhd4wHwTE6UPInR
         UKpg==
X-Gm-Message-State: AJIora/wxm1RhRbHpSWw1f5fZxtYdxCsiJhrHDExwy8BAtkcNul/KRTm
        ytG4CUITUrZM2ENt75doZzg=
X-Google-Smtp-Source: AGRyM1ubJX4gVJr3uLRmiff98P2XiBq5T0KVhx93BThRNnFT+dp0w0BQqzTyzMSzaq07MOQ0uMaLjw==
X-Received: by 2002:a63:1324:0:b0:419:afb2:af7b with SMTP id i36-20020a631324000000b00419afb2af7bmr597135pgl.367.1657750739552;
        Wed, 13 Jul 2022 15:18:59 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id y11-20020aa793cb000000b0052ac038672esm46516pff.33.2022.07.13.15.18.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jul 2022 15:18:58 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 13 Jul 2022 15:18:58 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.18 00/61] 5.18.12-rc1 review
Message-ID: <20220713221858.GC69517@roeck-us.net>
References: <20220712183236.931648980@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220712183236.931648980@linuxfoundation.org>
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

On Tue, Jul 12, 2022 at 08:38:57PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.12 release.
> There are 61 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 14 Jul 2022 18:32:19 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 153 fail: 1
Failed builds:
	um:defconfig
Qemu test results:
	total: 489 pass: 481 fail: 8
Failed tests:
	x86_64:q35:SandyBridge:defconfig:smp4:net,ne2k_pci:efi32:mem1G:usb:hd
	x86_64:q35:Conroe:defconfig:smp4:net,tulip:efi32:mem256:scsi[DC395]:hd
	x86_64:q35:Skylake-Server:defconfig:smp4:net,e1000-82544gc:efi32:mem2G:scsi[53C895A]:hd
	x86_64:q35:Opteron_G5:defconfig:smp4:net,i82559c:efi32:mem256:scsi[MEGASAS2]:hd
	x86_64:pc:Opteron_G2:defconfig:smp:net,usb:efi32:mem2G:scsi[virtio-pci]:hd
	x86_64:q35:Nehalem:defconfig:smp2:net,i82558a:efi32:mem1G:virtio:hd
	x86_64:q35:Skylake-Client-IBRS:defconfig:preempt:smp2:net,i82558b:efi32:mem1G:sdhci:mmc:hd
	x86_64:q35:Haswell-noTSX-IBRS:defconfig:nosmp:net,pcnet:efi32:mem2G:ata:hd

Guenter
