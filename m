Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A31B96C886D
	for <lists+stable@lfdr.de>; Fri, 24 Mar 2023 23:34:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232263AbjCXWed (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Mar 2023 18:34:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229957AbjCXWec (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Mar 2023 18:34:32 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85FA77681;
        Fri, 24 Mar 2023 15:34:09 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32OM528F025270;
        Fri, 24 Mar 2023 22:33:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2022-7-12;
 bh=iWUTsNYGtIMS4uIxqhYE01cB82KoNP4O4Rs8DAtzsEw=;
 b=NQEdstFtkd1SKsaUe/paCdT0Z4TtkzWaHSSe6nZrN5OO5GMR88AvRcctjS7yii+uxWtA
 2ijGio1cv2UoNGWkMdxgGe+4SNjZ6vCrgaCiCscXm0ojMEsrSiGzje2Fc1Rw9/Z628MJ
 JTAj4u144YWHvGrW6KOkQKbHZaTheAT7orZ7iDiAwi8NPErjFUyj5zEFajpOgADnsUA1
 Sx9M6TS+ZUuLiMW3yXOpe9JQIJS7nUaBlyCIIEemCkHs8VjCKqkiqS8M1UXwhAmlXSKs
 E8J2Sj0WyMyiZkf00LQ3qJspRv3Jr+WysVWQsCkkoZY8XHpitR1VxqQTXdR6P/FYOHrE Hw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3phmbcr1a1-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Mar 2023 22:33:06 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32OKtI0L001381;
        Fri, 24 Mar 2023 22:27:16 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3pgxk4k036-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Mar 2023 22:27:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=awWupuheFPcc8uhWP9fHJoQkAgoZM5Cf5YBm1qAs9CLoDBKb3x0qTBBruDaeTmIZUG1a6lOG0gFxfHIaUKW02tr1sDltp0TIQ+sfKdDDGW394hKWkFfIIXvMu5TmnDXMBB4wdN8Aflm0oVV8XWMMUBPL7p1vZzSvAszQ3SXT/TKPMYkxa3Ni7pcqQAALIuWkg7bre9+p1IPrUCcf1BdqhpWUasqSToH+jrHTZaNTDe2Kt3EBi6LsxhE9nzyahnat6fozNpAG3BQtfuhsWA1v2vYyYlxmcYu4I+a+PLpCuQXME22hEfn5/kVfRYWJcoGksiIveoqrJu6QOEOH/pnt0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iWUTsNYGtIMS4uIxqhYE01cB82KoNP4O4Rs8DAtzsEw=;
 b=O0EO/W+IeRYt/vlCDBsO/8Q0A7EQw24Ldb04Oq2Qw+vhgmsZLdtEWWi6nQNUcgPaoW4MZF6ho3keuRHG9LCG7GMuwRxyXZ3J+hoH4hJ8ReYpJvijruXREtXO7Zk8cX+pWq+f+peSmnZGK4M3WqDumBkjcsd76JJNZnluTrM8KLjZchhLifHcL/ewGQL4si5fTOM20Oc74BZwIPNOEcsIN8Bes7EUL5kt5JQvj6HipbRMYDiYR3vsKOFSsn9ENNQTXdHgZ1Mz2yXZAYmi9W/tbuOPsKxs2/czc0m1McHn8Rfot9+VCWZGTF5mbsJQvml6lbE1dRV+yQU5gPSPW4RPaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iWUTsNYGtIMS4uIxqhYE01cB82KoNP4O4Rs8DAtzsEw=;
 b=f0NR1xLOxCcQSWFiMiGlcrhgTDwmEGoMC9y4L0M/Z+kTJsAqH1li8dw0kJRgpFD7uw+08ZNpBSG/em00j53rTZpv00PqoGrhv2aTdjXpgzkOSlKW5y6QvUZ1832ZnmMhWWvFOLrzChtxi5ZsPyyoz0+ufAUuUpZk/ZCwYRZO7K8=
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by BL3PR10MB6138.namprd10.prod.outlook.com (2603:10b6:208:3b9::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.28; Fri, 24 Mar
 2023 22:27:12 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::3db5:6e11:9aca:708a]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::3db5:6e11:9aca:708a%9]) with mapi id 15.20.6178.038; Fri, 24 Mar 2023
 22:27:11 +0000
Date:   Fri, 24 Mar 2023 15:27:07 -0700
From:   Mike Kravetz <mike.kravetz@oracle.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        David Hildenbrand <david@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Muhammad Usama Anjum <usama.anjum@collabora.com>,
        linux-stable <stable@vger.kernel.org>
Subject: Re: [PATCH v3] mm/hugetlb: Fix uffd wr-protection for CoW
 optimization path
Message-ID: <20230324222707.GA3046@monkey>
References: <20230324142620.2344140-1-peterx@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230324142620.2344140-1-peterx@redhat.com>
X-ClientProxiedBy: MWH0EPF00056D12.namprd21.prod.outlook.com
 (2603:10b6:30f:fff2:0:1:0:15) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4196:EE_|BL3PR10MB6138:EE_
X-MS-Office365-Filtering-Correlation-Id: 85f0cf68-2fcf-4fe7-c82f-08db2cb6e914
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hCD4ED4BYoJbiUwBMu5wLN8VgxPTdbTgE3z2DREIXMqsPMzXALPpt+cR7MVAyHVdZXXUkOYKvtVdJn1fAA+WJMPoEK44mFTaolq0kPxet0myaM5D/ebyENgCO+wxHKQXOWnRYCyfXg5fopUu4WiSMC/mSrxmRC+Zv4ZRRp7SeCPeaTpfyminJBKqkmamnlToGYnePUO+VtNn0CQUafS3oBYxFYK6D9Wsaz5/L4B1RkcwmM4G4OlN3BTOcaHants4zlc4WNrQ9vnskXo6A+K8tNxUT0rIoeFgmKcqQqyMRcs6Ll9XTyuD3U+JdJeGvbpVY1dh3M0/sqiuEkAb3E+4mkbICRRYXqKiPGTl+aADNQofHV5wnBjQnuSb1Oo/JIQDyJKje2IbXnjbgN/wfYPeJ+qzigKWVbTN6Veo7+JT9DQZYdcFa/5Diu7qcd56xsi6FJCMO3HxLhuU7ODdV/UcaBuPA+SRNjrwfo/jsLACgen/33TwKTe5cm6jsH1pwPb0/WF37n0wKMoyuD9a3hoflNPyW2/YOddUWhqplaWPVWu+AsWr/B1q1Z0y5nlkZXhf
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(136003)(396003)(39860400002)(376002)(346002)(366004)(451199021)(6666004)(1076003)(83380400001)(53546011)(8936002)(38100700002)(316002)(6916009)(6512007)(54906003)(4326008)(186003)(66476007)(478600001)(86362001)(66556008)(66946007)(8676002)(41300700001)(6486002)(5660300002)(33656002)(9686003)(33716001)(26005)(2906002)(7416002)(44832011)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nh2o1lWtAjzeBheLb9ielnM4PWtpjGS+cozyuSdCb89tu+PCm4TQ0MZ6Ry9C?=
 =?us-ascii?Q?7nxmGLhGl7ES19Eo8DW0TEkc2OhSktyZeDaPe4a6J51DGKV/0Ots8ZgPmYPu?=
 =?us-ascii?Q?5Os0J7VufK0ytHf555x7I4LAd+t5jcn2LfBeUHxL6CPofrKoYu8d6c2vjHnC?=
 =?us-ascii?Q?7y6WBiTTBJV7fWypAS5LgTGTwrcm9ov0IUKfjhXgDIONe2rjULWhN/l9XqnT?=
 =?us-ascii?Q?Z2NzR6AFHX9wQVFB3xeVsF6KeGiVzZlBGfveylFnIQt8/OAHOWKLaXjb/alh?=
 =?us-ascii?Q?FjCLZdKwJlStVOh56FTe5Ig2OOUOBiJpEFr5AhABLgrCMHhGt1L5YEbTDBSi?=
 =?us-ascii?Q?pv2jBo3ING5ADm2qug7SU3JB5jPaC+R0k0KK0dLV9qaD2tJqMT8T8HlbBdil?=
 =?us-ascii?Q?3CzKrdTu2Y+B5geirOH5GAoXXxaYgDBko9MJfdQT1nLjZZpmVp2xdOApKpT6?=
 =?us-ascii?Q?jBg4BTVYkMFe+SUjdB72LzbqYk4TP0uo6B4C18SsHxHOTsohNePNbvceFuym?=
 =?us-ascii?Q?F4k78j5IoAxM6nhhj0QLQthRnoZctT16au95YhcvJ1qJ4n39FU8d3kOihAJ+?=
 =?us-ascii?Q?7uXLJjHpYm0hMnR6ON+gaahhPOKJlqmon/1jPMM77DTZsMKLjXuF4vRSntqm?=
 =?us-ascii?Q?aENC5RtdOE0bW0L3n5cR1hd8OA+qCar7PxpcGcsjHOdl0biQ6k1qiEdwC2L4?=
 =?us-ascii?Q?SqYsVcxEQBAoDwrPEhu2xRpyW1upM0ynH4tyrvkAl5PjxDLT+sspu7OSzbXs?=
 =?us-ascii?Q?Yl9PBAmKOZHvMIptm1LCvKtgv6LC/lmQyGi2C2lyNC23FfiL5sqgQwHa+uJh?=
 =?us-ascii?Q?3BgNzjY4dLS/p/J6/ymbe0qMy16A7RrjzGN8AnI0AdW9azV5MA+hIoLIdRAW?=
 =?us-ascii?Q?Ez7SFZJnSRpkGjEcayyPhRHlhMkI1UFI4C/XcP8ts3CNqYjFahO7K0/hU1rT?=
 =?us-ascii?Q?rxYkJGjlGnY5hWtyP7QTFuZh2edN94hXO3i+jr++Qpanug01PSSziDd9YvKq?=
 =?us-ascii?Q?onniJGZOqGEDvRkeqToDuHrzmKccErA4rkjOFr6V+ZNsvsNYxGffeiUw4+aH?=
 =?us-ascii?Q?yhhBaUL7slpiildhN7R9pKf0ElnsRzTSnvLPvTRDXq2+Skbw7xuL+W93K/hq?=
 =?us-ascii?Q?pqk1L0X1CMtTfl9jNSq/Ux44NT5zNb1Hyyl/QkWrSrS/7rj4FJ/elM2pQeM7?=
 =?us-ascii?Q?MLEcVtHvGMvoa9sUug1LsJ8HUjAkuiTSkmSa+66CBGk/mkoOosA0sdkfHKkl?=
 =?us-ascii?Q?L7W2BD9oqfgzvFE2zb4/BCE76+pJZzyf3yN0koFQRvRh/2gF7nEu7ILAcgD1?=
 =?us-ascii?Q?2aIwm8uiohGn29d/hwd0O2Sy9R/EAwa08sdTeMc1Z+fe503Ew6Je4aS1go89?=
 =?us-ascii?Q?RJp2xTfBBTOahlHyDsy4Z2EESYaRmC//2WoNaNtoxZxS/N6umEx7cHmFi7iO?=
 =?us-ascii?Q?cOzVLxcA2mgIoGhnsaDke6jY478xvO6QlwMuGKzFoamO5ydSoC1Yg8rO9ZW7?=
 =?us-ascii?Q?QgWZIaVJob0BeuoZyYS98yTQ6xMKX9NmDN/f52EbtYkyB9lP0l8ksebJvA2X?=
 =?us-ascii?Q?Yf1SOvjZz1k2atKDove6GFpWZ/X5ZSlx22oD3n1f?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?Nd23SImALopxQvMzTmUwW4PhTDHatPpK0kvL/ZcD87eVNCxBSWQdEPQ0uARk?=
 =?us-ascii?Q?t5UUZPjb5UYp8vZSNsBOKEocxdFkZpYGWpiBV6agRBhXCRNCeSh7ux7d8JIp?=
 =?us-ascii?Q?QLlRBKVpyP477scE8EO5QJPkiKor7sYZvSYoy64c7EaJJ8WKjS0Cgrr1tp2E?=
 =?us-ascii?Q?iOY2qN4Dzm5bZi7esbj+pHTJGiasMgzszYrMWZzOUvjHspVctPOWH2BSLo2p?=
 =?us-ascii?Q?D51ucdDYW3iDjvrQJmpBfmXwZa4thLYQzDjFJh+Jyk4ja5y5MEqbPifAd441?=
 =?us-ascii?Q?gKuSLISwUyGMP7A9s2qWKy+SBxdFZx4vT5vRIyWWszt+mS5NQ782G+azGNcm?=
 =?us-ascii?Q?h4gMgK20LqED3WBtJmfrKYF4t0CWb/zQ/DNib9on4q2nV/Mpp/dzvbTOKrim?=
 =?us-ascii?Q?/L6+CpPz1Zprzz6XwEJP+uts0pi3UvXSZaRa3s/Z3sSHjeDgk+iELgyCsUVu?=
 =?us-ascii?Q?bwRXCf2jvA6+KwI4QvPVe3t/UBn8JIEoY1EYI82jYpLDFDn0YEY8Iy17MQBg?=
 =?us-ascii?Q?qApI7XzN40iCtE5agXOShtwasciPVNoQxtPQEfk1hOlXwXn8t/ep6YD9Pvnk?=
 =?us-ascii?Q?wkWLexfAAlt6FGuDWgUY/BYEHrwd5cXTXjHiPHkOtT/6XdSYhMgABqxiOLQD?=
 =?us-ascii?Q?UkRvb5u5GUJBXOuEW1VTKKNGzNu7MdZ1w5evjT1bO3cjxtJkTEAmk0BIEgmU?=
 =?us-ascii?Q?YHuPIQj4bbfdefXy1K3z5N7pQCBRVhcDUd736fvwoDADqph1SKItwcvpsLjD?=
 =?us-ascii?Q?wFxZi0GLDdfNgYbh5jAGjCb/n5LRU7xR7Dx1P7vCV4FNosuKuk0eBqLK7FkP?=
 =?us-ascii?Q?IDAjw2S/ZJcthq6GwuMemD/7DVWwjTQlPDPngG5Y5poE2Vlv2W44sQzxQIBJ?=
 =?us-ascii?Q?U2iO52iLughDh2uUPKak/UwKOqrmmbneucCSIQ+88wRwIhB/DkArvgzkwnos?=
 =?us-ascii?Q?InSHhZzP12FVnLg6VLHoxdfgY8ZY0wnHbniQv5rEIDpFjx/2MvgbNbmFcf5Y?=
 =?us-ascii?Q?9fsVHnJDq2khrTJ0lb1sNL8GUg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85f0cf68-2fcf-4fe7-c82f-08db2cb6e914
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2023 22:27:11.3085
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1TxesyTDU2JSoS53Inn5KnNSUGg2Tw6qfw1VbRSr6rbIexxOn0gxhZzN0MSBKa6kX7k0bjMcKMFOVO96fMTsBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6138
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-24_11,2023-03-24_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxlogscore=821 spamscore=0 adultscore=0 bulkscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303240171
X-Proofpoint-ORIG-GUID: G71O5_dofCWS3OHLV2HtKtVgxM_h2-6Q
X-Proofpoint-GUID: G71O5_dofCWS3OHLV2HtKtVgxM_h2-6Q
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 03/24/23 10:26, Peter Xu wrote:
> This patch fixes an issue that a hugetlb uffd-wr-protected mapping can be
> writable even with uffd-wp bit set.  It only happens with hugetlb private
> mappings, when someone firstly wr-protects a missing pte (which will
> install a pte marker), then a write to the same page without any prior
> access to the page.
> 
> Userfaultfd-wp trap for hugetlb was implemented in hugetlb_fault() before
> reaching hugetlb_wp() to avoid taking more locks that userfault won't need.
> However there's one CoW optimization path that can trigger hugetlb_wp()
> inside hugetlb_no_page(), which will bypass the trap.
> 
> This patch skips hugetlb_wp() for CoW and retries the fault if uffd-wp bit
> is detected.  The new path will only trigger in the CoW optimization path
> because generic hugetlb_fault() (e.g. when a present pte was wr-protected)
> will resolve the uffd-wp bit already.  Also make sure anonymous UNSHARE
> won't be affected and can still be resolved, IOW only skip CoW not CoR.
> 
> This patch will be needed for v5.19+ hence copy stable.
> 
> Reported-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
> Cc: linux-stable <stable@vger.kernel.org>
> Fixes: 166f3ecc0daf ("mm/hugetlb: hook page faults for uffd write protection")
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
> 
> Notes:
> 
> v2 is not on the list but in an attachment in the reply; this v3 is mostly
> to make sure it's not the same as the patch used to be attached.  Sorry
> Andrew, we need to drop the queued one as I rewrote the commit message.

My appologies!  I saw the code path missed in v2 and assumed you did not
think it applied.  So, I said nothing.  My bad!

> Muhammad, I didn't attach your T-b because of the slight functional change.
> Please feel free to re-attach if it still works for you (which I believe
> should).
> 
> thanks,
> ---
>  mm/hugetlb.c | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 8bfd07f4c143..a58b3739ed4b 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -5478,7 +5478,7 @@ static vm_fault_t hugetlb_wp(struct mm_struct *mm, struct vm_area_struct *vma,
>  		       struct folio *pagecache_folio, spinlock_t *ptl)
>  {
>  	const bool unshare = flags & FAULT_FLAG_UNSHARE;
> -	pte_t pte;
> +	pte_t pte = huge_ptep_get(ptep);
>  	struct hstate *h = hstate_vma(vma);
>  	struct page *old_page;
>  	struct folio *new_folio;
> @@ -5487,6 +5487,17 @@ static vm_fault_t hugetlb_wp(struct mm_struct *mm, struct vm_area_struct *vma,
>  	unsigned long haddr = address & huge_page_mask(h);
>  	struct mmu_notifier_range range;
>  
> +	/*
> +	 * Never handle CoW for uffd-wp protected pages.  It should be only
> +	 * handled when the uffd-wp protection is removed.
> +	 *
> +	 * Note that only the CoW optimization path (in hugetlb_no_page())
> +	 * can trigger this, because hugetlb_fault() will always resolve
> +	 * uffd-wp bit first.
> +	 */
> +	if (!unshare && huge_pte_uffd_wp(pte))
> +		return 0;

This looks correct.  However, since the previous version looked correct I must
ask.  Can we have unshare set and huge_pte_uffd_wp true?  If so, then it seems
we would need to possibly propogate that uffd_wp to the new pte as in v2

> +
>  	/*
>  	 * hugetlb does not support FOLL_FORCE-style write faults that keep the
>  	 * PTE mapped R/O such as maybe_mkwrite() would do.
> @@ -5500,7 +5511,6 @@ static vm_fault_t hugetlb_wp(struct mm_struct *mm, struct vm_area_struct *vma,
>  		return 0;
>  	}
>  
> -	pte = huge_ptep_get(ptep);
>  	old_page = pte_page(pte);
>  
>  	delayacct_wpcopy_start();
> -- 
> 2.39.1
> 

-- 
Mike Kravetz
