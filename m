Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5867EDD39
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 12:02:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726364AbfKDLCn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 06:02:43 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:49257 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726071AbfKDLCn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Nov 2019 06:02:43 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 5A3AC20A3C;
        Mon,  4 Nov 2019 06:02:42 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 04 Nov 2019 06:02:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=PD/nXFuZxFeP4A6XthDcFbpgf0f
        KT9V6esc+3nPt8e8=; b=HBaTfVxqXAb5dlc26dyZkkGwHjjxtOxCks3jd+Fnoby
        bhRQiHe6N4mLAv94PvUfgb+5JdGigghETu6zWKz0QYzXSDA7riUc7AB2Jf0CiWhi
        y9RYNnEiWSgjJ8eF0N9dskBBYWvbO6y2uUR5gbBUc9o0f1xoWHhX9znYhopMXJSw
        823elYB2vv2uGrAkQMAcA/lwFQbQFH0YTC4vvza4kCXVINowp38sMVwyAgN7MqsL
        7Op0Irr/tZnI6+4Yje3bITuG+44lYVTjZdJtM33scsBoWmvcnHyCfZ7ZV3bvxGrc
        a+aaR5LO43w/IYvmDzGM9eJ66BuP0EApqwwu8Gluu8w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=PD/nXF
        uZxFeP4A6XthDcFbpgf0fKT9V6esc+3nPt8e8=; b=Hb08SMpDvgXSFS2Z7o89pL
        wadGLWEIrjY4hU/Jx51fQWXYh7ai3LTnAtNFz4UjBswJsW83O7g3tvz+HCVkKL+f
        NH6yTncDCmIbi28RiNX+Ot/UZRr8N5G0bzptc4JMFcjPOQGfvlrTQbYHS4EAXFW2
        Ds4LY6RAMdM6pE8srD3FreTAm1QyplJj2Aw4Jba0ZTUyPCIBLSV8gJ5pWGMkeVKs
        l+Udtw1UXEQcnXBJgb6+cK6J1bxykTU95rDyKi6bVKID7BVwEaIRUIs0GAgT5EOJ
        SSfIeF4M3JyeWxXLV4mBqxh1JfFkbEXv08ruair8CIFfy/FA7PVYwEbMIZmWwwBA
        ==
X-ME-Sender: <xms:UQXAXXP_JKsoqPfqfgttS2mPUQuafLDmUOlWNPbsRHMQm3cnXH1hsg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedruddufedgvdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppeekfedrkeeirdekledrud
    dtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecu
    vehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:UQXAXc0fGcLbOyz_yiYPR6jtBsfBzFrKeTdAHLiLzkrRwGEYObP6GQ>
    <xmx:UQXAXeF4b7GNKku_XvOX4VJhMVa7IW70fvZmpi6Skokh4J4UjeTUNQ>
    <xmx:UQXAXZ6rZq4a4UO1mJfDaav-OizEv_yoFczrFP7Rv135dftUwOGvUg>
    <xmx:UgXAXbEynlylKYMtKqnGE__rgKGWw6b9_eux6LeMchsZIlWCf7XnpQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 71C6D80063;
        Mon,  4 Nov 2019 06:02:41 -0500 (EST)
Date:   Mon, 4 Nov 2019 12:02:37 +0100
From:   Greg KH <greg@kroah.com>
To:     Alex Lyakas <alex@zadara.com>
Cc:     linux-xfs@vger.kernel.org, stable@vger.kernel.org,
        vbendel@redhat.com, bfoster@redhat.com, hch@lst.de,
        darrick.wong@oracle.com
Subject: Re: [STABLE-PATCH] xfs: Correctly invert xfs_buftarg LRU isolation
 logic
Message-ID: <20191104110237.GD1945210@kroah.com>
References: <1572535975-32634-1-git-send-email-alex@zadara.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1572535975-32634-1-git-send-email-alex@zadara.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 31, 2019 at 05:32:55PM +0200, Alex Lyakas wrote:
> From: Vratislav Bendel <vbendel@redhat.com>
> 
> [upstream commit 19957a181608d25c8f4136652d0ea00b3738972d]
> 
> Due to an inverted logic mistake in xfs_buftarg_isolate()
> the xfs_buffers with zero b_lru_ref will take another trip
> around LRU, while isolating buffers with non-zero b_lru_ref.
> 
> Additionally those isolated buffers end up right back on the LRU
> once they are released, because b_lru_ref remains elevated.
> 
> Fix that circuitous route by leaving them on the LRU
> as originally intended.
> 
> [Additional description for the issue]
> 
> Due to this issue, buffers will spend one cycle less in
> the LRU than intended. If we initialize b_lru_ref to X, we intend the
> buffer to survive X shrinker calls, and on the X+1'th call to be taken
> off the LRU (and maybe freed). But with this issue, the buffer will be
> taken off the LRU and immediately re-added back. But this will happen
> X-1 times, because on the X'th time the b_lru_ref will be 0, and the
> buffer will not be re-added to the LRU. So the buffer will survive X-1
> shrinker calls and not X as intended.
> 
> Furthermore, if somehow we end up with the buffer sitting on the LRU
> and having b_lru_ref==0, this buffer will never be taken off the LRU,
> due to the bug. Not sure that this can happen, because by default
> b_lru_ref is set to 1.
> 
> This issue existed since the introduction of lru in XFS buffer cache
> in commit
> "430cbeb86fdcbbdabea7d4aa65307de8de425350 xfs: add a lru to the XFS buffer cache".
> 
> However, the integration with the "list_lru" insfrastructure was done in kernel 3.12,
> in commit
> "e80dfa19976b884db1ac2bc5d7d6ca0a4027bd1c xfs: convert buftarg LRU to generic code"
> 
> Therefore this patch is relevant for all kernels from 3.12 to 4.15
> (upstream fix was made in 4.16).
> 
> Signed-off-by: Alex Lyakas <alex@zadara.com>
> Signed-off-by: Vratislav Bendel <vbendel@redhat.com>
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> (cherry picked from commit 19957a181608d25c8f4136652d0ea00b3738972d)
> ---
>  fs/xfs/xfs_buf.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Now queued up, thanks.

greg k-h
