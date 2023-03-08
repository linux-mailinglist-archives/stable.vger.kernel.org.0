Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C76A6B11C4
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 20:07:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230173AbjCHTHu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Mar 2023 14:07:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230248AbjCHTHU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Mar 2023 14:07:20 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1C77BE5F9
        for <stable@vger.kernel.org>; Wed,  8 Mar 2023 11:06:37 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 328HiZBU010415;
        Wed, 8 Mar 2023 19:05:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=HVOSOXcsT3ADt22q+dOOQ+RgcHXs/9NAJVthWFMqVBg=;
 b=N4rsiU4RCsOhoxotIX/hyQZ69HvZo11dELj7mVtISQqHeP0ib7FScj5uX3OCB9KXtaGR
 alqK8/8zJHJgbRMpuwDjjnMPlz/hP558pS3TJlzdMqjvglqW5JMY8F4QNr5H/6AwMePg
 YEmT3OmCrklRBUL+RUuiWpQH+Dje6CZzIEymjGqmvn0hzo+T71DM4VazoDpTwk/6fgGp
 6uhho2TjJwVumGmeU9wvUXHoc8u5vq/n2zSQwq+y4VdTxLNaLbhE+R75mrhZa25Lndw+
 hNXYwTy43OUN4nEbIkIhtb2qefDJpbnUAS7vj4v0HQ4oP3Gtc3kJ2keSw9iaP3pLs08Q Vg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p416wrxsu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Mar 2023 19:05:06 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 328J2OWa015615;
        Wed, 8 Mar 2023 19:05:05 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3p6femprdx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Mar 2023 19:05:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AyNMcgX4AD9P9OgD9Nxs0rkIJQp3tTfEoz39+2YKk0tkbZIA1TGFqoIJV4sd3jBMM7W6fWkGJ6oKqHnArUlCzF4KYPl7/v/q0gAOeKxN2U/BK+Uz5aMjHSOLxeGztxpHc2amKNMnCesHom09RexxT7rs82eHPrNO/OGMDRs/sKrHR2+CS4atNdmAZcF51Clc+3AdrPYiRZUKG4kVuIPKfE/HGTKL26yzLO5z5eKedVfQUyC8VPTCmYGll82z24Ys5aJuIkfHmlH+PlKXbFFBmOVmj3wdDp9Y+HUa19kwRAOr1iUb39BmVEjzD9l131Qq+dDeQVo7sjzCdBNe3nEdXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HVOSOXcsT3ADt22q+dOOQ+RgcHXs/9NAJVthWFMqVBg=;
 b=MTsd6I8n5qCecpQM20X3EkwbQM5TMOxET/g7tQaVQxbXx8qK2J7ZRCGeEuQMPEpT/KGxKCFWaXKlH1N4EKznB2x+ChZbzOGq76lUMX37HBQtDMCKfdCtJ8DuPX6CjrnMJYMlHJoyHhwhzas+i/nkzu90VmVDSSwErce3JtbRQ1yvPF+//dFB5TjDUhOrYc0Qpt26kZBIE/br5PA+ncRD8ZyNY5Q2wo9mrXxjwQ0XDv5FIld9U0iCC6MRPNR83UCme4lfqF7kOIjWJZDMz54maYPS6xFTJYxzlw/qK28bpmap5PEryunODsCPxZJAqySjAoeEyOFLTUaW33H6t+ar/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HVOSOXcsT3ADt22q+dOOQ+RgcHXs/9NAJVthWFMqVBg=;
 b=JzJyMi5jntRDZKIwTHmxYbQCpmEuc5e9klkJ7gm1ffOdiIZRkWuaGkemvPeqy9JrQ2HzTOiD0Kq8Jvwg9boAcNCafUIx4slNNTr4JidG3PhrVpg1+PQ2auFBvLQd4oV+N+37H9QQBRtgPrVYTiNQ4/JvtBD0P3/0bFDp2tcUIxg=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by MN2PR10MB4189.namprd10.prod.outlook.com (2603:10b6:208:1de::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.29; Wed, 8 Mar
 2023 19:05:03 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::8ef9:5939:13aa:d6a2]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::8ef9:5939:13aa:d6a2%8]) with mapi id 15.20.6156.029; Wed, 8 Mar 2023
 19:05:03 +0000
To:     Salvatore Bonaccorso <carnil@debian.org>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Martin Wilck <mwilck@suse.com>,
        Christoph Hellwig <hch@infradead.org>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Linux regression tracking (Thorsten Leemhuis)" 
        <regressions@leemhuis.info>
Subject: Re: Please apply commit 06e472acf964 ("scsi: mpt3sas: Remove usage
 of dma_get_required_mask() API") to stable series
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1wn3rgj7a.fsf@ca-mkp.ca.oracle.com>
References: <ZAMUx8rG8xukulTu@eldamar.lan>
        <yq1356hnzd2.fsf@ca-mkp.ca.oracle.com> <ZAi4k/09acWV0wRZ@eldamar.lan>
Date:   Wed, 08 Mar 2023 14:05:01 -0500
In-Reply-To: <ZAi4k/09acWV0wRZ@eldamar.lan> (Salvatore Bonaccorso's message of
        "Wed, 8 Mar 2023 17:32:19 +0100")
Content-Type: text/plain
X-ClientProxiedBy: BL0PR05CA0008.namprd05.prod.outlook.com
 (2603:10b6:208:91::18) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|MN2PR10MB4189:EE_
X-MS-Office365-Filtering-Correlation-Id: 032eeae4-4bae-4e7b-a1ef-08db200805b3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vs7VQffbxb9iVJx/LHSXuz/nxDcYR3c89ExFBKaxmCdvTizxpfRuTVjG4t8Wzle2hdvzlH8rOOdcqtJ0QcSI7Wp7mh3LVcRxBhO+hAJMVY8X5JIOmu8EFAImQguHm5K9sHy+bEzRywUBQinbPV1N05Q7ZBnZFDA26qhsgdKU9CIijOajCptaqfo9qKoIcrbpNSo+vZBLd7mFYb9sm/kDTzQaonO4SwtVCjTWVxGzhlzumlr/eysupGeEllp8zQmBaJxUGDVp2+C07Y6UTYyIHT5V/jP1WJC4VEao188OPI/nmsjflhYZ9dZhaQfdEOQEZO17mJ0AAOyBtzk84e8nwiOxUMTftTgfKos62pyhvcG4q7ZXDMZUrj4Q8lz99OSSTcDxlNX9l8mCzkfPW/HIGGXEFQLt+WqAlJZN6BGyja1VPfyw7KhfInHK/95aY1DzbKoUNHRXbn4iNvpW68716m5W6/EfzZe4LHGeUsKkCxUZORqpE8r5FvEN8ahG+ON+hoyXm/rgXT0LavDAqDc1ZaLDmoXXF3x8Fkpi/50PUSHCQgzof93NvP/tn4+lwey3GwareDAQ0oe361NiDURtYA8a0ItJ0sVinyaoaIvjZS1IEg09J9JQGwaM9Ha/4RmAXPs0wqOjBLv9WUKhMwmjvjSjJK3Ad11s9CG/NZUi6xrsUAE0YcPdYSVVb/rDpadH
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(39860400002)(396003)(376002)(346002)(136003)(451199018)(83380400001)(2906002)(66946007)(66556008)(8676002)(4326008)(4744005)(66476007)(6916009)(5660300002)(26005)(186003)(41300700001)(38100700002)(8936002)(6506007)(54906003)(36916002)(6486002)(86362001)(478600001)(6512007)(316002)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?L5AB9ONwFJAMkbCUMalEvRi+7vWfKyJA3YSG6NNsilpfyAndHuDvA3ZcG300?=
 =?us-ascii?Q?43B3SdCAjVpBBL1C+AD+911QWFbO/U1v6XetSJugBIiq2bJ4Zirq7G84Pjat?=
 =?us-ascii?Q?bxPM+x4hSixcCrINUgird3zzoCPYIl4SOZxRrbvjAruXXp+hKNLTwk6NyfD6?=
 =?us-ascii?Q?qSNJ/gdEqQFbCSi8GnL4/iZyruzQmH+qllmutZRGJ0SmzUQaUgXlyq4mF7va?=
 =?us-ascii?Q?+5Cnr6gn4+AJKnBNH5bFKx2n4gIYzU9r4+RfFYVCAoiCXSBebUUo1Rvjp+eJ?=
 =?us-ascii?Q?xAkd7J8XYrvXtkKJvnYlimDRf2IzhCkpl6s6ZaY4meU7MRdJXUXsQbZr16IM?=
 =?us-ascii?Q?KF5Q1Vt/HSsnijyP08b84f7L2NjHwu3pHWxiLXadvOONGG3EAM34TarCc3WO?=
 =?us-ascii?Q?pS7wjlXkfE1Q55uWfNbsFdC1tK8LWzeAzUW8Y5IznVqExj+xBq/ajoyrhD0F?=
 =?us-ascii?Q?W2ty95CjMErZfBu56OxoNN2SFEnTvPHxkjuUb0G2+VZp/+HZeoIIHhlGnUGB?=
 =?us-ascii?Q?hY6vDbg73VRrzKA903PfNdhoReUfWMO3jkxhqHAVXUqMK+JR/nsiK9464d1C?=
 =?us-ascii?Q?GISqh1VsDlsF6Zj1TuO1s9/wlocHUabYFG+xM+AswZ5GGwqsph3Tz3h0mAm0?=
 =?us-ascii?Q?DM/nk8pi/z/TRffAkucyG30/O+8LwjSvYB/GwGq7i4mTjLGFBSuS3z4fz+kc?=
 =?us-ascii?Q?z40/OqHnOinaqkW2UqWQYtNOzUJXBbgNs0n5M5kFhS/cMUuHEbhCUgrl90Mc?=
 =?us-ascii?Q?2wvOdFDjhJSzf6znyYYwKLltGI90nOPPM2ftZsKj3N7Y064QGIfbdrIyHW60?=
 =?us-ascii?Q?7eRnm+ijS5NtrDAs7R+Co0ykqFy5Ij5EYeMy4ymbuE0zQmW6f9BwTvaRwMFQ?=
 =?us-ascii?Q?XUOCmXFE7kwcTHNfmKEj8cxVzaWA6DclDbm+uzIWCZk0nNVKBQfieT5XRywv?=
 =?us-ascii?Q?eXo/ho4RWMKEaxe91FDzjzNLMT2kB9X9PkOZhHm7/s0BD5QLmAek1ffXqMjF?=
 =?us-ascii?Q?M4oAkWJztr+w2PrM1M2+IXW6BvxkjkYJFamJA+oRL4UhVF4kLmF0y3NR4v25?=
 =?us-ascii?Q?n218TUaQXkmX2DLzP9WRdx6VbIQotdxSVNJirYUUPPcLnU5pTCpz5Eoobaga?=
 =?us-ascii?Q?ljNFpG+E7bEu/6ZV6RlaqXy2gmsngEI+2gWz4GRxFtQRJCnnzhDaxmEHTIYI?=
 =?us-ascii?Q?tUk0XVXtqdizoGYfyOD70uIZtHLJhQY+zJrMuX4ali4qr6iYbIa+FGBlCSuq?=
 =?us-ascii?Q?zyiig/L1wK8BBLyGEYMSKX39Zfti3J4w0+CBDu/qfm+aRSegsIR2z9CEObnM?=
 =?us-ascii?Q?R2OpQ+wDshCCVtPIPokPZaeeiixAnB6GzqIpLOjb06rEc4CHWHx4nxfxFpVk?=
 =?us-ascii?Q?U5CyqIZMGXhuX4V0mOzmbu+EbJ29zoXud4At18BJzIkr0DJQiKpqHZ8IMguC?=
 =?us-ascii?Q?vuTElLfAwE7B489jJpMEOioKxVizBkfM6myyAL6RLHMZGiXUZQCJY0tss/DQ?=
 =?us-ascii?Q?CaDPm1SDZbSUVswoCLyqfKArbqMAef4pP07ZNORHtljOym+7VnbIfcs9bn70?=
 =?us-ascii?Q?QwaxX+TGLzwDM1QUxHMEYIDrH9jnVNorEqItdzJ37V2DR/kYpmOGlFVK0lLm?=
 =?us-ascii?Q?sw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?/BfQznSesU4hbHg9B5RzXaeEDmBDnBvbv0B7TEloHsSFBsH1Sv97iUNe4U46?=
 =?us-ascii?Q?e/N7eW0PgF23huIpYZOfW8AI4EXhkviGSLeXXic6FmRKQJhwq5IO6GotHKOf?=
 =?us-ascii?Q?5KGIU/vsr0dw+SlCYpzCVFWLrAfAWMgLxx17OOzcIylF+aiGSsVjmwrNdApE?=
 =?us-ascii?Q?gQ2PCtuRteeOLzBHUi2hcLc7m3telJQNXoG50+n41YJokcDTOcNvX7w7qvJe?=
 =?us-ascii?Q?W20AxAtMpEFdPVOgjAUUEEuF2VS3ldI/82N2BlH6+Ll76d6UTCAMkrVJn0Lh?=
 =?us-ascii?Q?YXt/gAnD+T+ChCSKOab88ENcx2TRkCbh9LpZ+OigXqUvFXuF/4K+ebao71zK?=
 =?us-ascii?Q?ndWIevnYU//TN3JVZoh3XSxcbJ7AX5F97aD+Mrw1A0m/S4ScVLT9ZwHS1tus?=
 =?us-ascii?Q?tsMQpdwOF1LHk0CULPiX5MLfQbfWWKDibk2CL5Xb8aO3748tF3+qS9cKb/93?=
 =?us-ascii?Q?osiRiiPYAiYBuGaG8r7URoaTDwUV9tpNiiHSsGpCBmhUhlnV9IQxHqhpLL6m?=
 =?us-ascii?Q?1YC1IFifL3gNW5uCQHpo1D4qfLUrHR18PrntoVeqSU8QxycrpdrZfhtzbjIa?=
 =?us-ascii?Q?dtneHI2Rz2jQSEQtDqbIp/59WZu2opb1SS92wkaldQHyboJRGKhD15M5cSch?=
 =?us-ascii?Q?ZkEu5mNWDRAqElK4+O2KR8WOfGlg9A0UPL5dI0opkmJgYDElw6P25DNYPFDk?=
 =?us-ascii?Q?0jCDfrOjkof96SDPHWyOlouiez7ohvI9UwkvvadNqM6r5/OrJDnXZbZmEAHw?=
 =?us-ascii?Q?n0564b2TlwCkg9VzYC3SMvqZSBbzPJ/mLr6SL1xku3BFO8OYpxssog/+RrEl?=
 =?us-ascii?Q?8Gla4zAy+pd5KbeZFYkYuriWlBqZ1fTJLrPHyzmZEiflEJQd0GsPKm1oKgqz?=
 =?us-ascii?Q?aNpqU74a9siDpb4d9gS70LIvH7MvvPhnxoaN8Ja0T1jo99hSjeOLJdoM/jvg?=
 =?us-ascii?Q?V34xX6Oy9WWjPbu5pSSnEdMqkzS9PWDjEFqT3Ie/okiWYkiQDZlpt2zDp/TN?=
 =?us-ascii?Q?P2aj?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 032eeae4-4bae-4e7b-a1ef-08db200805b3
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2023 19:05:03.1480
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ix9AGemq7ttZk9WAhDEA8QR7zLkh/C9ImEHHYt2f+iYemMTjOy7T6WdWZwYGrR2HMeuRntN+ktjDeWWuJhrVirO2/YK5ZSP+3v/lWCM+sE4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4189
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-08_12,2023-03-08_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 bulkscore=0
 mlxlogscore=977 suspectscore=0 malwarescore=0 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303080163
X-Proofpoint-GUID: wvXW_3uwn8qNu6DPeMDO2yfBk6vz5NtS
X-Proofpoint-ORIG-GUID: wvXW_3uwn8qNu6DPeMDO2yfBk6vz5NtS
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Salvatore,

> So I believe the right thing would be to revert first in the stable
> series where it was applied (5.10.y, 5.15.y) the commit e0e0747de0ea
> ("scsi: mpt3sas: Fix return value check of dma_get_required_mask()")
> and then on top of this revert apply the patches:
>
> 9df650963bf6 ("scsi: mpt3sas: Don't change DMA mask while reallocating pools")
> 1a2dcbdde82e ("scsi: mpt3sas: re-do lost mpt3sas DMA mask fix")
> 06e472acf964 ("scsi: mpt3sas: Remove usage of dma_get_required_mask() API")
>
> Attached mbox file implements this.
>
> Does that looks now good for resolving the regression?

Yes, that's one way to resolve it.

At a quick glance your mbox looks fine. Best way to validate would be to
compare the resulting _base_config_dma_addressing() function between
your tree and upstream. I don't believe we have had additional changes
here so there should be no delta.

-- 
Martin K. Petersen	Oracle Linux Engineering
