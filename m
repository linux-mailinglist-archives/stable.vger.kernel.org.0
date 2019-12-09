Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4A6811714E
	for <lists+stable@lfdr.de>; Mon,  9 Dec 2019 17:15:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbfLIQPj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Dec 2019 11:15:39 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:56843 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726080AbfLIQPj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Dec 2019 11:15:39 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 77D5CB82;
        Mon,  9 Dec 2019 11:15:38 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 09 Dec 2019 11:15:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=v1zrmVcnZ4WpIY5x4d5EzxBO5Cs
        vFdPWQBWdDjMCm8s=; b=J3GLCy9HhoVPOOau53BkJYq1v13QdtrvwhQad6/1iMj
        YbaULP1jA+PyvvOUaeuATO4fbRMoEVw+ujVbd8LDUM0ppyY30qo5+YLN5RnZ9Lwn
        DKdgUHLCA6Maq49aWEImlDET1SQd6dUtk/QwezFOcIvOPTiB8UuJ295dR8A5MjKE
        wFDJUvpc3YeIoszyMBoJBkL0uVpDbycDljKC4+IkY/7KrrATSKYpPJta6a+tifSQ
        0fkLjDmOBpLkR0SPZTDSYDYxEb5mQyflD6f6kqKxJ0ypr2dFsj/JBNvimU/jBsHh
        wH+ledZd2Aru/Rp42Gn/d7H+FEgpth1DHBmfTfX8MeQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=v1zrmV
        cnZ4WpIY5x4d5EzxBO5CsvFdPWQBWdDjMCm8s=; b=fEC6NZfM5a6TfIxXHHnbqy
        HXzhwYlb7bLtkKwV2QDGtU8xICefScG8xUNVe/7dIT+cCQdwVK/0h7pmKAytuNhx
        CsLUkg1ofvmN9muyqvCX5bPEKY1KxFgtj0iYkrxKjoZlxAmllMwCL1PWTfxA08mt
        yYGe4WxkkkmnHoyDeP+vpFr7JBvaCOnPTAjxYTGeCvszLQi1SIWZizfPbUeYFnH8
        nw+baUzljr4FL5BJIdSDeOImoYBWWykYhY9oB6Y1IWVvb7sfY+5Tz74aCDboayA+
        +NmJ/SIADjGnPYKEXeZCnG4Fsg/ubWkCT7/TwRFT4jbyt/aMDFuhzRtwz2/Kbz+g
        ==
X-ME-Sender: <xms:KXPuXQL8FyFPPrh-kAGS6HXRAZFV9xmn2P-oSbBhoSPyJvSG8gGABw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudeltddgkeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvuffkfhggtggujgesthdtre
    dttddtvdenucfhrhhomhepifhrvghgucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheq
    necukfhppeekledrvddthedrudefvddrvdefnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:KXPuXW80tBUMZHHxuH_mVQar0bcdTPwEBDJ_UXAXExQFLUcX7AvQpw>
    <xmx:KXPuXU-AlXI6qMCljqzb2tzvl00L6bw7i-3wNJ7etRK_UuVPnn5ymQ>
    <xmx:KXPuXWIfr-yQLbLew7cYZj0QD_fWp-_PNmDJBdGo722sFaoTYDFKiw>
    <xmx:KnPuXcKxGOQG7PNFIou_L4T-V8usYWUZsZU0bEZfAs2_yXDapHKAOg>
Received: from localhost (unknown [89.205.132.23])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7CF4C30600FE;
        Mon,  9 Dec 2019 11:15:37 -0500 (EST)
Date:   Mon, 9 Dec 2019 17:15:36 +0100
From:   Greg KH <greg@kroah.com>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable@vger.kernel.org
Subject: Re: stable release candidate build/test status
Message-ID: <20191209161536.GA1286960@kroah.com>
References: <20191209155342.GA30203@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191209155342.GA30203@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 09, 2019 at 07:53:42AM -0800, Guenter Roeck wrote:
> Hi,
> 
> stable release candidates are a mess right now. Example build/boot
> test results from 4.4.y.queue:
> 
> Build results:
> 	total: 170 pass: 163 fail: 7
> Failed builds:
> 	arm:allmodconfig
> 	arm:u8500_defconfig
> 	arm:axm55xx_defconfig
> 	arm:mxs_defconfig
> 	arm:nhk8815_defconfig
> 	arm64:defconfig
> 	arm64:allmodconfig
> Qemu test results:
> 	total: 325 pass: 261 fail: 64
> Failed tests:
> 	<too many to list>
> 
> Most other branches are just as bad, and it isn't always just arm/arm64.
> Is there a need to report details, or will it all be taken care of before
> the next set of RCs ?

I cleaned up a bunch of problems this weekend for x86, so I'm glad to
see that working now :)

Sasha, can you fix up the rest of these?

thanks,

greg k-h
