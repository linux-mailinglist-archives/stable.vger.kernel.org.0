Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FC4C6E3AC0
	for <lists+stable@lfdr.de>; Sun, 16 Apr 2023 19:42:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229945AbjDPRmT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Apr 2023 13:42:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229743AbjDPRmJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Apr 2023 13:42:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC2963AAF;
        Sun, 16 Apr 2023 10:42:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CD46160F01;
        Sun, 16 Apr 2023 17:42:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F31BC433EF;
        Sun, 16 Apr 2023 17:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681666923;
        bh=4cI/fvz+aCiUy0YzFsR7PrUxSh+8Wz2r3apdZRrC3mg=;
        h=Date:To:From:Subject:From;
        b=g4tRxHOU42jCDVaWl1Bzw5MZpYvVh0g0ueczCcbabp5wXxe12pxPlAFs7BCQeBqhu
         +BylYNu7J/eOpuN9uRNaN1dHYD81+grFCsRF1hhKRA0dC+knkmqEZ8opm7Z+Hgjss3
         M/JhLXclhu0IutXAe0aNtMeFORktofxlwLjIkt2I=
Date:   Sun, 16 Apr 2023 10:42:02 -0700
To:     mm-commits@vger.kernel.org, yejiajian2018@email.szu.edu.cn,
        stable@vger.kernel.org, steve_chou@pesi.com.tw,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] tools-mm-page_owner_sortc-fix-tgid-output-when-cull=tg-is-used.patch removed from -mm tree
Message-Id: <20230416174203.2F31BC433EF@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: tools/mm/page_owner_sort.c: fix TGID output when cull=tg is used
has been removed from the -mm tree.  Its filename was
     tools-mm-page_owner_sortc-fix-tgid-output-when-cull=tg-is-used.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Steve Chou <steve_chou@pesi.com.tw>
Subject: tools/mm/page_owner_sort.c: fix TGID output when cull=tg is used
Date: Tue, 11 Apr 2023 11:49:28 +0800

When using cull option with 'tg' flag, the fprintf is using pid instead
of tgid. It should use tgid instead.

Link: https://lkml.kernel.org/r/20230411034929.2071501-1-steve_chou@pesi.com.tw
Fixes: 9c8a0a8e599f4a ("tools/vm/page_owner_sort.c: support for user-defined culling rules")
Signed-off-by: Steve Chou <steve_chou@pesi.com.tw>
Cc: Jiajian Ye <yejiajian2018@email.szu.edu.cn>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/mm/page_owner_sort.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/mm/page_owner_sort.c~tools-mm-page_owner_sortc-fix-tgid-output-when-cull=tg-is-used
+++ a/tools/mm/page_owner_sort.c
@@ -857,7 +857,7 @@ int main(int argc, char **argv)
 			if (cull & CULL_PID || filter & FILTER_PID)
 				fprintf(fout, ", PID %d", list[i].pid);
 			if (cull & CULL_TGID || filter & FILTER_TGID)
-				fprintf(fout, ", TGID %d", list[i].pid);
+				fprintf(fout, ", TGID %d", list[i].tgid);
 			if (cull & CULL_COMM || filter & FILTER_COMM)
 				fprintf(fout, ", task_comm_name: %s", list[i].comm);
 			if (cull & CULL_ALLOCATOR) {
_

Patches currently in -mm which might be from steve_chou@pesi.com.tw are


