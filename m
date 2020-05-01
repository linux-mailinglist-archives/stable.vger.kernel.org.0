Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB5791C203B
	for <lists+stable@lfdr.de>; Sat,  2 May 2020 00:00:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726333AbgEAV7k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 17:59:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726045AbgEAV7j (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 May 2020 17:59:39 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56001C061A0C;
        Fri,  1 May 2020 14:59:38 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id d24so4090470pll.8;
        Fri, 01 May 2020 14:59:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=SzPukKl2CPx/8RlWz33HWqiKK+RNMTLLEn/EbDaTvis=;
        b=YrwQLE+4pnsfYmizpy+718SeMLUTCGDoEF6SQsUhLxHmfLsYL7GlrDC0tnzT4urfTt
         MDvzsn7DUramnBnIsB6rSIkBq9j/l15gIpepXnAutSKSgrUko+3JI19NLgR6o9e9/ZnK
         0EV0+c/xFlWzxzGf0TSaJaOHqo0pl0Zat08EHTE7YWpUXn6rG6tli6U9/e2KLMOasaSH
         dtuNNiH3kwiVbVXpUtqffiuwkDV/g28Ddm7L8cUESf4SCvuooVJ9kCQ+iYYhUKVK3D0H
         oyCDbA4V//Bs8haKJL6dWp/X+qvVD3xdyJddAKIuK86w7oXIRjQRvfGbmjiBrAolBCYm
         8qhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=SzPukKl2CPx/8RlWz33HWqiKK+RNMTLLEn/EbDaTvis=;
        b=V6j5NEY5NOFUq3GMV8LSIjMXn8EdH64OUNT2pjxZv2UfZol6N2sG+OONOY9spCa3rF
         sn/THx6/zocNiELnvmFfWlxeuw7w9YYJbFCO/YoVkrsTfKlnjL7+tpgIKgvxasE4k0F5
         27Ze/IZ75LUY8c7mSsq/Y5xz4SrB38YNHzwqSvi2+BobtdZVgpZi2lNY6yrdG5LU5TRV
         lOqb8W5ztTqS3fb8DVYksRXHdzDFn7nCHvcfceyiAMJOxgYNPRUfRZgh+WRsTibE+lZN
         wWAM7+e6SMKeUrfhO1dBXEWhmDOnXJgHF4ch9YrU5aGsGioIfpkyER8aCdG8B8PxgQhW
         JD4Q==
X-Gm-Message-State: AGi0PuZu9n/Z1CUD5VLQzZSfm7TCV7M7njEKc56gEeh7RV3Qe1Fu9RpL
        HbizzC8S/XcLvtFGv19B+oPRDyRM
X-Google-Smtp-Source: APiQypLhY+kH5fGMg2AKSr01HZD9aCPRXfZMjLzRk04dE6bm4Iq1ZVIVqsgi/ODT8U1v4CNvfgBG9Q==
X-Received: by 2002:a17:90a:883:: with SMTP id v3mr2014025pjc.5.1588370377947;
        Fri, 01 May 2020 14:59:37 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id l6sm1542096pfl.128.2020.05.01.14.59.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 01 May 2020 14:59:37 -0700 (PDT)
Date:   Fri, 1 May 2020 14:59:36 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.14 000/117] 4.14.178-rc1 review
Message-ID: <20200501215936.GC44185@roeck-us.net>
References: <20200501131544.291247695@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200501131544.291247695@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 01, 2020 at 03:20:36PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.178 release.
> There are 117 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 03 May 2020 13:12:02 +0000.
> Anything received after that time might be too late.
> 
Build results:
	total: 171 pass: 171 fail: 0
Qemu test results:
	total: 405 pass: 394 fail: 11
Failed tests:
	ppc64:mac99:ppc64_book3s_defconfig:smp:initrd
	ppc64:mac99:ppc64_book3s_defconfig:smp:ide:rootfs
	ppc64:mac99:ppc64_book3s_defconfig:smp:sdhci:mmc:rootfs
	ppc64:mac99:ppc64_book3s_defconfig:smp:nvme:rootfs
	ppc64:mac99:ppc64_book3s_defconfig:smp:scsi[DC395]:rootfs
	ppc64:pseries:pseries_defconfig:initrd
	ppc64:pseries:pseries_defconfig:scsi:rootfs
	ppc64:pseries:pseries_defconfig:usb:rootfs
	ppc64:pseries:pseries_defconfig:sdhci:mmc:rootfs
	ppc64:pseries:pseries_defconfig:nvme:rootfs
	ppc64:pseries:pseries_defconfig:sata-sii3112:rootfs

Again, please drop "of: unittest: kmemleak on changeset destroy".

Guenter
