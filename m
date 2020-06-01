Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5D0E1EA7F5
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 18:47:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726149AbgFAQrc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 12:47:32 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:60905 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726125AbgFAQrc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Jun 2020 12:47:32 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id E18705C0089;
        Mon,  1 Jun 2020 12:47:30 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 01 Jun 2020 12:47:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=m0bDCjJMb2mSrUryHZnpstY5uuw
        3/YciXAeS1fk9yTU=; b=dprHmVphVMlRqrkYXrHwWIlSaFdFhZII7dVcZiY/AU2
        G4+luvItOpHM744dnCpR0b9H1QobRA1pRUt5d62HuxjXstQ0nos0hpfgncT5Ya1l
        bs/Pt7RpAyy/k32WvuuDZpPEY7cCOa+3e4gp+Aw0TSp0b5/Y76l1SqsbTOU2mB03
        iUvEAo1RMf0j/rDG1mlFkr86kuBu66rOMseDgJHLgn5ygIGkdTpUTOVdsktLoS6s
        BBbPlpIq0BS+cmiyvjmSTGKEATlrSy/fR1p8vpo8p6Q6fsLZsOg88uwDKwc7QOd3
        b2CERHlcfRE0CLKRSEQ0hTh6kHmPcyCRtHSFHBdpkFQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=m0bDCj
        JMb2mSrUryHZnpstY5uuw3/YciXAeS1fk9yTU=; b=FvORIxVp751hgMaq3aE3Wz
        i7+jVdQl9sc/s5xYVIbivkCg0msOraYnc51kNpKuF19nheYEFDHSyI9JQGb7y96z
        1hMHVo2IW426Q4suAA9XWSJML9uNWLyad/7nl/xE6SrwpboHtDBG1p9adi9LuRTK
        Jw4KG/KEO+fWPkWTyoc+fLAmtgkD9jyI5Of6lvWgekuvZL4RJEswjDKaQrZ0KqYZ
        Z9w0OdZKl4NSMJcMX/U50CbbHLr6cieiHs2ap8UH2Go+SpEzp4I/bvZV8C3rkhK5
        kirLwjIauhENqvc0LEZF4r3DfTR5gZlR4ymskAsMIixx1fJ3j8a/kZxAr737Pbmw
        ==
X-ME-Sender: <xms:IjHVXuVeHxaTVl0e6ODi7c2-l7JyNbo82ZujmECA3nBT_YUl7G_4_Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudefhedgleeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:IjHVXqlBr_ODPkID2sqYroHK-6DE9MSc02VpAEZoDD1z8pbi1Nmd6w>
    <xmx:IjHVXiYjyUPeWI22FhGT-OBRY00Phw9O8IX2o7HT8OH3qEbJOyJjzw>
    <xmx:IjHVXlWHIzLWlxQvm-NhaW8o5xTV2zjxWNlCFOFzFGOzD4CZL2Uvyg>
    <xmx:IjHVXpAJYT5EUuUhiNNJLGvFaQLx13TfwzpISLX1_Td6dlmEMXbWDg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1572D3280066;
        Mon,  1 Jun 2020 12:47:29 -0400 (EDT)
Date:   Mon, 1 Jun 2020 18:47:27 +0200
From:   Greg KH <greg@kroah.com>
To:     Marek Vasut <marex@denx.de>
Cc:     changbin.du@gmail.com, linux-stable <stable@vger.kernel.org>,
        acme@kernel.org, jolsa@redhat.com, linux-kernel@vger.kernel.org,
        mingo@redhat.com, peterz@infradead.org
Subject: Re: [PATCH] perf: Make perf able to build with latest libbfd
Message-ID: <20200601164727.GB1037203@kroah.com>
References: <20200128152938.31413-1-changbin.du@gmail.com>
 <70322330-524c-14ab-aace-e460677e25e3@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <70322330-524c-14ab-aace-e460677e25e3@denx.de>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, May 31, 2020 at 03:50:25AM +0200, Marek Vasut wrote:
> Hi,
> 
> since commit
> 0ada120c883d ("perf: Make perf able to build with latest libbfd")
> is in master, can it be backported to stable as well? I keep hitting
> this with too new binutils on Linux 5.4.y and I have to keep
> cherry-picking this commit to fix it.

Now applied, thanks.

greg k-h
