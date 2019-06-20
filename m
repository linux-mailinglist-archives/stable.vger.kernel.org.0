Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A34AC4DADF
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 22:03:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726218AbfFTUDd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 16:03:33 -0400
Received: from mail-eopbgr750101.outbound.protection.outlook.com ([40.107.75.101]:54134
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725903AbfFTUDd (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 16:03:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=wavesemi.onmicrosoft.com; s=selector1-wavesemi-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v29dJJNvykQn+fJWRTTPGchZkBFetIV1OtEvVAm8o58=;
 b=QIqtqozE+ZZ8ggeL7SNIh8hpISBkl3OWzwzuhMay8i8drtrcbf92HwDz9oZVFJSh7gQ5lHcE8TiukXDfDYF64MV6lPmFWBHURe86uQi4NTLvoMO0GAWUhiYFX5bTXOkW803/YuZNcmdjsmllJZ1iVKW3TGD1cpclsXFJfZyj8aQ=
Received: from MWHPR2201MB1277.namprd22.prod.outlook.com (10.172.60.12) by
 MWHPR2201MB1184.namprd22.prod.outlook.com (10.174.171.39) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.13; Thu, 20 Jun 2019 20:03:29 +0000
Received: from MWHPR2201MB1277.namprd22.prod.outlook.com
 ([fe80::6975:b632:c85b:9e40]) by MWHPR2201MB1277.namprd22.prod.outlook.com
 ([fe80::6975:b632:c85b:9e40%2]) with mapi id 15.20.2008.007; Thu, 20 Jun 2019
 20:03:29 +0000
From:   Paul Burton <paul.burton@mips.com>
To:     "Hombourger, Cedric" <Cedric_Hombourger@mentor.com>
CC:     Sasha Levin <sashal@kernel.org>,
        "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] MIPS: have "plain" make calls build dtbs for selected
 platforms
Thread-Topic: [PATCH] MIPS: have "plain" make calls build dtbs for selected
 platforms
Thread-Index: AQHVIgBpf6BYLkAQw0aPbj6clwp5T6adO4kAgACh3B+ABltpAIAAyaOA
Date:   Thu, 20 Jun 2019 20:03:29 +0000
Message-ID: <20190620200325.se6e6yicvlkjrb46@pburton-laptop>
References: <1560415970-844-1-git-send-email-Cedric_Hombourger@mentor.com>
 <20190615221604.E6FB82183F@mail.kernel.org> <1560668291651.87711@mentor.com>
 <1561017706300.81899@mentor.com>
In-Reply-To: <1561017706300.81899@mentor.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BY5PR13CA0033.namprd13.prod.outlook.com
 (2603:10b6:a03:180::46) To MWHPR2201MB1277.namprd22.prod.outlook.com
 (2603:10b6:301:18::12)
user-agent: NeoMutt/20180716
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=pburton@wavecomp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [12.94.197.246]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e50b23d5-1807-49e9-e59f-08d6f5ba5c91
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR2201MB1184;
x-ms-traffictypediagnostic: MWHPR2201MB1184:
x-microsoft-antispam-prvs: <MWHPR2201MB1184434A80F8A011DAE2D0E6C1E40@MWHPR2201MB1184.namprd22.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0074BBE012
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(7916004)(39840400004)(366004)(396003)(346002)(376002)(136003)(199004)(189003)(71190400001)(229853002)(6246003)(4326008)(54906003)(58126008)(316002)(99286004)(25786009)(6512007)(9686003)(52116002)(6116002)(6436002)(3846002)(2906002)(42882007)(6486002)(256004)(53936002)(102836004)(446003)(11346002)(8676002)(305945005)(476003)(7736002)(386003)(6506007)(186003)(1076003)(66946007)(4744005)(26005)(68736007)(76176011)(66066001)(33716001)(5660300002)(6916009)(73956011)(486006)(66446008)(81156014)(66476007)(64756008)(66556008)(478600001)(44832011)(14454004)(71200400001)(8936002)(81166006);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR2201MB1184;H:MWHPR2201MB1277.namprd22.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: wavecomp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: e3Ium3BNKYSYCl8c6HfxsnP6VD8mSpQWME4xqcllZuvKXwkl2YxE9Ps6qlwKJjF9+jxUkkdD6UkwJOr6UIgQdb8QQAtsNCkmWUg9+ohgQqEv0PzXtgSbvoWDbfsw1AUBXj7Q+04MwdpG4yUjyBjdJIMLV40nc95NC+4LtbOsyYzEMaklRuh725COqJy5IcLNimvF2pTCGbgLLf4MCuaDNQWwCoEHulNooZzwovwwE7PRLmtN1igTIhQeyASFqAhy52Wr+JrTi85LK92++rlDjQTwoUT0I2GFgIGWWrPZSkKywrdPgm7OL7bDl0MxlbAs7zsy2+D0iNNRTvZz3Lls3t8yJfZxmtm8enl2YEmlQVsD9/guyNu5NLrYsbVKR7n9xVBR8/t8UCZd+gY4KL6BAg4GxuMoh1yfmEu8+1Yv/Mg=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <37EBF8B93C6D0842B386569C71AEA6C6@namprd22.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: mips.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e50b23d5-1807-49e9-e59f-08d6f5ba5c91
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jun 2019 20:03:29.3257
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 463607d3-1db3-40a0-8a29-970c56230104
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pburton@wavecomp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR2201MB1184
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Cedric,

On Thu, Jun 20, 2019 at 08:01:46AM +0000, Hombourger, Cedric wrote:
> Just to follow-up. I have verified that we can apply this patch to 4.4
> and 4.9 without introducing additional patches but simply resolving
> conflicts. Should I post separate patches for 4.4 and 4.9?

Is the patch actually needed any earlier than v4.20?

Locally I've applied it to mips-fixes & tagged it with:

Fixes: d5615e472d23 ("builddeb: Fix inclusion of dtbs in debian package")
Cc: stable@vger.kernel.org # v4.20+

It looks to me like prior to that commit this is unnecessary. If that's
wrong please let me know.

Thanks,
    Paul
