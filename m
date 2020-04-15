Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DAFB1A91B4
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 06:02:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725770AbgDOECG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 00:02:06 -0400
Received: from mail-eopbgr50067.outbound.protection.outlook.com ([40.107.5.67]:10894
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725294AbgDOECE (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 00:02:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l+gcuTv4S3MlVaqBntPmrFyX/YgQNHtPN7IDUU3ucbzmKAm7z21dF7jZYnJtWpbJmNs0+JRLwGtysEF9MsqrE3xJMSh3CBLrAbhP/mH4UomTok5TZgDyUsVUNafhkUCQazZhT17OFT8J5WvseRjYtVOgNF6z0X33WkKfSWe8ij+lRty3LA8yB/Agohh/VZ+eFBEUl82FrZTWMWgG4LcqMrUPjDHz//8eqGe8beF41bV5uq+0UMeXxg8xFgIDu54PDFZ6DyEnvHCnrD46jQm/l1JJcJgYfVxIREt4Ylc+8VNcy8TprMovaPOpDxU/PkRXZXdMGAZ+oYR6NapFrTl9TA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZthF+o1Fqb/HOnhMIY6qQCS8hyA/4vbiK6CV5z9D8Iw=;
 b=eycD6XpLoP1HeDuIz4GzagIwFYr2wktQvJ7FK4zjOraffSLrElPS+mLdToVbNg9sOPWneXd1C2ejTC/EIEEg/QTq/c2a9TuLIxiW8Hi5D86+MBScWww6mw0Fak2gm9bRIE/ysQpXRdXbyLzg8rXNnlPOOKoM7/8Ya+UTu6v3EgaxTu8vreAgUUgJzJwkeZ0B993yGVTpa1Nd3IMNfU9m0/2JmiQ6iTtHxgs2SuOk5bIUDKiyZQiZyN6XKUEoFy5GbAy979qx8zg6xFfcbMhU70tXjt1Mq6Omtle7CSwa6v+ePzf06bUyAyAGwNVJe4QcZDB/54eVSQTgSc2vJAv0pA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZthF+o1Fqb/HOnhMIY6qQCS8hyA/4vbiK6CV5z9D8Iw=;
 b=ibAPi0Bx8JIlyochX0ZA3w4Rb+cOxj1NHJ+o+jBqRR0NjwYK9V6/8qTYmWtc8dpKQpLDrtzKZUnKOvpae9aVXVzFy1T6eheAvtI3r70FxidlV7A6AM44LEs68rigX1zSr5qf2vW6dPW0H/Y1Swu9UfCRylFvni3rMkO+M1j7khk=
Received: from AM7PR04MB6885.eurprd04.prod.outlook.com (2603:10a6:20b:10d::24)
 by AM7PR04MB6936.eurprd04.prod.outlook.com (2603:10a6:20b:106::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.24; Wed, 15 Apr
 2020 04:02:01 +0000
Received: from AM7PR04MB6885.eurprd04.prod.outlook.com
 ([fe80::fdc0:9eff:2931:d11b]) by AM7PR04MB6885.eurprd04.prod.outlook.com
 ([fe80::fdc0:9eff:2931:d11b%5]) with mapi id 15.20.2900.028; Wed, 15 Apr 2020
 04:02:01 +0000
From:   "Y.b. Lu" <yangbo.lu@nxp.com>
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Daniel Walker <danielwa@cisco.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: RE: [v5.5] Fix up eSDHC issue on P2020
Thread-Topic: [v5.5] Fix up eSDHC issue on P2020
Thread-Index: AQHWEtnNlcx6IRidMEm9KCs/UwaqUKh5jz+w
Date:   Wed, 15 Apr 2020 04:02:01 +0000
Message-ID: <AM7PR04MB68856F8499F0AA8695EFC851F8DB0@AM7PR04MB6885.eurprd04.prod.outlook.com>
References: <20200415035212.19139-1-yangbo.lu@nxp.com>
In-Reply-To: <20200415035212.19139-1-yangbo.lu@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=yangbo.lu@nxp.com; 
x-originating-ip: [92.121.68.129]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 89ce73cc-fe3c-4735-f384-08d7e0f1c037
x-ms-traffictypediagnostic: AM7PR04MB6936:
x-microsoft-antispam-prvs: <AM7PR04MB693645C245CF05065112CF98F8DB0@AM7PR04MB6936.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0374433C81
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7PR04MB6885.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(136003)(396003)(366004)(346002)(376002)(39860400002)(186003)(52536014)(8936002)(26005)(33656002)(2906002)(5660300002)(64756008)(81156014)(54906003)(7696005)(53546011)(4326008)(316002)(8676002)(6506007)(478600001)(71200400001)(6916009)(966005)(86362001)(66446008)(9686003)(66556008)(66946007)(76116006)(66476007)(55016002);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /FEZIDrxkP9mhtP5ai6LJU0AWcC2IJlRz187Ne869kKp8XsHwD4lsGX5dEsRtZwPx7GxD7Z7haDZBb5HKEdU/ulOMlty1M/VE7EL+TzaHoWBP1krcUbD2aa0Mt2W/z47tdUHK+oGtyzZv1A517faVYEoYGaZsaStICCqfx2kz9tY84D/V6FoU9DbKefIf0mZhlkT+XGKuJegacwXr0eaCnzTommZwJ9kXkS9uigvQR3/a8xjNf7jlLOfqLmeXA7n/Jo4JnbB1rxIQgVRa3fDcxYk+fpJlr998GGfBG8kEW5MJ8oLh9KlVCW7PjxeZwMMzvbpOnQkp7+fcGnz1k7TBuWQ2cACN+RKJ0zSgFpU8dWaAaoSPPZW44E5L41bJyrNANV+XaJkGUuqwXiwlEIpu63QbK8JwfnvdTfZl08UL0ZcpLlg+Clo01b+WQahgBf/QZbHRo0v6bdsnATz6Gb/8LxIUHYHZMyjuXg7pTYX9OjpLkFPFl7FkQV1qkOnKVmfuhgb94zOyw2tAHlK2XIqqQ==
x-ms-exchange-antispam-messagedata: qeT6bWAEwmYSakcrCTEMzhq4ClOMjV3CCBGHQsgd16x30dlYMO3bq1fgN/QKNwi//RhSKx9pDCGv56mZWlsvVeqM3EwPO4k/euuagUTiHlCnPcctqCQ1gbSXz3Wss/7AU4AEeUcyRmHtxpkKd6xHyw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89ce73cc-fe3c-4735-f384-08d7e0f1c037
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Apr 2020 04:02:01.1682
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8Fz9WTuX6OGYahbK2v19tWFklkHMS0U0w7ZaQkixBv6FXNzRzteneMEo4ldsW+A2F6320VTF6hLhENEYppe1Jw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB6936
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> -----Original Message-----
> From: Yangbo Lu <yangbo.lu@nxp.com>
> Sent: Wednesday, April 15, 2020 11:52 AM
> To: stable@vger.kernel.org
> Cc: Y.b. Lu <yangbo.lu@nxp.com>; Greg Kroah-Hartman
> <gregkh@linuxfoundation.org>; Sasha Levin <sashal@kernel.org>; Daniel
> Walker <danielwa@cisco.com>; Ulf Hansson <ulf.hansson@linaro.org>
> Subject: [v5.5] Fix up eSDHC issue on P2020
>=20
> The upstream commit broke P2020 eSDHC.
> fe0acab mmc: sdhci-of-esdhc: fix P2020 errata handling
>=20
> While the issue was fixed by later commit.
> 2aa3d82 mmc: sdhci-of-esdhc: fix esdhc_reset() for different controller
> versions
>=20
> The commit fe0acab had been applied to stable kernel 5.5, 5.4,
> 4.19, 4.14, 4.9, and 4.4 without that fix-up.
>=20
> To fix up P2020 eSDHC on the stable kernels, backport the fix-up 2aa3d82
> kernel 5.4 and 5.5.
>=20
> Please help to revert fe0acab on 4.19, 4.14, 4.9 and 4.4, since there are
> many conflicts to cherry-pick the fix-up, and fe0acab is actually not str=
ongly
> required for handling errata which is hardly triggered.
>=20
> The email thread for the issue discussion.
> https://www.spinics.net/lists/stable/msg375823.html
>=20
> Yangbo Lu (4):
>   mmc: sdhci-of-esdhc: fix esdhc_reset() for different controller
>     versions
>   mmc: sdhci-of-esdhc: fix clock setting for different controller
>     versions
>   mmc: sdhci-of-esdhc: fix transfer mode register reading
>   mmc: sdhci-of-esdhc: fix serious issue clock is always disabled
>=20
>  drivers/mmc/host/sdhci-of-esdhc.c | 174
> +++++++++++++++++++++++++-------------
>  1 file changed, 114 insertions(+), 60 deletions(-)

Sorry, please ignore the wrong patch list and changes here in cover letter.
It is to backport only fix-up 2aa3d82.

>=20
> --
> 2.7.4

