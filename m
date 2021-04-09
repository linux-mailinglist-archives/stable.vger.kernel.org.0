Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9820B359B39
	for <lists+stable@lfdr.de>; Fri,  9 Apr 2021 12:07:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234398AbhDIKH4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 06:07:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:51394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234355AbhDIKGE (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Apr 2021 06:06:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 47C0161367;
        Fri,  9 Apr 2021 10:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617962532;
        bh=hmIcV6g2nTUsEzZimcA6GiCe/NcKeNtvL1AKwwHtmtQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wAQrduhBSO7YSMWGYGMDVVXgbm1AQxyxvP101T0j9rDzTHssMsvVcB5zHHN0J3Gck
         S35CL0ZGxaTZ5JA/JDF9Z6J+YCwynR1mhS82reeGJiOXJV5hwMO5+mjMH1P5nYAG6m
         MSQot5VRHvConfztpGMIkkFXPe2Va0UyaZfDxGkQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stanislav Fomichev <sdf@google.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 42/45] tools/resolve_btfids: Add /libbpf to .gitignore
Date:   Fri,  9 Apr 2021 11:54:08 +0200
Message-Id: <20210409095306.768870295@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210409095305.397149021@linuxfoundation.org>
References: <20210409095305.397149021@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stanislav Fomichev <sdf@google.com>

[ Upstream commit 90a82b1fa40d0cee33d1c9306dc54412442d1e57 ]

This is what I see after compiling the kernel:

 # bpf-next...bpf-next/master
 ?? tools/bpf/resolve_btfids/libbpf/

Fixes: fc6b48f692f8 ("tools/resolve_btfids: Build libbpf and libsubcmd in separate directories")
Signed-off-by: Stanislav Fomichev <sdf@google.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20210212010053.668700-1-sdf@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/resolve_btfids/.gitignore | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/bpf/resolve_btfids/.gitignore b/tools/bpf/resolve_btfids/.gitignore
index 25f308c933cc..16913fffc985 100644
--- a/tools/bpf/resolve_btfids/.gitignore
+++ b/tools/bpf/resolve_btfids/.gitignore
@@ -1,2 +1,3 @@
 /fixdep
 /resolve_btfids
+/libbpf/
-- 
2.30.2



