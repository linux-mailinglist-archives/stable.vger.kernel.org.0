Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C345A10D087
	for <lists+stable@lfdr.de>; Fri, 29 Nov 2019 03:28:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726856AbfK2C2V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Nov 2019 21:28:21 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:19546 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726835AbfK2C2V (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Nov 2019 21:28:21 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAT2POtt021994;
        Thu, 28 Nov 2019 18:28:13 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=Hac4yaRUAl1bTmfBxT72QSOIpouor4147tq7KQt5fec=;
 b=b5CQBs8B9WfozQq8WzIQBD0YHySXoT8PbKe4248ihwxoopYkVmXFX9gd8LApRWPPJBAw
 /fYkZFbIfkefeeJN4ekynqXdczLfkwdBzUE6omRRtvMCF0Tb6ikQedWijHGiOBPxt5eX
 pgOa3Ds8c47ox58km28M4PPdmh3dy+qaNXQ= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2wjfj02hty-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 28 Nov 2019 18:28:13 -0800
Received: from prn-hub01.TheFacebook.com (2620:10d:c081:35::125) by
 prn-hub03.TheFacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 28 Nov 2019 18:28:12 -0800
Received: from NAM03-CO1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Thu, 28 Nov 2019 18:28:12 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PinezhyeVKLqEqAntIFOrFmREV0ax9GXeNwgoUUYWVYoMeYj4FccoO7hBa7pi80KXW9xhF+VaIAeUJmgxFahGTbXdyJ+5Nfyveauq9A+62WY3qffQ0PyplkNGxvCAOORP9sCGvtqaoKnFNMeNVoujzifBFgljiVDVrNWJfUQjtCnqQiF0p2wYB1tZUp2jHMbY7nUQqYShCg/hgk8s3ath2MRJAtxE3rfGzJ5nZIJOssRxRwaV6/kxMnbTtV6I1iYcRqYLijXbQaSmdX1LoTLGzT4TR5/xhdl5L0SCLYGPGRivNpXYrvVHJLyHf+NvRC1lsfi+U4DRoiJoLPGM6rW+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hac4yaRUAl1bTmfBxT72QSOIpouor4147tq7KQt5fec=;
 b=OlXTGtOvdtatYtnIBsr/MNoioyapZguUDUmLbj/LWXpCX1jBtK/2FL+PMZLHCLYaYL5EWRHmSzYkLwVmIou4tNKKBd1s7DcW4xrZC0DAVXD3rjuOPlu2xuSXDa8FVaUmp1YDljML+31v+hx7eXnEsQ3REvb6CLjpNgpnSudKMSiB2vl52iTsKJj770vs7z2jJI8J/rJM5XX1AqCVxdX3Zdk/+h91eBZ/8FwEXO9DMUiCBg7ivaEgkTa3GNNkpGwcAlaMZm0msQjR1iOhOZWrFBwoaK3i7+z43tcE+chTeSJh7bxzVAL9oABl0XT6VBiVGk+1QY0xE76xKNeERgu3uA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hac4yaRUAl1bTmfBxT72QSOIpouor4147tq7KQt5fec=;
 b=UQUPJALbpLSnx7OzGSx++tbuWnf+1GRwtOMzRbvDgNVFuuEDTNVmHPR7PyJduR3xfY79I3pEk3Eu6dtHea39pmBtRglnslh6YEcx7KewPp+0NijjJjngWgE9tzs/pZxPV9vNeLLH9AUVpeYexqTduFlTIsXldk+xJnSTFLsBwMM=
Received: from BYAPR15MB2631.namprd15.prod.outlook.com (20.179.155.147) by
 BYAPR15MB2533.namprd15.prod.outlook.com (20.179.154.214) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2495.20; Fri, 29 Nov 2019 02:28:11 +0000
Received: from BYAPR15MB2631.namprd15.prod.outlook.com
 ([fe80::8cc8:bdb1:a9c7:7f60]) by BYAPR15MB2631.namprd15.prod.outlook.com
 ([fe80::8cc8:bdb1:a9c7:7f60%3]) with mapi id 15.20.2495.014; Fri, 29 Nov 2019
 02:28:11 +0000
From:   Roman Gushchin <guro@fb.com>
To:     Michal Hocko <mhocko@kernel.org>
CC:     "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] mm: memcg/slab: wait for !root kmem_cache refcnt killing
 on root kmem_cache destruction
Thread-Topic: [PATCH] mm: memcg/slab: wait for !root kmem_cache refcnt killing
 on root kmem_cache destruction
Thread-Index: AQHVo8HY/WnVvAZSgEqkb7BHNOXmHaedMHAAgACaToCAASswgIAAUmsAgAEQogCAARjFAA==
Date:   Fri, 29 Nov 2019 02:28:11 +0000
Message-ID: <20191129022806.GB68299@localhost.localdomain>
References: <20191125185453.278468-1-guro@fb.com>
 <20191126092918.GB20912@dhcp22.suse.cz>
 <20191126184135.GA66034@localhost.localdomain>
 <20191127123225.GR20912@dhcp22.suse.cz>
 <20191127172724.GA67742@localhost.localdomain>
 <20191128094312.GF26807@dhcp22.suse.cz>
In-Reply-To: <20191128094312.GF26807@dhcp22.suse.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR19CA0089.namprd19.prod.outlook.com
 (2603:10b6:320:1f::27) To BYAPR15MB2631.namprd15.prod.outlook.com
 (2603:10b6:a03:150::19)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::32b2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6fc1e111-d149-4bc2-2248-08d77473c747
x-ms-traffictypediagnostic: BYAPR15MB2533:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB25332D766431709865850E43BE460@BYAPR15MB2533.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:345;
x-forefront-prvs: 0236114672
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(136003)(396003)(39860400002)(376002)(366004)(54534003)(199004)(189003)(51914003)(54906003)(4326008)(71190400001)(6512007)(6246003)(11346002)(229853002)(6436002)(6486002)(186003)(316002)(71200400001)(102836004)(2906002)(446003)(46003)(52116002)(25786009)(8676002)(6506007)(386003)(8936002)(6916009)(256004)(14444005)(81156014)(76176011)(81166006)(9686003)(86362001)(6116002)(66556008)(66476007)(5660300002)(33656002)(99286004)(66446008)(66946007)(478600001)(1076003)(64756008)(14454004)(7736002)(305945005);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2533;H:BYAPR15MB2631.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8qjl39BLNuNSx9Qpy5Nb1l9PuC7yN0ZPjfpKOCqJzm1GVtwGRK7GbdYZtlSrP2OxQ5dp+PwwsdY5Yyk4vpJmNzddx50GHl3lzIitWIOpyQASQWVbHrqRfJSrqcVxlQFIQ3UDgVUP3m9tNguzqzBSE00JLdWXmsBQEJgEzO+60Pl3cF3AiWbp1nhp0EznDLxMApxqZHan1C6A+Rl5kjE3Vv6yds6oVOxJcKFpHYbjQCaCXROflLhxF2dFki9GH1/18c/O3Pyezh9Jw1/H7IN5+7eJN2jG0Z5rFfsDTyvLpKGRVd1IcnAHAIVrXiXqIvFfHyFwqLxYiVPaWwQffH3x9ZEXQ6N6FTEzAuJKJe3tDqThWprsx6aanHOsNG5u+Zxtm+YbNo76a1ihwKM3aevdIpgwdzLAR/kFhoEXUzsX5TNg2CRFzldI5s0bX9uScoPD
Content-Type: text/plain; charset="us-ascii"
Content-ID: <DB1BC2F78181D048A0C267B99C83F661@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 6fc1e111-d149-4bc2-2248-08d77473c747
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Nov 2019 02:28:11.2132
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: M/5hMK9D6sp4IunSy7BTSl32m+rB5GR2SvgFHj36Zxh/KYZt5YJCoG8JslXGSuO2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2533
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-28_08:2019-11-28,2019-11-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 spamscore=0 clxscore=1015 lowpriorityscore=0 malwarescore=0 mlxscore=0
 impostorscore=0 bulkscore=0 phishscore=0 suspectscore=0 adultscore=0
 mlxlogscore=616 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911290019
X-FB-Internal: deliver
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 28, 2019 at 10:43:12AM +0100, Michal Hocko wrote:
> On Wed 27-11-19 17:27:29, Roman Gushchin wrote:
> > On Wed, Nov 27, 2019 at 01:32:25PM +0100, Michal Hocko wrote:
> > > On Tue 26-11-19 18:41:41, Roman Gushchin wrote:
> > > > On Tue, Nov 26, 2019 at 10:29:18AM +0100, Michal Hocko wrote:
> > > > > On Mon 25-11-19 10:54:53, Roman Gushchin wrote:
> > > [...]
> > > > > > So in a rare case when not all children kmem_caches are destroy=
ed
> > > > > > at the moment when the root kmem_cache is about to be gone, we =
need
> > > > > > to wait another rcu grace period before destroying the root
> > > > > > kmem_cache.
> > > > >=20
> > > > > Could you explain how rare this really is please?
> > > >=20
> > > > It seems that we don't destroy root kmem_caches with enabled memcg
> > > > accounting that often, but maybe I'm biased here.
> > >=20
> > > So this happens each time a root kmem_cache is destroyed? Which would
> > > imply that only dynamically created ones?
> >=20
> > Yes, only dynamically created and only in those cases when destruction
> > of the root cache happens immediately after the deactivation of the
> > non-root cache.
> > Tbh I can't imagine any other case except rmmod after
> > removing the cgroup.
>=20
> Thanks for the confirmation! Could you please make this explicit in the
> changelog please? Maybe it is obvious to you but it took me quite some
> time to grasp what the hell is going on here. Both memcg and kmem_cache
> destruction are quite complex and convoluted.

Sure, will send v2 shorty.

Thanks!
