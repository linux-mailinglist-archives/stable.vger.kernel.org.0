Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 650EC6C3C51
	for <lists+stable@lfdr.de>; Tue, 21 Mar 2023 21:57:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbjCUU5n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Mar 2023 16:57:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjCUU5l (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Mar 2023 16:57:41 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47D7B56786;
        Tue, 21 Mar 2023 13:57:39 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32LGnGSx007501;
        Tue, 21 Mar 2023 20:57:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2022-7-12;
 bh=b/6YT4Y9TY9voR/fF25e2KlsGN0L/1L6LGtiy+LtmJo=;
 b=t/IF/IO57EH6FKDSB8pgoo9lpzXKxfL7j5kriRgfN1TU0WpOc4FAVAZ1xrewfms9NJl9
 RDT8GPzX2XkI4AMYmfHuIhaeOl3zJW3U8sB3ej+yrUh9vuwOLte7Gxx2Z8QaPvWgGibi
 FBd92GWwhn1WbdQ3YDah4G0SD8wbH6o84GQyEVtWJehiF9s68eeQA1d6VyO2fuap4bt5
 P7McZ9eAcmyWe+HTCj6HtCx6t89k/7Uf6lj5VcGwbcF4Z/MA50VwXg6iTW09UWXc/GDO
 6I4NqW/OXkfZ8xiHACdD8y5Vs91TyuEZrgihd0Drs8nnQSbtUD28Btye+kc2Bt7T/dG0 rg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pd3qdqc2w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Mar 2023 20:57:26 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32LKriJM029748;
        Tue, 21 Mar 2023 20:57:25 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2047.outbound.protection.outlook.com [104.47.56.47])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3pfm130448-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Mar 2023 20:57:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oZHMxKHq/trV2dvc6JFUemvOvldj5vG8u0yoAZlmgpMIK3LshOX9/aprBnXItVeIhUoUuni/6rDSuxZVOtXIcQhOq8Yr5K5dmfhmrUjsSv2HgIrJ0E9J0Jp+3fMhdt3sL6CvL2WDFeWULsR1152PkU0bKLe5IaLYEoiywv/sFxIPfUg6g9TibyBAxhA3YECkmaIm1bNyH1B4nMXvWyepPRUbNK2j7uzSa2i8Ku+ycTw6SL8B1yGwx2PDyD5SVl6dLrWW7odUrDaJ0haCf/8HytjF3Ee/0zVIxh1b6E7bg5TJb80LbHs6wxYyxn9fg40wAUuDPNjLLAK1K9mDROvDTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b/6YT4Y9TY9voR/fF25e2KlsGN0L/1L6LGtiy+LtmJo=;
 b=nqTCueAHF0Aaou2BSDbj1Q3FPRNFaMJtuHytQ35tj8xsOBDBEcE/e+K8eUZSMV78ykIPr8O0fFNhRo3+X60943fRtOZ8yqGsERSh0mwS3aCiOIQEuT/N7yigGN/+QneeVZBNYYk/x9e6w6yPZ0y4iK1xJ1dD2972vm5e77oGcXseNR515JYqzpRR9ojAvdFnt2y+pSUj5u76zlXpTh5trb8QjxnZqO2dJhNeFtHr9khc1B4ivUTcoJrA3jonc3f7GDWlBee0o1RP3Slh1N7Zklj4JkQ76B8201e1ZrOHjFRIsLl/UuEJQQRdatIzw3QQ1sB5YiIRUfksqs9xl1Qjtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b/6YT4Y9TY9voR/fF25e2KlsGN0L/1L6LGtiy+LtmJo=;
 b=LpUGelejWzjnfy6rudvrQJBSNytlDRpXNg4VJmLk/KAeUZiggnVD9TpuQCC5TFpZQsTAyMXyLSM/qNFZyNQ+2C4wHCulmfvr0i/rY1AjmkIbR7p/DcQSPYGVkiYA/mmSbXUcFVung10KACAKgNMWn468HDMVBeo7WWAs2YKeNWI=
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by PH8PR10MB6646.namprd10.prod.outlook.com (2603:10b6:510:222::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Tue, 21 Mar
 2023 20:57:22 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::3db5:6e11:9aca:708a]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::3db5:6e11:9aca:708a%8]) with mapi id 15.20.6178.037; Tue, 21 Mar 2023
 20:57:22 +0000
Date:   Tue, 21 Mar 2023 13:57:19 -0700
From:   Mike Kravetz <mike.kravetz@oracle.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        David Hildenbrand <david@redhat.com>,
        Muhammad Usama Anjum <usama.anjum@collabora.com>,
        linux-stable <stable@vger.kernel.org>
Subject: Re: [PATCH] mm/hugetlb: Fix uffd wr-protection for CoW optimization
 path
Message-ID: <20230321205719.GA6030@monkey>
References: <20230321191840.1897940-1-peterx@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230321191840.1897940-1-peterx@redhat.com>
X-ClientProxiedBy: MW4PR04CA0297.namprd04.prod.outlook.com
 (2603:10b6:303:89::32) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4196:EE_|PH8PR10MB6646:EE_
X-MS-Office365-Filtering-Correlation-Id: 49416313-4805-4bdd-ae39-08db2a4edde7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n5kVFltkJyC+XIL2PcXJnk9J08uf+hfhi9HWM7ZZNFThLIZIO78mvGTrrE+dV2jQFtg4qIxBD6Iyr9otkdbPqOuHzoPAxjInyjNLQIqsdhPGolfHLrhc+/2Ho2NlB4Joear62YYUajWxtlx8PJcANlxecjQfYFK7CoybJ9TywcUujvUuLyqMaVmaCM7LiOhVkFCJKcFULVS90jSBgGx0eEmHnKkFMC4Pij4rXfP50ZqWGtcfBdJBzPYZ3D9vcId1KvXpcsRkLkbJE1OOFbvDjYktA9w7kvS7SnmRXMjERDr+38GQpRYSr+UARfCVel0enRHzAwnxll21nl/KqpPCQm9k1zPvfFXHkQ1QLgijp5DhZkNwipZ9NcvQ2TxYuqSiK6k4ayYZOm44s1OEnzG/djjXtT18vENSjq2ouFZ34hskB47/2rTbF6vXNuicTwzkXJN4Z6ZxjkHkKuWh1Bg/D9jMMdoUhMOdKKgU4nUp4dKYwdO1Htqbh7VDRyKK3r5STavoWHIotxOX7nlMZ5yMtMNjDQLeBS0DB/oTKcDeQ00wQmdAXxyu3ieCYn2v1gasK8Msk4xz4Jmcfe6MGcwkSPAouTnTSwh7zV7EfeYnJbsjfbzEpE/mudzONcUz66YpxMBi9HpaKcPdZFhlhECMjQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(136003)(39860400002)(346002)(376002)(366004)(396003)(451199018)(6486002)(186003)(4326008)(6666004)(478600001)(83380400001)(316002)(66476007)(6916009)(66556008)(9686003)(66946007)(8676002)(26005)(53546011)(6506007)(1076003)(54906003)(41300700001)(6512007)(7416002)(8936002)(44832011)(5660300002)(38100700002)(2906002)(86362001)(33716001)(33656002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zZ97mURsFvWaFQ4Fmop9Pf8F/BRXa1R6/OICb8JHLsSHJp8/uLuGiYcC0uV0?=
 =?us-ascii?Q?RSr90xwVk+Ih2qFIZgX6FdtsarJ50pjCZosG+MDvNRrdeTZYhKaMOJ+Bxn3H?=
 =?us-ascii?Q?3Mil8gGEqAreDkE1pZFPwSu2s4EY9HPM2OiJaI5bD+dZxnLJrQ9Tkx9MePlu?=
 =?us-ascii?Q?Zpl3wp9E0GF3L+2fG/WOEI9qbryer6PJgjv9JdhCDiL6GSfcGI3xDAsEFhpW?=
 =?us-ascii?Q?wjthlTtb8DOi8BfV92AtEG8T4oTMcMc5JLqPrYtsxwDulyzVVxSgXi6+Q3MB?=
 =?us-ascii?Q?rYr7QUKj8lyZ/u2EpCEh8Pxrwa1m4rAQCMeRoppU2XRMvL3QHCfIzAmLWoBP?=
 =?us-ascii?Q?k1VIYy/BSZlACkb53m1Py7J6OWcesua/wUGZltZPBW1ACE5XWIzccXJ6/rCM?=
 =?us-ascii?Q?0krQll/UEfWRCDivVQ7h1CugXHV47ygUDAQd1xMwwTJ/8cHrzGINKGcyyQ5y?=
 =?us-ascii?Q?eShjDA9lCDVWicryIw2p0R64GI5J+1kBAiphYWF1ynU2KnGGOnMa87wkL9lt?=
 =?us-ascii?Q?mX1NowFv4Wp4ZWUKDSs63hY55sGLSJ+TelJh5J6Ja79NtW89L4T7gYl1DqK8?=
 =?us-ascii?Q?JX18RrBx9SDaIDU4pCXf/zgyVwlXXt53/i21RPJ9Zlg0k5PkozmvnN3q+WvU?=
 =?us-ascii?Q?MGbM0XIrd0t/0BA3sWrK597HiyGKeiInieELbFmLrirfGUzq0E2auQ/6U4mo?=
 =?us-ascii?Q?TgurPn9xvWFOtOzzlczIVeKlHoYS4GVANE1zl6OtADTRTo7W1mr0W4mP+YT5?=
 =?us-ascii?Q?FFue07zHoKarT8Ho1A+lxYkHVdnByzwKmUj/uKPozwtqucttVZdlEJp65p3T?=
 =?us-ascii?Q?67qaEHCx86P5BiUJQHjZu4wvDyFkvvuVS11cjFW0umrebDup6VgD57nUsH7a?=
 =?us-ascii?Q?dYBwAMuIACX4WWhoH0iQuvuSJNzc7IRBY+ZvFYSozeRZviWkn12NiNQNYSrE?=
 =?us-ascii?Q?0NsHluSN/Riaqb9w88HxZTLFyTUH2JyNJdEpY2xi6zUOrSE63z2y9KAnV7SH?=
 =?us-ascii?Q?nxscOA2eqLUTIzzM0+OcFxgFXsHOunTitBmLc1iKdsK/okz4EFqbEdJNQSBp?=
 =?us-ascii?Q?q5ST1TuMITgMWxl7dyxgAwI0i/pk1TF5z0RvO2nzHu3NQ/z3fEao3piW7wN2?=
 =?us-ascii?Q?gmZOci8PWLLEMLjVO/U5FrFBMJ/jZLz2bZ01H+E897noNydxDwai3pOhl5kx?=
 =?us-ascii?Q?iSau7Y6n3BSNXQikdPMoxefuvZPlTOXSDj90XAYEriU+ZigMQs7WEcLsebtu?=
 =?us-ascii?Q?VBumdr0SE4MsY8vgHzK6L/iO6Q76UCXyPLqAZKYjPdjuQnQ29ToCvhYKdTTC?=
 =?us-ascii?Q?pnz95uICNb6gdrGdHMz7dHV0DJBKqrAeC/sb0VJ8z8mZQO14ewkmb5rEFtnz?=
 =?us-ascii?Q?bJBD15BMVukM7ZnEu5d0Ftgov85/GabbIPbJe0sIy8rNIMicqZT9V/dGAdte?=
 =?us-ascii?Q?E0JR31SvyByq8TnFH4OIzUu7FA1O3nDDT+sSxOGBI3BtpvI5/if1cGIulsTk?=
 =?us-ascii?Q?UYQKQhVlA1P3sBatHbT/ixu1b107rv/sXMQeHjuauuvxnN34sLGmzSP1m0Or?=
 =?us-ascii?Q?gpXdqNe2hrd+/Ft6yJ9fg7jdWZJ3rVu/WriizfWcAEc4gYshcv9nfgbiRRtq?=
 =?us-ascii?Q?UA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?DxGHsb6r+O50cwwCARV6HmFISbqttATYQkivZhjATsWqWZxEdZDW3h/RARe8?=
 =?us-ascii?Q?eWRI6xhdSUyds+TR3tuMAdVDzpYSwZG/UTxBeewym/EZxD8qm/HgaTeVNLZA?=
 =?us-ascii?Q?k1iUY1hwzYBfFLu5YqGGURUjJwZBKwzqdnOad0uDGsvYuPFkpPVd/jlfkvuh?=
 =?us-ascii?Q?m1LI6lydpEwqMX55o27S7AyQLqDOFZs1I8dUE0pKCkv6cZ9kkWX3vdHvG9Wq?=
 =?us-ascii?Q?+RLlIxm6BIP0diXNxng9XfWrYPzPDzOF2fooJsNr8jW1dMU0PKil7inGLOHo?=
 =?us-ascii?Q?IyZWi9xjQMP37l7ZQEvz7W8DKaDZ4YHZCQiTXoPKc4Ldy+Sqmojsgin/8OH4?=
 =?us-ascii?Q?4CCMhJ2oWtYTy2ErqnK7dmsjdpeQ6ay/D8/fWqbdXKA/BWUjrNu8w9rhbEuy?=
 =?us-ascii?Q?PUgcGkW8rPyYC5Yo8um3RKU0LRAU8qA1XtFxoudUBqWRMtXesODxU6Ira+Xo?=
 =?us-ascii?Q?lA4XWtE5cfiwjk4JUVLMz5rCj4fOguJF1YQ1ZmdaqZsO5wUwFN5beG/FfRzI?=
 =?us-ascii?Q?iDSVPl5tlf+E+nvHOFKXbwUOux9rSWIqZ19Y/islbENFyXDk4geh+7pQDu7/?=
 =?us-ascii?Q?n0t7XYP8bOg1IZnzX1qOftXGaN2jS6c4LFbeEYa/B1S+A5YwgwZu9EYpaZE6?=
 =?us-ascii?Q?HeOLMtLpDsBraUgIB0BvbXt7bGxOryPOE09rUk+MVQurrj/fgInooT7uWzqa?=
 =?us-ascii?Q?vHH6UQrGBXsg54eLvdbAsXZ/XqrYUw9iqfb9kyPIJCIk05t0Beg/XkggZRht?=
 =?us-ascii?Q?Vk5/W1fwGGURSY1rrRX2x/GZFL/NFSzd+ELK1Mf1rqkSKmLRof2ccUpinjBO?=
 =?us-ascii?Q?4P1fJXHDOwFNk2Xyo/okBmllQmx0GCwHSBEMssetL1QhYRoJOwC+kFT3mLav?=
 =?us-ascii?Q?IcRgguks3tJ40udwXUpNzKotRXD6kiZxSj6Zoy6L506MvCeP+6SBcf+EtN+V?=
 =?us-ascii?Q?TFFWhXPZkmv//6+Ej+JysioHArvFhzo33SFCojBeUQi7K6u8GYi2+1K/ZUPX?=
 =?us-ascii?Q?OdDSw+esFO7fbxLf+G86yQ+HSA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49416313-4805-4bdd-ae39-08db2a4edde7
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2023 20:57:22.3695
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J5bqlw/ikmMypPFIKaGvT4C6z1c7w9xaJDgeCWAh5timloWdz3baBA6x39YLVW1BeTg1vBH/b076Uuv4t9GVlQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6646
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-21_11,2023-03-21_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 adultscore=0
 bulkscore=0 suspectscore=0 mlxlogscore=999 phishscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303150002
 definitions=main-2303210165
X-Proofpoint-GUID: dGSeGsYfgqtm-2ZhGlRC8154OtTzxZi4
X-Proofpoint-ORIG-GUID: dGSeGsYfgqtm-2ZhGlRC8154OtTzxZi4
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 03/21/23 15:18, Peter Xu wrote:

Thanks Peter!

> This patch fixes an issue that a hugetlb uffd-wr-protected mapping can be
> writable even with uffd-wp bit set.  It only happens with all these
> conditions met: (1) hugetlb memory (2) private mapping (3) original mapping
> was missing, then (4) being wr-protected (IOW, pte marker installed).  Then
               ^^^^
Nit, but is the word "then" intended to be there?  Almost makes it sound as
if wr-protected was a result of the previous 3 conditions being met.

> write to the page to trigger.
> 
> Userfaultfd-wp trap for hugetlb was implemented in hugetlb_fault() before
> even reaching hugetlb_wp() to avoid taking more locks that userfault won't
> need.  However there's one CoW optimization path for missing hugetlb page
> that can trigger hugetlb_wp() inside hugetlb_no_page(), that can bypass the
> userfaultfd-wp traps.
> 
> A few ways to resolve this:
> 
>   (1) Skip the CoW optimization for hugetlb private mapping, considering
>   that private mappings for hugetlb should be very rare, so it may not
>   really be helpful to major workloads.  The worst case is we only skip the
>   optimization if userfaultfd_wp(vma)==true, because uffd-wp needs another
>   fault anyway.
> 
>   (2) Move the userfaultfd-wp handling for hugetlb from hugetlb_fault()
>   into hugetlb_wp().  The major cons is there're a bunch of locks taken
>   when calling hugetlb_wp(), and that will make the changeset unnecessarily
>   complicated due to the lock operations.
> 
>   (3) Carry over uffd-wp bit in hugetlb_wp(), so it'll need to fault again
>   for uffd-wp privately mapped pages.
> 
> This patch chose option (3) which contains the minimum changeset (simplest
> for backport) and also make sure hugetlb_wp() itself will start to be
> always safe with uffd-wp ptes even if called elsewhere in the future.

I was going to suggest (1) as that would be the simplest.  But, since (3)
makes hugetlb_wp() safe for future callers, that is actually preferred.

> 
> This patch will be needed for v5.19+ hence copy stable.
> 
> Reported-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
> Cc: linux-stable <stable@vger.kernel.org>
> Fixes: 166f3ecc0daf ("mm/hugetlb: hook page faults for uffd write protection")
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>  mm/hugetlb.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 8bfd07f4c143..22337b191eae 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -5478,7 +5478,7 @@ static vm_fault_t hugetlb_wp(struct mm_struct *mm, struct vm_area_struct *vma,
>  		       struct folio *pagecache_folio, spinlock_t *ptl)
>  {
>  	const bool unshare = flags & FAULT_FLAG_UNSHARE;
> -	pte_t pte;
> +	pte_t pte, newpte;
>  	struct hstate *h = hstate_vma(vma);
>  	struct page *old_page;
>  	struct folio *new_folio;
> @@ -5622,8 +5622,10 @@ static vm_fault_t hugetlb_wp(struct mm_struct *mm, struct vm_area_struct *vma,
>  		mmu_notifier_invalidate_range(mm, range.start, range.end);
>  		page_remove_rmap(old_page, vma, true);
>  		hugepage_add_new_anon_rmap(new_folio, vma, haddr);
> -		set_huge_pte_at(mm, haddr, ptep,
> -				make_huge_pte(vma, &new_folio->page, !unshare));
> +		newpte = make_huge_pte(vma, &new_folio->page, !unshare);
> +		if (huge_pte_uffd_wp(pte))
> +			newpte = huge_pte_mkuffd_wp(newpte);
> +		set_huge_pte_at(mm, haddr, ptep, newpte);
>  		folio_set_hugetlb_migratable(new_folio);
>  		/* Make the old page be freed below */
>  		new_folio = page_folio(old_page);
> -- 
> 2.39.1
> 

Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>

-- 
Mike Kravetz
