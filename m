Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DA4515C5F5
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 17:11:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388059AbgBMPzg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:55:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:41758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728200AbgBMPZi (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:25:38 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EC85F20848;
        Thu, 13 Feb 2020 15:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607537;
        bh=/O/Q4FG/rgon6u0qtaJpJXjl/VmEOXvI7NIDBPba6es=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=csFPNPZKU8f0W6bE6LerMxFZTR0XQFFpL7SB63fy4WeWtxk661EyIP0u2Clh2Bfz2
         h08wQl+fgnrPbjOqXE2c/uYe/7nfwlxOb0ZT7p0LzGdVC882iWJ0yh8Y+zRDb51uES
         I3Xv4oKQdrw8Qs4G+wZJoGaUDafYyX+Rdh2UqxM4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Manish Rangankar <mrangankar@marvell.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4.14 095/173] scsi: qla4xxx: Adjust indentation in qla4xxx_mem_free
Date:   Thu, 13 Feb 2020 07:19:58 -0800
Message-Id: <20200213151956.947394191@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151931.677980430@linuxfoundation.org>
References: <20200213151931.677980430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

commit aa8679736a82386551eb9f3ea0e6ebe2c0e99104 upstream.

Clang warns:

../drivers/scsi/qla4xxx/ql4_os.c:4148:3: warning: misleading
indentation; statement is not part of the previous 'if'
[-Wmisleading-indentation]
         if (ha->fw_dump)
         ^
../drivers/scsi/qla4xxx/ql4_os.c:4144:2: note: previous statement is
here
        if (ha->queues)
        ^
1 warning generated.

This warning occurs because there is a space after the tab on this
line.  Remove it so that the indentation is consistent with the Linux
kernel coding style and clang no longer warns.

Fixes: 068237c87c64 ("[SCSI] qla4xxx: Capture minidump for ISP82XX on firmware failure")
Link: https://github.com/ClangBuiltLinux/linux/issues/819
Link: https://lore.kernel.org/r/20191218015252.20890-1-natechancellor@gmail.com
Acked-by: Manish Rangankar <mrangankar@marvell.com>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/qla4xxx/ql4_os.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -4150,7 +4150,7 @@ static void qla4xxx_mem_free(struct scsi
 		dma_free_coherent(&ha->pdev->dev, ha->queues_len, ha->queues,
 				  ha->queues_dma);
 
-	 if (ha->fw_dump)
+	if (ha->fw_dump)
 		vfree(ha->fw_dump);
 
 	ha->queues_len = 0;


