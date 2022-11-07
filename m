Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6B3661F2D9
	for <lists+stable@lfdr.de>; Mon,  7 Nov 2022 13:22:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232080AbiKGMWN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Nov 2022 07:22:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232024AbiKGMWM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Nov 2022 07:22:12 -0500
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF498D62;
        Mon,  7 Nov 2022 04:22:11 -0800 (PST)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 11E815C0185;
        Mon,  7 Nov 2022 07:22:11 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 07 Nov 2022 07:22:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm1; t=1667823731; x=
        1667910131; bh=XvW4y+OvD3m2wCaNiof4U12PyYREji7eszG/mpI1LJg=; b=d
        XvlOoXdkOt9jxdzFm/kSPsHuEJuybuMgQW6wLPlscY6S5UrS/kYnkx1c6ayyTBXs
        /DPh6uP2/Sha6g/j3EsZpJ91X+Dy/T1PrLzLIbZ47mk4kSVQhLwZapUxiZQjBWKN
        ywNnsXwRBw7VbeuaOmkiz4k6RBEn8tkSvWGFrJ5qVqortCg/tvbWzVTxbg3rs8/h
        PoOl5Pk6XHK5Ii/LHSbMYm4b7kesM7GaNhHqDwZWST3sJ26DMyweNfjVln27Wuoc
        iIxauQttHip5yxyV0PCTScnfjs+bQ8BdKwYF0nDGUaZEX6I2blugluLjk+yfpcJI
        tmg43KmDVrYpCbjDbVSrg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1667823731; x=
        1667910131; bh=XvW4y+OvD3m2wCaNiof4U12PyYREji7eszG/mpI1LJg=; b=w
        meYzvu4h+miaHQgps7+s+bM5+JX9pnBCo32ruyLkrUlfm4LWbs4Cd76V0Qc4+l3i
        eELSgmiwtfaKYOtD2NcHVCG6Txxs3Vvbk9ppOSQV9ANAtHoax76mMbpq95VT/8ET
        onY7Jv2qXHiWzMagw7Pxt20azD8pTVbX36rcpzff4rSv4rJDtUn2S4K5nP1Qze9B
        Bg00/nvOamcgqcFGTveFmr3DHIfIS3bz20Rk/Tt1JYyg5HVouzKy9YsGKSuv3JJT
        Dky9mxtztmtqQr8nQX5gLXfyFEHMZXWQ5t4VGG5T7SdXg1rhPRfmGCSBsdreUx6q
        g6c6MsXrp3k4vDVgKPZLQ==
X-ME-Sender: <xms:cvhoY07i2M1xQ9o1Dl9j1nJ5Fkr4olQmZQQ8mdwtDKFmZVHZF5LfGw>
    <xme:cvhoY16LiAyR8eJ3ZaUZ6HUe2hKrS2F2jNVVQZzGskDq4I4gIDRsxrAKS8WVMAz_E
    iK5w9NCXjzWvg>
X-ME-Received: <xmr:cvhoYzcjYvmvLvvgZuOnBlujXoXPGtwjUFYSFunJq-k0wcr16yBq8vr6d-Tw9IwtiuY01pnOT-mLu4w9RcUbAVTdLdEqywkh>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrvdekgdefkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtugfgjgesthekredttddtjeenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepleekhe
    ejjeeiheejvdetheejveekudegueeigfefudefgfffhfefteeuieekudefnecuffhomhgr
    ihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:cvhoY5LUA8jU37n3O_TXdPulu42ZXniMtom4TE69TVhZF8EH0QgJ1Q>
    <xmx:cvhoY4JyeGltXpyD1DCAMIN9JvfxZzj88GoEXV0W6IMRfMPnPQLf1Q>
    <xmx:cvhoY6wp6OtnGLChppzrMeyrAur7h5j11wVM5etQ8P5qKgF4hmN8IQ>
    <xmx:c_hoY1CpyOvhlV82Kv7SD0pvO-aTFTlMxrIdUmOBLFxucdm5KhU7vQ>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 7 Nov 2022 07:22:10 -0500 (EST)
Date:   Mon, 7 Nov 2022 13:22:07 +0100
From:   Greg KH <greg@kroah.com>
To:     fdmanana@kernel.org
Cc:     linux-btrfs@vger.kernel.org, stable@vger.kernel.org,
        Filipe Manana <fdmanana@suse.com>,
        =?utf-8?B?0JzQsNGA0Log0JrQvtGA0LXQvdCx0LXRgNCz?= 
        <socketpair@gmail.com>, David Sterba <dsterba@suse.com>
Subject: Re: [PATCH for 5.15.x] btrfs: fix lost file sync on direct IO write
 with nowait and dsync iocb
Message-ID: <Y2j4bx15xkJx42Kh@kroah.com>
References: <3046b907b319071aef61d0a1b3dfaf0f71f2c9aa.1667582440.git.fdmanana@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3046b907b319071aef61d0a1b3dfaf0f71f2c9aa.1667582440.git.fdmanana@suse.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 07, 2022 at 09:41:35AM +0000, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> commit 8184620ae21213d51eaf2e0bd4186baacb928172 upstream.
> 
> When doing a direct IO write using a iocb with nowait and dsync set, we
> end up not syncing the file once the write completes.
> 
> This is because we tell iomap to not call generic_write_sync(), which
> would result in calling btrfs_sync_file(), in order to avoid a deadlock
> since iomap can call it while we are holding the inode's lock and
> btrfs_sync_file() needs to acquire the inode's lock. The deadlock happens
> only if the write happens synchronously, when iomap_dio_rw() calls
> iomap_dio_complete() before it returns. Instead we do the sync ourselves
> at btrfs_do_write_iter().
> 
> For a nowait write however we can end up not doing the sync ourselves at
> at btrfs_do_write_iter() because the write could have been queued, and
> therefore we get -EIOCBQUEUED returned from iomap in such case. That makes
> us skip the sync call at btrfs_do_write_iter(), as we don't do it for
> any error returned from btrfs_direct_write(). We can't simply do the call
> even if -EIOCBQUEUED is returned, since that would block the task waiting
> for IO, both for the data since there are bios still in progress as well
> as potentially blocking when joining a log transaction and when syncing
> the log (writing log trees, super blocks, etc).
> 
> So let iomap do the sync call itself and in order to avoid deadlocks for
> the case of synchronous writes (without nowait), use __iomap_dio_rw() and
> have ourselves call iomap_dio_complete() after unlocking the inode.
> 
> A test case will later be sent for fstests, after this is fixed in Linus'
> tree.
> 
> Fixes: 51bd9563b678 ("btrfs: fix deadlock due to page faults during direct IO reads and writes")
> Reported-by: Марк Коренберг <socketpair@gmail.com>
> Link: https://lore.kernel.org/linux-btrfs/CAEmTpZGRKbzc16fWPvxbr6AfFsQoLmz-Lcg-7OgJOZDboJ+SGQ@mail.gmail.com/
> CC: stable@vger.kernel.org # 6.0+
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
> 
> The commit in the Fixes tag was backported to 5.15 stable releases, so
> this patch is meant for 5.15.x and was tested on top of 5.15.77.

Now queued up, thanks.

greg k-h
