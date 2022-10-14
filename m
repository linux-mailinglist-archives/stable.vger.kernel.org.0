Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E88A5FEA61
	for <lists+stable@lfdr.de>; Fri, 14 Oct 2022 10:20:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230145AbiJNIUp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Oct 2022 04:20:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230114AbiJNIU2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Oct 2022 04:20:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82CD8B3B2D
        for <stable@vger.kernel.org>; Fri, 14 Oct 2022 01:20:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C756AB8226D
        for <stable@vger.kernel.org>; Fri, 14 Oct 2022 08:20:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CA56C433D6;
        Fri, 14 Oct 2022 08:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665735619;
        bh=GsQbcXss/AbNM/GPEVbMVgMz05OzRpZbD5aDedxKVms=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IvrndHfBrL4BFpz6Lq6urwS6jB+0ppc8EnSxtmWItCwKjRlcyCDumi2+ITCbO29AT
         416I7VBe8MmF/CgoyrPSb22L+EH1h6wceURBCneGYdJyaJsTI/lerNSTnt6uxC8q1I
         4X1fqp5C5WAMH70/tlzn05L415Xns+EmEkXkQWtY=
Date:   Fri, 14 Oct 2022 10:21:04 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     stable@vger.kernel.org, johannes@sipsolutions.net
Subject: Re: [PATCH 5.15 1/6] mac80211: mesh: clean up rx_bcn_presp API
Message-ID: <Y0kb8LRHNxZz2nIl@kroah.com>
References: <20221013181601.5712-1-nbd@nbd.name>
 <Y0kLsThZoDPPENhI@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y0kLsThZoDPPENhI@kroah.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 14, 2022 at 09:11:45AM +0200, Greg KH wrote:
> On Thu, Oct 13, 2022 at 08:15:56PM +0200, Felix Fietkau wrote:
> > From: Johannes Berg <johannes.berg@intel.com>
> > 
> > commit a5b983c6073140b624f64e79fea6d33c3e4315a0 upstream.
> > 
> > We currently pass the entire elements to the rx_bcn_presp()
> > method, but only need mesh_config. Additionally, we use the
> > length of the elements to calculate back the entire frame's
> > length, but that's confusing - just pass the length of the
> > frame instead.
> > 
> > Link: https://lore.kernel.org/r/20210920154009.a18ed3d2da6c.I1824b773a0fbae4453e1433c184678ca14e8df45@changeid
> > Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> > ---
> >  net/mac80211/ieee80211_i.h |  7 +++----
> >  net/mac80211/mesh.c        |  4 ++--
> >  net/mac80211/mesh_sync.c   | 26 ++++++++++++--------------
> >  3 files changed, 17 insertions(+), 20 deletions(-)
> 
> Many thanks for this series.  Will this also work in 5.4.y and 5.10.y?

Also, in the future, you forgot to sign-off on these patches as you did
forward them on yourself.  Next time remember to add that, thanks.

All now queued up.

greg k-h
