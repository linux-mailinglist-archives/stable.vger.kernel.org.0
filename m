Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FC2676164
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 10:56:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725944AbfGZI4U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 04:56:20 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:34203 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725842AbfGZI4U (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Jul 2019 04:56:20 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 011D048C;
        Fri, 26 Jul 2019 04:56:18 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Fri, 26 Jul 2019 04:56:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=DtU+MuRFEzOZTFMx8vOWJ0Pzp2u
        K5qQtO6Jx/4NNOoQ=; b=EARYC3Yk7y2m3PM6cBa1O8O1e0minxSJZwQNb1ej4tN
        cvnPYRAqZywqDPauKccIqwUYIEnh5u/twDGwUnRQXepqx0bKiEb6dfhIXJNES9cm
        HEdztIEebDVwNdkERwcIg6DRAi+InQyrzGh7FNZC4lLLcXu3J6uE9UIZTqhO/Aer
        MkylU5OETl29amS1vbMLDvH1Ouu8YYYMvVG5X77QF8exa8HYp98kvcP+kT6AOZF0
        sm88oVsdX9/qDSnhIzKvYWeRr0Jazd8IPY73U8fFBgm2mPnHaJ9iAl+y7qDRvft/
        k2RyiIbrnxH6FdkvvNu6XdTElulGMDAvx1VSjS6ndqg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=DtU+Mu
        RFEzOZTFMx8vOWJ0Pzp2uK5qQtO6Jx/4NNOoQ=; b=j0HyKjyt5wIEEZIS3W74ZH
        gy0fV0Vca+gyKtfikjIA9MRYSPtvJU2n07rV7xe2cg8bktSH4Eqia+rgZnkjOa0U
        vrdC7iIA2jcC9dUDiBLC2t8O+S1h+6uCtJQb1M6DSG+LvtWpV8jx7XX6rsNReUe5
        bAGaNSOmtdoNhLM1UOdMAK0YCV4P5RtA4jXGQPt1GZnGd0Tm74btB1m9zUPUZrln
        HrRAgo9GMdgtq/RNwtWRAaxIE20XSr+pGwWYaXbVA777mrQ6q/hXPOoyfPUwOaRN
        dhXLl8ciRdunchfmrq+Xq383wRSe0xVYpEv8p1g5mUTKrojBCcQK6+Y1v0rkdSJQ
        ==
X-ME-Sender: <xms:McA6XVzvYrhXnzB__yoYSFFw5go0irgLm2W6v99xGc0gYHf6_A-B8A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrkeeggdduudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucfkphepkeefrdekiedrkeelrddutd
    ejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhenucev
    lhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:MsA6Xc0ZL2PLCPLkfOjGW5gfJsVGOf75v42qqoTrMZb2KLGEi6_mRQ>
    <xmx:MsA6XcSCQIJU0anbeeQ6M55hK_k41crAkj7zFZdx81-sPTwQLxtF0g>
    <xmx:MsA6XVec8IqqjZO0OnrcsahS5sx5epN3AI_u-q8nF4KGnIMp6YUa9w>
    <xmx:MsA6XUvfDDSX1Pgi1gfcLjUU04ZO2weorzdZSSM7kobFGU3lekqeKg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6F9608005A;
        Fri, 26 Jul 2019 04:56:17 -0400 (EDT)
Date:   Fri, 26 Jul 2019 10:54:49 +0200
From:   Greg KH <greg@kroah.com>
To:     David Miller <davem@davemloft.net>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCHES] Networking
Message-ID: <20190726085449.GA1254@kroah.com>
References: <20190724.185542.1419407175465140099.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190724.185542.1419407175465140099.davem@davemloft.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 24, 2019 at 06:55:42PM -0700, David Miller wrote:
> 
> Please queue up the following networking bug fixes for v5.1 and v5.2
> -stable, respectively.

All now queued up, thanks!

No need to do any more patches for 5.1.y anymore, this is going to be
the last release of that kernel branch.

thanks,

greg k-h
