Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0230A4447D1
	for <lists+stable@lfdr.de>; Wed,  3 Nov 2021 18:59:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbhKCSCF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Nov 2021 14:02:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:58864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229558AbhKCSCE (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Nov 2021 14:02:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C1F9960EDF;
        Wed,  3 Nov 2021 17:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635962368;
        bh=wSPv/KPHqTG4DTYCHSbxtNfK7yLnRw5I48paglxvGXk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wybcj3pBTSXIRVNBlyOkCZ/m0xi1O+vML3IutxfblkcTwLp9Q3FTIO/CxjiKgxdMh
         LjnwDl09n1aVY7l4yKGPvNVqd5HbChqEj4hYKfPv1HeNKu15vInw25o8xveraY0ngr
         GgkeuJ1U9ClH3t7JHASeyYwANLFHbTacb7d5H9yw=
Date:   Wed, 3 Nov 2021 18:59:25 +0100
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     "Marciniszyn, Mike" <mike.marciniszyn@cornelisnetworks.com>
Cc:     "Dalessandro, Dennis" <dennis.dalessandro@cornelisnetworks.com>,
        "ivansprundel@ioactive.com" <ivansprundel@ioactive.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] IB/qib: Protect from buffer overflow in
 struct" failed to apply to 4.14-stable tree
Message-ID: <YYLN/RXehdox7308@kroah.com>
References: <163559866445226@kroah.com>
 <CH0PR01MB7153A85CF46D541FA76F1F95F28C9@CH0PR01MB7153.prod.exchangelabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CH0PR01MB7153A85CF46D541FA76F1F95F28C9@CH0PR01MB7153.prod.exchangelabs.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 03, 2021 at 03:25:39PM +0000, Marciniszyn, Mike wrote:
> > From: gregkh@linuxfoundation.org <gregkh@linuxfoundation.org>
> > Sent: Saturday, October 30, 2021 8:58 AM
> > To: Marciniszyn, Mike <mike.marciniszyn@cornelisnetworks.com>;
> > Dalessandro, Dennis <dennis.dalessandro@cornelisnetworks.com>;
> > ivansprundel@ioactive.com; jgg@nvidia.com
> > Cc: stable@vger.kernel.org
> > Subject: FAILED: patch "[PATCH] IB/qib: Protect from buffer overflow in
> > struct" failed to apply to 4.14-stable tree
> > 
> > 
> > The patch below does not apply to the 4.14-stable tree.
> > If someone wants it applied there, or to any other stable or longterm tree,
> > then please email the backport, including the original git commit id to
> > <stable@vger.kernel.org>.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> 
> This patch requires a backport of upstream commit:
> 
> 829ca44ecf60 ("IB/qib: Use struct_size() helper")
> 
> That commit needs to me modified to include linux/overflow.h.
> 
> The overflow patch then picks clean after that modified patch is present.
> 
> How do you want to see that expressed in patches?

Can you please send a patch series for this that I can apply?

thanks,

greg k-h
