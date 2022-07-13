Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44113573F7F
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 00:18:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236807AbiGMWSS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jul 2022 18:18:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbiGMWSR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jul 2022 18:18:17 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E6BF2A26C;
        Wed, 13 Jul 2022 15:18:15 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id f11so10804239pgj.7;
        Wed, 13 Jul 2022 15:18:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Ko7QEynAmCOumsLObUWSFACp38LhgpGeUYtJDc/K54M=;
        b=m5fHquRGVoNCyxZMZN2p/4xUIoluG3kC84v4WH2iwup1xdl9Y3sPBsZnSszKal4KSC
         OzXK0KN/TbaAIzfCLWNqJLxgSNWyi1/wkqiSKCmxwkNvt9Vx8apXiVV6XMC1LxxIxDvk
         G/6hTzp/olUO1nF1zoNDgHRR1qXrNkUmASRULnU/gqkHNFZZhWmtyDErvwg6N6TS2P3d
         Nksdc/K9C4qRCQuyoroPTt+ONpCySte/fiFF9YnejuPzYf3y6nO0KSFZU8rwiVHbDJfv
         b6G8aWAUg4syxqpM2e9NlJ3Uxg+wJzeiDpvd7wRZKXpUKkMseMUgj70qpHCFu5G/8PHS
         UbjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=Ko7QEynAmCOumsLObUWSFACp38LhgpGeUYtJDc/K54M=;
        b=JFP8a41NCZlFHBth9yZ50KlIPIZV+ku2BiA+KlR3cDyT5feTdKuUXLNv6n1D38F/KY
         VPccKtBvEERYZ01YpbDW5pmO7BdSp8O8qWWbVRzHL3f+KkexGFp3hPcouxHwlEByTl+6
         PYcOQPFwm1A0bHODGas3/JnTQM3a2+Wohn8t5jn8nyw5omWEr1X6acoPyA/Y8LRYfnFC
         MmGONzu8zmwqzlWMKbhJ10O8ROGBy9RNNTKnHM1e9jxzy6v1OO8sQ0UxQRge2r4yVqwV
         DZ9g09y7vGQCgIHQ2B86dd9U9s/zDDAKSSV7hw9XBl2LL7jQLJ8u69tnResDFtH1JMbf
         iFhw==
X-Gm-Message-State: AJIora+1rDBWlyDSauQTiiGuiCEgVaKL73dlr9QT1qFftLFeVXgMmONj
        CNlEG6aEYkpY4qbxAiYR1Zs=
X-Google-Smtp-Source: AGRyM1u6RVncAgzBum/rApFPHVTudLUXJXW5QYihconlADS+WmV1KpdsGkvwKUf6Ens07TG+ztRj5A==
X-Received: by 2002:a65:6885:0:b0:412:a2ed:c3b with SMTP id e5-20020a656885000000b00412a2ed0c3bmr4654433pgt.606.1657750694582;
        Wed, 13 Jul 2022 15:18:14 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id e16-20020a631e10000000b00412a3c1efddsm8457167pge.42.2022.07.13.15.18.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jul 2022 15:18:13 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 13 Jul 2022 15:18:13 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.15 00/78] 5.15.55-rc1 review
Message-ID: <20220713221813.GB69517@roeck-us.net>
References: <20220712183238.844813653@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220712183238.844813653@linuxfoundation.org>
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

On Tue, Jul 12, 2022 at 08:38:30PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.55 release.
> There are 78 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 14 Jul 2022 18:32:19 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 158 fail: 1
Failed builds:
	um:defconfig
Qemu test results:
	total: 488 pass: 480 fail: 8
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
