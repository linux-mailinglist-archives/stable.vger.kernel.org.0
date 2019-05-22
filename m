Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BE8F26848
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 18:31:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729856AbfEVQb0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 12:31:26 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:50644 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729572AbfEVQb0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 May 2019 12:31:26 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4MGIOjE019400;
        Wed, 22 May 2019 09:30:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : content-type : content-id :
 content-transfer-encoding : mime-version; s=facebook;
 bh=PLGq8DIBv1a+N4WMNoVFde89YvBh4ZyjQsDyHXNc+E4=;
 b=ODnK/MQoAIPF4EeRRX9xzUbMcB/hKT5g1JSoWceBB5RaaHG0S1MeX+mUBYbF6Gxc2eB9
 JIGBDkb2mlpFgs/unt4Njg8uz/HW/J3gToMqTwrQ8mYG51UoIbn4X2CSNQgwJ69bmn9E
 MDwH/g17hv5NrAGAFbrIQhRbqoQYwyFDI7w= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2smmucv6s4-15
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 22 May 2019 09:30:36 -0700
Received: from prn-mbx08.TheFacebook.com (2620:10d:c081:6::22) by
 prn-hub04.TheFacebook.com (2620:10d:c081:35::128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 22 May 2019 09:30:34 -0700
Received: from prn-hub05.TheFacebook.com (2620:10d:c081:35::129) by
 prn-mbx08.TheFacebook.com (2620:10d:c081:6::22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Wed, 22 May 2019 09:30:34 -0700
Received: from NAM03-CO1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.29) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Wed, 22 May 2019 09:30:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PLGq8DIBv1a+N4WMNoVFde89YvBh4ZyjQsDyHXNc+E4=;
 b=Dm07BFyi2Bp82sdoDAzygC7ihTIlsn4b7ARtXanjlYZ+WUJ497ABR8eFA6ijCRL/wItkTh8p+7UprbeBm1M3m06gum3ZeEAbjEUw1Ck2DTiEsBunURnPywzK26DnwUlWr01VxAO6ip73hIMx2Zwgc5C139/qPLmW8c2tVEXoEW8=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.2.19) by
 MWHPR15MB1165.namprd15.prod.outlook.com (10.175.2.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.17; Wed, 22 May 2019 16:30:33 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::85b5:614:bc49:8a15]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::85b5:614:bc49:8a15%11]) with mapi id 15.20.1900.020; Wed, 22 May 2019
 16:30:33 +0000
From:   Song Liu <songliubraving@fb.com>
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     linux-raid <linux-raid@vger.kernel.org>,
        Nigel Croxon <ncroxon@redhat.com>,
        "linux@thorsten-knabe.de" <linux@thorsten-knabe.de>
Subject: Fix bad backport to stable v3.16+
Thread-Topic: Fix bad backport to stable v3.16+
Thread-Index: AQHVELut9IDecR4QV0quZ9ifvSzBlQ==
Date:   Wed, 22 May 2019 16:30:33 +0000
Message-ID: <5F8253BF-1167-4A48-A3AC-E0728E1EE6CB@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3445.104.8)
x-originating-ip: [2620:10d:c090:200::3:a64d]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 67c7ea29-f178-4d7b-4b0b-08d6ded2cffb
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:MWHPR15MB1165;
x-ms-traffictypediagnostic: MWHPR15MB1165:
x-microsoft-antispam-prvs: <MWHPR15MB116504A70DB78AA7955076FDB3000@MWHPR15MB1165.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2043;
x-forefront-prvs: 0045236D47
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(366004)(346002)(376002)(39860400002)(136003)(189003)(199004)(76116006)(83716004)(73956011)(6436002)(66946007)(57306001)(71200400001)(71190400001)(4744005)(5660300002)(5640700003)(53936002)(6512007)(316002)(54906003)(66476007)(66446008)(64756008)(66556008)(82746002)(6116002)(81156014)(1730700003)(33656002)(81166006)(8936002)(2906002)(478600001)(305945005)(8676002)(2351001)(7736002)(50226002)(2501003)(36756003)(4326008)(14454004)(2616005)(476003)(186003)(102836004)(6916009)(6486002)(25786009)(6506007)(86362001)(256004)(46003)(68736007)(486006)(99286004);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1165;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 2sAObNJ9HYNVvfjE3eCQx1186RT+xzCA7ya52MQohFoMRtxy9IHAKb0DZ+xVOplLG184rVhNbXLy6qPBKk53/9QyBKZyYkkoZpjSXUEHKDGjbSVYLzVlnUQecLlwJHxSeIrYMbGI1oYorgTJaKGm9QwDRmtSeqUol62iLMFO7Tgp43AnteEj9dnFIWUIbH8OByIqV3Kd+aa/NoPGj2W0GrzwF8BkWt/n+JY31J8hIcwIWojgDKpgMc66RSCr45/V8UJM5u3YPUHo3asmq5j7/s+7eYKUIPNagjP/cvpAM349yimlZvoZ0uKsiiKtZwos8cqRQwxrjLVTVlEnz43LanCNHeGPuGnejdH6+u2aj9C9acbOlvK1PiB/WW5uB07nTvwxUNu9WZr6dQUx8ljriy30+RjPbLBRW9Bf3IMcCF4=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <62B578430C9F4E4F908C9E2FD76DD80D@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 67c7ea29-f178-4d7b-4b0b-08d6ded2cffb
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 May 2019 16:30:33.1613
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1165
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-22_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=907 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905220115
X-FB-Internal: deliver
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,=20

As reported by Thorsten Knabe <linux@thorsten-knabe.de>.=20

commit 4f4fd7c5798b ("Don't jump to compute_result state from check_result =
state") =20
was back ported to v3.16+. However, this fix was wrong. =20

Please back port the following two commits to fix this issue.=20

commit a25d8c327bb4 ("Revert "Don't jump to compute_result state from check=
_result state"")
commit b2176a1dfb51 ("md/raid: raid5 preserve the writeback action after th=
e parity check")

Thanks,
Song=
