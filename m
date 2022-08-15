Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5509593F6E
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:45:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232356AbiHOVJ6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:09:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347993AbiHOVHx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:07:53 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 493C52AE3E;
        Mon, 15 Aug 2022 12:17:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B0ACDCE12C7;
        Mon, 15 Aug 2022 19:17:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 894DCC433C1;
        Mon, 15 Aug 2022 19:17:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591043;
        bh=eZUb+aQMNbV6lZHdXecjaoF0a6s0C00ln2UItW2hTY0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RiCP3ANDcwOSUs6JxbuEuN1unIXAu/bdpIYyrFxo+RtHeoWAzHRvW06+VA52TBtVX
         fOUHOc49l8gUOC4x5JAwnBHJlzrwuuOw3Tpz8W13+9yjtbmnOhO+lAb9VeuT+VuBwU
         1FmySetzoaBrfTg16vwlxgzQS+HczXIeOpZ/KsvA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Milan Landaverde <milan@mdaverde.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0453/1095] bpftool: Add missing link types
Date:   Mon, 15 Aug 2022 19:57:32 +0200
Message-Id: <20220815180448.362288232@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Milan Landaverde <milan@mdaverde.com>

[ Upstream commit fff3dfab17866f6ac5c5666839f6132b6c52f306 ]

Will display the link type names in bpftool link show output

Signed-off-by: Milan Landaverde <milan@mdaverde.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20220331154555.422506-3-milan@mdaverde.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/link.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/bpf/bpftool/link.c b/tools/bpf/bpftool/link.c
index 97dec81950e5..8fb0116f9136 100644
--- a/tools/bpf/bpftool/link.c
+++ b/tools/bpf/bpftool/link.c
@@ -20,6 +20,9 @@ static const char * const link_type_name[] = {
 	[BPF_LINK_TYPE_CGROUP]			= "cgroup",
 	[BPF_LINK_TYPE_ITER]			= "iter",
 	[BPF_LINK_TYPE_NETNS]			= "netns",
+	[BPF_LINK_TYPE_XDP]			= "xdp",
+	[BPF_LINK_TYPE_PERF_EVENT]		= "perf_event",
+	[BPF_LINK_TYPE_KPROBE_MULTI]		= "kprobe_multi",
 };
 
 static struct hashmap *link_table;
-- 
2.35.1



