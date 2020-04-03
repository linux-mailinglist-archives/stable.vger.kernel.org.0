Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FB9B19D364
	for <lists+stable@lfdr.de>; Fri,  3 Apr 2020 11:20:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727829AbgDCJUg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Apr 2020 05:20:36 -0400
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:35509 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727774AbgDCJUf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Apr 2020 05:20:35 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id C46C97BF;
        Fri,  3 Apr 2020 05:20:34 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Fri, 03 Apr 2020 05:20:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=cGOTJPKcDs47nZ9/lI4ynlR3lxG
        ccMyQDcAWVYl28lY=; b=o09laQZs0qYFYef28XZFT6GwJZGL4Mhuc+o7Ph2a7Kr
        IPVfFH6I6OBWPdvdH7j6IgkF80Gh30WKo+hhwLZJwTRt9LVE0jeBCgmhwxgcG9sN
        i5SsSwukEsAxkd0HHGIA3jw4kgJAuzJZFI4HCU9hXHJFEoPnJv5H8xui3PS6M2rU
        BqtOuUTs078QBchhgNSG+Kd4KI+O3YjLXO2toaRjqONRC+xjonhR1EP0IobxWOk+
        gjNT/miqb4aAZtUudBGNqJB2clRSeC8yeZTDlKWF/BkqjQ5I6+6kyeQme1Tto3Gt
        6MF0WmG7XYWfmWJZQbhhPEV6tg3QRPAWs5D+OpSOCzQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=cGOTJP
        KcDs47nZ9/lI4ynlR3lxGccMyQDcAWVYl28lY=; b=nZpxawwATOgsljdh7/emx0
        GZyy4ZMnd0Wo2g+3jNSBXfOd8+c7F0EUoyw25dAMb47HATaSqtTaWscW4uZrVtVV
        tDBqOz19AQhiFWITjcVSyL4bpxQhOHCg+6fPhu5RTSs1RMxOUje3H8qXdHy6AVGd
        kmIz9TFoamg5Se8EV66OfjkhK0oAgA1OxyK/qsunZmfzC9k63SxDq9DHhTN0NNdk
        CG4kLVddqSiFJ91F90lGbT/D2WXRHCOFNT5ePLb+xVg6UiyjHyD+fBOAv25utVO3
        9KaNhgf5+wlnRvHWiXTzBCjGyBLJ+dAfDOVw1+EwUGF5grxgrVwTj45YNfpo0ySg
        ==
X-ME-Sender: <xms:4v-GXizOBir4MsOb0e8NKmNGJfKKENoM1edJb-URvCy042_Dzh0WTw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrtdeigddugecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppeekfedrkeeirdekledruddtje
    enucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgv
    gheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:4v-GXsgImUSxovAwFfLQH57hkkFr_s42osbl5Xm-9W9_0Rrzkvsfvw>
    <xmx:4v-GXhfu-x7qPxfyC5HLTnJ1GlpBFyf78Klg_MimVfTNLmAdZEITwA>
    <xmx:4v-GXrVUPwNICGhWFhqgtB_W29Pr2nh5x4rfn191oeZK-BGdP3KmUQ>
    <xmx:4v-GXscW-JcNWGhHxlBpmKCxsltB5wv_4wsxztePB7uEUQovB-4Cgw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id D37FD328005E;
        Fri,  3 Apr 2020 05:20:33 -0400 (EDT)
Date:   Fri, 3 Apr 2020 11:20:32 +0200
From:   Greg KH <greg@kroah.com>
To:     Giuliano Procida <gprocida@google.com>
Cc:     stable@vger.kernel.org
Subject: Re: backport request for use-after-free blk_mq_queue_tag_busy_iter
Message-ID: <20200403092032.GE3740897@kroah.com>
References: <CAGvU0HkVUE_mQY8AUjieRcRrD38gdJRE+CbDuenMxnU6DAFOSA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGvU0HkVUE_mQY8AUjieRcRrD38gdJRE+CbDuenMxnU6DAFOSA@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 01, 2020 at 05:47:02PM +0000, Giuliano Procida wrote:
> This issue was found in 4.14 and is present in earlier kernels.
> 
> Please backport
> 
> f5bbbbe4d635 blk-mq: sync the update nr_hw_queues with
> blk_mq_queue_tag_busy_iter
> 530ca2c9bd69 blk-mq: Allow blocking queue tag iter callbacks
> 
> onto the stable branches that don't have these. The second is a fix
> for the first. Thank you.
> 
> 4.19.y and later - commits already present
> 4.14.y - f5bbbbe4d635 doesn't patch cleanly but it's still
> straightforward, just drop the comment and code mentioning switching
> to 'none' in the trailing context
> 4.9.y - ditto
> 4.4.y - there was a refactoring of the code in commit
> 0bf6cd5b9531bcc29c0a5e504b6ce2984c6fd8d8 making this non-trivial
> 3.16.y - ditto
> 
> I am happy to try to produce clean patches, but it may be a day or so.

I have done this for 4.14.y and 4.9.y, can you please provide a backport
for 4.4.y that I can queue up?

thanks,

greg k-h
