Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0636519A043
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 22:57:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727937AbgCaU5S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 16:57:18 -0400
Received: from rcdn-iport-7.cisco.com ([173.37.86.78]:24567 "EHLO
        rcdn-iport-7.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727852AbgCaU5R (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Mar 2020 16:57:17 -0400
X-Greylist: delayed 427 seconds by postgrey-1.27 at vger.kernel.org; Tue, 31 Mar 2020 16:57:17 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=401; q=dns/txt; s=iport;
  t=1585688237; x=1586897837;
  h=from:to:cc:subject:date:message-id:content-id:
   content-transfer-encoding:mime-version;
  bh=BcxB/aDCsPcgNLPnE7l3yfchgVPTSiLbL/D901fTnE8=;
  b=StJRkeUJvmNiSO3jWEahkz6GaBi85jC5nDAS76UkOnYW0qgVuPyPql7t
   6CrD8w13Q0bLUaPp4w7EKGvXp78tlRMbzGh1P5/NJKNUa5MO4z+zX1aa0
   ugcQAmavK51eLnZo+6TA+/2OEIXokGXbGgfrT9zguFXDVtNqwVy67Q6Dz
   A=;
IronPort-PHdr: =?us-ascii?q?9a23=3AwKHF6RJlRQVXR1/DjNmcpTVXNCE6p7X5OBIU4Z?=
 =?us-ascii?q?M7irVIN76u5InmIFeBvKd2lFGcW4Ld5roEkOfQv636EU04qZea+DFnEtRXUg?=
 =?us-ascii?q?Mdz8AfngguGsmAXEHyKv/nazMzNM9DT1RiuXq8NBsdFQ=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0CZGgD9q4Ne/4UNJK1mHAEBATgBBAQ?=
 =?us-ascii?q?BAQIBBwEBgVMCgVJQBYFEIAQLKgqHVQOKbpF/E4hqgS6BJANUCgEBAQwBAS0?=
 =?us-ascii?q?CBAEBhESCNyQ1CA4CAwEBCwEBBQEBAQIBBQRthVYMhXECAQMSKAYBATcBEQE?=
 =?us-ascii?q?IIRUfBR4nBA4nhVADLgGjQgKBOYhigieCfwEBBYUXGIIMCRSBJAGMMBqBQT+?=
 =?us-ascii?q?EJT6EToVwsHEKgj2XCykOgi0BmTKrIAIEAgQFAg4BAQWBVAE2KoEucBWDJ1A?=
 =?us-ascii?q?YDZIQilV0gSmMVAGBDwEB?=
X-IronPort-AV: E=Sophos;i="5.72,329,1580774400"; 
   d="scan'208";a="739636822"
Received: from alln-core-11.cisco.com ([173.36.13.133])
  by rcdn-iport-7.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 31 Mar 2020 20:50:10 +0000
Received: from XCH-ALN-004.cisco.com (xch-aln-004.cisco.com [173.36.7.14])
        by alln-core-11.cisco.com (8.15.2/8.15.2) with ESMTPS id 02VKoAaW015311
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL);
        Tue, 31 Mar 2020 20:50:10 GMT
Received: from xhs-aln-003.cisco.com (173.37.135.120) by XCH-ALN-004.cisco.com
 (173.36.7.14) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 31 Mar
 2020 15:50:10 -0500
Received: from xhs-rcd-003.cisco.com (173.37.227.248) by xhs-aln-003.cisco.com
 (173.37.135.120) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 31 Mar
 2020 15:50:09 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (72.163.14.9) by
 xhs-rcd-003.cisco.com (173.37.227.248) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Tue, 31 Mar 2020 15:50:09 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HPuzCOZ++2YXL9MDD9OErpj1uOj/YzvpFitb+mdCETWa6NG71cfsX1m0tGF4hfqGdxEvs8gN6rORu9ZRzreThMeoN87sUYo9V3YF20MKRYw0Y4hngfkBLX4HG/KakpLlqhMCqaK2MQZS509IvCwbM1jMhtin9u3rl8hEEWOL0HSenfswmVT3uIZBhonvBwVXXGT+CnLDXBAYcH0cBTf14KVVltUGsFp3NqICJMdKi658CQ6HLRyIMc0croyGuBL2ZbG0nS61yETcSXF37Pb52z97G7c85fG27TzXerunI9LFnGffKhGgc33MZltnBdVv3rxLcWWeNBVMzCTT3l5R0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5w5Nl4Ckx9mFgC04OZvh77zRpqY5I9WczcjU+w6VVWI=;
 b=eS+Hy9csEE5l39sXgfYD4j/SXTw1hhowAgNpCze1pyrB3i+d7KuASvPhZGC8wH8X7XyvQTo9SKfmm+emAPRLyvuZDHLQJDKNpeVAKTLI/BETZwnGIx9UajnDdF3Q6hbhEa/1vccc08F8B0SLfc7gY9clyD6R+/jlSflL8RhuetkzpDdrnRoj7HuniOat1cERsV5NGK+yBdVhiRm63wuMyxstqk2aDBQGzABycM/z0V/OVg01O1lNQ3KEMKt4I5IGBPWBF0t2CLaxhoXDY9y+rtN9MsE0tj00WbZmcBQuAkDpxNjsYAs0sor9j0fjWcI9+8BZVJCJj0Yr6Yr3/GoBiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5w5Nl4Ckx9mFgC04OZvh77zRpqY5I9WczcjU+w6VVWI=;
 b=rz8vIIl6Y9ggY/BTzupAVZidWpi/yO5bJyLFujLXOUewRHGk5Z0PCKpXXybrvdHe6i8sJUmVJfPBEYjNx37CfQCyd6KOe1LhvyPq+4b3HrBKOwNALNE3T3unp3QxIA34lR6++6sX5C2wFXCvPaWpi5+E4nzX+euXBTXjfWjVRrs=
Received: from BYAPR11MB3205.namprd11.prod.outlook.com (2603:10b6:a03:1e::32)
 by BYAPR11MB2581.namprd11.prod.outlook.com (2603:10b6:a02:cc::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.20; Tue, 31 Mar
 2020 20:50:08 +0000
Received: from BYAPR11MB3205.namprd11.prod.outlook.com
 ([fe80::d015:3039:2595:7222]) by BYAPR11MB3205.namprd11.prod.outlook.com
 ([fe80::d015:3039:2595:7222%7]) with mapi id 15.20.2856.019; Tue, 31 Mar 2020
 20:50:07 +0000
From:   "Daniel Walker (danielwa)" <danielwa@cisco.com>
To:     Yangbo Lu <yangbo.lu@nxp.com>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Shyam More (shymore)" <shymore@cisco.com>,
        "xe-linux-external(mailer list)" <xe-linux-external@cisco.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: mmc: sdhci-of-esdhc: fix P2020 errata handling
Thread-Topic: mmc: sdhci-of-esdhc: fix P2020 errata handling
Thread-Index: AQHWB532KYmmzOSk9kuuDMNOQaxK8w==
Date:   Tue, 31 Mar 2020 20:50:07 +0000
Message-ID: <20200331205007.GZ823@zorba>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-Auto-Response-Suppress: DR, OOF, AutoReply
X-MS-TNEF-Correlator: 
user-agent: Mutt/1.9.4 (2018-02-28)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=danielwa@cisco.com; 
x-originating-ip: [128.107.241.186]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7c6a81ca-f25c-417d-5227-08d7d5b518b9
x-ms-traffictypediagnostic: BYAPR11MB2581:
x-ld-processed: 5ae1af62-9505-4097-a69a-c1553ef7840e,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR11MB2581AD1DD31D7842015E293ADDC80@BYAPR11MB2581.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 0359162B6D
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3205.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(7916004)(136003)(366004)(346002)(39860400002)(396003)(376002)(6512007)(186003)(33656002)(478600001)(2906002)(9686003)(71200400001)(316002)(54906003)(26005)(81166006)(33716001)(66446008)(1076003)(5660300002)(4326008)(76116006)(8936002)(4744005)(86362001)(64756008)(66476007)(66556008)(6486002)(6916009)(8676002)(66946007)(6506007)(81156014);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: cisco.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XF7IM7OpraD/yC0JY2WfMPP8U7a4jQd2nOGq9tanmfPR1ZEYBZsF6ATlQ/KJ4rcum0SNahDSsBVdEZywtrOWaKuNUdsBDVKCNlSsiVcpa1DeugHC3mICMfBvAI+/2iRY1ZP12v6mh+vTObaaeDxXMHewRKCsg+KkdzL1yFDXDBrgd/v+bHwDDBjbDRJ4pNU4KvKfVxTZAE0/wkxw65cYAfn1idujv8HpJKVTzgpmqyWXmxOtzyJ0ox2G2UuPCnuGPzNqTTXvToCLBLl6SYnj/c5hgEXeXprlq2qVh40FzPheHokjbkXW6rWErE9eKT+d7ImgzBiXD3MYSvo47tvF4OsgXKPtV6EMQOsBGsinXzENhFhlvo2xBkk1HVjKUIZJrbuAWlki6z0si6S16cF/glwX1BRossJ41b0n8rfgJBKr+oFOkhQzLc09egqt4u+n
x-ms-exchange-antispam-messagedata: Tjwsp/ZLKYOtn2qLZv0dsgcPt9GrdjcytmD6G5u8cGJb/TTs0nHbfwg85wP0d68dtCZJj9LJ7asy6zmdDD1205TRvvAe2EA0qbcrPTUjC+wtTSxpG5hPU/idsYey6nf1P303QlT8xSmJuH8vLb4WSg==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <25008B36E62E3840BE765C42901D568A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c6a81ca-f25c-417d-5227-08d7d5b518b9
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Mar 2020 20:50:07.5710
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cAPQ3oy6/Pf4e74XcJiQJJ9EvrStRu4MxzGkRH6Nq0ZzU7EBsHfcBefpD6u69pwFi3T/bmjYno1YNuBKGYX5YA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2581
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.36.7.14, xch-aln-004.cisco.com
X-Outbound-Node: alln-core-11.cisco.com
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

We got your patch from stable. On p2020 we had mmc issues, and bisected the
issue to your patch.

Both prior patches seems to modify quirks2.=20

    Fixes: 05cb6b2a66fa ("mmc: sdhci-of-esdhc: add erratum eSDHC-A001 and A=
-008358 support")
    Fixes: a46e42712596 ("mmc: sdhci-of-esdhc: add erratum eSDHC5 support")

So I'm not sure if your changes were done correctly.


Daniel=
