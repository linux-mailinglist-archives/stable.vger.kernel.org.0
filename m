Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F1421EB7E4
	for <lists+stable@lfdr.de>; Tue,  2 Jun 2020 11:07:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726380AbgFBJHV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jun 2020 05:07:21 -0400
Received: from mail-eopbgr1410137.outbound.protection.outlook.com ([40.107.141.137]:9440
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726311AbgFBJHU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jun 2020 05:07:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KwoM9x9rYN/Rbzl9hZYP71j6jTOXZHTJV6OefrUbYarSsMUawvygh+8uzT9H0frxYPrzIrivzMOHrQLd0j+swOPAQ//f4RHr/Jul9X13y8SvwPadluhQUNHzyVBSK2nNudkZ//IX6L/KF+vGMkawygDshxFvaV0VkVIBB6v+MTXc+mco1FXbi2AxVfp1M8z+t1gub2gJZlbbv/PWGzvq6t3f8qdtsCnRzrPnlyfmsCarMbVWAF9b2LJ/6f4gwa4VbxdYcYozxHAKwhyL8PYg9BfpK2WHsGSpWSACM8l6SQSjsiG6xAGZXOAP73SYlRhSjYY6+us4rJvB/FVstC3IUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AX6/p9SoNQGtsFzGs/40isfbplQwU4ymyIQZ8X6wDF4=;
 b=cEJQRrVq/oVhtdSaCZh5t62wDyHlS5nMPRBS0sR1JnuusgzmiFgT3a1vIivsRC3HM0V8KTIaV1ycjaNPlbIuxzVfXX80yjiIOIRMip3fWyjuOljEw5EWG3w9P//B0oooqVKJyPgHl+CQ7oZk2FwQSqOnkfrF34OBc5uubhC+4SbWdHMHct9TFgCCfAPJmPB3HMO1thrftX5JHku+/FHA6aTZCaRxMxhrD5cO+XWjnwT7ebpnnGZoXcUqqYrPf2krgcBsxKp4CBe7Sl5PPqTHClRbzrA1j0rR+H6aQBiJn1FaX3y0RdueRABIBpsR5Hc3PLoD5ZILNIh4cV5lJfyJpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AX6/p9SoNQGtsFzGs/40isfbplQwU4ymyIQZ8X6wDF4=;
 b=pBzsdEqboNGXHNwFRvNZc88tPQm6RSos6tMzSE7MJKpumr29l1oJrWWdwMBtqN5ShqRM77Fz2I05tAfYsCL0tvxwhhGJHhwBuNQpPcU4mln2w04JzHXTuLAC3kJbtmbrJPoivGQ/rjSmw1YzEO19bm6TUaXWP8jbrTgl/qHGhtA=
Received: from OSAPR01MB2385.jpnprd01.prod.outlook.com (2603:1096:603:37::20)
 by OSAPR01MB2177.jpnprd01.prod.outlook.com (2603:1096:603:18::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.25; Tue, 2 Jun
 2020 09:07:16 +0000
Received: from OSAPR01MB2385.jpnprd01.prod.outlook.com
 ([fe80::c44c:5473:6b95:d9fd]) by OSAPR01MB2385.jpnprd01.prod.outlook.com
 ([fe80::c44c:5473:6b95:d9fd%6]) with mapi id 15.20.3045.024; Tue, 2 Jun 2020
 09:07:15 +0000
From:   Chris Paterson <Chris.Paterson2@renesas.com>
To:     Sasha Levin <sashal@kernel.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux@roeck-us.net" <linux@roeck-us.net>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "patches@kernelci.org" <patches@kernelci.org>,
        "ben.hutchings@codethink.co.uk" <ben.hutchings@codethink.co.uk>,
        "lkft-triage@lists.linaro.org" <lkft-triage@lists.linaro.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH 4.4 00/48] 4.4.226-rc1 review
Thread-Topic: [PATCH 4.4 00/48] 4.4.226-rc1 review
Thread-Index: AQHWOEblTp/wW69zwEmAlBmsCs3iiajEQ4lwgABQ3oCAAHTo4A==
Date:   Tue, 2 Jun 2020 09:07:15 +0000
Message-ID: <OSAPR01MB2385A58EDAF34A14A3756230B78B0@OSAPR01MB2385.jpnprd01.prod.outlook.com>
References: <20200601173952.175939894@linuxfoundation.org>
 <OSAPR01MB23858265B59669B78394A94CB78A0@OSAPR01MB2385.jpnprd01.prod.outlook.com>
 <20200602020651.GM1407771@sasha-vm>
In-Reply-To: <20200602020651.GM1407771@sasha-vm>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=renesas.com;
x-originating-ip: [193.141.220.21]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 15404bcb-fe4e-4a1b-93de-08d806d45838
x-ms-traffictypediagnostic: OSAPR01MB2177:
x-microsoft-antispam-prvs: <OSAPR01MB2177D9D8C63E37696949E2ADB78B0@OSAPR01MB2177.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0422860ED4
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aa2dXi7ddlBBScsueMkKF9uH7hkEFca/sqgwN2Vsv+absf7KDlHZ9+4sRuZPXfPefdAHxD23p6GMdCGO0tpJajtJSgGezRadJIvLXnUwoJ5Pr4KCgyPtXyVhnVhZE1Qav29RCGtNKblN7brz/yFQYqXRokGZEIOcsBAh1tGvt3jYs8WOp0BlTeLmGX1RazocgaHnvEW1RkksjMYMu8j5TAsbO/FEVQBuw2jAHTgVI40NbHOoOuE0oTcHVZrAwZ0vfDlLeKsBgadvWcOSBxBOM7n7+4w+HlllTnGu6aq9Px9uLmIlLZgAIYOosPhLhRn5dCYrbN/irpJOziVJzZxNKc0+qONmYxxbAzX0FrQTnfdNcfLZ7MFxIAEYI+Vrsfjg94OCx19QuUwzS8XYMrVWxg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OSAPR01MB2385.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(376002)(366004)(39860400002)(396003)(346002)(8676002)(316002)(478600001)(7696005)(966005)(33656002)(54906003)(186003)(26005)(6506007)(9686003)(4326008)(8936002)(55016002)(66946007)(66476007)(66556008)(64756008)(66446008)(86362001)(83380400001)(76116006)(6916009)(2906002)(7416002)(52536014)(71200400001)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: uMwFoNXJ9PbK9Q5VMfgYrIr4rWypzjSMPF1vKFx+5JIGZCHYqV9FHFJD+7j1H1QtCSJpdsbVp1j/sa6Q8ad6NpAtv1+J/el13Vm1LrGNdYq3yjxqX31OlnYQWySEdV/9F8FfiukDMyMr/v1vqqbP+iDAbaZcKXYsOhadLpLRqNt8najcC+xVBfDcqqrJQRD7n0xb9aawQBmeB4fA5WzNobji3qqlWmprCmPFJ5qfV3B/v8CVXXy1jYbY9M6ZhjQFVbZjH4fgqzWvBX4bxjulN+lhAI25NIf8Da3CHUbu0pf5D8ZZbBdNVFtHoLAzPj4Ciop9536XfGualYyE4rkDJOFH/Vj8bkKZyX5g21JeqGqUi6nXGrd1OmFQCo7SvTSN5d+26KwKgZR0GoeQmXZ5LsmrMyd4txj9/Js82DqohpHdpgeZTXxEYX/Jqg1lvAkQk/nueJzfym8e0QKrk5DVDXUqYYJlJhbhkPB1Db7IszmUlX4Mhs2sFoYy/NDdqPWU
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15404bcb-fe4e-4a1b-93de-08d806d45838
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jun 2020 09:07:15.3942
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YuMaozuaZcXfyN7R4WoU90gkIkbUhu1qFSefQ58g1uD2DOYa4dyfc/W8eBKGjMv9ACAaNdGFi5B6LtfMR5D0GX8k5rOlfxxnE9a8txhtILU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSAPR01MB2177
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Sasha,

> From: stable-owner@vger.kernel.org <stable-owner@vger.kernel.org> On
> Behalf Of Sasha Levin
> Sent: 02 June 2020 03:07
>=20
> On Mon, Jun 01, 2020 at 10:14:20PM +0000, Chris Paterson wrote:
> >Hi Greg,
> >
> >> From: stable-owner@vger.kernel.org <stable-owner@vger.kernel.org> On
> >> Behalf Of Greg Kroah-Hartman
> >> Sent: 01 June 2020 18:53
> >>
> >> This is the start of the stable review cycle for the 4.4.226 release.
> >> There are 48 patches in this series, all will be posted as a response
> >> to this one.  If anyone has any issues with these being applied, pleas=
e
> >> let me know.
> >
> >I'm seeing some issues with Linux 4.4.226-rc1 (dc230329b026).
> >
> >We have 4 configurations that fail, 2x Armv7 and 2x x86, whilst building=
 the
> modules.
> >
> >Error message:
> >  ERROR: "pptp_msg_name" [net/netfilter/nf_conntrack_pptp.ko] undefined!
> >  ERROR: "pptp_msg_name" [net/ipv4/netfilter/nf_nat_pptp.ko] undefined!
> >
> >Relevant patches are:
> >  69969e0f7e37 ("netfilter: nf_conntrack_pptp: prevent buffer overflows =
in
> debug code")
> >  3441cc75e4d1 ("netfilter: nf_conntrack_pptp: fix compilation warning w=
ith
> W=3D1 build")
> >
> >I haven't had a chance to dig deeper yet but will do in the morning.
> >
> >Build/test pipeline/logs: https://gitlab.com/cip-project/cip-testing/lin=
ux-stable-
> rc-ci/pipelines/151700917
> >GitLab CI pipeline: https://gitlab.com/cip-project/cip-testing/linux-cip=
-
> pipelines/-/blob/master/trees/linux-4.4.y.yml
> >Relevant LAVA jobs:
> https://lava.ciplatform.org/scheduler/alljobs?length=3D25&search=3Ddc2303=
#table
>=20
> Thats and interesting one... I've queued fe22cd9b7c98 ("printk: help
> pr_debug and pr_devel to optimize out arguments") for 4.4 to address
> this.

This patch resolves the issue for me.

Test pipeline: https://gitlab.com/cip-project/cip-kernel/linux-cip/pipeline=
s/151885545

Thanks, Chris

>=20
> Thanks for the report Chris!
>=20
> --
> Thanks,
> Sasha
