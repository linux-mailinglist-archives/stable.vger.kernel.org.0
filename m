Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F2C72180E
	for <lists+stable@lfdr.de>; Fri, 17 May 2019 14:16:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728205AbfEQMQW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 May 2019 08:16:22 -0400
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:57143 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728201AbfEQMQW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 May 2019 08:16:22 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id B3B7128B;
        Fri, 17 May 2019 08:16:20 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Fri, 17 May 2019 08:16:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=9oJNhvpJNtK/zPdFs1MGDrcFXho
        q2Jw2CGG2XnlvZCQ=; b=d6fIzTfQuXkAbwgrvGqEXd0ggLtS7dqT1kqKXZQ5Z0l
        dlnCQvWgvt/0S1VBHiRt9CHzPO6e3sCMIIzln5Az8my+6D0QhVsCigd51evDO54v
        y1amzGGtxiihbbe/f/a8fcKWS3MTUnbrexuuDtUGap1EMdeViEZre3+DcI9IswDD
        bNCD1+Lt62YIKgcQobZHfhqxhdBS/DnVhCslcjheKInbX+oX721SFpyTJ6wwqBNG
        Qk6SA54H3nedznorhDKLyUZwncwdKcSKXx2Mx0so9ROTA6eWqP+wukDfiyGaORoS
        4NbTFLWOLhRt/0pUlsINWM68nxYG6FCJF+/7qtTJCPQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=9oJNhv
        pJNtK/zPdFs1MGDrcFXhoq2Jw2CGG2XnlvZCQ=; b=nqkMPj6duuQ4HvE8ETRIFh
        V+bZDUxG655XiNKYSn6m8DDJwKG+48KFLUczbDo/lthwJPQ92tMeh/RZKUx/op23
        fgEIV/kJmW3c1WyCo28tqIERJfw0uqnNNX4Wf/jLrIbvXHaWoygKNOUoBvjfv7VJ
        IbwlyNhgJVccRRNWRqvsHLT5KtgbeMJVgDIHQC2+z/7UGqbVaZGLhWcqU4u8mi/c
        /Kl/sI0qxI5iai8gHXw9fyu9gPsm+kMaC8EOr4qrEl2J3GP2RXVfxKFfbNlqm8Pj
        HUOel2v8ra0ORvm3lt6rVdFGFu3x40KTb3c7Nj2yGGaCU/UigHxWjT0Ui1Zl1H2A
        ==
X-ME-Sender: <xms:EqbeXNSjxd9mTaUGjjK8XzmflFrGZROGDCu2faPrQI80R1zOGXSW3w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddtvddgheduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppeekfedrkeeirdekledrud
    dtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecu
    vehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:EqbeXFTOJ_bVBCbPXoq2o1Jmw9XbhtBWK8s3MEjMzjNd4f-vrjbTkA>
    <xmx:EqbeXJCKszvlzxivNwEbKK2cHjSCrJTiL9p3pfYgcmpq30BI-yl8FA>
    <xmx:EqbeXJwL9FMMMxIogtHkRXejvfYGJU4b2ERnYTkXACPCkR0l5u8jMw>
    <xmx:FKbeXCStukeYdyvvHgm6ONOejCypfCqTLJogfkk1Tm5ecFCRh2mfzg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7843180059;
        Fri, 17 May 2019 08:16:18 -0400 (EDT)
Date:   Fri, 17 May 2019 14:16:16 +0200
From:   Greg KH <greg@kroah.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        stable <stable@vger.kernel.org>,
        Linux List Kernel Mailing <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] locking fix
Message-ID: <20190517121616.GA3705@kroah.com>
References: <20190516160135.GA45760@gmail.com>
 <CAHk-=wgtHi5mT7y=0ij-AksQQOBQJqV1apk2bRaH2tfRTxyFcg@mail.gmail.com>
 <20190516183945.GA6659@kroah.com>
 <CAHk-=wgNFabppzpSQQgt7ajrYqmFjtkn2D3n=RvSEDryCLO+=g@mail.gmail.com>
 <20190516235553.GU11972@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190516235553.GU11972@sasha-vm>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 16, 2019 at 07:55:53PM -0400, Sasha Levin wrote:
> On Thu, May 16, 2019 at 11:42:58AM -0700, Linus Torvalds wrote:
> > On Thu, May 16, 2019 at 11:39 AM Greg KH <greg@kroah.com> wrote:
> > > 
> > > Thanks, I'll work on that later tonight...
> > 
> > Note that it probably is almost entirely impossible to trigger the
> > problem in practice, so it's not like this is a particularly important
> > stable back-port.
> > 
> > I just happened to look at it and go "hmm, it's not _marked_ for stable".
> 
> I've addressed a missing a8654596f03 ("locking/rwsem: Enable lock event
> counting") and queued up a backport for 5.1-4.9.

Thanks for doing this.

greg k-h
