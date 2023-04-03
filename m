Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1704D6D4CEC
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 17:59:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233041AbjDCP7i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 11:59:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232960AbjDCP7a (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 11:59:30 -0400
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::227])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 317D82D63;
        Mon,  3 Apr 2023 08:59:20 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id B977220005;
        Mon,  3 Apr 2023 15:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1680537558;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mz4VHGXz6DS1YgoT5sffndIrCMbK1I9V2lRSBl4Rl/8=;
        b=FDaIT0gY7prNMxDiZ5XpwX2vX+R724wNbtq5lBzGawcDsjFAIm3noHaiBmFyEczsbTo0cy
        Or9jsPVom4iDkSbnxVTVwQBQOm5fPzaDhVw2LJxRVjv7YGjpjAGHBf+iXEYtGsdRC+9I0w
        UiJC8mTkpr/AxetoJr2mwzzsef02hu72P19FvxLwXmG8lqNK1IvC+9grejJWZ9eurUeevS
        qYfxM/5wZ4g9Xq3P1yjeiEYsNroAM24M7kwu+Y0/cwEMzzRHnkdedW3HuUtHgy1GrXbpNX
        k/XdS3dcygnI47pi+5HHYeUGNqDPfEy9c4U7dz54Y4CeDlBjCMcxneeRi8WwsA==
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Bang Li <libang.linuxer@gmail.com>, miquel.raynal@bootlin.com,
        richard@nod.at, vigneshr@ti.com
Cc:     linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] mtdblock: tolerate corrected bit-flips
Date:   Mon,  3 Apr 2023 17:59:16 +0200
Message-Id: <20230403155917.137591-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230328163012.4264-1-libang.linuxer@gmail.com>
References: 
MIME-Version: 1.0
X-linux-mtd-patch-notification: thanks
X-linux-mtd-patch-commit: b'0c3089601f064d80b3838eceb711fcac04bceaad'
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2023-03-28 at 16:30:12 UTC, Bang Li wrote:
> mtd_read() may return -EUCLEAN in case of corrected bit-flips.This
> particular condition should not be treated like an error.
> 
> Signed-off-by: Bang Li <libang.linuxer@gmail.com>
> Fixes: e47f68587b82 ("mtd: check for max_bitflips in mtd_read_oob()")
> Cc: <stable@vger.kernel.org> # v3.7
> Acked-by: Richard Weinberger <richard@nod.at>

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/mtd/linux.git mtd/fixes, thanks.

Miquel
