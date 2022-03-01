Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 645CD4C7F7D
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 01:44:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230482AbiCAApD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 19:45:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbiCAApC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 19:45:02 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44E2B119
        for <stable@vger.kernel.org>; Mon, 28 Feb 2022 16:44:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1646095462; x=1677631462;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=LayEQqiq4qvLCe7Zfw2GxJYt29osZWMIm0UUzp8bZFQ=;
  b=dWiFAWm1hekNFSCZ7ZcZ7jZvFB5px6b4+Kx2sx1PpJAn4rl3Tgr7OOHi
   pkwE1dk3VHhrm9/OZWXRUdcKU2NSTc73GYRo6N8QNXBlcBms7jQ199inh
   I9+ezBPHczdOsebQ9/qriskddTV/DDBrEBEOeytwMDe/H8GLQ7fGFiHPN
   vKN3nywK3CTPkSE5FQsrt2tOIrdko0F0CYv5f28azOhXcqB4CoXNked1b
   HKyGiu2TBmf57GEx+7yo62QDA9WAjpjIsgPSqjver0BI3Ox9T4GTJoTVU
   lIJyiqO9bdpUrV54OUBupdwp/F8RcMMbhUQGY+OHOW09QPppdfhfRqfbz
   w==;
X-IronPort-AV: E=Sophos;i="5.90,144,1643644800"; 
   d="scan'208";a="195121224"
Received: from mail-bn8nam11lp2174.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.174])
  by ob1.hgst.iphmx.com with ESMTP; 01 Mar 2022 08:44:21 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GNTX650W3JJjZkRJReBb+D6NMLGwAzs6P3kz0gcVBwJzfnN81SJrn/BzX16Pm2vm7Z6WZkWzy8JrXO6JQWCVZ36yP5NTvwjwdtXJVJWYBlzhEZGjKh10r1tc7fyPM/BSQVYu1dkzyi8flCu5na83OiS7NKhl3sCLsFbh2DJFV/KdTwl2CmTilEhm5i93FlkKhTkHx7MffsJle1xb7AKLV3n9HLttIH7jNP5zUQRgYpfZig4HSG6R8huuPcijAzWSj3yegMPvyzZxJgVpoof4pF0+tbWn8pWKOUI+WgAGQJYIfUit8UmXyoxnGm0CUqwTvB0N5ibre7+JU7XJiBNK1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gSKQ9OqmYUDHPe9sFCgTznaGBf9xINzWf0HQGHok9Jc=;
 b=W0J2NYAkhukdcLaEfZalFfFGNTuHQr5FQYbU9Jw7osQ1hFvWtWojkQVahseppDIWcTG2jeG+BXWeusEw6aeEch/MvmN96WzqnukDJOFH+sNaR4zNXXMeGfrg27lKP2CC1Y5YrPD+GAVK1YG7Wa/A8oiTNVcDFVPlMBRzwNYDLwru/pJpV43Nrxb0B3VcMI2c6Srjo8gJF62ForFcuiLm0E/XDQm991DdmYPJ4grq4W8X/ezKWyL7FllNoDoBfSrIuiFnhNLFFHmMzDeX4nAh+w8qq+f0nQqyskZectY1mCwpt7FJaSVdB6hhjp9ardcqM2e+nTyUB+g7j8fZ7PVEOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gSKQ9OqmYUDHPe9sFCgTznaGBf9xINzWf0HQGHok9Jc=;
 b=ZeJWc6oBrVXSmG+Cp4NQ2SLDb+I6LN9vQac6KAda7nctDoR0aJ3/qcvuZCo9P/VRvDq+fhFqQHdol23SHPwT+djgr4VLLr07/FrW5bclT5uFNxvF4rcHx7Q5W5CbYMO+AVxIkbzb5brPeKNaTJkt8WG2rNcnspFtm3DNFTVWBJg=
Received: from PH0PR04MB7158.namprd04.prod.outlook.com (2603:10b6:510:8::18)
 by SN6PR04MB4255.namprd04.prod.outlook.com (2603:10b6:805:3c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Tue, 1 Mar
 2022 00:44:19 +0000
Received: from PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::f025:4f23:8e46:b2ed]) by PH0PR04MB7158.namprd04.prod.outlook.com
 ([fe80::f025:4f23:8e46:b2ed%2]) with mapi id 15.20.5017.027; Tue, 1 Mar 2022
 00:44:19 +0000
From:   Niklas Cassel <Niklas.Cassel@wdc.com>
To:     Rob Herring <robh+dt@kernel.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Damien Le Moal <Damien.LeMoal@wdc.com>
CC:     "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        Niklas Cassel <Niklas.Cassel@wdc.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: [PATCH] riscv: dts: k210: fix broken IRQs on hart1
Thread-Topic: [PATCH] riscv: dts: k210: fix broken IRQs on hart1
Thread-Index: AQHYLQV8jnfNWmqMsk69WSN/LNe4Hw==
Date:   Tue, 1 Mar 2022 00:44:18 +0000
Message-ID: <20220301004355.3038142-1-Niklas.Cassel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.35.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fb1f9d39-8b31-48b9-e533-08d9fb1c9eb9
x-ms-traffictypediagnostic: SN6PR04MB4255:EE_
x-microsoft-antispam-prvs: <SN6PR04MB42553E80BD5153D43977BC8BF2029@SN6PR04MB4255.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aOmn6kUf0CWE9Hcb44xoPHGZyAdIfhdYmmmQtpeEnWBUiz+DWhzTA3Phx1gEC+9wEvci6L5g5jREoekeADLSrpr7bLGLZ+3QcDyRxgtRWCoPMYaylSopzALqN/E5A6r0m7A/MWDGvS5+C6lPk6WqiaLoIdf+wYpiFo2Ty9qktxixVqvlkCEMM8XzXlLtgkyutFi4eQbEDRL4cItdIJWJVRTWnJJaWq8b5apbBuk15lfUZD9xTJweS2odsri/yzwAX4TOuxON8ZXHJcX/AOS4Hxg4g7+iEUTtrZx1khWmT9lOrdzdmlJx69xVACW5E8qP/wUajGAWx6c0Im/C+fyz8UirlD2m7o2JaIx2/XNrn8kHSBMYxcUhuaOSBOS67ZYT8iAoGRIACDIoFKPm3c2m4D10zI0qGC5yO/VwxVWVOqoquulxMz6IC40mpu652S2PX335oKB+QiGN1KEdX/hZq1dE8dbAUjgr/dWWv/YWPT1e2AK+FsG+Kz1eoKR/a2tFFbt6IM3h9JVnSA3WpPQ8x4u/lEizqfSAcItW+U+1umpWBgqy8YFBVAYfbsecO2siPtLGmchGEG5OOLylK8HDjAmexT3UB8Z2G85VId3P+O8c13+pUp21kHgkJJGDZFmVR4O4AmRPj3A6hicbHR8pvzXJENUbeH9wFyvocatoJ6rS0jrVkxZfHQ3Ny8NzBKdUwMKAlt0lg45hV+rh44rzzw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7158.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(83380400001)(38070700005)(91956017)(2906002)(26005)(82960400001)(1076003)(2616005)(122000001)(186003)(66446008)(6512007)(508600001)(316002)(6636002)(71200400001)(38100700002)(8936002)(36756003)(6506007)(5660300002)(66476007)(66946007)(76116006)(66556008)(64756008)(110136005)(8676002)(86362001)(4326008)(6486002)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?BlchDUAbij1vJDReBt7WjuqUgE1Cz1HA/d1bNEKKCwLvWakaTD8YzD7HEm?=
 =?iso-8859-1?Q?qgyhsxhIRcfHgVLYuM4S0fnSP6E7n/etkj1ehNwavhdyBqYD2J1vVxYNvK?=
 =?iso-8859-1?Q?rracfEzvvBgxo046YzhEI2B4kCRHsToksza+cxWgLhG12S2fLrnfvddNgq?=
 =?iso-8859-1?Q?1jGk6SigdUBGg7czZQu5DcQ5nFxOgiCs9P/87jrWaVbxEQU3gmx3K+mK7q?=
 =?iso-8859-1?Q?NAfv2f5SrdcFcCUxMh2vYFVOWcdmL9PHu63tNbvlQriBHS4qMh0c1TqOEt?=
 =?iso-8859-1?Q?KWMby/fraQA7XQ9bP0l5mtV51ljo6XBe3HohJX4LCc35nl7SkxNragpjeJ?=
 =?iso-8859-1?Q?yiMs6IJzf6KFid8QCSxfj9pS6zrak3GejIBoh+fXRmKvomqyM0BToh7Kns?=
 =?iso-8859-1?Q?OOGfIfNd6ppeq0cRVTZ9KRFGb/TpKaqSOzrXs8r29MdG0Pdw9Gx4O4t1A1?=
 =?iso-8859-1?Q?hLPZnlRj4y40VytPe347WP9/diOtvHrUmoc6hy89NXHtbgqU1fwK4jQFpP?=
 =?iso-8859-1?Q?Pe9RRwSXlNifwGFB6uK7F9J3UD/7csMlASTEyjXtbVljWeg/DOJE+GDA27?=
 =?iso-8859-1?Q?mlrGwYETOXPExIqXM5jO2v+emfyrDjWauHbkypfJBXz3bi2s6MBok2O0PH?=
 =?iso-8859-1?Q?/ZMu0B1de/3vHHXt2js6cSscruPCNQorKjc7rCSa4JUwmQHsZCsI60jhz5?=
 =?iso-8859-1?Q?fXvI797wON1ex1QYEFsA2e1tPtPRI0t5WAnQeU8Gyj6dDxxtwQLlg1/ayS?=
 =?iso-8859-1?Q?Dw/AJ/oLavODxseYZ3tRxWB+Zqg2vUrnbLiuXDgjo3FIs7PHaj+ncuomUJ?=
 =?iso-8859-1?Q?o5oFPls2wDKndPF8kAP/e2awc/CjUU4ZSUyLKMxTRkDBc7uGuW02RjsUuI?=
 =?iso-8859-1?Q?NbvpoEjIM0WYBcGb94Z+AwqHq5OJhcTolvrUMKT6cQnySHRL4AjFGcKLkx?=
 =?iso-8859-1?Q?FTDc/P5dsjjO7/88O8JWY/ztYfM1mrANnRIH9aFtZh3qjLreWrDEWZeZHg?=
 =?iso-8859-1?Q?180yl5KFphKwchI09QArYLX7+jA++XNcjvUWqsPOS8UG/61k6F0ad42Oho?=
 =?iso-8859-1?Q?OWxjk2+YXGHz07p/onOq97Ip4V5QlzMPQzVLAMbhpGXBCC2kTlddWoASat?=
 =?iso-8859-1?Q?BzRTHvcJIUUn2/RVhgSzkKAoVUEElKfQrQp6nws4WPSI17KeTOWd4h4LdV?=
 =?iso-8859-1?Q?jsHC4Y+yvuQBB1Yd5BQnAVZajSL465bUFQ9cj+bpwHzh9cTdtZ+4QS+zDz?=
 =?iso-8859-1?Q?cJrfRgsfazfjUaF4NZGZWQWnZRDMm9UfPrKAIasHpcoCTgJgSfjrgZLmhZ?=
 =?iso-8859-1?Q?jkFttIafw7Ei6xWBy7a8NYYc4JTHKQW6g7Uclyfg2b8VhBDKPHcuX8/mSK?=
 =?iso-8859-1?Q?ToEEKIIuFvSGXiE67WWXUwMuScat4fwp3OzNzMR/Z5J+kl1LJ9PJ8gxG6E?=
 =?iso-8859-1?Q?Fump6fn07cObDvKdtvqTxk4zpCNu8LnDdcZLy0IRyXw/I3zGAYSLwoW25z?=
 =?iso-8859-1?Q?cDfjsYQjktnRF0XN6H6VckDS2D9CLfhvwH/TkX10MwbQU3igSIKQQDlcjc?=
 =?iso-8859-1?Q?kOjl6RDGuXseLxoT59RPm5rXl8zb+lxbFdd1OaZZS1jUPDGkLv7S244PB5?=
 =?iso-8859-1?Q?lVszMH48VI7SNhAPLdNDvkxUVT1ywHdjU6YV57XrPYD6M2yCUYzjjQ6Jgp?=
 =?iso-8859-1?Q?Z5v5viT7LOexNuFtke0=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7158.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb1f9d39-8b31-48b9-e533-08d9fb1c9eb9
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Mar 2022 00:44:18.8712
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dUezdqReGmaswUgStw8T+wi2JZ4+QY8qX0EhPaI3KPHQddC1oLKUOFfLbm6MHy0yGkWraUk04xsu0i7OAkBtUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4255
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Niklas Cassel <niklas.cassel@wdc.com>

Commit 67d96729a9e7 ("riscv: Update Canaan Kendryte K210 device tree")
incorrectly removed two entries from the PLIC interrupt-controller node's
interrupts-extended property.

The PLIC driver cannot know the mapping between hart contexts and hart ids,
so this information has to be provided by device tree, as specified by the
PLIC device tree binding.

The PLIC driver uses the interrupts-extended property, and initializes the
hart context registers in the exact same order as provided by the
interrupts-extended property.

In other words, if we don't specify the S-mode interrupts, the PLIC driver
will simply initialize the hart0 S-mode hart context with the hart1 M-mode
configuration. It is therefore essential to specify the S-mode IRQs even
though the system itself will only ever be running in M-mode.

Re-add the S-mode interrupts, so that we get working IRQs on hart1 again.

Cc: <stable@vger.kernel.org>
Fixes: 67d96729a9e7 ("riscv: Update Canaan Kendryte K210 device tree")
Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 arch/riscv/boot/dts/canaan/k210.dtsi | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/boot/dts/canaan/k210.dtsi b/arch/riscv/boot/dts/can=
aan/k210.dtsi
index 56f57118c633..44d338514761 100644
--- a/arch/riscv/boot/dts/canaan/k210.dtsi
+++ b/arch/riscv/boot/dts/canaan/k210.dtsi
@@ -113,7 +113,8 @@ plic0: interrupt-controller@c000000 {
 			compatible =3D "canaan,k210-plic", "sifive,plic-1.0.0";
 			reg =3D <0xC000000 0x4000000>;
 			interrupt-controller;
-			interrupts-extended =3D <&cpu0_intc 11>, <&cpu1_intc 11>;
+			interrupts-extended =3D <&cpu0_intc 11>, <&cpu0_intc 9>,
+					      <&cpu1_intc 11>, <&cpu1_intc 9>;
 			riscv,ndev =3D <65>;
 		};
=20
--=20
2.35.1
