Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 794C252ED21
	for <lists+stable@lfdr.de>; Fri, 20 May 2022 15:32:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231362AbiETNcI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 May 2022 09:32:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229750AbiETNcH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 May 2022 09:32:07 -0400
X-Greylist: delayed 304 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 20 May 2022 06:32:05 PDT
Received: from de-smtp-delivery-63.mimecast.com (de-smtp-delivery-63.mimecast.com [194.104.111.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6422F606CE
        for <stable@vger.kernel.org>; Fri, 20 May 2022 06:32:05 -0700 (PDT)
Received: from CHE01-GV0-obe.outbound.protection.outlook.com
 (mail-gv0che01lp2045.outbound.protection.outlook.com [104.47.22.45]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-31-sCMJq1I-Otiqy6PPOd2VIA-2; Fri, 20 May 2022 15:25:31 +0200
X-MC-Unique: sCMJq1I-Otiqy6PPOd2VIA-2
Received: from ZR0P278MB0377.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:34::14)
 by GV0P278MB0387.CHEP278.PROD.OUTLOOK.COM (2603:10a6:710:35::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.14; Fri, 20 May
 2022 13:25:29 +0000
Received: from ZR0P278MB0377.CHEP278.PROD.OUTLOOK.COM
 ([fe80::9cce:1929:39d3:3ce1]) by ZR0P278MB0377.CHEP278.PROD.OUTLOOK.COM
 ([fe80::9cce:1929:39d3:3ce1%4]) with mapi id 15.20.5273.017; Fri, 20 May 2022
 13:25:29 +0000
From:   Philippe Schenker <philippe.schenker@toradex.com>
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     "peng.fan@nxp.com" <peng.fan@nxp.com>,
        "abel.vesa@nxp.com" <abel.vesa@nxp.com>,
        Francesco Dolcini <francesco.dolcini@toradex.com>
Subject: Broken Audio on Stable Kernels for i.MX 7 based Boards
Thread-Topic: Broken Audio on Stable Kernels for i.MX 7 based Boards
Thread-Index: AQHYbE0SBG2S+k3NR0GyJDokGf1iNA==
Date:   Fri, 20 May 2022 13:25:29 +0000
Message-ID: <536ad55a36d88364299f22782f7c12a6c70c5c11.camel@toradex.com>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 05ab2e79-183c-4545-5ede-08da3a64355b
x-ms-traffictypediagnostic: GV0P278MB0387:EE_
x-microsoft-antispam-prvs: <GV0P278MB0387B0BE31975B051FF3E405F4D39@GV0P278MB0387.CHEP278.PROD.OUTLOOK.COM>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: eLaWsdSl1a1TbOMoj6bNGYv1zaIWmTi5XN7rLVJ9gcEEwrtmrzBhewXeRHpf3wwNLjXk3pfT328/GxfOJoxLC2j7gdWXsSk2hqamdxNdLxPYMJuInGKkL/oZR+1kdMwaPJMqj2twy0s2bQZUnnW4jfhp/k0PLOtWq+3J0ZvvIfMzqOBa0LuML2gNXyYPDw/e7yT6ERgrrctavPHsHmVuXlkfBcUPFsQNIBT6CAi+nwcmEcwQ9/r9gAL9IW9jMo25AK1CifNRXg+zamqswHENHNETIAHEmir9914Y3e/Cqyv1qY4fDB0bL0gxnX790FPMwcPC+1GLJnllgbVOWQTB5VUv8IEwb/rnc+yvy++pNsDkSTqg6UriiD9e7M/upVtKujVONurLMrzNPxxg4DmdWondpKYoo1pc7NkUzWJJWErEWmIdEVikW/selJ3B+AAMgI5ZVMxDah6mYA1dfy011eeAG/FBcu9U6jv9EPIMOxUPtlCqtyvr7Dlu5nkdscUfalryFmFs8Qx6BZvpHyVmbDQw05SCkzSFt3WzynKq2mcdxThatSzYCZohao5STZH+kSuNBsdD2SMJvIWOZfti/Whqmsz9E0tk0aK80RFGKGNv3yF+8YHcPAXQyIczLwIndq1/LXArO7UKwxWG1LOfKidclOzhTZKGvPWNKROHwniGVuHBgNSW2/r9jnWh5EINSXdz/ftG6zGnKT76SXEZRCKWIo+3n6HEneuNXUGK1VUC9HtU/gqDP40vh5O2OOmAud6ykiX5cQnJSnQGyz6daL4MF/WMRAvVkn4c5a3Pjpg7osOcHCQVMD/kvLPLC6RpWfQfI/CVMx0Fs1AU6ctl2g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZR0P278MB0377.CHEP278.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(76116006)(66476007)(71200400001)(966005)(4326008)(64756008)(8676002)(66946007)(186003)(5660300002)(6486002)(66556008)(2906002)(8936002)(508600001)(66446008)(83380400001)(4744005)(122000001)(86362001)(2616005)(26005)(6512007)(110136005)(38070700005)(38100700002)(54906003)(44832011)(36756003)(316002)(6506007)(107886003);DIR:OUT;SFP:1102
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QWhhM2JrRmRVWkZ4czB3a0RVd01CQkhtZ2tyMXVXNWc4a3AveVg2UStjdnJL?=
 =?utf-8?B?WXpSLzZsNEUzdW5yWExPbjdKTjVzMU9GL3h3RE1OdkNrYmdkMHU5S09GaWNR?=
 =?utf-8?B?RzZnK05WSHpFeUJleThvbm5OTW5pa045WFd3aWRsazE1MjREV0xzai9oa2kr?=
 =?utf-8?B?bE91QUlsZ2ZvYndaMXM0OXBjR3A2QndXWmlNMStscXNtVlJaK2dDMEtxQ1Rk?=
 =?utf-8?B?VTVCTHl1SCtaSDlJT212RzNUWWE1dFZCczVDSmNHTUZ5TkExWmRmd2FVb01p?=
 =?utf-8?B?M0FObXNGRnpIZDlORVF5UFBvaG1YTWVycWVOMFpzUmhnUm9LY01vZWtTS0l4?=
 =?utf-8?B?Y012ZWdQR2tQQ1NaTEdTUjlWU0F6L1RLaXNvTk5NeUsyQVJQelJRb29zYjRB?=
 =?utf-8?B?STdsUEtBWUNOaG41MVZaZnhUR0kzNXVSSE5wUVY4TkRFUjl1SWNBbFVnQlI1?=
 =?utf-8?B?a1EvNk1GZlBKNlJ3YlN3YmFBRGNTNGdLV2xuc0hVNGMrRnlLQWxPNkIzK3Na?=
 =?utf-8?B?SmtqNHpWSWxLSDJjaDFVMU94SVJwMkU2dEs2K3FkY29WcjJvVUNudmVVUTZv?=
 =?utf-8?B?bTBSS0E2TStvQk5PTFFKWXZyVGJoODdYRWFsMDAvT2x6MkFmZXRVUzZzV0wr?=
 =?utf-8?B?MWxmTkkrOFJEcVc5QW14a3k0VmRwenFGVURseXdRSFJORnpmTVAxOTJIWG5L?=
 =?utf-8?B?WHBBRkV6OThiWXZqZTJGMjdtN2FwVHZHUll4RUNuYmhlS0d0ZURjVzBKbXps?=
 =?utf-8?B?ZlhvZEVTWDhtZGR3YktWMjJTWXZBYlV4UlovZzE5NW9sa1lEM0hmMjlKQ1h1?=
 =?utf-8?B?RHROcHlGS1VwMzc3UFNMdWlRNUlXN0srNFR5b09STk1YM1BoMTRIWXpWc0Ez?=
 =?utf-8?B?ODVoM3JmUFpCdG1ZcWo2emhoMWVVeGp2UzJiay9jekFLT1VIZjlZeW8xS0Q2?=
 =?utf-8?B?Q3BadHRwSmMzS3lMNlp1c29RamFwN3ZESVEzUy9UUk1tNkdvZDRVMktSV3Y5?=
 =?utf-8?B?OWpoWXd5c21rZmwyeVJwRFZ5R09tMjZoakIvT20rUzRkOVYzeVgxUzJrWnFz?=
 =?utf-8?B?NThFalFhazNYaUFXUFlBYmp6aGdMeGpUVldoZTN0SzZZS2IzOVZpUUZub3Zh?=
 =?utf-8?B?REtFbW0velN6VjduR2lBSU90d0ZsakdqT3FhNmhxWG5nbW9HMU43NjBucWwr?=
 =?utf-8?B?RVJob1JrSmVHV0tRTWxaUTQxeDdZT0krLzdlcWdNMmRGeVVwUWVPSDk0TnQy?=
 =?utf-8?B?cm1udlJjVFJYSDZweUlvelVGTy9CS2d3OThjN3hGYjJFa3JrdGdBdGd3L0hp?=
 =?utf-8?B?VUFkYU9OakhtNGtJL1RSbzJvSXJIM3VtZ1EybVdWVVhWU2xoMS84M2tSSG5M?=
 =?utf-8?B?bzZWbHREbXo2Tmlmb0c5TnU5aW5tSnJWYklic0JFRFdXVlZ1U1BHNFFQQ2NB?=
 =?utf-8?B?WkNya09XYVdncGVaakVLR0JnbVY4SFE2QVpOOFcwUGZzdGhwUk1DRDZMditL?=
 =?utf-8?B?N2w5ZnN0c2QwTTA1MjBvaUNQUUdKUjBBUG1FZVBUenBxdE15b05JNWRYbVZP?=
 =?utf-8?B?ZlErRjU0Tk1PM2xjbWdRS1RSb1ZvbWhndXFMTjJrMmQ1RUR6SU5jTlBXWGE1?=
 =?utf-8?B?VTlDV3VraVcvVVlHRWFxUlR2ZHdOUUNiYjZTZkJKQ3dscmRwQWV0cXE1NFRz?=
 =?utf-8?B?OHhKcTc0aEtaQmVYRlBoemxteitSdlRSUS9kNThIWHlXVzdVMXJUZVI0SFFG?=
 =?utf-8?B?SHZRbHpCdWVDUDNEVSt5R3ZaRm5tb3Nnci9JcmRpMmN3K0t3YzNoNnlrb1BO?=
 =?utf-8?B?SG1IMHFuWi9xVXdzQjhxSlc0TTBlSjdaczEwRndOb0lwNTNTZWEySEdRdlF5?=
 =?utf-8?B?Ykp1Qk96eHdZWXp4c2kvd3lBVWx6MkdKcjZ5VGxWdlgvSWRzSVhoYzIyMG5T?=
 =?utf-8?B?cjgwNVFGOUgvS0F0b1VtekNpbFpzNkFUaFhtSWEyNTNzOEdTMGZqTWh6Y2Vr?=
 =?utf-8?B?bTV2b3RjZDRPazVTS1FDS2NGc2hnR0NFc3lvaXZJVWhOVlR0YkZQYmkvQXhr?=
 =?utf-8?B?U095NWRYc1J3Q0F1TVhNUVpkd0N5ZzhlKy9iU1paZ2oySFBCVzkyWGJKbTdi?=
 =?utf-8?B?ZjF5WElhT0Y4eGkvbzdjREdYUHNHQ05EOGZuTXlNOWpKU3M2RncvZUZBSFNZ?=
 =?utf-8?B?MWJjM1ljdjJjYlNTTTMyR29LVE81VTB2YnlTTU15VFRDS0toSjF1QUxTbEt3?=
 =?utf-8?B?WlprZ1lydWp6UUErTjhnNjRnR2pMdW13R3U3bUxGdmVzR0htb2tYOEg4Rmhx?=
 =?utf-8?B?aVNjWU1mcjBXUy9qRE1XTllMOFZBZUQ5T24rTXl2emZ3aXJXTVRzenN0eWN5?=
 =?utf-8?Q?F2Ol1Ow4Pvmk0V1U+3IDJ20dUNDYUymDyyje4?=
MIME-Version: 1.0
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: ZR0P278MB0377.CHEP278.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 05ab2e79-183c-4545-5ede-08da3a64355b
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 May 2022 13:25:29.2042
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d9995866-0d9b-4251-8315-093f062abab4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: L1eev3m69Ii0qt9hSKjVd9YW0IhMXrodbLyt2Q2JdbBs71i3ISbiR3MnObVXXsccXqVu3vaqNsh6+0l7gVNmhPZ0wZFGIc2YLGFzH4he5Xo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV0P278MB0387
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: toradex.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-ID: <0448699D7AAB164D856D1DAAC60001FE@CHEP278.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGVsbG8NCg0KSSBub3RpY2VkIHRvZGF5LCB0aGF0IGNvbW1pdCBlY2NhYzc3ZWRlMzk0ICgiY2xr
OiBpbXg3ZDogUmVtb3ZlDQphdWRpb19tY2xrX3Jvb3RfY2xrIikgd2FzIGJhY2twb3J0ZWQgdG8g
c3RhYmxlIGtlcm5lbHMuIFRoaXMgY29tbWl0IGJ5DQppdHNlbGYgZG9lcyBicmVhayBhdWRpbyBm
dW5jdGlvbmFsaXR5IG9uIGkuTVggNyBiYXNlZCBib2FyZHMuIFsxXQ0KDQpGb3IgdGhpcyB0byB3
b3JrIGNvbW1pdCA0Y2I3ZGY2NGM3MyAoIkFSTTogZHRzOiBpbXg3OiBVc2UNCmF1ZGlvX21jbGtf
cG9zdF9kaXYgaW5zdGVhZCBhdWRpb19tY2xrX3Jvb3RfY2xrIikgaXMgYWxzbyBuZWVkZWQgYnV0
IGlzDQpsYWNraW5nIGEgRml4ZXM6IHRhZywgaGVuY2UgaXQgaXMgbWlzc2luZyBpbiBzdGFibGUg
a2VybmVscy4gWzJdDQoNCkkgbm90aWNlZCB0aGlzIHdoaWxlIG1lcmdpbmcgc3RhYmxlLXBhdGNo
ZXMgaW50byBvdXIgZG93bnN0cmVhbS0NCmJyYW5jaGVzLg0KDQpAQWJlbCBjYW4geW91IGNvbmZp
cm0gbXkgZmluZGluZz8NCkBHcmVnIGNvdWxkIHlvdSBwdWxsIHBhdGNoIFsyXSBpbnRvIGtlcm5l
bHMgd2hlcmUgWzFdIGdvdCBtZXJnZWQ/IA0KDQpUaGFua3MsDQpQaGlsaXBwZQ0KDQoNClsxXQ0K
aHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYWxsLzIwMjIwMTI3MTQxMDUyLjE5MDAxNzQtMi1hYmVs
LnZlc2FAbnhwLmNvbS8NClsyXQ0KaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYWxsLzIwMjIwMTI3
MTQxMDUyLjE5MDAxNzQtMS1hYmVsLnZlc2FAbnhwLmNvbS8NCg==

