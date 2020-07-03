Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AFDB2136BD
	for <lists+stable@lfdr.de>; Fri,  3 Jul 2020 10:53:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726228AbgGCIxa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jul 2020 04:53:30 -0400
Received: from mail-eopbgr1410134.outbound.protection.outlook.com ([40.107.141.134]:54885
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725764AbgGCIx3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 3 Jul 2020 04:53:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cDZqDhKlth0tNP+s+5ucHslPjl6k2oRI0e+YafALcVA2LDhHS6c0EHwzIYK/NhtiKEkYokFm6pv3wYyQDglqWqVAvkgbdQgu8N42Kk9LpwzOBYR4ZpAfhHh+NCPQNFH1qxZDt6RyrHuoRIFpa7JSTS2M0agydCHvznf6WvUR8NmhAiQWJAwyvavK+aoU0diEpVrmHdsL4X2FBFPpOBjnA5M2xHIG1rEXbvne8bwDmeiN2uGv4dSVmsloKLzeN5GyeNWAyFDsx2ZUSNHWby+da0MAfgrC6s/IVgZmsW7MtUllPOj7VLsFW2ok3pRtAcX7lOzBsU/tLx0pDohclTgU1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nUwL+/p3aTuOhyn7coL3Z5wfQsD70C+ZpLdFhb54qEg=;
 b=U4RkH/VnBXEGL2GqD9mOGWxFyQevfTkFkjIQdbZ9vEHhGun4LtegGrnNASXtaM6sPeDjmTqGyyd5Tljr99MLIb1JW0zoSpur97/BoNZix7TckJXH+rZ8S9mdmKqLiGXBj8ADmpDfQgiBFgNPRp0ytfS908D4cXY9f3yQE38coN8SM7QJTj1q4nWtKTeZzuvzFWLw66i34ywk9l1tfaLVp5dOlAPUizHw9TOw2ms68XCRDEXp+dMgGEf+tu41vOJBZH6Lhc2PJVFwWREnB1Yr3LVo11lU/1Zctntk494YasP7f1UNhGEUARILUzitAGyvXKslMO0xKQRQy/xGdpZSlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nUwL+/p3aTuOhyn7coL3Z5wfQsD70C+ZpLdFhb54qEg=;
 b=hgwxdlZX4uN+NbPJlqKLS275EP5g4EfoNlkwzjNKecjr9TCAjiP5aFhIY4V7IQqsRAmWmOX/5m8CMTrqZ690xFJgXw5QsIwgJABbtAAiKK9sVHnXydQEcGVubZm4P+w2+UnkgUQxiK9cRfpHjpAiuW6u/WlKAAba/Q+e5IbixSE=
Received: from OSAPR01MB2915.jpnprd01.prod.outlook.com (2603:1096:603:38::10)
 by OSBPR01MB2518.jpnprd01.prod.outlook.com (2603:1096:604:21::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.21; Fri, 3 Jul
 2020 08:53:18 +0000
Received: from OSAPR01MB2915.jpnprd01.prod.outlook.com
 ([fe80::3d28:786d:6736:7a8]) by OSAPR01MB2915.jpnprd01.prod.outlook.com
 ([fe80::3d28:786d:6736:7a8%7]) with mapi id 15.20.3153.024; Fri, 3 Jul 2020
 08:53:18 +0000
From:   Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Biju Das <biju.das.jz@bp.renesas.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     Geert Uytterhoeven <geert+renesas@glider.be>
Subject: RE: patch "serial: sh-sci: Initialize spinlock for uart console"
 added to tty-linus
Thread-Topic: patch "serial: sh-sci: Initialize spinlock for uart console"
 added to tty-linus
Thread-Index: AQHWURWhMqamFVKjKUu3jfwLKaD60Kj1iVYA
Date:   Fri, 3 Jul 2020 08:53:18 +0000
Message-ID: <OSAPR01MB2915705C9D066B832772457FAA6A0@OSAPR01MB2915.jpnprd01.prod.outlook.com>
References: <1593765640253201@kroah.com>
In-Reply-To: <1593765640253201@kroah.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=bp.renesas.com;
x-originating-ip: [193.141.220.21]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 5993424f-f40b-4405-a3cc-08d81f2e882a
x-ms-traffictypediagnostic: OSBPR01MB2518:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OSBPR01MB2518C06597FFD0EF2130B953AA6A0@OSBPR01MB2518.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 045315E1EE
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NthAdr4hJNpgjQZTg79+9sHn8mUTiOzg7a58FzyR3SMPwHcCqwtNMpiRFEqBpJ/nJd2b48ZlVf5h1wMAZxBh798iuVHCvobgqorxsWViU2cv7dhhdsvlq7kzrP0jx9yb19d6hdodDB1CYJUlbgGPLmjAWZ78nPlzcYoCADqW72g1/h6HVPMrsEQe5+V57dea5+IhcJkTg2OaKLP0HoHWTcQVdhnHDV3xI7leMhvelhpFBzY9MG7XXv+A3GrDM4SdY40nms5brrc94lv/9ywukuSDUM0knkVYkHw7C/QQPL78PMCjxWqLrEfqnmw4d2rUvoyMDzn2FCyM/3MnuAeO5p6BNuPyl6tphUlUA7muQHy3PPKrvu/fBYZXrDTFaIBp1HRepzdpCxNFcPXPeQSTJQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OSAPR01MB2915.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(136003)(366004)(376002)(39860400002)(346002)(186003)(26005)(4326008)(9686003)(7696005)(2906002)(64756008)(76116006)(66556008)(52536014)(71200400001)(5660300002)(66946007)(66446008)(66476007)(86362001)(55016002)(8676002)(8936002)(6506007)(83380400001)(53546011)(33656002)(966005)(316002)(478600001)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: xJKXLdzQfb0iumhhY3NHc78l8CgUfnY+kIYrsUYCgiwmb1cmnSxiBSraVVKcouYcYuWPdJTRt7KOohMkL0OhweK8rib/t4st3O58+CvOuG+xaZCfIC0yxmc06MVlA6RlbQ+OVE81lb2gkAMmlUdIBMvqpYXbhSeBOdcJz/9IhAxtRoBk6p505DyRFme6YsDs6jmzRj6fWUG2GE004HbrNDJMLoIXvDRud6onxPQcSx62H5Za+QuCgBjJsxliNbod9NaCh3lyjXz4T62SZHFO3DqkFT6pL72D38kbqyGtApmz/3l0o6ysRAaWW6ifQiHM/tpfKx6vSY7ZDe4aM/ee/02dxorlu736xJIed1XSJaKP74cmzCbsoMLeqg89v4bhh4GNpAmhhrprWaA9xWphSA0FP7tMuPDenYWODxglIwpAaWBuEoEit/3iVK9ohXSot/bDtwwTBxQ/pSlI7OnYCgCIIMVMsEzS/xYZl+OqHZvpeAzKlamvusY32QplkxA4
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OSAPR01MB2915.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5993424f-f40b-4405-a3cc-08d81f2e882a
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jul 2020 08:53:18.4798
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rEJBTxVGuhtPT9wBRykTSm/MSZFRwNo5NWLaK/VaMcW8x85v0WNAPcN1CRsfUUi9mXRQSxipMo06jgeB7QO16RRq2pnVC1tlbGuY7L48RIJ1CMlHM21ai21He3xu8pfB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSBPR01MB2518
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

> -----Original Message-----
> From: gregkh@linuxfoundation.org <gregkh@linuxfoundation.org>
> Sent: 03 July 2020 09:41
> To: Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>; Biju=
 Das <biju.das.jz@bp.renesas.com>;
> gregkh@linuxfoundation.org; stable@vger.kernel.org
> Subject: patch "serial: sh-sci: Initialize spinlock for uart console" add=
ed to tty-linus
>
>
> This is a note to let you know that I've just added the patch titled
>
>     serial: sh-sci: Initialize spinlock for uart console
>
> to my tty git tree which can be found at
>     git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
> in the tty-linus branch.
>
> The patch will show up in the next release of the linux-next tree
> (usually sometime within the next 24 hours during the week.)
>
> The patch will hopefully also be merged in Linus's tree for the
> next -rc kernel release.
>
> If you have any questions about this process, please let me know.
>
It looks like it's a regression in serial_core.c [1] as Geert pointed out [=
2]. Please drop this patch until we come to a conclusion.

[1] https://www.spinics.net/lists/linux-serial/msg37119.html
[2] https://patchwork.kernel.org/patch/11636731/

Cheers,
--Prabhakar
>
> From f38278e9b810b06aff2981d505267be984423ba3 Mon Sep 17 00:00:00 2001
> From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> Date: Wed, 1 Jul 2020 16:41:40 +0100
> Subject: serial: sh-sci: Initialize spinlock for uart console
>
> serial core expects the spinlock to be initialized by the controller
> driver for serial console, this patch makes sure the spinlock is
> initialized, fixing the below issue:
>
> [    0.865928] BUG: spinlock bad magic on CPU#0, swapper/0/1
> [    0.865945]  lock: sci_ports+0x0/0x4c80, .magic: 00000000, .owner: <no=
ne>/-1, .owner_cpu: 0
> [    0.865955] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.8.0-rc1+ #112
> [    0.865961] Hardware name: HopeRun HiHope RZ/G2H with sub board (DT)
> [    0.865968] Call trace:
> [    0.865979]  dump_backtrace+0x0/0x1d8
> [    0.865985]  show_stack+0x14/0x20
> [    0.865996]  dump_stack+0xe8/0x130
> [    0.866006]  spin_dump+0x6c/0x88
> [    0.866012]  do_raw_spin_lock+0xb0/0xf8
> [    0.866023]  _raw_spin_lock_irqsave+0x80/0xa0
> [    0.866032]  uart_add_one_port+0x3a4/0x4e0
> [    0.866039]  sci_probe+0x504/0x7c8
> [    0.866048]  platform_drv_probe+0x50/0xa0
> [    0.866059]  really_probe+0xdc/0x330
> [    0.866066]  driver_probe_device+0x58/0xb8
> [    0.866072]  device_driver_attach+0x6c/0x90
> [    0.866078]  __driver_attach+0x88/0xd0
> [    0.866085]  bus_for_each_dev+0x74/0xc8
> [    0.866091]  driver_attach+0x20/0x28
> [    0.866098]  bus_add_driver+0x14c/0x1f8
> [    0.866104]  driver_register+0x60/0x110
> [    0.866109]  __platform_driver_register+0x40/0x48
> [    0.866119]  sci_init+0x2c/0x34
> [    0.866127]  do_one_initcall+0x88/0x428
> [    0.866137]  kernel_init_freeable+0x2c0/0x328
> [    0.866143]  kernel_init+0x10/0x108
> [    0.866150]  ret_from_fork+0x10/0x18
>
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> Reviewed-by: Biju Das <biju.das.jz@bp.renesas.com>
> Fixes: a3cb39d258ef ("serial: core: Allow detach and attach serial device=
 for console")
> Cc: stable <stable@vger.kernel.org>
> Link: https://lore.kernel.org/r/1593618100-2151-1-git-send-email-prabhaka=
r.mahadev-lad.rj@bp.renesas.com
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/tty/serial/sh-sci.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/drivers/tty/serial/sh-sci.c b/drivers/tty/serial/sh-sci.c
> index e1179e74a2b8..204bb68ce3ca 100644
> --- a/drivers/tty/serial/sh-sci.c
> +++ b/drivers/tty/serial/sh-sci.c
> @@ -3301,6 +3301,9 @@ static int sci_probe_single(struct platform_device =
*dev,
>  sciport->port.flags |=3D UPF_HARD_FLOW;
>  }
>
> +if (sci_uart_driver.cons->index =3D=3D sciport->port.line)
> +spin_lock_init(&sciport->port.lock);
> +
>  ret =3D uart_add_one_port(&sci_uart_driver, &sciport->port);
>  if (ret) {
>  sci_cleanup_single(sciport);
> --
> 2.27.0
>



Renesas Electronics Europe GmbH, Geschaeftsfuehrer/President: Carsten Jauch=
, Sitz der Gesellschaft/Registered office: Duesseldorf, Arcadiastrasse 10, =
40472 Duesseldorf, Germany, Handelsregister/Commercial Register: Duesseldor=
f, HRB 3708 USt-IDNr./Tax identification no.: DE 119353406 WEEE-Reg.-Nr./WE=
EE reg. no.: DE 14978647
