Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F9BD12BD6F
	for <lists+stable@lfdr.de>; Sat, 28 Dec 2019 12:24:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726187AbfL1LYA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 28 Dec 2019 06:24:00 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:50747 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726045AbfL1LYA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 28 Dec 2019 06:24:00 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 28AFA21AD2;
        Sat, 28 Dec 2019 06:23:59 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sat, 28 Dec 2019 06:23:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=6IFecCJV59RPKiZOLptHXUnkpV+
        VnH5xdrJP+Bu0zVI=; b=BB+8/qZs+U4NEFItHSdA7Q+2TgwoFCMLmvruPP8gp7J
        zrRBNnFgg8614L1UApDlqd3+OBaskFPm2dNTJfXhWdsipct4uQdyyw9/+enQquoS
        ax55vkxt2TbA9HXSpYtba160X/3LcalPhuISBvQ5FmEZYQ9S7NnQd0LQg4BOkJQN
        TNpPvQUzbRY4pIQytQvUsKp0xBubwIQm6DDW3ZYOtlvbkI5/I6ZiS7ET2BY8XjTh
        p3MfHPnulNbp1YaD8GHBEXJzTdTTeC3+AMnCYF85J6DAl/+Tja6994YnPTdoQVxH
        H1U50/J979cFPamtQSYKIzYfH1wjTZ2OSlmfOzgCozA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=6IFecC
        JV59RPKiZOLptHXUnkpV+VnH5xdrJP+Bu0zVI=; b=Hbut7kJCZOWTOh4/pDX1uS
        q0zTsYpUHp1TjqLWqzVz+Yyc27F/nxj5qomhf3VUxA6JEq0k0PlURx3UlfKpIR+c
        Vuw3RpVSud/zsCifhEUW7B8aHnj91b/eeLaZ95pqBBsNS061EzuAkpAwWJROXkp9
        k9LBdfGoW1NMvDYbT5RGUpHnH/QyirjiuuhJcl8V+lWAyq6LZCf4HHT5iCLIo9Av
        BYueFYO2xhFK+Vt06v+ANdYQdKIV8vU8JfN8WW7NX4RUqsn4nslrTZOSG2XXbTB8
        9wgf0LDyMUPOcklEPzN5oohqZbsYtzVpHIZ7genM9KUKyrXoLaIg9RySYGr3+N4A
        ==
X-ME-Sender: <xms:TjsHXu2mdLFAVNOujTdlqVeLKYd4K2xBfOcj9S_wP6Eitvpox7SiXg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvdeftddgvdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucfkphepudejfedrvdegiedrvddtvd
    drudejheenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
    necuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:TjsHXkIMZcxKWR7Ijojw9l4ZVQTfVFIQWPS1_kvCW15tx8zYFK6jSA>
    <xmx:TjsHXk-o_UsbxuAu_JKxnTQ3esu91kbKwQpPbNa589uwVj9IAjoy3w>
    <xmx:TjsHXjTkU5FTBSPkrjCBSzeR5H4bk0NuUHD4vsaiXJgkSDvIVvJUzA>
    <xmx:TzsHXr0Nn157Nswi_jPaWtRuayO3Q2POmrmS8E5cVN8g1jl9MRnpHg>
Received: from localhost (unknown [173.246.202.175])
        by mail.messagingengine.com (Postfix) with ESMTPA id 90EC68005A;
        Sat, 28 Dec 2019 06:23:58 -0500 (EST)
Date:   Sat, 28 Dec 2019 06:23:57 -0500
From:   Greg KH <greg@kroah.com>
To:     David Miller <davem@davemloft.net>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCHES] Networking
Message-ID: <20191228112357.GA379084@kroah.com>
References: <20191228.001442.1023398124730683590.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191228.001442.1023398124730683590.davem@davemloft.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Dec 28, 2019 at 12:14:42AM -0800, David Miller wrote:
> 
> Please queue up the following networking bug fixes for v4.19 and
> v5.4 -stable, respectively.

All now queued up, thanks!

greg k-h
