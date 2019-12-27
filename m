Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1C6812BBD2
	for <lists+stable@lfdr.de>; Sat, 28 Dec 2019 00:49:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725820AbfL0Xt2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Dec 2019 18:49:28 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:13290 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725306AbfL0Xt1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Dec 2019 18:49:27 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBRNnLfr022843;
        Fri, 27 Dec 2019 15:49:21 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=DroxoxZ3jtDVgPOdwgQQ2qnccUNgWTqNT0DnsEjQHoM=;
 b=VQwDQpTr+t/MDpydk4QnA8LeCYKxgemmftmNXekQO8VK0Wmendl5+8bClt+F3eW8Hz/d
 wEOc0lceZWJftcWQGuEPGv2EKYZBmXk12v7MLtifTJesrtR4YDyQ+2XNVtCb9sxHNt5e
 5d/cRAidqdrSuLjM0U8DqWtF18dSpreIUJM= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2x5rhmgnk2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 27 Dec 2019 15:49:21 -0800
Received: from prn-hub05.TheFacebook.com (2620:10d:c081:35::129) by
 prn-hub02.TheFacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 27 Dec 2019 15:49:20 -0800
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.29) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Fri, 27 Dec 2019 15:49:19 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m9HuDX3lFTYh/iFIiwaiwAjcUgJSlJxfy4FLSX8rZsdI0jjf6+MYavXjTcen5W/jSYEUvZAJyGjwczzTP4AQOWh1TUSGzf9Hte26XoBbsXkmrDlirEmVFEL/dGMqYeG1wRGdYRGp8evE6PQ9DQEocpO/N8p/slR09aHWeSv+9q+jO/s4aCEZYlH+09gDO3q9ItF3Y3LesF1oijJSdNvX+yPmZbLJsjRqP5NQXnoIt9lxBtaPv831rP4Wn6SzozIzPE6u6viQjNR5cW5klxxFXJU2ilwgnUKoYxkPjtRTYHq2/sBqtyDVJxeIoU0SLql1Qm08htnte+16R7pnj/WxzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DroxoxZ3jtDVgPOdwgQQ2qnccUNgWTqNT0DnsEjQHoM=;
 b=GLk1v6NzCLMm1kerZ2X7mJb0EZD7P75Im6abux8pAKHEKrrL2cO0q1mdp+DIz+LMuiUQxaojywnyevvaq+YR+527KQaynCL1VAaEb3XPQifhfUNjzssvrSAvXz9kby/WkpeQV48VYG5npCDfmBKCl5lurt6tzvtKP1K82IxliIJNlNs0/TT6kpMLbSTjtsiaR3+1Y/2nYsuRUWxsyP28yBoSmasU5l+TWx+ZeHSU5KE7iaoh+D+9SooCNgn/+BtmDrJ75pigwHaxBlS9D3eTQcwCSBh3YUeQiUdU3QU3ShbPttXrDBLgVJLbIAM54auG4S9VL6hnLUy7g3lt+NCJng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DroxoxZ3jtDVgPOdwgQQ2qnccUNgWTqNT0DnsEjQHoM=;
 b=WGmHv6DgNZgrXvjUD1eHzvyyIBP4WXM7o8z4dXmC6/JO/x5vy3knpGOEHI9Zv27iP4XWOYxY9Ald4vBAllHp1dvyTl2kcrn+xD4+ONnHSmx3pxE5fekxTjv1BFyCpDBk9ughDDeHrT8plFFzb9GGiV2/cTje7X5cjWrfAKDr7lc=
Received: from BYAPR15MB2631.namprd15.prod.outlook.com (20.179.155.147) by
 BYAPR15MB3224.namprd15.prod.outlook.com (20.179.56.222) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2581.12; Fri, 27 Dec 2019 23:49:18 +0000
Received: from BYAPR15MB2631.namprd15.prod.outlook.com
 ([fe80::8cc8:bdb1:a9c7:7f60]) by BYAPR15MB2631.namprd15.prod.outlook.com
 ([fe80::8cc8:bdb1:a9c7:7f60%3]) with mapi id 15.20.2581.007; Fri, 27 Dec 2019
 23:49:18 +0000
Received: from localhost.localdomain (2620:10d:c090:180::322) by MWHPR11CA0032.namprd11.prod.outlook.com (2603:10b6:300:115::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2581.11 via Frontend Transport; Fri, 27 Dec 2019 23:49:17 +0000
From:   Roman Gushchin <guro@fb.com>
To:     Yafang Shao <laoar.shao@gmail.com>
CC:     "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        "mhocko@kernel.org" <mhocko@kernel.org>,
        "vdavydov.dev@gmail.com" <vdavydov.dev@gmail.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Chris Down <chris@chrisdown.name>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] mm, memcg: reset memcg's memory.{min, low} for reclaiming
 itself
Thread-Topic: [PATCH] mm, memcg: reset memcg's memory.{min, low} for
 reclaiming itself
Thread-Index: AQHVvLNbLK+Vure78kqR8d/QXQ5M5KfOpxSA
Date:   Fri, 27 Dec 2019 23:49:18 +0000
Message-ID: <20191227234913.GA6742@localhost.localdomain>
References: <1577450633-2098-1-git-send-email-laoar.shao@gmail.com>
 <1577450633-2098-2-git-send-email-laoar.shao@gmail.com>
In-Reply-To: <1577450633-2098-2-git-send-email-laoar.shao@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR11CA0032.namprd11.prod.outlook.com
 (2603:10b6:300:115::18) To BYAPR15MB2631.namprd15.prod.outlook.com
 (2603:10b6:a03:150::19)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::322]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 600ce710-e53a-4cbe-3e45-08d78b27633c
x-ms-traffictypediagnostic: BYAPR15MB3224:
x-microsoft-antispam-prvs: <BYAPR15MB32249FFE1AF1AE850EBC2CD1BE2A0@BYAPR15MB3224.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0264FEA5C3
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(136003)(396003)(376002)(346002)(39860400002)(189003)(199004)(81156014)(8676002)(81166006)(66556008)(66946007)(66446008)(64756008)(66476007)(8936002)(55016002)(69590400006)(71200400001)(9686003)(6916009)(5660300002)(1076003)(33656002)(86362001)(478600001)(4326008)(6506007)(52116002)(316002)(54906003)(2906002)(186003)(7696005)(16526019);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3224;H:BYAPR15MB2631.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qkMYjiQYrqio4KdqWzg5GuG2dwKn8qKBDTbGbNhkYxfqx1XRP/kmCZQTAJHlrI1yd++o93kySHbgWO6if7U9a/hF890d5bMYvPL40jVXiOwMthjjd0eBMbNEd22dOR3/9VZqPMt1k10dlj2Cm2oxTnb4uMIvUMANob+w6RLy5/7gaOmUcAJtiWoJt2X4jkIiwOZ9sKphtAo7O+fuv5Q7HN5PHkLgpHG5ZmFB5nRJjf8O7OfzOIyEkhsOlXU24/IDTXmv+Ry39T2qAn8IrdaIxxcqaCyc7DAbRaQewe9IFp4KWufO0c7jb87aTXAeNmeN4vr5aOgx+Ym96xJgYSvfBq2i5L8TpwRWq7heaA0sq7phgdr6YdXR7dNfdncJexB9IuKy/NzCI9YQl7rahipRCx/0Utt0fNf+ALkk0818Uh5p1MYxaTldnMSaMnDRNmNbawozEPYo9akLV+Wmp9YWA8SaGAElSiYrxnJfbujY3BJQB0hPb1XXCDtHI64tM2et
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A3259E3C92DF584A8DFD6FF3572F0736@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 600ce710-e53a-4cbe-3e45-08d78b27633c
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Dec 2019 23:49:18.3960
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ui/4eiMl6SOEeaINwLFU2PPKmGt1eM7fokxRUrYiOBHCKgcEZa64byqHYreG1OxS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3224
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-27_07:2019-12-24,2019-12-27 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 impostorscore=0 mlxscore=0 adultscore=0 lowpriorityscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 phishscore=0 suspectscore=0 clxscore=1015
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912270192
X-FB-Internal: deliver
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 27, 2019 at 07:43:53AM -0500, Yafang Shao wrote:
> memory.{emin, elow} are set in mem_cgroup_protected(), and the values of
> them won't be changed until next recalculation in this function. After
> either or both of them are set, the next reclaimer to relcaim this memcg
> may be a different reclaimer, e.g. this memcg is also the root memcg of
> the new reclaimer, and then in mem_cgroup_protection() in get_scan_count(=
)
> the old values of them will be used to calculate scan count, that is not
> proper. We should reset them to zero in this case.
>=20
> Here's an example of this issue.
>=20
>     root_mem_cgroup
>          /
>         A   memory.max=3D1024M memory.min=3D512M memory.current=3D800M
>=20
> Once kswapd is waked up, it will try to scan all MEMCGs, including
> this A, and it will assign memory.emin of A with 512M.
> After that, A may reach its hard limit(memory.max), and then it will
> do memcg reclaim. Because A is the root of this reclaimer, so it will
> not calculate its memory.emin. So the memory.emin is the old value
> 512M, and then this old value will be used in
> mem_cgroup_protection() in get_scan_count() to get the scan count.
> That is not proper.
>=20
> Fixes: 9783aa9917f8 ("mm, memcg: proportional memory.{low,min} reclaim")
> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> Cc: Chris Down <chris@chrisdown.name>
> Cc: Roman Gushchin <guro@fb.com>
> Cc: stable@vger.kernel.org
> ---
>  mm/memcontrol.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
>=20
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 601405b..bb3925d 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -6287,8 +6287,17 @@ enum mem_cgroup_protection mem_cgroup_protected(st=
ruct mem_cgroup *root,
> =20
>  	if (!root)
>  		root =3D root_mem_cgroup;
> -	if (memcg =3D=3D root)
> +	if (memcg =3D=3D root) {
> +		/*
> +		 * Reset memory.(emin, elow) for reclaiming the memcg
> +		 * itself.
> +		 */
> +		if (memcg !=3D root_mem_cgroup) {
> +			memcg->memory.emin =3D 0;
> +			memcg->memory.elow =3D 0;
> +		}

I'm sorry, that didn't bring it from scratch, but I doubt that zeroing effe=
cting
protection is correct. Imagine a simple config: a large cgroup subtree with=
 memory.max
set on the top level. Reaching this limit doesn't mean that all protection
configuration inside the tree can be ignored.

Instead we should respect memory.low/max set by a user on this level
(look at the parent =3D=3D root case), maybe clamped by memory.high/max.

Thanks!
