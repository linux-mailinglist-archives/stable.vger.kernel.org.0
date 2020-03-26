Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D028F193CF7
	for <lists+stable@lfdr.de>; Thu, 26 Mar 2020 11:35:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727688AbgCZKfI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Mar 2020 06:35:08 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:55091 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727560AbgCZKfH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Mar 2020 06:35:07 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id BB9F15C01E5;
        Thu, 26 Mar 2020 06:35:06 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Thu, 26 Mar 2020 06:35:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=Qzys90o5abW780iClkZnIacvhuv
        2mRRaM2JQPil3+74=; b=IlvHjX2eESlyXYZNVrxszyGz+fyHHokBJcFoJRRf+AI
        lKsNnRwnEuEgSmZitUg4oMpU7h5v96/TCJMH5yxNlp7vJylKAnpAYqbJaj5yI9cg
        EzYoJvYu70+/E4Vu8EVgL//Z8/FoVf+6zHhonKxu2LYBdAO5jzs4ze29iaI7s0iY
        f14KTRLfqxbBxXzPo1U1bALUmEiRWo+gTc67S7UKkVZGlxNx379t6g4w+z8Lqfrn
        qxEY2MSbsfvE2bsQ8TSl0vsDuUzveRoZ9LjVztwDGeqNO9Ou9Xc8OQVrUSCvh6/9
        RbeBdVBmTnzs0dKiDBdNxaaU6eMAGawDx6819UGosNw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=Qzys90
        o5abW780iClkZnIacvhuv2mRRaM2JQPil3+74=; b=HWeHdvMihzmQNlWYpPwQua
        Mu40jU+SxgzRtr08stvGCayjXJsVeW9JuPi+oCWURg7ka793ZC0U+8yNLAx2y1W1
        pAuwNrTxQMO4FobjI9RUAhOtTcYC6pXaRQZGC3na2lKwEMrPb1+BV3GiiQ7K5phY
        lCvKxVLRIGOXTNbGBh0nR6kSuPNlQ2T1NuqrQMKRfk2aIjmgPpRD6l4PwaTcpsMH
        qA7of3yRVKWKIewzFDuiBCk/oZPkILkSEeW0tiMuRdDq+n7iQ5N9G25C0Dd2nBTK
        bkhOIFM/Ne351JrCtijgO6qr5hTAUvNmKxCGWl/iHDI92njPE2UhP/Kg1q6aLUMA
        ==
X-ME-Sender: <xms:WoV8XniwNQsBACrEuER1ZWkK8woHZY7pcP8yWnOLBkrvKrKiPvTqLA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudehiedgudejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucfkphepkeefrdekiedrkeelrddutd
    ejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhr
    vghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:WoV8Xv-xTAqxwIuF_eUVJVS5lBB4mVByMgxiWHRvIGiC0Y9cos3GhQ>
    <xmx:WoV8XtN_iEaq-5XZB4gdxMyRtpdUnFqtOjeEsUCDo52LSAFJ1LHmkg>
    <xmx:WoV8XqrXH54al0bzHJrICOXqote-x_OQ0vMrH35AtrwKWjiZXN6yXw>
    <xmx:WoV8XlrhHz6_Et1MmddDhOkRtLHMnuBbrotfE-wgAg6pcpwL-Z0DPA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3DB273069835;
        Thu, 26 Mar 2020 06:35:06 -0400 (EDT)
Date:   Thu, 26 Mar 2020 11:35:01 +0100
From:   Greg KH <greg@kroah.com>
To:     Sagi Grimberg <sagi@grimberg.me>
Cc:     stable@vger.kernel.org, Potnuri Bharat Teja <bharat@chelsio.com>
Subject: Re: [PATCH stable 5.4] nvmet: fix dsm failure when payload does not
 match sgl descriptor
Message-ID: <20200326103501.GA1079173@kroah.com>
References: <20200320060314.31192-1-sagi@grimberg.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200320060314.31192-1-sagi@grimberg.me>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 19, 2020 at 11:03:14PM -0700, Sagi Grimberg wrote:
> commit b716e6889c95f64ba32af492461f6cc9341f3f05 upstream.
> 
> The host is allowed to pass the controller an sgl describing a buffer
> that is larger than the dsm payload itself, allow it when executing
> dsm.
> 
> Reported-by: Dakshaja Uppalapati <dakshaja@chelsio.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>,
> Reviewed-by: Max Gurtovoy <maxg@mellanox.com>
> Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
> Signed-off-by: Keith Busch <kbusch@kernel.org>
> ---
>  drivers/nvme/target/core.c        | 11 +++++++++++
>  drivers/nvme/target/io-cmd-bdev.c |  2 +-
>  drivers/nvme/target/io-cmd-file.c |  2 +-
>  drivers/nvme/target/nvmet.h       |  1 +
>  4 files changed, 14 insertions(+), 2 deletions(-)

This patch does not apply to the 5.4 tree at all:

checking file drivers/nvme/target/core.c
Hunk #1 succeeded at 941 with fuzz 2 (offset 2 lines).
checking file drivers/nvme/target/io-cmd-bdev.c
Hunk #1 FAILED at 280.
1 out of 1 hunk FAILED
checking file drivers/nvme/target/io-cmd-file.c
Hunk #1 FAILED at 336.
1 out of 1 hunk FAILED
checking file drivers/nvme/target/nvmet.h
Hunk #1 FAILED at 374.


Are you sure you generated this properly?

thanks,

greg k-h
