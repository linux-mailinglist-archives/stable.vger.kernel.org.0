Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 120AB422EF2
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 19:17:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236768AbhJERTJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 13:19:09 -0400
Received: from mail-vi1eur05on2096.outbound.protection.outlook.com ([40.107.21.96]:49761
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234938AbhJERTI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Oct 2021 13:19:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ekj9iRf4gSxOWKLsg3YU06Idr7e0rJY9ROqGH++eihLGNOoQdlT/zgkj9Cs4dlshtY5iqYhPPRUK1ZxXSCT2ZrqW6BXD3qqSF6e/qHWvFI+Idw0JsSNoPqozt/6e4vwMd9op0VMIi8v6w96uSWxmwMmWV0eotdmRxcPWTS72A55xRVTxk55qmWqjeJA7GGzEg19xxFzv1svm0uaf4ghHsHaYpdm90CYhCOllsdigOhNlT0ZaJUO2Z1XxIc7m1V2q9dDelFo/B5pm8nh9doEACR+yV+ju8y0NCm6oq2QMIpc1drSeD3Iw+A4VxTib0lWzusoFafiGOENnoKh2dKYetQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H1gL9pa/96GcysYb4dnL81fj0rY0i8LVeYSxLGeVDaE=;
 b=T+YgIGfT/3VDU3QSfQzBL43FA5qZbiFnDYb1G/2CDEH9at1DjIbGlCBZ6x7p5Q4n6U9vQccy6JrdzqKSytjrHxkaO5twysTH3KfW4XM+HdMv7MGVdlj7Hik+uPFz3FvFBJfBGb/BmTkqcT/Nkkz1jExmX4cjQEfjvf3+ivJc3BLiejvxwPqT1bvVtrgtsleDYnZKP6OOplVsAPZ9sq7hEM2xfk8yJEg8A3Cnw5rPHVJ8J4nHKpWseBdtOxIqTHtDb/RRqIoB2hsyNTy9zd9b1ZObklvEJwCMvRT+tYtLU+tD4SxGFN3LjvK524S9W802SY4e9o42Iw5ulYAeCkXcVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=kontron.de; dmarc=pass action=none header.from=kontron.de;
 dkim=pass header.d=kontron.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mysnt.onmicrosoft.com;
 s=selector2-mysnt-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H1gL9pa/96GcysYb4dnL81fj0rY0i8LVeYSxLGeVDaE=;
 b=EzA96OSOViZPXZevJ481D773I423SYKblfq+5cG6XkW51B3JjPaEbSYZY4zF6YhVtL03KZrHi4yir/wbbtuEZ0OTrWs7VsBmZ5FBQJ4njoY7N9MyJsHQEJAJgenoUj+/g2kSbyyLJL9UIyv09oQ8k0Z5LzWmWDoS73OhGc6PlkU=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=kontron.de;
Received: from AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:157::14)
 by AM0PR10MB2579.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:12f::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.19; Tue, 5 Oct
 2021 17:17:15 +0000
Received: from AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::216b:62be:3272:2560]) by AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::216b:62be:3272:2560%6]) with mapi id 15.20.4566.022; Tue, 5 Oct 2021
 17:17:15 +0000
Message-ID: <37c1845d-9323-3187-ed0b-b9795758649d@kontron.de>
Date:   Tue, 5 Oct 2021 19:17:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.2
Subject: Re: [PATCH 5/8] arm64: dts: imx8mm-kontron: Fix CAN SPI clock
 frequency
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
 <20210930155633.2745201-6-frieder@fris.de> <20211005071230.GC20743@dragon>
From:   Frieder Schrempf <frieder.schrempf@kontron.de>
In-Reply-To: <20211005071230.GC20743@dragon>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS8P250CA0011.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:330::16) To AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:157::14)
MIME-Version: 1.0
Received: from [192.168.10.40] (88.130.78.70) by AS8P250CA0011.EURP250.PROD.OUTLOOK.COM (2603:10a6:20b:330::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18 via Frontend Transport; Tue, 5 Oct 2021 17:17:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f6a492e3-d98c-4e25-f84f-08d98823f9f0
X-MS-TrafficTypeDiagnostic: AM0PR10MB2579:
X-Microsoft-Antispam-PRVS: <AM0PR10MB2579853988C11FB8A88428CDE9AF9@AM0PR10MB2579.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kv2N4fvr9RM8fOBvrIJFZn6PHMIc+uJfuDP+yS164Si/4So35ncDGwpNegC62fGAM6kvPAnZz/tH9ZJ3ngiCr8qJW76mcLppEw+GsytDbUo+rSKwTRpZvSrD5JU51uJ1ZVlLD8KzETyd9anU0lBMhU8C3eMnKUUHvS7Iec46bGaPiNhrZ6So9+4KeMeD8TdqSnEjmDGLWJ7xWWRMPrRkCBUY844mzfFkraNVa6k5o/87yQsCIzEk8K7IVdjv8x7sI/0zWZpDXAvsHDdnI4KHEDpL1A3JoyyXltejSvvkWXeGEpjajiO/xmLZ27XV5xCIcuFaHT1sc6ULYl480+hJEuRaZR1OvkMXqK6n7qKrqerQAirCOt1CBACjVaKc2OTfuGKyn2iEAZg9XDgksGIc6hWkLQMw16M4tVdypTMF/U/+CWp4MA+NlcYu2UMHdo3+j2jKla0+Vox5v2bGbrgyiOCO9GXMt7THtJUdMiXcXOQXFpu4RhRZ/lOTkLzRK1lHvlQvTFQ6YvPvGOiP7BqCykjiDNANgWsLRsIEUY0maZo4afaDC8pJCvVy1AKURJDRK/u8c6gD4WbffMAGvRxr2sPFbWGLy1tuaOf/J2b5tNjol6v2yKfJDoQVq0MR7O+rEh/aJHa1DZQnx6x/ltF8adf6jVVvsfTWKg8QNZfTRRM/8N5WNEtvqw2vTBmWWa+5iHQ+cCndg3JSQYsljlwJ1ocE+5UDL0OeNhIoV/vd9mIn+PLyKu3svWV+To7frsFw8UwSPd4M3ewi+gjdhDwm1Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(66476007)(66556008)(26005)(2906002)(508600001)(66946007)(53546011)(86362001)(7416002)(8936002)(8676002)(186003)(5660300002)(38100700002)(83380400001)(4326008)(316002)(110136005)(16576012)(6486002)(54906003)(36756003)(31686004)(956004)(44832011)(2616005)(31696002)(32563001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b2kyMXVBUDdmbnhPNnJ3bTFsWEpRU1JnUEZqa1B6KzFmdjRycFgxZTNpQ0lO?=
 =?utf-8?B?MlhxS2VkTFRyR3REdDE3bjQrQmU5MUxmckFUdkVTejE4MWFTNW0vMHF6bXo0?=
 =?utf-8?B?TVhrQTJuL2d4RXBtYmVnOThyRXVUYTJxbjNHZFVES3VQVlRleXl6UzBFdlJS?=
 =?utf-8?B?dU1CUmkrcjREOXdKQW1XWFdRWUpidlJnSURmTzJPLzRyN3hJbmNrZ0VvcXQw?=
 =?utf-8?B?T2dKWG5NeVN2c3ZFSklEZzdTRzVxUERqcXhvZmRqbUxnSkVsVnNJVElqcW51?=
 =?utf-8?B?TXJtWkFnMEd4dUFkbzNxdVgwQytuTXByR2lMQzFRMWM2THZVQUZIOEUzdjJI?=
 =?utf-8?B?MU03eGlSemYvdE96dUNuSTducWRoekdXakRiQXVETG9aUVBUOWthZ3FTWEds?=
 =?utf-8?B?allSbkxlN0FoS200Umw0VmsyNlJzK3g1M0VhRUh3Njgzb3c1b21scThZbHpI?=
 =?utf-8?B?UzVEZDhzT2w2WnBNVTNmemRJTzFadWdGNVJxRE9Fcm5jdnIvOEFYcDZwOWVN?=
 =?utf-8?B?WTg1UXMwUXFCaElUeGpYeFhYV0hZS1ZNazl5cC9DOXFuQnAxSWQxcW03akc2?=
 =?utf-8?B?MHk1M0ZPMmQrSHkzdDNLcWRnYWY4Wk4ySVV4UnhXWmNHSWNTNFdxamJ2N2wv?=
 =?utf-8?B?ekJVUFVORUdJQ3dZdkh0ZjZqcnJ6S0E5WG1ZLzRXNFRId24zalozNjgxTE5H?=
 =?utf-8?B?UTJqMFpCYjZvWC9tWUxZUkNFNFpCaGMvQm1YVFNYUGZpNnUyR1ZGQXlwdkVq?=
 =?utf-8?B?L0xXNFdxcWd2OW9mbmRvY2YvVlZnY2kxWFFMVkhXbDlQOUUvbTRqYkhJWFV6?=
 =?utf-8?B?RUsyc05td3dvN1BpeUNQNVRnRUhpdVZYNGxQTkQ4Z1RyWHRRK2xFK005UGtN?=
 =?utf-8?B?cjRaNmxDeGd1OU9Nb0ZhVTN1VGJJTnVtSGtLSjkxV25OSEcrcVNFSHFVek1x?=
 =?utf-8?B?aEJ5V2xrdVJXSmc0bmdMT0cwcUhDSjl0REk5eVNBWFdNSHB4UTlZUzd4L3Zh?=
 =?utf-8?B?R05rOGQ0VklDWC9McVRPa0FNT0w2NmJVVU9hN0NGbk55UG1GTmxNakhtUTVF?=
 =?utf-8?B?WldvYkUvR2NMVWlxME5OTkE3S1EyalBabEl2RGd1VTN5M3Zkc1BqbFlDUTJT?=
 =?utf-8?B?V0h2ZXFLSmZVNy9xdDJPbE5kQmxSYnZ6NUVUUWpDaUY5OVlhT3BWMk52NEww?=
 =?utf-8?B?RTF4UTJpM2IrNnZNbVJ2SnlGUVNpUXpIOWVmbWJPSHI5K0lhOW5VSDBIS0FI?=
 =?utf-8?B?Y2pnQjN6akJUV05YRytBTnVXYVFRNGlmVUtHNW40enZOUTYwUDhDY0dOSWtv?=
 =?utf-8?B?RzhwK1lDODZYVGpVd2YxcUN6STRmUnM3Q3NodWYrd1k4d2srQWFTZzF5bHVz?=
 =?utf-8?B?ZjIwRS9FcDE4b2tFOWFaS1d4YXVHOUozR3hJdnJLaVA5QTBLSTZsaVF3NjVY?=
 =?utf-8?B?dm12Z2VZSmdVc0JNOU5TUWdYWGFuL2hsN0dDNVFBQjBGV1JLKzNJQ1QrbFVm?=
 =?utf-8?B?ZWpPQmlHeGkrQXJsUkxHSVI5d3FNcktGVzJJOEFKUmxCK3ZJdm4vcGs4dXEy?=
 =?utf-8?B?NStoTXJ6V3RZTFBoajQ5eU9lSDduTFNsMUtzVjFCYUxUcHRYVkZScVRSbU1q?=
 =?utf-8?B?R0trbkh6bG0yQjh5Z05nN2hNVGtpcm94UDIrMm9CY3Y5ZFcvQlRDc1RHQVhv?=
 =?utf-8?B?QzhtT1NMTXJMb1k0bjg0cDV4UTdSYThyZDdpMTVTL29ka1NrOEhLb0ZkOWVw?=
 =?utf-8?Q?vTuQn0cgP/mGbHEaCS2lfwD9hwUgnRGVN6PJXfy?=
X-OriginatorOrg: kontron.de
X-MS-Exchange-CrossTenant-Network-Message-Id: f6a492e3-d98c-4e25-f84f-08d98823f9f0
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2021 17:17:14.9407
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8c9d3c97-3fd9-41c8-a2b1-646f3942daf1
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OqRt88s7/9lIkuccR0D+KEmKYGc5gixtaYxUSJqkGlR1pMdVJjLJaQMYzqNcCVGTOrdURR/U7fwAEF6XJBSYv/mpGOIK0hmckvPkLOLG4mQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB2579
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 05.10.21 09:12, Shawn Guo wrote:
> On Thu, Sep 30, 2021 at 05:56:28PM +0200, Frieder Schrempf wrote:
>> From: Frieder Schrempf <frieder.schrempf@kontron.de>
>>
>> The MCP2515 can be used with an SPI clock of up to 10 MHz. Set the
>> limit accordingly to prevent any performance issues caused by the
>> really low clock speed of 100 kHz.
> 
> Could you share some testing result of this change?

Without this change, receiving CAN messages on the board beyond a
certain bitrate will cause overrun errors (see 'ip -det -stat link show
can0').

With this fix, receiving messages on the bus works without any overrun
errors for bitrates up to 1 MBit.


> 
>>
>> Fixes: 21c4f45b335f ("arm64: dts: Add the Kontron i.MX8M Mini SoMs and baseboards")
> 
> It's really an optimization rather than fix, isn't it?

It removes the arbitrarily low limit on the SPI frequency, that was
caused by a typo in the original dts. As the usage of the CAN bus is
seriously affected by this I would consider it a fix. But if you think
otherwise, feel free to remove the Fixes tag.

> 
> Shawn
> 
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>
>> ---
>>  arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts b/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts
>> index f2c8ccefd1bf..dbf11e03ecce 100644
>> --- a/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts
>> +++ b/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts
>> @@ -98,7 +98,7 @@ can0: can@0 {
>>  		clocks = <&osc_can>;
>>  		interrupt-parent = <&gpio4>;
>>  		interrupts = <28 IRQ_TYPE_EDGE_FALLING>;
>> -		spi-max-frequency = <100000>;
>> +		spi-max-frequency = <10000000>;
>>  		vdd-supply = <&reg_vdd_3v3>;
>>  		xceiver-supply = <&reg_vdd_5v>;
>>  	};
>> -- 
>> 2.33.0
>>
