Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A5BD58F380
	for <lists+stable@lfdr.de>; Wed, 10 Aug 2022 22:26:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233294AbiHJU0P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Aug 2022 16:26:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233285AbiHJU0O (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Aug 2022 16:26:14 -0400
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B05027165
        for <stable@vger.kernel.org>; Wed, 10 Aug 2022 13:26:13 -0700 (PDT)
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27AKLWOi022584;
        Wed, 10 Aug 2022 20:26:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=PPS06212021;
 bh=9EizvLHuVTECo91bkB+gY243A+1Bt/tkFC5fp6Nb8p0=;
 b=LEcvTA8/3viGox+Ru3Cc7mG4QUhWiq0trpXQ56B3SM5Inc17rS4WmJ8YPTLlMe4MzKnl
 Zjl4HbjGY2jpojrqW9s7kS56C3MChBqeT3w1XXe1pNeeHEfeKlGBP2eV/bCqSX7p4H2l
 RpmaYNe7b3R+BnchpxFI+5IlP7Mr2Y2PhTLZ9D5hATfHG9cnecvRW6tbV68Z1iEcUh7x
 nYEv2yC+G3bAWhTOkewbJLzmb3dlzNJgVRMzYvPD7tuzrSeCck89G3Gw5ern5pQ7OFCT
 qEkhaiFvoo3BJy8M6HaCPn4px7YS615VEHotSjGY2wbWYW0utMhhyU9KhRyS8jpgeAW+ BQ== 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3huwrd0wgx-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Aug 2022 20:26:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MEg4Vqvc1m/vVw+1PSHPCWspnth6z73bPRnSTGiM2Qx2lZweMx2M+GsF/r4+W5VwpNhWbKlzIkuvtSQu+0wxH77qzldog6gqljnqcP2razLZsyfZWRsIen6hU4dhqOtQ+jLhbCG8xBuJ8g/u0nWZBdfQTUN4EPSbnb/nnmsyj3ozHAq3kEOLPawpo5CzFUbd8qcsRI7d3bVdMadAgoR6XAlu8krYy6tsTK9Euhi1HLFCr3Ik3uc/ONvK0MpCZ2cBnkXcWhSM1tDwPTU6VsUq/X/N4wdTCN/ehoNMh5sHRjmQzTwDc3Mqfq/kt6SbJSYjo2HOGv3uoFDDMnZIws5EHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9EizvLHuVTECo91bkB+gY243A+1Bt/tkFC5fp6Nb8p0=;
 b=Tzy+aCE/b4NHyW7eq/NPobY8NNA05AHG47/iJn7FlNyPVftHLEa7SHuA7F58nDA/cSQaWBKTqK/j8sDnEWDoVqerbYT4lWnhAtI79xfCkzBWBT2pmB/y3K6OIZFffLoTbXAf/pQW3YLgAwoK5HVztjFJRLFTnoZBlsMisL9wCWu+WzGSCABMkOdnHE+Yi9s0MtrYyHMskSzj417WSNAhGfDetPA5a8eTaZlGjcreIZwDtMNIFEOfibeOFrT3nLpaLWQp9QAitZ/os1ZY9N/pTe5LX75YwV87hCNDMwanmD1wbH7C6VeRW2dMWBtDy2gPeKzp3sL3V1OmOAUnkDHkMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from SJ0PR11MB4989.namprd11.prod.outlook.com (2603:10b6:a03:2d9::22)
 by BYAPR11MB2920.namprd11.prod.outlook.com (2603:10b6:a03:82::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.18; Wed, 10 Aug
 2022 20:26:09 +0000
Received: from SJ0PR11MB4989.namprd11.prod.outlook.com
 ([fe80::c1cd:e945:f9e:b71f]) by SJ0PR11MB4989.namprd11.prod.outlook.com
 ([fe80::c1cd:e945:f9e:b71f%9]) with mapi id 15.20.5504.021; Wed, 10 Aug 2022
 20:26:09 +0000
From:   Stefan Ghinea <stefan.ghinea@windriver.com>
To:     stable@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Ghinea <stefan.ghinea@windriver.com>
Subject: [PATCH 5.4 2/3] KVM: x86: Check lapic_in_kernel() before attempting to set a SynIC irq
Date:   Wed, 10 Aug 2022 23:25:51 +0300
Message-Id: <20220810202552.32242-2-stefan.ghinea@windriver.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220810202552.32242-1-stefan.ghinea@windriver.com>
References: <20220810202552.32242-1-stefan.ghinea@windriver.com>
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0701CA0035.eurprd07.prod.outlook.com
 (2603:10a6:800:90::21) To SJ0PR11MB4989.namprd11.prod.outlook.com
 (2603:10b6:a03:2d9::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a75a9d99-99c5-4fe7-18be-08da7b0e8f4a
X-MS-TrafficTypeDiagnostic: BYAPR11MB2920:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vnZ5qXW0Ahcrp/BYyQtp2twlNwW99BAxbYDh+2kO5FRQJTvsDx0j1aa7WZj8yccVhPL25s/U6hBeN6pqg2mzXk77ptPNGxlHxlYxyfP5dBQc8iHmiPF6ogMizotwkdUlvl6SjxLisX6/7PBVVO7B4O/7HrabhEQYuOI3dGdwiVtUZNImkjT1lMWOCdbeg2UCd3noOzaKp6sLlRLvxcgx8J7y1mW0lONPPahul0b4qjMMwX0vsdj0rYFZC4ZLU2neoJ5bLXwhKYNTe/XfHMQwrcrgUFaKLSJusY21ooRCv+DUrZIrJoulIkUH33+rD8UetqVhW6n7ADiiD1hiT9FVpowXl/XpjG8bNV5Lsq4F4v8YrzVMy1N94G26uSYh9NR1WJCCQLxe2pmwEu7hOOXKC058Z9z6k3n5XvAsQ4BEme46cfevc3jO/uDKwExBUHD8uKLINTg3jw44jeWOEJvx0rgWojpjSiWUVyd/tlk5CHMhB7c2Q9all7HwaK/DEUDbsBm4Ax/xwDuQOQJd0vWzxSBfFWrBSuU1K6rSo4RjkPDiE1DvGtDkB9/UAU3Rp+c/TbRVfHX+jRvD4XnM3Ley7zhz6plWJt7RfHG3cdREmriitdaa7rBeR3p5WpOA7ZFUnxP+JryTFjWcxVPlWBSKD2CDParplMBn9YJc/hW+Ihov/x8uL/MrVBp/u9/WlbZ2k2Eg9hr/0E3GTXApKQeTwLAtg8BN/jPP6VYh7og2UZQenxUH1Fcgt4FVvL7j10++BjbBT3o/mAAvMMfQ3pnjm2HlOJZYZAiMAkjUAkco0AU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB4989.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(136003)(396003)(376002)(366004)(39850400004)(6486002)(107886003)(478600001)(86362001)(1076003)(186003)(6916009)(6512007)(26005)(52116002)(83380400001)(6506007)(41300700001)(2616005)(6666004)(2906002)(5660300002)(66476007)(66946007)(38350700002)(66556008)(38100700002)(8936002)(316002)(8676002)(44832011)(54906003)(4326008)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?essiTJoz/VxKodur80/6AaHIPTUDYsvdjsznBkhUmvG4+FWzJ0/71aspYdCq?=
 =?us-ascii?Q?jt+KMofyR34pVafkOfqVDPI7KrdO95mG5+86JcxFYashGMY1vNsUM8Z0KRSx?=
 =?us-ascii?Q?r0P90A9upL7gChQmyBhUswLjUTiF/UR3yJ2ePaawmqeJc3XpbIlUFTrPpTjk?=
 =?us-ascii?Q?bynUVady4vtTJstzuSZLdlUyjgKS4fMf7ro6hvXcc9I7ooskMBzarNur1Tiq?=
 =?us-ascii?Q?3MYx1UzDBdTG31S8rdzW28+WasTrwuFP4smKerKPQj8ngm20yUMhQIO1OvRQ?=
 =?us-ascii?Q?xe9fUXhtT9pXKNieFpbTwHH/tVgRm8gLoREIGTXTIFXFBi3Ye2/74SPew8LM?=
 =?us-ascii?Q?mz783Bn4DyO75olb4k/SG+Z0klQ+MXOmqbutW/KvrQVTAW4JnK2K7QEhJUjz?=
 =?us-ascii?Q?NnnBwDvqSW+tsc9BwbL6rGIr9MwCghuNmkt6CdYWUs4xBjUDoApysrTqnBie?=
 =?us-ascii?Q?8Bh9pg+MpjYy1jCWFqMxtnmLJrdFc1el/PpsvMOv/R/XMaT706UK9vLFmYCF?=
 =?us-ascii?Q?Ptl+aUTeUoQl97Yjss9ZugizmIwsu2ub2xl1QFvlbdn14PtmANIri0HTmxQq?=
 =?us-ascii?Q?Zf1usmEBn7QmI1Dlr3P65oje6nUS0iO+LUX35C3PwhSea+BNzab9bBYRuqfc?=
 =?us-ascii?Q?S9PldY2wHSBKuKuDeJT46bennwilzmUxy+lVWMBUchfjKpdfxIcGRAhVrFaA?=
 =?us-ascii?Q?8aHLrugWc1J9dW6y5gemvnnvpz6sbJ0JYQOxtKiSqbFKHFblAa2Kx9EscWT7?=
 =?us-ascii?Q?Y4c7DfQVDQtZKU5xGgPpNkXmKia6uVY1Ydp2vWYrVih1aWDhLFjjEUQcbYMs?=
 =?us-ascii?Q?rJdnKF3Pop3+glad8CJUdPOnmVD7IhkVZQS4MM9sK7FM8e1aOYwu7SKIIb/0?=
 =?us-ascii?Q?mF1MEIUm0lwAzVrvFEsmqvfPGOZr61dJkjmA+H3MGrVTGLYuH4RgZ4ObTVN3?=
 =?us-ascii?Q?3giAJaK74Mxcmya9+DaATPgeKd/WIWMtJq44NYPNxGgmLel9LmG1S3X9XNfr?=
 =?us-ascii?Q?Zbeiy1glhLnkC/KmW11yh9Vgcgbhb7Gh9AoASduBhTUX0ypF0wVuEzpPdM/L?=
 =?us-ascii?Q?z3tqrVS45D0q3qnaijIyh/HcynSibrQhxoB3Z/OZG1kEc4ofdzoAUwPvk15c?=
 =?us-ascii?Q?KqLsy0ogCzPzhaDO6L3iK+B5O/BgYAndZZIYz2mt8ZPN7Q+KGR4jQl7ZYPRd?=
 =?us-ascii?Q?MvNguO0a1DWS4lK638QWiW+pcsI5C6NdZ60TaXGBouUzRwMiTEfzqwJqZ97u?=
 =?us-ascii?Q?ijfoRKh9+7MrxOoi3daF4wmGaLGxIS4OupyTw02gy84vr+5W71wfeshFISAd?=
 =?us-ascii?Q?a9jSWgZYEL6/TS7NNkpX3qR2qS6wVP0bJU6go4KaquDXFCoPGTStRicOphX0?=
 =?us-ascii?Q?TCxx7XT9Fhm+e8JkvirfXzvLN/Lyop4aVKKl96G8bWDvsX/egkSGFLjsx54/?=
 =?us-ascii?Q?85Hua+fnQl51kmb79fyO7/OMpC/gHDM5QViOMa3/Kar6/D9SRQcueB2ksAby?=
 =?us-ascii?Q?NdADKIpqpq611krSqwt/oaiHANTUy06PSmZRxGkR5aHq5JG7wusob2eFOqd8?=
 =?us-ascii?Q?HEtl4qSiXUZuYlLSqdoTNsEx0k1lPSmKOU6iCPCrlTt3/UZBvj2j7JBa/9xL?=
 =?us-ascii?Q?Kg=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a75a9d99-99c5-4fe7-18be-08da7b0e8f4a
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB4989.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2022 20:26:09.3383
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y7P19PAmWfYfPEKO5jpD+V5oyhsfU2uZlR/G1gQt9/pxnZTuZw6Tz8/H08qevVVdp5fDUXalJuTxOZIhl+WsYC9AVPGUt518KmRf1uCi2z8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2920
X-Proofpoint-GUID: ZKyEwWmdBkA0mgWbUVjS650ZqpV9O2kH
X-Proofpoint-ORIG-GUID: ZKyEwWmdBkA0mgWbUVjS650ZqpV9O2kH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-10_14,2022-08-10_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 priorityscore=1501 malwarescore=0 suspectscore=0 impostorscore=0
 bulkscore=0 mlxlogscore=825 mlxscore=0 lowpriorityscore=0 spamscore=0
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
index ca66459a2e89..f9603df799bf 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -309,6 +309,9 @@ static int synic_set_irq(struct kvm_vcpu_hv_synic *synic, u32 sint)
 	struct kvm_lapic_irq irq;
 	int ret, vector;
 
+	if (KVM_BUG_ON(!lapic_in_kernel(vcpu), vcpu->kvm))
+		return -EINVAL;
+
 	if (sint >= ARRAY_SIZE(synic->sint))
 		return -EINVAL;
 
-- 
2.37.1

