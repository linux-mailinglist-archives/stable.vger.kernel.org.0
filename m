Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AB804447D7
	for <lists+stable@lfdr.de>; Wed,  3 Nov 2021 19:00:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbhKCSDQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Nov 2021 14:03:16 -0400
Received: from mail-mw2nam12on2136.outbound.protection.outlook.com ([40.107.244.136]:59105
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230450AbhKCSDN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Nov 2021 14:03:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fEZd4dVOnxI/RevVBAxiwFr4vU2LEHOQ9truMqAnLCYXQGvwnLQFbhRyZ23Yk/8kI+oKYhKHOzwkk8BKFlKPIyO5ootEzFQzUoCfI4099SOnRQHCIXyzsSX1wFTSz456JjeVPoSwO5yAupBDATzr+uzAxyqZT5ueHCXuK5/ECJuLFpFM3QOqEt+nl7y7N8QrZ4rkFAcMfy3cCVmvwsgiU1zQRZhEUin75Tne/Mv19B6u1E4AQAo1KICctyYcHyX6Oofdf508uzNxo585t+iswIOc8FJpXm2EQrdHG/ms/ggA2GdlctkMWlq0XaQIU/YY1fdRVQFa3fFknquyRVODug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kpVx6yp3mZyk8/PrfYrPCCu9bZ8AMdxKs2iWwnveQ1Y=;
 b=Mst6VANvVyojU3WZJzmCFcTucfhYQ8rm/eG6CX58btxcWJm3bkpHuxhXP9QpdqKLLFD5wBXv1TSjSG/RHsG+QHJqztQqY2cWuMrtwaNuTd+ikP96Q7QOM6nbwrN2sIJ/ABg4XRteomFIds29+F+/v1OkSQiWnkc2li51IVJTP8nNTwaL2dnzFbRCuPMDK4Pe2pJCeb7Wvn0p2jw1yFYXl+Kq1Rw3vScr2S+YAl+dGZgHybvENDbnGuDWp8euDXctHRfYnIsxTJQ/l4p7QZOA1JVrs2qrcbbDjdcwyj3a55dXPe8r4EbOjsCQRdS3HW/ocKmR0qvfBc0qQKFHGaRr2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cornelisnetworks.com; dmarc=pass action=none
 header.from=cornelisnetworks.com; dkim=pass header.d=cornelisnetworks.com;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cornelisnetworks.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kpVx6yp3mZyk8/PrfYrPCCu9bZ8AMdxKs2iWwnveQ1Y=;
 b=SrrND2Ew1H7+25edt7PYkPqgwSb25oTu9DIgSguMvtbf26LUGwmi2x/qO1C1NjmKVCv//e1DIroUAPt+MSKiQxILRlZaUDiV/o+a40so4saIq1dkFKHN0Lg+DZCDEDoe/Z3DxPWE9rIAnSkmPau2jPgmsXbCngc5ehMJGY6/3sZmQlWxGT+mu0djqUoNNen/7DymtNsA7OhBfpRoUuMlo6G7O/Al3abXeirsvBIGWN6XS/YIApvADNNZYDUyS1yxDwx17lEws+/Bng5CAXJLL9x+mMeYAlTjPsOfv4PwBiYNfuguj3UMPCEiCVoy51Q+BW+dA8fG9KtXAvBOpUpZFg==
Received: from DM8PR01MB7157.prod.exchangelabs.com (2603:10b6:8:e::7) by
 DM6PR01MB4028.prod.exchangelabs.com (2603:10b6:5:26::16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4669.10; Wed, 3 Nov 2021 18:00:34 +0000
Received: from DM8PR01MB7157.prod.exchangelabs.com
 ([fe80::f199:25cc:8a3c:c983]) by DM8PR01MB7157.prod.exchangelabs.com
 ([fe80::f199:25cc:8a3c:c983%9]) with mapi id 15.20.4649.019; Wed, 3 Nov 2021
 18:00:33 +0000
From:   "Marciniszyn, Mike" <mike.marciniszyn@cornelisnetworks.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     "Dalessandro, Dennis" <dennis.dalessandro@cornelisnetworks.com>,
        "ivansprundel@ioactive.com" <ivansprundel@ioactive.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: FAILED: patch "[PATCH] IB/qib: Protect from buffer overflow in
 struct" failed to apply to 4.14-stable tree
Thread-Topic: FAILED: patch "[PATCH] IB/qib: Protect from buffer overflow in
 struct" failed to apply to 4.14-stable tree
Thread-Index: AQHXzY3GTwK0YivjsEWUaqYtzO9ye6vx8ioggAArzYCAAAAkIA==
Date:   Wed, 3 Nov 2021 18:00:33 +0000
Message-ID: <DM8PR01MB715777FBA8534B8D53BC2474F28C9@DM8PR01MB7157.prod.exchangelabs.com>
References: <163559866445226@kroah.com>
 <CH0PR01MB7153A85CF46D541FA76F1F95F28C9@CH0PR01MB7153.prod.exchangelabs.com>
 <YYLN/RXehdox7308@kroah.com>
In-Reply-To: <YYLN/RXehdox7308@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=cornelisnetworks.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0216b025-366b-4479-4f7d-08d99ef3d521
x-ms-traffictypediagnostic: DM6PR01MB4028:
x-microsoft-antispam-prvs: <DM6PR01MB4028D95A2C59B1A8D2F77CCFF28C9@DM6PR01MB4028.prod.exchangelabs.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /vBO9lqtcF2KHv4f9zR67TdEa68w8fyxiFeNQWOLBPqowwy/rgstykKXBnbJam+dNNFLGeWzNRwfNKT28XG2rd75ygwxc7/1SKc6oYZChvHCkuDp1Sd6OwRSYOJhNAzT4E5BuE4S3Px/ZRNkIY0HKfyjnVHUE+UkkkwwKvTWz3iK0sIFaHbPhgX6OQsddPxaHqgHMaFe0YWYGGyNJ1Ay4NJrVAoTot2s+wzKmV2iu0vxuGK2mRVJbbvBVl/wXfflA+FJ7NXtHNMJHW0FWA60BV4qHbwzijxUgMIB82h5ExwmzdeJ2dv3LTec0B0WKdkk/TqWczH3qabiuCHWjsZzGZLQ98iMjPDXElYC0WLA2WeuGMq3mbdngc7s/sKYtI8qiTomC1/EH60dnDwOuT+WYNu9fI7J4OdWSgQ5ctnx3pxSpDqDzr/ViP1Wgqqf5mCS5V6K05be47VfsVIo2ZYbmEk71TNa1kDx4BOshK4vBeAy6ns396EDTx5DrcDNh2eXKlQfr5ZQGcp32FoIx8PVV5FctQmo44aXM4rVH5drmLO8EDh0nVNaPhlUut0V0DR4n8My0oLWnrXBS0NJY3RXU7aHADKNAHVDuRZ0uJ9oiNkHtZDp7F6ym5K170O/UlE68UdOmgCX5cmPTRCbCfIYCBou0kf3YgZtU3am0cVPcSxB+Cs1Na11VRAwp2v8weiNx8K0OF8MFQV4Cc5xMYm6uA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR01MB7157.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(366004)(346002)(376002)(39840400004)(508600001)(5660300002)(38100700002)(6916009)(55016002)(4744005)(316002)(54906003)(8676002)(9686003)(8936002)(66476007)(2906002)(38070700005)(76116006)(186003)(26005)(52536014)(86362001)(66556008)(64756008)(71200400001)(7696005)(33656002)(4326008)(66446008)(6506007)(66946007)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Wfj32PdsGdMofwFq44RpWxrOvLLo7lhB/d26ZtV59Js1ngk0j/luhU4KM8wf?=
 =?us-ascii?Q?IFhabm5Oc5uOV7E5+btJRatrQ8M9xG+tn+4U10g0kv+N5TJW7VJ7UjFN4q50?=
 =?us-ascii?Q?CTG3dbG58rCrKbSW71LYI84/KlDjNw0QsXXxoM79UCh4YQjkfXJW/TAbNiSk?=
 =?us-ascii?Q?cm+11r+bzgcEqzENxhv2MPBwWzNKuN3jNIX8dL9G6wz7tR2Gi10CDDoYbje5?=
 =?us-ascii?Q?Z9YECJbAFBbw4USnyrnYYA5XA0VnvxY6JmHVNLD7+ao7yEfOAJVQgh1tfABn?=
 =?us-ascii?Q?p0kIfR3ToUtypPe4kd7zZzythC47UVPgbS8NOr9dBtbz+Pusul6gqBXiIkyF?=
 =?us-ascii?Q?QMD4Tl5J3cvvfEskt8P2EhOczSnNGnTrva1+HF6wMSXgz0IysB5ApwbFAUY8?=
 =?us-ascii?Q?A292A8oFrVev10/ll9N4FwUaSm3IMnjY3aDOIkP25dR5ipVbfHldzo3V0gXU?=
 =?us-ascii?Q?gG2VWW6BfcvH3QTSjcfdobm2pCCoxQao0MFtfjw+Ncz8f0vr3LvjXNDFgAID?=
 =?us-ascii?Q?vKny1AFt8QqBmrPuNiQ1dVeSYdxUR3BY61RiQe6BJQMAA1LzYYeGQCxfP4nv?=
 =?us-ascii?Q?K/8OLF943eC13aL7f5Qwm274JDS0NC9e4CEcXxRDfhPqsFH5LR0nat58nH1m?=
 =?us-ascii?Q?vBx+9wSdaJBVX+oGmRV79D5cp07YKlnhpPgzBSi00IdcDy/1xfhCMLSI5l6s?=
 =?us-ascii?Q?C2lrXJOnk/o9RiLY8K3tU+WwefLL4tc6yStJDnPQ3KDld8TlMU48MTOg6suL?=
 =?us-ascii?Q?awLzEhetQGEOu+60az9Fu0gZk/mLUJyAw6B+8DF+fflsaaRmjIKJQP5M/3lZ?=
 =?us-ascii?Q?rD3wCokmny1N3VMsKCTjhX306ei2FSKG4bH9RrunexgWeKRgiHYYSUupx6w7?=
 =?us-ascii?Q?ZyxUov/yOxJElaR6iMKWvsvX3PttHXFkRrM2ZQithUduHZbn/Gl0m2afeRhR?=
 =?us-ascii?Q?iauGSExKTXWyWt/XYQDZJ4PjpK0YUm6CvOYkgCnEN2c7QjvcXiA8lVzGJupq?=
 =?us-ascii?Q?NaDIvrVOqykI7wDxpN23V0V1xiF2Ws6QdiboPX5aUcRsCRV72dLyPDcPS3og?=
 =?us-ascii?Q?Kycr+3iY+4iYl2xDm88/hcLntQUppNe/WQPtdDoIGGSV2XLJMtml6ZO2kHI7?=
 =?us-ascii?Q?GsiQMATmZ/tv7Ae2jk32N5ZuITraXYO/VOnfduUgIbU4vt+sYthyHs4jmTQI?=
 =?us-ascii?Q?u5XnFKKMR4mSvjKz2KSDMlsEAJBH/CbpEVUQ7aYy/Oq7AfPIN75SHhVe6BSE?=
 =?us-ascii?Q?h103LlFoOjI1qz7uOeBzAyXThhYwEQtdwEGb85ygto+bbpDqygExa2bSOiKY?=
 =?us-ascii?Q?CGEakQ21MT4XVkgi22Wf6xQzN5iZJElbFBY6tINbi06OrDTEWz53JU78IYCd?=
 =?us-ascii?Q?6OIxtnjukU3SP+G6JpIgSKkv0qmh6dr+fSeLwEMqovmM74okwPZjry/G+HfZ?=
 =?us-ascii?Q?Fv+RQ+keC7LhXpg/V/KQmSYoInKUb4t2FkoGrnVE7glv8/r2sQ5xae5ZbLoe?=
 =?us-ascii?Q?osn7vUd+fRqlAJzBMFsyz/DkGbQafjIV9fKvfyZ+S689YWafflDhzQ+Uiolg?=
 =?us-ascii?Q?oRURmYF4WVH+jMfijnVcKpjfgXdVlUuNegMHaX9apOmEX7ztPUkgf1OvuMRo?=
 =?us-ascii?Q?zSPwBje+B3R1Ne3SYDeeK4qy9KNqSD4iOlntGEIMNFwmYg9MCXBj9RLp5vdn?=
 =?us-ascii?Q?tLoXEI4yqz551XbgKudXbOki4pZhdXkN3Z9FE9y2+i4PXUyM?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cornelisnetworks.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR01MB7157.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0216b025-366b-4479-4f7d-08d99ef3d521
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2021 18:00:33.8392
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4dbdb7da-74ee-4b45-8747-ef5ce5ebe68a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qLGkS9jz36zfLOrH7kWX28c5KOVqD4fi80dO6WU8sF5N00XwHA4aRjM92tF37ouqglOeqkn43HvWl9jE49B1ILb4OnFIhWj8mVl94GwcuVx9GAvUyR7MXP/8sxkdXq75
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR01MB4028
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> > This patch requires a backport of upstream commit:
> >
> > 829ca44ecf60 ("IB/qib: Use struct_size() helper")
> >
> > That commit needs to me modified to include linux/overflow.h.
> >
> > The overflow patch then picks clean after that modified patch is presen=
t.
> >
> > How do you want to see that expressed in patches?
>=20
> Can you please send a patch series for this that I can apply?
>=20
> thanks,
>=20
> greg k-h

I figured that.

I will be sending it out shortly.

Mike
