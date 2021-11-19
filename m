Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2198456F03
	for <lists+stable@lfdr.de>; Fri, 19 Nov 2021 13:46:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235342AbhKSMtD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Nov 2021 07:49:03 -0500
Received: from wnew3-smtp.messagingengine.com ([64.147.123.17]:44475 "EHLO
        wnew3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235328AbhKSMtC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Nov 2021 07:49:02 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailnew.west.internal (Postfix) with ESMTP id CCFDD2B017C0;
        Fri, 19 Nov 2021 07:45:59 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Fri, 19 Nov 2021 07:46:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=TqzbqJgsp3679OQmdBXFlQSiQsI
        NdU6mFESgQ8pHy3U=; b=P8yWYMJ4ldNfTJ1Uuo/qe4HtjRk30T/ijkHDqSk9qF0
        S4l2QPD1WZzmBkRy953FXIfsuigdU5pCXxBz++mCwAt9AdGLwvfmDt+TSDJ6FWCA
        Xg0HjeVwidxiXtJWf39w8XziCUJlTAqux33qyEakDhmnB/eUWo/3ZI5DhMSbszWg
        OggJuPGN2zsSBABArK64S9g3DLsMkiO4/QvI4bAQyBwt6oqpmkN4Sk8JR0Mqfa/8
        4Bq/BHLFUH37GNNoFPO0+bDj38IL5vQnUSiTOaxTpJ5dIL2+R5JYN+zYcV3/hsM8
        HFnDM2XHL8dhTsPeUhj47/YPs6d3T/+bsQzSZnP92Aw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=TqzbqJ
        gsp3679OQmdBXFlQSiQsINdU6mFESgQ8pHy3U=; b=LAZoalZlbqjrxnrZPiyVD+
        AEr79KUmS1vQJq8Jfwx0nnP8G2wChf8PTMIZSTfZiVl1xCj3WbkCflWAsv12Fk31
        /uXfcmICNDWlPlHGkUC0xZQbPiqADiM/Pl2v/4BnpRniVhGHzfzhoVeSuWFS4+rh
        Qxjo5KT5HYte09m3n6vBmTAvnHzX4EPYetFb5QsrmNHKsXSftgorecoVMJQVjjYY
        Gl11W3wUWj8/VYN5i3MAH+XfLv0tEPlkXDAVbK/Viq1s79dK+UiQQQemRNBnk1DE
        ueeqDS6nxLZVSvMqJhmnMoUnl0U9l0LNKDNrkkYQJhrw4wRgbYqgsyk/1lmfzOJQ
        ==
X-ME-Sender: <xms:hpyXYeg0V9SL-cv7DKbqw_xfZD4TmbhN56HVHyWU2OXEgzrgR-YYXw>
    <xme:hpyXYfASgACjIBuvl-OAl0yhayEjgjJtYiDkX5eD_SJtaSa2m9AaYfeZlK04sHomo
    OTgY3EccsiFtw>
X-ME-Received: <xmr:hpyXYWEILNQLDQXs_tQQfMNdtCAureGe4KzBPKxRP8X9Dl1sPa4LwU9ZZ3DumyHqZgVCYpS9IL_0wcw-j8Vfu971eOmGzL9W>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrfeekgdegvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuheejgf
    ffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:hpyXYXQjlgK3s6HWctahE0FxOKgc-4AdOdul6OJso96Pn2m4EdUbvg>
    <xmx:hpyXYbwU-4C43CJN-pN9qzpf0HU8uRUfQfC11W9PI6Hk_OwfZrT05g>
    <xmx:hpyXYV5YvyW7me1XhxAWDEW_ECJzSWj1UBMpNVp760HTGe-sm2G5rg>
    <xmx:h5yXYQKIZWp-fAU1-jisda9eASqo99w6aF9niPuopxGIAR-OC1dFJ_w-GJk>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 19 Nov 2021 07:45:58 -0500 (EST)
Date:   Fri, 19 Nov 2021 13:45:23 +0100
From:   Greg KH <greg@kroah.com>
To:     Tadeusz Struk <tadeusz.struk@linaro.org>
Cc:     stable@vger.kernel.org,
        syzbot+662448179365dddc1880@syzkaller.appspotmail.com,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        xieyongji@bytedance.com, Christoph Hellwig <hch@lst.de>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: general protection fault in bdev_read_page
Message-ID: <YZecY2gAFjoNtxZO@kroah.com>
References: <7e6c4c23-f071-f33b-7bd4-da11980d34c6@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7e6c4c23-f071-f33b-7bd4-da11980d34c6@linaro.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 18, 2021 at 03:08:06PM -0800, Tadeusz Struk wrote:
> Hi,
> This has triggered in 5.10.77 yesterday [1], and I was able to
> reproduce it on 5.10.80 using the C repro from android-54 [2].
> What happens is that the function do_mpage_readpage() calls
> bdev_read_page() [3] passing in bdev == NULL, and bdev_read_page()
> crashes here [4]. This happens in 5.15 down to 5.10, but it is fixed
> in 5.16-rc1. I bisected it to the first good commit, which is:
> 
> af3c570fb0df ("loop: Use blk_validate_block_size() to validate block size")
> 
> The root cause seems to be loss of precision in loop_configure(),
> when it calls loop_validate_block_size() in [5]. The config->block_size
> is an uint32 and the bsize param passed to loop_validate_block_size() is
> unsigned short. The reproducer sets up a loop device with the block size
> equal to 0x20000400, which is bigger than USHRT_MAX.
> The loop_validate_block_size() returns 0, but uses the invalid size
> to setup the device. The new helper changes the bsize param type to uint,
> and the issue goes away.
> 
> To fix this for the older kernels can we please have the two commits:
> 
> 570b1cac4776 ("block: Add a helper to validate the block size")
> af3c570fb0df ("loop: Use blk_validate_block_size() to validate block size")
> 
> applied to 5.15, 5.14, and 5.10.
> The first one needs to be back ported, but the second applies cleanly.
> I will follow up back ports for each version in few minutes.

All now queued up, thanks.

greg k-h
