Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F324E70931
	for <lists+stable@lfdr.de>; Mon, 22 Jul 2019 21:01:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728588AbfGVTBd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jul 2019 15:01:33 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:41949 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727646AbfGVTBd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Jul 2019 15:01:33 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 31A3E53A;
        Mon, 22 Jul 2019 15:01:32 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 22 Jul 2019 15:01:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=JX8+vBzMq3RJ12fnh2l/UftFHDK
        eahAWrm4nMVdfa+w=; b=N+eBSIAT1iruHffi5I4UNtqwN7M9u7ujrbJ6rCEL7IG
        F79CZTs4/KDAVinwlUHwehrOX7djXXpyyyLa/JJuWQk0+SEoUy4u2sLG6ZuedCDY
        gjAm8yQ7GrRmhRLrunzfoKtW77RpJXl1wGN847+weqfcXdy7woCj8WHTJxYQ4wV4
        ma65zLRVQSQoEu/0ZdduajXNvphwbMiGQVEDcZTSoA4bOTja2xaGPKyJSOYOVbPl
        PkJtWEjm17rq4+yB5+U/6NECq3TyL7hqDLqi8K/ZTz8QnLsxCe/yd8ExZJM1ufxA
        sgVcEYoFust6uA01RpPh8BOcN+Wpqn8m4YdYMXH1yTA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=JX8+vB
        zMq3RJ12fnh2l/UftFHDKeahAWrm4nMVdfa+w=; b=yt+Gzgdiljs96AGA26mTDn
        ndC1B8dTMOYrCxgrJJsqKXJ61s0eBtWE24mOEwjNIHc5RR+nBpDj4eNQnAV2wdCR
        bIRVwRj7R5rXys4PuDW1GrhtZSpQJD04APfMGwFzuPexRU0XRzdTDY+lWv37cj1F
        XDIg11hSfhD/qDLclAMiz5NAQUhavRy+zqCBzaRTvraIe4mZEWFZFfpeYd9b9UhP
        XFOaQIM2XFUab3WtDp3iC6P7ySOU5mvWZ041fZMXe4MTVF6e6X9DoUwZm4kMQi26
        8htVQDCnO8dGZNr7HdRAW5QDKARhHZT83Ez/s0CLttA3LQxVn2vwT/soVga4uFRQ
        ==
X-ME-Sender: <xms:Cwg2XXTLqRqjIe23l2ipgSlgJgWvqDLOmEzLyFh-GjobShOYQ51QjQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrjeeggddufeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppeekfedrkeeirdekledrud
    dtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecu
    vehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:Cwg2XdDNKq8tNq_GY5U-FaS8d1lGmzlRBBbaDWxZFjBN48Aw8fyhDA>
    <xmx:Cwg2XX1ujefmDe7So3kfVTFCj4_W6bkzsPsCeACO-rg_O5CDlEtatw>
    <xmx:Cwg2XbVit_iiWHlKf2AMaS94esLfnSlUNODbU3mt2jD5pk-u85O8Aw>
    <xmx:Cwg2XcdjqToFr73X5KKg24rRfARFC4a1xhsnaorkUB77xsybojbhGQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id E1F8980059;
        Mon, 22 Jul 2019 15:01:30 -0400 (EDT)
Date:   Mon, 22 Jul 2019 21:01:29 +0200
From:   Greg KH <greg@kroah.com>
To:     Juergen Gross <jgross@suse.com>
Cc:     stable <stable@vger.kernel.org>
Subject: Re: Patch for stable kernel
Message-ID: <20190722190129.GA28511@kroah.com>
References: <56dfd6e8-06f7-bdcb-f88d-e7fc102127e0@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <56dfd6e8-06f7-bdcb-f88d-e7fc102127e0@suse.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 22, 2019 at 08:41:19PM +0200, Juergen Gross wrote:
> Please apply commit a1078e821b605813 ("xen: let
> alloc_xenballooned_pages() fail if not enough memory free")
> to the stable kernel tree.
> 
> It is mitigating a security bug related to Xen (XSA-300).

Now queued up, thanks.

greg k-h
