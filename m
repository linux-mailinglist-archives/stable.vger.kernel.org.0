Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B04525783BD
	for <lists+stable@lfdr.de>; Mon, 18 Jul 2022 15:33:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233278AbiGRNdL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jul 2022 09:33:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230033AbiGRNdK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Jul 2022 09:33:10 -0400
X-Greylist: delayed 1515 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 18 Jul 2022 06:33:09 PDT
Received: from mx0b-00328301.pphosted.com (mx0b-00328301.pphosted.com [148.163.141.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F862DE90
        for <stable@vger.kernel.org>; Mon, 18 Jul 2022 06:33:09 -0700 (PDT)
Received: from pps.filterd (m0156136.ppops.net [127.0.0.1])
        by mx0b-00328301.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26ICxJQx015131;
        Mon, 18 Jul 2022 06:07:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=invensense.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version; s=pfpt1;
 bh=yblkHMaG3kOsJXtiHj0ExezYvHx1AQoHY1XzBOWT4EY=;
 b=PVHFSLqq5w89YU9RcnZCD+AMTNu/NCsHhlEB9QbzpPw66KCD23YInp7DVG1KZiMGizs8
 pAFL70hPBxefU4gs/b4597IQGD1T2i4trinkbP8NXcBmwKcwKtdl2q+D2OpIw4HSDJsS
 zvjqRbFlKUnhjwOD+cNTwQYhTjiHonxFgRXIhjAXlMJi4KZ2+qAG37WWTZZyBtJtDaqr
 /DA+jjYzQHyXW0byYhLsB5mpCctFfgMGISHLyHKvdX379rCnX4PDivfWQRWHiKqRx4oC
 7+jN0zyANXWhtLZBs48NzzYdI52l0pHqZeMw3QRnINb0ZGkC1cdfXJSa1tGhe14oHAxu +A== 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2103.outbound.protection.outlook.com [104.47.58.103])
        by mx0b-00328301.pphosted.com (PPS) with ESMTPS id 3hbs9p8tp6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 18 Jul 2022 06:07:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HrZ3/X63S+NIdhMXvmyV+SnoE814x27LZ3UbvvD5HI/KFb98hpTct+Sn8gIQfVcDc2YEnWYfV/FRQPD1vGvUyPf0eWKFW7bQs1bADziPAd3w3bj55QWtgKqyhQduhdxBSQpSVlzt+Jt7fYY5LGGshmh5u8K+vcKk6r30HSfOtGFf9rm+C7uMBDbiLCAVGVGDBqMcEwmQhdF7HA1tVeeWWQz+2nzjvUbVKm3kTrHXor1vXQYS2/rG+Hm+IX847bKKN7tI/BR2ob4yG0XlfF0nu6Kc/J6ZSiknYCuTxsHxN6JMA+KxiNHyC4jvTFCZ6ZRSvT2+L8Gq60SUDcg/jrGgjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yblkHMaG3kOsJXtiHj0ExezYvHx1AQoHY1XzBOWT4EY=;
 b=PCEIdSK3CK31qPPibx+PPISTS7YPsuyUln2Tvhql0X/YpaW1ZquWyOZ7AlexKOxwwciejy7yGwz6eC81iAicl22fAJd5gD7gyV5/PCENdgioXgqu7p7W7XVg2vHAQGWIjTf0Q0jgBhWx1IO87fpmKcLZlQLTMuZUVzFs7NiOGn2TbffZM9m/xnYMWRG/dQBALz74QG20bDs20kpbLkvSliAZnFSd164NRUzsWXta4saLPYmIJA26Zk/YuIr4QwO242VDUo2sO0ZmYfBWMTJ584H1AgJIfnA9CNXHmUGas3hrbYYlMkRBRTfbsPceWEeQDVfeY6CiryT/V/uZ14GbBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=invensense.com; dmarc=pass action=none
 header.from=invensense.com; dkim=pass header.d=invensense.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=invensense.onmicrosoft.com; s=selector2-invensense-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yblkHMaG3kOsJXtiHj0ExezYvHx1AQoHY1XzBOWT4EY=;
 b=IGIJJ7Yi1U+OuS71vZQ/Pw+hlvSi/vQD1/sxC+/DEd0GL8r/1OijYn3Ni8dpTUWTASvL0gkshz7FFct3q7vDh7zpSvgNixJvxw3zEC25EPQw+tY/JYZFbsoOZ7dNmBwz4puHLaGN/FcMLSLGxfipCLEU2sCP9WpSYz4VAaAXUAw=
Received: from BYAPR12MB4759.namprd12.prod.outlook.com (2603:10b6:a03:9d::16)
 by BN8PR12MB3377.namprd12.prod.outlook.com (2603:10b6:408:46::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.12; Mon, 18 Jul
 2022 13:07:28 +0000
Received: from BYAPR12MB4759.namprd12.prod.outlook.com
 ([fe80::64f5:a6bb:b5aa:ce61]) by BYAPR12MB4759.namprd12.prod.outlook.com
 ([fe80::64f5:a6bb:b5aa:ce61%7]) with mapi id 15.20.5438.023; Mon, 18 Jul 2022
 13:07:28 +0000
From:   Jean-Baptiste Maneyrol <jmaneyrol@invensense.com>
To:     jic23@kernel.org, lars@metafoo.de
Cc:     linux-iio@vger.kernel.org, stable@vger.kernel.org,
        Fawzi Khaber <fawzi.khaber@tdk.com>,
        Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>
Subject: [PATCH v2] iio: fix iio_format_avail_range() printing for none IIO_VAL_INT
Date:   Mon, 18 Jul 2022 15:07:06 +0200
Message-Id: <20220718130706.32571-1-jmaneyrol@invensense.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: LO4P265CA0208.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:33a::6) To BYAPR12MB4759.namprd12.prod.outlook.com
 (2603:10b6:a03:9d::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f5b336a6-69e8-4c08-8995-08da68be7710
X-MS-TrafficTypeDiagnostic: BN8PR12MB3377:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ze18O44XK1pEPAWFLV+g9UcfQukVMVBV+5yCrgBAxFqc3ELSgDCMR+FL8YGGC+LWjeP3SI66ov3jSZs0FPyvykpU4q5GStG/xPDW6cO6nhhiWx4B8Q+dNDYIa+yX9QFfaWvEiH/we8B385W8PVoB65D1Z1ys7ROSaMi5Ph5aXlaRUw3i3X1nWeFVdXX5OexxdZgBs0vA6Gb3yYi6f1heEDUQBWWj5IwhWmo2GbYyTEwtSSVKUQh3qdV6Gzf6OWHaq83kJKqgyMpdd9PA9yzGN5aoHTLz481D58KDX/AdCGXxM8Bou6b2ImeMAezk/o0nl/ViuIrqeks2faHqAOsUHuS+EHxSVuvxKS8nOhfRClL+JPz5vKFwRUNWP00MpmlOIg/uQ/8xUoOvwGOE6lp3U39ch6HZtKO/qF3aoSeXat3b5hDkU4snHO5iZtxWukXnUJH01chwoVWfsw50aqEGVt6kyU3xhigZVX6/Liq9FNrr4EdhEpokDbEVzWkcW2l/DheDNCILEp28FK7UzXdw/0l3kKUS6o4RHsqgebNcHQ1RNC5bx1ZEIOidc/SL92y19HRVOM2uplQXJgPI2RQrI6i21qseb0Ef9T+hkoRmcFFyqCFo3kLu7c6AepgChmFt/iDTK/sFmYhrAYvronf//3mGr8rQlwrTvHaUOs/ETdv2oaALoPfcKk6Dk+CaRsPbOPPOh5vRGv9E2mkrdFpRT4WZmCGu+QPqPFS3e11ylHei1lLAslo1gyvRl/Px5JtA793B0adSx0uKEgZZWnQhhPUNHhDyfm/S+Fj5zIdo5m0cpW9jIhchYJHpZWlQjdRF
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4759.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(136003)(346002)(39850400004)(376002)(366004)(2616005)(86362001)(6512007)(5660300002)(6486002)(1076003)(6666004)(6506007)(41300700001)(478600001)(8936002)(52116002)(2906002)(26005)(4326008)(38350700002)(186003)(36756003)(66556008)(54906003)(66476007)(316002)(8676002)(66946007)(83380400001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZIaTpGZAxYoQ5fiUie5hKPf5UZzW3Wfzis8mhMD87fhtKKUsioRuo6uk9H7h?=
 =?us-ascii?Q?zbC7ovpq3P3+T0Y/29YE2zGTbzhbjY2EXnGjVaGwaooCd8klXyAJOV1Urpnj?=
 =?us-ascii?Q?g0gdA77AUlsrJ2GAOxX0gM58O7Bn0pFcrB903fL1/EU6wFy+l7lE1h5yPF8w?=
 =?us-ascii?Q?xSs2V3UzhmpDF+Q0blbn/afk7yg+HPhM/pjFxX3mHTFpwCgpo2ABP+sy3S88?=
 =?us-ascii?Q?40Twx16DSWLqcnVtdE8pxhKAXUwiwj/oJvnTokbWaKttvVyDDfldKdiQjpSg?=
 =?us-ascii?Q?o3sEGUMb/OlzQrB/OBN2T2ewxuQMlGCp2IAHS4vn4V/lWICuw0ra5PE6waYR?=
 =?us-ascii?Q?UpYCOTntfOf+DzmJHoTJ45DAxzUl6q1nvp0hsMkJUzBr9DEBaz3J4ZhHYCY/?=
 =?us-ascii?Q?p0Jc5pyLK68tf4IIgGWo2AD1ODK9yWrbbRWuR/MDWkPfU/RqTpZXqSIPRdhl?=
 =?us-ascii?Q?UfOlU4RCXy7j7twN1tOfcXgRL+KPXpIA+8AMV7xVd16Ei34QA6xFMqjKbWH7?=
 =?us-ascii?Q?suwsZwa59WZCr7zwdS1XBC/mGAYm1xeaFeBeknOhuu6pz1Jg7EaFCX+y6A8e?=
 =?us-ascii?Q?LFGCqp0oScdIuEj6XRfjCqM8VU18FBAHR45s/OB7ix7JFMztKcoV0Q1OLeH/?=
 =?us-ascii?Q?oygW/6H9u1JkfbwLcy35U7XomDQ1gQqzSO7HaDipfKBXrud7NFGaUwyxjFMu?=
 =?us-ascii?Q?OCko2/woyxHta1ktDP9FpxkiT3v/iKyk/2T8bhnLALzFib4Z5HfQuKLK37iH?=
 =?us-ascii?Q?kkGEHOt0PNDxzNQFkrwOclkejxXZqGPI5dGdm7MPoUDiHrlijCGIgEQ3nCp7?=
 =?us-ascii?Q?nOGL+iCf/o9eofno6+sdUfXRYO0U89ZDwegircp2y9s9xRDPLGI/wEv4x2sb?=
 =?us-ascii?Q?4j3KSgc6T4hV44mvsZRKM2TLD+YZMhiXcp8n/XvM20wiWTCyGPjvxpqNcvYt?=
 =?us-ascii?Q?OPAEW0o7rRBBHbUf5bUTWuKOLFyzNMOeG9REh2VwqN2PMtAey3hhpmrw/k1b?=
 =?us-ascii?Q?YMFleSBPXMHmuU4Q0aiap2STIxK+LNw9W2va4z/ahAS5IggtrIy4WIfxvnYF?=
 =?us-ascii?Q?ZRDSYpgR6V+mCcDqPrCpwlDmV88NX7N9PzTmweaki5q3/j7wpT6opQqNL0P9?=
 =?us-ascii?Q?QhJD4WwLUdt76eDhG9lJE+zMT8xdtIfp058P+Pe7+xD3W5Rm9e/cU6lRHBvG?=
 =?us-ascii?Q?8Z+H4CXx4YB498XGo+GkdKQas6fHkkeBXZrsD12Qu/bys3omhxYBSf7g+gH5?=
 =?us-ascii?Q?14/PQzjExo4Wf8Pn+rN+2f0yYELbthTpkIIeTpfH3iOmPmtwd5K33PoXVEZd?=
 =?us-ascii?Q?F0UadbfI3BtSWPoHbHCh6hIlVIg+kPqFjmwmB915PdQvctdP8iw8ydf4Uee/?=
 =?us-ascii?Q?4ngq49ollLAnHznUhpvNacbhpnvArrS6JW/Oo/WDdNyTSMlN/rhaYMDnMBBk?=
 =?us-ascii?Q?51TzhI3fIz7FI2f1PYGwUY7Q6cxUoBb0wvz/d/P7KCVY3EcGm8xcbDGjyz5D?=
 =?us-ascii?Q?p3bSughkleSOVpax2B52G62YTflGfrh9xCeaJ6I46s9GXUxYT2ov5A7Fwr/A?=
 =?us-ascii?Q?aYynZ+NCRy0Qhp82qFwDf48V4NcydVONLE74Ho5z5R4nRyO/RzlvnovK+kP1?=
 =?us-ascii?Q?lg=3D=3D?=
X-OriginatorOrg: invensense.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5b336a6-69e8-4c08-8995-08da68be7710
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4759.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2022 13:07:27.8712
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 462b3b3b-e42b-47ea-801a-f1581aac892d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sAaYqLx/FCNLIQEc3Dlp+ilAId/GJFQswSvYKS634mq2PBV4Y5RVs1bg0Bb5GmAjmOeJcRIU0DfCF2mtmbUaMSHXU92FPbnXFkJBSoy96fE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3377
X-Proofpoint-ORIG-GUID: vGDGHT9DVfAbJCQYB1fnIMeqaL_QRAnM
X-Proofpoint-GUID: vGDGHT9DVfAbJCQYB1fnIMeqaL_QRAnM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-18_12,2022-07-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 clxscore=1015 lowpriorityscore=0 mlxlogscore=999
 phishscore=0 suspectscore=0 adultscore=0 mlxscore=0 spamscore=0
 bulkscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207180057
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fawzi Khaber <fawzi.khaber@tdk.com>

iio_format_avail_range() should print range as follow [min, step, max], so
the function was previously calling iio_format_list() with length = 3,
length variable refers to the array size of values not the number of
elements. In case of non IIO_VAL_INT values each element has integer part
and decimal part. With length = 3 this would cause premature end of loop
and result in printing only one element.

Signed-off-by: Fawzi Khaber <fawzi.khaber@tdk.com>
Signed-off-by: Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>
Fixes: eda20ba1e25e ("iio: core: Consolidate iio_format_avail_{list,range}()")
---
 drivers/iio/industrialio-core.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/industrialio-core.c b/drivers/iio/industrialio-core.c
index 358b909298c0..0f4dbda3b9d3 100644
--- a/drivers/iio/industrialio-core.c
+++ b/drivers/iio/industrialio-core.c
@@ -812,7 +812,23 @@ static ssize_t iio_format_avail_list(char *buf, const int *vals,
 
 static ssize_t iio_format_avail_range(char *buf, const int *vals, int type)
 {
-	return iio_format_list(buf, vals, type, 3, "[", "]");
+	int length;
+
+	/*
+	 * length refers to the array size , not the number of elements.
+	 * The purpose is to print the range [min , step ,max] so length should
+	 * be 3 in case of int, and 6 for other types.
+	 */
+	switch (type) {
+	case IIO_VAL_INT:
+		length = 3;
+		break;
+	default:
+		length = 6;
+		break;
+	}
+
+	return iio_format_list(buf, vals, type, length, "[", "]");
 }
 
 static ssize_t iio_read_channel_info_avail(struct device *dev,
-- 
2.17.1

