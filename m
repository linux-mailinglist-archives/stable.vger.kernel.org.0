Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B05E4BB569
	for <lists+stable@lfdr.de>; Fri, 18 Feb 2022 10:22:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233265AbiBRJWN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Feb 2022 04:22:13 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233467AbiBRJWM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Feb 2022 04:22:12 -0500
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com [66.111.4.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D23B2C12E
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 01:21:54 -0800 (PST)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 6278F5C032E;
        Fri, 18 Feb 2022 04:21:52 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 18 Feb 2022 04:21:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm3; bh=DgI7RoIgCzUtmx6H7PnK5Q2Jk4f1gRg6tBy5QI
        ZLfSI=; b=oun3aAJhg5AiGpi9iNC5FEZl+AB3CPXrC/og7jE4vbdH/b+T807VKX
        qPICc7GrgsR/MYADke/xmVguoylkARjhSMoC/MIeHEqt6cX/gyCCfiWOki4vyLGR
        Dj5o9LNnc5ELmiX2ZD5x5XwaQjzIjQ0WgH4Qdb8dghF1Hm1WKzWdz86KCnzm4VPq
        /QGrk7DPNKhicsjoJLlTV196KY/RRcQ4WrecRSSW0O04yYJzVcyBWlAD1MufxBsv
        Dj5QvZ1AMd/4OIFpTBLX2QF+GzMRlYnf052clTFL0ILjKh+YAWLKLqYUXCZvWTeK
        4E2l1yaAMREcqEDp541Gcs1FVYq31lNw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=DgI7RoIgCzUtmx6H7
        PnK5Q2Jk4f1gRg6tBy5QIZLfSI=; b=Y9uHHLGAVQa0Irvt5c9WaN7DelIm4ztmP
        82pBu832KyYftNEhWMUcsakLK+GkBG5eFYWhoP34JBANWIG5kpTJevA2lCoxO6LC
        0FldpqBvIkLoQygLJ3nyRVL1lO3KbJULT2np6zv8NusBa6I3nw4gUL8MYfPPQgVX
        M9mAt0aximw53Ghgs4MoaFIjz2qMl3eXoPHaUjHRACMRgyB0G8Q6AW5TucMaigCj
        a35xXXPWuGII8R9ymjqOPUOcQp7/hH+mcxDZJI26uGYVrJ6DdisZk2e785tWTVGZ
        Q7N/gxhcLGFRbvALwS85aXcTXCjsgv62AL2QRE5ohIoBeLRm0LYtQ==
X-ME-Sender: <xms:LmUPYkBTJdoZg_TTgo6Y2vFRczHsCLyHS7wDvunAyAtUKSCAkMxaxg>
    <xme:LmUPYmgOpvGy2JAo_Tc__GAhRKnkOcVaeJYZ3d3vnqX7ISDCUYp9FCuPHlZQnJrNC
    xQlrjR1YvveUQ>
X-ME-Received: <xmr:LmUPYnnq5YNgXDuWyVS8mToJLWnz08lHBxtEmj8rKHClih7UkEMbiVV3wbWEQyvi-6KyQzgx0Z2mwvLpAJ0621e5l2xxyLuy>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrkedtucetufdoteggodetrfdotffvucfrrh
    hofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgenuceurghi
    lhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurh
    epfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcumffjuceo
    ghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeeuleeltdehkeelte
    fhleduuddvhfffuedvffduveegheekgeeiffevheegfeetgfenucffohhmrghinhepkhgv
    rhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilh
    hfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:LmUPYqz3_BN_eeBKoVPkgLcpPUrQ7hVVhQYgXZlUqdnY5OkvizrR2A>
    <xmx:LmUPYpTADYCP4vIKqKvSkelNekI4VJDt5jxAmJHmCfnrgGsbIX4tnw>
    <xmx:LmUPYlaTNkKMy7Dt5cvGPW0vM9G0Hjp-hYuMPvv-NCYzHQ_l2JhJoQ>
    <xmx:MGUPYoEIjhLW_PX_aZM-F-bn2JFayYzu4mkv6f8M7S9wJCbIFBrxaA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 18 Feb 2022 04:21:50 -0500 (EST)
Date:   Fri, 18 Feb 2022 10:21:48 +0100
From:   Greg KH <greg@kroah.com>
To:     Leah Rumancik <leah.rumancik@gmail.com>
Cc:     stable@vger.kernel.org, Zhang Yi <yi.zhang@huawei.com>,
        Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH for 5.4 1/3] ext4: check for out-of-order index extents
 in ext4_valid_extent_entries()
Message-ID: <Yg9lLNWNa8FLLhdC@kroah.com>
References: <20220217225914.40363-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220217225914.40363-1-leah.rumancik@gmail.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 17, 2022 at 02:59:12PM -0800, Leah Rumancik wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> commit 8dd27fecede55e8a4e67eef2878040ecad0f0d33 upstream.
> 
> After commit 5946d089379a ("ext4: check for overlapping extents in
> ext4_valid_extent_entries()"), we can check out the overlapping extent
> entry in leaf extent blocks. But the out-of-order extent entry in index
> extent blocks could also trigger bad things if the filesystem is
> inconsistent. So this patch add a check to figure out the out-of-order
> index extents and return error.
> 
> [Added pblk argument to ext4_valid_extent_entries because pblk is
> updated in the case of overlapping extents. This argument was added
> in commit 54d3adbc29f0c7c53890da1683e629cd220d7201.]
> 
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> Reviewed-by: Theodore Ts'o <tytso@mit.edu>
> Link: https://lore.kernel.org/r/20210908120850.4012324-2-yi.zhang@huawei.com
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
> ---
>  fs/ext4/extents.c | 21 ++++++++++++++-------
>  1 file changed, 14 insertions(+), 7 deletions(-)

All now queued up, thanks.

greg k-h
