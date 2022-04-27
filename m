Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96702511045
	for <lists+stable@lfdr.de>; Wed, 27 Apr 2022 06:46:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357672AbiD0Ett (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Apr 2022 00:49:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237234AbiD0Ets (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Apr 2022 00:49:48 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D6BC3121B
        for <stable@vger.kernel.org>; Tue, 26 Apr 2022 21:46:38 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23QM7wwY011361
        for <stable@vger.kernel.org>; Wed, 27 Apr 2022 04:46:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version;
 s=corp-2021-07-09; bh=kPyJsapgX323ThDmxbmzYeIPVtHLuS5rrcwEzgjNFbQ=;
 b=ZegbHl8zhcnOfGjsSVHsJNYrSjuP3vb6s29qKjoC/TrsckgIHyNInmqRgJJKDTjwqYot
 5Vs2met43LYuF/D81+iIqMXuxL7riC+1ACqb7Jhh8d3sy4I1aa5uy6Cty7xb2Q8eO72y
 W7/vJDvVbk/0qTT5rkvwE3yILUhR7Jfdz195yv8lPaBEITuWHvBU3pazH+Z/TNILP7SA
 tfORCrevO0SxlOFyfnCoXB62k43mLLKTVVFLkwazlORc244Q5refTZLLNR8xXjqA5mx0
 eS8h5T2REKN3Z9T/SwqW1DUDqbuycJVMu8mV3f3ZqMIO3z7iWHzAJ57dcpgxtcZdv8j4 OA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fmaw4fxth-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <stable@vger.kernel.org>; Wed, 27 Apr 2022 04:46:36 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23R4kYnK017511
        for <stable@vger.kernel.org>; Wed, 27 Apr 2022 04:46:36 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2046.outbound.protection.outlook.com [104.47.73.46])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3fp5yk7ujt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <stable@vger.kernel.org>; Wed, 27 Apr 2022 04:46:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bQI1lT6CVn5BDDS1j62NHsoqt69F2aq6o5Osg9o7TYVm47H62u6TqN/cqrQ0Bv2m5fk9pL1zRKYeAVSLi/hUWpZBT9cteLWwtpQsv1MSYcjlwtFavjhdVK30q3zPnD3XjtaZAuGSgCqxmBtMLcV370k6HTBhpKP3gLF091CWMsjugD54w/ijcWAVS6QTuAiWoqwOc8Q/Wf3c3LYELxVRl3EhvJUtKjpbpu3dCKxynJuYmN3lQgIpuFHpGcLX36PxntbIIrw7Ieh4tydBvkh4rVaKgJ5ixJh9oBWHCS1kU0pvdl09B5tYTP5WbS/LP5aFswUQfvO7SyGdXbk25cW9XA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kPyJsapgX323ThDmxbmzYeIPVtHLuS5rrcwEzgjNFbQ=;
 b=LKtI73Or30r3OpAfxe5BTtQfdyb1oUIVp9GzvyLs1ARBlDfw1GvHuAoEDu7TwHvcRN80JP9HVQRibdYCqbxt2rUcgd5EGuy3Paf9ooteHNpt3QwYHeDBtZ8Oef7MhoPCauuDDreX6eHAxE6+Rptf956bUY1y+Ob5knjkA3bRhbStl4w2SM0w7pM/uN6KdnZ4V+B9C8xcmDRIUPTee9bCiPrUd96t9tRNwDCE7MH+Oa6GhVtyIPP8XD9ppusbSJhtbE4eGHgzUW18ufYt248G8m+s7zDfXrHBEoFRrkNjU8eh8hXpQl34JSUVC2nuRxwFwNH5i0tssceycUOQ9IGe3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kPyJsapgX323ThDmxbmzYeIPVtHLuS5rrcwEzgjNFbQ=;
 b=ujh5iq6yM/EFBfcOXjCCzTgE/91uTIk59j5KduwytZ/V39ENzRyDNc3yVRcD493tlFgPQjl0/OBqK3pHrjzidsLQYk03y8oBOeNYuCUc9UFgITpCl6GK9j76ggCbl8fW8syhtTJn5PA1k+gZfdS0U3/MI7MXVekpxssBwMUNXHQ=
Received: from DS7PR10MB4861.namprd10.prod.outlook.com (2603:10b6:5:3a7::15)
 by SN6PR10MB2512.namprd10.prod.outlook.com (2603:10b6:805:47::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Wed, 27 Apr
 2022 04:46:32 +0000
Received: from DS7PR10MB4861.namprd10.prod.outlook.com
 ([fe80::f0d1:1609:2332:c2c]) by DS7PR10MB4861.namprd10.prod.outlook.com
 ([fe80::f0d1:1609:2332:c2c%6]) with mapi id 15.20.5186.021; Wed, 27 Apr 2022
 04:46:31 +0000
From:   Partha Sarathi Satapathy <partha.satapathy@oracle.com>
To:     linux_uek_grp@oracle.com
Cc:     stable@vger.kernel.org.#.v5.8+,
        Partha Sarathi Satapathy <partha.satapathy@oracle.com>
Subject: [PATCH 1/2] mm: fix VM_BUG_ON(PageTail) and BUG_ON(PageWriteback)
Date:   Wed, 27 Apr 2022 04:46:28 +0000
Message-Id: <1651034789-32295-1-git-send-email-partha.satapathy@oracle.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-ClientProxiedBy: BL0PR0102CA0027.prod.exchangelabs.com
 (2603:10b6:207:18::40) To DS7PR10MB4861.namprd10.prod.outlook.com
 (2603:10b6:5:3a7::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c96f3cb0-9263-4be4-cae1-08da2808e61c
X-MS-TrafficTypeDiagnostic: SN6PR10MB2512:EE_
X-Microsoft-Antispam-PRVS: <SN6PR10MB25125E0487663CC34A527C38E0FA9@SN6PR10MB2512.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DXqoztAiAWbz265skmaIwOeyTeNPEx9OVNVI/aiXCeFpwkMFUENF2frA1WlG/iELXu8j/gZGhCnezMNn+nEK3Ed5ounlx/1rRQszmtxOCLCrSZpzBYNLM1uRuYxbGP9f5Aww6rZvQb1nL7IS8PhPF09R4y6ja3wuWcmwnJ6cRiGFP/iM4bJdPBkTelYOwaPmD3BpJ76ton4k/1OAozPyjVbXzy1fec49o7MSl13ymMMNQHj4+Fd93fBCMujVSrLvUSa+nZkvRNDmS/b2JIPg+lGYhpeiNc/s3iOZeY+sWd1dFGrol/x9ZEdJALVuEKBFlqzVrKPffzVWFZlNJxWy49dxqQvtUkiHOC6S/3vLxDFgnRfQulUN1VLgVlrPTLo/kktiOu8f25nNyAQ8jgN42e3161gTyjgVwjhKmJ1PIfh0BuawBNLlz6f9dneFGi+OCYUBWd5mYdgTxC9B0O+pvxso8ElN/45p3CocSMABWxG7xRUCO1fAvEkYJxJAF20u06Cm9ngwJKm9gbySEEDgjzDbEvRAd9jUkJd1SDVq6jf1DNvf1gppBXkqucAIB+liktHhvTZrVJLjJ+lFsmP03WmxCdxdlf0cqATqID3fA90UtWLL7M7ga2+4xZVlTd0htxdS5G1dpABWfUWi4CASgfMe9d65oZK8PxfpL+q7hYRRWwvVrZpF95TWKrp8PtaglObWz6Zo+JYIsBt09MXa3zK8V3EpagPGR1FI8c581n24gF/gmx0DEfVCCt/iFDfAhgm8kKpEGymfkh7vbnM5H78Mhbs+ueOOuIzeEDvsccs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB4861.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(316002)(2616005)(6506007)(38100700002)(5660300002)(38350700002)(52116002)(107886003)(36756003)(86362001)(8936002)(508600001)(8676002)(4326008)(966005)(34206002)(6486002)(6512007)(83380400001)(6666004)(26005)(37006003)(6636002)(66946007)(66556008)(66476007)(186003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DjuRC0hI7qJGB5S2CzSVKkEpnIalZTDpB13TzqiUX7HzAha5XWvIUSJycPgw?=
 =?us-ascii?Q?RNn5nnPYW/YSztC+Zx78TdSh3DUldnChmjYFlCTun+tpPuJsKtCCJ7epKWaR?=
 =?us-ascii?Q?sKn1yR1uXUNKoAvvtgnZ+iZzzSYJgQQo9K1e/g3c8X8CVFGHQcNJq9Lo6Qb7?=
 =?us-ascii?Q?AXxhVYm2Da52ktEY8Ngw2KznDDASaVxTYREPgJM7ZcA4MmHOnYxBcTBo95qI?=
 =?us-ascii?Q?GfKwtFNK7smxvFkBOq1h/1MssUxEYpbY91aZW0fAA/112btzzXSA5LkaFQrt?=
 =?us-ascii?Q?gvBUtzLbLixxp0LqZxiF+7+4vfX8WY/qb8RhGSU1eYBGL/fwao3GzGvqA2h7?=
 =?us-ascii?Q?xyl/GYXOjHxsxmyhBBy2ezrL/PnE5oMxphpVevBHGXKrr4N1hYVDr7gFrDfm?=
 =?us-ascii?Q?p3sgeSIwBbI8MKAZCpRphLEh8Hd7Gth+cTOdiMVJk9WGaiNfLkUHEydjjnDe?=
 =?us-ascii?Q?p1iCOfALAloUMgB0Bm35i/I/qmEszsNCTwDzm6K5UGX78+T7ujUAK18qDLyZ?=
 =?us-ascii?Q?T5mPncpjaJq2URaWogbckhvT6emmu+mQdxNC4jDcIx8z5x6V8EvNTd1wBIzm?=
 =?us-ascii?Q?VaWFC023FemCyXZdZbRkJGLhgRnqsbPxQgkrabb07lL0FMzal9mnSaykURzr?=
 =?us-ascii?Q?l7O7w8rAR3ueA44Rw0WTfNumSlOj/O3Li9GWB6V+36xkSlEg4pz4fC8c6sSq?=
 =?us-ascii?Q?A1BxVO9n/6CZ1gz4mU8K+KEvQBuvo4zPqG6jvpUzy7TTusw4t2O7YAcpG9cu?=
 =?us-ascii?Q?l76qdzhg7eGalNxgo8kNfS79P/P/lK/dmIs1khAPBmTB7vR+dmOQdAfuqmzM?=
 =?us-ascii?Q?NlnOjXadnjBouBon4ZayGEHcZH1OGPEK+A7tu7eb8oFRiKJOrve0yvY+R53M?=
 =?us-ascii?Q?Wii8rDAQlVb3GmjcL+9pFQVhBH8LK86o20HKev8UdmCKP4XQgMMjmC9GXMpV?=
 =?us-ascii?Q?6wl2zMpXx5p5h8f4FOA2v/MYWHXApTYVkBiRHYJkG+5bDF61Ic4cWFIR0XP/?=
 =?us-ascii?Q?JxxMSQkX+b1rH2uoLuHG0mMT3bQVkp047dJwz5xeNW5IKJOf4x3I1NYC6EQ2?=
 =?us-ascii?Q?4o9K5EBSkp2kmmDN7PdAkqnmIJDsegMEuaP+gPfR4dRNxRx8ecgio6pCzx2s?=
 =?us-ascii?Q?bac5qBROnno/sOUqJ+0OPh1xAsT3+hbChiPx3Twsjp61EEiHa0j19XIWkqOs?=
 =?us-ascii?Q?GJBbm8tBOxHt9hAyClyv5iGe6Bf/ZVpcq6VGOr6MDbX/EzBDRv59edS78WX2?=
 =?us-ascii?Q?bYTAWpviyfFrMtj155gt+SultpLTQ9J8TJvwnTWkJ4TCNwGrBo1fpwThn8A1?=
 =?us-ascii?Q?ADgyK7j+KOpDh0K5iqf5nGCngqwjotXJEjiglnDC2gtSy6w+eYS2wh71Ru4Y?=
 =?us-ascii?Q?c3T89CQ1Be6eKDyUScmYwB/cPc5XuQpD3ttaAV8tVUIBY5G0DcPF68xh6wK9?=
 =?us-ascii?Q?DLm/TsoCMuylaH/sx4R0cwGI1afDygD8MheGhaxGPoGqbRa8JD2h0p2J0NrW?=
 =?us-ascii?Q?yjhPG52+dqkI+SXH983xekbDuTXvL+E5p2C6PCblOVuT7EX6PTFBVmDqNXZG?=
 =?us-ascii?Q?RsNenZnBgDLd3OFGyG0bNhmbRnc68h48j8qfavOysxdXDSLaQo1eTgUXiACC?=
 =?us-ascii?Q?vxBNzOm8bPBdT4Zb1ZB4V+9a6oedJddXSbJpzxib6QwxXNPHAseS7PXb5aZN?=
 =?us-ascii?Q?SflKzr7ya79DLQAzF0X22OuAn3Z9/ww2HNX1tBZ/Mio7bGQYqFHI+kNdo1MM?=
 =?us-ascii?Q?KE0G9YjWZGSXKpDMs1h7oang8hENeUY=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c96f3cb0-9263-4be4-cae1-08da2808e61c
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB4861.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2022 04:46:31.3418
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 38uNX8c0Tdo3BnUm7hadzcAtLpCHdeYk0ndZj6YkV2MIBIHV5gTLztAlb1EezHnkh0QVvkPqNCPX+0hdmQ9MUH5yajlzatdEfe0C39pbqMg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2512
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-27_01:2022-04-26,2022-04-27 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 malwarescore=0 spamscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204270030
X-Proofpoint-GUID: FFjYOId8DL_oVhR8H5NQD4fWZ3z0RFbi
X-Proofpoint-ORIG-GUID: FFjYOId8DL_oVhR8H5NQD4fWZ3z0RFbi
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hugh Dickins <hughd@google.com>

Twice now, when exercising ext4 looped on shmem huge pages, I have crashed
on the PF_ONLY_HEAD check inside PageWaiters(): ext4_finish_bio() calling
end_page_writeback() calling wake_up_page() on tail of a shmem huge page,
no longer an ext4 page at all.

The problem is that PageWriteback is not accompanied by a page reference
(as the NOTE at the end of test_clear_page_writeback() acknowledges): as
soon as TestClearPageWriteback has been done, that page could be removed
from page cache, freed, and reused for something else by the time that
wake_up_page() is reached.

https://lore.kernel.org/linux-mm/20200827122019.GC14765@casper.infradead.org/
Matthew Wilcox suggested avoiding or weakening the PageWaiters() tail
check; but I'm paranoid about even looking at an unreferenced struct page,
lest its memory might itself have already been reused or hotremoved (and
wake_up_page_bit() may modify that memory with its ClearPageWaiters()).

Then on crashing a second time, realized there's a stronger reason against
that approach.  If my testing just occasionally crashes on that check,
when the page is reused for part of a compound page, wouldn't it be much
more common for the page to get reused as an order-0 page before reaching
wake_up_page()?  And on rare occasions, might that reused page already be
marked PageWriteback by its new user, and already be waited upon?  What
would that look like?

It would look like BUG_ON(PageWriteback) after wait_on_page_writeback()
in write_cache_pages() (though I have never seen that crash myself).

Matthew Wilcox explaining this to himself:
 "page is allocated, added to page cache, dirtied, writeback starts,

  --- thread A ---
  filesystem calls end_page_writeback()
        test_clear_page_writeback()
  --- context switch to thread B ---
  truncate_inode_pages_range() finds the page, it doesn't have writeback set,
  we delete it from the page cache.  Page gets reallocated, dirtied, writeback
  starts again.  Then we call write_cache_pages(), see
  PageWriteback() set, call wait_on_page_writeback()
  --- context switch back to thread A ---
  wake_up_page(page, PG_writeback);
  ... thread B is woken, but because the wakeup was for the old use of
  the page, PageWriteback is still set.

  Devious"

And prior to 2a9127fcf229 ("mm: rewrite wait_on_page_bit_common() logic")
this would have been much less likely: before that, wake_page_function()'s
non-exclusive case would stop walking and not wake if it found Writeback
already set again; whereas now the non-exclusive case proceeds to wake.

I have not thought of a fix that does not add a little overhead: the
simplest fix is for end_page_writeback() to get_page() before calling
test_clear_page_writeback(), then put_page() after wake_up_page().

Was there a chance of missed wakeups before, since a page freed before
reaching wake_up_page() would have PageWaiters cleared?  I think not,
because each waiter does hold a reference on the page.  This bug comes
when the old use of the page, the one we do TestClearPageWriteback on,
had *no* waiters, so no additional page reference beyond the page cache
(and whoever racily freed it).  The reuse of the page has a waiter
holding a reference, and its own PageWriteback set; but the belated
wake_up_page() has woken the reuse to hit that BUG_ON(PageWriteback).

Orabug: 33634162

Reported-by: syzbot+3622cea378100f45d59f@syzkaller.appspotmail.com
Reported-by: Qian Cai <cai@lca.pw>
Fixes: 2a9127fcf229 ("mm: rewrite wait_on_page_bit_common() logic")
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: stable@vger.kernel.org # v5.8+
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
(cherry picked from commit 073861ed77b6b957c3c8d54a11dc503f7d986ceb)
Signed-off-by: Partha Sarathi Satapathy <partha.satapathy@oracle.com>
---
 mm/filemap.c        | 8 ++++++++
 mm/page-writeback.c | 6 ------
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index dc20b49..336a065 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1366,11 +1366,19 @@ void end_page_writeback(struct page *page)
 		rotate_reclaimable_page(page);
 	}
 
+	/*
+	 * Writeback does not hold a page reference of its own, relying
+	 * on truncation to wait for the clearing of PG_writeback.
+	 * But here we must make sure that the page is not freed and
+	 * reused before the wake_up_page().
+	 */
+	get_page(page);
 	if (!test_clear_page_writeback(page))
 		BUG();
 
 	smp_mb__after_atomic();
 	wake_up_page(page, PG_writeback);
+	put_page(page);
 }
 EXPORT_SYMBOL(end_page_writeback);
 
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 2d658b2..52d3006 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -2746,12 +2746,6 @@ int test_clear_page_writeback(struct page *page)
 	} else {
 		ret = TestClearPageWriteback(page);
 	}
-	/*
-	 * NOTE: Page might be free now! Writeback doesn't hold a page
-	 * reference on its own, it relies on truncation to wait for
-	 * the clearing of PG_writeback. The below can only access
-	 * page state that is static across allocation cycles.
-	 */
 	if (ret) {
 		dec_lruvec_state(lruvec, NR_WRITEBACK);
 		dec_zone_page_state(page, NR_ZONE_WRITE_PENDING);
-- 
1.8.3.1

