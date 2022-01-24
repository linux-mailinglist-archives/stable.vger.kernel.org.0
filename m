Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DFE44995A1
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:13:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442142AbiAXUxZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:53:25 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:41702 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391315AbiAXUrW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:47:22 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B5F016090B;
        Mon, 24 Jan 2022 20:47:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83905C340E5;
        Mon, 24 Jan 2022 20:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057241;
        bh=T4NY8zqPRR6WKhwieFaRIRF4HrYhvq77oMAZe4cIyL0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=shyYPXjlfq6rsmTsceKWJXQK4J0R2WHwOXP3zDq4+Zv+F3CV7WPnjMrQwHy3opGjF
         XAYsD1+xY9X8zUokM6IRuv6bWGU0cxKYPnecFR502u99FqT0an591Ap2RAJiovyhwk
         SKoB/gu4O0IiNzKfo4jQu5Bz3aI9JHWtEfULTUmY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.15 746/846] scsi: core: Show SCMD_LAST in text form
Date:   Mon, 24 Jan 2022 19:44:23 +0100
Message-Id: <20220124184126.716497653@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

commit 3369046e54ca8f82e0cb17740643da2d80d3cfa8 upstream.

The SCSI debugfs code supports showing information about pending commands,
including translating SCSI command flags from numeric into text format.
Also convert the SCMD_LAST flag from numeric into text form.

Link: https://lore.kernel.org/r/20211129194609.3466071-4-bvanassche@acm.org
Fixes: 8930a6c20791 ("scsi: core: add support for request batching")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/scsi_debugfs.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/scsi/scsi_debugfs.c
+++ b/drivers/scsi/scsi_debugfs.c
@@ -9,6 +9,7 @@
 static const char *const scsi_cmd_flags[] = {
 	SCSI_CMD_FLAG_NAME(TAGGED),
 	SCSI_CMD_FLAG_NAME(INITIALIZED),
+	SCSI_CMD_FLAG_NAME(LAST),
 };
 #undef SCSI_CMD_FLAG_NAME
 


