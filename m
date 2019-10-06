Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C829BCCEF1
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 08:09:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726131AbfJFGJv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 02:09:51 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:32260 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726087AbfJFGJv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Oct 2019 02:09:51 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9669URS011282;
        Sat, 5 Oct 2019 23:09:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=xgC3G/u67260navD3nYyQnJYw2ZVdph9V9Kmy3FrSb0=;
 b=bCfWWab28cUCxrgtMqVhTxwsWtxE8OGr/5NkVkeHlc1RR2yjJufLBs76Vjz0uKjf6BbH
 cw6VV0aMcA5s+O3qwJPmMa6/y4f6VwtSty/mJH04GeQIEN/VhF+qYYnOkmB5D4z3f45e
 K16ptqvt+AcshsJEGR4YYfOAHTB1ehM2qkk= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2ves0gk5nb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sat, 05 Oct 2019 23:09:32 -0700
Received: from prn-hub01.TheFacebook.com (2620:10d:c081:35::125) by
 prn-hub02.TheFacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Sat, 5 Oct 2019 23:09:31 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Sat, 5 Oct 2019 23:09:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=POgQftwwN3KrCFznE+3YdmVIy2BK2nwP6QQd0YKWNYgQ46LUhozoxgSXbjaPZkI/3/PhZvQuiJS54uGB4N6JJV6VwbQ39qRyERVUuv0eJogwMJQNFRfey/nNP7gHIhHRZfZaZ8EsSuoVrR5VIoZsY5Gn2pJLrVMmCP7WrDD53itirJ6QHDkrwwuBqVKKMvWpUCGVaZwpyBoey05eGAaH8X3dxCcKgtHkn/NRKsjx2ytY9Mm39FwKugZxuRb3kd1F1OyyXfZc3j2o9ZRdg2umCFshLu+XofMh/zhsnOdQlh/FfaACOuCq238UOwkSwT65GQim5LbDcbNdwFjyJSpVPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xgC3G/u67260navD3nYyQnJYw2ZVdph9V9Kmy3FrSb0=;
 b=Bjvu0StzKF8cfrQD46+qD7vkmusDqzbFUaujfJt37eEcipPZKVLDq3nzg8PdJgJT+FbdPWebeQI5QXfMrdFXAlOjzpE10ArMlRaVPDqPsXfhWBEulxFZGay/vHbtfbv+W6yE95CSzByZOCUrQGn77aBjnQzPOrso+Z4RPTbsUyAx4k0dHqSzMUEnNWWcwe2LkVFSylqD4uPKJ6x+jpDLqAifBtxRKOME1wi7p+1QNoSM+9FEihMWnqcvgYqGCtTXoH6EIJ8B6ojheQcsubr3ox++hd9FcKCSKC8mk65BtlGPkK5tsowuGU3U0PEcVeTtoUB2kTrukQm4QfmSdRxIxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xgC3G/u67260navD3nYyQnJYw2ZVdph9V9Kmy3FrSb0=;
 b=D4ed89zj3iJQConmK3S966WJBhz4v0G4wRKqd1H83vJQAzk1BNW1YxHlMKJsiloAR076g5ZZeHP5Ecjn3r2KhZav3U7YjOa0nwUGNc0o789U8nJquhFe44sapB990ofOL57uNISnl5apFm1COqLycQySU/Sj2PEbmur/T7Sknx4=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1789.namprd15.prod.outlook.com (10.174.96.8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2327.24; Sun, 6 Oct 2019 06:09:30 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::a828:5750:379d:b9a1]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::a828:5750:379d:b9a1%8]) with mapi id 15.20.2305.023; Sun, 6 Oct 2019
 06:09:29 +0000
From:   Song Liu <songliubraving@fb.com>
To:     open list <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
CC:     Kernel Team <Kernel-team@fb.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: [PATCH] perf/core: fix corner case in perf_rotate_context()
Thread-Topic: [PATCH] perf/core: fix corner case in perf_rotate_context()
Thread-Index: AQHVebXeTwCJT6mWNUStetO5rZ1Qe6dNJcwA
Date:   Sun, 6 Oct 2019 06:09:29 +0000
Message-ID: <C0355084-8227-4380-AF6F-EEBFC0BE6E37@fb.com>
References: <20191003064317.3961135-1-songliubraving@fb.com>
In-Reply-To: <20191003064317.3961135-1-songliubraving@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:180::61f5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d835b9cd-61b2-46db-3418-08d74a23bfae
x-ms-traffictypediagnostic: MWHPR15MB1789:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR15MB1789E9D3E075B2C614BC0EBCB3980@MWHPR15MB1789.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0182DBBB05
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(136003)(39860400002)(366004)(346002)(376002)(189003)(199004)(2616005)(8676002)(6436002)(11346002)(446003)(81166006)(25786009)(110136005)(46003)(53546011)(6506007)(229853002)(8936002)(305945005)(316002)(7736002)(50226002)(6486002)(476003)(76176011)(81156014)(186003)(256004)(54906003)(6246003)(2906002)(86362001)(4326008)(66946007)(33656002)(71200400001)(71190400001)(76116006)(6512007)(64756008)(66446008)(66476007)(478600001)(91956017)(102836004)(99286004)(36756003)(5660300002)(66556008)(486006)(14454004)(6116002);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1789;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: U/wfShnmGC3eVLXdyot053Xmqmk1rR6S8IXvU2VusMZ6MO/U593Q8gmbfjwXLFiOjpB6gTDJbkmZGCEitv4xFdfBu3G9DVeTdl6g+82zhc+aAGqqGOjesO5TaZJ0ZXa1ovzlMQ1qpHA/6hG/C4Ept0WZfuQsGQtTJRJQucNX54TbRk698/Kh6hy5l+uolsd58rxQlty4xUK6u1t2rZOD2hh1FiCbHMpVrJmghXYmmjl9Ym0ys5mtwoA1bqDoem5kMVjriaK99Zozia6Yh2yg3T0eWAk/fMPcMGMR12TPRbTtxVvTvKCHoRPoKqp3zJPfNJUyjDeNf+AJ9vpG2Z4OYbS3NmRoR241Bnauon5JbbmRJtCf0gAe/TjnC4Ui6KOYXUdLCV39SAWFU0DRrpY0Bf+9bkG1YCvaDyWyrIGccWM=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5FACBE3C650A3848B1431F4239877644@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: d835b9cd-61b2-46db-3418-08d74a23bfae
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Oct 2019 06:09:29.5080
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1W+wrFgwultpfVOUURI8sWMP38uCc2g1KoF1TnO73dGDDWAV61X6cIn0SXu9GP5sB3q7POvMzK5UxRLHywRALA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1789
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-06_02:2019-10-03,2019-10-06 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 bulkscore=0 clxscore=1015 impostorscore=0 malwarescore=0 suspectscore=0
 mlxscore=0 spamscore=0 priorityscore=1501 phishscore=0 adultscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910060063
X-FB-Internal: deliver
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On Oct 2, 2019, at 11:43 PM, Song Liu <songliubraving@fb.com> wrote:
>=20
> This is a rare corner case, but it does happen:
>=20
> In perf_rotate_context(), when the first cpu flexible event fail to
> schedule, cpu_rotate is 1, while cpu_event is NULL. Since cpu_event is
> NULL, perf_rotate_context will _NOT_ call cpu_ctx_sched_out(), thus
> cpuctx->ctx.is_active will have EVENT_FLEXIBLE set. Then, the next
> perf_event_sched_in() will skip all cpu flexible events because of the
> EVENT_FLEXIBLE bit.
>=20
> In the next call of perf_rotate_context(), cpu_rotate stays 1, and
> cpu_event stays NULL, so this process repeats. The end result is, flexibl=
e
> events on this cpu will not be scheduled (until another event being added
> to the cpuctx).
>=20
> Similar issue may happen with the task_ctx. But it is usually not a
> problem because the task_ctx moves around different CPU.
>=20
> Fix this corner case by using cpu_rotate and task_rotate to gate calls fo=
r
> (cpu_)ctx_sched_out and rotate_ctx. Also enable rotate_ctx() to handle
> event =3D=3D NULL case.

Here is an easy repro of this issue. On Intel CPUs, where ref-cycles=20
could only use one counter, run one pinned event for ref-cycles, one
flexible event for ref-cycles, and one flexible event for cycles. The=20
flexible ref-cycles is never scheduled, which is expected. However,=20
because of this issue, the cycle event is never scheduled either.=20

perf stat -e ref-cycles:D,ref-cycles,cycles -C 5 -I 1000
#           time             counts unit events
     1.000152973         15,412,480      ref-cycles:D
     1.000152973      <not counted>      ref-cycles     (0.00%)
     1.000152973      <not counted>      cycles         (0.00%)
     2.000486957         18,263,120      ref-cycles:D
     2.000486957      <not counted>      ref-cycles     (0.00%)
     2.000486957      <not counted>      cycles         (0.00%)

Thanks,
Song

