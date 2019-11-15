Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84E72FE494
	for <lists+stable@lfdr.de>; Fri, 15 Nov 2019 19:09:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726131AbfKOSJG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Nov 2019 13:09:06 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:58202 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726075AbfKOSJF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Nov 2019 13:09:05 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAFI52Ek006489;
        Fri, 15 Nov 2019 10:07:37 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=PlAdRwlh9tiipUN2LMpCVT3bCWPjl10eHHH8c17Z3Hk=;
 b=UPTZuxoLzHs3p8VM5z9NkXMSYWdKq/KNdr8KjJzKMXJV/XnMhLZizko+Ca5kyKkKVSRY
 ZS6321QtIfNQtn/pm8utUQE242NluRAUzUPvwvZ62/RFIbcaw6Sf/GwmYXTptVOylasb
 ylxRz+Yfh6LZivQkQNSXaxgtPWtexTBYR20= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2w9umh40xv-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 15 Nov 2019 10:07:37 -0800
Received: from prn-mbx07.TheFacebook.com (2620:10d:c081:6::21) by
 prn-hub01.TheFacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 15 Nov 2019 10:07:36 -0800
Received: from prn-hub03.TheFacebook.com (2620:10d:c081:35::127) by
 prn-mbx07.TheFacebook.com (2620:10d:c081:6::21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 15 Nov 2019 10:07:36 -0800
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Fri, 15 Nov 2019 10:07:36 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vark10Xl162MO3N5ZvMSAjGwQ7OkGfJ6xdM50BZLp/0IAL6WCaznqcaDC6V/HexmigeAmezfEwQJOKhw4AaBlAOKfbUTyqLxECXNWLfGzYAexNv8iX50v0fyu4QGbHLCoFTYVtpQN1gzsDSyLYYSrfNuzwI0/3PThUmVcMIcShjs7jBWIqs8bYGWYtkPiHZmt2evwZcX/Ix4PCiYLuht5WT8VQQctGUvXP4bQGA/oecouK4lvPdghQiBa4wDCkBTXXlGnkJYV+IPC1MBCnrDq8kdqWe55rxQoZQHBNI4HsU8TsVa0gHyaH2lPIVYRt1I+zmJjJBLedeMwpXvMI7R5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PlAdRwlh9tiipUN2LMpCVT3bCWPjl10eHHH8c17Z3Hk=;
 b=M+bVDyMPDgvFgZSSa6jRCWWxghIwO6spmfoQhw+BXcZsiPknppJuVtg6/LHd3dSs/g0Mli/mwx9M87KaAA1/mUHCKfALjADUW8XR5JhnnncttxHSHRQjYWT6T1X02f0sUzpQtOrt5Xh8Mi5idA+YvOx+kciKcr7ihB7MjEIXj7bwSj5ZdgtAMMl0ANwGwUU9NJylV1UmGIsGbpKwLhdB1yK78Vm/kxiUCyBYib6qRfe0aqd/s4ia20bl9U79YSo8Jn7VOwY2c1GKLLFcR8l2Vibhdm4GhtplqoneU8JibSEykqZIuFt99sodUXJHr0USSmthdVQF+TEXaAlWPHVlcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PlAdRwlh9tiipUN2LMpCVT3bCWPjl10eHHH8c17Z3Hk=;
 b=a0P7eT0mTAh01/aBe2B51uzo462oh0fS1kKQjCERXlwlvz2t1F3ucfT8atdoavO2ErnlHEcwEFb+u6Q7cVi1gG2uZ3WC+McmOBc3RJxFOCddwpaFBHoZwjDErVL/WOPdJhhgWLFdY2PRpcI14/mO4iHuyZZ+WFUqifqJbMudRE0=
Received: from BN8PR15MB2626.namprd15.prod.outlook.com (20.179.137.220) by
 BN8PR15MB2577.namprd15.prod.outlook.com (20.179.138.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.23; Fri, 15 Nov 2019 18:07:34 +0000
Received: from BN8PR15MB2626.namprd15.prod.outlook.com
 ([fe80::7cae:3a15:917d:83c0]) by BN8PR15MB2626.namprd15.prod.outlook.com
 ([fe80::7cae:3a15:917d:83c0%4]) with mapi id 15.20.2451.027; Fri, 15 Nov 2019
 18:07:34 +0000
From:   Roman Gushchin <guro@fb.com>
To:     Michal Hocko <mhocko@kernel.org>
CC:     Tejun Heo <tj@kernel.org>,
        =?iso-8859-1?Q?Michal_Koutn=FD?= <mkoutny@suse.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH 1/2] mm: memcg: switch to css_tryget() in
 get_mem_cgroup_from_mm()
Thread-Topic: [PATCH 1/2] mm: memcg: switch to css_tryget() in
 get_mem_cgroup_from_mm()
Thread-Index: AQHVlPTSqR6tDyqEq0WgIBYYtGCX/KeJVScAgAAK2ICAAbZBgIAAAO8AgAADvACAAAEaAIABcZ6AgAAB6YCAAAWfAA==
Date:   Fri, 15 Nov 2019 18:07:34 +0000
Message-ID: <20191115180728.GA27385@localhost.localdomain>
References: <20191106225131.3543616-1-guro@fb.com>
 <20191113162934.GF19372@blackbody.suse.cz>
 <20191113170823.GA12464@castle.DHCP.thefacebook.com>
 <20191114191657.GN20866@dhcp22.suse.cz>
 <20191114192018.GJ4163745@devbig004.ftw2.facebook.com>
 <20191114193340.GA24848@dhcp22.suse.cz>
 <20191114193736.GL4163745@devbig004.ftw2.facebook.com>
 <20191115174031.GA15216@dhcp22.suse.cz>
 <20191115174721.GB15216@dhcp22.suse.cz>
In-Reply-To: <20191115174721.GB15216@dhcp22.suse.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR1001CA0033.namprd10.prod.outlook.com
 (2603:10b6:301:2a::46) To BN8PR15MB2626.namprd15.prod.outlook.com
 (2603:10b6:408:c7::28)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::9012]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8b118aae-fce1-4f48-71ad-08d769f6b0a9
x-ms-traffictypediagnostic: BN8PR15MB2577:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR15MB2577D679602B165DBC9A210EBE700@BN8PR15MB2577.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 02229A4115
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(376002)(39860400002)(396003)(346002)(366004)(199004)(189003)(305945005)(81156014)(71200400001)(7736002)(54906003)(99286004)(478600001)(66476007)(66556008)(64756008)(66446008)(486006)(446003)(76176011)(186003)(86362001)(476003)(52116002)(316002)(6916009)(14454004)(386003)(5660300002)(5024004)(14444005)(1076003)(11346002)(256004)(102836004)(25786009)(46003)(71190400001)(6506007)(33656002)(229853002)(81166006)(6486002)(6116002)(66946007)(4326008)(8936002)(8676002)(2906002)(9686003)(6512007)(6436002)(6246003);DIR:OUT;SFP:1102;SCL:1;SRVR:BN8PR15MB2577;H:BN8PR15MB2626.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 02FbyAQCxX+VV+A8gJCQHoYGZDjyRmuWH0ziBhySX+m8GpP+6vQ2dg0wVCh8vKTLR1809UTTjopxuSX10LRo09R3ZUg4+ViFo+LaiSfDmI3D457ekOJNhafKyulu5GM923uXdUccPr8b1jukIviL1ABbYgHodACe+FIZGJsp1ssgGAnNtuUFDN/XjLASdJnwtBom2fIDxSWLvTd1JfUr2RZCFcCkll99m6jDxm9vGkwO7cDCeh0nPED3Ou6ZmhhcsaLIUlc9OnhluCmfy9RCz+4DqeB/y92EpsHTehagPxWR2xre1ibjrhavJg8nvZwTRSAnBPz2+ZQpQZte46zxiq34qeuAENvbYmhfjlWUYIuKp9HG+hI/zaGgBnOrNjarkiRImraDOl1RHA85dLVv5hO+x/mN5e7q6/HMp1B0MZT7aDINGY5uM0+cJiJj8jXL
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <325172A99507B545B39F1159C2F42900@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b118aae-fce1-4f48-71ad-08d769f6b0a9
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Nov 2019 18:07:34.5619
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hfP/Fg1qUMeMZxXD9EKlnjNdJxL0n4I/MiFlkhEACUKnprCmV7wBYflHe5v5WyEe
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR15MB2577
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-15_05:2019-11-15,2019-11-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 adultscore=0 mlxscore=0 mlxlogscore=788 impostorscore=0 bulkscore=0
 suspectscore=0 lowpriorityscore=0 priorityscore=1501 malwarescore=0
 phishscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911150161
X-FB-Internal: deliver
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 15, 2019 at 06:47:21PM +0100, Michal Hocko wrote:
> On Fri 15-11-19 18:40:31, Michal Hocko wrote:
> > On Thu 14-11-19 11:37:36, Tejun Heo wrote:
> > > Hello,
> > >=20
> > > On Thu, Nov 14, 2019 at 08:33:40PM +0100, Michal Hocko wrote:
> > > > > It is useful for controlling admissions of new userspace visible =
uses
> > > > > - e.g. a tracepoint shouldn't be allowed to be attached to a cgro=
up
> > > > > which has already been deleted.
> > > >=20
> > > > I am not sure I understand. Roman says that the cgroup can get offl=
ine
> > > > right after the function returns. How is "already deleted" differen=
t
> > > > from "just deleted"? I thought that the state is preserved at least
> > > > while the rcu lock is held but my memory is dim here.
> > >=20
> > > It's the same difference as between "opening a file and deleting it"
> > > and "deleting a file and opening it".
> >=20
> > I am sorry but I do not follow. How can css_tryget_online provide the
> > same semantic when the css can go offline right after the tryget call
> > returns so it is effectivelly undistinguishable from the case when the
> > css was already online before the call was made.
>=20
> s@online@offline@
>=20
> And reading after myself it turned out to sound differently than I
> meant. What I wanted to say really is, what is the difference that
> css_tryget_online really guarantee when the css might go offline right
> after the call suceeds so more specifically what is the difference
> between
> 	if (css_tryget()) {
> 		if (online)
> 			DO_SOMETHING
> 	}
> and
> 	if (css_tryget_online()) {
> 		DO_SOMETHING
> 	}
>=20
> both of them are racy and do not provide any guarantee wrt. online
> state.

Let me step back a little bit.

I think, we all agree that css_tryget_online() has a weird semantics,
in most cases is used only due to historical reasons and clearly asks
for a cleanup. So I suggest to stop arguing about it and wait for the
cleanup patchset. Then we can discuss each remaining use case in details,
if there will be any.

Thanks!
