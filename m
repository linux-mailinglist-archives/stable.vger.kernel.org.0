Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35550624D4E
	for <lists+stable@lfdr.de>; Thu, 10 Nov 2022 22:50:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbiKJVue (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Nov 2022 16:50:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbiKJVud (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Nov 2022 16:50:33 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3130845EDA;
        Thu, 10 Nov 2022 13:50:32 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2AALNAsA016673;
        Thu, 10 Nov 2022 21:48:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=corp-2022-7-12;
 bh=3EgRGDcmCoqGPwIBAL592LVO56lyJUVy79wdvS4VM/4=;
 b=nUtJfP5R/IFoRWoF+iTEly0VKFTolRl3Rbkyypq1TYQw0UgR1qsBRo4ilhbO64rriTuK
 jKj/MXwSA+y0N0XhjNzehHQS9eQYyEUbUf+PVqN1XkCQLW8HkqT21uZVHAo0CcK0gkS3
 0lOqNpmcLQoccxfLvA2BJVYxh/VbKswqRijOgl6mCMn3Jk7JQhCYDu269iToUbeVV9Zi
 xSlirs+JLVh5p5voUtOc8BrBW13J6PZBPUG5h3gmLc8qfh6qogc8pfxvkS/7F8ltIVvG
 bbtDlCpb1MlFSNvDGo3N3Fy3wdh73h13okX8CqhCMmXTYUNwXEWQYZzW4oPsHl7ZD7+J Qw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ks95nr2y6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Nov 2022 21:48:14 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AAKcnWQ023222;
        Thu, 10 Nov 2022 21:48:11 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2041.outbound.protection.outlook.com [104.47.51.41])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kpcysg5nr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Nov 2022 21:48:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EeJRl5WiDrae0mj6we4RDkK+jvoGwpwhwNn6v+8MTFvMRgov2KmR1aMdBwdRVArV+zXkyKwjH8VfEcqXdnGpdDNbavA9ApyYRTFsup0A56qcRrNfjC2Jh+m4gwkDunMAFsT9Zpd/SMtJ0xDiEt2bBqHut4SHJGUWWoyZVRQF7TQvqdZkD5DQ3BCOS/n/juU/Aa2Kmlxw1rw0oz0YFWI1UuzX9ytItOFyy9k8sv3P2NhlgJ6gmUhssAlYEHd+5lR0U2WfdsubU3uewJIN6jXKZFhSKOmzEPv5XYebUOqnprbhQeRJUPp4U99pHb3eLP6Hc0tj9mUcXfClrheuA8AXUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3EgRGDcmCoqGPwIBAL592LVO56lyJUVy79wdvS4VM/4=;
 b=iZb4HYKeBS4yKWpz9IAnEwdlvAXz8t3a5uehNezDhDMutuYFI7AXX+73sBEa3s+j5Vk5HYjuCdVIhjjqU2i6DOx2DCYDg4ZqE6DdQiGTpCziwacsHtIkkvzRUetXxWuxpuDCDwQFpFl1FMJ+X1n+9vxhXdwAtHqOIT6JsNuC/sIg83jt+vWQjNVeNL48tPeB1G+RpP2BLFXCZRzncG78evk9doKrLHxDVTRvY5baBDARryP38xUe3TVnpRzqOavtOAwayd6FZaXlM3ZyXDPwYsNCRFB0RWPIcFwgsAn93hguKufHuOr4OLMaDVnh9xovTepAc09equX8t+uhkmNXVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3EgRGDcmCoqGPwIBAL592LVO56lyJUVy79wdvS4VM/4=;
 b=BeI0Wuxqfje/2GnV923Tm03Bo+whohf7kKpzUMM+U2wtrl78auzLy5xLrvdLK6T9w4bdSQB0CWRCTjs2P2MFausdDZxKuU/dh6VsPmHCR4q12R84qEcrVuhh4drLnbnAZ+Aw5sKm+FsPonEG5bHenh2NDYRJ316iAL/zLTaom5I=
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by SA2PR10MB4809.namprd10.prod.outlook.com (2603:10b6:806:113::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.13; Thu, 10 Nov
 2022 21:48:09 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::8d67:8c42:d124:3721]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::8d67:8c42:d124:3721%4]) with mapi id 15.20.5813.012; Thu, 10 Nov 2022
 21:48:09 +0000
Date:   Thu, 10 Nov 2022 13:48:06 -0800
From:   Mike Kravetz <mike.kravetz@oracle.com>
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     Linux-MM <linux-mm@kvack.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        Naoya Horiguchi <naoya.horiguchi@linux.dev>,
        David Hildenbrand <david@redhat.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Mina Almasry <almasrymina@google.com>,
        Peter Xu <peterx@redhat.com>, Rik van Riel <riel@surriel.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Matthew Wilcox <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Wei Chen <harperchen1110@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH v8 1/2] hugetlb: don't delete vma_lock in hugetlb
 MADV_DONTNEED processing
Message-ID: <Y21xlgG6sxP6q5K9@monkey>
References: <20221108011910.350887-1-mike.kravetz@oracle.com>
 <20221108011910.350887-2-mike.kravetz@oracle.com>
 <9BB0EA0C-6E7C-462B-8374-5BFEC34E8415@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9BB0EA0C-6E7C-462B-8374-5BFEC34E8415@gmail.com>
X-ClientProxiedBy: MW4PR02CA0021.namprd02.prod.outlook.com
 (2603:10b6:303:16d::31) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4196:EE_|SA2PR10MB4809:EE_
X-MS-Office365-Filtering-Correlation-Id: cd050d71-82e3-4bff-1c65-08dac3654224
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8OGy20fBIpqAjvCWlf/5E/owOySj3lCk2inG652hct04hCXDII+b46MwuJioTqaf+XpnlTdGRXGI/xiFZxjjUS0RxKorbHgAcHD8DRnagJYxO+OLKMhm8lxSM+FCiYF4y6QBFfjG9waddxHoUa+UeCCX3C2/T0thIfw0nRVL9VS8ck2W7KiQKXH3faU0n6OukAqZipBkwGifoLsibpFa3QV4R3wIn0MhPjVJvfftR5RCnP9DFcxoajAAAQ35hr8vLnTPXX+7YjSQOXIIhI1CqS9Fo4RTz8mhsEXs310QNxk37B0U/W3dTr4oRhQ363qan9TdFoOmq77EKx+KkVlFj17553mWKrrus4zocdvJq7LAd/JI/yu3b1KqO4BAs3MS3+QZw2DyriXLfaOvTQha5+ejPTWp1KoGSZXe6YzqlZUQ00QSzlgm7zQlwKKm9HYNp3jRyL2p8kClGMrEuBClyc/LFqyiaOzLqDwvOtoADkjQuCTCTIfZT7azzR7n19hdMp3T13aqE6K3DIaHtlcuvCqu1h8b4Ai7YgHGETrsHPl1DT8mkNUgmnHIcqVTiNdknFAEUtQf8x8+w7ZCDBiKNJDDa/lwKpLt22HsX0A71hLmQycKgWdclJ2NbdQwv6OcEcR61x7WGbmzRaS5QFIpfaNBP74zHvaAc6GZFvD7lZJL5fzjjMhmmI6u93j9/7mWqGmRVfrtSdKOG+Hfk/khTg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(366004)(396003)(39860400002)(346002)(376002)(136003)(451199015)(53546011)(26005)(9686003)(6512007)(33716001)(38100700002)(8936002)(83380400001)(186003)(44832011)(6506007)(2906002)(41300700001)(66476007)(7416002)(5660300002)(8676002)(6916009)(66946007)(6666004)(66556008)(4326008)(478600001)(54906003)(316002)(86362001)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NWxUbmlKMTNlMDMyMnE4Y0EvWDRYczhtRFhTYjFURUVFaFVhL1lPSDNUUWgv?=
 =?utf-8?B?ZTFBL28wREJZd09oRzdDZ3RXTkp1aW9GMFQ3R0E3aE4yQUppUGI0RXhrQmhi?=
 =?utf-8?B?Z1l4NjA2NWJOWEZmVWZjZzBHMncyTnVXb3o1cmtNTm9PT2pKZm94SjRNYWpR?=
 =?utf-8?B?MjQzZzUzbFV6bXNhdzlTcXhnWmhHVmRuNXR0Z1UxSFRXcVRuUlowaEhVNVRJ?=
 =?utf-8?B?VURiR1JYWE9VSTRYczRGS3V5bzZnSUMwVVUrNFJwSnYwVzQ3U1dyYjhXRndD?=
 =?utf-8?B?b3N1VDl6MVlsby9mSjJyTVZQU0dyeCt4dGhxT0IreGlrM3lucnRzZk9QYUM3?=
 =?utf-8?B?MG9SenJPSXB6YXBUQVp4WVFPbS92MHp3K3pmTTVSRllmOWFWbFZNQ0hHcklZ?=
 =?utf-8?B?RUpYM0VhTmNnV0lIK1NtYXVJR3BISmQ3NDQvMjhpTHVoNGdTdG1EdG5ZVWgr?=
 =?utf-8?B?K2hmc1VSVnk4UnJpdnJqTzcrK1FoKzdBTTZ3NGtTMGp2Nks2KzlnVXVDdGFo?=
 =?utf-8?B?ZzVKWW0rUnhia21oZzRaZllUcVNwUklVdU5vNnNnRUFNTXNvY0I3U3RUazdq?=
 =?utf-8?B?MUtmOWg2V2t3aExvRDdOWCtYY0NRRFFEakRWOGo5cjFiNGt0QW9DZUJOYXZX?=
 =?utf-8?B?WUlPOGkvRjk2VVZta29saU8yYUlBbUt1SlUrVk1ZeWtBdndRWkprMExxdU9G?=
 =?utf-8?B?STlWWHB0N0F3R3lNKzhUVXJzN0pmRnpmcEgxZmdxN3BoSlR5Y25LSm9qRThz?=
 =?utf-8?B?UE9Za0NpZUhLREFPOHdDeGV6OGhBYjFjeUk1ci9kTGlKWlh0bWlYTVhrSjBG?=
 =?utf-8?B?ZHlNc24wUzU5WHN1OSt0d1JGT3FJVVlIMTFXOHN0cGV2MllHeitMa3puQ0Fl?=
 =?utf-8?B?TEZYcUVaaXJ3MFdQMDFDemNJTExtS3B5UEhOSEJyYmcwTnhkT2Q3U2tUM2tW?=
 =?utf-8?B?VmlVVUFLWXBwUWFMeC9Tcis3MFJha0R2a2paNkFoY3RRVUR5TUNWOU82V0tQ?=
 =?utf-8?B?RVAremhCSUdwS1ZHNGFPa0wvczdwRnJ4QU5ITmdMWWJkZHI5cXY1QlF5b1BF?=
 =?utf-8?B?ZG1NUjJVUzVHSnFROUFMK2Q4cVRaS0x2cFFDQTB1UHlHZ0FYTXo5eTlDWVhG?=
 =?utf-8?B?VFZnaGhpOE5DQUtIWnM5SkVxOTQrV1FkZ0FvR0NDU1VabVRvT0FIZ0ZZZ29H?=
 =?utf-8?B?N21pd2FPcWJVaUh3bEE5VWxYMFVpWE0zVG0xbXd0clErN1RGTmM4bXZCZE8x?=
 =?utf-8?B?TEhRSVNJRHJkbzkxNkRReVhSZmc0azE4dGVLWmNpSDIwU0s0NWZJVW5Ob0xu?=
 =?utf-8?B?VFVkQTUzQmpBS2dxSVdMNjlIZlRObnM1bGRJU2gwSjExOWwxVkVpajJxVzBO?=
 =?utf-8?B?QmVpdFpKaXpwK2o5cDJZeE5tVzNOMEJQeUYybDJvMGFtQ2tDY1F2am5UZ2xZ?=
 =?utf-8?B?ZVY2ZUdoeWhEWUZXOVprby9BZVJzTU9FOHVUUzFoejZrR3NpSlc2RjlCSk0x?=
 =?utf-8?B?cU02Zzk2NURPQVlLbGVnSkdRRS9xbXZDRTdKTFlLQ3NHeTA1RWxWR0JFOEdE?=
 =?utf-8?B?Z28zcllIUUZDQU1hMVZ6c1lscmc4UTlHQ0VkenJ0Nmwrb2E4Vll5bVE0N252?=
 =?utf-8?B?c2drSHJIU1hTazN0VXJKTjAzYUE5NTRmVXBGSTRmb05WUnBHNDB1ODVZcmkz?=
 =?utf-8?B?bVVkNVhkZGF4dUtGak82ZEFaL3E0L3VOZmw1bVJqMGR2M0ZUREo0L3BUY2tj?=
 =?utf-8?B?ck9xTFpuOGpqYWFpcndnN1BKbXN1a3ROR3RFOGY3VnkrcFpXeWU1SzUrbDN1?=
 =?utf-8?B?eDRiNEtSL2RsQTBKT3duajk4UkhFQVo1TC8vdm0wem9tUHUzYnIzUFJmWUU1?=
 =?utf-8?B?WUMvSGR4YzJ2M1drUDlhN3NycHBmQU94NVpidnN0YkFGQ1V6ZG11SldFOFhV?=
 =?utf-8?B?KzZlZVljMkdwQ2hsOFhmQ1p1MFFYYjhLWEZYZThRbXNPRXR6cm9nK3BpSE5s?=
 =?utf-8?B?RTFwa0VJQTdGYXNJQ3Z4dlBTZUJ2THJmMndjUVNxWmk2d3NkUXRmL010bjhw?=
 =?utf-8?B?VGhYQThkaGE5bXI5Q29SOXdDeG5vU2Y0YXV2YXRVRVlhRGJmSzJxZXFOSXBM?=
 =?utf-8?B?ZXJvUEtjazRuQmFVQVl5Z0VFalRNbzhibGtGNGhndHhEZm0xeU1nYzd3R3hK?=
 =?utf-8?B?UWc9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd050d71-82e3-4bff-1c65-08dac3654224
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2022 21:48:09.7635
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WecISwHLIMaf3Y1iu6GI6pY65VODZY2msx/mkD5VwzFjTY1HHYcB/LumbQzTyL2J2mhxfzcDyyNNbeNZgJGUXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4809
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-10_14,2022-11-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 malwarescore=0
 adultscore=0 mlxscore=0 mlxlogscore=962 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211100153
X-Proofpoint-GUID: teNL-r0dJZhm6nuRxriVEUW2yW3sNfCi
X-Proofpoint-ORIG-GUID: teNL-r0dJZhm6nuRxriVEUW2yW3sNfCi
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/10/22 12:59, Nadav Amit wrote:
> On Nov 7, 2022, at 5:19 PM, Mike Kravetz <mike.kravetz@oracle.com> wrote:
> 
> > madvise(MADV_DONTNEED) ends up calling zap_page_range() to clear page
> > tables associated with the address range.  For hugetlb vmas,
> > zap_page_range will call __unmap_hugepage_range_final.  However,
> > __unmap_hugepage_range_final assumes the passed vma is about to be removed
> > and deletes the vma_lock to prevent pmd sharing as the vma is on the way
> > out.  In the case of madvise(MADV_DONTNEED) the vma remains, but the
> > missing vma_lock prevents pmd sharing and could potentially lead to issues
> > with truncation/fault races.
> 
> I understand the problem in general. Please consider my feedback as partial
> though.

Thanks for taking a look!

> 
> > @@ -5203,32 +5194,50 @@ void __unmap_hugepage_range_final(struct mmu_gather *tlb,
> > 			  unsigned long end, struct page *ref_page,
> > 			  zap_flags_t zap_flags)
> > {
> > +	bool final = zap_flags & ZAP_FLAG_UNMAP;
> > +
> 
> Not sure why caching final in local variable helps.

No particular reason.  It can be eliminated.

> 
> > 
> > void unmap_hugepage_range(struct vm_area_struct *vma, unsigned long start,
> > 			  unsigned long end, struct page *ref_page,
> > 			  zap_flags_t zap_flags)
> > {
> > +	struct mmu_notifier_range range;
> > 	struct mmu_gather tlb;
> > 
> > +	mmu_notifier_range_init(&range, MMU_NOTIFY_UNMAP, 0, vma, vma->vm_mm,
> > +				start, end);
> > +	adjust_range_if_pmd_sharing_possible(vma, &range.start, &range.end);
> > 	tlb_gather_mmu(&tlb, vma->vm_mm);
> > +
> > 	__unmap_hugepage_range(&tlb, vma, start, end, ref_page, zap_flags);
> 
> Is there a reason for not using range.start and range.end?

After calling adjust_range_if_pmd_sharing_possible, range.start - range.end
could be much greater than the range we actually want to unmap.  The range
gets adjusted to account for pmd sharing if that is POSSIBLE.  It does not
know for sure if we will actually 'unshare a pmd'.

I suppose adjust_range_if_pmd_sharing_possible could be modified to actually
check if unmapping will result in unsharing, but it does not do that today.

> 
> It is just that every inconsistency is worrying…
> 
> > 
> > @@ -1734,6 +1734,9 @@ static void zap_page_range_single(struct vm_area_struct *vma, unsigned long addr
> > 	lru_add_drain();
> > 	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma, vma->vm_mm,
> > 				address, address + size);
> > +	if (is_vm_hugetlb_page(vma))
> > +		adjust_range_if_pmd_sharing_possible(vma, &range.start,
> > +							&range.end);
> > 	tlb_gather_mmu(&tlb, vma->vm_mm);
> > 	update_hiwater_rss(vma->vm_mm);
> > 	mmu_notifier_invalidate_range_start(&range);
> > @@ -1742,6 +1745,12 @@ static void zap_page_range_single(struct vm_area_struct *vma, unsigned long addr
> > 	tlb_finish_mmu(&tlb);
> > }
> > 
> > +void zap_vma_range(struct vm_area_struct *vma, unsigned long address,
> > +		unsigned long size)
> > +{
> > +	__zap_page_range_single(vma, address, size, NULL);
> 
> Ugh. So zap_vma_range() would actually be emitted as a wrapper function that
> only calls __zap_page_range_single() (or worse __zap_page_range_single()
> which is large would be inlined), unless you use LTO.
> 
> Another option is to declare __zap_page_range_size() in the header and move
> this one to the header as inline wrapper.

Ok, I will keep that in mind.

However, Peter seems to prefer just exposing the current zap_page_range_single.  
The issue with exposing zap_page_range_single as it is today, is that we also
need to expose 'struct zap_details' which currently is not visible outside
mm/memory.c.
-- 
Mike Kravetz
