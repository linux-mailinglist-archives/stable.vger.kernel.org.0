Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77CEA29E1C1
	for <lists+stable@lfdr.de>; Thu, 29 Oct 2020 03:03:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729048AbgJ2CDE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Oct 2020 22:03:04 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:42463 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727903AbgJ1Vsn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Oct 2020 17:48:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1603921722; x=1635457722;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=SHatl5wKLhbJ1HTEYcwsngnXnHrZQwgmxwifuFPenoY=;
  b=DqEN+Mr+THv5gUMtdadmlB2lZ9CC4Y/BzM/EiSs0ADSuPyW+uHcebW1I
   szI2yo+CDxWlZr2RIifYjBdWU5LXI4gsfxyjQ3klPHWFVWbv1eIU5ki6O
   O/h/WdAjTQu4mJQsLKmKao9jOp8dQ5Sut1toE5GFsUAwtMHUIozgMKa2b
   7ewfWMC6pVLEJpmUnviZdjqvWFHm6sTyxOi30aDWTzwH49mjqvppkjwMR
   Rh+BaQN64ZeuIlqObnoEM5WPA1u7pqFOpv/621LAOxoStDBh53EwsH/WT
   P3dCFAA/DF11of9uuBfy4BFdSOwb4gPkzEbCn3zcVzIorG1wvVXtaklcO
   Q==;
IronPort-SDR: eQucXinzePyv54C/qXbWVHbmr7WyRTpWwVXHp7SwwyatGxBALKCrLZpHoOCC+HZ+7w/k8YmE0O
 RKwRh0BCUj8ZXKqjd1i9RWHB0yHpj0gkA9aU+UGEYBhwar87a0USUzDBw001zAitq0V/s6G9Df
 AVQn4VtWdGMdfMNvL67ERQEvPFRkxeLJae0V0ckVJIFgNMQPIjPGy2VTStqn+Dw/G+fubTC0iC
 v0o6KGJC5R0pSWx3S4LCZ8ChEcHBF5/FagzCXhW5FWHZAUqlDxCmFGjamRhXi8mgA3FD+Zg1sU
 ZJc=
X-IronPort-AV: E=Sophos;i="5.77,425,1596470400"; 
   d="scan'208";a="151169949"
Received: from mail-dm6nam10lp2101.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.101])
  by ob1.hgst.iphmx.com with ESMTP; 28 Oct 2020 16:45:07 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C/AciDJZoe8xPVJ7wX1Yrdru5AkvigpzqfivXwO+ucJb72WF2Je5+6ZoG/gTIq5W6wzqjHth9kz9FcET6gZbZA/XgKXMyzgaTeUZb9VwSCaweWnTQ9fgDxk9n0dNbDF7BoUqUK7XDwx8/s6n/E/2xMKR2AES0F6M/BvR6ZrJ3sqQZ4xMoC0tMH/zxRwvAlu7Exmm+3QBZII5QaMHFbHHE4emJHdkuot2z58WpU06YLPXkuaXe8ntmlAB9zBkvJC9UhuFQhbzOhNnYLchcI+f178Mp+WQEuUZjrdJWnBSX/7ygvgCFDNmLrj6jmrAIsPDLtPFx76pgP52CX4YSC7jlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SHatl5wKLhbJ1HTEYcwsngnXnHrZQwgmxwifuFPenoY=;
 b=oDPfWQDfjuj6A2ap3RhWilF8HQsZWd3ubbEw0gYE8CDoLwT6jebVUrfCWKHmz595hsWKMt9MY5/EgZLhQMH1jNstFln7tef7F8C0IMgwUeiQsfM/nTS223XIg8ICC6AdvQ34+ZSHG8iyCZl+yjzUqMozG1Q6JIhlqol3CwkPQSDwbE+5uKgFAjHMmJ1JZ2o0FuLSBJ8edHoYndXWW5P/tfxCHIx72438mOj1tDAgc9+qbQ0XCtKjeiKRrjH7I8sOvwexsVzlqcZFXMQvxFWsPjTDb2kLtDh9Iocm/FTTBdrkoeEvsMWIKy1S72cIEwmoqJclSdobycFE+uxsypyQew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SHatl5wKLhbJ1HTEYcwsngnXnHrZQwgmxwifuFPenoY=;
 b=JI9PUKbZtpQPaOfGku4fDm+ySg9kUUoTlFxt1UsPsONZfPI4/OtqEBOAz4kxO+mOTDlwVWK3grz+5K91gTZhVtWlnHhQ3816xc3AXOyUg+jrVz9oSyuv+7zzOIxCBend3rjc/oQCm3mis7rl0l6EjL0y5/qTpQaBmcxNNyIa7Xc=
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 (2603:10b6:803:47::21) by SA0PR04MB7420.namprd04.prod.outlook.com
 (2603:10b6:806:e8::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Wed, 28 Oct
 2020 08:45:05 +0000
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::619a:567c:d053:ce25]) by SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::619a:567c:d053:ce25%6]) with mapi id 15.20.3477.028; Wed, 28 Oct 2020
 08:45:05 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Naohiro Aota <Naohiro.Aota@wdc.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
CC:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] block: advance iov_iter on bio_add_hw_page failure
Thread-Topic: [PATCH] block: advance iov_iter on bio_add_hw_page failure
Thread-Index: AQHWrPuN5bEkPswN00253WdAP7+4zQ==
Date:   Wed, 28 Oct 2020 08:45:05 +0000
Message-ID: <SN4PR0401MB3598F35451C8A3A8D9719A009B170@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <7e91d39fccbd06efdee40ad119833dbfeafd2fb7.1603868801.git.naohiro.aota@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2001:a62:14ff:e901:156e:c9ac:ebdd:d314]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: ccba5323-1090-430c-3bd2-08d87b1dc47a
x-ms-traffictypediagnostic: SA0PR04MB7420:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA0PR04MB74202D79DA6C15519E6C4AF59B170@SA0PR04MB7420.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2803;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LXyrODMq6+eRNVa0GtN/23tk752zc4xkAzRIIL+l5XAmCNvsZv9V5ATg7O7FfJ9Rby+Wa4eKcw+slCNw0AC0U7uE8d7wj5RWh6L8ZsaV1uwZ+zryMc7BVND1/BlS11m4IpOfPBKeD2S1VCj2mmWZq4gypb6j082Xa2JNo4jWHsf2b+LMZyPQ/56pN9Q2DFJ4YjzzAZSBaNAWojr8+Yln1L4qPKVmG8wYnbuTVdY4CLhMyD2JdoMrHfI2oOAt1Def9SKlg5bDCH4ziKzYktMXYpHJbGEPBRvbQ/dgby2lPpbKQQfyn7i9jC+K8+T2gpTg0JZRVMNqVmJsgqBno2LboA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR0401MB3598.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(346002)(136003)(39860400002)(376002)(2906002)(9686003)(66556008)(66476007)(91956017)(64756008)(76116006)(66946007)(66446008)(316002)(5660300002)(8936002)(55016002)(8676002)(19618925003)(110136005)(186003)(52536014)(86362001)(4270600006)(478600001)(33656002)(558084003)(6506007)(7696005)(54906003)(4326008)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 6kNR3adqSqqtwvSJZMHmH83t98yyqwxtZuR0u48tTphGSkgDfg6MDE49cT/8tqVj3NpwzpOVyLHTYBpFd40hxHIAufvCp3+ky0tHKDLz6ZNOW2yOEIe9fYl6Yu5GmQng1zZzY1ecDgQ+6A+5vy+c212QMTnEkvmpBiXu/c8SqUmWKZr/AUZkh2McHprRGUaL73Sz3I7gG1zQufEOFLmFDdmocv5EC0aejg4nltcYVpSxRQTHeO1+7S/zv1Hu5rTOnV+5tigrL2xFxrUH884D95e6d4HpjBvc5YAMbWdlm+SwGcMG3zUuONh8HfoTfpxph+4oZLst7WJjrGipDz5wTk72myLWUlEgf0v1MX0QXTrGSBmGahGT/9nKK4iyzOVLVU6/DiWSKO9K7RSkDn9AY4Cz739fhr2WRvsBiKW+7J58w3TyirVrcQE1noBHEE+7WjKg1ffS7DX1CtGnz8q71WxoN125Bw2IzNYUAjD/gVPx4/0Teqyl3JSdGMVz/9E+lvP6lgPrTuNxb8+jfJoMYQ3O5SQmXkUn3lV1UGgx2FSDh+9rdxhTfciDz8eeWeFxESViIg+ux8LoDPdoKpySnPMV9liCu5eUG7+yvIe46M9jUdeUhJ6pBsSa8RithkKw7cJVaMoGatqkCZ6CH/KOz/s892ehMxVsEUk7y7tC5rlHR3kJoyJJhgCkzmGcYPCJtPyKFVSR5Tkrl/HQr/bt8w==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN4PR0401MB3598.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ccba5323-1090-430c-3bd2-08d87b1dc47a
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2020 08:45:05.2618
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6VtnRcb6LiRUtEoXf/xjCdLKFnJYZwqbwujkIMoY9/0B9kso/lA70wT7QmTU0eckeAQ3NjrBgxEItzfwrLYSBPLeCW+rEumjzmEmZRAuiYM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR04MB7420
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Thanks,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
