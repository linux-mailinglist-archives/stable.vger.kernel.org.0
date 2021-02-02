Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE92330C076
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 15:00:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233513AbhBBN6s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 08:58:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:42526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233368AbhBBN4q (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:56:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8091364FE5;
        Tue,  2 Feb 2021 13:45:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273530;
        bh=XG70ap1PzUXWKpNAJMjQldDPvbk0TB8cWNORfcFrqzM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gTVRoijdzHAMoMOSBwGyvtMkmAa/vTcC/T7GBgK1qSPCbxSXt/WSWR1un+r4lhy17
         ddiHAPlPNmYxWG1BoOEs4p55OgFEheo57Rq14EkehKOUufOxHwL3SY6bcdyXD2wTLC
         WmyNVQR9gZyb630dHUr7IAz9m/m/R7pUWCL8f084=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Wagner <dwagner@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Enzo Matsumiya <ematsumiya@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.10 139/142] scsi: qla2xxx: Fix description for parameter ql2xenforce_iocb_limit
Date:   Tue,  2 Feb 2021 14:38:22 +0100
Message-Id: <20210202133003.427602741@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132957.692094111@linuxfoundation.org>
References: <20210202132957.692094111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Enzo Matsumiya <ematsumiya@suse.de>

commit aa2c24e7f415e9c13635cee22ff4e15a80215551 upstream.

Parameter ql2xenforce_iocb_limit is enabled by default.

Link: https://lore.kernel.org/r/20210118184922.23793-1-ematsumiya@suse.de
Fixes: 89c72f4245a8 ("scsi: qla2xxx: Add IOCB resource tracking")
Reviewed-by: Daniel Wagner <dwagner@suse.de>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/qla2xxx/qla_os.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -42,7 +42,7 @@ MODULE_PARM_DESC(ql2xfulldump_on_mpifail
 int ql2xenforce_iocb_limit = 1;
 module_param(ql2xenforce_iocb_limit, int, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(ql2xenforce_iocb_limit,
-		 "Enforce IOCB throttling, to avoid FW congestion. (default: 0)");
+		 "Enforce IOCB throttling, to avoid FW congestion. (default: 1)");
 
 /*
  * CT6 CTX allocation cache


