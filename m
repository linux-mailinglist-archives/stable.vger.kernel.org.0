Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 085A17DCD3
	for <lists+stable@lfdr.de>; Thu,  1 Aug 2019 15:50:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728041AbfHANuu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Aug 2019 09:50:50 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:49165 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725930AbfHANuu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Aug 2019 09:50:50 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 47C8D43F;
        Thu,  1 Aug 2019 09:50:49 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Thu, 01 Aug 2019 09:50:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=VD0+62PbXYEUtn3nWDeyLEdc1Uk
        cObs+jXwJEZ9imi8=; b=XL5l8TWup11/3STFzR7FeSvbvt+oA0XRSm16xAqK+UI
        +J1Np0f66xrbHY4zCea8Cx+bUs/d6DsB4/KR5v5uSOf6XtXoKW2FNBV6gLppNYX8
        0OvQ1bltL8Z/Co6+exZx36hE/zrT/MvfM5gybzossmBhWKbWriyq3mW5CP+WEgGJ
        bpZh5h0ZDY4bG+CQ2cVxt2qPw6DUUqNh64+pIwkGB/d0EzOOOBvLZR/9dOVY8CGF
        zVrTizMk+ft48EAKGmT36pgPlkmMLfJtPmVtzeHhvYimKtUCXRRnvKdk0HyeKBVh
        K9DsXFAKo2zS9AN10HDcSIJmJ1ZQP9CYGmXFKZe0J9w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=VD0+62
        PbXYEUtn3nWDeyLEdc1UkcObs+jXwJEZ9imi8=; b=o5EN+DrqUd3XeC2qlsJKEw
        THLsfg6/pjZU4AV6lOnDON7LxQPdmkmCLODaPXk4im4gYjSn7wfQnVZPjsRNuKUt
        0MenDWGt+R/qaqlEe7wcJ4V6hxkSbhp9mDNMKqaop5pk4r7xdZmFP/bZ2kotrYGu
        0sZUQcl2GY+UqsVg8bHxj83eCsVEze774dabczLiqI7b6r2ygW6p5RUdv1vZIGHC
        16Sgs3I9l7fajimGfIy960P48jGJ1A6uJBQr7z0n9BU624DM8G1/YvrLvAIUqgok
        eScDLxq26OHzuMMlPfz5k2wsCr57Qw05YBgohBN5bBgLAwkTR03CslqR0p/lbG5A
        ==
X-ME-Sender: <xms:OO5CXe58fVDB1Y-4wsdg5Ayynxd1j2VvdEjG-FjbZHlMyOJRhvAgZQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrleejgdeikecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucfkphepkeefrdekiedrkeelrddutd
    ejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhenucev
    lhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:OO5CXekqEv3fICIw9qvS_0Cr9VW5YjMICx1KXxm2CwVv3LHbcVPqjw>
    <xmx:OO5CXXnDngUcH-x5bMdAp67_eq-rBCJHQPBlhG4H5lT4fwUO5MSFsA>
    <xmx:OO5CXa7GqhyrEbuEOjrJOee6WJ9hbxA9-i5RRC2mGYzAxtLko5jRbw>
    <xmx:OO5CXb6RaIXMZWT47YEkLtOuE3r3MSueMlY-gtHtdsDxd-CJiFov8A>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1328F380076;
        Thu,  1 Aug 2019 09:50:47 -0400 (EDT)
Date:   Thu, 1 Aug 2019 15:50:44 +0200
From:   Greg KH <greg@kroah.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Vladis Dronov <vdronov@redhat.com>,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v5.3-rc2] Bluetooth: hci_uart: check for missing tty
 operations
Message-ID: <20190801135044.GB24791@kroah.com>
References: <20190730093345.25573-1-marcel@holtmann.org>
 <20190801133132.6BF30206A3@mail.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190801133132.6BF30206A3@mail.kernel.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 01, 2019 at 01:31:31PM +0000, Sasha Levin wrote:
> Hi,
> 
> [This is an automated email]
> 
> This commit has been processed because it contains a "Fixes:" tag,
> fixing commit: .
> 
> The bot has tested the following trees: v5.2.4, v5.1.21, v4.19.62, v4.14.134, v4.9.186, v4.4.186.
> 
> v5.2.4: Build OK!
> v5.1.21: Build OK!
> v4.19.62: Build OK!
> v4.14.134: Failed to apply! Possible dependencies:
>     25a13e382de2 ("bluetooth: hci_qca: Replace GFP_ATOMIC with GFP_KERNEL")
> 
> v4.9.186: Failed to apply! Possible dependencies:
>     25a13e382de2 ("bluetooth: hci_qca: Replace GFP_ATOMIC with GFP_KERNEL")
> 
> v4.4.186: Failed to apply! Possible dependencies:
>     162f812f23ba ("Bluetooth: hci_uart: Add Marvell support")
>     25a13e382de2 ("bluetooth: hci_qca: Replace GFP_ATOMIC with GFP_KERNEL")
>     395174bb07c1 ("Bluetooth: hci_uart: Add Intel/AG6xx support")
>     9e69130c4efc ("Bluetooth: hci_uart: Add Nokia Protocol identifier")
> 
> 
> NOTE: The patch will not be queued to stable trees until it is upstream.
> 
> How should we proceed with this patch?

Already fixed up by hand and queued up, your automated email is a bit
slow :)

greg k-h
