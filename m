Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4434720F56A
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 15:09:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726935AbgF3NJN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Jun 2020 09:09:13 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:14118 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726744AbgF3NJL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Jun 2020 09:09:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1593522551; x=1625058551;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=RUAKv7/hjBSikpyghctcaOWGRNCM/BrsJZpnDk9mXjQ=;
  b=YnnNBZsAsYpss1qRsMywZJYI8UYvESkK2FbYdRygn0gH3moV4beJoTsq
   YuC04uqRSm0gSZGshmhU3nbLe+QqYczjPuVI0bPKLDofzYh0El9rxWk9K
   C+bWKH+GkenIVbUoG287oPY9O3q4PyVvRmeLkkG0H7XKQL+IbhSJk0jL0
   e8+KMGGVupIPWX4vYLF/lObZKWvw/1pOe4pqJmgXvbHnvQFQcIuDXMxpY
   940u/CxREJvltUZEy1z0J2nBFPaTqIMV1sNL0/e7lbBoUvcIW0dCrIo2C
   ++mpjwx9jJEeYlMvJgBhT4vLdWEZi9yGtYgCL+0DIck+0HyceuUg5vZuA
   Q==;
IronPort-SDR: bn+1zw41kptO9XhliRRafgfVjAUs7nkfrmO93150Rz8srmSF/TqK+sJ2REAjyh8VxQHtz7AS1A
 w1Uc3bE0KQZECf4IBM0QGzv9NT9QwRO7h92QtIjam3vSo6MpDFTO8Mc/A8X4SHNOZ7JY74PGOK
 KrL2kKSwxTl90Mzu7UNnQDRMH+NY+QJ9LtRfuLmLsvcutv/B8uExROk/64YBc8qmBYs1d9mlCj
 SJghBhq1ZGT13bZRy2Xbb3a5PbAlUaynUFqJicktRSdLtjQrn2z3yB9TG/h0jfUNWyoLYLtkd1
 pdA=
X-IronPort-AV: E=Sophos;i="5.75,297,1589212800"; 
   d="scan'208";a="141485084"
Received: from mail-mw2nam10lp2109.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.109])
  by ob1.hgst.iphmx.com with ESMTP; 30 Jun 2020 21:09:11 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xl5HYRyjAwOycphoumS+zbBZvtz4WxSRAyUSoYwY6Yt6LVUsVXqbyJVJgjNlEdEBCeM45qdRVpEYf8FUocns3hpCAjoAu1/BC9GKgWra8Tvf5Ya3ilbAGPLaTmb4WuMysok26Gvw4pwMgYbZ64nFwfot75+RHCa4/r4k7KBl4z6FecwXSWCmATNMjsi71EdhJwvXAtHQwIIbt1uvXr1R3i3kqTmKiFjWY+G4HotWj26LY7A8ZQFXC1RLpKcKIp6qi6qiKFBSiPCGIyytXg9ezTLexs1hlWoWH/H209nb27W5LB05KVz/c7Iwye1M5ZdDcQo3+Pp+CiV9YyT5KaqqmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RUAKv7/hjBSikpyghctcaOWGRNCM/BrsJZpnDk9mXjQ=;
 b=ZhjOO4Y6zVOe9GBadlwnssbmTKvMcXogjqUC6gmQnelG9Mg4/L7QmbsKCrzYY0Ywk6v24GcmkdcLmm3xh47uje3UvSOq4Q3RwMQIB8I4bi2nioEbodDUCK39f+17oLIZ9dyoCG1yweuBAKKv/xG5i7D4OlblsyU7ii5zBAcwBiRVYpo7W9EQ67YH7o1uuudhhLbWfeaAXtbtaaJsZLEgZ49kDsCdm2IWTto2stEN29USIJzy8dAsDBMMhfUYtwkXAJJ71cEaqbwe3O3/egOL1f7eM8uBD+Y5s3nwm42WVCslih+NgK2TOhTpK2H707AnGllq05I2rLNla0AzdMZkXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RUAKv7/hjBSikpyghctcaOWGRNCM/BrsJZpnDk9mXjQ=;
 b=ymHN31fZQR+jRClKNSr8E1erI4d91kETO2WpC6oJs8HfHg2pb5RHwuydK33/kZrdNMJR0g5B+eSDzTc1LZ6B8tkum3U2bkDGpcM5/zPa7oLdW/9Saas+1hC80vxU7SwT5iC5+2U/BnfmHM5NU3kR9w7E/y3+KXtAnLOraIwbd78=
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 (2603:10b6:803:47::21) by SN6PR04MB4784.namprd04.prod.outlook.com
 (2603:10b6:805:ad::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21; Tue, 30 Jun
 2020 13:09:09 +0000
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::1447:186c:326e:30b2]) by SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::1447:186c:326e:30b2%7]) with mapi id 15.20.3131.028; Tue, 30 Jun 2020
 13:09:09 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Hans van Kranenburg <hans@knorrie.org>,
        David Sterba <dsterba@suse.cz>
CC:     "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v4] btrfs: pass checksum type via BTRFS_IOC_FS_INFO ioctl
Thread-Topic: [PATCH v4] btrfs: pass checksum type via BTRFS_IOC_FS_INFO ioctl
Thread-Index: AQHWTepoB6oio6k7uE+fiuF4wWRH6Q==
Date:   Tue, 30 Jun 2020 13:09:08 +0000
Message-ID: <SN4PR0401MB359836571F4572136EF1981F9B6F0@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20200629075329.36969-1-johannes.thumshirn@wdc.com>
 <c9145a96-95ba-6f6d-c22a-8ba0d324e39e@knorrie.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: knorrie.org; dkim=none (message not signed)
 header.d=none;knorrie.org; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [2001:a62:1515:bd01:8525:1965:641f:1b27]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 05ffa101-1bfa-40ad-7c93-08d81cf6c67b
x-ms-traffictypediagnostic: SN6PR04MB4784:
x-microsoft-antispam-prvs: <SN6PR04MB4784128D3F5589C3CBF12C149B6F0@SN6PR04MB4784.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0450A714CB
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: l6BSFiFVGF7szYxB9Qh2q4xOhhfs2XtGkr57zb/Cmw7LCT87PpJgBjt1XS4LsaoWywtmWLE9dgvqbaNQrth5wyH/Pl5w9gpv9QfF+PTbge366DrXDwT9f5MZwkcm56DASwELcI/JbvZCOBV4BZzvTFWO9i/875tXl17+UcMvE9wkcUEkssVBHliPhZlH041nrjUp9QAc1Dg0O/4UjW8zcmlVWCg9PPKMyBbnVFGOyIOqTb4oGBT18CABl3pvCn2w4w3kuGT7tBE2C9OCDCjy2W2ndpiCA5PE/ffCef1vsbsx2LFRKMWz0PODyY9/rqtmhd71+PNdz5Gr5tccpvzUNA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR0401MB3598.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(366004)(396003)(39860400002)(376002)(346002)(8936002)(8676002)(186003)(5660300002)(4326008)(7696005)(33656002)(52536014)(76116006)(91956017)(86362001)(4744005)(66446008)(64756008)(66556008)(66476007)(66946007)(55016002)(9686003)(316002)(71200400001)(2906002)(54906003)(478600001)(110136005)(6506007)(53546011);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 262aP8VvYngROP45PqgvyaKTur0NBfVmLJFUztOmpN/zfSEZGsWiYI0/PhkiNXsanlCQIizGZ5R23pWW5wawWXRDOuVz15Rgob9vRjlZ4E6aokXfDAIBXOY92cRu303zoYUurGGIgL0jenOBykvV8mSkkilT9N/VlSWTnPxbYmYx72y1OUUPb32IQHhJXAdD6a8yv0Bxy3bH6p+YOANM6JBwi7K6rZkS69IXL22enyJ/5Wx+eNwJ3fefaKVBpalR+FOJPMoJFSh05L47Y6Svjm+LmRDE4OUVcvseHPNpYgb5Pp86ylGSZPCvHle1TT5KM/IqBSut+SPeQjSKiayZxV8MIC9LgfSnyiN8OnYqGOLU/05jibHlktiMsT6Sj0qCDZCm6xKu+NIlzq++Zt3AcUz4Gq+X2V2LVfR19GsktnIssN8ivSU2/J1ZBtzPGf/JtvN4evbs7+2i2WhiCDcCmtmurYaBjRedZLNJ/WQgy3dlxSS95j3+QrgI4Qh9OLTv/MJe+v2MPgbQlEiECHiS6/i804SRFH494rWb0BZzzCnWM+xiw/svjyPtuRYcrHn/
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN4PR0401MB3598.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05ffa101-1bfa-40ad-7c93-08d81cf6c67b
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jun 2020 13:09:08.9110
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8E0zp7b6Y9NZbDsKpe7VhkN19uqvLTQ54IFIIPXshnv1JRDsqAz2LR+1NbnEeIU33PLqlgpEnPJFKsErbji+uAjsw0h1z2d3BissGb5jEOE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4784
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 30/06/2020 02:25, Hans van Kranenburg wrote:=0A=
> So, (apologies if I'm already causing you a headache right at the=0A=
> beginning of the week), I'd say... Let's for now park everything I just=
=0A=
> wrote and drop the whole idea of using input flags for FS_INFO, and keep=
=0A=
> it output-only and just properly document the output values that have a=
=0A=
> meaning with the flags bits. Because at least we know that the unused=0A=
> output fields were zeroed before (phew!!).=0A=
=0A=
So basically you say we're going back to v3? David, do you want me to =0A=
resend v3 as v5?=0A=
