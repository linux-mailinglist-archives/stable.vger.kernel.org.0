Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9307A1647DF
	for <lists+stable@lfdr.de>; Wed, 19 Feb 2020 16:09:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726634AbgBSPJe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Feb 2020 10:09:34 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:28856 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726700AbgBSPJd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Feb 2020 10:09:33 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01JF41m7126839
        for <stable@vger.kernel.org>; Wed, 19 Feb 2020 10:09:32 -0500
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2y8uba0xt3-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Wed, 19 Feb 2020 10:09:32 -0500
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <stable@vger.kernel.org> from <bblock@linux.ibm.com>;
        Wed, 19 Feb 2020 15:09:30 -0000
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 19 Feb 2020 15:09:27 -0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01JF9PgR54788154
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Feb 2020 15:09:25 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 61E0C52057;
        Wed, 19 Feb 2020 15:09:25 +0000 (GMT)
Received: from t480-pf1aa2c2 (unknown [9.152.212.144])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTPS id 4FD1F5204F;
        Wed, 19 Feb 2020 15:09:25 +0000 (GMT)
Received: from bblock by t480-pf1aa2c2 with local (Exim 4.92.3)
        (envelope-from <bblock@linux.ibm.com>)
        id 1j4Qyb-0047kL-1z; Wed, 19 Feb 2020 16:09:25 +0100
From:   Benjamin Block <bblock@linux.ibm.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Benjamin Block <bblock@linux.ibm.com>,
        Steffen Maier <maier@linux.ibm.com>,
        Fedor Loshakov <loshakov@linux.ibm.com>,
        Jens Remus <jremus@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH] zfcp: fix wrong data and display format of SFP+ temperature
Date:   Wed, 19 Feb 2020 16:09:25 +0100
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Organization: IBM Deutschland Research & Development GmbH, Vorsitz. AufsR. Gregor Pillen, Geschaeftsfuehrung Dirk Wittkopp, Sitz der Gesellschaft Boeblingen, Registergericht AmtsG Stuttgart, HRB 243294
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 20021915-0016-0000-0000-000002E84E59
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20021915-0017-0000-0000-0000334B672F
Message-Id: <d6e3be5428da5c9490cfff4df7cae868bc9f1a7e.1582039501.git.bblock@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-19_03:2020-02-19,2020-02-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 mlxlogscore=999 impostorscore=0 phishscore=0 lowpriorityscore=0
 priorityscore=1501 clxscore=1011 mlxscore=0 malwarescore=0 adultscore=0
 spamscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002190115
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When implementing support for retrieval of local diagnostic data from
the FCP channel, the wrong data format was assumed for the temperature
of the local SFP+ connector. The Fibre Channel Link Services (FC-LS-3)
specification is not clear on the format of the stored integer, and only
after consulting the SNIA specification SFF-8472 did we realize it is
stored as two's complement. Thus, the used data and display format is
wrong, and highly misleading for users when the temperature should drop
below 0°C (however unlikely that may be).

To fix this, change the data format in `struct fsf_qtcb_bottom_port`
from unsigned to signed, and change the printf format string used to
generate `zfcp_sysfs_adapter_diag_sfp_temperature_show()` from `%hu` to
`%hd`.

Fixes: a10a61e807b0 ("scsi: zfcp: support retrieval of SFP Data via Exchange Port Data")
Fixes: 6028f7c4cd87 ("scsi: zfcp: introduce sysfs interface for diagnostics of local SFP transceiver")
Cc: <stable@vger.kernel.org> # 5.5+
Reviewed-by: Jens Remus <jremus@linux.ibm.com>
Reviewed-by: Fedor Loshakov <loshakov@linux.ibm.com>
Reviewed-by: Steffen Maier <maier@linux.ibm.com>
Signed-off-by: Benjamin Block <bblock@linux.ibm.com>
---

Hello James, Martin,

please consider this patch to be included in scsi-fixes, I also tagged
it for stable. It fixes a bug I found with the exposed hardware
diagnostics we introduced with 5.5.

Tests have been done by injecting negative temperatures in the used data
structures, in the same format specified in SNIA's SFF-8472 (Table
9-2).

    crash vmlinux /proc/kcore
    p ((struct zfcp_adapter *)((struct ccw_device *)0x00000001be250800)->dev.driver_data)->diagnostics->port_data.data.temperature
    $8 = 0xffff
    crash> ^Z
    [1]+  Stopped                 crash vmlinux /proc/kcore
    ~ # cat /sys/bus/ccw/drivers/zfcp/0.0.1900/diagnostics/temperature
    -1

    crash vmlinux /proc/kcore
    p ((struct zfcp_adapter *)((struct ccw_device *)0x00000001be250800)->dev.driver_data)->diagnostics->port_data.data.temperature
    $9 = 0xff00
    crash> ^Z
    [1]+  Stopped                 crash vmlinux /proc/kcore
    ~ # cat /sys/bus/ccw/drivers/zfcp/0.0.1900/diagnostics/temperature
    -256

Reviews and comments are welcome :-).


 drivers/s390/scsi/zfcp_fsf.h   | 2 +-
 drivers/s390/scsi/zfcp_sysfs.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_fsf.h b/drivers/s390/scsi/zfcp_fsf.h
index 2b1e4da1944f..4bfb79f20588 100644
--- a/drivers/s390/scsi/zfcp_fsf.h
+++ b/drivers/s390/scsi/zfcp_fsf.h
@@ -410,7 +410,7 @@ struct fsf_qtcb_bottom_port {
 	u8 cb_util;
 	u8 a_util;
 	u8 res2;
-	u16 temperature;
+	s16 temperature;
 	u16 vcc;
 	u16 tx_bias;
 	u16 tx_power;
diff --git a/drivers/s390/scsi/zfcp_sysfs.c b/drivers/s390/scsi/zfcp_sysfs.c
index 494b9fe9cc94..a711a0d15100 100644
--- a/drivers/s390/scsi/zfcp_sysfs.c
+++ b/drivers/s390/scsi/zfcp_sysfs.c
@@ -800,7 +800,7 @@ static ZFCP_DEV_ATTR(adapter_diag, b2b_credit, 0400,
 	static ZFCP_DEV_ATTR(adapter_diag_sfp, _name, 0400,		       \
 			     zfcp_sysfs_adapter_diag_sfp_##_name##_show, NULL)
 
-ZFCP_DEFINE_DIAG_SFP_ATTR(temperature, temperature, 5, "%hu");
+ZFCP_DEFINE_DIAG_SFP_ATTR(temperature, temperature, 6, "%hd");
 ZFCP_DEFINE_DIAG_SFP_ATTR(vcc, vcc, 5, "%hu");
 ZFCP_DEFINE_DIAG_SFP_ATTR(tx_bias, tx_bias, 5, "%hu");
 ZFCP_DEFINE_DIAG_SFP_ATTR(tx_power, tx_power, 5, "%hu");
-- 
2.24.1

