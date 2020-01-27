Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4E8F149E91
	for <lists+stable@lfdr.de>; Mon, 27 Jan 2020 06:07:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725807AbgA0FHt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jan 2020 00:07:49 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:41039 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725763AbgA0FHt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jan 2020 00:07:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1580101669; x=1611637669;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=8Np8hgmnq2WhrIwnDAbJU//tSHUZ95CGVkqc8Ph52tQ=;
  b=K1zdDq08tpOQyvuBYT7xMvKHVAPqvAfQI+p7spWfjbGxh+ZDOAP+FMFI
   OZIhHtPvu3b6N5Swo68PrkdYHREa4mO3T7iYI0fV9ptzgWBw8GaE2j91i
   vx0iO4jaEKHCYBRzOaffxGE/H6vdWSsCRJ75k48M9lUzzrN7QdZUn2+Nn
   MApCZXrZblp/OOSE+9rHBo20OI0pOHWvgKfezigjUrQOQAipvY8AqDlWI
   Kfd4hnvJCXmuplcZSFi6ycxazpO0Er2hnautVZ5vXwDSuoWzXuA5yiryU
   OX9rDl03Ajk/JGYzNqZ8FOp2B64TgDlHr+f1ACkoCY+rs4VbFnxHOOABb
   w==;
IronPort-SDR: rKMe4SNX+NNRSTWMvWW1d8kgZb8UlRjZiQGO+7o/2chIl/vkNCWSbIz19Zn+nQGQtQxCDLfp8H
 6uDoyIlYXCyMqRZ2YrgdqMUUzx0AcOCJJ5ksILPGIKEmcFfKLk6y5b5SzZQ8jwxHvDwik1CPIS
 OZBWkGbK+L2lrqUt3QEoEN/TJmcHlgILf7XTf/g3mbCCnltRaEXFag1CCsSOD1p+vB6bhPhsr8
 QFGLgx+AFJUVbd95B1fEK7Xl7vu6PZFXb1sblrQ5GQhuWavyWW3oqso4+2QosGRFjSYnE2/9zq
 dbw=
X-IronPort-AV: E=Sophos;i="5.70,368,1574092800"; 
   d="scan'208";a="129913800"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 27 Jan 2020 13:07:49 +0800
IronPort-SDR: Tn8XA/FWn4VAi4NFt8qjmPRY+0HR9wSRPPINeWp6I6S0Sh9SWqdUMJgM221zPc10r3wOnnnWbR
 Bp5KaQeGOUO2F6Em2VoTPYcLmg3vWZRsFuKdIkzWFrGc+dZRKrSgJkaSjJTrFr+vNfrASVirhc
 +HjRblzWe2BopmnvAcdtXeExsrbA62kwtp21ZTg+rqH/tYi9nDf4+1Nsnf/XIsa9mti8RIaVwr
 HrHP0hqPtYbjYeNJtWE/SQMurR0lSvmT12qB0eFk4841vK4GfJBEfUk1eBnuiut86M5r39XCwp
 p1GjU4pfie+tYAyKDUBC9T7M
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2020 21:01:04 -0800
IronPort-SDR: Ndn6vtCT1w95arzq2EmKO/3Ef3Mqa39EtGTSp5x/4xwNuzzdwK/ruv0SRbwk7VrTWNvaXeDkr6
 LWw6sqDg+D7irmQKY0JjwvCp7NWNpFdYm84bbGfWK+t68vm0D1TDEswgQPfwIyhcFv+x2w26hS
 1SoI1XFfrAM8qX/LQz0pS6WMhnoNQEpk1METZHLBfsbctcQLblMXv1Oi6HwFZjna6S1r7WMtHR
 1QLzbCzZ34x41u38xFi7WeKKoTa5MIFzsJDT12hw9FE+mI/uzuBP2Gz2XXWnWsNXsOMuzMY1td
 a+s=
WDCIronportException: Internal
Received: from yusei.dhcp.fujisawa.hgst.com ([10.149.53.79])
  by uls-op-cesaip01.wdc.com with ESMTP; 26 Jan 2020 21:07:47 -0800
From:   Masato Suzuki <masato.suzuki@wdc.com>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH] sd: Fix REQ_OP_ZONE_REPORT completion handling
Date:   Mon, 27 Jan 2020 14:07:46 +0900
Message-Id: <20200127050746.136440-1-masato.suzuki@wdc.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

ZBC/ZAC report zones command may return less bytes than requested if the
number of matching zones for the report request is small. However, unlike
read or write commands, the remainder of incomplete report zones commands
cannot be automatically requested by the block layer: the start sector of
the next report cannot be known, and the report reply may not be 512B
aligned for SAS drives (a report zone reply size is always a multiple of
64B). The regular request completion code executing bio_advance() and
restart of the command remainder part currently causes invalid zone
descriptor data to be reported to the caller if the report zone size is
smaller than 512B (a case that can happen easily for a report of the last
zones of a SAS drive for example).

Since blkdev_report_zones() handles report zone command processing in a
loop until completion (no more zones are being reported), we can safely
avoid that the block layer performs an incorrect bio_advance() call and
restart of the remainder of incomplete report zone BIOs. To do so, always
indicate a full completion of REQ_OP_ZONE_REPORT by setting good_bytes to
the request buffer size and by setting the command resid to 0. This does
not affect the post processing of the report zone reply done by
sd_zbc_complete() since the reply header indicates the number of zones
reported.

Fixes: 89d947561077 ("sd: Implement support for ZBC devices")
Cc: <stable@vger.kernel.org> # 4.19
Cc: <stable@vger.kernel.org> # 4.14
Signed-off-by: Masato Suzuki <masato.suzuki@wdc.com>
---
 drivers/scsi/sd.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 2955b856e9ec..e8c2afbb82e9 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1981,9 +1981,13 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 		}
 		break;
 	case REQ_OP_ZONE_REPORT:
+		/* To avoid that the block layer performs an incorrect
+		 * bio_advance() call and restart of the remainder of
+		 * incomplete report zone BIOs, always indicate a full
+		 * completion of REQ_OP_ZONE_REPORT.
+		 */
 		if (!result) {
-			good_bytes = scsi_bufflen(SCpnt)
-				- scsi_get_resid(SCpnt);
+			good_bytes = scsi_bufflen(SCpnt);
 			scsi_set_resid(SCpnt, 0);
 		} else {
 			good_bytes = 0;
-- 
2.24.1

