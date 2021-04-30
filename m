Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 973A73700D2
	for <lists+stable@lfdr.de>; Fri, 30 Apr 2021 20:55:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230475AbhD3S4a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Apr 2021 14:56:30 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:50050 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229954AbhD3S4a (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Apr 2021 14:56:30 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13UIsCn3066229;
        Fri, 30 Apr 2021 18:55:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : from :
 subject : message-id : date : content-type : content-transfer-encoding :
 mime-version; s=corp-2020-01-29;
 bh=SYm1ezGmrwWBk06PIydNh50hLKIa4jD7HaMD93QTNNE=;
 b=qe9YxacAgTOn+XCT3c9IYjY+swOGEuQmz9LaYqIt51+Y7La2fIH+AIfzEwRndgIuo4dd
 xSctc+wE+2VFuCbzd7a4zWYL7DzojMsdgmWdZHYhUz7Oz2nqivG8QIOnaN7ETaftDDbh
 kJUULmetxQlH1Zklp9QQYJ5uKXxayajLrvkbG8dsqPqgjVBuTxoHJpT6oPfzb0XjNK4Y
 u3yS3PEQBMvdN0e8xpD5vZbm9B2DKb0vmKdKtGxU6G/WYD5BpZQTzyBvMCg2XP2CkGDp
 kM9jfMpdy66Uop4Tyne9GP15VAy3FjItxz5sTn6U4/a/sOsnX77hGNcIQkMbCEL6zIbR XQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 385aeq8nhq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Apr 2021 18:55:29 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13UIsxlM077598;
        Fri, 30 Apr 2021 18:55:29 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2057.outbound.protection.outlook.com [104.47.36.57])
        by userp3030.oracle.com with ESMTP id 3848f2v9ga-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Apr 2021 18:55:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dxQn0CayI8C1gThpzuO3AlL4c+A465+SuSZ+RLUCZ4qHdSKb19Po0YyNBjrKNUzNBKfvAptOV5cxxP9vgbwjsf+TpGkkxuLzggIdH6pE5w0MUA+fctQf/Jz0vF3kmUuv+egg3voqDCAS5pSwDI+YTb3XgcaRzquZHVWyoA1s/vCKgUqAobaNwqV1dOrtJQmvWrHONGG0yLtM4mlnC+Oxgi6T7StHIPdEbf3Xbj6H3QCrwLGflEX1VzLA5te+Ft4F4JoOFdB1lJgqZBqHZ6dPk7ACHt8AwTrCRTN83EIL32beyT47ik1a3YMe13rqHDSxYX6gpuikSO9Op8im6d/hrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SYm1ezGmrwWBk06PIydNh50hLKIa4jD7HaMD93QTNNE=;
 b=guCt7WsweUmfDtP7ZD6XsPE67YTuOeW773Pdy1V8ffIGVevxYHS6KqNGKWh60lk7AXRwzsFrRjj2oVFl01MJtCjkGTtj1WPbk4dvoqCl3J4nqqpAU3jEADQaGEgEDNEQ0rAmA8c5RdUqNZwO7XSmmRibtjhav03j/SeItHJXTxuOVYtVVpk6U9St7VFGnG0BQMUYeuQ/0VcFSw9rjhnpkmDir3neUV8SFRPffDjdXsJkt+hypKSnNzHJB+OwwHriuSRjo67v7imwrqp7fRdFXATxpMGPgaFZXwueljOmN/w4yUBbaqKcC0KaZFA29YghS7iigElwr+Cr5JlHDamVFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SYm1ezGmrwWBk06PIydNh50hLKIa4jD7HaMD93QTNNE=;
 b=ubXWxbP03FETNr1A+O5eArLQYWFk87++cTvAKoR9NRjhok5Y+sPwYSG8MBq+qk/0qU0WwSR83vHwxw/nnLOgU0y1KPtLFLPg+Ypy1ZzyMcLlhywZb+Z09v3uCC0lLb3MU7GvSWsjn/C8TqDyJQ22LLoH2EDKM1bvGC9h4OYxZ48=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from DM6PR10MB3851.namprd10.prod.outlook.com (2603:10b6:5:1fb::17)
 by DM6PR10MB4156.namprd10.prod.outlook.com (2603:10b6:5:217::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.26; Fri, 30 Apr
 2021 18:55:27 +0000
Received: from DM6PR10MB3851.namprd10.prod.outlook.com
 ([fe80::e490:f9ff:f8f3:c1e6]) by DM6PR10MB3851.namprd10.prod.outlook.com
 ([fe80::e490:f9ff:f8f3:c1e6%7]) with mapi id 15.20.4087.035; Fri, 30 Apr 2021
 18:55:27 +0000
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Dhaval Giani <dhaval.giani@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        stable@vger.kernel.org, "Rafael J. Wysocki" <rafael@kernel.org>,
        Linux ACPI <linux-acpi@vger.kernel.org>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86 Maintainers <x86@kernel.org>
From:   George Kennedy <george.kennedy@oracle.com>
Subject: 5.4.y, 4.14.y, 4.19.y [PATCH] ACPI: tables: x86: Reserve memory
 occupied by ACPI tables
Organization: Oracle Corporation
Message-ID: <18b4a9fc-800b-975b-8f6c-89d2b06dffb6@oracle.com>
Date:   Fri, 30 Apr 2021 14:55:23 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [108.26.147.230]
X-ClientProxiedBy: SN4PR0501CA0053.namprd05.prod.outlook.com
 (2603:10b6:803:41::30) To DM6PR10MB3851.namprd10.prod.outlook.com
 (2603:10b6:5:1fb::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.228] (108.26.147.230) by SN4PR0501CA0053.namprd05.prod.outlook.com (2603:10b6:803:41::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.8 via Frontend Transport; Fri, 30 Apr 2021 18:55:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 41dc3988-1c02-49ac-e2b4-08d90c098497
X-MS-TrafficTypeDiagnostic: DM6PR10MB4156:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR10MB41566B5674040FAEC27599EEE65E9@DM6PR10MB4156.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2657;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E0hu+usQc97nTom0IRwcjVkiqvGcJnQVZYLwoohy6b7Ffy5rNLR9/rrwGE8ZoqOk+sI2+KFSTFsUTO33J7tUVKuTgl3rZwI5ucM4kW4gsrgVqKHJVIsRPV1VnTiLXoWBNHXOXC599uNYteHE4qr13KGngugO8tG2cA2W54BOVkOcrfko7nc7SIoXgPn5BcNmFZuXgdCByfqMdvJKD5AK8k2vvbp39L5A0rhubAZ7Vwh5oxXZb73bAeDdo4cd6kX704nx4GyTsv8zua26EnUkOJFk4qk0hX+4gjN6HbexMAmW8DvJRi9dDmHZFYdMerBF+oAtqwPfhNq2SMvsCI84Jk7zNLVAaMDzsfQ/psWqB3wbyyH7caITI5Uw6ZRcm6TXQPuBgXuTcIBFaGiT670EGL0E+qPpbNapCXcbGpnFcUicVDmD5RLWVqfonTkc7qoqPOpB4KLyDIqPvCQeL+kHVxJPhqmhfKuEz53zbA0RPfJHyWaqadzoHQ5gaa126d67RW0qmd3hlOVurLkBYUYSALV3hC82ie1Ey1RBvlwFtLUV7ddyiPSComEpsdTFNHvCR+DhV5oFPv0FjvqiXQ6JoPzdrVffmE3re6NO6InilfYnkBjjUO4hgEcKohHLLP86c62D+xP8iNS2VCGen45zJgkwa+vXd97emvX1g2webISxsZ+tt4PJRebySK5P04da9LwqJm/Z5F+HVPV4f27yHq9qRLf6zimwKagIuByk+yslrwo2xxin5m0fjko0jC92
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB3851.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(366004)(396003)(39860400002)(346002)(44832011)(316002)(36756003)(2616005)(4326008)(186003)(16526019)(956004)(66946007)(8676002)(66556008)(26005)(6486002)(2906002)(16576012)(38100700002)(31686004)(6916009)(478600001)(66476007)(86362001)(31696002)(966005)(36916002)(83380400001)(8936002)(5660300002)(54906003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Q0h6UEphbXBXU0U3NUR3L0pJMnBjelFsQUMwSFBjQzdseGFYa0VCMXhGZnhV?=
 =?utf-8?B?MlU1K0liQWNEVVF3d1kreVJHaTh4dFNrNURXYU1PeXcvajdTRlRLVzM2YnhY?=
 =?utf-8?B?ODVvRCtKY2hDOHlxU2syZmZ1WHc1QVlGK0xMYWxlVUs3dk5pMnhUUVVHbVVW?=
 =?utf-8?B?b0VCUHlWTHBoUEdYS0dTVlA1SGlnRW5FcHluTnp6QkpyOG95VFAvVWZZS1N3?=
 =?utf-8?B?WmJXSDFxY1MwQno0a2VOdTRXR3pscWZIQm9rVHNubGVqM3ZNZTgxV0FaSEZy?=
 =?utf-8?B?OVNSbmRKRGx1ZlBFaFZ2TUkrQUVqQVMvR3RTSXlLSlJUaUZ2ZHhTODEvbkhU?=
 =?utf-8?B?WEJRaExnNUYwNWRiUUxVTmZ0YWNqNzIrTVN3Z3BmRmIxV0pJOWhwMHZCYXdY?=
 =?utf-8?B?SzZiK0szQmhqZVZEKzU5VDN3ZmQ0VDlna2FQKzd6b2JZYWVPYVBmWjhQUm5C?=
 =?utf-8?B?bzdZNWRVUUdsNEhYbzFCWkVaVnlOdS90UVZjZkNWYnJ4QStaeWUzOHFPM0hB?=
 =?utf-8?B?ejQrUWhtRGZlOFI3RWVORlNDdXZjNWxhcCtWSUtYVEM3MitQVmhLRXJiVlBj?=
 =?utf-8?B?ZDI5NEZqcFZQQVF0Wk5EUlRPTVEvNnk4UXdCWGJVOVNpNnU1K0t0V2tZUktK?=
 =?utf-8?B?MEVEYWRsWGZsU0pjeThmTjAxcVZiMjNlRDdZZ25lbnBkdWkvMGRsN2YxQ3py?=
 =?utf-8?B?VXNOLzJjcnVTdVo2bWJFVkY5Q25iTXNreG54SXI3cnJHaW5XdmZkWTFmQTRU?=
 =?utf-8?B?TGFDcmxPZStoZ2crWWExcDNtWjB0cFhwcFlQV0EzQk1NYXZNdG0ramt0ckFZ?=
 =?utf-8?B?Y3lmZEVKUDdzWGNpcXU4NWdrN1cvRkxIU3kwY05rVUdGQ3VNakh1WUtlbWZM?=
 =?utf-8?B?S1p4cFhVRTJkV1I1Y1VObytLUndHNDhXOFowQ0loMURPMUVNK3JzL3l4MzYz?=
 =?utf-8?B?bC9oREdRSEhpbGpKblRsR0RPRkVxVVJQYXhDZlRMNmxBcDZQQXkzTkVhYk1Q?=
 =?utf-8?B?OHpBaXlNZ0U2bEp6Q2ZHM2NpSEF0M0E0djAwQ2I3WmdyMmZKRHJRRmNPcjFC?=
 =?utf-8?B?K21SQnJjUTR3S3F1WG1xb0N1T2dKWHNCbFJmUFFITGJmRXcySWxQWXJCNDBi?=
 =?utf-8?B?K3VWTmpDd3dDMTFvakttREhvdkUvakJSZEdiOTg5cVo0U2JVTU9MMkFYUitT?=
 =?utf-8?B?S2gzdkpkK2VibVpEcGNQS0N1d2pHUm9zS0F1VVJWK1o5STlyT2FPVTdPZTNv?=
 =?utf-8?B?RklOM2RYOHV4dng3ZGh0NDZWMlRoeWhyVUt1K2pDYXB0UUJ4emY5NHRidElu?=
 =?utf-8?B?STdTMGZzRkJaM1FERUZtbkExUmFPQ1ZNUnlCVFlMN0UwM0JVNUVkdU1VYjRq?=
 =?utf-8?B?WUo2aEFPY2xqL2FiTkh1S0dhL1M3Nmg2MlRadmkvUkJ5c2R2Z2dXV2c1dUNP?=
 =?utf-8?B?ZHpsZmpzVWNuODVEK3NTTFZrRFlhS05LTjZLcVY0YWpaTFhNdHNtOEVXQWtv?=
 =?utf-8?B?bzJEY2QwNlpNaHdpSnNyOGdwODNyVmsxaGJYY0NUTFV5WjNtVDV3OTd0V3Ez?=
 =?utf-8?B?ZS84eThRRGp3SlkxckR5STgwRVllYVRKeDllaWJaTnpMZHRnclk1bFNiVm5D?=
 =?utf-8?B?aitvVXVSaEdZeHFuM3FlclNRcTNtS2gvREFKNHZHbFpOSHhkMXRnRnJ3bEky?=
 =?utf-8?B?VU5ibE9pK2owZzM1c3JpM3RxUWV5RUhOMXI1Ri9xL0VDYVlaSzBzS2hPRStJ?=
 =?utf-8?Q?+LM8Z1iUDO4DW9MUrSXD+rkvNR+oZBeDMeIR1TB?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41dc3988-1c02-49ac-e2b4-08d90c098497
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB3851.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2021 18:55:26.9900
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A8iXTCBHAvtBkWkh6MRKPb3DL7R+4oo0VNxoJSanYhAipe3wCJV+NT+YAKa3Y1GS9iy3LQZcFI6QVjlJk3QP2CulqxHU0SZvFgvApgAT/OM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4156
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9970 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104300129
X-Proofpoint-ORIG-GUID: DwBGpkhWEh57rHHoZhRhd2QM4PBD_dgS
X-Proofpoint-GUID: DwBGpkhWEh57rHHoZhRhd2QM4PBD_dgS
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9970 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 impostorscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0
 clxscore=1015 suspectscore=0 malwarescore=0 mlxlogscore=999
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104300129
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 1a1c130ab7575498eed5bcf7220037ae09cd1f8a upstream.

Upstream commit 1a1c130ab7575498eed5bcf7220037ae09cd1f8a along with 
upstream commit 6998a8800d73116187aad542391ce3b2dd0f9e30 (ACPI: x86: 
Call acpi_boot_table_init() after acpi_table_upgrade() ) fixes the 
following issue.

Mounting an iSCSI volume during boot causes the following crash with a 
KASAN enabled kernel:

[   17.239703] iscsi: registered transport (iser)
[   17.241038] OPA Virtual Network Driver - v1.0
[   17.242833] iBFT detected.
[   17.243593] 
==================================================================
[   17.243615] BUG: KASAN: use-after-free in ibft_init+0x134/0xab7
[   17.243615] Read of size 4 at addr ffff8880be451004 by task swapper/0/1
[   17.243615]
[   17.243615] CPU: 2 PID: 1 Comm: swapper/0 Not tainted 
4.19.190-rc1-1bd8f1c #1
[   17.243615] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), 
BIOS 0.0.0 02/06/2015
[   17.243615] Call Trace:
[   17.243615]  dump_stack+0xb3/0xf0
[   17.243615]  ? ibft_init+0x134/0xab7
[   17.243615]  print_address_description+0x71/0x239
[   17.243615]  ? ibft_init+0x134/0xab7
[   17.243615]  kasan_report.cold.6+0x242/0x2fe
[   17.243615]  __asan_report_load_n_noabort+0x14/0x20
[   17.243615]  ibft_init+0x134/0xab7
[   17.243615]  ? dcdrbu_init+0x1e6/0x225
[   17.243615]  ? ibft_check_initiator_for+0x14a/0x14a
[   17.243615]  ? ibft_check_initiator_for+0x14a/0x14a
[   17.243615]  do_one_initcall+0xb6/0x3a0
[   17.243615]  ? perf_trace_initcall_level+0x430/0x430
[   17.243615]  ? kasan_unpoison_shadow+0x35/0x50
[   17.243615]  kernel_init_freeable+0x54d/0x64d
[   17.243615]  ? start_kernel+0x7e9/0x7e9
[   17.243615]  ? __switch_to_asm+0x41/0x70
[   17.243615]  ? kasan_check_read+0x11/0x20
[   17.243615]  ? rest_init+0xdc/0xdc
[   17.243615]  kernel_init+0x16/0x180
[   17.243615]  ? rest_init+0xdc/0xdc
[   17.243615]  ret_from_fork+0x35/0x40
[   17.243615]
[   17.243615] The buggy address belongs to the page:
[   17.243615] page:ffffea0002f91440 count:0 mapcount:0 
mapping:0000000000000000 index:0x1
[   17.243615] flags: 0xfffffc0000000()
[   17.243615] raw: 000fffffc0000000 ffffea0002df9708 ffffea0002f91408 
0000000000000000
[   17.243615] raw: 0000000000000001 0000000000000000 00000000ffffffff 
0000000000000000
[   17.243615] page dumped because: kasan: bad access detected
[   17.243615]
[   17.243615] Memory state around the buggy address:
[   17.243615]  ffff8880be450f00: ff ff ff ff ff ff ff ff ff ff ff ff ff 
ff ff ff
[   17.243615]  ffff8880be450f80: ff ff ff ff ff ff ff ff ff ff ff ff ff 
ff ff ff
[   17.243615] >ffff8880be451000: ff ff ff ff ff ff ff ff ff ff ff ff ff 
ff ff ff
[   17.243615]                    ^
[   17.243615]  ffff8880be451080: ff ff ff ff ff ff ff ff ff ff ff ff ff 
ff ff ff
[   17.243615]  ffff8880be451100: ff ff ff ff ff ff ff ff ff ff ff ff ff 
ff ff ff
[   17.243615] 
==================================================================


Patch

commit 1a1c130ab7575498eed5bcf7220037ae09cd1f8a
Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Date:   Tue Mar 23 20:26:52 2021 +0100

     ACPI: tables: x86: Reserve memory occupied by ACPI tables

     The following problem has been reported by George Kennedy:

      Since commit 7fef431be9c9 ("mm/page_alloc: place pages to tail
      in __free_pages_core()") the following use after free occurs
      intermittently when ACPI tables are accessed.

      BUG: KASAN: use-after-free in ibft_init+0x134/0xc49
      Read of size 4 at addr ffff8880be453004 by task swapper/0/1
      CPU: 3 PID: 1 Comm: swapper/0 Not tainted 5.12.0-rc1-7a7fd0d #1
      Call Trace:
       dump_stack+0xf6/0x158
       print_address_description.constprop.9+0x41/0x60
       kasan_report.cold.14+0x7b/0xd4
       __asan_report_load_n_noabort+0xf/0x20
       ibft_init+0x134/0xc49
       do_one_initcall+0xc4/0x3e0
       kernel_init_freeable+0x5af/0x66b
       kernel_init+0x16/0x1d0
       ret_from_fork+0x22/0x30

      ACPI tables mapped via kmap() do not have their mapped pages
      reserved and the pages can be "stolen" by the buddy allocator.

     Apparently, on the affected system, the ACPI table in question is
     not located in "reserved" memory, like ACPI NVS or ACPI Data, that
     will not be used by the buddy allocator, so the memory occupied by
     that table has to be explicitly reserved to prevent the buddy
     allocator from using it.

     In order to address this problem, rearrange the initialization of the
     ACPI tables on x86 to locate the initial tables earlier and reserve
     the memory occupied by them.

     The other architectures using ACPI should not be affected by this
     change.

     Link: 
https://lore.kernel.org/linux-acpi/1614802160-29362-1-git-send-email-george.kennedy@oracle.com/ 

     Reported-by: George Kennedy <george.kennedy@oracle.com>
     Tested-by: George Kennedy <george.kennedy@oracle.com>
     Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
     Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>
     Cc: 5.10+ <stable@vger.kernel.org> # 5.10+

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 7bdc023..14cd318 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -1554,10 +1554,18 @@ void __init acpi_boot_table_init(void)
      /*
       * Initialize the ACPI boot-time table parser.
       */
-    if (acpi_table_init()) {
+    if (acpi_locate_initial_tables())
          disable_acpi();
-        return;
-    }
+    else
+        acpi_reserve_initial_tables();
+}
+
+int __init early_acpi_boot_init(void)
+{
+    if (acpi_disabled)
+        return 1;
+
+    acpi_table_init_complete();

      acpi_table_parse(ACPI_SIG_BOOT, acpi_parse_sbf);

@@ -1570,18 +1578,9 @@ void __init acpi_boot_table_init(void)
          } else {
              printk(KERN_WARNING PREFIX "Disabling ACPI support\n");
              disable_acpi();
-            return;
+            return 1;
          }
      }
-}
-
-int __init early_acpi_boot_init(void)
-{
-    /*
-     * If acpi_disabled, bail out
-     */
-    if (acpi_disabled)
-        return 1;

      /*
       * Process the Multiple APIC Description Table (MADT), if present
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index d883176..5ecd69a 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1045,6 +1045,9 @@ void __init setup_arch(char **cmdline_p)

      cleanup_highmap();

+    /* Look for ACPI tables and reserve memory occupied by them. */
+    acpi_boot_table_init();
+
      memblock_set_current_limit(ISA_END_ADDRESS);
      e820__memblock_setup();

@@ -1136,11 +1139,6 @@ void __init setup_arch(char **cmdline_p)

      early_platform_quirks();

-    /*
-     * Parse the ACPI tables for possible boot-time SMP configuration.
-     */
-    acpi_boot_table_init();
-
      early_acpi_boot_init();

      initmem_init();
diff --git a/drivers/acpi/tables.c b/drivers/acpi/tables.c
index e48690a..9d58104 100644
--- a/drivers/acpi/tables.c
+++ b/drivers/acpi/tables.c
@@ -780,7 +780,7 @@ acpi_status acpi_os_table_override(struct 
acpi_table_header *existing_table,
  }

  /*
- * acpi_table_init()
+ * acpi_locate_initial_tables()
   *
   * find RSDP, find and checksum SDT/XSDT.
   * checksum all tables, print SDT/XSDT
@@ -788,7 +788,7 @@ acpi_status acpi_os_table_override(struct 
acpi_table_header *existing_table,
   * result: sdt_entry[] is initialized
   */

-int __init acpi_table_init(void)
+int __init acpi_locate_initial_tables(void)
  {
      acpi_status status;

@@ -803,9 +803,45 @@ int __init acpi_table_init(void)
      status = acpi_initialize_tables(initial_tables, ACPI_MAX_TABLES, 0);
      if (ACPI_FAILURE(status))
          return -EINVAL;
-    acpi_table_initrd_scan();

+    return 0;
+}
+
+void __init acpi_reserve_initial_tables(void)
+{
+    int i;
+
+    for (i = 0; i < ACPI_MAX_TABLES; i++) {
+        struct acpi_table_desc *table_desc = &initial_tables[i];
+        u64 start = table_desc->address;
+        u64 size = table_desc->length;
+
+        if (!start || !size)
+            break;
+
+        pr_info("Reserving %4s table memory at [mem 0x%llx-0x%llx]\n",
+            table_desc->signature.ascii, start, start + size - 1);
+
+        memblock_reserve(start, size);
+    }
+}
+
+void __init acpi_table_init_complete(void)
+{
+    acpi_table_initrd_scan();
      check_multiple_madt();
+}
+
+int __init acpi_table_init(void)
+{
+    int ret;
+
+    ret = acpi_locate_initial_tables();
+    if (ret)
+        return ret;
+
+    acpi_table_init_complete();
+
      return 0;
  }

diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index fcdaab7..3bdcfc4 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -222,10 +222,14 @@ struct acpi_subtable_proc {
  void __acpi_unmap_table(void __iomem *map, unsigned long size);
  int early_acpi_boot_init(void);
  int acpi_boot_init (void);
+void acpi_boot_table_prepare (void);
  void acpi_boot_table_init (void);
  int acpi_mps_check (void);
  int acpi_numa_init (void);

+int acpi_locate_initial_tables (void);
+void acpi_reserve_initial_tables (void);
+void acpi_table_init_complete (void);
  int acpi_table_init (void);
  int acpi_table_parse(char *id, acpi_tbl_table_handler handler);
  int __init acpi_table_parse_entries(char *id, unsigned long table_size,
@@ -814,9 +818,12 @@ static inline int acpi_boot_init(void)
      return 0;
  }

+static inline void acpi_boot_table_prepare(void)
+{
+}
+
  static inline void acpi_boot_table_init(void)
  {
-    return;
  }

  static inline int acpi_mps_check(void)


Thank you,
George
