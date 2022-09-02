Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 965955AB072
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 14:54:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237835AbiIBMyY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 08:54:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238044AbiIBMxj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 08:53:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D0A4B69;
        Fri,  2 Sep 2022 05:38:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 93926B82AE6;
        Fri,  2 Sep 2022 12:37:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB80DC433C1;
        Fri,  2 Sep 2022 12:37:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662122242;
        bh=MOj0Ic4N15HWpDxWQhM6QmWUotzFLYKuIljYUisKX/0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KAQE73gxu0lxMgXTRjAyrWCbcAqI3Z+0uDPyGuWGkKj9i5E/9KvXgLaqfaN6iBdp3
         PdbFmh89SC7bvp1+7YLbv8YFqNucgTlwOHF7FxGnpMIsQ8cswezoyK+2VQsFB4OI52
         1lFD3D3UcjhyW4XJIPKuV/pZfpSmmXTbPj4dy0/E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Even Xu <even.xu@intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 5.19 27/72] HID: intel-ish-hid: ipc: Add Meteor Lake PCI device ID
Date:   Fri,  2 Sep 2022 14:19:03 +0200
Message-Id: <20220902121405.692956847@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121404.772492078@linuxfoundation.org>
References: <20220902121404.772492078@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Even Xu <even.xu@intel.com>

commit 467249a7dff68451868ca79696aef69764193a8a upstream.

Add device ID of Meteor Lake P into ishtp support list.

Signed-off-by: Even Xu <even.xu@intel.com>
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/intel-ish-hid/ipc/hw-ish.h  |    1 +
 drivers/hid/intel-ish-hid/ipc/pci-ish.c |    1 +
 2 files changed, 2 insertions(+)

--- a/drivers/hid/intel-ish-hid/ipc/hw-ish.h
+++ b/drivers/hid/intel-ish-hid/ipc/hw-ish.h
@@ -32,6 +32,7 @@
 #define ADL_P_DEVICE_ID		0x51FC
 #define ADL_N_DEVICE_ID		0x54FC
 #define RPL_S_DEVICE_ID		0x7A78
+#define MTL_P_DEVICE_ID		0x7E45
 
 #define	REVISION_ID_CHT_A0	0x6
 #define	REVISION_ID_CHT_Ax_SI	0x0
--- a/drivers/hid/intel-ish-hid/ipc/pci-ish.c
+++ b/drivers/hid/intel-ish-hid/ipc/pci-ish.c
@@ -43,6 +43,7 @@ static const struct pci_device_id ish_pc
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, ADL_P_DEVICE_ID)},
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, ADL_N_DEVICE_ID)},
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, RPL_S_DEVICE_ID)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MTL_P_DEVICE_ID)},
 	{0, }
 };
 MODULE_DEVICE_TABLE(pci, ish_pci_tbl);


