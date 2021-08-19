Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 152E93F0F7B
	for <lists+stable@lfdr.de>; Thu, 19 Aug 2021 02:28:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234482AbhHSA30 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Aug 2021 20:29:26 -0400
Received: from mx0b-002c1b01.pphosted.com ([148.163.155.12]:52170 "EHLO
        mx0b-002c1b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234294AbhHSA3Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Aug 2021 20:29:25 -0400
Received: from pps.filterd (m0127842.ppops.net [127.0.0.1])
        by mx0b-002c1b01.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17IGjvjk000625;
        Wed, 18 Aug 2021 17:28:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint20171006;
 bh=k9qLtBT08yc8M7dxiCOXTlFrS0IivxEzXD8VQ9UjR7c=;
 b=NDl61aSm19BphKCr3BNs+3JFPCf04TOOhVNd9e9KUO7fGA4MC+YMmImMQuriigrarYdD
 gOsyXG15Je8krnOU3zDZGAZ/uwQ7txSlbtSXkjrNo1m7kRsY8YQsZ7AyZgui2g2Gwe7q
 NX5qtu1ucTyXHm8xW1c6dOD98KST8AnrfRnXFYzBKRto68UURguyewOTPELM+YujhRta
 xf6QA8oyfpxZPolxkixwaOspR6Mxu/KQ7Wj8ySrgMDus6UPdWEbqOXFtt+dV3Bk3NsE0
 0aaUYSmFC1ig+oRv7O69KJ3zYzOlxxy6Eg4F6Oq3t/TEfkKYg8297Q5feosD5tjmHX4G Vw== 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2107.outbound.protection.outlook.com [104.47.58.107])
        by mx0b-002c1b01.pphosted.com with ESMTP id 3agym21qj7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Aug 2021 17:28:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Or9dKdRits8uCXyN1B9qaNNWOdQYsG4MzPEgqVH1moLHOzujKrtJ4L9tCgH+FX2IaAZg7EGCHgywk/Dt9KEWH48I/T51IvbyEj7o0nzVVBIGlId4GXxdEwoIMJY5Vus8FJjoHBwUnjVfG+xE6Z7jXmH0U5btlysP7NCfUb3POTr6akrCQYhMoGQOvNV92AccghoSN//jgF5x5Bm1lzvey7+/qs09j8ff3BdtMxhjWJWz/O9VrQfoDjX5dD5jayXhH4QznVe5hfihsf+wgSwq5fB2l/JB9tlsW/TrMs6O2UEQItuEdL9D3p2viq00l7l2AI82t/auO4u2GXS2wFlZUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k9qLtBT08yc8M7dxiCOXTlFrS0IivxEzXD8VQ9UjR7c=;
 b=Gnd42Gh2vve8KbRBkO+AUF2vz/45mUrWmT1mfjJcoNpNj+1AfI5BtyMokaDWm7CH3MM9GbXUwwGYmspEslaDQXY49meWCCvmedpKonSaJhW10o0ScezZwQrR+/Tbe4nJ4NQo4BssSi1xSxif28sOT4jZbYHa9JpV2RHHv5S3X2AOF+4nHWKG2MGF+bpwxKLJsJLoNAHyKEmLHHw9hQ47h4wGCDfoc2dXIrntzD0B/PsyL4yi9d24xbmGs9Cu1undv7WcH2gmpC1XPgdUTuUgsTs5QRYjV7YMqEbpSEHSFIhy3GPG57kJbKz0FWxghe8Tl6eWwl7UFAVRCbdxYBf+pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from CO1PR02MB8489.namprd02.prod.outlook.com (2603:10b6:303:158::17)
 by MWHPR0201MB3531.namprd02.prod.outlook.com (2603:10b6:301:7c::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.22; Thu, 19 Aug
 2021 00:28:41 +0000
Received: from CO1PR02MB8489.namprd02.prod.outlook.com
 ([fe80::84b4:fa2:b281:c43]) by CO1PR02MB8489.namprd02.prod.outlook.com
 ([fe80::84b4:fa2:b281:c43%9]) with mapi id 15.20.4415.024; Thu, 19 Aug 2021
 00:28:41 +0000
From:   David Chen <david.chen@nutanix.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "neeraju@codeaurora.org" <neeraju@codeaurora.org>
Subject: RE: Request for backport fd6bc19d7676 to 4.14 and 4.19 branch
Thread-Topic: Request for backport fd6bc19d7676 to 4.14 and 4.19 branch
Thread-Index: AQHXktGCsfrxxwEReUWMujEGbBEH2Kt2hLUAgAAopoCAAIvOAIAA0CoggADNCoCAAPdDIA==
Date:   Thu, 19 Aug 2021 00:28:40 +0000
Message-ID: <CO1PR02MB848977DE32D7353C4BB75C1794C09@CO1PR02MB8489.namprd02.prod.outlook.com>
References: <CO1PR02MB8489A10983A22C72447EEB5C94FD9@CO1PR02MB8489.namprd02.prod.outlook.com>
 <YRq81jcZIH5+/ZpB@kroah.com>
 <CO1PR02MB8489899CD7101180B2759D9C94FD9@CO1PR02MB8489.namprd02.prod.outlook.com>
 <YRtUNtyom4DDaa5a@kroah.com>
 <CO1PR02MB848942762455555DD6C9B9D794FE9@CO1PR02MB8489.namprd02.prod.outlook.com>
 <YRyu1XUkg2QyZWzS@kroah.com>
In-Reply-To: <YRyu1XUkg2QyZWzS@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=nutanix.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e70bb89c-c1c9-4567-ed7a-08d962a84b8d
x-ms-traffictypediagnostic: MWHPR0201MB3531:
x-microsoft-antispam-prvs: <MWHPR0201MB3531F2E546951C067A6EF3FA94C09@MWHPR0201MB3531.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Q4NkBtUUgBxoXBFe5IqIfmU1tPijaqGF2rf13r25gAtoaPrhIX4ZU5dRDkpVMFnsonr6K9n8xCakKoxzFf4NxJh6BjnUKHxegSOGmRkJKihcL+k9H8qlquvPy22jlhXvwxw54zOfHSc+zB4dVLotePyVIUEGlK/mmyx2kC/ac2gMP0bWs3IviuMY5HjkgzeMiBCaihTMqBgvyAxTFlH2qckgSYgcVGHdK7msxLfO864h1/PP6Qk7TeiRuWoDp+NCP7u8goAtsfmInBQ7DvFY0KM/dW7IzIez/UYOn3qKDdFPXcz4qK/wLVR7ADHeqmqOy8IT/3WfvQuDxEzdHobHaAQ1DLsE4hsIHAecmD04CHJuaVt8nQ9CgSb0QUOhBQurJ7SyLzuXXBQCVDsEVazjj0xXDBtfopfp6mS7Z+W/BVm7vclz3uuFhSYOdy/PA+eB2I1q5TYGmgTfJVTVg6M/eqqcCqkBG4B5QHOmkMIZNNIVA1mU7PfDAYOhz6j5epyAX7hY5QAqpknlTQo/dGpfeXDrZ9qCjsndQfp/lu774NekimncaSwJJMg+I0n/qZk/MKD+xJ1IspoEt+tLgeiCQK7bmwnFf4ulTAykvslzDzx4eQ9jK2jqBlpk8qVF9C/FioDZvANuj7LoRjQzSNh7SK/Z02g1Q6iktI1eKjRIqq2VHO6vRG3+yiVqUb/tcnZHhWJ7wIL5deZZ5TkLi2qNCjCT71HHA7dcSwXhIKqs15EV1AZsQFXakibjAi+t0/T/Pr+viAF9m6wb+7sQqq05/g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR02MB8489.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(376002)(136003)(366004)(396003)(5660300002)(2906002)(52536014)(66946007)(33656002)(83380400001)(38070700005)(122000001)(6916009)(26005)(316002)(66556008)(64756008)(6506007)(44832011)(66446008)(86362001)(478600001)(966005)(66476007)(76116006)(45080400002)(53546011)(38100700002)(186003)(9686003)(54906003)(4326008)(7696005)(55016002)(8936002)(71200400001)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?kj2ASfvUe4qmkZsgMeOqqF/8/shaE8Wz6/Gjt/ZElN2Kz57ZLJEDDXYIsh?=
 =?iso-8859-1?Q?2gZQPWPxu27GrQ72Le4I0zEjAWZ9fkCC3R25FQijeOher7hbzCuYwaMe5I?=
 =?iso-8859-1?Q?cbE+YxjiNewvekAfbqiGlA/fyAlh7bAuUWI3ufPt2A0GAQtf012q9g3Vu9?=
 =?iso-8859-1?Q?KJui9Xq2PLK6gm/WJXXEXGQHtc87/wz9PQSYe7cPCB9/Iq28Q/VEn84hMG?=
 =?iso-8859-1?Q?eubufuGNnBeUeBlJIAJOWp3v/8GrKzCxGO5wnV7v+TtFSpymrMJ52xZ/Pc?=
 =?iso-8859-1?Q?eLq0Env7YIziRNESEz0wVsWvbc1m4uXJI7Qh7deR30aPHTsZ9OZRynOHu5?=
 =?iso-8859-1?Q?6b3fQVZmvzQUg2bI3ZDAczSe66Nw+D6D9hTvzleND1uhgOB6C2Zq8xK2UI?=
 =?iso-8859-1?Q?0a9bv/DCwnR3J2dhUOGip1BXIRU07+XZ20sluyRahZ095auUdUAtCFAmU2?=
 =?iso-8859-1?Q?6sQhU0P8oGWwCvUoOVp1qSK609ze+znluVnjQjvvhPpxW0UYcCP7sX6jjw?=
 =?iso-8859-1?Q?nKkM8GyTsJYan5vwzjDpU4cfIKb5kghhmXKq+ihtP1pp8Yd3Q/yHk3TwZd?=
 =?iso-8859-1?Q?IXjcQIbqrG2Vj5waML9IDt3XGj2AVXEZYkslefiijJGih4WtuV0jyfzpad?=
 =?iso-8859-1?Q?fCRjy4tt4W+GZwF3bQF4yX04HabVJKwyalOebk6ZEt0Dk/2QvH+D8DQgU8?=
 =?iso-8859-1?Q?W0Et0x3Nem0OHQlQ4Bih/ATSHR+okDJAKopuiOey9a/DlxZEcmrHTn59ob?=
 =?iso-8859-1?Q?QRgzZhfrGA+zPIOaTlGIV5CcaQzMjEO8r3dZRPrrCjkCOhc+ADXbYUpOQt?=
 =?iso-8859-1?Q?vjKQFJ7B04KhHnVgWmAlgG1ea4DwmeMHxqMghiX773E1FP5jipUFub1QVL?=
 =?iso-8859-1?Q?PnXcdtX29PUi+I/c4DnQdafL2zQF88Rc7yi+DwWRs4Wk1FRrQlonmWkLN4?=
 =?iso-8859-1?Q?YwTB11JcVRTQ8aeg3j37b6+Hdkm8L/DK+V38roLOPTXxY1bM8FeGigEitM?=
 =?iso-8859-1?Q?8OxgOjY6kwblxTW1+GVf+5pF97h3X4+QEx9dcS5AW29k1wCJtR/9xXF/MX?=
 =?iso-8859-1?Q?DHQMGN5Ge8hn7vu+esSFcOIQbDyWCN/8LkehORJ45uXc8ntPJTbUFt3uzS?=
 =?iso-8859-1?Q?GdtL8ZoScJCTrqEKThvi3Zwv6LKEB+TtkqtaYkBdO/eGWxbCvFX/r/WTex?=
 =?iso-8859-1?Q?xBG5RSIRP8gmkREvVRQnhkymPQO1DIGfqcUE3B+e1lxTS0vsqyhBbA/V17?=
 =?iso-8859-1?Q?d175ZLYqPmEhQQaOHwLw7zSKxTHjxNGEbEPyp93oGmPnhoQ2xbekaa7iu1?=
 =?iso-8859-1?Q?QJx0QrtzLvSl8GFeYzDXYI3zN1SBbwNkpRfuq4xpPKidEr0=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR02MB8489.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e70bb89c-c1c9-4567-ed7a-08d962a84b8d
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Aug 2021 00:28:40.9971
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TE6PhDFq868yiW4feY6JC5HX6MZ+tPh6XoW0zX9M9eZwydCxozLk84ug2pRUpM1fcagSSH2AdbJxms4R+68lpw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR0201MB3531
X-Proofpoint-ORIG-GUID: 0-IMFyhaq8_t65t6BbVZuj95bNb-cPq7
X-Proofpoint-GUID: 0-IMFyhaq8_t65t6BbVZuj95bNb-cPq7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-18_08,2021-08-17_02,2020-04-07_01
X-Proofpoint-Spam-Reason: safe
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> -----Original Message-----
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Sent: Tuesday, August 17, 2021 11:55 PM
> To: David Chen <david.chen@nutanix.com>
> Cc: stable@vger.kernel.org; Paul E. McKenney <paulmck@linux.vnet.ibm.com>=
; neeraju@codeaurora.org
> Subject: Re: Request for backport fd6bc19d7676 to 4.14 and 4.19 branch
>=20
> On Tue, Aug 17, 2021 at 06:47:45PM +0000, David Chen wrote:
> >
> >
> > > -----Original Message-----
> > > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > Sent: Monday, August 16, 2021 11:16 PM
> > > To: David Chen <david.chen@nutanix.com>
> > > Cc: stable@vger.kernel.org; Paul E. McKenney <paulmck@linux.vnet.ibm.=
com>; neeraju@codeaurora.org
> > > Subject: Re: Request for backport fd6bc19d7676 to 4.14 and 4.19 branc=
h
> > >
> > > On Mon, Aug 16, 2021 at 10:02:28PM +0000, David Chen wrote:
> > > >
> > > >
> > > > > -----Original Message-----
> > > > > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > > > Sent: Monday, August 16, 2021 12:31 PM
> > > > > To: David Chen <david.chen@nutanix.com>
> > > > > Cc: stable@vger.kernel.org; Paul E. McKenney
> > > > > <paulmck@linux.vnet.ibm.com>; neeraju@codeaurora.org
> > > > > Subject: Re: Request for backport fd6bc19d7676 to 4.14 and 4.19 b=
ranch
> > > > >
> > > > > On Mon, Aug 16, 2021 at 07:19:34PM +0000, David Chen wrote:
> > > > > > Hi Greg,
> > > > > >
> > > > > > We recently hit a hung task timeout issue in=A0synchronize_rcu_=
expedited on
> > > > > 4.14 branch.
> > > > > > The issue seems to be identical to the one described in `fd6bc1=
9d7676
> > > > > > rcu: Fix missed wakeup of exp_wq waiters` Can we backport it to=
 4.14 and
> > > > > 4.19 branch?
> > > > > > The patch doesn't apply cleanly, but it should be trivial to re=
solve,
> > > > > > just do this
> > > > > >
> > > > > > -		wake_up_all(&rnp->exp_wq[rcu_seq_ctr(rsp-
> > > > > >expedited_sequence) & 0x3]);
> > > > > > +		wake_up_all(&rnp->exp_wq[rcu_seq_ctr(s) & 0x3]);
> > > > > >
> > > > > > I don't know if we should do it for 4.9, because the handling o=
f sequence
> > > > > number is a bit different.
> > > > >
> > > > > Please provide a working backport, me hand-editing patches does n=
ot scale,
> > > > > and this way you get the proper credit for backporting it (after =
testing it).
> > > >
> > > > Sure, appended at the end.
> > > >
> > > > >
> > > > > You have tested, this, right?
> > > >
> > > > I don't have a good repro for the original issue, so I only ran rcu=
torture and
> > > > some basic work load test to see if anything obvious went wrong.
> > >
> > > Ideally you would be able to also hit this without the patch on the
> > > older kernels, is this the case?
> > >
> > So far we've only seen this once. I was able to figure out the issue fr=
om the vmcore,
> > but I haven't been able to reproduce this. I think the nature of the bu=
g makes it
> > very difficult to hit. It requires a race with synchronize_rcu_expedite=
d but once
> > the thread hangs, you can't call it again, because it might rescue the =
hung thread.
>=20
> I would like a bit more verification that this is really needed, and
> some acks from the developers/maintainers involved, before accepting
> this change.
>=20
https://lkml.org/lkml/2019/11/18/184
From the original discussion, Neeraj said they hit the issue on 4.9, 4.14 a=
nd 4.19 as well.
I also tried running with the "WARN_ON(s_low !=3D exp_low);" mentioned abov=
e without
the fix, and force a schedule before "mutex_lock(&rsp->exp_wake_mutex);" to=
 simulate
a random latency from running on VM. I was able to trigger the warning.

[  162.760480] WARNING: CPU: 2 PID: 1129 at kernel/rcu/tree_exp.h:549 rcu_e=
xp_wait_wake+0x4a5/0x6c0
[  162.760482] Modules linked in: rcutorture torture nls_utf8 isofs nf_log_=
ipv6 ip6t_REJECT nf_reject_ipv6 nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_f=
ilter ip6_tables nf_log_ipv4 nf_log_common xt_LOG xt_limit ipt_REJECT nf_re=
ject_ipv4 nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack libcrc=
32c iptable_filter sunrpc crct10dif_pclmul crc32_pclmul ghash_clmulni_intel=
 pcbc ttm aesni_intel crypto_simd drm_kms_helper drm sg joydev syscopyarea =
sysfillrect virtio_balloon sysimgblt fb_sys_fops i2c_piix4 input_leds pcspk=
r qemu_fw_cfg loop binfmt_misc ip_tables ext4 mbcache jbd2 sd_mod sr_mod cd=
rom ata_generic pata_acpi virtio_net virtio_scsi ata_piix virtio_pci serio_=
raw libata virtio_ring virtio floppy dm_mirror dm_region_hash dm_log sha3_g=
eneric authenc cmac wp512 twofish_generic twofish_x86_64 twofish_common
[  162.760509]  tea sha512_ssse3 sha512_generic sha256_ssse3 sha1_ssse3 ser=
pent_avx2 serpent_avx_x86_64 serpent_sse2_x86_64 serpent_generic seed salsa=
20_generic rmd320 rmd256 rmd160 rmd128 michael_mic md4 khazad fcrypt dm_cry=
pt dm_mod dax des_generic deflate cts crc32c_intel ccm cast6_avx_x86_64 cas=
t6_generic cast_common camellia_generic ablk_helper cryptd xts lrw glue_hel=
per blowfish_generic blowfish_common arc4 ansi_cprng fuse [last unloaded: r=
cu_kprobe]
[  162.760524] CPU: 2 PID: 1129 Comm: kworker/2:3 Tainted: G        W  O   =
 4.14.243-1.nutanix.20210810.test.el7.x86_64 #1
[  162.760524] Hardware name: Nutanix AHV, BIOS 1.11.0-2.el7 04/01/2014
[  162.760525] Workqueue: events wait_rcu_exp_gp
[  162.760526] task: ffffa083e92745c0 task.stack: ffffb29442cb8000
[  162.760527] RIP: 0010:rcu_exp_wait_wake+0x4a5/0x6c0
[  162.760527] RSP: 0018:ffffb29442cbbde8 EFLAGS: 00010206
[  162.760528] RAX: 0000000000000000 RBX: ffffffff932b43c0 RCX: 00000000000=
00000
[  162.760529] RDX: 0000000000000000 RSI: 0000000000000286 RDI: 00000000000=
00286
[  162.760529] RBP: ffffb29442cbbe58 R08: ffffffff932b43c0 R09: ffffb29442c=
bbd70
[  162.760530] R10: ffffb29442cbbba0 R11: 000000000000011b R12: ffffffff932=
b2440
[  162.760531] R13: 000000000000157c R14: ffffffff932b4240 R15: 00000000000=
00003
[  162.760531] FS:  0000000000000000(0000) GS:ffffa083efa80000(0000) knlGS:=
0000000000000000
[  162.760532] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  162.760533] CR2: 00007f6d6d5160c8 CR3: 000000002320a001 CR4: 00000000001=
606e0
[  162.760535] Call Trace:
[  162.760537]  ? cpu_needs_another_gp+0x70/0x70
[  162.760538]  wait_rcu_exp_gp+0x2b/0x30
[  162.760539]  process_one_work+0x18f/0x3c0
[  162.760540]  worker_thread+0x35/0x3c0
[  162.760541]  kthread+0x128/0x140
[  162.760542]  ? process_one_work+0x3c0/0x3c0
[  162.760543]  ? __kthread_cancel_work+0x50/0x50
[  162.760544]  ret_from_fork+0x35/0x40
[  162.760545] Code: 4c 24 30 49 8b 94 24 10 13 04 00 48 c7 c7 d0 d7 05 93 =
0f 95 c0 48 2b 75 a8 44 0f be 80 d8 d2 05 93 e8 99 2f 70 00 e9 ae fe ff ff =
<0f> 0b e9 ec fc ff ff 65 8b 05 2d 40 f1 6d 89 c0 48 0f a3 05 d3
[  162.760570] ---[ end trace 2cc2ddd257a55220 ]---

The warning triggered mean that the waker skipped the slot it's supposed to=
 do wake_up_all on,
and would result in possible missed wake up issue.

> thanks,
>=20
> greg k-h
