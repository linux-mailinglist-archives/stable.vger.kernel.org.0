Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8022453FE26
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 13:58:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239191AbiFGL61 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 07:58:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243336AbiFGL6Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 07:58:25 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2097.outbound.protection.outlook.com [40.107.244.97])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DD6D65402
        for <stable@vger.kernel.org>; Tue,  7 Jun 2022 04:58:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=giYLB6l95+PyrZMlOLYs2HXXn5wdF07N9sWfEfZk9f1GajkxT24/tGX6IQouYmD0ttucaInmYp5MLRUyD3GfaSRfhcEWNMiD0B+g8tBdYR8iSadfveSi1JV+VXHcnQm6GRmSPiU8WYXajlI7xwQ9zQJA9dMuXnDt6dyLlrnGx32W+9Uo7TbjWRu73yU06xQI9jpYI+gS6SnzDfGRPcZxlA+seWfcUtQcGyNZvgxCl9ibWQfiAVFszSIsxQo7zL3A2rwzS3Cv4JRkwfpEfhSAh/AOQ30F4LxCpoEi9ylMiLnOx3PiyhGrgnj6Y3WELqj+m2LUMZxyiSzTMudTvBBbJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0TvHtAm/+bTVmJV92bKaIrJr84Ya6u+PloHsnPOZO3E=;
 b=XwuG9VQHWsV03go37tIQekea9OoCoL2gt2raQEx0pVKDsz9jFRMy042vhm2KeUgLHPs2Y6s3RfO+PkuVfZAsaTVaDgzzTaZFoXdBUtwFE2wbWD/dUcrfVIsxNHh67VwR51GoXja3rSrX5CATfRIqgIm1u1c2PcOOU//wGnBcgxFvhxX4fgEP28dhYIfadebj+JxZrW6b5oMx8B2Bn0Ho1+LAr1tq6JAtuzX50xztNncaL8OQSM35/Rw70QM/iAGNKnPoeiw2seh7ycDUdu1SQRMS6wdddMewf91F2SkqsE7kDpGgM3YQFBkVl/lrRjpqkqsUim2fetjczKgQFrmehA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=novatechautomation.com; dmarc=pass action=none
 header.from=novatechautomation.com; dkim=pass
 header.d=novatechautomation.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=NOVATECHWEB.onmicrosoft.com; s=selector2-NOVATECHWEB-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0TvHtAm/+bTVmJV92bKaIrJr84Ya6u+PloHsnPOZO3E=;
 b=Gv8/Moij3iuCsmVyrxY/8cFpUkpp1gfj42g8iuEIhWgUIRCp9ahPnncJyLNSvLK3CGsbqUXKP/xesiTf1EdWX0l+fch0OskMuj6r7g7mq25sssPFYLbnexKwy+pBPk5R2whynC+dxLyRbX7rD6W+Ecxe7mkxKrwHZUket40j7xw=
Received: from CY1PR07MB2700.namprd07.prod.outlook.com (2a01:111:e400:c61b::8)
 by DM6PR07MB5275.namprd07.prod.outlook.com (2603:10b6:5:48::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.18; Tue, 7 Jun
 2022 11:58:21 +0000
Received: from CY1PR07MB2700.namprd07.prod.outlook.com
 ([fe80::a9b6:a462:eddc:cedc]) by CY1PR07MB2700.namprd07.prod.outlook.com
 ([fe80::a9b6:a462:eddc:cedc%12]) with mapi id 15.20.5314.019; Tue, 7 Jun 2022
 11:58:21 +0000
From:   Eric Schikschneit <eric.schikschneit@novatechautomation.com>
To:     Thorsten Leemhuis <regressions@leemhuis.info>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        "rmk+kernel@armlinux.org.uk" <rmk+kernel@armlinux.org.uk>,
        "grygorii.strashko@ti.com" <grygorii.strashko@ti.com>,
        "tony@atomide.com" <tony@atomide.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>
Subject: Re: [REGRESSION] gpio: omap: ensure irq is enabled before wakeup
Thread-Topic: [REGRESSION] gpio: omap: ensure irq is enabled before wakeup
Thread-Index: AQHYdc+tWv7aWWd/6kGN6rTOpeTdya1DwRYAgAAebIE=
Date:   Tue, 7 Jun 2022 11:58:21 +0000
Message-ID: <CY1PR07MB27008E7B556EF9ABF609F85081A59@CY1PR07MB2700.namprd07.prod.outlook.com>
References: <CY1PR07MB2700E81609B0967127D0773381DF9@CY1PR07MB2700.namprd07.prod.outlook.com>
 <cad76252-ec94-779e-aa31-b487526a2154@leemhuis.info>
In-Reply-To: <cad76252-ec94-779e-aa31-b487526a2154@leemhuis.info>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
suggested_attachment_session_id: ecdcf95c-8542-c970-6823-3f03e8c77a4e
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=novatechautomation.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 14abd797-c888-4994-ce27-08da487d04b9
x-ms-traffictypediagnostic: DM6PR07MB5275:EE_
x-microsoft-antispam-prvs: <DM6PR07MB52754FF73F255371EA22C5A181A59@DM6PR07MB5275.namprd07.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8kQ4w86fQjogkDz7zW/k19yrrB1JZaz2siuowuDr94sPzArJa91ArevADcNMBcPYxlvgAXSZq9zR0EKQQ1PwHmGL5fJOfJToeeGdWmt21PwiPEAIJXgS+S8uNxkxo+iSIo6l2snl5vqk7rCTqB5OOCHZpqWZ02mpao606TKOwOANP14wXbUhpZ0znfOcNp8zTgfPiDxX0W2RO7TWRV/uNYUpf60A9zItKUNS3UOOlPvoQPXB8wctA2YJLo7Exen/tKknLARlTfcCmB/JcOXx/vqd6Z7M6uEQsLRkWwQM1UrXnATeR4jIlNXC0/GBovfLoLoRvlWBVOx6VCOt5d2W+NQSZH+MJYRpg50frg9keSH1ZbD0lQPjekR9en+Am3FQnXsYNFSKfkPQkRFpqo12GEDlPksnPKu60SyCf6wNErI+IHR/CsAG4t4ZPpOTP3e5iCcDUcmxnyPtPlMNqoZjxt/kyQsH3e3SpwmRnP8gea/eQCXBqCwwxrQDu7GoMdcbnYLYAL5EPXufuqkKQiyyc+jE+SDO3bu8+tu9qJajtqlpRW8aEGuNJ6WFrkqT26zlwCYHtm+dv9CoRHDOsz6pJ8rI1O/fhSYlOFBxsLE8uAk2EO3CcbQ9aUcnQawovmw3FSHg09/grIrO6gu8x4XNHgO9fp533+PxNwocWwYJcLxi2xB7JFYAq9X9i42MuNAXuoLTNP9nSOzWe/91zu2MFP5GPP9g72RygyXFsqsDZ+ux7MGINiRV3duTXF1m2QRWksf+d+ptwOpWi8pFGA5pYiyFsL9rBJJSVY/h/ao8r7M=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY1PR07MB2700.namprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(396003)(346002)(39840400004)(366004)(136003)(52536014)(122000001)(8676002)(9686003)(66476007)(64756008)(66446008)(66556008)(53546011)(4326008)(55016003)(86362001)(91956017)(38070700005)(71200400001)(508600001)(26005)(2906002)(966005)(6506007)(8936002)(44832011)(7696005)(38100700002)(33656002)(316002)(66946007)(5660300002)(76116006)(186003)(41300700001)(110136005)(54906003)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?sAMj5VBnwJFzeNuu+AMXKKH2EABhD4ShDbTdrNShYxNXcThHPf0Yr1GSXx?=
 =?iso-8859-1?Q?8xu5K6tkwbpZa3hQBBWv7FQHs8v5Gp8ObI8cZiIoApPr8ST1jwynLbuymw?=
 =?iso-8859-1?Q?0mIE91v3Nq9ZwxhcPnbFqNzI0/sXhPinWnx/UHexl/3N71cbDow7qJy+J/?=
 =?iso-8859-1?Q?QItLUUkfoGmGr2/bIfojiqSGrvfeYpW37zZfjmrzGrqLisolgaE21NVK54?=
 =?iso-8859-1?Q?QLn9KSE/OeLxLTBXFwBkoXqSPG/K89GvDQ0AnXZTkwwqWD+Hc42I0V6fQP?=
 =?iso-8859-1?Q?YdSGD8bQkDJDPNPJ/6U0A8H1ue856jP3spxEE3NSxMS4Pe1wKZp9vAnIN2?=
 =?iso-8859-1?Q?JWaj1vQvM2Ny4PUxgSDdmAWf3fuC6XuU+Y+ZVgJt/NJ1xVj446SBwjsgjg?=
 =?iso-8859-1?Q?grdLNrF/COWQZjUV/xm9DRnaQa8TqkT0+A1HofgAJ4i4i44/uGMt+61SoO?=
 =?iso-8859-1?Q?jRsvUs0HZr9TaDhYkqdp28WeyzGhH1JRx37AbDYzPZ8F+tOKeWJocctOEl?=
 =?iso-8859-1?Q?frMyaZHMihrQWOYc0Sg9OPR5eDA3q9J4b5EfHcU2WtAPd/+zYRq/KRoLfZ?=
 =?iso-8859-1?Q?iIJjgSs9BjO9OUugADOTCt4wwfHR9vmZP0tLAooMjeNVUvglYah0PYM9X+?=
 =?iso-8859-1?Q?VX9tv7eBGVOzPExcoAYAaqlbyx/V5ecFq7MvN6tH4j8At7DOg0uYMazKjj?=
 =?iso-8859-1?Q?ioI91mEa5mTwqcRN4bzacZY/Djz37P/t1aB5Op66RTpuza+JL8G8iXrb2E?=
 =?iso-8859-1?Q?FJB55PuT93iu1tAjPF4O4OxPARvjobA2v5bkgtZrg8aqqSrh90zzedGG5F?=
 =?iso-8859-1?Q?v2sc9EZZEVunsweOGTrW7gBcyJ16SCwLfFb7GCJ+yzuWl1cidWh9T2PwNS?=
 =?iso-8859-1?Q?Xyw0wXWLNcO0QOxLXIRcEGmeJE0Jn+6Ix01SqCAWXtM0fFd0gjbV/SXMy1?=
 =?iso-8859-1?Q?JfvkpWlnsTcXvcDFuj3tkqq8BTVWi2S9c1ncMbmtVvTY9R3Iy61ZHSEk3v?=
 =?iso-8859-1?Q?yXW+8Fhlev2/f4JShJeinxWtBCUWIY6P0uH/tJnCqJUTVbKGh6R9xog8YF?=
 =?iso-8859-1?Q?tPAL5EC0n2ratpiTDLsjY7xZw4sQy7HGY6UdzDl3dJaHqcxAPT1pgmBQVi?=
 =?iso-8859-1?Q?fQykH/wBuHOciqT7beSMyoQ59roRpX6rf3wYIH/bWNmj44nfdM9FnysGnT?=
 =?iso-8859-1?Q?XjM0VcDWUeg6180hgZDKo52KKFzEogi308yd0RvYIb4zTfyYGRsRVvtMHw?=
 =?iso-8859-1?Q?HZcHssrxeaL8FhG0m/QBfjlaasntU7VJ6SL8bXdMju11ENLyHX4sXOfZnQ?=
 =?iso-8859-1?Q?Ja2bf37ni+A2coRHpQ0XCnRFPGPm+oIARzsJnynYkLy5KmqcG0vKnk+nmK?=
 =?iso-8859-1?Q?ou0d6fsqSYP/wKPVDCsoOaZVcjXZKwCIfYuD30rrVQp/EaBpjIi6XbavFs?=
 =?iso-8859-1?Q?wnBfxge4U0J6IK2TvhvjpaCNrU109jTP/Ri5GHP3S03s6Mc0ecvaAdy3g+?=
 =?iso-8859-1?Q?jqqbCYbJIjJ2VUfkLGxKo1Ohl8ScaijxN2+vZBIIep0UAsq4ck8+YQPLI8?=
 =?iso-8859-1?Q?VP6SkigCfw2kXGz2lwQAhC2a81A+SVM/uEVHggw9mgRx7ntNU0IU+igl0v?=
 =?iso-8859-1?Q?L8C63IgnfptZ4yhFBxwIRCZahyaRYfnjTUEXKuABuSfHjogNf2lHQQLdrd?=
 =?iso-8859-1?Q?9UDmJBeRcvnBATwkc7Stz7q5Xe+hY1vkSQqJNBpiOr5nEm0vTn/jEUZ61u?=
 =?iso-8859-1?Q?03m5BK4ZBIGhqKF6LloziI+D/mBMfc+yfm3dyPVpwakiBS0FzaFg+ImfHH?=
 =?iso-8859-1?Q?5LoJb9dHyX8UoS9t4wPE+S6FxIKvDsycooe23flamLuECBgD46fu?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: novatechautomation.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY1PR07MB2700.namprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14abd797-c888-4994-ce27-08da487d04b9
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2022 11:58:21.3431
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: eb0f6598-d3e5-4ff3-a8b8-fe893d304059
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HEre/UwSQf3i6J0VoHGUukPrx1ezd/zsIeDDcEMVpLowVxJ61TBaci4Uemh616OeYi//Hr9+tSlQq6eL0E52Yj50X7OK2FLFy/QExMOqzqKf2EJ3iT9cHz0pCBWY7+sHOQMvWyc3QZK4eyUknd5gEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR07MB5275
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I am limited by the availability of the preempt-rt kernels that are =0A=
available on the yocto project. The newest kernel I see listed is =0A=
5.15.44 on: https://git.yoctoproject.org/linux-yocto/=0A=
=0A=
=0A=
From: Thorsten Leemhuis <regressions@leemhuis.info>=0A=
Sent: Tuesday, June 7, 2022 5:07 AM=0A=
To: Eric Schikschneit <eric.schikschneit@novatechautomation.com>; stable@vg=
er.kernel.org <stable@vger.kernel.org>=0A=
Cc: regressions@lists.linux.dev <regressions@lists.linux.dev>; rmk+kernel@a=
rmlinux.org.uk <rmk+kernel@armlinux.org.uk>; grygorii.strashko@ti.com <gryg=
orii.strashko@ti.com>; tony@atomide.com <tony@atomide.com>; linus.walleij@l=
inaro.org <linus.walleij@linaro.org>=0A=
Subject: Re: [REGRESSION] gpio: omap: ensure irq is enabled before wakeup =
=0A=
=A0=0A=
Hi, this is your Linux kernel regression tracker.=0A=
=0A=
On 01.06.22 17:56, Eric Schikschneit wrote:=0A=
> Summary: OMAP patch causes SPI bus transaction failure on TI CPU =0A=
> Commit: c859e0d479b3b4f6132fc12637c51e01492f31f6 Kernel version:=0A=
> 5.10.87=0A=
> =0A=
> The detailed description:=0A=
> =0A=
> I know this is a old commit at this point,=0A=
=0A=
That shouldn't be a problem at all, but it raises one question that=0A=
would be good to get answered: does this problem still occur with the=0A=
latest code? This issue for example might have been fixed in between,=0A=
but maybe the fix was to complex to get backported or something like=0A=
that. Hence it would be ideal if you could quickly give 5.19-rc1 a shot;=0A=
5.18.y is not ideal, but will do as well.=0A=
=0A=
> but we have observed a=0A=
> regression caused by this commit. It causes improper toggle during a=0A=
> SPI transaction with a microcontroller. The CPU in use is Texas=0A=
> Instruments AM3352BZCZA80. The microcontroller in use is a PIC based=0A=
> micro. I have logic capture images available to show the signal=0A=
> difference that is causing confusion on the SPI bus.=0A=
=0A=
Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)=0A=
=0A=
P.S.: As the Linux kernel's regression tracker I deal with a lot of=0A=
reports and sometimes miss something important when writing mails like=0A=
this. If that's the case here, don't hesitate to tell me in a public=0A=
reply, it's in everyone's interest to set the public record straight.=
