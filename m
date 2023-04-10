Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3ABB36DC312
	for <lists+stable@lfdr.de>; Mon, 10 Apr 2023 06:20:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229485AbjDJEUz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Apr 2023 00:20:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbjDJEUy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Apr 2023 00:20:54 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2062330E4;
        Sun,  9 Apr 2023 21:20:52 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33A0Nwo4010168;
        Mon, 10 Apr 2023 04:20:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=+mNn6ErEtoDo3qZJAwA/YwtYS1rBOH/ESud0ADgbyfs=;
 b=LPUyLdX3c/9SYn3wL22GmsJcXmUIYx22IB+b3uUOLJDfjATUnDjN9NYIJ7mUzHvbG2wC
 IOnpiqZZ1Jn6ndgsuR5Ik72NZ7fyaFfFxzIm0XZHe8WMIxI4xbOp7lW3VChhbC63ZaRH
 s2bouueMgQyi6QHaUCUp0lLfBTRn932Y6nwKNPNWW8p9AZ788EICQN2wg6Ratz6vdy97
 xtKtZGxu78r6917mMnUv6RvRQh2PDyB+P1Ht6v2c8Su77OaIg0Lxn8nMUnuzmyU1goxu
 XJ7EbbZ961w7jGDMAkYRogcdr4swQ4pqxlwpBOmaswWnRqRpWpkH3lO82aspBbkEC/cw Ug== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pu0b2sx3r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Apr 2023 04:20:49 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33A04IGw021480;
        Mon, 10 Apr 2023 04:20:48 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3puwdk9em4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Apr 2023 04:20:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m1IAh5vErYtv7iavT3kwhg2307Wr+v9RsdXCYRw3SKPN3TUFJEmyjFdC58WJVAgNra3vGqqXP3S9BPt3lJMup8yodi9FQbhRQxeqpJBMItEy7L2ONZTpJYV5ycBVpl0Fz1XQ6Wutv/ByGl6A4dQDpuVWaMKVoUEk3BsxnoYPOPbp9Tr/9HfwRfmaX8NJW/QtyLE8KJdyu8uRVs4v69QECYZSUNK1jzmrbudAjkk+LW9o2EyJCkqGvqIsrNB3iBFzlwQnL5YIHezuddAuRLhEsG+SATSGwSGXiwHY2FkXW5uxqMbFG4N6P90gPYFR6EDHMTCbvM9/RClDZGFH7I9k+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+mNn6ErEtoDo3qZJAwA/YwtYS1rBOH/ESud0ADgbyfs=;
 b=Orf0fFCCnUTZdgjlxAN00RwiK+/WaEejEOmF9UG1HHvxutgyxlZ5LYFe1tYYmcSWfJr9fK9rlAzQzfxLcpXC/aRivSOoscwUTt8bV0+Mt+SAYl+YzQfCaGvTMqBF9xe0Ln5zPRMsIUaxioTsmEJoG5GyGe36sEVhE13xdrT5KboDLIzqXuD0OY+IISiRmFCbzt+4Mur3py8vfjIyXR+wGHjlpqZvxaFGbmhPrc/Xr3CNzoTvurSJAEw+1lMXCISBiKTFBfdYsk0ybcrNZJXj4rUu8m66udxM8yaw5xv6ANiA8pqCSEWEZRap9zRA0t6MCGCAOcIlr3ah0xltyUkIVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+mNn6ErEtoDo3qZJAwA/YwtYS1rBOH/ESud0ADgbyfs=;
 b=qDFpvDrRUzKTYGiOSxSFEyP2u1AcOBaJl3Ok++BaOGViQgFD6ViTUSkJ2XTR3jYqsaC/QP3iMJPeue9yggX5YK89ru6ruWH8oZhxMCz2rz71A1jtmyZB8N6bWd+6126qDaee55X9SH/cOrqT68J3UY0UZuGnGZth7RkP6PBnFoY=
Received: from PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
 by MN6PR10MB7490.namprd10.prod.outlook.com (2603:10b6:208:47d::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.31; Mon, 10 Apr
 2023 04:20:46 +0000
Received: from PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::bc67:ac75:2c91:757e]) by PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::bc67:ac75:2c91:757e%6]) with mapi id 15.20.6277.038; Mon, 10 Apr 2023
 04:20:45 +0000
Message-ID: <e3d8c926-d4a4-cc3b-b845-211c40fe99a2@oracle.com>
Date:   Mon, 10 Apr 2023 12:20:36 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH pre-6.4] btrfs: dev-replace: error out if we have
 unrepaired metadata error during
To:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Cc:     stable@vger.kernel.org
References: <4360e4f01d47cca45930ea74b02c5d734a9cbfbd.1681093106.git.wqu@suse.com>
Content-Language: en-US
From:   Anand Jain <anand.jain@oracle.com>
In-Reply-To: <4360e4f01d47cca45930ea74b02c5d734a9cbfbd.1681093106.git.wqu@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR02CA0039.apcprd02.prod.outlook.com
 (2603:1096:4:196::9) To PH0PR10MB5706.namprd10.prod.outlook.com
 (2603:10b6:510:148::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5706:EE_|MN6PR10MB7490:EE_
X-MS-Office365-Filtering-Correlation-Id: efafe27f-b669-419a-8867-08db397af473
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8ltQcRa7INDST0/wTF0JZ+6AxWo1tY4w0a5E2FtXDGtQKeWZoekk3aQLzsiGmdhqZcZDioYDDlv17ci3DldugVJcN8YIo3Ugp5uon92J5sInVycsFMJO2It+PK48yxEKkDU9lX4R8gd9YmMdyvL5gIEidwMQiPO3/GPLf7OPHMxyk1PN0ekvinUcUNNJ5NYtHHGdhkzIQW2Kak+ZDjPDzeSYjCsHMCrKkQ5p5024WvPZIf+Vjd1uJUU4W7gmc3i3nHggi4YNGJTaLEHUd5djwHSWChJcJW3T1ij+ryXKxOTvCyhdeBv6Y5omhqhiCoqROKpMfd/5DYsVEmLJcxptvxytsv5fDCTgHhOYZlVcp4XU+83XHRw4DxWtLzSxaK0h9kKsHAt+vCvkP3d0zbQ8KZyWunwjl9/aGLxohl4XEme0bf99WKzgYCv3vUoDeZUoEjsc2rN38DZiVQ2RzsQ/pyopl+cNT+M7d0FDELOIIHYwp3dl3pYO+zvGRzOnrJuClhhY3uQxV3yTWTp1EsbehEGP/FJRz//s5mieQbFZfgUdJ0caujWqVwdpLS8Kvco21sbZtDhHVlEgCTgFoq3NfByGnD2+RfS3zoe22hu1oqrevxbgv2FfuIWyVN1wAwDga0W4CRMC66HyZ3m5sm3fKQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5706.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(376002)(396003)(39860400002)(366004)(136003)(451199021)(186003)(41300700001)(6506007)(6512007)(26005)(53546011)(66556008)(66476007)(31696002)(316002)(8676002)(66946007)(4326008)(86362001)(6666004)(5660300002)(478600001)(6486002)(83380400001)(38100700002)(36756003)(31686004)(2906002)(44832011)(2616005)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WFBhRUdFWDFNN0grZkZoV0htcFB5TGFXNDhVMHFadHhNbFVkRksrYmJPTUZT?=
 =?utf-8?B?Y3p5SHJlRGtOTnlQcGNVaWVWRW5tbEhPeFlzK2JkY05ERndoREtwNUxjSndL?=
 =?utf-8?B?WC9UaUYycGlmOGFpZnpES2txWDFFY1hpQzdGTkhaWmNqaHQ1VFdWM0pVU2hQ?=
 =?utf-8?B?NFcxQkEzSy90NGdJRktFY0Y4NFNROVllN3ljWlVzbFNhN05ranNONjBsRFVT?=
 =?utf-8?B?MFdwQ2E2cGFQdnpDWjVTNWZhQWNuRHdvbFZOelJDUWFIODdRUGovV0xOcmdk?=
 =?utf-8?B?MDRHNHlidnVPOEJpOU10RVE3L05pNHZRQ0s2Z2gwUmY3dkVNd2laNnhaSG1z?=
 =?utf-8?B?c0xxdkxQVWVZNTFkMTdjTURnTy9zektpUG1hZnVQTml6QWtqL0VQVmF6Y1p6?=
 =?utf-8?B?VmhYRVV3U2FKYjZkNWcxZnZka214NDh2Yy9ZRUxKYTUzSjJyQnFQdjIwWE9D?=
 =?utf-8?B?b1ZMRXgzWHRCQ0lDUm0zOWUrYXFVcDJpcVI4NmFsbVk5YmhpUzZPcEt1K3NU?=
 =?utf-8?B?MXF3OEtvWmxKeVBJYzFkTU8veXM4NWNWSHFNRG5JN0dla1I3YkpsdW1Wdld6?=
 =?utf-8?B?dk02dHVKTDQ3eEVxdjBnR1hnTjduRVZHbXp0enhvaWhvY0VySEF6TUwyWlpY?=
 =?utf-8?B?a0RJVDFocHlVcW85d2hLOER4bnBXMXFNTzJ0Q0FGbk8xa3JLekpzOWI5QzFB?=
 =?utf-8?B?aE9nZW01andIZUxZSTZwRmFSRGJyUXFJRnpLSTFrY25LVUo0UG5rQ0ROY0hL?=
 =?utf-8?B?QURxMjZTbG5CdzFzb1pzVlo5UWtFWHRzYTBQbDM4cklHZm84a1JQREM2VlJt?=
 =?utf-8?B?aTV6ZTdlODJWWlFkaDZwN1VuejVBVEdiVWwzQWZFNDVjSnlwcFVWZnZWTEpJ?=
 =?utf-8?B?aUNXREdQVnhNRmNTU1dDRkE2Vkl3YUZrZjI2VkZSSG1hdU85SWdIT3h0VHQ2?=
 =?utf-8?B?WVQvK3M5RFZJcWZ5MG9rQWczY3htNmllRVdsTDU5MTJPdGdBOVM3NUxkOUlV?=
 =?utf-8?B?SG5UUnRKK3lrTWFWYVRCSkRwRzhiaFBqOXRxWEx4WVJlSDRmVzFDMmdHNCto?=
 =?utf-8?B?SSt6ckVJVGlTK1VQUFdzQ2hMSWk1Zjh6VWxhcmRScWhzb0drTlpWMmw1Q2VX?=
 =?utf-8?B?ZjFtRjBBZ3pYNTVVVU5CL3hkS1FzRUJkL0N6RXIxNk0xdnhNaDlTMjlHRkFJ?=
 =?utf-8?B?THl3c2NmbVdyOUlnOXJHbUJvQ2h4YTlWUDNleGt5K1lEUVBUMFQ1RTRSa2hs?=
 =?utf-8?B?eTUxTzNYVERVK1J5N28zR0NNVkdWekVwdk1YeXJPNzJVOU03dmlwb0JOOWdF?=
 =?utf-8?B?YW01MGdLekYwQlRPTzRlQXVuR2s0WkRqb2drYWVhZnYzMmZIMGs0czdqZCsr?=
 =?utf-8?B?bDA0b21mMXB2U01DbUZCVkR0ZWtXSzFlOFFqc1NhaXRzU2NYK0lTT2JRaU5M?=
 =?utf-8?B?M1phZW15czVoeWZBWXJPK20zd0hBMDZ1TTZ5RXU2SzhmTFJRajRWNHBBWm96?=
 =?utf-8?B?c0tKOXJ6TnlSaGl2V2xUQjNqdTNkRC9PSTE4TjFRMG0zbnNsRXEyeW82ZHU4?=
 =?utf-8?B?a011cXRBTCtkVUZJZ3dveDh0ZkJhOHUyak5GeGUrRGp5NWhqdjRMd3pFd2dP?=
 =?utf-8?B?RlNSKzBDZnU1ckFveEFBdmc3M25VdmV2SFY5Znh2MmhUNnNjV2lpSkxrVk5i?=
 =?utf-8?B?MzNtUnkwRVlMZ2lISGNackErZHYxQWlsWmRzNHFScjdhYUV3RGYrbzdlQTVW?=
 =?utf-8?B?Qks2Z1pIbnhnM1ZBa1lZYkU4bjk1dGFFVTBmNkNpMS9XY3EvcmlxSGRpUWVX?=
 =?utf-8?B?bE5PaDBBKzFPN3JvNjFEMm5FQTBxN05KQVNWcVRQYmNtY0ZJSDV3bHRkYkN6?=
 =?utf-8?B?ZHdSdzdJNmpNaWtJOEFLT2s3enU2Y0tIcjJQR3U4RmVoenNxbTBlcklub1BK?=
 =?utf-8?B?UlYzU2VpdUtCVGorSkRvQnMwOFBtNTljMFkwcTU4dEM5Vzk1b0ppVzBOTVQ4?=
 =?utf-8?B?V1lnV0hEYUloUnBjVXgxL2VqZGMreUszaWY3MkZpeHB1cTV6Q3Y5VzRvclV5?=
 =?utf-8?B?anBoNCtXb3orZVQ3NG9tSWFub0dWYXU5TVQyMUFNT0RPK0JuV3FJZzFwaENZ?=
 =?utf-8?Q?48Qvp6aXi/YuQnoFpyOcHce5H?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 2P31maI1BG9A3dZMMHQ6bQvOvV5M0mN+mYaqEXe8s+Nye1y70EGFXsV7aLYauZI7dmu9/4EKoJT62/ack866Rr2qptWfNLOS8B3ZQv9VXCmsyxRRhMEhvA9wq68cVT7+EAtxwy1SobI+Dv/wKEtbobr3/XkQeOLuQ/3HKg1ppDYplSjDNd/Zvgz+B1sElErw/1k2PE6e9aCVx79x7oxMc+cJ7Nb7T73E5FYAqtZf5P1mXBu5QEHtAOljvRrgUJG3hhCnhdYGkzDeiqA7wLWx6vw9+HhwnXzjd0AvvHLOEfr0a5pV+i1rlt/Y4L2Qq7QWEbGWnbf4HNjqKNiVnrsSe18CLtrN65zSNhxS+AyCZ+U/iw1XHmlQQ3HBLlAZuNKdp0I+azbkTK4ueaIVn7pgXyS+KQIfHmqHbqikRaGW4e5eX+3IjEis1OIrfdJotBNC71MN8OBGhSCu1+V+CWgg2AS75FpbRMe7diToC4ci63Zt0hVHvOAe5W+f9tVwk86mjSlyKGMEUzHtmGrh6NxUh2sKeyrZMoWDGoIlpBurkLjGE6B7jITrdVr+Jee7WhSgybOMkxPssJvMnaYDNDXnzoaz5UFsQ8Jgs+m2mWt4oZsqdV8v37CjYxADwKZRtZeIve9ZSAVRS6FW8e91vmD+5opaIhHa32r/XXhbLeogL2NXpuBcp3QNLdrXYAM7PqiieM+4GPdeeEjz1dKDSd2adIQWtQIUPYgG5QllLuSw66sDpa3sVuOEsagEDa8N7TKqlKVesIF5IC8DtL3mtAj4lDfg4HlB8N8SHlp+zmOW0A8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: efafe27f-b669-419a-8867-08db397af473
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5706.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2023 04:20:45.6776
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XdqlStKc7rxggOrod0F0DsLLeqPgZRiB4TGVxKPgF/nkmv4R4lqzvFtUAR491UTZAXagvpOzxc2mTd8HfRCQqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR10MB7490
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-10_02,2023-04-06_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 spamscore=0 suspectscore=0 bulkscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304100035
X-Proofpoint-GUID: 36EkPxKnc5JxAmGLHPXYVhjB8LgqNgP4
X-Proofpoint-ORIG-GUID: 36EkPxKnc5JxAmGLHPXYVhjB8LgqNgP4
X-Spam-Status: No, score=-3.8 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/4/23 10:22, Qu Wenruo wrote:
> This is for pre-6.4 kernels, as scrub code goes through a huge rework.
> 
> [BUG]
> Even before the scrub rework, if we have some corrupted metadata failed
> to be repaired during replace, we still continue replace and let it
> finish just as there is nothing wrong:
> 
>   BTRFS info (device dm-4): dev_replace from /dev/mapper/test-scratch1 (devid 1) to /dev/mapper/test-scratch2 started
>   BTRFS warning (device dm-4): tree block 5578752 mirror 1 has bad csum, has 0x00000000 want 0xade80ca1
>   BTRFS warning (device dm-4): tree block 5578752 mirror 0 has bad csum, has 0x00000000 want 0xade80ca1
>   BTRFS warning (device dm-4): checksum error at logical 5578752 on dev /dev/mapper/test-scratch1, physical 5578752: metadata leaf (level 0) in tree 5
>   BTRFS warning (device dm-4): checksum error at logical 5578752 on dev /dev/mapper/test-scratch1, physical 5578752: metadata leaf (level 0) in tree 5
>   BTRFS error (device dm-4): bdev /dev/mapper/test-scratch1 errs: wr 0, rd 0, flush 0, corrupt 1, gen 0
>   BTRFS warning (device dm-4): tree block 5578752 mirror 1 has bad bytenr, has 0 want 5578752
>   BTRFS error (device dm-4): unable to fixup (regular) error at logical 5578752 on dev /dev/mapper/test-scratch1
>   BTRFS info (device dm-4): dev_replace from /dev/mapper/test-scratch1 (devid 1) to /dev/mapper/test-scratch2 finished
> 
> This can lead to unexpected problems for the result fs.
> 
> [CAUSE]
> Btrfs reuses scrub code path for dev-replace to iterate all dev extents.
> 
> But unlike scrub, dev-replace doesn't really bother to check the scrub
> progress, which records all the errors found during replace.
> 
> And even if we checks the progress, we can not really determine which
> errors are minor, which are critical just by the plain numbers.
> (remember we don't treat metadata/data checksum error differently).
> 
> This behavior is there from the very beginning.
> 
> [FIX]
> Instead of continue the replace, just error out if we hit an unrepaired
> metadata sector.
> 
> Now the dev-replace would be rejected with -EIO, to inform the user.
> Although it also means, the fs has some metadata error which can not be
> repaired, the user would be super upset anyway.

IMO, the original design is fair as it does not capture scrub errors
during the replace. Because the purpose of the scrub is different from
the replace from the user POV.
However, after the replace, if scrubbed it will still capture any
errors? No?

Thanks, Anand


> 
> The new dmesg would look like this:
> 
>   BTRFS info (device dm-4): dev_replace from /dev/mapper/test-scratch1 (devid 1) to /dev/mapper/test-scratch2 started
>   BTRFS warning (device dm-4): tree block 5578752 mirror 1 has bad csum, has 0x00000000 want 0xade80ca1
>   BTRFS warning (device dm-4): tree block 5578752 mirror 1 has bad csum, has 0x00000000 want 0xade80ca1
>   BTRFS error (device dm-4): unable to fixup (regular) error at logical 5570560 on dev /dev/mapper/test-scratch1 physical 5570560
>   BTRFS warning (device dm-4): header error at logical 5570560 on dev /dev/mapper/test-scratch1, physical 5570560: metadata leaf (level 0) in tree 5
>   BTRFS warning (device dm-4): header error at logical 5570560 on dev /dev/mapper/test-scratch1, physical 5570560: metadata leaf (level 0) in tree 5
>   BTRFS error (device dm-4): stripe 5570560 has unrepaired metadata sector at 5578752
>   BTRFS error (device dm-4): btrfs_scrub_dev(/dev/mapper/test-scratch1, 1, /dev/mapper/test-scratch2) failed -5
> 
> CC: stable@vger.kernel.org
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
> I'm not sure how should we merge this patch.
> 
> The misc-next is already merging the new scrub code, but the problem is
> there for all old kernels thus we need such fixes.
> 
> Maybe we can merge this fix before the scrub rework, then the rework,
> and finally the better fix using reworked interface?
> ---
>   fs/btrfs/scrub.c | 9 +++++++++
>   1 file changed, 9 insertions(+)
> 
> diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
> index ef4046a2572c..71f64b9bcd9f 100644
> --- a/fs/btrfs/scrub.c
> +++ b/fs/btrfs/scrub.c
> @@ -195,6 +195,7 @@ struct scrub_ctx {
>   	struct mutex            wr_lock;
>   	struct btrfs_device     *wr_tgtdev;
>   	bool                    flush_all_writes;
> +	bool			has_meta_failed;
>   
>   	/*
>   	 * statistics
> @@ -1380,6 +1381,8 @@ static int scrub_handle_errored_block(struct scrub_block *sblock_to_check)
>   		btrfs_err_rl_in_rcu(fs_info,
>   			"unable to fixup (regular) error at logical %llu on dev %s",
>   			logical, btrfs_dev_name(dev));
> +		if (is_metadata)
> +			sctx->has_meta_failed = true;
>   	}
>   
>   out:
> @@ -3838,6 +3841,12 @@ static noinline_for_stack int scrub_stripe(struct scrub_ctx *sctx,
>   
>   	blk_finish_plug(&plug);
>   
> +	/*
> +	 * If we have metadata unable to be repaired, we should error
> +	 * out the dev-replace.
> +	 */
> +	if (sctx->is_dev_replace && sctx->has_meta_failed && ret >= 0)
> +		ret = -EIO;
>   	if (sctx->is_dev_replace && ret >= 0) {
>   		int ret2;
>   

