Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47BF84F3AA0
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 17:03:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381620AbiDELqj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:46:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354206AbiDEKMP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:12:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D3B054BC3;
        Tue,  5 Apr 2022 02:58:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 43267B817D3;
        Tue,  5 Apr 2022 09:58:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAF06C385A2;
        Tue,  5 Apr 2022 09:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649152719;
        bh=QvVBerDKdoCVfQK/+ujmnOE/1XqAbYOn7pRFuVZg8nk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pf31a6kOcM3IjMNmdEGZR29P17fY229pkxC26NUipHk9JNLiNGHgPH+F4rB+6jKpI
         VpWK55/s9eeRSICj0qNLz/+9W1z7ogB/fVIYjYVQgh9gzm6Z8oDsRvI24fOXoJvgnp
         pU88W307X0WCSVTjtMlJrTyPA/imgNTH3w2bw8pI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hengqi Chen <hengqi.chen@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>
Subject: [PATCH 5.15 879/913] bpf: Fix comment for helper bpf_current_task_under_cgroup()
Date:   Tue,  5 Apr 2022 09:32:21 +0200
Message-Id: <20220405070406.171460911@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Hengqi Chen <hengqi.chen@gmail.com>

commit 58617014405ad5c9f94f464444f4972dabb71ca7 upstream.

Fix the descriptions of the return values of helper bpf_current_task_under_cgroup().

Fixes: c6b5fb8690fa ("bpf: add documentation for eBPF helpers (42-50)")
Signed-off-by: Hengqi Chen <hengqi.chen@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Yonghong Song <yhs@fb.com>
Link: https://lore.kernel.org/bpf/20220310155335.1278783-1-hengqi.chen@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/uapi/linux/bpf.h       |    4 ++--
 tools/include/uapi/linux/bpf.h |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -2276,8 +2276,8 @@ union bpf_attr {
  * 	Return
  * 		The return value depends on the result of the test, and can be:
  *
- *		* 0, if current task belongs to the cgroup2.
- *		* 1, if current task does not belong to the cgroup2.
+ *		* 1, if current task belongs to the cgroup2.
+ *		* 0, if current task does not belong to the cgroup2.
  * 		* A negative error code, if an error occurred.
  *
  * long bpf_skb_change_tail(struct sk_buff *skb, u32 len, u64 flags)
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -2276,8 +2276,8 @@ union bpf_attr {
  * 	Return
  * 		The return value depends on the result of the test, and can be:
  *
- *		* 0, if current task belongs to the cgroup2.
- *		* 1, if current task does not belong to the cgroup2.
+ *		* 1, if current task belongs to the cgroup2.
+ *		* 0, if current task does not belong to the cgroup2.
  * 		* A negative error code, if an error occurred.
  *
  * long bpf_skb_change_tail(struct sk_buff *skb, u32 len, u64 flags)


