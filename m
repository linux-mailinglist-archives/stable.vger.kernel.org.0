Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A89C425CCA
	for <lists+stable@lfdr.de>; Thu,  7 Oct 2021 22:00:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241686AbhJGUCW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Oct 2021 16:02:22 -0400
Received: from mail-bn7nam10on2042.outbound.protection.outlook.com ([40.107.92.42]:38913
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241572AbhJGUCV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 Oct 2021 16:02:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=awvP99yDyAsok4VLaalbiyqS3Td6VvtakhVMzeCs+aY0u01cchHpbulIgbCM0SXx12ERqcaDicQ4m48PrUvH/Pndf0NTKv5kEznaSJrMNoqUFJ0HX3cJ60+95yEUb+SDece8j+qqFoaZfC0XwbDEbEuMfsmW43D4UfHhCTQc93YufqacKS+Si2BTQxtOl0KfGK93uK6mCPtJa7EP83t9eHp+faAIKRVAcGrxU+mWw5A7SGWLrZcu8YuT/3OagTxhhGQqjvGSw7i1ehbE+AXGQuI0cMiuiLAV3LZb3Eyfem7TRLAAX65qAt8mu6SMh2KEQYHOC1zUll/wid5STr1iGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w0R+daDZhzW5md683dZ6ph/xkCumF3ZRJkN8Ie+GQgM=;
 b=YA1U2ozTnfo889c8BQfbO74opql4KY0Gh/AS+YTtJgeqFT7wiaPvft3G8Ec9cJF4HABZcYRvdcd0gw1EX7WzD/1ba6/Q26rhDDgyV9IazKYRN8dWzjeaVcziGqLLlh7mztuANu5pcapKGw4C317sgWWbjUl3izkaKp6i4sW9OMjsPnadTMxJgX7CRZK5VXgspN22XekBMZMH7cJmjChuohRT0IMDxethYE7paKvYn8hoB78veyQec84CKzUXPpg6VjhQf5engnW0Sc5GXyeqo/qVDvHMmRRonwwPEyanTXGE3+gmG7mya9sjO6SUlbPdnjs//47eYrNX3p2f4yC8Gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w0R+daDZhzW5md683dZ6ph/xkCumF3ZRJkN8Ie+GQgM=;
 b=V9lHfn4qW5u4h6MJ+YcFmqKn1BqOLUbgk6bp9Oi4eFyESQL3Lxi0pjKFlxW8MtshBVfnNcePW+XSAaFve2lCzwIBS8+6L5swNROLRk5j60JFvKCYj2kLzYleGYsd9Yq9tsJSn1PCFp2aO5JAJoV2CKQfhX1yt+w/Hbc4ac0xql8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SA0PR12MB4510.namprd12.prod.outlook.com (2603:10b6:806:94::8)
 by SN6PR12MB4670.namprd12.prod.outlook.com (2603:10b6:805:11::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18; Thu, 7 Oct
 2021 20:00:24 +0000
Received: from SA0PR12MB4510.namprd12.prod.outlook.com
 ([fe80::f909:b733:33ff:e3b1]) by SA0PR12MB4510.namprd12.prod.outlook.com
 ([fe80::f909:b733:33ff:e3b1%5]) with mapi id 15.20.4587.020; Thu, 7 Oct 2021
 20:00:24 +0000
Subject: Re: [PATCH 1/2] platform/x86: amd-pmc: Add alternative acpi id for
 PMC controller
To:     Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        Sachi King <nakato@nakato.io>, hdegoede@redhat.com,
        mgross@linux.intel.com, rafael@kernel.org, lenb@kernel.org,
        Sanket.Goswami@amd.com
Cc:     platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, stable@vger.kernel.org
References: <20211002041840.2058647-1-nakato@nakato.io>
 <3ecd9046-ad0c-9c9a-9b09-bbab2f94b9f2@amd.com>
From:   "Limonciello, Mario" <mario.limonciello@amd.com>
Message-ID: <909f28e9-245a-df90-52f1-98b0f63a2b3a@amd.com>
Date:   Thu, 7 Oct 2021 15:00:23 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
In-Reply-To: <3ecd9046-ad0c-9c9a-9b09-bbab2f94b9f2@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN2PR01CA0053.prod.exchangelabs.com (2603:10b6:800::21) To
 SA0PR12MB4510.namprd12.prod.outlook.com (2603:10b6:806:94::8)
MIME-Version: 1.0
Received: from [10.254.54.68] (165.204.77.11) by SN2PR01CA0053.prod.exchangelabs.com (2603:10b6:800::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.19 via Frontend Transport; Thu, 7 Oct 2021 20:00:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dde907fa-d25d-4bc5-2495-08d989cd19f0
X-MS-TrafficTypeDiagnostic: SN6PR12MB4670:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB4670E98EAB8C6A01F46D5967E2B19@SN6PR12MB4670.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i7c+neIWsFDnKGZpFa8rBjDevL08u2BGRTArCRzyKWK2pYD5dT9Dnua8ANaPC3nMRUl1gTrScPSkbJK1REkG7emXWaSA9hI2qXBTkhtb5UpOBLdSpLGqtdUt/56PvS/5RWhjyAfO5Y6RuOPxUMJlahp09dxXJCIvZzS0lIunif1WjlwY+rH1dl++KTlyayFiqBzHVUHbTYmnv9wc5zjuz0oRwzCU3IWA9zraxn1AkKpz4qSqlMnzX5RgjV+JETkr7oIMukT6MOHS/kFu42KutmZfRrhf/58ZWkZbzv/+I/oIsnlhfOKtAG/SSFwSWlGRq85V2OfFPfkapIrNpF9xtmYM3aNmJ2O+oQ335fVzXWp6EKGci2EnOg9wKbNgyZvar/p2hxfJnK88VBVjl65X9i+/lk9u1eJ4hzyEMzSGobEs8cuMe/tBzDaRaqUTv/yxcseXLloPeqycpCBXd0SkxXKgqqMBC9w3jbVY8C6GXukTs1PHtECSeff+BfF8tqei/7yYhlysqAm2gQZ9fOaZhhnXuYyXz0lR1zx0OYn4STw8cGc694g883UuipVgqxIz1VTW/+DpDGWOhyH6HZqIYXVXY8JLvDN9alsXDglX5t4SJ6b4+bQggoaBCc7G8I/QJk1SG0SfpdJUhG6VibpSfAa123ITPEW1PeEKotmKINepnqZPFt1I5jDKw6QferhaG8xPuB6RLa122y8OaL8g1g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR12MB4510.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(508600001)(31686004)(2616005)(53546011)(6486002)(8936002)(38100700002)(83380400001)(956004)(5660300002)(66946007)(110136005)(36756003)(2906002)(66556008)(26005)(316002)(86362001)(66476007)(6636002)(16576012)(8676002)(4326008)(31696002)(186003)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bHBVZFNHaURyY0dTMUxtVzdST01Kdi9Ra1RvY3VYb0J0WTF6emhOMjBtcjdN?=
 =?utf-8?B?QlNIYnJndTRZb0lUenNuc3NJYm9xaDRlMFhDcGxFRlBEbVNMbEREaXhrZnYr?=
 =?utf-8?B?d0d6Z3NDMW4ySjdxWHhXMGV4SHhWaDJnYk9zSTlyQ2xjM2RDNW5RM1RNLzJZ?=
 =?utf-8?B?K0JTSmdBNklHb3FWUSswWEdtTXlUeEp5emg4eHVhL3F4WjJpOVEzNXVnUkdU?=
 =?utf-8?B?SmxPZXpIOXZ2U21hUDdueXhhWlNsNWhQYTUwVGwxT0xCYWkwS0M4dndqUlkv?=
 =?utf-8?B?OW9RbklGZk9pMXMxeGVjQW5qUEJwcm5WQmcwVWlnV2k3eTNMendmOHhqMVZp?=
 =?utf-8?B?NUdWR0g3T0RNdmFoQk8zZy9DL2kxUi9ncWxCcG44WUNQcW5lU3RTdlNWcFZ3?=
 =?utf-8?B?ZXYvVlQ4bE90UWNJT0lqMjZtWGsyR1dLUHJEQU5uUzZac1MxbHBVd0s5VWtV?=
 =?utf-8?B?eWRucUpyaUM2Wnk5VXh2QXVCNjBIWGdmdGRKaFdmNmtweUlOc2ltNE9SUUU5?=
 =?utf-8?B?SXAwTjVOVnR0UC9QQ1VUMXNwVTRsM3Z3WXhKdDRyTjNPempxYVVOaG5DWGJw?=
 =?utf-8?B?U2JJWmlraFlqN2lLQ3ZCRFMxVHp0bkx6dkFpTm15TVNrVTRwWm9SdWUrb3lC?=
 =?utf-8?B?cVlpQmFRQXNxVkVlYlg4RjY5bFAzVEdRMGN0K0lSUDI2V05TSE1tUk1SNDRS?=
 =?utf-8?B?U1BFVGE2VmI2R2NlMjlHSGJUOTFrQ3N4SzAyQUZiaXg3dG01YWlSN2lsZVJw?=
 =?utf-8?B?ZGJPU2MxTmxEZTV5R29pR0xvL1pLQU55MWVKUGIzdjQ1SWhyRGZUSUNCRGh5?=
 =?utf-8?B?b0h5cDFtMVVzTlY3UUd0aTEyZXlXMVVxdHhsTW1zalAwQVViaGxQcFVPRGNK?=
 =?utf-8?B?L1FmYi9FZ3k4WWdpVmMyS0xySHFwVGhrak54S0ZkUnpnbXNEdC85T1M1WGJ1?=
 =?utf-8?B?aEtreTRpcHRYTW4wMVpOWVhTa3R2Y2U5cUUycTFjZmNVYitydlNXOGorbjRS?=
 =?utf-8?B?a1VXSXcyMlNJbFNKT3ppQTZVR2MzdWVXQ3hEYmREdVJEV1EzenFqazlBRlZP?=
 =?utf-8?B?TmNuVE8xTHJkVHo3NGpSMWMrYldGZ0RuMVoydStYRXdFZlpIUG8rYXBJaC91?=
 =?utf-8?B?RjlQVUljTXQybFBIN1hxcW5SN29yK2dRZk1Ta3ltMTFNRDFuL3FSSGRZa2JC?=
 =?utf-8?B?UkZacENVNGNSeEVNUkJ0Ni9EdVZGK0duV2l6WmQ0bkxVa0M2czZsKzdRbzMr?=
 =?utf-8?B?T3hIQm5KL1g3WUUzOTNweFR1cDZRalBkRkd5dHh2Y2pBUEllY2szV1NQTE84?=
 =?utf-8?B?YXBrL0V3dUYzelNxSjRkUTJLOWFScW9MaXNPZTdkWUpGVS9pSEJKblBXVWFl?=
 =?utf-8?B?d01lQjNuLzZDdHFvWFExbFBHVysrbndNQUNRV1RZbkxIVXdXMWpkY24zNkxn?=
 =?utf-8?B?RzlOQkp4QlhvcmNNdmFTNUcxTFRqMkk5L01lZTU5c1FER3lhK05hdlZ6M3RR?=
 =?utf-8?B?R0MrUXdPb1FZRHM4VjhuQWtCWDE5V1poaU84WTRZM0UvVTB1U2lNc3dWRFhm?=
 =?utf-8?B?Y1AyZWNwdGxESjJWemZrVW9kVlZuS0pEcFUxLzZxTHZ0Q3FYVkpTb2JFSTVs?=
 =?utf-8?B?MHhiMmlOWkQ5c2dEaXQ2L2k2RGpmY0lHbDJ1UkMzYnNYRWhDNVZjSnViRjdH?=
 =?utf-8?B?TlNxY3VoWFhGMTlDWG1RVkViekRUU3dFeFI1ZkgrRm5zUFpLL3FZTVZFMmdj?=
 =?utf-8?Q?nChszAaWdqqtrNqcbybGzGCn3tKf19QjLI64qvm?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dde907fa-d25d-4bc5-2495-08d989cd19f0
X-MS-Exchange-CrossTenant-AuthSource: SA0PR12MB4510.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2021 20:00:24.7230
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 45Ie1cTe6Al+v3SMksMy20uGhmADYQHcVfN/bTsl8Cw8QIFr8exS+fQhEfWVWQ7BwbHC3lIn2vv3BunI2QEEuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB4670
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

+Sanket Goswami

On 10/5/2021 00:16, Shyam Sundar S K wrote:
> 
> 
> On 10/2/2021 9:48 AM, Sachi King wrote:
>> The Surface Laptop 4 AMD has used the AMD0005 to identify this
>> controller instead of using the appropriate ACPI ID AMDI0005.  Include
>> AMD0005 in the acpi id list.
> 
> Can you provide an ACPI dump and output of 'cat /sys/power/mem_sleep'
> 
> Thanks,
> Shyam
> 

I had a look through the acpidump listed there and it seems like the PEP
device is filled with a lot of NO-OP type of code.  This means the LPS0 
patch really isn't "needed", but still may be a good idea to include for 
completeness in case there ends up being a design based upon this that 
does need it.

As for this one (the amd-pmc patch) how are things working with it? 
Have you checked power consumption and verified that the amd_pmc debugfs 
statistics are increasing?  Is the system able to resume from s2idle?

Does pinctrl-amd load on this system?  It seems to me that the power 
button GPIO doesn't get used like normally on "regular" UEFI based AMD 
systems.  I do see MSHW0040 so this is probably supported by 
surfacepro3-button and that will probably service all the important events.
