Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78FD381F5C
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 16:43:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728149AbfHEOn4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 10:43:56 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:53107 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727349AbfHEOn4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Aug 2019 10:43:56 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 6F1D121F48;
        Mon,  5 Aug 2019 10:43:55 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 05 Aug 2019 10:43:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=3nyzWng7SeF0wmA5xPW/ugnaHEj
        EYXSQ0h/sQBWhVWA=; b=LtcjoADpjx5RTz8PDIGlPiUXgnUcGW3cVzfnZGCd51/
        6lYfTJhQvB7Oi+sk1ho559CKznYBirzizf+ydESKXlZx2mr9cVOa75QqG5IeG/Jj
        It7n/ws8OUC2/45l9hzUBeZqhIERK6YKGO6VHgUMGYfuKTHj69fTd80CaflWfWd2
        nLDp7uJZ6n4KsRM4KVJtXi02r1pul3ed0NFX6qKgdLFHQcVA6F/yB6J1sFs4uaHU
        Aou/y5O6rnKN0aKuX6pTV0E5y76An1h6ifVhXkm6CltrQZXjXHxoHIQjiybmxi0j
        8IXiC4NvDpxpKEBqEl6ZaQN9veD3L2+yWGA8FD97y8Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=3nyzWn
        g7SeF0wmA5xPW/ugnaHEjEYXSQ0h/sQBWhVWA=; b=aR2bamWPEw0tl0Oi6VVX+R
        tax3DBFXBJYNs5v6QBjRsJy0ZAfRTVor+QPN/nlzmbb8gBJXkuYUlsTmc8SwoB9J
        hlCxSyVV1hv9omu1hOsQGXfxcGsg33c27RA2gUM1Z1ZrBoMIps/ctbgCHkoxA+R+
        KR1H6hkS9xm44zsmnQaX6zWMFU9jjgFJcqjgKx1FFVGNwyyM72R2TuzdWMpgoFvr
        Ycpy15iyPMxXJcOL9ucHhSm8QkQQiR7FGA3u/OiqvMlKZRuVyf3Br1TIV5fqouHx
        7aE1J7hMSbaX57mlifXSfIVaYAC7NknsN1PpYfGAIdY4u0l7sRHCdUbjQ7Wj4Zxw
        ==
X-ME-Sender: <xms:qkBIXda0JRg744sfwRDwn_II4fJm-Vp49GFiWMlmnx4KOiTMfiRUYQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddtjedgjeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuffhomhgrihhnpehgihhthhhusg
    drtghomhenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhr
    ohhmpehgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:qkBIXYo48xIzgiXkvhHGdTsr7OuF70uKmBT4hXTnOpSTIv6GgyaGCg>
    <xmx:qkBIXa_7PSPvcqmNyjK-raFT10PNjBauMyW4ykRkIBGIZcqyAH0VqQ>
    <xmx:qkBIXf9s1oerKeuYNJQdaRB5aXdJ0e8_pxhjS63xnL82r85FWqfF-A>
    <xmx:q0BIXXdAztxHYyGskP9zaDEfilVhDyBI8PMV5v4W0MtwS3GrIGq9oA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0D62D8006C;
        Mon,  5 Aug 2019 10:43:53 -0400 (EDT)
Date:   Mon, 5 Aug 2019 16:43:51 +0200
From:   Greg KH <greg@kroah.com>
To:     Sebastian Parschauer <s.parschauer@gmx.de>
Cc:     stable@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH 4.14] HID: Add quirk for HP X1200 PIXART OEM mouse
Message-ID: <20190805144351.GA30363@kroah.com>
References: <20190724210324.4868F218B8@mail.kernel.org>
 <20190805141056.8764-1-s.parschauer@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190805141056.8764-1-s.parschauer@gmx.de>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 05, 2019 at 04:10:56PM +0200, Sebastian Parschauer wrote:
> The PixArt OEM mice are known for disconnecting every minute in
> runlevel 1 or 3 if they are not always polled. So add quirk
> ALWAYS_POLL for this one as well.
> 
> Jonathan Teh (@jonathan-teh) reported and tested the quirk.
> Reference: https://github.com/sriemer/fix-linux-mouse/issues/15
> 
> Signed-off-by: Sebastian Parschauer <s.parschauer@gmx.de>
> CC: stable@vger.kernel.org # v4.14.x
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> [sparschauer: Backport to < v4.16 hid_blacklist]
> Signed-off-by: Sebastian Parschauer <s.parschauer@gmx.de>
> ---
>  drivers/hid/hid-ids.h           | 1 +
>  drivers/hid/usbhid/hid-quirks.c | 1 +
>  2 files changed, 2 insertions(+)

What is the git commit id of this patch in Linus's tree?

thanks,

greg k-h
