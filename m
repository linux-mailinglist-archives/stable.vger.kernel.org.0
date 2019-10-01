Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D83ECC40F2
	for <lists+stable@lfdr.de>; Tue,  1 Oct 2019 21:21:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726922AbfJATUd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Oct 2019 15:20:33 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:33321 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726918AbfJATUc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Oct 2019 15:20:32 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 8D735224E7;
        Tue,  1 Oct 2019 15:20:31 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 01 Oct 2019 15:20:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=hiW5hSCu17btFLmUA/d+cfpdXCR
        gdy/ReqV73xHKj9c=; b=mdNbOzciVOX3hpxuVH5klsCkblFtgFfXNOC72AqFNXX
        zCBETXewTLM6r3Uqkz+AXlC7f7x7JBiwPIk/UvQjy/VT/sr9qPUopxfKmOgv9r/m
        4H2L1+z1dfjx0k+2KLwj2r29zW2dGllYXrRKctJRqsckIgiSai/ExOzp+E0pVPad
        QhIMUlRtcdX0803vpX0wrHE4UwSB+SE9iSQYf4Msspx6V7Uvfqx9vZR4PrcaVqYJ
        SNq3AfRqBtyKBHOyJeFfx+5C/SielaaAy00yphBFHp5BOVly77+HR1HrMsTETwtK
        dbRaizrBIgwVaRlO/rVK2GLhL7v8DQVyOZHyVmo/tRw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=hiW5hS
        Cu17btFLmUA/d+cfpdXCRgdy/ReqV73xHKj9c=; b=vWmdAj4qes6XS4jZ348JcY
        u7V1BizHYoRlETOuf6s3q4GWSNeYozdDoHCLLgPyQfqb+NfmuH3h7FhIdReE901s
        AvEw3fq8VzyM0d9Hmfdgd43d8XdK2P14fNSbDehvcvS3vVlEWEcu3cpUJ1yAOqBb
        fj16LmWFLnLPdIMdbdM/O+cCJKRCbLeHOP9EE8MBRzHAkIQrIcx7qY8wE0QT3uoQ
        O+CA7yDpVVePyDGQmnLWUGB25MfL726MbhJsOm6THcxYCfZaY5Zr4xMwbh5luCWX
        t/8Cb9vfbxJkHHaqGLd3lFeOyKJSKCkm3GK+GYpYCDqXao5w1ucjI5iEDyocKzHw
        ==
X-ME-Sender: <xms:_6aTXdpQsf_fdC0kJpJVNNgHqCW2sX5_rBPBPyH4gyE2FbP-NYlbjQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrgeeggddufeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuffhomhgrihhnpegtkhhiqdhprh
    hojhgvtghtrdhorhhgpdhkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrddu
    tdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhenuc
    evlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:_6aTXZ772s4QZju4MvLJFKHm2Mimbm3Hjw2Jb72NP-syKLOTtW_k8Q>
    <xmx:_6aTXfqxHWg2uowymey3IrHFBei3T6xwP5oLRBixtnylJ6davgruXQ>
    <xmx:_6aTXfKCoisQ4OcTKgdaFjgCSZu5z__OkKO9O7vE5hW-38hLCIwmew>
    <xmx:_6aTXW4XcM5grZg5_TNHQiVtAXTs004K-dbkyYESe2brIdxKeXFdiw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0B6E780063;
        Tue,  1 Oct 2019 15:20:30 -0400 (EDT)
Date:   Tue, 1 Oct 2019 21:19:39 +0200
From:   Greg KH <greg@kroah.com>
To:     CKI Project <cki-project@redhat.com>
Cc:     Linux Stable maillist <stable@vger.kernel.org>
Subject: Re: =?utf-8?B?4p2MIEZBSUw=?= =?utf-8?Q?=3A?= Stable queue: queue-5.3
Message-ID: <20191001191939.GA3962691@kroah.com>
References: <cki.0FBC5E477B.VNOTHXGKDZ@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cki.0FBC5E477B.VNOTHXGKDZ@redhat.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 01, 2019 at 02:32:36PM -0400, CKI Project wrote:
> 
> Hello,
> 
> We ran automated tests on a patchset that was proposed for merging into this
> kernel tree. The patches were applied to:
> 
>        Kernel repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
>             Commit: 0e7d6367ac13 - Linux 5.3.2
> 
> The results of these automated tests are provided below.
> 
>     Overall result: FAILED (see details below)
>              Merge: OK
>            Compile: FAILED
> 
> All kernel binaries, config files, and logs are available for download here:
> 
>   https://artifacts.cki-project.org/pipelines/199890
> 
> We attempted to compile the kernel for multiple architectures, but the compile
> failed on one or more architectures:
> 
>            aarch64: FAILED (see build-aarch64.log.xz attachment)
>            ppc64le: FAILED (see build-ppc64le.log.xz attachment)
>              s390x: FAILED (see build-s390x.log.xz attachment)
>             x86_64: FAILED (see build-x86_64.log.xz attachment)

My fault, should now be fixed, sorry.

greg k-h
