Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E580F469DCF
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:34:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358823AbhLFPdM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:33:12 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:45726 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237886AbhLFP2V (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:28:21 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4C44D6132C;
        Mon,  6 Dec 2021 15:24:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34532C34901;
        Mon,  6 Dec 2021 15:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804291;
        bh=K2bL7SEGCCkKp1tj6X6eOD8GLru1vr4CGyZB7K1NezQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QVM//qzDSoQi3fStnzVVVh0uh7nFa14MPNlaxTui2pl3dHujPER656yqt8OMVJD0x
         3brVTbgz8n97GUeMEvaC4V2CuuQ6+2zcPH8zPtPghpN6PXKWtaaSQ59PFH8OXzj8TQ
         KSgYWJj0X2f8qj5WFvV75SZi9zWCosOXrF2/TJo4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Li Zhijian <lizhijian@cn.fujitsu.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 094/207] wireguard: selftests: rename DEBUG_PI_LIST to DEBUG_PLIST
Date:   Mon,  6 Dec 2021 15:55:48 +0100
Message-Id: <20211206145613.487313316@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
References: <20211206145610.172203682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Li Zhijian <lizhijian@cn.fujitsu.com>

commit 7e938beb8321d34f040557b8915b228af125f73c upstream.

DEBUG_PI_LIST was renamed to DEBUG_PLIST since 8e18faeac3 ("lib/plist:
rename DEBUG_PI_LIST to DEBUG_PLIST").

Signed-off-by: Li Zhijian <lizhijian@cn.fujitsu.com>
Fixes: 8e18faeac3e4 ("lib/plist: rename DEBUG_PI_LIST to DEBUG_PLIST")
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/wireguard/qemu/debug.config |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/wireguard/qemu/debug.config
+++ b/tools/testing/selftests/wireguard/qemu/debug.config
@@ -47,7 +47,7 @@ CONFIG_DEBUG_ATOMIC_SLEEP=y
 CONFIG_TRACE_IRQFLAGS=y
 CONFIG_DEBUG_BUGVERBOSE=y
 CONFIG_DEBUG_LIST=y
-CONFIG_DEBUG_PI_LIST=y
+CONFIG_DEBUG_PLIST=y
 CONFIG_PROVE_RCU=y
 CONFIG_SPARSE_RCU_POINTER=y
 CONFIG_RCU_CPU_STALL_TIMEOUT=21


