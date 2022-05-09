Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 110D551FFF2
	for <lists+stable@lfdr.de>; Mon,  9 May 2022 16:37:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237237AbiEIOgl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 May 2022 10:36:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237253AbiEIOgh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 May 2022 10:36:37 -0400
Received: from wout1-smtp.messagingengine.com (wout1-smtp.messagingengine.com [64.147.123.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F569344EA;
        Mon,  9 May 2022 07:32:43 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id B434332002E8;
        Mon,  9 May 2022 10:32:38 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Mon, 09 May 2022 10:32:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1652106758; x=1652193158; bh=q2fT6PeM+A
        UuJffXe5pQrhxNHgfVI2C0XP0Aur0lGRQ=; b=A4iBPsoEz6TeExjL15OtRvqOBD
        Rcgj3CEIbFxNDBWpEOvWhgqSxyHYQgHzP6L2rHOv76GyG2I8roO2CBtUMXeUs9QD
        9VdNunZ3MY4PUGwckFplrl6SaD7x1jthvmNhxwLdwubzx4mOgdtLu9Z/zpGIRuBK
        j1KPJ7/XdMqca2UVchc69aKrhnPXpz12NcwZ+T24LZUov1Bb/Phmy/kh6p9DzewY
        tUe/vFcTfB2Np5VcQNEXnLeBl9LyKQGDcETW7lxcOVZiAuAAszWFcl6rRNknCpPg
        WZ5ihOadmgWalMt133ueUqziTTCpokipTDuBUMKmg6wPOeR6VJ3oWB+alKkA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1652106758; x=
        1652193158; bh=q2fT6PeM+AUuJffXe5pQrhxNHgfVI2C0XP0Aur0lGRQ=; b=y
        Wjkna7tbZljgf02Qd2QXFkFZGxDoYaNx5upaQcv6P7XX8BwjG2UAk1Zgy9Ow6Wd+
        KpBBa1qP4bBchGr5EIWsorFwDSDweMKcktE44Q/HTrSqXzT3BoDdLB6e6GQzVuou
        SygHBe67fXPrAa0G8VcNbV51JdAxwipgyX2LVWI9CPlFx09rUQtbkCmqz84BVGkB
        5H388WSa9pvcarZeT8YQ1n5jEIwQX2qGYyTTyhDHkh4oPCGvHVNaOtAAV+nApeBY
        Qa7YaeHxaC2gNhy156KPUp+53bcGXCrvLAOFyL9fBw7D4Huie/RRqw4QALjfOQek
        wpIPFsgrf+qVS/vDmWL6w==
X-ME-Sender: <xms:BSZ5Ygx6-lm1QrNUBNVxmtjzNaKdnpHvAIj7CASikzSusu6FB20ZTg>
    <xme:BSZ5YkTbUoxlRrcCqIfA4NF8FRaY3OF1y2czNdANLbvKAvx6NXiAeIEtkaEuhwuai
    Oi9O3TJSKX7qQ>
X-ME-Received: <xmr:BSZ5YiXMVkJZdC0KbhSKYfibYEBE-une6zY7CMcBXzkTEFYksd2ObeNnOPcz1ncTmTSNVTdLvyX8NePeXSY3u2R-bELYMuG9>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrfeelgdejjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeegheeuhe
    fgtdeluddtleekfeegjeetgeeikeehfeduieffvddufeefleevtddtvdenucffohhmrghi
    nhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:BSZ5YuiVXce1FX60DhPXZ00MR2S_45sPs3-QqM1vM984dOgwr9am4Q>
    <xmx:BSZ5YiAIq5WJI6s8VIZUUW3dLPw8yGeUDfw4GMQQXSGLOfZpMxjYlQ>
    <xmx:BSZ5YvLRhSHtsKQfv2--elMtzCTHcbexfovunQT_9D90rsIlTYQINA>
    <xmx:BiZ5Ym7iY5VG26jzw0l3cCdhnIfSfHyIsGPsBo3J1pacKoN2HJ7KWg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 9 May 2022 10:32:37 -0400 (EDT)
Date:   Mon, 9 May 2022 16:32:35 +0200
From:   Greg KH <greg@kroah.com>
To:     Qu Wenruo <wqu@suse.com>
Cc:     stable@vger.kernel.org, linux-btrfs@vger.kernel.org,
        Matt Corallo <blnxfsl@bluematt.me>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Subject: Re: [PATCH stable-5.15.y] btrfs: force v2 space cache usage for
 subpage mount
Message-ID: <YnkmA3hE5LnVz3KQ@kroah.com>
References: <edc6262ba229edce38a63b70960ffc170287ee11.1652088466.git.wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <edc6262ba229edce38a63b70960ffc170287ee11.1652088466.git.wqu@suse.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 09, 2022 at 05:28:56PM +0800, Qu Wenruo wrote:
> commit 9f73f1aef98b2fa7252c0a89be64840271ce8ea0 upstream.
> 
> [BUG]
> For a 4K sector sized btrfs with v1 cache enabled and only mounted on
> systems with 4K page size, if it's mounted on subpage (64K page size)
> systems, it can cause the following warning on v1 space cache:
> 
>  BTRFS error (device dm-1): csum mismatch on free space cache
>  BTRFS warning (device dm-1): failed to load free space cache for block group 84082688, rebuilding it now
> 
> Although not a big deal, as kernel can rebuild it without problem, such
> warning will bother end users, especially if they want to switch the
> same btrfs seamlessly between different page sized systems.
> 
> [CAUSE]
> V1 free space cache is still using fixed PAGE_SIZE for various bitmap,
> like BITS_PER_BITMAP.
> 
> Such hard-coded PAGE_SIZE usage will cause various mismatch, from v1
> cache size to checksum.
> 
> Thus kernel will always reject v1 cache with a different PAGE_SIZE with
> csum mismatch.
> 
> [FIX]
> Although we should fix v1 cache, it's already going to be marked
> deprecated soon.
> 
> And we have v2 cache based on metadata (which is already fully subpage
> compatible), and it has almost everything superior than v1 cache.
> 
> So just force subpage mount to use v2 cache on mount.
> 
> Reported-by: Matt Corallo <blnxfsl@bluematt.me>
> CC: stable@vger.kernel.org # 5.15+
> Link: https://lore.kernel.org/linux-btrfs/61aa27d1-30fc-c1a9-f0f4-9df544395ec3@bluematt.me/
> Reviewed-by: Josef Bacik <josef@toxicpanda.com>
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  fs/btrfs/disk-io.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)

Now queued up, thanks.

greg k-h
