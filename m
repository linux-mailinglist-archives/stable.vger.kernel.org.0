Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5220160076
	for <lists+stable@lfdr.de>; Sat, 15 Feb 2020 21:51:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726340AbgBOUvq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Feb 2020 15:51:46 -0500
Received: from mail-eopbgr760074.outbound.protection.outlook.com ([40.107.76.74]:5235
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726254AbgBOUvq (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 15 Feb 2020 15:51:46 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P0ihGsrQmuJeUPVXRKYvRh9kWUMibM/ozbkwspED5xIGq66LAwG+51VJgkCuyH/K82iIwFBgQaEzWFo1FaEmCXNFv9+J/MkaXYM2+/fs4v8L87kvtBZUlThxpGHB5NyTXrB8cXlawKJ29Q86ZtDHlDcEdK7uicQOA4RdD9l1OlbY3Ev7rgcrVZIsYTGxjrE7NVnBK6fEBpbFISm8o/Vcz4C+bVBm5yYxjjGQ1EP3mRMardQOv9JQWFwofwB1NW0wfbSnX7OL7Ewa8b3y8GdMP9OcPWX9SdaVhWjchfvs9c6uD0bz65Sr0Ffvk74PFeADOvX0R5uqs6lpDQJRTqxgzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HO6I3jhj9L/T4zXRjruBWJcM5O09+/5D9NSloPcNwb0=;
 b=ORIboWJImWSrNSiKv0qHmHJro6yQPY/BJI5AVnpNT7gf6s+b7OvSZzbhfVt8TZMGBpxawonY8dxYb9HdJ8/ZxTL4c80OODiusctXQh20Hi8do/glYlCztTibOwwP7hfH7hzlkYt4FBPxJUjfU0TpOXVp4SIsKxA5nG9mf13jrhXfQIk5TSdOcQ2i7Gw2sOVvmb6zJrHEGoj7Ie9CHT2INT8li+jnE6vs8WuNTIIeLDE97pieHMwg78OHtSjTsWyEDcR0BE7gZwD6VBR/bA5VXHagZgFOORitWrBL4v1uqM7WptddbJgMSVlugDjxtgNspoKXxXfT23OnwyC1mqDphw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=xilinx.com; dmarc=pass action=none header.from=xilinx.com;
 dkim=pass header.d=xilinx.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HO6I3jhj9L/T4zXRjruBWJcM5O09+/5D9NSloPcNwb0=;
 b=EYQfUClYrzhLxRgWIt7FPznXebcytZzg2BPwp2shN1pxZ0W/xPoeue/oSU5fuLHvZbj6PQ7f4JQj+USQyPpB7AOjbuwjJ7Ajs6U0H/9l+aw12x0FlQZxXB9IdzFg00VDR6/mRJvj76j6DnBs3Rav5gF3IfX5G5t/Yz8z7Hoz7wc=
Received: from CH2PR02MB6359.namprd02.prod.outlook.com (52.132.230.25) by
 CH2SPR01MB0020.namprd02.prod.outlook.com (20.180.11.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.22; Sat, 15 Feb 2020 20:51:37 +0000
Received: from CH2PR02MB6359.namprd02.prod.outlook.com
 ([fe80::c9bd:b19d:704a:14df]) by CH2PR02MB6359.namprd02.prod.outlook.com
 ([fe80::c9bd:b19d:704a:14df%7]) with mapi id 15.20.2729.028; Sat, 15 Feb 2020
 20:51:37 +0000
From:   Dragan Cvetic <draganc@xilinx.com>
To:     Sasha Levin <sashal@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Derek Kiernan <dkiernan@xilinx.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH AUTOSEL 5.5 344/542] misc: xilinx_sdfec: fix
 xsdfec_poll()'s return type
Thread-Topic: [PATCH AUTOSEL 5.5 344/542] misc: xilinx_sdfec: fix
 xsdfec_poll()'s return type
Thread-Index: AQHV409N7nql6u4sN0afXLMJVz995KgcvK+A
Date:   Sat, 15 Feb 2020 20:51:37 +0000
Message-ID: <CH2PR02MB6359D1E5D7E76CB200E9D7B5CB140@CH2PR02MB6359.namprd02.prod.outlook.com>
References: <20200214154854.6746-1-sashal@kernel.org>
 <20200214154854.6746-344-sashal@kernel.org>
In-Reply-To: <20200214154854.6746-344-sashal@kernel.org>
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
x-ms-office365-filtering-correlation-id: 9d3e0d98-740b-4929-7036-08d7b258d9b5
x-ms-traffictypediagnostic: CH2SPR01MB0020:|CH2SPR01MB0020:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CH2SPR01MB0020FF97F8B191A0100D920FCB140@CH2SPR01MB0020.namprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:773;
x-forefront-prvs: 03142412E2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(396003)(39860400002)(366004)(376002)(199004)(189003)(6506007)(8936002)(52536014)(81166006)(8676002)(53546011)(81156014)(71200400001)(66556008)(7696005)(66946007)(66476007)(110136005)(54906003)(76116006)(66446008)(64756008)(26005)(316002)(55016002)(9686003)(966005)(2906002)(86362001)(478600001)(4326008)(5660300002)(33656002)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:CH2SPR01MB0020;H:CH2PR02MB6359.namprd02.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: xilinx.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 53roZxwvbrqjmQXSZsftAyElBeyf518j+RnNmYkVbqsRBHPksjR5XI3G0OBd21T0JviWZnw10SRVfiUtUlB9g1PFm7ErrAJhbAQhsDdOpF2eY1gHxD0SmCe2e0hkpo1oTcbX37Qv7nyNl6tY+hslmocpliYgWM+H/wbhjJe82W3thXemjMAmLGgPfSPa+ppRclzwgNrp2DymOVZuJvGWotWVjwiiP5/2xZQgH/JtPjwnSFQCElWiZ20+CSLLX/+nckvTlwn9pvtVK/hfGDX/9XCT8x9Uwfid2aIi0aV/VfFUd8U4FH/+eijMAGwa+xQ8LBGGOtctAe62XnBG4/pfjuTgGQ06jbMFWphQpMCvfIiB+ZJcyPXB4KgXoMs2vw6lq2HXp0jhFQyO29/GSFyGLJCMxUnwqxg5oXZdnpPcQ3NJbJ6MbZFidAMI1pbhraL8A4XW9VQZNxtCIqIz8c8zayoINsnCIP3GepIrTCWGmQ0ZAIuhy15MIJ8oOcxNHQEIKDI2zIP0u2OGlgjU3VVOaA==
x-ms-exchange-antispam-messagedata: wEAOKZA9TXE8n62bHLx/P3sWHwQlJRuFULJNwQjwlw5J8OpLtzqGLdW97cOfMyGyUYfVm3q9diqEDMGSwD13WDQmHsmeCQQCBBNfxJOEKeLkeJ+zN+aWGAVGMzIGJ4yTulDfwgX/xrtVVihbC6G4mQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d3e0d98-740b-4929-7036-08d7b258d9b5
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Feb 2020 20:51:37.4228
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Cx6vYrL19KN+qok1VNDAHTZ07ip4m3YwirM+0GKjSXHpVEvqiQhnE2lgBNrEK94LQlB21yTpBWtpvG2R/cQKZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2SPR01MB0020
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> -----Original Message-----
> From: Sasha Levin <sashal@kernel.org>
> Sent: Friday 14 February 2020 15:46
> To: linux-kernel@vger.kernel.org; stable@vger.kernel.org
> Cc: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>; Derek Kiernan <dkie=
rnan@xilinx.com>; Dragan Cvetic
> <draganc@xilinx.com>; Greg Kroah-Hartman <gregkh@linuxfoundation.org>; Sa=
sha Levin <sashal@kernel.org>; linux-arm-
> kernel@lists.infradead.org
> Subject: [PATCH AUTOSEL 5.5 344/542] misc: xilinx_sdfec: fix xsdfec_poll(=
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
