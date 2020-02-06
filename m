Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74F87154B67
	for <lists+stable@lfdr.de>; Thu,  6 Feb 2020 19:46:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727698AbgBFSq6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Feb 2020 13:46:58 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:57315 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726990AbgBFSq6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Feb 2020 13:46:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1581014819; x=1612550819;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=AotBydzGNLGUzWkFSVV2Y/q2r/FTyRqqoTrN0sMKto4=;
  b=hES5HbTc+1pXW712WOCjX/5hxuRfUQU7+SldiL7PDEyGADY2CMTHLn8x
   w6UADtyeuogj9jp72TC3D3a6fvcxPW749iicp187Z7KYIp6bIrTIsznmr
   il4+n9vk7k6CkdmlVl7l073B3bjlSVfpHASSxX/qa9MESLvS+yZhVXCX1
   PaBNG3Qiq7EA5fEAsPo197YVDDsAdJg6k0Gpw4OYXV5xTyCosbxC6bdSL
   xRspLHvvTqfGTyAYNJCEendJBroOkpklblOVCbFgJOe12Hu8y6Img4U1n
   GhxODBXhX6xGwmV9C6R3mTvBi9RmoDW2fF1apE/Q++C6MkN7k+qkqubj7
   A==;
IronPort-SDR: GgOjHaibIqEkyggAGuAw7itMC8sb46lmQ2gpqvzvc5gljhLd+LKJBypTcTFTObNbfl75Zkgskd
 YhazxaFUsPpxGUO3sSjqngY4YJZRC3Henw5+tRri3csPQyLS3wpvVOMyBjQRFuhdCBv5F4BCBn
 j8IRTok4Y90o9vw+WWU2Fh6Gt3kNMf8ZHrh55DTj2IIXgjWeu+MATQgk518iy3Eu/1YLRV/AW2
 ouRwrQwFUJM1BqihWnM4vB0DCMqrTmEwxoGQiUQ0nEMDBf8WFQmbsijUugXFJlk8DMEsJ5q4p1
 3wg=
X-IronPort-AV: E=Sophos;i="5.70,410,1574092800"; 
   d="scan'208";a="129836473"
Received: from mail-dm6nam10lp2102.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.102])
  by ob1.hgst.iphmx.com with ESMTP; 07 Feb 2020 02:46:58 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lxi4G4k4UNilbf+aru3CBwlarnvRG0kBdffqU5SKQIcElr/RxPsHCmVNpJnZlHK8Z1oMdRR1gI3ci1EIaZiIbcVr8UtO691tRcPsWdvqfu48074YLhBCwIbLfA+Q8dxEDwCsz/efai0Ubx6yH3EAVV3ELWrDojgqvWv5+o3gVUVTxXTFEPfTApdo9/Ly5VGb40CJTtQRUupa9lfHyhUt46gE711Qc2qDzz+dcr6Zvok39Dfx7I+OYduHrtZ9aSPfUI4dSfsBeea/M9MZUgYCgc/LrMgSv8U14NM5Sqtm/JVJrXxas1GZF8FiE/xh9kxSnRZ2vXn4eJjtN24eQ4MYkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xtYyCZ7uxvpLZeiwhG5YR3zrTeHc6HqioVJpOUHHuAI=;
 b=FQ7sgweSAGpf286T9z4fmfakH70hoIHG8NsXelic3Qq6zsVs589rtnec7+zjaAZOfzJaJNFO17ohM0SsvLsZSa4yIIQ4JakXXh1dcfh8KEBBnOo8GLAZABdoE9or79knejtJxlS31SItLohibgR/v9vCzovj14FXlMuMM4fxk9HipE4kZ5gVVP9jADMws3bGq6FQWQS60x2WrUBg+54GRjGcGXoLBKvQ7c+FsmE0+lORPlYSibI8fbi2OhdxRXXRoSqfmmE177Pic/kGuLJDJ2o4DdTZDfLwnh9R7zZic96W2LdsJYkVYyQOftdUFYbt6PpGBSWe/VoD8Q9fzmYomg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xtYyCZ7uxvpLZeiwhG5YR3zrTeHc6HqioVJpOUHHuAI=;
 b=Qb60/baaXwN9OtKsPLTbyP+VtaG0W/SOKky2SIo7k/etS9b4sW8K6rwkFjhgAZu+7iwcnCRdYrKjOdgbZV6iDl65L4w2mRdJoV1RQ8RHMuNKC+zrwo7rdQ3LQdrelIVGMXRgyTdYVd/qTohpkYzkFVC6Bf7Cn5hppp4esbz8X1o=
Received: from BYAPR04MB5749.namprd04.prod.outlook.com (20.179.57.21) by
 BYAPR04MB4966.namprd04.prod.outlook.com (52.135.236.91) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2707.21; Thu, 6 Feb 2020 18:46:55 +0000
Received: from BYAPR04MB5749.namprd04.prod.outlook.com
 ([fe80::a8ea:4ba9:cb57:e90f]) by BYAPR04MB5749.namprd04.prod.outlook.com
 ([fe80::a8ea:4ba9:cb57:e90f%5]) with mapi id 15.20.2707.023; Thu, 6 Feb 2020
 18:46:55 +0000
From:   Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To:     Jan Kara <jack@suse.cz>
CC:     Jens Axboe <axboe@kernel.dk>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "tristmd@gmail.com" <tristmd@gmail.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH] blktrace: Protect q->blk_trace with RCU
Thread-Topic: [PATCH] blktrace: Protect q->blk_trace with RCU
Thread-Index: AQHV3Pm1sBn7cXCscUyQVcxbWOqGBg==
Date:   Thu, 6 Feb 2020 18:46:55 +0000
Message-ID: <BYAPR04MB5749BAE3D6813845E16D92E2861D0@BYAPR04MB5749.namprd04.prod.outlook.com>
References: <20200206142812.25989-1-jack@suse.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chaitanya.Kulkarni@wdc.com; 
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 4c0ef2b0-71d7-490c-6d8e-08d7ab34f054
x-ms-traffictypediagnostic: BYAPR04MB4966:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR04MB4966EA1A847EA2FE1975044C861D0@BYAPR04MB4966.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:513;
x-forefront-prvs: 0305463112
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(39860400002)(366004)(136003)(346002)(376002)(199004)(189003)(52536014)(76116006)(33656002)(316002)(66946007)(54906003)(66476007)(64756008)(4326008)(66446008)(66556008)(71200400001)(9686003)(55016002)(966005)(478600001)(5660300002)(86362001)(8936002)(81156014)(8676002)(81166006)(2906002)(7696005)(53546011)(186003)(6506007)(26005)(6916009)(309714004)(6606295002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR04MB4966;H:BYAPR04MB5749.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4V8NbrbuNhYHion4HHKP4L066arLrG1EOA6zpF61S8UJXboWVyjK2M2aNqPz58wO2uJc/Gxb4cKYXGYZ2G1h6s3Q6G+77k6YZjqBBUIBvKxK5s/CH2aCS07NrkvhdXJOfKzi84EwcZCg93ZkxrOz7Vj5sWSXRodTDOPJ7Q8NpHh7z2SmpKSdzfdYN+R++wE/FeL/AZtZtzoMrzDbiXR6IhEN6BJRnD1pjCYKdjZMGQAODxmjkidjV+7bjK1UZw9SOz/Teua8n8ryRGUDbXOcE3Lp63IMyYQSSqo7bm83/HC0ZPWkDq2r/GKCv+Tnt1EH79yn5ZUjzvC4Qc2K5bpoHOWXzm5StzDzBQ+nCj1F+7L77j/odBDvspmvnQ4LZJxzZEG+EkkIMBWyHtBTKbtdFMicMydH5nm4oUcJSt2tFkE9HIvp0CPYmHnuZskQmxV0wPfr3o6ZNujsjyCyi53WZ6sH9yZqKkHEpflAlNDZZh0N4VTYU/H/mSROadi58vh0Pc9jyTfmp+yFL+ZOr/3wXb4eBNGNd+sDw6Ax00j3/A10W8QT3ncXa4otOfiF9RDasLKHizb1xhwaUBY+PcaTJC4LMNljbq2wn3jaAT90yjw=
x-ms-exchange-antispam-messagedata: snljiLQncvLETK9CmKHGGsP7NLE/QCP+bTbDEpM57ZkiWXVbRCa5DdNiqkyhhnklF1hsuahJh9lODV2Cj3LmVDxBiyeEvy9X3BDa2Eg4i75thwAlGSCZdnOKE5f+/oALA6nXX2RHjK85FWANX+Y56Q==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c0ef2b0-71d7-490c-6d8e-08d7ab34f054
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Feb 2020 18:46:55.3129
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tFRbJtK29quEzAy6GLpVTCJXcXXxNUhdSDvhopKpWWdNHedAtUQ8fkQtmMVTqFgiHFS5Aei5nUQztNvS0RVF5U2X7015PiYWagk8O/U1gOE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB4966
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Jan,=0A=
=0A=
What do you think about following patch on the top of yours ?=0A=
=0A=
The new helper that I've added on the top of your patch will also=0A=
future uses of the rcu_dereference_protected(). e.g. blktrace=0A=
extension [1] support that I'm working on.=0A=
=0A=
P.S. it is compile only if your okay I'll send a separate patch.=0A=
=0A=
+=0A=
+/* Dereference q->blk_trace with q->blk_trace_mutex check only. */=0A=
+static inline struct blk_trace *blk_trace_rcu_deref(struct =0A=
request_queue *q)=0A=
+{=0A=
+       return rcu_dereference_protected(q->blk_trace,=0A=
+ =0A=
lockdep_is_held(&q->blk_trace_mutex));=0A=
+}=0A=
  /*=0A=
   * Send out a notify message.=0A=
   */=0A=
@@ -632,8 +639,7 @@ static int __blk_trace_startstop(struct =0A=
request_queue *q, int start)=0A=
         int ret;=0A=
         struct blk_trace *bt;=0A=
=0A=
-       bt =3D rcu_dereference_protected(q->blk_trace,=0A=
- =0A=
lockdep_is_held(&q->blk_trace_mutex));=0A=
+       bt =3D blk_trace_rcu_deref(q);=0A=
         if (bt =3D=3D NULL)=0A=
                 return -EINVAL;=0A=
=0A=
@@ -743,8 +749,7 @@ int blk_trace_ioctl(struct block_device *bdev, =0A=
unsigned cmd, char __user *arg)=0A=
  void blk_trace_shutdown(struct request_queue *q)=0A=
  {=0A=
         mutex_lock(&q->blk_trace_mutex);=0A=
-       if (rcu_dereference_protected(q->blk_trace,=0A=
- =0A=
lockdep_is_held(&q->blk_trace_mutex))) {=0A=
+       if (blk_trace_rcu_deref(q)) {=0A=
                 __blk_trace_startstop(q, 0);=0A=
                 __blk_trace_remove(q);=0A=
         }=0A=
@@ -1817,8 +1822,7 @@ static ssize_t sysfs_blk_trace_attr_show(struct =0A=
device *dev,=0A=
=0A=
         mutex_lock(&q->blk_trace_mutex);=0A=
=0A=
-       bt =3D rcu_dereference_protected(q->blk_trace,=0A=
- =0A=
lockdep_is_held(&q->blk_trace_mutex));=0A=
+       bt =3D blk_trace_rcu_deref(q);=0A=
         if (attr =3D=3D &dev_attr_enable) {=0A=
                 ret =3D sprintf(buf, "%u\n", !!bt);=0A=
                 goto out_unlock_bdev;=0A=
@@ -1881,8 +1885,7 @@ static ssize_t sysfs_blk_trace_attr_store(struct =0A=
device *dev,=0A=
=0A=
         mutex_lock(&q->blk_trace_mutex);=0A=
=0A=
-       bt =3D rcu_dereference_protected(q->blk_trace,=0A=
- =0A=
lockdep_is_held(&q->blk_trace_mutex));=0A=
+       bt =3D blk_trace_rcu_deref(q);=0A=
         if (attr =3D=3D &dev_attr_enable) {=0A=
                 if (!!value =3D=3D !!bt) {=0A=
                         ret =3D 0;=0A=
=0A=
On 02/06/2020 06:28 AM, Jan Kara wrote:=0A=
> KASAN is reporting that __blk_add_trace() has a use-after-free issue=0A=
> when accessing q->blk_trace. Indeed the switching of block tracing (and=
=0A=
> thus eventual freeing of q->blk_trace) is completely unsynchronized with=
=0A=
> the currently running tracing and thus it can happen that the blk_trace=
=0A=
> structure is being freed just while __blk_add_trace() works on it.=0A=
> Protect accesses to q->blk_trace by RCU during tracing and make sure we=
=0A=
> wait for the end of RCU grace period when shutting down tracing. Luckily=
=0A=
> that is rare enough event that we can afford that. Note that postponing=
=0A=
> the freeing of blk_trace to an RCU callback should better be avoided as=
=0A=
> it could have unexpected user visible side-effects as debugfs files=0A=
> would be still existing for a short while block tracing has been shut=0A=
> down.=0A=
>=0A=
> Link:https://bugzilla.kernel.org/show_bug.cgi?id=3D205711=0A=
> CC:stable@vger.kernel.org=0A=
> Reported-by: Tristan<tristmd@gmail.com>=0A=
> Signed-off-by: Jan Kara<jack@suse.cz>=0A=
> ---=0A=
=0A=
[1] https://marc.info/?l=3Dlinux-btrace&m=3D157422391521376&w=3D2=0A=
=0A=
=0A=
