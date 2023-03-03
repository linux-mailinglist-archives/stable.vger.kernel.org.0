Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38B8B6AA120
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 22:26:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231704AbjCCV04 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 16:26:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231292AbjCCV0z (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 16:26:55 -0500
Received: from mx.ewheeler.net (mx.ewheeler.net [173.205.220.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0672C17156;
        Fri,  3 Mar 2023 13:26:54 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by mx.ewheeler.net (Postfix) with ESMTP id 904A54B;
        Fri,  3 Mar 2023 13:26:54 -0800 (PST)
X-Virus-Scanned: amavisd-new at ewheeler.net
Received: from mx.ewheeler.net ([127.0.0.1])
        by localhost (mx.ewheeler.net [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id oyirRZ1woSgR; Fri,  3 Mar 2023 13:26:53 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.ewheeler.net (Postfix) with ESMTPSA id B785440;
        Fri,  3 Mar 2023 13:26:53 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx.ewheeler.net B785440
Date:   Fri, 3 Mar 2023 13:26:53 -0800 (PST)
From:   Eric Wheeler <stable@lists.ewheeler.net>
To:     stable@vger.kernel.org
cc:     linux-bcache@vger.kernel.org, Coly Li <colyli@suse.de>
Subject: [CHERRY-PICK] bcache: fixes that missed a Cc:
 stable@vger.kernel.org
Message-ID: <81201ca-5263-1b20-8e21-8c88edb552c9@ewheeler.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,HEXHASH_WORD,
        SPF_HELO_NONE,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dear stable tree maintainers: 

Please pick the following commits that should be pulled into stable but 
missed the `Cc` tag to make it happen automatically.

I have checked with Coly, the bcache maintainer, and he agrees that they 
should go into stable:


d55f7cb2e5c0 bcache: fix error info in register_bcache()
7b1002f7cfe5 bcache: fixup bcache_dev_sectors_dirty_add() multithreaded CPU false sharing
a1a2d8f0162b bcache: avoid unnecessary soft lockup in kworker update_writeback_rate()

# NOTICE: These two depend on each other, so apply both or neither!
0259d4498ba4 bcache: move calc_cached_dev_sectors to proper place on backing device detach
aa97f6cdb7e9 bcache: fix NULL pointer reference in cached_dev_detach_finish

Thanks!

--
Eric Wheeler
