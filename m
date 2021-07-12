Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A2C03C4B2E
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:36:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240210AbhGLGzz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:55:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:52482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240967AbhGLGyX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:54:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9CAD86115C;
        Mon, 12 Jul 2021 06:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072685;
        bh=cKP4GxnIuNOR7Wrkgosk62j3gIzMRVVyIlkEuxXSyR0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FEyEOP+QNzkHdTLW0jStsAO8E0n3M+n13mMgXwq2pNX5eJmrf/0Y5+i8ohpHcgStm
         NYceCWsLKX4qvXmmVhq2h6CXLtNBiNOYTTkoc13fvXFRBJjFP3l/xBLveRbntNCgm8
         Co5xhMMokWCU89dI8/l8Zh8UST2T9pRuOKCRdWVg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Javed Hasan <jhasan@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.10 581/593] scsi: fc: Correct RHBA attributes length
Date:   Mon, 12 Jul 2021 08:12:21 +0200
Message-Id: <20210712060959.107230669@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Javed Hasan <jhasan@marvell.com>

commit 40445fd2c9fa427297acdfcc2c573ff10493f209 upstream.

As per the FC-GS-5 specification, attribute lengths of node_name and
manufacturer should in range of "4 to 64 Bytes" only.

Link: https://lore.kernel.org/r/20210603101404.7841-2-jhasan@marvell.com
Fixes: e721eb0616f6 ("scsi: scsi_transport_fc: Match HBA Attribute Length with HBAAPI V2.0 definitions")
CC: stable@vger.kernel.org
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Javed Hasan <jhasan@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/scsi/fc/fc_ms.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/scsi/fc/fc_ms.h
+++ b/include/scsi/fc/fc_ms.h
@@ -63,8 +63,8 @@ enum fc_fdmi_hba_attr_type {
  * HBA Attribute Length
  */
 #define FC_FDMI_HBA_ATTR_NODENAME_LEN		8
-#define FC_FDMI_HBA_ATTR_MANUFACTURER_LEN	80
-#define FC_FDMI_HBA_ATTR_SERIALNUMBER_LEN	80
+#define FC_FDMI_HBA_ATTR_MANUFACTURER_LEN	64
+#define FC_FDMI_HBA_ATTR_SERIALNUMBER_LEN	64
 #define FC_FDMI_HBA_ATTR_MODEL_LEN		256
 #define FC_FDMI_HBA_ATTR_MODELDESCR_LEN		256
 #define FC_FDMI_HBA_ATTR_HARDWAREVERSION_LEN	256


