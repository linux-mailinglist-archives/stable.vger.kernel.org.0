Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42B624FFD98
	for <lists+stable@lfdr.de>; Wed, 13 Apr 2022 20:13:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233601AbiDMSPr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Apr 2022 14:15:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235006AbiDMSPq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Apr 2022 14:15:46 -0400
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08B01496BE;
        Wed, 13 Apr 2022 11:13:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1649873604; x=1681409604;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=SzB0d7WiTUY/MZqJdvQr5qlPZZd6DRvWRXimBhv/lF4=;
  b=hM7mOSSOmnapuF5qKK1hCWlRkXo8mni0NhUGjVG60TmrFo4HkOwMCwzw
   fCB+CKwBv7mIevTYJc5fxNTD39tt1k6clshHC43LvpgzgH0w7iVr1eKMx
   CUQ56MVzUhM4QMjzPtke89eO0J1zZWoV1tYdv1PMA2EtcKQ8iWjIH7CYP
   nmnHcZc/FkJMkH2PdydwH4s4uS0Mg53ZC6XLGDcyqwNMhI+zTbXqD/7Zt
   dksJsfa4G1agaf5XDVf+YaThdQ1a36x9oZ8ZcArtvuy2E7lQ0k+ZqjeUa
   8ttM5Oy4+sajh5o/XYjkFvKqe+JzBsNGr9Glxb4Y/3K57PhoanztxJ12R
   A==;
X-IronPort-AV: E=Sophos;i="5.90,257,1643644800"; 
   d="scan'208";a="198744309"
Received: from mail-dm6nam12lp2168.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.168])
  by ob1.hgst.iphmx.com with ESMTP; 14 Apr 2022 02:13:22 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CWE3NZhBtNNRkXa1dRdrlwuflsTHFq2eGD8NfC9/JKr+RyrDSpec/YgTwYz1cnBGK2S2UJXQcfViaNBNFwmvg/INjV2mW01IgIIuqxbnFOXse6ClAiTc8U9BHLa3BqBCAHmfnxJbxKQeXHapzCjqzQy2tD+FOssJ27fNpk8q0hnttH0H2krxR97bWl44XNI5H9D/4Rzh3H6IECL/2aWVt18r2m9ZXXjGaHM7ep4Mlvmn0kdUYaU4zk9mLk/ESRpbY1MZTA95atE4jvYcElyxdkAfIJ2H5N3Zv0XD3jIRT3FWfd2PaV5RH3jW+PnOyenRZ8+VybVYqQrrQ5e2QB7eFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=toPTeenVBUQtMhwQiRzhPLrdlAoAMDY56IgBu3dDXUI=;
 b=Tv/8A33QJs5FG1oGhqmmFSG7C6hB4xNKK360YWuiVBw+bqEEmv3XO3pZUUECFZWpbcgeFlAbzjkFI7yleW2y7I/yNgg+xxm/EL2k57UhH9/yF4sBNTiod2rwySzKqISJKLHbHfrWQdywFxO4rIc9Rki3g0TMPxp7EBoxsMMql8KZG8CFPtocGq/m9t7PK7ZAvqrSF8s1NtpySvJw6KUWzpUPMKjvv64zyTMIAWno1V8cvJUJTjY+ZSMpM7CbY+VXG7mC4Y4LIgs/ucsTtnXXRmkUPz37ezgNdoMbS7b5JsSsqSr5qatO3XGYKkbW5kSwUOMdcs1sfhIG5MXb4IPcvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=toPTeenVBUQtMhwQiRzhPLrdlAoAMDY56IgBu3dDXUI=;
 b=U5dk9dF1QAG9X7dvcBQoPa9GfsW0ggeTdD6e5+8/WiVyX6h8sfjxRLFq9FSoI6yOF5a2aZoIErUm++Kz2oZjdcMXQ8sCQagL8RgFGugPUY/6vFwean96DdaLbpK+tjK/D5dQ7/ZpF66cMlTKHDADTlDuqv4iaOEH4fc8+xtD604=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by BN8PR04MB5476.namprd04.prod.outlook.com (2603:10b6:408:58::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.18; Wed, 13 Apr
 2022 18:13:20 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::995b:363e:8d1c:49af]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::995b:363e:8d1c:49af%8]) with mapi id 15.20.5164.018; Wed, 13 Apr 2022
 18:13:19 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     "Eric W. Biederman" <ebiederm@xmission.com>
CC:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
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
Thread-Index: AQHYTlSbKHqZCw+JvEK9UT79JBm95qzsJ4yAgAAMu4CAACkDVIABylkA
Date:   Wed, 13 Apr 2022 18:13:19 +0000
Message-ID: <YlcSvhXeUD89XEYn@x1-carbon>
References: <20220412100338.437308-1-niklas.cassel@wdc.com>
 <9437ce7f-0553-3688-5695-69add6b2971c@opensource.wdc.com>
 <YlVv2Z5y9qhzu7X9@x1-carbon> <878rsatkv6.fsf@email.froward.int.ebiederm.org>
In-Reply-To: <878rsatkv6.fsf@email.froward.int.ebiederm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7119a920-f70c-40af-40a3-08da1d794a29
x-ms-traffictypediagnostic: BN8PR04MB5476:EE_
x-microsoft-antispam-prvs: <BN8PR04MB5476D92381C9C38B4A17991AF2EC9@BN8PR04MB5476.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EnAhIukfqVllW8oQgm8fjG9kjPIdMoLpLYNq9dg8gg2ylXaA5I/Sht07gz8E06q81D+S9zAyLbOTZXmjo8pZ58JHxn6KYw9lMwK+g14H6W99tZ3HwALO1kXM4R3kHwxQk3D4wlDVJbXFJoAc04N+93AZiLrzVRcxtqdBpI5edFV6kD0QbPZ5Hbsmq1fI+IjM0aPfCVd97FCzMNyPXnqmTyvoIpBsxAYwt971VeKt7/+66Oqr+OX0DxLGPiaqK4jVo9p1pH1YAqW3MWf6CqqUgfXbW2uYs9GXEPM8S29XSb5ELP9XkpJVZbE9Qcqi5D5TxaN0JHAtX7EyVTOvlrAcYorfrqfWYcImMRd4K7Sohjl00X0rk2x2vl+rtJXmrFiDK4p6WUmmr2Pz4NNhxt5NkaPowiAjc17/s5Pzn0EH5MzTTr8Sx4hLFaAJo1a/qAafelaitPEDcKWGmGG42x1XjKSQ4i1EcF6/mKnR27OHMDCvLsVuK2gfitOY77j8eSP5L+GFv+eJexe2QiJYDty4MRBh3xFzmz+4uvCNtuenZXlfICB+eSQhBRTDGDHbtoDuDQbcq4AEqHeJoRWTQF5L/q4e1wUIVrwg/sHT9o1XX5mgPYHeJGS71EL+e/BETqd2h34KK3S12ZfKglJ1BJM9W4LCuLdLpSzMuBHZLBKxLoRocep9774BpFnQgKa9qz8dtYpQmd5v+J2u0JWHBLjLhFTXB2ERMQAWMAvSOgGeXNhIEdGhvBCkDPHv+pkCy/vqp/S9jzebXDNssdRiTNGaMfdytPRf/+WaeAEBqX3Lzi63W5eyT5PI2Su9+sdqiCQBGjpdCS6kaidh8/bWADfdZg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(83380400001)(9686003)(6512007)(2906002)(4326008)(33716001)(26005)(82960400001)(38100700002)(122000001)(186003)(86362001)(38070700005)(5660300002)(508600001)(66556008)(66446008)(66476007)(316002)(71200400001)(64756008)(966005)(6486002)(7416002)(54906003)(6916009)(76116006)(6506007)(91956017)(8936002)(66946007)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?gGakjFyGIG1qOjcsWcv/f9tgpNLO2NT6Xo18ifS2VGpPw0EzpSoqL971WEND?=
 =?us-ascii?Q?khcq9sER00ZYPTj9PiTmSTphDNmeyqDwTybxtiJJsxUnweB8nIa6YX2ibar8?=
 =?us-ascii?Q?U2mcHaLSIuOg3dwL6d8CNsZAPgP9dkuNDi2oRSlsFRcyI92+0ObKWZscT3uL?=
 =?us-ascii?Q?CnOGZDF4P0UhDwYgolFZGJ8kAc9KO11hABl1A/LUjczB+QBbDu+B5ZVMfIbc?=
 =?us-ascii?Q?bqio4n7YR6wBoEgEW2hWtX8JSWfhSj18m6m+y5u+2VWwe2cPkLTF8YpS/E8i?=
 =?us-ascii?Q?DhXo3WEyufbKv0jhCJFNMOwxqj04yfZ4EUcvHtoiGFQIRXSiHrq0cuOGhcVD?=
 =?us-ascii?Q?y0OxDBBZAFSgyjthrZGed3ilIhN4InXNmwDsaX+G3/g//6X5YVYvaLxmVlCI?=
 =?us-ascii?Q?Nz01sv4zHkUrCqkYX42C+TYOUHY6E4COfXJ9GyhUjzq1JYtenQ7Ueik+SYt3?=
 =?us-ascii?Q?SQcT6jyEtpzft6ZBB15aeoQ9Q6DL9sLDrs+YXhmOxiOOeDPLicPwHZjXFcuF?=
 =?us-ascii?Q?t5LBZ3goCJn6PtgYooLtcZHf67NTzpD43aiB2inGFYh4MPLfUm3r6MdOjpD4?=
 =?us-ascii?Q?8Qd8PE5pGh21RWJWLoNA98jeHkaUmpNNkDRzeGvUBHE+olC/d54KE5vdgusC?=
 =?us-ascii?Q?xYAqsvQdUajr4AJT3IHiUK0T82sJhRfg807lh9o0RY/H1/Pe6EodQwdRBo3R?=
 =?us-ascii?Q?Pyf09WaJwYA0L+TWyUGqLzdkxdeNNvuVPEPynGAOZNEsnh2hfSul80u5edGL?=
 =?us-ascii?Q?4VCJ8xFFNusMN569DamL0zABM8s8576UCqdeoZVGR20Chjel8QdU+DoHX/F+?=
 =?us-ascii?Q?MnoMNPlidgPMuolgcQuqSZFcAHfNms96QVbc1Q6gghBLq7yeyfynYnJCLOMr?=
 =?us-ascii?Q?G7GGn4vjCgdiplmIL9QzoxqjtqDT7UEmem0pDR8EyGosladmQdC0QWD1Snok?=
 =?us-ascii?Q?ED5mB+Pi40G/iRXsI/2SUBjyzcgBrcyI1fvNp7R6ssaPYgN61SJt05z7I4gh?=
 =?us-ascii?Q?bcWMGtFakMa3gJGMQPDRV++WQ5eaHVyk5A8MxGwNxsmhVfL/1LyJuEnjD80j?=
 =?us-ascii?Q?SpNr3N2kUXnvQ6j/AcONh0RbCJJJm8h8dhKq9UTWScSbMgs/khjOvo5WQ4lc?=
 =?us-ascii?Q?BO1irHFjxojApq8AsEPmZOLkV3zw7vneikrDJPQtf8meCUj3qshiT9e5P31W?=
 =?us-ascii?Q?ERRI6SrUAvffEojkm3RlXUt827V0EBVANgBh26NPpfbfTAHenBgjaSUyFCJ5?=
 =?us-ascii?Q?cDvBkUE3pPC7O1nI+E6FQMS7pRW2C1RJ1Mlut3mpqJQY52IjvalG1UuJUZO+?=
 =?us-ascii?Q?KHSMxd7Owks4qmKzJBAHcoGp/FPT8T9qeddgi8Fo+gOs5z+hhKc+3kThkBze?=
 =?us-ascii?Q?xiFiHXcSOefZmM2CQXLQ9k/KqAcZCRmzpdDaalKsuCOhXwwdssv9CunzvYBY?=
 =?us-ascii?Q?M5EZ/5hU6DMGT/oGU2hHF/Klps36gA8xBA/GZu3OE3YZANHn1E1GR+jmbzQs?=
 =?us-ascii?Q?vnvfLUiMTsqUW+Hazy8NpYxgKVQ9hWHjAMNQrib8eNiCgInmz6ka4c8T/+Zx?=
 =?us-ascii?Q?LWmGPYReOYIo2g12tWw/gGtvV/shpfX32sgmGlI0fjH5NrMDD2kxmcS6rHoS?=
 =?us-ascii?Q?LcbSPlAFUwW8wiOGXe2jaJ8sbIfSxZxE39VDoNyhvRrTmWOMEtGCBJ8c+Tkz?=
 =?us-ascii?Q?1cYiWlge4So75h0HXAuqOtpR/ipFhyFUADcDdA7VmRaobvR+fHJIj3ZBSMMW?=
 =?us-ascii?Q?NbApHV1Ha+T9rQtOG/GZFZc4MrTVFoM=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D025504C4E004C438899B35B148A3A79@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7119a920-f70c-40af-40a3-08da1d794a29
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Apr 2022 18:13:19.7250
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fHbLa9FLz6uKfZ+n6mH22nJcI4Y69pcGMrpqPNMsIvW3i2pFusoA5bQUIEALj71f68KKqJiovm9w7Rrlg5mwOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR04MB5476
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 12, 2022 at 09:52:13AM -0500, Eric W. Biederman wrote:
> Niklas Cassel <Niklas.Cassel@wdc.com> writes:

(snip)

> >> Would it be safer to check that the following rp_val is also -1 ? Also=
,
> >> does this work with 32-bits arch ? Shouldn't the "< 2" be "< 1" for
> >> 32-bits arch ?
> >
> > I think that checking that the previous entry is also -1 will not work,
> > as it will just be a single entry for 32-bit.
> > And I don't see the need to complicate this logic by having a 64-bit
> > and a 32-bit version of the check.
>=20
> Handling 64bit in this binfmt_flat appears wrong.  The code is
> aggressively 32bit, and in at least some places does not have fields
> large enough to handle a 64bit address.  I expect it would take
> a significant rewrite to support 64bit.

Running "file" on the ELF supplied to elf2flt shows:
ELF 64-bit LSB executable, UCB RISC-V, RVC, double-float ABI, version 1 (SY=
SV)
(The code was compiled with -melf64lriscv.)

And the resulting bFLT works perfectly fine with the existing fs/binfmt_fla=
t.c
(with the minor fix in $subject applied).

The current relocation code probably won't work on systems where it needs t=
o
relocate something to an address > 4 GB, but the systems running bFLT rarel=
y
have that much memory. The k210 I'm testing on has 8 MB of memory.


So I'm not arguing that we should change the u32 pointers to something else=
,
my point was that:
https://sourceware.org/git/?p=3Dbinutils-gdb.git;a=3Dblob;f=3Dbfd/elfnn-ris=
cv.c;hb=3Dbinutils-2_38#l3275

bfd_put_NN (output_bfd, (bfd_vma) -1, htab->elf.sgotplt->contents);
bfd_put_NN (output_bfd, (bfd_vma) 0,
            htab->elf.sgotplt->contents + GOT_ENTRY_SIZE);

Where NN will be 64 for elf64-riscv and 32 for elf32-riscv:
https://sourceware.org/git/?p=3Dbinutils-gdb.git;a=3Dblob;f=3Dbfd/Makefile.=
am;hb=3Dbinutils-2_38#l878

So while the GOTPLT header will always be two words,
it will be 16 bytes ([0xffffffff 0xffffffff] [0x0 0x0]) on elf64-riscv
and 8 bytes ([0xffffffff] [0x0]) on elf32-riscv.

Both words are reserved for the dynamic linker (ld.so).


>=20
>=20
> I think it would be better all-around if instead of applying the
> adjustment in the loop, there was a test before the loop.
>=20
> Something like:
>=20
> static inline u32 __user *skip_got_header(u32 __user *rp)
> {
> 	if (IS_ENABLED(CONFIG_RISCV)) {
> 	        /* RISCV has a 2 word GOT PLT header */
> 		u32 rp_val;
> 		if (get_user(rp_val, rp) =3D=3D 0) {
>         		if (rp_val =3D=3D 0xffffffff)
>                 		rp +=3D 2;
> 		}
>         }
> 	return rp;
> }

I like your suggestion, but perhaps change skip_got_header() to:

static inline u32 __user *skip_got_header(u32 __user *rp)
{
	if (IS_ENABLED(CONFIG_RISCV)) {
		/*
		 * RISCV has a 16 byte GOT PLT header for elf64-riscv
		 * and 8 byte GOT PLT header for elf32-riscv.
		 * Skip the whole GOT PLT header, since it is reserved
		 * for the dynamic linker (ld.so).
		 */
		u32 rp_val0, rp_val1;

		if (get_user(rp_val0, rp))
			return rp;
		if (get_user(rp_val1, rp + 1))
			return rp;

		if (rp_val0 =3D=3D 0xffffffff && rp_val1 =3D=3D 0xffffffff)
			rp +=3D 4;
		else if (rp_val0 =3D=3D 0xffffffff)
			rp +=3D 2;
	}
	return rp;
}

What do you guys think?


>=20
> ....
>=20
> 	if (flags & FLAT_FLAG_GOTPIC) {
> 		rp =3D skip_got_header((u32 * __user) datapos);
> 		for (; ; rp++) {
> 			u32 addr, rp_val;
> 			if (get_user(rp_val, rp))
> 				return -EFAULT;
> 			if (rp_val =3D=3D 0xffffffff)
> 				break;
> 			if (rp_val) {
>=20
>=20
> Alternately if nothing in the binary uses the header it would probably
> be a good idea for elf2flt to simply remove the header.

It is used by the dynamic linker (ld.so), so I don't think that we can
remove it.

The bFLT format only supports shared libraries when CONFIG_BINFMT_SHARED_FL=
AT.
Looking at e.g. buildroot:
https://github.com/buildroot/buildroot/blob/2022.02.1/arch/Config.in#L418
it seems that perhaps only m68k supports shared libraries for bFLT, but I
suppose that elf2flt wants to keep the linker script the same for all archs=
.


> Looking at the references you have given the only active architecture
> supporting this header is riscv.  So I think it would be good
> documentation to have the functionality conditional upon RISCV.

Fine by me.


>=20
> There is the very strange thing I see happening in the code.
> Looking at the ordinary relocation code it appears that if
> FLAT_FLAG_GOTPIC is set that first the address to relocate
> is computed, then the address to relocate is read converted
> from big endian to native endian (little endian on riscv?)
> adjusted and written back.

The relocation entries in the GOT are not converted using ntohl():
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/fs/=
binfmt_flat.c?h=3Dv5.18-rc2#n799

The extra relocation entries tacked after the image's data segment
are only converted using ntohl() if FLAT_FLAG_GOTPIC is _not_ set:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/fs/=
binfmt_flat.c?h=3Dv5.18-rc2#n851


>=20
> Does elf2flt really change all of these values to big-endian on
> little-endian platforms?

Short answer, yes, but only for non-PIC code:
https://github.com/uclinux-dev/elf2flt/blob/v2021.08/elf2flt.c#L826

The code is horrible to read because of all the ifdefs,
I had to compile it with -E to actually see anything.

Basically the code ends up looking like this:

	if (!pic_with_got) {
		switch (q->howto->type) {
		default:
			/* The alignment of the build host
			   might be stricter than that of the
			   target, so be careful.  We store in
			   network byte order. */
			r_mem[0] =3D (sym_addr >> 24) & 0xff;
			r_mem[1] =3D (sym_addr >> 16) & 0xff;
			r_mem[2] =3D (sym_addr >> 8) & 0xff;
			r_mem[3] =3D sym_addr & 0xff;
		}
	}


Kind regards,
Niklas=
