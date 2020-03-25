Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42147193097
	for <lists+stable@lfdr.de>; Wed, 25 Mar 2020 19:46:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727491AbgCYSqT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Mar 2020 14:46:19 -0400
Received: from mail-eopbgr1300109.outbound.protection.outlook.com ([40.107.130.109]:3278
        "EHLO APC01-HK2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727027AbgCYSqT (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 25 Mar 2020 14:46:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l0/akW0+/jxVV1yO8/SNGnTenboeK4QI83LyLFopr/JkacjtUmPcAUNOsKXMpCneEBBmmF4S675e67ia7LLGYt9e0qx6AMD3VA57Su8zosI8Vn9vxiY7b1Fz0RGgFFv08N8kuD5hPQsUmORKvig+oPcnsQSOZVzGBLpAicXdGvcLUkiAsond9TI6ggbNIbQE0VSTzJjzk4zM0VoFB+uxKuasDOIKcLjIg2iW1/HMJ9PEMpa3QQn2fTdRBZmE6dY+gdfW1fL54K7ydJ1a2TyYGzSnwex8FwA6agLgL3TSdprpYz3OnUKb4PP3my47TcDSbGMCBi7yLnr9jPk0bLG0Ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9y1sBBsEoSHTNIwfSIa7HjqizKab5qUjk0buT2t09XU=;
 b=LXzR9z0yx53BbWFO0qzZr1kUtl5Wj5yRPZAVH6gRVUJBRjyY6AB4x6LTbJXNcEglpOx6ScVehW/dLqxKuB1V4XkvS2Ynh14JMhrUQaZz607dTsz/e5ijx/bgHrhL1Z9wnZePXKM3XUFj2UJqP+GDtN03AkaJKQu5xN5HDKB7ZX89Pn4WQuk8N3rR1ignt4ckjIms9VP7CBOYuZ1ZNwKNRdI4DJ8+VmzwReL3yFQxDImrBi8CXs+OyPysVakGq0sXvO80dm0PkFX/wqmHXxvwXG3T6TuR6WoYuUKbTnTLksnfZGI2kk8M7/PBcmGQYct2jQaEM8rVJqmtow8yjYY0nA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9y1sBBsEoSHTNIwfSIa7HjqizKab5qUjk0buT2t09XU=;
 b=adnY5bf1ldo2XP3jAwNJ07I7FL2h678iV6H9bgFDWHlK9jrmmt8dXTPZRtlZfUhxIYuLfnmOo8X3s4nW5WcYMwj/qTBaG7FtnGJReihIOqh7odDSwpM8ASdTCS1yWbK622zQdh4FK76BV3sme4GoFJC3D7Ebgo77Z7A58HYB5KU=
Received: from HK0P153MB0273.APCP153.PROD.OUTLOOK.COM (52.132.236.76) by
 HK0P153MB0145.APCP153.PROD.OUTLOOK.COM (52.133.156.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2878.2; Wed, 25 Mar 2020 18:46:09 +0000
Received: from HK0P153MB0273.APCP153.PROD.OUTLOOK.COM
 ([fe80::2d07:e045:9d5b:898a]) by HK0P153MB0273.APCP153.PROD.OUTLOOK.COM
 ([fe80::2d07:e045:9d5b:898a%2]) with mapi id 15.20.2878.007; Wed, 25 Mar 2020
 18:46:09 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Yubo Xie <ltykernel@gmail.com>, KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <liuwe@microsoft.com>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        Michael Kelley <mikelley@microsoft.com>
CC:     Yubo Xie <yuboxie@microsoft.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        vkuznets <vkuznets@redhat.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>
Subject: RE: [PATCH] x86/Hyper-V: Fix hv sched clock function return wrong
 time unit
Thread-Topic: [PATCH] x86/Hyper-V: Fix hv sched clock function return wrong
 time unit
Thread-Index: AQHWAe+sIAx5Fyul2kCy9Ve4hkotjqhZotyQ
Date:   Wed, 25 Mar 2020 18:46:08 +0000
Message-ID: <HK0P153MB0273AEB3D64694E8DF31C0B0BFCE0@HK0P153MB0273.APCP153.PROD.OUTLOOK.COM>
References: <20200324151935.15814-1-yuboxie@microsoft.com>
In-Reply-To: <20200324151935.15814-1-yuboxie@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=decui@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-03-25T18:46:05.1806297Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=5f141aee-3c29-4a29-a518-1eaaf4ed75fb;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=decui@microsoft.com; 
x-originating-ip: [2601:600:a280:7f70:5896:cf8a:cefe:fd7]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 40370955-164e-446a-ca3c-08d7d0ecc897
x-ms-traffictypediagnostic: HK0P153MB0145:|HK0P153MB0145:|HK0P153MB0145:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <HK0P153MB0145F019E012A065DD12F30DBFCE0@HK0P153MB0145.APCP153.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:1923;
x-forefront-prvs: 0353563E2B
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HK0P153MB0273.APCP153.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(4636009)(366004)(6636002)(86362001)(8676002)(2906002)(110136005)(8990500004)(54906003)(64756008)(81156014)(66556008)(66946007)(66446008)(107886003)(81166006)(6506007)(66476007)(71200400001)(5660300002)(9686003)(55016002)(8936002)(498600001)(186003)(4744005)(52536014)(33656002)(7696005)(76116006)(4326008)(10290500003);DIR:OUT;SFP:1102;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rNG3kqcVDkUi3OWc+wWizxR0kV324lyjZKVbeEe3qAi0tj+lBb9KjbVNY03C5Q7oBAKFXswH1Yuky+SZ3D/Bo/XAezeasB9BhYjU46jDdLDteFLurF6OaAw1MujwhpkaJcclqlnhc0qxIw5yodmgwLJ7+cikmjmE3HOGcejSOKpMfgKcvb3lwNkEoK2lcTElJ0np7DxyASJfgPBk4vMHzx3cbhleEsn4Q2I7jSMElrFhEB0TfOkh+Pm3lOyKQ0Dd/Hz45D02GYpmVaS3Qw8X0f8+pwCGIeKmS0FTF88g15n/3cKyIvPg9LTDj9yPIQvta3DYPexJZBg4O/b5iVWMIBOfYKNyQDsYsuusyWWEMC3qWQtxRxgdBrsIRQbkiqPttdQRF1X3CKZC9tKBjtHSRJsgm2Ms02HlUDcjqvIIzagYGmddIwHysptKciFpAKeC
x-ms-exchange-antispam-messagedata: Iw9i+7E/2lre9msuHgZHT+iRyf4AslnQIJHYXD3eA4rKYzldZWy6knS0Uv9ikn1K8cnDDYHtXsvpTIwx9kIIG0VhI7ZVr2AsirrTsMJO8TpjKONR1O2itkeoHJT6gnUnT+qfGPyyE+yuUCu/ZWNoGl27O+xs6nFxbnl+Bk6v/AjP7j0dNZ1OcYyGW4E/hRm9VG308sqWsqy9eRQk1Uqmrg==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40370955-164e-446a-ca3c-08d7d0ecc897
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Mar 2020 18:46:08.8297
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tuNX0ND4ggfXj/+pMSK7VsWr1lr+jSxE4uk0LDHFnsfokrUAKuRgLALu0TnRBKTgeSmV2C8dyN9ccNExEHOsQw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HK0P153MB0145
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> From: linux-hyperv-owner@vger.kernel.org
> <linux-hyperv-owner@vger.kernel.org> On Behalf Of Yubo Xie
> Sent: Tuesday, March 24, 2020 8:20 AM
> ...
> sched clock callback should return time with nano second as unit
> but current hv callback returns time with 100ns. Fix it.

Hi Yubo,
I'm curious how you found the bug? :-) Did you notice some kind of symtom?

Thanks,
-- Dexuan
