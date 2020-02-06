Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4848154C5A
	for <lists+stable@lfdr.de>; Thu,  6 Feb 2020 20:37:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727902AbgBFThK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Feb 2020 14:37:10 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:61999 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727738AbgBFThJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Feb 2020 14:37:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1581017830; x=1612553830;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=9WHyig8zuTMnRE08czRy5SnQx9n2kFsmFFV5dSEdP8Q=;
  b=TeXk69OnUlLYvely1XR5aji5LimfcV6Cd6YiEPlvkMrZ/Ua8sWrQ9Pvg
   KZfRuv3BMoFT/EpkKUR0uUCTjUF2YxqBvT3hjcXlqmqidtZmBV9hjgC8A
   Ed0a3+oHxqP6dIKcYDKjZSFsNVugGG7bdjczUyK0IgaVpBxfulJPE8gpD
   I8QNDkRf20h7I6ap6EtBrA4ADdrjfBeAf+Q0trcQqkUWJzTiz4154Vj+g
   qrxUOKxOipUjgvx9K5mObEmHCNyCbqFJWqRbz1Im/ChweF9nsT0QjkCBf
   DnKOOrht0k3cukN8EakgJ40nvXowaXTqXOEoh9mLnJ4Cwp12gc6IRZOit
   g==;
IronPort-SDR: cecf223N3wCStLwZdcCItu4pF+QLDGVBHPVH2nnr9wwIeIorbG3Dt6MYFx1qTwSj3bxFg74004
 uBOBKuGSmhCL+WN6m2Ww0Qe9C5sfLvuTbkWrG5lxLplErpgt9NutfJaSQI8ZzVS4H/0p+SXfu3
 4fPcp5gKiEUgeI/LeCxXKfeE9BRD2+ivHVkTTe3ksweb1XFdlg/2/Pp2IEDc21/KTQiGTKdIwz
 kikF/BGvw3wo0jA/rAWNzSHYj/dCZhoSuK/mPX2XTkGAcHa8woFoetSd48eXvD3hYqG+ymNkoK
 Tpg=
X-IronPort-AV: E=Sophos;i="5.70,410,1574092800"; 
   d="scan'208";a="129840679"
Received: from mail-dm6nam11lp2176.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.176])
  by ob1.hgst.iphmx.com with ESMTP; 07 Feb 2020 03:37:09 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LhTMyYZDExrriPNJFixKuHKYuw/gDuyx03DkOi2ofpFhche/5RtigKvHcgGPf6syK9XdZbgZpmvrKh4rwIC/pHO8z+H8JAW23cy/VfABlqsUAbZ6gE6zZc+2BCP9jKrGxUkFB0igW8rGw2XGOS1osGgCozmaivHo/9cKg8qCXiMW56EMZN56nNp+4mfnWsk6h+2LSYNiySpHYAyhU+FEIWBBJBrB6lT3Y2zuSNISFE1mallRKaib8ScQXS+GK9jqgVBhLR9ffJZAS1dJryPDIeIz0mFUVg9dDvrX65NnFhenGOt/uB9+JU/Y1dIjczcJEzVUMnzEufrn4ALe+kI6KQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9WHyig8zuTMnRE08czRy5SnQx9n2kFsmFFV5dSEdP8Q=;
 b=fZ14zZOwIskVeqdrLf4bSg/NHNvrgGmuQBl1j3UAaRItBYmCq8Z6OzaINAJenmZrCOlkIVBmYM68TiX5bciAXUWeVg2ZyPfT4DQwplzZ5tVgsrQ07c36tpx212GybXY6K39xQaZeKU84QQGXnghmikB55OQgRNb/jLl4IXOjQ9CGbb0yCyi77jmLgEGct9rTfOvMAaHIbTyM0In0n+eHDU3LB3yYHt0coqGMxYkvdRT+hKInsad5EkzOt2sKRDbjdwmT561NPz+3EOJywaBAKm7dMIoXF09RZsoowmTrkEW2vz4vBmDg4KwtOdcFtAUJpQzCE9ij7RvmMTxJ8g1Z1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9WHyig8zuTMnRE08czRy5SnQx9n2kFsmFFV5dSEdP8Q=;
 b=VI7Vk+f+qFP0BaFH70LJN0ASWQam/AM6lGaqobVt+X3w/8Vc/QpnoZ8SreAgmE/tzOhbDuBt19r/HsVmMWMe8MJ1/6mATwYqdVhsHUBt0RuZRXqQOVlL/HwRA9wfg5u8KU+kzWz2odcSfvbroExhJeiWi6bprCjd5zSNoUI8SbE=
Received: from BYAPR04MB5749.namprd04.prod.outlook.com (20.179.57.21) by
 BYAPR04MB3896.namprd04.prod.outlook.com (52.135.220.152) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2707.23; Thu, 6 Feb 2020 19:37:06 +0000
Received: from BYAPR04MB5749.namprd04.prod.outlook.com
 ([fe80::a8ea:4ba9:cb57:e90f]) by BYAPR04MB5749.namprd04.prod.outlook.com
 ([fe80::a8ea:4ba9:cb57:e90f%5]) with mapi id 15.20.2707.023; Thu, 6 Feb 2020
 19:37:06 +0000
From:   Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>, Jan Kara <jack@suse.cz>
CC:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "tristmd@gmail.com" <tristmd@gmail.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH] blktrace: Protect q->blk_trace with RCU
Thread-Topic: [PATCH] blktrace: Protect q->blk_trace with RCU
Thread-Index: AQHV3Pm1sBn7cXCscUyQVcxbWOqGBg==
Date:   Thu, 6 Feb 2020 19:37:06 +0000
Message-ID: <BYAPR04MB57496DF0F065E13FB8CD9024861D0@BYAPR04MB5749.namprd04.prod.outlook.com>
References: <20200206142812.25989-1-jack@suse.cz>
 <BYAPR04MB5749BAE3D6813845E16D92E2861D0@BYAPR04MB5749.namprd04.prod.outlook.com>
 <ddc358fb-8189-fbe9-619d-e3c943a05053@kernel.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Chaitanya.Kulkarni@wdc.com; 
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e575077b-1321-460a-f6fa-08d7ab3bf321
x-ms-traffictypediagnostic: BYAPR04MB3896:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR04MB3896B9AF30CF26D043D2C2FA861D0@BYAPR04MB3896.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:3631;
x-forefront-prvs: 0305463112
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(39860400002)(136003)(366004)(346002)(376002)(189003)(199004)(53546011)(8676002)(110136005)(52536014)(54906003)(6506007)(5660300002)(8936002)(81156014)(81166006)(2906002)(316002)(558084003)(66476007)(66946007)(4326008)(71200400001)(55016002)(9686003)(186003)(64756008)(66556008)(33656002)(66446008)(76116006)(7696005)(478600001)(86362001)(26005);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR04MB3896;H:BYAPR04MB5749.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BiU1FebIXXVCL56aXNSXvNFVMZmbAacwW1XRmqCokSV2QevgC1ghFcQ2oTPOIda8IaSOvjPVYSs/d6RKnQ2cMmTOtoHL1ktL4c/D3Z4vZoCfCU0TEvUJnJX2T4/tftmsQoEnySrCgJgD9MDL8VlmPN9tkxP7OGWcOACKvHY/C0ijkMqB2f1sjMiGH38w10Umlfdhduwra67bHIzP4jojKBfZPJjZZ8Pbqby3pa28IeoWiOCBzJHeUyKcXQ+mYKs4M43IsuZM00pQ0UQJca4p1w0r9ZmDjm4a3+7/ppZJQsyqa+G0ZaiIhl01nBhBhRxMEKxTx1m5mEMzjZYMsVSAB5Jf6Emblg+bvw+lWl8WKQ0gfC724GjQ9O0xzmbylIQ3mydFLH7geo0ZiDbkXT+netsZ7t6TY59HhJHt7OPV3vRr19iCUlSf0hCMMr+gqPRR
x-ms-exchange-antispam-messagedata: mFw0DF5wrBxTM8T1SM0a40XP+CZOgTYsKiCRwfHTlycZq679L1ItXYU1UfvI24sovEgQArjswtYVPEtLk7ErF2G2B4XbJmxEMG4ugSnEqQ0GSOAg5UESeQGaoqc2nX5b7ULsPTAktckCLxklMExeGQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e575077b-1321-460a-f6fa-08d7ab3bf321
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Feb 2020 19:37:06.4885
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XxpNePGhIF6yPzwIr5nPw1ohFXn8ZGKb0OXgD6/ssk35UKuct4s7uvOCF2kkVBeR7LRNaoYKc/i0FWodFUUkFBeNIAw5cMad52kVTDrlI84=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB3896
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 02/06/2020 10:49 AM, Jens Axboe wrote:=0A=
> Let's please not do that, it serves no real purpose and it just=0A=
> obfuscates what's really going on.=0A=
>=0A=
> -- Jens Axboe=0A=
=0A=
Okay, will avoid such changes and comments in future.=0A=
=0A=
Thanks Jens for the clarification.=0A=
