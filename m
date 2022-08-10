Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DD6858F381
	for <lists+stable@lfdr.de>; Wed, 10 Aug 2022 22:26:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233297AbiHJU0R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Aug 2022 16:26:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233285AbiHJU0Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Aug 2022 16:26:16 -0400
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A3A42716B
        for <stable@vger.kernel.org>; Wed, 10 Aug 2022 13:26:16 -0700 (PDT)
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27AJTts0027668;
        Wed, 10 Aug 2022 13:26:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=PPS06212021;
 bh=nV2XmuVX0zSjQHJf/STc9XY4M8h2S82r/eBceiqwUtU=;
 b=a1RP/gWm/R3rS8vMMXEjM4zkX8YJDvsYUuKfgGDookwvrlWDfIbQKIMAlacLy3kZXEtW
 Hu9QDFe9nj3xhsM+5pkghRMDDraZUbG8iF2Wj2IV3wJWN5MeUIe3laYJzPywJg2GKwA1
 H+j/IIUToXsk8o1Hh2bVjfP+6rfjqtJUWC4M0Gbn+hlM9CGgLUc9QxikymYWI2KZCN49
 Kd7zG/IXyOte8onxODr0SSgWknizBah3UQBiSZX+XQdDjpXZGEJfEVbp8B/nAJCCmHWW
 qbQR7Fp4sTsTZu3aCc5u6qB2LGk58bjzXQT5Re12xgB2eRTRZ6c/hlFaB/jHQ5aaHLEd cQ== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3huwr7rx0f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Aug 2022 13:26:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IokSRrqtvWmvcFeSs3KG852DQgEIqlMJ1eIiXjm69xOE1EV7T46gKk8WDoMuNMVr7DMWWc/ut2Jn/F/vrjUEEM2/J8nvoqTJtImazKwj+nBrZjP99NOg67xCpGeosjLJWM3LVW8iMt62LsgswgvA02rxQ5JOB2NZUgOLS6e7jXczjpXwLe1onY6oOiB5egqS8SH7ffGzVYbUOr68pA958utPan+Dn92U4n/iinm/nyLpW++k+phQbhPNl/7jAfXkOFwy0pbSVxoFvHuZ8UfPy7BaX3LaWTDMhKVfVgCJk3axexcb6vDX4e6rSWXCoV7pHE7HR6SrAaicQV9rt2pppw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nV2XmuVX0zSjQHJf/STc9XY4M8h2S82r/eBceiqwUtU=;
 b=T2NJhuL+/QVQ3J+d/ljzPpgVoGb7ir9xRxXhn2/rZ9b7ohIi/MChBm0Wc+NerNhC1IMx8XpoKXLIuKj+v71YfZBNopwJFpImgnZZK2j/g8OS+AsO7eqoYGWmh1S0QPQ5p8HFiAH9Xqad3NUxzvoEc/Oc9jtQGcuYnsm7ZiZe9XFFa4/3E7sdvi6W2O7Z11YZNkGPhG7GjEq2yQnhkbah/UNzZHsjWYYp3th9nXpEwYo0nUhTWHyC9UodR1NC5UJc2oaHUbqY5POwsjVD/Yhmdrx+6wRFlQFc+0HbOsRbogwqO9RHpMOu/l/4S6x8SWAfe2jow4Zpfny9pElzNbOemA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from SJ0PR11MB4989.namprd11.prod.outlook.com (2603:10b6:a03:2d9::22)
 by BYAPR11MB2920.namprd11.prod.outlook.com (2603:10b6:a03:82::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.18; Wed, 10 Aug
 2022 20:26:11 +0000
Received: from SJ0PR11MB4989.namprd11.prod.outlook.com
 ([fe80::c1cd:e945:f9e:b71f]) by SJ0PR11MB4989.namprd11.prod.outlook.com
 ([fe80::c1cd:e945:f9e:b71f%9]) with mapi id 15.20.5504.021; Wed, 10 Aug 2022
 20:26:11 +0000
From:   Stefan Ghinea <stefan.ghinea@windriver.com>
To:     stable@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Ghinea <stefan.ghinea@windriver.com>
Subject: [PATCH 5.4 3/3] KVM: x86: Avoid theoretical NULL pointer dereference in kvm_irq_delivery_to_apic_fast()
Date:   Wed, 10 Aug 2022 23:25:52 +0300
Message-Id: <20220810202552.32242-3-stefan.ghinea@windriver.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220810202552.32242-1-stefan.ghinea@windriver.com>
References: <20220810202552.32242-1-stefan.ghinea@windriver.com>
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0701CA0035.eurprd07.prod.outlook.com
 (2603:10a6:800:90::21) To SJ0PR11MB4989.namprd11.prod.outlook.com
 (2603:10b6:a03:2d9::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 16454f36-f8ee-4c44-3d23-08da7b0e907b
X-MS-TrafficTypeDiagnostic: BYAPR11MB2920:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2AQOeya+f/6zfCgdEEvU11d+U2W13yjO0CuHaoi9OK2HrotNnxX8oYu6LhGuS3XNSIw4Ti/BODpLISoS+Fjg/PEIY1tFRzyO90p1zlPMSSTR0efNgro+eSHuPFHFuF3sKceTwb0IxP80r3oIrC0J+MfCS24YNtrZQyP4HBeAcn0nFVBPaSCIonSnKc4HIlG6GpsUrbqVRKAG0uLzVaRKeNAXWQCuLLOs9yjkmoc0k/pXjYQq2wUMcvX9+BQqaF2vB/cHf8w9RW6sSxrD7MqLe8vHkOw5Tf0br2vMdip0FAQsNyW66+O4wVKpsN3KG2QHGAoAZvtyZZOiiMtxoH40mFBtInpQ4460tOOrW4tB1WSBHZOlXp4rhmDRrSKp3K9ZWHEk0iefORLwn6O5zdvIBZICVgm7UN1nVBoIH45Bq1RmfA9Rp1UsFr5x8Ab5bgbTnAiauznwfqgICY5OIFXOQfOf7frYdPQcJt3B5AlFkKr/tVMubmRLFoUCT3gI6dGt5MgeriV47MFSKwSTYwzHJaLj61sonM1HRheVdr4f7yEHL/Tva3smKspFZyMWFW1Kdzbsn27u5lgaCdV5XF5IKi5+6YGuhrTqv+Rpo0QNEMsD5l06KFYJDEvd7irTf7zeez/36nhkkY69u3mpg8DIZdaPP7nvS854wGnlpOoE8/GwOZkVYoFWgS8Wa1NUJPxri5j1fYmrK3somBqJWELFfMwe3F1xf7zkDXijQzb8Y6+OWN3ZDFhFFMuElXMfDSAOSE9MDi3gKraF61Pv7JQ20CL7pb2HOT6RjjEevRgNpy8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB4989.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(136003)(396003)(376002)(366004)(39850400004)(6486002)(107886003)(478600001)(86362001)(1076003)(186003)(6916009)(6512007)(26005)(52116002)(83380400001)(6506007)(41300700001)(2616005)(6666004)(2906002)(5660300002)(66476007)(66946007)(38350700002)(66556008)(38100700002)(8936002)(316002)(8676002)(44832011)(54906003)(4326008)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?st6W7rUZkNjDWOz4urxSxSeqVVrbRC2+CG16+EsfVoxXbUYxknqZmpAEZrH3?=
 =?us-ascii?Q?mmO/RcyBmhGVA6rk1jK4CpT1du5J0lE/x8z2WymeFSBSUVKS58dhB0gR7reQ?=
 =?us-ascii?Q?5i5ySFh6gl1LjXN4mpLwfkY4o6MsKRWES9RokILWrFp2HAOUbsTzqGzD2fM/?=
 =?us-ascii?Q?M+BILHRG4DXDMBdu8avUBX5L81TZS6d8bTPUo5B8ADgCZRA39Q8oYrYsGS6S?=
 =?us-ascii?Q?XyEq8lEC+t774H2lfvDPrxAaI+PdE4U/nvIcnX3SA1B9XIPqaR5qQ7r4kf4O?=
 =?us-ascii?Q?+7TZsk8DG47sjl4EEGqTM9qXFN0Zf3ZaWfketLKEUpD55VUis7luQENQIXVw?=
 =?us-ascii?Q?YNc4QUQWMVz8wXuLHLnpiE7ddrQBPjJAqFmvjoTjIYTsId5d3psLM9+0jQpn?=
 =?us-ascii?Q?f/LRZ0d4P2KAVlYCzblxvgnJdUVo5ADpUdn1aDZtpPLr/U7cLExNX2eR+Tmu?=
 =?us-ascii?Q?pxrJUS2JNr9oUMvM/Vz/PXQkSVOXfcWuOvrsOKnL+1ABMS5IXnwmI3OoQx12?=
 =?us-ascii?Q?1F+bFSCtCr8HRzRXDRguq0vd6sr3w+DOtG1TICxHkILdwgNxFXKLcxTz0JgJ?=
 =?us-ascii?Q?6sw3qsZ6amnHGPy9PGytVqqcpcKPJK4oNW/YSTLfWxp1nMkSlGrleUuh0RRs?=
 =?us-ascii?Q?I1qqXXqdsNHXA/6QxiNdhuNptXBtl5l+MW6cVfNk8NDy6/8/9s8Jq3JvMk6C?=
 =?us-ascii?Q?er0tXDdgvQU9T9voGNrqJybaVLxl8I8EzTb0Hme5tbGWg2aI4qumT5E+vnlb?=
 =?us-ascii?Q?/a5SoFrYBrG4AEwLwZi5J5N4xfuGDnfVUJ+AlbrcyZ1Kp2p46ryqYCWdGxHZ?=
 =?us-ascii?Q?6au1ZBod2lGOJ5tR4pIjqKxTeAbSVyaXyi2bZeM8gqz3C/O8D9E9QKzLcDgP?=
 =?us-ascii?Q?QNLqkZWPLFyNgInM0DJ30bE2/pGVw/MYw9/Mhwg7BDtzC0HQXjfdnjIFwzvZ?=
 =?us-ascii?Q?j1UWkm9CnpfuOuqyXB94M6zZAFvK+7mTAgY3jfmbNFQ7vjDoZt/aJxcPeSfi?=
 =?us-ascii?Q?5yS17rvOEH1eeIVY7YSj3gWUNC3x5zQ6Jfg5GNrA8qXdoW4Yx9HrrQmM3MNH?=
 =?us-ascii?Q?yPKf+WZyll2PlvbPdgthTt9xJ9H2Arvua6PRQkEoN5KeYz7yZklNLHUZ0RQl?=
 =?us-ascii?Q?6W4uPKKvKCTyolVsx/c6EH6sU8tCNBllo7t9hyuC6Q7byIIiUcuFfEpIHOww?=
 =?us-ascii?Q?Y9CEn3PKjE2ll4m1ew4waOIXYXyZXAi0eCL3eZyy8H+SLYJGGbEtau8kIFyB?=
 =?us-ascii?Q?Ab560NE0oEgHxxdL5QoApuUDjkILmMcvd638stjinrKpkPchNTvkcGH4r6JX?=
 =?us-ascii?Q?RZC6ZD3v88YN7jebtkIGsDFQEzREVKn1zkQ5otcS01jh9YFvq1H6OzaENEUm?=
 =?us-ascii?Q?Oyv2m3nZfASKp7ShsBmGPZk8sQZAN/OwkxvIARdAxODs2FB7Qpulx1b/aNxT?=
 =?us-ascii?Q?nyd/Gh1ZVHbnIs/bQuDFXehRvukCh2Z0PeB2e7/e8EO84o3kQlTrwefHuccP?=
 =?us-ascii?Q?Dm6BCP7w0ee/RObBjJwIgJmOHWuFZ8FRz3IXQZqbywaDOX0r8VE9NvseHTnC?=
 =?us-ascii?Q?VUn/mjcMASq3o3AwYIyiQ4vSkiBDm8Og/xoErYrOPm3AyAYsj5ikERD088WK?=
 =?us-ascii?Q?KA=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16454f36-f8ee-4c44-3d23-08da7b0e907b
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB4989.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2022 20:26:11.3225
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TJBZi97uIDIkkxkWKJg4SQdkNMl2LRHPdXiwSwKRuF4bGan66Ibd7/U2LtVTxG5ty9lZ4r4Vj72SOVFdODlU9ohq7ypFz7oiHGyXh/Ryd8A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2920
X-Proofpoint-GUID: 8uIrtttxI4H3_pgF41KsXGTzAcRC5vIQ
X-Proofpoint-ORIG-GUID: 8uIrtttxI4H3_pgF41KsXGTzAcRC5vIQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-10_14,2022-08-10_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 phishscore=0 impostorscore=0 spamscore=0 suspectscore=0
 malwarescore=0 bulkscore=0 mlxscore=0 adultscore=0 mlxlogscore=849
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
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
index 3696b4de9d99..23480d8e4ef1 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -955,6 +955,10 @@ bool kvm_irq_delivery_to_apic_fast(struct kvm *kvm, struct kvm_lapic *src,
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

