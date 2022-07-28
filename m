Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 365DA5845B3
	for <lists+stable@lfdr.de>; Thu, 28 Jul 2022 20:25:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230393AbiG1SPO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jul 2022 14:15:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbiG1SPN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Jul 2022 14:15:13 -0400
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10063.outbound.protection.outlook.com [40.107.1.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A22B1FC1;
        Thu, 28 Jul 2022 11:15:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M/D4ptppjU1iCjQo1WQ5Ey7m51qcwx4EiePEbx5K0rL2kWeDGPLVA4WSJqlDHhFzjufGHq53dRGPkCnHjuTbPSNC0VddfP/FQk5duVRxTNObGHYgqFKapfmrZs2KWH0WNPfNh2bwn65spNqYx6Ufb+nEXcvwxKQZAKurG5ixXbv1P7mQwCKYsI5b+NzXLybuBZjqt1TjTz+kShfAm77uTWSm1ugXIah+jdHf34OCWTGBWmgnqPtBWTj016tpkHt+AU57NFL6ioLOW/OpRo1xbzXdr5GztXaDM/VO5B1KRourzHmMT3g3DMk0cwWyLJbyW61Q84zvHiCMGnh/XT9F3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BG7fa3gDLjCibCXF/K3zVa7z1RUoE7FVqynzrryX5BM=;
 b=FEpdjGWOu2L4k/V5sw4dvxqCG0N6KfRvKqa3dbAlXYLuxm3if0+bcyAiIGIbNOUk5e2BcwPhskMAWzm9klT8rXlw65KLCGzK7kCw1ifh6UYufmsfhr8mA0E1AHO2i7pLMex5Wan05zlho70ynM8XXUP92Tlm0L4nHOyEsQTeILBQr0H0oA4WsE2r/2bh1LHdsX9IvPsalP0CwpYbQCjEOUYDOdmFtR4MSKsZgWWoYLdM+hHEqBfD3QMW+v1c7P77udQyuDAUBlI98BKkhxw21KoKQk6uKo6QoJYL0raFX1NElJoEZP5xXlOgt96FOjbCDjg9o/RPFMTyWRsmdponzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BG7fa3gDLjCibCXF/K3zVa7z1RUoE7FVqynzrryX5BM=;
 b=NYtfypr+UEzLsnQWvM2laMMbUoaru7M7J6uLiTs7/AvGf3zS3y1uc/9OuFsbYo8WALaZzGje7nU2DRnoEYvkruDIPwxM7+W0RjCD2w5JRv3MOyPuYY+jktinKh0ayMbRnoSB4ziXBEa5UncXNv5LLfsZPW8HuOozP4iWkjSa/6o=
Received: from AM9PR04MB8274.eurprd04.prod.outlook.com (2603:10a6:20b:3e8::23)
 by DBBPR04MB6107.eurprd04.prod.outlook.com (2603:10a6:10:cf::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.25; Thu, 28 Jul
 2022 18:15:09 +0000
Received: from AM9PR04MB8274.eurprd04.prod.outlook.com
 ([fe80::f46c:5b09:72eb:638c]) by AM9PR04MB8274.eurprd04.prod.outlook.com
 ([fe80::f46c:5b09:72eb:638c%4]) with mapi id 15.20.5458.025; Thu, 28 Jul 2022
 18:15:09 +0000
From:   Shenwei Wang <shenwei.wang@nxp.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [EXT] Re: [PATCH V2 1/1] serial: fsl_lpuart: zero out parity bit
 in CS7 mode
Thread-Topic: [EXT] Re: [PATCH V2 1/1] serial: fsl_lpuart: zero out parity bit
 in CS7 mode
Thread-Index: AQHYl7Pc5ouTsV2p6EuL4SD+9s88e62TineAgAChE3A=
Date:   Thu, 28 Jul 2022 18:15:09 +0000
Message-ID: <AM9PR04MB8274C49685CC127AE48FB3DD89969@AM9PR04MB8274.eurprd04.prod.outlook.com>
References: <20220714185858.615373-1-shenwei.wang@nxp.com>
 <YuJKObb/XQJ4woBK@kroah.com>
In-Reply-To: <YuJKObb/XQJ4woBK@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ca221f65-39bc-45b3-ea1e-08da70c51b57
x-ms-traffictypediagnostic: DBBPR04MB6107:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 98foNUa87/WAVk5btVlBVswKsOdAh7F+7uOQR2JsE8zMGiZtED5aES7nsO8FnYzW+zLZiby4d1fag+fDAR0sMsERHATgQXOt3WMCgbWpvu5dyXq0GKvfMxgelgl6RVru+0/gJt4uMFTLWM68hMGVvwmhO+dvX7raTHRjFcweLKiaR6a0v8k+h4qnaoEdxLrISDgX+wX+iKOe3iOD9x4h19mfZwCXeqv2EKWiRSua7R+WknOIa7hDVya61siaLp7OaHeOR9uyhLo+VsuPt+xq+zaU4776LdszaJIak9erzU2RM782lFTihb+BcegS42SxZOik47TMDIy62B81D4p0j1S2gwdW6uUo97VU0LekGa0jzjZBXUcAe8NRtIndB2RQO51nxAP7dUJrqKTu+par/nT9EdI6TYP/tVbo05fBuSeNSsjIQsJRnA/ToAh2TP+hvhOmPaY38TrzRo+pdM2LPlF2jgEtwAQqtfu96/6+PeqpBTWbgnxLKQQtD5PczIILtZUvaWC/JGUdC49BLe+pVH4BWLXVmxJSzCP+Z+xVeardZHm51rYgH0c1E86jC14sqLX7FqglS+jLikCrarCPQUDq8Nq+2pSL9ZZefz3QpyS1vMyW5y418LZb2MfdayotAc++kXfEPwxlhbTXKGRC897muptwQ8d3ZIMSZQh6+zq0Onp9Udhm+r3QlgfQzRvzunqlK3PAeFYoUoJaLhf6N3W9R252ZP9FdV0FHC65Wr0YXCtDwBKfX3BY8ZUQ1w/iSGy3sjQR4YD9JWZ/u70vtcoGR78y76nduI4zjtO6Dk4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8274.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(376002)(396003)(366004)(346002)(39860400002)(186003)(54906003)(2906002)(41300700001)(53546011)(6506007)(83380400001)(7696005)(26005)(33656002)(122000001)(55236004)(38100700002)(38070700005)(6916009)(9686003)(8676002)(76116006)(55016003)(52536014)(66476007)(86362001)(66556008)(5660300002)(478600001)(19627235002)(8936002)(44832011)(66946007)(66446008)(71200400001)(4326008)(64756008)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?c3UvMXlmT3FTVXZUY21YVWJpNFd4OG1HNEVRc2l3c3lhd3FUZ3hVZDMxNlhV?=
 =?utf-8?B?bk1RMkpMY3J6NGY2bDBqbWw1YmlpMFBvUm1aRWZvclZTcHlBUjV1NThFcnZK?=
 =?utf-8?B?bHBmb1YybFR5NG5RRVEwVC9rNEZVSzFlVjM3Y1U3Q2JPVWhNSGJ2dWdaK040?=
 =?utf-8?B?TGZaNGxwZk1GUnZsRmxnNkNUQTFKMDZNcDhmaW5RMkRqdGE3VUE5Zjd0OG10?=
 =?utf-8?B?N3k3RUFZL0VZNWZObnhoQk9udHFlOG5FZjMvVUNSQWlUblVDdndFRXFHQzd3?=
 =?utf-8?B?amNmeW93cjUwZnl6RzF5Q09lMFN2bVc1NHVSQmlFRjBzanNOV3YrQ3B6NU1U?=
 =?utf-8?B?bWEwUHQzb1o4cjhuSXVScktBS3F5ZVlUOWlLUkRWZmd1d2JFa21FRjVIVG9T?=
 =?utf-8?B?T0xsQmp6dTdiL05TSVpxaUNRZS9yYzRublBYc3plaXVRRGczdWlQVW1RODlx?=
 =?utf-8?B?QlprcHAzVUdiZWhKbm1wM0JSci9xTlU4V3A0S2NqQk9meHVvTlRFd3M4blZ3?=
 =?utf-8?B?RERiQU1Udit0UUNBaEV6SFM2V0RwZGdqcUVDYkRHam1XVjJLNVoxbFk0NTBL?=
 =?utf-8?B?ODN3ZkJ1YnhHcmdQaHRic1VGOWQ1ZU1RV3JicS83OU9tTlJzcVhOSG03bHNn?=
 =?utf-8?B?U3hKV2J5M3NXZnRiUGdaNm0yUkFtbW9KRDRxYVNPNHFtUDRpMG1ZU2czWkNN?=
 =?utf-8?B?bkFFcUlhaEhGcGptYnkyL0wzKzNvR3MyekNpUFJLWFFkYTJpVEp5RFJQMzFV?=
 =?utf-8?B?c0FlQmVNemdLN3hJOTBxSEdKbGhMVTAzTWpJdlRDalFmUXhRajlzdERQWG1R?=
 =?utf-8?B?T3c4eld3RkxXUFBZWml4RGpNVTBqYlFGQTJIWm1WblhubGE1RzNxMVpncUVE?=
 =?utf-8?B?ZGh6Q2l1eW5lNFRqMURWUlYzRyt0cFF3OVpxcTNURzAyb2Zsemd2N2dXcnFx?=
 =?utf-8?B?TXlIOFpxcUd5Z2crSVBVSEhkMTlhRE8vckQ3VE41dzNjdlpMeDVsTU54WTFp?=
 =?utf-8?B?S0JvVVk2NTB4amlUdWFWamFtWEdVREtFZVl3NU1MZGlDdHhoMDFxWXRldHl3?=
 =?utf-8?B?Z29yYzJZNlFjajhFWHYvenQ2ZnQ4MUxpNEJVdUR5V1BYN1VaREFmVVNuK0gx?=
 =?utf-8?B?T0RxWExJQVlQY243UVM2dlBIdXpFYTNiSXVtTG1yS3ZIbkpWZk9nTmZwckht?=
 =?utf-8?B?M2p4L0JrSE1EVjBlUFdDYUgwcWhEQkN3dk5rRVVXL3RGVFlmZG1YK0NJblhr?=
 =?utf-8?B?bVk1eVBQTzM5SThydkZNSnZENTNsVlJsQmRUOXE2THRjaWM2RWt5dWZpdzY1?=
 =?utf-8?B?Rk4wa0ZsaGJ1OE10c3YxdjBSc3FrK2JyUEk5ZFRXWFJ2Zld5RzJqS2c0NXdO?=
 =?utf-8?B?c0ZZdFFGNlA0S253dTBMdEFvNG53Z2dkRlRvY1lRU0Z4RG5zcER2ZU5IcDBZ?=
 =?utf-8?B?U1JYSVZnWFNVT2dxZGdtWk9wY2xyRUVibG9sTTBNTG56UHNLR1hmMkRvOUV6?=
 =?utf-8?B?NlAzMC9sOFlaeFgwNUkzUlAyc20yQXdnTzRJTFNicldxbVpvOHo5YmRNQ3l0?=
 =?utf-8?B?aXViVVV0cjdZL2wvQ0t2VFkvK1NzOGFDdlZHQjczbmVVMmtzWVIvdDZyMGto?=
 =?utf-8?B?VUlqcUJuaWIySEVBcnU3STM1Nlg0Z3FGbGQ3N1EvbmY2TVdnM24vdElPRHd2?=
 =?utf-8?B?d2xRdzVGQzV1ZUE4Qmt4M0phRlpTOWNnWmF1NE9QME9tQ0NCcG5BQThxVC8z?=
 =?utf-8?B?MDYrYlQrUmxoQ2N1WEhFT1ZHQ1czSkdUd2p1OTlwZC9qd2Izc1hGbER4bkFs?=
 =?utf-8?B?TnM0eE1rRVFwbnpJZVg3SEgrUmk0bkplMkhFS3dOM1NFQkQyV0xpcFUvUkt4?=
 =?utf-8?B?ekVHbWM0VGJUKzNOWUZWMTBMREpoOFdZMWNENEN0RHFJeWRMRUxoY3VaTG5V?=
 =?utf-8?B?dVpGQlhlekdaWUI4Slg2NDZzbk9zUkFzMytLT0VjTTZWbnEvMGZ4a0dpY2RX?=
 =?utf-8?B?SjQ4RmtLZVFmQmlBaXpERERXZEp3ZXk3bXViT0Z6RGtCRkFNdEJhMmMzVFh1?=
 =?utf-8?B?cWVNc3lGd3lvYkgrTndNRTV0bjRadlZhMmpUcmJZSWNUYTJZYW1RYW5xcVdL?=
 =?utf-8?Q?tVJeeTqcO0GUR7LA0wxqoyMMv?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8274.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca221f65-39bc-45b3-ea1e-08da70c51b57
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jul 2022 18:15:09.5804
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZHvsEo6lKWUiNj3f+NNUSxWDaAe1RyD1OfXHhPho7qkMQ4v6IoxclMlMhaEONqzOfRSjilIsE4j0rRqNrnxX6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB6107
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGkgR3JlZywNCg0KSSB0cmllZCB0byBzZW5kIGFuIGVtYWlsIGFnYWluIHRvIGNoZWNrIHRoaXMg
REtJTSBiYWRzaWcgaXNzdWUsIGJ1dCBldmVyeXRoaW5nIGxvb2tlZCBmaW5lIGhlcmUuIENhbiB5
b3UgcGxlYXNlIGxldCBtZSBrbm93IGhvdyB5b3UgdmFsaWRhdGVkIHRoZSBzaWduYXR1cmU/IFRo
ZSBmb2xsb3dpbmcgaXMgbXkgREtJTSB2YWxpZGF0aW5nIGluZm86DQoNCi0tLS0NCkRLSU0gSW5m
b3JtYXRpb246DQpES0lNIFNpZ25hdHVyZQ0KDQpNZXNzYWdlIGNvbnRhaW5zIHRoaXMgREtJTSBT
aWduYXR1cmU6DQpES0lNLVNpZ25hdHVyZTogdj0xOyBhPXJzYS1zaGEyNTY7IGM9cmVsYXhlZC9y
ZWxheGVkOyBkPW54cC5jb207IHM9c2VsZWN0b3IyOw0KIGg9RnJvbTpEYXRlOlN1YmplY3Q6TWVz
c2FnZS1JRDpDb250ZW50LVR5cGU6TUlNRS1WZXJzaW9uOlgtTVMtRXhjaGFuZ2UtU2VuZGVyQURD
aGVjazsNCiBiaD1IWTJwQzV4cWFPTG1FNjg5S0FabktsMzBKM1RuTE9OT3FMWXhNNHkwOHIwPTsN
CiBiPU03cXhVQVd0RG93VnpQWnMwZVRUZHJTdGozYm85RER4TzNyc3hoQmlDR3MxUE1Bakd2MUpH
T3dFenovVVEvcWdRMTRPK2w2T1h5YkpvanJwbWgxelZvcGhVcGhUVnkyc05hVzVvSzVzNW9VMVpY
ZU1UdTBqdG0zYWpQSVJQbFRSVjhKZXlWMFJxOHFnUGRoQTU5R3FiLzFVWWhXMEFxNWdPMEltalZ3
ajJGYz0NCg0KDQpTaWduYXR1cmUgSW5mb3JtYXRpb246DQp2PSBWZXJzaW9uOiAgICAgICAgIDEN
CmE9IEFsZ29yaXRobTogICAgICAgcnNhLXNoYTI1Ng0KYz0gTWV0aG9kOiAgICAgICAgICByZWxh
eGVkL3JlbGF4ZWQNCmQ9IERvbWFpbjogICAgICAgICAgbnhwLmNvbQ0Kcz0gU2VsZWN0b3I6ICAg
ICAgICBzZWxlY3RvcjINCnE9IFByb3RvY29sOiAgICAgICAgDQpiaD0gICAgICAgICAgICAgICAg
IEhZMnBDNXhxYU9MbUU2ODlLQVpuS2wzMEozVG5MT05PcUxZeE00eTA4cjA9DQpoPSBTaWduZWQg
SGVhZGVyczogIEZyb206RGF0ZTpTdWJqZWN0Ok1lc3NhZ2UtSUQ6Q29udGVudC1UeXBlOk1JTUUt
VmVyc2lvbjpYLU1TLUV4Y2hhbmdlLVNlbmRlckFEQ2hlY2sNCmI9IERhdGE6ICAgICAgICAgICAg
TTdxeFVBV3REb3dWelBaczBlVFRkclN0ajNibzlERHhPM3JzeGhCaUNHczFQTUFqR3YxSkdPd0V6
ei9VUS9xZ1ExNE8rbDZPWHliSm9qcnBtaDF6Vm9waFVwaFRWeTJzTmFXNW9LNXM1b1UxWlhlTVR1
MGp0bTNhalBJUlBsVFJWOEpleVYwUnE4cWdQZGhBNTlHcWIvMVVZaFcwQXE1Z08wSW1qVndqMkZj
PQ0KUHVibGljIEtleSBETlMgTG9va3VwDQoNCkJ1aWxkaW5nIEROUyBRdWVyeSBmb3Igc2VsZWN0
b3IyLl9kb21haW5rZXkubnhwLmNvbQ0KUmV0cmlldmVkIHRoaXMgcHVibGlja2V5IGZyb20gRE5T
OiB2PURLSU0xOyBrPXJzYTsgcD1NSUdmTUEwR0NTcUdTSWIzRFFFQkFRVUFBNEdOQURDQmlRS0Jn
UUMwU2lnTk93MUtqazZiMDg4M3BoNElSVWpmZ0xmcDh5TDJKOFJ3VTlKOW1NVGtLeHlGUVlNdHFV
UjBDMEhtR3REanpkS1QzRFVIZTA2R2pQOUhxNkpiaWdhMEpLS1ZwM2l5Nmx5TEZtdmN5NjRvZGpV
cnZPaEtnT2pnblJwZUVWMnQ5OGEvaWRoTDNzUnhIMUpranFrTG1VeTRrN2s0RVkxMDVvWUEzMUlw
T3dJREFRQUI7DQpWYWxpZGF0aW5nIFNpZ25hdHVyZQ0KDQpyZXN1bHQgPSBwYXNzDQpEZXRhaWxz
Og0KDQoNClJlZ2FyZHMsDQpTaGVud2VpDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0N
Cj4gRnJvbTogR3JlZyBLSCA8Z3JlZ2toQGxpbnV4Zm91bmRhdGlvbi5vcmc+DQo+IFNlbnQ6IFRo
dXJzZGF5LCBKdWx5IDI4LCAyMDIyIDM6MzUgQU0NCj4gVG86IFNoZW53ZWkgV2FuZyA8c2hlbndl
aS53YW5nQG54cC5jb20+DQo+IENjOiBsaW51eC1zZXJpYWxAdmdlci5rZXJuZWwub3JnOyBzdGFi
bGVAdmdlci5rZXJuZWwub3JnDQo+IFN1YmplY3Q6IFtFWFRdIFJlOiBbUEFUQ0ggVjIgMS8xXSBz
ZXJpYWw6IGZzbF9scHVhcnQ6IHplcm8gb3V0IHBhcml0eSBiaXQgaW4gQ1M3DQo+IG1vZGUNCj4g
DQo+IENhdXRpb246IEVYVCBFbWFpbA0KPiANCj4gT24gVGh1LCBKdWwgMTQsIDIwMjIgYXQgMDE6
NTg6NThQTSAtMDUwMCwgU2hlbndlaSBXYW5nIHdyb3RlOg0KPiA+IFRoZSBMUFVBUlQgaGFyZHdh
cmUgZG9lc24ndCB6ZXJvIG91dCB0aGUgcGFyaXR5IGJpdCBvbiB0aGUgcmVjZWl2ZWQNCj4gPiBj
aGFyYWN0ZXJzLiBUaGlzIGJlaGF2aW9yIHdvbid0IGltcGFjdCB0aGUgdXNlIGNhc2VzIG9mIENT
OCBiZWNhdXNlDQo+ID4gdGhlIHBhcml0eSBiaXQgaXMgdGhlIDl0aCBiaXQgd2hpY2ggaXMgbm90
IGN1cnJlbnRseSB1c2VkIGJ5IHNvZnR3YXJlLg0KPiA+IEJ1dCB0aGUgcGFyaXR5IGJpdCBmb3Ig
Q1M3IG11c3QgYmUgemVyb2VkIG91dCBieSBzb2Z0d2FyZSBpbiBvcmRlciB0bw0KPiA+IGdldCB0
aGUgY29ycmVjdCByYXcgZGF0YS4NCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IFNoZW53ZWkgV2Fu
ZyA8c2hlbndlaS53YW5nQG54cC5jb20+DQo+ID4gLS0tDQo+ID4gY2hhbmdlcyBpbiB2Mg0KPiA+
IC0gcmVtb3ZlIHRoZSAiaW5saW5lIiBrZXl3b3JkIGZyb20gdGhlIGZ1bmN0aW9uIG9mDQo+ID4g
bHB1YXJ0X3R0eV9pbnNlcnRfZmxpcF9zdHJpbmc7DQo+ID4NCj4gPiBjaGFuZ2VzIGluIHYxDQo+
ID4gLSBmaXggdGhlIGNvZGUgaW5kZW50IGFuZCB3aGl0ZXNwYWNlIGlzc3VlOw0KPiANCj4gUGxl
YXNlIHdvcmsgd2l0aCB5b3VyIGVtYWlsIGFkbWlucyB0byBmaXggdXAgeW91ciBzeXN0ZW1zIGFz
IGl0IGlzIHNob3dpbmcgdGhpcyBpcw0KPiBhbiBpbnZhbGlkIHNpZ25hdHVyZSB3aGVuIHZhbGlk
YXRpbmcgaXQ6DQo+ICAgICAgICAg4pyXIEJBRFNJRzogREtJTS9ueHAuY29tDQo+IA0KPiBTb29u
IEkgd2lsbCBqdXN0IHJlamVjdCBwYXRjaGVzIGxpa2UgdGhpcyBhcyB5b3UgZG9uJ3Qgd2FudCBw
ZW9wbGUgdG8gaW1wZXJzb25hdGUNCj4geW91ciBkb21haW4sIHJpZ2h0Pw0KPiANCj4gdGhhbmtz
LA0KPiANCj4gZ3JlZyBrLWgNCg==
