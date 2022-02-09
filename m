Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 622B44AEC72
	for <lists+stable@lfdr.de>; Wed,  9 Feb 2022 09:33:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241319AbiBIIdD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 03:33:03 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:44208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239606AbiBIIc5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 03:32:57 -0500
Received: from relay9-d.mail.gandi.net (relay9-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1170FC05CBB6;
        Wed,  9 Feb 2022 00:33:00 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 167D8FF809;
        Wed,  9 Feb 2022 08:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1644395578;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4rPFnHcHVlSSnZKzRu4Ncl2lMwdWWlcor8ub3qfc+CA=;
        b=eCsL4raikSTCbREvwu6DyH51SUIv+uIGRTH7jZTvAoWM2toO/5/8rygsyojvQrZOmUWaBw
        QUgRsA/1oZll5nGYTx6dccW1oUiclDIb5t7E0oQ05uxbKxXIIasdeYtjF8TZI4Rd6nFIF5
        dr1MhEGAXQLlJigxSTobxvckdwgIlcJ5vqplBoXbapN+WUDzU3vcWRj27CrcPkyy8jlUGH
        Y8DKKiOZckDM5Wmll1pbGcBpxYuU2znWjQR6mgapk6hMXRABm9uEZPLejoKyCVbYdAXzHD
        R3nkd10YtPcXJhJXz1tQYubIjJuZG71vzZEb5ySYvJfn0NE5ePo8LMbLWbTMEA==
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Sean Nyekjaer <sean@geanix.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Boris Brezillon <bbrezillon@kernel.org>
Cc:     Boris Brezillon <boris.brezillon@collabora.com>,
        stable@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] mtd: rawnand: protect access to rawnand devices while in suspend
Date:   Wed,  9 Feb 2022 09:32:56 +0100
Message-Id: <20220209083256.749170-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220208085213.1838273-1-sean@geanix.com>
References: 
MIME-Version: 1.0
X-linux-mtd-patch-notification: thanks
X-linux-mtd-patch-commit: b'8cba323437a49a45756d661f500b324fc2d486fe'
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2022-02-08 at 08:52:13 UTC, Sean Nyekjaer wrote:
> Prevent rawnand access while in a suspended state.
> 
> Commit 013e6292aaf5 ("mtd: rawnand: Simplify the locking") allows the
> rawnand layer to return errors rather than waiting in a blocking wait.
> 
> Tested on a iMX6ULL.
> 
> Fixes: 013e6292aaf5 ("mtd: rawnand: Simplify the locking")
> Signed-off-by: Sean Nyekjaer <sean@geanix.com>
> Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
> Cc: stable@vger.kernel.org

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/mtd/linux.git nand/next, thanks.

Miquel
