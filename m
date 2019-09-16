Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6225BB392D
	for <lists+stable@lfdr.de>; Mon, 16 Sep 2019 13:13:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729541AbfIPLNh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Sep 2019 07:13:37 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:48813 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725826AbfIPLNh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Sep 2019 07:13:37 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 4D4D3723;
        Mon, 16 Sep 2019 07:13:36 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 16 Sep 2019 07:13:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=hRigFTwphf1qy+sgPmQeqeUX4se
        TEa9X3v1YEI5zFPk=; b=bN02mj7XSCgqfbikYIYuw1/IFIyW1R8vBdKSl1hQZGi
        MIW7bfrzFWrjaBsvLA3nERihcziphcHivuqDjmHcM2ilHft6Lfy5OPFITZsbcufO
        Ug17Up235O3Z8azk5DAK23lYiBxMXO1NkRrYLOnSRgjWSwj7bkoNr5+q7upO17MM
        xjT5Fa3iGJnafroefMbkGshgKd6psiPztAevCcltw38XBSgL7J9V/ugBvIyWTgr9
        6J8ojAzT2917gb1R0j/OPoHZkxCUgOJQC0H7RtyopUmMJahxOoxvqG234KpSTqwR
        txTgwhNIhlz1A4LVonQpA7CmoFL9SIziAVk11EOMcpw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=hRigFT
        wphf1qy+sgPmQeqeUX4seTEa9X3v1YEI5zFPk=; b=s6PCn2htbj5kfEjHZym+eI
        a4Y7IANljG+r7eTUWAgcfNDISnHFiggO6HEYVc/rx/UvKbBAlT5wHZQYzctXl1Ps
        tpSHzEgWRAFz330jBFnKY2bp3kRZXB7KTPPmU19tSXBCCDMr3JIUqH+kX+LBorlQ
        rTwP/WCMf0jdU6nUOgLpzC9YULSExKUA4p78mo8AUJyAEZ0ueV9Kc8xTOSCmFF+n
        TzdCgauJ46Vf534e1oQUJsP3dwf+7kUrVFeKQL2jTmOk6NrfBZpVzMM8a2a9sttR
        z3dWL4xKZKTiEzSqWN4ch03/aRm3NYSlDWxRc3//rjUGCmWeqaH/yRN/sPDDDr6A
        ==
X-ME-Sender: <xms:X25_XWjGhJKOeIJmi1509fe0ukKRfLAHTQcNE-srsPq_5KerNFWHZw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudefgdefkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucfkphepkeefrdekiedrkeelrddutd
    ejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhenucev
    lhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:X25_XYgUS0rduG0Udz_3wBKh22Y69BkB3uluB-iK0Ha3vmvRAzPSlA>
    <xmx:X25_XeKq3ygqJ92p7duajHO7COHhq2LnFuUIoHGoUD5NKbxERs5llw>
    <xmx:X25_XfEnF-PAk8kBYdMRA6LjPjd1VrnhYKQ0X6HsDnw7DYhXjlb7iw>
    <xmx:X25_XVflGLDAukI5Ou7okP0K48E3DTP_cRr3HEPTqWCjd737bc20IQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1DA7280063;
        Mon, 16 Sep 2019 07:13:35 -0400 (EDT)
Date:   Mon, 16 Sep 2019 13:05:20 +0200
From:   Greg KH <greg@kroah.com>
To:     David Miller <davem@davemloft.net>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCHES] Networking
Message-ID: <20190916110520.GA1485033@kroah.com>
References: <20190915.203722.1417237812508740544.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190915.203722.1417237812508740544.davem@davemloft.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Sep 15, 2019 at 08:37:22PM +0100, David Miller wrote:
> 
> Please queue up the following networking bug fixes for v4.19
> and v5.2 -stable, respectively.

All queued up, thanks!

greg k-h
