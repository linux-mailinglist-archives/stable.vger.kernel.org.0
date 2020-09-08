Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C323261DF2
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 21:44:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732406AbgIHToW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 15:44:22 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:11898 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730846AbgIHPvo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Sep 2020 11:51:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1599580303; x=1631116303;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=v36TwNsJtBiYGarjIzFTpVnSWt6EUXdLDlptUg4qlpc=;
  b=N8IFKytHVjmkOvuvkURD6a/QA7H48zFaPMNCZVoYtjrsiaA+MkUs+4y1
   rPD3wa2FVcBJajPIc1bNJyCX7/hYQji4cypTLyTr8IJfqVaonPlIxMqA2
   1XozMzqN3NinSiEqjgmFOpwcCdQRK2hNbGplGygjL+jSrjoRQ6A0DAG8S
   U5Y3cohvCjp4mhA78I0Krbqy6JwWFvR4It5oElP3eVXzPiE1BNTzvQZ+a
   a9Fr0t1WXmmiB6Wj6DM4QchRjpXkVKp9MNque36Y2WBbp+/oqr/7xO8P6
   DQlwSOg4p1d8J9fZYCxNOGvs59l6WSomUUKFiQczLRaJ6AGXZA3G/+Cka
   A==;
IronPort-SDR: B8uw004R5JUTUDn2GOHn5SNTggaJNikqG1Tc1EWXb1SL4/9UwJrIPiVxVpaCX+7rxldqWwbY8X
 QcsKPKQZ8lo4GAa2Q0x/a4dXxgV4+sGxSioE5jTnY2j/xR3Fgi8MHG8aiXmpeuOQzPPp+5o0D0
 qFYR2OfGZIwLW8J4P9rnLvhZweeFxqaVcIDJsiEePaWSTNovwsmH5H2qNRiMSYfkMJEt+Za798
 DedmTRtgFz95sP7D+urV+A3RZGqUR3QNziRvpY+4oau/hGysz/ZuXgvn1xQo9wfSL8hhk6lcwN
 2YQ=
X-IronPort-AV: E=Sophos;i="5.76,406,1592895600"; 
   d="scan'208";a="90971867"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 08 Sep 2020 08:51:13 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 8 Sep 2020 08:50:52 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3
 via Frontend Transport; Tue, 8 Sep 2020 08:50:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HANEhR4z2kgEaPa4QQFvJ4mI8Qp9ygCtPWDT0s6Y4x37yAzxhid9D2kftlcs3rm+9q0yjqg+FGrmnkwa/K47zGTHqRZqzvSHJqapAj91mFm1SHb9gxPWT/pEFSJOk1FwSxSJNvQkfR7fVQjchohgoTPsabkTz8y+HvNrJfZswMmJKhUOhb8qjQLNvj6nc/zsPsnMXXpJanjT9OgWVc7PaKS/vSMk01QVXQX3GjT+1KH8jh9k+98P0kn43cQZYMh45WbCSr4S/LRvFnWeR61aGXCTbqOaP/c3i3PjjhscJGsfmJXRX6QyT/4sG0cVW3zeMmjHuZYXBSUr/AXTFti/3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v36TwNsJtBiYGarjIzFTpVnSWt6EUXdLDlptUg4qlpc=;
 b=Kl3E0LpF3udPEvtgg0upO42TPMsw62aY2jpgkqJiocPY2ZSyUTMnLAy+4pPNT0K/sTmY23mde6YlUbcUnW34EBkmyAaNCLP5k9M7zUcIBZEFUyOaQtq5YYJca4LyXZIKrxLKbr3LqYEcaBx25esTXB1ESeBnAE9ogJxUcaxb+dub8roXAPXtNoMt+wooOKwH6HbbrjrZqctnqvcJvnmDsskamx76JVLFROTjkg9MjFmbJ+Ux/WGRHG5VB3g9KirUqkEXq85EEOdDBpAeggww4dukeJuKF1MuM44EcvruOw0T9mxKtXFkoYcoJ5i7gsArz3kKuk8rgSqxO1bsQc9jmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v36TwNsJtBiYGarjIzFTpVnSWt6EUXdLDlptUg4qlpc=;
 b=cgqYhA53NxuQNELvZogLXXn0sAwL3HiT34KrAflq5Ljdcqt8OMlJlFDcJFhGW+NwC+ZZPYfYphuPjMmCP7nONj91T0cbYoGrRfDpKAzulzQKNVOxPaAgMizKoh9pyPOzldrCVWTq0IgJhYnt0pQvyNokiqY3/yJm4Y2rrqXo5LE=
Received: from CY4PR1101MB2341.namprd11.prod.outlook.com
 (2603:10b6:903:b1::22) by CY4PR1101MB2344.namprd11.prod.outlook.com
 (2603:10b6:903:b4::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.18; Tue, 8 Sep
 2020 15:51:11 +0000
Received: from CY4PR1101MB2341.namprd11.prod.outlook.com
 ([fe80::c57b:e93f:98a8:c654]) by CY4PR1101MB2341.namprd11.prod.outlook.com
 ([fe80::c57b:e93f:98a8:c654%11]) with mapi id 15.20.3348.019; Tue, 8 Sep 2020
 15:51:11 +0000
From:   <Codrin.Ciubotariu@microchip.com>
To:     <sashal@kernel.org>, <gregkh@linuxfoundation.org>
CC:     <havasiefr@gmail.com>, <stable@vger.kernel.org>
Subject: Re: duplicated patch in 5.4
Thread-Topic: duplicated patch in 5.4
Thread-Index: AQHWhSKNyQIp8JfpLUKNBhCKaiw8yqldasqAgAAEfwCAABA4gIABZfgA
Date:   Tue, 8 Sep 2020 15:51:11 +0000
Message-ID: <3d8f87c1-944e-725d-2d70-ca9ddebe10fb@microchip.com>
References: <CADBnMvh6gODocz8=fNE0wVcv71SdHKNtee7hAZev6OdZ7EZcAw@mail.gmail.com>
 <788f9aa0-f03d-c736-a8a1-9a989f2e9c6e@microchip.com>
 <20200907173154.GA1016021@kroah.com> <20200907182957.GO8670@sasha-vm>
In-Reply-To: <20200907182957.GO8670@sasha-vm>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [84.232.220.208]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 419ebfd4-ba60-48af-9ba6-08d8540f02ac
x-ms-traffictypediagnostic: CY4PR1101MB2344:
x-microsoft-antispam-prvs: <CY4PR1101MB2344818434228DC7E1FB157BE7290@CY4PR1101MB2344.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: V4tmmix/59xsGRSnKkfBGAF/aX14EOzvBEkdSISmSUZAycDxh2iJidWs4YL2y5EJT+aTRq6945hkY+gIN1LNB5cPEDStDLD7mhEDLrgcmRW2s01mS736nVbdAicjL39ARiKjszmcm+8TONeI914JC7bxGCR1p8HBKF2qIQAyAb9PtEJuNaOEqKvzLKb+NnRFILat7OCtaRUVT+3L4Vw/BSeTNhULesE2KOsmUtJygW5mpXESCzKPH3hZsUcWSEZYYECm7bdaU/89P3Ahdmlz07eqA6uCrk6Wc1+odGJcFt4T6Ep3UkuzabC4C3ZIBXARFtwLGLJISptWAwo90mMRAA21Cuh9eRomrsJkj+Jbn+WZDQu+38eocJvESXNN+DG94VWWP0kPi0a3cZyXOyXlResI4bPbVcNxa0Ubo5gjMgO3NN9yDJii0sj94r0G6KuCXgiEZMoDVrIhok2sGSvvaw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1101MB2341.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2906002)(86362001)(4326008)(2616005)(6512007)(7116003)(8676002)(6486002)(66946007)(186003)(110136005)(8936002)(966005)(54906003)(498600001)(26005)(6506007)(53546011)(76116006)(31696002)(91956017)(64756008)(66476007)(66446008)(66556008)(31686004)(83380400001)(5660300002)(71200400001)(36756003)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: NDDRLO3k0t5QOhECqemUjRZ5CuAjFVvZBG8leodcNElR0wAUXTcCGsyC3wD1ih6w1c/Jdp1SgOjwMdK4gm5f8vOpbzwSm5UdlRJcS99N8bWCLVBVk//IjLZFieuJo36h+FnoOHha7/QrC5SfNa6TSSKWgro8hdZskltQrAQe2Ga9YYHQY7Yy/uNnEvL+pnZ4nOQvyz0OYJOAPtJMvzsrvWtRFa6DmnrHKbViXyVXP+HndPgZat0p51X6+8CdX6y14emKn7117UTOmBuqGiQK7Z1Zoe3RRUBbe3NOvl9qX+mIa/jhCk34V1LiT9SeiN7OIT4mi4qAOdTPct944ok2z9H/UwDLYNgn2sKpEEgcgyKuLbozscjeadinKon0FZ24yNg8NYqRX3YBHB6rOi3X0lN/RsIhEG2DL7oaqZqQCJ5EsdoLbbdgcWcR5/pD6RCH3MANi5senob2+O/wZDnLJv+CMj4nSdKWjWSjr8jILa9pMev6UwyfETmgI7ZGvdv/SzofCL+yMEN6ftrhJapq7QKJvKPQQtQ1TYPl+OlAihxWl3cHNZLNKB2sfWOJ/UVUWbbdIxqp8O+lI8mzuUI7pJnTcS1NMDL+Xm42pYnfV8aeLkVEuY1aPXJ1H9tLwEBKwvL97blkCu4ZxxpeJAgEJA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <F789A4D0B2BEE945B65E87A7A4BF3B66@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1101MB2341.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 419ebfd4-ba60-48af-9ba6-08d8540f02ac
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Sep 2020 15:51:11.7025
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kD667FJYkCU2cHcmCvWX2JJB/2OaFcR90npnGIRiYyrlkyRhhxfyxT9oDOVgGNnL56e32sk6ffYCJf8prvUvkwnT4X4TnJC01OpWav+z9vY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1101MB2344
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gMDcuMDkuMjAyMCAyMToyOSwgU2FzaGEgTGV2aW4gd3JvdGU6DQo+IEVYVEVSTkFMIEVNQUlM
OiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3MgeW91IGtub3cg
DQo+IHRoZSBjb250ZW50IGlzIHNhZmUNCj4gDQo+IE9uIE1vbiwgU2VwIDA3LCAyMDIwIGF0IDA3
OjMxOjU0UE0gKzAyMDAsIEdyZWcgS0ggd3JvdGU6DQo+PiBPbiBNb24sIFNlcCAwNywgMjAyMCBh
dCAwNToxNTo0OVBNICswMDAwLCANCj4+IENvZHJpbi5DaXVib3Rhcml1QG1pY3JvY2hpcC5jb20g
d3JvdGU6DQo+Pj4gT24gMDcuMDkuMjAyMCAxNzoyNCwgS3Jpc3RvZiBIYXZhc2kgd3JvdGU6DQo+
Pj4gPiBEZWFyIENpdWJhdGFyaXUsDQo+Pj4gPg0KPj4+ID4gYXMgSSBhbSBub3QgZmFtaWxpYXIg
d2l0aCB0aGUgbGludXggZGV2ZWxvcG1lbnQgd29ya2Zsb3csIEkgYW0NCj4+PiA+IGNvbnRhY3Rp
bmcgeW91IGRpcmVjdGx5IGFzIHRoZSBhdXRob3Igb2YgdGhlIHVwc3RyZWFtIHBhdGNoOg0KPj4+
ID4gYWYxOTlhMWE5Y2IwMmVjMDE5NDgwNGJkNDZjMTc0YjZkYjI2MjA3NQ0KPj4+ID4NCj4+PiA+
IEkgbm90aWNlZCB0aGF0IHlvdXIgYWRkaXRpb24gdGhlcmUgd2FzIGFwcGxpZWQgdHdpY2UgaW50
byA1LjQgWzFdDQo+Pj4gPg0KPj4+ID4gZDliODIwNmU1MzIzYWUzYzliNWI0MTc3NDc4YTEyMjQx
MDg2NDJmN8KgwqDCoCB2NS40LjUxLTQ1LWdkOWI4MjA2ZTUzMjMNCj4+PiA+IGQ1NWRhZDhiMWQ4
OTNmYWUwYzRlNzc4YWJmMmFjZTA0OGJjYmFkODbCoMKgwqDCoCB2NS40LjUyLTEzLWdkNTVkYWQ4
YjFkODkNCj4+PiA+DQo+Pj4gPiByZXN1bHRpbmcgaW4gYSBub24taGFybWZ1bCwgYnV0IHVubmVj
ZXNzYXJ5IGRvdWJsZSBzZXR0aW5nIG9mIHRoZSANCj4+PiB2YXJpYWJsZS4NCj4+PiA+DQo+Pj4g
PiAvKiBzZXQgdGhlIHJlYWwgbnVtYmVyIG9mIHBvcnRzICovDQo+Pj4gPiBkZXYtPmRzLT5udW1f
cG9ydHMgPSBkZXYtPnBvcnRfY250Ow0KPj4+ID4NCj4+PiA+IC8qIHNldCB0aGUgcmVhbCBudW1i
ZXIgb2YgcG9ydHMgKi8NCj4+PiA+IGRldi0+ZHMtPm51bV9wb3J0cyA9IGRldi0+cG9ydF9jbnQ7
DQo+Pj4gPg0KPj4+ID4gcmV0dXJuIDA7DQo+Pj4gPg0KPj4+ID4gQ291bGQgeW91IG5vdGlmeSB0
aGUgc3RhYmxlIG1haW50YWluZXJzIHRvIGFwcGx5IHlvdXIgcGF0Y2ggY29ycmVjdGx5Pw0KPj4+
ID4NCj4+PiA+IEJlc3QgcmVnYXJkcywNCj4+PiA+IEtyaXN0w7NmIEhhdmFzaQ0KPj4+ID4NCj4+
PiA+DQo+Pj4gPiBbMV0gDQo+Pj4gaHR0cHM6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4
L2tlcm5lbC9naXQvc3RhYmxlL2xpbnV4LmdpdC90cmVlL2RyaXZlcnMvbmV0L2RzYS9taWNyb2No
aXAva3N6ODc5NS5jP2g9djUuNC42MyNuMTI3NCANCj4+Pg0KPj4+ID4NCj4+Pg0KPj4+IEhlbGxv
LA0KPj4+DQo+Pj4gS3Jpc3TDs2YgZGlzY292ZXJlZCB0aGF0IG9uZSBwYXRjaCBvZiBtaW5lIHdh
cyBhcHBsaWVkIHR3aWNlLiBXaGF0IGlzIHRoZQ0KPj4+IGJlc3Qgd2F5IHRvIGFkZHJlc3MgdGhp
cz8NCj4+DQo+PiBTZW5kIHVzIGEgcmV2ZXJ0IHdvdWxkIGJlIGJlc3QuDQo+IA0KPiBJJ2xsIHF1
ZXVlIHVwIGEgcmV2ZXJ0LCBub3RoaW5nIGVsc2UgaXMgcmVxdWlyZWQgb24geW91ciBlbmQsIHRo
YW5rcyBmb3INCj4gcmVwb3J0aW5nIQ0KDQpHcmVhdCEgVGhhbmtzIGV2ZXJ5b25lIQ0KDQpCZXN0
IHJlZ2FyZHMsDQpDb2RyaW4NCg0K
