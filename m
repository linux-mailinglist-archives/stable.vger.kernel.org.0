Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79ADC408F2C
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:40:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242478AbhIMNkP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:40:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:37748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240553AbhIMNiV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:38:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 04FAD61103;
        Mon, 13 Sep 2021 13:28:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539706;
        bh=EPQOh9AUi631HF9hkHOnIKTLvUSuL/KsF7eC+n6GvEc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=10dOtqS5lYE8+uI2zroZKaOCRNX2+rSPkiCz8H9+J0SGSVZmIj7BAoRC0TkwrAmsS
         qcUds7tzsgWB+LdywjCGDEOwW9ttwM5moys4Q15eZGyQlZYlYTn+cBiglkmcUMk31M
         M4qv9gJBImzLFYV88NLUNjIuWXgrmK8dvbHECu4I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Matthew Cover <matthew.cover@stackpath.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 127/236] bpf, samples: Add missing mprog-disable to xdp_redirect_cpus optstring
Date:   Mon, 13 Sep 2021 15:13:52 +0200
Message-Id: <20210913131104.683464740@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131100.316353015@linuxfoundation.org>
References: <20210913131100.316353015@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthew Cover <werekraken@gmail.com>

[ Upstream commit 34ad6d9d8c27293e1895b448af7d6cf5d351ad8d ]

Commit ce4dade7f12a ("samples/bpf: xdp_redirect_cpu: Load a eBPF program
on cpumap") added the following option, but missed adding it to optstring:

  - mprog-disable: disable loading XDP program on cpumap entries

Fix it and add the missing option character.

Fixes: ce4dade7f12a ("samples/bpf: xdp_redirect_cpu: Load a eBPF program on cpumap")
Signed-off-by: Matthew Cover <matthew.cover@stackpath.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20210731005632.13228-1-matthew.cover@stackpath.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 samples/bpf/xdp_redirect_cpu_user.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/samples/bpf/xdp_redirect_cpu_user.c b/samples/bpf/xdp_redirect_cpu_user.c
index f78cb18319aa..16eb839e71f0 100644
--- a/samples/bpf/xdp_redirect_cpu_user.c
+++ b/samples/bpf/xdp_redirect_cpu_user.c
@@ -837,7 +837,7 @@ int main(int argc, char **argv)
 	memset(cpu, 0, n_cpus * sizeof(int));
 
 	/* Parse commands line args */
-	while ((opt = getopt_long(argc, argv, "hSd:s:p:q:c:xzFf:e:r:m:",
+	while ((opt = getopt_long(argc, argv, "hSd:s:p:q:c:xzFf:e:r:m:n",
 				  long_options, &longindex)) != -1) {
 		switch (opt) {
 		case 'd':
-- 
2.30.2



