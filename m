Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B47D44F7BC7
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 11:37:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232631AbiDGJjC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Apr 2022 05:39:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230323AbiDGJjB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Apr 2022 05:39:01 -0400
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B969642A;
        Thu,  7 Apr 2022 02:37:02 -0700 (PDT)
Received: by mail-oi1-x234.google.com with SMTP id q189so5041971oia.9;
        Thu, 07 Apr 2022 02:37:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9Js/h/Y3FN3Q2Mue3vOpoiO+5qrHRwvsvpWy7TYX9ck=;
        b=EuIuV+UhKpbr7tvQW/ucwzX6zcL6XIal7jdbc4DTK7D6scsu7SG2sJAATAcBgO5YDL
         7xTSIZ60YiGFGrlKTDSSlJC9srTW/RX/ZEAN3BBNZXQIlcUfh2qjl5ctnww19uByIj55
         40++jxmP1APHU2CDuqeiIaPqjLAXdF67xqJ7VTyp/txVrgs3B65MoroW7oX14/b9aHJE
         s6US4JAtybbfxySUPt1Xlud2EThIKG8CHCNNygBWX9DeDALBJgRFoyxsJVSCSkd8Utmw
         3MfNSDMG4BH5q6829/aLmLxAsvS0wQF1aMND55FYQFT7NGHbPtjrGRfIu69+JCncH9Tj
         Bfqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=9Js/h/Y3FN3Q2Mue3vOpoiO+5qrHRwvsvpWy7TYX9ck=;
        b=pgbPYuNotfdMlK8iDU3/qaZL7LEuFrJVjRxx5U6UXIhoBeXuKLlOKe1U7Xy7Ytg7cl
         F49bptf3F3J8eGo9PJx4g465KYju2+tiIonfs0fsfyyShYcFPsRSD9CRM/Fy7AC06cHz
         xiZNeDOB0HPBegKGxaIdzS1qJnCBWjINokij5rHg2re83XGphyOifGV6wEsZ1G4KInla
         53XJE1IBL+VI75RGbKo4xc2Zw5LnoZRFGkyOGHHsFVv0flBnw/JmpRBWsMtQxZsGvT0V
         niaDNnzrNPpmO0kYf0Lgp18FvtFNZi1jYrQeThnMpn55ox1tYsVP1UcAvgwo+Wy0rK8u
         vKew==
X-Gm-Message-State: AOAM531NsBP9/+EmMzVYykPj4CJHIiKI9unDHzFLNrV0l9yn3BRXZcjB
        zDCNPIdnhKH7rNV5oh91AIs=
X-Google-Smtp-Source: ABdhPJwjdr8SqwEVR2lcIXyMPsLlPOOFLqBztvVxyVocQ1pEET6mjRK6dwh8Rc4orpzt+okv6QAjFA==
X-Received: by 2002:a05:6808:305:b0:2ef:904d:a8e3 with SMTP id i5-20020a056808030500b002ef904da8e3mr5290537oie.297.1649324221454;
        Thu, 07 Apr 2022 02:37:01 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id r8-20020a05683001c800b005cdadc2a837sm7689212ota.70.2022.04.07.02.37.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Apr 2022 02:37:00 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 7 Apr 2022 02:36:59 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.10 000/597] 5.10.110-rc2 review
Message-ID: <20220407093659.GB3041848@roeck-us.net>
References: <20220406133013.264188813@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220406133013.264188813@linuxfoundation.org>
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

On Wed, Apr 06, 2022 at 03:43:51PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.110 release.
> There are 597 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 08 Apr 2022 13:27:53 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 161 pass: 150 fail: 11
Failed builds:
	alpha:defconfig
	alpha:allmodconfig
	csky:defconfig
	m68k:defconfig
	m68k:allmodconfig
	m68k:sun3_defconfig
	m68k_nommu:m5475evb_defconfig
	microblaze:mmu_defconfig
	nds32:defconfig
	nds32:allmodconfig
	um:defconfig
Qemu test results:
	total: 477 pass: 448 fail: 29
Failed tests:
	alpha:defconfig:initrd
	alpha:defconfig:devtmpfs:ide:net,e1000:rootfs
	alpha:defconfig:devtmpfs:sdhci:mmc:net,ne2k_pci:rootfs
	alpha:defconfig:devtmpfs:usb-ohci:net,pcnet:rootfs
	alpha:defconfig:devtmpfs:usb-ehci:net,virtio-net:rootfs
	alpha:defconfig:devtmpfs:pci-bridge:usb-xhci:net,pcnet:rootfs
	alpha:defconfig:devtmpfs:usb-uas-ehci:net,e1000:rootfs
	alpha:defconfig:devtmpfs:usb-uas-xhci:net,e1000:rootfs
	alpha:defconfig:devtmpfs:pci-bridge:scsi[AM53C974]:net,tulip:rootfs
	alpha:defconfig:devtmpfs:scsi[DC395]:net,e1000-82545em:rootfs
	alpha:defconfig:devtmpfs:scsi[MEGASAS]:net,rtl8139:rootfs
	alpha:defconfig:devtmpfs:scsi[MEGASAS2]:net,e1000-82544gc:rootfs
	alpha:defconfig:devtmpfs:scsi[FUSION]:net,usb-ohci:rootfs
	alpha:defconfig:devtmpfs:nvme:net,e1000:rootfs
	q800:m68040:mac_defconfig:initrd
	q800:m68040:mac_defconfig:rootfs
	microblaze:petalogix-s3adsp1800:initrd
	microblaze:petalogix-s3adsp1800:rootfs
	microblaze:petalogix-ml605:initrd
	microblaze:petalogix-ml605:rootfs
	microblazeel:petalogix-s3adsp1800:initrd
	microblazeel:petalogix-s3adsp1800:rootfs
	microblazeel:petalogix-ml605:initrd
	microblazeel:petalogix-ml605:rootfs
	s390:defconfig:nolocktests:smp2:net,default:initrd
	s390:defconfig:nolocktests:smp2:virtio-blk-ccw:net,virtio-net-pci:rootfs
	s390:defconfig:nolocktests:smp2:scsi[virtio-ccw]:net,default:rootfs
	s390:defconfig:nolocktests:virtio-pci:net,virtio-net-pci:rootfs
	s390:defconfig:nolocktests:scsi[virtio-pci]:net,default:rootfs

Errors:

fs/binfmt_elf.c: In function 'fill_note_info':
fs/binfmt_elf.c:2050:45: error: 'siginfo' undeclared
fs/binfmt_elf.c:2056:53: error: 'regs' undeclared

Plus there are the same s390 crashes as with -rc1.

No idea what I am missing here, but the failures are exactly the same as for -rc1.

Guenter
