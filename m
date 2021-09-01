Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABF613FD510
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 10:15:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243048AbhIAIPr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 04:15:47 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:60477 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243041AbhIAIPp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Sep 2021 04:15:45 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id 84A245C00F3;
        Wed,  1 Sep 2021 04:14:48 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Wed, 01 Sep 2021 04:14:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=BuvuRLiclI2ZPDHjAVTSSUhPf+B
        EZ0r+raCKQUzMmyY=; b=MBA0jEPWTM4N3BfTJlHCkBjK8gMHaHAaR0/ANSYbvCM
        WehbVNhWQKyRQJxx/GAlhNk6kjlNsoq/c7v9fHqNYVf+CyG3Q/VqwfFU0kLJ7TgB
        YBziO5bQtTEmEqAInz2c0NGCrirKo5xcDWCOVjP38quSADIsraeYD2lVJkX5mZ+/
        hvSvgYQiKY38wcKzOzrGYxvuXXW5WT1DBBIjKFJD4EvCv+eey26sWihnbynklEyl
        37exUUIegHInU+vZy8KwCnH0y03fTBR7o635gRAt+fQZrQaDIIsLFQH6JwPOWldu
        5fP6cJuwjXFR7RuxlXKtum/cH9zlNHgaNd/2VPhysmA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=BuvuRL
        iclI2ZPDHjAVTSSUhPf+BEZ0r+raCKQUzMmyY=; b=LwL+UOuStjzHuA8KbAZDeT
        Ye7zhlllqH3xXR5BRZoF1DNbvs/tBxn0RBP7h+sW/ziUj3m7h/iZGxsqNDymbvfo
        8Np+BavaAzMmajv4u1mz/5HZ6AeyTznlMoYkoAGccW0TCMgNtUYU+IuapQ/K8FRM
        pkdqYWY2ybVz5/m34pM4/42U7K7He9lOig3vlDrf0oUA2jPpi7CJHmjD9vrx5cNo
        t7ntzCn5TzTAM0QzG+8UXLBhjdDQBhst4FQKtcTXCHYZhhxKIUNySCVlrjbclj0L
        K3MLJoWsFf2GXYGuzBb0k220NynqSyeX1+DbVkTkoJWnJR+U1qKl6xMxDNnO23mA
        ==
X-ME-Sender: <xms:eDYvYRGIhggwWmsiJqUp7MbDzGoDthXtvykPdoFA1QLwj7fcrjxAAg>
    <xme:eDYvYWVRKfVIqdNOJKsWdWWA4iQz8N7InnTvD1yiTEqbCvpEyM_xzxSjeMk10rPfv
    77V-F7kuih9Lg>
X-ME-Received: <xmr:eDYvYTK-NBiNOuMDw_TovX8BdcEosUAb_HHenPPOqnDSLsF6ws8O9Vys3V5yLb8Ek-pDcddjiXJGZdtL1M-5w6TmR7B-I0s0>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddvfedgtdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:eDYvYXFTUahAG_q5weLx3iSH7S4QZ5kdf_wjd4x26eSoS9JPNWKRpQ>
    <xmx:eDYvYXXRB-JnoT9K--Mv6tZsA1wvm3E7BAiJ5GPYpxoDP-QtaN9z6A>
    <xmx:eDYvYSPpRVLD1s5JolYyv9GQzn7-NZKH5gc34a7WqFo9Hig4IHDwqA>
    <xmx:eDYvYTqXN7Xeil6-9Ox33aOKcM1oOyTSw7wef1PrxwBZLPuODZmV7w>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 1 Sep 2021 04:14:47 -0400 (EDT)
Date:   Wed, 1 Sep 2021 10:14:45 +0200
From:   Greg KH <greg@kroah.com>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH stable-5.9.y, stable-5.10.y] btrfs: fix race between
 marking inode needs to be logged and log syncing
Message-ID: <YS82dS2FmcKYDXwv@kroah.com>
References: <2f474ee209a89b42c2471aab71a0df038f7e8d4c.1629969541.git.anand.jain@oracle.com>
 <7701f6238b7a6905164fa85d343d6328554414ea.1630270929.git.anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7701f6238b7a6905164fa85d343d6328554414ea.1630270929.git.anand.jain@oracle.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 30, 2021 at 05:42:17AM +0800, Anand Jain wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> commit bc0939fcfab0d7efb2ed12896b1af3d819954a14 upstream.
> 

Both now queued up, thanks.

greg k-h
