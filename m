Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAA963F2740
	for <lists+stable@lfdr.de>; Fri, 20 Aug 2021 09:04:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235318AbhHTHEd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Aug 2021 03:04:33 -0400
Received: from mx0b-00128a01.pphosted.com ([148.163.139.77]:59064 "EHLO
        mx0b-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235172AbhHTHEc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Aug 2021 03:04:32 -0400
Received: from pps.filterd (m0167091.ppops.net [127.0.0.1])
        by mx0b-00128a01.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17JJnoR7022418;
        Fri, 20 Aug 2021 03:03:42 -0400
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2105.outbound.protection.outlook.com [104.47.55.105])
        by mx0b-00128a01.pphosted.com with ESMTP id 3ahka2nmbb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 20 Aug 2021 03:03:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CHl+RvPlMhPIITmBYMY3txDMRdWIx75nvi52urzfZSntTAbDolgHjtHlaS1TpwpKsCRe3AdroE3e04I5ELn8u0LlXsfr1hdAImnVcM8mbSbw20to+pIXjZ+yJXj2hEQart66MUqzDhbFyYhQmUFPQQ0EPYlx+RBLgIRfuXWEGW5MEIEUCMoset9vOTcCtju8yixgj2jE0tnN/0g7i/AOCdM68E1NgnXX+9ayqAPnN40CuvXB5RXxtqXpYASXqBu0ZIQfrXJ6JQe7u5uOAAOVCo+EH6rqroIcG+g3lz1Su/rAXQEhkyCGm4vDFW7WbyryZfxGmj1QkuSsPI+NsCygBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7yIHky1apNFRho6Y5mHVJzBrrzQ36lnOmPerXhZvCiw=;
 b=gOGadIs2KjtirLm/4teUcAxruN1TnlQ+UkEU2zQrwhG6dXIsjWTGEou/uDrQe8u12gLNLCYXG6Lda5xspXSm/Zr/GhgUi/qGaf/VQcPEyVJhJNXj/Vs8U3KAt41GO25RbkoeTehbM0jdqsjSUNCkLXSzdV65mqCFxVQgM/ylQ3M9jE3yMZlbm4aOk2PZVANxr5N7rHXc8J6IUVrAZIpSNgJhvvNOCDCW2Sa0smzePUSTpHAZsLIZz7VeLThMUawKcwuyWLYGZN4aaQEO+MlKP3MefXSNpN6muBK00DF6ns6flpgr+yxxPD0hlispqoP9Dw8HibBk5VOok8VwRm4meA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=analog.com; dmarc=pass action=none header.from=analog.com;
 dkim=pass header.d=analog.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7yIHky1apNFRho6Y5mHVJzBrrzQ36lnOmPerXhZvCiw=;
 b=ilUomkOiU2uUWOazBPDBftuhrUFdUHfVlY4z6JWWOi8tEK8oc8ChmBsPoRsWc0nNkhO1JFbSiI6WvpGlkUxjry3qoNhVLuvWjy5hioVdZumpPBMV3VqIRIrQsejHYVffhIVr76utbAKf5c7FsYBTGeRY7AkWJXm/AI4LHoOabv8=
Received: from SJ0PR03MB6359.namprd03.prod.outlook.com (2603:10b6:a03:399::5)
 by BY5PR03MB5299.namprd03.prod.outlook.com (2603:10b6:a03:229::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.22; Fri, 20 Aug
 2021 07:03:40 +0000
Received: from SJ0PR03MB6359.namprd03.prod.outlook.com
 ([fe80::a010:2cb7:9a3d:d930]) by SJ0PR03MB6359.namprd03.prod.outlook.com
 ([fe80::a010:2cb7:9a3d:d930%4]) with mapi id 15.20.4415.022; Fri, 20 Aug 2021
 07:03:40 +0000
From:   "Sa, Nuno" <Nuno.Sa@analog.com>
To:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>
CC:     Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH 02/16] iio: adc: max1027: Fix the number of max1X31
 channels
Thread-Topic: [PATCH 02/16] iio: adc: max1027: Fix the number of max1X31
 channels
Thread-Index: AQHXlCHW9kyU8lZNUkqP0z3km2MNLat7+rdA
Date:   Fri, 20 Aug 2021 07:03:40 +0000
Message-ID: <SJ0PR03MB63596A655409A24A442977F199C19@SJ0PR03MB6359.namprd03.prod.outlook.com>
References: <20210818111139.330636-1-miquel.raynal@bootlin.com>
 <20210818111139.330636-3-miquel.raynal@bootlin.com>
In-Reply-To: <20210818111139.330636-3-miquel.raynal@bootlin.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: =?utf-8?B?UEcxbGRHRStQR0YwSUc1dFBTSmliMlI1TG5SNGRDSWdjRDBpWXpwY2RYTmxj?=
 =?utf-8?B?bk5jYm5OaFhHRndjR1JoZEdGY2NtOWhiV2x1WjF3d09XUTRORGxpTmkwek1t?=
 =?utf-8?B?UXpMVFJoTkRBdE9EVmxaUzAyWWpnMFltRXlPV1V6TldKY2JYTm5jMXh0YzJj?=
 =?utf-8?B?dFltVXhZVE0xTlRZdE1ERTROQzB4TVdWakxUaGlPRGN0WlRSaU9UZGhOMk5q?=
 =?utf-8?B?TnpFd1hHRnRaUzEwWlhOMFhHSmxNV0V6TlRVNExUQXhPRFF0TVRGbFl5MDRZ?=
 =?utf-8?B?amczTFdVMFlqazNZVGRqWXpjeE1HSnZaSGt1ZEhoMElpQnplajBpTVRZNE9D?=
 =?utf-8?B?SWdkRDBpTVRNeU56TTVNVFkyTVRnNE5qQTRPRFkwSWlCb1BTSmFWbEU0V0hs?=
 =?utf-8?B?WFZuaFpkMmt5VkRSUE5FTlFiMWRhZWxCblpWRTlJaUJwWkQwaUlpQmliRDBp?=
 =?utf-8?B?TUNJZ1ltODlJakVpSUdOcFBTSmpRVUZCUVVWU1NGVXhVbE5TVlVaT1EyZFZR?=
 =?utf-8?B?VUZKV1VSQlFVSm5TRmhUUVd0YVdGaEJXV2hzY0hSMFZESlBWVU5wUjFkdE1q?=
 =?utf-8?B?RlFXVFZSU1VaQlFVRkJRVUZCUVVGQlFVRkJRVUZCUVVGQlFVRkJRVUZCU0VG?=
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
x-ms-office365-filtering-correlation-id: db507ebb-b49d-4345-85cf-08d963a8a3c1
x-ms-traffictypediagnostic: BY5PR03MB5299:
x-microsoft-antispam-prvs: <BY5PR03MB52993F352327EE04A1B2576C99C19@BY5PR03MB5299.namprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3631;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wTmC9OZppEzUIhVPvF8YVk53hAKfe9Y3BzOONFrwtBktgayLEDVQimMXpc2/vMa41jKaJp827dddpWUoTnsiXDkUuG75IWpZ3tFmvcU2VSnOaTui+iBJSpUmqTI+XvaL4Bgm6I4/l5d1kWeeFtK2zQpGTspWmbOYAOUY3wOrZvfpc1V5ppDBYiAMtYgCNrkckeYY0xYlZFiaGfMuU6XW5OYmG7iVJQYMiptQHhHA52ph2No6WZ2uWlW7iwvfJcakRqS09EZWJLRm36CmRMiPgnmcSk8Q+Zkg4u4ojmPf+793PVlgcuzpazd3zWtbj+JIrSmu4gmN0LURpzrNE1cj2CXR1fMF/4AtNEES3kMv0Oz+6HhcnfbtXajldmMn64iqSWp4GnbOj95wwtMfu0ui3ClCM7CP4nUsAphlY/79MeUNBzQBzsdwAB8SZcScDo3c+/GpeetGRMmo7v2zrA4fwOBJOzGrPVJVP7Fodo5rljeJBFPG89eURnt8h30isFJhMXmZtvINy3NXbmVzqy7OsObyHVrQdrfi1iOtu+5v7Vrb17oNmgtpguqR+kfsEs5OcNGWd7wcKg697mqGdSsxffPglAgEEOaxWTR8WWRC8WSleqifajeWaRtomOez+Nu83nma3S0OU8Rkl85zRqE1vmjrzeveU9/XjoPq3tgVKNTFEVaJ87g//h9Yt4dHNIUq53NBaZEX/6PuKF4EyjivYA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR03MB6359.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39850400004)(376002)(346002)(136003)(366004)(38070700005)(9686003)(7696005)(86362001)(76116006)(110136005)(6506007)(316002)(8676002)(186003)(2906002)(4326008)(71200400001)(38100700002)(52536014)(53546011)(55016002)(54906003)(478600001)(66556008)(66946007)(8936002)(66476007)(26005)(66446008)(64756008)(33656002)(83380400001)(5660300002)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?c2FkcGtUODJtSFQxOHNVT0k1QVl2WVdlVHlGQ0lYRW9UMU95bWhzclVvbURR?=
 =?utf-8?B?MUw1UnRXS2hsTFBNTy9qMTdXU0picGlhY2JGa1NHaTNRek9mRER3QXcyL0xS?=
 =?utf-8?B?WW95QTA0aXBiVEt1cUNkYUM5bkhiNWwvZEt2ei82MkhPb0VGZFNOSHp5VmlB?=
 =?utf-8?B?R0dDeVlZaUdzS0FFSFA1T0xrejVxdlBIb0ZxUUtIRHBFa0FZeCtKNGhnMXJ0?=
 =?utf-8?B?elJrUGdaNi8wNXduazV0ZWFIYS9kVjVOWWFRM24zZHNTNzRUQnNYSmE1WFp3?=
 =?utf-8?B?MlhnT1BCYkxyWDdreC9BWVBjR2p2VHNhY1BIbGRCSDJnV2o2WDQxM28rUUIr?=
 =?utf-8?B?d05rZnRoTURNeXpJZTQzK0tOcHpESXZsYkcxUFY3d0hZK2xZdVBRYjhUUHdM?=
 =?utf-8?B?cHB4b0VIZ1p1dVpIOGx1cytoSFlrdEQ2TmJqT0xqSGxYdlZEZG05Z1FJRm5J?=
 =?utf-8?B?bW9FeW9XU1QyZ3V3cFdiOWtidE1QZjdHRmtodnJqVk9MNXJwbUZVR3Y4aWln?=
 =?utf-8?B?N21pc29hMk5rN1V1V28zdENKQ3VxWm5ZNWZPdG8wY1FESHJzRWdzV2UzOXNz?=
 =?utf-8?B?b0xVMmtrV3k3NGxCMHRIZURLc25WbWFWNWxuSVErOHMvM2NkY3Z1L0xQd2wy?=
 =?utf-8?B?bXRibG05U0J6OVE5d3RTdFNVN09Xd1pUSzU4aExYMmp1N2Nvd09heFJFKzZS?=
 =?utf-8?B?eisvNzJGbFFqb0FWcHA3eFBZTERNZENLTC8rK2pUZ3Z6QTU5bzQ1RHBhbjF4?=
 =?utf-8?B?dE5GVUYxMEk4UWVYVDNrTVM2V2JIY3ZGd2VIK0ZrWmZPd0JTSWVhblFzbmpB?=
 =?utf-8?B?aCtqYkFiM1hYaTN5VHcySVVmZUdlalFQWFhlUjFSYXZudXFRa0o1UGI4eHo4?=
 =?utf-8?B?bHB0aWRIc0EzRkc0bndJODVTbXFPZERURkMzWldhZHJoRC9ubU9PRWhEaWdR?=
 =?utf-8?B?dmRkL2laUWhtZWFSVVBtZGNMbTZVZ0V2ajhHSXVVUUhjRU51VTBtTzRVeGhl?=
 =?utf-8?B?ZGJrVVd3ZFlGSDlFMkJPc253dU5NdDk3eG00WThCMUNxSEtSM2pCeEdGQVov?=
 =?utf-8?B?elVzc21FejBXWHkyMVZlMW8yTnBOWC9Ud0RpWTI5ZEN2clN3emx3NW5oUkFQ?=
 =?utf-8?B?NEF4Q28rTTBXWnZIaGZnOFV4SzJKMFYwaHpEeFlMbk9rRjM0cWI3STRIY1VL?=
 =?utf-8?B?VEFsemxqRlM2NDR5ZFZIMVQ0QVJFa2FpSVJjVk1CSFdoendkR2RQR294MHZi?=
 =?utf-8?B?bTRISEdBbFN0OTdLMEZFU1pzQ1FId3ByaUhrcVozWkJjQ3lHS01sdXlRWUJz?=
 =?utf-8?B?dk1rZ3FIek9TK1NDT25QTldIV3R3OStRTmMvUGlxOEFyK0pCUnlESTJQMGw4?=
 =?utf-8?B?U1VWQktYeUVIcGF1U1RWZWdCcHc5RTJZNitHeHl6bld2SUxXdytGeUVlbzZP?=
 =?utf-8?B?VW9ZRHk1aVk0cXhOZjc2L2pucU5oa2ZDbTlJWStnSUx5YmJXRExITjRseHpW?=
 =?utf-8?B?M2NRVXB5NzFRSEh5V0lxNVpRUGlnbWFZYk05bjdCbHdnY2IyenlSU2ZSS0RJ?=
 =?utf-8?B?ZFB5ejdvN2lIZDZXUFNhV2hzYi9qY3J3SHM4clNDTmRjYlRWOXNQbGdmQUFD?=
 =?utf-8?B?djl2L0JvV1R5RVZsTC9kQ3BjZlR0VVRVVkF4VDdBaEl6TFNLdjlSQjdtM1hj?=
 =?utf-8?B?SG9zT2JPYXBPSldvSUNWOCtQL1I4eW16TVlZeG01YWNLczhNemUwY1lRdFY5?=
 =?utf-8?Q?9Kmj2U0MmzRTWCPyaM=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR03MB6359.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db507ebb-b49d-4345-85cf-08d963a8a3c1
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Aug 2021 07:03:40.2441
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NmL8ODLb+tKuQocBxuy+5y2PBza+At/CJRrEV+0ZE+pHuzErmzxUS/w8V8heV21ehmnfiMTlAduNhefq9BWSgg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR03MB5299
X-Proofpoint-ORIG-GUID: VoEjlGODeoN8ZMYHpb0sb3_TUP7VGQif
X-Proofpoint-GUID: VoEjlGODeoN8ZMYHpb0sb3_TUP7VGQif
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-20_02,2021-08-20_03,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 mlxlogscore=867 clxscore=1015 adultscore=0 bulkscore=0 mlxscore=0
 suspectscore=0 spamscore=0 phishscore=0 impostorscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
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
PiBTdWJqZWN0OiBbUEFUQ0ggMDIvMTZdIGlpbzogYWRjOiBtYXgxMDI3OiBGaXggdGhlIG51bWJl
ciBvZiBtYXgxWDMxDQo+IGNoYW5uZWxzDQo+IA0KPiBbRXh0ZXJuYWxdDQo+IA0KPiBUaGUgbWFj
cm8gTUFYMVgyOV9DSEFOTkVMUygpIGFscmVhZHkgY2FsbHMNCj4gTUFYMVgyN19DSEFOTkVMUygp
Lg0KPiBDYWxsaW5nIE1BWDFYMjdfQ0hBTk5FTFMoKSBiZWZvcmUgTUFYMVgyOV9DSEFOTkVMUygp
IGluIHRoZQ0KPiBkZWZpbml0aW9uDQo+IG9mIE1BWDFYMzFfQ0hBTk5FTFMoKSBkZWNsYXJlcyB0
aGUgZmlyc3QgOCBjaGFubmVscyB0d2ljZS4gU28gZHJvcA0KPiB0aGlzDQo+IGV4dHJhIGNhbGwg
ZnJvbSB0aGUgTUFYMVgzMSBjaGFubmVscyBsaXN0IGRlZmluaXRpb24uDQo+IA0KPiBGaXhlczog
N2FmNTI1N2Q4NDI3ICgiaWlvOiBhZGM6IG1heDEwMjc6IFByZXBhcmUgdGhlIGludHJvZHVjdGlv
biBvZg0KPiBkaWZmZXJlbnQgcmVzb2x1dGlvbnMiKQ0KPiBDYzogc3RhYmxlQHZnZXIua2VybmVs
Lm9yZw0KPiBTaWduZWQtb2ZmLWJ5OiBNaXF1ZWwgUmF5bmFsIDxtaXF1ZWwucmF5bmFsQGJvb3Rs
aW4uY29tPg0KPiAtLS0NCj4gIGRyaXZlcnMvaWlvL2FkYy9tYXgxMDI3LmMgfCAxIC0NCj4gIDEg
ZmlsZSBjaGFuZ2VkLCAxIGRlbGV0aW9uKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9p
aW8vYWRjL21heDEwMjcuYyBiL2RyaXZlcnMvaWlvL2FkYy9tYXgxMDI3LmMNCj4gaW5kZXggNGE0
MmQxNDBhNGIwLi5iNzUzNjU4YmI0MWUgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvaWlvL2FkYy9t
YXgxMDI3LmMNCj4gKysrIGIvZHJpdmVycy9paW8vYWRjL21heDEwMjcuYw0KPiBAQCAtMTQyLDcg
KzE0Miw2IEBAIE1PRFVMRV9ERVZJQ0VfVEFCTEUob2YsDQo+IG1heDEwMjdfYWRjX2R0X2lkcyk7
DQo+ICAJTUFYMTAyN19WX0NIQU4oMTEsIGRlcHRoKQ0KPiANCj4gICNkZWZpbmUgTUFYMVgzMV9D
SEFOTkVMUyhkZXB0aCkJCQlcDQo+IC0JTUFYMVgyN19DSEFOTkVMUyhkZXB0aCksCQlcDQo+ICAJ
TUFYMVgyOV9DSEFOTkVMUyhkZXB0aCksCQlcDQo+ICAJTUFYMTAyN19WX0NIQU4oMTIsIGRlcHRo
KSwJCVwNCj4gIAlNQVgxMDI3X1ZfQ0hBTigxMywgZGVwdGgpLAkJXA0KPiAtLQ0KPiAyLjI3LjAN
Cg0KUmV2aWV3ZWQtYnk6IE51bm8gU8OhIDxudW5vLnNhQGFuYWxvZy5jb20+DQoNCg==
