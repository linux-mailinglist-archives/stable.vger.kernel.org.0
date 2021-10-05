Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0128422788
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 15:14:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234378AbhJENQf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 09:16:35 -0400
Received: from mail-eopbgr30103.outbound.protection.outlook.com ([40.107.3.103]:33410
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234170AbhJENQe (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Oct 2021 09:16:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XqJ923DUJ/fAbqH1DQQZduMMDQY/ZeeXq7X7yq7h1HURYxmBWa+AS2/dJ2w7jMCCSRm8PgHxQVXAXBdDUCzUpY7e2SNgvqAc9rBsL7XtELHjnRvyysp8s/gyLg8YYe1oW9Np26ulj8VrVCPh3HQy84tFJIbJIwQfruAuUPSCGWioaAa/I0RIME8rzcFuThzbqKPm1g56+FB+Kvt2zHcTOmzjlh7Ajm7fcEvbbHrCccH7sdHwc82D5LySjgGpj0jIhxgDanrv7AtN27CmiFDS7cvTLQxLsLl8QyAtIIBnV7OiX676mXDSvAEUKb5Pk0tyghnwX7RieTwLv9U+epdSfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jIN7DbtYPg1iqBuRXgr77ZPJt2V+1AquByzQFCUnEwA=;
 b=hxc/fZQ3CsuP5lW+SPgARs83xtWgmy2qpPaBwR29ZDMSZ9nClsD2GJjMz+JsVYkcm2cNjibP3dzKwP8ywcgwqjcTDYRx/YwcUdGrxK59jCtc5u8+046rSEWhx8jU5UaSqkfiNFSes/95iFflK2CTExxdNVuURmeIVTOnfrvtT9i9+zZ1Yry2JYCwpXUXiXvWxUXezzhJryJaCFWrq1cY+QFR6kLYokZWsWhf0Z2fN067809xY0s0MraS6lw/3CjPHRouSdznkfg+0vXvUjv4Z1l1S9IixFOqKaZbyjPMOY8jg9GxiURmJyJTzJpIztbntW0Uy5zFcs999FqO4NBvjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=kontron.de; dmarc=pass action=none header.from=kontron.de;
 dkim=pass header.d=kontron.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mysnt.onmicrosoft.com;
 s=selector2-mysnt-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jIN7DbtYPg1iqBuRXgr77ZPJt2V+1AquByzQFCUnEwA=;
 b=U7RUGE5auUYcC33IchqGCbgESe6mud7NQvGSIuaItjjyCXIvctTyWOWM8zAzfS/Xadhh8GHr3e2+7+Z2jHri0xia/GYllhpgvolmDPqmc8Xm1i61Ob+7lopM9i2Gy1HDw9q5YkKzKsD1SEVsS2mNbcxmIll7KCDTcCWc5E0vOA0=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=kontron.de;
Received: from AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:157::14)
 by AM0PR10MB2578.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:12a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.22; Tue, 5 Oct
 2021 13:14:41 +0000
Received: from AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::216b:62be:3272:2560]) by AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::216b:62be:3272:2560%6]) with mapi id 15.20.4566.022; Tue, 5 Oct 2021
 13:14:41 +0000
Message-ID: <df454b06-3069-d369-e3c7-f2434d94f4af@kontron.de>
Date:   Tue, 5 Oct 2021 15:14:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.2
Subject: Re: [PATCH 3/8] arm64: dts: imx8mm-kontron: Set VDD_SNVS to 800 mV
Content-Language: en-US
To:     Shawn Guo <shawnguo@kernel.org>, Frieder Schrempf <frieder@fris.de>
Cc:     devicetree@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>, stable@vger.kernel.org,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>
References: <20210930155633.2745201-1-frieder@fris.de>
 <20210930155633.2745201-4-frieder@fris.de> <20211005065641.GA20743@dragon>
From:   Frieder Schrempf <frieder.schrempf@kontron.de>
In-Reply-To: <20211005065641.GA20743@dragon>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM6PR10CA0094.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:209:8c::35) To AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:157::14)
MIME-Version: 1.0
Received: from [192.168.10.40] (88.130.78.70) by AM6PR10CA0094.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:209:8c::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Tue, 5 Oct 2021 13:14:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2fb4cc5c-ae0f-4533-a384-08d988021791
X-MS-TrafficTypeDiagnostic: AM0PR10MB2578:
X-Microsoft-Antispam-PRVS: <AM0PR10MB257813A85E87352C668EDE40E9AF9@AM0PR10MB2578.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RvBY/yAHxEv+fb0X29DHMNLetFOi84g4j2mNovVGAnjbSayIoAcP0anKfTKOGLa0vUmRWhtAqMI/5/bBcBECj8qv+C6HzSIXaheHUgg32XjwTaxBIAM/wG/PJDSM5XaGjeM1jKG5qVwLhKl6B9fxL4wgFarob2U6v6DIMSB93XoCctL9oqlq6YHBAYtqDV5cQqOVR1skWX26E9eJRaU1Uv9I+/6WRbwNxxO/C9mk41b+n/QDwiNJNkUddrkPr1gpKqd36KfWX2Kqj6YQHeLDrZOLAwsRsa4yOI3cLBwWlwwJmZ9mOlSUmiNJtzt5VgnRn1NdHjIMYeIXESdwYSbrLcSXD+UaoocJcjU31IlJlzmDH6iJp1p30tAa8u9z4+X4tbrtI1TvJSmfYAjFe4QpgJn2WVSc9Om/Z5PDkrwliz6ZCG1hDnUWUiEefzlLl4nEl2GAUMDadJY1kXcG5s2KjfqHqH3mw0mHqpedVYvQ4y2a2fbBmptke1jmAJjsQ9I4pPeMraW3EewPuFBhLdB2WHDGN6iW1IAiFoU3vxUyMLv4ytnc/oD3VT6a9cEKypauKqdGlbv1K2E3SVOijHx646lgpTPTl2zPdJqLMEX16zlDqW3DcCieYfK+jiJZ7kqHGLeUI5j/Ui/CLlx2L1SK3ApMPULMux5QV73+OSYTJwzms2mYejd1yfjX4OLgLNQ+X7fXEXXw30/t5gRm9RWPEtcb4gBI0r/Bxfy3NLhNzt5bPefF97n8nMZZ5j9HcEqM+9pUZpr4oqM3c3ompNaVuoMPcJ+CYSnWykEerve2AStsBE8iAs28yI7gwsKB1CTm+89iV8stDuBx4OsEkIfP+g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(5660300002)(110136005)(16576012)(54906003)(2616005)(966005)(316002)(4326008)(2906002)(44832011)(956004)(26005)(66556008)(66946007)(83380400001)(36756003)(8936002)(508600001)(6486002)(86362001)(8676002)(7416002)(38100700002)(31686004)(66476007)(53546011)(31696002)(186003)(32563001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZG1XTE1PcmUvV3UxcEYzZE9Gbm8wMFdScFdRNS81b1dRNzF3c2M2dGlkTUxD?=
 =?utf-8?B?eTF5b0ZMVjBMSEtIakwxcXVLWitncFlkeEJIMW03eGtJbFZLMkNMUzNHeWpn?=
 =?utf-8?B?WSt2SktMM3U4WmEyOWJWYlJjazg5Y3hENDhIT09GLzl4Sllac1dRcFV3MXVp?=
 =?utf-8?B?bHM5UGRiUXBKeVVFTTBTUlUwa1hTenYwU0F6NmZ1VUpKKzRWM2wzUThRYnps?=
 =?utf-8?B?YnJYaXhtVlNRenZ4MXNVMTlqRDRaaWx1N1hONlRiWUxjT2N5R2ZTZnl4WTNB?=
 =?utf-8?B?WnZzejFQeVdEZjVoY3FPb3JuR3ZvbHZlbFl1V3BmY09GUkI4MEw1dEw4ZGlQ?=
 =?utf-8?B?M09sMmNLbUJ5WE14SEl5TnVMNi9tOEhCalZNYU9UR3pubWt0Q3ZzMldVV0NJ?=
 =?utf-8?B?S21qdWFXZ3E5dk04MExGdmszTHN4NFg2cGk2TGFpdEU2RHJkV2dKYXlsc3Vz?=
 =?utf-8?B?dUluNnNZd3F3VUJia2JTQXdSaE5KVmRUUzRBTGRGRWpSQWM3RVI3bWpUTEpm?=
 =?utf-8?B?MGxLRDl2Qzd0K0VsQXFRY1Z5QkJacDdYUWVCTlFOd1NDYVRuVnVodXpUTCtx?=
 =?utf-8?B?MUdHR3laTlNYUW16ekEvY1V5QWhwUDdSWWtFbVdvS3dDRW5tTWhVeHp4TlFa?=
 =?utf-8?B?M3FpSDE4clBFcDdDS0ZDNjFlY00yR2ZVeFFUN2ZWaWUvc0RGWjZzczZEaW13?=
 =?utf-8?B?Z1FKMVpidElhK3VDYUwrRXg4U1pYYUdPSGxyUUhQTXFzQi9qWkVmTHBvU0Rr?=
 =?utf-8?B?cW01MDBvSXNvYTcwK3N1UWVsV3lEVExtNDJLT1orS3MvMzNIa3orb21zdG1Z?=
 =?utf-8?B?bldnSVNUSG5xeWwxZ0Rma1lNSzBVTzdxa3VzSkRyb0xzOVhReEhPVTdKUDNi?=
 =?utf-8?B?ZmxwLzYwS1R0ZHFEcHNteHpZMHhaZE02OGFsS25YeGh3dG10dWJRa3h6WE5K?=
 =?utf-8?B?cVZaNjUwTTBydE5OMERqN003MjhmN2gydXY3M0czeDhMdENLemV3QnBYUUxW?=
 =?utf-8?B?T1BoT2RVcW9PR25YWXVJS2ZQYi9CdlZEUDA0TVkxWnlrS2JwQWc2R3JuWm1G?=
 =?utf-8?B?aWVPSXNVQm50b3FacllTMGt5Q0d2NlcxSUlZS3lQQTd3MGRtRWgya0htTmEr?=
 =?utf-8?B?RGY1QjVDU1ZkQkdzZmlYOVZhQTJwRU84QnM1a3QyMDVhRm15L3ZxcnQ0OFY2?=
 =?utf-8?B?TmhqOXFMcmtKUWJTcHlaa0N5dmR4WEltNzBKcnRteXh0S3NjR2dBSlRRb3U1?=
 =?utf-8?B?QVpGajQyLzI4ZVJkWlZYRnp5blgvbzFiVXZYa05BWTJibnNIL2g1Z1NzeG9s?=
 =?utf-8?B?TTZxQ2VENzBvZWVtZ0tWdVFvT0xvUVhFTDU5dmdYVElRV2g0MUhJMXRjRjNt?=
 =?utf-8?B?ZDlLQlE0QUhDdDhUUlhocUpaZXVOTG1ZNUk0dUlBWmRnbG9yNEluNUtPcWpN?=
 =?utf-8?B?dlNWclhXUHd3ZXhrd0IwWDZRTjJPbjVCc3pFYXJQMEtRWHlsK1ZsVHE4ZzM3?=
 =?utf-8?B?OVNsenVTY0JsNFJoK3lCSkUxdFhBNm5Ob1IzaFlUcm1jd2U4N2FoVEM5RWg0?=
 =?utf-8?B?Yzlaem1qT2dadnRZWmNXMWdrZitlUlJTbEQvMVlPZWhPRWtFWEFIRUlOb0dm?=
 =?utf-8?B?RnpKdkFQa0FObjl3SWM4azhWYlBiSlNXLzVrZlI1R3U3R25PTFQrZmp4WVAw?=
 =?utf-8?B?UmExUmhQZUZYUXg3eXJlRjB3Mlk0MS9YQXp2bjlQaDZ3aE9oSkMrYlNlMy9J?=
 =?utf-8?Q?HUz/XIfByfj8AFceQpl/x97L4IFhEW+B7Yhefbh?=
X-OriginatorOrg: kontron.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fb4cc5c-ae0f-4533-a384-08d988021791
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2021 13:14:41.8607
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8c9d3c97-3fd9-41c8-a2b1-646f3942daf1
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QZWdokjhpIQgmfy3ThykkvOUprAENHAy7fgcKZ1oTVeFnMZNc2nwVkm1WdPEcKPnhCkrUMc0CzJCDZ9dh6a4wJa7KSlxSC5lNUE+Rvstzv0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB2578
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 05.10.21 08:56, Shawn Guo wrote:
> On Thu, Sep 30, 2021 at 05:56:26PM +0200, Frieder Schrempf wrote:
>> From: Frieder Schrempf <frieder.schrempf@kontron.de>
>>
>> According to the datasheet VDD_SNVS should be 800 mV, so let's
>> make sure that the voltage won't be different.
> 
> Could you share the datasheet?

Sure, it's here: https://www.nxp.com/docs/en/data-sheet/IMX8MMIEC.pdf.
See table 10 for the operating voltages.

>>
>> Fixes: 21c4f45b335f ("arm64: dts: Add the Kontron i.MX8M Mini SoMs and baseboards")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>
>> ---
>>  arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-som.dtsi | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-som.dtsi b/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-som.dtsi
>> index b12fb7ce6686..213014f59b46 100644
>> --- a/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-som.dtsi
>> +++ b/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-som.dtsi
>> @@ -152,8 +152,8 @@ reg_nvcc_snvs: LDO1 {
>>  
>>  			reg_vdd_snvs: LDO2 {
>>  				regulator-name = "ldo2";
>> -				regulator-min-microvolt = <850000>;
>> -				regulator-max-microvolt = <900000>;
>> +				regulator-min-microvolt = <800000>;
>> +				regulator-max-microvolt = <800000>;
>>  				regulator-boot-on;
>>  				regulator-always-on;
>>  			};
>> -- 
>> 2.33.0
>>
