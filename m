Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B58B949E93A
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 18:42:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235235AbiA0Rmb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 12:42:31 -0500
Received: from mail-mw2nam10on2040.outbound.protection.outlook.com ([40.107.94.40]:35361
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229956AbiA0Rmb (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Jan 2022 12:42:31 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ff1QM2DxIXOmzoDKqYhxj/ksglP8LDQNy8JDIm3rk310HIwt+LlIWDJ6zxKwiFN/MlLYbfAayx7BWF0QSU2kVmp9fXVWw/NbkQF+pxsIIGDHacJa7IlI8M3+Uj6i5tikWMUl5qHjIOA9dn5820P1wv1kJsBVc4oy9cz0vbliHzapeUyNyYqamXql1kWIDpepIGpEWhPhMKCLWfoMwAJlXgO1vS9Dy40BcPn+naZgl+sw2qCdiZSdSTVICi/yvLWEQJ6r+rTNbnrNhbwEzaWEHEpTxnGkCjMu6FHyVLCOCx+cPClBrKfREDUkobz7vNnsZLGTH6SVHsEJHzlvZR+S/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6TUcqGiTz5KxJ0snS21/CTsmivD0viul8py3JyUe//U=;
 b=Xg8jZRIli7RhaRsMudVJlowBQUGSjq31YNgn69u6JSwqt0NF/+OAm0Ydkuyisd/eXtdf7gKsXIHO17XNd4i7N3ITnuPG1OZdmUsPLe27NIgjrVDGNJLHI7RPV4SxPa8eX2JuyuOr6QyiWmqlz4CURh0xBF41REunktnEokfeN2kcfsTjMJgDQdmsrvJTYw+QzILZCJO+aycS0r2sV0xGTHzSeF43O7xaXHShyzflz/qkT3pN9krJS/BTVZ/GoK+nCt1wYOkRPyNQWpImz2QuW8D0BPHvcpleSF5JC/iw1oYxuOnT1MtnUIZhau2IxiYqinXm5MVuUKGJhwNAKXiGaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6TUcqGiTz5KxJ0snS21/CTsmivD0viul8py3JyUe//U=;
 b=gb8WG17tWzRCo38sMoGND+FzFkZ7Dq5pPRDofrtd+fMpYqIqUseS+GauVCQOoJl6v+gd68Kv7R/4Iuq2tMV+eD22f5F98Gg2syrzvvL+zINOyg6mE2sbDPSBD4HjCrUjLKuiaCgOJJv51qbpjefYuRwwWGFy3ua6DIP0KvtJqQE=
Received: from BL1PR12MB5157.namprd12.prod.outlook.com (2603:10b6:208:308::15)
 by MN2PR12MB3485.namprd12.prod.outlook.com (2603:10b6:208:c9::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.17; Thu, 27 Jan
 2022 17:42:23 +0000
Received: from BL1PR12MB5157.namprd12.prod.outlook.com
 ([fe80::42f:534d:e82:b59f]) by BL1PR12MB5157.namprd12.prod.outlook.com
 ([fe80::42f:534d:e82:b59f%4]) with mapi id 15.20.4930.018; Thu, 27 Jan 2022
 17:42:23 +0000
From:   "Limonciello, Mario" <Mario.Limonciello@amd.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Bhutani, Amit" <Amit.Bhutani@amd.com>,
        "Tsao, Anson" <anson.tsao@amd.com>
Subject: RE: suspend to idle fixes for SATA for 5.15.y
Thread-Topic: suspend to idle fixes for SATA for 5.15.y
Thread-Index: AdgR9qphnqUAoyLrR/KqBpWH4SRB3ABm1Q2AAATK+nA=
Date:   Thu, 27 Jan 2022 17:42:23 +0000
Message-ID: <BL1PR12MB51574A7C2136A21DB556DAB1E2219@BL1PR12MB5157.namprd12.prod.outlook.com>
References: <BL1PR12MB51579C4626B8B584F5C50F44E25F9@BL1PR12MB5157.namprd12.prod.outlook.com>
 <YfK5NdC7eaUQb45M@kroah.com>
In-Reply-To: <YfK5NdC7eaUQb45M@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2022-01-27T17:42:15Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=8e3af7e6-6960-46f4-a6d0-07b60be7ab1a;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_enabled: true
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_setdate: 2022-01-27T17:42:20Z
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_method: Privileged
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_name: Public-AIP 2.0
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_actionid: e2ef6012-3f49-41ae-a5b7-ca4ea0c3b9f3
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8696cf39-1e14-49be-f00a-08d9e1bc603f
x-ms-traffictypediagnostic: MN2PR12MB3485:EE_
x-microsoft-antispam-prvs: <MN2PR12MB34856654CCDD1C8687B5584EE2219@MN2PR12MB3485.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rexx7dJkZYLceJVGKHhIJp+v5ORptdxY5aSTqo2KzskcLpfbQcIZS4IWmQJdP+hnqwmxjBpnqxq5TqiGuw/KQhXX/z2WIkyFBjLV6+sPifCm7yJtiqJqGhEcEV3RtLP06OGOViiF5vT3gqNpuIqnMyta4XjF7H3LJkyR9SduQ1L3xj396O/PUuYflE2iuOafJMoDzbZ5MN3jWhGLZMUhtE0old2xt5m4fUbl7YFAA9DTjpq8nWOnlX3iqV/AWnZxDqOeGr4G9mR6ZGMArtxSfAgPXpt5VtGR8n4QngyZhlaVFHi80FkszhUOutUBJxFFD53iiVYs2jYz7enLJWIYz+6InNkUxUmpBKib1j0saO1Kqms9yVjC3GF1jFp2Zsropeb7K2yq/RRhs6h7NsCl8cVujkFmAUSp2BbmRBARVG2FpI3dBnwQmdUpQfZO0PZs8fCasAhtFphTYqPCAqVIgxXgI0Zvse1cH+pOKwga1YU0CSpvt2h6R+lU334/Nl34/dULmxvU5juRBeRwBaTqeRkRfTFuuEgo1LVRYh6nRxrK9lEKrrkBCWT+88bhnKhhf7mu44A/xDHk0P6Z2gxzHojh9LNxkd8UxfGIoGv9sww43C4+9nwFEDg70uNFLCbXIzafUKmNslvC22jJs3k/Oth5zCZob2PbiGcZm/FQO+Bwk6u9TJbqwZz7yULCHL2GGFN1EfB0u5CnlOgxpk0BCA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5157.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8676002)(4326008)(66946007)(66556008)(66476007)(66446008)(64756008)(8936002)(76116006)(9686003)(4744005)(15650500001)(83380400001)(26005)(71200400001)(7696005)(6506007)(86362001)(186003)(5660300002)(33656002)(52536014)(316002)(54906003)(508600001)(55016003)(6916009)(38100700002)(38070700005)(122000001)(2906002)(20210929001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?9zBLM6ajaxMI1Yzc6Y//YAAWrNdoKOvR6Pa6TNqX0HiEyOX/MwBnuEgrsGX6?=
 =?us-ascii?Q?FQq52dBSsE7wvwSLQcFGyAIB68Eob/anLoK2tzUOUjkHTizhMl/pM1GK7jOP?=
 =?us-ascii?Q?xQFlyzkAh+FLrerarF6Pr+v+RXnVxZcJpzGS+U7EY6/7xNcYcztHzDpQHZaG?=
 =?us-ascii?Q?j3XOGXEhwGWYVn1wmhAM9x87UdrJvk4FdEKJ5Iy1A7iDhhyrJmkOdSihgrS5?=
 =?us-ascii?Q?PqjTr/5z2csRcP328jWFKPWxCHRnklvNX5EJo0Uzkaan7i2tR9q06LqoYBQs?=
 =?us-ascii?Q?fQdVyROGxdnBw0VEelam3HfCj3rviTP5oJlKpeSl90AtS5+sww7KOQRqcVT8?=
 =?us-ascii?Q?5SsMqXd1JSiP+NKqVhVZAjzVPLBl7wuZsOejuJlkbtId8ThweBeP/Uo0QZYY?=
 =?us-ascii?Q?7js0AAyoJMXDBVdo89io54yFi/QLvWsIFd9JOgnL8HzXiaYvAYWqrBVVGCO7?=
 =?us-ascii?Q?GtclxMmOhJoErg78bphcpZz4K7AuTfjyb0iY3LzDHZ6UVkrnl2jD2HlJjWc8?=
 =?us-ascii?Q?MsU3x0YA4ud5whPy9APrMiW8y0EriI1vDtLkENzhU8rID4R1n/SjVB6EXl8k?=
 =?us-ascii?Q?tWCh3pXW8vUeSMOEAZ5ZuHwDRRZg14+bZgZkVLNfUE+vMVumI8kFZCYOcWV4?=
 =?us-ascii?Q?ErJofQwWsxSJj9cZH4k/3MeqU0kvribCOmqLAHFJUBPSDjYNUaxzc5cHNACw?=
 =?us-ascii?Q?vMwIRVk8b4h3kesFmQg8sPTPMr7I/BpI8ZZASVUXAcKMmwQefTIdbcIR52fy?=
 =?us-ascii?Q?8y6vBusgU81wQFOrwT0361H+s/n22C3msmAcxPftmMucDh/2Kq7x7AArKGV4?=
 =?us-ascii?Q?mAvd5IiEcuytoqoMyVADkQZogJCgOR5/TmJwj48bPvffMMM44tz5tjof5Ti7?=
 =?us-ascii?Q?Lgy8lDdgdfeUou1PUMlxaSi0kUgQytx3dBuaat4yaXR6MZtBuR1PIoaaJai2?=
 =?us-ascii?Q?JB6Z10gc5PihoEULhyr4A3yAQd1/ePN6v/lIVOhr+ZjN3f4+tRFZrWRNO19S?=
 =?us-ascii?Q?W7CjpyNUrWHo9sWiLuYLygeA3zianpqp3IS/1xtN1Wi9oMa7WakahNBgCy5b?=
 =?us-ascii?Q?RmLlAtM/A+ZzBiTn/0e/4RKjFrn1fIMeQ4aSkq75oEnhXsPMlDcCY09Psx8r?=
 =?us-ascii?Q?e+1vQCRs0jvZHYyAxrqdITDT2E1ECQrJzT6JPNkUWm/OyKLHMpGvzBFLyvy+?=
 =?us-ascii?Q?rN2/+tBd0lV/m1Jz4enb1SK1Xzn7Lzt4w9Zc0WibDN2GAshYSvnEs/ryJReY?=
 =?us-ascii?Q?IJtcalUoSdZaKvJ8RbphJfzdHn9yieeS+lztx/Wbzoh2nZR+V8+0VI1C11Gb?=
 =?us-ascii?Q?rERspbBohcoZLsvdVLbByHfXmSsKgRk7fr92/EafewcVgvN9BLC1rpcWakRP?=
 =?us-ascii?Q?NLxn6NlPhIQIa4Q3lh6npFeQXSf5daVz5H177oZx4xqBFU+IgyaLrvstUZmv?=
 =?us-ascii?Q?gjTTvhVX4TjmhGyTbC4eqm0e1L88i4i7rxrpCOiknl1RrRysUwkIO9XWH6d+?=
 =?us-ascii?Q?dXOYX+ZvZ10SesJWBxcxB42PyGtI67e8Y/bLnOknEqaM8JJEMLnMmnjeSnZI?=
 =?us-ascii?Q?lUivW1bIEfJy97FFq3w3vPgJEWQgCFc8yN0V+uaxN64Zh3Xs9l8ExAKWbmAz?=
 =?us-ascii?Q?fA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5157.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8696cf39-1e14-49be-f00a-08d9e1bc603f
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jan 2022 17:42:23.3589
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2kEU+EfRJUDuF4THTt5dnUaYLEX3mDc4CQnK2+myU3kOBjQwlWWYZ8tEU6PSb3L6te88Nb8O3/Zf4SPlE5Z4JA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3485
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[Public]

> On Tue, Jan 25, 2022 at 02:22:14PM +0000, Limonciello, Mario wrote:
> > [Public]
> >
> > Hi,
> >
> > Can you please bring
> > commit 7c5f641a5914ce0303b06bcfcd7674ee64aeebe9 ("ata: libahci: Adjust
> behavior when StorageD3Enable _DSD is set")
>=20
> Already in 5.15.7
>=20
> > and
> > commit 1527f69204fe35f341cb599f1cb01bd02daf4374 ("ata: ahci: Add
> Green Sardine vendor ID as board_ahci_mobile")
>=20
> Also in 5.15.7
>=20
> >
> > to 5.15.y?  These help suspend to idle failures with supported SATA dis=
ks
> and should make sense for LTS Kernel.
>=20
> Are you sure you are testing the right branch?
>=20

My apologies, it was the wrong branch.  Glad they're in already.

