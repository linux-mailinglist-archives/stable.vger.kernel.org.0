Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E68623BCB3
	for <lists+stable@lfdr.de>; Tue,  4 Aug 2020 16:53:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726656AbgHDOxt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Aug 2020 10:53:49 -0400
Received: from mail-eopbgr1400118.outbound.protection.outlook.com ([40.107.140.118]:19704
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726580AbgHDOxt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 Aug 2020 10:53:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q6t0/NMeBJIoM9LhB1NI9BbJJbAtvy5Xw/9F2x/PVuFVYfjBHpt1mvICPeLsY5sxxwS8q/rYuO82qZ9+pO2W7tmDqvABuoy3Mql29knNQtyOdEvQESq7qCYqn9r1f0eF8Do+2rPKHKTGDQeB85vbZmnonoErb/qbvL5okNLadmAsYuBqyrXQE6eFFw5q8rgRy2FYthMAAl+fEhqiZc03PPH9D3/CMT0gasI9vmP+VBV9rEllM9O1bsaC+JDKPXa86dyUBYpG5N7qH5ucis6ctu+43viqTywM5ytDWoLtk1smKQWETO0sWPwLzdp8lvqd9F4Hq/RM6mCOK+jfb3ENXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wHJ927n5/Tlkyc4Dn1XWas71JGvz2RR1BVqjdcB+b7I=;
 b=aJh4RrxUZ7zXEgFtpfbL6NHbh1NpqV44Hc8RzgignoOehGUXEG5gNosbwzqrabmZAaNasFLRuSxVOx9h5qnmCnsdWOVkwg16kGbDeJ5YHtwntOYqwir1CJ2q8I00EzITM6oDZKOC3aLzb13RjbkGzZvmD9mTQra6qK2yM/xMjLNwStOj5Jxu5tNQubpqLsbkfqxo3bqH7fQQzXwSe/3yIvLrepAX7xKEeM7up/1VU/+2mo4z3svBpUEuS4u3fG2vvXbgSPVKoZJvfiQ8QSjGZmVPXItfB6kE8guuzjY7huBZcu+p2ceyt/C5ioOZPGwwUAKc+XM2pLrmVPDBix5TQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wHJ927n5/Tlkyc4Dn1XWas71JGvz2RR1BVqjdcB+b7I=;
 b=YHtqOTyIVifYZJHfllxuQ7p26gABnH45X90TsGioZjDqIIXVw2HgJE5a3Eh4UOnOz07S4iQvvucBALAH72MWB92Um9zvQH6UGFf19DoqgpV56YhFsh1gx1T27CBet+mQ+Jg0wyJItt5WOszYLYlTaEQ/MfMMkgc7KbwFAtvJ9Vs=
Received: from OSAPR01MB2385.jpnprd01.prod.outlook.com (2603:1096:603:37::20)
 by OSAPR01MB5106.jpnprd01.prod.outlook.com (2603:1096:604:6d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.18; Tue, 4 Aug
 2020 14:53:46 +0000
Received: from OSAPR01MB2385.jpnprd01.prod.outlook.com
 ([fe80::9dba:6049:dd66:3c70]) by OSAPR01MB2385.jpnprd01.prod.outlook.com
 ([fe80::9dba:6049:dd66:3c70%7]) with mapi id 15.20.3239.022; Tue, 4 Aug 2020
 14:53:46 +0000
From:   Chris Paterson <Chris.Paterson2@renesas.com>
To:     Pavel Machek <pavel@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux@roeck-us.net" <linux@roeck-us.net>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "patches@kernelci.org" <patches@kernelci.org>,
        "ben.hutchings@codethink.co.uk" <ben.hutchings@codethink.co.uk>,
        "lkft-triage@lists.linaro.org" <lkft-triage@lists.linaro.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH 4.19 00/56] 4.19.137-rc1 review
Thread-Topic: [PATCH 4.19 00/56] 4.19.137-rc1 review
Thread-Index: AQHWaZIw72+QhKs9zkSO6gQcXgjYTaknk46AgABzYWA=
Date:   Tue, 4 Aug 2020 14:53:45 +0000
Message-ID: <OSAPR01MB23857AEF0D818484DF9BAEF3B74A0@OSAPR01MB2385.jpnprd01.prod.outlook.com>
References: <20200803121850.306734207@linuxfoundation.org>
 <20200804074623.6nhrryvq46zi7qkv@duo.ucw.cz>
In-Reply-To: <20200804074623.6nhrryvq46zi7qkv@duo.ucw.cz>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=none action=none header.from=renesas.com;
x-originating-ip: [193.141.220.21]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 7a8f193e-04e5-4eae-1bda-08d838863054
x-ms-traffictypediagnostic: OSAPR01MB5106:
x-microsoft-antispam-prvs: <OSAPR01MB510631482CE14266F1636283B74A0@OSAPR01MB5106.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rKhuXft0vG65T66NmXunhMJFnZJCIAYRfjSuTRA4TI/0uRNOEnxKJhABpW1uf7rqaEF51PDlbrXUVbCrMP/mWYiLvqnNp4dWPQQldzib2KZR0KvswM8/+1SY6Uba31ivkEaY/9O1X8wNO8KThKqOKE91ksMlh9i+PCzAvXLGtp3p3ZJr9SWe/q6wRWykDYSBSBlFGM0FXAzOMuyfcwHVnLaBpORN4ZZHEUMPKWY1WWFsVEMdQ6KVmvFwmQ9vdMYIxYO5DiJ+s64ZMqjesSHZuEuf+4Yayl5DVGgbrPruAttDUlotlVoQiA0npB1FvmW4jnltS+eebdyX9i0PZGM55j2Ccx91gOzx8kEcQq1rFDGAr191a0bf7mq51OV58lF46SVSo0G35IM+IBw2UVcvOQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OSAPR01MB2385.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39850400004)(136003)(346002)(396003)(376002)(366004)(2906002)(186003)(6506007)(55016002)(83380400001)(71200400001)(26005)(9686003)(7696005)(33656002)(66446008)(86362001)(110136005)(54906003)(316002)(52536014)(7416002)(966005)(8676002)(64756008)(8936002)(76116006)(66556008)(5660300002)(66476007)(66946007)(478600001)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: ISVU1KI1nP0wx7nsJhHxRlDGRdwaj2IEC//dCVF6JYlaO06P/TifMYsWy4ytvQfZ9NaINHk55UFflLss0dSiASn/PFiZFlMfYoUEM0DqaRDRhjoiw6GJeubzQF4TbC6V/ilun7LB6V3MYge4tLjC4N8OA+Z2FENh5s9CPCFTXoxif9i0fGVaItmlncodoYLSNneWFJZ8wtzFIQIx5uWVYdc0y8OTETmsEGLEgdTzn6uVOKec7DVzBY9WJT6pnou5by+cTiL+rCAhQybONgGXxAGrCiZU1zdRpLvB/Zrb+x/4o9lAMhuLK8D7ow6scZwxSBFsiMyQfexh/NdvQ+lM6ro6lPNes+zt04DGPBA+UOErC7aE0zAycbgeKNrM1bL2Epk91+NLtMW3/BgpSPsRKoCgcJZBakYDxFEtuNxUceM1M0sOdOcrBpogBe1B+NfZKt2eupylzB77cpP9yQUFlFewHTaw/pYwHwFO7tSiOwIZ46VhM1q/a92lk/LEViPkkOseX5w9NmDd7ThrADlDrgWvsA3LXClzjO6pa59TWnFkf4a/J3XA/8D3kTxfOqOVHgOJp52Zj6XL+4on2C6h0mOQWs4D60bzw4wFFCc8Gq4CbMrCjeis5DOIuA1irROzmyz4fDNCChpbRXgWi9SMgg==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OSAPR01MB2385.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a8f193e-04e5-4eae-1bda-08d838863054
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Aug 2020 14:53:45.7848
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WpEFWx5KgMou0/GraGgfJ/Q9nHWSimlkBsJxPOeuSmS90Y+GUYs3e+4eMhNE46nLsxDEl6XtTj51aohZAk4ND2Lr4sirU5bt1YMIa6gwVN4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSAPR01MB5106
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Pavel,

> From: stable-owner@vger.kernel.org <stable-owner@vger.kernel.org> On
> Behalf Of Pavel Machek
> Sent: 04 August 2020 08:46
>
> *** gpg4o | The signature of this email could not be verified because the
> following public key is missing. Click here to search and import the key
> 30E7F06A95DBFAF2 ***
>
> Hi!
>
> > This is the start of the stable review cycle for the 4.19.137 release.
> > There are 56 patches in this series, all will be posted as a response
> > to this one.=A0 If anyone has any issues with these being applied, plea=
se
> > let me know.
> >
> > Responses should be made by Wed, 05 Aug 2020 12:18:33 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> > =A0=A0=A0 https://www.kernel.org/pub/linux/kernel/v4.x/stable-
> review/patch-4.19.137-rc1.gz
> > or in the git tree and branch at:
> > =A0=A0=A0 git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-
> rc.git linux-4.19.y
> > and the diffstat can be found below.
>
> CIP test farm does not see any problems...
>
> https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-
> /pipelines/173700523
>
> ...except that one of the targets is unavailable.

This is up again now so I've rescheduled the tests.

>
> Chris, could we get distinction between "we ran a test and it failed"
> and "we could not run a test because mice ate the cables"?

You can see that the board is offline in the GitLab CI log, but that's not =
ideal.
I can change it so the job passes with a nice big green tick, but this may =
lead people to think that the tests had actually been run.
Maybe we need a yellow icon in the GitLab GUI for this circumstance. Looks =
like we aren't the first with this request:
https://gitlab.com/gitlab-org/gitlab/-/issues/16733

Kind regards, Chris=20

>
> Best regards,
> =A0=A0=A0=A0=A0 =A0=A0=A0=A0=A0=A0=A0 =A0=A0=A0=A0=A0=A0=A0 =A0=A0=A0=A0=
=A0=A0=A0 =A0=A0=A0=A0=A0=A0=A0 =A0=A0=A0=A0=A0=A0=A0 =A0=A0=A0=A0=A0=A0=A0=
 =A0=A0=A0=A0=A0=A0=A0 =A0=A0=A0=A0=A0=A0=A0 Pavel
>
>
> --
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures)
> http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
