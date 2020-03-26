Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 234BA194D47
	for <lists+stable@lfdr.de>; Fri, 27 Mar 2020 00:31:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727347AbgCZXbD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Mar 2020 19:31:03 -0400
Received: from mga02.intel.com ([134.134.136.20]:43771 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726954AbgCZXbD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 26 Mar 2020 19:31:03 -0400
IronPort-SDR: 8J+NNdmezh3KlDW9MGsVE0CzLBk8h9FKJ9pnzUrgvn/GoImOyMnxHPTD/jxzGvSlmMnvh6vJS3
 XE/+usowtCKA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2020 16:30:57 -0700
IronPort-SDR: fdvz0oM+pezZSllPdRqsx+u4XN9arrS/XJJ/Hyh663IDvm83ftHj53MR6DJf7QPWhGpaT/J6CS
 cejoiDZPINFg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,310,1580803200"; 
   d="scan'208";a="394191562"
Received: from fmsmsx107.amr.corp.intel.com ([10.18.124.205])
  by orsmga004.jf.intel.com with ESMTP; 26 Mar 2020 16:30:57 -0700
Received: from FMSEDG001.ED.cps.intel.com (10.1.192.133) by
 fmsmsx107.amr.corp.intel.com (10.18.124.205) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 26 Mar 2020 16:30:57 -0700
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (104.47.44.55) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Thu, 26 Mar 2020 16:30:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XkdWtvU6Iro6kOjAKlSx5XEcQ5z4BotSMGdi4e4htsmbhX076H05STfkKKzjFGH+ZCrPnvWYXIfaFDzrFfsTjKRzEdHW3fHWAhe/2eEwxmuQFJZ60L74iIpt0gDnqtCBUcygLY3Y4kJo0vaKVN9OS8PXRrjurLRKXX/YGlzNdP4reHbvCN2dONikbj0kI28JWppHLJjE+6zkVSgymJQogk4CryJHTyI12wmY3ezNDlM/k5fdfiSqO1VLXaB8PUUEPwtzfdqmakyNC43H1AyWyaPneQ9xLVY2PO6sdPaN8tjBBVFuGhGvBJ0vC/rToV1AtUQzN+5tW4Bf9gEHFibHpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YimSbTgDJLt9RmQdBJuMRestOqWyM1TbJqqq5OsNM6M=;
 b=dYFFNaN4pvtEE1udqzBp0ofjRMRwJ8jbCtD9r+EkEnO4IGyXzE1sB+arNLvf9F1vXRqYLmtH+Hh2CZLKtu+Vutw5VYuimSg1Lx5M+7qK/NxU0NwC7PlbTYRQ2GXa8DorOmMBjPIiMXKJzR0nEKb92uAFYwQE+FiWuTzzdRwTuEK7pxx82InvGY/eOv4bNngq3eQvCZ57Lykkmu7XrKbChNwTrJFGSDOpcpIYwJAmruc50OVv/GQG0DMtDsGBJriyLlkyyLPYfzmrhhIfuG1uUuXWO+kPG+31HPXdtLMy3qhfDst/M2TJZhLxR2PJbCUq6XhAmsMPVT5xj8mt4qJoGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YimSbTgDJLt9RmQdBJuMRestOqWyM1TbJqqq5OsNM6M=;
 b=zXgOL2g8JYFPViiRmxi0qJiSSiUWPF4L3so69GyHhP3l43xSsy09rmHRdL8kiBJpfRIVlSSUbfD+07P3S26H+A+rDfxLwnKtuEpPVaFRSrutt1mchgaZW3GhpeTUVqyjSKzKXiYye4DKmf8GkjfeRbCuJ9mqOEUnDqqHi3tEQnY=
Received: from MW3PR11MB4665.namprd11.prod.outlook.com (2603:10b6:303:5d::12)
 by MW3PR11MB4698.namprd11.prod.outlook.com (2603:10b6:303:5a::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.19; Thu, 26 Mar
 2020 23:30:55 +0000
Received: from MW3PR11MB4665.namprd11.prod.outlook.com
 ([fe80::c008:bca9:22e9:4dc9]) by MW3PR11MB4665.namprd11.prod.outlook.com
 ([fe80::c008:bca9:22e9:4dc9%4]) with mapi id 15.20.2835.023; Thu, 26 Mar 2020
 23:30:55 +0000
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
Thread-Index: AQHWA40Awes0Rgb8RkWMlfzLNuNxCKhbIAuAgAATmUCAABK6gIAAAUsggAAvVYCAAA66QA==
Date:   Thu, 26 Mar 2020 23:30:55 +0000
Message-ID: <MW3PR11MB4665CC64F56087B2AA5A726AF4CF0@MW3PR11MB4665.namprd11.prod.outlook.com>
References: <20200326163619.21129.13002.stgit@awfm-01.aw.intel.com>
 <20200326163807.21129.27371.stgit@awfm-01.aw.intel.com>
 <20200326172541.GM20941@ziepe.ca>
 <MW3PR11MB466550446C9C322CAB52AAE7F4CF0@MW3PR11MB4665.namprd11.prod.outlook.com>
 <20200326194251.GO20941@ziepe.ca>
 <MW3PR11MB466518FEF749DC4DD1ABDC91F4CF0@MW3PR11MB4665.namprd11.prod.outlook.com>
 <20200326223653.GQ20941@ziepe.ca>
In-Reply-To: <20200326223653.GQ20941@ziepe.ca>
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
x-ms-office365-filtering-correlation-id: 1c2441e0-4652-4297-ff2c-08d7d1ddbb2c
x-ms-traffictypediagnostic: MW3PR11MB4698:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW3PR11MB4698E1A31B56F73342B82E8BF4CF0@MW3PR11MB4698.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0354B4BED2
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(346002)(396003)(39860400002)(366004)(376002)(9686003)(53546011)(7696005)(66946007)(66476007)(66556008)(6916009)(54906003)(6506007)(2906002)(76116006)(64756008)(4326008)(5660300002)(52536014)(66446008)(33656002)(316002)(81166006)(81156014)(26005)(71200400001)(478600001)(8676002)(8936002)(186003)(86362001)(55016002);DIR:OUT;SFP:1102;SCL:1;SRVR:MW3PR11MB4698;H:MW3PR11MB4665.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sbJuyZCUmsGhf6KCE1T0Pa1xVur6TmmXDY8f1ChkGEoSBM7QpD1R3CY8+/3jl1FBA2jyVUnUBS5qocN/JjqRwL425L1xW/0L1cCOtDu20jhKVKTdN7IaB/mGRQ9fIkuD+co/GfaT7LoQM/wIgkL5EXnyQLCDQI1um6tWWJaPOFLchIEk47r73kvTDoItynbW3y6/Ll2aNMyYbHTezC1q98DrTyH59djEa4p6DW4nj1+N428C5fCj6NwA9MKjmOzHHpL/9/hB+jp7mOXrNCHBE0BiqGsnr5oVAF47G5Uc/o1/xFSdAeEse3UlXC0GvlerAPmpiLh/CU9emh0pwfvutLihZzUtEwavsscKXFAAQqfZ2y7KgBDC/Fts+ipRQQCivQojL8+O8UVbjPz/3HKbnSQ1KMCobWsh/l70ZcyqVm26WVdnA6hP9kSShzUlfU9x
x-ms-exchange-antispam-messagedata: Uh5zGQ5yT50EvGc8B6oLhCneRlXbgSmngw5MBXPL6getHmR73aCjKyRPNr/2R4CqMFvkla91sjRWtiXNiX6VZx0ECp/S4/ZmGsKtSoWpowXX+t8zNNgy53kTBgf7gpFkmYYUD3DkeG8YnzUqR6xuHg==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c2441e0-4652-4297-ff2c-08d7d1ddbb2c
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Mar 2020 23:30:55.2937
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2yDB4g9qf8xHIf5RwbKxsX78LMrr82yHvFAMPsRujPCLBaO3AIvEfSBwlRumUWjiiByVpjZEkH6rWkTh6qcqcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4698
X-OriginatorOrg: intel.com
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> -----Original Message-----
> From: Jason Gunthorpe <jgg@ziepe.ca>
> Sent: Thursday, March 26, 2020 6:37 PM
> To: Wan, Kaike <kaike.wan@intel.com>
> Cc: Dalessandro, Dennis <dennis.dalessandro@intel.com>;
> dledford@redhat.com; linux-rdma@vger.kernel.org; Marciniszyn, Mike
> <mike.marciniszyn@intel.com>; stable@vger.kernel.org
> Subject: Re: [PATCH for-rc 1/2] IB/hfi1: Fix memory leaks in sysfs regist=
ration
> and unregistration
>=20
> On Thu, Mar 26, 2020 at 10:24:51PM +0000, Wan, Kaike wrote:
>=20
> > > To see if there is an issue here delete the kobject_del and
> > > kobject_put entirely to leave a dangling sysfs during registration
> > > and see if ib device unregistration explodes.
>=20
> > I tried a patch wherein the function hfi1_verbs_unregister_sysfs() is
> > never called at all and when unloading the driver the ib device
> > un-registration went through smoothly(no error, the
> > /sys/class/infiniband/hfi1_0 directory gone). Only kmemleak complaints
> > were observed.
>=20
> Then perhaps there is nothing to worry about and the patches are fine
>
Then I don't have to re-spin the patches?

Kaike
