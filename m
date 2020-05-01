Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA7541C2037
	for <lists+stable@lfdr.de>; Sat,  2 May 2020 00:00:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727062AbgEAV6w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 17:58:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726045AbgEAV6w (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 May 2020 17:58:52 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02C91C061A0C;
        Fri,  1 May 2020 14:58:52 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id s18so5110465pgl.12;
        Fri, 01 May 2020 14:58:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=4P5Sh2Y2j29M4qrLIGaPMQlq6452gml9jxraLTTh9eE=;
        b=no0bNgmBeTEc2raLLB8YNM6RS1hxcnaxyjCUsjp+eo1kOC50zUI3LgsxIgZ1afzpyB
         UnqcVrALrNmykc1PGkqR4PVVDmiM52Gk5cTisHh2QHp6jt23dVLqQnEGgF1zRoyVyBMU
         qUrhoJZraT3tuDqe0M7/e+nIm1/w22Wg/c52/G/Ij/fhQRveTEypIgXM5rHjMsO+PjHy
         4OE9wqEo2CwBAyjKmJgLZqSu/lYN2UMiboEPbD/h7HB+y8lEj9zK7etxN3E+gdRNYh1t
         EbaTA8uc5wQcYYCzEv82rXj38JaayfVeyXlouwaRpE2ugwltYXMHTUwJr7gWSPoEP0z2
         YTHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=4P5Sh2Y2j29M4qrLIGaPMQlq6452gml9jxraLTTh9eE=;
        b=BTmi77zgP/Tcu4G861cXWn3mhv6nHo0N/FScRmGLzTnsPTvRg51IGk6Cu5F7or+L1Q
         68c3nkp0xUuYsW4pCetoB47+6tC5m2Jkxn3pLlEBxzCMe/YdkUwNHqaB3hoRVhBqGTpe
         4Q4HBIjFm1gs+WF8vOy0Abd7vWRehX3TN3QcOHIVo4UDz4KMvJXtR+kGCPVmuXWXEudH
         3EXBvN1EBtIngZrkJakSCNs9IUgnOpKUKD4+zIxzO9ZwaVZNfRbgvVTAqIlVVQs/5Dgd
         CcKUaRIIfho/UpYLKpFBHaR/YxuMuYUAPT+JX9Cq/rzb2tXGJcMcE1Li9c5Ag8ykAx7O
         iUJA==
X-Gm-Message-State: AGi0PuaRPP4HQJ4KZrv5PLdhEmIFVHmDt8qn/2p2B7iw7txVFHzt3nZ2
        O/p1CrQWgGo4EDSq7kKJ7O0=
X-Google-Smtp-Source: APiQypIJN9oF9WPL3VjNv4qhXGQxRCDGGIhufRm+F/+gsFiFMWhyi/32e7L1nMJ3MviFYp5m+lW32w==
X-Received: by 2002:a62:7c16:: with SMTP id x22mr5937580pfc.267.1588370331537;
        Fri, 01 May 2020 14:58:51 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id w69sm3055863pff.168.2020.05.01.14.58.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 01 May 2020 14:58:51 -0700 (PDT)
Date:   Fri, 1 May 2020 14:58:50 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.9 00/80] 4.9.221-rc1 review
Message-ID: <20200501215850.GB44185@roeck-us.net>
References: <20200501131513.810761598@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200501131513.810761598@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 01, 2020 at 03:20:54PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.221 release.
> There are 80 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 03 May 2020 13:12:02 +0000.
> Anything received after that time might be too late.
> 
Build results:
	total: 171 pass: 171 fail: 0
Qemu test results:
	total: 384 pass: 374 fail: 10
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

"of: unittest: kmemleak on changeset destroy" has to be dropped to fix
the problem.

Guenter
