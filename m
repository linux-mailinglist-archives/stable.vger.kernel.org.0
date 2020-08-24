Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9AC324FA35
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 11:54:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728461AbgHXIhu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 04:37:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:51562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728462AbgHXIht (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:37:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DEB5D207DF;
        Mon, 24 Aug 2020 08:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598258268;
        bh=XE6fwogygd3BtBfbN9VKJdPsGRATYwsuEUX0wNk/Ebk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wlDprk3NlZ0gZFRHFkcpovq8hw+HN8IvH1V4vuL4MGmJC3aRnZPBzVPEcLrh+l2lp
         gYHRkL/6aMXsmM6IuNONQElWTZNBYGUe9lITgX0V3kgBMx4w8JxZinaJXp/1b5LoPW
         jVF7/evL2VmXgnSNKr0eTIbfcGtf2cz1XnROvePo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Veronika Kabatova <vkabatov@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 136/148] selftests/bpf: Remove test_align leftovers
Date:   Mon, 24 Aug 2020 10:30:34 +0200
Message-Id: <20200824082420.533918870@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082413.900489417@linuxfoundation.org>
References: <20200824082413.900489417@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Veronika Kabatova <vkabatov@redhat.com>

[ Upstream commit 5597432dde62befd3ab92e6ef9e073564e277ea8 ]

Calling generic selftests "make install" fails as rsync expects all
files from TEST_GEN_PROGS to be present. The binary is not generated
anymore (commit 3b09d27cc93d) so we can safely remove it from there
and also from gitignore.

Fixes: 3b09d27cc93d ("selftests/bpf: Move test_align under test_progs")
Signed-off-by: Veronika Kabatova <vkabatov@redhat.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
Link: https://lore.kernel.org/bpf/20200819160710.1345956-1-vkabatov@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/.gitignore | 1 -
 tools/testing/selftests/bpf/Makefile   | 2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/.gitignore b/tools/testing/selftests/bpf/.gitignore
index 1bb204cee853f..9a0946ddb705a 100644
--- a/tools/testing/selftests/bpf/.gitignore
+++ b/tools/testing/selftests/bpf/.gitignore
@@ -6,7 +6,6 @@ test_lpm_map
 test_tag
 FEATURE-DUMP.libbpf
 fixdep
-test_align
 test_dev_cgroup
 /test_progs*
 test_tcpbpf_user
diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 4f322d5388757..50965cc7bf098 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -32,7 +32,7 @@ LDLIBS += -lcap -lelf -lz -lrt -lpthread
 
 # Order correspond to 'make run_tests' order
 TEST_GEN_PROGS = test_verifier test_tag test_maps test_lru_map test_lpm_map test_progs \
-	test_align test_verifier_log test_dev_cgroup test_tcpbpf_user \
+	test_verifier_log test_dev_cgroup test_tcpbpf_user \
 	test_sock test_btf test_sockmap get_cgroup_id_user test_socket_cookie \
 	test_cgroup_storage \
 	test_netcnt test_tcpnotify_user test_sock_fields test_sysctl \
-- 
2.25.1



