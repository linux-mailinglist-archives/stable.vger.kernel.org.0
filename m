Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C77C1DB858
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 22:35:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392669AbfJQUfE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Oct 2019 16:35:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:56468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391182AbfJQUfE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Oct 2019 16:35:04 -0400
Received: from localhost (unknown [104.132.0.109])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7EAF520872;
        Thu, 17 Oct 2019 20:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571344503;
        bh=OI9A1yrHyosZVM/tf75VWNjxnmTQlKe1SAKlU6H8ogU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zr7CxEd7yJPO4Xv5/78Iru46ZIrZaUcfxVbfQQGs1Ckn76N+youieobNzLI5Fe27b
         WDmhMvwPiQquAuKsnmawukhLQHQqeNMNf7basacqMtRnGrRp0pgLPduJg1iPtzRQaq
         t2840dsj4xpoSmPouABJwfuJ4LvvGMbU6A4tJEYQ=
Date:   Thu, 17 Oct 2019 13:35:02 -0700
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Didik Setiawan <ds@didiksetiawan.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.3 000/112] 5.3.7-stable review
Message-ID: <20191017203502.GA1104591@kroah.com>
References: <20191016214844.038848564@linuxfoundation.org>
 <20191017183048.GA9506@thinkpad-e420s>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191017183048.GA9506@thinkpad-e420s>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 18, 2019 at 01:30:48AM +0700, Didik Setiawan wrote:
> On Wed, Oct 16, 2019 at 02:49:52PM -0700, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.3.7 release.
> > There are 112 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri 18 Oct 2019 09:43:41 PM UTC.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.3.7-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.3.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
>  
> Compiled, booted, and no regressions found on my x86_64 system.

Wonderful, thanks for testing all of these and letting me know.

greg k-h
