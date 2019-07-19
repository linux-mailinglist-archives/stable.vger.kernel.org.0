Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89DA96D834
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 03:13:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726072AbfGSBMy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jul 2019 21:12:54 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.47.102]:41868 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725992AbfGSBMy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Jul 2019 21:12:54 -0400
Received: from mailhost.synopsys.com (dc8-mailhost2.synopsys.com [10.13.135.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id A9D0AC0BF4;
        Fri, 19 Jul 2019 01:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1563498773; bh=fnel+lDEPFN/oJpyePgR8DYCQkzmWiZniGM/ZZxD3dE=;
        h=From:To:Subject:Date:References:From;
        b=ZEhz8dZsGSEIlJMDb7mhhQIOU9cWPAurPaLITCZgpxdWvP3C9tPU439uBkqbe7bs2
         k4Azl4ZBd2J/jkfVL4W8xfLNQlrukjlFGz6+K/3R/hfPm2s/JExeXbezGg5myXVWGx
         yBKjwlwSl/BfxYaOVeZng1mKRjg2rnaaFGpALT2MR32V+ccmrcLAfECVj9o67Tv4Yu
         1XYmYNRQlh6yEOs4RzQhzJMHtR6PwGOQ7AcYIVvUaTXIopG/q893Y94O3FVUxM7KJy
         yR9kAo5Ro0to5WWP0qtLRHql0ZT8/n2e5O1SVeAuP1b2OtCojRs+Q2AkAB+OKLtWpO
         rFGpF+t+Pdi7Q==
Received: from us01wehtc1.internal.synopsys.com (us01wehtc1-vip.internal.synopsys.com [10.12.239.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id C67D4A0067;
        Fri, 19 Jul 2019 01:12:41 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 us01wehtc1.internal.synopsys.com (10.12.239.235) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Thu, 18 Jul 2019 18:12:27 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (10.13.134.195)
 by mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Thu, 18 Jul 2019 18:12:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MPkjuDO0LASos7lNQ0LQRzW0bkZR1eF57DmIq159FprVpergPVE3x1nCT80k6gz+wPExZJ2Giup7w91nFZPteXvgYW3OyUPsu2OBWDmLsI3q9pYCk+y724/zm/VxU4OLVVwDHC0BVWv6AM9Blt3rEUwU3g6W9pK5Mqn4CtoBb8MVgkpThyL8eIhx1reThdA5xQMUDBcF7U1rm/lANWn7n1tPDdsxS305LbJc9dDCru5FSLAJ1kXsvSeUVZc3TjGIRHhqyUwfip1Pcdm/OBQ8oIOfCDgGs96yKzbWUPj6/ZhMbyHikFzY0VK34d8afb6TSTDyTIeu0qBPcU7oXs2JMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kcb/lyfE4ajOmgKbnd1bCGg+RjzdKNu8rIsqTRRG1C0=;
 b=kdMHFWU45XRPofdcq/j06wl+IJqBuZJrJSJ+HgCpQO+Z60eJ6ZF/KNrfC8p+wb27YOp4prPHaI7CnRLVVMnZjJnhgCCbUvlXsIH7IxKk1fCh/+QLG84CbxevqQDHsPJnP0W/v7EEf532mB0xCflNOC0TjyhqwX8Z9ysX9P0cg7Vzu+/NNW7XwRDNITj1PavD2lWL77Cbg0sboM4Pwnr2Z0cb5+an3RRtmMsBY7NEB4Mx5c/9VX4FNCm9YHsI0vfeGUgAshwePgMlDWAHfrhsfTZQ3AkKpZusBR0ONuvhOxRhusN7eL7ZmYqus/GHAWH2H4AX2aCui+N8RZolZXcCEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=synopsys.com;dmarc=pass action=none
 header.from=synopsys.com;dkim=pass header.d=synopsys.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector1-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kcb/lyfE4ajOmgKbnd1bCGg+RjzdKNu8rIsqTRRG1C0=;
 b=vJw3r6CfLVcFIhlpHluoRBZzqTUGU9eAmjTm502aObT/qN/1Lo/DUFVGjU/6Tudcny5qd5FEYDSem/iSKmI6s5AjzJ93qDBF6iXODv+iCwaUO0MSPodPs/Mq4mrwvEFdNaysk68gyJaDBgVFWw64LARtNM4thdVzGPk7j/GYcgI=
Received: from CY4PR1201MB0037.namprd12.prod.outlook.com (10.172.78.22) by
 CY4PR1201MB0022.namprd12.prod.outlook.com (10.172.79.8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.11; Fri, 19 Jul 2019 01:12:25 +0000
Received: from CY4PR1201MB0037.namprd12.prod.outlook.com
 ([fe80::8dd:b2af:d63f:c339]) by CY4PR1201MB0037.namprd12.prod.outlook.com
 ([fe80::8dd:b2af:d63f:c339%9]) with mapi id 15.20.2094.011; Fri, 19 Jul 2019
 01:12:25 +0000
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
To:     "fei.yang@intel.com" <fei.yang@intel.com>,
        "felipe.balbi@linux.intel.com" <felipe.balbi@linux.intel.com>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>,
        "andrzej.p@collabora.com" <andrzej.p@collabora.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v3] usb: dwc3: gadget: trb_dequeue is not updated properly
Thread-Topic: [PATCH v3] usb: dwc3: gadget: trb_dequeue is not updated
 properly
Thread-Index: AQHVPct5482iA1i8Sk2wptVdWd1tFw==
Date:   Fri, 19 Jul 2019 01:12:24 +0000
Message-ID: <CY4PR1201MB003708ADAD79BF4FD24D3445AACB0@CY4PR1201MB0037.namprd12.prod.outlook.com>
References: <1563497183-7114-1-git-send-email-fei.yang@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=thinhn@synopsys.com; 
x-originating-ip: [198.182.56.5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 518887a1-60a7-4333-2b37-08d70be628c9
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:CY4PR1201MB0022;
x-ms-traffictypediagnostic: CY4PR1201MB0022:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <CY4PR1201MB0022B8F9455CD2259B7EA4EEAACB0@CY4PR1201MB0022.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2887;
x-forefront-prvs: 01039C93E4
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(136003)(366004)(39860400002)(346002)(376002)(189003)(199004)(99286004)(81156014)(8936002)(256004)(6116002)(3846002)(81166006)(14444005)(2906002)(8676002)(68736007)(25786009)(33656002)(14454004)(316002)(110136005)(486006)(76176011)(102836004)(2501003)(6506007)(229853002)(7696005)(66556008)(26005)(71190400001)(71200400001)(66446008)(5660300002)(66066001)(66476007)(66946007)(64756008)(76116006)(91956017)(86362001)(476003)(446003)(186003)(2201001)(478600001)(6306002)(55016002)(9686003)(53936002)(7736002)(305945005)(6436002)(966005)(74316002)(6246003)(52536014);DIR:OUT;SFP:1102;SCL:1;SRVR:CY4PR1201MB0022;H:CY4PR1201MB0037.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Uz0ujBzyUUwKck5oJb/b512s0AsgVga2cy5pjFiZkMFpDvi+HYJTYCZB1rvPBbhkaPAyEYl59VJtQ7RB58TeXGCcBMYTKSFBmsLM4ABTkrZW+TEDA3zYTzU9AW9aRsuEbvqQghk9KRDcIBB8aPKBbHdrqG++QvR51dJegyIGFQWJ8qn+eQdJ91NM4BxDb3OW5ueRlG4QoUh2sUJcvlw5zvDHItUVbrtwFE+/ERzVkgiAvyscV+IhguqdpIiXOKJthtsdd6k9mK/e/GUDeVMEGVBJghigu5aVPxr2n86k2fpUVuHmzRZoIEnDOJo6IekJDZt/kvse1WDbzjULxXlvH/tuubSJIroZB+S1IbxKox/hEmf3hf9YzUzCj+j05z2kvNzRkO+eM9WkGUdRq6vXlVZplvQUcWpy1c4R4gPa0yI=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 518887a1-60a7-4333-2b37-08d70be628c9
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jul 2019 01:12:24.9321
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: thinhn@synopsys.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0022
X-OriginatorOrg: synopsys.com
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,=0A=
=0A=
fei.yang@intel.com wrote:=0A=
> From: Fei Yang <fei.yang@intel.com>=0A=
>=0A=
> If scatter-gather operation is allowed, a large USB request is split into=
=0A=
> multiple TRBs. These TRBs are chained up by setting DWC3_TRB_CTRL_CHN bit=
=0A=
> except the last one which has DWC3_TRB_CTRL_IOC bit set instead.=0A=
> Since only the last TRB has IOC set for the whole USB request, the=0A=
> dwc3_gadget_ep_reclaim_trb_sg() gets called only once after the last TRB=
=0A=
> completes and all the TRBs allocated for this request are supposed to be=
=0A=
> reclaimed. However that is not what the current code does.=0A=
>=0A=
> dwc3_gadget_ep_reclaim_trb_sg() is trying to reclaim all the TRBs in the=
=0A=
> following for-loop,=0A=
> 	for_each_sg(sg, s, pending, i) {=0A=
> 		trb =3D &dep->trb_pool[dep->trb_dequeue];=0A=
>=0A=
>                 if (trb->ctrl & DWC3_TRB_CTRL_HWO)=0A=
>                         break;=0A=
>=0A=
>                 req->sg =3D sg_next(s);=0A=
>                 req->num_pending_sgs--;=0A=
>=0A=
>                 ret =3D dwc3_gadget_ep_reclaim_completed_trb(dep, req,=0A=
>                                 trb, event, status, chain);=0A=
>                 if (ret)=0A=
>                         break;=0A=
>         }=0A=
> but since the interrupt comes only after the last TRB completes, the=0A=
> event->status has DEPEVT_STATUS_IOC bit set, so that the for-loop ends fo=
r=0A=
> the first TRB due to dwc3_gadget_ep_reclaim_completed_trb() returns 1.=0A=
> 	if (event->status & DEPEVT_STATUS_IOC)=0A=
> 		return 1;=0A=
>=0A=
> This patch addresses the issue by checking each TRB in function=0A=
> dwc3_gadget_ep_reclaim_trb_sg() and maing sure the chained ones are prope=
rly=0A=
> reclaimed. dwc3_gadget_ep_reclaim_completed_trb() will return 1 Only for =
the=0A=
> last TRB.=0A=
>=0A=
> Signed-off-by: Fei Yang <fei.yang@intel.com>=0A=
> Cc: stable <stable@vger.kernel.org>=0A=
> ---=0A=
> v2: Better solution is to reclaim chained TRBs in dwc3_gadget_ep_reclaim_=
trb_sg()=0A=
>     and leave the last TRB to the dwc3_gadget_ep_reclaim_completed_trb().=
=0A=
> v3: Checking DWC3_TRB_CTRL_CHN bit for each TRB instead, and making sure =
that=0A=
>     dwc3_gadget_ep_reclaim_completed_trb() returns 1 only for the last TR=
B.=0A=
> ---=0A=
>  drivers/usb/dwc3/gadget.c | 11 ++++++++---=0A=
>  1 file changed, 8 insertions(+), 3 deletions(-)=0A=
>=0A=
> diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c=0A=
> index 173f532..88eed49 100644=0A=
> --- a/drivers/usb/dwc3/gadget.c=0A=
> +++ b/drivers/usb/dwc3/gadget.c=0A=
> @@ -2394,7 +2394,7 @@ static int dwc3_gadget_ep_reclaim_completed_trb(str=
uct dwc3_ep *dep,=0A=
>  	if (event->status & DEPEVT_STATUS_SHORT && !chain)=0A=
>  		return 1;=0A=
>  =0A=
> -	if (event->status & DEPEVT_STATUS_IOC)=0A=
> +	if (event->status & DEPEVT_STATUS_IOC && !chain)=0A=
>  		return 1;=0A=
>  =0A=
>  	return 0;=0A=
> @@ -2404,11 +2404,12 @@ static int dwc3_gadget_ep_reclaim_trb_sg(struct d=
wc3_ep *dep,=0A=
>  		struct dwc3_request *req, const struct dwc3_event_depevt *event,=0A=
>  		int status)=0A=
>  {=0A=
> -	struct dwc3_trb *trb =3D &dep->trb_pool[dep->trb_dequeue];=0A=
> +	struct dwc3_trb *trb;=0A=
>  	struct scatterlist *sg =3D req->sg;=0A=
>  	struct scatterlist *s;=0A=
>  	unsigned int pending =3D req->num_pending_sgs;=0A=
>  	unsigned int i;=0A=
> +	int chain =3D false;=0A=
>  	int ret =3D 0;=0A=
>  =0A=
>  	for_each_sg(sg, s, pending, i) {=0A=
> @@ -2419,9 +2420,13 @@ static int dwc3_gadget_ep_reclaim_trb_sg(struct dw=
c3_ep *dep,=0A=
>  =0A=
>  		req->sg =3D sg_next(s);=0A=
>  		req->num_pending_sgs--;=0A=
> +		if (trb->ctrl & DWC3_TRB_CTRL_CHN)=0A=
> +			chain =3D true;=0A=
> +		else=0A=
> +			chain =3D false;=0A=
>  =0A=
>  		ret =3D dwc3_gadget_ep_reclaim_completed_trb(dep, req,=0A=
> -				trb, event, status, true);=0A=
> +				trb, event, status, chain);=0A=
>  		if (ret)=0A=
>  			break;=0A=
>  	}=0A=
=0A=
There was already a fix a long time ago by Anurag. But it never made it=0A=
to the kernel mainline. You can check this out:=0A=
https://patchwork.kernel.org/patch/10640137/=0A=
=0A=
Hi Felipe,=0A=
=0A=
Maybe you can review and cherry-pick that patch?=0A=
=0A=
Thanks,=0A=
Thinh=0A=
