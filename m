Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CB5C43FEC0
	for <lists+stable@lfdr.de>; Fri, 29 Oct 2021 16:54:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229893AbhJ2O5M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Oct 2021 10:57:12 -0400
Received: from mx0a-0064b401.pphosted.com ([205.220.166.238]:44110 "EHLO
        mx0a-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229501AbhJ2O5M (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Oct 2021 10:57:12 -0400
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19TE7Yvi004274
        for <stable@vger.kernel.org>; Fri, 29 Oct 2021 07:54:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=PPS06212021;
 bh=WdtFEyxwlM/fra019hyyB7TGg8fMouNVJxWFy9oBAiY=;
 b=rM+uBEW8FbGrn9POWbLkVWp3HltHHOfm7D3RyHA/V1+xptk+KtPp+hZZz2bKM5td9NIY
 /Z43posA2ZvM1qu+tTW2A11wDfGJUfOBTfoZGnmC7MTYAHL90C+mseNKewNrj8cuMUQn
 yeRHVfAAz33ywUb1lxMK/m9XcSNzcC2t+vYAKxfIbC6uPlo0QPEkQhhtCQQFwPQu9IMS
 9ETUtrlp9Zf1zgIkWXwuV/PJ2BizL64USHuWBYGRdkt1fFBKnZA2HoOy3xaBpDSr+AGe
 kSk9DDTk6OwZ627RaAj1PBjP1jzE0BeatpKccvW0SQiDpPobmheuFJWBwYz9GGyL6CaW /A== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by mx0a-0064b401.pphosted.com with ESMTP id 3c0jekr128-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Fri, 29 Oct 2021 07:54:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BxpnqECsqChTSEDWgw3uaKqvCk8XUJ0ad0Upvnw1cXyBM43lIwPs6gSXoWHuxSmyE9RMjuVjlszWi82D64D/4SlJ4oa62ZjvrCh2dJ/eJkco4180qYf+7fB39ESR+YcSb2ZGmpFuoMJng2/02jytunwUSzL9E1LCbQWQuV9PwR4i7vBtt4/h3BM1IG0aILAssZF5Zyp4rn/bvCeJD+mYIdgPdS11/VoxEYp6VTR+QNocEiFjHEnwIgyxdMbkrlQOjwGDmTG+FDKMRFxGe0X/WAPFoQLCBHlt6YCg6eDagMgCppiVp1L5CO8WjiKfmgNKxFwmrqruCLVSiFaZOEPbsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WdtFEyxwlM/fra019hyyB7TGg8fMouNVJxWFy9oBAiY=;
 b=ZRGXaXhYFLUmM1480GvScoU7+IvN0TjkHL511oQtgr3UDNydCOV6z4/tTwE0VKktEJbtVNqatSwIrc2p0vpyhqWm7PpZQjM4J8pozg0myc0eKi1lwJSN0kL8tDEF4P+NCLxfo0OrwBbR1/fLxdlM/zvZBYYE5jz0IRA2MJ+yNThk9aJXiMIeCa0DgJl5CBpvTyRa60NJMsi4SKaVJl1qtUnuyxFpVsdRBan/1Ay62YR2A+NI38T6DbVM2tG7KqNR+JAZZw9It0BVAskIur+uuNVnFnkmb/2zNjsmO7kfX1TDwz2QSTS9j2VGtwzcSDRYJhweopiBGMW6aqcUwkDOEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from DM4PR11MB5327.namprd11.prod.outlook.com (2603:10b6:5:392::22)
 by DM6PR11MB2618.namprd11.prod.outlook.com (2603:10b6:5:c0::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15; Fri, 29 Oct
 2021 14:54:40 +0000
Received: from DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::6daa:43c4:6ef3:a6d3]) by DM4PR11MB5327.namprd11.prod.outlook.com
 ([fe80::6daa:43c4:6ef3:a6d3%3]) with mapi id 15.20.4649.015; Fri, 29 Oct 2021
 14:54:40 +0000
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
Subject: [PATCH 4.14 0/1] ipv4: backport fix for CVE-2021-20322
Date:   Fri, 29 Oct 2021 17:54:17 +0300
Message-Id: <20211029145418.1888144-1-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0302CA0008.eurprd03.prod.outlook.com
 (2603:10a6:800:e9::18) To DM4PR11MB5327.namprd11.prod.outlook.com
 (2603:10b6:5:392::22)
MIME-Version: 1.0
Received: from otp-linux03.wrs.com (46.97.150.20) by VI1PR0302CA0008.eurprd03.prod.outlook.com (2603:10a6:800:e9::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15 via Frontend Transport; Fri, 29 Oct 2021 14:54:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e26c2e5b-8998-4f8b-1bb4-08d99aec0908
X-MS-TrafficTypeDiagnostic: DM6PR11MB2618:
X-Microsoft-Antispam-PRVS: <DM6PR11MB2618E8CAB6A2BD2EFFFD7B7CFE879@DM6PR11MB2618.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:862;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Bof+QtHHjCrFukmfL93ax+jOXgWwfuGDnEwGpPODjdSnCEYRGnhvPhvcw6qY8b+/x7c7Im4O2kA7DhOg1E4AfYoQbUdug5w4rtKdXdGzekRQID1b4QCrMqPxER3V7LYrWjytnLLG4uFzXPa8CMPZSZjxjr+HbPjxo/hREIgSI5nUcmcG/vrHMA2zAQRXa17+BBxyRk20C68bQo1bbjvSUHFZNfiWV9DotrgKEa7Mwt22iSREanLHlgSOsizjf59OJ342i8QshqFaocrifunxhuZjijidrwztRHdDRgiFhDFagzq0PzyK3uqc2SIsyK5s6U2RtVZ7gPtwFIm8ArTgmb2jvJaQIMEzh+hjys8tMkwtpayk1xGGXYGKDp6G7IRiPpSgSL6TlCx7tmTEpV7K+hOhmFGu0mhF0na0wSihMd4h3xu6d5nO2JezukKmdeZKkGAx0RVod3DKWbUjyc4sEVQKbzLijgdUM6XWJ5D4394CnyTOOaPDbjGheAgXj5HhScfDKtNTV85G2zMv5FNSdisgvH72NPHYD97qBcBwhUpp71zyee97DEkhWJrkWvLK6pnewJCaD8sp0VoWllYBMi9h7qIFolSXbRghRAqEsKHRP4b+um+lrh9G5K61Muxn+Jks9Zu6r/egN2F2Tn6B1ALBJnX1v62pcMghy88Ph1IqKgPKXuW9mCTIVsFXYpCGV43cS2PtpsXHIrv2nqNA+XLCo6itvf0mnn7OlpSyFafGic3wvTj77pFLrHM6H9e6+huNFJkksH4VKWBhFQyZLLLJghvs8VOw08U5iV52NwmXIxm/dgjetXqhLctqVfgT5Q8a8lmcWNdL33AFTZhqnQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5327.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(508600001)(66946007)(2616005)(66476007)(66556008)(2906002)(956004)(6486002)(5660300002)(316002)(6666004)(6512007)(1076003)(8676002)(44832011)(38100700002)(6916009)(36756003)(8936002)(83380400001)(966005)(86362001)(6506007)(26005)(186003)(38350700002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BjH7qRDpSkI0xTRPFdrpGLQ2VjH57wDLDKLacz7CqcmlsDhfjM8ZmEom7J/m?=
 =?us-ascii?Q?Ek70TB6uQOwQL2cJ04VtJTSR6dWOmxJSWnKLNoNCvVp5civXSBKNYCQiDn3J?=
 =?us-ascii?Q?rVxGVK7LkpqUD1tTzYkL7IGx1KCIwXOCl5yJHl+T9jwy9j0bg01T9mesXeRH?=
 =?us-ascii?Q?D2ScKdDaEIomNL9R6nHjnGKuhunOG4dd73OhtfSVwEjLxIMKzVClqUf65vyp?=
 =?us-ascii?Q?EAiyAYD3ec1hv7xvQTDXt2GbEwT9rqNoCaW5JcsaRLMGYxy8fCimEJ0TnbKR?=
 =?us-ascii?Q?uUz5sU1e8DpwhILJIjLRyLhLShNHgJcBPICjTHawSHQn7IW0/ZUeOYk3v8QK?=
 =?us-ascii?Q?ClPfQ90ODZov/OoKR5hThA/aVj2WQ/MMApyJQmTt3UCNTYAWH0Kaao0hDqxG?=
 =?us-ascii?Q?ffCYC6PFXQ7lt2yAOzeP9rJ67kTHr14hpOc+ugCxoZnw8Jbi+VRyeaAlA4sd?=
 =?us-ascii?Q?lHm3hvjN3ue465V6EwiAyDeZcVzsfB13s8f2KBy3Jpeu9E5mjTdGib0aNcrO?=
 =?us-ascii?Q?KYw/FZERDI7BtMLZ8iDwgIxkofzHJp8THyccqvjUnUOosvtJB5KbwSTAYWIR?=
 =?us-ascii?Q?7KAcMcMWNSiithQDOWy4LAumh/5n6X9BzedJO3KByz9v44MVivhzkA9lrgFE?=
 =?us-ascii?Q?4i5XUThrmO3vH38R2dAXQgRwktY2mUjXSLvM2ucZX4CGfvFKnwGdxrJ7y9R4?=
 =?us-ascii?Q?MWzx9MHCf20u0gJIP5bcp1CZdc5e36MrBFxCgN12TfZvFVHC3Y17bWlm4tyL?=
 =?us-ascii?Q?pJBk8PHgOXeVBPrI5kGSYKmAqTiZZCbbL+3F3592wL8MlXIm0314EkSY6LKI?=
 =?us-ascii?Q?dkfPfFWvTlwpLahoDAlJcpd1qjjnhbt+UnbvORxrEOhbWilTOUSCyuPi8P2g?=
 =?us-ascii?Q?0BBEWTdfFQn9IpF7ihP6e6eS2aGEUyUzkbEbiyrRJAEvUoDiftOScVYOPm9R?=
 =?us-ascii?Q?Femv9zzdCAEmiFdCFAxJAKxjBWYWgRQvnh/ICu58q4hh3T4R67NxzLmS1SPK?=
 =?us-ascii?Q?F6tmWOdX1gipvi0XCEmFe0YTOOX5vubh2QG2dyJ7P6JzgxUiqjkstr7m0Ka5?=
 =?us-ascii?Q?f8wNcaZaEfi4flrW7Wi+sVHyV0AIeN7ZMm0u9mKyB/uybzBwpZzWniT3dHZV?=
 =?us-ascii?Q?DKa81Zg7EMSD+zEP4Ovp/4sHFy+6SFzv+L9Erw/Yqzj7AZofxCrvFGbik8Wq?=
 =?us-ascii?Q?aBuWadKymeXBaY1ou0nT1UyM8u9VBfhKDYfOFbep8fwmAmr9H4ymwQIHBS2F?=
 =?us-ascii?Q?MR5SP0ioDlzxNUZuHdbYTEtSJr39Ce89RDQsXBk6FP83pXrAQymlaajtHh7W?=
 =?us-ascii?Q?m7iQPVfzvA0dOGRSfV9jYbHpNL8hOvxt8zXeNZJyxrHV8xdLpbr0v2Y+pK9F?=
 =?us-ascii?Q?jBeO19ZhXIv7NwgJcXBtIgzlD7YLjQnRZIsUhMKTW3bXbsx2J6p85l/V1tW8?=
 =?us-ascii?Q?CeY1TZUhh45uen7QeVhHmwy9YA1XNjI+aiE/oKS7m1Jom8HSy4qLwwJ4aSmO?=
 =?us-ascii?Q?hjVUw4Ssjgo+M+fokN92xDiBM+u+gAROZBRyrF4P1Bs8m2azok+JSVxc5XvV?=
 =?us-ascii?Q?FlPMIjYAm3HQi3P+l2EShfoJzdCSF904GiUsmj4eOj9oKqhpkC2HlJRRA61Y?=
 =?us-ascii?Q?ogxfjA5a+EyACQ7QUnWOhrTqz6jjso1OuYENd8erBkyDqZOE8IUiCLv0qORv?=
 =?us-ascii?Q?+W55aw=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e26c2e5b-8998-4f8b-1bb4-08d99aec0908
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5327.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2021 14:54:40.7257
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oVBol+IvQ6pPVxJu9Kz+8TFlkYVLUcUQJlOdVjw5yEAEOYrJ4yy+EePXQO8HO7SQM6nGiJJFYYAB/9Z3cnK085GXHZ1KZuYDUqaINQO3DFc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB2618
X-Proofpoint-ORIG-GUID: 8yYkJmshmtZf9dtakj3Ze6Lb0Nq6uztL
X-Proofpoint-GUID: 8yYkJmshmtZf9dtakj3Ze6Lb0Nq6uztL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-29_03,2021-10-29_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 priorityscore=1501 clxscore=1015 mlxlogscore=442 bulkscore=0 spamscore=0
 suspectscore=0 malwarescore=0 phishscore=0 mlxscore=0 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2110290085
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commits are needed to fix CVE-2021-20322:
ipv4:
[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=6457378fe796815c973f631a1904e147d6ee33b1
[2] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=67d6d681e15b578c1725bad8ad079e05d1c48a8e

ipv6:
[3] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=4785305c05b25a242e5314cc821f54ade4c18810
[4] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=a00df2caffed3883c341d5685f830434312e4a43

* Commit [2] is already present in 4.14 stable.
* Commits [3] and [4] are not needed in 4.14, as there is no exception hash
  table implementation for ipv6 (it was introduced in 4.15 by commit
  35732d01fe31 ("ipv6: introduce a hash table to store dst cache")).
* Therefore, backport only commit [1] with minor context adjustments.

Eric Dumazet (1):
  ipv4: use siphash instead of Jenkins in fnhe_hashfun()

 net/ipv4/route.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

-- 
2.25.1

