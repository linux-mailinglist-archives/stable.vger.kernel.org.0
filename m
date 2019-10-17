Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1A54DB285
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 18:37:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727508AbfJQQhE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Oct 2019 12:37:04 -0400
Received: from mail-eopbgr790043.outbound.protection.outlook.com ([40.107.79.43]:15305
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729529AbfJQQhD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Oct 2019 12:37:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mDgcsFbiTKx2x/laEVH+iJdCcgNgJrJN1yKuxj+Hd+HLln1hOdz6xMH5V0uH/Gkz0LSn8B3Xzc1XzerovOwcDxvFCw5ZPlHBYR/MtlfCVkAUQ/5urfwTwKOv2Jy2mI01IIYLDnGvh3Eptke7UwkdO2wSnSvpS311FXkELqB691i4J/dhcHiLxYG9mTN/oT9jeHjGg/cQjOLr4Df5VoC50w0Bg3fr+JxIngvdZf2tKhYIpEP8vNjRVsGPXNnZfmLhXVO3gAkMQ5e/lJkDTNuSBMkcs2BtVYT5MJhV4UNkIH0vOD99bb8MaQ9ziqq6hcYAJ7KRv1WgsiLWqbZZzRV71Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9Y+x57QXn1I/hs86FjiAWQRmt3RzlPt55bAQfaa7cls=;
 b=JurrrOvNmbovs1rPmmumJ8trSm4DNtO1U3c0n53t+CXa6Wf//nWha2MQloA9bf0UKPe0WmRhnjm+bKdB4CiNZ+gUJ3fXP5LBSIKDWvACIJ8l1E8yWKnziFidRcDje+StrfLwWwN5PVw0T7pb1eIlEpwzgMCjXswMN5NqLSOeifnMzaRTFhfQPgCQ5KoJHA3DLHrXC5YcWbODVyZX6iCb2/yZgcEpAQpFwVsmaSVjwk4lMiwrhoN21Q3u92SA2ioHL3MaV5lTFuGOGqqsJ6GSrvaTTYLMG3Kw3/cR154sPDkpOOPKtEPxCoED9ZTfrHe7jZ0HdZ+ZHM3oEZ10TX+OCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9Y+x57QXn1I/hs86FjiAWQRmt3RzlPt55bAQfaa7cls=;
 b=zLCFLkEt9iqPqzydun+fZjTWlx3BFHwtyKqnmd5Xmv+bjM67TCyTXh6D9W8bK44gi4aH+Fsl+zS5QzfyXdItWbeUEPBnTUpAq90lM8TwP7N8pG7AifxOqEtwYJUUGJJWnWW+gk3U7O8gaYW06lt+hTIf3hpE9a8SGmufCdNcYao=
Received: from MN2PR05MB6208.namprd05.prod.outlook.com (20.178.241.91) by
 MN2PR05MB6798.namprd05.prod.outlook.com (52.132.175.214) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.11; Thu, 17 Oct 2019 16:37:00 +0000
Received: from MN2PR05MB6208.namprd05.prod.outlook.com
 ([fe80::f9be:d2d8:1003:99b5]) by MN2PR05MB6208.namprd05.prod.outlook.com
 ([fe80::f9be:d2d8:1003:99b5%6]) with mapi id 15.20.2347.021; Thu, 17 Oct 2019
 16:37:00 +0000
From:   Ajay Kaher <akaher@vmware.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     "dchinner@redhat.com" <dchinner@redhat.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Steven Rostedt <srostedt@vmware.com>,
        Srivatsa Bhat <srivatsab@vmware.com>,
        "srivatsa@csail.mit.edu" <srivatsa@csail.mit.edu>,
        Alexey Makhalov <amakhalov@vmware.com>,
        Srinidhi Rao <srinidhir@vmware.com>,
        Vikash Bansal <bvikas@vmware.com>,
        Anish Swaminathan <anishs@vmware.com>,
        Vasavi Sirnapalli <vsirnapalli@vmware.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: Re: [4.9.y PATCH] xfs: clear sb->s_fs_info on mount failure
Thread-Topic: [4.9.y PATCH] xfs: clear sb->s_fs_info on mount failure
Thread-Index: AQHVeJ883Cj90kJZYkWUHWw9u04UBadRD8wAgAHwX4CACt4fgIABnrsA
Date:   Thu, 17 Oct 2019 16:37:00 +0000
Message-ID: <6B4E533E-6853-44B0-AF94-EC27EBC082F4@vmware.com>
References: <1569965031-30745-1-git-send-email-akaher@vmware.com>
 <20191008174758.GA3013565@kroah.com>
 <F4C3D25C-A8FC-4A31-8CC2-1ABBA6CDF1C1@vmware.com>
 <20191016212209.GE856391@kroah.com>
In-Reply-To: <20191016212209.GE856391@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=akaher@vmware.com; 
x-originating-ip: [2405:204:549c:9b0:157a:adf0:3cf7:b301]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2e2b0870-6d40-4f09-7252-08d753203bed
x-ms-traffictypediagnostic: MN2PR05MB6798:|MN2PR05MB6798:|MN2PR05MB6798:
x-ld-processed: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR05MB6798FB70EEE1E5D77DC77A58BB6D0@MN2PR05MB6798.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:268;
x-forefront-prvs: 01930B2BA8
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(39860400002)(346002)(376002)(366004)(199004)(189003)(99286004)(6246003)(2906002)(4326008)(4744005)(76176011)(6916009)(6506007)(5660300002)(186003)(6116002)(33656002)(305945005)(102836004)(316002)(6512007)(7736002)(53546011)(256004)(81166006)(81156014)(8936002)(476003)(11346002)(8676002)(14444005)(229853002)(446003)(486006)(6436002)(478600001)(2616005)(6486002)(46003)(54906003)(71190400001)(71200400001)(25786009)(14454004)(76116006)(66556008)(66946007)(66476007)(64756008)(36756003)(66446008)(91956017)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR05MB6798;H:MN2PR05MB6208.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: vmware.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nYgE6n01BnQyjMrc1VgLq9rVM3KNYgbpCFwx7/Se5JO+4gWcglAQWr39+mFG3AT6rs/yflbIoREh02uWjm8YAZD8tm0A2UVCXl0xqVTLQC5onajI9Dej1EEeMYNArdAD8L8LA/s0507IbmkyquYNnZAsU0fGRPcJat81tYRg0z4RGZ7bRsJogISHFryj/YZf2IChljOOu42DxB1REdUJ+fDWVmJYX/jz4gyUuJspbmItcTA9hjC9/ZE51kAXc2oiwftrcVCqkFZh2h6IdVNguQcXLq+HwXKT7OVzRQFI/avZ7rBiaglot0PtCInDalMBySN5AKztuMyv5QxoP3gvAlPLiA2fyNQQL6+34aj2yItDx3Wv9zVIIZWQb8bmOTeNgGeu0v1DHtjp1b9kbVZKrXaD4cSkprgpppvGHM/j0S8=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A300459832016F40A65EE322E1B6F24B@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e2b0870-6d40-4f09-7252-08d753203bed
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Oct 2019 16:37:00.4960
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: J67k0AI4VbgG7ji+/jytcOfVzrojy46FRmvA3IoTgdNCqp4yHjC21HAZu2OgVv/1P3XHxRUiqxmFvwfxn+HA8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR05MB6798
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQrvu79PbiAxNy8xMC8xOSwgMjo1MiBBTSwgIkdyZWcgS0giIDxncmVna2hAbGludXhmb3VuZGF0
aW9uLm9yZz4gd3JvdGU6DQoNCj4gT24gV2VkLCBPY3QgMDksIDIwMTkgYXQgMDU6NTQ6MzZQTSAr
MDAwMCwgQWpheSBLYWhlciB3cm90ZToNCj4gPiANCj4gPiANCj4gPiBPbiAwOC8xMC8xOSwgMTE6
MTggUE0sICJHcmVnIEtIIiA8Z3JlZ2toQGxpbnV4Zm91bmRhdGlvbi5vcmc+IHdyb3RlOg0KPiA+
IA0KPiA+ID4gT24gV2VkLCBPY3QgMDIsIDIwMTkgYXQgMDI6NTM6NTFBTSArMDUzMCwgQWpheSBL
YWhlciB3cm90ZToNCj4gPiA+ID4gRnJvbTogRGF2ZSBDaGlubmVyIDxkY2hpbm5lckByZWRoYXQu
Y29tPg0KPiA+ID4gPiANCj4gPiA+ID4gY29tbWl0IGM5ZmJkN2JiYzIzZGJkZDczMzY0YmU0ZDA0
NWU1ZDM2MTJjZjZlODIgdXBzdHJlYW0uDQo+ID4gICAgIA0KPiA+ID4gWW91IGhhdmUgc2VudCBh
IDQuNC55IGFuZCA0LjkueSwgYnV0IHdoYXQgYWJvdXQgNC4xNC55PyAgSSBjYW4ndCB0YWtlDQo+
ID4gPiB0aGlzIHBhdGNoIGZvciB0aGUgb2xkZXIga2VybmVscyB3aXRob3V0IGEgNC4xNC55IHBh
dGNoLCBzb3JyeS4gIFdlDQo+ID4gPiBkb24ndCB3YW50IGFueW9uZSB0byB1cGdyYWRlIGFuZCB0
aGVuIGhpdCBhIGZpeGVkIGJ1Zy4NCj4gPiANCj4gPiBTZW50IGZvciA0LjE0LnkgYXMgd2VsbC4g
VGhhbmtzIGZvciBzcGVjaWZ5aW5nIGFib3V0IDQuMTQueSBmb3IgdGhpcyBwYXRjaC4NCj4gICAg
DQo+IFRoYW5rcyBmb3IgdGhhdCwgbm93IHF1ZXVlZCB1cCBmb3IgYWxsIDMgdHJlZXMuDQoNClRo
YW5rcyBHcmVnLCBhcHByZWNpYXRlIHlvdXIgZ3VpZGFuY2UgYW5kIGRlY2lzaW9ucy4NCg0KPiAg
Z3JlZyBrLWgNCiAgICANCg0K
