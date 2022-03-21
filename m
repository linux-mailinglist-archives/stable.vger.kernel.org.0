Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B4474E277F
	for <lists+stable@lfdr.de>; Mon, 21 Mar 2022 14:30:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242201AbiCUNcO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 09:32:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244205AbiCUNcN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 09:32:13 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2067.outbound.protection.outlook.com [40.107.223.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92391396B9
        for <stable@vger.kernel.org>; Mon, 21 Mar 2022 06:30:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VAZy0S4YZuJboUXXxFN+F19yY/YN4HDEQrG7NlrkQbxCyTaTXrmhUXtWdisvSJkUNJMUE+6xBKZOuXXP9qBwseS7Z6iCbUKq4/781XY2FDZd4CTuzMXI2igHZA95AYFxc0R17YExR3uLt+LqGMVwy98Najx+Mw1/plaw2FzPGDBmemICJ94V4KxXdKao8dBgIHbnZqqPdGlMGDKwBfkpr+yv6MFrQItSvHVv0NFu64lVEtv/86kBe1As8++21eQsRJ8b9LPYgn1t2aekwNDO8cb/697iet9Bq4cwqDAXjQ69QYRptZHrHJBv0oCW8wvO91jaYImepwinVa/Ni4V0aA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GxdBPUMqaOyzc1aXuK7YcOaYY7vAg5QoUSt6uCzAZ8o=;
 b=D6taSxidSJXk84jFSJmrnEyBvOuqhwtu6bPSskSCIS3Dv22mzAc5qv5P9alm81lq0vUWzNlFVG6nD642oqZZCKpeUFuy4TaUodKyCZZD1xE8tkqcJsa5gBlmfpjZu8zQXKdFtTIokW956FbtDTd7rql3yQ/7wcFkp+gs5Vvu038jP2HwS6IDn6vH7+EyQxSGao6VVaIajJS+xeygyS+KOZfBw9+WNwkC4n51I/tEUFdtszOBA+/48e5vKItMrQsxBWS5GIU14Bw+uemy86d8psGyVRl4DA9EHb5fN4oXwF/6JVnLXNUPG7BtQ40ZZ09FPZJ+IT2bmM/e8cw1D8VkjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GxdBPUMqaOyzc1aXuK7YcOaYY7vAg5QoUSt6uCzAZ8o=;
 b=aHr+7nBgPCRqWmThf9dNuGv/1cy8gAB1kC9W537oaOeJ9DS6CWx87lYxEInHpntRu8sO5mnvSU3g8RT+n5Oeg56YIjRjgWLfd1PMTcercDULicgl6xGORmGJnKu5N4hQ1M9vWwSoXnWo7DNAqRyTfgF1ZCF3NZO9YPIBHfGWCK4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by SN1PR12MB2400.namprd12.prod.outlook.com (2603:10b6:802:2f::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.14; Mon, 21 Mar
 2022 13:30:44 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::1946:2337:6656:ae2e]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::1946:2337:6656:ae2e%9]) with mapi id 15.20.5081.023; Mon, 21 Mar 2022
 13:30:44 +0000
Message-ID: <5ca779bc-91c9-054b-da3a-b80a2d83dd2c@amd.com>
Date:   Mon, 21 Mar 2022 08:30:42 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v2] x86/sev: Unroll string mmio with
 CC_ATTR_GUEST_UNROLL_STRING_IO
Content-Language: en-US
To:     Joerg Roedel <joro@8bytes.org>, x86@kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, hpa@zytor.com,
        Joerg Roedel <jroedel@suse.de>,
        Brijesh Singh <brijesh.singh@amd.com>, stable@vger.kernel.org
References: <20220321093351.23976-1-joro@8bytes.org>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20220321093351.23976-1-joro@8bytes.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR04CA0098.namprd04.prod.outlook.com
 (2603:10b6:610:75::13) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 738336a2-0ef1-4573-5a19-08da0b3f0072
X-MS-TrafficTypeDiagnostic: SN1PR12MB2400:EE_
X-Microsoft-Antispam-PRVS: <SN1PR12MB24008F26DC176E9FA127CC38EC169@SN1PR12MB2400.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5yJPsNoAA+5cm2UKjlBa3jhZQMNR9+PjyeFE765xSI2HM3IE7fWJd5zZRIyBqOanxV2NRJ+vBWvTEAIX9aoJTRs74uRWCg1Tb5B2St7Qv+0yR9KXlyZvxLvwNSXJRl8fG9dSfLmXEMgAz/wn2LR6oQHZ2T3r72tAqVIrspleWbSAdMWAHUVUr/rGOmUqXaTkbrBKnfaaVLLugtjBb5e/hY3DMq2xrPCq5JkWrHiuzBrDNkHXenDRlhAFPr7TB8cI/Mh3CQw1ieF2qzUWqOMLRx2w/jUfMkO9iGITdwTFe72XUu9rIi2D1IXuhX7ccHeJmuohAHmItupu8uGuCZuZ8G0dYF9awD2k/gbdqv6Pe+ijigWPBbDab01FfqFhjxYvxNK8labt8qUpkKhuYlkzdQXxzBAIyZkQ1lKgf0dMvQgCXdGqZeBa3eCgKNEY0VJ6g5ofWZrZMkTGqhaxiDwRHrA5CydeIk37dYhkiZ8xVOMLAIFH8QD7NFFpnOYV1VHQoxsNW8S5z2sxnMAk56s/0Kna0hnlWGJKtmbHKSYdrM6Ti/Lwm3q+/gn2e2DXTCsac4EKIKih+d1kldFKN2SBHrCTfu30dCn7bi6VEseB37364En1KwbIz5eoUQZFibIu0P8zVIkpDC/MPvMJyu7C3KYzWybReD0OC9AxixWxF2l7XpjJollwAvTiC3kTIcmDKmS19BVV6zDaxQQREFq6ehl3InDsjJgsyK1PsM7tjaE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(186003)(6512007)(6506007)(2616005)(31686004)(31696002)(508600001)(86362001)(6486002)(26005)(53546011)(83380400001)(36756003)(4326008)(54906003)(38100700002)(316002)(5660300002)(66476007)(66556008)(66946007)(8936002)(2906002)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UjZJSUgxRENOYkNjdGVyVWh2ZitSbFF3ajNjRktnZnk3MlVjbHZEck9mRmdr?=
 =?utf-8?B?aS9hb3EvVU1MN2RZcGlJMUpNN2RtdVgzUTR3alNDMU1DbDVxYlprS3BPUFRz?=
 =?utf-8?B?b0hhN29iNnlUZWlFNUVKdmZpbHBqTFBnS0lNVWc1b1ViUGhrTHRkelF1SGZR?=
 =?utf-8?B?d2I0Z0J1TVlLdUVvS0hKK25RV3hudXNWRjZQNmRDV0VOQmdOSHgwWDhUbnpu?=
 =?utf-8?B?em5OcDN0cHRKUnVUajRObUJOb0Y1bm5qVHViZlNBQzdaS2RYNVBFRXNHYXRT?=
 =?utf-8?B?WENpTmMyc2pIbi9RS3kzSXVLQWZBSUVHZisrWlRuVWZLb3hteWFpR3RlWDdr?=
 =?utf-8?B?NE0yMWQ2NjhZcUVIak05WVp1c0R1NUxtMWN2WGJhZldiSjh3MGFMcVRVSTlV?=
 =?utf-8?B?MVRnUkZKRjZNaWhLM2lJdGl0TEJXWG9lbHVPQ0FpT2FqNjFUMnpkaU9YMjE2?=
 =?utf-8?B?YzBYdzF2NEgxNXlVN0hhcVl0QTNkNHpRZEJ5cFgwOW5ucXFVV01SWU1ENFpJ?=
 =?utf-8?B?akoyekRvOEZiSERnd3NsbS9adDdsTnYwcTZKbXZpd2hEUDJpQ09vTERGOFE4?=
 =?utf-8?B?Z2M4RDkxYk9DL1doNEt6cDB3bmJ2dEhwNGp1TTJWNHdMWDV2Kzl4cW9tMWhH?=
 =?utf-8?B?dG1aeWVuWmNRUnRhV2R3Z0thcjRmZTBhOUI3M1gvV2VYU25jSUpUQktsSzdi?=
 =?utf-8?B?RG0xeGMyblhFeVk4cklYaktSMEdhZEJMelR2VTlNbmFQYktKb0xVK2dvSnhi?=
 =?utf-8?B?TnZjc201YU5mdGpBOTJBcUJmS2pUcng3QktSOHF6b09mcTlnY1ZaUmdyV3Zn?=
 =?utf-8?B?NmR6Z2s0ZUdEak9hNUdHQ1F6YUpEdCsvbk40aXpHYzBxc2c4TGYxK3k5Qzlo?=
 =?utf-8?B?cFJjSzRxWGM4ZW5vWVpZS2plWDM0RlZGQ1ZoTFVCTWZnekN4Z1RyTCtmdTdm?=
 =?utf-8?B?TEtNOU9OVERkWVcva0trL0lXOGl0TWpUdEtXSnBDdE5EVjQvNm5FbElGbnN3?=
 =?utf-8?B?aFlyMTdlN3JMQ1BGWUp2OTExU3d3MkVLRWxOejBYSXRlZmlwNVVTV2NvU2dF?=
 =?utf-8?B?ZVRtUkI4T0dnS0s4VWxNNFNTRGFQTzRDNVJIQUE4VnR3SDBlblVTazVCNkNa?=
 =?utf-8?B?Q01FTzcwYmlVUVFxMUtqY24rNUdPdlNPU1Z6QUJYbndjWXptcVZPR3Vma3J6?=
 =?utf-8?B?VzFQUkRZUlVGdW1jNlA3bjV1U3NiV2Q4bDdHc2hXMjdvVVJhdm9XeU91YTYy?=
 =?utf-8?B?WUVaNXFKbUd4akorRng4bGtESmdiRCs0OGYrcXVZQ1lkSEgrUHJyTXcwdGRT?=
 =?utf-8?B?c1ZvQktpOU43Lzl4V0hGWTVIS29QVktoUVdDM0FiWWU1MHFlMWNPR2ZlL3NK?=
 =?utf-8?B?UlNTTEhsc0Z6cDlYd01hTmU4VnNDbHZ1SGV4UFcyZzhOOXo5R3haUU92Qlkr?=
 =?utf-8?B?ZzVqT2pxNzJudzl4RzZPYkwyQkR3Z09OQUVWdVVMWFdNbitvZWdvdU1yeUpX?=
 =?utf-8?B?ZllhK1FYcVlxMExyeUExSU4wa09BMTZNdUQvNlpYUmJwNXIyN2hyaHIrTWJl?=
 =?utf-8?B?U0dnVGl4S3l2eUpXMnVXaFhMVFRQVWthb1RRUEhkOFJWUmJ1VGpkSVlxRmtP?=
 =?utf-8?B?enQreVh4bnlYbXRoTmdiWnVoWWVGZDluemlzaDB4UGdXSmUvS1l2cjNrMmZM?=
 =?utf-8?B?Y1p3TjdPdFdpTmpCbDV3cGJkaTZYN0VaMHVzY2xJTWRFZEpkcWo0UTg3ZU5W?=
 =?utf-8?B?TjRPZ2dleHRyVGVSVnZySUVrd2dLVjg0VmlLUWZydWZnNlRXeEJNU2c3M3RZ?=
 =?utf-8?B?VDREWHVBdTJZWWt2OHNxMUdaSjVwb3R6b293bDBKc0VKdHhRcDFDZGdBYXBG?=
 =?utf-8?B?K3NhcjVPZDRWOHRuMEJHbU9NekhjNjM5dHQxSGdGQzhKOVFPNC8zekJpRjJR?=
 =?utf-8?Q?zT+5UcFGo90OpsptLgdJXfbPzZNbz0Oj?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 738336a2-0ef1-4573-5a19-08da0b3f0072
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2022 13:30:44.6091
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4KLcPcFgLHfExsyjjr4xzvtfBQ8+9QXT9uuxWfSwu6YCIxSib0U89UID4Kdxn2ixYPB3n2Kz3Vr6dq60mPkCOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2400
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/21/22 04:33, Joerg Roedel wrote:
> From: Joerg Roedel <jroedel@suse.de>
> 
> The io specific memcpy/memset functions use string mmio accesses to do
> their work. Under SEV the hypervisor can't emulate these instructions,
> because they read/write directly from/to encrypted memory.
> 
> KVM will inject a page fault exception into the guest when it is asked
> to emulate string mmio instructions for an SEV guest:
> 
> 	BUG: unable to handle page fault for address: ffffc90000065068
> 	#PF: supervisor read access in kernel mode
> 	#PF: error_code(0x0000) - not-present page
> 	PGD 8000100000067 P4D 8000100000067 PUD 80001000fb067 PMD 80001000fc067 PTE 80000000fed40173
> 	Oops: 0000 [#1] PREEMPT SMP NOPTI
> 	CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.17.0-rc7 #3
> 
> As string mmio for an SEV guest can not be supported by the
> hypervisor, unroll the instructions for CC_ATTR_GUEST_UNROLL_STRING_IO
> enabled kernels.
> 
> This issue appears when kernels are launched in recent libvirt-managed
> SEV virtual machines, because libvirt started to add a tpm-crb device
> to the guest by default.
> 
> The kernel driver for tpm-crb uses memcpy_to/from_io() functions to
> access MMIO memory, resulting in a page-fault injected by KVM and
> crashing the kernel at boot.
> 
> Cc: stable@vger.kernel.org #4.15+
> Fixes: d8aa7eea78a1 ('x86/mm: Add Secure Encrypted Virtualization (SEV) support')
> Signed-off-by: Joerg Roedel <jroedel@suse.de>

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
> Changes: v1->v2:
> 	- Addressed review comments
> 	  - Call memset directly and remove the string-wrapper
> 	  - Add section about tpm-crb to the commit message
> 
>   arch/x86/lib/iomem.c | 65 ++++++++++++++++++++++++++++++++++++++------
>   1 file changed, 57 insertions(+), 8 deletions(-)
