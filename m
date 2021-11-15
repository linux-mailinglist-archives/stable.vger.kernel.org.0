Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76A1E45030C
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 12:04:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231278AbhKOLH1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 06:07:27 -0500
Received: from mail-dm3nam07on2073.outbound.protection.outlook.com ([40.107.95.73]:58849
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237566AbhKOLHP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 06:07:15 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lNAVtEIaihB2R/1pn621/Kz7N/huXW2X/VJxnY2NEhkOJX2SkuC5+aqm707jirKYUAeU16+yQuJABLxknXDgFMEZRHIgA+hBrjv23xGs5thlfiJcEDB9Bb9SVexMUxrubFZxO/z6aN2zOe/PaMMXN46DZwh5LBt6AMQkb1r8PVAsJvzcGigFCyoecRsk6y5Nx7eWWX1OqGt5odIFJ7FIDKMvTvYaoHhHEojYR0YuXf8lREpLRNj8TYkM6UFe9DQeH85ln166qoHLyYcqM+Dwr01djYNgrW2BKDHtsvjBFIBueCAfnuWYkotO7Lwli/kepU9pNEKRxoSiIj7crlXp/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6CYe7hI9EuyLWWHfXGxjXmQnW0anutBsLBl4zHG9MBs=;
 b=VkgkEzFP7aKa6xRFUR6rVeglaQI+kChTcR7oG+/RFVPF3IBu2flHTvPOZsBn7by0GODpBTzxa0WhbZQ8XebCNIcL/GMa68qVDRUK64C0OZoNGSj+75CDJiHsSt4ImvrErQs8CX4uLAAIwyrUQVWT/YUp7iBwimTiC1dxsxcUmRNx2fOZBhgQ/7Ia58POxq0TkRyAYOhEkRusbZStXF77wGsW4Z+IIQFIJeCU4nRQ5fNTLGQqZYUAqyHG2W6EhEJJ4PIT0PKdCig8pVfmZFpUueQL4Pc76NE7KNZARPEXfTIi8XwtbR/ivBo2aud2552fHG0+FjC4/kuLOjXEzRphGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6CYe7hI9EuyLWWHfXGxjXmQnW0anutBsLBl4zHG9MBs=;
 b=f3MZSyJhhwIEsmLPb3BewnQPb70XP9KYLzIFOejg9HEZHb+ETSya3Ov+GvidYKQxUSB6fWfmhDDLWTQV9v6XKlrrwyRm6LV96N8q7H1U9A/maXSfRJnQu9G9znXig4jOfnHCTgV6Ai4Ber4ctDuvzZROAbnSCKJXpz00rWPOuGM=
Received: from MWHPR05MB3648.namprd05.prod.outlook.com (2603:10b6:301:45::23)
 by CO1PR05MB8441.namprd05.prod.outlook.com (2603:10b6:303:e4::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.5; Mon, 15 Nov
 2021 11:04:17 +0000
Received: from MWHPR05MB3648.namprd05.prod.outlook.com
 ([fe80::d871:f5de:8800:46dc]) by MWHPR05MB3648.namprd05.prod.outlook.com
 ([fe80::d871:f5de:8800:46dc%4]) with mapi id 15.20.4713.019; Mon, 15 Nov 2021
 11:04:17 +0000
From:   Alexey Makhalov <amakhalov@vmware.com>
To:     Michal Hocko <mhocko@suse.com>
CC:     Dennis Zhou <dennis@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "cl@linux.com" <cl@linux.com>,
        "mm-commits@vger.kernel.org" <mm-commits@vger.kernel.org>,
        "osalvador@suse.de" <osalvador@suse.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "tj@kernel.org" <tj@kernel.org>
Subject: Re: + mm-fix-panic-in-__alloc_pages.patch added to -mm tree
Thread-Topic: + mm-fix-panic-in-__alloc_pages.patch added to -mm tree
Thread-Index: AQHX1OJIWPaykZv/p0er2gRbWiPNoav64CoAgAABpgCAACaDAIAFMc8AgAQ2uwCAAAZtAA==
Date:   Mon, 15 Nov 2021 11:04:16 +0000
Message-ID: <B8B7E3FA-6EAB-46B7-95EB-5A31395C8ADE@vmware.com>
References: <20211108205031.UxDPHBZWa%akpm@linux-foundation.org>
 <YYozLsIECu0Jnv0p@dhcp22.suse.cz>
 <af7ab3ce-fed2-1ffc-13a8-f9acbd201841@redhat.com>
 <YYpTy9eXZucxuRO/@dhcp22.suse.cz> <YY6wZMcx/BeddUnH@fedora>
 <YZI5TEW2BkBjOtC1@dhcp22.suse.cz>
In-Reply-To: <YZI5TEW2BkBjOtC1@dhcp22.suse.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vmware.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 524ad6c4-bbbb-46d9-19de-08d9a827aab1
x-ms-traffictypediagnostic: CO1PR05MB8441:
x-microsoft-antispam-prvs: <CO1PR05MB84416EA1C0D8317BA42C9CEED5989@CO1PR05MB8441.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RQjSRQodxRN2/AgtMC0+CyuKDlSvUDU9lBeyCviDFNqb4DYJzv+eoVmle9BZtCJKCTw9LKTNXFZ2Szp+CJFz1HOA0ZvcjfJEjNYhvIjDUWK9C95v3P+ILO9OIw91C9IttgGPdsFj7jyW9iTxrI+QLHB8c/HvFELq3ECZxP7qRiIrbrzBw9Eesv9rMDIOJQhH6+v0ruuIPD/yy+iFBoKsnSBQq3EUlZxkCR7Gj76r2IHb7huj+mnGB1S9F9wRmR83/svmWkYwUvUaEGCRXViKu4oGoZjAD33qcIl7j4VILu1Rs6e0t7b6o9j1kXUfqs6eLviKWopHLQTCArA76odb+ao4MKBXfiIQzLwgXU/nQV87TNQq6Uj+k6yAlaZLYjfW4Hyw49cx/yDEI2o79aw8lws55jQs7+P4FotVbE+r3ulIZQW34pkXZ7hDLzHzyzG7dToOeBy3psNu4KzJvYmNRBMsn5MvF5kkO3SwCYS2pVxJqk2NSNRvDHMwjSTbe/FAv5TYy0r8SLDKvWRWiCKTqCrXzgP9Fag1anOXH4cCzqDjAAiO8TeDMrztmQOa2isHul5nmIBCUwTx0yNAPnuMSEkju2HbFC5dBgqzOE3qKwgOF+ed/dqNUpiVRZ2DdGL407a60OQtyjIpLYWS40WffHmDGyXIGxi18J2jcD4aLO5A3WbFjWG6CYBm/ImeI1wJGc+odsb3CbHG9bEp4q1ckAQkUoPO1fm2TGXSOFaBgBcz3mnhBokELpyPvMmjtmBO
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR05MB3648.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4326008)(316002)(54906003)(2906002)(76116006)(91956017)(86362001)(83380400001)(38070700005)(99936003)(8936002)(66476007)(66556008)(64756008)(66446008)(4744005)(186003)(66946007)(6512007)(8676002)(122000001)(38100700002)(36756003)(508600001)(2616005)(5660300002)(33656002)(71200400001)(6506007)(6916009)(6486002)(26005)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?enIyOGFhTkFZMUJsTnJsNzNybFNpY0lWYTZsNHk1Q3k5RkluVkNsenpvSmF5?=
 =?utf-8?B?TXRaUWtxMlV3VDgxOGlxdFpsb3RmRm9Mck5RS3J1VGp0b04vclVTVUpORUl2?=
 =?utf-8?B?VGJGQmsyb2l0WWR1OHV3cnk4V3NWZURvcUdhaFdsTHZIWE5HTlU3ZDM3QldK?=
 =?utf-8?B?RUNZZlQ4TFAwWFBXclBDSFlCUWwreWkxWUxUVUFIMGxnT0pzTDBPNU12Z0Ns?=
 =?utf-8?B?UXV1aGRoK25jZTVJOHlsNVJpR0ZCL01IMEZSb1I5TFg1RWs1M2hOMXZuWEtt?=
 =?utf-8?B?RDE5cE1Qclc3UGU1TzhTWWNaYzZ3YWpaeHRvQTgxSU1vMWE0UHB0emZpQytS?=
 =?utf-8?B?VVNkcVg0ZGh2Q1pZRnJMbjVmMUYzNzJwVXAzNEVCUEVwRTd2Q3F3c3A2NHNS?=
 =?utf-8?B?OXNIb3luTlhEaEVrZlNrb1h3bXhDdmVPVk1wVEx5VTJsUzh4WUpvRHhVYWth?=
 =?utf-8?B?WVhETTNoTnFOZUxMYTZWWkF6b2tqeHhnVTRYRjkrWVRNMHJDenllZytWUDFs?=
 =?utf-8?B?TVF3OTRpOTJ6ZWdSTWdqTmU2cGxNR1pWbmMzOUd6WE5lRG1lME1NRkYrWlVT?=
 =?utf-8?B?QUhYNGk1a1RHeHFVOGdVQWpXcEFCR25qN2xyYlJ6MjEvblYzeU9UbnBkclUx?=
 =?utf-8?B?dXIwS0NIOUxlSTVTVm5YRXdIK0ExYWw0NnlRNnlNazV5RlluK2RzeUdUN1d2?=
 =?utf-8?B?anQrSU5WaW5KU1FjQVMvSWhMRis5R1JiOC9MdXA4Y25USTZIMHRDdGFueDJJ?=
 =?utf-8?B?cW56bDVleURVVUx0blJkblhqWVJzdVcvd2hnTXBIQkt6R3ZrbWx2NXhRR2dp?=
 =?utf-8?B?NnpIVTZ1R0grYW1iVGE5ZWYyS0Y4UWhZSGkzT0w3MWQ0OGY0RWd5S241N1Ey?=
 =?utf-8?B?RDZyTFhIYzRLaUQ1S3VOQk13R2wxbHVOaFIvVHRFWTkxUGczS0p2WExqOEVI?=
 =?utf-8?B?NXBhajJuTEU5QU5KaVBYcVI5SG1JZ25LZ2VFSG9rVzE2MU8xUmhTNmY3M2E5?=
 =?utf-8?B?Y2lHVEVuU09GSnl4dDh0dXZGblI5TVhjaCtZREo0VGdoQkhURERaWHRLWVIv?=
 =?utf-8?B?RHhZMmt2dUxSOGFNZGc0Wm9iZmh1SXdMUkVGRVkxTlRGWktZQlJTZWhpNVE1?=
 =?utf-8?B?OUtUbXFjcFYzYndaS05kQVFtakQyTjFhOG55TEF3WEtjdjFMQlBPQTBVQkVp?=
 =?utf-8?B?Q0F5ekpsamJBMjUxL3MyZ3lkNUZuYXdncXlOc2ZaQlE5cmhPNVFySVoyTjNa?=
 =?utf-8?B?eGZRemVJdVVEVlBNbUlxN0ZIczZkTlN0WWZBcWFDeUtncThPQ2NpTmdISzgx?=
 =?utf-8?B?eDkyTEx3eWxBK0MrZnRzTnY1N211cFgvakNmUzdCQWEvOGs1bmppMHJwcmM4?=
 =?utf-8?B?TktnZmp3YWM2d0gzNjgxOXNBTmNpWVNlMUhLV2x1czV1ZkdQUW5lLzIyWDZz?=
 =?utf-8?B?OEF1d0FsVllkbzZNbnZqWlU0Q3RQMmM5VUZpcXRMdVdiVW5rRVJmWFp1Zk1M?=
 =?utf-8?B?aEV2MFpuL1VGcVZETmtRTCtiSFhGVkFTNnRJOHowLy95YlBSUy95amRSbEU0?=
 =?utf-8?B?VTdzS0pyVk5PSzFEbmNjNEdyTFBiL0thZTJ2MUh4WkQ0ejlrSit5OXYwY1N5?=
 =?utf-8?B?K3ZHdjRLTWJmVGpSaGhiUFMxS2JxZWJpNGJpOTRiVCtDdi82U2lMQUNSQ2dQ?=
 =?utf-8?B?d0diUWU2REtqdURFSDk1eUQ5QXpCUFZrSWdkN3lzV1dBbUZuVHJIN3ZYUzZq?=
 =?utf-8?B?WXJOclBxekxkWGxObDFhNGJzdHJIbm1SZHZXSmdSTm1sV0FoNy9BZkN3ckdY?=
 =?utf-8?B?UzZwQXVjdkRoSDRVUmFORU9EbEVabmU1NGpqNU11Wm94cXpoKzJGWWdhSUMx?=
 =?utf-8?B?TU9LQU95dWE5RWYxbzg4Qm1XekFZVkxvMVJYNGNxOVJYQmI3eWY4bUJMZXpa?=
 =?utf-8?B?TU53YUVxMWt4Mm9jVHhVTTJTQzNoOWpjVGxEbXlzcEQ4ZWRPM05wTFNYdHVP?=
 =?utf-8?B?N0thNHJ1Zlh6c2VKYVQvdEVVd1drY1FYVTcrOENYdG45OUF1UW5NTlpRMkhR?=
 =?utf-8?B?QWMwTkQxbkVyNlE4REhYMCtLWjlSd1NVdkZ4eFg5bSsvemtGM0Rxak13R2lh?=
 =?utf-8?B?UnN2NkI3L3ZOSUVBUlIwdGhuUWRRemlWZjdyVzZSYXpwYTRQVEtDdGtxTVcy?=
 =?utf-8?Q?jdWUkYgl1vGHYNHCUczJMhE=3D?=
Content-Type: multipart/signed;
        boundary="Apple-Mail=_C3B3FA11-46E7-467E-B524-98301AFF122D";
        protocol="application/pgp-signature";
        micalg=pgp-sha256
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR05MB3648.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 524ad6c4-bbbb-46d9-19de-08d9a827aab1
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Nov 2021 11:04:16.9990
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zjlKzxw/7jYe6SZDV8L8bQ7gCBmmQjFbXOCTcfDP0VT9o1E8HxYb/ThLVTk4Zcrqnzxt5/XAGKyDBscZIfONiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR05MB8441
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--Apple-Mail=_C3B3FA11-46E7-467E-B524-98301AFF122D
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8

Hi Michal,

>=20
> I have asked several times for details about the specific setup that =
has
> led to the reported crash. Without much success so far. Reproduction
> steps would be the first step. That would allow somebody to work on =
this
> at least if Alexey doesn't have time to dive into this deeper.
>=20

I didn=E2=80=99t know that repro steps are still not clear.

To reproduce the panic you need to have a system, where you can hot add
the CPU that belongs to memoryless NUMA node which is not present and =
onlined
yet. In other words, by hot adding CPU, you will add both CPU and NUMA =
node
at the same time.
I=E2=80=99m using VMware hypervisor and linux VM there configured in a =
way
that every (possible) CPU has its own NUMA node.
Before doing CPU hot add, udev rule for CPU onlining should be disabled.
After CPU hot add event, panic will be triggered shortly right on the =
next
percpu allocation.

Let me know if this is enough or you need some extra information.

Thanks,
=E2=80=94Alexey

--Apple-Mail=_C3B3FA11-46E7-467E-B524-98301AFF122D
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEQe6bu7hIFElmsM7CGW4w8WwwaSUFAmGSPrAACgkQGW4w8Www
aSXapBAAhr1SijiRAVZNuj5A2YdTY9+PYSBxMX3ukFCDj6ri9LZ3QZb9fTfxyR2e
fMMuqhl1MChUg2k1XBtF6buFITBBT8rOnAHaySTIhuVzAODeH7SVk7zWlUBvYsKm
uMaIihJ5nygh11XjtkSd5OdIE1jh6DoHeo/10T16kL783pHy9O2aV+vCCtMXcKrG
cNfDitnTfElf+vNBx5rLSwqxgQwB2Ubg+n6JZcQFEYl/xSitdY/mpN1sE/PlVxp6
+FL64I1c8rojiPfEgMI7D1yH2hJCRm/3K2CdtNsoZgsB9NxYxfEaPGzjwK8ygsWj
tka7sgjmAfs1Fl9cCaNExRdN/CIvFlPd6/NBYu3fHxVi/lhLm3UgnDqoe0kmP2gm
47NMMadCNq2xZy4Pa2p5eXkInsQaa90oAjbRK0D45tTuRsY69Gv6R/hB5xhVl73Q
+hUlaB3q99MphBfxXMhSOv29rtLklFQrEQT9XurnNJIH5dBlMKG0+UjVf1bfH1YO
xhdCIiXiDPaPwSUx2qE+GEobpdVwCGJslAm5qCWG8J6nBG7qQ9GiqFifGBw9RjBr
Uf0/0NMf6c1PbhH8DDOypQ7txJiaMJ7wawWWKIH/sZbVUBfJCGs+y8RttHH/o+Nh
TWeRyltAoUYMk6mkl3P/lG5N+UvtUjkxmRI0/pJRJ+cQbWvC3B8=
=alns
-----END PGP SIGNATURE-----

--Apple-Mail=_C3B3FA11-46E7-467E-B524-98301AFF122D--
