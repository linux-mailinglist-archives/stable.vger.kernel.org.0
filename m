Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7359C1F3737
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 11:46:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbgFIJqQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 05:46:16 -0400
Received: from mail-mw2nam10on2124.outbound.protection.outlook.com ([40.107.94.124]:53502
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725950AbgFIJqQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Jun 2020 05:46:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KgmntQevc3R4XRHMzjH1AophR3t0QPq3P+fIg1Rjmg7cR5+Yh3ykbzZvucGHM1bHHcmP110sOiiKnBdfJyGI9QMqIjhXV6GRU4MwK1L0FhROkMGDhDjdDLNWzmCYWz1GxWwYwa0UxEKGac5JP/QE76qPUFSvVV+Yv1HKsk3y4jVhzRwqO+pDinO7XuqhiQICmVAgwwxHEqGctztyKTXMAbADHIMR6CWvkgMMMT4resB5dTk6hLcJDh8675wM/AY4VLz2P8RdVkbMZj86Xt5SCaoXm200Cp87RjpBLR4/vyn5zgi9LjU1DQI3erfkIkFGnVTUT2CEZQ/VnGQj6LeOLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T2TYovFzMVxBFbyqFenzqp+W1mqLc0/lH8MlbXqcd8U=;
 b=EMmmrJOd9b5vbUibhlIqqAKyJfP40SZ41fHvgPfY3+0N7hXjh6qILHTaDlnnKkeaHP5OQDZd4HcGUnAN5Jg8vAdobp2JSnOpDMkqU3RP2+gZqGj+Rgmbzsbbwcv5EgVojDbnhZ+jqZD1HtqegEp5pYvNTSLbzWFD3nZElnRXAoD7sBCz4XvplBxRiPDkXMLyoHWA79Mp1/MTSTfWm8cOGF0dKvEiQLykxxPKni8UQGCPB4mrv4J8kTo+e/cQZKMGwL+Vh4HQNH4qhui3IAPAoZeHtSxP6rXBaWllZHaoYXAfMMA3pKrVP4+zHHu+Pz7tg6kKKmjXYK2tcfLmmLZ9zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ugto.mx; dmarc=pass action=none header.from=ugto.mx; dkim=pass
 header.d=ugto.mx; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ugto.mx; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T2TYovFzMVxBFbyqFenzqp+W1mqLc0/lH8MlbXqcd8U=;
 b=oywBDD2MBT64tle83BIdVkaGsGD0E3DZXP0B3pajaVLBs0UJWZQ1eTIUgC9vvmi4p/FkRHxOZ0RAJwrE8GSju4UzeF2GH0u/gKZAUkjgvWUFjP0DjO2IQ56s1ee3vRuCAkglFbiq4ntXRhVSaJ4pJX/d4NufqMQOpFVVudB/RcI=
Received: from BYAPR02MB5366.namprd02.prod.outlook.com (2603:10b6:a03:65::30)
 by BYAPR02MB5528.namprd02.prod.outlook.com (2603:10b6:a03:9b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.18; Tue, 9 Jun
 2020 09:46:13 +0000
Received: from BYAPR02MB5366.namprd02.prod.outlook.com
 ([fe80::55a0:ac58:81a5:2161]) by BYAPR02MB5366.namprd02.prod.outlook.com
 ([fe80::55a0:ac58:81a5:2161%4]) with mapi id 15.20.3066.023; Tue, 9 Jun 2020
 09:46:13 +0000
From:   Orlando Reyes Herrera <o.reyes@ugto.mx>
To:     Orlando Reyes Herrera <o.reyes@ugto.mx>
Subject: Re: Hello
Thread-Topic: Hello
Thread-Index: AQHWPj9V/Tj9GOHQq0aqtT+MNbZ1KKjPjRaAgAABaICAAAJ8gA==
Date:   Tue, 9 Jun 2020 09:36:15 +0000
Message-ID: <F98BAEBA-1029-45AC-B403-A36BD2A018C4@ugto.mx>
References: <A845BC24-A037-4E10-9DBF-A0498E9436E6@ugto.mx>
 <0BC2C1BD-1E04-4ED4-9DAD-E35E6C4682B5@ugto.mx>
 <229F2B24-C4DD-4FC3-8916-CB9839407659@ugto.mx>
In-Reply-To: <229F2B24-C4DD-4FC3-8916-CB9839407659@ugto.mx>
Accept-Language: es-MX, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: ugto.mx; dkim=none (message not signed)
 header.d=none;ugto.mx; dmarc=none action=none header.from=ugto.mx;
x-originating-ip: [129.205.113.56]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 34dd3077-b5bd-4d50-6e0c-08d80c59f2ce
x-ms-traffictypediagnostic: BYAPR02MB5528:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR02MB5528DF3C4FDB7E4D644342A2F1820@BYAPR02MB5528.namprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1169;
x-ms-exchange-antispam-scannedurls: 17573975298564142132;5959347087216061301
x-forefront-prvs: 042957ACD7
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IZ/tw0XuuY9hI6s0zT0sYgb5AAIXF7tguQRCoDZuMASWm/U0vEKSJDRbSFLDB8CITBQhn+Bf7YtshUa12oPyRCOjfNKlyP0HGv1iYTUk9NUDG4AHCsZuc7EDAsim7aMxI12FI+Y8wR0wEX8SXtS+6G52YM/QxSkuzvf/JZMBXQc3sr/xpgudcygoitPq7WLTKgp4bLE8JEvO4giZONSIYHAam4NwIY05s/wrE3N8GYOq4kVnASKyiqZ1mpCRfOQmFt+QVR6zJyIpWUnKaXpQzSiezMskGtNJpFXZHr8FI2VXfJm+t/CFc2CyX4vAEFgyezHZcMT1xY4paBo7DmiCalHeE++EEV848FGeivutZscUctnM1+ReS3vocMR9dkOUkU+67JpYlZQjldsn3Kf05ItIgosI3da189gcHEeFhCcLmPsBJPeb5HS5x9K+BDPt
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR02MB5366.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(366004)(396003)(376002)(136003)(39860400002)(346002)(66446008)(8936002)(76116006)(966005)(66476007)(7116003)(2616005)(786003)(62860400002)(91956017)(66946007)(66556008)(7416002)(6512007)(316002)(6486002)(64756008)(37006003)(33656002)(3480700007)(5660300002)(6506007)(36756003)(66574014)(4744005)(6200100001)(86362001)(83380400001)(186003)(71200400001)(6862004)(26005)(478600001)(2906002)(8676002)(8484002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: lwJRdq4+0JQ85ZjuomNaX2v/xtCsqTNhC4teTEJzfkeW/UK0vLkYSINNU92IqPr7BV4hmm4UO3q0bqlFPqfDGqb6m1va3xGmSuCBQVM2Wjybx4pEJ3X6ORR6LzGW40gPLKAP8hIm3cBg8oe/v20F5NmOfBdvmi6axCu5fR3IUj95+APfZjBKHh0c/0WfykIHQCBY/avpJhhj1Lj2dW/UynDu0s5tTi30nK1nhuTeS4xN/rq1sNfJVbpv/WR33lekJKh4OrfSS2WAjs7VZQAw/f7TZ0VGXd13PW8V9XRcqYjDr6THdby3orgwRKM+okiABm1HcIZR2MwscFpm9SfV7owmfCjioaAk9yp3ivIr3ldEBNIxoe/R1Y4q1lXnuw9wsCA9tnnREhpBTMdAWSxvqioIYgg1yKJPghOfjCJQKVAA6r8W1F3+jynapwdyHsnbJj9qPlwHpdIdPRHFLawbGtkPGU4s7uC4e0mSib8Jo1U=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E121F62262AB19499089B57A6996B6E9@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: ugto.mx
X-MS-Exchange-CrossTenant-Network-Message-Id: 34dd3077-b5bd-4d50-6e0c-08d80c59f2ce
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jun 2020 09:36:15.6496
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 132b9871-e025-4ead-a34d-7bd5e7a383b4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gnt04qyQNLYgX0Bb3RRC45DePi5Lb/FT1gsvHOilh2y6QbJNLSuZVlcEC8h3CJQn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR02MB5528
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Qml0Y29pbiBpcyB0aGUgZnV0dXJlIGFuZCBJIGNhbiBzaG93IHlvdSBob3cgeW91IGNhbiBlYXJu
ICQgMzAwMCBpbiA3MiBob3VycyBieSBpbnZlc3RpbmcgaW4gYml0Y29pbi4gRG8geW91IGhhdmUg
YSBCaXRjb2luIHdhbGxldCBvciBUZWxlZ3JhbSBhY2NvdW50PyBhbmQgYXJlIHlvdSBpbnRlcmVz
dGVkIGluIG1ha2luZyBlYXN5IG1vbmV5Pw0KDQpGb2xsb3cgdGhlIGxpbmsgdG8gcmVxdWVzdCBp
bmZvcm1hdGlvbiBodHRwczovL3QubWUvam9pbmNoYXQvQUFBQUFGQlpkY0U5RzJRV3FYb1dldw0K
DQogICAgICAgIPCfkYfwn5GH8J+Rhw0KV2hhdHNBcHAgbnVtYmVyDQpodHRwczovL3dhLm1lLzQ0
NzUzNzE0NzA1MQ0KDQorNDQ3NTM3MTQ3MDUxDQpFbWFpbDogIG1pY2hhZWw3Z2lsYmVydEBnbWFp
bC5jb20NCg0KDQoNCg0K
