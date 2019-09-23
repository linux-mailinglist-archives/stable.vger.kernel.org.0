Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30E1FBAE56
	for <lists+stable@lfdr.de>; Mon, 23 Sep 2019 09:13:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729395AbfIWHNu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Sep 2019 03:13:50 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:49397 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726942AbfIWHNu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Sep 2019 03:13:50 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 58F9522254;
        Mon, 23 Sep 2019 03:13:49 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 23 Sep 2019 03:13:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=RkRK996cL4srhgRQFGfrcbxHAR9
        z0ZXdF2rqtRnas6U=; b=BGJ3zFCpk2ml8YWsvqD6Hr6WVoecaEiJVphIyq1t6eG
        Fvya10WixfI7nxfGx2dOO9CZmnCJImT3MmQUxjNa8TyubWLq3LGZNmclyhgih5kn
        n1f2awyulS0bKvGh6FB+VTenLxLF32tSXtmqEfjuhPVsTcphGeK50XH6JBnyMwu+
        7ir/rcaxSsqcI2gwUNc6u5u93KdPv1ve+87UthLp/z/x2sbXouAXls9Nm5wvcYgA
        ArJ85iFHpsPGTSARv/TqkrK+ahhLLC+XD7Y+JkrjF0dRKUzu3eFErxLca6dtpSG1
        nwE0eFUFARUF8GBUrah9GFE6otmaPvHTkgKqbPiDMPQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=RkRK99
        6cL4srhgRQFGfrcbxHAR9z0ZXdF2rqtRnas6U=; b=ec08mQlaZuCVA1ec3MUX2Y
        sataQ6A14/dntZLgTEJBjCJG8x3vk8khw8/8vFcnQxLQPrVB1b90Y1emDjHD6Gvo
        cGRLoFnWZ3PlVhwufvakf6CCUL/HDzepcRtJjmF5W+rItKgUK2uYHednqp8khW+S
        dZLUFheKrocyTyvIVYQWuMAEEbYMCTm/7jaA7TsjWHzkJQSNAuBE6XcgczMIL/Pz
        e0IG4UqvuoWq0op9WFGwQ4TbW9aRYMpPzroFRwV3VLHTgXG8m51fbhMsv10P0zFc
        Jva8lSVkTMa7WiJGLl9IfcDHg3J9MJmuyJc+S6Oj63LAGAWi+fojk4A7qP/mceGg
        ==
X-ME-Sender: <xms:rHCIXbvy0xUaAgNCiDq4Et8L8tP_kN1HXHr_3mbjTK97co_vOZz54w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvdejgdduvddtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppeekfedrkeeirdekledrud
    dtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecu
    vehluhhsthgvrhfuihiivgepud
X-ME-Proxy: <xmx:rHCIXWuUp0H43keclEzz19i_R_vT1Avwwy4uh68uorOHRgs1Ud89Qg>
    <xmx:rHCIXdv_mh2cjeKXFTO3mDnvBQwt6rXuFv-pWIsCSe44x89sPiX5og>
    <xmx:rHCIXR3RAMMi4IljKXhgb5wiUrx4bum9zbqWOFqtXML_NB4UZRNSPw>
    <xmx:rXCIXUNKOcE-3TQKB2DE27A1lWJCejGoSGUIbl_Rqf2esH6BHuN55w>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 020AE80059;
        Mon, 23 Sep 2019 03:13:47 -0400 (EDT)
Date:   Mon, 23 Sep 2019 09:13:46 +0200
From:   Greg KH <greg@kroah.com>
To:     Tokunori Ikegami <ikegami.t@gmail.com>
Cc:     Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Joakim Tjernlund <Joakim.Tjernlund@infinera.com>,
        linux-mtd@lists.infradead.org, stable@vger.kernel.org,
        Felix Fietkau <nbd@nbd.name>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Vignesh Raghavendra <vigneshr@ti.com>
Subject: Re: [PATCH for 5.2.y] mtd: cfi_cmdset_0002: Use chip_good() to retry
 in do_write_oneword()
Message-ID: <20190923071346.GD2746429@kroah.com>
References: <20190923023251.20180-1-ikegami.t@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190923023251.20180-1-ikegami.t@gmail.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 23, 2019 at 11:32:51AM +0900, Tokunori Ikegami wrote:
> As reported by the OpenWRT team, write requests sometimes fail on some
> platforms.
> Currently to check the state chip_ready() is used correctly as described by
> the flash memory S29GL256P11TFI01 datasheet.
> Also chip_good() is used to check if the write is succeeded and it was
> implemented by the commit fb4a90bfcd6d8 ("[MTD] CFI-0002 - Improve error
> checking").
> But actually the write failure is caused on some platforms and also it can
> be fixed by using chip_good() to check the state and retry instead.
> Also it seems that it is caused after repeated about 1,000 times to retry
> the write one word with the reset command.
> By using chip_good() to check the state to be done it can be reduced the
> retry with reset.
> It is depended on the actual flash chip behavior so the root cause is
> unknown.
> 
> Cc: Chris Packham <chris.packham@alliedtelesis.co.nz>
> Cc: Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
> Cc: linux-mtd@lists.infradead.org
> Cc: stable@vger.kernel.org
> Reported-by: Fabio Bettoni <fbettoni@gmail.com>
> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> Signed-off-by: Tokunori Ikegami <ikegami.t@gmail.com>
> [vigneshr@ti.com: Fix a checkpatch warning]
> Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
> ---
>  drivers/mtd/chips/cfi_cmdset_0002.c | 18 ++++++++++++------
>  1 file changed, 12 insertions(+), 6 deletions(-)

What is the git commit id of this patch in Linus's tree?

thanks,

greg k-h
