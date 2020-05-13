Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74ECD1D1987
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 17:35:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389179AbgEMPf3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 11:35:29 -0400
Received: from mail1.bemta25.messagelabs.com ([195.245.230.2]:20954 "EHLO
        mail1.bemta25.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389255AbgEMPf3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 May 2020 11:35:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ts.fujitsu.com;
        s=200619tsfj; t=1589384126; i=@ts.fujitsu.com;
        bh=FXX7HR9EP9nN4Qc4Odqz55unqXGlxJCDNyqQsVOxOuc=;
        h=From:To:Cc:Subject:Date:Message-Id;
        b=qeIgWRTJFOaWXuQxGxqPDzue74JMgFcLZmiRilv7W2PBt8LRaZoV0d/18IZRbWJYL
         lVgUpDD9TCVgCIqYwPuQ4YWDXNAIrkjoTfq5Wu241kymND99Bd1wbxoub+8TDR2mbX
         +QuXdo367KMTtxXAuYnqVi+ZifX09n60rWOdEebNtH+d+h2WXLFf7Lo4/nFmYLrYVE
         qGOxfURFzwdgCW3TZzL3TGjdjYrsfYOlYMGxZfvdkSZMUr/XYVLSQ8sETadbA+dvaN
         Igtft9Dk6jjUtO3dY5M+cxx7WHGLJTPTBW6uBv/2AY7WV2Io7dBBQj1iBEaCk9k6vG
         QiaAC+HKPwkpA==
Received: from [100.112.193.214] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-2.bemta.az-a.eu-west-1.aws.symcld.net id 75/7C-40611-EB31CBE5; Wed, 13 May 2020 15:35:26 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPLMWRWlGSWpSXmKPExsViZ8MxRXev8J4
  4gwef1S12Xv/IZDHtw09mi+7rO9gslh//x2Sx/sgGRosFGx8xWrQufcvkwO5x+Yq3x/9/U5g9
  Pj69xeLxft9VNo/Pm+QCWKNYM/OS8isSWDNe9VYVzBGsOPvnD1sD4wT+LkYuDiGByYwS569PY
  4RwpjNK7F4yC8jh5GATMJBYMek+C0hCRGANo8T9ZXuYQBLMAm4S17a+ZgGxhYHsp98ms3cxcn
  CwCKhK3D3sDRLmFbCVaJ58gRnElhCQl+g4MJllAiPnAkaGVYwWSUWZ6RkluYmZObqGBga6hoZ
  GuoaWRrpGxiZ6iVW6iXqppbrlqcUluoZ6ieXFesWVuck5KXp5qSWbGIHhklJw4NUOxpNr3+sd
  YpTkYFIS5fW8sTtOiC8pP6UyI7E4I76oNCe1+BCjDAeHkgRvkdCeOCHBotT01Iq0zBxg6MKkJ
  Th4lER4DUDSvMUFibnFmekQqVOMilLivMtBEgIgiYzSPLg2WLxcYpSVEuZlZGBgEOIpSC3KzS
  xBlX/FKM7BqCTMmwsyhSczrwRu+iugxUxAi53v7AJZXJKIkJJqYGJxcUn68GR/YfvrtyUcTyz
  PbBX9EaJ5bKn4zFfhj2+8KdG5OyMv9E7gEzfXmwyVdyb4/gw2eTqr64a8doqy391snvpWC/br
  WzMO10ewNXiHnNb+zuW17PO+uFSeaN3virv7PaNEb/9+/8j4b7+AycPnE965J60+8tec8dosQ
  +e/qx08l261du1QOuT36zHD3IXWkhrGe3df6km93SV/SyxS8+vKH39i/f6Vz1n1+6GhjPuc0E
  uLr+04N8P3p6xhSc656xrer6pkGMVsj3BbqHR/4r9T0/U/OG5q87YT3dtuvQ3w9UxSNsi6Oit
  yEr/ElMQTX761JvGvvMgiMDHmTImky7wP6/8/DlXomH/QeKESS3FGoqEWc1FxIgAXJe/GEgMA
  AA==
X-Env-Sender: bstroesser@ts.fujitsu.com
X-Msg-Ref: server-10.tower-265.messagelabs.com!1589384125!1024971!1
X-Originating-IP: [62.60.8.148]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.50.1; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 23576 invoked from network); 13 May 2020 15:35:25 -0000
Received: from unknown (HELO mailhost1.uk.fujitsu.com) (62.60.8.148)
  by server-10.tower-265.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 13 May 2020 15:35:25 -0000
Received: from x-serv01 ([172.17.38.52])
        by mailhost1.uk.fujitsu.com (8.14.5/8.14.5) with SMTP id 04DFZ4cu022537;
        Wed, 13 May 2020 16:35:04 +0100
Received: from VTC.emeia.fujitsu.local (unknown [172.17.38.7])
        by x-serv01 (Postfix) with ESMTP id 617A82070C;
        Wed, 13 May 2020 17:35:04 +0200 (CEST)
From:   Bodo Stroesser <bstroesser@ts.fujitsu.com>
To:     martin.petersen@oracle.com, bvanassche@acm.org,
        mchristi@redhat.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, bly@catalogicsoftware.com
Cc:     Bodo Stroesser <bstroesser@ts.fujitsu.com>, stable@vger.kernel.org
Subject: [PATCH v2] scsi: target: put lun_ref at end of tmr processing
Date:   Wed, 13 May 2020 17:34:43 +0200
Message-Id: <20200513153443.3554-1-bstroesser@ts.fujitsu.com>
X-Mailer: git-send-email 2.12.3
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Testing with Loopback I found, that after a Loopback LUN
has executed a TMR, I can no longer unlink the LUN.
The rm command hangs in transport_clear_lun_ref() at
wait_for_completion(&lun->lun_shutdown_comp)
The reason is, that transport_lun_remove_cmd() is not
called at the end of target_tmr_work().

It seems, that in other fabrics this call happens implicitly
when the fabric drivers call transport_generic_free_cmd()
during their ->queue_tm_rsp().

Unfortunately Loopback seems to not comply to the common way
of calling transport_generic_free_cmd() from ->queue_*().
Instead it calls transport_generic_free_cmd() from its
  ->check_stop_free() only.

But the ->check_stop_free() is called by
transport_cmd_check_stop_to_fabric() after it has reset the
se_cmd->se_lun pointer.
Therefore the following transport_generic_free_cmd() skips the
transport_lun_remove_cmd().

So this patch re-adds the transport_lun_remove_cmd() at the end
of target_tmr_work(), which was removed during commit
2c9fa49e100f962af988f1c0529231bf14905cda
"scsi: target/core: Make ABORT and LUN RESET handling synchronous"

For fabrics using transport_generic_free_cmd() in the usual way
the double call to transport_lun_remove_cmd() doesn't harm, as
transport_lun_remove_cmd() checks for this situation and does
not release lun_ref twice.

Fixes: 2c9fa49e100f ("scsi: target/core: Make ABORT and LUN RESET handling synchronous")
Cc: stable@vger.kernel.org
Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
Tested-by: Bryant G. Ly <bryangly@gmail.com>
Reviewed-by: Bart van Assche <bvanassche@acm.org>
---

v2:
 - Resend of the same patch with added tags "Fixes:",
   "Cc: stable@.." and "Reviewed-by:"

 drivers/target/target_core_transport.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 594b724bbf79..264a822c0bfa 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -3350,6 +3350,7 @@ static void target_tmr_work(struct work_struct *work)
 
 	cmd->se_tfo->queue_tm_rsp(cmd);
 
+	transport_lun_remove_cmd(cmd);
 	transport_cmd_check_stop_to_fabric(cmd);
 	return;
 
-- 
2.12.3

