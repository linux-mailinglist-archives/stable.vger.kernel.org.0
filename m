Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED5E019AEC6
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 17:33:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732904AbgDAPds (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 11:33:48 -0400
Received: from alln-iport-6.cisco.com ([173.37.142.93]:30919 "EHLO
        alln-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732799AbgDAPdr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Apr 2020 11:33:47 -0400
X-Greylist: delayed 427 seconds by postgrey-1.27 at vger.kernel.org; Wed, 01 Apr 2020 11:33:46 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=1191; q=dns/txt; s=iport;
  t=1585755226; x=1586964826;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=lbJUtd8XxhKLIc40vyRkmno6fI4bufQaXVHmFHgOyeo=;
  b=grAscPHyVEAOhCEDimOwB6HcylBiSe05ESN5nO3m6EkQvlvPiFjoe+te
   L9gsJJaEIftJdXEN65l7xy2iZfFVqVaAgFs0/LaFzNBIYrSfJKliOqR72
   oNJXjf0KTYqajvRERZ537DrvHA1adf2hHSpguZdgBBCeMGZ8MjboHHha+
   Q=;
IronPort-PHdr: =?us-ascii?q?9a23=3Ayc5OgB90dPyBF/9uRHGN82YQeigqvan1NQcJ65?=
 =?us-ascii?q?0hzqhDabmn44+8ZR7E/fs4iljPUM2b8P9Ch+fM+4HYEW0bqdfk0jgZdYBUER?=
 =?us-ascii?q?oMiMEYhQslVcKMD0z2KOHjRyc7B89FElRi+iLzPA=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0CkCAAssoRe/4UNJK1mHgELHIFwC4F?=
 =?us-ascii?q?UUAWBRCAECyoKh1UDim6CX48giH2CUgNUCgEBAQwBAS0CBAEBhEQCgjgkNwY?=
 =?us-ascii?q?OAgMBAQsBAQUBAQECAQUEbYVWDIVwAQEBAQIBEigGAQE3AQQLAgEIGB4QFB4?=
 =?us-ascii?q?nBAoEJ4VQAw4gAaNjAoE5iGKCJ4J/AQEFhSMYggwJFIEkjDEagUE/hCU+hE6?=
 =?us-ascii?q?DRIIssQQKgj2XFCkOm2SrNQIEAgQFAg4BAQWBaCOBWHAVgydQGA2OHYNzilV?=
 =?us-ascii?q?0gSmMfAGBDwEB?=
X-IronPort-AV: E=Sophos;i="5.72,332,1580774400"; 
   d="scan'208";a="481790539"
Received: from alln-core-11.cisco.com ([173.36.13.133])
  by alln-iport-6.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 01 Apr 2020 15:26:38 +0000
Received: from XCH-RCD-002.cisco.com (xch-rcd-002.cisco.com [173.37.102.12])
        by alln-core-11.cisco.com (8.15.2/8.15.2) with ESMTPS id 031FQcX5003036
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL);
        Wed, 1 Apr 2020 15:26:38 GMT
Received: from xhs-aln-001.cisco.com (173.37.135.118) by XCH-RCD-002.cisco.com
 (173.37.102.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 1 Apr
 2020 10:26:38 -0500
Received: from xhs-aln-003.cisco.com (173.37.135.120) by xhs-aln-001.cisco.com
 (173.37.135.118) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 1 Apr
 2020 10:26:38 -0500
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (173.37.151.57)
 by xhs-aln-003.cisco.com (173.37.135.120) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Wed, 1 Apr 2020 10:26:38 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S57//8sTMjcWGMSNcHQz7RirW9Kt8bqxBMdqB/ssMTUy2h9F+JcwwA/gnmCOZs9UJ2I6/rTNfZG4ulF0CV+E1I5hJvJ51P3tYJr+ea07JkvYJ2Ho7SozXUv5Fzjmj85NmorM7BB2BkZSaoOyvFtyAKCu5xpMtn37MzpWj8xFa5a9SGbqOUpstNd2qfcJoR2r0WE9OClOrrqc9aZvK5vPihfi6HrE79ht/8Hzu1HltsuKUUaNRNIY2tpDQM774LCVeV7TxEzMG+iEOYXzLH6tYpYojral/AUtKrpD8BqwpL0nYrT7NgVj1TrUxeb5yl3InrTc65EH1kgih2RW9HbvFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lbJUtd8XxhKLIc40vyRkmno6fI4bufQaXVHmFHgOyeo=;
 b=NmGyTTYWZh0bKfSEQ68hAeAXAc4RqIvHb3CDWYhbgy/RNsJkFgxeOfA64D2Ya+tNDqkQNiwzpddL3mC5DiSqKqekE1qqB3sqrpP8078aTQTuJjBcAf49acBi/R8Os1/3Jvjg2zhm5LpNxbBWbiJ/HXkR8Cvxy9m4YKpNaMZbSehxn9nbgpmQ1uDu9EKqDOj0lxzr3Xu7MoHMHgUaj88cpnu0rB7X9mBG4hJ1My+5CynWOp7AAX6RRbDpL8zufF8SGuPMZ5tdsUCtzavPx7ySDokZaNXdT/UmvjlyFp9/QWyx92qQllfLjVHuoDQVbIHq+Q05YghhkQznr1WSnCQWXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lbJUtd8XxhKLIc40vyRkmno6fI4bufQaXVHmFHgOyeo=;
 b=HZv9qYy5kKaJfP81fXz8bHJjijfhDmFrTJlOdGxGMvdOFIriexNY9M3z0dr+bxrNlIMGjak7FLcli3PG7DvFD8P6f9h0+lrB6s6xHC29LRwmrHAfKd6QUQGESvcbfqNnzfsH7y/LV2O9FY8sAV4qlWGnvg8sUmY19VuQkozxq6U=
Received: from BYAPR11MB3205.namprd11.prod.outlook.com (2603:10b6:a03:1e::32)
 by BYAPR11MB2791.namprd11.prod.outlook.com (2603:10b6:a02:c8::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.15; Wed, 1 Apr
 2020 15:26:36 +0000
Received: from BYAPR11MB3205.namprd11.prod.outlook.com
 ([fe80::d015:3039:2595:7222]) by BYAPR11MB3205.namprd11.prod.outlook.com
 ([fe80::d015:3039:2595:7222%7]) with mapi id 15.20.2856.019; Wed, 1 Apr 2020
 15:26:36 +0000
From:   "Daniel Walker (danielwa)" <danielwa@cisco.com>
To:     "Y.b. Lu" <yangbo.lu@nxp.com>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Shyam More (shymore)" <shymore@cisco.com>,
        "xe-linux-external(mailer list)" <xe-linux-external@cisco.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: mmc: sdhci-of-esdhc: fix P2020 errata handling
Thread-Topic: mmc: sdhci-of-esdhc: fix P2020 errata handling
Thread-Index: AQHWCDnupGSTppuslE+SoPns0OKbtg==
Date:   Wed, 1 Apr 2020 15:26:35 +0000
Message-ID: <20200401152635.GA823@zorba>
References: <20200331205007.GZ823@zorba>
 <AM7PR04MB6885CDDD1ECEEAE7111C6201F8C90@AM7PR04MB6885.eurprd04.prod.outlook.com>
In-Reply-To: <AM7PR04MB6885CDDD1ECEEAE7111C6201F8C90@AM7PR04MB6885.eurprd04.prod.outlook.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-Auto-Response-Suppress: DR, OOF, AutoReply
X-MS-TNEF-Correlator: 
user-agent: Mutt/1.9.4 (2018-02-28)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=danielwa@cisco.com; 
x-originating-ip: [128.107.241.167]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b509f46e-9275-4034-d8cd-08d7d65110ea
x-ms-traffictypediagnostic: BYAPR11MB2791:
x-ld-processed: 5ae1af62-9505-4097-a69a-c1553ef7840e,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR11MB27911BE41F749B3DF94EC8BADDC90@BYAPR11MB2791.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 03607C04F0
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3205.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(7916004)(4636009)(39860400002)(136003)(366004)(346002)(396003)(376002)(86362001)(478600001)(6512007)(9686003)(6486002)(1076003)(4326008)(186003)(6916009)(33716001)(2906002)(26005)(81156014)(81166006)(8936002)(8676002)(66946007)(66556008)(64756008)(66446008)(76116006)(316002)(66476007)(54906003)(33656002)(71200400001)(6506007)(5660300002);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: cisco.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kxza+hHL2NWH5buTFAVzIdKVTkwuxH9Km1UdbtP6ew5MIICYyOFCGwLl/uT3N4l35l+8y4/2VNdmjbK+Tpg5p+99t9ulJB1jdSj+wjldsMZ+0dbFAMAkkzvjqp42sLxF59itSJdHPKLaPi+EiVsavdeViMXXkgAD4gqKgpFrhvtn2ZY3uWJkSdfKdiJLEKhEQQehHdUK44FVP5cJzllhB8EI+6LZM1SvCP7sI9tjbSvZnvx5Lcl1sLFs5KuSyitUaGmVFGtlfd6vyx1X2Z6m9sUYQVnFCCjemwnfxqe658PN+cFQVTjKjiZrHxF8xDfJrXrJTRJXwBuo1jOeE54fVFRKb2+b6ywoVlxShIYwJN2lAA0AXFum2U+Y1ByO5yn7Bh/OJ9mHkDCom4GVeo1CgeJPpAI0Kp75H3c/4mZiTfUXkD15g5FPLO4rDrv5MkVV
x-ms-exchange-antispam-messagedata: TS0Fxd9/9XOTMYAPnB5zNqgClEmXmbaFBiqn8dA1Yg+HnwG7tFjaz12pnP2Omelw3EmqWs9KffQRm18olMldkgdkE+88H5Dnu7i6QSieWGe0D25ssOX7Xsy6Z5QjXkVKW6zYAEpnd2sZd8RpNPCBVg==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C8C588052697294AA63248D01589A036@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: b509f46e-9275-4034-d8cd-08d7d65110ea
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Apr 2020 15:26:35.8827
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hPSrHsMSvfoBlScE3ODRcOV7yeuCoG8TeB+t0FOfl4fqakDCDeSLORIq8Fz3pILaAIITBgl9yNRli0hvBl18VQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2791
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.37.102.12, xch-rcd-002.cisco.com
X-Outbound-Node: alln-core-11.cisco.com
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 01, 2020 at 05:12:44AM +0000, Y.b. Lu wrote:
> Hi Daniel,
>=20
> Sorry for the trouble.
> I think you were saying below patch introduced issue for you.
> fe0acab mmc: sdhci-of-esdhc: fix P2020 errata handling

Yes, this patch cased mmc to stop functioning on p2020.

> Actually it looked fine from code. Probably it resolved its own issue but=
 caused another.
> I don't know which kernel you were using. Could you have a check whether =
my other fix-up patches which may be related to P2020 in your kernel after =
that one?
> I remembered P2020 should work.

We are using 4.9 stable. Your patch changes from quirks2 to quirks, but the
original patches all use quirks2.

> 80c7482 mmc: sdhci-of-esdhc: fix serious issue clock is always disabled
> 429d939 mmc: sdhci-of-esdhc: fix transfer mode register reading
> 1b21a70 mmc: sdhci-of-esdhc: fix clock setting for different controller v=
ersions
> 2aa3d82 mmc: sdhci-of-esdhc: fix esdhc_reset() for different controller v=
ersions
> f667216 mmc: sdhci-of-esdhc: re-implement erratum A-009204 workaround
=20
These are all 5.5 time frame patches, unless it's in stable we don't have t=
hem.

Daniel=
