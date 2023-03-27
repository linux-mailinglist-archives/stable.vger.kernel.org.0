Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CC666CAD11
	for <lists+stable@lfdr.de>; Mon, 27 Mar 2023 20:35:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229852AbjC0SfB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Mar 2023 14:35:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbjC0SfA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Mar 2023 14:35:00 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7A6E3AA8;
        Mon, 27 Mar 2023 11:34:59 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32RIYWsn018371;
        Mon, 27 Mar 2023 18:34:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2022-7-12;
 bh=jfTbdZ2XI1vlos8QBT9uLeBQAGtYJqPSxnhQhQNe8DA=;
 b=UcmmR8db875DNvBirWdtos3jbzQJqiVqL1czn9KkGP1Ki7j/TKyCGkAQfJZwpI8M4cGh
 FkIL7ruLglnjwJh4UHF9NMRHYxjh+Rl3LJfSgvD6g7nzj9gnR7ZKed3nF+FxPIPZwZ9h
 G8r8XiCAVlHtQh7WBw8XQzXEc2sy0qopvbMNi26WjoGKX1JsH65NoNNAslBGsFpmgEsw
 vL/KMQoGKyMHnf6iN+dICdgliNgt4Uu6AH9WtYaizlPPyfmYYnFc2B2JUBqP2bN7M9rj
 /5ivPIY4kEw/tpNabsTPkzvW0KKAZyEo2ZNKhaNXj1Bsx2er671FtPibFgJhoEPWqKJX kg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pkghq002b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Mar 2023 18:34:47 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32RH8ghL005467;
        Mon, 27 Mar 2023 18:34:46 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2171.outbound.protection.outlook.com [104.47.59.171])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3phqd5bu7h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Mar 2023 18:34:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hf45IY6kR+Ao3EF6ApdMYqmhLEonlbYLQx4U70lJxpDP5WCFqfusK1vzFYEIAu5YkRtk+VWwOaJugaj6duBEbOuZ413TqiSzTc6+H2sa0UVtq8YAMmBHLDcLGO1wKug2LldyA0AkfCoNjjMxSs/SI3AQHG4uGj1D373uq75L8KqubdkFisIFfiW5CImsV8/dyRjHKvJytpZXlgqt2mNxRs43cx/LrHX9CNlZ6DnkoGxZ9XLZuZ0/qGLiRNgA7YdmJV091GgXaJJiDJ15MnvJKJN7/Rm88Ob2YClPcjrkqT4qXCqjTtEnlK5SbMTveGcMhgjQnXKBLIt+hFtSKWu1mQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jfTbdZ2XI1vlos8QBT9uLeBQAGtYJqPSxnhQhQNe8DA=;
 b=Eae+1Le3s51d8gvDRMGbBGWJjm2Xk1r9GtAjbUwto7yBIxgv0ffmOIOooC7hcAX3Ke6MAdByuaO4eRMX5E6Sc80vUhwbFH7nAde9SNAIgoafcda9HRfCbYmUQmKmD0Lv6Soz+alfMqBgs2fB3YVBgrEo/hzL9Dbb7SIPSNtesauqjSq1MIDRV+vGOoceGjd2ckLk/EDUHAtpeMdtdz7+NDOHk6gsMyxI0ZDBHLW+ezvhU5hcPKwvthwppfuUlsKphIGEDNJHJsuFPp5WiziG9oyjT5c9oB/tJkZ0ZZWMscacgecz3nit0QT9+cRoSCAHsFCb1DBvmHOtTcS7zcCv2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jfTbdZ2XI1vlos8QBT9uLeBQAGtYJqPSxnhQhQNe8DA=;
 b=NSCOjEUaOtoR8N6tUbEyySOuBq34CLrb/lpuCehMooHpvLUm1t/qkOC6ETvzkS3v1M+Gzpo5NueuW9EAgpQv+A0JuORDSGbwD4QZCL9gkiteHp+Jyl70I32s+YQ6YL+i6/oIvZz+Vt3nh5Oe68meBXoCiQ3B77UvQTHTTrZWvVM=
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by BLAPR10MB5009.namprd10.prod.outlook.com (2603:10b6:208:321::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.32; Mon, 27 Mar
 2023 18:34:41 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::3db5:6e11:9aca:708a]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::3db5:6e11:9aca:708a%8]) with mapi id 15.20.6178.041; Mon, 27 Mar 2023
 18:34:41 +0000
Date:   Mon, 27 Mar 2023 11:34:38 -0700
From:   Mike Kravetz <mike.kravetz@oracle.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     David Hildenbrand <david@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Muhammad Usama Anjum <usama.anjum@collabora.com>,
        linux-stable <stable@vger.kernel.org>
Subject: Re: [PATCH v3] mm/hugetlb: Fix uffd wr-protection for CoW
 optimization path
Message-ID: <20230327183438.GC4184@monkey>
References: <20230324142620.2344140-1-peterx@redhat.com>
 <20230324222707.GA3046@monkey>
 <8a06be33-1b44-b992-f80a-8764810ebf3f@redhat.com>
 <ZCBavqZE2cyVOzaW@x1n>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZCBavqZE2cyVOzaW@x1n>
X-ClientProxiedBy: MW4PR04CA0347.namprd04.prod.outlook.com
 (2603:10b6:303:8a::22) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4196:EE_|BLAPR10MB5009:EE_
X-MS-Office365-Filtering-Correlation-Id: fb104e6f-78f7-4ed1-1d28-08db2ef1edb9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r0ZY6NdzDtUdszGZfE3loIWvzz5O0tZB3G4DYA51K+kQla0IPNsDXg/IBjA/u9PAVkWatVCsr8+k+uqQwhHIMXA3Z8F5zb5+UEMYxwDyht5yLI4uw+4s2KfK8g4z3MqIOvTt/q3JhSeUHqsGuMEQ/gLl5PoNfhGXSuV40aziTJIz3mHcr2yMvlXv3n3FumET/xYXUqO/0VqDmF0wSZGDsexpENIL+IL+IcnuTh+2Pvd0PRJ3KKoQL5nyY9bvcBP8fJEqnbRcJqpZwMojsVl/oSxyJEphpgm1/OWEXEpiOrpyPGicL+Fxne0fpoCCRU2PvWJYbOUdrR53EkizDc86B4iYE7R+d6X4To5bPq1J1iIrAlwsGvxKYmHAXR6JwV9DGu2dV876+Ipp7Ys18UibF+fjPBpw4VeJeGA19Coy4A1GpMhMWlZzRYdFtofRaza2OR8ExbQiUq7lByaRqm5wVikDXF11ZzerBGEgJudhvQiur50KFE4JfJg3ZbaaHU8xZ1NdmMiHm4OarDlZZUBhvclN14tkcmioO9qXmwNeMKokgQkAaoxv1nETwhxoSywU
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(136003)(39860400002)(396003)(346002)(376002)(366004)(451199021)(7416002)(8936002)(5660300002)(44832011)(9686003)(53546011)(186003)(1076003)(6506007)(6512007)(26005)(2906002)(6666004)(86362001)(33656002)(6486002)(41300700001)(478600001)(38100700002)(33716001)(66946007)(4326008)(66476007)(66556008)(6916009)(54906003)(8676002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ftx1h5XCr5q/m67MchIobnvkAU7LbZy2XBMuvLzOKitjcGVWbnUEPXIWHQmK?=
 =?us-ascii?Q?J1joBMActu6YjshBtgkoktG/Q+mIE5nWHv0botLq9TtdhCgk7d84GoOstTf8?=
 =?us-ascii?Q?+bk9Yx+qyGY2whqECGaR8uELtltryMFDkdrs2v9o3Uyd3WDp3FHL0lfFG8kB?=
 =?us-ascii?Q?tPxYF4xpxdFWIcSIVi7Gb0qrYzQukzhLPh5XXETPHgWCjrf6mmkHHbDKUB+P?=
 =?us-ascii?Q?fOfYRkcBoi3KzCnICA6FCmCLXjIhjXvVAFRcdcKMtqzKn9Wgk74XVEqdlYpS?=
 =?us-ascii?Q?c6YAiqxYV2JtH5iYy63Ew0EmWcqegT4+6nW+YDQpw1Tu64+oyCAM9/HvCaC3?=
 =?us-ascii?Q?sBOt7wqpvYKrh8yCsrrDxrG4c1RCJlpeFDQ+t4BaMWAGxgblrgCBo9BwEbUb?=
 =?us-ascii?Q?3hMhnQY1nRWme0RO311nCqHUygV0xNJUIjmTyhb9hDajJrrRqZ/2VoLJ2X/F?=
 =?us-ascii?Q?ppkPYmZFgmXrdz19COSOLyNRZTz4SfvXamfDHmWOF0FTJBuxJfoKiHg8LtW9?=
 =?us-ascii?Q?cEO3zbyAXAJ/3dZY6KC0qkv/017uNASEnqNCVZnAv/8solOI78Kd65S+og3B?=
 =?us-ascii?Q?qaGIvR7Osksiucd2eu0hW5ZczawrMZdXksNm2ienIUetYjTbzu25yAyFLlFp?=
 =?us-ascii?Q?LVK0Lz7HYaSf71yxzyX1AI5oMSVUN2IercKiJQEMLWDwN5e3+DQ7eCFzV0fo?=
 =?us-ascii?Q?uwDMiouNgFNgTx9jM/HZ0/e2jNPoFmDFRmpCV+uVsDyMNIVEYni7tHUCPBrO?=
 =?us-ascii?Q?hPnH+mp5+HiCryjuS+uVeyMZ6fOrXhxcaFUUkVrd9yY3yXlv/aU361Ihso3D?=
 =?us-ascii?Q?cO7qiacUPUUHKEucbytiejF1xLOj74a8nG8KwtrMXc9TffDVZzmeSbhpKdzZ?=
 =?us-ascii?Q?sfeUfCle1iy6Fjbg8zli2NXT4gp51+8kv/rijSJ8qLcTYZHyhK83wW89JFrI?=
 =?us-ascii?Q?i7v1zzjQlk6jSqO4o8WE8psksM4fEphDv3sSSO4wcFDGM5wZzgAalVO1Qdbc?=
 =?us-ascii?Q?0K+St5nOQ5aorUqjB4E9Y4w7pBDHe38JXSdavxp9pHtXmgzhML/wTnt+Ab/M?=
 =?us-ascii?Q?k09JIywqlozEPUnpD55AdLjbjMN7VWZ541RRIqojxD/dH4zo9v+f3QBSc17F?=
 =?us-ascii?Q?rp6gUagkAr1F+HjdCeK1xqW6FSp/eLJanm30vj3kJmCVzmonpEb3bukKSyuN?=
 =?us-ascii?Q?QIoLbk/otLB1035hqtNuO59jHvugbA0jXhyrquniL5/B7ZT8Hi8EQ+nUjf74?=
 =?us-ascii?Q?+LalIKLTWKtHsUPcPsWMZzXzh+xt5LpiomLK5n0dBhHmnfC9Ag3QBQR0epLW?=
 =?us-ascii?Q?7x6yvvIQjzsk7Q4300MkyJL2l84SQ1GSBmR5M4fhgekHepdVcezws6mIzZz6?=
 =?us-ascii?Q?By5Gl80K2CdmYej33b/aLRVBnjfHFTGE6CVBoSDIGBYDlSr2P0BfAFkjUfh5?=
 =?us-ascii?Q?XsPInuvJ1VHG9bGl2NbxbfVVzNqGkMyDaoo5/qEV1oSNZYa7VqBtUCTOz6Mu?=
 =?us-ascii?Q?T1Cfk6O05S93HQI3r1aUSXwYAVvFAstNqEQZti6LF4TSPS4g30feqrtbQSQe?=
 =?us-ascii?Q?JofmADqnAB5d2WYjkA6SaoGjCeDwfQenrf8FWKnxRZ2j1zx+UCED2EFOnorX?=
 =?us-ascii?Q?bw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?2y0Ey3wjnBVEi/s7/YFQterFujeZoaogT+A4wdS6KpfjMJWgrt+4xAbDHkcC?=
 =?us-ascii?Q?2hUmcKGanvnyJJCQyrppeiT4X1JpHSwojlBjKYuzLUgkhfva4XgYjNx9LlGE?=
 =?us-ascii?Q?oa7dtw3EHOp24gQw1/02COjXplQqYT/GTqy7C93xyNRugbPSTWXG1VfgiMJR?=
 =?us-ascii?Q?OpdJNoodVFguMl956bJrn+d4MF83IR0LxsUtSHtMXAbIW+Alb+PsdjcBuMp4?=
 =?us-ascii?Q?7nGQNFg1RCUbfFup06B7WFN40dHZWygzYsgKilAexVfeTyvZooGQKj3enrxO?=
 =?us-ascii?Q?Bul/19hZO/wTchcoHSO6C92lYwSzibtSMlMIMDeN5Z6+8QVSwaTOXlZXBVbA?=
 =?us-ascii?Q?HMn1mvxHalOTj/5Zvzr3BE90X4N9NYOEiXvlEk1RisjuWNdhdnw5kDG7m3rO?=
 =?us-ascii?Q?DGkiNoYPqwpk2/34oNOVRSCxYNrkmQt00ZbCweIcvilPvF75cfdZTtopwekW?=
 =?us-ascii?Q?xYGC9YSUiKUFo6xcL6tFL2ankKWDPaXO+MkIeD+/MXgFRjA/EEXehSih+E7F?=
 =?us-ascii?Q?DpwCqnIoFvTgrkJwBNcBQ6c04PgNdKmqY7mkObSOvE5AFduV9sdiSsx1BwQp?=
 =?us-ascii?Q?nlHqD1d5L0CpIhB6cF41YP2has0o2ip1ODpd6YQBNEA+XLEpZnC6mcr1wjLe?=
 =?us-ascii?Q?INRNCyaTMxwljhkUbPPgccOcWq3Tt7RV3+Fb7LxefaatofjxhywvDR+C0+r7?=
 =?us-ascii?Q?bfQKegAD/Y68AuZdHpuYhU77+kf4Mi2o4p3JZxr4qMpwc13KyGH1AKDKR1N1?=
 =?us-ascii?Q?JchImWmuYr03xxn7K23opu6CkOMEZVA+zwZAEzRF1xRuFY0dz08pYvv+yEiF?=
 =?us-ascii?Q?XDPtJ4T6YHxvE0O0jZos+HyudNAyApX+L3Xy5dFZwlBaZ09mQBD3n3bys8ep?=
 =?us-ascii?Q?9ABq98aMDh2TDINow8ncVLOLW2Ths/YUNBBuXvzB8/3EWcHo36rVx2Z0Wa7O?=
 =?us-ascii?Q?gKcttt8074jE1zJf9lcL/iIkR/flaOPHUIwfc/f95yilciYfVmOrUFI90nm8?=
 =?us-ascii?Q?g0NNGptUYK0fe3DzxNlNbgDerQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb104e6f-78f7-4ed1-1d28-08db2ef1edb9
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2023 18:34:41.5272
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vQGuI5Tbu0EADo7Mab2TrI6wSsN9eBR0VhH2IraGatx71/ylTMPSO3ooL58RUVcrxXXKUi4NtHV9mlMmMib5Fg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5009
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-24_11,2023-03-27_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 suspectscore=0 malwarescore=0 spamscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303270152
X-Proofpoint-ORIG-GUID: v81ZORHO9cyxEN-ErFskDsmT6JzLEYQJ
X-Proofpoint-GUID: v81ZORHO9cyxEN-ErFskDsmT6JzLEYQJ
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 03/26/23 10:46, Peter Xu wrote:
> On Fri, Mar 24, 2023 at 11:36:53PM +0100, David Hildenbrand wrote:
> > > > @@ -5487,6 +5487,17 @@ static vm_fault_t hugetlb_wp(struct mm_struct *mm, struct vm_area_struct *vma,
> > > >   	unsigned long haddr = address & huge_page_mask(h);
> > > >   	struct mmu_notifier_range range;
> > > > +	/*
> > > > +	 * Never handle CoW for uffd-wp protected pages.  It should be only
> > > > +	 * handled when the uffd-wp protection is removed.
> > > > +	 *
> > > > +	 * Note that only the CoW optimization path (in hugetlb_no_page())
> > > > +	 * can trigger this, because hugetlb_fault() will always resolve
> > > > +	 * uffd-wp bit first.
> > > > +	 */
> > > > +	if (!unshare && huge_pte_uffd_wp(pte))
> > > > +		return 0;
> > > 
> > > This looks correct.  However, since the previous version looked correct I must
> > > ask.  Can we have unshare set and huge_pte_uffd_wp true?  If so, then it seems
> > > we would need to possibly propogate that uffd_wp to the new pte as in v2
> 
> Good point, thanks for spotting!
> 
> > 
> > We can. A reproducer would share an anon hugetlb page because parent and
> > child. In the parent, we would uffd-wp that page. We could trigger unsharing
> > by R/O-pinning that page.
> 
> Right.  This seems to be a separate bug..  It should be triggered in
> totally different context and much harder due to rare use of RO pins,
> meanwhile used with userfault-wp.
> 
> If both of you agree, I can prepare a separate patch for this bug, and I'll
> better prepare a reproducer/selftest with it.
> 

I am OK with separate patches, and agree that the R/O pinning case is less
likely to happen.

Since this patch addresses the issue found by Muhammad,

Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
-- 
Mike Kravetz
