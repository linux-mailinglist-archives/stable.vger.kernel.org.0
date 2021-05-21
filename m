Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4354138CF61
	for <lists+stable@lfdr.de>; Fri, 21 May 2021 22:53:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229532AbhEUUzI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 May 2021 16:55:08 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:48542 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229455AbhEUUzH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 May 2021 16:55:07 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14LKhLM1025449;
        Fri, 21 May 2021 20:53:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version;
 s=corp-2020-01-29; bh=9rs5ugSB7MkClwEiaKoNJqRO/24W0Z+By45xD0lF1B8=;
 b=Ikvn2Vt4vIrTQmFOP/WQ564ptU7XtOTJTs/bI4INv+1g4sC3OupMGwpqfQt74uXE7RaN
 7YlHX0LxTK/cWR2mNBtr+iyUg/TACs0Wl8QskPSiiOv8PqvvE/MrLnG7EXHSt79hXhGX
 jp6MlMKLGxH+slb5lOVmO+ILTqM+sQnRCNu31EHuinA+GBRJAYC5exMim0WohcdPMwBo
 uAwp1JMpNxPrM41BU/SVu7KPnEG0hSEvkC0u8MiC67llFr8XzrKC9fEVYFICZQtksDPU
 gNAu2/sR+xLt+cdlu+szzgCsLaxW48ysZTuO6angnOhX/gDCDtqgoR5Pp9h3P5sbjYMr xg== 
Received: from oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 38n4uks2en-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 May 2021 20:53:38 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 14LKrbAB067047;
        Fri, 21 May 2021 20:53:37 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2041.outbound.protection.outlook.com [104.47.73.41])
        by userp3030.oracle.com with ESMTP id 38megnwbp6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 May 2021 20:53:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ka5f54gSTQvKzuqylynN7jnaWc4NtjdziLsVoSaJBuNdEDP1OZeodJaTdsgDWmbsi8xO/mpcJoYi/i8IGTzYEhmeLQprxwiqfZROWy4E8zccyDwQ6wBgJ3BroQLOaKBdfIAoezR3ON0xkE6jIcEyBs1ldOC+kcecFVTfyN5h44jzjo7XIljxV9UpZXMMA8WDuYb/6W7vJI7+dVoCI1By89b3wGXt47BHpzIHnW9qxfR8hZj9ofXfhckJ9emJLGq4b7cGE0CWr7AFxEHvinFcR/hWK6JTJ2mbCUHHzaDlNB+rzIDdq4bDaDA+WcpvIIIj7uQzLxId38CenIC2SLoBIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9rs5ugSB7MkClwEiaKoNJqRO/24W0Z+By45xD0lF1B8=;
 b=Vofc4onKUIHT2njijZYM4rox43F4/GF8CCzlqUJ6UQqhD1xXEBDTE4YpZgW5sMA+wt9FiWE5zL8A+AhC84KKchkhy1RrenpF++PXiQZsKn+BuweOlOjE1DgMnu8kIUBoGDIORlI9tJokiTRWKwb+dfw6wjiJN1CWaetAow6lWoKA3xq51CPzoCCTAwIG3LQkc0tmXCZlxVv3RFamEKH/5QHlAZKPqwYASy1Sbm7JtBpv2+hHa+hx3FpZUivVgDIB8JJO1EZlhPvOoUap1mdFfJmRvuXHZwB+ipnDmEOcvE0xvyoApi1mVYqsRG+ALYNkOOJNH05i2UJK0iaegUL/6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9rs5ugSB7MkClwEiaKoNJqRO/24W0Z+By45xD0lF1B8=;
 b=MabYlg0Ptff2LItZCUI7isw8k3H3+eVkmeVWOP6/bJxJNlg0ovxosNN2v73OeSPfpcOa7AZJk6odvOcRCEMu+zw6ToRhHTbja8cZRsgM9lPpEFQGvChXmrAwMdC0c+fTz7eXGA8ZJ3GQCWuMU2Kz6yGRMqYrLGRflopYI3igpLY=
Authentication-Results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=oracle.com;
Received: from DM6PR10MB3851.namprd10.prod.outlook.com (2603:10b6:5:1fb::17)
 by DM6PR10MB4364.namprd10.prod.outlook.com (2603:10b6:5:223::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23; Fri, 21 May
 2021 20:53:35 +0000
Received: from DM6PR10MB3851.namprd10.prod.outlook.com
 ([fe80::e490:f9ff:f8f3:c1e6]) by DM6PR10MB3851.namprd10.prod.outlook.com
 ([fe80::e490:f9ff:f8f3:c1e6%7]) with mapi id 15.20.4150.023; Fri, 21 May 2021
 20:53:35 +0000
From:   George Kennedy <george.kennedy@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     george.kennedy@oracle.com, stable@vger.kernel.org, daniel@ffwll.ch,
        airlied@linux.ie, maarten.lankhorst@linux.intel.com,
        mripard@kernel.org, robdclark@gmail.com, sean@poorly.run,
        tomi.valkeinen@ti.com, vegard.nossum@oracle.com,
        dhaval.giani@oracle.com, dan.carpenter@oracle.com,
        dvyukov@google.com
Subject: [PATCH 5.4.y 0/2] 5.4.y missing upstream commits 7beb691f and 51f644b4, causing: WARNING in vkms_vblank_simulate
Date:   Fri, 21 May 2021 15:53:18 -0500
Message-Id: <1621630400-22972-1-git-send-email-george.kennedy@oracle.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-Originating-IP: [209.17.40.39]
X-ClientProxiedBy: BYAPR07CA0078.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::19) To DM6PR10MB3851.namprd10.prod.outlook.com
 (2603:10b6:5:1fb::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dhcp-10-152-13-169.usdhcp.oraclecorp.com.com (209.17.40.39) by BYAPR07CA0078.namprd07.prod.outlook.com (2603:10b6:a03:12b::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23 via Frontend Transport; Fri, 21 May 2021 20:53:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fd0e1c9a-9f86-454e-d828-08d91c9a8068
X-MS-TrafficTypeDiagnostic: DM6PR10MB4364:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR10MB43640B2DFE485F9D05DF897DE6299@DM6PR10MB4364.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dTuZKqahCUctXYrjd6bnAoNSqsDCAv/CR/dXaS7nEyWUhDOQi94+jQzaCadITQUKkL/uPd3RCIek4EVhsV/j/jjAVt/1NMykntMiGCd1+KBMm2HoghrdL9TY/i/V4bGfHNBHbxJPtiZzxHuR/P7AeAhKiKBBhvVQo2S2uFjvkuKNvAJQL9E3y4Shi686T/bftjZrJTb+QFkqCHxuxQuEZU6fdVXtewRadGdJyhSOYh9qtNZt09o5gC4XE3hQVEOr7e4dfIrpVRWQB84XLO9UBN7OD3eI7T223ATtfFAPcfHj7YBnf0gAYf+iOCQjTy1UUVO1FRgF1ZDV0aATr6TLEg1BwgYHUpXaagLh/1fij9eLMkd4rLvSGbSLziGPQR6BLSoAc9dWp+jwZVyNhl0N9a4iRaZjS6i9T/GmAKggl5r3slnG5sEjQlHyjtkYKgT5E20jOE/wGEyMrXDoEGdkCuPY8a28PXn9STzQZ4YqPbGKJtfaB5gKGbRO9Jz8WmBR0/+GDeMACii2PIQxvR/QcHN4/12RqRqlvifVZT/RBd1lDnuNFqFtdI7LJT0Gm5qCCl0C0P5MtIuKSE8aAbsEXXxD+gptCzbxJTmhmY8QrblreSlWrOb5prjIEi87P/swkdUkOSSQi4XFo5LgBBPTkNpZhP3204aeeIoYUrnQCKMKbd6mhg9JBu6d0RGJNTjQTqH1Jz9alj5iyWs3FoKu+h1CsOjfDvsjXA6z+FLOSAFn6+m2E+DAb7sc2X9Z/aPki+nIEb4P3l8gjJTKe7aSkJM8T9mqEDrSRjKP4koyNVk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB3851.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(396003)(39860400002)(366004)(376002)(38350700002)(7416002)(6486002)(38100700002)(6512007)(6916009)(6506007)(83380400001)(36756003)(316002)(4326008)(44832011)(186003)(6666004)(66556008)(66946007)(66476007)(2616005)(2906002)(16526019)(8676002)(966005)(8936002)(956004)(52116002)(5660300002)(86362001)(478600001)(26005)(45080400002)(99710200001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?3XpB3FnvLUGYM/nIUMxKSxS0l2vgI8swa2DqSWd0lbP4cne1IG+WdsrBhW06?=
 =?us-ascii?Q?X1olxUoGnvQLhjMffTL9o736063r/ZXN9Vk8w5kVwLdPNqvZzwgRcO2Y+RP3?=
 =?us-ascii?Q?LRIsMj6VI+R9/OFTEZCHNWtcrm6A09BWZlpDHOzTSRDzFHNrMTktpd21LEGL?=
 =?us-ascii?Q?UjXlajP9xevmS03os+wIQ3IAdvgOa4EdUMWjkVOyumrHPE7EUvrKILv2hma6?=
 =?us-ascii?Q?RDmqP7esM+DAPWIdlEKd9wgasuWgItZW7BVLKUBAKk/BApj0XDZJJXAGtRH8?=
 =?us-ascii?Q?zbJGdmaPtV0FNTsPXHY2FfF9IKlkz/26ZAAlhz9BAJwElio836xqfIWHYoWT?=
 =?us-ascii?Q?oXJbQl6+/nH2MgnMhULqm+/z62R0k+9ijpTRBGOIFUij2tpwxRJG5kasyXHe?=
 =?us-ascii?Q?FBtY2Ki7NCATemUfwhHDzJOdwdo6ucwHxLOL/xKwJFFvIv5zjKix5DEAj268?=
 =?us-ascii?Q?xdj9KIEBpULuYMT82fn61A2ZLpYFivaVAemuUE1urP1soPxLvFOxb45QWgL6?=
 =?us-ascii?Q?/PpWuVbW0WYPEdSMFRWh3TqpILL4XwC2tkPud9+bJSL0CncNGeaAEMuaQ75e?=
 =?us-ascii?Q?GM8ifHkCQ2FaFdVmJQfU5RzlyhJhmVadd5B7a+8hc/VXXhLbeZ2gHuVnrFAy?=
 =?us-ascii?Q?z64AUjT3fBCFf4pJxnFH+l675801Wm6xLctZsuL8/mQjncfvX+L1371Hdma7?=
 =?us-ascii?Q?nizC7Z9bYPoDxouN4ndJxBRI+qPrW8COTpatfzKgAB0MvtNYbDLy1f623iRl?=
 =?us-ascii?Q?3DwiZ9uugip0UhqFmfENQS52i+0quj2XCMuNq4UjUiEdlG5BYfzUAnG40jW5?=
 =?us-ascii?Q?37O3toOmPLOx0QSj/2LmNA1gk85+QVy9FUJhl/Kos0Y+c8NlHxj6w9T9UkSb?=
 =?us-ascii?Q?dOOb/TEZVnIJhJOOLvoj/GDOkvNuhACh6PPTPuJrVrcB/ALARy0Mskt9UGb+?=
 =?us-ascii?Q?CZiR/MkkXC/Yr8RhqNOjA0Fgu9rDhzNoPE5zogwTbXx3tkXL0nJq2lp72TQa?=
 =?us-ascii?Q?GusYcQyxAWZOrmdFCefjA29vjDf4e8DL0RDzSHONT95sYYMF21+Hk5jJjdOg?=
 =?us-ascii?Q?WY4hu+O7uUW6+ZreZdrDAeT2VmrNgx+QZE7hleNcHtn6fCs/eRWMMKJE3okF?=
 =?us-ascii?Q?FLmU3WzdadM0D532dFXCCyoe0JK/RL6uj64YdXL1XG7i4iO6/FtyN5IsqN3W?=
 =?us-ascii?Q?Tj16ibzqE/1BULKxcJungv8wWojL9EYEXHh/aX7P9prRQ77CtuuH2UCBMJNb?=
 =?us-ascii?Q?Kf6JZ8Z4jb2XBpg/LEMG2mxxepq4mOZm0MnkIVyTLZ5vsXp1OYytSuQsGvO3?=
 =?us-ascii?Q?Am11f/85FftqM8cY/EzTRqX2?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd0e1c9a-9f86-454e-d828-08d91c9a8068
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB3851.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2021 20:53:35.5831
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dQt4Buahfu7+yDZpWEMVJrRP84HNZVJ/EcWZiyvKCjypXBbr3SSr+BOtBX+bB2z4YDyj/x9QbcfsyM9GupLkSeKK8Flh/aG82t33joKY9bg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4364
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9991 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 adultscore=0 malwarescore=0 bulkscore=0 mlxscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105210113
X-Proofpoint-GUID: PEB57Ht2Syi11iCuJ6EjcZhZJiWHyWnY
X-Proofpoint-ORIG-GUID: PEB57Ht2Syi11iCuJ6EjcZhZJiWHyWnY
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

During Syzkaller reproducer testing on 5.4.y (5.4.121-rc1) the following warning occurred:

WARNING in vkms_vblank_simulate
https://syzkaller.appspot.com//bug?id=0ba17d70d062b2595e1f061231474800f076c7cb

These 2 upstream commits are needed to fix the warning:
7beb691f drm: Initialize struct drm_crtc_state.no_vblank from device settings
51f644b4 drm/atomic-helper: reset vblank on crtc reset

51f644b4 has conflicts (which were resolved).

[  101.335429] ------------[ cut here ]------------
[  101.336576] WARNING: CPU: 1 PID: 0 at drivers/gpu/drm/vkms/vkms_crtc.c:91 vkms_get_vblank_timestamp+0x10a/0x140
[  101.338952] Modules linked in:
[  101.339701] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 5.4.121-rc1-syzk #1
[  101.344331] RIP: 0010:vkms_get_vblank_timestamp+0x10a/0x140
[  101.345660] Code: 03 80 3c 02 00 75 4f 4d 2b b5 80 10 00 00 4d 89 34 24 e8 d9 4e a7 fc b8 01 00 00 00 5b 41 5c 41 5d 41 5e 5d c3 e8 c6 4e a7 fc <0f> 0b eb e4 e8 3d a0 e6 fc e9 27 ff ff ff e8 33 a0 e6 fc eb 91 4c
[  101.351293] RAX: ffff888107a65d00 RBX: 000000179647991a RCX: ffffffff84cde2af
[  101.352976] RDX: 0000000000000100 RSI: ffffffff84cde2fa RDI: 0000000000000006
[  101.354662] RBP: ffff88810b289ba8 R08: ffff888107a65d00 R09: ffffed1021651398
[  101.356361] R10: ffffed1021651398 R11: 0000000000000003 R12: ffff88810b289cb0
[  101.358037] R13: ffff88810a89c000 R14: 000000179647991a R15: 0000000000004e20
[  101.359718] FS:  0000000000000000(0000) GS:ffff88810b280000(0000) knlGS:0000000000000000
[  101.361627] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  101.362992] CR2: 00007f82b0154000 CR3: 0000000109460000 CR4: 00000000000006e0
[  101.364684] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  101.366369] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  101.368043] Call Trace:
[  101.368652]  <IRQ>
[  101.369159]  ? vkms_crtc_atomic_flush+0x2d0/0x2d0
[  101.370296]  drm_get_last_vbltimestamp+0x106/0x1b0
[  101.371446]  ? drm_crtc_set_max_vblank_count+0x1a0/0x1a0
[  101.372715]  ? __sanitizer_cov_trace_const_cmp4+0x16/0x20
[  101.374001]  drm_update_vblank_count+0x17a/0x800
[  101.375107]  ? store_vblank+0x1d0/0x1d0
[  101.376038]  ? __kasan_check_write+0x14/0x20
[  101.377071]  drm_vblank_disable_and_save+0x13a/0x3d0
[  101.378265]  ? vblank_disable_fn+0x101/0x180
[  101.379296]  vblank_disable_fn+0x14b/0x180
[  101.380282]  ? drm_vblank_disable_and_save+0x3d0/0x3d0
[  101.381508]  call_timer_fn+0x50/0x310
[  101.382393]  ? drm_vblank_disable_and_save+0x3d0/0x3d0
[  101.383621]  ? drm_vblank_disable_and_save+0x3d0/0x3d0
[  101.384849]  run_timer_softirq+0x76f/0x13e0
[  101.385857]  ? del_timer_sync+0xb0/0xb0
[  101.386792]  ? irq_work_interrupt+0xf/0x20
[  101.387776]  ? irq_work_interrupt+0xa/0x20
[  101.388761]  __do_softirq+0x18d/0x623
[  101.389647]  irq_exit+0x1fc/0x220
[  101.390454]  smp_apic_timer_interrupt+0xf0/0x380
[  101.391565]  apic_timer_interrupt+0xf/0x20
[  101.392547]  </IRQ>
[  101.393073] RIP: 0010:native_safe_halt+0x12/0x20
[  101.394178] Code: 96 fe ff ff 48 89 df e8 ac c1 fc f3 eb 92 90 90 90 90 90 90 90 90 90 90 55 48 89 e5 e9 07 00 00 00 0f 00 2d 10 ee 50 00 fb f4 <5d> c3 66 90 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 e9 07 00 00
[  101.398541] RSP: 0018:ffff888107aafd48 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
[  101.400326] RAX: ffffffff8db7b830 RBX: ffff888107a65d00 RCX: ffffffff8db7c532
[  101.402004] RDX: 1ffff11020f4cba0 RSI: 0000000000000008 RDI: ffff888107a65d00
[  101.403680] RBP: ffff888107aafd48 R08: ffffed1020f4cba1 R09: ffffed1020f4cba1
[  101.405361] R10: ffffed1020f4cba0 R11: ffff888107a65d07 R12: 0000000000000001
[  101.407041] R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000000
[  101.408729]  ? __cpuidle_text_start+0x8/0x8
[  101.409735]  ? default_idle_call+0x32/0x70
[  101.410722]  default_idle+0x24/0x2c0
[  101.411589]  arch_cpu_idle+0x15/0x20
[  101.412459]  default_idle_call+0x5f/0x70
[  101.413405]  do_idle+0x30f/0x3d0
[  101.414185]  ? arch_cpu_idle_exit+0x40/0x40
[  101.415188]  ? complete+0x67/0x80
[  101.415992]  cpu_startup_entry+0x1d/0x20
[  101.416937]  start_secondary+0x2ec/0x3d0
[  101.417879]  ? set_cpu_sibling_map+0x2620/0x2620
[  101.418986]  secondary_startup_64+0xb6/0xc0
[  101.420001] ---[ end trace 6143b67a4d795a3a ]---

Daniel Vetter (1):
  drm/atomic-helper: reset vblank on crtc reset

Thomas Zimmermann (1):
  drm: Initialize struct drm_crtc_state.no_vblank from device settings

 drivers/gpu/drm/arm/display/komeda/komeda_crtc.c |  7 ++---
 drivers/gpu/drm/arm/malidp_drv.c                 |  1 -
 drivers/gpu/drm/atmel-hlcdc/atmel_hlcdc_crtc.c   |  7 ++---
 drivers/gpu/drm/drm_atomic_helper.c              | 10 ++++++-
 drivers/gpu/drm/drm_atomic_state_helper.c        |  4 +++
 drivers/gpu/drm/drm_vblank.c                     | 28 +++++++++++++++++++
 drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.c        |  2 --
 drivers/gpu/drm/omapdrm/omap_crtc.c              |  8 +++---
 drivers/gpu/drm/omapdrm/omap_drv.c               |  4 ---
 drivers/gpu/drm/rcar-du/rcar_du_crtc.c           |  6 +----
 drivers/gpu/drm/tegra/dc.c                       |  1 -
 include/drm/drm_crtc.h                           | 34 +++++++++++++++++++-----
 include/drm/drm_simple_kms_helper.h              |  7 +++--
 include/drm/drm_vblank.h                         |  1 +
 14 files changed, 84 insertions(+), 36 deletions(-)

-- 
1.8.3.1

