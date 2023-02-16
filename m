Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4145698C8A
	for <lists+stable@lfdr.de>; Thu, 16 Feb 2023 07:05:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229673AbjBPGFv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Feb 2023 01:05:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbjBPGFv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Feb 2023 01:05:51 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2053.outbound.protection.outlook.com [40.107.93.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85B5336FED;
        Wed, 15 Feb 2023 22:05:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gK3Zq4231BDWnwcAbRQ7DMnPNmWQO6zJ/+DBZgk5Pdht5ra+LKK1XDIhc4tiM6wYiAEoz6AlvgQ/d0aaQ++iVYGOOPVqDFfOLkfOXH8PuE3YMNWjNgKNFbnPSuV1gPTwpCIkh45BB7CDr6AFsZTW1bM36wV+OfKht9dSq8mEdJMy85Ek/BZfQqvtjfv3V+Fb6moVgBNnJu4wtIStaCBwhIs0cOj842yn5ygPLNqDzrGY6siw6939qH1hQwxmMTnlH9r9qCVa0zFvkNOPqz2QS3KKH3aDWKCBnLwR8rouJIZQs9InNJflqMgRxxrxrZUCZspv3eZmL+Y/VOwNSeG6/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DgnEjh92MFxlbF1JXfKJszZBlZWof7/Smtxssw9Td+Q=;
 b=H+xzkfqluvU8r41YhmrLewBgR1Ekod9V4ecc9q3rcnjelo4zn6kD22koZ1ZfseCkOFZFWF2xoWSymsYb+o7UaBDCAO2QHdQYJMq7yuPbc4PxnBtjEvWmLVjmMqPQQYC6GR/x0LBveXd6HgKQJMEdBVW3AyvprJ48+/kXlYK/SL+WKYpyJenq6bG3FpZVRJtoz8SXrzGyr/F/5YuJQB0mlTyI6zTsGVCDNHhNk8bwjQCag5qLd5iRiSc8d+M123mJRCwmVtxhBFyLnTALiiVZkSuIhK/GZm6ripVU/VcKPUdMMoMuVDZ0Zhe9/8yAiek9OCsoPb0byLszodSeBUrzCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DgnEjh92MFxlbF1JXfKJszZBlZWof7/Smtxssw9Td+Q=;
 b=uHlPEI29J+mqDOjcs1NgyGH7vV1QbO/Wr8cU2kjQJ4CodPDCGrpMM2XHNW/1R+0nRlZ65TCV8mBRAgw4gUKugQDxtrGcwIeapkf6Ke4AFGboVNvLJ4PQoz+I1/b71wSB7Bv686WZA7KwIogjVF3LePx0v9iC6saBuYVrebIihss=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by MN0PR12MB5954.namprd12.prod.outlook.com (2603:10b6:208:37d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Thu, 16 Feb
 2023 06:05:47 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::a59e:bafb:f202:313c]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::a59e:bafb:f202:313c%5]) with mapi id 15.20.6086.024; Thu, 16 Feb 2023
 06:05:47 +0000
Message-ID: <3d185e02-3484-5226-76bf-e3ee98af8ed9@amd.com>
Date:   Thu, 16 Feb 2023 00:04:39 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v2 1/2] thunderbolt: Adjust how NVM reading works
To:     Mika Westerberg <mika.westerberg@linux.intel.com>
Cc:     Andreas Noever <andreas.noever@gmail.com>,
        Michael Jamet <michael.jamet@intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>, Sanju.Mehta@amd.com,
        stable@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230215172520.8925-1-mario.limonciello@amd.com>
 <20230215172520.8925-2-mario.limonciello@amd.com>
 <Y+3D+nRCXM4xhtwv@black.fi.intel.com>
Content-Language: en-US
From:   Mario Limonciello <mario.limonciello@amd.com>
In-Reply-To: <Y+3D+nRCXM4xhtwv@black.fi.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA0PR13CA0023.namprd13.prod.outlook.com
 (2603:10b6:806:130::28) To MN0PR12MB6101.namprd12.prod.outlook.com
 (2603:10b6:208:3cb::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR12MB6101:EE_|MN0PR12MB5954:EE_
X-MS-Office365-Filtering-Correlation-Id: 0574a6dd-745e-4e3a-2acc-08db0fe3d8ac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mZj+yxPGo3hM7Njerp4cCzRZDWv1NRxlC80gW8xkn8IUcoato9akqCtG/w5Liel8BQn8LQr+EG6UL+XO4uZQL3OieeuF4fC5jH8lPkpHha7XQJLR2fN6lR3q3m7E12/GuSimgnN1SlFhUYuAjWiaxSHjn8DokJsig8JyQ8RtKL8c/m5B61ltbMERdGuLX1S6al9rMN06QRhy6f2qKq5PU2BtLmIg1IoExvix0OKQEJ1V5fTRAKVlLzqCyLckGz0KfBHtVYMyl3rfcBQGSofJoilCPs0hJMcAOBJr5YxvHk/t9t6jhtTURYlbVs8o4jVpMsrd/mfVhPR/FWtuOsKsa1Nv+7RYh3PS5zn/rHU80Jh4IXwlT3WsN1o0t0Bt2qXXoUHOYATmZt6Sem0LpBj3Iu/kBZHTeQTW25yu4BQLkkEAesj4mzLGGHcdCD08iV1Y1p8As1R+CTfbo57+0Z8rEtFGSmXRPNArxIlCDePzs2zfKP1fFea0ml+CY+f5Ey70lK7QeWPa5hXAXpPKlCrcvti5kjLAGs2poUJRlXoY1xGzdKJBoLDzTq1aOZpLRI1Ya9K1tA//3Aey39A7fExt+HxHQOpM++wolGyciKxtGVVz41va+F+Yl69L0Q3GFoPuZ1imIhMYiMTa7qIVgXWTXS1lpZ7LOCMbuMVXWqL8C4jTD4HZoIv1k7l1jCpqEQNbTFToL3dB3e/cBwKLIyEisqKRflYiMXF7F2eit1AP7Ug=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(39860400002)(136003)(346002)(376002)(396003)(451199018)(66574015)(86362001)(31696002)(38100700002)(6486002)(36756003)(478600001)(6512007)(6506007)(6666004)(186003)(2616005)(83380400001)(53546011)(66556008)(66476007)(4326008)(2906002)(66946007)(6916009)(8676002)(5660300002)(8936002)(41300700001)(44832011)(31686004)(54906003)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S1pOanRJYXBncjNMZFRhNDJoMXZvVHBuNkpyb2IzekFqN3ZBNmg4Qmpmci9r?=
 =?utf-8?B?eHVYZngwUzA4RHUzNVB2ZDhkSC9YZHZwUituSVd4cVQ1SURZdEEyU3hxZFVT?=
 =?utf-8?B?bG1tcno4c0FyYTB6MFVxM0U3V2tRVTRrSldaTVJLa3EvWURTN1JGYURmb2lm?=
 =?utf-8?B?aFgwUDRZaEFJSVMybFdOWkgrZW9KbGNJeDg0d0R0RVBQU2xQK2t3MjZ1OHRi?=
 =?utf-8?B?a1RxTzZNWEpXYjJlOVFRRFhOeEJCckprNkN5cVkrbXUrZytzVEZkUm9MVDlo?=
 =?utf-8?B?Zzk4Mnk2QVV1M0xmRWNpSTVkM1RjQWd2MWxWQXdPN2NqT0Qwd1k0b015SnpE?=
 =?utf-8?B?UUYxR0tqUkE4c0JNZWtqWE1oaVZzMGE2ajkvYWRQcjJQN240Y0xkdzFKRjZZ?=
 =?utf-8?B?MW9GVGdaMXJjUlVLeWErbTRZbkFBbkViUW4vdXhmRGNzTFJ0d081Q3N4Zklv?=
 =?utf-8?B?WGNGbHJsaGhveHJXMUlSQk5PcXlNNDhuZnFac052SWFvdkNJNExLZFpmRmNB?=
 =?utf-8?B?MXdveEZ4MnV1Qnc4VGhjNFJYRURaY2tXK1NHRFlZVHh4c3JheG5yaUVCbGw1?=
 =?utf-8?B?Zk5KUENCVzFqcFZQY1JsUWZpK1F5c0ErSEMrd2VWbU9ZOEo4K3F0bFZPWnZI?=
 =?utf-8?B?anczV3NPUW9KU3lOdGRtV3hMMkVMY0EySThTV2NnS2ZRQ3MyT0swVWl3Umc1?=
 =?utf-8?B?d2ZrMTB4RlZoSVpPcjhjdG93ZFJVK0ZqWnZha2g3dm5ib0JQV0lHVDNNZ3ZQ?=
 =?utf-8?B?eEcvT2ljRmpFMHFpZVNzQ0pyYjcyMi80QzhJRGRYUkR0elN2WWYwR25PNjNY?=
 =?utf-8?B?MUF0QnRwcWVNSHRjMkxqRTQrRTMveXdCQVFOcG9yd3pFZXh4MjlWRk5TbEY2?=
 =?utf-8?B?YXhXWGZMQzJXcTB5T0ZJVDdGVXlkelhRRE1ObUo0T1R0ckVtV2J3ak1pUHpa?=
 =?utf-8?B?VHp1VE5Fai82VlZPZEgyVjA2eCt0eEFWM2I3Q0h4a0lpdGJCVHFoVUtMYksz?=
 =?utf-8?B?eVpGVkM5MnVrL0ZTc1BQVFcvVEhONS9mVzlDS2ZVclpQN0ZoTy9SY3VuME5P?=
 =?utf-8?B?K1ZOYitzV0lOdVU0UXVOaXM5VmN4SkJ4RWYzMk9GK1luSFZCWGtZSGFhbVkv?=
 =?utf-8?B?VkRGL3hIUG5DNmc4aStoSW9nakU2eHMzdzM4SUpldWlPMjVHM2JMUnllYTVp?=
 =?utf-8?B?ZGtCbDgrZUNOQ29HS1o1eFlyN1NjelBmMHpFYWFYTEV6dTNFazh5YjN1ZFMx?=
 =?utf-8?B?ZHQ5cERlNU15dXJyUXdzUUVMQmVUQXdNUDM5N2hTUWdtQklaL2xLSHNyWmVX?=
 =?utf-8?B?d3VmVjRMdExGdlVJeEVrRmZNalZkdWNKNmRQOHlvN1pGbndrZ2RuMHZQY0Vy?=
 =?utf-8?B?YkRYWVduazlDQ0ZxVkU1QnI1SGUzcXUwR2ZSaUhHbjhQaWFRanUvYlRqdkRp?=
 =?utf-8?B?WW54WGtpMWplbENWVUtqdFFPWFhyRSs1b2dQbzZTOW4rQWUrVElRaFRrOW92?=
 =?utf-8?B?cS9rR3ZXMTZTKzZaK04xcUpBblhrMEZGSTZuaWtXNll3SjE2ZlJoRTVwdWh0?=
 =?utf-8?B?a2c1VnhwKzJhQk1xT05WZ0Y4eGJKRXd5ZkpBNTJ5MjJ4TklvaVJXb0JZSXE0?=
 =?utf-8?B?SEdkMEhlbVdEUEFwRzZJTnYzdXo2WVdOOTR0dW5MaURWR3JXYy80enNYcWlm?=
 =?utf-8?B?TVRFZXlOTVhtS1BoMjB5MGM3aGMxY3VrU3VmTU56RFVxN201a29qYk41djJT?=
 =?utf-8?B?VHJzTStaTVQxdkdZZXYzc3BTOVNDdmY3dHd5dXJZdFVmb3JJY1dOU3RpY0xD?=
 =?utf-8?B?YW5DaEs5OFl2a0dYSFkrYzN5VWZ6aHVGbzFMbWpEZlRXMHo4WWNIdklONGdE?=
 =?utf-8?B?S3VWc25zbWhMaURxWGZqZEtSWWEwN3llUmRLcW5NWi9LQVlER2lTWFE1U3Iw?=
 =?utf-8?B?TWdMbi93VExFUmZOVWN6OTlITExFaWVWWCsrRnNuVkJqeGRtcXRhVVlnVFZH?=
 =?utf-8?B?RG5Yckxrcis1a2tFUU9JeGw4dVBKSDJjWDdTNXppQURqOVU2SDJFektrMGd5?=
 =?utf-8?B?WGo1MUwva0ZMeU9mYXJDWGlXSDJid2lpRE12Z2d0WUgrNlV6YllXZGdrbzBm?=
 =?utf-8?B?cWhpdlhnczVJTTZMNXVPREViUEFWSVplQnhMMUJyeEpubjQwRGtGNFM4VkpQ?=
 =?utf-8?Q?PnQrgYuTEDdSj+jbFTxNcAV1RY0sfO1MGzafVTfQTcO/?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0574a6dd-745e-4e3a-2acc-08db0fe3d8ac
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6101.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 06:05:47.1304
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NOYyqzj2tpeXwmytK20BjMPVWMWq5OuwcBW/RYH/Yr9EvUGrqqSO7nrUwunhfMJQFjTLkHSsW9w4SHatZ0YXpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5954
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 2/15/23 23:49, Mika Westerberg wrote:
> Hi Mario,
>
> On Wed, Feb 15, 2023 at 11:25:19AM -0600, Mario Limonciello wrote:
>> Some TBT3 devices have a hard time reliably responding to bit banging
>> requests correctly when connected to AMD USB4 hosts running Linux.
>>
>> These problems are not reported in any other CM supported on AMD platforms,
>> and comparing the Windows and Pre-OS implementations the Linux CM is the
>> only one that utilizes bit banging to access the DROM.
>> Other CM implementations access the DROM directly from the NVM instead of
>> bit banging.
>>
>> Adjust the flow to use this method to fetch the NVM when the downstream
>> device is Thunderbolt 3 and only use bit banging to access TBT 2 or TBT 1
>> devices. As the flow is modified, also remove the retry sequence that was
>> introduced from commit f022ff7bf377 ("thunderbolt: Retry DROM read once
>> if parsing fails") as it will not be necessary if the NVM is fetched this
>> way.
>>
>> Cc: stable@vger.kernel.org
>> Fixes: f022ff7bf377 ("thunderbolt: Retry DROM read once if parsing fails")
> I don't think it fixes a regression of above commit and I don't think
> this is stable material because it is quite a big change. I would rather
> let it sit in -rcX for a while to make sure no user visible changes are
> accidentally introduced. Is this OK for you?

No worry on dropping these two tags.  I'll do that for a v3.
The original change in v1 was more stable material than this is now.

While adopting your feedback below I'll keep in mind patch ordering
for refactoring as I do want to get the core of the solution back to stable
eventually when we're collectively confident on it.

> Did you check that the UUID of these (and other possible) devices stay
> the same before and after the patch?
Yeah I did across a few hotplug cycles and suspend cycles.
>
>> Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
>> ---
>> v1->v2:
>>   * Update commit message to indicate which CMs are tested
>>   * Adjust flow to only fetch DROM from NVM on TBT3 and bit bang on TBT1/2
>> ---
>>   drivers/thunderbolt/eeprom.c | 145 +++++++++++++++++++----------------
>>   1 file changed, 80 insertions(+), 65 deletions(-)
>>
>> diff --git a/drivers/thunderbolt/eeprom.c b/drivers/thunderbolt/eeprom.c
>> index c90d22f56d4e..d1be72b6afdb 100644
>> --- a/drivers/thunderbolt/eeprom.c
>> +++ b/drivers/thunderbolt/eeprom.c
>> @@ -416,7 +416,7 @@ static int tb_drom_parse_entries(struct tb_switch *sw, size_t header_size)
>>   		if (pos + 1 == drom_size || pos + entry->len > drom_size
>>   				|| !entry->len) {
>>   			tb_sw_warn(sw, "DROM buffer overrun\n");
>> -			return -EILSEQ;
>> +			return -EIO;
>>   		}
>>   
>>   		switch (entry->type) {
>> @@ -544,7 +544,37 @@ static int tb_drom_read_n(struct tb_switch *sw, u16 offset, u8 *val,
>>   	return tb_eeprom_read_n(sw, offset, val, count);
>>   }
>>   
>> -static int tb_drom_parse(struct tb_switch *sw)
>> +static int tb_drom_bit_bang(struct tb_switch *sw, u16 *size)
>> +{
>> +	int res;
>> +
>> +	res = tb_drom_read_n(sw, 14, (u8 *) size, 2);
>> +	if (res)
>> +		return res;
>> +	*size &= 0x3ff;
>> +	*size += TB_DROM_DATA_START;
>> +	tb_sw_dbg(sw, "reading drom (length: %#x)\n", *size);
>> +	if (*size < sizeof(struct tb_drom_header)) {
>> +		tb_sw_warn(sw, "drom too small, aborting\n");
>> +		return -EIO;
>> +	}
>> +
>> +	sw->drom = kzalloc(*size, GFP_KERNEL);
>> +	if (!sw->drom)
>> +		return -ENOMEM;
>> +
>> +	res = tb_drom_read_n(sw, 0, sw->drom, *size);
>> +	if (res)
>> +		goto err;
>> +
>> +	return 0;
>> +err:
>> +	kfree(sw->drom);
>> +	sw->drom = NULL;
>> +	return res;
>> +}
> Can you split the refactoring part into a separate patch?

Sure.

>> +
>> +static int tb_drom_parse_v1(struct tb_switch *sw)
>>   {
>>   	const struct tb_drom_header *header =
>>   		(const struct tb_drom_header *)sw->drom;
>> @@ -555,7 +585,7 @@ static int tb_drom_parse(struct tb_switch *sw)
>>   		tb_sw_warn(sw,
>>   			"DROM UID CRC8 mismatch (expected: %#x, got: %#x)\n",
>>   			header->uid_crc8, crc);
>> -		return -EILSEQ;
>> +		return -EIO;
>>   	}
>>   	if (!sw->uid)
>>   		sw->uid = header->uid;
>> @@ -589,6 +619,43 @@ static int usb4_drom_parse(struct tb_switch *sw)
>>   	return tb_drom_parse_entries(sw, USB4_DROM_HEADER_SIZE);
>>   }
>>   
>> +static int tb_drom_parse(struct tb_switch *sw, u16 *size)
>> +{
>> +	struct tb_drom_header *header = (void *) sw->drom;
>> +	int res;
>> +
>> +	if (header->data_len + TB_DROM_DATA_START != *size) {
>> +		tb_sw_warn(sw, "drom size mismatch\n");
>> +		goto err;
>> +	}
>> +
>> +	tb_sw_dbg(sw, "DROM version: %d\n", header->device_rom_revision);
>> +
>> +	switch (header->device_rom_revision) {
>> +	case 3:
>> +		res = usb4_drom_parse(sw);
>> +		break;
>> +	default:
>> +		tb_sw_warn(sw, "DROM device_rom_revision %#x unknown\n",
>> +			   header->device_rom_revision);
>> +		fallthrough;
>> +	case 1:
>> +		res = tb_drom_parse_v1(sw);
>> +		break;
>> +	}
>> +
>> +	if (res) {
>> +		tb_sw_warn(sw, "parsing DROM failed\n");
>> +		goto err;
>> +	}
>> +
>> +	return 0;
>> +err:
>> +	kfree(sw->drom);
>> +	sw->drom = NULL;
>> +	return -EIO;
>> +}
>> +
>>   /**
>>    * tb_drom_read() - Copy DROM to sw->drom and parse it
>>    * @sw: Router whose DROM to read and parse
>> @@ -602,8 +669,7 @@ static int usb4_drom_parse(struct tb_switch *sw)
>>   int tb_drom_read(struct tb_switch *sw)
>>   {
>>   	u16 size;
>> -	struct tb_drom_header *header;
>> -	int res, retries = 1;
>> +	int res;
>>   
>>   	if (sw->drom)
>>   		return 0;
>> @@ -614,11 +680,11 @@ int tb_drom_read(struct tb_switch *sw)
>>   		 * in a device property. Use it if available.
>>   		 */
>>   		if (tb_drom_copy_efi(sw, &size) == 0)
>> -			goto parse;
>> +			return tb_drom_parse(sw, &size);
>>   
>>   		/* Non-Apple hardware has the DROM as part of NVM */
>>   		if (tb_drom_copy_nvm(sw, &size) == 0)
>> -			goto parse;
>> +			return tb_drom_parse(sw, &size);
>>   
>>   		/*
>>   		 * USB4 hosts may support reading DROM through router
>> @@ -627,7 +693,7 @@ int tb_drom_read(struct tb_switch *sw)
>>   		if (tb_switch_is_usb4(sw)) {
>>   			usb4_switch_read_uid(sw, &sw->uid);
>>   			if (!usb4_copy_host_drom(sw, &size))
>> -				goto parse;
>> +				return tb_drom_parse(sw, &size);
>>   		} else {
>>   			/*
>>   			 * The root switch contains only a dummy drom
>> @@ -640,64 +706,13 @@ int tb_drom_read(struct tb_switch *sw)
>>   		return 0;
>>   	}
>>   
>> -	res = tb_drom_read_n(sw, 14, (u8 *) &size, 2);
>> +	/* TBT3 devices have the DROM as part of NVM */
>> +	if (sw->generation < 3)
> This is true for TBT2 devices too. I think you want to check for the
> sw->cap_lc here instead. If it is set the device has LC and therefore we
> can use the LC UUID registers to figure out the UUID in later stages.
> Otherwise we need to read it through bitbanging.
OK thanks, will adjust.
>> +		res = tb_drom_bit_bang(sw, &size);
>> +	else
>> +		res = tb_drom_copy_nvm(sw, &size);
>>   	if (res)
>>   		return res;
>> -	size &= 0x3ff;
>> -	size += TB_DROM_DATA_START;
>> -	tb_sw_dbg(sw, "reading drom (length: %#x)\n", size);
>> -	if (size < sizeof(*header)) {
>> -		tb_sw_warn(sw, "drom too small, aborting\n");
>> -		return -EIO;
>> -	}
>> -
>> -	sw->drom = kzalloc(size, GFP_KERNEL);
>> -	if (!sw->drom)
>> -		return -ENOMEM;
>> -read:
>> -	res = tb_drom_read_n(sw, 0, sw->drom, size);
>> -	if (res)
>> -		goto err;
>> -
>> -parse:
>> -	header = (void *) sw->drom;
>> -
>> -	if (header->data_len + TB_DROM_DATA_START != size) {
>> -		tb_sw_warn(sw, "drom size mismatch\n");
>> -		if (retries--) {
>> -			msleep(100);
>> -			goto read;
>> -		}
>> -		goto err;
>> -	}
>>   
>> -	tb_sw_dbg(sw, "DROM version: %d\n", header->device_rom_revision);
>> -
>> -	switch (header->device_rom_revision) {
>> -	case 3:
>> -		res = usb4_drom_parse(sw);
>> -		break;
>> -	default:
>> -		tb_sw_warn(sw, "DROM device_rom_revision %#x unknown\n",
>> -			   header->device_rom_revision);
>> -		fallthrough;
>> -	case 1:
>> -		res = tb_drom_parse(sw);
>> -		break;
>> -	}
>> -
>> -	/* If the DROM parsing fails, wait a moment and retry once */
>> -	if (res == -EILSEQ && retries--) {
>> -		tb_sw_warn(sw, "parsing DROM failed\n");
>> -		msleep(100);
>> -		goto read;
>> -	}
>> -
>> -	if (!res)
>> -		return 0;
>> -
>> -err:
>> -	kfree(sw->drom);
>> -	sw->drom = NULL;
>> -	return -EIO;
>> +	return tb_drom_parse(sw, &size);
>>   }
>> -- 
>> 2.34.1
