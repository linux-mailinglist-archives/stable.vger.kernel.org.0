Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4ED1F1B0B2
	for <lists+stable@lfdr.de>; Mon, 13 May 2019 09:03:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726132AbfEMHDq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 May 2019 03:03:46 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:46871 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725980AbfEMHDp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 May 2019 03:03:45 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 4120221540;
        Mon, 13 May 2019 03:03:42 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 13 May 2019 03:03:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=EUprfd4oTQRMt24J3KzcRvPKyEC
        6+T0VwqaT8sTkVCE=; b=O+pqQVhZvmV60GYSMSAkdPunsYnKVKX9Ef6sOa/m7bH
        FFjRERT88Z92kd/CJrXq8YU/aCGRL21/I9HEr2GkxCk0PEc4Ny9HxEyvAuJZdZDq
        68lKzzGRnJ5YeR3QvBLtWW0zmfESSVIVSgTtziPOAgoeuhlO5prPkrTVNmjI5FwL
        2ahAmU4T5HiRg+LFlZYRBCu6Cq5BHsfdhIciVjMpCB1b02DKxzBzv4v9fXs0xc12
        7lsqCgDQjLIYZNaU2gZb9bJ65T7P1SG8ySOB4ZstvBWSMa+vxPc7uuWVqsd+D6uY
        9LTr3nurXg/+zqGxvCOevMb/LonFmNFrzcnL12NhWdA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=EUprfd
        4oTQRMt24J3KzcRvPKyEC6+T0VwqaT8sTkVCE=; b=u0ZrxH9qkt4z4EjTNRDODL
        Nw2XJzCfLQi0IbMnaeIfXHSd3+q2eXRR8fjSxBNCphRPb+8Jds4FBA9wOg4WQlvx
        8fo530OWzq4Ir3lIh0CULIadj2ukGJ7Rka/aBFe4Uk/ovIBZ7BVmEVJ1zfmYDsiL
        DWYh9i+r38cQQlndCZcYIwD0h4DQK7idZXVSRGMMmyDclKfZU7ruQEsAqEC+PJAp
        I/wqeDo5OlnuN5LUMTqpNk2zWy3XmTQY65xf51DqpGQDMt6gKNWN2tlicffqH9oE
        RAv8q+Rj2RXbEVr3pKYhNccroYFZBtlrRNw/wRkOnLaaDUToOcPz+JsL9z0qxZLQ
        ==
X-ME-Sender: <xms:zRbZXLzqJ6SRUcN14pdUw-yHesimMyunYQR1B4kiUAgaH0CTtkh8rg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrleefgdduuddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppeekfedrkeeirdekledrud
    dtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecu
    vehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:zRbZXHjPWNDPxewBJDvxqj-z39TJJ0IrAuJ9-uS8rR_bmqXcW4asfQ>
    <xmx:zRbZXAUTgZTMszS4BYXjbSlITbDwcxoLDNJ1CilQb-2sXy2YHnQfzQ>
    <xmx:zRbZXJ2gph_4YGi1uevcIR1MChzLcwTYod5gsE_apHM288U8OipE3w>
    <xmx:zhbZXLgJN03WNlHmVvMlA9YX97qzWTX5D3Qkj5UxPOtI2rXMAx_vnA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id D03EF80060;
        Mon, 13 May 2019 03:03:40 -0400 (EDT)
Date:   Mon, 13 May 2019 09:03:37 +0200
From:   Greg KH <greg@kroah.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Eric Wheeler <stable@lists.ewheeler.net>,
        Paolo Valente <paolo.valente@linaro.org>,
        Jens Axboe <axboe@kernel.dk>,
        "open list:BFQ I/O SCHEDULER" <linux-block@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Eric Wheeler <bfq@linux.ewheeler.net>, stable@vger.kernel.org
Subject: Re: [PATCH] bfq: backport: update internal depth state when queue
 depth changes
Message-ID: <20190513070337.GB26553@kroah.com>
References: <1557510992-18506-1-git-send-email-stable@lists.ewheeler.net>
 <20190510201855.GB14410@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190510201855.GB14410@sasha-vm>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 10, 2019 at 04:18:55PM -0400, Sasha Levin wrote:
> On Fri, May 10, 2019 at 10:56:32AM -0700, Eric Wheeler wrote:
> > From: Jens Axboe <axboe@kernel.dk>
> > 
> > commit 77f1e0a52d26242b6c2dba019f6ebebfb9ff701e upstream
> > 
> > A previous commit moved the shallow depth and BFQ depth map calculations
> > to be done at init time, moving it outside of the hotter IO path. This
> > potentially causes hangs if the users changes the depth of the scheduler
> > map, by writing to the 'nr_requests' sysfs file for that device.
> > 
> > Add a blk-mq-sched hook that allows blk-mq to inform the scheduler if
> > the depth changes, so that the scheduler can update its internal state.
> > 
> > Signed-off-by: Eric Wheeler <bfq@linux.ewheeler.net>
> > Tested-by: Kai Krakow <kai@kaishome.de>
> > Reported-by: Paolo Valente <paolo.valente@linaro.org>
> > Fixes: f0635b8a416e ("bfq: calculate shallow depths at init time")
> > Signed-off-by: Jens Axboe <axboe@kernel.dk>
> > Cc: stable@vger.kernel.org
> 
> I wasn't clear on what was backported here, so I've queued the upstream
> version on 4.19 and 4.14, it doesn't seem to be relevant to older
> branches.

I only see this added to the 5.0 and 4.19 queues, did you forget to push
the 4.14 update?

thanks,

greg k-h
