Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 462F8285AE
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 20:12:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731237AbfEWSMl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 14:12:41 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:44616 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731117AbfEWSMl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 May 2019 14:12:41 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4NIAjfS026622;
        Thu, 23 May 2019 11:11:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=tEh99UFUuIoCQbF7Y2Fx93vLTN/9CrGvFYwbWli1O8I=;
 b=T5hYNRzR4wjMg3r3DR8Ai3FPT6JwEx22EP9zHRqsTRDAGnSX0SCY2Ypy21r+22UHnaXy
 722rAJEh/Nt9GWJb5vKP7enCe/oIWFOm1J+TnhpdE186yfgGdnnnysnYoOG3S7i5e6Qv
 6z/p6b/OtQF4+pBXHv3+g5yD77SKFm3NLNA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2snxsv0eks-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 23 May 2019 11:11:53 -0700
Received: from ash-exhub102.TheFacebook.com (2620:10d:c0a8:82::f) by
 ash-exhub104.TheFacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 23 May 2019 11:11:22 -0700
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 23 May 2019 11:11:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tEh99UFUuIoCQbF7Y2Fx93vLTN/9CrGvFYwbWli1O8I=;
 b=Y4NiRpAyJlII8r5eTQi39CXwWxAYR7zlErYZtrJWQVqJ6GB1ikDqXFBCHYizpf3qSjgQeo2FOdhJHGAosCQmeaHltX+4Oo4c5RZXvjTK+WLJ3ydaII8xaHtjSTX3YBbzUKKpVrMNDw/LbQUWG6s9XChVcgurnhToJyqMYtXH8Ps=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.2.19) by
 MWHPR15MB1344.namprd15.prod.outlook.com (10.175.3.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.18; Thu, 23 May 2019 18:11:20 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::85b5:614:bc49:8a15]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::85b5:614:bc49:8a15%11]) with mapi id 15.20.1900.020; Thu, 23 May 2019
 18:11:20 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Greg KH <greg@kroah.com>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        linux-raid <linux-raid@vger.kernel.org>,
        Nigel Croxon <ncroxon@redhat.com>,
        "linux@thorsten-knabe.de" <linux@thorsten-knabe.de>
Subject: Re: Fix bad backport to stable v3.16+
Thread-Topic: Fix bad backport to stable v3.16+
Thread-Index: AQHVELut6an29Mq8+UC+F4U28QLXqqZ4/OWAgAAHeoA=
Date:   Thu, 23 May 2019 18:11:20 +0000
Message-ID: <C62D2B83-3773-42FA-8918-53C31AB56F97@fb.com>
References: <5F8253BF-1167-4A48-A3AC-E0728E1EE6CB@fb.com>
 <20190523174433.GB29438@kroah.com>
In-Reply-To: <20190523174433.GB29438@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.11)
x-originating-ip: [2620:10d:c090:180::fd85]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b214f981-f019-40e0-5375-08d6dfaa0ed8
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:MWHPR15MB1344;
x-ms-traffictypediagnostic: MWHPR15MB1344:
x-microsoft-antispam-prvs: <MWHPR15MB1344644F52E99CF5E4103924B3010@MWHPR15MB1344.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:972;
x-forefront-prvs: 00462943DE
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(346002)(396003)(39860400002)(136003)(376002)(199004)(189003)(86362001)(8676002)(6116002)(81166006)(99286004)(4326008)(14454004)(81156014)(486006)(229853002)(6246003)(2616005)(33656002)(6436002)(6486002)(25786009)(446003)(11346002)(76176011)(53936002)(476003)(66446008)(64756008)(66556008)(66476007)(6916009)(66946007)(6506007)(50226002)(76116006)(53546011)(316002)(83716004)(71200400001)(73956011)(82746002)(71190400001)(186003)(2906002)(57306001)(54906003)(5660300002)(478600001)(305945005)(7736002)(36756003)(68736007)(4744005)(102836004)(256004)(6512007)(8936002)(46003);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1344;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: pwQlGGxuZIl1dFeDXfb+/ETxT3ejeiOAiqUq2XjDLuK9oUb38/CziFcX7V/IzZzM4SBVQplfKNm9voPeCJU/8v64YN/WAEjAYxHVnZIL8kRb9a/x8CDbcGKIm5eeG74ENYVjWDRmUYubWB5GvklvPxVjS9Fg+ADQfz+fzgJtzYCmMwPM5/bPHWgLZlGHTfolkyToqeXm7OQcFpnV8wSpnoQ5VbXDYXn+5VIho7TfFBvBIs1rMJ0LLUdhX7KXmdQaqu8saWcUCPLpSCqleEmLyPywBpYoGwrtR+VFYE/gimc4hCIECU39YuHcPZLduOVEzYiyG1W0qTRHw3q0JLdbVEcuCQIz5r/dVRPR5tz5DVP842YEZGsGoL+8hHkFIhmipRDSa2EKfyeJ/RPIhMMdUcuj5pQXEdeboL4woq7aN2k=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C1251FEDB522C04F96DCE9A4F6B0936A@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: b214f981-f019-40e0-5375-08d6dfaa0ed8
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2019 18:11:20.4335
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1344
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-23_15:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905230121
X-FB-Internal: deliver
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On May 23, 2019, at 10:44 AM, Greg KH <greg@kroah.com> wrote:
>=20
> On Wed, May 22, 2019 at 04:30:33PM +0000, Song Liu wrote:
>> Hi,=20
>>=20
>> As reported by Thorsten Knabe <linux@thorsten-knabe.de>.=20
>>=20
>> commit 4f4fd7c5798b ("Don't jump to compute_result state from check_resu=
lt state") =20
>> was back ported to v3.16+. However, this fix was wrong. =20
>>=20
>> Please back port the following two commits to fix this issue.=20
>>=20
>> commit a25d8c327bb4 ("Revert "Don't jump to compute_result state from ch=
eck_result state"")
>> commit b2176a1dfb51 ("md/raid: raid5 preserve the writeback action after=
 the parity check")
>=20
> Added to 4.4+ for now.
>=20
> thanks,
>=20
> greg k-h

Thanks Greg!!

Song=
