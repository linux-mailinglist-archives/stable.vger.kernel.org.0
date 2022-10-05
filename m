Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A099B5F5007
	for <lists+stable@lfdr.de>; Wed,  5 Oct 2022 09:01:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbiJEHBj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Oct 2022 03:01:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbiJEHBh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Oct 2022 03:01:37 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 175EB6D57C;
        Wed,  5 Oct 2022 00:01:37 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2956hl6R016883;
        Wed, 5 Oct 2022 07:01:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=DQ9WdjsWIL95XHKAcrzvQir7FO14Wm81i6uGAO2l5c4=;
 b=vDqJryA2ZtU0z8JIN/JaSXPRcYZlnYL0kf1sqpzfJkGhyY5M2OgF8bALzIkn/QIQi6SY
 eLU7rBYBMSqMnvoSk/YhUb3rKXHJ0G1AC3+PkcbQnSg9dBhUn6Cw6ry10nI9L5EuzaDP
 WvGs33yAW8zYm59zWELFWR+Yz1Pdz/q7rdf2ltTC4kztL0wDqZ2XO6gNXJsH855Py6S/
 yzA5A1JcDZIrURcdcUrFNj/GcCN9fSEpbT8GvzANEI6xyZeJDCvRZFsEz9iA9kwAULnj
 YY1l82k5tW7xynp4s5gpmZSmyVW4F2+U3gJiPmmeceoKrpVwSgM0fNIquQlAO40ZJDVy 3g== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jxdea8gfu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Oct 2022 07:01:31 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2956fMTn000495;
        Wed, 5 Oct 2022 07:01:31 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jxc05ck6x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Oct 2022 07:01:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RJkmmXxqE8v1VV+aZTgOrJWgWkQP6AoLtVk9Chk+kwKE/kIHXx5VYW1gx7o6LmSVeafeFSi6YNnL3jPxGLA1X7eYOE7DHkZ6xpfWu4sIOAkz9g/UhXlqS59q9iAMaog0pqsJD897SAS+6MQaoHU9dt/tIgW1TZDcQJZs1VlsJm9XH+S0qzGL6q5LUujvu7u6dUHjD6Jm4F2T9fKqlej/J5V9ZxFrzMUokr3wF24G9epg3zz3fzM0vM+l2QePT66EDH76vvQTrJIQxBExWSO792p3fBs9bPcRNvV8EuQArVtlAtg9GwuPBNSXfhOljwh7gaenAOr6+Wk1BWJYLL5LXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DQ9WdjsWIL95XHKAcrzvQir7FO14Wm81i6uGAO2l5c4=;
 b=K2fMfz1xmpso2zoBi9Hg3GQR3mCt8PmRiW1pc+9pkK/sNOspwAPtDbcG53QjnNeOISiVBmC8hE57Qb13Ympjna9IdosFQrl6Uiq7RvPJuJfjKUcWVFXLpBL1tjueSdnmbROoDn2DKJWAYvdSJJMk0+5ZwiC+WbXd8FD1RSojEHlYJkMm8TarKCQRi7wZw0ucGJdcrtHyWQy0PCy3JsvP12hcEV0C59acUu5Ob3vZMdRqtoyQXjiGEw2TyRU/7/mo5YBX9oyaMilweYtAypBFUWd3wJPmilOUXBYs2EweEwRnKqpteQEihhLVMo0RuhmZVYxn0EUPxrTJFkyixNthxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DQ9WdjsWIL95XHKAcrzvQir7FO14Wm81i6uGAO2l5c4=;
 b=mWJ16mUYARHuD+Hqv+u+8Oowb24RWq+TslTUn9rPvuF9kLFTxF+hnI/Gy0G4RGLYF/+mBKnEpiigzijSJJVTn8ZquDkhnnp4DRb7xJLyZ1CkX4tCT2P/r/a/wkA8coXk3dx8wigaHQjcwfF6HJzLHgZ1J237bHse0T0Gl/YkyZU=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by MW5PR10MB5808.namprd10.prod.outlook.com (2603:10b6:303:19b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.30; Wed, 5 Oct
 2022 07:01:28 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1%8]) with mapi id 15.20.5676.031; Wed, 5 Oct 2022
 07:01:28 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 02/11] xfs: introduce XFS_MAX_FILEOFF
Date:   Wed,  5 Oct 2022 12:30:56 +0530
Message-Id: <20221005070105.41929-3-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221005070105.41929-1-chandan.babu@oracle.com>
References: <20221005070105.41929-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR04CA0181.apcprd04.prod.outlook.com
 (2603:1096:4:14::19) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|MW5PR10MB5808:EE_
X-MS-Office365-Filtering-Correlation-Id: 66c47b92-5d37-41ba-dc78-08daa69f6cef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lJz2Od9cKbNS45H/6+12b7q4etLSN+7gSY8GYyw1Ex18m06xVrtppdeyIzMTEuxWE3eulU5TxVBOsKhT3s59MLMiJ9PbF5FjSqews3F5sfq/m5/8EIrIMI7wx+UEyZbiW/B8c0oTe/cOMrau2DuyR9cAxhrmmOJKOkFXtBgrap4tPzhOc9YHLlgFxhM+eWZtlb0sZz0LutzT0cSjJnIhuZ1YqHB0rWQ5Cewhj9rKlSDt5Ue4J3RoHoyMSrDOUYXu+jflRf9NnOOeZ/bVgk0p6O3/Z+Np127cF1cvUmoN6D8KBHe0Zr/MrpgVU/uauRy3O/gkayavW3R9wX/M+IpESeQtMHAZ1i2mhOpcoOyRiiIMvdn9ihuOMWn3D6Uw034Z9FlmyO6PcRnEVEndex8FjxMWys8oWXhtxF8Lfd5OFjCm8bPheJBjutas1bfY9eDgZl3g+OrBI5YurzyzFEo55hXmkM9ihqaSQp/5ZBuXobpydNiBHCnUVSLQSIIBn7Z6qwANrGeDyBHP7945v+92bsowNKjhO3UixGCpKXnLHpNgeUMTTWbpnGokhPbOPN7/wwjD+CP8llOnflClb9e0wIiCGzFM+75b95hz1KnmZLdmiY36a0PaSYINjtMStZUVS1kc4xB/oj5uGCXnUiDX+mVr++VujKWzDFGj32NemPXmksRgPf5iTAzJWjLZV+uGqWprUbtfHY8rItriQiMpYA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(396003)(366004)(346002)(39860400002)(451199015)(5660300002)(8936002)(8676002)(41300700001)(36756003)(6512007)(26005)(6486002)(66476007)(186003)(66556008)(1076003)(83380400001)(66946007)(4326008)(2906002)(6506007)(6916009)(2616005)(316002)(478600001)(38100700002)(86362001)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Vv0H4K0u5HaQt2nBbQCeINv2P5lAsfc/giE6gR0cxr18+kQEwWKuUzHDpraf?=
 =?us-ascii?Q?McxT9a3doPBj+vO8gIv+Nqm9HjyUrMb6QA5EfJM3/qGYjuasEDadQs5MNUpd?=
 =?us-ascii?Q?KfMR8X4URn3GhpEzLk2IenaMwUOPCG6XN3R76p9iS6BNh1Ixk7xDR5SFiMtp?=
 =?us-ascii?Q?jj5ONWMHBaz4Rlmo+ltiBw+85JbrPU0z3vUV8OgM8H9LEBziBrmg+ezgFIMD?=
 =?us-ascii?Q?zZ6hrrI9WH/FRIw53Nt2J+fONjwFXgeErRe2qyxpJuDGABSsvsgv79OxgN71?=
 =?us-ascii?Q?cINUYvMaPxW7VS5RDW7IEhuismWm5VQCBM9dhKlEgKmUttgf1Biu+yOy4oai?=
 =?us-ascii?Q?LYkcP3ztPG5W/Mr6JGuM5XoJ3uIeV/s6J9B0Ve9hUfXHIbFROymw2En9eekY?=
 =?us-ascii?Q?bV7q4xsf5bD8naV1GwHnULDyBlnjv3D4Yu0GalWq9Fl+OKMzlmV6Zb5hJ1PD?=
 =?us-ascii?Q?t/hTlIlWcT4MAXWg2iFrACFHD+fBaOGrDmtCh81A6MMpPXe83WedU5kp22yi?=
 =?us-ascii?Q?/Bk5EauqZwaFOOfGTNzxRZ66WL8hs6mcbiITVVZ1LuTjVxoIj9uSxi2eArD6?=
 =?us-ascii?Q?/ONCnrWYLK7bVWwXEy36KhQTers7NFaoEPI84V9VA+b9q8Sbdf/+MPBcIjIQ?=
 =?us-ascii?Q?yX2pIk01j65bNYgHQ3JDcI2pNEcbwpQHSemzHjOOXDZIH2Qxg+W4dXPJvppp?=
 =?us-ascii?Q?6gf4s9EILV6xaAdhvL4BzLF+qIK2LPI7Gt4D0jNI8ci7ABrfCkYVbfekr4Am?=
 =?us-ascii?Q?tVbU8lOGrsAD3VGRRPkVOvYmlORe5Ck9OF+jjw/v5YKugIyx+UMlPi07Jild?=
 =?us-ascii?Q?4S4Z9vwPIBCjQu26EA81yvlzopMVQHUm11z5pnaEoHreg+/RYsYkBov4m1r2?=
 =?us-ascii?Q?JQseMbXpxcwaZxrAVBC2i0I/hBhrfdE1OrErfXmnVyL80bvNxa8KJkLiqL9f?=
 =?us-ascii?Q?S0/xfTw95HZXpCCXvH0HExKxgVYT7PH+SCXF09eJ7w+SNoMoAv51lOEwJeX0?=
 =?us-ascii?Q?QOqmW5hR84DjHCfr5y1gJXTG4I7i/8gKwe1WywcRA1D2CpvJ1ezwXSGXyPcI?=
 =?us-ascii?Q?LIT4FD0qL+t7qePVjSSFI86nIzcvd+bpRP9sAiplXMULKMzlpGVtJhZfLXLK?=
 =?us-ascii?Q?jYOdf7iHNQFsK15O4IGCKRwrouTMScEWUAsIi1hdWJcnPvZxJw27HZ/TzJNS?=
 =?us-ascii?Q?PXbsadqpDuTNjlPFJXEJdYsmvt7crcOvi1/CMsG67FqrO/CJKh1xKZBHRobo?=
 =?us-ascii?Q?OgF+FXVo5zEoLXi9pDxVBYuoByylrTKRUBfV7w5GaKXNa0sRUfvRdU+oGDhA?=
 =?us-ascii?Q?okeIx+b1HDDt4LIhoMYqDLaAI7NA/aFsMHgTuJjFEYDg03pPN0BiF15ALBxC?=
 =?us-ascii?Q?nn+kgSUvS4wNXqzD04+cX8fA5+V/g8pYKrAK5QZxdhAT5Wu7cZl6H/4OMLCx?=
 =?us-ascii?Q?/fOmmkl/7HjLlNFJAfMef5MMK6xbtHCIcDG/5votlq3dLO+9zNAXv0WKE1ro?=
 =?us-ascii?Q?pis8dBSUyqRmSVY/yrZ7quRuiQmrAoE+++ifmvsYRKNKLhlwETYBHdFrY/rD?=
 =?us-ascii?Q?wOZA2O3ghFcFrVPF43wsZd5u7D4SoBXZoKjoUuAoC54x7kG5qhHtt9DnMUB1?=
 =?us-ascii?Q?lQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?MdX3aVS+lol2vOYo8VvBgI4WZMUh3nEtpGmRWkPPQ3+jgX53zsmocWc6oypo?=
 =?us-ascii?Q?91J4MAFNW2J2Plo1g/IQ0joXGmmF1K262JaFAmVfjnsqyYDf7XT//aQb3hop?=
 =?us-ascii?Q?jSk8snyt97/QJ4qQAZmICAoMgynqMkMJH4j2Og3jOTAWfaqYtblkMtofHeV8?=
 =?us-ascii?Q?ClLkVJDJ5qxSUdZocsgz4mlMwWesdBqKj6JWqSu52Z1nGbtPvuTXCh2x4Vsv?=
 =?us-ascii?Q?G6+IrFT97WE+xd9DvcT7yRp7HMPh2Tg28Of9d2i15hWKzE07GktKqtrMjP9o?=
 =?us-ascii?Q?Pk/PVYlGVxgRtO/2fu9MJAHfMLq0HpM7fpljbAuiW6GdxKlpl6O7Mt2e2Osz?=
 =?us-ascii?Q?7FzxPzyukmrJjUx1VlAcSFd/7ygeLHMAhVIRUP/CyOyOrk8NFzAYReS/50Qz?=
 =?us-ascii?Q?K5DUNX++7/2y40IQKuWmu9XGJ0nbAzXEgKsP4acYYry0tVLpZMr4q85FsDSb?=
 =?us-ascii?Q?9iz1ba60HZzcY08T1/MVXv0/gUaHPeRFETUjh10EEo+GPuKl5eIxQWK8Nggq?=
 =?us-ascii?Q?QTamLqu8Djx0jsSxx5/6LhYW6Wg9kM7JA2jHO+jTfFmBvt4l5JDFYORo6Kfg?=
 =?us-ascii?Q?tNoTQac0jk2LJVpr1+CjeJTaiEiowUcwuQJg3v6LDk+3MMn/kdLKnGJsb1oL?=
 =?us-ascii?Q?KAcgwwYprvk83uvLpYvlS+4ywGzVvEGbQMKxfUwoPc3d6Y6OopwPzNIM0RsP?=
 =?us-ascii?Q?249ChbpF8XuBd58ON0aoHgg0/D4wnoHa7lQIklNhdH+1Az9TdRq+b15mjJ/V?=
 =?us-ascii?Q?Uw9S80LBCbXhUZqHbMDFqke/desvimHmKFxvEX+vHMXqhyxBQW+n98mbIYQz?=
 =?us-ascii?Q?urW1qLuWE2NxAYhzF0xBTsAsK+s1RSdgjPk3WT2Ku4YMwscLln2jUna7YFRR?=
 =?us-ascii?Q?g/M+1cFtsXrNmSB4Tze/HAWQLWLkZ4QkhbadA4aT6O6WgbU3E/TbMy4Q6+Sa?=
 =?us-ascii?Q?BbxzE2nWSE0LWwRgwHDvQa9ZL8YoLM72cXsJiCkPCrAuZHWLAV3xk8Vianc1?=
 =?us-ascii?Q?EXpo?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66c47b92-5d37-41ba-dc78-08daa69f6cef
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2022 07:01:28.6828
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7uWGuz2rNJE3EgVttk9ELq+KaXmkyoJvNnWzQfcJtZXXGpWlBuPeBBkowGgvkQPX7s8nyJX8/yIp9mhbggK8Fg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5808
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-04_09,2022-09-29_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 suspectscore=0 phishscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210050043
X-Proofpoint-GUID: B50kYXinthac_yeMC_3D3u2FQ8cLc8N9
X-Proofpoint-ORIG-GUID: B50kYXinthac_yeMC_3D3u2FQ8cLc8N9
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit a5084865524dee1fe8ea1fee17c60b4369ad4f5e upstream.

Introduce a new #define for the maximum supported file block offset.
We'll use this in the next patch to make it more obvious that we're
doing some operation for all possible inode fork mappings after a given
offset.  We can't use ULLONG_MAX here because bunmapi uses that to
detect when it's done.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/libxfs/xfs_format.h | 7 +++++++
 fs/xfs/xfs_reflink.c       | 3 ++-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index c968b60cee15..28203b626f6a 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1540,6 +1540,13 @@ typedef struct xfs_bmdr_block {
 #define BMBT_BLOCKCOUNT_BITLEN	21
 
 #define BMBT_STARTOFF_MASK	((1ULL << BMBT_STARTOFF_BITLEN) - 1)
+#define BMBT_BLOCKCOUNT_MASK	((1ULL << BMBT_BLOCKCOUNT_BITLEN) - 1)
+
+/*
+ * bmbt records have a file offset (block) field that is 54 bits wide, so this
+ * is the largest xfs_fileoff_t that we ever expect to see.
+ */
+#define XFS_MAX_FILEOFF		(BMBT_STARTOFF_MASK + BMBT_BLOCKCOUNT_MASK)
 
 typedef struct xfs_bmbt_rec {
 	__be64			l0, l1;
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 904d8285c226..dfbf3f8f1ec8 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1544,7 +1544,8 @@ xfs_reflink_clear_inode_flag(
 	 * We didn't find any shared blocks so turn off the reflink flag.
 	 * First, get rid of any leftover CoW mappings.
 	 */
-	error = xfs_reflink_cancel_cow_blocks(ip, tpp, 0, NULLFILEOFF, true);
+	error = xfs_reflink_cancel_cow_blocks(ip, tpp, 0, XFS_MAX_FILEOFF,
+			true);
 	if (error)
 		return error;
 
-- 
2.35.1

