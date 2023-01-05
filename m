Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4003765E5F8
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 08:21:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230379AbjAEHVa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 02:21:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229912AbjAEHV3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 02:21:29 -0500
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5C1042612;
        Wed,  4 Jan 2023 23:21:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1672903288; x=1704439288;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=JjCAMTXMv3pEZ/NUfUYrIZjILFekIbrz5PCh0HKfZ84=;
  b=nq2uJh1HTPHf9fxoJQYI9vF1lioM9l33HXvv929oJik4In/fy57Q44Ay
   qWEHGpBKeF+PSQATqdQq5y4SFSX65ZjIjDOm4d0h72DK7YeQa7q0N/KcL
   NG0wMG/rSXW7je3m0grDw/7ZVkcCGs6WmD/Po/q6kj8RfhPY/cjWbx9YY
   PLlzDnDB7wZxmeICxBiaidfSTVVz5RLUxJt6PTNTWrg9V+j9YW6III9IE
   xFSO8zusQHoTkocNz7Obb11SngNrSoPJVZ1UgN1tqGBFn6HWpljWtVfcn
   oTbrXEKTg0lHdjMtN/ce6yB/uQTaOrKLrhzajUM175hxWGd6ImTBfJ7hb
   A==;
X-IronPort-AV: E=Sophos;i="5.96,302,1665417600"; 
   d="scan'208";a="225125159"
Received: from mail-mw2nam10lp2106.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.106])
  by ob1.hgst.iphmx.com with ESMTP; 05 Jan 2023 15:21:27 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BzaKalEgfUEgyCoPAjq6n3gTtNW6KMO1PrE//EnHQKrqTHzIGIGySf1xQWTTrgoB/gJQVOAOUk1558mTRt/Ujo8K2XxCm7t/YP7SEuLntgcddPWBFLXIR77eNfUfgl9xFoWjh5MQfU8WmrcRnr280lEmUFk3uqZ3aAtgMoOkefTDdAaocWhv1bgPIlQsj20rh0HjWyWh7ywtV8pSTW9WHri7MO9/1KAZosyNBCfZ+shkQXr+2LU6RhWjp6B8gRFZXzGKV0SJTCCH+Xy/M0uXlVXneXEhqm4Nwtsgp6pOhYVmG1hO0iV5itbdtLo9qWQxrLNvDS5XcFrcNq8rHjn8jQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JjCAMTXMv3pEZ/NUfUYrIZjILFekIbrz5PCh0HKfZ84=;
 b=Na4Hgazr6IvnCLoH3hYl17NJW4hFKLpW5ng0eRlk+pBV+t/Xl6NLIu7pH4/bd0stw1FfrEScmCMf7clAeHlsnEaJzCah/FKf6q1lUeNW6MyskrJf490877lLaeH1trWxR3XGozCQT8J38IHTB+0anwEkkac58ujlAF4hnxQ/DRoKZAm53U70BL6tiXZrgBFt121yf8ew2BD8RiQhdH8Cjq2UB6AcnuMixciRe4HkmnEdTkIyjo8ba73XaC00u4fRNkiBXRHgZg/MOB0JH1o9ZScB9InOCwTaWqQpAnE20MLPVOV4LPOTKu2PWtpF+XTMGb9w5sKmO0qwptyQ80uc2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JjCAMTXMv3pEZ/NUfUYrIZjILFekIbrz5PCh0HKfZ84=;
 b=ILUoAwtLzyD1MBnXr3OXA67vlpWAslKcyQ5mmmyYjpuWANdTbjMnqGi6HhlCOVAM1Wh+7BsovcUza6gNlwRYUnWr3pnMUUhaydQbG7z4UYvR54a2N+cNcEBO4RlW+84NChIQD1DeBNqi2+K4b7k7RanU0cFv7WA48ykgV3803Nw=
Received: from DM6PR04MB6575.namprd04.prod.outlook.com (2603:10b6:5:1b7::7) by
 SJ0PR04MB8245.namprd04.prod.outlook.com (2603:10b6:a03:3e5::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5944.19; Thu, 5 Jan 2023 07:21:25 +0000
Received: from DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::1afa:ab74:ef51:1e72]) by DM6PR04MB6575.namprd04.prod.outlook.com
 ([fe80::1afa:ab74:ef51:1e72%4]) with mapi id 15.20.5944.019; Thu, 5 Jan 2023
 07:21:25 +0000
From:   Avri Altman <Avri.Altman@wdc.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        Asutosh Das <quic_asutoshd@quicinc.com>
CC:     Johan Hovold <johan+linaro@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Can Guo <quic_cang@quicinc.com>
Subject: RE: [PATCH] scsi: ufs: core: fix devfreq deadlocks
Thread-Topic: [PATCH] scsi: ufs: core: fix devfreq deadlocks
Thread-Index: AQHZH7ytIv0nmKZpNUaZ7D6pWDZRBa6OTTOAgACL6YCAAJHYcA==
Date:   Thu, 5 Jan 2023 07:21:25 +0000
Message-ID: <DM6PR04MB65750DE015FA51FDC08D994BFCFA9@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <20221222102121.18682-1-johan+linaro@kernel.org>
 <85e91255-1e6f-f428-5376-08416d2107a2@acm.org>
 <20230104141045.GB8114@asutoshd-linux1.qualcomm.com>
 <3db8c140-2e4e-0d75-4d81-b2c1f22f68d1@acm.org>
In-Reply-To: <3db8c140-2e4e-0d75-4d81-b2c1f22f68d1@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR04MB6575:EE_|SJ0PR04MB8245:EE_
x-ms-office365-filtering-correlation-id: 21678d4d-7549-4799-3607-08daeeed7491
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zkKSnXlQMg4w9WBXxGk9seGfmVTilhf1SRd7dZjrFdEJZNXPxV0O2y29x6Ua8VCt6LKraRbHR8GOiUHLOHxOHyqP5BMpoFJsyMCTWI2gpswr6yVHKxO/xO99PMmze/oSC7IQB7pHVVt81AYl4SbxyH4H8gW5MX8x3JjJuNed7Ew0mzHUnugI9or335hD28RTUvABSJwWl5rveHBsqa6kOH9Uhr8ewBCWiptIk7Le/USEgjD+tlr2UuNXOKEj6PeC2S1Xu6PqXkZQKP81jdrlBoWsawFY53T72GSOmcp0K5PJdku68J9BZ+vImuFwdXTefgLKV+vLk+F+L5JlqKZF9cpg02ZAmp6uhmICJSNqueVO+jtbMX3LKeraG+InOPIkdMNtK35Xh4LE9gao43BoCIG+A29Ry8+NTSKL4jOA7e4LrWlpnPdXqhsIRpcpOxdhrIrjwEglN04oQXOBSpyJtTMXk9Hy1OUs9RdTdt/PVI/O+41jrV8/k86oiWY7XWMfEPP5BGUoXUZ0g7uLsfL+0hv8bqSp7mks6/2ChrV4OlsqNj32Ds/TZ7zscgTFKoHje2ZDzlw1/rnI24lcuzueiO7QmIYEqQGiKBLv2OJuhbpjZ5onTGTp/wP2bFylhIm8TikdRszF5nmaV4NA+6YJTzyqYVb8TuThxHt5O6xVB4u1dlypsny2u00dWpnJQQnEDPLTqvZZ2QLMMIHagf9Or06LBwNEWQaW1v0P8ByG6xh9W1Yqkf2vhj12k6l2clf1
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6575.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(346002)(366004)(396003)(39860400002)(451199015)(9686003)(186003)(83380400001)(86362001)(26005)(55016003)(33656002)(38070700005)(122000001)(38100700002)(82960400001)(52536014)(4744005)(316002)(2906002)(8936002)(54906003)(66946007)(4326008)(41300700001)(7416002)(8676002)(5660300002)(76116006)(53546011)(66446008)(66476007)(64756008)(66556008)(478600001)(110136005)(6506007)(71200400001)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dTJxZWE0dExzL2s0OGVsSW9zakNpV2JGdHFxYnZ1czlKU1gvM1huMCt6ZEtM?=
 =?utf-8?B?dTQyR0xrY0hid1NvZXpJOGhLNWNoL2FFTE9PYkpZbWRDMURTYTBjcHIyU3la?=
 =?utf-8?B?WUZCb0d0Ynd5eFdZbnFGbzVwQllSTTh0UjVwdHIwT3VDSWpIeVpTS0JEc1Zq?=
 =?utf-8?B?d3VoSzZHZ3V3NWw2bkF4aXU3d1BQLytuWkMrMnJhbG8yMlBnK2dFbDNPN0xy?=
 =?utf-8?B?RnRmNUx2YVZ3QmRPVEJLenNhR0FsTnI3dFYzL3Rld0dneU4rTk9ZQ1pKOCtG?=
 =?utf-8?B?d2hkSU5aQUp4NDFlUER1UXJNcHJkdXlnaEd1WjVpOFR5b2RvdzJhS0czTzJ6?=
 =?utf-8?B?cTBWYzB2M01jYk5YMWVxTW1DejZHUys3aEJoUkpnakxBbEpYcVlORG5rd3J2?=
 =?utf-8?B?T3MvWmEveWxkcGFKUW9wRUF0UWpLRktpQWszU3hCem04TWxVZ0Yza0FKODNs?=
 =?utf-8?B?RzlvRFFHYkxsbkRSQ2w4U2lzekVsbHFhdmx3TnQ0UTVRRHhmbkU1aWI5TklD?=
 =?utf-8?B?ZkxXOVltUkNhSUQzbXNXOElpSDJaeWF1eURhWFhNZXBVVHptVHF5UnF6TDFH?=
 =?utf-8?B?TU9NYWo1dVFHaXhNVWZCSytHaVZMa3hnWFpGcXd2N25RZU5QSU1adW1XRjRP?=
 =?utf-8?B?endOZUNkWXZoSFlJRk1pU0hYTTBlWnc0MDRDaXdhUGZYcWlmNWQzZzZGVUU1?=
 =?utf-8?B?QXNSZVZVT290OXFlTlVTSFlnd1lrU2RoRTZyWDhGZm5zZjBQb0FvU2JyVzda?=
 =?utf-8?B?bFlhYjcxS3d4Q1IxUDd2NzN1ci9HQjJ2NWhGZ0xydVV5aWRjcjlzTmg5R0ZX?=
 =?utf-8?B?bk9CTzB5OVMzNm5oR2FMejdma0NmNnp5azIxZHEwZVh6T1Rqa3NSWG53aGV2?=
 =?utf-8?B?WjJtSmVlOGxUTEpOV2JEcHY2THRiR3dUSjA4RWFhK0hJbXR3SXZ6Z2pPaFh5?=
 =?utf-8?B?OXhqdVI4QWtFSXkrS3gyRHkzaDVmRWNjYUxqMS91cnpzQTdVYm15R0J4Qjhw?=
 =?utf-8?B?ZUgyTTVHVDFFNDRWRWYxWVBNWFc0TEF2M2o1N05QRDZJL3ZNRDM3bnIvTnpN?=
 =?utf-8?B?blAxWUtSaG9mdmlkMUxaWmZZQmgvUXliQzBlK2pPN2JOM0REN2NIZy9NY3ZX?=
 =?utf-8?B?Z3dvSjNJbkp1UWRxbHRSQzV2VXlleThtWkUyeUFLekNBYUZhMzUrRlRuVzBF?=
 =?utf-8?B?aEl4Ky80VGtqTXRzQW81dVhjajRmMTNOdXdKRElVbnRWRnE1cDluK1VVTDJz?=
 =?utf-8?B?dytsZVZCSFBiVXcwdHUrbnRFZGp5RXM2TGptZm9uaEhPTU5KS1ZxclZONWtD?=
 =?utf-8?B?QmowRlBXcUV1bjJBVzB1RExSMkluWTFhelR2cWlvL1o5aWVwaEpvR3lBOFls?=
 =?utf-8?B?bC9GT2N6SGV5VUtmZHV0V1JYbTkybzNYeFB4WUIvaTFhRkhUOStEZXVMTFd1?=
 =?utf-8?B?L2FkT0dZMEgrbndML05rOXIzeWpoOExJOFNScExOTVowQi9VcmJxSzdJTVRU?=
 =?utf-8?B?VElieFJGdjBVN1NkdVd1c3h0QWR3YkkwVG51SUdQdXlVVDBMakM3dC95NlN4?=
 =?utf-8?B?ZWJCYTIvMUtKWldrYldOVjNVY01YOFB0V2NKaU52TkJxTUZWUUJRYWE4N0k4?=
 =?utf-8?B?TnR2V1lsQzhPUG96eG5RSFp1YzZ4aHVoUVVGVmphbjZYUEJNMXZuQXBGZEsy?=
 =?utf-8?B?d0I5Y0YzOG1Fb3MyYm94NWo3Mko2K21tbFdBekJCaDdRelN3allPSG9zWlVV?=
 =?utf-8?B?UGxFaGtGc2FWSGpoTytlNFl6Y0dFeitsaUJLY1gyQlFZODBHQW9ONmtMcE9i?=
 =?utf-8?B?cmVoeUxpLy92WGFKTUpPdDZjeEYvYndwREVUWmxxeWo1TVM3Vy8vUHFFNXVr?=
 =?utf-8?B?azdMeVNLV21hVTB2RHEwbVJTUFlhOWt0aTM3aDJYb1p3SGgzenR5SXBkMHRY?=
 =?utf-8?B?M2ZkR0RtTHRVeFZaQzJOV01YUENGYUlpaXkyWkswcjdPS09nM2YrSURPc3c4?=
 =?utf-8?B?STI0WGt5cXhaeERsSWJuczhkWGQ5R2ROMW5vY2k5S2RCbmFYSjExdHRVdHly?=
 =?utf-8?B?KzZBSlZpMnFHOVJBUy9WblBuVjlSbkJmd0I2cjVFUXhYclJYd1hnZnJja2Mx?=
 =?utf-8?Q?D3oDn21n58pmALCiiTFEGG9Uw?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?cWp2bndxb3VLam1TMmFqMWRYMVZMR2E1REhqY3NuQXR3c1YzNjF4am9GRmdK?=
 =?utf-8?B?THdqU0FDc0NsUTgwZE1Sb0tCVGpPcUIyeEl6amhYTVZVdU04Z1h4VVRHNlBl?=
 =?utf-8?B?TlJoYTB3MEJRYzRqS1VlZ21GUVlqZC9TVWdrQmpuT1NqZUlRUVFFNUQ1SUll?=
 =?utf-8?B?bmozc2IrSkZnZjRqMnd6UFUxYTl5TzJVQ0Q3bEtrTDR2RW41c3pvRlNUVXoz?=
 =?utf-8?B?MGNnbUhYVVpJR1ZBZXRFRGd3TjZpYndTMTVGOEdKRjl6VzI5a3grWnMzUmVj?=
 =?utf-8?B?SklaT1Q5cHlHbkFwSytTRjlrdGg3OUI0bURMYmlHQzlVeG9jbmlmTDBrSlh3?=
 =?utf-8?B?MThBVUhKNkhWZG5yc3RzWURHWTJCSDZqenJTWHZVdEl1UlRzNW1xZktVUFFI?=
 =?utf-8?B?RCtCUEpBY2c1RFlIUlM0ckhyQ0tlSVVhT2N0WEdvME1lQngxL1FnaEYzR0Qw?=
 =?utf-8?B?dCsrY3hPakl6UEI5c211NDE4bXJiWWkyVnVVNE9UM1hJL0FLWVFSQjRac1hi?=
 =?utf-8?B?NHZhK2FJRlpIK2c0SmNGdEZvMzFrTHY5OUZaMGg3RmpKR0JQRmN3b01Oa1dK?=
 =?utf-8?B?SGNXbU9NMnlESjlUTmdxZHJlTGFySTVMNUl4U0RyODhLYkdSdTZ0SkxlY1BC?=
 =?utf-8?B?OWNNcUdIUmVnblFMS1RwK1J6cFR5cGZJY1VGOG1Zckt5alhpdGc1L0Q1cHVM?=
 =?utf-8?B?ZmZ2Z1UxWVRXdWQ4MjdFNlJpakllRGxHUnpjS2hURm9INHlnb1BGTkt1S0NV?=
 =?utf-8?B?ZGg0YkV4NU5UbHFSQnlvNno5NVVJNDVKQ3BkY3loS1lkczB0T1V0K3FFRVNI?=
 =?utf-8?B?Lzkrdk9SWmxpMk9RMXd6cUdEZm5lSDZ0WUNKK1ltZzFTSm5jUVBMemoyT0Q5?=
 =?utf-8?B?MW0ya1l6dnlNeEZ6NTBwMitDc1dTTDdkYnFLdUpCWWJYdnkyTGsxd3Rld3hh?=
 =?utf-8?B?eDBobXBmYkg3YTdoazR4bktiLytNdGM4WEJTTjRGSkhKZHVldFJCTERlUkxh?=
 =?utf-8?B?Zno5NzJseUQxZ2pnMmg2TFFTbjFSV2Z1QzJCRFdLb011WDdXZDl4bGRCZldB?=
 =?utf-8?B?R3ZDQ3Q0TjYwV2Q1L2FMU2tuZERUZFdTTWRzSlJnenpUVWs4eHA1QlNFenA3?=
 =?utf-8?B?cWxBYmYrVUZFRnN3U0JIOFdmTDRwRmFaU3RXaEJlWkQvQm5ObTJxbXpNK2dh?=
 =?utf-8?B?OHdobWsvRnBCZkNjNjU3clpkWUlUTnlmM1hndndTZTYxbDdmQzFHRlp5bVlk?=
 =?utf-8?B?VDk5Y1Z1azVHYnFIWGZRZFVCMWJvQk1Fd2pNN01DaEl6YjJ5cjA2RzduTnB1?=
 =?utf-8?B?ZFFwSmFXQmZZaVUwM3NJV1NsNURCWmk5K2w1VmdkZWhxTzZTTDF2TkFJUzIv?=
 =?utf-8?B?eDZNRytEa21YeURqVktHWTlaeEI1TXFPTU1tbVRyT0o2bmh2Ykd5bEZ4RGVk?=
 =?utf-8?Q?chvD6hE4?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6575.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21678d4d-7549-4799-3607-08daeeed7491
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jan 2023 07:21:25.6523
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9L2Pd9fan0fFWYG5cRLfdRDNd0pLSVBucjBpqTVkZTAuQT8Y50JDzyvtbVsfvZDJ8ZuZEspHOBeymsxpVxOhfw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB8245
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

PiBPbiAxLzQvMjMgMDY6MTAsIEFzdXRvc2ggRGFzIHdyb3RlOg0KPiA+IExvYWQgYmFzZWQgdG9n
Z2xpbmcgb2YgV0Igc2VlbWVkIGZpbmUgdG8gbWUgdGhlbi4NCj4gPiBJIGhhdmVuJ3QgdGhvdWdo
dCBhYm91dCBhbm90aGVyIG1ldGhvZCB0byB0b2dnbGUgV3JpdGVCb29zdGVyIHlldC4NCj4gPiBM
ZXQgbWUgc2VlIGlmIEkgY2FuIGNvbWUgdXAgd2l0aCBzb21ldGhpbmcuDQo+ID4gSU1UIGlmIHlv
dSBoYXZlIGEgbWVjaGFuaXNtIGluIG1pbmQsIHBsZWFzZSBsZXQgbWUga25vdy4NCj4gDQo+IEhp
IEFzdXRvc2gsDQo+IA0KPiBXaGljaCBVRlMgZGV2aWNlcyBuZWVkIHRoaXMgbWVjaGFuaXNtPyBB
bGwgVUZTIGRldmljZXMgSSdtIGZhbWlsaWFyIHdpdGggY2FuDQo+IGFjaGlldmUgd2lyZSBzcGVl
ZCBmb3IgbGFyZ2Ugd3JpdGUgcmVxdWVzdHMgd2l0aG91dCBlbmFibGluZyB0aGUgV3JpdGVCb29z
dGVyLg0KVGhpcyBmZWF0dXJlIGFzc3VyZXMgU0xDLXBlcmZvcm1hbmNlIGZvciB3cml0ZXMgdG8g
dGhlIFdyaXRlQm9vc3RlciBidWZmZXIuDQpTbyBlbmFibGluZyBpdCBpcyBhZHZhbnRhZ2VvdXMg
YXMgZmFyIGFzIHdyaXRlIHBlcmZvcm1hbmNlLg0KDQpBcyBmb3IgdGhlIHRvZ2dsaW5nIGZ1bmN0
aW9uYWxpdHksIGNvbXBhcmVkIHRvIGUuZy4gZW5hYmxpbmcgaXQgb24gaW5pdCBhbmQgbGVhdmUg
aXQgb24sDQpzb21lIGZsYXNoIHZlbmRvcnMgcmVxdWlyZSBpdCBiZWNhdXNlIG9mIGRldmljZSBo
ZWFsdGggY29uc2lkZXJhdGlvbnMuDQpUaGlzIGlzIG5vdCB0aGUgY2FzZSBmb3IgdXMsIHNvIGxl
dCBvdGhlcnMgdG8gY29tbWVudC4NCg0KVGhhbmtzLA0KQXZyaQ0KPiANCj4gVGhhbmtzLA0KPiAN
Cj4gQmFydC4NCg0K
