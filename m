Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7E1E32E27
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 13:04:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727588AbfFCLE7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 07:04:59 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.61.142]:34816 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727587AbfFCLE7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jun 2019 07:04:59 -0400
Received: from mailhost.synopsys.com (dc8-mailhost2.synopsys.com [10.13.135.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 2CCFCC1CC4;
        Mon,  3 Jun 2019 11:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1559559879; bh=cDJkK9nIjLSqJ1yDKjJ9VIgwel7cmwLtHlfD3aCY60U=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=RGXUW0+0orzPDp6mC3fyPkFwW5bfML2WjnB4vsEjKlHH30RfF8HThq3bN6onuybId
         d82uFopsIc9ldzj+GoLXv6PAKHxCqKoR7dDqtB1kPUb8Kx2OKwN3At1s7wOmUvktIx
         U/Qcp0mxSt+/QXQ9iF9Leq9isWDriZmy9CurneGP61YHR5MKqIbFQqJIGlUFByfrNi
         Ryvck8KfMmuWNQOhRQY++APzKU7ucenyWZWWBy/yfa2s22HioNHQQ543DCBfmmvJ9O
         enQtOT+kyrlDPuTGa7UBi84r34chlGIK2PA0QwuDskyjCRA/xAz1ZgTyEtNr//tOKQ
         BYiolDgsU7Hpw==
Received: from us01wehtc1.internal.synopsys.com (us01wehtc1-vip.internal.synopsys.com [10.12.239.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id BBCF4A0067;
        Mon,  3 Jun 2019 11:04:52 +0000 (UTC)
Received: from US01HYBRID2.internal.synopsys.com (10.15.246.24) by
 us01wehtc1.internal.synopsys.com (10.12.239.231) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Mon, 3 Jun 2019 04:04:52 -0700
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (10.13.134.195)
 by mrs.synopsys.com (10.15.246.24) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Mon, 3 Jun 2019 04:04:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=synopsys.onmicrosoft.com; s=selector1-synopsys-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cDJkK9nIjLSqJ1yDKjJ9VIgwel7cmwLtHlfD3aCY60U=;
 b=cDrzBiv69Ji8Wi1mHeZqxYOXlGmKIM4gBsTIYgp4qsspuoJg7v5Li2Abs886Goy7ErPNMH33Bv+fNICn8IXoRbcJEKtXwJ2+KwMT65A52EnqAJDR+zKmOBrFTvEQBhxsD5JuzNsWIqlcLLC/pM6rNP8rB3vT0BfPK/zFx+ehU4Q=
Received: from CY4PR1201MB0120.namprd12.prod.outlook.com (10.172.78.14) by
 CY4PR1201MB0053.namprd12.prod.outlook.com (10.174.53.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1943.22; Mon, 3 Jun 2019 11:04:49 +0000
Received: from CY4PR1201MB0120.namprd12.prod.outlook.com
 ([fe80::d536:9377:4e1c:75ad]) by CY4PR1201MB0120.namprd12.prod.outlook.com
 ([fe80::d536:9377:4e1c:75ad%4]) with mapi id 15.20.1943.018; Mon, 3 Jun 2019
 11:04:49 +0000
From:   Alexey Brodkin <Alexey.Brodkin@synopsys.com>
To:     Masahiro Yamada <yamada.masahiro@socionext.com>
CC:     Michal Marek <michal.lkml@markovi.net>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        "linux-snps-arc@lists.infradead.org" 
        <linux-snps-arc@lists.infradead.org>,
        "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>
Subject: RE: [PATCH] kbuild: use more portable 'command -v' for
 cc-cross-prefix
Thread-Topic: [PATCH] kbuild: use more portable 'command -v' for
 cc-cross-prefix
Thread-Index: AQHVGfont1F7Wo44NUqpr9HzdNLvIqaJw/Qg
Date:   Mon, 3 Jun 2019 11:04:49 +0000
Message-ID: <CY4PR1201MB012052D53B42622F45E39143A1140@CY4PR1201MB0120.namprd12.prod.outlook.com>
References: <20190603104902.23799-1-yamada.masahiro@socionext.com>
In-Reply-To: <20190603104902.23799-1-yamada.masahiro@socionext.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=abrodkin@synopsys.com; 
x-originating-ip: [84.204.78.101]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 610f6186-422a-4ca3-ba95-08d6e8134c15
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:CY4PR1201MB0053;
x-ms-traffictypediagnostic: CY4PR1201MB0053:
x-microsoft-antispam-prvs: <CY4PR1201MB0053FA162462441F168DCA9EA1140@CY4PR1201MB0053.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-forefront-prvs: 0057EE387C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(366004)(396003)(39850400004)(136003)(346002)(51914003)(199004)(189003)(13464003)(71200400001)(71190400001)(99286004)(478600001)(53936002)(186003)(6506007)(53546011)(54906003)(316002)(68736007)(102836004)(14454004)(26005)(6246003)(7696005)(52536014)(76176011)(7736002)(8676002)(256004)(66066001)(476003)(81156014)(11346002)(305945005)(446003)(81166006)(74316002)(4744005)(86362001)(2906002)(6116002)(25786009)(3846002)(64756008)(6916009)(6436002)(76116006)(66476007)(66946007)(73956011)(229853002)(33656002)(486006)(55016002)(9686003)(5660300002)(4326008)(8936002)(66556008)(66446008);DIR:OUT;SFP:1102;SCL:1;SRVR:CY4PR1201MB0053;H:CY4PR1201MB0120.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: synopsys.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: t273X3GLfK7OlKz9i4CQQjUdIoLXnMd6fVIER3ZxDaat70DVkZVd4+r5rhAGm7JBrpW3W+JlxvKIHXSZejjWPWPlN1T6VF1Bgdml4yqILyvKj1gTmBrVNe1mkwoTSn8RbDPRxBR7H4mpEE4liPRN0akQ1qHwilftRI1ulvl/ZS/nOByl5K3/O3TFZobICmuF89Wi9mcuv3VGnLMsV0a/9QEGkciA0J2LA9Z44dzGYlLaQAnDtMmWiEQXR/XraPSsUd0AsKRL1J8wsVdgtWGFv5JUlPdhPprwibJcboYSb0vbpNh4pzcppgGS6cu8P2BM+Lj2LtmFDnkaG1j2YjehUHIrj1MtrTP4lXUOs4DD9tue2YVJUt3edDpLoxvewg0K2n6Ok60jVTNf9ueivdQOD1KZOhRdo3PWwwYFa7Qui10=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 610f6186-422a-4ca3-ba95-08d6e8134c15
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jun 2019 11:04:49.6157
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: abrodkin@synopsys.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0053
X-OriginatorOrg: synopsys.com
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Masahiro-san,

> -----Original Message-----
> From: linux-snps-arc <linux-snps-arc-bounces@lists.infradead.org> On Beha=
lf Of Masahiro Yamada
> Sent: Monday, June 3, 2019 1:49 PM
> To: linux-kbuild@vger.kernel.org
> Cc: Michal Marek <michal.lkml@markovi.net>; Vineet Gupta <vgupta@synopsys=
.com>; Alexey Brodkin
> <abrodkin@synopsys.com>; linux-kernel@vger.kernel.org; linux-stable <stab=
le@vger.kernel.org>; Masahiro
> Yamada <yamada.masahiro@socionext.com>; linux-snps-arc@lists.infradead.or=
g
> Subject: [PATCH] kbuild: use more portable 'command -v' for cc-cross-pref=
ix

[snip]
=20
> Fixes: bd55f96fa9fc ("kbuild: refactor cc-cross-prefix implementation")
> Cc: linux-stable <stable@vger.kernel.org> # 5.1
> Reported-by: Alexey Brodkin <abrodkin@synopsys.com>
> Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
> ---

Thanks for the prompt fix - it does the trick, now no junk in the console!

Tested-by: Alexey Brodkin <abrodkin@synopsys.com>
