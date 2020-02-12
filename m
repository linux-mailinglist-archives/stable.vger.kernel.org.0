Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 785F115AF66
	for <lists+stable@lfdr.de>; Wed, 12 Feb 2020 19:04:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728872AbgBLSEd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Feb 2020 13:04:33 -0500
Received: from mail-eopbgr1390072.outbound.protection.outlook.com ([40.107.139.72]:39424
        "EHLO IND01-BO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727054AbgBLSEd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 Feb 2020 13:04:33 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bmTL0+HIA2ulfEoolg9Rpqx8UL+eZ2CmSknDXFqULxwHmKALIVbJKawbaPfU5mF0TfWD4YzOVeDVZVGCu4Rkue8bIm0BUUTiEhmwOgk6g9ujCtFpuxkWu0Na9JYCJpvsiTHoEbFps2NinU8v5IWp0B4S2zGReGfVhf2mu31P5mFOzL9ak1t33KnNBC+NZ8rCCWVuyScMcOlqHSdS1TtTBdvKsDvhNJv20/xccmtUah9bBhPujKClUfJYtw3dyUMh5JTLXuXZOwGYk4qdZPw6dYlmiJ34QQHljByg+z8dNXXr8C4db2jhiCtp/Yz1azJU3SFqownXII9Wsb2STvdmmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HyAnrDBqx/v6JoR/Xs8Wvxt1Dn9NwP1miAM0oGLj6ys=;
 b=dJLFQFICqUbKdv8zJQQ0LG5XUjC7ZdbF6QYVqledQnPf0b1sbRqVJEdAZ2TY4kELTSW1SndykxBnXIT8Rjyenp/Sa0FFxP8RMyxdpgHPS25P0Bjxz2UcjLkiB3KJ5bJ3/RvDXbOB5q0abu7WQMooaz0L+PkzFofssqCvVNMQdi1/HPDadkXxgNBvTYlNfeq8zZuZ/oqjscmfA3sooPDFeNC8BGB4iycwpwVLGtOr6gPRO6Y5cdIDZblznlnABC9sxMwNkhCJbntdeL6FnnLaYG6L6R8kpx0ntpibH4pwlUhaN88CtUwHI8sguqF9esrY2guTc3c4c5CHImT2E/Fcmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=worlddigitalprodata.com; dmarc=pass action=none
 header.from=worlddigitalprodata.com; dkim=pass
 header.d=worlddigitalprodata.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=NETORGFT5578867.onmicrosoft.com;
 s=selector1-NETORGFT5578867-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HyAnrDBqx/v6JoR/Xs8Wvxt1Dn9NwP1miAM0oGLj6ys=;
 b=bYdXB0gxfHwspLykbq+SQDt9E5WYWXaoREBno4Xeyti+Ec2ut1L1LbXpFPSarnHTZqv+yHczdBSUmivpbz9rg1vvUbo7YEPpvMzAsSmZ7IV6qKhlucw2uEmd0Z93kkIMDjCW6O3W/ek5JF5MOUaM/fSkY0Fnp9bRWe3hbl4RizQ=
Received: from MA1PR01MB3836.INDPRD01.PROD.OUTLOOK.COM (10.255.215.19) by
 MA1PR01MB2332.INDPRD01.PROD.OUTLOOK.COM (52.134.149.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2707.21; Wed, 12 Feb 2020 18:04:29 +0000
Received: from MA1PR01MB3836.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::24b5:96f9:da47:f395]) by MA1PR01MB3836.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::24b5:96f9:da47:f395%3]) with mapi id 15.20.2707.030; Wed, 12 Feb 2020
 18:04:29 +0000
Received: from admin132PC (106.51.30.28) by MAXPR01CA0105.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:5d::23) with Microsoft SMTP Server (version=TLS1_0, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.20.2707.21 via Frontend Transport; Wed, 12 Feb 2020 18:04:29 +0000
From:   Ara Gates <ara.gates@worlddigitalprodata.com>
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: EVENT IN SPAIN MWC 2020
Thread-Topic: EVENT IN SPAIN MWC 2020
Thread-Index: AdXhzt3YmRm1zM6NQ2eLYnbe2b3MUw==
Importance: high
X-Priority: 1
Sensitivity: private
Date:   Wed, 12 Feb 2020 18:04:29 +0000
Message-ID: <!&!AAAAAAAAAAAYAAAAAAAAAAwcKHcddElNkhudO5gi/sHCgAAAEAAAAMq+DM/RZrRFo1+Fa4JW+AYBAAAAAA==@worlddigitalprodata.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MAXPR01CA0105.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:5d::23) To MA1PR01MB3836.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:82::19)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ara.gates@worlddigitalprodata.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: Microsoft Outlook 15.0
x-originating-ip: [106.51.30.28]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9eb424bc-8935-4f31-1de7-08d7afe60163
x-ms-traffictypediagnostic: MA1PR01MB2332:
x-microsoft-antispam-prvs: <MA1PR01MB2332EC3311E137C360738E01E81B0@MA1PR01MB2332.INDPRD01.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0311124FA9
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(366004)(136003)(376002)(396003)(39850400004)(189003)(199004)(66476007)(66946007)(956004)(316002)(2616005)(1006002)(6486002)(86362001)(6916009)(5660300002)(186003)(66556008)(55236004)(26005)(36756003)(16526019)(44832011)(64756008)(66446008)(81166006)(81156014)(8936002)(8676002)(71200400001)(52116002)(2906002)(6496006)(508600001)(32040200004)(130950200001);DIR:OUT;SFP:1101;SCL:1;SRVR:MA1PR01MB2332;H:MA1PR01MB3836.INDPRD01.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: worlddigitalprodata.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Khvxomm6vjauaVj/HmElDw+zEx751x4vaAf+zW1921zwDjic0Wr1MgOq1u/oO3Ol4GHYjSET3sT3t6foa0g5k/1ihuS7LbBV2/BH4IqLiNq9n1SvSS6Rckz1s5Zp5kSpxfE5DB7Y6KFUmKqPawWKY9QrrYSMN+hmLm8//NQsR2q9/8b5yFGMKTJY+04zRJeItx7NbE/1MU3uZRYWi9U/7HNRyfqyww3G2piH0gBo+G2G5+JjRUwprXSzYgjVg1ewvVovAom4SBsCWmCSBQeGTuwaUqVa2oZPkDJh+ctfc+8Dy2/hG7uH2AObVvTlS5CvCr/ErjM3h2OQoWcwVmD317K6Ui7xKmiKB98zYBR9OhA5uYSQwIAoWaTDqRSQfj13nhFzauRgZN5+MIyFtKRwdKeMUrABIkFWhKZkFNdjmovDCTbenXwdcMPyMFefJkdgO07XXukubW2OdiVa/4aSqx5GTc+F6pq+ZrcOAn6VayssPviUKkNVf3rJLMSkXTDvbb9+Cm74dKaUohlkdtbFpzxSeITg++FMR6tU+z1iUCg=
x-ms-exchange-antispam-messagedata: 6fUqAxe+4oAc+It4v22HcXT0HQwNkXwn+UNda/7ALhw7YPNqbO9bC3YKxMloCs338pHqu4UlFH6aHxeGZeCNHG1B95Rn0YJv/WlCrkFaVKNBi8A0RJ5QP4E5OwXbRXxrX6Yg2DhFsl54m1OPeHG1XQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A40AD127FEC5AA44A23FFC784D6B06A4@INDPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: worlddigitalprodata.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9eb424bc-8935-4f31-1de7-08d7afe60163
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Feb 2020 18:04:29.8125
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 65343f07-34ec-4516-bb20-6348adb7960c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AJTOvh5ynGard1qSu7/eHoQyxeh2ErTnNARj2LatgNfWIrP9eG/HdDB8FaJW9/TS4VxSIHYb18PSFqh8TdLgbhReKZsdIMPiWi6CmttUv8Zew8iLBYo3rQUYgh5dqQl8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MA1PR01MB2332
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

It is a pleasure to be in touch with you.

We came across that you are exhibiting at MWC 2020 (International Trade Sho=
w
for Technology, Communication Technology, Telecommunication, Communication,
Mobile Communication, Mobility, Mobile Phones and Gsm) and was curious to
know if you would be interested in purchasing the attendee list for your
business needs.

Venue: Barcelona, Spain

We have recently updated records of past/current Attendee Companies who are
participating in this event.=20

Information provided: company name, url, contact name, job title, business
contact, fax number, physical address, company size, email address etc..!
Our list is the best source for awareness and can be used for booth invites=
-
product launch - brand awareness - increase in revenue etc..!=20
Look forward to work with you soon!

Kindly confirm and let me know if I can share Proposal for your approval.
Also, if there is any interest in buying B2B data for your Campaigns, we ca=
n
drive in records according to your request.

Kind Regards,=20
Ara Gates
B2B Tradeshow Specialist
=09
If you don't want to hear again the mail regard MWC 2020 kindly replay back
to us for "Opt-Out"

