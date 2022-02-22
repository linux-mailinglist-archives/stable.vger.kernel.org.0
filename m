Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B94924BF032
	for <lists+stable@lfdr.de>; Tue, 22 Feb 2022 05:10:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239704AbiBVDb6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 22:31:58 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230249AbiBVDb5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 22:31:57 -0500
Received: from eu-shark1.inbox.eu (eu-shark1.inbox.eu [195.216.236.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E2221CFC9;
        Mon, 21 Feb 2022 19:31:31 -0800 (PST)
Received: from eu-shark1.inbox.eu (localhost [127.0.0.1])
        by eu-shark1-out.inbox.eu (Postfix) with ESMTP id 152E36C006A5;
        Tue, 22 Feb 2022 05:31:30 +0200 (EET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=inbox.eu; s=20140211;
        t=1645500690; bh=gHEc7msTYbNxZ/VBoa/NT7YaOCMo7F0D9O09MSSjdq4=;
        h=From:To:Cc:Subject:Date:Message-Id:X-ESPOL:from:date:to:cc;
        b=NwTqHtibXNvOVS2tvKNHLs3Xm+cnySWdB2kJVxIzhU7c8kuIVcnfdbN28oH/JAK+k
         qdpUfM4OXw56a5XmEN83xumNhj4qoXW10dgB63BriNuxkG073+ad4JvC4udOXoTMar
         VYCoSTi+gMyY+nZxf52p3onj+Uc8XXVD0ykwBclY=
Received: from localhost (localhost [127.0.0.1])
        by eu-shark1-in.inbox.eu (Postfix) with ESMTP id 055106C0061C;
        Tue, 22 Feb 2022 05:31:30 +0200 (EET)
Received: from eu-shark1.inbox.eu ([127.0.0.1])
        by localhost (eu-shark1.inbox.eu [127.0.0.1]) (spamfilter, port 35)
        with ESMTP id 4lzCFhGa44Pj; Tue, 22 Feb 2022 05:31:29 +0200 (EET)
Received: from mail.inbox.eu (eu-pop1 [127.0.0.1])
        by eu-shark1-in.inbox.eu (Postfix) with ESMTP id D43BD6C00504;
        Tue, 22 Feb 2022 05:31:29 +0200 (EET)
From:   Su Yue <l@damenly.su>
To:     stable@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, Su Yue <l@damenly.su>
Subject: [PATCH stable 5.10.y 0/2] backport two patches to avoid invalid memory access while mounting btrfs crafted image
Date:   Tue, 22 Feb 2022 11:31:15 +0800
Message-Id: <20220222033117.1421286-1-l@damenly.su>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: OK
X-ESPOL: 6N1ml5YsbjOljF6gQXPdBAIxs1k6UZeF55TE3V0G3GeDUSOFfksTURS1g21yTGK6vjYX
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Due to btrfs_item* helpers name changes in v5.17-rc1, here are two manual
backport patches. Already verified by running fstests. 

Su Yue (2):
  btrfs: tree-checker: check item_size for inode_item
  btrfs: tree-checker: check item_size for dev_item

 fs/btrfs/tree-checker.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

-- 
2.34.1

