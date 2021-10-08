Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17EFE426E2E
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 17:57:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243056AbhJHP7p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 11:59:45 -0400
Received: from mail-dm6nam11on2061.outbound.protection.outlook.com ([40.107.223.61]:20224
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230365AbhJHP7o (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Oct 2021 11:59:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gz8Tj/LiGw+9fBJRxM/0Gbjk/MzNVVky0wtFljncNGmCoL+SDObMHu+LvLukvM65EtQPqSP3ww2k3T4rDtDmXY7E8WDj/uJJT8yA1FAsAqc0cgTOmyjQHbog+aNEGpczLL0yCsbwQdlrDXfvu51T95WesjBEW8sgahXPrOlyPrHF8cjMg4NWHiC9dAZQa60n+/tvAjzG/yTSLpebWKPMWBdfYwnm5eULi6aO/A1X9IcDylM2dETkfmYcmOp59e1aNF8wc1n5O27EvOhPKBLhTNTY2UyGBWbUdZdtO/QXas/cNP9l+K/u3sywhiOidykqnklTRfVah/tVtI4EsP1Nkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1nvPWS9KF0+rXEfO4d5vUfSfUW9Jk2+Q6fbb/EmlOhM=;
 b=YZ1tPDewSoupBWLi3BdCyLbDDy4kFBUTKI4TIx2ofHk9/HXWQ4moGA9GIWuLQK2finIhUZBnsX3MLMx4obYKo7atZrpaZB4Ie76fKqxEj8W8ZodVZmoQXNvXfppb9+/j/hWpglLLJxy57hhUHGA95ROdrU5yJx1aZIB5LYwuyZNtrEeDL0ckR5fdRR7J7B5nQLe8viqOP+A9Ad3wqTlq+MiQRA+p8YhJM0piSxH4cVmrXlPCt/WZAECkggwcG3NxpR+9djAgxnEVJvwXPQa5ISaKtX2bQusmQeuO4aLnpFX55SMzyy+W7Gp4sTNMb/HD7SqjfdCqD+JVVGKxR3Ycbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1nvPWS9KF0+rXEfO4d5vUfSfUW9Jk2+Q6fbb/EmlOhM=;
 b=oHe7LcrUtbnIRBiNOXNLmLBYNa0t/eqO60tmWrOkAYUfv7GXQzXXWo/wANykbLaSXPWQuwrnjX5ZM08Z8QjaaASC0N+lUz7ky6vFVIvT+aStQgUKAJ89VV3LCEVMsGMTh+rBrykRipyYjewVMg/DqR0ONzuHa/m4wpBolJYDqXw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SA0PR12MB4510.namprd12.prod.outlook.com (2603:10b6:806:94::8)
 by SN6PR12MB2782.namprd12.prod.outlook.com (2603:10b6:805:73::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.19; Fri, 8 Oct
 2021 15:57:46 +0000
Received: from SA0PR12MB4510.namprd12.prod.outlook.com
 ([fe80::f909:b733:33ff:e3b1]) by SA0PR12MB4510.namprd12.prod.outlook.com
 ([fe80::f909:b733:33ff:e3b1%5]) with mapi id 15.20.4587.022; Fri, 8 Oct 2021
 15:57:46 +0000
Subject: Re: [PATCH 1/2] platform/x86: amd-pmc: Add alternative acpi id for
 PMC controller
To:     Sachi King <nakato@nakato.io>, hdegoede@redhat.com,
        mgross@linux.intel.com, rafael@kernel.org, lenb@kernel.org,
        Sanket.Goswami@amd.com, Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Cc:     platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, stable@vger.kernel.org
References: <20211002041840.2058647-1-nakato@nakato.io>
 <909f28e9-245a-df90-52f1-98b0f63a2b3a@amd.com>
 <609f5254-4527-38b8-3d1d-5cb06791e103@amd.com> <1837953.FDaK0lLtFO@youmu>
From:   "Limonciello, Mario" <mario.limonciello@amd.com>
Message-ID: <42e9a7d0-536f-bd15-0c4a-071d09195bc2@amd.com>
Date:   Fri, 8 Oct 2021 10:57:44 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
In-Reply-To: <1837953.FDaK0lLtFO@youmu>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0501CA0076.namprd05.prod.outlook.com
 (2603:10b6:803:22::14) To SA0PR12MB4510.namprd12.prod.outlook.com
 (2603:10b6:806:94::8)
MIME-Version: 1.0
Received: from [10.254.54.68] (165.204.77.11) by SN4PR0501CA0076.namprd05.prod.outlook.com (2603:10b6:803:22::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.4 via Frontend Transport; Fri, 8 Oct 2021 15:57:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 16ac969a-456c-43a4-2f17-08d98a745f01
X-MS-TrafficTypeDiagnostic: SN6PR12MB2782:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB2782F2AA3D0B8CD5C9751802E2B29@SN6PR12MB2782.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BWbya0wUXn3d5Of9PY5HBNXEyI7hO6Du4Fp/lubQqiTlJ5QRXp7QHBRJLIQ9848ntiK/HAUG26I8CQe/ZZLHxpLIH88qKH0VlIUJVd9x6xBn/4h6Rw+JCg2Vv7ymwWRWaVhxJW05ZuQhEZ5jkT9DmqEq5+b3uLN02wQGcVAMENRBfE5Fl3+iRz+dkSLjXehYuOjnoh5f7g/fv+D6OXlRL5MAgFH7wz7ipn4/ULWI5ltcJFc+K8CzATPEpCWMB6GPrhGz0jbwKJQwlF7SE2PcmKLZBLxbDfl/7d4LJwtdVfhZL//4HrMSmb7UclV0gC7vjCFVbjkcmjGillT9Kua+cZBUm5aDGBGDlnerTkNZW5Wl6gzpWoIqEKnMalxBjApAl5DDVsDGTMAU1UJcJ4TOISg1a/kTK+4boET5aSHJLilwb1W1MXbWQV0TO1f/RfKfOt0KP1IwVLLjIGumEL/wd0E2HxVvObjMY08HdSR8GjaXRv1jQg+5llV5zaZKDhmx8fjHTPqG3mzCNWCrw0JWh9onKKXU4+rJH+23RinkyYKqk/K42PGPpa4emSnG50AGgDYXihmuWX8B9SnV0ETHoxk45fqYXFvpDfs/iwj1gweIxcNGRAbTxc8jBgUVkcNRtUUeyIyOW8oTcWvh6g8q0dTgNdnwF0x0tMg6yDbO1Z5SzRcqutqQFOi1UBCjv2E7Gt5sbVoSg87xeU0WRXf8ka4ESCMCWuDuCvJ+1MNLGrqyFqIoR2GfapDggHHeDVPxngfbP39CkCWiqEB2sdzzGYVd+rSKdCBi+QzldIj6fkQc92Ei1yibFLSsHWFJSwc7+YGuoCZG6j9WfNuEp6LQgGSRkNapgAxf+0vsqSVLon0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR12MB4510.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(31696002)(6636002)(26005)(956004)(508600001)(2616005)(110136005)(53546011)(86362001)(36756003)(8676002)(6486002)(316002)(66946007)(186003)(45080400002)(66476007)(8936002)(5660300002)(66556008)(4326008)(83380400001)(31686004)(2906002)(38100700002)(16576012)(966005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q3p6bVhrRXZJRW81bkkrbXFVVVFXTFFWNVdJRnFPanEvZm1ucGErRHIrTEZu?=
 =?utf-8?B?SW5QdHRjSE9pc2ZMQ1FXVjFRNEhqdzA3TUtlMElwZHA0WkFGbStraDhmMUlp?=
 =?utf-8?B?ZE9ON2JwOVZMdjdEdlNhQ1hNOHJlNmsxU05uVytoTS9EanZsVXJVdUhLdHI3?=
 =?utf-8?B?NkE0NlQvVURSVENKOHN2OE9QWVREVzlRZHY2SzJsbFFyK3JraUVRWkdxeCsv?=
 =?utf-8?B?VXZYcXg1azN1ZXF5MGxHSDhWbjJlSHdaVmhmeDFERnJmbDNyRGYxbjRqVndU?=
 =?utf-8?B?RkY4bFRJWHNNYUIzZEk3OFNiUCtPMXVvZmIwSnc1OGZzL2ZiYnpyRXlUSTIw?=
 =?utf-8?B?dTFmeVdtWWlndXRHNG1TTDZrMGlmdmhOSmV1c0tEMTdBblBlT0JhWEtsM0Yz?=
 =?utf-8?B?R3JwYnl6cWNSYlVWMHdUMkM2MWg1K0FucllMdW9KSGYvVG9oRHE2YTM5U0JJ?=
 =?utf-8?B?N1V3SjhLeUZxcnlUTTBtNVpkQVJtajZlbGhwNFJ4VlpLZ0JzOUlSdjNUMDlY?=
 =?utf-8?B?Z1diZUVWaHExMDNGajdpdFZBaXlXczZ5L0dyQkwwdjc3aE1zcE1vQnlDa2Fj?=
 =?utf-8?B?d1RZM1VjNmVFamR2Nko0em1NY3QxL3V0bkNlYXVIcVowa2F6bVp2TndqOThK?=
 =?utf-8?B?NlFaMGRCcjlzaDMvT2FoYXNySTJDVXZ0ZGs1RXF5bm5zK0V0bkdxejRVYnFr?=
 =?utf-8?B?Z0VyamlkYmZ5V2lSdEZrQXdJWlp4d1oxbjJFK3htQWt6MmU0QnJhTkx4NFJM?=
 =?utf-8?B?WkpBeG85cXhuMkt0c0lpOUcwM25DWXRTNS9JVVhxVXpVemhQdWxIWHZKbjJT?=
 =?utf-8?B?Q3hpUVZTSWE5WGxsTVFOUkU5U1lVeVkvV2JTeEpVT2tuaTkzNk5NZlVhaWlv?=
 =?utf-8?B?NXdzUHdnQmMxbDNQSlZUWEhtcndYczByanVjM1J4MnIvaXJPMGh5NGdObE1p?=
 =?utf-8?B?TVlEM1IzQTRaelZWK2hXbWc4ckh2NXF5S0hrUkd6WkFGM04waDZBdmwzbTU5?=
 =?utf-8?B?TUQyaEo1ZG95V3hGLzVTcVJEQTk0dmNIRGpWbUpYMXpweTJ0c00vZVFUVjQz?=
 =?utf-8?B?YlZESEtsVFYvYXdZTUkxYTVlaU9RUWY1N05aK2RiTDBCVUFST0dRbmJJV2gz?=
 =?utf-8?B?cHhsUlZ0VnFnTmpSYUxNVWN6WWpNazRPc2svT2s0Ukt0Qno0a1dGWGUyeTRi?=
 =?utf-8?B?Q2FCeFBjNngwNlRvVFJPZURuYzRMeWl3ZnNhbW90T05iNE1DRHB4VkRjWmxJ?=
 =?utf-8?B?MkYwYzdYanZnd2VRMkFpbFlaWjJ5UlQvaUFIdFFISHRyWGJ3cXUzVFZ6aDBR?=
 =?utf-8?B?cDdhNzBWOVp0bDZTTVo0TEdBVzByL0hBOUpQZm5vb1NEVDRUbmsyZnF1UzQw?=
 =?utf-8?B?SzdiNHRjUTNRQktyOEcrR1BSQU14RWtIMVd2SHQzREk3eTFiNFNOMCtZd1FP?=
 =?utf-8?B?VTVlNzJ6VEdZQWNKaDF3UWxtVWJCeG5LUzdiOUswbUh4Wnc3cHVYa0RBajNS?=
 =?utf-8?B?UjJNSnptUStMcjZVSUhSSkR5aE1FRkwrWEZXNWdOcmtpcjg3M1NUR3lWR3h5?=
 =?utf-8?B?UmtpemF6bWFGbHZlUTRxd2J4c2tod0dUR2pSL0I2ZHl6ZWN3OXI5UjBiNU1a?=
 =?utf-8?B?ZUlsWGVheThDdDJqNDhweG9WZUNDb1BEMUVvQWtZWTRyUXNEWmZIaWNjWDhz?=
 =?utf-8?B?UzZ4eXQ2UDhRV3hEWnN2MEVXTi9OdjREU01CQnJ6K3kzVVJhUlNURDN1Z0FL?=
 =?utf-8?Q?b3ssS+obHfZhANqEXJC3EhX3B3aUCUTFeS6iJlo?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16ac969a-456c-43a4-2f17-08d98a745f01
X-MS-Exchange-CrossTenant-AuthSource: SA0PR12MB4510.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2021 15:57:46.6180
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 62fWvfOqnOCyYjLJs+CN3ZP39Dvddre7V4UGGv9NIOQEJYLCCn9muRuXnxRv9CRsSrXkk+/zoQDgGpqimN4kzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2782
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/8/2021 07:19, Sachi King wrote:
> On Friday, 8 October 2021 21:27:15 AEDT Shyam Sundar S K wrote:
>>
>> On 10/8/2021 1:30 AM, Limonciello, Mario wrote:
>>>
>>> On 10/5/2021 00:16, Shyam Sundar S K wrote:
>>>>
>>>> On 10/2/2021 9:48 AM, Sachi King wrote:
>>>>> The Surface Laptop 4 AMD has used the AMD0005 to identify this
>>>>> controller instead of using the appropriate ACPI ID AMDI0005.  Include
>>>>> AMD0005 in the acpi id list.
>>>>
>>>> Can you provide an ACPI dump and output of 'cat /sys/power/mem_sleep'
>>>
>>> I had a look through the acpidump listed there and it seems like the PEP
>>> device is filled with a lot of NO-OP type of code.  This means the LPS0
>>> patch really isn't "needed", but still may be a good idea to include for
>>> completeness in case there ends up being a design based upon this that
>>> does need it.
>>>
>>> As for this one (the amd-pmc patch) how are things working with it? Have
>>> you checked power consumption
> 
> Using my rather limited plug-in power meter I measure 1w with this patch,
> and I've never seen the meter go below this reading, so this may be over
> reporting.  Without this patch however the device bounces around 2.2-2.5w.
> The device consumes 6w with the display off.
> 
> I have not left the device for long periods of time to see what the battery
> consumption is over a period of time, however this patch is being carried
> in linux-surface in advance and one users suspend power consumption is
> looking good.  They have reported 2 hours of suspend without a noticable
> power drop from the battery indicator.
> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fgithub.com%2Flinux-surface%2Flinux-surface%2Fissues%2F591%23issuecomment-936891479&amp;data=04%7C01%7Cmario.limonciello%40amd.com%7Cb95422d699a2496a56f608d98a55e888%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637692923846585025%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=MND10b0iIblTgywFsxoLNx7D1bZuLZOmbqbhQJiezxM%3D&amp;reserved=0
> 

Thanks, in that case this is certainly part of what you'll need and it 
sounds like you're on the right train as it pertains to the wakeup sources.

For both patches in this series:

Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>

> 
>>> and verified that the amd_pmc debugfs
>>> statistics are increasing?
> 
> s0ix_stats included following smu_fw_info below.
> 
>>> Is the system able to resume from s2idle?
> 
> It does, however additional patches are required to do so without an external
> device such as a keyboard.  The power button, lid, and power plug trigger
> events via pinctrl-amd.  Keyboard and trackpad go via the Surface EC and
> require the surface_* drivers, which do not have wakeup support.
> 
> 1. The AMDI0031 pinctrl-amd device is setup on Interrupt 7, however the APIC
> table does not define an interrupt source override.  Right now I'm not sure
> how approach producing a quirk for this.  linux-surface is carrying the hack
> described in
> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore.kernel.org%2Flkml%2F87lf8ddjqx.ffs%40nanos.tec.linutronix.de%2F&amp;data=04%7C01%7Cmario.limonciello%40amd.com%7Cb95422d699a2496a56f608d98a55e888%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637692923846585025%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=5dWwpgh%2FRIA%2F57UpY5h0l9Snzem%2BNpirgE6ujEHO7aY%3D&amp;reserved=0
> Also available here:
> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fgithub.com%2Flinux-surface%2Fkernel%2Fcommit%2F25baf27d6d76f068ab8e7cb7a5be33218ac9bd6b&amp;data=04%7C01%7Cmario.limonciello%40amd.com%7Cb95422d699a2496a56f608d98a55e888%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637692923846585025%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=HPZfqPoVUJT8w%2FRD7UaVjegT0iRLDlRkXfOwMx5HS8Q%3D&amp;reserved=0
> 
> 2. pinctrl: amd: Handle wake-up interrupt
> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fgit.kernel.org%2Ftorvalds%2Fc%2Facd47b9f28e5&amp;data=04%7C01%7Cmario.limonciello%40amd.com%7Cb95422d699a2496a56f608d98a55e888%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637692923846585025%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=gUtHcFKolVIZeHtIIJuT3BkruQbjq8NAOU5504%2F02Mg%3D&amp;reserved=0
> Without this patch the device would suspend, but any interrupt via
> pinctrl-amd would result in a failed resume, which is every wakeup
> souce I know of on this device.

Yes that was the same experience a number of us had on other AMD based 
platforms as well which led to this patch being submitted.

> 
> 3. pinctrl: amd: disable and mask interrupts on probe
> Once I worked out that I needed the patch in 2 above the device gets a lot
> of spurious wakeups, largely because Surface devices have a second embedded
> controller that wants to wake the device on all sorts of events.  We don't
> have support for that, and there were a number of interrupts not configured
> by linux that were set enabled, unmasked, and wake in s0i3 on boot.
> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore.kernel.org%2Flinux-gpio%2F20211001161714.2053597-1-nakato%40nakato.io%2FT%2F%23t&amp;data=04%7C01%7Cmario.limonciello%40amd.com%7Cb95422d699a2496a56f608d98a55e888%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637692923846585025%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=mwJgcXBY9zdlTG671KssViHdSwHfq6DCJ2fpeLbRbR4%3D&amp;reserved=0

We'll have to take a look at this to make sure it's not causing a 
regression for the other platforms the original patch helped.  If it 
does, then we'll need some sort of other messaging to accomplish this 
for the surface devices.

> 
> These three are enough to be able to wake the device via a lid event, or by
> changing the state of the power cable.
> 
> 4. The power button requires another pair of patches.  These are only in the
> linux-surface kernel as qzed would like to run them there for a couple of
> releases before we propose them upstream.  These patches change the method
> used to determine if we should load surfacepro3-button or soc-button-array.
> The AMD variant Surface Laptops were loading surfacepro3-button instead
> soc-button-array.  They can be seen:
> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fgithub.com%2Flinux-surface%2Fkernel%2Fcommit%2F1927c0b30e5cd95a566a23b6926472bc2be54f42&amp;data=04%7C01%7Cmario.limonciello%40amd.com%7Cb95422d699a2496a56f608d98a55e888%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637692923846585025%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=PGWON0kCpByJtsO1rS9wrYr7oH86V%2F8M%2FYLmUoFjBhM%3D&amp;reserved=0
> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fgithub.com%2Flinux-surface%2Fkernel%2Fcommit%2Fac1a977392880456f61e830a95e368cad7a0fa3f&amp;data=04%7C01%7Cmario.limonciello%40amd.com%7Cb95422d699a2496a56f608d98a55e888%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637692923846585025%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=B%2BBW3M4L5TLCq3Fc6oB0KHaC9A%2FQp3uwkB2Jby%2FdDo8%3D&amp;reserved=0
> 
> 
>> Echo-ing to what Mario said, I am also equally interested in knowing the
>> the surface devices are able to reach S2Idle.
>>
>> Spefically can you check if your tree has this commit?
>> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fgit.kernel.org%2Fpub%2Fscm%2Flinux%2Fkernel%2Fgit%2Fpdx86%2Fplatform-drivers-x86.git%2Fcommit%2F%3Fh%3Dfor-next%26id%3D9cfe02023cf67a36c2dfb05d1ea3eb79811a8720&amp;data=04%7C01%7Cmario.limonciello%40amd.com%7Cb95422d699a2496a56f608d98a55e888%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637692923846585025%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=XdRCk8klBuDRCk7UWL%2Ft5wiupVVgdCWBqFmaYgGK%2BFU%3D&amp;reserved=0
> 
> My tree currently does not have that one.  I've applied it.

You should look through all the other amd-pmc patches that have happened 
as well in linux-next, it's very likely some others will make sense too 
for you to be using and testing with.

> 
>> this would tell the last s0i3 status, whether it was successful or not.
>>
>> cat /sys/kernel/debug/amd_pmc/smu_fw_info
> 
> 
> === SMU Statistics ===
> Table Version: 3
> Hint Count: 1
> Last S0i3 Status: Success
> Time (in us) to S0i3: 102543
> Time (in us) in S0i3: 10790466
> 
> === Active time (in us) ===
> DISPLAY  : 0
> CPU      : 39737
> GFX      : 0
> VDD      : 39732
> ACP      : 0
> VCN      : 0
> DF       : 18854
> USB0     : 3790
> USB1     : 2647
> 
>>> /sys/kernel/debug/amd_pmc/s0ix_stats
> 
> After two seperate suspends:
> 
> === S0ix statistics ===
> S0ix Entry Time: 19022953504
> S0ix Exit Time: 19485830941
> Residency Time: 9643279
> 
> === S0ix statistics ===
> S0ix Entry Time: 21091709805
> S0ix Exit Time: 21586928064
> Residency Time: 10317047
> 
> 

Yeah these look good, thanks.

>>> Does pinctrl-amd load on this system? It seems to me that the power
>>> button GPIO doesn't get used like normally on "regular" UEFI based AMD
>>> systems.  I do see MSHW0040 so this is probably supported by
>>> surfacepro3-button and that will probably service all the important events.
> 
> We require the first patch listed above to get pinctrl-amd to load on this
> system, and the two patches mentioned in 4 so we correctly choose
> soc-button-array which is used by all recent Surface devices.
> 
> 
> 
> 

