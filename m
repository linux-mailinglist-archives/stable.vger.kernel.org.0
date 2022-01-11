Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4083848A58D
	for <lists+stable@lfdr.de>; Tue, 11 Jan 2022 03:23:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346572AbiAKCXc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 21:23:32 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:53843 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346562AbiAKCXb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 21:23:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1641867811; x=1673403811;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=uEYeXGl5hr9XiQL/BYTjoqXCXfxqPkgHvATLC6ovQSA=;
  b=n2AtY37+f7qyqewaSXPQ5VZDkuVpvSZ17nqzX/9+yZ9/ehTdCgMI6Dx4
   Re0rEjoPJlWuGrFtRZcCaXIYRDc7gIVvJ2IroPzyJwXOvu1n1p6tHOem0
   8dFbBm14cqqy75PNpKX7UGugmPzu6iFq71ewDRdAAeHN85ACRGfvaGm0b
   sksaj+ZwEFFV/9pheJHpWTphRzoYWHg0aE/SUbcaEZxXg679dINn5ipyR
   wqbZcjusA3Hlxd81eAOhfl8Sa6TX/qpoMBj/mf2AUoxrqpFXExx1tyYUu
   9ESPqdOolGUMTIDHx2Jh4AC8bMdTreFy54i1zvuMm9quPSRoatIK75i4E
   Q==;
X-IronPort-AV: E=Sophos;i="5.88,278,1635177600"; 
   d="scan'208";a="190147790"
Received: from mail-sn1anam02lp2046.outbound.protection.outlook.com (HELO NAM02-SN1-obe.outbound.protection.outlook.com) ([104.47.57.46])
  by ob1.hgst.iphmx.com with ESMTP; 11 Jan 2022 10:23:30 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ta5Mlh068Z9zz8y+MBXu+5LBAL8QSdIVjaiLabcTsV7C534vkIApvspc+NKsK9aC6l3bWRHy4KxQZ0RBUWtxnSRHQOQEqcP/h7XPAauhI0kLbC4bckSyGcXhjZW1GnugjcsYa/hn2Yjj5kYA5gzqxdEjomyyy4muUZvj32CHZGnmPlNex+OypzKS1qD1Vm7HsUzhTDeUW2RQTI2ZTI+wh8Bt+p2lhlVX2TK4/mhjJ2ZySELgStqR1EOvIydsYxYtB6F7zI8OILztVKW+MGufWYylGyU0tf9eAJiGuYiqV0DSh/AEAStxUPLeX7eGBwZ8/1NdhMXvmj2JrqUEyqI4sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uEYeXGl5hr9XiQL/BYTjoqXCXfxqPkgHvATLC6ovQSA=;
 b=R2gAHhfy+nmpww+0yXxcRAznAyp4rIgA2yDRIDpwKUt+vbZA8WrXalUfg4r64AcDMj5NQR0OrLHlezRbIhD+IkEW8Y7/vcB8Ilou7DsKzxvy64P54YuEL64G6XlJ32JLqY37QO4MdVLujnpOWy6tOYSLu3838MNYQTMj8AzaI/PvVqG2zsrJYbTbylzCv/wtiO3Nja0flfcQcHiHmaoH40v/kM/56Ji7Z2xzfHedW6arS9vKx4ZqLg0J+R1eg5k05/QksMexcw4CrjaCx/MdLZjCzEB7AYrCsZsIs5Fc18WzAzTrVK1KiuL+9ufdIJ9blr8t3SSRRjcAWMD39M7otg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uEYeXGl5hr9XiQL/BYTjoqXCXfxqPkgHvATLC6ovQSA=;
 b=d91xgbTQJIgTNHnVeoIGG4O7wQDPLBZkZ6w/a2FMO4gaQ97JgQk+Fzhez8zYJL6KSAY3X3nf/jjUxOJyRyiMhpW3tKs2ikm0TU5HhHtnK2kHMcVUUP079qT23mFfUD8f2/TI5pZEWic4+zidbMd3Xt7UJB2IMGzV8+SHgtWdTic=
Received: from SJ0PR04MB7776.namprd04.prod.outlook.com (2603:10b6:a03:300::11)
 by SJ0PR04MB7773.namprd04.prod.outlook.com (2603:10b6:a03:302::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.9; Tue, 11 Jan
 2022 02:23:29 +0000
Received: from SJ0PR04MB7776.namprd04.prod.outlook.com
 ([fe80::7067:b7ba:4fdf:d3af]) by SJ0PR04MB7776.namprd04.prod.outlook.com
 ([fe80::7067:b7ba:4fdf:d3af%5]) with mapi id 15.20.4867.012; Tue, 11 Jan 2022
 02:23:29 +0000
From:   Naohiro Aota <Naohiro.Aota@wdc.com>
To:     Jiasheng Jiang <jiasheng@iscas.ac.cn>
CC:     "damien.lemoal@opensource.wdc.com" <damien.lemoal@opensource.wdc.com>,
        "David.Laight@ACULAB.COM" <David.Laight@ACULAB.COM>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] ide: Check for null pointer after calling devm_ioremap
Thread-Topic: [PATCH v3] ide: Check for null pointer after calling
 devm_ioremap
Thread-Index: AQHYBpI4LXUhzxHhmU2uDl/BQMgWmA==
Date:   Tue, 11 Jan 2022 02:23:29 +0000
Message-ID: <20220111022328.ynoyoekjwwf6p2vw@naota-xeon>
References: <20220109140142.4081651-1-jiasheng@iscas.ac.cn>
In-Reply-To: <20220109140142.4081651-1-jiasheng@iscas.ac.cn>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0d02d701-c42b-4024-6b26-08d9d4a95b60
x-ms-traffictypediagnostic: SJ0PR04MB7773:EE_
x-microsoft-antispam-prvs: <SJ0PR04MB77730AA799759533A1D1B33B8C519@SJ0PR04MB7773.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:119;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: v9jOAzapF+xZX9IlFkThtdBOcroimOAMMRQ3YALJBhL+CeCevE1D/ftXw0gMseYc22iK7BR5oehzcjvoWMeukivQl8eZz8PZ8yCkpuhHA318s/TSuBQlZ9J9JlfqYaIU/JXO37LlKKJWLZMJnOYfIUohfsZZli8b7Ut9v2l85AkJZW0Yj10iXj+rrFfu8yKA/MLIhJCQMd+YKhefkH/W8ypOZwRvgwAbOTmvKCc2B4vyY08FM3y2YnvyxUjI0O9yoPez9eVYbHAxwclaR1dasVdwehrQFspwtCZwMr8GagsCxDLfbeHEkE79UcDtoDzc0J6DodiJtdxZxHHxLIuPIf/FMZyHeVX+i8ZLM/YAORVv3ttUuGd7yk8ySbf7tBjcfDJ8UIxLPrJ4PWKoZjOus2fhj8bN96cLOjO6In+Y0rD1H0wlHbo+TDnFBf0DLP8t1Ua4YS4VoVS0mztln6FdYB5CM3US7uT9ugqlMFDnn/94sB8xt8TY/avaXdAlZPJoVjOQCGRhDxkFama9in5pTmEe6ukd6B6jGP0KWWhSJYjunbcfy3sO5g3do4NwtFKPhONG8IxwN+0Iu7b/eSnOSH2tIXNjF3TgKsfOKHbu87sQrqaRH6HM85VEe1ZVPeFRA4wZnIRvCVRwHeRgTOAkKT+dIIfU+i5Ob7Tx/iDRlYRZ8jfMKMqsGSjzKaHqW69NrWqAwD2ugO5Kd/Q/iP3eNw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR04MB7776.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(366004)(6512007)(38100700002)(82960400001)(86362001)(316002)(1076003)(6916009)(8936002)(5660300002)(91956017)(6486002)(76116006)(8676002)(9686003)(66556008)(66476007)(66946007)(66446008)(64756008)(26005)(6506007)(2906002)(508600001)(186003)(54906003)(83380400001)(4326008)(71200400001)(38070700005)(122000001)(33716001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?QixOCfbuE8Crt/ECK4fQAodmkU8lQvDKkBxUmpovJ+g/Q7oqqQE8552kCDKW?=
 =?us-ascii?Q?CljGlDXtE0rpI9Xg47mBnF6MMh1hkyF8Wa67CdD0AN8my0CsIWO5q8pMFopW?=
 =?us-ascii?Q?s9yy3zAeu/0eQuTfi8/stv/xOhGz1aVzY39r+ALsXF+y31arxPbaMx/7vIwS?=
 =?us-ascii?Q?ZqtlR96dpN0qesutbMIcBg1ko17OHUcpB4JdYuzs18NytbTMpwvJ7ASGFWje?=
 =?us-ascii?Q?61HOOt8kAQMtcnCKMHV4ZOQCHhZCM9eNw173RsvzmdU8NLRqEbpIdJ/oVMgv?=
 =?us-ascii?Q?JtcwnYekmBsQEPtfiJ8vI7MQdG8gwnhj0EJ+xRfNufqcdEKHJlqQI6FISoCe?=
 =?us-ascii?Q?2X5w/rHuQ2vwFGIGSnuw/Nlx4YlS6VTaajoYElGeZFKhtefrcKlLFsJaGPjO?=
 =?us-ascii?Q?bKYvMmAYzbAAVUIStOio7NNYusmWbOv0s4oMrE3Mp/TospcNdJPPScDz2z92?=
 =?us-ascii?Q?L0MwaipOdLmnZpuiY56193lx4svrCfIcbpoUCcfTbFosgDT9VTv3Er/xnCOJ?=
 =?us-ascii?Q?A/Wkjj9WgPDW7Zlzo7BA6xN0YkhxPUbELHy/X6jntoiGafJwO22es1O6OUjn?=
 =?us-ascii?Q?dvkgkcPv6uW6SpxKpXj0alKE286s4O9ZorW4EtKdprMM4TICMCd6MUjEPxaE?=
 =?us-ascii?Q?/m2g8HniOAwlV2i5iMG860PhiSkJi3tH5ixrGu5uCaS2qprZSClFP+3lxxMJ?=
 =?us-ascii?Q?WoiZ/n+WFyM+lghu13pmGpTXKrLa+OrHBSONDwPYfoOr0FBLCLsTFLAazT3o?=
 =?us-ascii?Q?gYInyuzRFraI1cY/cUAcZLGeFsVsDQ6PYvAMyUayXF4XwSP1AYo9a50JDG52?=
 =?us-ascii?Q?HwiWx0LGHukApelXg1SYZ3s0lBulOyu5rdINWY+vwZgHN1oPW59Tae5X+TsB?=
 =?us-ascii?Q?uouzj5ozI12JnyWmYXTS5T19MOcEkw5fwOH0HjHWTDnUi3IHeJQZt9OAkpu5?=
 =?us-ascii?Q?r+Y0Z452umbfQ3Sr2c99q1Be1M6xQgm2t18PVXqlqTfP18urEHiZwIHXWuQp?=
 =?us-ascii?Q?J56u6b+qnfN3jcGyPXIOyaxdUHjgzV7mkTA6brTVFhP8o8YPQ62Jir5jsBka?=
 =?us-ascii?Q?I//FAbxZZQngbYLk2FpFHwZwFiIe1EakTD4qBlXvz07vB1Ew7CT+mxp5kCkL?=
 =?us-ascii?Q?gL7rfMOo7acW5tUIGOb7jQORzPvrG2hSmY4rRkUyJZWqEQ3tDcowUj8Yiwbk?=
 =?us-ascii?Q?H3hhMNENaXK8hjAFJ8SYn4TnkHKUuYbhDPfGIzhNmQuHxB8w9A5m0rmmVZ4N?=
 =?us-ascii?Q?5MSAwD/vt/y5I+mxKlwKtE+QgK3Srs9uOaLtS7B/hj6Bt2mIw6qObJMjJ/gc?=
 =?us-ascii?Q?TnVXLUaBr5eHwd0pRsmLhsOUB8QHAsRN8gx/alshll3fOtiQoe5MVhl4qP6x?=
 =?us-ascii?Q?kCKjOgcgQfdAH3IKj0+eoE3jHSeMNeP607yLdTC9kRgCVbOy4oOVPf4G8tHQ?=
 =?us-ascii?Q?60z54c2juUSFritapPIScx/esLUj8VGg/JE7uR4MKdy1gsOas+z9D1j3nUaB?=
 =?us-ascii?Q?2fNWZZR3K/pNn8BG4rcgWwNsw0/qxFFqktTo53TIKlGCGJWaEnMdxuKgUWIf?=
 =?us-ascii?Q?FG4+1Iwu0cz+Y42AIP+53KgtaUw5+Ac4963H/pf9tvZRHgjGpi47DSuThcmi?=
 =?us-ascii?Q?99Z9m+7UNF1cOHVGrT5Bk6A=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0089D24C8D65DE48BB0BD3084B097866@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR04MB7776.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d02d701-c42b-4024-6b26-08d9d4a95b60
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jan 2022 02:23:29.5836
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ir6kY3tRSs5tKLrtbIJA8EhLGzJ4Jhgq835GoLvcnv1pPLhH84E4QaTM3BNZmMeddI9gze0BUc+pw5sdyTpezg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7773
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jan 09, 2022 at 10:01:42PM +0800, Jiasheng Jiang wrote:
> On Sun, Jan 09, 2022 at 04:53:39PM +0800, Damien Le Moal wrote:
> >>>> Cc: stable@vger.kernel.org#5.10
> >>>
> >>> Please keep the space before the #
> >>>
> >>> Cc: stable@vger.kernel.org #5.10
> >>=20
> >> Actually, I added the space before, but the when I use the tool
> >> 'scripts/checkpatch.pl' to check my format, it told me a warning
> >> that it should not have space.
> >>=20
> >> The warning is as follow:
> >> WARNING: email address 'stable@vger.kernel.org #5.10' might be
> >> better as 'stable@vger.kernel.org#5.10'
> >
> > Cc: stable@vger.kernel.org # 5.10
> >
> > Should work.
>=20
> I used 'scripts/checkpatch.pl' to check it, giving me the warning again.
>=20
> The warning is as follow:
> WARNING: email address 'stable@vger.kernel.org # 5.10' might be better as
> 'stable@vger.kernel.org# 5.10'
>=20
> And if I use the 'stable@vger.kernel.org# 5.10', warning too.
>=20
> The warning is as follow:
> WARNING: email address 'stable@vger.kernel.org# 5.10' might be better as
> 'stable@vger.kernel.org#5.10'=20
>=20
> It seems that the only non-warning format is 'stable@vger.kernel.org#5.10=
'.
>=20
> Sincerely thanks,
> Jiang
>=20

The checkpatch.pl in 5.10.90 fails to parse the line as shown
above. That is fixed in commit fccaebf00e60 ("checkpatch: improve
email parsing") in the current tree.=
