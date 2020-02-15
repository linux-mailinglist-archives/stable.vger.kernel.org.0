Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7497B16007A
	for <lists+stable@lfdr.de>; Sat, 15 Feb 2020 21:52:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbgBOUwE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Feb 2020 15:52:04 -0500
Received: from mail-eopbgr760078.outbound.protection.outlook.com ([40.107.76.78]:22158
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726254AbgBOUwE (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 15 Feb 2020 15:52:04 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aBMHCHHFoAVtW1Fsxg5lgKBnmUpbROjFPlsRm73Pee+cwvw1f80Wd1UHev7DQ5rTOT8C0Hv2xD3v3jQsJYl6sQ+CewsP+U90+uyQiC+sYFBCdqUlBYCxzCbBP7XqXV7L3pONZ60eiPTOfZTebFT56AJ92ZfZNuv95JwLFVWjCG1bEBerqWpWWpJ800g5MW5o/4usLZTmGS/kFRp/uYe3VSQnpBKPfEs8tQB/QX58v+Ay8qvygyAVwp37coPrWVS0YSrWGQL/Fff5MPk8rASO9IF8qy2caZUZDAbULwZNAgxzyYO4exD4/GCwV6BouP3tGzjpztIoQhsVuXIIZy2VBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HOBcsRHBuzI/ktdH5s1Q4+QOfZm1ltGLHf+UVoH6/RM=;
 b=hscJa/xtwKAiAxcXvsAG2YV6Pg0fZTzgJvnIvsxXRByqmy0lHhK/nf+nFQlmS/xWrk4Flnosi5po7zcZ5+E5Ld95vK3rMvWUhtMZ2IBXeQ1SreXqPNByf00qZWzrxJ2Kr7+tKIgZFYEOgg51cp7Ay2O8Yh9nzRX410YOkwOe7EWqcCIGbKrmyajxEPx+E/bAJp8SpvxbLbKn8zViUvbeSrnUHESi8ii2JW2bOxolRS0llJ6rT995CNn++7JY3rEa/9Eww57ep8Wz6k7g7pTDDCnPAskhWOTxpvtDT75B2MpFLw7FthUJ8YF9f8YmAsCuGE/M/Qh244tE4oXZfANYQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=xilinx.com; dmarc=pass action=none header.from=xilinx.com;
 dkim=pass header.d=xilinx.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HOBcsRHBuzI/ktdH5s1Q4+QOfZm1ltGLHf+UVoH6/RM=;
 b=Z4zt3qfjXlsAYqUEvTMC2FCjPFzIkqiYPrttoft0NoFtdEge3pLFw6/t3zFZ+s6NORKn2YS3Mzc/8P0SpN9Me+jvgq58L3sR/w6JS9Et4+eohtQeiq0axcFEC80k9c/sI+lHoLkvDn/TYuI9osTwn3oE/aW0CcWo6gjCB8n8LW4=
Received: from CH2PR02MB6359.namprd02.prod.outlook.com (52.132.230.25) by
 CH2SPR01MB0020.namprd02.prod.outlook.com (20.180.11.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.22; Sat, 15 Feb 2020 20:52:01 +0000
Received: from CH2PR02MB6359.namprd02.prod.outlook.com
 ([fe80::c9bd:b19d:704a:14df]) by CH2PR02MB6359.namprd02.prod.outlook.com
 ([fe80::c9bd:b19d:704a:14df%7]) with mapi id 15.20.2729.028; Sat, 15 Feb 2020
 20:52:01 +0000
From:   Dragan Cvetic <draganc@xilinx.com>
To:     Sasha Levin <sashal@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Derek Kiernan <dkiernan@xilinx.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH AUTOSEL 5.4 299/459] misc: xilinx_sdfec: fix
 xsdfec_poll()'s return type
Thread-Topic: [PATCH AUTOSEL 5.4 299/459] misc: xilinx_sdfec: fix
 xsdfec_poll()'s return type
Thread-Index: AQHV41D3T+CdT+Q7T0isFJicpaRRO6gcvNTA
Date:   Sat, 15 Feb 2020 20:52:01 +0000
Message-ID: <CH2PR02MB635957528FFF97FBF8121E24CB140@CH2PR02MB6359.namprd02.prod.outlook.com>
References: <20200214160149.11681-1-sashal@kernel.org>
 <20200214160149.11681-299-sashal@kernel.org>
In-Reply-To: <20200214160149.11681-299-sashal@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=draganc@xilinx.com; 
x-originating-ip: [149.199.80.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: afe31b3b-54a5-42ad-39d4-08d7b258e7f0
x-ms-traffictypediagnostic: CH2SPR01MB0020:|CH2SPR01MB0020:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CH2SPR01MB00204D8191A8344996AFC9ECCB140@CH2SPR01MB0020.namprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:773;
x-forefront-prvs: 03142412E2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(396003)(39860400002)(366004)(376002)(199004)(189003)(6506007)(8936002)(52536014)(81166006)(8676002)(53546011)(81156014)(71200400001)(66556008)(7696005)(66946007)(66476007)(110136005)(54906003)(76116006)(66446008)(64756008)(26005)(316002)(55016002)(9686003)(966005)(2906002)(86362001)(478600001)(4326008)(5660300002)(33656002)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:CH2SPR01MB0020;H:CH2PR02MB6359.namprd02.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: xilinx.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8HhTso0O2WqtxikDa2ILkZQ8W9TkvAMrCfvGYkl5yBGF1mSzWOBRYtQUdv+t4x/fWnBmX+qHetf1M5hoUxARGfsc3m2rMfbvH30JQfH1bPhjFQtwBgdKWdszU5VEH/jiY3TrQMYWaWiF8Q55KNeY09Njad38Kur8NL+7+7f3CBQSZUoy+DWE3QFwBCKLugSeI2VQUq9YAvXVMDhUV5LXnYAFbbIHrgQGhS8vI+wxXKAID4IGoH6BoKoZaAxI294L35NzBbHca3OjbwVyafzu106nyx/uiMFZcDIFawL/54f9/Ufq0ldzWPpw7UaILf2tIi6hCWALJDv03sSIhtQkjQRaeO1YVJzee0rGTifKXHm3CKHQwJVwfNHUodTgHBcZN7ms70Z35VhV4hCXe62VmV49KB19sKOMSfSG9nlekF809/AP4d8xo7oqmQt1xLj+ylhW9mdZ7UikdDFb86EHjH/arpMpsYPNTkpWf6qxDQOlFPFsUT+7Tt7RV201WYv+iX7w2tqjFlwagwxxQG8OaA==
x-ms-exchange-antispam-messagedata: 4rB5986mljYUuvuLxZ2iEgYq0vY7xjWWZ1q0ce46ud1IYFwr4QOYk5iLYRc3ll+9Yut51zlEC0WGgyVpivcWWVvwQ5F4hiI4bsuV5wIvHg/fOlRzXx8pw96W7aJhMmhsF5WYWqYxoKWFTDWNoq5RYQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-Network-Message-Id: afe31b3b-54a5-42ad-39d4-08d7b258e7f0
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Feb 2020 20:52:01.2851
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TdChtI/Qpu8Bl/HPzYl4VO5x12sNBkwwJe9FzAIlOwbXTMrVR+L4JfXghMz+xY1NhbV4Kr3Tn7z6hnF7yQm6Pg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2SPR01MB0020
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> -----Original Message-----
> From: Sasha Levin <sashal@kernel.org>
> Sent: Friday 14 February 2020 15:59
> To: linux-kernel@vger.kernel.org; stable@vger.kernel.org
> Cc: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>; Derek Kiernan <dkie=
rnan@xilinx.com>; Dragan Cvetic
> <draganc@xilinx.com>; Greg Kroah-Hartman <gregkh@linuxfoundation.org>; Sa=
sha Levin <sashal@kernel.org>; linux-arm-
> kernel@lists.infradead.org
> Subject: [PATCH AUTOSEL 5.4 299/459] misc: xilinx_sdfec: fix xsdfec_poll(=
)'s return type
>=20
> From: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
>=20
> [ Upstream commit fa4e7fc1386078edcfddd8848cb0374f4af74fe7 ]
>=20
> xsdfec_poll() is defined as returning 'unsigned int' but the
> .poll method is declared as returning '__poll_t', a bitwise type.
>=20
> Fix this by using the proper return type and using the EPOLL
> constants instead of the POLL ones, as required for __poll_t.
>=20
> CC: Derek Kiernan <derek.kiernan@xilinx.com>
> CC: Dragan Cvetic <dragan.cvetic@xilinx.com>
> Signed-off-by: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
> Acked-by: Dragan Cvetic <dragan.cvetic@xilinx.com>
> Link: https://lore.kernel.org/r/20191209213655.57985-1-luc.vanoostenryck@=
gmail.com
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/misc/xilinx_sdfec.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/misc/xilinx_sdfec.c b/drivers/misc/xilinx_sdfec.c
> index 11835969e9828..48ba7e02bed72 100644
> --- a/drivers/misc/xilinx_sdfec.c
> +++ b/drivers/misc/xilinx_sdfec.c
> @@ -1025,25 +1025,25 @@ static long xsdfec_dev_compat_ioctl(struct file *=
file, unsigned int cmd,
>  }
>  #endif
>=20
> -static unsigned int xsdfec_poll(struct file *file, poll_table *wait)
> +static __poll_t xsdfec_poll(struct file *file, poll_table *wait)
>  {
> -	unsigned int mask =3D 0;
> +	__poll_t mask =3D 0;
>  	struct xsdfec_dev *xsdfec;
>=20
>  	xsdfec =3D container_of(file->private_data, struct xsdfec_dev, miscdev)=
;
>=20
>  	if (!xsdfec)
> -		return POLLNVAL | POLLHUP;
> +		return EPOLLNVAL | EPOLLHUP;
>=20
>  	poll_wait(file, &xsdfec->waitq, wait);
>=20
>  	/* XSDFEC ISR detected an error */
>  	spin_lock_irqsave(&xsdfec->error_data_lock, xsdfec->flags);
>  	if (xsdfec->state_updated)
> -		mask |=3D POLLIN | POLLPRI;
> +		mask |=3D EPOLLIN | EPOLLPRI;
>=20
>  	if (xsdfec->stats_updated)
> -		mask |=3D POLLIN | POLLRDNORM;
> +		mask |=3D EPOLLIN | EPOLLRDNORM;
>  	spin_unlock_irqrestore(&xsdfec->error_data_lock, xsdfec->flags);
>=20
>  	return mask;
> --
> 2.20.1

Acked-by: Dragan Cvetic <dragan.cvetic@xilinx.com>
