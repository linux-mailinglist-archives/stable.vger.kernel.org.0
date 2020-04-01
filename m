Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D5C419AD7F
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 16:11:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732847AbgDAOLs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 10:11:48 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:40491 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732760AbgDAOLs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Apr 2020 10:11:48 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 0E2385C015E;
        Wed,  1 Apr 2020 10:11:47 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 01 Apr 2020 10:11:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=nttjfI9cnsv06SYrmMmGs9JjqhF
        2pqEUJrx1CPedQog=; b=kqmTwkMAccxwzS+T+/GhVssaYujL+Y1Kfnv4esXdvf5
        vnUXupjzGBe/mhd00QyM/H94SsvHSPhrAVA7kkLHMw55xIy3NfbgYxpAbN6Lz3xC
        DILfYLLtrn90WbnNmLyc9xhfSSoi2P7BNpwlBAlvZQhD7H4Fua2FnSITywPpfwfr
        Tkrx1Ti3uyL5AnRI+8iZfTyqQbCAvVOqP150nMzOEFNCQv1mIHonDfmTwROIB627
        KyKi/QKuzSGqijl0l3sje/sC3tWxZCcPgK9Mqmcp7+SLJNNjQpe+PAcWRCspgPSD
        nx1jZgr+nVGvDIDDqim0gd2mTQlfIVBfe6MX1Tud7sQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=nttjfI
        9cnsv06SYrmMmGs9JjqhF2pqEUJrx1CPedQog=; b=ejyJrbgZTT/DDDbOnvtfbI
        +zvYXBjNMwECub5dHZvmXcNmZj+7yA8knxIUzfPSft4/LUI38HcBIfRtwJmBDdPP
        B4U3sl57BfGt+Qd61ZPBGD9hq7sIapIdE1+qhYAbiN2IETEx1ccIe8ogaS+bVKvH
        Q2ECWkr/VM054di6+d5zufMz9kyXp/tIFhrRJJbneo2DMWodLr/JBorp3rboz6MP
        /J1wILXd2ku7P2zrx1L8/m23x2S5zRNn/Q+6PT4//Ilj7Z4nb/0SeuQ6GjXzV72O
        xPBdU04qtG1JzBnuza8dwFhU9j3qogn4RZvx+9z5lPM3VCFIqGZWrBgKULdfsEVA
        ==
X-ME-Sender: <xms:IqGEXhbBpJqe-HE55VeJlEu6Qt9Z8u_AHioi6EcQrdt54W-iN2-U4A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrtddvgdejvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuffhomhgrihhnpehkvghrnhgvlhdroh
    hrghenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptden
    ucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:IqGEXvX7euvQ_J0ynyQVLqm2q4v8oZERZaTFafUucYsxm6u8xaYypw>
    <xmx:IqGEXqYQWAkMJ4PDMxuI_C9fahvoGt3jt3OZ9SeNhMBjIv_Fg2G26A>
    <xmx:IqGEXuJD76d1VXo561yJRZz3HMV2xa6lAz4nCJBnzLWsilBAtA3hYg>
    <xmx:I6GEXjMsay4-bZA9WAJjpz0cLPxCWlisKeqgvQMSY8fe0a8pEGURTQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0AEEA3280064;
        Wed,  1 Apr 2020 10:11:45 -0400 (EDT)
Date:   Wed, 1 Apr 2020 16:11:42 +0200
From:   Greg KH <greg@kroah.com>
To:     Felipe Contreras <felipe.contreras@gmail.com>
Cc:     stable@vger.kernel.org, Golan Ben Ami <golan.ben.ami@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Jonathan McDowell <noodles@earth.li>,
        Len Brown <len.brown@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [PATCH] iwlwifi: don't send GEO_TX_POWER_LIMIT if no wgds table
Message-ID: <20200401141142.GA2429506@kroah.com>
References: <20200331202625.7998-1-felipe.contreras@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200331202625.7998-1-felipe.contreras@gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 31, 2020 at 02:26:25PM -0600, Felipe Contreras wrote:
> From: Golan Ben Ami <golan.ben.ami@intel.com>
> 
> commit 0433ae556ec8 upstream
> version linux-5.5.y
> 
> The GEO_TX_POWER_LIMIT command was sent although
> there is no wgds table, so the fw got wrong SAR values
> from the driver.
> 
> Fix this by avoiding sending the command if no wgds
> tables are available.
> 
> Signed-off-by: Golan Ben Ami <golan.ben.ami@intel.com>
> Fixes: 39c1a9728f93 ("iwlwifi: refactor the SAR tables from mvm to acpi")
> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
> Tested-By: Jonathan McDowell <noodles@earth.li>
> Tested-by: Len Brown <len.brown@intel.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
> Link: https://lore.kernel.org/r/iwlwifi.20200318081237.46db40617cc6.Id5cf852ec8c5dbf20ba86bad7b165a0c828f8b2e@changeid
> Cc: <stable@vger.kernel.org>
> ---
> 
> Without this patch certain wireless devices simply stop working since
> Linux 5.5.

Now queued up, thanks.

greg k-h
