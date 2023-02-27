Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C8C46A4535
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 15:52:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229657AbjB0Owt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Feb 2023 09:52:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbjB0Ows (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Feb 2023 09:52:48 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2044.outbound.protection.outlook.com [40.107.102.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43D2522006;
        Mon, 27 Feb 2023 06:52:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PuaeAETuW714nYkq5lEuk7MH2cBY3Fh1yF/gogbJhjHlquFESNVJ8FbdZBADTA07o5vzviDUtutMRgRUTY7pAUcemRZ18zp3IZ+Kz3SnxAQQbyIXysPyvfbdGV6mhFmbZzyVKKQzM3hkggjfpuPgMTZArkspQxbmLzYF8RcTZfe9gPTDMKSLMAhqiAp3HSrp5pyalyifkDyvGZdXJlLIJdOX4wt81yUFsxumTydm3v6O5WDWmBV5z4XADi01Whlp6ymXla+hsY180Nsi7zEmLgJxCryF9ijPLZ3ymTe1tTgE12efgWINTbC6+XPvt1feNa4GFWXF7siI+OKjO7WLTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d/Y5RQh8Vm2oBKCPcTHPu34W1Lx46QogxImIbhRSc3I=;
 b=RbzW12KnCluLVPnIjxiW+5FujLDkyXZp/3kqdnz51oZUhmW30bLeiXaxM6jIQrfrHaqlTCvn5fuMgSCoZb3EX+oNq2VaeksHo2er9BiR37CwXPXzFlgeSqhzYhqlM3/RXo2C5KMMK2JFtstAu+CcCLKIrmZsxK/019bjVgB2JCAQmSn2I3zZLBMvEsgyLqcaMbkn63YqFqbBUHIn7RsRexjDTiAxb/TAR2HaB5YVgbZV2VrFFd/Yhv/XquUtZvyJ2BEUneqBnlJzBD7eRQdkej1iQO0jd9eAUcXdG5gnBzybKWScpVv+gDlX4T+bo99YVAjy4qO7FiLrwqE/31xubA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d/Y5RQh8Vm2oBKCPcTHPu34W1Lx46QogxImIbhRSc3I=;
 b=LO+UQXuxUlWPDgzG9nG4FzPMSBV7ASP3TKJ/m3XqHxsKP0N+qZPcuIPi/guq4RK4AdO36pyU0T1KTfSY7sopOUQlZUdKKlp9XlfPa0Ew4UsYs6VZ8rZa1FQlHS2SvSUe0jpMXDLbQbFLKtHA1Uj0bSH2OY+fQ8Z2Ry6z4NXRUJM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by BN9PR12MB5210.namprd12.prod.outlook.com (2603:10b6:408:11b::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.29; Mon, 27 Feb
 2023 14:52:30 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::a59e:bafb:f202:313c]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::a59e:bafb:f202:313c%6]) with mapi id 15.20.6134.029; Mon, 27 Feb 2023
 14:52:30 +0000
Message-ID: <915571f8-d055-90b9-3048-f629befd9a13@amd.com>
Date:   Mon, 27 Feb 2023 08:52:26 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v2] tpm: disable hwrng for fTPM on some AMD designs
Content-Language: en-US
To:     Peter Huewe <peterhuewe@gmx.de>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     stable@vger.kernel.org,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230220180729.23862-1-mario.limonciello@amd.com>
From:   Mario Limonciello <mario.limonciello@amd.com>
In-Reply-To: <20230220180729.23862-1-mario.limonciello@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR05CA0011.namprd05.prod.outlook.com
 (2603:10b6:805:de::24) To MN0PR12MB6101.namprd12.prod.outlook.com
 (2603:10b6:208:3cb::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR12MB6101:EE_|BN9PR12MB5210:EE_
X-MS-Office365-Filtering-Correlation-Id: cff89ec7-a8c2-4cf6-e083-08db18d24032
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: A5Hk5FLWsug/dX4EDeOIZxg7SPbnT2N1vkIzmtyg1QLUq0ILQq50P2WOdaAzO634fKxfvn0iuNhpOQA1qPi5oS1EKJ7otD0CiTZ5Igszf4ZpKGRdo1jKB3zjxg69i19mKFXm4PzaLtrNyTuaT7NOl0yab1H6SzW8s9t33Ce0SRkgWRnKBcplgELKDkcHrokW7/dOijGl2MuBTrwnwk2QGofDX6xMwiGfJ1itvfDmR0/KkW9aZj76nL8VyrF2MXvnOl0c8KPC08ujRI2iITxywZy0JwvQWg4syeM4nWEnOWMyqjdWPnmceF7mfEOVs1BMRmLHmVuIC/WckwsCvJ1HygG1mSd5f1mt4Z4cl9sKh1ua13CZWhpX4VCsmXnHIrwR2haCJl/9uClucOR4RAKW92LiSTvMA+z8UGQV4Ncjfzin+rKpQ785k5rG0RR/ImfnoN4JwjKucU4HJome4ePzcsuIMyFRwe6e99TnvvtwIcHwjadlhxVX55nbSdyu6MpiYT2KeJM3gFOL9LK0SIFNf7aAdQLOrvFq8dj4UOBiOMwKU8I6AQ7mAgSnmyuwLfKtqsUyZOZr3adqAewJaVXzw6N0R0UKtzfVI6JgGfu2/JHeW8yKWs//eS/e/W/Clu5g5ClFLClFVGgQE1/lTZSRzFi/BYwobowndPnVE+InvkkK8DfTtWjJdX+MyKpRV55Vt3Nt2/5Wg0sogfik+b4Nnl9rVla/hLFmdUJlSLwL9AGLgfXztJG6ez7NEJpG6p7+Ed5DWH8OLJykZdrSwZ5NSg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(396003)(346002)(136003)(376002)(366004)(451199018)(186003)(6512007)(6506007)(53546011)(6666004)(83380400001)(86362001)(36756003)(31696002)(38100700002)(2616005)(41300700001)(66476007)(66556008)(66946007)(4326008)(8676002)(44832011)(2906002)(8936002)(7416002)(5660300002)(31686004)(6486002)(966005)(316002)(110136005)(54906003)(478600001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VkxYeCs2RGlZL0Q1dTAxaWlyd2hHem10SlhTVERLZTdBd25vS0pjUVgvbnlY?=
 =?utf-8?B?MzlXY0NHZEdpN3lTbS9WeHE4SURpZi9rM1A0ZVRKcitTOHU3aFk5eFYrM2J0?=
 =?utf-8?B?U3h2TTNyNlVHdDFpYXR2L0Vva3JBYUt1YitXSytXQk1WdmpVeTlIME9TMWpv?=
 =?utf-8?B?Vk10RFN2d1NUd01NamJ6NmhzWmdXNnhoOXhOZGpmNmkyOFNtcUtHeGp4UGZs?=
 =?utf-8?B?WUxZU09IZXFCUStNWlpRS08vVlF0Rzd5MGVFaEllbXN5NXRPVU8rZ3ppZXl2?=
 =?utf-8?B?M0RTREhiVnNyN0diSXhzcGc3WC9iajZhZUluVWRyOGJjNXlYYVNJVUJyTUc5?=
 =?utf-8?B?cFJmV2s0TTUxeWQ1czJ6RDgzQ2I4K1RIQkpBRk1kNENrdFgvL1lWRkp1c1Qw?=
 =?utf-8?B?UjVIbVZjd3BTWmFYZmdLaHgwZU8zZGQ5U0V5M2gyTTg0UUNWWmROVU1YY0NK?=
 =?utf-8?B?OU01YytFZ0lQK2JUcVU0UzhDVFNJNzlpSE1odVJ0aFg0bHlpcXZxQVdoMGU3?=
 =?utf-8?B?eC96VkFxdmFYZzFxNStPRmVpSHp6aEd5SWo0VkthNVFXNkdDdkdSVUF2cER5?=
 =?utf-8?B?WC9xYnBITGlqZnlvRGVDbjZ5V0NtOXRQSzMxU0xJanBaQlBQUmV6TzVxSkcx?=
 =?utf-8?B?LzdqTk9WN2ZxTU1CemdCQ1hmdE5JRmpTQ2JDdElHWkE3ZWlpRjVZRFhqSDQw?=
 =?utf-8?B?R3ZwS3dyWXVqQ2hxanVJWFJVdWoxVjF1Q3pWWlBWVGYwdXBpUjJpSk1JdE0r?=
 =?utf-8?B?OWtNN1h5UU9CSks3NHh6OHpadmVYeXB6Zzkxc0hPT3lMc0dJK1ZMYldkRVFX?=
 =?utf-8?B?aEROZlkwMFdOWXc2UHFEYnVZVWtkL3luTkpzZEFJY0ZscE54bmNOajNpMFVJ?=
 =?utf-8?B?TmtVRHpCQW5ON3o0U0JDRXBsTjQ3OHJKWGRzV2syemNGWVZxaHFQUEVxaUNj?=
 =?utf-8?B?c0RjT2ZlWFdIY2FENDRnbWk1RXNwOVpPK1VpelpObnluRlovQlJXb2dsZnVj?=
 =?utf-8?B?MmIwTERvaHhyK0RXUW5YajB1cmNxKzUzZFlFSjcxMlBFejVxZ3pKQWdJVTQw?=
 =?utf-8?B?SUpiU3pLR05Sd3FEN0RlSXdpV200Wk5FMDVpa2xiMm9NL1h3S2ZQZ3AvdUI3?=
 =?utf-8?B?N2tyV1RuVVZLTG50U1ViSHpaTlNJeTJrZ3d1WGhnMzRYbjFCRWM2ZjZVQjBX?=
 =?utf-8?B?U1ZXOG9HdGsvTWMwQSszWEVuM1c1VmRScnR5NWRvZkJNMkpFREV5cWNnV0FT?=
 =?utf-8?B?MnJ0WWJzQjl2dm1ROHNGQXN2RkxtbyszZ0hwYjZxQTVtNnp5SnlMbjQwYU1T?=
 =?utf-8?B?YXZVNEMwMnBzaXppVTA5S0tyVkdpQVFSYXZTWkFHc051Nyt1OTdEc3MxUW5K?=
 =?utf-8?B?Vys4ZVl4UWR2YjBLbnFlRlI1WW9IS1JvREM1eXBuT0VrTmZFZ2JZMDlBelRF?=
 =?utf-8?B?RlNqY2gvOU5teE16OHlDYWFQZks1em5VZ0huWkszd0pIdGNlck1RMVR3TURm?=
 =?utf-8?B?YVdnNkdHaXZlY1hFM3hYR3JpakczcVQzY1FXK1VqcmxzT2l0Ui91RnlzRWl6?=
 =?utf-8?B?TUFMc0dLRklKcmxDZm11YjBRY0Ryc2NNOFFScEJheG5NR0h5NXgwRDRreEVO?=
 =?utf-8?B?d1BNbzgvWkxhSFNUS252cndwTGtFekh2Wm5IWnlYcG0yMXpkbnBEblVyWDlP?=
 =?utf-8?B?TUtnNmRoL1VncXNVSEZYdHZGUVBzYURHM0Z4bEprQ0M1RnJJNGJZbVB1QlFs?=
 =?utf-8?B?Y3lPTU1sTVFCWGF3VUZoM3l5UXNHSVdhM1hCZjN1S3AvL1BOWFZSeEhjbmZC?=
 =?utf-8?B?cGRJTGNmcDk3djRBZUdORWlzZVFYTmNLMEtIUjhZN1crZzZmNkIrbktHY1NO?=
 =?utf-8?B?Tjg1YUdZTmdLekxKaGtTdC9oZUs2WHE0amNVWDAyK2h5aWNJN1AxdmFiZ3cz?=
 =?utf-8?B?REZhV2l5eGlwdEJvRy9veUg2QzI0a1RSK2JlUnZlOUV2Y1M0SU1CNlIrYmpy?=
 =?utf-8?B?SzFNTHloT2lmeUU0akN3d1NpdURxVE00RVliZkIrR24zakIwSmsxbVVtR0Qx?=
 =?utf-8?B?QktkKzRBN3ZKYU45b0VlbXlwVG5nS2xQMDZJR2w4ZDZkcVlFdFFFcHJOaW5j?=
 =?utf-8?B?M09TUVdjNU1DM1FMYUgvRVVEc1lHVVdiVU1uR3FRSzUxZDNSb2YwNG9RYWpK?=
 =?utf-8?Q?RpVldk7eDgnSWt8h47pQxMw/GDmgebDd5QGy4o2bKsNg?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cff89ec7-a8c2-4cf6-e083-08db18d24032
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6101.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2023 14:52:30.4206
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qvzjSbNj0Q7tOsVJYaLcFFi+j8E6dp7puM2gwhwINRsHdPSsqQEO4CdOOV2zZrJ6krFLR57ZVU4Jv/sNtIDIBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5210
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/20/23 12:07, Mario Limonciello wrote:
> AMD has issued an advisory indicating that having fTPM enabled in
> BIOS can cause "stuttering" in the OS.  This issue has been fixed
> in newer versions of the fTPM firmware, but it's up to system
> designers to decide whether to distribute it.
> 
> This issue has existed for a while, but is more prevalent starting
> with kernel 6.1 because commit b006c439d58db ("hwrng: core - start
> hwrng kthread also for untrusted sources") started to use the fTPM
> for hwrng by default. However, all uses of /dev/hwrng result in
> unacceptable stuttering.
> 
> So, simply disable registration of the defective hwrng when detecting
> these faulty fTPM versions.  As this is caused by faulty firmware, it
> is plausible that such a problem could also be reproduced by other TPM
> interactions, but this hasn't been shown by any user's testing or reports.
> 
> It is hypothesized to be triggered more frequently by the use of the RNG
> because userspace software will fetch random numbers regularly.
> 
> Intentionally continue to register other TPM functionality so that users
> that rely upon PCR measurements or any storage of data will still have
> access to it.  If it's found later that another TPM functionality is
> exacerbating this problem a module parameter it can be turned off entirely
> and a module parameter can be introduced to allow users who rely upon
> fTPM functionality to turn it on even though this problem is present.
> 
> Link: https://www.amd.com/en/support/kb/faq/pa-410
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=216989
> Link: https://lore.kernel.org/all/20230209153120.261904-1-Jason@zx2c4.com/
> Fixes: b006c439d58d ("hwrng: core - start hwrng kthread also for untrusted sources")
> Cc: stable@vger.kernel.org
> Cc: Jarkko Sakkinen <jarkko@kernel.org>
> Cc: Thorsten Leemhuis <regressions@leemhuis.info>
> Cc: James Bottomley <James.Bottomley@hansenpartnership.com>
> Co-developed-by: Jason A. Donenfeld <Jason@zx2c4.com>
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
> ---
> v1->v2:
>   * Minor style from Jarkko's feedback
>   * Move comment above function
>   * Explain further in commit message

One of the reporters on the kernel bugzilla did confirm the v2 patch, 
forwarding their tag.

Tested-by: Bell <1138267643@qq.com>
> ---
>   drivers/char/tpm/tpm-chip.c | 61 ++++++++++++++++++++++++++++++-
>   drivers/char/tpm/tpm.h      | 73 +++++++++++++++++++++++++++++++++++++
>   2 files changed, 133 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
> index 741d8f3e8fb3..1b066d7a6e21 100644
> --- a/drivers/char/tpm/tpm-chip.c
> +++ b/drivers/char/tpm/tpm-chip.c
> @@ -512,6 +512,64 @@ static int tpm_add_legacy_sysfs(struct tpm_chip *chip)
>   	return 0;
>   }
>   
> +/*
> + * Some AMD fTPM versions may cause stutter
> + * https://www.amd.com/en/support/kb/faq/pa-410
> + *
> + * Fixes are available in two series of fTPM firmware:
> + * 6.x.y.z series: 6.0.18.6 +
> + * 3.x.y.z series: 3.57.y.5 +
> + */
> +static bool tpm_amd_is_rng_defective(struct tpm_chip *chip)
> +{
> +	u32 val1, val2;
> +	u64 version;
> +	int ret;
> +
> +	if (!(chip->flags & TPM_CHIP_FLAG_TPM2))
> +		return false;
> +
> +	ret = tpm_request_locality(chip);
> +	if (ret)
> +		return false;
> +
> +	ret = tpm2_get_tpm_pt(chip, TPM2_PT_MANUFACTURER, &val1, NULL);
> +	if (ret)
> +		goto release;
> +	if (val1 != 0x414D4400U /* AMD */) {
> +		ret = -ENODEV;
> +		goto release;
> +	}
> +	ret = tpm2_get_tpm_pt(chip, TPM2_PT_FIRMWARE_VERSION_1, &val1, NULL);
> +	if (ret)
> +		goto release;
> +	ret = tpm2_get_tpm_pt(chip, TPM2_PT_FIRMWARE_VERSION_2, &val2, NULL);
> +	if (ret)
> +		goto release;
> +
> +release:
> +	tpm_relinquish_locality(chip);
> +
> +	if (ret)
> +		return false;
> +
> +	version = ((u64)val1 << 32) | val2;
> +	if ((version >> 48) == 6) {
> +		if (version >= 0x0006000000180006ULL)
> +			return false;
> +	} else if ((version >> 48) == 3) {
> +		if (version >= 0x0003005700000005ULL)
> +			return false;
> +	} else
> +		return false;
> +
> +	dev_warn(&chip->dev,
> +		 "AMD fTPM version 0x%llx causes system stutter; hwrng disabled\n",
> +		 version);
> +
> +	return true;
> +}
> +
>   static int tpm_hwrng_read(struct hwrng *rng, void *data, size_t max, bool wait)
>   {
>   	struct tpm_chip *chip = container_of(rng, struct tpm_chip, hwrng);
> @@ -521,7 +579,8 @@ static int tpm_hwrng_read(struct hwrng *rng, void *data, size_t max, bool wait)
>   
>   static int tpm_add_hwrng(struct tpm_chip *chip)
>   {
> -	if (!IS_ENABLED(CONFIG_HW_RANDOM_TPM) || tpm_is_firmware_upgrade(chip))
> +	if (!IS_ENABLED(CONFIG_HW_RANDOM_TPM) || tpm_is_firmware_upgrade(chip) ||
> +	    tpm_amd_is_rng_defective(chip))
>   		return 0;
>   
>   	snprintf(chip->hwrng_name, sizeof(chip->hwrng_name),
> diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
> index 24ee4e1cc452..830014a26609 100644
> --- a/drivers/char/tpm/tpm.h
> +++ b/drivers/char/tpm/tpm.h
> @@ -150,6 +150,79 @@ enum tpm_sub_capabilities {
>   	TPM_CAP_PROP_TIS_DURATION = 0x120,
>   };
>   
> +enum tpm2_pt_props {
> +	TPM2_PT_NONE = 0x00000000,
> +	TPM2_PT_GROUP = 0x00000100,
> +	TPM2_PT_FIXED = TPM2_PT_GROUP * 1,
> +	TPM2_PT_FAMILY_INDICATOR = TPM2_PT_FIXED + 0,
> +	TPM2_PT_LEVEL = TPM2_PT_FIXED + 1,
> +	TPM2_PT_REVISION = TPM2_PT_FIXED + 2,
> +	TPM2_PT_DAY_OF_YEAR = TPM2_PT_FIXED + 3,
> +	TPM2_PT_YEAR = TPM2_PT_FIXED + 4,
> +	TPM2_PT_MANUFACTURER = TPM2_PT_FIXED + 5,
> +	TPM2_PT_VENDOR_STRING_1 = TPM2_PT_FIXED + 6,
> +	TPM2_PT_VENDOR_STRING_2 = TPM2_PT_FIXED + 7,
> +	TPM2_PT_VENDOR_STRING_3 = TPM2_PT_FIXED + 8,
> +	TPM2_PT_VENDOR_STRING_4 = TPM2_PT_FIXED + 9,
> +	TPM2_PT_VENDOR_TPM_TYPE = TPM2_PT_FIXED + 10,
> +	TPM2_PT_FIRMWARE_VERSION_1 = TPM2_PT_FIXED + 11,
> +	TPM2_PT_FIRMWARE_VERSION_2 = TPM2_PT_FIXED + 12,
> +	TPM2_PT_INPUT_BUFFER = TPM2_PT_FIXED + 13,
> +	TPM2_PT_HR_TRANSIENT_MIN = TPM2_PT_FIXED + 14,
> +	TPM2_PT_HR_PERSISTENT_MIN = TPM2_PT_FIXED + 15,
> +	TPM2_PT_HR_LOADED_MIN = TPM2_PT_FIXED + 16,
> +	TPM2_PT_ACTIVE_SESSIONS_MAX = TPM2_PT_FIXED + 17,
> +	TPM2_PT_PCR_COUNT = TPM2_PT_FIXED + 18,
> +	TPM2_PT_PCR_SELECT_MIN = TPM2_PT_FIXED + 19,
> +	TPM2_PT_CONTEXT_GAP_MAX = TPM2_PT_FIXED + 20,
> +	TPM2_PT_NV_COUNTERS_MAX = TPM2_PT_FIXED + 22,
> +	TPM2_PT_NV_INDEX_MAX = TPM2_PT_FIXED + 23,
> +	TPM2_PT_MEMORY = TPM2_PT_FIXED + 24,
> +	TPM2_PT_CLOCK_UPDATE = TPM2_PT_FIXED + 25,
> +	TPM2_PT_CONTEXT_HASH = TPM2_PT_FIXED + 26,
> +	TPM2_PT_CONTEXT_SYM = TPM2_PT_FIXED + 27,
> +	TPM2_PT_CONTEXT_SYM_SIZE = TPM2_PT_FIXED + 28,
> +	TPM2_PT_ORDERLY_COUNT = TPM2_PT_FIXED + 29,
> +	TPM2_PT_MAX_COMMAND_SIZE = TPM2_PT_FIXED + 30,
> +	TPM2_PT_MAX_RESPONSE_SIZE = TPM2_PT_FIXED + 31,
> +	TPM2_PT_MAX_DIGEST = TPM2_PT_FIXED + 32,
> +	TPM2_PT_MAX_OBJECT_CONTEXT = TPM2_PT_FIXED + 33,
> +	TPM2_PT_MAX_SESSION_CONTEXT = TPM2_PT_FIXED + 34,
> +	TPM2_PT_PS_FAMILY_INDICATOR = TPM2_PT_FIXED + 35,
> +	TPM2_PT_PS_LEVEL = TPM2_PT_FIXED + 36,
> +	TPM2_PT_PS_REVISION = TPM2_PT_FIXED + 37,
> +	TPM2_PT_PS_DAY_OF_YEAR = TPM2_PT_FIXED + 38,
> +	TPM2_PT_PS_YEAR = TPM2_PT_FIXED + 39,
> +	TPM2_PT_SPLIT_MAX = TPM2_PT_FIXED + 40,
> +	TPM2_PT_TOTAL_COMMANDS = TPM2_PT_FIXED + 41,
> +	TPM2_PT_LIBRARY_COMMANDS = TPM2_PT_FIXED + 42,
> +	TPM2_PT_VENDOR_COMMANDS = TPM2_PT_FIXED + 43,
> +	TPM2_PT_NV_BUFFER_MAX = TPM2_PT_FIXED + 44,
> +	TPM2_PT_MODES = TPM2_PT_FIXED + 45,
> +	TPM2_PT_MAX_CAP_BUFFER = TPM2_PT_FIXED + 46,
> +	TPM2_PT_VAR = TPM2_PT_GROUP * 2,
> +	TPM2_PT_PERMANENT = TPM2_PT_VAR + 0,
> +	TPM2_PT_STARTUP_CLEAR = TPM2_PT_VAR + 1,
> +	TPM2_PT_HR_NV_INDEX = TPM2_PT_VAR + 2,
> +	TPM2_PT_HR_LOADED = TPM2_PT_VAR + 3,
> +	TPM2_PT_HR_LOADED_AVAIL = TPM2_PT_VAR + 4,
> +	TPM2_PT_HR_ACTIVE = TPM2_PT_VAR + 5,
> +	TPM2_PT_HR_ACTIVE_AVAIL = TPM2_PT_VAR + 6,
> +	TPM2_PT_HR_TRANSIENT_AVAIL = TPM2_PT_VAR + 7,
> +	TPM2_PT_HR_PERSISTENT = TPM2_PT_VAR + 8,
> +	TPM2_PT_HR_PERSISTENT_AVAIL = TPM2_PT_VAR + 9,
> +	TPM2_PT_NV_COUNTERS = TPM2_PT_VAR + 10,
> +	TPM2_PT_NV_COUNTERS_AVAIL = TPM2_PT_VAR + 11,
> +	TPM2_PT_ALGORITHM_SET = TPM2_PT_VAR + 12,
> +	TPM2_PT_LOADED_CURVES = TPM2_PT_VAR + 13,
> +	TPM2_PT_LOCKOUT_COUNTER = TPM2_PT_VAR + 14,
> +	TPM2_PT_MAX_AUTH_FAIL = TPM2_PT_VAR + 15,
> +	TPM2_PT_LOCKOUT_INTERVAL = TPM2_PT_VAR + 16,
> +	TPM2_PT_LOCKOUT_RECOVERY = TPM2_PT_VAR + 17,
> +	TPM2_PT_NV_WRITE_RECOVERY = TPM2_PT_VAR + 18,
> +	TPM2_PT_AUDIT_COUNTER_0 = TPM2_PT_VAR + 19,
> +	TPM2_PT_AUDIT_COUNTER_1 = TPM2_PT_VAR + 20,
> +};
>   
>   /* 128 bytes is an arbitrary cap. This could be as large as TPM_BUFSIZE - 18
>    * bytes, but 128 is still a relatively large number of random bytes and

