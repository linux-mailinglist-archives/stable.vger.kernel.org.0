Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 537813700F2
	for <lists+stable@lfdr.de>; Fri, 30 Apr 2021 21:04:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230356AbhD3TFI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Apr 2021 15:05:08 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:38914 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229954AbhD3TFH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Apr 2021 15:05:07 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13UIt8Z5066408;
        Fri, 30 Apr 2021 19:03:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : message-id : date : content-type : content-transfer-encoding :
 mime-version; s=corp-2020-01-29;
 bh=MVjZ/xG3gOYD3lzgIW8t4boFc7pzjK5GDt7qrgk63F4=;
 b=uolgvGvg52xWc7dT81amBzlzkOWTPZBsKaZG1ffjmId3l5FJDk0vNnXcSNpQk4xbtRjv
 q49me4MdaEXEjmlputCCTum0jFkxxb91axz4yH8nMCytnDxkScrrVl/1a/FBQ9xbV3Wt
 eqk9UzT++4xZvggHgSVtDX+DiRVP9qHexGfH2hpAaRlwgNlxnihYX0TkFMyGFV4ql2EC
 2jhm7t7AHfCiJ7bOLGhszn6v4pDOqg/kjaJFvT423wpinCja3JQEkHDJFFos03NwYDSD
 JgqbfwDmASgPsMGErG6ybAE699xaQZfPJ24gIt3znv6o0cTK1H8a8atJC3uwj8anUwme Fg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 385afq8r0r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Apr 2021 19:03:43 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13UIsqTk167129;
        Fri, 30 Apr 2021 19:03:42 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2108.outbound.protection.outlook.com [104.47.55.108])
        by userp3020.oracle.com with ESMTP id 384w3y4tg4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Apr 2021 19:03:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MyuvtFrHcJlPLSvBpu230C9be4KzVbwD8ZCq/tFlZz9yK5Wd1dQGVnvB/yK80u5E20CfMPqFi4WKcA9y2XFnQG/4mdztGvGvOh/GwLMQOb1AXdFxA6pJkClnsHFrT/iNa/SX2mgzoW3+Un4fdL3AUF6u2dm+t3pm7DpOPNVrySpk8iVCmxzyUUbnLfwZ85yOao/gXflOFhrjtlnEs7VHzMXy8i1OzFAhfptVeodch4PMtjt76ZkNYNX6cp/x5WZeKR0VnBitR10Tyz7rwBDa+inNlp4IZVi/4K7iVKluYXZnANP3IR2POittR3u/yjJ+dilQAPCDRCJIqzlnKL04jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MVjZ/xG3gOYD3lzgIW8t4boFc7pzjK5GDt7qrgk63F4=;
 b=P3pcJNJAq7guqJDPAt1EIDdR/0vbCSVXIm9Lt7zsacavFTDsgQsVutCfpxYDR5D98areq5Iv+HcP9xXMC0QgetGIGvtO3/i5UEDq7jWUjQSzb6CIojCckjzL3Ato16Tv9uiKzBWUYGLToVQvIcE8Zw8feTJ5fdzeFtUX2KnpMA8EY9JToSi3PlY3y98aWv00B5U7djjykCFdaYL5SATqlqxq7LpdH9EE01vvnIDvcXa6uKB4Ht8j2bRPLtP9dyNWbA7i+8KW3Tk6JDqIc1HM0J1r9ns7MidIw55Fo9ZNL9zkjhX9P9nhrq0oZNYZgncv9lffUD6kMrEoO4D2sIVB9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MVjZ/xG3gOYD3lzgIW8t4boFc7pzjK5GDt7qrgk63F4=;
 b=n/ZUCmoX+ZZRaLZUixjMxqZ4zrcdLZYbegoG58q+F1UQM367RgzF/6xLGnhRrMBNcFlMnpzN1eMFI1VNJBDhVPXRjLFa2dE/+FB8LVz7ke6zeJA9VdvsR6yUZXjRI8Ud/g4e3wAZMlkY+C3pdnsFJN8BLkp8TzJHkxossz6aCEA=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from DM6PR10MB3851.namprd10.prod.outlook.com (2603:10b6:5:1fb::17)
 by DM5PR10MB1257.namprd10.prod.outlook.com (2603:10b6:4:f::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4065.20; Fri, 30 Apr 2021 19:03:39 +0000
Received: from DM6PR10MB3851.namprd10.prod.outlook.com
 ([fe80::e490:f9ff:f8f3:c1e6]) by DM6PR10MB3851.namprd10.prod.outlook.com
 ([fe80::e490:f9ff:f8f3:c1e6%7]) with mapi id 15.20.4087.035; Fri, 30 Apr 2021
 19:03:39 +0000
From:   George Kennedy <george.kennedy@oracle.com>
Subject: 5.4.y, 4.14.y, 4.19.y [PATCH] ACPI: x86: Call acpi_boot_table_init()
 after acpi_table_upgrade()
Organization: Oracle Corporation
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Dhaval Giani <dhaval.giani@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        stable@vger.kernel.org, "Rafael J. Wysocki" <rafael@kernel.org>,
        Linux ACPI <linux-acpi@vger.kernel.org>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86 Maintainers <x86@kernel.org>
Message-ID: <ccb59e5f-c585-d5d2-034c-a96aba407b5b@oracle.com>
Date:   Fri, 30 Apr 2021 15:03:37 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [108.26.147.230]
X-ClientProxiedBy: SN4PR0201CA0041.namprd02.prod.outlook.com
 (2603:10b6:803:2e::27) To DM6PR10MB3851.namprd10.prod.outlook.com
 (2603:10b6:5:1fb::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.228] (108.26.147.230) by SN4PR0201CA0041.namprd02.prod.outlook.com (2603:10b6:803:2e::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.27 via Frontend Transport; Fri, 30 Apr 2021 19:03:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3a2a0fcc-1d08-4782-9c97-08d90c0aaa50
X-MS-TrafficTypeDiagnostic: DM5PR10MB1257:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR10MB12576F31C3DB42596457E9E8E65E9@DM5PR10MB1257.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3276;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vB2LVe2+FPGFxIaqlfRFXpdCskyNpeqp/s61R995tHPs57ZTLBjfO01eVz2/0z/rdiQkp+SIArAMKTj8l52Y5dlI8ACHV/pIKtCx2moUNCHQVm7hcedDAqGbDx9pfHDBTCAeuboKXyqFR9nV/RcK9k+skhcrmdlxXrqLzwkD/q3V09N/KJC6Hvikogbq0noztIlmFbsAATbWijbDPjWZ81JoBfkxWbfXH7PixtG8vwsFedK683mH6FjqXcs2emxrvKDxoDw1RfEe+qLlDt5ESuRxd9f15Rz7ApUCAHTRBVO0aKeOPXDtJDai3H0btJNA0tGektKWQSPZCjEZUtIDudhvyU3nlk45ml4smDQrWsMfprcqR/kof5D3yAH9L5xH1YVStfecAh7KPY2FWkv8ND4uLTaiZq1s2vAnsArIR+ySmFfU/g6u7rU8hicX1yGkxnUhD8PTFV175fSPA7MLVYTNapMZnlkiFUHcTDkY+NZlKBdunurCdsVNzSowu4H/fmJg+0JW2v45o9TK+dYESleXB1F3dsgbB1znd0Ua94fggbnalFYsnPngDhW1R93vsWMokwJUp9l9uVIeP2HM2WiflSZ+K3TYhWzyHpfRN47LR/T32QyGmM5Dgcg7SVX9DO6IvuJ5PG/Pu/6qndu2UGBLOvX8Fv0daZZtqA6eJLOWe7lO/jaEFPj8vxA4iP+V
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB3851.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(376002)(39860400002)(366004)(136003)(66946007)(31686004)(6486002)(83380400001)(4326008)(186003)(66556008)(36756003)(8676002)(6916009)(36916002)(54906003)(478600001)(16526019)(5660300002)(2616005)(316002)(38100700002)(44832011)(66476007)(8936002)(86362001)(16576012)(2906002)(31696002)(26005)(956004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?V0x1YVJ2dEdzM0xFZFMvcHFBdDdhbGE3WkRUR3p4WkxDTk04cHVKbk5WZXYr?=
 =?utf-8?B?ODdhV1JmREt1Q3N0cUlPTVFMSFVwSlA0a0xXVHJhVm53Ykw1OW1haVdIelJu?=
 =?utf-8?B?V3BPQzgvQjZ4ZVYyTDA0Z3ZMZ1k1a29xWlVXM1VRajFKckhJTVBOYk95MzFN?=
 =?utf-8?B?Z2IvYUowL29vSzIwdjMyU1AxRUdSUHRjaDdaY3BHUHFvYWJTRlhsVjA5eU9H?=
 =?utf-8?B?b2hEYVArRTAzQlFMK2t1d0t4OVFvQXBDbGJ4VW4veWw5R3gzNTRrY3F6UEhu?=
 =?utf-8?B?dVdXcmNOeFdnWDZ5RTB2akdjZmFwMmFZY0lqZHRTN2hsYXNwb1BmdmR4NWY1?=
 =?utf-8?B?NGJudFRDcTg5L1FudTRkSVVuRjZYWHVaZ2N5NWV2Ymhla0szSlNzbTlzUnM5?=
 =?utf-8?B?N1dJOXFRWkNDOEoveEtlRWk3bGVyaVNLdk4vWDUzTVp4dzVpd1V4OWF4eE11?=
 =?utf-8?B?eVZidUFyUVY4SEo2aGpJb3BuQ25KUXlSL0Z4K1grNTd5SmdiVWVOMTkzTzFD?=
 =?utf-8?B?ejRLRXliZzFjRmpMYm1lQnhRcFA1VkRuYktuL1VzUUJlRjRVNkhKdmF6TUtj?=
 =?utf-8?B?M2RyT3V4VjdMcmhRRXo4T1JuTXhzQ251KzkrVm84Rmo1ZnNSNlhSOCtPdjEx?=
 =?utf-8?B?MGpmQjRkOHZDM1U5TGJPb1dPSThSUTlwM0N5OVdsMHBNVVVOc09iYlk5THRC?=
 =?utf-8?B?bEdhQ2pETmZpMjhNM0xxR0FDQVZuUFFjd3JNNHpndm43dnFUeUNzUUhSWnBn?=
 =?utf-8?B?VHRNVmM5SlpYT3lybnQ4aGtnMzY0a3ZQdGRtUkpna2d6Zmk1cnZVSW5KWlZ5?=
 =?utf-8?B?d1JNOGZGVVdqQy9WbkZpMHE3ekFrUFgrTTFVWGQyZGpKYmlSUWp1MEVwdDlk?=
 =?utf-8?B?WkRtOGU3TUNwK20zQ0NocnB2UjFqVU0zY1dJejhBSktoemtsWFBKenk0bWlO?=
 =?utf-8?B?K2JMS1J2dC9BbGkwVHA1bFIwTVAxNzRtYVdaZzBPNG9YOGE0T2UxQUNoRzlt?=
 =?utf-8?B?VHczSkhZWS92WndWaE5zdnRPZTI0T2pPVGZ2aXJGaFBWTzhla3ZWMENpbTJa?=
 =?utf-8?B?MnFDWVNxNHRBSGZIWGMycnhNb0NJb3ZrcUl1aGhNcmxaM1N1bzM4ckl0YVIz?=
 =?utf-8?B?Um1PZjFmbHgxRzh2VkQ0SVplWURFOUJoZncrN0lZV0dRSVpnVWlBWkRoYW8x?=
 =?utf-8?B?bTkycHhKRmtIRW1ESFNGbEJFci94RVRpSTVySjlYQWExUzdNS3NFUVJhbGpH?=
 =?utf-8?B?bkdIV2JWR0RLQXBlQ0xFdUdLZUJ3QnNPSE4yWkVacFpLQ04vTzFaNSs5ektN?=
 =?utf-8?B?UlpSS1U5dWdIbDJZT1kzVEJXTzRMMElYR3BIemFxcDJ5RTk1NzdCTldNNk1C?=
 =?utf-8?B?cHhKcTBsVWV6T0VybnBONzg3WEt4YTdDYlVudE4vVFlPQWhONEpINXpYVWlM?=
 =?utf-8?B?QnJtM1llcUNzNzlRdVlZcGdPZVpxYjFja2lJeFRESGc4T3JibWtHeUxkeGpC?=
 =?utf-8?B?a1dPUGhWVzQySGlaTWRMV3lJcHdlS1JQNTI1L05wTGV0YU8rMVY3RytULzFr?=
 =?utf-8?B?L0NJZml0Y3pEVEVwT0NGZ2UwTGZ2U0lvTkR6dm82ckRPNW8wNDYyOVhYNDVt?=
 =?utf-8?B?b2U3MmZxWlFHeVVxQkxVMVc4QU9mR2QwTmZ2Tld3T0lQM2lhdGVYVGN4MUtW?=
 =?utf-8?B?Uk4wdVNway9xdGlMT281SW5lMi9GcGZkYUZwOExXc1krZSt6UGxBRFhBNUhL?=
 =?utf-8?Q?8G7+6EhpZEPQrYuc6A6g+thCbbZtpiqVwLOi9m4?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a2a0fcc-1d08-4782-9c97-08d90c0aaa50
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB3851.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2021 19:03:39.7461
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9wDyyk7wEVdu75CGXPfmyZjt8OvBU0PbhZ3zBlN2FuF9VNtXB5ZBs9qTXS9RuG1qM2NIkH7qVdiQ3y9A4KzGs6YM/9E78I5PG8osYcB3nKQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1257
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9970 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 bulkscore=0 phishscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104300129
X-Proofpoint-ORIG-GUID: i8liezcxjGuBA5TUqDR2BCJQmP-DCb1w
X-Proofpoint-GUID: i8liezcxjGuBA5TUqDR2BCJQmP-DCb1w
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9970 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 phishscore=0
 clxscore=1015 suspectscore=0 lowpriorityscore=0 mlxlogscore=999 mlxscore=0
 adultscore=0 malwarescore=0 impostorscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104300129
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
