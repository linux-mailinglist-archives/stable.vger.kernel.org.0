Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 500423637E
	for <lists+stable@lfdr.de>; Wed,  5 Jun 2019 20:43:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbfFESnX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Jun 2019 14:43:23 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:56579 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726305AbfFESnX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Jun 2019 14:43:23 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id AC3432134B;
        Wed,  5 Jun 2019 14:43:21 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Wed, 05 Jun 2019 14:43:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=XjSDSERcX5eVnQvGa2z3d44G6BD
        UvBbcos/tt2mjxSM=; b=hN2XUBpqh0DmgRGUECsrNmJh3Il4xW8GjeVUV6kiRBT
        h87B0xa4TWxFbg5hL2/Vqo9bLg1J3ha5R/xfpt4SEqitrqy/MdkQ+YtXd7SZZ7s/
        rI5G8C+H79dA4wVlCpDTf8d8B+FHuOuMCHswUlYy8yBYvDpMPBEdnpVfWt1+3QC/
        8L3ymyuEDdznq0M+V5VkIts/Np1qgmgdR5SDnDa1A0pcjrYvQnJHY+i5/yCmnuCF
        HJeCD61srA+B3UblYoTjQqspXMBPkvYAXvfhp3aBIPrKL3YBtq16bKAS3HO4qpxV
        DrJ9eqt06c4FlycYPjlqy32SVbWlz6/cUdANkZis80A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=XjSDSE
        RcX5eVnQvGa2z3d44G6BDUvBbcos/tt2mjxSM=; b=l8+I3l5d+zRU8+VEtUbiDK
        gSzde79yZKoZOJEGhyRfzNURP4/kiK3/J5ocHoxyfmwgLFjUJaYn4d5qq8QxjVdd
        0Xl9p5+dYxUvppzAcUwl/mg1woGLEQfUQAtDnfDGbcg2eNse1lqIGzXb2grN0DaW
        H5QArcbh+8asMdY0J+onoQOay3e+mIxARGo2PxyoLK247Sit8ohVvXQWdSm1ntGe
        oK2W0JC8z2Wx5hykMOl5Zltr00BXO3RMyFtsCdfUzgCWMqcej7G1BCyh0AkQnfli
        5sKbV/IWcPB6X2/Y8BTo5x/amYRKtxSdrqbDpiZByTvwAWeopMt6KvoiVTAQiMaw
        ==
X-ME-Sender: <xms:SQ34XHxtS7I_jn8VCYwhPiTGqGC7a9-HKy-T_Mbnb2w5d6h_n4vCpw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudegvddgudefudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefirhgv
    ghcumffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:SQ34XESj8Gows134a8uT7cinNg1yQL2xxo7aB_QFEhgSG-x6NLZ48A>
    <xmx:SQ34XCNjQVHjs4YPvii0DBDGWRYCDT55ZPcJM6PfTYP2Y5S8NsniAw>
    <xmx:SQ34XHTr6upfWHtiB9CDnvsncf-n3Co_SMGtg94mSfvlA4ZUkW9lHw>
    <xmx:SQ34XPpqTRyvjWbOtVgCKttwAngraSZ9ZGs_jkngGiMiwGYvIoqRbA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id DA8C5380087;
        Wed,  5 Jun 2019 14:43:20 -0400 (EDT)
Date:   Wed, 5 Jun 2019 20:43:18 +0200
From:   Greg KH <greg@kroah.com>
To:     Kees Cook <keescook@chromium.org>
Cc:     Alec Ari <neotheuser@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86@kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] x86/build: Move _etext to actual end of .text
Message-ID: <20190605184318.GB32750@kroah.com>
References: <CAM5Ud7NhtKDCMnf+zbsRH1N8V6=kCpEJ5NCmJ4mOQSdVA_noMA@mail.gmail.com>
 <201906051114.6DEF834@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201906051114.6DEF834@keescook>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 05, 2019 at 11:16:06AM -0700, Kees Cook wrote:
> On Wed, Jun 05, 2019 at 11:08:13AM -0500, Alec Ari wrote:
> > I'm having this problem too, build is failing:
> > 
> > Invalid absolute R_X86_64_32S relocation: _etext
> > 
> > I stayed on the 4.14 branch to help prevent these kind of breakages,
> > so much for that idea. Gentoo GCC 8.3.0.
> 
> It seems to be a problem with the Gold linker. Using ld.bfd appears to
> work. I haven't narrowed down the problem, unfortunately.
> 
> Greg, given that this change was only for special situations (Clang
> CFI), can you revert this for the stable trees?

Turns out that Android required it to be reverted too, so no one needs
this :(

I'll go revert this, thanks.

greg k-h
