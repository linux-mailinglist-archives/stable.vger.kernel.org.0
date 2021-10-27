Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DD4543C4F0
	for <lists+stable@lfdr.de>; Wed, 27 Oct 2021 10:18:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240858AbhJ0IVB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Oct 2021 04:21:01 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:49589 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240819AbhJ0IU7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Oct 2021 04:20:59 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.nyi.internal (Postfix) with ESMTP id DF73D5803F7;
        Wed, 27 Oct 2021 04:18:33 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 27 Oct 2021 04:18:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=uT84THlxz9EBwWU8Qk+dOJNT5Pj
        lIqrahiffVgieZEA=; b=PvKrgrfy60m1UjCeRs2xftCXxcTrwrsGl+iBh0q+7Ne
        8v+vQ9N+hwq3ao6px4jtO8PIlWDGxM9vxQozjoxaQ/aAM0mwiFNHIGhmYrS0+eyG
        dC+ZFG5kwNsIbee3AgD1IdZX33alQTpHO17gEaB6D7mK05lymBqV4367Nt9Qh32S
        Wqaw2L2H4FJCtRH/ryZPlXe2lSBGKMgbtbNjEPp4gL5Ongr6RJLkjnXoh8y8c0k0
        u4FAYghM/+9QlFIklzMFH60z5jLUu94uGiNxa4zGixwq6XA6LyxwobWyDfDzk0MV
        IBOHumzQX/vqOEpOL0neKFcxXxWuEfNPA3nWJR8Iv/Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=uT84TH
        lxz9EBwWU8Qk+dOJNT5PjlIqrahiffVgieZEA=; b=L3QaEtXV1VjGzLZS8lHr+n
        rTs5xNxBrD6jobeQtVLw4u335d/ytdw35dQJf9R5pvi72jmqSqQ9yrBCmf3iPkdn
        ovFWVA+Nxy98UWKm7VCJVuYiVlGzyJxJhIAJUz14sg0q3Xyz4gwNTS5oSRKt8Xv+
        OJGvky9NEhzFbM7denafp2cCeKB+RhvLrVsahzv+vPZQsztKo1/UgT95o6u/8WEE
        DFSuPR7upuUvZPqa0rvexoTvOAS5xy4VUKIkx+FiobxNNcQzUomPkFpXDvAr6P2S
        vBpvoL/RkEojFPsyhGx9qWxyNm9shuMDEwrLZTkfR1NPGW3vstj1Kvokg4wULmqA
        ==
X-ME-Sender: <xms:WQt5YY_Hm0KWeBMoA_ixFIYUPkOkHmIGeke7XeZ-k-aDJebhDLZ6PQ>
    <xme:WQt5YQuOaJOxbjy3vo8ZzDalfcwB60G6w9NJn1KzGIcriT3plsgLYNa1LjbnEF4Yr
    ReoObBXIfbpeA>
X-ME-Received: <xmr:WQt5YeC0pibzIf-JFOQHq7GjoS3Cu2IblJ6zbc4S6yrbWcWfXBENXIdu-pr-34RHXz-qgfAxjL_TkbJRhFiQbcirVMfaTWUA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvdegtdcutefuodetggdotefrodftvfcurf
    hrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvuffkfhggtggujgesthdtrodttddtvdenucfhrhhomhepifhrvghgucfmjfcu
    oehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveehgfejiedtff
    efhfdvgeelieegjeegieffkeeiffejfeelhfeigeethfdujeeunecuvehluhhsthgvrhfu
    ihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtoh
    hm
X-ME-Proxy: <xmx:WQt5YYev337IC-Rc_xCsdFRQqoBoEDs8QJgdrbBmznhjwsF_-KCgUg>
    <xmx:WQt5YdPKqBtCBx2F81QsmTmajKVEwVFYhU0gBqpm7ayptjIOu7iw_Q>
    <xmx:WQt5YSmKguJvZxD4B4gZk3g01r2es0YFmuB2oF7iRLmeYDudvWXgZA>
    <xmx:WQt5YeG3c-8Se9D8cwoVm-elSGwyhMWzfpOURKrNz9xyU3iajMzxDg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 27 Oct 2021 04:18:32 -0400 (EDT)
Date:   Wed, 27 Oct 2021 10:18:30 +0200
From:   Greg KH <greg@kroah.com>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     stable@vger.kernel.org, axboe@kernel.dk, asml.silence@gmail.com,
        io-uring@vger.kernel.org,
        syzbot+59d8a1f4e60c20c066cf@syzkaller.appspotmail.com
Subject: Re: [PATCH 5.10 1/1] io_uring: fix double free in the
 deferred/cancelled path
Message-ID: <YXkLVoAfCVNNPDSZ@kroah.com>
References: <20211027080128.1836624-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211027080128.1836624-1-lee.jones@linaro.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 27, 2021 at 09:01:28AM +0100, Lee Jones wrote:
> 792bb6eb86233 ("io_uring: don't take uring_lock during iowq cancel")
> inadvertently fixed this issue in v5.12.  This patch cherry-picks the
> hunk of commit which does so.

Why can't we take all of that commit?  Why only part of it?

thanks,

greg k-h
