Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02F59351B89
	for <lists+stable@lfdr.de>; Thu,  1 Apr 2021 20:11:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237844AbhDASIy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Apr 2021 14:08:54 -0400
Received: from mga07.intel.com ([134.134.136.100]:1682 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236222AbhDASCR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 1 Apr 2021 14:02:17 -0400
IronPort-SDR: MQXu7+PfaYvmHHRuj2/d2J7WFnURkv74I8wRDEE87uqX2lzoa3gDw6F9GMzqrEE733cWZzAeoc
 m8r51vGC3DEg==
X-IronPort-AV: E=McAfee;i="6000,8403,9941"; a="256229496"
X-IronPort-AV: E=Sophos;i="5.81,296,1610438400"; 
   d="scan'208";a="256229496"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2021 06:42:59 -0700
IronPort-SDR: WOIR69XMJuW0gyzNI5bKn3s2DT6W2+7cB92/U0JrF9uiu2ANAjH6AAu3FeqBNOI7NRxwB3fyl4
 dpywxyo1+wPg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,296,1610438400"; 
   d="scan'208";a="379321825"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by orsmga006.jf.intel.com with ESMTP; 01 Apr 2021 06:42:59 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 1 Apr 2021 06:42:59 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 1 Apr 2021 06:42:58 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Thu, 1 Apr 2021 06:42:58 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Thu, 1 Apr 2021 06:42:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mCxq6dsR1faddaQBRM6JxztPrgMFn4T2YrV4I0OvOAtODz7ei+8UUphF4KEMp/eTIKAXrLxE1ia/Ng67ltXHppOfLS85INa98r/OTgy0vDu/fooysuwyjVPXpLtlLG5kfpyinsNXnfzTq/o+nfUGuhrjmSFk+I7HFzOF+AxVG2HtEndv2aepDK6JJRC75VEmbl8t4EJmnIxfElierpKUBQzZTW/0Zp9pmBmbrFrZ+aAsKpAiYk2byo/6rBRDctf2vSjQCaAe9ZUcz0a57SuK7RkV9/TLC4eio1lGYK4d4wqDOaz0YT4UUAnzn4D9wcyFA9XK6sKC0R13el51MAbvsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uR/lWMK8kNykYiyEnD/OeHxHTpmenG9Hw4wonph5R4E=;
 b=NCfAXB63Zp1bXt0E/aPdWtxx8AsZE058Kvry2uvv1bqgXmVla7GKWoHO2sJPSVeQk9FgpaERTusMeFe3XwCsSTWN3EwmuFeuGdylcWcyvo6O2A3szBDlCsJjzwqGQumTC6ZbzWfWV7MU17Z2mq/tEopgO4Uct9CofrntmXPzNdvi4KrtQCzxnZoaeLCWZX5okdFu2yrAX6BPfFvHhHBBl4q0AKb2ia5V1qgqRQgkTs1TLKCi8+IIz3x8YvIHXGdR4GILR44tizwPREwCwQHYqDhoaRnEpy2L6BrzYLYCh9kHU9Xc2mMKiuf+mYGSJ8vgMzLMbecrsCLW9PUfJy5Sqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uR/lWMK8kNykYiyEnD/OeHxHTpmenG9Hw4wonph5R4E=;
 b=tLcXK1v2o1D3G/y3tdvaIIWt3F+93QnXo4ypfwHctE6jSYHmwO4CEZGOFDIVCB5IjA5Ta5Yg38E18YRPc7e42TecJ0Y/VB3hC4ISNmV/SXIt+vYK+GrPAQh+wIreh2DlVfYVCSPLHiMJkxcswM4poED0uQS1/3NOsaOuD2U9qyI=
Received: from DM6PR11MB3306.namprd11.prod.outlook.com (2603:10b6:5:5c::18) by
 DM4PR11MB5551.namprd11.prod.outlook.com (2603:10b6:5:392::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3999.27; Thu, 1 Apr 2021 13:42:57 +0000
Received: from DM6PR11MB3306.namprd11.prod.outlook.com
 ([fe80::a5d3:6423:7589:c110]) by DM6PR11MB3306.namprd11.prod.outlook.com
 ([fe80::a5d3:6423:7589:c110%6]) with mapi id 15.20.3977.033; Thu, 1 Apr 2021
 13:42:57 +0000
From:   "Wan, Kaike" <kaike.wan@intel.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
CC:     "dledford@redhat.com" <dledford@redhat.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH for-rc 1/4] IB/hfi1: Call xa_destroy before freeing
 dummy_netdev
Thread-Topic: [PATCH for-rc 1/4] IB/hfi1: Call xa_destroy before freeing
 dummy_netdev
Thread-Index: AQHXJKJ1kGs0X/qh/ku36euB8822faqbAPYAgAN//QCAARwpgIAAEkTg
Date:   Thu, 1 Apr 2021 13:42:57 +0000
Message-ID: <DM6PR11MB330637BAEB1AA8D7FDC56225F47B9@DM6PR11MB3306.namprd11.prod.outlook.com>
References: <1617025700-31865-1-git-send-email-dennis.dalessandro@cornelisnetworks.com>
 <1617025700-31865-2-git-send-email-dennis.dalessandro@cornelisnetworks.com>
 <20210329140922.GP2710221@ziepe.ca>
 <7da1174e-97a6-3933-ae35-166a9dcbf38e@cornelisnetworks.com>
 <20210401123317.GC2710221@ziepe.ca>
In-Reply-To: <20210401123317.GC2710221@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
authentication-results: ziepe.ca; dkim=none (message not signed)
 header.d=none;ziepe.ca; dmarc=none action=none header.from=intel.com;
x-originating-ip: [96.227.240.152]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 62893b70-06b3-4120-4f37-08d8f5140f4a
x-ms-traffictypediagnostic: DM4PR11MB5551:
x-microsoft-antispam-prvs: <DM4PR11MB555101F06B82511DECE547CDF47B9@DM4PR11MB5551.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ahu2qwEYsDIz8vbLYikefrIsL1wPFCruPsjj+MXYVMsSbC6e9IEu2cHdKPXAiTSmVYHcjZj0ClfkcsNwmj0c6rUaiKVbWog52/tpzoJhrRMgPOXzE7FGtI12Vxo3S2xamPE3tIhWAu5YtX9tSX6B8dGlEWLmemw2HBdrNnNv8CXpZDIqJMsmRtg16XePFKW5kwgEHK//RMYyY8ehuJ8ePV1PCfL01gCzAyatUjg0i95SgUEVfNYgo6fwdDxU7HSz5dDOSvJbUQQkW2MX15sLUKM1bNAau2rb5eMTHoih3VZuAMB8WBF8RWJGoQSJItQp8O10G1O7z8HcGByhkdPkLrrC/8A0ac/vVhJpNOb08UmKi6ae1vf4DJ5ElLiGXEmKGdfAKAz8s5fO5zUg3G3srLL/Ml1j9yLiOZcGcvEv4D+sMoHzrLDerXPbxFD8KFm03JnyYOyoLiQt0eu3o1duRfKbggUvASCNS4dSkMujqovpldCtx+X4MR2LzOUnxV3FB0gU9h1MCp7ZfnTsEbK+tuyTEkDQmrfpwG+5xoyTHgErvDZAdyrttwZGNXV5SFiMOq1fk1g0Dl4dDo6FV92CZyDIHdfPble4NU5I8jdfT/Z9x96ZMxBShp4pw76M+0nK544iVsLs25eJ6DsfVWJlmaSj0VG8LVjY/u25TqQ9S7Bcby4z6gGoHUBw2nDo5MrY6vgx9Bh0r7116LzZQBlfOMzIMtEjNqQ+42vHohZ9IFcDAa7GWW6N8ErKzeu+5sU2
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3306.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(376002)(366004)(39860400002)(396003)(5660300002)(52536014)(478600001)(53546011)(26005)(71200400001)(6506007)(8676002)(186003)(55016002)(4326008)(2906002)(316002)(8936002)(76116006)(38100700001)(66476007)(66946007)(86362001)(110136005)(9686003)(64756008)(66556008)(66446008)(54906003)(33656002)(966005)(83380400001)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?ckf287JEDuEspEvZ9qpykxRtZyPWfct/XPr/MPHwCOCGAvtciCGdGdX/5m4i?=
 =?us-ascii?Q?lkvXmmh/ajwtkoDhUu9b7SWrz6lGO27tkUCJtdqkeYT0ANdv5tq4f5jFz1EH?=
 =?us-ascii?Q?ftOjj1aLuBRxrKWpxtInVemBbJGgaDiw+YftF+IBt7HVwPYrCFUCV2ctFbCF?=
 =?us-ascii?Q?/KQNXjRrVH81Ahf7oetzBrYuHXgH1vdhvfC9/DuDMht7ArJXGBgEsUKN6ieU?=
 =?us-ascii?Q?15HB8Pygrd+NXBeLcka01FJ+249lII/ElZjgpkqoftBPMjWOHjepg6JooWgq?=
 =?us-ascii?Q?raulkBuocndXDdoVuGnHQrvmoxJAZyX2YnjgVKi+oMfNIcLEoy43KljKdbwL?=
 =?us-ascii?Q?9cWWsnAjASkEmVy2eTmHLVedqz++9bShaxDjG96AF8zwZOIRsrFDZrfeziCy?=
 =?us-ascii?Q?hdQ86CTee49//8FUXfHf84vlMpKPNEADxYU+stJL8IQ18YJ7xR6U7eSJ4eWo?=
 =?us-ascii?Q?JSMqYHeVN7Zgmi121evjextke1qUda/qOZNsGn+hWKsedbprmNBC+w+VrSHu?=
 =?us-ascii?Q?AteX0jDpgbCpdQCQ1HuV1goVwl3exoH2qPwEsTWt9U5o8gG2pdl0o7mkmCG4?=
 =?us-ascii?Q?Ql9TUxi8tz6TBBu71R228qtuFuXESrBtum0pTCEmU36xHSAIddpC8llVuWei?=
 =?us-ascii?Q?vSsLr390YumrHW0ub8gL2ouNzDCMnJ4VGWCK3/rUPLkIE3H6PTvtdz3sZD69?=
 =?us-ascii?Q?CkNVbJEOye/7EXREdNfqC1C/hLyo/pYJJi9eRo2NlwXyDZ3p39uK7JkJzc/R?=
 =?us-ascii?Q?63/TzdNlXxpB4CKGQ6MH7sT4jWUZoqFbwizShvOxqUrvtr6AHOBFz4K/XJcD?=
 =?us-ascii?Q?qINzb5oRYVIhUghMFCjq6Zk0/F+TsO1DN+oPGUpHGDnTi5fuC0kGDpxKo4hp?=
 =?us-ascii?Q?Tti+0hYYZ9k3hIk2nBOZrfvm/7VHOuxLGb59BTipbzQCyVuzV7TZkWxKdgUV?=
 =?us-ascii?Q?PnxyaxCAk+6EwBwbTCFbYoitPERy1JyiORZVQnNLy+fdx/PSkrWSK5n5UDb7?=
 =?us-ascii?Q?8c7cOo24fOzUb+nw2uHX/4VhZ+9Y4AvqsyGCCrSZXZsnRZkcQzjxKF++CVjS?=
 =?us-ascii?Q?B3OYuupuE9cAkb61pUHpLhe/zfG29ciI/TBTGVdxctiXswBv9ZRi9YyHZjrC?=
 =?us-ascii?Q?lRDorOlVgZhJtXOuIL6rXjf4DAZdEDazXaP9tb8oilBaAJ4rPgL3Pvi19G6G?=
 =?us-ascii?Q?6I5CV4LnLWpFHzkBo/279GfzWDlv6taU47xIMTR9u1EaVLyfM95MiHkIYmzn?=
 =?us-ascii?Q?2BdtHhbl7Ah33sBjT4D7i9WrhJx3hZjgfCUBeF3wDrJ6Pnv21AmAdp4T9NKr?=
 =?us-ascii?Q?nCTIpJBGIMy4ZncuU+AV8Xwy?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3306.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62893b70-06b3-4120-4f37-08d8f5140f4a
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Apr 2021 13:42:57.6844
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LNMclX20DuGgBRSD0vA9YZsTmzx0nqKPAtW9iSiXSHvcT4ublLhZaicfjc/5uOzKZAq9uwYRxprwqPoteF26VQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5551
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> -----Original Message-----
> From: Jason Gunthorpe <jgg@ziepe.ca>
> Sent: Thursday, April 01, 2021 8:33 AM
> To: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
> Cc: dledford@redhat.com; linux-rdma@vger.kernel.org; Wan, Kaike
> <kaike.wan@intel.com>; stable@vger.kernel.org
> Subject: Re: [PATCH for-rc 1/4] IB/hfi1: Call xa_destroy before freeing
> dummy_netdev
>=20
> On Wed, Mar 31, 2021 at 03:36:14PM -0400, Dennis Dalessandro wrote:
> > On 3/29/2021 10:09 AM, Jason Gunthorpe wrote:
> > > On Mon, Mar 29, 2021 at 09:48:17AM -0400,
> dennis.dalessandro@cornelisnetworks.com wrote:
> > >
> > > > diff --git a/drivers/infiniband/hw/hfi1/netdev_rx.c
> > > > b/drivers/infiniband/hw/hfi1/netdev_rx.c
> > > > index 2c8bc02..cec02e8 100644
> > > > +++ b/drivers/infiniband/hw/hfi1/netdev_rx.c
> > > > @@ -372,7 +372,11 @@ int hfi1_netdev_alloc(struct hfi1_devdata *dd)
> > > >   void hfi1_netdev_free(struct hfi1_devdata *dd)
> > > >   {
> > > >   	if (dd->dummy_netdev) {
> > > > +		struct hfi1_netdev_priv *priv =3D
> > > > +			hfi1_netdev_priv(dd->dummy_netdev);
> > > > +
> > > >   		dd_dev_info(dd, "hfi1 netdev freed\n");
> > > > +		xa_destroy(&priv->dev_tbl);
> > > >   		kfree(dd->dummy_netdev);
> > > >   		dd->dummy_netdev =3D NULL;
> > >
> > > This is doing kfree() on a struct net_device?? Huh?
> > >
> > > You should have put this in your own struct and used container_of
> > > not co-oped netdev_priv, then free your own struct.
> > >
> > > It is a bit weird to see a xa_destroy like this, how did things get
> > > ot the point that no concurrent thread can see the xarray but there
> > > is still stuff stored in it?
> > >
> > > And it is weird this is storing two different types in it too, with
> > > no refcounting..
> >
> > We do rework this stuff in the other patch series.
> >
> > https://patchwork.kernel.org/project/linux-rdma/patch/1617026056-50483
> > -11-git-send-email-dennis.dalessandro@cornelisnetworks.com/
> >
> > If we fix it up in the for-next series, what should we do about stable?
>=20
> Well, if you are fixing bugs then order it bug fixes first, but this is t=
agged for rc
> and you still need to explain what bug it is actually fixing.
>=20
> xa_destroy is not required if the xarray is already empty, so the commit
> message at least needs to explain how we get to a point where it still ha=
s
> something in it.
[Wan, Kaike] Shouldn't xa_destroy() always be called during cleanup, just i=
n case that something is left behind?
Check the following:
static void ib_device_release(struct device *device)
{
	....
	xa_destroy(&dev->compat_devs);
	xa_destroy(&dev->client_data);
	kfree_rcu(dev, rcu_head);
}

>=20
> Jason
