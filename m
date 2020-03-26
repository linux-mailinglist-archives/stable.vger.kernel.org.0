Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7491419472B
	for <lists+stable@lfdr.de>; Thu, 26 Mar 2020 20:10:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727939AbgCZTKB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Mar 2020 15:10:01 -0400
Received: from mga18.intel.com ([134.134.136.126]:42245 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727026AbgCZTKB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 26 Mar 2020 15:10:01 -0400
IronPort-SDR: VnhhbmqcK03AUNaK8/hLJGgcMiPXRESvhKAxFJ6+zerpzKR8huq/oLn77fqVFSVV5ua5rwmj5y
 9WxK8Zy4bmFQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2020 12:10:00 -0700
IronPort-SDR: 4dcpgXMraPs8yCJO7PTAu1N6/KWLtsnYoGK8tb5dwfakotgEF0JBI7NjFTBLhZfK9pMXtpl7to
 1rkvOPqYoEkw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,309,1580803200"; 
   d="scan'208";a="448740668"
Received: from orsmsx107.amr.corp.intel.com ([10.22.240.5])
  by fmsmga006.fm.intel.com with ESMTP; 26 Mar 2020 12:10:00 -0700
Received: from orsmsx155.amr.corp.intel.com (10.22.240.21) by
 ORSMSX107.amr.corp.intel.com (10.22.240.5) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 26 Mar 2020 12:09:59 -0700
Received: from ORSEDG001.ED.cps.intel.com (10.7.248.4) by
 ORSMSX155.amr.corp.intel.com (10.22.240.21) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 26 Mar 2020 12:09:59 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.109)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 26 Mar 2020 12:09:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vf8uAvg5kdQIGT4WR4MZX4CBMzbGevp3BXSw/4c3hUU9PgybXrfyxgjIo06733hLSMckYDfSHZWWUSkXcJKNlaEX6XUJ/kTJmlxgDcezmKYLf+j0jWS/zIwk8qmjHxxIkTawTvfBPQ8MgS8UnoXST9sHFvsotX0yQaEY8ljdFiufIozGVbHFNHktslupe6qTRBUH0Wk06Sdyy0Va+8vAshnRKYqrM2mOHaxdRlYiOlUYcB8cH1YRnHRJc+qkNOISn0bSvZ39SObcRiY4umU5p1jcCd5/ixTZfVJc6rkmBy2GBCWp9cVUE/7y0UJFLVxZBwBVhDvNqRRby6x23PSlbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I/KRgniaiGJdA3NXncdS1cViFxKtz13vn7qYt9D2BPU=;
 b=jOo1dgj9J45JQFMaCZ31fXp1sNOGd9DRpyOrmwwCTWPgqEshny4oQYvXOfyROeFjtWdhaMicVrc4ERqBqMxevXB/t86N+azEIZmKsnc89VXwcRkPOUjEmyrrAzZn1pFGDyJHJbLxfQp091pQZZk2IFxOm5vxuwVWeusMLl5TRx2Z0z76xTh1Ib7/0HlaWK9yTWaNjdzoH0c/SSubPyG9LMMicSLU/ncoTpDStqQD9NJD0gwC3BFUYA/gB0mYLEXMxXRfPtOOyiTTWL3vNrNjSPOBFU3JnjJnUI5UYxTtsFj6Wq1mc8Gy2reYlACuoN6mPCGW3Hwibo6e/JN7K0gCNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I/KRgniaiGJdA3NXncdS1cViFxKtz13vn7qYt9D2BPU=;
 b=EsJoDBH5PpJ7p5bzd4v23rb0o6T+/TQL3CUU//zCjg09BxPrEij65E7PmKt9LQuCt5NEzu5ko5x4tJ3slyDU9Ws/SriVcNT/+hXqVncF9qe77i1anxpjR/KZtbr0Z4xrOJFkS92Nx5L7kbtgqBiqqDGP0rcR5WvqGlXMHMaGh0E=
Received: from MW3PR11MB4665.namprd11.prod.outlook.com (2603:10b6:303:5d::12)
 by MW3PR11MB4763.namprd11.prod.outlook.com (2603:10b6:303:2c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.19; Thu, 26 Mar
 2020 19:09:57 +0000
Received: from MW3PR11MB4665.namprd11.prod.outlook.com
 ([fe80::c008:bca9:22e9:4dc9]) by MW3PR11MB4665.namprd11.prod.outlook.com
 ([fe80::c008:bca9:22e9:4dc9%4]) with mapi id 15.20.2835.023; Thu, 26 Mar 2020
 19:09:57 +0000
From:   "Wan, Kaike" <kaike.wan@intel.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>,
        "Dalessandro, Dennis" <dennis.dalessandro@intel.com>
CC:     "dledford@redhat.com" <dledford@redhat.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "Marciniszyn, Mike" <mike.marciniszyn@intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH for-rc 1/2] IB/hfi1: Fix memory leaks in sysfs
 registration and unregistration
Thread-Topic: [PATCH for-rc 1/2] IB/hfi1: Fix memory leaks in sysfs
 registration and unregistration
Thread-Index: AQHWA40Awes0Rgb8RkWMlfzLNuNxCKhbIAuAgAATmUA=
Date:   Thu, 26 Mar 2020 19:09:57 +0000
Message-ID: <MW3PR11MB466550446C9C322CAB52AAE7F4CF0@MW3PR11MB4665.namprd11.prod.outlook.com>
References: <20200326163619.21129.13002.stgit@awfm-01.aw.intel.com>
 <20200326163807.21129.27371.stgit@awfm-01.aw.intel.com>
 <20200326172541.GM20941@ziepe.ca>
In-Reply-To: <20200326172541.GM20941@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.2.0.6
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=kaike.wan@intel.com; 
x-originating-ip: [192.55.52.215]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: af47eb63-1b8f-4f01-e9be-08d7d1b94626
x-ms-traffictypediagnostic: MW3PR11MB4763:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW3PR11MB476390D36C562F958B6C06C4F4CF0@MW3PR11MB4763.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0354B4BED2
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(136003)(39860400002)(396003)(366004)(376002)(7696005)(53546011)(66946007)(9686003)(110136005)(54906003)(76116006)(6506007)(64756008)(66556008)(6636002)(2906002)(66476007)(5660300002)(4326008)(52536014)(66446008)(55016002)(316002)(81166006)(81156014)(26005)(71200400001)(478600001)(8676002)(86362001)(186003)(8936002)(33656002);DIR:OUT;SFP:1102;SCL:1;SRVR:MW3PR11MB4763;H:MW3PR11MB4665.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ReBWtGbaxnGRjFXV21eTJxhhliJ5uHzJX1xCttGeCEMgB76QEBypOtv7mJfOIh2NbR2wXuRwf4sW6tvdA0EateEIEkFmEMn/sFaeWzXeD+BHkxioZ54ZqMxpHN68Ljtyx3Lq2xLC0I2IoL0bqsMRK9WGdp6SDnGvJfLyU62GnHnXyQ17zj66DfoUDrmzPp4kKQCX2SNE6t8k+XYI4EByURxh6WrtHJx7PjTZ3n0OvSV+aLqWiKZqRtlNNC6koOObOsqYDhH9fXwF8SvRo9rdGDt+FM8ZUFNpA+H+YnO50E30Upook0phP2jhyJYukLm6IhCgCm1PhicQ4EonHJ8U76lqeNPS5l6gGUFf8Vu3hYlflLIVVIgxyF2HbMr33+9DjZOU+Af/aBhriUKtdbHHLEJuK91JmOo78zNAVYnFtWQ0eylOb74PH++r7tE80krU
x-ms-exchange-antispam-messagedata: qCRTjKghkQNXGVi89vKyxAAvaahMHV6Q1PTWdQr26+DyCPs9bs8qTPNA9n4wribEpENQd3kEbq4+X7dnzkoqsRCFRwggx+yB6sBKCMt2PuuWwxOrF2DtlFT+AgRuFibdGWM2aGad8zjfsgPAMiFZaw==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: af47eb63-1b8f-4f01-e9be-08d7d1b94626
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Mar 2020 19:09:57.1065
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pIzyLnCfQBAK1kHyCbpvhWgYHKyrveIqRWlwd/t55xJlJUXJakary7sZglWV0d+sqIiQZAwdDh5y+is1LYU5kg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4763
X-OriginatorOrg: intel.com
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> -----Original Message-----
> From: Jason Gunthorpe <jgg@ziepe.ca>
> Sent: Thursday, March 26, 2020 1:26 PM
> To: Dalessandro, Dennis <dennis.dalessandro@intel.com>
> Cc: dledford@redhat.com; linux-rdma@vger.kernel.org; Marciniszyn, Mike
> <mike.marciniszyn@intel.com>; stable@vger.kernel.org; Wan, Kaike
> <kaike.wan@intel.com>
> Subject: Re: [PATCH for-rc 1/2] IB/hfi1: Fix memory leaks in sysfs regist=
ration
> and unregistration
>=20
> On Thu, Mar 26, 2020 at 12:38:07PM -0400, Dennis Dalessandro wrote:
> > From: Kaike Wan <kaike.wan@intel.com>
> >
> > When the hfi1 driver is unloaded, kmemleak will report the following
> > issue:
> >
> > unreferenced object 0xffff8888461a4c08 (size 8):
> > comm "kworker/0:0", pid 5, jiffies 4298601264 (age 2047.134s) hex dump
> > (first 8 bytes):
> > 73 64 6d 61 30 00 ff ff sdma0...
> > backtrace:
> > [<00000000311a6ef5>] kvasprintf+0x62/0xd0 [<00000000ade94d9f>]
> > kobject_set_name_vargs+0x1c/0x90 [<0000000060657dbb>]
> > kobject_init_and_add+0x5d/0xb0 [<00000000346fe72b>] 0xffffffffa0c5ecba
> > [<000000006cfc5819>] 0xffffffffa0c866b9 [<0000000031c65580>]
> > 0xffffffffa0c38e87 [<00000000e9739b3f>] local_pci_probe+0x41/0x80
> > [<000000006c69911d>] work_for_cpu_fn+0x16/0x20
> [<00000000601267b5>]
> > process_one_work+0x171/0x380 [<0000000049a0eefa>]
> > worker_thread+0x1d1/0x3f0 [<00000000909cf2b9>] kthread+0xf8/0x130
> > [<0000000058f5f874>] ret_from_fork+0x35/0x40
> >
> > This patch fixes the issue by:
> > - Releasing dd->per_sdma[i].kobject in hfi1_unregister_sysfs().
> >   - This will fix the memory leak.
> > - Calling kobject_put() to unwind operations only for those entries in
> >    dd->per_sdma[] whose operations have succeeded (including the curren=
t
> >    one that has just failed) in hfi1_verbs_register_sysfs().
> >
> > Fixes: 0cb2aa690c7e ("IB/hfi1: Add sysfs interface for affinity
> > setup")
> > Cc: <stable@vger.kernel.org>
> > Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
> > Signed-off-by: Kaike Wan <kaike.wan@intel.com>
> > Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
> > ---
> >  drivers/infiniband/hw/hfi1/sysfs.c |   13 +++++++++++--
> >  1 file changed, 11 insertions(+), 2 deletions(-)
>=20
> I'm not certain, but this seems unwise.
>=20
> After hfi1_verbs_unregiser_sysfs() returns there should be no sysfs left
> under the ibdev as we are going to delete the ibdev sysfs next.
>=20
> kobject_del() triggers synchronous delete of the sysfs, while
> kobject_put() potentially defers it to the future.
True.  However, kobject_del() will only delete the sysfs for the object, ie=
, unwrap what has been done in object_add, but it will not decrement the re=
fcount for the kobject.
To unwap kobject_init_and_add(), one can call
(1) kobject_del() (optional)
(2) object_put()

The kobject cleanup function (kobject_cleanup()) will call kobject_del if k=
obj->state_in_sys is set. Therefore, one can call object_put() alone to get=
 the job done.

>=20
> Will ib unregister fail if the kobject_del() has not happened yet? I am u=
nsure.
>=20
I don't think so. We only observed the kmemleak complaints after unloading =
the driver, nothing else.

Kaike
