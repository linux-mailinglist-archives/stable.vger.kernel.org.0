Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9224F746CC
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 08:07:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728471AbfGYGH0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 02:07:26 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:2234 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727794AbfGYGH0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Jul 2019 02:07:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1564034853; x=1595570853;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Q55erNfqSJheu+NRbhJxP1DeQEbxRh+oloSkG8o7d9g=;
  b=HXD3nUhTDb/f8H8ARz0ABiriSZDcKU4+bHeRWrFHJEjsIRW+UvTjgFlM
   LlLj1tUY80dbfZgSKf4Jmj3/vUQ/fQQsdj9sJjOZ2nCK7NWJYWKRcfngS
   Yiq+szBvDBQAW693TXdMApP72TaFNvX7ME06/R0pZB0506vQB3ziWbsQR
   4jAoYvVMq8C8/j90rhkGxkv0t8U7bmUgryYnonjjQ+ifKrc7jzQkzBXeq
   y/9EeK/kcn+gPNc1/t4rcLzPvkopb6AxI1CiApGRmMMEcLqJJXgjCbEZo
   xhuFUbSHQ4ekwjSLEEBRGb4Oxk/s4aQveYqw/Gvja5xesmf+Didn1CNr+
   A==;
IronPort-SDR: ZK3EA3muB06xPCUjoc8v0ElACDIFpD39sz23iCEWTwgrukIdLcJvMRRWVHs8CRdmGPQjDZPVnM
 ik/XdHqy2wxWUnlYXuxUJWjX2WdkpTUcYZIOoBAnS7nbnJKb5K01QbB1c+Zyc8Yzm4Xpy6Ysiy
 jt7kMX6uCYEliwkXX/w/EvKjvdNzQomNnSlH6ZuxGgIqK83Zyj0EIPkN4gM49drIe+fGqOeBMt
 fSnL8RYJGkbZS6226MWvfLCg+KK6YsOY6q6051KTw3PGihy58XGQ2K3TDD3cV+Ib649HBJdkuO
 TW0=
X-IronPort-AV: E=Sophos;i="5.64,305,1559491200"; 
   d="scan'208";a="214070413"
Received: from mail-bl2nam02lp2052.outbound.protection.outlook.com (HELO NAM02-BL2-obe.outbound.protection.outlook.com) ([104.47.38.52])
  by ob1.hgst.iphmx.com with ESMTP; 25 Jul 2019 14:07:31 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HpAdg26dl53MErwnR+t/UyMc3/R4hxo1HCiic/eFYJ+Zue2vJVZUPIXRWH/1e9x4SNJ/XXpLzpIo9rjNuDhhiRWGNIzBh7LE00BwNAWcTqUSJwbO7xQdmwfUHTpcvfZOnep5PzMZJyICd0JjgKQ5iZ2cGAVgFo7DFqPhYYOwjQfPhYwtK+Pm5TyDKdmb13pEWfh4DVX19EnHBLGUfLOj7WncVem/q9jhbEJcmhOrUuPEtXWeFzddShfIHIY+hclGmtAMSzWPd0nacp+1sXLw0aZVSlctQUoZD7zKT7CaIivrnzj4ubS1YugjF1lJE1EQdea1eflu1wAFZcWOvz3p/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q55erNfqSJheu+NRbhJxP1DeQEbxRh+oloSkG8o7d9g=;
 b=CJbHrrGDfBqvIwwWOs7mNciymCDsLwP3a+wPqxhmGsUOXfuCS10VSrZFTDvtUwGItKYtKIxvkM/bfUpawB4RUMGu/gxBlIdXSrPUglMXPkx4S7iGqGuFfFsSrfHS9jV+iMfZd0bwHEGBRlj+5JgbssfbbLi7kLSGZqN9L2/AcPJLoccovwh72r+2lpDA+sGjaBF3oaIP5NAjHy5djXD3Pl15mycmhPz6hWTtqrqzXyYASy8GagmkvdiHBAwfi4tz5jVl8xOcF4f66ddbBN4mw9eaLtYfY2OK8N75O40HdpNpEW06Lg3A0IUVdg/A0X2Dh2As43j6cvDA68dY0jStbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=wdc.com;dmarc=pass action=none header.from=wdc.com;dkim=pass
 header.d=wdc.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q55erNfqSJheu+NRbhJxP1DeQEbxRh+oloSkG8o7d9g=;
 b=KVf0njSxOCBtyMM5+J3VrmNezXwfsrS6HH6a81J+CeanIbSfRaUxfSbZ85jnRtlFStkgWFIIBphMx+TeEh6kXV3y8gXToFaEqZiyVqH7DnuiHyVZq3Ey1yoUdxQgu6RiMi0LLU6oojr7dxDBGjntzN0UMoCCXBsRBUwE2iaXxxM=
Received: from BYAPR04MB5816.namprd04.prod.outlook.com (20.179.58.207) by
 BYAPR04MB5894.namprd04.prod.outlook.com (20.179.59.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.17; Thu, 25 Jul 2019 06:07:23 +0000
Received: from BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::65a9:db0a:646d:eb1e]) by BYAPR04MB5816.namprd04.prod.outlook.com
 ([fe80::65a9:db0a:646d:eb1e%6]) with mapi id 15.20.2094.013; Thu, 25 Jul 2019
 06:07:23 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     "hch@lst.de" <hch@lst.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] sd_zbc: Fix report zones buffer
 allocation" failed to apply to 5.1-stable tree
Thread-Topic: FAILED: patch "[PATCH] sd_zbc: Fix report zones buffer
 allocation" failed to apply to 5.1-stable tree
Thread-Index: AQHVQiwhSIqlbReJ102fhXBOfwyVjKba2hkA
Date:   Thu, 25 Jul 2019 06:07:23 +0000
Message-ID: <e5527e8a83751616a31ee9f6a49295e4ba7332e3.camel@wdc.com>
References: <15639782522644@kroah.com>
In-Reply-To: <15639782522644@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Damien.LeMoal@wdc.com; 
x-originating-ip: [199.255.47.11]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 532d0683-5389-4781-f0b0-08d710c65c4f
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:BYAPR04MB5894;
x-ms-traffictypediagnostic: BYAPR04MB5894:
x-microsoft-antispam-prvs: <BYAPR04MB58949FF4522D0BA0371E8678E7C10@BYAPR04MB5894.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0109D382B0
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(136003)(366004)(346002)(376002)(39860400002)(199004)(189003)(6486002)(118296001)(6246003)(186003)(25786009)(53936002)(4326008)(478600001)(26005)(8936002)(2906002)(2201001)(76176011)(76116006)(2501003)(5660300002)(64756008)(66556008)(66446008)(66946007)(102836004)(6506007)(66476007)(91956017)(36756003)(71190400001)(66066001)(14454004)(476003)(81156014)(68736007)(81166006)(6436002)(8676002)(486006)(110136005)(71200400001)(58126008)(7736002)(305945005)(11346002)(446003)(86362001)(3846002)(2616005)(229853002)(316002)(4744005)(6512007)(256004)(6116002)(99286004);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR04MB5894;H:BYAPR04MB5816.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: QepTrRZ5VWjEZLGK9KF0sW3vaXUwmB6yfF55LTMoAKPBLhyU3inZSVeWjtg5fSH2rs+xxmQIQgfwsr3FjSfOECJTAREWN7NanS/hJz7C/ve+DPIrLpe/oM2TICrUT0CfJrSINsU6I/P7H0QAG0ldgzZnTdYQXYdSohxupsBooOpQAfMrYq47ySeOgM9jETpkYeGUNsYzijGi1gWHgAIh7qgmIjQHgbuwGx9XrOi9BFvYqLvwQe0OCtUpvKS8FjrPIiInHdqMniDwWhnk+2xzzwt31WgmPlpa0kHHIM74fmi7NvHLqIeljzsG1uPtH8YFRCHCl89cqjAL3Y915P14cnwC2ZeynMD2tfU8M9wRaFXJI9g6fuyOaplMPSqUfVlQqB9dl1tEijI38PjFxW46O6lxFS48s9B9aCzUHLGG0g4=
Content-Type: text/plain; charset="utf-8"
Content-ID: <68D8A32496172D4B933FA6C69534C3DC@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 532d0683-5389-4781-f0b0-08d710c65c4f
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jul 2019 06:07:23.3287
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Damien.LeMoal@wdc.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR04MB5894
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gV2VkLCAyMDE5LTA3LTI0IGF0IDE2OjI0ICswMjAwLCBncmVna2hAbGludXhmb3VuZGF0aW9u
Lm9yZyB3cm90ZToNCj4gVGhlIHBhdGNoIGJlbG93IGRvZXMgbm90IGFwcGx5IHRvIHRoZSA1LjEt
c3RhYmxlIHRyZWUuDQo+IElmIHNvbWVvbmUgd2FudHMgaXQgYXBwbGllZCB0aGVyZSwgb3IgdG8g
YW55IG90aGVyIHN0YWJsZSBvciBsb25ndGVybQ0KPiB0cmVlLCB0aGVuIHBsZWFzZSBlbWFpbCB0
aGUgYmFja3BvcnQsIGluY2x1ZGluZyB0aGUgb3JpZ2luYWwgZ2l0IGNvbW1pdA0KPiBpZCB0byA8
c3RhYmxlQHZnZXIua2VybmVsLm9yZz4uDQo+IA0KPiB0aGFua3MsDQo+IA0KPiBncmVnIGstaA0K
DQpHcmVnLA0KDQpJIHNlbnQgeW91IGEgYmFja3BvcnRlZCB2ZXJzaW9uIHRoYXQgYXBwbGllcyBj
bGVhbmx5IHRvIGJvdGggNS4xIGFuZA0KNS4yIHN0YWJsZSB0cmVlcy4NCg0KQmVzdCByZWdhcmRz
Lg0KDQotLSANCkRhbWllbiBMZSBNb2FsDQpXZXN0ZXJuIERpZ2l0YWwgUmVzZWFyY2gNCg==
