Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 376544666C6
	for <lists+stable@lfdr.de>; Thu,  2 Dec 2021 16:36:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243756AbhLBPj6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Dec 2021 10:39:58 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:56663 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237530AbhLBPj6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Dec 2021 10:39:58 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 3D9555C01DA;
        Thu,  2 Dec 2021 10:36:35 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Thu, 02 Dec 2021 10:36:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm2; bh=+
        jquG2CaAB5mb0fv44sKsuFPt2m6rHUoO+diia3XdhM=; b=nkxeWk+g3icujeaDz
        uUDHdGx0reC4F+zjbZNF565vWX+2H5tHuNSPMjkzqY+kqBlIz6AY92QxvU0vKP3f
        6eFIca4Td6hOab7UxPvC6bwKONYFN00RYFzcGBPetAfk3gADv32FdVwCT9wbejpU
        Pk8s7xIrqNKJgc0SHa2uPar61OK/kc9bMQizyu9i/MBxJ2qU2ButHI/jjOlCt8V/
        xM4Qef03gP/QOfsxcNtNIsNbWhmKSdKIllv9GPNOay8/ZjGRv4kr+Js50UNgq8VY
        shXSHVMKm+K3G03ODqlM+bpWd3UTj8P3ZRA+XNq4hQ031e7sOfA6ntEIpr/eryEe
        dRkJQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=+jquG2CaAB5mb0fv44sKsuFPt2m6rHUoO+diia3Xd
        hM=; b=QsktPyRWTuFafMkijX2rS6F3cmvp2qLhZGa80R9bN3LCkq36VtJW+s/OJ
        T/N/dwnyKGVlRDO5LbtsAYiaKiZGUAHD7ETeZxh/WSAegscTnLlgannbdjcR+ICQ
        8gn8z+tSk8FEXv4SOCqZXBFFuvXUNCv7Kvp2Njyviw8Kj14loC6hIMWSyyQk2FF1
        fgucMz+5tBoLN70QzbslA/0iQJXcu0YUmfh8E0vwRdgk2azuOLEkvowezKqAsS16
        Org3yK+/DEFOEeBcvU5UkbEmjGEINI1o417yfFP10Y5nyXmuMZyNT9Db80Z/4cbO
        M7H65WJWmCflvswrwvbeDsSOsd6SQ==
X-ME-Sender: <xms:AuioYUm8a47zmfAf2CGDzVkfoeSamr5JxyL7UztKEKgpRcmIEorfTw>
    <xme:AuioYT3dSpgqPTBviQSxNtfsjklw72SIbo_p90LkpNs_YramoiLDK_Y8sp5quz9rv
    kAxqVVdUdutsw>
X-ME-Received: <xmr:AuioYSpZQexxpJG-D9g2u7pDW8HS_CMGtc0P6rgnGPDKBGfTJJIDTMckoohQxQV4F3o0tOGJmOOQ8nSRJQ1VRAXznpx__PWN>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrieehgdejkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepfffhvffukfhfgggtugfgjgesthekre
    dttddtjeenucfhrhhomhepifhrvghgucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheq
    necuggftrfgrthhtvghrnhepfeelieeigeeffeejtdeuheffudefudetheejvddtieeile
    fggfegteelfedtkeeinecuffhomhgrihhnpehgihhthhhusgdrtghomhdpohiilhgrsghs
    rdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:AuioYQkfijHT6-3iIfI3Xy9liPEXA4KmbDXFDkWV9oOmp29NK_EdzQ>
    <xmx:AuioYS0RQdbUKTWU7aJ6Ok6cDvQt3Qrlk_HwsLPQvrYYeficeBFFOQ>
    <xmx:AuioYXtahQvXXx7kkz2OBR_m9zu73IPzmjrXNSBswdqf72LZMLxJNg>
    <xmx:A-ioYVSgJtqd8dxBShXeggZOyLg4Oi1AhYctsrn9PbfxYy3Gpr235A>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 2 Dec 2021 10:36:33 -0500 (EST)
Date:   Thu, 2 Dec 2021 16:36:31 +0100
From:   Greg KH <greg@kroah.com>
To:     Christian Lamparter <chunkeey@gmail.com>
Cc:     stable@vger.kernel.org,
        =?utf-8?B?54Wn5bGx5ZGo5LiA6YOO?= <teruyama@springboard-inc.jp>
Subject: Re: arm64: dts: mcbin: support 2W SFP modules
Message-ID: <Yajn/4ut63xi3qE5@kroah.com>
References: <611c8692-d5bf-244b-4f75-b90b33466b49@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <611c8692-d5bf-244b-4f75-b90b33466b49@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 01, 2021 at 10:59:55PM +0100, Christian Lamparter wrote:
> commit 05abc6a5dec2a8c123a50235ecd1ad8d75ffa7b4 upstream
> 
> please consider adding the patch to the 5.4's stable release.
> (Tested it with patch, where it applies cleanly.)
> 
> Reason: The commit message of the patch states that it is:
> "Allow the SFP cages to be used with 2W SFP modules."
> 
> This was Reported by: 照山周一郎 <teruyama@springboard-inc.jp> in his
> openwrt github PR [0].
> 
> Based on the reporters' e-mails in a related thread on the OpenWrt
> mailinglist [1]. This aforementioned patch is required to get the popular
> (in Japan) SFP module "NTT OCU" working.
> 
> Thanks,
> Christian Lamparter
> 
> [0] <https://github.com/openwrt/openwrt/pull/4803>
> [1] <https://patchwork.ozlabs.org/project/openwrt/patch/1638108130-24432-1-git-send-email-teruyama@springboard-inc.jp/>

Now queued up, thanks.

greg k-h
