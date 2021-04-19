Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADF88364AC5
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 21:49:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241684AbhDSTuE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 15:50:04 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.73.133]:43726 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239346AbhDSTuA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Apr 2021 15:50:00 -0400
Received: from mailhost.synopsys.com (badc-mailhost1.synopsys.com [10.192.0.17])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 6825B40131;
        Mon, 19 Apr 2021 19:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1618861768; bh=Cx3q6RbrOkvBIxwzVWXJ1Q7bm3jjvnd3FqM4PwXiYhI=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=DmzTD07EOPTJi3RqwPOZb8h2jbRnJkjv9zzzx4Ib2SPq2J6r3W2WgtrohrgmdtFia
         GkgRDhc5/X2+cA34AEBhDB8/Z8EbxVAMgbRSbHYeuVcF8KYaxcqyF4x7mZ72Zsak6B
         sc8/4HzP7A/mXTPSDV2AL+sn2lzW44/1CuQh1DvSG93lZ8e7Yl4i7AN5IY+9icay/q
         +tHMBmKWLKbapkOYO1bWCGkNJS5awLoSxXL+uwtXnAPvEEHdOpjTHUSR1Ut5VX/Nd9
         mBjt/dBZUP0J14Tfufq7Epo+9zHnnB3QI82vGmuAigcWrp5mC5CpnG9jZsyqtLIuqJ
         e8W28RuJnOtEw==
Received: from o365relay-in.synopsys.com (sv2-o365relay3.synopsys.com [10.202.1.139])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 4074DA0071;
        Mon, 19 Apr 2021 19:49:26 +0000 (UTC)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.protection.outlook.com", Issuer "DigiCert Cloud Services CA-1" (verified OK))
        by o365relay-in.synopsys.com (Postfix) with ESMTPS id 996EC4013F;
        Mon, 19 Apr 2021 19:49:25 +0000 (UTC)
Authentication-Results: o365relay-in.synopsys.com; dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relay-in.synopsys.com; spf=pass smtp.mailfrom=thinhn@synopsys.com
Authentication-Results: o365relay-in.synopsys.com;
        dkim=pass (1024-bit key; unprotected) header.d=synopsys.com header.i=@synopsys.com header.b="sl4dbNQg";
        dkim-atps=neutral
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NKZGDjJ0b0WhbIUqj1zRdkZIE2nsZ3nXs8zcJdq6iQqVJyRwLsvHDn/SFvxarSkeoUZJ+2f3kWnKdX9OyQnMnWL+Szdunt46f/o1q3Bk9QjJvfNNBQcTL1ge5EQDOIP7qdiRNzbDQPsa7CTRFD+2bms8DOSLpAFShDWsLrx/nRcNgQH9X3ojJQPt6WKxfwAIRaM2Vv18XHFaEwYS1+qnqyYN32U4hy73JfOtqLk18wCVU1/N6WkjF0ZGCC7Thgwe7ymPLHHCqwi5VCFl3lW3yAfMoPU6qw0thQv/6v0knUUN+2frAC9TK06oDHMUI+aMDSAK8BFF05wSpx84t+7OQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cx3q6RbrOkvBIxwzVWXJ1Q7bm3jjvnd3FqM4PwXiYhI=;
 b=OIe3yjPj3ghtvByEJzfYttSOJCEznPok3uZPS1BXVlP4Kl55KtwXV5Rk8ANCGvcNOpOR8qFohB9CnO27m4Oh/hnCeFqGw07oqhvJjz/5th+xzBsEuT0n2wlD71bo+Z0Ad0x80ah4UIXGsGLariAD2DUmjSMWKHFFhqWy8MKjHg1IEoNJlNxh81leQdwwmfqbkzUbUFMhpNkrU/VtCpVy/bMv6T456j5EMG82BfW7oRT+l145ivWKgkQGxW+f/lz7rT6/X6EzZuV8x7CvbnpZNwPduJJ1NIUYS5Yn4j4V2L+PjF2E6ZmovhKPv469kjJBo7Tum3B0a1HTrjae0W3wQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cx3q6RbrOkvBIxwzVWXJ1Q7bm3jjvnd3FqM4PwXiYhI=;
 b=sl4dbNQgE+BqxQC2bk2xJPfbVRM11ZtAKYvX12C5ZxRVzd20qIj+yF/agbdva2NgLckYJ/nTXdjzPFSexJg2/f3S4T86nPrkw6Eu2zZU+7ozwGHP+IAF06knhyQdImpbngebZgxOHlJWWPw8QHQbFImlOQorXTxp9XZRrBfUc44=
Received: from BYAPR12MB4791.namprd12.prod.outlook.com (2603:10b6:a03:10a::12)
 by BY5PR12MB4050.namprd12.prod.outlook.com (2603:10b6:a03:207::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Mon, 19 Apr
 2021 19:49:23 +0000
Received: from BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::7c97:6a33:14c4:dd8c]) by BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::7c97:6a33:14c4:dd8c%6]) with mapi id 15.20.4042.024; Mon, 19 Apr 2021
 19:49:23 +0000
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
To:     Felipe Balbi <balbi@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux USB List <linux-usb@vger.kernel.org>,
        John Youn <John.Youn@synopsys.com>,
        stable <stable@vger.kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Wesley Cheng <wcheng@codeaurora.org>,
        Ferry Toth <fntoth@gmail.com>, Yu Chen <chenyu56@huawei.com>
Subject: Re: [PATCH v3] usb: dwc3: core: Do core softreset when switch mode
Thread-Topic: [PATCH v3] usb: dwc3: core: Do core softreset when switch mode
Thread-Index: AQHXMkWV7LsE5m94VkyJIYRuvRhHs6q29zcAgACUfoCAAALsAIAAFgQAgACbnICABAVlAA==
Date:   Mon, 19 Apr 2021 19:49:23 +0000
Message-ID: <f3b7cb62-9365-f276-c862-2b42466c265e@synopsys.com>
References: <2cb4e704b059a8cc91f37081c8ceb95c6492e416.1618503587.git.Thinh.Nguyen@synopsys.com>
 <374440f8dcd4f06c02c2caf4b1efde86774e02d9.1618521663.git.Thinh.Nguyen@synopsys.com>
 <87zgxymrph.fsf@kernel.org>
 <CALAqxLUQn+m_JsjVrMSDc+Z=Ezo3jDD1e22ey7SZsruoEfQLjg@mail.gmail.com>
 <2a990344-8d57-2ab5-b5c5-3e6b43698f93@synopsys.com>
 <CALAqxLUgKsJS5Hy=N1KDNP7+v1Y0TxW19m9iD0S4ySq-5qhgjQ@mail.gmail.com>
 <87k0p1mnr4.fsf@kernel.org>
In-Reply-To: <87k0p1mnr4.fsf@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=synopsys.com;
x-originating-ip: [98.248.94.126]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9e061f60-0372-4646-a671-08d9036c3b0f
x-ms-traffictypediagnostic: BY5PR12MB4050:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR12MB405000C5F6E2F23CEA243C09AA499@BY5PR12MB4050.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mBY0XBdgQhKlIdyiYsgUa0AywwFbWMrIZa3tBHhtJ6icGSPSvkalW1WN48hbMhMiw901COtEFtog4BXFsESaJvJnwR8NtMkoHsP1sJdjg/JGFWj0SVF/+Oh+S5SK5yh8RhrESNI7iOeKGTojA74TK4Z4f53OC/gZRnUM6zVv/JvCJX5uBMqfeBY5Q6Y4cSz6Psek1SQSV4Ch4XQomMUdCzrydTwRW7VPge5Tfi3SqzyhN70VtMr2qJggXUGQXBl6sqlA4QEqW1sfWwk3DfMwCM1SgNGcl9gTb80Qm2jKRHt1DfElZQ3tq6Q4aIEbYJOFfWkzbmmQff/XGfqYxFnDNa1cKI5eV8E30GGCR60/NKur7JZA5G5WST8mgrPk7YUAPy1Z2HEaaUiPy2PaH2GHfvNimQ6tMoN3t+pUIoM9+0nBd34B9tBBscpr51a4MEgWFgXxiwasllfopj9GxxJOKkpz/jo1y/dsf//lXOT7k+su3o9DhJQRbyWF4PTxv9y7f5iXQcxdI6VuAOgEAeIgZTRLLxTg5W9Yw8JK6OCT8Ix5PDOHvqqVOWpBOIhWoeqMapwCr+Zi86EplI1wgwRGtXZb1N8zzEx4Od53kQv2fexMjx4rVy89jykRIOORhXAO7RlwU0i5B8zHbzjrxK4hXZ5eF9Dnsvz+84ekZioQGxDpv4T3Gt4iPVkwImenEWCdsvmQImg8kbW5eqAidvjimG5xJqfceWAIOq3UGvnRyk0S6wdmfehjtnASWaMOPzGqO5MaasENKFroIX3cc/L3mQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4791.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(39860400002)(346002)(136003)(376002)(5660300002)(6512007)(6486002)(36756003)(2616005)(31686004)(66446008)(6506007)(53546011)(86362001)(83380400001)(4326008)(54906003)(64756008)(8676002)(66556008)(478600001)(122000001)(66476007)(71200400001)(966005)(76116006)(38100700002)(26005)(66946007)(2906002)(186003)(110136005)(8936002)(316002)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?Vjc1eis2YzVralJtQk1QUm9MNkdVeGNNZVMwekxTZ3ArUmRXbStnblJjZHNB?=
 =?utf-8?B?MWF1ZzZSV3BmRzUyUURTWUtXOVQrTmwrRVR4THNuakNRNkhWQ3F2amtqTHhT?=
 =?utf-8?B?bXl6T3dEY3BUTnFzWW5KOWo1MXNYL3NHa1hvWTg3UUJzcUZGQ1RYS09zTW4x?=
 =?utf-8?B?Ri9EZ0hYamhFMHY4TjZmNG1Ib1Rud04zOTNBZmM4amtMWklFZkpHSm5LUUVY?=
 =?utf-8?B?YVd2QjNMcFhJclE3cXBXWVR5bHRPN2RmWkgvVnFna3lVdmNuWFZFZnV0UFQ2?=
 =?utf-8?B?V1VYQTNJOFJNYnNMUXVNZDJlWlVNZHNud0F5dDAzaklidytjZ200Q2I0UlNO?=
 =?utf-8?B?TVVFRUVZVC9xa3dVLzkzTkVSMTJkVGtZekQzZjVCZHExbkpDZU5YbjkvVk9C?=
 =?utf-8?B?RHArVmhYQUhqRVB1VG1IMG5EOHJnbTEwQkdPTXl6UittcERsTkRycHZ1WWlp?=
 =?utf-8?B?TityMks4UHNTNU9zQUxMc1hFbmlCRmJBN2JTSTg4UlQwc2hWVjEyWkZ0dk52?=
 =?utf-8?B?aytUMWNJSXVUVlBMTVVJRWU1QmplaEpIUERTRkMxaGx1ZmJja0VicERkQU9X?=
 =?utf-8?B?cFFUY0IzdFI4cDZPNHZvMGlaUUhydWgyS3ltUmdaWTJ0azdLVDJ0VHcveVdw?=
 =?utf-8?B?bmYxT0FsaGErTk1OaEFrdlJ5dkI4WGpDNG9CM09PZ1pjNlFYRVB1VmJLQzFn?=
 =?utf-8?B?MlpvRThwT2t4R0llS3VyRThvVm1MdFRxY0x6dE5GbFFSNWRveXpiVW5Cbkdh?=
 =?utf-8?B?bnZ1VmtPL2NXRW8xMWhGclE0ZGFEOUt2V084VEF4cGxPdVRFbldCWmZtUW5F?=
 =?utf-8?B?aXgrcjBkZkhoUmQ5NU9pTGhiajAvWTV0VS9YVDJ4SVgwd1JXWUIyRlNTRjRQ?=
 =?utf-8?B?UU5QeTM2N3NvcjBRY0ZxYitQTkhiYzdtVWZBU2dQT0xxenVyMlhNejYrQjFB?=
 =?utf-8?B?ZG91SEJaRG90MmliVGFYQlFIaWxLL0F2Rmo0bGZpQkdzS3ZrWUU4TVowUUF0?=
 =?utf-8?B?UW5wbVdCMHd6VVpJcEsvejhOV0JIUHlwWEM4QnhrTWFLbnhDdUpxeXdEaHBU?=
 =?utf-8?B?b3IzNmZXOEVETWRCUGhqNUZ4OGFOVVJBNHEwNE04Qmgxd1lNcWFSTGlKY3N2?=
 =?utf-8?B?QlJmcUtmM0ozeUxBNGtiNXg1bzNRd29WQjJQamVQVHFTOUJ5TW50VnNQWGV4?=
 =?utf-8?B?NStSMGlZQUVyRWs2ZTBiSFRlU25OQXN1QldmOU5kWVpvb0VrMzNPQTJZWU1V?=
 =?utf-8?B?T3gwc1FMSEREOTVnaStrRWRpdW9RSUhZMStaS2ZJOUU4ZGZjQXRCdGJDQyti?=
 =?utf-8?B?RlVrQkhoRXlvM2hIY04wOVEvVExvQ2dvVHZTblk0bDhVUTZzRERIcWFUUG5x?=
 =?utf-8?B?TzRmQXhCUnNPVCtPK3F1Vk80UklIcDZrQTlmTC9BWVFsYnpjMTRZQXQxOWUw?=
 =?utf-8?B?aGhYcnE1T2J3YU1LM1UzcWZ4cURvcjdKd1NNYXZva3M0c0VpczkyellaVGNB?=
 =?utf-8?B?SEJQazdRdnJ1Sk9iYXQ3UzRMWkF1QTVHZ1NUTll2Z0I0M1FaWVhxdVRQZHpw?=
 =?utf-8?B?WTloaWNvMHJ0UG40VVFtbnJoRFVBY1pQRnVqaFFoYW1BN2JEQWNybk1LM0xp?=
 =?utf-8?B?TFpYTnBBQ0t0cXlaZW5LbUowb2pHZXBXTUwvUmhsbVlnL1VRbUNtRmY0RzVV?=
 =?utf-8?B?QVRBU3psWElzTWNKYmtBVGFGVlNKZVJUSVZzTVo1cCtGYTJ3UDNETVZEejh5?=
 =?utf-8?Q?mz/kWTJbDnLo7XeTheN0q4LFbekaQo3muXiuD/H?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C660CFA0C584A54CA59049E73FBE9ADD@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4791.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e061f60-0372-4646-a671-08d9036c3b0f
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Apr 2021 19:49:23.0309
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ky1Fg85K2je1D7jsvct+BZjPCeYw6Iwgo6IXNk2Rt5j3GVqP6UTqgJ9rVLJZ5gn8z7Wcu1MGAkVPa/DFH3VwuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4050
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

RmVsaXBlIEJhbGJpIHdyb3RlOg0KPiANCj4gSGksDQo+IA0KPiBKb2huIFN0dWx0eiA8am9obi5z
dHVsdHpAbGluYXJvLm9yZz4gd3JpdGVzOg0KPj4gT24gRnJpLCBBcHIgMTYsIDIwMjEgYXQgMTI6
NDkgUE0gVGhpbmggTmd1eWVuIDxUaGluaC5OZ3V5ZW5Ac3lub3BzeXMuY29tPiB3cm90ZToNCj4+
Pg0KPj4+IEpvaG4gU3R1bHR6IHdyb3RlOg0KPj4+PiBPbiBGcmksIEFwciAxNiwgMjAyMSBhdCAz
OjQ3IEFNIEZlbGlwZSBCYWxiaSA8YmFsYmlAa2VybmVsLm9yZz4gd3JvdGU6DQo+Pj4+Pg0KPj4+
Pj4NCj4+Pj4+IEhpLA0KPj4+Pj4NCj4+Pj4+IFRoaW5oIE5ndXllbiA8VGhpbmguTmd1eWVuQHN5
bm9wc3lzLmNvbT4gd3JpdGVzOg0KPj4+Pj4NCj4+Pj4+PiBGcm9tOiBZdSBDaGVuIDxjaGVueXU1
NkBodWF3ZWkuY29tPg0KPj4+Pj4+IEZyb206IEpvaG4gU3R1bHR6IDxqb2huLnN0dWx0ekBsaW5h
cm8ub3JnPg0KPj4+Pj4+DQo+Pj4+Pj4gQWNjb3JkaW5nIHRvIHRoZSBwcm9ncmFtbWluZyBndWlk
ZSwgdG8gc3dpdGNoIG1vZGUgZm9yIERSRCBjb250cm9sbGVyLA0KPj4+Pj4+IHRoZSBkcml2ZXIg
bmVlZHMgdG8gZG8gdGhlIGZvbGxvd2luZy4NCj4+Pj4+Pg0KPj4+Pj4+IFRvIHN3aXRjaCBmcm9t
IGRldmljZSB0byBob3N0Og0KPj4+Pj4+IDEuIFJlc2V0IGNvbnRyb2xsZXIgd2l0aCBHQ1RMLkNv
cmVTb2Z0UmVzZXQNCj4+Pj4+PiAyLiBTZXQgR0NUTC5QcnRDYXBEaXIoaG9zdCBtb2RlKQ0KPj4+
Pj4+IDMuIFJlc2V0IHRoZSBob3N0IHdpdGggVVNCQ01ELkhDUkVTRVQNCj4+Pj4+PiA0LiBUaGVu
IGZvbGxvdyB1cCB3aXRoIHRoZSBpbml0aWFsaXppbmcgaG9zdCByZWdpc3RlcnMgc2VxdWVuY2UN
Cj4+Pj4+Pg0KPj4+Pj4+IFRvIHN3aXRjaCBmcm9tIGhvc3QgdG8gZGV2aWNlOg0KPj4+Pj4+IDEu
IFJlc2V0IGNvbnRyb2xsZXIgd2l0aCBHQ1RMLkNvcmVTb2Z0UmVzZXQNCj4+Pj4+PiAyLiBTZXQg
R0NUTC5QcnRDYXBEaXIoZGV2aWNlIG1vZGUpDQo+Pj4+Pj4gMy4gUmVzZXQgdGhlIGRldmljZSB3
aXRoIERDVEwuQ1NmdFJzdA0KPj4+Pj4+IDQuIFRoZW4gZm9sbG93IHVwIHdpdGggdGhlIGluaXRp
YWxpemluZyByZWdpc3RlcnMgc2VxdWVuY2UNCj4+Pj4+Pg0KPj4+Pj4+IEN1cnJlbnRseSB3ZSdy
ZSBtaXNzaW5nIHN0ZXAgMSkgdG8gZG8gR0NUTC5Db3JlU29mdFJlc2V0IGFuZCBzdGVwIDMpIG9m
DQo+Pj4+Pj4gc3dpdGNoaW5nIGZyb20gaG9zdCB0byBkZXZpY2UuIEpvaG4gU3R1bHQgcmVwb3J0
ZWQgYSBsb2NrdXAgaXNzdWUgc2Vlbg0KPj4+Pj4+IHdpdGggSGlLZXk5NjAgcGxhdGZvcm0gd2l0
aG91dCB0aGVzZSBzdGVwc1sxXS4gU2ltaWxhciBpc3N1ZSBpcyBvYnNlcnZlZA0KPj4+Pj4+IHdp
dGggRmVycnkncyB0ZXN0aW5nIHBsYXRmb3JtWzJdLg0KPj4+Pj4+DQo+Pj4+Pj4gU28sIGFwcGx5
IHRoZSByZXF1aXJlZCBzdGVwcyBhbG9uZyB3aXRoIHNvbWUgZml4ZXMgdG8gWXUgQ2hlbidzIGFu
ZCBKb2huDQo+Pj4+Pj4gU3R1bHR6J3MgdmVyc2lvbi4gVGhlIG1haW4gZml4ZXMgdG8gdGhlaXIg
dmVyc2lvbnMgYXJlIHRoZSBtaXNzaW5nIHdhaXQNCj4+Pj4+PiBmb3IgY2xvY2tzIHN5bmNocm9u
aXphdGlvbiBiZWZvcmUgY2xlYXJpbmcgR0NUTC5Db3JlU29mdFJlc2V0IGFuZCBvbmx5DQo+Pj4+
Pj4gYXBwbHkgRENUTC5DU2Z0UnN0IHdoZW4gc3dpdGNoaW5nIGZyb20gaG9zdCB0byBkZXZpY2Uu
DQo+Pj4+Pj4NCj4+Pj4+PiBbMV0gaHR0cHM6Ly91cmxkZWZlbnNlLmNvbS92My9fX2h0dHBzOi8v
bG9yZS5rZXJuZWwub3JnL2xpbnV4LXVzYi8yMDIxMDEwODAxNTExNS4yNzkyMC0xLWpvaG4uc3R1
bHR6QGxpbmFyby5vcmcvX187ISFBNEYyUjlHX3BnIUw0VExiMjVOa3EwREYycXJDUFdXMTNQVXE0
aWRoRG41UVNaaGd2blZBeTd3SmlZRk9TU291U3B0d285bk96SWRQRDRqJA0KPj4+Pj4+IFsyXSBo
dHRwczovL3VybGRlZmVuc2UuY29tL3YzL19faHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGludXgt
dXNiLzBiYTdhNmJhLWU2YTctOWNkNC0wNjk1LTY0ZmM5MjdlMDFmMUBnbWFpbC5jb20vX187ISFB
NEYyUjlHX3BnIUw0VExiMjVOa3EwREYycXJDUFdXMTNQVXE0aWRoRG41UVNaaGd2blZBeTd3SmlZ
Rk9TU291U3B0d285bk8yMVZUOHE3JA0KPj4+Pj4+DQo+Pj4+Pj4gQ2M6IEFuZHkgU2hldmNoZW5r
byA8YW5keS5zaGV2Y2hlbmtvQGdtYWlsLmNvbT4NCj4+Pj4+PiBDYzogRmVycnkgVG90aCA8Zm50
b3RoQGdtYWlsLmNvbT4NCj4+Pj4+PiBDYzogV2VzbGV5IENoZW5nIDx3Y2hlbmdAY29kZWF1cm9y
YS5vcmc+DQo+Pj4+Pj4gQ2M6IDxzdGFibGVAdmdlci5rZXJuZWwub3JnPg0KPj4+Pj4+IEZpeGVz
OiA0MWNlMTQ1NmUxZGIgKCJ1c2I6IGR3YzM6IGNvcmU6IG1ha2UgZHdjM19zZXRfbW9kZSgpIHdv
cmsgcHJvcGVybHkiKQ0KPj4+Pj4+IFNpZ25lZC1vZmYtYnk6IFl1IENoZW4gPGNoZW55dTU2QGh1
YXdlaS5jb20+DQo+Pj4+Pj4gU2lnbmVkLW9mZi1ieTogSm9obiBTdHVsdHogPGpvaG4uc3R1bHR6
QGxpbmFyby5vcmc+DQo+Pj4+Pj4gU2lnbmVkLW9mZi1ieTogVGhpbmggTmd1eWVuIDxUaGluaC5O
Z3V5ZW5Ac3lub3BzeXMuY29tPg0KPj4+Pj4NCj4+Pj4+IEkgc3RpbGwgaGF2ZSBjb25jZXJucyBh
Ym91dCB0aGUgc29mdCByZXNldCwgYnV0IEkgd29uJ3QgYmxvY2sgeW91IGd1eXMNCj4+Pj4+IGZy
b20gZml4aW5nIEhpa2V5J3MgcHJvYmxlbSA6LSkNCj4+Pj4+DQo+Pj4+PiBUaGUgb25seSB0aGlu
ZyBJIHdvdWxkIGxpa2UgdG8gY29uZmlybSBpcyB0aGF0IHRoaXMgaGFzIGJlZW4gdmVyaWZpZWQN
Cj4+Pj4+IHdpdGggaHVuZHJlZHMgb2Ygc3dhcHMgaGFwcGVuaW5nIGFzIHF1aWNrbHkgYXMgcG9z
c2libGUuIERXQzMgc2hvdWxkDQo+Pj4+PiBzdGlsbCBiZSBmdW5jdGlvbmFsIGFmdGVyIHNldmVy
YWwgaHVuZHJlZCBzd2Fwcy4NCj4+Pj4+DQo+Pj4+PiBDYW4gc29tZW9uZSBjb25maXJtIHRoaXMg
aXMgdGhlIGNhc2U/IChJJ20gYXNzdW1pbmcgdGhpcyBjYW4gYmUNCj4+Pj4+IHNjcmlwdGVkKQ0K
Pj4+Pg0KPj4+PiBJIHVuZm9ydHVuYXRlbHkgZG9uJ3QgaGF2ZSBhbiBlYXN5IHdheSB0byBhdXRv
bWF0ZSB0aGUgc3dpdGNoaW5nIHJpZ2h0DQo+Pj4+IG9mZi4gQnV0IEknbGwgdHJ5IHRvIGhhY2sg
dXAgdGhlIG11eCBzd2l0Y2ggZHJpdmVyIHRvIHByb3ZpZGUgYW4NCj4+Pj4gaW50ZXJmYWNlIHdl
IGNhbiBzY3JpcHQgYWdhaW5zdC4NCj4+Pj4NCj4+Pg0KPj4+IEZZSSwgeW91IGNhbiBkbyB0aGUg
Zm9sbG93aW5nOg0KPj4+DQo+Pj4gMSkgRW5hYmxlICJ1c2Itcm9sZS1zd2l0Y2giIERUIHByb3Bl
cnR5IGlmIG5vdCBhbHJlYWR5IGRvbmUgc28NCj4+PiAyKSBBZGQgdXNlcnNwYWNlIGNvbnRyb2w6
DQo+Pj4NCj4+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy91c2IvZHdjMy9kcmQuYyBiL2RyaXZlcnMv
dXNiL2R3YzMvZHJkLmMNCj4+PiBpbmRleCBlMmI2OGJiNzcwZDEuLmIyMDNlM2Q4NzI5MSAxMDA2
NDQNCj4+PiAtLS0gYS9kcml2ZXJzL3VzYi9kd2MzL2RyZC5jDQo+Pj4gKysrIGIvZHJpdmVycy91
c2IvZHdjMy9kcmQuYw0KPj4+IEBAIC01NTUsNiArNTU1LDcgQEAgc3RhdGljIGludCBkd2MzX3Nl
dHVwX3JvbGVfc3dpdGNoKHN0cnVjdCBkd2MzICpkd2MpDQo+Pj4gICAgICAgICAgICAgICAgIG1v
ZGUgPSBEV0MzX0dDVExfUFJUQ0FQX0RFVklDRTsNCj4+PiAgICAgICAgIH0NCj4+Pg0KPj4+ICsg
ICAgICAgZHdjM19yb2xlX3N3aXRjaC5hbGxvd191c2Vyc3BhY2VfY29udHJvbCA9IHRydWU7DQo+
Pj4gICAgICAgICBkd2MzX3JvbGVfc3dpdGNoLmZ3bm9kZSA9IGRldl9md25vZGUoZHdjLT5kZXYp
Ow0KPj4+ICAgICAgICAgZHdjM19yb2xlX3N3aXRjaC5zZXQgPSBkd2MzX3VzYl9yb2xlX3N3aXRj
aF9zZXQ7DQo+Pj4gICAgICAgICBkd2MzX3JvbGVfc3dpdGNoLmdldCA9IGR3YzNfdXNiX3JvbGVf
c3dpdGNoX2dldDsNCj4+Pg0KPj4+IDMpIFdyaXRlIGEgc2NyaXB0IHRvIGRvIHRoZSBmb2xsb3dp
bmc6DQo+Pj4NCj4+PiAjIGVjaG8gaG9zdCA+IC9zeXMvY2xhc3MvdXNiX3JvbGUvPFVEQz4vcm9s
ZQ0KPj4+DQo+Pj4gYW5kDQo+Pj4NCj4+PiAjIGVjaG8gZGV2aWNlID4gL3N5cy9jbGFzcy91c2Jf
cm9sZS88VURDPi9yb2xlDQo+Pg0KPj4gVGhhbmtzIHNvIG11Y2ggZm9yIHRoaXMuIFNvIEkgcmFu
IGJvdGggb2YgdGhvc2UgY29tbWFuZHMgaW4gYSB3aGlsZQ0KPj4gbG9vcCBmb3IgYXdoaWxlIGFu
ZCBkaWRuJ3Qgc2VlIGFueSB0cm91YmxlLg0KPj4NCj4+IEhpS2V5OTYwIGlzIGludGVyZXN0aW5n
IGFzIHdlbGwgYmVjYXVzZSB3ZSBoYXZlIGEgbXV4IHN3aXRjaCwgd2hpY2ggaXMNCj4+IHNvcnQg
b2YgYW4gaW50ZXJtZWRpYXJ5IHJvbGwgc3dpdGNoZXIgKGl0IGdldHMgdGhlIHJvbGUgc3dpdGNo
IHNpZ25hbA0KPj4gZnJvbSB0aGUgdGNwY2lfcnQxNzExaCwgdHdlYWtzIHNvbWUgZ3Bpb3MgYW5k
IHRoZW4gc2lnbmFscyB0aGUgZHdjMykuDQo+PiBTbyBJIGFsc28gZGlkIHRoZSBhYm92ZSB0d2Vh
a3MgdG8gdGhlIG11eC1zd2l0Y2ggYW5kIGhhZCBpdCBzd2l0Y2hpbmcNCj4+IGJldHdlZW4gZGV2
aWNlL25vbmUgYW5kIHZhbGlkYXRlZCB0aGUgb25ib2FyZCBodWIgY2FtZSB1cCBhbmQgZG93bg0K
Pj4gYWxvbmcgd2l0aCB0aGUgZHdjMyBjb3JlLg0KPj4NCj4+IEV2ZXJ5dGhpbmcgc3RpbGwgbG9v
a3MgZ29vZCBoZXJlLg0KPiANCj4gU291bmRzIGdvb2QsIGhhcHB5IHRvIHNlZSBzbyBtYW55IHBs
YXRmb3JtcyBzdXBwb3J0ZWQgYnkgVGhpbmgncw0KPiBjaGFuZ2UuIFRoYW5rcyBmb3IgZG9pbmcg
dGhpcyB3b3JrLCBUaGluaCA6LSkNCj4gDQoNClRoYW5rcyBmb3IgdGhlIHJldmlldyBGZWxpcGUg
OikNCg0KVGhpbmgNCg==
