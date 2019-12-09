Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 013FB1171D3
	for <lists+stable@lfdr.de>; Mon,  9 Dec 2019 17:33:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726642AbfLIQd2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Dec 2019 11:33:28 -0500
Received: from mail-eopbgr1400112.outbound.protection.outlook.com ([40.107.140.112]:32736
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726950AbfLIQdT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Dec 2019 11:33:19 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MmgCgLuvQgqCUS1ys96NDY/vy26FeJv7x4redVAgknjg0Ij4Mck24TIEnRGFPTM7OLqIDHc538IeDdmqoKYuJsJrfT1ORPZ/Y07HyhspXdbgjSnqbumbkQu2abjeZYID6GfqxZDs8S8UmDTIdHgF1VBIQNqp9tKCHB3eAx7vaUxKv2cKtZ/kXIYPPn/DwWd5vZA9jBvpIe3ZlDN7xyUEecahmitVBKzaBOdK95vdSujXvtTvd5lQ7EJ5y+e7w7VQbOM5uY9mwLv+8jm7FvipXyqvJjmKd1W3FrWqKgY1zGZdhc25KxKUvY33xYWjdqWzAIN3OWYlE4O5xtIxWYkubw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5Z/MPIlUrlVtTmJ2nR5KrqqYxHXeD8zLp0+QXi7iaFg=;
 b=XBtupu5hxYG2xdhomtQmLcDA0Nugd6c2lIb+XAFDlRmAGBub9sMhIYPMAi83Z3OArLmw9//OYGD0PpF7ziamXzONqlJFA7DD09ILHJmJ/YXHTndTJfoPn15Y5Pye7BSjpaAS+vBMzlE9uZ9kt51T/VPE7xyaZr6i/a/tRlzz2rGG3JQz1Q8aJv87HD/DoSZOv+QoC/Ee0ZVQasmXg+3wJuhXDHBLubcQ/qMMWdOEzhJDr+qKPLkUd5rKdeqRjhdvFVlqa+e7Ql7eX76rGYkPJFNI6xkifES6ADac17WeVVRyjDjbRVqFXEoMt00PMzhHACwygdH3Gaysl+Xyep/QXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5Z/MPIlUrlVtTmJ2nR5KrqqYxHXeD8zLp0+QXi7iaFg=;
 b=Nk9F8bdcayry10m6ASCI/K7GK6SCgHYV6/5fEUDClYxGf/vrP+znr2hglizMuPbVgEKPGrr8je4eFhXbeC/RpeIrx5SWJ2Tz0EOcfNc+4DJ2q0FfG1n97cwHxww1T+3ULNDRKIMCVA3dO4JN7MfwpbvxKIbQ4nF5E0/QlLujY0k=
Received: from TYAPR01MB2285.jpnprd01.prod.outlook.com (52.133.177.145) by
 TYAPR01MB4574.jpnprd01.prod.outlook.com (20.179.174.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.16; Mon, 9 Dec 2019 16:33:17 +0000
Received: from TYAPR01MB2285.jpnprd01.prod.outlook.com
 ([fe80::5025:20cb:31a2:4be1]) by TYAPR01MB2285.jpnprd01.prod.outlook.com
 ([fe80::5025:20cb:31a2:4be1%5]) with mapi id 15.20.2516.018; Mon, 9 Dec 2019
 16:33:17 +0000
From:   Chris Paterson <Chris.Paterson2@renesas.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "cip-dev@lists.cip-project.org" <cip-dev@lists.cip-project.org>
Subject: Linux 4.4.207-rc1 8dbad6fe errors
Thread-Topic: Linux 4.4.207-rc1 8dbad6fe errors
Thread-Index: AdWurgt7utNWvBqZQ+ynUVtGfdoeNg==
Date:   Mon, 9 Dec 2019 16:33:17 +0000
Message-ID: <TYAPR01MB22854300E93B9F6D02232982B7580@TYAPR01MB2285.jpnprd01.prod.outlook.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chris.Paterson2@renesas.com; 
x-originating-ip: [193.141.220.21]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 12f0d958-6fec-4482-661d-08d77cc57ebb
x-ms-traffictypediagnostic: TYAPR01MB4574:
x-microsoft-antispam-prvs: <TYAPR01MB457471AFE276803A44B9DFE9B7580@TYAPR01MB4574.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:813;
x-forefront-prvs: 02462830BE
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(39860400002)(396003)(376002)(346002)(366004)(189003)(199004)(186003)(55016002)(8936002)(52536014)(4326008)(81156014)(81166006)(9686003)(26005)(8676002)(71190400001)(54906003)(7696005)(6506007)(33656002)(71200400001)(86362001)(66446008)(64756008)(66946007)(76116006)(66476007)(6916009)(316002)(966005)(478600001)(2906002)(305945005)(4744005)(66556008)(5660300002);DIR:OUT;SFP:1102;SCL:1;SRVR:TYAPR01MB4574;H:TYAPR01MB2285.jpnprd01.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: renesas.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: w46QQSQ3KCzWrf6nk8CcBVTvbyBbBvIhwiJlatTGxMR1Y9nU9uprTifBENpIpmTHs3ZONYsUB4oTyrF35R1YhMidVMDstzhkfvkEZz9TIfFGNjRz9nTJY6ZEkEy7uGaueLqaA+3zZlGwlg4Q3SdxTxxC3q1/ecIeG1yoCF+sArRV0VpVdYrSalkcoAEK2RzrzsnvqlMAg3DW8yMD/WOQQJ1AXY+w4R+A3o0MHppM+cuhTBpZ/xDY6T6jv4/mbPaM6u06BBZgCe9ADDdzSlaUT5+NapKB2uaKeekuwlPxBQoS1Egb8cgtwI0yYCkn0UFnOJ+7uPLxDkV8pNZ5O8JAdyVKTvEmi3q3e1m4zf9BnTpzIx4W2rcK4PsMBDrdMnu64WZX900IS8laqih6s1/n5yrHpBkvcc5tijO5NvcTacyWiz6Jttr6V6bddwAdOQD1Gdi9Tal0g/CNzFyEKd+Bu9nHCpf66n4z6DI31rhSoC8=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12f0d958-6fec-4482-661d-08d77cc57ebb
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Dec 2019 16:33:17.1867
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BAurxhZM83mps0pBQMg+rw9wJeNae3l9So7HVBlfAvjULd2XO6GS8luKHKi8+rDRGL0s8ieFkFTq6f5kEfzvLwZ8pWYbqvHOI8bt7TeN1AU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR01MB4574
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Greg, all,

I've seen an error with 4.4.207-rc1 (8dbad6fe).

1)
Config: arm multi_v7_defconfig
Link: https://gitlab.com/cip-playground/linux-stable-rc-ci/-/jobs/373483706=
#L3649
Probable culprit: bc15f46a10dc ("serial: pl011: Fix DMA ->flush_buffer()")
Issue log:
3649 drivers/tty/serial/amba-pl011.c: In function 'pl011_dma_flush_buffer':
3650 drivers/tty/serial/amba-pl011.c:697:2: error: implicit declaration of =
function 'dmaengine_terminate_async'; did you mean 'dmaengine_terminate_all=
'? [-Werror=3Dimplicit-function-declaration]
3651   dmaengine_terminate_async(uap->dmatx.chan);
3652   ^~~~~~~~~~~~~~~~~~~~~~~~~

Kind regards, Chris

