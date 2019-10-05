Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F441CC774
	for <lists+stable@lfdr.de>; Sat,  5 Oct 2019 05:04:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725974AbfJEDEl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Oct 2019 23:04:41 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:5038 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725887AbfJEDEl (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Oct 2019 23:04:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1570244746; x=1601780746;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=rEVjToQkXPNATVZAnO+gB1aojuWSQr8StfWDT29pLUA=;
  b=HWw+DIuk+inCgRp6hcv2fM+uZ8xIfyQxckLGCJ1AG7K6alQ8rasLMoec
   FY5Pb9mraWusl+LsmZSz8dzk3pdSlGjqHBp0tdTld7I4bl+BRKvOZkW/B
   6/GawnOjilFWRA6EXkZm39z3SELugRsmWBcjLILxvlyu8C+A+znqYe53D
   38QkvKVjM6UiTT60pVSyZAerDUfwY2wUYwyP3U4Q5eQ17EIaoLL/xAEAD
   rSBiFUFXVbxSH+ISBq20XMph7qhAvW4BFQZdG1CkQ+GD6ESotNkRfnDO7
   yxm3i0wJ2XqnBL+KonXAK+NViIhn5UCpG9ZyNaQHH9Yi1iV2wHNmrtFH5
   w==;
IronPort-SDR: /hUE1CzODB0h08MTVOhT7FPBK0Ds04aKrCujUOUmnDV++HATQgbjIxDVRoVxpLgyteb5mmXLyV
 Djrh8gho4I/6QCVGVBQfhgs9RPhfH4M1ze7E0O03xIUcQIBQk67FTPXo+u9e7ciOSGU6MTLA/3
 3HBV3Qs5oSs29sK0wVOpb4YfSw6O21gJqtdscnnJ+j9g6yrDI0K9q4L05O/D0fOE6OjrrasQFI
 Tk2NE6j/8MPgte/YQgFHHsIV7+YNcxzjq9PvWZ/y10AK+WKP+xiQWrMPdrHbMn1q9xfZTs7j8I
 R3A=
X-IronPort-AV: E=Sophos;i="5.67,258,1566835200"; 
   d="scan'208";a="220794169"
Received: from mail-sn1nam01lp2054.outbound.protection.outlook.com (HELO NAM01-SN1-obe.outbound.protection.outlook.com) ([104.47.32.54])
  by ob1.hgst.iphmx.com with ESMTP; 05 Oct 2019 11:05:44 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PBVAK3mcBS7JDlrlrsjeggw//rQoW/e29ScEEBzBuUnW3HfPE992zzv0cshtv5MkEEo7mSQryFPNb8qN7+83suF4ivhhKVMeHwmAOf3ET2iVaKLl44Udcw4II4X0/J+uqK240OKlq9H7VRgRbmcNBK0egmR0QNWan5ZPO1Sa3y0y418ximTI4YjvCRiJ8StoDwq6efJwlpC5AQkay2cXADOQ2QWn6rSXwl6dDCZMTT49jXH/34krqIU0ZfN/2lWfINeC54WQkQBkSx7REjb/CDHXX6Un51hPmmcCPl3hloRyZjUJUvAWY9x5+iZdWdVHeW8fjKbKhYIbRHQbwVLIbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I9ZctBl1TpTIljHoGl5pavWgcav+V548NYPukwx9kAw=;
 b=Ecd6m1uZwjAPxtO19yeA1zJkooLz3ZMkh6uoUIoFbwzayM8ZpXB4qmMFWOnCyt7gf+af4LNsgWNmt/2klQk3jQ6/PLoyR7qk/E7kop0iLeqdzWjRR3WMYuPTIUl9BPEOPcorzcEDUGFkVkvL2MLCV/vNXYSVJr6fo6A0ziq1EdIyiduSy6+EJlYAH/AnVdXAF1BfBBFV7dDeMF734S+7t4qtohiRhR5nD1ORY2uBrrUOmI7X1IW6AvF34ABxwLTj+hSVhXARmTEtcFgazDwu2uPh1yjE5RMvp+578ZE0LmfsyZp0CaI8Qj4XcVoQe0N4CVIbUbHyO3tf13ECnJNtVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I9ZctBl1TpTIljHoGl5pavWgcav+V548NYPukwx9kAw=;
 b=BtDNFoidbILv1RFbHNKZ7Z4HIlIOhXmefgPevkfoB+uq8duN6HmdqULBe1OzZ7hd+o/j8YGmE8eqr3PEH0CkSSPD2+9w/iHUdQ0spuJDGLXXqwPm6dC6UXB/Ve4lPgGOAGMm/wUOIEj1XEZfpJX2rfZeOKdc+BXu4A3hUTGumLY=
Received: from BYAPR04MB5816.namprd04.prod.outlook.com (20.179.59.16) by
 BYAPR04MB5416.namprd04.prod.outlook.com (20.178.50.225) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.22; Sat, 5 Oct 2019 03:04:38 +0000
Received: from BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::84c4:833e:ec0b:5053]) by BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::84c4:833e:ec0b:5053%2]) with mapi id 15.20.2327.023; Sat, 5 Oct 2019
 03:04:38 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Hans Holmberg <Hans.Holmberg@wdc.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>, "hch@lst.de" <hch@lst.de>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] block: mq-deadline: Fix queue restart
 handling" failed to apply to 4.19-stable tree
Thread-Topic: FAILED: patch "[PATCH] block: mq-deadline: Fix queue restart
 handling" failed to apply to 4.19-stable tree
Thread-Index: AQHVefAwZYHc2XNi/kOVZstHgkthwQ==
Date:   Sat, 5 Oct 2019 03:04:38 +0000
Message-ID: <BYAPR04MB5816811EDFD9C0BC834026A5E7990@BYAPR04MB5816.namprd04.prod.outlook.com>
References: <1570110048170134@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Damien.LeMoal@wdc.com; 
x-originating-ip: [129.253.240.72]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3638e858-7029-4958-59fc-08d74940c287
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: BYAPR04MB5416:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR04MB5416AB11BEF35D991352AE4FE7990@BYAPR04MB5416.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0181F4652A
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(366004)(39860400002)(396003)(346002)(376002)(189003)(199004)(229853002)(9686003)(6436002)(4326008)(6246003)(110136005)(25786009)(26005)(186003)(102836004)(446003)(53546011)(76176011)(6506007)(52536014)(316002)(14454004)(33656002)(486006)(476003)(55016002)(478600001)(7696005)(71190400001)(71200400001)(256004)(5660300002)(14444005)(66066001)(2906002)(66446008)(66556008)(91956017)(3846002)(66476007)(76116006)(64756008)(66946007)(86362001)(8936002)(81166006)(8676002)(2201001)(81156014)(7736002)(2501003)(99286004)(305945005)(74316002)(6116002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR04MB5416;H:BYAPR04MB5816.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hx0todRs9BYP1AU+rTgA+wDn9CiydWJ6gtJaoPc9IB6FsBA+PzNjZEST9GDqRvdStEtmSh1vPcst80CbFtdN7yklcBei9PLFEpwUOM+Gv0VKQO3O9A9UF41xVkYTkAWC3lVcl9t0LckfA2VN92fTFNnZ7SSeMMaYQRtvBxEZQxYqTOt31uw1ycGJmHPuZhaXuLpj76vez0ZHYX/EZTXcs8jGuc92eO+FD6UQc0eJ1tt09EM9nMdc2DJuAMIqjOf1UA1H0WnEzPUtG3jo0lB86e+vivxi63JAjfoPCXJfEU4kZ1em51gtg+ZyLWyqbMqdHxmTUu0x/gJ+uDMDSrU+Sg/Kvw4V2xg5u0x6iHCh4k1DX4pgVrYfJ23lhT9YH0oqZ1i3n8fOg0nbyFnhXwKuutXgdtO8HwFCQx5NxjqQA9Y=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3638e858-7029-4958-59fc-08d74940c287
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Oct 2019 03:04:38.6079
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: diQMV/2c4/ZwxBpgiYNj74jFSC1uDzT5PFg16P1a/aVVA1rX4Ev5DIsJlu0NVVdbRJ6H7Bmz9VwUa2isB8DxmQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB5416
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greg,=0A=
=0A=
On 2019/10/03 15:40, gregkh@linuxfoundation.org wrote:=0A=
> =0A=
> The patch below does not apply to the 4.19-stable tree.=0A=
> If someone wants it applied there, or to any other stable or longterm=0A=
> tree, then please email the backport, including the original git commit=
=0A=
> id to <stable@vger.kernel.org>.=0A=
> =0A=
> thanks,=0A=
> =0A=
> greg k-h=0A=
=0A=
I sent the backported (and tested) patch. Please consider it for addition t=
o 4.19.=0A=
=0A=
Thank you.=0A=
=0A=
Best regards.=0A=
=0A=
> =0A=
> ------------------ original commit in Linus's tree ------------------=0A=
> =0A=
> From cb8acabbe33b110157955a7425ee876fb81e6bbc Mon Sep 17 00:00:00 2001=0A=
> From: Damien Le Moal <damien.lemoal@wdc.com>=0A=
> Date: Wed, 28 Aug 2019 13:40:20 +0900=0A=
> Subject: [PATCH] block: mq-deadline: Fix queue restart handling=0A=
> =0A=
> Commit 7211aef86f79 ("block: mq-deadline: Fix write completion=0A=
> handling") added a call to blk_mq_sched_mark_restart_hctx() in=0A=
> dd_dispatch_request() to make sure that write request dispatching does=0A=
> not stall when all target zones are locked. This fix left a subtle race=
=0A=
> when a write completion happens during a dispatch execution on another=0A=
> CPU:=0A=
> =0A=
> CPU 0: Dispatch			CPU1: write completion=0A=
> =0A=
> dd_dispatch_request()=0A=
>     lock(&dd->lock);=0A=
>     ...=0A=
>     lock(&dd->zone_lock);	dd_finish_request()=0A=
>     rq =3D find request		lock(&dd->zone_lock);=0A=
>     unlock(&dd->zone_lock);=0A=
>     				zone write unlock=0A=
> 				unlock(&dd->zone_lock);=0A=
> 				...=0A=
> 				__blk_mq_free_request=0A=
>                                       check restart flag (not set)=0A=
> 				      -> queue not run=0A=
>     ...=0A=
>     if (!rq && have writes)=0A=
>         blk_mq_sched_mark_restart_hctx()=0A=
>     unlock(&dd->lock)=0A=
> =0A=
> Since the dispatch context finishes after the write request completion=0A=
> handling, marking the queue as needing a restart is not seen from=0A=
> __blk_mq_free_request() and blk_mq_sched_restart() not executed leading=
=0A=
> to the dispatch stall under 100% write workloads.=0A=
> =0A=
> Fix this by moving the call to blk_mq_sched_mark_restart_hctx() from=0A=
> dd_dispatch_request() into dd_finish_request() under the zone lock to=0A=
> ensure full mutual exclusion between write request dispatch selection=0A=
> and zone unlock on write request completion.=0A=
> =0A=
> Fixes: 7211aef86f79 ("block: mq-deadline: Fix write completion handling")=
=0A=
> Cc: stable@vger.kernel.org=0A=
> Reported-by: Hans Holmberg <Hans.Holmberg@wdc.com>=0A=
> Reviewed-by: Hans Holmberg <hans.holmberg@wdc.com>=0A=
> Reviewed-by: Christoph Hellwig <hch@lst.de>=0A=
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
> Signed-off-by: Jens Axboe <axboe@kernel.dk>=0A=
> =0A=
> diff --git a/block/mq-deadline.c b/block/mq-deadline.c=0A=
> index 2a2a2e82832e..35e84bc0ec8c 100644=0A=
> --- a/block/mq-deadline.c=0A=
> +++ b/block/mq-deadline.c=0A=
> @@ -377,13 +377,6 @@ static struct request *__dd_dispatch_request(struct =
deadline_data *dd)=0A=
>   * hardware queue, but we may return a request that is for a=0A=
>   * different hardware queue. This is because mq-deadline has shared=0A=
>   * state for all hardware queues, in terms of sorting, FIFOs, etc.=0A=
> - *=0A=
> - * For a zoned block device, __dd_dispatch_request() may return NULL=0A=
> - * if all the queued write requests are directed at zones that are alrea=
dy=0A=
> - * locked due to on-going write requests. In this case, make sure to mar=
k=0A=
> - * the queue as needing a restart to ensure that the queue is run again=
=0A=
> - * and the pending writes dispatched once the target zones for the ongoi=
ng=0A=
> - * write requests are unlocked in dd_finish_request().=0A=
>   */=0A=
>  static struct request *dd_dispatch_request(struct blk_mq_hw_ctx *hctx)=
=0A=
>  {=0A=
> @@ -392,9 +385,6 @@ static struct request *dd_dispatch_request(struct blk=
_mq_hw_ctx *hctx)=0A=
>  =0A=
>  	spin_lock(&dd->lock);=0A=
>  	rq =3D __dd_dispatch_request(dd);=0A=
> -	if (!rq && blk_queue_is_zoned(hctx->queue) &&=0A=
> -	    !list_empty(&dd->fifo_list[WRITE]))=0A=
> -		blk_mq_sched_mark_restart_hctx(hctx);=0A=
>  	spin_unlock(&dd->lock);=0A=
>  =0A=
>  	return rq;=0A=
> @@ -561,6 +551,13 @@ static void dd_prepare_request(struct request *rq, s=
truct bio *bio)=0A=
>   * spinlock so that the zone is never unlocked while deadline_fifo_reque=
st()=0A=
>   * or deadline_next_request() are executing. This function is called for=
=0A=
>   * all requests, whether or not these requests complete successfully.=0A=
> + *=0A=
> + * For a zoned block device, __dd_dispatch_request() may have stopped=0A=
> + * dispatching requests if all the queued requests are write requests di=
rected=0A=
> + * at zones that are already locked due to on-going write requests. To e=
nsure=0A=
> + * write request dispatch progress in this case, mark the queue as needi=
ng a=0A=
> + * restart to ensure that the queue is run again after completion of the=
=0A=
> + * request and zones being unlocked.=0A=
>   */=0A=
>  static void dd_finish_request(struct request *rq)=0A=
>  {=0A=
> @@ -572,6 +569,8 @@ static void dd_finish_request(struct request *rq)=0A=
>  =0A=
>  		spin_lock_irqsave(&dd->zone_lock, flags);=0A=
>  		blk_req_zone_write_unlock(rq);=0A=
> +		if (!list_empty(&dd->fifo_list[WRITE]))=0A=
> +			blk_mq_sched_mark_restart_hctx(rq->mq_hctx);=0A=
>  		spin_unlock_irqrestore(&dd->zone_lock, flags);=0A=
>  	}=0A=
>  }=0A=
> =0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
