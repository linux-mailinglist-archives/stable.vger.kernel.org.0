Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7EF26A7949
	for <lists+stable@lfdr.de>; Thu,  2 Mar 2023 03:05:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbjCBCFh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 21:05:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbjCBCFg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 21:05:36 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FDE14C6ED
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 18:05:35 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 321NWtPw010775;
        Thu, 2 Mar 2023 02:05:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=06dkb4/chwq21DxXO0rNVXic8AgazvmpoP6KFz+AHVM=;
 b=Th9tjlvX9f3UW6IIAunG9kZwXtgqC9aiSuNyo5wxzjxLhNsxx1zQjhircBap29YJjqB7
 KXLAJFWZ7saWJ018ggbIGRq7YCobn2eqQOe6FUaBk47iUkY7b1rHesxHDaOqQhPyuytE
 Lz5zbX0oxXN89U58rRDVFY/I8AWXYitcnHdZ+SJxgfPcjKa3y7vxf6qz+xjlqJ8Yj9Sy
 QtvimB7oOJ8BHi/QzoY4oRbaR6+ZcPt+cyjMEyUO31pYCVjxXCw61kepy1xUzjiJxMoZ
 zF+AS+PvkIyRg7LarX1R12Of5M2yTd64WlTUXVJ62LmmIC5b2otn+sQnb17ZHJ8enWRa sg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nybb2jh2r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Mar 2023 02:05:30 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 3220pOW2029431;
        Thu, 2 Mar 2023 02:05:29 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ny8sff38y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Mar 2023 02:05:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RiCIpJwndLsVHOET4uLkMDq9Z/kbsZfxVLRax4S3C9uUssMG2/wfNlFvKfKQJq9u2RrAGDv5S6JQ0Uv0uvBPYGtEhAN8aflOS2wUngJqD6zQEjpa6zhJVLOIk5WCS0a5FZJ4G8jwoheObiOPXmH9EISWPy0HpWOWBZMICSGq9X3EBnnrD9kwvN1TfE5HpdkSBO5YgCJa62E2YQrXKRGbhjEOGf5LiH9yft0/t0s/O003zQVq5jBrCLwlsCbBWI3tOxrEUqQHMps2yhjKA7hTORX+838pqmRHcZAjg16cbcn/CYZaLsDkkNtrCFmd45Onb12CZBcwROA2yd//lsDYeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=06dkb4/chwq21DxXO0rNVXic8AgazvmpoP6KFz+AHVM=;
 b=Tk+CXX8R1cLr7Qji/D8mVvUFJZxQiAE2xo1qmh4tel7FMWRYsE3azooIt9pCEiDYfwmZFnYHmZvtn6+cc1Z78OSM0eIIs1Lugx3t11bF5mjc7MfZfB2LVFfEkbyVChSiWEs2AFGihva1ejoKcvXIr0PqelkAOCbS7uVnizMy5OXnuXQAmecwgW50xBZPtqaLmBsMdOqvs2ycgYiJv0D7u8SkUuWc4OdJuxrOyfA2BGtm63QuBbVQzwy4WlAxsOI5qg+7i0/7JSnI3ONwa9aXckP3hDqWlyQgJlWtE/AAY3lbbRfToUzmMuUpfS7yh/E0ZI7v5i3cGTl8ryecE3HVLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=06dkb4/chwq21DxXO0rNVXic8AgazvmpoP6KFz+AHVM=;
 b=kQgAlcDU8k1BWj+RE8rGEdCd0CvYnEtRDeV1Ry30AniT4kstZa2aGTpEH+V0ZIGE0vrExMqz9SmA9b67xR0uNxPy0c3AQN462/uSDVFMdzONyD5aNOLZvZOxMpIV1ZRhPANwYO2dzHeOm3m8oQ62HkE0PGmM660NNpjfyz/IWGU=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by DS0PR10MB6872.namprd10.prod.outlook.com (2603:10b6:8:131::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.17; Thu, 2 Mar
 2023 02:05:26 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::df97:c045:6f0c:974f]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::df97:c045:6f0c:974f%3]) with mapi id 15.20.6156.018; Thu, 2 Mar 2023
 02:05:26 +0000
From:   Tom Saeger <tom.saeger@oracle.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        Tom Saeger <tom.saeger@oracle.com>, stable@vger.kernel.org,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.10 v3 2/5] powerpc/vmlinux.lds: Define RUNTIME_DISCARD_EXIT
Date:   Wed,  1 Mar 2023 19:04:53 -0700
Message-Id: <20230210-tsaeger-upstream-linux-5-10-y-v3-2-f7f1b9e2196c@oracle.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230210-tsaeger-upstream-linux-5-10-y-v3-0-f7f1b9e2196c@oracle.com>
References: <20230210-tsaeger-upstream-linux-5-10-y-v3-0-f7f1b9e2196c@oracle.com>
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.12.1
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR05CA0033.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::46) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|DS0PR10MB6872:EE_
X-MS-Office365-Filtering-Correlation-Id: c4956a1d-266a-421b-985e-08db1ac2972a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QC8RLznQibyWK6Zk3yx33qduvWa2ZOdvaOJphCnw+fwA4m23jyKw0ttQoSyfVcJbn9FE6PRoInyDx5BBDe/F3a75gLaMXWF8IAjGKKnZAE2xTWJZ+fiefCOIIc2u1iEUjQdM5S/V8AvyL8PsScKDmJhEBCvmof/ykRdfAJ0gsIpDcFRfj4ReelDmvD8SCMObAQBDRoIq1iXjxpGTUT3whdYRUVcM+r9W6BaK5+fluGk0BRrkPfESO6/xs/+plIeKA0zT6demeGU4Yt9ODVagB1c7V8OfKWBya3vl4vld0dClHYLfAUuXwXL7C/6Uzvc1s2fb+IuAaZ03K5llwNZ3JZyCq9qEFYwBdUwwuZEiwXCDQ48dXmqKmo7HT9mFe6NhOCBUeCjmUQO+8qTxu29DkcpfJOzjLnHuhndVHEY6lC+Q4jN0OP2dKbC2h5BKdpsV7xU86ReBUDe7v0DugI4Xg/lR0nFPTqKh8sLOGH4L59vmHfPYT+EaDltAmH9n/HXIrdLSDyHGCUoJs3qjLlRyQfx3pxThElGf8fdF0lN2/x90UA8D7rplPIYyrvv4yjOky5qANrVO3Wf/F5exb0ol3cq0EFqLrtawSLRX6hdQ8bw5NYFc/pua4ILwlSTpO++k9QsYQx7/cvB7uQLsuXbFvtP9hY6CkzLXU+4OsqornMI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(366004)(346002)(396003)(136003)(376002)(451199018)(5660300002)(44832011)(41300700001)(4326008)(6916009)(8676002)(8936002)(66476007)(66556008)(66946007)(966005)(316002)(54906003)(38100700002)(36756003)(2906002)(6486002)(6512007)(478600001)(6506007)(86362001)(26005)(186003)(6666004)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MjRCbE9YNFgrQTdNV0t2RlZSS1luZE1ZN3lSQlF0WVg2NzBPTWFjSCs3d0xD?=
 =?utf-8?B?aUk1eG9WL1pFcU12ZFBqNGhpaWwrd1ZvME51ZFNnSjg2UG1PTlJjZnA5YS9R?=
 =?utf-8?B?TklvN3Z2NGplTmhFakY0akhmdXo1Q1QyL3NVUTVmSUVET2pZOVhmcWx4YWVu?=
 =?utf-8?B?eXh3RzNONlJkSmxNbGttOHE1YVU4MFdXaHJ4eUpnN1pzZVNLdmJrZUZRUjEr?=
 =?utf-8?B?S1VGOXprb1VVd3BUSmdZRWdzb2xOempteWpWRk4xNitlWWxBcDlpMG42VXFI?=
 =?utf-8?B?eUtiN2locVYxK2svczllb3dudTI5NjdjLzZwYkVhMFZzYU1KREFVa2lMVzVJ?=
 =?utf-8?B?SjR4QlVNRkdPM2VWK3FISmUzeFVEc21SNE13YkpMUVJLRjJ2Q2FLWHRmMDNr?=
 =?utf-8?B?dlpVaXBTOHJNM1EvNytueGN1bXYrb0xwRnJpenFCRHd5b2JqdkJzU2hXV1Rw?=
 =?utf-8?B?M0FrQzZZN2lYMDNUalFFY2l2dXIvdEg4dTJkQ2NxZ2c5TlIvSGFlMlZLOXNS?=
 =?utf-8?B?MjBkcHdjdzhacFpDMVJSZFhHYlBqYWVrano2TjFTV3JlTmowM1NCNHJyUXpi?=
 =?utf-8?B?ZkJaSUdaYUtObkIyUjhQMWF3TXdCTHMvdHJ5OGhsZnpteDQ3RUdvWGtSdUZx?=
 =?utf-8?B?ZUpSakNFYkFQbFRoKzI1MElJSElxWVpFVFB2ZjNvRUp4dG5KcUsxMHRVNnVy?=
 =?utf-8?B?dmI1Q05VajFrYVdBVzh1ckltajAwakNqVlFRRlJBUFp0ZTROa2ZieEsvT2VW?=
 =?utf-8?B?czIxVitaNytSSGRkUnlScC9ldkR0WC9VckR2QWsrVlQxdjY0UTRDL3RIRWJq?=
 =?utf-8?B?Wmg4YkJVU01TNUN3dmc2dkMyN21vbEcyU2c3S0pPOXBWT25jcldYT2pDTWVO?=
 =?utf-8?B?V3BkVk4yV2poNVJVeGlvSndZWE9DUnpkNXRlSktlMCs4T1hnS1dyR2xrdThW?=
 =?utf-8?B?YmhkRGJkQUtlNkhpUzZrRUZzRUZ4TG1obHo2cHJiWHlIdE94djN2UE5jN1pY?=
 =?utf-8?B?K1cra2VmWUc1UzhyMThYbWpEYzhGVXlYV3AzV2kraEZwTmZWSEN5N2ZHbWlF?=
 =?utf-8?B?R1lENzNqWU9wREJNMVJXRmtDSWN4Kzc5R0JzaDQySWZwdW1VZVhaR3RwVlZs?=
 =?utf-8?B?L3p3NWk2VmNTamZIc2JGVG9hR1VFRDRxMDNYUTR6dkhzc3ZaMEltUXY3OFRw?=
 =?utf-8?B?Rm1aOXRmRk5kWHNsR3ZPa29HYjJ4V1REUFJzZEFvdG5kdDFJbnhOZUdtUDZK?=
 =?utf-8?B?OVc3SE9Wc3NoSHl4ZytFRThKZmd3YUI3TU11L3M1UCtmTlFYREdVaGc0T1hL?=
 =?utf-8?B?d3hzekl1dHp6b0dFaXdIcnM4WlZHbFhOUkR6Rkp2bjZhbzRTbWxUcCt2U2c3?=
 =?utf-8?B?MXdyZWZVUUZSZDZGVllJSG9BU1FzeG1laUdKTEVCODh4SzNaMG5BWkZ4dU1o?=
 =?utf-8?B?Vzl1RlpxNFBmS3dKdVg3OG4wNy9pTllIMXhyeStDRTdBdklCSWpOc3ZGN2hS?=
 =?utf-8?B?dm5kTVFKVEJsQWQyV1ZqMGVvYjBoa2RpaTJtMTNFNk4xcjYxR2F4aW81T2tH?=
 =?utf-8?B?QjA1UHFuU2Z2TjdNcGNsMDdPRDM1QlJWVzVidEl6TU90Ymg5Qy9YM3NERlhH?=
 =?utf-8?B?WFVaenNZWFFtb0dSSENneWI0OHpqcVRLQ3R0WE5CQU1jMXBDZ1ZpQUNXb1lZ?=
 =?utf-8?B?a2F4eEF4ZEFqQ2UwZnMxWjFqTzJNdDIzWlVpUjdJMENCNkJiVTErcnNTK01z?=
 =?utf-8?B?S3h1NnB1NENjTUlDNWtBZGZXL1A0WTloVlRhNFM1bExFRENqZThCN1p6UUpm?=
 =?utf-8?B?ZzhFTC9MSVU4TWN2NzBBN01hSmROWG1yQ0ZGdWtWMEF3anFrN0ZXWmNlODJX?=
 =?utf-8?B?eGtDd1BWTnF1WVdKZTFYZ0hhaVlVOGkwN0x2YlF2U1hKUWh1bTUvbjBKREFZ?=
 =?utf-8?B?QVhYV2VjUnpUT2NCYndOQ2dTTko4LzlUZFBaYmtXRCtZVGdpRnZ0YnJ1MkNy?=
 =?utf-8?B?eFV4QnJzTW4zUXAxbm9RVllDNEhBSldiSEdKbmk3NjFGeGsvSXkwbkpROE5F?=
 =?utf-8?B?aHFXVFJtYktweHB4SVNrUEcvM0RDcmk0Y0J2UDR5S2w5RFdvMnFGSFlza21G?=
 =?utf-8?B?ZW5IazdvYVVseDVtY0lQUno1Q3lRRUY1TWNHL0sveGVOQVcwRy9SS2k1MEZF?=
 =?utf-8?B?R3c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: D1bQKysJqX7Y3EmhB2/IDkH6J8yAsyinc6W6Lk/s6q47blZYhyBMHCW70LPMX5JbQv/ZXfjoCg3w9wLIgrl57wSziC6ADM3NvOX42KBYtz3DGDc7LGx7E6uNNNMakWzs8GSWwjS+qEI4xV+Z5hwZKweejLEn5uFcdWWC/SZM0H01lYveJbp/kAxthMlxnkOAN965kn60n8gINXgD6efM2KeWlzmGhA8LiRzByYTgveXK17LhSMJGRRjQV6Kn/MlcZmkO3n8RQWEwYZ4G1aiPUsrsh94VMDEi/rz7dqDVCaqNFqHyV3mGxfnu259W/knkTwqDyeemDU0/NfSDgWm/ur8p/Ne2aI2pqyGapQat7lOSoAhiy0vEuHvKXktVMsEG0KwTrCLcV6UAJ1uZa/jk4CGX+T9s5YNQVaZGmOOsfgFB1QdWaARfoauKbQcH9ksstGiEGPQcs7zNAxIwJgeTa60/V4xFgKMsPWg3CNndNUdIVZyNkf3RDVQF73N+MriUQoUXrOse13ggDV1YZpvN0/pv6MM1Cwr3oynBpnnNYPIt/CNGydEi3K+q8NqRELJ/ugYJCueIr0UMun7tQAwEjzwESiHdAUvvJ+qKpW5tjMnvBfGZHpJ6UBjXm/XcA4Ah9MD3WokSfhnUkYYlgDAxQm+GN5SXbmNqI1YEv0/1+VlkzNmwvt4Pz1a8qCiM/Hjs9JPA8iOU88U3H7kzWRsGp+l9jnMhHRpKH+OE55/PPXG/CGvIrMsf4DIOVr/AMuW3SkheQWbpZvlZQn9+O6YcFo4WOuoOeP9W2UznoDGQkZH5y4MM87DNbsuQdyEL6G+H00+Fsh4+ZQickMr/D4EVFVyaJeHsXqgpVcPr2gRTr6OWYO9vhzJPGmOdcCeXlIqh
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4956a1d-266a-421b-985e-08db1ac2972a
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2023 02:05:26.6904
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1OFSpF/Z5rKE3i4uj2TrqDK+mVuy6ivURt3QErxsNC/1chR4k2+q+EJ0NLoiV6OBh9puFo7ACccWOJy1b6sEEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6872
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-01_17,2023-03-01_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 spamscore=0 adultscore=0 phishscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303020015
X-Proofpoint-GUID: j3R6vVb_Ia_vG9xmusWVrS3QHp7X27EN
X-Proofpoint-ORIG-GUID: j3R6vVb_Ia_vG9xmusWVrS3QHp7X27EN
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

commit 4b9880dbf3bdba3a7c56445137c3d0e30aaa0a40 upstream.

The powerpc linker script explicitly includes .exit.text, because
otherwise the link fails due to references from __bug_table and
__ex_table. The code is freed (discarded) at runtime along with
.init.text and data.

That has worked in the past despite powerpc not defining
RUNTIME_DISCARD_EXIT because DISCARDS appears late in the powerpc linker
script (line 410), and the explicit inclusion of .exit.text
earlier (line 280) supersedes the discard.

However commit 99cb0d917ffa ("arch: fix broken BuildID for arm64 and
riscv") introduced an earlier use of DISCARD as part of the RO_DATA
macro (line 136). With binutils < 2.36 that causes the DISCARD
directives later in the script to be applied earlier [1], causing
.exit.text to actually be discarded at link time, leading to build
errors:

  '.exit.text' referenced in section '__bug_table' of crypto/algboss.o: defined in
  discarded section '.exit.text' of crypto/algboss.o
  '.exit.text' referenced in section '__ex_table' of drivers/nvdimm/core.o: defined in
  discarded section '.exit.text' of drivers/nvdimm/core.o

Fix it by defining RUNTIME_DISCARD_EXIT, which causes the generic
DISCARDS macro to not include .exit.text at all.

1: https://lore.kernel.org/lkml/87fscp2v7k.fsf@igel.home/

Fixes: 99cb0d917ffa ("arch: fix broken BuildID for arm64 and riscv")
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20230105132349.384666-1-mpe@ellerman.id.au
Signed-off-by: Tom Saeger <tom.saeger@oracle.com>
---
 arch/powerpc/kernel/vmlinux.lds.S | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/kernel/vmlinux.lds.S b/arch/powerpc/kernel/vmlinux.lds.S
index 4a1f494ef03f..e3984389f8ef 100644
--- a/arch/powerpc/kernel/vmlinux.lds.S
+++ b/arch/powerpc/kernel/vmlinux.lds.S
@@ -8,6 +8,7 @@
 #define BSS_FIRST_SECTIONS *(.bss.prominit)
 #define EMITS_PT_NOTE
 #define RO_EXCEPTION_TABLE_ALIGN	0
+#define RUNTIME_DISCARD_EXIT
 
 #include <asm/page.h>
 #include <asm-generic/vmlinux.lds.h>

-- 
2.39.2

