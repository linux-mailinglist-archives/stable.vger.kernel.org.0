Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB21B3DEF68
	for <lists+stable@lfdr.de>; Tue,  3 Aug 2021 15:56:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236138AbhHCN4Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Aug 2021 09:56:24 -0400
Received: from mx0a-0064b401.pphosted.com ([205.220.166.238]:19694 "EHLO
        mx0a-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236143AbhHCN4Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Aug 2021 09:56:24 -0400
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 173DhTCN023855;
        Tue, 3 Aug 2021 06:56:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=PPS06212021;
 bh=xhNmZfa36xZ4CKPY9plc6D8hMSBhV7bTsmAP7wKfj/M=;
 b=PyAG2R+2mMm8yuKgF/iYFTFpAS21+MTG6JU4q6MLfjGd9qn6khex/75rXtEJa9bkAo4m
 LmN153duGqA0AIZacNhyolS3UDJlfYc4j/uMWPtsLSHlK4V67F/aIh7FJyE97k3ujf9x
 KlbrdtcUvI7CSt9ocGuKsaP7qd9Jej/Z0gXO3dgZLffgko+N2TBRTpl7lLWVEGaDgl42
 TeEYGocTbF2jBiDCvrsm3m9Zirko+XCiozXrvF3VMaSMtk9V3mdK58aEy8eg2F8icvBs
 DwM5jV7P10WZ6Y2Ux8/fApnQUuNgkZ0HFQfVCF1N/O2+Bp1wZjKqxQN+MJZUw6NINy/e CQ== 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by mx0a-0064b401.pphosted.com with ESMTP id 3a753s02rk-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 03 Aug 2021 06:56:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YsHkyF3hgwD8bbAB/vPuPYnpKrXVFWjYqKOm573vxlCB/bLEs/rL+l//XbAetVCVqWQXFWbJy0j2z+w0qk16ovcK9OTfO6XJ1a/vT2Dnrt1emB5kuISzcB1T4wVuF/h9FnTosc9mcgwpdm8UDcBNeOaxaVjzGhKVVA/yLrLlmeM5ULKXGCJZjkkvuCxtXyjmEXM8M6SPQLWeaWjsLg/Dw/gimPDGfv0PZQ/D0VQ+mEfUbcORNnDiB6HPoomEBm17Ml2vsWQD9HyR2+c1g6iMvUTWo7E/9j8xjSehLOGQF5/LAmP/hJIvcREWAoOZ5fAVhkwtqrxNjbq4zgzlXBodvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xhNmZfa36xZ4CKPY9plc6D8hMSBhV7bTsmAP7wKfj/M=;
 b=VY/Z7rO2wT/9PuP/i9uDRQUTlT37lec4Eoz8k9pgL/umcaP8cwpLKR61MqDEh/t+JsiugXydLO7kd8C/wKQ80cAtcgix42Gki0mSCQsQ2a6665jpAwMGKGZE/zzEDTHC/pQZdejLPCTF6wR/XwIf1fZkhyArG0uWodLKDUqVRpJAyL9nvt9jNE3RyG3kW34zd2rjhNSBwRQzAKkx0UWSG18NbUBTKcr9vZROLyX5tmAYUQitibKDarYbnt5ybyfnK8DcVeAasnefzxqO/sDSTogWciUegmx9vCttX5AdiFsvkyh7f+nwN7j3cMV4wEQ+nlC00TlL9Scb+L3dBkeGPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM5PR11MB1497.namprd11.prod.outlook.com (2603:10b6:4:c::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4373.22; Tue, 3 Aug 2021 13:56:10 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::dce0:cf03:275:4b3c]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::dce0:cf03:275:4b3c%2]) with mapi id 15.20.4373.026; Tue, 3 Aug 2021
 13:56:10 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Cc:     pbonzini@redhat.com
Subject: [PATCH 4.14 3/3] KVM: Use kvm_pfn_t for local PFN variable in hva_to_pfn_remapped()
Date:   Tue,  3 Aug 2021 16:55:21 +0300
Message-Id: <20210803135521.2603575-3-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210803135521.2603575-1-ovidiu.panait@windriver.com>
References: <20210803135521.2603575-1-ovidiu.panait@windriver.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: VI1PR07CA0159.eurprd07.prod.outlook.com
 (2603:10a6:802:16::46) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from otp-linux03.wrs.com (46.97.150.20) by VI1PR07CA0159.eurprd07.prod.outlook.com (2603:10a6:802:16::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.6 via Frontend Transport; Tue, 3 Aug 2021 13:56:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f4160e76-e477-4f4e-b9ef-08d9568672d2
X-MS-TrafficTypeDiagnostic: DM5PR11MB1497:
X-Microsoft-Antispam-PRVS: <DM5PR11MB14975D6184A0E21437C0B503FEF09@DM5PR11MB1497.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1186;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 564JlotGlJWAqHaGtldAFwXGdgMbgr6Wk7rZ745B7be8x84SYM/Cet0tCBBlbAoq0nsLCzbtMlsY2rXwXz59ULoyRcd61J7h0iXiTyDUTQpy9HGQUWccjwY/oaCb9+vhBy/f3ZQz922vTPks1ngKO5cNerlLN0jE27I7IUgGETkFw8stxO8FFaJJHY3sCLju+q5cugP2YnY+VnzVXuwSO3G5g/KAqDJo9QoxyyjBIRHrFptmcozedzvk1vAAbYGYL53nfn82PxrhPlSjeOB5anJyloeb2gyC9cZ6On1YyKSrINysCzsOa9528FO58gzZAGLooIYB7p5OoRJaE3YOLMjtuv0nNuszlVOpiDAaJ+CXp87g5Do26hzHoHOOpMmTLk3GVfwnb7F9OZkvEqPd5Cc6Fu1laquvYC91OK5CH9V9WZmcc6yh59yiMO0l1CGZ/MAEjqbhN8EBZI9pTekk69Q3Ulih2+ORhlCiaib4FjYCfxq5L2RKe24KX6xwY4kPoRwv2zgrGUN6aCSA0+xnMcEuYjH+OitDyipEPozMYHiDz6Vl5o6/WuqGWrDW172Ju3AyIE187DylL01Cncm39KpuovJlP1dEfJ4qFdyf7C6NCKAzwLjkUEbHF/Z5STER85mVOq1ilFsuXd/Tkfm9B55mHRddMU1WVAoDMQhIT7mM3K3N7DbrfMJ8OOimXGji
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(136003)(366004)(39850400004)(346002)(38350700002)(8676002)(6486002)(2906002)(316002)(6666004)(6506007)(5660300002)(38100700002)(6916009)(186003)(26005)(1076003)(8936002)(478600001)(86362001)(83380400001)(4326008)(6512007)(2616005)(956004)(44832011)(66556008)(66946007)(52116002)(66476007)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OVhFdWRqTllTTVR4ZGgxbzZOZTVVeWRBaWw4RlNLQU9JRU5OUzM4U0lnWWRS?=
 =?utf-8?B?K0V5R2JSSzBoRWJtVFJiY3FFdFlSUHhWS0xrTldQdU9zN1BrNzgza3VoWEhw?=
 =?utf-8?B?SE04WFl3TGR1dytka0VJWUtEU2QvQUowVUwrNVJ2dWdGZ3AyYlVhaXdlY0Qx?=
 =?utf-8?B?WnNnMjRVK0JkMjl0QlZKeSszMmZNVy94Mk12bVpoWm1yQU9SYTNNdzhhcGtE?=
 =?utf-8?B?ZExJOHBYZE0way9UUytBUDE2K29RUk82WTVzdkh6dnptLzVzcUhDcmxWU3px?=
 =?utf-8?B?TktmK2d2c0dCZCsrSno2REpiZ1dqT041cXh6eWEvK21tVkhHSmZkWnRIejNT?=
 =?utf-8?B?VG1UZ2pwa0ErQy9Ed1pGWlcxK3hOaVNFRUtJaFQxQ09OeFZLWWk1VksyanBT?=
 =?utf-8?B?VTN4SXpCazYvejN5dTdFbDN0dzZwcTFyakd2QXluelJvc21HYVhTUjBoTy95?=
 =?utf-8?B?VEc0dXBIYkFtVVlaU3RObUhlaVAxUndOeUVXMGRPdUJucENsUkxmeUFQdkRx?=
 =?utf-8?B?TW92YTlUcHNYU3dpSG1tay84QW9wclgvbkVzeXJFRnBRby9KaG0rME4yRnJR?=
 =?utf-8?B?aTdZQ2pZaUR6bnhhUlk4allmTXBQNTFuYy95enB1eGxxVFYzV0ROcGhuY0Vo?=
 =?utf-8?B?RzhJZXp5OW95dDZhY3pYNXIzL01mU1M1UHc0eW14TlhxbnprUllGK1BRVEdo?=
 =?utf-8?B?NHA1blpxOHRwTUZvN1oybmVuWEdKdmpKTUQ1VURKOFhmdHRCN3hWOVR2OUVs?=
 =?utf-8?B?NU15OFdOK1k2Sk5hZU1ibmwyb0FpZ2Y0QzBNS0RlSkl4MUFFS3kwNmhHc0sz?=
 =?utf-8?B?TGRzaHBJMzZFMHN4SnloQjVQNHBvcm5UaytqTUZzV1BnaDk0WU1vUEc5eURn?=
 =?utf-8?B?WkhLUU9KZVFIaGY2WG5tNlVyMmVFajNUU0d1RW1JWjF1NXI3cXk1cVBOb2o2?=
 =?utf-8?B?cHFSVE9LZmZMcUY1VFVuZXJZRkdnMXY5b0k1K0k0dzUzc0VNcnNPWStnUHpO?=
 =?utf-8?B?Nm53by85c3N1d0kvZjE3cGFrV3d1Z2tmNUZXbXBNdHNkZDEvUFZkQW5VbXpa?=
 =?utf-8?B?YjhPbENCOU9pQWdnb0tPb1NwUmJkT21rQU82TmhiVXgxL0hmcDVnWHREakpw?=
 =?utf-8?B?Q2hYZDE2Y203dlJnYmdGdzB2VWlVeWFoOEhRbnJ4UDFmSk5sSmNRREFPMlY5?=
 =?utf-8?B?dG1ETlZXNURwb2JDeEF3dndONVFPdnFDWU1EeFJ4ZVc5ZlNobEh6UUpuL29K?=
 =?utf-8?B?OWZyM1JIcm5jYTh4Tk0xOUFsbEFZZENtaXFlS01NeFBNdFc0em1rVVowYXQz?=
 =?utf-8?B?WVBGVDBnWGFQaHRnMGFGd0JDRXFzMzMySXJjUFFxdHp2QUZWZzE2blA3a2s4?=
 =?utf-8?B?TVp3bEh2Y0R5UEowdVhBSnJTNUlJalJrWkhwMGErM2pIeVJVN01SbE83cE5m?=
 =?utf-8?B?akhwa0RXMHVWM2wyNTE3ZTE4MnZabjFRTE9hVG51aEFNRndvdWZLY0NsTFc4?=
 =?utf-8?B?NmNRb3hGZjdTVHBjTUo3aitSRE9kQSt1d2V5NDU2WEF3cC9uZVR5aHNCN0xt?=
 =?utf-8?B?Y1VtRnpSWW9YUlYzYk11SHYvK0hUQUUxb2VnZVdIWHRVM0VDTmxDdmh1VzNN?=
 =?utf-8?B?bWsyWmJGcGJoTDMvMXNMdTlmTTVqVCs2M2lTS2c5REJLZ3dUUVBOcjNHZDRl?=
 =?utf-8?B?ZXFkcjd4dGRZNExtbkRDWlN3RzVjelVqYzZXNCtHUkF5TG9tejVFdHFjRThU?=
 =?utf-8?Q?VjYuqTRmrHyuG9apK9UTHx9tcslmYelF774eHlI?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4160e76-e477-4f4e-b9ef-08d9568672d2
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2021 13:56:10.3297
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YkRJ1n5R2B3C3L2kT3gIJSlypLYlU0158DSRfO5oBycdPoIuw6Pldxl1zZvqoykZnhtmvU9lXnHZQ60YKWe9+0LROXx9LNjAjv15+GXQO18=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1497
X-Proofpoint-ORIG-GUID: Hp7pE2BKXI0uuCp1ctUiV69zg71IS4l2
X-Proofpoint-GUID: Hp7pE2BKXI0uuCp1ctUiV69zg71IS4l2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-03_03,2021-08-03_03,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 bulkscore=0
 spamscore=0 clxscore=1015 priorityscore=1501 lowpriorityscore=0
 suspectscore=0 malwarescore=0 mlxscore=0 impostorscore=0 mlxlogscore=853
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108030093
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit a9545779ee9e9e103648f6f2552e73cfe808d0f4 upstream

Use kvm_pfn_t, a.k.a. u64, for the local 'pfn' variable when retrieving
a so called "remapped" hva/pfn pair.  In theory, the hva could resolve to
a pfn in high memory on a 32-bit kernel.

This bug was inadvertantly exposed by commit bd2fae8da794 ("KVM: do not
assume PTE is writable after follow_pfn"), which added an error PFN value
to the mix, causing gcc to comlain about overflowing the unsigned long.

  arch/x86/kvm/../../../virt/kvm/kvm_main.c: In function ‘hva_to_pfn_remapped’:
  include/linux/kvm_host.h:89:30: error: conversion from ‘long long unsigned int’
                                  to ‘long unsigned int’ changes value from
                                  ‘9218868437227405314’ to ‘2’ [-Werror=overflow]
   89 | #define KVM_PFN_ERR_RO_FAULT (KVM_PFN_ERR_MASK + 2)
      |                              ^
virt/kvm/kvm_main.c:1935:9: note: in expansion of macro ‘KVM_PFN_ERR_RO_FAULT’

Cc: stable@vger.kernel.org
Fixes: add6a0cd1c5b ("KVM: MMU: try to fix up page faults before giving up")
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210208201940.1258328-1-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
---
 virt/kvm/kvm_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 469361d01116..36b9f2b29071 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1497,7 +1497,7 @@ static int hva_to_pfn_remapped(struct vm_area_struct *vma,
 			       bool write_fault, bool *writable,
 			       kvm_pfn_t *p_pfn)
 {
-	unsigned long pfn;
+	kvm_pfn_t pfn;
 	pte_t *ptep;
 	spinlock_t *ptl;
 	int r;
-- 
2.25.1

