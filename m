Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A788D15C57C
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 17:10:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728083AbgBMPWn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:22:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:60622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728066AbgBMPWm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:22:42 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A816E246A4;
        Thu, 13 Feb 2020 15:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607361;
        bh=xp5AfYsg5Lg7c8CdywzoLdQcyf/BrBlzYmWCtroqw9A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aLE2SJpTMMjfCekGlGs0ht7VCQjqQPaws2JBUqvpbn7/VHazhXlh6SKnGVdWa6hLB
         DNhaCaCAMa+SgHPVRMNW787Dh7zhwMXD1/NGA7CAycvLHhDLL5w8dS2C4Xyjd1vr6B
         Hbv3raVAIV3XUnUhRnh7STxDQTYiXKgi75GcxnS4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4.4 48/91] scsi: csiostor: Adjust indentation in csio_device_reset
Date:   Thu, 13 Feb 2020 07:20:05 -0800
Message-Id: <20200213151840.304812250@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151821.384445454@linuxfoundation.org>
References: <20200213151821.384445454@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

commit a808a04c861782e31fc30e342a619c144aaee14a upstream.

Clang warns:

../drivers/scsi/csiostor/csio_scsi.c:1386:3: warning: misleading
indentation; statement is not part of the previous 'if'
[-Wmisleading-indentation]
         csio_lnodes_exit(hw, 1);
         ^
../drivers/scsi/csiostor/csio_scsi.c:1382:2: note: previous statement is
here
        if (*buf != '1')
        ^
1 warning generated.

This warning occurs because there is a space after the tab on this
line.  Remove it so that the indentation is consistent with the Linux
kernel coding style and clang no longer warns.

Fixes: a3667aaed569 ("[SCSI] csiostor: Chelsio FCoE offload driver")
Link: https://github.com/ClangBuiltLinux/linux/issues/818
Link: https://lore.kernel.org/r/20191218014726.8455-1-natechancellor@gmail.com
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/csiostor/csio_scsi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/csiostor/csio_scsi.c
+++ b/drivers/scsi/csiostor/csio_scsi.c
@@ -1383,7 +1383,7 @@ csio_device_reset(struct device *dev,
 		return -EINVAL;
 
 	/* Delete NPIV lnodes */
-	 csio_lnodes_exit(hw, 1);
+	csio_lnodes_exit(hw, 1);
 
 	/* Block upper IOs */
 	csio_lnodes_block_request(hw);


