Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 668BE4F774A
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 09:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241703AbiDGHWG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Apr 2022 03:22:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241714AbiDGHWE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Apr 2022 03:22:04 -0400
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94AC851328
        for <stable@vger.kernel.org>; Thu,  7 Apr 2022 00:20:01 -0700 (PDT)
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 2376l7gJ012838
        for <stable@vger.kernel.org>; Thu, 7 Apr 2022 07:20:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=PPS06212021;
 bh=vAxFKECCrHNiW8jzpkJkQtIWkuSvySsDOtLsOuHA+L8=;
 b=nhdkGDzVIjoRyE/MQBiPGuxiRnJg1heqQC0OMqkwlweMNH1511w/Wke5JnTEcUCCqeSQ
 sLNVVinYfBXLjGymi5uH4gabNzQsZb7cO1SYBdFkXnUWJntQeIRbU19e59eGgFWYXYSD
 q7ly1Br1iu0XpnU8kTfD4dyBSEjmLdUisGq1T/rK1FFvoRBrBuUBoFkc5yLvWV9iWTus
 d4qBqZstq3vrw8Q/4MLtJxANqikeGMZVyo4aPSRwfsglSZPD8Ku+EohjQkHQFzJzxE0W
 33/0R0kl002MXYGGfYuuVitHc9PZ3Qu+w8cR+oLmJU/Z0dAnBeG1y9xaGmnStu3VAe9P Hw== 
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2047.outbound.protection.outlook.com [104.47.57.47])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3f6bq243dm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Thu, 07 Apr 2022 07:20:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nIm2jP4d6ifmXVPtTfMSeGJve6U99SrVNoNpedJztnMdz5rI44M89kyjJmXgEtyMFtHK0pRb1tj9fYAs0EETFWQ/YnIw07AobqFlV3lwXlbPtM2FhSk/qn5wDhttl7V/7ad4xpxxPlqN4+65TzK5RVe2VRnN0H0insSxQaSx00K6Z7RegQbHKzVXCBUqHoYofKbb8utwcvNbNkVaPymYkcU2J16XE2CKLtjDSy91HaTh9RFxJ/qKpDTgnhDyR7rTAjc2xw4G+/cfPklQsjYLJVjuZmUHXryXBlNWq2dJOVaCaIDZ9eHoPAkPPeWFBszLcwxatXJJ+Z+NH8uraV2ECA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vAxFKECCrHNiW8jzpkJkQtIWkuSvySsDOtLsOuHA+L8=;
 b=TNDop2ABdyrnqtAzrGp88kpFWpcOUQizeaE+aIU+isw0sR+2XnlRr+URoJE0na29/QbrUkdjW4VE3kT0zaRZsXN5gXgpuKL/pIT+2wU8wNhaiPgpIDwgyQFg6QBq4VBngkr8K3V9VnA0lE4D0nluJCAn4exAiR7XKcdtf5cbJG4QtbHvM5HMQTmbRkMXp5PqVS46+mRrD8ieugeB50cHc0WoId/OlscALCOOlfrW4GYbTklXX+1obYkyYzwQU1Ut13YROeAhBMV8Uc6Baee39i4vlm423e1RP5ZS/DP9o+K5bVWaO1kmE2KRE1xah7YWGVgt2gvp05DewuatgldFRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM6PR11MB3371.namprd11.prod.outlook.com (2603:10b6:5:e::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5144.22; Thu, 7 Apr 2022 07:19:57 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::fd7f:8915:60b2:cacf]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::fd7f:8915:60b2:cacf%6]) with mapi id 15.20.5123.031; Thu, 7 Apr 2022
 07:19:57 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Subject: [PATCH 5.15 0/3] cgroup: backport selftests for CVE-2021-4197
Date:   Thu,  7 Apr 2022 10:18:58 +0300
Message-Id: <20220407071901.32350-1-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: VI1P194CA0041.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:803:3c::30) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4085b8d2-f82f-4143-30ed-08da186704c7
X-MS-TrafficTypeDiagnostic: DM6PR11MB3371:EE_
X-Microsoft-Antispam-PRVS: <DM6PR11MB33713B7ECBE098505978B66CFEE69@DM6PR11MB3371.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tL7XMqK8Z7/tGnMUdgsC7T2+o56KnpzpZsEnw+L8Y6OqBWiA3I8SvtPkG+vY50iwUyEWpKbNDSBNa22R6fAbq58xtWSDAV5AcwZlTFUwI9DmSVWBbuavf6JMio7TOWucFJaaP2JueRkjvX39NzoG3FS0o682+6yYsiV0ZsAZ57byR8McQ+0NtaMz2tzYa2rGqYQVOz8wnPJvpPr4iW3knkrM11ChuG/TTYRlIS8BieXEF2k34o3/4RQ//iSvO9NeZM/EUHIUel+ZuUBy0yZ+cQBFm3XNZKg4f1i0t2EBgpdbzCemmgJInLryeres6dcHpilA0nacrOsNs0RMIrZgkm4bttwOGEfFTdgQt8MGOraA+On5IljEKwN5Z4r5eo/S5rPDXnRBN7f9dEMk3Q5cO0GQ50Ye4QEgZOUKx8wAXRzPcvKBfwUclgM62T/56BhMoo/hxQ3jMMlN5xt/eygG/v9xQmU6IRtT5lJrpgFUBg5XaZrKGzKCtxFzkCYlM7/y1SpfqwNKkT7Po+X85ZmXZR+6hNJHZ31SRngr27GTMEcwUMPfCtwinf0IENLM6tdJ9oT3jC2Y0ZBH2iXMwmB/VCt4y7/BQWn7vAjb9yCBKMDNdvVF8cRFN9OXvNj05E8muQPTzT3hVGynAl0SHzHsN827cajmhFsIovytGtkziTeN7tKM+ZX95qj6tLGwGBN0bd2OfvUC0JjqTlD1WRm3OQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66556008)(1076003)(66476007)(6512007)(66946007)(8676002)(44832011)(38350700002)(38100700002)(5660300002)(6916009)(186003)(26005)(2616005)(316002)(2906002)(36756003)(508600001)(6486002)(6506007)(52116002)(8936002)(83380400001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?czNVRzJUNnc4MEZVd05LWXBsQ3JnbWlTYVpZeE54eXBxTU9aeDIvU1pFY3R3?=
 =?utf-8?B?K09HRFBEUTlLdmVjRHJYNkg4ZXIzd1RPaDRGV25hZzNTT3R1MnhkRzRnQXBE?=
 =?utf-8?B?S01EVEhueThaMzBpaU9KMzFYaTZTdVVkREZqang5TkVacVA5aWFweXZrekZZ?=
 =?utf-8?B?UG9MSllPeDJvekRFdk1uRkROckxQZXV5ZHpRWElrdVM2ZFhjQmlheWpHWFJL?=
 =?utf-8?B?VTdreGo5ZkpVMEV4NTMwdSt5NGVSbFRCYVR4aXkySHl3OXdlQ0MwZ01PU1FF?=
 =?utf-8?B?cm9vQzlkbytBbXc0aW9hSnhnR0VIRGp0S2ViYnYxZktqV3F0amNOdHphNHp0?=
 =?utf-8?B?MXJubDJEblB3MkdkbHJkVnNiMmRNUDhKNFV2cjc0djRFcW8wNFRzZUpXaytm?=
 =?utf-8?B?NExYdjU3dEJrS2N2M0JTd05kTjcwRXduVXNBTVN5V3ZBVHdWUldheGtiazlw?=
 =?utf-8?B?YzRKTUdUcmlkNlhpWWM3UW1Ha0pGa1UvOHRidks3dndjdVBKRkw5YWx0QkdT?=
 =?utf-8?B?T0NFMjN2OXFRcXQyUDNyTUoyd1ExeEttOHpqcjVjUmp0R3NWYmRsZFhGMEw4?=
 =?utf-8?B?UEo0MUMzK1BBSGJUTEFpWmFvS2JyNnNLc0kwd3lpRXJiSnlsMWxXWXZLTzZY?=
 =?utf-8?B?eFJ5UW1XSlU5NHZuQktRbzZ3VWxuR2pYQitkem9SblpIR3d1KzVrSm9wNTJY?=
 =?utf-8?B?cGdlRlNzWTIraUQ5V0pSWkRMYkMwdHJ1SVpCeGVUSWRpZXpOa0VKb3lCbUJE?=
 =?utf-8?B?eGJPRmN2Qy91NCtETmVWNEJCd290V0lEbFJ5WG9TQnVXSjVwLzVKSmtBVENl?=
 =?utf-8?B?ckRiRjZOcVJnbnNHdnQ4KysxWFJwOUtScS9zQmk2T2svRlJWUG1xU2EyTDl3?=
 =?utf-8?B?Zkl1QXBMeldiNEM4ZkZqcUJBQVFmVUtqREw5UGpYemZMYzk1WXA0WHFmUHpT?=
 =?utf-8?B?K1hlTG5oMENFRG1YOHRHaHRjU0IzRmlTLzh2bzVQeHkvdFdBbmRGcURCSndt?=
 =?utf-8?B?RmFDajZaRWhUbUx6dU9iL29iNFZzbHV0STN6cERMemc0MWZGM1RlWFA4N0Va?=
 =?utf-8?B?UlcrUWl4eEh6L1g2SFltS25UNGJqbUQ3cDYrMjg4QVBSSmJHcGZmUjF6UGtT?=
 =?utf-8?B?UGhDbVJ4dW9UZmVGZEhZcERkK2k1N1BRcVoxQmRoMGJsRW50WUo4WEU1bXZj?=
 =?utf-8?B?SlEwRUxrdDZSazVRbEtUVXhqajNPamtURjBZQVA5UEFmcVZ2c0E1VE1DWFcr?=
 =?utf-8?B?cDFPN3VHOXpvSFVMTjkySXpRbUh1UjVkdnFzTTFqZTk4TWxhOHVWZ1NVMWF4?=
 =?utf-8?B?ZzZLdkRPeTVCRTJZcWlnNENLYTE4UDBTam9pWDArTDgzUUxyT29UZWhLcnU4?=
 =?utf-8?B?a3NkTDVsL3hpOHl3SVJqS25mTlJWMTJENTFsWExMbytKaVN6eUdmNW54Q3d2?=
 =?utf-8?B?YXk5bEV4T3U2cENobXJocVpJbmg5N0JkL3VXckw4MXBVL3RDanBHaUJGL2lS?=
 =?utf-8?B?a29XNFdSc3E4TFRERzFycGh3ZU9QSkFQSjVFT29HaTdUbklabmdFK0kvOC9n?=
 =?utf-8?B?R05IcERKcWNNbnBFbURlUVd4bUtWdnlrUHIrVEdiakt0c1NMR3orZE42Q2tD?=
 =?utf-8?B?Njl6em80OWdDaWN4STR1TE1CUDFxYlIvRk1KNFdSc2N3dUg5YmxGb2IwQlpk?=
 =?utf-8?B?aHlhbHJQOXk0N3BhMDhtVk81YzRmNkswOXlEZjIzMnk5VG5UMEdkbXM4cGlB?=
 =?utf-8?B?QWwxME5lc0U0bTRVVHdKbENLUVpaR2RjVVpDRTVFV2svamZzcCtZWkViNXpv?=
 =?utf-8?B?SGxvemJMYzVHdG5JNjRaeXJVZUVoZGZvRjk5Wmd5U3JMUUpncnJud2VnZjBT?=
 =?utf-8?B?Z0ZOYjUvdkdMQy92WXNLRi9LM0drVkdZS3Rvc2tjeE5aNEloalYrTkE0RXYw?=
 =?utf-8?B?SXYwTkdxcmN0bVJQT2toOVFRNG91dGlxbWV5cWNkdFhKNXR0c2I0NjltdnVI?=
 =?utf-8?B?QnBSVHkyUWViRW1tQldBMGFQN1FvNzA5S05DSWZ0eDhyUHg3M0s0K0JSak0v?=
 =?utf-8?B?K2s1Tm1DTSt2amRqSzNNUjRDblozN1hXMHd6b1pyNU1BYVM4VEtLUDcxK1Vp?=
 =?utf-8?B?MWYwZHZQdFZQVUJPazhUUG1aazhveTB0VUFSOVdYNDcrbTgzdk1VWC9WUkt6?=
 =?utf-8?B?Sk4zZVdvS2plcGRFeS90R29kOFNNQmwvYmRDc243ZzQyQmtDN0wweFl5UXZj?=
 =?utf-8?B?dktaVERqQk4zRnhETDl6V1h6VElqUm9xbEJmWGFTbDIwSDlyR1gzbzQ3VDF2?=
 =?utf-8?B?ODBTZG90WDNMUlpHZlZ3THYyREFVNkNJanJPaFN1RDF1Y0tVSHI5TnlUendS?=
 =?utf-8?Q?A95LYayc/Jsqzmjw=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4085b8d2-f82f-4143-30ed-08da186704c7
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2022 07:19:57.0800
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K93juaV/6zyaalsujOd86CmaAwuuej3wn5RmyTi/aUO1BKKsw/fGRdIAo5QqazXzzGbEC5dIMaU16mQFgfUL6js2r3Nv+IgXqMpnrk19Mjo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3371
X-Proofpoint-GUID: X5ZKE81BDJ6fc0C2NOMwwGycNcQWq-af
X-Proofpoint-ORIG-GUID: X5ZKE81BDJ6fc0C2NOMwwGycNcQWq-af
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-06_13,2022-04-06_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 spamscore=0
 phishscore=0 suspectscore=0 impostorscore=0 bulkscore=0 mlxlogscore=600
 priorityscore=1501 malwarescore=0 clxscore=1015 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204070036
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

Commits [1], [2] and [3] are already present in 5.15-stable, this patchset
includes backports for the selftests. All patches are clean cherry-picks.

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


Tejun Heo (3):
  selftests: cgroup: Make cg_create() use 0755 for permission instead of
    0644
  selftests: cgroup: Test open-time credential usage for migration
    checks
  selftests: cgroup: Test open-time cgroup namespace usage for migration
    checks

 tools/testing/selftests/cgroup/cgroup_util.c |   2 +-
 tools/testing/selftests/cgroup/test_core.c   | 165 +++++++++++++++++++
 2 files changed, 166 insertions(+), 1 deletion(-)

-- 
2.25.1

