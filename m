Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF7E16ECD93
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 15:24:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232067AbjDXNYg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 09:24:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232113AbjDXNYb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 09:24:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 228DD4EE1
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 06:24:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B16E162277
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 13:24:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C736FC433EF;
        Mon, 24 Apr 2023 13:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682342669;
        bh=6fshdmpTvInoVnQjRBQ66SBVadwV04JODMRb0gT0C/U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qeh9ldQ0nrb5zZmuklJQc/yF1E0rUCJzuFl72PtSvLU3jmDvSk1u1npXMHSNEvDCl
         v5zW58F7Uf+hkLJcp66x/c2HmAj8YeFYK1X3DOzVS9Ue0X6MonOb+Mu8fGqx1EG9LS
         ua9BdiMKEFvdMRaLCseAvJfR8tT0A6n1/SHXPx0U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Miguel Ojeda <ojeda@kernel.org>,
        Patrick Blass <patrickblass@mailbox.org>,
        Vincenzo Palazzo <vincenzopalazzodev@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 13/98] rust: str: fix requierments->requirements typo
Date:   Mon, 24 Apr 2023 15:16:36 +0200
Message-Id: <20230424131134.386956205@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131133.829259077@linuxfoundation.org>
References: <20230424131133.829259077@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Patrick Blass <patrickblass@mailbox.org>

[ Upstream commit 88e8c2ec4ab84f9f05ed5af9693a3972baf386c4 ]

Fix a trivial spelling error in the `rust/kernel/str.rs` file.

Fixes: 247b365dc8dc ("rust: add `kernel` crate")
Reported-by: Miguel Ojeda <ojeda@kernel.org>
Link: https://github.com/Rust-for-Linux/linux/issues/978
Signed-off-by: Patrick Blass <patrickblass@mailbox.org>
Reviewed-by: Vincenzo Palazzo <vincenzopalazzodev@gmail.com>
[Reworded slightly]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 rust/kernel/str.rs | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/rust/kernel/str.rs b/rust/kernel/str.rs
index e45ff220ae50f..2c4b4bac28f42 100644
--- a/rust/kernel/str.rs
+++ b/rust/kernel/str.rs
@@ -29,7 +29,7 @@ impl RawFormatter {
     /// If `pos` is less than `end`, then the region between `pos` (inclusive) and `end`
     /// (exclusive) must be valid for writes for the lifetime of the returned [`RawFormatter`].
     pub(crate) unsafe fn from_ptrs(pos: *mut u8, end: *mut u8) -> Self {
-        // INVARIANT: The safety requierments guarantee the type invariants.
+        // INVARIANT: The safety requirements guarantee the type invariants.
         Self {
             beg: pos as _,
             pos: pos as _,
-- 
2.39.2



