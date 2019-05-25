Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A26122A5C0
	for <lists+stable@lfdr.de>; Sat, 25 May 2019 19:18:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726126AbfEYRSF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 May 2019 13:18:05 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:45248 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726102AbfEYRSE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 May 2019 13:18:04 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4PH9SgM012305;
        Sat, 25 May 2019 10:17:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=SiyCsUrIrqcWpDYO/n6R8kpYFzRSTeiJz8dlb4LEU0o=;
 b=Tt15QisWvgrBvkbBuQz8oesHfiiOCWp+PVZ5gjH+qat7Ra8mQb/ncVu5ylgHBW0TcD60
 8Kt/KQTvhijKfznR4CE95BlLQ6dNr/jKzDcKEfcegsaY4KKriTJsG2rzogjFi2WhbXzO
 HO8e7pjADETXhDVUGBno6rXtBDfc1ZIM9BM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2sq1r40xmy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sat, 25 May 2019 10:17:15 -0700
Received: from ash-exhub203.TheFacebook.com (2620:10d:c0a8:83::5) by
 ash-exhub201.TheFacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sat, 25 May 2019 10:17:14 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Sat, 25 May 2019 10:17:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SiyCsUrIrqcWpDYO/n6R8kpYFzRSTeiJz8dlb4LEU0o=;
 b=gmNL/IsT3HSJeePyZZn2uRqECa8ztwqq+JD/DGm+WRJQsf7hzfzR00FOajN3KDqL/fEaLPmQb9qDytq9dWmwJacnsin2kNoeKHS3hALyU5yBInbisavXXkGocJmBNrXEJ635KQhR9j7BYK049nuqmrZW15UCpmijopSQfjzSfkc=
Received: from DM5PR15MB1163.namprd15.prod.outlook.com (10.173.215.141) by
 DM5PR15MB1900.namprd15.prod.outlook.com (10.174.105.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.15; Sat, 25 May 2019 17:17:12 +0000
Received: from DM5PR15MB1163.namprd15.prod.outlook.com
 ([fe80::cc3d:9bc2:1c3f:e661]) by DM5PR15MB1163.namprd15.prod.outlook.com
 ([fe80::cc3d:9bc2:1c3f:e661%4]) with mapi id 15.20.1922.016; Sat, 25 May 2019
 17:17:12 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pavel Machek <pavel@ucw.cz>
CC:     linux-kernel <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Dan Williams <dan.j.williams@intel.com>,
        "Nigel Croxon" <ncroxon@redhat.com>, Xiao Ni <xni@redhat.com>
Subject: Re: [PATCH 4.19 108/114] Revert "Dont jump to compute_result state
 from check_result state"
Thread-Topic: [PATCH 4.19 108/114] Revert "Dont jump to compute_result state
 from check_result state"
Thread-Index: AQHVEZx90hau43dmW0yughF9xRiYnaZ7we6AgABCpACAABOVgA==
Date:   Sat, 25 May 2019 17:17:12 +0000
Message-ID: <17DAA66F-27E0-4356-9ED6-090A444D0D0E@fb.com>
References: <20190523181731.372074275@linuxfoundation.org>
 <20190523181740.646499661@linuxfoundation.org>
 <20190525120835.GA2975@xo-6d-61-c0.localdomain>
 <20190525160706.GA26722@kroah.com>
In-Reply-To: <20190525160706.GA26722@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c091:480::1b58]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6244c3f7-e35d-4163-0394-08d6e134d393
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:DM5PR15MB1900;
x-ms-traffictypediagnostic: DM5PR15MB1900:
x-microsoft-antispam-prvs: <DM5PR15MB19006CE6929FB68E164708CEB3030@DM5PR15MB1900.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:517;
x-forefront-prvs: 0048BCF4DA
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(346002)(366004)(396003)(39860400002)(136003)(54534003)(189003)(199004)(4744005)(5660300002)(478600001)(53936002)(68736007)(86362001)(50226002)(64756008)(102836004)(53546011)(81156014)(66446008)(186003)(14454004)(66556008)(8936002)(66476007)(81166006)(66946007)(76116006)(57306001)(229853002)(73956011)(91956017)(6246003)(8676002)(6486002)(6506007)(71190400001)(71200400001)(4326008)(2906002)(82746002)(316002)(256004)(7736002)(6436002)(83716004)(486006)(305945005)(110136005)(446003)(25786009)(54906003)(36756003)(6512007)(46003)(6116002)(99286004)(476003)(11346002)(2616005)(76176011)(33656002)(192303002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR15MB1900;H:DM5PR15MB1163.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: X5JSfsSoAuQ+U+bWsTN+gSArouUAcvRMN5eMfxTngBxw8AfVAHU+2LwaZdsWaaLJgmdVfEyZiFseAzEQsR0bsjzN+BKkE4aWHFRNhBnCKbxy+q4VcG67Kvz8mTYx/Duf3/ltMb9VmQm/PCd+VN5wjdyj76eLyXzOSwt+1/ACYTlYJcR6svW2A2vj2rL5f1kdppH1GWkuJ0YQicT0hfROhGQnNArFtICimEOlXbGGw02FfxEH7KHTnueBixbJVXG2xlNsLITH9ouY7v3hWRNAqR6+3vBKayu+l8tTGQOJQREzpthze3RMHorM0kJf7Tw8VYzkuc6g+3wWBkjrTVESlLpKC+MR68juFH4yOq5ME0891XRx3cM9abMZecctkVGilQYf4WG3P1lA4h1V635hM+vvantngrfZhnsKgWoSJog=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1576C249E28F0A408F1EA8FF64A4EFEB@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 6244c3f7-e35d-4163-0394-08d6e134d393
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 May 2019 17:17:12.1398
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: songliubraving@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1900
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-25_12:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=903 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905250122
X-FB-Internal: deliver
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On May 25, 2019, at 9:07 AM, Greg Kroah-Hartman <gregkh@linuxfoundation.o=
rg> wrote:
>=20
> On Sat, May 25, 2019 at 02:08:35PM +0200, Pavel Machek wrote:
>> On Thu 2019-05-23 21:06:47, Greg Kroah-Hartman wrote:
>>> From: Song Liu <songliubraving@fb.com>
>>>=20
>>> commit a25d8c327bb41742dbd59f8c545f59f3b9c39983 upstream.
>>>=20
>>> This reverts commit 4f4fd7c5798bbdd5a03a60f6269cf1177fbd11ef.
>>>=20
>>> Cc: Dan Williams <dan.j.williams@intel.com>
>>> Cc: Nigel Croxon <ncroxon@redhat.com>
>>> Cc: Xiao Ni <xni@redhat.com>
>>> Signed-off-by: Song Liu <songliubraving@fb.com>
>>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>=20
>> We normally reject patches without changelog, and this has none. Why
>> make exception here?

Hi Pavel,=20

It was all my fault not to include more information about the revert.=20
Thanks for highlighting this. I will be more careful with this in the=20
future.=20

Thanks,
Song

