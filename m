Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFA90501E76
	for <lists+stable@lfdr.de>; Fri, 15 Apr 2022 00:31:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347211AbiDNWda (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 18:33:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347197AbiDNWd2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 18:33:28 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B959C55A5;
        Thu, 14 Apr 2022 15:31:01 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23EKX5sh008564;
        Thu, 14 Apr 2022 22:30:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2021-07-09; bh=8Ct0seMaWqqoEdaNRFLwwYNLam8EXfh3cGOja5tWS8Q=;
 b=iukYm+sGpreU7G1lK8sCZZQ6reesM4EAAwugHfsDR1nl0+wW6wLHELYaHSTEzlTf3RWa
 pQ2HpgOeUikqnvIWLqJhZgwyBGVCCNSqwTeBXOV1jPph8YS62AakKxTisXZp+oKjM0MZ
 P6tlquY4vdCnYKXuEI/MNWyOXDCuw7V1eS5l3URPAyZ54vuMRBfDgsv8fQRAd7IcoLya
 eDlOUWJ0LsOr2v8I0OugQInh1zrOXkxvsoDfMUayQT9zcQwgnSsjXGmPwrPsg84KPnO0
 CVjK7D/09IhzjgfP1AwRcdEniTdBK1lhZsACHE/reh3u4mG7BYVOD6kkkmeJPA0ihZbQ rg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com with ESMTP id 3fb0x2p3w1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Apr 2022 22:30:57 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23EMFowJ006346;
        Thu, 14 Apr 2022 22:30:56 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2047.outbound.protection.outlook.com [104.47.56.47])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3fb0k5p5n5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Apr 2022 22:30:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kE2evXRAoPyUgZowN3pAURGl0LFV9F4CprqiiFeMmHrjnqP+/ELL4NYsbzFKzAwAikD+9xFGHxliFWxTrMgcKPcfpxujCFfeA7ky1AsHf0T+9eegdfpxQD5Dqc7yivRlu63mz0Lw0lVgba3e/kAlkzyAHtmKmJo1Fq1gX9W+kUs2hGeNPqOtZR+qGiLhylmsyWvUYAZjTNeSIVJemA5d6z6N9Nane82BI913fyEC4UxNWzq9XvGy+oTPHOKe8FFtHq+Io4vs/qQtSGbIVb5Hkee4JceEIG+L8HqXhaQT18btd0z2yz6Kr41jLkdU8DxQKwWuQI+TRRSr0+R9bg/C/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8Ct0seMaWqqoEdaNRFLwwYNLam8EXfh3cGOja5tWS8Q=;
 b=UJuWzo/Ghyl1zVucu2mHttCFuK6yZYW8+NBPmPgKDF4ZMZXBUwbQFBC4MvQ13upQ00JjN6fWR5jUZ68CyAoI4VgDT3GUkmFSe1hOMyaSekIYOXUtH8z45ZvAg+rB+O0SOKPl6qHADHg27CT1YWdJfqKEYBQwA9z0Y4ZcMy1ROT+j3A8nkgBrNEJbd1sv/zmVlpxCAhZAMvv3jTyB0+AQPkOxaSn4Omn42Eb3oNJrpmdub49yqyWdgiv9jwLnxlqkOn3rR2eDcOFwov3ITUwWXD0P90Rj2gGl8r3Gy1GlGd+wraDt0lA4HV0RU1sZPdnTonrVa91T0itcH4jGQ6tZlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Ct0seMaWqqoEdaNRFLwwYNLam8EXfh3cGOja5tWS8Q=;
 b=xLsi7eQQNA7uXdZitlChnUVlxRtG15yt2M8ScHyB7sY6J0Bf9SDH2M41Jx28G4/vDmRg7HWl9B3zshlumb7R1zc2OR0zTsIcCOxMF6XoyAOXh5Q3XiaVd4pk2T88plvTjTVZkFjZS+RuadhYpL2Bvs0/9k78flmWzkEoJBcsMFw=
Received: from PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
 by CO6PR10MB5572.namprd10.prod.outlook.com (2603:10b6:303:147::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Thu, 14 Apr
 2022 22:30:54 +0000
Received: from PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::d414:7654:e1b8:4306]) by PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::d414:7654:e1b8:4306%7]) with mapi id 15.20.5144.029; Thu, 14 Apr 2022
 22:30:54 +0000
From:   Anand Jain <anand.jain@oracle.com>
To:     stable@vger.kernel.org
Cc:     linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Anand Jain <anand.jain@oracle.com>
Subject: [PATCH v3 16/18 stable-5.15.y] btrfs: fix deadlock due to page faults during direct IO reads and writes
Date:   Fri, 15 Apr 2022 06:28:54 +0800
Message-Id: <b3ed77a21e8c9b82b32a044aac971feaa0a893e0.1649951733.git.anand.jain@oracle.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1649951733.git.anand.jain@oracle.com>
References: <cover.1649951733.git.anand.jain@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCPR01CA0057.jpnprd01.prod.outlook.com
 (2603:1096:405:2::21) To PH0PR10MB5706.namprd10.prod.outlook.com
 (2603:10b6:510:148::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 40c51a68-596b-4e51-c5b7-08da1e66700c
X-MS-TrafficTypeDiagnostic: CO6PR10MB5572:EE_
X-Microsoft-Antispam-PRVS: <CO6PR10MB55728F207E926C8A2DCDF05CE5EF9@CO6PR10MB5572.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TI3sZyRMKyev6VDK31z2YoAqe+TXgncBuXJSGJKBAW+ooo1jfABNxI1crhRaTHxH/d5ulA/9nJp2JAvLh6hOWC7/U4jRI0m6gtfVOzNONyQjC9He3O3Bh5bXL8rOdw9ml+5mRfUrqLMHd/px6KlAswr37VH+X99D1D0gT9eb2DWvQwvPZSeAx3fAQ1WuHTGB1njRNXZ/LaeR7+hyM1jBZ5KDRd8QOCrBTo5u2/4/e1AT2H+ywvV+Jqp0O/K8jy8n17Vh+JtrM6tfcBmuoHmOKIKR+9unqig7kfpFxl/lbJ1trfTWSjfsUr0tShklqMZgtrNU50kkDV8AAqekVKALHBRF0Pc8fTn88TTlO0okdKmJivLKR/lbpBokx12kPYJrbgX7DDpHUTqCWVvXDm43zzxd65gznGSOCDH1Wc1b/g1qc0iA04T62QU8mRTUzKqfidoSQoO77n+E1Y96pUCFeRwRTMyoR+/Rt2eOxpKQZox1kEUcRsqWtLEe5256dCl4O7Fk3y2zVRUiUGvLqEya316IxE3S6RKvW3iPY4G1/6tOIYebPQV6hfnDQ1PnAq2m6WQD3x5u2YXyjkZtTJybxKVliwSRMfHrHPPA33wWD54QNub0OEWYQz11aJU4e9PcJFmr1wfGlJh7MmPQUAe/VA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5706.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38100700002)(86362001)(6512007)(6506007)(2906002)(4326008)(36756003)(66556008)(66476007)(66946007)(508600001)(8676002)(6486002)(44832011)(83380400001)(107886003)(8936002)(6916009)(5660300002)(316002)(2616005)(54906003)(30864003)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tnbXDicVn1eFPJjtc+/CHHDUXhUq329/Y2zmWpHAj0joTVtP6dPT39eAiiW5?=
 =?us-ascii?Q?4wZ7QblQ3rO7VC8fvxExa5/IZr1mQAZ+bVqZ+f+xZqKzpRd4bEjYvhHc95VC?=
 =?us-ascii?Q?TqdWyhX7WELRq3OXyBwE5qa8AkjZaD90cUk8swk2MXYTdCDfolCXUhzW9RY2?=
 =?us-ascii?Q?4tWls9hfSVZFjePRru+h7wnrmcnG7l+vmCaMRK1GVtKBcxPdfYmeJR5D6NkL?=
 =?us-ascii?Q?FwDjerpEJHa5fREFkC/I7wanc4F7vB5U97KYiorjmKjmOZijzIc8TmYDL8tn?=
 =?us-ascii?Q?zuvZ7sAMStN3sH3fxIkU/9/5dLBJLokpt6S2sTRM1xFW0qFVWtO+0vAwUBhl?=
 =?us-ascii?Q?fGCeLt+DEED5OjMYPc0+tSAXJr0tPUHWx6B+XLrVuYu5pW8ZtC1HQs7Pgimd?=
 =?us-ascii?Q?GJPpIItj8f24HraocEWu0l3Nc/ZWI4iTJjix9lzPRZeEnImmmvlHlz590rQX?=
 =?us-ascii?Q?RKXAUvxUCQ+xf2Cc0PF+eF9K22ZtUZrlhhlMG9inZLG14NWItN7cJSHXfXFT?=
 =?us-ascii?Q?WzQGJKxqoJisnREVOufidvs9rNpVNRZFQ/OeC09Jt/MV15G8yWXvZVmiNXka?=
 =?us-ascii?Q?vL1jpdkMdkJ5E6WaWvT/aEoE+/MXkIuiaw8H3/IG3g+8UFUP8pRmreP1vSyi?=
 =?us-ascii?Q?TxW6vluC6D2G7nr0mBOKjl5HRPDLwd6HDcGUFheoLX0g61ogaxwy3Dph0Ac4?=
 =?us-ascii?Q?r5Kl7f0VVuj7eG3k2LbvVbFBmdFF+OUrmfl91NfQYkOWllwvn6mRZBDr28us?=
 =?us-ascii?Q?VM32kA/LECCxtPw+4VMXzvssOxZSiJXUlYybrA6FsiGkYlXNUfQZEkrI3N6s?=
 =?us-ascii?Q?AWuiqsJaJrPApLqTSQ8T42/OinOTOSBba1FpvwJsA3iGXKdge7Jx2YiXC6x1?=
 =?us-ascii?Q?care4bjIe+xLsL2RR/bAvqyFNRj8+ISwl6kb3Q+QxKMhk+XfjUYNYea8QaYM?=
 =?us-ascii?Q?gcnFD2Df79ooveWS/NYfSRIHZoI+d30mx5o+DhDnqyn3bNPVwfGn77L9/lpe?=
 =?us-ascii?Q?cjZJ/fmtQqwZMxKtPVSVlqlI5sTYs7OYQojRf0cfbmTsw6+hVkOqPcuGOkUW?=
 =?us-ascii?Q?n5N3XNfYQNoDu5Ba3AODNAT2zIa/qcSGuhLochqTb6pocoj2YlUawNnhF56w?=
 =?us-ascii?Q?OYQAseFJsN0vcrIcEjP3WkSiS15I4JLn3KYW2Qex1KenjtkliNIm2NNA4G8i?=
 =?us-ascii?Q?2+0W/PeaqOGOWEqjaDV20l6slCiZsiKlWmwOpTeGxS9jEYSqE5FaFbJEnmuj?=
 =?us-ascii?Q?viMT304NaK6oVRNd/79VqDv/e8jhEBHU4PqyjWqXoXMUUhidXlpUGpxnAZpG?=
 =?us-ascii?Q?Dr37gEKt04ZTR2oG/iaUCRxehH/UUHme0xphslMipUVum2E97UN3kaw6Iasp?=
 =?us-ascii?Q?WB/EaZO6k/dbPO2qFL24mCHv4VNvdc5DQLpghN7yMJlyEW3N7iUP0j276fMN?=
 =?us-ascii?Q?6sp9fbb3FPp45uUD+NfxoEELdP5JZKiiA0QC/Wv2uSOTyXKEOLE6fZ5xho7m?=
 =?us-ascii?Q?lE7Z2PWg5mymuf+GbNDQF165tQGfIYoXTa2hyRHy8rOaTKF02zGs+aJx5WuY?=
 =?us-ascii?Q?gaMdYBEKUPg87UfceGLT4IorL7edKky5N46Ls908bU9FMU5dxT0N7pQ8sG3p?=
 =?us-ascii?Q?vtyeLvxOsFP16M0NILZ/Zkjuikp4+lahzYEa087T/Y0otBL3kA5dLMC4K6Do?=
 =?us-ascii?Q?wQwiu+RfcgYKKQSQgEQENL7l7lz6xFTxORslDIYAZsMlNff6BNlXug82gwUT?=
 =?us-ascii?Q?29BKIBelFgQOKfeZJKRKbJ2faSbr6oH6fjj7mf7n9XVWxH/h6aSF?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40c51a68-596b-4e51-c5b7-08da1e66700c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5706.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2022 22:30:54.3134
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u1U7EgH25XspZ7Z4ziJiUX6O0/dPrBomqtrL5mumh+rp8Hd0tsdeQYyqBsUAJ2g50Pbx3fJ9VhGSiNF/oTy1zA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5572
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-14_07:2022-04-14,2022-04-14 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 phishscore=0 suspectscore=0 spamscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204140116
X-Proofpoint-ORIG-GUID: j8yxx6EPSSgrTdfMLy8KiM3q3uVbQDck
X-Proofpoint-GUID: j8yxx6EPSSgrTdfMLy8KiM3q3uVbQDck
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Manana <fdmanana@suse.com>

commit 51bd9563b6783de8315f38f7baed949e77c42311 upstream

If we do a direct IO read or write when the buffer given by the user is
memory mapped to the file range we are going to do IO, we end up ending
in a deadlock. This is triggered by the new test case generic/647 from
fstests.

For a direct IO read we get a trace like this:

  [967.872718] INFO: task mmap-rw-fault:12176 blocked for more than 120 seconds.
  [967.874161]       Not tainted 5.14.0-rc7-btrfs-next-95 #1
  [967.874909] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
  [967.875983] task:mmap-rw-fault   state:D stack:    0 pid:12176 ppid: 11884 flags:0x00000000
  [967.875992] Call Trace:
  [967.875999]  __schedule+0x3ca/0xe10
  [967.876015]  schedule+0x43/0xe0
  [967.876020]  wait_extent_bit.constprop.0+0x1eb/0x260 [btrfs]
  [967.876109]  ? do_wait_intr_irq+0xb0/0xb0
  [967.876118]  lock_extent_bits+0x37/0x90 [btrfs]
  [967.876150]  btrfs_lock_and_flush_ordered_range+0xa9/0x120 [btrfs]
  [967.876184]  ? extent_readahead+0xa7/0x530 [btrfs]
  [967.876214]  extent_readahead+0x32d/0x530 [btrfs]
  [967.876253]  ? lru_cache_add+0x104/0x220
  [967.876255]  ? kvm_sched_clock_read+0x14/0x40
  [967.876258]  ? sched_clock_cpu+0xd/0x110
  [967.876263]  ? lock_release+0x155/0x4a0
  [967.876271]  read_pages+0x86/0x270
  [967.876274]  ? lru_cache_add+0x125/0x220
  [967.876281]  page_cache_ra_unbounded+0x1a3/0x220
  [967.876291]  filemap_fault+0x626/0xa20
  [967.876303]  __do_fault+0x36/0xf0
  [967.876308]  __handle_mm_fault+0x83f/0x15f0
  [967.876322]  handle_mm_fault+0x9e/0x260
  [967.876327]  __get_user_pages+0x204/0x620
  [967.876332]  ? get_user_pages_unlocked+0x69/0x340
  [967.876340]  get_user_pages_unlocked+0xd3/0x340
  [967.876349]  internal_get_user_pages_fast+0xbca/0xdc0
  [967.876366]  iov_iter_get_pages+0x8d/0x3a0
  [967.876374]  bio_iov_iter_get_pages+0x82/0x4a0
  [967.876379]  ? lock_release+0x155/0x4a0
  [967.876387]  iomap_dio_bio_actor+0x232/0x410
  [967.876396]  iomap_apply+0x12a/0x4a0
  [967.876398]  ? iomap_dio_rw+0x30/0x30
  [967.876414]  __iomap_dio_rw+0x29f/0x5e0
  [967.876415]  ? iomap_dio_rw+0x30/0x30
  [967.876420]  ? lock_acquired+0xf3/0x420
  [967.876429]  iomap_dio_rw+0xa/0x30
  [967.876431]  btrfs_file_read_iter+0x10b/0x140 [btrfs]
  [967.876460]  new_sync_read+0x118/0x1a0
  [967.876472]  vfs_read+0x128/0x1b0
  [967.876477]  __x64_sys_pread64+0x90/0xc0
  [967.876483]  do_syscall_64+0x3b/0xc0
  [967.876487]  entry_SYSCALL_64_after_hwframe+0x44/0xae
  [967.876490] RIP: 0033:0x7fb6f2c038d6
  [967.876493] RSP: 002b:00007fffddf586b8 EFLAGS: 00000246 ORIG_RAX: 0000000000000011
  [967.876496] RAX: ffffffffffffffda RBX: 0000000000001000 RCX: 00007fb6f2c038d6
  [967.876498] RDX: 0000000000001000 RSI: 00007fb6f2c17000 RDI: 0000000000000003
  [967.876499] RBP: 0000000000001000 R08: 0000000000000003 R09: 0000000000000000
  [967.876501] R10: 0000000000001000 R11: 0000000000000246 R12: 0000000000000003
  [967.876502] R13: 0000000000000000 R14: 00007fb6f2c17000 R15: 0000000000000000

This happens because at btrfs_dio_iomap_begin() we lock the extent range
and return with it locked - we only unlock in the endio callback, at
end_bio_extent_readpage() -> endio_readpage_release_extent(). Then after
iomap called the btrfs_dio_iomap_begin() callback, it triggers the page
faults that resulting in reading the pages, through the readahead callback
btrfs_readahead(), and through there we end to attempt to lock again the
same extent range (or a subrange of what we locked before), resulting in
the deadlock.

For a direct IO write, the scenario is a bit different, and it results in
trace like this:

  [1132.442520] run fstests generic/647 at 2021-08-31 18:53:35
  [1330.349355] INFO: task mmap-rw-fault:184017 blocked for more than 120 seconds.
  [1330.350540]       Not tainted 5.14.0-rc7-btrfs-next-95 #1
  [1330.351158] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
  [1330.351900] task:mmap-rw-fault   state:D stack:    0 pid:184017 ppid:183725 flags:0x00000000
  [1330.351906] Call Trace:
  [1330.351913]  __schedule+0x3ca/0xe10
  [1330.351930]  schedule+0x43/0xe0
  [1330.351935]  btrfs_start_ordered_extent+0x108/0x1c0 [btrfs]
  [1330.352020]  ? do_wait_intr_irq+0xb0/0xb0
  [1330.352028]  btrfs_lock_and_flush_ordered_range+0x8c/0x120 [btrfs]
  [1330.352064]  ? extent_readahead+0xa7/0x530 [btrfs]
  [1330.352094]  extent_readahead+0x32d/0x530 [btrfs]
  [1330.352133]  ? lru_cache_add+0x104/0x220
  [1330.352135]  ? kvm_sched_clock_read+0x14/0x40
  [1330.352138]  ? sched_clock_cpu+0xd/0x110
  [1330.352143]  ? lock_release+0x155/0x4a0
  [1330.352151]  read_pages+0x86/0x270
  [1330.352155]  ? lru_cache_add+0x125/0x220
  [1330.352162]  page_cache_ra_unbounded+0x1a3/0x220
  [1330.352172]  filemap_fault+0x626/0xa20
  [1330.352176]  ? filemap_map_pages+0x18b/0x660
  [1330.352184]  __do_fault+0x36/0xf0
  [1330.352189]  __handle_mm_fault+0x1253/0x15f0
  [1330.352203]  handle_mm_fault+0x9e/0x260
  [1330.352208]  __get_user_pages+0x204/0x620
  [1330.352212]  ? get_user_pages_unlocked+0x69/0x340
  [1330.352220]  get_user_pages_unlocked+0xd3/0x340
  [1330.352229]  internal_get_user_pages_fast+0xbca/0xdc0
  [1330.352246]  iov_iter_get_pages+0x8d/0x3a0
  [1330.352254]  bio_iov_iter_get_pages+0x82/0x4a0
  [1330.352259]  ? lock_release+0x155/0x4a0
  [1330.352266]  iomap_dio_bio_actor+0x232/0x410
  [1330.352275]  iomap_apply+0x12a/0x4a0
  [1330.352278]  ? iomap_dio_rw+0x30/0x30
  [1330.352292]  __iomap_dio_rw+0x29f/0x5e0
  [1330.352294]  ? iomap_dio_rw+0x30/0x30
  [1330.352306]  btrfs_file_write_iter+0x238/0x480 [btrfs]
  [1330.352339]  new_sync_write+0x11f/0x1b0
  [1330.352344]  ? NF_HOOK_LIST.constprop.0.cold+0x31/0x3e
  [1330.352354]  vfs_write+0x292/0x3c0
  [1330.352359]  __x64_sys_pwrite64+0x90/0xc0
  [1330.352365]  do_syscall_64+0x3b/0xc0
  [1330.352369]  entry_SYSCALL_64_after_hwframe+0x44/0xae
  [1330.352372] RIP: 0033:0x7f4b0a580986
  [1330.352379] RSP: 002b:00007ffd34d75418 EFLAGS: 00000246 ORIG_RAX: 0000000000000012
  [1330.352382] RAX: ffffffffffffffda RBX: 0000000000001000 RCX: 00007f4b0a580986
  [1330.352383] RDX: 0000000000001000 RSI: 00007f4b0a3a4000 RDI: 0000000000000003
  [1330.352385] RBP: 00007f4b0a3a4000 R08: 0000000000000003 R09: 0000000000000000
  [1330.352386] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000003
  [1330.352387] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000

Unlike for reads, at btrfs_dio_iomap_begin() we return with the extent
range unlocked, but later when the page faults are triggered and we try
to read the extents, we end up btrfs_lock_and_flush_ordered_range() where
we find the ordered extent for our write, created by the iomap callback
btrfs_dio_iomap_begin(), and we wait for it to complete, which makes us
deadlock since we can't complete the ordered extent without reading the
pages (the iomap code only submits the bio after the pages are faulted
in).

Fix this by setting the nofault attribute of the given iov_iter and retry
the direct IO read/write if we get an -EFAULT error returned from iomap.
For reads, also disable page faults completely, this is because when we
read from a hole or a prealloc extent, we can still trigger page faults
due to the call to iov_iter_zero() done by iomap - at the moment, it is
oblivious to the value of the ->nofault attribute of an iov_iter.
We also need to keep track of the number of bytes written or read, and
pass it to iomap_dio_rw(), as well as use the new flag IOMAP_DIO_PARTIAL.

This depends on the iov_iter and iomap changes introduced in commit
c03098d4b9ad ("Merge tag 'gfs2-v5.15-rc5-mmap-fault' of
git://git.kernel.org/pub/scm/linux/kernel/git/gfs2/linux-gfs2").

Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
---
 fs/btrfs/file.c | 139 ++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 123 insertions(+), 16 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index cd4950476366..5ac6ec80b970 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1903,16 +1903,17 @@ static ssize_t check_direct_IO(struct btrfs_fs_info *fs_info,
 
 static ssize_t btrfs_direct_write(struct kiocb *iocb, struct iov_iter *from)
 {
+	const bool is_sync_write = (iocb->ki_flags & IOCB_DSYNC);
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file_inode(file);
 	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
 	loff_t pos;
 	ssize_t written = 0;
 	ssize_t written_buffered;
+	size_t prev_left = 0;
 	loff_t endbyte;
 	ssize_t err;
 	unsigned int ilock_flags = 0;
-	struct iomap_dio *dio = NULL;
 
 	if (iocb->ki_flags & IOCB_NOWAIT)
 		ilock_flags |= BTRFS_ILOCK_TRY;
@@ -1955,23 +1956,80 @@ static ssize_t btrfs_direct_write(struct kiocb *iocb, struct iov_iter *from)
 		goto buffered;
 	}
 
-	dio = __iomap_dio_rw(iocb, from, &btrfs_dio_iomap_ops, &btrfs_dio_ops,
-			     0, 0);
+	/*
+	 * We remove IOCB_DSYNC so that we don't deadlock when iomap_dio_rw()
+	 * calls generic_write_sync() (through iomap_dio_complete()), because
+	 * that results in calling fsync (btrfs_sync_file()) which will try to
+	 * lock the inode in exclusive/write mode.
+	 */
+	if (is_sync_write)
+		iocb->ki_flags &= ~IOCB_DSYNC;
 
-	btrfs_inode_unlock(inode, ilock_flags);
+	/*
+	 * The iov_iter can be mapped to the same file range we are writing to.
+	 * If that's the case, then we will deadlock in the iomap code, because
+	 * it first calls our callback btrfs_dio_iomap_begin(), which will create
+	 * an ordered extent, and after that it will fault in the pages that the
+	 * iov_iter refers to. During the fault in we end up in the readahead
+	 * pages code (starting at btrfs_readahead()), which will lock the range,
+	 * find that ordered extent and then wait for it to complete (at
+	 * btrfs_lock_and_flush_ordered_range()), resulting in a deadlock since
+	 * obviously the ordered extent can never complete as we didn't submit
+	 * yet the respective bio(s). This always happens when the buffer is
+	 * memory mapped to the same file range, since the iomap DIO code always
+	 * invalidates pages in the target file range (after starting and waiting
+	 * for any writeback).
+	 *
+	 * So here we disable page faults in the iov_iter and then retry if we
+	 * got -EFAULT, faulting in the pages before the retry.
+	 */
+again:
+	from->nofault = true;
+	err = iomap_dio_rw(iocb, from, &btrfs_dio_iomap_ops, &btrfs_dio_ops,
+			   IOMAP_DIO_PARTIAL, written);
+	from->nofault = false;
 
-	if (IS_ERR_OR_NULL(dio)) {
-		err = PTR_ERR_OR_ZERO(dio);
-		if (err < 0 && err != -ENOTBLK)
-			goto out;
-	} else {
-		written = iomap_dio_complete(dio);
+	/* No increment (+=) because iomap returns a cumulative value. */
+	if (err > 0)
+		written = err;
+
+	if (iov_iter_count(from) > 0 && (err == -EFAULT || err > 0)) {
+		const size_t left = iov_iter_count(from);
+		/*
+		 * We have more data left to write. Try to fault in as many as
+		 * possible of the remainder pages and retry. We do this without
+		 * releasing and locking again the inode, to prevent races with
+		 * truncate.
+		 *
+		 * Also, in case the iov refers to pages in the file range of the
+		 * file we want to write to (due to a mmap), we could enter an
+		 * infinite loop if we retry after faulting the pages in, since
+		 * iomap will invalidate any pages in the range early on, before
+		 * it tries to fault in the pages of the iov. So we keep track of
+		 * how much was left of iov in the previous EFAULT and fallback
+		 * to buffered IO in case we haven't made any progress.
+		 */
+		if (left == prev_left) {
+			err = -ENOTBLK;
+		} else {
+			fault_in_iov_iter_readable(from, left);
+			prev_left = left;
+			goto again;
+		}
 	}
 
-	if (written < 0 || !iov_iter_count(from)) {
-		err = written;
+	btrfs_inode_unlock(inode, ilock_flags);
+
+	/*
+	 * Add back IOCB_DSYNC. Our caller, btrfs_file_write_iter(), will do
+	 * the fsync (call generic_write_sync()).
+	 */
+	if (is_sync_write)
+		iocb->ki_flags |= IOCB_DSYNC;
+
+	/* If 'err' is -ENOTBLK then it means we must fallback to buffered IO. */
+	if ((err < 0 && err != -ENOTBLK) || !iov_iter_count(from))
 		goto out;
-	}
 
 buffered:
 	pos = iocb->ki_pos;
@@ -1996,7 +2054,7 @@ static ssize_t btrfs_direct_write(struct kiocb *iocb, struct iov_iter *from)
 	invalidate_mapping_pages(file->f_mapping, pos >> PAGE_SHIFT,
 				 endbyte >> PAGE_SHIFT);
 out:
-	return written ? written : err;
+	return err < 0 ? err : written;
 }
 
 static ssize_t btrfs_file_write_iter(struct kiocb *iocb,
@@ -3650,6 +3708,8 @@ static int check_direct_read(struct btrfs_fs_info *fs_info,
 static ssize_t btrfs_direct_read(struct kiocb *iocb, struct iov_iter *to)
 {
 	struct inode *inode = file_inode(iocb->ki_filp);
+	size_t prev_left = 0;
+	ssize_t read = 0;
 	ssize_t ret;
 
 	if (fsverity_active(inode))
@@ -3659,10 +3719,57 @@ static ssize_t btrfs_direct_read(struct kiocb *iocb, struct iov_iter *to)
 		return 0;
 
 	btrfs_inode_lock(inode, BTRFS_ILOCK_SHARED);
+again:
+	/*
+	 * This is similar to what we do for direct IO writes, see the comment
+	 * at btrfs_direct_write(), but we also disable page faults in addition
+	 * to disabling them only at the iov_iter level. This is because when
+	 * reading from a hole or prealloc extent, iomap calls iov_iter_zero(),
+	 * which can still trigger page fault ins despite having set ->nofault
+	 * to true of our 'to' iov_iter.
+	 *
+	 * The difference to direct IO writes is that we deadlock when trying
+	 * to lock the extent range in the inode's tree during he page reads
+	 * triggered by the fault in (while for writes it is due to waiting for
+	 * our own ordered extent). This is because for direct IO reads,
+	 * btrfs_dio_iomap_begin() returns with the extent range locked, which
+	 * is only unlocked in the endio callback (end_bio_extent_readpage()).
+	 */
+	pagefault_disable();
+	to->nofault = true;
 	ret = iomap_dio_rw(iocb, to, &btrfs_dio_iomap_ops, &btrfs_dio_ops,
-			   0, 0);
+			   IOMAP_DIO_PARTIAL, read);
+	to->nofault = false;
+	pagefault_enable();
+
+	/* No increment (+=) because iomap returns a cumulative value. */
+	if (ret > 0)
+		read = ret;
+
+	if (iov_iter_count(to) > 0 && (ret == -EFAULT || ret > 0)) {
+		const size_t left = iov_iter_count(to);
+
+		if (left == prev_left) {
+			/*
+			 * We didn't make any progress since the last attempt,
+			 * fallback to a buffered read for the remainder of the
+			 * range. This is just to avoid any possibility of looping
+			 * for too long.
+			 */
+			ret = read;
+		} else {
+			/*
+			 * We made some progress since the last retry or this is
+			 * the first time we are retrying. Fault in as many pages
+			 * as possible and retry.
+			 */
+			fault_in_iov_iter_writeable(to, left);
+			prev_left = left;
+			goto again;
+		}
+	}
 	btrfs_inode_unlock(inode, BTRFS_ILOCK_SHARED);
-	return ret;
+	return ret < 0 ? ret : read;
 }
 
 static ssize_t btrfs_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
-- 
2.33.1

