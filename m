Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A10E3167A56
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 11:13:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728238AbgBUKNS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 05:13:18 -0500
Received: from mail-eopbgr1410112.outbound.protection.outlook.com ([40.107.141.112]:44244
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727150AbgBUKNS (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 05:13:18 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fkIO6MIE7bz0XkV+Km8/+m0/kbzUuGIz4E5YpGW7nfxWhX3oftInf0ipPGhqt+o2k7s0NtstxqM6eGJCOoHg5eyuUHwMV28Dm2SLfwNC5g0KipmjOGrwsQVHNhxOAsnUD7BbJVBiZ8uN4vbQXjG2Kk3+kf4tHYxykHelsXb/kpLzmRZJf7MKCw7ALcuQYPEGoZokw+1q3stKcPiR3csuWsfNPfEUl7ncxxijLVDXXGfHJQ7yaRP9h5Q+ySjXBOqyrfk7wFsDCh4c8vtSgn+jqvzr3yuhf33+P1MPYeA40Jr8yItA5WXk64C7SYs3/v7fsNJ1X4E4YD9shS443q/C1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lWyOzyK9USraGk+KqxItGj4sL/sIeI3C9dVxC9LKKHY=;
 b=e4iLaeR2wTPASwqcGu0usilVhjG7A8KdsgKQNcTusUh0seJ0lPdxGIT+aPmLyaWBOq7FBAWVAmv6jtQpJETn2zRWUmcvT/V7QLPtWcd9tH0rYN5zfQSiqBTzkU3cIu0l4nxJirtpx1uNa5NAQRdE3MN+GMjc0bKWIu5aZsydtSENZEXoVcGieoIpLf+haP5XJ8YDEC7b6UDj005Xj7rWprHrB64nNnwzsFdpb245knqIWQL1Do7c7Y7pC6rH5a2+PDfbHESKP5A13SZ3dZB7Oh2D5LyImL6FaoUrVds4dhCWeYyjElzLr4H4o03W1sZBVMRgipn5aUE9Gj0/R//cQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lWyOzyK9USraGk+KqxItGj4sL/sIeI3C9dVxC9LKKHY=;
 b=XOuYvc4tAqSpF4TUwMRTZQ1h03iNRIWZGYR/6DfBfncLepSmWFEx5OcYo3I582s24HYWapd8X4XL121xpiD2VQUjC1RzDYQBlDlWZetmcSJUesgegPHrODtbGfJYL9CKLKwMHAxEa//efUUZchrxkqYdxWIjb1+WhSAr8EWmyOk=
Received: from TYAPR01MB2285.jpnprd01.prod.outlook.com (52.133.177.145) by
 TYAPR01MB2669.jpnprd01.prod.outlook.com (20.177.102.203) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.22; Fri, 21 Feb 2020 10:13:15 +0000
Received: from TYAPR01MB2285.jpnprd01.prod.outlook.com
 ([fe80::1045:4879:77ed:8a70]) by TYAPR01MB2285.jpnprd01.prod.outlook.com
 ([fe80::1045:4879:77ed:8a70%7]) with mapi id 15.20.2729.033; Fri, 21 Feb 2020
 10:13:15 +0000
From:   Chris Paterson <Chris.Paterson2@renesas.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux@roeck-us.net" <linux@roeck-us.net>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "patches@kernelci.org" <patches@kernelci.org>,
        "ben.hutchings@codethink.co.uk" <ben.hutchings@codethink.co.uk>,
        "lkft-triage@lists.linaro.org" <lkft-triage@lists.linaro.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH 4.19 000/191] 4.19.106-stable review
Thread-Topic: [PATCH 4.19 000/191] 4.19.106-stable review
Thread-Index: AQHV6I9JzS0hdk3yWkilhKK8EfzpqKglbVjQ
Date:   Fri, 21 Feb 2020 10:13:15 +0000
Message-ID: <TYAPR01MB2285808EB540D90E812B514FB7120@TYAPR01MB2285.jpnprd01.prod.outlook.com>
References: <20200221072250.732482588@linuxfoundation.org>
In-Reply-To: <20200221072250.732482588@linuxfoundation.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chris.Paterson2@renesas.com; 
x-originating-ip: [176.27.142.199]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 4f92d8eb-98a2-43bd-2134-08d7b6b6aa54
x-ms-traffictypediagnostic: TYAPR01MB2669:
x-microsoft-antispam-prvs: <TYAPR01MB2669DA50015AA1F025CB331FB7120@TYAPR01MB2669.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0320B28BE1
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(366004)(199004)(189003)(8676002)(26005)(66946007)(66446008)(52536014)(66556008)(76116006)(64756008)(66476007)(9686003)(966005)(8936002)(81166006)(81156014)(5660300002)(186003)(33656002)(110136005)(7696005)(498600001)(2906002)(4326008)(86362001)(55016002)(71200400001)(4744005)(7416002)(54906003)(6506007);DIR:OUT;SFP:1102;SCL:1;SRVR:TYAPR01MB2669;H:TYAPR01MB2285.jpnprd01.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: renesas.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Yk16zoauf77nqPU7FDnfuTqzspG8Lm56z2/ojk9irOdB5kndJBB98pkx3+A5hdoAOVihsrYywQRhSWF9ZR34Xxm4RHxsoWAhY3kKI1XlXLQOMiOJlMX+EJl3UZ3Vn7SDtkFGhi6OYEr2W79n42yQON8qMU5JD/AtQlbOvpwfVoSpeqhJhRSKKCDDRWtpgHQwLhVt30zeJMo971+W157lVxk91ys3QMmKMO8Zy5timli6/euvt6NfuG31K+0JguXZ7P0zF0L6zT+fPjcJjpP9nFznODM2E7m8s2FxHcnNbKFa0y8lIesGLFGVowzcpiMSHFTjJeaNO2fvoMpAnMV1ejXp0AJJS9Mdn2FPdWNVbfbRdoUt0JN1KulZZvszUooDSvxOyWbUR4pkveLxLvL5uaUTEbMrbNMOUXkTsc8VkJz/+QksFBebYkgvgVdhTH5A9ibCwfsWRoehmsn6ciV2vx1+yrozckYJ4Bk0HiN8UMzhmCx+czvJ0j7GZsFwRJSxvV1pVhp7v2ZAedijm3WQxA==
x-ms-exchange-antispam-messagedata: BgnPpS4sUOpHM3L2sMdK8EI2/ktFZ65cXEJCjMBe3bE2PR+ltBJ2tXSmS62EK/1YJ5cASM3DpdsvOuaVPWQtJ0Oz+M6XEO/GaCfA+/2mpRZ7QnjulA3r0recakCLZT4dw+fKZsANDn+UYKSaxwnZZw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f92d8eb-98a2-43bd-2134-08d7b6b6aa54
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Feb 2020 10:13:15.2358
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4mSR6DeLGWwcA34r2rqCFUCU9kUkA66SkCBXr1giRehT2q4q99MMkifmK7fZSoovHBSC1162+3PCKgxzPCDILYlPM6dHSlnqynDnCcvkNy8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR01MB2669
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGVsbG8gR3JlZywNCg0KPiBGcm9tOiBzdGFibGUtb3duZXJAdmdlci5rZXJuZWwub3JnIDxzdGFi
bGUtb3duZXJAdmdlci5rZXJuZWwub3JnPiBPbg0KPiBCZWhhbGYgT2YgR3JlZyBLcm9haC1IYXJ0
bWFuDQo+IFNlbnQ6IDIxIEZlYnJ1YXJ5IDIwMjAgMDc6NDANCj4gDQo+IFRoaXMgaXMgdGhlIHN0
YXJ0IG9mIHRoZSBzdGFibGUgcmV2aWV3IGN5Y2xlIGZvciB0aGUgNC4xOS4xMDYgcmVsZWFzZS4N
Cj4gVGhlcmUgYXJlIDE5MSBwYXRjaGVzIGluIHRoaXMgc2VyaWVzLCBhbGwgd2lsbCBiZSBwb3N0
ZWQgYXMgYSByZXNwb25zZQ0KPiB0byB0aGlzIG9uZS4gIElmIGFueW9uZSBoYXMgYW55IGlzc3Vl
cyB3aXRoIHRoZXNlIGJlaW5nIGFwcGxpZWQsIHBsZWFzZQ0KPiBsZXQgbWUga25vdy4NCj4gDQo+
IFJlc3BvbnNlcyBzaG91bGQgYmUgbWFkZSBieSBTdW4sIDIzIEZlYiAyMDIwIDA3OjE5OjQ5ICsw
MDAwLg0KPiBBbnl0aGluZyByZWNlaXZlZCBhZnRlciB0aGF0IHRpbWUgbWlnaHQgYmUgdG9vIGxh
dGUuDQoNCk5vIGlzc3VlcyBzZWVuIGZvciBDSVAgY29uZmlncyBmb3IgTGludXggNC4xOS4xMDYt
cmMxICgyN2FjOTg0NDkwMTcpLg0KDQpCdWlsZC90ZXN0IGxvZ3M6IGh0dHBzOi8vZ2l0bGFiLmNv
bS9jaXAtcHJvamVjdC9jaXAtdGVzdGluZy9saW51eC1zdGFibGUtcmMtY2kvcGlwZWxpbmVzLzEx
OTg1NjUyNw0KUGlwZWxpbmU6IGh0dHBzOi8vZ2l0bGFiLmNvbS9jaXAtcHJvamVjdC9jaXAtdGVz
dGluZy9saW51eC1jaXAtcGlwZWxpbmVzLy0vYmxvYi9iYTMyMzM0Yi90cmVlcy9saW51eC00LjE5
LnkueW1sDQoNCktpbmQgcmVnYXJkcywgQ2hyaXMNCg==
