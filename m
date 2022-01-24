Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62CB349A921
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:19:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1322183AbiAYDVO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:21:14 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:50764 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378683AbiAXUIT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:08:19 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 50960B8121A;
        Mon, 24 Jan 2022 20:08:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51359C340E5;
        Mon, 24 Jan 2022 20:08:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054896;
        bh=Nfhpuzi4irbRQN3E3HkAZc4HSOT9aiM10z8KebCFNVM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BRNsh3xcM8H9LzTEDLYB//9hfCPoNuW8+GZvQTVv2xUM5e+ZVOgDRfPj72vqnfwYU
         w04TWSXQpUL4TF6e0Aj+S8nnvJFhZYSRXRL7JaJb5wYpD5Rugd0gdxZMmGlDZLvy4+
         my69ejpfl7QvpVpkae4J2f89mQr8XauSmdN9UAE0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.10 496/563] scsi: core: Show SCMD_LAST in text form
Date:   Mon, 24 Jan 2022 19:44:21 +0100
Message-Id: <20220124184041.604864608@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
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
@@ -10,6 +10,7 @@ static const char *const scsi_cmd_flags[
 	SCSI_CMD_FLAG_NAME(TAGGED),
 	SCSI_CMD_FLAG_NAME(UNCHECKED_ISA_DMA),
 	SCSI_CMD_FLAG_NAME(INITIALIZED),
+	SCSI_CMD_FLAG_NAME(LAST),
 };
 #undef SCSI_CMD_FLAG_NAME
 


