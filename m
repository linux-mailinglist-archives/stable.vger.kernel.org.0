Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAE0844447A
	for <lists+stable@lfdr.de>; Wed,  3 Nov 2021 16:16:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231694AbhKCPTS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Nov 2021 11:19:18 -0400
Received: from mail-mw2nam10on2118.outbound.protection.outlook.com ([40.107.94.118]:61761
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232721AbhKCPSi (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Nov 2021 11:18:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lxBT2ribGYrrtOHTxRZBVaopRLpd2yHDPkjkqWQnu9wX5+eHs+NQhgUOsg64oWAwzJyB4MEOiPYgsI2xAUvhJ6o50zX8VoeN9BAoU0Tu0xmm5d8yT6AKid+D2Q8gsH1j/FM43bNRxU/nCFJT8oL4H/4r9FHIVdlVBL1mSDIVWhgXiOdPBwVjAhmva5uuj3CkfYypwcxJ0ms09kjWVSwbUPcdpCIAVfmRfB8uaKjhvPC8da1jFtRy4d/SqlTMa1G/C+tMGc8SiYQZhO3k/IeqxI0GO8DVijy291Q6M+K6nnD/3xudYn+QPILAmSZ3vJRkAT6GIbJRqRsKBWF6Fwg7VA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0e4Eav9qEHnbwWbgPIj04qqb9rgcTu5gaFvXPjC5N4Q=;
 b=Ua9y7pZWr8ryRrYQQMIb16gCZPb1dZe6dajJ6NFvU0/dopermSkjaAaib+7/Etemv21EDWvck49mGHD7HN89d1RLqsKSaoK9ydxbLinv2idWGzTfz7q4/F6F1pZf/bgfNSoyFDh/j129lQArOnIP/coEO1HXu1h2P/9uOQGFqo1bQBom0jXDBq6SnUu73Z0xLRJ73y3RNfZ/QXAvv6rQvFt2uATtKsxRz8sO+IVqS4D5jecyR+0o3umznXxGIjOrdWtFMDPTzQOlGVncoQNWVFwoMcehDaN74gMpCYgGhb6pPc2DAIsn92X6Qq4CDjwnj6zg/aDYsgghSJFDv75vtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cornelisnetworks.com; dmarc=pass action=none
 header.from=cornelisnetworks.com; dkim=pass header.d=cornelisnetworks.com;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cornelisnetworks.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0e4Eav9qEHnbwWbgPIj04qqb9rgcTu5gaFvXPjC5N4Q=;
 b=cL6sDQ8M32xT8gTYYVI7joEvlWVLTsYdWZ0EBqIhpsP/T7imx11dvQIqegFPdgEoUzjofFZio4Ih8rq8VquEa2hp7z++feZAQHvGoQ1t2ea+7gZ4A2FO7nFT9p37f1Xw2WXiIio4QpvgRiDSmV+KksNcH4cM6+Pvi153+Cawy5tEBz0US/zSz7ok66/oFk4AjooDTYCT5pxZM4SlJ2mDTabdgfixfupUU4mto6WYgwKHcZnKjATeTi/54VVOcGIFcjQXiKbMYF4ud5VKRrJqIpyzC51k7kUo15p+wHdVfzzp3p4A7yiMDPf989AvsrFPjebnSMLaH/ABSSUFv//3TA==
Received: from CH0PR01MB7153.prod.exchangelabs.com (2603:10b6:610:ea::7) by
 CH0PR01MB6876.prod.exchangelabs.com (2603:10b6:610:101::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4649.15; Wed, 3 Nov 2021 15:16:00 +0000
Received: from CH0PR01MB7153.prod.exchangelabs.com
 ([fe80::bdea:4e22:1b89:24e0]) by CH0PR01MB7153.prod.exchangelabs.com
 ([fe80::bdea:4e22:1b89:24e0%7]) with mapi id 15.20.4649.019; Wed, 3 Nov 2021
 15:16:00 +0000
From:   "Marciniszyn, Mike" <mike.marciniszyn@cornelisnetworks.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "Dalessandro, Dennis" <dennis.dalessandro@cornelisnetworks.com>,
        "ivansprundel@ioactive.com" <ivansprundel@ioactive.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: FAILED: patch "[PATCH] IB/qib: Protect from buffer overflow in
 struct" failed to apply to 4.19-stable tree
Thread-Topic: FAILED: patch "[PATCH] IB/qib: Protect from buffer overflow in
 struct" failed to apply to 4.19-stable tree
Thread-Index: AQHXzY3FmZbXyB3jX0OtQXRsZ2x9savx7vCw
Date:   Wed, 3 Nov 2021 15:15:59 +0000
Message-ID: <CH0PR01MB715319BCF6C1A8C0F1F631C9F28C9@CH0PR01MB7153.prod.exchangelabs.com>
References: <163559866411243@kroah.com>
In-Reply-To: <163559866411243@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=cornelisnetworks.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 83e7fbb9-e128-4445-e560-08d99edcd7ca
x-ms-traffictypediagnostic: CH0PR01MB6876:
x-microsoft-antispam-prvs: <CH0PR01MB68761A2E9B81C417277B1B65F28C9@CH0PR01MB6876.prod.exchangelabs.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: flq8dhhYMKd+DwTN1ekz9sVPfX5MovNFrc5bDOojYyCp+8T5Y2bqfK0r5/ouiwdNXla+njn73D+pZFWd1bXtmirqFo6M5YqVHnt5lp+K3BpmwHgxtlC/dcO3vigp5T5nEsBxAT3DRLBYvaVnpNqDS44BvHl2ynvvICYmb4L9Q3nZlQrHnzo+E6xjl+Prnx214y7Lb+Zy2MQJHWhdsEfdSrN0e3Qm4l2qMbKvB84RM18uyi1KJsz0B7pqsdKc5YPIKxq5OPc/cGCoxmCcGjm+Y0Ske9tqk6A0pCaTj/ythADgDQB5ORHP+TK4qZkEmDG/bbU7rAf54kps/u4cL9WlM/Wv6f7io8rpYmk6+FkbUNjI6shau3fW709PZZcQ6dNDQr79ST9NvWazJvNLuu5q0LkF8RljQ5s1v2fg+wV93ISijkGNmABeZXEDi1NweQzJc9tLltsr75IlA4VZrjoGsic3T5MfgBNi42bAv46AsC1/v9/XSV2qKhR9sPmx+37UYfTYuIiXChxSLWCKFKKe8iHT16PbcOfJ33I+kbGc4s6HdbafxboyjNJMaEf+l6i+eH1vj8BcOXDJ2SxfKBEI6cCNOtr5+hbw82O5djSE0yLmyi/XuGhP/mcVWq9VQ0X3dARy0O6SIl4sovvI7yp8jr/iULI/bsS/s3Uv6UZeXbOvFiJglI+qOqrO1GqZ4YMZEk1hY0HTOZJDADcmOnzfqg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR01MB7153.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(39830400003)(376002)(136003)(396003)(55016002)(4326008)(38070700005)(83380400001)(4744005)(53546011)(66946007)(33656002)(71200400001)(122000001)(8936002)(316002)(64756008)(66446008)(26005)(66476007)(110136005)(7696005)(5660300002)(76116006)(52536014)(186003)(508600001)(2906002)(9686003)(86362001)(8676002)(66556008)(38100700002)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?fmFID4YkKolsU2HSDf7v5139D+cu5B4FewbA3XXwPGVX/HYoZPKXN/5Om9nA?=
 =?us-ascii?Q?WXaR8zTyBxjwv56rNXl2Sdknum8/5rM+A1Jap7mxrjzD+s5l8djyfv8NBu1a?=
 =?us-ascii?Q?rXbZEzuzYdWECZp28J0hdhb8nYg/FwvR0+IklvGHo8sHbeJT22fhMuQTiW6y?=
 =?us-ascii?Q?DIOB6Lq8G6f1Koj0JsVhq+vALejHUV8PWQEvcwM6cPePCKV/QG2jkdnn/EAA?=
 =?us-ascii?Q?3GZ+ecU5Eh7imcbpM75cQSV05h61g/zJYhlhIQnizB0eP3/q/5/rp9veHp4g?=
 =?us-ascii?Q?igOMaA5mXPokwXDI3fmKiGZs2nxaGCV+pdyJui/R9QV8qzToyA+WmSsqjCTe?=
 =?us-ascii?Q?+GUUz6SHferhMD+TzsEi+uBEASl/lQ4U4nN4ikr/8mgd0+SwVrrohhekWxkL?=
 =?us-ascii?Q?RoD+4bqQBXVeYQFx8GIZwPMN62HBzHHUmsHW9vurve3ts4DnetzGwcfNu2JX?=
 =?us-ascii?Q?02pTWFqxRkGW/SXDdT0LciLi9KIc4/r5MOc/OrjDDGwCrAnmPMMaoFhzYKCx?=
 =?us-ascii?Q?p5l+bY2nZUmfDD0/GLzVWHJP8dv50FSCgkncgP+KjgKPFKUdtH15Gj/auZSi?=
 =?us-ascii?Q?cBRQ+XoPFnr9XgfW+YcNwXsAtn8TV90dnd9LO+Qty9cnOSKrxCJsIiUH/u0W?=
 =?us-ascii?Q?S17oe1pn+qgJI9ePcRkTDKRXTa/IP5C7atPCM2RfBIxdWsqlprmh+f22e37d?=
 =?us-ascii?Q?GkONjGLjo9wJh1/pHiWG7zz+5RYwfC/bd8HuMszZYSxPVqT0Zzf/TJhdUwdo?=
 =?us-ascii?Q?iTj+WfOV2jbDPU+IqHLzP8bBOvy4xrvDwRtSeWxGtT7IauHGfFgD7zZfZXAw?=
 =?us-ascii?Q?p2o8pUBOWz8d6T0AC2jOnUT1Y7lDKYqw1j8Uy37+Oa+twzuC2RcOZhUtXGY6?=
 =?us-ascii?Q?M/swNb3tD0hOmOQwNIxRFZB8D8KrwNZSZfIFznH1ij4OLnn3jBBsCpaw6ojn?=
 =?us-ascii?Q?7mxu8knl0C7G/qq09QVf+WbYcly7ModjnNQTt2IOqTSXZLNrobKLp3hIHCgd?=
 =?us-ascii?Q?/50lP0nii8LLMfB75TX77MC20Zdp5oQoJgAFXxas7oTkYvGwIOUl0bsi+2YU?=
 =?us-ascii?Q?gT7ch869IHZ9OHlo0ywhWJ599TCzsHQlPYZgRLoTe9J8mTJ+9vaBo9XCC+IF?=
 =?us-ascii?Q?Se+aBGagPC+TJqa9egAmuzX3yszT//UYWIQ6FUiSSLcqtPuSb81vLymzJhZk?=
 =?us-ascii?Q?nBUhNoZdWtTJyEvTjoaWA2sbBO5yN/UhrZjJrzWOf/UK6ufhr6wB6hxMI+SK?=
 =?us-ascii?Q?u6vbVymnncJUutu+VYu/gYS8JNaHguFIzzpE8ml1z/flNfJs0kebp1CBu0Js?=
 =?us-ascii?Q?sNfrVvCds/dy0+euXAR2T45lovBR1TK0MtrfU5UxR2Y2sjJyAwPduiZrAq1W?=
 =?us-ascii?Q?SdMjOqvUU6r5wvBfq5hBPbOC9B++3ryezGRduh+CoSOmSGUSSJ6jK6X2udtz?=
 =?us-ascii?Q?8bfzoj3Be3iM8WJPr/wS+dJ3eV97ovWRsii9P8JghIcH3++GFErzB3BKkC7v?=
 =?us-ascii?Q?kkFLLHdr02izRd/edOjM5EtabzpKegt1Qgl9AZtvRijJPqJBoki3QBB2Mqjd?=
 =?us-ascii?Q?rgZkIvj+hIQunWR9J5ryzsidvu3vXapFy+tIVD6FpU3axGEb7FRTNfdMIuLr?=
 =?us-ascii?Q?QFU/jf4ZDvL1TnyfPPaFP7L86spJB8r91pyaFP4lMy+TnLZ4A82wiPjD4pqr?=
 =?us-ascii?Q?XeNEr28vVisShBsqvEKWfLiJItIvFEdl335zbdjURI13XGXt?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cornelisnetworks.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH0PR01MB7153.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83e7fbb9-e128-4445-e560-08d99edcd7ca
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2021 15:15:59.8723
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4dbdb7da-74ee-4b45-8747-ef5ce5ebe68a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KFI/KQo6pWYVypynzxRUsPZob71Pn868Oy3oAary0MJ3diCH3jXotjumRQxmavP8jvp92Kmk6KJADv+SllOcvowZ7wMQSRd5casIpfG/+QzijsIsEfmOgCdnoMgApVzy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR01MB6876
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> From: gregkh@linuxfoundation.org <gregkh@linuxfoundation.org>
> Sent: Saturday, October 30, 2021 8:58 AM
> To: Marciniszyn, Mike <mike.marciniszyn@cornelisnetworks.com>;
> Dalessandro, Dennis <dennis.dalessandro@cornelisnetworks.com>;
> ivansprundel@ioactive.com; jgg@nvidia.com
> Cc: stable@vger.kernel.org
> Subject: FAILED: patch "[PATCH] IB/qib: Protect from buffer overflow in
> struct" failed to apply to 4.19-stable tree
>=20
>=20
> The patch below does not apply to the 4.19-stable tree.
> If someone wants it applied there, or to any other stable or longterm tre=
e,
> then please email the backport, including the original git commit id to
> <stable@vger.kernel.org>.
>=20
> thanks,
>=20
> greg k-h

Greg,

The only thing required for 4.19 for this patch is that:

829ca44ecf60 ("IB/qib: Use struct_size() helper")

Is there first as a prereq.

How do you want to see that in the signature block meta language?

Mike
