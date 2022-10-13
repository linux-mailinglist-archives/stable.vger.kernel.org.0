Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B41EA5FDA46
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 15:18:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229462AbiJMNSp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 09:18:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiJMNSk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 09:18:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7A3E4E18F
        for <stable@vger.kernel.org>; Thu, 13 Oct 2022 06:18:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 90C36617A9
        for <stable@vger.kernel.org>; Thu, 13 Oct 2022 13:18:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F424C433D6;
        Thu, 13 Oct 2022 13:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665667105;
        bh=u0r/emeG1onKEVgDAm2kfO1iKl2rk2ZSCQTFuKotjpk=;
        h=Subject:To:Cc:From:Date:From;
        b=LaU2kSIUMU81E05TzG+hRBcTDBs8VXRjJyXxHZhJ8Ewq9Q0fH484OZ5v7hXc5KsBT
         Hy+QO27RNPgfGJF/dxaig0uXXtBjIutkIeehFFo7EKCKGVYDYaMNrA3IZZqGv0+SrH
         +ONDU9czrYw+Rq3jPdBYTeAuFSC2pHidxLfouaQA=
Subject: WTF: patch "[PATCH] scsi: qla2xxx: Define static symbols" was seriously submitted to be applied to the 6.0-stable tree?
To:     njavali@marvell.com, himanshu.madhani@oracle.com, lkp@intel.com,
        martin.petersen@oracle.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 13 Oct 2022 15:12:45 +0200
Message-ID: <166566676569234@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The patch below was submitted to be applied to the 6.0-stable tree.

I fail to see how this patch meets the stable kernel rules as found at
Documentation/process/stable-kernel-rules.rst.

I could be totally wrong, and if so, please respond to 
<stable@vger.kernel.org> and let me know why this patch should be
applied.  Otherwise, it is now dropped from my patch queues, never to be
seen again.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 2c57d0defa22b2339c06364a275bcc9048a77255 Mon Sep 17 00:00:00 2001
From: Nilesh Javali <njavali@marvell.com>
Date: Fri, 26 Aug 2022 03:25:58 -0700
Subject: [PATCH] scsi: qla2xxx: Define static symbols

drivers/scsi/qla2xxx/qla_os.c:40:20: warning: symbol 'qla_trc_array'
was not declared. Should it be static?
drivers/scsi/qla2xxx/qla_os.c:345:5: warning: symbol
'ql2xdelay_before_pci_error_handling' was not declared.
Should it be static?

Define qla_trc_array and ql2xdelay_before_pci_error_handling as static to
fix sparse warnings.

Link: https://lore.kernel.org/r/20220826102559.17474-7-njavali@marvell.com
Cc: stable@vger.kernel.org
Reported-by: kernel test robot <lkp@intel.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index f76ae8a64ea9..0ccaeea4e1bd 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -37,7 +37,7 @@ static int apidev_major;
  */
 struct kmem_cache *srb_cachep;
 
-struct trace_array *qla_trc_array;
+static struct trace_array *qla_trc_array;
 
 int ql2xfulldump_on_mpifail;
 module_param(ql2xfulldump_on_mpifail, int, S_IRUGO | S_IWUSR);
@@ -342,7 +342,7 @@ MODULE_PARM_DESC(ql2xabts_wait_nvme,
 		 "To wait for ABTS response on I/O timeouts for NVMe. (default: 1)");
 
 
-u32 ql2xdelay_before_pci_error_handling = 5;
+static u32 ql2xdelay_before_pci_error_handling = 5;
 module_param(ql2xdelay_before_pci_error_handling, uint, 0644);
 MODULE_PARM_DESC(ql2xdelay_before_pci_error_handling,
 	"Number of seconds delayed before qla begin PCI error self-handling (default: 5).\n");

