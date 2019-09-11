Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51CC5B04CC
	for <lists+stable@lfdr.de>; Wed, 11 Sep 2019 22:19:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729075AbfIKUTM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Sep 2019 16:19:12 -0400
Received: from mail-bgr052101133070.outbound.protection.outlook.com ([52.101.133.70]:2883
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729054AbfIKUTM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Sep 2019 16:19:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZYF86XU3N5gPvGIFJb8/EPT3KDU+EwX+osS5X+CAc0fRgnjI5qLpiHXSV9BtaO/AMHBnnSAOXy3ws/7F+pXFahJFvho+cDGPffKqxDQnUr5t8HMbpLSCWrQ6HebRkvkrj/hs+MKgf9CmsZk5bH3Tf7Bcpz8ErVkcqJp83bRS+XIHHhbYEBPQMH7kk9u055X2a+X/nFwkgQ7aV3cLt1FFk5la0mC6nOvfosJAYYp093GwJNMWMV/Q4yjAVXIL+UvRQREpT/6TUpyS/hMItJJpT2HrpiZbs9GI0ihkap0ICR+JKMFcVCdEXVfFzBP2+hdTZbAslx0pSp1R3Ljsmdv9Vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kZ+Yq4cYhnzJ+TIUdW3/PGmGSfUPsVhWRRzeaprLeN4=;
 b=A7LEo9Ey1ZkvNAFhVNqBN79GZR2IJJhYEH1jTO7ynOsgeshJBnRzs2HuvFzL6gtb/baR1sv6UcgKzF9dPBGWbZ9sfydLsjzvqML6xEQNJ/AYbQwxYuz4cw151pr0nb2US/C5dHIOFZXKTEpKlVqIuTQVFIx/VRenFXkvrnPM0heyo04nCbDk73n7JPxJw++1dPydfRrZ4Y8n/g5jiUjVvNwLojSB/uX0n2P7sqA5pYD4/rfFrfEyoo/ffO3XVGS+ryI/jmhwPMwYoDV9Z8FkoJl6H99rbAvZy+hUzui0dEDkbxRrke5MT6+dzY6s5TdZLHBKNK3RVc34ydLO6Al+9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sun.ac.za; dmarc=pass action=none header.from=sun.ac.za;
 dkim=pass header.d=sun.ac.za; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sun.ac.za;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kZ+Yq4cYhnzJ+TIUdW3/PGmGSfUPsVhWRRzeaprLeN4=;
 b=nPK598O5+wC9ozkQIp9+jqYFINUAPDy09SipDPrRgUCml1/+Bucax3Eg2TbYxq752wfx/CV/cOJTOJI9GoTmfcQAnRBpwmlKDfnM/uIaa6a11bMhyfAivQ5iT1SgCYcpe2g2+h0SEtdvydof6ILMhV+20CR9pGt5M7hUXczcCpQ=
Received: from DB6PR0701MB2376.eurprd07.prod.outlook.com (10.168.72.146) by
 DB6PR0701MB2215.eurprd07.prod.outlook.com (10.168.58.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2263.10; Wed, 11 Sep 2019 20:19:08 +0000
Received: from DB6PR0701MB2376.eurprd07.prod.outlook.com
 ([fe80::e4e5:ea63:2e11:9d08]) by DB6PR0701MB2376.eurprd07.prod.outlook.com
 ([fe80::e4e5:ea63:2e11:9d08%12]) with mapi id 15.20.2263.015; Wed, 11 Sep
 2019 20:19:08 +0000
From:   "Nell, Mario, Dr [mdn@sun.ac.za]" <mdn@sun.ac.za>
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Product Order
Thread-Topic: Product Order
Thread-Index: AQHVaNzLCgZKLPWuN0mVjOcXaDADVA==
Date:   Wed, 11 Sep 2019 20:09:18 +0000
Message-ID: <DB6PR0701MB2376F5DA5334267391642975ECB10@DB6PR0701MB2376.eurprd07.prod.outlook.com>
Reply-To: "chengjuan1986@outlook.com" <chengjuan1986@outlook.com>
Accept-Language: en-ZA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [105.112.112.78]
x-clientproxiedby: LO2P265CA0056.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:60::20) To DB6PR0701MB2376.eurprd07.prod.outlook.com
 (2603:10a6:4:5b::18)
authentication-results: spf=none (sender IP is ) smtp.mailfrom=mdn@sun.ac.za; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 975ea9ff-08dd-482a-fb56-08d736f3ed81
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7167020)(7193020);SRVR:DB6PR0701MB2215;
x-ms-traffictypediagnostic: DB6PR0701MB2215:
x-microsoft-antispam-prvs: <DB6PR0701MB2215EFD6C9D12ECE151737EFECB10@DB6PR0701MB2215.eurprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3276;
x-forefront-prvs: 0157DEB61B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(39860400002)(376002)(346002)(136003)(189003)(199004)(2906002)(66806009)(186003)(1730700003)(221733001)(81166006)(81156014)(8676002)(8936002)(66946007)(256004)(66446008)(64756008)(66556008)(66476007)(8796002)(99286004)(7696005)(52116002)(5660300002)(6116002)(3846002)(5003540100004)(52536014)(86362001)(66066001)(74316002)(7736002)(305945005)(6666004)(33656002)(9686003)(6306002)(55016002)(486006)(6436002)(5640700003)(62860400002)(6916009)(6506007)(53936002)(55236004)(102836004)(386003)(26005)(14454004)(476003)(43066004)(2501003)(36542004)(786003)(316002)(4744005)(478600001)(7116003)(2351001)(25786009)(3480700005)(71200400001)(71190400001)(2860700004)(19580200005);DIR:OUT;SFP:1501;SCL:1;SRVR:DB6PR0701MB2215;H:DB6PR0701MB2376.eurprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: sun.ac.za does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: rFNhDuXYxX7qy1wRV/IUHwUYSZn9N4sB+wdykMfxGV2d0FyqeELpWAdQE2cIqNjIb2NyOJfK04d8cPV/uRG2dYRAKUOS3eGcjYhQW0K73IhzJEifGyHKda0kiH4fgOnucs8NOJiZnq9CSyxB6almRq0kDKMDCqb533Me/lckVuq5tVIUYe/on9Erd6RvCPmSN9ZscXMFOW1EkJx5eL6XXXAy5SVDXp2u2VHzF2Udj1F0btYxpXFZ1pjwdarCL9iJspP+mWiVJGVHoeH9cOvwvmgM2fL4dFaY1l+GWSgbIlHn+FradAFw8yc637v+ZmC65cXgxj2qvDdfuQ3N4JOuy4X9BGaGvIPQIN21qImX7Vp2DV7gtiKzi3gI1Z66c6AE61nDaNBYzry1MqZ6Kt7oyvKAuu9plv37gsYL/8kXhZE=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <BCDB934EB952F1468182D5AA15E44EB4@eurprd07.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: sun.ac.za
X-MS-Exchange-CrossTenant-Network-Message-Id: 975ea9ff-08dd-482a-fb56-08d736f3ed81
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Sep 2019 20:09:18.6785
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a6fa3b03-0a3c-4258-8433-a120dffcd348
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UVE3pkrN4A35TLp9rUDn8xFJ+7R3bdtN0nnpd8WjvxLji1Cfqz2ZI+KSYjhGEKUH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0701MB2215
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Sir/Madam,

We are interested in purchasing your products.

Please send your catalog so we can make a quick purchase.

Hope to hear from you soon.

Best regards,
Mrs. Juan Cheng | Sales manager
SAH INDUSTRY&TRADE CO.,LTD
No.4023, Wuhe Street, Bantian, Longgang District,
Shenzhen, 518129, China
[http://cdn.sun.ac.za/100/ProductionFooter.jpg]<http://www.sun.ac.za/englis=
h/about-us/strategic-documents>

The integrity and confidentiality of this email are governed by these terms=
. Disclaimer<http://www.sun.ac.za/emaildisclaimer>
Die integriteit en vertroulikheid van hierdie e-pos word deur die volgende =
bepalings bere=EBl. Vrywaringsklousule<http://www.sun.ac.za/emaildisclaimer=
>
