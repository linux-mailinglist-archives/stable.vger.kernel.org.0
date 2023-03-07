Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFEF56AF715
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 22:00:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbjCGVAa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 16:00:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbjCGVA2 (ORCPT
        <rfc822;Stable@vger.kernel.org>); Tue, 7 Mar 2023 16:00:28 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 384E69B995;
        Tue,  7 Mar 2023 13:00:27 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 327JuDMX015840;
        Tue, 7 Mar 2023 21:00:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=y4TIKLHZySqO98qYzQyHoHZGKwl/KxJszkQRlg172q8=;
 b=hMz0WmOGtu9wUaRPWmUxz4Hf4pH6HGzALLZUi0jRZvNQ/d+3G9SCNIgoU7M2gjWp9+/h
 Vqa+jlVCqWSn6JNaFfSM16oLOAVW3bqQ7uvd1ukkEtJBci4a4xrI0/vvFWDA7zRQ+qoW
 gHwbtGVSXf7wzjrDy11LnyyOhFHsFcZAyhQoxMecu6tq7NGss75joi7GE8MFta97sB6U
 6axKIrz7rcg3lsO0QgYEF8jyxe6aQkcHx7bEo6IuCYCOq6DmzVVd8ppmtkVW5cG7uMx5
 OumuvoYAAdmN3Kn63GRgnwtuaDpT/Ns9ZonnwPEArOppjW+XccHz9M5w5iKU+VYkRbqY JQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p418xxpk4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Mar 2023 21:00:08 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 327KV09U011126;
        Tue, 7 Mar 2023 21:00:06 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3p4u2jbnpj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Mar 2023 21:00:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e1PG3yA2lLuATzWlFDBQY44NplkTuDJKKgZ9nxy0/up0HzyCM40s0uG/8klzuPk5UvhjXkVBM7LYGgI7yqZoM8ga2dPbLriGqhYciLv+lXVmXEAhPx0/BdBBKpGQRo8uJ7HPilCPrtUNL11RD6mn/uKiG7k4c+76shg8Tz7wpui4nt7fJePCibIxEvWi2VVvgIlzlHAfecK8jACZ1NYgwtY8ClYla2+RrzkC6CJPxM1QKkrGCVR3R3N5VLFURczLuyswYmpYR4y7c0fw0cDKIr7rXTE+YCXPOEv1XuSr1cgQZ3DktouLclSN9sji/gI/bcNuwWon/DHvSr/fVWlFuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y4TIKLHZySqO98qYzQyHoHZGKwl/KxJszkQRlg172q8=;
 b=jlmx5wCJWwY7ktNxuhJ4NVJHGMEcuxXhvFCrTndLD/hUtAhCCeaQE0Th8e8bdZL7lF4ZnJrw4cQ55sBuxB7op/ZkdMVnnQ86gmRLSbMRBodGkuSaHuPhWwVIKhmu0ZIGSpc084MXm89eygqvpelI00lJwzONDBoJVgDmMuOuMy3mrseocFPASXUYMlRyoGb2BqomD9RAfAlSxR8S6xlu6tC/91NvHYuuMLD9vKR3mbWXiupn+p7OkH9GMImhII9HBTf3edw72j/77Gn78M/nBYF+AtJ5HS3CaG22E9vkJXa1sLfz5pn48jGqLJOFwgUzuIcEyti5RfhENfWf6YQ43g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y4TIKLHZySqO98qYzQyHoHZGKwl/KxJszkQRlg172q8=;
 b=SHaUaxTO3h8RF+YEVZf0tqMMZzGGtoaoORqTN2TU2ctfzB2hGazqa4g2zbXR5Ndinc+E0jNRCwqZafDoTK3xJlF40eYAbL2L9TkVj/L3+FuGsWz6JAtSiq9Xq0ghYel4tJCz/yIV5C4NqliwhN9W5mOdDQ3tAeoIW0GE0zaNhfM=
Received: from SN6PR10MB3022.namprd10.prod.outlook.com (2603:10b6:805:d8::25)
 by DS7PR10MB5037.namprd10.prod.outlook.com (2603:10b6:5:3a9::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.29; Tue, 7 Mar
 2023 21:00:05 +0000
Received: from SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::93c9:c99e:5ab:4319]) by SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::93c9:c99e:5ab:4319%7]) with mapi id 15.20.6156.028; Tue, 7 Mar 2023
 21:00:05 +0000
From:   "Liam R. Howlett" <Liam.Howlett@oracle.com>
To:     maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Pengfei Xu <pengfei.xu@intel.com>,
        syzbot+2ee18845e89ae76342c5@syzkaller.appspotmail.com,
        Matthew Wilcox <willy@infradead.org>, heng.su@intel.com,
        lkp@intel.com, Stable@vger.kernel.org
Subject: [PATCH] mm/ksm: Fix race with ksm_exit() in VMA iteration
Date:   Tue,  7 Mar 2023 15:59:51 -0500
Message-Id: <20230307205951.2465275-1-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.39.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT2PR01CA0020.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:38::25) To SN6PR10MB3022.namprd10.prod.outlook.com
 (2603:10b6:805:d8::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR10MB3022:EE_|DS7PR10MB5037:EE_
X-MS-Office365-Filtering-Correlation-Id: b4f7e81d-c2b1-4593-4734-08db1f4eed1d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jqzpWA2bk3YGm3wP9+MlDbrjGZVdQ3TdLpJJiyb/Tp3fpz4Kfp7RoXEWQNCIVBLqt+lfyR+/6SwA09YElpHCkEkBAkZyhiaEhHa3a05P52vG5H5Ck+CEeEuYm/reYL7kxNXv4wYvltTCeEec8/JSp8NIz/TPivVLy/laAK1ChbqGAc9YaTXBk7ofLCLbmwwrm5K/+Ncp7/z6YEIbGncQfWX4sDhl2hWmOFjJgBo7rr6VESCwcbaKd77h5wgj7xRKoiExrPqEiRetTPgtXWn+Iku+amY1fva3YLEr/Iqtn4BCX8fPMzgLNZvGsoiBky/Q/QHagHtKnAsY11X+5eqjpb0e5eu4ZfCA5nfvcyQFXZIHNFAqe7IUzywwivct2+5cZG9UW/s1KVW8CeCawVgpw2RaqXhI2Iiq4gmaAFMNZK2AVxBhHBwfi9blnnpabUTsymMzDF+rEdwdMBc0OxwlanvGjT61jOW+kvkKl8RDzLGh4WZGbA6nx2LT7FxR+6umYmqaBU9byGvz3dcJMzzzidKMuJ7wvRJ2k9wwNPJi839EWCabi20zJwR+wlmk/GXDi3+Kw6O7Q+VLG8nUUkI0bNfhCd1ScPOB/ma7uOBn7UgAeAVmmlxBRYyUTjQbuCTXejK10w/vMZ9TcdTk6Khnx5ddWNpC4EghTdssdI/qvaCr37Ac93TvhzO9Xut5svKG8s3VT9jvyj47tbDJZFPgDTYJufPwnbMVNvKUNoSNJrc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3022.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(376002)(39860400002)(366004)(346002)(396003)(451199018)(66946007)(66476007)(66556008)(8676002)(54906003)(6486002)(478600001)(316002)(966005)(41300700001)(6916009)(4326008)(5660300002)(86362001)(36756003)(6506007)(1076003)(26005)(6512007)(186003)(2616005)(83380400001)(2906002)(7416002)(38100700002)(8936002)(6666004)(99710200001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wAndExHv8ooNQ1G6B1F5O/4VNbPWo3a5b63RLRAyoOCdZgFAMCZuDMrLM++0?=
 =?us-ascii?Q?QbA2UL+9iLtm6d839x17mjmIalw2Lb6P7cOS9tv1VzB1lfqcb53MMYj0Vd1R?=
 =?us-ascii?Q?H9iCUV43+2o6oobuaTazfhiUPjSdW/SyZWMOhGKC/oz4hTa7NbbV+nExm+zE?=
 =?us-ascii?Q?6/ck9PRRw5yiq/3zZa8sBS2ecwTp4PjcDP18oQAsq1Vf0UHC8fKavnczFmB0?=
 =?us-ascii?Q?AGzIcN01I4Xj4yyUoUnBEJIlUR4j5iBya5rE+8it1H2q7aHn7x74yMIOd2tn?=
 =?us-ascii?Q?2gXlspuMklVMOuMu5smBpMbhd0fBNW1UBUlTspVIoLjUUvip1acm/APYZRjN?=
 =?us-ascii?Q?W/0ZMcfjY0eTLkgTUGjLFHoczSN7m3UztZygEXIZlYAhcDUAVGOj8S5cEHUf?=
 =?us-ascii?Q?JdiqIDN+K3XwQE4IbzbkX4zTLWAIpxOsaRdu5nZ+d74Sk40pMGn4W5iMo+LU?=
 =?us-ascii?Q?yxlbht3qg0B5vRNxG2nRByGOHgobfiJ06R9XC0N8Dwznh4DuSTtpIfwtGAA4?=
 =?us-ascii?Q?9Cn35N4mSM6DoPaXrqb3PU9uytc44zetXG42M5o6S68GVUf+h9Qp2xC5I4l2?=
 =?us-ascii?Q?WcvK6JKRNVZ1CqeWE7hgtP1i7lo3AcH8wAawfUmDO1G8uihPsLjgoicSbqm4?=
 =?us-ascii?Q?cextRaPZeXMrMxxHmuXBywF4dK00OmsXkgfvOiWjz3aafPbXVuFoprPbyqYR?=
 =?us-ascii?Q?f/4wcE4Jzey0iMpQ9bl0HFbTmiXLeUCY6pQB3Rw6tynfMern9k7yaCN8s+xr?=
 =?us-ascii?Q?9Yo4Im7jGau5BCh9xWuXjLe+CvBJZFXsFaCQAM9O6bf1K2qSRmpWd6iMbd1C?=
 =?us-ascii?Q?zOiZg5ss5EUYdFp2b1lw6r4WUXNvsDSL4EQRxVZ+4rWfUFU8CtOvPxX7xTYb?=
 =?us-ascii?Q?II8c2K9sv9jkd/Yk4ldJlGfuebCfCkmX+u0NMDCsuNQz/vNRW/OL7ceqDN7b?=
 =?us-ascii?Q?8ef2oGncbcbffNkAYZs8KsHgDT2Xcf5HhFw1raO0tiEqAobg3c9Y74ji8to0?=
 =?us-ascii?Q?QRxyBsPVmVehJWLSa0OOJCbwrg+XIESD2L1R+BClXVkDwU6jd+ljp8JlBKN6?=
 =?us-ascii?Q?Bpd3hDD7WzZqc1iqN28QKtaXK/kR24dJAky0Uc6bKOjFFQshVeF08/GM6kHB?=
 =?us-ascii?Q?AhXzqwoOrp+rfNGIrxJCPbsWALQW9vZolYuLIOUimA53qgY1wEug9lpvC0pM?=
 =?us-ascii?Q?VfLcLPahPyHqDKgUui1FM1zu8tKUbSf4lmua5gwiG0uNLN3WDIHpf6lCIQ/U?=
 =?us-ascii?Q?klY2alfpSTWO3QijMXUA7J+mFAkgZNx2iLHaKyD9Kk9Ugvi5aCnS1Fz2b5qD?=
 =?us-ascii?Q?Kxt79vtcBXEbCdzYMrh0OTwqY4vWlENATtLz/9kmoqAwyFJvgAl5WzI+z9Hd?=
 =?us-ascii?Q?P7L+xp4MeiiiOctBAXaklpQ9uxzZxFz79AAkA5EPMuqcB6kOBJhZSvFElPj5?=
 =?us-ascii?Q?9n8x3jnHo3SP9iiVxMOqgUq4Uywc+qMKn6xvJ1lDyk62C01nd9KynIgiSML7?=
 =?us-ascii?Q?meQVIwq+38MU1iF9PS6k3BPaWkfx+qb+8sQKNGuul5+pMXQ1UpGYMCE51RFr?=
 =?us-ascii?Q?9ArWSpTTPbWSbIGjbIoWc7MWKccDc5S3D87wShFyiD8fBGPTS+7B8L8OKK7t?=
 =?us-ascii?Q?8Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?ukmRKx6dDe5XwJrWVyQ1PeQBKFSGS+QO0CmIzdaf/tkasFysrFX9p//7DxMO?=
 =?us-ascii?Q?lrE70t99UxsRQuQyYhmEmThpnAOitLFVk5HKbIMj5glKW2tVz/1310H7axqS?=
 =?us-ascii?Q?FLBaHkqdmgUjdLxoQ6noBLjIE6LwQ0l/ltM8ynox5LhaN7uQbtH42ivYjKh2?=
 =?us-ascii?Q?Q5Z7FFHwtG051MoqUunzpvPbMBu7nKk/bnDh35UxDvzWx+a4Fl5+MLhmP0OQ?=
 =?us-ascii?Q?9mLN6uUwHUL/DKQNaO3jrXK8TZ0Gu2vno6i6qmQWJOfRKGAuh17UGdk4yQNh?=
 =?us-ascii?Q?PmC3x2Df/fDxYf2N+jos2Bl1Coej1TK6t90SCQPOd44c31cR2xv4Pbp6jRok?=
 =?us-ascii?Q?RRndAd3MY4rrZwKR8L/Wk5UqskGHNaIt+0yhfSJ7abZn0ITz6uYDtIIF1qor?=
 =?us-ascii?Q?qmqIcxT4xqAytCFg/IcjXscpMxozuLXWlau5YxdEke01I7JbKsEIGKLTYwoU?=
 =?us-ascii?Q?vv8T3geHrA7QUyX3wctfC5bu7iq8yHeJz0T9jGz6WcH3nuoL56f7jY+ds207?=
 =?us-ascii?Q?21ZGrZkQdLKyxBYXq/hmqBCFuQ1mdC7Ym+UOQ6vuMgMd2NkG4vut+evdf/1D?=
 =?us-ascii?Q?yjaDIOjNOhAvYaGQNW7oieTpogxqGgYedcBGJCN2ILk92tEb/q/9vSNohYXI?=
 =?us-ascii?Q?U5MeMDrnZSYoOsgEpi/UayWqwl2nvNsL+srDqlFxikLFdV8JlXXrPEfYKpBj?=
 =?us-ascii?Q?ysFm3mFBJ4qferDRPk0jkaU3E9j/SoO5jW0LbOUkuQTPxRTvkKXlBZIN24Yf?=
 =?us-ascii?Q?Bqa4qN9tIBuFtd9XvCVRpwIRUhh58YkwosUy8B3hwSPOGl6+5aaWIVjtqKBY?=
 =?us-ascii?Q?kI7LRZ92xCrZ1bS4HtyiNBT5QF442KWtI3qMjbRro7VwXQLo34LKRYfkca3O?=
 =?us-ascii?Q?J2IqBD27Z9tBBAukeHwYIPrVvDUEPVGHUgsdU0G5SL8pkR2BEfP+wz//2P3X?=
 =?us-ascii?Q?Xc6M3T4nRtV8Qsf2isRqZR1mDTWrs0rWXkiZ8xuolzVPu2BJolfYvm7eV6a6?=
 =?us-ascii?Q?VT9cAKUQ3r8NH3bN3X2CR4WQ1g=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4f7e81d-c2b1-4593-4734-08db1f4eed1d
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3022.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2023 21:00:05.0179
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ii/DTyqcTqYfPhNZpzFqaD9Dpg4NCl3HKDd8E9S+6+61lNL59Cp56NpnUkpGBJ/3l8hTZ05ubtfbwvAMAfYayQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5037
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-07_16,2023-03-07_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 bulkscore=0 phishscore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303070187
X-Proofpoint-GUID: _7J32a3CXEl0QD9awKRPWpN3KCwu9nOd
X-Proofpoint-ORIG-GUID: _7J32a3CXEl0QD9awKRPWpN3KCwu9nOd
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

ksm_exit() may remove the mm from the ksm_scan between the unlocking of
the ksm_mmlist and the start of the VMA iteration.  This results in the
mmap_read_lock() not being taken and a report from lockdep that the mm
isn't locked in the maple tree code.

Fix the race by checking if this mm has been removed before iterating
the VMAs. __ksm_exit() uses the mmap lock to synchronize the freeing of
an mm, so it is safe to keep iterating over the VMAs when it is going to
be freed.

This change will slow down the mm exit during the race condition, but
will speed up the non-race scenarios iteration over the VMA list, which
should be much more common.

Reported-by: Pengfei Xu <pengfei.xu@intel.com>
Link: https://lore.kernel.org/lkml/ZAdUUhSbaa6fHS36@xpf.sh.intel.com/
Reported-by: syzbot+2ee18845e89ae76342c5@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?id=64a3e95957cd3deab99df7cd7b5a9475af92c93e
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: heng.su@intel.com
Cc: lkp@intel.com
Cc: <Stable@vger.kernel.org>
Fixes: a5f18ba07276 ("mm/ksm: use vma iterators instead of vma linked list")
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 mm/ksm.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index 525c3306e78b..723ddbe6ea97 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -1044,9 +1044,10 @@ static int unmerge_and_remove_all_rmap_items(void)
 
 		mm = mm_slot->slot.mm;
 		mmap_read_lock(mm);
+		if (ksm_test_exit(mm))
+			goto mm_exiting;
+
 		for_each_vma(vmi, vma) {
-			if (ksm_test_exit(mm))
-				break;
 			if (!(vma->vm_flags & VM_MERGEABLE) || !vma->anon_vma)
 				continue;
 			err = unmerge_ksm_pages(vma,
@@ -1055,6 +1056,7 @@ static int unmerge_and_remove_all_rmap_items(void)
 				goto error;
 		}
 
+mm_exiting:
 		remove_trailing_rmap_items(&mm_slot->rmap_list);
 		mmap_read_unlock(mm);
 
-- 
2.39.2

