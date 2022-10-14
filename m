Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2D8B5FE93E
	for <lists+stable@lfdr.de>; Fri, 14 Oct 2022 09:11:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229595AbiJNHLD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Oct 2022 03:11:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiJNHLC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Oct 2022 03:11:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CC7515A313
        for <stable@vger.kernel.org>; Fri, 14 Oct 2022 00:11:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 20C0461A1D
        for <stable@vger.kernel.org>; Fri, 14 Oct 2022 07:11:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29E07C433C1;
        Fri, 14 Oct 2022 07:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665731460;
        bh=TV0zdjTJbfFTzEaIO92Vs99q7sP91t8cN4/PJL01jJA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LrMLZh5mBi+rsfLosly16TJQDZRLN/0D3lnfLz+aU1bY3q0/rv3Ohm6vpt69EFNfS
         NL6kkZdakbkFnpaG2OQh7nVXEtw4zJYljxpwgZ3HnyWfg1igI54K2iAoPUhsbH0nsy
         g2ymURi4JXmsqtjCcj/+kZQOfcnq35ENx35CEj6E=
Date:   Fri, 14 Oct 2022 09:11:45 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     stable@vger.kernel.org, johannes@sipsolutions.net
Subject: Re: [PATCH 5.15 1/6] mac80211: mesh: clean up rx_bcn_presp API
Message-ID: <Y0kLsThZoDPPENhI@kroah.com>
References: <20221013181601.5712-1-nbd@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221013181601.5712-1-nbd@nbd.name>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 13, 2022 at 08:15:56PM +0200, Felix Fietkau wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> commit a5b983c6073140b624f64e79fea6d33c3e4315a0 upstream.
> 
> We currently pass the entire elements to the rx_bcn_presp()
> method, but only need mesh_config. Additionally, we use the
> length of the elements to calculate back the entire frame's
> length, but that's confusing - just pass the length of the
> frame instead.
> 
> Link: https://lore.kernel.org/r/20210920154009.a18ed3d2da6c.I1824b773a0fbae4453e1433c184678ca14e8df45@changeid
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>  net/mac80211/ieee80211_i.h |  7 +++----
>  net/mac80211/mesh.c        |  4 ++--
>  net/mac80211/mesh_sync.c   | 26 ++++++++++++--------------
>  3 files changed, 17 insertions(+), 20 deletions(-)

Many thanks for this series.  Will this also work in 5.4.y and 5.10.y?

greg k-h
