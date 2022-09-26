Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BE475EA5D6
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 14:21:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239422AbiIZMVd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 08:21:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239437AbiIZMU5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 08:20:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C24F5E54A;
        Mon, 26 Sep 2022 04:03:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 468746068C;
        Mon, 26 Sep 2022 10:49:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CD2DC433D6;
        Mon, 26 Sep 2022 10:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664189352;
        bh=4XjvDMY7+JMNNTaZ99vTKWavds7RXyMkidR26fFMFpc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gmHF06wl3JqtTE4Qc5W7PpsZfKxRdlvi0y+z/w2n3jxOM+mJO+ohdi8Et9pcqPS4X
         bLNJ4ucVc7dX22tNxNS3SU8eKFV98SmceRAlsuHCT+Obwr7mRCAPdoKhpuIIiFyw8N
         K5uVouAowlRVSYrqBcs3FKv2RasWAF52h6gc9tTA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangbin Liu <liuhangbin@gmail.com>,
        Petr Machata <petrm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 158/207] selftests: forwarding: add shebang for sch_red.sh
Date:   Mon, 26 Sep 2022 12:12:27 +0200
Message-Id: <20220926100813.726220380@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
References: <20220926100806.522017616@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 83e4b196838d90799a8879e5054a3beecf9ed256 ]

RHEL/Fedora RPM build checks are stricter, and complain when executable
files don't have a shebang line, e.g.

*** WARNING: ./kselftests/net/forwarding/sch_red.sh is executable but has no shebang, removing executable bit

Fix it by adding shebang line.

Fixes: 6cf0291f9517 ("selftests: forwarding: Add a RED test for SW datapath")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Link: https://lore.kernel.org/r/20220922024453.437757-1-liuhangbin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/forwarding/sch_red.sh | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/net/forwarding/sch_red.sh b/tools/testing/selftests/net/forwarding/sch_red.sh
index e714bae473fb..81f31179ac88 100755
--- a/tools/testing/selftests/net/forwarding/sch_red.sh
+++ b/tools/testing/selftests/net/forwarding/sch_red.sh
@@ -1,3 +1,4 @@
+#!/bin/bash
 # SPDX-License-Identifier: GPL-2.0
 
 # This test sends one stream of traffic from H1 through a TBF shaper, to a RED
-- 
2.35.1



