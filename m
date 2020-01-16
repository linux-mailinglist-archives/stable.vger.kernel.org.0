Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DA3213D525
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 08:41:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726160AbgAPHlc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 02:41:32 -0500
Received: from mail-ma1ind01hn2047.outbound.protection.outlook.com ([52.103.200.47]:9872
        "EHLO IND01-MA1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726315AbgAPHlc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 02:41:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mTRB8gPZxIP74EHS5WEKQPpsOnJPp5CNdFxaZmbUN0yBJpfeOdedEE76DIzfB3Ih1HRNDsz39AwCStKtvxpJZpYBJQ7BCCktX1GD/IaER6ZhiiHjLUJgk0u7j5ncMDADK8rj9mDxcmkVtZd50V7NlbCT/OGfOvn9kwUxVgzII+lLYue/5F2rgtkgO2NvZIvtWj6W6HQksVuCDjyIL7SajxOpE0mwuEiZ0MrMW/dWwv5ER//dEwK+7Sv7xhEe9lh0WSGLJxBcxq3/3KBVOOmf7uCDVURPc5ZA5KTzCpx3MfJYlDgFlvkpnAScVuQTVq6qda5EEpZci/Sw8/s2zXgNkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/ZZJXMYT2pzyIeaRekzni0gCjWiXTNix98tEUdWrNhM=;
 b=gdqfZ555+VZgRuoxQfp4L2MuCTCspB1mpG1KcoKInPtrJbEvMikdzlBOauYvjOyIdsTniOA2YgyzETz65oCfZ5BTVT93zb+l/7ukWgZ6HcNHndq1gsI/yYD8UmIqtJINuy6EZv4wslEbZhGnclNztWB6TexNQen2JtfXTXlWJqqZOXYWz8INT9PBTp0wx4eLc7BwGtDrjatO/AquXVvQTIbBzn0rnna4tUFZG1EVxLvL1gTK/WOgvpvJ7evz2Q+Gl1I3fQ20oLyAT4cVEVKl5oVihwy29A4PyihUkaPq30/kkCXbnlDFJSHQUVTxGUTPcSeQw26IWY75KCxN1U8g1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oceanedigitaldata.com; dmarc=pass action=none
 header.from=oceanedigitaldata.com; dkim=pass header.d=oceanedigitaldata.com;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=NETORGFT5553580.onmicrosoft.com;
 s=selector1-NETORGFT5553580-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/ZZJXMYT2pzyIeaRekzni0gCjWiXTNix98tEUdWrNhM=;
 b=ElXF8cw71IyJprIE8SoT0gde8Aotopiu88gnzxEgbeKQffPM9pkCefDc8LeHa7WQQZasi8TWL4JDDnb+iT5Lp/YDNPg5CFKGQoSoKb3DN3wZzCnK2bB6o/qJAIH2ZO6XTsSZ3Y3ULKtlr1xMH9UZdfbXh1QMZfcM934xcYcwP04=
Received: from BM1PR01MB3362.INDPRD01.PROD.OUTLOOK.COM (52.133.239.87) by
 BM1PR01MB2994.INDPRD01.PROD.OUTLOOK.COM (20.178.174.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.18; Thu, 16 Jan 2020 07:41:28 +0000
Received: from BM1PR01MB3362.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::7815:ea:4d7e:7f52]) by BM1PR01MB3362.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::7815:ea:4d7e:7f52%7]) with mapi id 15.20.2644.015; Thu, 16 Jan 2020
 07:41:28 +0000
Received: from DESKTOPMPN5UI4 (106.51.17.50) by MA1PR01CA0080.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.19 via Frontend Transport; Thu, 16 Jan 2020 07:41:28 +0000
From:   Brenda Lane <brenda.lane@oceanedigitaldata.com>
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Attendees List 
Thread-Topic: Attendees List 
Thread-Index: AdXMQFt/ZxdkaN0iS3qB4rfN0/FKJg==
Importance: high
X-Priority: 1
Date:   Thu, 16 Jan 2020 07:41:28 +0000
Message-ID: <!&!AAAAAAAAAAAYAAAAAAAAAMeItoodLbBEhAG+Fnluak7CgAAAEAAAAGaqL1EWXkRIjdYqIhcOR/ABAAAAAA==@oceanedigitaldata.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MA1PR01CA0080.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00::20)
 To BM1PR01MB3362.INDPRD01.PROD.OUTLOOK.COM (2603:1096:b00:76::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=brenda.lane@oceanedigitaldata.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: Microsoft Outlook 15.0
x-originating-ip: [106.51.17.50]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2d07f2d5-2c84-4934-e87d-08d79a577f17
x-ms-traffictypediagnostic: BM1PR01MB2994:
x-microsoft-antispam-prvs: <BM1PR01MB299495441B351245518E94B8EA360@BM1PR01MB2994.INDPRD01.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 02843AA9E0
x-forefront-antispam-report: SFV:SPM;SFS:(10019020)(366004)(39840400004)(376002)(136003)(396003)(346002)(199004)(189003)(36756003)(4744005)(66476007)(186003)(2616005)(16526019)(4743002)(66556008)(44832011)(8936002)(66446008)(64756008)(71200400001)(3480700007)(956004)(66946007)(8676002)(81166006)(81156014)(86362001)(6916009)(26005)(508600001)(7116003)(6486002)(316002)(1006002)(6496006)(52116002)(55236004)(2906002)(5660300002)(32030200002);DIR:OUT;SFP:1501;SCL:5;SRVR:BM1PR01MB2994;H:BM1PR01MB3362.INDPRD01.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: oceanedigitaldata.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1R58OJbYsHmwPxd1c4KkFbULqBRi8w3pOC/XkCcpaYZLTotQqVKkYuHAfrmO54ubeQj4kwrDh03+gprsTQ+5xSlxf8h+F6/4wf1OHCpHSeX2Q45mjrcm2Xqqo40T7ciI/UpxT5D6s/jxGAOvusnnPW7haD5pZwjTTS8RV3Lm+oNNgyIfJLF0SHvbq03mALG2Q5tTxkgJMdqQCcK2Q/n5nUxKZr2QdwTdJTv2I/6IOEw3fe1wDPsTFa3iPJitWhQvEuU4vBYmKKZOH8tPNJ0Y5lbgIW0KFNCHBppX4nwY/4lSZCpIZS3C1nvJnAAVMoryHSgWc5KA3mr9BdUFKR0Aaaxg/moKZbCaOA5jW+2LLRdMO1XLdbIEBLkvF+Ace8eNAbuJyaz87zLhv4C6cLxy8qCXrl6lATst1BH00U30XOT3mD7UdJ+U/q3XQqYVMppyVHyVXkzhCfSpTIW4Yd73cf/lSZ/2zyoiWxMlprKH6WLNPmxpHRiIaabTV9Kw6WWpeSpjVh94gKzWY7csac4xibXBqaYc8jjs60UaolvigCMXw8rV0dSvZqW08I3cgs9wD9bciWL8YEmf71tIHxB75qcRoy+vk6UKvtJFmlIzMCDz9hb6Bz02dTK67ZFXbQ0wswvQTh1+nLAqh/+skPzkddTa4AYpF11QjaXz+d6eCbso60KnhNfJ+KHGuRLsQHOedsOW78bXcE5mfXtJ/C0UC761RRmfnGkBOWJFQhVgkGmNoHEIwM0DmHtLw+jMcjV6SehkDq18rltPm3oq12/Pxg==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B93A0DC02B2BFA47BF36779A3A843AEE@INDPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oceanedigitaldata.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d07f2d5-2c84-4934-e87d-08d79a577f17
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jan 2020 07:41:28.2719
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4d88f05e-781c-4247-92e4-bd9439b8070f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9mTKPXSBStoR7SGIB9/DF+qjwOfSKiK2bw29bjXob6vbPtiDDdcf+vvcCXE6uBLDyTHphQnnGsY2WXKfy+d7HwdkTK8cPN5W6XGP265JyTceYbOt5KGfiS4rmMHaxdSi
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BM1PR01MB2994
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,
 =09
Blissful morning.

I just wanted to check if you are interests in Attendee Company list of
Embedded World 2020 (International Trade Show for Electronic Systems,
Embedded Technology, Embedded Systems, E-mobility and Distributed
Intelligence) to reach wide range client/industry leaders to promote you
product/services at global market.

Venue: Nuremberg, Germany
Information Provided: - Company name, URL, Contact name, Job title, Busines=
s
contact, fax number, physical address, Industry, Company size, Email addres=
s
etc..!

Please confirm and feel free to reach me out for any queries. Have a great
day.

Awaiting for your reply

Best Regards,
Brenda Lane.
Tradeshow Specialist

If you do not wish to hear from us again, please respond back with "Leave
Out" and we will honour your request.

