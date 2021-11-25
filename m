Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22F3145D2D6
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 03:04:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231925AbhKYCHK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 21:07:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235152AbhKYCFK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Nov 2021 21:05:10 -0500
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB118C061A18;
        Wed, 24 Nov 2021 17:38:52 -0800 (PST)
Received: by mail-oi1-x22d.google.com with SMTP id bj13so9159513oib.4;
        Wed, 24 Nov 2021 17:38:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=digwsKRJmW4nJPoljxkhKTqMWVm/QVGwJva8DYYeAKo=;
        b=f5tPu+oB6q9fyJCq9u2l2a4ZzmPec4FEKQ3hdw/u3plipYEaYcrfKo+wt4R4HdCP7W
         sTmJPWp/Y1RAWrrAIZmW32HLaWYa1db6GrLx+rSbUG4swp9L/i7yspPZ6VPiv5Pc8vIQ
         v+tSSr24xx+VN9T+zMsSOcegFvNa84abTpjIDLQq3bDhAECQkLN9M/wZVKSC58sNJh8Z
         cE8DsP9/y4dktpd1u7lxyfw3xVii6ssQHwASWbvejN52yhntf2BBcAAx/j6htlrWUPvw
         sUTvvEmWQdB+SHiRtlg0bDs1UBejqnp6namEUu37C/nCURZis4TjU0QWOt1uVbqs8VBR
         iEXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=digwsKRJmW4nJPoljxkhKTqMWVm/QVGwJva8DYYeAKo=;
        b=W+7dJC++CFURevNfE7OhqlRmPsPLrLAlIjBpEXe+LKxZYwggyD3RZXEyA/ixuqn2su
         w525ekeAByapf8VUaDMx75fCL401iRxJb7Uwt6k+lgnEKLnYN3smBoR9asahPlmYLm3R
         h2EX95FDjHcZW0iBPeBKlnhz9BACG26jJqFe2eDV0a2zQ8Vwkz1sRgnj12Bhcwt1gBmr
         Bg7/LuyGN4Sb8w+UpFht0mdZprMuWLrNijEPb1IhvP2m3W1oW2V0LghESTWvCFQi5vVF
         pUQcrnS6IvUzUYyr28hqLlbcqgjf5SlbwgV6MJ2GWUwCAy59f+/7IDmY07w6TfAbuCpe
         LHOg==
X-Gm-Message-State: AOAM530t2dT/Vz1WnkkzDH0/d2AFxuusakkbbZUOLteNFu/IltxB6HLW
        dwyyCLaBFN8F19N1DlAsK0I=
X-Google-Smtp-Source: ABdhPJz2RDjHOycWmiNbh16/r2FrGayNvpggI0Yehkl+fNl7Cukrv3DwiG/8HF4IyAlUO6pqfQ8JAw==
X-Received: by 2002:aca:3e8a:: with SMTP id l132mr10755372oia.95.1637804332089;
        Wed, 24 Nov 2021 17:38:52 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id r26sm273025otn.15.2021.11.24.17.38.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Nov 2021 17:38:51 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 24 Nov 2021 17:38:50 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.14 000/251] 4.14.256-rc1 review
Message-ID: <20211125013850.GB851427@roeck-us.net>
References: <20211124115710.214900256@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211124115710.214900256@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 24, 2021 at 12:54:02PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.256 release.
> There are 251 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 26 Nov 2021 11:56:36 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 161 fail: 7
Failed builds:
	ia64:defconfig
	s390:defconfig
	s390:allmodconfig
	s390:performance_defconfig
	sh:dreamcast_defconfig
	sh:microdev_defconfig
	sh:shx3_defconfig
Qemu test results:
	total: 423 pass: 418 fail: 5
Failed tests:
	s390:defconfig:nolocktests:smp2:net,default:initrd
	s390:defconfig:nolocktests:smp2:virtio-blk-ccw:net,virtio-net-pci:rootfs
	s390:defconfig:nolocktests:smp2:scsi[virtio-ccw]:net,default:rootfs
	s390:defconfig:nolocktests:virtio-pci:net,virtio-net-pci:rootfs
	s390:defconfig:nolocktests:scsi[virtio-pci]:net,default:rootfs

mm/hugetlb.c: In function '__unmap_hugepage_range':
mm/hugetlb.c:3411:25: error: implicit declaration of function 'tlb_flush_pmd_range'

Guenter
