Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E16D8187E2D
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 11:21:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbgCQKVq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 06:21:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:51808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725730AbgCQKVq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 06:21:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E6DD20658;
        Tue, 17 Mar 2020 10:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584440504;
        bh=IMZu9NW9T51LGVbw8l51sy1mY44amIGPuSt80n7+izA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=M5G6mrx5uKYGjqDzvCTp9kE4VA/EMMNbOXlGFBC2D/3A5pcpL83RkRYB9+OpAJFwO
         MIh/aUYkWVsVmrnb5sxsAMIV3Eu1TcxOLYuItFqGD/XsWrz+3q51OQdhO2UobjZj6f
         p297frjvt1SJShQchI/yGr4/MjjsGWDq86yTEbH4=
Date:   Tue, 17 Mar 2020 11:21:41 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Dan Moulding <dmoulding@me.com>
Cc:     luciano.coelho@intel.com, sashal@kernel.org,
        stable@vger.kernel.org, stsp@stsp.name
Subject: Re: [PATCH 5.4 61/90] iwlwifi: mvm: fix NVM check for 3168 devices
Message-ID: <20200317102141.GB1130294@kroah.com>
References: <20200205093102.GB1164405@kroah.com>
 <20200313151300.18957-1-dmoulding@me.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200313151300.18957-1-dmoulding@me.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 13, 2020 at 09:13:00AM -0600, Dan Moulding wrote:
> On Wed, Feb 05 Feb 2020 at 09:31:02AM +0000, Greg KH wrote:
> >On Tue, Feb 04, 2020 at 02:01:57PM -0700, Dan Moulding wrote:
> >> I believe this commit (upstream commit
> >> b3f20e098293892388d6a0491d6bbb2efb46fbff) introduced a regression that
> >> causes the driver to fail to initialize for Intel 3168 devices. A
> >> patch for the regression has been submitted to the linux-wireless
> >> mailing list here:
> >>
> >> https://patchwork.kernel.org/patch/11353871/
> >>
> >> I would suggest either not including b3f20e0982 in the next v5.4.x
> >> stable release, or also applying the above patch, to avoid introducing
> >> a regression for users of the v5.4 series. The above patch is also
> >> needs inclusion in the v5.5.x series, as the regression is already
> >> present there.
> >
> >Now dropped from all trees.  Can you send us an email with the git
> >commit id of the fix when it lands in Linus's tree so we remember to
> >pick both of these up?
> >
> >thanks,
> >
> >greg k-h
> 
> The above fix has been merged to Linus's tree and needs to be
> backported to linux-5.5.y.
> 
> Commit a9149d243f259ad8f02b1e23dfe8ba06128f15e1.

Looks like it has already been queued up, thansk!

greg k-h
