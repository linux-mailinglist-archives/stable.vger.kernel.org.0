Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3CB344DFA0
	for <lists+stable@lfdr.de>; Fri, 12 Nov 2021 02:15:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234605AbhKLBRz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Nov 2021 20:17:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbhKLBRz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Nov 2021 20:17:55 -0500
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40020C061766;
        Thu, 11 Nov 2021 17:15:05 -0800 (PST)
Received: by mail-oi1-x22f.google.com with SMTP id n66so14860318oia.9;
        Thu, 11 Nov 2021 17:15:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jfEeNpLc8SMxrQlinkfOFct9tI+arJ3WA5GsEwiIOMQ=;
        b=E5JaZN8206rtQpmFg+3Gd3+8Rwm+U+i1F2zazsTXLr2pd/Mw3DuY+Bmvt2qMvcIvul
         qhkno5Zq1Y2GG/fAzQaItGm2y7mzNIcE6qvTmVTZa+w+wjChM/vtn/zfele9IHsEzdfh
         fSREs6JneuvSGIMPJS7i9xXjKpM4FqfC+Vc7EYJZM7cz13OkD2gM3673MQ4+RS8WgMle
         YvGYfh3XhBHEamQpMEY45It3RLTpSQHGRex+vkJjNFvHMtkDT88pht1pZx/e9JXT1nr+
         sSCBeTTj+HJy7A0FMTvWKvnrB0zCHTc8t0QZouqSg6AVriGPsQuOc32PqnNLsw6YjZKL
         xBlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=jfEeNpLc8SMxrQlinkfOFct9tI+arJ3WA5GsEwiIOMQ=;
        b=dJChnto44qrhac3tE8d/rAgFFUQJmsCZMZrDA15iMNBYtO3d6rZrj1PZHV/1yKBNtG
         q/buwT2IWHoJrhwL9Cf2y3HrF1LYz+n03SBGYcAywH+gzSEEyV9EkY8G2jzmW/AShDPJ
         s7F5vnc+SQ4TNJD3h8tpV8VqekD8B0X49E1PZwc3XXT6/Fy4sH84nsL/Z0yFN61469z/
         zKUnlsTsDreYLcFlE90aW8/W/J7cjumMU5wQRs382Kskg7lhaO2ly++Q5O6qbXI9b2UC
         olFMT26o2xm4z7QX/Tsn04OV7Y74kTgQs9vC3b/qtTTEvkBsANxeZAdU02A7L63XCRx7
         T8wA==
X-Gm-Message-State: AOAM532rZ6VoWoNi1I/azx/lxmm4eecNTTyGzqFS/APaHq5055iuqEFI
        V3X4XIqjwoV2WANnt41VMgA=
X-Google-Smtp-Source: ABdhPJyxLMYaFTDHsN8FjbAv+fejnwKszCxkQWM21Qv679hAQxY7C3VWyi+c3gll0MOLED0eMRDqZA==
X-Received: by 2002:a05:6808:3b7:: with SMTP id n23mr9935998oie.160.1636679704581;
        Thu, 11 Nov 2021 17:15:04 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id m12sm921212ots.59.2021.11.11.17.15.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 17:15:03 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 11 Nov 2021 17:15:01 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/21] 5.10.79-rc1 review
Message-ID: <20211112011501.GA2588851@roeck-us.net>
References: <20211110182002.964190708@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211110182002.964190708@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 10, 2021 at 07:43:46PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.79 release.
> There are 21 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 12 Nov 2021 18:19:54 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 474 pass: 469 fail: 5
Failed tests:
	ppc64:powernv:powernv_defconfig:smp2:nvme:net,i82559a:rootfs
	ppc64:powernv:powernv_defconfig:usb-xhci:net,i82562:rootfs
	ppc64:powernv:powernv_defconfig:scsi[MEGASAS]:net,i82557a:rootfs
	ppc64:powernv:powernv_defconfig:smp2:sdhci:mmc:net,i82801:rootfs
	ppc64:powernv:powernv_defconfig:mtd32:net,rtl8139:rootfs

Reverting commit 8615ff6dd1ac ("mm: filemap: check if THP has hwpoisoned
subpage for PMD page fault") fixes the problem.

Guenter
