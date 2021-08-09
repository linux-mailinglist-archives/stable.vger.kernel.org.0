Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FB0B3E4594
	for <lists+stable@lfdr.de>; Mon,  9 Aug 2021 14:27:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233826AbhHIM1e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Aug 2021 08:27:34 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:35583 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233698AbhHIM1e (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Aug 2021 08:27:34 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 57E395C00DF;
        Mon,  9 Aug 2021 08:27:13 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 09 Aug 2021 08:27:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=AdJj11WOeMxOsGS2VukRYuSdN7K
        Cr738JS2MrX1t4AY=; b=O92RbYWvJ0NcMaHXf8NImaFUzVrVvFRqS6qxMbMH+Ag
        rx3ykbdvnAOIfPhbfQVriQD+OJbqC/eK6MujScW6OaS8jLjAp+XAIBMkcHMeaVJp
        xIimyBb6rOcpmPU+PRuZLaIeXU4OZZfIkJno9/acD1W3MmM9eSkbIpeKyHu5YDw5
        ERN6zb/CBccfeOjeRSt74yrGujICz9HybnJPn+BmNQmbk12uNAw2rznQlhtnT7TH
        fSbPFD8q52C76UxgmHlwBXXqU3w9XrgOYseoNSjvlLQkKIYt7/imB9L/uKOoOCVe
        rcBhlebr6rTon9AeXEypanI07dgf4ArvVE34gAqbJYQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=AdJj11
        WOeMxOsGS2VukRYuSdN7KCr738JS2MrX1t4AY=; b=U9itvKUmpzvSdzP2q9BB3w
        y6nBCu2Aua5QosJ38I+CkO2xnaQTW08dXaFMNvL/cKvPB89EFi6OAht3WLxY5OV1
        y+dmrc1f+1bnhuUNeZP1ehbJ9ZBG0gBVn1JcesxCF6PMvscCKoY9ZD8g562h2oT+
        P4UEcHfxmZ3zh3X6lGGCiylD8CxlqE3qrkBdui2ft5O0bfI8aK50Zze1beWnQsPL
        xAs+nRvF/1quZNWRfDqVnrx35R9KCS6UmCBT+DT7nSh/0w38RkdUXbXQg3707XmV
        IvfTHSaJO74hHpvknqBfsJtTg4HHwj/5s+C+erOOwaKm8jzX4h7+L0snIjxffOWw
        ==
X-ME-Sender: <xms:IR8RYcLN3Qdejm-BLr2dpi2rsLml7tAYT177lDaQaQKCEZERo_X3ug>
    <xme:IR8RYcIDG9M5ueYyRNB-Bhg7wNwM2TkOn5AYcDFL0ha5IgoNezmx9BIIvK26UGMFs
    STTBBryUPVo3Q>
X-ME-Received: <xmr:IR8RYcs9GdK_vomgewQ_dZmaKU8Vkec-mVwXnS__meCALKYVDtUDr3fNZGtnPn9-YlmZD_JeeEnaMAopmaOxSkPu6wCETPWW>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrjeejgdehfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuheejgf
    ffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:IR8RYZYdS2hek9V9gnPZLkw8zoL39vjwbugk_b0fdw1ETZYn45Jlag>
    <xmx:IR8RYTYhHHspzrs_naBXYj2FgEUk5WDIpWnLyxxNFVj2ytCI1C7-Qg>
    <xmx:IR8RYVBEf6MXdd_EO6pxnEG32PvmQvQGcFH_NB2jcFNPBPX03vKE_Q>
    <xmx:IR8RYSUzdH3KK-K2LzkjXcU2jJfZ_p9HPIqPjFmc3ynwevMe--gwOQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 9 Aug 2021 08:27:12 -0400 (EDT)
Date:   Mon, 9 Aug 2021 14:27:10 +0200
From:   Greg KH <greg@kroah.com>
To:     nelakurthi koteswararao <koteswararao18@gmail.com>
Cc:     stable@vger.kernel.org, regressions@lists.linux.dev
Subject: Re: Futex crash in Normal 4.9 Kernel
Message-ID: <YREfHsGDx/Yows56@kroah.com>
References: <CAGJbQdfVXdjcDjwUae9QdWWu8MJM5EamN4S1pQCRZO2KwjeFaA@mail.gmail.com>
 <YREQ8H6AmD2P5nL0@kroah.com>
 <CAGJbQde8vgDBknH7gevnRx5cxwjOvuNoU7jHDnj3fN+dJgt2uA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGJbQde8vgDBknH7gevnRx5cxwjOvuNoU7jHDnj3fN+dJgt2uA@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 09, 2021 at 05:52:17PM +0530, nelakurthi koteswararao wrote:
> Dear Greg,
> 
> Thank you for your reply. I noticed most of the futex changes between
> 4.9.233 to 4.9.279 is related to Priority Inheritance that comes in
> to use in the Real time kernel. But I am using the 4.9.232 Normal Kernel.

I do not know what a "4.9.232 Normal Kernel" is.

> That's the reason I posted futex crash to the mailing list for input.
> is the race between futex_wait() thread and futex_wake() threads leading to
> NULL pointer crash? any input in that direction?

Again, please try the latest 4.9.y kernel release, we do not support
older releases for obvious reasons.

thanks,

greg k-h
