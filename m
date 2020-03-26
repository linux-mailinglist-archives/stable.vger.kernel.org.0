Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEF98194B7B
	for <lists+stable@lfdr.de>; Thu, 26 Mar 2020 23:24:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727636AbgCZWY4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Mar 2020 18:24:56 -0400
Received: from mga06.intel.com ([134.134.136.31]:26725 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726270AbgCZWYz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 26 Mar 2020 18:24:55 -0400
IronPort-SDR: S3Rf72P4KNPSz22BGLF6X+SAJeII6BD6mV1+sQ1M5IYGe3QofGeJVoonmejHcJMl4MF7/LUXXu
 Yn53fbDldnng==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2020 15:24:54 -0700
IronPort-SDR: Ysl4hfqq1+yGQSjVv0zUmEeFxGbJyFkKiEp0PjqY6R1943twbs8qTE72mQU7D0yM/2k/Sfv/fN
 q3eASnEXRB9g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,309,1580803200"; 
   d="scan'208";a="394176067"
Received: from orsmsx103.amr.corp.intel.com ([10.22.225.130])
  by orsmga004.jf.intel.com with ESMTP; 26 Mar 2020 15:24:54 -0700
Received: from orsmsx115.amr.corp.intel.com (10.22.240.11) by
 ORSMSX103.amr.corp.intel.com (10.22.225.130) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 26 Mar 2020 15:24:53 -0700
Received: from ORSEDG002.ED.cps.intel.com (10.7.248.5) by
 ORSMSX115.amr.corp.intel.com (10.22.240.11) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 26 Mar 2020 15:24:53 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (134.134.137.101) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 26 Mar 2020 15:24:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lwsjo3jr04H79cAngK/na+2Zn8YZm5yOuvySD1fVZQvEoeNZg2QQtWZiAd2FkVumMl3nY/zA6nE+lZzgVx7jg/MB51TIcKuHiT/2la6XLEBjU60b5AZi98vpEsKAis8krdHRWMC63wr5+9UTsZ8a9a0r9hACHkR24YIUvOy6GCFuME9lBvmFeh5I2WwQvOrzuxwzwau5p61nnbDktwRhilw3/xqBbgiMG2o4Uaj/1qYH2bRaB5Sz985fYSvBh4d0FB1hF/9wkkG5VV+fatvyCkhIG5rgbPhYqp/hPGT0E33yVHrxPmEU5wZBxbxyTBAQkZz9J1Ex/ZwUqF2SX74HSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=spwF7SbE5D02N3jFMTU5oPAjYo3hbpo8uWgZRAu1Uhg=;
 b=PIx7oS8K+YWyRT3Mmyj76tq0qBNCu0g9Na+l+JyWs1walBfHPYNs+M9R+nv14d1YVufoskdzhKaq40hnPoO0guuePfWXh9Y+m9mp3tKJDFjxkqJrbFtib0cJZdEGJGiTfDaKcb5ilcZAoFPVjqysMNUH8H+tv1WpvlKOVO3M7GKWsirIpJEEJZqeUjLFiQVuoR3VMSIff3/NSsKEkAYN/tiKrTaFUQuZ2wT4FbvPfwQYmN1XwA0hj/nA9uTUEnnxcEDmkE1IP8/wk7Xeq+6MMQ0YrH1shsDQeJ69cFjxcnmKjDeHQrs0nIBRnwRgvQhpKqx/ekWLOq6R+UcP/02spA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=spwF7SbE5D02N3jFMTU5oPAjYo3hbpo8uWgZRAu1Uhg=;
 b=aVDBWobhsSXcrPWX6wxN70ldrlmJgXVXsiFB4CN2FMQ686IDRxgtsbCBCwmVlmn92Zyty/k2Ex++UumEZxUE6Gy8OPrtughIgSDR8y97bV/VwZhrfWMSXOo7H6HlIEdcPeN1U7OZC9W/ITSw+EGkULPQRynFGmnw4Aj18TJ9OSs=
Received: from MW3PR11MB4665.namprd11.prod.outlook.com (2603:10b6:303:5d::12)
 by MW3PR11MB4634.namprd11.prod.outlook.com (2603:10b6:303:54::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.20; Thu, 26 Mar
 2020 22:24:51 +0000
Received: from MW3PR11MB4665.namprd11.prod.outlook.com
 ([fe80::c008:bca9:22e9:4dc9]) by MW3PR11MB4665.namprd11.prod.outlook.com
 ([fe80::c008:bca9:22e9:4dc9%4]) with mapi id 15.20.2835.023; Thu, 26 Mar 2020
 22:24:51 +0000
From:   "Wan, Kaike" <kaike.wan@intel.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
CC:     "Dalessandro, Dennis" <dennis.dalessandro@intel.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "Marciniszyn, Mike" <mike.marciniszyn@intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH for-rc 1/2] IB/hfi1: Fix memory leaks in sysfs
 registration and unregistration
Thread-Topic: [PATCH for-rc 1/2] IB/hfi1: Fix memory leaks in sysfs
 registration and unregistration
Thread-Index: AQHWA40Awes0Rgb8RkWMlfzLNuNxCKhbIAuAgAATmUCAABK6gIAAAUsg
Date:   Thu, 26 Mar 2020 22:24:51 +0000
Message-ID: <MW3PR11MB466518FEF749DC4DD1ABDC91F4CF0@MW3PR11MB4665.namprd11.prod.outlook.com>
References: <20200326163619.21129.13002.stgit@awfm-01.aw.intel.com>
 <20200326163807.21129.27371.stgit@awfm-01.aw.intel.com>
 <20200326172541.GM20941@ziepe.ca>
 <MW3PR11MB466550446C9C322CAB52AAE7F4CF0@MW3PR11MB4665.namprd11.prod.outlook.com>
 <20200326194251.GO20941@ziepe.ca>
In-Reply-To: <20200326194251.GO20941@ziepe.ca>
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
x-ms-office365-filtering-correlation-id: 449656de-20af-429a-8e9d-08d7d1d48057
x-ms-traffictypediagnostic: MW3PR11MB4634:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW3PR11MB4634C39D585E3A8C6C241EB6F4CF0@MW3PR11MB4634.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0354B4BED2
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(396003)(376002)(39860400002)(366004)(136003)(6506007)(53546011)(71200400001)(33656002)(7696005)(66476007)(76116006)(66446008)(66946007)(186003)(26005)(52536014)(5660300002)(6916009)(2906002)(4326008)(64756008)(66556008)(54906003)(9686003)(316002)(478600001)(81156014)(8936002)(81166006)(55016002)(8676002)(86362001);DIR:OUT;SFP:1102;SCL:1;SRVR:MW3PR11MB4634;H:MW3PR11MB4665.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LPKne3go70uQl1nLoSk1WeL6dIv6COQwJ/TJFYS/MX891WDTOZRpQjz+eIk5aOFyjqQ7iSyrr8XtC1do5TMn3JBvnED8t+GDk+4IewzRn/+E4/MdAOsETrTL8JL0/DyHXZYsX4CPuJxz+U66p2roiUFCEbgxr/MAqIKdatJVKOrQtWAuU4qBWbN5dcMuxajemRq7y+EHfhXeSAhGBHSBPQZAQvYqk69kfO9I4MUf0wMJmkvUZbvo4ooQji52A0yBYzbOE371ma+93NvH926xRGebpu9IH7/LrKImMFSP3zCMoRpk3C9TbTKdNPoEYLEA4VkPsugK0vxS9Mm5H86/gqMdTWvOhQk4Nd5YQYJl3oulGg8IHZfIcZZV5lC8qvi0Uak+YlsLlhNwIjROVlEI+t3vuQskpIWh+WFXzR6MgvNKSLhVtci72rAqlIAY1d/4
x-ms-exchange-antispam-messagedata: IgJ5WdWQnJ6V0ZItdsJ3QNeI9ofLvsbtbbsm/vSnX4KdFw0Ba7Iyte0XiL9PXrNL+p7dVsS+BDhMXDTvJNkgYA8iwB9kmMt8K2eg6ZOkZBIQdfbdkBnYIWwo+lSRakWGZ9pmoYtV4bAdvNKOVAXM6A==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 449656de-20af-429a-8e9d-08d7d1d48057
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Mar 2020 22:24:51.1513
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IwhYGyRicpPAZWG5/j3ciD3OPKWN3Cd024yFeUA4v8fiwJiCuYOb8GFa+Bzd+MAKH4qzXAlXHzVAv9G0d/2QZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4634
X-OriginatorOrg: intel.com
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> -----Original Message-----
> From: Jason Gunthorpe <jgg@ziepe.ca>
> Sent: Thursday, March 26, 2020 3:43 PM
> To: Wan, Kaike <kaike.wan@intel.com>
> Cc: Dalessandro, Dennis <dennis.dalessandro@intel.com>;
> dledford@redhat.com; linux-rdma@vger.kernel.org; Marciniszyn, Mike
> <mike.marciniszyn@intel.com>; stable@vger.kernel.org
> Subject: Re: [PATCH for-rc 1/2] IB/hfi1: Fix memory leaks in sysfs regist=
ration
> and unregistration
>=20
> > > > When the hfi1 driver is unloaded, kmemleak will report the
> > > > following
> > > > issue:
> > > >
> > > > unreferenced object 0xffff8888461a4c08 (size 8):
> > > > comm "kworker/0:0", pid 5, jiffies 4298601264 (age 2047.134s) hex
> > > > dump (first 8 bytes):
> > > > 73 64 6d 61 30 00 ff ff sdma0...
> > > > backtrace:
> > > > [<00000000311a6ef5>] kvasprintf+0x62/0xd0 [<00000000ade94d9f>]
> > > > kobject_set_name_vargs+0x1c/0x90 [<0000000060657dbb>]
> > > > kobject_init_and_add+0x5d/0xb0 [<00000000346fe72b>]
> > > > 0xffffffffa0c5ecba [<000000006cfc5819>] 0xffffffffa0c866b9
> > > > [<0000000031c65580>]
> > > > 0xffffffffa0c38e87 [<00000000e9739b3f>] local_pci_probe+0x41/0x80
> > > > [<000000006c69911d>] work_for_cpu_fn+0x16/0x20
> > > [<00000000601267b5>]
> > > > process_one_work+0x171/0x380 [<0000000049a0eefa>]
> > > > worker_thread+0x1d1/0x3f0 [<00000000909cf2b9>]
> kthread+0xf8/0x130
> > > > [<0000000058f5f874>] ret_from_fork+0x35/0x40
> > > >
> > > > This patch fixes the issue by:
> > > > - Releasing dd->per_sdma[i].kobject in hfi1_unregister_sysfs().
> > > >   - This will fix the memory leak.
> > > > - Calling kobject_put() to unwind operations only for those entries=
 in
> > > >    dd->per_sdma[] whose operations have succeeded (including the
> current
> > > >    one that has just failed) in hfi1_verbs_register_sysfs().
> > > >
> > > > Fixes: 0cb2aa690c7e ("IB/hfi1: Add sysfs interface for affinity
> > > > setup")
> > > > Cc: <stable@vger.kernel.org>
> > > > Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
> > > > Signed-off-by: Kaike Wan <kaike.wan@intel.com>
> > > > Signed-off-by: Dennis Dalessandro <dennis.dalessandro@intel.com>
> > > >  drivers/infiniband/hw/hfi1/sysfs.c |   13 +++++++++++--
> > > >  1 file changed, 11 insertions(+), 2 deletions(-)
> > >
> > > I'm not certain, but this seems unwise.
> > >
> > > After hfi1_verbs_unregiser_sysfs() returns there should be no sysfs
> > > left under the ibdev as we are going to delete the ibdev sysfs next.
> > >
> > > kobject_del() triggers synchronous delete of the sysfs, while
> > > kobject_put() potentially defers it to the future.
>=20
> > True.  However, kobject_del() will only delete the sysfs for the
> > object, ie, unwrap what has been done in object_add, but it will not
> > decrement the refcount for the kobject.  To unwap
> > kobject_init_and_add(), one can call
> > (1) kobject_del() (optional)
> > (2) object_put()
>=20
> Yes, you must call both, but kobject_put is not a replacement for kobject=
_del.
We can do that.
>=20
> > The kobject cleanup function (kobject_cleanup()) will call kobject_del
> > if kobj->state_in_sys is set. Therefore, one can call
> > object_put() alone to get the job done.
>=20
> No, as I already explained, the moment that kobject_del happens is no
> longer reliable with kobject_put.
>=20
> > > Will ib unregister fail if the kobject_del() has not happened yet? I =
am
> unsure.
> >
> > I don't think so. We only observed the kmemleak complaints after
> > unloading the driver, nothing else.
>=20
> Of course, hfi1 is missing the required kobject_put, so it was only a lea=
k.
>=20
> To see if there is an issue here delete the kobject_del and kobject_put
> entirely to leave a dangling sysfs during registration and see if ib devi=
ce
> unregistration explodes.
I tried a patch wherein the function hfi1_verbs_unregister_sysfs() is never=
 called at all and when unloading the driver the ib device un-registration =
went through smoothly(no error, the /sys/class/infiniband/hfi1_0 directory =
gone). Only kmemleak complaints were observed.

I will re-spin the patches.

Thanks,

Kaike
