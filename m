Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FF594094E9
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:35:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345666AbhIMOgW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:36:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:54212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345435AbhIMOcd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:32:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 53E6761BB4;
        Mon, 13 Sep 2021 13:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631541127;
        bh=BgX/HImZbQ3Mdruw3lRmzZM2jo7VWCAV17yLDpIWyOI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZLATXlbJ2n05kG2ULg5qZMk9Soke/OQsmaUF25t05WpcDh7XV6JHyPuvJ8sdNx9Bo
         2fSS0RmfE18yaBsF7iLCHjVf2881cUTxP3y2JwPz15tjkkMbaTsV/gUXLq1L5c1rTX
         5OBZhf4iQmrERHr3+n55QYTdg61C0bcbCeow2ZEw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Matthew Cover <matthew.cover@stackpath.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 167/334] bpf, samples: Add missing mprog-disable to xdp_redirect_cpus optstring
Date:   Mon, 13 Sep 2021 15:13:41 +0200
Message-Id: <20210913131118.982355725@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
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
index 576411612523..c7d7d3586730 100644
--- a/samples/bpf/xdp_redirect_cpu_user.c
+++ b/samples/bpf/xdp_redirect_cpu_user.c
@@ -831,7 +831,7 @@ int main(int argc, char **argv)
 	memset(cpu, 0, n_cpus * sizeof(int));
 
 	/* Parse commands line args */
-	while ((opt = getopt_long(argc, argv, "hSd:s:p:q:c:xzFf:e:r:m:",
+	while ((opt = getopt_long(argc, argv, "hSd:s:p:q:c:xzFf:e:r:m:n",
 				  long_options, &longindex)) != -1) {
 		switch (opt) {
 		case 'd':
-- 
2.30.2



