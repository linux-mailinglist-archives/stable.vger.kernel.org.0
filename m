Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EAC65008AC
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 10:45:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241050AbiDNIr7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 04:47:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241099AbiDNIrz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 04:47:55 -0400
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14E2D65D13
        for <stable@vger.kernel.org>; Thu, 14 Apr 2022 01:45:30 -0700 (PDT)
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23E8MH9o025116;
        Thu, 14 Apr 2022 01:45:16 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=PPS06212021;
 bh=mjuCYclfqzmPUr8Yt4PkLBVoQyDEky8+NNbnAoei6O0=;
 b=SqO+WHYzibtKSIm9liJdKelFYFy4s1evZCn4/ebp3XKZe9j95ingF7kB3dhRBDNC73Wp
 dCjQdl1A0OJ3m3Ev1O7A+SEc9j3k3+cgtHr63o3ICoY+o81+mb1/tyg/Z7EEXVi6AY19
 RYHdVTJ7Q7sUwNyrV9cNwOh3BQP6P0hcJe/9dPcU+dypl2BKMMArPgTmwyPj1l97NBIP
 MrSxvKfxlph9KGLR5nCC3hDRqjLlVgzJmI0L/xh2eVAS8w4dazvL8E2xUjseoZws29Wf
 8VGN7yNQRbMlObX+UNyHWR49lgdNJYheUjg7a9ADs2Y53GIEsPYu47kjG0iPJN31ntsQ 2A== 
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2169.outbound.protection.outlook.com [104.47.73.169])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3fc0jeb4hw-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Apr 2022 01:45:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X6h/LKeuyL/y/ZK7FAkNSTUleuTjwdiRJNx2kWMn3oB2xfeEntSkBp32DlvuG+ajI89/ZG2OzBjMzboyqELCVPpG0YYnyQo5vjQrXVox8Wl712kUCq2h/Mme1+0XSDB2fU4lkzkRRBHleDrP4666KuDDaU4G3uws0kbpbO6Bun8F5D3RshjWRwC9nWNYPJIdEZ6PWnGsMDq0QMlCz4d/qTJfCzLhwKLZejTyrwc+6lc5f1sIL+mK7hvlgkNwyA6/9revzdkEVtiYbgstejxLkSC1cSKA9atqT3n4XG57eIvmHdentRQknW7yjSj8eJm/qVnM+7M9g6B3xxGCLCWHYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mjuCYclfqzmPUr8Yt4PkLBVoQyDEky8+NNbnAoei6O0=;
 b=F8/zv3W3CbOnj1tR8adUtbhMR0xdx5VmCTOF2Nl5JxuvMXiuKfWWSq5ceYbh1UL7cpKA5brQn+dCfiUxvVm6jEAH59QJf8XAgRljtZIyJBKtf+TB7Vc0wdWnhqq/khi8Gm0tMs+pVdid/Yd6cGF1Qgnv5uIIXoTeGQqDEIoEfk4QZxpfHlR+h9vHU6kvyzjtYRTyV/eH5ecRUw2dD0/Sg6RPKac3OlqviRzYejyeIKYr50NP9fDJFIoAe6eTIzlMW6HDvAAJjATzIDMkNDP8ZGvPTqTnxMv7b4ph3/71sE0XZmxeDKYDkWoHl+xcHroDHIQLkQ96XeSm7TIYgqKz2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM6PR11MB3435.namprd11.prod.outlook.com (2603:10b6:5:68::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Thu, 14 Apr
 2022 08:45:13 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d%4]) with mapi id 15.20.5164.020; Thu, 14 Apr 2022
 08:45:12 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     tj@kernel.org, mkoutny@suse.com
Subject: [PATCH 5.4 0/6] cgroup: backports for CVE-2021-4197
Date:   Thu, 14 Apr 2022 11:44:44 +0300
Message-Id: <20220414084450.2728917-1-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: VE1PR08CA0034.eurprd08.prod.outlook.com
 (2603:10a6:803:104::47) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7010cbd8-7b2e-43c7-4e0b-08da1df316e4
X-MS-TrafficTypeDiagnostic: DM6PR11MB3435:EE_
X-Microsoft-Antispam-PRVS: <DM6PR11MB3435F2BE6FEF5CAAC4D6446CFEEF9@DM6PR11MB3435.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LRSUIZbBOT5rza3FDSloprjk64GuMV68VBSMt0Fygez2w9EAmgMxgmkbxwJ4Xx8ZCLGgryyDihI8uKUbQAky/daJr8Lc6qrjAN24v3HerJcXe1GzhawJkmkeiyRlwvGq60co+TLN/7hkdb/9CC6E6uo691ib59oTDitep3g9JpdrE+nr491TqhN44BK9khXfMdkMwBBHwY8W/4f+CCU6TKdenpgjYcXcEmHwvbfbnloUlBreXkNpGIWrZo5h3LJryQkVpsqdrzjq1TQh++xNHxrhGqKMStA1Gs1KjKjo4kw/AZ54VdmyvqFCGsj4ZkRgbz741iStLoDg3As+3ynXFNxTbhbqHG+uzV2rpXK61qWUOBCJFfNfB9AGFAQP2U7hOALCok5zCHu8h+XY1sb01XXvsVy7KkAaTRkRVILu2M5bQ9WtLSQVv0ZH2KQlKFgvlgoL1o/rFsJMRfihvYf/MtWKT2BLFtKLbVPJN/EE+iMMK1sj3W/OLhKfJs88WoyKXv1cc9QpRA5CMfqTNqbnJsqUZmQ0WmOKRdiVW3Ua5XiMLJW4ckh7w4DSZWyrExa3YPASHw++MHQJFZBI7PlPCI2DWnaT5EoxZWL6DWE3bj7N4k7E2jn5K5Xt/lWSGhLZNRfLZokSJbKFWY+lGA/sYJcWwgR+LT38DqfNeaVDorKMZPKujg0p7GcyL7zyisDeUEYA9l1vkxbD7K5T0wf0vA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(186003)(26005)(6666004)(316002)(86362001)(1076003)(52116002)(6506007)(2616005)(38100700002)(38350700002)(66556008)(66476007)(5660300002)(66946007)(8676002)(4326008)(6486002)(44832011)(8936002)(36756003)(6512007)(83380400001)(508600001)(6916009)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TWlWSXN6WTFmMTBEd3BEbXRRb3FpRGJFdnJmNDZrQVJlY3JPQzEzYyt1ZzJD?=
 =?utf-8?B?RmZ0alUvanRzQ3dsbEIyMUxpdFk3UGpKdUxPUWJGOGZNOVoxRiswMlhhWWZB?=
 =?utf-8?B?S2dVT2pXeURMKzFoQ2Y2OVJrMlN1NEFBKzQyZEE4NHpUbDJUekxYSmtHY0xC?=
 =?utf-8?B?VUJlR3kzdkUyUVdoN25NOTVpREZrdzlzZVZvTjhsd3BBeFVMbzZYQi9mVzhL?=
 =?utf-8?B?bmRKVEpkS2NMeU9ubCt3cEFHZnArUVF0VXE3cjRvOHZCbWx1ZGdwUFBSNGxT?=
 =?utf-8?B?dnlOU0lyM0N5VnY0MUpuZXpYbWtKQzRrQnJGWjNEc3k0RzMyQkkvUmVsOFZV?=
 =?utf-8?B?dlJSaWNaR2lGcHk4S3IrMDVuTWNYZ1FaZ1ZWOTNuT3VhTSt6Qy9BMUcrRjlR?=
 =?utf-8?B?eXl2Y0JPa0RmemREY3FnNzNrZHd2aXJtWE92LzZqajBuTUQ5UldTNWQ4d20x?=
 =?utf-8?B?eTdBcm1HbkY3TVBKbzlwSnA4Y29naW1zYmJCVXJGNklKQXBMZkNjRTBYZEpV?=
 =?utf-8?B?QXFTUGxMR0JxUFdKYVBmbStVWjNENWg5bGl4QzlvSkVELytJbWx0NCtpQVQ2?=
 =?utf-8?B?SytJeDRXTm1IMjBpQXQ4dURqaEhmaWk3Q2JyWXZwc2FtL0k1cjBEMWVTcVFs?=
 =?utf-8?B?WjFWSWNYaGdjeXZXV0hCK0JvM1doUUFQV3pSV0pXamRiTFhuMzBoZHpzTDlm?=
 =?utf-8?B?ZnBUU2VXNFZqVnVwanBxTjlVd1Zuc284UlRHaGtmUUl4K1V3SFZldGxvSjVz?=
 =?utf-8?B?TmQycFdqdDRuNU5Rckk5cU5ySnB5dXhveGlkRzlzN1JTbU1MQUREUFRTYUx2?=
 =?utf-8?B?ck5BdmI1Z0o3RlJObTZVTTBNcFRVbytPT1RncHBDUVk0ZmVYVVQ1eUsyaDJ1?=
 =?utf-8?B?c1Q0M1RENUpvS0thM1JTRWtrN0pDc0h1c1cvUjJqZGVVVC9wY3BnM0JkZGdO?=
 =?utf-8?B?Z0dMdVhZdjBKTmZEbDdWUVI1Rm56VVlmU3hDTEcyN3lWZHBBMjFpbWFSMVJB?=
 =?utf-8?B?TDNrZFBZQmpQZ0N0U05lWkpQNjdJQkZxUE55ZzZCSXY4MzVSeHl5Znd3NWVG?=
 =?utf-8?B?dmRwWm92RCs0TG5pZzE2SkdOSXdLTWE0T0U4OFBVQ3JuSTNkelF4ajIxQTk2?=
 =?utf-8?B?OEE4cWdZZ1l5MEtSUGQrQVpUM2xDdm1PR3oyTFBEaEkvT0tpdHR2TUdPbHh5?=
 =?utf-8?B?Z1dYVWpuOTNTVThXTlZiNmtXeE54S1lSV3RPY1kwVE13eVN1ZzZrM2Q5SWNY?=
 =?utf-8?B?Y3ZWR1hYb1ppNUowZ05BTlVna1BsZ0JxUThtK1Y1bU03NXhqYjFlY0lPV054?=
 =?utf-8?B?UEJoRi9iUmd6NHp6VGJFaEx5bEJsS2tLSXlzcDVqTXZZVWF5YlJDcVhOaVZO?=
 =?utf-8?B?TVhYbDZJS0lCVFcvbFNCamxpUUYvZUd4dU41eGZ2SWlSNDNmd0RsVVZKblVs?=
 =?utf-8?B?TTN5Tyt1SGJ0MG90UVNmTTdzZzFXbjFQSDluZU9VWS8rOHBERHJQVDA4OW9L?=
 =?utf-8?B?Nnlid09WUUFBZkZiQmxMYyt4MC9TOUttTC8xdDhxM09Nd0Fua1UxeDFyNTd3?=
 =?utf-8?B?VVZXMlR6amluQS91TTNTemtrTGhkQnI5WjBST0JPS0tEbkI3YW9wZS9RTjRQ?=
 =?utf-8?B?Tm9MTTJyMGZXcWxPbkp1NjB0VzJFbDRiVUpaRFFJR0xLRVNvcXIvRTVYRVpo?=
 =?utf-8?B?M0JMTlVZZllBSGpJMGZ2R2k3Qng5WWpMVythek9BSHl3T0NOL040WGdTZmh6?=
 =?utf-8?B?S3FPOC9jUm04QUdwemtTajJkcUplOHZaTVJmVllsdzZJVVBJb1NVcmFWWkZs?=
 =?utf-8?B?aDNPSW5Jb1dLUzNsckRsTi9NUG50SWZzMWFndkpwcVRtR2JYU0p5OEFvSFhX?=
 =?utf-8?B?T055MU1kMzdJSFhNZ1RySFgzNy9zV3VERDRXaW1QNU9tQ1FONFhNUjhFMDJE?=
 =?utf-8?B?a05tVnhnOUoyRmtZcVUvaU5VTmVmRC93QnBaTXVWMUpzd2htWU9oUGhmSUhv?=
 =?utf-8?B?SldnTEFIemRFbitFeERPVy9lVjhXSG5QdFM0QTdOZzB1Zmo5bGpDUVNmV2pO?=
 =?utf-8?B?UEVCMWZXZkNReXh0a0dFWHJZRlZ0NmpoNW1XZzdGUzRtVTArMVVIZG1ody8r?=
 =?utf-8?B?WFJXZ0JJWGl1WkJxRWlMRmVHaFhjd01UQWN6ZDEzdjVqQTFJTVJhMm5scUk0?=
 =?utf-8?B?WkZRNkxEUnNpYnRsY2t5L1U3bmtObGVoOFZTVHQvWDZhRmFaNmxCUHdCZE1M?=
 =?utf-8?B?KzRSQUx5UlJRN1VGYUVzTW93Wm5KVk1zM3pTMWFtM2MvWm5OOENjaW5kZC84?=
 =?utf-8?B?WTNuTm1TSHl4dGluM1JSbm1MV2U2eUgrNllMQUYybmF1YVJNZ3NzSmZqZlVM?=
 =?utf-8?Q?cCmLUkeB/sqEATF4=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7010cbd8-7b2e-43c7-4e0b-08da1df316e4
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2022 08:45:12.6852
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ak4Mg/xFjuAUurdxrwoM3qQBQEe+gmHkHm0OOt4D739dV+f9D2LVqvLjutTugh/JEe2p1KRBXJkzgeffvSM22fcH7lHx26FUwMFoOCb8idw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3435
X-Proofpoint-ORIG-GUID: Cdom-C6JFKBdzyrBSw5Z9KYBCPHcGukl
X-Proofpoint-GUID: Cdom-C6JFKBdzyrBSw5Z9KYBCPHcGukl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-14_02,2022-04-13_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=556
 priorityscore=1501 lowpriorityscore=0 adultscore=0 impostorscore=0
 phishscore=0 malwarescore=0 clxscore=1015 spamscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204140048
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Backport summary
----------------
1756d7994ad8 ("cgroup: Use open-time credentials for process migraton perm checks")
	* Cherry pick from 5.10-stable with minor contextual adjustments.

0d2b5955b362 ("cgroup: Allocate cgroup_file_ctx for kernfs_open_file->priv")
	* Cherry-pick from 5.10-stable, no modifications.

e57457641613 ("cgroup: Use open-time cgroup namespace for process migration perm checks")
	* Cherry-pick from 5.10-stable.
	* Backport to 5.4: drop changes to cgroup_attach_permissions() and
	  cgroup_css_set_fork() as the two functions are not present. Also,
	  adjust cgroup_procs_write_permission() callsites directly in
	  cgroup_procs_write() and cgroup_threads_write().

b09c2baa5634 ("selftests: cgroup: Make cg_create() use 0755 for permission instead of 0644")
	* Clean cherry-pick.

613e040e4dc2 ("selftests: cgroup: Test open-time credential usage for migration checks")
	* Minor contextual adjustments.

bf35a7879f1d ("selftests: cgroup: Test open-time cgroup namespace usage for migration checks")
	* Minor contextual adjustments and added wait.h
	  and fcntl.h includes to fix compilation.

Testing
-------
The newly introduced selftests (test_cgcore_lesser_euid_open() and
test_cgcore_lesser_ns_open()) pass with this series applied:

root@intel-x86-64:~# ./test_core
ok 1 test_cgcore_internal_process_constraint
ok 2 test_cgcore_top_down_constraint_enable
ok 3 test_cgcore_top_down_constraint_disable
ok 4 test_cgcore_no_internal_process_constraint_on_threads
ok 5 test_cgcore_parent_becomes_threaded
ok 6 test_cgcore_invalid_domain
ok 7 test_cgcore_populated
ok 8 test_cgcore_lesser_euid_open
ok 9 test_cgcore_lesser_ns_open

Tejun Heo (6):
  cgroup: Use open-time credentials for process migraton perm checks
  cgroup: Allocate cgroup_file_ctx for kernfs_open_file->priv
  cgroup: Use open-time cgroup namespace for process migration perm
    checks
  selftests: cgroup: Make cg_create() use 0755 for permission instead of
    0644
  selftests: cgroup: Test open-time credential usage for migration
    checks
  selftests: cgroup: Test open-time cgroup namespace usage for migration
    checks

 kernel/cgroup/cgroup-internal.h              |  19 +++
 kernel/cgroup/cgroup-v1.c                    |  33 ++--
 kernel/cgroup/cgroup.c                       |  93 ++++++++---
 tools/testing/selftests/cgroup/cgroup_util.c |   2 +-
 tools/testing/selftests/cgroup/test_core.c   | 167 +++++++++++++++++++
 5 files changed, 271 insertions(+), 43 deletions(-)

-- 
2.25.1

