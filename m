Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 026BB4C4BC7
	for <lists+stable@lfdr.de>; Fri, 25 Feb 2022 18:14:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241478AbiBYROu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Feb 2022 12:14:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238615AbiBYROt (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Feb 2022 12:14:49 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2114.outbound.protection.outlook.com [40.107.20.114])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18E5D1AAFE8
        for <stable@vger.kernel.org>; Fri, 25 Feb 2022 09:14:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mbony1TiYJr1Ed7F6mFgG+b+afj/7kZCO+vGzMRenkMkGuhbqogqWWtep3iNZ24Yb+0t/fCePYO51afBEyTFdDrxg3SQPq5qHMhqipNkSyUvijpMakIPd6Zg4877R5pWgFevKl3RHh+2OUw4PFmIJB9kfHFfixzCM6o2vDFcaT4XxmJsz980f5llQHtcQFLoajxGWT6MIu22e45i0ssWh9tqdPqHV3gIfprq6PxL4C/isFKG54iI0alN66kIBm+WLbeQJ0dstu/s4GBx4ezzLlnR9rg6bp6RvpC1NnCtw9F/2te9RJXNYZDhQZztoZD0OlW0kgTa36ujuvQ5lLKRmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rnOk+MXGszg1M3jcU3jXSNjdymilYBlTqNEveQv/EIg=;
 b=h4tp+jZFlWAPEkljCp4ZReek+pJpA4zcy58l//uwjiDNt49fX5Yxfch7jvKKLhHkUw5/2lpg2M2ZOy1LuSAltxQiBiTJTXN3rwZwTXalgafV2vFo4785YI0YxischzWk4IgA33qYFqXz9ek66LEc51Rl2v1xkkIrejTvAvUvjbdcyCOtYz3JO44w4baFuzqX0KFrqz/Irpllc8fe4YzU0S7+uZKzPmynEpd5kY3hio/Xvr2dWO3N3Gz0Iy9oogowRKfjnXi6Yujm6locwpXfNTnG7d8GkK8+6feh2uhRP2C1zUbBzm3SybhjYG2JB1fYogZf7ZAGWs8rEoz5P2pX1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=secomea.com; dmarc=pass action=none header.from=secomea.com;
 dkim=pass header.d=secomea.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=secomea.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rnOk+MXGszg1M3jcU3jXSNjdymilYBlTqNEveQv/EIg=;
 b=ho1Z1Q/Qkvbil+9YbDoaWEcaaukF3LqE4GY8Z1SoTY3lmVPFdCCiy8TYqCzxxeEQsrDFKrhIzzLu553jV9mLO96jQXSuKRjnJ26yMdOvrTCrgvYB4faOL+SuaXHn3rJQ0zktzRVlG2VMOOUC6v7GjLVrRjWfEIj0UKpsFbr42VY=
Received: from DB7PR08MB3867.eurprd08.prod.outlook.com (2603:10a6:10:7f::13)
 by AM0PR08MB4002.eurprd08.prod.outlook.com (2603:10a6:208:132::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Fri, 25 Feb
 2022 17:14:14 +0000
Received: from DB7PR08MB3867.eurprd08.prod.outlook.com
 ([fe80::216e:9d9:ffd1:7af1]) by DB7PR08MB3867.eurprd08.prod.outlook.com
 ([fe80::216e:9d9:ffd1:7af1%2]) with mapi id 15.20.5017.026; Fri, 25 Feb 2022
 17:14:14 +0000
From:   =?iso-8859-1?Q?Svenning_S=F8rensen?= <sss@secomea.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "o.rempel@pengutronix.de" <o.rempel@pengutronix.de>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] net: dsa: microchip: fix bridging with
 more than two member" failed to apply to 5.16-stable tree
Thread-Topic: FAILED: patch "[PATCH] net: dsa: microchip: fix bridging with
 more than two member" failed to apply to 5.16-stable tree
Thread-Index: AQHYKmNbQhXOuQp3Q02tv5p+1+zni6yke7Ck
Date:   Fri, 25 Feb 2022 17:14:13 +0000
Message-ID: <AM0PR08MB38593B3E0E9B6A861479A7F4B53E9@AM0PR08MB3859.eurprd08.prod.outlook.com>
References: <164580577118139@kroah.com>
In-Reply-To: <164580577118139@kroah.com>
Accept-Language: da-DK, en-US
Content-Language: da-DK
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
suggested_attachment_session_id: 61e0464c-9292-1f9f-6bcf-ed29bfdfb4ff
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=secomea.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cf80e72a-7ef4-4682-d094-08d9f8823f60
x-ms-traffictypediagnostic: AM0PR08MB4002:EE_
x-microsoft-antispam-prvs: <AM0PR08MB400226F8DF0273F5430CBDC9B53E9@AM0PR08MB4002.eurprd08.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PLYSVhRhqkTXxiCkbLIfasAS7TilTYOX0mZlRJmb9a+E9TKsizZ6fKqYWMiEmbDVL9bBQDhXAj9S+SLxpR5WhYCddvp/glTN0BAQZyZY0JgzWYTvSg+lzZdmrMvphefxyTsa3VO/o5k3HEJSGM8M2YdTum7mmlU+HwpiYyvkM/5YLb/XkeqvD4qLOt0iPK/EvianxRQAm8pGMlOg+VVLRhm/gAyxdFem9UefLGmKU6pJY395IGuMK4jPhKIftdLpdTJsXeo4PMoyOuzLyMYqFQqgUzN9zP1A1+pyiRWCqXzzdf5qOtefCfSalOcHcPNBUvTVCYqSwGcIv0IJD+2oI295A8eUyF2nvHdZVG+bvQ5IjmNRHGCi9Gp/ISokXKwVuppCympYo1lm8KFSPjfeR14dJpGl8Tm3sQFCiyFekMRhbxoxHfkQ/hEF6vKb9IfaqWRdn8g0/rSSlk+Zaz7a57fyPvKpdPDu7aXMzUdSHsvUCb8kkdw4blqBzxZEcXUvonWlgphvs+OEUYIgYxAAMM9PX8uEXuADgVEz1bhkyz414jNnikGoq5St/EDOTDw7XII3WiKQSVH+T+qgHyCHREAIT6CglioMUkA+jyr9XIVnTxr0a0ZbOEuIBSojAdSkgDFcb8mGyfyfC4w+MOLmD86Hw2IA9SnMPN5bfxvHWpZpXS1WjQ8NgmqjajxpNQWVJh3cQe3yukLavbySOLdRuQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR08MB3867.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(136003)(346002)(39840400004)(366004)(376002)(396003)(6506007)(6512007)(86362001)(6486002)(38070700005)(8676002)(76116006)(2906002)(4326008)(26005)(64756008)(186003)(122000001)(91956017)(9686003)(66946007)(52536014)(5660300002)(66446008)(66476007)(66556008)(33656002)(71200400001)(8936002)(110136005)(83380400001)(316002)(508600001)(38100700002)(4744005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?ztXO5Z85uslHLgrt++eNl1vK8y1u1XsZ9Z2JwsfKEk4jkbpssuPi5ywl+o?=
 =?iso-8859-1?Q?sSmHHylUBVFv66piOZtfzyCo6aSR81QIXe3bDG5dRJllxuctuF115qK6C/?=
 =?iso-8859-1?Q?CrAZyO5eEqyskSJn1ZUPOfyVQKKUAgztk9q607dkcHrm5cqOLw1E/dllaY?=
 =?iso-8859-1?Q?UMOKCRfRGAIBO86hUJJrO2p9HZ1tOI8/gsp/+vz7opfesd+RiTsn4Vf6gm?=
 =?iso-8859-1?Q?d1odvMkJrpeJCEk2f0KszQNR6X3cX+AzHKjzFRwosQWF80AjAoRSEMZt0n?=
 =?iso-8859-1?Q?QjhI/f3plYzlGdR1wCYvH959j4WOl3d5ZIOpAbOCn7hudmDfELdvZBbFmM?=
 =?iso-8859-1?Q?yJaeBUhA5fCWf2NzzMMOlElqDsXaYjkXNMOUDZyQxlgUMydCcRIhIbaztn?=
 =?iso-8859-1?Q?DVFW7sg+zver6NwZqT4m60dJohlNyJt//bd9DNlZ1hief5j+iZduTd+lpe?=
 =?iso-8859-1?Q?pEo+GHBnY6rUstQpBXj84zDPxae/JuVLi+dqj1Y0DKvLH3hilLdpPCYGO/?=
 =?iso-8859-1?Q?1o0gMKDr5/r1wx/guYSyx/U0cbUWfAUM9T//EZMhPnCkRwcpoOIrDFPlUt?=
 =?iso-8859-1?Q?oqBcJclA4pPEQvHsqH7rPlw3I2CIgHsAiVnZf9j9LZC4ksQfRwwIYFM0AY?=
 =?iso-8859-1?Q?FUk8qSTALg8qyHNvMUmvubCfgOivBSSkcefosOQGc6+tfcCHP0QIbMHD3s?=
 =?iso-8859-1?Q?xfRd8Y8FZ/YzaOV9B23gepM6c6LNc9CAuRx0D690HLcm8CYO7YcqeFxasm?=
 =?iso-8859-1?Q?Qvytle5WIWig1rHb8dWnSVny83k3vJ+TMEgsTgCSXllLYrEwE+2b72xfq5?=
 =?iso-8859-1?Q?O0B+ei+XtF1Rx2jSYE424PBOxu7iabwveWMbQIqwgrkQ57Zi4cTs7taKE4?=
 =?iso-8859-1?Q?GnQ95oo5u4LHm3PYuS7H/h2e3xXKBojDDZgXyh/woiaLmKo+0YsP+oxq7l?=
 =?iso-8859-1?Q?bbTd8VVQDEbj6AmkYKYTtFzOUlCl5tsytHJ86NKM8j2QTKArnMxob4Bpwl?=
 =?iso-8859-1?Q?BhLy1kzz2w3klvpR5PyySAOODe2zHIsbGw2+4hJITXrELdkZ9lpj2bcgy6?=
 =?iso-8859-1?Q?F7Gsh+CkYMfY5fjox7yVtDcUrMXPQu2GY+92RGlcEqCZohNn2XuV4Kwz9T?=
 =?iso-8859-1?Q?cyGtqqxmOQhC9wCaQ0JI+Ix8Lw90/cecWpajolt3NmBoVdgLgPtiZbp7AL?=
 =?iso-8859-1?Q?Uzd6qvqPz2GjkAQH7Vu2bDlTkFTHKqQNpSIrWGdbVuEuCSO/wNKs4bG2/v?=
 =?iso-8859-1?Q?+mCMnwhU9Tglc10KQs+Z27j7jirpuu1YDivBni+HHk3lD4UawWbeiHMjke?=
 =?iso-8859-1?Q?sjaGtNhcaCm+azyj8xHqJl9K5ZyzbYhLgsezFSRnWcSOFfN0q9qra7620h?=
 =?iso-8859-1?Q?EtMV48sm49lwjtnPn1eAfedw2L06zkKg/Z+ltQt0/wuuyXFWWA2Sm+wqg9?=
 =?iso-8859-1?Q?PgMyCfks0oPgw3bgghZuSUe1QSgyOEyXEQuWwYvKXLueH/eIVo+64I9q0o?=
 =?iso-8859-1?Q?856VCaF5H0V8Tz1jgy559hVOkrJNH5t+aqjhQ41CfYV5NlnMPIPpvaJKKW?=
 =?iso-8859-1?Q?7c9EhKjbx/Z5r/N3OYHvIzoKCNus8XwRGpCJBcyAbowUveMJWQ=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: secomea.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB7PR08MB3867.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf80e72a-7ef4-4682-d094-08d9f8823f60
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Feb 2022 17:14:13.8632
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 979261ea-5b3f-4cae-9a49-3a7da1f4fb47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EMo2e2Q2sIk1jL/RK5BOsEBGYVXWZPngCm3gYcOjv56x0YtBMgVkRQ+nzaiCYOu7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB4002
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

gregkh@linuxfoundation wrote: =0A=
=0A=
>> The patch below does not apply to the 5.16-stable tree.=0A=
>> If someone wants it applied there, or to any other stable or longterm=0A=
>> tree, then please email the backport, including the original git commit=
=0A=
>> id to <stable@vger.kernel.org>.=0A=
...=0A=
>> ------------------ original commit in Linus's tree ------------------=0A=
>>From 3d00827a90db6f79abc7cdc553887f89a2e0a184 Mon Sep 17 00:00:00 2001=0A=
=0A=
Hi Greg,=0A=
=0A=
That's strange - it applies just fine without errors here:=0A=
=0A=
--- snip ---=0A=
$ git log --oneline -n 1=0A=
f40e0f7a433b (HEAD -> linux-5.16.y, tag: v5.16.11, stable/linux-5.16.y) Lin=
ux 5.16.11=0A=
$ git cherry-pick -x 3d00827a90db6f79abc7cdc553887f89a2e0a184=0A=
[linux-5.16.y e1e17aca71a0] net: dsa: microchip: fix bridging with more tha=
n two member ports=0A=
 Date: Fri Feb 18 11:27:01 2022 +0000=0A=
 1 file changed, 23 insertions(+), 3 deletions(-)=0A=
--- snip ---=0A=
=0A=
So I'm not sure what's needed for backporting?=0A=
=0A=
Best regards,=0A=
Svenning S=F8rensen=0A=
