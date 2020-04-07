Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFFBC1A1180
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 18:35:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726877AbgDGQfM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 12:35:12 -0400
Received: from rcdn-iport-4.cisco.com ([173.37.86.75]:5255 "EHLO
        rcdn-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726873AbgDGQfM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Apr 2020 12:35:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=428; q=dns/txt; s=iport;
  t=1586277312; x=1587486912;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=rUKFq0G4vmiNoKpfot/ksTAVDfAJ8xYSDal/Y2PZ81s=;
  b=EMSMYJEqPre+mZ9RiHbmJUmdx6XpFgfqbAmpW6XOAJ+z4MNzI/Z1Carl
   wTnp0mVaFuhLs2WylCqARIPf1hrXL4lHZAzsbSEJI1z3OSwxqpU1/iPE+
   HuShfbtOQwErt5XjktMYCYwtyq++r/CaqD2MwPi0vE1mmAKpk151/5FNb
   o=;
X-IronPort-AV: E=Sophos;i="5.72,355,1580774400"; 
   d="scan'208";a="747243348"
Received: from alln-core-7.cisco.com ([173.36.13.140])
  by rcdn-iport-4.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 07 Apr 2020 16:34:46 +0000
Received: from XCH-ALN-002.cisco.com (xch-aln-002.cisco.com [173.36.7.12])
        by alln-core-7.cisco.com (8.15.2/8.15.2) with ESMTPS id 037GYkbF003931
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL);
        Tue, 7 Apr 2020 16:34:46 GMT
Received: from xhs-rtp-002.cisco.com (64.101.210.229) by XCH-ALN-002.cisco.com
 (173.36.7.12) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 7 Apr
 2020 11:34:46 -0500
Received: from xhs-rcd-003.cisco.com (173.37.227.248) by xhs-rtp-002.cisco.com
 (64.101.210.229) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 7 Apr
 2020 12:34:45 -0400
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (72.163.14.9) by
 xhs-rcd-003.cisco.com (173.37.227.248) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Tue, 7 Apr 2020 11:34:44 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RjQMkkYr2AxYcf6jd5UYlTKLTJypxJ7V373gnmDY46l2bW8nRInjmJ30WHIL8FIR518Ekgk0GvwlnI7MHcY4nA9Bw2YP43/R4BT0min/GgsFsCLUrSzYZnG/xCjgiH12eIzK22mrUCoXbff5WtZxojwuHXdKc0txJ3lcnqgTb6+CsJbM1yCM25ds0rTaSlmm8pnoWRl2O5c8NW0ZKTZeyBzNTvB5H4N6G4hGirWlenYougE0CJCweGEBjsm8NtKyfcn5cg63TWZlmpycbfZloMuf4qznDXcSOKZg9nVEgVGrnixfwgIdJJgvZs+TAO2j+KhGSsHV5z0eIqw2KQyGtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rUKFq0G4vmiNoKpfot/ksTAVDfAJ8xYSDal/Y2PZ81s=;
 b=JAc5X3UoWZdMSuJOTqk0sPUTQDTcpKYYKWQwfxe3u4ETESEF5bIGowQFcVn31LaEgVR4aIemptD8RlhMaXFgOx8cbHjNglzpCh1eC2i2zlKiAq0uJ3YTiVjV6J5I9JONeY8DJf2Z6M3rEo9W+9QJfkMEy18MGl4FEGdP2pCzBnonGTp97zIq7MAnXhPrTi6ha/frUu4gYRw9xPTnuCRp5inf6zpmoFcwpcvOdfl32G6Cm2v/9p7DRDH7eecwgOVoq6KmXaMnxNIcfc7mRzwvbdJhk1KPiaZOMrqyH/BydLbeMoAFzHIZ1MtTnREfoRk1Z6XY+NfNFsJr1I4jBsgsdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rUKFq0G4vmiNoKpfot/ksTAVDfAJ8xYSDal/Y2PZ81s=;
 b=y2g+kaRo5dEj97qX76y1BMTz2IEJvmbuzLHrA/tl5LgYahuT2Kq0LntiFiP6FHhml3Fj0vPRfg9RCgV8aWmS1qpqWWYiJkNIV0OOtxEOBb80QT9NA2YlcggTxt+LTTILBM3Z7w5qDRwAuWQLpXLK1gUVA63E46DDSVRPgsPBpk8=
Received: from BYAPR11MB3205.namprd11.prod.outlook.com (2603:10b6:a03:1e::32)
 by BYAPR11MB3512.namprd11.prod.outlook.com (2603:10b6:a03:8f::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.16; Tue, 7 Apr
 2020 16:34:43 +0000
Received: from BYAPR11MB3205.namprd11.prod.outlook.com
 ([fe80::d015:3039:2595:7222]) by BYAPR11MB3205.namprd11.prod.outlook.com
 ([fe80::d015:3039:2595:7222%7]) with mapi id 15.20.2878.018; Tue, 7 Apr 2020
 16:34:43 +0000
From:   "Daniel Walker (danielwa)" <danielwa@cisco.com>
To:     "Y.b. Lu" <yangbo.lu@nxp.com>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Shyam More (shymore)" <shymore@cisco.com>,
        "xe-linux-external(mailer list)" <xe-linux-external@cisco.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: mmc: sdhci-of-esdhc: fix P2020 errata handling
Thread-Topic: mmc: sdhci-of-esdhc: fix P2020 errata handling
Thread-Index: AQHWDPpxdQdUnnvWsk6SjNz175Py5g==
Date:   Tue, 7 Apr 2020 16:34:43 +0000
Message-ID: <20200407163443.GK823@zorba>
References: <20200331205007.GZ823@zorba>
 <AM7PR04MB6885CDDD1ECEEAE7111C6201F8C90@AM7PR04MB6885.eurprd04.prod.outlook.com>
 <20200401152635.GA823@zorba>
In-Reply-To: <20200401152635.GA823@zorba>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-Auto-Response-Suppress: DR, OOF, AutoReply
X-MS-TNEF-Correlator: 
user-agent: Mutt/1.9.4 (2018-02-28)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=danielwa@cisco.com; 
x-originating-ip: [128.107.241.170]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: eecf6529-f61a-4a02-4004-08d7db1193cd
x-ms-traffictypediagnostic: BYAPR11MB3512:
x-ld-processed: 5ae1af62-9505-4097-a69a-c1553ef7840e,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR11MB35125C225C72609A296F095EDDC30@BYAPR11MB3512.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2000;
x-forefront-prvs: 036614DD9C
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3205.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(7916004)(4636009)(346002)(396003)(366004)(136003)(39860400002)(376002)(71200400001)(8936002)(4744005)(4326008)(33716001)(186003)(26005)(6506007)(86362001)(1076003)(64756008)(8676002)(66946007)(66446008)(33656002)(81166006)(6512007)(478600001)(6916009)(76116006)(6486002)(2906002)(5660300002)(66556008)(316002)(81156014)(54906003)(66476007)(9686003);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: cisco.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pbkNydo48CluwUswmrT8TNgIAmTYrdwYeipGJcxS9dnTDTq+C+5fg2ZpjIvZ+ZEWt/0ULljsa5mLBXf3qlrvjbkMSqH6xKZxgzhMI5/nRYqusCNyPW58WiPs4daA3bFvLnFHERzNvk+3x0gyApxmDua/yRDRTZXSvbBYoQepUh4SDeY0CaLUiR5jJM+JCy/x/hWS9ds9KfGFsMkW54Ej8pJnAA2eaOBv6kxdes68SG7SnmYQqk2XYN6zllF0uNrB8IMDrsK0V7y4FsqQ3Vg1HC4gpIq5rH9u6/o4Qs8egDhL98D27j9y3ai1lkZIMS6gkw+nMemHbktCg1y53STktTQdXrh+RuNfzwvrInmmOvq4XoyRfHFD0xO+raDl72RWl0o8BcjzaL3V6m+W/joWH65N1pDYlSK8EdhILMf52HeDA5TzyFBSIFANxRe53iKf
x-ms-exchange-antispam-messagedata: eLrckXkddL5thDfOb+Moxiek1HzIM4Uo1t7kEBw5aCPnrSxynVmfJ5Ny4Xs0NRXilTCfwdfpmT4BKndqrVZyucyaUgbtmu5QHG6HpKz/YzAh5NT/tZlVQ5Obg0O3uKCQ96lO+dubRBb4dTc2hVDs1g==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B8A3B340358612478E4ED06802FA72A8@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: eecf6529-f61a-4a02-4004-08d7db1193cd
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Apr 2020 16:34:43.5194
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: n2rYU8xyixjCxhhsCkF4CcyCTlGZtTGzab9h0/50J85EuzOjy3Z4u1tOkfY9kraI/UHtjhRAl3OEjRCTylmu2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3512
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.36.7.12, xch-aln-002.cisco.com
X-Outbound-Node: alln-core-7.cisco.com
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 01, 2020 at 03:26:35PM +0000, Daniel Walker (danielwa) wrote:
> On Wed, Apr 01, 2020 at 05:12:44AM +0000, Y.b. Lu wrote:
> > Hi Daniel,
> >=20
> > Sorry for the trouble.
> > I think you were saying below patch introduced issue for you.
> > fe0acab mmc: sdhci-of-esdhc: fix P2020 errata handling
>=20
> Yes, this patch cased mmc to stop functioning on p2020.
>=20

Have you investigated this ?

Daniel=
