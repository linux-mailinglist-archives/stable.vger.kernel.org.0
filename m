Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC16658F384
	for <lists+stable@lfdr.de>; Wed, 10 Aug 2022 22:26:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232464AbiHJU0o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Aug 2022 16:26:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233285AbiHJU0n (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Aug 2022 16:26:43 -0400
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15CE42717E
        for <stable@vger.kernel.org>; Wed, 10 Aug 2022 13:26:43 -0700 (PDT)
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27AD10cR013918;
        Wed, 10 Aug 2022 13:26:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=PPS06212021;
 bh=9kGYydrbGnOiY+HC5Z6IC96eJ3uuho0mE+jgsYOHyGQ=;
 b=MKnebmkOWpIn7xB0nUZTYjJE3yBBhcIbMQxa356SF91A6A5GJ/UEWMHJqYAFifsZd8uC
 /+UqCE6bNc4FEoMnVLWaNIuZT4Log4nFdYQsYKajuvqNRX5+H13nzSa6OiMTsWQqv/ch
 SIowfZxEYe0tGSsO37skvQ2Bn5HqXWR6/iw2De9MNr67dHgEG2x8tYtzhxNVeZqO8Q7Z
 BGsExUOkX7Bt/PEplYKBypxkxc6h+KzX9qPzYqnu7SPrvoeVBy2OjrN3RO2hK9FZhzzF
 qteNLeWMIEIW59+cHc7VliG4Isl4huGdWbLBw1AmVq2lVuV/AxOmm5lFVWqt81AHmlnE sQ== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3huwrcgww4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Aug 2022 13:26:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=djmUMbcwn5T9m+Sz4ohwOq2lkE4uD9G9pTz6wlypbBQC1k/KMvUVehRFIA9+cI95+IHmZWAz87iWfafAWZ6YyMdsmMeAkVZYkNGLfEOiVCFStI+dnDlZU3L+k2RLNogNUcYtg8uaqb2YaHwT9Vk17pSRxFv9Y8rTSKJj1jwqFJU38W7UbhNtUjcPgT2Su6MZGADxgrUjLS7rJMH+LeRbD6y1nWkaALyTJSRY/+RMJDW1i6PB0hbY8BvT//54m5LzC8oJYctCAECun2it0CRY/ZSb9ZwUauGUCg1HLLB2WnpCUz5LP7B1bC/gF9u3bRTzTzWjNyve6NeKY1RZ9xGZ4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9kGYydrbGnOiY+HC5Z6IC96eJ3uuho0mE+jgsYOHyGQ=;
 b=PNpZLC89K9HW1kfCAitMk27uv/AUR2GAJQrdcXjNpD/5QyIlLfZEOd1fGy171LJUYDCwio/NOHMJvD8gmfMA7J2hLA+JWPYlfbg7LjArM1Kxc8zxeXxOQmXxL3zg0r9ifHYI1TJG75zT08pbl5jp9tm3KEl7lmDYHOf3wM2i313ylswEjsF0wQiJhts2CrTx3slqU0NeDsaldKzp7zoIwlcFpPbN8gpLxCyTykbPJLbOCMCKwRvIFsGSi2LVHPTeMcw9vROcdFKaZ0cOKttet+rzwnw+E/F04/tDQ1pVFVkKrUT2RWKOeXQInSNVjZXFfVL3w1m/XiUjxWX8/asS+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from SJ0PR11MB4989.namprd11.prod.outlook.com (2603:10b6:a03:2d9::22)
 by CH0PR11MB5217.namprd11.prod.outlook.com (2603:10b6:610:e0::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11; Wed, 10 Aug
 2022 20:26:39 +0000
Received: from SJ0PR11MB4989.namprd11.prod.outlook.com
 ([fe80::c1cd:e945:f9e:b71f]) by SJ0PR11MB4989.namprd11.prod.outlook.com
 ([fe80::c1cd:e945:f9e:b71f%9]) with mapi id 15.20.5504.021; Wed, 10 Aug 2022
 20:26:39 +0000
From:   Stefan Ghinea <stefan.ghinea@windriver.com>
To:     stable@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Ghinea <stefan.ghinea@windriver.com>
Subject: [PATCH 4.19 2/3] KVM: x86: Check lapic_in_kernel() before attempting to set a SynIC irq
Date:   Wed, 10 Aug 2022 23:26:23 +0300
Message-Id: <20220810202625.32529-2-stefan.ghinea@windriver.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220810202625.32529-1-stefan.ghinea@windriver.com>
References: <20220810202625.32529-1-stefan.ghinea@windriver.com>
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0001.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::6) To SJ0PR11MB4989.namprd11.prod.outlook.com
 (2603:10b6:a03:2d9::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 683a9858-54ae-439c-9c3a-08da7b0ea11a
X-MS-TrafficTypeDiagnostic: CH0PR11MB5217:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s4fgJl4fc90S4duqdSQylZLo8OZdL2YB+GuYvI1NMJxeUn/1g2reYHp8oMxPe2JqafV8bXlOSLio9gyAxdD9TsBdKA97mKIbmR0oChyXAs9gyTu9gJy79/EOXqQTg6HgYr/Rwz3QuEhFsraMbm4L0OsLAsfipWo2qxR35aNplQ87GuO2Iuk+yLDLxM2zTlXpBiKfwTUgHHRvfCNQXON0tn7iNiPFhqDw0NxdBUS2An75gS/AvnycnlCpRMh/s0Y6Uj/g/1jskPUUBhlXSw78ndlaEMWYFx/KaZ9aNmkhZZa7owwjXRg2O8/eiKXf/L+FP/5fqP/j+lqzkHHM9qAkdHqP0t8BcMdtRjwcRsavjx6X3HWHUeGfdwxKFQepFufBdm00lcerFLcCPTJKAlGYzvTrx/Yjg15O5paPMl3F2wLyeP6iwiFgwq+2gG4LJeb/bDEnGxG1EHH+6Ek9StLN3JpEtSfmReaYMKgKVWhTzfmXK/geZumLC8eHE7o8xqKxJnyfK8dBZplfJfGAiVoMHVcxwS1rWFfmXOzZhGSqQH9A4DWTky2Le4rTtcseauZPq3LXiu1wVkr5Pdn9AjjoeRlTY5GB1Y4wLW/uXqB86LgKLXOTyF0vC7bkPcuAJMhozit+W0PHT6NABCTETMArkPxMu70BPAItrP8yCcS6RAQ9nYtGVihe1iZiSmOXJODqI58r5e1slUJfDaCeWYKqpmRWZOxFrO4oiybvy62slYwmiUZOMBCNB3KX3YosYHD5oi5ZUukDgP7N42FK9YLUy7+FLAEvCk4teyp6RTGvEJ4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB4989.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(39850400004)(396003)(376002)(366004)(346002)(54906003)(6916009)(316002)(36756003)(8936002)(478600001)(86362001)(6486002)(5660300002)(44832011)(2906002)(6666004)(2616005)(83380400001)(38100700002)(38350700002)(41300700001)(52116002)(6506007)(8676002)(66946007)(66476007)(4326008)(66556008)(107886003)(186003)(6512007)(26005)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9kel7SiG2VSx/btUaLFL/bbjmyHNVUa0AqvT27qjnrSCdIdYFWOa7XwbWc4G?=
 =?us-ascii?Q?iLt278sSoZM1aEEApizjEvpB1NS9YP30mJq8EesIsKQIBC8gYUbXKKkbNhHm?=
 =?us-ascii?Q?igaVCKy9ymvTv6ywBp2Usz05V6nTKRUxSzrJTpJWcoN0uNeTSPrZIpgLcpjt?=
 =?us-ascii?Q?GffI3hhO2kBxvEsIEMoB7hxegZ1JQCljOuF8ZcFI4neQsRodoHRGlCeGsppn?=
 =?us-ascii?Q?DFpRriDY/usFylLBbJtqULDAq3GsTjNunSNIMY3ZwdNrKyXmiqLhc5R2DsNF?=
 =?us-ascii?Q?jI6W4rXGMECZQGgFgywzsOxEhtKcCPY7shPIZNXu2RP5whdIIOc6dKjJc30o?=
 =?us-ascii?Q?ASvioecC0t53gxztelHrYF/W6aIhsYv28GguY1AA6LlyJEeWEMn8s7610b4o?=
 =?us-ascii?Q?whBqaYj0zNUswpvNSZUppnRr0I3fWNTQkbpybCk+2+83WHH0KDG7zKzY0cmy?=
 =?us-ascii?Q?3iwwbhoqhDAsjMtJsk+KitMtjKNR1VkT5r79SrlcrZJgzuQiOGKtbNlc0IIv?=
 =?us-ascii?Q?eWgSdXNJbQiGlcBA18QNZOKvXlfDCUXR8f5q6ADYyVokw1/NGJxyp6txP/8G?=
 =?us-ascii?Q?0WxBT3R0ZBRYiwSyVU/YqrRCTI/2G/80JIiwELO5HWjIPU2Zaq0bgWhXVYLC?=
 =?us-ascii?Q?/EjpX4sPqoQZRM3iH0Exe4qNq/33hyqcStdW9nQzqAZghtcaCiHOPFGQdaEo?=
 =?us-ascii?Q?frWfyxkdJZbLZoB6WFg7smSX0wtAQoArDLLZ/2V5apNm8R41/WHjQK/TLcD/?=
 =?us-ascii?Q?2EILGGU2GQWWb+u2G8ZN19rv6L4tmasorYluBrWzEDAb+gnjT0dJJE71Gmhj?=
 =?us-ascii?Q?V3dI4IMEurG0ZeWSY1WtYdRYRkktCaUMqg9VX/Uz7APYnASDkRHueeMrKNln?=
 =?us-ascii?Q?r1r8K3ZMRXfXebwXw89WkOlXkvJ1X7oOBOLYH1vs3/4+QZXP4G7YLzVOxRY2?=
 =?us-ascii?Q?FJ1XfYm/SWdPCmKfciE952JKDuLqkdJQoPjgY7kybrlsSRcqAb5QlzJXnuvn?=
 =?us-ascii?Q?7FS2NWPbhZM4jiflvnKmVKZjWtbtVkvs353AY8ZWt/U9jZleTM6yZi6KO6QD?=
 =?us-ascii?Q?8PvdBEXSeyVJHg9uwBZD4bPCINDPZezvBWuEnNOwRlzLOTKVZP+desbF4IzQ?=
 =?us-ascii?Q?E02EvgJ61OLOuZ7Hn5GwFHj/VzWYruAC7ahJPUNPiLLgedZTYAmBn3ryyy7O?=
 =?us-ascii?Q?Bey7nksxjvzgFM618sPfNIvPrIMQ3kJVnAAVdaVt2vDpcJLI3/x9w/DWrr0z?=
 =?us-ascii?Q?eQa9IYS2cN8xMHJY3usa263sM7eweyBDZdeSGdEZrnF+H/TsdybdspuRHXqI?=
 =?us-ascii?Q?xaqbBg+XFcX+KWJ4x4+p+5kXLwk+6OsPWB1kBYMDRXR2YDWYLnkNgPXOJ1gs?=
 =?us-ascii?Q?yeiLQDWjwRQP5lW1mmQK+hgRzPsCxnQ3qUHjnfkmOWLztVpmAQAtIZQ7rNaW?=
 =?us-ascii?Q?5gDFP6pGOIqBu0KZ3+rjdIG4xADnMtvlMDdI1hgYnUQmYnRRZyopD6MtA0v6?=
 =?us-ascii?Q?/Lbhq/SMf9tCCgLL5Qk48/lbji0XW6PyoBz61mW+zmz+mmSmC5vZIl9K2XcJ?=
 =?us-ascii?Q?+AoccrqPfExG00OUQOVhENMh885C56ig1aec7F+42rjwynl4Jj3vkbYJW+Bz?=
 =?us-ascii?Q?7g=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 683a9858-54ae-439c-9c3a-08da7b0ea11a
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB4989.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2022 20:26:39.2417
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y/4XYbLmrNrpI+JJIZcm5+tt7AU5dMYp1uum2M3znTdpm3sRhiCKiPmCa5xZwH0+i3LR2Mq98lXMZj/hT37uwmZ+S2EOrPXqdky/Sh0c+4Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5217
X-Proofpoint-GUID: VmGgDEA4Mm9ra6qE-Wp9VCubDYm84P8n
X-Proofpoint-ORIG-GUID: VmGgDEA4Mm9ra6qE-Wp9VCubDYm84P8n
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-10_14,2022-08-10_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 clxscore=1015 impostorscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 spamscore=0 adultscore=0 mlxlogscore=825 phishscore=0 lowpriorityscore=0
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
index ca5a6c3f8c91..2047edb5ff74 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -341,6 +341,9 @@ static int synic_set_irq(struct kvm_vcpu_hv_synic *synic, u32 sint)
 	struct kvm_lapic_irq irq;
 	int ret, vector;
 
+	if (KVM_BUG_ON(!lapic_in_kernel(vcpu), vcpu->kvm))
+		return -EINVAL;
+
 	if (sint >= ARRAY_SIZE(synic->sint))
 		return -EINVAL;
 
-- 
2.37.1

