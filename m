Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4570A5C878
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 06:41:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725808AbfGBElK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 00:41:10 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:37737 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725648AbfGBElK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Jul 2019 00:41:10 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 0EDBE4F2;
        Tue,  2 Jul 2019 00:41:08 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 02 Jul 2019 00:41:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=M339WNpyptsEkES40075yFhWz3m
        5rFjjeJNPBTWgukw=; b=FTtQuR3hBHcIsOWtMcGuzjyjNnDKN/9iruxCAkp3qNX
        ZMPRZJ684Yex6W4Vi3Kf672S2vLrmSZYLfq8argcAX/Bat4beiZ2terrZnKogdLq
        dQdNmZBmXUdj/DlC0YQqj6lAujHWMlJJqFfdwbzCxtsaHmKSpXTRYq10kzp4MzOl
        B0Xc7WLYxjSDPiMdfSN0+OA/QyRJKEYC6DquDXgtf++tdWJS1npfdIWXDeRyze1u
        8JpEL4YOiI5ET7mK82m2soCVan6xBoHCiSmfXzWiFCU8JtX+GvepwK+FWgWevXY9
        itJ6YzSX1p82NQJcJNcxtxzGGotdPhf30REoHlds+Tg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=M339WN
        pyptsEkES40075yFhWz3m5rFjjeJNPBTWgukw=; b=BJOB/gS33vl1TUq831usM/
        9kQyDqjUELfF5xrtiO2UfHSC9YIs0N3CFQACFtDirdxr9phcoEfU5+I3a/t7UYUQ
        bwTS1YAf8OSe0tB/NgTMQORYWmzBe7sAGRgrfgSNgRsYcVGJGxkrVx3MUDSLKVMO
        SW6UEa1MNWkiC9GUB9hdXNR4mfIW8G0kmcpiA78SJ+ibvFl8FM9uJ6eFQ9Yf9BWK
        s1CoDQuCQysE6LbX150aoZ1YKMQQMkeS3Yce6b49UNYy4/imlv4bT/2QUuFngraU
        c1eBEIeTV0xQ4fLR6FCQ/pQJ22FbH1CGCKazk1DSBEuFB2a3LtQpQTGR8l25UXOw
        ==
X-ME-Sender: <xms:ZOAaXRZ0uD4TM4zMm6kuEjavhYs_R4ZC7CjMwyryauK2Mka1ookzBQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrvdejgdekhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucfkphepkeefrdekiedrkeelrddutd
    ejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhenucev
    lhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:ZOAaXW5bshJTn6kH1_Qynn7O2niuOp5MVljru13RYYKmhx9Vq23bag>
    <xmx:ZOAaXezo7eQ7ct7W9L-ktj9a1YmEbdeaZxp_yQtnND_IYkAXwp-2gQ>
    <xmx:ZOAaXV3Aln8gXjvwi1C1uSVT_TuR2SyQHeELYKmPwWXTzr3wKw02KA>
    <xmx:ZOAaXU52uS05BCaDzdIVcEeZUXFV84-X9MpieElZIt6E5SFBfxWzgg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id AE4FA80059;
        Tue,  2 Jul 2019 00:41:07 -0400 (EDT)
Date:   Tue, 2 Jul 2019 06:40:56 +0200
From:   Greg KH <greg@kroah.com>
To:     David Miller <davem@davemloft.net>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCHES] Networking
Message-ID: <20190702044056.GA567@kroah.com>
References: <20190701.185255.2169498414285832961.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190701.185255.2169498414285832961.davem@davemloft.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 01, 2019 at 06:52:55PM -0700, David Miller wrote:
> 
> Please apply the following bug fixes to v4.19 and v5.1 -stable,
> respectively.

All now queued up, thanks!

greg k-h
