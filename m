Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1447760F2C3
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 10:43:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235098AbiJ0Ink (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 04:43:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235118AbiJ0Ing (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 04:43:36 -0400
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B06B515818D;
        Thu, 27 Oct 2022 01:43:34 -0700 (PDT)
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
        by mx0a-0031df01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29R1p8tQ002139;
        Thu, 27 Oct 2022 08:43:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=qcppdkim1;
 bh=Gi56Hf851r1lwRikHtJlMSJMnmjGqToa2Up8VvkgpwY=;
 b=Qy75YCYAI09OqZOrrm4ax1xHCskXwZTrk88TefLrzMEoXhpO+Gr9AP3o1QsyFlceb9Nb
 jhknMlHK/8fgVJAmwMfj+hPQ2gHLrz0vXQ35Q2HPMUSFqb/8pq0F1OKeYSSPs3rFlIBG
 dFQ4gb7haKKGQbMFpUER6INL+54XDD3kSgnIs5CFUSCbUPVQtXGF9eTls71anKzR/ynY
 8LRCUhLRRQ0FPhZKlfh7zDhlupjQoh5FroaGw3rx+gBLg6QbTt0LF7sNpxYUeM+vgpkh
 p9ONkeTFuLJtMSEXO1+xApEVwOx6jwNfeiRY5W6XK4WhA8EhvQ+ov4dOkSw/y+6qCVtV BQ== 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2108.outbound.protection.outlook.com [104.47.58.108])
        by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3kfah51xwc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Oct 2022 08:43:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QeMMvWX0mJM67wIFN8kXUP2KUf+YzmT0bFWk7OXW7GXx/8YGItV//n+H2Qcw0b8SfDGIe5AZDJPdlKxPE6Uu2o6+vQ7qN4q2HtOtfTtIZgnkqun/OoxZqpb4ibA7Jjr1HBRaeljaq8ZDmShyGXwKE7nXIDpnHjhbuIaCV6lvJrcAf84dlStB6IoHqitzOqt250UaiON0xVZAZDXaafKbo2gnLE1O9DyLJz8G9t95OvsiyyJoQc0v6cTpff7XkTL9f4qEgdzuMaKjhF2VsGU01VyufhyPEbRBqaV6goUOPIpd6Z7xHWUXqY3CtX40aEIm4Y4sPz3MWSQ9fnqymjFxSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gi56Hf851r1lwRikHtJlMSJMnmjGqToa2Up8VvkgpwY=;
 b=CagYftZlneN3/1vVdjeAk/Q+dIQkNkIGCbzf2dj9wabD0/3zUcdpC+kcPwWmQUIIByJfXk+2t2ZkpvV95R7EYi2pjzN+jWQHfm6Q0OScu6hKKu2mRFajaeO/kewBTcswYtpE0rN6zGLaanBg6hfDwxAwJ9S6fbR7WidLp4toDPChK3+XrXfOMTumveMqH0sbLQR45XrhNydm8ltNX54JIIGIq9M4/RS+W90SH4DqD5NcJglLo4gyk0/jekQrY02y7PcpQdGkMwk6AspDqqo8ruBaOi1r9XOwfkHrTjKw5/e3hg887JOTDYul/BQNBvFjeBAI6wJKmAP0KuFDpWn9cQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=qti.qualcomm.com; dmarc=pass action=none
 header.from=qti.qualcomm.com; dkim=pass header.d=qti.qualcomm.com; arc=none
Received: from SJ0PR02MB8385.namprd02.prod.outlook.com (2603:10b6:a03:3e4::11)
 by BL3PR02MB7892.namprd02.prod.outlook.com (2603:10b6:208:353::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.28; Thu, 27 Oct
 2022 08:43:29 +0000
Received: from SJ0PR02MB8385.namprd02.prod.outlook.com
 ([fe80::f6a7:579e:7d0b:e74d]) by SJ0PR02MB8385.namprd02.prod.outlook.com
 ([fe80::f6a7:579e:7d0b:e74d%3]) with mapi id 15.20.5746.028; Thu, 27 Oct 2022
 08:43:29 +0000
From:   "Aiqun Yu (Maria)" <aiquny@qti.qualcomm.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        "Aiqun Yu (QUIC)" <quic_aiquny@quicinc.com>
CC:     "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] pinctrl: core: Make p->state in order in
 pinctrl_commit_state
Thread-Topic: [PATCH] pinctrl: core: Make p->state in order in
 pinctrl_commit_state
Thread-Index: AQHY6dCJBetiofi0F0OiVcg2jfEKha4h1okAgAAV8BA=
Date:   Thu, 27 Oct 2022 08:43:29 +0000
Message-ID: <SJ0PR02MB8385CDAD532E58836B7F23E6E9339@SJ0PR02MB8385.namprd02.prod.outlook.com>
References: <20221027065110.9395-1-quic_aiquny@quicinc.com>
 <Y1oyEMYRK8R0dOs1@kroah.com>
In-Reply-To: <Y1oyEMYRK8R0dOs1@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ0PR02MB8385:EE_|BL3PR02MB7892:EE_
x-ms-office365-filtering-correlation-id: e8b14708-2a1b-4337-12f7-08dab7f7525a
x-ld-processed: 98e9ba89-e1a1-4e38-9007-8bdabc25de1d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0CSJTqkgmGx98NsNW8iSX5zjlr3p04qn6bSys4CXBs5x4jftQXk84A7mj6xt7n7GY0NksW4iRrJWSH8JNuFlaFNwZboxTtcwfwl9LvOt44NiUV5u26jRor7SHLRgHxAKEa/hBrFVYriKhg1MlylLdgnlmN9Tl7F6VYMYtjHdOA2oK2TNlM2jl5CLjALZvNADJo3gpclKNwuKCU9Vk9+6EIlKoQoDVRS76tjPi8OVMhiXG9wccTxVNxkjDnIFfS/aijzMblez1wpAsYTzV51Ut9tZWSg+iT6kh02bMW8q8nTMeCEfYE2YaFakiWdXZnP6GqDgOM6US0YRqNikiEAZH1gOx0R22yFbCL6IXWLRYt17keVuHcs5QSrELu43p00SO7S6in0jDiSoNRzYdIbAvyQznlRwSxnxb2oDlKlLCT1nhKl/ZnwlIGnmcR4khTRonWJ897/yjY6uOtvSfP2Dlc/uxHDWhXflP/cdfi/HeTh5tt4OPViSf8kxYNzt57HhIbU0oMNU9XVJv7j7rWaUo4tq73rHleyqdBs8fv5buJK9ZLASiNcoOBnW/eZXP3A3jn0JNS7MbZamM2Hqwx6g6sbn07HqmPBsIMfiNT1wZL3yEa3Bgv4ngiFD5IliDH9wReSrlv/NxWVYEugq4ovQOOKBFb8YudurQGVoiX8iR8FJQmITxtrvOC3Hq8EJOGZzcCO0GGClmeWu4JHlAb8FHO+gpNEpRZUfYWEdLIjRmnHhiXe86fpRDjuxPsNIuMcSoeuzlLyOUi/Wf24wRgdmYn+7VYKQYDtktd5rEtaMaz0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR02MB8385.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(346002)(396003)(136003)(376002)(39860400002)(451199015)(52536014)(41300700001)(8936002)(5660300002)(2906002)(966005)(8676002)(64756008)(66476007)(66446008)(76116006)(66556008)(66946007)(110136005)(122000001)(26005)(316002)(478600001)(9686003)(4326008)(6506007)(7696005)(33656002)(53546011)(54906003)(71200400001)(83380400001)(86362001)(38070700005)(38100700002)(55016003)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?b08yWERGUTlTQysxeFZXSXhkV1JRMFV0L3JhOGd4M3FtNS9zT0xjdkJaMGdC?=
 =?utf-8?B?aUlVTTNtMWRuTlhSc3Y2TXNDbCtMRnIvK3ZoZzlEUmZFcHdpVkhoVGVubE5W?=
 =?utf-8?B?Y2NBWm5jYnFvSlpvZlZNNndENU04Skh2UHU4OVhPczZ5M0lhcVByS3ZHYXM2?=
 =?utf-8?B?OXFDbEowM2JEaXg1SlhBbGF6a3FzUUp6SkJFTXQ1bjdHUTU2TkREb215ZHNN?=
 =?utf-8?B?aTVFV0I1Q2dzeDJMREtuQUVZQ0t4Vkh1UkxTa0N1YjVlaVJ4bDk3bnZkOVhF?=
 =?utf-8?B?bGhySkZ3L1lXdm03cVZRTUVRSkNBcEhVVXFHVW1wMVVDT2FOU0lWVjFqT1ZQ?=
 =?utf-8?B?TWcrMG1tdGVrcm1aa05NSTNHWlM2UjhSMnlSZWh5R0RhcWUrSExKTEJLOFZ5?=
 =?utf-8?B?emc5SGp6NU1ITTE3OENWRk14cVZPenRFcEI5RytrWkRhNnpqdzYybXBMb0tD?=
 =?utf-8?B?b2tmZHdCaHNWN1JnWktUc3dPYzVZNUhmcDN2QkNCVWxqekF4TTMzSjV3UGN6?=
 =?utf-8?B?bmtRUG54ZThmYkxIN2dnZC9paGd6UktCM2RpS3V4TlYrMDVucExIVnJLRWt3?=
 =?utf-8?B?d0JDcmhrRERyNlpJdi9ZUkd3MWxRQ2tJSkNiOHZNbDUwWnhTVkozbUlUQ2Nk?=
 =?utf-8?B?WnlEWE92R2lEa25EenpnRStpNERNOXRmRDJPbDR2bUZZaVBPU3lWL1BTYS9o?=
 =?utf-8?B?REhXNXpxSUwvR0E0ZHA5dFdwY3pUSnYxOVphdG9CTGlBbi9wWXBBY0xDakhX?=
 =?utf-8?B?MFRBU3lKL1RYZDJqNVIvRHVnb25yQnRWOHNTL1JERHFiSithVGtQTDdLOUhV?=
 =?utf-8?B?amtJVUVwUk40b1Z1NWoxRk1VUmFHdU1QS2dnZFc4QVk0YlBjS0JMZ0R0bnlC?=
 =?utf-8?B?cUVFWEt5SjVNYmJBQzVhTVo5T0V0dnhQNXpkRWdOTCtHY0xyTVNPczdVanZY?=
 =?utf-8?B?c0hDbHh3akpzbFJYSG9OSzFmTmVKS281TUlhL3lrWVI3bDJzTkhVa3NEcStJ?=
 =?utf-8?B?MVF6WjUxNzg0UlY2R2ZsS0lLR2xoOVpka2E0NlhkZ2JQQUdmR0RyNVJub3lK?=
 =?utf-8?B?N0ZPRFJNaUFNNmd6QWkvWDlUVnJQd2dSSGpYLzBON0liTlRFSUl2bEdLaGFs?=
 =?utf-8?B?dy9pVTRPWFdoZ1UxVldrdk1uZlgzKzBIL1FCT3pVSHNXajkzWkg3SWZiOEtS?=
 =?utf-8?B?WFE4Z1M5eHNRU1ZCeEZEdTRmWUlaMm1QRVB4TEY0R0FuSzhZY0Nnd2Z1eitP?=
 =?utf-8?B?ZVlaRUZ6STBZMmhZQmVqbkNJb05kWWd1NHg3OVVXWERDMm1ZR1VYQ2g1amZK?=
 =?utf-8?B?UGkzaGR6YWIvNmQ3ZlRZL1VYVW85ZDM4Zmt0ejZZdjJPODRtV1BCcG05dm5r?=
 =?utf-8?B?bUtRWmlMQTJZZGNmMm5EOHJMLzNJV2Q2UUpPS0lDUDZ3MGNXblZNZ2xtWGFH?=
 =?utf-8?B?Q3F4Q2ppSDJBaU9Ib2RBTkVGR3pOV0ZBUHl6MWJXSEJocnQ5WWgxRWFSL2o1?=
 =?utf-8?B?TGQ4MkcyNXFHU2ZHQ1A5dElBc1NiclZVTC80M0RDejhlSk0zKzUyQUZRS2VS?=
 =?utf-8?B?dUlnbHNQREN2bTFOeTB1TzBFK0xIR1M4OWNCM1EvVlpLOHdJbUR0YXVqYWlZ?=
 =?utf-8?B?REtBSm4xQ0tIYkt2Wmg1SFNTWVcyVGZ2MlM4c3RXWmJjKzRQNUd3aWhGYWlw?=
 =?utf-8?B?di9yQjNjbEhaVlZmWTB6RVJadXNTNEdhTTFUZGdJR3d1Rk1sRnRUcDdYSXl3?=
 =?utf-8?B?UjdiSmxaVnhSemhmM0UwOEZUbU16WTgwZXBQRUpXZWlBdVhxd1ZBMmxTbnMx?=
 =?utf-8?B?cUtoeGhmOGVadThoalVKVXBDT0N4Z1VBYzZsaWtQclNNTE1nQWlmcFVRam9u?=
 =?utf-8?B?Wlo4TTd4N0xkRmQycHNzYTZRajI3VmpGMHNHN2NCMlNyWm9FVEtPb2JzU1R2?=
 =?utf-8?B?S1ZLMkNFbmpaMk1XV2lBQlA1RVJLaG02ZmQrTExFdXRmRFJ1RDRuQUNuOWVz?=
 =?utf-8?B?V1M1Q3haWjM2N1JvZno2Y2VKcThQUldjeGNoVVpTczFsdnNvbGVRT05EMXha?=
 =?utf-8?B?NEQ0UlR1aXZodHM2WmdzbGZDWTl5cC9VbWdqZmJjZ1ZpakZBaG1TRHdyN0Iw?=
 =?utf-8?Q?xlp4UR1ZODfSEvivf+mudGQrX?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: qti.qualcomm.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR02MB8385.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8b14708-2a1b-4337-12f7-08dab7f7525a
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Oct 2022 08:43:29.2473
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 98e9ba89-e1a1-4e38-9007-8bdabc25de1d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RYL7esJhNakDx295KZZ7ZfHzPxLpg+fL14VeaPEabvBQoQ2Ot9z8jfEtHb3QLks2wzJByhu8xIgkD1SNp3yFWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR02MB7892
X-Proofpoint-GUID: c00UCx_YXRUepireZb21j1qNIZVqtMYx
X-Proofpoint-ORIG-GUID: c00UCx_YXRUepireZb21j1qNIZVqtMYx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-27_03,2022-10-26_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 mlxscore=0 bulkscore=0 lowpriorityscore=0 malwarescore=0 suspectscore=0
 spamscore=0 mlxlogscore=956 clxscore=1011 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2210270048
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

VGh4IEdyZWcsDQoNClBscyBpZ25vcmUgdGhpcyB0aHJlYWQuIEFscmVhZHkgY29ycmVjdCB0byB0
aGUgbm9ybWFsICBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnICBpbiBhbm90aGVyIGVtYWls
IHRocmVhZC4NCg0KVGh4IGFuZCBCUnMsDQpBaXF1biBZdSAoTWFyaWEpDQoNCi0tLS0tT3JpZ2lu
YWwgTWVzc2FnZS0tLS0tDQpGcm9tOiBHcmVnIEtIIDxncmVna2hAbGludXhmb3VuZGF0aW9uLm9y
Zz4gDQpTZW50OiBUaHVyc2RheSwgT2N0b2JlciAyNywgMjAyMiAzOjI0IFBNDQpUbzogQWlxdW4g
WXUgKFFVSUMpIDxxdWljX2FpcXVueUBxdWljaW5jLmNvbT4NCkNjOiBsaW51cy53YWxsZWlqQGxp
bmFyby5vcmc7IGxpbnV4LWdwaW9Admdlci5rZXJuZWwub3JnOyBzdGFibGVAdmdlci5rZXJuZWwu
b3JnDQpTdWJqZWN0OiBSZTogW1BBVENIXSBwaW5jdHJsOiBjb3JlOiBNYWtlIHAtPnN0YXRlIGlu
IG9yZGVyIGluIHBpbmN0cmxfY29tbWl0X3N0YXRlDQoNCldBUk5JTkc6IFRoaXMgZW1haWwgb3Jp
Z2luYXRlZCBmcm9tIG91dHNpZGUgb2YgUXVhbGNvbW0uIFBsZWFzZSBiZSB3YXJ5IG9mIGFueSBs
aW5rcyBvciBhdHRhY2htZW50cywgYW5kIGRvIG5vdCBlbmFibGUgbWFjcm9zLg0KDQpPbiBUaHUs
IE9jdCAyNywgMjAyMiBhdCAwMjo1MToxMFBNICswODAwLCBNYXJpYSBZdSB3cm90ZToNCj4gV2Un
dmUgZ290IGEgZHVtcCB0aGF0IGN1cnJlbnQgY3B1IGlzIGluIHBpbmN0cmxfY29tbWl0X3N0YXRl
LCB0aGUgDQo+IG9sZF9zdGF0ZSAhPSBwLT5zdGF0ZSB3aGlsZSB0aGUgc3RhY2sgaXMgc3RpbGwg
aW4gdGhlIHByb2Nlc3Mgb2YgDQo+IHBpbm11eF9kaXNhYmxlX3NldHRpbmcuIFNvIGl0IG1lYW5z
IGV2ZW4gaWYgdGhlIGN1cnJlbnQgcC0+c3RhdGUgaXMgDQo+IGNoYW5nZWQgaW4gbmV3IHN0YXRl
LCB0aGUgc2V0dGluZ3MgYXJlIG5vdCB5ZXQgdXAtdG8tZGF0ZSBlbmFibGVkIA0KPiBjb21wbGV0
ZSB5ZXQuDQo+DQo+IEN1cnJlbnRseSBwLT5zdGF0ZSBpbiBkaWZmZXJlbnQgdmFsdWUgdG8gc3lu
Y2hyb25pemUgdGhlIA0KPiBwaW5jdHJsX2NvbW1pdF9zdGF0ZSBiZWhhdmlvcnMuIFRoZSBwLT5z
dGF0ZSB3aWxsIGhhdmUgdHJhbnNhY3Rpb24gDQo+IGxpa2Ugb2xkX3N0YXRlIC0+IE5VTEwgLT4g
bmV3X3N0YXRlLiBXaGVuIGluIG9sZF9zdGF0ZSwgaXQgd2lsbCB0cnkgdG8gDQo+IGRpc2FibGUg
YWxsIHRoZSBhbGwgc3RhdGUgc2V0dGluZ3MuIEFuZCB3aGVuIGFmdGVyIG5ldyBzdGF0ZSBzZXR0
aW5ncyANCj4gZW5hYmxlZCwgcC0+c3RhdGUgd2lsbCBjaGFuZ2VkIHRvIHRoZSBuZXcgc3RhdGUg
YWZ0ZXIgdGhhdC4gU28gdXNlIA0KPiBzbXBfbWIgdG8gc3luY2hyb25pemUgdGhlIHAtPnN0YXRl
IHZhcmlhYmxlIGFuZCB0aGUgc2V0dGluZ3MgaW4gb3JkZXIuDQo+IC0tLQ0KPiAgZHJpdmVycy9w
aW5jdHJsL2NvcmUuYyB8IDIgKysNCj4gIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKykN
Cj4NCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvcGluY3RybC9jb3JlLmMgYi9kcml2ZXJzL3BpbmN0
cmwvY29yZS5jIGluZGV4IA0KPiA5ZTU3ZjRjNjJlNjAuLmNkOTE3YTViMWEwYSAxMDA2NDQNCj4g
LS0tIGEvZHJpdmVycy9waW5jdHJsL2NvcmUuYw0KPiArKysgYi9kcml2ZXJzL3BpbmN0cmwvY29y
ZS5jDQo+IEBAIC0xMjU2LDYgKzEyNTYsNyBAQCBzdGF0aWMgaW50IHBpbmN0cmxfY29tbWl0X3N0
YXRlKHN0cnVjdCBwaW5jdHJsICpwLCBzdHJ1Y3QgcGluY3RybF9zdGF0ZSAqc3RhdGUpDQo+ICAg
ICAgICAgICAgICAgfQ0KPiAgICAgICB9DQo+DQo+ICsgICAgIHNtcF9tYigpOw0KPiAgICAgICBw
LT5zdGF0ZSA9IE5VTEw7DQo+DQo+ICAgICAgIC8qIEFwcGx5IGFsbCB0aGUgc2V0dGluZ3MgZm9y
IHRoZSBuZXcgc3RhdGUgLSBwaW5tdXggZmlyc3QgKi8gQEAgDQo+IC0xMzA1LDYgKzEzMDYsNyBA
QCBzdGF0aWMgaW50IHBpbmN0cmxfY29tbWl0X3N0YXRlKHN0cnVjdCBwaW5jdHJsICpwLCBzdHJ1
Y3QgcGluY3RybF9zdGF0ZSAqc3RhdGUpDQo+ICAgICAgICAgICAgICAgICAgICAgICBwaW5jdHJs
X2xpbmtfYWRkKHNldHRpbmctPnBjdGxkZXYsIHAtPmRldik7DQo+ICAgICAgIH0NCj4NCj4gKyAg
ICAgc21wX21iKCk7DQo+ICAgICAgIHAtPnN0YXRlID0gc3RhdGU7DQo+DQo+ICAgICAgIHJldHVy
biAwOw0KPiAtLQ0KPiAyLjE3LjENCj4NCg0KPGZvcm1sZXR0ZXI+DQoNClRoaXMgaXMgbm90IHRo
ZSBjb3JyZWN0IHdheSB0byBzdWJtaXQgcGF0Y2hlcyBmb3IgaW5jbHVzaW9uIGluIHRoZSBzdGFi
bGUga2VybmVsIHRyZWUuICBQbGVhc2UgcmVhZDoNCiAgICBodHRwczovL3d3dy5rZXJuZWwub3Jn
L2RvYy9odG1sL2xhdGVzdC9wcm9jZXNzL3N0YWJsZS1rZXJuZWwtcnVsZXMuaHRtbA0KZm9yIGhv
dyB0byBkbyB0aGlzIHByb3Blcmx5Lg0KDQo8L2Zvcm1sZXR0ZXI+DQo=
