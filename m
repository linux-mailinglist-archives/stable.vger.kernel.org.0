Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 183D158F37D
	for <lists+stable@lfdr.de>; Wed, 10 Aug 2022 22:25:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233290AbiHJUZb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Aug 2022 16:25:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231533AbiHJUZa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Aug 2022 16:25:30 -0400
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C514F26ACB
        for <stable@vger.kernel.org>; Wed, 10 Aug 2022 13:25:28 -0700 (PDT)
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27AENAYU005645;
        Wed, 10 Aug 2022 13:25:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=PPS06212021;
 bh=cz0U2HtXvPgyqU4KDnG9z/dMEYIUmhDb4h2gm6S+nAs=;
 b=SY8+Z4bCLBuN1K1Ugd7umrxGMW9Y3hN6dEkVcpw+QockJiJBfgxJUEHO8lWRsTLee7Nf
 7TyF5F8DiJhl8vYbYmRM45kyfj8382oIXyEoH9LxG0lseKsquPpPUNSiATzy5P4VCJQL
 8m+D8o+YMcSRM2mFiRuKkHy8bofjawuUFdkR5Ulq8JzXmB6+6W6sbvtEktVJQZsjR1br
 TDPr13mG62vysYUUivqVGEZ14cckrIRAVH8lYJ/sXUByGqiXuiVblKCaIPc5NdSSQZ1/
 bT6oERqOrBVnFtrOLeVplQQxUVDr+9m6gJzcGJ5iHqUNksiRIiGXJzhTNevV15qW3zSm Vw== 
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2176.outbound.protection.outlook.com [104.47.56.176])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3huwr7rwyy-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Aug 2022 13:25:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F0OQJYsncApZaN9PFKSlFBWGgdRcjTqflfdhxXBzuGggst4tIWbpoX5YuEHYeqGlV2gdP3JcOk3rtcj6X3DMAQK0RW4etw635oY/MnwZx8gtBE1c5CsMPgMQ1uUk0WypMg66pIZlqMcgSPWOgp4ezXpsdirPJ9nIzhKrUSivyWgE2TxTQuqP+gVikM223muDsAOGJE/qm+/ok6vdhY0GRmGabvn7v733IE1A2r6mb+ms+RYeUsH3LURwXP/qkFXhJwEYOZH8D7WJv89TLMZdbmMFPT3GrawayuiVisWEA+M7l8bXoHTD4pUpC2cvELg/1DMloiMyrqFs4jbsHXHVTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cz0U2HtXvPgyqU4KDnG9z/dMEYIUmhDb4h2gm6S+nAs=;
 b=U3dD68W8OQOdXtPDIjfF6DvLTK0VHU3Tb3WaMzbrlx/vwsIajA3Z+3LxPsGxdl0X3I5Z/cusTMPCUtyt5TEFNVor1k5sferlwHbgQrSqL8a5u2XWb95+i3QVqnifIp3ifJLc7If9PBvCF5ex5ZWDRkHJwhma7NvHivJN3Q4d8oYLrKQc1KcBLJySAg8LW2xs1b/5sGa+vN8GmoWxNIWvrI46ZyVMh01oXYoytwGCx/P56s8FFI96YhygIzOnTjMYXm0E+AbOMW0/jmHPlTANejeMRJkIV3sA+JySowf5HRs7GdTqbEs01A7ozXnr8xFUhRVgj4cQAFsNBoNAbcE1Nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from SJ0PR11MB4989.namprd11.prod.outlook.com (2603:10b6:a03:2d9::22)
 by BY5PR11MB4339.namprd11.prod.outlook.com (2603:10b6:a03:1be::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11; Wed, 10 Aug
 2022 20:25:24 +0000
Received: from SJ0PR11MB4989.namprd11.prod.outlook.com
 ([fe80::c1cd:e945:f9e:b71f]) by SJ0PR11MB4989.namprd11.prod.outlook.com
 ([fe80::c1cd:e945:f9e:b71f%9]) with mapi id 15.20.5504.021; Wed, 10 Aug 2022
 20:25:24 +0000
From:   Stefan Ghinea <stefan.ghinea@windriver.com>
To:     stable@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Ghinea <stefan.ghinea@windriver.com>
Subject: [PATCH 5.10 2/3] KVM: x86: Check lapic_in_kernel() before attempting to set a SynIC irq
Date:   Wed, 10 Aug 2022 23:24:38 +0300
Message-Id: <20220810202439.32051-2-stefan.ghinea@windriver.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220810202439.32051-1-stefan.ghinea@windriver.com>
References: <20220810202439.32051-1-stefan.ghinea@windriver.com>
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0501CA0010.eurprd05.prod.outlook.com
 (2603:10a6:800:92::20) To SJ0PR11MB4989.namprd11.prod.outlook.com
 (2603:10b6:a03:2d9::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a4e0b2f4-6066-4d6a-2b68-08da7b0e745f
X-MS-TrafficTypeDiagnostic: BY5PR11MB4339:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8ftMEVG0LsEfkvIzPcuMpBFHXWzsb5cROtW988NgewPFYn77i0omIJ//cYJFr7tg10gIvBDG/wBl7PqLB5FUSQGgBlQ3ZvGCjVDYZx1eaBQvLX1YifDKkcT3fp+6Dr1Aol8DE+WiGxNTNe2PtKByR1ubUa6v5okzjD4WPo3gNLm7KsW8KwLo2ge4rRciUwgQef6v/9Ibyo7z1A4YuNd7iYFZ5rsZW0XVNmU+/7mmhOwowLVEzdUlKeHtHQBkyBrMptV0byq7qTsI8WZHm2Li5npgxHwvSlTRBbAIWv2YvOFANUPrr4Xq3E3WtROqLk01NZkuBoAOdnHMvi+UO0Q0zMfsM/d8dY0LtKP7oRhDYVHeSCupl2NOVhc/cCb7kTi6Oc13kITcdHoW7LWRAm3T/3SHu0vkdH4pYbM2+OQO3azDxwfNy99z+yIs7e3f01JxKk3psHksb6QCmbCPf9MKCf+5lXr2lN3f4rSpKcLbThlllO5Db22sHoZaDgd7agxA7S6ifVIzxmTumCiumVU7c2q9v912qsAxy7cGUhLpYrP6gSTDrnVnNCkYiE5IXlx1Qu/5dJlspUuN37lj/n3pJqbRyPrM5MuQ5gFC4uQdlQiOyY6fDvnNqtVUgMwjFM4EI5rTO6sZgdR2oNnccGuku2cIs1bfA1EElalHwMus3vyNqACiky7/5DF2bIMHd9SR3nY3KyfotUkAF+ysfeovlIkt+nipD5RBJBA0hKtTQNggjLTcYiOCtwJMt0cyh4WkcXBzW2NOwsY8qTYSm7VWR/w031rHUUqdcw0qshywUkU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB4989.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(366004)(346002)(39850400004)(376002)(136003)(6666004)(52116002)(38350700002)(6506007)(186003)(1076003)(107886003)(2616005)(6512007)(8936002)(5660300002)(26005)(44832011)(36756003)(6486002)(41300700001)(478600001)(38100700002)(86362001)(83380400001)(316002)(6916009)(54906003)(2906002)(66946007)(4326008)(66476007)(66556008)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SZKkWV696xf4siNCTXoNcJrsvkHZ59OZatzKm+LRAMrFZYUFgPz3a1gOBfwj?=
 =?us-ascii?Q?75HuMT0ndWq+qbpv3plYAW2GcpjOq41oUjFQJ7aJyvGNbmIOeRuq7MeoWgCB?=
 =?us-ascii?Q?uz2xYBqDpLzn0wq11x0FnFrQYnqN5X8UKDjSfRc3p1OXmIcsNAz/bx3E341E?=
 =?us-ascii?Q?qUKa0YYwu/fqYjwEr/UYAEsp2WNyi59T642xwIKBdpuKxi1oxCdDYh5UUe2s?=
 =?us-ascii?Q?eMSXpFdan6z+tpBrbZaIOJ/g5Y16M8/87frSx9tLDjPKxF0te9Qb2bXXR7dn?=
 =?us-ascii?Q?Fft7DoSuEnA31OSlvm+hy8blF5ZbPaoR2/2lBXoXuZf0NIV1IjhNDnRGJicw?=
 =?us-ascii?Q?YaZpm4pJRs5jH/EX3opAz7xp0JHlwm7GDqRh9DDoOUP27IWcL9xhuf6dwgY3?=
 =?us-ascii?Q?q7fy3S5g+JNEgWvTk53pnIsCVeiR7whZOxJ4TXFpvatRZ1Ml2C/dYlkay2Eg?=
 =?us-ascii?Q?nGQ3cUxF+FtAZ6RcBQCUzWIipD8xdSK1L/xNzHXq0basj7c6e/eXErf6CMlp?=
 =?us-ascii?Q?2AJr04okRVofzuj0F1TjOLfOFIqkTDBJnx0ItmsNg9L+EmnJ0zQR7Ckx/L9p?=
 =?us-ascii?Q?G0diJW8HaL3GlzxPkDXf+ww9CzENtruxglA46Q3T9TtwUdQuNWKAlzC9BGbw?=
 =?us-ascii?Q?AQ6mM0IbbduXwrGAwxyhd1dc8ughjsgRl5KIPrM4VW+oGPeZ++Ou0mDezIXv?=
 =?us-ascii?Q?/2vKrw/kT71ElXFGG2X4rPlC5j3De575GG+w5WdYhknjwD4BoeCr8J7vN3k2?=
 =?us-ascii?Q?DLoiKXISK+UcUqAQr81VTEyrenYs5Di9eaEGy/b3gsoi+TFvcU8bBKubvtqD?=
 =?us-ascii?Q?c4WNMGlbP9+rMch1nEjmQwEBIBtcwXcb1pkCd2xJny+9vRWDSs4uC4nNC6uW?=
 =?us-ascii?Q?sJUZ1DtA8hMInSOLvKQ186l6HWNiPZ2yg7ftlIHK/JV73NZNZrMhjqWdw7iq?=
 =?us-ascii?Q?vRzf10ABk1cjfj07Sgs4JLGNS/21krlhCTyjvnEFsByUdXbRqF5YgBbUccr8?=
 =?us-ascii?Q?TnKfZNKDhnqWIv1a/vhkoVvO0unhnsaa8rRluKMneJ2xCNfOC07XEVBHJ2Jl?=
 =?us-ascii?Q?N0L2OXo9LtuyvTzYYWFDHlBWcWsEjAveBJkfalSQemkyML69CLj1G2Tq0mK1?=
 =?us-ascii?Q?OfZNPYeAJUzf/+SpbqXAWXHugiklbdb0gVSaaxrCxhLtbt5NPHDf/D+lU1fI?=
 =?us-ascii?Q?kNc2eTGlT47jTH1IZMzUxPkNbaMDLAMhiqHbXNF7GfIvepxUCmkOTXMKWmi+?=
 =?us-ascii?Q?EEn72JtM8wu479SQ3lxaGzWDbfyXvZYuwH8CYJc6xiD5dPoJ+nXb7DzhjkEQ?=
 =?us-ascii?Q?b8C4I26CwqO/tL3/Q/ecQoaV/oezpxH9xB3E4ae7NUZZVJ/QK97yzVwxeeHR?=
 =?us-ascii?Q?J5NzW8A86KyK+cH5yG6Og8LM9H+Vd+MCPKrbFZ9C0iZgDHNtt45rw4gBAq/W?=
 =?us-ascii?Q?kSVGIthhWLJ2nZJosvDBbPVzizTHLpDJmynWm0UnjpuTU9BcJoegLZFRI4vs?=
 =?us-ascii?Q?Ytd3t7vOo89sWP2T07tFCaZtj96yg8weRdHk5HBQSgxzqMhpybRcrG7Ya1Xv?=
 =?us-ascii?Q?OSASL3uud1vjzVxFfWZy63GKkc3y2NO6FRpcRSH4YWUADHlcB7Au92JiRIQ7?=
 =?us-ascii?Q?8g=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4e0b2f4-6066-4d6a-2b68-08da7b0e745f
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB4989.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2022 20:25:24.1936
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dbdI6bhPV9K9tMKQOcrbygbXvBZVnhsugcderxGZBbdWlqfEWu9yBYnxBUW3lpPHKMjqVZki/Jqn3jwXh0artb7hRkS+fZY455s1cKuWNfo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB4339
X-Proofpoint-GUID: lAZHJLelaSrZiTQcz_QWQdIF6xRGq7jv
X-Proofpoint-ORIG-GUID: lAZHJLelaSrZiTQcz_QWQdIF6xRGq7jv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-10_14,2022-08-10_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011
 priorityscore=1501 phishscore=0 impostorscore=0 spamscore=0 suspectscore=0
 malwarescore=0 bulkscore=0 mlxscore=0 adultscore=0 mlxlogscore=825
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
index d806139377bc..09ec1cda2d68 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -428,6 +428,9 @@ static int synic_set_irq(struct kvm_vcpu_hv_synic *synic, u32 sint)
 	struct kvm_lapic_irq irq;
 	int ret, vector;
 
+	if (KVM_BUG_ON(!lapic_in_kernel(vcpu), vcpu->kvm))
+		return -EINVAL;
+
 	if (sint >= ARRAY_SIZE(synic->sint))
 		return -EINVAL;
 
-- 
2.37.1

