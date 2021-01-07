Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FF8A2ED06C
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 14:14:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728172AbhAGNNq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 08:13:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:55074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728298AbhAGNNq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 Jan 2021 08:13:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0DD2B223C8;
        Thu,  7 Jan 2021 13:13:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610025185;
        bh=sBaRgt9v5nPEv/YZQlpS6zarzR2tvC1DT8Zf2tm0ZxY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=b7bBAyMfXt7V4aW/SorObkV7/lz3G6s0ars2K9mGiyruC66kWAxZaD4yMLmiQRwLg
         o4eW4e+44Yq7079xdRDmlEKej0J4jALe9TUA2KS605zKVwEWSMBtiKFV4VRtmPvomR
         5dd942x3nTrkcXiuSd0yNwvn1krqO3GWsYKWstpU=
Date:   Thu, 7 Jan 2021 14:14:25 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Imre Deak <imre.deak@intel.com>
Cc:     stable@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        Ville =?iso-8859-1?Q?Syrj=E4l=E4?= 
        <ville.syrjala@linux.intel.com>
Subject: Re: v5.10 stable backport request
Message-ID: <X/cJMWjnhr+JFh/N@kroah.com>
References: <20210106175301.GB202232@ideak-desk.fi.intel.com>
 <X/X7umSYEeKCZ0Dw@kroah.com>
 <20210106190945.GA213231@ideak-desk.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210106190945.GA213231@ideak-desk.fi.intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 06, 2021 at 09:09:45PM +0200, Imre Deak wrote:
> On Wed, Jan 06, 2021 at 07:04:42PM +0100, Greg KH wrote:
> > On Wed, Jan 06, 2021 at 07:53:01PM +0200, Imre Deak wrote:
> > > Stable team, please backport the upstream commit
> > > 
> > > 8f329967d596 ("drm/i915/tgl: Fix Combo PHY DPLL fractional divider for 38.4MHz ref clock")
> > > 
> > > to the v5.10 stable kernel.
> > 
> > I see no such commit id in Linus's kernel :(
> 
> Sorry, the commit id correctly is
> 
> 0e2497e334de42dbaaee8e325241b5b5b34ede7e

Much better :)

Now queued up, thanks.

greg k-h
