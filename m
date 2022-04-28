Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13C7B512E1A
	for <lists+stable@lfdr.de>; Thu, 28 Apr 2022 10:19:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344014AbiD1IW2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Apr 2022 04:22:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344076AbiD1IWI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Apr 2022 04:22:08 -0400
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::223])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95078A0BE7
        for <stable@vger.kernel.org>; Thu, 28 Apr 2022 01:18:51 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 6D05E60008;
        Thu, 28 Apr 2022 08:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1651133928;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1r9Gw8bxccInDnBs9TnvRjWw+P42AgdF7L9BUI3UsGs=;
        b=kDuTP9QnyvZav/4/uS7hUm/ffzzCLM9ACOx8ZaTpbKhEdVMf6QSSwpUzB4Pam6UNFbRFxW
        9TzO2wLNLa6gP5b+kPekYlI5xlhXP98Ta5EbJcq3T59E7Gj8EGcoTu+CuC3N4deDa1aGzC
        wwUonJZ6whugjip/AJcwjN8kDx+WBR8OGSo34ilMTXWvh3L5Ek89592/8JtdUZkLlHY3vC
        dUEG+ZIjrKWb/CY+rzcaj1jYLE2i/K/OgqGEeIlaPjcJ5gkzkyTAKeFJrQHD/Z1RzvzbyC
        W1a5gfd7YOF0FVRCTXA6BdgJM6GU3WBbAPtEdRxxzebVW52EcvKPayV0wBNFnw==
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Tokunori Ikegami <ikegami.t@gmail.com>, miquel.raynal@bootlin.com
Cc:     richard@nod.at, vigneshr@ti.com, linux-mtd@lists.infradead.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v7 1/4] mtd: cfi_cmdset_0002: Move and rename chip_check/chip_ready/chip_good_for_write
Date:   Thu, 28 Apr 2022 10:18:46 +0200
Message-Id: <20220428081846.120148-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220323170458.5608-2-ikegami.t@gmail.com>
References: 
MIME-Version: 1.0
X-linux-mtd-patch-notification: thanks
X-linux-mtd-patch-commit: b'083084df578a8bdb18334f69e7b32d690aaa3247'
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 2022-03-23 at 17:04:55 UTC, Tokunori Ikegami wrote:
> This is a preparation patch for the S29GL064N buffer writes fix. There
> is no functional change.
> 
> Fixes: dfeae1073583("mtd: cfi_cmdset_0002: Change write buffer to check correct value")
> Signed-off-by: Tokunori Ikegami <ikegami.t@gmail.com>
> Cc: stable@vger.kernel.org
> Link: https://lore.kernel.org/r/b687c259-6413-26c9-d4c9-b3afa69ea124@pengutronix.de/

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/mtd/linux.git mtd/next, thanks.

Miquel
