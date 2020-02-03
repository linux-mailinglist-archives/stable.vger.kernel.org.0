Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAEBE15023A
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 09:07:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727514AbgBCIHk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 03:07:40 -0500
Received: from mail-eopbgr700068.outbound.protection.outlook.com ([40.107.70.68]:2048
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727308AbgBCIHk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 03:07:40 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GBc32W3yGvFTSd0F0O+khUdqEdqI9T2APtutXcxIceOTIwTxL5LqVtQpbmZCnrd47QkoAmV0qDwTTaWCPUC5Lmllt2bKoJ7JYeTMWdsYObwbsH9f8W92YohrWuQ7vqCs1bbxgtJNj7tzFN1+E5QGYH5SB75Dzw8C6m+2lxgGRCO2QvHXGqEafDn/ODW2e/ISprjcUjf2rS3Nv5zAgRQS3i28XRGtV7F6Zxilv3+aoO5tO8TCz9gGIXtNbMSZs1fDGJS5qHbX/wbhSL40HQcGNrV58qvwR3+9ZbUXhDVHZ9vGESeJlz22FWKl/siDoC9GCnaMTgw5Gc3M3oFM6+ZAdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yotUrgnRE2beqVviDIbUStHK2Rv85QsohZEXSJ/rIac=;
 b=Sy3QCQfp6bbBtPPiyaDe2W4i/kCtXYTLm9yOArYohbzrl4K92tmYVQCtHnQjSk3ovZhhJfNkQeO0hWvfZTCkThFwRpfiYkFX0xNkjTTtSnC/CRvnRBzZ7HoSUAJvwlFhYUogB5RckDIRM3YSsgzIUwjnJWtHUK2IbQmyBgMAoLMUN4RHjhWOegqgu4CjsmdrV3rkX8MVfoJeUpXi7Bep7Ksio7IjO5uO4R3p+Jrtah1MbQYig8I3o/3Z+XAYotg34PbaYqiPAhPvzFTFhRPncu5SrljPNfhAnBiiS9ghSVdwyp+s7ua1U5PDtjk1YFvTmPI6XHAgfa6aufpnyyrYDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=infinera.com; dmarc=pass action=none header.from=infinera.com;
 dkim=pass header.d=infinera.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=infinera.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yotUrgnRE2beqVviDIbUStHK2Rv85QsohZEXSJ/rIac=;
 b=ZU/4H9ofY2ST+2T17p6kP6EG0FkOIjZKpR4F0AATeUb3vHsuhVpy+c1quOEzZypXcs1cvAl8v1w8I9q4aGVKB10BRxjk5nHR/a2qM/GqG4XFk4LFhWxg9miX47AkkcNGrv4GNNCwtdI5jw7PnMLvIoyZ3KpSIzxGbl76hLk0owU=
Received: from BN8PR10MB3540.namprd10.prod.outlook.com (20.179.77.152) by
 BN8PR10MB3729.namprd10.prod.outlook.com (20.179.77.221) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2686.26; Mon, 3 Feb 2020 08:07:38 +0000
Received: from BN8PR10MB3540.namprd10.prod.outlook.com
 ([fe80::6922:a072:d75e:74ef]) by BN8PR10MB3540.namprd10.prod.outlook.com
 ([fe80::6922:a072:d75e:74ef%7]) with mapi id 15.20.2686.031; Mon, 3 Feb 2020
 08:07:38 +0000
From:   Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
To:     "sashal@kernel.org" <sashal@kernel.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: e1000e: Revert "e1000e: Make watchdog use delayed work" in 5.4
Thread-Topic: e1000e: Revert "e1000e: Make watchdog use delayed work" in 5.4
Thread-Index: AQHV2FVfbX9/ePjF/0y2k/D3g6Oxd6gIffoAgACjWYA=
Date:   Mon, 3 Feb 2020 08:07:37 +0000
Message-ID: <05a00d034176c2b3eee8d9b3c510ac92fe864c62.camel@infinera.com>
References: <7b4b20e95883db121b9aa539bea82f9c93390e7a.camel@infinera.com>
         <20200202222258.GC1732@sasha-vm>
In-Reply-To: <20200202222258.GC1732@sasha-vm>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Joakim.Tjernlund@infinera.com; 
x-originating-ip: [88.131.87.201]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8e90008f-c497-48c0-c94a-08d7a880225e
x-ms-traffictypediagnostic: BN8PR10MB3729:
x-microsoft-antispam-prvs: <BN8PR10MB37291C71DD13BE004FC8D7E2F4000@BN8PR10MB3729.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-forefront-prvs: 0302D4F392
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(346002)(376002)(396003)(39860400002)(199004)(189003)(86362001)(186003)(6916009)(26005)(4326008)(6486002)(36756003)(66476007)(66556008)(64756008)(66446008)(5660300002)(91956017)(76116006)(66946007)(71200400001)(6506007)(2616005)(966005)(2906002)(316002)(81156014)(81166006)(478600001)(6512007)(8676002)(45080400002)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN8PR10MB3729;H:BN8PR10MB3540.namprd10.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: infinera.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oGb9xQxWFsMiQ4Qrocxwd7h0rNcxE1JykbICdU/VBVyX82Xj6cMfj4e242IttSq5IeDNPNsNphdCunhyE9PB5D+gL+b5e94qJDGGdCStGjjWZa1MGpvV+IFqRBszXiy24fDogOKoFRrae7TD6uA+R1JJzraP3AY/exYYqPamzqcPdOD/JD48s5Gj4rtfB72QP4qq00pdwMYgpdAsMqtGjr8JTmfRsA3vmi7AmVmY2gKDi3EGs2ApWR6YACDioeBLrrWDjAaxJbhsh0Xpr7aYCgNb52rfCe2M1c5LHJjv5Hlhs/ql6h7vZRb1qx/z7iVHETvbktZiFf/U/kWmnwGeFMCiLtr6Xhf0oTZVEk5VVyZ5vfR3feJDQZABM/Yv9/6NFhbcRKs/933FV43SfAIf+Tu0CBI/1bvuhDrE47N5ItwYXjUsfmZz5VMuEKB5akNmXkOn0TK8vRKqLmki7Trl40tKR3s/ebXPDNsIRZmUeViyX3VHKUzcopQ+0AwGBYxaxIxEV2W5v6kOOAAlFYoimg==
x-ms-exchange-antispam-messagedata: wt4g24OgDQjcmUzFKH36FEWf51AR+sUpkuPXwwRVnkoumgwW9drCcmuXNI2ebd+xIMpArF4CHcS+72v0pkWRNFEOugxvgmPDvD2muRVKm2n2zZoAmw1+j6dnAKOExh22zMOdfShfEpuc5frlRF2rRg==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <8D94A4E27E4B17479AE5F881D5B75160@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: infinera.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e90008f-c497-48c0-c94a-08d7a880225e
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Feb 2020 08:07:38.0253
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 285643de-5f5b-4b03-a153-0ae2dc8aaf77
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xZvK6NWl1EG6x4b7BS4/tNjVoGDbKUNW8wi/BcQC6MEVpmkqnrvhpfVsSyttQfOeGzb5YBCEDMunP1le4637eg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR10MB3729
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gU3VuLCAyMDIwLTAyLTAyIGF0IDE3OjIyIC0wNTAwLCBTYXNoYSBMZXZpbiB3cm90ZToNCj4g
DQo+IE9uIEZyaSwgSmFuIDMxLCAyMDIwIGF0IDA0OjQyOjA2UE0gKzAwMDAsIEpvYWtpbSBUamVy
bmx1bmQgd3JvdGU6DQo+ID4gT2JvdmUgY29tbWl0IHdhcyByZXZlcnRlZCBiZWNhdXNlIGl0IG1h
c2sgc29tIGUxMDAwZSBjYXJkcyB1bnN0YWJsZToNCj4gPiBodHRwczovL25hbTAzLnNhZmVsaW5r
cy5wcm90ZWN0aW9uLm91dGxvb2suY29tLz91cmw9aHR0cHMlM0ElMkYlMkZnaXQua2VybmVsLm9y
ZyUyRnB1YiUyRnNjbSUyRmxpbnV4JTJGa2VybmVsJTJGZ2l0JTJGc3RhYmxlJTJGbGludXguZ2l0
JTJGY29tbWl0JTJGZHJpdmVycyUyRm5ldCUyRmV0aGVybmV0JTJGaW50ZWwlMkZlMTAwMGUlMkZu
ZXRkZXYuYyUzRmglM0RsaW51eC01LjUueSUyNmlkJTNEZDVhZDdhNmE3ZjNjODdiMjc4ZDdlNDk3
M2I2NTY4MmJlNGU1ODhkZCZhbXA7ZGF0YT0wMiU3QzAxJTdDSm9ha2ltLlRqZXJubHVuZCU0MGlu
ZmluZXJhLmNvbSU3Q2FlOGU1Mjk5OGFhNzRmZDA1MzNhMDhkN2E4MmU3NjdlJTdDMjg1NjQzZGU1
ZjViNGIwM2ExNTMwYWUyZGM4YWFmNzclN0MxJTdDMCU3QzYzNzE2Mjc4OTgyMzQzODY0MSZhbXA7
c2RhdGE9MFJMd292cU1FdUNCeDQlMkJ2JTJCRXdhQnNacE5WdyUyRmR2TENzb05lJTJGbmclMkJC
blUlM0QmYW1wO3Jlc2VydmVkPTANCj4gPiANCj4gPiA1LjQgZG9lcyBub3QgaGF2ZSB0aGlzIHJl
dmVydCwgZmVlbHMgZm9yZ290dGVuPw0KPiA+IA0KPiA+IGJ1Z3M6DQo+ID4gaHR0cHM6Ly9uYW0w
My5zYWZlbGlua3MucHJvdGVjdGlvbi5vdXRsb29rLmNvbS8/dXJsPWh0dHBzJTNBJTJGJTJGYnVn
emlsbGEucmVkaGF0LmNvbSUyRnNob3dfYnVnLmNnaSUzRmlkJTNEMTc4NzAyNiZhbXA7ZGF0YT0w
MiU3QzAxJTdDSm9ha2ltLlRqZXJubHVuZCU0MGluZmluZXJhLmNvbSU3Q2FlOGU1Mjk5OGFhNzRm
ZDA1MzNhMDhkN2E4MmU3NjdlJTdDMjg1NjQzZGU1ZjViNGIwM2ExNTMwYWUyZGM4YWFmNzclN0Mx
JTdDMCU3QzYzNzE2Mjc4OTgyMzQzODY0MSZhbXA7c2RhdGE9ZVpjUWx3c2tuOU55TkUyV0RYanJ1
eVRVMDdEdG9sOUxldHd6N2RSSTl0WSUzRCZhbXA7cmVzZXJ2ZWQ9MA0KPiA+IGh0dHBzOi8vbmFt
MDMuc2FmZWxpbmtzLnByb3RlY3Rpb24ub3V0bG9vay5jb20vP3VybD1odHRwcyUzQSUyRiUyRmJ1
Z3ppbGxhLmtlcm5lbC5vcmclMkZzaG93X2J1Zy5jZ2klM0ZpZCUzRDIwNTA2NyZhbXA7ZGF0YT0w
MiU3QzAxJTdDSm9ha2ltLlRqZXJubHVuZCU0MGluZmluZXJhLmNvbSU3Q2FlOGU1Mjk5OGFhNzRm
ZDA1MzNhMDhkN2E4MmU3NjdlJTdDMjg1NjQzZGU1ZjViNGIwM2ExNTMwYWUyZGM4YWFmNzclN0Mx
JTdDMCU3QzYzNzE2Mjc4OTgyMzQzODY0MSZhbXA7c2RhdGE9b3NZVlNYWUpZMHBNJTJCcE5EQmNO
JTJGck42dzkwJTJCVjV6TmhWUEFycFowZmRadyUzRCZhbXA7cmVzZXJ2ZWQ9MA0KPiANCj4gQSBz
dGFibGUgdGFnIHdvdWxkIG1ha2Ugc3VyZSB0aGF0IGl0IHdvdWxkbid0IGhhdmUgYmVlbiBmb3Jn
b3R0ZW4gOikNCj4gDQo+IFF1ZXVlZCB1cCBmb3IgNS40Li4uDQoNClRoYXQgd2FzIHF1aWNrIDop
IFRoYW5rcyBhIGxvdCAhDQoNCiAgIEpvY2tlDQo=
