Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B22451171A1
	for <lists+stable@lfdr.de>; Mon,  9 Dec 2019 17:29:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726874AbfLIQ30 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Dec 2019 11:29:26 -0500
Received: from mail-eopbgr1410133.outbound.protection.outlook.com ([40.107.141.133]:43053
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726608AbfLIQ30 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Dec 2019 11:29:26 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CXfMevSzeV878BbGvjRP43Vp8As9RyBW4LUx8l3EotipOMeJzVqJIzC3nLjM7ocvBa1DuFfvzGIg4FOHXnCtvyfZOz0Sd2fXaiOAIkd79GwVAJWEmOvfGaesKRaI+05FVF2SlvIcauD2fcqP/Jkzfu8iduAVIsTFlgxtzc67Nc4wxL4Kf6Xc3ixARRQ5wvglLfJHSgWE6uPR42djQ4H0S8eR1RJZwEt64WtJm1s8w4WaZw3MhLI7e4BbF56hD0JUw/5waSu6fW+PJWrte+NS2kg4ws10511FPoVu+vkwAYUKsd42X/+Ku7UcL8kUCZwQJu29DGRvjaOPViXGONLPwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LttRioHDueAclKFpR/7WfXqTk1onUZXjk/jBuw8/O8U=;
 b=UFePS5uj6gOW6B90f5+lg10TfAQDu21hcZ2RhuipyiuryXTACUCTLRZJLXAUf0ytLIC4vsDcXCevirkOF/y5z99eh6w/0TxBm3e4pLOpVO8rP3GVzh5kUtgl4yhIZHZogXL9GAuvUfZGv5YRb+vSgm2Weo0/Pg1NV/69AINkT75r7AxNoHyr8mSmVMAqDIgGICbGWU2FBJ1XVSYzdu0M78Pvk9KOGBhDrJG51nvMU2oOqqjnh0iOaTw3UaY3SsEU2gfZEpKrioqE04z/x1UJXICRyTUBhkplbEI9PWd0r4TzoTM+oshZ9a8HuUfdTjHtTcVkzSfL0zQZbmNjX9PXAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LttRioHDueAclKFpR/7WfXqTk1onUZXjk/jBuw8/O8U=;
 b=E3/Gr8VcvM4mW29GLuSkVn0uknfOUmMCWD9rE1VJxSuvHjB7O1rJgi/vJSm5J2m+Vo3MEVjqO+5LfFzRSVZ3ur/vekcO+26uV+dDOdL8AK4C1oynQCOh4VFfSMl4UTB/HfA8hVf6mYcObRV7KlT64A7T1Y2MaCK0fQmDo6HCuGs=
Received: from TYAPR01MB2285.jpnprd01.prod.outlook.com (52.133.177.145) by
 TYAPR01MB5166.jpnprd01.prod.outlook.com (20.179.173.86) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.16; Mon, 9 Dec 2019 16:29:23 +0000
Received: from TYAPR01MB2285.jpnprd01.prod.outlook.com
 ([fe80::5025:20cb:31a2:4be1]) by TYAPR01MB2285.jpnprd01.prod.outlook.com
 ([fe80::5025:20cb:31a2:4be1%5]) with mapi id 15.20.2516.018; Mon, 9 Dec 2019
 16:29:23 +0000
From:   Chris Paterson <Chris.Paterson2@renesas.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Linux 4.19.89-rc1 5944fcdd errors
Thread-Topic: Linux 4.19.89-rc1 5944fcdd errors
Thread-Index: AdWuq27YYqoiVr7aSmCEQeiV9xd6BQ==
Date:   Mon, 9 Dec 2019 16:29:22 +0000
Message-ID: <TYAPR01MB228505DBC22568339F914C15B7580@TYAPR01MB2285.jpnprd01.prod.outlook.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chris.Paterson2@renesas.com; 
x-originating-ip: [193.141.220.21]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d7c4845c-250d-40de-e580-08d77cc4f320
x-ms-traffictypediagnostic: TYAPR01MB5166:
x-microsoft-antispam-prvs: <TYAPR01MB5166BB83E841B0058BBDFA4FB7580@TYAPR01MB5166.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2089;
x-forefront-prvs: 02462830BE
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(366004)(136003)(376002)(346002)(39860400002)(396003)(189003)(199004)(186003)(6506007)(76116006)(81166006)(5660300002)(316002)(305945005)(26005)(6916009)(66476007)(66946007)(66556008)(71190400001)(71200400001)(52536014)(7696005)(86362001)(9686003)(55016002)(478600001)(2906002)(33656002)(66446008)(64756008)(4326008)(966005)(81156014)(8676002)(8936002);DIR:OUT;SFP:1102;SCL:1;SRVR:TYAPR01MB5166;H:TYAPR01MB2285.jpnprd01.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: renesas.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: R26S+s5DlIOAZ5rhXEDJL07JObBVwBAa7unPjSdthY4K+/5ERdvAMD0hsnn1DD3mQ/EEgxuybmqMMjh+kcC84TZnp51LcuSLdEcUDjkQHR/beoSU1jU33mQMQProKbCfnSyEmqNshmoMfvy7aCsSxBRE/TfI6xe2WVx4SNx49znRw3MW5uySXvBDlnazqVAkNLgE4VsmcYV/X6qiVQP+GgZgdBRiyXAYLYuUlBwryzmfddNY9hlMlMBwExOnn/keil5q6HMjhajD4INFKcbjm1V2pU25GYsfYcI36nMlTi5E7rBFI42qa+ZKC9F4DQcdhCA6Dg1srhhuuRLVc0IMNHW1drBvSvJXv8GSQu03ipNdcbQ0bjT0ygdc+7fBJypIOsd7MPCIB15GwBDqgydz555khYDYesnRhwfAVp7ij+XeAKCzZhd5xT9gabU+fKI1qraYF+lV5TAp3wHsZ4ae+NPTxZkJ7pBMcer2gfulH24=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7c4845c-250d-40de-e580-08d77cc4f320
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Dec 2019 16:29:22.9568
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mt1Oqtid0no23Iro4jIo2hVuMnYpkpG0jF46xgj1myJ51tt+1RFbGQhm08Xkl5z/gnrC4l9AxUx+Rd1Tj1EnFtW0eavV1P6EJOuBRGgsNnQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR01MB5166
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Greg, all,

I've seen a few errors with 4.19.89-rc1 (5944fcdd).

1)
Config: arm64 defconfig
Link: https://gitlab.com/cip-playground/linux-stable-rc-ci/-/jobs/373484093=
#L267
Probable culprit: 227b635dcae6 ("bpf, arm64: fix getting subprog addr from =
aux for calls")
Issue log:
267 arch/arm64/net/bpf_jit_comp.c: In function 'build_insn':
268 arch/arm64/net/bpf_jit_comp.c:633:9: error: implicit declaration of fun=
ction 'bpf_jit_get_func_addr'; did you mean 'bpf_jit_binary_hdr'? [-Werror=
=3Dimplicit-function-declaration]
269    ret =3D bpf_jit_get_func_addr(ctx->prog, insn, extra_pass,
270          ^~~~~~~~~~~~~~~~~~~~~
271          bpf_jit_binary_hdr


2)
Config: arm multi_v7_defconfig
Link: https://gitlab.com/cip-playground/linux-stable-rc-ci/-/jobs/373484091=
#L2147
Probable culprit: 192929fd944d ("dmaengine: xilinx_dma: Fix 64-bit simple C=
DMA transfer")
Issue log:
2147 drivers/dma/xilinx/xilinx_dma.c: In function 'xilinx_cdma_start_transf=
er':
2148 drivers/dma/xilinx/xilinx_dma.c:1252:9: error: implicit declaration of=
 function 'xilinx_prep_dma_addr_t'; did you mean 'xilinx_dma_start'? [-Werr=
or=3Dimplicit-function-declaration]
2149          xilinx_prep_dma_addr_t(hw->src_addr));
2150          ^~~~~~~~~~~~~~~~~~~~~~
2151          xilinx_dma_start


3)
Config: arm shmobile_defconfig
Link: https://gitlab.com/cip-playground/linux-stable-rc-ci/-/jobs/373484089=
#L2249
Probable culprit: 984d7a8bff57 ("pinctrl: sh-pfc: r8a7792: Fix VIN versione=
d groups")
Issue log:
2249 drivers/pinctrl/sh-pfc/pfc-r8a7792.c:1750:38: error: macro "VIN_DATA_P=
IN_GROUP" passed 3 arguments, but takes just 2
2250   VIN_DATA_PIN_GROUP(vin1_data, 24, _b),
2251                                       ^
2252 drivers/pinctrl/sh-pfc/pfc-r8a7792.c:1750:2: error: 'VIN_DATA_PIN_GROU=
P' undeclared here (not in a function); did you mean 'PIN_MAP_TYPE_MUX_GROU=
P'?
2253   VIN_DATA_PIN_GROUP(vin1_data, 24, _b),
2254   ^~~~~~~~~~~~~~~~~~
2255   PIN_MAP_TYPE_MUX_GROUP
2256 drivers/pinctrl/sh-pfc/pfc-r8a7792.c:1751:38: error: macro "VIN_DATA_P=
IN_GROUP" passed 3 arguments, but takes just 2
2257   VIN_DATA_PIN_GROUP(vin1_data, 20, _b),
2258                                       ^
2259 drivers/pinctrl/sh-pfc/pfc-r8a7792.c:1753:38: error: macro "VIN_DATA_P=
IN_GROUP" passed 3 arguments, but takes just 2
2260   VIN_DATA_PIN_GROUP(vin1_data, 16, _b),
2261                                       ^


Kind regards, Chris

