Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B44067E82C
	for <lists+stable@lfdr.de>; Fri, 27 Jan 2023 15:23:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230004AbjA0OX5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Jan 2023 09:23:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230458AbjA0OXz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Jan 2023 09:23:55 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2085.outbound.protection.outlook.com [40.107.237.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C4CE84940
        for <stable@vger.kernel.org>; Fri, 27 Jan 2023 06:23:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h90TVY4uzsxjPPpEpA1z1OnQh5Rs5yV5hfPM/POEvKRxGQOdwnOXmDusC+0+lQKawaygG8r3NODBEAHNC9W8Ij2TXsqT7GOE4UfGNK9AhMK93lmEkJOJC9SYd78gqj30UhI1cDKgTuFZsAdDDrrqMeKWZ/PQn6XiVHsuEvPIwDBZcnWGIPHmGO50WsOOUke7VnjfNRfpG2eetc6eRW927Ix9xxYs/MGh3hvdglLzJ2BvN0mpeM1Ki6XkQEII3rJF670ZcGyVZjJDtTWCjy+CJi7JFAXLe1hQ7xTe2ZjxDo97KF/NsZoCYwa/LaI44ARDMHWLfwlES/byI2sFoqwufg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mn2IslC2I9oXmj+Rbf7/kJjMZfgIJMBH4oeUCdUu8Dc=;
 b=iMLBnbcdHK8VlmFG0U1FKR90pVdUZPV1a+SFQxg9T2fp7T9618rvhxUTDi+BNUN96qbZyHeA1XFKIvqKjQHwUMY9Z3GKrugE/p+6U6ghzafD+GUsaREaEGIFsEwsUWnhDQhGWMs5MRLXoEYArKSZX/hVI78lTx/ASttcHXiWh0HbPANK6U1JfZtIJMrDfOJtJtN7HsTPuTwaHXhAevZXezC86dQ5iH06hjTQ5sCNZZulryGW4sCryspvOwS3Q57NJNUdQrbHP6Oy+KT3oBeBhwdEG6+GzheArZaVQpAkLjBqS3y7K2T1fXOJJmeoTchAvc1p+10qKCQOXHN9AMro2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mn2IslC2I9oXmj+Rbf7/kJjMZfgIJMBH4oeUCdUu8Dc=;
 b=P3Xx0+jxz4eBgNFZoic4efBdPoCpHnJFHMg+BMTIaGpX4BKs1lv628cFzI0XhvDPJjqB9CuJQixGt0WmqnX/FFMrCauCXFOML5nyyE3Jv6OdDnmgXNCl2nSkC+QfGjVJ2ReYWcGXcZ03ovK+Qrg/QHDrJfEwD0Xu0KFhxbEm2Xc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB6280.namprd12.prod.outlook.com (2603:10b6:8:a2::11) by
 CY5PR12MB6369.namprd12.prod.outlook.com (2603:10b6:930:21::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.22; Fri, 27 Jan 2023 14:23:11 +0000
Received: from DM4PR12MB6280.namprd12.prod.outlook.com
 ([fe80::5935:7d8d:e955:6298]) by DM4PR12MB6280.namprd12.prod.outlook.com
 ([fe80::5935:7d8d:e955:6298%9]) with mapi id 15.20.6043.022; Fri, 27 Jan 2023
 14:23:11 +0000
Message-ID: <45686f49-e46a-5e28-70fa-45bf9aa77ee1@amd.com>
Date:   Fri, 27 Jan 2023 09:24:10 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH] Revert "drm/display/dp_mst: Move all payload info into
 the atomic state"
To:     Greg KH <gregkh@linuxfoundation.org>,
        "Limonciello, Mario" <mario.limonciello@amd.com>
Cc:     dri-devel@lists.freedesktop.org, stable@vger.kernel.org,
        stanislav.lisovskiy@intel.com, Fangzhi Zuo <Jerry.Zuo@amd.com>,
        amd-gfx@lists.freedesktop.org, Wayne Lin <Wayne.Lin@amd.com>,
        Guenter Roeck <linux@roeck-us.net>, bskeggs@redhat.com
References: <20230112085044.1706379-1-Wayne.Lin@amd.com>
 <20230120174634.GA889896@roeck-us.net>
 <a9deecb3-5955-ee4e-c76f-2654ee9f1a92@amd.com> <Y9N/wiIL758c3ozv@kroah.com>
Content-Language: en-US
From:   Hamza Mahfooz <hamza.mahfooz@amd.com>
In-Reply-To: <Y9N/wiIL758c3ozv@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YQBPR01CA0151.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:7e::9) To DM4PR12MB6280.namprd12.prod.outlook.com
 (2603:10b6:8:a2::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB6280:EE_|CY5PR12MB6369:EE_
X-MS-Office365-Filtering-Correlation-Id: 92ced686-f652-4086-a5f9-08db0072050d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZBPJC5hPQsu0NLE3MutsmKtIoE2jzAEJ9Whcaxt5l4PIMBKpdVht6nsa0qU6ol3SjkRVkAfjCLh8QoZuDOtaO8U2fGJ4+u7Fb5b3CpyJjfz7iym9yCsJbBuiRuZL0/fxkUva8j1BBrDvBsNv3J8eWlRycWE/T6NE9za3bz9dlWKNKHq9z/iFROgWL80p+UMJHs319/ZjPnlhNaDtzkupJO9Pk/uPTTUdCXp9Pycu4srB0H0HV5X8pTr7IikUpE4Eu6o5oXKiJJBVdbYPP0TxYlMPdVXKbNCQkAh6Mzt0QHrJ51OWKfN57gpCRlhPtHqcPezL8O0CA8WfkaXxQIN5moouEmlcqXY79xg6ZWa2nkkqMsB/n6ZvUN3YQ4a3mhaiqSLxYO7q0I2OBJSHc9jWVCjdi4fZrFmYwHM0AENrnN27d2PlnNP/b/zdyARH91V/rX3m6gsKWp87CPSNM3tFodd/mZDoti1I4qX2zTcvtDBfAnSsOXCCFDagwGR5ADdvhLPI7UhyEUFBeiBIaWjvCL+9+PSEllrW6SYSMrAGDpKVqLteU7ki3jL2tk8R3LnADbJMJ/72QllciXtfvZN4HwlMgah22GL19qJaa+dO03gw6l4hdoV8/qgwwWnDK4knPtvZndltJVJL6xtyF0r6fvOY+AKUJFTl+4kLjkXH8fDOY6nUKfFxiqIyYt4YCKpo1eMtR3ebA19nRaty3z93PehriH8W03GGGpOgsqHN1Hz9zSq/bEHVsqfBV+hHKa+nU5jP+7BEV9eHPhNYAbVSpA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB6280.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(39860400002)(366004)(136003)(346002)(376002)(451199018)(6486002)(186003)(31686004)(26005)(478600001)(6512007)(966005)(2616005)(83380400001)(316002)(54906003)(41300700001)(8676002)(38100700002)(6636002)(6506007)(53546011)(110136005)(8936002)(44832011)(86362001)(4326008)(5660300002)(66946007)(31696002)(66556008)(66476007)(36756003)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Tnc0Q1d5SmM4Q3ZiRzdwWGgyd0RQUmVRdTAxdG9QdkpLbCtnTlR0QnRPYnNq?=
 =?utf-8?B?ZlhVTGRwQXRTdVJvdjFacldIcVVlSzBLQy9BcUx4eWdwYUkrT1MwVVMrQy9B?=
 =?utf-8?B?R2s4UmNUcXc0VmFzWW4zZHZPNjNOVEVtQys4L2pNZ0FEMEs3bllQVEs3VDQ1?=
 =?utf-8?B?Q0RvK042TWk2a09wUE5GY1BMRE8vNXQ5WWlka2t1SE9hVVpHM0hpVEtXcThH?=
 =?utf-8?B?NC94cEVaYmNYWjFRbjNzK2tZYjh6cFJ1TWYrSU5ua3dhbGM2VWFzMi9CZEFT?=
 =?utf-8?B?dm9GK0x5YjhaWUpnY0ZyU1krOEpSSXZvU05ZQmNWZGVxcGNWd1FpTWVYY0Na?=
 =?utf-8?B?RUdPRmxiV2JqR2dGcFJBbSs0NmI4UExDMWkxakl2aW5sMnhDWld6QWRNSXFR?=
 =?utf-8?B?Q0dqOEpEQTNEWVZxczZiaktpSmFaanZIUjBucElrK3Z1cDI5Wk1uUXk4UnVy?=
 =?utf-8?B?QXlJd0E2ZUh2RVJHbXhQSS9EWmh6R3dEc3VyeFM4TEVlZmRsNHdEOElOSGta?=
 =?utf-8?B?NWM3cE9RTS9MM3MwK3c0UGRzbXZqZitaNWlqS1FJcStaQmhmUnRIdSt0NEdh?=
 =?utf-8?B?VWk3NkZWdUZ0V2lVSzZGVmpuWUdBcnFWbkZHL3JKYU5jc1ExWWpteHBndnF2?=
 =?utf-8?B?KytoK3o1aXpVSWhXRWlJQjczRFcvRGNFSEN1MjgvK1RWU2RMa3lVQVNZWkxX?=
 =?utf-8?B?NUFmUkY0anFCb3ltbmFtVHhDbXRIRzZvZDNzRjl1RmhNV1ZMZzlPQjNhQXMy?=
 =?utf-8?B?cHRyTWRoZ3BRMndnd0FaVXZ0eVNyU2VhUEpnYUF3L2pvNDZkSGowejhPY3Vv?=
 =?utf-8?B?N28vZ0hXazdnMWRNZ3dVeW00WktINC9kVHdTb0hKbGpDTlhyb0I4NXBsaGdD?=
 =?utf-8?B?Z241cUZVbllmaHNoSnVwSjNSR1lxc21aNElvTTVLWmJwWXRKYkFSeFM1a0pq?=
 =?utf-8?B?OFRNVzRURWlWYU1BOXphMVU3UlB2cUhHN1FlTzNxVU82enhpSUhvb1dYMGUy?=
 =?utf-8?B?UkVMNjFSMk1LZGtXbXNlTTB2WmxvQmJMd3pPbElPV3VkZm8xWC9mZDE0aFd4?=
 =?utf-8?B?Nm1GS291eE1sN00wOVFjekVVK1lDMlZ2QTdYV2szNGF1UkxadDdHczNOS1Ey?=
 =?utf-8?B?cCtMRHVZUHFnU1FrazFXditHdW9aQXdMZHA3Qld2aGdOTmdVUkp0RnRtNFdI?=
 =?utf-8?B?d3Vkc2xSMGo0WitMRmVVaGJaWEk3NHFIKzNWeUxtRTlyMS80TiswQUYrOGdy?=
 =?utf-8?B?OEhLQUVZL0w0OUFJOC9kbFV5K2E2ZnlHN1RCWnp3QTBZRDdYNGUwQXdBSnZT?=
 =?utf-8?B?M1JpN3VKNUZadDdxK3grdmlFUGlHQVFod2U3d1M4Tkd3YWNWNXR2SlVGTkV0?=
 =?utf-8?B?VmJpczg2OUlpWDROOTlaUGhwOHU5K2tPSUZnSG1FTTlIbmlWL1JLZG51Zi9T?=
 =?utf-8?B?WUF1TVNRS3NUSHFxcjhnOTB4eVJzT3NtWE1taThiNkYyeE1VeTNkdEF4VnBU?=
 =?utf-8?B?Si9zNXBZbjJoK1pkbVlRMTNUR0VEdmdRdk5nN1hhUTJrUVVScG9rYzgyT0lr?=
 =?utf-8?B?YnBCODR0RzR5YTgxQlNvYkFBZWRnZStNT3YyMFUyUDRqa0tIeXdIOUlXWmJL?=
 =?utf-8?B?aW5sYk56blFITzlFVTUzbERLTzhYRGJJTmhpTVREOFNVWkE4NTVMYjROMTE0?=
 =?utf-8?B?S2tMU1F2TjEwU2YwWWNITlpOK08yc3VJNGd6U2pnbGR2MnlBTUJZL1RLcWgx?=
 =?utf-8?B?MVk1aC8vSEIvME9xZzBvaXZjVjMxem5lckIrWGpucmRzUzZNaC9EOWJCbXU0?=
 =?utf-8?B?cG1FNFZTOG1pL2FDUGVFaFJsdlpZSUpzdlNrT1RTQkxKUEJDSjZhU3JaS01Z?=
 =?utf-8?B?bnNvSkZRajQzSXpLRndNU3FDWGRHTFZGWTJjeHFJbXFDWXNWWXJKSndlOGNU?=
 =?utf-8?B?UU9MbGo0UFY1ZlJqaTlWb3d3TGtURWNmN25JZXp3S0FnM1k0OEsyTHh2S1g1?=
 =?utf-8?B?SVVKaFp1YXBDR1pIVDFXWWM2Z2ZKMXRtYk1HQW1Ealc2T0hmTmc2dm1uQ0w3?=
 =?utf-8?B?Nkg0djdCUlhSdWs1TXpSbGZtWVVOYTM5Ni92QmlWYXBxVW0rUmJSUEFVRSts?=
 =?utf-8?Q?ovWVQ1aIW2hU+hNTEQnZCWxAE?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92ced686-f652-4086-a5f9-08db0072050d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB6280.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2023 14:23:11.5984
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b+fp0cvvvBjcccm9tvH2KcNFTdlwkT2CTRoJWIvaV4dnf1Jr9M7VABPZO+C3VgcUZJvW4zwItmJAZGfdOwMP5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6369
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hey Greg,

On 1/27/23 02:39, Greg KH wrote:
> On Fri, Jan 20, 2023 at 11:51:04AM -0600, Limonciello, Mario wrote:
>> On 1/20/2023 11:46, Guenter Roeck wrote:
>>> On Thu, Jan 12, 2023 at 04:50:44PM +0800, Wayne Lin wrote:
>>>> This reverts commit 4d07b0bc403403438d9cf88450506240c5faf92f.
>>>>
>>>> [Why]
>>>> Changes cause regression on amdgpu mst.
>>>> E.g.
>>>> In fill_dc_mst_payload_table_from_drm(), amdgpu expects to add/remove payload
>>>> one by one and call fill_dc_mst_payload_table_from_drm() to update the HW
>>>> maintained payload table. But previous change tries to go through all the
>>>> payloads in mst_state and update amdpug hw maintained table in once everytime
>>>> driver only tries to add/remove a specific payload stream only. The newly
>>>> design idea conflicts with the implementation in amdgpu nowadays.
>>>>
>>>> [How]
>>>> Revert this patch first. After addressing all regression problems caused by
>>>> this previous patch, will add it back and adjust it.
>>>
>>> Has there been any progress on this revert, or on fixing the underlying
>>> problem ?
>>>
>>> Thanks,
>>> Guenter
>>
>> Hi Guenter,
>>
>> Wayne is OOO for CNY, but let me update you.
>>
>> Harry has sent out this series which is a collection of proper fixes.
>> https://patchwork.freedesktop.org/series/113125/
>>
>> Once that's reviewed and accepted, 4 of them are applicable for 6.1.
> 
> Any hint on when those will be reviewed and accepted?  patchwork doesn't
> show any activity on them, or at least I can't figure it out...

These patches have already made it into amd-staging-drm-next and as of
https://lore.kernel.org/amd-gfx/20230125220153.320248-1-alexander.deucher@amd.com/
they should land in drm-next soon if they haven't already.

> 
> thanks,
> 
> greg k-h

-- 
Hamza

