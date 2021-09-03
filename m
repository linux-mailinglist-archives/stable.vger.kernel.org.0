Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D4EE4000E0
	for <lists+stable@lfdr.de>; Fri,  3 Sep 2021 15:59:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235443AbhICOAB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Sep 2021 10:00:01 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:47361 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235169AbhICOAA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Sep 2021 10:00:00 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 4BC623200392;
        Fri,  3 Sep 2021 09:59:00 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Fri, 03 Sep 2021 09:59:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=P7+z8iMxzb0763KA6v+2GBqFK/Z
        ZTu6DoHoTlqtoCwk=; b=kDbhQvG8V5NjaMSWFZhViFraDkGHLxi6yMatFJRy8Kv
        4BvGu6A3mm565NdyB3Pkdl/5Nql5Pzi0hCp706v+D8RtpF+LqdiMJUB6J+JcvniB
        uYALSEoVaa3G19+FweN87i3QVbhYbQQl0ssz20L8GHuWAgttEbo3qLAySNvGwIAU
        VC/V8FWsQdXCz9vno9Bk99dJKDoBU+RFMukMGvuMkJLR7TWV85i3GVFYsnSUr/f6
        8mxRfNM0hFdfgcl58BkADkGE2E34ZN6xM8EylZUMbKhMzqH6BH8UASNDi2h0v5CT
        l9OL0YqnUzakwgTTnqS+tBEg7GgFkfimuD4RTkK2MTw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=P7+z8i
        Mxzb0763KA6v+2GBqFK/ZZTu6DoHoTlqtoCwk=; b=I1SBU0q5qY9XCS4gRfaxpO
        ys2UYdmRLPLdpnfwxMAW4v2doAWcsUNNG7CnCaooHxubSPvf4vHQL3G6QcvBJFCn
        fNlq5WyzHdfU5t/jEhiBCPPvMKkOn9J2p6e0h2WeIhijJwIi1QMQ4wtb3IQVpanK
        2WGjmUYh3+exjs9hyB6/guDsJJXapzp6r8xdyNiEuVj2CTsaCc7JmdwGQWcUHA08
        HDqm760pQrcJ3+dZTvcXQlJ53U0Tr+cmdxHwOlyxefj2Sbz8j0oA9yw8Z9OzpCJS
        ZCQoClJmLaYOi3L5Z/1eG7jiaTlaSPJwGyq2aGfUdBGPTSgG/ndaQU//gTWAsiXA
        ==
X-ME-Sender: <xms:IyoyYXZbhPV9EYfokXI6zUWBUmOQwK6jedjT9_gl9k_11m9lX6weSw>
    <xme:IyoyYWYRRWBKbb0uFbrM89jzAsROJ_Phf3pijLZMs6gD6lKifL1JXrjwiE76E08Qo
    eBsA0qfI8vlxA>
X-ME-Received: <xmr:IyoyYZ9kcoD7HOr54heGzq7aWWNOzLewWvBseSAYv4IVvljoavgsgt7GqwpeIiU9R2leAcaitTcCIXhHIPVDucFuQ_tBgN5Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddvjedgieelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:IyoyYdodk2BcZX_gsJYNoz0jou3zV76QIoakpMFT5pODfO04D6UsXg>
    <xmx:IyoyYSpWsRhTE_40OYKyz_aIG6_e_ntXy0SNy0bPjtXHwkPfhZExFw>
    <xmx:IyoyYTQIijLuamwYdJKsTcMEIj6NHrulNB0alRzvZGIl0V_1vc4QNA>
    <xmx:IyoyYbnhcCp_zCbZpnqbe2PN14adhJ3JuwvGUKHvfoaPFaIRPXrfWg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 3 Sep 2021 09:58:59 -0400 (EDT)
Date:   Fri, 3 Sep 2021 15:58:57 +0200
From:   Greg KH <greg@kroah.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     stable@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH 5.10 0/4] backport fscrypt symlink fixes to 5.10
Message-ID: <YTIqIWc+A9LxQUrq@kroah.com>
References: <20210901162721.138605-1-ebiggers@kernel.org>
 <YS+sg+meMk0upj7H@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YS+sg+meMk0upj7H@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 01, 2021 at 06:38:27PM +0200, Greg KH wrote:
> On Wed, Sep 01, 2021 at 09:27:17AM -0700, Eric Biggers wrote:
> > This series resolves some silent cherry-pick conflicts due to the
> > prototype of inode_operations::getattr having changed in v5.12, as well
> > as a conflict in the ubifs patch.  Please apply to 5.10-stable.
> 
> Thanks, will queue these up after this next round of -rc kernels are
> released.

All now queued up, thanks.

greg k-h
