Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA7B550FDB7
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 14:53:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242694AbiDZM4T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 08:56:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233690AbiDZM4S (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 08:56:18 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 532A917CEBD;
        Tue, 26 Apr 2022 05:53:11 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23QCT1Kp031660;
        Tue, 26 Apr 2022 12:53:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=iSsL4Q9EA1pr3eyY/fDdlwzoxRtSFXdjj7iCXXvLLss=;
 b=QEKcNRRwgvDdWo6IE95vDvZYyPybpnbqy7VyhTXv0S2n+nCwmBJzat2TAHr4eUOwZnsG
 T3cj4CqpExpuhzLN6Ty9YUkspC1dXiJM6m7z9vLbxhATQqKR0gBoonfrYnpvHCEmoM59
 iD212vCUS44HEh3FHojYnu7TdZNIj6wJGZUU0qPbA57ZjEUd51p5TBGqNwvn+NlgsY7X
 Sk8JtNvaLbC3QvcjLRo+4/O5nfpS6d4Jx0Re8iXWOubbn3RrYzYIcuuBNN07zl2uOMD4
 InbxSm29jKms/mhxYrm78zB4Y6elZs1UVBrkiMETZyjc3dQROmfj40Um5P+Qkzh367Bo Qg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fmb5jx1e8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Apr 2022 12:53:02 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23QCj4XN014499;
        Tue, 26 Apr 2022 12:53:02 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2109.outbound.protection.outlook.com [104.47.70.109])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fm7w3bg3j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Apr 2022 12:53:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=an1s1NkStzEO0s2B6VccyY4Rhd7K+K5T0B2mZSUVSOHa2QCNLpkT6MEn34yPtyrZf7NP3nWQtvOI/wC1KHFhhz8CkIEvEJgs2J+eSUcLVw88ESqmNob0BOyRXxmtITpryF+Caa0G6Yk7LREDcNFg3K0T4k3r3SAelo9xE0cC/fw7ajWWGWmVah05aP3Aoalqt26PhWQZVuV4BoSn3y57LNGN48Cb2WO5JyNJF8JC7y46RjLMULXmSF8rKvG9EGL/MBTZC59XlGHpwS6Zt0+jfQQVfoWMPQTWQgN5Zm5ouEM++PiDM1W/keZQ2uWyCgewxU2HYltMhkT1oQRc7C3j8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iSsL4Q9EA1pr3eyY/fDdlwzoxRtSFXdjj7iCXXvLLss=;
 b=S5Nj0nKiFiyCPA+FbLrRos6FHSbU7S/Izv1Pd5sLOhSPBdLQCZvrY9u4pa2eGrbwhat/yq9RcwGoFNrAb3IdcAGGJ6xa1WPnUQaY0DNGEGRBc5MAyTBC/W5Zu+QD7lSSNQgUaEZcXQnEoDSSh5MupWQEEADmZnXTxlxpiD21c7xk19gsgHzxacqpRRlnS43LYu08MP4uM3IsY2HcDcPI9LhAiMaIODFR7aKvwgx4B3KpKYnGE1MZDObmCualEWaEi+LbuTHkhNn1wdPgy4MaOfbfsD86eBlJMp3BIV32IcBZzPN/lchsOGKGYKBp3AzVgaEy17XNFuygEGGc0xCemw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iSsL4Q9EA1pr3eyY/fDdlwzoxRtSFXdjj7iCXXvLLss=;
 b=E5uOhGGaMmM3LkCuppfNbR7isfWx475l9mdonNLA3iaLLWnumo8YwMe7hVKub29MQ6mC8rQLSpDbcScPsefnH7WfL90ChVkSQpgh5PpxIcO2q21aEXXd+lAAgsR7o+3n7+2wTIx3MmfjgxtpUyTtolL5bFhqz16e+0Sr/Cm4iUk=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BYAPR10MB2983.namprd10.prod.outlook.com (2603:10b6:a03:83::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.20; Tue, 26 Apr
 2022 12:53:00 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::d1db:de4e:9b71:3192]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::d1db:de4e:9b71:3192%9]) with mapi id 15.20.5186.021; Tue, 26 Apr 2022
 12:53:00 +0000
To:     Xiaomeng Tong <xiam0nd.tong@gmail.com>
Cc:     oliver@neukum.org, aliakc@web.de, lenehan@twibble.org,
        jejb@linux.ibm.com, martin.petersen@oracle.com, dc395x@twibble.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [RESEND][PATCH] scsi: dc395x: fix a missing check on list iterator
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1czh4t3ab.fsf@ca-mkp.ca.oracle.com>
References: <20220414040231.2662-1-xiam0nd.tong@gmail.com>
Date:   Tue, 26 Apr 2022 08:52:58 -0400
In-Reply-To: <20220414040231.2662-1-xiam0nd.tong@gmail.com> (Xiaomeng Tong's
        message of "Thu, 14 Apr 2022 12:02:31 +0800")
Content-Type: text/plain
X-ClientProxiedBy: CY5PR04CA0026.namprd04.prod.outlook.com
 (2603:10b6:930:1e::21) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 05daa1d9-9ea7-4787-fafe-08da2783b1cb
X-MS-TrafficTypeDiagnostic: BYAPR10MB2983:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB29830EA83A6F1841CEF0AF678EFB9@BYAPR10MB2983.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EDngCKURJbXBTuzLgTOTVIFiqWJkpSsdK3xoojYeBQHjmqOII2qxKQGCx35s9A1/I8pujeHe9/j35uc1Ly5LiCFk7PPoTyEFOS8aApzu6kQoUL4XpU5JRKg0J3d94w+pcwTW/FO0IeucHxWz0iSSrBbRMF0RlWI0tXa+RTn/MTGoTZGfrXuf+iUtHqDo+ToB8/gFQa3m1JK+c6tKH/zzfz+OwJYH6H0AyKFL/Ne49eaU6gLaEc46kKWfNLGE2YNDedhBbq1MPMxj+NuZZanJeHzKiErt2oBprz4CyVU5Vs4kGjAJdBUinV6SnOAg/9YZd5BHahm63xi+2Po+7d0bBQZU/NWKGZdB1Ib/AthbqAVLWUUwBgHXHv/lh+ne40JaHNh1fIZQsBksAnWRJ5ZP9J2QxZv8jaFAU5dGGm313QgatW6mx4az6w19yhk7VAHYcFomf9JmHMZadJFMOdx35V5yWRs3CHF5kqShMoVVw/AQNCgF5a01Pd0ENPmOqSlhSm7v/tF70dLIHZDlEhSIYZza7aorUXP0vG5mEDZRaDpapy0oSbqmvkcQK6tzgzgqBBGb83Iqg18IVXBwd/Rncr7Qg9G65/MVjcHKxb50stFb2KHrf/F6qFegaTr3gkDWhrMFj8e2/BMK4ZlCkCd43nAGLFrD8Vz2Ou3OYMIlXHAxfl3b+gp9tjEdWWxVF6p1rRIgwwDSodRkxffWYS0qKw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(86362001)(8676002)(66556008)(66946007)(83380400001)(8936002)(26005)(6512007)(2906002)(36916002)(52116002)(5660300002)(6506007)(186003)(6916009)(66476007)(6486002)(316002)(4326008)(38350700002)(38100700002)(508600001)(4744005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?15pxeCgM9kDd1HyOfLn6L9baFpnIaTp54LAWsLuvZbCwLI6I6NzFvyN0f/cf?=
 =?us-ascii?Q?VuevIQ8Ttf8veCHb2kZtfXmxdGyqk2q7qSCyDf4RKY9nu6b5PuIrRO5M0fsq?=
 =?us-ascii?Q?6EqggNY8f+yxadnUkMKovlqS2J3G/p73cJE7GTw4mb6SrQdUiFIiTmzRQ2cu?=
 =?us-ascii?Q?mBOlmdbY5hOCJdrrujLGl0FQ4wZFzYU93T6Ue/vq0z0NeCIj7sbY0TZ6WOcF?=
 =?us-ascii?Q?P2B+n6HIJkz60YMwNoNMfEdWiq7ZM8jc+bhNv5EOm2ihQTv47V8RaJb5OpdY?=
 =?us-ascii?Q?WYbKR5zypCGNmPBOx3Gmzkqsh/JpqshOE9BfAoqCO7kzySIuVkeH+TKdxYGB?=
 =?us-ascii?Q?kFfH1VPe8TFleFQKEcu+wSaGh3BLZs4svTtz7M+SoZge4cPGxSPO+cdRwWEH?=
 =?us-ascii?Q?rinYadFPnnyObFQvTn82n4lt73fLRdiNiGdVIAUgygBSBFb6rZ4LxM9+aA8z?=
 =?us-ascii?Q?eSCUCACW2E/EEHCMe7llTMWGGRSekja482jcSAs3NFhLaaaUkDXcdrfBPGOi?=
 =?us-ascii?Q?lC6hr7hGw82ilE60mnaKx0fdfIjmNJMj8cdKIPPtydROG1aMjBKy1eNcDhaJ?=
 =?us-ascii?Q?1Q2H38/N50+7sOVqtgT+bYylG2Pi69hDW0QXfXEZCy1YyEXnWBb76598qnE0?=
 =?us-ascii?Q?O9BLSHiofqNxm+kVluDJs1kKahY/+hReOwioTX3bTVEkLKYBGshLbzf0/hUi?=
 =?us-ascii?Q?tMlT2IYGCCDr17MagoLs3sEBdh03gcPf1HlpY3Rhys/kEdEAZBDPoB63rMh2?=
 =?us-ascii?Q?7xxiwZHhmAAoD1kYm1GlGgz/uQnxt8nsuqlaC0weolDGT4R+8EgZ25oec8s8?=
 =?us-ascii?Q?doowxzUbDYtIuxxbX9HVTNsUTApXLBj9KnjnNolb49mZKxqUZNNTiePtQe/n?=
 =?us-ascii?Q?rJCgmu1BeiupWmh3hlyzk0XIHrU9fNS8oOcWR9gPWFaaWfBXkoAQZKflHzNp?=
 =?us-ascii?Q?MydpwQtkHpScHTU13q9MgKXVU66HuNMa0eNmmTvSmlDlqW3v9WEe832+qUuM?=
 =?us-ascii?Q?2WLD0wvuKqYniL2ZKZiCaz5ZxUK3C4yt9BThNp/+bm2lAX1v6uvSRyRU9gQ/?=
 =?us-ascii?Q?9qs49LRglfWupJRkpsSJpCIZ05Xd1kAdFCNXUB4huvktJ2NBrYrh0ihz+8d0?=
 =?us-ascii?Q?uFuN6XVRJLDwJdEkr7ocIqae2i8+gIft08bbybFsowICmcL3s/AVW6wwLWWi?=
 =?us-ascii?Q?Hanolq8YejSmyVoPpk97EAZAHFvjLPgvVe2nDTwkUofvAYSzGsI8f4lA1nvQ?=
 =?us-ascii?Q?4VMWypd7gyKfp7nUEDTcn1XRC7fKR8Pu2mfAatfgJQGa+hKLs6qqdXcfHrNg?=
 =?us-ascii?Q?beylVLR3OicUhbMShLuzst4pLjfiloRK1U7PQ0rNgSUsYAFVaEqr3n967c0c?=
 =?us-ascii?Q?9RtsxvI3myje2WmaU/+tGBovB7COhknRSKV+/qZPDcZn83SDY36T+WXHVBwE?=
 =?us-ascii?Q?/SzaxP6rSy3KRruoQ76isrpbO8eDP8ZU3FobHvj4uBESAM6c1W1IRGJ0UpgQ?=
 =?us-ascii?Q?BcGL1/ksg9fkRXqSWNfU2tTrsM8IQP2csyXbj62TrANWJPv0CbI1qynGCfeq?=
 =?us-ascii?Q?+8vUDnN3gGfGaK/rXsJHNSP+fmqcx5jbtDlDR11LcWbAxvWing4rEzIfhL5y?=
 =?us-ascii?Q?Iq+zxThd8vKRmBMIUi2xMKRRXNaL4oImpUwdwQDYt3ZoUi60uM4dAzak3Npy?=
 =?us-ascii?Q?KuWMo42nzqwVCkwLQStox/mfJpHoBEjGVt2d+2yApsXyUreT3mbUIgIHBC9V?=
 =?us-ascii?Q?svxYQqa3wCAodfv3d5e7lwPPTahODXs=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05daa1d9-9ea7-4787-fafe-08da2783b1cb
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2022 12:53:00.6292
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uBYvUgsR0tvG1kC0/4wZOH1hOkmJc7orqaHM2L8ANbGH1q+QhxzYg29FEeqq2LU9RjWcnyiw4yut6JZOArggibDgjBzQnd76sUrlxLDS2KQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2983
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-26_02:2022-04-26,2022-04-26 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 mlxscore=0 bulkscore=0 suspectscore=0 malwarescore=0 mlxlogscore=877
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204260082
X-Proofpoint-GUID: US9KUivD1vR0nZ40JUbU6-e3hSQrQGZn
X-Proofpoint-ORIG-GUID: US9KUivD1vR0nZ40JUbU6-e3hSQrQGZn
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Xiaomeng,

> The bug is here:
> 	p->target_id, p->target_lun);
>
> The list iterator 'p' will point to a bogus position containing HEAD
> if the list is empty or no element is found. This case must be checked
> before any use of the iterator, otherwise it will lead to a invalid
> memory access.
>
> To fix this bug, add an check. Use a new variable 'iter' as the list
> iterator, while use the origin variable 'p' as a dedicated pointer to
> point to the found element.

Applied to 5.19/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
