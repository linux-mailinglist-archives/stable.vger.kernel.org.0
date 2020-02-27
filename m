Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46C171728DA
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 20:42:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730736AbgB0TkS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 14:40:18 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:36366 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730716AbgB0TkR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Feb 2020 14:40:17 -0500
Received: by mail-pl1-f193.google.com with SMTP id a6so215725plm.3;
        Thu, 27 Feb 2020 11:40:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=2Kjoqysk6gSi3byP/Av9Kd5WTwb/bJB2OS6hFuH6MkI=;
        b=AHn6RrhKAqJYZ7NfuNHz/2QFqIi7GnQKF1eAQ2KuFjmsuUaoS91+Hf5Klob/k9VXPM
         /mQAnqGIS9xvMVdYJ64+IjSaAY2gH7OOOn6ZMQjtg92hdogrXGraLuISN+AnN1yQdBy9
         vrAn6Jf1TAIt1Rf/gSDVEEd/zqOsvVSv3CkoRYtPt4k4zWqIsKpapOeLzhxhJvv4Gptw
         woMQois3SjFau3VHHAx53nw8d/Xf+xCBRzeEA1HodrDmyofqjZ+1dZ65TbMQEgqgLQGi
         gxZ/wbCrzgYTEQ+SZcLORGw/lCPU1ghXXTq3sfeWyyVjjMIMF8becLKCLD3F7+uGhTrJ
         jHsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=2Kjoqysk6gSi3byP/Av9Kd5WTwb/bJB2OS6hFuH6MkI=;
        b=nBZqLplfeuUTQp069n/HeoMbFD+1Hg18HC09FRnterQbyGxOC35s0W70cyfUYvsylv
         w18BBXAtybF2/O42HJB+A00i//kzoMic1IkTIYBUZvFDIe3S4fV+XVuSCDajUD4BUCS2
         jx1NTVjapiDqyF/Tg2PBZB89T3mVV6K36J4F30LiDJgyfYzpxAmUvlqzHNYfKxs9iIx0
         RAfQSodSjN/IKE4RQJ/9P+6VrM+yK8ojIVuKtUOCkxFdak/D9CA6845PXh1sivyKRieL
         IXvlncMBznjIHI4Q1D5GyK+xsQQGcs/sNiG963uxr7CP1EX+CHLc6Pr6kPUllcW3Q8wn
         5HJA==
X-Gm-Message-State: APjAAAXUte54gVM7fJzmDQZL3zSY1hTplKBZYldJYn4+xrPYjrxQMoUL
        3H4Z0MzdLlGuF4DUN+7rS/E=
X-Google-Smtp-Source: APXvYqxec6/gJGSHxBEPxiCdeMeCc7px+e5aG306WxE8kn8otdwddqI9rPGs7xiImY1Hi1fopFfwqg==
X-Received: by 2002:a17:902:9a86:: with SMTP id w6mr342958plp.37.1582832416678;
        Thu, 27 Feb 2020 11:40:16 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id u23sm7927216pfm.29.2020.02.27.11.40.15
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 27 Feb 2020 11:40:16 -0800 (PST)
Date:   Thu, 27 Feb 2020 11:40:15 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.14 000/237] 4.14.172-stable review
Message-ID: <20200227194015.GC31847@roeck-us.net>
References: <20200227132255.285644406@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200227132255.285644406@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 27, 2020 at 02:33:34PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.172 release.
> There are 237 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 29 Feb 2020 13:21:24 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 172 pass: 170 fail: 2
Failed builds:
	powerpc:defconfig
	powerpc:allmodconfig
Qemu test results:
	total: 394 pass: 378 fail: 16
Failed tests:
	ppc64:mac99:ppc64_book3s_defconfig:smp:nvme:rootfs
	ppc64:pseries:pseries_defconfig:initrd
	ppc64:pseries:pseries_defconfig:scsi:rootfs
	ppc64:pseries:pseries_defconfig:usb:rootfs
	ppc64:pseries:pseries_defconfig:sdhci:mmc:rootfs
	ppc64:pseries:pseries_defconfig:nvme:rootfs
	ppc64:pseries:pseries_defconfig:sata-sii3112:rootfs
	ppc64:pseries:pseries_defconfig:little:initrd
	ppc64:pseries:pseries_defconfig:little:scsi:rootfs
	ppc64:pseries:pseries_defconfig:little:usb:rootfs
	ppc64:pseries:pseries_defconfig:little:sata-sii3112:rootfs
	ppc64:pseries:pseries_defconfig:little:scsi[MEGASAS]:rootfs
	ppc64:pseries:pseries_defconfig:little:scsi[FUSION]:rootfs
	ppc64:pseries:pseries_defconfig:little:sdhci:mmc:rootfs
	ppc64:pseries:pseries_defconfig:little:nvme:rootfs
	ppc64:powernv:powernv_defconfig:initrd

Failures as already reported.

Guenter
