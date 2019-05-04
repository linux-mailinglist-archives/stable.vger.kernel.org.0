Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC83113812
	for <lists+stable@lfdr.de>; Sat,  4 May 2019 09:18:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726178AbfEDHSf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 May 2019 03:18:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:47494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725802AbfEDHSf (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 4 May 2019 03:18:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E005A206DF;
        Sat,  4 May 2019 07:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556954314;
        bh=KjtIdOqgGdJRkpK539kaYm/XfWHQJNxowDI71iFyh04=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zynfTzrERwQ2d+YOgHuXK5YKpGnpkRJru55Yn+3GTl2D/ipka7IFpkKSozOSkew4I
         cu8ugxESTz/4SdQ8/Wl6ibUzvnVvV2sCNDG4bscjKFTW4M+4T2bM/MRFEP5W9aUSiT
         /57JgIM85amImI98v4NO5PC3cyImuet3LvShR6wM=
Date:   Sat, 4 May 2019 09:18:31 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/72] 4.19.39-stable review
Message-ID: <20190504071831.GA12815@kroah.com>
References: <20190502143333.437607839@linuxfoundation.org>
 <20190504065447.GA16530@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190504065447.GA16530@amd>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, May 04, 2019 at 08:54:47AM +0200, Pavel Machek wrote:
> On Thu 2019-05-02 17:20:22, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.19.39 release.
> > There are 72 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat 04 May 2019 02:32:17 PM UTC.
> > Anything received after that time might be too late.
> 
> These do not meet stable criteria afaict: (3-5... I see this is
> probably security bug; it would be good to mention in the preparation
> patches what is going on because otherwise it is tricky to understand).

I do not do "explain why specific patches are applied" because yes,
sometimes it is due to security issues that we know about.

> ?? 03/72] mm: make page ref count overflow check tighter and m -- not sure description is good enough; preparation for later changes?
> ?? 04/72] mm: add try_get_page() helper function -- adds unused function
> ?? 05/72] mm: prevent get_user_pages() from overflowing page r -- over
>   100 line limit and depedns on previous patches. get_gate_page() change
>   not in -rc?.. it is in -next.

These are all well-known as solving a public security issue, please see
lkml for the details, no need for you to "guess".

thanks for the review.

greg k-h
