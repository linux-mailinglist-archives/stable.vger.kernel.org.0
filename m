Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E11282A20B0
	for <lists+stable@lfdr.de>; Sun,  1 Nov 2020 19:06:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727180AbgKASGw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 Nov 2020 13:06:52 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:58996 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727111AbgKASGw (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 1 Nov 2020 13:06:52 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A1HxKII032294;
        Sun, 1 Nov 2020 10:06:43 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=aPwoS586QGVEOrLnV5weQldFEdgpI6SiU7plR0OeZcY=;
 b=qmjQhaQ+T06T9EWSys1wsiTYwELvOS4z6Sh7TUM3Jm9JqxJ2XsyxUt49U5q7b61yw5Xa
 IL8J+YaI2A80caeX8PHp3iWGjoNMnsdnVFcpuTofFYrbjEcDXxBT2INJMHvc06ytQMKf
 VvrDq88SkiW3htUgELBiKn5kPtGHAARndKo= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 34h5rfcck0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sun, 01 Nov 2020 10:06:43 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Sun, 1 Nov 2020 10:06:42 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AY+i1L3aLeJzIsr1ndtcCbhMqQ1bHcZFlzJoPqxNJm36/zSLmRk+BYF06HzhI8khJl20ra14aJpaRKBDWMeuP2uItQXtQE1ii1s8FUe7oVGtPY1LpZi+UErqh0kf3qQhuO93Ib7m5Fbwx9uUInoLbzYo3xLuQ0VV5Wc3YKq4c2pLTyzsRqF8irC4I9pJDALe0RjpW2NHSCCVWc1kwzZ88u6LJdZjXVsP0LwWTbRNnoc31vPBlOW7HFDs1iu/FP0fmXG9ZvBfKkdo/19fUIBfLykxcJRJsNXiutXUGYRpxnKcnTy0NcJLdhU7YwVfSuYu3XT6uSJiA6oN34u7vHCxfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aPwoS586QGVEOrLnV5weQldFEdgpI6SiU7plR0OeZcY=;
 b=BauzHsrDtj/tL+su566yU4+OcuqyAE20y3Sd+q6FZnEN3uX/mcjLqDiIcCLNTnDTBbAs+Cv5cC3ooVMWIOHkx2SBm+1ZQXQCz0VhHE3xl8imhDVsdati3vAS+T/NkJp98Gj5FvF923EUqAyjwgIl/q1LxJuQQOlzjPuiTl++Ev1dq3ZuP2Y6osr6fOQXBTAarNUZkoOz8DR68msvLu2HIp1TiioEXmLFDBq0yhjHYEImNT6r/b8JMXu/ttonj8m4ahuNSo9Bq9W79pygkv6x/mh4/VFm8Pdvoa+2vuJJWaXTO3dvBE1cWHI/DTST9KhPwRQzxbjE4FLH0NBqcHfOKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aPwoS586QGVEOrLnV5weQldFEdgpI6SiU7plR0OeZcY=;
 b=ZJJCllRXKMn9f3lmabAy0QjBunohoojA+of+XbVkzZdl/6PQ0Gx4Qi3bK6+YQ1JRBahu8oRhnhfXjI5vVyQJupzzw8xpjIGJBosWqx2l6Pf7YSx6kQfcDlECHJ1RxXADiryzrQjkAM1Ket1fQbtL72xs/SQkUv01V+v6M6plr1Y=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB4120.namprd15.prod.outlook.com (2603:10b6:a02:c4::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.27; Sun, 1 Nov
 2020 18:06:41 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::7d77:205b:bbc4:4c70]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::7d77:205b:bbc4:4c70%6]) with mapi id 15.20.3499.030; Sun, 1 Nov 2020
 18:06:41 +0000
From:   Song Liu <songliubraving@fb.com>
To:     David Laight <David.Laight@ACULAB.COM>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Jin Yao <yao.jin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        "Arnaldo Carvalho de Melo" <acme@kernel.org>
Subject: Re: [PATCH] perf: increase size of buf in perf_evsel__hists_browse()
Thread-Topic: [PATCH] perf: increase size of buf in perf_evsel__hists_browse()
Thread-Index: AQHWrxgJ8VqeSFqmzUq01sEGnLmGuqmxk16AgAIB8AA=
Date:   Sun, 1 Nov 2020 18:06:41 +0000
Message-ID: <2032D1DB-821B-4B6B-882C-0E77E5582D5F@fb.com>
References: <20201030235431.534417-1-songliubraving@fb.com>
 <5334209cb6fa4a0782029ca7b44c917e@AcuMS.aculab.com>
In-Reply-To: <5334209cb6fa4a0782029ca7b44c917e@AcuMS.aculab.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: ACULAB.COM; dkim=none (message not signed)
 header.d=none;ACULAB.COM; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:c2a2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 97536dde-871e-49f9-622b-08d87e90e295
x-ms-traffictypediagnostic: BYAPR15MB4120:
x-microsoft-antispam-prvs: <BYAPR15MB4120F4E4F5D3B2B4C83A21FCB3130@BYAPR15MB4120.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: upfX8OkLDCVO6GrBEX5Xb5ylDcPySopHEqsvu/NQaIOPOFJBnn+7Jk3vAJ1KVaE+clqV0qUTIdVudY8ZyxFjI5zNObz/aIyl3AIvJ7VCSM46nXbhf/+6OIfznZpc/5i69+HbchQYKDE18ijBHj8/NiIhscW6h78rid0YAQ2G8RAZpK27bimP6jklyeHFJBx03y6srlpHYeUpUbf6+nURGyV3RD1IAYXbJtaf3vrN6AuwEDK+55IKKhSno3ljHVsprU7aFZ/iOqZqAQBkD/32t/zqtlDtmolTtLHuH4S2ZQxjPe4JUtYhlUr726NXA9xUy1l0PoDf43oaeIfAZXTXpAQRE4vidrWrQzEoMGep4BOtv2WpuGSb3kQ/01EmYsgiO6GUf2E2Zjh72j6/X3cY9vUlxrYtahglct7l4Z570uA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(396003)(376002)(39860400002)(346002)(66446008)(91956017)(66556008)(36756003)(83380400001)(5660300002)(2906002)(186003)(6512007)(86362001)(53546011)(478600001)(66476007)(76116006)(316002)(64756008)(66946007)(6506007)(2616005)(6916009)(8676002)(71200400001)(6486002)(8936002)(4326008)(54906003)(33656002)(106533001)(101420200001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: xwO1A+z02MOCSkbBTbbFFsG0jA9NoafK6t+wtDAcg+GVfiopOpsFHHXTP08LRUZdpyQVMncE8XlhvhWD6gVHQuL0tb7rGzdyXmUYlCE2dNC+p0wJBN9eNCgIhuxK6Zmf9NycWM/aCcz+uyNPzUUtt5WZygso1AvJ0GPd+8godlTsppf68sfiNhLzAA19XSy/OdsFW/G9fpzgHyJCq2roFj71fUhLOOm3XRi01Vh2U2rqDxV0phKkh2kwNThv8EgntrFxjTavCC8GOEAwniRsMTbVrJvQE860CFx8HRa3EfgDzekKnqHgk3gKnF8gg7zll84jQcRyeWKeRvuDAwbNUsSbb49eDw43ZA9EPD6pFcNvapNvdRpTM9bQxFRcIXXehg37BIBw24mI2Ut6dM3XVHDoL77nHxaNuSaqzykZMcZBmkav0LoGWdOKmyMq3CKH1BADULXSJQLVERNTurDf36OIvSjyVtVau8fa0mbuvcP5y5CbHOWwXBf0LDeBWXtbCGoACCS2IkCG34rXOT9KWRNdxW3O4oTWHjMNyLEmovrDM+ZSl/JGqIHpcXlyRiRIwXz1e0ADfD7QGfs3rykY/GxK2fOlgnoD50iD8AW8HA/SvguZMN/hF9XJ7R2MEPrF+wZujXsbIXpsQ2VJka5cGwkTzwmfSy3PW63qy/u8Mydy/MFBcAODaYeKSZ7z8/cx
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4E8852E5C0B6544D935D529BD76E5C07@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97536dde-871e-49f9-622b-08d87e90e295
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2020 18:06:41.3237
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SkKRSLlflffe4tdGTWMJ6qRrPIHO9CcDngR1zEiuziJhZPCPCkJp8uwSDJoByX4R3gT9uFu1WCcAvPehGzFejw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB4120
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-01_05:2020-10-30,2020-11-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 lowpriorityscore=0 adultscore=0 clxscore=1011 priorityscore=1501
 impostorscore=0 phishscore=0 malwarescore=0 suspectscore=0 bulkscore=0
 spamscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2011010149
X-FB-Internal: deliver
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On Oct 31, 2020, at 4:27 AM, David Laight <David.Laight@ACULAB.COM> wrote=
:
>=20
> From: Song Liu
>> Sent: 30 October 2020 23:55
>>=20
>> Making perf with gcc-9.1.1 generates the following warning:
>>=20
>>  CC       ui/browsers/hists.o
>> ui/browsers/hists.c: In function 'perf_evsel__hists_browse':
>> ui/browsers/hists.c:3078:61: error: '%d' directive output may be \
>> truncated writing between 1 and 11 bytes into a region of size \
>> between 2 and 12 [-Werror=3Dformat-truncation=3D]
>>=20
>> 3078 |       "Max event group index to sort is %d (index from 0 to %d)",
>>      |                                                             ^~
>> ui/browsers/hists.c:3078:7: note: directive argument in the range [-2147=
483648, 8]
>> 3078 |       "Max event group index to sort is %d (index from 0 to %d)",
>>      |       ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> In file included from /usr/include/stdio.h:937,
>>                 from ui/browsers/hists.c:5:
>>=20
>> IOW, the string in line 3078 might be too long for buf[] of 64 bytes.
>>=20
>> Fix this by increasing the size of buf[] to 128.
>=20
> ISTM that something should be unsigned so that the bound check
> that puts an upper bound of 8 implies a lower bound.
>=20
> 	David

Changing both "%d" in this line to "%u" does fix the warning. But we=20
are printing "evsel->core.nr_members - 1" here, and nr_members is=20
signed int. So I feel more comfortable keep the "%d"s and increase=20
the buffer size.=20

Thanks,
Song=
