Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 208D47372F
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 21:02:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728792AbfGXTCT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:02:19 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:7896 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728819AbfGXTCS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Jul 2019 15:02:18 -0400
Received: from pps.filterd (m0001255.ppops.net [127.0.0.1])
        by mx0b-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6OJ268C014433;
        Wed, 24 Jul 2019 12:02:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=HWxRlGWoX5BeHuaWlmkoHflK2URiZdZhtdLVIQJucX0=;
 b=HKbZdTyVO9Yx6VGSOJc5xZD9lhRYe0MNrDsOb/he+uxQ6hgGq9lCUNWPVQcfxqaoyBCc
 abixThbJS5Ap5LwQDU/7/loTMZ0iZdBI80G+TsOiaTLpJ8UG4o5Z6z+nlzeyXFM6LV2y
 JrJR2MGVjewnaCQoCPhO82km1cieO23220w= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0b-00082601.pphosted.com with ESMTP id 2txu1ugjyd-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 24 Jul 2019 12:02:14 -0700
Received: from ash-exhub203.TheFacebook.com (2620:10d:c0a8:83::5) by
 ash-exhub104.TheFacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 24 Jul 2019 12:02:02 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 24 Jul 2019 12:02:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JAgtmslFbBZzcVptgr9qkfM0FI8xcD/yNIDSaKJAcAz4gVpzQHTowC49sNKjQ8M9kamCj8bTd2x+t7qXfXA4a3nmPkszaqSQ3YVsMTjpF/j5mGERzEz/0CAVMBYoXnO5V7wdqIkrhbOMIDapf6ZPijvF8KJqNqK36Fs4jx5YGSM9AufuLFkpWhRN0fHTFMCwuNwUPu0ji8hNW91AdFXVqssyjkxQtx+H0JgmeDcn+hQaPdL5+Mkvd28wqYTGd7ZLSvbg90rJ4OnbpH9I3Q/bMdGR6q7hX5JoUpFeJDN23SJFYuA7+rS1nMGHGUzgEXdSF1eoV0HDNd1Zm4CMSaU3AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HWxRlGWoX5BeHuaWlmkoHflK2URiZdZhtdLVIQJucX0=;
 b=PNmvh1RNOAgShz8fasASC18Rk3SFw38+N1ghsNxHHYYOPbODmC3zxzU8Rw+Ir/J7AK7lkDUbkgv5VTNyRo61C0/av1u82wZObIwv0JsbowaqgL7EbzqQiEmQ48yQLj9Y1ix3c0qfOde4fegssyT/1XcINCqq+IXYufYGaxFjRHGnmG5ZmM2LT9NO3C8w56EVJNL4fDlTzJU9tIH/ZNHyyVmyv6b4fKychwdqvsln+i8+WESGvSHjVOOZjpomqHpZWzT+E0vZpFKXwMEy9Z9PtN6c9NaIzZIEJxDIccp9SqYuwqxLHO2RwtNnIbHozJNtmG1j5GGy1mbVGJd6unGsyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=fb.com;dmarc=pass action=none header.from=fb.com;dkim=pass
 header.d=fb.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HWxRlGWoX5BeHuaWlmkoHflK2URiZdZhtdLVIQJucX0=;
 b=NMriGzOL1s9saHpI/cOA7IZSWbpfp7kmVZrSaSK3U6oJ6BQmjMwB2UdHmvr0oonydu/QhtJP1TJiE/zSeH+6feInzO72FREeLGOi/kCxzCeZyM+Jqkjt9peLoYJC6ESRiVBxhbiavODksn3mAj/Qg8r7R0tVa6/Vku3/aEKqWjQ=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1871.namprd15.prod.outlook.com (10.174.255.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.10; Wed, 24 Jul 2019 19:02:01 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::4066:b41c:4397:27b7]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::4066:b41c:4397:27b7%7]) with mapi id 15.20.2094.013; Wed, 24 Jul 2019
 19:02:01 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     Xiao Ni <xni@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        "soltys@ziu.info" <soltys@ziu.info>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] raid5-cache: Need to do start() part job
 after adding journal" failed to apply to 4.14-stable tree
Thread-Topic: FAILED: patch "[PATCH] raid5-cache: Need to do start() part job
 after adding journal" failed to apply to 4.14-stable tree
Thread-Index: AQHVQT4HYBrTLKOHFk+O58OAUd3KhabaIhCA
Date:   Wed, 24 Jul 2019 19:02:01 +0000
Message-ID: <6DDB0EF7-FB67-49D1-9615-841E3F15F182@fb.com>
References: <1563876263160153@kroah.com>
In-Reply-To: <1563876263160153@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:180::1:856f]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f171a9a3-8197-4c95-ebed-08d710696922
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1871;
x-ms-traffictypediagnostic: MWHPR15MB1871:
x-microsoft-antispam-prvs: <MWHPR15MB1871E4AB994D461481C5C386B3C60@MWHPR15MB1871.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0108A997B2
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(979002)(376002)(346002)(136003)(396003)(366004)(39860400002)(199004)(189003)(6436002)(86362001)(25786009)(6512007)(6246003)(53936002)(4326008)(305945005)(7736002)(6116002)(8936002)(57306001)(50226002)(8676002)(81156014)(81166006)(14454004)(36756003)(68736007)(33656002)(478600001)(6916009)(186003)(53546011)(6506007)(102836004)(486006)(6486002)(46003)(476003)(2616005)(229853002)(11346002)(446003)(316002)(2906002)(54906003)(99286004)(76176011)(256004)(5660300002)(71190400001)(71200400001)(76116006)(4744005)(64756008)(66946007)(66556008)(66446008)(66476007)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1871;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ijHFMSyAOpeqjN4Ak7EQnIStpv8B690ZuGuW417rZvhtpHJhPZjwFI5AGVezGtl41jJWJcjT2sQWAUejDY2+e352BR0Hkyw0fMwwvyNhjpwDG6YEdQnDzflXQI/dUj+kkDsuoZ573yT49cETpkasYtkHIZUa34racZR5ZQaqhTlFTLWHWbZiNpGcXRc59QEYxtbt/siR2FqbxurrayPT+2CLVd3z0q4kaljBxlh6TO0QY+NbOBmcguAwBGipzkDkNioLd02/RKiHqpqqS0n0DLr4wGHH4nC2+TCOe77Cqv1xtzfpePy0hUcbgqg89mXISCD5vD7yaLIwMl9uj/A3u9jYagy16H2um7BZBeMbDevwE0paQB+iXc9c11dinE0hPTMbVy/IHx7GGouZmBA8IgUDBr1MG0Wl9y/uDR7nmOc=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <19EF73BA6E658B4782F6F0E26CD68E43@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: f171a9a3-8197-4c95-ebed-08d710696922
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jul 2019 19:02:01.5869
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: songliubraving@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1871
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-24_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=585 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907240203
X-FB-Internal: deliver
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On Jul 23, 2019, at 3:04 AM, gregkh@linuxfoundation.org wrote:
>=20
>=20
> The patch below does not apply to the 4.14-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
>=20
> thanks,
>=20
> greg k-h

I made the mistake to say #4.9+ for this one. It is not needed for 4.9=20
and 4.14.=20

Thanks,
Song
