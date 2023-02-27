Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6BCB6A4565
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 15:58:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229986AbjB0O6s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Feb 2023 09:58:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbjB0O6q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Feb 2023 09:58:46 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2042.outbound.protection.outlook.com [40.107.93.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8D3B7695;
        Mon, 27 Feb 2023 06:58:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hnZlSl/LY77n6e61wC3KttBy3CKXilapbC/KCvlk6PT/zQsYOZPSbqx0f4NCi7aQ1ih4yvo2a92Do83+7wEb63Xz2El1s9sVDJuJNFC5jQPrEfPOSBGWKMHyC+YccdbiStenm5E+EeZ2a9C1jDqOUBkLO1D2+GTDgEmn38qzecMQNA4oTSwwOz6s+L9cTJFU8Kf3R+s0/3a6okJZv9niSGAEO8TcPhqrZaHB/LwePa0Ca2hQCnwuAA6gYJzgU2v2rmUQKl5Trs/9wawpXHC8pQz7bua41To7K3796nMR77PdhYLnKpm2sCBydexo0YXMBhpLJvwNiXbGtIps/xVLBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=egrHDvH9k7+Q+DCzkS90CumKbJ69jFhqtzZuWKHUPAg=;
 b=VE6Wa+BBxOHhKG+xGWTliP1OLKEHX8H7vvl4jC3iaI9d7pN7HDbnrefbB5su4f8/+D70AVZvwP/cDL/IAFuQB+/+LxtAB3FUhJt+OeqcbmjOhP2YBJ2fskwwjKau51wpKOnsnE2IRYaMjX3BM9IC4rIT8yLlNjAg5zy5rI0yN0lRsHg8pS5qi2WdOrvk7U8GZXos5gquKZx/noHkP+3JZApgnp36Bn2Z6i8/63NHrXXDXTxJA0k8yuI8pYQGX+ZnpIyyyY91yEg7EotZOJ8UDiXsvvqBn41LbPQfoId2rSilV/6Pq1izwFgbVUO2WGlfTl599z0TuOv87q1kABcyyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=egrHDvH9k7+Q+DCzkS90CumKbJ69jFhqtzZuWKHUPAg=;
 b=TKOTfXAbFIsnXErnmS0TlQsaUlZgBW+hNpwz6R0l6INwTFxuGZX517vRFDZNxKMW+8HD5z4YLyJNyGIg2RdOBHkglcmJL/kSre1Sninx7XYSRJXE86HMUoYYsAlyqKNqnFGX1VTeQJuQUgxzQx8OyGNPlo5QMfYlwZKSSlIYDew=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by SA1PR12MB8141.namprd12.prod.outlook.com (2603:10b6:806:339::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.27; Mon, 27 Feb
 2023 14:58:41 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::a59e:bafb:f202:313c]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::a59e:bafb:f202:313c%6]) with mapi id 15.20.6134.029; Mon, 27 Feb 2023
 14:58:41 +0000
Message-ID: <7f5bd6a2-2eed-a27e-8655-181bb37a7c1c@amd.com>
Date:   Mon, 27 Feb 2023 08:58:37 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v2] tpm: disable hwrng for fTPM on some AMD designs
Content-Language: en-US
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Peter Huewe <peterhuewe@gmx.de>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        stable@vger.kernel.org,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230220180729.23862-1-mario.limonciello@amd.com>
 <20230227145554.GA3714281@roeck-us.net>
From:   Mario Limonciello <mario.limonciello@amd.com>
In-Reply-To: <20230227145554.GA3714281@roeck-us.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR16CA0062.namprd16.prod.outlook.com
 (2603:10b6:805:ca::39) To MN0PR12MB6101.namprd12.prod.outlook.com
 (2603:10b6:208:3cb::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR12MB6101:EE_|SA1PR12MB8141:EE_
X-MS-Office365-Filtering-Correlation-Id: 582f79d6-78c8-4519-8c8c-08db18d31d2a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y4t38GLLzQ6sgkR2IMHdoIjDI4ZJF0hAkw8DSz74/jl4tcdlimAz0ptlrR/LycEDSYPdanvymkLv37znBPEvky5RWGTMpDGo9uz3WsolhHqiEWurxC5QxeWCnLx5JPfWG90xH3Oe8Tv2UkFQIrX2x7wZ0Ug0992T/AoAZCb+uSy9326EZamHugdyHiXDy+de0Mi3oIj5tqdzecVC3bU40OXAURkXzSCJ0gXvszWXb1WXRdJYWLPCA8c+M7WwkeLoyMLExAyanZJcU/KLvOeVhPr1sMaUwnR9OOUA/15PrMuLR5xteRXpy2qq8vTrNnP5jdppx4xD1MKIlkgoGde2wqNbLdmofDhwVjAwRqrSGlsJKND7JbWTq2jxU+Wg99LGJKWUUzHWcGfH/P+1Q6WFWeMADp6qm37EPk0wa26/sgUrTnYE1gXxirmsJI9MRMRantLniaN4qP7uw78MmH7R18UbbLEmUO1Wdybgnb5zGPnrV3lC3QGF17HRolzhPQ2VXkgPapF6orli255xCOmfALDGwqlgWVZgFRmcQNTTKqwHQEaF+WuxqjVL71iwgK5jevOz/27h/2cDzAWggAwIP9lPX+jBQsdTX0oVmDiSMvwjMT/xGDnGt70W7/2JJXhZ+bqaZdCtKZDw9mnNH+y3pYczQMn32Lb+cNOQwYJuIhIPcqVDGffW3zsJv7gtRZJk9TcB7rxYf3qebXU/uWZFacIF0guilp+4Khxx84diU5oJ76GQ1VjeFJcAKsy8wODy
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(376002)(346002)(366004)(136003)(39860400002)(451199018)(36756003)(6666004)(6486002)(966005)(6512007)(6506007)(4326008)(186003)(53546011)(54906003)(2616005)(316002)(41300700001)(66946007)(44832011)(66476007)(2906002)(6916009)(478600001)(8936002)(5660300002)(7416002)(38100700002)(86362001)(31696002)(66556008)(83380400001)(8676002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y25IbGlXN2VjaGtOQU1kRzVYRTBnRnBjcXVNN1ZDa0lDTFJNOWxFeFErcTkw?=
 =?utf-8?B?czkxVEc2aE5XTWJpNThqa1JRY2JqNXhhUWdFRk9oQnIwMmZveGhRWUs0dFlM?=
 =?utf-8?B?bEdhMUpLWDA4cFRGYW9MSHFRYmRTdm4vL2M5UVROT0xXQ2J0OHd5SUExMFJX?=
 =?utf-8?B?eW5PV1BReTlzVzBWc3p5d25zZ3ZEN1BpSU5MVnlWZTBMM3NFRFJvRnUveHdS?=
 =?utf-8?B?THBIdkdKL1dBSEF5QmFORU4xOW41Qkl6eE1UeXlGMGtSdmdLRE4wM1lXbzhP?=
 =?utf-8?B?Qm9RRGR5NnBXZHkvYVFKcXBMMmx4NlBGdjdHbEZ1WHVaYnN6T2lLY2RCdlVU?=
 =?utf-8?B?Vkd6b2NRSGhMVUF3dzhmOC9sTTd4bW5WOVRoRG82bTNmWjc0UHRSSzB2eGp6?=
 =?utf-8?B?ZStXR1Y2enBwdHZScFJmY0Y1ZVVjWmM0SndUT0FXSk4rQTQyTnRtOW5oZzBT?=
 =?utf-8?B?Y2lxdHFNbzd6aUJCYW5BU0IzRnFwczNBbnlYU244b0duOXZVbXZteHg4WDhL?=
 =?utf-8?B?cGd5ckV6TU9Ic2M4ZmNyRGVYQWp6SHJLNzl5NHUxQXpPVWhEWm5GenFoZnVQ?=
 =?utf-8?B?d2pSQk0yY0JkT21Mb1pOOWxJSE93SFRjYmdnbnVvL2s5QklxdWY5QWVpb3lJ?=
 =?utf-8?B?U0VtRG5xU3NCRmp4VHZOeDdlRWFxeXdEZExZQTdBcWFXQ21hSlR5UzNOQkR0?=
 =?utf-8?B?bllrVzRzU0lvTC90OE0yZW1NOEh1T1YxcWRMaW9FM01PNFhHUWtJbkp2aDhu?=
 =?utf-8?B?akxvc3hoN2lvdlppbjZqd0dHSmFuQi9SKzFPaXdvaXliU0tMMWhmd29UTXFX?=
 =?utf-8?B?RTVGMlpkbTZMcUxzWEdmOUQyTnB6K1NORkZGRU1WTWV1NzM2aDhvMEQralJl?=
 =?utf-8?B?aWZXaHZneVhhZ0J5YjhJRjJua0MwUloycGxPQWZJcFVTdE9RVytlWW50Nzgv?=
 =?utf-8?B?c0F3SE5ZK2ZJZkw2YkhEWnRnVnFRTG5PNXJkOS9QUUEvSDlMajhNNERJVW03?=
 =?utf-8?B?MC84T3c1dlY3VFpZM2wzMlJTOTFJS3FsdjQ4MFVIR3dORWFoS0lMZyttWHpl?=
 =?utf-8?B?eEpJbUlUNEFXSU9BdHgrT25ydXduaXI0ejZyU3NpeEpiM2wyL1lSYkJKN1Fl?=
 =?utf-8?B?NGE3VTVna3FPaFhFbzUrVEYrYVRjY0RYbHU2NGFrc1p2RllWejYvckRYMFMy?=
 =?utf-8?B?SWxNbnMxendlekVoMlNuYzlYM1czTHJqSG1LM3ZhYm8yTklXWFEyMzhjQTBR?=
 =?utf-8?B?cHRiTkZrR1FteEJCck5WMjdFRHBmbjFkWk82Zk5qUGNHQmVHTm9wNU9ZdG1B?=
 =?utf-8?B?Yk0vQ0F1MXEwQ2xWMW5FMGgvTS9oVGxJc01UY0RVZFBwbGZWYjFxSys4NlFI?=
 =?utf-8?B?cENlbTZvb3FkV1RBYUYwRHY0czRzOG1NUXpNV3B1N2paOEZrczlnK3NlVFc5?=
 =?utf-8?B?WjNCQ0p3NG9iVHNSNitONzMzNi9RZkxsZDRlL1NGS2tEWnhZZmhYRWpSUElO?=
 =?utf-8?B?aEhTUVF1SGJTa2xadTZ3bEM1YWhORXFwRVRKTWJoNTVEVCswNVoyY0RvRTZ4?=
 =?utf-8?B?UU1LclBOY3dadlpjdXVQaXZYZUtkZHJhc0preGxxSXdIVkJOSFJWUzdkTWw2?=
 =?utf-8?B?WW43TWUzQzYyTm52M0FGMngwaVVXQ01sUU96dFhOY2hpd281a3hxRWRBVG5x?=
 =?utf-8?B?V1RROTVyYnNWQU9pZGw2MXQrSmNqa1FEb3VaSmFFVUFUcUwwd1g0aFdxdU1y?=
 =?utf-8?B?S0hrVGpZdytkSEFqNkQ1SEtYS0lKN2xlYjJMWld1bytKVm42Y1FuWFV6Vk84?=
 =?utf-8?B?Nk5wTVBCNnl3b3ZMUzhtRnFJanlvMnlpeHdnaW9nbkZyNUdQMUJIU1FYd01G?=
 =?utf-8?B?RnE2MnE0SWIvcEZpWnFlNCtBUkNyVnNmaG12bzBTaGhPN3Z2dGFTOW1WMFp1?=
 =?utf-8?B?N3N2bHV6bE53am1XbGkzTEFZVUEzNTlvek5zTGdpQ3FlOURQb05ZbzNlUUtG?=
 =?utf-8?B?dlFNRUpyait4NHVaMUpiYzJQc1VQYWhSYzk0c2tyZXB1WVR2M2RGUVNYZ01P?=
 =?utf-8?B?VTdvOEdabEs4VGFiOHBmaE5vc2hJYWxrNVNLeU1tK1pqMGpLbGtmZXFoT25l?=
 =?utf-8?B?WFRNREhpREZpeitma1YxVms0WlJnWld5L1ZRMjZYYm1VUUVLUytKZWxCbHJZ?=
 =?utf-8?Q?x5XXI3VT8QrINfdQrt0/07Jmaa1JZj6LtZCIjsum6JXx?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 582f79d6-78c8-4519-8c8c-08db18d31d2a
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6101.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2023 14:58:41.1269
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /Q5WmsgEW3tA3E9qGWWCJmUQr5nJ/CJF0vvso8dagJHYseSzSHfaae8mN0w4k/1nMYE4uhzn38VKNDNs89IxNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8141
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/27/23 08:55, Guenter Roeck wrote:
> On Mon, Feb 20, 2023 at 12:07:28PM -0600, Mario Limonciello wrote:
>> AMD has issued an advisory indicating that having fTPM enabled in
>> BIOS can cause "stuttering" in the OS.  This issue has been fixed
>> in newer versions of the fTPM firmware, but it's up to system
>> designers to decide whether to distribute it.
>>
>> This issue has existed for a while, but is more prevalent starting
>> with kernel 6.1 because commit b006c439d58db ("hwrng: core - start
>> hwrng kthread also for untrusted sources") started to use the fTPM
>> for hwrng by default. However, all uses of /dev/hwrng result in
>> unacceptable stuttering.
>>
>> So, simply disable registration of the defective hwrng when detecting
>> these faulty fTPM versions.  As this is caused by faulty firmware, it
>> is plausible that such a problem could also be reproduced by other TPM
>> interactions, but this hasn't been shown by any user's testing or reports.
>>
>> It is hypothesized to be triggered more frequently by the use of the RNG
>> because userspace software will fetch random numbers regularly.
>>
>> Intentionally continue to register other TPM functionality so that users
>> that rely upon PCR measurements or any storage of data will still have
>> access to it.  If it's found later that another TPM functionality is
>> exacerbating this problem a module parameter it can be turned off entirely
>> and a module parameter can be introduced to allow users who rely upon
>> fTPM functionality to turn it on even though this problem is present.
>>
>> Link: https://www.amd.com/en/support/kb/faq/pa-410
>> Link: https://bugzilla.kernel.org/show_bug.cgi?id=216989
>> Link: https://lore.kernel.org/all/20230209153120.261904-1-Jason@zx2c4.com/
>> Fixes: b006c439d58d ("hwrng: core - start hwrng kthread also for untrusted sources")
>> Cc: stable@vger.kernel.org
>> Cc: Jarkko Sakkinen <jarkko@kernel.org>
>> Cc: Thorsten Leemhuis <regressions@leemhuis.info>
>> Cc: James Bottomley <James.Bottomley@hansenpartnership.com>
>> Co-developed-by: Jason A. Donenfeld <Jason@zx2c4.com>
>> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
>> Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
>> ---
>> v1->v2:
>>   * Minor style from Jarkko's feedback
>>   * Move comment above function
>>   * Explain further in commit message
>> ---
>>   drivers/char/tpm/tpm-chip.c | 61 ++++++++++++++++++++++++++++++-
>>   drivers/char/tpm/tpm.h      | 73 +++++++++++++++++++++++++++++++++++++
>>   2 files changed, 133 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
>> index 741d8f3e8fb3..1b066d7a6e21 100644
>> --- a/drivers/char/tpm/tpm-chip.c
>> +++ b/drivers/char/tpm/tpm-chip.c
>> @@ -512,6 +512,64 @@ static int tpm_add_legacy_sysfs(struct tpm_chip *chip)
>>   	return 0;
>>   }
>>   
>> +/*
>> + * Some AMD fTPM versions may cause stutter
>> + * https://www.amd.com/en/support/kb/faq/pa-410
>> + *
>> + * Fixes are available in two series of fTPM firmware:
>> + * 6.x.y.z series: 6.0.18.6 +
>> + * 3.x.y.z series: 3.57.y.5 +
>> + */
>> +static bool tpm_amd_is_rng_defective(struct tpm_chip *chip)
>> +{
>> +	u32 val1, val2;
>> +	u64 version;
>> +	int ret;
>> +
>> +	if (!(chip->flags & TPM_CHIP_FLAG_TPM2))
>> +		return false;
>> +
>> +	ret = tpm_request_locality(chip);
>> +	if (ret)
>> +		return false;
>> +
>> +	ret = tpm2_get_tpm_pt(chip, TPM2_PT_MANUFACTURER, &val1, NULL);
>> +	if (ret)
>> +		goto release;
>> +	if (val1 != 0x414D4400U /* AMD */) {
>> +		ret = -ENODEV;
>> +		goto release;
>> +	}
>> +	ret = tpm2_get_tpm_pt(chip, TPM2_PT_FIRMWARE_VERSION_1, &val1, NULL);
>> +	if (ret)
>> +		goto release;
>> +	ret = tpm2_get_tpm_pt(chip, TPM2_PT_FIRMWARE_VERSION_2, &val2, NULL);
>> +	if (ret)
>> +		goto release;
> 
> This goto is unnecessary.
> 
>> +
>> +release:
>> +	tpm_relinquish_locality(chip);
>> +
>> +	if (ret)
>> +		return false;
>> +
>> +	version = ((u64)val1 << 32) | val2;
>> +	if ((version >> 48) == 6) {
>> +		if (version >= 0x0006000000180006ULL)
>> +			return false;
>> +	} else if ((version >> 48) == 3) {
>> +		if (version >= 0x0003005700000005ULL)
>> +			return false;
>> +	} else
>> +		return false;
> 
> checkpatch:
> 
> CHECK: braces {} should be used on all arms of this statement
> #200: FILE: drivers/char/tpm/tpm-chip.c:557:
> +	if ((version >> 48) == 6) {
> [...]
> +	} else if ((version >> 48) == 3) {
> [...]
> +	} else
> [...]

It was requested by Jarko explicitly in v1 to do it this way.

https://lore.kernel.org/lkml/Y+%2F6G+UlTI7GpW6o@kernel.org/

> 
>> +
>> +	dev_warn(&chip->dev,
>> +		 "AMD fTPM version 0x%llx causes system stutter; hwrng disabled\n",
>> +		 version);
>> +
>> +	return true;
>> +}
>> +
>>   static int tpm_hwrng_read(struct hwrng *rng, void *data, size_t max, bool wait)
>>   {
>>   	struct tpm_chip *chip = container_of(rng, struct tpm_chip, hwrng);
>> @@ -521,7 +579,8 @@ static int tpm_hwrng_read(struct hwrng *rng, void *data, size_t max, bool wait)
>>   
>>   static int tpm_add_hwrng(struct tpm_chip *chip)
>>   {
>> -	if (!IS_ENABLED(CONFIG_HW_RANDOM_TPM) || tpm_is_firmware_upgrade(chip))
>> +	if (!IS_ENABLED(CONFIG_HW_RANDOM_TPM) || tpm_is_firmware_upgrade(chip) ||
>> +	    tpm_amd_is_rng_defective(chip))
>>   		return 0;
>>   
>>   	snprintf(chip->hwrng_name, sizeof(chip->hwrng_name),
>> diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
>> index 24ee4e1cc452..830014a26609 100644
>> --- a/drivers/char/tpm/tpm.h
>> +++ b/drivers/char/tpm/tpm.h
>> @@ -150,6 +150,79 @@ enum tpm_sub_capabilities {
>>   	TPM_CAP_PROP_TIS_DURATION = 0x120,
>>   };
>>   
>> +enum tpm2_pt_props {
>> +	TPM2_PT_NONE = 0x00000000,
>> +	TPM2_PT_GROUP = 0x00000100,
>> +	TPM2_PT_FIXED = TPM2_PT_GROUP * 1,
>> +	TPM2_PT_FAMILY_INDICATOR = TPM2_PT_FIXED + 0,
>> +	TPM2_PT_LEVEL = TPM2_PT_FIXED + 1,
>> +	TPM2_PT_REVISION = TPM2_PT_FIXED + 2,
>> +	TPM2_PT_DAY_OF_YEAR = TPM2_PT_FIXED + 3,
>> +	TPM2_PT_YEAR = TPM2_PT_FIXED + 4,
>> +	TPM2_PT_MANUFACTURER = TPM2_PT_FIXED + 5,
>> +	TPM2_PT_VENDOR_STRING_1 = TPM2_PT_FIXED + 6,
>> +	TPM2_PT_VENDOR_STRING_2 = TPM2_PT_FIXED + 7,
>> +	TPM2_PT_VENDOR_STRING_3 = TPM2_PT_FIXED + 8,
>> +	TPM2_PT_VENDOR_STRING_4 = TPM2_PT_FIXED + 9,
>> +	TPM2_PT_VENDOR_TPM_TYPE = TPM2_PT_FIXED + 10,
>> +	TPM2_PT_FIRMWARE_VERSION_1 = TPM2_PT_FIXED + 11,
>> +	TPM2_PT_FIRMWARE_VERSION_2 = TPM2_PT_FIXED + 12,
>> +	TPM2_PT_INPUT_BUFFER = TPM2_PT_FIXED + 13,
>> +	TPM2_PT_HR_TRANSIENT_MIN = TPM2_PT_FIXED + 14,
>> +	TPM2_PT_HR_PERSISTENT_MIN = TPM2_PT_FIXED + 15,
>> +	TPM2_PT_HR_LOADED_MIN = TPM2_PT_FIXED + 16,
>> +	TPM2_PT_ACTIVE_SESSIONS_MAX = TPM2_PT_FIXED + 17,
>> +	TPM2_PT_PCR_COUNT = TPM2_PT_FIXED + 18,
>> +	TPM2_PT_PCR_SELECT_MIN = TPM2_PT_FIXED + 19,
>> +	TPM2_PT_CONTEXT_GAP_MAX = TPM2_PT_FIXED + 20,
>> +	TPM2_PT_NV_COUNTERS_MAX = TPM2_PT_FIXED + 22,
>> +	TPM2_PT_NV_INDEX_MAX = TPM2_PT_FIXED + 23,
>> +	TPM2_PT_MEMORY = TPM2_PT_FIXED + 24,
>> +	TPM2_PT_CLOCK_UPDATE = TPM2_PT_FIXED + 25,
>> +	TPM2_PT_CONTEXT_HASH = TPM2_PT_FIXED + 26,
>> +	TPM2_PT_CONTEXT_SYM = TPM2_PT_FIXED + 27,
>> +	TPM2_PT_CONTEXT_SYM_SIZE = TPM2_PT_FIXED + 28,
>> +	TPM2_PT_ORDERLY_COUNT = TPM2_PT_FIXED + 29,
>> +	TPM2_PT_MAX_COMMAND_SIZE = TPM2_PT_FIXED + 30,
>> +	TPM2_PT_MAX_RESPONSE_SIZE = TPM2_PT_FIXED + 31,
>> +	TPM2_PT_MAX_DIGEST = TPM2_PT_FIXED + 32,
>> +	TPM2_PT_MAX_OBJECT_CONTEXT = TPM2_PT_FIXED + 33,
>> +	TPM2_PT_MAX_SESSION_CONTEXT = TPM2_PT_FIXED + 34,
>> +	TPM2_PT_PS_FAMILY_INDICATOR = TPM2_PT_FIXED + 35,
>> +	TPM2_PT_PS_LEVEL = TPM2_PT_FIXED + 36,
>> +	TPM2_PT_PS_REVISION = TPM2_PT_FIXED + 37,
>> +	TPM2_PT_PS_DAY_OF_YEAR = TPM2_PT_FIXED + 38,
>> +	TPM2_PT_PS_YEAR = TPM2_PT_FIXED + 39,
>> +	TPM2_PT_SPLIT_MAX = TPM2_PT_FIXED + 40,
>> +	TPM2_PT_TOTAL_COMMANDS = TPM2_PT_FIXED + 41,
>> +	TPM2_PT_LIBRARY_COMMANDS = TPM2_PT_FIXED + 42,
>> +	TPM2_PT_VENDOR_COMMANDS = TPM2_PT_FIXED + 43,
>> +	TPM2_PT_NV_BUFFER_MAX = TPM2_PT_FIXED + 44,
>> +	TPM2_PT_MODES = TPM2_PT_FIXED + 45,
>> +	TPM2_PT_MAX_CAP_BUFFER = TPM2_PT_FIXED + 46,
>> +	TPM2_PT_VAR = TPM2_PT_GROUP * 2,
>> +	TPM2_PT_PERMANENT = TPM2_PT_VAR + 0,
>> +	TPM2_PT_STARTUP_CLEAR = TPM2_PT_VAR + 1,
>> +	TPM2_PT_HR_NV_INDEX = TPM2_PT_VAR + 2,
>> +	TPM2_PT_HR_LOADED = TPM2_PT_VAR + 3,
>> +	TPM2_PT_HR_LOADED_AVAIL = TPM2_PT_VAR + 4,
>> +	TPM2_PT_HR_ACTIVE = TPM2_PT_VAR + 5,
>> +	TPM2_PT_HR_ACTIVE_AVAIL = TPM2_PT_VAR + 6,
>> +	TPM2_PT_HR_TRANSIENT_AVAIL = TPM2_PT_VAR + 7,
>> +	TPM2_PT_HR_PERSISTENT = TPM2_PT_VAR + 8,
>> +	TPM2_PT_HR_PERSISTENT_AVAIL = TPM2_PT_VAR + 9,
>> +	TPM2_PT_NV_COUNTERS = TPM2_PT_VAR + 10,
>> +	TPM2_PT_NV_COUNTERS_AVAIL = TPM2_PT_VAR + 11,
>> +	TPM2_PT_ALGORITHM_SET = TPM2_PT_VAR + 12,
>> +	TPM2_PT_LOADED_CURVES = TPM2_PT_VAR + 13,
>> +	TPM2_PT_LOCKOUT_COUNTER = TPM2_PT_VAR + 14,
>> +	TPM2_PT_MAX_AUTH_FAIL = TPM2_PT_VAR + 15,
>> +	TPM2_PT_LOCKOUT_INTERVAL = TPM2_PT_VAR + 16,
>> +	TPM2_PT_LOCKOUT_RECOVERY = TPM2_PT_VAR + 17,
>> +	TPM2_PT_NV_WRITE_RECOVERY = TPM2_PT_VAR + 18,
>> +	TPM2_PT_AUDIT_COUNTER_0 = TPM2_PT_VAR + 19,
>> +	TPM2_PT_AUDIT_COUNTER_1 = TPM2_PT_VAR + 20,
>> +};
>>   
>>   /* 128 bytes is an arbitrary cap. This could be as large as TPM_BUFSIZE - 18
>>    * bytes, but 128 is still a relatively large number of random bytes and
>> -- 
>> 2.34.1
>>

