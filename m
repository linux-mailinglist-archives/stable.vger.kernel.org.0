Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C781B7EE91
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 10:16:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390775AbfHBIQC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 04:16:02 -0400
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:60701 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390761AbfHBIQC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Aug 2019 04:16:02 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 8F0473D7;
        Fri,  2 Aug 2019 04:16:01 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Fri, 02 Aug 2019 04:16:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=uEocR7cf+uvpM7xnT7yGCqIJVCe
        VFmNwygWN+t39F6M=; b=KY/Yqr6uoa6gwxMjj7KYxJ2OLsCbhVhmX+ApYAnKx/3
        nb8hPdipS2RBlavS37ExIOAmpiM4DaHshhZs0Vhnra318g+MTPDMH+5iy7RMgxpL
        1hgZcXzCiTF4d2NFGD+9k/Kzg+y2MG/j5I9Gw4HR+cKqoPtH/eNGfido8PRffeUe
        PdXE138mKIvDUYqopdXxTBfbbS0um9X7v5llvdeh1r1jmAeQapLw/2skQImXdjGv
        H0USsQZKbpq6nawCHIlXCfCUTOMljLPRUNhx9WyvxnX6EPp8iyaaehkVjUGJcWuL
        bEzD/BrfOrTS4CFyMpWO1z41GwKveO6lPSph2sv+Gpg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=uEocR7
        cf+uvpM7xnT7yGCqIJVCeVFmNwygWN+t39F6M=; b=Ef8zfcD4NMsKTsSGHJ/Ujl
        32Unb1sUPOOSRguaoBlmpVOUqTLWWZnIXQRHY/jdZL+3RFPCKm1qCcgXdKoGJEdL
        SNs5w4CU5YBO9sTgm6A3pyWGxzyomLYoFdrih88Pp3ZMzgiQga+EnDrJGmCbWjaU
        rSWUl1NZexLZ4zqjFTqPLX3jItShAahOqzwr+YaIWkHHr4zDGttse/aFHfxFAmDQ
        3I/kBNDrERt82cAhFzUbX8F7wAvC6XB57JxJDJGMYQPet6sQl5tH4ANY8L3ASOYI
        Ckq7eFaJh0v60v6CcTKQOJO8BpXJceNYM55WIz+H0QLE5M63halAjP2QU/p+iS2w
        ==
X-ME-Sender: <xms:QPFDXdpwEYs8kbziCc8yNshgd-f9wTP3XF_Th45DK9HBTXeanujOuA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrleekgddufedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuffhomhgrihhnpehkvghrnhgvlh
    drohhrghenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhr
    ohhmpehgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:QPFDXdSjaER4fQUQr80utXuFOf1xd1FAqs51RUVLLVhTNP8HWK3oSw>
    <xmx:QPFDXRnLZtImoSfVnW4HKjJ7bXiNINbjMkQOOASW9KmWh7Yt-jp39w>
    <xmx:QPFDXRG8cKtnBwx417Meh_dkPbA7bWKCixlqEuRNnO3XurramEY9FA>
    <xmx:QfFDXdty7WTL6fv2tpxvL8aa7v5l6gO80tS3bzCPbSHtJWbw8MhjEg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 83BBF80061;
        Fri,  2 Aug 2019 04:16:00 -0400 (EDT)
Date:   Fri, 2 Aug 2019 10:15:59 +0200
From:   Greg KH <greg@kroah.com>
To:     Evalds Iodzevics <evalds.iodzevics@gmail.com>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: missing patch
Message-ID: <20190802081559.GL26174@kroah.com>
References: <CADqhmmcCA_UjV899cHn8SOTSp89BvjMgnd5TcijCWqp6KnhdJw@mail.gmail.com>
 <20190401160629.GA20725@kroah.com>
 <20190401165853.GA1929@kroah.com>
 <CADqhmmeCYNpYpCCG6Y0t+0gxacK-834Bshc+bLmav7ei+Xzx9g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADqhmmeCYNpYpCCG6Y0t+0gxacK-834Bshc+bLmav7ei+Xzx9g@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, May 26, 2019 at 10:32:29AM +0300, Evalds Iodzevics wrote:
> Hi, sorry for super long delay i was a little bit busy but i finally
> got time to work this out in full.
> This applies to 4.4 and 4.9.
> 
> Intel requires CPUID eax=1 for microcode operations, microcode
> routines use sync_core() for this.
> Back in December of 2016 Andy Lutomirski submitted few patches
> https://lore.kernel.org/lkml/cover.1481307769.git.luto@kernel.org/
> 
> Second patch does not apply to 4.4 and 4.9 as it is revert
> 
> Unfortunately only the first one got backported to 4.4 and 4.9 and
> broke microcode early loading on 32 bit platforms because it always
> jumps past cpuid in sync_core() as data structure boot_cpu_data are
> not populated so early in code.
> 
> Thanks to Your recent backport of 4167709bbf826512a52ebd6aafda2be104adaec9
> the only place that uses sync_core() is
> arch/x86/include/microcode_intel.h it should use native_cpuid_eax(1)
> as in original Boris submitt.
> To make this work we should apply
> 5dedade6dfa243c130b85d1e4daba6f027805033 witch defines
> native_cpuid_eax and others.
> 
> As for c198b121b1a1d7a7171770c634cd49191bac4477 i think it is a good
> idea to include this as sync_core in present state behaves differently
> depending on call time, those compiler warnings can be ignored, on
> older compiler they are not generated and this compiles fine. I tested
> it on GCC 5.5

Can you submit the proper patches backported as a series so that I can
queue them up correctly?

thanks,

greg k-h
