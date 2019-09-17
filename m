Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 659D6B54F3
	for <lists+stable@lfdr.de>; Tue, 17 Sep 2019 20:11:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727941AbfIQSLc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Sep 2019 14:11:32 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:43381 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726883AbfIQSLb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Sep 2019 14:11:31 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id B895A22006;
        Tue, 17 Sep 2019 14:11:30 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 17 Sep 2019 14:11:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=I/TlEC3jhYvjL1y1geR9IG8Zay1
        GtX68aiiSzlszgro=; b=UiFscZeM8/99BjdUTr4h6bowIAM1Tf4ujZ3TFXW/q0/
        MU0qZvemcI+QcjhXwH5xcGvxxa8CLGvy+lJAk644wXg6ID2wbiVq8XQX/gh7G4Bs
        gI37BPXROpTYEpD2wVu1K0QJOqY6h5rRmE/wBEAUT65jnWgdb4Ow8lMGih5pJcDn
        cFXiiQrT9hAy3xxZb5RduEkoB3fpauJscNzAROE21LzgXGo1jPbmBiqyxo3x0mde
        rKM5WDWwH7TQoGeewtXa49qHTYC/GvIL6/SraIrrI59GLAIzApWJ248Ofjydqgn8
        wXlz2g4ZDMSRoj7119/CchSf7irPyXweFqzZ9WGAJTA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=I/TlEC
        3jhYvjL1y1geR9IG8Zay1GtX68aiiSzlszgro=; b=iJHOTWYKD0F9nqPa8x6JcU
        LRou34THpNBhbI8IaMsb/MIM+b9Ddzn3LR79f3zzX6VnOdy++tScNprG4Skqx+w4
        rN6nrYY/kBTlruZn0sCxsdf81cFCQ4VerYmUfyxYKWKMtQOgw1uc/C3RLwRMD6td
        ZckI4+T+uApvivQJT0pVN+YlxmtACnjA4NpmF5cKhlQidNiEMmHNaz9Q8t2m2YwH
        x5pWoXBdVV/87weip6a0CSxj7QEGjcXgdlCC58RwnVIlHcV9ciE4SspvX7cucib1
        V7ONOwpWrLCUSTICyPcxUP3zwokhTSfwNCXU6cwGdZYy9J/aq7pRMRJtQS0Gr6cQ
        ==
X-ME-Sender: <xms:0SGBXTzi09IARfuOigWruwLC3mPXL9PNpKuEbkxwISxap-2K12IO6w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudeigdelgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucfkphepkeefrdekiedrkeelrddutd
    ejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhenucev
    lhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:0SGBXQqZ21Ovb2fmcQiFENv6AvFBxh2Q6tcLjGyHUtfLCkM6MMw5aw>
    <xmx:0SGBXZwnW5ShFNKyEvoF2rZMyOnWjITiQc1nrkQZwHHLKLgus7Ys5g>
    <xmx:0SGBXSqXdgD7w77EnwunUTVXukQOacOZa368FMm49xX7fWjGVX-sQg>
    <xmx:0iGBXcMgTU1WaJIMCw5SSiVWdlTEzlfm8SYvMVUQ3hTXwEef7y-x9A>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id B524F80064;
        Tue, 17 Sep 2019 14:11:28 -0400 (EDT)
Date:   Tue, 17 Sep 2019 20:11:27 +0200
From:   Greg KH <greg@kroah.com>
To:     Tokunori Ikegami <ikegami.t@gmail.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        Chris Packham <chris.packham@alliedtelesis.co.nz>,
        Joakim Tjernlund <Joakim.Tjernlund@infinera.com>,
        linux-mtd@lists.infradead.org, stable@vger.kernel.org,
        Felix Fietkau <nbd@nbd.name>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Vignesh Raghavendra <vigneshr@ti.com>
Subject: Re: [PATCH for 5.2.y] mtd: cfi_cmdset_0002: Use chip_good() to retry
 in do_write_oneword()
Message-ID: <20190917181127.GD1570310@kroah.com>
References: <20190917175048.12895-1-ikegami.t@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190917175048.12895-1-ikegami.t@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 18, 2019 at 02:50:48AM +0900, Tokunori Ikegami wrote:
> As reported by the OpenWRT team, write requests sometimes fail on some
> platforms.
> Currently to check the state chip_ready() is used correctly as described by
> the flash memory S29GL256P11TFI01 datasheet.
> Also chip_good() is used to check if the write is succeeded and it was
> implemented by the commit fb4a90bfcd6d8 ("[MTD] CFI-0002 - Improve error
> checking").
> But actually the write failure is caused on some platforms and also it can
> be fixed by using chip_good() to check the state and retry instead.
> Also it seems that it is caused after repeated about 1,000 times to retry
> the write one word with the reset command.
> By using chip_good() to check the state to be done it can be reduced the
> retry with reset.
> It is depended on the actual flash chip behavior so the root cause is
> unknown.
> 
> Cc: Chris Packham <chris.packham@alliedtelesis.co.nz>
> Cc: Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
> Cc: linux-mtd@lists.infradead.org
> Cc: stable@vger.kernel.org
> Reported-by: Fabio Bettoni <fbettoni@gmail.com>
> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> Signed-off-by: Tokunori Ikegami <ikegami.t@gmail.com>
> [vigneshr@ti.com: Fix a checkpatch warning]
> Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
> ---
>  drivers/mtd/chips/cfi_cmdset_0002.c | 18 ++++++++++++------
>  1 file changed, 12 insertions(+), 6 deletions(-)
>  mode change 100644 => 100755 drivers/mtd/chips/cfi_cmdset_0002.c

You changed the file to be executable???  That's not ok :(

Also, what is the git commit id of this patch in Linus's tree?  I can't
seem to find it there.

thanks,

greg k-h
