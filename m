Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEA4535E325
	for <lists+stable@lfdr.de>; Tue, 13 Apr 2021 17:49:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345994AbhDMPtY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Apr 2021 11:49:24 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:57258 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345978AbhDMPtX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Apr 2021 11:49:23 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13DFj819040931;
        Tue, 13 Apr 2021 15:48:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=KUul+6GVjVjvhEt8jSgdju2F01EbQV6AEBz5ceftj78=;
 b=KPtsClm6pxn8HtXwvLUcopw++fYE/cLVepjwGOZS1k3W1b87KV3a9rZnbaRMFQsr/+J2
 yS2Fkx6OgQbfNPCrtZ8vwCNVxUFBZT42xvvqBHjrS+QJh91C+VZEU18IFnPSLdo5lyBU
 r1i3TbAC7+7O6gk0QLTX+PQ5o0aZUhECwXg3M7kzLCAjrIPiciPweAr2fBME0TzqExNJ
 yugfXuiR5mP21lkzJ/udBju2nhFI/uK5qji+yM0Dwnqe32ldsjqbXhoqWpPNGg3NiiMr
 hVvX3BCVR4vJO9GmTPi93cIRka+HIA56IZJ+RBrIn+hHG+8OI3hEbX9fQwJf5xwoQaw3 3g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 37u4nnfj12-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 15:48:59 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13DFjfeb003029;
        Tue, 13 Apr 2021 15:48:58 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2171.outbound.protection.outlook.com [104.47.58.171])
        by aserp3020.oracle.com with ESMTP id 37unwyxxsd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 15:48:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dz0qVcuw+xpSS5pc/ClOD9RT22D0byVNX80OJiE7LN+dgp+kr9LMqTlU1lmUcduHo4DQKMXH6QRPsQGokwCdtLMZGM9Fhjxxe3XL8YMALVr4PrLXSXrd8hE6+WIyeAFxuLwIfOjGWi8pYKtNN7wvSppUgXQ1w+Irf+df9L1TBxJq6EmePZKMYfmt/yHZ6CRvh3RwB1AMcHtu2pcWaVbYWNOY1N+PslQOenUyX1xspmDMJVZMBnZM32xCgqzSkicjWR3rb3bEixi5n98Q87O3M576Q/n0OF+wSM7utkUPrAThEOctToU6t+ogRZ5S6x0Ga74G/I5gmyHO8FvpBCyl2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KUul+6GVjVjvhEt8jSgdju2F01EbQV6AEBz5ceftj78=;
 b=l6HWR6jEIWwAcK2ck1OUA8HZqGaqWih8lufMWm3zyMTiTb32so4f1xLLFSKFPXsuyMbY0HZT8EWOlocC9h1Tps8Tm6btRVd0pAVbO6b9qRkLhr4X27as/M/Yv6tKGdYKNnlMIx7Ng7zWkNRhhDPjn126W9VbYE054TDLh7yk1XL2a/SingDsc39/VGHXKKCkukwgRYfcAifZ1nD7aGbsVhNgw209sWxp32ZfoMNz4ZzbtG5R53lokP2VaQTqw/SWV3byctimH6RqaplGKwKvr2GdBlGyrOnYUNEoFTo2huECD2tMp9qbCm70V5mwkgYx1H7ICUfA7kGTo/P88Wj/Aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KUul+6GVjVjvhEt8jSgdju2F01EbQV6AEBz5ceftj78=;
 b=Nxyd1nlc69uwVJDQIfXtxHR7Rd7HiWZZbqi3kQlNwWkxipfLbRv+uYKwOoI9UUWea0XT2slB030DnK5gOYsTAZLcTIPVsV2IWtFDM4mxgmuTQ3cyer8xtXFj8c6ZvRJuyi6Q+eHonS75d2jmMhPvZX2P080jg2MYtTbaGvVg6f0=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SA2PR10MB4506.namprd10.prod.outlook.com (2603:10b6:806:111::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.22; Tue, 13 Apr
 2021 15:48:54 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::20c7:193:d737:7ab1%4]) with mapi id 15.20.4020.022; Tue, 13 Apr 2021
 15:48:53 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Roman Bolshakov <r.bolshakov@yadro.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux@yadro.com" <linux@yadro.com>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>,
        Daniel Wagner <daniel.wagner@suse.com>,
        Quinn Tran <qutran@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Aleksandr Volkov <a.y.volkov@yadro.com>,
        Aleksandr Miloserdov <a.miloserdov@yadro.com>
Subject: Re: [PATCH] scsi: qla2xxx: Reserve extra IRQ vectors
Thread-Topic: [PATCH] scsi: qla2xxx: Reserve extra IRQ vectors
Thread-Index: AQHXL71FMzbYmDbkQ0qMb6rerHOdBaqymYeA
Date:   Tue, 13 Apr 2021 15:48:53 +0000
Message-ID: <7188360D-8AE3-4F12-8058-225DA561B3EB@oracle.com>
References: <20210412165740.39318-1-r.bolshakov@yadro.com>
In-Reply-To: <20210412165740.39318-1-r.bolshakov@yadro.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: yadro.com; dkim=none (message not signed)
 header.d=none;yadro.com; dmarc=none action=none header.from=oracle.com;
x-originating-ip: [70.114.128.235]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2d992705-e8a7-44a9-48c1-08d8fe93a416
x-ms-traffictypediagnostic: SA2PR10MB4506:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA2PR10MB450652E2D2A6A30337F921A6E64F9@SA2PR10MB4506.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kpR8vXU0WgHGFg+lNelwa7T++qtPP7rX8QrcMYtJY00KVC3NcZY8f59YWK0wuanzUS7esnh9BUnRdkLGUEp6j+i3vHTLBXhcPOOo4lPmUEQbp+E08oS6wV5T6JZzzHWZe84MJ+851268S0WWJbjf/ifceyin5OzdyZjUErZN9YQVMzPd1SIdmQA3slcvHmJniKjKixNnaDE66xqBi3LmScaWxE0egQCVClJEddFtKkmhNj6SH7cLkCjCPs59SHrVsD5/i+mWn7bsYw9wnyimvVaaysPczimJyEXGEaCEaD6BAeufOIAQnzRCJhVDJIlMWFnDMhqohNfJ6c75VlI/2SK/n498DKA4KQczX5Hy+XEGTmumJXfACM9seIXaQxxFVpmujuMnRaAcSdmitiltOQ1l4fFemiMDXTslpOUm6QKc1/KesnPrLZrUNCJYjY/XoJZrga7LKzL2kgRBq0RegaibGl6fuLP0sghwKgUw7pAPD7eCB0IFxjpjLGAKOyGk+/GWhB5QG2sQe6ha7tErs1d9MLKwTMsj2SqSdRLt+Ug/4pzF3GovLOKb+7fb/hDwNIwvIiqzlD/gURGDPjiXlcl4kp53Sk5Hk+vonVwOu/cLFNi0Nl4Gls21Xx5s4TfdHdXIoxMsnrqG3bJqrwvJNkhFkJk45CKUxkHBTUIl59s=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(396003)(376002)(39860400002)(366004)(66946007)(6916009)(316002)(8676002)(6512007)(71200400001)(5660300002)(83380400001)(122000001)(2906002)(186003)(2616005)(38100700002)(4326008)(8936002)(66446008)(36756003)(86362001)(7416002)(26005)(54906003)(33656002)(66476007)(44832011)(6486002)(478600001)(64756008)(53546011)(66556008)(6506007)(76116006)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?S4lejgVDFWfl4SbZDUEXW2DHPgJhtodexwEr56O60IdjCyBE1KqpNHdM3K6I?=
 =?us-ascii?Q?Tx3vqMMWXXPPdG2TLo4hL6H9Fc5M1FE/I8WiStvHGYoZCeFWExKj6kGvKEwQ?=
 =?us-ascii?Q?ZyueUqcgMi96+1JXL4rmkWB/dY0qMLI3WQDBR89KIVRFUUrMjU2LHHZiSVEQ?=
 =?us-ascii?Q?BJr/XLv+FWiIvkTMDM1hkI4S2cbJmQWtjhcsetAtTGInybAjSAmpdvU7HWYM?=
 =?us-ascii?Q?i/tRA3ToCKFttMzpmiwPA3Vb0b1eeF9BVpH8mJb93VQ8wGU2EhtlqFrIUXVu?=
 =?us-ascii?Q?9/yfuyfqUKhqj5bPYTBsfilAfxWBb+PDXvH1lL2xS30xe6P0zXM1NGODZvJp?=
 =?us-ascii?Q?aiHP3moYzkRYB8QiFhAqPpBWRZ5PjSgqjcmDDTHjgXf051H+/PEa2/Jq4PaJ?=
 =?us-ascii?Q?uGsHkwzLNqJELdmLxF43V9lCADo2ALTXPEpuJWb73vH+xFGQUoYbCe+1Yi0D?=
 =?us-ascii?Q?CJyLi8KPBEWtkVW7FT2ssKqoJRlljNB8ukzgXaWMrqTFYYPqwyJ/DglHcuRM?=
 =?us-ascii?Q?VdtaU2BkJmTAMDBVT9VkXbKbxSSU/wjVMn0E+7AwYkEmJ5PLwcEMuQX0sJaV?=
 =?us-ascii?Q?31IuNJQ0ZqczYv/KgAPYzoUqisfsMfjIbD9cn/cPwOlj8LFhEKBYuV2e3WEs?=
 =?us-ascii?Q?tCYfcn2M70oh0MoKfWH7c/QaWdkITxpd0JCTPH+zBF8RWAtQChVV7N9VC+R7?=
 =?us-ascii?Q?z3nbNInZNUoc1byG3l0kU7w2my7oPAeWzzyN++6YCKqR7tN1lV6HGgeScZcM?=
 =?us-ascii?Q?zJzDs5gv1nfAHFKQ+0FMf4ebqNnexpQsbceg7nrIUIUuEZR7zpqLGAMsEaii?=
 =?us-ascii?Q?12UjWjud089KczjHGgu+GsXyMg50x6Um+JxaL3lGh1Tzn1HPg8U+99Q9hEgj?=
 =?us-ascii?Q?EjgpsciKdz7zY5vOWV7HnDcrm+ZQfkWjAe0eOeSkmt1fC6EhtV95O2FRVOCk?=
 =?us-ascii?Q?Z/NOIATGf1siQOkjP7k2B/ALfKhhCffcte0hexuJcbrD63Ddj1CAeYE1yGkT?=
 =?us-ascii?Q?U8umOLo5wnhnF5th4vZoXiasBh7sHGbWsGFJcYk5vmPe46nyYRAjgLDq24OK?=
 =?us-ascii?Q?MDQpSpomDbhpmIW62WQF3979ZuUxbKcZ2rIcrcSqpWxvsE2BWX+v+MFGKsNp?=
 =?us-ascii?Q?4DgcmZ5bOe0m7t9ndfAVO0yPrIjqHjySaWOeHNpFS4qPr4pz3IHxLTEs38Tx?=
 =?us-ascii?Q?kCdcb4EyK3aIfQi8acvkd6y0pVgxMMnveEBkoUqGl9t0kyGrs+yo6DYZqqR6?=
 =?us-ascii?Q?Zc1PhYEE5qTvIdZeIVlx3IOVOwBy5F1KA9YPdf9gDCXYzoR41CCY3If6P6QN?=
 =?us-ascii?Q?XNpLoDUKHNQNAmXvQ15k7pQW9n00eocnHDjZdFhZgIh7pA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6C6D46A6BC0B3849BB8EAD8F43B9C4E6@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d992705-e8a7-44a9-48c1-08d8fe93a416
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Apr 2021 15:48:53.7787
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FWJbFTJkoUfggnwYEWgq1lTol4XXrE3lHZiRkqhJh7Y4+CWAccrMSntbSPKcvQeqqoHIWdj5gunV6WEkyR9g9NcCBtYMHcn8RzhoT5f3KPg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4506
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9953 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 malwarescore=0 adultscore=0 bulkscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104130109
X-Proofpoint-ORIG-GUID: RgAYuYvCytI-K3pjAvD1UaoZYKk9YegS
X-Proofpoint-GUID: RgAYuYvCytI-K3pjAvD1UaoZYKk9YegS
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9953 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 priorityscore=1501
 clxscore=1011 lowpriorityscore=0 spamscore=0 impostorscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104130109
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On Apr 12, 2021, at 11:57 AM, Roman Bolshakov <r.bolshakov@yadro.com> wro=
te:
>=20
> Commit a6dcfe08487e ("scsi: qla2xxx: Limit interrupt vectors to number
> of CPUs") lowers the number of allocated MSI-X vectors to the number of
> CPUs.
>=20
> That breaks vector allocation assumptions in qla83xx_iospace_config(),
> qla24xx_enable_msix() and qla2x00_iospace_config(). Either of the
> functions computes maximum number of qpairs as:
>=20
>  ha->max_qpairs =3D ha->msix_count - 1 (MB interrupt) - 1 (default
>                   response queue) - 1 (ATIO, in dual or pure target mode)
>=20
> max_qpairs is set to zero in case of two CPUs and initiator mode. The
> number is then used to allocate ha->queue_pair_map inside
> qla2x00_alloc_queues(). No allocation happens and ha->queue_pair_map is
> left NULL but the driver thinks there are queue pairs available.
>=20
> qla2xxx_queuecommand() tries to find a qpair in the map and crashes:
>=20
>  if (ha->mqenable) {
>          uint32_t tag;
>          uint16_t hwq;
>          struct qla_qpair *qpair =3D NULL;
>=20
>          tag =3D blk_mq_unique_tag(cmd->request);
>          hwq =3D blk_mq_unique_tag_to_hwq(tag);
>          qpair =3D ha->queue_pair_map[hwq]; # <- HERE
>=20
>          if (qpair)
>                  return qla2xxx_mqueuecommand(host, cmd, qpair);
>  }
>=20
>  BUG: kernel NULL pointer dereference, address: 0000000000000000
>  #PF: supervisor read access in kernel mode
>  #PF: error_code(0x0000) - not-present page
>  PGD 0 P4D 0
>  Oops: 0000 [#1] SMP PTI
>  CPU: 0 PID: 72 Comm: kworker/u4:3 Tainted: G        W         5.10.0-rc1=
+ #25
>  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.0.0-prebuilt.=
qemu-project.org 04/01/2014
>  Workqueue: scsi_wq_7 fc_scsi_scan_rport [scsi_transport_fc]
>  RIP: 0010:qla2xxx_queuecommand+0x16b/0x3f0 [qla2xxx]
>  Call Trace:
>   scsi_queue_rq+0x58c/0xa60
>   blk_mq_dispatch_rq_list+0x2b7/0x6f0
>   ? __sbitmap_get_word+0x2a/0x80
>   __blk_mq_sched_dispatch_requests+0xb8/0x170
>   blk_mq_sched_dispatch_requests+0x2b/0x50
>   __blk_mq_run_hw_queue+0x49/0xb0
>   __blk_mq_delay_run_hw_queue+0xfb/0x150
>   blk_mq_sched_insert_request+0xbe/0x110
>   blk_execute_rq+0x45/0x70
>   __scsi_execute+0x10e/0x250
>   scsi_probe_and_add_lun+0x228/0xda0
>   __scsi_scan_target+0xf4/0x620
>   ? __pm_runtime_resume+0x4f/0x70
>   scsi_scan_target+0x100/0x110
>   fc_scsi_scan_rport+0xa1/0xb0 [scsi_transport_fc]
>   process_one_work+0x1ea/0x3b0
>   worker_thread+0x28/0x3b0
>   ? process_one_work+0x3b0/0x3b0
>   kthread+0x112/0x130
>   ? kthread_park+0x80/0x80
>   ret_from_fork+0x22/0x30
>=20
> The driver should allocate enough vectors to provide every CPU it's own H=
W
> queue and still handle reserved (MB, RSP, ATIO) interrupts.
>=20
> The change fixes the crash on dual core VM and prevents unbalanced QP
> allocation where nr_hw_queues is two less than the number of CPUs.
>=20
> Cc: Daniel Wagner <daniel.wagner@suse.com>
> Cc: Himanshu Madhani <himanshu.madhani@oracle.com>
> Cc: Quinn Tran <qutran@marvell.com>
> Cc: Nilesh Javali <njavali@marvell.com>
> Cc: Martin K. Petersen <martin.petersen@oracle.com>
> Cc: stable@vger.kernel.org # 5.11+
> Fixes: a6dcfe08487e ("scsi: qla2xxx: Limit interrupt vectors to number of=
 CPUs")
> Reported-by: Aleksandr Volkov <a.y.volkov@yadro.com>
> Reported-by: Aleksandr Miloserdov <a.miloserdov@yadro.com>
> Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
> ---
> drivers/scsi/qla2xxx/qla_isr.c | 4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_is=
r.c
> index 11d6e0db07fe..6e8f737a4af3 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -3998,11 +3998,11 @@ qla24xx_enable_msix(struct qla_hw_data *ha, struc=
t rsp_que *rsp)
> 	if (USER_CTRL_IRQ(ha) || !ha->mqiobase) {
> 		/* user wants to control IRQ setting for target mode */
> 		ret =3D pci_alloc_irq_vectors(ha->pdev, min_vecs,
> -		    min((u16)ha->msix_count, (u16)num_online_cpus()),
> +		    min((u16)ha->msix_count, (u16)(num_online_cpus() + min_vecs)),
> 		    PCI_IRQ_MSIX);
> 	} else
> 		ret =3D pci_alloc_irq_vectors_affinity(ha->pdev, min_vecs,
> -		    min((u16)ha->msix_count, (u16)num_online_cpus()),
> +		    min((u16)ha->msix_count, (u16)(num_online_cpus() + min_vecs)),
> 		    PCI_IRQ_MSIX | PCI_IRQ_AFFINITY,
> 		    &desc);
>=20
> --=20
> 2.30.1
>=20

Change looks sensible.

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

