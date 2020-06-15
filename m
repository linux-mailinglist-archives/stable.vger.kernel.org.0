Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FFDF1F987C
	for <lists+stable@lfdr.de>; Mon, 15 Jun 2020 15:28:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730313AbgFON2B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 09:28:01 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:35821 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730417AbgFON17 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Jun 2020 09:27:59 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 073B0638;
        Mon, 15 Jun 2020 09:27:58 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 15 Jun 2020 09:27:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=DKyp3bFsT/wAPyu3/m37Y/nhGw3
        zD9EptQY56CoWJTE=; b=rG0XjvrC1fzNFrjF2IhL/m09oPKa7ogCInrNWNOTxsb
        dPDZpirSoqaXCvqUnO5bDKu0drnmYuWmr12sOunEd/K2GCloqPYQlI7GdfM+O2VH
        YbxnC7QS8pKC3fQyl1zOMpmCeVKa4KlPab3D3DL4VzAOsOptDi09JWlhjhXm3tCT
        WyQBCHJxGx/XuiJh6c4N3trrVtSk3sbYDdTNxauHUKMfKV1xnOtWt/D7HCoQ5CU1
        QVYZHr+MZodWwAuSpWtUOPo7++Cx+Ej7Cl6/1cqHU2UEPfxxeo9QusqWydPQPKr7
        2CJ9EnKQCiImvlyGW//4lmSFk+KytfVqGh/U+/cM4hQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=DKyp3b
        FsT/wAPyu3/m37Y/nhGw3zD9EptQY56CoWJTE=; b=NfqNF0yO0vYDcKoOq6qXuP
        beuy5fHmjeotjtV1sMrp5+G22J9Pg+hSukg1LB2UurqjbFlcFAY6byO0VAgl8rgB
        plfkGejd8EB2+01GCYDFQgATwkV3mx2yWSsWCua7nuRPaFqVuxju0oKeqt4vYIQW
        1hRKmIqkd5Nm3UJ0dt1Q8Fwq9LskAztXfNAU/Rrlrg5Uhc7ivDJYgYVOnAq4hryq
        Cm9k5Mwq2/Hhr0Mm1ahjLg8ISD5mZBODuwkG2OtdOn87FqHNSW4qniTeYph8vokK
        fhc3Ep4kObVJaCtvHzy4kZgYCIkmmNMTPjcWv9yAbTP2YtFb5I6FdPaelFPuCYKg
        ==
X-ME-Sender: <xms:XnfnXjLYoR4CZB8TPqheSe0cqAI-W2nUztIQXLTJYb4khslyfxXutQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudeikedgieehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:XnfnXnIVNGUb0mitHkJJFfNgk-Jwhb3KpvvROE6zIuv4WHyWWfhjRQ>
    <xmx:XnfnXrvl6XpgkTJzpH4PN6S4rCwJfUjvEeWCXXF2SBwR2hkim0TqxQ>
    <xmx:XnfnXsY-RLFvXh4MBMu8peFeTzGrtAGqqHoH-DeFtnCvykLqWaaIiA>
    <xmx:XnfnXjDfKZ_Q4uHaTB_wMrLN4E0VBEawHiKgbsWp9x-plC2ca4nmdg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id BC65C3280066;
        Mon, 15 Jun 2020 09:27:57 -0400 (EDT)
Date:   Mon, 15 Jun 2020 15:27:44 +0200
From:   Greg KH <greg@kroah.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     stable@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Fwd: [merged]
 usercopy-mark-dma-kmalloc-caches-as-usercopy-caches.patch removed from -mm
 tree
Message-ID: <20200615132744.GA1108815@kroah.com>
References: <20200602213744.63kb6HfFG%akpm@linux-foundation.org>
 <b589f80b-98ac-8323-fa0d-f91b681b5f09@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b589f80b-98ac-8323-fa0d-f91b681b5f09@de.ibm.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 15, 2020 at 03:24:12PM +0200, Christian Borntraeger wrote:
> stable team,
> please consider 
> 
> commit 49f2d2419d60a103752e5fbaf158cf8d07c0d884
>     usercopy: mark dma-kmalloc caches as usercopy caches
> for stable.

Now queued up.

thanks,

greg k-h
