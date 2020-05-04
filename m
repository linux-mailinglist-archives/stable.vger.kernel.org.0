Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 651B21C337B
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 09:16:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726935AbgEDHQw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 03:16:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726515AbgEDHQw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 May 2020 03:16:52 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28DB8C061A0E
        for <stable@vger.kernel.org>; Mon,  4 May 2020 00:16:52 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1jVVLI-00028Z-SR; Mon, 04 May 2020 09:16:44 +0200
Received: from sha by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1jVVLI-0001Mp-3y; Mon, 04 May 2020 09:16:44 +0200
Date:   Mon, 4 May 2020 09:16:44 +0200
From:   Sascha Hauer <s.hauer@pengutronix.de>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Richard Weinberger <richard@nod.at>, linux-mtd@lists.infradead.org,
        linux-crypto@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] ubifs: fix wrong use of crypto_shash_descsize()
Message-ID: <20200504071644.GS5877@pengutronix.de>
References: <20200502055945.1008194-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200502055945.1008194-1-ebiggers@kernel.org>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 09:12:17 up 74 days, 14:42, 102 users,  load average: 0.08, 0.30,
 0.31
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 01, 2020 at 10:59:45PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> crypto_shash_descsize() returns the size of the shash_desc context
> needed to compute the hash, not the size of the hash itself.
> 
> crypto_shash_digestsize() would be correct, or alternatively using
> c->hash_len and c->hmac_desc_len which already store the correct values.
> But actually it's simpler to just use stack arrays, so do that instead.
> 
> Fixes: 49525e5eecca ("ubifs: Add helper functions for authentication support")
> Fixes: da8ef65f9573 ("ubifs: Authenticate replayed journal")
> Cc: <stable@vger.kernel.org> # v4.20+
> Cc: Sascha Hauer <s.hauer@pengutronix.de>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Looks better that way, thanks.

Acked-by: Sascha Hauer <s.hauer@pengutronix.de>

Sascha

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
