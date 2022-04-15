Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B059A501FA4
	for <lists+stable@lfdr.de>; Fri, 15 Apr 2022 02:31:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348032AbiDOAdg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 20:33:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348030AbiDOAdf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 20:33:35 -0400
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38095B0A4B;
        Thu, 14 Apr 2022 17:31:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1649982666; x=1681518666;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=by8WYiAWff5iBTPTfUiihuv7rXF+Wmvm8gg3usNY3dE=;
  b=K1oKtQkIwgcKA8iEue/9m0VfFH/rziYWxcsmHCHaaWBtmnRQQICt2joH
   XsCMNX0xbq4l/YKVrGEpNlp8o8SsbDXWK2ReArhw10UEM2ExfUTNTcrkk
   LbqFcwBS52BLruR+Vc9CLZ7F23aCXuJjX12vm0ZQbR5bsH1egUEy6hys2
   bBpcIBtPDayfMwAzZZshHiehKoUlihzC3xGmheZBPnlsLMPisXBG66b43
   1GiK9F0j/KPp7mszb9K5KbolB/GEAhYbjrPxLu4EPaKnpwJDlB/8jV7zj
   4EEEbxoWJJ3u/HLrdyk6cL9qPoIEPV/cjbCaZgy2PPalgKNfoTb0Medxi
   w==;
X-IronPort-AV: E=Sophos;i="5.90,261,1643644800"; 
   d="scan'208";a="198853407"
Received: from mail-mw2nam10lp2100.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.100])
  by ob1.hgst.iphmx.com with ESMTP; 15 Apr 2022 08:31:04 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Or1cGmEHIcevWHY2kabkU9vA6zajj5IToQIngwvcig4WqsaMNQcLk5oflJtuqHpaifaKzVuo5GMvQUDWHSr2JMZnfHqropUiigRgrSgupCebEezSFW9xGigeiVokjyVf474n62mIuuSbGZ/Z6HaVUvn4s8MBpbiEWHslUJL39JuK1h5YBOWPyYbBZeUbFQlkT9nYvzvURH+l55oRx8NKhN9rgzmWGNeYO8eawsXppZ2iq4JKZsC0kxNM6bazFeR6yczBDs0XhoBDQDrVEe4oolF0AKTpLwFrmUviKbJZ6SJRVnUCD6U6JRttihNahiKhuihCDsuIF4MKbllisVOI6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/ffxEew5BtRanyTKghZXcdurZvjNYuBiDlsgLIJjxR0=;
 b=eGCvvC+NBSRb748bDj2ba04CHGSbrW/m82ZnTSC/YQRuekuBsEFgnvUbzXb2iReEsfLcyfTlsY/GT4jh6tDu8WxSGwaNgVIjm3LIQQIL3O2Kf9lEpGRmfcrKmVbzcvJ9gdWNLsVNtdkOfOCqSw9BGLrVZyip2LOn5Tn8gcLq/WzDemfd7XODHIdZNMpNqQsq7kdrvV8Owya7PkZlcmpxoRyckHNehSxGKYevB7XvNaHA6qbDrOg9IpUDxS7CVA/Xtmpi4KWbeDQRmELSccQ8JPdurjPDiWWsLsn2Vv+bv+DseWZRHNLKnpDPRLeDFwaaH+I6x02fP6EHPo9ugc5PgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/ffxEew5BtRanyTKghZXcdurZvjNYuBiDlsgLIJjxR0=;
 b=ovStQ0mdIhvI8O+o90i8E2oaZ9g205lVi8Ygl4d8lzV8EzWQF+vRo1huEk4QtalfDFCbvRptc47EJwEANSk/EhWHKcw2lMVq4H20rq9JGQ37rP7FHUPQeQPlClj6Vma1tYXUXQxtq6LychU2O3e6/2p1RHCkIm3D3p8mp2/6XA0=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by BN0PR04MB7920.namprd04.prod.outlook.com (2603:10b6:408:153::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Fri, 15 Apr
 2022 00:30:56 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::995b:363e:8d1c:49af]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::995b:363e:8d1c:49af%8]) with mapi id 15.20.5164.021; Fri, 15 Apr 2022
 00:30:56 +0000
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
Subject: Re: [PATCH v2] binfmt_flat: do not stop relocating GOT entries
 prematurely on riscv
Thread-Topic: [PATCH v2] binfmt_flat: do not stop relocating GOT entries
 prematurely on riscv
Thread-Index: AQHYT9+B/BNFs63JH02JGuF3zm1OJqzwFV2AgAALBgA=
Date:   Fri, 15 Apr 2022 00:30:56 +0000
Message-ID: <Yli8voX7hw3EZ7E/@x1-carbon>
References: <20220414091018.896737-1-niklas.cassel@wdc.com>
 <f379cb56-6ff5-f256-d5f2-3718a47e976d@opensource.wdc.com>
In-Reply-To: <f379cb56-6ff5-f256-d5f2-3718a47e976d@opensource.wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fbbfca7a-f80d-4d60-9142-08da1e773503
x-ms-traffictypediagnostic: BN0PR04MB7920:EE_
x-microsoft-antispam-prvs: <BN0PR04MB7920704355B4D7D9EB595865F2EE9@BN0PR04MB7920.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: M2kDI9rZBhYUN202ALZJEq6xED9s7rvyG5gE4pJXC8Tccok1W7TDpF2aleZwR5I9uTgbv0nX6adN07XYq5NX0UXwSx9N7N3LfpdVOg8157pbRgaQkMahsLi9n0ONex/dHPV4QULld6rhmHvsgEYOjZmQCAZ9CEVbVECkn9w6ZY/DY8ARkVH4eJ97/NMLubeAtxnd11qz2tm/sZ+/vtEhqGGYPuxEVBLPxaPV2PxBxNbZlUKUNz/sA8WYV8hDejKrXP740NQwqCruaLvc1wYjV3nMYlsdTWSvhgTyrByG7nkaVmGXoAhTjqsZGfSCX7ieETGtgVf0ZMvbTUhXd6dnAKAzJFIxpccj+CO3GCNbh8CqUQZIQMzKQJFrVY1O5FFiihOLx+fggbvTgU8f+hCjS5D1SfPJQpiYObVxfx8DohLTJ0tURdrzY395I12FeFXdVaZ+DfYfUCu3TaPkHjnDuVKopT3temQQH4nRSOJnmTOkMf+ULXEufS9xg+qmi2/2zEPmZrC3scJaB/HkcAXpecTI35jHxmvdVMfIIMBto+JUL+nQF2tSEtNkIREcjJdh6hOpuNszMN1dp0TsTvoowp1W36EIADiTBkA+GIstiv3N+2PIb0ULLExtl5l2c/5JwmqCj/3UXys5/fkINfWCUAgDaXcCWn6f7u09I9d9Yf+fuS0/ThigD54MLWo3I91GIKV+HY2tmxA40PEhMNSYZBeCawlA3feJfdZXRH/JMOagvkT6LCcVWNOlGiz/X3+w
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(38100700002)(6862004)(316002)(66946007)(76116006)(54906003)(66446008)(66476007)(64756008)(122000001)(5660300002)(8676002)(26005)(6512007)(186003)(86362001)(4326008)(6506007)(82960400001)(9686003)(53546011)(508600001)(33716001)(71200400001)(91956017)(66556008)(6486002)(2906002)(7416002)(8936002)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?EUTnFc20viBzgFR1USEtPyQBRjdS6Jw4xJzOjZccbH+g4dAF0xBpOoMKlF7s?=
 =?us-ascii?Q?jaN7e1aYNd8mhH/6B+NuIuRFDghiT0W4lSdocT2mr3ir1xNbCKVQA6qI/Rlj?=
 =?us-ascii?Q?kHUH9XXPBuq4TPeqWHOmzKDY2HrtDXJYyznza+LXwHDZ45s0EptuzDIMy0nV?=
 =?us-ascii?Q?QZOpzFlELz7/yfivORM9xUpocdI0EppUAnbTNgsMXPY3KowDPqyirS6bv7Ql?=
 =?us-ascii?Q?ZLthTvQc2Co7r0G8ls3iTE+ByviKNNs2Ow/Z+2H5nPIxwdtQMTmInraCM8ah?=
 =?us-ascii?Q?o5tZf2aKpKA97L9RQKyihJ1TfXl91pmNLYFDpOR+Y8dRj2lsdUEZS2ngcB+t?=
 =?us-ascii?Q?IKaEfCOQfQpI5NqerqAAcJUI/auJEYk2h2MYSJv6cCoIzsJuEbnprJeU1jAq?=
 =?us-ascii?Q?oq9AA3pvWCT/zAff9zgBZdBYzAGwDXzCtTyr1/WFSlgqH9DfRWk/F3iYuOuR?=
 =?us-ascii?Q?gEl9bEfjeQi5QhoqpPapa5QT8G4a5bgK5O/eMNfas0rJTFunQAs+4+pVO8oz?=
 =?us-ascii?Q?lgYOI/hy5hsBnDtmD06giWoinKDSLTjXvV6koPH4M7IPYyo1IQ/W93nb7EuY?=
 =?us-ascii?Q?mR1Sw0knCDn0C7rTABLYVUYHioWZUaAyJFet2/iw7Hpn6byM8jJScJ+rsHB6?=
 =?us-ascii?Q?jtCVo+Oi4wDNRSFBrqwe17b96zoR+9dQDmChuBwAp+1vyxvcBtv8gmpXFqRZ?=
 =?us-ascii?Q?eSylaVTzdsefaaaHpvWPdaai2/h8sTb0kTHPPf7E5Eu11OOWTX2M0CM58pQA?=
 =?us-ascii?Q?hMhIWcIyKhpbQnRdyW1KA6vV3co1LBM6HEK0RnVziXBiaMAg5Bmara/5Wk6A?=
 =?us-ascii?Q?lICReGc0CnFbWNcCy6HDyiMRTEvNJ/dyg8RhbbQCGqL0xtkyLNQ35hfKRVib?=
 =?us-ascii?Q?lSmIC84S+rjFnZPJKdLHHS35orpGxlLGkuZJAo6PgDaYijNv5gEx222L4N95?=
 =?us-ascii?Q?1vfIKik2f+kH5qARhpTF0EJCYyW4TLOSOcmCcxd1ymkmw83FLy/LBB1Gqwhs?=
 =?us-ascii?Q?plfnSxcZFZU0sxu1QYmqGrMZxr0K8W6SQlBaqrUnC5wwsun6/9hyIHamd0hS?=
 =?us-ascii?Q?bpaEZ7TuqwOmAT5+6AiexSX/hQZQ7e1PxaJYw+p9C4p3yO/6RsNLnt5S5kVa?=
 =?us-ascii?Q?4QUuPqqF/AwoFoAkvPJHIlLwQu7nKZ+gJfBPv94X2Fe+kDZw01U5eQwYmN78?=
 =?us-ascii?Q?eqTc9ubKiMfRg73faCrMpfqtwIjgl5CzZTns04tdr2z6Kyy4y05t64q8FD5q?=
 =?us-ascii?Q?HnUQ5JTaXlBvxY0in+UzXlUxVJ3OF91vQpaHnIDJlMbtwr26ub+zk/Gh1+2u?=
 =?us-ascii?Q?IWJK83NZczdDb9vgd94RYZaVXYZiAaYzei70o+QTdDFpM5dD5nrIe9Zs12Ax?=
 =?us-ascii?Q?uiyR2XomyPdYxARe5PkA/T0wGZwtrpvbyqLc9WpiktduLm0pJ/eRiyRsspmf?=
 =?us-ascii?Q?ddaA6wIqv6i3tdnRyYZ88DCUUmib4+xFF5jUis4nKy20BuKmwn9O5KoiSU2w?=
 =?us-ascii?Q?JFsr+mbjyhBcOqxMA9VEvmO9a6wGjdgJQP4rombJhj3cXZeCaQ4MIRANiyme?=
 =?us-ascii?Q?Y4BUWJy4OtZ0kiCZ1j3aTBiQTHlO4xX3XrYDUk2X3A+1rvoKA/jL2dcBvsEL?=
 =?us-ascii?Q?Tph/dSjzPY2Qs1ySJh5KuSIzGRxoiJQwyImMWFOnt9WllY5WwDEq0bw7biei?=
 =?us-ascii?Q?aaRwqmWMIeRnCMPCxHNytGNNFX3ThxBzTJR8qAzEFdeG46+1/Q5uSq+FopvN?=
 =?us-ascii?Q?hY265Jwri15+KLwUeNHyOPZimC1Gxj4=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <FABFDA205275DB45B36EEBD1FEB6A860@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fbbfca7a-f80d-4d60-9142-08da1e773503
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Apr 2022 00:30:56.4308
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /qZ0ko+BTEbSWgAVMLs4I72aSoUwHkoysjNpm59YaOW+m5clR6HU0YXX7/6jFMcXLKQHnwB8YHoF0JMLdSm5MA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR04MB7920
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 15, 2022 at 08:51:27AM +0900, Damien Le Moal wrote:
> On 4/14/22 18:10, Niklas Cassel wrote:

(snip)

> This looks good to me. But thinking more about it, do we really need to
> check what the content of the header is ? Why not simply replace this
> entire hunk with:
>=20
> 		return rp + sizeof(unsigned long) * 2;
>=20
> to ignore the 16B (or 8B for 32-bits arch) header regardless of what the
> header word values are ? Are there any case where the header is *not*
> present ?

Considering that I haven't been able to find any real specification that
describes the bFLT format. (No, the elf2flt source is no specification.)
This whole format seems kind of fragile.

I realize that checking the first one or two entries after data start is
not the most robust thing, but I still prefer it over skipping blindly.

Especially considering that only m68k seems to support shared libraries
with bFLT. So even while this header is reserved for ld.so, it will most
likely only be used on m68k bFLT binaries.. so perhaps elf2flt some day
decides to strip away this header on all bFLT binaries except for m68k?

bFLT seems to currently be at version 4, perhaps such a change would
require a version bump.. Or not? (Now, if there only was a spec.. :P)


Kind regards,
Niklas

>=20
> > +	}
> > +	return rp;
> > +}
> > +
> >  static int load_flat_file(struct linux_binprm *bprm,
> >  		struct lib_info *libinfo, int id, unsigned long *extra_stack)
> >  {
> > @@ -789,7 +813,8 @@ static int load_flat_file(struct linux_binprm *bprm=
,
> >  	 * image.
> >  	 */
> >  	if (flags & FLAT_FLAG_GOTPIC) {
> > -		for (rp =3D (u32 __user *)datapos; ; rp++) {
> > +		rp =3D skip_got_header((u32 * __user) datapos);
> > +		for (; ; rp++) {
> >  			u32 addr, rp_val;
> >  			if (get_user(rp_val, rp))
> >  				return -EFAULT;
>=20
> Regardless of the above nit, feel free to add:
>=20
> Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
>=20
>=20
> --=20
> Damien Le Moal
> Western Digital Research=
