Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9A252117D
	for <lists+stable@lfdr.de>; Fri, 17 May 2019 02:58:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726953AbfEQA6G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 20:58:06 -0400
Received: from mail-eopbgr1320135.outbound.protection.outlook.com ([40.107.132.135]:32016
        "EHLO APC01-PU1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726901AbfEQA6F (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 May 2019 20:58:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=hpNRBdU8DnQjLHuciZS/9q28RcKl7j9CoYQek28xs8Q2XElnnwHGAkS/+gWlldmRYv1gZeoVjrLeVN8OmOCT350BPyc/7yrKFyLdQlVCxhm4aQOr1vs2u5U0cHQWamaiOMYqXQ4BYx/WGKtSbHmaMQIyS/MzL1RzczUpOyDh9bI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ik7Pw2aeRQa57X1bRWTXCSmWPEW8w1/M+tSdySighhY=;
 b=PzixlQWjV8CDJt1xlEaRq9WSkNKynNucMHdTif8A0+PymTIP66up9siur3Yu5P1fn0F5PcSQar+XfRWwuruZQNA8S4m74bbSjP78Bd9DNazIIhozs0O0iEjhHH1MBwZIU6n9zAfNzXzI+fHOBlh8M72P+bbSXAMhLdCiPCqb0rU=
ARC-Authentication-Results: i=1; test.office365.com
 1;spf=none;dmarc=none;dkim=none;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ik7Pw2aeRQa57X1bRWTXCSmWPEW8w1/M+tSdySighhY=;
 b=NHYcCmbU8NxaKsc2nj65AFrsnQQMETmGsM/pndN/1VoHDIaHFG+w9NU9AuuWr46eVWKygJtBJ8gpQbh1au77qJ8Seu/Ub9YupvF1WfM0UJ/F6nPPUasNWDjx/pp0CZTpProgX0+p8r6cC4IqvAD1myZR+NAHxoGx9DYlC7dowlU=
Received: from PU1P153MB0169.APCP153.PROD.OUTLOOK.COM (10.170.189.13) by
 PU1P153MB0201.APCP153.PROD.OUTLOOK.COM (10.170.190.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.3; Fri, 17 May 2019 00:58:00 +0000
Received: from PU1P153MB0169.APCP153.PROD.OUTLOOK.COM
 ([fe80::dc7e:e62f:efc9:8564]) by PU1P153MB0169.APCP153.PROD.OUTLOOK.COM
 ([fe80::dc7e:e62f:efc9:8564%4]) with mapi id 15.20.1922.002; Fri, 17 May 2019
 00:58:00 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Sasha Levin <sashal@kernel.org>
CC:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "lorenzo.pieralisi@arm.com" <lorenzo.pieralisi@arm.com>,
        Michael Kelley <mikelley@microsoft.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: FAILED: patch "[PATCH] PCI: hv: Fix a memory leak in
 hv_eject_device_work()" failed to apply to 4.14-stable tree
Thread-Topic: FAILED: patch "[PATCH] PCI: hv: Fix a memory leak in
 hv_eject_device_work()" failed to apply to 4.14-stable tree
Thread-Index: AQHVCvkJaDgNxZ8BEkOcR/891njmX6Zs0sswgAGp4QCAAAMEkA==
Date:   Fri, 17 May 2019 00:58:00 +0000
Message-ID: <PU1P153MB016990F46FF3D679D4944D5ABF0B0@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
References: <1557909270643@kroah.com>
 <PU1P153MB0169D8FF719D8718F6B3157ABF090@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
 <20190517004148.GV11972@sasha-vm>
In-Reply-To: <20190517004148.GV11972@sasha-vm>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=decui@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-05-17T00:57:58.3077694Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=56cba5c4-8e7d-4458-9674-2dc5e1a416a4;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=decui@microsoft.com; 
x-originating-ip: [2601:600:a280:1760:e49c:a88d:95f1:67ea]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3f3ef192-ab7f-45b2-6dc1-08d6da62b57a
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:PU1P153MB0201;
x-ms-traffictypediagnostic: PU1P153MB0201:
x-microsoft-antispam-prvs: <PU1P153MB0201D8611CFC3A278EF49812BF0B0@PU1P153MB0201.APCP153.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0040126723
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(376002)(136003)(366004)(346002)(39860400002)(199004)(189003)(229853002)(5024004)(55016002)(256004)(10290500003)(7696005)(74316002)(5660300002)(6436002)(11346002)(305945005)(9686003)(8676002)(476003)(71190400001)(71200400001)(33656002)(7736002)(6916009)(8990500004)(4744005)(10090500001)(52536014)(25786009)(2906002)(46003)(6246003)(186003)(6116002)(316002)(102836004)(68736007)(4326008)(76176011)(64756008)(66476007)(66556008)(66446008)(86612001)(86362001)(53936002)(446003)(6506007)(81156014)(81166006)(54906003)(8936002)(66946007)(73956011)(486006)(76116006)(22452003)(478600001)(14454004)(99286004);DIR:OUT;SFP:1102;SCL:1;SRVR:PU1P153MB0201;H:PU1P153MB0169.APCP153.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 7Ov92KjSyxmkVEsM2yUpe4W/iOEFAr7OHx94vjGRTywmzYu6er1pwA4gNfxhhxm6IB5YCORzqA9kquygj/4f3xelIWU9JYMkSr6ij+3W+t83T9bjQQwF7+TjqmSXKl1E7oPYoisCY/4ZeZomT9NWKUcpGnL2cv1ioYVFl9TrfWMTm4uNCaf5nAQuqc8SSNxQzhr7SoEV8NMR9rYjSQXgHE9+1SAAj6YAF2RNi7pDXJw1qdKnCwGV8OjwnysvXYiN87/0uEFH5ljTxQ2UzaSA0rtwwv1lFCLBkmeCmV4odZ4WxaStHlDjo46R30XgGtZXcVeiO3aMizIxqZm7gwZ5f1FPQIHdWZMk/TrhO+MGKY6csM8US76ism+iwXcgLMUaROdT/1D907z3SF3hOpYA0fABKeYcO2mCVyvW8im61yQ=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f3ef192-ab7f-45b2-6dc1-08d6da62b57a
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 May 2019 00:58:00.1276
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: decui@microsoft.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PU1P153MB0201
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> From: Sasha Levin <sashal@kernel.org>
> Sent: Thursday, May 16, 2019 5:42 PM
> On Wed, May 15, 2019 at 11:18:56PM +0000, Dexuan Cui wrote:
> >Hi,
> >I backported the patch for linux-4.14.y.
> >
> >Please use the attached patch, which is [PATCH 1/3]
>=20
> Hi Dexuan,
>=20
> For future reference, please keep the commit message in the backported
> patch same as the upstream one, unless you want to add additional
> information about the backport, in which case just add it to the commit
> message rather than replacing it.
>=20
> I've cleaned up the commit message and queued it up for 4.14, thank you.
>=20
> Sasha

Thanks, Sasha!=20

I thought only using the concise one-line commit info would be better . :-)

I'll follow the rule in the future.

-- Dexuan
