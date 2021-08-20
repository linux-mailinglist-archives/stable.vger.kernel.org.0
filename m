Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2E213F273D
	for <lists+stable@lfdr.de>; Fri, 20 Aug 2021 09:04:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238769AbhHTHDt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Aug 2021 03:03:49 -0400
Received: from mx0b-00128a01.pphosted.com ([148.163.139.77]:57118 "EHLO
        mx0b-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238760AbhHTHDs (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Aug 2021 03:03:48 -0400
Received: from pps.filterd (m0167090.ppops.net [127.0.0.1])
        by mx0b-00128a01.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17JJgZKi020247;
        Fri, 20 Aug 2021 03:02:56 -0400
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2102.outbound.protection.outlook.com [104.47.55.102])
        by mx0b-00128a01.pphosted.com with ESMTP id 3ahk6ynnnv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Aug 2021 03:02:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KJM/CEbZNsblrAG4BFnRT7xdJb6BZUdJNgSrKPOaWaSa6d7xFCdqRnKsRnmemVrGix/cAC6AVVOWiquNAr4q6+SJz8jZ8zc0m+q8pgQttPOSSAEsluvMGwbBnqemzjNalwvq9s6YhcdS9tBfQNcIKMUrH5wnO7P1l2BQ5RS66zw1Gm2AvutqEFG+rMOzwbMGYvlXvP7FQuFp+1rE5IeYxW2iboQI2E6Qv4Ieme8FMs2dOko1LtJVN7FbPT2EJlPVCvoMg5lSOIF8pmElCQVVJm5KNTI9xWfPfQ7Cg4P7mwfgjWx5Qva7oJgVR9R7Tzm4pJq14JYXadmNwfWvf2n1tA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xeQOK3qiRrVpZYQ05CQ4Lq2+TNpCRxJTxsQh0yszmm8=;
 b=f4tV92CVNa1eotR4GqOd2j1RPJiCGBOTZTl/QueeghZ/MbdoSweHLmPqidCTE6GcD+aAGrlQcRaNXzkP67ni88fzIBH8APSBtCW8O2yTcRVw1rTwfxjJC++RDRtwfqvB07kNFSdls0p0zK9gJ4CPmFcuz0cZ5Cez1tXHg/uoDvjWA8RrLfqNnKkQv3Hkw0RKzzSzssxoTHeqwaqEuljxROoNZRjNT7D0BwQXStOaiv8tRapZvtQscdhnYfsMH9GDLMf6l31t2zPFeb11FmGet9W5zG/ZbwvfQuBqEvnjWIxu03bQUktzg8oUQbzMA1tUPm1iX85aizWPF8w2r9kDDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=analog.com; dmarc=pass action=none header.from=analog.com;
 dkim=pass header.d=analog.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xeQOK3qiRrVpZYQ05CQ4Lq2+TNpCRxJTxsQh0yszmm8=;
 b=NaHt8pkNokYpG4W3Sj8VZuXV1Evp+syJs7voD3Ft1lz3h3wNvEPS2FJProl8iL1MY0RGmTwWlsORYrM2Y5/tUOzN31iHtyqNYi8jm+edDstKd1PJfF8Xaj65vR1SAjWGhUCPhvChRw560ZfxkqY1bSImv7n0oy1mdYndEtcd/Ug=
Received: from SJ0PR03MB6359.namprd03.prod.outlook.com (2603:10b6:a03:399::5)
 by BY5PR03MB5299.namprd03.prod.outlook.com (2603:10b6:a03:229::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.22; Fri, 20 Aug
 2021 07:02:54 +0000
Received: from SJ0PR03MB6359.namprd03.prod.outlook.com
 ([fe80::a010:2cb7:9a3d:d930]) by SJ0PR03MB6359.namprd03.prod.outlook.com
 ([fe80::a010:2cb7:9a3d:d930%4]) with mapi id 15.20.4415.022; Fri, 20 Aug 2021
 07:02:54 +0000
From:   "Sa, Nuno" <Nuno.Sa@analog.com>
To:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>
CC:     Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH 01/16] iio: adc: max1027: Fix wrong shift with 12-bit
 devices
Thread-Topic: [PATCH 01/16] iio: adc: max1027: Fix wrong shift with 12-bit
 devices
Thread-Index: AQHXlCHWRHQAQcHDy0y8h6AXJV2iSat7+iZg
Date:   Fri, 20 Aug 2021 07:02:54 +0000
Message-ID: <SJ0PR03MB6359CD425BDE36688DC9265299C19@SJ0PR03MB6359.namprd03.prod.outlook.com>
References: <20210818111139.330636-1-miquel.raynal@bootlin.com>
 <20210818111139.330636-2-miquel.raynal@bootlin.com>
In-Reply-To: <20210818111139.330636-2-miquel.raynal@bootlin.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: =?utf-8?B?UEcxbGRHRStQR0YwSUc1dFBTSmliMlI1TG5SNGRDSWdjRDBpWXpwY2RYTmxj?=
 =?utf-8?B?bk5jYm5OaFhHRndjR1JoZEdGY2NtOWhiV2x1WjF3d09XUTRORGxpTmkwek1t?=
 =?utf-8?B?UXpMVFJoTkRBdE9EVmxaUzAyWWpnMFltRXlPV1V6TldKY2JYTm5jMXh0YzJj?=
 =?utf-8?B?dFlUTXdNalkxWldVdE1ERTROQzB4TVdWakxUaGlPRGN0WlRSaU9UZGhOMk5q?=
 =?utf-8?B?TnpFd1hHRnRaUzEwWlhOMFhHRXpNREkyTldZd0xUQXhPRFF0TVRGbFl5MDRZ?=
 =?utf-8?B?amczTFdVMFlqazNZVGRqWXpjeE1HSnZaSGt1ZEhoMElpQnplajBpTVRVd055?=
 =?utf-8?B?SWdkRDBpTVRNeU56TTVNVFkxTnpNME1EVTBNelV4SWlCb1BTSm1UMXBuU1VO?=
 =?utf-8?B?TWNWQTJVV04wV0drM1pITmFlVE0zYW5JMldHODlJaUJwWkQwaUlpQmliRDBp?=
 =?utf-8?B?TUNJZ1ltODlJakVpSUdOcFBTSmpRVUZCUVVWU1NGVXhVbE5TVlVaT1EyZFZR?=
 =?utf-8?B?VUZKV1VSQlFVUlFTMVo0Ykd0YVdGaEJaRXBMWldKWVVpOHZWbWN3YTNBMWRH?=
 =?utf-8?B?UklMemxYUVVaQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCU0VG?=
 =?utf-8?B?QlFVRkJWMEYzUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJSVUZC?=
 =?utf-8?B?VVVGQ1FVRkJRVUpQV1VkalowRkJRVUZCUVVGQlFVRkJRVUZCUVVvMFFVRkJR?=
 =?utf-8?B?bWhCUjFGQllWRkNaa0ZJVFVGYVVVSnFRVWhWUVdOblFteEJSamhCWTBGQ2VV?=
 =?utf-8?B?RkhPRUZoWjBKc1FVZE5RV1JCUW5wQlJqaEJXbWRDYUVGSGQwRmpkMEpzUVVZ?=
 =?utf-8?B?NFFWcG5RblpCU0UxQllWRkNNRUZIYTBGa1owSnNRVUZCUVVGQlFVRkJRVUZC?=
 =?utf-8?B?UVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJR?=
 =?utf-8?B?VUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFV?=
 =?utf-8?B?RkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkZRVUZCUVVGQlFVRkJRV2RCUVVG?=
 =?utf-8?B?QlFVRnVaMEZCUVVkRlFWcEJRbkJCUmpoQlkzZENiRUZIVFVGa1VVSjVRVWRW?=
 =?utf-8?B?UVZoM1FuZEJTRWxCWW5kQ2NVRkhWVUZaZDBJd1FVaE5RVmgzUWpCQlIydEJX?=
 =?utf-8?B?bEZDZVVGRVJVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFV?=
 =?utf-8?B?RkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVG?=
 =?utf-8?B?QlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZC?=
 =?utf-8?B?UVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCVVVGQlFVRkJR?=
 =?utf-8?B?VUZCUVVOQlFVRkJRVUZEWlVGQlFVRlpVVUpyUVVkclFWaDNRbnBCUjFWQldY?=
 =?utf-8?B?ZENNVUZJU1VGYVVVSm1RVWhCUVdOblFuWkJSMjlCV2xGQ2FrRklVVUZqZDBK?=
 =?utf-8?B?bVFVaFJRV0ZSUW14QlNFbEJUV2RCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZC?=
 =?utf-8?B?UVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJR?=
 =?utf-8?B?VUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFV?=
 =?utf-8?B?RkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVG?=
 =?utf-8?B?QlFrRkJRVUZCUVVGQlFVRkpRVUZCUVVGQlNqUkJRVUZDYUVGSVNVRmhVVUpv?=
 =?utf-8?B?UVVZNFFWcEJRbkJCUjAxQlpFRkNjRUZIT0VGaVowSm9RVWhKUVdWUlFtWkJT?=
 =?utf-8?B?RkZCWVZGQ2JFRklTVUZOVVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFV?=
 =?utf-8?B?RkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVG?=
 =?utf-8?B?QlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZC?=
 =?utf-8?B?UVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJR?=
 =?utf-8?B?VUZCUVVGQlFVRkJRVVZCUVVGQlFVRkJRVUZCWjBGQlFVRkJRVzVuUVVGQlIw?=
 =?utf-8?B?VkJZMmRDY0VGSFJVRllkMEpyUVVkclFWbDNRakJCUjJ0QlluZENkVUZIUlVG?=
 =?utf-8?B?alowSTFRVVk0UVdSQlFuQkJSMVZCWTJkQmVVRkJRVUZCUVVGQlFVRkJRVUZC?=
 =?utf-8?B?UVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJR?=
 =?utf-8?B?VUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFV?=
 =?utf-8?B?RkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVG?=
 =?utf-8?B?QlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGUlFVRkJRVUZCUVVGQlEwRkJRVUZC?=
 =?utf-8?B?UVVFOUlpOCtQQzl0WlhSaFBnPT0=?=
x-dg-rorf: true
authentication-results: bootlin.com; dkim=none (message not signed)
 header.d=none;bootlin.com; dmarc=none action=none header.from=analog.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 663eb225-bb12-4dda-106d-08d963a888c0
x-ms-traffictypediagnostic: BY5PR03MB5299:
x-microsoft-antispam-prvs: <BY5PR03MB52999570DDC0E9CFA6EC27B999C19@BY5PR03MB5299.namprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:459;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rB7gHHQKtfDnUytYhAb3Xd5Sk3tqboXHmEOD88yZmqn9cQawhxjLjg3kMITNjQQreJHHzuCuzSktfe/Ww2BDrtPeyTTd1tTVzVTVEa+H8QLv/WfKQurLoyCoHnQmQelv9XydKOJTpvylH5D47EdSYbkRcqOQymJEWM+H+91s7Sc4NX4S+JxsIrZIBhE2OI1qIguH34Dv9MtIstaj5f+dKTDLcngn7swF6doFifIYAciK/cWrVSjNIoTOOWGeRFyhG8LUl2V3X8UCR/JHfE81LDe4FMVY07vDYcUjDOyCTiER8ChRyWfPrV+jI2CL1AYzMrnNrsE/f22SGElFPWEi4zckt6YDIN3Pz43TZtdpWaa88tiFtta/XI9H156YU0Ean446H6bGCu853srwrC7q5AcSEHsLEG284WP4CzDnLHkI97wdjJwRBzXOB+GuSgh8zwW8pW/aNaf6Tzbt3qC9ZWzOA7vm2JGp/7Qtj4DTCxXsOPhgCFvw02nsdykMRisBo6U6FuEfEuAbt6UHc36YWFBSndKQ6iqJWGV92Kl5RyRhZu4104yzQjYiioQBtlHDVSyHDmiJ6Mo7iBwzJTZCpHT8inBMp99+TwbAzvy7+pPYwaMoQWU8lAYgVkuHtWo0xA3ThFlzqu0s0r2Y9Bg8GK1F/a9XDVVkyR6vI0exyfSf2++/4tl+KVGWWKN1uxt1jXhUdLfFZJvj9P4Me6Nw+A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR03MB6359.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39850400004)(376002)(346002)(136003)(366004)(38070700005)(9686003)(7696005)(86362001)(76116006)(110136005)(6506007)(316002)(8676002)(186003)(2906002)(4326008)(71200400001)(38100700002)(52536014)(53546011)(55016002)(54906003)(478600001)(66556008)(66946007)(8936002)(66476007)(26005)(66446008)(64756008)(33656002)(83380400001)(5660300002)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OUoxcTd0L0M3c3l5WFVBdTZMSjd1a0VmY0dEYW15SkE0czZmeGFUcHEveExY?=
 =?utf-8?B?SENmcU1ZN1pwUGY0dkVLblpINDZLc2FVVVh4QktNS1M2bXVUczhKQS80Y04v?=
 =?utf-8?B?OWdOWTlBbGFPNGt6WHRoRENxWm0xTW92WndaK3MySHlESDVFWmJoQ2xUUHdZ?=
 =?utf-8?B?Y09HMG42Y1pUNFNaWHl0eklBZDB1cmhucUlJaVhnQ29iaVozeEhrWGlNYklD?=
 =?utf-8?B?ODBMaUg1cHJUOWdpZG40SVZQQkJ0K2x3NHpKRlJQQ0ZiSDNUNjBUVHU1ZS9I?=
 =?utf-8?B?ZEorQ2I4dWt1d3N3WHYwaVY1eFlRckpCYklWUTA5eUpra1RSdWZnVlVFNVRZ?=
 =?utf-8?B?V1VaSHJ3SFhtZ292MmpVOGx4TkprVVd2RlgxQTB0MFAyNVBWTE1hS3U4NG54?=
 =?utf-8?B?cUxPSVBvUzVscWtHc29naXhhRWtwOHN6c2VVcVAvekJpZWVPOGZ6VWo1c3JQ?=
 =?utf-8?B?aVBiSzZmL2hTbWx2YngzL01zdUtjVitYbk14V3lXTkxtcFZuaEFvUjN4cFFt?=
 =?utf-8?B?b2VVOHhOWW5zYVhybEFUQU1TMW5wRGJaMGdHNHYwS2E2S0xhQmZmRVEyVmxu?=
 =?utf-8?B?b21QKzNSTXU1U0hNd0x1YVhnNHZyYmlMalJoaXlKeE1rdkxvcUU0ZGZLSG5i?=
 =?utf-8?B?WnNMSndhTEo5bEJsb0hicUFkRy9iRURVenZ2Z1p2UkdvWE5iSzVLcndYZUhU?=
 =?utf-8?B?R1BGU200dE84bmlSNUNpNm14eGt3SE5LOGs0RlRxbGFodURnakVzS1FlenVp?=
 =?utf-8?B?SWp3N2h2SHJhYUN0MTZKVjlYRnZ0Qk85WG1BR0EwNUY2WUkzRnp3cVMxOEsx?=
 =?utf-8?B?WlpTZ0lYaXV5ek0rd1hxMCtpcis4VTFRTU1VbTVXRFVTWHpwMHJGaytSRFNW?=
 =?utf-8?B?ODRyWlYwOWZESHZqT05tNzVXVTZlWTJLQm1NQklVbGsycnR5aGJJRjNMYmJj?=
 =?utf-8?B?by9pb0tFVEI5K2FGQzNWYW5nYmxCd1RNSjcrV3haWGhzd28wTHBmYVNjYmdn?=
 =?utf-8?B?Z3drZHFZTmQzK2VBWE5QTWEzQkJPZ2VMQ0ZFcFQxdW1YZXp2ZThibHJPeENW?=
 =?utf-8?B?NTEra0Y3R3hJZkRmNGptdUxySEJueDNxWmg0RkR3eVdmc2FhVHpCTGFEWDhy?=
 =?utf-8?B?QUIxREFGQzBCMnFkeklQTEtpZ0Uva2pOaW5LYjdUUFIxRHRBWWNzQmNQalJL?=
 =?utf-8?B?ZVNwbTdQWFZINmRPcm95WmF3RVNMZjBCYjY3MUYxQ0pXdG9XS1FlcjlxQnp2?=
 =?utf-8?B?QVRXSjBUeVVSdTgyUWhEdXhnKy9QT21xa1UwcC81aTFNNG12WEJ5NHAwQ3ZG?=
 =?utf-8?B?NTNuV3FncDFpZFlxWkhpS0FMZzQzS09Rb2orU0hFbzFZRDlpclF5NG8zdWJU?=
 =?utf-8?B?Z2hjc2lkQ29BMjhmTTlJcVQ4OXQwM0d4NjdkM0tEaFdxVHlOMVoza0ZCa0JH?=
 =?utf-8?B?b0lNQ2RIV0YrYU9MWVM3UFJ6K2xoVStlaFQxdGFMazh5MmNNUWJPUnlBMGpV?=
 =?utf-8?B?YUJYZzcyVzRVNm1COHlBVEloR0JsKytJZ3UyODBwOGlqUHJ5VzhyS3c4QU10?=
 =?utf-8?B?VkRyTHUzVWthNjh4eFlHaDlDNjN6amhkMFA0d0kzTEREek16YVFxTXhTN3hk?=
 =?utf-8?B?K2RjbjF6WGovSXd6b1NBZEFXQWtrQzhMa2VBQ2d3WmQyUEFxUWdKTGpnYWRT?=
 =?utf-8?B?RkphY1preHJuWVYvTm5lbllUYWZrVnZGczhJcXZyelB0MU9FNWtrMVQrYVlr?=
 =?utf-8?Q?aQU20KcizVF/Nf8IV6w3G6m5ybLr7NeK/kO8c67?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR03MB6359.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 663eb225-bb12-4dda-106d-08d963a888c0
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Aug 2021 07:02:54.8902
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6+H9BjG2PnE1jArTCSmg5Du/sLpI/OOyc+xBisuNymPhCwI403rdWcAzsapMT/u0idPJv3PAhm3ZODCdlmM5uA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR03MB5299
X-Proofpoint-ORIG-GUID: b8kqME5CrlxL2e55sRLQIQiu-0DsS-_H
X-Proofpoint-GUID: b8kqME5CrlxL2e55sRLQIQiu-0DsS-_H
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-20_02,2021-08-20_03,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 spamscore=0
 mlxlogscore=999 impostorscore=0 mlxscore=0 phishscore=0 bulkscore=0
 clxscore=1011 lowpriorityscore=0 priorityscore=1501 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108200040
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogTWlxdWVsIFJheW5hbCA8
bWlxdWVsLnJheW5hbEBib290bGluLmNvbT4NCj4gU2VudDogV2VkbmVzZGF5LCBBdWd1c3QgMTgs
IDIwMjEgMToxMSBQTQ0KPiBUbzogSm9uYXRoYW4gQ2FtZXJvbiA8amljMjNAa2VybmVsLm9yZz47
IExhcnMtUGV0ZXIgQ2xhdXNlbg0KPiA8bGFyc0BtZXRhZm9vLmRlPg0KPiBDYzogVGhvbWFzIFBl
dGF6em9uaSA8dGhvbWFzLnBldGF6em9uaUBib290bGluLmNvbT47IGxpbnV4LQ0KPiBpaW9Admdl
ci5rZXJuZWwub3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBNaXF1ZWwgUmF5bmFs
DQo+IDxtaXF1ZWwucmF5bmFsQGJvb3RsaW4uY29tPjsgc3RhYmxlQHZnZXIua2VybmVsLm9yZw0K
PiBTdWJqZWN0OiBbUEFUQ0ggMDEvMTZdIGlpbzogYWRjOiBtYXgxMDI3OiBGaXggd3Jvbmcgc2hp
ZnQgd2l0aCAxMi1iaXQNCj4gZGV2aWNlcw0KPiANCj4gW0V4dGVybmFsXQ0KPiANCj4gMTAtYml0
IGRldmljZXMgbXVzdCBzaGlmdCB0aGUgdmFsdWUgdHdpY2UuDQo+IFRoaXMgaXMgbm90IG5lZWRl
ZCBhbnltb3JlIG9uIDEyLWJpdCBkZXZpY2VzLg0KPiANCj4gRml4ZXM6IGFlNDdkMDA5YjUwOCAo
ImlpbzogYWRjOiBtYXgxMDI3OiBJbnRyb2R1Y2UgMTItYml0IGRldmljZXMNCj4gc3VwcG9ydCIp
DQo+IENjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnDQo+IFNpZ25lZC1vZmYtYnk6IE1pcXVlbCBS
YXluYWwgPG1pcXVlbC5yYXluYWxAYm9vdGxpbi5jb20+DQo+IC0tLQ0KPiAgZHJpdmVycy9paW8v
YWRjL21heDEwMjcuYyB8IDIgKy0NCj4gIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwg
MSBkZWxldGlvbigtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvaWlvL2FkYy9tYXgxMDI3
LmMgYi9kcml2ZXJzL2lpby9hZGMvbWF4MTAyNy5jDQo+IGluZGV4IDY1NWFiMDJkMDNkOC4uNGE0
MmQxNDBhNGIwIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL2lpby9hZGMvbWF4MTAyNy5jDQo+ICsr
KyBiL2RyaXZlcnMvaWlvL2FkYy9tYXgxMDI3LmMNCj4gQEAgLTEwMyw3ICsxMDMsNyBAQCBNT0RV
TEVfREVWSUNFX1RBQkxFKG9mLA0KPiBtYXgxMDI3X2FkY19kdF9pZHMpOw0KPiAgCQkJLnNpZ24g
PSAndScsCQkJCQlcDQo+ICAJCQkucmVhbGJpdHMgPSBkZXB0aCwJCQkJXA0KPiAgCQkJLnN0b3Jh
Z2ViaXRzID0gMTYsCQkJCVwNCj4gLQkJCS5zaGlmdCA9IDIsCQkJCQlcDQo+ICsJCQkuc2hpZnQg
PSAoZGVwdGggPT0gMTApID8gMiA6IDAsCQkJXA0KPiAgCQkJLmVuZGlhbm5lc3MgPSBJSU9fQkUs
CQkJCVwNCj4gIAkJfSwJCQkJCQkJXA0KPiAgCX0NCj4gLS0NCj4gMi4yNy4wDQoNClJldmlld2Vk
LWJ5OiBOdW5vIFPDoSA8bnVuby5zYUBhbmFsb2cuY29tPg0KDQo=
