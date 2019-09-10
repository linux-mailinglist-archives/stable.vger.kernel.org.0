Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59DF0AE69C
	for <lists+stable@lfdr.de>; Tue, 10 Sep 2019 11:19:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729439AbfIJJTn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Sep 2019 05:19:43 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:35095 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729349AbfIJJTn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Sep 2019 05:19:43 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 26B686AB;
        Tue, 10 Sep 2019 05:19:42 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 10 Sep 2019 05:19:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=FuIKM8ji5B1GYyi/ac3f7h+lnXh
        WE4Zc17vPAo4OuDE=; b=S7XaQk1Aasr0fDsjjCRfDjCxHvKWyaz59W8fXxPe4Z0
        7AbWAVFg/s4pmP+V/IYEoE0q3NHcPItLzB8JAJ8HCILSxDSrt9ztUmc9vL0Kl5fY
        qL6tiqHoE7uAoc7RfT/mDkjrs1/k386sF1nxZId6LuQY3DiEe8aKQfTLHnRsdYSh
        d9xsJ0g2YDWDDZuh26ug1Ux46Wa4rMOvjcCeI1gWeQZM87XG2VRBNR3vrFHC8uCZ
        F1vy5PlKR2lToqSGW+zSgz4UXq7tA8uhGDcqNq4gu3ZswhUgxFUk6rF+lkzBIJLF
        eJqwdDWSeenuIEZJpWdfWx9d2ndB/z3vZ1bMTwzNapA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=FuIKM8
        ji5B1GYyi/ac3f7h+lnXhWE4Zc17vPAo4OuDE=; b=nQ44Lh8B8VV3oF+7DQAict
        C2weNhFVMnVhwdjoZwH19O4PJnL7UyYVoo5KDFfoSAGmkTom/T+z1xcOy6YPAvxG
        2KviBJv3sQJYtQglrHjBdvTBcy/HvEEXSFRM4m3PXmedSZARI1rceGo+VPknyXWQ
        OFxragE2YJejUDewlJIEob0yEOePdZXG7onR5TFYqseguBevxNFhs+FDaSZh6Ctf
        +PNZm1aaRyyEUhFNzGVejGaf4GR7WgARHETr+AAWqQnL+nNE0lJGzGtBLwimG3BT
        7jrY4kDmmrxISSM4pyfwMfkhYxxdCsBFedkJ/JYrdoNMTRrMu9OJx0mCuJ7LeJjw
        ==
X-ME-Sender: <xms:rWp3XR2Sncnr9Z2A3oEXAi1JrDr3_1D3VsMhVpu81S_3Z3fdKNi6og>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudekkedguddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppedvudefrdeftddrkedrud
    dutdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecu
    vehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:rWp3XTLrDag1PYAjBtXuppdchF_KcmVRDlrwdXZss7IgG3w2cr3HfQ>
    <xmx:rWp3XZ-f2BbcX2J3DlVlIcpisu8j0th-o0lE82WG_RaPehyGBML0pQ>
    <xmx:rWp3XREKoQ54y3aazGM_idIIaJkUdi-Cr7sPe7Z_AX6GMJeGASbg9w>
    <xmx:rWp3XVk6zz9k07uO4bNh8vNt5xHkOTLltHoGjSvus0yOxBOHWvn2Aw>
Received: from localhost (110.8.30.213.rev.vodafone.pt [213.30.8.110])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8160B80059;
        Tue, 10 Sep 2019 05:19:40 -0400 (EDT)
Date:   Tue, 10 Sep 2019 10:19:38 +0100
From:   Greg KH <greg@kroah.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH AUTOSEL 5.2 06/12] configfs_register_group() shouldn't be
 (and isn't) called in rmdirable parts
Message-ID: <20190910091938.GA5542@kroah.com>
References: <20190909154052.30941-1-sashal@kernel.org>
 <20190909154052.30941-6-sashal@kernel.org>
 <20190910060135.GA30753@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190910060135.GA30753@lst.de>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 10, 2019 at 08:01:35AM +0200, Christoph Hellwig wrote:
> Please stop selectively backporting parts of random series.  We'll
> need to the full series from Al in -stable instead.

Yeah, I'll pick this whole series up soon.  Sasha, can you drop this
from your queues please?

thanks,

greg k-h
