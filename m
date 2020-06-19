Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A805E200FC7
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:23:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392924AbgFSPVz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:21:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:53176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392918AbgFSPVw (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:21:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D62CD20B80;
        Fri, 19 Jun 2020 15:21:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592580111;
        bh=7qRrtypSSmzWLdDkp9783c/owwEwmGd/9SP07NiOk2s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FgnfSlDsfS3ie+KQ0oYwGbTIb2+56AI8w9tQWHFRjXNjEZg7B4RETT+5UB853CqpQ
         WYtXap2FkAU22GQc7aqAY0y4NU+XYZBb4SsM9g3cqvbuZHS/TF8kLLnt5tHl52EOuv
         pKO+4lhZU9grg0IZO4eoiYnlXzMCkp1JH1b2ABBQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Veronika Kabatova <vkabatov@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 127/376] selftests/bpf: Add runqslower binary to .gitignore
Date:   Fri, 19 Jun 2020 16:30:45 +0200
Message-Id: <20200619141716.348158220@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrii Nakryiko <andriin@fb.com>

[ Upstream commit e4e8f4d047fdcf7ac7d944e266e85d8041f16cd6 ]

With recent changes, runqslower is being copied into selftests/bpf root
directory. So add it into .gitignore.

Fixes: b26d1e2b6028 ("selftests/bpf: Copy runqslower to OUTPUT directory")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Cc: Veronika Kabatova <vkabatov@redhat.com>
Link: https://lore.kernel.org/bpf/20200429012111.277390-12-andriin@fb.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/.gitignore | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/.gitignore b/tools/testing/selftests/bpf/.gitignore
index c30079c86998..35a577ca0226 100644
--- a/tools/testing/selftests/bpf/.gitignore
+++ b/tools/testing/selftests/bpf/.gitignore
@@ -39,4 +39,4 @@ test_cpp
 /no_alu32
 /bpf_gcc
 /tools
-
+/runqslower
-- 
2.25.1



