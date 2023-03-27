Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FF8A6C9B44
	for <lists+stable@lfdr.de>; Mon, 27 Mar 2023 08:07:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbjC0GHR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Mar 2023 02:07:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbjC0GHQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Mar 2023 02:07:16 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75FBF420A;
        Sun, 26 Mar 2023 23:07:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679897234; x=1711433234;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=Npa94VU9mql1w1rhhghpUDV4CryPBzkpURQF/mCRmMY=;
  b=VC618NGlzhnu7SbjFfeFmOgbd3gaIEMJHngrQTuh+fHEIZYd//j6ONUh
   euCI6Dv6I3oSs3rO0Rjle9OmkNqD0nZ8QBcvDZVXy4SautTUTedEMn+fC
   gLMw/jiZ3htYxwnMKk2tkHMh+fBuUbdx3UEqUvtSGIWXwXUFoULsAlRG4
   skgARc5URrXCbt2Yj8mgRxuNcMAsW+QdQD41Bc6X18h7ddA4sHNAFOlKy
   +AeCb4km+t17IJ3vx7J/d0jQH/uyXvAityr78gOy6VdIntpnYSL3xePo7
   rgdCSfMgKg1/qGFTVwXk2P/QVfADol1pHpbbbIRi9r4H5Hi9SV30fr/MF
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10661"; a="367928103"
X-IronPort-AV: E=Sophos;i="5.98,293,1673942400"; 
   d="scan'208";a="367928103"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2023 23:07:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10661"; a="857546573"
X-IronPort-AV: E=Sophos;i="5.98,293,1673942400"; 
   d="scan'208";a="857546573"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga005.jf.intel.com with ESMTP; 26 Mar 2023 23:07:13 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Sun, 26 Mar 2023 23:07:13 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Sun, 26 Mar 2023 23:07:13 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.174)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Sun, 26 Mar 2023 23:07:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KA3qi99s9UziAE9Cw/CnaWVN8oiOfNBq19Ff6xOg2jCQ3DElcTEp7Kh/aoEHZX2xt2cco+VuyDitk/pz8S3SoO0HW1+BOG4PK9Hk0V1WQsEFTvXSTUEHlYEHDOYka9Hq5un0Yz5zg5pCZn+vEllzPwOh7RUF6RCyivcykX22fvIRgMsLA1Yo4kSmSFfMrqaSwLyoqaHbPLGXacoiwVmNkKsNYo/4utnGzPMOGtrcYPFGq5BL9fNy2A9pIyzdwPE0AUgzHXft/ewyGy+g49XImhqNrKfLtofHtwHvEQcNCLRNhljZOYGLU8XCiTvuEQ5AlJSuMQPeP11DckWLkuLVXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/Zdu1duVd9lYWatrTwXhVGu3/SZfppwWbncE1NGhhdw=;
 b=fRXFSB9+YU96rCkT+OFLyYIJ0sJyTk337WG/lBfZE9121suuu0PPrfO5X/VOB8frShWP58lgqT17YjHZiPZypEoPcm3P+lkH7NmfmvO3V9BW3TuKiOKYVDcBZFAz1J3ZWFCCxV3qkJ5GtXKXlQD+Wy7UAW6KyJy7SRPMA2MABad+wQSm9bR1ar2vVInGvkKYddJi/HY4I6g01LCNjn1/VOcsECMK/JWkCyAn+cvzv3IFS9MJvNRjlSl4qPHpoHuaYDJGG20TvnB+oHZgoQ2GLScPxzQok5G0tiL9/7Qa1nOoEyzLwOgpOLQtWcZKWFyTBZ2354bawnOHNU6kFJCA8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4839.namprd11.prod.outlook.com (2603:10b6:510:42::18)
 by MW4PR11MB6958.namprd11.prod.outlook.com (2603:10b6:303:229::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.41; Mon, 27 Mar
 2023 06:07:10 +0000
Received: from PH0PR11MB4839.namprd11.prod.outlook.com
 ([fe80::7369:ca71:6d2e:b239]) by PH0PR11MB4839.namprd11.prod.outlook.com
 ([fe80::7369:ca71:6d2e:b239%6]) with mapi id 15.20.6222.030; Mon, 27 Mar 2023
 06:07:10 +0000
Date:   Mon, 27 Mar 2023 14:08:38 +0800
From:   Pengfei Xu <pengfei.xu@intel.com>
To:     <axboe@kernel.dk>
CC:     <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <heng.su@intel.com>, <lkp@intel.com>
Subject: [Syzkaller & bisect] There is "io_poll_remove_entries" NULL pointer
 BUG in v6.3-rc4 kernel
Message-ID: <ZCEy5jA2nT/vaO56@xpf.sh.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-ClientProxiedBy: SI2PR06CA0006.apcprd06.prod.outlook.com
 (2603:1096:4:186::19) To PH0PR11MB4839.namprd11.prod.outlook.com
 (2603:10b6:510:42::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4839:EE_|MW4PR11MB6958:EE_
X-MS-Office365-Filtering-Correlation-Id: 57d1e458-328f-4284-f882-08db2e8980ab
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 26RTGsaxEHp6TA8QEPXtjbHUinBVMDexoDuYtIOCZ1xyXgdni6CE27Wty2vQ0of2K9G7sOFhk4QGD5V/a22CI/C0TPZ87v6DlmoWcfnqYOdOc0SFj/N25V+I4s2Gpi/jxGOcKNeG70SmcWAi80nzgiDBcoOqwkx/s7PnVYFbTN1XkONQNlcN4VwmwOuP2oF7sdzqjKcFS3zmFyhySK/npkmZUVuMzlM4wZkOOa2kDq7XQxxUeXcF4VegMdjjORwssnV6joHPWcj8w7FXf0n6+7tf8d0WiYJ6/p814WOcXIucXWzBpWmLi0CIOL6IxeMzyV62VlEoO0fM9aq13j02PxRAvoICeyu0aIgyc1k/HZr20MD5xU72/gp+irdoa1L98iduVUikVW0yIy8uFWAx1qDt3Y+CAiJt8BpG37Lqd2A5KiNcZSmCiUKJYpXqXk6Nb20w8MDRC3XA37pXK3p/wtg2fyJ96StYBn3VIIuqR7OfnRgVUzcJHMd23OPClfk+bDOEc0f9XEdwfHrzmhpXlih2J9GTKuN4rSNcvFhmyn+DAZA86bgBQXEPI3TuQw8/MKzcXlvojCkmkxKR6Nk+gwhDKwo+038Jrh3iULcOfNAfwaF9p+wcgz9C9e94tjeMEKIl5U3YaqqwNTGxXiJ+9Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4839.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(136003)(346002)(366004)(396003)(376002)(451199021)(8936002)(316002)(82960400001)(41300700001)(2906002)(30864003)(5660300002)(44832011)(4326008)(66946007)(66556008)(478600001)(45080400002)(6916009)(8676002)(66476007)(38100700002)(966005)(6486002)(86362001)(107886003)(6666004)(83380400001)(6512007)(186003)(26005)(6506007)(21314003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Z8o1EIdv7q/mZrtvQ4tggYB3+r6u3tZ6JRU1YV56wLRblp6UFVRqYiO4D0ni?=
 =?us-ascii?Q?pV5H4jJgKeNtlrhWxK+fY0y9HFiQIEipnhn2YW/kyqVMEjc1MAQMkJvAa2Q/?=
 =?us-ascii?Q?QG22VySz7ag42ceV/WqfDyN1IvPzOS6vSxrvS+IEozkPO9344HGyLiSZaOAE?=
 =?us-ascii?Q?ZeJV1VETSR399Ug2eGCMFJPtfI2NB6Q/XML3FAAlc6DAzuVAsRGN1ZRiqPkd?=
 =?us-ascii?Q?6h9oU7axrbJ0TbO0RszEHX/S+TXT2Jbp0x0XGENKPkGhcnxIgxxyGIwQMRpF?=
 =?us-ascii?Q?IHkYxFVqiwGD6LYRKOhmEIm0jOQs6oLAUX8mgw2/Tlbk28PrFl8HVGpWzAxU?=
 =?us-ascii?Q?Tg7vlaMOMLwhJFvWJAWNApOnhzss9oQWOt13CfsbTrW1GpSccDGHkbFx3H0a?=
 =?us-ascii?Q?rr6YF+7W+VQIlJfGXEziBl8CitjmNIOg8qYZ0/BacG5izTb/dItMmp3Es+ff?=
 =?us-ascii?Q?qqAiDI6N8IqVaryffeHkxPGmkiUTMArnhXdr6cM10x03S0V9ueOV/Ek/dmZy?=
 =?us-ascii?Q?L94tGnFGlLxvGjTAUPGg9kFYUxFUN5JUQLQCZIfJi4MH5kps1Cr1fnPpfE78?=
 =?us-ascii?Q?x6x04NPx5+Bb9SQvs9yY+hsu0IBWYVNIJe6c0SnBCo3f7ndpnlOPDfixlED9?=
 =?us-ascii?Q?W6rUkL93XG7gSKx5mySLx+98EitLogUar9cQ9OYzJy1H5SYkZFxiQ3dfyoDo?=
 =?us-ascii?Q?qYgpgCdSs5toyYr0RL9hx5clJXl5UPxlEDK4E5pPQslQHELlfFdiw4sHyEJ1?=
 =?us-ascii?Q?32qeM/CTDlptZkHPKUcSVKHP6/i61jWDHx4pjt/+dGzQ1R4QOKwbUXI8TzgE?=
 =?us-ascii?Q?qNUPhTGwAfetl7gNffECTMiy7C3tAYu0GG3TDSh2CJjatcGi3XiV5gASzMG6?=
 =?us-ascii?Q?Rm+lMldcx/nIyh0UrGlrQiGG83mNB9QqLqk8e0oUR4lDRlrujXDMVgWQAK+q?=
 =?us-ascii?Q?gVnPDQe+vI53+ZVtYq3a7ysXirAxXAhVDQ5ewYH3u6ZDHGl6W3y/TzN59+1Q?=
 =?us-ascii?Q?yDWOqRLyUH5cJbKBFN1LEi5JI5L8lMBiInFjc3A7nFNvyQX6RcIUMXjYrMWS?=
 =?us-ascii?Q?YUSrjXGYmHlWe8yinPSi7itySCo3ynWrpW7XHq2M7oTJ4/ljrV62UQkoqiB8?=
 =?us-ascii?Q?KmAcr9jkDKy9k8ZYLFZ/kNP8XM7b+F8IaoyOZka9X2RlpgTsYKtFUpniqjIc?=
 =?us-ascii?Q?tHtXQEbyySzRbh1PaiZ4DyHo8tlfaT9Sw5pr8pnC4jbPZUDw/rl6ne2Fz1v3?=
 =?us-ascii?Q?GX7rv2e71B9d/9oiJo7fU/D+vLWTY6YrdDkj+xhiUSen1KW3e5/cWpdez+MI?=
 =?us-ascii?Q?z6iIqXqolu1nbQu0x300lKVvnRxER54oRDEQJPKvngx5e2kpfILwNDs32du4?=
 =?us-ascii?Q?PipPFsDhXGWvNGcOSJEiWbt15qlFGxozNFRgeolJZv5YgNPfOTItDsMbmMUJ?=
 =?us-ascii?Q?22708XDeiujqTZrUw1luA0gvz+i3EKX0mQMHCMLv7ybGVbVDi4lLRFswu0T9?=
 =?us-ascii?Q?M5CSFTV0g91RemFZ0xnwA9c6TWdcQYG6jQCq/FZ+hC91ke5xBOBG/cIArx36?=
 =?us-ascii?Q?fQw9g5wJ2XmuX1NmDxIvZUpdFp+Rgvsfl9hzFMQB?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 57d1e458-328f-4284-f882-08db2e8980ab
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4839.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2023 06:07:10.8329
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5anpFOGw8eK4lOxL1JL/CvVRCyRNgEGDYgp34aJRgeQ1lWJR1TgmBVXtYQjQXKarh3YqiDiPiBfmzyySXsSmYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6958
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Jens Axboe and kernel experts,

Platform: x86 platforms
There is "io_poll_remove_entries" NULL pointer BUG in v6.3-rc4 kernel.

All detailed log: https://github.com/xupengfe/syzkaller_logs/tree/main/230327_041425_io_poll_remove_entries
Syzkaller reproduced code: https://github.com/xupengfe/syzkaller_logs/blob/main/230327_041425_io_poll_remove_entries/repro.c
Syzkaller analysis report0: https://github.com/xupengfe/syzkaller_logs/blob/main/230327_041425_io_poll_remove_entries/report0
Syzkaller analysis status: https://github.com/xupengfe/syzkaller_logs/blob/main/230327_041425_io_poll_remove_entries/repro.stats
v6.3-rc4 issue dmesg: https://github.com/xupengfe/syzkaller_logs/blob/main/230327_041425_io_poll_remove_entries/v63rc4_reproduce_dmesg.log
Kconfig: https://github.com/xupengfe/syzkaller_logs/blob/main/230327_041425_io_poll_remove_entries/kconfig_origin
Bisect info: https://github.com/xupengfe/syzkaller_logs/blob/main/230327_041425_io_poll_remove_entries/bisect_info.log

It could be reproduced in v6.3-rc3 and v6.3-rc4 kernel, and bisected between
v6.3-rc3 and v5.11 kernel, bad commit was:
"
c16bda37594f83147b167d381d54c010024efecf
io_uring/poll: allow some retries for poll triggering spuriously
"
After reverted above commit on top of v6.3-rc3 kernel, this issue was gone.

"
[   67.196537] BUG: kernel NULL pointer dereference, address: 0000000000000008
[   67.197176] #PF: supervisor read access in kernel mode
[   67.197638] #PF: error_code(0x0000) - not-present page
[   67.198100] PGD 1204e067 P4D 1204e067 PUD 12211067 PMD 0 
[   67.198588] Oops: 0000 [#1] PREEMPT SMP NOPTI
[   67.198987] CPU: 1 PID: 393 Comm: repro Not tainted 6.3.0-rc4-kvmmainline #2
[   67.199615] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 0.0.0 02/06/2015
[   67.200324] RIP: 0010:io_poll_remove_entries.part.16+0x14a/0x310
[   67.200871] Code: 06 00 00 00 89 de e8 75 2f 59 ff 80 fb 06 0f 84 c5 01 00 00 e8 07 2e 59 ff 49 8b 84 24 a8 00 00 00 48 8b 58 40 e8 f6 2d 59 ff <4c> 8b 63 08 4d 85 e4 74 38 e8 e8 2d 59 ff 4c 89 e7 e8 a0 1f 27 01
[   67.202490] RSP: 0018:ffffc900010b3b78 EFLAGS: 00010246
[   67.202963] RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffffffff81d4356b
[   67.203597] RDX: 0000000000000000 RSI: ffff888004ecc680 RDI: 0000000000000002
[   67.204230] RBP: ffffc900010b3b90 R08: 000000000000001c R09: 0000000000000001
[   67.204867] R10: ffff888004ecd418 R11: 0000000000000000 R12: ffff8880044d6e00
[   67.205502] R13: 0000000000000000 R14: 0000000000000059 R15: 0000000001000000
[   67.206137] FS:  00007fd010a36740(0000) GS:ffff88807ed00000(0000) knlGS:0000000000000000
[   67.206850] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   67.207383] CR2: 0000000000000008 CR3: 0000000005efe004 CR4: 0000000000770ee0
[   67.208037] PKRU: 55555554
[   67.208298] Call Trace:
[   67.208535]  <TASK>
[   67.208746]  __io_arm_poll_handler+0x30c/0x520
[   67.209170]  io_arm_poll_handler+0x2cf/0x530
[   67.209577]  ? __pfx_io_async_queue_proc+0x10/0x10
[   67.210030]  io_queue_async+0x88/0x2f0
[   67.210394]  io_req_task_submit+0x122/0x140
[   67.210794]  io_poll_task_func+0x4c6/0x700
[   67.211182]  tctx_task_work+0x1d3/0x650
[   67.211554]  task_work_run+0xb6/0x120
[   67.211910]  get_signal+0xd6b/0x14a0
[   67.212259]  ? __tty_hangup.part.29+0x32a/0x3a0
[   67.212709]  arch_do_signal_or_restart+0x33/0x280
[   67.213159]  ? exit_to_user_mode_prepare+0x100/0x210
[   67.213631]  ? __this_cpu_preempt_check+0x20/0x30
[   67.214083]  exit_to_user_mode_prepare+0x13b/0x210
[   67.214540]  syscall_exit_to_user_mode+0x2d/0x60
[   67.214981]  do_syscall_64+0x4a/0x90
[   67.215335]  entry_SYSCALL_64_after_hwframe+0x72/0xdc
[   67.215818] RIP: 0033:0x7fd010b5b59d
[   67.216163] Code: 00 c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d d3 08 0d 00 f7 d8 64 89 01 48
[   67.217852] RSP: 002b:00007ffc0d005148 EFLAGS: 00000206 ORIG_RAX: 0000000000000010
[   67.218553] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00007fd010b5b59d
[   67.219214] RDX: 0000000000000000 RSI: 0000000000005437 RDI: 0000000000000003
[   67.219884] RBP: 00007ffc0d005160 R08: 0000000000000000 R09: 00007ffc0d005240
[   67.220551] R10: 0000000000000000 R11: 0000000000000206 R12: 00000000004010b0
[   67.221219] R13: 00007ffc0d005240 R14: 0000000000000000 R15: 0000000000000000
[   67.221891]  </TASK>
[   67.222112] Modules linked in:
[   67.222414] CR2: 0000000000000008
[   67.222738] ---[ end trace 0000000000000000 ]---
[   67.261809] RIP: 0010:io_poll_remove_entries.part.16+0x14a/0x310
[   67.262406] Code: 06 00 00 00 89 de e8 75 2f 59 ff 80 fb 06 0f 84 c5 01 00 00 e8 07 2e 59 ff 49 8b 84 24 a8 00 00 00 48 8b 58 40 e8 f6 2d 59 ff <4c> 8b 63 08 4d 85 e4 74 38 e8 e8 2d 59 ff 4c 89 e7 e8 a0 1f 27 01
[   67.264185] RSP: 0018:ffffc900010b3b78 EFLAGS: 00010246
[   67.264704] RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffffffff81d4356b
[   67.265399] RDX: 0000000000000000 RSI: ffff888004ecc680 RDI: 0000000000000002
[   67.266094] RBP: ffffc900010b3b90 R08: 000000000000001c R09: 0000000000000001
[   67.266790] R10: ffff888004ecd418 R11: 0000000000000000 R12: ffff8880044d6e00
[   67.267484] R13: 0000000000000000 R14: 0000000000000059 R15: 0000000001000000
[   67.268179] FS:  00007fd010a36740(0000) GS:ffff88807ed00000(0000) knlGS:0000000000000000
[   67.268964] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   67.269530] CR2: 0000000000000008 CR3: 0000000005efe004 CR4: 0000000000770ee0
[   67.270228] PKRU: 55555554
[   67.270506] note: repro[393] exited with irqs disabled
[   67.271058] BUG: sleeping function called from invalid context at kernel/locking/mutex.c:580
[   67.271874] in_atomic(): 0, irqs_disabled(): 0, non_block: 0, pid: 393, name: repro
[   67.272623] preempt_count: 0, expected: 0
[   67.273025] RCU nest depth: 1, expected: 0
[   67.273431] INFO: lockdep is turned off.
[   67.273858] CPU: 1 PID: 393 Comm: repro Tainted: G      D            6.3.0-rc4-kvmmainline #2
[   67.274688] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 0.0.0 02/06/2015
[   67.275468] Call Trace:
[   67.275721]  <TASK>
[   67.275950]  dump_stack_lvl+0xe0/0x110
[   67.276344]  dump_stack+0x19/0x20
[   67.276702]  __might_resched+0x1c2/0x2e0
[   67.277111]  __might_sleep+0x46/0x70
[   67.277486]  __mutex_lock+0x54/0xcb0
[   67.277862]  ? debug_smp_processor_id+0x20/0x30
[   67.278328]  ? rcu_is_watching+0x15/0x50
[   67.278737]  ? io_uring_del_tctx_node+0x84/0x110
[   67.279210]  ? lock_release+0x1f4/0x290
[   67.279611]  mutex_lock_nested+0x1f/0x30
[   67.280016]  ? mutex_lock_nested+0x1f/0x30
[   67.280435]  io_uring_del_tctx_node+0x84/0x110
[   67.280906]  io_uring_clean_tctx+0x74/0xf0
[   67.281328]  io_uring_cancel_generic+0x452/0x4e0
[   67.281814]  ? __pfx_autoremove_wake_function+0x10/0x10
[   67.282356]  __io_uring_cancel+0x1f/0x30
[   67.282774]  do_exit+0x227/0x12b0
[   67.283129]  ? write_comp_data+0x2f/0x90
[   67.283549]  make_task_dead+0x100/0x290
[   67.283951]  rewind_stack_and_make_dead+0x17/0x20
[   67.284446] RIP: 0033:0x7fd010b5b59d
[   67.284823] Code: 00 c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d d3 08 0d 00 f7 d8 64 89 01 48
[   67.286656] RSP: 002b:00007ffc0d005148 EFLAGS: 00000206 ORIG_RAX: 0000000000000010
[   67.287419] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00007fd010b5b59d
[   67.288140] RDX: 0000000000000000 RSI: 0000000000005437 RDI: 0000000000000003
[   67.288862] RBP: 00007ffc0d005160 R08: 0000000000000000 R09: 00007ffc0d005240
[   67.289582] R10: 0000000000000000 R11: 0000000000000206 R12: 00000000004010b0
[   67.290298] R13: 00007ffc0d005240 R14: 0000000000000000 R15: 0000000000000000
[   67.291020]  </TASK>
[   67.364809] ------------[ cut here ]------------
[   67.365494] Voluntary context switch within RCU read-side critical section!
[   67.365535] WARNING: CPU: 1 PID: 393 at kernel/rcu/tree_plugin.h:318 rcu_note_context_switch+0x4f0/0x5b0
[   67.367522] Modules linked in:
[   67.367898] CPU: 1 PID: 393 Comm: repro Tainted: G      D W          6.3.0-rc4-kvmmainline #2
[   67.368885] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 0.0.0 02/06/2015
[   67.369741] RIP: 0010:rcu_note_context_switch+0x4f0/0x5b0
[   67.370360] Code: 9c d7 01 85 c0 75 02 0f 0b 49 8b 4c 24 58 48 8b 53 20 e9 6f fd ff ff 48 c7 c7 a0 f8 99 83 c6 05 a4 6c dd 02 01 e8 a0 bf ef ff <0f> 0b e9 a4 fb ff ff a9 ff ff ff 7f 0f 84 0c fc ff ff 65 48 8b 3c
[   67.372260] RSP: 0018:ffffc900010b3bf8 EFLAGS: 00010082
[   67.372800] RAX: 0000000000000000 RBX: ffff88807ed36180 RCX: ffffffff8111743b
[   67.373524] RDX: 0000000000000000 RSI: ffff888004ecc680 RDI: 0000000000000002
[   67.374249] RBP: ffffc900010b3c20 R08: 0000000000000000 R09: 0000000000000000
[   67.374972] R10: 000000002d2d2d2d R11: 000000002d2d2d2d R12: ffff88807ed352c0
[   67.375698] R13: ffff888004ecc680 R14: 0000000000000000 R15: ffff888004ecc680
[   67.376425] FS:  00007fd010a36740(0000) GS:ffff88807ed00000(0000) knlGS:0000000000000000
[   67.377244] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   67.377836] CR2: 0000000000000008 CR3: 0000000005efe004 CR4: 0000000000770ee0
[   67.378565] PKRU: 55555554
[   67.378854] Call Trace:
[   67.379117]  <TASK>
[   67.379350]  __schedule+0xe1/0xc30
[   67.379725]  schedule+0x5b/0xe0
[   67.380072]  schedule_preempt_disabled+0x1c/0x30
[   67.380563]  __mutex_lock+0xad4/0xcb0
[   67.380959]  ? debug_smp_processor_id+0x20/0x30
[   67.381444]  ? rcu_is_watching+0x15/0x50
[   67.381869]  ? io_uring_del_tctx_node+0x84/0x110
[   67.382362]  ? lock_release+0x1f4/0x290
[   67.382780]  mutex_lock_nested+0x1f/0x30
[   67.383201]  ? mutex_lock_nested+0x1f/0x30
[   67.383638]  io_uring_del_tctx_node+0x84/0x110
[   67.384114]  io_uring_clean_tctx+0x74/0xf0
[   67.384551]  io_uring_cancel_generic+0x452/0x4e0
[   67.385057]  ? __pfx_autoremove_wake_function+0x10/0x10
[   67.385612]  __io_uring_cancel+0x1f/0x30
[   67.386039]  do_exit+0x227/0x12b0
[   67.386402]  ? write_comp_data+0x2f/0x90
[   67.386830]  make_task_dead+0x100/0x290
[   67.387243]  rewind_stack_and_make_dead+0x17/0x20
[   67.387750] RIP: 0033:0x7fd010b5b59d
[   67.388137] Code: 00 c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d d3 08 0d 00 f7 d8 64 89 01 48
[   67.390025] RSP: 002b:00007ffc0d005148 EFLAGS: 00000206 ORIG_RAX: 0000000000000010
[   67.390805] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00007fd010b5b59d
[   67.391541] RDX: 0000000000000000 RSI: 0000000000005437 RDI: 0000000000000003
[   67.392279] RBP: 00007ffc0d005160 R08: 0000000000000000 R09: 00007ffc0d005240
[   67.393021] R10: 0000000000000000 R11: 0000000000000206 R12: 00000000004010b0
[   67.393758] R13: 00007ffc0d005240 R14: 0000000000000000 R15: 0000000000000000
[   67.394499]  </TASK>
[   67.394741] irq event stamp: 4450
[   67.395097] hardirqs last  enabled at (4449): [<ffffffff82fb58db>] _raw_spin_unlock_irq+0x2b/0x60
[   67.396014] hardirqs last disabled at (4450): [<ffffffff82f9476e>] exc_page_fault+0x4e/0x3b0
[   67.396897] softirqs last  enabled at (1580): [<ffffffff8107aa91>] fpu_flush_thread+0xd1/0x130
[   67.397787] softirqs last disabled at (1578): [<ffffffff8107a9c9>] fpu_flush_thread+0x9/0x130
[   67.398671] ---[ end trace 0000000000000000 ]---
"

I hope it's helpful.

---

If you don't need the following environment to reproduce the problem or if you
already have one, please ignore the following information.

How to reproduce:
git clone https://gitlab.com/xupengfe/repro_vm_env.git
cd repro_vm_env
tar -xvf repro_vm_env.tar.gz
cd repro_vm_env; ./start3.sh  // it needs qemu-system-x86_64 and I used v7.1.0
   // start3.sh will load bzImage_2241ab53cbb5cdb08a6b2d4688feb13971058f65 v6.2-rc5 kernel
   // You could change the bzImage_xxx as you want
You could use below command to log in, there is no password for root.
ssh -p 10023 root@localhost

After login vm(virtual machine) successfully, you could transfer reproduced
binary to the vm by below way, and reproduce the problem in vm:
gcc -pthread -o repro repro.c
scp -P 10023 repro root@localhost:/root/

Get the bzImage for target kernel:
Please use target kconfig and copy it to kernel_src/.config
make olddefconfig
make -jx bzImage           //x should equal or less than cpu num your pc has

Fill the bzImage file into above start3.sh to load the target kernel in vm.

Tips:
If you already have qemu-system-x86_64, please ignore below info.
If you want to install qemu v7.1.0 version:
git clone https://github.com/qemu/qemu.git
cd qemu
git checkout -f v7.1.0
mkdir build
cd build
yum install -y ninja-build.x86_64
../configure --target-list=x86_64-softmmu --enable-kvm --enable-vnc --enable-gtk --enable-sdl
make
make install

Thanks!
BR.
