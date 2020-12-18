Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B7EA2DDE3B
	for <lists+stable@lfdr.de>; Fri, 18 Dec 2020 06:54:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732471AbgLRFwy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Dec 2020 00:52:54 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:55419 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732182AbgLRFwy (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Dec 2020 00:52:54 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 539875C00E1;
        Fri, 18 Dec 2020 00:51:47 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 18 Dec 2020 00:51:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=TKB9lMmMJqJL+Z4KiEL937lWMUa
        UGHNxQPNnwVtfDQc=; b=mH4DitV96Y3zeibglkqvv6Q+wAigL0TwMm0A6hE6En0
        dTx7Ii08KolbmuAPS2MnU47J1kwWmqsBn3WW/ha21pN5h8hXlv3cLh4egdSegZ/w
        TivG0YgCulfs34pEOQMgvem6Em7LgUCQO9C0VSaiscClabR/aw4x5hiQ3yOQymjH
        L+JK+DLQHaI8YUAtK8Puzep2nDgbSXiexne4HaOvGUdAtG98HVNA4ku/ZrziAtxL
        fwQPv10Mk3QbrrpwYL1G4Mwi5/LMfqEiuHApmRNCKH81pM3p8dmUpsvXAX6WqIRs
        GfGRJteUYU1FPiAMY3MoVTif7owRYj3rytcGflGX4Lw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=TKB9lM
        mMJqJL+Z4KiEL937lWMUaUGHNxQPNnwVtfDQc=; b=iX21RtOlrDw2NLdSsxrvUa
        knXePZ1ZGduojAR8N/MQ6F/ogcbcqVbRfAxzcz5rDTGol61Po7Rat57u1pjP8XLt
        L6bir2YBiMEYMBT0Qt61ZKT91lybUmgXgDZySPHAPviZyrbiIXQrsUWGVhDmaGXh
        gwCd0snbuDuwYTdOWKY7jt/4MxUZvKfO5icSGZF8f2LhErUYjfuorr5EU8eFkRam
        hte0b1jSiv/Y646Y7pF7OJIKwf3ml9Jrv9momTyaksNor/rPUj/TaeWNW25Ie50W
        +b+9IvtiZv4WHRRa0T+brA/2pmZ7uabjCAOe35f6ll2zzkdumpD3a8wcNyopC2oQ
        ==
X-ME-Sender: <xms:ckPcX6Da1wz2qp7t_npjbFFmjxjVRniemWuboJvaWtN9qap7u8WD9w>
    <xme:ckPcX0jyyfnnrOk_ty3_QpVN02Sfu_Xs-TiqcA_FlTrR2cCiyv1yBYydbBrwMILS_
    YxaE5od8PwaDQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudelhedgkeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mfdqjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepjedvud
    fgtdeuueekvedvhfdvtdeuteelheekteethfelffdvffettdduuefghfeunecuffhomhgr
    ihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrjeegrdeigeenucevlhhush
    htvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgr
    hhdrtghomh
X-ME-Proxy: <xmx:ckPcX9kwaYy0P4OzDnqzf3-uT5ygQXp1Og-_m9QZmI-A5L1aB_XEcw>
    <xmx:ckPcX4wunMWR2AhJ07ITZcU60OyexMTrUXkjExb-ZaFTtGOresui4A>
    <xmx:ckPcX_RdpQKNyqxXbhoRcT11gyytxYU8OFHV_9RLBEtL0kF0REWRow>
    <xmx:c0PcX2L_nUPbzNCBt3viCEnV3lpUIpM5CSUdLELYxDFaMTyybQKtHA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9FB86108005F;
        Fri, 18 Dec 2020 00:51:46 -0500 (EST)
Date:   Fri, 18 Dec 2020 06:51:44 +0100
From:   Greg K-H <greg@kroah.com>
To:     Young Hsieh <youngh@uber.com>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: Re: Question for AMD patches
Message-ID: <X9xDcN6F6yI4fWoZ@kroah.com>
References: <1B44E762-F9F2-4E2B-BFEF-6F032BE8841E@uber.com>
 <83E7490A-EFB0-42C2-BD9D-B5E6E5BF440D@uber.com>
 <B23EF613-CE1A-482E-8AAE-7AB6FBA8B1D8@kroah.com>
 <380D416C-D23B-4F35-A944-EC3E3A8349C3@uber.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <380D416C-D23B-4F35-A944-EC3E3A8349C3@uber.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 18, 2020 at 05:18:16AM +0800, Young Hsieh wrote:
> Hi Greg,
> 
> Thanks.  I am looking for the Essential, RAS & Perf patches for AMD Milan as follows:
> 

I don't see anything here :(


> I am not familiar the rules for stable kernel patches, can you help to elaborate ?  Thanks for your assistance! :) 

Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

for what stable kernels are all about.

thanks,

greg k-h
