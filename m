Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 815232F5B18
	for <lists+stable@lfdr.de>; Thu, 14 Jan 2021 08:13:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726055AbhANHMo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jan 2021 02:12:44 -0500
Received: from mail-eopbgr1400043.outbound.protection.outlook.com ([40.107.140.43]:24988
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725888AbhANHMo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 Jan 2021 02:12:44 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lEDZ5QKYpNhcbECJNbZbn/7BtOr5txXBH3oX9n6YH++e6KOCJ8GB9Tm7zh/rjiwz8ZAGleYpGrdV2U/MeI+IKrdicHbHiSEPbU9sfSeiOKXHDR2oiMDo12D2b1ESf5GqP52hJoL+po3JldWcsSpmw64RQA5X51vENHQZ1aw7qSKPAboWKvW3ErTfRCG00ZVE3Rf6T61Ey8bN3PokCdP/ZAPtLJwnQKODKTep6FQJftpRbRTxYD07JDnehHtbEaEJCLBmsxqNdbvg/f7F8V0OKmHEXcHf2bOnnl8GDEfa0TdDGoEA/Gpqee+kKYNeqVxF5A5jF55hPwWwywNJRexKvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/epOgBd/BBd/spKFK8yIXz6IEDtr5Bo50kl9YxlZ8Xk=;
 b=jB4Nr0Zi40vDLvPM4QlT105yUqxY8HgRrPQdJYA4r2xYJdDJ7/OLzgaiUvv39k66B7sH8Qhp3AnByANvI1okcKQtnKNBBCdpG+6nrcNa7+jwslfNlLuV7rFX/PqT62n40x8bZXYTftgvVFshlPxzHuZ1ZR+4CYSMUzyiRsacA/gZBgJ7FDxaUj1hDY2fDqD2RfU/MwDeYw5M1VKaJyy50SUFmyvfD9zLE7i8b1+NtdodTnXfhVdkZyzId1ybK8+lXOhQLIwuSkLp1i2sMkzthDAgy41hNVuckvMBWJb9+NbVKBmutlDc5VWOVpxA0cWpeZnNCoORofJXI8bSzR4Zcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nec.com; dmarc=pass action=none header.from=nec.com; dkim=pass
 header.d=nec.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nec.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/epOgBd/BBd/spKFK8yIXz6IEDtr5Bo50kl9YxlZ8Xk=;
 b=j79MjcEnm62PQquPI7AyNoHnVrVr5fIXUzGlTB8+6Tg2MuwtfAGbsumx7qL5VMlehksSm3gy3m3xrfqaaQ9EOoXFLSHWc0pRCcrx/a+JMNM9SjEdhoqFssd4gsfKRIYKLhvbl5IKQqXV6V24Zy0LdH4eg/MsBnZBJ38ug2qt5IM=
Received: from TY1PR01MB1852.jpnprd01.prod.outlook.com (2603:1096:403:8::12)
 by TYAPR01MB3965.jpnprd01.prod.outlook.com (2603:1096:404:c6::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Thu, 14 Jan
 2021 07:10:25 +0000
Received: from TY1PR01MB1852.jpnprd01.prod.outlook.com
 ([fe80::8453:2ddb:cf2b:d244]) by TY1PR01MB1852.jpnprd01.prod.outlook.com
 ([fe80::8453:2ddb:cf2b:d244%7]) with mapi id 15.20.3763.010; Thu, 14 Jan 2021
 07:10:25 +0000
From:   =?iso-2022-jp?B?SE9SSUdVQ0hJIE5BT1lBKBskQktZOH0hIUQ+TGkbKEIp?= 
        <naoya.horiguchi@nec.com>
To:     Dan Williams <dan.j.williams@intel.com>
CC:     "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Naoya Horiguchi <nao.horiguchi@gmail.com>,
        Michal Hocko <mhocko@kernel.org>,
        David Hildenbrand <david@redhat.com>,
        Oscar Salvador <osalvador@suse.de>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 4/5] mm: Fix page reference leak in soft_offline_page()
Thread-Topic: [PATCH v4 4/5] mm: Fix page reference leak in
 soft_offline_page()
Thread-Index: AQHW6heInkqG7QE910OSp4LbdxOpwqompd+AgAAOmQA=
Date:   Thu, 14 Jan 2021 07:10:25 +0000
Message-ID: <20210114071024.GC16873@hori.linux.bs1.fc.nec.co.jp>
References: <161058499000.1840162.702316708443239771.stgit@dwillia2-desk3.amr.corp.intel.com>
 <161058501210.1840162.8108917599181157327.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20210114014944.GA16873@hori.linux.bs1.fc.nec.co.jp>
 <CAPcyv4gVPMUD7P0KwAY9xk3xBkodPExeJVG6i9=9FGexbJZpBw@mail.gmail.com>
In-Reply-To: <CAPcyv4gVPMUD7P0KwAY9xk3xBkodPExeJVG6i9=9FGexbJZpBw@mail.gmail.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nec.com;
x-originating-ip: [165.225.110.205]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 99c42390-46cb-4e0e-4dc6-08d8b85b770c
x-ms-traffictypediagnostic: TYAPR01MB3965:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <TYAPR01MB3965712D89709DAEC1C36140E7A80@TYAPR01MB3965.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8EA9dXroqEbxcJFg30hj2s68dyQfhtkaFxnsILsK2j8gGhe1JmZPOVeSWcnOL2Lic3LQA90V041uG9nau1kQy++kBPkgcF5g/tCy/S9AzmcPisTqMXnNRZ54oeJKVwkVwTXrMRhBQ7RKMha3aPG55bBpjOrhLBcJIoIHzTHUVHw548PVyGjNqRM6hjm3klIK+I+t6SOovRujRAy7ebe80fyvsNIi8TlmDIwTqSv1tIzRHUV5xSSfoeq5isHuUIb65wmgVHKDrfNy6tpbXxAEXXGxpZRyUQSkAok21QfS4dGGGdkYdvljCpO35OvYwkpht8gEoYB/lLYMaUqFII8tfgKXQ7Wpy3QOzMs//v2xkWk7v5D6m6n+dOjb4UdT9kyOKIcI6eJgcctNO7UjVPjIyw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY1PR01MB1852.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(396003)(376002)(366004)(136003)(6486002)(66446008)(26005)(54906003)(5660300002)(86362001)(6512007)(6916009)(33656002)(478600001)(9686003)(71200400001)(7416002)(4326008)(1076003)(8936002)(66556008)(66946007)(55236004)(76116006)(186003)(66476007)(8676002)(85182001)(53546011)(83380400001)(64756008)(6506007)(316002)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?iso-2022-jp?B?NzJid1A2eFdDOHlVM2d5ZFRUOStRWFNkaEFrSU9GKzAwWmZpcXNpNXhW?=
 =?iso-2022-jp?B?TWtlZHRlQmt1cEtQUExXcEI5UmtZTU1PK3VjVkxsZng3U3NVT1pHaGRH?=
 =?iso-2022-jp?B?WTVtY1ZBZFFtN0lGUlNpb0gyQ3VUWHFwbkFUV3BYSmpDSFFlc3ZPT0Q5?=
 =?iso-2022-jp?B?TWtWaVNaZmNFVW54VmtNWldZRTVQa000UWFERW9ZMEhvZHlKWm9TVnJh?=
 =?iso-2022-jp?B?QzFyRHVPTHorZDFaditRdmxiUW0rMFB2a2NwM1VFSkJYQjNxY1duK1Vl?=
 =?iso-2022-jp?B?QXIrUlhEcElGbkYzVitzVENsR01NM2VVdThrQkJIYWtQaW5UN0h4RlZZ?=
 =?iso-2022-jp?B?Uml3UzZXVktQRGJJRW1hZ3QyNENCaGxZUmtadjNNOEtJQ2NTZzR0cVhR?=
 =?iso-2022-jp?B?Z2dBcjdyci9qL0szNmNyWUJuOUQxRkNtTzVUbXFyMlVCQTNRVWkybm5X?=
 =?iso-2022-jp?B?Z2QybWhKeGM4dXVlQ0FJN1RwM1Q5OEN4ZWV4bmZoL24yUHVvcmxBZWNr?=
 =?iso-2022-jp?B?RlZoZXdVT0RVa1VVMkRFd3RNT0VVeFVvL1VOWGJzSlBQK0xqZnlkbGFS?=
 =?iso-2022-jp?B?N1RMYndmekFrMjdRY09HMUVId0hzT0x5Z2JuVDhaTmpyT1QrcHpEejJJ?=
 =?iso-2022-jp?B?MU50a3FBR1RSMlVOanp3WTNmYURoS0tVY3Q3ejVrNkRkZnMwanA1NWZ2?=
 =?iso-2022-jp?B?RHk0RzVtUER2OWwyYlRZa2lGYkh1VHJuUVpRL3ZFOVRYcFM1RnVNMHVB?=
 =?iso-2022-jp?B?dVkvSWZLNHkxYnc0RUhlbHczSENFYXRHRnA0cnZqYjJKSFZ2dWhBTXFl?=
 =?iso-2022-jp?B?TGl1QmpuUHhycGUvcVJlZFBnVk9lcnVxRXJXRWNuTkk2c29UTDRIQUdV?=
 =?iso-2022-jp?B?MXExNTVlMzQ4Um4xUHQvNTk1QWFNejJzUTFzYXZyQVRWcjhPU3BoK1I4?=
 =?iso-2022-jp?B?K3Vkb0dyRm54ZDhZUVJwVUdUY1pMWG50NG5RcXFQOXhLUFZHT05zYlRR?=
 =?iso-2022-jp?B?dFJudTB2b2pPM2hQRldsUm5KcUNkb2dtMkUyOUlLanRpQ0dBcGxJMzNn?=
 =?iso-2022-jp?B?dGt4Mmdhdng4TmN6Wk1KSzhjb2g3MXZVZmNRbk02NDdVWEVSc1BTTENY?=
 =?iso-2022-jp?B?Mmk0UmM1cUVOUzVqYjhrSjRrSXY3V29xNWZDNEVuQndZeGlDWndadnNv?=
 =?iso-2022-jp?B?N1VhN3EwSFhrNG5CajJycXoySWpJRHVDS1d5a0N3d2hUT1VnRTBkWW54?=
 =?iso-2022-jp?B?aklsbWxHYWNla1VtcmM4Zno0dkdxaTVDc0VHcU9ncHIxYXgyNXU5TmZB?=
 =?iso-2022-jp?B?UGZ5SHlMQnI0Yy8zVmd3dHN0MENod2tZazhvNWZhc0QxSlh2UThsN2hR?=
 =?iso-2022-jp?B?Tno2bWNuNXRrNFZDeVE2UDB3M0IvcmJzeFRWREVuOWJESmpob2xTMTRx?=
 =?iso-2022-jp?B?UU5JQzA4R1lDbVB3OXBBVw==?=
Content-Type: text/plain; charset="iso-2022-jp"
Content-ID: <4C74EAC17EFC2D42B38E717AAF84678B@jpnprd01.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nec.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY1PR01MB1852.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99c42390-46cb-4e0e-4dc6-08d8b85b770c
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jan 2021 07:10:25.1145
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: e67df547-9d0d-4f4d-9161-51c6ed1f7d11
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KD2mf9YVU3Q1VduIk5Esoww47M46nkPwsrHqqjSEoWk9LpTJgq1d2T4qY7/41HiRcb1OcqLzduNmf2xsiJ8dOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR01MB3965
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 13, 2021 at 10:18:09PM -0800, Dan Williams wrote:
> On Wed, Jan 13, 2021 at 5:50 PM HORIGUCHI NAOYA(=1B$BKY8}!!D>Li=1B(B)
> <naoya.horiguchi@nec.com> wrote:
> >
> > On Wed, Jan 13, 2021 at 04:43:32PM -0800, Dan Williams wrote:
> > > The conversion to move pfn_to_online_page() internal to
> > > soft_offline_page() missed that the get_user_pages() reference taken =
by
> > > the madvise() path needs to be dropped when pfn_to_online_page() fail=
s.
> > > Note the direct sysfs-path to soft_offline_page() does not perform a
> > > get_user_pages() lookup.
> > >
> > > When soft_offline_page() is handed a pfn_valid() &&
> > > !pfn_to_online_page() pfn the kernel hangs at dax-device shutdown due=
 to
> > > a leaked reference.
> > >
> > > Fixes: feec24a6139d ("mm, soft-offline: convert parameter to pfn")
> > > Cc: Andrew Morton <akpm@linux-foundation.org>
> > > Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
> > > Cc: Michal Hocko <mhocko@kernel.org>
> > > Reviewed-by: David Hildenbrand <david@redhat.com>
> > > Reviewed-by: Oscar Salvador <osalvador@suse.de>
> > > Cc: <stable@vger.kernel.org>
> > > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> >
> > I'm OK if we don't have any other better approach, but the proposed cha=
nges
> > make code a little messy, and I feel that get_user_pages() might be the
> > right place to fix. Is get_user_pages() expected to return struct page =
with
> > holding refcount for offline valid pages?  I thought that such pages ar=
e
> > only used by drivers for dax-devices, but that might be wrong. Can I as=
k for
> > a little more explanation from this perspective?
>=20
> The motivation for ZONE_DEVICE is to allow get_user_pages() for "offline"=
 pfns.

I missed this point, thank you.

>=20
> soft_offline_page() wants to only operate on "online" pfns.

Right.

>=20
> get_user_pages() on a dax-mapping returns an "offline" ZONE_DEVICE page.

OK.

>=20
> When pfn_to_online_page() fails the get_user_pages() reference needs
> to be dropped.

The background is clear to me, and I agree with this patch.

Reviewed-by: Naoya Horiguchi <naoya.horiguchi@nec.com>

>=20
> To be honest I dislike the entire flags based scheme for communicating
> the fact that page reference obtained by madvise needs to be dropped
> later. I'd rather pass a non-NULL 'struct page *' than redo
> pfn_to_page() conversions in the leaf functions, but that's a much
> larger change.

As Oscar mentions in another email, removing MF_COUNT_INCREASED was
recently discussed and rejected. I think that if pfn-page conversion
layer is somehow factored out from soft/hard offline handler, code would
be more readable/maintainable.

Thanks,
Naoya Horiguchi=
