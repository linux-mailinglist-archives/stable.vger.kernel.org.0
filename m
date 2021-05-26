Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FBD039104D
	for <lists+stable@lfdr.de>; Wed, 26 May 2021 08:06:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231157AbhEZGHf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 May 2021 02:07:35 -0400
Received: from mx0a-0014ca01.pphosted.com ([208.84.65.235]:25388 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229576AbhEZGHe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 May 2021 02:07:34 -0400
Received: from pps.filterd (m0042385.ppops.net [127.0.0.1])
        by mx0a-0014ca01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14Q62MNm017007;
        Tue, 25 May 2021 23:06:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=proofpoint;
 bh=I97hx2Fqwiso1xlMcv+mbc93j2vuGQX3SWUoHQISzj8=;
 b=VWDk7auOoMnw/BLpz+Q5zFS2CY34n2nx9sWFy0zkzJHc6UtSr0/Ln8jY8pLcOAL5aAOO
 ZasSZdtyfTaDdu9BzSCj16Mm7E77dcODbIFefoew2qHKBWD2kOrs2DnbFgfk1J7VEjVm
 BHbTmjmNjS71X4D/Qass9Wp0awWP0VibWIu7KH5anhgWjpq/1KeTgLXY7t06OrrHU+Vt
 xdR03IVym6igzNfxep6HbkBrdETdhuvDn4tFFfWi89q0dlklIpb3S1bul3FZbTujT0OD
 szrA6QQ9BD+1fbQbDx7fJUGv89S0GAuJJcCOPO2DM2rgJUT8bUH+UbiJZLyr2g4XMM43 Cw== 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2104.outbound.protection.outlook.com [104.47.70.104])
        by mx0a-0014ca01.pphosted.com with ESMTP id 38rdrf73kc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 May 2021 23:06:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dTT9xSDkypj2h/IyBdaM9flWnlkdoNHsAWHpUbjc0h3DG5upKW62x/2HsxJQSfE8dzfaJekMzoLfWlqHe4UeCz3RC4jJHui99SjJIpLpc7WDO5jrAB8/tJMBQrnmN/8cGF5+eDqGDGenptXg26ZbOtM8xnrYbiXriBCxPd8h+3hlKa+NaBbqMoHCczKDtEpwIEHtF1IHEaFYMhWrfU6ml/8EXQYJSSEZbMXxY7+pc3sOvG8c4GgaiJ53RhQIHhC8yM4lLfdW43QPbzScYCSE9OLH/eHedi7sgK+3zDazK7ftn/JBfmjka/ymWMyH19w88PaSsqgjfBki9hVMpi2Sfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I97hx2Fqwiso1xlMcv+mbc93j2vuGQX3SWUoHQISzj8=;
 b=ALgXHpR6k40GjZ+3MaKVBv4Kd3D75+a0hU6qL0c7HvHEa2mCbCPPJ7QOd4s31JWDhUHOQlV7fkPYQbrrjy0JcTyhAikG4zDvTDzfM+xxU0o2iN8QPfiF8YOwMORCK423nFym22sfnrebYM6sz8qiK0AtMVyudPy/v20tUgGTKNP3jt1gUvTlqxHkGWLsd5voBVStFmF/TbnDuT2g+PBhXIQNFpqHDrydkdzH0DHqfMRIrtizun/ny37w96BcwXr5DMiao3IEy8nEf1r4/QeuK8YRgmfOq9zwFmsNvMW8gIVmnU2TZKID/ClVzOKhieRHk9NmgDhnk0EYD7EhU3ykhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 199.43.4.23) smtp.rcpttodomain=linuxfoundation.org smtp.mailfrom=cadence.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=cadence.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I97hx2Fqwiso1xlMcv+mbc93j2vuGQX3SWUoHQISzj8=;
 b=R2J6kEKbYcDC6Q2CQRtzM2pEZhJe006xrlt3SAGOvVbi+y5PObFzGHpaDUkvDdWB1nrfmxGC4N3Xij/g+8HgCQDVnFDSYOhcL5E322y3pRJx1FXhasHHqx/GgK8tHsI/LQgxbcNkxY1g+nNFpXn0szTBa+2ETINHmIAa2TQrZLs=
Received: from BN6PR1701CA0005.namprd17.prod.outlook.com
 (2603:10b6:405:15::15) by DM5PR07MB3020.namprd07.prod.outlook.com
 (2603:10b6:3:e3::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.25; Wed, 26 May
 2021 06:05:57 +0000
Received: from BN8NAM12FT010.eop-nam12.prod.protection.outlook.com
 (2603:10b6:405:15:cafe::41) by BN6PR1701CA0005.outlook.office365.com
 (2603:10b6:405:15::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend
 Transport; Wed, 26 May 2021 06:05:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 199.43.4.23)
 smtp.mailfrom=cadence.com; linuxfoundation.org; dkim=none (message not
 signed) header.d=none;linuxfoundation.org; dmarc=pass action=none
 header.from=cadence.com;
Received-SPF: Pass (protection.outlook.com: domain of cadence.com designates
 199.43.4.23 as permitted sender) receiver=protection.outlook.com;
 client-ip=199.43.4.23; helo=rmmaillnx1.cadence.com;
Received: from rmmaillnx1.cadence.com (199.43.4.23) by
 BN8NAM12FT010.mail.protection.outlook.com (10.13.182.62) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4150.11 via Frontend Transport; Wed, 26 May 2021 06:05:56 +0000
Received: from maileu3.global.cadence.com (maileu3.cadence.com [10.160.88.99])
        by rmmaillnx1.cadence.com (8.14.4/8.14.4) with ESMTP id 14Q65tM8024173
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 May 2021 02:05:55 -0400
X-CrossPremisesHeadersFilteredBySendConnector: maileu3.global.cadence.com
Received: from maileu3.global.cadence.com (10.160.88.99) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 26 May 2021 08:05:54 +0200
Received: from gli-login.cadence.com (10.187.128.100) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Wed, 26 May 2021 08:05:53 +0200
Received: from gli-login.cadence.com (localhost [127.0.0.1])
        by gli-login.cadence.com (8.14.4/8.14.4) with ESMTP id 14Q65qep008001;
        Wed, 26 May 2021 08:05:52 +0200
Received: (from pawell@localhost)
        by gli-login.cadence.com (8.14.4/8.14.4/Submit) id 14Q65qnT007903;
        Wed, 26 May 2021 08:05:52 +0200
From:   Pawel Laszczak <pawell@cadence.com>
To:     <peter.chen@kernel.org>
CC:     <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <kurahul@cadence.com>, Pawel Laszczak <pawell@cadence.com>,
        <stable@vger.kernel.org>
Subject: [PATCH v2] usb: cdnsp: Fix deadlock issue in cdnsp_thread_irq_handler
Date:   Wed, 26 May 2021 08:05:27 +0200
Message-ID: <20210526060527.7197-1-pawell@gli-login.cadence.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-OrganizationHeadersPreserved: maileu3.global.cadence.com
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 276e8f1e-2db0-4c39-4c14-08d9200c53e9
X-MS-TrafficTypeDiagnostic: DM5PR07MB3020:
X-Microsoft-Antispam-PRVS: <DM5PR07MB302068F6C8DABD6602AEB7FBDD249@DM5PR07MB3020.namprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:177;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Zr1+i65zkENJWCpOCQR3pToLAdAeRxwC4STOc7hAoZIJ9ajrasw8z7IS2lPkMmMiU4LUUNtajtjgavVF1m/PsPb0UmULzd3On+EUXQCiDusNIkFqnQK53zcua9js8tpBXbSrosGqHSqjMWmgK7OoiLmYlbWVcQvXG/8G9iwWaxuD+PWtsXGLa0KZ1OE4Ji45lMRyJOdXf535/+lcRi9DX08Sq8943wwk1Fn5mQDNyCtdDWA3EKTyCGXZ36NcbAVwyynL9a5G+KRIvH3+q/qS25QxtdkmiUm6IvR+XCc3w1vO2bGp5XQsbbWd4Dpn2UNBl9T4pfVg8XjjzWz/QoVSbRKA6EDRLBPWsy5jZPd0DJ0uCd5rlpmf3TxjdbAfapNfILwXM/fi/DRtxSvFM9VzHc9jttUM1cjq1DER6ZRblAmfrVywhju9HnwwysvJm2BRDYJAlCrv6pZ8PpHwa/8aOfHH0dSjZlB6w0OMKk3r9KV0OWmwsXfQb/8L7UWHfiWkxPxd7bEpOUCIJzBgsMqeVahE1lqB1GpjUUpFvxAx6A7syoVTVlOZwfML7I5K24c9O6z6qwrTJaMXHIVi/QRnSsc+O65R3PAD5K/4tU7Ey78Yh84dVXTilRr/EHBN8tTIyPZVE9ksi+/4UXO+DUEs4FmQDm2e7O0I5uiIYfcAnyVbOwfOyAVXhbQ6WUlBUfL3ntdnXJg3FpPz+3wnQK5CnA==
X-Forefront-Antispam-Report: CIP:199.43.4.23;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:rmmaillnx1.cadence.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(136003)(39860400002)(396003)(376002)(346002)(36092001)(36840700001)(46966006)(5660300002)(4326008)(186003)(8676002)(6666004)(47076005)(6916009)(356005)(26005)(336012)(316002)(478600001)(42186006)(426003)(70206006)(1076003)(81166007)(70586007)(54906003)(36860700001)(83380400001)(8936002)(82740400003)(2906002)(82310400003)(86362001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2021 06:05:56.8900
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 276e8f1e-2db0-4c39-4c14-08d9200c53e9
X-MS-Exchange-CrossTenant-Id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d36035c5-6ce6-4662-a3dc-e762e61ae4c9;Ip=[199.43.4.23];Helo=[rmmaillnx1.cadence.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM12FT010.eop-nam12.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR07MB3020
X-Proofpoint-GUID: zjSDOdwFtS5cR1kh1EtNRgDau4LoJrdq
X-Proofpoint-ORIG-GUID: zjSDOdwFtS5cR1kh1EtNRgDau4LoJrdq
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-26_04:2021-05-25,2021-05-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0 adultscore=0
 suspectscore=0 phishscore=0 lowpriorityscore=0 clxscore=1015
 impostorscore=0 malwarescore=0 priorityscore=1501 mlxscore=0
 mlxlogscore=739 spamscore=0 bulkscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105260040
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pawel Laszczak <pawell@cadence.com>

Patch fixes the following critical issue caused by deadlock which has been
detected during testing NCM class:

smp: csd: Detected non-responsive CSD lock (#1) on CPU#0
smp:     csd: CSD lock (#1) unresponsive.
....
RIP: 0010:native_queued_spin_lock_slowpath+0x61/0x1d0
RSP: 0018:ffffbc494011cde0 EFLAGS: 00000002
RAX: 0000000000000101 RBX: ffff9ee8116b4a68 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff9ee8116b4658
RBP: ffffbc494011cde0 R08: 0000000000000001 R09: 0000000000000000
R10: ffff9ee8116b4670 R11: 0000000000000000 R12: ffff9ee8116b4658
R13: ffff9ee8116b4670 R14: 0000000000000246 R15: ffff9ee8116b4658
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f7bcc41a830 CR3: 000000007a612003 CR4: 00000000001706e0
Call Trace:
 <IRQ>
 do_raw_spin_lock+0xc0/0xd0
 _raw_spin_lock_irqsave+0x95/0xa0
 cdnsp_gadget_ep_queue.cold+0x88/0x107 [cdnsp_udc_pci]
 usb_ep_queue+0x35/0x110
 eth_start_xmit+0x220/0x3d0 [u_ether]
 ncm_tx_timeout+0x34/0x40 [usb_f_ncm]
 ? ncm_free_inst+0x50/0x50 [usb_f_ncm]
 __hrtimer_run_queues+0xac/0x440
 hrtimer_run_softirq+0x8c/0xb0
 __do_softirq+0xcf/0x428
 asm_call_irq_on_stack+0x12/0x20
 </IRQ>
 do_softirq_own_stack+0x61/0x70
 irq_exit_rcu+0xc1/0xd0
 sysvec_apic_timer_interrupt+0x52/0xb0
 asm_sysvec_apic_timer_interrupt+0x12/0x20
RIP: 0010:do_raw_spin_trylock+0x18/0x40
RSP: 0018:ffffbc494138bda8 EFLAGS: 00000246
RAX: 0000000000000000 RBX: ffff9ee8116b4658 RCX: 0000000000000000
RDX: 0000000000000001 RSI: 0000000000000000 RDI: ffff9ee8116b4658
RBP: ffffbc494138bda8 R08: 0000000000000001 R09: 0000000000000000
R10: ffff9ee8116b4670 R11: 0000000000000000 R12: ffff9ee8116b4658
R13: ffff9ee8116b4670 R14: ffff9ee7b5c73d80 R15: ffff9ee8116b4000
 _raw_spin_lock+0x3d/0x70
 ? cdnsp_thread_irq_handler.cold+0x32/0x112c [cdnsp_udc_pci]
 cdnsp_thread_irq_handler.cold+0x32/0x112c [cdnsp_udc_pci]
 ? cdnsp_remove_request+0x1f0/0x1f0 [cdnsp_udc_pci]
 ? cdnsp_thread_irq_handler+0x5/0xa0 [cdnsp_udc_pci]
 ? irq_thread+0xa0/0x1c0
 irq_thread_fn+0x28/0x60
 irq_thread+0x105/0x1c0
 ? __kthread_parkme+0x42/0x90
 ? irq_forced_thread_fn+0x90/0x90
 ? wake_threads_waitq+0x30/0x30
 ? irq_thread_check_affinity+0xe0/0xe0
 kthread+0x12a/0x160
 ? kthread_park+0x90/0x90
 ret_from_fork+0x22/0x30

The root cause of issue is spin_lock/spin_unlock instruction instead
spin_lock_irqsave/spin_lock_irqrestore in cdnsp_thread_irq_handler
function.

Cc: stable@vger.kernel.org
Fixes: 3d82904559f4 ("usb: cdnsp: cdns3 Add main part of Cadence USBSSP DRD Driver")
Signed-off-by: Pawel Laszczak <pawell@cadence.com>

---
Changelog:
v2:
- updated commit message

 drivers/usb/cdns3/cdnsp-ring.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/cdns3/cdnsp-ring.c b/drivers/usb/cdns3/cdnsp-ring.c
index 5f0513c96c04..68972746e363 100644
--- a/drivers/usb/cdns3/cdnsp-ring.c
+++ b/drivers/usb/cdns3/cdnsp-ring.c
@@ -1517,13 +1517,14 @@ irqreturn_t cdnsp_thread_irq_handler(int irq, void *data)
 {
 	struct cdnsp_device *pdev = (struct cdnsp_device *)data;
 	union cdnsp_trb *event_ring_deq;
+	unsigned long flags;
 	int counter = 0;
 
-	spin_lock(&pdev->lock);
+	spin_lock_irqsave(&pdev->lock, flags);
 
 	if (pdev->cdnsp_state & (CDNSP_STATE_HALTED | CDNSP_STATE_DYING)) {
 		cdnsp_died(pdev);
-		spin_unlock(&pdev->lock);
+		spin_unlock_irqrestore(&pdev->lock, flags);
 		return IRQ_HANDLED;
 	}
 
@@ -1539,7 +1540,7 @@ irqreturn_t cdnsp_thread_irq_handler(int irq, void *data)
 
 	cdnsp_update_erst_dequeue(pdev, event_ring_deq, 1);
 
-	spin_unlock(&pdev->lock);
+	spin_unlock_irqrestore(&pdev->lock, flags);
 
 	return IRQ_HANDLED;
 }
-- 
2.25.1

