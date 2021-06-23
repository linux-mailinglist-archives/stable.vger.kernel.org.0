Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F9723B1CEE
	for <lists+stable@lfdr.de>; Wed, 23 Jun 2021 16:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231229AbhFWO5h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Jun 2021 10:57:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:33718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231187AbhFWO5g (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 23 Jun 2021 10:57:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 108506102A;
        Wed, 23 Jun 2021 14:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624460118;
        bh=ETecJZBPOe24uQwnVE7Ls/Srn2CzCagDRXRWeoVp8ZQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Np9oG6k4yymFKQEiHtHU2Fuj2Xqj4AN13cL+vZGxt6Ak3xgCa5hBqTAMvxEW49Fwb
         rR7ClgW5+WKSZZiczlNpmcVQ015U0XUwa8tmqm6UqPxhmtZQlesww8gC4K/KmGYKep
         1KMFZuAuxGxirj/uG5BspPDnCqvdfSx7NviA+8WI=
Date:   Wed, 23 Jun 2021 16:55:16 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luca@coelho.fi>, johannes@sipsolutions.net,
        linux-wireless@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 11/12] mac80211: drop data frames without key on
 encrypted links
Message-ID: <YNNLVFDPbayaYEUG@kroah.com>
References: <iwlwifi.20200326150855.6865c7f28a14.I9fb1d911b064262d33e33dfba730cdeef83926ca@changeid>
 <20200327150342.252AF20748@mail.kernel.org>
 <20210611101046.zej2t2oc6hsc67yv@pali>
 <20210622231511.nb7o2sohnnz5qdhi@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210622231511.nb7o2sohnnz5qdhi@pali>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 23, 2021 at 01:15:11AM +0200, Pali Rohár wrote:
> On Friday 11 June 2021 12:10:46 Pali Rohár wrote:
> > On Friday 27 March 2020 15:03:41 Sasha Levin wrote:
> > > This commit has been processed because it contains a -stable tag.
> > > The stable tag indicates that it's relevant for the following trees: all
> > > 
> > > The bot has tested the following trees: v5.5.11, v5.4.27, v4.19.112, v4.14.174, v4.9.217, v4.4.217.
> > > 
> > > v5.5.11: Build OK!
> > > v5.4.27: Build OK!
> > > v4.19.112: Failed to apply! Possible dependencies:
> > ...
> > > v4.14.174: Failed to apply! Possible dependencies:
> > ...
> > > v4.9.217: Failed to apply! Possible dependencies:
> > ...
> > > v4.4.217: Failed to apply! Possible dependencies:
> > ...
> > > 
> > > How should we proceed with this patch?
> > 
> > Hello! I have looked at this patch and backported it into 4.19 and older
> > versions. But as this patch is security related and backporting needed
> > some code changes, it is required to review this patch prior including
> > it into any stable branch. Patch is below.
> 
> Hello Sasha and Greg!
> 
> Do you have any opinion how do you want to process this patch? I would
> like to know if something else is needed from my side.

If it is not applied, please resend it, it's not in any queue that I can
see...

thanks,

greg k-h
