Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CE186AEF9B
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:24:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230513AbjCGSYj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:24:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232782AbjCGSYN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:24:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BCD09DE1B
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:19:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E01FDB8184E
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:19:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38F0EC4339B;
        Tue,  7 Mar 2023 18:19:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678213186;
        bh=NRxQacvklSiFHnu/ATtktMdVd5c6W8U4Ua4ZRkxeIHs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K3rOBc71kZCP6B75SuxxOa73lvA2fZNc4cc3iiuX9V49tEvp9D61ebWtm7aL327Cg
         zDlDetWDExVhoczL0EbRibA8rAV0aX0vzh6z3phQSmaCQuY69yS+KBuqTdeZL/QQPU
         adOTn4zRet+Uxck1mdhn4FiVQGYceMAlPp4IJfUs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Frank Li <frank.li@nxp.com>,
        Lorenzo Pieralisi <lpieralisi@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 426/885] PCI: endpoint: pci-epf-vntb: Clean up kernel_doc warning
Date:   Tue,  7 Mar 2023 17:56:00 +0100
Message-Id: <20230307170020.925161451@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frank Li <frank.li@nxp.com>

[ Upstream commit 9298804840457c29c7e115f3a87bec406c262c81 ]

Cleanup warning found by scripts/kernel-doc.

Consolidate terms:

- host, host1 to HOST
- vhost, vHost, Vhost, VHOST2 to VHOST

Link: https://lore.kernel.org/r/20221102141014.1025893-2-Frank.Li@nxp.com
Signed-off-by: Frank Li <frank.li@nxp.com>
Signed-off-by: Lorenzo Pieralisi <lpieralisi@kernel.org>
Acked-by: Manivannan Sadhasivam <mani@kernel.org>
Stable-dep-of: fd858402c6d0 ("PCI: endpoint: pci-epf-vntb: Add epf_ntb_mw_bar_clear() num_mws kernel-doc")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/endpoint/functions/pci-epf-vntb.c | 83 ++++++++++++-------
 1 file changed, 54 insertions(+), 29 deletions(-)

diff --git a/drivers/pci/endpoint/functions/pci-epf-vntb.c b/drivers/pci/endpoint/functions/pci-epf-vntb.c
index fba0179939b8f..36a83f0c28810 100644
--- a/drivers/pci/endpoint/functions/pci-epf-vntb.c
+++ b/drivers/pci/endpoint/functions/pci-epf-vntb.c
@@ -11,7 +11,7 @@
  * Author: Kishon Vijay Abraham I <kishon@ti.com>
  */
 
-/**
+/*
  * +------------+         +---------------------------------------+
  * |            |         |                                       |
  * +------------+         |                        +--------------+
@@ -156,12 +156,14 @@ static struct pci_epf_header epf_ntb_header = {
 };
 
 /**
- * epf_ntb_link_up() - Raise link_up interrupt to Virtual Host
+ * epf_ntb_link_up() - Raise link_up interrupt to Virtual Host (VHOST)
  * @ntb: NTB device that facilitates communication between HOST and VHOST
  * @link_up: true or false indicating Link is UP or Down
  *
  * Once NTB function in HOST invoke ntb_link_enable(),
- * this NTB function driver will trigger a link event to vhost.
+ * this NTB function driver will trigger a link event to VHOST.
+ *
+ * Returns: Zero for success, or an error code in case of failure
  */
 static int epf_ntb_link_up(struct epf_ntb *ntb, bool link_up)
 {
@@ -175,9 +177,9 @@ static int epf_ntb_link_up(struct epf_ntb *ntb, bool link_up)
 }
 
 /**
- * epf_ntb_configure_mw() - Configure the Outbound Address Space for vhost
- *   to access the memory window of host
- * @ntb: NTB device that facilitates communication between host and vhost
+ * epf_ntb_configure_mw() - Configure the Outbound Address Space for VHOST
+ *   to access the memory window of HOST
+ * @ntb: NTB device that facilitates communication between HOST and VHOST
  * @mw: Index of the memory window (either 0, 1, 2 or 3)
  *
  *                          EP Outbound Window
@@ -194,7 +196,9 @@ static int epf_ntb_link_up(struct epf_ntb *ntb, bool link_up)
  * |        |              |           |
  * |        |              |           |
  * +--------+              +-----------+
- *  VHost                   PCI EP
+ *  VHOST                   PCI EP
+ *
+ * Returns: Zero for success, or an error code in case of failure
  */
 static int epf_ntb_configure_mw(struct epf_ntb *ntb, u32 mw)
 {
@@ -219,7 +223,7 @@ static int epf_ntb_configure_mw(struct epf_ntb *ntb, u32 mw)
 
 /**
  * epf_ntb_teardown_mw() - Teardown the configured OB ATU
- * @ntb: NTB device that facilitates communication between HOST and vHOST
+ * @ntb: NTB device that facilitates communication between HOST and VHOST
  * @mw: Index of the memory window (either 0, 1, 2 or 3)
  *
  * Teardown the configured OB ATU configured in epf_ntb_configure_mw() using
@@ -234,12 +238,12 @@ static void epf_ntb_teardown_mw(struct epf_ntb *ntb, u32 mw)
 }
 
 /**
- * epf_ntb_cmd_handler() - Handle commands provided by the NTB Host
+ * epf_ntb_cmd_handler() - Handle commands provided by the NTB HOST
  * @work: work_struct for the epf_ntb_epc
  *
  * Workqueue function that gets invoked for the two epf_ntb_epc
  * periodically (once every 5ms) to see if it has received any commands
- * from NTB host. The host can send commands to configure doorbell or
+ * from NTB HOST. The HOST can send commands to configure doorbell or
  * configure memory window or to update link status.
  */
 static void epf_ntb_cmd_handler(struct work_struct *work)
@@ -321,8 +325,8 @@ static void epf_ntb_cmd_handler(struct work_struct *work)
 
 /**
  * epf_ntb_config_sspad_bar_clear() - Clear Config + Self scratchpad BAR
- * @ntb_epc: EPC associated with one of the HOST which holds peer's outbound
- *	     address.
+ * @ntb: EPC associated with one of the HOST which holds peer's outbound
+ *	 address.
  *
  * Clear BAR0 of EP CONTROLLER 1 which contains the HOST1's config and
  * self scratchpad region (removes inbound ATU configuration). While BAR0 is
@@ -331,8 +335,10 @@ static void epf_ntb_cmd_handler(struct work_struct *work)
  * used for self scratchpad from epf_ntb_bar[BAR_CONFIG].
  *
  * Please note the self scratchpad region and config region is combined to
- * a single region and mapped using the same BAR. Also note HOST2's peer
- * scratchpad is HOST1's self scratchpad.
+ * a single region and mapped using the same BAR. Also note VHOST's peer
+ * scratchpad is HOST's self scratchpad.
+ *
+ * Returns: void
  */
 static void epf_ntb_config_sspad_bar_clear(struct epf_ntb *ntb)
 {
@@ -347,13 +353,15 @@ static void epf_ntb_config_sspad_bar_clear(struct epf_ntb *ntb)
 
 /**
  * epf_ntb_config_sspad_bar_set() - Set Config + Self scratchpad BAR
- * @ntb: NTB device that facilitates communication between HOST and vHOST
+ * @ntb: NTB device that facilitates communication between HOST and VHOST
  *
- * Map BAR0 of EP CONTROLLER 1 which contains the HOST1's config and
+ * Map BAR0 of EP CONTROLLER which contains the VHOST's config and
  * self scratchpad region.
  *
  * Please note the self scratchpad region and config region is combined to
  * a single region and mapped using the same BAR.
+ *
+ * Returns: Zero for success, or an error code in case of failure
  */
 static int epf_ntb_config_sspad_bar_set(struct epf_ntb *ntb)
 {
@@ -380,7 +388,7 @@ static int epf_ntb_config_sspad_bar_set(struct epf_ntb *ntb)
 /**
  * epf_ntb_config_spad_bar_free() - Free the physical memory associated with
  *   config + scratchpad region
- * @ntb: NTB device that facilitates communication between HOST and vHOST
+ * @ntb: NTB device that facilitates communication between HOST and VHOST
  */
 static void epf_ntb_config_spad_bar_free(struct epf_ntb *ntb)
 {
@@ -393,11 +401,13 @@ static void epf_ntb_config_spad_bar_free(struct epf_ntb *ntb)
 /**
  * epf_ntb_config_spad_bar_alloc() - Allocate memory for config + scratchpad
  *   region
- * @ntb: NTB device that facilitates communication between HOST1 and HOST2
+ * @ntb: NTB device that facilitates communication between HOST and VHOST
  *
  * Allocate the Local Memory mentioned in the above diagram. The size of
  * CONFIG REGION is sizeof(struct epf_ntb_ctrl) and size of SCRATCHPAD REGION
  * is obtained from "spad-count" configfs entry.
+ *
+ * Returns: Zero for success, or an error code in case of failure
  */
 static int epf_ntb_config_spad_bar_alloc(struct epf_ntb *ntb)
 {
@@ -465,11 +475,13 @@ static int epf_ntb_config_spad_bar_alloc(struct epf_ntb *ntb)
 }
 
 /**
- * epf_ntb_configure_interrupt() - Configure MSI/MSI-X capaiblity
- * @ntb: NTB device that facilitates communication between HOST and vHOST
+ * epf_ntb_configure_interrupt() - Configure MSI/MSI-X capability
+ * @ntb: NTB device that facilitates communication between HOST and VHOST
  *
  * Configure MSI/MSI-X capability for each interface with number of
  * interrupts equal to "db_count" configfs entry.
+ *
+ * Returns: Zero for success, or an error code in case of failure
  */
 static int epf_ntb_configure_interrupt(struct epf_ntb *ntb)
 {
@@ -511,7 +523,9 @@ static int epf_ntb_configure_interrupt(struct epf_ntb *ntb)
 
 /**
  * epf_ntb_db_bar_init() - Configure Doorbell window BARs
- * @ntb: NTB device that facilitates communication between HOST and vHOST
+ * @ntb: NTB device that facilitates communication between HOST and VHOST
+ *
+ * Returns: Zero for success, or an error code in case of failure
  */
 static int epf_ntb_db_bar_init(struct epf_ntb *ntb)
 {
@@ -566,7 +580,7 @@ static void epf_ntb_mw_bar_clear(struct epf_ntb *ntb, int num_mws);
 /**
  * epf_ntb_db_bar_clear() - Clear doorbell BAR and free memory
  *   allocated in peer's outbound address space
- * @ntb: NTB device that facilitates communication between HOST and vHOST
+ * @ntb: NTB device that facilitates communication between HOST and VHOST
  */
 static void epf_ntb_db_bar_clear(struct epf_ntb *ntb)
 {
@@ -582,8 +596,9 @@ static void epf_ntb_db_bar_clear(struct epf_ntb *ntb)
 
 /**
  * epf_ntb_mw_bar_init() - Configure Memory window BARs
- * @ntb: NTB device that facilitates communication between HOST and vHOST
+ * @ntb: NTB device that facilitates communication between HOST and VHOST
  *
+ * Returns: Zero for success, or an error code in case of failure
  */
 static int epf_ntb_mw_bar_init(struct epf_ntb *ntb)
 {
@@ -639,7 +654,7 @@ static int epf_ntb_mw_bar_init(struct epf_ntb *ntb)
 
 /**
  * epf_ntb_mw_bar_clear() - Clear Memory window BARs
- * @ntb: NTB device that facilitates communication between HOST and vHOST
+ * @ntb: NTB device that facilitates communication between HOST and VHOST
  */
 static void epf_ntb_mw_bar_clear(struct epf_ntb *ntb, int num_mws)
 {
@@ -662,7 +677,7 @@ static void epf_ntb_mw_bar_clear(struct epf_ntb *ntb, int num_mws)
 
 /**
  * epf_ntb_epc_destroy() - Cleanup NTB EPC interface
- * @ntb: NTB device that facilitates communication between HOST and vHOST
+ * @ntb: NTB device that facilitates communication between HOST and VHOST
  *
  * Wrapper for epf_ntb_epc_destroy_interface() to cleanup all the NTB interfaces
  */
@@ -675,7 +690,9 @@ static void epf_ntb_epc_destroy(struct epf_ntb *ntb)
 /**
  * epf_ntb_init_epc_bar() - Identify BARs to be used for each of the NTB
  * constructs (scratchpad region, doorbell, memorywindow)
- * @ntb: NTB device that facilitates communication between HOST and vHOST
+ * @ntb: NTB device that facilitates communication between HOST and VHOST
+ *
+ * Returns: Zero for success, or an error code in case of failure
  */
 static int epf_ntb_init_epc_bar(struct epf_ntb *ntb)
 {
@@ -716,11 +733,13 @@ static int epf_ntb_init_epc_bar(struct epf_ntb *ntb)
 
 /**
  * epf_ntb_epc_init() - Initialize NTB interface
- * @ntb: NTB device that facilitates communication between HOST and vHOST2
+ * @ntb: NTB device that facilitates communication between HOST and VHOST
  *
  * Wrapper to initialize a particular EPC interface and start the workqueue
- * to check for commands from host. This function will write to the
+ * to check for commands from HOST. This function will write to the
  * EP controller HW for configuring it.
+ *
+ * Returns: Zero for success, or an error code in case of failure
  */
 static int epf_ntb_epc_init(struct epf_ntb *ntb)
 {
@@ -787,7 +806,7 @@ static int epf_ntb_epc_init(struct epf_ntb *ntb)
 
 /**
  * epf_ntb_epc_cleanup() - Cleanup all NTB interfaces
- * @ntb: NTB device that facilitates communication between HOST1 and HOST2
+ * @ntb: NTB device that facilitates communication between HOST and VHOST
  *
  * Wrapper to cleanup all NTB interfaces.
  */
@@ -951,6 +970,8 @@ static const struct config_item_type ntb_group_type = {
  *
  * Add configfs directory specific to NTB. This directory will hold
  * NTB specific properties like db_count, spad_count, num_mws etc.,
+ *
+ * Returns: Pointer to config_group
  */
 static struct config_group *epf_ntb_add_cfs(struct pci_epf *epf,
 					    struct config_group *group)
@@ -1292,6 +1313,8 @@ static struct pci_driver vntb_pci_driver = {
  * Invoked when a primary interface or secondary interface is bound to EPC
  * device. This function will succeed only when EPC is bound to both the
  * interfaces.
+ *
+ * Returns: Zero for success, or an error code in case of failure
  */
 static int epf_ntb_bind(struct pci_epf *epf)
 {
@@ -1377,6 +1400,8 @@ static struct pci_epf_ops epf_ntb_ops = {
  *
  * Probe NTB function driver when endpoint function bus detects a NTB
  * endpoint function.
+ *
+ * Returns: Zero for success, or an error code in case of failure
  */
 static int epf_ntb_probe(struct pci_epf *epf)
 {
-- 
2.39.2



