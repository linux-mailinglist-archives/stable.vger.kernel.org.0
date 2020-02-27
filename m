Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59B6A1728CD
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 20:39:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729835AbgB0TjB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 14:39:01 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:45680 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729766AbgB0TjB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Feb 2020 14:39:01 -0500
Received: by mail-pg1-f195.google.com with SMTP id m15so191882pgv.12;
        Thu, 27 Feb 2020 11:39:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=roPL+TIfZXnizgw/7azYAkPYosZjjdePOLhyXpL+spM=;
        b=GU/SLT0k6RNOlJjIG+fSyVJVZdhCNM0ue3amW8ai3qh1JVlZky+XNa0P2UK+JB1ZNG
         xZ0KpZe5m2LpeNn4wMAgoMHSd/Tgb4BBPNrUtVrlWJhjO8fmeeKdL1hrmDqHcX/BgG3d
         ScNlda7iVna6RxOhMfYl1P8tMhG7zQYgDFe/KLRCaoyQ9cwbDP5Rm1tSLd8PwLQaJRuE
         ondl/v9NrhacEr7EGWv07myML7oaykcjiKCtaRrhlaP8PN2xtcN+ydkirwwgGGd/9WDf
         5c7a5r1o1W9HLAnTLHMghDX7L0h7A/Vjd40urjkOqpm6uSN6aKn8NwLypTPagPNFRVMS
         TZmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=roPL+TIfZXnizgw/7azYAkPYosZjjdePOLhyXpL+spM=;
        b=DtMeD1VlHXE7yH/QtdF8hKQLNk+Oh/L+xTfkh3IiK3fbWlb13G7ZbYVJTMXLeGw6p7
         LIpobatZSg9STg++o2uiAbM991IS2g4O+fvLcJmKGWxAT7kxfbL0VclBP7LoE26HfadU
         ydIDNQL+JeWAH96LpG80AcdcAE+tfGAtnEmsap/qSYYYn89hOldg8ok6qJ2ZneO/nWvg
         vO/sw2WO8bWzYDgtPtQ/tMxXOaLlaAG6W17/+G80XfkSnHWSVoUC3BKibocYkts3aKCe
         BYufeb0cXWwMaZoPEioVdfoYnlH9YYfvfH9EkVYV1JySofxqdtEpqqPAdQhDSbkq3Ewt
         iO4A==
X-Gm-Message-State: APjAAAUebWZUQ5dcz6YEhtkQYTuQ4fdX4KonEblx5IbKotl820wHzKTH
        CtyLOA0o4lR+5wlmhQ789UI=
X-Google-Smtp-Source: APXvYqwv35MbgQvAOHbr7kYWDxTd0JGZdWlq9UxdbJF/JNZbHGVFyI6Lm2tNg5k//1J5J02jYxf1JA==
X-Received: by 2002:a63:505b:: with SMTP id q27mr878087pgl.39.1582832339934;
        Thu, 27 Feb 2020 11:38:59 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id z10sm7200800pgz.88.2020.02.27.11.38.59
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 27 Feb 2020 11:38:59 -0800 (PST)
Date:   Thu, 27 Feb 2020 11:38:58 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.9 000/165] 4.9.215-stable review
Message-ID: <20200227193858.GB31847@roeck-us.net>
References: <20200227132230.840899170@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200227132230.840899170@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 27, 2020 at 02:34:34PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.215 release.
> There are 165 patches in this series, all will be posted as a response
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
	total: 375 pass: 361 fail: 14
Failed tests:
	ppc64:mac99:ppc64_book3s_defconfig:smp:nvme:rootfs
	ppc64:pseries:pseries_defconfig:initrd
	ppc64:pseries:pseries_defconfig:scsi:rootfs
	ppc64:pseries:pseries_defconfig:usb:rootfs
	ppc64:pseries:pseries_defconfig:sdhci:mmc:rootfs
	ppc64:pseries:pseries_defconfig:nvme:rootfs
	ppc64:pseries:pseries_defconfig:little:initrd
	ppc64:pseries:pseries_defconfig:little:scsi:rootfs
	ppc64:pseries:pseries_defconfig:little:usb:rootfs
	ppc64:pseries:pseries_defconfig:little:scsi[MEGASAS]:rootfs
	ppc64:pseries:pseries_defconfig:little:scsi[FUSION]:rootfs
	ppc64:pseries:pseries_defconfig:little:sdhci:mmc:rootfs
	ppc64:pseries:pseries_defconfig:little:nvme:rootfs
	ppc64:powernv:powernv_defconfig:initrd

Failures as already reported.

Guenter
