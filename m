Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EEE31F9DD
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 20:24:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726412AbfEOSYb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 14:24:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:33040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726084AbfEOSYa (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 14:24:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB47F2084F;
        Wed, 15 May 2019 18:24:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557944670;
        bh=SJIrTJOHyIs6jQxk3NaubUkLolNMb/rtvEVrlNlQ0tY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lAfxWrVZEqwKU/doi9c4XivQH5pzJDxevn4R1xBgwzs8RWag+C5Qp7TsOfVCQiQX+
         njgEHSemuGywjDEu9EDGYVQvyNxZQhDL7IRQhLDU2rKgrrw/hpj+f83pjIDgj5AAjS
         8MktqjLToN4G1qBmRQKE8Z/yAwg7UuxTZAbJiOuk=
Date:   Wed, 15 May 2019 20:24:27 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.14 000/115] 4.14.120-stable review
Message-ID: <20190515182427.GA26029@kroah.com>
References: <20190515090659.123121100@linuxfoundation.org>
 <20190515181705.GB16742@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190515181705.GB16742@roeck-us.net>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 15, 2019 at 11:17:05AM -0700, Guenter Roeck wrote:
> On Wed, May 15, 2019 at 12:54:40PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.14.120 release.
> > There are 115 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri 17 May 2019 09:04:39 AM UTC.
> > Anything received after that time might be too late.
> > 
> 
> mips:malta_defconfig, parisc:defconfig with
> CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=n:
> 
> In file included from crypto/testmgr.c:54:0:
> crypto/testmgr.h:16081:4: error:
> 	'const struct cipher_testvec' has no member named 'ptext'
> crypto/testmgr.h:16089:4: error:
> 	'const struct cipher_testvec' has no member named 'ctext'
> 
> and several more. Commit c97feceb948b6 ("crypto: testmgr - add AES-CFB tests")
> [upstream commit 7da66670775d201f633577f5b15a4bbeebaaa2b0] is the culprit -
> aplying it to v4.14.y would require a backport.

Already dropped.  I'll push out a -rc2 as you aren't the only one that
hit this...

thanks,

greg k-h
