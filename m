Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3159221EA
	for <lists+stable@lfdr.de>; Sat, 18 May 2019 08:56:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725909AbfERG4w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 May 2019 02:56:52 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:41493 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725268AbfERG4w (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 May 2019 02:56:52 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id AD32927429;
        Sat, 18 May 2019 02:56:51 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sat, 18 May 2019 02:56:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=B1p9lyLBmAPcjBl0M+pwA6JBf+o
        l522aoqJx3w2Ouoo=; b=onimEHeqatTJy3WEBUgD4P5cqx1KTAcaoq2xOIL0LZP
        WI4StJ8etc54wZyKhpRnS5gUWB8lXx6Lizy+LINvyasN32/wX3PjdHaGBYQ1H6y8
        HgD4hPVvJt4MCSKotdZCb5ypdTptFmWXcvCAfN7/cU+T3yw7o2ssTKZVinTqcAY8
        sX8XchjfCO6oQIVa484lfudXYqXZKx7wxIz3BJlK0/zASp1J0cOF0JNf1K3Df/VE
        jRTbCJ+TlrzrfqovDVUQ2OgyQ5V23X0zsF8YpELM+u0+v1NEAxnTxjvKWVBfwgqx
        E154GDtQtHZTE1pV4sYbPcPbV1ruZGnqcPuT5NIcm/w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=B1p9ly
        LBmAPcjBl0M+pwA6JBf+ol522aoqJx3w2Ouoo=; b=AcVeRXOcBZK8WkDVDJkYgB
        exwoz369rLzWmjmLiLwyjiF3U+poFzeXwz3SPxUFX4ZwytkYUbEZSOqoQvhBIeWO
        mkbb/pm2HI9cm90RtuZtt50eKTuGA+gjvHnQdmu58LpfllTo9D4GANTHWDFMDAc7
        9vH4R1qROU5JtPm8UvoxbjnKoA2Vj06QFEXxq0osrgYgHItc3awSQiP28G8zuyTi
        1DwxkRdoJ5fpCuEYjaCmHI+H6sbO+Y+mplVZmGt1j17lxvRrY8FxR8eA4cpvwznL
        O8Ca1CjMHnsCV4Q7GFzYvrD7oU5yzhF56ewdzk3lE6teEOXIV7LDzQU2jNDgOYwQ
        ==
X-ME-Sender: <xms:s6zfXOkpV4odn75BPJU3XXHC4eZLqhS7zcC6YPKPKSX8v-kIRhZvXg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddtfedguddugecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefirhgv
    ghcumffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:s6zfXPJIGhK-Vcw6k1F6sSPEREgbhFfpeOpSfCb4fxCMvRN7AfuD7w>
    <xmx:s6zfXJA6GG5oK9Y4M5h0EnmuaTjmpPTRdJiy__bPpdKtCAyWjflHog>
    <xmx:s6zfXKJvdh12Qm-MTyHQSHd6wLZ1yBUd_6gWhCwLdBZzSTmpUe3YAw>
    <xmx:s6zfXBZ46B5DpOWzW3tSqCaXPfZqdEdu5ebMDUY-hmrjUiEfPMXlTw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1FA3D80059;
        Sat, 18 May 2019 02:56:51 -0400 (EDT)
Date:   Sat, 18 May 2019 08:56:48 +0200
From:   Greg KH <greg@kroah.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     stable@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH 4.4 2/2] crypto: gcm - fix incompatibility between "gcm"
 and "gcm_base"
Message-ID: <20190518065648.GD28796@kroah.com>
References: <20190517180610.150453-1-ebiggers@kernel.org>
 <20190517180610.150453-2-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190517180610.150453-2-ebiggers@kernel.org>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 17, 2019 at 11:06:10AM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> commit f699594d436960160f6d5ba84ed4a222f20d11cd upstream.
> [Please apply to 4.4-stable.]
> 
> GCM instances can be created by either the "gcm" template, which only
> allows choosing the block cipher, e.g. "gcm(aes)"; or by "gcm_base",
> which allows choosing the ctr and ghash implementations, e.g.
> "gcm_base(ctr(aes-generic),ghash-generic)".
> 
> However, a "gcm_base" instance prevents a "gcm" instance from being
> registered using the same implementations.  Nor will the instance be
> found by lookups of "gcm".  This can be used as a denial of service.
> Moreover, "gcm_base" instances are never tested by the crypto
> self-tests, even if there are compatible "gcm" tests.
> 
> The root cause of these problems is that instances of the two templates
> use different cra_names.  Therefore, fix these problems by making
> "gcm_base" instances set the same cra_name as "gcm" instances, e.g.
> "gcm(aes)" instead of "gcm_base(ctr(aes-generic),ghash-generic)".
> 
> This requires extracting the block cipher name from the name of the ctr
> algorithm.  It also requires starting to verify that the algorithms are
> really ctr and ghash, not something else entirely.  But it would be
> bizarre if anyone were actually using non-gcm-compatible algorithms with
> gcm_base, so this shouldn't break anyone in practice.
> 
> Fixes: d00aa19b507b ("[CRYPTO] gcm: Allow block cipher parameter")
> Cc: stable@vger.kernel.org
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> ---
>  crypto/gcm.c | 34 +++++++++++-----------------------
>  1 file changed, 11 insertions(+), 23 deletions(-)

Both now queued up, thanks.

greg k-h
