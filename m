Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E97B13CA474
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 19:31:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234083AbhGORe3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 13:34:29 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:35321 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232933AbhGORe0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Jul 2021 13:34:26 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id BC3E35C01A4;
        Thu, 15 Jul 2021 13:31:32 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Thu, 15 Jul 2021 13:31:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=ZKt08GWlKwTR+3ZcsxkQKWxaC4m
        uTY2tJEb4iWkaqBs=; b=hfvZjP42B+1HlNLp1/E2+VYFyEEpWQB49zmqgsDynMl
        NoxjH2Ktlh4Fw1/eP0EMt3+TCOup0CIKhzwDaapUxIafkiC2DFS2KQSCm/LDEhIn
        twURKJjTWgulxMm0aPw7uOSdNjSM2X+hclFHp8CzbLSQKak/YjgT/8Xgbt2XuyTI
        7vCtrwWg09T3YOLYGD8t383G8teqKIAc/le34NSi0RI91tJLtrDdkFH+DxRxGveg
        kbial311oRul0PbojRpi4qOikT+BemobiNd/T8TOeasrM7bJZ+nu6ihKjkZvjT+W
        eB17J85D5yIMFxYVTEELpgSYNaY5dNReSkV4eDFfaIA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=ZKt08G
        WlKwTR+3ZcsxkQKWxaC4muTY2tJEb4iWkaqBs=; b=bsgTygOOJ+zG78FZwrJDBi
        GdiuZvnyBGtp7zaacYdbf8KZB5KK7iDTZ7fMy8iqcNUQ1iL3YekZqpgqRC/lx51g
        31VBPDAnkoeo101/OX3js3tEQN/Hl32Ze3se0ydp5iUII429cJLxOhbD+aGQuf1w
        MeGK9FVXMbvFbCzvHTqr/ZuQRSWsEEJtJgRY6b1qXvp+4Sg+IxKyI8/PNUdcNGw+
        G9E+Kk7ONafyM2W0M6VtdOymcx2MyM/XbD9A7DeUwbnZT2QR4MCeLXzRKLanrNiW
        MGBV+D2cb1KSYFQBycfh9czxFq/yQHXVGxANLEKuVqZUIunTOTOMZ6BqP63hC7kA
        ==
X-ME-Sender: <xms:9HDwYJjy9bFMZbJiPqtqbleEEB9QRMVTJxs_2IJ0D8M2Osb8j9u-vQ>
    <xme:9HDwYOD2wnlR96QkDsEfKSTgV1zokIjwI2aDVxuvheYduC_4Xuse0Aj08iVwDW1hD
    D3Lo_6i0QgskQ>
X-ME-Received: <xmr:9HDwYJG1sM9UjfZ-QsVIq2es2rTPnhK62uubovM_A8FI1knurZbRn4h7Mb8hOpZL_nlhyyQUuxGgFFlUUgrdOGQjxQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvddtgdejjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepiedugeffud
    ekjeejheevhfdutdeugeduffdtueefgfehiefhudetudeuteduleegnecuffhomhgrihhn
    pehkvghrnhgvlhdrohhrghdprghmrgiiohhnrgifshdrtghomhenucevlhhushhtvghruf
    hiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtgho
    mh
X-ME-Proxy: <xmx:9HDwYOQA7ZU0QhOW-91jPqW2171srlol8VHpqbJduEkIiUNk3IDKlg>
    <xmx:9HDwYGz9KYsHF0DUfEw-czShNT3eyzeXUk7Pex9P0NI1-FBzV4ErOA>
    <xmx:9HDwYE6LBsMHm2JMsStv83H_0g2vznCSsjA3_iFM63GYuk4PJ3uulw>
    <xmx:9HDwYAsAE5z2KdIh5mvJ8xCDhmirtFTaQ8HKnB8cexnhl7QJtmUqTA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 15 Jul 2021 13:31:32 -0400 (EDT)
Date:   Thu, 15 Jul 2021 19:31:29 +0200
From:   Greg KH <greg@kroah.com>
To:     Veronika Kabatova <vkabatov@redhat.com>
Cc:     CKI Project <cki-project@redhat.com>,
        Linux Stable maillist <stable@vger.kernel.org>
Subject: Re: =?utf-8?B?4p2MIEZBSUw=?= =?utf-8?Q?=3A?= Test report for kernel
 5.13.2 (stable-queue, ee00910f)
Message-ID: <YPBw8SQ/oQQXfguv@kroah.com>
References: <cki.8AA4B7C8B2.MU36FLBY8R@redhat.com>
 <CA+tGwnmVdw=B5rnz3QmHeu3jGdHr36yf4MJHR5c11w09tP9Amw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+tGwnmVdw=B5rnz3QmHeu3jGdHr36yf4MJHR5c11w09tP9Amw@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 15, 2021 at 02:51:15PM +0200, Veronika Kabatova wrote:
> On Thu, Jul 15, 2021 at 2:50 PM CKI Project <cki-project@redhat.com> wrote:
> >
> >
> > Hello,
> >
> > We ran automated tests on a recent commit from this kernel tree:
> >
> >        Kernel repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> >             Commit: ee00910f75ff - powerpc/powernv/vas: Release reference to tgid during window close
> >
> > The results of these automated tests are provided below.
> >
> >     Overall result: FAILED (see details below)
> >              Merge: OK
> >            Compile: FAILED
> >
> > All kernel binaries, config files, and logs are available for download here:
> >
> >   https://arr-cki-prod-datawarehouse-public.s3.amazonaws.com/index.html?prefix=datawarehouse-public/2021/07/15/337656806
> >
> > We attempted to compile the kernel for multiple architectures, but the compile
> > failed on one or more architectures:
> >
> >            ppc64le: FAILED (see build-ppc64le.log.xz attachment)
> >             x86_64: FAILED (see build-x86_64.log.xz attachment)
> >
> 
> Hi, looks to be introduced by
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/commit/?h=queue/5.13&id=07d407cc1259634b3334dd47519ecd64e6818617

Are you sure?  I fixed a different build bug in that area a few hours
ago, if you rebuild the tree it should be resolved.

If not, please let me know.

thanks,

greg k-h
