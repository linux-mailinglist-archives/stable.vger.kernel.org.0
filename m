Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E2F9151F21
	for <lists+stable@lfdr.de>; Tue,  4 Feb 2020 18:18:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727443AbgBDRSV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Feb 2020 12:18:21 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:35205 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727440AbgBDRSV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Feb 2020 12:18:21 -0500
Received: by mail-pl1-f195.google.com with SMTP id g6so7537762plt.2;
        Tue, 04 Feb 2020 09:18:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=8WA4B8voYuCqjA49yDhyby9CytQRBltptTuc0mFVDB0=;
        b=i/TEcCQbDUGSSKGsElwHSq54Ei9p+UPPHAroRRiKhzyQcKb18av8K+Rws/gSW6lefp
         ApWRlFhfKkPziUStpASC8O+6Jmy9T14tm282XgoWAEVQVK5ha/Cgm5mA8AAt52KZk7Wq
         1+S2XxiBvQktBd4FwiX5vicwuWyS3VG9G4Xw9UdHM9uaxESqNpsUvt9uj+JMk/8R6eVY
         LtevVTzxFnna6IT7q3dFb0M8unbvxwpU/cgK59JCzsK0oV0FfqwtEs4tQe9ntEO8NVMT
         doOXbEr0/jH7M7inLObcPcOpolVIHCPPFWdodI8XxZZfGoii8/aQz1idRcXsoIkXzB99
         biHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=8WA4B8voYuCqjA49yDhyby9CytQRBltptTuc0mFVDB0=;
        b=gxioVCjNii9rQ+qCxfKSjiYYYu/o2JzKTSdBXBIHO/L4oN0bkZNbkKPBvI9HIymEAB
         mW6gI9hRT9SLKwiSoxC0Xn+B6q0HVj2LFrwDg4G/hQdDGlOt9bYwVtLB1xWOCGbFu8Tf
         EYKWgPxt7etwPNnqmaIX99p6gcK5bvhRszTiyCpx+x4SrOYKgKn8ECdyfzztYmuDReIR
         ex/CzfCjsz3dyTGG/Vdk9dJsPZfX/cw01smIrjurKsdmlOIskLXTrVRD+ttyLLK6sFl+
         pJyHVp8gn2bnBuuKCqvdJw1DeWKr8WE972desdyx+qiM8gjblSI2Uow/lNTC27TTuqP9
         OD4g==
X-Gm-Message-State: APjAAAVMyqPM+9p3W2gSEVsAq6gUqE0FjBZUG1iQhXpOjhVIPNEylAQe
        0YGQFX8E3/IUSHvSl/kwwUYMAFV7
X-Google-Smtp-Source: APXvYqzhgJb+zRV/6iVwZ+a2O3QT0RQujqiuzJyLoToCYMxIfvW/xtObYdGDNiW5LTDemh9ykMvVlw==
X-Received: by 2002:a17:90a:5d18:: with SMTP id s24mr51385pji.141.1580836700529;
        Tue, 04 Feb 2020 09:18:20 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d23sm24465383pfo.176.2020.02.04.09.18.18
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 04 Feb 2020 09:18:19 -0800 (PST)
Date:   Tue, 4 Feb 2020 09:18:18 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/53] 4.4.213-stable review
Message-ID: <20200204171818.GA10163@roeck-us.net>
References: <20200203161902.714326084@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200203161902.714326084@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 03, 2020 at 04:18:52PM +0000, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.213 release.
> There are 53 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 05 Feb 2020 16:17:59 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 170 pass: 167 fail: 3
Failed builds:
	arm:allmodconfig
	arm:omap2plus_defconfig
	arm:imx_v6_v7_defconfig
Qemu test results:
	total: 325 pass: 322 fail: 3
Failed tests:
	arm:kzm:imx_v6_v7_defconfig:nodrm:mem128:initrd
	arm:mcimx6ul-evk:imx_v6_v7_defconfig:nodrm:mem256:imx6ul-14x14-evk:initrd
	arm:mcimx6ul-evk:imx_v6_v7_defconfig:nodrm:sd:mem256:imx6ul-14x14-evk:rootfs

Errors as already reported.

Guenter
