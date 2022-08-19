Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B447A599DB3
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 16:48:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349459AbiHSOjn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 10:39:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349585AbiHSOjl (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 10:39:41 -0400
Received: from wout3-smtp.messagingengine.com (wout3-smtp.messagingengine.com [64.147.123.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30A66ED001;
        Fri, 19 Aug 2022 07:39:39 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 07D7E32003CE;
        Fri, 19 Aug 2022 10:39:36 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 19 Aug 2022 10:39:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1660919976; x=1661006376; bh=fZII8GyCA2
        yRaqfhy5Sp+pvzUV5l79DuSRqq+3GxzNk=; b=mh9ClG6cRZI47g1MciZw9j6gIr
        sM2TpsLKoCppnbmmV36Rb4ZKvtOOU8FO0G7TJ2xmYdpl8hmrLYeyWrRK75UclqOf
        4V1gfXG72XcldRKbalBdjv9Tf3zJoYngELMcnYRa2cSEKpwEO69TR5VTb1jAgdYS
        PCDJiA716fMtJR2Htl0IaaNYSkphAGQrnJcR8I/fXFz1O5DuX3FHDZx/xIMK1kaW
        68RACwa3P5x8kewtFyIv2aKinNaM7w7s4m8T3DIpa5/T5Yjm3EdaIR0TSPxE5Diy
        igA7rgxUn/0V/YBZ2ra4KvMfmclEUugOCkFkwxbDq5nngKTxif97ENIjICBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1660919976; x=1661006376; bh=fZII8GyCA2yRaqfhy5Sp+pvzUV5l
        79DuSRqq+3GxzNk=; b=yKvWuz7rC8UvR1VkzCIrirGMOaBXHXkPi10ac5PoRu/4
        iMSXwfb3vF/j9Wl473JIvIi60t58BI6n0KOtOQfqP3WkBLmsMjHvUAB5afMQlBRH
        X/WZMv6daIlptrNc01vn+y99eX3asmEXSuEsbOy2GZyf6vdeZSjeV1wYF0FY7m7q
        u0gvzt3fVqQvPfQBxD7Ebl2kuPqDM5FkmYO1jERaPAtK6aCiyoqSt03QkE5OkYs0
        b6nSx2PDruimbKyF32+z9iOu9ZWOHk8+aAmCV4xmVSiq7XldOoJxdZBUAhNuid+u
        Xj5ML1JZRNZPbUONgCKan5OvHDBlV1zSwLjneNb4eQ==
X-ME-Sender: <xms:qKD_YoMwjchNwpFTd4mX1ePMzsyzwSfguhhD9P-Dx6ZI1DNc2CarBA>
    <xme:qKD_Yu91bdgKicUEL5KqIQGdYWehDHQnc1DBz2VuUaKCadMUx2QFB9f7YfqYvsEK6
    o0Nj--daIyTXQ>
X-ME-Received: <xmr:qKD_YvRIRHD1rgvRibD1PVjBej8d3TDciYbnbwX63wEEGInw5SQYLOXJYtMH2xLJ2iZ9rLDNKT1e_D3PQY6wPD0dLKJahH-t>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvdeiuddgkedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepgeehue
    ehgfdtledutdelkeefgeejteegieekheefudeiffdvudeffeelvedttddvnecuffhomhgr
    ihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:qKD_Ygu0cUQAuEGAq0godjgh6w7vfijnnKos5PbFsu6t8flEiv0wdw>
    <xmx:qKD_YgdPkwy6dvVxAIraVqG5CMzEGFGWiF6Jbxo95LNvl8IZ77qA-w>
    <xmx:qKD_Yk2MEyF2Ne4Pgp6mJolrU1Tde2tP4B2lG4lN5brILlId5OOMhA>
    <xmx:qKD_Yv6luiUwOCaHYiQx1LIoclNiJU2J_CZgS7Qfuj7mPV9rySH2qA>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 19 Aug 2022 10:39:35 -0400 (EDT)
Date:   Fri, 19 Aug 2022 16:39:31 +0200
From:   Greg KH <greg@kroah.com>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH STABLE 5.10 0/2] btrfs: raid56: backports to reduce
 corruption
Message-ID: <Yv+go4KbjBbWoGo3@kroah.com>
References: <cover.1660906975.git.wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1660906975.git.wqu@suse.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 19, 2022 at 08:01:08PM +0800, Qu Wenruo wrote:
> This is the backport for v5.10.x stable branch.
> 
> The full explananation can be found here:
> https://lore.kernel.org/linux-btrfs/cover.1660891713.git.wqu@suse.com/
> 
> Difference between v5.10.x and v5.15.x backports:
> 
> - Naming change in btrfs_io_contrl
>   In v5.15, we don't have the btrfs_io_contrl rename, thus only
>   btrfs_bio.
> 
> - Missing btrfs_fs_info::sectorsize_bits
>   Since RAID56 doesn't support anything but PAGE_SIZE == sectorsize
>   (until v5.19+), here we just use PAGE_SHIFT.
> 
> Another thing related to v5.10.x testing is, there are some lockdep
> assert triggered related to uuid_mutex.
> 
> I'm not 100% sure, but at least RAID56 code is not touching that mutex,
> thus I guess it's some other problems.
> 
> Qu Wenruo (2):
>   btrfs: only write the sectors in the vertical stripe which has data
>     stripes
>   btrfs: raid56: don't trust any cached sector in
>     __raid56_parity_recover()
> 
>  fs/btrfs/raid56.c | 74 ++++++++++++++++++++++++++++++++++++-----------
>  1 file changed, 57 insertions(+), 17 deletions(-)
> 
> -- 
> 2.37.1
> 

Now queued up, thanks.

greg k-h
