Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B611C49A5D2
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:13:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2371156AbiAYAHG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:07:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2363403AbiAXXo0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:44:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EEFBC0FE684;
        Mon, 24 Jan 2022 13:39:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1789E614B4;
        Mon, 24 Jan 2022 21:39:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFCA1C340E7;
        Mon, 24 Jan 2022 21:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060351;
        bh=T4NY8zqPRR6WKhwieFaRIRF4HrYhvq77oMAZe4cIyL0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TJa/P/eLeqNLh85IoqBUP58tayy1wqIySTbigFHencJffqiyJ5cnPF5rYVYfLmTft
         m5i2Altt85dDt+AqVNkXeYFjvGseG0cMLCLLBpchKJkWeAQxd6BgI1DtzvA15Pq3WO
         WuOBSKqJv/JF6BA2SoEgu1cVGFH1azSGH37VKtKw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.16 0920/1039] scsi: core: Show SCMD_LAST in text form
Date:   Mon, 24 Jan 2022 19:45:09 +0100
Message-Id: <20220124184156.224871831@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
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
 


