Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BC22201185
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:47:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393491AbgFSP0b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:26:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:58190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404311AbgFSP01 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:26:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1493221556;
        Fri, 19 Jun 2020 15:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592580386;
        bh=H41nqotO2pzomHP53p6h5JZJ/pOdapmKqlagWJkG6tY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yQDzG0mp1Cwlkv+jWTO7MUWUu4O9UMYAio3qT2FGPtxpYkCpcAsRRF4IxliPnMY9c
         G4UVP0avLB8HLZ24pm+WvTvFfudZJ+9pXq4nx/buNw7jVM/6zc9b+N44J8H48ktrHY
         of0xwPF2XiQ8Ope1kuOGMPmNPvCeuiLYRLyT/JPU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Maguire <alan.maguire@oracle.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 212/376] selftests/bpf: CONFIG_LIRC required for test_lirc_mode2.sh
Date:   Fri, 19 Jun 2020 16:32:10 +0200
Message-Id: <20200619141720.369800256@linuxfoundation.org>
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

From: Alan Maguire <alan.maguire@oracle.com>

[ Upstream commit a5dfaa2ab94057dd75c7911143482a0a85593c14 ]

test_lirc_mode2.sh assumes presence of /sys/class/rc/rc0/lirc*/uevent
which will not be present unless CONFIG_LIRC=y

Fixes: 6bdd533cee9a ("bpf: add selftest for lirc_mode2 type program")
Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/1590147389-26482-3-git-send-email-alan.maguire@oracle.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/config | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/bpf/config b/tools/testing/selftests/bpf/config
index 48e058552eb7..2118e23ac07a 100644
--- a/tools/testing/selftests/bpf/config
+++ b/tools/testing/selftests/bpf/config
@@ -38,3 +38,4 @@ CONFIG_IPV6_SIT=m
 CONFIG_BPF_JIT=y
 CONFIG_BPF_LSM=y
 CONFIG_SECURITY=y
+CONFIG_LIRC=y
-- 
2.25.1



