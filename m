Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2507BCCF61
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 10:15:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726270AbfJFIPV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 04:15:21 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:37017 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726264AbfJFIPV (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Oct 2019 04:15:21 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 1A84520D9E;
        Sun,  6 Oct 2019 04:15:20 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 06 Oct 2019 04:15:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=rcQysKi1rsbvHJPFiE7PDIeg5iw
        QBBiKVpHMmwZQ/fc=; b=ZIFhufaw/mtxdIZwGNRgYqwY/lX1XCDid2+p0IWJwhN
        dANNhWal7kVmYCKoWkzbR4799RN35RrjlP4sSkw+FFblwF2QuaiIeAIiRbqLhZYC
        rD0AXdENkk+1Os++QeqDJkmCrdzH6tuTeJnkhaTxILYa5hJDZynEszQq79aBriYB
        tYxi9AF8EXwNN/lOmUE4adom9xzOtyDWOWTQsBwcnC1rzYY++U6vShSLP2GleXuF
        VWKDcvZMAIq8OlL1+qZIawDA0RVo4QthBEtqCW0xxDl58Q5h0QoFF2uYAyO22PAv
        q/9UyCTvDYIkPGJwhvvywWzVXiq5UHc4gMQs/gphD8g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=rcQysK
        i1rsbvHJPFiE7PDIeg5iwQBBiKVpHMmwZQ/fc=; b=1qZ+Z411Ry20YkW5PnFRad
        qekQ0rYCjyVmDEoAUgQz9Nv/YhCsMubNpW/1ktkVpGrHWXKB6eFo4TfZwSJRlZ+K
        cnOp31hbkR3NruI9Siak3um2PvF432WxVXHGbIHn9jLYmhZ6JEb0Qz9kAXtHSqSG
        t9Mp5bRdSZylBe8VlqOwRQ6imeXyw+14/rIiLRzrerFf+1Fxrk/+jvt2v0M9Ir9z
        Egs7GV1YOfF0HBQvgDH2KTnz7/aCEQM1NKdbCycFyq0YggurLOSCmskBBAfYBlwj
        Nj+pOp/NZW4vS/o7APjmmXJnsmxR3NVnKd4vEzNaxTfzCaNzYfq0WPsIUNzKdHEA
        ==
X-ME-Sender: <xms:l6KZXdVfXoECGa4KszHMcNj_BKB-F03f1Li66ENsu5W8N66IjeeiKA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrheehgddtvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucfkphepkeefrdekiedrkeelrddutd
    ejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhenucev
    lhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:l6KZXXhMcNe4NpIy-s90Mp03PS1UAwOywV3eWyTZ1629zOSFRdIswg>
    <xmx:l6KZXfuITww9P1XeL8h76xBhIwTluimxKLVYs9BZHcx7ha1sQynaug>
    <xmx:l6KZXW1rdWKHIXTWvuR4Cv19qiEp65RHK3OkcHW6zXU23dl3u1E_aw>
    <xmx:mKKZXdXZZ0iF6kX-DIlAmV8tsEgUnbSWNoJLDR6n1m6J8hXk1yoZjw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 839518005B;
        Sun,  6 Oct 2019 04:15:19 -0400 (EDT)
Date:   Sun, 6 Oct 2019 09:50:40 +0200
From:   Greg KH <greg@kroah.com>
To:     David Miller <davem@davemloft.net>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCHES] Networking
Message-ID: <20191006075040.GA2246024@kroah.com>
References: <20191005.145722.1341683959362171945.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191005.145722.1341683959362171945.davem@davemloft.net>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Oct 05, 2019 at 02:57:22PM -0700, David Miller wrote:
> 
> Please queue up the following networking bug fixes for v5.2 and
> v5.3 -stable, respectively.

Thanks for these, all now queued up.

Note, 5.2 is now going to be end-of-life after this next release, so no
need to make patches for it anymore.

thanks,

greg k-h
