Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B9B71F3748
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 11:52:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727093AbgFIJwq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 05:52:46 -0400
Received: from mail-mw2nam10on2131.outbound.protection.outlook.com ([40.107.94.131]:21729
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725950AbgFIJwp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Jun 2020 05:52:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E8eppaCtiD8sI9M4Cm27AioI7c9RILbRF22eKJv67hJVq9NiTRp041cstKw9HjQBhNCyciJjrZ7TC+8UuesQpIio+ioVKVZIic6O4WyU8gedkCnJ7ymkClwYD3ONEO/r42RSWe2uEjRKEnp4zssCXXMSklc5f1mk3uV4LkCZ4RvIw/AJBYE0iCbc+/FkQ3o7zFDxQGJh0Qxz0pJB6BhC9u8E1pNn86XwGkNBcHCPbMBiWMqRD9y/UOqHX6sRGwoHE6s0+twL7Ll806eYsgSLKO4GaIwu6xZ6IAUZn9x8kQPWGIvgZmWX21BKGuonaxnSMtmois1KfoOmVmPNG7qcUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9gVJ7f3oC5cplpF64Z/kI3cYvOWdGKOHnYbu+fNmqQ8=;
 b=RJueL2umKMRh0991msSo0Djyx9ZCf11cqqr3pS565WqjmdoWnsWMwyMZRXGIu4zkW4Ii18P+FyzGjwPMgqdQoGWFbz68frQdkmcRNWsJEXYBenFflkGPrWYgo7MAEUDt+L502OmncJiF2AAZB6mILJzlb+g3pPpFawKKf6ho5kxpuJ2oo7kQL4QQouoVdC1aqg3bLFIfln7FGbMKqMKba1t1l0xCiFLt7T+RgwhL74EPySBwDgbr7NEclYoAOGvkIAVaZYbvIBZ+7tW+6A6qzAgFLpxCFbLL/xZTeHC/ir92bwtpcvZwhPtHxwOJMvUbuCcFl37hglIErLkTH1dOaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ugto.mx; dmarc=pass action=none header.from=ugto.mx; dkim=pass
 header.d=ugto.mx; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ugto.mx; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9gVJ7f3oC5cplpF64Z/kI3cYvOWdGKOHnYbu+fNmqQ8=;
 b=n62CEeZGfFXr0XuZekcRJgE3eEW+sZJerqvrY4zVb8LmTNy4eI47TzVG1HLsyw4aYiktqThftKIfNChMizgSz9vcBtxlfk8YiGlMMVL0OQtW95hmuzC11oHwhhCaHa44gG6NTVWxPtzpgZWk1JkU6TsBRG5CjSmz9eEyUrzDPU4=
Received: from BYAPR02MB5366.namprd02.prod.outlook.com (2603:10b6:a03:65::30)
 by BYAPR02MB5285.namprd02.prod.outlook.com (2603:10b6:a03:6c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.18; Tue, 9 Jun
 2020 09:52:39 +0000
Received: from BYAPR02MB5366.namprd02.prod.outlook.com
 ([fe80::55a0:ac58:81a5:2161]) by BYAPR02MB5366.namprd02.prod.outlook.com
 ([fe80::55a0:ac58:81a5:2161%4]) with mapi id 15.20.3066.023; Tue, 9 Jun 2020
 09:52:39 +0000
From:   Orlando Reyes Herrera <o.reyes@ugto.mx>
To:     Orlando Reyes Herrera <o.reyes@ugto.mx>
Subject: Re: Hello
Thread-Topic: Hello
Thread-Index: AQHWPj9V/Tj9GOHQq0aqtT+MNbZ1KKjPjRaAgAABaICAAAJDgIAAAHEA
Date:   Tue, 9 Jun 2020 09:36:59 +0000
Message-ID: <BD698136-9A28-489E-95C7-6258ECB298E8@ugto.mx>
References: <A845BC24-A037-4E10-9DBF-A0498E9436E6@ugto.mx>
 <0BC2C1BD-1E04-4ED4-9DAD-E35E6C4682B5@ugto.mx>
 <229F2B24-C4DD-4FC3-8916-CB9839407659@ugto.mx>
 <D08C3ED4-5F89-4DDE-9E3D-7C27CDFD50D1@ugto.mx>
In-Reply-To: <D08C3ED4-5F89-4DDE-9E3D-7C27CDFD50D1@ugto.mx>
Accept-Language: es-MX, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: ugto.mx; dkim=none (message not signed)
 header.d=none;ugto.mx; dmarc=none action=none header.from=ugto.mx;
x-originating-ip: [129.205.113.56]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 31297b85-fb13-4246-a837-08d80c5ad8dd
x-ms-traffictypediagnostic: BYAPR02MB5285:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR02MB52852969FE8EBAE09E000BD8F1820@BYAPR02MB5285.namprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1169;
x-ms-exchange-antispam-scannedurls: 17573975298564142132;5959347087216061301
x-forefront-prvs: 042957ACD7
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EnVnSMQS3IshI6jbOiygk4lGd8LbEnLcuej3+Eni251ACSw9sDJ9Viz4M4IO0QHiKqnTRAjDWOP365q1aGSYoeD5QLWbGnbHaTywf87gkDs2MBmKvtwTB9H3bouEjvKbvaCgRt4UOkMurC1S8hIEIBY4zulYOPzvEpE3cQuZcRutXamHkJQV+b33JnW7S8JLCqYd/j+VPvQhuJdygmY8lXFoR79Qn5eqZj8/xYWW0ks71Tnk6Q/z2gILV860Fc+MZAY+1TFYw6XIl55C2jkE8sto9dSMXWIMSfPa4DXlPkX+BnxpwRLoISoz5TPqo3Cdax0ODooAFLPFDxz6dt412c9IHkuYhiUGJm+Tf1npGYzoQJ/ezD72x9/8oe6rG1eSaffFtFHqMjkkJ6d9P4itACxtMm8cTqzaP4qz0shEv5ndXcWuRZDvVRKLIYPjQVww
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR02MB5366.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(366004)(39860400002)(346002)(376002)(136003)(396003)(6862004)(6506007)(6200100001)(3480700007)(33656002)(316002)(26005)(86362001)(186003)(2616005)(966005)(62860400002)(7116003)(8676002)(5660300002)(83380400001)(36756003)(6512007)(2906002)(786003)(76116006)(91956017)(8936002)(66574014)(66446008)(64756008)(66556008)(66946007)(7416002)(37006003)(6666004)(66476007)(4744005)(478600001)(71200400001)(6486002)(8484002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: H+5Ag9excckCVlemCk9xSpki1ERRUz0KYSq5RGTfhnlC95E1MA3bSy9eXfU+/Zass9IuqCqzZu6f03XiobZDfaSIx02FcTcf61qZYlSgvTk9A1ISg3jXQOsO0HxTQni9tAu7JOcSBTrb2wT1Dk0xNaooKLYBwaxHwE6OqO0DCEqlvWh9I3q1KJJGIv1ovW94IigV+oX1jsyiVPkhj5UHeifbS8uDANB9A+jEQLJ7rEgP+tsHSwtRbLmABAGaKlgk/B5xgE0aLNn6XjW8FaNZyr7LI0zGT81AeZM1++Zc3s0qBUKjaCrpEIRwHOnXXDGPfWNplGbEPrFh7C9/Sd+zAI4wKMuceu2g+J0jhMTv71wc4xo9zF5zbL2Xfbqh1NvK/t4oEIvmPeqdNag1lMolYYt+bteiYu6+xHd3o0ov4DDqy8oZYigq8VGWxUYGS2RIZqI+WpTXb6v0zCU05JsyzzjoTFds0APxxn+hXWwf0Qw=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F19E1D1F4528744AB25ED6B07A3D12C9@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: ugto.mx
X-MS-Exchange-CrossTenant-Network-Message-Id: 31297b85-fb13-4246-a837-08d80c5ad8dd
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jun 2020 09:36:59.6113
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 132b9871-e025-4ead-a34d-7bd5e7a383b4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sHhRW/cdrphl8od0pp0KBgB3ffe4NoMTs3FRBOugk/ScJyZCR3U4h+ltE5Z2fNoo
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR02MB5285
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Qml0Y29pbiBpcyB0aGUgZnV0dXJlIGFuZCBJIGNhbiBzaG93IHlvdSBob3cgeW91IGNhbiBlYXJu
ICQgMzAwMCBpbiA3MiBob3VycyBieSBpbnZlc3RpbmcgaW4gYml0Y29pbi4gRG8geW91IGhhdmUg
YSBCaXRjb2luIHdhbGxldCBvciBUZWxlZ3JhbSBhY2NvdW50PyBhbmQgYXJlIHlvdSBpbnRlcmVz
dGVkIGluIG1ha2luZyBlYXN5IG1vbmV5Pw0KDQpGb2xsb3cgdGhlIGxpbmsgdG8gcmVxdWVzdCBp
bmZvcm1hdGlvbiBodHRwczovL3QubWUvam9pbmNoYXQvQUFBQUFGQlpkY0U5RzJRV3FYb1dldw0K
DQrwn5GH8J+Rh/CfkYcNCldoYXRzQXBwIG51bWJlcg0KaHR0cHM6Ly93YS5tZS80NDc1MzcxNDcw
NTENCg0KKzQ0NzUzNzE0NzA1MQ0KRW1haWw6ICBtaWNoYWVsN2dpbGJlcnRAZ21haWwuY29tDQog
DQoNCg==
