Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0C49667CC5
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 18:40:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234777AbjALRkd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 12:40:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231349AbjALRkC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 12:40:02 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2062.outbound.protection.outlook.com [40.107.94.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41CAE6D51E
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 08:59:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=goG22CowTT5PAVYupESzTB3CJzrqoovL7jumAzMs7aZJmw2PVfsIIK4WEgg5ILlX6YX/2rgCCp9OTU3t+xPUhf9g7YlxTTjB57Czts5tSw5TgSOe9RtX+jMbpAdqcqNsrwSdD/Ev8VX/sqsyjZSNAb1W3Z2KFNsbBiQIljFdPxMfoRydvpCI1OekmZv5HAzaNuWK7xfIvJVQPC+0Rri6W/CUeBbF+fvaLfOuy65FF6aRHvWvK2XLsnGbAqWmf7VRwZtklIiw+/RufdN6DiEcvXGwAXsFIPYLgWbD8L+Xr5N5643f1q/TtGPnmThugeocAaWqiAhBB+xAO7SWq4RoUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=++6IWrrX+LCNXnjHyEnf1esDnuYi5/VVJyA7/Il/7kU=;
 b=kKGuHJ9ZX48KSwii8hhvM+5VAm8W7L7ysx4oo0k1fdtIYWZiTZzhxiwisHGUEj/10TWcGgDSuXOaVnY4CMuyoUDL0SCOfl3plVyAePD2rpHYIllIwYP8bU8obC2IGD5UmsN0m8RyGw1WS/ibVHl6zlzgAbG1VVP2uVCbMiQjBR9p8+B9fPXrqU7MMXBhA8ZmSkiHvWjICWvjTYXbxRhI6vLm0+SRnCciBPD+p4fclatA4on/pMcxeVqmNrn5ZaryKbnFmcKzEqlxWXnSxFQphhdFojA9Jm47kAQ5S+EdhdTpcRKVlnSnfWs9Tk96J9mv+8kRepChrNbyDtb/bCbiag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=++6IWrrX+LCNXnjHyEnf1esDnuYi5/VVJyA7/Il/7kU=;
 b=GNUPe8BK2VOf9+Vlvx99WgRlWPFy9bO3qzpaibtC6O/+KPDa5xHsLqJc+lLkKAkd9jvzOjCp7SuD1IkE2Zm0c0hmn2mGpj/lFLKdD09zSSqlxdD6hhBSmZJHRFloqpePtqdQRtzwlNLuzo3GqVchFA/MJPtxZxT3y4/EeQ5FvUk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM6PR12MB3370.namprd12.prod.outlook.com (2603:10b6:5:38::25) by
 SJ0PR12MB5633.namprd12.prod.outlook.com (2603:10b6:a03:428::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5986.18; Thu, 12 Jan 2023 16:59:09 +0000
Received: from DM6PR12MB3370.namprd12.prod.outlook.com
 ([fe80::2fd1:bdaf:af05:e178]) by DM6PR12MB3370.namprd12.prod.outlook.com
 ([fe80::2fd1:bdaf:af05:e178%3]) with mapi id 15.20.5986.018; Thu, 12 Jan 2023
 16:59:09 +0000
Message-ID: <ee614df9-390b-1736-c2a3-3157e47f9d6a@amd.com>
Date:   Thu, 12 Jan 2023 11:59:06 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH 6.0 108/148] drm/amdgpu: Fix size validation for
 non-exclusive domains (v4)
Content-Language: en-CA
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        Alex Deucher <Alexander.Deucher@amd.com>,
        =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>,
        AMD Graphics <amd-gfx@lists.freedesktop.org>,
        Sasha Levin <sashal@kernel.org>
References: <20230110180017.145591678@linuxfoundation.org>
 <20230110180020.610387724@linuxfoundation.org>
 <e4b4b0ca-b6e6-70ae-1652-3df71df53ab4@amd.com> <Y8A6AC9DrYfO1c4+@kroah.com>
From:   Luben Tuikov <luben.tuikov@amd.com>
In-Reply-To: <Y8A6AC9DrYfO1c4+@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YT3PR01CA0056.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:82::17) To DM6PR12MB3370.namprd12.prod.outlook.com
 (2603:10b6:5:38::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3370:EE_|SJ0PR12MB5633:EE_
X-MS-Office365-Filtering-Correlation-Id: f9ee4bde-7a14-4ca8-15af-08daf4be5261
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QlYSMURNTbylUnNerQynKGMeuQWJvYUdnBDPmmZMSzzvf7lXPx1QNdX1cEn6f4kz6Xjz9WYt9Uaw/SyyaBYF9V+bfgZaW2fduBM6+h5HYym+DYawWhGI54Im3RInI6w8Ry0Jbuic0YmL668eojB1AjAP76iN1stJ01m6M1J1ISzZ0JX95kAg5jy19Q5hf4QtABdJJefk8jMuW1iTch+qw5z13mu39J/aW/oUWxNfIAJ0+FIP7UEzKTCpm4BTzuuHH85sKiM+0o7b+A6ICw6ylF4w9nkCOTVr6jqUrdB0M32AaeeKvHHUHr9DBUUOCuvxC3Wx+68+NGAuuUqmn1iw7iT0zk2vzc72XAS6lWMMYrmDDWmYMMQayrcVF459Rqjzah61OgiBetyEcs77lzxM83c2MUx7unzE688C801p4RbqEPNtasuhBzFpryYsaFlr+FkVqNXW9hhq7erwaliDHaGhA3c0tu126bzAZYRvVHgVgALMq8KY148XEzkeapyqbVQAB3IY+DIsTw0gZJzTCxNNLk9o6NVeeVWdntI2/ur7p4is1/NurIQTn9aj80rIQxIXungPBuuCyauNI5K+kw6ALJSQbVPimlnb+6PBfSiRAItMTkgo8T0HujcZylFUuHEX3+zCXjPyZ0qazZ0gVzVQdxvLiusSSpykRebgMgN3J7ylLyJzrcEXwtrCskJf2juvHtWBKZkPLtEApcdaQgWpimGas3MfhKiSY04yvoZjHMAn9242A6NTS5TXqp9V
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3370.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(366004)(136003)(396003)(376002)(39860400002)(451199015)(41300700001)(4326008)(66556008)(54906003)(2616005)(66476007)(316002)(36756003)(8676002)(66946007)(6916009)(86362001)(31696002)(4744005)(38100700002)(5660300002)(44832011)(8936002)(6506007)(2906002)(53546011)(31686004)(6486002)(966005)(6666004)(26005)(478600001)(186003)(6512007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OWhUbVB0WGM4Y21CdTlTVmlyVFFvU0ZwUTFYYVZwb0NuYU1jSHRtcW9aR3ZS?=
 =?utf-8?B?WGJSLzFqaTJNSWRSeUhqSFd4WXpWb2FXTW9qN0NXWWgzd0RnMWNCYi9TanBp?=
 =?utf-8?B?NlVTUFpIa2J2RWpKWnVNdnlUQnJxSlBSVjMvdW4vYWhFSURXbkpZdnRhSHoz?=
 =?utf-8?B?N1g2R2xvOHdxV3ZDVWE5cTk0Yi9xR3B4S2tlM1ZCUkRqTG5ROUk4RXo2L05k?=
 =?utf-8?B?KzdIRk95MVZMNUFjZ1BzN0ZmVmJFM1M2NlhML0N6dk4vUjF6ZmVUQkw0RmlW?=
 =?utf-8?B?cjRrem9OQ1N2dGhCWXpPTTBRcys0ZWVneGJhQTB1WmFvWitqb3dsZjdHdjla?=
 =?utf-8?B?VFB6SnphMnJHTUp2a3NnMkxmQjg3MjNSa0wzSW5CVXFJQll0YmtEUlBSdzVm?=
 =?utf-8?B?UFJzMzBDTmUrRFA5VGw4S0NyRGRUcFlTR3RPL0NXcUhlNTY4dkI1RHRoMTlV?=
 =?utf-8?B?RkZQWWpzNDZkcTNCUnozSWVaM3VXbjNHekVXTjVFd0ZzL2xTNDJ2dXl0NEw3?=
 =?utf-8?B?WnAxWGRwZHB3SnlBQ3Z6eU85QVFzU201VDdZMW9CRDFsSlFVRnhlODFEZHNZ?=
 =?utf-8?B?bUx4NWRGN2hJSHpKRlVkSjhyOTNtU2FHMlc0Sy9SbW9wSk1ldDhwcjVzbE1h?=
 =?utf-8?B?YUswdVlrU0xaOWt3NjcvZVBqSDBHZk5lalFjSk9IN2FtY21NUTdRRE00SFM5?=
 =?utf-8?B?M2ZjM3cyUWFEZ3ExTHFMS1JKZThPNWt1N1JnK0t4YnlMaUdSV2h5LzlWenNC?=
 =?utf-8?B?S3pweVl1bCtWbkdkSFhBbzJYcmcrWTZJVzdTWjYzLy9tcEkrNkoweDliYXhp?=
 =?utf-8?B?UmNKbFpqSjBRNWtqSm1tUEVjQ05VZDFBTE1xd1hQZ3haanFHOEoycFp3d014?=
 =?utf-8?B?QStUMlcxY09HSGNKd0RyTGttUHUxUDlYenV1RjNTR2Nsb2tndENldlJ2V0pG?=
 =?utf-8?B?T01RQjUxQk1QNXVpLzBVYWRYeHIyZWNLSXFjK2htTVVva2p3Ni9TOW5kZExQ?=
 =?utf-8?B?MHhobHpDRFdyY3o4NmJzU3Z5NlBlMElKV0c0NmNWNkRad1ZJUHNwdXFrZDVZ?=
 =?utf-8?B?MGJDYnRuaTBIaDJFRzNXWjhaS0ZTVGJGczlQWm56RC9keWJMNnRXTUw5UEs4?=
 =?utf-8?B?SDRXMlA4ZDRibC8ybzBCRkRNb20zVzhGVnRzay9kODZSbjZZQ0w0SlJkNEZh?=
 =?utf-8?B?dFVVR0pjaWVmaEVnTlgrc1pTUiswbjVUSXRFNzJ1OUx0RVZwWmxwTCtMRkha?=
 =?utf-8?B?VlhlWUpYRzJCbGp2Qk05RzZRa2ZWVWdIUmlWdDNMY09KTWRiOFFPUXRndGpL?=
 =?utf-8?B?d0w5ZFRUYTQ4YVI1czZDeGFJd3pEaEZ0bVhWdXhhM1B6dWN1cVJCR2FKeHMr?=
 =?utf-8?B?QVIvaEtscmNvbHd4WlhvQVpTYXo1Q2dOMGh1bHpOdm4zZGdWWHMwK2ZVRkVt?=
 =?utf-8?B?WEFWQzJvS1l2akVDeWVtci9LVS9yQ241REZ4SmpSM205U0xKUjNQY0lZT1RF?=
 =?utf-8?B?SHJ3Kzd6WXdubCs1YTdDcUQ5aVNLTVFYNVcwaWM1dFJrTnVBWWhHZTRKNDhC?=
 =?utf-8?B?UjBpUFEvMXhQdFREUURSZCtUOTJxa2NCYWIwcHFMQnVsQVlldFM0ZmxDaW5k?=
 =?utf-8?B?cDJjYXFKRlZTUDE5NjQ0elNjU2dzWGpWcDh6b0MxYjE5UVlnK0FEZTZLa3Mr?=
 =?utf-8?B?VE5UZEQwSVkzWHkwTXZtR1VEanBFRklibXVnb3cycDZWankxYndBdmdXYmlL?=
 =?utf-8?B?a2JwSlJmdEcvRCs2MHV2ZkF3TURDNXNFVWM0dGQvTHVrS3hzUTdtY2ladE5N?=
 =?utf-8?B?QTJhbkt5UnVUMkwyR29vQTdvWjFlUzR5ZHBNeW1jUkR4Ri9rVFFEcnJuSmN0?=
 =?utf-8?B?Yjkzb3dMSUUrSjBFKzc2UEJmYjhuR1hpai80K01VNWhOTUx6Nm52QU5LMXVG?=
 =?utf-8?B?bnVqVVV3Q24yL0JFNk0va2ZVZkc1emdjWEpTWnJ2VC9jRlk5WHptQWNxOGty?=
 =?utf-8?B?WnVnZU16ditITEh1bHlVUW5uVUwwWVRya3YrZEgreEh3TGIwZ1FiQmM0V3Zy?=
 =?utf-8?B?L0h3TUNiSkpKUmhqcDh0dXZXY2IvOXRPT3RqYWg3WTd5ZFFPbDlXRFh6OWFS?=
 =?utf-8?Q?H49hf22P0Mex/+O+rWe2mVg9z?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9ee4bde-7a14-4ca8-15af-08daf4be5261
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3370.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2023 16:59:09.1279
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Lr+yn87MwTbr4jUz8oQ0x4lvChqucAx1lvy+3xtqlYQ6G4ZNR8fU9ITxNzshvrtg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5633
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2023-01-12 11:49, Greg Kroah-Hartman wrote:
> On Thu, Jan 12, 2023 at 11:25:08AM -0500, Luben Tuikov wrote:
>> Hi Greg,
>>
>> The patch in the link is a Fixes patch of the quoted patch, and should also go in:
>>
>> https://lore.kernel.org/all/20230104221935.113400-1-luben.tuikov@amd.com/
> 
> Is that in Linus's tree already?  if so, what is the git commit id?

I just checked, and not yet. Just wanted to give a heads up.

It does have a Fixes tag, and I hope it would be picked up automatically,
when it lands in Linus' tree.
-- 
Regards,
Luben
