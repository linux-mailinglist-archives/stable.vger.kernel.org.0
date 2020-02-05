Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8A5C15352A
	for <lists+stable@lfdr.de>; Wed,  5 Feb 2020 17:24:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726359AbgBEQYb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Feb 2020 11:24:31 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:39346 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726534AbgBEQYb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Feb 2020 11:24:31 -0500
Received: by mail-pf1-f195.google.com with SMTP id 84so1458928pfy.6;
        Wed, 05 Feb 2020 08:24:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=vW/tfpwzyWWkMpKU6Lyvn0d5pLCF5+H/aORn6raHEIc=;
        b=C8466oHR7IjuPqVnRwgw4cB0nRxpvX/Lr71L/qL5WnzCERx91rUPfqGhD2G5LhaGyH
         PAsUA0u07wYdYhobVkDSfIlhDcvvxJtoa2PlcH+pK5cHR8pIMYs+5e+cMXzgj6CP7hp5
         3+0HyV48NZoIE1ixMxVOfKKVWDIr/Rp69B0hdbC3Idna68fvQhbrthjVBaKOtjz8Fj8S
         1myAhRL4XTinM3CoC/3ErT9EYlQzazss6sluMr5CMUHzlIkjGDpOXku76nlfWNzrMKHT
         GIbH2bmSDomPN+Gk9hGy0PBVjaGF2lwloeM++QPYxFD39HZNU5cRCGB/JdxxUr/o5JzT
         2Nww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=vW/tfpwzyWWkMpKU6Lyvn0d5pLCF5+H/aORn6raHEIc=;
        b=dnT6UW2aJy3p/MvsKJMsHn1808Od3gO+RFtaVe3Y5Xp9FqUJuJD2GVVQviy+dMqOT2
         m6nSw32Bz5BKj2U1v/eHlmc+oAOHelAA1+VrESCU3jRBO2/4j+oBeHsgYSh7r+yH3lLh
         09rsrh2e2uqifie4WfCwrUJsZJ0ZAUZGF5QUI/fdaW6uG8Tfky8PzmD0aXZMUcapOddA
         y3945/FI8nGAZAN5/BHPOmn8wpwOtf+DDt2UNJ0AdSW5JlG9FcAZEeYz1rLrtPRHD8Gr
         To7DsHz5Irm42CkIhkDtppIPRj1rXUcYc/iXcdjrTKyHuz+V1OqbrEe2fA7ermHGT5Pr
         V6HQ==
X-Gm-Message-State: APjAAAX1rMQ7tFO4fkBnKE5JIhqiWiBTTf4hluBjb2EFKK7Sv/vubfij
        XrtMyutxlPPguRKCnj6HJd8=
X-Google-Smtp-Source: APXvYqyrnw4Nw+QSCWRTAQA4RVmt+Q4OIrnUYg1ZN28Fv2wXKYg/qluDCGNBlqZLAZfXqdhPD34fKQ==
X-Received: by 2002:a62:e10b:: with SMTP id q11mr18975440pfh.48.1580919870973;
        Wed, 05 Feb 2020 08:24:30 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id a22sm31351602pfk.108.2020.02.05.08.24.29
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 05 Feb 2020 08:24:30 -0800 (PST)
Date:   Wed, 5 Feb 2020 08:24:29 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/90] 5.4.18-stable review
Message-ID: <20200205162429.GB25403@roeck-us.net>
References: <20200203161917.612554987@linuxfoundation.org>
 <9a5a92f2-6e28-a9ab-a851-8d7e56482df6@roeck-us.net>
 <20200205151357.GB1236691@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200205151357.GB1236691@kroah.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 05, 2020 at 03:13:57PM +0000, Greg Kroah-Hartman wrote:
> On Tue, Feb 04, 2020 at 06:37:38AM -0800, Guenter Roeck wrote:
> > On 2/3/20 8:19 AM, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 5.4.18 release.
> > > There are 90 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Wed, 05 Feb 2020 16:17:59 +0000.
> > > Anything received after that time might be too late.
> > > 
> > 
> > Building i386:allyesconfig ... failed
> > Building i386:allmodconfig ... failed
> > --------------
> > Error log:
> > In file included from arch/x86/kernel/pci-dma.c:2:
> > include/linux/dma-direct.h:29:20: error: conflicting types for 'dma_capable'
> >    29 | static inline bool dma_capable(struct device *dev, dma_addr_t addr, size_t size,
> >       |                    ^~~~~~~~~~~
> > In file included from include/linux/dma-direct.h:12,
> >                  from arch/x86/kernel/pci-dma.c:2:
> > arch/x86/include/asm/dma-direct.h:5:6: note: previous declaration of 'dma_capable' was here
> >     5 | bool dma_capable(struct device *dev, dma_addr_t addr, size_t size);
> 
> Ok, I think this is now resolved with a patch that Sasha added.
> 
> I have pushed out a -rc4 that _should_ build and boot properly.
> 
The i386 build still fails with v5.4.17-99-gbd0c6624a110 (-rc4).

Guenter
