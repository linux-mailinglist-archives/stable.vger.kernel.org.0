Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC37745D2D8
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 03:04:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232160AbhKYCHK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 21:07:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237222AbhKYCFK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Nov 2021 21:05:10 -0500
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5518CC061A20;
        Wed, 24 Nov 2021 17:40:15 -0800 (PST)
Received: by mail-oi1-x22a.google.com with SMTP id t23so9175909oiw.3;
        Wed, 24 Nov 2021 17:40:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=z9RUz7IYPgHVRSbLMwUqKtAcz3uQFS5BkVAgRop5Xqk=;
        b=NJlcX4SDw36LXkFaLiQUxDfscPKOVkrgrG32ouefFQVLI3ldYBSNDQt4heXGaXl+FX
         gs6ERg+2n6zRo05lN5gqroAYpdtUsS2/0QeNulsRJpCZ5s3QQW6EZ05KJN8n4B/a2c4Y
         8Gtat0TmDiSRSGfjGH0A9dHCRJYLn71Wq71tRV3YwQITYHW+jGVCbb9eAdMmlK5F9rQ6
         77Qs4MgNahG2WwUEga0oo9KtFYsTbI/VNHZ+HSMl6tGTK6zSWGKObuDZ2eq/XJc2NpXJ
         OzJiS7zXBnz8grG96NANpqIJAxTZpFKbD5B9+l/def55fddFgRJgp8vGTRAIOYdFyvjY
         vYiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=z9RUz7IYPgHVRSbLMwUqKtAcz3uQFS5BkVAgRop5Xqk=;
        b=ORaSw9kWQtynb7OwzvhK+6C105lsCjU6T9dZzHxUs828osJhmstNYEY6RQ/rkUXSsK
         v45t2hmnJkLdzJzCqDuopqNx4RfbAbSfuSwyb+iCPFsghzqmUQrOD5ytoGm2AfrcIM8F
         5r3/0D6ZXUmdOI1FtTLuYArG+AwBJojUL41Ylaflmjn2E5TsxRHNyqLjtBi7MvusWltU
         6gKnQlM56tJgdQITk0aAZgZaEnEhrOr68Zg7vqNKJ4y/mTU8ZrjZ5OF19jTDY2krq5z9
         6ka1ghnxGrYMFouCx0Ae61sCH7Gb/+WQLkANiWq/76eSm8JdEFdHKaZE637AwjkTKg8H
         TEEQ==
X-Gm-Message-State: AOAM530x2EqT0xXk4zeuUY2gF6s+0n0SElQwKFtnMz8Hw9OXMKHzrNCk
        eDMq1fRSG/wc49oNh+LXmBA=
X-Google-Smtp-Source: ABdhPJzSBhzPN2nQUSTmo8z5wbcwlyHk+6vKecQ368MJfVVpQ6EKh7b9vtHiE/WohGz/SnixtC5tHA==
X-Received: by 2002:a05:6808:1811:: with SMTP id bh17mr11055397oib.105.1637804414757;
        Wed, 24 Nov 2021 17:40:14 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id f12sm267756ote.75.2021.11.24.17.40.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Nov 2021 17:40:14 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 24 Nov 2021 17:40:13 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 000/323] 4.19.218-rc1 review
Message-ID: <20211125014013.GC851427@roeck-us.net>
References: <20211124115718.822024889@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211124115718.822024889@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 24, 2021 at 12:53:10PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.218 release.
> There are 323 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 26 Nov 2021 11:56:36 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 147 fail: 8
Failed builds:
	ia64:defconfig
	s390:defconfig
	s390:allmodconfig
	s390:performance_defconfig
	sh:defconfig
	sh:dreamcast_defconfig
	sh:microdev_defconfig
	sh:shx3_defconfig
Qemu test results:
	total: 441 pass: 436 fail: 5
Failed tests:
	s390:defconfig:nolocktests:smp2:net,default:initrd
	s390:defconfig:nolocktests:smp2:virtio-blk-ccw:net,virtio-net-pci:rootfs
	s390:defconfig:nolocktests:smp2:scsi[virtio-ccw]:net,default:rootfs
	s390:defconfig:nolocktests:virtio-pci:net,virtio-net-pci:rootfs
	s390:defconfig:nolocktests:scsi[virtio-pci]:net,default:rootfs

Again:

mm/hugetlb.c: In function '__unmap_hugepage_range':
mm/hugetlb.c:3455:25: error: implicit declaration of function 'tlb_flush_pmd_range'

Guenter
