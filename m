Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E80DE45D2FE
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 03:12:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234086AbhKYCP1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 21:15:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229821AbhKYCN0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Nov 2021 21:13:26 -0500
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28540C0698DC;
        Wed, 24 Nov 2021 17:50:19 -0800 (PST)
Received: by mail-ot1-x330.google.com with SMTP id v15-20020a9d604f000000b0056cdb373b82so7124171otj.7;
        Wed, 24 Nov 2021 17:50:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xOPhCOlCNp6uUIBaUHNqh+qJKVIjQdFpa4WJew+wXmM=;
        b=qewz+LoKoG28hL94OD4MdcdP1EJBRKSARjjgX61lJfv20iMGfNVXj4KTF8evPTnX0/
         E/2tNGNN07RIAbUCGcMKCVoV7fmQvog/qi0BWkFCI//sMRb/gQ0t0fRtRm6ADl10n4+F
         yYzeXEqJUDQlwd8+PWd1/t3JflZFQLSKHm3jqxnPexGiEZIN/h6mx5e08tnEn9UO8W/q
         NOj+eT4VqD4ARBEp08B1UuL6xnuEnIfSzyTo9UZyjWy3Gg8gcenD2vozvpQ5r6bjkOCw
         V313FA49tZyT22oNxGHaqvXdrQoNYVN0RCBUjUDIoLm7p7KHWZUkzpjTnUkWaTc7Jm0+
         nEZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=xOPhCOlCNp6uUIBaUHNqh+qJKVIjQdFpa4WJew+wXmM=;
        b=4pEu96rKSAT1cV+W1KCcDd9WfrAAKTZZB9LaaSduyUOzEYkqf2L8BAkiFoPSi++dWv
         vJyq1T/nvoxpQMTR+Gr06DrDwTIhT0Zy3OKvWPofG6GHtYednEdyRD8ORDG8zDBnJkFo
         Lc/VpJ+kd6EiR4m1n2/X0Yt/JvavzyoUnShjlFoGZ0PAc4B0R6NI7r+fsF17doA+/fjN
         D0lcfta59yT+NeaAd1MphxfFh1l9ft8/kgmyfPmE7/NlZ0/B5GKM5rNAKywnQbajCsWR
         miiqRXnZYKfQOZLxc+Fz6QZhaGBI9QMHZoU2iiwhUHUlipf7SaycIO7rMHAoQ8FDPhcM
         WopA==
X-Gm-Message-State: AOAM5329hC1RuBMBxxYAxOfU4AWTvPdBxy17Ymf828qcyiSg13jMwTtd
        B/iF9e1Apfb/QcBx+b6cghk=
X-Google-Smtp-Source: ABdhPJx8e4Q3tcdFNIyyzSFjCRee9m4aKH03siICvBDwW9lkHGd4bWIVxuhLqn+NTHGdBUkf7lwz2A==
X-Received: by 2002:a9d:ea6:: with SMTP id 35mr17699064otj.304.1637805018595;
        Wed, 24 Nov 2021 17:50:18 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id c9sm307314oog.43.2021.11.24.17.50.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Nov 2021 17:50:18 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 24 Nov 2021 17:50:16 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.9 000/207] 4.9.291-rc1 review
Message-ID: <20211125015016.GG851427@roeck-us.net>
References: <20211124115703.941380739@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211124115703.941380739@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 24, 2021 at 12:54:31PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.291 release.
> There are 207 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 26 Nov 2021 11:56:36 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 163 pass: 134 fail: 29
Failed builds:
	arm:allnoconfig
	arm:tinyconfig
	arm:efm32_defconfig
	blackfin:defconfig
	blackfin:BF561-EZKIT-SMP_defconfig
	c6x:dsk6455_defconfig
	c6x:evmc6457_defconfig
	c6x:evmc6678_defconfig
	h8300:allnoconfig
	h8300:tinyconfig
	h8300:edosk2674_defconfig
	h8300:h8300h-sim_defconfig
	h8300:h8s-sim_defconfig
	ia64:defconfig
	m68k:allnoconfig
	m68k:tinyconfig
	m68k_nommu:m5272c3_defconfig
	m68k_nommu:m5307c3_defconfig
	m68k_nommu:m5249evb_defconfig
	m68k_nommu:m5407c3_defconfig
	microblaze:nommu_defconfig
	microblaze:allnoconfig
	microblaze:tinyconfig
	s390:defconfig
	s390:allmodconfig
	s390:performance_defconfig
	sh:dreamcast_defconfig
	sh:microdev_defconfig
	sh:shx3_defconfig
Qemu test results:
	total: 396 pass: 389 fail: 7
Failed tests:
	arm:mps2-an385:mps2_defconfig:mps2-an385:initrd
	mcf5208evb:m5208:m5208evb_defconfig:initrd
	s390:defconfig:nolocktests:smp2:net,default:initrd
	s390:defconfig:nolocktests:smp2:virtio-blk-ccw:net,virtio-net-pci:rootfs
	s390:defconfig:nolocktests:smp2:scsi[virtio-ccw]:net,default:rootfs
	s390:defconfig:nolocktests:virtio-pci:net,virtio-net-pci:rootfs
	s390:defconfig:nolocktests:scsi[virtio-pci]:net,default:rootfs

include/asm-generic/tlb.h: In function 'tlb_flush_pmd_range':
include/asm-generic/tlb.h:208:54: error: 'PMD_SIZE' undeclared

mm/hugetlb.c: In function '__unmap_hugepage_range':
mm/hugetlb.c:3415:25: error: implicit declaration of function 'tlb_flush_pmd_range'

Guenter
