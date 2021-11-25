Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEDEC45D2D4
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 03:02:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345688AbhKYCFR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 21:05:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353521AbhKYCDJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Nov 2021 21:03:09 -0500
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 345CCC06174A;
        Wed, 24 Nov 2021 17:36:07 -0800 (PST)
Received: by mail-oi1-x22c.google.com with SMTP id q25so9231139oiw.0;
        Wed, 24 Nov 2021 17:36:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Os3OV2FPDkTjU4WiTzn9kPyZqlbHkg+HZpKJILevVJ4=;
        b=pI9Y6blWE1yQwDi8EpuGo2HQaoFhQvEP+mu9VXlRe5D1/R/MtghgVnJVS9FYBRYkj+
         nIW62vm7peWt+2v2K2Aa2rE1PNEnZpm4wGsZhwJjHbEMqpbEtzQ489hmRTzj4KQU9FFG
         yT+rz0nBFYLfCQz1yqqVt34UzjCWKkV8WuIMyOUqveQ4JTXreEIlFQHxYTP9NiPWRrbU
         M7Dwl6Wg8za3OroK6kYWZEhsGWXIzrRSqQv1XR7QTejIOuUwKmtC2tlbuGU4e9fjSJhb
         45jNGFfSWbbYb50WAqJEEHglWNzgDyUEWVtoLwR8XowbZo6QUQJTJy5AJZhFgA35DFmd
         MFsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=Os3OV2FPDkTjU4WiTzn9kPyZqlbHkg+HZpKJILevVJ4=;
        b=0HpFLG5jqWdXP+6p6rnmniyTFOndlxhd5HOMQvORt9Xc1D7Zk3vjkN0tQ/ucxYp7uZ
         mxf7EXzA6EQTVCOGMBQV8fY1A0wuMV7x+ugpSHg08bbH7oZGMrRn05wQTXoA1o0msIqC
         SaqyR4KJ4NuJR2iuBRGALEQNoE3Qdjv29zckeO6tBtkgqQLFVmYGe7+ZEdhudOXjsZze
         YEuF0gim6NrWDUXxcpbIV0kT0T1VValk8L18phbGOvrUutgxqe5S2V7gBUBT9G1VPJt0
         Y1DwK9gnL253N219/dvyKN3Tx+kHoqTrG5GwUr6M6rMupE4mWEZTMKvlNt+Kb5YRXWuO
         +lbQ==
X-Gm-Message-State: AOAM533feANqLH0R1C3A1THJXxV4QhG3U5XG3E9eIhHxdBumzhNgNlB2
        FMO33SVdFZXtrLFXTJYhJfFfUL3JOTY=
X-Google-Smtp-Source: ABdhPJx85DGJ7/0To/zijOaGsTkydOK8Hjeng0fjMj/YaWUhXSrxbc4ZaojpIxhL+oUryVzEC8qLqw==
X-Received: by 2002:a05:6808:1210:: with SMTP id a16mr11337737oil.113.1637804166418;
        Wed, 24 Nov 2021 17:36:06 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id h6sm274332otb.60.2021.11.24.17.36.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Nov 2021 17:36:05 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 24 Nov 2021 17:36:04 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.4 000/162] 4.4.293-rc1 review
Message-ID: <20211125013604.GA851427@roeck-us.net>
References: <20211124115658.328640564@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211124115658.328640564@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 24, 2021 at 12:55:03PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.293 release.
> There are 162 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 26 Nov 2021 11:56:36 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 160 pass: 153 fail: 7
Failed builds:
	ia64:defconfig
	s390:defconfig
	s390:allmodconfig
	s390:performance_defconfig
	sh:dreamcast_defconfig
	sh:microdev_defconfig
	sh:shx3_defconfig
Qemu test results:
	total: 341 pass: 336 fail: 5
Failed tests:
	s390:defconfig:nolocktests:smp2:net,default:initrd
	s390:defconfig:nolocktests:smp2:virtio-blk-ccw:net,virtio-net-pci:rootfs
	s390:defconfig:nolocktests:smp2:scsi[virtio-ccw]:net,default:rootfs
	s390:defconfig:nolocktests:virtio-pci:net,virtio-net-pci:rootfs
	s390:defconfig:nolocktests:scsi[virtio-pci]:net,default:rootfs

Unlike there are secondary issues, the errors are all due to:

mm/hugetlb.c: In function '__unmap_hugepage_range':
mm/hugetlb.c:3294:25: error: implicit declaration of function 'tlb_flush_pmd_range'

Guenter
