Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FE213B1495
	for <lists+stable@lfdr.de>; Wed, 23 Jun 2021 09:28:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229950AbhFWHa5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Jun 2021 03:30:57 -0400
Received: from mx0a-0014ca01.pphosted.com ([208.84.65.235]:27964 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229660AbhFWHa4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Jun 2021 03:30:56 -0400
Received: from pps.filterd (m0042385.ppops.net [127.0.0.1])
        by mx0a-0014ca01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15N7MUOg031639;
        Wed, 23 Jun 2021 00:28:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=proofpoint;
 bh=V6LfZns1Rx6q09j+7fQChFzpv7poXq0I7t3I1D6DBFU=;
 b=I59oQPyH/R8NfNyWMLiIT3A2+o+LJAGcIv4HKi32mjGhlvIrMR70HHdrM2GHP0dSQtp/
 xKWFAs4B0Udepc0G/gwS3z+asUpLD++oGMvyVz3gePXU1bgiM/ID0QOFw9FNcdZS7pDE
 qugvDlOs1BGZ6SsWppvUwmuHSHcpqfPUQLQ4QhYLJbJLU0w+eFQDUtX/IDL+2Px0BfAo
 T3YStxZZZ1dNM80DNojRi1k9U64aGvLKIEkCoY0SwO5626V/m3dx3UKtctx29rOgGpnq
 U1oNlJZTm5DkRxClWjuy13x7XWKRTKKJp72WaCRsAsUb+nSqw1jRlRF2hBfBA5zhnJEN 8g== 
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2043.outbound.protection.outlook.com [104.47.73.43])
        by mx0a-0014ca01.pphosted.com with ESMTP id 39apms84qe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Jun 2021 00:28:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gvh84eZ+Q0CUlB/g7slnAzA8KYadfyOWWjLwkNUgmjRiaIwS/HXh8NnOudDiKTrsbYFQHGabEFAbj4w07Vnx4rjuXdFXWMtH4+sWCAMUEj48CotjEj9EihVia1ppYDPdBpDNfSH6Cz1GJ8RAovLdLdrmmjAuvQddHExrMasjOKD6ifFR850lrEIfYqPDO45gbFyguChIP60jQNJUy2Ido6utJPgITHAYUK3IXy1NqiZruEs4bmkrlOJvcKQ5UnhhpDNFWbBcksyTGFc5D1LGSubnQKlaEeCzWYUa2e78hlZEk4NQFaDSNcTjOB0YPbca8fnNx9MPNCi/nFIP/1viJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V6LfZns1Rx6q09j+7fQChFzpv7poXq0I7t3I1D6DBFU=;
 b=jTMG3QH48MX5mOAdAyw31RuMr3Q5m/VbUUt7S8EEW722z3HSlQJOHcnOm0Jw9tbyDeFHD6OOB1hSgSiB6a8BtYzGTxcOTVWnWah7jBrXfI0Ik6YHHVZkMkWjmsyCChCtfBqLlFv6dXEwSSiLBVP773RRCWuYmkcRhDaMQHAU0qHPewOE4EBOhR+zPvhdzlVnVOiuZ+5rPK7zpIuFNK/vsJMMpmCN51BEIwckijo5yhbCMb0H2fF1DxB0LhP/8o+Id4kRmmVYzf+urDBOjz+ClQvu5DUtV8rqxLWZZ30Xb+wX9IFNPVyj4iM9o/HbWZrDAb9jhE9VKh7zQ1+yBVCH0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 64.207.220.244) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=cadence.com; dmarc=pass (p=none sp=none pct=100) action=none
 header.from=cadence.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V6LfZns1Rx6q09j+7fQChFzpv7poXq0I7t3I1D6DBFU=;
 b=TI3FjxewxCBbPD5IPJmG42b011g7z4KQrduhJaT3hWhbrhnKGFOaJPH7If/uirF0a0GtJa3HL0P4q2QVv/HmyJhphG1ibRBWlEtNtriOZxJiEk1AKsO9aNo8G2xT5XmFiSEcu7k6xx9984pcGNwwmgsGxv6z3V8eweNXFJavv2E=
Received: from DM5PR13CA0065.namprd13.prod.outlook.com (2603:10b6:3:117::27)
 by SN6PR07MB5278.namprd07.prod.outlook.com (2603:10b6:805:76::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.22; Wed, 23 Jun
 2021 07:28:35 +0000
Received: from DM6NAM12FT061.eop-nam12.prod.protection.outlook.com
 (2603:10b6:3:117:cafe::85) by DM5PR13CA0065.outlook.office365.com
 (2603:10b6:3:117::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.7 via Frontend
 Transport; Wed, 23 Jun 2021 07:28:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 64.207.220.244)
 smtp.mailfrom=cadence.com; linuxfoundation.org; dkim=none (message not
 signed) header.d=none;linuxfoundation.org; dmarc=pass action=none
 header.from=cadence.com;
Received-SPF: Pass (protection.outlook.com: domain of cadence.com designates
 64.207.220.244 as permitted sender) receiver=protection.outlook.com;
 client-ip=64.207.220.244; helo=wcmailrelayl01.cadence.com;
Received: from wcmailrelayl01.cadence.com (64.207.220.244) by
 DM6NAM12FT061.mail.protection.outlook.com (10.13.179.123) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4264.10 via Frontend Transport; Wed, 23 Jun 2021 07:28:33 +0000
Received: from maileu3.global.cadence.com (maileu3.cadence.com [10.160.88.99])
        by wcmailrelayl01.cadence.com (8.14.7/8.14.4) with ESMTP id 15N7SUUP026158
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=OK);
        Wed, 23 Jun 2021 00:28:31 -0700
X-CrossPremisesHeadersFilteredBySendConnector: maileu3.global.cadence.com
Received: from maileu3.global.cadence.com (10.160.88.99) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 23 Jun 2021 09:28:29 +0200
Received: from gli-login.cadence.com (10.187.128.100) by
 maileu3.global.cadence.com (10.160.88.99) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Wed, 23 Jun 2021 09:28:29 +0200
Received: from gli-login.cadence.com (localhost [127.0.0.1])
        by gli-login.cadence.com (8.14.4/8.14.4) with ESMTP id 15N7STUC042955;
        Wed, 23 Jun 2021 09:28:29 +0200
Received: (from pawell@localhost)
        by gli-login.cadence.com (8.14.4/8.14.4/Submit) id 15N7SSHR042954;
        Wed, 23 Jun 2021 09:28:28 +0200
From:   Pawel Laszczak <pawell@cadence.com>
To:     <peter.chen@kernel.org>
CC:     <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kurahul@cadence.com>,
        Pawel Laszczak <pawell@cadence.com>, <stable@vger.kernel.org>
Subject: [PATCH] usb: cdnsp: Fixed issue with ZLP
Date:   Wed, 23 Jun 2021 09:27:28 +0200
Message-ID: <20210623072728.41275-1-pawell@gli-login.cadence.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-OrganizationHeadersPreserved: maileu3.global.cadence.com
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eeb14899-9143-477d-74e4-08d936188201
X-MS-TrafficTypeDiagnostic: SN6PR07MB5278:
X-Microsoft-Antispam-PRVS: <SN6PR07MB52789F78E35C297A7F683D39DD089@SN6PR07MB5278.namprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cNRV6iJ4c9oxzOlUBW4ruHuQIG8BwmTEEUhksnXqqgz7muw1JW7b3gRmHygCmxSVMaoai9+uYNgDHV/mPJOkpbgLWhwSTY998cTKTTOummQMhbOnzAihzBQ5mUFzHB+67+wNqw+klvVSWzCuEZnT2yASOyjaTplkolkuwAuBlN3M51cVIFRj5+DtkFnOVj/cG/Adr/q9644Ecib2vPIpsg38DgzphGuDcZlVSD5BWE+kmy4hJm/BczJs3wqEWcdWxXUxFZj4/GH+y3FBozSkXqflKVkmrhpkt2ao63qk20Tj30ipskoR3uysVvcvwZ0mkJ34RIYBE9967fGksIgYOCrpCVPFBNHlyNL9kWVFVNHDbkHjCyRBUZziixMF5qKJlKx8TCpMAkRkPIUtZ5totgJlFQPjzYZyiOTTHSgn64g9GTlVSHBHRepkhTtfdCti9hRVmn27BiDYjCSeXxn/PJ+mdhItPRxDTlMQUl46KEYg8yLkY88wTTaByChOLrelrp50rJ0itbriMulFefEjb2lXn/iVZmF4B1g0Uq+jA5AF2MpEufXqkqJgF0j4st+aoKibb0V0qKU5I1QR2grvdxRtP04M9DDV0HYkZE2h58Cf4sxpGYKEkdXvEsYd1VcVpSOB6tkOjcDU2V2mwi1O4Tojhom3wod7h02nMC8IyTCCoQ9/u92W6oGPapOAf5hTC/XHYLf9ukOSwo+CZLiWLA==
X-Forefront-Antispam-Report: CIP:64.207.220.244;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:wcmailrelayl01.cadence.com;PTR:ErrorRetry;CAT:NONE;SFS:(4636009)(136003)(39860400002)(376002)(396003)(346002)(36092001)(46966006)(36840700001)(4326008)(5660300002)(36860700001)(6916009)(70206006)(86362001)(8936002)(8676002)(82310400003)(70586007)(82740400003)(2906002)(356005)(81166007)(478600001)(426003)(186003)(83380400001)(336012)(1076003)(42186006)(316002)(54906003)(26005)(47076005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2021 07:28:33.6785
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: eeb14899-9143-477d-74e4-08d936188201
X-MS-Exchange-CrossTenant-Id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d36035c5-6ce6-4662-a3dc-e762e61ae4c9;Ip=[64.207.220.244];Helo=[wcmailrelayl01.cadence.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM12FT061.eop-nam12.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR07MB5278
X-Proofpoint-ORIG-GUID: Z-RiFeO0ayjBvw7rhSTywJbLV0EO3oJD
X-Proofpoint-GUID: Z-RiFeO0ayjBvw7rhSTywJbLV0EO3oJD
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-06-23_02:2021-06-22,2021-06-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0 suspectscore=0
 mlxlogscore=797 phishscore=0 lowpriorityscore=0 spamscore=0
 priorityscore=1501 impostorscore=0 adultscore=0 bulkscore=0 mlxscore=0
 clxscore=1015 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104190000 definitions=main-2106230043
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pawel Laszczak <pawell@cadence.com>

The condition "if (need_zero_pkt && zero_len_trb)" was always false
and it caused that TRB for ZLP was not prepared.

Fix causes that after preparing last TRB in TD, the driver prepares
additional TD with ZLP when a ZLP is required.

Cc: <stable@vger.kernel.org>
Fixes: 3d82904559f4 ("usb: cdnsp: cdns3 Add main part of Cadence USBSSP DRD Driver")
Signed-off-by: Pawel Laszczak <pawell@cadence.com>
---
 drivers/usb/cdns3/cdnsp-ring.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/usb/cdns3/cdnsp-ring.c b/drivers/usb/cdns3/cdnsp-ring.c
index 68972746e363..1b1438457fb0 100644
--- a/drivers/usb/cdns3/cdnsp-ring.c
+++ b/drivers/usb/cdns3/cdnsp-ring.c
@@ -1932,15 +1932,13 @@ int cdnsp_queue_bulk_tx(struct cdnsp_device *pdev, struct cdnsp_request *preq)
 		}
 
 		if (enqd_len + trb_buff_len >= full_len) {
-			if (need_zero_pkt && zero_len_trb) {
-				zero_len_trb = true;
-			} else {
-				field &= ~TRB_CHAIN;
-				field |= TRB_IOC;
-				more_trbs_coming = false;
-				need_zero_pkt = false;
-				preq->td.last_trb = ring->enqueue;
-			}
+			if (need_zero_pkt)
+				zero_len_trb = !zero_len_trb;
+
+			field &= ~TRB_CHAIN;
+			field |= TRB_IOC;
+			more_trbs_coming = false;
+			preq->td.last_trb = ring->enqueue;
 		}
 
 		/* Only set interrupt on short packet for OUT endpoints. */
@@ -1955,7 +1953,7 @@ int cdnsp_queue_bulk_tx(struct cdnsp_device *pdev, struct cdnsp_request *preq)
 		length_field = TRB_LEN(trb_buff_len) | TRB_TD_SIZE(remainder) |
 			TRB_INTR_TARGET(0);
 
-		cdnsp_queue_trb(pdev, ring, more_trbs_coming | need_zero_pkt,
+		cdnsp_queue_trb(pdev, ring, more_trbs_coming | zero_len_trb,
 				lower_32_bits(send_addr),
 				upper_32_bits(send_addr),
 				length_field,
-- 
2.25.1

