Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 292F25008AE
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 10:45:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240040AbiDNIr5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 04:47:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240773AbiDNIrz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 04:47:55 -0400
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FAC76582B
        for <stable@vger.kernel.org>; Thu, 14 Apr 2022 01:45:28 -0700 (PDT)
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23E8MH9q025116;
        Thu, 14 Apr 2022 01:45:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=PPS06212021;
 bh=e911vXhRJWv2Ne/NVdTfPpbmYIz7j/g1rAcSk/qLz30=;
 b=TDIxYq6umem4DtvRe/ydbCbibE1WAXe9DJj/Gz6xyAnquCGvnKYXP0EO8TNIZdLG4qZN
 2vYhT/fJ0yFOHlOhXNYqwulNUCzMLTd2Nj1ylvh8vXNS6z/8whWggx2DVJSSoV25DPuT
 tXE7a6c07rCLE39VHcVLLdurX05eNfRMUN/FAufNLwT0JKZ5eHLyHM+AdABiceBWcXzq
 UpeskIU92aZ7wc9iTK37kjaxuqoeOphd6m5n1meYyhGIZb10CEo0YiFS8ZOOw5wjTJK8
 NV7slWfwD5IHsu1cTbw1bvRkoSkm1sVh8JFNBeP9JdHSm842veYOcO9ydeiGIkrwD5Cc wg== 
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam08lp2169.outbound.protection.outlook.com [104.47.73.169])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3fc0jeb4hw-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Apr 2022 01:45:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PHH/8+OZcTbJ/NCcADZjoRwqXqhAGDCWgOOwQyuv5HnqkxpUkvbT5CSSLZWlASa/EU0VdKirNw6T4MAyDZdpFyUUr1zy0RDwpW7Igb/MJOgQ00mNuDyTtPamT4hGNEYEW04u9C1pfPueeIvGI5Dt1EbenOeC2vETfPDrXqBU34mOz6VIGU2wDNJnLx3JB/hGGk2zLZft1O0pkyEkTLnSg7eFtLHDu1MRCn4MRodT7Qj/OOB5/9maPFdvxe/Y8R8Y2KaIKPkpRsHvQp1mQxwuYMvZr8QEn9/CWF7GwFgffwvdn2oPvmhtiDvTY09wYWt8N/LgM5lQYEkO2cnh2WL+Xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e911vXhRJWv2Ne/NVdTfPpbmYIz7j/g1rAcSk/qLz30=;
 b=eFw8C5Qkn2xtQjqS0WBqsRvV3PM8vc8FVKHTRgD8Wco8he0bJ6+I33vds9vuFiiCiFbXlxbul+OHKWLa5KOKjc80uW42WiR5IgvD8nTdyDGQbfUFUmYexe7vzsF1Rou3DchXUdyoGHlyRXwx3OPGhDscOUSspvqsEK++FcGDdixGP2OcY+ws4/+A9ocST2Po6ZfP9tu9ecY2N/yy6R64mGMQI0d4k09VAOa76RyW1dByAQEPmgmi5T+bQtBdyUjmedgtJogOFAbzx/Hwk+A3XUwj46wDTf4XuwCWagLRM0oIdtk/g0s4kpRy+tDxxxhJOEfWPhxtSwJ+jcdV2wLd0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM6PR11MB3435.namprd11.prod.outlook.com (2603:10b6:5:68::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Thu, 14 Apr
 2022 08:45:16 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::c903:4c47:ac8a:992d%4]) with mapi id 15.20.5164.020; Thu, 14 Apr 2022
 08:45:16 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     tj@kernel.org, mkoutny@suse.com
Subject: [PATCH 5.4 3/6] cgroup: Use open-time cgroup namespace for process migration perm checks
Date:   Thu, 14 Apr 2022 11:44:47 +0300
Message-Id: <20220414084450.2728917-4-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220414084450.2728917-1-ovidiu.panait@windriver.com>
References: <20220414084450.2728917-1-ovidiu.panait@windriver.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: VE1PR08CA0034.eurprd08.prod.outlook.com
 (2603:10a6:803:104::47) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 72f1b3bd-d45a-452b-f702-08da1df31941
X-MS-TrafficTypeDiagnostic: DM6PR11MB3435:EE_
X-Microsoft-Antispam-PRVS: <DM6PR11MB34352E9342763EFC5487A161FEEF9@DM6PR11MB3435.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JNbFuSwzU5DRXJIVWC0Bd4ABNHavcGFmsR5NNHJp2l6sab//KQJutCL+Dvz+d0VbdbIEetHzGjaI3aX8hoch13TU2zTDIPESBFv+DZLilt7OXYFdDjYBrrISIAb5Bn2OhA3Jiog6Ykk3m3Mgv7QaohnVgOhmJKHC8oVkwe9aTvTDq+6g4SHPM2sSczJztY9Eejri4mQRCt1kg7kyU0I8CvrftwiXHr1+BELV8jyxe4KpEjOnRuGrdFSAoZOOysDUEhB+rK9//I2Ht3Ox9fbgw59L+tYN4TwejRos8TEutmvrfGC2Zn8mmt1e4MLO01H48gQR/MyOp8VpfNWRRBicTED39Vo8H68LYbWp97SZ7f5AThf/T1GU4jzW29liAB9dGiSiEVzhMX4AjhwSmv6IdVwcdu4MBuzmahFKMsiWsgb1WXh9sPW1OUOmkm5p3iIeyxWo7CBNTlJ8E3nLUzXWtoQYjKNLYm7E80J1oH35H3K80+m4u7ogTczXmnAunUTGqGdzFHWxujSb1BuBbU0KFAmuCyxslr8wtTAMdPxV7MFeZf+MBRBQw71WQj9LhO1FoTHTRNJpaBt+hnej8iUSSGvoeBaNUt63ol2b9jRgYXT0J5hCMCUHSzc4yq9E8OWNcLXwMlj2737SRSW7TcmPqe89IZRYjIWOTbi1edFkuBWPi/qFoe3zsgi3YcKksL9qoKpjxN0UREUzG78fu7atGfnY+Mm0IFK1u5TQL04WnubzRJQuXPNu2aFDIoh2G+QaXBAht3mOMx6EoBs+YeqHBVVVsSeuin3OqEkuyNH6Dm4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(186003)(26005)(6666004)(316002)(86362001)(1076003)(52116002)(6506007)(2616005)(38100700002)(38350700002)(66556008)(66476007)(5660300002)(66946007)(8676002)(966005)(4326008)(6486002)(44832011)(8936002)(36756003)(6512007)(83380400001)(508600001)(6916009)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U3VmV1F3cDBBelF0ak5DY2tnMFFPaWNNTEo0OHdBMEUrVlNhQlNJRFl3UFRS?=
 =?utf-8?B?b3did1BweUg3R3I3Mk85YWx0RTdEalNyaUdiWTRxYkZIeEN5R1lkYjlnNVBL?=
 =?utf-8?B?TG11aVV5Y1cvSWFqZ2tzeDhqY1BSM1V4cXppaElUVit6RC91YWlBN0N6T2Vh?=
 =?utf-8?B?dUlRQTFNeU5hNFlKaDNVZzU4dVFOSWZoMnhwMFIrUTZuRXZBODJuSDFiajd5?=
 =?utf-8?B?ZEE5eE5sbllLelFPK2owQ3QvWTE4aUlKNFpoQlIyWmE3RCtET2ZDczA4eExo?=
 =?utf-8?B?czROcUdmYWZFZGxBWXpValNkd1d4ZERWc0VhaUJ5Rm9KU3Z2TXVyVXZHclRO?=
 =?utf-8?B?akwrSTlUamlLOWtKcEROMmlRMW9RMnJZOWIrdDFNa2c3SWk2VmRrNnRscmpo?=
 =?utf-8?B?RGtVTG83MFo4VlR1cDkrQS9WMjNCMExqMVhFVkpnSFlRNGVvT0lTVUJtSU11?=
 =?utf-8?B?Ly9XWGY1LzJCY3ZPSHlnNkVzRVRZaTUxWlBIUnBUM1ROMG83QkdwdkhSSi9z?=
 =?utf-8?B?cjBFdzZ4QXk3cFJ2ZjJjdktiNUNKK1lKdmdWdVlXZmRKRjJqTldBUTg3RDlR?=
 =?utf-8?B?S2FCM1BldVRCU09pNkhlclYwSmF0SWR3NnQ4TG12VHJKZWFXOGo3am5oRXZx?=
 =?utf-8?B?aFZhNXFUdUU3NE93YnpGTlFrbTNlVEJvSlViY2JZZ2hPdm5McXh4RjJtRXRY?=
 =?utf-8?B?dzQ0M2RyemdmT0RFNDl2aHZoa2FwR2pkcDZmbjA4WmNnT2RjVTR3akRTTTY3?=
 =?utf-8?B?LzdxOHZpWXVNU3M5YUUzRklNc1YvK3UrVnFBc3dZbXV2TG41eEFiS1lacnBZ?=
 =?utf-8?B?cjlEL3cvK0V0RWFNTnh0MERmUmw1Y0EzbmxZc1loRTR0UUdBWU9UbUdGY05F?=
 =?utf-8?B?ZmJmM0tDbEQwSDRzcTRySjhtQThmR2Fnd1BIU3NTRHJEUkpJTWNPUkpLMmZ2?=
 =?utf-8?B?Y0RNWU51L0JuRVI3alJRc2x0aFhRRnRHdkJ3QWlGS0tMTVcxenBLMWVreFdM?=
 =?utf-8?B?Z2o4UUtwVEViS3NQVmJnK1RZOXlFVkhrMUdYMVRBZUMvdkxNMjVJWDVoWWd3?=
 =?utf-8?B?UFhuakU0ajRlLzgzT0hNUWc0aUYzZm13cU9nanV6Vyt2cXF1VkU4a2pHMVM3?=
 =?utf-8?B?VjZhTmxRYmcrcWN1MHdUQitmeXR0SENqTHViRnppMyt0OG1IdzhDMENrbHZm?=
 =?utf-8?B?SUI4L0JUYkpyOXVTWU54dEg2ZitldkdNd3V5NHFYNzVvdThtekZSWTlFYlhO?=
 =?utf-8?B?OE5jYkRTZEMycVlUVEdJdzVuK1hQRS9CMnp1T2xjL3lUT1lFY2hSdWtsSGRs?=
 =?utf-8?B?QUlBdng1Q0hHa2pQaEIxWS92WWRHQjgvWFNJMFgxL2d1K0JNaGcwMVdSMThN?=
 =?utf-8?B?OGlObzUzWWtNeWdMTmYrd1lCRTZrWnNnQnUrVjVIdm1pT1RKaWw2Y2EzR2ND?=
 =?utf-8?B?WjBaYzIxZDJwV2xDaDBFTUY1T2hJUkh4L1VjK3d6WVhqeXFkVkxHQlFGczFj?=
 =?utf-8?B?blhhNW1rQ2piM1drMEpTQVpQa2JRZjQzdG0zbVNVWGxnYUtSQUd0dldEY0dt?=
 =?utf-8?B?c3kwNklZZW9CVDFLTEFGU1hqWlN3bUtmN0ZsR2xQenFObmxUZXd3UkFEejZT?=
 =?utf-8?B?RXlvblVNK0NITndtU3phL3NWZ3JlbUVDZnd3QmN4dERZWnFOS0MrUWk5SmdV?=
 =?utf-8?B?TFNCWXdwZzJrM01PQTlQK2pqQ0JNcFE2amROOGljSjY2WU5VVEJsUHB3Z01k?=
 =?utf-8?B?K2draVFhTWRRT3cvamI4VENKVWFJa0MvREs5MkdFdWtCTlh3eEcyNnJBTjl4?=
 =?utf-8?B?U1F3c0VQaFBkRXpjT25pYkdsSVBQb0NmU1JBakFnMjF0RmQzdXA2S3pkWDhC?=
 =?utf-8?B?ckxtYm1yaG1FOUV2SVpIdmg5ckxzNWNWTDBCbnJpV0cxWGszcFRFVVBSZzho?=
 =?utf-8?B?SGZqZnBNVWw0TGZwN0dwYWpCYTFXUnROSElNWjM5VW9wRVdGZWdQLzJaTGtj?=
 =?utf-8?B?ZmwyeDdwdU00aGVPcnJNK1h4UGNpTGxsZys1cHlQakI4THVnV0J6RU1TWWNW?=
 =?utf-8?B?MkJXYmJSNndnZ1lLZlVrUzJXY3RCVWQzdGdkTzdvTThRUGh5c0V2OUttZWZZ?=
 =?utf-8?B?ZklQNURobkgyYkVjcStWTnhac0lySmtRV3hqVVlYandxOGpKOWhVY0FIS3o3?=
 =?utf-8?B?Uk5EZmdiemRJbHdWOUhjd1AxcXdudU1rQ2R4dmlYc0l3SThLQVFUcUdyd1pC?=
 =?utf-8?B?RU1rNlZlOWkrRm11RFUxMFJRUDNlcUZ2SHZmSSt5dURoaXJVdGNsajBLaFZC?=
 =?utf-8?B?REh6TldqV0pzWVFVYTJwelRhNWJVSFhTZFREd2RpRGpicHkyZjhLZ0pxdXZG?=
 =?utf-8?Q?t+UU28LupXRmdBSQ=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72f1b3bd-d45a-452b-f702-08da1df31941
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2022 08:45:16.5921
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JJkHJFiZu1SU3150U8Rwyy+tIcX7aluVA6y+H8YeUv2HN3b3UAa7eckIUdy2W9zzVzxk0t9CsWHYoe2/qVsygnaIQAyEVjC5Ma/BFQlZVtg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3435
X-Proofpoint-ORIG-GUID: 2tNO6hxxWN0LOIRBWgmFCSV0t35ev9Jb
X-Proofpoint-GUID: 2tNO6hxxWN0LOIRBWgmFCSV0t35ev9Jb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-14_02,2022-04-13_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=999
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

From: Tejun Heo <tj@kernel.org>

commit e57457641613fef0d147ede8bd6a3047df588b95 upstream.

cgroup process migration permission checks are performed at write time as
whether a given operation is allowed or not is dependent on the content of
the write - the PID. This currently uses current's cgroup namespace which is
a potential security weakness as it may allow scenarios where a less
privileged process tricks a more privileged one into writing into a fd that
it created.

This patch makes cgroup remember the cgroup namespace at the time of open
and uses it for migration permission checks instad of current's. Note that
this only applies to cgroup2 as cgroup1 doesn't have namespace support.

This also fixes a use-after-free bug on cgroupns reported in

 https://lore.kernel.org/r/00000000000048c15c05d0083397@google.com

Note that backporting this fix also requires the preceding patch.

Reported-by: "Eric W. Biederman" <ebiederm@xmission.com>
Suggested-by: Linus Torvalds <torvalds@linuxfoundation.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Michal Koutný <mkoutny@suse.com>
Reported-by: syzbot+50f5cf33a284ce738b62@syzkaller.appspotmail.com
Link: https://lore.kernel.org/r/00000000000048c15c05d0083397@google.com
Fixes: 5136f6365ce3 ("cgroup: implement "nsdelegate" mount option")
Signed-off-by: Tejun Heo <tj@kernel.org>
[mkoutny: v5.10: duplicate ns check in procs/threads write handler, adjust context]
Signed-off-by: Michal Koutný <mkoutny@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[OP: backport to v5.4: drop changes to cgroup_attach_permissions() and
cgroup_css_set_fork(), adjust cgroup_procs_write_permission() calls]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 kernel/cgroup/cgroup-internal.h |  2 ++
 kernel/cgroup/cgroup.c          | 24 +++++++++++++++++-------
 2 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/kernel/cgroup/cgroup-internal.h b/kernel/cgroup/cgroup-internal.h
index f91a8ba168dd..236f290224aa 100644
--- a/kernel/cgroup/cgroup-internal.h
+++ b/kernel/cgroup/cgroup-internal.h
@@ -68,6 +68,8 @@ static inline struct cgroup_fs_context *cgroup_fc2context(struct fs_context *fc)
 struct cgroup_pidlist;
 
 struct cgroup_file_ctx {
+	struct cgroup_namespace	*ns;
+
 	struct {
 		void			*trigger;
 	} psi;
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index c1eca24db373..177d57ce9016 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -3758,14 +3758,19 @@ static int cgroup_file_open(struct kernfs_open_file *of)
 	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
 	if (!ctx)
 		return -ENOMEM;
+
+	ctx->ns = current->nsproxy->cgroup_ns;
+	get_cgroup_ns(ctx->ns);
 	of->priv = ctx;
 
 	if (!cft->open)
 		return 0;
 
 	ret = cft->open(of);
-	if (ret)
+	if (ret) {
+		put_cgroup_ns(ctx->ns);
 		kfree(ctx);
+	}
 	return ret;
 }
 
@@ -3776,13 +3781,14 @@ static void cgroup_file_release(struct kernfs_open_file *of)
 
 	if (cft->release)
 		cft->release(of);
+	put_cgroup_ns(ctx->ns);
 	kfree(ctx);
 }
 
 static ssize_t cgroup_file_write(struct kernfs_open_file *of, char *buf,
 				 size_t nbytes, loff_t off)
 {
-	struct cgroup_namespace *ns = current->nsproxy->cgroup_ns;
+	struct cgroup_file_ctx *ctx = of->priv;
 	struct cgroup *cgrp = of->kn->parent->priv;
 	struct cftype *cft = of->kn->priv;
 	struct cgroup_subsys_state *css;
@@ -3796,7 +3802,7 @@ static ssize_t cgroup_file_write(struct kernfs_open_file *of, char *buf,
 	 */
 	if ((cgrp->root->flags & CGRP_ROOT_NS_DELEGATE) &&
 	    !(cft->flags & CFTYPE_NS_DELEGATABLE) &&
-	    ns != &init_cgroup_ns && ns->root_cset->dfl_cgrp == cgrp)
+	    ctx->ns != &init_cgroup_ns && ctx->ns->root_cset->dfl_cgrp == cgrp)
 		return -EPERM;
 
 	if (cft->write)
@@ -4772,9 +4778,9 @@ static int cgroup_procs_show(struct seq_file *s, void *v)
 
 static int cgroup_procs_write_permission(struct cgroup *src_cgrp,
 					 struct cgroup *dst_cgrp,
-					 struct super_block *sb)
+					 struct super_block *sb,
+					 struct cgroup_namespace *ns)
 {
-	struct cgroup_namespace *ns = current->nsproxy->cgroup_ns;
 	struct cgroup *com_cgrp = src_cgrp;
 	struct inode *inode;
 	int ret;
@@ -4810,6 +4816,7 @@ static int cgroup_procs_write_permission(struct cgroup *src_cgrp,
 static ssize_t cgroup_procs_write(struct kernfs_open_file *of,
 				  char *buf, size_t nbytes, loff_t off)
 {
+	struct cgroup_file_ctx *ctx = of->priv;
 	struct cgroup *src_cgrp, *dst_cgrp;
 	struct task_struct *task;
 	const struct cred *saved_cred;
@@ -4836,7 +4843,8 @@ static ssize_t cgroup_procs_write(struct kernfs_open_file *of,
 	 */
 	saved_cred = override_creds(of->file->f_cred);
 	ret = cgroup_procs_write_permission(src_cgrp, dst_cgrp,
-					    of->file->f_path.dentry->d_sb);
+					    of->file->f_path.dentry->d_sb,
+					    ctx->ns);
 	revert_creds(saved_cred);
 	if (ret)
 		goto out_finish;
@@ -4859,6 +4867,7 @@ static void *cgroup_threads_start(struct seq_file *s, loff_t *pos)
 static ssize_t cgroup_threads_write(struct kernfs_open_file *of,
 				    char *buf, size_t nbytes, loff_t off)
 {
+	struct cgroup_file_ctx *ctx = of->priv;
 	struct cgroup *src_cgrp, *dst_cgrp;
 	struct task_struct *task;
 	const struct cred *saved_cred;
@@ -4887,7 +4896,8 @@ static ssize_t cgroup_threads_write(struct kernfs_open_file *of,
 	 */
 	saved_cred = override_creds(of->file->f_cred);
 	ret = cgroup_procs_write_permission(src_cgrp, dst_cgrp,
-					    of->file->f_path.dentry->d_sb);
+					    of->file->f_path.dentry->d_sb,
+					    ctx->ns);
 	revert_creds(saved_cred);
 	if (ret)
 		goto out_finish;
-- 
2.25.1

