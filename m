Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ABB93E378E
	for <lists+stable@lfdr.de>; Sun,  8 Aug 2021 01:20:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbhHGXU5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Aug 2021 19:20:57 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:34213 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229797AbhHGXU5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 7 Aug 2021 19:20:57 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id DAA295C00EE;
        Sat,  7 Aug 2021 19:20:38 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Sat, 07 Aug 2021 19:20:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=C2Kr+e
        Eh5+xzHcKB01XFOXm7GGyi4YjtCJ20uK8zVjw=; b=M6P9BUvJeg/pne9wVqPnuR
        qFXn7X0S2HLePU6EkRDnRngSGlqs46ZE1rRa3o96umGb4JHhnoYUkV3tGt9kDg5t
        4eGlRWMkLbEdLA2G9ZvITB62hPfJKOLp6l+XO40ACZhVQS1hgb8bo+zQgnntK8js
        t6eagLpw7kdtvYYiWEE0zTBcJUT2qh90xpMOzH9GmXfQ4TIScMDLiU1GT1GFri7j
        OuKz8vTvb51n0WhovuGyKoMDVJOLmo//xMxgJfI4AQnuE1pfA7FeiJVGy5W08X6Y
        JjCtkVrP8oFrj8U4K1f2pIBfFu8WztDBROz/kFL8Cp58OII0MbBmo5wqY57Oa+BA
        ==
X-ME-Sender: <xms:RhUPYWadBmDSxSlhf6p4B9eF3f6dERkePmaN7E0W-1IHrvJbbPBUTw>
    <xme:RhUPYZbEOKo1Lju6h7gNmb6MnQQ0hViKv6OZY-TNFnud35eLHHkj8QIchKyyQ0cEq
    YXZ6CFOV3TOts_rW2c>
X-ME-Received: <xmr:RhUPYQ_QcsChYD9j0CYi-T3MGulSaeXgBSc68RQZ0hZlxJy4sTaD-B3aIYzX3ufkRuC0Mu05AFCo8m3RHu9R7rRfS8eC1-03h1o>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrjeeggdduvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvufgjkfhfgggtsehttdertddttddvnecuhfhrohhmpefhihhnnhcuvfhh
    rghinhcuoehfthhhrghinheslhhinhhugidqmheikehkrdhorhhgqeenucggtffrrghtth
    gvrhhnpeekgeejkeffhfefgeelieffueethfeludduhfdtteduvddthedtteeftdevfefh
    jeenucffohhmrghinhepudegqdhrtgdurdhishenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehfthhhrghinheslhhinhhugidqmheikehkrdho
    rhhg
X-ME-Proxy: <xmx:RhUPYYp8hyyk09FjHO52slj9iHEsmeMMJmNu3B-yNjhPoVx0shWXIg>
    <xmx:RhUPYRrHD2ewLRKpa4B5d_Rs7YqGpPPOXVVHB-1TyVbAf9I9rohneQ>
    <xmx:RhUPYWS-d6f-rIlBVSFfyq0czLW0ms7ASCv4EqXnF6-97wjeywrKrA>
    <xmx:RhUPYSDPGbX0vTOUByHmu4l5A6KTf5ieElk4JjRuzGwIB22UYtwTiQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 7 Aug 2021 19:20:35 -0400 (EDT)
Date:   Sun, 8 Aug 2021 09:19:54 +1000 (AEST)
From:   Finn Thain <fthain@linux-m68k.org>
To:     Mikael Pettersson <mikpelinux@gmail.com>
cc:     Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-m68k@lists.linux-m68k.org, stable@vger.kernel.org
Subject: Re: [BISECTED][REGRESSION] 5.10.56 longterm kernel breakage on
 m68k/aranym
In-Reply-To: <CAM43=SM4KFE8C1ekwiw_kBYZKSwycnTYcbBXfw5OhUn4h=r9YA@mail.gmail.com>
Message-ID: <31298797-f791-4ac5-cfda-c95d7c7958a4@linux-m68k.org>
References: <CAM43=SM4KFE8C1ekwiw_kBYZKSwycnTYcbBXfw5OhUn4h=r9YA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, 7 Aug 2021, Mikael Pettersson wrote:

> I updated the 5.10 longterm kernel on one of my m68k/aranym VMs from
> 5.10.47 to 5.10.56, and the new kernel failed to boot:
> 
> ARAnyM 1.1.0
> Using config file: 'aranym1.headless.config'
> Could not open joystick 0
> ARAnyM RTC Timer: /dev/rtc: Permission denied
> ARAnyM LILO: Error loading ramdisk 'root.bin'
> Blitter tried to read byte from register ff8a00 at 0077ee
> 
> At this point it kept running, but produced no output to the console,
> and would never get to the point of starting user-space. Attaching gdb
> to aranym showed nothing interesting, i.e. it seemed to be executing
> normally.
> 
> A git bisect identified the following commit between 5.10.52 and
> 5.10.53 as the culprit:
> # first bad commit: [9e1cf2d1ed37c934c9935f2c0b2f8b15d9355654]
> mm/userfaultfd: fix uffd-wp special cases for fork()
> 

That commit appeared in mainline between v5.13 and v5.14-rc1. Is mainline 
also affected? e.g. v5.14-rc4.

> 5.10.52, 5.11.22, 5.12.19, and 5.13.8 all boot fine. 5.10.53 to
> 5.10.56 all fail as described above.
> 
> grep ^CONFIG .config below, everything omitted is of course disabled,
> including I might add CONFIG_USERFAULTFD.
> 
> /Mikael
> 
