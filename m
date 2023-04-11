Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C6436DDF2A
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 17:12:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230476AbjDKPM3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Apr 2023 11:12:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230422AbjDKPMJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 11:12:09 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 851955B9D;
        Tue, 11 Apr 2023 08:11:52 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33BF1tj6018377;
        Tue, 11 Apr 2023 15:11:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=Ncc5JoP9CP/6T60IokeCK6aY7GzhvHCWLWgIubZw00U=;
 b=Y8KvcD9WCGySLMnkzW+R9SOLY5I64W1kew6UVURqFeSPqXnwTww8jW8roNDXb5NqByku
 zjXGVEV2sl7PYttEkublnrEnVVB/WhQvpCfEyXYkcDvWPeIPOC5BBNaxbRJF+G2/rwyh
 7ooRzFIJnIFnVtcAHCEJymItS3g8y9fcwiBWAx90qfNyO+NIHpZgSvBMfLlBOCp6frWe
 rQbVStx/CboFWDXOpQ4I53HcQamhf8lRboCTupmAghC8Amb94d7+UyVP/Ly40XDbvBFV
 JUDQRd4tmrZQ718yUKBdo7pnKXtNHwKoOFrxIVa3U2pcAJ3SzsB5h54YBORWSRVrV2iW TQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pu0bvwr5w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Apr 2023 15:11:32 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33BEPpHv008084;
        Tue, 11 Apr 2023 15:11:31 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3puwc4976c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Apr 2023 15:11:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OLip3fhb3/xsixGICv0YeL6gUoH+7YggeIPfSe0TMLf0wqmHFTzwB1bjxifqXBDaxwfzRt2VF6AM4RM72YfRoaZjspQjJfSHsCT1GZIV7d5R2yNw+cVc+9HzGaNbWAA1gsidEsGL8BIZBiI+wzPXz+hfrd7tDw3g4Sy7ezyLF1sdloupgu951/akAmZXVsiYadEFif3c2fCfkI8kxAL677LdG54/bFxtvSoXQTY+BbahBV5xZm+zfsigISkFVIBjuJSabt/Jp/hsS6AFSdiZ7c8pcQSoylcPyjlPbPq3b7hShNA+VjGSXzJPrdV+tdlrNxPb7Tz8URCkhRIkAUchDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ncc5JoP9CP/6T60IokeCK6aY7GzhvHCWLWgIubZw00U=;
 b=EXDm2GEoJQTDsXDUEjdoX0J7vX9kAVHcZIUJq6se/QzUQ9dJ/YIA42cIKtixuWi2Co07fzb5QVOICOzi62ez8YyCj6mKUkJoLCtxtcgHKCa79MBlkhJiF2Tht9A3XVPozF6Vm38HqjzVb2w1vx9sjebeogVJh0OMc6fjCEhm00DCNhYiilHNQ6KK2jJIxHahlR62T/Gl++miAhNcO6zIbWluFjf9gFNDEn4csQZ/R6YJzgrdvJIymfLw49oD9fQsHVbt8hl52uDm4k4K/edsCZf5uCUS7VNQTPuk429Upl4a04yCmGbr706sgA5OMv+T0l3i2Z/h3eb0xOEI/2mjjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ncc5JoP9CP/6T60IokeCK6aY7GzhvHCWLWgIubZw00U=;
 b=QqUzSDM6uIH3rklADPf94OvP6jxQh2iKTv5oyNHMWyGG+1eQ9k1K2yp5yxQxawu1wdyDtcTPzL56gZbzp18PBg6i7sRpDeVmb+OLY0hKZo4CWqfgas+TDm0O4sRAgPBQ3WwiDycZjCBQyBK43kzNCYhqYkhteX18xNUBb/VVbd8=
Received: from SN6PR10MB3022.namprd10.prod.outlook.com (2603:10b6:805:d8::25)
 by CY5PR10MB6120.namprd10.prod.outlook.com (2603:10b6:930:34::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.27; Tue, 11 Apr
 2023 15:11:28 +0000
Received: from SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::8bb9:2bb7:3930:b5da]) by SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::8bb9:2bb7:3930:b5da%7]) with mapi id 15.20.6277.035; Tue, 11 Apr 2023
 15:11:28 +0000
From:   "Liam R. Howlett" <Liam.Howlett@oracle.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Liam R. Howlett" <Liam.Howlett@Oracle.com>,
        Stable@vger.kernel.org,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>
Subject: [PATCH 6.1 03/14] maple_tree: reduce user error potential
Date:   Tue, 11 Apr 2023 11:10:44 -0400
Message-Id: <20230411151055.2910579-4-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230411151055.2910579-1-Liam.Howlett@oracle.com>
References: <20230411151055.2910579-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4P288CA0048.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:b01:d3::25) To SN6PR10MB3022.namprd10.prod.outlook.com
 (2603:10b6:805:d8::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR10MB3022:EE_|CY5PR10MB6120:EE_
X-MS-Office365-Filtering-Correlation-Id: b76c830f-f4f4-447d-aef3-08db3a9f0661
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3022.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(396003)(376002)(136003)(366004)(346002)(451199021)(38100700002)(36756003)(86362001)(316002)(26005)(6506007)(8936002)(5660300002)(6512007)(186003)(41300700001)(478600001)(6666004)(1076003)(2906002)(107886003)(66556008)(66946007)(54906003)(8676002)(6486002)(966005)(2616005)(83380400001)(4326008)(66476007);DIR:OUT;SFP:1101;
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b76c830f-f4f4-447d-aef3-08db3a9f0661
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3022.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 15:11:28.5547
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3AOfcycjbHBy0hxVijQQXLGmkGwkLgeVsfpAk4ozWa/x5KZph5+ns+TLpTS738gx2gog305EwypYRJ3bsL3YUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB6120
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-11_10,2023-04-11_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 adultscore=0
 suspectscore=0 phishscore=0 mlxlogscore=999 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2304110138
X-Proofpoint-GUID: Co-of1uw6AXEjJWqNsK5PQa7Xc8G7O7I
X-Proofpoint-ORIG-GUID: Co-of1uw6AXEjJWqNsK5PQa7Xc8G7O7I
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Liam R. Howlett" <Liam.Howlett@Oracle.com>

commit 50e81c82ad947045c7ed26ddc9acb17276b653b6 upstream.

When iterating, a user may operate on the tree and cause the maple state
to be altered and left in an unintuitive state.  Detect this scenario and
correct it by setting to the limit and invalidating the state.

Link: https://lkml.kernel.org/r/20230120162650.984577-4-Liam.Howlett@oracle.com
Cc: <Stable@vger.kernel.org>
Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 lib/maple_tree.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 1ade7748cc9b..819ba692940e 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -4737,6 +4737,11 @@ static inline void *mas_next_entry(struct ma_state *mas, unsigned long limit)
 	unsigned long last;
 	enum maple_type mt;
 
+	if (mas->index > limit) {
+		mas->index = mas->last = limit;
+		mas_pause(mas);
+		return NULL;
+	}
 	last = mas->last;
 retry:
 	offset = mas->offset;
@@ -4843,6 +4848,11 @@ static inline void *mas_prev_entry(struct ma_state *mas, unsigned long min)
 {
 	void *entry;
 
+	if (mas->index < min) {
+		mas->index = mas->last = min;
+		mas_pause(mas);
+		return NULL;
+	}
 retry:
 	while (likely(!mas_is_none(mas))) {
 		entry = mas_prev_nentry(mas, min, mas->index);
-- 
2.39.2

