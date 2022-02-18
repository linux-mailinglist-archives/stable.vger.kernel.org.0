Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECD6F4BB9C9
	for <lists+stable@lfdr.de>; Fri, 18 Feb 2022 14:04:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232738AbiBRNEg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Feb 2022 08:04:36 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232256AbiBRNEg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Feb 2022 08:04:36 -0500
Received: from new4-smtp.messagingengine.com (new4-smtp.messagingengine.com [66.111.4.230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3D242B4618;
        Fri, 18 Feb 2022 05:04:19 -0800 (PST)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id F278D580226;
        Fri, 18 Feb 2022 08:04:17 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Fri, 18 Feb 2022 08:04:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm3; bh=pxpqD2+sLe6m/z/BcNmFIUMN1NaFzbA2gxa6Sn
        G8FAE=; b=YkFltgs/c6JzKnjmgH8tHs+8cIg9owcvVpqyEagiIVRJ9bSEj1WQQ4
        ToRrhcr4eSxTfN8YK279owt59FbvtFqd0r16BgV4FNPxcNVotRdE8NKhbPv/hd79
        2Z4KaSShethSnnJhtocSPa3wJe+Kqgtsa0Ajokvu+RWPiHml0VG+lQJ9xB0RupSA
        rDP40DVjUlvbXmSCYbqgpU5Us4Y/zNWFhlAZO9lg+qZkS8z00wZ4uCx4nAKWqm0+
        jjyuWpxAwVLSxbJN6Q3yP1vrKkZa+bIrHADBD6azZA9KlxmcrBgTLK1ODPkLphE/
        sl2ApynvQXp1tKkmPEqf12n1m1XdN6pA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=pxpqD2+sLe6m/z/Bc
        NmFIUMN1NaFzbA2gxa6SnG8FAE=; b=WbwYTPkqk0SGSvuwi4hwM4TZzpgA3XNd7
        wv27aKMOCVhvX9gnFwPVEne69GFZFbI3HtbGh7QKwNTG6UFQsQsrAgj60RDgn9wl
        OQA8HpsOn+L4ORcoKjLZFXiFpzWTHW41QvEmuqQM6gqzjpZSy9b/za37y1h3+e9+
        ZQ1/LxBUVUvW/Dixu/oap0jKWkMhHZAGI+BgU3DcZ6Gm7Oe6YZOdJjlTUwWjW+sW
        8UWpVUHmOWaYxyrmI1st9346rijZkQFD/9yXdN7ptt1ud9CbYO6D6KOKRTtyejyt
        Ks7ZzFLzq4c4hjpXwD7FGUvVxr/CrjKExXyDDcXmaepz8SEgTkTGg==
X-ME-Sender: <xms:UZkPYktVLygxxXeO3qfwmn_ksqtSTVg48CPJLwdtQT9xFlUjWx_5LQ>
    <xme:UZkPYhfP4pUaK0LhAQ-50255ESPE5GUXn2qlGumdhTZ5-8z3iZALJapsRlW6C99y1
    PP5huOxzD7rIA>
X-ME-Received: <xmr:UZkPYvwuNWocT16q2ezjMBMp1anqIk_Scs07YgdFzSPWET5ZZgsqh0u9IMJSywyepx_oOYKSP8kUIPEOizstVsVIg6geq7t0>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrkedtgdeghecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuheejgf
    ffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:UZkPYnPVDh6GLp2R8Sn2csqEhtGXq5cw9PmtlzNM7yUvY0QQ-PlE2Q>
    <xmx:UZkPYk_4XdxzbSs83w8Y41rugLb5f_eEh71kjNxLK7aljvhDKd06-Q>
    <xmx:UZkPYvVP1CwpPaQ2XpVAVfExnOvSUhwxRdwlLxVgqAsDqLY76of18A>
    <xmx:UZkPYoUoiNB3WBcARV4FjZi9NGc92yFyyRDafFIlIheOzoL0bbaomw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 18 Feb 2022 08:04:16 -0500 (EST)
Date:   Fri, 18 Feb 2022 14:04:15 +0100
From:   Greg KH <greg@kroah.com>
To:     Su Yue <l@damenly.su>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, David Sterba <dsterba@suse.com>,
        clm@fb.com, josef@toxicpanda.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.10 16/27] btrfs: tree-checker: check item_size
 for dev_item
Message-ID: <Yg+ZT4b8J+MRU2nG@kroah.com>
References: <20220209184103.47635-1-sashal@kernel.org>
 <20220209184103.47635-16-sashal@kernel.org>
 <Yg92voqmS9jz/rI+@kroah.com>
 <1r00qtxj.fsf@damenly.su>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1r00qtxj.fsf@damenly.su>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 18, 2022 at 07:25:20PM +0800, Su Yue wrote:
> 
> On Fri 18 Feb 2022 at 11:36, Greg KH <greg@kroah.com> wrote:
> 
> > On Wed, Feb 09, 2022 at 01:40:52PM -0500, Sasha Levin wrote:
> > > From: Su Yue <l@damenly.su>
> > > 
> > > [ Upstream commit ea1d1ca4025ac6c075709f549f9aa036b5b6597d ]
> > > 
> > > Check item size before accessing the device item to avoid out of
> > > bound
> > > access, similar to inode_item check.
> > > 
> > > Signed-off-by: Su Yue <l@damenly.su>
> > > Reviewed-by: David Sterba <dsterba@suse.com>
> > > Signed-off-by: David Sterba <dsterba@suse.com>
> > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > > ---
> > >  fs/btrfs/tree-checker.c | 8 ++++++++
> > >  1 file changed, 8 insertions(+)
> > > 
> > > diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
> > > index d4a3a56726aa8..4a5ee516845f7 100644
> > > --- a/fs/btrfs/tree-checker.c
> > > +++ b/fs/btrfs/tree-checker.c
> > > @@ -947,6 +947,7 @@ static int check_dev_item(struct extent_buffer
> > > *leaf,
> > >  			  struct btrfs_key *key, int slot)
> > >  {
> > >  	struct btrfs_dev_item *ditem;
> > > +	const u32 item_size = btrfs_item_size(leaf, slot);
> > > 
> > >  	if (key->objectid != BTRFS_DEV_ITEMS_OBJECTID) {
> > >  		dev_item_err(leaf, slot,
> > > @@ -954,6 +955,13 @@ static int check_dev_item(struct extent_buffer
> > > *leaf,
> > >  			     key->objectid,  BTRFS_DEV_ITEMS_OBJECTID);
> > >  		return -EUCLEAN;
> > >  	}
> > > +
> > > +	if (unlikely(item_size != sizeof(*ditem))) {
> > > +		dev_item_err(leaf, slot, "invalid item size: has %u expect %zu",
> > > +			     item_size, sizeof(*ditem));
> > > +		return -EUCLEAN;
> > > +	}
> > > +
> > >  	ditem = btrfs_item_ptr(leaf, slot, struct btrfs_dev_item);
> > >  	if (btrfs_device_id(leaf, ditem) != key->offset) {
> > >  		dev_item_err(leaf, slot,
> > > --
> > > 2.34.1
> > > 
> > 
> > This adds a build warning, showing that the backport is not correct, so
> > I'll go drop this :(
> > 
> And the warning is
> ========================================================================
> arch/x86/kernel/head_64.o: warning: objtool: .text+0x5: unreachable
> instruction
> fs/btrfs/tree-checker.c: In function \342\200\230check_dev_item\342\200\231:
> fs/btrfs/tree-checker.c:950:53: warning: passing argument 2 of
> \342\200\230btrfs_item_size\342\200\231 makes pointer from integer without a
> cast [-Wint-conversion]
>  950 |         const u32 item_size = btrfs_item_size(leaf, slot);
>      |                                                     ^~~~
>      |                                                     |
>      |                                                     int
> In file included from fs/btrfs/tree-checker.c:21:
> fs/btrfs/ctree.h:1474:48: note: expected \342\200\230const struct btrfs_item
> *\342\200\231 but argument is of type \342\200\230int\342\200\231
> 1474 |                                    const type *s) \
>      |                                    ~~~~~~~~~~~~^
> fs/btrfs/ctree.h:1833:1: note: in expansion of macro
> \342\200\230BTRFS_SETGET_FUNCS\342\200\231
> 1833 | BTRFS_SETGET_FUNCS(item_size, struct btrfs_item, size, 32);
>      | ^~~~~~~~~~~~~~~~~~
> ========================================================================
> 
> The upstream patchset[1] merged in 5.17-rc1, changed second parameter
> of btrfs_item_size() from btrfs_item * to int directly.
> So yes, the backport is wrong.
> 
> I'm not familiar with stable backport progress. Should I file a patch
> using btrfs_item *? Or just drop it?

If you think this needs to be in the stable tree, yes please backport it
and send it to us.

> The patch is related to  0c982944af27d131d3b74242f3528169f66950ad but
> I wonder why the 0c98294 is not selected automatically.

No idea, if you think that is needed to, please send it to us.

thanks,

greg k-h
