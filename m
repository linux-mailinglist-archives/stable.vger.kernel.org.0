Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7ADC60CC87
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 14:51:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231310AbiJYMvj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 08:51:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbiJYMvB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 08:51:01 -0400
Received: from CHE01-GV0-obe.outbound.protection.outlook.com (mail-gv0che01on2119.outbound.protection.outlook.com [40.107.23.119])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 436E619ABEB;
        Tue, 25 Oct 2022 05:48:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fPHBW266l2E9Y0x21SzGClZpmiiFu5QvEeICSw4Z01s7tACoNOowV+xyoPyE4omGMUuOJp/3yST3MFxR5frl8z9pxd+hUe1GOM5UqNEGQlsjB6ZBIwslSJO9s+I5pWwH7JjEIUXHltBy1KRNyFHz79J7SZnH+riCzjHWN9nV2xrcYyW2vjMSCdROot7rGUYxnEnjCJcc34l5Y9ptF/KG9YOrtzMYZRrFFh48vCGEmwsO8Y8EwXFnvpLCunOmUGKNBvzacDk2HlXiWsc44YUyJI1TG318O8v4+AFYDB5N6ollmd9VcJ1e365RrOzI2jfl4+ddplf6Dg0NJgTVjfJD8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mKFdyLGf6O9cFTgyQOP+mG7uzjJy0J6nCm3N7G5+izI=;
 b=h4l5ktM5BhijeWteXnNQ/bwspY/sacVcFCceWyA5+EBPli4N6dqMEzxNNZKyj87cDSqtt3vnftkTsPCtuRE9T8BMQevVlwNR2zVDvtMX9rObrpZ7Wb2S+6xRBxwp+M4ayyrM+97pV+U2pdm5IAS/Jwm6imFAcbziQYzVwW+BTFJP5mhkl0IES/sp91pAIPVAiJDnCY6IwfuTe3G/bgV/X0PN34g00zAAUzCFRdn1CApaVlDNL698gDuY/n/vdzJET1LxXxOnzMPnUtFjJOjdmHhzpy30uouJ4rcKapuvo9CgbuPWkN8Gf/7Fc+5upjZ0UDYh0q66qdIbEg3VxAqiNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=scs.ch; dmarc=pass action=none header.from=scs.ch; dkim=pass
 header.d=scs.ch; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=scs.ch; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mKFdyLGf6O9cFTgyQOP+mG7uzjJy0J6nCm3N7G5+izI=;
 b=XonBmqiuXwwiySZ9topSx+oV5reCQcUr6Pr1ZaoETjKgs1aSC7Ng1PumvJ3qSnwnlR3FJFFUL+QhPZgDMC4iXrN5qUqWyWydH0K1TRU23cSohLB/1WikLScA32EQXFyVJQwOEGDzRXr9/cHZCFSDhSbwysslTrsiDbq+iuvKXhGG7SGlk42fraxhvMIjPbKe9/4a5/cFJpTHGn1DPUyqRgRZBk3Cnenyn7uWVj1QCbHCOWdp/mmUEAIWX6PEIEZtQ1SfwgfknCMEYGpOLnbvy76qSs7JIkEu97OguiDK9EnJfvR7XXAPMP5V4noH/63lMn/dA1Izfxc+QkzG6r7rMw==
Received: from ZR0P278MB0773.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:4d::10)
 by GV0P278MB0854.CHEP278.PROD.OUTLOOK.COM (2603:10a6:710:51::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.28; Tue, 25 Oct
 2022 12:48:27 +0000
Received: from ZR0P278MB0773.CHEP278.PROD.OUTLOOK.COM
 ([fe80::a72a:1fa7:a789:4222]) by ZR0P278MB0773.CHEP278.PROD.OUTLOOK.COM
 ([fe80::a72a:1fa7:a789:4222%9]) with mapi id 15.20.5746.028; Tue, 25 Oct 2022
 12:48:27 +0000
From:   Christian Bach <christian.bach@scs.ch>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        "linux@roeck-us.net" <linux@roeck-us.net>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: AW: tcpci module in Kernel 5.15.74 with PTN5110 not working correctly
Thread-Topic: tcpci module in Kernel 5.15.74 with PTN5110 not working
 correctly
Thread-Index: AdjoVYnpyrmyLmxITSiX1bJ23H/1egAFm5rgAAClgwAAAA5FcA==
Date:   Tue, 25 Oct 2022 12:48:27 +0000
Message-ID: <ZR0P278MB077321F8565A4FF929B132A1EB319@ZR0P278MB0773.CHEP278.PROD.OUTLOOK.COM>
References: <ZR0P278MB0773545F02B32FAF648F968AEB319@ZR0P278MB0773.CHEP278.PROD.OUTLOOK.COM>
 <ZR0P278MB0773072DD153BA902AFE635AEB319@ZR0P278MB0773.CHEP278.PROD.OUTLOOK.COM>
 <Y1fYjmtQZa53dPfR@kroah.com>
In-Reply-To: <Y1fYjmtQZa53dPfR@kroah.com>
Accept-Language: en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=scs.ch;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: ZR0P278MB0773:EE_|GV0P278MB0854:EE_
x-ms-office365-filtering-correlation-id: 16c596f0-3590-4225-c4f3-08dab6873623
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ja4dYpKZ2DAXczfIb9aVL+YOzw/tps7yuNYRtGqUP3kQvUWkq3tHhwsinQHPLTPjNzZ1rJ78XDYxmlsYklKbjiEUInVFP/+UERD1BeTwILg31wpiBfzFIMf0i7IS1mhtmKYVrTQ2VcjHiAp20Ne4TtwSFabBJwq/G58QzDxGepVcDUgCM4Af+YZ79JZZN80xDKuTQAKu/Dkpg3+5Q5H3MiAfySB2nzJPFYu5mOku8FMNqIBhkplqq+AvarITkp05kV5W63Sc6SsrF8Gv+u7Iu6NVmP2vj0bHWHSq4f0QHEHBUgOiPN65nOHz0I9vmcZf8DsUGlBEbQ3Pn3scE1+CSaThWetguCoPw+tdPvnLYG+Ig5Eeyzvuw8RL1M/VHCSolOA8+BBTyeo6KBBe4xJxjnJM9kZnLgXOMSioLfVc/cVQreTjNOPGLkyHkkpwC3ANVWybYhaHnHGM1JbYFdeIOhHtXXsuV9cuUO5D4VC7NhJAWeqx5Rzdr62Ij71ROyCCZZ37+xzzETdQaxwEfheAgBJS+kDkpSXlOIbsW21xPlf1S7wxa0+ZwHVzMbe43XGW/aBMuJyw1xdLoEpbTYOIl3bs6HDRbxMg2BqKxe55Ir0xt5P1FZ2zOHcOydnhS82U3CKIl32yDF2jRglai+3xgkYzVQmh0EyZQFKrjo92W2Zf7XyWdV6Yr9+mBDwsy0L6z1upVbHqB/EKFkiFoUCPw2J2loV7WCHB7bzVzuEOE97DWMq8+YhVPNAnBljaA0iPjOkAvxf8BOXn/Tq854S1jw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZR0P278MB0773.CHEP278.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(346002)(376002)(39840400004)(366004)(136003)(396003)(451199015)(66574015)(38070700005)(33656002)(86362001)(64756008)(66476007)(122000001)(5660300002)(8936002)(66946007)(66556008)(76116006)(52536014)(66446008)(8676002)(44832011)(4326008)(7696005)(6506007)(186003)(26005)(9686003)(54906003)(6916009)(2906002)(55016003)(316002)(478600001)(966005)(71200400001)(38100700002)(41300700001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?iRllOyYagO9DEMdHJVD4zgHzJGg4SS/iXvkydgD1AezPLcI91TjVtulYWh?=
 =?iso-8859-1?Q?S+hTjEaI4h3byajLRgcKjgCisswaOJh0w02We40vEgUp6b7JkG9aSSz4RY?=
 =?iso-8859-1?Q?E8U6wCCzsPpqagxod3iKCjwAwW1QhhTIjQWG4kUtutX3DBqxwpwG9kD940?=
 =?iso-8859-1?Q?pdmQQOuWuvR8CJmymwX734CAXgIAEYp5HRepK/h3c41SMJbqDOdZsCjIpT?=
 =?iso-8859-1?Q?PrMc/DRg/xKka7/lra281Co8XYTEFcSrHX6YBHjSqm96kTc7x6K+4EH8XX?=
 =?iso-8859-1?Q?2yzzy+Gb3OJF0xPGWkXI6A8S4YxXDKUg55Sibgm6G6oAm/v9QC/RWOmJen?=
 =?iso-8859-1?Q?N2lP/hIb0v9Ip8dh9UOV5R1jsnfADUWfZDeT4tazUesEnZNBqnT6wmUywj?=
 =?iso-8859-1?Q?cI9oJnnZF375/fZ8/wp6mrTOehBpVZxjYNrSx7iInKft95zuWnF0Tmsbyh?=
 =?iso-8859-1?Q?vQ2Tx0s3klD34dkiKmGGEj3Rd9Ucm5Eow8TojrLaE/qlhRRNHXTcfYqX7H?=
 =?iso-8859-1?Q?88unsHXB40ykP26RgSRF+l0kqBPikSjJ/UHtHNCLOtqlI9vFTzVhCqm0bB?=
 =?iso-8859-1?Q?TeGT/CkLhqIDwPqh6ycdHmS5VZA3Nsyz7ZaO7VPLdmMgA5zV5oQ/Zp94hf?=
 =?iso-8859-1?Q?Yl70huIJd3BHK3JnFKxWwQIB8iLFCtEX3LohDXR7zPbI1Ehkb7yrMG90LC?=
 =?iso-8859-1?Q?lYU8joKIEbqL8g8X1BzFjusm8vSBqGn3AQjnESCXzju0NwFxjq3o9kzrQM?=
 =?iso-8859-1?Q?aLha8YfD5VfyLZoG3YOy25TXRnXHRbgUcOzpvcbL7eTmkyhEUx80CkWShv?=
 =?iso-8859-1?Q?26SaMuPtTgiTCoqMwgT3Bd3BpNcZZouRgcwf8N8ew5vLT/OycrPteOu1me?=
 =?iso-8859-1?Q?76jE8foSZnsisft9uFBK51XX9Fh5ABi574RRtkIs8YwXB1nzl01nvQ0AgM?=
 =?iso-8859-1?Q?dZE89PyqnOQgKzyDVfAwzgR1FAjk4q74I6RtF5ofF4ICGA5sHoCqRkGSx6?=
 =?iso-8859-1?Q?xCmnAeDnde+aNAWQcbjL6Be5V1YVxbqz2o+7AsXAzTmPRa6nxZQG28J3OS?=
 =?iso-8859-1?Q?2EwqXwlszIQKFzJmE3+KNjC+EPL4CjXdbH+wa5mV6koLsvo8UFfqv4K3b6?=
 =?iso-8859-1?Q?bVO3XWWtTgVk2pFSgO+4P+WPiwd73XNMvFC722PTaAjqs2kZFLCLxgZQ8E?=
 =?iso-8859-1?Q?rHecKfGR6s2Ff24GIqlxQDcTd6DBV5PybbJT1Mq3TQKSXJm+IEFIhBR2jV?=
 =?iso-8859-1?Q?s363r46YV7sbc2YwXsN9pwJjAk+hG3gbaGFiRB58LPEnoOWgKrwwj6hyfR?=
 =?iso-8859-1?Q?4p4rDkC+Lit3v54VMvj3yli3t/EQPcfJ9dUhV+OrI9QKo/WITa2NEotNzt?=
 =?iso-8859-1?Q?iQ3G7WYUyZwLOVg2WBkw0+5qoJq78Dl9Nuv/el/4fVuXOePCTo1m+205Lf?=
 =?iso-8859-1?Q?j9b6O4iFhSlLLa4OkFF5Rmw2pqsw4UInhjEeHZOXST8bBeUEbBYMaWPEqi?=
 =?iso-8859-1?Q?ovbnc1uGjcMkN7KU87aNYoZSVLJpPLwSkSclOwKl3JNv2MMkDufc3JiHu6?=
 =?iso-8859-1?Q?3yYa2G+eaWjfSQaWD0KADZON0DOjemoRBQcUsV7BpFGKyIPKGqdPCplB1h?=
 =?iso-8859-1?Q?P/3tjFY7DdcaIi53WQ2CiDK3ze7L94rVCZ?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: scs.ch
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: ZR0P278MB0773.CHEP278.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 16c596f0-3590-4225-c4f3-08dab6873623
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Oct 2022 12:48:27.1344
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 1b8c3cb6-94f9-44ce-91ec-7183fd2364b2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LQsqBPQbU8sEOTgq+o56mTf2QCzahBUp3gFyuVRBHZz94TZde2TCy/wCu0FJRmUg4o7v5kEXEk9LLSetAQNqgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV0P278MB0854
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Thank you for answering. I did try a Kernel from 1 year ago (11. December 2=
020 - with the Hash b5206275b46c30a8236feb34a1dc247fa3683d83). But this Ker=
nel had the exact same behavior.=20
I even wanted to go back further the when the tcpm module got it's own subd=
irectory (v4.20 - 20. September 2018 - Hash ae8a2ca8a2215c7e31e6d874f730380=
1bb15fbbc) to see if it still worked at that time but my build system was n=
ot able to build it.

-----Urspr=FCngliche Nachricht-----
Von: Greg KH <gregkh@linuxfoundation.org>=20
Gesendet: Dienstag, 25. Oktober 2022 14:38
An: Christian Bach <christian.bach@scs.ch>
Cc: stable@vger.kernel.org; regressions@lists.linux.dev; linux@roeck-us.net=
; linux-usb@vger.kernel.org
Betreff: Re: tcpci module in Kernel 5.15.74 with PTN5110 not working correc=
tly

[You don't often get email from gregkh@linuxfoundation.org. Learn why this =
is important at https://aka.ms/LearnAboutSenderIdentification ]

On Tue, Oct 25, 2022 at 12:19:39PM +0000, Christian Bach wrote:
> Hello
>
> For a few weeks now I am trying to make the PTN5110 chip work with the ne=
w Kernel 5.15.74. The same hardware setup was working with the 4.19.72 Kern=
el. The steps I took so far are as follows:

That is a huge jump.  Why not use 'git bisect'?

Or start with a smaller jump.  Why not go to 5.4.y first, that's only a yea=
r's worth of changes, instead of 4 years of changes.

thanks,

greg k-h
