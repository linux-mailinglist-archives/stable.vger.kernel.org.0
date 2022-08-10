Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9566E58F385
	for <lists+stable@lfdr.de>; Wed, 10 Aug 2022 22:26:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233301AbiHJU0q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Aug 2022 16:26:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233285AbiHJU0p (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Aug 2022 16:26:45 -0400
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E92912716B
        for <stable@vger.kernel.org>; Wed, 10 Aug 2022 13:26:44 -0700 (PDT)
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27AJAWNl024023;
        Wed, 10 Aug 2022 20:26:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=PPS06212021;
 bh=hkqQLLB/MxH5BABuPm53JvBeEOdxDdkhT9G6oj5mYrA=;
 b=GbDayV16+GcRrBa7+lh5KcamFFsktg1nhIE7s+xplhb+YnZzQtlxOUd0v0U/dsE4YQH1
 wYU3aXmITfSfxS8dsiEX3pMT3knhvaFR9a8vnvy3D7e6USA0naZXelyBq3PakSS0nu84
 g+P9SmD9mFnQui6kHPcxVvboDXrFXw5hG1H079OAxinxFyJQKSjxSEkHY4NPWNV0l6mc
 RbGCverk6JMWBaXqWDGgiBYsjqt/i0BSKmMy9dcu245ZQrFxJTlMA/w3MkOsJBmyCG0y
 pOlAk1+830h9qctUrP5orOqxGOxtrHrHQJOHLv3/OMmc1r0h6B1zmCN7j+01cjK8erqI 5w== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3huwrd0wh9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Aug 2022 20:26:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A0zw0c64xisxQkOV6zrGWNVbJ+HuNn5dGG20w4PEnViIL/+rzWsdfiMvbJ+TXMpPEuTiTqpG4GXYmjegrMjQ5o2pwRkXszAzeoqn98/8ZPUQ4FZM09eUn1WewdGhpY1y6muJ5AAOiB9IHImwygkhsUILRMDzySQe93eiXBgmMfjrszAAVsqICBxbezJN/d2IzTxkR5QfgUTmn92uoYcCr8lIneYj+bXDpFY6TlrmfEupWxbhzswPCsOHlQiOKacOL7f+uhHQ7hWPTgfkxn9vBRKTAZKJwPuRozz2Tv0Vu9RlfGm784quFj9g9nPc3YHU1QwmygpY2Rdtr3MBOFEA8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hkqQLLB/MxH5BABuPm53JvBeEOdxDdkhT9G6oj5mYrA=;
 b=Z+P+88/Gk5/CP08uNi7PlZJGktx8QOWQFJH828cKUf1tq1zyaW/n2/XAEqBdh6P2rNFyAtrlV9WgC2ivlubNoJla0qaLB5pkn2R7vLlNYRfVoA4ZEocr1dgkfymRDezahNE2t4v2kaF6d5tCJPT1o3D70gpd23TfZMzPpgfIH4xlqK8L/6TxjnEhev6Rw5tm1aUC6fgh3lwfhk3oPw45/o1i/PWTLU5HXiHbUWj4+DX8C4yuvRkFv04XSFSenO6bc8GrVAGuxLsrkfBMlMotOR5+TK8DxIiy4eMLMWAOL8rH3M4jQ6H8i+oa0JIqekNsbV38BDU+T6l7z63d7qMp+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from SJ0PR11MB4989.namprd11.prod.outlook.com (2603:10b6:a03:2d9::22)
 by CH0PR11MB5217.namprd11.prod.outlook.com (2603:10b6:610:e0::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11; Wed, 10 Aug
 2022 20:26:41 +0000
Received: from SJ0PR11MB4989.namprd11.prod.outlook.com
 ([fe80::c1cd:e945:f9e:b71f]) by SJ0PR11MB4989.namprd11.prod.outlook.com
 ([fe80::c1cd:e945:f9e:b71f%9]) with mapi id 15.20.5504.021; Wed, 10 Aug 2022
 20:26:41 +0000
From:   Stefan Ghinea <stefan.ghinea@windriver.com>
To:     stable@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Ghinea <stefan.ghinea@windriver.com>
Subject: [PATCH 4.19 3/3] KVM: x86: Avoid theoretical NULL pointer dereference in kvm_irq_delivery_to_apic_fast()
Date:   Wed, 10 Aug 2022 23:26:24 +0300
Message-Id: <20220810202625.32529-3-stefan.ghinea@windriver.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220810202625.32529-1-stefan.ghinea@windriver.com>
References: <20220810202625.32529-1-stefan.ghinea@windriver.com>
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0001.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::6) To SJ0PR11MB4989.namprd11.prod.outlook.com
 (2603:10b6:a03:2d9::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 25ee597c-46c5-4a01-a06e-08da7b0ea23d
X-MS-TrafficTypeDiagnostic: CH0PR11MB5217:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ccnszNdWCYOpy6idCg5jvf9o3rHMIHUJhAgIPx27rSxEshF6TikxThETR1q/Zz9itR0cre9NxnO9W2K92RXI3ydhPDNXYQ+18jNUjsJjHKKKo3Ao81Qo144o3gx52KKpUMfwQev/Ajamo3i1Qn9B7jIFajDUtwQyn0umTfzs1NpHeyJmybcxbkS0gnMDRo2TPKtwEH7jdiC88hBwzUo4kFBCxUkQYTfWBpLBNiYI7/ZasLz3nq6ejtjOhISokcbA8UNger2oP4KwbBv2UdwwWIJH4MRmmJu6vWMUtnnc57T3skx7ZeZ9w51fcGZtGvsl3H/u41QoMwhRydVu6NyJr1olxLQxAyouS5z09FXmgxYkmvXHgigovDogDd/4udR9YEbqezL63LLJ0nLvWrNlsfG6UQ9dg1Vmnyt6NWfUk/lrCevgzTXLNjyiTnZMzctjqNrMqJWMJoYDnN6vwsx0cNOcX8QkdtX+OI4hytu6jLgbqfpaTPGN/y3sAbVHKF2rxg0d+hhZsXieaTUuxEAFKhuvISR667nCb7syqrxWNYlZpmnjN1dkrDLbyVNtDKbMv7PKVptSPnnArxrcFjNq2m7tFQPU54obUsb+XIxrMHCtJKOJ1Q37QLot6UshZuseolxW5coC24BOK3n9mlMRlvXvoUIGLx+q3EI6GdId0NatKPAxVrqwqjzBanV77YdJRsn+/bHYemowTD4XmH31pikR1EdbPi9U8Kdcxz4WWW3MH3DGU7GW2Q/3wc+sNqtOEuD7eIwiKJvZAHahlY8SuSzdXG6TjatPFNtbzj0m3dc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB4989.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(39850400004)(396003)(376002)(366004)(346002)(54906003)(6916009)(316002)(36756003)(8936002)(478600001)(86362001)(6486002)(5660300002)(44832011)(2906002)(6666004)(2616005)(83380400001)(38100700002)(38350700002)(41300700001)(52116002)(6506007)(8676002)(66946007)(66476007)(4326008)(66556008)(107886003)(186003)(6512007)(26005)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8SBPAulBWsI772lhPvdGoGzlfRRhUJ/Kv+M/KCJwF8YJB/Tvh2ANadxQS49g?=
 =?us-ascii?Q?P5Yoco/XfBp54bf0DM0bNOh126+FB0N8j1BGRV3mwKo2JytNVIFsLS+dyRPd?=
 =?us-ascii?Q?RcD3JVhMwRhtdbkz1TOJ4KygVAvBv6wbGoSw9xW3gCCOE6YU85Y5yTYxG+Pr?=
 =?us-ascii?Q?3HGXLDZth3cz15NkJJl6y7ASbNrkCLbeF4hDXKT0LJuJh+b7txfzA/K64LiH?=
 =?us-ascii?Q?J43i9Joy+aLt4TyW7359NZdyu8ITRhLTjxJ+Rn9nVOS0EhFcPDRU+mw2Snsl?=
 =?us-ascii?Q?NAlg2qOTnniTLCAYwlpDEY3YWnsSc30d9+/fGorc2vG4QCYWKHdMWFEipMHJ?=
 =?us-ascii?Q?kdm4lNUfQrfxt75d6/9tettMz6U/EvH48eoZlDrEIn9JXg0AP+JrcemooUSy?=
 =?us-ascii?Q?eTCFFJf5foxIkYC+IvodWBVh+1GB0K3Wo/bMGm2UZlThkVG3OOAbQtWoVx2O?=
 =?us-ascii?Q?quJ9XUaBXz/kEI5Fs5f9rAgALosTc1iwQttj2L3PkyIDft/cgHqwjf3V8FWo?=
 =?us-ascii?Q?1StyXB3nsnECdsB4oYbfEP/thZYbDGoN+xzXaNqTdVCyY3NIuI9lR6bMPNEE?=
 =?us-ascii?Q?TI0LJFEhc4Bn9vtXKBFc9ZjuJyGUB3JJy+yX+/LyCToFgUXQPqY6btzTQO/J?=
 =?us-ascii?Q?QYQw8Sx8RiOtHtVDaMkPcbMG/0z1+xEgd8v89v7y8QieVA+uINFHwrl4UMUq?=
 =?us-ascii?Q?zYN6t68m8vEIDVZtt6Lift26b/i5yjpxGjWBlSFJyUyNrxk+Gogh1cjChcfm?=
 =?us-ascii?Q?d0gm3RXY9jtoZA3lX/2CEJtjSN5DMCF6GFKV+yfrXsl+L9c6ULTcfC4EhLNM?=
 =?us-ascii?Q?nhv/P55+rIedtzEvcqiz1QvKA5RHvm0dRl/7cloVMtcoRfw9bT2FCY/RQfoL?=
 =?us-ascii?Q?MLci1J8AiH8ErEzCPONI+hqkhZdZRCeG95OnRMOPf1YWFIOlpAw6WUfEok98?=
 =?us-ascii?Q?f1tl7Onqx3yjgm9U6cs62BRWdVNkkiil4qjBgga/Wp75beiRFCRMlLlVNPMd?=
 =?us-ascii?Q?cwrbUUtzP6VKZJJqrmwN3c2me7hgqnfQqyzCZM0lZXzu3sCYlY2K7CZFMPxG?=
 =?us-ascii?Q?gnoE3Dpf1khOE8zSnTHM47i25koH74aq5+bwlpAwbnNjtYLCikiQEU/zka9D?=
 =?us-ascii?Q?bOc0XufogdJdvyQpr/QohIN/9KTUbAh8lXYaijoTfiIF3JncjuqGM2lvT2Ii?=
 =?us-ascii?Q?L+SzmyjCq4PoThJzmSf5Q703x0tNKn3VKfMzF/1hctiuJJ2OvB2VgzaIOpkg?=
 =?us-ascii?Q?YOSwVzuCVN/Zju7QZWFUU9V7zv6a8Ibvm9dGCqx/DMq+fxFJA/ZPZgLza2/K?=
 =?us-ascii?Q?22bh30/HpsV6+grMFz8Da0OqHXeeDuXoo4LH2nZjZqWGcgzCf2dSYh4Povs4?=
 =?us-ascii?Q?jAY5JQa0oWYVhICSGoj+HgKN3j9iXh1zqXdm1G3PufuJ06QajRB/BaVSrKy5?=
 =?us-ascii?Q?Po1ZerpbHwcnwoa1JVKrguy3+22vHq5kQYGfRVGg/51K2vkwuDp1QFEhW1Ir?=
 =?us-ascii?Q?rOdeKG5Yb1BzB0TboKycdQljpSZWc2hQ20MQ4L4cCOj/VyDbRXyRUA+8eOQL?=
 =?us-ascii?Q?Fv/YtwueaKECNrs/kfU32mGcT5HMNV4i6CRTF7EA4s9H7wzB04AUEhlMKI6T?=
 =?us-ascii?Q?kA=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25ee597c-46c5-4a01-a06e-08da7b0ea23d
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB4989.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2022 20:26:41.1801
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L9TkYZhp2H8PSSn9LhrfNg1RidwCuikDTEpVyQSa9O9uw7rSXQ/3PAxf0GIntg2hgbXyuOrZevcT5XtZv+7qDle89ZB9Lx5iaiAiQAQPSO0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5217
X-Proofpoint-GUID: RpeL3O75zit2YedGVIXgJ-0m0L1Znsf0
X-Proofpoint-ORIG-GUID: RpeL3O75zit2YedGVIXgJ-0m0L1Znsf0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-10_14,2022-08-10_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 priorityscore=1501 malwarescore=0 suspectscore=0 impostorscore=0
 bulkscore=0 mlxlogscore=849 mlxscore=0 lowpriorityscore=0 spamscore=0
 phishscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
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
index 89d07312e58c..027941e3df68 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -961,6 +961,10 @@ bool kvm_irq_delivery_to_apic_fast(struct kvm *kvm, struct kvm_lapic *src,
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

