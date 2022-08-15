Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1553594E46
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 03:54:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240321AbiHPBvE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 21:51:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241896AbiHPBue (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 21:50:34 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F0E8207591;
        Mon, 15 Aug 2022 14:43:43 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27FKxZ2W011788;
        Mon, 15 Aug 2022 21:43:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2022-7-12;
 bh=gH7rGO/F4yW6nP0Km2gSr3YnoAEzdb4tpYA6NGLFZuI=;
 b=xMQ3PCrQ5Cnhi0dqPjT3Gx0FbeBdOm39hB10B1Kb4HOvf2BF0vF7wADrUcHY/Bj71Rg0
 b+gASylW6EO77QuFVajyywiuu/1QtlJn5EzBz5P5tQFsu7uQCSut66khXV17RpHMg2xN
 VjQqm97NUQ1FLKeL1dJ1kXN2drrMyoxDwQzjE2/7oh4t7ZzUE0ltYrL8YjjKRlgFSxEY
 3aCTw+vny+lo2bh1CwHqU4QU3R62JC4a/BQ5QOug4+mWmC0ybuLpIAWZdDlDqMJTuShh
 VdvAIg9b3HgUVVSr2Y4w0ysDuUIPNPW3+c/iVxOjXrNqJaOTz+RTS1AE9ayGIETTzc4N ow== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hx4gt44gf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Aug 2022 21:43:22 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27FIo8QV034892;
        Mon, 15 Aug 2022 21:43:21 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2175.outbound.protection.outlook.com [104.47.73.175])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3hx2d7sp0g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Aug 2022 21:43:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DnLNsnQSADIbaHJ77BcMg8/gWoc1tfVIzg5K1XRhe1eF1n2oBz3nc52cWYqnzXtmgUNCZP2EbqQHpHdI3TC2OYZ4AdBbzo2Dct8o0G0P5ewxaFltPwFa2QeJnphk39Snc5n6nm2Y1S7z6aIvwQKZk7aUJ02/+W287+iYAGvY5ms/J9IwjK4pBObPXfpHp533h8Txw7mQ0EookhyAPeLOxJIGsMQvlYKiWBlY8bwTph+5lI1Nze7FZpNU6sb/Tal9APIu3WQnYyxRWPXY/O1JtuobW6EtHx8rV/cmiDgRP2Txd/4QruhrVOf2yG+yQSHP0tNLfTV96LAqalfCVQmmgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gH7rGO/F4yW6nP0Km2gSr3YnoAEzdb4tpYA6NGLFZuI=;
 b=XeWU0Ope5eKW9UUXNoxxz28bfGiYl70hQ65O3Xr8Rl1A9t0oDMGz5GMt5GmG/wRMh3YbyyipvzFTrQOGtY+ihNyxCus00sDPQVNVW/+vntPgI57AnCOo7beJzOu7Hamuxpd4p0FX9f/SoJPZogiZYAy7LgWKg362m2ABZgZeC5n3R20347C3vgY0pCCZzaCT8QqgDPGxAaudpd+J5xOd83v+bQ50xD1pngdzclo6lBi18qvWnAWCx8awzlKZVt76Tp6pSxNW4CaEFTooXZRawhb4SClLZ7gEz/UYe1mG+qYOUQS0Cj0+oaTyYIeA/OJSs8QQxwE4WQSY8XpYNclf8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gH7rGO/F4yW6nP0Km2gSr3YnoAEzdb4tpYA6NGLFZuI=;
 b=RIfmDcTwrEKbs2JRO8AmGg3zWcZuSPIqNrvobVKrxy1GhYp9MolVG+ppmRYFagKc34XdjFPfeShRJaZedYkxhiXpg/R5Uf+R4O0459LNQ7ogjEuYzrGybJxb3iNvBZzNjItrBan01Th8tfD5KnZiTcOSILz06h5bu1mB6Nxc1/Y=
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by PH7PR10MB6034.namprd10.prod.outlook.com (2603:10b6:510:1fe::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.20; Mon, 15 Aug
 2022 21:43:19 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::c1ba:c197:f81f:ec0]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::c1ba:c197:f81f:ec0%5]) with mapi id 15.20.5504.028; Mon, 15 Aug 2022
 21:43:19 +0000
Date:   Mon, 15 Aug 2022 14:43:16 -0700
From:   Mike Kravetz <mike.kravetz@oracle.com>
To:     Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>, stable <stable@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] mm/hugetlb: support write-faults in shared
 mappings
Message-ID: <Yvq99MmpaGJBhlt4@monkey>
References: <20220811103435.188481-1-david@redhat.com>
 <20220811103435.188481-3-david@redhat.com>
 <YvVRfSYsPOraTo6o@monkey>
 <20220815153549.0288a9c6@thinkpad>
 <CADFyXm7-0zXDG+ZHjft95aAAiSZh_RyAqgJw1nGsALwEL1XKiw@mail.gmail.com>
 <20220815175929.303774fd@thinkpad>
 <CADFyXm40iiz-xFpLK4qGgHGh5Qp+98G9qxnqC20c8qtRiKt9_A@mail.gmail.com>
 <20220815203844.43b74fd1@thinkpad>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220815203844.43b74fd1@thinkpad>
X-ClientProxiedBy: BYAPR11CA0086.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::27) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 500921ff-3c4c-4803-fbfe-08da7f072ade
X-MS-TrafficTypeDiagnostic: PH7PR10MB6034:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jGZGoiTNYcAs5fVT3HFg1HJ7P34feJ0jUSMk+5a5A+8Vr0D5i1x8h5oKwZ4RMo94aNpKhcgG9fnBl/azYOrBvBE8p1FKdZ3yZFVds1pOoPscuYAmBrfp1jtzgBE+PHlGPMqWNnj8GOARJINo/QSCM9ObLnNfi1nXiwx0ihuvzJ4WFhMxfYXx+Ouz3pXnARTMwIHH+BA3q+3X852/f6HPhVXYk1ezNF1kIbCsPEoP+P5N5SoLvH86x5+bZxE7zfucdMdJ3FVcdgO2Kd3eVR/3ynHViTTXf6kn7sL4KzwjgdMh/pQ4EsxhGgHp/BS62d8uu+akGyZQZi6dDKPMzmOloJ8vsjPfZLBmicX9mtHgwuMxSIuwEfSfoOuh4FQJFTRy6PuTG2S/HHUAJ/Qg2nMaqkHqvTxkOJglav8l3Psp++m/VagGgUiW6w4X//sOZ/fNLAmPPKBCcttdPRV7prd1/IqtV6W+7WkyQ2a0PhZm6e8yS24CvQFB83BJJfAwyCHOD5TWGirS3cBpE/CDrpaSy+s+ZnleKZsq2EqDXyaOtqlamSJ9rpysp/VkYJbW0N8H/fY4kkdpcNKV1GaPVVdmhO0mdQH/y4gYt9Ohzw/e21tCepsP8Yfl9LEzArOGYsmE1LswHHj3hLO0jIQAH8D+K0EX28HMi2yjNadwdTjjQorQfjsZIqBrkQMIRXhVE+xpQWMtT/yGdnFkZKLWEXKgqoIBonelfFvIM16QVnIAup8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(346002)(39860400002)(366004)(376002)(396003)(136003)(6486002)(2906002)(4326008)(478600001)(8676002)(66946007)(5660300002)(66476007)(44832011)(38100700002)(8936002)(6506007)(33716001)(9686003)(86362001)(6666004)(53546011)(186003)(66556008)(45080400002)(41300700001)(54906003)(26005)(6512007)(316002)(83380400001)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uuHz94gdd+/DUJgcQOVgk5zYtkcPHEwcRgSp4ng2gh5JihrTL/2yzJRfTThR?=
 =?us-ascii?Q?w+OyyWmpa5rzHfIhO04FNVy1CLUmqPkwo0nCQ3/Gurn1zXSURlc/WFyXAKgc?=
 =?us-ascii?Q?hU2+Je0I0Ll9MbSXJVPdVYptFACqWrjBshOF9U8lFi7Br8LzsXWs0nMGQwxT?=
 =?us-ascii?Q?XmofUIItbZIvQ9lHGUA1eY/QKIR6/CyJt9g6Io42FOLVa/3PiMPWigsotDzO?=
 =?us-ascii?Q?muy+db+d+mn+MpYpYJ7/KurKTtvV7zGtbixrChwxE+8PKobaflCBuQaDgjjl?=
 =?us-ascii?Q?R/6ZotJRiW66rtx1TdjWPweQXVt1Od2XOY5WROCy0tx+gt1Iowvp29I1wEAA?=
 =?us-ascii?Q?ugfDiGsEx1O+VMEACqwRutDPCAQKS0qTvuz5+A1HKm7S13q3Ico5197+5JsS?=
 =?us-ascii?Q?p2QPXUu6+19nk+QYjN3QTQ/hwj0LJvR82OW5yjvT56Si357550PK5TKmCatN?=
 =?us-ascii?Q?1GKKEcJ1uUaBid2s6wyxZ0SH8w8JPEYEna4vaP5Jt/9+vIaNGDhCkbmGszdV?=
 =?us-ascii?Q?9pyvOlULCqA6mvijTULNqfVJjmzJZDy/lsaf9KsBv2QYkHn9J62ebIcKlDec?=
 =?us-ascii?Q?3JTVd4AJYPxAqf1shLZICMNskcC6IPHa+zuHQISrx6jUL2kln59hF5OQG+hT?=
 =?us-ascii?Q?LIUn2p6l+5EosNl6zbMlxTrpAHRMBGIbFgn5fexAEjRFDmFN9+ZYEi/VQvd6?=
 =?us-ascii?Q?kGC0HrIxVHNdRVogUsEc03PKd6WHFkLPQZyG4MS0e+8A7NVc24FAQ17mZBbt?=
 =?us-ascii?Q?k8MarEOSJy+f9dZ4lJAx8wVlDFiU3dvm2C1zUr6YJrP8f0xcFWuN+onRzC8v?=
 =?us-ascii?Q?vXxexwCDvj78+88kqAjCyS2sLgEluRN++iqUs09qVFT8o3EwPwpewjOB34sY?=
 =?us-ascii?Q?xOLgbHwmknac/IWrS2eBh9Zz7NdiiIa2r0rMyQVt598lH2B3OA64pGyrxe7F?=
 =?us-ascii?Q?mh0WJ5qDhtX+sSO6ubqTgdGm9RT2zMyuoiXdOXGPvsUWpE4zucJgkxLkXhU7?=
 =?us-ascii?Q?NaFcsCcHFA8KX4NTtfeFim5e4nxUYJWSn9CIh/S6wP2ofFi0Lyjy8VLtbjT8?=
 =?us-ascii?Q?1aWaVMxHqEE8ELm/uSoXhkei+zBx4U+2qg8a9SvVt5m3uvSNWMEQcuPON7nD?=
 =?us-ascii?Q?6Fr3W3g+38ucuRCGbHRUHX750G997wQ9DsmasXzAQ31F+dfrD6NO5Rk77Npe?=
 =?us-ascii?Q?wGjAd4CUqE5ubin/Z/dqg4qOLvFtmsExa3i5NVlyWEehCsbBRQa7C2DT2xiZ?=
 =?us-ascii?Q?zKJMrAfjAGBnnnhdkizMKml2by4kdfHofFsDE3CCz/EUHinHfazlXN7syhxk?=
 =?us-ascii?Q?55xyZn5QWyqR837xWv+9yybM4dxynr/JzQtFSHbw7CYQF1nX+zx1IlEwv7L6?=
 =?us-ascii?Q?aEPgqzR1OfoPMJEIvCAmpx9c+TSz+0JEUeUd21rBfr/bOJys0RhPRByKD74f?=
 =?us-ascii?Q?ORgIDB3b2wVPAPq0XOYQdmagAj4+VaUbgaPNNhctfHchc//YY0zxSo3TkGLX?=
 =?us-ascii?Q?1U9GG2WNWju1rgBxCkaBAaop+xxSq3ss7AJy/OUfm9et629D/uXlNjeZgEcr?=
 =?us-ascii?Q?hWFpBZwZshBfgJcWvH53JmpNTAp1v/MlVzqnmgCC0c9HHQZwczEkxmbH37E2?=
 =?us-ascii?Q?gw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 500921ff-3c4c-4803-fbfe-08da7f072ade
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2022 21:43:19.0946
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ouw6WPQtFE29AdVzWyvgIlykG43owObbiRq80o9xQYEsAf62k1xzm23XyyHR7che7yuC/GAhwkeIAx99lVqSvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6034
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-15_08,2022-08-15_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0
 malwarescore=0 phishscore=0 bulkscore=0 spamscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208150083
X-Proofpoint-GUID: T6jaZf7pC3VGuYc_6V37yVH0edUPQBuB
X-Proofpoint-ORIG-GUID: T6jaZf7pC3VGuYc_6V37yVH0edUPQBuB
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 08/15/22 20:38, Gerald Schaefer wrote:
> On Mon, 15 Aug 2022 20:03:20 +0200
> David Hildenbrand <david@redhat.com> wrote:
> > On Mon, Aug 15, 2022 at 5:59 PM Gerald Schaefer
> > <gerald.schaefer@linux.ibm.com> wrote:
> > > On Mon, 15 Aug 2022 17:07:32 +0200
> > > David Hildenbrand <david@redhat.com> wrote:
> > > > On Mon, Aug 15, 2022 at 3:36 PM Gerald Schaefer
> > > > <gerald.schaefer@linux.ibm.com> wrote:
> > > > > On Thu, 11 Aug 2022 11:59:09 -0700
> > > > > Mike Kravetz <mike.kravetz@oracle.com> wrote:
> > > > >
> > > Sure, forgot to send it with initial reply...
> > >
> > > [   82.574749] ------------[ cut here ]------------
> > > [   82.574751] WARNING: CPU: 9 PID: 1674 at mm/hugetlb.c:5264 hugetlb_wp+0x3be/0x818
> > > [   82.574759] Modules linked in: nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 ip_set nf_tables nfnetlink sunrpc uvdevice s390_trng vfio_ccw mdev vfio_iommu_type1 eadm_sch vfio zcrypt_cex4 sch_fq_codel configfs ghash_s390 prng chacha_s390 libchacha aes_s390 des_s390 libdes sha3_512_s390 sha3_256_s390 sha512_s390 sha256_s390 sha1_s390 sha_common pkey zcrypt rng_core autofs4
> > > [   82.574785] CPU: 9 PID: 1674 Comm: linkhuge_rw Kdump: loaded Not tainted 5.19.0-next-20220815 #36
> > > [   82.574787] Hardware name: IBM 3931 A01 704 (LPAR)
> > > [   82.574788] Krnl PSW : 0704c00180000000 00000006c9d4bc6a (hugetlb_wp+0x3c2/0x818)
> > > [   82.574791]            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:0 PM:0 RI:0 EA:3
> > > [   82.574794] Krnl GPRS: 000000000227c000 0000000008640071 0000000000000000 0000000001200000
> > > [   82.574796]            0000000001200000 00000000b5a98090 0000000000000255 00000000adb2c898
> > > [   82.574797]            0000000000000000 00000000adb2c898 0000000001200000 00000000b5a98090
> > > [   82.574799]            000000008c408000 0000000092fd7300 000003800339bc10 000003800339baf8
> > > [   82.574803] Krnl Code: 00000006c9d4bc5c: f160000407fe        mvo     4(7,%r0),2046(1,%r0)
> > >            00000006c9d4bc62: 47000700           bc      0,1792
> > >           #00000006c9d4bc66: af000000           mc      0,0
> > >           >00000006c9d4bc6a: a7a80040           lhi     %r10,64
> > >            00000006c9d4bc6e: b916002a           llgfr   %r2,%r10
> > >            00000006c9d4bc72: eb6ff1600004       lmg     %r6,%r15,352(%r15)
> > >            00000006c9d4bc78: 07fe               bcr     15,%r14
> > >            00000006c9d4bc7a: 47000700           bc      0,1792
> > > [   82.574814] Call Trace:
> > > [   82.574842]  [<00000006c9d4bc6a>] hugetlb_wp+0x3c2/0x818
> > > [   82.574846]  [<00000006c9d4c62e>] hugetlb_no_page+0x56e/0x5a8
> > > [   82.574848]  [<00000006c9d4cac2>] hugetlb_fault+0x45a/0x590
> > > [   82.574850]  [<00000006c9d06d4a>] handle_mm_fault+0x182/0x220
> > > [   82.574855]  [<00000006c9a9d70e>] do_exception+0x19e/0x470
> > > [   82.574858]  [<00000006c9a9dff2>] do_dat_exception+0x2a/0x50
> > > [   82.574861]  [<00000006ca668a18>] __do_pgm_check+0xf0/0x1b0
> > > [   82.574866]  [<00000006ca677b3c>] pgm_check_handler+0x11c/0x170
> > > [   82.574870] Last Breaking-Event-Address:
> > > [   82.574871]  [<00000006c9d4b926>] hugetlb_wp+0x7e/0x818
> > > [   82.574873] Kernel panic - not syncing: panic_on_warn set ...
> > > [   82.574875] CPU: 9 PID: 1674 Comm: linkhuge_rw Kdump: loaded Not tainted 5.19.0-next-20220815 #36
> > > [   82.574877] Hardware name: IBM 3931 A01 704 (LPAR)
> > > [   82.574878] Call Trace:
> > > [   82.574879]  [<00000006ca664f22>] dump_stack_lvl+0x62/0x80
> > > [   82.574881]  [<00000006ca657af8>] panic+0x118/0x300
> > > [   82.574884]  [<00000006c9ac3da6>] __warn+0xb6/0x160
> > > [   82.574887]  [<00000006ca29b1ea>] report_bug+0xba/0x140
> > > [   82.574890]  [<00000006c9a75194>] monitor_event_exception+0x44/0x80
> > > [   82.574892]  [<00000006ca668a18>] __do_pgm_check+0xf0/0x1b0
> > > [   82.574894]  [<00000006ca677b3c>] pgm_check_handler+0x11c/0x170
> > > [   82.574897]  [<00000006c9d4bc6a>] hugetlb_wp+0x3c2/0x818
> > > [   82.574899]  [<00000006c9d4c62e>] hugetlb_no_page+0x56e/0x5a8
> > > [   82.574901]  [<00000006c9d4cac2>] hugetlb_fault+0x45a/0x590
> > > [   82.574903]  [<00000006c9d06d4a>] handle_mm_fault+0x182/0x220
> > > [   82.574906]  [<00000006c9a9d70e>] do_exception+0x19e/0x470
> > > [   82.574907]  [<00000006c9a9dff2>] do_dat_exception+0x2a/0x50
> > > [   82.574909]  [<00000006ca668a18>] __do_pgm_check+0xf0/0x1b0
> > > [   82.574912]  [<00000006ca677b3c>] pgm_check_handler+0x11c/0x170
> > 
> > 
> > do_dat_exception() sets
> >   access = VM_ACCESS_FLAGS;
> > 
> > do_exception() sets
> >   is_write = (trans_exc_code & store_indication) == 0x400;
> > 
> > and FAULT_FLAG_WRITE
> >    if (access == VM_WRITE || is_write)
> >           flags |= FAULT_FLAG_WRITE;
> > 
> > however, for VMA permission checks it only checks
> >   if (unlikely(!(vma->vm_flags & access)))
> >           goto out_up;
> > 
> > as VM_ACCESS_FLAGS includes VM_WRITE | VM_READ ...
> > 
> > We end up triggering a write fault (FAULT_FLAG_WRITE), even though the
> > VMA does not allow for writes.
> > 
> > I assume that's what happens and that it's a bug in s390x code.
> > 
> 
> Hmm, that looks weird, but that doesn't mean it has to be broken.
> We are talking about a pte_none() fault, not a protection exception
> (do_dat_exception vs. do_protection_exception). Not sure if we get
> any proper store indication in that case, but yes, this looks weird,
> will have a closer look. Thanks for pointing out!
> 
> FWIW, meanwhile, I added a check to hugetlb_wp() in v5.19, for
> (!unshare && !(vma->vm_flags & VM_WRITE)). This did not trigger,
> however, it did trigger already before your commit. So something
> already changed before your commit, and after v5.19.
> 
> Further bisecting showed that the check started to trigger
> after commit bcd51a3c679d ("hugetlb: lazy page table copies in fork()"),
> and after that the "HUGETLB_ELFMAP=R linkhuge_rw" testcase also
> started segfaulting (not sure why we did not notice earlier...).
> 
> Anyway, I guess this means that your commit only made that change
> in behavior more obvious, by adding the WARN_ON_ONCE, but it really
> was introduced by that other commit.
> 
> Not sure if this gives any more insight to anyone, still confused
> by your comments on do_exception(), which also sound like a possible
> root cause for ending up in hugetlb_wp() w/o VM_WRITE (but why only
> after commit bcd51a3c679d?).

I know it doesn't mean much, but I did not/do not see these issues on x86.

bcd51a3c679d eliminates the copying of page tables at fork for non-anon
hugetlb vmas.  So, in these tests you would likely see more pte_none()
faults.

I'm trying to figure out exactly what this test is doing.  From a quick
look it is doing a fork/write fault to determine if addresses are writable.
Guessing that such faults are triggering the warning.  Will look at this
some more to try and gain more insight.
-- 
Mike Kravetz
