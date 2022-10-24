Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD56160B446
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 19:35:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233029AbiJXRfN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 13:35:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233237AbiJXRex (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 13:34:53 -0400
Received: from mx0a-0014ca01.pphosted.com (mx0a-0014ca01.pphosted.com [208.84.65.235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79C1A4DF13;
        Mon, 24 Oct 2022 09:09:52 -0700 (PDT)
Received: from pps.filterd (m0042385.ppops.net [127.0.0.1])
        by mx0a-0014ca01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29OCu0pT011978;
        Mon, 24 Oct 2022 07:04:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=proofpoint;
 bh=/pk38fEZ9U0+nRNaqE9OQAzzGVgDKqaCIE5yNVgKWZU=;
 b=Gbt7rWGO+gU4SbmxkflEj+uVO8bmRjccs3rk0hkDaH8GORI/Rv3LjQ2Dpd55P6QToMRR
 d41el+UdBN9oRf+IZGPpjQmJeBfhpJ/TNU83WBi1toEzJ+7QMEXdjt8Dn4vfWsX6GM4X
 2rK0Yknc6+HzD2O4lzoaIHZXHjLz+G86o3rck9PuFoWri3toHoru2qdRR91eFmDqo+Pz
 YZQ+TIKRhxEgboKpt6bpGSHQ+p0WaMEhH97T7oRoJ1W44NmjcmMhC0iuptiHqquqGJbV
 RZ2lNEkp97vrxRnWFG3koBgTcMvinWBB1rU/gx7wbexmbMtkB+I7myGOMBPxWqY2dqIm Og== 
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2049.outbound.protection.outlook.com [104.47.74.49])
        by mx0a-0014ca01.pphosted.com (PPS) with ESMTPS id 3kcd30rex2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Oct 2022 07:04:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WlHDOm/tLup3L4hgHeUlBNMDV+4ySZ3hW/935urcMP61tBHKgjKcdnjIIEZZZXCpNz8FLt23+Fi3RAx/gNiO7uk8xe5Q4c9sAcYXIXaXICejPTCJu2aZ2pLcPaRNtm2bkLAadBA+zu7bXZyOPweq6arM9ttSK62pQ1kSxPLrroOVLbEkyThtmHSstaU61zPZvXc2FSfmskb0R//tqMNvyH7DRD+/rxbq+8oOs5FBEkDAvujSLYngAKX292mSlJe4suwRHzDdoDacRYKDLuxCCHwIb+X33F7sXU207/Qv5yYOiG/K7SVdSXja3oXi2zVgzD7Xe85c63IxTxDEYjUmsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/pk38fEZ9U0+nRNaqE9OQAzzGVgDKqaCIE5yNVgKWZU=;
 b=ksBvzV+/bfv5H+tEufqDiR+z3EgStM459rfPRYV8KKCHvYWB+cuLvLrXBEDGy1SojpgRzRyedBncjOXRer47zxPsTmEFN+hvqdl6RhigT8NimSRgc+r86d+fqnjVy7gTj4XL+o6x+aSpx5oalJJeypH//VnSIoqIVTExziFbm/Fdv5LoRhlZ+6ntuSNul7t1XxEZxjZZwu14d/32NTa0OAnt5oXgwRayvBBgI12pP9T1fq8/tpqSwrzCYC9H0plD5kXfGK1J2+k2Dve2enbf4AHV2jjR7SJSRZAHgNdOtnz6TDzaOYvb8I/lLPms4JntvL1gPB43NWdTbWixECxlbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 158.140.1.147) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=cadence.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=cadence.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/pk38fEZ9U0+nRNaqE9OQAzzGVgDKqaCIE5yNVgKWZU=;
 b=03Kw9fEZEBOyZYjM7x1+NnFSuC5ZaXB7xMoTs18WuOBN5VJWg8jApeOnG5bC1QN5uekFIbRCW3/qbl4r4zJtF1PkqHz4fzAiIrMrZOaUSEula65jTjORIU3zoV4YpoD5NUhWg2dwGql21qP9f8zNPGj6oZ6LvIchZ9K0I0X+dpg=
Received: from MW4P221CA0007.NAMP221.PROD.OUTLOOK.COM (2603:10b6:303:8b::12)
 by PH8PR07MB9582.namprd07.prod.outlook.com (2603:10b6:510:225::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.29; Mon, 24 Oct
 2022 14:04:53 +0000
Received: from MW2NAM12FT010.eop-nam12.prod.protection.outlook.com
 (2603:10b6:303:8b:cafe::db) by MW4P221CA0007.outlook.office365.com
 (2603:10b6:303:8b::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.26 via Frontend
 Transport; Mon, 24 Oct 2022 14:04:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 158.140.1.147)
 smtp.mailfrom=cadence.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=cadence.com;
Received-SPF: Pass (protection.outlook.com: domain of cadence.com designates
 158.140.1.147 as permitted sender) receiver=protection.outlook.com;
 client-ip=158.140.1.147; helo=sjmaillnx1.cadence.com; pr=C
Received: from sjmaillnx1.cadence.com (158.140.1.147) by
 MW2NAM12FT010.mail.protection.outlook.com (10.13.180.77) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5769.10 via Frontend Transport; Mon, 24 Oct 2022 14:04:52 +0000
Received: from maileu4.global.cadence.com (eudvw-maileu4.cadence.com [10.160.110.201])
        by sjmaillnx1.cadence.com (8.14.4/8.14.4) with ESMTP id 29OE4o46005187
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Oct 2022 07:04:51 -0700
Received: from maileu5.global.cadence.com (10.160.110.202) by
 maileu4.global.cadence.com (10.160.110.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Mon, 24 Oct 2022 16:04:49 +0200
Received: from eu-cn01.cadence.com (10.160.89.184) by
 maileu5.global.cadence.com (10.160.110.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24 via Frontend Transport; Mon, 24 Oct 2022 16:04:49 +0200
Received: from eu-cn01.cadence.com (localhost.localdomain [127.0.0.1])
        by eu-cn01.cadence.com (8.14.7/8.14.7) with ESMTP id 29OE4naR139902;
        Mon, 24 Oct 2022 10:04:49 -0400
Received: (from pawell@localhost)
        by eu-cn01.cadence.com (8.14.7/8.14.7/Submit) id 29OE4nnV139899;
        Mon, 24 Oct 2022 10:04:49 -0400
From:   Pawel Laszczak <pawell@cadence.com>
To:     <peter.chen@kernel.org>
CC:     <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Pawel Laszczak <pawell@cadence.com>, <stable@vger.kernel.org>
Subject: [PATCH v2] usb: cdnsp: fix issue with ZLP - added TD_SIZE = 1
Date:   Mon, 24 Oct 2022 10:04:35 -0400
Message-ID: <1666620275-139704-1-git-send-email-pawell@cadence.com>
X-Mailer: git-send-email 2.4.5
MIME-Version: 1.0
Content-Type: text/plain
X-CrossPremisesHeadersFilteredBySendConnector: maileu4.global.cadence.com
X-OrganizationHeadersPreserved: maileu4.global.cadence.com
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW2NAM12FT010:EE_|PH8PR07MB9582:EE_
X-MS-Office365-Filtering-Correlation-Id: f13f8119-9b9d-481b-52aa-08dab5c8b916
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qWBGWRT2dlEd/SbxcXbSGdqZZMKdvTE3xmC3+4C8AVlpPv6jP0YlA2qWqrcci3RW3/fJ6qBaT8Zx1iEZ17MKSgI7X+B03MV0vx+wBOVO9EyHWJPjCSqfabszxKXCHnwbgbjUBvrf5T5EqwfCEx3TwRTmR1Icsl2j1u0Gmb3nkN9OECIU5msZC2pGam6ukKzSbOdDSiZ3n2qrmMtuY27visZEI5wKx8zlGlxLQfR7OoGfCWsRUvr5ClA0MwhWjG8izJbvuLezkixsK/r1OGcDvkIJScsNkdya69nJoALONYjCsiJiBbjTlVt6ouddv8J/bQ0kqesydqiIQKCxtWsqXD0gCiO6EeeiCD3hlzj25mZA8/r9ww8Kpab1huEXJQ8LQLJsivxSiuWDmUz36ioPjEBuVymLN7ZmKu/jktUMi7nxNFwLn5mKI0Liwj5coeG7wTRhne7Lo16dgPnagH1EmQ5/LXBe96lO583Z0vl+oksDUyfXRfuB5WPJmjCggh0KQfpLn+o9YkvcXgIHToCnTUuod3CGZ2PdHsjMD5lN+jAzr1T2+Z7dEKk65JC/i/hYUzeVfk+LvbiE6TCSDm2JOzd9QHY4wyWe5RbOA3DVXxJMSlvuvFFe5yuAUCmrhqJN6+KjZIpZzAdyhxhy4hAxJVCrwRMCjt/ftVQjAQg+iVIru76Nn1Rh/G69bnSxO6kRQyf5oH2Ek6iC2aH50aziXX11JugPwz5XN1WnpcCjb++qaKP6rWbfoBYvQUm5ykyJoL96h5KAaFsgZRSCAfdyhA==
X-Forefront-Antispam-Report: CIP:158.140.1.147;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:sjmaillnx1.cadence.com;PTR:unknown.Cadence.COM;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(396003)(39860400002)(376002)(36092001)(451199015)(40470700004)(46966006)(36840700001)(83380400001)(82310400005)(36756003)(2616005)(36860700001)(356005)(47076005)(54906003)(5660300002)(336012)(426003)(70206006)(7636003)(4326008)(186003)(6916009)(82740400003)(86362001)(70586007)(316002)(40480700001)(478600001)(40460700003)(42186006)(2906002)(41300700001)(8936002)(26005)(8676002)(6666004);DIR:OUT;SFP:1101;
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2022 14:04:52.9212
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f13f8119-9b9d-481b-52aa-08dab5c8b916
X-MS-Exchange-CrossTenant-Id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=d36035c5-6ce6-4662-a3dc-e762e61ae4c9;Ip=[158.140.1.147];Helo=[sjmaillnx1.cadence.com]
X-MS-Exchange-CrossTenant-AuthSource: MW2NAM12FT010.eop-nam12.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR07MB9582
X-Proofpoint-GUID: RXyMBqr0p2137ijI-LzIFHmLtizwhBRq
X-Proofpoint-ORIG-GUID: RXyMBqr0p2137ijI-LzIFHmLtizwhBRq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-24_04,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0 bulkscore=0
 clxscore=1015 priorityscore=1501 impostorscore=0 malwarescore=0
 adultscore=0 suspectscore=0 spamscore=0 mlxscore=0 lowpriorityscore=0
 mlxlogscore=488 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2209130000 definitions=main-2210240086
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Patch modifies the TD_SIZE in TRB before ZLP TRB.
The TD_SIZE in TRB before ZLP TRB must be set to 1 to force
processing ZLP TRB by controller.

cc: <stable@vger.kernel.org>
Fixes: 3d82904559f4 ("usb: cdnsp: cdns3 Add main part of Cadence USBSSP DRD Driver")
Signed-off-by: Pawel Laszczak <pawell@cadence.com>

---
Changelog:
v2:
- returned value for last TRB must be 0

 drivers/usb/cdns3/cdnsp-ring.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/cdns3/cdnsp-ring.c b/drivers/usb/cdns3/cdnsp-ring.c
index 04dfcaa08dc4..aa79bce89d8a 100644
--- a/drivers/usb/cdns3/cdnsp-ring.c
+++ b/drivers/usb/cdns3/cdnsp-ring.c
@@ -1769,8 +1769,13 @@ static u32 cdnsp_td_remainder(struct cdnsp_device *pdev,
 
 	/* One TRB with a zero-length data packet. */
 	if (!more_trbs_coming || (transferred == 0 && trb_buff_len == 0) ||
-	    trb_buff_len == td_total_len)
+	    trb_buff_len == td_total_len) {
+		/* Before ZLP driver needs set TD_SIZE=1. */
+		if (more_trbs_coming)
+			return 1;
+
 		return 0;
+	}
 
 	maxp = usb_endpoint_maxp(preq->pep->endpoint.desc);
 	total_packet_count = DIV_ROUND_UP(td_total_len, maxp);
-- 
2.25.1

