Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F77C361573
	for <lists+stable@lfdr.de>; Fri, 16 Apr 2021 00:24:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237007AbhDOWYo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 18:24:44 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:40098 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235823AbhDOWYC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Apr 2021 18:24:02 -0400
Received: from mailhost.synopsys.com (sv2-mailhost2.synopsys.com [10.205.2.134])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 4B01FC014A;
        Thu, 15 Apr 2021 22:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1618525418; bh=WRN49JsXWA26QVFO0bLtmTRCbTw79op1BBgTWnfyiAE=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=U5uyUY/9BPa5HIuOXg9ZSdHWE3Ym3v7tn0c6fj6YB33vp62nkeeSHimNTlaCE2qE5
         rpj1gaK8Gom/KGpP9E8dSfZi/T1WcurJgM3VBCTK+FQm6thqq5FsF3s5MLkbRnSeda
         ZpuQJ99zeVfiBrIJ5W0wcKuMlgRm3ma7J7FM1YY0ty+yTRMHTjPkTirFiTLKJNk9ys
         E2OcHHfygB6lThtG1rZo2nL/pVLEQMStSEAcWb7rXQZjfP0K/REeUX7wz4tstksL2x
         GDdQjaS0wwDlNTOYIuPbsQxkIzyAxSCjBnJyMT0V8TE15eI7YyFV1Ywh8bcVoCEelg
         6miF6pr8/UBvg==
Received: from o365relay-in.synopsys.com (us03-o365relay3.synopsys.com [10.4.161.139])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id B1857A00A8;
        Thu, 15 Apr 2021 22:23:36 +0000 (UTC)
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.protection.outlook.com", Issuer "DigiCert Cloud Services CA-1" (verified OK))
        by o365relay-in.synopsys.com (Postfix) with ESMTPS id 719AC80129;
        Thu, 15 Apr 2021 22:23:35 +0000 (UTC)
Authentication-Results: o365relay-in.synopsys.com; dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relay-in.synopsys.com; spf=pass smtp.mailfrom=thinhn@synopsys.com
Authentication-Results: o365relay-in.synopsys.com;
        dkim=pass (1024-bit key; unprotected) header.d=synopsys.com header.i=@synopsys.com header.b="qcrzIFuk";
        dkim-atps=neutral
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bgO0Gu/ZFhXOiO5avAqYxHDTsJ/1mIo12d80FO8kOa5rJVO5urRfDFIUToiI+9As24ddSmnd7Pyk0RbFjEZGB/Lp0mLNC7GpPHT6uhGulMAxlnjOLX95wzHqp8788B0te8npp2H1/VJqYDTfY8c2GHd5hopj/LcPPRfmbLr8e5N2M9jXsHDlUGOVw42M/oA2SU0g1plfWcHFBu6uRfr9sdfXBMGDHDklkSx79Q61FWaqUeJHhSghMZLDXSDoTcvlbQcBrXDoiVGS9awKD75eZrSngB+mqmDpU8nElqVWf9AC2pBDKy4FEC4qVnHi6qnYx0efTiIM8N91UN+c61aDCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WRN49JsXWA26QVFO0bLtmTRCbTw79op1BBgTWnfyiAE=;
 b=QTY/Jd9lLYF/BlstA3zwOy+sEG6IKIQuV1bVnvmSrYxPyEO55XQMp/h4CiXTE7kpL4wvUkJghMfR/2OQOwDH21AKqrEZEFJvne9B0bSJ8R4mpKk0URLa+oNAMLN4Y815P8qVIDug4CG7V/5twuzPUdh3/lXUdNYcO1i8iHeW8BDv0YzVF11T+cUpRfO2snOvn1zZbasWxWq2vr/VtLGYdJS+8kAn9nHnPaNIJyv/wzGhw/UpBsRB/U4QEe0Yxjk2NbN5zD5tmSqtZ1+bTSDZBcGISsx+6SOzaR92h5sCbaQTBcTH/+kr1JrmIRSRNfU6sXoAGM4OcUkkbSnjLG0kpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WRN49JsXWA26QVFO0bLtmTRCbTw79op1BBgTWnfyiAE=;
 b=qcrzIFukBTyuEthi/DdS+QE/YquXT/HZ7msxcqMlLm+i5EWC5q0dxbAQ2Imybi4m/WCS95ZUMZbtATOu2Yy7SjTc4Xx17o/ykKVn1ngOoWfKMB5AX34LvxIO+t3qNo4cjZs6VauokigjLfX3F2JxKA0AUaKWv2BhkMY3Ovk5Dks=
Received: from BYAPR12MB4791.namprd12.prod.outlook.com (2603:10b6:a03:10a::12)
 by BYAPR12MB2808.namprd12.prod.outlook.com (2603:10b6:a03:69::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.22; Thu, 15 Apr
 2021 22:23:33 +0000
Received: from BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::7c97:6a33:14c4:dd8c]) by BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::7c97:6a33:14c4:dd8c%6]) with mapi id 15.20.4042.018; Thu, 15 Apr 2021
 22:23:33 +0000
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
To:     John Stultz <john.stultz@linaro.org>, Ferry Toth <fntoth@gmail.com>
CC:     John Youn <John.Youn@synopsys.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Wesley Cheng <wcheng@codeaurora.org>,
        Yu Chen <chenyu56@huawei.com>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: [PATCH v3] usb: dwc3: core: Do core softreset when switch mode
Thread-Topic: [PATCH v3] usb: dwc3: core: Do core softreset when switch mode
Thread-Index: AQHXMkWV7LsE5m94VkyJIYRuvRhHs6q2J2QA
Date:   Thu, 15 Apr 2021 22:23:33 +0000
Message-ID: <d053b843-2308-6b42-e7ff-3dc6e33e5c7d@synopsys.com>
References: <2cb4e704b059a8cc91f37081c8ceb95c6492e416.1618503587.git.Thinh.Nguyen@synopsys.com>
 <374440f8dcd4f06c02c2caf4b1efde86774e02d9.1618521663.git.Thinh.Nguyen@synopsys.com>
In-Reply-To: <374440f8dcd4f06c02c2caf4b1efde86774e02d9.1618521663.git.Thinh.Nguyen@synopsys.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
authentication-results: linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=none action=none header.from=synopsys.com;
x-originating-ip: [98.248.94.126]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 81c379ac-2ca2-4289-46af-08d9005d1b1d
x-ms-traffictypediagnostic: BYAPR12MB2808:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB28080882DE7A561EC892D34AAA4D9@BYAPR12MB2808.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YrNU6c7ADIqxD2XpTsLym4fSAIVpMO1WqCeSOGAwJiF7JZSckNQvRfpopcPoDIxT0F8p5sqCK4FlzFWhi1GTIY8udSDLjjqJVP9xwMqA9Mt9D8U3G5pfbl+7BFyqFz5WHDnkrx/BCXA5rUc0TjtrcgzxNcKOEggtTbEc2ZT0ZgfbK8nllg6w5JwfIVmU6xXeo7yWWCc4CfSEtuIM8UhOY0eLYW3tnmM9yIY2Q5WZj9IwT2Wm/q/ofqbEPO687+ahg1QMH+eU8wMeJrb2oNaSjWtwHh3sAqKbP17BVWypuMVRXM/sIMja6lzCWSMM5dgo4L1QDDv5rNH3WO4H23eyIBmplxMKFdp+KNNyKOhOdCQleurpDRA9Zu3QKWdXrKl8XYQTMEb0aIU7+DQzt5XWJZ80PHDIESfDkBjzZD5Blt92dEujuSztmLAF8b2sgQ55nEqgPnQMmdrLRoQCHyEGHtBnwTrGldYejU5VW7qIT63FpKhQErOdqjjf3nPGwFFsHL1vHYrhgRLFukYZ8RNnG4E0mC9ISmaVpUoLZwLrzYPuXjdaRCNBDo9zDSk89NhJCDkNVbKMYeoN3pQq62uQJLSFmMAWMDkc5nJhLEkx5LpQuCDaXPYntiRoDwqhduSiGWC7e6k3Z0RSLY3cReE6BW5eumL0+wow7x8OUQOEqil76ZGyiBbRHQWc2Z3Q1IL4k13voANcNHjWYsV13bgMmktN5nkayeyMZAzCk4dhtzVtT/ncWIOGcOZ1PWjPTYhsqizZrPQ5nQSEods/WcOAJA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4791.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(366004)(376002)(346002)(136003)(122000001)(5660300002)(316002)(71200400001)(6506007)(6512007)(31686004)(31696002)(966005)(54906003)(2616005)(38100700002)(26005)(110136005)(478600001)(2906002)(86362001)(66476007)(66556008)(76116006)(66946007)(186003)(4326008)(64756008)(8676002)(36756003)(8936002)(6486002)(66446008)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?YU8ySlA3blA0REkrd0pSUFVHTTFpSXJTRW94TU1lZ3RGVkVmajVLOWxyYnVV?=
 =?utf-8?B?VkdnZ3Z3Y2xZWHNYVWFNOEUzQ3FpSHlBM3ZkalFUbVNVVW9kd1NmMmNVSFRJ?=
 =?utf-8?B?eVEyelBJZm5lMlhxMENjMGNBR3VDdE9mM0h4ZmVXaCsxdE5Dd1JOemR6Uis4?=
 =?utf-8?B?QzV3Y3JYYXE2V0djd2xzbHZKL1cya1dETXZPcmtDamF0dmtNdG8zTTdmdlVX?=
 =?utf-8?B?NTZHaGlTeWJWSDAwUjVoU3lGWGd0eDJTL0hrM1NHRFYvdXBGSWNoTlM2dGNP?=
 =?utf-8?B?b3QrY09wUzhhTnV4M0J1VS95eU5iWTB3U1lFQ2MvY0NPRmtzTzZVTWxsYjhh?=
 =?utf-8?B?SXppRVF2VlhEL3MzZmFlTU0zVVo5ZXc0SDFxREY0SmFlYWpONUVmaWFNR2NW?=
 =?utf-8?B?WFowekhSQ096ZVh3a1B2LytUcFJCaEhUNTlTbDBUeUFrNExXaFhSREJwOVpo?=
 =?utf-8?B?TlBzRFAvaGlLdWsvQWxjU25zYzBYVjFlN2lqRTRXV2hrdWoyQUIrc2cxcFB2?=
 =?utf-8?B?U2M4TmtuZHNYTXduZFNyZFRYb3ltcXArRlVXQ2QxVkxqdk1KNlhadUhpVVdm?=
 =?utf-8?B?NElyekNkZFM5RnVETXprcXl3c0xoTnQzUFBZMUxPUXVDNUFyU2JBS2NWS3ky?=
 =?utf-8?B?OEtCQzhBMDBFRlNLQUlZTFZRNnJ5dmY2dnY5NUVtbC9EUkQyS1NubnY5cDQw?=
 =?utf-8?B?NVlvSG1Lc2JwNFZCMit4ZStxY3kxREx6YXBoVWtXRmU4YTVsakdPRWxQWXMz?=
 =?utf-8?B?b3UrbFJwZFJQeUdUenZieXVCTmZBMGd3NUZadWtRaXVaYVh0TC9mY3Q2YTM1?=
 =?utf-8?B?aWxOSkFzL3lFVnMweExZKzhWK2t6cEt1cTEwaWpoZHZuTjJYS2hFRnQwNWZE?=
 =?utf-8?B?MFIrNmJLOE4xT3ZPaGJxMHBTMlNyQVl5TU5NWjVMMURudklaS2pObzdNWDFo?=
 =?utf-8?B?WXJBR2VUWitsOFJ2NURNREVXV1huYjl2NjZLNEVkZUpUVkVNY1pYV1FxYXZO?=
 =?utf-8?B?ekY0cmtkMitOenNSRUxpWi9yenNBM3Jka1o5cEJidW5MUW5uS2tTMExoL3lU?=
 =?utf-8?B?M0pzMlQyQTE4MEphL1QwMXFCTSt6bFlCcDhvZHFlc3duQndpV015a1ovUm02?=
 =?utf-8?B?dGVybTA3Mk1ydkJZa2lQWm1JcFRjRVNKaC8wNjBnTW1GeDNLNUtMQkR1MUti?=
 =?utf-8?B?ZlpXeU4wVG5mZUJTY3M5MkVSWkRzM0NIR1hmVWpjZEpwUUhlUUp3cTFPcy80?=
 =?utf-8?B?UVlSOTVLMFoyNFdKb1RoVGM1V21TS2F5SEdBVGZXbW5vL0xWK2lPQXU2VUFs?=
 =?utf-8?B?MUpXbHNobTJranpmR295dFdwSDRBTUZpcHF5MnpyRHZ6aDEwdTdNRDFVMnpy?=
 =?utf-8?B?SmgxdDd0cXUraFpySkJINHltMjJKRFlmWi9xUGxaZ2hDUllhZzIvT3BydDAx?=
 =?utf-8?B?ZE1HWmh4RXIrVVRmaTNmZUhGNy9EN2FXNVpWbXdFT2VuSTBKK00rUWliSlV2?=
 =?utf-8?B?TzRlSkFFSC9SQnZtMDJjQlc1MVN4Vk5lUnFxeDd1elJKbC96ZWt2UzRSNEpt?=
 =?utf-8?B?TFVmMGc0cjQ3ZFNteXN5cW1ZZTdKdW5qYjliOVpSWGZPTkVxdW5va1M1aVli?=
 =?utf-8?B?WnIxa0hlL2dJRjJrcHlWYS8veUxXN3FKbi9hZzFPMkFvSkRVd3hIQUZkdkxJ?=
 =?utf-8?B?U0VuTVRxeVdjeDVoN09wR1ludlA3RnA3aGcvYzJsR0VlV3VmMkhsN2piTXZ0?=
 =?utf-8?Q?AhJFPOnsejPEfen72EtXp1cG2NffA2KPuTzAQFI?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6E4313FE2808A349AA2D85C0D14BB47B@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4791.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81c379ac-2ca2-4289-46af-08d9005d1b1d
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Apr 2021 22:23:33.4928
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yB16k+eUpfmzL5XwsOyxsoaXp1f5NYHKLDNrczCX6fWQIFff2v/kW82p+KEGcl4GARUjN5HX/7Zp53gOtvbIDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2808
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

VGhpbmggTmd1eWVuIHdyb3RlOg0KPiBGcm9tOiBZdSBDaGVuIDxjaGVueXU1NkBodWF3ZWkuY29t
Pg0KPiBGcm9tOiBKb2huIFN0dWx0eiA8am9obi5zdHVsdHpAbGluYXJvLm9yZz4NCj4gDQo+IEFj
Y29yZGluZyB0byB0aGUgcHJvZ3JhbW1pbmcgZ3VpZGUsIHRvIHN3aXRjaCBtb2RlIGZvciBEUkQg
Y29udHJvbGxlciwNCj4gdGhlIGRyaXZlciBuZWVkcyB0byBkbyB0aGUgZm9sbG93aW5nLg0KPiAN
Cj4gVG8gc3dpdGNoIGZyb20gZGV2aWNlIHRvIGhvc3Q6DQo+IDEuIFJlc2V0IGNvbnRyb2xsZXIg
d2l0aCBHQ1RMLkNvcmVTb2Z0UmVzZXQNCj4gMi4gU2V0IEdDVEwuUHJ0Q2FwRGlyKGhvc3QgbW9k
ZSkNCj4gMy4gUmVzZXQgdGhlIGhvc3Qgd2l0aCBVU0JDTUQuSENSRVNFVA0KPiA0LiBUaGVuIGZv
bGxvdyB1cCB3aXRoIHRoZSBpbml0aWFsaXppbmcgaG9zdCByZWdpc3RlcnMgc2VxdWVuY2UNCj4g
DQo+IFRvIHN3aXRjaCBmcm9tIGhvc3QgdG8gZGV2aWNlOg0KPiAxLiBSZXNldCBjb250cm9sbGVy
IHdpdGggR0NUTC5Db3JlU29mdFJlc2V0DQo+IDIuIFNldCBHQ1RMLlBydENhcERpcihkZXZpY2Ug
bW9kZSkNCj4gMy4gUmVzZXQgdGhlIGRldmljZSB3aXRoIERDVEwuQ1NmdFJzdA0KPiA0LiBUaGVu
IGZvbGxvdyB1cCB3aXRoIHRoZSBpbml0aWFsaXppbmcgcmVnaXN0ZXJzIHNlcXVlbmNlDQo+IA0K
PiBDdXJyZW50bHkgd2UncmUgbWlzc2luZyBzdGVwIDEpIHRvIGRvIEdDVEwuQ29yZVNvZnRSZXNl
dCBhbmQgc3RlcCAzKSBvZg0KPiBzd2l0Y2hpbmcgZnJvbSBob3N0IHRvIGRldmljZS4gSm9obiBT
dHVsdCByZXBvcnRlZCBhIGxvY2t1cCBpc3N1ZSBzZWVuDQo+IHdpdGggSGlLZXk5NjAgcGxhdGZv
cm0gd2l0aG91dCB0aGVzZSBzdGVwc1sxXS4gU2ltaWxhciBpc3N1ZSBpcyBvYnNlcnZlZA0KPiB3
aXRoIEZlcnJ5J3MgdGVzdGluZyBwbGF0Zm9ybVsyXS4NCj4gDQo+IFNvLCBhcHBseSB0aGUgcmVx
dWlyZWQgc3RlcHMgYWxvbmcgd2l0aCBzb21lIGZpeGVzIHRvIFl1IENoZW4ncyBhbmQgSm9obg0K
PiBTdHVsdHoncyB2ZXJzaW9uLiBUaGUgbWFpbiBmaXhlcyB0byB0aGVpciB2ZXJzaW9ucyBhcmUg
dGhlIG1pc3Npbmcgd2FpdA0KPiBmb3IgY2xvY2tzIHN5bmNocm9uaXphdGlvbiBiZWZvcmUgY2xl
YXJpbmcgR0NUTC5Db3JlU29mdFJlc2V0IGFuZCBvbmx5DQo+IGFwcGx5IERDVEwuQ1NmdFJzdCB3
aGVuIHN3aXRjaGluZyBmcm9tIGhvc3QgdG8gZGV2aWNlLg0KPiANCj4gWzFdIGh0dHBzOi8vdXJs
ZGVmZW5zZS5jb20vdjMvX19odHRwczovL2xvcmUua2VybmVsLm9yZy9saW51eC11c2IvMjAyMTAx
MDgwMTUxMTUuMjc5MjAtMS1qb2huLnN0dWx0ekBsaW5hcm8ub3JnL19fOyEhQTRGMlI5R19wZyFQ
VzlKYnM0d3Y0YV96S0dnWkhOMEZZcklwZmVjUFgwT3VxOVYzZDE2WXotOS1HU0hxWldzZkJBRi1X
a2VxTGh6TjRpMyQgDQo+IFsyXSBodHRwczovL3VybGRlZmVuc2UuY29tL3YzL19faHR0cHM6Ly9s
b3JlLmtlcm5lbC5vcmcvbGludXgtdXNiLzBiYTdhNmJhLWU2YTctOWNkNC0wNjk1LTY0ZmM5Mjdl
MDFmMUBnbWFpbC5jb20vX187ISFBNEYyUjlHX3BnIVBXOUpiczR3djRhX3pLR2daSE4wRllySXBm
ZWNQWDBPdXE5VjNkMTZZei05LUdTSHFaV3NmQkFGLVdrZXFHZVpTdHQ0JCANCj4gDQo+IENjOiBB
bmR5IFNoZXZjaGVua28gPGFuZHkuc2hldmNoZW5rb0BnbWFpbC5jb20+DQo+IENjOiBGZXJyeSBU
b3RoIDxmbnRvdGhAZ21haWwuY29tPg0KPiBDYzogV2VzbGV5IENoZW5nIDx3Y2hlbmdAY29kZWF1
cm9yYS5vcmc+DQo+IENjOiA8c3RhYmxlQHZnZXIua2VybmVsLm9yZz4NCj4gRml4ZXM6IDQxY2Ux
NDU2ZTFkYiAoInVzYjogZHdjMzogY29yZTogbWFrZSBkd2MzX3NldF9tb2RlKCkgd29yayBwcm9w
ZXJseSIpDQo+IFNpZ25lZC1vZmYtYnk6IFl1IENoZW4gPGNoZW55dTU2QGh1YXdlaS5jb20+DQo+
IFNpZ25lZC1vZmYtYnk6IEpvaG4gU3R1bHR6IDxqb2huLnN0dWx0ekBsaW5hcm8ub3JnPg0KPiBT
aWduZWQtb2ZmLWJ5OiBUaGluaCBOZ3V5ZW4gPFRoaW5oLk5ndXllbkBzeW5vcHN5cy5jb20+DQo+
IC0tLQ0KPiBDaGFuZ2VzIGluIHYzOg0KPiAtIENoZWNrIGlmIHRoZSBkZXNpcmVkIG1vZGUgaXMg
T1RHLCB0aGVuIGtlZXAgdGhlIG9sZCBmbG93DQo+IC0gUmVtb3ZlIGNvbmRpdGlvbiBmb3IgT1RH
IHN1cHBvcnQgb25seSBzaW5jZSB0aGUgZGV2aWNlIGNhbiBzdGlsbCBiZQ0KPiAgIGNvbmZpZ3Vy
ZWQgRFJEIGhvc3QvZGV2aWNlIG1vZGUgb25seQ0KPiAtIFJlbW92ZSByZWR1bmRhbnQgaHdfbW9k
ZSBjaGVjayBzaW5jZSBfX2R3YzNfc2V0X21vZGUoKSBvbmx5IGFwcGxpZXMgd2hlbg0KPiAgIGh3
X21vZGUgaXMgRFJEDQo+IENoYW5nZXMgaW4gdjI6DQo+IC0gSW5pdGlhbGl6ZSBtdXRleCBwZXIg
ZGV2aWNlIGFuZCBub3QgYXMgZ2xvYmFsIG11dGV4Lg0KPiAtIEFkZCBhZGRpdGlvbmFsIGNoZWNr
cyBmb3IgRFJEIG9ubHkgbW9kZQ0KPiANCj4gIGRyaXZlcnMvdXNiL2R3YzMvY29yZS5jIHwgMjcg
KysrKysrKysrKysrKysrKysrKysrKysrKysrDQo+ICBkcml2ZXJzL3VzYi9kd2MzL2NvcmUuaCB8
ICA1ICsrKysrDQo+ICAyIGZpbGVzIGNoYW5nZWQsIDMyIGluc2VydGlvbnMoKykNCj4gDQoNCkhp
IEpvaG4sDQoNCklmIHBvc3NpYmxlLCBjYW4geW91IHJ1biBhIHRlc3Qgd2l0aCB0aGlzIHZlcnNp
b24gb24geW91ciBwbGF0Zm9ybT8NCg0KVGhhbmtzLA0KVGhpbmgNCg0K
