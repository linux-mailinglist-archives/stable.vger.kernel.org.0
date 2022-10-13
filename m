Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C533E5FE146
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 20:32:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231854AbiJMScR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 14:32:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231979AbiJMSbx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 14:31:53 -0400
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E0A018812C
        for <stable@vger.kernel.org>; Thu, 13 Oct 2022 11:27:32 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id A06885C00AB;
        Thu, 13 Oct 2022 14:13:50 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 13 Oct 2022 14:13:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm3; t=1665684830; x=1665771230; bh=Rzq4+Fa3pO
        Tv29+8aJzZs4KSt4CTfJ6c6cgeXED305Q=; b=jKHtbshonb1bojXErLc8VrYX5I
        5F5JnSXo19EKQl0S3ydZp4hZJYd3YlcKHrEpn7E68Tq2bsaVSOSUEBkCBOYgzwyd
        QF0AvKvC0WB/2axk5unx6zaP2MzLs9G13zKvqaeeLT0iN9s8IenSgsXfybOOEs/r
        WPmPUOcnMPpWZBgNLqOrIe6C4rxeBqcakaVfkRH4meBl55TRv3i35q+FUHqxdAhG
        b7qmqnvoAuN1wpQkYkUCilBy+d5GGp+jgV0IdlzLgMrL+Sf7IF8B338V6zxbEASv
        87QtQoR4fLJubP72M4Xkera1LSNqIv9n1XPzyE+d/Hibl4uIEg4VmcSmo21g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; t=1665684830; x=1665771230; bh=Rzq4+Fa3pOTv29+8aJzZs4KSt4CT
        fJ6c6cgeXED305Q=; b=dHrLS6WzI1ph6DvAD7KEEIjhxlIIg5j9Ok5ODjIBsW3a
        3FJDv6ms8oHYJhRpIhyKidStc5xqsYVfuR5JTtfUQ2v1tpCkJwTuXHs77rIlQuxa
        TW/BahjiWdaaxJcg4hkqdN9ts/yvEsDmgWfDK2IBXzt1SpEfcH6dqVOwe9lJpyrV
        InQyeqVKrHAi2/KcQyU5/FAEXv+srRBZNLPyCo2qzddKr8zkq43ndgePzV93XMKs
        pgmSoWfBJJnLPgUViOydFc+ksiXdoriceDtq+LezyiMxRnA6NCM/celx91E++dc0
        rzOp1STgydRdjHZ71v+LQsRlDVECb3Y0iA/oY6HkFA==
X-ME-Sender: <xms:XlVIY4sJyXIhj_6h0hq0duGJVT_Rr1C2xE7_AS4MQdgoWAzXnjBM3g>
    <xme:XlVIY1cORhyYRhUxMBHnlAlj_vpK5HN2qk9ko9u68vIC7OWdE6HP8w829YwI8MW0S
    dR9t99g-zshoQ>
X-ME-Received: <xmr:XlVIYzydSpz_GLpQ2GCFI_rFSeuJooYojWA-51rVLOl6vAfdlIYK3psVNso>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrfeektddguddvgecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgv
    ghcumffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeehge
    dvvedvleejuefgtdduudfhkeeltdeihfevjeekjeeuhfdtueefhffgheekteenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhroh
    grhhdrtghomh
X-ME-Proxy: <xmx:XlVIY7NGPNVOwSe5lbYfU9a4KuD-K8q_tG3X9GpzwIdNL0GMyoshYA>
    <xmx:XlVIY4-wdpVaXfTxe8rn60H-XuNHd46x2q36_NPb0M639lI9SjJqqA>
    <xmx:XlVIYzVD5IyI1vbCiJJKxl0-LDAXmzCteflf2OYqDc-yakVdV11xeA>
    <xmx:XlVIY8RMCzsUpppdq_J-WsAy5XgxzrF-oyc0S70SnYpD-GuM3ExgNA>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 13 Oct 2022 14:13:49 -0400 (EDT)
Date:   Thu, 13 Oct 2022 20:01:49 +0200
From:   Greg KH <greg@kroah.com>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Ilan Peer <ilan.peer@intel.com>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v5.19] wifi: mac80211: fix MBSSID parsing use-after-free
Message-ID: <Y0hSjVMP2HonYspS@kroah.com>
References: <20221013175215.161367-1-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221013175215.161367-1-johannes@sipsolutions.net>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 13, 2022 at 07:52:15PM +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Commit ff05d4b45dd89b922578dac497dcabf57cf771c6 upstream.
> 
> When we parse a multi-BSSID element, we might point some
> element pointers into the allocated nontransmitted_profile.
> However, we free this before returning, causing UAF when the
> relevant pointers in the parsed elements are accessed.
> 
> Fix this by not allocating the scratch buffer separately but
> as part of the returned structure instead, that way, there
> are no lifetime issues with it.
> 
> The scratch buffer introduction as part of the returned data
> here is taken from MLO feature work done by Ilan.
> 
> This fixes CVE-2022-42719.
> 
> Fixes: 5023b14cf4df ("mac80211: support profile split between elements")
> Co-developed-by: Ilan Peer <ilan.peer@intel.com>
> Signed-off-by: Ilan Peer <ilan.peer@intel.com>
> Reviewed-by: Kees Cook <keescook@chromium.org>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>  net/mac80211/ieee80211_i.h |  8 ++++++++
>  net/mac80211/util.c        | 30 +++++++++++++++---------------
>  2 files changed, 23 insertions(+), 15 deletions(-)

Thanks, my attempt was almost the same as yours, except for one
whitespace difference.  I've taken yours as a replacement now.

greg k-h
