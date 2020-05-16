Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4BCF1D5F01
	for <lists+stable@lfdr.de>; Sat, 16 May 2020 08:19:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725803AbgEPGTC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 May 2020 02:19:02 -0400
Received: from mail-dm6nam11on2086.outbound.protection.outlook.com ([40.107.223.86]:20960
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725275AbgEPGTC (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 May 2020 02:19:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mk0dj7rE+zWZ9X6FCzwAye4HvjKdy/EF2jm/CGUREbSEHqZOjUv66/mz8sukFHzC26nSClq7gEZH77qNs8UMbODJSKI01tCsVDu0z2fkhtuFwzoqHCTy0g/ITI6OqNx9By0I3QFo5E4yXxKCne4hejZ5vmwLc00gLA0gP9DhXiStG7F/NdCmRo45+WtYUN5AGqwyTyBDe13oXIge2fX06rF2CFB88qtAG89Z+SPKtDqeqa7zm1E7GdMqbKhkxdGSlAurtAMUxGyX+xc3iYuJukY4FiTYzRmlkaPvqlWA3Y0tWhvIsn/b3h3YbsphVO/qnOAGo5JivkjTCX5JlRFKsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YluKaD3jJmyNAVNXS0VyEwF4WK7zpWZktWGVTabndoQ=;
 b=QfBMvzIUwDaXvvTRfznTE5YO4qLYQi4v2EqkpWN7kMRf7cPgba9Ed2T5mf3smiS1oaykjy/MHhPQzsfjd7bT5y8wEnNuIYv7yYTTMF7ylST8LRkybT56oxIRqVHZOQL9rSp7M/3yRgyzUG2DfgLFCwVK7/JB8sJRUC/IipvH+BVa3TI8Mi4lkwei0oJ9RSt0Ypl4SYK94s0SJpnryyW7epZqIHCeWIHYx8/cgr2BXbTCqPjbkpz42ivYSzZBSPijIBHfvS/5vaIdkzrzD3VNH/JE752yupBcALbTuQ0/Dm/unEN+IP9htM7CRGv0cy4hNCeEvhhyP9WEwisjq+eQzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sifive.com; dmarc=pass action=none header.from=sifive.com;
 dkim=pass header.d=sifive.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sifive.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YluKaD3jJmyNAVNXS0VyEwF4WK7zpWZktWGVTabndoQ=;
 b=X/I8MHOHdYtwmXxqbz9AJ6EOV+Tbr9Uvvv2IYSEUhlcd3tTK7az3tOfdinz5ljrxpXmVPJr1zNaJKuj5q024txAONHMooS6TqanoiiHAnN9YRxBZPpkQXsUUpOHgOpKDm6MHknKdhWdLSXLpdWH97QcYKWuzZEmrTjVZvcYsrGM=
Received: from BYAPR13MB2614.namprd13.prod.outlook.com (2603:10b6:a03:b4::12)
 by BYAPR13MB2293.namprd13.prod.outlook.com (2603:10b6:a02:c5::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.11; Sat, 16 May
 2020 06:18:59 +0000
Received: from BYAPR13MB2614.namprd13.prod.outlook.com
 ([fe80::c0fc:30a3:5e5f:c2b6]) by BYAPR13MB2614.namprd13.prod.outlook.com
 ([fe80::c0fc:30a3:5e5f:c2b6%7]) with mapi id 15.20.3000.013; Sat, 16 May 2020
 06:18:59 +0000
From:   Sagar Kadam <sagar.kadam@sifive.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "Atish.Patra@wdc.com" <Atish.Patra@wdc.com>,
        "palmerdabbelt@google.com" <palmerdabbelt@google.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: patch "tty: serial: add missing spin_lock_init for SiFive serial
 console" added to tty-linus
Thread-Topic: patch "tty: serial: add missing spin_lock_init for SiFive serial
 console" added to tty-linus
Thread-Index: AQHWKrgW8OtVUBSBQ0ig/n7dELWeWKiqPhlw
Date:   Sat, 16 May 2020 06:18:58 +0000
Message-ID: <BYAPR13MB26140DFE7B4C0E1824067A3B99BA0@BYAPR13MB2614.namprd13.prod.outlook.com>
References: <1589547313226207@kroah.com>
In-Reply-To: <1589547313226207@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=sifive.com;
x-originating-ip: [116.74.153.242]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 88dd85c5-e6fc-4c04-6ae1-08d7f961055a
x-ms-traffictypediagnostic: BYAPR13MB2293:
x-microsoft-antispam-prvs: <BYAPR13MB2293E119D94FA6D8F2B100EF99BA0@BYAPR13MB2293.namprd13.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 040513D301
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3qYZfYU0oYfl6+TQCOCu7Zg+jM2aCrf+GCKAMZzrYPNSg9a338iiQzDN8aV8Oox+Zif+pUd8aHu6cEC4cpKu/0kqrICwSfGKgCz/t0FWbB/n4HNqhBBuJqEI2okG+5O8PR7u35Jy4qa+4r/lUBra9IMwfNOmHYyWws0NADd45bsm3Bo4+8RWyJQzDF9IxsVgW9NzVOaTp7A0RVDns2v86/Kg5GCB1RtELrCfCf4xnW7JKSvJ1veilkMzgoYgGtTz3ZlkNp1kWpXTUYdOLBo3s4Lcy9hwCz6oqKC9jtgqnpb1dRVdn/nZmKUgtfhJv8Y3WSHbMqpGN7UKp7AukBrZpjPkgy/MzUFz7FUz0STdzYwRrmHlDZm9wcIr5BvPKFywzMGpbXlj8THSvltlpMlIjg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR13MB2614.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(6029001)(376002)(366004)(39850400004)(136003)(396003)(346002)(53546011)(6506007)(110136005)(76116006)(2906002)(66446008)(66946007)(44832011)(66476007)(64756008)(316002)(66556008)(5660300002)(8936002)(52536014)(26005)(186003)(55236004)(9686003)(71200400001)(7696005)(86362001)(33656002)(8676002)(966005)(478600001)(55016002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: Xns9PiLVoR0rsmTvIf1VImh8uVT0xdTL8FmMyV27ZCkl+AkG1p1n4J85ZTYMeLsi1CmrubPAoeSz8P2htEhjE7D9NPOH/L//5M6eomApJQwKJkRHF0lJu3xzJl/NBejTizjJuRU5Jt2bAaSUD+YMWsJLM3Z/+gFDnJk72Ie+fmrs0kvlINGtSJh1lT0bWa0E857T3D/8gqDs08QyELEBWujd6qvcZGdZWg1XxsUUQDVjjNrn+BTtjxqCz0eW7Idq1DAWLFyuyFKoHiq7/TUGLJkBDOQHNS+76c6A/NRvKvV1LUQP3ZfxumEv81qXx0sZhfTBK9zUyJfPZab8GZ9kDdlIgX84eRJ01EJTl+5wMKjJCJ578sFJqFZShfTlDzR9NnDnIKHfRncZSMNqJe50FSxwBnCAPuDzTqxk3ZcHQ9BSbb/vCfMbVSXwL08wEOOFKCDHE0xhsDGF+q6vkX+EnXkuHOlJ58bqyv57UIpge4NcHzGftoRsx0EIb7Ea5cKL
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: sifive.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88dd85c5-e6fc-4c04-6ae1-08d7f961055a
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 May 2020 06:18:59.1271
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 22f88e9d-ae0d-4ed9-b984-cdc9be1529f1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 933XunJtkgfWEpa0+t6zxiA0c9udjfRoKRYjTZkL8Q/QEjPQtxnUUA6tIGhbbCdjOMwuk62MAP0jHKETL6KL4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR13MB2293
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Greg,

Thanks for the notification.

BR,
Sagar

> -----Original Message-----
> From: gregkh@linuxfoundation.org <gregkh@linuxfoundation.org>
> Sent: Friday, May 15, 2020 6:25 PM
> To: Sagar Kadam <sagar.kadam@sifive.com>; Atish.Patra@wdc.com;
> gregkh@linuxfoundation.org; palmerdabbelt@google.com;
> stable@vger.kernel.org
> Subject: patch "tty: serial: add missing spin_lock_init for SiFive serial
> console" added to tty-linus
>=20
> [External Email] Do not click links or attachments unless you recognize t=
he
> sender and know the content is safe
>=20
> This is a note to let you know that I've just added the patch titled
>=20
>     tty: serial: add missing spin_lock_init for SiFive serial console
>=20
> to my tty git tree which can be found at
>     git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
> in the tty-linus branch.
>=20
> The patch will show up in the next release of the linux-next tree
> (usually sometime within the next 24 hours during the week.)
>=20
> The patch will hopefully also be merged in Linus's tree for the
> next -rc kernel release.
>=20
> If you have any questions about this process, please let me know.
>=20
>=20
> From 17b4efdf4e4867079012a48ca10d965fe9d68822 Mon Sep 17 00:00:00
> 2001
> From: Sagar Shrikant Kadam <sagar.kadam@sifive.com>
> Date: Sat, 9 May 2020 03:24:12 -0700
> Subject: tty: serial: add missing spin_lock_init for SiFive serial consol=
e
>=20
> An uninitialised spin lock for sifive serial console raises a bad
> magic spin_lock error as reported and discussed here [1].
> Initialising the spin lock resolves the issue.
>=20
> The fix is tested on HiFive Unleashed A00 board with Linux 5.7-rc4
> and OpenSBI v0.7
>=20
> [1] https://lore.kernel.org/linux-
> riscv/b9fe49483a903f404e7acc15a6efbef756db28ae.camel@wdc.com
>=20
> Fixes: 45c054d0815b ("tty: serial: add driver for the SiFive UART")
> Reported-by: Atish Patra <Atish.Patra@wdc.com>
> Signed-off-by: Sagar Shrikant Kadam <sagar.kadam@sifive.com>
> Reviewed-by: Palmer Dabbelt <palmerdabbelt@google.com>
> Acked-by: Palmer Dabbelt <palmerdabbelt@google.com>
> Cc: stable <stable@vger.kernel.org>
> Link: https://lore.kernel.org/r/1589019852-21505-2-git-send-email-
> sagar.kadam@sifive.com
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/tty/serial/sifive.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/tty/serial/sifive.c b/drivers/tty/serial/sifive.c
> index 13eadcb8aec4..0b5110dad051 100644
> --- a/drivers/tty/serial/sifive.c
> +++ b/drivers/tty/serial/sifive.c
> @@ -883,6 +883,7 @@ console_initcall(sifive_console_init);
>=20
>  static void __ssp_add_console_port(struct sifive_serial_port *ssp)
>  {
> +       spin_lock_init(&ssp->port.lock);
>         sifive_serial_console_ports[ssp->port.line] =3D ssp;
>  }
>=20
> --
> 2.26.2
>=20

