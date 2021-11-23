Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5863745A94E
	for <lists+stable@lfdr.de>; Tue, 23 Nov 2021 17:53:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231844AbhKWQ4z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Nov 2021 11:56:55 -0500
Received: from esa.hc188666.iphmx.com ([68.232.145.191]:58382 "EHLO
        esa.hc188666.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229825AbhKWQ4y (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Nov 2021 11:56:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=conduent.com; i=@conduent.com; q=dns/txt; s=sept2021;
  t=1637686427; x=1669222427;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=QeGv7YxKndSVT6z03ZM3qrmdUPFS11iN4QHSlw/mjzM=;
  b=GZOetZzHDx18V+4qZ+a96+cknEJFW+Phqsj//LkNyUqXsJgD4YdhZAVp
   UrfEjuq8qg/yN52ETAfM19ccGC/dYw1jUshqkI0xgg6pVypepkHbxFtqn
   cbqwhCpnnMhEhMOE0KYzwSNIQzExizDcZNJQJZ5BWx86cxAYfcda8MpDd
   7g3PyaIpWZR5EEs7dHfxUSdx+IenFvVeGQGEoVaK6ubqnv7V70/twlL5z
   qgKOTIpmFgdtb1wDj8lpb/vXZnn5i+7dDQUE27Xogf9gwEVygF07U6nWu
   hz0E8sDw6e6o/XLC4nuuDmLKaitsRcFkEgmGOb6Y4aSkRQfj4iJwJn+p/
   g==;
X-IronPort-AV: E=Sophos;i="5.87,258,1631595600"; 
   d="scan'208";a="208821336"
Received: from mail-bn8nam11lp2170.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.170])
  by ob1.hc188666.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2021 10:53:45 -0600
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LCJFEfAap95iUbDk35DQOR3qereQxil0BY//CIgTNQDW2V6AS/HUn4YIK89QB3gfYsIA/SCBfMoELy/zFO9GcRhoFkX0Iqib8ITsQRe7/i9dmmpRE3limKiV5q7IddItQ+cLjxZ4zp1gKB70jSlx2sjYm3UTTqjZNTc6imsEvue9uFdGVqDmThPK8GTy0J1uR6spxyL4YWx4WjDk/d9sy54GTT8+cWR9gvBWapuefTQttta/EvFxLGK6jnqyK3Ibg48iYHIsUyoKztL0aaQAgwZSdE04jJNxNZx414QWNzIcX8YoTYU12tu21vvRQjReh2ofzp3EyUxkCw7Fm5OfNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QeGv7YxKndSVT6z03ZM3qrmdUPFS11iN4QHSlw/mjzM=;
 b=mMB87K5rYEOsFC/7aThl6ZyiTAnX48iqBOD+44ONRzgjRRFugLiG6Sc6zP1F1kaH1YJ/v7AFowkeGQeSLjj2aD0aydUaHpUyc825sJHR8s30n2DsMiZssVuwhggunD2WyeBEDBaNuC+t4EToOp6OwWgbMArrI61L7OIXdhoogMEZnIXtQLT+oBYGD8sKGsH+fHc7LK3PEuybE9q1WJKNRL2LjuTx+n1tuNMVyIwJTZlLbz47n/QsBUptiEQ461aZ3d210e42jaZc6/Ci0effMgKWQDp6MXkcwrfPtw+PQyTRZID6wbdUH6px1Jvbb3ixQMcj/09VSQyDE1tTC2PJhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=conduent.com; dmarc=pass action=none header.from=conduent.com;
 dkim=pass header.d=conduent.com; arc=none
Received: from BN8PR20MB2674.namprd20.prod.outlook.com (2603:10b6:408:8e::17)
 by BN0PR20MB3800.namprd20.prod.outlook.com (2603:10b6:408:12f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19; Tue, 23 Nov
 2021 16:53:43 +0000
Received: from BN8PR20MB2674.namprd20.prod.outlook.com
 ([fe80::fd5c:cde6:a909:2325]) by BN8PR20MB2674.namprd20.prod.outlook.com
 ([fe80::fd5c:cde6:a909:2325%2]) with mapi id 15.20.4713.025; Tue, 23 Nov 2021
 16:53:43 +0000
From:   "Fernandes, Francois" <Francois.Fernandes@conduent.com>
To:     Konstantin Ryabitsev <konstantin@linuxfoundation.org>
CC:     "webmaster@kernel.org" <webmaster@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [External] - Re: EOL Kernels versions
Thread-Topic: [External] - Re: EOL Kernels versions
Thread-Index: AdfgUJIys2sQaThVQNmvMpZAGmTDrAAJvjmAAAEv8jAAAMXHAAACuiOA
Date:   Tue, 23 Nov 2021 16:53:43 +0000
Message-ID: <BN8PR20MB2674E60612008BC2114D3A3DF8609@BN8PR20MB2674.namprd20.prod.outlook.com>
References: <BN8PR20MB26744F4622B7219F22A2DA64F8609@BN8PR20MB2674.namprd20.prod.outlook.com>
 <20211123143647.zcnrlsnlmfl5yhhu@meerkat.local>
 <BN8PR20MB26741ED4B21328F5F64CFC14F8609@BN8PR20MB2674.namprd20.prod.outlook.com>
 <20211123153254.pqz4ii7jhf3c5ltz@meerkat.local>
In-Reply-To: <20211123153254.pqz4ii7jhf3c5ltz@meerkat.local>
Accept-Language: fr-FR, en-US
Content-Language: fr-FR
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=conduent.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b4ec941a-16a6-464e-ed1f-08d9aea1cf0b
x-ms-traffictypediagnostic: BN0PR20MB3800:
x-microsoft-antispam-prvs: <BN0PR20MB38001DE3D78EBA5153FDD51FF8609@BN0PR20MB3800.namprd20.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eE9TSAxmZQvj54mjguxCxLHPQDrx3c9+P0LSSgj93seeEJrrUXChF6M/My5peFjPweNaqaO0iQNPvBj1yIkiTtMFwFQTUSWXLf74FwDc8gujYr5teE29vjOmc6zvaW0iaqN+Qe/RPVCPRfsVVpFvEH37OskE7EHzX5KKiDeyeFxgJaerdaW8SQuMEEGQFMyicehCy1hCcF8Wmqt4Q8TLF70qbrxLRDesnHdiBTN87SaVqW5N66Gg1MSaoDLF/pwUD+leG/t6jhvM5vyQwLqRqKwlgDrO+Wjna76js3Rh5K483bv4JGJ5L1s2W8eNC8kfzA94VAbHSxgYzJGOIHB/DPdjnGOedSiRLj6zV13hpFxzlA+zqdSOIbEWvnt/ctW+FTbDvi7H+PEuB8CHWm3VmmnBTfD+1a8kd9uccEIM3ckDbg4B9BnVOR65cPbgKxw9+z/0P7FW++EFQFgYS/+FrZU48M9+j8ut7e4c2t1u9tV4lnCjb/UAlUxX49zeLYLgx2160g3OQSw2LVDhpAnCxIRSK6WI5JwKtDVaS/Kkj8t7BerAQGsEk9XEC4WS+S6z1+QGWyOWqyjM0H+kDrO1hj+KJvlhtRHnZ7DyXzcXhnQPBoz7PwdHmU6a2U6tM1l+YFiUl+ybCt+88idAeScteBwQpg3DShXD1UjYgAYUoey+y6vnNh982yBm4QHho+xqnzKxeLo6RwNZ6VQN+iW75GFQncX4aDegzr9RJ0nXWTOvnqp/wZ2WJvmHA8zGEHuseeG8MxMsTJ1mzCW3aKh6ziFJhmmdRHmf/n153N9SXnY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR20MB2674.namprd20.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38100700002)(45080400002)(122000001)(38070700005)(86362001)(316002)(6916009)(186003)(54906003)(82960400001)(66574015)(7696005)(83380400001)(508600001)(66446008)(966005)(8676002)(52536014)(4326008)(9686003)(2906002)(33656002)(66476007)(5660300002)(26005)(71200400001)(66556008)(66946007)(8936002)(76116006)(64756008)(55016003)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?cApRVW7eR6+j7mrLknASXJkKpGemWF/+wRmVuO6qXtlH5xJxILHgCSbFpU?=
 =?iso-8859-1?Q?3pG9k2Y0VH5I2lhV73/N5jwi+3HBPg6ltcOUbYbjA+mWTIbzP5h/yW9Nte?=
 =?iso-8859-1?Q?wbuSv3oGaozxjSBNfKEc6CiBne9DIlYEMM2rscfQCHpJlKSFgj8DC5gZXD?=
 =?iso-8859-1?Q?hwiNo1higuTvq1P4g5WK+7x8BUHqZWDj9ALaPjfXIYJJsVmv49zLH+H/Rq?=
 =?iso-8859-1?Q?OIOEOGugJsqr4Dz9ug/gLgXDx88Slt1RawpMRusdLXr9NL90BrFPrUXhzD?=
 =?iso-8859-1?Q?mKZEA6rg70LKMlS3jygMd1y8f/a5IwBTS/vqQGbnonoUzEnus3MyWlwLN9?=
 =?iso-8859-1?Q?5bRdFY3Okiu6yzgPCR7/haTlef51GRHfq2ifXdEDrJUIkJi0ye5RBrVuA7?=
 =?iso-8859-1?Q?IIBncDeNlIlRLHL+JMwUXutZ45vtIcnCoEeX5pkJ9viv8Th/mCaEu7KtKr?=
 =?iso-8859-1?Q?iH+0567Dqmm8MoRPsr7QLu08Kkm6R6zyU3jjV8xownFx7QCxxI8Di8qQnc?=
 =?iso-8859-1?Q?I4Sb4AVBnXSYGPo8ez6U6KDiEW3SHkRwdKDIy/l8NmfGfotY2nSOsgdzBo?=
 =?iso-8859-1?Q?+ndWQp1OwYZbiABDBw/sZvfCWwCgQ9YAi8fZ/spIS9NfpDKFzSmApJnE45?=
 =?iso-8859-1?Q?1w05P8OUQZ1+OyFItlHHEegFvrLzMiq5t4qYMDKMrp/C0iqV9iT+T1U0e3?=
 =?iso-8859-1?Q?T6I43v7Dy626bvMM1LaweWsxQ4ZZRnHqX3udWT0Woi8M6jbxmrYsKVDSRM?=
 =?iso-8859-1?Q?tCgfZ9QWHPGqBXy8MBKG4QjNbDoKDds31sxzYtNYzTyyP+E81J3LARq827?=
 =?iso-8859-1?Q?bXvD5KIZw1arwXo4H9WMJPzHngi7joT7u0hpGEScI7DlnNT2w1hHBocjt+?=
 =?iso-8859-1?Q?HtJRp31V2XphlRyPbkCwZ0X7Trb9ksPcqwiB6wC7LU+LoqvMelroCYI8cN?=
 =?iso-8859-1?Q?oBf+tlr+Hw0fZ+NfbjcF5ZiHwb8Klpi9uRk03vjE2YZ2SyrG82JU9XGUf8?=
 =?iso-8859-1?Q?dSRACC8Lgk3zvkxdI3190oWP27hnvVVLwLa6/rJ7DB9b+lzn3V/TcZzB1t?=
 =?iso-8859-1?Q?laTt5fTslOYmtJChoz6F12FC4H/FfHlObsteJpum1yU0DhcNpSuEPbiQaT?=
 =?iso-8859-1?Q?ZFNc8TQEPvX8auzboG1P/sP6A4WUcD8DpYXxkzqWwCFWA14bkby2bPbwkM?=
 =?iso-8859-1?Q?0ee7jOTU6YwS4LxJ89xqvA+K3xiga5CUiqANfDWkqbF+/se+HVc883L8Xc?=
 =?iso-8859-1?Q?H3MVWMkD1EwGy6wwMMuaDxHm4knBQSc3Xi5/N81oQnMyZZYpg8SadX9LJP?=
 =?iso-8859-1?Q?k9Y5sNZBp+kIIOwDdOzNX1wMPrxwt7YULRbBV4kSSayY6a6SQSLfd63aSl?=
 =?iso-8859-1?Q?BszDdJdBJCvV1Av3rO+kzsD9of7AYUNCwt9hAJqVDC48SfiIu5/HbqLZCt?=
 =?iso-8859-1?Q?EzCd2tXM+4jgxlAZNduC7Ol1QEPCr5D0KsTPoSERuWZhB1pAhAQ/s389/b?=
 =?iso-8859-1?Q?0mSONlzHF9lNB38Xq/6oXta5VbgBcA0pWkfoScZP3qLzVsHenuqy3sDNY9?=
 =?iso-8859-1?Q?e0LSJbnzgMN3zQHPeNJq7PQbkHoed584O99/UPiTo2Hyw+atT/Aj2DkgXg?=
 =?iso-8859-1?Q?n753EgO5qkXIfB6POPaCyB3ScWo6CRflO/O+znZosBvStS57kQTS2smsRA?=
 =?iso-8859-1?Q?LyXraZyvua2thWZ75Mhy0sRmmXWLAC49BGJBli2Ans6dqSu0PKGpF3L2/E?=
 =?iso-8859-1?Q?OfaA=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: conduent.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN8PR20MB2674.namprd20.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4ec941a-16a6-464e-ed1f-08d9aea1cf0b
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Nov 2021 16:53:43.4329
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 1aed4588-b8ce-43a8-a775-989538fd30d8
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9etCgXMz/wZyC3B/qsjVxGoKIQ5xMgwY7n6Q0ydO5COqySRd3ofgIz91YO1ddzTvDWL7ilo3ofHHpxpApZQNktGeQC7x/efMXGUNtWOeAgM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR20MB3800
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

OK,=20
So in this case we 'only' have to follow the version for the distribution d=
ate and move this at each EOL distribution date.

I understood that this kind of evolution is easier than a kernel evolution.
Could you confirm please ?

I will stop boring you after :)
Thanks again for your help.
Best regards.
Fran=E7ois

-----Message d'origine-----
De=A0: Konstantin Ryabitsev <konstantin@linuxfoundation.org>=20
Envoy=E9=A0: mardi 23 novembre 2021 16:33
=C0=A0: Fernandes, Francois <Francois.Fernandes@conduent.com>
Cc=A0: webmaster@kernel.org; stable@vger.kernel.org
Objet=A0: Re: [External] - Re: EOL Kernels versions

On Tue, Nov 23, 2021 at 03:13:46PM +0000, Fernandes, Francois wrote:
> Hi Konstantin,
>=20
> Thanks a lot for your quick answer.
>=20
> I found some complementary information here :
> https://nam12.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fitsf
> oss.com%2Fwhy-distros-use-old-kernel%2F&amp;data=3D04%7C01%7CFrancois.Fe
> rnandes%40conduent.com%7C8355a82766034b094ec108d9ae969d28%7C1aed4588b8
> ce43a8a775989538fd30d8%7C0%7C0%7C637732784185975483%7CUnknown%7CTWFpbG
> Zsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%
> 3D%7C3000&amp;sdata=3D%2BxlJ%2FkE5XFTPRmHn%2FUBtGjPnpv3ThpJc7Q88DgUpuwI%
> 3D&amp;reserved=3D0
>=20
> It seems that even if the kernel version is EOL it's not a matter=20
> while the distribution version (in our case Debian 10 (Buster) is still u=
nder support.
> Is my understanding correct ?

Yes, distributions may choose to maintain their own LTS versions. If you ar=
e basing your work on a distribution like Debian and aren't shipping your o=
wn kernel, then you should plan your work around the distribution's announc=
ed EOL dates.

-K
