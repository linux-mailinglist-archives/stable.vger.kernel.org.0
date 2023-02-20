Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8393969D1A7
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 17:47:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232209AbjBTQrM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 11:47:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231613AbjBTQrL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 11:47:11 -0500
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2097.outbound.protection.outlook.com [40.107.105.97])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE4DB173F;
        Mon, 20 Feb 2023 08:46:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gt3fMGtfDjYc0aZqWNk6dsBVeitgVTnG+p/amAn1A6Fk8dsiYXn60aw4DrjoNuvrsDlfBCFG1Vsg1zQUbu1Uxw9c7v3yeJGuwG1CMm0ufcGIHrmP7d9Kzbibg4npI7/Z+dKafKwSSBz+Xksn+A35cihC364ZqG6rKdxnyCRk+26TjKBcnTRN4deLgOMZWux5fdiH+x1dpMKO8B0OIPf5THIpjNo1tB2xrLpgCloGqLxwaOKR2MauFXgpG6d2KhW5ZtTkfFSNvZekgppfwKKXgfduBRcnSdnanHLUfu3st3NPYkDk49NlTNdfPzQhxz9EFHs/Xh3X2D93Hp5Oko896A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p0/KNVqZgmaRk1WHWtdxC+K7Vo83W9Yvx19Fbk3qX4g=;
 b=FXQJ0qXAsMe86rLHCjFRSU89pLLh67B73Q6HdIMlMAwsLEH5W3frBwluLVx2gOD8lyJ0bwv7pFrYFc+03vtufG9wFsh0FHNy2JOFbYSKDvL6TtK6iCPNVg2LSyJO9jQOHTFUWz0meyrWCwkg4WJ76PwNVPBAfi+VKGLXUozZVnzMhrepgbVg8DnqIObgIlFBLvywHBKXZjQEnVltHh/z5tfnZ7H9HvJ6EX2SWJyurAt0GDZsAueD89hI6ErNCLW/FELa4QJ/RarQV4mX2GBzDZKg4hZLx/izDStDn0//0mwy/PR9LEnOsrMjI+gX9r+HM+/a6qoqCvQq5SnvSQZ5Tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=scs.ch; dmarc=pass action=none header.from=scs.ch; dkim=pass
 header.d=scs.ch; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=scs.ch; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p0/KNVqZgmaRk1WHWtdxC+K7Vo83W9Yvx19Fbk3qX4g=;
 b=q6/vvtlhtXrqpVn3NJeAiVCG6ZBUEsa+v1aDnySDBsDi2tyUpOD+Q5pVqirSuysDwy7uG5s9X5et7DX8R+syOsu59ZKqvKPe72HV/3GN/OMcFdP7jbpQN6XLelwUbZK7aV5JXR1ttr4LQ2CMccqs5s5AZWSmcEI4WFGOfHK6IOaRBx4Db6KCjkyYb+dIw3uug3gl4QWfLtGwsC7a2TVTFz657+p2mpdA7M/nAfL4hKJ201g5VbjdYv8FWcklCewaNDSKOrPHNkROeUBoIteG6ewdnK3UJxzIqoVmsLSLJrSI8rq+kkvyznF5IdjzxOhPW0vF/QUQG1ZujSdg0P37Cw==
Received: from ZR0P278MB0773.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:4d::10)
 by GV0P278MB0830.CHEP278.PROD.OUTLOOK.COM (2603:10a6:710:51::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Mon, 20 Feb
 2023 16:45:32 +0000
Received: from ZR0P278MB0773.CHEP278.PROD.OUTLOOK.COM
 ([fe80::1379:5785:1f56:763f]) by ZR0P278MB0773.CHEP278.PROD.OUTLOOK.COM
 ([fe80::1379:5785:1f56:763f%6]) with mapi id 15.20.6086.031; Mon, 20 Feb 2023
 16:45:32 +0000
From:   Christian Bach <christian.bach@scs.ch>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        "linux@roeck-us.net" <linux@roeck-us.net>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        =?big5?B?Y3lfaHVhbmcotsCx0q3sKQ==?= <cy_huang@richtek.com>
Subject: AW: tcpci module in Kernel 5.15.74 with PTN5110 not working correctly
Thread-Topic: tcpci module in Kernel 5.15.74 with PTN5110 not working
 correctly
Thread-Index: AdjoVYnpyrmyLmxITSiX1bJ23H/1egAFm5rgAAClgwAXNteHcA==
Date:   Mon, 20 Feb 2023 16:45:32 +0000
Message-ID: <ZR0P278MB07731B49E8938F98DB2098ABEBA49@ZR0P278MB0773.CHEP278.PROD.OUTLOOK.COM>
References: <ZR0P278MB0773545F02B32FAF648F968AEB319@ZR0P278MB0773.CHEP278.PROD.OUTLOOK.COM>
 <ZR0P278MB0773072DD153BA902AFE635AEB319@ZR0P278MB0773.CHEP278.PROD.OUTLOOK.COM>
 <Y1fYjmtQZa53dPfR@kroah.com>
In-Reply-To: <Y1fYjmtQZa53dPfR@kroah.com>
Accept-Language: en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=scs.ch;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: ZR0P278MB0773:EE_|GV0P278MB0830:EE_
x-ms-office365-filtering-correlation-id: a2907e9e-f866-4cb0-7a62-08db1361e1b1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IAxWLsPPKy3EVcLzPZ4mVSfVFE9yyO6VHtwMtN/+Nu4doS8cIL/stWtB+N7Pn9YjHYhoe5KCIxeS1QPofIG4HgbXpysuEhFCZxijOR4X0+Y/YoMZTA5uZxVDPAOFNeq93n1rShfL/CjhTN4MlbdwpwFAPPApMNYA7RK7D+XHgvCI4yt3EC6KeIAyja0Ot2kesJo19vusn5oF6JjorqzOaFcXTTZwLGnZwHTJeYOvGgchwAS/yUZET8yp63GPnoArP8gB5JTm4xHkIQWqj70pEoXs9cPEWdzBRk9+cOEpJXsFkStzAy8YhcmJigKysY1bepDRh+RK+BjU4+ll030/aLD5kWAL2aL7ViOBRgIpaT2CUaU8wxrj1/k0URPHh1Wp2obw+4+hJ5t7Swgl8GE/K8dIG36/l2yNZ0RJoJLWSIHgVlufom1e7eEhwSpJSgkjZSxSDPxw7WoUMu9Jw8G7TwielLG/h78zavDgeb0vko7uwgtbCUtVYrNil1MLhhjtKFc0Sse4JGaqH5VElUjTqt8iz5ZkvnkAb3WaGI9owBTkKl6uBF7VKCaEl+UWwu4Na1Oc4/rjIaFMjlWoAhPfHQslOUiG44rU1oLff8bgqIv3ruCXCmpVlr+qGAxt9Blx2Era2D9qM0BN5AOMAKqwglxcPvBsxb9ocdd4Wrkm1OiCAz41eXHdoTq5SuMuvxRt
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZR0P278MB0773.CHEP278.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230025)(346002)(366004)(39840400004)(376002)(396003)(136003)(451199018)(122000001)(71200400001)(76116006)(7696005)(41300700001)(478600001)(9686003)(66556008)(44832011)(26005)(186003)(54906003)(6506007)(8676002)(66946007)(6916009)(66476007)(2906002)(64756008)(316002)(55016003)(8936002)(52536014)(38100700002)(33656002)(38070700005)(66446008)(86362001)(5660300002)(4326008)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?big5?B?RzArejlJbzdvayt3Y3NpSzVlbS9VTzRzdmFpNGFtemIvVjgycVFvS2REK0MzazNP?=
 =?big5?B?WXRPV1M2eDJyamIrb3JrUkhCTjhIWXMrNnpGcGNVb3NSMXNSYU85UXVUL00yYm5M?=
 =?big5?B?c3JPekpUZFA4TXdMeDFrMHRnalp3Qk5FVkM0VWdmYUdyTjZEWGRZTnhrUFVtbVNa?=
 =?big5?B?ZERKVTRiZjU0Wnd3OEpSZzhDZElBZVFRS0swZ0pVSGVQbXpDaHo2SHVMVjFWR0Nu?=
 =?big5?B?NDYyRzAvS1E1YXZBUXBBT1dVbUw1b0tIZUtVMGxEQzN4VksvYTdTeC9WTUNwVUFt?=
 =?big5?B?R2FWbnFLcVJYdTRyOWQrUkg4UXozZktPWW5zS3ZLcjdLOGRBYUNxZmJxQ0Z1Z05E?=
 =?big5?B?RWdsNnEzUFpxVG9PcU9SM2JyYlRHRmZuVVpoRm11Tm9YZUc3OElmS1dOcWQ5eDRO?=
 =?big5?B?M0ZxcDE3am5qNGNCT09LRm1jM05tV21BKzFYU2pDZ3ROTXpRdS9IOTBKRk9KUDRK?=
 =?big5?B?YStzUDNjVjRSeHk4QUhLenJGVkVEb0VlTkxvM3grMzFyZGZvejZKUTQyL3dUN283?=
 =?big5?B?VWZxdDhjcVB4UUwzRGZmeTU3QTJ1bWZTRTUzTHg1SlQ4TnZ1dU1CRnF1VUp3TmRz?=
 =?big5?B?MGx6dncyWnRxNkxTN0lpZ1NGK3orNVgvZUpwVlBrenBpUmp2VEtPR1VGYnlsMWU1?=
 =?big5?B?ZWs1Q3hOME42ZGRLZUtSbEhDUXRocWFxemFZeWUydEY1MHk5NVFDOC9YTU95dVRG?=
 =?big5?B?Z3hjcW1GWThDS0R5cE5OejBhWjhoVHZTbkR4SzJEVmVIWFRUOUhTNkNQTHVLUlJa?=
 =?big5?B?akowVnBjbEQrNFdBazdoSXpZNC9pZ1BzRmYyYXg2bEU4RVBSS0E4WGtVMGh5R3ph?=
 =?big5?B?aXJHQzV4VEJBN3pZUmE2SFkxTlowZitEN2ZnTFFXaGtqR3N4eHltOUZCWW5tcVU2?=
 =?big5?B?enJxTU9KSmZ1WlB3T3dTL2tWQkdWc2RTUEhPTnRrYkJPZmhpMDNIOVJ1NFFzYVJR?=
 =?big5?B?U1dYQ1FJSnRvRGVNYlUwcTFBdUFWbVdweUpDYUk4aWhyNEtrT3AvdDVmai95TkZX?=
 =?big5?B?ejYrLzYxQ1puRm5uempsZTVFVzZDN1hjMVFTbUhtSHZRVlNRMnRwTjhXR0NETlhB?=
 =?big5?B?ZE8xVUlGeTZuL3NHbmVCOXhiRUJXcHBIaUVJOUZSMjdoNElqR3k0MFVyRWhyV2Yv?=
 =?big5?B?aEJKMG10K1ptL1FEQ2hLS1EvaC9VQ2JzQXRwMGZTYUc1dzd3U1FsSXZSeGZERXpQ?=
 =?big5?B?QWFaWm4yTm82WjhDYXhaaDhSZ3lMUS9HUFovZnY1R3pTZDJyUGpVczZvZ04zcmRV?=
 =?big5?B?dkNQaHp2YW03S0tHMm1xYjhPVjJHYks0Nks1NklnTGtSZ1lsc1R3eGdOTTN4Qlhm?=
 =?big5?B?NmQ5U3VuMFFmMDRMQ3VPelVoOGxjVDRjaC83N25wb1NYY0xmRnFPRTNqYVhkREli?=
 =?big5?B?VmU3RmdyYkJkWTJZL1RFT0ljZjZGZnVBWWJPVWowR0tlR0N5RFVRbUNPbGwrNzFN?=
 =?big5?B?TUdGdXA3U0tyM2svMUVkV1BaWTM5L1kwYnA4eW5EOEJkN1dobHdaTjFmWXhDL3Q3?=
 =?big5?B?MVhMWmlpbXJ0SVR4bjgzNld0MUFjVkZDMTdRTVNJMjZIaUJDbExRenhPcmVLdDhN?=
 =?big5?B?L2tpclNaMlNwNWR1N2ZxWks0NVNLS3crSFBPc04zMFY0T0IyTzhOVHNna1hwYjNz?=
 =?big5?B?NDh6R3FoUnBHRGJOdytkaUJmZFltS0JVVkVkV25XVm1HSWlLbEsrelJHQUUwVHlP?=
 =?big5?B?M3JnazhnVjlWZVdlQ21pVTVkRWI2RnhURWJjT3pDKzRXWnRSb1lYM0lzVXJxcG12?=
 =?big5?B?VnRta3Nob0JwazBBZ1ZRUUltd2Q0NzJzb0JzVjQ1UmJvWElwZ2F4Q3pIeDhTWjhZ?=
 =?big5?B?NHJYSFpBcEZvaDlMaGJaMlY2amRBRHFBWEFFYXdGQ3RJMFBCYzFIWGx3WElHMjFL?=
 =?big5?B?REY5dE1XakNRc29UVzV0b2MxZ0NsS1lhbzVYV0MxNStGT1NkUHJFSWc1enVPV0JM?=
 =?big5?B?TFNzTk51NEFIUFVFc1UzTmN3ejJON1FNSkFreU0yaFVmbkhOWFB0Wm81WVg1b3px?=
 =?big5?Q?bpr9/Lxexftj/Gmi?=
Content-Type: text/plain; charset="big5"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: scs.ch
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: ZR0P278MB0773.CHEP278.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: a2907e9e-f866-4cb0-7a62-08db1361e1b1
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Feb 2023 16:45:32.2161
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 1b8c3cb6-94f9-44ce-91ec-7183fd2364b2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GPElCcTZ1AFPDxX7fAc+TSdPsqAI9ts2NRT8Dmpgz9MnqEJZRcb0HVxCrQvUGYKDuNXIiEy0FXEsk8aQns32Sw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV0P278MB0830
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGVsbG8gZXZlcnlvbmUNCg0KV2UgZmluYWxseSBmb3VuZCBhIHNvbHV0aW9uIHRvIHRoZSBwcm9i
bGVtIHdlIGhhZCB3aXRoIHRoZSBQVE41MTEwIENoaXAgYW5kIHRoZSBLZXJuZWwgTW9kdWxlIHRj
cGNpIHRoYXQgbWFuYWdlcyB0aGlzIGNoaXAgaW4gNS4xNS54eCBLZXJuZWwuIE5YUCBQYXRjaGVk
IHRoZWlyIEtlcm5lbCBhIHdoaWxlIGFnbyAoaHR0cHM6Ly9zb3VyY2UuY29kZWF1cm9yYS5vcmcv
ZXh0ZXJuYWwvaW14L2xpbnV4LWlteC9jb21taXQvZHJpdmVycy91c2IvdHlwZWMvdGNwbS90Y3Bj
aS5jP2g9bGYtNS4xNS55JmlkPTJhMjYzZjkxOGIyNTcyNWUwNDM0YWZhOWZmM2I4M2IxYmMxOGVm
NzQpIGFuZCB3ZSByZWltcGxlbWVudGVkIHRoZSBOWFAgcGF0Y2ggZm9yIHRoZSBLZXJuZWwgNS4x
NS45MS4gSSBhdHRhY2hlZCBteSByZXdvcmtlZCBwYXRjaCBiZWxvdzoNCg0KZGlmZiAtLWdpdCBh
L2RyaXZlcnMvdXNiL3R5cGVjL3RjcG0vdGNwY2kuYyBiL2RyaXZlcnMvdXNiL3R5cGVjL3RjcG0v
dGNwY2kuYw0KaW5kZXggNTM0MGEzYTNhODFiLi4wZDcxNWUwOTFiNzggMTAwNjQ0DQotLS0gYS9k
cml2ZXJzL3VzYi90eXBlYy90Y3BtL3RjcGNpLmMNCisrKyBiL2RyaXZlcnMvdXNiL3R5cGVjL3Rj
cG0vdGNwY2kuYw0KQEAgLTYyOCw2ICs2MjgsOSBAQCBzdGF0aWMgaW50IHRjcGNpX2luaXQoc3Ry
dWN0IHRjcGNfZGV2ICp0Y3BjKQ0KICAgICAgICBpZiAocmV0IDwgMCkNCiAgICAgICAgICAgICAg
ICByZXR1cm4gcmV0Ow0KDQorICAgICAgIC8qIENsZWFyIGZhdWx0IGNvbmRpdGlvbiAqLw0KKyAg
ICAgICByZWdtYXBfd3JpdGUodGNwY2ktPnJlZ21hcCwgVENQQ19GQVVMVF9TVEFUVVMsIDB4ODAp
Ow0KKw0KICAgICAgICBpZiAodGNwY2ktPmNvbnRyb2xzX3ZidXMpDQogICAgICAgICAgICAgICAg
cmVnID0gVENQQ19QT1dFUl9TVEFUVVNfVkJVU19QUkVTOw0KICAgICAgICBlbHNlDQpAQCAtNjQ0
LDcgKzY0Nyw4IEBAIHN0YXRpYyBpbnQgdGNwY2lfaW5pdChzdHJ1Y3QgdGNwY19kZXYgKnRjcGMp
DQoNCiAgICAgICAgcmVnID0gVENQQ19BTEVSVF9UWF9TVUNDRVNTIHwgVENQQ19BTEVSVF9UWF9G
QUlMRUQgfA0KICAgICAgICAgICAgICAgIFRDUENfQUxFUlRfVFhfRElTQ0FSREVEIHwgVENQQ19B
TEVSVF9SWF9TVEFUVVMgfA0KLSAgICAgICAgICAgICAgIFRDUENfQUxFUlRfUlhfSEFSRF9SU1Qg
fCBUQ1BDX0FMRVJUX0NDX1NUQVRVUzsNCisgICAgICAgICAgICAgICBUQ1BDX0FMRVJUX1JYX0hB
UkRfUlNUIHwgVENQQ19BTEVSVF9DQ19TVEFUVVMgfA0KKyAgICAgICAgICAgICAgIFRDUENfQUxF
UlRfVl9BTEFSTV9MTyB8IFRDUENfQUxFUlRfRkFVTFQ7DQogICAgICAgIGlmICh0Y3BjaS0+Y29u
dHJvbHNfdmJ1cykNCiAgICAgICAgICAgICAgICByZWcgfD0gVENQQ19BTEVSVF9QT1dFUl9TVEFU
VVM7DQogICAgICAgIC8qIEVuYWJsZSBWU0FGRTBWIHN0YXR1cyBpbnRlcnJ1cHQgd2hlbiBkZXRl
Y3RpbmcgVlNBRkUwViBpcyBzdXBwb3J0ZWQgKi8NCkBAIC03MjgsNiArNzMyLDEzIEBAIGlycXJl
dHVybl90IHRjcGNpX2lycShzdHJ1Y3QgdGNwY2kgKnRjcGNpKQ0KICAgICAgICAgICAgICAgICAg
ICAgICAgdGNwbV92YnVzX2NoYW5nZSh0Y3BjaS0+cG9ydCk7DQogICAgICAgIH0NCg0KKyAgICAg
ICAvKiBDbGVhciB0aGUgZmF1bHQgc3RhdHVzIGFueXdheSAqLw0KKyAgICAgICBpZiAoc3RhdHVz
ICYgVENQQ19BTEVSVF9GQVVMVCkgew0KKyAgICAgICAgICAgICAgIHJlZ21hcF9yZWFkKHRjcGNp
LT5yZWdtYXAsIFRDUENfRkFVTFRfU1RBVFVTLCAmcmF3KTsNCisgICAgICAgICAgICAgICByZWdt
YXBfd3JpdGUodGNwY2ktPnJlZ21hcCwgVENQQ19GQVVMVF9TVEFUVVMsDQorICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgIHJhdyB8IFRDUENfRkFVTFRfU1RBVFVTX01BU0spOw0KKyAgICAg
ICB9DQorDQogICAgICAgIGlmIChzdGF0dXMgJiBUQ1BDX0FMRVJUX1JYX0hBUkRfUlNUKQ0KICAg
ICAgICAgICAgICAgIHRjcG1fcGRfaGFyZF9yZXNldCh0Y3BjaS0+cG9ydCk7DQoNCg0KDQoNCg0K
DQoNCg==
