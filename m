Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2195A55DE57
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:29:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235917AbiF1Iti (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jun 2022 04:49:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbiF1Iti (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jun 2022 04:49:38 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5142B2EA37
        for <stable@vger.kernel.org>; Tue, 28 Jun 2022 01:49:37 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 0CBFD21D44;
        Tue, 28 Jun 2022 08:49:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1656406176; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=pe8jvmdOgchmFKvfxBome+wG4GN8qbsZHgsZ1ldjbfI=;
        b=EPdK30KjwvJa7EF6WWstH3Vtysy4dF2X+Ujr7fGnWzkPPocMxgEggdG2vsOr43+OPaGdc8
        EA+dESyNlvcEU+vgUJzsnXOai500vCsk+zSJ+MOCwkoc0g12E3lC4ND5s8xJ6j+Yc3I6d7
        BmYASigoEPOkJHzsMsUnah0PkIO2Me0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1656406176;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=pe8jvmdOgchmFKvfxBome+wG4GN8qbsZHgsZ1ldjbfI=;
        b=I3eotqDNH98n5TIv/NAsZhkg9ZkqTqcGgoMfpKzUfWJ+kfuN13xUtJwXpKEcmEgOLCmYes
        irJXPxCv7lKtolDw==
Received: from localhost.localdomain (unknown [10.163.16.22])
        by relay2.suse.de (Postfix) with ESMTP id F3C3A2C141;
        Tue, 28 Jun 2022 08:49:34 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org
Subject: [PATCH 0/1] one bcache patch for stable tree
Date:   Tue, 28 Jun 2022 16:49:32 +0800
Message-Id: <20220628084933.8713-1-colyli@suse.de>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

This is a bcache patch upstreamed in Linux v5.19, it fixes the
undefined stack state which I feel it should go into stable tree
as well.

I go through all the stable releases since Linux v5.10, based on current
stable tree maintenance status, this patch should be applied to the
following stable kernel releases,
- longterm: 5.10, 5.15
- 5.17, 5.18  

Please consider to take it for the above stable kernels.
Thank you in advance for taking care of them.

Coly Li
---

Coly Li (1):
  bcache: memset on stack variables in bch_btree_check() and
    bch_sectors_dirty_init()

 drivers/md/bcache/btree.c     | 1 +
 drivers/md/bcache/writeback.c | 1 +
 2 files changed, 2 insertions(+)

-- 
2.35.3

