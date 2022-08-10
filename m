Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB8AF58F37E
	for <lists+stable@lfdr.de>; Wed, 10 Aug 2022 22:25:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231533AbiHJUZc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Aug 2022 16:25:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233285AbiHJUZb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Aug 2022 16:25:31 -0400
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F74426AF3
        for <stable@vger.kernel.org>; Wed, 10 Aug 2022 13:25:30 -0700 (PDT)
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27AGK4hV000830;
        Wed, 10 Aug 2022 20:25:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=PPS06212021;
 bh=ZRg4Svj9p9hkGoVG7GOa1LVkkawbeQ91AR3To+SvO7k=;
 b=M9wiyWDBBpaT3v2agkcLJ7iUEeG1/Ev6dq0XP4xRAb3MHPgDxCeFYDSX9hc9/htQiKUd
 9OEGrRJXU1CPMQNYk4f5TVECntx2uushBXTft/eX8QGJYs3F/aQdPLr6L63nldVdtl5a
 Fl7bZfMtAPTs7P6AxNJqg55wfofPPvv4pqcmyTh+4Xghoda5OhjrxrRHirFLDI8JAyUd
 tlhx/RV8TmVLo/pRl/uPkvHijUAJ+uZO7V9bg+mjncOC/2F61OKYJd+qrj6BHGF10kt5
 /MQx/Bl6i38QK2/CiL/JcCCvs67sbabkicjoHIfnMfYmLNSnZfJvCHB9V/rXqNLeaNps wQ== 
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2173.outbound.protection.outlook.com [104.47.56.173])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3huwr50wcq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Aug 2022 20:25:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cfZfIeQYdBKoM3yxCojxCXX1KjIAsml+fSFybPEa8NeqA/YZVifaPoaAOakZZyV7bePryMaoHOI7zv+VQ8PGlNkIG1lw04m9rsd+I3eDYNRWzgWQl37rnn+XTCskuFD7paWWXWDyA+96RCUZ02VHSZ/oN2rCgWBJUDRWElklSZr3dliODJ7gLuPwQAivvb55Z5s0aQfLKjwyuNlu2sbJ6Ld0njiiU4GuyLcGlmWAcoVUb5kLZuqi27KoVyhHXQZ323MW6lLNQqnHTU+1Sh1SPZ43dK93enpiBMkgRXyMsULi9ctshhDQZTDrZWF/OQTd0uqy0xN5+Erwd/wPTClCFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZRg4Svj9p9hkGoVG7GOa1LVkkawbeQ91AR3To+SvO7k=;
 b=XBr3pPY5bIq829HKm4iFfxPOe/ia0viGfa5M5nh4nhuDrd2P27NwGp5jZ+Kb66JyFsiPRPBdOeZcaRCPU1S2HY+1jeYq0Jh0eV4vsipuy6fO+WTHBDrPNAINtNoDUCO4YZlm8PauzyyutWVQufsgGbXZi2APlaZt7opNyzKkfaULT2TJjL4KGEsKtvhiN7idxGVt3fAl0Ju0t12VcGz/9EHapPSRv2ZX7YO21CzYqO+0Nzal2F9jBcB0mX+akiQ+6QpschOa94piDLBMCk52JfOf6fg0MNmTjQuDuo423fnQso+YHC/1u4S7fTS2XoNB+7pPqbgRTuxqx/YyPecC6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from SJ0PR11MB4989.namprd11.prod.outlook.com (2603:10b6:a03:2d9::22)
 by BY5PR11MB4339.namprd11.prod.outlook.com (2603:10b6:a03:1be::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11; Wed, 10 Aug
 2022 20:25:26 +0000
Received: from SJ0PR11MB4989.namprd11.prod.outlook.com
 ([fe80::c1cd:e945:f9e:b71f]) by SJ0PR11MB4989.namprd11.prod.outlook.com
 ([fe80::c1cd:e945:f9e:b71f%9]) with mapi id 15.20.5504.021; Wed, 10 Aug 2022
 20:25:26 +0000
From:   Stefan Ghinea <stefan.ghinea@windriver.com>
To:     stable@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Ghinea <stefan.ghinea@windriver.com>
Subject: [PATCH 5.10 3/3] KVM: x86: Avoid theoretical NULL pointer dereference in kvm_irq_delivery_to_apic_fast()
Date:   Wed, 10 Aug 2022 23:24:39 +0300
Message-Id: <20220810202439.32051-3-stefan.ghinea@windriver.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220810202439.32051-1-stefan.ghinea@windriver.com>
References: <20220810202439.32051-1-stefan.ghinea@windriver.com>
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0501CA0010.eurprd05.prod.outlook.com
 (2603:10a6:800:92::20) To SJ0PR11MB4989.namprd11.prod.outlook.com
 (2603:10b6:a03:2d9::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 44c4b0e7-b6aa-46db-057e-08da7b0e7582
X-MS-TrafficTypeDiagnostic: BY5PR11MB4339:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dlRwqCq8mQcFjLBTMkSexx4+miyKgRtGNhV3lekpITAM4d9zFcXw3lD9JQiD6r1Qhfvd7il7v54ZWqcWSrOV1Bux9/Uv2GNp16Yy4TGHXayeVrz92Xg+Z1QLwtKr7LODCmPlZgkTyg3tG/RWENxdlYIPJYMAkBfI3GV3JnQ832wxQWTgODEYlzUjR9l3ZKLA/vaD0vSP0Xg3Bu+Ylof6YQJKk3sEZQmZiV7kzZCOR9E0GPiAFXrww7QBFeG2yOH1GnicFXEV4hUEWl8vb7Z33z37AqSMv6YxRvN8K2hGuLryy8KwzsQwEp4IcY1Ljk7FOoX6L3RG+e71Gj/La1Zq4pVwIWBCJcR5EsBZQrZwZOe4HK0C3PINWvd5YIDOfbisc7WaHIV40Vjg7EfmRO8nunC9oOdPTY45E8YgfeCSjV+V3XYZWqYfNCCIuZ1s+HI9iDY7KAlBgkRuhcL+BvqgBkezPfZqNQBUaGoTCTH0YDDr1y6TNU8JDnyxTjiBTXAKXeFOowmJwYc+32+PR8r37klj2SrfZEBxNTct21ZvvJE3O78juhj81MnbcWpZGgIqpm4GzrPXZgV96S33yI0UtcQirsR1LWM82mBkUDwQdWNqLX39XVPC8ipKjTpVM/2nW7HKPiSADGEsLEQSCzzUlsy+LtH0iTTUBQDspa0Mquu7fo7adNJB/8o9EJSCseVgf+aVsSfOL5M0NVnSdbEtkcXbgj9p4l7fcyVkKAVR7a5/BPjdHstmUfIw/SrCcwUdMJ2xaOEsarZYJ2FZyLoHHia4QarGzi5BOEeRkIaEocM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB4989.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(366004)(346002)(39850400004)(376002)(136003)(6666004)(52116002)(38350700002)(6506007)(186003)(1076003)(107886003)(2616005)(6512007)(8936002)(5660300002)(26005)(44832011)(36756003)(6486002)(41300700001)(478600001)(38100700002)(86362001)(83380400001)(316002)(6916009)(54906003)(2906002)(66946007)(4326008)(66476007)(66556008)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vbfDwvD85ldsKaE/Gs926rmqq4UUDqqFdyupPY0ZJ/zSXocWJyXUnNMS+DRS?=
 =?us-ascii?Q?kkKV5/AqUDOiao67dhKH5RfE8YJqFjrDRe9bOSNkS8lv6Vs8rPLVFBZ5DPnV?=
 =?us-ascii?Q?N+P+OgdDf9BtKd3qGQ1EtZ6y6YMGyajt7xnEu4GX2rvV/033IpiI+4Sl5wNU?=
 =?us-ascii?Q?YyhWTKDX8z34lv59qO+9y9nm99eSlFXBcziigpIaEm+fgDpkYfi8XjkDqEPB?=
 =?us-ascii?Q?D7sZlPMUHL6kWI5AkhnrTGegrOIbSpcOkk8OKC6Jhsgisp1zZDGgX/Up7Tde?=
 =?us-ascii?Q?zczA3+bWyRLZXn5mTOvFlbSndRbie1RB2iJXUEk1SsSeLqB2RxqHnkQ+bDiP?=
 =?us-ascii?Q?tSzYIqXzxZK2i5nUuSkESOf6KOCEMNkZgVGtIcH0Sh8sJ9nggHhD0FOmccEi?=
 =?us-ascii?Q?47NXGcRpMsIRHQj7MOLt0e8tdRn+ee5oxY1wUfzXKVHKBUI2sJ6ONi73t7fD?=
 =?us-ascii?Q?tOIbyGMgE1n1AG1OF9kS5v10D26m3W4CbyN3TEdLJqq0XG8xWq4DAq0ZUl4O?=
 =?us-ascii?Q?X28ZkTLnk5hiWlaoEKjITluZbB7C+XbJczvloZ73QYWaDaIjfjfmeyee6JUI?=
 =?us-ascii?Q?u9SRQsNkiySrOFQCjH8SMzSTnNSc+N0xgGaD5KKkTAVvf7lvaW0DVuMU7eBu?=
 =?us-ascii?Q?Sinjokwaj5uZd+QyYnP/WERuYB69b6rK44t78Z1owbPF/PuRaJaIOzECc0dI?=
 =?us-ascii?Q?reTDCqaA6nqWHtbmk01ZtpRSvfjm8NAgle8cg+wMAvrCuDdwKYZnhEJtoeYg?=
 =?us-ascii?Q?cyhzF3bvUW1zd7z7pC9E5HAiF9IBE2s1C3nEfRTqvpDDRHluYDG1cRt/u6pR?=
 =?us-ascii?Q?rEkYriUeUUwav7bZUwdhqt6dgRAHYZ2aCjl80Ktf8pF9gOcuXlT5coRox5b/?=
 =?us-ascii?Q?j0RkA/t9ytoUf1JXEciHs6GncH79ZS+IX20XVcEoG8YJZInMGgW9sps76BoN?=
 =?us-ascii?Q?+WWUjf/53tqJMY+gZIp+9/FrWD+1fu7gckUI1mYlQKKAl1af1xqle+JWpAKC?=
 =?us-ascii?Q?XBL5mRgYFYIwlUMIIkwfOIoyTPXdq1bajaGdv+4ogouiBYIxuGTYMm8iRIxq?=
 =?us-ascii?Q?pd/JqhMMTJ1G9RwpkdbqH8/+CY/gf0tGMxVgiTau8H9f/avMaKrUTFYhsV3B?=
 =?us-ascii?Q?XbfofsbAg4IVEYU+0uMfZTpUsSYHbAjrD9upo4MemDAu1EOQ+aqDkxZB5VlL?=
 =?us-ascii?Q?2EMaL20fCg5ciUaIeHCuO+03uvL2ug7tVG2IMOce2DjrMaYL3VnACfVXc10B?=
 =?us-ascii?Q?53Uc0v8GU38Xo9cHTy7wfNaa0pq6IBHe/FTnuOmCNu+br/12nV1X+ZMtTbZ6?=
 =?us-ascii?Q?zhuQea2+PwaPb3Hmbpvq7fj0x60wGF++xPhJzec3DYyrJlT4KBt5Jasw8TrT?=
 =?us-ascii?Q?SkEcHhhQAdUIi9nRF5PZOr4VAanAcwrQI5o3TbwSxiX4bYV/rYTP4uGH4b3e?=
 =?us-ascii?Q?gyJZisZ22Mp0+fLBrSUdGWs8it5riX4FenvR0UV88WoHAmK3/xscOTPZF5BD?=
 =?us-ascii?Q?NhAMj8H3B6MOgfgUAnwui1qqCgHQqNZHtZJ1rfhOEEJMn38qYoOFBEOPI0WT?=
 =?us-ascii?Q?u2C4/uTpyQ09hawITGb/eAG+NVrfEEw/JVn8ySBWW+HVaY08isNFRs76v8VU?=
 =?us-ascii?Q?Xw=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44c4b0e7-b6aa-46db-057e-08da7b0e7582
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB4989.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2022 20:25:26.0841
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ACL6nKXIOzeIWkJbszwMgS2etOFCl0/QzcLyyFPvxPFSvHvtnhTDdch1fpLIeee8ctE4VXOw74gbbB+HoIx48Irw5cdGfyhY0BNV1Q4+9TU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB4339
X-Proofpoint-ORIG-GUID: vMcHuqdtVY3zX3PsR6KB12FooarhRWW_
X-Proofpoint-GUID: vMcHuqdtVY3zX3PsR6KB12FooarhRWW_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-10_14,2022-08-10_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 clxscore=1015
 priorityscore=1501 lowpriorityscore=0 spamscore=0 malwarescore=0
 mlxlogscore=849 mlxscore=0 impostorscore=0 suspectscore=0 adultscore=0
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
index 6ed6b090be94..260727eaa6b9 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -991,6 +991,10 @@ bool kvm_irq_delivery_to_apic_fast(struct kvm *kvm, struct kvm_lapic *src,
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

