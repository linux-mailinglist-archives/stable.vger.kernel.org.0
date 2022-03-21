Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 244384E2F3D
	for <lists+stable@lfdr.de>; Mon, 21 Mar 2022 18:40:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349896AbiCURmF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 13:42:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230370AbiCURmE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 13:42:04 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6BF851332
        for <stable@vger.kernel.org>; Mon, 21 Mar 2022 10:40:38 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22LGiQ4p028732;
        Mon, 21 Mar 2022 17:40:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=vSHXWGZ1YOAnGxlbXPTG/Yi07EZX7F66zc4AKZ83Grc=;
 b=OgJ9dwa+mSFsW9urjJxzxIqq+QGj9nmtdgjac1fUegukEbRdIsmkv3SGTTdn11QNWV9r
 /zK+0oUsRj5Mnd7jUz6tew903KPGwSb81gKw1U/QnbnQOa0vicF7KZHgsZxe3g2QU40v
 lSqkTfypA4NMC+iRnxeC/ar/EjJGm27xuWMoAa7UvRQoPzBp9I/hXLWsw2CLGl2O6zoF
 y7D4yWMBBNAlqflY3qJ2AzOBWaC0SCYDJGaGnIA35xMGE4+9VvWaaKbdnHt3EZ7wpYn/
 8Ay494IP5YCa9OBov7dyrb/zeDZhxRhjkuSoFkmcuW1CGbv0JInwM7RH5zeABQELjADH hg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ew5kcm2by-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Mar 2022 17:40:31 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22LHZY3p102263;
        Mon, 21 Mar 2022 17:40:30 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2107.outbound.protection.outlook.com [104.47.70.107])
        by userp3020.oracle.com with ESMTP id 3exawgvtja-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Mar 2022 17:40:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S5M1DfanDeuxb82ysaX2jKxRmNPz38wKDVB6YpTrMyPOqhOs/i9qweLVP6IiTGKglvxBqeLhcBypnbYd6EJHhwLYs0nv3skQA6IaSV7yoRVO5DNI3Swc2vKqHCFC/0wWVYz45AUyVQexN0YGnnmeedZfNm1DlUO803LQfGETQiJkC0cmYuII+uR5xUZ9jF2QpkV32C+fz+WTbA9+CEoNZmQmIbNK3mC/ANVuIH2XvqfDiKaB5FsN/qmI4v7yom53Vh2IUbxZ5AP2uofy7shHkCaJalCWh0IIe551klY/d7S3R50BBg4q16Pj5ooAbKllQie5eQ8BBx54BsihdRs1vA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vSHXWGZ1YOAnGxlbXPTG/Yi07EZX7F66zc4AKZ83Grc=;
 b=V1gjHXHVyKdHIa1jvhycDxjRXj11w9Pb0N5Nfl3SogrZW8uWZDFcw7FvA7++uxI6fcDEEwsTSJYvz6rGDubg40tG1RG0oOl+J5VCTW4RJwDGzdMrH3clRFua17eV+hiZ7coQSGS0/wcl2XNovt7usm1MWwQ5jwvOKcxA1jgrrRmGO89MZGXjQtlcrdb58iNP1jgQ5qe+QwL9qvCPejTRlDo2th6k4lSfegXNLdYKKUmWOpUUjwqydWmZXePaWXM3w5LVFWQP5HmngvLAImyv1mvuc4bnCqrl8adTF/cbLFhfnKOQfEWRHTL2PUDSQ9Yge4LHCsxhjCwAg1YohsTUiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vSHXWGZ1YOAnGxlbXPTG/Yi07EZX7F66zc4AKZ83Grc=;
 b=zluTZY4AM1va8nAXsjQBJquKPWSgpROr5PhJkOow5wHGI4bq9hjLsFCB4i6PtFsl2oi2o1uyuoZTkJuBDqrbLNOi9HTKKZx3NaHJK/Xt+6OIXPkqWnvCq+OXXemCVET48ZWSy/dbO34fku7RsvtQnDVssKhz64qheUt9amf1gf0=
Received: from CO1PR10MB4627.namprd10.prod.outlook.com (2603:10b6:303:9d::24)
 by PH0PR10MB4776.namprd10.prod.outlook.com (2603:10b6:510:3f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.21; Mon, 21 Mar
 2022 17:40:27 +0000
Received: from CO1PR10MB4627.namprd10.prod.outlook.com
 ([fe80::407d:30f6:5f26:5ce8]) by CO1PR10MB4627.namprd10.prod.outlook.com
 ([fe80::407d:30f6:5f26:5ce8%5]) with mapi id 15.20.5081.023; Mon, 21 Mar 2022
 17:40:27 +0000
From:   Denis Efremov <denis.e.efremov@oracle.com>
Cc:     Jordy Zomer <jordy@pwning.systems>, stable@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Denis Efremov <denis.e.efremov@oracle.com>
Subject: [PATCH] nfc: st21nfca: Fix potential buffer overflows in EVT_TRANSACTION
Date:   Mon, 21 Mar 2022 20:40:06 +0300
Message-Id: <20220321174006.47972-1-denis.e.efremov@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220111164451.3232987-1-jordy@pwning.systems>
References: <20220111164451.3232987-1-jordy@pwning.systems>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: GV3P280CA0066.SWEP280.PROD.OUTLOOK.COM (2603:10a6:150:a::9)
 To CO1PR10MB4627.namprd10.prod.outlook.com (2603:10b6:303:9d::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 406b6bcf-69eb-4e82-2754-08da0b61e219
X-MS-TrafficTypeDiagnostic: PH0PR10MB4776:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB4776127FEE60C3E1CAFEC893D3169@PH0PR10MB4776.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: t8VpPCf1JlP1G18tZ5jgD5VmSQh3QISsdiYgadWjahcCUBphRq2iDI+mKnnb8KGF/ew7BjUYsqJRgVpPnNBbvlU2LuUASI5aC5ls64H4TYnyLU9B8z5ZYSYmLlTqvoCNCqAz7wWwpD7pzMfPsVvZZT+tcEjNjN56F0QLgM7E6e1AuJea2SAS2Sjv+04EanQ2zzj2UkZtQO+j7LUdoBQ0DdoLA4g+mTbwgJpmisdrf84LMkeB8TkWBIUGm3ks2xjbx81bOwyiDsilGY8ShFW/sesWLSFA8pYqBGWnfFwWiXzlbNZTYCReKFCJX7pqqqCtpzeKBCxJ5xD48EmFL1W4yVvYBT4rGXrFLm+DCVZw2ERqdiUfk8MJ25ECu7GHT1C995ZSTB3bwUpJajtgbEf8lGvSkmbdOowLpe3PepHZHOF0+eudGiFVksGWjK1Ochw2seXAqSyf4T5aciLkrDtL5DvP0xaa6wOjdpOYPe8WPWNLZ7o6USSOOY2fH45SMpQiUDJgEyhRuqByVUYE69AQptMCtcK1gsfoFrNYJymuEP0Tb4XE9TakN8kQtnWmfS/Fu+DbSJM8aPTNU/haf/8VPc5T2FkD+7200YjNlQOdYXpJzsXMnpNaIOmZYsPv6DvegB8bX0NruBF4GVhjxKvrrHNggWRNayjMMzMV/Vh3PyEC8rsKdlnOBnN23RhKiBfEhjxglExJAr7Q01awFcOHfIenJZr2knHyE/w0DlYxZlIfhl0TlzmPODOttjLkaOrIiJZ+0hwbyuA7gEzgHJYLwQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4627.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8676002)(103116003)(6666004)(5660300002)(508600001)(2616005)(4326008)(6486002)(66476007)(66946007)(66556008)(83380400001)(8936002)(86362001)(966005)(316002)(109986005)(107886003)(1076003)(186003)(26005)(38100700002)(2906002)(6512007)(6506007)(54906003)(36756003)(266003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Fbi9N4xCFZLjHcdIUmBlZadZm+X72wYmD4lPkz9k0kdUL1j+BHdFD01kmeMD?=
 =?us-ascii?Q?QfInpyyuaicQ0+uv4ENC5hLscdLs6F35OYsuxoXGRmWQIRrBI8JLLqHV92uF?=
 =?us-ascii?Q?TlZjJ4nhsIwxRY0WR1MirvJvsNFpda1YiYiYXKBTQedaCNvz9NWuVtzyWaWi?=
 =?us-ascii?Q?QRlvLURVm45jt/VHsl521KO3k1EG2ALZ20x93SsAPf99gsNrPe/hZXut63Ph?=
 =?us-ascii?Q?fhx+VitEcPYNZ50J+t3q8iMmtGTFBTNO+IwXosg0EhXchFBc3ElN8kcsKc8N?=
 =?us-ascii?Q?FFAFbm7rra8D2F77YsBBShIJ75piiF1eJHi5xg4JyCR1ZKQILj9/GWsX43wA?=
 =?us-ascii?Q?gu/x+C7tgyToaUCz7q0zKKFPewgKl5ppn5WIizCESyTdU4j6fX43E4rl0F2J?=
 =?us-ascii?Q?Y7rDCTII7UzMyjsRWHTSETh73uJbEngjLTeiuxadoKsp+r55SGv2IXCQPPnq?=
 =?us-ascii?Q?kD2zlr9BcmvBTDblkxiTVJnrKihqFrV02headevsru1BOyuwA80wrz+5hEgO?=
 =?us-ascii?Q?KXaJDaOWvuZ9KKKKXiMqfyVXAndfRUvbzO1EuSp8keu+JZHRwqAeSVrirFfM?=
 =?us-ascii?Q?iJpOESJARk/QxIb3K6oIz2eRKLwZoXwAuRhQMTqv5e/GIZr9vJ17dQSxEtlC?=
 =?us-ascii?Q?5eM8eHZ4R9rmjvclZRU/N+Q+04emO5D5alE9MZkyythDb7tGj3wGXrMCup6T?=
 =?us-ascii?Q?2vIL8cmvJR11ObyyWI4BqZitvcr5Rw2j/xMNYB5RLkSBzMoj32gcDTmx+bMm?=
 =?us-ascii?Q?63rmNBzN7YtO976WD/WNdK6VyoK4CyGSoMx0+SrPenE955wcu4K0drEoHdcq?=
 =?us-ascii?Q?2QzXmenT7zPDLQ6tNQIZFAHzAEYs9Vk6lNQVN5mcLpxUEEkSBvwYw1eeurWf?=
 =?us-ascii?Q?b+MwQKEz6/c0xR6xZnpPw+fiMFaNAYvG28as1HXWPVpOl6idc698J6ZHzuDB?=
 =?us-ascii?Q?BJ8juXzutLHKlZxHmuY9E5r9AJXFPBMaSq1AkgYOgkjVTCnkmz6ZB5TCQ76v?=
 =?us-ascii?Q?xYXZegbd506p1TaUFrULE3/E0rylQPeFeMIGwn9xrlgkK663UWQEOiaNFQve?=
 =?us-ascii?Q?9fhC3rlhrPBGfQ5AID1NrFP0mOcrjWPC/B1P17R8Q7+rju2mwOM9P1l5UBhd?=
 =?us-ascii?Q?OsrjqQXnQX/2ERGo2nBwHVVLNEUZ0pkHddlqhn/qtXwqgJe+4tEhwmDAMLIr?=
 =?us-ascii?Q?8xmje2B/eF/odg8wMhIOQivEv8BccUBH43l3BAmfyoB04Z36EM0rLo76E7V8?=
 =?us-ascii?Q?oj1MPmqmjrEhscDpLOftYNMG2i4NUOv5zLajacJFbjprowjD2Xu1NLhnuEJa?=
 =?us-ascii?Q?qZXrtymJDIr7+uoQi2RnjWlRqkeGW5lzbOih/NBDK8gPiBLy/DeL7DQLWd5G?=
 =?us-ascii?Q?vItXueI2r/Bq6sbrZgNShdxGTjSRFVkSQWhQzL102S/34qx6ekfsYBnaVYKU?=
 =?us-ascii?Q?IRVaEnoXjyMJmMLIhkUqx7nfzPUEZJZAUKfWolDKGHe6n3Drx6IMnA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 406b6bcf-69eb-4e82-2754-08da0b61e219
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4627.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2022 17:40:27.4857
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8MwELm6BuHBhKIuPsDCW4AZIVitKBA9PXZC1YYPSxV/ntCoaqPo4o9u4NJJsd7OdT1ZFUWsjq70vOyq98ecQ6kZLpW/UI6cx2Ab9aPSnUN0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4776
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10293 signatures=694221
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 malwarescore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203210112
X-Proofpoint-GUID: qdr1bPfixqKYYOERsNKvODrs6hvgPLfg
X-Proofpoint-ORIG-GUID: qdr1bPfixqKYYOERsNKvODrs6hvgPLfg
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jordy Zomer <jordy@pwning.systems>

It appears that there are some buffer overflows in EVT_TRANSACTION.
This happens because the length parameters that are passed to memcpy
come directly from skb->data and are not guarded in any way.

Link: https://lore.kernel.org/all/20220111164451.3232987-1-jordy@pwning.systems/#t
Fixes: 26fc6c7f02cb ("NFC: st21nfca: Add HCI transaction event support")
Cc: stable@vger.kernel.org # 4.0+
Signed-off-by: Jordy Zomer <jordy@pwning.systems>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Denis Efremov <denis.e.efremov@oracle.com>
---
CVE-2022-26490 was assigned to this patch. It looks like it's not in
the stable trees yet. I only added Link:/Fixes:/Cc: stable... to the
commit's message.

 drivers/nfc/st21nfca/se.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/nfc/st21nfca/se.c b/drivers/nfc/st21nfca/se.c
index a43fc4117fa5..c922f10d0d7b 100644
--- a/drivers/nfc/st21nfca/se.c
+++ b/drivers/nfc/st21nfca/se.c
@@ -316,6 +316,11 @@ int st21nfca_connectivity_event_received(struct nfc_hci_dev *hdev, u8 host,
 			return -ENOMEM;
 
 		transaction->aid_len = skb->data[1];
+
+		/* Checking if the length of the AID is valid */
+		if (transaction->aid_len > sizeof(transaction->aid))
+			return -EINVAL;
+
 		memcpy(transaction->aid, &skb->data[2],
 		       transaction->aid_len);
 
@@ -325,6 +330,11 @@ int st21nfca_connectivity_event_received(struct nfc_hci_dev *hdev, u8 host,
 			return -EPROTO;
 
 		transaction->params_len = skb->data[transaction->aid_len + 3];
+
+		/* Total size is allocated (skb->len - 2) minus fixed array members */
+		if (transaction->params_len > ((skb->len - 2) - sizeof(struct nfc_evt_transaction)))
+			return -EINVAL;
+
 		memcpy(transaction->params, skb->data +
 		       transaction->aid_len + 4, transaction->params_len);
 
-- 
2.35.1

