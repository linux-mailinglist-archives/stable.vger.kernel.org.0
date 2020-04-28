Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 332241BB96A
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 11:03:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726956AbgD1JC5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 05:02:57 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:55073 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726271AbgD1JC5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Apr 2020 05:02:57 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id BE45E5C0195;
        Tue, 28 Apr 2020 05:02:55 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Tue, 28 Apr 2020 05:02:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=p8eNY0xnZNFtAr72xYZInG4PLoa
        Gm0XNLJTzn92LVy0=; b=QWOHAf8q/LDOeUq71TnWybRJl0K/Jfr540x/wM5Owej
        mgDhPzn5M8Bj+4lWqyVReHD54bx3S4mkj2GeSP+z1uHYyp9gvxvr7JWGfXu+rprC
        wg9H2KirKQL9U0YerpIIHVgdZ9/ZGWS/L4McFc46iem+tcZgmTeGC9MGk57YtVpt
        VV5J55HRLh//kc2rhKiKF8NsbaY7rclimQL0zE4RQXtM0hQGLocpH/xshdWrdMjv
        lvAHcthSCeHDkkhj1wCtD13BVrVyZqBUeeWTec6uctDRpVEUwLdRDB52cg/IuByb
        WN7Nzb6nLwwM2ja9VTwyu8Q2Ed7tSsA/S4L1wH8PkGw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=p8eNY0
        xnZNFtAr72xYZInG4PLoaGm0XNLJTzn92LVy0=; b=Edye47JG1WMcFNI10kojbg
        xQvC2ODZR5WIPa10dLqivksIAunNMq9sO+woS9V+ofw7Y6gA7Zp3n/2gkAVWGV7H
        iPemtjgwMcQGczaSq2P1tvK/1pTMMtCjEmUB8B0hSyw1ht0IgYJxpebWUj0d6Hrq
        XYCzAYBOh5YVHp5HHcYoU70eDcLHfq4Zrh4lzCmepT75rnTCVCyz/PJKpmGbyj1/
        7ygdNb6feVZitQPnjXuKr9xQSO14eS8PFx7Zxcf0srQd/Yzsi8TcsS5Mz7q5Rd//
        gBH/TfggPwWOKno8q9zFYpC7ngUScSFsl3HIW1CGigvlbQI1PohUAgICuWqMk3LQ
        ==
X-ME-Sender: <xms:P_GnXtEUH6EGtRWiBf-u2kQg98o8Utht1svmekSa6lKlozupk8kn_A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedriedugdduudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppeekfedrkeeirdekledruddtje
    enucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgv
    gheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:P_GnXqOtRhAcyxqWu9bmcN-LWBlNPY7f5VaZQgIVJDMdMRO5uSYBCg>
    <xmx:P_GnXui_D44xYwhrQtpeH0Anvyu34-GW2t3KSmtPiRh6nFWhLq-XAA>
    <xmx:P_GnXq2tUNH3gBVlRt39u1g7_lZK2BjzN0qTQTcHudYEaTUypejhMQ>
    <xmx:P_GnXrfl0VKErdyagWS7UsQDDsqwhG7VQ2Jd7aG8LN0kHvyfKWTTfA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 38A473065EA1;
        Tue, 28 Apr 2020 05:02:55 -0400 (EDT)
Date:   Tue, 28 Apr 2020 11:02:52 +0200
From:   Greg KH <greg@kroah.com>
To:     Suraj Jitindar Singh <surajjs@amazon.com>
Cc:     stable@vger.kernel.org, sjitindarsingh@gmail.com,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH STABLE v4.14.y 0/2] xfs: Backport two fixes
Message-ID: <20200428090252.GA1001680@kroah.com>
References: <20200424230532.2852-1-surajjs@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200424230532.2852-1-surajjs@amazon.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 24, 2020 at 04:05:30PM -0700, Suraj Jitindar Singh wrote:
> This series backports two patches which fix known bugs in the xfs
> filesystem code to the v4.14.y stable tree.
> 
> They are each verified by the xfs tests xfs/439 and generic/585
> respectively.
> 
> The first patch applies cleanly.
> 
> The second patch required slight massage due to the last code block
> being removed having changed slightly upstream due to rework. I think
> the backport is functionally equivalent.
> Only thing is I request comment that it is correct to use the following
> error path:
> 
> 	ASSERT(VFS_I(wip)->i_nlink == 0);
> 	error = xfs_iunlink_remove(tp, wip);
> 	if (error)
> >	       goto out_trans_cancel;
> 
> The old error patch out_bmap_cancel still exists here. However as
> nothing can have modified the deferred ops struct at this point I
> believe it is sufficient to go to the "out_trans_cancel" error label.
> 
> Darrick J. Wong (1):
>   xfs: validate sb_logsunit is a multiple of the fs blocksize
> 
> kaixuxia (1):
>   xfs: Fix deadlock between AGI and AGF with RENAME_WHITEOUT
> 
>  fs/xfs/xfs_inode.c | 85 +++++++++++++++++++++++-----------------------
>  fs/xfs/xfs_log.c   | 14 +++++++-
>  2 files changed, 55 insertions(+), 44 deletions(-)

All (including the 4.19 patch), now queued up, thanks.

greg k-h
