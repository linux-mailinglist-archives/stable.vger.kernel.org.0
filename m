Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FAE5364538
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:48:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241658AbhDSNo5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:44:57 -0400
Received: from mail-eopbgr1310090.outbound.protection.outlook.com ([40.107.131.90]:6334
        "EHLO APC01-SG2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241542AbhDSNoP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:44:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C861wjvSreBd6Vbt8gtPrkl0pD4vqz/MuToaUrKNYRi2pONP9/9kPR0AglFXWCOdPSAwxSZ1q2GWgbbTz2pg5OobIx8c33UQN5ZpwJ4UIzlOQQnuUF0wovjgh7qNu2m2eX0Y9R2otV5y7qczCccUOYugdh6+OK6SFxVQHOgVqOYD4VBhBpXrKXQwZgB4tIm3TMl0Er158S9YjAswaVUNE9kXo0vscAVnpP3OODbng9QgN6Y7DTcxLk9XzI3V2vNnxlLenJjSstgVGiVRPJrtqJg4K//UyAjdoU8v2Vvex8wFWNDin0awezk7JQhX+rIZnNLpiA0zEswQ1NCzVuFDSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+8xcmvTKtjW25KjhvyCRyZP/mfag51RufBnt90cn2HA=;
 b=LwoItBRqCvI6tmUgEt1EhsV/uwhGOb9ozbV1y7RNZS/I2ed2vOjjOxufCzYHwm6Di5OlAGSXqp/wbK1IV72EwpTsogAgiae4ftqW7WDPDnOSLwOt7S6jAW4FwFy5PDGseRtS96SI2TwSrr52RIqh/7SNXUd0VyfGbsd/nfg2v7eBxdui7oxGME0PKFqNAgxkI3tHrOqpj5Hs17fViYESVzwVNOarGuPPx7TKqBZzktx20jLexwQEchBggvsjzjZC9LN9DSpKjBbLxfkwW6+xcJbBbruvRGURxBfjBwg1tkANSCsSO/iUX5sFy0ZPCoe6VJxwR+At4KorMpWqkBD/DQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+8xcmvTKtjW25KjhvyCRyZP/mfag51RufBnt90cn2HA=;
 b=h/z246E4hTeBD9mnNtt6utgDcDCuj4Id+aAGk2/vUY/oobcHEkJY5WFLz2WgI2HhzJmnRVVKwxKYxZdC+NPOEvqPgfMIjVNvMTFrrHMz2AwjVRHhCElx0ZL11dzZTDXMqYtXO5OwEpWsaYrKYQHK5w2lAJstm5J95s/LcoJBWyc=
Received: from PSAP153MB0422.APCP153.PROD.OUTLOOK.COM (2603:1096:301:38::12)
 by PSAP153MB0407.APCP153.PROD.OUTLOOK.COM (2603:1096:301:3f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.11; Mon, 19 Apr
 2021 13:43:37 +0000
Received: from PSAP153MB0422.APCP153.PROD.OUTLOOK.COM
 ([fe80::9921:b743:c0db:6f50]) by PSAP153MB0422.APCP153.PROD.OUTLOOK.COM
 ([fe80::9921:b743:c0db:6f50%7]) with mapi id 15.20.4087.013; Mon, 19 Apr 2021
 13:43:37 +0000
From:   Shyam Prasad <Shyam.Prasad@microsoft.com>
To:     Salvatore Bonaccorso <carnil@debian.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>, pc <pc@cjr.nz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Aurelien Aptel <aaptel@suse.com>,
        Steven French <Steven.French@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: RE: [EXTERNAL] Re: [PATCH 4.19 013/247] cifs: Set
 CIFS_MOUNT_USE_PREFIX_PATH flag on setting cifs_sb->prepath.
Thread-Topic: [EXTERNAL] Re: [PATCH 4.19 013/247] cifs: Set
 CIFS_MOUNT_USE_PREFIX_PATH flag on setting cifs_sb->prepath.
Thread-Index: AQHXKtl3oEpPTTCadkuXKYVCCMdGI6qnf4aAgAACKFCAABQAgIAC7L2AgAYL/YCACbwcAIABHItwgACBRYCAAAUg4A==
Date:   Mon, 19 Apr 2021 13:43:37 +0000
Message-ID: <PSAP153MB04225D4C5A61E003B196570994499@PSAP153MB0422.APCP153.PROD.OUTLOOK.COM>
References: <20210301161031.684018251@linuxfoundation.org>
 <20210301161032.337414143@linuxfoundation.org> <YGxIMCsclG4E1/ck@eldamar.lan>
 <YGxlJXv/+IPaErUr@kroah.com>
 <PSAP153MB04220682838AC9D025414B6094769@PSAP153MB0422.APCP153.PROD.OUTLOOK.COM>
 <YGx3u01Wa/DDnjlV@eldamar.lan> <YG7r0UaivWZL762N@eldamar.lan>
 <YHP+XbVWfGv21EL1@kroah.com> <YHwo5prs4MbXEzER@eldamar.lan>
 <PSAP153MB04224202F4A2BE668533F94794499@PSAP153MB0422.APCP153.PROD.OUTLOOK.COM>
 <YH2EBzOKkg4kGoQn@eldamar.lan>
In-Reply-To: <YH2EBzOKkg4kGoQn@eldamar.lan>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=20cfd1ea-0d45-4c94-b5a5-98f19dca236e;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-04-19T13:40:35Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: debian.org; dkim=none (message not signed)
 header.d=none;debian.org; dmarc=none action=none header.from=microsoft.com;
x-originating-ip: [2404:f801:8028:1:60f6:ca47:5dfc:b1d0]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ce5039ac-ab5e-4a4a-e6d9-08d903392285
x-ms-traffictypediagnostic: PSAP153MB0407:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <PSAP153MB0407B4E12FA10312E06F8FBD94499@PSAP153MB0407.APCP153.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vf5qlAgQjL/q+xj52vVa7z4iQFEXqbezFfa7JMqFKBDdZIahHzag+YAODEKW6hwHlu2cUPM02szdBOhOOSYsyDKvXFGrMmKiY/Dbf9oyWbq0drEMIHFkKeJLlBAWgy0KiL0Fr4Va+ay7+y6PpAPSgtrY86tMlUUVRIq9TUytVljkP+Iys5ozYlRkIocRdEJ6Qn78WiHD8mRf0IYRD/Wn0ey9ZSt/RBfVM+Gbf/xnqNE3NCuMyc6BZtVAIlFjySDBrR0O1esJURDch0uxBt5NP0W2pSgoEXdKqA5vJiFu89ynpRK9R1EaB8oV7MoiAFBDPX6CzbrZZOptsNgbQnn3MvQSrHubaWt0s04c98RXvpioREevc0D9ieeYJsYOECzT4SjBwSjY7fLSpShExk3XG4A8X9OAtLCtOLON/Ycyhgn0QwVTasf4RZrKfCy2XEJCpwsZ5555ilmt8PhV4XZr2gjzT5xNPqotoQVW03oFAe+4CarpC7NImgtSsyvyuhxj03nygRDRha1+eCwEut8vOgXPFlEyXOeXsd+6kldaWbymikjZ7UWDmWtsSllRV19crO8spka2wanhN+0fFuyjo7L4H8Ezbl/7Se3xonb781I=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAP153MB0422.APCP153.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(8936002)(2906002)(316002)(10290500003)(52536014)(4744005)(8676002)(478600001)(4326008)(55016002)(5660300002)(54906003)(8990500004)(7696005)(82950400001)(9686003)(53546011)(82960400001)(83380400001)(38100700002)(186003)(122000001)(6506007)(71200400001)(6916009)(76116006)(66946007)(64756008)(66446008)(66556008)(66476007)(33656002)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?YZ06ZyR4F+43aRWxnVl/nGdkdSEbHsn8Sw52AH8mbmfCh4vVpOVs78t0JtEf?=
 =?us-ascii?Q?jmL6wkric/iSovvHq44namnwgRbVq+hs+Axae0qEJXXDSs+NF04u0+4Ot/w6?=
 =?us-ascii?Q?sVXrL5p2jgEmuDl99/J/etbW2gNCDVbI738iJPi4y5XNvi8HlX7XxNFEqBfC?=
 =?us-ascii?Q?xsOsSKLy/1bxz4SatZWvlDFP1ngQ5DbVEzBuJprIOPgxDHZuVQQ5JI01Rb2E?=
 =?us-ascii?Q?rc9KzIqrUFIE89aMNfmisZgaIfAfMlIzM26UPnZDzzzINPwWZX4mZB5wz7Zu?=
 =?us-ascii?Q?t6G3omOcmmZJMyTKX8uKugnQZNGnMEnTjomR9Nc5d+7/RgiugIu1zMtylBwf?=
 =?us-ascii?Q?FGzGfofWbD1uawTkillfmT7GiVru1Jzqqku8Qg49OsDPIrtoB4mnAGrMduyg?=
 =?us-ascii?Q?raBRhCrFdrgjPcDdXBCBZZqjNe2XlFuaffOsTFzHabLbERrOZXkoqIT4CU76?=
 =?us-ascii?Q?1PrthyzUbVHppIUotTP6pPRYgIEgz1MxQPCl23G1JYPoBqCoSzCaPN2dAVyS?=
 =?us-ascii?Q?rTMRJ+ebI3K/du5iVX7QGTqe/tmQWsjU5F36I9+1Z90Baq1k1fGa9foA8QfG?=
 =?us-ascii?Q?+y8l7nrvK9n8XfHq8B2ZhRaBRIkb6nVCQxwPOJpY699q4q70yng7wFlh3yQp?=
 =?us-ascii?Q?Co4XV6ubUXRfo+Rq2vo3yjYE1QcGLz2gHNC3lY9uqvwjST0yvw1PIG+E+v1v?=
 =?us-ascii?Q?69tiMCla2fbgUD5dVxwBw+gL0exbE0HeBl9xgbTh3ouG6MQTmVRDAK1Mvs/l?=
 =?us-ascii?Q?CbEeB7LsIBmMqTC4XnTrZzLXlSpNKCIeGtFfYplfaGwMZ/2xwatEefbfvfMC?=
 =?us-ascii?Q?lXQ2d7xpvn5Kyd8dJcoLSwxOwbsIU/udHzNJ4N3bATkwJGmshM6v1IIQA8z0?=
 =?us-ascii?Q?LnStBxsMR201T9yo+0HFcxjvTcG0OhGVIU6k7w+ELdKLbjwo+iHD7HgAT0Wa?=
 =?us-ascii?Q?SWMxJ+f6au/CrsiB6Abjixy/N+vWv7R2wdOnoIu7QHCll5VUufhHzQmFdroz?=
 =?us-ascii?Q?FDkvxMtbwI6Q1qJ8Mn73qFnMvVzUpvXpGKOpXoGEOKEEtevBWZlAW+LzC2Cx?=
 =?us-ascii?Q?qm6tSmVpmaEAmoHKGV0XpYomnkrFgmXlqjd2MPIrKg/sB5u/MgOkzbFhCJHh?=
 =?us-ascii?Q?1YaJDIp9cFdsKCAn3K9HhwHaKwI6+sWURP4b83wAKRAfbazCaQc923vtcV/v?=
 =?us-ascii?Q?fvazl+UiT3M3gxDzNeVgSwb/ivDh7Jrf7FXcq6AOClN26xr6Y2ArGgAou3im?=
 =?us-ascii?Q?7U+3Ks32yuH0+D2DnMkXsRVveccD3imxQLYS7b81EijooaUdQ6pMoywuwy1E?=
 =?us-ascii?Q?gc4mbHKfJuFo8VOL+eY0A5AM2DcjoN5zLmiOF5TlgAXdfBxdwOGkF5y74Co7?=
 =?us-ascii?Q?bUv8QAs=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAP153MB0422.APCP153.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: ce5039ac-ab5e-4a4a-e6d9-08d903392285
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Apr 2021 13:43:37.5143
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6+cbPC8kLr+RZnnUI4qGFehhb4OfG1X7JE4e4q5MLJPbe0yciw/NUlCFZcBAGBYPTRm2BOpWvd0HvkelsT979A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PSAP153MB0407
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I think so; Paulo can confirm.

-----Original Message-----
From: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com> On Behalf Of Sa=
lvatore Bonaccorso
Sent: Monday, April 19, 2021 6:52 PM
To: Shyam Prasad <Shyam.Prasad@microsoft.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>; pc <pc@cjr.nz>; linux-=
kernel@vger.kernel.org; stable@vger.kernel.org; Aurelien Aptel <aaptel@suse=
.com>; Steven French <Steven.French@microsoft.com>; Sasha Levin <sashal@ker=
nel.org>
Subject: Re: [EXTERNAL] Re: [PATCH 4.19 013/247] cifs: Set CIFS_MOUNT_USE_P=
REFIX_PATH flag on setting cifs_sb->prepath.

Hi Shyam,

On Mon, Apr 19, 2021 at 05:48:24AM +0000, Shyam Prasad wrote:
> <Including Paulo in this email thread>
>=20
> Hi Salvatore,
>=20
> Attached is a proposed fix from Paulo for older kernels.=20
> Can you please confirm that this works for you too?=20

So just to be clear, first apply again a738c93fb1c1 and then your additiona=
l patch on top?

Regards,
Salvatore
