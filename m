Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF7755F501C
	for <lists+stable@lfdr.de>; Wed,  5 Oct 2022 09:02:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbiJEHCc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Oct 2022 03:02:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229901AbiJEHCa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Oct 2022 03:02:30 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE79874DE3;
        Wed,  5 Oct 2022 00:02:27 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2956hX8H004838;
        Wed, 5 Oct 2022 07:02:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=tYqw9wbqdyqf9VYVpGmch6fW4fs7Ni96Foh7E+F6/xY=;
 b=iMh6ey5qYMtyaSqqztkZnOual1jsV2mUhVvwqf80FM8CIz7SO9W1cjyow90j+ia1fPVL
 B09FNEtTlA0jb2XeiN2hNmsPK5p9XBxpFuk40PGbRIVmQv7tkYASLYgd422+zpHX2xic
 nLmPnEzSgAdnNGS/ZCkxHa3VTRlOAbRN4RH43B8SH+6MPhFN1B5ytiHtDFfAccgBspsy
 t6UEK7MCj8lXxolA9wFgfIWnqBgKx6darE5LMCKVpBK/8KgkxM+x6hSwUORCi2gNvOqU
 IpiEIAgwLyT6LE0hyNPWY5se1r6R0dCo/PM3kaA5VbTWCly8Kv1EiJNYzaaYoLYNs8XM YA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jxbyn858x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Oct 2022 07:02:24 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29545l5K005627;
        Wed, 5 Oct 2022 07:02:23 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2103.outbound.protection.outlook.com [104.47.55.103])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jxc04msr5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Oct 2022 07:02:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BaaUTJUes4DG/FI8Y87utlfWL0OZ5PvijEdI0qDfwlDN5bNVbXgYMYZCL/rahcpg1kVcZ3bGuSX3d70375pc/uttM/pG6TYdJU+i/+igU8nK/WPssEs0pW8GalZ5myJIreF/yQJ08/R1tmQjJibS4GgD3EF0O42aAgOgVK8RIjn+mNwKJcZfGLsJqzC3xEzUImAl+3J9RkhI5YEalcyIVLZcOSoKMYpeyJP9ek263OBqjfl29MUVeXXwaWtlT7SrDtB4YyLSfBFpfMnptgP/lA0fOId/Zzq+PEqh2tx+DMvOb5+UEZuSHm78M8cXx41pOwthyNl4BCRKnlX88rvv8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tYqw9wbqdyqf9VYVpGmch6fW4fs7Ni96Foh7E+F6/xY=;
 b=YKr8OwqEKSOr1mxXQkeokql1xeWVv2s4Peuk63IJ+7UmA9mLQht+Koq0nEn4WhlEk9piI9Rz6WTCrPQ5OtUv3egamEEjNT5Iiw/NbaR2WeRTqi8mIYx5yAT2zawmlctmEoVTx/61j+1mnhlZ1cAEofwwswMtwGOzkfoLZV0J8EL1Vz6haTQIeB2Yf4OPV1xcYnZSFUwWHqWIgaIvWiMHFy8vZPqL4JO4Tb6FkA7dSrgZISsG0l/F9pGncldJ8xIXlNOY3+vcwyaApv4p4XqOyGGVoo+S8fvLfix3Ks7b9ppYDxjKPFv3WiyfdYxm+hInniQpA6ZJ+28f/bOFyCzipw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tYqw9wbqdyqf9VYVpGmch6fW4fs7Ni96Foh7E+F6/xY=;
 b=NSyA3cOIrNpGTbt3oXFyxDfL/uhzdDJQ1zqFSSgsI3jOsEJCUc4Q3hbn/zz+BD5z9fMU343eufQDy4HAp3gj3eSyS9EosqQFZQhXycjTgxrB41uPkcRrmMxESmR70RE38H0swnFt7QoUVdwxQnAjVdufU8OSzI8yRxp1FfefPj0=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by DS7PR10MB4863.namprd10.prod.outlook.com (2603:10b6:5:297::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.24; Wed, 5 Oct
 2022 07:02:21 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1%8]) with mapi id 15.20.5676.031; Wed, 5 Oct 2022
 07:02:21 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 10/11] xfs: fix uninitialized variable in xfs_attr3_leaf_inactive
Date:   Wed,  5 Oct 2022 12:31:04 +0530
Message-Id: <20221005070105.41929-11-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221005070105.41929-1-chandan.babu@oracle.com>
References: <20221005070105.41929-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TY2PR0101CA0008.apcprd01.prod.exchangelabs.com
 (2603:1096:404:92::20) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|DS7PR10MB4863:EE_
X-MS-Office365-Filtering-Correlation-Id: eb0f5134-f5df-4df8-fa22-08daa69f8c4b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PVZbnZbmF96BZXbpxEcRsqoi8nhkSL5LQUP6qisBQhusg9COUqDqYtOW/7XX0Q12nIsbKQu/fGdVu/7PjCq9yrqOZdaaxUYPcG4+BHy4ZYQTggyJs186XnBhKYxc5thhYb/XJOvsKTSsIBv3gJbwSC2DTSydlOGfrgvCMkQ9SwGHuSyuwug2yRyxLeY+2JdepDNIOFbfCySYNPmJ0z3KBIY6miM/+PbFakMGKy1/DZ5nR2uYMO4QzDupDZba+mZLun+xV+jWVIa4RVmkqDsxjE52qmgI92RXHhrE06SzrSu1lc1sIxu+4r+wQCzKl6UevDaEGVVT6Zqv1OaPYBv1YFBWJCoEpVXkfZj4y1XmIMz9Qv+COtSjxBvgKPARQkhU+zd7nf1Ac6dI+0MQ+4VykdirRda0ckoSI7knuT+vDWSkqcUKzxnJS6rIt/JQ6iwLU85M0sD7Qc25CqAKaivn3umdqOOYdeXUG4ErunWBz41TYtvF+90kbqV6tDIzt43BKPBnp4SRJmZj93FrU2g+hzBV+s6UYudv8s+sGBVw3MwPW8q2bfcrOsOYykYFPFYMTsNxZR5uGroqrA/2PbBvI+0FnLfHH9iXFYryG9874EKyHv50W/aPCzyU8xnDzmBYDNh9zbdrweaDlgbm6vnXvdTmPerySDNv9fGYm6WO6GsZ0cUmMMpU+ncPK9XYxWDSZN+EY/6loe5r1mqE7VacQg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(39860400002)(136003)(366004)(396003)(376002)(451199015)(478600001)(6486002)(66556008)(6512007)(2906002)(66946007)(5660300002)(8936002)(2616005)(66574015)(6666004)(4326008)(26005)(8676002)(6916009)(316002)(36756003)(6506007)(83380400001)(86362001)(66476007)(186003)(1076003)(38100700002)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pHuUDM4+EKDKZEkS6bmlo7tKgj1uPtTjKJn4EaAM6TN0ur5VUg8kNShE4ZoU?=
 =?us-ascii?Q?IbI7MFsbpPFaNvzLM9XEQkgaylo5iQTAiCXfQCUbeo3z7CBCrp1KL5K7ZCkV?=
 =?us-ascii?Q?PseOVUnQFH3h2iSZ+uCHChokpi6nv4X0hd8zcWCquattIZHmg/FWOJLSBpUK?=
 =?us-ascii?Q?LvZQOhZi0NRPQtkN1KtGeUHIcwsU1uW3J7vUNTEoVpS6sOw2PYWv4qIBziwj?=
 =?us-ascii?Q?Vq8hvogjvI5WQblc5SnodSVZVwU9zoFKvkAh/2yKArkbFCXY0/Ayxr9JRsSV?=
 =?us-ascii?Q?ARGQpJ+9vSPQBDD8Q3FTgyE0fmIdTle/o38/fx/Sgkb2Rq+VCehoosblZfu1?=
 =?us-ascii?Q?gYl6T1zkU66Rc7vSnzZevt+lVrSFYf0lQ8VkTB3/sWB6TvjNzikCaBeYdyHq?=
 =?us-ascii?Q?Fw4MhJtwGZGwRkY/girQ/klgmS0nVe+WTkKvexlvPd4EnZ62ZTPC7cqhje+o?=
 =?us-ascii?Q?eCrfV+qprSciWhLeH/8kvc+bKQgviwMFgaDGVoM3x4Z7tDjolmHy5I9gaD9j?=
 =?us-ascii?Q?nKIclLu0Q5s+xoxTqurp+uxfOxFRlDDBJtEKn/SD7J6MAGClsESYjdmwCu9M?=
 =?us-ascii?Q?f8m1xooEONx/yxO3AIlfAaHE4dZGRufniP+0qi6BQrYohph00BbRB6bTh/GB?=
 =?us-ascii?Q?/97qzojr6ZjoLZfX+iLvxqeDVBokZRNRuIhDQSVm/ITeysrFt2E24zv3Yh4p?=
 =?us-ascii?Q?o0lPTrx9M5NC+jWAkI1+VpHa+QluS2mvlB3/ubyYz7ThddM6N0POOG2b3opt?=
 =?us-ascii?Q?ZEpcX+JIxjjnQGQcSP/GG3oQq9eD+PN/85QJxVaoph4hfgAygHZKOu3Bq6RC?=
 =?us-ascii?Q?l3+0Me6Z5YHOTU4Men/Kh2fK5t+BZEnm30CBPwA2lUGUqk7bAwh8s8KH1EMl?=
 =?us-ascii?Q?oHGvTfb98f2kh5edwHWaPA1m64fPnCImw5JUzq4g7pnuFhljJIJnT/qQ6zx5?=
 =?us-ascii?Q?rGLP4ZiGrWCpcELGXGJWUl9kWS97vu4jLwRee5ocNu8jnkUvmbu0uecsgYWh?=
 =?us-ascii?Q?ueQkJfOgsO4d5V4tUrafxk6VxHXFmjwcVbPzOcHFDJvWS0m2cYkr2cpYHpJM?=
 =?us-ascii?Q?h07vX/xDgON6OiI0LOHNS8VcVPY7B7nThI0Gco8mrKcM8ATsMbXHLdjJbKMm?=
 =?us-ascii?Q?EhV5HAXP+66WXIm5BKVMnzNZx+U2zKcJ2fRNrLbFVRoGkMp6ukzVPZodQGQK?=
 =?us-ascii?Q?oyGnnKXcaUi8ilIcnqaR22EGghuIfYPTrtsYuI2w+A20aC9sT1mYRcUGY7aB?=
 =?us-ascii?Q?R48P3RnTfK9hajxMU6WsORz1S2T1MysYyM8ND0QvsPI4pEU/10JCsP92fr/f?=
 =?us-ascii?Q?9zLBuPV5ZYsc57+O2c/o6h7NIz2aJYnGL0nUp3L/U3oTQRKTaf0EJnBC36ex?=
 =?us-ascii?Q?w5qOvqwthN6p9WKaxp/etf3eW2Iaf+Ly3W/OXkjaLKDMJsZfYW+lusVbrZET?=
 =?us-ascii?Q?8HdsJiRDiswfATzl+PyFsJdB85cd01b/vH+aPn1CblnHimNRQL9MbVlaba9M?=
 =?us-ascii?Q?hUyxd2QsvbpG2mO0EHmSS4zPCKzVm8QvkzVx1O6BLMLsFzKSKPxmL66ODoaZ?=
 =?us-ascii?Q?Yi7ethouOKZToz42U08iDP4BUrTYukI9/gz8EJn01tA7L3JUYJsVKow82T5x?=
 =?us-ascii?Q?Kg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?/hbHCKGtHq/z0J4CtAbRT0AFy716M3W3llPffc5anyYnBR2HDazlzJvpnzOy?=
 =?us-ascii?Q?oROQsFwoM+Q+CZ5oXHTGdCqWXChYCbpWlfH3VG3L7q6y3JwGQipj9rUh0YaQ?=
 =?us-ascii?Q?n3KC3lYfw5arBAFYlRh8qhuiy4aHBx960TA5M1Z+OFfIwvKofUscAgerBhlx?=
 =?us-ascii?Q?cyOyIiUk3jHEs3w6yt4xCwwx5LRGWwQXIaRvMjob5/UkNbAZ9zLpJLyb4Tiz?=
 =?us-ascii?Q?ayJiNPXxR+8HHURmABCIqBaVVJ1+PymnwaeFdpxRohkwgKQUlSxW0jODJAle?=
 =?us-ascii?Q?vf7Ei0DJo/9kahmt8kBOBmzB2RHyyVRDl1i3aSzoW03WXBvOpHzOl/V/9Gae?=
 =?us-ascii?Q?PqjWisUWf2Eyn0K4JDfU/A8hFmUxv1xkks428/sVdr+zJRJAL9jvJJKpAbCC?=
 =?us-ascii?Q?EQgQkFUe0ELxB3lsJXWfyvM+U4OaCUF83797t20vVdIUW4Fi4JzL95uQPgyI?=
 =?us-ascii?Q?Umkm4KSbFN2uJ9MdqtbT7QF34PZnwzL75xcoAkQRUajOGZkpWsuK+bDCT7Gh?=
 =?us-ascii?Q?Ie42xsh+8YjVRvwzX/+j+R8f6T4XAkfSyjJ4cU/2Ibof59Zj/R3cEichrBzv?=
 =?us-ascii?Q?UJ7A4xaxkREF1KF4SMTZ6zscMzh5zsoB2GhdC0jdj2hP8a8vSxj5OUTAti4m?=
 =?us-ascii?Q?DMS5pblwo8x21p8csj7+sb7he5W1YC0iMQsw2zUd6YhO/NhlVyaN1OQamE2W?=
 =?us-ascii?Q?XT4nwnWq8nVvFWmvoz7bv9elORMS+Y4maYCTDyE9gOaBxDqNf6JZYpcsOS9X?=
 =?us-ascii?Q?LUIc8MtSdJbhCR27Yo7Zp6NTnbJyJg7n+R2cF9b6m3ty2RJu7kA7Kh0qLCsS?=
 =?us-ascii?Q?FEKliPOBI5ohai0ZNLt0Ii9Ff0JO8pAzmDM3drXpPZbLSnWuschrf39mOlXe?=
 =?us-ascii?Q?ZNY8DXwhGXs0+/PDG5mbueH+V1cSPrCojK45LiVHbDwQk8KssIUmVVvY0nuy?=
 =?us-ascii?Q?PIdYiqeRV9K8qNdmI9HviDssi6Z9Md4P6Hxv8RwOzDwUvRxaI8Bj+c2O1zUB?=
 =?us-ascii?Q?7u99?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb0f5134-f5df-4df8-fa22-08daa69f8c4b
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2022 07:02:21.2177
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WO0oUoopS/Bz88YPbmj/s0A+Juump5G/84XrKQwjSy0ackXm/b6FpsbqqGxMtv2eu5mtdf3DEMp3kJEhfTsxsQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4863
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-04_09,2022-09-29_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 spamscore=0
 suspectscore=0 bulkscore=0 mlxscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210050043
X-Proofpoint-GUID: zU8kBUVfl4QWKSuwVKirMSegInbC-lmq
X-Proofpoint-ORIG-GUID: zU8kBUVfl4QWKSuwVKirMSegInbC-lmq
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

commit 54027a49938bbee1af62fad191139b14d4ee5cd2 upstream.

Dan Carpenter pointed out that error is uninitialized.  While there
never should be an attr leaf block with zero entries, let's not leave
that logic bomb there.

Fixes: 0bb9d159bd01 ("xfs: streamline xfs_attr3_leaf_inactive")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Allison Collins <allison.henderson@oracle.com>
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_attr_inactive.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
index 1f331d51a901..9c88203b537b 100644
--- a/fs/xfs/xfs_attr_inactive.c
+++ b/fs/xfs/xfs_attr_inactive.c
@@ -88,7 +88,7 @@ xfs_attr3_leaf_inactive(
 	struct xfs_attr_leafblock	*leaf = bp->b_addr;
 	struct xfs_attr_leaf_entry	*entry;
 	struct xfs_attr_leaf_name_remote *name_rmt;
-	int				error;
+	int				error = 0;
 	int				i;
 
 	xfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &ichdr, leaf);
-- 
2.35.1

