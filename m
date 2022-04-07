Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C56D4F7755
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 09:22:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236408AbiDGHYK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Apr 2022 03:24:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231377AbiDGHYI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Apr 2022 03:24:08 -0400
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F35F2D8
        for <stable@vger.kernel.org>; Thu,  7 Apr 2022 00:22:10 -0700 (PDT)
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 2376oBkQ023969;
        Thu, 7 Apr 2022 00:21:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=PPS06212021;
 bh=x+QyGJOkpBL4fZMX4TXZL+LlJAZ6m1UmFpNOElcVBbI=;
 b=TvJS+01fUkT9mjqY3uK2Zhs/7bVPRb+6k+vjfkE8Knqvf57cyXv2zfc3SF70Z+j+FtSR
 e5i39HHZlNbpiFPx8grYW4RoAUwBrhw6Pq6r/wlDSVGYuz6Lpv6X+U+TZWEGykRg+gLo
 43waxtPOvYTXPJlNWsDx0kSrd3GpnqqQ1Z/Ee3oZ7m1wBwTEyP656zK5L9BVc04OG1Fz
 oKxZBWU6XSUBOAToQt9CqkejIIAU+gd6B1b0NtQSh+RytVx+Nc15GKB7qFVQpQhJ6q44
 6hC3wqm5RntyMXW03+qo/mP9iqVSRbguy8fmhYlp+MF88d3BIVzhSE8oW8awSGVgACFJ 1w== 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3f6hs3uxsd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Apr 2022 00:21:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PS7o3HBaAMJHRcN7+T4R/poF96Qt35eV0jxtKpaMvk+43yjAOz3WGu9NiXSDBNoJr2M6L+a4s1FYMR3urpF4EOwZUyT33rjNLujIcPFyrkzJBwgsBXbXurMdUuBw3FbJnhaBnriByX0riDPEUrLm0HcFSgKoVKXCdq/JHYal4poTSYGOt6tZYssqWbTUnzcRGr6g4pCwDPJStTU6D8dtpW0Ysk5ibgd/DOWqwlH9fkdC97q9BBEbA1utO1rGl+1fAWSAwDw8BZp2u2pWQxC9c4SrI0xdSnG7nmfFU1bF+UweyKUiLK1KDYQZLB79nhHDELpPJ/8CYbSLAK/T5fvCcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x+QyGJOkpBL4fZMX4TXZL+LlJAZ6m1UmFpNOElcVBbI=;
 b=EnL3miUKIcmXbvG/z5+00JwaqHykJK4Jo/nl3wxZLq7g1KE8ufBjQ3veZfBA0x31pXOs86Xq28m4WMGMs/H9X8mO9ojFMePulUlgNcDqWkbZfd3qxV7SvbVCts0T9tILM1dnMYq72vD02UyeZNAXsPqEOGmsPkmhYRs0df+2O8lKM3q6fy/soVK2UW0Q9qJ2AdJuh+e6Lqy8jdCKxhto7QlDcUtGt7FyOJP8d/E3wXxnavB9I6CZHnoeyR8gknSBHfi3OknJcNnnEIvGIxp/gCT2p1azrHK7GQGQ71aPS0KlC7ZKpIzpdZD/qVjTwFHahCpyZzs/WeY2lVk+Vx4Cfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM6PR11MB3371.namprd11.prod.outlook.com (2603:10b6:5:e::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5144.22; Thu, 7 Apr 2022 07:21:57 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::fd7f:8915:60b2:cacf]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::fd7f:8915:60b2:cacf%6]) with mapi id 15.20.5123.031; Thu, 7 Apr 2022
 07:21:57 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     tj@kernel.org, mkoutny@suse.com
Subject: [PATCH 5.10 0/5] cgroup: backports for CVE-2021-4197
Date:   Thu,  7 Apr 2022 10:21:30 +0300
Message-Id: <20220407072135.32441-1-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: VI1PR04CA0094.eurprd04.prod.outlook.com
 (2603:10a6:803:64::29) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a284d332-f307-4b05-9e41-08da18674c9e
X-MS-TrafficTypeDiagnostic: DM6PR11MB3371:EE_
X-Microsoft-Antispam-PRVS: <DM6PR11MB3371DAB403640FA58AF1AB8DFEE69@DM6PR11MB3371.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a4fLrPLx4uhuuOquKDgESuvVVih1dcSCZhpNMM8sUc6tPCqvPXW58lhEfkMohb8qtzOsQslMbDw+Z3Mqgj9yQUPPqRyxStaowd8bT5okTaJOyzrq9H9Hts5w7qUXgm0VNIdOgXAPI5KSSIxxywALxy5RgjcVzhWG7MH/o1s95QmnJvgELF3wDhJ71pz9jIfdz6tAS2PCYmCzn6OGthJqsCTcke57rEXq1STMdxRDrXwrGPsCLLGYDTUqnZ4sgRmI3vp55sXFOo/0JxZJyWRBsRfe9HltSOe6xpAMm3o1v1uqwUr28uG/QwbQvh8v0mQpU8NvdWQfl1LGblDnJPlDH/1TC9Ac97CnNzRAhMprkX6+kJTM2CuJDVH6n1STbCWTz5NXlOI9R/RMKVL2zFfGIqzxvJFVnD6nDlNVTji6NAHsWGMfq1nimSNdXcLLqHZKlduMl3wM1/wXASfVJc3XBw+FoYTPb9CYdL3cFgbtCctpNfpLWRdYRQUQbI1SSLceJ4bm5googr7PWj+IcJ7lWN9xYjuhDaivSOI987mWHxKiyNjz7PjK/oYZ1lrBWQv8RwIEChR8jSd7kpQFzmOAuoHxDiN9VP+PAwzI9ggJpoSIO3AxDreRBxR0Mw6qfk87XkrfQ+yaX0hcLf7TIoBYkI+VJ4CGrPM0ePApLKyfy2h8mH6sQzAR1usF6lCF4mmTC8CMKHJ36XpL7beOHxxzRA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66556008)(1076003)(66476007)(6512007)(66946007)(8676002)(44832011)(4326008)(38350700002)(38100700002)(5660300002)(6916009)(186003)(26005)(2616005)(316002)(2906002)(36756003)(508600001)(6486002)(6506007)(52116002)(8936002)(83380400001)(6666004)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZzJnV2d4TzR0VzRrL1ppc3B4NlRsOFllNFJtelZlaVBVRTR0S21XZytETzdJ?=
 =?utf-8?B?Qmc4bnc4dGJsWTZyOHBLMHZBWkc2bUZYQjFKMG03bTdhMzRsa25lTXZDVGlw?=
 =?utf-8?B?ZjZ0ajZqRGhuR2lTbXpyS2JteW9IZXowc0g1UTVnSFlhcFdoYjRCK2hUem9U?=
 =?utf-8?B?QWNRSnE0bm5yUmVOWDdIWDRJMXZobUVnWUxqZ1VFOVFBTVRLZUdpT3h1bWVz?=
 =?utf-8?B?N2ZQNTE4ZEhxRjRiSFlMbDJPR1h0VDhOcXRjR0EwRDFyRE1DMU5la2VtSzY4?=
 =?utf-8?B?MDNWbkRNaXdBNkNUR29OQitDcGgvUHhaVVUxcVBWdDVnS29URUN0VXh6NzlL?=
 =?utf-8?B?SGFwcnE4c0xkTHBqRHVhQVNwVzhIWXg3T0hSQUkyWmdhdW5lR3laMC9FbmIx?=
 =?utf-8?B?N1ZjYzFyV2h6M1VNdEtnZTJndWtKRkNFOG9VL0tuZ1hLOTJqdmVUSjRUZWJR?=
 =?utf-8?B?ZzM0R0huOG9BSi9iYXl0Z1FXSHFjUGdIVDg4b0lpSDRUQnVJWkNSUU5FaG50?=
 =?utf-8?B?c0RVNWNCS2lWTE1vN3Z6eDNlZlFYOVUySFJQMmMvN0NvMjZQRWdPWVRKeXhB?=
 =?utf-8?B?d0FpdEowTUlYSjdKTG41eEV3QnVDb3lWakE5c2Q1MWNXTEJEV2ZSRk55M0dW?=
 =?utf-8?B?SUJxMCt2OCtldkQ1VEJqenRlNEtZYVlXc2lRamh6RTYvZ1pITWE2NkxTTHcv?=
 =?utf-8?B?SVd6aDZ6bUdKeHhVallQM1pSN01DQUI1cWtSbHlLMGptMDhWd1ljREpnMHpm?=
 =?utf-8?B?aDFZQk9aSGY4NGpYd1NQNDd6WGNacTA0UnJZSE40d1J6M3FtVHFoYUJJcDFn?=
 =?utf-8?B?Skh0cHZZbDdMcXA4V2M3MWxwNXhHQjRMMnBvcGJ1SmRBMy9PNFRJVWxlaVJP?=
 =?utf-8?B?aFMwRkJvb1ZWa3ZINHcyU1lxZmZobkIzcDVwbzFvU25idkRKdkMwNGkzR293?=
 =?utf-8?B?ZFBrTCtGc2o5aDV2SHRXM2R3Wnk5WXVYdUR5eDR5R1RZU2J6ZlZrZzJuQjQ0?=
 =?utf-8?B?bSs5UWVFbDV0cUl6VXpVYzVweEFZbHJhWlNoQnlyQ2dpZ2dQRGlPN0FCR21L?=
 =?utf-8?B?MjNPeVNkTTFweHhuaEFJbVhURUY5elNVamJVUVppQnQ5cVV0VHNydTIvN0lB?=
 =?utf-8?B?aGpMcHdpQmhwNnNYOG96NS9kdFNpR1h6NzZlQ0tWSG5qN1pCaERvWVlERmpV?=
 =?utf-8?B?TTh0U2FwR1JVTGlzSW5jYlcrdDdOT0x4NS9YTHlicVhhZHRZcHpUMldaSHJE?=
 =?utf-8?B?WWc0QlBreDRBMWtwSUhSSDB2SkdWek5PNTFkNnFJT0s0b3RUVVNXR2VBMmNv?=
 =?utf-8?B?RXpwTXdOanhqbDExWTdTWDFCenlubHdUYVVpa1J0ZUM2cTh2NUJoSXlJL0hy?=
 =?utf-8?B?YVJ6Unk5SVlRNWdzQmFUaC81eGpCbUpUemw3LzN1L01McXViekM5bjhKSUxn?=
 =?utf-8?B?NGROME5sYzArLzdrbnVKaHhxdEk3OVV2YVJGYStSTHVmdGd3VUsxbk0rYXRF?=
 =?utf-8?B?RURCZ0s2RVN6VzJWREFPVjk0WHJLRm4zNlVXUVRBOHJZdHArMnRlc2tXL21n?=
 =?utf-8?B?VkN2Y0MybUpGQVFJdkZiZnJiZ3RsbjRrcEZNMEFtellNR0pZMEVHMXMzb2cr?=
 =?utf-8?B?SFB4T3AxRW9RVFYvRWJqK1JpS1VPRkJpWVE4d3hQVWtiQklGN2l0cEttWEdT?=
 =?utf-8?B?ZTAxY0l5dmtaQzVZM0VpbGdsNVd5dVpXWjhUaFJrSnlheXNta0szT3p3TW14?=
 =?utf-8?B?cmZ5V3NuU0pVb1BEelhSa0o1Qkkra1JsYWFHQTN6T045WGNxWWdBOXZsSUxP?=
 =?utf-8?B?U0RZdnZrK0c1b0RQekZOandxUEFIazdMZE9wNnpuMVkweGdENXZodWJSNXRO?=
 =?utf-8?B?QXZWaXRBS0tia09DM3pvaUljbTVtRHdxeHJaN2NienYyK3EwT0p4OFdwTFBy?=
 =?utf-8?B?NUNrdEtEODNMSHBVdHNodjZDMFFzbjhuazB3aGM3TzdvZEZQM3VBU1VldHU2?=
 =?utf-8?B?TzMwcXRyMkU2NTd4ZWtxWXh1UGpVbFNrKzJEWldFWHkzSWdzcURrWUxvejY2?=
 =?utf-8?B?MDJiR0JjR0EyOExPNGxIYkR0Wk1PSUFTVVlxNURCTXlzUFI2L0xCUG9jWHNl?=
 =?utf-8?B?RTFRcVNTTkV6cUJqN2VrR1BLcTFucXJydktxWHV6OUgrakhYT1lpdFkzTlBE?=
 =?utf-8?B?bHV1eiszYWlNR0R5MGExSTM1aUdQdkZHeXU4L0xxM2QzWXlOY0tmREVnTVR1?=
 =?utf-8?B?SmRQZnhhYWk3OWZKRTdhamNuL0ptS3dEQ21MNk81MzZ6U0RMdGFlemplWVUy?=
 =?utf-8?B?M0t2RUNOZHlkeDQzTlpjWHlDZkdvaURRL0ViZE1VYit3ajR5M2RlYi9Yb3hi?=
 =?utf-8?Q?Vce5u9nFSK0fhzKw=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a284d332-f307-4b05-9e41-08da18674c9e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2022 07:21:57.6726
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h6dM0iygZA/uEKn/o8SfnJH7RIo5qG2tjVXeqO7h9KeK2RBQd9ZhLGMNAG5YWhh3ovSibyirK5GP354OYaZjUM9S+gd1eFR5ypMZIJ2RZtY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3371
X-Proofpoint-GUID: RngRheZar9DcJXVbEpRPcV_vPuQXJVR2
X-Proofpoint-ORIG-GUID: RngRheZar9DcJXVbEpRPcV_vPuQXJVR2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-06_13,2022-04-06_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=606
 malwarescore=0 spamscore=0 clxscore=1011 impostorscore=0
 priorityscore=1501 adultscore=0 phishscore=0 bulkscore=0 suspectscore=0
 mlxscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2202240000 definitions=main-2204070036
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

CVE-2021-4197 patchset consists of:
[1] 1756d7994ad8 ("cgroup: Use open-time credentials for process migraton perm checks")
[2] 0d2b5955b362 ("cgroup: Allocate cgroup_file_ctx for kernfs_open_file->priv")
[3] e57457641613 ("cgroup: Use open-time cgroup namespace for process migration perm checks")
[4] b09c2baa5634 ("selftests: cgroup: Make cg_create() use 0755 for permission instead of 0644")
[5] 613e040e4dc2 ("selftests: cgroup: Test open-time credential usage for migration checks")
[6] bf35a7879f1d ("selftests: cgroup: Test open-time cgroup namespace usage for migration checks")

Commits [2] and [3] are already preent in 5.10-stable, this patchset includes
backports for the other commits.

Backport summary
----------------
1756d7994ad8 ("cgroup: Use open-time credentials for process migraton perm checks")
	* Refactoring commit da70862efe006 ("cgroup: cgroup.{procs,threads}
	  factor out common parts") is not present in kernel versions < 5.12,
	  so the original changes to __cgroup_procs_write() had to be applied
	  in both cgroup_threads_write() and cgroup_procs_write() functions.

c2e46f6b3e35 ("selftests/cgroup: Fix build on older distros")
	* This extra commit was added to fix the following selftest build
	  failure, applies cleanly:
	  ...
	  cgroup_util.c: In function ‘clone_into_cgroup’:
	  group_util.c:343:4: error: ‘struct clone_args’ has no member named ‘cgroup’
	  343 |   .cgroup = cgroup_fd,
	  |    ^~~~~~

All other selftest changes are clean cherry-picks.

Testing
-------
The newly introduced selftests (test_cgcore_lesser_euid_open() and
test_cgcore_lesser_ns_open()) pass with this series applied:

root@intel-x86-64:~# ./test_core
ok 1 test_cgcore_internal_process_constraint
ok 2 test_cgcore_top_down_constraint_enable
ok 3 test_cgcore_top_down_constraint_disable
ok 4 test_cgcore_no_internal_process_constraint_os
ok 5 test_cgcore_parent_becomes_threaded
ok 6 test_cgcore_invalid_domain
ok 7 test_cgcore_populated
ok 8 test_cgcore_proc_migration
ok 9 test_cgcore_thread_migration
ok 10 test_cgcore_destroy
ok 11 test_cgcore_lesser_euid_open
ok 12 test_cgcore_lesser_ns_open


Sachin Sant (1):
  selftests/cgroup: Fix build on older distros

Tejun Heo (4):
  cgroup: Use open-time credentials for process migraton perm checks
  selftests: cgroup: Make cg_create() use 0755 for permission instead of
    0644
  selftests: cgroup: Test open-time credential usage for migration
    checks
  selftests: cgroup: Test open-time cgroup namespace usage for migration
    checks

 kernel/cgroup/cgroup-v1.c                    |   7 +-
 kernel/cgroup/cgroup.c                       |  17 +-
 tools/testing/selftests/cgroup/cgroup_util.c |   6 +-
 tools/testing/selftests/cgroup/test_core.c   | 165 +++++++++++++++++++
 4 files changed, 188 insertions(+), 7 deletions(-)

-- 
2.25.1

