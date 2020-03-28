Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7073619648F
	for <lists+stable@lfdr.de>; Sat, 28 Mar 2020 09:49:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726244AbgC1ItO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 28 Mar 2020 04:49:14 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:41221 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725973AbgC1ItO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 28 Mar 2020 04:49:14 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id BFAF1853;
        Sat, 28 Mar 2020 04:49:13 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Sat, 28 Mar 2020 04:49:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=COIVPIbW1M6foH/DUrtQQ5CHkP8
        epgL54WI4amWcywA=; b=n3DUOthW5M0nvexIOcbXohufM64WnAV5WhZAqX5QJpT
        Z0pTtLg6m1CtlEK6+G76o2IZQyf28pQvRTZQZHbW+ZXwEwXeWWwv40tmxtiWH9Uy
        nWPxMKvc+FkvcjvNl22oQ5IC/LqLOOOI+/dlAtEAt8bGYoS2dHoy8WlUYWa8Tyk2
        14Oe+QHEc/ZvviR4qJaZD0eZEaCcWZNEFWjXPtx6mjimBh7UADrZcdDCsx8+mnxz
        8EBnt3HAzYqAbVHj2uzT60ATd7Fe9SgaGfybyKstuenhkAC8ampwRKvCooxSgNzM
        uGOGjSEiFnecyCmIMzQc2TINlr5+UkTfEOe3cjYAjZQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=COIVPI
        bW1M6foH/DUrtQQ5CHkP8epgL54WI4amWcywA=; b=GlzQs9hrrU553YIaOjm/Il
        R7dmt8LoArC+gPZFfo7Zg2UM28Yp/+IFZNsp+ERIzYPNg8eIRQAcOK2rMxVvgmUR
        QALNlejJoUEO/BmfNbiXT/hJqQ74fXS1fxpOJFnOvIHavNo9JaOg+B6/wjHZKU1R
        84fpqdYSzQkgtamaMbmDGkKV5Hfc61S6bkAOTEJKw/5CRUQheLHR5hhOPkqYQzIQ
        kLlnqM8nEcAQb+AXlCrDIGrpQWVk0LKMG6jmM6qZxNS8kWf7KqPlzAyuKLNKz9q8
        /6NnQFysLQibjYdDxHGD3Ic3qnKH2CjXkZwn+nh8DFsM4vr7fQusIxv4yuGrGHpA
        ==
X-ME-Sender: <xms:iQ9_XpEGqdxvfkfVaM3573q2yTms_mOMmiEcei_NXXCHGOlxl9iiqA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudeitddguddvtdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppeekfedrkeeirdekledrud
    dtjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehg
    rhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:iQ9_Xnc_wv3_vWNNzQY7JFaSRdToU-VSgnpTzVUjU8xgOQkbUclCag>
    <xmx:iQ9_XkBiktimx-VcxH0vpDuqdmFawmipgBP2XUIuX4blBPaszSedSQ>
    <xmx:iQ9_XhtJtF3WyMwhCHUlRLyA8XFtSy-NgR6_ATf812ZRrM5S-PsU8Q>
    <xmx:iQ9_Xrwh84ztnH1xNr_ZHEgdqsPJjFqML_ZqqqQfTbXeXXuuaWFMkA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id C29D93280064;
        Sat, 28 Mar 2020 04:49:12 -0400 (EDT)
Date:   Sat, 28 Mar 2020 09:49:09 +0100
From:   Greg KH <greg@kroah.com>
To:     David Miller <davem@davemloft.net>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCHES] Networking
Message-ID: <20200328084909.GA3700205@kroah.com>
References: <20200327.165104.1888725401936017964.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200327.165104.1888725401936017964.davem@davemloft.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 27, 2020 at 04:51:04PM -0700, David Miller wrote:
> 
> Please queue up the following networking bug fixes for v5.4
> and v5.5 -stable, respectively.

All now queued up, thanks!

greg k-h
