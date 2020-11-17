Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20B862B5D19
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 11:41:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727841AbgKQKkq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 05:40:46 -0500
Received: from mail-dm6nam11on2041.outbound.protection.outlook.com ([40.107.223.41]:17925
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727834AbgKQKkq (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 05:40:46 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VFAcERWsIU0ym2nbIQ7B9Q+flro+uEW2/RJ8JNmumP0d+qlNJIIWwRjdJFSRygs8xPmizri3TEdP/pmk6hH2FXkDul4fSAxtgS5AlKJG+Jyl0XOaiFllzvYc/i30T/exUNyIkK4Cr5AMw9EnzbMDzLp21In6cB0n13EqiSzvySLuZiJ5qWodRdxq5EGiof6LU4JdgkuP7RjLNIRQ/GTCtTyeoo6iTSJ9r7GDKFSY0yz/Vs6avP8Vaxh0qa/+RDog0e6dZ+uDZoHpn5suJvvNaKM1wlfJ3dmyKZilQfaMb7FbSEaVFThJ7+brjduLBSwwHOwv9XlgHnby9GvPqOMRsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uhfnbTypS902Z9hvOP7S29Ero9yfX7HkU796nsmFDy8=;
 b=E6APwl7Z2C1amOXMR8isLcbA0fECt5e5RdQ7oJ/MKJiVwJAxpiX7pKtID6AdRvUU4TdcAXXo/OqRRA2coeMRaoPuZFTsgZBwLsZCf8eYEL6D8mI+5ANMnO6lxaReYQ07Cd3gJE6pxZnJOxCxUr9604++4lkxkUDxSPnIa9wW2st8XUbuF5HzfGYg4N+3JY15Yypa+GPoLeAcovD1nB6fIG/KPGxWpOAN6vwGd204GqZBUb/ynHDSrIQS0r4uKfCvufWtNOwHypTIZDHtX91byZxpbDZVAxNF1s/bCHEtWpBJnWiT4Jd6YIAmNKRD8yzuziyTnW4xJ4tt31RZitJ+ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=infinera.com; dmarc=pass action=none header.from=infinera.com;
 dkim=pass header.d=infinera.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=infinera.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uhfnbTypS902Z9hvOP7S29Ero9yfX7HkU796nsmFDy8=;
 b=benINVPr5Va4YeRAJLZ0PH2RvxR9ZmtLBhQj6yHafX5qv7KbOcilK8uO/N8x3XgeRLt1SLFdCxW+HwsBYVLuFx85hUtCrPAOYJ19fPkb2cq/41LxgoeRq+Bl9Z5QWCpw+npPn4v/ecpO0IldAdiBW5w2FFjfdURPf9a3tUKC2aU=
Received: from CY4PR1001MB2389.namprd10.prod.outlook.com
 (2603:10b6:910:45::21) by CY4PR10MB1560.namprd10.prod.outlook.com
 (2603:10b6:903:2d::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21; Tue, 17 Nov
 2020 10:40:43 +0000
Received: from CY4PR1001MB2389.namprd10.prod.outlook.com
 ([fe80::6d08:ba9e:476a:8523]) by CY4PR1001MB2389.namprd10.prod.outlook.com
 ([fe80::6d08:ba9e:476a:8523%7]) with mapi id 15.20.3564.028; Tue, 17 Nov 2020
 10:40:43 +0000
From:   Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
To:     "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] ALSA: usb-audio: Add delay quirk for all Logitech USB
 devices
Thread-Topic: [PATCH] ALSA: usb-audio: Add delay quirk for all Logitech USB
 devices
Thread-Index: AQHWudMglpstayskekOO5Bc0b19TYanMKIsA
Date:   Tue, 17 Nov 2020 10:40:43 +0000
Message-ID: <07339bc75af562945e431b9bba23b0fa0ac303e5.camel@infinera.com>
References: <20201113153720.5158-1-joakim.tjernlund@infinera.com>
In-Reply-To: <20201113153720.5158-1-joakim.tjernlund@infinera.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.38.1 
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=infinera.com;
x-originating-ip: [88.131.87.201]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 92a0fd14-902c-41f8-6fa1-08d88ae53c5b
x-ms-traffictypediagnostic: CY4PR10MB1560:
x-microsoft-antispam-prvs: <CY4PR10MB1560B909BABDCFE0915BDBFEF4E20@CY4PR10MB1560.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BDJknuVL1guSEh/vU0CX/QY5pJGfU35wekjKW9BlF4UfAskefrmMuswjUIH1+7cEwCsth1PMtQcVBXcWO32/gmUqV5CWYVS5rUB8pd8eYGvzM1YXQLi7WmacGVlyEcY99UM+P8PusrWbOTRxJQN7NZZtEppOO/ytoKPkW1jrlweBgu+hR6v9sMVSI08vhN8HV4E4z6AtKTvsi75bVD7raXGizS0IGy7SuYm358okfp5KXV7ZFsDCDZr+N8tR2g+UifiswREyMR4Sw6qilcw0Jxo8rzxIkb3F1mJzfpCG6ZYzOkzE9l42Vb4dkeXTRrmX1NR4YPJantCpJ/f5FZSc3w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1001MB2389.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(376002)(346002)(366004)(39860400002)(83380400001)(186003)(2906002)(6486002)(6916009)(8676002)(316002)(26005)(66946007)(5660300002)(4001150100001)(91956017)(71200400001)(66446008)(64756008)(66556008)(6506007)(66476007)(76116006)(36756003)(2616005)(8936002)(478600001)(86362001)(6512007)(4326008)(450100002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: hJzdlp48q95nPa8MmOvF9sPHsbBu/R+B2f53ShswfQHWLxBIY26Mmc8wCr3JI/s1edhdmgnuDOuaLWS2Z7vYHg5oADNeCQzCcPAZp4vOyugzhUZlOCZTVnneQrH9aJPXR4y82UAhkmPtsJybmmxrQPK+UPzl/DiVic2U9wBGHD0v9qGsujJkgIsFXtVtxWAcBlh47c1dyXwe1MXDTJNWAbryFmVch4DVNaapVh0J0siDrd+3H70A69onqwhawB62Uf3yJSz8KHOMh8wqFVRYgAdvgLSOdadJlJeIAfuR4tzqu8Z4XDS8+WQRKc4mPMEDu7XAP5FauSFU7DKNI8iHI9POhJWRQj54Rs5YdjNP1ccUMykdf90lzakdEA21DasupXWxGmSvtlcrcuiY6VTEuXwfhdR6Q6HlZiJky/ApHchumdaCsuQOogBxlBIQz0mwwHEiVuh9dOOq3/Lh2sR00WA2xXVOLTIe+m2wh/NV+g5dQuA8JMDPDOEVOiyC2pARG2BoFNWCCDoTie9to3JM9XW9sfh2Z7ReDSdORtMeWFYqvq24BzMqqWAwUBPLbsD6krQu6hRwipQcFYQBD9dUjgaw0OVDswzAgrKZnUx8NBmKLp3TdqqPxvLXIrEBqX4SOfKMGW4prHVE9qvZsHXmjw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <117205A039564B4CA1CAA25441D5E4F4@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: infinera.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1001MB2389.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92a0fd14-902c-41f8-6fa1-08d88ae53c5b
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Nov 2020 10:40:43.6215
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 285643de-5f5b-4b03-a153-0ae2dc8aaf77
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lpU+VbEaAJesAIMUnwQCtQnTY0cKd28v7Vgvm1CXfCv3gQ66qIfOOVnKHmHSchknPhgOgsXKYePikIuzFI6upA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1560
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQpQaW5nID8NCg0KT24gRnJpLCAyMDIwLTExLTEzIGF0IDE2OjM3ICswMTAwLCBKb2FraW0gVGpl
cm5sdW5kIHdyb3RlOg0KPiBGb3VuZCBvbmUgbW9yZSBMb2dpdGVjaCBkZXZpY2UsIEJDQzk1MCBD
b25mZXJlbmNlQ2FtLCB3aGljaCBuZWVkcw0KPiB0aGUgc2FtZSBkZWxheSBoZXJlLiBUaGlzIG1h
a2VzIDMgb3V0IG9mIDMgZGV2aWNlcyBJIGhhdmUgdHJpZWQuDQo+IA0KPiBUaGVyZWZvcmUsIGFk
ZCBhIGRlbGF5IGZvciBhbGwgTG9naXRlY2ggZGV2aWNlcyBhcyBpdCBkb2VzIG5vdCBodXJ0Lg0K
PiANCj4gU2lnbmVkLW9mZi1ieTogSm9ha2ltIFRqZXJubHVuZCA8am9ha2ltLnRqZXJubHVuZEBp
bmZpbmVyYS5jb20+DQo+IENDOiBzdGFibGVAdmdlci5rZXJuZWwub3JnICg0LjE5LCA1LjQpDQo+
IA0KPiAtLS0NCj4gwqBzb3VuZC91c2IvcXVpcmtzLmMgfCAxMCArKysrKy0tLS0tDQo+IMKgMSBm
aWxlIGNoYW5nZWQsIDUgaW5zZXJ0aW9ucygrKSwgNSBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYg
LS1naXQgYS9zb3VuZC91c2IvcXVpcmtzLmMgYi9zb3VuZC91c2IvcXVpcmtzLmMNCj4gaW5kZXgg
Yzk4OWFkODA1MmFlLi5jNTBiZTJmNzVmNzAgMTAwNjQ0DQo+IC0tLSBhL3NvdW5kL3VzYi9xdWly
a3MuYw0KPiArKysgYi9zb3VuZC91c2IvcXVpcmtzLmMNCj4gQEAgLTE2NzIsMTMgKzE2NzIsMTMg
QEAgdm9pZCBzbmRfdXNiX2N0bF9tc2dfcXVpcmsoc3RydWN0IHVzYl9kZXZpY2UgKmRldiwgdW5z
aWduZWQgaW50IHBpcGUsDQo+IMKgCSAgICAmJiAocmVxdWVzdHR5cGUgJiBVU0JfVFlQRV9NQVNL
KSA9PSBVU0JfVFlQRV9DTEFTUykNCj4gwqAJCW1zbGVlcCgyMCk7DQo+IMKgDQo+IA0KPiAtCS8q
IFpvb20gUjE2LzI0LCBMb2dpdGVjaCBINjUwZS9INTcwZSwgSmFicmEgNTUwYSwgS2luZ3N0b24g
SHlwZXJYDQo+IC0JICogIG5lZWRzIGEgdGlueSBkZWxheSBoZXJlLCBvdGhlcndpc2UgcmVxdWVz
dHMgbGlrZSBnZXQvc2V0DQo+IC0JICogIGZyZXF1ZW5jeSByZXR1cm4gYXMgZmFpbGVkIGRlc3Bp
dGUgYWN0dWFsbHkgc3VjY2VlZGluZy4NCj4gKwkvKiBab29tIFIxNi8yNCwgbWFueSBMb2dpdGVj
aChhdCBsZWFzdCBINjUwZS9INTcwZS9CQ0M5NTApLA0KPiArCSAqIEphYnJhIDU1MGEsIEtpbmdz
dG9uIEh5cGVyWCBuZWVkcyBhIHRpbnkgZGVsYXkgaGVyZSwNCj4gKwkgKiBvdGhlcndpc2UgcmVx
dWVzdHMgbGlrZSBnZXQvc2V0IGZyZXF1ZW5jeSByZXR1cm4NCj4gKwkgKiBhcyBmYWlsZWQgZGVz
cGl0ZSBhY3R1YWxseSBzdWNjZWVkaW5nLg0KPiDCoAkgKi8NCj4gwqAJaWYgKChjaGlwLT51c2Jf
aWQgPT0gVVNCX0lEKDB4MTY4NiwgMHgwMGRkKSB8fA0KPiAtCSAgICAgY2hpcC0+dXNiX2lkID09
IFVTQl9JRCgweDA0NmQsIDB4MGE0NikgfHwNCj4gLQkgICAgIGNoaXAtPnVzYl9pZCA9PSBVU0Jf
SUQoMHgwNDZkLCAweDBhNTYpIHx8DQo+ICsJICAgICBVU0JfSURfVkVORE9SKGNoaXAtPnVzYl9p
ZCkgPT0gMHgwNDZkICB8fCAvKiBMb2dpdGVjaCAqLw0KPiDCoAkgICAgIGNoaXAtPnVzYl9pZCA9
PSBVU0JfSUQoMHgwYjBlLCAweDAzNDkpIHx8DQo+IMKgCSAgICAgY2hpcC0+dXNiX2lkID09IFVT
Ql9JRCgweDA5NTEsIDB4MTZhZCkpICYmDQo+IMKgCSAgICAocmVxdWVzdHR5cGUgJiBVU0JfVFlQ
RV9NQVNLKSA9PSBVU0JfVFlQRV9DTEFTUykNCg0K
