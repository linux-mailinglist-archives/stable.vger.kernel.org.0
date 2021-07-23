Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B8113D34F7
	for <lists+stable@lfdr.de>; Fri, 23 Jul 2021 09:01:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234093AbhGWGVF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Jul 2021 02:21:05 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:47073 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234089AbhGWGVE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Jul 2021 02:21:04 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id 4CC565C0054;
        Fri, 23 Jul 2021 03:01:38 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Fri, 23 Jul 2021 03:01:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=ucph8GkSVtGZd/e1zJ+JvCnPioK
        M6Rmi5qDllTc4ktY=; b=PCvCMIourWo9sbULkHihm3qhou80iprLlkC2kOyVZN0
        u1H3wDpXAWruRGdwYWha7V2HVeVm5QDXWH4KEx4yV4de/YfMilQcUfErYQg4St6e
        bTzSwZjbtoBo+QkggpBfvbc5kImI79gzJKJTgYVKyTVcfsLv6YZwEXwrSPeGIUR8
        OaA7g30TRwuIn9cYDYkBrm9cQgLTRIsWFrZSGEoNxBi0i0CVIefFBWVlYVQbrTpI
        NUVCcZzls0sByJHXFe3I030TCjZegtT/lPnyjgTqYnIPpGOE+82C73aijZyzrUrw
        HM2I9x7e5mmvp2yDByDNTYUupo7O9uFMuQubNBHQBLA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=ucph8G
        kSVtGZd/e1zJ+JvCnPioKM6Rmi5qDllTc4ktY=; b=aOnwVmLOyNKLkhLnx6xSM8
        6Yr44Dl8NkcB6FFbjTFPoIih4Uuck4B5fQ1MiA0B/813LHRiQrGNjoVQgifGekJo
        ai9zZq4zSQ+BJj9dxvNwDh/A4tuUkG+g5I0NiNAaUFIoaFS2T/5gGf+qFeS0tQMd
        C6eKwHwGMcPIcols6QL9sQgaGZu6urxEt03TRG2DbyS4I9r2Uq0aG7jhMJnyxfB9
        ZsTwwx0vrtHXbdRaj92x+YrCTbNcao94oG+JnEWvsH/DQzoaZKo7Ga+hPKxqQKpo
        /5694qfCS/Er2ofl0oamHzGoivTgFBqz0KvfFIkfF4He7EaY2ZMBwaSsAPoAwV/A
        ==
X-ME-Sender: <xms:UWn6YMof5dM0ZD1_4Z6lsnuAI-JgXFmqQBbFDoApv_fteZN7H3xaMw>
    <xme:UWn6YCohTNUZWlhrbO8vgNzy2tLClNGU79c3hXBPZM_OCLAooakUDzf3wMD4xxc8_
    GqZLKS3MYFG7g>
X-ME-Received: <xmr:UWn6YBMzTi0dZnIm7GU8YQkEkpmRiDH9eb-qjrWwb-64ACVwyo2noewu6yK3bU1IyTww7Cubj3PaEo6VrrCs6dKP6MQHUS0->
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrfeejgdduuddtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:UWn6YD49lmCpxcMTTY5Nk_J96FcgYcRXQe4xv3Zw5XqvIEZoMgAwXw>
    <xmx:UWn6YL6LaZA33Yspi1tOT0V1xVPXnUAqDFLjuY5GItaVaX7unFv0ZQ>
    <xmx:UWn6YDjQi2jEpxU-3N-ENkINNJE0XEnHuRK-srd3Revou0F2dJaOeQ>
    <xmx:Umn6YO2loWHjn_GzDMpGx9lgT8CWjz8DTfeRxbtNkEkFQzbyszlK5g>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 23 Jul 2021 03:01:37 -0400 (EDT)
Date:   Fri, 23 Jul 2021 09:01:34 +0200
From:   Greg KH <greg@kroah.com>
To:     PGNet Dev <pgnet.dev@gmail.com>
Cc:     stable@vger.kernel.org, regressions@lists.linux.dev
Subject: Re: boot of J1900 (quad-core Celeron) mobo: kernel <= 5.12.15, OK;
 kernel >= 5.12.17, 5.13.4, slow boot (>> 660 secs) + hang/FAIL
Message-ID: <YPppToU9X3LZYwoe@kroah.com>
References: <5b5d1b7f-7327-52a2-5221-de39206a07a3@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5b5d1b7f-7327-52a2-5221-de39206a07a3@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 22, 2021 at 05:10:02PM -0400, PGNet Dev wrote:
> My servers run Fedora 34, with latest kernels.
> 
> Updating to any of minimally- or un- patched 5.12.17 or 5.13.4 hangs/fails, as follows.

Can you use 'git bisect' to find the offending change?

thanks,

greg k-h
