Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B1C557AA82
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 01:33:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238922AbiGSXdK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 19:33:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235061AbiGSXdJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 19:33:09 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60047.outbound.protection.outlook.com [40.107.6.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A05A5A8A1;
        Tue, 19 Jul 2022 16:33:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Md9CSPhioNLBGGxiqrZR4r9BLH8oJfr/LYelSRUVcKCbaqHX1q55VOHD4nBR/NGK2LVfKHjHrfvKwV0VFuQXVPEj7I06V7Wxvsfl2iZF0MCcvmCLSEgDfVVLT7XI3TRpsa7/exSX2W7v6X/p5mg8cBLOtccLCg1TvcNKuVpCdXkPsA2fFjOogBa7t6nfI2DzHGnmMEK5j4gExZVJBh98Gr9DhI3kj70SXMiDgiazSfwKXcdhyWglNOL2JfzfSQtl1pCMbF9Vr9d0EFo+zfAGiB0Pjj0fs1v0C+OwuKWEVm6EZ7l8thPS61YCDNJmmwBxj/fdpz6EMUkCJrtMqf0FSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g+rUJveYmuBzEJGZ+DLNFWOOW+7VXieGN9RyR9PCvHk=;
 b=NXXpw7BryLqRjJesUigVjivh8Uj4yjfCyNPOFSqbJ+lyHp6Oh4wLaAR/NSNUl0IB45+J3XOuLSg8zsgKcfcwQHZru8HzWrjv7+3b6PJee0SnkX8kE/Bgr04KMVOgxLttboHRKeZbAwpp7GphKMJ+i+H/5REep/cqR/Io6VWBwAvn9vbQ3TLiYRcYH2tykdqLw0F/5WePdW/vswuQclYiqrT1bVbswxURZIoPcyik2WnBByogv/jXBvmectiHa+JwaQVCl/fbb5cQ2MbifR7qeqn1Po7LL5/KRfd1P3fHOOuSFQYyXY9pcrxIIpt/v1/hEy16QQa4XrqvIDyIUcskpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g+rUJveYmuBzEJGZ+DLNFWOOW+7VXieGN9RyR9PCvHk=;
 b=SLA5K/gWoxSlxgur+/ioD217BvE+coSllFDpxS/DYm1JV/cYNij4kleCuA+XF0ob1236CqepFws3X/Zm+K+C4f8FSRqYquEsxdq/UkuY8RSNrVQ/a+Tg7QqWB4dtEkWuzM8iUgZIjZIg13EE14BwlgnzbBkpti+q+aTGfGYSgCk=
Received: from AM9PR04MB8274.eurprd04.prod.outlook.com (2603:10a6:20b:3e8::23)
 by AM0PR04MB6225.eurprd04.prod.outlook.com (2603:10a6:208:13c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.23; Tue, 19 Jul
 2022 23:33:06 +0000
Received: from AM9PR04MB8274.eurprd04.prod.outlook.com
 ([fe80::f46c:5b09:72eb:638c]) by AM9PR04MB8274.eurprd04.prod.outlook.com
 ([fe80::f46c:5b09:72eb:638c%4]) with mapi id 15.20.5438.025; Tue, 19 Jul 2022
 23:33:05 +0000
From:   Shenwei Wang <shenwei.wang@nxp.com>
To:     =?iso-8859-1?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial <linux-serial@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [EXT] Re: [PATCH V2 1/1] serial: fsl_lpuart: zero out parity bit
 in CS7 mode
Thread-Topic: [EXT] Re: [PATCH V2 1/1] serial: fsl_lpuart: zero out parity bit
 in CS7 mode
Thread-Index: AQHYl7Pc5ouTsV2p6EuL4SD+9s88e62FhFoAgADbN2A=
Date:   Tue, 19 Jul 2022 23:33:05 +0000
Message-ID: <AM9PR04MB8274A5FBEE76F65D36B12F39898F9@AM9PR04MB8274.eurprd04.prod.outlook.com>
References: <20220714185858.615373-1-shenwei.wang@nxp.com>
 <bf982c0-403c-1677-b8a-5098f7e85b82@linux.intel.com>
In-Reply-To: <bf982c0-403c-1677-b8a-5098f7e85b82@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: af85febd-940c-4385-17ec-08da69df07db
x-ms-traffictypediagnostic: AM0PR04MB6225:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZwASv+Zc+9R8r3eUstu3hz4HI9SmQ15DHH4a4K0w77kkkv2JBl6cs3sVo7XZ71nC3QHOG35KohCywkIhnH2OZ8HRXfpRcZ0ChkMra2AjM9zAX8qSg/yAvY2d5WlUKjg8IktqMSQtr0egauDtJRTWnvaj4j7y5MXNuVzMJmhseM7YN34rs/BNOuECBo4Dk7wn4lquq43qBywa5A0xAH5WD63Vh7I31zWI0J9BUT59RfzJVa339GzT4l/2cSUgjNdyQP/tXbz8F51TX0bpN9uztVs+R+y5zKrlpRF+B7CmQ9rT7YHzrxvL0MCWc2zK/dsFTpnZZIEHA0Ondg5HuHzzX3IrAB1OF+zOCSUrxacY6kWlEGvnm6SYGSMke9PUzO0lV+n7FXUIey1QvDWZGpHYqwZ2ksf3IL6W6vWhwvlnbwRB5GJDUPVaHCLc9UL8UPaA+pJ0aE3VnlGWaV+jdhZOkh07upePN3KK2TSNtlUO19GKg08T1iDTnFxL0JhC0J+nwzpXJp393xEsERxsTUifzdtztUFsTvXCxWAXZUj+XvNptSs47qjgREl0Rssvv7pL7rcIelEroOBplBtYTPVB7p+kXD7FPwZQvGKyKayOX89eUbdFayNX1Kk07RijIBH+MKPqHCls3lk/2U1G1u4SoCmZ2NkV3oHru94ZQ9MJcS5VoZA9RfBL+QHNdp9Zk5coCskNiXl2bQCzIeX93kbkg8CGgSyUJGObThgLlj6wcrlrUMNwwZcsWY9tKPqT3nHL326b0lrwnIycsMGg9uPqfGWtndPl8dDhXPtsce91ZJFAG6DZm2qldy+v8cBByj2C
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8274.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(39860400002)(136003)(376002)(396003)(366004)(55236004)(186003)(26005)(41300700001)(9686003)(478600001)(55016003)(83380400001)(2906002)(66574015)(33656002)(6506007)(53546011)(7696005)(44832011)(8936002)(5660300002)(52536014)(122000001)(316002)(86362001)(38100700002)(6916009)(66946007)(8676002)(64756008)(71200400001)(4326008)(38070700005)(54906003)(66446008)(76116006)(66476007)(66556008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?uWxskJfPkgukKFP48awJLBm4pU4LMs+FTTr6b9R8e+jEkj+ow+HJyRnD//?=
 =?iso-8859-1?Q?sMG4IVa16pKC0Dblcbz3WuKwuMo7dM7NqeoP8vIHZs4AEhZfSEp0vrr2pN?=
 =?iso-8859-1?Q?7dnVrz/hRZSkTc23qOs47xz7eFsCfGlYQH9bUczaVn2PSIRc3qYxOKRonw?=
 =?iso-8859-1?Q?xUdrF+nocGbBdlKtwK6aze2v74i0q2SyahCu2syq+OnniDGL2hejqy7GA+?=
 =?iso-8859-1?Q?f8Rpl23Pni95vEA+uGeCmVv4rQSHBgdxiyJsiOXKX5OSkuQfHYFm4LYwlY?=
 =?iso-8859-1?Q?4GHWr665pU4tto9KF0/g/1L3h9o94ievd2Kk+gTrYUZARCnp279r1A4ZTK?=
 =?iso-8859-1?Q?SOOYcdnmM0P1YcydncqXTofNhepa0NFIjo2Pob7okmEKGR7peIFzPE2CtT?=
 =?iso-8859-1?Q?JetISU5uZzxLz3WZtv7DWugwaW1Ug76FuX4z3+dufbGXVS5ACh1ZBUsR0Y?=
 =?iso-8859-1?Q?5LKBIMxWvxQMlayWdFrUBZ49W+S2fc+5/ZYdx1/S3EWz2kVNRujsKR7kDF?=
 =?iso-8859-1?Q?kZfuzdpyWwfFQ6NunYI81uHbWQlkCIfn7f/IJ4bYmojaOSXljhe+31jpwD?=
 =?iso-8859-1?Q?LnxMAIabolyzqxj1NOTCP8lF06zrajI8ddrrVSc+tsQ1SSUOvy36pEbjem?=
 =?iso-8859-1?Q?YPctnx9UoPIQuNh41A1Ieoy9kCF9s1oNFfptUphIib00ziA9g2Wnu0/l8X?=
 =?iso-8859-1?Q?GMIXHbp/AGYvseeLE4zkcidbk6deWiXiKU1E1CvzXIWSw5pre/W99Ko8bI?=
 =?iso-8859-1?Q?kSzmNoDsE1GVTu6s8kClJterT7xNgXAvb6bkfLy6Z0FXgofWrfWo/kO+7n?=
 =?iso-8859-1?Q?CZHiekqPRbXq1/CgZu0RxzaaGaAg1E4fIRCokWCblfqKU2O4ryKJHJ/EWD?=
 =?iso-8859-1?Q?hwml1PKtZEzd9+0T6lnsmz6kVoefUazJSts3K3tzEw3CR1Vtx5TyCr6Yr/?=
 =?iso-8859-1?Q?az7u3OoEbdSqgFGfU8hFC9zWkAfU3JkvJbeY7Wys4/fQ3duzyrnhJP7AWP?=
 =?iso-8859-1?Q?5vYOmnK+mucVlrJ/aEmDCXQxI7adCsmcCfz3tI7G1ty1sZbRmvq4pz8ZnF?=
 =?iso-8859-1?Q?CAhiHgyVSVMuj3jzcNlZJcjrli4NJ8EXicQnQrJLMpQ6KMKnQCDJlAvyDt?=
 =?iso-8859-1?Q?RhAfh+avSh01PCY5Ai8pAN14TCVRr3TDXAQDBUwu+lv6rCBM3mfpVZpjzl?=
 =?iso-8859-1?Q?emXRtCi0FrWZj9qu8sHX8nn/rdSLV1DPS+ArfbEvgWiUuRTV8G5rqozMg8?=
 =?iso-8859-1?Q?uaV5eE9NIq0PUWh4VbUZ4JaYPJ3cMaLm9/FecAY6ZYgDzGa1O40i84okE4?=
 =?iso-8859-1?Q?DZkLhEiechRjwRlz/IHhnJnXOwT/IVxp6g7jeHKiklp9B4r8R2qTtPCuSo?=
 =?iso-8859-1?Q?EElMem7hXJ3NjvSFQjtEY9VsgP7l1Mr7aexMk3hR2cGJnDYmpQU086odkw?=
 =?iso-8859-1?Q?YMzxltONFYalqWwVYq0JvDEQhK9in0jeO1dlci0nP+8XeaplsR6BGdEpn+?=
 =?iso-8859-1?Q?8mVl4bIR1GHkiLPW/7acKOQnqRs/iLc7ktYjYyWDXj8GeXIV6Z4U/Nuy+e?=
 =?iso-8859-1?Q?twdN7uqtn5oI3cHaAwCbOnQznm3kEvx6P9L9Bb3RoyYLL/0yj4ZBY2tKcF?=
 =?iso-8859-1?Q?vqEbjoCvGr6iPeUvuupT63tsI2HFspyRJ4?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8274.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af85febd-940c-4385-17ec-08da69df07db
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jul 2022 23:33:05.6143
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3g7MzSX8l+Crjvw9loqUE47pRZ9JO4LZLE+/T6dlAw4f3uoheyxo27J1VZawN/ZEnrl098zDoQiRjV+Xox7C8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6225
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> -----Original Message-----
> From: Ilpo J=E4rvinen <ilpo.jarvinen@linux.intel.com>
> Sent: Tuesday, July 19, 2022 5:26 AM
> To: Shenwei Wang <shenwei.wang@nxp.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>; linux-serial <linux-
> serial@vger.kernel.org>; stable@vger.kernel.org
> Subject: [EXT] Re: [PATCH V2 1/1] serial: fsl_lpuart: zero out parity bit=
 in CS7
> mode
>=20
> Caution: EXT Email
>=20
> On Thu, 14 Jul 2022, Shenwei Wang wrote:
>=20
> > The LPUART hardware doesn't zero out the parity bit on the received
> > characters. This behavior won't impact the use cases of CS8 because
> > the parity bit is the 9th bit which is not currently used by software.
> > But the parity bit for CS7 must be zeroed out by software in order to
> > get the correct raw data.
>=20
> This problem only occurs with the lpuart32 variant? Or should the other
> functions be changed as well?

In theory this problem should occur with the non lpuart32 variant too, beca=
use LPUART32 was derived from the non lpuart32 IP module.  However, I don't=
 have a platform to confirm it.

Thanks,
Shenwei

>=20
> --
>  i.
>=20
>=20
> > Signed-off-by: Shenwei Wang <shenwei.wang@nxp.com>
> > ---
> > changes in v2
> > - remove the "inline" keyword from the function of
> > lpuart_tty_insert_flip_string;
> >
> > changes in v1
> > - fix the code indent and whitespace issue;
> >
> >  drivers/tty/serial/fsl_lpuart.c | 26 ++++++++++++++++++++++++--
> >  1 file changed, 24 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/tty/serial/fsl_lpuart.c
> > b/drivers/tty/serial/fsl_lpuart.c index fc7d235a1e270..afa0f941c862f
> > 100644
> > --- a/drivers/tty/serial/fsl_lpuart.c
> > +++ b/drivers/tty/serial/fsl_lpuart.c
> > @@ -274,6 +274,8 @@ struct lpuart_port {
> >       int                     rx_dma_rng_buf_len;
> >       unsigned int            dma_tx_nents;
> >       wait_queue_head_t       dma_wait;
> > +     bool                    is_cs7; /* Set to true when character siz=
e is 7 */
> > +                                     /* and the parity is enabled     =
       */
> >  };
> >
> >  struct lpuart_soc_data {
> > @@ -1022,6 +1024,9 @@ static void lpuart32_rxint(struct lpuart_port *sp=
ort)
> >                               flg =3D TTY_OVERRUN;
> >               }
> >
> > +             if (sport->is_cs7)
> > +                     rx &=3D 0x7F;
> > +
> >               if (tty_insert_flip_char(port, rx, flg) =3D=3D 0)
> >                       sport->port.icount.buf_overrun++;
> >       }
> > @@ -1107,6 +1112,17 @@ static void lpuart_handle_sysrq(struct lpuart_po=
rt
> *sport)
> >       }
> >  }
> >
> > +static int lpuart_tty_insert_flip_string(struct tty_port *port,
> > +     unsigned char *chars, size_t size, bool is_cs7) {
> > +     int i;
> > +
> > +     if (is_cs7)
> > +             for (i =3D 0; i < size; i++)
> > +                     chars[i] &=3D 0x7F;
> > +     return tty_insert_flip_string(port, chars, size); }
> > +
> >  static void lpuart_copy_rx_to_tty(struct lpuart_port *sport)  {
> >       struct tty_port *port =3D &sport->port.state->port; @@ -1217,7
> > +1233,8 @@ static void lpuart_copy_rx_to_tty(struct lpuart_port *sport)
> >       if (ring->head < ring->tail) {
> >               count =3D sport->rx_sgl.length - ring->tail;
> >
> > -             copied =3D tty_insert_flip_string(port, ring->buf + ring-=
>tail, count);
> > +             copied =3D lpuart_tty_insert_flip_string(port, ring->buf =
+ ring->tail,
> > +                                     count, sport->is_cs7);
> >               if (copied !=3D count)
> >                       sport->port.icount.buf_overrun++;
> >               ring->tail =3D 0;
> > @@ -1227,7 +1244,8 @@ static void lpuart_copy_rx_to_tty(struct lpuart_p=
ort
> *sport)
> >       /* Finally we read data from tail to head */
> >       if (ring->tail < ring->head) {
> >               count =3D ring->head - ring->tail;
> > -             copied =3D tty_insert_flip_string(port, ring->buf + ring-=
>tail, count);
> > +             copied =3D lpuart_tty_insert_flip_string(port, ring->buf =
+ ring->tail,
> > +                                     count, sport->is_cs7);
> >               if (copied !=3D count)
> >                       sport->port.icount.buf_overrun++;
> >               /* Wrap ring->head if needed */ @@ -2066,6 +2084,7 @@
> > lpuart32_set_termios(struct uart_port *port, struct ktermios *termios,
> >       ctrl =3D old_ctrl =3D lpuart32_read(&sport->port, UARTCTRL);
> >       bd =3D lpuart32_read(&sport->port, UARTBAUD);
> >       modem =3D lpuart32_read(&sport->port, UARTMODIR);
> > +     sport->is_cs7 =3D false;
> >       /*
> >        * only support CS8 and CS7, and for CS7 must enable PE.
> >        * supported mode:
> > @@ -2184,6 +2203,9 @@ lpuart32_set_termios(struct uart_port *port, stru=
ct
> ktermios *termios,
> >       lpuart32_write(&sport->port, ctrl, UARTCTRL);
> >       /* restore control register */
> >
> > +     if ((ctrl & (UARTCTRL_PE | UARTCTRL_M)) =3D=3D UARTCTRL_PE)
> > +             sport->is_cs7 =3D true;
> > +
> >       if (old && sport->lpuart_dma_rx_use) {
> >               if (!lpuart_start_rx_dma(sport))
> >                       rx_dma_timer_init(sport);
> > --
> > 2.25.1
> >
