Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20DE7570D18
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 00:01:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231668AbiGKWBh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 18:01:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230119AbiGKWBf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 18:01:35 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3434509F1
        for <stable@vger.kernel.org>; Mon, 11 Jul 2022 15:01:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DDsIefLZI74t2z4SH2CMfTORKoMu2kG5PbL3viNpH+IYO6aWVrvxdqP5xoVWX+GYXwtsnFgidQAurx5OxRFuvbqxQy3sDDBo+gEnKl849BsTA7ogjif7TyEoIcWzOawYttrxIKRmkQLfUMydmCKUmuI5xmL5fzPz17JzCvEMn5ojXZTxOOS7NpnFh3K3Z+t6JMDkMJxvTw+bqUleEqSmGAYZuD0MTCrbxk+GgL7vGjNGQhmkwUmI4iqa5dYs68yZZDugZviG4PsiCRSWF6Ea5YRITBv+VzCbzYk97iWMc9hPpVwtSyRc4+KkYsH07OGVSD+UUsBN4G2kEI+1KRbGEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VtCvlp5cITz7RPw+mLD4HPMoGd86d6dbdIODCXl6vq4=;
 b=m3OGQyrtBPvncJwjuURY4IxtrUsbT71q6jpK9v1M2+cFr+cMSFm/33uGicvi03nr5SaPzROKwJvxP1cOHF43sh9M9EPpK9lAwQtjqK9TjJSxYan0lNrzaR+fV1Yweu9KEnqUcTuxZc4maE7e5xCLEqtiZwriMRhtTXIy6s1YewRnhWrBIkXElHJ4jslhC/plFvadLQy1ZTv91uEjhiKY1zX0r1Egvs6zZAe6CgA1PhU0CgegJG4C06HF6nm69oPaQDi9RI15LH2ShSI9uoXpU4ZulPsPl1dZuEy3bBVof5NYx69WskhATmLe4SIQM5EY5xnoA9A6MeoVSTo0Lz5mbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VtCvlp5cITz7RPw+mLD4HPMoGd86d6dbdIODCXl6vq4=;
 b=XBKo2cNyq6xT4OGigm/s+utPap1qSsJEI4u6VYX62UPYGGMKrPSRNQxaXvA0khavRzXi793WevR5np5ZxZqcR7KqdOE2pi9HN8YLdgg7cg4Ye3Zkld+vvC77qf5Ftc5LmmIIm5MxpgWbq69OjuMT3aR7HfBVi+IyrO12U/Punqg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by BN6PR1201MB2544.namprd12.prod.outlook.com (2603:10b6:404:a5::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.20; Mon, 11 Jul
 2022 22:01:30 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::1143:10a5:987a:7598]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::1143:10a5:987a:7598%6]) with mapi id 15.20.5417.026; Mon, 11 Jul 2022
 22:01:30 +0000
Message-ID: <14fdb4c7-041b-c6fd-a868-0c32de90470f@amd.com>
Date:   Mon, 11 Jul 2022 17:01:24 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] drm/amd/display: Ignore First MST Sideband Message Return
 Error
Content-Language: en-US
To:     Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        amd-gfx@lists.freedesktop.org
Cc:     Alex Deucher <alexander.deucher@amd.com>,
        Fangzhi Zuo <Jerry.Zuo@amd.com>,
        Harry Wentland <harry.wentland@amd.com>,
        Qian Fu <Qian.Fu@dell.com>, stable@vger.kernel.org
References: <20220711215246.88773-1-Rodrigo.Siqueira@amd.com>
From:   "Limonciello, Mario" <mario.limonciello@amd.com>
In-Reply-To: <20220711215246.88773-1-Rodrigo.Siqueira@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR13CA0009.namprd13.prod.outlook.com
 (2603:10b6:610:b1::14) To MN0PR12MB6101.namprd12.prod.outlook.com
 (2603:10b6:208:3cb::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fd9c81e5-3561-41bf-5011-08da6388e8da
X-MS-TrafficTypeDiagnostic: BN6PR1201MB2544:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jvM2dft1Yh68PTT2dz6uADlR7Rx6OQHi+khSNiWmqypuPf4ZqOA6gWup6e/CO0kDItBH5Pe+PtXl7LRCmOHs/EfRMbwHKwf27uPuZSF8vYj+HlGr7ejcQZPvKO/K2ZtLIA/VCxzQgCeoziGRq1kTrUGit4JmwaBhDRHi2QBq0+YWyB26ulAYL45FFDKa6qAon/c9m/ullc5adUBPepPNZXnADu3HNiqE7YXOZO5yPsV0nwfd9bN+i2sOvcdhi+5Sp/67L/mh2+ezoGSHtXe+vRqysgieZmd7JLijrMNXCkN/akg/q9e9Mq3HKnq5DkS6g/+2bLutpV3y67QDuwsTKdP1cgyPdvaQik+w1oyA1oQh/7qYA079TE3oc9ihX6J4vcueVdT2knhMokMbC/lcZvnve2PVa4zbZGnJ3j4V/56MQcjfZ3PqWj64K7w4PBzS/SfmLs/tEzL/nVFtnsBPtWlBstpqVrJhTV6yz3eyCAB1aIK3qFO2jq9A62VVwIafLPUDhg8P682CM0oYb10rPQghixZRGArqmFtOrpmC5cn1JgDQxpskAEuYpI4XKSzaopjYWZfuf3DT4NqDN7A39BX/imNwa7nXgpbsBKzXYX67VGfrxCiX60N+I41PidcbeyUGOrmTlMrLHbHEMVaCokqHD1EP40m09DCpBRWV7/IozOxr3Qrn9ouomCSFZITMn5/7Tr8aGv7DNG+aLACSbS5sN39GAguldMdDj+FhBiEDfpQIsI6IMqvUcJhvPitO67V6SS/0cQN+L9xbxMfgq/9+6uBeyYKUiE3XmvkNDLTiNhCoQHzp856EeCVJVEPGQBzyhmLjYKCva/6eS9fPka3xkhFOqZXJQtG89gcWCKY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(376002)(136003)(39860400002)(366004)(396003)(54906003)(478600001)(6486002)(38100700002)(26005)(36756003)(86362001)(31696002)(41300700001)(31686004)(6506007)(53546011)(6666004)(4326008)(8676002)(66556008)(66476007)(66946007)(316002)(2616005)(186003)(6512007)(83380400001)(5660300002)(8936002)(2906002)(15650500001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NEhPOGxVQzdjZG80Q21CemRrR1hOQXpQMGhzZ2xqOGdJemtqM0NSMDFlcGF3?=
 =?utf-8?B?QnJ0T3JvRjkrcjJTcGh5NlpvM3Z1YU9jUDZjeHpVYkh3QUNmeGRKaFIwSGhn?=
 =?utf-8?B?N1NsL2ZtR09YbS9oQlVMS29FZ3p3WGlydXdjS2RmTDc5SVRZOHVEMFVvVEVN?=
 =?utf-8?B?cjZmelJUdFJCdDh6SjNSbHhEQjErREd3em1pdjgvRjFIVVVGUURzazhKbHhr?=
 =?utf-8?B?Slgremt6ZGlvZ25yb2lQVnd4STlZUjVHdDlydG04SFNjQUFxZUVSeTl0OXdX?=
 =?utf-8?B?cUs3Uyt3ZXdoeTVmY0xPLy9JRHpIQjBReXREK0JhYWgrSWVEeDN3alFTSlJm?=
 =?utf-8?B?NUhNYXdZWHJjdDhWdlZXY0g1dDlEQTNmSDZSZGVNUVZkZ25qUmc0b3VjSjFL?=
 =?utf-8?B?Uy96azJic1daMThtTlBxZkFxcTZYSHV1SXlBVlRvWDFidHlxOGFUdk01dk5F?=
 =?utf-8?B?T2hncTRYY2xnOFhMNjBqNEE4b29MNGsrenZqRk50QnFxd2dvK3FESVhqdFdM?=
 =?utf-8?B?VEpjSmZPU1IwSHQ5NldWeFR0SXZJTjNhS0hETkFlc1EzTWp1d21CcXRsVktu?=
 =?utf-8?B?M3JjY2MwUzFCZlFOL3NFQzJHMG5jUTdwVlRmaTErUnRlVUNHdFdQKzlqaVV0?=
 =?utf-8?B?NjlOUU5hR3dXRjdkOHVhWVZ2bjJ0SSsvYnBiVnc3K0lqRGdLdVFtelBNRHVs?=
 =?utf-8?B?UFJNaW9sN3l4YTB0RmlDVUhzSVRJNU1hTkdidE11R0paeE5SV0ppZXZ2WW5H?=
 =?utf-8?B?cTRJUGdyZkp4OXFrNmFLL05YUmI1cGxHWVdxTzVxNWJlbENoM21sMTF5S3ha?=
 =?utf-8?B?MTQvclB0TFFZRmtsYWxEeGhmMzExUExzOHFRcHp2Z29pZ3hocXcwMDhQVGg4?=
 =?utf-8?B?TlVHaHVIWU9tbC92NnhlY0RkcU91ZlhMQXdwNEl2OEZqNGVzSForR2M5SDF0?=
 =?utf-8?B?eU1xMDM0TlFnM1loQllIU29CWFc2aWZ2YmhHY3J5M1Y5ckpIQTUwTDNWU3VC?=
 =?utf-8?B?S1FHaWs3ZVNHY2JKU1E3ZXE3dWN0eGF0VUZLWGJBNWdzVFo1RFhwcjFsV2VD?=
 =?utf-8?B?dElnV0NkbzJBMkM3eHhFbWJ6UU1uaU9ta3FjenJzdzZGZUpSd0ZNUUNaRFN1?=
 =?utf-8?B?TkJBV1RyclVZY1RBK2h6dkNMRGRYMEY2U2dKN3RpVEQ1QVM2eUJpNzhDb3NO?=
 =?utf-8?B?ajVUdEFXdTBYWUFmNWNMV29xWHMveTBkYnI1ejI1UkdIN3p0aXpvL2J4M1M2?=
 =?utf-8?B?dHFXRFdFd1VwSldDT2J3dEdka0dQVFMzcTdLbU1xQnJzYTVwVjZKbSsvRnEr?=
 =?utf-8?B?NXZtWXlWVklFd1JxVTIxSG9zak5ZMUgybmpDUDk1YlVHdng4Y0o1S1ZDL3dq?=
 =?utf-8?B?b01iOUsvVjFyRjJISFVCb0FXQjZ5UlZqaUYwd3lTWW1rWlEyVVVRRFFieXE3?=
 =?utf-8?B?SnhkejZ5bDUxeW12cjFXMGxSemxUY1djZEtMQzM3NlN1OG5LZTQ0Q0JTQm5S?=
 =?utf-8?B?M0RDWDlsdzZiWUxXTC85cGxIbFBXdGtuRWN3M0dYNEpDOXl5bThCd0pQdUVa?=
 =?utf-8?B?dWowNUxrWEhRejFnMnFreWl5emR0cEdlQWJYcDEzNG4zS0F4WXh6S1JiK1pF?=
 =?utf-8?B?MFlRYnFBNmtJMjdham9UUW1CV2tBQ1hFUlVSU2JsYnhWRnh3cFoySEt4Wis4?=
 =?utf-8?B?TS9XL1haL2VMWmNoVHpncUprclQxNE5VWlZESDdPOUFFK0tyeURNRHdBL1N4?=
 =?utf-8?B?aktTc0Fhd1MzT0tmdGtMWlVoVDBaalVFSGVVeXl5eU1LV0lNMng2djRaMTJh?=
 =?utf-8?B?VHk3TEpLU0tJaWNwNzRSK2J0UEJHK2FkTVExdnhxc2NxNmZtMVVUL3U5bzVr?=
 =?utf-8?B?eGhWaUpiNzRpY3ZaQU9oTEJ3Skd2emFSb2RUME15cGdUT3FhNWlwT3JheXNT?=
 =?utf-8?B?NGxjK3dYMWZvTGQyV0haVFRPdUtaMWFTL3Y3dUJoNUlRUnRnM016MXd2eHJ1?=
 =?utf-8?B?MDlrY3ZtTFN4WitQbHl5RVVaYzYzOGhmYVduM2l0d2ZSUHJGUEJKRmNJTTVq?=
 =?utf-8?B?ZFJXOG9WM2M1UVdVM3J5Q0g2b1R4UUxWUVR1RlpBYk9ZdDJtT21aVVhaRVFD?=
 =?utf-8?Q?ntUb+IMCVk/C2I0UqopHcxD/s?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd9c81e5-3561-41bf-5011-08da6388e8da
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6101.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2022 22:01:30.1847
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OfJ7hbZOvvP6y7tJjT2z0bUxyVCkGblJTIXEvPl727B28SvwPkURobc8+450fP8ciKhGdlz432dcdiFrOYYiDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1201MB2544
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/11/2022 16:52, Rodrigo Siqueira wrote:
> From: Fangzhi Zuo <Jerry.Zuo@amd.com>
> 
> [why]
> The first MST sideband message returns AUX_RET_ERROR_HPD_DISCON on
> a certain Intel platform. Aux transaction is considered a failure if HPD
> unexpectedly pulled low. The actual aux transaction success in such
> case, hence do not return an error. Several Dell Intel-based Precision
> systems had this issue, for example, Precision 3260 and 3460.
> 
> [how]
> Not returning error when AUX_RET_ERROR_HPD_DISCON detected
> on the first sideband message.
> 
> Cc: Harry Wentland <harry.wentland@amd.com>
> Cc: Mario Limonciello <mario.limonciello@amd.com>
> Cc: Qian Fu <Qian.Fu@dell.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Fangzhi Zuo <Jerry.Zuo@amd.com>
> ---
>   .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 27 +++++++++++++++++++
>   .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h |  8 ++++++
>   .../display/amdgpu_dm/amdgpu_dm_mst_types.c   | 17 ++++++++++++
>   3 files changed, 52 insertions(+)
> 
> diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
> index de1c139ae279..e0af3d003b5c 100644
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

I think two more matches are needed here for the other two products that 
are affected by this.

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
> @@ -1528,6 +1552,9 @@ static int amdgpu_dm_init(struct amdgpu_device *adev)
>   	init_data.flags.enable_mipi_converter_optimization = true;
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

