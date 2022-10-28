Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E59C610D4A
	for <lists+stable@lfdr.de>; Fri, 28 Oct 2022 11:31:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230168AbiJ1Jbm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Oct 2022 05:31:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230106AbiJ1Jbh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Oct 2022 05:31:37 -0400
Received: from CHE01-ZR0-obe.outbound.protection.outlook.com (mail-zr0che01on2107.outbound.protection.outlook.com [40.107.24.107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09E1B1C6BF9;
        Fri, 28 Oct 2022 02:31:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XbLKM2E5H4WQJby3V6dhOMoTeI5q6IaVaKeWCO1ebfwIURnxRq7hZIF/ovybgYyj77YQaCnlzkbo8W4aRqzywBqAHIkGnorZfAaSLSbjeBhpr7VzeP1IxUb+wiRs3AkzqKSDtj6e+lHElezL5bpobzqsYLuYYVVukvRBQgSyuR1Px9MNxI4j2n8bewvGJltIkZo8Q7erBTIxp+zCQSGgl7ltiDYCTfLoFbsT1RFQI1acRTT2cXq3SXPU824Rf/tmP0ery/VoW6UF8NvF7o4OygMFIWVmDWEfZ7Qa/U2v6/EwAhoxxU9X+id44BUb0Ce2vPFgLxgT10qucBLv9pFpYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GjuMRhdBYLffF3td7+R9xXeH0xylrsMDC+CPry1maz4=;
 b=GO8sglyeiyrAWveilHDyap9wb+TU93tHwj+QYY+mhFLrClzBGGE2hqGxSt/3VT5VMH10EG9gd10X+GQNY1xLfgrBhvHwjUuDD6FTWkfS+oIS4RGKPKqzmUmra6WcAWfFoTrF8fMFKxCCHr6lqVjn5rxe/5H5B4NOYjlQic8WRMhlmNymD7afb8EYTyWcDxkdqYmVZNOncetFFe9+1O5oyqNx3HefSuoKoa1v0a5dtO+IRdU/eyVwY2qtWKRvPtqMywREURgutYkE+NnizYazKYyEaFxq+DZEOzJJLdJUXleezhu01pTuyLZE9TRu8lbr0pAGNZ1aCW3xNVEauOdjYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=scs.ch; dmarc=pass action=none header.from=scs.ch; dkim=pass
 header.d=scs.ch; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=scs.ch; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GjuMRhdBYLffF3td7+R9xXeH0xylrsMDC+CPry1maz4=;
 b=beXTpUfiLLKFLQtClvLLGlzFkllqvl4LtnIV3iW3nsK17cy/ba/kIMxg9fpEvHEwLtfqgbFVPwvpleGQXtnpLigZGIPrz+0gAy/1yOsIqSV5WUUU51MzAzZ6nqZBv26CujCfVbWp/liULIRpabOOiWajcVa1goUHVzjw61SObG4a+osjLto5zONBi8c4garU3yfTCW9f0kk8fs7+TNhP5NsLQ562Fe/rdaLrPM3Tb6okAUIymUM3zlfrJwF87YN6d8Z/NFPEdWIElf0U4ccgNBonzSg7PuFW4ViY8kQxU4WiYQarMJSHVhNyW7hdUxCU/OqY3cI8VLCSWOr2sQNmQg==
Received: from ZR0P278MB0773.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:4d::10)
 by ZR0P278MB0012.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:19::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.14; Fri, 28 Oct
 2022 09:31:26 +0000
Received: from ZR0P278MB0773.CHEP278.PROD.OUTLOOK.COM
 ([fe80::a72a:1fa7:a789:4222]) by ZR0P278MB0773.CHEP278.PROD.OUTLOOK.COM
 ([fe80::a72a:1fa7:a789:4222%9]) with mapi id 15.20.5769.015; Fri, 28 Oct 2022
 09:31:26 +0000
From:   Christian Bach <christian.bach@scs.ch>
To:     Guenter Roeck <linux@roeck-us.net>
CC:     Greg KH <gregkh@linuxfoundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: AW: AW: tcpci module in Kernel 5.15.74 with PTN5110 not working
 correctly
Thread-Topic: AW: tcpci module in Kernel 5.15.74 with PTN5110 not working
 correctly
Thread-Index: AdjoVYnpyrmyLmxITSiX1bJ23H/1egAFm5rgAAClgwAAAA5FcAACA+oAAAHLBnAABd5EAACFrZ5w
Date:   Fri, 28 Oct 2022 09:31:26 +0000
Message-ID: <ZR0P278MB07737E5F1D48632897D51AC3EB329@ZR0P278MB0773.CHEP278.PROD.OUTLOOK.COM>
References: <ZR0P278MB0773545F02B32FAF648F968AEB319@ZR0P278MB0773.CHEP278.PROD.OUTLOOK.COM>
 <ZR0P278MB0773072DD153BA902AFE635AEB319@ZR0P278MB0773.CHEP278.PROD.OUTLOOK.COM>
 <Y1fYjmtQZa53dPfR@kroah.com>
 <ZR0P278MB077321F8565A4FF929B132A1EB319@ZR0P278MB0773.CHEP278.PROD.OUTLOOK.COM>
 <5373483d-adde-2884-6017-75f3bd25d6bc@roeck-us.net>
 <ZR0P278MB0773212E08AA1007241990FCEB319@ZR0P278MB0773.CHEP278.PROD.OUTLOOK.COM>
 <20221025171614.GB968059@roeck-us.net>
In-Reply-To: <20221025171614.GB968059@roeck-us.net>
Accept-Language: en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=scs.ch;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: ZR0P278MB0773:EE_|ZR0P278MB0012:EE_
x-ms-office365-filtering-correlation-id: 97044087-9a7f-4b18-eff6-08dab8c72f8b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 98kJei1P1OKeVvu00tRWWCqkdd0fO/hc0mSAQhARZc6ZI7qpBjEhp6p9rpTLRBkItlf0vN7Qd8KqjrdLMYNJwFvZxyL7l1JCNKHD/ZRJV39c7Jarvy8p17nB28Ue/TpKbu3q+IbCsLmwkXmiYrh07uRCwMA67SNu2FyW7/eWBzZwMNZLglkqx6gOtPnyw7OCYoTgrfbeX7PiXHkbxsaHvgRC0YiyAHQr9QdWgv15wU+QEvDjwJQjeDNlSjX5YBLBVY+DGKRxMFee29GhyHu7Csmodj/NlhcguMOGervVFfR1SDlFJrsgCKstlI8t/Py0XIgL4wrELbx3yC0tyCa+vm82FbYroXJx6Dbv7gQu6nNakUYgOIK4YfqmLLWa++0iBQ4Td/x5knwL+d5CJyyQ7Wt82ZN0Z6rWg3YGT4lgiKKT+KrrppWK718tNrKs5a7RYZqNO9l+0qlcB6RsR5FOGwFnZvYX2VJCNrKqAK38YLqamet5jdHAdC57JUze1KQaFXobOSP8tw4g3CwW5zKN+v3/Llb/mR5k22VN1Rnqw4ozk9AWDdsszs+mF5wYU8uua6gdWZXJODvW31WtFeUUXY2g4iSe/jFEszyz3en6TUl9LsIaVmLti69+KkALqazkivkZkbatlzqhT2TllZ0kOxj+EAne0UD7Q7a+NMmD7J4xcQUlJM+3sTeamdEbL9Ho9wEqduFQxMK1vLEpdX4fZagNL/clI3snmSXLIVM3zalFf4Qr4++x/z8igzhPauzI+PHeDEOu2IWZndMeQ3X/Pw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZR0P278MB0773.CHEP278.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(39830400003)(136003)(346002)(366004)(376002)(396003)(451199015)(2906002)(186003)(9686003)(83380400001)(26005)(6506007)(7696005)(44832011)(66556008)(41300700001)(66946007)(6916009)(76116006)(478600001)(122000001)(54906003)(38100700002)(52536014)(71200400001)(5660300002)(30864003)(86362001)(4326008)(316002)(38070700005)(33656002)(8676002)(66476007)(66446008)(64756008)(55016003)(8936002)(579004)(559001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?SCPBOYMpTq8UwjA3YMUhgqaUlt7XJCTQXwEqpdQ3FzKA5BR32CRLrxi18UOQ?=
 =?us-ascii?Q?bNTHZPAnH74YrJVVTi8/bLodHwddgVwkZ+bLRj3MHfvszJ8cRj72ceFSw81F?=
 =?us-ascii?Q?tAZo+X2B3WJhXNGsAK1QXbovUXMOLdg+Uf9rahROoUrGZazEw5irhgb/napm?=
 =?us-ascii?Q?aF5rm7HKtx4aLoNga7yPmpAhrH9km0nBJWFqApl+ESL9RJN5BkddCe/TiXBo?=
 =?us-ascii?Q?25QjM8dyCH3jL90xmbZw0bSJspnE3Np/PE1Nn+3md31glaVJ0nEsqtnPiw2X?=
 =?us-ascii?Q?eFgKIw/NuZCrc3tdIqyMnmLPb+1DS2no9M6Sr36yR3JUZJXRxM8MUG8VW2m1?=
 =?us-ascii?Q?JAmoTNxcdfymz8pZ1ZK9SQrixLh/NmD3nt+LiXXg0dzDFtUsqM+/4oddLCV7?=
 =?us-ascii?Q?iejtRkOd0xZUmhfgrY5CRKjrwP4SauZ6rMkB01m/imQQRe3nsq5wSK0Jt1oy?=
 =?us-ascii?Q?PFQD9sxSqVNGnOLUc+zEL9ImRDbx1zLhpCueKeG4tGRBcQWIfjw58vll0lJp?=
 =?us-ascii?Q?HKfV/gcbvhWNNiJWfJpw4AR/BGVE8snJ4jKjoCkk1AVbHEBB4Vga1JcBWrGO?=
 =?us-ascii?Q?Vo4sKfQVzPBFXj5KoQ9ap4ihhEFBgjk3s9diqBdMu8472pF+siZzk+OkUQjy?=
 =?us-ascii?Q?l/kR3+lxcmtCTKfZVx5EdY/ahW0Nzen7grbXeF9WdOpXJSlOKAiN8Um9UnOZ?=
 =?us-ascii?Q?C5KjXR50hURxx0SUlAnv550qwMdbZIVM7i+ldhTZTq8PC84cL0LTrlIZ+Ua/?=
 =?us-ascii?Q?iFZ1On+YbwfZFVgU9AeJ3qw1HnYzMS1K++Z51Wq4ugdCkWGtInnBmKf38bKd?=
 =?us-ascii?Q?DvVmd9kGctuAKAuoVD7SNFTmwVNDsD4NFTQOt4wG4jUbAxhL7rgvvRE5C+YS?=
 =?us-ascii?Q?U1Mc+kHvuC77M0M3y4hKvifdP2JSlGbY9quZqjAYECX9+wLEhoPCPLcJH2fF?=
 =?us-ascii?Q?fWx6n9jcHGQUZhZe2HwFKylq+/PFT0m9ZDjjLVcp8cVuR+Q6hc7J6k/yDE6u?=
 =?us-ascii?Q?V0vGxr2H9rODs+D72skHlL9jjl8ed00qee36+mCtKa4Pv39H+5UJtjA76fxJ?=
 =?us-ascii?Q?fygRzi65iKG+gXrNJBqP0gasor/6wTOY9bQzHofSRK23/PdKm2ygMcABb5dN?=
 =?us-ascii?Q?EzGskKhgVl2Ltrm1/dsq3Kc+/0ZQfwC7pMVWAtQ6ZYJEngCipKZLwoa8wHVq?=
 =?us-ascii?Q?Gi22TnQ9LnzXa8AjOh7yfaYq7iiINXv1KhtWBObmihrrENtUwGs6hdkLWBeC?=
 =?us-ascii?Q?3P+LsMGE24y/Tojw8CjDjqWh7pMDhS/+aBEvMi1jgMZzBspvKbmyHismd0C+?=
 =?us-ascii?Q?eJo1qrDiKOAOci5HqJZkHAMktyQ4aDDGPQK9SaWXpW6pn6dfZBT3iuRfiuji?=
 =?us-ascii?Q?YORjZGhBJ0Wu9N1pgvfBCG+1V12B7MgJEyCD2nVFADIyowJUI5RZ0j8I+CsX?=
 =?us-ascii?Q?LGEZ0rwIgGehkbTFGGXBPNgIgSRIyXDXMi4lZJOcZKwo8go9IUFki0FfuWT+?=
 =?us-ascii?Q?ezP+Ux8Myk0d+4VhtQmLF55lERp8GynjTewFsmOzqm9jcTSEBrOy3WAsCeuF?=
 =?us-ascii?Q?lCFbmrUdHjLejcSd9VteNGHHSYqDkmjZYf8tK1eH?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: scs.ch
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: ZR0P278MB0773.CHEP278.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 97044087-9a7f-4b18-eff6-08dab8c72f8b
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2022 09:31:26.1424
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 1b8c3cb6-94f9-44ce-91ec-7183fd2364b2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wgzA72JnIbSFgN5SmYeZVbtx+ch0bWLWLd0Z66inDngbWMppBTCVfpGUR8rK9dazLDfGiPMt/omDurSKankK0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZR0P278MB0012
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,T_SPF_TEMPERROR
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> Can you also test v5.0 .. v5.3 ? Mainline would be best (not v5.0.x but v=
5.0) ?

I was unable to build those Kernels with my build-system:

Kernel    | Hash                                       | Bug     | Comment
Version   | (date)                                     | present |
----------|--------------------------------------------|---------|---------=
-----
v5.0      | 1c163f4c7b3f621efff9b28a47abb36f7378d783   |         | git://gi=
t.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
          | (3. March 2019)                            |         |  The bui=
ld system was unable to compile the kernel=20
          |                                            |         |  scripts=
/dtc/dtc-parser.tab.o:(.bss+0x20):=20
          |                                            |         |  multipl=
e definition of `yylloc';=20
          |                                            |         |  scripts=
/dtc/dtc-lexer.lex.o:(.bss+0x0)
----------|--------------------------------------------|---------|---------=
-----
v5.3      | 4d856f72c10ecb060868ed10ff1b1453943fc6c8   |         | git://gi=
t.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
          | (15. September 2019)                       |         |  The bui=
ld system was unable to compile the kernel=20
          |                                            |         |  scripts=
/dtc/dtc-parser.tab.o:(.bss+0x20):=20
          |                                            |         |  multipl=
e definition of `yylloc';=20
          |                                            |         |  scripts=
/dtc/dtc-lexer.lex.o:(.bss+0x0)
----------|--------------------------------------------|---------|---------=
-----

> You should find the logs in /sys/debug/kernel/usb/tcpm-<index>.

I was able to retrieve these Logs for the 5.15.74 and 4.19.72 Kernel. Unfor=
tunately I am not familiar enough with this subsystem to find the problem m=
yself.
Regardless, what stands out to me (as it already did when I posted the I2C =
communication) is that the module in the old kernel is doing much more thin=
gs when a cable gets attached. To me it seams as if a vital handling method=
 is not being called in case a non-PD capable cable gets attached. As you c=
an see in the log at the end the PD-capable power supplies work just fine.

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
First the log from the old Kernel 4.19.72:
USB-PD Init:
------------

[    2.381046] Setting voltage/current limit 0 mV 0 mA
[    2.381069] polarity 0
[    2.383125] Requesting mux state 0, usb-role 0, orientation 0
[    2.384739] state change INVALID_STATE -> SNK_UNATTACHED
[    2.385636] CC1: 0 -> 0, CC2: 0 -> 0 [state SNK_UNATTACHED, polarity 0, =
disconnected]
[    2.385759] 3-0050: registered
[    2.390858] Setting voltage/current limit 0 mV 0 mA
[    2.390875] polarity 0
[    2.405734] Requesting mux state 0, usb-role 0, orientation 0
[    2.406435] cc:=3D0
[    2.407098] pending state change PORT_RESET -> PORT_RESET_WAIT_OFF @ 100=
 ms
[    2.408069] CC1: 0 -> 0, CC2: 0 -> 0 [state PORT_RESET, polarity 0, disc=
onnected]
[    2.408098] state change PORT_RESET -> SNK_UNATTACHED
[    2.408139] Start DRP toggling
[    2.411694] CC1: 0 -> 0, CC2: 0 -> 0 [state DRP_TOGGLING, polarity 0, di=
sconnected]


USB-A to USB-C Cable attach event:
----------------------------------

[  565.271076] VBUS on
[  565.274567] VBUS on
[  565.276331] VBUS on
[  565.362693] CC1: 0 -> 3, CC2: 0 -> 0 [state DRP_TOGGLING, polarity 0, co=
nnected]
[  565.362731] state change DRP_TOGGLING -> SNK_ATTACH_WAIT
[  565.362775] pending state change SNK_ATTACH_WAIT -> SNK_DEBOUNCED @ 200 =
ms
[  565.565761] state change SNK_ATTACH_WAIT -> SNK_DEBOUNCED [delayed 200 m=
s]
[  565.565797] state change SNK_DEBOUNCED -> SNK_ATTACHED
[  565.565807] polarity 0
[  565.567832] Requesting mux state 1, usb-role 2, orientation 1
[  565.568544] state change SNK_ATTACHED -> SNK_STARTUP
[  565.568567] state change SNK_STARTUP -> SNK_DISCOVERY
[  565.568591] Setting voltage/current limit 5000 mV 0 mA
[  565.568602] vbus=3D0 charge:=3D1
[  565.569961] state change SNK_DISCOVERY -> SNK_WAIT_CAPABILITIES
[  565.570651] pending state change SNK_WAIT_CAPABILITIES -> HARD_RESET_SEN=
D @ 240 ms
[  565.813787] state change SNK_WAIT_CAPABILITIES -> HARD_RESET_SEND [delay=
ed 240 ms]
[  565.813817] PD TX, type: 0x5
[  565.818135] PD TX complete, status: 0
[  565.818238] state change HARD_RESET_SEND -> HARD_RESET_START
[  565.820586] state change HARD_RESET_START -> SNK_HARD_RESET_SINK_OFF
[  565.820611] vconn:=3D0
[  565.823265] vbus=3D0 charge:=3D0
[  565.828697] Requesting mux state 1, usb-role 2, orientation 1
[  565.830910] pending state change SNK_HARD_RESET_SINK_OFF -> SNK_HARD_RES=
ET_SINK_ON @ 650 ms
[  565.837525] Setting voltage/current limit 0 mV 0 mA
[  565.837673] polarity 0
[  565.839715] Requesting mux state 0, usb-role 0, orientation 0
[  565.841235] state change SNK_HARD_RESET_SINK_OFF -> SNK_UNATTACHED
[  565.842167] CC1: 3 -> 3, CC2: 0 -> 0 [state SNK_UNATTACHED, polarity 0, =
connected]
[  565.842188] state change SNK_UNATTACHED -> SNK_ATTACH_WAIT
[  565.842221] state change SNK_ATTACH_WAIT -> PORT_RESET
[  565.848450] Setting voltage/current limit 0 mV 0 mA
[  565.848475] polarity 0
[  565.850847] Requesting mux state 0, usb-role 0, orientation 0
[  565.851570] cc:=3D0
[  565.852307] pending state change PORT_RESET -> PORT_RESET_WAIT_OFF @ 100=
 ms
[  565.855180] CC1: 3 -> 0, CC2: 0 -> 0 [state PORT_RESET, polarity 0, disc=
onnected]
[  565.855214] state change PORT_RESET -> SNK_UNATTACHED
[  565.855253] Start DRP toggling
[  565.860451] CC1: 0 -> 3, CC2: 0 -> 0 [state DRP_TOGGLING, polarity 0, co=
nnected]
[  565.860480] state change DRP_TOGGLING -> SNK_ATTACH_WAIT
[  565.860520] pending state change SNK_ATTACH_WAIT -> SNK_DEBOUNCED @ 200 =
ms
[  566.061736] state change SNK_ATTACH_WAIT -> SNK_DEBOUNCED [delayed 200 m=
s]
[  566.061767] state change SNK_DEBOUNCED -> SNK_ATTACHED
[  566.061775] polarity 0
[  566.063833] Requesting mux state 1, usb-role 2, orientation 1
[  566.064551] state change SNK_ATTACHED -> SNK_STARTUP
[  566.064570] state change SNK_STARTUP -> SNK_DISCOVERY
[  566.064581] Setting voltage/current limit 5000 mV 0 mA
[  566.064590] vbus=3D0 charge:=3D1
[  566.065949] state change SNK_DISCOVERY -> SNK_WAIT_CAPABILITIES
[  566.066641] pending state change SNK_WAIT_CAPABILITIES -> SOFT_RESET_SEN=
D @ 240 ms
[  566.309824] state change SNK_WAIT_CAPABILITIES -> SOFT_RESET_SEND [delay=
ed 240 ms]
[  566.309854] PD TX, header: 0x8d
[  566.319938] PD TX complete, status: 2
[  566.320007] state change SOFT_RESET_SEND -> HARD_RESET_SEND
[  566.320019] PD TX, type: 0x5
[  566.324321] PD TX complete, status: 0
[  566.324430] state change HARD_RESET_SEND -> HARD_RESET_START
[  566.326885] state change HARD_RESET_START -> SNK_HARD_RESET_SINK_OFF
[  566.326909] vconn:=3D0
[  566.329797] vbus=3D0 charge:=3D0
[  566.335128] Requesting mux state 1, usb-role 2, orientation 1
[  566.336565] pending state change SNK_HARD_RESET_SINK_OFF -> SNK_HARD_RES=
ET_SINK_ON @ 650 ms
[  566.342930] Setting voltage/current limit 0 mV 0 mA
[  566.342956] polarity 0
[  566.344941] Requesting mux state 0, usb-role 0, orientation 0
[  566.346586] state change SNK_HARD_RESET_SINK_OFF -> SNK_UNATTACHED
[  566.347405] CC1: 3 -> 3, CC2: 0 -> 0 [state SNK_UNATTACHED, polarity 0, =
connected]
[  566.347432] state change SNK_UNATTACHED -> SNK_ATTACH_WAIT
[  566.347465] state change SNK_ATTACH_WAIT -> PORT_RESET
[  566.352157] Setting voltage/current limit 0 mV 0 mA
[  566.352182] polarity 0
[  566.354530] Requesting mux state 0, usb-role 0, orientation 0
[  566.355274] cc:=3D0
[  566.356035] pending state change PORT_RESET -> PORT_RESET_WAIT_OFF @ 100=
 ms
[  566.359164] CC1: 3 -> 0, CC2: 0 -> 0 [state PORT_RESET, polarity 0, disc=
onnected]
[  566.359198] state change PORT_RESET -> SNK_UNATTACHED
[  566.359240] Start DRP toggling
[  566.364575] CC1: 0 -> 3, CC2: 0 -> 0 [state DRP_TOGGLING, polarity 0, co=
nnected]
[  566.364607] state change DRP_TOGGLING -> SNK_ATTACH_WAIT
[  566.364646] pending state change SNK_ATTACH_WAIT -> SNK_DEBOUNCED @ 200 =
ms
[  566.565769] state change SNK_ATTACH_WAIT -> SNK_DEBOUNCED [delayed 200 m=
s]
[  566.565797] state change SNK_DEBOUNCED -> SNK_ATTACHED
[  566.565806] polarity 0
[  566.568370] Requesting mux state 1, usb-role 2, orientation 1
[  566.569046] state change SNK_ATTACHED -> SNK_STARTUP
[  566.569064] state change SNK_STARTUP -> SNK_DISCOVERY
[  566.569074] Setting voltage/current limit 5000 mV 0 mA
[  566.569083] vbus=3D0 charge:=3D1
[  566.570939] state change SNK_DISCOVERY -> SNK_WAIT_CAPABILITIES
[  566.571660] pending state change SNK_WAIT_CAPABILITIES -> SOFT_RESET_SEN=
D @ 240 ms
[  566.813804] state change SNK_WAIT_CAPABILITIES -> SOFT_RESET_SEND [delay=
ed 240 ms]
[  566.813834] PD TX, header: 0x8d
[  566.824392] PD TX complete, status: 2
[  566.824461] state change SOFT_RESET_SEND -> SNK_UNATTACHED
[  566.827325] Setting voltage/current limit 0 mV 0 mA
[  566.827349] polarity 0
[  566.829479] Requesting mux state 0, usb-role 0, orientation 0
[  566.830186] Start DRP toggling
[  566.834009] state change SNK_UNATTACHED -> DRP_TOGGLING
[  566.837862] CC1: 3 -> 3, CC2: 0 -> 0 [state DRP_TOGGLING, polarity 0, co=
nnected]
[  566.837895] state change DRP_TOGGLING -> SNK_ATTACH_WAIT
[  566.837936] pending state change SNK_ATTACH_WAIT -> SNK_DEBOUNCED @ 200 =
ms
[  567.041827] state change SNK_ATTACH_WAIT -> SNK_DEBOUNCED [delayed 200 m=
s]
[  567.041856] state change SNK_DEBOUNCED -> SNK_ATTACHED
[  567.041865] polarity 0
[  567.043932] Requesting mux state 1, usb-role 2, orientation 1
[  567.045164] state change SNK_ATTACHED -> SNK_STARTUP
[  567.045187] state change SNK_STARTUP -> SNK_DISCOVERY
[  567.045199] Setting voltage/current limit 5000 mV 0 mA
[  567.045208] vbus=3D0 charge:=3D1
[  567.046615] state change SNK_DISCOVERY -> SNK_WAIT_CAPABILITIES
[  567.047289] pending state change SNK_WAIT_CAPABILITIES -> SNK_READY @ 24=
0 ms
[  567.289820] state change SNK_WAIT_CAPABILITIES -> SNK_READY [delayed 240=
 ms]



=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
Now the log from the new Kernel 5.15.74:
USB-PD Init:
------------

[  256.784494] Setting usb_comm capable false
[  256.791647] Setting voltage/current limit 0 mV 0 mA
[  256.794207] polarity 0
[  256.809727] Requesting mux state 0, usb-role 0, orientation 0
[  256.837483] state change INVALID_STATE -> SNK_UNATTACHED [rev1 NONE_AMS]
[  256.846618] CC1: 0 -> 0, CC2: 0 -> 0 [state SNK_UNATTACHED, polarity 0, =
disconnected]
[  256.846836] Setting usb_comm capable false
[  256.846766] 3-0050: registered
[  256.856301] Setting voltage/current limit 0 mV 0 mA
[  256.857922] polarity 0
[  256.865372] Requesting mux state 0, usb-role 0, orientation 0
[  256.872658] cc:=3D0
[  256.875081] pending state change PORT_RESET -> PORT_RESET_WAIT_OFF @ 100=
 ms [rev1 NONE_AMS]
[  256.876241] state change PORT_RESET -> PORT_RESET_WAIT_OFF [delayed 100 =
ms]
[  256.876283] state change PORT_RESET_WAIT_OFF -> SNK_UNATTACHED [rev1 NON=
E_AMS]
[  256.876306] Start toggling
[  256.893542] CC1: 0 -> 0, CC2: 0 -> 0 [state TOGGLING, polarity 0, discon=
nected]


USB-A to USB-C Cable attach event:
----------------------------------

[  446.745172] IPv6: ADDRCONF(NETDEV_CHANGE): usb1: link becomes ready
[  446.347606] VBUS on
[  446.359827] VBUS on
[  446.365643] VBUS on
[  446.443772] CC1: 0 -> 3, CC2: 0 -> 0 [state TOGGLING, polarity 0, connec=
ted]
[  446.443853] state change TOGGLING -> SNK_ATTACH_WAIT [rev1 NONE_AMS]
[  446.443975] pending state change SNK_ATTACH_WAIT -> SNK_DEBOUNCED @ 200 =
ms [rev1 NONE_AMS]
[  446.647478] state change SNK_ATTACH_WAIT -> SNK_DEBOUNCED [delayed 200 m=
s]
[  446.647634] state change SNK_DEBOUNCED -> SNK_ATTACHED [rev1 NONE_AMS]
[  446.647687] polarity 0
[  446.660017] Requesting mux state 1, usb-role 2, orientation 1
[  446.665130] state change SNK_ATTACHED -> SNK_STARTUP [rev1 NONE_AMS]
[  446.665218] state change SNK_STARTUP -> SNK_DISCOVERY [rev3 NONE_AMS]
[  446.665635] Setting voltage/current limit 5000 mV 0 mA
[  446.665810] vbus=3D0 charge:=3D1
[  446.670562] state change SNK_DISCOVERY -> SNK_WAIT_CAPABILITIES [rev3 NO=
NE_AMS]
[  446.672741] pending state change SNK_WAIT_CAPABILITIES -> HARD_RESET_SEN=
D @ 310 ms [rev3 NONE_AMS]
[  446.983091] state change SNK_WAIT_CAPABILITIES -> HARD_RESET_SEND [delay=
ed 310 ms]
[  446.983189] AMS HARD_RESET start
[  446.983210] PD TX, type: 0x5
[  446.992857] PD TX complete, status: 0
[  446.994940] state change HARD_RESET_SEND -> HARD_RESET_START [rev3 HARD_=
RESET]
[  447.007365] state change HARD_RESET_START -> SNK_HARD_RESET_SINK_OFF [re=
v3 HARD_RESET]
[  447.007412] vconn:=3D0
[  447.008918] Requesting mux state 1, usb-role 2, orientation 1
[  447.014308] pending state change SNK_HARD_RESET_SINK_OFF -> SNK_HARD_RES=
ET_SINK_ON @ 650 ms [rev3 HARD_RESET]
[  447.664993] state change SNK_HARD_RESET_SINK_OFF -> SNK_HARD_RESET_SINK_=
ON [delayed 650 ms]
[  447.665082] AMS HARD_RESET finished
[  447.671853] state change SNK_HARD_RESET_SINK_ON -> SNK_STARTUP [rev3 NON=
E_AMS]
[  447.671932] state change SNK_STARTUP -> SNK_DISCOVERY [rev3 NONE_AMS]
[  447.671987] Setting voltage/current limit 5000 mV 0 mA
[  447.672176] state change SNK_DISCOVERY -> SNK_WAIT_CAPABILITIES [rev3 NO=
NE_AMS]
[  447.674498] pending state change SNK_WAIT_CAPABILITIES -> HARD_RESET_SEN=
D @ 310 ms [rev3 NONE_AMS]
[  447.985276] state change SNK_WAIT_CAPABILITIES -> HARD_RESET_SEND [delay=
ed 310 ms]
[  447.985359] AMS HARD_RESET start
[  447.985406] PD TX, type: 0x5
[  448.010616] PD TX complete, status: 0
[  448.011377] state change HARD_RESET_SEND -> HARD_RESET_START [rev3 HARD_=
RESET]
[  448.031719] state change HARD_RESET_START -> SNK_HARD_RESET_SINK_OFF [re=
v3 HARD_RESET]
[  448.031797] vconn:=3D0
[  448.034634] Requesting mux state 1, usb-role 2, orientation 1
[  448.044759] pending state change SNK_HARD_RESET_SINK_OFF -> SNK_HARD_RES=
ET_SINK_ON @ 650 ms [rev3 HARD_RESET]
[  448.695410] state change SNK_HARD_RESET_SINK_OFF -> SNK_HARD_RESET_SINK_=
ON [delayed 650 ms]
[  448.695503] AMS HARD_RESET finished
[  448.702988] state change SNK_HARD_RESET_SINK_ON -> SNK_STARTUP [rev3 NON=
E_AMS]
[  448.703071] state change SNK_STARTUP -> SNK_DISCOVERY [rev3 NONE_AMS]
[  448.703123] Setting voltage/current limit 5000 mV 0 mA
[  448.703257] state change SNK_DISCOVERY -> SNK_WAIT_CAPABILITIES [rev3 NO=
NE_AMS]
[  448.705602] pending state change SNK_WAIT_CAPABILITIES -> SNK_READY @ 31=
0 ms [rev3 NONE_AMS]
[  449.016365] state change SNK_WAIT_CAPABILITIES -> SNK_READY [delayed 310=
 ms]

### ISR is blocking the system at this point. Only after detaching the cabl=
e was I able to read the log

[  463.230666] CC1: 3 -> 0, CC2: 0 -> 0 [state SNK_READY, polarity 0, disco=
nnected]
[  463.230768] state change SNK_READY -> SNK_UNATTACHED [rev3 NONE_AMS]
[  463.292143] Start toggling
[  463.352318] CC1: 0 -> 0, CC2: 0 -> 0 [state SNK_UNATTACHED, polarity 0, =
disconnected]
[  463.353156] Setting usb_comm capable false
[  463.368588] Setting voltage/current limit 0 mV 0 mA
[  463.368710] polarity 0
[  463.381744] Requesting mux state 0, usb-role 0, orientation 0
[  463.390057] cc:=3D0
[  463.395516] pending state change PORT_RESET -> PORT_RESET_WAIT_OFF @ 100=
 ms [rev3 NONE_AMS]
[  463.395680] state change PORT_RESET -> PORT_RESET_WAIT_OFF [delayed 100 =
ms]
[  463.395733] state change PORT_RESET_WAIT_OFF -> SNK_UNATTACHED [rev3 NON=
E_AMS]
[  463.395786] Start toggling
[  463.412692] CC1: 0 -> 0, CC2: 0 -> 0 [state TOGGLING, polarity 0, discon=
nected]
[  463.418218] CC1: 0 -> 0, CC2: 0 -> 0 [state TOGGLING, polarity 0, discon=
nected]


USB-PD capable power supply attach event:
-----------------------------------------

[  826.768426] CC1: 0 -> 5, CC2: 0 -> 0 [state TOGGLING, polarity 0, connec=
ted]
[  826.768509] state change TOGGLING -> SNK_ATTACH_WAIT [rev3 HARD_RESET]
[  826.768627] pending state change SNK_ATTACH_WAIT -> SNK_DEBOUNCED @ 200 =
ms [rev3 HARD_RESET]
[  826.893156] VBUS on
[  826.904557] VBUS on
[  826.910508] VBUS on
[  826.971690] state change SNK_ATTACH_WAIT -> SNK_DEBOUNCED [delayed 200 m=
s]
[  826.971726] state change SNK_DEBOUNCED -> SNK_ATTACHED [rev3 HARD_RESET]
[  826.971741] polarity 0
[  826.980352] Requesting mux state 1, usb-role 2, orientation 1
[  826.981887] state change SNK_ATTACHED -> SNK_STARTUP [rev3 HARD_RESET]
[  826.981917] state change SNK_STARTUP -> SNK_DISCOVERY [rev3 HARD_RESET]
[  826.981935] Setting voltage/current limit 5000 mV 3000 mA
[  826.982003] vbus=3D0 charge:=3D1
[  826.984458] state change SNK_DISCOVERY -> SNK_WAIT_CAPABILITIES [rev3 HA=
RD_RESET]
[  826.985671] pending state change SNK_WAIT_CAPABILITIES -> HARD_RESET_SEN=
D @ 310 ms [rev3 HARD_RESET]
[  827.108627] PD RX, header: 0x61a1 [1]
[  827.108711]  PDO 0: type 0, 5000 mV, 3000 mA [DE]
[  827.108760]  PDO 1: type 0, 9000 mV, 3000 mA []
[  827.108801]  PDO 2: type 0, 12000 mV, 3000 mA []
[  827.108841]  PDO 3: type 0, 15000 mV, 3000 mA []
[  827.108881]  PDO 4: type 0, 18900 mV, 3000 mA []
[  827.108921]  PDO 5: type 0, 20000 mV, 3000 mA []
[  827.108957] state change SNK_WAIT_CAPABILITIES -> SNK_NEGOTIATE_CAPABILI=
TIES [rev3 POWER_NEGOTIATION]
[  827.109079] Setting usb_comm capable false
[  827.109216] cc=3D0 cc1=3D5 cc2=3D0 vbus=3D0 vconn=3Dsink polarity=3D0
[  827.109263] Requesting PDO 5: 20000 mV, 3000 mA
[  827.109298] PD TX, header: 0x1082
[  827.159596] Setting usb_comm capable false
[  827.169005] Setting voltage/current limit 0 mV 0 mA
[  827.169099] polarity 0
[  827.182015] Requesting mux state 0, usb-role 0, orientation 0
[  827.192980] state change SNK_NEGOTIATE_CAPABILITIES -> SNK_UNATTACHED [r=
ev3 NONE_AMS]
[  827.198398] CC1: 5 -> 5, CC2: 0 -> 0 [state SNK_UNATTACHED, polarity 0, =
connected]
[  827.198464] state change SNK_UNATTACHED -> SNK_ATTACH_WAIT [rev3 NONE_AM=
S]
[  827.198499] state change SNK_ATTACH_WAIT -> PORT_RESET [rev3 NONE_AMS]
[  827.198540] PD TX complete, status: 2
[  827.198852] state change PORT_RESET -> SNK_WAIT_CAPABILITIES [rev3 NONE_=
AMS]
[  827.201434] pending state change SNK_WAIT_CAPABILITIES -> HARD_RESET_SEN=
D @ 310 ms [rev3 NONE_AMS]
[  827.201597] Received hard reset
[  827.201625] state change SNK_WAIT_CAPABILITIES -> HARD_RESET_START [rev3=
 HARD_RESET]
[  827.209157] state change HARD_RESET_START -> SNK_HARD_RESET_SINK_OFF [re=
v3 HARD_RESET]
[  827.209224] vconn:=3D0
[  827.212481] Requesting mux state 1, usb-role 2, orientation 1
[  827.215281] pending state change SNK_HARD_RESET_SINK_OFF -> SNK_HARD_RES=
ET_SINK_ON @ 650 ms [rev3 HARD_RESET]
[  827.868854] state change SNK_HARD_RESET_SINK_OFF -> SNK_HARD_RESET_SINK_=
ON [delayed 650 ms]
[  827.868923] AMS HARD_RESET finished
[  827.871858] state change SNK_HARD_RESET_SINK_ON -> SNK_STARTUP [rev3 NON=
E_AMS]
[  827.871918] state change SNK_STARTUP -> SNK_DISCOVERY [rev3 NONE_AMS]
[  827.871956] pending state change SNK_DISCOVERY -> HARD_RESET_SEND @ 1000=
0 ms [rev3 NONE_AMS]
[  827.961711] VBUS on
[  827.961769] state change SNK_DISCOVERY -> SNK_DISCOVERY [rev3 NONE_AMS]
[  827.961898] Setting voltage/current limit 5000 mV 3000 mA
[  827.962048] vbus=3D0 charge:=3D1
[  827.972701] state change SNK_DISCOVERY -> SNK_WAIT_CAPABILITIES [rev3 NO=
NE_AMS]
[  827.975008] pending state change SNK_WAIT_CAPABILITIES -> HARD_RESET_SEN=
D @ 310 ms [rev3 NONE_AMS]
[  827.983446] VBUS on
[  827.986223] VBUS on
[  827.997210] VBUS on
[  828.175355] PD RX, header: 0x61a1 [0]
[  828.181699] Received hard reset
[  828.181749] state change SNK_WAIT_CAPABILITIES -> HARD_RESET_START [rev3=
 HARD_RESET]
[  828.202553] state change HARD_RESET_START -> SNK_HARD_RESET_SINK_OFF [re=
v3 HARD_RESET]
[  828.202621] vconn:=3D0
[  828.205308] Requesting mux state 1, usb-role 2, orientation 1
[  828.214671] pending state change SNK_HARD_RESET_SINK_OFF -> SNK_HARD_RES=
ET_SINK_ON @ 650 ms [rev3 HARD_RESET]
[  828.229807] Setting usb_comm capable false
[  828.239381] Setting voltage/current limit 0 mV 0 mA
[  828.239534] polarity 0
[  828.252334] Requesting mux state 0, usb-role 0, orientation 0
[  828.263656] state change SNK_HARD_RESET_SINK_OFF -> SNK_UNATTACHED [rev3=
 NONE_AMS]
[  828.269095] CC1: 5 -> 5, CC2: 0 -> 0 [state SNK_UNATTACHED, polarity 0, =
connected]
[  828.269159] state change SNK_UNATTACHED -> SNK_ATTACH_WAIT [rev3 NONE_AM=
S]
[  828.269218] state change SNK_ATTACH_WAIT -> PORT_RESET [rev3 NONE_AMS]
[  828.269522] Setting usb_comm capable false
[  828.279409] Setting voltage/current limit 0 mV 0 mA
[  828.279506] polarity 0
[  828.292304] Requesting mux state 0, usb-role 0, orientation 0
[  828.300793] cc:=3D0
[  828.305888] pending state change PORT_RESET -> PORT_RESET_WAIT_OFF @ 100=
 ms [rev3 NONE_AMS]
[  828.306038] state change PORT_RESET -> PORT_RESET_WAIT_OFF [delayed 100 =
ms]
[  828.306079] state change PORT_RESET_WAIT_OFF -> SNK_UNATTACHED [rev3 NON=
E_AMS]
[  828.306117] Start toggling
[  828.310980] state change SNK_UNATTACHED -> TOGGLING [rev3 NONE_AMS]
[  828.322643] CC1: 5 -> 5, CC2: 0 -> 0 [state TOGGLING, polarity 0, connec=
ted]
[  828.322713] state change TOGGLING -> SNK_ATTACH_WAIT [rev3 NONE_AMS]
[  828.322837] pending state change SNK_ATTACH_WAIT -> SNK_DEBOUNCED @ 200 =
ms [rev3 NONE_AMS]
[  828.526334] state change SNK_ATTACH_WAIT -> SNK_DEBOUNCED [delayed 200 m=
s]
[  829.027912] VBUS on
[  829.027969] state change SNK_DEBOUNCED -> SNK_ATTACHED [rev3 NONE_AMS]
[  829.028081] polarity 0
[  829.052206] Requesting mux state 1, usb-role 2, orientation 1
[  829.055175] state change SNK_ATTACHED -> SNK_STARTUP [rev3 NONE_AMS]
[  829.055233] state change SNK_STARTUP -> SNK_DISCOVERY [rev3 NONE_AMS]
[  829.055273] Setting voltage/current limit 5000 mV 3000 mA
[  829.055419] vbus=3D0 charge:=3D1
[  829.059645] state change SNK_DISCOVERY -> SNK_WAIT_CAPABILITIES [rev3 NO=
NE_AMS]
[  829.062077] pending state change SNK_WAIT_CAPABILITIES -> SNK_READY @ 31=
0 ms [rev3 NONE_AMS]
[  829.064903] VBUS on
[  829.241900] PD RX, header: 0x61a1 [1]
[  829.241980]  PDO 0: type 0, 5000 mV, 3000 mA [DE]
[  829.242025]  PDO 1: type 0, 9000 mV, 3000 mA []
[  829.242066]  PDO 2: type 0, 12000 mV, 3000 mA []
[  829.242107]  PDO 3: type 0, 15000 mV, 3000 mA []
[  829.242147]  PDO 4: type 0, 18900 mV, 3000 mA []
[  829.242187]  PDO 5: type 0, 20000 mV, 3000 mA []
[  829.242223] state change SNK_WAIT_CAPABILITIES -> SNK_NEGOTIATE_CAPABILI=
TIES [rev3 POWER_NEGOTIATION]
[  829.242346] Setting usb_comm capable false
[  829.242487] cc=3D0 cc1=3D5 cc2=3D0 vbus=3D0 vconn=3Dsink polarity=3D0
[  829.242531] Requesting PDO 5: 20000 mV, 3000 mA
[  829.242567] PD TX, header: 0x1082
[  829.293636] Setting usb_comm capable false
[  829.303004] Setting voltage/current limit 0 mV 0 mA
[  829.303099] polarity 0
[  829.315711] Requesting mux state 0, usb-role 0, orientation 0
[  829.326763] state change SNK_NEGOTIATE_CAPABILITIES -> SNK_UNATTACHED [r=
ev3 NONE_AMS]
[  829.332550] CC1: 5 -> 5, CC2: 0 -> 0 [state SNK_UNATTACHED, polarity 0, =
connected]
[  829.332619] state change SNK_UNATTACHED -> SNK_ATTACH_WAIT [rev3 NONE_AM=
S]
[  829.332654] state change SNK_ATTACH_WAIT -> PORT_RESET [rev3 NONE_AMS]
[  829.332692] PD TX complete, status: 2
[  829.333002] state change PORT_RESET -> SNK_WAIT_CAPABILITIES [rev3 NONE_=
AMS]
[  829.335248] pending state change SNK_WAIT_CAPABILITIES -> HARD_RESET_SEN=
D @ 310 ms [rev3 NONE_AMS]
[  829.335405] Received hard reset
[  829.335433] state change SNK_WAIT_CAPABILITIES -> HARD_RESET_START [rev3=
 HARD_RESET]
[  829.343489] state change HARD_RESET_START -> SNK_HARD_RESET_SINK_OFF [re=
v3 HARD_RESET]
[  829.343548] vconn:=3D0
[  829.346261] Requesting mux state 1, usb-role 2, orientation 1
[  829.349054] pending state change SNK_HARD_RESET_SINK_OFF -> SNK_HARD_RES=
ET_SINK_ON @ 650 ms [rev3 HARD_RESET]
[  830.002616] state change SNK_HARD_RESET_SINK_OFF -> SNK_HARD_RESET_SINK_=
ON [delayed 650 ms]
[  830.002685] AMS HARD_RESET finished
[  830.005098] state change SNK_HARD_RESET_SINK_ON -> SNK_STARTUP [rev3 NON=
E_AMS]
[  830.005156] state change SNK_STARTUP -> SNK_DISCOVERY [rev3 NONE_AMS]
[  830.005197] pending state change SNK_DISCOVERY -> HARD_RESET_SEND @ 1000=
0 ms [rev3 NONE_AMS]
[  830.092822] VBUS on
[  830.092880] state change SNK_DISCOVERY -> SNK_DISCOVERY [rev3 NONE_AMS]
[  830.093011] Setting voltage/current limit 5000 mV 3000 mA
[  830.093162] vbus=3D0 charge:=3D1
[  830.103484] state change SNK_DISCOVERY -> SNK_WAIT_CAPABILITIES [rev3 NO=
NE_AMS]
[  830.105769] pending state change SNK_WAIT_CAPABILITIES -> HARD_RESET_SEN=
D @ 310 ms [rev3 NONE_AMS]
[  830.114579] VBUS on
[  830.117251] VBUS on
[  830.128552] VBUS on
[  830.308729] PD RX, header: 0x61a1 [0]
[  830.315066] Received hard reset
[  830.315115] state change SNK_WAIT_CAPABILITIES -> HARD_RESET_START [rev3=
 HARD_RESET]
[  830.335975] state change HARD_RESET_START -> SNK_HARD_RESET_SINK_OFF [re=
v3 HARD_RESET]
[  830.336043] vconn:=3D0
[  830.338846] Requesting mux state 1, usb-role 2, orientation 1
[  830.348224] pending state change SNK_HARD_RESET_SINK_OFF -> SNK_HARD_RES=
ET_SINK_ON @ 650 ms [rev3 HARD_RESET]
[  830.363848] Setting usb_comm capable false
[  830.373342] Setting voltage/current limit 0 mV 0 mA
[  830.373492] polarity 0
[  830.386127] Requesting mux state 0, usb-role 0, orientation 0
[  830.397083] state change SNK_HARD_RESET_SINK_OFF -> SNK_UNATTACHED [rev3=
 NONE_AMS]
[  830.402808] CC1: 5 -> 5, CC2: 0 -> 0 [state SNK_UNATTACHED, polarity 0, =
connected]
[  830.402878] state change SNK_UNATTACHED -> SNK_ATTACH_WAIT [rev3 NONE_AM=
S]
[  830.402936] state change SNK_ATTACH_WAIT -> PORT_RESET [rev3 NONE_AMS]
[  830.403243] Setting usb_comm capable false
[  830.412686] Setting voltage/current limit 0 mV 0 mA
[  830.412787] polarity 0
[  830.425143] Requesting mux state 0, usb-role 0, orientation 0
[  830.433883] cc:=3D0
[  830.438861] pending state change PORT_RESET -> PORT_RESET_WAIT_OFF @ 100=
 ms [rev3 NONE_AMS]
[  830.439010] state change PORT_RESET -> PORT_RESET_WAIT_OFF [delayed 100 =
ms]
[  830.439050] state change PORT_RESET_WAIT_OFF -> SNK_UNATTACHED [rev3 NON=
E_AMS]
[  830.439087] Start toggling
[  830.444098] state change SNK_UNATTACHED -> TOGGLING [rev3 NONE_AMS]
[  830.455846] CC1: 5 -> 5, CC2: 0 -> 0 [state TOGGLING, polarity 0, connec=
ted]
[  830.455917] state change TOGGLING -> SNK_ATTACH_WAIT [rev3 NONE_AMS]
[  830.456045] pending state change SNK_ATTACH_WAIT -> SNK_DEBOUNCED @ 200 =
ms [rev3 NONE_AMS]
[  830.659546] state change SNK_ATTACH_WAIT -> SNK_DEBOUNCED [delayed 200 m=
s]
[  831.160863] VBUS on
[  831.160920] state change SNK_DEBOUNCED -> SNK_ATTACHED [rev3 NONE_AMS]
[  831.161028] polarity 0
[  831.185034] Requesting mux state 1, usb-role 2, orientation 1
[  831.188004] state change SNK_ATTACHED -> SNK_STARTUP [rev3 NONE_AMS]
[  831.188062] state change SNK_STARTUP -> SNK_DISCOVERY [rev3 NONE_AMS]
[  831.188102] Setting voltage/current limit 5000 mV 3000 mA
[  831.188250] vbus=3D0 charge:=3D1
[  831.192929] state change SNK_DISCOVERY -> SNK_WAIT_CAPABILITIES [rev3 NO=
NE_AMS]
[  831.195063] pending state change SNK_WAIT_CAPABILITIES -> SNK_READY @ 31=
0 ms [rev3 NONE_AMS]
[  831.197744] VBUS on
[  831.374580] PD RX, header: 0x61a1 [1]
[  831.374660]  PDO 0: type 0, 5000 mV, 3000 mA [DE]
[  831.374707]  PDO 1: type 0, 9000 mV, 3000 mA []
[  831.374748]  PDO 2: type 0, 12000 mV, 3000 mA []
[  831.374790]  PDO 3: type 0, 15000 mV, 3000 mA []
[  831.374830]  PDO 4: type 0, 18900 mV, 3000 mA []
[  831.374870]  PDO 5: type 0, 20000 mV, 3000 mA []
[  831.374906] state change SNK_WAIT_CAPABILITIES -> SNK_NEGOTIATE_CAPABILI=
TIES [rev3 POWER_NEGOTIATION]
[  831.375032] Setting usb_comm capable false
[  831.375177] cc=3D0 cc1=3D5 cc2=3D0 vbus=3D0 vconn=3Dsink polarity=3D0
[  831.375221] Requesting PDO 5: 20000 mV, 3000 mA
[  831.375258] PD TX, header: 0x1082
[  831.426768] Setting usb_comm capable false
[  831.436181] Setting voltage/current limit 0 mV 0 mA
[  831.436279] polarity 0
[  831.448776] Requesting mux state 0, usb-role 0, orientation 0
[  831.459690] state change SNK_NEGOTIATE_CAPABILITIES -> SNK_UNATTACHED [r=
ev3 NONE_AMS]
[  831.465398] CC1: 5 -> 5, CC2: 0 -> 0 [state SNK_UNATTACHED, polarity 0, =
connected]
[  831.465468] state change SNK_UNATTACHED -> SNK_ATTACH_WAIT [rev3 NONE_AM=
S]
[  831.465503] state change SNK_ATTACH_WAIT -> PORT_RESET [rev3 NONE_AMS]
[  831.465541] PD TX complete, status: 2
[  831.465853] state change PORT_RESET -> SNK_WAIT_CAPABILITIES [rev3 NONE_=
AMS]
[  831.468123] pending state change SNK_WAIT_CAPABILITIES -> HARD_RESET_SEN=
D @ 310 ms [rev3 NONE_AMS]
[  831.468279] Received hard reset
[  831.468308] state change SNK_WAIT_CAPABILITIES -> HARD_RESET_START [rev3=
 HARD_RESET]
[  831.476495] state change HARD_RESET_START -> SNK_HARD_RESET_SINK_OFF [re=
v3 HARD_RESET]
[  831.476558] vconn:=3D0
[  831.479360] Requesting mux state 1, usb-role 2, orientation 1
[  831.482403] pending state change SNK_HARD_RESET_SINK_OFF -> SNK_HARD_RES=
ET_SINK_ON @ 650 ms [rev3 HARD_RESET]
[  832.135981] state change SNK_HARD_RESET_SINK_OFF -> SNK_HARD_RESET_SINK_=
ON [delayed 650 ms]
[  832.136053] AMS HARD_RESET finished
[  832.138377] state change SNK_HARD_RESET_SINK_ON -> SNK_STARTUP [rev3 NON=
E_AMS]
[  832.138433] state change SNK_STARTUP -> SNK_DISCOVERY [rev3 NONE_AMS]
[  832.138472] pending state change SNK_DISCOVERY -> HARD_RESET_SEND @ 1000=
0 ms [rev3 NONE_AMS]
[  832.228209] VBUS on
[  832.228265] state change SNK_DISCOVERY -> SNK_DISCOVERY [rev3 NONE_AMS]
[  832.228395] Setting voltage/current limit 5000 mV 3000 mA
[  832.228544] vbus=3D0 charge:=3D1
[  832.239282] state change SNK_DISCOVERY -> SNK_WAIT_CAPABILITIES [rev3 NO=
NE_AMS]
[  832.241912] pending state change SNK_WAIT_CAPABILITIES -> HARD_RESET_SEN=
D @ 310 ms [rev3 NONE_AMS]
[  832.250466] VBUS on
[  832.253173] VBUS on
[  832.264235] VBUS on
[  832.442716] PD RX, header: 0x61a1 [0]
[  832.448663] Received hard reset
[  832.448708] state change SNK_WAIT_CAPABILITIES -> HARD_RESET_START [rev3=
 HARD_RESET]
[  832.469385] state change HARD_RESET_START -> SNK_HARD_RESET_SINK_OFF [re=
v3 HARD_RESET]
[  832.469449] vconn:=3D0
[  832.472224] Requesting mux state 1, usb-role 2, orientation 1
[  832.481771] pending state change SNK_HARD_RESET_SINK_OFF -> SNK_HARD_RES=
ET_SINK_ON @ 650 ms [rev3 HARD_RESET]
[  832.496945] Setting usb_comm capable false
[  832.506399] Setting voltage/current limit 0 mV 0 mA
[  832.506554] polarity 0
[  832.519367] Requesting mux state 0, usb-role 0, orientation 0
[  832.530881] state change SNK_HARD_RESET_SINK_OFF -> SNK_UNATTACHED [rev3=
 NONE_AMS]
[  832.536387] CC1: 5 -> 5, CC2: 0 -> 0 [state SNK_UNATTACHED, polarity 0, =
connected]
[  832.536452] state change SNK_UNATTACHED -> SNK_ATTACH_WAIT [rev3 NONE_AM=
S]
[  832.536510] state change SNK_ATTACH_WAIT -> PORT_RESET [rev3 NONE_AMS]
[  832.536812] Setting usb_comm capable false
[  832.546428] Setting voltage/current limit 0 mV 0 mA
[  832.546527] polarity 0
[  832.559025] Requesting mux state 0, usb-role 0, orientation 0
[  832.567562] cc:=3D0
[  832.572992] pending state change PORT_RESET -> PORT_RESET_WAIT_OFF @ 100=
 ms [rev3 NONE_AMS]
[  832.573138] state change PORT_RESET -> PORT_RESET_WAIT_OFF [delayed 100 =
ms]
[  832.573179] state change PORT_RESET_WAIT_OFF -> SNK_UNATTACHED [rev3 NON=
E_AMS]
[  832.573219] Start toggling
[  832.577847] state change SNK_UNATTACHED -> TOGGLING [rev3 NONE_AMS]
[  832.589556] CC1: 5 -> 5, CC2: 0 -> 0 [state TOGGLING, polarity 0, connec=
ted]
[  832.589625] state change TOGGLING -> SNK_ATTACH_WAIT [rev3 NONE_AMS]
[  832.589754] pending state change SNK_ATTACH_WAIT -> SNK_DEBOUNCED @ 200 =
ms [rev3 NONE_AMS]
[  832.793127] state change SNK_ATTACH_WAIT -> SNK_DEBOUNCED [delayed 200 m=
s]
[  833.292447] VBUS on
[  833.292505] state change SNK_DEBOUNCED -> SNK_ATTACHED [rev3 NONE_AMS]
[  833.292615] polarity 0
[  833.316496] Requesting mux state 1, usb-role 2, orientation 1
[  833.319533] state change SNK_ATTACHED -> SNK_STARTUP [rev3 NONE_AMS]
[  833.319592] state change SNK_STARTUP -> SNK_DISCOVERY [rev3 NONE_AMS]
[  833.319630] Setting voltage/current limit 5000 mV 3000 mA
[  833.319781] vbus=3D0 charge:=3D1
[  833.324316] state change SNK_DISCOVERY -> SNK_WAIT_CAPABILITIES [rev3 NO=
NE_AMS]
[  833.326456] pending state change SNK_WAIT_CAPABILITIES -> SNK_READY @ 31=
0 ms [rev3 NONE_AMS]
[  833.329106] VBUS on
[  833.508682] PD RX, header: 0x61a1 [1]
[  833.508766]  PDO 0: type 0, 5000 mV, 3000 mA [DE]
[  833.508813]  PDO 1: type 0, 9000 mV, 3000 mA []
[  833.508855]  PDO 2: type 0, 12000 mV, 3000 mA []
[  833.508895]  PDO 3: type 0, 15000 mV, 3000 mA []
[  833.508935]  PDO 4: type 0, 18900 mV, 3000 mA []
[  833.508975]  PDO 5: type 0, 20000 mV, 3000 mA []
[  833.509011] state change SNK_WAIT_CAPABILITIES -> SNK_NEGOTIATE_CAPABILI=
TIES [rev3 POWER_NEGOTIATION]
[  833.509133] Setting usb_comm capable false
[  833.509274] cc=3D0 cc1=3D5 cc2=3D0 vbus=3D0 vconn=3Dsink polarity=3D0
[  833.509319] Requesting PDO 5: 20000 mV, 3000 mA
[  833.509356] PD TX, header: 0x1082
[  833.559278] Setting usb_comm capable false
[  833.568621] Setting voltage/current limit 0 mV 0 mA
[  833.568715] polarity 0
[  833.581360] Requesting mux state 0, usb-role 0, orientation 0
[  833.592425] state change SNK_NEGOTIATE_CAPABILITIES -> SNK_UNATTACHED [r=
ev3 NONE_AMS]
[  833.597768] CC1: 5 -> 5, CC2: 0 -> 0 [state SNK_UNATTACHED, polarity 0, =
connected]
[  833.597832] state change SNK_UNATTACHED -> SNK_ATTACH_WAIT [rev3 NONE_AM=
S]
[  833.597866] state change SNK_ATTACH_WAIT -> PORT_RESET [rev3 NONE_AMS]
[  833.597907] PD TX complete, status: 2
[  833.598219] state change PORT_RESET -> SNK_WAIT_CAPABILITIES [rev3 NONE_=
AMS]
[  833.600853] pending state change SNK_WAIT_CAPABILITIES -> HARD_RESET_SEN=
D @ 310 ms [rev3 NONE_AMS]
[  833.601013] Received hard reset
[  833.601042] state change SNK_WAIT_CAPABILITIES -> HARD_RESET_START [rev3=
 HARD_RESET]
[  833.608667] state change HARD_RESET_START -> SNK_HARD_RESET_SINK_OFF [re=
v3 HARD_RESET]
[  833.608724] vconn:=3D0
[  833.611758] Requesting mux state 1, usb-role 2, orientation 1
[  833.614525] pending state change SNK_HARD_RESET_SINK_OFF -> SNK_HARD_RES=
ET_SINK_ON @ 650 ms [rev3 HARD_RESET]
[  834.268087] state change SNK_HARD_RESET_SINK_OFF -> SNK_HARD_RESET_SINK_=
ON [delayed 650 ms]
[  834.268158] AMS HARD_RESET finished
[  834.270888] state change SNK_HARD_RESET_SINK_ON -> SNK_STARTUP [rev3 NON=
E_AMS]
[  834.270942] state change SNK_STARTUP -> SNK_DISCOVERY [rev3 NONE_AMS]
[  834.270978] pending state change SNK_DISCOVERY -> HARD_RESET_SEND @ 1000=
0 ms [rev3 NONE_AMS]
[  834.361893] VBUS on
[  834.361950] state change SNK_DISCOVERY -> SNK_DISCOVERY [rev3 NONE_AMS]
[  834.362079] Setting voltage/current limit 5000 mV 3000 mA
[  834.362232] vbus=3D0 charge:=3D1
[  834.373148] state change SNK_DISCOVERY -> SNK_WAIT_CAPABILITIES [rev3 NO=
NE_AMS]
[  834.375423] pending state change SNK_WAIT_CAPABILITIES -> HARD_RESET_SEN=
D @ 310 ms [rev3 NONE_AMS]
[  834.383993] VBUS on
[  834.386675] VBUS on
[  834.397691] VBUS on
[  834.576163] PD RX, header: 0x61a1 [0]
[  834.582359] Received hard reset
[  834.582406] state change SNK_WAIT_CAPABILITIES -> HARD_RESET_START [rev3=
 HARD_RESET]
[  834.602442] state change HARD_RESET_START -> SNK_HARD_RESET_SINK_OFF [re=
v3 HARD_RESET]
[  834.602503] vconn:=3D0
[  834.605196] Requesting mux state 1, usb-role 2, orientation 1
[  834.614511] pending state change SNK_HARD_RESET_SINK_OFF -> SNK_HARD_RES=
ET_SINK_ON @ 650 ms [rev3 HARD_RESET]
[  834.629493] Setting usb_comm capable false
[  834.638823] Setting voltage/current limit 0 mV 0 mA
[  834.638994] polarity 0
[  834.651863] Requesting mux state 0, usb-role 0, orientation 0
[  834.662953] state change SNK_HARD_RESET_SINK_OFF -> SNK_UNATTACHED [rev3=
 NONE_AMS]
[  834.668385] CC1: 5 -> 5, CC2: 0 -> 0 [state SNK_UNATTACHED, polarity 0, =
connected]
[  834.668462] state change SNK_UNATTACHED -> SNK_ATTACH_WAIT [rev3 NONE_AM=
S]
[  834.668523] state change SNK_ATTACH_WAIT -> PORT_RESET [rev3 NONE_AMS]
[  834.668852] Setting usb_comm capable false
[  834.678503] Setting voltage/current limit 0 mV 0 mA
[  834.678600] polarity 0
[  834.691321] Requesting mux state 0, usb-role 0, orientation 0
[  834.699426] cc:=3D0
[  834.704750] pending state change PORT_RESET -> PORT_RESET_WAIT_OFF @ 100=
 ms [rev3 NONE_AMS]
[  834.704893] state change PORT_RESET -> PORT_RESET_WAIT_OFF [delayed 100 =
ms]
[  834.704933] state change PORT_RESET_WAIT_OFF -> SNK_UNATTACHED [rev3 NON=
E_AMS]
[  834.704972] Start toggling
[  834.709557] state change SNK_UNATTACHED -> TOGGLING [rev3 NONE_AMS]
[  834.721353] CC1: 5 -> 5, CC2: 0 -> 0 [state TOGGLING, polarity 0, connec=
ted]
[  834.721424] state change TOGGLING -> SNK_ATTACH_WAIT [rev3 NONE_AMS]
[  834.721553] pending state change SNK_ATTACH_WAIT -> SNK_DEBOUNCED @ 200 =
ms [rev3 NONE_AMS]
[  834.925070] state change SNK_ATTACH_WAIT -> SNK_DEBOUNCED [delayed 200 m=
s]
[  835.428159] VBUS on
[  835.428217] state change SNK_DEBOUNCED -> SNK_ATTACHED [rev3 NONE_AMS]
[  835.428345] polarity 0
[  835.452702] Requesting mux state 1, usb-role 2, orientation 1
[  835.455663] state change SNK_ATTACHED -> SNK_STARTUP [rev3 NONE_AMS]
[  835.455720] state change SNK_STARTUP -> SNK_DISCOVERY [rev3 NONE_AMS]
[  835.455759] Setting voltage/current limit 5000 mV 3000 mA
[  835.455910] vbus=3D0 charge:=3D1
[  835.460564] state change SNK_DISCOVERY -> SNK_WAIT_CAPABILITIES [rev3 NO=
NE_AMS]
[  835.462704] pending state change SNK_WAIT_CAPABILITIES -> SNK_READY @ 31=
0 ms [rev3 NONE_AMS]
[  835.465371] VBUS on
[  835.642076] PD RX, header: 0x61a1 [1]
[  835.642159]  PDO 0: type 0, 5000 mV, 3000 mA [DE]
[  835.642205]  PDO 1: type 0, 9000 mV, 3000 mA []
[  835.642247]  PDO 2: type 0, 12000 mV, 3000 mA []
[  835.642287]  PDO 3: type 0, 15000 mV, 3000 mA []
[  835.642328]  PDO 4: type 0, 18900 mV, 3000 mA []
[  835.642368]  PDO 5: type 0, 20000 mV, 3000 mA []
[  835.642405] state change SNK_WAIT_CAPABILITIES -> SNK_NEGOTIATE_CAPABILI=
TIES [rev3 POWER_NEGOTIATION]
[  835.642528] Setting usb_comm capable false
[  835.642671] cc=3D0 cc1=3D5 cc2=3D0 vbus=3D0 vconn=3Dsink polarity=3D0
[  835.642716] Requesting PDO 5: 20000 mV, 3000 mA
[  835.642751] PD TX, header: 0x1082
[  835.693384] Setting usb_comm capable false
[  835.702717] Setting voltage/current limit 0 mV 0 mA
[  835.702814] polarity 0
[  835.715221] Requesting mux state 0, usb-role 0, orientation 0
[  835.726392] state change SNK_NEGOTIATE_CAPABILITIES -> SNK_UNATTACHED [r=
ev3 NONE_AMS]
[  835.732286] CC1: 5 -> 5, CC2: 0 -> 0 [state SNK_UNATTACHED, polarity 0, =
connected]
[  835.732362] state change SNK_UNATTACHED -> SNK_ATTACH_WAIT [rev3 NONE_AM=
S]
[  835.732403] state change SNK_ATTACH_WAIT -> PORT_RESET [rev3 NONE_AMS]
[  835.732449] PD TX complete, status: 2
[  835.732791] state change PORT_RESET -> SNK_WAIT_CAPABILITIES [rev3 NONE_=
AMS]
[  835.735053] pending state change SNK_WAIT_CAPABILITIES -> HARD_RESET_SEN=
D @ 310 ms [rev3 NONE_AMS]
[  835.735209] Received hard reset
[  835.735237] state change SNK_WAIT_CAPABILITIES -> HARD_RESET_START [rev3=
 HARD_RESET]
[  835.743140] state change HARD_RESET_START -> SNK_HARD_RESET_SINK_OFF [re=
v3 HARD_RESET]
[  835.743198] vconn:=3D0
[  835.745877] Requesting mux state 1, usb-role 2, orientation 1
[  835.748830] pending state change SNK_HARD_RESET_SINK_OFF -> SNK_HARD_RES=
ET_SINK_ON @ 650 ms [rev3 HARD_RESET]
[  836.402423] state change SNK_HARD_RESET_SINK_OFF -> SNK_HARD_RESET_SINK_=
ON [delayed 650 ms]
[  836.402492] AMS HARD_RESET finished
[  836.404809] state change SNK_HARD_RESET_SINK_ON -> SNK_STARTUP [rev3 NON=
E_AMS]
[  836.404861] state change SNK_STARTUP -> SNK_DISCOVERY [rev3 NONE_AMS]
[  836.404899] pending state change SNK_DISCOVERY -> HARD_RESET_SEND @ 1000=
0 ms [rev3 NONE_AMS]
[  836.492168] VBUS on
[  836.492229] state change SNK_DISCOVERY -> SNK_DISCOVERY [rev3 NONE_AMS]
[  836.492376] Setting voltage/current limit 5000 mV 3000 mA
[  836.492535] vbus=3D0 charge:=3D1
[  836.503274] state change SNK_DISCOVERY -> SNK_WAIT_CAPABILITIES [rev3 NO=
NE_AMS]
[  836.505544] pending state change SNK_WAIT_CAPABILITIES -> HARD_RESET_SEN=
D @ 310 ms [rev3 NONE_AMS]
[  836.514069] VBUS on
[  836.516750] VBUS on
[  836.527817] VBUS on
[  836.707649] PD RX, header: 0x61a1 [0]
[  836.713553] Received hard reset
[  836.713599] state change SNK_WAIT_CAPABILITIES -> HARD_RESET_START [rev3=
 HARD_RESET]
[  836.733083] state change HARD_RESET_START -> SNK_HARD_RESET_SINK_OFF [re=
v3 HARD_RESET]
[  836.733145] vconn:=3D0
[  836.735857] Requesting mux state 1, usb-role 2, orientation 1
[  836.744888] pending state change SNK_HARD_RESET_SINK_OFF -> SNK_HARD_RES=
ET_SINK_ON @ 650 ms [rev3 HARD_RESET]
[  836.760542] Setting usb_comm capable false
[  836.769399] Setting voltage/current limit 0 mV 0 mA
[  836.769563] polarity 0
[  836.782089] Requesting mux state 0, usb-role 0, orientation 0
[  836.792748] state change SNK_HARD_RESET_SINK_OFF -> SNK_UNATTACHED [rev3=
 NONE_AMS]
[  836.798194] CC1: 5 -> 5, CC2: 0 -> 0 [state SNK_UNATTACHED, polarity 0, =
connected]
[  836.798260] state change SNK_UNATTACHED -> SNK_ATTACH_WAIT [rev3 NONE_AM=
S]
[  836.798318] state change SNK_ATTACH_WAIT -> PORT_RESET [rev3 NONE_AMS]
[  836.798617] Setting usb_comm capable false
[  836.807762] Setting voltage/current limit 0 mV 0 mA
[  836.807855] polarity 0
[  836.819915] Requesting mux state 0, usb-role 0, orientation 0
[  836.828230] cc:=3D0
[  836.833634] pending state change PORT_RESET -> PORT_RESET_WAIT_OFF @ 100=
 ms [rev3 NONE_AMS]
[  836.833789] state change PORT_RESET -> PORT_RESET_WAIT_OFF [delayed 100 =
ms]
[  836.833829] state change PORT_RESET_WAIT_OFF -> SNK_UNATTACHED [rev3 NON=
E_AMS]
[  836.833868] Start toggling
[  836.838410] state change SNK_UNATTACHED -> TOGGLING [rev3 NONE_AMS]
[  836.849857] CC1: 5 -> 5, CC2: 0 -> 0 [state TOGGLING, polarity 0, connec=
ted]
[  836.849929] state change TOGGLING -> SNK_ATTACH_WAIT [rev3 NONE_AMS]
[  836.850061] pending state change SNK_ATTACH_WAIT -> SNK_DEBOUNCED @ 200 =
ms [rev3 NONE_AMS]
[  837.053117] state change SNK_ATTACH_WAIT -> SNK_DEBOUNCED [delayed 200 m=
s]
[  837.561556] VBUS on
[  837.561614] state change SNK_DEBOUNCED -> SNK_ATTACHED [rev3 NONE_AMS]
[  837.561721] polarity 0
[  837.585787] Requesting mux state 1, usb-role 2, orientation 1
[  837.588793] state change SNK_ATTACHED -> SNK_STARTUP [rev3 NONE_AMS]
[  837.588852] state change SNK_STARTUP -> SNK_DISCOVERY [rev3 NONE_AMS]
[  837.588891] Setting voltage/current limit 5000 mV 3000 mA
[  837.589041] vbus=3D0 charge:=3D1
[  837.593658] state change SNK_DISCOVERY -> SNK_WAIT_CAPABILITIES [rev3 NO=
NE_AMS]
[  837.595772] pending state change SNK_WAIT_CAPABILITIES -> SNK_READY @ 31=
0 ms [rev3 NONE_AMS]
[  837.598462] VBUS on
[  837.776218] PD RX, header: 0x61a1 [1]
[  837.776298]  PDO 0: type 0, 5000 mV, 3000 mA [DE]
[  837.776345]  PDO 1: type 0, 9000 mV, 3000 mA []
[  837.776387]  PDO 2: type 0, 12000 mV, 3000 mA []
[  837.776428]  PDO 3: type 0, 15000 mV, 3000 mA []
[  837.776468]  PDO 4: type 0, 18900 mV, 3000 mA []
[  837.776508]  PDO 5: type 0, 20000 mV, 3000 mA []
[  837.776543] state change SNK_WAIT_CAPABILITIES -> SNK_NEGOTIATE_CAPABILI=
TIES [rev3 POWER_NEGOTIATION]
[  837.776665] Setting usb_comm capable false
[  837.776800] cc=3D0 cc1=3D5 cc2=3D0 vbus=3D0 vconn=3Dsink polarity=3D0
[  837.776844] Requesting PDO 5: 20000 mV, 3000 mA
[  837.776879] PD TX, header: 0x1082
[  837.825886] Setting usb_comm capable false
[  837.835072] Setting voltage/current limit 0 mV 0 mA
[  837.835173] polarity 0
[  837.847308] Requesting mux state 0, usb-role 0, orientation 0
[  837.858190] state change SNK_NEGOTIATE_CAPABILITIES -> SNK_UNATTACHED [r=
ev3 NONE_AMS]
[  837.863918] CC1: 5 -> 5, CC2: 0 -> 0 [state SNK_UNATTACHED, polarity 0, =
connected]
[  837.863988] state change SNK_UNATTACHED -> SNK_ATTACH_WAIT [rev3 NONE_AM=
S]
[  837.864023] state change SNK_ATTACH_WAIT -> PORT_RESET [rev3 NONE_AMS]
[  837.864063] PD TX complete, status: 2
[  837.864374] state change PORT_RESET -> SNK_WAIT_CAPABILITIES [rev3 NONE_=
AMS]
[  837.866579] pending state change SNK_WAIT_CAPABILITIES -> HARD_RESET_SEN=
D @ 310 ms [rev3 NONE_AMS]
[  837.866735] Received hard reset
[  837.866764] state change SNK_WAIT_CAPABILITIES -> HARD_RESET_START [rev3=
 HARD_RESET]
[  837.874698] state change HARD_RESET_START -> SNK_HARD_RESET_SINK_OFF [re=
v3 HARD_RESET]
[  837.874766] vconn:=3D0
[  837.877384] Requesting mux state 1, usb-role 2, orientation 1
[  837.880541] pending state change SNK_HARD_RESET_SINK_OFF -> SNK_HARD_RES=
ET_SINK_ON @ 650 ms [rev3 HARD_RESET]
[  838.533408] state change SNK_HARD_RESET_SINK_OFF -> SNK_HARD_RESET_SINK_=
ON [delayed 650 ms]
[  838.533476] AMS HARD_RESET finished
[  838.536041] state change SNK_HARD_RESET_SINK_ON -> SNK_STARTUP [rev3 NON=
E_AMS]
[  838.536096] state change SNK_STARTUP -> SNK_DISCOVERY [rev3 NONE_AMS]
[  838.536132] pending state change SNK_DISCOVERY -> HARD_RESET_SEND @ 1000=
0 ms [rev3 NONE_AMS]
[  838.625719] VBUS on
[  838.625777] state change SNK_DISCOVERY -> SNK_DISCOVERY [rev3 NONE_AMS]
[  838.625909] Setting voltage/current limit 5000 mV 3000 mA
[  838.626117] vbus=3D0 charge:=3D1
[  838.636737] state change SNK_DISCOVERY -> SNK_WAIT_CAPABILITIES [rev3 NO=
NE_AMS]
[  838.638997] pending state change SNK_WAIT_CAPABILITIES -> HARD_RESET_SEN=
D @ 310 ms [rev3 NONE_AMS]
[  838.647388] VBUS on
[  838.650058] VBUS on
[  838.661358] VBUS on
[  838.841466] PD RX, header: 0x61a1 [0]
[  838.847267] Received hard reset
[  838.847310] state change SNK_WAIT_CAPABILITIES -> HARD_RESET_START [rev3=
 HARD_RESET]
[  838.867145] state change HARD_RESET_START -> SNK_HARD_RESET_SINK_OFF [re=
v3 HARD_RESET]
[  838.867209] vconn:=3D0
[  838.869904] Requesting mux state 1, usb-role 2, orientation 1
[  838.879143] pending state change SNK_HARD_RESET_SINK_OFF -> SNK_HARD_RES=
ET_SINK_ON @ 650 ms [rev3 HARD_RESET]
[  838.894564] Setting usb_comm capable false
[  838.903822] Setting voltage/current limit 0 mV 0 mA
[  838.903978] polarity 0
[  838.916640] Requesting mux state 0, usb-role 0, orientation 0
[  838.927675] state change SNK_HARD_RESET_SINK_OFF -> SNK_UNATTACHED [rev3=
 NONE_AMS]
[  838.933416] CC1: 5 -> 5, CC2: 0 -> 0 [state SNK_UNATTACHED, polarity 0, =
connected]
[  838.933486] state change SNK_UNATTACHED -> SNK_ATTACH_WAIT [rev3 NONE_AM=
S]
[  838.933545] state change SNK_ATTACH_WAIT -> PORT_RESET [rev3 NONE_AMS]
[  838.933854] Setting usb_comm capable false
[  838.943491] Setting voltage/current limit 0 mV 0 mA
[  838.943597] polarity 0
[  838.956130] Requesting mux state 0, usb-role 0, orientation 0
[  838.964257] cc:=3D0
[  838.969176] pending state change PORT_RESET -> PORT_RESET_WAIT_OFF @ 100=
 ms [rev3 NONE_AMS]
[  838.969321] state change PORT_RESET -> PORT_RESET_WAIT_OFF [delayed 100 =
ms]
[  838.969361] state change PORT_RESET_WAIT_OFF -> SNK_UNATTACHED [rev3 NON=
E_AMS]
[  838.969399] Start toggling
[  838.974114] state change SNK_UNATTACHED -> TOGGLING [rev3 NONE_AMS]
[  838.985743] CC1: 5 -> 5, CC2: 0 -> 0 [state TOGGLING, polarity 0, connec=
ted]
[  838.985816] state change TOGGLING -> SNK_ATTACH_WAIT [rev3 NONE_AMS]
[  838.985953] pending state change SNK_ATTACH_WAIT -> SNK_DEBOUNCED @ 200 =
ms [rev3 NONE_AMS]
[  839.189282] state change SNK_ATTACH_WAIT -> SNK_DEBOUNCED [delayed 200 m=
s]
[  839.695231] VBUS on
[  839.695287] state change SNK_DEBOUNCED -> SNK_ATTACHED [rev3 NONE_AMS]
[  839.695395] polarity 0
[  839.719424] Requesting mux state 1, usb-role 2, orientation 1
[  839.722649] state change SNK_ATTACHED -> SNK_STARTUP [rev3 NONE_AMS]
[  839.722708] state change SNK_STARTUP -> SNK_DISCOVERY [rev3 NONE_AMS]
[  839.722747] Setting voltage/current limit 5000 mV 3000 mA
[  839.722899] vbus=3D0 charge:=3D1
[  839.727145] state change SNK_DISCOVERY -> SNK_WAIT_CAPABILITIES [rev3 NO=
NE_AMS]
[  839.729327] pending state change SNK_WAIT_CAPABILITIES -> SNK_READY @ 31=
0 ms [rev3 NONE_AMS]
[  839.732221] VBUS on
[  839.894447] PD RX, header: 0x61a1 [1]
[  839.894486]  PDO 0: type 0, 5000 mV, 3000 mA [DE]
[  839.894509]  PDO 1: type 0, 9000 mV, 3000 mA []
[  839.894526]  PDO 2: type 0, 12000 mV, 3000 mA []
[  839.894542]  PDO 3: type 0, 15000 mV, 3000 mA []
[  839.894558]  PDO 4: type 0, 18900 mV, 3000 mA []
[  839.894573]  PDO 5: type 0, 20000 mV, 3000 mA []
[  839.894592] state change SNK_WAIT_CAPABILITIES -> SNK_NEGOTIATE_CAPABILI=
TIES [rev3 POWER_NEGOTIATION]
[  839.894646] Setting usb_comm capable false
[  839.894750] cc=3D0 cc1=3D5 cc2=3D0 vbus=3D0 vconn=3Dsink polarity=3D0
[  839.894772] Requesting PDO 5: 20000 mV, 3000 mA
[  839.894787] PD TX, header: 0x1082
[  839.905398] PD TX complete, status: 0
[  839.905668] pending state change SNK_NEGOTIATE_CAPABILITIES -> HARD_RESE=
T_SEND @ 60 ms [rev3 POWER_NEGOTIATION]
[  839.914091] PD RX, header: 0x3a3 [1]
[  839.914126] state change SNK_NEGOTIATE_CAPABILITIES -> SNK_TRANSITION_SI=
NK [rev3 POWER_NEGOTIATION]
[  839.914181] Setting standby current 5000 mV @ 500 mA
[  839.914195] Setting voltage/current limit 5000 mV 500 mA
[  839.914299] pending state change SNK_TRANSITION_SINK -> HARD_RESET_SEND =
@ 500 ms [rev3 POWER_NEGOTIATION]
[  840.189160] PD RX, header: 0x5a6 [1]
[  840.189224] Setting voltage/current limit 20000 mV 3000 mA
[  840.189362] state change SNK_TRANSITION_SINK -> SNK_READY [rev3 POWER_NE=
GOTIATION]
[  840.192758] AMS POWER_NEGOTIATION finished
[  840.193054] AMS DISCOVER_IDENTITY start
[  840.193140] PD TX, header: 0x128f
[  840.211568] PD TX complete, status: 0
[  840.234728] PD RX, header: 0x47af [1]
[  840.234788] Rx VDM cmd 0xff00a041 type 1 cmd 1 len 4
[  840.234871] AMS DISCOVER_IDENTITY finished
[  840.235846] Identity: 03f0:0000.f603
[  840.236012] AMS DISCOVER_SVIDS start
[  840.236097] PD TX, header: 0x148f
[  840.266351] PD TX complete, status: 0
[  840.266753] PD RX, header: 0x19af [1]
[  840.266799] Rx VDM cmd 0xff00a081 type 2 cmd 1 len 1
[  840.266881] AMS DISCOVER_SVIDS finished
[  840.293192] AMS GET_SINK_CAPABILITIES start
[  840.293222] state change SNK_READY -> AMS_START [rev3 GET_SINK_CAPABILIT=
IES]
[  840.293262] state change AMS_START -> GET_SINK_CAP [rev3 GET_SINK_CAPABI=
LITIES]
[  840.293279] PD TX, header: 0x688
[  840.301621] PD TX complete, status: 0
[  840.301892] pending state change GET_SINK_CAP -> GET_SINK_CAP_TIMEOUT @ =
60 ms [rev3 GET_SINK_CAPABILITIES]
[  840.309127] PD RX, header: 0xbb0 [1]
[  840.309161] state change GET_SINK_CAP -> SNK_READY [rev3 GET_SINK_CAPABI=
LITIES]
[  840.309226] AMS GET_SINK_CAPABILITIES finished
