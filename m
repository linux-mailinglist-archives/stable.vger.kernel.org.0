Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 911B28C3EC
	for <lists+stable@lfdr.de>; Tue, 13 Aug 2019 23:47:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726712AbfHMVrp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Aug 2019 17:47:45 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:41142 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726565AbfHMVrp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Aug 2019 17:47:45 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7DLleWq006164;
        Tue, 13 Aug 2019 14:47:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=x3UWO+LBB6O0hTYfEASivfqkFHYJbO2Lt4ssFr3OqOE=;
 b=RGA0D3VWGY1FwfS8IO7LeMuTboCJJDhyOWNDa7YZa7xXbLoAxEnjoUFUOaxVbyRRgc70
 C7J6zbTOGHRP6MN6pZaid0OrX7CSe54eX5qFEEyVHjnkAm3CkemoOrPBgXnjNc+QuXoU
 5Cc2oHAec3y7+dUU9bwmnX5Jx7nxkm5p8Aw= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2uc0t6s9py-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 13 Aug 2019 14:47:40 -0700
Received: from ash-exhub103.TheFacebook.com (2620:10d:c0a8:82::c) by
 ash-exhub103.TheFacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 13 Aug 2019 14:47:37 -0700
Received: from NAM03-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 13 Aug 2019 14:47:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PrBkv2ya+oozEGdKaorBXP0qfynmUyhGOQRmrR7bMZOVoVjwo6hkliE81MoCH0wT/7yoNM2/6aEnk1PeNjyYLhyYlvXyKBkE//ONrq7Y+uYzNz1RcnC5t1dtZCJjQAeytFENr/o/H7gAk+vkXT3CEF7SplF05VXhqxY5uxL8kir0ea+Zz65P7HQDGVyDX7d/JhDzLHCHRvM6qZVo944RqzLTuYrktEqn2pOcAy+YHvbyRqHv8DA380nSuT0ZXzKWWogAYsR8AGSm126lky32rqjI0qvhjypjlSSxsdwFz1A1qoCgI4asP5zcVcsyXRZXYGCy699XTIXamWvRX7odGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x3UWO+LBB6O0hTYfEASivfqkFHYJbO2Lt4ssFr3OqOE=;
 b=UjrLMy9jOD79sk7LBK6DKy1JxFbItJhuNd1hzZjENJXDmXgqDzIjrKkC8Jt+UgsYZMWjCZJ8BcK9TXLgOoZQINQICwb0SrCYouXJiBfVN+dV4ujaRT6tHE+CvHCPV3rS/tY5yk9VbCPrv09WeCBTmbesnUx2uUB8dOSN6/gbWTlFOn/FultSwcHCT6QXL6f569VozGUPtQPWno/sdkv1UdtRQ3Lb6KSwFPnzeaa98xkzRiAlqkuwrZdmrJO/vNRbT2prOjfrWnUNzCmVPqoi+JseK8BzkJm1iNsqzhNn+dvyPa+uniTpunyv74KJ5Oo0RafC95epsTWdHdimNB7hGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x3UWO+LBB6O0hTYfEASivfqkFHYJbO2Lt4ssFr3OqOE=;
 b=PcJGkN2/uh6nAXyYDNyHJank00xUQM3b7nliIYgQKyehByzD6pn+ztkFkTc2w9tIx02h5uH/ZrP4UrPl6ZnHP0N5bFlbr2I3GQAn6xo0IaNkg7TBvkLdGFgjAQkDZ8Ew4xsKreW8NBRP7mcumAxfAP28rP0cuMKGAVjy/Y7zRC8=
Received: from DM6PR15MB2635.namprd15.prod.outlook.com (20.179.161.152) by
 DM6PR15MB2620.namprd15.prod.outlook.com (20.179.161.93) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.20; Tue, 13 Aug 2019 21:47:35 +0000
Received: from DM6PR15MB2635.namprd15.prod.outlook.com
 ([fe80::d1fc:b5c5:59a1:bd7e]) by DM6PR15MB2635.namprd15.prod.outlook.com
 ([fe80::d1fc:b5c5:59a1:bd7e%3]) with mapi id 15.20.2157.022; Tue, 13 Aug 2019
 21:47:35 +0000
From:   Roman Gushchin <guro@fb.com>
To:     Andrew Morton <akpm@linux-foundation.org>
CC:     "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Michal Hocko <mhocko@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] mm: memcontrol: flush percpu vmevents before releasing
 memcg
Thread-Topic: [PATCH] mm: memcontrol: flush percpu vmevents before releasing
 memcg
Thread-Index: AQHVUWcJo041kAovIUqPQ99aFT9BKqb5mhOAgAAEiYA=
Date:   Tue, 13 Aug 2019 21:47:35 +0000
Message-ID: <20190813214731.GB20632@tower.DHCP.thefacebook.com>
References: <20190812233754.2570543-1-guro@fb.com>
 <20190813143117.885bef5929813445ef39fa61@linux-foundation.org>
In-Reply-To: <20190813143117.885bef5929813445ef39fa61@linux-foundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MW2PR16CA0016.namprd16.prod.outlook.com (2603:10b6:907::29)
 To DM6PR15MB2635.namprd15.prod.outlook.com (2603:10b6:5:1a6::24)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::1f63]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ad6b0a52-885e-4828-c597-08d72037da26
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:DM6PR15MB2620;
x-ms-traffictypediagnostic: DM6PR15MB2620:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR15MB26207C1E587E7E1A820A28D6BED20@DM6PR15MB2620.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 01283822F8
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(376002)(39860400002)(346002)(366004)(136003)(189003)(52314003)(199004)(6436002)(6916009)(478600001)(6486002)(66476007)(229853002)(52116002)(186003)(102836004)(6506007)(8936002)(4326008)(386003)(66446008)(2906002)(64756008)(66946007)(7736002)(6246003)(14454004)(446003)(46003)(476003)(486006)(11346002)(6116002)(66556008)(76176011)(9686003)(8676002)(54906003)(71190400001)(5660300002)(316002)(33656002)(1076003)(25786009)(256004)(4744005)(305945005)(99286004)(71200400001)(86362001)(81156014)(81166006)(6512007)(53936002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR15MB2620;H:DM6PR15MB2635.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: AoKrMjp1mi18SrBkvNmzL7zbopmDWI9xJtOt90nmWFs9NmIQ0rdUQud8h5QqXauKjEMXXV5Sp8axw1vaGVBiy5WSCJwkpYtlhM61h6JPQJGip6tbivSsE4sBR6pOwOgDX3PjAT33vCkgXP8l10RriQkTmxp9Lqt2beWUClXKG60hMC5wsBbaGWmSEbFsrOqlcFDtIe/hRoV75LTrmTCAT+fephzesvDccZv8UimngqCz1LbfEuyLTKwd2b06fB+95f7FMRKBd1D13wNofJSsBNH7MDd1Uzj6xywsgNeoek486Y9eO/4xDxI3Ew4DbP2KHRSghznMeR/pJyeXgi/qVwkCA+z3AAYAvYatGMsCckUMm/NlZpi9ANc0Nq9bNePb8bn7Hgqy73vcRd7SZZjG0b3ED0k0IbZNBqMzoPCcDoA=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <FF10EAA14CB20F40918937449AAD0EE5@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: ad6b0a52-885e-4828-c597-08d72037da26
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Aug 2019 21:47:35.3267
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HHxUzls8Ee3DmxjbT7OI7b59LBttVmVMskQC5x/uxHT3+l+38eNTuFjzjWSeCDyp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB2620
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-13_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=588 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908130204
X-FB-Internal: deliver
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 13, 2019 at 02:31:17PM -0700, Andrew Morton wrote:
> On Mon, 12 Aug 2019 16:37:54 -0700 Roman Gushchin <guro@fb.com> wrote:
>=20
> > Similar to vmstats, percpu caching of local vmevents leads to an
> > accumulation of errors on non-leaf levels. This happens because
> > some leftovers may remain in percpu caches, so that they are
> > never propagated up by the cgroup tree and just disappear into
> > nonexistence with on releasing of the memory cgroup.
> >=20
> > To fix this issue let's accumulate and propagate percpu vmevents
> > values before releasing the memory cgroup similar to what we're
> > doing with vmstats.
> >=20
> > Since on cpu hotplug we do flush percpu vmstats anyway, we can
> > iterate only over online cpus.
> >=20
> > Fixes: 42a300353577 ("mm: memcontrol: fix recursive statistics correctn=
ess & scalabilty")
>=20
> No cc:stable?
>=20

Here too, cc:stable is definitely missing. Adding now. Thanks!
