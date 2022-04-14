Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B260F500949
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 11:07:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241191AbiDNJJy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 05:09:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238667AbiDNJJw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 05:09:52 -0400
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D62636D962
        for <stable@vger.kernel.org>; Thu, 14 Apr 2022 02:07:27 -0700 (PDT)
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23E7VnPb023485;
        Thu, 14 Apr 2022 02:07:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=PPS06212021;
 bh=16oOx6oeZRf4Kt4gLf0E9/rmCNY3nehLpB/BdGVRonw=;
 b=Pqrj+utMVINtVe7mf5jmyJF0y08BEbH+bDSqJA7NmPvLwb0emCNvyNruXJk3GR5uAfLk
 3NhP3YBpzo/uOdWnquP8hTvzsQ0w65ck4AUL/VEHlEmHo+dQUGrxBfI1hnAp7dNsGhvM
 OtT18wQd2slXCz0J4lGgP1WEdfVzS+1Z1BMXPlmWLOYKPfmsq24JKul+D8oqD0Cfakkg
 gdZuIxE1gkXI23pYm2UrNEAB69I4lxQrEq8rSyNo58W/TaRVpHg9FZpdFTNBIKTSCUkI
 9cv2c/sfmZEmUKAR4G/ERhII6fnKr/iewAp2YCQNZd0dV/TbSES2D//mk9FS2DkgqkLB 6g== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2176.outbound.protection.outlook.com [104.47.58.176])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3fb9nfurtg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Apr 2022 02:07:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mek/lW5bjHmOGA9ydDh/qiOvS5cemKwKSUfx78kfa8D8QbIrE2HiX7uomdqNxP4th+xJ+YlgSXfj1RGHHJ2cGljuBBM5djm95TJt9crpYJec3C2yUz5E1CrcHQtPjyvf45Rmxyb0siPWgKT9Q0A32fkUVAtPwzPVtcx8uEJmDqFeBK21b8/ZJ96BHYlOJoQl2BqYmtTwkEayq8ImNzlDJyGziG4Qd4DbAQ6Z9+/kZmXNSQtiZTdWjS1++UZodGIOIKUrTTGjLjhT/RBGOkSm7jc30TbFtfLWD+vEATXZfGY/UH/3h4ymSKzoXDfSce2Dkb2L13msZvM1fB8pNZAi/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=16oOx6oeZRf4Kt4gLf0E9/rmCNY3nehLpB/BdGVRonw=;
 b=PKTfvb08ALJBg8j74oFL9D0sw9gBhOXx/nSOxO/7JXvpxs+0TklVO7V923HT3hdtwGv982MEXeabEDZuPDcMfasBCaeCoKzEbmCWLpkScYOIKFalkDiOdLSbERkj+qAE4niWnEL7n1GK1LBAWRxbAhNgh7L3VMczBrHWYbfwaDAoVsT4is14Zwip9iRrubJvEe8U/KAj05ILOd5tUeo7UW+7A48Rfb3Gc0ccrk24ir0Ild/1E3jY6OygGvn6Fnqs+tYjsJuT7sp60oALwNEnP4hMX/VW+wP6ghLqbNGECG8ce1CI8tm0whh5S6wD+brsKvNtAyvXrfvEIoQZ0PCbqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by BY5PR11MB4356.namprd11.prod.outlook.com (2603:10b6:a03:1bf::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.18; Thu, 14 Apr
 2022 09:07:20 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d%4]) with mapi id 15.20.5164.020; Thu, 14 Apr 2022
 09:07:20 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     tj@kernel.org, mkoutny@suse.com
Subject: [PATCH 4.19 0/6] cgroup: backports for CVE-2021-4197
Date:   Thu, 14 Apr 2022 12:06:54 +0300
Message-Id: <20220414090700.2729576-1-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: VI1PR07CA0263.eurprd07.prod.outlook.com
 (2603:10a6:803:b4::30) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6211835a-adde-4a37-1945-08da1df62e2d
X-MS-TrafficTypeDiagnostic: BY5PR11MB4356:EE_
X-Microsoft-Antispam-PRVS: <BY5PR11MB435631CFE56BB4488947B3DAFEEF9@BY5PR11MB4356.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oxSEUpQUL824gTVlXWAVgn80uUA3xBE3nCQXxDgO0KyeQYHgT2+/LdDQ/beB/6AHVy93YmiTPTVz/lQ0Gyg/5bkUQKbsFl5OFsG6++pdj7XWUz3SlEYea6R6aKIyn4t1ZuBo7UczCJq+hSG9lsMgH+q3EgR6Rl49x75s7ryTQgyAqd7Qbpr3SvNOtfADfsekR4RLmwciDrL53LN+xFUnoiA2lae0/jUyIv23oI+pCz+cZQmE32QlJZJ+wyYNuimlgH3nkUPYLVLU0+9/s0J4Ff5ekRmVl/rp3JhncNp1Fa8i17SFtbEeDj6imbpnnY1vLQuUI6XPAR98zvcMsvGvCbblJwcs34hu25fHO2tSv3PpSTNCnt+YzNyfpqHYD9kAUTJ/TGqCZqTKkcYwf8OEDoxxSSyb7YKvhDnCK9hqEclBs+FnBuPt+2pCJt91OmpZjWUOUpwQNJReUb9O7jzp2F6yEtgDhM5z2a1Sf6uVIvqlp0T7L6ytu5fn3Ie9gwCM6NMOee8yZTgxmw6w2b050WJyNliFUJAUgNC6RqJBg2CVghXe6IybkmG1Y5s6UELS/1av+mRc5Z9AfXEzdDIWpJv80O+fG8yxM13A3rrGh7m1quKk8tNUXcH2uzM6bYoUzAyyolZ0hwumH+A4SFMvoycOwbalj5oVnA6ecQbhr3Af11yNxuXg2sK2gy7DFKz0JMDBAmF/fDrTdPnt+3A68Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6916009)(5660300002)(52116002)(1076003)(186003)(8936002)(6666004)(26005)(36756003)(2616005)(6506007)(6512007)(508600001)(44832011)(316002)(2906002)(6486002)(66556008)(66946007)(66476007)(38350700002)(38100700002)(8676002)(83380400001)(4326008)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WEc1ZjNQM055Yk50QVJadUJoTGxCQWxRTGJOa25sSnQxeUxGQVE5RDIvMzVP?=
 =?utf-8?B?WFhxT0FMY05JQzIvbVZtL24vYnBNRTNUNWVBZnZESXFSRkx5Rzh4RTMrTHZY?=
 =?utf-8?B?NFZIa2plRE13QitGcWdEZHF0U3dPT0lwSTZVK2Uxc1N0SFpDMENUT3NMMWt3?=
 =?utf-8?B?bUxPUUdTMVNmRWZ1RnVjRG5nSFV5bVpCNmNxSWYwRHN2b2lJcHZMYlVHdm54?=
 =?utf-8?B?RHFJZzl0dU1HYVUvaldURHZyYWVjbDdhejRhNG9YY0VxVERWWE5MRDlvc0FO?=
 =?utf-8?B?bmczT3JLMTk4RWtSN05PQnNVUHB3R0Yrd1pUckxCYlRNM0xTTTZOOEdVR25j?=
 =?utf-8?B?V1ZPNXdaNVl5d0FHNUh5dXVYMkM2b3o2T1EwWmJZMEh5OUM5SzRIWE02MTBX?=
 =?utf-8?B?VDlCY0MxTyszTWJkWlJPbEZWbzdvVFdsaXdjaG5KN3o4eE00YlpKakR3alpt?=
 =?utf-8?B?cG1vclM1b00zY2xHNDFXLzdtWjZUcnJJaS9GV0VDS2lrdnpJZ29aSWtYUEdG?=
 =?utf-8?B?NldyZFp0V0FxaXNGM0VLK29vZEliclpaNGlwM2VrQTAxSTBYaFdzb3plTnhn?=
 =?utf-8?B?S0Y5KzFLVmhTR2NCZjRoSXNpN21KQ2JSNThtMGUrbzZCMEMyaGpWTWtRby9P?=
 =?utf-8?B?Ylh6K3RMNW5FekdVNDhtUXBqZktDVTQzYVovZkNpUWxyUmlJNlB3VGNncVY2?=
 =?utf-8?B?dWVqdG9CU1ZxYWs1RkQ2d1dTMUF2NnV5dWROaXFLenJMNHNuVzZ2NStkd0N3?=
 =?utf-8?B?SEhxVzNQYkdQTmpFSFE2eUYySlhwVHBxZUJzeVdPQ1R2SmZzQVlLclkrV1Bt?=
 =?utf-8?B?SlhNZy9PU05aMFBQWG1wc3VqMnNza1dVaFprTDZhczgwa0JsMFV2VGZ3MlFq?=
 =?utf-8?B?UkdYMUM1WG1XSlcxVG9KeVRJUVpyb2dPNkVCNE5saVg1VnFmTnR2ZDhLc3Bu?=
 =?utf-8?B?SWIxeUZ0OUFuSVM2UTlpZm5WYStHRDdqWlNxbGlIRm02SW9ZTjZ0Vi9qUkFu?=
 =?utf-8?B?eXJOdHhHQWxMaVp5UExkSGpISUJQQVlTTTkvSmw3YmpRUGtwVjMwNDV2aGdh?=
 =?utf-8?B?Y0pmcmlqZDNzK1VpQ28rL1JOL0pqZk1kMEovR2NCQlNvTWtrQ1A0dXlqdHVm?=
 =?utf-8?B?WThyMEo1Vm1idGMyU3Z1RzdjSUtWTlhVZUc0dEtGRjRwaTJxNHlrUjFDQjJq?=
 =?utf-8?B?RDhaUFQ0NWFtREFCdUdBbm4xOHh5WkFKekN2dzFSMnV4K0tjMkpEMjQwNnpz?=
 =?utf-8?B?L2J1cVRHWFZnK25ab2c0OHpxdTJPNHQvVngreXpvMDIwOXdCTWlCUWpqNTN2?=
 =?utf-8?B?MDNxSGJFWnlkeEYzK1JIVEw3QTdxcXplQ3h2MkEwOFpBZVVmamRLMWJ3WXBv?=
 =?utf-8?B?ZE9scHF3VldMR0ovU2RhWGNZUzFGRy90dnNKVjI0bVR3dEl1UkRBdGIxVTNC?=
 =?utf-8?B?alc4SmtJaHZISDRHQXpURi9Nd2M4V2w3SWhRSENHcHBmbUxLR0VFTlVDMU5r?=
 =?utf-8?B?NXI2OGM2dUxlZTdFZ3F6TG8wdVZpNVc1R0Y4RkhLU3FlVXl4ZytaRjVVdG8y?=
 =?utf-8?B?aURNWEpyVkdQa1lFT2VRamRIaHhJbDdQZnZoYlVlSTNNaHA1MVoxV1lKUVIx?=
 =?utf-8?B?dGtwK0tLUGM3enNMRUM5Wkk1elR6dmhnVkV6NXFxUVpYMTRlVzkrb2JpcFZL?=
 =?utf-8?B?cE5xS3BpMW5nKzdPWW5nNWN3dHhhVVlFK1c0WndwcWdFWDJHSjlCc2RsR0Zo?=
 =?utf-8?B?Q3VOek03RmFnak15dk9mRWh4TFZSL3AyVGtTSkwzZW5oNmFxaUwwd2NkZnZI?=
 =?utf-8?B?SWMwS0JZUjlZWWxVdklVM0xsWEFhTGwzZlNhc3FBTGVCM2JpblBCaWRpc1V5?=
 =?utf-8?B?ZEtRSXdqMkp1RVA4WHgySlNTWGVrcWhES1FlSzlYTHFyTmJpYTQ1aGpTeGMr?=
 =?utf-8?B?bmwyMnAyanFhaityb1R5OGJhOGE3NGxEN2E4dTArMTNWN2hCR0dvdEFuWDVa?=
 =?utf-8?B?N08xclNic3NHLzU3eEJDblI5SXFLaGp1TnpPaFZiZi9Fd2htZ0FyS3g4Kys1?=
 =?utf-8?B?RmYzMXJ6c3V2VDVNSmhOUXZhWnJwQ3pYUXNKRUxOVFV0ZjhuQlBjQUJ0eW9p?=
 =?utf-8?B?MytxTDdmdE1NTndzemU0TFdKVUpsWVZITzUwcytPeElLOTFqTUVGK2VOSjBZ?=
 =?utf-8?B?eXdENUFXYmRHQ21vRHFUaVZ2V3N2MFhLWHdWM0RMSDk5NDRJUmFGSGFpL2pt?=
 =?utf-8?B?VzJRN1VqMG5wMGZUZGQ3QUt3N2h6Q3BJdUpWcUJTRXgybHB1MDB4eGJFVms0?=
 =?utf-8?B?WEtWdzdGY2U5ZXY5c2tYK2pvNEpBdzdVMVgyVU9NYUFEWCtHZlNQU1VmTzdp?=
 =?utf-8?Q?uZIUCC16pPZIObVI=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6211835a-adde-4a37-1945-08da1df62e2d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2022 09:07:20.1170
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FVWJpQDVF38lailazIn3M3gYC19mrvKtqUv2HySrRbdrU3M2x52lJDtUOGQRsg0vEAtgmO6SYiCL2a2yPNOXuPHad8LNHfqV/IdRYkocUWc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB4356
X-Proofpoint-ORIG-GUID: dpiSmiv_Shtp1_aoSx1YI2-LaDK8p66M
X-Proofpoint-GUID: dpiSmiv_Shtp1_aoSx1YI2-LaDK8p66M
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-14_02,2022-04-13_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0 mlxscore=0
 mlxlogscore=508 bulkscore=0 adultscore=0 impostorscore=0 malwarescore=0
 clxscore=1015 phishscore=0 priorityscore=1501 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204140051
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
	* Cherry pick for 5.4-stable, no modifications.

0d2b5955b362 ("cgroup: Allocate cgroup_file_ctx for kernfs_open_file->priv")
	* Cherry-pick from 5.4-stable.
	* Backport to v4.19: drop changes to cgroup_pressure_*() functions -
	  psi monitor feature is not available in 4.19.

e57457641613 ("cgroup: Use open-time cgroup namespace for process migration perm checks")
	* Cherry-pick from 5.4-stable, no modifications.

b09c2baa5634 ("selftests: cgroup: Make cg_create() use 0755 for permission instead of 0644")
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
 kernel/cgroup/cgroup.c                       |  81 ++++++---
 tools/testing/selftests/cgroup/cgroup_util.c |   2 +-
 tools/testing/selftests/cgroup/test_core.c   | 167 +++++++++++++++++++
 5 files changed, 263 insertions(+), 39 deletions(-)

-- 
2.25.1

