Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11D991F0B37
	for <lists+stable@lfdr.de>; Sun,  7 Jun 2020 15:01:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726520AbgFGNBy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Jun 2020 09:01:54 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:34075 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726465AbgFGNBy (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Jun 2020 09:01:54 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 0C3975C00CD;
        Sun,  7 Jun 2020 09:01:53 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Sun, 07 Jun 2020 09:01:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=9g++IuvBOw7OWVlogdzSw3T2JNn
        VLfV/jMqJmCk5vsQ=; b=ZZHg7uBR752/5SfzkSJCLk7L/oLDwATzkYR0bqstVpY
        rJRCzNqk3WEbgDficQvn+h5mdGeZUF7jxJS5iSd6djbbxmB1sOhivZXa52Vu/pz+
        LSP/186S11NVremQnrXyHsPygj9ZbjkWLa/LN3FqLVMeHyEU0Ubx1f2vusRMWl60
        9uKGu8NOyoX1rQ3aw5R0Yacvs3wCOP2tX4W32J6rGslFNTX6vCGABkg47DjfSOjb
        END5IxyD4C/r4yHup71TQRNTtiEY1dsSsXPAWrrCBUtPziYkNSvGpYdWgfBbadt+
        S+AOS0vqfzL+GBiyVK80dSyonD8X1DwMeU+ATG231Vg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=9g++Iu
        vBOw7OWVlogdzSw3T2JNnVLfV/jMqJmCk5vsQ=; b=QPiR4Ql4CIMGGG12hi4cPj
        z4tfBuf4qZSosFDTax9NzfTLoJoOACME8SjdoSbQ28qtIYZ7Y9g2WzqpDI/vPJwU
        c2Q7T0n2eOcC474W8c46h/Eyrj0EunUu6RqI5i5yA3h88uV+JTAGbPa3YCGbyqTL
        2iq41HqzhxPnzlGysFE0SLg1ZK8e155Fj06i/jcFWoja7mCJnWjJEXCkarIy/j+P
        Q/LYcLNM9eeFNQoWPSbwkYrcL9twYe0rtRVgpuVecgRMvRwsRCxf9ofOjBiVS3IO
        NvqFyP39EdC0Xo/7ru9/sEvNbqMqTmtnm1xWr6K5gXWeaULvuS2jNKkAwTUkDF5Q
        ==
X-ME-Sender: <xms:QOXcXkRgAe4DlyctZ46y_ClAmnwJMSuIu1zb5JgAy3GFu9JVxeHQ9g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudegledgiedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:QOXcXhwxuZFu-rAl6NJpAFApZfiEFvEVw-kgvGY-p0HBnJpckAFdig>
    <xmx:QOXcXh1pKfOlZRurLcz4ySreiDnsNe6jfrqQBG_M2lVeTWBRv96NAg>
    <xmx:QOXcXoA7sQ7FIW7ZlEimDx28vM44NWjLid6FUfr9Ey9aMVEiBVo98A>
    <xmx:QeXcXosPHDv-2G_vvhGh5R_elfVtqq0KazbXZ5qdHf0vCNR6993bFw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 867E0328005E;
        Sun,  7 Jun 2020 09:01:52 -0400 (EDT)
Date:   Sun, 7 Jun 2020 15:01:51 +0200
From:   Greg KH <greg@kroah.com>
To:     David Miller <davem@davemloft.net>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCHES] Networking
Message-ID: <20200607130151.GA147580@kroah.com>
References: <20200606.195515.1705304573006551137.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200606.195515.1705304573006551137.davem@davemloft.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jun 06, 2020 at 07:55:15PM -0700, David Miller wrote:
> 
> Please queue up the following networking bug fixes for v5.4 and
> v5.6 -stable, respectively.

All now queued up, thanks!

greg k-h
