Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87D9E19CB04
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 22:23:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389520AbgDBUXb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 16:23:31 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:59329 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389514AbgDBUXb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 16:23:31 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id C3CBB5C00FC;
        Thu,  2 Apr 2020 16:23:29 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Thu, 02 Apr 2020 16:23:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=aAUO/VtvNFV05bmr5qzGrJTFA+n
        cCVd9ns0rWfwVtu8=; b=E5wi7/xfhyc4XPAdugz3DxA21Z5s0Eq2TM7X6vaOpt6
        vBd+Ty+eXw2eT/fGVGyr0OfueIeoFqagbBvNIQ2vOsxuvNUEtSm15xfQQ82P6jW7
        0Aai/ccdpkOkm9EMy1cWlscFeCI4pXmKpmJwwWCySpBQg2RM5KxQGjM7m3oidhY1
        SKBrSeYMU8Xtwy9vGsg5vLOp+pyqRcpL1fdgoHsXYjy7Z3OK8SJcqS2AYQzX/eNT
        EWZeN8+1/mmf8sSMYhALrRsim1G9AMWtNBteTQ2uXdnYHxat/EWJpeT/kO04ZIoN
        BA6hxjRdPhrvdf2zIfKKHobV5R3Y+tq5fUgzB1Au7Pg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=aAUO/V
        tvNFV05bmr5qzGrJTFA+ncCVd9ns0rWfwVtu8=; b=QCLGmrDgqHGUTTTHUsBDMZ
        oubuRbXomkBT4MLiz8NsloHDiE9VCAbSS1iqwcnPL0ABFk7XHAS/9Bf8hCOIt3ke
        Bv5SsFY7MBs81siz4dsKlCmwbJ/bQpJH19DYsQtAEC1z7/LidRVCBoh3QDD+S2RW
        x+W+jkb1rINiNS3n2Aj3R+/Swf0FrX5lej/bZf1cg03x9o2+ZyiwXg8CngNltmHN
        pO2SC6mSw6Gr0UQt1iShxw9VYwdTQfg1ldFjrbC7QKvRXsFyLi2fMOtM8weDLIFD
        dxLxqgocKMC2DJ6ZiEt2Bjdgu8fE35DE83qaBcpVPKXifLuPoYyErVee7jHNjMKg
        ==
X-ME-Sender: <xms:wUmGXttEZKSd2WnqVUM3xjSmBTqbJS_Iq_YiFydC_X3z7RG4nFK0Zw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrtdeggddufeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucfkphepkeefrdekiedrkeelrddutd
    ejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhr
    vghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:wUmGXllO_UDvIYTqFZDk7j1WglpnwLeP6Qel2L5FVq5_LsmXFrlgEA>
    <xmx:wUmGXlxkyKJvPCZlnjCEWaYZK24fXiRMdCtgnjcJcSc_B5RkW7H75g>
    <xmx:wUmGXjx2UUAfdPyEqF5K0wghzbvfCsmtA4lefLdOxvOg_29hN2xlmQ>
    <xmx:wUmGXgZcpTGL9UVvhHY27xXXlyr9SS31RgdCMnERmTAfve9QXH3Khg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3D746306CEA1;
        Thu,  2 Apr 2020 16:23:29 -0400 (EDT)
Date:   Thu, 2 Apr 2020 22:23:11 +0200
From:   Greg KH <greg@kroah.com>
To:     David Miller <davem@davemloft.net>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCHES] Networking
Message-ID: <20200402202311.GA3258915@kroah.com>
References: <20200402.131633.668893605649137999.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200402.131633.668893605649137999.davem@davemloft.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 02, 2020 at 01:16:33PM -0700, David Miller wrote:
> 
> Please queue up the following networking bug fixes for v5.5 and v5.6
> -stable, respectively.

All now queued up, thanks!

greg k-h
