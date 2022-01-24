Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2068C49A953
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:23:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1322474AbiAYDVu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:21:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356111AbiAXUWc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:22:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 918AAC0417D1;
        Mon, 24 Jan 2022 11:40:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 39B88B81239;
        Mon, 24 Jan 2022 19:40:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66C9FC340E7;
        Mon, 24 Jan 2022 19:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053218;
        bh=Nfhpuzi4irbRQN3E3HkAZc4HSOT9aiM10z8KebCFNVM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i4k9PuQsRNigywDeO/YurS5pO1DBwUkuyuye5MIq3J6Fwduy28IGnv9rzjTDPEdcu
         naJ2naVo4RmqsDbuCdfxvnWf5E3grSBUUNX2Mym1zSLO8A0ApDc9+nlPJjEhkeOqVU
         dwFAe3S0jSJLGdB61f3w5YlDz5UhUOXi+qh6Rtsg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.4 281/320] scsi: core: Show SCMD_LAST in text form
Date:   Mon, 24 Jan 2022 19:44:25 +0100
Message-Id: <20220124184003.536800740@linuxfoundation.org>
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
 


