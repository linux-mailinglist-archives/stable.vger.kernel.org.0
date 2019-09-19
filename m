Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55F82B873A
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 00:35:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393423AbfISWI1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 18:08:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:46368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393418AbfISWI0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 18:08:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 452E321927;
        Thu, 19 Sep 2019 22:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568930905;
        bh=zPGuwjDYDiMDQS1Q5oFy7DwqvLOrtR8i3MQgAW0T9QA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JId8Wjvo73JVXzlrF256AUi7DDUuo8bdYDHE1B/DuWUedOgsrVH44O6xIjxd43Fjk
         cnFcCM1U5POnBBx0FlpOrz0cjqiQtC2sS84rb2aMcf5v4UXb2VwtC+Uma1cv2MQfb/
         RevbyzCMe2KLSirobilff6LnruaZh64ZkFZ7oVww=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anders Roxell <anders.roxell@linaro.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 057/124] selftests/bpf: add config fragment BPF_JIT
Date:   Fri, 20 Sep 2019 00:02:25 +0200
Message-Id: <20190919214821.075146918@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190919214819.198419517@linuxfoundation.org>
References: <20190919214819.198419517@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anders Roxell <anders.roxell@linaro.org>

[ Upstream commit 0604409df9e04cdec7b08d471c8c1c0c10b5554d ]

When running test_kmod.sh the following shows up

 # sysctl cannot stat /proc/sys/net/core/bpf_jit_enable No such file or directory
 cannot: stat_/proc/sys/net/core/bpf_jit_enable #
 # sysctl cannot stat /proc/sys/net/core/bpf_jit_harden No such file or directory
 cannot: stat_/proc/sys/net/core/bpf_jit_harden #

Rework to enable CONFIG_BPF_JIT to solve "No such file or directory"

Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/config | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/bpf/config b/tools/testing/selftests/bpf/config
index f7a0744db31e1..5dc109f4c0970 100644
--- a/tools/testing/selftests/bpf/config
+++ b/tools/testing/selftests/bpf/config
@@ -34,3 +34,4 @@ CONFIG_NET_MPLS_GSO=m
 CONFIG_MPLS_ROUTING=m
 CONFIG_MPLS_IPTUNNEL=m
 CONFIG_IPV6_SIT=m
+CONFIG_BPF_JIT=y
-- 
2.20.1



