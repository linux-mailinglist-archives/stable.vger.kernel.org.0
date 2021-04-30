Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55C643700FB
	for <lists+stable@lfdr.de>; Fri, 30 Apr 2021 21:06:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230475AbhD3THL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Apr 2021 15:07:11 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:34166 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229954AbhD3THL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Apr 2021 15:07:11 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13UJ3ri4124132;
        Fri, 30 Apr 2021 19:06:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : from :
 subject : message-id : date : content-type : content-transfer-encoding :
 mime-version; s=corp-2020-01-29;
 bh=MVjZ/xG3gOYD3lzgIW8t4boFc7pzjK5GDt7qrgk63F4=;
 b=m/H/AWE0PJOFzCmOUIXvOInA7U0Qn8ggQeAIFZLEh8DOPn6MLD1vDPCbqtpKYWZNkYNX
 W4Vu+pNxopcSN27Z21up+0J4WMHaLBWIHEGlZT478qb6reQ8mZ3WU0YQwd8KN21hz5sT
 Uc9dWuX+syZToJjJUyMiR1vWPaQOPI9kCLW3pKwuqVtfu3gC3NDEOBOI5/xn+N/ss0Bm
 Ni6UrIekMi84W0utjHn9f0Rl+ksWD6FCKPva+uqMuXAWNa7wf5LLugEQY0QqTbueFDUZ
 BunwpUhCG/sWHMnUvTc3+2I+pymGKUX6ZkvM/Sotd661e8SV9ffpn/UCfgJh29hsVU6d wQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 385ahc0nkw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Apr 2021 19:06:06 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13UJ63tS111626;
        Fri, 30 Apr 2021 19:06:06 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2042.outbound.protection.outlook.com [104.47.66.42])
        by aserp3020.oracle.com with ESMTP id 384b5ce33y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Apr 2021 19:06:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Edv8EjyF0N1ZT1XGQt/wwqRY0f+26jXJiuZ/fA0tDFKs9p9lTei2vUAW9mt+r7ket+Y6HnROaxHdjDyywXLl0kuKOXWFXU9A2f/uUD8Uk/o2qG+3gbJzrb9kcvOLuhpihRv4pE5CbYunTqnxt/siFSG+Hicl40A53iDrmbyNDfZ+5APxUVTPwKqmoTnNxj76U+MoL9Wqa6BiINvXQyeAOcOofHOdWxaN8PITuSIH98W9p9fFQYNp99XxdasRQiMHi+6Cyrxtl7baVhiDExOkcRwPaA489cLChW8WFDu54gAncqZkxqZXU140bRpM/Whp6FnTALoUpKqqgJ4240q6ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MVjZ/xG3gOYD3lzgIW8t4boFc7pzjK5GDt7qrgk63F4=;
 b=iMVBLdF+ImO6Ec1ZHHd8f8KiRpS2HkPWWyQDDSnuO5OmlnqUmZx4pvGtPYzzyscrIwKolY3t3tNKMO67ivPl94ElZKtmBcGwvBYL2wJp/JDjAZe4AWTIlOLS98lXrIe99rQvSBs0+KQ0Szp9vWQfLHjlsZ4qR2tID6mdS0OnZT6YPcx9HHggQ3biJmQWZpIWny5lMcpMHg7IN5RQF+Mets5uYRg2Kr7SaGt9/FNL2fh6JGWbvWLXz+NlGj3eWGnSyRzl3F/b1maIwifYCyB7bgbdnhsqDV7Y/mkgJm1NOXZritJ8WNbZ7g2uZ1cescVINDiPNspQEDOV25+TopkCkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MVjZ/xG3gOYD3lzgIW8t4boFc7pzjK5GDt7qrgk63F4=;
 b=d2R7daS72LgavfcGJbPzrNAJqHd19hXPfKEq5/ikvuuM+Xpd5yVtE7IlHtRfty6yM1flTlIKDsORzXZOyFVWXvEMUsMpxgq6gGiPFbgWcC3dtAW9bL5ZHu4GubnJSpsDdKiS294zALRZtX4SKg4tL6KDr+kaWu8m9fzlBL0QS9k=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from DM6PR10MB3851.namprd10.prod.outlook.com (2603:10b6:5:1fb::17)
 by DM6PR10MB4156.namprd10.prod.outlook.com (2603:10b6:5:217::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.26; Fri, 30 Apr
 2021 19:05:48 +0000
Received: from DM6PR10MB3851.namprd10.prod.outlook.com
 ([fe80::e490:f9ff:f8f3:c1e6]) by DM6PR10MB3851.namprd10.prod.outlook.com
 ([fe80::e490:f9ff:f8f3:c1e6%7]) with mapi id 15.20.4087.035; Fri, 30 Apr 2021
 19:05:48 +0000
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
Subject: 5.4.y, 4.14.y, 4.19.y [PATCH] ACPI: x86: Call acpi_boot_table_init()
 after acpi_table_upgrade()
Organization: Oracle Corporation
Message-ID: <12b04d71-e3dc-c2d3-2e8d-f11c2650764a@oracle.com>
Date:   Fri, 30 Apr 2021 15:05:46 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [108.26.147.230]
X-ClientProxiedBy: SA9PR13CA0150.namprd13.prod.outlook.com
 (2603:10b6:806:27::35) To DM6PR10MB3851.namprd10.prod.outlook.com
 (2603:10b6:5:1fb::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.228] (108.26.147.230) by SA9PR13CA0150.namprd13.prod.outlook.com (2603:10b6:806:27::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.10 via Frontend Transport; Fri, 30 Apr 2021 19:05:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1fb13d63-fdda-4174-ad94-08d90c0af71b
X-MS-TrafficTypeDiagnostic: DM6PR10MB4156:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR10MB4156788C7D34E385164ED989E65E9@DM6PR10MB4156.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mLlPPJz++Q2pG7UVEHYQ1v3Ut8MErEBiZ+UOuNoWj/KhWL7ZpJd92amd6EVnOUmEcWSUeLKVI8UuFqxSNSkIWEmq+izdY6Sj0J6uCpiGIVeyOylIu9LJdrucgoUT6b+CdH1yvfzfNSwE0MKj3dJThE0fJR7DwOYRmLaeoEJn4Nox0mytHpmc64OC0Dgz7YkQqCDHcGFQyDwJa5baBziQ7YcTFvzY8zJkWK7dv5SJekp3ohHm7y8PzeixAmINmT4bj1wZzGhQA3N9rwvr2qwZy6og+rji1UF1TE6qkzwfnXK0gnLtH5DjAm7oKx7aWAdmB93feTsszwQljeJkOImmUkqKeIfK98+zhFEmsa14isfBlKRSXOSAJzVQFDuS/AUHDJTb1NR55ctRULaS6tmQC4z7k97RXGlSfteLJPVJ3HgIVQxgvZKXO/57EMvp5XTP4REEhfhzigVezbiHg8yKYk8lUwgkWNGSpxgX6byQ39i9LksrSZNoEvKbpA8zY78qDDJWxq2u4wSYvHBRo+UpNERb55zQghoHgsfLmnIfNTVOdvz8YyROV6XunqQe8FndZ59HYG6bD7GiFxCvu9w9d89WW4jkakhXKcDPV9gnYsKDCddVL3Cf3ZqS8AueJUBpQpkWJNwzOxwsKrH3xccN9Y7N1ELt/ti7/DVahxYJpmOYXva7D9U5V2YLBJfDyemH
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB3851.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(346002)(366004)(376002)(136003)(36916002)(86362001)(478600001)(66476007)(31696002)(54906003)(83380400001)(5660300002)(8936002)(4326008)(186003)(16526019)(956004)(316002)(44832011)(36756003)(2616005)(31686004)(6916009)(38100700002)(66556008)(26005)(8676002)(66946007)(16576012)(6486002)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?cUd1dWlWMnljWkZYb211eFpydzF4SG5hNFNXU2Fwb244Vzc5c2pabTMyT3JD?=
 =?utf-8?B?R2FtWjVoOFM3TUVyK3RudStYRGNGTFF1bGRGUERuNSs4UlV6dC96UEU1MXFM?=
 =?utf-8?B?Tm9xbSsvYnA3dldqMWdnV1NFRTNNWC9SbWJ1bHBzQWh2QWh2empEb2JaQXhJ?=
 =?utf-8?B?MDJKVnYrc21qSUZXdHRJb2t3SmF2alVrRGRaK2VjWlBnYzdSRkVpNWZMYk5x?=
 =?utf-8?B?N0lEWU5MZkUreWFJeExQeDdEaG4xUlkrOUVPeXljb2EwamVsb3NiTExQVkFP?=
 =?utf-8?B?SmN4Y1N2NnBhVUpYOE12OExtZjN3R2poeGZZQ3B3VmFjQ2NoNlhSdHo0WTNR?=
 =?utf-8?B?bTBzTEIrLzFBTUcyRVJ5YXloVkN1aWYyWTQ4NGVCdU4rRDR6VmNLY282OWxL?=
 =?utf-8?B?MGIzRjJ6U0NSbFQwbkk2clROMnNLYWZNM3hTY2MwK0VUVk9SN1dkTFUzQWN1?=
 =?utf-8?B?S0QrdjNPUE50OExLZTR3VnIwNUtkU1ErNTdVOXR1VnVJaENES1pIb3AwTW9h?=
 =?utf-8?B?SEtuYUVma2ljODNxOTBVOU55SEJ3d245aEdiNGMrbTIzd2JIanFRWEJSVlJQ?=
 =?utf-8?B?ekdnSkhLSW91T2FVU0FEeUtwamRkQkFaQmRVdXcrTVBJY0VEQmhuSEZ3YU5Q?=
 =?utf-8?B?clIwd2xyenhpQ0FENzlzK0ZnYXdoUHZibEUrd1VRN3cxQXg4SzR2Z0luTDFa?=
 =?utf-8?B?b0UraEFRckFrNVdTa25VQVR5Z1RIQTlmdUJZN0R6L0lsTGJpN0Z5ckN0MytF?=
 =?utf-8?B?UVc2aWorN25RZ2FqR09Kamc2RXM1aXJmdnBnOWVQa29hVWNHNFdZejNhM0xT?=
 =?utf-8?B?dzF6dHBjUlF3dkJNRzY2c2ZGenV3TVlJOWkxNlZCdzNuelplL0hHRkVvdlpQ?=
 =?utf-8?B?WUNqTitaOEsvb0tpaDd3WVZZNk1WWXR3ZWVPNTVSVGFOdHluZnc1ZXZaSTZp?=
 =?utf-8?B?eTJCYjFqdDlKVmxGTUM5OWxPZUdhMU1hR3kxbHRsM0F6aFBBa1FrWmlJWmR5?=
 =?utf-8?B?RkNIZGN0NzdQci9YV0dvQXBzVCs2VHZMa1lqaDZORFVQR2VyRUIwdzFBNGpW?=
 =?utf-8?B?eU5KOXlGcDJvMmNPZ0xkbnJqV3NKcWNlbnVUL3dmMWFvdjZGM0M0ZlpiNUxM?=
 =?utf-8?B?cW4xbWpmUU1IRkRkNVY1YnRDdi9RempIUnRRamtOL3ZrR0VPT2NJQ1VPM2JZ?=
 =?utf-8?B?My9VQW9LU0lWSDBQeWtjOHdOYXM0Tk9BNm5TMFdwZkYvQVRRZTVMNGtFVWJI?=
 =?utf-8?B?dlZ6QllWL3BhQmNaWVV6VVpjQnQwSDY1S2MwVUtVb1REL0MvOXhQUVRRM1Bk?=
 =?utf-8?B?UGsrY0poczE5Z2xZejE4Q282Uk1xZkhCMWxXbERNMDY2bjZyVEVRVm5YMXlH?=
 =?utf-8?B?WkV2dkoyZU9wWVlhOHhEVFB3RTJMUnZsb2lWNkVnZGJ2WGFlY0U5Tm1oS2x3?=
 =?utf-8?B?cUFzbU1SRndLY1k3aU1odThPTUIvWDJyRGNCdWtGWlBMSnlDVG0weGNPVFNw?=
 =?utf-8?B?c3dSb0JrcUdwbmJ2Zk1ZeE95OS8vQzA3TmFTZ2tkaEtxQXdoWDNtUDRXbURw?=
 =?utf-8?B?UUZ4R0ZTNEc5czlQcTNnNkJhN1J6QmlzMHluaUpHcVpMQjdFV3gvb0gwbE1h?=
 =?utf-8?B?NjhPT0MvK2dFaXhBOHhKZ2ZBVlFQbmhYS0F1a0NXa2U4YU5xK3JldGl5R0JP?=
 =?utf-8?B?Tk1YRDdvaFI3aEZibDZITWNyaTNpSGJYWUVhS2ZaQ0NWNjhpTUhDTlJnNkMv?=
 =?utf-8?Q?m6vk2DEoyu19dwyNmL/RhY2K3Ll3+U8JYdchMrC?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fb13d63-fdda-4174-ad94-08d90c0af71b
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB3851.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2021 19:05:48.5687
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: blKzKjTwYWK6JQyxh+CH2x+YseuAF34Ubd3rDsCxv0g6PuktWVanJYdNqdb8TgQtHMcLQ48O8lCAJgHpAuRhbXseEXqTnXKMJMLBtW3KSSg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4156
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9970 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 phishscore=0 adultscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104300130
X-Proofpoint-GUID: FvdBKnr85b_2ONuZ2EVpXLGUSGSNvI4L
X-Proofpoint-ORIG-GUID: FvdBKnr85b_2ONuZ2EVpXLGUSGSNvI4L
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9970 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 priorityscore=1501 clxscore=1015 adultscore=0 suspectscore=0 spamscore=0
 phishscore=0 malwarescore=0 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104300130
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 6998a8800d73116187aad542391ce3b2dd0f9e30 upstream.

Upstream commit 6998a8800d73116187aad542391ce3b2dd0f9e30 along with 
upstream commit 1a1c130ab7575498eed5bcf7220037ae09cd1f8a (ACPI: tables: 
x86: Reserve memory occupied by ACPI tables) fixes the following issue.

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

commit 6998a8800d73116187aad542391ce3b2dd0f9e30
Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Date:   Tue Apr 13 16:01:00 2021 +0200

     ACPI: x86: Call acpi_boot_table_init() after acpi_table_upgrade()

     Commit 1a1c130ab757 ("ACPI: tables: x86: Reserve memory occupied by
     ACPI tables") attempted to address an issue with reserving the memory
     occupied by ACPI tables, but it broke the initrd-based table override
     mechanism relied on by multiple users.

     To restore the initrd-based ACPI table override functionality, move
     the acpi_boot_table_init() invocation in setup_arch() on x86 after
     the acpi_table_upgrade() one.

     Fixes: 1a1c130ab757 ("ACPI: tables: x86: Reserve memory occupied by 
ACPI tables")
     Reported-by: Hans de Goede <hdegoede@redhat.com>
     Tested-by: Hans de Goede <hdegoede@redhat.com>
     Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 5ecd69a..ccab6cf 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1045,9 +1045,6 @@ void __init setup_arch(char **cmdline_p)

      cleanup_highmap();

-    /* Look for ACPI tables and reserve memory occupied by them. */
-    acpi_boot_table_init();
-
      memblock_set_current_limit(ISA_END_ADDRESS);
      e820__memblock_setup();

@@ -1132,6 +1129,8 @@ void __init setup_arch(char **cmdline_p)
      reserve_initrd();

      acpi_table_upgrade();
+    /* Look for ACPI tables and reserve memory occupied by them. */
+    acpi_boot_table_init();

      vsmp_init();

Thank you,
George
