Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9B7A571FDC
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 17:47:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233131AbiGLPrb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 11:47:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbiGLPra (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 11:47:30 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2052.outbound.protection.outlook.com [40.107.223.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DA0DC54B9
        for <stable@vger.kernel.org>; Tue, 12 Jul 2022 08:47:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MXzs7dd/yvxWlDKjLugfWhZylzJogBHTnbDlHPAb8v2mLNEofjQA6mOHTexhDpZnpvyB60vUDgCUqo9stxER11Ym1glTwL8CePpicJ9BpsfPp4yT6u9MAoceK3jdxwTwJEJgV0nPUxSyjNp65zTpjPHsv6ZeeHH98TS17mbjt2KuTluKfEMDqzjnfgwuIC7BMIZrCEc9uyOo4nrORmf/ulFKF/7WC44Uc+aorREO3jN1TwrLTFcXh9psGuRk92IvBf3FdBiKWJmJro2fzZ+n1FiEY/MWRKsyTTXJSfOgeM+6CuwLRW/JePsrQkZdJHy2Hnq4s3BYJWyKct4M4yo4Rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jx9BjQfgVJjMtkADoFZxH3c1TjdrRbSq/PsqbqUFdD0=;
 b=drY+znwUdcjWFydpa0/XgDHj4S5ZBRsBUAAZNxNsotI9p34tIkS7pItm9VeD06XpdngxEgJGDyDkOAADlDnzjjdCDidRWBekFL1OriLb+ylsurDPay3ZueQXgcELqohenUzIOSeAr+9Au+phZtdgBZ7wjSX/JpFA+DdVvNOCw2dMnoRgciEa8lmUh79cnIJs5fKsylGwP6XvM79YKW4T1UNx/z8DU8B9uHegiO8hOeqzJ+93nnt8RGjjDs2TddOP9u+oOZxBigp1GiNo00DweSz2070D1B4yu/DKqFrRCgOSPLpHf0Imuzcaa/RA57PNNs6tg3oMtq8OcjJqkIOvYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jx9BjQfgVJjMtkADoFZxH3c1TjdrRbSq/PsqbqUFdD0=;
 b=HP3Zeurrnr0rkUbLVzTLoNF/xWd4c72vHcm6FjiTO2ptXvTkB3TlRIDZO4i4rilWXjtN2n2jGyJxddzaDz1RvdlxmWgtRY/KqxJhsC2y+vYvz2143cP2SN15DdazYdebjBod9Avrl9Ive26Zk/7HBCcAHXNo4v+NlrxwZJsX04o=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by BYAPR12MB2792.namprd12.prod.outlook.com (2603:10b6:a03:65::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.20; Tue, 12 Jul
 2022 15:47:24 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::1143:10a5:987a:7598]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::1143:10a5:987a:7598%6]) with mapi id 15.20.5417.026; Tue, 12 Jul 2022
 15:47:24 +0000
Message-ID: <e8d31984-3505-965a-115d-85114d161348@amd.com>
Date:   Tue, 12 Jul 2022 10:47:21 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [21/21] drm/amd/display: Ignore First MST Sideband Message Return
 Error
Content-Language: en-US
To:     Solomon Chiu <solomon.chiu@amd.com>, amd-gfx@lists.freedesktop.org
Cc:     stylon.wang@amd.com, Sunpeng.Li@amd.com, Harry.Wentland@amd.com,
        qingqing.zhuo@amd.com, Rodrigo.Siqueira@amd.com, roman.li@amd.com,
        stable@vger.kernel.org, Daniel Wheeler <daniel.wheeler@amd.com>,
        Fangzhi Zuo <Jerry.Zuo@amd.com>, Aurabindo.Pillai@amd.com,
        wayne.lin@amd.com, Bhawanpreet.Lakha@amd.com,
        agustin.gutierrez@amd.com, pavle.kotarac@amd.com
References: <20220712154232.501735-1-solomon.chiu@amd.com>
From:   "Limonciello, Mario" <mario.limonciello@amd.com>
In-Reply-To: <20220712154232.501735-1-solomon.chiu@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BLAPR03CA0077.namprd03.prod.outlook.com
 (2603:10b6:208:329::22) To MN0PR12MB6101.namprd12.prod.outlook.com
 (2603:10b6:208:3cb::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 62ef7768-bb13-4578-3630-08da641dd0ac
X-MS-TrafficTypeDiagnostic: BYAPR12MB2792:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HXbRWGpDH8/Rg0VklRNNADLlgOJkcYB5oOYY2A8ifs7CGKQa7hIIOoQuTp1t1cyhRaHS4uINJx055Ha4C6NKGbJjBjWsFgciocEu1rVlxcGFCx28QpGRm21OGZJ+qWBPXdeexJlZQ8oOT18mDxdE26TqmR5X6p/FH4jZTwowprD7ytqygdLcdY7Uoa06lgOW6zsaAWxrknmBDy5K1SV+O6waO7caUXuJu7BXI4M38lrBwiUbldmxBMEGrFh5Jm+uVMzhJM1o9EpDsXhSow8qC0hAPWUxWQfomBzwz/KH072EY41h/uMHW7A6cJW6w2R0jXsXjGTtR/pCRl8SSgNmx+w1WgVp3XdId+T4EokiplLEgatzM8em7/yEzC3MQRlPiEp15TNjh7M1+wWwCCKmknnT0fVKM/IFDyKNAHVHysLwQTV2a0DjdQDMFnxWPhs8gsgH1siHTp0rt0JRhOKBsHXDy2gO08dX23G+ugAvkWwhHIC2Q2A/7rrQ94xGZ40EFmTutHUAhN3Q7gEvsFMmYMnXprlv/QHbNl96rgK+Oi0+yvvug3nj3Itf8+fFXQYIzvzRleKlLkD9eChxqPXpdcm1bPjjkXRnouS57X7QY6sxdHTz45v3Nar6JTUCoxyKYjqdd5m+gKgc1MwiXZ2Lb5hjFAZVQeJQSuppIDXRPVwxRR6qh1FTpq0MEnUMs7ZMP9Bbi2qwifdMRrsa7DHr6XVnudJRjpUYkiW83skoGmTfClMBnQeEC6lgmFefkq57pYsaM3rQlLFBEhtO5+I0nn08OGOuAzHbG9GkvxG/pBA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(396003)(39860400002)(136003)(366004)(346002)(54906003)(83380400001)(6666004)(6486002)(26005)(4326008)(41300700001)(2616005)(5660300002)(66556008)(478600001)(31696002)(316002)(66946007)(186003)(966005)(8936002)(8676002)(6506007)(6512007)(2906002)(36756003)(86362001)(53546011)(66476007)(31686004)(38100700002)(15650500001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dW1zWnRSK0tHZEU1Vk1NNkhocWEyS2x5elRjQmg3N1ZKT1RHQ1BqUU1xT3dX?=
 =?utf-8?B?NldNU3kwRi9yeXBNSlM4SkJSSWZNd0YvcWYyMTlnWm5yVkw1eVlVY2ZPQmQv?=
 =?utf-8?B?b3Q5YXl5Q2l5MWNkK0s2YUp1ZnAxdzVvYlJCaXQxMm5oQUt4RUhjQ0h1ckFJ?=
 =?utf-8?B?bTQ1MGZPS1l6U280T2hsM214di9XeDRyQkpxMlFjT1M0bElxcUQ0eFdtY01H?=
 =?utf-8?B?Q3BRNDBXK0tzb0pnZG5BSnJMU0tzZnlyM0pZekVQZTZacHlYaHVBZTB3cE5r?=
 =?utf-8?B?SU9GRFpObld1bVRkTCtFV2hiYnlGays1UUtlYlcxcTIySTRwYUZPTHY1M3hG?=
 =?utf-8?B?MWd4Z3B4RkNJdjU3dWlOU3BjdGRhSHZKUkpRTlRMb2YxNXdyRGVIWW5veExv?=
 =?utf-8?B?MWFVT2toeUhpbWkrYnFZTkwvY3hRcjBqa1g3Ym1Ea2l6NENMVHhNS2E5SjNU?=
 =?utf-8?B?UTE2bE1uQmVUZ3pDb01pV2RzSkNzbUU2bEJBY2pPN1BKMDY0b1FyTWNwUi8x?=
 =?utf-8?B?ZkdacHlIdnMvdFNCNXptSDZadXNGVit2NVhOWCt4OC9CQms4M3ozMTZVYzM4?=
 =?utf-8?B?NWkrdE1HSDNkMGFkN2tkci8zZnFET0tOM2FvanVaMVZPTWJVYVRMVjRCZE1r?=
 =?utf-8?B?UG8vZkpBWVB6SHF4VjJLTTBsNkY0NDcxanBRWkRYSzVaV3NkbHNBYk9VeGFS?=
 =?utf-8?B?S0ovejZRMVRGVUJxNlhwYTYzQlBkK3g5NHNTdEJBSnhoR1gwcWY4alZJcVRs?=
 =?utf-8?B?OUl0WDVqZjgrYjZCcVJGQTVpa002THNlbHpKMHY2TUd2R2NYSHFtTk5UY1Ni?=
 =?utf-8?B?bnIzbTJaVTkvTlQ0NFR3ODdrclpwL2w5cGdqKy93MWxGRVJMYm9UYXE0djc4?=
 =?utf-8?B?djY2RzNwZzJkYS81TjNJdW9PRG9DdTdjVXVINUU2aHh0eDFUQjYvMTZhN25P?=
 =?utf-8?B?RkVOMkovQzNHTHpSYXBJczlWSDVzYTcydk5ndUR2NjV2alYrL2JJc0J3VzZ3?=
 =?utf-8?B?a1ZlSmFwR2hZemtITDNUcExRQnhFRVRlZUx1a0RMdW90MXZrcUZPbWphWi80?=
 =?utf-8?B?bjBiWk9XSmFhcElJQmlvaEdWbXJYakRCdjR2V0JIS2sxQ3VONTNEaUpGcWpG?=
 =?utf-8?B?Z3dsMlZrRnJnRDhkQnZQMnZtSEFuQmpGOWVvV3l6TFZyTzAwcnk5R2M5eXBq?=
 =?utf-8?B?NkY2SXJlWUhubGpWY2JYSHA0ei9hc25uQXRvRWlzNFdIU0pUNXNvQW5mWHJm?=
 =?utf-8?B?amxaZ0pxSGo5OUh2d01HT2xFREU5V3B1RitNZ05nTGlpbWl2bWpVZWVSVEVR?=
 =?utf-8?B?NzZKc2crMExMbW4yRDJ5NlNlYUZkZDBuZjU0bGtBVnluMldpQ1FJbUxIaGhy?=
 =?utf-8?B?Z3JPNkxTckdTbG5KTGlsT1lCQ3IrL3JkaVhHV3VPQnZjTVEvS21nMi9lZlBq?=
 =?utf-8?B?U3I0ZHBZY2Q0TW5GQkZob3VtdlVZSnVQdDQ1WTluaGh4S2ZBVmlYM2NGbWhz?=
 =?utf-8?B?TlR0dk1OTzZVREhzSVJIdngvb0E2MFJqTFBWRnAzbk9JVGxVaFpLWWJCYmIy?=
 =?utf-8?B?RjFsWmtlVDE4dDBLMXljTG13YzJ5NlRZcytHaDVmM0NpZWlNV0FvZjBybVBN?=
 =?utf-8?B?b2dkV0lJOFVycWhiTDIxYlIzVWZmVW1nRVRxakhaaUQyQWFwcG9VMzdlL2pk?=
 =?utf-8?B?WXp2djVNOEtJMytyTnpibHJQbEl2aC93ek5kZFk3dWNVaXdMZXUzTDhLSGNa?=
 =?utf-8?B?K0pHNHVZNUxPUXVSa2FaMVZQTjBPZ1crSGRIWGZ2dEs4T3B5RmVaZkNJL2li?=
 =?utf-8?B?U0Jjak1LTytWTXE3emhiY1g2WElBN1lHRmRlV0h4TEFiN0RldW8vWkd6SFpK?=
 =?utf-8?B?YW9Xd1VlZ2FHWDBOVjc4a0ZMb2Rac0E0b2JpSm9OK3EyQ2IyWWJhTG4vRzVw?=
 =?utf-8?B?bHFKUC9vUFF4WkpMcGV0LzNtUGU3R2dUa1o1TUw2UXZJY3VjeVQrNUtvVWZk?=
 =?utf-8?B?dDk0eEllZXhpeExDYUZCUHhKVUxkTUNidTdmb2RIM0pYSTFzOTBILzQ1NDdV?=
 =?utf-8?B?U095WThlTTFRNllUWmh4dkdHTEpsSXdLb01zTGppUkJONzZ4VVZ4cUVPQ1Ra?=
 =?utf-8?Q?UoPDTx2GnNcOq06CvtQxOIUEx?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62ef7768-bb13-4578-3630-08da641dd0ac
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6101.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2022 15:47:24.5841
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NoFxCTqdMceweFm6yEa5l9t3HU6d39PhpefIAdLF0aqUyDuYk4tfMoabkx9/izDe1luAgEDnx0KLzitYiiKB6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2792
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/12/2022 10:42, Solomon Chiu wrote:
> From: Fangzhi Zuo <Jerry.Zuo@amd.com>
> 
> [why]
> First MST sideband message returns AUX_RET_ERROR_HPD_DISCON
> on certain intel platform. Aux transaction considered failure
> if HPD unexpected pulled low. The actual aux transaction success
> in such case, hence do not return error.
> 
> [how]
> Not returning error when AUX_RET_ERROR_HPD_DISCON detected
> on the first sideband message.
> 
> Cc: stable@vger.kernel.org # 4.18+
> Signed-off-by: Fangzhi Zuo <Jerry.Zuo@amd.com>
> Acked-by: Solomon Chiu <solomon.chiu@amd.com>
> Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
This particular patch was sent separately yesterday:
https://patchwork.freedesktop.org/patch/493547/

It needs to be be re-spun though as the platform list for the quirk was 
jumbled.

> ---
>   .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 27 +++++++++++++++++++
>   .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h |  8 ++++++
>   .../display/amdgpu_dm/amdgpu_dm_mst_types.c   | 17 ++++++++++++
>   3 files changed, 52 insertions(+)
> 
> diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> index 476fe60f4b7d..e203d75834de 100644
> --- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> +++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> @@ -72,6 +72,7 @@
>   #include <linux/pci.h>
>   #include <linux/firmware.h>
>   #include <linux/component.h>
> +#include <linux/dmi.h>
>   
>   #include <drm/drm_atomic.h>
>   #include <drm/drm_atomic_uapi.h>
> @@ -1400,6 +1401,29 @@ static bool dm_should_disable_stutter(struct pci_dev *pdev)
>   	return false;
>   }
>   
> +static const struct dmi_system_id hpd_disconnect_quirk_table[] = {
> +	{
> +		.matches = {
> +			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
> +			DMI_MATCH(DMI_PRODUCT_NAME, "Precision 3660"),
> +		},
> +	},
> +	{}
> +};
> +
> +void retrieve_dmi_info(struct amdgpu_display_manager *dm)
> +{
> +	const struct dmi_system_id *dmi_id;
> +
> +	dm->aux_hpd_discon_quirk = false;
> +
> +	dmi_id = dmi_first_match(hpd_disconnect_quirk_table);
> +	if (dmi_id) {
> +		dm->aux_hpd_discon_quirk = true;
> +		DRM_INFO("aux_hpd_discon_quirk attached\n");
> +	}
> +}
> +
>   static int amdgpu_dm_init(struct amdgpu_device *adev)
>   {
>   	struct dc_init_data init_data;
> @@ -1531,6 +1555,9 @@ static int amdgpu_dm_init(struct amdgpu_device *adev)
>   	init_data.nbio_reg_offsets = adev->reg_offset[NBIO_HWIP][0];
>   
>   	INIT_LIST_HEAD(&adev->dm.da_list);
> +
> +	retrieve_dmi_info(&adev->dm);
> +
>   	/* Display Core create. */
>   	adev->dm.dc = dc_create(&init_data);
>   
> diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
> index e04e6b3f609f..33d66d4897dc 100644
> --- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
> +++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
> @@ -547,6 +547,14 @@ struct amdgpu_display_manager {
>   	 * last successfully applied backlight values.
>   	 */
>   	u32 actual_brightness[AMDGPU_DM_MAX_NUM_EDP];
> +
> +	/**
> +	 * @aux_hpd_discon_quirk:
> +	 *
> +	 * quirk for hpd discon while aux is on-going.
> +	 * occurred on certain intel platform
> +	 */
> +	bool aux_hpd_discon_quirk;
>   };
>   
>   enum dsc_clock_force_state {
> diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
> index 8237029cedf5..168d5676b657 100644
> --- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
> +++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_mst_types.c
> @@ -56,6 +56,8 @@ static ssize_t dm_dp_aux_transfer(struct drm_dp_aux *aux,
>   	ssize_t result = 0;
>   	struct aux_payload payload;
>   	enum aux_return_code_type operation_result;
> +	struct amdgpu_device *adev;
> +	struct ddc_service *ddc;
>   
>   	if (WARN_ON(msg->size > 16))
>   		return -E2BIG;
> @@ -74,6 +76,21 @@ static ssize_t dm_dp_aux_transfer(struct drm_dp_aux *aux,
>   	result = dc_link_aux_transfer_raw(TO_DM_AUX(aux)->ddc_service, &payload,
>   				      &operation_result);
>   
> +	/*
> +	 * w/a on certain intel platform where hpd is unexpected to pull low during
> +	 * 1st sideband message transaction by return AUX_RET_ERROR_HPD_DISCON
> +	 * aux transaction is succuess in such case, therefore bypass the error
> +	 */
> +	ddc = TO_DM_AUX(aux)->ddc_service;
> +	adev = ddc->ctx->driver_context;
> +	if (adev->dm.aux_hpd_discon_quirk) {
> +		if (msg->address == DP_SIDEBAND_MSG_DOWN_REQ_BASE &&
> +			operation_result == AUX_RET_ERROR_HPD_DISCON) {
> +			result = 0;
> +			operation_result = AUX_RET_SUCCESS;
> +		}
> +	}
> +
>   	if (payload.write && result >= 0)
>   		result = msg->size;
>   

