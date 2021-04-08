Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA82935804C
	for <lists+stable@lfdr.de>; Thu,  8 Apr 2021 12:09:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231134AbhDHKJg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Apr 2021 06:09:36 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.73.133]:38458 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229686AbhDHKJf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Apr 2021 06:09:35 -0400
Received: from mailhost.synopsys.com (sv2-mailhost1.synopsys.com [10.205.2.133])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id E19A640806;
        Thu,  8 Apr 2021 10:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1617876565; bh=RpJnU5tsz+dLO8LJMLYqF7Sd32vODQQoVLr/c4R8yS8=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=XsHamE8xoW1Mau/Hn9mTXC5HbjABynqINoRJHc6DNLZc2koM9OTDSqS7ZfCx6HTXG
         1WSSiyA90eDBF4m6DLeqve13Ach0mvSpfykEzxV4XKijldrx0ZRU+Nj5kN4z7fjjMD
         qWknn2d6bCutaHu/l+G3TP49wsM29XJ/Sqj93m1Sq1CCIStulOX3zFQ3+F3i+E32Ej
         6dgIwS0LwavfoYGR2aRyQ3zkTNwOfFAlNDywwzvpMOjlo0x8robAnrjtWKMqtchx3y
         HriyM0Tw3sr8+twinzdM7qyhvfuTTPjjA43FOvHktpy6E+R3+T8/TluASvFqy6Sqw3
         I++UCJL/Z2W0A==
Received: from o365relay-in.synopsys.com (sv2-o365relay3.synopsys.com [10.202.1.139])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 3568CA007C;
        Thu,  8 Apr 2021 10:09:24 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2176.outbound.protection.outlook.com [104.47.58.176])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.protection.outlook.com", Issuer "DigiCert Cloud Services CA-1" (verified OK))
        by o365relay-in.synopsys.com (Postfix) with ESMTPS id 1DE4C4014D;
        Thu,  8 Apr 2021 10:09:23 +0000 (UTC)
Authentication-Results: o365relay-in.synopsys.com; dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relay-in.synopsys.com; spf=pass smtp.mailfrom=arturp@synopsys.com
Authentication-Results: o365relay-in.synopsys.com;
        dkim=pass (1024-bit key; unprotected) header.d=synopsys.com header.i=@synopsys.com header.b="r4tWhQEM";
        dkim-atps=neutral
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ef+jv/R7xeDgdypmUMWBPzEnMwu9n2uNXEcGAl9coGJHXP6ZBafQ56ZdcexL1cBpzswnc1MzwU9W4tlERcCPRD4wpa7Gi37F/OvLSd5cTj7L8l8MZi2S1BdYXYOhbNg9RaWHCBh92XN2DqhB0lg+Y0Am+21+kI3QkmTJXEjqtNMSHG5Gqy+J3PyTPaM4dgLu1b7OTDn1z1+i7PRAZTXceYAsDlEMp8H1IO10jA8msvh/JIEuHk2uLszpGOj6Wor/T0xE9hn0mW44moYtX8ocL7PPGQciZf6s3tMHRgB6rHg6fxTAu5sTmTQHXl7mlz5NOwjGl8YDxbgXDUFEZrXYPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RpJnU5tsz+dLO8LJMLYqF7Sd32vODQQoVLr/c4R8yS8=;
 b=K6sxToSe9PQ5oz3e7yYgS4lrk0mvfLXqUN7N7yj+mtBoHuQAZL9JuxLoqbEkucxn3T2NCbGMhgTeGRPtSl0X6MbgCTVG9zAiMnUYHCa+SfLSmCLOpEgWEs4QRaAQCHDdebxfJoX1wA0R5QXkd2TwLp6Mwxi78Zm2+ddl9LsPoiwq2mqEBxgAwkUWpCZjy36QMCqVnFvo+Wpc66c45LyxIgdkUJxs1SfdEBV3E3IUNcGIIB6hJqBv3+bZZGjJsnDxXVqMm04I0NkeQWs/eHXkZkhxDJcDWe4ranImpqpFPqVpC36zHqzxW6Vm3arAqaZHEYR2Japnx8Ny3m2Gxa0i1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RpJnU5tsz+dLO8LJMLYqF7Sd32vODQQoVLr/c4R8yS8=;
 b=r4tWhQEMRJwg7OE7MfL2WKEvjv5Bwr5+UeH+VRKXcGMGy3U8juVrMmxASdE2ho59qhqZA3+njlh4mXZT/0Q3ovd3ICBYQU5sFIXEyxLZ4DsTYa0UpCt+lEHjjOdeFQcls//VoRKrQXZoo+qxAVX6/Lb1mLVrWUAQRHHXSEqpx4w=
Received: from CH0PR12MB5265.namprd12.prod.outlook.com (2603:10b6:610:d0::22)
 by CH0PR12MB5348.namprd12.prod.outlook.com (2603:10b6:610:d7::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17; Thu, 8 Apr
 2021 10:09:21 +0000
Received: from CH0PR12MB5265.namprd12.prod.outlook.com
 ([fe80::b1a0:f306:3b5a:7f0c]) by CH0PR12MB5265.namprd12.prod.outlook.com
 ([fe80::b1a0:f306:3b5a:7f0c%7]) with mapi id 15.20.4020.016; Thu, 8 Apr 2021
 10:09:20 +0000
X-SNPS-Relay: synopsys.com
From:   Artur Petrosyan <Arthur.Petrosyan@synopsys.com>
To:     Artur Petrosyan <Arthur.Petrosyan@synopsys.com>,
        John Youn <John.Youn@synopsys.com>,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mian Yousaf Kaukab <yousaf.kaukab@intel.com>,
        Gregory Herrero <gregory.herrero@intel.com>,
        Douglas Anderson <dianders@chromium.org>
CC:     Paul Zimmerman <paulz@synopsys.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Robert Baldyga <r.baldyga@samsung.com>,
        Kever Yang <kever.yang@rock-chips.com>
Subject: Re: [PATCH v2 00/14] usb: dwc2: Fix Partial Power down issues.
Thread-Topic: [PATCH v2 00/14] usb: dwc2: Fix Partial Power down issues.
Thread-Index: AQHXLEjGTAAr4ldgzUSBIe37KXOig6qqV46AgAAOWoA=
Date:   Thu, 8 Apr 2021 10:09:20 +0000
Message-ID: <af45ed18-2ce4-43da-f28c-d5cda0710b9f@synopsys.com>
References: <cover.1617782102.git.Arthur.Petrosyan@synopsys.com>
 <20210408072825.61347A022E@mailhost.synopsys.com>
 <3625b740-b362-5ec6-8fba-cd7babcab35b@synopsys.com>
In-Reply-To: <3625b740-b362-5ec6-8fba-cd7babcab35b@synopsys.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: synopsys.com; dkim=none (message not signed)
 header.d=none;synopsys.com; dmarc=none action=none header.from=synopsys.com;
x-originating-ip: [46.162.196.54]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 219b5816-cb01-47d5-d0b6-08d8fa7660cb
x-ms-traffictypediagnostic: CH0PR12MB5348:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CH0PR12MB53488EFC3A82CD625C99EE76A7749@CH0PR12MB5348.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3276;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: R+U1f2pYw7+PiylK970m0W/mEYzMmaYo3yIxqMrjYbdtrl09vaJrxwtPub6wDVXX5LDfBgt1x8anA48Cr1GREFddFll+REU8BzpKlhy2j90sAN1HY63rHnSmQ1E0yCB/35LzRe9qrtnelAcYZHMoBOgTZC1vpXccWYUck8H6t+9h5noojq75TbpGzsd2YsOMHOKebitYIitBdR6o2HvmB0tKTCPFslgz/knS1jEDOAPtbGyXHtTvrek9N6IZ7HfM132x2Rk1fPsM1cEuHwJ+fF1yfZyCmZF7flYT9lZ+a5mTTPjZuAbiUMXDdT+eKu5oKCXYK8ondjAuhk1BruyYI7KJ/wknyLw03BAYRjrbTgi9QCCS5Fy9JMlH0Zx9xrPyFyskg8R17ZF5o1/prhHcfQqv5bNmKwV5/ulP5wDId+eklYwoqKwxu0OBFO+O746noV9gm1QOro91Ep1TGB0yPKvHirh+PcUTXMv/eN5SIxc3GBshn9E3QXdsGb/E1vzd7rEecQ6lZ1e7YS8zI5onflfgqdi9+nc6pVXRfsXdODl7MjLn5ZXzHMWWGBFHpeYx+UagiBGUvLYIhn/TZ5Q2+WIoVArLrL0ldyYE8oWzQrq8DYnCq2pWT2jtQ4B3Vj1oSZnEghVxwYj+j9TPg7w/HuWZUFgJ3pjNYJau5l4pki+XVG/HdsCM4Ocx1IFfHdjnaGMiBIzZXagDsnI/CzTcvPGKRRuxVUKOfNCV/lcESS85e0trT3sxHloRpXsjkOaR5xaTJdYltO98OBXRT4tN0AxiqiuAXTV/bbnoJvq4jNRgDaaykPpAu/bCxgbfhjYy
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR12MB5265.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(396003)(136003)(366004)(376002)(91956017)(53546011)(4326008)(31686004)(76116006)(66476007)(6506007)(66556008)(66946007)(478600001)(64756008)(83380400001)(66446008)(2616005)(86362001)(31696002)(6512007)(110136005)(26005)(8936002)(316002)(71200400001)(5660300002)(8676002)(54906003)(966005)(6486002)(36756003)(7416002)(2906002)(38100700001)(186003)(921005)(45980500001)(6606295002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?M1Fxc1lFWHgrZ2hvc0FHbmJ5K3YreWhxbmx4RTBzSlV1dU51WVZrNUk0ZWJO?=
 =?utf-8?B?UWpoNE8yT2lTTWdDeGloaHAzb2pCY3VqOG9hLzVlWkg5RkV4WDN2eG53cHN5?=
 =?utf-8?B?UHFXd1JhZW5NOXU4WlN6WDdadUVEdTllcmZBSnJMUjZLQzFGTVJNRXRoalJW?=
 =?utf-8?B?RXFkNEFaTU1SVmJFRGJKMUR1RUpXVlAzbUNlZUNxYktsL1kzeTVrMWxOMVRt?=
 =?utf-8?B?cURxNVpCaWNBbWFPblowam5Fb001SVNmVkZBQ1MwS2w1ZE1YTlZqQnBGMTB6?=
 =?utf-8?B?ZTJZWTUvM0poY2pBRFR1UjFzK01MOXhncTl0MElyamVvcTU5NzhMNlEyTlg5?=
 =?utf-8?B?QTJPWmhpamhQODJyVjVnSktBZGRlMUJzUnl2cGRjKzJmWnZXY0VXdTFuUDRs?=
 =?utf-8?B?YzhDN2JHSXdDTU5acmRFeENjV0VnSFdhRDJUbFRzY1J2eVU4cmw4NEN0OUFj?=
 =?utf-8?B?TTNGYWlvZzJWY3lWbmtMNGNwbkZKVE9nY2dEQllGbE5kcDk3R1lvSFVlZDRo?=
 =?utf-8?B?Z09ZbHRiV01oVHpYR2JZZlBJODg5NDYzeG1mbUFqc0JydDB4N0NsWG1LUUto?=
 =?utf-8?B?Q2ZLM29pNEV1QUozZEVMbmJZUGxTM3hacVArUTJGSGlEY3lFSTByOFc5Z001?=
 =?utf-8?B?UEhvVFBsZTFNMmFnR0ZjWHhrRXdZSERIek42SFVlV3N4d3NmUHoxay8vbk5G?=
 =?utf-8?B?R2RqdWt2STlnL2pLb01yNlpQcmdvTXJ6aW1WNXk2SGNOZXJia05FRHF2OTNw?=
 =?utf-8?B?a3pVWGFPUDhGQ0E2WVlaQjd0R3ozQXQ1OWt3a3BEWEFaSUQzNnBzUjFzTFU0?=
 =?utf-8?B?aGxHVnhXOVlPK2psWTZQakVQSWpQT2xDZnRodFVJcHVXYTJtblQxQi9EQlgy?=
 =?utf-8?B?V2wyUUk2TkRwQ0kwZHFrOFpFcWN3VEJKc1M1QzBwRFlTUnMvYllLbTUyM1Az?=
 =?utf-8?B?dWo0QU05WUtlVGJaS3VheVVXYW1QL3dGZmthb0FkVElHWDF3ZU5VR1ZjMXQw?=
 =?utf-8?B?UnJUbVlSZ2kwVWhrM3h4RGoxSytFTi9OWnhPdjBoL2pjWUhmd3FNK2xKNDUw?=
 =?utf-8?B?YUY0eFArQjJ5QVM3Y1J5OExwa1VLazdINXEwQWhnTGl3bzJVZExhaE9WVXcz?=
 =?utf-8?B?KzBJZ2ZPVW9kMlg1cTVPeDZkTWllWkkxNksxanlFOHhoaWNJYTB2OWxDK0cr?=
 =?utf-8?B?VnRuUGE5TC9xVUhwVmEwWGdGYzIveTJsNkRDdWpYeGp5elJybEtFTmZKTkFv?=
 =?utf-8?B?bHhUa01MUUFML2gwNTJOSzlnUkRDOWlkYTI2MXczOW9QYmg1TkVabVRUS2dB?=
 =?utf-8?B?djFhdkV0NERJZ2tHR3ZQa3ZwUnJ6eVN0b3R2MlVmbnhJb1h0SWRzRk96VWVv?=
 =?utf-8?B?TE1tSXQ5Y2FPSFJGK2I1amNYMUJudWxJN05KdWJwTTBtVmRwQndkbk5nbDlO?=
 =?utf-8?B?bWY3QWhQTFVlMWV6anc5RW1BcGtMZHptSjdadmt2TSt3ZytDNkVmZUk5eEI5?=
 =?utf-8?B?WlFOL0Rrc0hVWnhPdHR2aFJ6REN3a1drNi9DVVdLTTFTS3ZqWTc5QVRwb01L?=
 =?utf-8?B?YmdDREl0TENHNFVJblI4U25JRXIySytnMDdnY1llL055YThoTEhLYjRKMnB0?=
 =?utf-8?B?cTJuMXF1cUlBQk4zWWdTWkp5RlhxMWlmWEhFeHlZbUJPOWtVeVhHVGlXWkdq?=
 =?utf-8?B?SkV3Nk4yL1JoL3B4NlA5eVBLMi9mcGhFL255bFYxRzUvWEVPNFAxMTRVSTdx?=
 =?utf-8?Q?rQqo3lPzs9bfKC7NE7RbwqfUUTUtcOxZgStcmst?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5A8D3B3B54E0904A923D8CB293C14C83@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH0PR12MB5265.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 219b5816-cb01-47d5-d0b6-08d8fa7660cb
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Apr 2021 10:09:20.8586
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3qTRXMHrFUvu0NEVoHF8cykm+jez5dZxauJQRySCXP5KdqP5bO/pLkHVLeHuS22ks0gXPXRkxg0+gsM6EBYsMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5348
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGkgR3JlZywNCg0KT24gNC84LzIwMjEgMTM6MTcsIEFydHVyIFBldHJvc3lhbiB3cm90ZToNCj4g
SGkgR3JlZywNCj4gDQo+IE9uIDQvOC8yMDIxIDExOjI4LCBBcnR1ciBQZXRyb3N5YW4gd3JvdGU6
DQo+PiBUaGlzIHBhdGNoIHNldCBmaXhlcyBhbmQgaW1wcm92ZXMgdGhlIFBhcnRpYWwgUG93ZXIg
RG93biBtb2RlIGZvcg0KPj4gZHdjMiBjb3JlLg0KPj4gSXQgYWRkcyBzdXBwb3J0IGZvciB0aGUg
Zm9sbG93aW5nIGNhc2VzDQo+PiAgICAgICAxLiBFbnRlcmluZyBhbmQgZXhpdGluZyBwYXJ0aWFs
IHBvd2VyIGRvd24gd2hlbiBhIHBvcnQgaXMNCj4+ICAgICAgICAgIHN1c3BlbmRlZCwgcmVzdW1l
ZCwgcG9ydCByZXNldCBpcyBhc3NlcnRlZC4NCj4+ICAgICAgIDIuIEV4aXRpbmcgdGhlIHBhcnRp
YWwgcG93ZXIgZG93biBtb2RlIGJlZm9yZSByZW1vdmluZyBkcml2ZXIuDQo+PiAgICAgICAzLiBF
eGl0aW5nIHBhcnRpYWwgcG93ZXIgZG93biBpbiB3YWtldXAgZGV0ZWN0ZWQgaW50ZXJydXB0IGhh
bmRsZXIuDQo+PiAgICAgICA0LiBFeGl0aW5nIGZyb20gcGFydGlhbCBwb3dlciBkb3duIG1vZGUg
d2hlbiBjb25uZWN0b3IgSUQuDQo+PiAgICAgICAgICBzdGF0dXMgY2hhbmdlcyB0byAiY29ubklk
IEINCj4+DQo+PiBJdCB1cGRhdGVzIGFuZCBmaXhlcyB0aGUgaW1wbGVtZW50YXRpb24gb2YgZHdj
MiBlbnRlcmluZyBhbmQNCj4+IGV4aXRpbmcgcGFydGlhbCBwb3dlciBkb3duIG1vZGUgd2hlbiB0
aGUgc3lzdGVtIChQQykgaXMgc3VzcGVuZGVkLg0KPj4NCj4+IFRoZSBwYXRjaCBzZXQgYWxzbyBp
bXByb3ZlcyB0aGUgaW1wbGVtZW50YXRpb24gb2YgZnVuY3Rpb24gaGFuZGxlcnMNCj4+IGZvciBl
bnRlcmluZyBhbmQgZXhpdGluZyBob3N0IG9yIGRldmljZSBwYXJ0aWFsIHBvd2VyIGRvd24uDQo+
Pg0KPj4gTk9URTogVGhpcyBpcyB0aGUgc2Vjb25kIHBhdGNoIHNldCBpbiB0aGUgcG93ZXIgc2F2
aW5nIG1vZGUgZml4ZXMNCj4+IHNlcmllcy4NCj4+IFRoaXMgcGF0Y2ggc2V0IGlzIHBhcnQgb2Yg
bXVsdGlwbGUgc2VyaWVzIGFuZCBpcyBjb250aW51YXRpb24NCj4+IG9mIHRoZSAidXNiOiBkd2My
OiBGaXggYW5kIGltcHJvdmUgcG93ZXIgc2F2aW5nIG1vZGVzIiBwYXRjaCBzZXQuDQo+PiAoUGF0
Y2ggc2V0IGxpbms6IGh0dHBzOi8vdXJsZGVmZW5zZS5jb20vdjMvX19odHRwczovL21hcmMuaW5m
by8/bD1saW51eC11c2ImbT0xNjAzNzk2MjI0MDM5NzUmdz0yX187ISFBNEYyUjlHX3BnIUlKLVhs
MVp3UVUya21xSEIzSVR5V3lubzlCZ3BXVXNDNjQ3QXFLN0dJbGd6SnU5QnpUNlZON2p0LS1fX2ZH
ZE10Z1dGNjlNJCApLg0KPj4gVGhlIHBhdGNoZXMgdGhhdCB3ZXJlIGluY2x1ZGVkIGluIHRoZSAi
dXNiOiBkd2MyOg0KPj4gRml4IGFuZCBpbXByb3ZlIHBvd2VyIHNhdmluZyBtb2RlcyIgd2hpY2gg
d2FzIHN1Ym1pdHRlZA0KPj4gZWFybGllciB3YXMgdG9vIGxhcmdlIGFuZCBuZWVkZWQgdG8gYmUg
c3BsaXQgdXAgaW50bw0KPj4gc21hbGxlciBwYXRjaCBzZXRzLg0KPj4NCj4+IENoYW5nZXMgc2lu
Y2UgVjE6DQo+PiBObyBjaGFuZ2VzIGluIHRoZSBwYXRjaGVzIG9yIHRoZSBzb3VyY2UgY29kZS4N
Cj4+IFNlbmRpbmcgdGhlIHNlY29uZCB2ZXJzaW9uIG9mIHRoZSBwYXRjaCBzZXQgYmVjYXVzZSB0
aGUgZmlyc3QgdmVyc2lvbg0KPj4gd2FzIG5vdCByZWNlaXZlZCBieSB2Z2VyLmtlcm5lbC5vcmcu
DQo+Pg0KPj4NCj4+DQo+PiBBcnR1ciBQZXRyb3N5YW4gKDE0KToNCj4+ICAgICB1c2I6IGR3YzI6
IEFkZCBkZXZpY2UgcGFydGlhbCBwb3dlciBkb3duIGZ1bmN0aW9ucw0KPj4gICAgIHVzYjogZHdj
MjogQWRkIGhvc3QgcGFydGlhbCBwb3dlciBkb3duIGZ1bmN0aW9ucw0KPj4gICAgIHVzYjogZHdj
MjogVXBkYXRlIGVudGVyIGFuZCBleGl0IHBhcnRpYWwgcG93ZXIgZG93biBmdW5jdGlvbnMNCj4+
ICAgICB1c2I6IGR3YzI6IEFkZCBwYXJ0aWFsIHBvd2VyIGRvd24gZXhpdCBmbG93IGluIHdha2V1
cCBpbnRyLg0KPj4gICAgIHVzYjogZHdjMjogVXBkYXRlIHBvcnQgc3VzcGVuZC9yZXN1bWUgZnVu
Y3Rpb24gZGVmaW5pdGlvbnMuDQo+PiAgICAgdXNiOiBkd2MyOiBBZGQgZW50ZXIgcGFydGlhbCBw
b3dlciBkb3duIHdoZW4gcG9ydCBpcyBzdXNwZW5kZWQNCj4+ICAgICB1c2I6IGR3YzI6IEFkZCBl
eGl0IHBhcnRpYWwgcG93ZXIgZG93biB3aGVuIHBvcnQgaXMgcmVzdW1lZA0KPj4gICAgIHVzYjog
ZHdjMjogQWRkIGV4aXQgcGFydGlhbCBwb3dlciBkb3duIHdoZW4gcG9ydCByZXNldCBpcyBhc3Nl
cnRlZA0KPj4gICAgIHVzYjogZHdjMjogQWRkIHBhcnQuIHBvd2VyIGRvd24gZXhpdCBmcm9tDQo+
PiAgICAgICBkd2MyX2Nvbm5faWRfc3RhdHVzX2NoYW5nZSgpLg0KPj4gICAgIHVzYjogZHdjMjog
QWxsb3cgZXhpdCBwYXJ0aWFsIHBvd2VyIGRvd24gaW4gdXJiIGVucXVldWUNCj4+ICAgICB1c2I6
IGR3YzI6IEZpeCBzZXNzaW9uIHJlcXVlc3QgaW50ZXJydXB0IGhhbmRsZXINCj4+ICAgICB1c2I6
IGR3YzI6IFVwZGF0ZSBwYXJ0aWFsIHBvd2VyIGRvd24gZW50ZXJpbmcgYnkgc3lzdGVtIHN1c3Bl
bmQNCj4+ICAgICB1c2I6IGR3YzI6IEZpeCBwYXJ0aWFsIHBvd2VyIGRvd24gZXhpdGluZyBieSBz
eXN0ZW0gcmVzdW1lDQo+PiAgICAgdXNiOiBkd2MyOiBBZGQgZXhpdCBwYXJ0aWFsIHBvd2VyIGRv
d24gYmVmb3JlIHJlbW92aW5nIGRyaXZlcg0KPj4NCj4+ICAgIGRyaXZlcnMvdXNiL2R3YzIvY29y
ZS5jICAgICAgfCAxMTMgKystLS0tLS0tDQo+PiAgICBkcml2ZXJzL3VzYi9kd2MyL2NvcmUuaCAg
ICAgIHwgIDI3ICsrLQ0KPj4gICAgZHJpdmVycy91c2IvZHdjMi9jb3JlX2ludHIuYyB8ICA0NiAr
Ky0tDQo+PiAgICBkcml2ZXJzL3VzYi9kd2MyL2dhZGdldC5jICAgIHwgMTQ4ICsrKysrKysrKyst
DQo+PiAgICBkcml2ZXJzL3VzYi9kd2MyL2hjZC5jICAgICAgIHwgNDU4ICsrKysrKysrKysrKysr
KysrKysrKysrKystLS0tLS0tLS0tDQo+PiAgICBkcml2ZXJzL3VzYi9kd2MyL2h3LmggICAgICAg
IHwgICAxICsNCj4+ICAgIGRyaXZlcnMvdXNiL2R3YzIvcGxhdGZvcm0uYyAgfCAgMTEgKy0NCj4+
ICAgIDcgZmlsZXMgY2hhbmdlZCwgNTU4IGluc2VydGlvbnMoKyksIDI0NiBkZWxldGlvbnMoLSkN
Cj4+DQo+Pg0KPj4gYmFzZS1jb21taXQ6IGU5ZmNiMDc3MDRmY2VmNmZhNmQwMzMzZmQyYjNhNjI0
NDJlYWY0NWINCj4+DQo+IA0KPiBSZSBzZW5kaW5nIGFzIGEgInYyIiBkaWQgbm90IHdvcmsgOigu
DQo+IFRoZSBwYXRjaGVzIGFyZSBub3QgaW4gbG9yZSBhZ2Fpbi4NCj4gDQo+IENvdWxkIHRoZSBp
c3N1ZSBiZSB3aXRoIGEgY29tbWEgaW4gdGhlIGVuZCBvZiBUbzogb3IgQ2M6IGxpc3Q/DQo+IExl
dCBtZSByZW1vdmUgdGhlIGNvbW1hIGluIHRoZSBlbmQgb2YgdGhvc2UgbGlzdHMgYW5kIHRyeSBz
ZW5kaW5nIGFzICJ2MyIuDQo+IA0KPiBSZWdhcmRzLA0KPiBBcnR1cg0KPiANCg0KSSBqdXN0IHJl
bW92ZWQgdGhlIGNvbW1hIGluIHRoZSBlbmQgb2YgdGhvc2UgbGlzdHMgYW5kIHJlc2VudCB0aGUg
cGF0Y2ggDQpzZXQgYXMgYSAidjMiIGFuZCB0aGV5IGFyZSBhbHJlYWR5IHNlZW4gaW4gbG9yZS4N
ClRoZXJlIGlzIG9uZSBzdHJhbmdlIHRoaW5nIHRob3VnaCBvbiBsb3JlLiBTb21lIHBhdGNoIHRp
dGxlcyBhcmUgbm90IA0KZnVsbHkgdmlzaWJsZS4NCg0KRm9yIHN1cmUgdGhlIGlzc3VlIHdhcyBj
b21tYSBpbiB0aGUgZW5kIG9mIFRvOiBvciBDYzogbGlzdHMuDQpOb3Qgd29ya2luZyBleGFtcGxl
Lg0KVG86IEdyZWcgS3JvYWgtSGFydG1hbiA8Z3JlZ2toQGxpbnV4Zm91bmRhdGlvbi5vcmc+LCAN
CmxpbnV4LXVzYkB2Z2VyLmtlcm5lbC5vcmcsIGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcs
DQoNCldvcmtpbmcgZXhhbXBsZS4NClRvOiBHcmVnIEtyb2FoLUhhcnRtYW4gPGdyZWdraEBsaW51
eGZvdW5kYXRpb24ub3JnPiwgDQpsaW51eC11c2JAdmdlci5rZXJuZWwub3JnLCBsaW51eC1rZXJu
ZWxAdmdlci5rZXJuZWwub3JnDQoNCklmIHRoZSBjb21tYSBpcyBhdCBsZWFzdCBpbiB0aGUgZW5k
IG9mIG9uZSBvZiB0aG9zZSBsaXN0cyAoVG86IG9yIENjOikgDQp2Z2VyLmtlcm5lbC5vcmcgbWFp
bGluZyBzZXJ2ZXIgd2lsbCBub3QgYWNjZXB0IHRoZW0uDQoNClJlZ2FyZHMsDQpBcnR1cg0K
