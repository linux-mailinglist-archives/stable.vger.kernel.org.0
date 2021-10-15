Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAE2542EFC2
	for <lists+stable@lfdr.de>; Fri, 15 Oct 2021 13:32:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231709AbhJOLfC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Oct 2021 07:35:02 -0400
Received: from mail-eopbgr70123.outbound.protection.outlook.com ([40.107.7.123]:15584
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230030AbhJOLfB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Oct 2021 07:35:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MYmv1mUlzN1rGbB2MrzRG9cp625oNcM+37um4HYd2soyAOahJckCZrh2iqITPAP+vjcD4M3uCJKX4sQLsvfrkZ5uQPq1q8CEpjsWhqzlpP5KHRWxbtvEGj6SKBGon7M7cD8MS6AdNwzKqJr9aASWmWbya10NkGGka7RbFBCUky0HN8NkchEJIdDKqDLGV5xch1p1wkKBrIBKQ/kMhBFeuHXa3sA81y+I7iwDq4AOWJa8ydneyLjSGQiaDrJ+7XFXHjjAhKb8SZrajlugs4Okb9MKE8OTkW84q7MdEoSN2zI/CzUr+f4cQJ3Vk3xE94IE+8DzLdWenjdiz8nIvNHz8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/OxhTRmXqrUgI89dD6BS9DX/QxbWF5z5+mD9gy1BlZk=;
 b=gNJBGdgoFZwH3ttqdj5o7mFe2+qeFpzjSz4Pw9XFjhzW+HA6innBoOew3IAnyrVTMkWy4/GB4OvXJv3nCBEW3DRvgw4kvzqNypMgQ5HGUgYzsURc7KLFnxohoDovIUTwB8Y6HHV0JgtK4Wgs4BVrbAIQld7P/hQRlBBhhaRiAE+VuVEh8amseKVE4Tu2Gp2HHXMAOdPfAcz6KXn0crqpAw0fVgQ51BwC9PzU8x5D0zuFjQGmmei14kOdRobCnnskUsgkfd4QZUaiEcwU/zrzbcTsfhM7dZEvWjSHHTWI9AEbfCxviJGOrp6U3Qu7an+915Jh9uaShYlArQtv2iuQWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=kontron.de; dmarc=pass action=none header.from=kontron.de;
 dkim=pass header.d=kontron.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mysnt.onmicrosoft.com;
 s=selector2-mysnt-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/OxhTRmXqrUgI89dD6BS9DX/QxbWF5z5+mD9gy1BlZk=;
 b=a0Z9yxPBRz9u2k+8qpshwJoo/660fBlKAF5ldt/O/Ic/w6kHWwZIbXT3zdBSulYO6p2wd8K+8qel5J27JCl73HoIOFGqYEn5oOWSL+DpAV7kv5EbgRGPFNeql1koHjGcdriCTLh4DMq0LwrdwToB/x7EgM0Hdxh2yzqymTLWDlQ=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=kontron.de;
Received: from AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:157::14)
 by AM9PR10MB4136.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:1fb::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.17; Fri, 15 Oct
 2021 11:32:53 +0000
Received: from AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::96d:7b11:1f16:a316]) by AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::96d:7b11:1f16:a316%4]) with mapi id 15.20.4608.017; Fri, 15 Oct 2021
 11:32:53 +0000
Message-ID: <00742641-72df-53bf-e75f-f627322c21d0@kontron.de>
Date:   Fri, 15 Oct 2021 13:32:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.2
Subject: Re: [PATCH 4/8] arm64: dts: imx8mm-kontron: Fix reg_rst_eth2 and
 reg_vdd_5v regulators
Content-Language: en-US
To:     Shawn Guo <shawnguo@kernel.org>
Cc:     Frieder Schrempf <frieder@fris.de>, devicetree@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>, stable@vger.kernel.org,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>
References: <20210930155633.2745201-1-frieder@fris.de>
 <20210930155633.2745201-5-frieder@fris.de> <20211005070949.GB20743@dragon>
 <725cc24e-f264-60ea-e30c-c50a61f7fe88@kontron.de>
 <20211015040904.GG22881@dragon>
From:   Frieder Schrempf <frieder.schrempf@kontron.de>
In-Reply-To: <20211015040904.GG22881@dragon>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM6PR10CA0081.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:209:8c::22) To AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:157::14)
MIME-Version: 1.0
Received: from [192.168.10.35] (89.247.32.72) by AM6PR10CA0081.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:209:8c::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16 via Frontend Transport; Fri, 15 Oct 2021 11:32:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dd73a759-9149-495d-bf8f-08d98fcf86a9
X-MS-TrafficTypeDiagnostic: AM9PR10MB4136:
X-Microsoft-Antispam-PRVS: <AM9PR10MB413638B2E514C197007CC924E9B99@AM9PR10MB4136.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +dOQtx00JI4fCGnd0HBz0mlMt74PIIdTrAGQfC3Q1M+VmrySH1Mr+nLnCjPBW2PGHbact7btILoi4jXvQJ2s9m++BuoEXmz2W3XsOgS8bE0lI8kTfDPxQ/szPu4bXYizEQq11vL+Rh/wX61A9fpNJfi9deqHK/t9e1eZMIeNne2ighmCNLexFWvGuedbSH2gvTBAMjYaTsx5Dyf20fxnCJJ2KKE71luACuLso62wMessy6uwFuVsFaXsb8gSx8t+t/aj/TGh4MH/vOghDzFaH9XQh1hLM5PXixbRbzEcV6XanFfYscPzI92xZEDW0/dJJDdG/A/zFEHXSuqTwJdwOnm94BkepRqF1zJhoB8BCSOOdRJB1/YnzkajbQzFrufGy3CxBKPOSQjCedq6fkkXSZRBEInNUC0hsFsW1WWamXCEY7dO7zFEvTDCKNkYGNugu95kecAnxvY5uT+oWwzqb8Ir4sa8PydUxi2U+oegNU0jfnppQcxgmVfrGzPwIEmmuFSkB4FqG1vV7PujR3dyRWdu2DvDXwhs7867gfpC+VYT4Lpw7eJYh3RPRXCvXgjl4QsFSI3PbiKJFD6P6DlK/lqCOCxZhFylMXGL3dHcaTGEIbXZHgkLLBYu8eMRG7CAXqizqJE5sMdZCZ8JBA18hLbXqNobpt/AK5kI8zl64qwZoC1A4pTA99ul8i0VUJ32noVH7+sV71T4+h7HUoYv+K1oDqON3pb7BCFVM1QB+H7gQezvbddvXYGyK9evk2MIYvOdEzL/OOoKDY4GrPRId9ITwu+94EGy7ickjGpYGHv8y5PVXBOH8Kg5ICDTRpN6fePgGMH+mDBAq8p/Qb204nUGD602QsEl0JhGwas//HM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(66556008)(66476007)(956004)(2616005)(66946007)(44832011)(38100700002)(966005)(5660300002)(31686004)(7416002)(31696002)(6486002)(53546011)(54906003)(8936002)(86362001)(16576012)(6916009)(36756003)(508600001)(316002)(83380400001)(186003)(4326008)(8676002)(26005)(32563001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UThxMU44SWk1eHdrRmF4cjY3NjFSZDdOMTlYRVN5Uy9ESm9nNVdjM0Rsb3hn?=
 =?utf-8?B?d1VZUERoSzA2T3VSSUlwd296RU0yTWlVTlJVaW1ucFFxeStXSWZCT3QrUk1N?=
 =?utf-8?B?QW10dUxzNVE2bFNFZEhlOG10Z0JnZm5QZkptN1BJMWp3NWdVQ3pCYk5OanR1?=
 =?utf-8?B?TVVLWXhwMnAyM2NKZGU0ek1uSis4eDFHdWMyaFRIdTM1c0doa3ZjOU85WUIr?=
 =?utf-8?B?WFU1NGNvQTJEOCtlU3ozazdhelNheW12c3padE1jV2ZQY2FIeFpZbU5XV1RK?=
 =?utf-8?B?QmlmcGRrQ0hSenBjRXZIa05pc0NQOHpMYW9kV29tN05uWHR0Nk5WL3R0TE9x?=
 =?utf-8?B?MkFGcTRUajZPQ0lWdEJGWmZuejJMQmo5aVN6aDMzOW03ckFEQk5DNW9YbHRH?=
 =?utf-8?B?Uk9BTzY3ZGU4LzZQN1VlWUdaNjRlaEJTN24xQ210Z2RaUWJ4RFZhUDF4bUl1?=
 =?utf-8?B?RlQ1TW01SUVMQjQ1OGxEeStLSVozamVSVEtmNENvV1dwNmZlU05RZmd1T2xm?=
 =?utf-8?B?bG5qZ1Q0SExjbFprRkRIVnI2anFzYmNJNld6WWNabmxkUGovSGhCV2l3WkdD?=
 =?utf-8?B?UkJlcGdzYzBtckx1OHdHMTBjY2xabFR6eExra3gvclNaR2UyNzk3dEpYakhV?=
 =?utf-8?B?M1ExVHE0eGtJQks2NVJYOEd0bWlJMjhKS3luaVozVFhGazVuREhvcXBCZjhE?=
 =?utf-8?B?d2RPQ09aVlBIaHdraCtlTHVGSDhFOG5vaGtqMVZ0VzBKVnFhVUlhTFV2a3JE?=
 =?utf-8?B?V1JtZE9KYjlHR0Rrd2JEOEF1Q0k2UGJwbnZSTVE1YzZNeDYrNE5PcjVINGJX?=
 =?utf-8?B?YzJGWUJmN3FSenc1YitxNm1GVkFUOVRXaDJ5L21kalNhWmM4VTljUys2OUhE?=
 =?utf-8?B?WXYrNFFGdm5YSFYvUVhUclNHeWVMaEZYeUx6VW9jSHY0MGtuL05aRkcyNi9I?=
 =?utf-8?B?M2lSQkVnUmt6UnFNRk4zYjhxci9XdGVWcGx2V3RWUFlrZERPYUJDR3pJWEFU?=
 =?utf-8?B?a0drcDdsR2d2T0xFY05lMkNKM2lyRDdQMzVESVh2eWNPcWV2YW5ta0N1ek1J?=
 =?utf-8?B?YXZQQ3lwOHhpbXhhNmdlRHF6ejFiMFU2ZUxjbzd3ZkJjck52enVSSm83Q2hL?=
 =?utf-8?B?TFE4YkpSamxYMnRURlpEVkNQUjFvMnBiWWJjN0gvdG1peHFURkxEbi9wNDJp?=
 =?utf-8?B?VmhWNzlhKzBTbWxhZ3NlNU1YamZkOUVzSTY4VnVzemR1YnlnUWZWVjg4L1lI?=
 =?utf-8?B?eUw4UkFsTXpVSGxaRXg5c09oQTFGd1pPaDltYkZsQmNDZXhoWmNRZ3lLR2dZ?=
 =?utf-8?B?ZzNpR1QzODh4V2tuZW90RUtYTkZZOUVHdWh0UjhCU01CbFhweHNsN1I5SWx4?=
 =?utf-8?B?MjVTWjlGSTZ4UnBzMzNyRm1POUFvRU83eVFQTzY3dkVMWHRxcGVVdThHZElm?=
 =?utf-8?B?TGRQc1RWSnh0UlNlV1BnWHhtWUVlK0h2VEJBYlozQnZCOTdwdlptYTBHMWZ6?=
 =?utf-8?B?UElPOWlUQVJSY2hPZWNrVlVXQWtYU3gweDI2ZFRpV1g4KzlpVzNLeVAyYm9H?=
 =?utf-8?B?TXhVL3RBWFBBS1hHVERQUktmWjhvYm52NFJyamZLV0FYUjdSeWNqRjQrVlNl?=
 =?utf-8?B?WFJOd2pWcVVKMGRSNUdJN1k3R3o4bGtBdmhjTDZHWDlBbGw4eVpTUWZGVGdj?=
 =?utf-8?B?R2g4eUsxSmlyR2tTTVQ5YTVtTmlpbkxwTUx3ZkxLMWRya2RQU203MVVqbENo?=
 =?utf-8?Q?aX/xPp9gbYjXRb2x/lS2Ov1arBVq55haeLVuflZ?=
X-OriginatorOrg: kontron.de
X-MS-Exchange-CrossTenant-Network-Message-Id: dd73a759-9149-495d-bf8f-08d98fcf86a9
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2021 11:32:53.1108
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8c9d3c97-3fd9-41c8-a2b1-646f3942daf1
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K286bAWuiGXexvN9+l3ZLwlSx+XliVyp/thQLM64TqNYlVdDxnrttZXQYhYq24VojSf7f8ts8TD0HtbG+NMJbot8/60t2lz6FlCoKDk7QmA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR10MB4136
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 15.10.21 06:09, Shawn Guo wrote:
> On Tue, Oct 05, 2021 at 07:06:57PM +0200, Frieder Schrempf wrote:
>> On 05.10.21 09:09, Shawn Guo wrote:
>>> On Thu, Sep 30, 2021 at 05:56:27PM +0200, Frieder Schrempf wrote:
>>>> From: Frieder Schrempf <frieder.schrempf@kontron.de>
>>>>
>>>> The regulator reg_vdd_5v represents the fixed 5V supply on the board which
>>>> can't be switched off. Mark it as always-on.
>>>>
>>>> The regulator reg_rst_eth2 should keep the reset signal of the USB ethernet
>>>> adapter deassertet anytime. Fix the polarity and mark it as always-on.
>>>
>>> It seems to be wrong from the beginning that the reset is modelled by a
>>> regulator.
>>
>> Right, but at least at the time when I upstreamed this, there was no way
>> to pass the reset GPIO to a USB device driver and using a regulator
>> seems to be an accepted workaround as far as I understand.
> 
> Do we have the solution in usb driver now?  If so, we should probably
> switch to that, instead of patching the workaround?

I had a look, but couldn't find anything. I remember there have been
efforts in the past to provide a generic way for usb devices to manage
resources like reset GPIOs and clocks (e.g. [1]), but it seems like
nothing of this ever got merged.

So for the moment I'd like to fix the existing solution, but I totally
agree that this should be solved properly in the future.

[1] https://lkml.org/lkml/2017/6/21/90

> 
>>
>>>
>>>>
>>>> Fixes: 21c4f45b335f ("arm64: dts: Add the Kontron i.MX8M Mini SoMs and baseboards")
>>>> Cc: stable@vger.kernel.org
>>>> Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>
>>>> ---
>>>>  arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts | 5 ++++-
>>>>  1 file changed, 4 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts b/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts
>>>> index 62ba3bd08a0c..f2c8ccefd1bf 100644
>>>> --- a/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts
>>>> +++ b/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts
>>>> @@ -70,7 +70,9 @@ reg_rst_eth2: regulator-rst-eth2 {
>>>>  		regulator-name = "rst-usb-eth2";
>>>>  		pinctrl-names = "default";
>>>>  		pinctrl-0 = <&pinctrl_usb_eth2>;
>>>> -		gpio = <&gpio3 2 GPIO_ACTIVE_LOW>;
>>>> +		gpio = <&gpio3 2 GPIO_ACTIVE_HIGH>;
>>>> +		enable-active-high;
>>>> +		regulator-always-on;
>>>>  	};
>>>>  
>>>>  	reg_vdd_5v: regulator-5v {
>>>> @@ -78,6 +80,7 @@ reg_vdd_5v: regulator-5v {
>>>>  		regulator-name = "vdd-5v";
>>>>  		regulator-min-microvolt = <5000000>;
>>>>  		regulator-max-microvolt = <5000000>;
>>>> +		regulator-always-on;
>>>
>>> You do not have any on/off control over the regulator.  So how does this
>>> always-on property make any difference?
>>
>> Right, this doesn't make a difference and is definitely not a fix, I
>> will drop it. Anyway, this regulator is just there for completeness of
>> the hardware description.
>>
>>>
>>>>  	};
>>>>  };
>>>>  
>>>> -- 
>>>> 2.33.0
>>>>
