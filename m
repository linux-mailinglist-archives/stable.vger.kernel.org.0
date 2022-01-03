Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAF9F48335D
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 15:36:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235475AbiACOgY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 09:36:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235537AbiACOem (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 09:34:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC6A7C08E883;
        Mon,  3 Jan 2022 06:32:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6CBB6B80F02;
        Mon,  3 Jan 2022 14:32:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39FB2C36AF0;
        Mon,  3 Jan 2022 14:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641220363;
        bh=CBCLoL3PlPAkYt2ViNpVsAbTFU6ZPDuvgOtuV9dMTB4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ncPTTL+pVS0phK1vSAMJeBuCVmF8NkRErMp52l+e1qmjL1KBM20VI4miRggSGA5as
         CS0bf4MG15/VsWGL50ntLJ4fA4fbvQA54vyiapy3iVWvUJibXlBGbbhKGQV6oGf03K
         1wCQ/0UG4PGVplHKOFnE/m9A6VACQxBWB0c6dAIs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jianguo Wu <wujianguo@chinatelecom.cn>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 46/73] selftests: net: Fix a typo in udpgro_fwd.sh
Date:   Mon,  3 Jan 2022 15:24:07 +0100
Message-Id: <20220103142058.400875931@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103142056.911344037@linuxfoundation.org>
References: <20220103142056.911344037@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jianguo Wu <wujianguo@chinatelecom.cn>

[ Upstream commit add25d6d6c85f7b6d00a055ee0a4169acf845681 ]

$rvs -> $rcv

Fixes: a062260a9d5f ("selftests: net: add UDP GRO forwarding self-tests")
Signed-off-by: Jianguo Wu <wujianguo@chinatelecom.cn>
Link: https://lore.kernel.org/r/d247d7c8-a03a-0abf-3c71-4006a051d133@163.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/udpgro_fwd.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/udpgro_fwd.sh b/tools/testing/selftests/net/udpgro_fwd.sh
index 7f26591f236b9..6a3985b8cd7f6 100755
--- a/tools/testing/selftests/net/udpgro_fwd.sh
+++ b/tools/testing/selftests/net/udpgro_fwd.sh
@@ -132,7 +132,7 @@ run_test() {
 	local rcv=`ip netns exec $NS_DST $ipt"-save" -c | grep 'dport 8000' | \
 							  sed -e 's/\[//' -e 's/:.*//'`
 	if [ $rcv != $pkts ]; then
-		echo " fail - received $rvs packets, expected $pkts"
+		echo " fail - received $rcv packets, expected $pkts"
 		ret=1
 		return
 	fi
-- 
2.34.1



