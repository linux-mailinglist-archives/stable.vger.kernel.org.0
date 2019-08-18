Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8213A91750
	for <lists+stable@lfdr.de>; Sun, 18 Aug 2019 16:20:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726097AbfHROUM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Aug 2019 10:20:12 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:53615 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725786AbfHROUM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Aug 2019 10:20:12 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 98C1021BF9;
        Sun, 18 Aug 2019 10:20:11 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 18 Aug 2019 10:20:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm1; bh=Z
        TIn6stjSrxzk3Nxai/fYfOkx6KtvVGx5bMZKNx5dVU=; b=pRQsIGbmjz1PyODIl
        TGdGKLTSjIH4YWprKXcel8tuiGaDwabHG37NDNIslnctV2g8tDY0BdJ8Q87JGV+U
        ar1vwAE3lOf8k/d3RVOl3cxsSowgZWWF5DEjQSZ7R8MOGNs0xmU9cgSo+Dh/w6kr
        4M+Ntyk/NIepAcHitaRuGGIZykPBdCHQMglyh6KmCA8Or8esevE8JzASxanPWIt/
        3IpqZbWBP/MuMD/fFMXfdwSl1UGL/YIJQxHmZJDfrmR9Bek2Vla5Abo0zhCassRl
        a47NdgEhc3IbZo/V/sHmDoBnP97kT8p2CMfd/9qSM5I0e/wKltt1Lz0RYTNIwA13
        oHSFg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=ZTIn6stjSrxzk3Nxai/fYfOkx6KtvVGx5bMZKNx5d
        VU=; b=UtwyetPU0ps9uYZJRcIs0mhQh5Z+Xhl3pWEvbuq/EwhthC/DQXXXvUTg6
        OqwY5V6izB29Tldot38ceQCd56Noib4PcG6mYh1f6qU12h71S+GNMgvYo+kNMROO
        BrjA0EvQg0yK/TLOxlEn6oVt4+Ib+kUIrdxB6oIuXdbvlrQPHALZR5lyxyMurBYs
        tUqeRC/JpnTOy0D1YueuEAlXO0uHW2sKV2GlpBOLA2pfPKlvlGDKY8fJHj80tnzg
        0OXWT7lJu8MkiZom8QoNfT5L1AjUOBokCO+hExcLdKiXoaBUqA+OiyJ/iM9XpcUK
        wARL/DuXGaGhVRGOq91O/IZ4NPLQQ==
X-ME-Sender: <xms:m15ZXft6MGEaurkhNR-hc4OH3lIDcmRwcPWD_cZ9O6fpCDQE5cnKjw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudefjedgjeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtugfgjggfsehtkeertddtreejnecuhfhrohhmpefirhgv
    ghcumffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucffohhmrghinheptghkihdqph
    hrohhjvggtthdrohhrghdpkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdekledr
    uddtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmne
    cuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:m15ZXSU3SiQ94gb_DDLo-Adk5dHMSXXLhCT5Mu17JiMaHeVdflo5Vg>
    <xmx:m15ZXX7qnv4bh2UougCAcCd6pFtnhcsIkDY5Rg_F9GXYhIVgbofwrQ>
    <xmx:m15ZXeZ0UOpPi2tz1xYF8fxW40FQdm-yjFwS6cCK5kNdCap8GCBzzQ>
    <xmx:m15ZXY91zdqueJma2bGa7sVvQcWAcEcPDu8xJoaMqk_ox4f5K5yurQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id E45C980061;
        Sun, 18 Aug 2019 10:20:10 -0400 (EDT)
Date:   Sun, 18 Aug 2019 16:20:09 +0200
From:   Greg KH <greg@kroah.com>
To:     CKI Project <cki-project@redhat.com>
Cc:     Linux Stable maillist <stable@vger.kernel.org>
Subject: Re: =?utf-8?B?4p2MIEZBSUw=?= =?utf-8?Q?=3A?= Stable queue: queue-5.2
Message-ID: <20190818142009.GA13411@kroah.com>
References: <cki.A5CB2BDFB2.E5K8JQ6VC2@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cki.A5CB2BDFB2.E5K8JQ6VC2@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Aug 18, 2019 at 10:05:27AM -0400, CKI Project wrote:
> 
> Hello,
> 
> We ran automated tests on a patchset that was proposed for merging into this
> kernel tree. The patches were applied to:
> 
>        Kernel repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
>             Commit: aad39e30fb9e - Linux 5.2.9
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
>   https://artifacts.cki-project.org/pipelines/108690
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
> We hope that these logs can help you find the problem quickly. For the full
> detail on our testing procedures, please scroll to the bottom of this message.
> 
> Please reply to this email if you have any questions about the tests that we
> ran or if you have any suggestions on how to make future tests more effective.
> 
>         ,-.   ,-.
>        ( C ) ( K )  Continuous
>         `-',-.`-'   Kernel
>           ( I )     Integration
>            `-'
> ______________________________________________________________________________

So everything is now failing?  Any hints at to what caused this all of a
sudden?

thanks,

greg k-h
