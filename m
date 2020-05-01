Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3BE31C202E
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 23:59:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726366AbgEAV5v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 17:57:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726318AbgEAV5u (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 May 2020 17:57:50 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D546BC061A0C;
        Fri,  1 May 2020 14:57:50 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id x77so2148706pfc.0;
        Fri, 01 May 2020 14:57:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=DJ7xsGG+aZH2HntpJQzEkkM1lh/twV6qWhYRNUXLISw=;
        b=DH+bf7rqYVrmie/L/B3nneFaSvPORnBGd6QbCqk9hL6p56989o07CKK8JhVUekdk9D
         LmmxCZw0wc2mWl3qebaBE3SPSbE7JVYzc2RjLvgeZv5Mdq0NH4EWenmcmxxyy3I2xFES
         P6ZqWx5o4CauVS6CnRmzyboFOI6s6X51sb26XbfBmlDjvHB2WRdcD+GgTYOn8cNHHO7a
         t8Kb5A9P3AthHu7S9aZUGyjPSUWYIAzk3kxJfZve6inq43oUI3ZHHcpaQlBV38rOjsl2
         y6NlKta3CVtIzU192qpMrfMOCziSXLh+/L1yZCyluyFhP3CVD56cKddZeVGT+mfGmR40
         WADw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=DJ7xsGG+aZH2HntpJQzEkkM1lh/twV6qWhYRNUXLISw=;
        b=KdYCXY6/wBfacgXr7NNSSTywXZakJ+NMUOjGau2SCn8KxUmDYuH8iZ9dwB1bzLjM7Q
         3NS1A+IOf+l0/hv4zZAqd47TAZ/Fm1p1ygGupLqxJF5UalvOg2qbfaPx4ItFfQDfcFYo
         o94jQKuvA7yayIcH/avBLOZCk9LO7PTDbmHR1zfHvigSPEHSS3KioF6UAGA7I+vmUj8n
         VUUsEW3IyM7z/nAqGx2nZOrNC96Ki4Z0CyzHPttp4CfUxoaFWOzvxOofHLDQcIY5U1M0
         O0dD99mi8E+lCQAc7vpMUihZOTnA/hRSgmmkSlZYOh50qLkiZgzutNOqhyNjLsid2etX
         zlrw==
X-Gm-Message-State: AGi0PubYaLZ4tDdBHmKHJE7H2HlWoQOpCl5KIbCjituHCP25i42gBKvv
        8jq5oDlCL8CtQ+j9gDRSF2I=
X-Google-Smtp-Source: APiQypKs4frHTCw/6OUF6kNtsir7IfdGTcSXaUmV8XCNsKa45E1NdnmyPEZMR6eI4dFNU8swPpOxKA==
X-Received: by 2002:aa7:8091:: with SMTP id v17mr6163921pff.93.1588370270097;
        Fri, 01 May 2020 14:57:50 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id z190sm3049628pfz.84.2020.05.01.14.57.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 01 May 2020 14:57:48 -0700 (PDT)
Date:   Fri, 1 May 2020 14:57:47 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/70] 4.4.221-rc1 review
Message-ID: <20200501215747.GA44185@roeck-us.net>
References: <20200501131513.302599262@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200501131513.302599262@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 01, 2020 at 03:20:48PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.221 release.
> There are 70 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 03 May 2020 13:12:02 +0000.
> Anything received after that time might be too late.
> 
Build results:
	total: 169 pass: 169 fail: 0
Qemu test results:
	total: 335 pass: 325 fail: 10
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

Patch "of: unittest: kmemleak on changeset destroy" results in UAF and must
be reverted to fix the problem (this had sneaked in earlier and was dropped
at least once).

Guenter
