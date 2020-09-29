Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D43BC27BF85
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 10:33:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727817AbgI2Ick (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 04:32:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725554AbgI2Ich (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Sep 2020 04:32:37 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7195EC061755
        for <stable@vger.kernel.org>; Tue, 29 Sep 2020 01:32:37 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1kNB3o-0002zp-Kn; Tue, 29 Sep 2020 10:32:32 +0200
Received: from sha by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1kNB3o-0006FY-7q; Tue, 29 Sep 2020 10:32:32 +0200
Date:   Tue, 29 Sep 2020 10:32:32 +0200
From:   Sascha Hauer <s.hauer@pengutronix.de>
To:     Richard Weinberger <richard@nod.at>
Cc:     linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Kristof Havasi <havasiefr@gmail.com>
Subject: Re: [PATCH] ubifs: journal: Make sure to not dirty twice for auth
 nodes
Message-ID: <20200929083232.GA11648@pengutronix.de>
References: <20200928190612.12074-1-richard@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200928190612.12074-1-richard@nod.at>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:31:25 up 222 days, 16:01, 152 users,  load average: 0.20, 0.16,
 0.24
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 28, 2020 at 09:06:12PM +0200, Richard Weinberger wrote:
> When removing the last reference of an inode the size of an auth node
> is already part of write_len. So we must not call ubifs_add_auth_dirt().
> Call it only when needed.
> 
> Cc: <stable@vger.kernel.org>
> Cc: Sascha Hauer <s.hauer@pengutronix.de>
> Cc: Kristof Havasi <havasiefr@gmail.com>
> Fixes: 6a98bc4614de ("ubifs: Add authentication nodes to journal")
> Reported-by: Kristof Havasi <havasiefr@gmail.com>
> Signed-off-by: Richard Weinberger <richard@nod.at>

Looked at the code until I understood what the problem is and how it is
fixed, so:

Reviewed-by: Sascha Hauer <s.hauer@pengutronix.de>

Sascha

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
