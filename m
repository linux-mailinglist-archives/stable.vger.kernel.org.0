Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ECD14A441F
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:26:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349910AbiAaL0Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:26:25 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:56670 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377686AbiAaLYR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:24:17 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D05526128E;
        Mon, 31 Jan 2022 11:24:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B19F6C340E8;
        Mon, 31 Jan 2022 11:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643628256;
        bh=gMokifr424n8gOCj7/t5riyyYpeh47ApsxIcacPW/uM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vc01Cy21Q+f/VPEdISOeOiGGGnVAqr6NH4/mnvVnEHRBwThxZPOVC6soO2gBs4s1e
         vJ8rOxoJ8vFlkuq8CzYZXBBRHkCqImClqnygH1dBd2W9vimXTAmdbhk6UvN5CRgLSA
         Im9+HQB59KhjRdxg0KvpNDCnhKsaiKiZ5LuPno/o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Matlack <dmatlack@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 175/200] KVM: selftests: Re-enable access_tracking_perf_test
Date:   Mon, 31 Jan 2022 11:57:18 +0100
Message-Id: <20220131105239.432242169@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105233.561926043@linuxfoundation.org>
References: <20220131105233.561926043@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Matlack <dmatlack@google.com>

[ Upstream commit de1956f48543e90f94b1194395f33140898b39b2 ]

This selftest was accidentally removed by commit 6a58150859fd
("selftest: KVM: Add intra host migration tests"). Add it back.

Fixes: 6a58150859fd ("selftest: KVM: Add intra host migration tests")
Signed-off-by: David Matlack <dmatlack@google.com>
Message-Id: <20220120003826.2805036-1-dmatlack@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/kvm/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 290b1b0552d6e..4fdfb42aeddba 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -77,6 +77,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/xen_shinfo_test
 TEST_GEN_PROGS_x86_64 += x86_64/xen_vmcall_test
 TEST_GEN_PROGS_x86_64 += x86_64/vmx_pi_mmio_test
 TEST_GEN_PROGS_x86_64 += x86_64/sev_migrate_tests
+TEST_GEN_PROGS_x86_64 += access_tracking_perf_test
 TEST_GEN_PROGS_x86_64 += demand_paging_test
 TEST_GEN_PROGS_x86_64 += dirty_log_test
 TEST_GEN_PROGS_x86_64 += dirty_log_perf_test
-- 
2.34.1



