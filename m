Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6AA26DEAAA
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 06:41:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbjDLEl5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 00:41:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbjDLEl4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 00:41:56 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 916061BF1
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 21:41:55 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33BLUDkH017728;
        Wed, 12 Apr 2023 04:41:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : date : in-reply-to : message-id : content-type :
 mime-version; s=corp-2023-03-30;
 bh=7clHApe+dnJTJaXfpe0lu1oXlJQw1vmwcd4GuzPu0b0=;
 b=MlYIxlFh6tK2GrBKYjUtnuhdUeeyNW03MjGs1dT1mIdapayRjp1tKYL5ZN3ZZ70ojKey
 /UZalLbez1FMlfElg16nYjIDrXKMRYlkDx90NgmidFYU74TyoVAdNBqtRz531Q0faxnz
 F5naPrhyS/ZmLTKjjlfYCXG9ayuCLnC1Pvb2b6fozHgbYSaua9N8alVRoV00AkrpXMC5
 lU48hvG5rVnbFDQ8YNX+gbmjekH+OqdOeRA3JKVc06H+WoJGpuE/Md1jAx3htOLDxPRo
 +kSRPRvWmhUUf3dud4ks3MotvgEzBx3u7KQu7OgfqDWBvl/z8hG62DAdtmeWtaPLnsv5 2Q== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pu0bvy3vs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Apr 2023 04:41:50 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33C2Sn0d012775;
        Wed, 12 Apr 2023 04:41:48 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3puwdq18km-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Apr 2023 04:41:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yezw+FgEJDEj3Q+VgKfv87RnwPUMjhLdgK5KKciH3W7JumPB+VrdIstmVeEYRMFtTKGOksUQKXiEVIcmuoLehkdmP89B7m3nBg9U9u5oj4nu6ZjSX/g6w51bFPq0UK9vBLvtFDRPl3b7ZU8mQEDwSkmaH4ElTzCnxMt3zmDGXCJeD1oXTm1b0fO2KKF520V2QXQFkhF/SM9jUs0UOx+POa+fPIGmNe8PTQaPd3VMnbGQPtv5o6PkzMB0zv0WKohcJqJ3b4Zh/wbjA1dZjNotd7xTedn9ohPam/BUN7JWyGLxPOtP33R1PdwLXeVaLYAGMj2HJSrzL0o0cvWm9NRxMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7clHApe+dnJTJaXfpe0lu1oXlJQw1vmwcd4GuzPu0b0=;
 b=dfOsBnEvInGhDCZ0820Jul4759pUjPllLZtWsG5HEy9WnI/jdU1dK1hkV8mu0kUtxi1S4mrYI2EbqmWsyCDMX/gsiGrZo/DH6zhk2lM9Qso0tD+9NxJRCJNm7PUyWOcYjqWMfGmgcdqINjGDtFuZA/er59tY+/Isb4TknPtvfEMQiZq41uGr/op8CZq8UK3iQlJs7qHwFSkb9G8hbp+UidhJYSGbqZlyLbJEo40FGp9lB2+fjVk5kmuQ5PWx6nQHrbeoxKhGS60yZZeB4OS8LNowMDXHmvE/2wWcSSldbXwZEzQk4dbTtQ/VE3COx68LCwy5gvPVHvYNVUx9JX6aJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7clHApe+dnJTJaXfpe0lu1oXlJQw1vmwcd4GuzPu0b0=;
 b=kdm0JJfRm3Q1u50Fk6EyO0W+/+JCiWrL0SFLxEwGeAVsQ/XprwWZ3/dq7fi4JNUgkTP8PO7KniI3QA5XKbKmlbPA471UPPEow8kogYpoyQLiKzJEXWB8Atu08FZgcELUg5OTj40rWJYiei00DYtGeRZFMoT8rkodGQCtD+QSpGw=
Received: from SA1PR10MB5867.namprd10.prod.outlook.com (2603:10b6:806:22b::9)
 by CH3PR10MB6833.namprd10.prod.outlook.com (2603:10b6:610:150::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.31; Wed, 12 Apr
 2023 04:41:46 +0000
Received: from SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::b3d4:e7f4:7f85:90b7]) by SA1PR10MB5867.namprd10.prod.outlook.com
 ([fe80::b3d4:e7f4:7f85:90b7%3]) with mapi id 15.20.6298.030; Wed, 12 Apr 2023
 04:41:46 +0000
References: <20230412042624.600511-10-chandan.babu@oracle.com>
 <ZDYzp9l2Ku6cbtQC@ec83ac1404bb>
User-agent: mu4e 1.8.10; emacs 27.1
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     kernel test robot <lkp@intel.com>
Cc:     stable@vger.kernel.org, oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH 5.4 09/17] xfs: simplify a check in
 xfs_ioctl_setattr_check_cowextsize
Date:   Wed, 12 Apr 2023 10:06:59 +0530
In-reply-to: <ZDYzp9l2Ku6cbtQC@ec83ac1404bb>
Message-ID: <87cz49lnjz.fsf@debian-BULLSEYE-live-builder-AMD64>
Content-Type: text/plain
X-ClientProxiedBy: TYWPR01CA0041.jpnprd01.prod.outlook.com
 (2603:1096:400:17f::16) To SA1PR10MB5867.namprd10.prod.outlook.com
 (2603:10b6:806:22b::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR10MB5867:EE_|CH3PR10MB6833:EE_
X-MS-Office365-Filtering-Correlation-Id: d1198fb9-3113-4083-b580-08db3b1038fa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rd5kuCrvjFBJ02sstuFd9857dMrqA1cFKNF/AK9WMctJ0fpyVhj0cDgBHcxXKUUyLyN3H0I057XMT37EVeKeN8PvoY/3FqH0wFl/mINUtsBQjbJ7jeoGZMkRK2qBFD/lVlCVXbZk2t87yjO+DDzVd8vxuriHLCah4sb+Nj+OIANVPEzFYyx8nHJpfM7Og7/CQ3S2GzM803P//aSkP6+Lwb1fFVyj/DAXYrJR1QrC1EHKUHMr2LQdNffn9umjemmPmUY0wmVTAxEvXcKrabAINBhOtv4PvHKXlmHphCpKCyQgqWLFRPy77KUOZ0zC+l5r9uwoX6TycAqZ2Clw1emtUfKs7z/Z/+X6S9JTKKXXy/C5JC4ZHaGSvAOQsTjcq7tR9VIghxjlpTAiwutBDtzI8chEXjcZVdwczmviEZlYxgHC/xUCU6LuJ6QLvNm6D+EXicp1+HsG8Le4t7VqaYzao3e98+iO9iHVAgzuvZOKVPQ2ep1N1Je6guHLVr3lU/GAKGKFntJ5MKA65wuT3vnNUAcMmP7gnLySZLNUsLajJ03mCSyPDg+kJd2hYnat9k3kJhi/k6lM0s0uOyYYJ+EtfQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR10MB5867.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(376002)(396003)(346002)(136003)(366004)(39860400002)(451199021)(6486002)(6916009)(478600001)(8676002)(66476007)(66556008)(4326008)(41300700001)(316002)(966005)(66946007)(86362001)(53546011)(6666004)(6506007)(26005)(83380400001)(6512007)(2906002)(9686003)(5660300002)(8936002)(4744005)(38100700002)(33716001)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/ZXXKUAKtQVosNe9L9gcRhTVw5uiYNw+qv22uefr+BqqVeoYjXJ+HpGWMUjN?=
 =?us-ascii?Q?on2OZa/QzCy3zqKcpnIztFoJZKCIQtQna2eVImmyyxat6I2HoL1XrzX9z9/T?=
 =?us-ascii?Q?94oWNvyS03L6z0E6lmQnQxoaPfvwtQecEM+f5Glp6bki8Dzl5FFJG+EsTGyA?=
 =?us-ascii?Q?r74xC+Aao2JCbtoIeRVlKg4kciEt4jChDVW+rty4QoWVSIFh5KGYBV+n7zy2?=
 =?us-ascii?Q?IPi6x6vUr69xOBaWJJkEb6E/v+Xf57NcKf0lXFnSzilTFhTEd8mKihJYkbOJ?=
 =?us-ascii?Q?T3dExh43ML3asAo52uj32SJTd498nB/qL8WE3p+YLFDA2xNvEN890qJfCKsF?=
 =?us-ascii?Q?IvrerilX4sp5WqxpnE7/SOfHlC9C0sweSwNl7DJ0uOxhARBBgayqWidD1Wxh?=
 =?us-ascii?Q?UY3q+1jLRZb5XkwM5RzpoBFZOgo0vXojphPf6X/7aJX7yyp4EPLzbNd0EBKm?=
 =?us-ascii?Q?OrBqVuViKLEPVGEy0oDWSQ8c/6iGOxxCwfsUr1pL96pys6589AnQ9NwWjTT/?=
 =?us-ascii?Q?YdnZLzw1CwTIrTiLEQYJtgsm5rEQdaeWmUaLa7dT2eH+dQkJL94BK5C0mfH+?=
 =?us-ascii?Q?UHhu4821JIurIgsFy4mfZiceziLuLH/qsDL7YPQbgw/vBZSebtMHSQ1CqYwv?=
 =?us-ascii?Q?5rQWnoYMzEXC0jq5fCh5CSYKpCDlYTdqj/0FstBKtkulv2Zv3W3hprq3OImi?=
 =?us-ascii?Q?Vkk7F2M0pFJVwikOQdmez5c3Zz1goqdQa37bhVu8SVzT3tl/ZbPbGlRYA+Lu?=
 =?us-ascii?Q?khqYdBmoxO3q3H3V3p3XuoB5npQ0naqgstBotceGtSrM3NCqZ6DkYZzgDZTW?=
 =?us-ascii?Q?UvR7aydJhlTqU8VJasavPplrqxC0/qbJOM9g09ubB6rD0Fx1J97c8GtFKZDj?=
 =?us-ascii?Q?ndYEH9gr3fREEP67uDDwQHYXnn/0Yfr4J/9J6I0vvlAyqKKlOindSnuwkPy+?=
 =?us-ascii?Q?TNCrMvmAzJX+51DrLBNhsAry8tImtWgSFpb9rwQ07B7eaD4HtA9hvf79PPTv?=
 =?us-ascii?Q?z5TKoSTJiaLL2hmNoqIRTm20+r6Nn9FWUT46wQt+Arf2stxsjiKjzlUIssG7?=
 =?us-ascii?Q?f+1CSlnPW66EhokMKvdizfciKYFMl3eKz2Hj24rwFnYLI9PXjDHCcsMT7njE?=
 =?us-ascii?Q?TJo3zw3NDsRCmB/oQll4lMPMJFbXNSLlsL9nNDsYvdEit72CK/A2RWdcQfuR?=
 =?us-ascii?Q?9eibsHsauywyXZOvzzFFHWGVfCwegvsX6OT5p9AUaYyqKb0NSixWW9N+Xj5N?=
 =?us-ascii?Q?t/tsm7SYqQGW5vemBnM0jLoRmeZRtf1vz81zaskOu1F4fcDjc3ylM/Vkbauf?=
 =?us-ascii?Q?A3KDGCBjdR6GeJWyVylwuTzzz87CKnsYZ610TEgLTKvg43r0iL/n8GB4gKEy?=
 =?us-ascii?Q?RG4i4JnbR6viaExBsYjN0nb8F40ACQ2U0tTZBh3hj/CtySs5zp0wKYzK+WoZ?=
 =?us-ascii?Q?laWn+WuSdbKkXdje6EwpdAwjcm3ExVS5IK6gRRtPnN2GWLUkbwxjskBSxTKz?=
 =?us-ascii?Q?GnOV1YTBv9eUjAJ22KnpMXlW3Xzu6lTGJTwsNlhHb5KOYybUEsqE5QcJN3Ih?=
 =?us-ascii?Q?r15aPnKiIVJtbMdTxXqbmT6a9T5JDZsbmhH7L8xk1qIBIkXr0yxnQhwxt4C6?=
 =?us-ascii?Q?sA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: GGBq8r57LYMEN/CCRHMkphn9YoDisT0/yIOnptHD+JSegZ457Tw8ATuzcHSJ/10QCHZsTjyJU/FRy6zMIJYaE64nunyMLvibKD9KLsDFDu5HuWXfH7vLedpSbWVT14ZM/zmUzttQlc3YEsMneHNk5fLxeK6+jVSxlQKskIQVcLZdAQx76Zyw109g/TU61J2Zi+aodHDwxoSCLYHK65RemENZkfQVhd+R2StCF+jXccseWeLYj8+H0zkuleFB7Qwf+X34i9GCNBjlf3rAhjAHVyUZtffsXqL5caSAq2rxXqaYcKdZtU+84Q3wE2458OI4Pt0x5NXK9Ye3CbGset/GIP/v9eJr8iFHr+Pms/bUu8nB6vI67+PZdQicn2aQOCr9Gdj/7tZ+FpE1bJXXE7oFnxDPi9+kd7q1OXo3uuTfRbRMtHoCDWRcNH5hoNBy5Anj4IzVLKIeu+vtvymIVmdPCdGtJUWxybtEdqkCHpNFs6Q/LVhR9Zen3ix79mZ3qs6F6qcduXDFLy4wME6AQTZkMTSGpUJSFqQBT0AcK3jY2Q69RICbkB2SpeX8kF6xYqNXfMZHw0hEvdUgvygemPD/qyRwe3RgcupzqSGPjEqdrqXfo2dROZSMXmFxWZhVhMqUIH26eXXFxN6p5Mww43hKwAddgAwMR6QMTyZM1TYKs/5V+dBT8fT/HbXSdFOpPjzToB01POHfAPPruQ5He+PPYdiL9AcBEFrgYR9+AXT9vYkNJau7MdXnMVwFBj43g4042qMv2Y7DNeqGdgL3+hbGjSIO1/wa9Nqoamh7XCGTFBsTsT3iuaFdn7GAZZyyOT3ytaJLTO3iFGie9MvBtYPtzA==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1198fb9-3113-4083-b580-08db3b1038fa
X-MS-Exchange-CrossTenant-AuthSource: SA1PR10MB5867.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2023 04:41:46.5988
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eUnKTJIDZNod20I0pejtosg8WT/lE87JVE0LAEV7f3mDGbd5rwH4vDtikMwDsj/vEWuOv5DtryCgJGSvXIQXEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB6833
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-11_16,2023-04-11_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 mlxlogscore=744 spamscore=0 suspectscore=0 bulkscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304120040
X-Proofpoint-GUID: P-7zTbx8fTaUgghCh6mngW8aEPoT-BYS
X-Proofpoint-ORIG-GUID: P-7zTbx8fTaUgghCh6mngW8aEPoT-BYS
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 12, 2023 at 12:29:27 PM +0800, kernel test robot wrote:
> Hi,
>
> Thanks for your patch.
>
> FYI: kernel test robot notices the stable kernel rule is not satisfied.
>
> Rule: 'Cc: stable@vger.kernel.org' or 'commit <sha1> upstream.'

I have CCed stable@vger.kernel.org and also mentioned the upstream commit ID
in the commit message.

> Subject: [PATCH 5.4 09/17] xfs: simplify a check in xfs_ioctl_setattr_check_cowextsize
> Link: https://lore.kernel.org/stable/20230412042624.600511-10-chandan.babu%40oracle.com
>
> The check is based on https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html

-- 
chandan
