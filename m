Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDBCA60ECC5
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 01:56:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbiJZX4d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 19:56:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233536AbiJZX4a (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 19:56:30 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18D44103DA6;
        Wed, 26 Oct 2022 16:56:28 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29QM3G78014699;
        Wed, 26 Oct 2022 23:54:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2022-7-12;
 bh=nm7ILFZcmnmxqB5oeD4Cumab9UmR57mBLwtMDbu01Iw=;
 b=ft39UWlyjYkmtXsZBaVl4hAv62cDl630Vzc8+M7mxwEgZVH4mj9cZsUtSulPDwsknp2W
 aucF//cmdUUnLO4iEYFdomGfy8DlpWGYpzOP8hL71mvj3OXHmc2UqcdgvMcMBcTVml5P
 QDBdKRjP5hH7uNKjDo2GcH5hEqwU0E2mCVErlnBkJlEMxpPzh2AnD2mPLVRhWFm3n5zV
 mjch8qOeFzZj2MAl0vx4d/jP5YMP5akBvLQ/rbwif/7UgdkWN6MJ4nkBPvALGjt5dol4
 6T2qwnpSG5WzOs7aimVY8fAf4Fs1MGolFrnC4dT4Rc2xLdm9oSGlqMUtVwqm/zCd+XST eg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kfays0kmq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 23:54:11 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29QM86uh017430;
        Wed, 26 Oct 2022 23:54:10 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2174.outbound.protection.outlook.com [104.47.56.174])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kfagfxccp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 23:54:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FHVPxD/p1U35I8JADiM+lf/HxtBHFXbaOK35dF91vPTQV5dDrXwbW6Xn1P4VS2U+3F5cBgHW/49ohFQONcdnvLlnGvC4Uf4v4DbIbLLEhelScR9dOAhM5BAX66jnoCxAJuwxMq20NgyyC2i3S3nYCu6yZY4ysw/Dg9fxBPp09FvHx8oU8BkRy2XLqBge3UlJvxyBovBB0qOD/qLGKGE+c7ldbFWfRQnOt+ayINO7wZSRybPw4e2i0lJghMDuskew3xQTQqrgMdiTHN7UyVSp2g4RWv92eQG6DLKu1XLrVS/3Jv9NZzxdcUXruR37EHkJojh+1JAVYuCWLOpvjZxG8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nm7ILFZcmnmxqB5oeD4Cumab9UmR57mBLwtMDbu01Iw=;
 b=ogInQhiRiLr86jJcU1r9f3cEf7S4teASJbrO5bBqFzpfgJPF0tbSCHSSU8VDOZiSgBfq7nXkTnBK5kKl2SjTLYlKEPBhibPMJHm5TO+ghWINQlH5QVGsHWHDPSOMRMG85SdyqiORB1Zb8wlPib1lt+SPFGkhLD1xgOAw30pZd/4z9o3q2yJQQkpimfsciGX6o+sEeYCGD1crOokh1QRYGhWtIH1p6alzapr9O6y1xrygY1Ri2n3SrlS4G2W3k97zVSiAEaIzz8vYV19w7Gzxzo3BCDJWMG/1V2fWj6CSG9gmaLqazBXkbqG4/7+vPF2buCPPJoFJ+g8ixvgH4L1Vig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nm7ILFZcmnmxqB5oeD4Cumab9UmR57mBLwtMDbu01Iw=;
 b=sGJTLyUIzVKdObZVnGNJuIANcUaMOUBDxTioYPgIrhloehlu0xwj8frReLZE/jyswrWvO7qpB216a8g83HFf9/zLcyOds/SBc4ntg6RhZBAjojPOV4IBhWWglTOBRKRYerXE6cAu67KZpNLlNMilXnXyMjfNp/y0tONlF3vhMA8=
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by CY8PR10MB6682.namprd10.prod.outlook.com (2603:10b6:930:91::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.32; Wed, 26 Oct
 2022 23:54:08 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::58e9:95ba:d31e:ddd3]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::58e9:95ba:d31e:ddd3%5]) with mapi id 15.20.5746.028; Wed, 26 Oct 2022
 23:54:08 +0000
Date:   Wed, 26 Oct 2022 16:54:01 -0700
From:   Mike Kravetz <mike.kravetz@oracle.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Naoya Horiguchi <naoya.horiguchi@linux.dev>,
        David Hildenbrand <david@redhat.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Mina Almasry <almasrymina@google.com>,
        Rik van Riel <riel@surriel.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Matthew Wilcox <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Wei Chen <harperchen1110@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2] hugetlb: don't delete vma_lock in hugetlb
 MADV_DONTNEED processing
Message-ID: <Y1nImUVseAOpXwPv@monkey>
References: <20221023025047.470646-1-mike.kravetz@oracle.com>
 <Y1mpwKpwsiN6u6r7@x1n>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y1mpwKpwsiN6u6r7@x1n>
X-ClientProxiedBy: MW2PR16CA0027.namprd16.prod.outlook.com (2603:10b6:907::40)
 To BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4196:EE_|CY8PR10MB6682:EE_
X-MS-Office365-Filtering-Correlation-Id: 9e1e3021-082a-43c0-1559-08dab7ad5f25
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n940/vFRyihlFoQUPuwuXom3zAXTxnLWVM2C3rBrJF+ZDCBxfFvfUy+4N++mIcpKqKFvNoTyOhW6Wa0nhK8z+xt4CppMEFups2UeAMljNpyu329sgLHHcMR8Bs+yHyMBscat0TVQJ8FvbechRO/eBkfFQW68+WVZ/5cZQYHQcX6sEcngyi39zf23/omp7CWZx+RL+/6XW+o75gKlzigcPezqRLblKciDL9UPsK7Lx7kX1whbnwcz/TiQ5bpgQS6mD3+lGKawxOoiRkx75kjPXgb8VeXiwCERByX9DDtUy7y6GZp4K2RdsZcjY21ToRWS3GIa4Zg/0dOyM8gEzW3TfWZ+YxnTOUAUnPo0+GM9RzkoS+tDwk91Jut/jafSqxg3eDOeJ46T+Ksei/29eq3Mu5GThEYRTf8wnHcE908ZIiTdMQhG4lBU7JI5xW0LF8YACTJgw9zHrxvdvteTR0MndOySUX5amjKP+eUkiDOBu1+zgfW3cMnGK50mYWiZrr9Brh6f2KYSZ8WYAxy5JPsjOi6LrbsVyTAcSpFUeiMtth3g3/hOM1KVZ1eAXIudd46TgPLfM8onZ5BtbSjE9+sPfo/DOcEltcIQ3rsWe/jSvcoDXzgQFN/oI8RHBu+iSd5VnTgTf1eLwQgHj5awPku6nG+FD0lsGDr+or55psny2gbuKs2BMCcGzMAMvRFY3eZLOrtWplqWe3tVHQIPXp8ylw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(136003)(376002)(366004)(39860400002)(396003)(346002)(451199015)(316002)(66476007)(2906002)(6916009)(44832011)(26005)(6486002)(6666004)(5660300002)(86362001)(38100700002)(54906003)(66946007)(6506007)(186003)(83380400001)(8936002)(8676002)(6512007)(33716001)(53546011)(478600001)(66556008)(4326008)(7416002)(9686003)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+N9fEwvdKZ5iG9gCrwx+YlxnJaoxGWU0Ki4xZyjKvELtTngzeVYlgJPXNP6G?=
 =?us-ascii?Q?2gdfWfqCRcMScajHiIipl62ptCbz13WGCbdSNUeok3htN6zROdKVGopV6z6e?=
 =?us-ascii?Q?k1uPk5N8tSFE4OES0AI2liQ7l+sSpMac1toluiwr1wW7mfAh15qGPoZU9gzC?=
 =?us-ascii?Q?3BS5iArUW+ZOGJI8juFnBBoO/UiL3SNxOdscy/HBa1NgPiDNAbpfFFGIBY2b?=
 =?us-ascii?Q?gRb85e5E2WVP36Ycg/M3h8KWw0tIlnfuPkHssZSV/OXHIAUCjA/yJWjZArP/?=
 =?us-ascii?Q?IrUyXVWOuTBMy4SiObTGd70AsEoXbJpINaZEVsYeT8T80isv8LMArQjMFN2t?=
 =?us-ascii?Q?6IvamhdgcFCrUiGipTNA4BpxQ5d/5LW8hZR1FrENwYI70Zyu/Ni/k2vpNF5O?=
 =?us-ascii?Q?OLv1GFAslyewJ5Kaj162BeFc9y7h1IVDn6nZl6T+5jY7u6QIFdYsJlUo3obR?=
 =?us-ascii?Q?hzt+Xm9vC5H0RgBx3S3/mQPp1It3m9KS35rQy19vOoWOBd3v8X2fCudii2ik?=
 =?us-ascii?Q?zQBDqY106bdTC1b6bjuMR48ogub25vS8ZKa1A9MYiLHSYtmHjQcqaNifa5Wg?=
 =?us-ascii?Q?BcUE/Us8O6Fud8A3bTRzcXP2hMcRe7y076Q+GgtGNoQhs6jlXIuDfWX+9FW9?=
 =?us-ascii?Q?DUIZo5tjN3Gh5Da5APeG5iTrVfBd0pOf1ac1/a0It/TI5Feu9ZW2SROGv7mg?=
 =?us-ascii?Q?PP+cQtFaTs0N6aaaNAWs3kbiyCJmEO4AImxnnrESkjEKk5tVkDchrgNOao97?=
 =?us-ascii?Q?te7lu6aeZRbVOXbBLM/6W0MTd9ABrV7Ae5h1mfOB3WCx9V1cPTAXP9X+cVGL?=
 =?us-ascii?Q?n5rM3GyhYJHcQl0T2AhLeARVFdgHbPTNusuN0IuLxuB1G7BPH6nFhuuQprAG?=
 =?us-ascii?Q?h/8yruuy3aibjW4ZUg9j7v2vUJtq/SBIntfUfhK6xO+b9N2ypvTb8LQA1KPs?=
 =?us-ascii?Q?50RP7g6UKTY9FCB4Hl/oZ/auqPFJiwnplDFGJnJcL9FVaWNh6svJTQMtLuU7?=
 =?us-ascii?Q?lCvCdxZwnf+Cm5FzBa7Ufh5PHy33YWuc4SwJnOTGIKWnofoZKEpjl7GPDhL7?=
 =?us-ascii?Q?0aj1LiPitqlqfgWv+C8feP2AzpLUHHyurb6pOnbT7XVPbAViLtn7c6FXIwAK?=
 =?us-ascii?Q?AM8eP+taLNtiRREh0wk/Lfyd0Ya+OSRa71KWzMsgJ7VIv8lpgeZuzar6bmK+?=
 =?us-ascii?Q?Tu9YzKKDSJAKJLkI9E6a+zwFKo4RWGViGVylMl+cd2hwHMDBYLjx1ugThlbK?=
 =?us-ascii?Q?qKwNDRnOAn77dDCyRHNrF8aTaWzJX/o4uhvofqFe/UkvSdXXARevFmQftARM?=
 =?us-ascii?Q?mLpar09PDr4UsiVqggERhmOXczD3cCyGyDH227BLiUm4W8L3VONgXVSpfMpC?=
 =?us-ascii?Q?CeJRvb2HDOaKZmoXS0rY4+Z0gTWQpmvMOJ5nbemQN+ivNQSpKH85gxp0/0Yu?=
 =?us-ascii?Q?JuVOVo1TRSdfPnSyhddu4dZhIhE65H4nzXaiF5mgKMnL0tGypeFPrXEnJ538?=
 =?us-ascii?Q?r+Ox10SINIjrixvUkWviJAcr8g/a2C2P8cxC4RRt+0r6nwnsAD3ZdHOLHMln?=
 =?us-ascii?Q?6cmhVHj1p2OcrvQTfFK31h+ChU9acuLrwsz/fKzzWrQpw+1UGqAu4fZFPWld?=
 =?us-ascii?Q?mQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e1e3021-082a-43c0-1559-08dab7ad5f25
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2022 23:54:08.2805
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IMbtvrVEa0VIw5iz3h992Od1H5a9GoiCLUK8VW6pneukWHOFuwE9NtPnC2No68O72D4adbqpsGoJqXGcWndSeg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6682
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-26_08,2022-10-26_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 phishscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2210260131
X-Proofpoint-ORIG-GUID: rB3LJW0OTrti7uSD81QDI5sUYXa-1yQS
X-Proofpoint-GUID: rB3LJW0OTrti7uSD81QDI5sUYXa-1yQS
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/26/22 17:42, Peter Xu wrote:
> Hi, Mike,
> 
> On Sat, Oct 22, 2022 at 07:50:47PM -0700, Mike Kravetz wrote:
> 
> [...]
> 
> > -void __unmap_hugepage_range_final(struct mmu_gather *tlb,
> > +static void __unmap_hugepage_range_locking(struct mmu_gather *tlb,
> >  			  struct vm_area_struct *vma, unsigned long start,
> >  			  unsigned long end, struct page *ref_page,
> > -			  zap_flags_t zap_flags)
> > +			  zap_flags_t zap_flags, bool final)
> >  {
> >  	hugetlb_vma_lock_write(vma);
> >  	i_mmap_lock_write(vma->vm_file->f_mapping);
> >  
> >  	__unmap_hugepage_range(tlb, vma, start, end, ref_page, zap_flags);
> >  
> > -	/*
> > -	 * Unlock and free the vma lock before releasing i_mmap_rwsem.  When
> > -	 * the vma_lock is freed, this makes the vma ineligible for pmd
> > -	 * sharing.  And, i_mmap_rwsem is required to set up pmd sharing.
> > -	 * This is important as page tables for this unmapped range will
> > -	 * be asynchrously deleted.  If the page tables are shared, there
> > -	 * will be issues when accessed by someone else.
> > -	 */
> > -	__hugetlb_vma_unlock_write_free(vma);
> > +	if (final) {
> > +		/*
> > +		 * Unlock and free the vma lock before releasing i_mmap_rwsem.
> > +		 * When the vma_lock is freed, this makes the vma ineligible
> > +		 * for pmd sharing.  And, i_mmap_rwsem is required to set up
> > +		 * pmd sharing.  This is important as page tables for this
> > +		 * unmapped range will be asynchrously deleted.  If the page
> > +		 * tables are shared, there will be issues when accessed by
> > +		 * someone else.
> > +		 */
> > +		__hugetlb_vma_unlock_write_free(vma);
> > +		i_mmap_unlock_write(vma->vm_file->f_mapping);
> 
> Pure question: can we rely on hugetlb_vm_op_close() to destroy the hugetlb
> vma lock?
> 
> I read the comment above, it seems we are trying to avoid racing with pmd
> sharing, but I don't see how that could ever happen, since iiuc there
> should only be two places that unmaps the vma (final==true):
> 
>   (1) munmap: we're holding write lock, so no page fault possible
>   (2) exit_mmap: we've already reset current->mm so no page fault possible
> 

Thanks for taking a look Peter!

The possible sharing we are trying to stop would be initiated by a fault
in a different process on the same underlying mapping object (inode).  The
specific vma in exit processing is still linked into the mapping interval
tree.  So, even though we call huge_pmd_unshare in the unmap processing (in
__unmap_hugepage_range) the sharing could later be initiated by another
process.

Hope that makes sense.  That is also the reason the routine
page_table_shareable contains this check:

	/*
	 * match the virtual addresses, permission and the alignment of the
	 * page table page.
	 *
	 * Also, vma_lock (vm_private_data) is required for sharing.
	 */
	if (pmd_index(addr) != pmd_index(saddr) ||
	    vm_flags != svm_flags ||
	    !range_in_vma(svma, sbase, s_end) ||
	    !svma->vm_private_data)
		return 0;

FYI - The 'flags' check also prevents a non-uffd mapping from initiating
sharing with a uffd mapping.

> > +	} else {
> > +		i_mmap_unlock_write(vma->vm_file->f_mapping);
> > +		hugetlb_vma_unlock_write(vma);
> > +	}
> > +}
> >  
> > -	i_mmap_unlock_write(vma->vm_file->f_mapping);
> > +void __unmap_hugepage_range_final(struct mmu_gather *tlb,
> > +			  struct vm_area_struct *vma, unsigned long start,
> > +			  unsigned long end, struct page *ref_page,
> > +			  zap_flags_t zap_flags)
> > +{
> > +	__unmap_hugepage_range_locking(tlb, vma, start, end, ref_page,
> > +					zap_flags, true);
> >  }
> >  
> > +#ifdef CONFIG_ADVISE_SYSCALLS
> > +/*
> > + * Similar setup as in zap_page_range().  madvise(MADV_DONTNEED) can not call
> > + * zap_page_range for hugetlb vmas as __unmap_hugepage_range_final will delete
> > + * the associated vma_lock.
> > + */
> > +void clear_hugetlb_page_range(struct vm_area_struct *vma, unsigned long start,
> > +				unsigned long end)
> > +{
> > +	struct mmu_notifier_range range;
> > +	struct mmu_gather tlb;
> > +
> > +	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma, vma->vm_mm,
> > +				start, end);
> 
> Is mmu_notifier_invalidate_range_start() missing here?
> 

It certainly does look like it.  When I created this routine, I was trying to
mimic what was done in the current calling path zap_page_range to
__unmap_hugepage_range_final.  Now when I look at that, I am not seeing
a mmu_notifier_invalidate_range_start/end.  Am I missing something, or
are these missing today?  Do note that we do MMU_NOTIFY_UNMAP in
__unmap_hugepage_range.

> > +	tlb_gather_mmu(&tlb, vma->vm_mm);
> > +	update_hiwater_rss(vma->vm_mm);
> > +
> > +	__unmap_hugepage_range_locking(&tlb, vma, start, end, NULL, 0, false);
> > +
> > +	mmu_notifier_invalidate_range_end(&range);
> > +	tlb_finish_mmu(&tlb);
> > +}
> > +#endif
> > +
> >  void unmap_hugepage_range(struct vm_area_struct *vma, unsigned long start,
> >  			  unsigned long end, struct page *ref_page,
> >  			  zap_flags_t zap_flags)
> > diff --git a/mm/madvise.c b/mm/madvise.c
> > index 2baa93ca2310..90577a669635 100644
> > --- a/mm/madvise.c
> > +++ b/mm/madvise.c
> > @@ -790,7 +790,10 @@ static int madvise_free_single_vma(struct vm_area_struct *vma,
> >  static long madvise_dontneed_single_vma(struct vm_area_struct *vma,
> >  					unsigned long start, unsigned long end)
> >  {
> > -	zap_page_range(vma, start, end - start);
> > +	if (!is_vm_hugetlb_page(vma))
> > +		zap_page_range(vma, start, end - start);
> > +	else
> > +		clear_hugetlb_page_range(vma, start, end);
> >  	return 0;
> >  }
> 
> This does look a bit unfortunate - zap_page_range() contains yet another
> is_vm_hugetlb_page() check (further down in unmap_single_vma), it can be
> very confusing on which code path is really handling hugetlb.
> 
> The other mm_users check in v3 doesn't need this change, but was a bit
> hackish to me, because IIUC we're clear on the call paths to trigger this
> (unmap_vmas), so it seems clean to me to pass that info from the upper
> stack.
> 
> Maybe we can have a new zap_flags passed into unmap_single_vma() showing
> that it's destroying the vma?

I thought about that.  However, we would need to start passing the flag
here into zap_page_range as this is the beginning of that call down into
the hugetlb code where we do not want to remove zap_page_rangethe
vma_lock.

-- 
Mike Kravetz
