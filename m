Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74C5244A5BB
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 05:16:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240095AbhKIETK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 23:19:10 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:30474 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239757AbhKIETJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Nov 2021 23:19:09 -0500
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A943RFO013368;
        Tue, 9 Nov 2021 04:16:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=FqGeH/AJTXOYg9IhFmrBWHp2Y4ej4gQsbg3wEQpYnrA=;
 b=dbsCXGuerkpHU/hiEkfUYbSnjCaY23ELiSaK4D5Fs+sxj1W0gRE5W5TvPKbFSsHU3IAg
 Plm/ovV/F1lgLEdzngOyOXT5hiJGeMqoR2GvCF0Y+4N1DJ5qrH7oKzbpiPG08/X02/z/
 okGRjgLzdMVE0j/s29wToYJrH0QQvrjTCIlSsHLUVDek2KspWYGmn16EJbcM/tw0yRyT
 qMvOOnIfbFxf0szSeNOcpNtSu4U+yBK+aeCPFZnFfNJobAnIHAEjjDNQpE+f4EmUInrm
 zrsBj76H9p+UzpCHga7VE68x+KDNZFKaE6npbFy7ig15Jsq7YRetwPDYmFmz/kahKLAJ qg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3c6st8rs11-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Nov 2021 04:16:20 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1A94BLQn190497;
        Tue, 9 Nov 2021 04:16:19 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176])
        by userp3030.oracle.com with ESMTP id 3c5etv22ws-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Nov 2021 04:16:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lVQW1I2KoX22j5hryQYfQFr3+DJENuPXVeLzPfyBPqTMmg9NuQFpoxm0WXdpFP/D/YRTckVJrpEoqem2FJmhU8krN1K5B8NmsrQWyuHllFekIf8SvldL97tSDZgo4CDjjeCDQTQ84pR3ilE+as881aoheewRsjXXY4jPatMcAX4PBedVp7NUYeoUlrU4Mbl9laZReZOdxKM3fZMcKxji/Mza0h9cQXSsxdT1N1IFC2N4eNFYscdqKJtrZt6fRstojz1e6FNKUM4U7Hm+zGGbsedejvuhmDUkXQMNfUNs9JJ5GDuNeQt8T36b0pBasICLyfYoPb5G8sIIJne8kF4mZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FqGeH/AJTXOYg9IhFmrBWHp2Y4ej4gQsbg3wEQpYnrA=;
 b=nZWCAY+RSq0kZvx7RiZcaSd4cYvj2GNMHx8yanGOp55OU+es9JxLbTd/TvpmVv5bmtg568MENtcBsfExMK1TFtbHlOhxGQj238Y0yEz87KIrSlnw5/b+84wfER7NaPZWKF8pYziV8jHM6Aq/UETeuUUZdt+ALiLY98Es61BVjQSlp6ZBc62zQXiqIZj+XbgJpke3RRiQo8f+B9RAHC53iSAEJKn80TK/XSMxFNKlmnREPYX3g05fIqKspoc2AOtTYELWBjaV20YvlfYwZCo0KzMrC6sc5ylgZesleYOkdYmvTZIZl2w8AMOPzRW6glezir4mdmITVAje+63orfW8Ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FqGeH/AJTXOYg9IhFmrBWHp2Y4ej4gQsbg3wEQpYnrA=;
 b=RXbdI/TIQu99KPqH7yyV2jPY8TcU346lkE8pEIOYc2ZC48elniVHDidRyMvppQHOO/M2R5V+Vasu3xf6ts03X/t/aDl+ZLeFB07+HH6kQzMCKt8z4egWMJxm/UiqTIqYVAdti4KIw4z6GTzQg2CK9d/rn6j8ANV5JkZVRWNzEiM=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4503.namprd10.prod.outlook.com (2603:10b6:510:3a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11; Tue, 9 Nov
 2021 04:16:12 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349%8]) with mapi id 15.20.4669.016; Tue, 9 Nov 2021
 04:16:12 +0000
To:     "Ewan D. Milne" <emilne@redhat.com>
Cc:     linux-scsi@vger.kernel.org, stable@vger.kernel.org,
        njavali@marvell.com, aeasi@marvell.com
Subject: Re: [PATCH] scsi: qla2xxx: fix mailbox direction flags in
 qla2xxx_get_adapter_id()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1sfw6j75r.fsf@ca-mkp.ca.oracle.com>
References: <20211108183012.13895-1-emilne@redhat.com>
Date:   Mon, 08 Nov 2021 23:16:10 -0500
In-Reply-To: <20211108183012.13895-1-emilne@redhat.com> (Ewan D. Milne's
        message of "Mon, 8 Nov 2021 13:30:12 -0500")
Content-Type: text/plain
X-ClientProxiedBy: SN7PR04CA0003.namprd04.prod.outlook.com
 (2603:10b6:806:f2::8) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.57) by SN7PR04CA0003.namprd04.prod.outlook.com (2603:10b6:806:f2::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11 via Frontend Transport; Tue, 9 Nov 2021 04:16:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f616d85f-0bd7-498b-67af-08d9a337aa2f
X-MS-TrafficTypeDiagnostic: PH0PR10MB4503:
X-Microsoft-Antispam-PRVS: <PH0PR10MB45038784C33C63B2092FE9A98E929@PH0PR10MB4503.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: p7VwNasQZ+gCAOCU+NmWf//VAh1ONv/roO2tVX3sPXx4Pc1EETLwoxtPw92GaQ+Q8DqqWAHh90oigPBy7VBjUvGrf4jgLu8etMT5stwIKtn6fW0lYpN43fZX5OkBB+iMYXXElai9qH2PWiEJn0vumC6sHHBet+6erR+JxDMx7gumZvoFMh5j/CxulbFV/Ig6x9bkW/pblBvjNIo3droguZXa0+YZzw1o4Id/9bvBGySLUS3aEtXHux7G5zvPnW1DB/a0P2s/xvkAWyTq0m3SRc/w79cvAbDEJNho5RzDy8jAsLkvPL5VxBsAR0OZsEDA+BFJ2AD8bFKdO+Cpj/ryrB34+33JwiaEXqGPbCyKctcAY6HBTPmbMWak7mpkCBjJZhWBEzxbpdTS9sCVbILnCD52ExO+EmudcRKdhgUqDVt2bGOqHJ4+GXpsKJCQ2wYi6Wz6ZvVQuthB4qbG8T8eKgLFmuDpVOxZHbhWukLvKArA5WpT5+S6okBN5oSnvSoSTJL1KUOmzgghcpRTPReFqmb6xPrMd9+G4BUh86h576IvUfJR4MhQTAEulZXtonT1yif1jpqpEYq8gHJBTaEGzgz5a6g96neIdiCafVc744ZklPH/1qI02xExhbLL5AuVHPOn0hlIKEmQYHxKqbl5qoOLWjkRHWFLsMbTtkokVjRripH4kllBjhG7Y2wcqIIrHDXNF19QXDwX2cunExIWaw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(956004)(316002)(2906002)(66946007)(6916009)(66556008)(66476007)(508600001)(52116002)(38350700002)(55016002)(5660300002)(38100700002)(86362001)(186003)(36916002)(558084003)(7696005)(4326008)(8676002)(26005)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6iFnyIu8jaLBsU5kb5zXJcTdbFlsX/hQidu24BXap3ZHxBH3APtDWQjVZ+2T?=
 =?us-ascii?Q?pJDQA5a3XK29zRZjzJYyOqQiLkl8A7SdMX7mBdFtz4vIOxVFGEcKHVcUabSR?=
 =?us-ascii?Q?qQBpFDS/zoVzeSubGPDudibrG+u/7MC1iOkiOi/THWwEzM6zIOe3bMBOMkBd?=
 =?us-ascii?Q?GlpYiXDQU2n4Zb2fpMmHOFz47jweDbVU97BMDLfAX3PApHh7JbRPiMW0LHCH?=
 =?us-ascii?Q?M694kf4xye1MX6D+jEkyL6v2fGnGOaIOYHWOUQ72XiBXu0JL3f+JslJhSLdS?=
 =?us-ascii?Q?A33y5w9UPRxEWrwBDQMEGKEcwQxN/xO+lSoV0mpbNEB0pCVJzeWdNkvA1jAu?=
 =?us-ascii?Q?g1EBn4x4852hQYD/gG/31loYUAzm6/yJJysnIo4j4gmi36Xp8byEXpTXkP6A?=
 =?us-ascii?Q?REKpuAMi4/yTH4qwOk2Iaij4/yPUs8bS0Fzbjy1cTPQKHTJit3CSDIvpj1UL?=
 =?us-ascii?Q?P4QW3nnlpUpb/Xc6ABTjDTnl90CPC1D4KimmVP1mBNhiJPmARetm4z3QZ2j2?=
 =?us-ascii?Q?EcpSr447sl8/MV44Y5Ze3REhjsVVncRgq+WWTBLcHA/AKFneGwMID5e7liGL?=
 =?us-ascii?Q?4DH3lGTcW39Qfe3iP/bCvvXr0n2THj6BMSVPvSyWK4f2koQIaOnFqByz9HEz?=
 =?us-ascii?Q?4BXhst4KcpwgwU64N6cGRl0IBrmPWT2JGTmHVPpOjYjM12OM4OuwYtoDM24L?=
 =?us-ascii?Q?DDY+M3MPyvysIE9BEKjIkvsbBfQzs2bo0x1Yhslp0e3m9Fsg/fFVUQcEdNIk?=
 =?us-ascii?Q?ak+TMt7DtCdbJvooaH0eFBW4gTru6PvoNDFqSM9OKrjRLVOhRxaUWtuvD9Fe?=
 =?us-ascii?Q?xBfn0kyTm83YfcKIQasc/10E862F8rfULqFg3/VdpxQgl1poiECkhEm1fUou?=
 =?us-ascii?Q?t+CLddrgW/w7wQfoOwoLyr4ZlbFtwRFKveTNKktPU7cKFUr+l7td7SmWJzRY?=
 =?us-ascii?Q?vLtV+WT9xsFyhb+MD9ss0Tu3et7SOpWGWbKCS/RnUOqEHkBEDl+qCJV/nDu1?=
 =?us-ascii?Q?h/D9QeFxSbSe7TFWDZe6gQN4475a3IKIiPz0U3n4jXkMl9yzOaTz3LxwwJr8?=
 =?us-ascii?Q?bSiT20cMv1D56SPbQHdK0UbK5bUCg6LArrKYacZJfDrdWoZHJJkmnTeTmHs1?=
 =?us-ascii?Q?b/NT6ZNkhUXidijeZTJHC0pzIZqdXqXCGwTcLJhoWUI8bKLw7itHqTZEDNwo?=
 =?us-ascii?Q?jEh1JKVgMdItk2ShofATpc+cJEebxJ57t2LQSdZJJyjPJTrJWA/QlH4QfcgI?=
 =?us-ascii?Q?C700LIDqjaEi57UehCeTc8UR9tPJpueWYZPQP68X4vJrZ6Rwqv29xDjkcHmJ?=
 =?us-ascii?Q?8XDbK1ivi46Lg2L23RxDlUebe4aAjgUVzuCq43/CJA3AM80Oyjt20iggITJA?=
 =?us-ascii?Q?cQYPX9O1j6Pfp9khzV7kMp+ib/UCxTeCqk3Dyrz9ORALlN5v8tUMioVP505J?=
 =?us-ascii?Q?YEYB/zk+ywGsdYQJ1lPJPWdLcdMwrbgfjXf+XNA9yyA26wstqdTYfbkW//LC?=
 =?us-ascii?Q?W2UjZyOV7lueKXPR+X5FcF/uoKIzAoSJ7+r+bIbFWxT75fm4+MBurVei6fRx?=
 =?us-ascii?Q?wiNKaH30z0AIEZnVDpQ/LHAENl4Q4+kDjZynDskUQkFjrjrTpAvVMwTR2/Cg?=
 =?us-ascii?Q?fgOxs2CXdgXtzuJg6A31K2AKjW8l/doTRfF2KozT5l/J2KIAndwHCVcK1IAF?=
 =?us-ascii?Q?0FJQDg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f616d85f-0bd7-498b-67af-08d9a337aa2f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2021 04:16:12.4791
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3vE09ThUk59I41vZQZHg30eqvMQ7etTJIHu7WWUxl6lwU/2/Zqieje+uU1R05B+ejcz6Y5CH7d8AHkquH4GbcxmK57Iu78JusstZmU4CAIk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4503
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10162 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0
 mlxlogscore=617 malwarescore=0 phishscore=0 mlxscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111090021
X-Proofpoint-ORIG-GUID: vbFcBBct2YpydWgt0eXjUz-HBgzR6dQh
X-Proofpoint-GUID: vbFcBBct2YpydWgt0eXjUz-HBgzR6dQh
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Ewan,

> The SCM changes set the flags in mcp->out_mb instead of mcp->in_mb so
> the data was not actually being read into the mcp->mb[] array from the
> adapter.

Applied to 5.16/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
