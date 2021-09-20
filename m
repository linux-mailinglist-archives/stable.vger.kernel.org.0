Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAD7F411E45
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:29:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347677AbhITR2d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:28:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:56440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347629AbhITR01 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:26:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 56E2561423;
        Mon, 20 Sep 2021 17:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157367;
        bh=YtbVEEC4Fc8VxrXVU+a9hOu8LZW9VwEKLu2s/O2098E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e4lKGSBEHz/oup8++94txBeeXrDekqjJuEjkfcxlNrdS487WMnq3hAWLr2aYUtnu9
         FZ//57vRV8EIubhbvMhrcQfM1gSHl7N5d+uGTCI9D34MsTHIMBgoFAqVnMJRwDIAVF
         q10K8cHNO/BTBKfleuBylK6na82I/Vpa8fMHvnXE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 144/217] bpf/tests: Fix copy-and-paste error in double word test
Date:   Mon, 20 Sep 2021 18:42:45 +0200
Message-Id: <20210920163929.522817050@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163924.591371269@linuxfoundation.org>
References: <20210920163924.591371269@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Almbladh <johan.almbladh@anyfinetworks.com>

[ Upstream commit ae7f47041d928b1a2f28717d095b4153c63cbf6a ]

This test now operates on DW as stated instead of W, which was
already covered by another test.

Signed-off-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20210721104058.3755254-1-johan.almbladh@anyfinetworks.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/test_bpf.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/test_bpf.c b/lib/test_bpf.c
index 75ebf2bbc2ee..4aa88ba8238c 100644
--- a/lib/test_bpf.c
+++ b/lib/test_bpf.c
@@ -4395,8 +4395,8 @@ static struct bpf_test tests[] = {
 		.u.insns_int = {
 			BPF_LD_IMM64(R0, 0),
 			BPF_LD_IMM64(R1, 0xffffffffffffffffLL),
-			BPF_STX_MEM(BPF_W, R10, R1, -40),
-			BPF_LDX_MEM(BPF_W, R0, R10, -40),
+			BPF_STX_MEM(BPF_DW, R10, R1, -40),
+			BPF_LDX_MEM(BPF_DW, R0, R10, -40),
 			BPF_EXIT_INSN(),
 		},
 		INTERNAL,
-- 
2.30.2



