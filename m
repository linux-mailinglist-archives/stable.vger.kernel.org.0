Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63AD21D14E9
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 15:31:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387748AbgEMNbb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 09:31:31 -0400
Received: from mga07.intel.com ([134.134.136.100]:7084 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387730AbgEMNbb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 13 May 2020 09:31:31 -0400
IronPort-SDR: TPeTcuhAO2aJStNDaN5nlDmzRfM1msMiGPFme9QIsEGGtbVUeuBMx7aGB73Ou/y/NHZ28Jq+Hy
 zAVRDO+WSQbw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2020 06:31:28 -0700
IronPort-SDR: uLaewi6hYXYMTHNE69oWSfdOkXEGmvkCdWVLrYY4edepSlAb7lCAvqpoNWIXNfkDbjMFBAYsan
 d80IXMZo8/oQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,387,1583222400"; 
   d="scan'208";a="298366300"
Received: from orsmsx104.amr.corp.intel.com ([10.22.225.131])
  by orsmga008.jf.intel.com with ESMTP; 13 May 2020 06:31:16 -0700
Received: from orsmsx606.amr.corp.intel.com (10.22.229.19) by
 ORSMSX104.amr.corp.intel.com (10.22.225.131) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 13 May 2020 06:31:15 -0700
Received: from orsmsx606.amr.corp.intel.com (10.22.229.19) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 13 May 2020 06:31:15 -0700
Received: from ORSEDG001.ED.cps.intel.com (10.7.248.4) by
 orsmsx606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 13 May 2020 06:31:15 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.107)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 13 May 2020 06:31:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aYXpe8WYBdJlBflE7sijLmvDCjlHsSKgN+6sI4x8z37bjDfxTUAQNo67moL5j472xwVIZOpWdCoKWvehwSrh04L6YN21KjFA222pIbeqhHNswuuayT0CdsjaJtBC12F6be1UutmF7WAIzfUNfxuJ9yKRYR7CLsa6fnsdXII54NKNwF94PecdOVPerni7SeDIN4/5aFrFQnEiUKQegBS7gzxez5hI8/xK6mCL6/Xz/WLshcmCRksCojcoKMmDHe5vKCEAWLj82EGNvRgdv380eAoRbTsZCNDF5No63MCxyRA0oXN3yJHAebR87PyfYyPh0Oy5FUzP5/oJ3We54JvIAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J1SiTV48yOv313VVIODyf+pqmRJ5G/P2Mg7hj54xbjQ=;
 b=P7Jqf0pFM0K7pBNmmGrshYjqvPW0If1x0rPsTFwsQ99Qnu1UqaPaVJyvnObMKj2esD4IkkPvlp+D8M5bX+EcEN+DZ8FWDzgzoSlY3Dr4+qo3cIsTdIo2fS77RFLkoq+gBvtLQISwXwUmJhDRrIUnShv8k8iofuqm2q4+25kXJ+dtF0j8vzJ15s3ptT85PcKM42HdZt9fwC3SYdJ/TPKZnzLZBeNHUHk+J/v9yaVXyxD7rkyIwQPpkg1CyOZFq6AunnJARdec1WjchwlKdVt37oajKyez0VRfNh1914u485p6ZriJ8m2ccw5izmhNJEiFbTEk5ScG+5JFAUnf+SXUzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J1SiTV48yOv313VVIODyf+pqmRJ5G/P2Mg7hj54xbjQ=;
 b=VtomCObJ3N2Am9iIUo7vkOur8F6Fx7ywS59Q5v08am5zQgb44aG1AZOaoYdKcOFMKoBuptsiqxnEZMOII+q2Dg7l1Ryt/fdJDPUQ6t1KcWp5JoqJvfdOdWvSnRmFe9ehtU+HqdzE9mcbjrciGMpReuwheuksmZ9B25rMIQkX0L0=
Received: from MW3PR11MB4665.namprd11.prod.outlook.com (2603:10b6:303:5d::12)
 by MW3PR11MB4700.namprd11.prod.outlook.com (2603:10b6:303:2d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.33; Wed, 13 May
 2020 13:31:13 +0000
Received: from MW3PR11MB4665.namprd11.prod.outlook.com
 ([fe80::29b3:892:eed1:2d0c]) by MW3PR11MB4665.namprd11.prod.outlook.com
 ([fe80::29b3:892:eed1:2d0c%5]) with mapi id 15.20.2979.033; Wed, 13 May 2020
 13:31:13 +0000
From:   "Wan, Kaike" <kaike.wan@intel.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     "Dalessandro, Dennis" <dennis.dalessandro@intel.com>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "Marciniszyn, Mike" <mike.marciniszyn@intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH for-rc or next 1/3] IB/hfi1: Do not destroy hfi1_wq when
 the device is shut down
Thread-Topic: [PATCH for-rc or next 1/3] IB/hfi1: Do not destroy hfi1_wq when
 the device is shut down
Thread-Index: AQHWKAtYj9gYAc53PUOvXaZcprmNbqij88GAgABfNtCAAVWZgIAAXJJA
Date:   Wed, 13 May 2020 13:31:12 +0000
Message-ID: <MW3PR11MB4665565B9F972B131C31091FF4BF0@MW3PR11MB4665.namprd11.prod.outlook.com>
References: <20200512030622.189865.65024.stgit@awfm-01.aw.intel.com>
 <20200512031315.189865.15477.stgit@awfm-01.aw.intel.com>
 <20200512055521.GA4814@unreal>
 <MW3PR11MB4665BDCA7CA57498D631FF5EF4BE0@MW3PR11MB4665.namprd11.prod.outlook.com>
 <20200513075845.GS4814@unreal>
In-Reply-To: <20200513075845.GS4814@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.2.0.6
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [72.94.197.171]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 41745223-20ef-4957-49c0-08d7f741e7d4
x-ms-traffictypediagnostic: MW3PR11MB4700:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW3PR11MB4700F3051E5093FBCF55846EF4BF0@MW3PR11MB4700.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3513;
x-forefront-prvs: 0402872DA1
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pJbi+bttq6Kyp2+M9mOblDFrxVkpuTK1xmjG3xssW8W1JFSA0tk1Nkg5tnsFwlVCqIZy4mnUB7zBcAlQIiPmucVQzQTiuxIQi5AWWn6TsAMWyZjwkol2AM612oU/Xq8FGBW6Ju4465aorBl298yj7zbmNHNhAF53xZtgwXFHacLl58wMbXRdXyqn8v7BoPgEFM1L+NfrIvhc16EAiDZ4q5xF0fr8NdhSLT1IJ6EJkUqyxV9TCYFCjLFVqf1PBiupZPJI8oQjjdvFh/F9rYOQ7e2f0T0nOt+W88zYgB1/NLGKDczoGObUHYJtnerHlrhweTt1cdSKOPRZvrWcSntN7mQm7WKBj3Sq7+xBAcKWv7HiFi9I8hqyyGM/zQY59egRBj7ZGTwFTbc4zsWhl8ZYKo5t0/3I1Y6/WlMYPnz7Rvuu24Sv6EkIQxiCUHNnsPqukj0wxatFj7cWg1rCkvRa3gZOlCjXCsfV0SiLw3fmXyi2zGGYIOR1Zz34v5hzujruHtpFTrvvowyTdx1Kg+WlvQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4665.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(376002)(39860400002)(136003)(396003)(346002)(366004)(33430700001)(33656002)(9686003)(55016002)(6506007)(186003)(5660300002)(316002)(8676002)(54906003)(53546011)(7696005)(26005)(33440700001)(8936002)(478600001)(76116006)(66446008)(66476007)(66556008)(66946007)(64756008)(86362001)(6916009)(71200400001)(2906002)(4326008)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: doVLXqh2ihVdZ0SkBEC0ztVX03ClG76uNKAfQtkPjZg02cWgYp6g8N+OAwxMyDN31Io+1jwdKvORLi15QMoUK5CorRyHos6hne/eQLHymQziyZ44anrJ4iRnIV+S75hHny1QRVdd9wYzfWhQC91fWFjYZAr70vq0d7UnHCPIGWw9nZjpGs7IOXGu1JEJJQFCBhYm12zjYl99q9qTIESOcQqazZiB9SfZWK3dNtwhCXKnJPqLBLFhvkY/XqIIY/3WgbbS/PIxAbA7DbH2J3s04AN3pNelNLCzVHVFqaRDUmt/cmgK9aEQ6KamBvLBAzVc3dv7t428OCYOB4OoNV2bPz97TLBEyIiRrNg4EVcUgIaBbpBYeHy//Jxeq/XZa5+7LOrqakJMGZKc7U/icH4JA/5/Z9e7bB522xGSPUbG7ZYKpak5jDBh2Xp77MuCFcdMjMZ55A4QttCjPghBkflXGxRArBWGT5LxCwVz7hLUnCo=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 41745223-20ef-4957-49c0-08d7f741e7d4
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 May 2020 13:31:12.9682
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: h8CHarIjN6N1dys6fqiF/Uwp/ROrMGlw702EfdQG1vQbTXeQ7Jp/F8OpkWxfMhkQgXwyF2c84QgdYOlKNA9K+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4700
X-OriginatorOrg: intel.com
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> -----Original Message-----
> From: linux-rdma-owner@vger.kernel.org <linux-rdma-
> owner@vger.kernel.org> On Behalf Of Leon Romanovsky
> Sent: Wednesday, May 13, 2020 3:59 AM
> To: Wan, Kaike <kaike.wan@intel.com>
> Cc: Dalessandro, Dennis <dennis.dalessandro@intel.com>; jgg@ziepe.ca;
> dledford@redhat.com; linux-rdma@vger.kernel.org; Marciniszyn, Mike
> <mike.marciniszyn@intel.com>; stable@vger.kernel.org
> Subject: Re: [PATCH for-rc or next 1/3] IB/hfi1: Do not destroy hfi1_wq w=
hen
> the device is shut down
>=20
> On Tue, May 12, 2020 at 11:52:34AM +0000, Wan, Kaike wrote:
> >
> >
> > > -----Original Message-----
> > > From: linux-rdma-owner@vger.kernel.org <linux-rdma-
> > > owner@vger.kernel.org> On Behalf Of Leon Romanovsky
> > > Sent: Tuesday, May 12, 2020 1:55 AM
> > > To: Dalessandro, Dennis <dennis.dalessandro@intel.com>
> > > Cc: jgg@ziepe.ca; dledford@redhat.com; linux-rdma@vger.kernel.org;
> > > Marciniszyn, Mike <mike.marciniszyn@intel.com>;
> > > stable@vger.kernel.org; Wan, Kaike <kaike.wan@intel.com>
> > > Subject: Re: [PATCH for-rc or next 1/3] IB/hfi1: Do not destroy
> > > hfi1_wq when the device is shut down
> > >
> > > On Mon, May 11, 2020 at 11:13:15PM -0400, Dennis Dalessandro wrote:
> > > > From: Kaike Wan <kaike.wan@intel.com>
> > > >
> > > > The workqueue hfi1_wq is destroyed in function shutdown_device(),
> > > > which is called by either shutdown_one() or remove_one(). The
> > > > function
> > > > shutdown_one() is called when the kernel is rebooted while
> > > > remove_one() is called when the hfi1 driver is unloaded. When the
> > > > kernel is rebooted, hfi1_wq is destroyed while all qps are still
> > > > active, leading to a kernel crash:
> > >
> > > I was under impression that kernel reboot should follow same logic
> > > as module removal. This is what graceful reboot will do anyway. Can
> > > you please give me a link where I can read about difference in those
> flows?
> > >
> > I used to think the same. However, by adding traces to the hfi driver, =
I
> found out that the shutdown function of the pci_driver was called when
> typing "reboot"  while the remove function  of the pci_driver was called
> when typing "modprobe -r hfi1".
>=20
> I took a look on what mlx5_core is doing in shutdown flow and it can be
> summarized in the following:
> 1. Drain workqueues
> 2. Close PCI
> 3. Don't release anything.
>=20
> So maybe you didn't flush the hfi1_wq?
Will add the flush.

Thanks,

Kaike
> >
> >
> >
