Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A42103980BC
	for <lists+stable@lfdr.de>; Wed,  2 Jun 2021 07:45:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230055AbhFBFrO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Jun 2021 01:47:14 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:29756 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230054AbhFBFrO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Jun 2021 01:47:14 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1525ilJT027394;
        Wed, 2 Jun 2021 05:45:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=Hi5JMwbHeDil4crBVZyKyrliCAGONIPcDmTqMvb6pO4=;
 b=y98yAvke+IUUmfYxOGuub9mtc0zCls3bNrz5zHLVM2+jztQFyC1PouSs63A49fvCtCBF
 GXz58maENcbjbSii533n2dT+cTS+7nf/wSyrkQgoTZFQ8BIZMXA60qASIVKbmKfCNPcz
 oqdyN1J59smfNDh+VHB8BjA59CmHf55ONcBYioUIxv86S+EPNlm0S/skBMhhV/pfwSfR
 xmk8ffM4SwZppNXK1cbDyrFkSVAITpwIBSuzxFteYwboWJWmqXOaL5xo2fIPi533CTSy
 JCC259aWbq9hXdmxgcyJNvOTmj0G624K0UQ8cnDjyrtlNMmJ1WyuBLGtoe2gboSg/mci GA== 
Received: from oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 38wqjf07yk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Jun 2021 05:45:31 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 1525jTkY081795;
        Wed, 2 Jun 2021 05:45:29 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
        by userp3020.oracle.com with ESMTP id 38x1bck5bk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Jun 2021 05:45:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M8PjaT1s2gAnMnoxuA8k59CCgzwcacFec74jkCuVi6mJn34uExWENvZ3Qp3OSDmVy2GbFiVMkG2f/up/YioPnQ58s8jdA5CJ1u7PwnzK7MQhBxiDhPcpuciA+T5mCX85ELptkwmVgsDIWJL43b6DBWUNHOGTi90FRcvS5/xc51SM4oEmpeLCCej2WW3gcA8Xim08Bd7XH/oaiuR8lvoSz50nEOoJqQyNEcU8VngCrsKXRF1cXlwGAqa4ZnKjsCi4q4Tx8VuQbHlyZKxeQJvSttJBexpphdSFQuvQ2LWT/yi2psDs2NKGwfDb5g8ErQBTn49LJuybeg7zzNJjWnBe4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hi5JMwbHeDil4crBVZyKyrliCAGONIPcDmTqMvb6pO4=;
 b=jETy031QT3TNnvA8yaBUNzCwUy4ZgLbj7p5J0wwCnTsFVQQSHiBD80PtxR7+xpDK4DumCJQIW+prvaBXkiJClCxBFOrVD4/mdFWwBGseRBzoS80s6yDMoGnyxxHl8mhvEFsNCNSeTe3kOguPfrvmEPlttBa53Wcz4O4ChiGC4UlC2eNybkJAvRjudqiAn7VDwx33RyYIIQuZJeRk8wwhy5TihIcQBk/S/jVk4uRmzLeH9eMYclHinl3Ln+y7R9f9Xt458tILk9/spLdS5MOpW+DF4yKbWNzjOGvf6d3fDPWfRWYr7I7FHduHwF+j3PquCxyCH3rONDEkX3V7hqTqQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hi5JMwbHeDil4crBVZyKyrliCAGONIPcDmTqMvb6pO4=;
 b=DMYAugLt2N43aT0oF74FeWDiIpU0KWS1HDulXHzwH5tXbs+Qn1L2XsrkzYc2tYRWbXM7Jv59p0hsBdbodpyFSzRyzHQSCJEm9js+J2JwbQcQI/F95Ik4cInxNMgtSba4emrvnNAHTEdnH2ZLxZNQKX/wxQqlZb29BNcjO6YWwwg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5418.namprd10.prod.outlook.com (2603:10b6:510:e5::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20; Wed, 2 Jun
 2021 05:45:27 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4173.030; Wed, 2 Jun 2021
 05:45:27 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, James Smart <jsmart2021@gmail.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] lpfc: Fix failure to transmit ABTS on FC link
Date:   Wed,  2 Jun 2021 01:45:19 -0400
Message-Id: <162261189570.29465.16730659982330225074.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210528212240.11387-1-jsmart2021@gmail.com>
References: <20210528212240.11387-1-jsmart2021@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SA9PR13CA0033.namprd13.prod.outlook.com
 (2603:10b6:806:22::8) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SA9PR13CA0033.namprd13.prod.outlook.com (2603:10b6:806:22::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.11 via Frontend Transport; Wed, 2 Jun 2021 05:45:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3dbc00ab-f3c3-4088-9440-08d925899fb7
X-MS-TrafficTypeDiagnostic: PH0PR10MB5418:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB5418C0D40ED4FC603804D28A8E3D9@PH0PR10MB5418.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wuo3ls50Fx9iRnAfJR6tA5DHdE5Ik2iYuDSSLaJ4VJX0VSNfM0PawGMqMC5WISy/oczH1uPPmKUt9j3DPPYduXmsmM4fN4EhcARlKhyYmrgsK2Bt+snPyFvOnzZaWqBS+ddbbpNv/6pUGTB6V2oQTm4OR85PQ7HreXzsssKzL3ki9NeDK9ypekLl+KbqOTtPxCRbUe2zDHkxShSDJSt8le+lI19FTVVjDLA60+QYpNKT5iqqQWPyHTBfxdE7wS5pmUu2MJLH6ci/Z/BolFFdvReyyTctCqlHOjS7xXmHf5Z7ONYbj+8AzlkaVR/F+b5t5YswGfAVELc3+rxqRd5wdv1N7FzfFDC3zLUnZdu+T1mA9rISKmMMC/IFh9hp59mGMsd/ALZzZFftHQiiD6D1lAKuNA/H9gG/EPSJYR4RDKOrnc98nbVPM2xwdlFsBNz1UNKSZZzzdMbtTOyUVAhsdRox8PrNDfmi5ZzjBOx63DNfyqvdk1HG1aagwg3XfIAiwh40LXTn4zl2A2/ZcJCWe6ZABPTc1vn/YsV+iMVsLbLfMyw4gQ3sZ2GFP6nLtpbemoZV1nWJ3dowWor7+f246ImxMA0mO+NU8iEbGUS42norQTE+3jLEuCmTSBU97SSOT4MF2Jfa7u8iPq5mIWK1RpyFTugAC7p1BOZfSb150KEnOIem7xlFOWKhcynHR3CYVtIg0cbAvpWQtpGpRJ9tODjdpzk+W9zQ5Cho/oxo+FwWLcdFxwq5b8NWszEdHfZCoLZFii7sG7sWEN98j8FbLQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(396003)(366004)(346002)(39860400002)(956004)(2616005)(6916009)(8676002)(966005)(478600001)(316002)(6486002)(86362001)(6666004)(4326008)(38100700002)(38350700002)(7696005)(52116002)(186003)(103116003)(16526019)(26005)(5660300002)(2906002)(4744005)(36756003)(66476007)(66556008)(66946007)(8936002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?ejhteHQrdzVEQ29YMzg3bm5hVzh0REUrUzNtOUNITldVcFFuUHhTK21HQkc4?=
 =?utf-8?B?TndNS2oybDg1M0svWml1cnJRNDRJUGRHYy9ucEtGNzJ6TVpCWUVKVXpRRHFa?=
 =?utf-8?B?aFVRVDhQcU5jeXhsOWh5aXdMa0xMRFpPaDRzOUFQN042NXBrNStQK1YrRXZy?=
 =?utf-8?B?aWVSblM5bEk0OElwbnFOR2tCTFViczY3c1cxdzNhZlg0ZmtXTERBRFZYU3d6?=
 =?utf-8?B?blV1THA2RG9SRDduQ05ibVd6b1VKU2R1UzUvWkIxalFwYjFlellIS1V1ZnBQ?=
 =?utf-8?B?SExkZC9xV3B6NE5rYkY4YVN6cmpocEczR0R4VytobUF0TVM0SW5VWDFsUTdQ?=
 =?utf-8?B?dTZDZndXeHlsNCtkQzFPOEE4OHp4ZExIWmlteGMvRGFiKzFHemVDOGRaVGJE?=
 =?utf-8?B?V3ZsVVNDWlUrT1FHYTJjcE83NitGTzViU1lhVGF0SHZ0YkJ4WEhXRjJsS2w4?=
 =?utf-8?B?ZldqaFd2c3BXZXdPQ21wVHBHM1JjVWJjMG0vRCtBZ1RTczVZc29PNC9IUUhC?=
 =?utf-8?B?T3kwWW1FMGJNelVwMndFNHNIU0NVSkRpM015YytQRjgyQTBNd0hyak45bSsz?=
 =?utf-8?B?UUhiYnNQYWZ3UmhPemtRK0lPNTNNV0hJSjUyYjFVMHlhcExReFNZSjJsUElI?=
 =?utf-8?B?R212R1pZRFBIblQwelpYYmNhTGI5VHo2MkZ0RVlvSGZBVXBBTmw0L1YwY3pQ?=
 =?utf-8?B?NERUVHFHQ1Y5dk1XVkNDc1Z6VGhqYjJZNGlFVEhoY1pmTDNLNHdtSEVzaloz?=
 =?utf-8?B?MWJ3RnZoNnlPbnFYUXZ5b2psRjBHVVdRSFpWWUg3Qkk2dGFqSGlBaXQyZUNB?=
 =?utf-8?B?MkZpbGtKY1hBaTVhSlBxLzlxQkFidzNJTGpJSCs5TG40d1h0ckMrSUc1YWtH?=
 =?utf-8?B?RGwwSDJZNnFtYXdYc1NTOVVWVCtLRG5tVkxRNnJvcGZ6ZVhiN2pjZEN4N3J3?=
 =?utf-8?B?MTdpNXhyRE95TFEwdkk4ZVpVMklGM3YwbzV4bjYwNmxvcWc5eisvaTh0eGM1?=
 =?utf-8?B?cGlnWjVCRFFoMEJCQUxFYllmZU9qNFIxeG5EYklUWXhrQ2FOZnRYbjEzWVdw?=
 =?utf-8?B?ZzFUK3dxZ3hRYVJJRkJEa2pmUnJUdFc4aWE3M0RDTVp3aTRpWlllbkl4RlVM?=
 =?utf-8?B?MTZiQnNYVld0NWVJV3U2QUsvTEh0OGdEK25LTm5mTElIcm1MNWo0QzBTQ2N4?=
 =?utf-8?B?NCtxb2o3OGJmZzdiZG83cUZ6ZjkvWDRvd0QrUGJBWm9keWR1QitkRzdCTC9R?=
 =?utf-8?B?Y2JEQlhvZUZUT0U4T0R3QnljWndicHE1ZWlFekRia1dhZWZmOHpVQzdrWVBU?=
 =?utf-8?B?Y0wyQXpSR0UvMFkwZU5kYkk5SlY3ZzFlVDJZOWNIUUZpYWQxa1JBZlBQRG5O?=
 =?utf-8?B?SEpPdzRaWGp2TGJ0M2tEd3JLZFJOcVFtOEs2L0JsSUZtTDFadjRwOWhRWUs2?=
 =?utf-8?B?ZkZXb0Q0eU1SZUxOdnc0QzhMdnZNUXh3UFRmRnE2MW5VY3F0Y0tEbGtXTDAy?=
 =?utf-8?B?Ym8vZURCWlF3ZHNady9aU1ljM0JJVkIxM1FOZ043NER5M0RpU0FENnV3VXhX?=
 =?utf-8?B?M3FOdzdHOHp0UGFRUGltMGtUenk5TWRnbEhoZFJNaVhYTXRIejB6RTFENlFw?=
 =?utf-8?B?N3dxSVcyY0RCeDlMVnp2UkRGNGl3R0w1cTduY28wZ2pzYitJU2tjVVJ0cUdq?=
 =?utf-8?B?RkhJS2srY0llb1c2Tm1uSlQyU1ZmT21BdUdrWm51anNicXl4YjBxcDBWN2ha?=
 =?utf-8?Q?wwLU+1GKUDE/ab3aZ4gdHww/Aad8qMF0S4ftAOJ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3dbc00ab-f3c3-4088-9440-08d925899fb7
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 05:45:27.1893
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: do96thGP9z9CA5c4T54C15DvNKeq5uDWZqIvIyfR6ocujB5c5i5JlX+tPaRyC4FC/zfKCo9a1gjFb+j0YRlA2QdXhHPHeRnfQxp/gkJLjD0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5418
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10002 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=923 adultscore=0
 malwarescore=0 mlxscore=0 suspectscore=0 spamscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106020036
X-Proofpoint-ORIG-GUID: ckmrjzMGRPjPT58L05d8ScZcT7k2sNib
X-Proofpoint-GUID: ckmrjzMGRPjPT58L05d8ScZcT7k2sNib
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 28 May 2021 14:22:40 -0700, James Smart wrote:

> The abort_cmd_ia flag in an abort wqe describes whether an ABTS basic
> link service should be transmitted on the FC link or not.
> Code added in lpfc_sli4_issue_abort_iotag() set the abort_cmd_ia flag
> incorrectly, surpressing ABTS transmission.
> 
> A previous LPFC change to build an abort wqe inverted prior logic that
> determined whether an ABTS was to be issued on the FC link.
> 
> [...]

Applied to 5.13/scsi-fixes, thanks!

[1/1] lpfc: Fix failure to transmit ABTS on FC link
      https://git.kernel.org/mkp/scsi/c/696770e72f2b

-- 
Martin K. Petersen	Oracle Linux Engineering
