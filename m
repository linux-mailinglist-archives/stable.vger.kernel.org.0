Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 209435F501D
	for <lists+stable@lfdr.de>; Wed,  5 Oct 2022 09:02:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbiJEHCr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Oct 2022 03:02:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiJEHCq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Oct 2022 03:02:46 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACE3874E0B;
        Wed,  5 Oct 2022 00:02:35 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2956he6d021627;
        Wed, 5 Oct 2022 07:02:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=We0LomCLoAqWgV8osaheCp2GcnRfLFTB9rWqIpkPigA=;
 b=ZS5T8upjMls1AcJFqDtFXfjnhEGNl1VKnNlRBiFU04pziQc5xUvO+ht5BwEg9PMwDDpo
 Ea4vR4HRt6xOmrqg1CNOSy6KiqldJ+F4SBDKxbbiq9qFgJesrgodcvKBgBPAMlPEJeHH
 YMQ7H2XpaoKqZR6REFVZWbdZu25REXaPOg7Lq//dyfwxggP6KE5+RMPYnHLxeV29VAcT
 ohPiAwPOn8uIe2Tb6VMIZ7ch4fNV0r+gtrixZz11ysLtKtLUJoqwQItv3+kc/7+4YZ7H
 OFSmKBLtXQkNkVvoSLdhLhwl3xAQX1luCuhWXyaAFsUxGrwqW1aFCrp7HmjEmaRjQtMw sg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jxcb2re08-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Oct 2022 07:02:30 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2952Lwlx005363;
        Wed, 5 Oct 2022 07:02:29 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jxc04mst5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Oct 2022 07:02:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O65+c2zwKqZGFLG5//r2y5ez8Vl6Ho574wychndLykL0ukesmvhvXeA8NhrrmT3EUsEu5nypAF4Jx53kj7q/GrFktsWu+FmCKcB/yfoIPTQLSYpHbFGfY0WoNc9AMJIcDxeO0R6FDhigJytqQQIFjccKfpUD0YJRrLvm4dNNJE0nwlF6QAYz66JEUZEpGP/hiYR2zq+7z7wet225zSMf2hh746GLzF+Ado66p5d1Agv+IxHi4ew6QA+jfvm6+CJUZXC2USmwukw2l50+qZZJIfgay/RJ6ucT2Sr0YtT4eb9hVGhsrX16w65Xywv8zDEkIsqNXSuq75Tk+LHxEYLzTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=We0LomCLoAqWgV8osaheCp2GcnRfLFTB9rWqIpkPigA=;
 b=DpoXhClzF2SqIVFu7htagV8vcKsIN93PsYwF+aTAjnRs9UTTxWjQ/QBxZOD+nzq9fbBJiBetRryqTiMIMcEaQpTia3wf5Dmr1COawGhAIzLpo2Y3wiMXelDI1AF458ffq54MlxZ/pgXtA82cQXaL6Kz6Ik/x2uXbTDnrtbHmcLluxkNVc+gunYpml7H1XudzUPx2oEF8w8oILrLX5uwnnCrD9aWEC6LdAYAdIT/DAWwxcN8Z+xYZxcTX7noHvCYMmCmxZwbRQLT+CbSrpyYjXhiKNzZ7ojDxXwUlKFwKxCDPDERp6jJ8ovtLdt/QvLrG1gn2lSHZA4/RIr14+AK5Mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=We0LomCLoAqWgV8osaheCp2GcnRfLFTB9rWqIpkPigA=;
 b=cNE4A7jc8rDRzklTrrpGVryHbT+JF6GmpnQvvgLaM/Z7QS75Y28JJwobY76XNc13g5MuSYqexn5x6fOjw7VnNCXGXAdXk/P+Jg8GFYGtCEV7E1jrcBx93W+lrLfxuAHf7QpV1NLObdKduw496GyMbe2FoEssEkoUOvRd7d0qQqc=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by DS7PR10MB4863.namprd10.prod.outlook.com (2603:10b6:5:297::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.24; Wed, 5 Oct
 2022 07:02:27 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::822f:1816:1c2c:43d1%8]) with mapi id 15.20.5676.031; Wed, 5 Oct 2022
 07:02:27 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com,
        amir73il@gmail.com, leah.rumancik@gmail.com
Subject: [PATCH 5.4 11/11] xfs: remove unused variable 'done'
Date:   Wed,  5 Oct 2022 12:31:05 +0530
Message-Id: <20221005070105.41929-12-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221005070105.41929-1-chandan.babu@oracle.com>
References: <20221005070105.41929-1-chandan.babu@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCPR01CA0132.jpnprd01.prod.outlook.com
 (2603:1096:400:26d::17) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|DS7PR10MB4863:EE_
X-MS-Office365-Filtering-Correlation-Id: 0027688c-66f4-4529-214c-08daa69f9014
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3Ta5AkoPcmHHh2j2zjQigeo59b1KzGqura8CAqPCso2XAihW3kJ1bjJsIKKI7fA+LVjmTEraQs21ps9ueR3+zCo7Z775pQyixXJZFn3YouLWOm0v+lfkEokjUOpMIABcDg8jUw/x3N23MiUH1H1bVc9s8YM1zjJo+mdn+K8fKvmArm0TtS6c2Y3Oh9JdL7sDMduXbi5fEFNPLpKLZZVDdDjDmuz8QiTb+Mpu9mv1Ddcmo02c5u7cw/paNqTct+cKd60//lugAocjlNQ8pgojUWOUPK5m5ap3DkTrmQLpqjtAXrzi/tAtoglg4KM6280bdxRU58xbJ8nSciElXlqNUmqtnteWIGN6UTPXsMG05PsW3idNHOiJDGi4T+DEdyHtYL2SXOJCmbuq1v+lPC9L7zLn7pYsBBimcVBYfhJvA6GesFhLpADRUM1RVBPbfpnY0NFNjnJdK2yLXGtTY/yDdE9dhxuJdh32sFzJg9Ktoo8NbPTF4QFHr+fzZHHUnysse7jupB2ZawNDXQY/qA5EtrrcWiZPJxco5XGuXsZBOu4eclbJc694RhrxEnx558n0036Nl2XzVXhT9r0PGlA/AVQTarczo/oZxV03aEMxLp/g+GPNwXpSNJLH4nEji4OUWZqgDHftd31HcMS3CBmxXMeYEdcNcn0gO5giNhJOUFi9kjx7lkB2WhRMUS6PRbRaH8uXvNESUtTmF8ep2CjvwQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(39860400002)(136003)(366004)(396003)(376002)(451199015)(478600001)(6486002)(66556008)(6512007)(2906002)(66946007)(5660300002)(8936002)(2616005)(6666004)(4326008)(26005)(8676002)(6916009)(316002)(36756003)(6506007)(83380400001)(86362001)(66476007)(186003)(1076003)(38100700002)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?S5HHyOr+3ofmhIGFKCvB6HqNFlwWKcmAxYvfuiBUEA3nDK/4FUe+iHOmIvf7?=
 =?us-ascii?Q?2rA7IgUVuIkuIrfnmaCXM41hSqp2qxunS4wagtZJ8qbm5XLjQoKD6v34PDaT?=
 =?us-ascii?Q?kbiczcNu/0xFZaUkWcYGvSyuCCF0Ep/iyXnXbBREyIAKq7zALoRsWXqrdrLU?=
 =?us-ascii?Q?TJ41lj5yvpapTZXYQL9NI/wvAjzoKUbUszDN94AeIymXazKm2TMnp36YmYqk?=
 =?us-ascii?Q?ywVcR9dk69Ft5c6zWcpl/dOxqPkhqSGGHqRTwMFGyfODiGH5GaHAmtWObUPE?=
 =?us-ascii?Q?liINJh7/TQpEwEkLAdt0Ov4CCByjsdpa1pTf3l69iWSSZmKgC7AtlKjIDeHB?=
 =?us-ascii?Q?JjAKxTO7ClLDT0T41v5Jxrv9054Si2tcQi+FJ/Fb8dQZS8TFmLnOdVv3cbur?=
 =?us-ascii?Q?PaZiX+XGxx+pQvADuNrxvaRg+jZnFSreDrZPUshKwpk3zuH+/kFnbJh+0vTg?=
 =?us-ascii?Q?m8w8Ce0TeRM6bUA318/COy6Rwrm9CrxizAhsyYVuhKpN3CQGo2EXI/kH53fC?=
 =?us-ascii?Q?NmGtjWKfg57Hbk3L5XNnBR5eitgCSLNDpxhpLmuoGIi5IleTfqLSbhwUlbXq?=
 =?us-ascii?Q?NlnWi9n/FrCETTMqK/ryweMN53hH2MLy3NhgQRVzOVevMoueJPtrAyyR7fM/?=
 =?us-ascii?Q?U2Bm6HONXvyyBwMDDOfbKYQePinxGOHSfY50NX00wLABxDhkiC2oPFakQPtX?=
 =?us-ascii?Q?X6XPBjGc9CqJJSg/owrlq06N22bKwsSscYwpTyOL4jrJBCH0+crIVBEFTsfN?=
 =?us-ascii?Q?EzBAzf7nu4M3ZviaCQQ5CpKsk9xC4u1p84cJ5cI3z7yp299AtUY35VQSN8Uc?=
 =?us-ascii?Q?wZzAiJbBZWPEY9DGsW6WucUNdduW7TWTowFSaJFsx4USRrkU2DkpV1RcSL+y?=
 =?us-ascii?Q?xBKDIxMSDYXQrGrOyE46hMSA8itMPYega+zBtF/sOaXevzGWVPMoH78Ih6Ly?=
 =?us-ascii?Q?5ihp8Rm5h69O84UOVksR26Rb26vGMGdUsiyBhVGLcjsd12u1/uvQWGqyWKhQ?=
 =?us-ascii?Q?8AAPtddT4ipGqxVBJxlqH4tpvClBldCA8wpxiLJ4Vpj25QtEMbub+Gz3bPTr?=
 =?us-ascii?Q?SDDsDy5t/FLVx5u4CWLse0oXQdlqd70bWAW3zB3O9ytcV5EEoikczQQoDTe2?=
 =?us-ascii?Q?DujnNAaGjNHAEY/IH5rz+LM7ktVQN/zZvxLvqX6EfnXDjD9+5wDpu5fywclZ?=
 =?us-ascii?Q?DLggzQblPA9JMa254Rwbqa6q/Xiz8ymD8qG0+5/trgBTiC7jwANqrmV4N2TI?=
 =?us-ascii?Q?UZwuEmTklIdU9esQbUT1mVQuCZqBue7jf1yn5Iy9qv3tnNaHKTNsJhJLVB9P?=
 =?us-ascii?Q?+pzWt+RGhJj0Z1qU3pyKKfYC0x4l/PdWpyUHbi82SdYEr8iIu5+HhS+B72Mh?=
 =?us-ascii?Q?yzxNqDUbd2J4INh3MW2p47Vsndq8+hZyeRzDmVrzGE0b1Uv+pfiXC5s6aZMy?=
 =?us-ascii?Q?ssJhnGyBzkVndIVUtjsN2B6uh8YnpV01htpftVEiEY58XYPzJNeFF/WV3akO?=
 =?us-ascii?Q?McKB4cJTxde1mvVHzsKLYqHGs40zuSP8mTpt802mig8SyJ2xcogVy4B81+As?=
 =?us-ascii?Q?Dyo04S/XdSuceOv/He5JO3O5fjYP1iVcz2QPvsQygY+JVG7RzLYvdMbBEZ8R?=
 =?us-ascii?Q?wg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?dfatUilwiP3FQl0b6+mB9kEWDkOM8tIHUH82aqwTEG0sv7P9Cik6UfBtWld6?=
 =?us-ascii?Q?8U1qtzktSSNXaPnbbGq1K0VadbItOQhQ3okDRZp8QioryDawu/ND47VhhGLS?=
 =?us-ascii?Q?pinKCfHNrbLT6BTGCqVx5ABuY4+G41zVG9tBzp3ayEs12KHUAFnuxO9x+pmG?=
 =?us-ascii?Q?oc8e3d7xjGvx4YEn6PxdcN+31u8lrEUSnOHQkcPkhBo125Iw1NCrS6TxG9+R?=
 =?us-ascii?Q?/mtizjkdRbW+3VQq56epBXJjtpY300dmYMZbsiNXtgmRid2P0xM72ghOKf3E?=
 =?us-ascii?Q?G53/xCrHAbknHdtmyZGfFWD5b9wCddtbKlaTzgx5mblhW92WCzo2w1ev6xPT?=
 =?us-ascii?Q?feON+s/ZUPYVMOhTkrqj+w5qJQN+Oe8oZEyqjfjzX6LGOJEzYkLIMAS7gRUX?=
 =?us-ascii?Q?dQmc6S3Vgg/H5dAtzKLQkOW9ksJMONTmhcYeR8krwgPJXkZCgVFWyO6Qd0NM?=
 =?us-ascii?Q?IkDqxbUzgo5/2W5PBUKQIc7UcgRwv/7WQu/f0J0e8P9CvpLc26zIVaKzDLm3?=
 =?us-ascii?Q?S2qrFyVV2kO76WL3fV87VcZiDHyTO0lPU5wZifFzMTrbjD/pbAtCqGOeQQyG?=
 =?us-ascii?Q?kN2msVa5WleQkFK2+nm2VP/ndZGhJldpWXREWrZHHIqsIRfjV4pVREYUnmzY?=
 =?us-ascii?Q?u0DuU+pptWu2J8bfvwhQ+KMZibDoq1REJiW7PU0JvaUL2u22W6b+/Uq6sFZF?=
 =?us-ascii?Q?G9gwCcXbv+5gDJFL4BWykA5ALes3wFxHvWHzx3Pi7ex3bsmejaNX9StXDgBw?=
 =?us-ascii?Q?f+80Pga1nyPnFp1Vd5g5BeVPcTqYwt2DxGMfFOacC4u4u8mQw/MYyX4LWUK5?=
 =?us-ascii?Q?gzEqjQc8RQvy0lgvLQ5Z+nV/V5F4ajm/t6dMENGhnEHiayA2f28vJPw3rQ6S?=
 =?us-ascii?Q?udMD4uZRFn4FVu8tRXwM2iiE0gvJG7KojhmXujkdT215N5pHoIqfiG9jjkD3?=
 =?us-ascii?Q?42dSYGP1FVlpCiukf/pU1wHt0PuFgkJKYDkbwPGwILyqioqFlODV/1zL+u4W?=
 =?us-ascii?Q?WSXW?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0027688c-66f4-4529-214c-08daa69f9014
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2022 07:02:27.5782
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qcUee11JEWVT7mLsVbrMQq74cn9MERz5oNyTA5Wf4H1uDJHKeggjZ3HYbIve3qSSwL2gQiLdKeYhZB4agU4smQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4863
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-04_09,2022-09-29_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 spamscore=0
 suspectscore=0 bulkscore=0 mlxscore=0 mlxlogscore=961 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210050043
X-Proofpoint-GUID: EcmQW8FVhXnYBoe_KC-ZnzRrWX6kVdRt
X-Proofpoint-ORIG-GUID: EcmQW8FVhXnYBoe_KC-ZnzRrWX6kVdRt
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

commit b3531f5fc16d4df2b12567bce48cd9f3ab5f9131 upstream.

fs/xfs/xfs_inode.c: In function 'xfs_itruncate_extents_flags':
fs/xfs/xfs_inode.c:1523:8: warning: unused variable 'done' [-Wunused-variable]

commit 4bbb04abb4ee ("xfs: truncate should remove
all blocks, not just to the end of the page cache")
left behind this, so remove it.

Fixes: 4bbb04abb4ee ("xfs: truncate should remove all blocks, not just to the end of the page cache")
Reported-by: Hulk Robot <hulkci@huawei.com>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 fs/xfs/xfs_inode.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index d4af6e44dd6f..30202d8c25e4 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1515,7 +1515,6 @@ xfs_itruncate_extents_flags(
 	xfs_fileoff_t		first_unmap_block;
 	xfs_filblks_t		unmap_len;
 	int			error = 0;
-	int			done = 0;
 
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 	ASSERT(!atomic_read(&VFS_I(ip)->i_count) ||
-- 
2.35.1

