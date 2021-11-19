Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 701284570B0
	for <lists+stable@lfdr.de>; Fri, 19 Nov 2021 15:30:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235843AbhKSOdq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Nov 2021 09:33:46 -0500
Received: from wnew2-smtp.messagingengine.com ([64.147.123.27]:36771 "EHLO
        wnew2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235496AbhKSOdp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Nov 2021 09:33:45 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.west.internal (Postfix) with ESMTP id 046B72B012A8;
        Fri, 19 Nov 2021 09:30:42 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Fri, 19 Nov 2021 09:30:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=h8r4/DEEY7cOxcSK25SrqJBn130
        fyuDYG6C6SxwLbwk=; b=OKldk0VNZfEt7PMAJCkIi3VYeZtYO2ZGrHUsakpJphL
        OYUv6EtgYpTyMcF0WTLlqyazWGBtRxZmdq4p5oSP2tdw1E8mDja6cMhOtA7S01El
        yn5blX/4U6mM5tSRrdrFXa3k3q3tcE9OhIXeCMR5yt7KqAxvP4BYVEYeioqpISoa
        PWhmEi5an+1WlDO0GT8DqDWJtNLrlZ/UI1vlVEDFS9u+7zrbdvuSo3QE6OUxejbk
        l97XgyAmX2FgTx+eU/Y7Fp/N4a5nLxpSTPBjPo78yCqRxX8i+F1P+5fVKblp8mO/
        +JexifRMWEFbSBeNJty42vHJospuxuFIS1r2TR6LSnw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=h8r4/D
        EEY7cOxcSK25SrqJBn130fyuDYG6C6SxwLbwk=; b=Fol2Orr0Uf6aNcNbx5jNev
        hh5L/bOv2UWKPO7jKnrz9bcglUCB/LPTZq8ZeTkiS8KujSBo3XpX0JkCiUr7/Wee
        JUWZlw/59gPpJG/o7o+V5DuOzOxya9ZWn8niCnZS/SnEBman+CW+g/45Lws1F6ly
        Ct3sHOnJNc0Q9oUkyVujfSJjduEok3Z9yJF6FAkWJ80YlBUVFFitEP4szezRqm/H
        OV3nWWylDq6ZgVVS3fxGV/GecWOf/Q1diDNKddU3I9Rzgf3D9JN8p9zdWOiQwDLF
        LYOLtOSX+Ce28XS44BPHb5wdKIW3RFGE+3vkgl65l7FsRlVZKoBD6eaAedGyRxgw
        ==
X-ME-Sender: <xms:ErWXYUdxq1Fux45wo0UTuhxvcANLAKW9WwtiATrG6CpL6sWKL8N8iA>
    <xme:ErWXYWMhLxXTWWy3rGpSyLRIAzkROiktDvwQWu9nsAWO1QiozyzcjvMG05qFngScR
    jwmBFKDJxmQag>
X-ME-Received: <xmr:ErWXYViBtPV91dN83EjNsfoBsk3QCMafEiceBrdy8bnZh8NR5OzP5K8wXqg_YeQyGB73bULM3wiMSrT57YsIt9Smw3amu7Ap>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrfeekgdeifecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepueelledthe
    ekleethfeludduvdfhffeuvdffudevgeehkeegieffveehgeeftefgnecuffhomhgrihhn
    pehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:ErWXYZ-OE5yqLwyusGbIpA1gRhxedV1RiX2o9NSP_ft2OKUUkglZFg>
    <xmx:ErWXYQtYTp8si2dNO7bu_GQe9-J3TmpXJHgFKIH2pdzUAzlCpEOWmQ>
    <xmx:ErWXYQH7f2zi6D-W7vyZIgHMGLFPiudPGbZ5izhmKcxrHzHRvCvMjg>
    <xmx:ErWXYRkD96TvWIqsJSSWHKNP8twVD4UVh2lOA000reSTk4-X9dMlYOMQy1g>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 19 Nov 2021 09:30:41 -0500 (EST)
Date:   Fri, 19 Nov 2021 15:30:38 +0100
From:   Greg KH <greg@kroah.com>
To:     Simon Wunderlich <sw@simonwunderlich.de>
Cc:     stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        syzbot+28b0702ada0bf7381f58@syzkaller.appspotmail.com,
        "David S . Miller" <davem@davemloft.net>,
        Sven Eckelmann <sven@narfation.org>
Subject: Re: [PATCH 4.4] net: batman-adv: fix error handling
Message-ID: <YZe1DsVVrn7mG+En@kroah.com>
References: <20211116105028.188548-1-sw@simonwunderlich.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211116105028.188548-1-sw@simonwunderlich.de>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 16, 2021 at 11:50:28AM +0100, Simon Wunderlich wrote:
> From: Pavel Skripkin <paskripkin@gmail.com>
> 
> commit 6f68cd634856f8ca93bafd623ba5357e0f648c68 upstream.
> 
> Syzbot reported ODEBUG warning in batadv_nc_mesh_free(). The problem was
> in wrong error handling in batadv_mesh_init().
> 
> Before this patch batadv_mesh_init() was calling batadv_mesh_free() in case
> of any batadv_*_init() calls failure. This approach may work well, when
> there is some kind of indicator, which can tell which parts of batadv are
> initialized; but there isn't any.
> 
> All written above lead to cleaning up uninitialized fields. Even if we hide
> ODEBUG warning by initializing bat_priv->nc.work, syzbot was able to hit
> GPF in batadv_nc_purge_paths(), because hash pointer in still NULL. [1]
> 
> To fix these bugs we can unwind batadv_*_init() calls one by one.
> It is good approach for 2 reasons: 1) It fixes bugs on error handling
> path 2) It improves the performance, since we won't call unneeded
> batadv_*_free() functions.
> 
> So, this patch makes all batadv_*_init() clean up all allocated memory
> before returning with an error to no call correspoing batadv_*_free()
> and open-codes batadv_mesh_free() with proper order to avoid touching
> uninitialized fields.
> 
> Link: https://lore.kernel.org/netdev/000000000000c87fbd05cef6bcb0@google.com/ [1]
> Reported-and-tested-by: syzbot+28b0702ada0bf7381f58@syzkaller.appspotmail.com
> Fixes: c6c8fea29769 ("net: Add batman-adv meshing protocol")
> Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> [ bp: 4.4 backport: Drop batadv_v_mesh_{init,free} which are not there yet. ]
> Signed-off-by: Sven Eckelmann <sven@narfation.org>
> ---
> Submission according to the request in
> https://lore.kernel.org/all/163559888490194@kroah.com/

Now queued up, thanks.

greg k-h
