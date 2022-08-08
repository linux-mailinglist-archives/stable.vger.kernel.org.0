Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B46FB58C888
	for <lists+stable@lfdr.de>; Mon,  8 Aug 2022 14:44:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242947AbiHHMo2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Aug 2022 08:44:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242959AbiHHMoY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Aug 2022 08:44:24 -0400
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68C87DF21
        for <stable@vger.kernel.org>; Mon,  8 Aug 2022 05:44:14 -0700 (PDT)
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 278C9pYO023112;
        Mon, 8 Aug 2022 12:44:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=PPS06212021;
 bh=3htP59BpYDhhgGI0XWbU9Skwtv/EJp7F9nOPgOR+9AI=;
 b=CDFtMLuz4xwbBHtddKdv4C7RB7Gs2a/7nEtZadmO95XWR65fzJlCK/loqaOhWbdC1Qd6
 AlV3kE3pyoLHuSmlrp5/MJXURzw7G1ukll2cZLFs5nM+149Oxol2Rs6d4n8agrAPidjx
 Rs6fO9KGhiq2Pl0N0/TfOZNgM+Ky1qrQF4Ec2N1+5qR6cv7gLFIWOZaqmGuV84q8MWb+
 BSqWtitZIZiz/umRkLENVlHJ8DVD+lEujVNaEU4SGhQDrKrfsGfRC+3ZE/gdpNgZNRM6
 Z/8unZlBVGSZilNVndRVODpjor8hlfpLauEm3mMcTankdUxX0YEjVD3Pqcu8jNiZTtAT DA== 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3hsf9d1gge-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Aug 2022 12:44:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j7Jsbt65ao/LZkSpyRxYOL1eQTvvfXS/1RSgcReWzd/TEaqwsZEKnHko1uhBHNkArPjtAcAOuQSKR+RSXg59faqbUHIYtZmUm9R8OkgJBISPpKOWRJFL49KhojlRt/tJaP+xfGVvV3Z7DnhfFIYBp6HHjbN1SzCwQ2ZZEI+WNRe1+4WUUYhx8M2FLXKpGv5AJUzmxMSuYdfojVNKkDNIswPesMThW3fycEPRsXanmTiZeOQ2jDRyByki8IPdszU5yy58Ou9bNVtGPsuAli/8/VfdQCn+25clwTXVpY4k9cQpcwkpxTrbm2an4eSEY4iqqUuL6995EwfuVnTtkKtk4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3htP59BpYDhhgGI0XWbU9Skwtv/EJp7F9nOPgOR+9AI=;
 b=d3+FiFosC8xPcTg0BP0FW+TPQbCOQ2+x63ZhsFNg3aNvVzQGh9uhpx6mWq/2UkBhArWujwP5eYdnFpPjkbEUs/xzKy82ib9VytFWcQ18wqJTuk30ZnhpmxrsMVrp3dDl0PtLS7IW81g/9Q35ad8G6egALXgeP1ixJJyjAIo1Hga7UrImQuiWZ6qNuES8VPY2dtOXA8cTE1ibPMPBi/2HOa3yt9nw3GqYm6mIhNmexhn5o08t1sXQoakN79PgnqELuDjZOjM0CyNhanmue/rhE4j6EogseT7/+4YitLmJQkoE0PmLTVVSUod93qPX2+XQkhrEzsnT0bO8GSnHblgLCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by CY4PR11MB2006.namprd11.prod.outlook.com (2603:10b6:903:2f::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.16; Mon, 8 Aug
 2022 12:44:02 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::e500:5c9f:fb41:287b]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::e500:5c9f:fb41:287b%9]) with mapi id 15.20.5504.020; Mon, 8 Aug 2022
 12:44:01 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org, wenst@chromium.org,
        hverkuil-cisco@xs4all.nl, mchehab@kernel.org
Cc:     linux-media@vger.kernel.org,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 5.4 0/1] media: v4l2-mem2mem: backport fix for CVE-2022-20369
Date:   Mon,  8 Aug 2022 15:41:29 +0300
Message-Id: <20220808124130.1928411-1-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.37.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR04CA0064.eurprd04.prod.outlook.com
 (2603:10a6:802:2::35) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 84fe37dc-1d93-4521-f761-08da793bab8e
X-MS-TrafficTypeDiagnostic: CY4PR11MB2006:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZJysDeMwNua3mDru2PjoV9GB2R2hau7ceZZbBsHP6Xj5GMU1HTtqk78hb7jOW1bhB+EzehlcicQsLnzOFm4qzPH1V8MeHh5WDOnfQp/mYEIW8nlKSpyM8Tar63cy4072gHorH/cZ/MrRnCGe2qZxflY4hqSjRriIi1mXz07ejZaKR8bjpNsthhQZwWHj+7Pe4tf+Ufvdn+5peCaeNVm0sIA15OF3C/c8gQFMXEojBg/ly3CYXhxB9pqrHePyuILUhZJEIJrrn/5VVbv+YOd5EAAiEmh+rp21pJnxEj9YYPwcHoVA8DBLV02DprihbLEurUhL5KCdhKg43RA1+/VW5MThPfPuPOIVI+8ne33Z+457QtLK9x2VeHpmy5QHKoTO48v1J01cv1iTiVQ+q5D5XlkxJZlTBy0l6O/rZd0ftIuL7oWjeAyJX7RW/MG06guhyzFfpQt36XB2Xzq4AJ8y2SWQOivyy6FrL7cPD/QWPGK7YBbnf51XkGCz2hyfR21N3+tw6HwNSEOghDLGn6XDqeYiQlk/CM4CwYlaH5f6ps5/yxFBFhNYhKOUr+9emwR206h1FzZpM30EUJPLaJWjb0+hTH0FdFd/J4apPDan89ER7dKT/6vBY5kK8qJKccl8na5cgECilS793GrCiuLHAWVYH2HVlDFwdp1HvAO+b5AgioteDaCOIxAQ0azTfOiofWptNCtbC0My47FPPAZ5Rg0gWSv5x7+/4f1+df4tnlhtJu/YbkapwKUXbGS19oiY6pESFtOAZ5X4Eemy7ZtZHiBcO8sTYq5vEKzjcmxt0IM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(376002)(39850400004)(366004)(136003)(396003)(83380400001)(26005)(6512007)(107886003)(1076003)(36756003)(2616005)(186003)(4326008)(86362001)(316002)(41300700001)(6506007)(52116002)(2906002)(6666004)(478600001)(66946007)(6486002)(38100700002)(44832011)(66556008)(66476007)(4744005)(38350700002)(5660300002)(8676002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uHYDa+d8/IfRwKpU9dwdIWxHDcOTtSKTNdLXxG4JBfizs5+Gf3imtzSbAUzZ?=
 =?us-ascii?Q?vnjkE8zMFF3pbBwMLkg+NRKzNOMH341BNXCwVoIDw0z9AXM9s0gcVZJTwFt9?=
 =?us-ascii?Q?dSihirQc6TGfhCyME/c51FgcnZhEMr2yRZCYE7uKhMe6rzL8ZzIciPCzyXCL?=
 =?us-ascii?Q?nQeUyJ8EqDouov+zeRw6S9gYtBvo3vg4F8J2ROqrUAq2FTLyvQNhdLUP/QQx?=
 =?us-ascii?Q?7ScM2egZqPeJ5GsJDT016Q1YHcdEuMwg1ofj4q5WeNgVq6SLRUr7LEyTlAud?=
 =?us-ascii?Q?fatQ5HegBKSKpz5nZIh5yVjqJt5CgOrcyC0A3/vDWRR7ZMeEgT5L9S3qgFEY?=
 =?us-ascii?Q?Rb0ZnCueAJ8lyG1cWvTcsTsDqvcGphYPxnBLZYxe56+Nv3Bw96SAmBSRBmwY?=
 =?us-ascii?Q?xzHhLi5+xku3/QJ9twFrboEm48NvbNWAgpfbkf6stguF8KJ89DS+cF3813tX?=
 =?us-ascii?Q?mggmQk8+CuPDqaGIKDnrOMkRI3ZhJ4jNn4Dw0Tv8qvJJ98bO3oDbCUWcRCI3?=
 =?us-ascii?Q?ayt+WESjPQ5M5BQFSVa5LG5QKYKIteZi3R4r/sXgpLlCFDHqrPsxtyF7SVrc?=
 =?us-ascii?Q?NQAqgYV29lYxPBZ9Zgm5qLmEuc5y7STQXTcYQPgeAnDlUv0eAQp3cuEuV8iT?=
 =?us-ascii?Q?FCpRdAAfFRs99Gcd7t9yZA6RH8sSRefrJazMgVPnTSDfiO9McjIZ3Qua6gQw?=
 =?us-ascii?Q?kJEVs3UxzCi4+Va2ii1cDM485fzOC26WiM5oXIWJiOmRGUFFCY1Fi5xFRmzH?=
 =?us-ascii?Q?yM0rvYwaLQYOZTfBnluHU/LrIrqXUWXgT2LCggn8JqMMBOuD4GOui1Gc1Wim?=
 =?us-ascii?Q?2wDRFvL4Y4yji0rk67XXn8/YlQ2thGFNTQNdz1Bx/YU0XF8IA6IbYbGLBnDu?=
 =?us-ascii?Q?GOMzWOzIwugI1CEJzZLGFC76UNjq1jRnQRln56yqHrwAH1af/YzLB64yoTcM?=
 =?us-ascii?Q?3fxCCSxT9wkz6s3mOmmMAiV8IyJeImdbhRWNnppxxexktLW90KMWv5GAoA4N?=
 =?us-ascii?Q?N1fTOD2qeffk0kurspZblPjRX7MoRYxUNLmA20c/XXWW3AfqawZ1qPqDAM2M?=
 =?us-ascii?Q?gTZzfeicxds2oqe4rJkdN5JnosV/pFp86EPsqVPXgigJpf9RH5AcIvtQeXVI?=
 =?us-ascii?Q?13wcfIYOVQhON8G7QJgii4eEM3Wslleu+JzMMTmMAxRLSIL+eSwOZWJaXZTh?=
 =?us-ascii?Q?jT3jUhzvh1GyrSBOXOmJOlmXtOvvUUWpQSTaVweEa9UDnD51TSxUQH/yCf9c?=
 =?us-ascii?Q?r1IQg50nlQnS99bnzpK82DOfoqUbIA7bPNwxz1vEdSRDhIzSYJ9UwHWtd/WG?=
 =?us-ascii?Q?Br7xI75uWdbbphbMdi/DOJ8Aj2oAujsx6Ambg7q4QzSmioyOZGSDlcep0fPJ?=
 =?us-ascii?Q?Lqj29O1D1Sl1ORhCRa5cjFM1/PpwBp1dIUvf9Dsx2hcMq2kRbd7ppXNYxNr6?=
 =?us-ascii?Q?WzrxDJ6zetIacU4+XEdDdEMDFBow5sudrx/QEp1IOEJGokjshm10RJ1TuANn?=
 =?us-ascii?Q?5qNYIvdtOKKlswGDap9JrwpqyjDwuF827RqMU4dXfa2xADZLtlgwz/2DZzH6?=
 =?us-ascii?Q?spj5CWgota2IzF1DRnz8lYxFHXtIIj+HAp6J6+QwfPYPLdEgEZBINQikhrqO?=
 =?us-ascii?Q?+A=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84fe37dc-1d93-4521-f761-08da793bab8e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2022 12:44:01.7619
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9B20uMVo0BL/lwcDYb2Gxjj6t6JLXXkwVcy3aLwFSowCNjRDtb1pddDkEZzPXG/V9vTi8g+8Gx3xGAR6IsapOEN1zM41VhBndbX5JJiNx3c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR11MB2006
X-Proofpoint-ORIG-GUID: glpbeiYcPOEQzECMsCpg-quHxhAPLKiE
X-Proofpoint-GUID: glpbeiYcPOEQzECMsCpg-quHxhAPLKiE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-08_09,2022-08-05_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 impostorscore=0 mlxscore=0 spamscore=0 priorityscore=1501 phishscore=0
 mlxlogscore=954 adultscore=0 clxscore=1011 lowpriorityscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2208080062
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Backport summary:
-----------------
The return logic in v4l2_m2m_qbuf() was adjusted manually so that it matches
the logic in the original commit (v4l2_m2m_adjust_mem_offset() being called
only if !ret and before the v4l2_m2m_try_schedule() call):

@@ -500,10 +510,16 @@ int v4l2_m2m_qbuf(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
 		return -EPERM;
 	}
 	ret = vb2_qbuf(vq, vdev->v4l2_dev->mdev, buf);
-	if (!ret && !(buf->flags & V4L2_BUF_FLAG_IN_REQUEST))
+	if (ret)
+		return ret;
+
+	/* Adjust MMAP memory offsets for the CAPTURE queue */
+	v4l2_m2m_adjust_mem_offset(vq, buf);
+
+	if (!(buf->flags & V4L2_BUF_FLAG_IN_REQUEST))
 		v4l2_m2m_try_schedule(m2m_ctx);
 
-	return ret;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(v4l2_m2m_qbuf);

Build tested only.

Chen-Yu Tsai (1):
  media: v4l2-mem2mem: Apply DST_QUEUE_OFF_BASE on MMAP buffers across
    ioctls

 drivers/media/v4l2-core/v4l2-mem2mem.c | 60 ++++++++++++++++++++------
 1 file changed, 46 insertions(+), 14 deletions(-)

-- 
2.37.1

