Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9188924B06A
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 09:51:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbgHTHuo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 03:50:44 -0400
Received: from mx0a-0039f301.pphosted.com ([148.163.133.242]:58952 "EHLO
        mx0a-0039f301.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726853AbgHTHuQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Aug 2020 03:50:16 -0400
X-Greylist: delayed 2105 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Aug 2020 03:50:15 EDT
Received: from pps.filterd (m0174676.ppops.net [127.0.0.1])
        by mx0a-0039f301.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07K7AXBW019171;
        Thu, 20 Aug 2020 07:14:59 GMT
Received: from eur02-am5-obe.outbound.protection.outlook.com (mail-am5eur02lp2058.outbound.protection.outlook.com [104.47.4.58])
        by mx0a-0039f301.pphosted.com with ESMTP id 330x6wkcgk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Aug 2020 07:14:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l8S5V+pfAoEB7BcDkhs29a+T6Ha68Rc8psiteqWgoBeUxjoC6gV7PVrU48/vPwtPYxLT/meimWljQ5WHEkMIf/UwyULNfgEb2RFo2DM99TH9fr+rtb5DnQXvKa4a5Z6HanTmMWWEwjw/YNKi1P+9Q6aTkGmICsP4MklgAXI33NBn0nX117H32manTkRUl/RhP2FU3qbLchTIz5ElNy5pnk8sUD1m9tzRI2Crf8Ocb8YW77AWA4s8DzKKrqRuLdNacnqiXSkJfKjoSFMcxsAUd2lF+KZGPcgsF75SoU9hgBhB2uXd2K9593IGTkaJp74joB+UOKF5tF28DDWnyomc1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LpHvE5DvK8NF6m9Zs56gPUeGPlKyYX08iF8Xu7ozfAo=;
 b=SV6sjz5uo5H7/sPZMOHqgKzlGcQicSKIjU4BE+AULDSr8Va+IJ09qZXc38Y948L414DQgcQHF1M01HQeKFYngPctzoxYsZ+h8GAxyJ0vRMimhuYVln5InJQNgLTu/lE6uoKx2uwwCau2KQ2HrSlfbH5Fo8Pmm9tzKrEVnMPj5rBXkd2juZVH73IfqUE6fyOa/3fXcO6fSP8eADJYz3qi4y5h/AepQzPXxPlpMKzeX301S/B5dSm9GtP2HDTGVCt2ql0no+oHYRWePl7RVBXzboCZH8YsuAowor+dqAA9al5BiqSEAAi3ysW188RYkKdu1vKfD2VqPQYA4WTBS/mWaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=epam.com; dmarc=pass action=none header.from=epam.com;
 dkim=pass header.d=epam.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=epam.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LpHvE5DvK8NF6m9Zs56gPUeGPlKyYX08iF8Xu7ozfAo=;
 b=170PYMfum7wTcSj/x1aQcn35oOcbgxeDDDdn7DWR1KDNj9r3PG0MaQkmzqjMkBWUOteESfSdZ+GmJVKUFvyEedVu1XZObsTnbCm9Wp6zfiiWf87xE1dqdlu6s2sbqVNGvekAKBFxwb4sbmkRGnyPU3y3OtxmNrvSIQgHqJAxEYdeDQRrNxLO/QyFw7Wb0rs1JWRnLOA+R5W9xqa0GMzol4Zle0KfPIiMTCFNCqRlQh197RwazWqrJd2RYlNIu80AJu4GZCC0Ry5rkCwo4EGKv8+anyjPIyYr//1h2Pj6ipS5ox0pShGwZ5L3pFwVShBd/SxqoHwNAijWZ3lYvGun6A==
Received: from AM0PR03MB6324.eurprd03.prod.outlook.com (2603:10a6:20b:153::17)
 by AM0PR03MB3587.eurprd03.prod.outlook.com (2603:10a6:208:44::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.24; Thu, 20 Aug
 2020 07:14:56 +0000
Received: from AM0PR03MB6324.eurprd03.prod.outlook.com
 ([fe80::853d:1bd6:75a0:a7d7]) by AM0PR03MB6324.eurprd03.prod.outlook.com
 ([fe80::853d:1bd6:75a0:a7d7%8]) with mapi id 15.20.3305.025; Thu, 20 Aug 2020
 07:14:56 +0000
From:   Oleksandr Andrushchenko <Oleksandr_Andrushchenko@epam.com>
To:     Sasha Levin <sashal@kernel.org>,
        Oleksandr Andrushchenko <andr2000@gmail.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
CC:     "sstabellini@kernel.org" <sstabellini@kernel.org>,
        "dan.carpenter@oracle.com" <dan.carpenter@oracle.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v2 2/5] drm/xen-front: Fix misused IS_ERR_OR_NULL checks
Thread-Topic: [PATCH v2 2/5] drm/xen-front: Fix misused IS_ERR_OR_NULL checks
Thread-Index: AQHWcTn3Q6X6TpC2sk2hUb4/U9tW36lAJkgAgAB6eYA=
Date:   Thu, 20 Aug 2020 07:14:56 +0000
Message-ID: <61ab361a-6b3f-f9ba-2954-470e8854e230@epam.com>
References: <20200813062113.11030-3-andr2000@gmail.com>
 <20200819235634.BB9D621744@mail.kernel.org>
In-Reply-To: <20200819235634.BB9D621744@mail.kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=epam.com;
x-originating-ip: [185.199.97.5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2fda20eb-06ba-4eca-2b89-08d844d8be07
x-ms-traffictypediagnostic: AM0PR03MB3587:
x-microsoft-antispam-prvs: <AM0PR03MB35877B4438A3107A65FA8A0BE75A0@AM0PR03MB3587.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2399;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gdrnq0NWh6lv1CfjvSsJXgyimf/Y+JLtSCFSOtZyNtWKt1gzONwrEfVU5vpTy5x2UxvyjHxxPSj+iboDz5yg1U1Z+V3WLpRbfziF7tOreVItiRwS/cc9gB8ngxUQ6OZKhJXQSQpp+7dvan7Lh5JblrzhGO8+4HZMboffcgxYhhD3vADwx0X9W4JDQLwgku1CLpVu/tTSu1o/f6N4f/aI4yxLPxTBjrNihVBR5qr8qM8dnSg6tSV/Mo9E4Hpzy/IRc5WDsfEUh/Ls7Byfu0APWlGasOXFAMxgfgbah6wFvCu1mrRloxFSEnQxSCh7K+GEX8u0JsG7yEV6J7OkAdx5JA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR03MB6324.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(396003)(39860400002)(366004)(136003)(6512007)(2616005)(83380400001)(6486002)(66476007)(53546011)(66446008)(91956017)(66556008)(6506007)(5660300002)(8936002)(2906002)(64756008)(71200400001)(8676002)(186003)(36756003)(26005)(66946007)(110136005)(4326008)(31686004)(478600001)(86362001)(54906003)(76116006)(316002)(31696002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 3XZv2QO70jIY8n9QAna2lji+5TZwDSW6SZMnagvTvGyipSiVf9OgSFVwC4MB7gVUxIxmxgChc8w3UvWThqfsAm16tT/8MefYxS9FDM8fMhudUMM6F3RfpOvH5qumeSsDFCFsPlJsqgesjY0+jvn5YYpB9gnYdbwIW+/aNdLo5uxUT5OUALNRnro10VPzzCSUF11KcMUVVnkbTH+GX95CIMTtf6X+3uNxlNDvL7x0+S3uZPime7REa8lRYRC3GteheiBG/RKP6AL5GTyfrtat9nQvPwTC6K7tuadJxHTwDywh75YezvJO7zYp1GnJJkJmHVhEgFksSALgGI3JCKdSk4rFagSxq3ezVtevAhyZMYaf3yy68B/2CzBdp/zMmY83mms2/l0HZ89fH+13/7P9dnLxK2xwQxmxq7bsYCoZOfZY02D/P/JM9i2FT0SdyAWlV8yM5YaWfPKI6ZWcHnv96QYfuUJShecd+wQziULOo/tyXcPrPer7OuakueTa4dN0cMwe3KagZMz8G/Z4i3H0qovf3E4lrOvQKdw0goM7NikBEpLGkGr1K32+Jh4+vvrszSMNqKxWzqHkG2+pRhaNW8r/fjzJS1bU5U5TZ+2DpbN2sQ86K85+AooXvJ/cjY30WlYaQjJOzE6b1wEGr9H30Q==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <723A624ACB3A9D41BFE71A76A53EE2B7@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: epam.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR03MB6324.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fda20eb-06ba-4eca-2b89-08d844d8be07
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Aug 2020 07:14:56.3824
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b41b72d0-4e9f-4c26-8a69-f949f367c91d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rIBkeBJAqQJu92u7xoXi5CEs4hTKwOJXPksXpFVseBZRJDGBofZQ3VSUwUg2SCOMzpF8pE2KBcsNHU8XkqHzE2YiU5ZMiYmXZrn7ntkW82KEsvjFQvTMAeTOjAb/yFPz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR03MB3587
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-19_13:2020-08-19,2020-08-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 clxscore=1011
 impostorscore=0 priorityscore=1501 lowpriorityscore=0 suspectscore=0
 mlxlogscore=999 adultscore=0 phishscore=0 malwarescore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008200063
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGksDQoNCk9uIDgvMjAvMjAgMjo1NiBBTSwgU2FzaGEgTGV2aW4gd3JvdGU6DQo+IEhpDQo+DQo+
IFtUaGlzIGlzIGFuIGF1dG9tYXRlZCBlbWFpbF0NCj4NCj4gVGhpcyBjb21taXQgaGFzIGJlZW4g
cHJvY2Vzc2VkIGJlY2F1c2UgaXQgY29udGFpbnMgYSAiRml4ZXM6IiB0YWcNCj4gZml4aW5nIGNv
bW1pdDogYzU3NWI3ZWViODlmICgiZHJtL3hlbi1mcm9udDogQWRkIHN1cHBvcnQgZm9yIFhlbiBQ
ViBkaXNwbGF5IGZyb250ZW5kIikuDQo+DQo+IFRoZSBib3QgaGFzIHRlc3RlZCB0aGUgZm9sbG93
aW5nIHRyZWVzOiB2NS44LjEsIHY1LjcuMTUsIHY1LjQuNTgsIHY0LjE5LjEzOS4NCj4NCj4gdjUu
OC4xOiBCdWlsZCBPSyENCj4gdjUuNy4xNTogQnVpbGQgT0shDQo+IHY1LjQuNTg6IEZhaWxlZCB0
byBhcHBseSEgUG9zc2libGUgZGVwZW5kZW5jaWVzOg0KPiAgICAgIDRjMWNiMDRlMGU3YSAoImRy
bS94ZW46IGZpeCBwYXNzaW5nIHplcm8gdG8gJ1BUUl9FUlInIHdhcm5pbmciKQ0KPiAgICAgIDkz
YWRjMGMyY2I3MiAoImRybS94ZW46IFNpbXBsaWZ5IGZiX2NyZWF0ZSIpDQo+DQo+IHY0LjE5LjEz
OTogRmFpbGVkIHRvIGFwcGx5ISBQb3NzaWJsZSBkZXBlbmRlbmNpZXM6DQo+ICAgICAgNGMxY2Iw
NGUwZTdhICgiZHJtL3hlbjogZml4IHBhc3NpbmcgemVybyB0byAnUFRSX0VSUicgd2FybmluZyIp
DQo+ICAgICAgOTNhZGMwYzJjYjcyICgiZHJtL3hlbjogU2ltcGxpZnkgZmJfY3JlYXRlIikNCj4N
Cj4NCj4gTk9URTogVGhlIHBhdGNoIHdpbGwgbm90IGJlIHF1ZXVlZCB0byBzdGFibGUgdHJlZXMg
dW50aWwgaXQgaXMgdXBzdHJlYW0uDQo+DQo+IEhvdyBzaG91bGQgd2UgcHJvY2VlZCB3aXRoIHRo
aXMgcGF0Y2g/DQo+DQpUaGlzIGlzIGJlY2F1c2Ugb2YgY29tbWl0IDRjMWNiMDRlMGU3YWM0YmEx
ZWY1NDU3OTI5ZWY5YjU2NzFkOWVlZDMNCg0Kd2FzIG5vdCBDQ2VkIHRvIHN0YWJsZS4gU28sIGlm
IHdlIHdhbnQgdGhlIHBhdGNoIHRvIGJlIGFwcGxpZWQgdG8gb2xkZXIgc3RhYmxlDQoNCmtlcm5l
bHMgd2UgYWxzbyBuZWVkIHRoaXMgcGF0Y2ggYXMgd2VsbC4NCg0KVGhhbmsgeW91LA0KDQpPbGVr
c2FuZHINCg==
