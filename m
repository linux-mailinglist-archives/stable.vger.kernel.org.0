Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6CDC676CA7
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 13:06:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbjAVMGS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 07:06:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbjAVMGS (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 07:06:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0AB6166D5;
        Sun, 22 Jan 2023 04:06:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A05C0B80A72;
        Sun, 22 Jan 2023 12:06:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C42FCC433EF;
        Sun, 22 Jan 2023 12:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674389174;
        bh=3nh7wT08+uoGl5Pvj2Db3Ta6DmN+AWME040ZNIylNjw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0/NyeG+TNaS2XaQ9u5j/wCPeWojYyDLvxVtFAlCMMthNCmQEAWOJhdsJZ+Fc+0flJ
         me/F2s7a4xPUktxoL55H8fieMgLqjr+AGpMFlxoHElQ0J4Diil+6MIDx+dKprOulgx
         7P3+0X4ewYgocWCzzVUl4vb4+XOf48UnW66Nug1w=
Date:   Sun, 22 Jan 2023 13:06:11 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Alexander Wetzel <alexander@wetzel-home.de>
Cc:     Sasha Levin <sashal@kernel.org>, stable-commits@vger.kernel.org,
        stable@vger.kernel.org, Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: Patch "wifi: mac80211: Drop support for TX push path" has been
 added to the 6.1-stable tree
Message-ID: <Y80ms6dcAmksApOz@kroah.com>
References: <20230122042805.209191-1-sashal@kernel.org>
 <211e827e-e778-72a9-de02-42549f2e4faa@wetzel-home.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <211e827e-e778-72a9-de02-42549f2e4faa@wetzel-home.de>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jan 22, 2023 at 10:55:50AM +0100, Alexander Wetzel wrote:
> On 22.01.23 05:28, Sasha Levin wrote:
> > This is a note to let you know that I've just added the patch titled
> > 
> >      wifi: mac80211: Drop support for TX push path
> > 
> > to the 6.1-stable tree which can be found at:
> >      http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> > 
> > The filename of the patch is:
> >       wifi-mac80211-drop-support-for-tx-push-path.patch
> > and it can be found in the queue-6.1 subdirectory.
> > 
> > If you, or anyone else, feels it should not be added to the stable tree,
> > please let <stable@vger.kernel.org> know about it.
> > 
> 
> We should at least have a discussion about that.
> While I think we have sorted out all related regressions it's still way too
> early to be sure.
> 
> The patch is also changing most mac80211 driver interfaces from queuing to
> non-queuing and is thus nothing I would do within a fix release.

Fair enough, I'll go drop it now, thanks for letting us know.

greg k-h
