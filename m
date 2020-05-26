Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ACAF1E1F95
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 12:25:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731859AbgEZKZr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 06:25:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:48664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726944AbgEZKZq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 06:25:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 475FC20776;
        Tue, 26 May 2020 10:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590488744;
        bh=FRo6WyVk4Pkdau+4M/ISA4WV0B0bW5RxwHZI5St8oGY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2tXcCYFmSZ/wpWZZ3owHULhfaLoDG+BB0eNRoPDI5tTu8N2r0vpV9c6dmzqNUfH3h
         tX9w9GNdTve5Zvr6SZP6yh7+29JvblLDUDYeYAPOekIUJng9+Oece19lxrvCBZ0Xqx
         KjKPFq43XoZpCs0b2hR5qfDus2SyYcmTjMeaT8NM=
Date:   Tue, 26 May 2020 12:25:42 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Dakshaja Uppalapati <dakshaja@chelsio.com>
Cc:     hch@lst.de, sagi@grimberg.me, stable@vger.kernel.org,
        bharat@chelsio.com, nirranjan@chelsio.com
Subject: Re: nvme blk_update_request IO error is seen on stable kernel 5.4.41.
Message-ID: <20200526102542.GA2772976@kroah.com>
References: <20200521140642.GA4724@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200521140642.GA4724@chelsio.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 21, 2020 at 07:36:43PM +0530, Dakshaja Uppalapati wrote:
> Hi all,
> 
> Issue which is reported in https://lore.kernel.org/linux-nvme/CH2PR12MB40050ACF
> 2C0DC7439355ED3FDD270@CH2PR12MB4005.namprd12.prod.outlook.com/T/#r8cfc80b26f0cd
> 1cde41879a68fd6a71186e9594c is also seen on stable kernel 5.4.41. 

What issue is that?  Your url is wrapped and can not work here :(

> In upstream issue is fixed with commit b716e6889c95f64b.

Is this a regression or support for something new that has never worked
before?

> For stable 5.4 kernel it doesn’t apply clean and needs pulling in the following
> commits. 
> 
> commit 2cb6963a16e9e114486decf591af7cb2d69cb154
> Author: Christoph Hellwig <hch@lst.de>
> Date:   Wed Oct 23 10:35:41 2019 -0600
> 
> commit 6f86f2c9d94d55c4d3a6f1ffbc2e1115b5cb38a8
> Author: Christoph Hellwig <hch@lst.de>
> Date:   Wed Oct 23 10:35:42 2019 -0600
> 
> commit 59ef0eaa7741c3543f98220cc132c61bf0230bce
> Author: Christoph Hellwig <hch@lst.de>
> Date:   Wed Oct 23 10:35:43 2019 -0600
> 
> commit e9061c397839eea34207668bfedce0a6c18c5015
> Author: Christoph Hellwig <hch@lst.de>
> Date:   Wed Oct 23 10:35:44 2019 -0600
> 
> commit b716e6889c95f64ba32af492461f6cc9341f3f05
> Author: Sagi Grimberg <sagi@grimberg.me>
> Date:   Sun Jan 26 23:23:28 2020 -0800
> 
> I tried a patch by including only necessary parts of the commits e9061c397839, 
> 59ef0eaa7741 and b716e6889c95. PFA.
> 
> With the attached patch, issue is not seen.
> 
> Please let me know on how to fix it in stable, can all above 5 changes be 
> cleanly pushed  or if  attached shorter version can be pushed?

Do all of the above patches apply cleanly?  Do they need to be
backported?  Have you tested that?  Do you have such a series of patches
so we can compare them?

The patch below is not in any format that I can take it in.  ALso, 95%
of the times we take a patch that is different from what is upstream
will have bugs and problems over time because of that.  So I always want
to take the original upstream patches instead if at all possible.

So I need a lot more information here in order to try to determine this,
sorry.

thanks,

greg k-h
