Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E2E9333C1F
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 13:05:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232941AbhCJMEu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 07:04:50 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:49985 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230435AbhCJMEW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Mar 2021 07:04:22 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 21D015C014B;
        Wed, 10 Mar 2021 07:04:21 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 10 Mar 2021 07:04:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=R80RvrtmzEoidFYOsoeEpHXdolL
        xYE2/IedsnmGQhZk=; b=M9XgqsssV+O8Foto/+nRRLMvS125G3310bWVa8EADJB
        L7ORlklqZIIwHsfpTDwoZ0DodwsatgpxySJR9LDpkfTc+Xgop5w+wZfXlr0eYSTM
        sqlmZiWYjHA6wiZnXc7E5GOhrP1/sjcbj8Ccwrd7Jnm1fJQ+YqXitIIZD1Ix4ljZ
        +uLbOElcgjJZM7jFLvrdlgcoePobOl0UxvqWL2QE6hfdWZ4x7hSAQ9cJYjkx/Xq+
        arVBtECVlTlv9EM0xc9XtMfBLNF8Egtt60aJ611H7Kiwpe0UHuI5a0kPmMdEyd+d
        BXjJYTSsM57/XdunT8C5QoaBWF3dyzwA2c/o8jINrBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=R80Rvr
        tmzEoidFYOsoeEpHXdolLxYE2/IedsnmGQhZk=; b=Xtk6Gn3d+RqLxW963EHQVM
        Hevxbx5adK4iX1OAtWx9qNHd1XqSeAoUsCZOAEg8xxH+LO/32lnQW3FiHQI7Gm/L
        oau90mo2zGTvdjQ/9TrTUS9vYXqGAe1M6rNjhP0mX9y6F2w2aMtdnN2yDkuryLGT
        guo0cHFdkOZj4KPQWYEc63sRdzS5zEkSu7vMSYUn4PrrmKoeZD+AmVl/eqaNW/v0
        ASCCaTzfJ/oB7CQsvkkUk7vLC2vPhuS1F61epviJys5jtFA+BRegJgywsYpNX7Qj
        TVIbzmsYEDWTEBZNFZZwXcHMJyt055YF1qn0VCrQln/kSNmLzNJ0UZw8Udhut2Qg
        ==
X-ME-Sender: <xms:xLVIYITGVduwiq4ilZ3sT4VcZXzmqmfqBupEJSFPlARw4EGi7oTY3g>
    <xme:xLVIYFw6hjWHZxR3IdN7wQKe2vffzcqdpPRUunUfOyyrxFj81fnepY_DmAl4Ckkgg
    Oj6TXzdmQA2Xw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddukedgfeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:xLVIYF3Zxe5tO3DH_xzBg1BhIMXIQp9SYFy0Kk2tmrG7WL2CotRduA>
    <xmx:xLVIYMCGJrgYrxyY5FbzEa1I2Hdgc2W50B85KU9UecrNlanjp2sVYg>
    <xmx:xLVIYBiku_oJqSIZ1klYrPSW-YG6yd5cR9Cx3enpjBCuB09kemnClg>
    <xmx:xbVIYBLlP__irhMj0oRMlU1sVwm85X7gZMmCkds1q6DnzwaYHBccnw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6FDC51080063;
        Wed, 10 Mar 2021 07:04:20 -0500 (EST)
Date:   Wed, 10 Mar 2021 13:04:18 +0100
From:   Greg KH <greg@kroah.com>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH stable-5.11 0/9] stable-5.11 backports
Message-ID: <YEi1wsm4UJlKhGOS@kroah.com>
References: <cover.1615375332.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1615375332.git.asml.silence@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 10, 2021 at 11:30:36AM +0000, Pavel Begunkov wrote:
> 5-6/9 were forgotten to be marked for-stable. Others are
> 5 out of 6 failed to apply + dependencies.
> 
> Jens Axboe (3):
>   fs: provide locked helper variant of close_fd_get_file()
>   io_uring: get rid of intermediate IORING_OP_CLOSE stage
>   io_uring/io-wq: kill off now unused IO_WQ_WORK_NO_CANCEL
> 
> Pavel Begunkov (6):
>   io_uring: fix inconsistent lock state
>   io_uring: deduplicate core cancellations sequence
>   io_uring: unpark SQPOLL thread for cancelation
>   io_uring: deduplicate failing task_work_add
>   io_uring/io-wq: return 2-step work swap scheme
>   io_uring: don't take uring_lock during iowq cancel

Thanks for these, now queued up.

greg k-h
