Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B6E750201A
	for <lists+stable@lfdr.de>; Fri, 15 Apr 2022 03:25:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242535AbiDOB12 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 21:27:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348420AbiDOB1Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 21:27:25 -0400
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42FB257B39;
        Thu, 14 Apr 2022 18:24:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1649985898; x=1681521898;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=oQ4WMNd78vefdve9alwAZCSYPR8NImEphaWC3zKWV9Q=;
  b=Kz32fe4yYXh6nI9NV5Tt27UH20939JLT2Sv8pCqmXa0RgJJD2zi9MoGh
   RqjpMsEYxqveNNxGZ+MYmcntkoBipscXdKtYoqCEpIL9LJvZgFONljpIZ
   fOb1S+gjDYuvKC0H2sm622nKHvufzdQQGWxTRQMUvlmtNVJnwSKAnBzLU
   z/pJBispWAMbdnWuBmlX9+1TgcRaAuREqpKDNhc/fBnkduyR4GowtkKNm
   8k0opIg4AjqfBgXJuMbqCZd7ucQrA45W5XsbCwopJTTCAJmeeo13xGj3X
   sWNS3eSdHYowbyD7QopuKcAdi2bdMXiIExJUBcTlGx4jiCOHhb4axtWLi
   g==;
X-IronPort-AV: E=Sophos;i="5.90,261,1643644800"; 
   d="scan'208";a="302150494"
Received: from mail-dm6nam10lp2108.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.108])
  by ob1.hgst.iphmx.com with ESMTP; 15 Apr 2022 09:24:56 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XQHXA/BLQgiYJVx7TQ1XBGNGRtegvJsAmp/4m5eAZnj6h6Urbj2Gt9SVuwQXDxN3q87s/Ykg48JfGdkkzGhV90VQPh5wgY1DmsGDNRzPXPuDuQMjwmaCMKMrrvCLIHmZmDfFjGUDx/lCushX3m1NMxNfctRtc49boPUptJdUkl+na3qKDAY3UoAeGR9tUYpwJigvZ+NyEkdHLZ3zhfi1tLtQ+MVMZi+eUrFXDx7uwi4dh4g7BRGhDgsU+vAFljpEBSBIW6TCBtX+XtuP/jApn6hp6BeW6DTN22fXpErqUW1fr9C01sWXzvLARsg89xVFhnQWUrDNHxap9MaB2AloCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sH1nvU3rTJQ76p8h0rWDB0qun67TvG+pOaVCpLY6AbE=;
 b=FWQO8N/QuCJ8y0rIFMYlUBsAP+gUcD74fIwGn+sokCU9tVgXW+6L7JbwMGpxIeD9QTiTY7tCOY+BETWgv0K11kVAtE7f7mdIuBuXzRNmWvTx4snS+cFagZVxguEmh3wXCS9dv7R0VTZTDxlD6hDXB1zzKWPIq8mu0aUFW+B5iX2bTupCXb4M+GhywOkQhFFuZ/xy2Bma39UGi/Gs5Q33p3xFPEjhPCG/sjv/YzoWamMz9fFPa1k+iuiVsl7dB5ZWB+zBfpaolhspeHKpes7gL1ryTJgywFNRP2nGDGsEghm5Ke5OtCKDOYhqZ1o8+cPwbWB0SQ+rZAurIZA86XGjlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sH1nvU3rTJQ76p8h0rWDB0qun67TvG+pOaVCpLY6AbE=;
 b=scfn12Itygpj3ugbpohhDMvVrjPo90ZO+SibLuiyAVAouVRM6Lr14Ts2NgTLn5gISJn4iqRcCbXh4qOF3J6r2xNmigvhG7TyId3wQNxE+LzZzmx0Ke7jTZrgqXBInBLCklGJRm9s0/vYWQIzmhMz7OeyOiIbYUOzb1hNrehe0S8=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by SN6PR04MB4591.namprd04.prod.outlook.com (2603:10b6:805:ae::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Fri, 15 Apr
 2022 01:24:54 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::995b:363e:8d1c:49af]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::995b:363e:8d1c:49af%8]) with mapi id 15.20.5164.021; Fri, 15 Apr 2022
 01:24:54 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Kees Cook <keescook@chromium.org>
CC:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Eric Biederman <ebiederm@xmission.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Greg Ungerer <gerg@linux-m68k.org>,
        Mike Frysinger <vapier@gentoo.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>
Subject: Re: [PATCH v2] binfmt_flat: do not stop relocating GOT entries
 prematurely on riscv
Thread-Topic: [PATCH v2] binfmt_flat: do not stop relocating GOT entries
 prematurely on riscv
Thread-Index: AQHYT9+B/BNFs63JH02JGuF3zm1OJqzwCKMAgAAm1YA=
Date:   Fri, 15 Apr 2022 01:24:54 +0000
Message-ID: <YljJZYNWXeWsT6HW@x1-carbon>
References: <20220414091018.896737-1-niklas.cassel@wdc.com>
 <202204141559.B2A0EB4F7@keescook>
In-Reply-To: <202204141559.B2A0EB4F7@keescook>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 53e1a702-0919-49cc-6074-08da1e7ebef4
x-ms-traffictypediagnostic: SN6PR04MB4591:EE_
x-microsoft-antispam-prvs: <SN6PR04MB4591DB8750E096BB92381663F2EE9@SN6PR04MB4591.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1PLSmtgs25ZTlMb0i/yQoQZj5bBX7eIXFsEVfkO3tIf0X6mQVZeDWj5ilyumuLDl4kR2Rt+r3kRP2IceeGk4y7wCVl0KO1YWfTZ+lWD4rczwUgOXOy6PMqQOXHoZzRfqqCc53dx9vOEdYeABhkOrL9bKDzdV9GcOKZrauQ6zB/zojlbZE5iuQN0mUWUd30P70VJrDiJI4Qr5lAvaIXCRbnGNUHQ56QI4iRxD7SNnnPVm6L55neb5HBHpfgnHWuQaDIHkASHFBtsE0Pochns++R7UujiIfXZy/joYafR4FPrnLRElO6zKfN9JmwTJ8QVNY6OK15KhK165D9Dj4tj4CXHAotVBySWM6W+RS2Hl+b4Tuw+cdiaK/kKWIMGvUrIckW8nMCx52tlF9eer9WMHsQUhcFui/tOiwPc9Sk5w0VZluf0LPss/rAc/KztHbWDwAY72s2B49JKZCDGMG/MHM+V5oNv1WNrAFxTAW/LcFSQeFDVgoJ4uCGEA9A9jWB/IloiG4mYGFQcIE0qhalVfbNjfrIfhWvtcTvLb1/Qamk6oBNMvwr2PUJXNjVHiD2DWcuFPnXcmwKYzz5cVhBuskn7wvpJydGd068vcQTwn7SD+EG1tEFOBBP2QWtMw8XEGIbs6jaDysXm9X3F0fBhq9PuTy7v5jvSmv2r84fGM/gosotnagc0XBLfdyn3+qFJBXNehCAgKvN6nl+45E6Q/7w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(54906003)(6916009)(33716001)(316002)(82960400001)(71200400001)(6486002)(38070700005)(122000001)(91956017)(38100700002)(9686003)(2906002)(6512007)(5660300002)(7416002)(8936002)(86362001)(6506007)(66946007)(76116006)(8676002)(26005)(66556008)(66446008)(4326008)(66476007)(186003)(64756008)(508600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?mDUr0mb2FsjiMZhOav4o/qr/a7WWvWX64+5qtKRb+QTQ1JqQDYcgXSR0pwZc?=
 =?us-ascii?Q?LA8GiU22Cf/D6iqjrrj2ZcyY4eKCxNfDm/laG4STAj7C4dlSrdMar57/PEpl?=
 =?us-ascii?Q?4ZiP4VuL7cNsxYP9tcYIhmjn/4htxagVSqUsL+2iWSyGUJ1mnCzxYycO0A6v?=
 =?us-ascii?Q?CZNs3wHY2PSODGvClgl+glZNs8hRNxF+nLolW4pgcWznCSEg1Z1ca5k2snBd?=
 =?us-ascii?Q?cIkzVQIZ/hBPo31e1rWa1OsegNVXMHHBK9SFqsRhR3H8mA2KvigpyRwc3f/6?=
 =?us-ascii?Q?QRLVPZBUpmADcuZKk1MUghY3qhniXew+amBdmb/eL2iJo9W2kjnpaSBxoapY?=
 =?us-ascii?Q?zVvxcxneX3A1mvWW+pKx1sPQfoHDkEl+ACQNiAlKZVNdBEIt00a7SAPlr6P5?=
 =?us-ascii?Q?fKW8g5f6ea+LyXm2lPYuSJjBKhrOMBSt+Api8jG8H11ATjxHgLVMUEX8R7VD?=
 =?us-ascii?Q?j+mHdqvYuCRRu6z4cRpxgqYljVhWYyAYJe2RLHsUbyNWICuaBiSukwn9cW6t?=
 =?us-ascii?Q?XujrtilDwdHDLRSCX+bpE7tumYAqf69fguB/0uEAz8eBOzOtpqa1GgAOjJHA?=
 =?us-ascii?Q?eAK4qaM5h9NoiznrOhldOZ2j9uc1HeJRjiN3W69qXABMhAeojYHVYavpGsSw?=
 =?us-ascii?Q?j0GVReG2tFYsHbH+HuqNRyDoEfb60KhVRwCtxn4FDToNo315wwkyG8/P5ZVi?=
 =?us-ascii?Q?Td7aRq8TUIoKVwcX9GxT4t6ezfCB6Rgdos8rcoD3Bwnit6mWwwUI3mPKLoUn?=
 =?us-ascii?Q?2h/F4qRVeMefn5/ov17AzeNqrj+ibOqzpdN82DAXrB1fxwwFnPTuFRw/o67K?=
 =?us-ascii?Q?2MLKQWNLL8GemJFXx7HGlVL3M4cgc6uJRGu1x6SFj8nz/7RlslE4qp7Ew/KV?=
 =?us-ascii?Q?YBrL36zsBx+DKnABrrjnF3Z0khQ+AqmavXjwS6XWEanZQVFDyw8iSmJuzVu0?=
 =?us-ascii?Q?Ep5//eBBtG/Vd0NkwRXqGqUN0Of7Ji4QikpTwTdLGN44krj/xOF3FL4RdvhQ?=
 =?us-ascii?Q?m9BJ7pZ4YBSUb75/wasQKONquzWwceq7BCRA4uvIFntLTGffU8fB7tvllLhR?=
 =?us-ascii?Q?FortRxBO5QQW81D4C3+81HlxkLKq4mUz+EstWmfy0jSd3fN79VYB0RuNQEap?=
 =?us-ascii?Q?49levyprQqyUV8V0bSb+NqzHeBbwT8nxhj8YQcdhB3530HTeKHE8DcfpfpfT?=
 =?us-ascii?Q?Oh+FRbkCHxoqH66bpjt2GxhXITZHgc2w5cvcTHZrZks8RiaTqQw7tShWxb+p?=
 =?us-ascii?Q?R/OdlXPlNyH2jNxcEt2qOlm0qj8C3vyAdEOJIx3JiJ5yrmyT/Xm1LEJC7ddl?=
 =?us-ascii?Q?NoaVLXAnFfOr9/7dL/hXXMi4l953MLelAcd06TUWFqgPVMaazEAxeM03/8Fs?=
 =?us-ascii?Q?aqT7uD9zoElKi+e7S6g7PHQuOS8+/0fuQPgt0Xh47GzomE/V8iCjLVdrLf5f?=
 =?us-ascii?Q?MyG1X23r6D7Lkh1zBdfRTSdR9IA/2CWRuNnZLh6Scma05f/LPc1Rs/d9rot/?=
 =?us-ascii?Q?5SZnQah6zWR9vhzf51budHx/ZB0BAmTkuPlxRQDOlniSwVZakuKq2KXTILT4?=
 =?us-ascii?Q?9nU64hStuTpWkMPmpejMqvoZiZtdYrqwV19QLiEB4eKBAod8AOxjo9iEM4Fa?=
 =?us-ascii?Q?xksGgg4VAd3yNSckS4UVvcUnUp3KAea8QSVw2mbOaQ+VXCsnAvkEooqHbxEg?=
 =?us-ascii?Q?FozMZISZ7TUE3Dvob7p9mGQwotIvuKG1ogK3YyqX1/Sgr+Nyk0RIxZI74m+0?=
 =?us-ascii?Q?ISnRT9palg7TrrUeUb1pDk+tEQg3bgs=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <13FC1BAC5C4FA34A8BCEA24F98F46511@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53e1a702-0919-49cc-6074-08da1e7ebef4
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Apr 2022 01:24:54.3183
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XHeF6GZX01fKhIMvVX0KhndHAdrvQjjTgutgZPv2BkrWX5y4N3gIew3tHCf4GNyr3ciwHSaKB0wapEP3FVT00Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4591
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 14, 2022 at 04:05:54PM -0700, Kees Cook wrote:
> On Thu, Apr 14, 2022 at 11:10:18AM +0200, Niklas Cassel wrote:

(snip)

> > +static inline u32 __user *skip_got_header(u32 __user *rp)
> > +{
> > +	if (IS_ENABLED(CONFIG_RISCV)) {
> > +		/*
> > +		 * RISC-V has a 16 byte GOT PLT header for elf64-riscv
> > +		 * and 8 byte GOT PLT header for elf32-riscv.
> > +		 * Skip the whole GOT PLT header, since it is reserved
> > +		 * for the dynamic linker (ld.so).
> > +		 */
> > +		u32 rp_val0, rp_val1;
> > +
> > +		if (get_user(rp_val0, rp))
> > +			return rp;
> > +		if (get_user(rp_val1, rp + 1))
> > +			return rp;
> > +
> > +		if (rp_val0 =3D=3D 0xffffffff && rp_val1 =3D=3D 0xffffffff)
> > +			rp +=3D 4;
> > +		else if (rp_val0 =3D=3D 0xffffffff)
> > +			rp +=3D 2;
>=20
> Just so I understand; due to the FILL(0) and the ALIGN, val1 will be 0
> (or more specifically, not -1) in all other cases, yes?

For elf64-riscv with a .got.plt header:
rp+0: -1, rp+1: -1, rp+2: 0, rp+3: 0

For elf32-riscv with a .got.plt header:
rp+0: -1, rp+1: 0

At least riscv binutils 2.32, 2.37 and 2.38 all create a .got.plt header
even when there are no .got.plt entries following the header.

Even if the .got.plt section was empty, there will still be data in the
.got section, so rp+0 will still not be -1.

If there is no data in the .got section, then the _GLOBAL_OFFSET_TABLE_
symbol will not be defined, so elf2flt will not set the FLAT_FLAG_GOTPIC
flag. (This code is only executed if that flag is set.)


Kind regards,
Niklas=
