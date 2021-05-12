Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4DAE37C3D8
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:29:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233357AbhELPWa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:22:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:57874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234701AbhELPU1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:20:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0989D619A5;
        Wed, 12 May 2021 15:08:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832111;
        bh=HCKSMquQ+CJ3V/85eGcb0RpjMU2UwBlUkXlmBhZiSPo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D/DDIKcdfixiELM5vtxfd1sGhv5WxmFKoHEHQaC0w4+ZAkkmA/1U87czpQ21CiNqN
         3B+8YOzRlbHad9iN87EIdzkGF88tvWxDdk5PkyfzwY9xCdyX1oP+evqWHTMnuEEK8/
         ZhNUyyPqDxWwTlvIwlsUzAxyzpIh4GuUprxlZbTg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michal Simek <michal.simek@xilinx.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 112/530] firmware: xilinx: Add a blank line after function declaration
Date:   Wed, 12 May 2021 16:43:42 +0200
Message-Id: <20210512144823.478843908@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michal Simek <michal.simek@xilinx.com>

[ Upstream commit a80cefec2c2783166727324bde724c39aa8a12df ]

Fix all these issues which are also reported by checkpatch --strict.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Link: https://lore.kernel.org/r/7b6007e05f6c01214861a37f198cd5bee62a4d3e.1606894725.git.michal.simek@xilinx.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/firmware/xlnx-zynqmp.h | 34 ++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/include/linux/firmware/xlnx-zynqmp.h b/include/linux/firmware/xlnx-zynqmp.h
index 41a1bab98b7e..7fb3274a4a9e 100644
--- a/include/linux/firmware/xlnx-zynqmp.h
+++ b/include/linux/firmware/xlnx-zynqmp.h
@@ -358,107 +358,132 @@ static inline struct zynqmp_eemi_ops *zynqmp_pm_get_eemi_ops(void)
 {
 	return ERR_PTR(-ENODEV);
 }
+
 static inline int zynqmp_pm_get_api_version(u32 *version)
 {
 	return -ENODEV;
 }
+
 static inline int zynqmp_pm_get_chipid(u32 *idcode, u32 *version)
 {
 	return -ENODEV;
 }
+
 static inline int zynqmp_pm_query_data(struct zynqmp_pm_query_data qdata,
 				       u32 *out)
 {
 	return -ENODEV;
 }
+
 static inline int zynqmp_pm_clock_enable(u32 clock_id)
 {
 	return -ENODEV;
 }
+
 static inline int zynqmp_pm_clock_disable(u32 clock_id)
 {
 	return -ENODEV;
 }
+
 static inline int zynqmp_pm_clock_getstate(u32 clock_id, u32 *state)
 {
 	return -ENODEV;
 }
+
 static inline int zynqmp_pm_clock_setdivider(u32 clock_id, u32 divider)
 {
 	return -ENODEV;
 }
+
 static inline int zynqmp_pm_clock_getdivider(u32 clock_id, u32 *divider)
 {
 	return -ENODEV;
 }
+
 static inline int zynqmp_pm_clock_setrate(u32 clock_id, u64 rate)
 {
 	return -ENODEV;
 }
+
 static inline int zynqmp_pm_clock_getrate(u32 clock_id, u64 *rate)
 {
 	return -ENODEV;
 }
+
 static inline int zynqmp_pm_clock_setparent(u32 clock_id, u32 parent_id)
 {
 	return -ENODEV;
 }
+
 static inline int zynqmp_pm_clock_getparent(u32 clock_id, u32 *parent_id)
 {
 	return -ENODEV;
 }
+
 static inline int zynqmp_pm_set_pll_frac_mode(u32 clk_id, u32 mode)
 {
 	return -ENODEV;
 }
+
 static inline int zynqmp_pm_get_pll_frac_mode(u32 clk_id, u32 *mode)
 {
 	return -ENODEV;
 }
+
 static inline int zynqmp_pm_set_pll_frac_data(u32 clk_id, u32 data)
 {
 	return -ENODEV;
 }
+
 static inline int zynqmp_pm_get_pll_frac_data(u32 clk_id, u32 *data)
 {
 	return -ENODEV;
 }
+
 static inline int zynqmp_pm_set_sd_tapdelay(u32 node_id, u32 type, u32 value)
 {
 	return -ENODEV;
 }
+
 static inline int zynqmp_pm_sd_dll_reset(u32 node_id, u32 type)
 {
 	return -ENODEV;
 }
+
 static inline int zynqmp_pm_reset_assert(const enum zynqmp_pm_reset reset,
 			   const enum zynqmp_pm_reset_action assert_flag)
 {
 	return -ENODEV;
 }
+
 static inline int zynqmp_pm_reset_get_status(const enum zynqmp_pm_reset reset,
 					     u32 *status)
 {
 	return -ENODEV;
 }
+
 static inline int zynqmp_pm_init_finalize(void)
 {
 	return -ENODEV;
 }
+
 static inline int zynqmp_pm_set_suspend_mode(u32 mode)
 {
 	return -ENODEV;
 }
+
 static inline int zynqmp_pm_request_node(const u32 node, const u32 capabilities,
 					 const u32 qos,
 					 const enum zynqmp_pm_request_ack ack)
 {
 	return -ENODEV;
 }
+
 static inline int zynqmp_pm_release_node(const u32 node)
 {
 	return -ENODEV;
 }
+
 static inline int zynqmp_pm_set_requirement(const u32 node,
 					const u32 capabilities,
 					const u32 qos,
@@ -466,39 +491,48 @@ static inline int zynqmp_pm_set_requirement(const u32 node,
 {
 	return -ENODEV;
 }
+
 static inline int zynqmp_pm_aes_engine(const u64 address, u32 *out)
 {
 	return -ENODEV;
 }
+
 static inline int zynqmp_pm_fpga_load(const u64 address, const u32 size,
 				      const u32 flags)
 {
 	return -ENODEV;
 }
+
 static inline int zynqmp_pm_fpga_get_status(u32 *value)
 {
 	return -ENODEV;
 }
+
 static inline int zynqmp_pm_write_ggs(u32 index, u32 value)
 {
 	return -ENODEV;
 }
+
 static inline int zynqmp_pm_read_ggs(u32 index, u32 *value)
 {
 	return -ENODEV;
 }
+
 static inline int zynqmp_pm_write_pggs(u32 index, u32 value)
 {
 	return -ENODEV;
 }
+
 static inline int zynqmp_pm_read_pggs(u32 index, u32 *value)
 {
 	return -ENODEV;
 }
+
 static inline int zynqmp_pm_system_shutdown(const u32 type, const u32 subtype)
 {
 	return -ENODEV;
 }
+
 static inline int zynqmp_pm_set_boot_health_status(u32 value)
 {
 	return -ENODEV;
-- 
2.30.2



