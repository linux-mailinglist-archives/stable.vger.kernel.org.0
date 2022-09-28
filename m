Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81C1C5EE80E
	for <lists+stable@lfdr.de>; Wed, 28 Sep 2022 23:12:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233049AbiI1VLx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Sep 2022 17:11:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234061AbiI1VLX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Sep 2022 17:11:23 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on20618.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e83::618])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83ABE6BD62;
        Wed, 28 Sep 2022 14:06:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=StKBpL+2Iw71PkfVR4cY6kAe+bXZ3KhhtHU0Rcaitt1YpFSMZJr27zRH+4TKIMYHyK7j/y6JbJuniPtTI2W9lSWY8mS3jfEyXoCwgP7gKaDwvXmaWoQxo1Szoh+CWutQ797jWmJ3l3Pp9Fsqa09LMkoyhMXUVI65lqiiD97sqnEgZ5gH17sYd8m2d26QU5hdVcpjMPSUUCpKwAIZW3/w2s6D5y6x2oidOG9EYJXluTVvFW726pdPuueSAiW6vcIaxtj64sMfGOCIEdiD+1TCrPXj9cMiVFcPhi2vE6CeBoH30sv8+IksykfS2mLOyl+bBKnX1lGlHsTbJvkclHQ4ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xe4/BsHV6nDZmHw+3WzpCx1laucZ0hg+40LwyaDY3K8=;
 b=m6bvJuZToxPWDNCLnMVPNiHLrIKpD8gQvsKiEuwyUoadvQo1FGFybXm9+SprNiRnAqUIIF4ydLdzqTejvrfCLQXsFhdtRKWv/TwoUYPXuvmZpzFZr6WReCwBCltP2eJkaHbDnkdzJzTGfJpLoF+n1+fxgAAH4ZnxiR8Pi7PRrikg2VU9EJJuyFFE79/8biwFCfIu2pveQIV62uc1QVGz2khUl8avvTKxD6AKeJ+5MAvmvujvTm94ThSgxfxiIfBaJVVdkDGK+gPasZFmPGuqDMnNnpSiYjyDx4HJKZHBXRpA29yl24lZpD7zXxwcrX5mcFw0wLYov+qxvyEf2pmbqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xe4/BsHV6nDZmHw+3WzpCx1laucZ0hg+40LwyaDY3K8=;
 b=HLDt2XkVeWTAau+QdxJN58X/t6aE8wel+ajSr/Gd5oRrR2D9q98dlqKVRdKlMHcLjvKYpK5u1qT6qxmgw7eEMNedkQJYwhIEo7jEK3WIcJVjCeLzGBhxuutCLndp6Rr2upuKgBVTsGXniF8bLA7D7MH1IVUQpEQVbIedNsVpevc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by BN9PR12MB5321.namprd12.prod.outlook.com (2603:10b6:408:102::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.18; Wed, 28 Sep
 2022 21:05:02 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::c175:4c:c0d:1396]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::c175:4c:c0d:1396%4]) with mapi id 15.20.5676.017; Wed, 28 Sep 2022
 21:05:02 +0000
Message-ID: <df4f1ee5-2123-8b39-fab5-88579c40cb0e@amd.com>
Date:   Wed, 28 Sep 2022 16:05:00 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] crypto: ccp: Add support for TEE for PCI ID 0x14CA
Content-Language: en-US
To:     Mario Limonciello <mario.limonciello@amd.com>,
        John Allen <john.allen@amd.com>
Cc:     stable@vger.kernel.org,
        Rijo-john Thomas <Rijo-john.Thomas@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220928184506.13981-1-mario.limonciello@amd.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20220928184506.13981-1-mario.limonciello@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR12CA0019.namprd12.prod.outlook.com
 (2603:10b6:610:57::29) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|BN9PR12MB5321:EE_
X-MS-Office365-Filtering-Correlation-Id: 672cd81c-367d-4a9f-5588-08daa1951c09
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H26lQY4BkamXzuSUDFyH+HEXwuuvs6HCzvPWc4fdACPCBn6d9QKuuHiWI2GqtBCsY+ookJArvXk/+U9bAY13y4WTp4npX3RLjkSYf6ALy8HRtuvfHspzyoKFc7WIE28niUgPMWxWwJPlDhNnX9OuaOxZWz58T8Wx/Wj9vieWsyGbj9ewgCGBqs/KgViGg4TsrAzTUczVYjWVRzcCtBlZEZRaESjO63Nk8kunf5482irk3hwT3AuYLK5IWQu3BhBWOSWOFj0+1xbhKaG/kSKrbWYztrNvIj93jVBAPYaYXEH7S4lnbrpbxjnB9k+NeELKRFok9vhmuE0kwBaVqosXsEDeLiEIt2a2ZtX2ok9ZEDPLCNPyJB/Zbt6PnpGY7+wb18XQeBEYSOIpxPf9L3Zm4xQWTwILvzy72Efet4eVquf0rI86eNaqkAXmVSWafFUSWQ17xEsBl/J3l9LfG9c/HXuzWan0ohtYMo7UinidtLho85n9nGW83V+HOVkx/N/t/NWzeRBK3YL9BvTzlwBQcPNdXMlT86k/TIUo+OJjM45ntp5CYXJtZcvAIwNFoLrET4R01Z3FAiNQ3Dx9vUZ9qjHxhNgnV77DU5192uCHrJCczKRFqmx+mBQipZfI2jcxuxlNPwuXO754F5VfQWGCpYoKUHrSp45Zbg8lGYTTj8IDfj6vgWU2brCUSN+kRH2ymv6CNCNJxZj4aGnaZxxomDW848NlSafJW5WfXatUSu+XdIxZG7Qq+yMgg65gw6LIbA4JPL7pif/+z3PEAc7N8mHvBOBCHzSaZjMGVZycEJk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(396003)(346002)(376002)(39860400002)(136003)(451199015)(83380400001)(31686004)(4326008)(66946007)(66556008)(66476007)(8676002)(316002)(26005)(54906003)(38100700002)(6512007)(31696002)(110136005)(186003)(86362001)(41300700001)(8936002)(53546011)(5660300002)(2906002)(36756003)(6486002)(6636002)(6506007)(478600001)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TUozOUc0QkxPNDZvcTQvV2pNTkJNTzAxV3ZwNFRWWjZKSWVIWENDY3lrWDJJ?=
 =?utf-8?B?T0ppRjRRbDlvOW9VVVIvcUtNTHR3aitKc1o1YWs0a2x3S0J2V3cwQ3JhVkRj?=
 =?utf-8?B?ZXprempvS1JYVG1SSU1lNnRaNS96QUZZT2pzclVvbURYbE1wR3NEYXNTMDZy?=
 =?utf-8?B?eG5xUURTMkhJOGNMcTQ0ZkdXNjFWalJiaEVFUUtDQWg3ZVZPL21OT3B4YUhI?=
 =?utf-8?B?Y25IYS8yM3RjdE9OWnpxMUtHK01WS1JxQWV2ZmNvU0RtVDlvNVRtVklxNHd0?=
 =?utf-8?B?VzBJZXBiakJXUWE3OG1qS0NldkVkbFpPbUx3NUl4Wm9RcXhQYjZnZ1B0RnRN?=
 =?utf-8?B?M2djRlZwdWtvemhUUlFMMUw3SnhTMXVzMGE1OTNGaDNSTm5lVUJ1N3BmMHNa?=
 =?utf-8?B?c3JhWXFQdmhPRU9nYTV6L1pPakgvc0VwcWFuekdOQXNNYzQ4bTBKUWJ2M0ox?=
 =?utf-8?B?dm9WVWQ3WXNjdmlZMVhDSjJzeENhdEk3M2R1aFA4NUFVV2VGck1TQ01ST0hK?=
 =?utf-8?B?bFI4blU2S01rNWd4OFJsNEd0MWE0RjltS0o2NWw2RXhNQ3BaczJ0ajlGN3gz?=
 =?utf-8?B?UWNLUWpMc0crNDdBWDBsd0RNRkFqcEZMTEQwa0tnWHJKaEJNYU9Wc0RzQU80?=
 =?utf-8?B?QTZQd3BxZW5rR05yTHI1aUxqUUJHY1pJSTV4eVFDQlE1MkRWZHVqc1ppOWVn?=
 =?utf-8?B?MHNrekNQMTEzRGxLRHRIeDFpeFJaVXQ5RVFRV2tsaS9LMlNCdnZtc0M0cGZM?=
 =?utf-8?B?MzlGR05UT1A3S2FHRzY2ekh3aHBBblpHcUY0M2N5R3hvcEE0YUZrT0QvMFc0?=
 =?utf-8?B?c1FZQm1EaWJmRWo2L0JtVWE1QVVQUUs2cmhtbXg5c3M4UXNoOGh1eHZRWWdU?=
 =?utf-8?B?K21XN2JGQ0NiRXd6ZUxPaU9Jdi9NR01BeThmOW5IZkJyOWJQZjhpb1JoaU5S?=
 =?utf-8?B?aGprMlYyY3o5a3VhaEtyajR6bGllMFQ5OGZuR1E2N2hsMnhtTmZ0VUx2ZkdG?=
 =?utf-8?B?V2VscHNScUlwOHl0ZjVueE5pT1Q4SnJEUFJCcGxLK2NWdjBkR2ZCdWVkSlpD?=
 =?utf-8?B?NzNzbVF2b0I4VzZSNFZrUEVkK09OSFJUSXBPNStmZmp0L1MzdEVHMU5wWDl3?=
 =?utf-8?B?MW4yM3pidEg0ZHJFT3NwWVVFTEM3VUFoSmhEVEpFcXBUNXJhMTlZSVdRZG01?=
 =?utf-8?B?bU13cjExVVZ0M2hnak5rNGhwZXJWM2NFT0EyMUNicjdLaTVGNUdGaEJQSGJS?=
 =?utf-8?B?WVcxTlpHL1JSVG5xSVhPY1FvcTNUb1dLUnZlc2U5emY1RzRvVDY3cElzbm43?=
 =?utf-8?B?OHlCVThlejEySGh2UVEzNktDS0J2ZkVVREdhM1lxM1RHbU5vempWU2c4WWZn?=
 =?utf-8?B?Vmk2cUVSbEpMUldMNjZrOTdiNUFpSHVURmwzMlFJYytSeFdzRHhUUzRzT1Uv?=
 =?utf-8?B?SG9RakpIcFZRenl5YndXM01iUFVFQ2JWTlc5c25nWFNTNlBtQWh2SzU1UjBu?=
 =?utf-8?B?c2d6Y2VVNjZ6bWZlQ0dkQnJ1c2hSTFpkU21EVFhCVUhhSVRhL0JHQ0dkaVQz?=
 =?utf-8?B?V2lZUnlQaEhGbzZVWlpZeEIxbHhsaFI4WHNTa3g1MzM2emJyZWRTRnk1WXBI?=
 =?utf-8?B?dkR1c0JsMHRrWUs5NDFXZGpZeTFOQlMrVkdqbmZGdlo3Q0JLbUFOTmNIZ2lt?=
 =?utf-8?B?YTBzS2dyU2p4ZXI5c09OVW1SSUtxalpGZXVGTXF0TVFZbjdEZmY0Yy9ZNmhM?=
 =?utf-8?B?amtzSW5tU210VmtxOEo2MWhZV1JHUlFhbHFKcTJ6cXFiN2tCNUpqTE95UzVK?=
 =?utf-8?B?eGJKdlRUMUVGTCtGQ0lFU25iVXpibjAwN3ZRRVpRRXAxNGhGYVVZVlRDdTh4?=
 =?utf-8?B?RFJac1JUTDF5bjc2OG9uVVB3SEFFNmVzWWpuWlY2YlBWMmRmREprY00zTXBC?=
 =?utf-8?B?NWNPalFKUEdGcExJZkhCaW9WbXJIQTArNVdBcTdjN2dQeXhGV0ZQUTBETG1R?=
 =?utf-8?B?UWRvcW5HNStmbUhFeGswKzliQlRPNVA4ZEVYZmFwcFlLaGxPWXMwQU5aUlBX?=
 =?utf-8?B?YzY0eU1KMHBWdjQzdXovV2tyTW10S0l4c1B5Rld5YWY0enBBK01nUlcwdURL?=
 =?utf-8?Q?kN9nYY2m1Psvuv1acK1O9puYR?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 672cd81c-367d-4a9f-5588-08daa1951c09
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2022 21:05:02.0012
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xHa5OTJKv4/Omm7ygbh8y75cXxTDtaA+4ccAUehtkMg+rreCHpWZ2Gla4uyxTzt9KU9tOjIbyLxqK/sdFbRxfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5321
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/28/22 13:45, Mario Limonciello wrote:
> SoCs containing 0x14CA are present both in datacenter parts that
> support SEV as well as client parts that support TEE.
> 
> Cc: stable@vger.kernel.org # 5.15+
> Tested-by: Rijo-john Thomas <Rijo-john.Thomas@amd.com>
> Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>

Acked-by: Tom Lendacky <thomas.lendacky@amd.com>

> ---
>   drivers/crypto/ccp/sp-pci.c | 11 ++++++++++-
>   1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/ccp/sp-pci.c b/drivers/crypto/ccp/sp-pci.c
> index 792d6da7f0c0..084d052fddcc 100644
> --- a/drivers/crypto/ccp/sp-pci.c
> +++ b/drivers/crypto/ccp/sp-pci.c
> @@ -381,6 +381,15 @@ static const struct psp_vdata pspv3 = {
>   	.inten_reg		= 0x10690,
>   	.intsts_reg		= 0x10694,
>   };
> +
> +static const struct psp_vdata pspv4 = {
> +	.sev			= &sevv2,
> +	.tee			= &teev1,
> +	.feature_reg		= 0x109fc,
> +	.inten_reg		= 0x10690,
> +	.intsts_reg		= 0x10694,
> +};
> +
>   #endif
>   
>   static const struct sp_dev_vdata dev_vdata[] = {
> @@ -426,7 +435,7 @@ static const struct sp_dev_vdata dev_vdata[] = {
>   	{	/* 5 */
>   		.bar = 2,
>   #ifdef CONFIG_CRYPTO_DEV_SP_PSP
> -		.psp_vdata = &pspv2,
> +		.psp_vdata = &pspv4,
>   #endif
>   	},
>   	{	/* 6 */
