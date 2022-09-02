Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53D5C5AA74B
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 07:37:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231260AbiIBFhX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 01:37:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230151AbiIBFhW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 01:37:22 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2062.outbound.protection.outlook.com [40.107.100.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BB5CB6D65
        for <stable@vger.kernel.org>; Thu,  1 Sep 2022 22:37:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cBslsuVGNmT2XWo2WYTck8hkcSQgoyp9H1zJPZbcj2WyJ4Z6esP9OLlilhYKMZ1R+NTtyft/jV7Qxsq9MV/L36bpRs1PyKIus2AHaJ0nPDE1YrjYuXMGLJBSmzQ9gJV5LMsKOlUrTjFd6dLs99OcZKTLsguE1CnUL5ifBpIqj826ccsD7sPNsskLLjE20ehAndPuZmiM8FfX/oqNmQ0BCXV4dzHjcx7G12/cD7jeER53sdK8N/W2U+DEIZtBiWwIAef/d4V+oNkrPVM6enrxyeYxqCEpynyt2L0SMcpBr/dKUhw64VBcbuZ1A/pyEweefDeIZ1JHW9B0gAhjAUxOVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wbn7aUmKSxpDEBV6p9at/wkdjLO8CnXt5pDhrGFsB8Y=;
 b=Z089N63x4DPG7uo8RWvfK/KlhWG7/LkZ+eZEx5IXOjnECjkw3MtIoW99xV/w1Qk0ZQz3j6IhQhpL8UEpEU8MdJj2jsKtvkmMZoAtPfat/Cmehc7oP27JJHEkedzdWr2zoL2JZkBb3NyuEm5baf9SVgM7i2fQVBv9xU8U3+DN1GELJHgbbgrSKGYedb0ySZrwwIUrEAiYkiBDTnz5OngdRGyxsbJma8uUFHUd2fjH4qkQ13xOoNC08nAJ2QzxxfRoigWqUir/FvZ6lkaBkS5+Bk5SWwEG+sYUD0qA1AkZL17MV2PjPLK697HSxIsUX2+xIGMx82IWQIWaRRtOf23Vpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wbn7aUmKSxpDEBV6p9at/wkdjLO8CnXt5pDhrGFsB8Y=;
 b=ovO5+ZqxtBFVApl66C18Rx8c5MhMqgJ8MmfQs5qTacIzdxHHRh0PUrvuzXB9HNx8ucULuiEFCCh/5mbI5lC8/8Q8s5+UPUgNkNirWLF5gzRGn4xum367GafUV41Zxb88ckcohDD5bA1ZKQfRRDNaCmcnONdviJp41KfFnoLoadw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by DM4PR12MB6012.namprd12.prod.outlook.com (2603:10b6:8:6c::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5588.11; Fri, 2 Sep 2022 05:37:18 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::e00a:1f8c:dcd1:afc3]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::e00a:1f8c:dcd1:afc3%5]) with mapi id 15.20.5588.012; Fri, 2 Sep 2022
 05:37:18 +0000
Message-ID: <2f525452-fbe8-6780-b552-9ba7c16047e7@amd.com>
Date:   Fri, 2 Sep 2022 00:37:15 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: Properly reflect IOMMU DMA Protection in 5.15.y+
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <MN0PR12MB6101D6CA042DB26E76179482E27A9@MN0PR12MB6101.namprd12.prod.outlook.com>
 <YxGUnAjojULtdhfL@kroah.com>
From:   Mario Limonciello <mario.limonciello@amd.com>
In-Reply-To: <YxGUnAjojULtdhfL@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR05CA0024.namprd05.prod.outlook.com
 (2603:10b6:805:de::37) To MN0PR12MB6101.namprd12.prod.outlook.com
 (2603:10b6:208:3cb::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1463d43e-cf4c-4580-50d3-08da8ca532eb
X-MS-TrafficTypeDiagnostic: DM4PR12MB6012:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7nA+mhEARcUTaFvmb6gJBFz57uZQRNPi2368zXBs+TK4I4vCvD70PtgBXFCHhIPxmk10GaZ1tNyHsqGQ7YLygjb9L3H+ChqZZEE18aMqgOAKP1h2tBkhJxCoX1FLDuG60Ung0OqhWqb13IjuX6RXptWgk6m00vUParFYSvQ+OdplC4h5RSYYTz8uaiNLMOesRaR88XrskN+provsKboTlcZjCjaY97lSvlB7WnVOS0RKfCBCRS4qEcd3FlfWCzwwUHpMiyNGFUue+B/MIF4C41cF/CJZP57jjs9+Yv+NRIHRQu6LRR/wpyZmWlNqicavsEEzrn63nVVf8HAEzzERGmScY8WlrXX8tN0Jy+lu1urup9psvGdkYE7AH+ASJbgxy7/DJ4I9P6lPEeA67AXHQPIl0TnpZeRbdpMeZi1wlQpm9bU0+fPZrKs00jHhtKSFK5VUQCpoqArb9yfAK6SXzMSiNFvoZmQUNYGi5tukTW/mgWWbdVsWndNBfZhYcCq2JmlqP2ydqF2du5jtfJb94H6wc29dF2wNxWKcBUtfhxxcro8ojcP96BEH6wQPGGE1ZyBNdgCX/CPjqXwq9kWbyC25G23OQAFCfdOoTj6cIXhEiAPRBf4MF1GPvP1+JWDYim7GbzRufZRmYejECHX/BXhKTww4in1BZ5rx38LqujS1p5ON6EKZXD5jlg+nIRJQxE/go69QgGbLxCKqrNn6ZnFKO7fj4g0R3LR4vL4jqDSHpXK4G6GJo1awTkzUTxQUwW6WTD9vYsQoRUdfdwmefezG0RFqJkSFTMu9Q1C2c04=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(136003)(39860400002)(366004)(376002)(396003)(86362001)(2616005)(186003)(31696002)(6666004)(41300700001)(8936002)(5660300002)(44832011)(26005)(2906002)(6512007)(53546011)(6506007)(38100700002)(83380400001)(66556008)(31686004)(478600001)(36756003)(6916009)(6486002)(316002)(66946007)(8676002)(66476007)(4326008)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q2xNUlZkdWQ0QUwzMFBrTjdtbnFINGUwdDlWdlBoZlhsbVdVRngraDJWNTFo?=
 =?utf-8?B?aDczdWpFUVdLK0o3V1BCRVN1TmVLQXRuRnRZdnY3VlB1am1oMDRqejk1bm5D?=
 =?utf-8?B?QUFWb0xURzF1MnlFVDBYM1NOZGs3VFNNU25pOWxHRzVZWnNQcjFlV1pBYXRU?=
 =?utf-8?B?TjNBNlhiS0lOTUU2cXpTQVR4ZGJYRkpNN0UxMGhhb1FaTGcwSzBJWkd3d3JX?=
 =?utf-8?B?Z3VWd1VqN0wwZC8xL21iSXBJVDhYeUp1NS9wRUt0NFBPRlp2ZkZFcnNXS0dO?=
 =?utf-8?B?NlRId3krbTFPL0t6aFdFdjEzVWFrVUI5Tk03ZE0vSSt1MWlNWXpqSjV5ZDZn?=
 =?utf-8?B?UVh1OThzcWRJK3FwalpJcldvR283aXJtRHBSYmt6aGxUSkxodjFRREF1MTUv?=
 =?utf-8?B?Qmk0alVVcmszN2FiYnNKSHBhWm5WOVRNNFc3QVhMeDFOc29oOG5OWmU1V2Y5?=
 =?utf-8?B?bkpuMi9BZWtOSDFnUEpxcU5NbG15MmlFVmpUdHQ0emJhNDlaMU91c2VCUXV5?=
 =?utf-8?B?NHN2c3lhc0hsQVR0UXllMGVibTIzOGJib0hEMnVTWHdFb3RWSnFiYi9yeDUx?=
 =?utf-8?B?SktzZmp4WnJQTTk4QzJEZXhyZGZQT0FGWEpoUXV1OXBjRkh4UVhqeTVuUmJ5?=
 =?utf-8?B?YnBEQW42RU91MWM1aklkNDJ0ZGZMdEpoTzZhRzFKeUE0OFQ4OVVLVWJwREgr?=
 =?utf-8?B?UUtwemhjRkZ1L0thSlJHUHNsWGFHdENNMW8veDZ5VkpzaW9YRGhDL2I2NTlF?=
 =?utf-8?B?QVU5NlB1bFJDbUZ5U1NBdGRramMwR0wva2x2YndLQTQ2VzdhUG14dmlFUkkr?=
 =?utf-8?B?aHFnOUxDMjN2cWFISHBITFVXUW5NTy9nWHU5WGlCd0NUc09oV2ticWdIeWpZ?=
 =?utf-8?B?QUFSd1lpU2lxSkFnY3JLSENWc0J0T1M3ZUU4QkQrZm9rVm5tY1NTVytLblR5?=
 =?utf-8?B?OW5xbmZaU3g1R2VpNElPR1RKUWZJOWVZZFN0QXdHL0l1YmlQcGYrWTJacnQ3?=
 =?utf-8?B?Z0pxZ1VXSnRhcnBjQTR6UUM4VHU2YW5DR2IrNndmSkxabS9qSmlvU09Ub3Fa?=
 =?utf-8?B?UjkvSDU1Ym9SYWlTR3ZDOEREb25za0UvN1FEWUkwZG5VYVpabHFUSm5rK3NC?=
 =?utf-8?B?N1V2ZXppZ250ZWJKSjNzK0xRV3JVVjJWbENhTUh4K0RBZUpNNlo5Y3JHMHdr?=
 =?utf-8?B?OCtPV2Ziblp3NnJNdndtbFJzM1ZqSEdUbEV6eWpxK000T1V5alA4aFhuYjB2?=
 =?utf-8?B?Z1Vta3Y0SU9MUGhvSjhOMC9Gcjg4K2M4bGFGYUNlRy91aTJzN0hiR3E5cG5M?=
 =?utf-8?B?UGFWMmRON0c4YjR1TDNPRHhERlBmRFFQMkZuWnUzUnBHSno0TmNNa2dUZzhh?=
 =?utf-8?B?RHdoTHkvakp0aWU0MjBhTytYRmpaek1DaDF0aDZMRUZEazRFTStFbi9uemNR?=
 =?utf-8?B?c000VFdzckdwNTRwbmR2MzNiMmE0TUNrVjhpbUNxN2cxTmE2bW1HWGwrUzBW?=
 =?utf-8?B?QlVvTFplQ0FKelF1dSt4VytYWFdZd0V0Unp5S2ZXK0Q1Y1RVYWlFSmJlNmtC?=
 =?utf-8?B?djI3R0lVaU1DL3krZk4ydlFCNVhUNmtwVUNya29HTjd2ejVDeHd3R1pjZjRh?=
 =?utf-8?B?VzlaTlJ5L0dnQmhKRTgrQ0hacUlTb2crQlkrcC9URE52ZEJJT2ZVZVpmaEEr?=
 =?utf-8?B?RzdUQVZmWmRYemZIYWw3cVlNdG9ZdVhuTmlLN3IxTkpoSGdGemx3UUIwL25I?=
 =?utf-8?B?bjUzai9GYjYxUk5MUUFVeDZCWUlWeVlQZ3o4UjIyZ0t3dVRJRW5wUXJHUmh0?=
 =?utf-8?B?eXkyczgxdWZ5N2s5TEp5MWttcG9xeWtjSjcvSkh3UW1Yc2NuK2dnZVdkTUxG?=
 =?utf-8?B?Y2EvTy9ldDFFQ00wVWVoU3FWNmVTcU8zUDYwdHFGUkQ3MVEwQkozWXFvSkFN?=
 =?utf-8?B?OG51cUhjYkZUY2lDWUpyKzhlQ3laWXhKRTQ5blJ4clUwYU5pdGx5Nk03Ry9i?=
 =?utf-8?B?KzJlZXg4SGFySUtYdUlFejRoR25JdGhmcUVKc1ZTUldHUjFxQlNzQkErVGZJ?=
 =?utf-8?B?R0swMEwxSDc5YXBoUDcxaFBJRldIeUw2ZnRodUVtTVJDazNxNVV6L3BURi9k?=
 =?utf-8?Q?eYcs5QUX/dn/vpdkZNtdaMkmw?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1463d43e-cf4c-4580-50d3-08da8ca532eb
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6101.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2022 05:37:17.9371
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3bI0beb+6J+5wI6ICmb2JmjziR9t0iR6jUi4Dl3eHJ0KAHAx+gqBVjYvh5N9FlqSmq67PdqgXjhSaF1ZmY7B1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6012
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/2/22 00:29, Greg KH wrote:
> On Fri, Sep 02, 2022 at 03:00:26AM +0000, Limonciello, Mario wrote:
>> [Public]
>>
>> Hi,
>>
>> A sysfs file /sys/bus/thunderbolt/devices/domainX/iommu_dma_protection is exported from the kernel and used by userspace to make judgments on whether to automatically authorize PCIe tunnels for USB4 devices.
>> Before kernel 5.19 this file was only populated on Intel USB4 and TBT3 controllers, but starting with 5.19 it also populates for non-Intel as well.
> 
> So that's a new kernel feature?

The sysfs file was there all along, but it always showed "0" for 
anything but Intel systems.  This makes it work properly on everyone else.

> 
>> This is accomplished by an assertion from the IOMMU subsystem that it's safe to do so by a combination of firmware and hardware.
>>
>> Here is the patch series on top of 5.15.64:
>>
>> 3f6634d997dba8140b3a7cba01776b9638d70dff
>> ed36d04e8f8d7b00db451b0fa56a54e8e02ec43e
>> d0be55fbeb6ac694d15af5d1aad19cdec8cd64e5
>> f316ba0a8814f4c91e80a435da3421baf0ddd24c
>> f1ca70717bcb4525e29da422f3d280acbddb36fe
>> bfb3ba32061da1a9217ef6d02fbcffb528e4c8df
>> 418e0a3551bbef5b221705b0e5b8412cdc0afd39
>> acdb89b6c87a2d7b5c48a82756e6f5c6f599f60a
>> ea4692c75e1c63926e4fb0728f5775ef0d733888
>> 86eaf4a5b4312bea8676fb79399d9e08b53d8e71
>>
>> Can you please consider backporting them to 5.15.y+?
> 
> I don't understand why all of the string helpers are needed just for the
> last commit, are you sure this is all necessary?
> 
The last commit (thunderbolt commit) uses one of them.  That commit for 
the one of them doesn't come back cleanly, but catching all of them up does.

So I could potentially change the thunderbolt commit to not use the 
string helper, but figured this was cleaner.

> And again, this feels like new features are being added that are much
> more than just a "new device id added".  Why not just use 5.19 for this
> hardware?

Stuff like this is targeted towards businesses that would want to be 
using LTS kernels.  In fact I heard "But on Intel we just plug in the 
dock and it just works" is what prompted the series in the first place.

It improves usability quite a bit because without it you need to know to 
manually change the sysfs file for your dock to work or you need to have 
GNOME installed and go and find the panel to change it.

With this sysfs file is showing the right value you get all that 
happening automatically.

> 
> thanks,
> 
> greg k-h

