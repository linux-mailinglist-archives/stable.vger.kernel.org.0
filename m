Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C6B82AB4E9
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 11:31:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727303AbgKIKbs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 05:31:48 -0500
Received: from mail-eopbgr40055.outbound.protection.outlook.com ([40.107.4.55]:39694
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727077AbgKIKbs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 05:31:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W/atZuFIJks+ZA1k6vVhki5pT/FY5jw9u26sOMfpl90ANuhcZsX57jjPebHseW611yGRneObmesu14bLQXsYVuqyVQt1Tkf/23AY0vHKMWB0DPHA/SnuzVAsxzIyGM/JB4hx4MrQpjewLrpqqcnoCucFk2R1v3D9QZiWOrvapj3zjbHHFRNbCeBiq+KJwn+WOEJTOioEdwR7SJKtpta3UIMlRYuzRs3+fjXCy0HiFPiZNFGaHs8goLl0ztxxNKOH359/FJlEKw5lCdv4vqftXz/32gybOC3GGgZg3/93dg18JzbDb58jRI80uyzTJh/h2/DwGAmG8WQPsMgZs8jXTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DJF+gLn+cnjXUn/yHxN61voEAZZgpRIGC++62gS1uTA=;
 b=QCWTHE5023IXwPcpN+waQRGFCsaxGaSVGn6LEIgruDdfrYxaNzSrZQfVmAW0BcKRhK5fSN7w9zod+jxOP28lpJs5w+spo+prU4GmChZ+Hh7wzao8PVUgSMgnXEKa8W5CI0QWCddW0TQCssqOgEA7Z1lpRxQiEiQsTSqjwX2sLO5iEErVwH7fsmyWMLqa+IJaMDObUSOV/1nj+4YxM8Z1EtUkxAyS9mbBPHJhvx43/UOGC/vZT5peOtCCvRNlgWF9qE6cSyrKMKiUTjpBWMt1k9ILr3shipVMysnbXcLcme98MFgb8L8rjJfI0OHPKvB2qaOUxYWcuZ+jg2Ht4K4uRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DJF+gLn+cnjXUn/yHxN61voEAZZgpRIGC++62gS1uTA=;
 b=p7cQFLaNlUsP9Z3+QjE7pWp/uYznOQNwZiZ7F7OjyCW6UC8bvzmrLIg7CZBvCYp7arwifkQPK2Cgz6rZLX+j9fADI6oliCbVQ+tVujWCclCaL52R6McmBr1+FUE3380og3gFFnIcggX23yhJU69BFkjLgG0JSao3XqM54Tuql94=
Received: from AM6PR04MB5685.eurprd04.prod.outlook.com (2603:10a6:20b:a4::30)
 by AM6PR04MB5432.eurprd04.prod.outlook.com (2603:10a6:20b:93::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21; Mon, 9 Nov
 2020 10:31:45 +0000
Received: from AM6PR04MB5685.eurprd04.prod.outlook.com
 ([fe80::c62:742e:bcca:e226]) by AM6PR04MB5685.eurprd04.prod.outlook.com
 ([fe80::c62:742e:bcca:e226%4]) with mapi id 15.20.3499.032; Mon, 9 Nov 2020
 10:31:45 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     Andy Duan <fugang.duan@nxp.com>,
        "michael@walle.cc" <michael@walle.cc>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] tty: serial: fsl_lpuart: LS1021A has a
 FIFO size of 16 words," failed to apply to 5.4-stable tree
Thread-Topic: FAILED: patch "[PATCH] tty: serial: fsl_lpuart: LS1021A has a
 FIFO size of 16 words," failed to apply to 5.4-stable tree
Thread-Index: AQHWsezEOoIzEfoLKkKJJMHVEvkOMqm3AwaAgAicWACAAAPTgA==
Date:   Mon, 9 Nov 2020 10:31:45 +0000
Message-ID: <20201109103145.3fryic2thanjh4f4@skbuf>
References: <160441340011200@kroah.com>
 <20201103224825.gxvly2qijdr2hmsk@skbuf> <20201109101804.GA1065310@kroah.com>
In-Reply-To: <20201109101804.GA1065310@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=nxp.com;
x-originating-ip: [188.25.2.177]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 72919c05-b6eb-44d7-0bd0-08d8849aa867
x-ms-traffictypediagnostic: AM6PR04MB5432:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR04MB5432A6A2C882B8D8EF8D10B3E0EA0@AM6PR04MB5432.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:758;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JS6uDxuruFBP5C3Wa8WGLesLFmxnn1HY5966IcIXmXQ+Unx02fT0vBfHr9edPx5yFUofz8Ma8s4kAnAQ/LaiAJzM/whNBRYNxKe0Y2xRh6w9UXU/OYG0UocyNGN8N/G+kJggdRNdrP9zdKQfRE+5UKdMiQbz6lvF3YWwQ/yMImTlTonD6raHOSR+zcFMrotYo9cSclWc121KrhzK+ftzlyzpFCQj4e5OLrxPbzky67Bm0YxXltZ8R08j+Db9pw/uiDIkDmtFeTNZpzbERxcyBDW+46V2FCZvl4h/e5lj12DPfgmYTY+tFsp3MJ5wYVEn
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR04MB5685.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(7916004)(346002)(376002)(136003)(39860400002)(396003)(366004)(2906002)(6486002)(6916009)(558084003)(186003)(66946007)(66476007)(66556008)(64756008)(66446008)(76116006)(91956017)(26005)(71200400001)(478600001)(86362001)(33716001)(5660300002)(8676002)(9686003)(6512007)(316002)(54906003)(1076003)(44832011)(4326008)(6506007)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: ar0guQhLhGP9lcf3fXKf3M34qpJpea2mE5ftlCDk/3W35qyAANmkTMQXrevTV4Q53rwVpZhjpekdv5b45/Ui4jj2tJDzYyPDMdWze4Ykr+njhjtzT+NklMlW7ctjUti4TsL6GuLQnrajBG4hLlPTjUiWXd+6Q6jRGDvYOi7h4e33kYsXiy9XpiVRkmyCedhY5mnpuvwPJwkvX8CP0awYcIlgMnzFN6On96Rk2DBgkQCF1WOoEnBWQUNWu+Iuj+6ygsdAZUvbKq0/kLXTbLae0dvp/j0BZP4SJVjpSQ8e7v52K8I9nqwL14Z7gVVBHaH95qX1FD4gZ2vY6HeAnW2syAp5yWArpUMLeKetlCvkNBAL76T5eF/UnRgpNuwmqkFw8yNsxQ7gq8zcv0DRMxviuwyIa/p4yW7K8W3+yJomtfPsJ9YA8e3coRaLfnDFyO4XK6cYjiXNch5eKhPCiAeeeTmGPovkoguOrXkZbOnTTat8uCi8edJ6kbk5KwCLNG3MtXFUTl5DQdUAKzqVyfBJnAnDtWnRZbpgl2AEgOuIH25f4tHgzatw/Q9Im9zFMHLh16Fna5jJJkpipfgfC7HMFocdB0ekvysfTIbdmcfFtyRPrW6TjwqKOaWgfWi/O8tfPUl43q9rZak1RGc2FpAhSg==
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2A406CA6FB4F81439FC2A43A52DBA4DF@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB5685.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72919c05-b6eb-44d7-0bd0-08d8849aa867
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Nov 2020 10:31:45.7251
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: otIGsw+0sw5BN7Mt9BNTDT/1k37efkXgzJakLcmHWWUqsw4IVv4m4DA/CqH24A/kwE6a7iZhHkdc3RnnOIqoGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB5432
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 09, 2020 at 11:18:04AM +0100, gregkh@linuxfoundation.org wrote:
> That worked, now done, thanks.

Thanks a lot!=
