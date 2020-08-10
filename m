Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5958240597
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 14:09:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726660AbgHJMJc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 08:09:32 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:56047 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726778AbgHJMJc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Aug 2020 08:09:32 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 051BB5C0110;
        Mon, 10 Aug 2020 08:09:31 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 10 Aug 2020 08:09:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=uVl+OMZKobqLbZd0fnjkhGZimea
        FfAn+SFSAmLbVuxE=; b=M25zlX9virbS+nnlcMWDpgDDSSiavItxysnsRO21Nq6
        JkCKrgnsnJ0YUeB3kGegY0EJHfbaSFQqqVQaRrjr1eDN3q/RFqE49UsO9fVInCnI
        RwaKE0H0MrHNzNecqG7MTR/Oz6e//nhkrUkMlyKAd+6rMLl60PT7KcJNVfBemBbw
        urTN2md5bMZzPAbElzoaMeassg0cIo+ven4tn/5Y0i/cEA3m9bd6wZuUJ1UUfXWm
        HH2a4eCZqIQ+SyQz+FDghG64XoW3xPBB4wWjEefM5DZ/w6XXdug60Bw07+kME/2L
        VzyxkmQiNKg4w9nKWBDcwrMUaa+3aFHMvGM04ByX8lA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=uVl+OM
        ZKobqLbZd0fnjkhGZimeaFfAn+SFSAmLbVuxE=; b=vBupuwHyHyACCWUagda6zU
        eYXwQX/Z91zBBGRUfhTOAh/rtSr7qQZBQIr7zHfg3fAuHAb/VSchmQ45CydFUG7m
        NulOezlpRHsCyX+OmMd4bZhuq0gH/DbEfrdCBbd0YjBwQxEvip1mKm6rvOLn+Ppq
        cGY6n7QT+eEqpulW9ZoPcSL5TLz3U+58aqXZoRGBXyijoPmzsDMNJNCtWbiDhJu4
        us7NH8IaLbN9N26vL5zbJYpNJba06BYivTkJ4hbl2YXmKRHMJ1QKI0czCIVVWour
        ZHKIUANtSdxn3tDVjb9I0a1jQHntoY0+AUtgNjHIu12LaHrxDLirfGm0J4czfJBQ
        ==
X-ME-Sender: <xms:-jgxX2Numk5_2EmVKXY_o0DcFGqjpdniGVyoSU-ddy4O-Q2ntUuoPw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrkeekgdegkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuheejgf
    ffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecukfhppeekfedr
    keeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:-jgxX08OKBw5WiusfVD8NpXu9prP7ogzQR27YMjqHmHNpJ17Ffi8kQ>
    <xmx:-jgxX9RpHaTw2Xk2mG0LSyckKxfZKoFfw1t8j1Qw7X0qasjHxpeT6A>
    <xmx:-jgxX2vz7fllDIfyY58QuO9FtlgEMW44AraAllWEJv4s4o8SlIdzsw>
    <xmx:-zgxX4oiFwpfK3SUBsZZL2SOPSWa77atYFnMiY5YI_RzsVaL5GQA-w>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6BC223280068;
        Mon, 10 Aug 2020 08:09:30 -0400 (EDT)
Date:   Mon, 10 Aug 2020 14:08:46 +0200
From:   Greg KH <greg@kroah.com>
To:     David Miller <davem@davemloft.net>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCHES] Networking
Message-ID: <20200810120846.GA3243913@kroah.com>
References: <20200807.185327.683162522262853191.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200807.185327.683162522262853191.davem@davemloft.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 07, 2020 at 06:53:27PM -0700, David Miller wrote:
> 
> Please queue up the following networking bug fixes for v5.4 and
> v5.7 -stable, respectively.
> 
> Thank you!

All now queued up, thanks!

greg k-h

