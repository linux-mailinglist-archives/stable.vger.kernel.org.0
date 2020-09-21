Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 347AD272BB2
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:21:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727958AbgIUQVh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:21:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:49200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726795AbgIUQVh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:21:37 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 257CB206BE;
        Mon, 21 Sep 2020 16:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600705296;
        bh=XWFVUx2G58FZvzVQE5KNasqBmTEJwzkjqe9m3960V2k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=q3aDwKPA16sbvKGWVB3wreOuZ/i0SPRHqNrdMexUjLPznbd7242QdrXvC6ymKKsB/
         BUt7+IQKPBONdw08wSTPdNNzamovQlwYnnHyDPTxyEvlBcOxVmMD/RwSfYfH9gfkvO
         tp9qpQW0QkMM3oDUuIebk8dFsSEjOVCdXq37D1gI=
Date:   Mon, 21 Sep 2020 18:21:59 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Cc:     stable@vger.kernel.org,
        Jaska Uimonen <jaska.uimonen@linux.intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH] ASoC: SOF: intel: hda: support also devices with 1 and 3
 dmics
Message-ID: <20200921162159.GA1260133@kroah.com>
References: <20200918161533.166533-1-pierre-louis.bossart@linux.intel.com>
 <20200921161024.GB1096614@kroah.com>
 <399fe98f-5577-6616-8539-885cbc89be1b@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <399fe98f-5577-6616-8539-885cbc89be1b@linux.intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 21, 2020 at 11:18:47AM -0500, Pierre-Louis Bossart wrote:
> 
> 
> On 9/21/20 11:10 AM, Greg KH wrote:
> > On Fri, Sep 18, 2020 at 11:15:33AM -0500, Pierre-Louis Bossart wrote:
> > > From: Jaska Uimonen <jaska.uimonen@linux.intel.com>
> > > 
> > > [ Backported from Upstream commit 3dca35e35b42b3405ddad7ee95c02a2d8cf28592]
> > 
> > There is no such commit in Linus's tree :(
> 
> no such commit yet, it's in Mark Brown's tree and should be in 5.10
> 
> https://lore.kernel.org/alsa-devel/20200825235040.1586478-4-ranjani.sridharan@linux.intel.com/
> 
> I must admit I didn't know how to tweak the information between brackets.
> 
> do you want me to remove the 'Upstream' comment and resend?

I can't take anything that is not already in Linus's tree, so we need to
wait until it hits there, right?

thanks,

greg k-h
