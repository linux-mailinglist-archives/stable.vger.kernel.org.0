Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C984A67DEA0
	for <lists+stable@lfdr.de>; Fri, 27 Jan 2023 08:38:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231553AbjA0Hir (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Jan 2023 02:38:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231740AbjA0Hiq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Jan 2023 02:38:46 -0500
Received: from wout2-smtp.messagingengine.com (wout2-smtp.messagingengine.com [64.147.123.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEC89627BD;
        Thu, 26 Jan 2023 23:38:45 -0800 (PST)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 91C713200B74;
        Fri, 27 Jan 2023 02:38:44 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Fri, 27 Jan 2023 02:38:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm3; t=1674805124; x=1674891524; bh=YsqaKJ1LUZ
        0PsL5aKHHcqClIuiWtgJNfSZoAsQwoT14=; b=AzlBtdQH2IBeVC/HAHJQgAKTIb
        GqMb2I/fx/3pJIqcPqYImD0lQh/EWjMKJgPu37nQuznHWXDcFgCxy/GwGjuLH5G4
        9sXLGu3baySW2IVWVQ5q3Yaay10DAtbmndJksGWhtm86qa1CqlLOAoAOIMBsxQjt
        uqgZdgpdGlkUdxERfMrLQRpd0inTE9VCmmrLw0cYvLyOTJQxvHUqydAxZ1QX6R/y
        d1TQ4QYnx3UAjLYIozh9Dars/Ify5PLoNbVe7SZy7y53XwuEp1sy1aU8Dg/OTiv2
        3NqhVGwaIBrLIMHOSufL41h4ZfDoBKsKQb6nFFDPc8PEq4Qjruu8i0ezBzKA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; t=1674805124; x=1674891524; bh=YsqaKJ1LUZ0PsL5aKHHcqClIuiWt
        gJNfSZoAsQwoT14=; b=bPiNBBYi/hWsdh4bVvz2TOsYe88fFPJbGrhuDO6Ku8NU
        ifzsKKdmWlUUFbxRxDnoTLWLYX4xhUa5bf0BdU67XaWoAyTgvg+yoBe7GgFxYaSM
        EqhyGzNprN+DF8SGx1gyY55uP2VQllKvaz81mEAXspnkIhLijussXLyikqamOJZ0
        IBjrP4Tqlx6fNEBFYVxZudTLDBDG4V6aszOqYGtb7KydJJBRjWm9P/GayypbaUL6
        QJ+MOejEirm9KvtgCpe1lxwOmEG2okTAIq6o3GuWn7zMxR+sYm6La7D530CdNdUo
        ClXmB/qrX/lmdf0+ZOhC/6QuWFWMB7mfAkU9henmnA==
X-ME-Sender: <xms:g3_TY0YYTXsQt1ON8NEkpMkDHe6aaWvfJ2Gw_1DhB0s0qac314GPcw>
    <xme:g3_TY_ZVICD1qS5ZSlyES5pVAPRYeAoHgQfghvgTw3MjrBK4bZKeP_DSZlkW-PebV
    yQdKuZuFImEnw>
X-ME-Received: <xmr:g3_TY-_1J0WlM2ZnwP5IwG6QlA0mAwWqj65NFB9Dumx7Rwsqb8OwHPLlY0O8I2ngTCFypPHRnoXj9mw1SmR8NTXRcEoy7Qbq2ofrCA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedruddvhedgudduvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgv
    ghcumffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeeghe
    euhefgtdeluddtleekfeegjeetgeeikeehfeduieffvddufeefleevtddtvdenucffohhm
    rghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrg
    hmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:g3_TY-rcL5hNAscyzb3UO2L3za2q3GXN9yHpi19q_5fsJCF4JIPHeA>
    <xmx:g3_TY_oP15wcuDM9538iDztsw7g_cLLwKtq3TpPkOmyMRbeZCWEDEA>
    <xmx:g3_TY8QFSwfn4EnzNl9XEz8nvRvOMrTDdxTadBq8GTvxNtav_3eO8g>
    <xmx:hH_TYwcb6dM2hVU-dQ3wV1iltUbHmxApC25LdPjNX6EV05JAhV_L3g>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 27 Jan 2023 02:38:43 -0500 (EST)
Date:   Fri, 27 Jan 2023 08:38:41 +0100
From:   Greg KH <greg@kroah.com>
To:     Alexander Wetzel <alexander@wetzel-home.de>
Cc:     linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
        stable@vger.kernel.org
Subject: Re: [stable v6.1 2/2] wifi: mac80211: Fix iTXQ AMPDU fragmentation
 handling
Message-ID: <Y9N/gVAgu7AdIajA@kroah.com>
References: <20230121223330.389255-1-alexander@wetzel-home.de>
 <20230121223330.389255-2-alexander@wetzel-home.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230121223330.389255-2-alexander@wetzel-home.de>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jan 21, 2023 at 11:33:30PM +0100, Alexander Wetzel wrote:
> This is a backport of 'commit 592234e941f1 ("wifi: mac80211: Fix iTXQ
> AMPDU fragmentation handling")' from linux 6.2.
> 
> mac80211 must not enable aggregation wile transmitting a fragmented
> MPDU. Enforce that for mac80211 internal TX queues (iTXQs).
> 
> Cc: stable@vger.kernel.org
> Link: https://lore.kernel.org/r/20230106223141.98696-1-alexander@wetzel-home.de
> Signed-off-by: Alexander Wetzel <alexander@wetzel-home.de>
> ---
>  net/mac80211/agg-tx.c |  2 --
>  net/mac80211/ht.c     | 37 +++++++++++++++++++++++++++++++++++++
>  net/mac80211/tx.c     | 13 +++++++------
>  3 files changed, 44 insertions(+), 8 deletions(-)
> 

Both now queued up, thanks.

greg k-h
