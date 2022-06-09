Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEB84544C63
	for <lists+stable@lfdr.de>; Thu,  9 Jun 2022 14:44:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244167AbiFIMoh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Jun 2022 08:44:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343883AbiFIMof (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Jun 2022 08:44:35 -0400
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [217.70.183.201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C982A59B8A
        for <stable@vger.kernel.org>; Thu,  9 Jun 2022 05:44:33 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id A9CDD1BF210;
        Thu,  9 Jun 2022 12:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1654778664;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=F5ZSToeEB4YLYYrt0Hm/nSJBH+HVxSfxNH1oQ0BpYBA=;
        b=X3lE4bYA80dhA8Tjx2zzr4vxS9eWKSv0kf9+Y0lVmwEzPyP308WNYQeZmZnmNAdfj8F3Uu
        jBpNtGMPOnLBAshF5LDSf5RDQR1WZlVLz/jL02iV3f45wz/t2K2Z9F+MecULTxfb7mFS5p
        ZZJgd6RuJodW1MzYJ0luARRy04Vn74OAAZEsYjta4vJggKLbL6R5Ip+LUKcIJRDCnZh2Y8
        D2HWvBASgwvyUzpnu1ldXCnoq3hpMNxTge2VffCzgrCzoR2CfW5nmHy/Ooc3VNXC0+lPDD
        Qv8ed5eKrpLT8aSY/J3+T5YXrH1y9UxsmovY9RY/UwK9udO44msGGEoPDmeSFg==
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Peng Wu <wupeng58@huawei.com>, miquel.raynal@bootlin.com,
        richard@nod.at, vigneshr@ti.com, christophe.jaillet@wanadoo.fr
Cc:     linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, liwei391@huawei.com
Subject: Re: [PATCH v2] mtd: rawnand: cafe: fix drivers probe/remove methods
Date:   Thu,  9 Jun 2022 14:44:23 +0200
Message-Id: <20220609124423.209280-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220520084425.116686-1-wupeng58@huawei.com>
References: 
MIME-Version: 1.0
X-linux-mtd-patch-notification: thanks
X-linux-mtd-patch-commit: b'18178e03b124b0c6be17abbbca914157642f5d7a'
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 2022-05-20 at 08:44:25 UTC, Peng Wu wrote:
> Driver should call pci_disable_device() if it returns from
> cafe_nand_probe() with error.
> 
> Meanwhile, the driver calls pci_enable_device() in
> cafe_nand_probe(), but never calls pci_disable_device()
> during removal.
> 
> Signed-off-by: Peng Wu <wupeng58@huawei.com>

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/mtd/linux.git nand/next, thanks.

Miquel
