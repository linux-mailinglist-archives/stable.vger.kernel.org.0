Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4659723DFED
	for <lists+stable@lfdr.de>; Thu,  6 Aug 2020 19:55:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728190AbgHFRzZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Aug 2020 13:55:25 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:47567 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726094AbgHFQ2v (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Aug 2020 12:28:51 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id DD4E45C00B9;
        Thu,  6 Aug 2020 08:42:23 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Thu, 06 Aug 2020 08:42:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm1; bh=k
        /oYHigm5ltMM6TCZ6JdWua9TtSkFYq1K/Gc18YYZus=; b=Tjx3HiGIcuhNCHxQM
        HyUCw3fyXmaTgB1k9kF8viQNMHbx0SYgrBmXmOD5sXFtlkULz3zltHNDyVMP0Lxu
        fzOw6j4VWcKWMEfoMoPY0uE+lDCb6JJr9VU40DQd/3gRPIj2nWyrwnpUsNBggluk
        LdyGG91nhEW8mkYFfgXngd9PBgOC6bCyHUIsaFPMgE3kEAeMN0R6JBabesL4KC9M
        1GpU709y3UJ+bhN7MILL8DzwSg2Pt3BHTKjxWafe6FyoNTReRtI6AP4xoldzbl/v
        vgPcaSXhYI7B3I6zQm1ogXYlId1qC+2gCK/rCamL2ZEGIVvmIRKDs4gJ63yxU51T
        9wOsw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=k/oYHigm5ltMM6TCZ6JdWua9TtSkFYq1K/Gc18YYZ
        us=; b=WNYLthCFcfdagx9wC6rmR1YDWTQ16n0s5e6EAY/CdDLhqtmF/C955nM7k
        Ezgv8dlVP7DNDxkOPr/PK0nWbZf/p5JprZHmZh51yfcve5zPE18a31NE4+rQLtGo
        xdIcI/nvI3pQH+VpAhq6qVJTPEUVnPOIKrzk7mBKNDZoBS2w0SSehtczMt8HfgtG
        7D1UJL+CUkXP54WA0VdTFRdVl3h8Y6siTN/7eO/uuxnpccHl426M7rLhnSqdfHus
        aAJx4/1jicdue9D3nUZoaB+n7yXxNtA3UwRyYr++3rF6Lob1XdQaQmS1iy/jrpHn
        7ozdYexF2/7XskDgwzqit8GCBkt+g==
X-ME-Sender: <xms:r_orXz4dR0fCtNeqBs3iuMiFGo8xBDd7-QCZhRg5D0xdge7qC5l5jQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrkedtgdehiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepfffhvffukfhfgggtugfgjgesthekre
    dttddtjeenucfhrhhomhepifhrvghgucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheq
    necuggftrfgrthhtvghrnhepueehkeehlefffeeiudetfeekjeffvdeuheejjeffheelud
    fgteekvdelkeduuddvnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushhtvghr
    ufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:r_orX45Dqz5_yZTeCkIZcqhadBRy1tNQDZxxAdSeayddZDHRRkE0ag>
    <xmx:r_orX6ev5e_6JfUpcXJkcvFOG5dlg5qVzH042bUb5YIGL4tkHEdqJg>
    <xmx:r_orX0JAc4UEidVCey9cXQsa4UFiUoRbqaqgH_E_2Kpzv_4o2FpLPw>
    <xmx:r_orX_9NztIlqn63SEIJCbAqASABoVxa0kP6Zs_ULcQD6_ZdD_L_Jg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id A373430600B1;
        Thu,  6 Aug 2020 08:42:22 -0400 (EDT)
Date:   Thu, 6 Aug 2020 14:42:34 +0200
From:   Greg KH <greg@kroah.com>
To:     =?utf-8?B?5aec6L+O?= <jiangying8582@126.com>
Cc:     tytso@mit.edu, adilger.kernel@dilger.ca,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        jack@suse.cz, stable@vger.kernel.org, sashal@kernel.org,
        wanglong19@meituan.com, heguanjun@meituan.com
Subject: Re: [PATCH v6] ext4: fix direct I/O read error for kernel stable rc
 4.9
Message-ID: <20200806124234.GA2876088@kroah.com>
References: <1596715264-3645-1-git-send-email-jiangying8582@126.com>
 <d00c156.5be6.173c3a83482.Coremail.jiangying8582@126.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d00c156.5be6.173c3a83482.Coremail.jiangying8582@126.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 06, 2020 at 08:04:07PM +0800, 姜迎 wrote:
> 
> 
> 
> Hi all,
> This patch is used to fix checkpatch error on kernel stable rc 4.9.
> I have built pass and tested pass, thanks!

Now queued up, thanks!

greg k-h
