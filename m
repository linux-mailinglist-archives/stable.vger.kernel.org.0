Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A803832EB8C
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:46:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232165AbhCEMpZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:45:25 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:45569 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232736AbhCEMpL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Mar 2021 07:45:11 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 3F1D05C015E;
        Fri,  5 Mar 2021 07:45:08 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 05 Mar 2021 07:45:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm3; bh=I
        Ao/TgFkA8q1KfzfOfn2Nsv0DUppMxw1zg5zaLqW+h4=; b=mg+5N96KQQPm6V/kc
        Q8rt+IAU6YFygpZPWLMx3KO0fWc8IrFSQtrmEVCJtv1lcZsz07Qw4MzxgjqPAZOm
        l7hSY+8QO1pKnzENU7ymBDkZHpAvmUGFuM/Dq4tY778aPq/8GAbnYolwka8MBE4i
        DbFtIQWYPh01p7o5JLgdwyW/sE1PSeNT0mgZTH0D2SDveCV5Zoe5TgmWNDOWOOUE
        xPbz4t2CkzYO8GZ1yCKrqKwQSJifAkHOAipuoCFdzndV4AllFcjKguj+11s8VSjU
        D7iN4j+B2pPyvXNgfH4okgHMax33rTFLC6wDoOprXWAY+SWMSgcVo+0/es6x/r2K
        BSxiQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; bh=IAo/TgFkA8q1KfzfOfn2Nsv0DUppMxw1zg5zaLqW+
        h4=; b=khH5NLEghVktTwn5QOONrzUmpCifAV2n7FfB9u/Dzb6Iv2+iE63SU+N/e
        TyHFbrHVg1QiAfgUHLnDU2Ie0eN9xIm6R17m614Sjn5ntL92FmgWXXNUCtbgnv+9
        NcRkFlESVGlvnWWz092ohahPvwlh+mIDP4RDZao2oLx715CyEjq5wwDsy8sysJed
        W1NhMCvpYMLMd9mM2oYD4SoJ8WQApxvV6nfUcG9XNJOAstpAeNiXs5kd9oC2EjRE
        ncD9m1yQrMnCpOz7n8TV1PcYjx4sqWDeDoTZvy/vegHkMOKvDTctJh2zvW1e5eIR
        tmHPE3Rbul/j1ssMp2SJNrVcSlwxg==
X-ME-Sender: <xms:0ydCYPKtHzlwwgbGH0xGO3Nhd887VxJ_6CtAWpXuGkSeu2Qzd2ZJSQ>
    <xme:0ydCYG9QkUd8JiItlXkEMjPUGUc8XLiG7fQLfVtJsq6gYfCkm0-4Z5uVvv9MHnKaA
    CYPNSpY3bZ4sA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddtiedggeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtugfgjgesthekredttddtjeenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepueehke
    ehlefffeeiudetfeekjeffvdeuheejjeffheeludfgteekvdelkeduuddvnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:0ydCYAxZxMGhpJxgYZ0UUtPmtExL0iFuE-it2giy5DIBx2uurFpb5w>
    <xmx:0ydCYL4NhdtmVo07YDN16ftB4HdGG1JXGRRvMQ-NQN4PUryA1ObaTg>
    <xmx:0ydCYP-IkP89m7ClHojwkSdxhYnr7Q6Tn8k6_LCTaXcgqpXCyIqTKw>
    <xmx:1CdCYAMefQxo-tRBRdhBaUbKIzwMyVPy3Gz2HsvkyNqMJzv_Gk9nwg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3B37B1080059;
        Fri,  5 Mar 2021 07:45:06 -0500 (EST)
Date:   Fri, 5 Mar 2021 13:39:08 +0100
From:   Greg KH <greg@kroah.com>
To:     Petr =?utf-8?Q?=C5=A0tetiar?= <ynezz@true.cz>
Cc:     stable@vger.kernel.org, Rui Salvaterra <rsalvaterra@gmail.com>,
        openwrt-devel@lists.openwrt.org, rosenp@gmail.com
Subject: Re: Backport of 'usbip: tools: fix build error for multiple
 definition' [Was: Re: [PATCH] kernel: backport GCC 10 usbip build fix for
 5.4]
Message-ID: <YEImbOQrEbb002VL@kroah.com>
References: <20210305120931.692973-1-rsalvaterra@gmail.com>
 <20210305122236.GG92607@meh.true.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210305122236.GG92607@meh.true.cz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 05, 2021 at 01:22:36PM +0100, Petr Štetiar wrote:
> Hi stable,
> 
> can we please get following patch from v5.9-rc1~142^2~213 backported into the
> stable kernels?
> 
>  From d5efc2e6b98fe661dbd8dd0d5d5bfb961728e57a Mon Sep 17 00:00:00 2001
>  From: Antonio Borneo <borneo.antonio@gmail.com>
>  Date: Thu, 18 Jun 2020 02:08:44 +0200
>  Subject: usbip: tools: fix build error for multiple definition

What stable kernel(s) have you found that this is needed for?

thanks,

greg k-h
