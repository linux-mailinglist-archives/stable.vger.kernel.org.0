Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86447354985
	for <lists+stable@lfdr.de>; Tue,  6 Apr 2021 01:52:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242196AbhDEXwG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 19:52:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242911AbhDEXwF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Apr 2021 19:52:05 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2C5AC06174A;
        Mon,  5 Apr 2021 16:51:58 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id n140so13236154oig.9;
        Mon, 05 Apr 2021 16:51:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=hYn0UEULkWKNrFe3fhmg/SHxb9Xe3EbVnLP+SzX4mPI=;
        b=cJKRcyE6sWwdnxB97gdA1c9YItGhCpyL0ybhue77zsNJkNsXxDLHs0zgh1mcBUlyx4
         VXgB4gLg/cMn9u4r6SGCOIxrJVp/ZHd7H5KookB1Q1F36wPcJg4aL3ZBszsPuIHtaDWr
         gOlfqRRwwk7+lj2qCMTne7T6t5gJlXKq5jtux7AJUK8vxyIjSATVhMZAsCncSKJlmiUL
         GbJO4AV3C8TjYhxQ+4TF/fDPiZ9rfS4N3rWXOY9461SgZWvvcY6NZcyIliqa2rsugDQr
         Z9vsYzn+YVSeH22BL5IpX/ydvFDrbQBcKqeGUMzX6Zhw34oHqyKCAlJRHZc3AvSEA/UP
         06Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=hYn0UEULkWKNrFe3fhmg/SHxb9Xe3EbVnLP+SzX4mPI=;
        b=ATNZvxG4RFhw71yAaYSMXyC/kpzTUtvrU91PpEfNa5efVHr8nZo4VU/7Bw6FMNwoe7
         4dgs8tooJU8ivrrEg4J/EsLCxdEKQ7ViLJvWv5mc9jD+qSu+FvFMOZ4PVa8BOlzG0UUc
         X1a1hvNFuWft5C0L37lvlVkFRh2dnCboD4KEpDrRQbRlTDbeXZIS+4i/Y2PwZYke5kHI
         ptLIdpKHXcCgf6fee/pWQjXDg3Mpz2t44F8qHNtTz1BZ43sGtpwZweDkxSJvEromAofi
         wlZCMRZYk0U5j6khDvpGLIrm0xAIrfOi+iC4SsSKw12qvwiJzHi9qyHoLZudy9bReK6E
         LDSA==
X-Gm-Message-State: AOAM533w4P65qZl8/yGzDiLePalKIT8Do0/AJNfOIN23wQOgxdYnsBvG
        Sa95ZYQq0essRq18q45eBtxCMJBK4ms=
X-Google-Smtp-Source: ABdhPJwrG0G8LYmj+Fm+7e8L3VPcJKSCMSa/0G6183PdWKpxqlJKD1T2iet/mMMwLZ4bwUpvLNkAgQ==
X-Received: by 2002:aca:f13:: with SMTP id 19mr1137848oip.56.1617666718330;
        Mon, 05 Apr 2021 16:51:58 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id e12sm3783220oou.33.2021.04.05.16.51.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 05 Apr 2021 16:51:57 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 5 Apr 2021 16:51:55 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.9 00/35] 4.9.265-rc1 review
Message-ID: <20210405235155.GA75187@roeck-us.net>
References: <20210405085018.871387942@linuxfoundation.org>
 <20210405175629.GB93485@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210405175629.GB93485@roeck-us.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 05, 2021 at 10:56:29AM -0700, Guenter Roeck wrote:
> On Mon, Apr 05, 2021 at 10:53:35AM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.9.265 release.
> > There are 35 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 07 Apr 2021 08:50:09 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 163 pass: 163 fail: 0
> Qemu test results:
> 	total: 383 pass: 382 fail: 1
> Failed tests:
> 	parisc:generic-32bit_defconfig:smp:net,pcnet:scsi[53C895A]:rootfs
> 
> In the failing test, the network interfcace instantiates but fails to get
> an IP address. This is not a new problem but a new test. For some reason
> it only happens with this specific network interface, this specific SCSI
> controller, and with v4.9.y. No reason for concern; I'll try to track down
> what is going on.
> 

Interesting. The problem affects all kernels up to and including
v4.19.y. Unlike I thought initially, the problem is not associated
with the SCSI controller (that was coincidental) but with pcnet
Ethernet interfaces. It has been fixed in the upstream kernel with
commit 518a2f1925c3 ("dma-mapping: zero memory returned from
dma_alloc_*"). This patch does not apply cleanly to any of the
affected kernels. I backported part of it to v4.19.y and v4.9.y
and confirmed that it fixes the problem in those branches.

Question is what we should do: try to backport 518a2f1925c3 to v4.19.y
and earlier, or stop testing against this specific problem.

Any thoughts ?

Thanks,
Guenter
