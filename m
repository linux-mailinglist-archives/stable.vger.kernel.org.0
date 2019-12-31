Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 503EE12DA07
	for <lists+stable@lfdr.de>; Tue, 31 Dec 2019 17:05:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727054AbfLaQFV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Dec 2019 11:05:21 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:42988 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726060AbfLaQFV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Dec 2019 11:05:21 -0500
Received: by mail-pg1-f195.google.com with SMTP id s64so19677169pgb.9;
        Tue, 31 Dec 2019 08:05:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=dZaUCr3Um0xyE02aIvLQxiiEoVv7ulqi8PdjiTC5+V4=;
        b=kvSE8e04W687RV4AR3dk1U2zNYKnv9Xyc1mwBFE2DcPg5wlfeQ0Pmawn2VeXcM6msA
         9CmhHV9b7LalazQrjS2DmQerMXCxdlhNX4g3mJE3WCOkzuKb+5X8ZYLCNYPKI0B9JIqa
         OWid8hgaFRb6qYduW5kPS3jbuSZAV7+lI9IrwMYtpVBpsi6JzCx1jgkHVdULaAWMxDaD
         gzgymDLcMbaCArnTkXhVIC/Bt5Itel7SYGpsiCVZs6faxaWtAhNIcIlzEcnuqxIFfT24
         AZtUbk9gBEfNdc17chwPKry/pmkPkiW2DD0O0VR7s5AEn2ANJHRp2ftXZw6eKD692Kq/
         c3Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=dZaUCr3Um0xyE02aIvLQxiiEoVv7ulqi8PdjiTC5+V4=;
        b=oWZEy2qO/qyFr5vlI9oUUEn2o4QooNqbsCaAaZWsUdHncVCYMokBkgZlfu3C9Bs+XV
         Ybbl8nhEkUhj4SIn51XoQSHQok+5JoU2WPnnbRlafWpPOhH0yLzDA9qLBAPIwUYybsWH
         vYQthQO48GfuD9oFU3dN26RvOQO+kW8Ss3sR4LeO7frJBGFq3d3yHXG2nF2ty/HDui3e
         ai5NMaBjYpykf1XMBoxrHDu7c9NXbZE+TOncN5wgltfAH0X6KFWK4npyMabj3OyHkiO+
         gb9kGYRUEfKzDCpfbjMXAoYIrEwkR+lXkWTEt7v1Uegkp0+lF1j4WMamWxXzi75jjsPA
         jshQ==
X-Gm-Message-State: APjAAAWrP55pjFMmQMfgciKgunPwjmEx6eC/O9bKaGmG9va1BpNuOw4Q
        Q0OsA6zbYSuyUHTsIqB9kaI=
X-Google-Smtp-Source: APXvYqwkStj6MF1s721UKZMK4XJ6CYf9/POYglgHpWgNUchUnTrrKuk13YKoFTI3jplt2ITu/gdWjw==
X-Received: by 2002:aa7:855a:: with SMTP id y26mr75155414pfn.175.1577808320686;
        Tue, 31 Dec 2019 08:05:20 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id g18sm53489176pfi.80.2019.12.31.08.05.20
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 31 Dec 2019 08:05:20 -0800 (PST)
Date:   Tue, 31 Dec 2019 08:05:19 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 000/219] 4.19.92-stable review
Message-ID: <20191231160519.GB11542@roeck-us.net>
References: <20191229162508.458551679@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191229162508.458551679@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Dec 29, 2019 at 06:16:42PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.92 release.
> There are 219 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 31 Dec 2019 16:17:25 +0000.
> Anything received after that time might be too late.

For -rc2:

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 381 pass: 376 fail: 5
Failed tests:
	ppc64:mac99:ppc64_book3s_defconfig:smp:initrd
	ppc64:mac99:ppc64_book3s_defconfig:smp:ide:rootfs
	ppc64:mac99:ppc64_book3s_defconfig:smp:sdhci:mmc:rootfs
	ppc64:mac99:ppc64_book3s_defconfig:smp:nvme:rootfs
	ppc64:mac99:ppc64_book3s_defconfig:smp:scsi[DC395]:rootfs

Bug-for-bug compatible with mainline. That makes me wonder if I should
stop testing those ppc images instead of being annoyed by the failures.
Thoughts ?

Guenter
