Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40B8943D2E6
	for <lists+stable@lfdr.de>; Wed, 27 Oct 2021 22:34:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240927AbhJ0UhS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Oct 2021 16:37:18 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:57726 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240884AbhJ0UhS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Oct 2021 16:37:18 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19RK0R3v012479;
        Wed, 27 Oct 2021 13:34:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : mime-version; s=facebook;
 bh=zyptw/GEEZK97iniktdRpIDk/tVFqKuaI4BmTWEGUTU=;
 b=nRD5cK34dxf7y6u+zPTaLB6YH1RuvN6SwiThT6tOxuHwByl0JeqJA83Uo5SA1xHGCwRC
 sawSwMsbcR7Xkqbf4P5Cpc5YYw+eg0X/MuuHum4iBhFql1QhbISUYv/Lx5jk4Kfu5eR9
 SahaQIS2NsnOD2GbxeTyilu72A858nLrR/E= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3bxy9e7q6h-12
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 27 Oct 2021 13:34:51 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Wed, 27 Oct 2021 13:34:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FsuHkLWPsIvjNeXs8eRxzIje7bGwCCwpLKYYIHL8MkSNHzDo1FNI2iX4dmO9grEo6pdf2VwTn5aSk4Cpzx9P4vDMIHtvfiaevFvlo0AQZpg0avUk1MS7boWS3EQPxnrdQ+ZIHBHh5s0gclz3HzdIXoJ3v1hyA7Wi7PT6kMKlLJLR0QC4sjO9hJHpv/akh0162QvAslutbwqeg87K80UCQMIq6vNcLF2Ja3OP7Hq0w6wDJNw6nAs5GbwaLuOYDB4PE+5B+ce8u+RpE0ougxzU/vMY9BLr65RO09Wk7L96X6Ef3TAbbY+igtWYfaknzoL/0xc3EQO9afQQfoi0CujRLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zyptw/GEEZK97iniktdRpIDk/tVFqKuaI4BmTWEGUTU=;
 b=Ds1ORGpyU3KsJvK5evd+FDWXQ8wMmNkNWqx2xdPfdgSWnEFFNTCXNJqdVV9r5+M7zLk3jHXBjn80Xa4o9SzUHIpm1goCnlJedJdGcFHGuQXAExBa0ftKqG2c3BTpGLCbjYatNBBuUUdHW64FmhhY4P869hlS95eqEdCQPWaEqfCOrfRbSnEFWKnNAe2Ioln07jIlJcaLyitn4V1ReOiaqMCQC9oB99uh4XkhkVRZNX52zQmQuuTSikPdH0sS6MpHg4V32gPqPCII89PkO6Sd/E+4iZzNM5Qb6ROWl0h+RCXASx+RJLEOqRpRVOIiYfWfr8pJAv0AAda7g4P2Vu400w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SA1PR15MB5188.namprd15.prod.outlook.com (2603:10b6:806:238::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Wed, 27 Oct
 2021 20:34:49 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::7d66:9b36:b482:af0f]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::7d66:9b36:b482:af0f%7]) with mapi id 15.20.4628.020; Wed, 27 Oct 2021
 20:34:49 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Yang Shi <shy828301@gmail.com>
CC:     Hugh Dickins <hughd@google.com>,
        "sunhao.th@gmail.com" <sunhao.th@gmail.com>,
        Matthew Wilcox <willy@infradead.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        "andrea.righi@canonical.com" <andrea.righi@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] mm: khugepaged: skip huge page collapse for special files
Thread-Topic: [PATCH] mm: khugepaged: skip huge page collapse for special
 files
Thread-Index: AQHXy2wtAJJR+AGuU0SPw4erOqc4Z6vnTVIA
Date:   Wed, 27 Oct 2021 20:34:49 +0000
Message-ID: <C8C6E50C-D300-40D4-AA5C-490F673BADFE@fb.com>
References: <20211027195221.3825-1-shy828301@gmail.com>
In-Reply-To: <20211027195221.3825-1-shy828301@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=fb.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 352b548d-8c48-43ac-03d9-08d99989390e
x-ms-traffictypediagnostic: SA1PR15MB5188:
x-microsoft-antispam-prvs: <SA1PR15MB51884B7D1CACAA445A7BE626B3859@SA1PR15MB5188.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VS9mSNuNHYvkO2k8I8+XYRbIIZvN/Ink1h27woQZ8iE4BlUtNbPQfHFrRfbpLbJFAHsEy8p6KaqEAnoWGAy+XUT/x90kqzpVysGkjpyGi5vN6zVMRRWx4zv/k6eX2KvlYqlY/GN65AW2ejK2sjp3EoregC1QKXKQ9e0BS1Co6R3bg42BRql3l928f109XR9DaIQxlxKVOjaMaZNDZ5dzZUEsQyH2qlLjQaLOFsO5L8CeygJ8ySXzUSMpBGqfNjSgNsQsqUgQrsVRoufiBt/0FJuOlhC4DJrAFkOPaDJ97FjJDV8kyRkhN3UOe4gArrJ3n+ICahse5O/LYIMuRP81lUXrj01fiRFK7zYAH1CxNV/9jF0NHJM2D5TE3XPXC0LHYB1djfQSH99Fx1RNljQpO2kVHix9nbmMal+slQnHXG5AWmKB2bHWDSAbXFcSxLXGeEFPJwc3BBUn0nL0vMO4tVnUnIWwiLVZqWvpVlOC/kNmPh3Hh+ovoF/7W2LLHs2XGmayQCDsNniEcj3Ta5GQ5eXlN4tQ0MsEat6qCkStZ/i+XBmjgIJT3jC4ItjMT7ZsOs3ljZAROZ1kJZZdORFZ4GCnZbKPuLSUF5jtpTQtm1L8nBv58YWdYBkEpHvu8XBH+EOisA6n8q1m9M4aQRbol6C/MmzH/s5QVfbL86Lv6JHAmdOL0eBsVp7LWzVwW0GPOuVuViHN6IRE9eGbPt60hA2QHAct3xzboSkob30Gb0lu6JpjzBOLAwchgrqp36ua6f6p67MHPfI5FK5akrHjJc1LRM0FYy9EHlp86vBh4nquJuZzxDLBPHXibBGCzzxy8q8vHUpqcZkf52uJVaExjrjypJUK6x5Ue8kdiabgnnqsCT8SCh5I7eHL7kYep3Cg2Qa8YJRinmAbwfiaHDKrpg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8936002)(8676002)(5660300002)(316002)(66476007)(66946007)(7416002)(66556008)(4326008)(966005)(122000001)(64756008)(66446008)(76116006)(6916009)(38070700005)(91956017)(36756003)(54906003)(508600001)(6512007)(186003)(86362001)(83380400001)(71200400001)(2616005)(6486002)(38100700002)(53546011)(33656002)(2906002)(6506007)(14583001)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?aLbsABn/PcoIrAMtBXStmp+NrJzcOQ2fvoq5hBuRXumQ2fEKvim621Yvps06?=
 =?us-ascii?Q?GPHVjvTK+CaOW40M4f83qdW2+3Gmf6Md+iVoxJnRVIMjDVsbpX5pdbTX71mb?=
 =?us-ascii?Q?+uYhJNLbKUNDqCMIv9HdBog2I/iZjNTMzLt3WJh5EDqVyHzDN4O6V+s/x/3p?=
 =?us-ascii?Q?dQC4zimTndMh40NX8R2poJTWRZ1UjVuD/tKSrQOiUHNrMKU6jRJi89sxDdRP?=
 =?us-ascii?Q?/nc+5Kf44GRHnY2wwh6GJ0QJqVdIF/mX1psUqFEHfpEXf7DR7D0RZVN8ltVk?=
 =?us-ascii?Q?ufVYuN0XmKnaNjOdD67KE7IPAx8ogM3OQgGnL9qZgEb1FqKJLXiVSPrXeBTH?=
 =?us-ascii?Q?Y7jbUz3JBRW/K/SuR9Hdt/zY8tcnyqUc4V19bMtQ8ACloDlREpiqkfMPrPYT?=
 =?us-ascii?Q?aBPFh1c/jb6rTj1roKDYTU+3LG5DypchyIEQWJORCC2vdrdvCe/3Ye4BtjHE?=
 =?us-ascii?Q?F3teaGdb7V+FKwQvJI8qai8xbYi7sRSn96wTq1pgdnu8JpENBmOlxwsGcxUK?=
 =?us-ascii?Q?K8/bweQE+0CHtoSx6n0RHVEQTjl9hTEpbuZXU1YNg4U/73YhQAIPyhTL5gnu?=
 =?us-ascii?Q?SDqlmU90PnPexKFQZ3TuJXWIPNXJvcI04WUrohstgj12aiP/GwQnPI8/wY1O?=
 =?us-ascii?Q?CqpECmNFxqF9gLJTGLdDPLpzeoD492MBaNsH/EK4rL2+ERS5ll6UVlwjo15H?=
 =?us-ascii?Q?I2CVbOSUKMiOg2xaJm1gz3rVXGcRTb0jOmgXplmRu4lxjUky2SjcAbIq3wzX?=
 =?us-ascii?Q?jgimmN1bs42Cf0m4FHzVXIci2YF9+7Q6soQpBo0dSr7YbI0nQ7lE/UJ7TjEk?=
 =?us-ascii?Q?uiRu4F5Ph4mq42Yj0hJJt1ClIVTfS1g0SaH4ncA9AWLO1Uqm0VM2aiWPwwC8?=
 =?us-ascii?Q?A5AQHdmpkc240bGqszjdGkAXWOnxYdSfu7qujPFkH1Dag2BY/LmN6C1ByFqv?=
 =?us-ascii?Q?G/H8zBNuVdD68Lx2p6JeCJTMoZHekLPyhMz89Z0ysi1unv4SgMG0OeguchqN?=
 =?us-ascii?Q?4WaGoh0e3XPwAIZ++Y2bhagDjY+XVw5EfNjc8i3jUdRx1X0pJux9yuK1cudC?=
 =?us-ascii?Q?6rFiz2q4BJYPb5aeelaHQvxaP/pxzRxSGokY8+RCQHicZmFLPJPTIrpVeFJc?=
 =?us-ascii?Q?Wg0mpfpRjhtZfj04TKwoiZPSZUdYBZHz4CLYn95jDpZcy7rDv5oojJ6NAQGj?=
 =?us-ascii?Q?mh7bhXJORsR7XPZkoOheIWxUfWckENjOwNHE41cA1zIAHk4Fwhb8iO/mx5Kg?=
 =?us-ascii?Q?9v2HjqPgIquuN+kryV0WTq340UnsRnpMKKBMWQMxh89MSX6ce8dr12aIhbrW?=
 =?us-ascii?Q?nIS1gOhjKkUFy/qaZ7yqJWrIigpr9258S5MYBDKsOwMFm7Ng5cJZKvqr5bLb?=
 =?us-ascii?Q?8iPeC7HHhDDO0VQVAlDpiTVSD+Vz5lQrrV9rESzFGfOzuYcy9NuAOhu/pJh3?=
 =?us-ascii?Q?q5sXhvJ+GG1b8nG6R1bAUcqFODkR4YasslXY80OqF86Ysq5l2OxrQWWwNSrc?=
 =?us-ascii?Q?yHOpDB8CR0QTniZ4hnxphP4nCZzFSX+M8ECB113qgNa1tu5GTXqLanpeFxO9?=
 =?us-ascii?Q?3lKgtXIsMbz/PhCqQiSnjrmQIBymvApPj2VhNr1hlNzzjMMVIjqzX5SV72F7?=
 =?us-ascii?Q?UMQ8kgfaFMDdnkHsCrB560WIm1Uv7hifoE0xxh0hpSVDjqdIl8t3w9VstoxX?=
 =?us-ascii?Q?a5c0Hg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <09C0D7897F3A6C478F3EF192F3BEFDE6@namprd15.prod.outlook.com>
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 352b548d-8c48-43ac-03d9-08d99989390e
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Oct 2021 20:34:49.5449
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7yrfQT1ANDTJv0zyqJVGSa2YwtScxJPgRMbFv05lkivYD8VlReV9rV8oEN+A89MgecnOd5ufj3ASdQ72aeCbag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB5188
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: 1Nz8A9JNeIuIJf4nhFCDyPxuF-0ywEqT
X-Proofpoint-GUID: 1Nz8A9JNeIuIJf4nhFCDyPxuF-0ywEqT
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-27_06,2021-10-26_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 malwarescore=0 adultscore=0 spamscore=0 mlxscore=0 impostorscore=0
 clxscore=1011 priorityscore=1501 lowpriorityscore=0 phishscore=0
 mlxlogscore=999 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2110270116
X-FB-Internal: deliver
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On Oct 27, 2021, at 12:52 PM, Yang Shi <shy828301@gmail.com> wrote:
> 
> The read-only THP for filesystems would collapse THP for file opened
> readonly and mapped with VM_EXEC, the intended usecase is to avoid TLB
> miss for large text segment.  But it doesn't restrict the file types so
> THP could be collapsed for non-regular file, for example, block device,
> if it is opened readonly and mapped with EXEC permission.  This may
> cause bugs, like [1] and [2].
> 
> This is definitely not intended usecase, so just collapsing THP for regular
> file in order to close the attack surface.
> 
> [1] https://lore.kernel.org/lkml/CACkBjsYwLYLRmX8GpsDpMthagWOjWWrNxqY6ZLNQVr6yx+f5vA@mail.gmail.com/
> [2] https://lore.kernel.org/linux-mm/000000000000c6a82505ce284e4c@google.com/
> 
> Fixes: 99cb0dbd47a1 ("mm,thp: add read-only THP support for (non-shmem) FS")
> Reported-by: Hao Sun <sunhao.th@gmail.com>
> Reported-by: syzbot+aae069be1de40fb11825@syzkaller.appspotmail.com
> Cc: Hao Sun <sunhao.th@gmail.com>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Cc: Song Liu <songliubraving@fb.com>
> Cc: Andrea Righi <andrea.righi@canonical.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Hugh Dickins <hughd@google.com>
> Signed-off-by: Yang Shi <shy828301@gmail.com>
> ---
> The patch is basically based off the proposal from Hugh
> (https://lore.kernel.org/linux-mm/a07564a3-b2fc-9ffe-3ace-3f276075ea5c@google.com/).
> It seems Hugh is too busy to prepare the patch for formal submission (I
> didn't hear from him by pinging him a couple of times on mailing list),
> so I prepared the patch and added his SOB.
> 
> mm/khugepaged.c | 17 ++++++++++-------
> 1 file changed, 10 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 045cc579f724..e91b7271275e 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -445,22 +445,25 @@ static bool hugepage_vma_check(struct vm_area_struct *vma,
> 	if (!transhuge_vma_enabled(vma, vm_flags))
> 		return false;
> 
> -	/* Enabled via shmem mount options or sysfs settings. */
> -	if (shmem_file(vma->vm_file) && shmem_huge_enabled(vma)) {
> +	if (vma->vm_file)
> 		return IS_ALIGNED((vma->vm_start >> PAGE_SHIFT) - vma->vm_pgoff,
> 				HPAGE_PMD_NR);

Am I misreading this? If we return here for vma->vm_file, the following 
logic (shmem_file(), etc.) would be skipped, no? 

Thanks,
Song

> -	}
> +
> +	/* Enabled via shmem mount options or sysfs settings. */
> +	if (shmem_file(vma->vm_file))
> +		return shmem_huge_enabled(vma);
> 
> 	/* THP settings require madvise. */
> 	if (!(vm_flags & VM_HUGEPAGE) && !khugepaged_always())
> 		return false;
> 
> -	/* Read-only file mappings need to be aligned for THP to work. */
> +	/* Only regular file is valid */
> 	if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) && vma->vm_file &&
> -	    !inode_is_open_for_write(vma->vm_file->f_inode) &&
> 	    (vm_flags & VM_EXEC)) {
> -		return IS_ALIGNED((vma->vm_start >> PAGE_SHIFT) - vma->vm_pgoff,
> -				HPAGE_PMD_NR);
> +		struct inode *inode = vma->vm_file->f_inode;
> +
> +		return !inode_is_open_for_write(inode) &&
> +			S_ISREG(inode->i_mode);
> 	}
> 
> 	if (!vma->anon_vma || vma->vm_ops)
> -- 
> 2.26.2
> 

