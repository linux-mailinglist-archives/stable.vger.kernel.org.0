Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEDCD58F388
	for <lists+stable@lfdr.de>; Wed, 10 Aug 2022 22:27:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233318AbiHJU1R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Aug 2022 16:27:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233350AbiHJU1O (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Aug 2022 16:27:14 -0400
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B89C027CEC
        for <stable@vger.kernel.org>; Wed, 10 Aug 2022 13:27:13 -0700 (PDT)
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27AFs6IW009493;
        Wed, 10 Aug 2022 20:27:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=PPS06212021;
 bh=0tgf/ktjE/qVVhwp69uesNydT46NuwQoPEgIq1lW6Wk=;
 b=BvFW4OWSrOYkJ10T3325f334HXTz1w4ffvwSmC7a8x1c5Eca5vJMfUhQDdH/W76JPD4R
 uHDhKsHkO+BUUmb2TufegQKZ6ItpLk7aj18ApGeP0ifQgK0rtfMxAlXW8V3xHf4X07gJ
 OdImN+ZtnKKVfi998q7LQihYM/KNJQJpqFycprwOjNPwyDDC/edP1XKOwMxclMlfr+fN
 ghquunx2FgBJlFVlpXGHH+maFJXtQps4Ux5Rga+6e4dMAb0nvM+iXiEhh+YNl3B2Vwk9
 uuZ2gDL++JM1oW3HIu7h+EtpWlLlTh6gdHG16TwpZ34hFxW9lGBsTYOQkgjSXHfAc9Oe Rg== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3huwr50wdw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Aug 2022 20:27:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Op7wKGphB+FDyoADC8wpaiA1jtQu0UZoHmWGNnuJvBabaZo8aZS1MmrWuEUSKwCNyXgBLBaf53WVA2AS/mv7hZo9c1ru5e/dYuQbPkPbN9dL5JyFrUuZS43sATM/XOyjHDdTBigcJ4GRI29llPtBFYaWUmjzcojU2lbqgjPjzXn/xvBmZ/T1qYtavY+Iv/7Et9sr+Qy288hXvTegwNVfm2PKmsPbaplw+JTAnzQMTjkUlQhnBE/J5+9QZBH77CYp2opmzUY6Mt2G3RC0+YVfYWQaznb8XcDIQ8DrbvbMlpoCrU5KF2MTFRld4CI29zGr96oT0avMl/u5cz4z364keg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0tgf/ktjE/qVVhwp69uesNydT46NuwQoPEgIq1lW6Wk=;
 b=GrqPozKClCiel4t5OpWFOFYPl4ot8tdProKvUPWteuqmCm11DBjivIWCiAr8ZXOymIkP/Drvp9cu//XFXNIgdcr204iuX9YzZSBvea2P87uKg5vjTWJ7pqcOZD83cmjZ2UJduQSfcwuKGVIKinVsGmIHyQNskHz4W4w4YgBsMKLR3h9t4M5mtrVoxIg0i/SF0pcmX5BuTCic7LQLZ6A5ssySXaS6AuTGze9/jhM+7nnxjmduP8lzwYr1hrpUKWjcRil9pfOd5qIHZt0VkwcRTNJcS06dDLQQ5976T6gD9OMOdz9jA6V2RZG6WBIBbhA/L0b7vl4U3kKvuycUqJ1icg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from SJ0PR11MB4989.namprd11.prod.outlook.com (2603:10b6:a03:2d9::22)
 by BYAPR11MB2920.namprd11.prod.outlook.com (2603:10b6:a03:82::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.18; Wed, 10 Aug
 2022 20:27:10 +0000
Received: from SJ0PR11MB4989.namprd11.prod.outlook.com
 ([fe80::c1cd:e945:f9e:b71f]) by SJ0PR11MB4989.namprd11.prod.outlook.com
 ([fe80::c1cd:e945:f9e:b71f%9]) with mapi id 15.20.5504.021; Wed, 10 Aug 2022
 20:27:10 +0000
From:   Stefan Ghinea <stefan.ghinea@windriver.com>
To:     stable@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Ghinea <stefan.ghinea@windriver.com>
Subject: [PATCH 4.14 2/3] KVM: x86: Check lapic_in_kernel() before attempting to set a SynIC irq
Date:   Wed, 10 Aug 2022 23:26:54 +0300
Message-Id: <20220810202655.32600-2-stefan.ghinea@windriver.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220810202655.32600-1-stefan.ghinea@windriver.com>
References: <20220810202655.32600-1-stefan.ghinea@windriver.com>
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0083.namprd03.prod.outlook.com
 (2603:10b6:a03:331::28) To SJ0PR11MB4989.namprd11.prod.outlook.com
 (2603:10b6:a03:2d9::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fa498e84-5414-4fb2-0962-08da7b0eb368
X-MS-TrafficTypeDiagnostic: BYAPR11MB2920:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4Qn68Q3t8b9whWHPqoNv8HuZP4OmGv8lZ1VMxlmTEXQv9rNWe1msegUKWe8Dcl5pHL91+omW6yXjosw4A68nUOxzVWC07+OxjHROvli1MpywQSv7cYpLVp5MTsG193t7BLPb1zDlLQGmVKL+03dpNYnGZzoOTWU4wWGuKMrjkr0zWKSqxRc0nbMyollV3F+mYgKRJ71xnBV3FwOIKOKfUXXERXfJ/r+EgqTChQlhkxQ74a1K0ccyzYOXexSUbBw5Ki5U5iltmK9nLn1pHiZAN+2zaUxqiEw4TlrM91bpmx7dEPo5gvAS2xCxF53BoQJXwICsmmYZSMqAsVynKiVYkKPJVwqF/c+z5Jid+8G+qIpFTd42WGy4d1HPpdVD2kYHmZGOBhj3qLpvmxD+jRNIl9RuRW9CDPy2fhdyI4WoCbGGdwN3aX+bizgjM/1iF4Ps6i2vgNzvKAatGH9RiZU8xu3HKRg53qrwh0DK79+qWRdUtGfYY8mAZiqedqESr2jiYofhyCrFdkPouvy8e3BDUP+E5r03SE972zQH0M/H762BXC0j0nZCBh+DiS8iim/cPdeR7U8+lrqpG42oKuB47KiWxgbql5wM9fDrBAs+02k3Swthq/x2pYPn4GDdA+QKNkKMcRQ4scd8Mr2YCowcC6qlTjrLcwO+ohH5kcLiKZUyDbL3r8K0RaqtkOTH1gBHin1kUZnvUDqRX/KSoS+1wq5dcF2jET4gxj984ptfEIi2Fsw6FoWZeO+xpQfbVZvKe8kdPcRVWrXoN3Msggx/tlQ3sBDr5t2r6D8NX97hlunfuYHQnZ4pgpcyiqahNpvp
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB4989.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(136003)(396003)(376002)(366004)(39850400004)(6486002)(107886003)(478600001)(86362001)(1076003)(186003)(6916009)(6512007)(26005)(52116002)(83380400001)(6506007)(41300700001)(2616005)(6666004)(2906002)(5660300002)(66476007)(66946007)(38350700002)(66556008)(38100700002)(8936002)(316002)(8676002)(44832011)(54906003)(4326008)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?S5rvIR3zOgHoqnnDlD5kxhQn8hTJwEwG/SuSyBznHDtdjcMZHNffaDLh36Wr?=
 =?us-ascii?Q?blgYvLyBz3LyOSzX+rWDhOq917loFz+XyVEJdBNpcsmCj48lnAcN3ZilgYJZ?=
 =?us-ascii?Q?VuHjGSSCgDKNytISGVA7g015h3JlO2MK0OPwi+xvHOAyCXFPxmV1sWk/UqLk?=
 =?us-ascii?Q?7TQBKPsnuvazxQtjqNodsdfXr+ggcvQpNqvo9olgY35SSeV5kL7DhgjmG2Lb?=
 =?us-ascii?Q?7Xgf+ly/HyZEx7ea2iXq4qk0+tXR5gpZwsmRYtjSqDymyvlpaAGE2YMDmpil?=
 =?us-ascii?Q?8lWx9UNiJm4vKEnIoQvVwOs8Q7qA+3yK0twFfVPlJTV8fHGUOLPJt0Z+6e73?=
 =?us-ascii?Q?1/wrG5678GalRO3kENOJ1mWQxZRAeV6KGleNugv7KJ/CNjhLfFCc3YWZkXUX?=
 =?us-ascii?Q?f0Uq2M59RG9p3/po/9q6PIyjXfT0Jh+hA0V+0OsB2tHu+bjRkiWcTJX5fhUA?=
 =?us-ascii?Q?VuLF+UqHIpx/cQ2iu+7wPJp8QcryAOEhbqxfbyH5pPhmJCoTz3ydhVegEEuR?=
 =?us-ascii?Q?j+b1CAFhTQ4X72IN2ibKN89avFXh6rvsNbnoOBCYVzdAwjGrBhzUyRxNH9jm?=
 =?us-ascii?Q?9yokAeK3ntPe/3L5NaCrcUG7R9EgOywqcQgZuJHcY3yIKiCPRoNUpF11dWmT?=
 =?us-ascii?Q?b+5KzLmLZ7qHN6T6j5S8yGq3lEHZBYARhNa7D0Nq31gQqqBq0UljL9K76x7m?=
 =?us-ascii?Q?TXzwAFegvioIXGJ+HpkYRctmS70Pgl+jHpMBUaLuOodjHkO7N6lx09ogSmg3?=
 =?us-ascii?Q?gb5Kk3TtIjUjLtVWbSOei/rFHqI+VNNXgriXOQp2qww4ub89lnCrknJeR6gq?=
 =?us-ascii?Q?Za0jgYRf60wSxd33P/x3EkK9i3s1W1NQTZC7GQo8InOf5y/+zXHxDaARvdo7?=
 =?us-ascii?Q?/iettNpvzJqczVViPSID4w3NxgyWyFIbDRZyZcKE4akJeV9X0wghgxBMc1lq?=
 =?us-ascii?Q?8xgRyyY3l9lpPvYdlx6jby2zNYOlmD46yW+ntC/aR8H6utpieXJ5J7+TJByc?=
 =?us-ascii?Q?yX+9jiL/eQLooGPMMXHe5HBIpuavOIOxqDgKzxGSiRUgeUjUk82WzA+W3uoy?=
 =?us-ascii?Q?Ja4f5sjus1YOCDyblVwXXK7qVfDMvMYknOLhZ3WJrAz0plfhfaXOq9UDpoRk?=
 =?us-ascii?Q?hF8JtFlMwcEWYIpZ47r7RqPqMoNR5+Zct6BccvilLtNSTloZlDHBiOHK8XfM?=
 =?us-ascii?Q?qGRb0h38JKi2nLQJIdbpdKtkI1Ym97q4mvqPkE1B9hBII67B9Bdc71sJCUq/?=
 =?us-ascii?Q?IDyv8KYf/T2GHP3z3TjogOfqasYQbG5Lk3K0tCbWrV7l58ESZl+z8gXb5hWk?=
 =?us-ascii?Q?/mkEiMWVI7kCTjIpjyqJBbnVEOcZOrOs3P3w8ZvYr+uDI8WiQaLu6xYlo5dP?=
 =?us-ascii?Q?9geNI39BBfWGJY2oadQy2rXVNBH3YoJ4C0MjBUdRzp0l3rlcOasVOjwZXLMa?=
 =?us-ascii?Q?Lj/OXKkwloSIrVPO+riZBqd5fk10gKRyIbS5I62csS3VDssEj+eQuy+4ZLQE?=
 =?us-ascii?Q?Rr1VR01xBNrp3ZPCdjKe6rt/4T3tjliwGLlYvV3rtJ03mJd3cFI3DVIrBx2V?=
 =?us-ascii?Q?vt+dQ3LUrLVAKtXmigp9IIGBM6zQN3U95Y3ZL0al5DiCY2z/RH2jysOISurW?=
 =?us-ascii?Q?Yw=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa498e84-5414-4fb2-0962-08da7b0eb368
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB4989.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2022 20:27:09.9325
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j2z7qVafu8rYxa7QpxUxVoW4W81Sto0TNq5/aNVgiXKyzO/jYfznBS0lsal62JWLFx46nnw4qBBTdOIRWTn4qOMFFSukso3r/c7Pndfs/gg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2920
X-Proofpoint-ORIG-GUID: PknkTBf2861IjgnCdZU4vmvTm699dnqN
X-Proofpoint-GUID: PknkTBf2861IjgnCdZU4vmvTm699dnqN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-10_14,2022-08-10_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 clxscore=1015
 priorityscore=1501 lowpriorityscore=0 spamscore=0 malwarescore=0
 mlxlogscore=825 mlxscore=0 impostorscore=0 suspectscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
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

commit 7ec37d1cbe17d8189d9562178d8b29167fe1c31a upstream

When KVM_CAP_HYPERV_SYNIC{,2} is activated, KVM already checks for
irqchip_in_kernel() so normally SynIC irqs should never be set. It is,
however,  possible for a misbehaving VMM to write to SYNIC/STIMER MSRs
causing erroneous behavior.

The immediate issue being fixed is that kvm_irq_delivery_to_apic()
(kvm_irq_delivery_to_apic_fast()) crashes when called with
'irq.shorthand = APIC_DEST_SELF' and 'src == NULL'.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Message-Id: <20220325132140.25650-2-vkuznets@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Stefan Ghinea <stefan.ghinea@windriver.com>
---
 arch/x86/kvm/hyperv.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 5497eeef4e70..ae9c45590b7e 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -317,6 +317,9 @@ static int synic_set_irq(struct kvm_vcpu_hv_synic *synic, u32 sint)
 	struct kvm_lapic_irq irq;
 	int ret, vector;
 
+	if (KVM_BUG_ON(!lapic_in_kernel(vcpu), vcpu->kvm))
+		return -EINVAL;
+
 	if (sint >= ARRAY_SIZE(synic->sint))
 		return -EINVAL;
 
-- 
2.37.1

