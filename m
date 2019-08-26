Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40A639D0A7
	for <lists+stable@lfdr.de>; Mon, 26 Aug 2019 15:32:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728053AbfHZNcn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Aug 2019 09:32:43 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:44951 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726953AbfHZNcn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Aug 2019 09:32:43 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 518662E3;
        Mon, 26 Aug 2019 09:32:40 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 26 Aug 2019 09:32:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm1; bh=M
        GpiO2KOfZCweH4wrUNpPwtsOVKEQJA/HAB10riWwJg=; b=gGhK0IXeTndUXnZ90
        AJXyJ1SNIK48x81WLTbJs8DKrzylD6ivHB+gUYqCtKPmZEAtMeHDkfpLZz2AKdKT
        ZRuhnY1u7gmmaneUnWBDmMT6y+GAByIUH6sTBi2jq5MCja+QMqWMBSGOsH5Lb1AJ
        Suqh2XPvQO3Wr89fq0a3Ye5H9snUI6uJMXyiYVtkc7El0ZVsGd9+ag3JZt/OQZgR
        ff7zxY4gizsfmsULPEkxRbXHJO7lx0buWkUGg0P2nAwK+lM3ghImNsg6+KIRyd/k
        qhTCs3VewpJHy0T6S8S7g0VUM5eGx6/Zx8v6CxyEey1IKxpjzKPZGYukTdhshMnv
        cS5/A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=MGpiO2KOfZCweH4wrUNpPwtsOVKEQJA/HAB10riWw
        Jg=; b=MFD53O2/kgwyfdapmadU4yJ10kShhzuTm3dS8EiYAaxw28Kvq+sCRI69f
        32G2EpXuoT+ugzT4pm1h3MIabiqqICJeCpOYs3i/eSbSusiauztYt3LPWjAtUWdP
        XN3yTi7SeopqQAb5GoBGPfAveylkfcLRCrsJtxtUO5hlCONSslSqhMBJgjvtKH6V
        2bVkBPrG0KLeZWVoS6WllIeLl9bVvYFma4a3TT5S11q54a0oIleZeDAQwXfGEOrn
        mJ1uRMe735ikVpCmQPAlfGOmG17IJzH4/zcT4hJ2/IpJDjjQV1bAUT652OSsKvrl
        ofCXVA/e5yjjQ1ladqHHtxylHVxPA==
X-ME-Sender: <xms:d99jXXpxwTl37Bljzott4ezSRnlQU78d0yHlXlyQuDA0GEEkJAo8EA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudehgedgieeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtugfgjggfsehtkeertddtredunecuhfhrohhmpefirhgv
    ghcumffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucfkphepkeelrddvtdehrdduvd
    ekrddvgeeinecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtgho
    mhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:d99jXV7i7Wx0HTzlS8M-7MJkjLOGyYWF_O4O54b-Nz8dpvvspOLiBw>
    <xmx:d99jXfPC_A6TEsgs8Nqn2q6PcHxixZdXbvbp7yC1wEbceUZ3LAX0JA>
    <xmx:d99jXfNcyPmjM1p23Cjqh08Nra506fTRQnjzdICcebszy6zPjjXPAA>
    <xmx:d99jXcvQPF1vVJClj5JlLjRyPspd9M7XoPvy8npsmYc3_8G2nKj6bg>
Received: from localhost (unknown [89.205.128.246])
        by mail.messagingengine.com (Postfix) with ESMTPA id D7AC7D60062;
        Mon, 26 Aug 2019 09:32:38 -0400 (EDT)
Date:   Mon, 26 Aug 2019 15:32:30 +0200
From:   Greg KH <greg@kroah.com>
To:     Jean Delvare <jdelvare@suse.de>
Cc:     stable <stable@vger.kernel.org>,
        Johannes Berg <johannes.berg@intel.com>
Subject: Re: iwlwifi: mvm: disable TX-AMSDU on older NICs
Message-ID: <20190826133230.GD12281@kroah.com>
References: <1566813164.5278.3.camel@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1566813164.5278.3.camel@suse.de>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 26, 2019 at 11:52:44AM +0200, Jean Delvare wrote:
> Please consider picking:
> 
> commit cfb21b11b891b08b79be07be57c40a85bb926668
> Author: Johannes Berg
> Date:   Wed Jun 12 11:09:58 2019 +0200
> 
>     iwlwifi: mvm: disable TX-AMSDU on older NICs
> 
> for stable kernel 5.2. It was not tagged but it matches all the
> criteria. It fixes commit 438af9698b0f1 which went into kernel 5.1.

It is already in the 5.2-stable queue, went in earlier today :)

thanks,

greg k-h
