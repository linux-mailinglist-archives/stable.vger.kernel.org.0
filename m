Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7D28BB214
	for <lists+stable@lfdr.de>; Mon, 23 Sep 2019 12:16:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439415AbfIWKQQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Sep 2019 06:16:16 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:39789 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2439381AbfIWKQQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Sep 2019 06:16:16 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id F3B6857C;
        Mon, 23 Sep 2019 06:16:14 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 23 Sep 2019 06:16:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=og7hv9S+A36vyhNUshI2k3Z6yfW
        53mhgDBj5tYm1SLI=; b=DO6CUHNsbdFmp69UjYZMIkvuq+mXIKQA5L0K9yyzaeE
        oXHMo5pdBCvwl46Yq7fgoZqxn75NfKLq0/1mWTg7Pnwe9sC3Vfy+Z1HhXx+ApwFZ
        opJpPS6wfYVnUmQchsAICYtmyxQxS7M84Yi1jmplJwwL/nwYltZJIEj4fX1Wj+5P
        evx8I/NBe815BdbauExNqUQvBBzKPAB7kfisso96P3oA7sOYaKpc53dns8QSo3fo
        u625h9EwkfojYv1qcoP5zRY/TmEw4tgPfrlqGlljbQRI3i86klm+GOyMnZfo2a7a
        PZCiyS4XsUwvW44i++wV9jzwcePLTcHYwpaO0SYZ0fA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=og7hv9
        S+A36vyhNUshI2k3Z6yfW53mhgDBj5tYm1SLI=; b=oT22yCtz3i0z9kb1extcs2
        KeS5xCWJ+8VIicl5+CE/8b4TVDWgfykNScFhh+3jRDMH364b4MV5JH0x5qYU2i1T
        3+ttSYS/GLiRgtzaXGCvYnJxhV8W0QEgVCxE1pGHFpnpxhwwEDNKUPiB4jPPxYHB
        CxznUSLN+AqAnF73suwiv64iMsJ2VMcESs4gToKl/iNRbmwVabP6jM2oYPgF/PnR
        gWDIklDv1TmwVHMvVvmx+dqvQL7ZCS+Pp7d9e+IVW02dxm2NkVb3v4egh8p3a5kT
        SUDsF/dIcf34zSjSuhl/G1HtuDvKLztFWYtpyi9ouapHCUbpPTs9dpCHC1gYvW9g
        ==
X-ME-Sender: <xms:bpuIXesOXKZR-PAO0BrcO6S29in0iIctyix9MTqZnCMd0CdHWXZ1Pg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvdekgddviecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucfkphepkeefrdekiedrkeelrddutd
    ejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhenucev
    lhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:bpuIXfxo6NZfIje_x3x2USTBhNUB-iaRzUAPesrQvSsNBm6RuPd39g>
    <xmx:bpuIXcgklq4x42ncPhncznTcMyUkS_USj9XkAJc4GpBnTqmH-4HJyA>
    <xmx:bpuIXbD47Gs3maA-lOv8u3IKpFk1OVTDJzDC-bd8VciKf7c1lGjJWQ>
    <xmx:bpuIXfghfTVN3w_oWBxd7o3FOiK2CMGaARQxSky2PjlyPR05x7LJ9g>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id E69EE80065;
        Mon, 23 Sep 2019 06:16:13 -0400 (EDT)
Date:   Mon, 23 Sep 2019 12:16:07 +0200
From:   Greg KH <greg@kroah.com>
To:     Rolf Eike Beer <eb@emlix.com>
Cc:     stable@vger.kernel.org
Subject: Re: [4.14] please include 056d28d135bca0b1d0908990338e00e9dadaf057
Message-ID: <20190923101607.GC2763897@kroah.com>
References: <7888549.SPjspKb6cB@devpool35>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7888549.SPjspKb6cB@devpool35>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 23, 2019 at 11:40:41AM +0200, Rolf Eike Beer wrote:
> Hi all,
> 
> please include 056d28d135bca0b1d0908990338e00e9dadaf057, I can't build without 
> it. It is in several other stable kernels (e.g. 4.19). It fails applying in 
> tools/objtool/Makefile, but the fixup is rather trivial.
> 
> For reference, this is the patch as I manually apply it currently:

Now queued up, thanks!

greg k-h
