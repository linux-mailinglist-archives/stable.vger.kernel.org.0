Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D1F3604A2F
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 16:59:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231594AbiJSO6y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 10:58:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229783AbiJSO6j (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 10:58:39 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2084.outbound.protection.outlook.com [40.107.223.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7593AD4D
        for <stable@vger.kernel.org>; Wed, 19 Oct 2022 07:53:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W1IxT6yJH25UTRLJOIKIY6yCAmGXwf124S4sR4Ba2bFEzwLc3eKEHFg7tgWEc58NjxtVQXJuqxJfp6ap4e+ybpEbDEAyceDcvg0a9zAwXywCMtUPFV2NyMa+zUQ1Q7Wcx2PUjANGbX7G4IGPhlbjyvCf/zb+AnOEDCvgOaRLclQKLsedOMf4vomgndMHiAJZ2R9Sy6etLCk7jR0mxYqCyI9JlQ8QXZ2cMeMvy+NaI5XII8cpvmLzoZ2LamhDKdB1z98TGd82p/ecFxqqlf8toM4u5NfWQYnRndB8arKW+CvIfsWKxOHG3rYCwI4MRLx8lLAGqdsJD9a7PgUHASuLxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8cL7v7Etx2ACeMMdNx/aFn0qaaA/Z8Vvl/ZpycnHAKc=;
 b=A9kPOxMWwO4vGk3PGzbJCS5MAjhF5LTRVbWJT7tdSfuJSswhwMsuntJlrUeTnxz4XkAGq6aSKNoixt6E0c6vp1H1OzjfVc0nB5UgPhwmZjt4+nDBxJQYHLIB2X6PYknWlOwW/WdLz9839+zEfHxAfCY5ATAymzpDVXGJgD9oi8MMAGcowaP8vGS2MRHX56o0AddtAlCJSnHn5+WYghibch3UBN8hGi/H1vaomi5pvwSRuO+BO4bMJYhS25hwy/B7h2v/2Pzw1o2F8smnPMEB/GyJi5EQecVHywbuiiccmjOJJhyeGqoYajUEZQVnIRD7Gq6ZP70q6FMxZx+YYukA1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8cL7v7Etx2ACeMMdNx/aFn0qaaA/Z8Vvl/ZpycnHAKc=;
 b=mRKB5VswRSKdB7YlWCJWbPRkMHYGa2BRQHhqdJQccBweqWrI20lwdOXR69Srz9/GphDk6q18anZQF9DnU6SKTzQQYEXEzE/1oxOF/ONR4IqqxdWEm/IaZPtjzrdLx4LIN0kXzGQ+9ZnwejqASTZy/Kwu0FufoPEqq4Xlb01n7GA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM6PR12MB3370.namprd12.prod.outlook.com (2603:10b6:5:38::25) by
 CY8PR12MB7684.namprd12.prod.outlook.com (2603:10b6:930:87::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5723.26; Wed, 19 Oct 2022 14:53:03 +0000
Received: from DM6PR12MB3370.namprd12.prod.outlook.com
 ([fe80::d309:77d2:93d8:2425]) by DM6PR12MB3370.namprd12.prod.outlook.com
 ([fe80::d309:77d2:93d8:2425%7]) with mapi id 15.20.5723.033; Wed, 19 Oct 2022
 14:53:03 +0000
Message-ID: <a8a177b5-0a79-f8e7-30af-422591109407@amd.com>
Date:   Wed, 19 Oct 2022 10:52:59 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: [PATCH] drm/amdgpu/discovery: fix possible memory leak
Content-Language: en-CA
To:     Yang Yingliang <yangyingliang@huawei.com>,
        amd-gfx@lists.freedesktop.org
Cc:     alexander.deucher@amd.com, stable@vger.kernel.org
References: <20221019070628.3242386-1-yangyingliang@huawei.com>
From:   Luben Tuikov <luben.tuikov@amd.com>
In-Reply-To: <20221019070628.3242386-1-yangyingliang@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YT3PR01CA0019.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:86::33) To DM6PR12MB3370.namprd12.prod.outlook.com
 (2603:10b6:5:38::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3370:EE_|CY8PR12MB7684:EE_
X-MS-Office365-Filtering-Correlation-Id: 146a6a92-f720-4a76-aefd-08dab1e19f38
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LtSWYIGU38XGR6rfhifTLgh3w+2sttILvrR7oHccXU6wASyAzSvOsvRgiq5D+BJzkTFHEkwRzgXDqT8wQZVP/yR8LijLrfjwUDDIcWzfDl1Brihjxkbwv2H8xEnj2BSklpqnNcalO5Ir0umlLdpeo8XsSlfISmFMOrjpoiK9e6JF57WLvlzotVp15+8UEvKMwTUpfA+5NTT8CnRmmHOr28VR8p83GBQwO1TtPmzlIbnDmvcuNmsb9TZGYNk0dNJDIldX3nrf0JDDFIgf7AtKM+lwgOxezhuFyHlGpkaZrSnUIUsTccA66Sa8I7MrPjPieMvIqln2dWyz6/OTRTL+SHJRJ/Y3ixFoWD7gqSzAiFy4xT2BGXfr+n3m5Q4YKOnftmMZD1p5ATouiYOUKPVwk2y73rU5irAUqbuyuK+aX/yL14a5L+Q6cIjlzEE78QCsRd2pz9OQFWogq6S7AcYk2Jpwm5Ppr5MI9vLZJIIrwBgtXMBqJo9MFkMjj5gMTAK4SWrGY9DytymaezN+HfUam0kCp3QrqkL/a5sU1ba11yXn+sjOQ4+6a1inxZ71zp1o5WlHxeRwqO6UKjqIui+qQL0e9O1vXk0DxUlv4aU8HeIpUzpb6EKWKJCM+XvP5O4uvjh2FVeP8oGazygCOHqH8FlxW0YNSks9sWo0vWwaS8a8D+rq0+8WUKHeqb9LQmzytmCQMSSM5nVm0aZGj4gm++xftGnJv8igPWI7qn0SzYETuoc/bPVENh0uAokTKGtAVMV43is/0uKW3x64xHouHiNei2IlRhxHxnojM5kteJ8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3370.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(396003)(136003)(346002)(39860400002)(376002)(451199015)(83380400001)(36756003)(31696002)(86362001)(38100700002)(6666004)(66556008)(66946007)(316002)(31686004)(5660300002)(44832011)(186003)(66476007)(4001150100001)(6486002)(2906002)(6506007)(2616005)(53546011)(4326008)(8936002)(6512007)(26005)(41300700001)(478600001)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MVhwcHhPMmozOS9IM3BZTklKZ1p3NXlTZHpSK3J2QmpKZE1UUWp5VDAzd2c0?=
 =?utf-8?B?NXQxSUFITi80aHB4dThRSXFxbmF1UTZKeW5Dd3FJK1pGVEpWVjFPdVllYW9U?=
 =?utf-8?B?MnhyZmtTbmJRVFR5cTlCYWhOdDRGZ2NCbTJSUjdSQ2pRSFF2WHZMYlVqbGp0?=
 =?utf-8?B?SDNJNHlIbG5wNlFNbjZaZmhMTzdoeVFld2FKVUxhY1ZaT3FVWE80Uktua2xa?=
 =?utf-8?B?NEYxc3lnVUZJWHRFVTdiU1dLaDF0MVhiSkhzRkhkeHdkS0dKRHFFc0prR1dC?=
 =?utf-8?B?MW5FVnhVWmVkVlhxTTJhV1NIamRlRmkzMGRkQVoyOWE1WURMMHd0UzIxVzU0?=
 =?utf-8?B?eHIvdEsyQUt4R1o4ZzBJaXp2a0dtcWZKWXVoczM4UHkyNG9wZkptMDRVWDQ1?=
 =?utf-8?B?QmlubDBqdGNxVWU3S0lzWHVmcVVhT2RjdDk0NjkrbjlZMnNjTlNDNlppNFBx?=
 =?utf-8?B?Slgrd1hlTUVXQklzd2ljK3hVWnl2NG1MOVRveU9kcTg0bWlKbVlLdnlpV0xL?=
 =?utf-8?B?MmdlU3Fob1hCQm1xb2lNUi9xT2NQek1hTmlzd1BuUkZWT1RLazFXcEYyNlpB?=
 =?utf-8?B?VzAwVUNSZUdjMkdzektNc0o4R3hpZHZIa0dNcEd5U1lYVVd0NjdTZElGL1FV?=
 =?utf-8?B?WFYxRldPeU1YR0dVVHArMjhNYVQ5aytVelU2WURlcW5sanp2bzVldlVZQUQv?=
 =?utf-8?B?NE1PaUVCZkwvb0xjTEpZZkVlS01LZldpVEtRSlZ4K29YWVd0ZnpRYVNVN0NZ?=
 =?utf-8?B?QW5WeldMRzhmZnpVTjNJN0dhbVlLK25BUlVnYURwOFZnZzNVcnduOXlrS3Vv?=
 =?utf-8?B?N1JWek51SFNFaWlTa0xQVzBLTWZLL2wyTHlKMlhXbkhQL2p4UHVrYWh4V2hm?=
 =?utf-8?B?emo2a2x5Sk8yK1B2MWJjdFVGWlhheWhnTTNjdkpLUDNjMWJXU0U2dTdPSmZF?=
 =?utf-8?B?R0JMOHl1UENDbVIzNnc5SEZTMWhzOG5vN2F5NkY4Qlc5MlMxSHM2a2tBYXVQ?=
 =?utf-8?B?WVVoendlOUR2aFZrYWNDL0JaUGdaRGdMSGV4bE40STJmL09NSXY4REJjY2lz?=
 =?utf-8?B?Wm1LRXkrYnl1VFREcVpQWlJaRCt1bG5EZzdiT0Z2RkhMK1VES1RTankrcTNN?=
 =?utf-8?B?RGUvNTB2M2s0YVl6Q2p3b0kwU0U5VUg5clZtUmJRMmxMV2pwRVpJWEZBMS9k?=
 =?utf-8?B?NjRvQ2NCRDV6NlNGWUUyL0ZIQlJsd1IvTDQwL1VSbGsyUng4SFRHUG54Mm5I?=
 =?utf-8?B?d1lGZk13alN6MHhpRHNHTTM0clZ5OU8rQnU4dlg0TmRQZGtrem43UDRUWWph?=
 =?utf-8?B?K2o4b2FmTXBjbXNaLzhPdkxNb2R0VUFzNUZtdS9OS1BOaDVuQmZZL2hxNDRI?=
 =?utf-8?B?MHlRVXFCM2RGeUtPc2hlbm5ucWs2NHNDOVNXb1hHTk5XVUxHQnNLNm02YWda?=
 =?utf-8?B?czFKYzRVdEd4ZXpKM0pMakVNWkZEWW4yZzFRczMwNDMvbU5ZSmdUaitoYzRD?=
 =?utf-8?B?QUM0b24rdjhsaUdyU0NMNWQvUFpJN3dyOFFmNjI3SGlrenVVUjZUdkhrR1h6?=
 =?utf-8?B?V0dhQXVuVDdiZThHRkR4cWpGbXNueGk2bnpmNGhWWVNwOWRsSlhpU0NzcE9Q?=
 =?utf-8?B?dGU3d0pSWVROOWwveVF4WWppWEh3SHFNS2Y2dXJTVDdVNGoxQVVrSXd5cFZR?=
 =?utf-8?B?RWFMUlg5eXM2aXprcGM0S0NuUFRxWFo1bVExSERvZXZwZGJSMlFYR1ZpeXl2?=
 =?utf-8?B?bGtiNnZaYVpYZlJidlYzT1RGQUY4SENHbnJDK0VVbnpRRGdsTndtcXR0ODBj?=
 =?utf-8?B?SW85ZU9ZZmVkK2xaSWZEWVgwUTZueXh6TzQ0TXFaSTdORmpZa0pkMmFMVjJV?=
 =?utf-8?B?ZTExdG1jUWFaMlBwY1ZRUTRXYVdDVERYNC91RGdUeUd0RXd4eVZDT1Q3UUMw?=
 =?utf-8?B?VUFoVU9hcllJSTI4YWJqb2d6dVc2MnhXK0VLb2xqc2JUSEhCOVliVDIyRjNw?=
 =?utf-8?B?TTB2bUxvZUgvMmp4c3NlWnFXemd2czhoQkZQQlJqZFR3ZVlvb1RicFBKS085?=
 =?utf-8?B?TjQvak1SRE9yMWJSdXB3UGlHaVNLN0tOc1FoYzNyR1prUmcxZEp3d3FMOGd1?=
 =?utf-8?Q?8z78DGACAo1TUfQ7FIV/FXnRd?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 146a6a92-f720-4a76-aefd-08dab1e19f38
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3370.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2022 14:53:03.5895
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qfi1+uctfJJE/X/AQsD0cMzYSSMMyuVhCxQwcA43XrXkhmVyXkIDcDb0z9I8fdUN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7684
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Reviewed-by: Luben Tuikov <luben.tuikov@amd.com>

Regards,
Luben

On 2022-10-19 03:06, Yang Yingliang wrote:
> If kset_register() fails, the refcount of kobject is not 0,
> the name allocated in kobject_set_name(&kset.kobj, ...) is
> leaked. Fix this by calling kset_put(), so that it will be
> freed in callback function kobject_cleanup().
> 
> Cc: stable@vger.kernel.org
> Fixes: a6c40b178092 ("drm/amdgpu: Show IP discovery in sysfs")
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>  drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
> index 3993e6134914..638edcf70227 100644
> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
> @@ -863,7 +863,7 @@ static int amdgpu_discovery_sysfs_ips(struct amdgpu_device *adev,
>  				res = kset_register(&ip_hw_id->hw_id_kset);
>  				if (res) {
>  					DRM_ERROR("Couldn't register ip_hw_id kset");
> -					kfree(ip_hw_id);
> +					kset_put(&ip_hw_id->hw_id_kset);
>  					return res;
>  				}
>  				if (hw_id_names[ii]) {
> @@ -954,7 +954,7 @@ static int amdgpu_discovery_sysfs_recurse(struct amdgpu_device *adev)
>  		res = kset_register(&ip_die_entry->ip_kset);
>  		if (res) {
>  			DRM_ERROR("Couldn't register ip_die_entry kset");
> -			kfree(ip_die_entry);
> +			kset_put(&ip_die_entry->ip_kset);
>  			return res;
>  		}
>  
> @@ -989,6 +989,7 @@ static int amdgpu_discovery_sysfs_init(struct amdgpu_device *adev)
>  	res = kset_register(&adev->ip_top->die_kset);
>  	if (res) {
>  		DRM_ERROR("Couldn't register die_kset");
> +		kset_put(&adev->ip_top->die_kset);
>  		goto Err;
>  	}
>  
