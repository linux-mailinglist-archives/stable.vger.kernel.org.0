Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD12C4F7751
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 09:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241711AbiDGHWN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Apr 2022 03:22:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234218AbiDGHWE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Apr 2022 03:22:04 -0400
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD18F52E7E
        for <stable@vger.kernel.org>; Thu,  7 Apr 2022 00:20:01 -0700 (PDT)
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 2376l7gK012838
        for <stable@vger.kernel.org>; Thu, 7 Apr 2022 07:20:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=PPS06212021;
 bh=aai4xh/bmUpMr0/rxRa/EmwuhEfJnOO1r93pGGJTZqY=;
 b=maWzs0yp9zJLYZGb1opTShXiP2rttDuDtU+GmLJa+pvGJi9NCrjGnIyKI7rxFqGllIOh
 PmQcoavw28ilJ0kckSaWIUglSbLeYojEjuCfcw05EqdroA8wxu61rKmvA7xjfgIubK/A
 Ev9nhhCb/8YPer7pFbpPoezeHFtLWbitrMHs6XfghPMwfcDHwudnQpxEIJCfHz2/9w7/
 it9s4uExY0xmjEddLpMDiuBvLf3pvP7sO996KT21F5rHJ9OrQI0ZjaDMF1IWjAvdPzW+
 K/ouuqEx2ba3hKe38+Y6NL1vId8pdtSZUMWKRtKiJhVE1C9NlrelUqYBPG8XCbU84Jot 6g== 
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2047.outbound.protection.outlook.com [104.47.57.47])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3f6bq243dm-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Thu, 07 Apr 2022 07:20:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZVXDGULvh28LMw9HYxHJ9h+IupkUfERM5Sz+wDAT1V4NbbyB0jwOn0ymZe4yQH6gHub/fDkdupC9YuDnfjbTw9IeNW/2mthJ8/523f+KMFYL/Tj8ScKSJw4/NO/ZCo1xcf0J4riQmNtXkz/NevBu4vmFdiSGPgO7NPJN4WR7DsC4HcGsRCJrV2EBefqMuWHwUEHeWsC5qAS/5TiPIxg4RGUPXqnSKSNXQwL2oWggd513mMdm8ZXBxt8xnZoHUbAQMv3qGeCHhXrMiAMa/C6JVwP73QQ0AeKb9/YIBK9l401R5P7Aj5cd1C67McqeIdQ6r8fIQMZWLy2pjtjZQRfgjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aai4xh/bmUpMr0/rxRa/EmwuhEfJnOO1r93pGGJTZqY=;
 b=dvfb/P1pu0bOMEJQwvnf/oZ449CFPHNAaKyi3mJflFp1vNS9iPp9QvZGcXooTLIkJL3yeKDjlptEXa+0Vtp9M88CwFT0fuUWD7vDpQ9z6RbPBSW6rwLyg0+EuVoMdqhbIlhKEHRM4ttC2BObP8/yExsg4wJCcbKWRVzybnke+J4CSrniQkloUD0DVlz0ZXoG+dHHm+xAGgX6WyeGKUyIEO/nJmXY/8eUGDM0lZei7CQIRM+wsR4j+JB+OP2aS1dWkcDCUYXgu3qpk3ryUfgTTyWJ+Eitegg7HaUkA52fvT0JH+bmVVh1lg6T5OLUDlmpXN7NYoA5vLOlEzHRo62pRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM6PR11MB3371.namprd11.prod.outlook.com (2603:10b6:5:e::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5144.22; Thu, 7 Apr 2022 07:19:58 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::fd7f:8915:60b2:cacf]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::fd7f:8915:60b2:cacf%6]) with mapi id 15.20.5123.031; Thu, 7 Apr 2022
 07:19:58 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Subject: [PATCH 5.15 1/3] selftests: cgroup: Make cg_create() use 0755 for permission instead of 0644
Date:   Thu,  7 Apr 2022 10:18:59 +0300
Message-Id: <20220407071901.32350-2-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220407071901.32350-1-ovidiu.panait@windriver.com>
References: <20220407071901.32350-1-ovidiu.panait@windriver.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: VI1P194CA0041.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:803:3c::30) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0ad97114-4e07-46dd-5d59-08da186705d9
X-MS-TrafficTypeDiagnostic: DM6PR11MB3371:EE_
X-Microsoft-Antispam-PRVS: <DM6PR11MB337199502356B37B75C310D2FEE69@DM6PR11MB3371.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EKSj7r1TK7L8HLez6Bv9R7lNP+pRZKCWIBYwck/4gie5YbXnVbe5eOVLjfC/2LDN7znJaYqlFkCRi/nRRkLLXjuYaBapJFKfW8fHMiCpvKRw07xq97Z59rAxl02xfDBNuOE8bxTVwq9+FDU31/3t7diDUM3ueAINial+4NOLQqjbIcZA0TXyCJsKbfxRdfCExeuibgxr4TZo71gphWyvGHIn9oE41wdr8B3XPfO5cZxl5b10mKXjLaLM14nhQUQJ73c/StgYwwvjy0pMFz3H9BCbho0qeJM7pLrUmOU7OEDtKS2YolqUJ3UMxHPWeFfOMoBoEZ+GSb63hy7vXY84GicqCgj6Fcac956vAt7gMVSSNltfwWhdXgCW9/dJ3VxObTZuIHTgYObt0Copyj0N5EvPK2Y7ryMWAbYVIZjWLRv1RaXNHBm7hetlLt607Gi46CUdQQG8VTBNuQRHRUgF8RGNWj8cBkd4aC4COZqETfbXiwoquAwwJuWE6Ir6RDu47lg4jyZou9CkUxsfZmfmhUmn4ppI/bq/2wFhRcFx4mzKWp8aC4M0CELT7TEEhGZ1iE3jk7YFrVakvtHsfH6BoT8543IID6VAZrS+G0xJF8GA5frJLY4/+V0efhDS6jgB+Mc62mZJwHmrcN9ZDMGwVCW+A/yqaJ9KfihwpegEDgJ3z+o/u7w/BECyux4H/twUwveUw8odu4UajDor+MbRwg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66556008)(1076003)(66476007)(6512007)(66946007)(8676002)(44832011)(38350700002)(38100700002)(5660300002)(6916009)(186003)(26005)(2616005)(316002)(2906002)(36756003)(4744005)(508600001)(6486002)(6506007)(52116002)(8936002)(83380400001)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aVFTK1lwdVlzNmdWSVhlNDlxZkFKc1lvdUV1YmxYWWRBdzZyWVRwVWViQk5I?=
 =?utf-8?B?UHV1d1NydWhRYXI3d2ZrdUhDbGRMRmplZjBxNFdObFVwemFZRnYzY3l4bkxj?=
 =?utf-8?B?Zksya0Q2dDF1VytGNXRadUpaUFM4dWQ5ay9CUDJraWk5QXR1L1BlbXFIUFQw?=
 =?utf-8?B?Ry9YKzlKUFBuZE50U2w1QlRiNDh3akxDeGJWMkxNY2ZTOGM1Q1JwQUhxMUY1?=
 =?utf-8?B?U3dJTzZDMkVGWnVBV0JBRGc3NUNCQzNidXJNYXV4bjZwWUEzeEhVeXVuL1N6?=
 =?utf-8?B?b1FFLzNHTkV4OEdsbEhIY1VwNFE3b0pkVkx5RlZ6MzlCU1BITHBBY2pSNTRs?=
 =?utf-8?B?YnFwQm0yTW9lRW53UDVuN2l1SXRFWUIyYlZtNXF2YTRONkd5ZFZNVDB5WE5O?=
 =?utf-8?B?bTF5Q0p2SzRoZG9KdnZiK1lzajFKUGlub1hhWEJQVkFuMVNwMlNjS2U0U2Va?=
 =?utf-8?B?NHlEUHlxbFVXYVRzRW5EVlM4RTBtSGpKWWMvN1N3WmdrVmhMS01jcTN4QWJD?=
 =?utf-8?B?ZUhqbEZUQXJpL3lDS09EaG1hQVlQRmtmUXUwRXJMWkZhTERKTEN3ZkRyWnZU?=
 =?utf-8?B?akx1dTJrWWZ3dVEwM0RYRndXQ0FUZzcrUmlhY2lBaEhmUGtHT2JaNUZKdWJP?=
 =?utf-8?B?WWlCT1plVmRwV2kxRk1rYzVCNDZHNVJ0KzlodldEZ21Sa3g2TG54TVViMElF?=
 =?utf-8?B?UGp6cFlRcnVVUXNYSElTUk9nUGxlSW9OY1RTL09mRVdzRE5Xc3NzRGtsbjJl?=
 =?utf-8?B?aEtPYTRqeXRwYUQzSzRkbE9JS1lhM3pLc2pFRVRyaWMyMkhFbks4TDdXNm9q?=
 =?utf-8?B?cjY5RE9SQ25VbklHSzJBOVRhd1J4Tmkydit5MDVqYSsyYnNaQ3loZE1ReWpy?=
 =?utf-8?B?Ni8rQTJINUVkbEtkdldJTEttaVBsb2RKZExsNVVKWXF1SEVoUGE3Y3JhekNa?=
 =?utf-8?B?eXMzSG1rNi9wc2ZZd0IyVEFzVUFCUWEvdEJUbzFCSzg2Q3ZWQjRWc0xJREtz?=
 =?utf-8?B?T2ttNnFDckN2Um9qOGlCd0hRc1M2OHloRmZFaU81cE9XSkZpYTJmeHBxRk9E?=
 =?utf-8?B?UmxlSVljQzdKemxuYXJIcUMwQzJWMWFjVWdrbzBwTGF0dnJZSVBoZ1RJVzl5?=
 =?utf-8?B?YXBLMXhlaUltanROejg2d21ZZXJhYVFVTFZVQXhLcW92M3RiUGE2MHZGUWtU?=
 =?utf-8?B?TCtWc0Z0dytZdmgxZnpDVmdrNmhzZ0l5VzF0UmxqaThpSXdPRE9BTnl6ejhJ?=
 =?utf-8?B?SXlPeWJ5NkErdmFXZzRqRjdqWG5XT3N2cmwrRzhrc2M4cXAvOWFKN3dtWG1B?=
 =?utf-8?B?eWhheTQ5Ti9RNFIrZWxLZWNrS0VENVp5ZVZOZTBDNC9HS3Q2anp0VVNQRHkz?=
 =?utf-8?B?c1ZJSnVYbndJSm5jY3NiWlJVK3pJc2dsOXdsZFlGeHlWaU9JRzNJWk5Qb2N5?=
 =?utf-8?B?c245NUQwRzJ3VDVqTGJiUmdBa20xNFIxanZZM0F6MjcreEFvSmtpa0tkbHRx?=
 =?utf-8?B?bUhCUWJIL3FhUEl5QW56cWxzOVFSdlhhLzhXUkxicEVqVzFZeGtKLzN5cmhQ?=
 =?utf-8?B?UHhxdWlNa0pGWnh1UmVVMkRoQWJ0NzhmYnNmUjIwQ09tblhYZTZjZWh3U2lT?=
 =?utf-8?B?aGJWL0QvRC9KNDluQ3A4Tm9oZHo3bFA4aXdRcms3anNJYU5hVnJWSFJiaEln?=
 =?utf-8?B?VEJjWWlUSlJxdzRJSFR6VzNkQTNHOGZLZnhxeE9URFJjbDVuQUpNOXVlOTNU?=
 =?utf-8?B?bndMNU9tVm5SY2dvcEVMcVFsVWs1TkgrbG5mK1cxbkZQMTFaOExidWhtQkpM?=
 =?utf-8?B?MkJGdUZpdjZqN1RqV2ZxMTZYQndJODhPYjZuUWp6NENQUXYzUmNVWTJyWjJZ?=
 =?utf-8?B?RGNNR1VoNmVJOXRUcXhEZTlRYU8yME5rYXp2VlNnNDdKQkVFcjY2YmhyTFND?=
 =?utf-8?B?Smh4bElsQjQvVEU1cFdkUVFvNURXUkZicHlPODhUVW1wM2hVSWk5dHRUeHBo?=
 =?utf-8?B?Z2FkdFc4MWZZV3JVRkNCM01zRTl4MWgvOVl5M0hFMzM0OVAzZFc4WmFyTFo0?=
 =?utf-8?B?WCt4SXgwRGU4YVg4Y1VTVzdkdmlxdmQ0M3QxTUtLckVoeUl2bThSK05OZGxS?=
 =?utf-8?B?SmtiN1FNRU5vMnpOMEZST3RwSk1vK3YwMWdRZXA0YktDcjc4bVFqNWtJMmlF?=
 =?utf-8?B?U2lzdU9mL0dPd1c1empaM2ZkQ1R4VEhZNEdBc3k4dS9DeDlxdGlaMlJnaE9L?=
 =?utf-8?B?c0ZxMWJtQy9tUzhzcm82RUZGZUVZOGpubW9jVjMxMUxFVkR0SmtLdGN2dUdC?=
 =?utf-8?B?eXJxaG5haFVQazJ3RGxoQy9SQ0xLaDF5SUdVZ2JGQTByMDArS2lubGZhL3pj?=
 =?utf-8?Q?15KGJosiPIedDuDU=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ad97114-4e07-46dd-5d59-08da186705d9
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2022 07:19:58.8470
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KdhWByU2TJhHY10b8pj6scCJTEADRzpuSoTd4HC+JnqCO4NfASdKzGvnRJfucFbharpwPknZUO2QLjqvokzQ9QLr1H5gP+FllZeEWs99kHs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3371
X-Proofpoint-GUID: iktYrQgiNnlernws3yKraNfRwrYmy0Gx
X-Proofpoint-ORIG-GUID: iktYrQgiNnlernws3yKraNfRwrYmy0Gx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-06_13,2022-04-06_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 spamscore=0
 phishscore=0 suspectscore=0 impostorscore=0 bulkscore=0 mlxlogscore=942
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

From: Tejun Heo <tj@kernel.org>

commit b09c2baa56347ae65795350dfcc633dedb1c2970 upstream.

0644 is an odd perm to create a cgroup which is a directory. Use the regular
0755 instead. This is necessary for euid switching test case.

Reviewed-by: Michal Koutný <mkoutny@suse.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 tools/testing/selftests/cgroup/cgroup_util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/cgroup/cgroup_util.c b/tools/testing/selftests/cgroup/cgroup_util.c
index 623cec04ad42..0cf7e90c0052 100644
--- a/tools/testing/selftests/cgroup/cgroup_util.c
+++ b/tools/testing/selftests/cgroup/cgroup_util.c
@@ -221,7 +221,7 @@ int cg_find_unified_root(char *root, size_t len)
 
 int cg_create(const char *cgroup)
 {
-	return mkdir(cgroup, 0644);
+	return mkdir(cgroup, 0755);
 }
 
 int cg_wait_for_proc_count(const char *cgroup, int count)
-- 
2.25.1

