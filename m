Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9B475B9DAB
	for <lists+stable@lfdr.de>; Thu, 15 Sep 2022 16:47:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230247AbiIOOre (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Sep 2022 10:47:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbiIOOrc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Sep 2022 10:47:32 -0400
Received: from mx0a-0039f301.pphosted.com (mx0a-0039f301.pphosted.com [148.163.133.242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9185F578BC;
        Thu, 15 Sep 2022 07:47:31 -0700 (PDT)
Received: from pps.filterd (m0174679.ppops.net [127.0.0.1])
        by mx0a-0039f301.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28FD3dCd001913;
        Thu, 15 Sep 2022 14:47:15 GMT
Received: from eur05-am6-obe.outbound.protection.outlook.com (mail-am6eur05lp2111.outbound.protection.outlook.com [104.47.18.111])
        by mx0a-0039f301.pphosted.com (PPS) with ESMTPS id 3jjxy9qtgr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Sep 2022 14:47:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ag9hfkh5xvF6oxz72nXeMBI61H8uLDAf6qgc0qdlY64Ay0qVVxU787UD1TwKErDZkZZvlXyag1SKvicC/fWpeDzcKhANFQJLNhJKcMp84hcVurTZMnUXoo/K+5kxcpOYxrG9rxkU6+6kZH81zGaNjwpEe80YQMIIvvNIsMwZr/xrR1rEJ4lXpbJHaCjikkMjMI1jQygSoV2ylHsFUcw5VRZzTYrdHP+lVFd5ahguX0Y8I7ZKyfv7/fn1egNcihdbS5IcLr+2Nagr5uVDrav6ao+riDE7PpIQVJ2HdFN2FtlzOBY3blRlG7Ly0kPU4G4DTb1DEcWKDeqpofEfk7RsEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XmhH4OHAj83WUaq1+htPXu31XFk9cLRFSxiLf8O+Fcg=;
 b=J5v+D9ivMPnBfcge7t56EZBk/Dat8rw/FqFgEGZOeRIftzJD2b+lzKbWHI81TfZS2dc9wOJLi+wRjzG5rlQoar+FEae5VYxHnPxedBbGzqyvJuSrNtLOQbf5HiWUkccDzm+S0zuE/0Rwxz/YT97TN37BZB1ht74CNb44L5IhrpOUAmWWgSE/vKG13yLz7goc/Elxvow5XjQ4WVGq+NDBSeZsAKJXsCLAR5AenaVlRJY0+kaS7BEoE372Bm1Hrq8Fs7fyT+tVMAow1q+xtfRc7hagNRmp2HwXuaDGTjMYEEdAN5ndtKhTIgVpc7571zaJIt4oVbL9jIL7h5ubCo4drQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=epam.com; dmarc=pass action=none header.from=epam.com;
 dkim=pass header.d=epam.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=epam.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XmhH4OHAj83WUaq1+htPXu31XFk9cLRFSxiLf8O+Fcg=;
 b=eg5IJ3pSbg2PDkhLsOy9tDOJz0fAYhX3/r8Xw4epWD++MFq9Sk4oUVi8u2RUXVE/xpmOWuBC4BDm8rpQkTUJpPP/eRmxqJyz3yGpsU1wqV3it8MJThzLh/EM0YvHfFvdJM+onf5JCv9NCPRUM8y7xBhloinpl/CpP/gOaeQb3c26Ox5epRXli71a+6PkVVHNpdYxMco9XXPaeOGD56Dr2J1AqijTRNBPAD/9tH36Jautbn2+TE2ZWXWHa2P07ym1GRe+ZnrHc1EkLt4/5DP821XSL9PLzROLsp3mM4MgXeLcIZGL2fZ1Fsh7lLb/Ksg8kw9FfPstt9cr3YeVSkhU7Q==
Received: from DB8PR03MB6108.eurprd03.prod.outlook.com (2603:10a6:10:ed::15)
 by GV1PR03MB8615.eurprd03.prod.outlook.com (2603:10a6:150:95::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Thu, 15 Sep
 2022 14:47:11 +0000
Received: from DB8PR03MB6108.eurprd03.prod.outlook.com
 ([fe80::f575:76e9:4a40:7387]) by DB8PR03MB6108.eurprd03.prod.outlook.com
 ([fe80::f575:76e9:4a40:7387%2]) with mapi id 15.20.5632.014; Thu, 15 Sep 2022
 14:47:10 +0000
From:   Oleksandr Tyshchenko <Oleksandr_Tyshchenko@epam.com>
To:     Juergen Gross <jgross@suse.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     Stefano Stabellini <sstabellini@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Sander Eikelenboom <linux@eikelenboom.it>
Subject: Re: [PATCH] xen/xenbus: fix xenbus_setup_ring()
Thread-Topic: [PATCH] xen/xenbus: fix xenbus_setup_ring()
Thread-Index: AQHYyQ/iPv5e34GuQU2mfPtgOqQE7q3gkeuA
Date:   Thu, 15 Sep 2022 14:47:10 +0000
Message-ID: <34c9a80d-3a9d-cd51-32d2-cf778c981107@epam.com>
References: <20220915143137.1763-1-jgross@suse.com>
In-Reply-To: <20220915143137.1763-1-jgross@suse.com>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DB8PR03MB6108:EE_|GV1PR03MB8615:EE_
x-ms-office365-filtering-correlation-id: 92a2770e-4048-4809-f142-08da97292bba
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: y4BdEmSzi4pNvhkd4C0BU8NE5dAEKMm68mz2CjHs64aiNfljAXEjUdBNEmbT9vUc7DFCkqAZRvgLkV74G7h1tiLyWvrdDmI5/SL0HWza8/nEntu7YE8huKKGU5c+gpjpU8ShjlftuKZNlUdVIZxLeqgPKuUbCaQ5E/j6RKnPNRepgoyOwbFDMvdlRGHaVaX1Pcemio2SICkDTuyCLuXDY64G/LKb9seOnTGuNveA9iUMUpSPP3CYmEIPNQBmMQ9zuZrSFf1EBtplekhvo+JRCWDUFmSX6QKe6TGgBW69ys9jOgAS/GkRiAcGCQz6YjK2kJkhZ/bAI0pgz4zH+itrZlE/Sok4iY57jJUrOdUH5eectVZZiZudnl8G70ytYI2FTL43KhKw9LOatVcPFr1iTnOip3s2T5M3lPfH+YBZFNDQkhf3Mb/7+ediot8mgFzW77AZ9lFh0fiqm9g3ugiKUb6bz7DqSekAAqLLNr6+Ny6uQSXJXSjx1IFbFak2Z8Ha7vjOfZqzi+FdbCoUkMTfFbEmNwG2rtTEGel+BmRzD0/gvLW5armj6qNjArzZq+D4PvmI3wyAes1GmLuy8kYzkK3o/F9KJ8nK98CMtuJLgC9mStDFJ5pN1TivF7yywToZ1GXa3C2izz3Jjoc9wUOaLaPM8urJZcU4Y4cPkGMZntqSDFCtCC7ou3XohYwtub4fc4d9nPo334fp0Iur4VVYNsVrPh0YGE/IAmEqg3LyC7jDu8ubJsZgj9/jfUORpq8XThj/8xC8K0BzuHJq5R4vdFpgD7LSZUQZySyZcpRBVI4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR03MB6108.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(136003)(346002)(396003)(366004)(376002)(451199015)(478600001)(31686004)(71200400001)(6486002)(36756003)(55236004)(2616005)(41300700001)(316002)(110136005)(6512007)(31696002)(54906003)(53546011)(6506007)(26005)(86362001)(186003)(66476007)(38070700005)(66556008)(66446008)(5660300002)(76116006)(38100700002)(64756008)(8676002)(4326008)(66946007)(2906002)(91956017)(122000001)(8936002)(83380400001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RUdhSVl2YmY0UVNiSldUeTlqTk5KN0J4YVFRNUpERGVYblU1aHh4UHhxRkN1?=
 =?utf-8?B?QWtSQ1FZT016UnB5ek8ycmNoM1IzMytuNzY0N01BRXZyRHJmN25lSUcrL1lK?=
 =?utf-8?B?UnFwNk9pbU1pNXA4eXQzK1M1bW1PYXRZM3VUSjdIQkR2V211T2dWWVAvL0Ux?=
 =?utf-8?B?dDV0MjBjVnM5V3cxWEN6VXNLOE54Q2NuNFlxSUNuVTBRbHh5NWhNczFBYlVs?=
 =?utf-8?B?QU1WT2FZS2VlN2N6ZHBSdkx3bkVMZ3lDY1Z6RGpNcm10UVJHaVJjMDZvS3FJ?=
 =?utf-8?B?S0dnUFkyK08yWXZJTkl4clVMTm5kaFhaOXorb000M0UyZ2FFbDZYZHNyczhn?=
 =?utf-8?B?T0FNeHhLU0NGRUFlVDBxVldwZkR4STQrcklQRXhab0VFd042QkJ6VkxQR0Ny?=
 =?utf-8?B?dTVCd3JHaXdjak1IcG5Ia2ZUQU90U1ZNaG9iL1RvMkRoZjRCOEVoSDJCeWxZ?=
 =?utf-8?B?MHJObVhrVzNnOXhMZUN6cFdCMVVWb1o4SkFESTNzUkxTNDVCY1RsbGdZMjVq?=
 =?utf-8?B?M1kxZUlIdkVUZ0U3RWtjZW1ZQmVKTzgwVXB5cXpPdE1GVTNsNjVZc0pzYVNx?=
 =?utf-8?B?b3QwQVI5d1p5bG8wdHM2Zm0yc3hjYkY3aml2czZST3ZkckFob1lPRUt0QWdi?=
 =?utf-8?B?QWxGZmFnVlNiQStYbDdwSEQwcnhJbFo4Y3pFMmlNT2pQdURaOXNmQ1E1MVl4?=
 =?utf-8?B?dVVSeWo2ZVByOXIyYzF5ZklSOCs0T3FOemEzSnRReEhlVGRXTGtsR0ZXZURs?=
 =?utf-8?B?aUNjdC92dGxJUEh4OHovU25JTDRXUWovcFF3SXJUeVpBOFNwemR2TWlnQUty?=
 =?utf-8?B?Z3d1dHpSdmdoMUQ1KzNoTGdiUndCaUlQQTdaMHBTV0dTNHNlSDJhaXFJU2k4?=
 =?utf-8?B?dmJ6WTg3Z092Qkc2ZWZDVWNCSEpiaXNZYW9rUmRaRGg3ZkFQRGhzWWNnRHNr?=
 =?utf-8?B?RDZpK2dCcWMrcHZrRVBDTmhTWHNwQTFibXZsYmM3WFhNN1dDaHdZNk94Z05K?=
 =?utf-8?B?Y0pFcUlFdlYxcHQ2a1JMVXZUMVZIY3NrTkNDK3VuVnMwS1hLcTJqTXFyd3Ju?=
 =?utf-8?B?cWNiL2pmRnJqNm5Ta0NZNFFlMEU0N3lER1VhVmdKZFNuS01VM2F1YWxNMTNv?=
 =?utf-8?B?OVNCT3ZvN28yS05qamlvUkF4c2tUUXBicXRienRWdHYxa0x1RjFBSFRqOUFh?=
 =?utf-8?B?MXNKTlZmRXhZQlROQ09WVEsycmlFdCs0RC91U3V0eTZ5aC8zc1U4dE1idFJG?=
 =?utf-8?B?d3FNU01ZTFYzemhwaW83SHZjK0NldFBJUVFzU1pvNXg1ZGRCNjljbVB4V2FS?=
 =?utf-8?B?bUZrRVhmVVpZTkk5RVZoemk0UFhNMXorNkVZRkJ1bUVDTFROK1dSQTJiVDhi?=
 =?utf-8?B?UjJRZ2V0dUgxYkg0NUErYXg3MGJDdktMa0h5Ni82a3I1UTBmSk5LbXBjSGxv?=
 =?utf-8?B?REZ0V2ZFTVlqd1czUGlnWHl6WGkwM25iRm5aUnVSU1d2cDUrOWpZQ3JYTFB0?=
 =?utf-8?B?NU5YK0NTc0tjNkQvVlNjeTZVcDl4OFBoTmFWQkJaQ2NOdWJlV3VDRURNMnNH?=
 =?utf-8?B?RUEzM0J1cnYwS2JGSWx6NjNzd282ZXFOUGVzcklZc1BIcURTd01NMzRwc0o5?=
 =?utf-8?B?L1ZwbmZhZHljdWM5U0RiNm1IUzYzbTIyY0FBTmZEUmkxR2ZOei9TQW1UYzZR?=
 =?utf-8?B?T1RtU2NYdVZWd09EWUFtQkJEY3dvUXpybmZGaEFXU3FKd05XZUVDbFc2YlRS?=
 =?utf-8?B?STFSVFdGdjI2UHlyUkM1cUZNQS9JOUE5RXoyTk1Pa1JUVW43RDBSSHZPRi9E?=
 =?utf-8?B?UDNyTjRqSEFUeGZkWGw1QlRKaWxRbzdPZlJQTHJOTWtpbUlZcHpuYVI0c1Vs?=
 =?utf-8?B?TkhKMTFrbG90U1liaUtyTldKNUZuWE12VUVzbGV1Q0tYZUdJVkQ4U0M5K3dw?=
 =?utf-8?B?RXlUc0tXSUllWDh3a0FYeDZhMW04ckNrMnhhTXc1V0IrbEZockowV3NCUVY4?=
 =?utf-8?B?ekYyOWx0a2pCdEVXaWMxSUJPMjBpTzNuMGw5QW9NWmRZejkwM3JaVCtBUkI0?=
 =?utf-8?B?LzJLeUE0eWtsS1QwaEdjNjdMbkhmWVhjSkxIUy9Xb0FFUmdCaGI4R0publRx?=
 =?utf-8?B?YnlrTGllWHlqdSsraGdVdkVLWmFUTVROS0tZQTZNMWM5ZTZUMWtmby9iMU91?=
 =?utf-8?Q?bTSjXgZ11JiO/GtgRJbScdM=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9A3A4702C79CEA4A83E454F929660DB1@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: epam.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR03MB6108.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92a2770e-4048-4809-f142-08da97292bba
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Sep 2022 14:47:10.8846
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b41b72d0-4e9f-4c26-8a69-f949f367c91d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yFIpMb3t6B9Ys99g9NB5O4Wt9nkxsiqhD6jiBmSR89FGanVkkloh9PqTXEw9UVppSv74lZ+mGH09LLoeEBXLPnhRajVOayI09W+YpDDnkmU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR03MB8615
X-Proofpoint-GUID: 0uI7TKAlfT3CkPcY2wH27fau9WqKqwUG
X-Proofpoint-ORIG-GUID: 0uI7TKAlfT3CkPcY2wH27fau9WqKqwUG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-15_08,2022-09-14_04,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 priorityscore=1501 mlxlogscore=999 impostorscore=0
 clxscore=1011 mlxscore=0 phishscore=0 bulkscore=0 malwarescore=0
 suspectscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2208220000 definitions=main-2209150086
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQpPbiAxNS4wOS4yMiAxNzozMSwgSnVlcmdlbiBHcm9zcyB3cm90ZToNCg0KSGVsbG8gSnVlcmdl
bg0KDQo+IENvbW1pdCA0NTczMjQwZjA3NjQgKCJ4ZW4veGVuYnVzOiBlbGltaW5hdGUgeGVuYnVz
X2dyYW50X3JpbmcoKSIpDQo+IGludHJvZHVjZWQgYW4gZXJyb3IgZm9yIGluaXRpYWxpemF0aW9u
IG9mIG11bHRpLXBhZ2UgcmluZ3MuDQo+DQo+IENjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnDQo+
IEZpeGVzOiA0NTczMjQwZjA3NjQgKCJ4ZW4veGVuYnVzOiBlbGltaW5hdGUgeGVuYnVzX2dyYW50
X3JpbmcoKSIpDQo+IFJlcG9ydGVkLWJ5OiBTYW5kZXIgRWlrZWxlbmJvb20gPGxpbnV4QGVpa2Vs
ZW5ib29tLml0Pg0KPiBTaWduZWQtb2ZmLWJ5OiBKdWVyZ2VuIEdyb3NzIDxqZ3Jvc3NAc3VzZS5j
b20+DQo+IC0tLQ0KPiAgIGRyaXZlcnMveGVuL3hlbmJ1cy94ZW5idXNfY2xpZW50LmMgfCA5ICsr
KysrKy0tLQ0KPiAgIDEgZmlsZSBjaGFuZ2VkLCA2IGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25z
KC0pDQo+DQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3hlbi94ZW5idXMveGVuYnVzX2NsaWVudC5j
IGIvZHJpdmVycy94ZW4veGVuYnVzL3hlbmJ1c19jbGllbnQuYw0KPiBpbmRleCBkNWYzZjc2Mzcx
N2UuLmNhYTVjNWMzMmY4ZSAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy94ZW4veGVuYnVzL3hlbmJ1
c19jbGllbnQuYw0KPiArKysgYi9kcml2ZXJzL3hlbi94ZW5idXMveGVuYnVzX2NsaWVudC5jDQo+
IEBAIC0zODIsOSArMzgyLDEwIEBAIGludCB4ZW5idXNfc2V0dXBfcmluZyhzdHJ1Y3QgeGVuYnVz
X2RldmljZSAqZGV2LCBnZnBfdCBnZnAsIHZvaWQgKip2YWRkciwNCj4gICAJdW5zaWduZWQgbG9u
ZyByaW5nX3NpemUgPSBucl9wYWdlcyAqIFhFTl9QQUdFX1NJWkU7DQo+ICAgCWdyYW50X3JlZl90
IGdyZWZfaGVhZDsNCj4gICAJdW5zaWduZWQgaW50IGk7DQo+ICsJdm9pZCAqYWRkcjsNCj4gICAJ
aW50IHJldDsNCj4gICANCj4gLQkqdmFkZHIgPSBhbGxvY19wYWdlc19leGFjdChyaW5nX3NpemUs
IGdmcCB8IF9fR0ZQX1pFUk8pOw0KPiArCWFkZHIgPSAqdmFkZHIgPSBhbGxvY19wYWdlc19leGFj
dChyaW5nX3NpemUsIGdmcCB8IF9fR0ZQX1pFUk8pOw0KPiAgIAlpZiAoISp2YWRkcikgew0KPiAg
IAkJcmV0ID0gLUVOT01FTTsNCj4gICAJCWdvdG8gZXJyOw0KPiBAQCAtNDAxLDEzICs0MDIsMTUg
QEAgaW50IHhlbmJ1c19zZXR1cF9yaW5nKHN0cnVjdCB4ZW5idXNfZGV2aWNlICpkZXYsIGdmcF90
IGdmcCwgdm9pZCAqKnZhZGRyLA0KPiAgIAkJdW5zaWduZWQgbG9uZyBnZm47DQo+ICAgDQo+ICAg
CQlpZiAoaXNfdm1hbGxvY19hZGRyKCp2YWRkcikpDQo+IC0JCQlnZm4gPSBwZm5fdG9fZ2ZuKHZt
YWxsb2NfdG9fcGZuKHZhZGRyW2ldKSk7DQo+ICsJCQlnZm4gPSBwZm5fdG9fZ2ZuKHZtYWxsb2Nf
dG9fcGZuKGFkZHIpKTsNCj4gICAJCWVsc2UNCj4gLQkJCWdmbiA9IHZpcnRfdG9fZ2ZuKHZhZGRy
W2ldKTsNCj4gKwkJCWdmbiA9IHZpcnRfdG9fZ2ZuKGFkZHIpOw0KPiAgIA0KPiAgIAkJZ3JlZnNb
aV0gPSBnbnR0YWJfY2xhaW1fZ3JhbnRfcmVmZXJlbmNlKCZncmVmX2hlYWQpOw0KPiAgIAkJZ250
dGFiX2dyYW50X2ZvcmVpZ25fYWNjZXNzX3JlZihncmVmc1tpXSwgZGV2LT5vdGhlcmVuZF9pZCwN
Cj4gICAJCQkJCQlnZm4sIDApOw0KPiArDQo+ICsJCWFkZHIgKz0gUEFHRV9TSVpFOw0KDQpYRU5f
UEFHRV9TSVpFPw0KDQoNClJldmlld2VkLWJ5OiBPbGVrc2FuZHIgVHlzaGNoZW5rbyA8b2xla3Nh
bmRyX3R5c2hjaGVua29AZXBhbS5jb20+DQoNCg0KUC5TLg0KDQpJIHdvbmRlcmVkIHdoeSBJIGRp
ZG4ndCBmYWNlIHRoZSBzaW1pbGFyIGlzc3VlKHMpIGFzIEkgdXNlZCBMaW51eCANCnY2LjAuMC1y
YzEgYW5kIHNldmVyYWwgUFYgZHJpdmVycyBpbmNsdWRpbmcgUFYgYmxvY2sgZGV2aWNlLg0KDQpU
aGUgYW5zd2VyIGlzIHRoYXQgdGhlIHNpbmdsZS1wYWdlIHJpbmcgaXMgYmVpbmcgdXNlZCBmb3Ig
YWxsIG9mIHRoZW0gaW4gDQpteSBlbnZpcm9ubWVudC4NCg0KDQpyb290QHNhbHZhdG9yLXgtaDMt
NHgyZy14dC1kb211On4jIGRtZXNnIHwgZ3JlcCB4ZW5idXNfc2V0dXBfcmluZw0KW8KgwqDCoCAw
LjMzMjQ0OV0gdmRpc3BsIHZkaXNwbC0wOiAwIHhlbmJ1c19zZXR1cF9yaW5nOiAxIHBhZ2VzDQpb
wqDCoMKgIDAuMzMzNDY0XSB2ZGlzcGwgdmRpc3BsLTA6IDAgeGVuYnVzX3NldHVwX3Jpbmc6IDEg
cGFnZXMNClvCoMKgwqAgMC4zNDEzNTBdIHZiZCB2YmQtNTE3MTM6IDAgeGVuYnVzX3NldHVwX3Jp
bmc6IDEgcGFnZXMNClvCoMKgwqAgMC4zNDI3NTBdIHZiZCB2YmQtNTE3MTM6IDAgeGVuYnVzX3Nl
dHVwX3Jpbmc6IDEgcGFnZXMNClvCoMKgwqAgMC4zNDMyNjFdIHZiZCB2YmQtNTE3MTM6IDAgeGVu
YnVzX3NldHVwX3Jpbmc6IDEgcGFnZXMNClvCoMKgwqAgMC4zNDM3OThdIHZiZCB2YmQtNTE3MTM6
IDAgeGVuYnVzX3NldHVwX3Jpbmc6IDEgcGFnZXMNClvCoMKgwqAgMC4zOTI5NjldIHZpZiB2aWYt
MDogMCB4ZW5idXNfc2V0dXBfcmluZzogMSBwYWdlcw0KW8KgwqDCoCAwLjUxODczM10gdmlmIHZp
Zi0wOiAwIHhlbmJ1c19zZXR1cF9yaW5nOiAxIHBhZ2VzDQpbwqDCoMKgIDAuNTE5MTk4XSB2aWYg
dmlmLTA6IDAgeGVuYnVzX3NldHVwX3Jpbmc6IDEgcGFnZXMNClvCoMKgwqAgMC41MTk1MDFdIHZp
ZiB2aWYtMDogMCB4ZW5idXNfc2V0dXBfcmluZzogMSBwYWdlcw0KW8KgwqDCoCAwLjUxOTk0OF0g
dmlmIHZpZi0wOiAwIHhlbmJ1c19zZXR1cF9yaW5nOiAxIHBhZ2VzDQpbwqDCoMKgIDAuNTIwMzcx
XSB2aWYgdmlmLTA6IDAgeGVuYnVzX3NldHVwX3Jpbmc6IDEgcGFnZXMNClvCoMKgwqAgMC41MjA4
MDVdIHZpZiB2aWYtMDogMCB4ZW5idXNfc2V0dXBfcmluZzogMSBwYWdlcw0KW8KgwqDCoCAwLjUy
MTA3MF0gdmlmIHZpZi0wOiAwIHhlbmJ1c19zZXR1cF9yaW5nOiAxIHBhZ2VzDQpbwqDCoMKgIDAu
NTc1NDUxXSB2c25kIHZzbmQtMDogMCB4ZW5idXNfc2V0dXBfcmluZzogMSBwYWdlcw0KW8KgwqDC
oCAwLjU3Njg1NV0gdnNuZCB2c25kLTA6IDAgeGVuYnVzX3NldHVwX3Jpbmc6IDEgcGFnZXMNCg0K
DQo+ICAgCX0NCj4gICANCj4gICAJcmV0dXJuIDA7DQoNCi0tIA0KUmVnYXJkcywNCg0KT2xla3Nh
bmRyIFR5c2hjaGVua28NCg==
