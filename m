Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F236498F34
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:51:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357685AbiAXTvT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:51:19 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59048 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354774AbiAXTh4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:37:56 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 13C6DB8124C;
        Mon, 24 Jan 2022 19:37:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D1D6C340E5;
        Mon, 24 Jan 2022 19:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053073;
        bh=esUmQol+H/4d9Hgo8Aa5Ag4uakS/BpjuUbGvpirtm4s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EQbMB21ncrpR77OT/C4XuM1nOrneLfNMzhL6XnTIUlHTz7y415pmiP0TfHYvoMHgO
         fSbz5hsuGcEoV/qN/3q5EsliWv4F+fI36cOYXkDwDrsD8M4GkkKGE4if4vnxhkd/2Y
         q1yJJL8yROzqYXDBz4i3CNwXOMr8nN1iOVWGN0No=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wolfram Sang <wsa@kernel.org>,
        Lakshmi Sowjanya D <lakshmi.sowjanya.d@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 240/320] i2c: designware-pci: Fix to change data types of hcnt and lcnt parameters
Date:   Mon, 24 Jan 2022 19:43:44 +0100
Message-Id: <20220124184002.149396816@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183953.750177707@linuxfoundation.org>
References: <20220124183953.750177707@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lakshmi Sowjanya D <lakshmi.sowjanya.d@intel.com>

[ Upstream commit d52097010078c1844348dc0e467305e5f90fd317 ]

The data type of hcnt and lcnt in the struct dw_i2c_dev is of type u16.
It's better to have same data type in struct dw_scl_sda_cfg as well.

Reported-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Lakshmi Sowjanya D <lakshmi.sowjanya.d@intel.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-designware-pcidrv.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/i2c/busses/i2c-designware-pcidrv.c b/drivers/i2c/busses/i2c-designware-pcidrv.c
index 05b35ac33ce33..735326e5eb8cf 100644
--- a/drivers/i2c/busses/i2c-designware-pcidrv.c
+++ b/drivers/i2c/busses/i2c-designware-pcidrv.c
@@ -37,10 +37,10 @@ enum dw_pci_ctl_id_t {
 };
 
 struct dw_scl_sda_cfg {
-	u32 ss_hcnt;
-	u32 fs_hcnt;
-	u32 ss_lcnt;
-	u32 fs_lcnt;
+	u16 ss_hcnt;
+	u16 fs_hcnt;
+	u16 ss_lcnt;
+	u16 fs_lcnt;
 	u32 sda_hold;
 };
 
-- 
2.34.1



