Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC458233138
	for <lists+stable@lfdr.de>; Thu, 30 Jul 2020 13:48:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726615AbgG3Lsf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jul 2020 07:48:35 -0400
Received: from mail-dm6nam10on2060.outbound.protection.outlook.com ([40.107.93.60]:2095
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726267AbgG3Lsd (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jul 2020 07:48:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G9RwPyim4F6kX4bGkNx83b6UCCaGyZVVplySEZZidj1ccuAf5CSAeXytkhlWKaMMnsEZfeYkIcvm/vNHtOnQ2gsFeiQlMdJq0kvCzO5+oz+p0mUoUsl1PEUWASYO4fMHsSdt8bqLYCOyxKYFs9Cw3iwxT6+Nkwp+gI6psd5csrIaJf3D53hqdgVFn9UnpfgIhpEdAuJKBS3iu3SVR6qH0wVNSCd364q3VrigjY1kGnsmg4Ggvzt75AS6TwLkeELeahozFHwfpcox5YuvYy7xJBOsJno5x7Z3NZ1KesuYdxup+4v7rGaMvBQ9McAUmqmUEoZ40wASc3S1z08AlK0dbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X21CoqJKU7eCqfIh2mEaK2ZuEVX6gLOX5h8R+cuhPbQ=;
 b=XtZ8ePEJ8jSMcl9j9FQbahYcPvR4yrf1+ry3xiXgCRJ1/TOWvaDapzW8gkfYoleK3diyDLKOyX9hLL9Y/yc8aHNFsiGRwEUOOHfOgA1U/f84eIL1Gnb006p9vJJqWWLAOuzzwTSq1swZ25WK2beqyhpDfUGJn9AsyB4SrUPFbiRm+AckqSUqmSoB4cn8nOKibbjdukoEVK9RPgeHsNbWaIOfyqCAMEwT5uMfoP8oBxN0JdmJkOr0Xc3dtZkb6BUMFEnfzJRJLVmd1YSor1mqzirrvqHzaMlfahZjctBHGH8gtvWf+IyZzu2aOG4VsmpNXvFW4Goi0e60tEy6CNUM+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X21CoqJKU7eCqfIh2mEaK2ZuEVX6gLOX5h8R+cuhPbQ=;
 b=s0R95My3agyw5MgbK0tYqoGhopFYv2PP402uJFg24X2v2PgWitATXZj/uDh4WQkbO6f7Wog6q9axUCi7HGzKt2esrF9UQTUBeyLCvdb+ZAhgmg5EV2Fb5ez1zP+HjDAUEtLa4+tf9Dprka2rMFh0G0NvJMC3soS49GOthHgYZkw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from MWHPR12MB1663.namprd12.prod.outlook.com (2603:10b6:301:e::9) by
 MW3PR12MB4427.namprd12.prod.outlook.com (2603:10b6:303:52::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3239.16; Thu, 30 Jul 2020 11:48:30 +0000
Received: from MWHPR12MB1663.namprd12.prod.outlook.com
 ([fe80::45:3012:7b13:778c]) by MWHPR12MB1663.namprd12.prod.outlook.com
 ([fe80::45:3012:7b13:778c%8]) with mapi id 15.20.3239.020; Thu, 30 Jul 2020
 11:48:30 +0000
Subject: Re: [PATCH] ASoC: amd: renoir: restore two more registers during
 resume
To:     Hui Wang <hui.wang@canonical.com>, alsa-devel@alsa-project.org,
        broonie@kernel.org
Cc:     stable@vger.kernel.org
References: <20200730075020.15667-1-hui.wang@canonical.com>
From:   "Mukunda,Vijendar" <vijendar.mukunda@amd.com>
Message-ID: <5d00fc3f-acbe-cfb5-38fe-cd787c509a2d@amd.com>
Date:   Thu, 30 Jul 2020 17:32:41 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20200730075020.15667-1-hui.wang@canonical.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA1PR0101CA0059.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:20::21) To MWHPR12MB1663.namprd12.prod.outlook.com
 (2603:10b6:301:e::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.129.8.176] (165.204.159.251) by MA1PR0101CA0059.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:20::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.16 via Frontend Transport; Thu, 30 Jul 2020 11:48:28 +0000
X-Originating-IP: [165.204.159.251]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e018b065-081d-41b5-3797-08d8347e7a96
X-MS-TrafficTypeDiagnostic: MW3PR12MB4427:
X-Microsoft-Antispam-PRVS: <MW3PR12MB442755398855781BA088FB2D97710@MW3PR12MB4427.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VL4+iNc2OVZFZ8e35Pca+Pc/LF+g4tYoDa+rLrJMScM9x3QMiu9CyYfGEVCw6w8W5CkkL69xUF83PEuVykiEcqg+vTUBjJFQSmykKQw9auhAXvMPY1201YmBc4vACduDhe6ZJKC+xyHKopIcm701nQGr6itE5ZuKEyGHZXaHCqDqg0ceEmnPa9toh0Cjr9HAaSaKBjBeEYQhu2MPGvDOIOeC/HHLEL26YkXH9S/vsepsiJAeps+X/eOgIWWIvqRS7vUy01/Nva12V5tTUHVhdBveOo445aBznp3JN/5j+X+gIn/Xb3ONtWWxNhyJrZM7HGumfDkgeHlR6ENGoU2zrkxliwxrsbfCEmoCbILU4lrlajLXfyRF/8h4Zp1uC1al
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR12MB1663.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(136003)(346002)(366004)(39860400002)(376002)(86362001)(83380400001)(31686004)(66946007)(66476007)(36756003)(66556008)(52116002)(8936002)(956004)(2906002)(8676002)(2616005)(478600001)(4326008)(31696002)(16526019)(186003)(5660300002)(53546011)(316002)(16576012)(26005)(6486002)(6666004)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: LdcN46FCQrvIVk5zuVWxxPSQNbDvVL2Knu0q4IK8DEFqrbkPRdqVullz40QGql4KIsb3YVtDfhSmcpsQjWGMbH34LWVyHPqlXXcCipPUAzFPvwN9mJs998oWflUaS1gNMD2zGL7LkAyoj+0/ETUzgHyoamxfIrBeOzVXPML0uWaFo4x7dqtadM304T/HqNShnEVrLgJgubpSJw9SWtpwOUy7DpnV+JpZnKmu9a/Z98ZDI1aoBCdCoPfo3Z0ThuVlrNokxgH3fHJaptlXCap0KSAeFnc9yNjof7AWMkCyE0PN4V6svOY12l5pheozwHh3wE9V95LHc3XYsLZ61rQYbohAv8r5Jfk2pzxd7nzqOGTbprGk84T0lKqTftED919B5Kv9lNCFVuQ9OwzgBtL6xrQqEVwv1/p0A3wrL5OXac+Ez7blT94R9qj5d4tURSoFLp9lXAR3oTGqHyadiqkVI5nvGdIKYPBpJjeJfw3h9IQmolAGscp8Fk+IJ3ovwCHCg7T8G4aNp03p9w/FuCetwkS7dUjMimFNEo41g7v2gGAI+JUtNYfQiOxV7n+gyViFjSF0NABZ65Ug/zquygLPyGU9xKCG8IsjsAiyZRVyS6fBHVud8ReZ3t/5XZBngMsRb96vjRjEg72RDljgjGWgbg==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e018b065-081d-41b5-3797-08d8347e7a96
X-MS-Exchange-CrossTenant-AuthSource: MWHPR12MB1663.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2020 11:48:30.2472
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NX0SV7JIE1m3XMibe2+ngCXWrazQiauTaJ6FBqwFRNtUpHzVE5P0tGfFY32qZefavQS8VL1UgfrnN5UEApxPtg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4427
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 30/07/20 1:20 pm, Hui Wang wrote:
> Recently we found an issue about the suspend and resume. If dmic is
> recording the sound, and we run suspend and resume, after the resume,
> the dmic can't work well anymore. we need to close the app and reopen
> the app, then the dmic could record the sound again.
> 
> For example, we run "arecord -D hw:CARD=acp,DEV=0 -f S32_LE -c 2
> -r 48000 test.wav", then suspend and resume, after the system resume
> back, we speak to the dmic. then stop the arecord, use aplay to play
> the test.wav, we could hear the sound recorded after resume is weird,
> it is not what we speak to the dmic.
> 
> I found two registers are set in the dai_hw_params(), if the two
> registers are set in the resume() too, this issue could be fixed.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Hui Wang <hui.wang@canonical.com>
> ---
>   sound/soc/amd/renoir/acp3x-pdm-dma.c | 5 +++++
>   1 file changed, 5 insertions(+)
> 
> diff --git a/sound/soc/amd/renoir/acp3x-pdm-dma.c b/sound/soc/amd/renoir/acp3x-pdm-dma.c
> index 623dfd3ea705..8acb0315a169 100644
> --- a/sound/soc/amd/renoir/acp3x-pdm-dma.c
> +++ b/sound/soc/amd/renoir/acp3x-pdm-dma.c
> @@ -474,6 +474,11 @@ static int acp_pdm_resume(struct device *dev)
>   		rtd = runtime->private_data;
>   		period_bytes = frames_to_bytes(runtime, runtime->period_size);
>   		buffer_len = frames_to_bytes(runtime, runtime->buffer_size);
> +		if (runtime->channels == TWO_CH) {
> +			rn_writel(0x0 , rtd->acp_base + ACP_WOV_PDM_NO_OF_CHANNELS);
> +			rn_writel(PDM_DECIMATION_FACTOR, rtd->acp_base +
> +				  ACP_WOV_PDM_DECIMATION_FACTOR);
> +		}


Could you refactor the code.
Remove this logic from resume callback
Add this register sequence in acp_pdm_dai_trigger() callback before 
invoking start_pdm _dma() callback.
Remove acp_pdm_dai_hw_params().
>   		config_acp_dma(rtd, SNDRV_PCM_STREAM_CAPTURE);
>   		init_pdm_ring_buffer(MEM_WINDOW_START, buffer_len, period_bytes,
>   				     adata->acp_base);
> 
