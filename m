Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 120813E9EBB
	for <lists+stable@lfdr.de>; Thu, 12 Aug 2021 08:45:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234568AbhHLGpb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Aug 2021 02:45:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:53410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231253AbhHLGpb (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 12 Aug 2021 02:45:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3D8A860720;
        Thu, 12 Aug 2021 06:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628750706;
        bh=qXGXdFChZAEV5IlCS4mrynkv9cBlsMkD8wmmIQ52G/U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=r1/nxotI59kvICpm1yqtty4L+cUsGJyhifnHQqDQBsejFZ3S2XdIyL3dqpbHkrOnG
         QQYOnhGig0zHBEMCt9qCGny9nkYvVuiGsV18BwfRylowPz4a8nrxNX3YJyN7b6wH4l
         /RkecF6Y+CuKuyYz8okZG6jshKwdPFV1D3fr/sJo=
Date:   Thu, 12 Aug 2021 08:45:04 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Georgi Djakov <djakov@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Mike Tipton <mdtipton@codeaurora.org>
Subject: Re: [PATCH 5.13 159/175] interconnect: qcom: icc-rpmh: Add BCMs to
 commit list in pre_aggregate
Message-ID: <YRTDcP5Mrf3omdzj@kroah.com>
References: <20210810173000.928681411@linuxfoundation.org>
 <20210810173006.202673615@linuxfoundation.org>
 <b52559cd-7f4a-70af-8878-a9e513a66bcd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b52559cd-7f4a-70af-8878-a9e513a66bcd@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 11, 2021 at 06:50:12PM +0300, Georgi Djakov wrote:
> On 10.08.21 20:31, Greg Kroah-Hartman wrote:
> > From: Mike Tipton <mdtipton@codeaurora.org>
> > 
> > commit f84f5b6f72e68bbaeb850b58ac167e4a3a47532a upstream.
> > 
> > We're only adding BCMs to the commit list in aggregate(), but there are
> > cases where pre_aggregate() is called without subsequently calling
> > aggregate(). In particular, in icc_sync_state() when a node with initial
> > BW has zero requests. Since BCMs aren't added to the commit list in
> > these cases, we don't actually send the zero BW request to HW. So the
> > resources remain on unnecessarily.
> > 
> > Add BCMs to the commit list in pre_aggregate() instead, which is always
> > called even when there are no requests.
> > 
> > Fixes: 976daac4a1c5 ("interconnect: qcom: Consolidate interconnect RPMh support")
> > Signed-off-by: Mike Tipton <mdtipton@codeaurora.org>
> > Link: https://lore.kernel.org/r/20210721175432.2119-5-mdtipton@codeaurora.org
> > Signed-off-by: Georgi Djakov <djakov@kernel.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> Hello Greg,
> 
> Please drop this patch, as people are reporting issues on some
> platforms. So please do not apply it to any stable trees yet
> (5.10 and 5.13). I will send a revert (or other fix) to you soon.

Now dropped from both queues, thanks.

greg k-h
