Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5366F43C5A1
	for <lists+stable@lfdr.de>; Wed, 27 Oct 2021 10:53:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234422AbhJ0Iz6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Oct 2021 04:55:58 -0400
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:35087 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231566AbhJ0Izz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Oct 2021 04:55:55 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 516BD5803B4;
        Wed, 27 Oct 2021 04:53:30 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 27 Oct 2021 04:53:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=PzUhDvrokiFxCCXtfqy6BykaRKV
        weAU+HowWDW8QGL0=; b=YpMUtTsny7JWINhzaK679bCLmCPNrc/T9eQ7PHoSunH
        qYRGIt46z1Zt0TAex1dRhp84ZKwqLYlTrar7m1N9qqKGLFNFBtlEpeyT+bvuYjdE
        HnjA3LfdPJ0Uq1QVI+LvMyYlDAeecaBIBJ1Iuv6yBZqdoetEgRtDWcjgh7Onlq1t
        aLZhfyU8aARxDqxg3Pi5zJCEhJSv8wAWasBowv2kD/Mn7hMhEUyLuHbH9t/mypt+
        D5FoFbkxWo1UVL1tsQNZ1s3due5fzYJ4N9ewx/4PghTFFv2rxr6/g5yEa6h/G2JJ
        UAYWJfSSn5H4qTjmUykC37P5YeGzlnt+LTYWOrwdS9Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=PzUhDv
        rokiFxCCXtfqy6BykaRKVweAU+HowWDW8QGL0=; b=NR7V9MQgQgCZ2lBD++eQc7
        +NAUNEuKv0Wtu/wNZSXjmttnWWZ+/7senvxbISNxKy5a/J4cnm07GHS3GE0P0uCQ
        ZEyuMhofIEipDrP32PwT6OJyhx/fSL47Ht5ftjbD9uKbnfqACfvGIwFWMPypT69s
        TaLHd3Hs7tQjjLmgQpPu1D+Zrh9tXsRi7dqI/0agI+kMA7rLGo/uMysVCruLigCE
        klYau9naIefTgFPfiLFNu6lj9X9tr/RjbrNkmUFos/zeFsHuWoUuTfbj58wEJZvL
        CsMXZ5Q2v7xvyBA56bQaUKn3gTfjJOdTsIUCEvs6Q74E1/mrfvvhfUdf3Vrp2DDg
        ==
X-ME-Sender: <xms:iRN5YWTjrBOmOTJ435zd3pVR30-lYXXeorcdf3GrSt1LvAbTy8PUuw>
    <xme:iRN5YbzFDlUTVxhg3kAx7xlraVN5MIdntl8uyjVlQmxO_zgVfZPFknNHzJ295P9H-
    7BAlqc-1VqSag>
X-ME-Received: <xmr:iRN5YT1xocXXrKaoocwXzcDubalcevtCh2DaCODhwwWlP-z90agG-Y5-AImi_VMM8tzD_ghaWganiBxBvMAzpGK0TY6HrIW1>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvdegtddgtdeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeeuleeltd
    ehkeeltefhleduuddvhfffuedvffduveegheekgeeiffevheegfeetgfenucffohhmrghi
    nhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:iRN5YSBxmcASELrHn6WMCM55XucrHiD1ezruStC2L4iyJjyn8DVfsg>
    <xmx:iRN5YfiuuyL997t_JdfmRYtVfbYzlkvMT0eXeaC4y0--hsndKRgF9w>
    <xmx:iRN5YerrokYppWuS3DuwvYG_AuCMqrTN-JXUWe1qxkid8tpisVWX_w>
    <xmx:ihN5YUbvyyEWu4X4Co8RafkIanKuv8YD5nPQ_h9r_GqGdrT6DBAwlA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 27 Oct 2021 04:53:29 -0400 (EDT)
Date:   Wed, 27 Oct 2021 10:53:26 +0200
From:   Greg KH <greg@kroah.com>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     stable@vger.kernel.org, axboe@kernel.dk, asml.silence@gmail.com,
        io-uring@vger.kernel.org,
        syzbot+59d8a1f4e60c20c066cf@syzkaller.appspotmail.com
Subject: Re: [PATCH 5.10 1/1] io_uring: fix double free in the
 deferred/cancelled path
Message-ID: <YXkThoB6XUsmV8Yf@kroah.com>
References: <20211027080128.1836624-1-lee.jones@linaro.org>
 <YXkLVoAfCVNNPDSZ@kroah.com>
 <YXkP533F8Dj+HAxY@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YXkP533F8Dj+HAxY@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 27, 2021 at 09:37:59AM +0100, Lee Jones wrote:
> On Wed, 27 Oct 2021, Greg KH wrote:
> 
> > On Wed, Oct 27, 2021 at 09:01:28AM +0100, Lee Jones wrote:
> > > 792bb6eb86233 ("io_uring: don't take uring_lock during iowq cancel")
> > > inadvertently fixed this issue in v5.12.  This patch cherry-picks the
> > > hunk of commit which does so.
> > 
> > Why can't we take all of that commit?  Why only part of it?
> 
> I don't know.
> 
> Why didn't the Stable team take it further than v5.11.y?

Look in the archives?  Did it not apply cleanly?

/me goes off and looks...

Looks like I asked for a backport, but no one did it, I only received a
5.11 version:
	https://lore.kernel.org/r/1839646480a26a2461eccc38a75e98998d2d6e11.1615375332.git.asml.silence@gmail.com

so a 5.10 version would be nice, as I said it failed as-is:
	https://lore.kernel.org/all/161460075611654@kroah.com/

lore archives are your friend :)

thanks,

greg k-h
