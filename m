Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12F784BABB7
	for <lists+stable@lfdr.de>; Thu, 17 Feb 2022 22:28:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236655AbiBQV2Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Feb 2022 16:28:25 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240851AbiBQV2Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Feb 2022 16:28:24 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2060.outbound.protection.outlook.com [40.107.93.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 943D483027
        for <stable@vger.kernel.org>; Thu, 17 Feb 2022 13:28:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=imYKvu23cd6FVByjp54m21T+Bm/2G+eIbZ5dnuOMWLjcA6boVYOtoqlrS5M3AQKzn5CbTiTk/L3oO140nAQHdG/r1VvB1HxZIvSTvHY5Vt9cp64RVam7t9jJ5rUuhL9MZE9TtCtym2VTpn4O/EZmSWOgO6jJqEjItelCgsa/7nCnZAZ6FJj5CuxNk0Oaqlt0YEBn6w06xQZ+PqReaML80f/8ykQoJI0uh20R7DlNiUORgluxGbDOo9pjRJU26p7cxUUc6vTunX0pwDNm8twuQhoCOUvXqX9jMtKHNCCkDeRKDUQSqjld9bF3ydldKNXHuyewdtta10NhXYR1H5XJLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wLTOkBolLa047hgHrdacxMRvsp8yFEDo9panHBo0axM=;
 b=e4WqYc5kSHDF3K6Erd+0Yf0JyCdOkpR6J38S9MPtOt5bgTtkDXJD0Ff5iS+Gpnf/bfmoAFTu1p7+Q5wXeF1faEDFn9DGtlZMF4r0OKc18+fGyowdsY+iQkYbJIiO5YNUFNgpkjl6vlt3WPSK1BQmYdA5yeDicUyunpIY0xoESUmU6GWRUt/tfDq33QlGbM0cAiWeVRVYxBvzilRDPikZdDCzhD+d9hrDbOfrVBD/6/C7cVUIKJLikrIx/G84+4S/z/aqoP3Ar+VjpcTxFFUQKtJT9A9IXC7RJ1y6iWzj2k+OcUT1BBthB0DD44lNIxDB5tEV5yolYSWSfqDZw8XLkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wLTOkBolLa047hgHrdacxMRvsp8yFEDo9panHBo0axM=;
 b=BP98DYrP1W+KQ9oSHU7f5HBCcNQjJeWEeqMdSOOzO5xmcFAM3tJkK/rC4sYblLXyopkgur402KND16weBXhMESZIzC0PBhrJUB0BSqIjeO5xJKFW9XIaOJMC+24m9ZpSeDSXUBOeH1OPeDfXMBvp4CmWdDBIv80zz40rUUEWzIg=
Received: from BY3PR05MB8531.namprd05.prod.outlook.com (2603:10b6:a03:3ce::6)
 by BN3PR05MB2482.namprd05.prod.outlook.com (2a01:111:e400:7bb8::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.9; Thu, 17 Feb
 2022 21:28:05 +0000
Received: from BY3PR05MB8531.namprd05.prod.outlook.com
 ([fe80::7856:d027:55:4db6]) by BY3PR05MB8531.namprd05.prod.outlook.com
 ([fe80::7856:d027:55:4db6%2]) with mapi id 15.20.5017.009; Thu, 17 Feb 2022
 21:28:05 +0000
From:   Nadav Amit <namit@vmware.com>
To:     Nadav Amit <nadav.amit@gmail.com>
CC:     Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] userfaultfd: mark uffd_wp regardless of VM_WRITE flag
Thread-Topic: [PATCH] userfaultfd: mark uffd_wp regardless of VM_WRITE flag
Thread-Index: AQHYJENwiN5z6WlHlk6dnL96VHXcPayYQfcA
Date:   Thu, 17 Feb 2022 21:28:05 +0000
Message-ID: <87B90777-1A53-47B7-B14E-0E2A297ACA89@vmware.com>
References: <20220217211602.2769-1-namit@vmware.com>
In-Reply-To: <20220217211602.2769-1-namit@vmware.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vmware.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 95976efb-b284-479c-dae5-08d9f25c62b0
x-ms-traffictypediagnostic: BN3PR05MB2482:EE_
x-ms-exchange-atpmessageproperties: SA|SL
x-microsoft-antispam-prvs: <BN3PR05MB2482F2FD18A705A0B67533DBD0369@BN3PR05MB2482.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: X17MYhpH/XvszFZPC4LCOobMn3U/+CIE2h3zMtFTXytua2ukB9rMiuGX9D0algWl1fcTOZEzD879aWOacfA6BUlRpE2JQcIysegian+RGO2GlOESJwjq2mDKhcfPeaacoM+acoV0fh525kl8DeZk3PARHVTseKkxQMBgU4smf66VM+S5zOiyezQ5RR0oBKdRB8twAKpT29wKCG+nXofXYxNHVYDlQNLtb88XV7RYaMUVBfxWA/6DlZvf+1vh5wVtNgQHgy20CQD4yTpT6VjXnT/dlmwQax7ci4Etucrdvp/P/APBkRZHbA0/vkSKvV06YnjKNTDQ1FGxg49jkmPg0e+juNn3pnBStUk9LwFHdmr5cW915vkzz5lS109d/pZDEStHV3BiRVfsxPxRszlt2fqvxaPNcZa/Q+QSlGwio9LFNIPLhiga3AqiN1ay9YZBdX2NDlH1xA7JlwVV3wMi1BOUBV6Wv7Ymd5omkZQgBtwqs0rz8w7WqMPNpmrVFYHZR6udg/jck86ro17kKwU+GEb0VM11bXUecY9GEkDpLo4iTK3Aor6Ma/OwzKxvWEDrNUCyERPGR5x0gjMCsTZTSUC8LpTDsDClEMb/QibqRBm9LCAbceQZsznUn+n48EuRrJ+ZAT9vN0zKmWXKfqJOIm9xpx0z+pNwLlrtUJ4phx/6Fkw0Q3Zoq75ckUOzySOR1PstqrJrtig4mNK56AcOZZjoXWAUKtgsm5bkcd7GVkkVYzQhKjOJBgbq3F/4idji3YeObnynfWqlBwgLQKhrhc99DtNGDSUAyf5BD1bf9tWFlXJ0zP/ES5xTUPh1H/vN
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR05MB8531.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38100700002)(83380400001)(38070700005)(316002)(122000001)(53546011)(6506007)(6512007)(6486002)(508600001)(71200400001)(54906003)(6916009)(186003)(2906002)(26005)(5660300002)(2616005)(86362001)(8936002)(76116006)(33656002)(8676002)(4326008)(66556008)(66476007)(64756008)(66946007)(66446008)(36756003)(26953001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Mmc5S2xGbHhPdzRpNmxhZmNoUUx5ZXpza3hnNGIzcFNia2l5QmM1YXFwZnFj?=
 =?utf-8?B?bEtaQ3NOMUFuWDZ5S0NkR0lRcWxXRkc2aitWQWlLeE5ObWdqY3BZWDc1c0Mx?=
 =?utf-8?B?Zk1FdnR2STZaZWVqUUFKSi80R1F4S2hhRXJnNlhWWDNIcVJZN0xnTnI2N29h?=
 =?utf-8?B?WXI0cWhkcWMzOGxab1lvSkpJUTFnWDRhN21HNzhxSUxtazZRSExLVXgvNkhu?=
 =?utf-8?B?NVhYTW0zbHBTMmR6ZHlBSlY1dGhUUFNTS29zdEM0dGpaVCtwMmxBQ0dSSWpZ?=
 =?utf-8?B?bFc2QVordFlhb00zaDMwcEVZWjZPc21yT1hEWXFTVWRQb05qMnNsRVJ2UkV4?=
 =?utf-8?B?Q0Q2bEhIeXJxRmZJUitOanZRRUVqWitCSU9GVUJpNjRPK0ZHR0NyZUdKZDNj?=
 =?utf-8?B?OERwNlZJM2krekRGeG5YNnl6UHZZa1h2NkZWTmo5OXNRNFR4MFB5VkhTUmdG?=
 =?utf-8?B?WEk3amNNRmZWd0xmSmdRcnEwWVMwYXBmVWdCVzFhS2FWSnMya2twcG1FVjFU?=
 =?utf-8?B?S2QzTFdjVW5BczREODB6N08zdjFvZXNSVGNuRWV2RVhWWkZ2aTJpSGIxME9j?=
 =?utf-8?B?UEt6NWh4ODRnUEpibjMwcHYrY2dJMzJzTUszUzNsMHVERlo3SG5pOWh6UFdM?=
 =?utf-8?B?cmVpQkd0cmF0Tzk1c0FYZmVwc0gycG4yRUYxKy9jN210WElPVWlteFZvRWo4?=
 =?utf-8?B?QU1oZlMwWWs4QlByTmhkWU11cTJDTW1ucitUREpOb2xEOGZwUWJrMWVwZHFO?=
 =?utf-8?B?RnNTQkxMdEtvQ2tRbEIrcGh3dDVZKzA2bVNkKzEyS0I1SFJLM05PVU1reXlH?=
 =?utf-8?B?U0U3MDE4SHVHMTZkbzMwYkxISG8zUGZHQTd2bXdWUStySlJrcEgrYXJWWExB?=
 =?utf-8?B?K0h4K2JyNjUvK0hpOE9hSjYyWkNwMUxOdE5ZU1UySHc1dWJxcENkcjd0cnox?=
 =?utf-8?B?WGNZWE5Oay9IU2taVUpjak5UOS9EWDV1V1k4OWlTVVJPQ0JjT2ZaZU9YRzFP?=
 =?utf-8?B?UW9HQnR2ZndqdXFOZU1pMlJnM1F5elJpeGI1dDlMUlR5VUJSVjF0MDQ4TjlB?=
 =?utf-8?B?emZZUTdWMW5Ka3RrUHJja3J5WVg2U29EYVdoVUxVR2ZoYUhJczh4dGVidlc0?=
 =?utf-8?B?R3RkbEdyalY2blVkS1htTS9LaG1JcTg5bzJqb1E3ZklkUGdHWjErSW1Xa0tM?=
 =?utf-8?B?VHhvMXlMZnpXc1BKdFlpVWhoLzZWM0FUdjlMNzNzdFRraDlSZTlMbzI2NVM1?=
 =?utf-8?B?Ui9zaEYySndhRWd0cnk5VjNwM2FLdVJLTlVmMlQ0bnBRZFprK0FNOVdqL3pj?=
 =?utf-8?B?UG8xS0UvOXpQSURDZEFnRUNJK1NkQ0k2L2c0K3pCSC9BMXJZTEZMMDZIVmdq?=
 =?utf-8?B?TG95S0pGOWNMUzBGRkhrYThWWXZySE9YaXJKckUxd0R1dXYyZzdid3VyNm1K?=
 =?utf-8?B?MGtFME50cjF5OExNak5LemlDSStaRWhGeEVSdjFQUnE4c2ovZFl3NFlnSGs4?=
 =?utf-8?B?QURxOXZJeS9uMUxCbzM5Tm5sajBRRm9EYWdDci9rZ1JlN3QwdEdvbk00UDcz?=
 =?utf-8?B?WkpCVTlIeXliNU50cm1LYUpwWGNHN3JHdUh3cUtUWlh2cWp0UENUUkVUdURB?=
 =?utf-8?B?ak1Sck1XUjRwWUFLVWk0NHRTNCtBUWp1aEZNR3JhRkNHK1AzTVNhU0lXSkR4?=
 =?utf-8?B?ZHNWTzNpZ1NFQ3B4MEZFOVdqOGt1bDlaR1VBeDI5MkFFRE85YW0xN2pJYkhw?=
 =?utf-8?B?ajEyTGUzSHNpdmFDbEhYYW0yQUgzSWVBYTgwQlNGT3pmcVJPNlZDNmQ4QVMw?=
 =?utf-8?B?RXJCZ3lSRS9oaWxPd1YrM053WGFpOGtjZXNKclhtZVRMRytmaWhMOC9xUTFp?=
 =?utf-8?B?WWNlbVc3czBnZERGZWJUeGRCcTQya1FxTDIwd3hvOWxaVms2NjU0T0s3MEIz?=
 =?utf-8?B?WFI3Zy8yd0Zaclp2UDJFSnA2QUxvSXgvSlVtWlArR0Z4S2dua1Y0bWZWeWZB?=
 =?utf-8?B?S1k4ZFlhK1Z0NHF5eFlTM0hvQU9tMzVUR0FOZXQ0OUZ3amhkUHEzWFA3WFFZ?=
 =?utf-8?B?Y1BOTmJoYkhGWE5DTTVTeHBpVklSQTcwNHJtblIzMm5NVDM4Y0RqNkQ3MFBK?=
 =?utf-8?B?N05kNDhmTEl5a3VtMGwwV0p0Nmx4dUpLaTNGeHUzenZTRDhNaEc2UXZxL0lh?=
 =?utf-8?Q?JLcCzjcP0AgaVPBUsE8/2Jc=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E3178946CC20A448BE7FFD89C31F4CAA@namprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY3PR05MB8531.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95976efb-b284-479c-dae5-08d9f25c62b0
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Feb 2022 21:28:05.5369
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qU37Zt2n6NmP1SlLEhSFTsEmSMyiBYC8Avb4I4XfgkRwurxE5uPnawUcxACeN3WmnoH/mv/PKnT6Ofkv4v6B6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN3PR05MB2482
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

DQoNCj4gT24gRmViIDE3LCAyMDIyLCBhdCAxOjE2IFBNLCBOYWRhdiBBbWl0IDxuYWRhdi5hbWl0
QGdtYWlsLmNvbT4gd3JvdGU6DQo+IA0KPiBGcm9tOiBOYWRhdiBBbWl0IDxuYW1pdEB2bXdhcmUu
Y29tPg0KPiANCj4gV2hlbiBhIFBURSBpcyBzZXQgYnkgVUZGRCBvcGVyYXRpb25zIHN1Y2ggYXMg
VUZGRElPX0NPUFksIHRoZSBQVEUgaXMNCj4gY3VycmVudGx5IG9ubHkgbWFya2VkIGFzIHdyaXRl
LXByb3RlY3RlZCBpZiB0aGUgVk1BIGhhcyBWTV9XUklURSBmbGFnDQo+IHNldC4gVGhpcyBzZWVt
cyBpbmNvcnJlY3Qgb3IgYXQgbGVhc3Qgd291bGQgYmUgdW5leHBlY3RlZCBieSB0aGUgdXNlcnMu
DQoNCk9uZSBtb3JlIG5vdGUgLSBpZiB5b3Ugd2FudCB5b3UgY2FuIHRyeSB0aGUgZm9sbG93aW5n
IHJlcHJvZHVjZXI6DQoNCiNkZWZpbmUgX0dOVV9TT1VSQ0UNCiNpbmNsdWRlIDxsaW51eC91c2Vy
ZmF1bHRmZC5oPg0KI2luY2x1ZGUgPGVycm5vLmg+DQojaW5jbHVkZSA8dW5pc3RkLmg+DQojaW5j
bHVkZSA8c3RkbGliLmg+DQojaW5jbHVkZSA8ZmNudGwuaD4NCiNpbmNsdWRlIDxwdGhyZWFkLmg+
DQojaW5jbHVkZSA8c3lzL21tYW4uaD4NCiNpbmNsdWRlIDxzeXMvc3lzY2FsbC5oPg0KI2luY2x1
ZGUgPHN5cy9pb2N0bC5oPg0KI2luY2x1ZGUgPHN5cy9tbWFuLmg+DQojaW5jbHVkZSA8c3lzL3R5
cGVzLmg+DQojaW5jbHVkZSA8c3RkaW8uaD4NCg0Kdm9sYXRpbGUgaW50IG9rOw0KDQpzdGF0aWMg
dm9pZCAqIGZhdWx0X2hhbmRsZXJfdGhyZWFkKHZvaWQgKmFyZykNCnsNCglzdHJ1Y3QgdWZmZF9t
c2cgbXNnID0gezB9Ow0KCWludCBucmVhZDsNCglpbnQgdWZmZCA9IChpbnQpKGxvbmcpYXJnOw0K
CXN0cnVjdCB1ZmZkaW9fd3JpdGVwcm90ZWN0IHVmZmRfd3AgPSB7MH07DQoNCglucmVhZCA9IHJl
YWQodWZmZCwgJm1zZywgc2l6ZW9mKG1zZykpOw0KCWlmIChucmVhZCA9PSAwKSB7DQoJCXByaW50
ZigiRU9GIG9uIHVzZXJmYXVsdGZkIVxuIik7DQoJCWV4aXQoRVhJVF9GQUlMVVJFKTsNCgl9DQoN
CglvayA9IDE7DQoNCgl1ZmZkX3dwLnJhbmdlLnN0YXJ0ID0gbXNnLmFyZy5wYWdlZmF1bHQuYWRk
cmVzcyAmIH4oNDA5NXVsbCk7DQoJdWZmZF93cC5yYW5nZS5sZW4gPSA0MDk2Ow0KDQoJaWYgKGlv
Y3RsKHVmZmQsIFVGRkRJT19XUklURVBST1RFQ1QsICZ1ZmZkX3dwKSA9PSAtMSkgew0KCQlwZXJy
b3IoInVmZmQtdy11bnByb3RlY3QiKTsNCgkJZXhpdChFWElUX0ZBSUxVUkUpOw0KCX0NCglyZXR1
cm4gTlVMTDsNCn0NCg0KY2hhciBwYWdlWzQwOTZdOw0KDQppbnQgbWFpbih2b2lkKQ0Kew0KCXN0
cnVjdCB1ZmZkaW9fYXBpIHVmZmRpb19hcGkgPSB7MH07DQoJc3RydWN0IHVmZmRpb19yZWdpc3Rl
ciB1ZmZkaW9fcmVnaXN0ZXIgPSB7MH07DQoJc3RydWN0IHVmZmRpb193cml0ZXByb3RlY3QgdWZm
ZGlvX3dwID0gezB9Ow0KCXN0cnVjdCB1ZmZkaW9fY29weSB1ZmZkaW9fY29weSA9IHswfTsNCgl2
b2xhdGlsZSBjaGFyICpwYzsNCglwdGhyZWFkX3QgdGhyOw0KCWludCBlcnI7DQoJaW50IHVmZmQ7
DQoJdm9pZCAqcDsNCg0KCXVmZmQgPSBzeXNjYWxsKF9fTlJfdXNlcmZhdWx0ZmQsIE9fQ0xPRVhF
QyB8IE9fTk9OQkxPQ0spOw0KCWlmICh1ZmZkID09IC0xKSB7DQoJCXBlcnJvcigidXNlcmZhdWx0
ZmQiKTsNCgkJZXhpdCgtMSk7DQoJfQ0KDQoJdWZmZGlvX2FwaS5hcGkgPSBVRkZEX0FQSTsNCgl1
ZmZkaW9fYXBpLmZlYXR1cmVzID0gVUZGRF9GRUFUVVJFX1BBR0VGQVVMVF9GTEFHX1dQOw0KCWlm
IChpb2N0bCh1ZmZkLCBVRkZESU9fQVBJLCAmdWZmZGlvX2FwaSkgPT0gLTEpIHsNCgkJcGVycm9y
KCJhcGkiKTsNCgkJZXhpdChFWElUX0ZBSUxVUkUpOw0KCX0NCg0KCXAgPSBtbWFwKE5VTEwsIDQw
OTYsIFBST1RfUkVBRCwgTUFQX1BSSVZBVEUgfCBNQVBfQU5PTllNT1VTLCAtMSwgMCk7DQoNCglp
ZiAocCA9PSBNQVBfRkFJTEVEKSB7DQoJCXBlcnJvcigibW1hcCIpOw0KCQlleGl0KEVYSVRfRkFJ
TFVSRSk7DQoJfQ0KDQoJdWZmZGlvX3JlZ2lzdGVyLnJhbmdlLnN0YXJ0ID0gKHVuc2lnbmVkIGxv
bmcpcDsNCgl1ZmZkaW9fcmVnaXN0ZXIucmFuZ2UubGVuID0gNDA5NjsNCgl1ZmZkaW9fcmVnaXN0
ZXIubW9kZSA9IFVGRkRJT19SRUdJU1RFUl9NT0RFX01JU1NJTkd8VUZGRElPX1JFR0lTVEVSX01P
REVfV1A7DQoJaWYgKGlvY3RsKHVmZmQsIFVGRkRJT19SRUdJU1RFUiwgJnVmZmRpb19yZWdpc3Rl
cikgPT0gLTEpIHsNCgkJcGVycm9yKCJyZWdpc3RlciIpOw0KCQlleGl0KEVYSVRfRkFJTFVSRSk7
DQoJfQ0KDQoJdWZmZGlvX2NvcHkuc3JjID0gKHVuc2lnbmVkIGxvbmcpcGFnZTsNCgl1ZmZkaW9f
Y29weS5kc3QgPSAodW5zaWduZWQgbG9uZylwOw0KCXVmZmRpb19jb3B5LmxlbiA9IDQwOTY7DQoJ
dWZmZGlvX2NvcHkubW9kZSA9IFVGRkRJT19DT1BZX01PREVfV1A7DQoJdWZmZGlvX2NvcHkuY29w
eSA9IDA7DQoJaWYgKGlvY3RsKHVmZmQsIFVGRkRJT19DT1BZLCAmdWZmZGlvX2NvcHkpID09IC0x
KSB7DQoJCXBlcnJvcigidWZmZC1jb3B5Iik7DQoJCWV4aXQoRVhJVF9GQUlMVVJFKTsNCgl9DQoN
CgllcnIgPSBwdGhyZWFkX2NyZWF0ZSgmdGhyLCBOVUxMLCBmYXVsdF9oYW5kbGVyX3RocmVhZCwg
KHZvaWQgKikobG9uZyl1ZmZkKTsNCglpZiAoZXJyICE9IDApIHsNCgkJZXhpdChFWElUX0ZBSUxV
UkUpOw0KCX0NCg0KCWlmIChtcHJvdGVjdChwLCA0MDk2LCBQUk9UX1JFQUR8UFJPVF9XUklURSkg
PCAwKSB7DQoJCXBlcnJvcigibXByb3RlY3QoUFJPVF9SRUFEfFBST1RfV1JJVEUpIik7DQoJCWV4
aXQoRVhJVF9GQUlMVVJFKTsNCgl9DQoNCglwYyA9ICh2b2xhdGlsZSBjaGFyICopcDsNCgkqcGMg
PSAxOw0KCXByaW50ZigiJXNcbiIsIG9rID8gIm9rIiA6ICJmYWlsZWTigJ0pOw0KCXJldHVybiAw
Ow0KfQ==
