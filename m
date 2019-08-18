Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 562B59190C
	for <lists+stable@lfdr.de>; Sun, 18 Aug 2019 20:49:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726115AbfHRStE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Aug 2019 14:49:04 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:37521 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726005AbfHRStE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Aug 2019 14:49:04 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 7805421B36;
        Sun, 18 Aug 2019 14:49:03 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 18 Aug 2019 14:49:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm1; bh=8
        AF28BINYGwkofGMv7RKfCm+g+0CssOgKU/p8dG2bCA=; b=oozoWQBooccpahywm
        AABdlu4OlF68n6uSMmQMKO2itErj4PiWoANDKp7aVzGd2PiRpUquS2eOf8xvwWnz
        iPCNsg2WC2CtHnI5dVAnlyaCBx9GeW4EsYLFubjkSI49Dj2KdTdcMzUBLN/y3kIE
        KreHf5kk6wy9UEpI0UEFWL0nlpF5lGYU1j0EFVkV21OdysBJrPqDoWLcLEZ/oT2T
        Oak6AZOJgmXRnluaRzLmQ4x/WIqnwNnzlH8eGMlSPyh3o2uEVTCyMDfS4mlRqT0i
        Tnrwy6immYQCq58nesqpqMlpBt/j+hO4IZz7veFMmQsM+Cs2xDDYLiNhStB7yep9
        pU3wA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=8AF28BINYGwkofGMv7RKfCm+g+0CssOgKU/p8dG2b
        CA=; b=A2avYhIzbfm4M9tyEEMbegUNb69akMvshHQD/mzc8BNhnr1W2X9urxax4
        fCA+o1gLiDbqy3t8ZOO9JN3vBi6FRnAfPO9IMCRa8TjAtHr4XGg6Fv826bT8NOzj
        uRPRJqKvckJoLZaI1DX7GTxpeJg8I2+3HRlE5IkVjJ4rg0cKzjObhuWoAJ6baJ9U
        zftkV6uXHKW/9mf319oNicdvWWejOl2EqE5xQaDeNlJYRf2EE9Od/EcsmmoQypjA
        JLhMFdgfI0g+lIBUo383hfKCuv+QeD9rVe3aNoKJA74nApjqJe3O7Jwf+R8ckCuo
        Jc2JU8k+SrxRqIXQVpLE3HnlwXc9A==
X-ME-Sender: <xms:np1ZXRjz1IX30pu9DoeZDLqVHYTmymtS5Jb2Bqu9W8ohdOdG7HnPug>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudefjedguddvlecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggugfgjfgesthekredttderjeenucfhrhhomhepifhr
    vghgucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuffhomhgrihhnpegtkhhiqd
    hprhhojhgvtghtrdhorhhgpdhkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeel
    rddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
    enucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:np1ZXWeE3Wur_E171zwjBXoJdTz6lKJJIHShKb95AWGMCq-Id9qxEg>
    <xmx:np1ZXQ1aHbTtUsPFWWz-WXVVSkF4yjSr-knBfgm85dUWKbTztVe4Ww>
    <xmx:np1ZXSrV9K-lNjNdb8zjfChVrCmKLswJgIp-GSgQvCOgALUTI30yvA>
    <xmx:n51ZXdB7KaYIVy7Kbwi-1DpTPQiP2qW_PjSoQdiiRSh_JBJqI5IAAw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 67E818005A;
        Sun, 18 Aug 2019 14:49:02 -0400 (EDT)
Date:   Sun, 18 Aug 2019 20:49:00 +0200
From:   Greg KH <greg@kroah.com>
To:     CKI Project <cki-project@redhat.com>
Cc:     Linux Stable maillist <stable@vger.kernel.org>
Subject: Re: =?utf-8?B?4p2MIEZBSUw=?= =?utf-8?Q?=3A?= Test report for kernel
 5.2.10-rc1-61d06c6.cki (stable)
Message-ID: <20190818184900.GE2791@kroah.com>
References: <cki.8FD44CAC8D.KLM2TF66J1@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cki.8FD44CAC8D.KLM2TF66J1@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Aug 18, 2019 at 02:31:22PM -0400, CKI Project wrote:
> 
> Hello,
> 
> We ran automated tests on a recent commit from this kernel tree:
> 
>        Kernel repo: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
>             Commit: 61d06c60569f - Linux 5.2.10-rc1
> 
> The results of these automated tests are provided below.
> 
>     Overall result: FAILED (see details below)
>              Merge: OK
>            Compile: OK
>              Tests: FAILED
> 
> All kernel binaries, config files, and logs are available for download here:
> 
>   https://artifacts.cki-project.org/pipelines/108998
> 
> 
> 
> One or more kernel tests failed:
> 
>   aarch64:
>     ❌ Boot test
>     ❌ Boot test
> 
>   ppc64le:
>     ❌ Boot test
>     ❌ Boot test
> 
>   x86_64:
>     ❌ Boot test
>     ❌ Boot test
> 

Are these all real?
