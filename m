Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A02F458F389
	for <lists+stable@lfdr.de>; Wed, 10 Aug 2022 22:27:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233325AbiHJU1U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Aug 2022 16:27:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231804AbiHJU1T (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Aug 2022 16:27:19 -0400
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0681627165
        for <stable@vger.kernel.org>; Wed, 10 Aug 2022 13:27:19 -0700 (PDT)
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27AIOg4u015735;
        Wed, 10 Aug 2022 13:27:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=PPS06212021;
 bh=WN0wUyfC23RyXK2u+wooga19wsZv3e59DHYUeRRKa6w=;
 b=dgashD1KbhUUW38lppNPRgKJQacDBNklzl7rQxwr/uWEebZ56/JgjKFuqcsGm75qZqnx
 HtNh/HflX6lU2+w3wR2wYFg7dWx9Ube4Z8AcGz0F7JD4HxxfGBHTUjLA940tiogZjSNl
 8JYu/bSZiar0mtmIFZzJp2OcdDGrCpawxPHnfRDHvxuvajij3gly86HBUTcozRyRyzUO
 vZJcCcubc3YqjqdcM1S8csF+0XoE3eNT1AyMEHm5RlaPInboSLGV1GZCcWatmpuKjqlg
 fjg82jWdoY7t4Oz/rpCnR2N/c53T+GtwJKfqAsJi5doknwkLB6yin4dZDEuoAfMm7alD Bw== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3huwrcgwwj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Aug 2022 13:27:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BI2tWdIOJG0h7OdIqS1/umuXaeinHSC8DQZbgjalw4rqpr2szKFokEkPqLuE2U7S9893pbf0wW+zZyTANv+rjbp6I6vN/lrMTes/kK3IzGDyTRnEMbbrHiD/G13aQxw+D1W0Khu1sUoKkWjURLR1ls3YWnFAbyC3agRbJtHKS/GR+Yds9djqKpXUJUN9FAgSZfyoyVNMShOKlSx9wetDG0aIDGqyYAe+/rauhLinaN8eDnrbubXhtULCohlPYfqfgkWQD4BLsR7U1ZjlRuurUfvVUfOrBfE7ZOAhSu9EBZVS4GI8TFerFuv4Iki9Uh35DI76sSPezHi0OLKhw7wOfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WN0wUyfC23RyXK2u+wooga19wsZv3e59DHYUeRRKa6w=;
 b=n/jYqUOfXYFzkLspqpVOvZOdokBzxiJs5DrPMA3f0dVJ0n9QbguP7UL02qq7i1RJN43E+mBKMkSKWE1XN/tfa/eK5qd743Icb9Q4yRUOxjyblwu/D1n5qtuH8akBYYznupVtv2PZQGeuCidpid1LumImi7cKF3V60XPosLf8afK7IRi3aLrEJLGtesn2WVjrnJ6MLfc71hJW+7F+mDGuprvtu9s5Z77wPIH1lZSWN4/E0K0yRzRbHzosA7+1sNCqqUnb+3lDdqjp+vo+SSeRwObr9MJuaGFexZm4UqBk4PaGM/qFJEjyeejzximh6BvUMm3GKkT+tJWNX9RLONS40g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from SJ0PR11MB4989.namprd11.prod.outlook.com (2603:10b6:a03:2d9::22)
 by CH0PR11MB5217.namprd11.prod.outlook.com (2603:10b6:610:e0::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11; Wed, 10 Aug
 2022 20:27:11 +0000
Received: from SJ0PR11MB4989.namprd11.prod.outlook.com
 ([fe80::c1cd:e945:f9e:b71f]) by SJ0PR11MB4989.namprd11.prod.outlook.com
 ([fe80::c1cd:e945:f9e:b71f%9]) with mapi id 15.20.5504.021; Wed, 10 Aug 2022
 20:27:11 +0000
From:   Stefan Ghinea <stefan.ghinea@windriver.com>
To:     stable@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Ghinea <stefan.ghinea@windriver.com>
Subject: [PATCH 4.14 3/3] KVM: x86: Avoid theoretical NULL pointer dereference in kvm_irq_delivery_to_apic_fast()
Date:   Wed, 10 Aug 2022 23:26:55 +0300
Message-Id: <20220810202655.32600-3-stefan.ghinea@windriver.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220810202655.32600-1-stefan.ghinea@windriver.com>
References: <20220810202655.32600-1-stefan.ghinea@windriver.com>
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0083.namprd03.prod.outlook.com
 (2603:10b6:a03:331::28) To SJ0PR11MB4989.namprd11.prod.outlook.com
 (2603:10b6:a03:2d9::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 19a0e40e-c86a-4604-7fa4-08da7b0eb488
X-MS-TrafficTypeDiagnostic: CH0PR11MB5217:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gJzBJl23aSfv1hfCEkxa54SBVzUUyqRcvwSTDz/WT1DDdjJXm5E6HvRgaAmhcgWPP2ZVDUoc0ggu25yRP8skTSHFzDcXX3W5Iueg9YYPJrx23PTpglde0bdZFey8xrGWR8Xc3jNPSz8IbQcqve8yyD2SO1bl9FJqUeRFw2vwr8TwpvwNiOreccelnBJ8k4IESBu2AvxNLA6I5DyHeJH+dHjPVDK959u8Z7IcPxTK5V/HpT10224Co7GK3AQKlRepd/nJyENcCZVrSkYJgPbBYs9rTp11w3BEuqT6bST/MCqUWF1WQ+5WQaFYtf0Vl2Vi02kAmjmm2RU8WNyutqz12GPcaIv/qDpUWBKUyp4FBWp+TDYProvKHdSKlE07eEoHGxzQ9RHmvTMtWrgittTJRQtngU+5sbYZADBVLix7/WZ1idkUd4aWB8YzRSqzuuZkWNiWu06TXgV5b4rut5qW6XRiZZucWI6iH2r/uxx8AtX2dOeNJPXD/dAtKQYEEu7WCwQ+U6KqSc2YM8LZWSfCnoRjazcy/xrIScnXLmTB/Hx9iGB96r+d5AftGrmEA1oVIzbb5+bF8E60s5DUGch6u9t54bcwK9yQhBWIXO67DT6tgQ8YJ3v6iQPoK5s2WBmFJsSVxP0+8Jp5GbSwrZ/Shux+MlkK2SJCEcwfYFsTuCkHogeQftQSZOePTEziPCysynyyi+dGIXl+HH8GI9vvPsivo/8R1gR8JxhQ/9ZFd0hXVYJncVs6LDcVXoF38A1II9GITDnxHDahwocn5cuFY7LoYODqJ3wbfSAd5IxXhD5e/r3CEpYfQ7c5lzYZ60r6
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB4989.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(39850400004)(396003)(376002)(366004)(346002)(54906003)(6916009)(316002)(36756003)(8936002)(478600001)(86362001)(6486002)(5660300002)(44832011)(2906002)(6666004)(2616005)(83380400001)(38100700002)(38350700002)(41300700001)(52116002)(6506007)(8676002)(66946007)(66476007)(4326008)(66556008)(107886003)(186003)(6512007)(26005)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IRcPMPBpnHC3j5KLXZ/imr+ZixDmKKIVraYMUMAnziSOGe1rO3cq4lVGsX1M?=
 =?us-ascii?Q?ApniiqRH2dV+TVneOrkdDMaI6rCoDh2mR3FkrAZZ0kat/6IzqaPOfCspzjgq?=
 =?us-ascii?Q?hzqxOKEYULvANxXRm4qIlJqCLxoLXkVRYfgAvUAUJA/b+rRVv2c6IEtKvPRU?=
 =?us-ascii?Q?mlqSay9Npb4pAhYPkn27AruWfVsd3uDDup+hwzP/J6hjD3M1APzwgpIqJ0My?=
 =?us-ascii?Q?RJrityb2yuRMMg4UPcrFPD72vQciZ+95memb9smuNciDI/s0jxNzbhYoRcDR?=
 =?us-ascii?Q?L/fVywvRF/FhblzMp4ZZcm5jBXznnTIxunZTYf44SEZQZHFbf2qCff2R2MDo?=
 =?us-ascii?Q?8WD0+EC/L7eBR+uS7j1x9+Uh244eFEsNmMtlU5x20kFijhz+CZmNtRdBw4Ni?=
 =?us-ascii?Q?cq1DuKbC2X31KkfbwdHKx7SK8EZp1mjrMrOhFjhfkv/fD9pD5+myWCQNZXmY?=
 =?us-ascii?Q?6+G1EH5SJxKJOuXRh9kO1BrrB3ccsNJjuUCghZw4qHhi3D7/bZcJyxEK+LlJ?=
 =?us-ascii?Q?PXoKGytXh6yntqhnfr/tGsRNqtWWui3VfdefcpBVZ7v8nnRdcvIAhYKZLbIt?=
 =?us-ascii?Q?uH8hfaMnlqHQExN1xQbb879wWuBsBxRGVRTuwJd4Z4dijNPsIO9gcCQUBGd4?=
 =?us-ascii?Q?/B+7n8gNGYpS/p6yR+06Azc3SzGO21V2aDby9RTZnQOCsLhZ2qDQUkoIo+al?=
 =?us-ascii?Q?M8Q6+dL0rph0NYyeVzy4mTcVITCEs9SuV726kpY7ORsg/WTvuxgxvZwo9VKZ?=
 =?us-ascii?Q?RaPBhbgbNmJ3wzQF8SqNHzA3yHkpqGL7kL7mfs1clMf6n9xkHboGUE3VMpEo?=
 =?us-ascii?Q?VPdgqB4Az85FrYDDDK4Huzk/FmnctXfnO7dT0ba6GVcDEu+NxuYcLqP8Sg60?=
 =?us-ascii?Q?GuHfNHA1rlxdCk3JJjRizhFyYp5ic6f90o8DPKnVbdkPibwYLTASz1pJJ6Ke?=
 =?us-ascii?Q?xyMHPAoZ5PmBYCAbNC1Yk3heCrjRP6Jp35yACEfueVJn5Eu60IpoM/5qxfyd?=
 =?us-ascii?Q?CmgNYhsKlBL23TT2QZEJvRiSs/dAvLo1gT6BigMyy5OGncu5yh+w9nkp3Wte?=
 =?us-ascii?Q?Q+z/wCwDQPNfV2L4o3epx4fNz/T5a8vqyYLeCZIJ35hJWHb2jHVXLI7GX0N3?=
 =?us-ascii?Q?lmgCdNkYaurMmUEiDHnXvkqs3xaoGV+yoiZWsRi+gCtbobxozyMvpEBg6yEp?=
 =?us-ascii?Q?X4OsYLKBjUfEgkEynH572LYG2hIh8e7dlJ09aMeCdb4NnBdVk/DFizUrFhTl?=
 =?us-ascii?Q?UqXbIYXfhw3fuy98DP6y7Xn7gAd0RDVWIs9BLe4cQfFPJKV9pV9CfNeAUku8?=
 =?us-ascii?Q?ht5WiEttTlueuup5Lv7WqzxIQ5jImrrcFS/lxlNH9ApxROfb82LTtwPpYwFw?=
 =?us-ascii?Q?bYyNJexqBC37j+Sm27+C8HWQ+0525leFxIN9NfTNznOf/Djpu8z+kRZCo+2E?=
 =?us-ascii?Q?px08FBQkqUj6edHRWeoTZmX3Q5d6gZ1R4YJvIbeLNwjs8bNb1DdVktUExQoI?=
 =?us-ascii?Q?Xwro4WOqXb+XR57oCfbCyW285fydLTwxkuzma02eG5/FlqRPoWXNslAEji6L?=
 =?us-ascii?Q?hW6iYomyQ2zTScJc3pMGkyZIPjDMB+/qbPN3DPW29bg2Asz4nFIKPXBtSlaY?=
 =?us-ascii?Q?Ng=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19a0e40e-c86a-4604-7fa4-08da7b0eb488
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB4989.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2022 20:27:11.8386
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qpad7x0ifXIbPZAWAYbQSGw3i9XtlR4bO9jgfqsggZTjImd6ozRETkcRWWY3EcvUmS055YnUJlJrn4estnfw6grBbVGUTRvWQT0oG4Et178=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5217
X-Proofpoint-GUID: qhB9p4diIhSxNeu3pAjrmtT32sV73rKt
X-Proofpoint-ORIG-GUID: qhB9p4diIhSxNeu3pAjrmtT32sV73rKt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-10_14,2022-08-10_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 clxscore=1015 impostorscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 spamscore=0 adultscore=0 mlxlogscore=849 phishscore=0 lowpriorityscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208100061
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com>

commit 00b5f37189d24ac3ed46cb7f11742094778c46ce upstream

When kvm_irq_delivery_to_apic_fast() is called with APIC_DEST_SELF
shorthand, 'src' must not be NULL. Crash the VM with KVM_BUG_ON()
instead of crashing the host.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Message-Id: <20220325132140.25650-3-vkuznets@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Stefan Ghinea <stefan.ghinea@windriver.com>
---
 arch/x86/kvm/lapic.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 99b3fa3a29bf..4305f094d2c5 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -894,6 +894,10 @@ bool kvm_irq_delivery_to_apic_fast(struct kvm *kvm, struct kvm_lapic *src,
 	*r = -1;
 
 	if (irq->shorthand == APIC_DEST_SELF) {
+		if (KVM_BUG_ON(!src, kvm)) {
+			*r = 0;
+			return true;
+		}
 		*r = kvm_apic_set_irq(src->vcpu, irq, dest_map);
 		return true;
 	}
-- 
2.37.1

