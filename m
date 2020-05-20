Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 394FE1DB107
	for <lists+stable@lfdr.de>; Wed, 20 May 2020 13:08:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726720AbgETLIH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 May 2020 07:08:07 -0400
Received: from mga09.intel.com ([134.134.136.24]:13228 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726403AbgETLIG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 20 May 2020 07:08:06 -0400
IronPort-SDR: Mt1B8oiSAnkHKDdy+eDtqSeCpqZ5a4Y4gqmbgJ75yk7cZ84dORPF4wRyOZ701c7K4cJq7GZ7UH
 ow8/E7yiwWQQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2020 04:08:05 -0700
IronPort-SDR: QEbYhe/G0CwJSICRZSrL0CKehCBbpgtnzv/y6ZcjfV+NoiK4vzQKofFVHja9i3h4o8clF6g9p6
 rAhJAb28HhIw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,413,1583222400"; 
   d="scan'208";a="466347503"
Received: from fmsmsx106.amr.corp.intel.com ([10.18.124.204])
  by fmsmga005.fm.intel.com with ESMTP; 20 May 2020 04:08:05 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 FMSMSX106.amr.corp.intel.com (10.18.124.204) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 20 May 2020 04:08:05 -0700
Received: from fmsmsx605.amr.corp.intel.com (10.18.126.85) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 20 May 2020 04:08:05 -0700
Received: from FMSEDG001.ED.cps.intel.com (10.1.192.133) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 20 May 2020 04:08:05 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Wed, 20 May 2020 04:08:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bTMmPQHgzsDYEeMEGE4tDrqUN7ZjIw2rOyuXHqzM1kiLMMYc6AU638QoDIT6WIEwCOzqO02JgkyxsoCvGB0VYcGSkecsnO2yFrkuC3A5eXtRa5T6sC8ggi3h7y0mD9ENB4uxLzvvC7rYSFtvHu3K/LqntrOhI72+ss3xnBLyOkiJ8T4z7656+KkNg39qIYmClr7Ix/BJLJQej6IHgM7wQYI/HPNkwXHWnVkKmctuyQPFrs/U6yeicsrYZXX+svoANvRhpC9pBaiDOVC8GTM2grsv/RtiY2UmPD4LqdXQJhdS7IbLUw0vqLNPm7j/FcIFFB0+tI24OJMAL3/T+GDhaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u8jZegypNBg2fYQLMu+h1HSa0Hdm8V6MNWjkOtgY3ps=;
 b=IYLAaptvVkCEN+lBaxiqFpNsqVEPEXoxJnyhJC702wPdh2T7fibOFDB0Z4JZHZ1QpOzg59v+gTRSljDFiNj4A4PzOh1/yDSyGHGuitkpfsHcPxdW8ftkhkCXUhAO+1fZlEFo1UED4dkLxwZI2VtVF+kUI3AIwhwza5AuHrRhOdVDON81d6MjnoZeeY3cz3Jnym8pJ6w+L+G6biXrK/bk4kAc77OyW8SHO/4sxnh34MwuVCYZgZ1kmnmXdGFbuYBwPbWeZlGnBYNhm8l1RhPach/HpkJhc0jf/gC/rVUs0ZPlzyHjITQbqtiS09GR1WfapjqWmLGPxENSvgL94npeZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u8jZegypNBg2fYQLMu+h1HSa0Hdm8V6MNWjkOtgY3ps=;
 b=hgIpPUf8XBYf0O85r6Z7Vx9jD97995bHcDMQG4S3nnOjC6g//IYTF7ZJrgqeLSYDbj/Xr63H3h5eyF6IZkkiG0za7wSzzPRvNxoLHxhZ4QkGzSRPdNrKe7hnHnLvHNgydgYiHIKlFco/VnO3ytayjWlx1sJRnRciXV9iTU1sHNI=
Received: from MW3PR11MB4665.namprd11.prod.outlook.com (2603:10b6:303:5d::12)
 by MW3PR11MB4761.namprd11.prod.outlook.com (2603:10b6:303:53::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.23; Wed, 20 May
 2020 11:08:01 +0000
Received: from MW3PR11MB4665.namprd11.prod.outlook.com
 ([fe80::4dbf:49cb:dc7a:5b3d]) by MW3PR11MB4665.namprd11.prod.outlook.com
 ([fe80::4dbf:49cb:dc7a:5b3d%7]) with mapi id 15.20.3000.034; Wed, 20 May 2020
 11:08:01 +0000
From:   "Wan, Kaike" <kaike.wan@intel.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>,
        "Dalessandro, Dennis" <dennis.dalessandro@intel.com>
CC:     "dledford@redhat.com" <dledford@redhat.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "Marciniszyn, Mike" <mike.marciniszyn@intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH for-rc or next 1/3] IB/hfi1: Do not destroy hfi1_wq when
 the device is shut down
Thread-Topic: [PATCH for-rc or next 1/3] IB/hfi1: Do not destroy hfi1_wq when
 the device is shut down
Thread-Index: AQHWKAtYj9gYAc53PUOvXaZcprmNbqiwKosAgACxejA=
Date:   Wed, 20 May 2020 11:08:01 +0000
Message-ID: <MW3PR11MB46656C9E5A8EE58F229AE99CF4B60@MW3PR11MB4665.namprd11.prod.outlook.com>
References: <20200512030622.189865.65024.stgit@awfm-01.aw.intel.com>
 <20200512031315.189865.15477.stgit@awfm-01.aw.intel.com>
 <20200520002634.GF31189@ziepe.ca>
In-Reply-To: <20200520002634.GF31189@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.2.0.6
authentication-results: ziepe.ca; dkim=none (message not signed)
 header.d=none;ziepe.ca; dmarc=none action=none header.from=intel.com;
x-originating-ip: [72.94.197.171]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: efc7532e-2692-4549-fca8-08d7fcae0f96
x-ms-traffictypediagnostic: MW3PR11MB4761:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW3PR11MB4761EB84DB12E7D91BF9A3E4F4B60@MW3PR11MB4761.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 04097B7F7F
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FV3whXdhbUVxC127XItwvvMmLXrl5DY2EQuaxOrBk3XI2AykH5j9zWRSkqBR4U78fN2SSIxkAMEydiOEPODjlxltFz5/jQFCOuHaG/qAG99o3N3PbMfnaUL5t3/wAkZfpX7ScTcpjPQ15mBpbyri7bcjMY6EiOHFWHAkz3pBDt51no5DXap3oNKk2NZ4qFB6eRlXeT5EvVcdUYtsT/ox88dCVADoSkawNw4byl3nw0rHfuZQvojfW2s7Px1JUVSkDQWf2V1oSigzwWnrehcXJHPCR7E+VauB6oWxDBXd0MkfDQUHt3t8dO38+ab4BhzK
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4665.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(346002)(396003)(39860400002)(136003)(366004)(376002)(7696005)(2906002)(26005)(53546011)(316002)(8936002)(86362001)(8676002)(478600001)(55016002)(33656002)(9686003)(110136005)(4326008)(54906003)(5660300002)(6506007)(186003)(71200400001)(66946007)(66556008)(66446008)(64756008)(52536014)(66476007)(6636002)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: cmyIJRFwjYPNSDUeF271X6HBnbpOf3rOJXXNjDkuIcgMvxIqGPJtdSXdYYEgOoBH3dCoaysOrv/6/ZuPPO0XHOSzye5JodnrvgsQBekosyhseIeCYwluBLaCGxXn4AF70ApuLAjRVZLNhVc+8gDwScii8vX3pxv1sq8lltloUzIROLZYcUq3gc0lE2FEq6ZBMcBGYkqL6qRtIihZqRB6WxPLbh2oziQ64yMbw8oJJEe+jYQ/U4O3/mR9VBv6Jy11/9DvpTfRDkkTTP9cjf6GSopEzUTxRPuAXoLjIEToXYU7J1Kv5V0mqsMmkBc9uvj+IMXl58lesKyxkqXu0KhTSCnWoT6bMU6UyGdu59YMmtVg8sg8Zf5Apy8MELuktd9wk1a3eDz/JSdcOgbvAVG+bbx4B5d67r/80tUuGfBrdc4i3o+dWHIWYPe8u/cymDm6yesOhpizKghBQvZMpo4MvLaHf0hJk+jAMRICPa1a5vA=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: efc7532e-2692-4549-fca8-08d7fcae0f96
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 May 2020 11:08:01.1331
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Xm0SWPdcq+AEzuIxpBJFbTkqf4l7pXjsi30Q+Gh+N1vzflc7iCJKgooQfvjE6TVa28CTgmAMnK73GpEcxazTug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4761
X-OriginatorOrg: intel.com
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> -----Original Message-----
> From: Jason Gunthorpe <jgg@ziepe.ca>
> Sent: Tuesday, May 19, 2020 8:27 PM
> To: Dalessandro, Dennis <dennis.dalessandro@intel.com>
> Cc: dledford@redhat.com; linux-rdma@vger.kernel.org; Marciniszyn, Mike
> <mike.marciniszyn@intel.com>; stable@vger.kernel.org; Wan, Kaike
> <kaike.wan@intel.com>
> Subject: Re: [PATCH for-rc or next 1/3] IB/hfi1: Do not destroy hfi1_wq w=
hen
> the device is shut down
>=20
> On Mon, May 11, 2020 at 11:13:15PM -0400, Dennis Dalessandro wrote:
> > From: Kaike Wan <kaike.wan@intel.com>
> >
> > The workqueue hfi1_wq is destroyed in function shutdown_device(),
> > which is called by either shutdown_one() or remove_one(). The function
> > shutdown_one() is called when the kernel is rebooted while
> > remove_one() is called when the hfi1 driver is unloaded. When the
> > kernel is rebooted, hfi1_wq is destroyed while all qps are still
> > active, leading to a kernel crash:
>=20
> AFAIK the purpose of shutdown is to stop all in progress DMAs.
>=20
> If devices are wildly doing DMA during the shutdown process then all mann=
er
> of things can fail, including kexecing into another kernel.
>=20
> Do you achive that with these shutdown handlers?

We did try to shut down the hardware and will address some software issues =
in next revision.

>=20
> It does make sense that the work queue would not be destroyed in
> shutdown, but I'm surprised it doesn't flush it?
Will do.

Kaike
