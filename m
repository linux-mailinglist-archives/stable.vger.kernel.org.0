Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B616B6DE2D8
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 19:42:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbjDKRm1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Apr 2023 13:42:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbjDKRmY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 13:42:24 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8D925BBA;
        Tue, 11 Apr 2023 10:42:23 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33BF1LWC018024;
        Tue, 11 Apr 2023 17:41:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2023-03-30;
 bh=QKDMQEzqy0QSLTifoL3yCudDkTYt5t7eQoMfLCFgz5c=;
 b=Wfzi09dos1bdAo3Sdvgl97X5wPHeDhIGuA8hbT8CZurZekK5MUfy1GFujrZ0q/HTNPMI
 32dAdKJKpds1YBeD2owxuht9khAVtu3cJ2z6WUZLQoHDA4iT86va8DdIcP8aI7QFZ09d
 qJEhw8oHhnKk0Xkn0WV13a2f9Izd/U72tXieUVKcjesCStEkQPd4lnZdresr/QZB8J1G
 iFMhfcj43AeCeg1rPZMsmlunLQzbA1Pvn5/VplMb5BfW2/7x6+c0mwiqAt3hXGhvGKOD
 rf6c0ls3r6Zff+xiXAoOqr+Vrurx5HmcPuHTnJEagdBzvoytg8GtacRIhMjDPUFdrS7s 1Q== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pu0etp2c2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Apr 2023 17:41:58 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33BHZEgv030939;
        Tue, 11 Apr 2023 17:41:57 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2103.outbound.protection.outlook.com [104.47.70.103])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3puwbng78e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Apr 2023 17:41:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UxuEs+Bpd1BXiWbXrMG4l7kBZtm+8MgkmZ12tM8T7ZBtHhydEOsR0lA4zatJV33J2Vr6eE4h40yMJ+0FCQ3VyD5qO33Ke5MNNb7KZNclJzqQJacC9T3kBK+XpQT7Y4Qxo+NkFidKImridi+0bAv7WjDFxHqBdV03G70i5KQy6OTvaMGR9PttGMFXT1/soZr5tVTFziO8WTEEAPEQ0p8yoI+dVOgQ8p4oTxTw0GEpTjS5gOSciN3syRjstsq5Rx5kPr9eqJ/BfR+NOXL/mKKXFHuBi8JNEMFSepBH92GwoHYBJdXrcpJD1HxTYkPIwwotO4qbF3dSY7jZWgap7HJRnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QKDMQEzqy0QSLTifoL3yCudDkTYt5t7eQoMfLCFgz5c=;
 b=fL4QOMHg7YwoCpNmjaAOmmoBOhTNF3vSidn+v1mf8Lm3LtzDtrBRRc3LEnBE9b07svV955c6LhVmo3FktSzK3kkiDbIoY5DIqEdiXERQlblYZbXpYiPMFWNq2gCGryFmq5gKKpxMd2n/GD4X+F8enZ38KFfLg63ks2wxBSlHYDS6OnsYm4ItXSTyvJZi7PyRxd2rEEB3j35QL41/BGtSJs7xTWh0YoUnQPwHh6QhoVkBeDJ7iy04fXccuraZ1UqyFscpsmzxyyKsGMX+P+qkz315jcYXr1zHgPU/LGf98rRs3J9uU8ekvwnhfeT1dgp5UA0JmKSrNo4xgGezGqk+jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QKDMQEzqy0QSLTifoL3yCudDkTYt5t7eQoMfLCFgz5c=;
 b=WtqUNPbCriliBY5O903RjPqsosiy8tqeYQW8IcYkJlpElBoSDYNMx7gsTRLUvznda/GqW8FfByfFrG/lRQSqKoBX2S9i2O1Wif9OAmWIJWcOLHheQwKoZ/36lLnft0teQwYzL1Z+YCKSPgJRQYOtStnDNh8rzH9fuN9ax1nQGMg=
Received: from SN6PR10MB3022.namprd10.prod.outlook.com (2603:10b6:805:d8::25)
 by SA1PR10MB5784.namprd10.prod.outlook.com (2603:10b6:806:23f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.35; Tue, 11 Apr
 2023 17:41:55 +0000
Received: from SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::8bb9:2bb7:3930:b5da]) by SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::8bb9:2bb7:3930:b5da%7]) with mapi id 15.20.6277.035; Tue, 11 Apr 2023
 17:41:55 +0000
Date:   Tue, 11 Apr 2023 13:41:52 -0400
From:   "Liam R. Howlett" <Liam.Howlett@Oracle.com>
To:     Peng Zhang <zhangpeng.00@bytedance.com>
Cc:     akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, maple-tree@lists.infradead.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] maple_tree: Fix a potential memory leak, OOB
 access, or other unpredictable bug
Message-ID: <20230411174152.4j2clkhb5xxh5rkk@revolver>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@Oracle.com>,
        Peng Zhang <zhangpeng.00@bytedance.com>, akpm@linux-foundation.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        maple-tree@lists.infradead.org, stable@vger.kernel.org
References: <20230411041005.26205-1-zhangpeng.00@bytedance.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230411041005.26205-1-zhangpeng.00@bytedance.com>
User-Agent: NeoMutt/20220429
X-ClientProxiedBy: YT4PR01CA0354.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:fc::14) To SN6PR10MB3022.namprd10.prod.outlook.com
 (2603:10b6:805:d8::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR10MB3022:EE_|SA1PR10MB5784:EE_
X-MS-Office365-Filtering-Correlation-Id: d9d86b7a-8058-4ec0-7d4b-08db3ab40ac5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wBHngvU8nwynfhb+mVoesxdwy2fff4X6UFOMh8W1vdfV8f3urAve4niqzAGgZYZiLkpHK8AUSEd9X4iJPRK4F7MY7FTGWBvbDRXhy1/34yqAJtuk+Uwf7mA1SNIB81A3dHy2XQrGuRrV5ZoCE2OiwdS8mj8j4XWADtwlVg8Oj9/lGZ7+b1wNKVMfFw78CQke+vNb3B6wxgcRvNlj9wc1lQp+8oTTieYvE7DGEU3s0i18Pi3mJ2E/4Wyx2TDwZBxghstf13auxzq+PQKuz7xJzK6lx7CtSDPtcSzaqKeAcXv4aTOFo1yF4TfIHgxvLl/E52WVhqv/+6IVHmwHww57nJdDdi6msv2RD2/Wtm6+UdvLh95TXCDM20D1rOGxTRIIfmiWinV4sGfXPvWwYmE+uL4sE2DJyaOsY5UBmzmNcOTYo/r9kyAypKpdlTzdd7msYoSwViwYlcEUAnbqvLFr4WvYTaA9Jtxs6sjjoVD6QmktoGkBAXDZq+TgqeunbnfQHvhfJMQcVHlwTLvpDdGZ0kF7lA2us1r7rtHFfqWfJ3XMaomFLoZebZJqD05hmHSI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3022.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(39860400002)(366004)(136003)(346002)(376002)(396003)(451199021)(41300700001)(5660300002)(478600001)(8676002)(38100700002)(8936002)(83380400001)(2906002)(186003)(1076003)(66946007)(26005)(4326008)(86362001)(6916009)(9686003)(316002)(66476007)(6512007)(6506007)(66556008)(33716001)(6666004)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CZSnlC/d9AZimTeQ8t7/rBRhe0pI2IlTxMNysLkNFaMUV5o9J99Qily8ATUC?=
 =?us-ascii?Q?3PwMGkYCjY9esiDZexDMHJMT5IkAErVLW9fTdMih0pYlVMUUbZU9rBXCQQPT?=
 =?us-ascii?Q?GrHxOzewkyrz957E3rBPLlJW5x1YLtHB2rQlbvZc5qFQZaWeaHkiy8LAFa5E?=
 =?us-ascii?Q?xeeLBVk5oHoNRYUOwFwHsYJoj/C+KvFzMCddDcaInsePxfO0kHYLGD/HpAo9?=
 =?us-ascii?Q?ug2Ia1x9NuNGWXPPziruDRgu8XY0whNHUxUmCVuaLEeEWNNNSH2XJyUpZPQK?=
 =?us-ascii?Q?IJOVvYCvWDiNpWwHsBT3+StxQXTPOZgmyZ1aIUzVTmo67L78XgV21bIWqy4E?=
 =?us-ascii?Q?x1BResN/MzsGeVCGNp5gfFZXXhX7lHKQ0Jv5xQuy6AFTVwiafLcjckSLofua?=
 =?us-ascii?Q?4VnCeUl88ixUyiYoAx7qjGED4xI5Lj1O/msvszi08SqMAuQ9Cbf8ZxWaUVez?=
 =?us-ascii?Q?izsZycXxTy0i9Lf3mGFfwHxsbSMUHsRH4Zl+KSdVPHbHb2swcwsm8OWXXcrg?=
 =?us-ascii?Q?54LWBsKSZZJM32SOobG70tbmAEbC87Y2Nw7CbCdm+fDbE13KQsO+YCy8u7dd?=
 =?us-ascii?Q?rZD9vxSKaR8LzLREVGVjHZZ91hY251p9tUeB6BTwgJzDZTsqNEaeop1IWHU/?=
 =?us-ascii?Q?niZuqnuyb2PobxVJAxzwQML+SId5sbd7p21PNAnYNjtpAU7cCQtv/0Bkr45N?=
 =?us-ascii?Q?pVQN5JGqRUHbYTZJ+umz6enu3pZuzJSyU9jfmFfYItvgweBsi4YtDfOPx+Ko?=
 =?us-ascii?Q?CC9p0QaYC963fes9YG6Y+zHqRb358ls4/unIA22+Ayc362hGfd01AkUj/Jt9?=
 =?us-ascii?Q?nkv40uT8VKKRsJuLoRd/iaH7QwkCh0bGhE5Fr2BE2xzlEQa4ueUjbnrKu6FL?=
 =?us-ascii?Q?ERtN/uWC0ercYVVFO6EOCzvTJBHaKXv7lWpbLQqRermD8M22bPyaGDay/1x5?=
 =?us-ascii?Q?HGN7CHZb72At2TJk6vEFaOXyaLBQJTfgD/mf7BiNsP8nwTUYeQd9T+XRNkLy?=
 =?us-ascii?Q?o1lJ6RljpUVvftVaZ2SivTUKtGPIZ/yeiROVXkheO/bzeOfIebvOXtkG2upJ?=
 =?us-ascii?Q?tILC0EDmMvlyNpE6uCUH1yigmO6Blhgm7NwH3C15EAx1MUN1SsagOVXB+y1K?=
 =?us-ascii?Q?7hvmm/4rSsVqjF0b2Ue+wEHD+3uEMCSKuLGnoKzqaNWuxp6fHM/R4xwht28H?=
 =?us-ascii?Q?D8WdpANiiC/p08R5rWjt4gycpS8Y1XrNPYf1J8Q0ka30ZUYgYCkjlM1lsqdc?=
 =?us-ascii?Q?xg/jnjWo4A2DoKwg17T9AihvkNLdAA7k+l1d7TlNjiADZjeoEsCUunr7OWOB?=
 =?us-ascii?Q?GB9nHw8kdtxE63vXc3kr32JiilULOSdLGk6jlh4Sjv6B2TE+Wuk1kMHOAXTm?=
 =?us-ascii?Q?/luliHv6KwMZMZLPB3DgPta1LU2yqgKm1wGVOihR8jOhS+UutfqnSBYXD/Ch?=
 =?us-ascii?Q?awCNgS99Q7ArLMq3AFwtibTK0MFN13hGnwcIdSeY9ocz1n6MxlEDBHctR1Ii?=
 =?us-ascii?Q?ATA4kZbZl+q2so63AekpMw/ea07tmHWQ7ZZ3ZxlsgjpOiR2u5+xYA8ddeTgh?=
 =?us-ascii?Q?McRFzuE5IQ87ku4tQ9ahpAeq0qFmhl5b0nTH/Gi9VDtFxZX3RPGDIyOTJr2T?=
 =?us-ascii?Q?fw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?bzhCEEM2IU1aqciVLa2+ghMTalT3j5YZUTmHSYKXPIPd7RLP1rDPoSkqwH8M?=
 =?us-ascii?Q?PoxelSdoP+5ttLJL7v/hiUpvmrvWyhEE3JSRZQM2N4qRp1d7v8WwwjCK3I5j?=
 =?us-ascii?Q?n07HKfjFtdN/k8FNgi4oW+31wDW2iCsfxF4igFfmke3fg+1zsryCrC3vY9Gf?=
 =?us-ascii?Q?QbaNlEYEJPcwVI2v0L00FnbleAkn3fA7DJ0nmFzrIFM4MBjYhqg8FarXRGMx?=
 =?us-ascii?Q?vByVTyA2nfsdHLlyemOuNRNAWyFYnSq+qwdTUlezNfJhTxkBT40fqGu1qfD9?=
 =?us-ascii?Q?qbRTVlDZs1zDJ8E1SChos9NhYizDjAtLnpFNssbKD5xvAv8GNxoCDbeLW/qY?=
 =?us-ascii?Q?oCJS07TbL0UyYsnZF3+pZpAyX06BZbTN2ltd2hCxtvE5BWMU0JWciMfBMSxC?=
 =?us-ascii?Q?xQzI6iW+wDbUjRhVAo5qSMs8HcUwOwDeLsHmwInsKNsrZ8W/tsXIxtfJP9eo?=
 =?us-ascii?Q?E7ft3t99EO2qDz0JZAGITjgthcu5trNZq171sdA5HRPdW/2left/pTwNrQ9M?=
 =?us-ascii?Q?sTGOehJ7gybvbnOQN1kC1S6usZ7rHZWthodgqJP1ahSRYPUD6GmiYC0yfCup?=
 =?us-ascii?Q?cGCrjPw98IxR1F+DfNmsZb5bOsqMSP68tX1cj6JMQ3MkoLKN2o/cBJsQzqrt?=
 =?us-ascii?Q?6Fd2x1+CC8L6I2uuJnMaKzPlpjw2DbsbvnYx+dVFAYF/Mw8fEP3lDsx9ZKlx?=
 =?us-ascii?Q?jiGBbxfXVObHJNwM5/KeZtlqZxxl4M3LHzxQy/vcwTXjPjmJ5MH5WE6YY+vN?=
 =?us-ascii?Q?axnUmlI6+25tGtMOaXDjNbN2U2zGjTT8aIRzHPVhDmy6UiFxRLpTh/yyR153?=
 =?us-ascii?Q?xiqsbKiyVgL6YJUnV0bW/4KIIcOjiRW0gqRdrVEP7soPv27/NzCw/wuC5Aku?=
 =?us-ascii?Q?rpRxabnerkqht5mE8j8u7d9AsG1jIY19OW/7rY7qlYNa5mhwkSAE8QY8isEx?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9d86b7a-8058-4ec0-7d4b-08db3ab40ac5
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3022.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2023 17:41:55.3708
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MV8pqlb7SGn2tpHGPoIasPfYPapFW979Hpv2k1jZbcjJkw1EFzyB6h6oTK3TFXm0qQe1JsS4ifNarigk0HPPqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5784
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-11_11,2023-04-11_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 suspectscore=0 bulkscore=0 spamscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304110161
X-Proofpoint-GUID: iHUyG9x5A_NUaRYLSkMyo-2Vx8WIUO33
X-Proofpoint-ORIG-GUID: iHUyG9x5A_NUaRYLSkMyo-2Vx8WIUO33
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

* Peng Zhang <zhangpeng.00@bytedance.com> [230411 00:10]:
> In mas_alloc_nodes(), "node->node_count = 0" means to initialize the
> node_count field of the new node, but the node may not be a new node.
> It may be a node that existed before and node_count has a value, setting
> it to 0 will cause a memory leak. At this time, mas->alloc->total will
> be greater than the actual number of nodes in the linked list, which may
> cause many other errors. For example, out-of-bounds access in mas_pop_node(),
> and mas_pop_node() may return addresses that should not be used. Fix it
> by initializing node_count only for new nodes.
> 
> Also, by the way, an if-else statement was removed to simplify the code.
> 
> Fixes: 54a611b60590 ("Maple Tree: add new data structure")
> Signed-off-by: Peng Zhang <zhangpeng.00@bytedance.com>
> Cc: <stable@vger.kernel.org>

Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>

> ---
>  lib/maple_tree.c | 19 +++++++------------
>  1 file changed, 7 insertions(+), 12 deletions(-)
> 
> diff --git a/lib/maple_tree.c b/lib/maple_tree.c
> index dd1a114d9e2b..938634bea2d6 100644
> --- a/lib/maple_tree.c
> +++ b/lib/maple_tree.c
> @@ -1303,26 +1303,21 @@ static inline void mas_alloc_nodes(struct ma_state *mas, gfp_t gfp)
>  	node = mas->alloc;
>  	node->request_count = 0;
>  	while (requested) {
> -		max_req = MAPLE_ALLOC_SLOTS;
> -		if (node->node_count) {
> -			unsigned int offset = node->node_count;
> -
> -			slots = (void **)&node->slot[offset];
> -			max_req -= offset;
> -		} else {
> -			slots = (void **)&node->slot;
> -		}
> -
> +		max_req = MAPLE_ALLOC_SLOTS - node->node_count;
> +		slots = (void **)&node->slot[node->node_count];
>  		max_req = min(requested, max_req);
>  		count = mt_alloc_bulk(gfp, max_req, slots);
>  		if (!count)
>  			goto nomem_bulk;
>  
> +		if (node->node_count == 0) {
> +			node->slot[0]->node_count = 0;
> +			node->slot[0]->request_count = 0;
> +		}
> +
>  		node->node_count += count;
>  		allocated += count;
>  		node = node->slot[0];
> -		node->node_count = 0;
> -		node->request_count = 0;
>  		requested -= count;
>  	}
>  	mas->alloc->total = allocated;
> -- 
> 2.20.1
> 
