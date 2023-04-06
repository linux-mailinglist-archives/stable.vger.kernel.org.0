Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78D946DA582
	for <lists+stable@lfdr.de>; Fri,  7 Apr 2023 00:05:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238043AbjDFWFM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Apr 2023 18:05:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239348AbjDFWEx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Apr 2023 18:04:53 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2B7CA5CB;
        Thu,  6 Apr 2023 15:04:51 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 336EvpVo016552;
        Thu, 6 Apr 2023 22:04:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2022-7-12;
 bh=YA7FDaUoxmNX9BwiqD4hG0qZzclOK6XYTvo5kS7D8b0=;
 b=wpQ+788VbvC0lVz0vkbRKXW/lQdvOOeCCmxwk7NjLZCvFVHO10hmrg7FHKqwVlXwvNO3
 KInYKZo2UoQToNw1iL+AEUOBwbgnPW0wIsEiC7zE2OJ7cv4nYSqQOuSln7FZ/3ypd5hV
 yb6El+7Dj0uN6hlkUNSG0O8SUGOK7A4aJsyE13k81UGI59YO5qY5SKGxekKl/iCaOa4y
 4XNhbFxdl9Aa7azujtpet7/xuTSv2RF6ND/WsjBWn1jhV1/t0844qNhptpZ3LddM/L6I
 SIH8n/7KjFuZsuS1ZtDHIv5luMoPmbhRvoBg6C+y8VSEy2huXTrmjamon8RuESQN1MYD Xw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ppc7u3x1f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Apr 2023 22:04:45 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 336KoArf027512;
        Thu, 6 Apr 2023 22:04:44 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3pptutpde6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Apr 2023 22:04:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lEPIiCS+i/QtpbDByBgTlfzd6ors6o41vrmldy9FYCkroqAvbbB/Ii5U1cxknF5VkPWBHdewxBFreazw0hq4NwEHcfJtaYpJe69mhDcOVOENKmKt5COLyYePp9UJIkbNnXclI5XWZmGuIVHZ1Y199pv3sfCo7iRF5P5fq75lE5X79vvZHYh7Il6+q0tDi5WpgOzpPbnl1tes+Rp2oigOz7Wr9sNH5pCzFdp+ibm8G/K82RugdkNAwS6syqoUPUuQ9FLKnSqLANH+HvMHEhqsW0+hZAuTz2OmgjLGKxncTfq5Z7c3lxGG2Cl0v4rhQmsKZWBAcHrBbnifcgxQv7aDpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YA7FDaUoxmNX9BwiqD4hG0qZzclOK6XYTvo5kS7D8b0=;
 b=n6TUgQ68iu9FRNogAujGo3JKnC7TR5Cn/8icMislXvCBC1UdqppK/BIRZ2PseycR6yFZGTtkNcNwV2JTs0Tgc67nX/UmpuzBLGmVdt9l3jofXfQZv3CipAUkcn5PfcxJ+b5QnwSrJrAVdvSv/LeTdyqAHcx2lARM1eyl7MNYtNQ17DPBOzmanj0MMoHTAnYiB3xIEM5Db9Si2PvsgIuWpND92cGYrJdHpenhul82/ZpFSj1QlJNoKEkm441TnyDdKxh04HjiijSiK97vEv9nQOdi9w1reEqHt0jVV+4E8EnYNYpLNUeH/19lXQ27jbxhc9DABh6+Kq8gN6BihqBLKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YA7FDaUoxmNX9BwiqD4hG0qZzclOK6XYTvo5kS7D8b0=;
 b=FVTWIweI8Cxy3kxnQzW91hOm/30oLAjQ8iHX0JB0iwLvgUUFqelfYq7R4/RUUdtV2lYtoYsTKXeM8DcgTbE87JYZJiYNJmX2guubIC8otzZMJ6c1C6buod21KlMuy5xxQ1eOnwRoAFRij6bEwtRLZF8GjysJDZ8YCwPuJSspnp4=
Received: from SN6PR10MB3022.namprd10.prod.outlook.com (2603:10b6:805:d8::25)
 by BLAPR10MB4882.namprd10.prod.outlook.com (2603:10b6:208:30d::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.31; Thu, 6 Apr
 2023 22:04:41 +0000
Received: from SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::8bb9:2bb7:3930:b5da]) by SN6PR10MB3022.namprd10.prod.outlook.com
 ([fe80::8bb9:2bb7:3930:b5da%7]) with mapi id 15.20.6254.035; Thu, 6 Apr 2023
 22:04:41 +0000
Date:   Thu, 6 Apr 2023 18:04:37 -0400
From:   "Liam R. Howlett" <Liam.Howlett@Oracle.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm/mprotect: Fix do_mprotect_pkey() return on error
Message-ID: <20230406220437.wiks6gm3k6tt662f@revolver>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@Oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        stable@vger.kernel.org
References: <20230406193050.1363476-1-Liam.Howlett@oracle.com>
 <20230406145345.9c5e4c91461cbf42509a92a9@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230406145345.9c5e4c91461cbf42509a92a9@linux-foundation.org>
User-Agent: NeoMutt/20220429
X-ClientProxiedBy: YT1P288CA0027.CANP288.PROD.OUTLOOK.COM (2603:10b6:b01::40)
 To SN6PR10MB3022.namprd10.prod.outlook.com (2603:10b6:805:d8::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR10MB3022:EE_|BLAPR10MB4882:EE_
X-MS-Office365-Filtering-Correlation-Id: ba6313dd-952b-4723-e5fd-08db36eaebd7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fo/vT/l9K1wT5j+RHZUlTyWfekSwPECkbnnK6xUkg9Y6n9dbMM0p2Ih6MAZXeGl39qxvEaKdP97brWxdlIMlAW1Q5TkQ3B/5SshBOzD1nwWn9R/pGr7JLQ328Yoso5uupApSLIYqH4AZdUoFCT36heLGW4au3iyxg7POftUZEi00VeoyBjGFV0wmqoIaOIKqQVZjFBWxmhyBQrEkPFdkTQCY+HWOue5CKHn7ScikXyO4PV6iOMfzzryEE8YXM+Jq4xDa/AoaqLEnaOjS/Q2xwk4DDgOK+gFofGMa5ud4sL2N5vVYT/YgvEkgyRu13kksCaAcMa/E6rSpu4Onbm/VC2p+/Pny9SiRicqfoxOOpbdWQTYij8UNBC89uclhbILHfYuvwZ8SlQrjiq55Kdc6Wqk4CbJb1zTOjseZ7sYchoS04OxIZtTmIVkewhSH6tUmrPavmjo2iuuAJD4jKhy0O1o1Zk5cI9AbkTkHwroWz5jxtKgfSk8c24EjXloBwqKliMRJ9EG+kVrXGWQtfywqpCFbZ1plf1qnmhoT+C7R6J1UbChpQP6RtrnJXlA9DTa9
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB3022.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(136003)(346002)(366004)(39860400002)(396003)(376002)(451199021)(83380400001)(6486002)(478600001)(316002)(1076003)(26005)(6506007)(6666004)(9686003)(186003)(33716001)(6512007)(4326008)(5660300002)(38100700002)(2906002)(6916009)(66946007)(86362001)(66556008)(41300700001)(8676002)(66476007)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?25Poy6t76GkxnmFmcvuZW00rPXUdatc1gWFugL3PQez9CXoaA86l0VqfryRV?=
 =?us-ascii?Q?ae/VAHuWHH8fkT90ucEz9cm3IVACzLvNYHRD2abx1HO2slw/gHzmkEh1vFr/?=
 =?us-ascii?Q?FjEvT2vwjV7Lt8vjnCqshcEJKBPTzgjGVJRYHkRXPjpvUnOUS8StgHBSbzox?=
 =?us-ascii?Q?CQEySgJyRQTPo+bqPMzXOs1pXslzjCVmlJRLgfCLv57CJQV+arQq5KWbfc+S?=
 =?us-ascii?Q?SH5Fq04ZSu7Bjk2Y7XZqYFFtiDck4JlLGfgaLjX4zdFU3O7ooPVLYJYR8955?=
 =?us-ascii?Q?w4WMqh9na9ux9zB/dSJV6tIpA3klkMw6cyGRY7VL6F2GQsvUMmdaYyl+5f2U?=
 =?us-ascii?Q?K2JJNJ+woWeZhwN9RWB606hndWwaJ6TcyZMVaTXdvr2e2QM7tzbPvcwBJOjS?=
 =?us-ascii?Q?t+jwrrx8aRIAGXbf8cRQzyRyWVpioPJvcYIcdyQVegggo3k7ZKd6FsGf+hh1?=
 =?us-ascii?Q?BWV/C0UiOT6FvMeCW/aTR64UEdF5Ae+0Mx2NWn2GojYECksFduz/WL4ZndME?=
 =?us-ascii?Q?AOaUbEFsd2FyOCMCxhS4NTE6g7pZ4oQT0Ps0sBp1km76qT70SbhVqkBt9XjY?=
 =?us-ascii?Q?/SLI1gFKtJRySNYOdEr4FYl9XfpM69q6/kkNR1PXgFYg4ShXK80pM46DFdTq?=
 =?us-ascii?Q?lIfmntWhPy7ewkJi3Hu5iMJjKfaQB2ywwq9vudSmewT/sVvzu+h9rVBHmmIG?=
 =?us-ascii?Q?lTd35vwZmJF+C3hWQNcSwBwzQmZeQmMhdtKM2eTMl+wUNiuLit/3+6sXFI5s?=
 =?us-ascii?Q?0HXND514UAcSMkaUX56XSRkMR5VlxKfpJaEExOWaFsADyIpbPrkT50rimh7o?=
 =?us-ascii?Q?GVD0swbRzvStB/XIObLns8rq9awLfXl60XcS5X6ApzbPgaFp91BocQ/PvkJ7?=
 =?us-ascii?Q?/O1efoXy9YQfz3WkGpmwQSA5d8RF9g4VK9NxkZAq+gza41+kcAW7xm6gP/Fa?=
 =?us-ascii?Q?1GJM7fzbbcK1AiBmdjrE5V3hUi3vlGZey07iy1nkZtaFj1kqI8/4glVNCWjG?=
 =?us-ascii?Q?13Doebyyz6fmKFolXzVWGi1bR5BajHDbvV0u7Th0/4aZJ3PvDnMwndHfEArS?=
 =?us-ascii?Q?n2JAifFuRFloCHnXLaU7ubAaJtEK0PRKkWvoC5TFlGg/iLB3FLJI/3RhkA72?=
 =?us-ascii?Q?BK8Nlisv/gfEUZIOgGHSufdG1rz7Woo5OODs783QT1g/LiHdzbssm5wKm/aI?=
 =?us-ascii?Q?51K7Ix9A2SmttrperaHMVD7dVdRXJdvQ/jIz0BXjc0r4lKWUejs/qqhT8riG?=
 =?us-ascii?Q?AeMXTXKxdssU2OLtsY7RcDhASE9b9r/3dnV+zodm2g00auqSRSSvy0BTyboj?=
 =?us-ascii?Q?IjvHp8W7/azA0J4Qk7B4SsnRmPl31ZLQuS5g7b1qZ5n9NgYGTVnJzkMpf8vy?=
 =?us-ascii?Q?S8oJHoIqagj+r+dVm+DdytGbKN5ra3vdbrUnRK5OAno59rSRzoYkRUGbrLdv?=
 =?us-ascii?Q?NkE+vU3buyXjCT+a4KuFlsnulWftuc50pnIWZjhhnIk6h+KSuEHkwhE7sY97?=
 =?us-ascii?Q?dfmCqwTMI2Foyb8jUMj/fD5Swgv5UP4F5KmnK5OnR3be90xbvsDpAyRf+72P?=
 =?us-ascii?Q?J1j8yEfcIzUb3jsBAXoK2oZGTCcvbTOP03ZounLzzVz44o8qOtGBMOD1pfLR?=
 =?us-ascii?Q?gQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: WEA/pb1FvbIYMM/WBeBBsQxx/up6VAopb8eDIPH8banVoj/x+X5z0T+fqpMyMlJxZwfv3W4TZlcZ3oJR1GDz6mTStoZQOiofJjinafbOMVhSzERAzltP357E9lSfiCHuIb4B0dcnjC7Z1gO6DHJh6LRLjna+ayEgUVhl9XQaSvZqpZzvpOVHVSqW2z5BoprGv4UPbxTk/8aWvONxTrtJFvC+OX9L2aEPGuvv9VIZigc69GLrixWjSvDj1+/eyshamqgeNXaPJOLx8c4Er/ugeGN93FGfAYoupc6fBWOt5RcNVE32TYN5oASQGmh7A32hJOKuciPW5S0XmChnrih34XRKu+h2r58U8fB4yWHOvTjfwQvf794Njje4Nne5RGsIa49SBbOUmkShVNouw7FZS9eJ0KV+8CXsBLxqtm/vZ+PvL70fB7j02owns5PYNOTwzKh12qroA12RbQBxsEjxoQqbrWiS5Rja+/qw8kHyB20il9ouuD0X4LWHHyuMpPExaeoR2ZGrdwXBxtQx+FtZ6ED05hJc1r368KSCUPSQ5TrSDsPgVxymcN8dLum3gegfgdRLgrfF7hhD7QPLmJyOJwOyLEnS14g/m95H0wGm6MKsHgAFyNcDsjhGaAg9EdpZQvyuP+Pnyl+ymdmpU9iOfbCPfuYw08K1EihnG0Cx/y8PKfhUc5pSg5qz2RJZoZ+5NCAnzuGUitYxiOcqHSFRneTz9F2W3j4HV42seztvbP87E3Vmx2kwFrM0R3FUN1oJTHB7S1sUjaLwI44xQv6ccJzfiw8xcRJoRSwIENfWC1+TVo7/NPHo+zy/mwMbjr7vIYVUVEqQJ0lkG8jUzwgW1g==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba6313dd-952b-4723-e5fd-08db36eaebd7
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB3022.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2023 22:04:41.1179
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dI1Oz0pSUiDJx7631AckZkhIMQXO7mr306OsUbNW306bscqLMXGzJmwli3BsPKWs2XJmDqYDKZBpdtDBcBoNgg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4882
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-06_12,2023-04-06_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 malwarescore=0
 mlxlogscore=999 adultscore=0 phishscore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2304060195
X-Proofpoint-ORIG-GUID: F6VNwk1f5u0sRS0NwFp_q6-2xgxQ4hAs
X-Proofpoint-GUID: F6VNwk1f5u0sRS0NwFp_q6-2xgxQ4hAs
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

* Andrew Morton <akpm@linux-foundation.org> [230406 17:53]:
> On Thu,  6 Apr 2023 15:30:50 -0400 "Liam R. Howlett" <Liam.Howlett@oracle.com> wrote:
> 
> > When the loop over the VMA is terminated early due to an error, the
> > return code could be overwritten with ENOMEM.  Fix the return code by
> > only setting the error on early loop termination when the error is not
> > set.
> > 
> > Fixes: 2286a6914c77 ("mm: change mprotect_fixup to vma iterator")
> > Cc: <stable@vger.kernel.org>
> 
> I do think we should always describe the user-visible effects when
> proposing a backport.
> 
> a) so the -stable maintainers understand why we're recommending the
>    backport and
> 
> b) to help some poor soul who is looking at the patch wondering if
>    it will fix his customer's bug report.

Thanks, I'll keep this in mind.

> 
> How's this?
> 
> : User-visible effects include: attempts to run mprotect() against a special
> : mapping or with a poorly-aligned hugetlb address should return -EINVAL,
> : but they presently return -ENOMEM.

That sounds reasonable, although this isn't an exhaustive list. It could
be an -EACCESS for multiple reasons, or anything the vm_ops returns.
