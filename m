Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F5DE4FE11F
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 14:53:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354445AbiDLMyk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 08:54:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355251AbiDLMxz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 08:53:55 -0400
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE072F4;
        Tue, 12 Apr 2022 05:26:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1649766366; x=1681302366;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=pFldmPxT8RaCe+cHlQbK4WhWpYOM4nj9aL6JNncEsvU=;
  b=PDiLTxxjeWl3/A3MdI+u8fT7kU14w/lURa9Z93s8jfgkLa8Ems/8zfp0
   Xxc2Mr3yWgzYb/1M9Wu1qwtU/ubjUTknpk605nCw9W2UnUDA4pgiIvmLS
   ijafWVoNbVK8XSfc0EAzN2wpARtEFG/s2waO1JC5GEgeGqdmGZBmswJpi
   A5DRcSv2T3RpAbJDgWOBnM3OEiNxZPnvwQt30ZyylPpNgGXeA5e0RFUxM
   mBERETvv0mAFakrE52mBSoDxIrfAu55tlcpT4M/VuYboXVMxrV+kgJzOY
   953ExUwqf19wqqhCLfrUkm4/fKNe4uUmzQ4QtKZ6ed3U1775zNIeBnvND
   A==;
X-IronPort-AV: E=Sophos;i="5.90,253,1643644800"; 
   d="scan'208";a="202579066"
Received: from mail-dm6nam12lp2170.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.170])
  by ob1.hgst.iphmx.com with ESMTP; 12 Apr 2022 20:26:04 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=by556HFw6+Xb1Kb722f6oRsbreagUVGxMGFfAT41PRKpq4mrFgY7qHs2UL2uh4aeJ0hWEsWxMi8WQoB9J8TIwclnr//Z5yeAwfcVs1lXeMEMTOMY8gXnQQ7DoRM2NBsNh/LNdhbHoiUeT32nb8E1y9U8dkWfc8qdGdXSuTVlBy7akE+xWmiXgNOBZzfFi+NxhCM0Rrnms2AaDIYQ51VjJx0ANtDbxaDx/tMTRSKNJn+WYRZIWAMsZCWrVkHYNni0dN7kxH9up3Mb5r0pKlU8wV3Z4I9NqGYWaGyDMcQxmxoPqaLERO8uHJx0K3IO4joZJ83xF8AAbWx6tqIbs7FxUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F/s7P8iKZ2shj7r5cJZCEu7aKrfrV3CpuiA6bKSgLYM=;
 b=O31Sippfn+OdYfQlk4YKrtAp2f4oVSuZSugX6MuHJwAmThQEZafQlKuCGCYqqdEYJGWNFqNF9xU3+nrI+gY0i9XrJcV4iAj8CGO40c5/tdY2ggoJxFXZsv2zm38qYGZTvk26MUBuetitCjvME7SV1oeriMruL+IoeqVSAUY+rhnzT8LmdWaVRdhOPeaBqnSnl3OEOA4L5WoOEPVPws6JfdBEKvBQTmKVlJOzogP/VEpuQXShpMbYYDjpFKVKPCeWeSuUtDEHeRg5V8hfnejBOp9ck2WCptEnHFUeas5+fbg/qDIawb1IAlIrtKNjs/4j1jVq+RwV4fs627ZpfkrnWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F/s7P8iKZ2shj7r5cJZCEu7aKrfrV3CpuiA6bKSgLYM=;
 b=KDqgCoYRmD7IsJwSZm817mh40B4Su9G+UY6HAMvR5n4QaHjHTawelygFEmmfIUPjWFGY1eKFDadjKpsxeGMp9Ha3gBISLyGg1jPI7MyvS+KVZnjD/+JfdZH65BoKqfGxnKRGAWY44rt7mFwolOFAbDNj9tWgciJLL9b1BpbezUc=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by SN6PR04MB4848.namprd04.prod.outlook.com (2603:10b6:805:af::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Tue, 12 Apr
 2022 12:26:04 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::995b:363e:8d1c:49af]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::995b:363e:8d1c:49af%8]) with mapi id 15.20.5164.018; Tue, 12 Apr 2022
 12:26:03 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
CC:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Eric Biederman <ebiederm@xmission.com>,
        Kees Cook <keescook@chromium.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Greg Ungerer <gerg@linux-m68k.org>,
        Mike Frysinger <vapier@gentoo.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>
Subject: Re: [PATCH] binfmt_flat: do not stop relocating GOT entries
 prematurely
Thread-Topic: [PATCH] binfmt_flat: do not stop relocating GOT entries
 prematurely
Thread-Index: AQHYTlSbKHqZCw+JvEK9UT79JBm95qzsJ4yAgAAMu4A=
Date:   Tue, 12 Apr 2022 12:26:03 +0000
Message-ID: <YlVv2Z5y9qhzu7X9@x1-carbon>
References: <20220412100338.437308-1-niklas.cassel@wdc.com>
 <9437ce7f-0553-3688-5695-69add6b2971c@opensource.wdc.com>
In-Reply-To: <9437ce7f-0553-3688-5695-69add6b2971c@opensource.wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5b5d6a46-daf4-4d1b-897e-08da1c7f9c74
x-ms-traffictypediagnostic: SN6PR04MB4848:EE_
x-microsoft-antispam-prvs: <SN6PR04MB4848DA9C48DAA58E8E2AC4BCF2ED9@SN6PR04MB4848.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uaSWbzFTvj1cizuXsgh832W0IycEddJtQOg9yCpO/144XIkg3y2wNiGo0CYeqSZ4MazpWiXa7RIcUSIQWennjhhqz1tt0wtpOZ8K4SIjT6+p4i9y/WfjqkVgF4GL8l0+zfkdGZgHl9hNvgkDgnbr8FOuQc/zkGPSPgj3DdoRDZVBQtN5m/0tyZAGJ9TLMNZwXw4AjLarjGcfIj6HQUj5EgISu99+axNFpW9ygBj1Hz6rZ6GXinNuJLWG1rXu0aMd9QFZqV91naIqE9pdOGnZNBXIKJk6/5caUpQxuDBI/noqnuwhuqGIozJBRp8TgxYn0tHmDMTi6MpuhwCjA9QSdVg/oHYhy3ndJ+TIZmAqwWV5ECkQtge8uS0EAJErs+w9tqMh8i4xJaBUA1C4iwL1bndASoc/9Zn1kMBTuDZBam2oP//GPyMwMZfSpDpP1EZBk0ut2JuzGVPHiIVWStcjPApRBnwC0zkQvoDuRUEKL+e/cuwWLMtSjOM/C2XRY+3mmcX3lJiVgrWWKX5PGoezlHCcryQFXwQ5gyoqMSPYduTx/d3NoNQksEA0j/q22PpLbAEW7sU4Ie/xExigmA+Pp3ZDp2RE4R27avH5C0r64zzhQSQYlbcudQZ80vu8+A0fWStWkeAak3EJlQlHc4GuClSm2GkQfVxuolpVPHcqzdN45WtDkFpSSFTy8xI8u1R9PlTRSOyh6TzhqCpwHzQ1zBBMvGM8d/Vt+qyNbqnXCWdQuXdbMuunrULW0Goooi+wtYsL7Op4VvK1sCeQSr2vy9kSKoJnRZnMwCT7KsWhQuJ3/IPfQOhvN0hhsWQCZmT4mLMtcvhpegDu9hlXw+Kcfw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(26005)(508600001)(33716001)(186003)(83380400001)(6862004)(71200400001)(54906003)(9686003)(316002)(6512007)(53546011)(6506007)(8676002)(5660300002)(86362001)(8936002)(66446008)(64756008)(66556008)(76116006)(66946007)(91956017)(66476007)(82960400001)(38100700002)(966005)(6486002)(122000001)(7416002)(4326008)(2906002)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?VGEtxWZh5WQVn6ySoKjC4WpX1e0vuPtnkiDtL+pRqpl7fw5RpjVn6S50G3oc?=
 =?us-ascii?Q?scNna1HQb+ZuZNkicUaZASZtN5AztCyUkifEhLFlL3wZi/x+tnM9b82LKCqa?=
 =?us-ascii?Q?I5K8IU/2lJZbkre48/VMfm8c/HwgFlEpgoxLmXKAaC/jcks6Fso4fMUQWfc5?=
 =?us-ascii?Q?aL9mtP5YqwZgs9h5vBS3EUfxSExlDw5hmTDZibKfMIUjwmg+XqibnTcE81wv?=
 =?us-ascii?Q?bY9sFeUsR8HfommLdshaVnieMrxKH4pXiD7U+FZPywHxmsiey/L6lfwquAUO?=
 =?us-ascii?Q?h8DbTv9uom0xEemvgp9k2C2nMHwq06EvrCs92CLTmvvNA2Xw617hjnSAr9RK?=
 =?us-ascii?Q?72R2frmSNfvQyj14REAParJDSNDCNTlU8i/DtQsBMIQs2+sasToFZOst3SXz?=
 =?us-ascii?Q?foSBZA6GrbHDZ48FGWpVD4/O6db8Qp9Et2RSsKvbhMqTdP9EsdSNQrQj9kJP?=
 =?us-ascii?Q?Sqwwm83jsvlLvMIQFkYegJiMClqxxJ10JLn91Ix0U0yR8PPWVSIAd/98dTyE?=
 =?us-ascii?Q?ap9DLS+n8CcM34PUumBjs0V5joW4NisyzQsYqCypvbiukMHVL5l+Yx1WV3x6?=
 =?us-ascii?Q?gRa2YhJ+jkdWhJaitL4/+mCsybOzyGEgMQZWpCP7z5IVrLFivUuMeFmF3FV+?=
 =?us-ascii?Q?pV9ZZ3jX00F3aeIj0xt9RnNbHB0EAi7hqyhmcWPdA8eHTVwPatGiXVITBq46?=
 =?us-ascii?Q?E5SagvRps8NEuzFC3hVB+iitV6O9Rbieug0g5KsS5+mHOFfElqdrcF3XCOz7?=
 =?us-ascii?Q?tGnaCCiq953L8SxeAFgET/9HQ1zj9sToHmLtC9w/tf3BtFDU2dRufTLfwCoO?=
 =?us-ascii?Q?KFlZhpCG4EUo8KgABVDn/4Nh3hj18xcinFEM6pVqWIw9bHi4j1mAuGNupjc+?=
 =?us-ascii?Q?Uc5H0ffhuDrH2N0un58Psz5MS9pGunK2x1OIMgNKUV6Z0c/6i5VJwzComnjD?=
 =?us-ascii?Q?yGQOAcMWp5S0i/xxjm7vgveaCslSozdJ78MnQcKQEyuLlrWIaqDcrjtp/Vx+?=
 =?us-ascii?Q?AFwglCQKG+iWgxeyk4FuwYrrylMcX7CStQmOADxdIZtInBlXeD3NItXOvQhl?=
 =?us-ascii?Q?5gNJkaSW9tyG9NPtNEm1eQ52EpmVCKOuHGzhBhiKUNUZhaaghquEktOvveB8?=
 =?us-ascii?Q?jdhKsqiSJ6mp0TtaNPcwnAb0xFvKLwbl/F6hSWc+2d9ZllDZpTU6lWtliMlu?=
 =?us-ascii?Q?ozRsV8TsM3DD6QbjeDU6vaaw7HgqrDAd4a0iQgIzUgtmCVR8Z5bZvlVzoiYS?=
 =?us-ascii?Q?in2zLUeDppGRqjdsCRxq8igepbdw01gVi+j9WECb9Lh5vaHajMmxf+1iR9E/?=
 =?us-ascii?Q?IaxWZZNwLWVzm6Emq1AKDxJ06NEfwAzB26ZElqu5mCTdboE4B03AgpiApczD?=
 =?us-ascii?Q?onyDxW52ncMIpWVfet5KRiqkK4OcnVHPc5G2HNPx1GjNG79en/Bo/Ka653rQ?=
 =?us-ascii?Q?C+RUAVDoCY6yUVMws7m8GNUZ8KlH+rJZWoUiue/Ud2Ma6iVJoiHWtncuX80C?=
 =?us-ascii?Q?5cYzoVYdIyudjbW3PvNUuAtYkvrnMxqucWYjbNh0Q7yBOoYuBpzA7UB//KEw?=
 =?us-ascii?Q?VWajqTSEsgNl3P5gze7teEg0qxIzCAnuSyq0KBjpA/GV104gINrv08mYDpXR?=
 =?us-ascii?Q?X8LsIABpZVpolyLYtwEU/OhI7Zst9q2yWZDjiw0vEq3HJ1yZug+LvtH/fBlU?=
 =?us-ascii?Q?tuAwmyGSuLolKKZZd/2IrtqaDMJxkvCernsNa7Zs1wc5NaT5JdUGype1Wwba?=
 =?us-ascii?Q?rE/IilLJKxWztjbGXWz0TyWQjewzwTI=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E90E97DF61AB134783DB3B75F6CFBFD0@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b5d6a46-daf4-4d1b-897e-08da1c7f9c74
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Apr 2022 12:26:03.5936
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0RiK5Ao9vrNFmt974MorJk4v8ZvFp9FGCDA4yJ+yOyxlr547urUb0TPqqBEPbY0GY8YtH+DpKj/kOUI6CJHDNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4848
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 12, 2022 at 08:40:27PM +0900, Damien Le Moal wrote:
> On 4/12/22 19:03, Niklas Cassel wrote:
> > bFLT binaries are usually created using elf2flt.
> >=20
> > The linker script used by elf2flt has defined the .data section like th=
e
> > following for the last 19 years:
> >=20
> > .data : {
> > 	_sdata =3D . ;
> > 	__data_start =3D . ;
> > 	data_start =3D . ;
> > 	*(.got.plt)
> > 	*(.got)
> > 	FILL(0) ;
> > 	. =3D ALIGN(0x20) ;
> > 	LONG(-1)
> > 	. =3D ALIGN(0x20) ;
> > 	...
> > }
> >=20
> > It places the .got.plt input section before the .got input section.
> > The same is true for the default linker script (ld --verbose) on most
> > architectures except x86/x86-64.
> >=20
> > The binfmt_flat loader should relocate all GOT entries until it encount=
ers
> > a -1 (the LONG(-1) in the linker script).
> >=20
> > The problem is that the .got.plt input section starts with a GOTPLT hea=
der
> > that has the first word (two u32 entries for 64-bit archs) set to -1.
> > See e.g. the binutils implementation for architectures [1] [2] [3] [4].
> >=20
> > This causes the binfmt_flat loader to stop relocating GOT entries
> > prematurely and thus causes the application to crash when running.
> >=20
> > Fix this by ignoring -1 in the first two u32 entries in the .data secti=
on.
> >=20
> > A -1 will only be ignored for the first two entries for bFLT binaries w=
ith
> > FLAT_FLAG_GOTPIC set, which is unconditionally set by elf2flt if the
> > supplied ELF binary had the symbol _GLOBAL_OFFSET_TABLE_ defined, there=
fore
> > ELF binaries without a .got input section should remain unaffected.
> >=20
> > Tested on RISC-V Canaan Kendryte K210 and RISC-V QEMU nommu_virt_defcon=
fig.
> >=20
> > [1] https://sourceware.org/git/?p=3Dbinutils-gdb.git;a=3Dblob;f=3Dbfd/e=
lfnn-riscv.c;hb=3Dbinutils-2_38#l3275
> > [2] https://sourceware.org/git/?p=3Dbinutils-gdb.git;a=3Dblob;f=3Dbfd/e=
lfxx-tilegx.c;hb=3Dbinutils-2_38#l4023
> > [3] https://sourceware.org/git/?p=3Dbinutils-gdb.git;a=3Dblob;f=3Dbfd/e=
lf32-tilepro.c;hb=3Dbinutils-2_38#l3633
> > [4] https://sourceware.org/git/?p=3Dbinutils-gdb.git;a=3Dblob;f=3Dbfd/e=
lfnn-loongarch.c;hb=3Dbinutils-2_38#l2978
> >=20
> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
> > ---
> > RISC-V elf2flt patches are still not merged, they can be found here:
> > https://github.com/floatious/elf2flt/tree/riscv
> >=20
> > buildroot branch for k210 nommu (including this patch and elf2flt patch=
es):
> > https://github.com/floatious/buildroot/tree/k210-v14
> >=20
> >  fs/binfmt_flat.c | 11 ++++++++++-
> >  1 file changed, 10 insertions(+), 1 deletion(-)
> >=20
> > diff --git a/fs/binfmt_flat.c b/fs/binfmt_flat.c
> > index 626898150011..b80009e6392e 100644
> > --- a/fs/binfmt_flat.c
> > +++ b/fs/binfmt_flat.c
> > @@ -793,8 +793,17 @@ static int load_flat_file(struct linux_binprm *bpr=
m,
> >  			u32 addr, rp_val;
> >  			if (get_user(rp_val, rp))
> >  				return -EFAULT;
> > -			if (rp_val =3D=3D 0xffffffff)
> > +			/*
> > +			 * The first word in the GOTPLT header is -1 on certain
> > +			 * architechtures. (On 64-bit, that is two u32 entries.)
> > +			 * Ignore these entries, so that we stop relocating GOT
> > +			 * entries first when we encounter the -1 after the GOT.
> > +			 */
>=20
> 		/*
> 		 * The first word in the GOTPLT header is -1 on certain
> 		 * architectures (on 64-bit, that is two u32 entries).
> 		 * Ignore these entries so that we stop relocating GOT
> 		 * entries when we encounter the first -1 entry after
> 		 * the GOTPLT header.
> 		 */

Sure, I can update the comment when I send a v2.

>=20
> > +			if (rp_val =3D=3D 0xffffffff) {
> > +				if (rp - (u32 __user *)datapos < 2)
> > +					continue;
>=20
> Would it be safer to check that the following rp_val is also -1 ? Also,
> does this work with 32-bits arch ? Shouldn't the "< 2" be "< 1" for
> 32-bits arch ?

I think that checking that the previous entry is also -1 will not work,
as it will just be a single entry for 32-bit.
And I don't see the need to complicate this logic by having a 64-bit
and a 32-bit version of the check.

The whole GOT (.got.plt + .got) will be more than two words anyway, if
there is a GOT (i.e. if flag FLAT_FLAG_GOTPIC is set in the bFLT binary),
so the "end of GOT"/LONG(-1) will always come way after these first two
entries anyway.

Another reason why I don't fancy a 64-bit and 32-bit version is because
some architectures might be 64-bit, but I assume that they can be running
a 32-bit userland. (And in comparison with the ELF header that tells if
the binary is 32-bit or 64-bit, I don't see something similar in the bFLT
header.)


Kind regards,
Niklas=
