Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 128353A8FAA
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 05:49:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231245AbhFPDvd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 23:51:33 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:61532 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231196AbhFPDvc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Jun 2021 23:51:32 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15G3lIho018299;
        Wed, 16 Jun 2021 03:49:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=X4iwyc2RCfiO3D1KC0MQWLhFooJf5yvUvbz83t0ujDo=;
 b=O/AdEHHWfU7nOEKB8/59L4cKfF5rLlkw4bZfsUyN/vu76ei2aFecdu3MhD4U6aMdFJZY
 Mx5nXeGpyO/J/xmpm0E8qqbOtnIK6f5y6W0qWJB80wKxjmfLgJHqhBVPSQWP+YKve3WT
 w+228JpvvMNX16d9NZKA/mBTMV6aOlQ/2h1U2KXR1HVM+Glk9HnJeIO8lVOg2fJeSKgd
 7MAvY4eSW4sCQGqpYSnBp38xMeaujo4wJsgHfClE3EJzkPW7VJDDHWqwKk2ggOuGDRy4
 DSXO9BuUjePj7PbjKVRzBcu/4RSQ1ywA0OF6pwrY4xcBwIdJC+9n+FEcBzdHoa/WB7L2 ow== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 395y1ksuby-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Jun 2021 03:49:25 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15G3j1Ft033989;
        Wed, 16 Jun 2021 03:49:24 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
        by aserp3020.oracle.com with ESMTP id 396was6yqy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Jun 2021 03:49:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BMo8T8iwBRrEvjO+sL5UeH7r9+zR2P1K8tgIncpwjeoGSMBSxqrFRAM4MpAHEw67n3xx0flsqv8Pt4nwCnxEh7FOO8IQip9F2XHY75OYvjT84dZ6Y3dT9Y6nK91GLPq5ppApdwxufqKhBYgJab5NlukMkU+ptrmkhufrYb+ToncNN+h3/4VXO/NdqcDxFccKzjznzbCiB282of9T7wdCldJPWthF4QGWh2eERBnD63JdiGwN2OsX0znPGWlQ8qg8REtbu1WtVSTir8sAJjkttPNYS6pvP9wKQh4f8MP63HKRNHZ1tKDPDyKcIF4CTAH6YgAOz359FTaoNCPsk+B3hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X4iwyc2RCfiO3D1KC0MQWLhFooJf5yvUvbz83t0ujDo=;
 b=LlVKtMi3eyeiXnQBEmsVdioPIVJi6WNJ34caQfch6LpHi4JtLx+OZO52xz0aQtMVPj+9WO1PHSDfF+aOsZjZCZZiyMSAnq60njRfT5bQCo5aLax3zLnAyNpjfrzVcigpoX6SNeFOkd+E5HI+jh8GsfNjzlIX/UMyJrBfohom8/TpokvP7E5RFLli5/cYr7p7+g4nXoaJ3iov+4fFiPzQ4gQssG+YUCs1pSWv1XpANhbjjIYDPD9iEfH2mAhWiSsQoEkSXbQ6XHsBa3wA4Gkhq7uYxFT1tXzwu+YvtigJQ7wYUlQIy8S7PeaifTPYgmktt9i0sbf+XKK9SxlrAg6DYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X4iwyc2RCfiO3D1KC0MQWLhFooJf5yvUvbz83t0ujDo=;
 b=wuYo+SNeozdE/w4UjIuPnAjLXnCU+iRCtjnEZIHN2gihUXFlnBV5MAPRAZC1e7GL8tamRJQJ5fAskKvgUmg5U5TH8XrUgr3D24n9ih3H5nlIxOFoCoHZ8GHQuK0bv+Y0Ll2HEoMka/HiyRygAPCFdVYQEKlqYkDdDUr+jfl743Q=
Authentication-Results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4663.namprd10.prod.outlook.com (2603:10b6:510:34::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.25; Wed, 16 Jun
 2021 03:49:23 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4242.016; Wed, 16 Jun 2021
 03:49:23 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Javed Hasan <jhasan@marvell.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com,
        stable@vger.kernel.org
Subject: Re: [PATCH V2 0/2] scsi: FDMI Fixes
Date:   Tue, 15 Jun 2021 23:48:58 -0400
Message-Id: <162381524897.11966.7183044885456759980.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210603101404.7841-1-jhasan@marvell.com>
References: <20210603101404.7841-1-jhasan@marvell.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SJ0PR03CA0268.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::33) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SJ0PR03CA0268.namprd03.prod.outlook.com (2603:10b6:a03:3a0::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.15 via Frontend Transport; Wed, 16 Jun 2021 03:49:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f42a4988-6ec3-4916-72eb-08d93079bab5
X-MS-TrafficTypeDiagnostic: PH0PR10MB4663:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB466334CC75A623192FB5F0668E0F9@PH0PR10MB4663.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: u74B7eIrhugaivg7WrdeEJj1ANysZLTuuP0JlM3f/2qDpjtr/H+Oba1fzBkWjMh8PZRWHHjweWFumyJzmi9TfVRL/BXQU1OWl0h3qakLPbknA1YXXxEllYT18FJQLFexXqJVT6pTGYPg9mVlheLIsZGlCVfaHx7uh08BjU3CW0Ai9HtgBM8XzIcQLysWT5hDdQhwFs/75Fdb0p62YlMP2v1B9ZjBKxE8gj/R7jzf67OFPU2qj0nhW02GEeJqaKTsioQYDxGzQ6eQSpztTSgyn8Raxlx3c/gpp9efRAphLngK7b8eUGXO0ReX892CcesJqZSNh8kONx7pqXpHesaOtqmhoRALMfAB/eSZxmgSQiI0FdM+tvVs4ZGYlsWZmRFTfyuqj0pAfrNhPNcBAj4mcbxkcgaEhxkD4v5BxOhobi/kphM8Dx8OeNpXiuIZOKSkQricSjSmw7hrD7l/EQTrEDM8R+xoeBmfZl7Jeutz9/9HmK5TUiRg6pLyusqcRUqpbo/cusSQxVCQYHVfU0dgDYkpigJZluzw2zVV9mFCouKZFwahT37abOQ/RB8B7/F4e2clXr6axYAXX1iJB+B8CCCNQiVvjG7EYyj+bxWRVdnB9zF4KtQakDdTckjewCdgXWnw5czET+lkJVa5CKxr2fxw4xtE95nr4mMRj7V0s52a75qlht5ezFvxEOc6PRwFcIkKQj5mnhoUU3DQfW6w85IFrTgtWbYl0fJCaGqZsAX2rdPGWbF0n/qbwTmf6rpra6R9yihuDgdv6rojk4pmcps3lbxE88G3ZKDd+ty+q7NboHCtqKFsyhl4I1JntIio
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(346002)(396003)(366004)(136003)(4744005)(66556008)(8676002)(4326008)(26005)(66946007)(2906002)(16526019)(186003)(478600001)(66476007)(6666004)(6916009)(5660300002)(8936002)(966005)(316002)(956004)(2616005)(7696005)(38350700002)(6486002)(36756003)(52116002)(103116003)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OHFCNm5CV2RCTkJ0QlhORzFpZUk3amlMTW9Ydmd2R3RiRlNldjJ4bGwrN3Zu?=
 =?utf-8?B?eGRhQlVCbHA3MzRXUzBUSUlQZmNTUTdJb2c1MXpRcmNFMDVHei85dkpjY2hK?=
 =?utf-8?B?dVl5b3QvcEp5V0hPSDYrd1Zaa0JqZW4vTGgxQjJRYjc3blVWZi8zL0FQWWFG?=
 =?utf-8?B?NWt0YW9ZOHZ6TzdtOWYzT0xyRmhUdk9aaWhSTGhxQWM5ZWloN3R1bzZXMDdz?=
 =?utf-8?B?MG1oVVllZVp2TDZqcVV5SDhITU9DVW5xOThsSk9IN1kweEZSR3ExQ1VuUEw4?=
 =?utf-8?B?ekVsVko5UnFKUWRyOHZjaEJ6aGQxR0xQbEdGVDFYdE5lcTJ5M0ZJdFhVTmtv?=
 =?utf-8?B?OG5wRlRqZWppR3VaWllzY1VxMUdCYVhOa25vbVEvTkxOdHViY3RQVk1vQXlu?=
 =?utf-8?B?RFpLZ212a0ZDMFZDR0RIaWw3bU9GYzM1ZFE1SDZyVFp6MGpML1JNc0ErRTRB?=
 =?utf-8?B?QlBuQ2tXa0dNSE5PYXh4WTVzSm0rUEx0QThnY1RLM05mdCs4bld1RCtUbERR?=
 =?utf-8?B?dUQrZ3N6ODZQY3lIeWVmSHpUY216NEh6L3JhM2J1L0xhekU0Sk1qTlA4bldM?=
 =?utf-8?B?YVNtUHRyWC8wMEVOaEVEcEt2eEcwYzVEdUxaY0pmcGg1cHJkaXNYWklyRFdh?=
 =?utf-8?B?MmhXMUVFZnNWdlRBY3FEb1R1THVhQjM0bVJDSkRZM0xvK3VPLzNYNFFXcTVI?=
 =?utf-8?B?bjdSaHEvam5adDJDaUo2SUs2VUVKekNLVVY0cXE0aXBsdTJ5M04vSlMvM1FQ?=
 =?utf-8?B?V05HWVZ5MTltNXlqNlN5OHhua01NUXhvUWVDNiswZVpucWdEZUpIZVI0bWhV?=
 =?utf-8?B?UHNYWVFjcGxSU1J4cldkeHJ1TTJ5SitCVGIvZFUyQis3MUtvbndIY05uWjRU?=
 =?utf-8?B?UDJONDNHQ1FIdDdrVXpiaWtuS3dBdnB1QmZQNVBiamIrNnVxMlBqYmQrNmR4?=
 =?utf-8?B?cFRSYkNYNGpvWnZKODFCL0tOUEJDalFsQ1dpWWVKRVM2V0lqcVFNaUV6T0sv?=
 =?utf-8?B?SWFobDNDamVtNU52dzY5cnVabWc2UFhvN1pJU0ppc3lmR1J3Z0JMcHNkUk9J?=
 =?utf-8?B?cGwrQTBMR0VZVXdxOEZSRE1OLzBuM3dFYTFJVlREbTNITEcza2s0QVlwTzZB?=
 =?utf-8?B?OGZDWVVJd2EwWC9XbW5xSHJkQmVUQUdDODVJakhqOWFSL0tTS3NEQUs3UTRy?=
 =?utf-8?B?amxaajl6cW85eXl2NGc1WVVZK3loemUxL2RtWkMrcDF5a1h6U0d6NWJKY3ds?=
 =?utf-8?B?Vmo0b3ZGSEhNWVhkUE9haXp0V1o1QitqcGw3dXRZUW9tdGM4aFBRWEdGbzJF?=
 =?utf-8?B?QzM5bWFmRllpb3EyLzZrL1ZWcG9uOTNSampmb3JySHBZOEIzZHZVYW1MT09s?=
 =?utf-8?B?d1FsVFJLbTB3eWJGY3ZYM0E4VnZBdTdpOGs1cithMlYyUUMxamJLcDllL2xR?=
 =?utf-8?B?Z01HQlpBejF2MVozVnBtaVZ3NXNMdVduek13dGhVMjZaQW5tMzJ4dUd6TnM2?=
 =?utf-8?B?eEpzM3BYRWU1MERxRUpoYjFIaHVoTmpCKzVLOGRaR1U2dnA1cGVhT3Uvelo0?=
 =?utf-8?B?L0VReVFGZXk5ZW1ldmUzd2hWbVNoQWlreUJaK0NkV1Bwdi9Za01iSUJHV1A3?=
 =?utf-8?B?eEViRVl5cTFrMjJMRURuYmV6VFdQT1RwVHkwWWZTTmk4QVZEQ25uNFBPZjJW?=
 =?utf-8?B?M21NRlQ5MFdzWlBGQ2RVclJCVi9KOHNvQmVMRVZ3TzgxKy9vS1hubmNlNWhh?=
 =?utf-8?Q?6HaZZtG5nrPUVBN9OVAMy8C5/RtcGJPYThKASVk?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f42a4988-6ec3-4916-72eb-08d93079bab5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2021 03:49:23.3754
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nC4LiCfdA27LoSbtjyZo8tryZz5mIWXHmZYx9AFEvqRLAJQNCxSBE6agFNtPz9QfufhUAbojq3usyPXehO4xKAilNALqlT5rCb8yMo3q6Po=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4663
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10016 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 malwarescore=0 phishscore=0 spamscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=995 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106160022
X-Proofpoint-ORIG-GUID: hVaFkG5x3m83aYXe_h-06bucV_v6VPhA
X-Proofpoint-GUID: hVaFkG5x3m83aYXe_h-06bucV_v6VPhA
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 3 Jun 2021 03:14:02 -0700, Javed Hasan wrote:

> This series has two fixes for FDMI.
> Attributes length corrected for RHBA.
> Fixed the wrong condition check in fc_ct_ms_fill_attr().
> 
> Kindly apply this series to scsi-queue at your earliest convenience.
> 
> Javed Hasan (2):
>   scsi: fc: Corrected RHBA attributes length
>   libfc: Corrected the condition check and invalid argument passed
> 
> [...]

Applied to 5.14/scsi-queue, thanks!

[1/2] scsi: fc: Corrected RHBA attributes length
      https://git.kernel.org/mkp/scsi/c/40445fd2c9fa
[2/2] libfc: Corrected the condition check and invalid argument passed
      https://git.kernel.org/mkp/scsi/c/8f70328c068f

-- 
Martin K. Petersen	Oracle Linux Engineering
