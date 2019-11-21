Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65CE41050E9
	for <lists+stable@lfdr.de>; Thu, 21 Nov 2019 11:58:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726170AbfKUK6c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Nov 2019 05:58:32 -0500
Received: from mail-eopbgr680092.outbound.protection.outlook.com ([40.107.68.92]:5895
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726014AbfKUK6c (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 21 Nov 2019 05:58:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WA93mWWvYXImfd6Gx60A6CAa7bNk83YXaRzX7NlLmg2l7HEgHuIEJ41nVgYM156tTXP6fAc0c+8AfMoVVSbMLReUqROtAjlqVHkcHuER0fY+jLE3KiZWdWhKXiVi2jCuIP4nNEC5/6mTdXJzVVRjoDJaVMR2mLDjByhrHHjXLDjBF20lAT6dhQA91Z8gAzWxb7GP8/KMfgQVoWkp4rstd+eqgJDJxF1R6evaguwxJiWG5X5vKjlJx20g0lHSucOHLb2r5hnIWR/G0vFaHoA9D7S0h2irz2qDuJOO2Q/a3mQcN3U3RRMWtx0m+W3YtnzsyZ7Lau1uRxOVgfw0zj3KdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5Rg8XJaK9/cm1ctHtB6MZZPw4qscz6Bs8q/5IEHcaC8=;
 b=nNHgkrNJVerR8dIox1cCOwzx1Qrpkrx3ayJT7T3pCL51Hfsp47WtvfEcAdLCJb5dmdcYFgbdxKiPNCvRNcwKJ7Mf/jIiNfVYVbNnqCICvPGOIbGbmMTK9qdqgYr8sRcK18Ae7D8ZELKPWnnNPuP2kHTh4wk6AB976raxW/d+hNjNr8xYkgib2Wqkf2syxUifiOZK7wdv7vZe9U0nQi5f0wC/cKviCaBnjCi6YsVihG+iPJWH+b1ACM52pDPjBciy3IyXA09XE1TuS5a32wLyfNa9+jzdaUrzILidz97MFCwywV0K4Fdh7JgIrliEf+Eu7zgbGmWll5+4JnborE4olg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 160.33.194.231) smtp.rcpttodomain=suse.cz smtp.mailfrom=sony.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=sony.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Sony.onmicrosoft.com;
 s=selector2-Sony-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5Rg8XJaK9/cm1ctHtB6MZZPw4qscz6Bs8q/5IEHcaC8=;
 b=fN2L3Q1wBQ0Ln7ME1dixnF8d2Q3VoFz6veiYk6Y85ztWFbEHY10v3YtIN0AHdTEsT2AXFUVLKcD9BsB+5KRpKeetfvhhJRuzn8FzZ5z2FZBh1/htP33C8xbMMJ5aBh1cGOquGrImd4DQ2pnQBAxbxN4+TtU/pv2vjXGFiWeZwtA=
Received: from DM5PR13CA0003.namprd13.prod.outlook.com (2603:10b6:3:23::13) by
 BN6PR13MB2914.namprd13.prod.outlook.com (2603:10b6:405:7c::36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.9; Thu, 21 Nov 2019 10:58:29 +0000
Received: from SN1NAM02FT023.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e44::202) by DM5PR13CA0003.outlook.office365.com
 (2603:10b6:3:23::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2495.10 via Frontend
 Transport; Thu, 21 Nov 2019 10:58:28 +0000
Authentication-Results: spf=pass (sender IP is 160.33.194.231)
 smtp.mailfrom=sony.com; suse.cz; dkim=none (message not signed)
 header.d=none;suse.cz; dmarc=pass action=none header.from=sony.com;
Received-SPF: Pass (protection.outlook.com: domain of sony.com designates
 160.33.194.231 as permitted sender) receiver=protection.outlook.com;
 client-ip=160.33.194.231; helo=usculsndmail04v.am.sony.com;
Received: from usculsndmail04v.am.sony.com (160.33.194.231) by
 SN1NAM02FT023.mail.protection.outlook.com (10.152.72.156) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.17 via Frontend Transport; Thu, 21 Nov 2019 10:58:28 +0000
Received: from usculsndmail12v.am.sony.com (usculsndmail12v.am.sony.com [146.215.230.103])
        by usculsndmail04v.am.sony.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id xALAwRKI006567;
        Thu, 21 Nov 2019 10:58:27 GMT
Received: from USCULXHUB06V.am.sony.com (usculxhub06v.am.sony.com [146.215.231.44])
        by usculsndmail12v.am.sony.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id xALAwQFF018642;
        Thu, 21 Nov 2019 10:58:26 GMT
Received: from USCULXMSG01.am.sony.com ([fe80::b09d:6cb6:665e:d1b5]) by
 USCULXHUB06V.am.sony.com ([146.215.231.44]) with mapi id 14.03.0439.000; Thu,
 21 Nov 2019 05:58:26 -0500
From:   <Tim.Bird@sony.com>
To:     <chrubis@suse.cz>, <rasibley@redhat.com>
CC:     <mm-qe@redhat.com>, <ltp@lists.linux.it>, <stable@vger.kernel.org>,
        <cki-project@redhat.com>
Subject: RE: [LTP] ??? FAIL: Test report for kernel 5.4.0-rc8-4b17a56.cki
 (stable-next)
Thread-Topic: [LTP] ??? FAIL: Test report for kernel 5.4.0-rc8-4b17a56.cki
 (stable-next)
Thread-Index: AQHVn5bAss4kT+6HcU6tK6ocLfZ+rKeUkwUAgAEeoAD//7x+cA==
Date:   Thu, 21 Nov 2019 10:58:04 +0000
Message-ID: <ECADFF3FD767C149AD96A924E7EA6EAF978BCF95@USCULXMSG01.am.sony.com>
References: <cki.6D94BD5731.3IAGHB25D8@redhat.com>
 <20191120113534.GC14963@rei.lan>
 <57f8e29e-1d49-e93f-2b03-75a3fd3e6e21@redhat.com>
 <20191121093150.GA14186@rei.lan>
In-Reply-To: <20191121093150.GA14186@rei.lan>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [146.215.228.6]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:160.33.194.231;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10019020)(346002)(136003)(396003)(39860400002)(376002)(51914003)(13464003)(189003)(199004)(97756001)(106002)(5660300002)(66066001)(54906003)(305945005)(110136005)(37786003)(316002)(55846006)(70206006)(33656002)(14444005)(47776003)(70586007)(336012)(2906002)(50466002)(478600001)(246002)(356004)(6666004)(229853002)(23726003)(2876002)(86362001)(26005)(46406003)(6116002)(8676002)(7736002)(6306002)(8746002)(3846002)(102836004)(8936002)(55016002)(11346002)(6246003)(446003)(426003)(4326008)(186003)(966005)(7696005)(76176011)(5001870100001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN6PR13MB2914;H:usculsndmail04v.am.sony.com;FPR:;SPF:Pass;LANG:en;PTR:mail04.sonyusa.com,mail.sonyusa.com;MX:1;A:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4c3b7e90-8d99-4bf7-60b9-08d76e71bd75
X-MS-TrafficTypeDiagnostic: BN6PR13MB2914:
X-MS-Exchange-PUrlCount: 2
X-Microsoft-Antispam-PRVS: <BN6PR13MB29140CB497F3AFDC13CB308DFD4E0@BN6PR13MB2914.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 0228DDDDD7
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TSOzbWHCcQ7DePXRTL1YV5oyyKV4FllhhlEaJlDrByNenb7HEFC5SV/8+4FU3WaF2QnjdISpn6ayLlUATBCLyVr+hyoRyF7mKs5zP+TzVGe/7YERWS0K8Vz7EJ/0+lHobR/E1FMeGtqdWqA89DlWGS55bVCxSL5hUFZ3C40elMRMdWZBDrJ7NzLiuHmmaSrR/+lbWGBky3e5otKgSXQkTnjZrf4/mrnbl2jZ0mWcqjSqeG4GElu8unRAu7bc8zPPTtR/dDny0SOqoCXbKtYpt3tm4LAYIedMHmPe1x4tvd8pfhN+Uux8kruGyF8iM05poxxMqWPV/wE2Wp/B4CTP67w0sfiaR+vHo8G07pBucX0e/y19DN7xpWluhr/ogJlL+GWbuNEt/PTF7ex3lVDZAQvKlbpXBsHGcXmgwLmVuFPA3cTrAQ4rxejpMkYXZMfUoCIVm8OEaElXKgDfC3mIsDQQ2ph5rSRIaqTBRTx0I1c=
X-OriginatorOrg: sony.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2019 10:58:28.3829
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c3b7e90-8d99-4bf7-60b9-08d76e71bd75
X-MS-Exchange-CrossTenant-Id: 66c65d8a-9158-4521-a2d8-664963db48e4
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=66c65d8a-9158-4521-a2d8-664963db48e4;Ip=[160.33.194.231];Helo=[usculsndmail04v.am.sony.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR13MB2914
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> -----Original Message-----
> From:  Cyril Hrubis
>=20
> Hi!
> > >> One or more kernel tests failed:
> > >>
> > >>      ppc64le:
> > >>       ??? LTP lite
> > >>       ??? xfstests: ext4
> > >
> > > Both logs shows missing files, that may be an infrastructure problem =
as
> > > well.
> > >
> > > Also can we include links to the logfiles here? Bonus points for show=
ing
> > > the snippet with the actual failure in the email as well. I takes a f=
air
> > > amount of time locating them manually in the pipeline repository, it
> > > would be much much easier just with the links to the right logfile...

My preference would be to include the failure snippet somewhere in
the e-mail as well (as opposed to just a link).

> > >
> >
> > Thanks for the feedback Cyril, we did have links to each failure listed
> > before but we were told it made the email look cluttered especially
> > if there are multiple failures.
>=20
> So it's exactly how Dmitry described it, you can't please everyone..,
>=20
> > The test logs are sorted by arch|host|TC, is there something we can
> > do to make it easier to find related logs ?
> > https://artifacts.cki-project.org/pipelines/296781/logs/
> >
> > Maybe we can look into adding the linked logs to the bottom of the
> > email with a reference id next to the failures in the summary, so
> > for example:
> >
> >      ppc64le:
> >       ??? LTP lite [1]
> >       ??? xfstests: ext4 [2]
>=20
> That would work for me.
>=20

Maybe combine the 'footnote' idea with the 'inline' idea, and have
the footnote include a link to the full log and a snippet with just the
output from the failing testcase, from the full log?

> > We could also look into merging the ltp run logs into a single file
> > as well.
>=20
> That would make it too big I guess. Actually the only part I'm
> interested in most of the time is the part of the log with the failing
> test. I would be quite happy if we had logs/failures file on the
> pipelines sever that would contain only failures extracted from
> different logfiles. The question is if that's feasible with your
> framework.

Fuego has an LTP log-splitter and link generator.
It's Fuego-specific and generates
files referred to by links in the result  tables that Fuego
shows to users.

I don't know how CKI is generating it's data or storing it,
but I can take a look and see if it could be applied
to their use case.  It's a python program that is fairly small.

See here:
https://bitbucket.org/fuegotest/fuego-core/src/master/tests/Functional.LTP/=
parser.py

It might not be applicable, depending on whether CKI stores their LTP outpu=
t similarly
to how Fuego does, but IMHO it's worth taking a look.  If there is sufficie=
nt interest,
maybe this could be generalized and submitted to upstream LTP.  The Fuego l=
og-splitter
produces individual files.

Another idea would be to write a program that takes an LTP log,
and the name of a failing testcase, and outputs (on stdout)  the snippet fr=
om the log
for that testcase.  I think this would be very easy to do, and might be sui=
table to
use in multiple contexts: on the command line, in a report
generator, or as a CGI script for a results server.
 -- Tim

