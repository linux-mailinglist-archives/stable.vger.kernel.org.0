Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 821A236386C
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 01:03:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232484AbhDRXEI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Apr 2021 19:04:08 -0400
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:40918 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236006AbhDRXEI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Apr 2021 19:04:08 -0400
Received: from mailhost.synopsys.com (sv1-mailhost2.synopsys.com [10.205.2.132])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 7BE71C0558;
        Sun, 18 Apr 2021 23:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1618787019; bh=E3lPzqUkfTh+nMvLeG+9SYUAzmflKDqvYrBOxXtwHPM=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=cYCSOAwwwM4+2GHI1P8VLVhoaAKBceZVDSSVX4mQZIrhHBghhslgotVaG388MTki4
         xAXxxe+7wgL2l4r0sVBbZJyU3O5HAdHaRQXGrHVMjfgwc9zjM+7mhID/Z04vsTvhQe
         2uXOvqFrXX1c4JVgyZXnn0AClOF5vcBkQkky9zgSKVV18sABErQ4FflAYaHz3RsA2D
         g/oYvuyFl6bJ7aJjMbUrMSk58P+FrEX2mptJUXI5TMyRGDaY/Zn0PQkr1bpLv8IH5T
         LO5MaOCq/UtiGC7qGUgcF0dfr+5WogpDVX9w1KqSX/ixLg68NWSuBVWPpiww3hCDNw
         KkAVPxxXbstIw==
Received: from o365relay-in.synopsys.com (sv2-o365relay3.synopsys.com [10.202.1.139])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id DE184A0070;
        Sun, 18 Apr 2021 23:03:36 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2172.outbound.protection.outlook.com [104.47.55.172])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.protection.outlook.com", Issuer "DigiCert Cloud Services CA-1" (verified OK))
        by o365relay-in.synopsys.com (Postfix) with ESMTPS id 3BF5C40145;
        Sun, 18 Apr 2021 23:03:35 +0000 (UTC)
Authentication-Results: o365relay-in.synopsys.com; dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relay-in.synopsys.com; spf=pass smtp.mailfrom=thinhn@synopsys.com
Authentication-Results: o365relay-in.synopsys.com;
        dkim=pass (1024-bit key; unprotected) header.d=synopsys.com header.i=@synopsys.com header.b="h3LTTXEv";
        dkim-atps=neutral
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iU9eNJDe0u5HAwQTeN/R/ggpe4TU8nNZeH1qGK616AkbcLW8aKuVTY7ngn7v+oenOftHBPmWkRmRlpthCH9m/EcBw11EnZKhWZZj11vzw5USCyqC6t1e9nN1pXNOOvPPW4rv/0kc22Z7cjGptVPmx57CgurzwC7Na9N+hesK795e5IyLNASg/1JhcGNrBxk/HCk8vUHfTcTfSdTn7IxGCzEAqQbjm1wNFhXyGTAR2wRSYqLUXlv7mumJTSpKUDSX7kLMnrAqKumk7+tmP1gGZpKkEp/xsR/FaAlIgZK7E9nsx+G15KBzkfLtcH2pjFoKedPN9/HkAYCfj9Delj08JA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E3lPzqUkfTh+nMvLeG+9SYUAzmflKDqvYrBOxXtwHPM=;
 b=AdfnUr2hs5QiW+APD0eu4+fhvXMoWcIxgnpcKDqkmp1CtMZY42OFlQb8Q7AMr+hicPCeaX+nCcPaUggjZw7gufIFjj1Pk6pdj8Pwf7T6MnEk3lMPDieSHUQOPNSqsGzdwCUZfs4+Lbrz+VtOyF272l9rgyEl9AiDarDSzqCj2VcFjyAconnwwZTNhRb5bwu5g1N1TPPfPNUgYmd5ne+6Rb6Pc5sjExxKuO5HqEbpttUEqLaOjNByEZTDnb0u4Akk45AkhOXqV5XUCUfm/tu8uISCIp1f2MU3hEWtZVYh+mF377me6P7Pk6IHM6i/IgOc6wUzZeD0Ts8TM6/609O3BQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E3lPzqUkfTh+nMvLeG+9SYUAzmflKDqvYrBOxXtwHPM=;
 b=h3LTTXEvIH8jf3eLzaNNp1LNn7DgoKZKqt5H1WkTSDoBbdsa4pJvBIfc7x6orUxbGMgPHfxofBEIsTXEeLvor/+6MZ6Or5+XtL0pPd7+1lmwzs7Kpl7ifWt75iEnQTJUnJPfq89L9N0ipcLuc+D5HYrddCgApiF+fta3BhEUieo=
Received: from BYAPR12MB4791.namprd12.prod.outlook.com (2603:10b6:a03:10a::12)
 by BY5PR12MB4226.namprd12.prod.outlook.com (2603:10b6:a03:203::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.19; Sun, 18 Apr
 2021 23:03:32 +0000
Received: from BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::7c97:6a33:14c4:dd8c]) by BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::7c97:6a33:14c4:dd8c%6]) with mapi id 15.20.4042.024; Sun, 18 Apr 2021
 23:03:32 +0000
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
To:     Ferry Toth <fntoth@gmail.com>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        John Stultz <john.stultz@linaro.org>
CC:     John Youn <John.Youn@synopsys.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Wesley Cheng <wcheng@codeaurora.org>,
        Yu Chen <chenyu56@huawei.com>, Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: [PATCH v3] usb: dwc3: core: Do core softreset when switch mode
Thread-Topic: [PATCH v3] usb: dwc3: core: Do core softreset when switch mode
Thread-Index: AQHXMkWV7LsE5m94VkyJIYRuvRhHs6q2J2QAgAF/xoCAAFbPgIAAx46AgAAkXQCAAf+uAA==
Date:   Sun, 18 Apr 2021 23:03:32 +0000
Message-ID: <4a1245e3-023c-ec69-2ead-dacf5560ff9f@synopsys.com>
References: <2cb4e704b059a8cc91f37081c8ceb95c6492e416.1618503587.git.Thinh.Nguyen@synopsys.com>
 <374440f8dcd4f06c02c2caf4b1efde86774e02d9.1618521663.git.Thinh.Nguyen@synopsys.com>
 <d053b843-2308-6b42-e7ff-3dc6e33e5c7d@synopsys.com>
 <0882cfae-4708-a67a-f112-c1eb0c7e6f51@gmail.com>
 <1c1d8e4a-c495-4d51-b125-c3909a3bdb44@synopsys.com>
 <db5849f7-ba31-8b18-ebb5-f27c4e36de28@gmail.com>
 <09755742-c73b-f737-01c1-8ecd309de551@gmail.com>
In-Reply-To: <09755742-c73b-f737-01c1-8ecd309de551@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=synopsys.com;
x-originating-ip: [98.248.94.126]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a2332349-0afd-4940-ee6f-08d902be304c
x-ms-traffictypediagnostic: BY5PR12MB4226:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR12MB42268980EC45F48E71828654AA4A9@BY5PR12MB4226.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5+E8zHAoRK9N8gW+RRjPXXqxO8Gk/a4R1OaLRfEh6tEVvvmqDM2FpJj+tW9VN9PsvfUhA8tOdiX5M50V4VNIzLT1gQglIweMmLqQ/qinh5cOGgxCPSOCg+r5EVGsUs6Cb47oxFPdLUXdfq+F0UEfLHawYry5r/kj5DM79OcQ1rsTbROKwLUlIfesjBgMuPMeMEgBLuiV8tFjKG1/jEJ8r90PEOQHj8nJTAMj2jlpCQFnbJpk4ERhVMRrKzORrOYaPgnaZIpfOfWkcU9Zi8iyEt/r0H57kVuMPNb34/tTsheGL3HF7Dq57LBNshmD5ebvfuXD6C8nDIdFBj/ouCqM51CGMlqOEzumytt5Ht585jM2ui+3n72QnbmxGLgIckJ3WI6k+uZRfgAnN1JJUj2pMH1i0RwEhheGDabOoS8tNgoJgAGW8xLTw+rBF5h5TFYWAKmDjmNKnseSCeANknvgISip3cxqP9zfLoykHc/1jYkrQtmL4cR1HYBaKxkwdlaztdV0kDA/gV6SBTPtt6uCPmv9SaE44CcWCwjThyQu1lZfQLYctiRQ+1/VGB3HVPo/RgpH+Ne1Vc7eCrSYaQYYLXtQ5PMoDPddxNRsrb1x+X9/ySc1GVotQ1Jhy+bjhdqJu+Vg82hhQbNDT5sIMxAZgc/J7dD53563JikjSt5QaVnxGB0LixcF1ggbE8JWWlPz3H75Yx5hoKZzzk+J6pFZZXWmvTZ/tNvwVZVdS7EeqpeMROhj2RQPhb0Gsh7rNYL2Ar+lg2Nvhpz841Lf90PZrg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4791.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(376002)(366004)(39850400004)(136003)(71200400001)(316002)(83380400001)(31686004)(6486002)(6506007)(4326008)(54906003)(186003)(26005)(110136005)(8676002)(2616005)(8936002)(478600001)(966005)(122000001)(38100700002)(6512007)(86362001)(76116006)(66946007)(66476007)(36756003)(66556008)(64756008)(66446008)(2906002)(5660300002)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?U3A5ZjI1RStwMVlnc0hTODhQSnAwdFhyTENxVGlxcnNOWTkwak5vTVZaZU00?=
 =?utf-8?B?bS9Ba2RFZWh4V2NjdWxYd1g0WjhOcmpWRitGZy9SRDg4NVZoaWZMWnlvUFZU?=
 =?utf-8?B?aE5HNUovUW9xbHg2ZHI5U2VuM2VoelkzbmxsK3JWTEp2Q1lJNnRJSjAweHF4?=
 =?utf-8?B?bVM2UmJMUFJVTXVINE5jOHVsbnFGQVNQazRERzFNN0tLNnlRN3hHTWhUMkFY?=
 =?utf-8?B?LzRLVlBCM1ErM0k0ODRWSXlpdTVqUHdzcEhEeFBkMVltTzR2Mys5cTk3Vzlp?=
 =?utf-8?B?c0VvSlk1QkZRQUpDY3V4bzgwc240MDlONGpxd2RRNE0xNVR2ZXdFTkp1T015?=
 =?utf-8?B?WnNzNFRGMWZ0aUpIL1hFT0pPWUZ3bDRsZ1VJaCszTzJTSTNKdkd6U2tXYmlp?=
 =?utf-8?B?YVh4MnVTaFBqL3lEZm8wVlBDNWR1c3dWZ29iN3VDREVPNnI1cFFwUUE0QW9W?=
 =?utf-8?B?MncvQ21BTWlDU0ovMlduaVV4T2MrMjFTSkV6a3pFdzFkR1NHTXc1S0VZbERR?=
 =?utf-8?B?bDlsZzRmeVBSY09YQVBqRkVQTHlOY0N0MGRYazVtQlY0RzFvZzUxMW13bEJr?=
 =?utf-8?B?VVBuYlh5eUxIYVdHZllKTjlFSDlZcmpFTHFDRmc1SzVTenJWdjFta1NpSXpv?=
 =?utf-8?B?T2R0MGc4MHlWK1ViMGQzNEJjRmw5V2NkOThLaXJFNU52dERFM3ZPeDBBaVV0?=
 =?utf-8?B?ZDJKNktxZU5VTkR1Wk9YMFlUaFJyVXd3OGdLaklLRHJmUC94MG5UUXl3WWRL?=
 =?utf-8?B?ekltRFJvZFhPejRpb3BLUUVXOG1IVFptZWZYS1NsNW5jSnFFVVVtcU9iZ2Vq?=
 =?utf-8?B?ckgwVWxleVFiWHN5V1QxanE3NWJlUXpIaVh5cktidHZHRE5ZY21TVndXUDI0?=
 =?utf-8?B?QmlNZ1NBOU9FcE5lTjFTUnhnMzNBU245OUtGdlE1RzczanZWc0szZnNFWW0x?=
 =?utf-8?B?bG04U0h3SjJ1YjJXYlZjN0d1UkNHUENBYVpNa3BPMXRseWVpSXIvVlRBajNU?=
 =?utf-8?B?eVF5UmYvVVhKeVl5azNuQ1hiZHBIcGZYZExhdk5uTTdPYWFXUThRNW5HanZS?=
 =?utf-8?B?VTdTWGxGbHNKTXpMR2d1R2VUaEVueVNCR1ByNzlUSm1sOEhDVTVCRFZOTGNk?=
 =?utf-8?B?czN2NERKcWt4a1hOU3ZzUURRS3JKYUFTVUFpYnRucHBkelBxc3U4RnpVZGR5?=
 =?utf-8?B?U3ZqbzBpUnpUc2VWVmx6MlVvcTlFTnF2ZGY5YnVmN1pFSXZ3WllWR0RjVDQ1?=
 =?utf-8?B?T2V0c0tvMktzSTM4Rk1PY1VPQkI1TTloQzYyNitqQ0tyMEpOY0hzNDhQVk1D?=
 =?utf-8?B?eExJY3Q3Nm9vN0VqbCtEeGtRZnBJZkE2NU9jOWlFNUliVFpkdXVqNy80T1JJ?=
 =?utf-8?B?YVg4YVBudURWWWVUUXRTRHhnL3c0MnhYK0NDV3QvS1R0TjVSV2FQTHVxZlNT?=
 =?utf-8?B?MGxhNG1IMDl0aUVXSmlWT0hRREJqSHpmNWMvMlhOVUFucUs2allJV1ZoOUpm?=
 =?utf-8?B?UHpOVFJkZThBbUxFVHA2OTVXRFVLL3Z0Rnd0T2t0TlFUbHVVMmJ4T1RIRVNI?=
 =?utf-8?B?R3BuM09aY1FYUVEvTzQwREFraXVIeUFUb2VZWVVJSjA0WHBRNUU5b0JNTmdD?=
 =?utf-8?B?UjJSY0dGN0xGS0F2V2RSTi9UV3crS1puUHMzV0V0d1JCdlVDOE5uTS90b3Nw?=
 =?utf-8?B?bTIvbEdyK1pnRUxmejhlS2o5UEk5N0loakFFdHlwSUZ5b25IbEdGb1hBU3Bp?=
 =?utf-8?Q?1JkyqUl2CeOTgEinaI=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AD6E13470C7B334F97BB6C08420A0BCF@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4791.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2332349-0afd-4940-ee6f-08d902be304c
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Apr 2021 23:03:32.5706
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NZIbWfMsQ8aO5LKEWCnDDdFry8EdqGLt6d6f7U6PFM5iD5p6X8KRxDAhongVIMy/j/GkLWUptS4fZKTOSvyYEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4226
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

RmVycnkgVG90aCB3cm90ZToNCj4gSGkNCj4gDQo+IE9wIDE3LTA0LTIwMjEgb20gMTY6MjIgc2No
cmVlZiBGZXJyeSBUb3RoOg0KPj4gSGkNCj4+DQo+PiBPcCAxNy0wNC0yMDIxIG9tIDA0OjI3IHNj
aHJlZWYgVGhpbmggTmd1eWVuOg0KPj4+IEZlcnJ5IFRvdGggd3JvdGU6DQo+Pj4+IEhpDQo+Pj4+
DQo+Pj4+IE9wIDE2LTA0LTIwMjEgb20gMDA6MjMgc2NocmVlZiBUaGluaCBOZ3V5ZW46DQo+Pj4+
PiBUaGluaCBOZ3V5ZW4gd3JvdGU6DQo+Pj4+Pj4gRnJvbTogWXUgQ2hlbiA8Y2hlbnl1NTZAaHVh
d2VpLmNvbT4NCj4+Pj4+PiBGcm9tOiBKb2huIFN0dWx0eiA8am9obi5zdHVsdHpAbGluYXJvLm9y
Zz4NCj4+Pj4+Pg0KPj4+Pj4+IEFjY29yZGluZyB0byB0aGUgcHJvZ3JhbW1pbmcgZ3VpZGUsIHRv
IHN3aXRjaCBtb2RlIGZvciBEUkQNCj4+Pj4+PiBjb250cm9sbGVyLA0KPj4+Pj4+IHRoZSBkcml2
ZXIgbmVlZHMgdG8gZG8gdGhlIGZvbGxvd2luZy4NCj4+Pj4+Pg0KPj4+Pj4+IFRvIHN3aXRjaCBm
cm9tIGRldmljZSB0byBob3N0Og0KPj4+Pj4+IDEuIFJlc2V0IGNvbnRyb2xsZXIgd2l0aCBHQ1RM
LkNvcmVTb2Z0UmVzZXQNCj4+Pj4+PiAyLiBTZXQgR0NUTC5QcnRDYXBEaXIoaG9zdCBtb2RlKQ0K
Pj4+Pj4+IDMuIFJlc2V0IHRoZSBob3N0IHdpdGggVVNCQ01ELkhDUkVTRVQNCj4+Pj4+PiA0LiBU
aGVuIGZvbGxvdyB1cCB3aXRoIHRoZSBpbml0aWFsaXppbmcgaG9zdCByZWdpc3RlcnMgc2VxdWVu
Y2UNCj4+Pj4+Pg0KPj4+Pj4+IFRvIHN3aXRjaCBmcm9tIGhvc3QgdG8gZGV2aWNlOg0KPj4+Pj4+
IDEuIFJlc2V0IGNvbnRyb2xsZXIgd2l0aCBHQ1RMLkNvcmVTb2Z0UmVzZXQNCj4+Pj4+PiAyLiBT
ZXQgR0NUTC5QcnRDYXBEaXIoZGV2aWNlIG1vZGUpDQo+Pj4+Pj4gMy4gUmVzZXQgdGhlIGRldmlj
ZSB3aXRoIERDVEwuQ1NmdFJzdA0KPj4+Pj4+IDQuIFRoZW4gZm9sbG93IHVwIHdpdGggdGhlIGlu
aXRpYWxpemluZyByZWdpc3RlcnMgc2VxdWVuY2UNCj4+Pj4+Pg0KPj4+Pj4+IEN1cnJlbnRseSB3
ZSdyZSBtaXNzaW5nIHN0ZXAgMSkgdG8gZG8gR0NUTC5Db3JlU29mdFJlc2V0IGFuZCBzdGVwDQo+
Pj4+Pj4gMykgb2YNCj4+Pj4+PiBzd2l0Y2hpbmcgZnJvbSBob3N0IHRvIGRldmljZS4gSm9obiBT
dHVsdCByZXBvcnRlZCBhIGxvY2t1cCBpc3N1ZQ0KPj4+Pj4+IHNlZW4NCj4+Pj4+PiB3aXRoIEhp
S2V5OTYwIHBsYXRmb3JtIHdpdGhvdXQgdGhlc2Ugc3RlcHNbMV0uIFNpbWlsYXIgaXNzdWUgaXMN
Cj4+Pj4+PiBvYnNlcnZlZA0KPj4+Pj4+IHdpdGggRmVycnkncyB0ZXN0aW5nIHBsYXRmb3JtWzJd
Lg0KPj4+Pj4+DQo+Pj4+Pj4gU28sIGFwcGx5IHRoZSByZXF1aXJlZCBzdGVwcyBhbG9uZyB3aXRo
IHNvbWUgZml4ZXMgdG8gWXUgQ2hlbidzDQo+Pj4+Pj4gYW5kIEpvaG4NCj4+Pj4+PiBTdHVsdHon
cyB2ZXJzaW9uLiBUaGUgbWFpbiBmaXhlcyB0byB0aGVpciB2ZXJzaW9ucyBhcmUgdGhlIG1pc3Np
bmcNCj4+Pj4+PiB3YWl0DQo+Pj4+Pj4gZm9yIGNsb2NrcyBzeW5jaHJvbml6YXRpb24gYmVmb3Jl
IGNsZWFyaW5nIEdDVEwuQ29yZVNvZnRSZXNldCBhbmQNCj4+Pj4+PiBvbmx5DQo+Pj4+Pj4gYXBw
bHkgRENUTC5DU2Z0UnN0IHdoZW4gc3dpdGNoaW5nIGZyb20gaG9zdCB0byBkZXZpY2UuDQo+Pj4+
Pj4NCj4+Pj4+PiBbMV0NCj4+Pj4+PiBodHRwczovL3VybGRlZmVuc2UuY29tL3YzL19faHR0cHM6
Ly9sb3JlLmtlcm5lbC5vcmcvbGludXgtdXNiLzIwMjEwMTA4MDE1MTE1LjI3OTIwLTEtam9obi5z
dHVsdHpAbGluYXJvLm9yZy9fXzshIUE0RjJSOUdfcGchUFc5SmJzNHd2NGFfektHZ1pITjBGWXJJ
cGZlY1BYME91cTlWM2QxNll6LTktR1NIcVpXc2ZCQUYtV2tlcUxoek40aTMkDQo+Pj4+Pj4NCj4+
Pj4+Pg0KPj4+Pj4+IFsyXQ0KPj4+Pj4+IGh0dHBzOi8vdXJsZGVmZW5zZS5jb20vdjMvX19odHRw
czovL2xvcmUua2VybmVsLm9yZy9saW51eC11c2IvMGJhN2E2YmEtZTZhNy05Y2Q0LTA2OTUtNjRm
YzkyN2UwMWYxQGdtYWlsLmNvbS9fXzshIUE0RjJSOUdfcGchUFc5SmJzNHd2NGFfektHZ1pITjBG
WXJJcGZlY1BYME91cTlWM2QxNll6LTktR1NIcVpXc2ZCQUYtV2tlcUdlWlN0dDQkDQo+Pj4+Pj4N
Cj4+Pj4+Pg0KPj4+Pj4+DQo+Pj4+Pj4gQ2M6IEFuZHkgU2hldmNoZW5rbyA8YW5keS5zaGV2Y2hl
bmtvQGdtYWlsLmNvbT4NCj4+Pj4+PiBDYzogRmVycnkgVG90aCA8Zm50b3RoQGdtYWlsLmNvbT4N
Cj4+Pj4+PiBDYzogV2VzbGV5IENoZW5nIDx3Y2hlbmdAY29kZWF1cm9yYS5vcmc+DQo+Pj4+Pj4g
Q2M6IDxzdGFibGVAdmdlci5rZXJuZWwub3JnPg0KPj4+Pj4+IEZpeGVzOiA0MWNlMTQ1NmUxZGIg
KCJ1c2I6IGR3YzM6IGNvcmU6IG1ha2UgZHdjM19zZXRfbW9kZSgpIHdvcmsNCj4+Pj4+PiBwcm9w
ZXJseSIpDQo+Pj4+Pj4gU2lnbmVkLW9mZi1ieTogWXUgQ2hlbiA8Y2hlbnl1NTZAaHVhd2VpLmNv
bT4NCj4+Pj4+PiBTaWduZWQtb2ZmLWJ5OiBKb2huIFN0dWx0eiA8am9obi5zdHVsdHpAbGluYXJv
Lm9yZz4NCj4+Pj4+PiBTaWduZWQtb2ZmLWJ5OiBUaGluaCBOZ3V5ZW4gPFRoaW5oLk5ndXllbkBz
eW5vcHN5cy5jb20+DQo+Pj4+Pj4gLS0tDQo+Pj4+Pj4gQ2hhbmdlcyBpbiB2MzoNCj4+Pj4+PiAt
IENoZWNrIGlmIHRoZSBkZXNpcmVkIG1vZGUgaXMgT1RHLCB0aGVuIGtlZXAgdGhlIG9sZCBmbG93
DQo+Pj4+Pj4gLSBSZW1vdmUgY29uZGl0aW9uIGZvciBPVEcgc3VwcG9ydCBvbmx5IHNpbmNlIHRo
ZSBkZXZpY2UgY2FuIHN0aWxsIGJlDQo+Pj4+Pj4gwqDCoMKgIGNvbmZpZ3VyZWQgRFJEIGhvc3Qv
ZGV2aWNlIG1vZGUgb25seQ0KPj4+Pj4+IC0gUmVtb3ZlIHJlZHVuZGFudCBod19tb2RlIGNoZWNr
IHNpbmNlIF9fZHdjM19zZXRfbW9kZSgpIG9ubHkgYXBwbGllcw0KPj4+Pj4+IHdoZW4NCj4+Pj4+
PiDCoMKgwqAgaHdfbW9kZSBpcyBEUkQNCj4+Pj4+PiBDaGFuZ2VzIGluIHYyOg0KPj4+Pj4+IC0g
SW5pdGlhbGl6ZSBtdXRleCBwZXIgZGV2aWNlIGFuZCBub3QgYXMgZ2xvYmFsIG11dGV4Lg0KPj4+
Pj4+IC0gQWRkIGFkZGl0aW9uYWwgY2hlY2tzIGZvciBEUkQgb25seSBtb2RlDQo+Pj4+Pj4NCj4+
Pj4+PiDCoMKgIGRyaXZlcnMvdXNiL2R3YzMvY29yZS5jIHwgMjcgKysrKysrKysrKysrKysrKysr
KysrKysrKysrDQo+Pj4+Pj4gwqDCoCBkcml2ZXJzL3VzYi9kd2MzL2NvcmUuaCB8wqAgNSArKysr
Kw0KPj4+Pj4+IMKgwqAgMiBmaWxlcyBjaGFuZ2VkLCAzMiBpbnNlcnRpb25zKCspDQo+Pj4+Pj4N
Cj4+Pj4+IEhpIEpvaG4sDQo+Pj4+Pg0KPj4+Pj4gSWYgcG9zc2libGUsIGNhbiB5b3UgcnVuIGEg
dGVzdCB3aXRoIHRoaXMgdmVyc2lvbiBvbiB5b3VyIHBsYXRmb3JtPw0KPj4+Pj4NCj4+Pj4+IFRo
YW5rcywNCj4+Pj4+IFRoaW5oDQo+Pj4+Pg0KPj4+PiBJIHRlc3RlZCB0aGlzIG9uIGVkaXNvbi1h
cmR1aW5vIHdpdGggdGhpcyBwYXRjaCBvbiB0b3Agb2YgdXNiLW5leHQNCj4+Pj4gKDUuMTItcmM3
ICsgImluY3JlYXNlIEJFU0wgYmFzZWxpbmUgdG8gNiIgdG8gcHJldmVudCB0aHJvdHRsaW5nIiku
DQo+Pj4+DQo+Pj4+IE9uIHRoaXMgcGxhdGZvcm0gdGhlcmUgaXMgYSBwaHlzaWNhbCBzd2l0Y2gg
dG8gc3dpdGNoIHJvbGVzLiBXaXRoIHRoaXMNCj4+Pj4gcGF0Y2ggSSBmaW5kOg0KPj4+Pg0KPj4+
PiAtIHN3aXRjaCB0byBob3N0IG1vZGUgYWx3YXlzIHdvcmtzIGZpbmUNCj4+Pj4NCj4+Pj4gLSBz
d2l0Y2ggdG8gZ2FkZ2V0IG1vZGUgSSBuZWVkIHRvIGZsaXAgdGhlIHN3aXRjaCAzeA0KPj4+PiAo
Z2FkZ2V0LWhvc3QtZ2FkZ2V0KS4NCj4+Pj4NCj4+Pj4gQW4gZXJyb3IgbWVzc2FnZSBhcHBlYXJz
IG9uIHRoZSBnYWRnZXQgc2lkZSAiZHdjMyBkd2MzLjAuYXV0bzogdGltZWQNCj4+Pj4gb3V0DQo+
Pj4+IHdhaXRpbmcgZm9yIFNFVFVQIHBoYXNlIiBhcHBlYXJzLCBidXQgdGhlbiB0aGUgZGV2aWNl
IGNvbm5lY3RzIHRvIG15DQo+Pj4+IFBDLA0KPj4+PiBubyB0aHJvdHRsaW5nLg0KPj4+Pg0KPj4+
PiAtIGFsdGVybmF0aXZlbHkgSSBjYW4gc3dpdGNoIHRvIGdhZGdldCAxeCBhbmQgdGhlbiB1bnBs
dWcvcmVwbHVnIHRoZQ0KPj4+PiBjYWJsZS4NCj4+Pj4NCj4+Pj4gTm8gZXJyb3IgbWVzc2FnZSBh
bmQgY29ubmVjdHMgZmluZS4NCj4+Pj4NCj4+Pj4gLSBpZiBJIGZsaXAgdGhlIHN3aXRjaCBvbmx5
IG9uY2UsIG9uIHRoZSBQQyBzaWRlIEkgZ2V0Og0KPj4+Pg0KPj4+PiDCoMKgIGtlcm5lbDogdXNi
IDEtNTogbmV3IGhpZ2gtc3BlZWQgVVNCIGRldmljZSBudW1iZXIgMTggdXNpbmd4aGNpX2hjZA0K
Pj4+PiDCoMKgIGtlcm5lbDogdXNiIDEtNTogTmV3IFVTQiBkZXZpY2UgZm91bmQsIGlkVmVuZG9y
PTFkNmIsDQo+Pj4+IMKgwqAgaWRQcm9kdWN0PTAxMDQsIGJjZERldmljZT0gMS4wMCBrZXJuZWw6
IHVzYiAxLTU6IE5ldyBVU0IgZGV2aWNlDQo+Pj4+IMKgwqAgc3RyaW5nczogTWZyPTEsIFByb2R1
Y3Q9MiwgU2VyaWFsTnVtYmVyPTMga2VybmVsOiB1c2IgMS01OiBQcm9kdWN0Og0KPj4+PiDCoMKg
IFVTQkFybW9yeSBHYWRnZXQga2VybmVsOiB1c2IgMS01OiBNYW51ZmFjdHVyZXI6IFVTQkFybW9y
eSBrZXJuZWw6DQo+Pj4+IMKgwqAgdXNiIDEtNTogU2VyaWFsTnVtYmVyOiAwMTIzNDU2Nzg5YWJj
ZGVmIGtlcm5lbDogdXNiIDEtNTogY2FuJ3Qgc2V0DQo+Pj4+IMKgwqAgY29uZmlnICMxLCBlcnJv
ciAtMTEwDQo+Pj4gVGhlIGRldmljZSBmYWlsZWQgYXQgc2V0X2NvbmZpZ3VyYXRpb24oKSByZXF1
ZXN0IGFuZCB0aW1lZCBvdXQuIEl0DQo+Pj4gcHJvYmFibHkgdGltZWQgb3V0IGZyb20gdGhlIHN0
YXR1cyBzdGFnZSBsb29raW5nIGF0IHRoZSBkZXZpY2UgZXJyDQo+Pj4gcHJpbnQuDQo+Pj4NCj4+
Pj4gVGhlbiBpZiBJIHdhaXQgbG9uZyBlbm91Z2ggb24gdGhlIGdhZGdldCBzaWRlIEkgZ2V0Og0K
Pj4+Pg0KPj4+PiDCoMKgIHJvb3RAeXVuYTp+IyBpZmNvbmZpZw0KPj4+Pg0KPj4+PiDCoMKgIHVz
YjA6IGZsYWdzPS0yODYwNTxVUCxCUk9BRENBU1QsUlVOTklORyxNVUxUSUNBU1QsRFlOQU1JQz4g
bXR1IDE1MDANCj4+Pj4gwqDCoCBpbmV0IDE2OS4yNTQuMTE5LjIzOSBuZXRtYXNrIDI1NS4yNTUu
MC4wIGJyb2FkY2FzdCAxNjkuMjU0LjI1NS4yNTUNCj4+Pj4gwqDCoCBpbmV0NiBmZTgwOjphOGJi
OmNjZmY6ZmVkZDplZWYxIHByZWZpeGxlbiA2NCBzY29wZWlkIDB4MjA8bGluaz4NCj4+Pj4gwqDC
oCBldGhlciBhYTpiYjpjYzpkZDplZTpmMSB0eHF1ZXVlbGVuIDEwMDAgKEV0aGVybmV0KSBSWCBw
YWNrZXRzIDQ5MDQyNA0KPj4+PiDCoMKgIGJ5dGVzIDczNTE0NjU3OCAoNzAxLjAgTWlCKSBSWCBl
cnJvcnMgMCBkcm9wcGVkIDE5MSBvdmVycnVucyAwIGZyYW1lDQo+Pj4+IMKgwqAgMCBUWCBwYWNr
ZXRzIDM1Mjc5IGJ5dGVzIDI1MzI3NDYgKDIuNCBNaUIpIFRYIGVycm9ycyAwIGRyb3BwZWQgMA0K
Pj4+PiDCoMKgIG92ZXJydW5zIDAgY2FycmllciAwIGNvbGxpc2lvbnMgMA0KPj4+Pg0KPj4+PiAo
Y29ycmVjdCB3b3VsZCBiZTogaW5ldCAxMC40Mi4wLjIyMSBuZXRtYXNrIDI1NS4yNTUuMjU1LjAg
YnJvYWRjYXN0DQo+Pj4+IDEwLjQyLjAuMjU1KQ0KPj4+Pg0KPj4+PiBTbyBtdWNoIGltcHJvdmVk
IG5vdywgYnV0IGl0IHNlZW1zIEkgYW0gc3RpbGwgbWlzc2luZyBzb21ldGhpbmcgb24NCj4+Pj4g
cGx1Zy4NCj4+Pj4NCj4+PiBUaGF0J3MgZ3JlYXQhIFdlIGNhbiBsb29rIGF0IGl0IGZ1cnRoZXIu
IENhbiB5b3UgY2FwdHVyZSB0aGUgdHJhY2Vwb2ludHMNCj4+PiBvZiB0aGUgaXNzdWUuIEFsc28s
IGNhbiB5b3UgdHJ5IHdpdGggbWFzc19zdG9yYWdlIGdhZGdldCB0byBzZWUgaWYgdGhlDQo+Pj4g
cmVzdWx0IGlzIHRoZSBzYW1lPw0KPj4NCj4+IEkgaGF2ZSBhbHJlYWR5IGdzZXIsIGVlbSwgbWFz
c19zdG9yYWdlIGFuZCB1YWMyIGNvbWJvLiBXaGVuIGVlbSBmYWlscywNCj4+IHRoZSBtYXNzX3N0
b3JhZ2UgYW5kIHVhYzIgZG9uJ3QgYXBwZWFyIChvbiBLREUgeW91IGdldCBhbGwga2luZCBvZg0K
Pj4gcG9wdXBzIHdoZW4gdGhleSBhcHBlYXIpLg0KPj4NCj4+IFNvIGVpdGhlciBhbGwgd29ya3Ms
IG9yIGFsbCBmYWlscy4NCj4+DQo+PiBJJ2xsIHRyYWNlIHRoaXMgbGF0ZXIgdG9kYXkuDQo+IA0K
PiBUcmFjZSBjYXB0dXJpbmcgc3dpdGNoIGZyb20gaG9zdC0+IGdhZGdldMKgIGhlcmUNCj4gaHR0
cHM6Ly91cmxkZWZlbnNlLmNvbS92My9fX2h0dHBzOi8vZ2l0aHViLmNvbS9hbmR5LXNoZXYvbGlu
dXgvZmlsZXMvNjMyOTYwMC81LjEyLXJjNyoyQnVzYi1uZXh0LnppcF9fO0pRISFBNEYyUjlHX3Bn
IU9hNlhHSDNJcVkzd3dHNUtLNEZ3UHVOQTBtM3E1YlJqN042dmRQLXk0c0FZNm15YS05Nko5ME5K
MHRKblhMT2lOd0dUJA0KPiANCj4gKElzc3VlIGhpc3Rvcnk6DQo+IGh0dHBzOi8vdXJsZGVmZW5z
ZS5jb20vdjMvX19odHRwczovL2dpdGh1Yi5jb20vYW5keS1zaGV2L2xpbnV4L2lzc3Vlcy8zMV9f
OyEhQTRGMlI5R19wZyFPYTZYR0gzSXFZM3d3RzVLSzRGd1B1TkEwbTNxNWJSajdONnZkUC15NHNB
WTZteWEtOTZKOTBOSjB0Sm5YTmM3S2dBdyQNCj4gKQ0KPiANCj4gT24gdGhlIFBDIHNpZGUgdGhp
cyByZXN1bHRlZCB0bzoNCj4gDQo+IGFwciAxNyAxODoxNzo0NCBkZWxmaW9uIGtlcm5lbDogdXNi
IDEtNTogbmV3IGhpZ2gtc3BlZWQgVVNCIGRldmljZQ0KPiBudW1iZXIgMTIgdXNpbmcgeGhjaV9o
Y2QNCj4gYXByIDE3IDE4OjE3OjQ0IGRlbGZpb24ga2VybmVsOiB1c2IgMS01OiBOZXcgVVNCIGRl
dmljZSBmb3VuZCwNCj4gaWRWZW5kb3I9MWQ2YiwgaWRQcm9kdWN0PTAxMDQsIGJjZERldmljZT0g
MS4wMA0KPiBhcHIgMTcgMTg6MTc6NDQgZGVsZmlvbiBrZXJuZWw6IHVzYiAxLTU6IE5ldyBVU0Ig
ZGV2aWNlIHN0cmluZ3M6IE1mcj0xLA0KPiBQcm9kdWN0PTIsIFNlcmlhbE51bWJlcj0zDQo+IGFw
ciAxNyAxODoxNzo0NCBkZWxmaW9uIGtlcm5lbDogdXNiIDEtNTogUHJvZHVjdDogVVNCQXJtb3J5
IEdhZGdldA0KPiBhcHIgMTcgMTg6MTc6NDQgZGVsZmlvbiBrZXJuZWw6IHVzYiAxLTU6IE1hbnVm
YWN0dXJlcjogVVNCQXJtb3J5DQo+IGFwciAxNyAxODoxNzo0NCBkZWxmaW9uIGtlcm5lbDogdXNi
IDEtNTogU2VyaWFsTnVtYmVyOiAwMTIzNDU2Nzg5YWJjZGVmDQo+IGFwciAxNyAxODoxNzo0OSBk
ZWxmaW9uIGtlcm5lbDogdXNiIDEtNTogY2FuJ3Qgc2V0IGNvbmZpZyAjMSwgZXJyb3IgLTExMA0K
PiANCj4gDQo+IFRoYW5rcyBmb3IgYWxsIHlvdXIgaGVscCENCj4gDQoNCkxvb2tzIGxpa2UgaXQn
cyBMUE0gcmVsYXRlZCBhZ2Fpbi4gVG8gY29uZmlybSwgdHJ5IHRoaXM6DQpEaXNhYmxlIExQTSB3
aXRoIHRoaXMgcHJvcGVydHkgInNucHMsdXNiMi1nYWRnZXQtbHBtLWRpc2FibGUiDQooTm90ZSB0
aGF0IGl0J3Mgbm90IHRoZSBzYW1lIGFzICJzbnBzLGRpc19lbmJsc2xwbV9xdWlyayIpDQoNCk1h
a2Ugc3VyZSB0aGF0IHlvdXIgdGVzdGluZyBrZXJuZWwgaGFzIHRoaXMgcGF0Y2ggWzFdDQo0NzVl
OGJlNTNkMDQgKCJ1c2I6IGR3YzM6IGdhZGdldDogQ2hlY2sgZm9yIGRpc2FibGVkIExQTSBxdWly
ayIpDQoNClsxXSBodHRwczovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dp
dC9ncmVna2gvdXNiLmdpdC9jb21taXQvP2g9dXNiLW5leHQmaWQ9NDc1ZThiZTUzZDA0OTZmOWJj
NjE1OWY0YWJiM2ZmNWY5YjkwZThkZQ0KDQoNClRoZSBmYWlsdXJlIHlvdSBzYXcgd2FzIHByb2Jh
Ymx5IGR1ZSB0aGUgZ2FkZ2V0IGZ1bmN0aW9uIGF0dGVtcHRpbmcNCnRvIHN0YXJ0IGEgZGVsYXll
ZCBzdGF0dXMgc3RhZ2Ugb2YgdGhlIFNFVF9DT05GSUdVUkFUSU9OIHJlcXVlc3QuDQpCeSB0aGlz
IHRpbWUsIHRoZSBob3N0IGFscmVhZHkgcHV0IHRoZSBkZXZpY2UgaW4gbG93IHBvd2VyLg0KDQpU
aGUgU1RBUlRfVFJBTlNGRVIgY29tbWFuZCBuZWVkcyB0byBiZSBleGVjdXRlZCB3aGlsZSB0aGUg
ZGV2aWNlDQppcyBvbiAiT04iIHN0YXRlIChvciBVMCBpZiBlU1MpLiBXZSBzaG91bGRuJ3QgdXNl
IGR3Yy0+bGlua19zdGF0ZQ0KdG8gY2hlY2sgZm9yIGxpbmsgc3RhdGUgYmVjYXVzZSB3ZSBvbmx5
IGVuYWJsZSBsaW5rIHN0YXRlIGNoYW5nZQ0KaW50ZXJydXB0IGZvciBzb21lIGNvbnRyb2xsZXIg
dmVyc2lvbnMuDQoNCk9uY2UgeW91IGNvbmZpcm1zIGRpc2FibGluZyBMUE0gd29ya3MsIHRyeSB0
aGlzIGZpeDoNCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvdXNiL2R3YzMvZ2FkZ2V0LmMgYi9kcml2
ZXJzL3VzYi9kd2MzL2dhZGdldC5jDQppbmRleCA2MjI3NjQxZjJkMzEuLjA2Y2RlYzc5MjQ0ZSAx
MDA2NDQNCi0tLSBhL2RyaXZlcnMvdXNiL2R3YzMvZ2FkZ2V0LmMNCisrKyBiL2RyaXZlcnMvdXNi
L2R3YzMvZ2FkZ2V0LmMNCkBAIC0zMDksMTAgKzMwOSwxNCBAQCBpbnQgZHdjM19zZW5kX2dhZGdl
dF9lcF9jbWQoc3RydWN0IGR3YzNfZXAgKmRlcCwgdW5zaWduZWQgaW50IGNtZCwNCiANCiAgICAg
ICAgaWYgKERXQzNfREVQQ01EX0NNRChjbWQpID09IERXQzNfREVQQ01EX1NUQVJUVFJBTlNGRVIp
IHsNCiAgICAgICAgICAgICAgICBpbnQgICAgICAgICAgICAgbmVlZHNfd2FrZXVwOw0KKyAgICAg
ICAgICAgICAgIHU4ICAgICAgICAgICAgICBsaW5rX3N0YXRlOw0KIA0KLSAgICAgICAgICAgICAg
IG5lZWRzX3dha2V1cCA9IChkd2MtPmxpbmtfc3RhdGUgPT0gRFdDM19MSU5LX1NUQVRFX1UxIHx8
DQotICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGR3Yy0+bGlua19zdGF0ZSA9PSBEV0Mz
X0xJTktfU1RBVEVfVTIgfHwNCi0gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgZHdjLT5s
aW5rX3N0YXRlID09IERXQzNfTElOS19TVEFURV9VMyk7DQorICAgICAgICAgICAgICAgcmVnID0g
ZHdjM19yZWFkbChkd2MtPnJlZ3MsIERXQzNfRFNUUyk7DQorICAgICAgICAgICAgICAgbGlua19z
dGF0ZSA9IERXQzNfRFNUU19VU0JMTktTVChyZWcpOw0KKw0KKyAgICAgICAgICAgICAgIG5lZWRz
X3dha2V1cCA9IChsaW5rX3N0YXRlID09IERXQzNfTElOS19TVEFURV9VMSB8fA0KKyAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICBsaW5rX3N0YXRlID09IERXQzNfTElOS19TVEFURV9VMiB8
fA0KKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBsaW5rX3N0YXRlID09IERXQzNfTElO
S19TVEFURV9VMyk7DQogDQogICAgICAgICAgICAgICAgaWYgKHVubGlrZWx5KG5lZWRzX3dha2V1
cCkpIHsNCiAgICAgICAgICAgICAgICAgICAgICAgIHJldCA9IF9fZHdjM19nYWRnZXRfd2FrZXVw
KGR3Yyk7DQpAQCAtMTk4OSw2ICsxOTkzLDggQEAgc3RhdGljIGludCBfX2R3YzNfZ2FkZ2V0X3dh
a2V1cChzdHJ1Y3QgZHdjMyAqZHdjKQ0KICAgICAgICBjYXNlIERXQzNfTElOS19TVEFURV9SRVNF
VDoNCiAgICAgICAgY2FzZSBEV0MzX0xJTktfU1RBVEVfUlhfREVUOiAgICAvKiBpbiBIUywgbWVh
bnMgRWFybHkgU3VzcGVuZCAqLw0KICAgICAgICBjYXNlIERXQzNfTElOS19TVEFURV9VMzogICAg
ICAgIC8qIGluIEhTLCBtZWFucyBTVVNQRU5EICovDQorICAgICAgIGNhc2UgRFdDM19MSU5LX1NU
QVRFX1UyOiAgICAgICAgLyogaW4gSFMsIG1lYW5zIFNsZWVwIChMMSkgKi8NCisgICAgICAgY2Fz
ZSBEV0MzX0xJTktfU1RBVEVfVTE6DQogICAgICAgIGNhc2UgRFdDM19MSU5LX1NUQVRFX1JFU1VN
RToNCiAgICAgICAgICAgICAgICBicmVhazsNCiAgICAgICAgZGVmYXVsdDoNCg0KDQoNCg0KQlIs
DQpUaGluaA0K
