Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B671D6416D4
	for <lists+stable@lfdr.de>; Sat,  3 Dec 2022 14:19:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229521AbiLCNTp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Dec 2022 08:19:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbiLCNTo (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 3 Dec 2022 08:19:44 -0500
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89BE52FA7B
        for <stable@vger.kernel.org>; Sat,  3 Dec 2022 05:19:43 -0800 (PST)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 262B35C00C2;
        Sat,  3 Dec 2022 08:19:41 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Sat, 03 Dec 2022 08:19:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1670073581; x=1670159981; bh=SizABY2/1f
        NhqB7GS1vNPEflme9clJsWe5fz9hJdhqE=; b=E/5gzWKsZYQN2gs7vt80ZW1//l
        T4ygfPuiOAahrg08En7ZZj2/tvgDxVvrcVjKve4Q2HpLviTw0IK72jm5bXohBn07
        NFS/14xl0Jhwuw/i1oiEEZfkoedMLm/OYRAIycNcTeP8jtWOJ/DDtcnHnvDYfG11
        A7pugirD5+O5Jpoqx2CYP2K7LfTndJd0aEXzRWnCCe/QMOxoXcyggw3lGZkBLrTo
        UPAXxrFDitXqolWOoAYWU0Dn1VDgzkuK1DWdsVfufAHNKEvsWBEio4hiALcdFbnM
        uVbPcdQ/is8Vjoww/3+BY91Kfv1zOkzrz4xOLuL1YUvIu6OPVFyC/DRxyBvA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1670073581; x=1670159981; bh=SizABY2/1fNhqB7GS1vNPEflme9c
        lJsWe5fz9hJdhqE=; b=QWyrm5KhItvQpUue/r6OG70Zw+AJ68JuPzV7Igdkgz6d
        YdMfvOsxxAmuo5L4zEq86dhNKeUCjvgnFqiZ+Ovb1YpI9XED59JWv/W7BBZy3s7g
        0NiCjBzOA/XnWtZBK8xXup8B93Ld0y0g3r/esQeRxad70uG3uFudspW8ZP4WdURA
        mVFiN2nTJgQn0KaOumli2DOrerhFVT1RwytVmQo1j4XC2GMGjQoK87Xh+XENVRPc
        5Foq24Iq7X4lO3WT7LRdOBSqPu/lvQKDCLrCTSJ3cktnBec0G2btDJFSqL1a7PMb
        IiOZEu40zragd21KedlouZeo4D2Ji+n6jACoZUVzvA==
X-ME-Sender: <xms:7EyLY05BiPgZigLfnZpIXe5pV5cv0EbCKQ7YQJF657NEcDww5kanoA>
    <xme:7EyLY17-jVwJQ9EYmwtSa6anwvc4Z_Dlz2hruynb5VVbK42OjMVQkVZfipAZ8jaiN
    0bg9MEyGIvk9w>
X-ME-Received: <xmr:7EyLYzcaBvVt4ZELgfTYAzqilq-feZqRWvlQaEe13gCIs7vJx9T62owbgoGCxoaAzfjgpYvB_5IXkMNkLtNYDQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedruddtgdehvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeehgedvve
    dvleejuefgtdduudfhkeeltdeihfevjeekjeeuhfdtueefhffgheekteenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:7UyLY5L_vfB-3y32UzJfSZbbXLH4krrq9Ix5OClooSHr9rF4btfvMA>
    <xmx:7UyLY4LBXqefrDLH4MAia6P4p8tSK-42C0oSyrIKBkHOWu7NPUXpsw>
    <xmx:7UyLY6zM8QXWeOi-mwIH-1tnhAeM6BtKyUDE_ndU5HUaXbpgd0leBQ>
    <xmx:7UyLY9Ejgnfc91O0B_Ssk0yfIfIC73jI0mbgbb72ZWDq36sIUGzflA>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 3 Dec 2022 08:19:40 -0500 (EST)
Date:   Sat, 3 Dec 2022 14:19:35 +0100
From:   Greg KH <greg@kroah.com>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH stable-5.15 0/5] io_uring/poll backports for 5.15
Message-ID: <Y4tM55qaauRLw+GV@kroah.com>
References: <cover.1669990799.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1669990799.git.asml.silence@gmail.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 02, 2022 at 02:27:10PM +0000, Pavel Begunkov wrote:
> Recent patches for io_uring polling.
> 
> Lin Ma (1):
>   io_uring/poll: fix poll_refs race with cancelation
> 
> Pavel Begunkov (4):
>   io_uring: update res mask in io_poll_check_events
>   io_uring: fix tw losing poll events
>   io_uring: cmpxchg for poll arm refs release
>   io_uring: make poll refs more robust
> 
>  fs/io_uring.c | 57 ++++++++++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 50 insertions(+), 7 deletions(-)

All now queued up, thanks

greg k-h
