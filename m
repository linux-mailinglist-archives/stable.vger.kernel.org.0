Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4236621584E
	for <lists+stable@lfdr.de>; Mon,  6 Jul 2020 15:28:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729085AbgGFN2N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jul 2020 09:28:13 -0400
Received: from mail-eopbgr700126.outbound.protection.outlook.com ([40.107.70.126]:59738
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728961AbgGFN2N (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 Jul 2020 09:28:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vpj/VvjQ3K55a0Kr6atVdJvN0B7oMFydYGQXbk2YWjnR1qj0owO1UNt7gnDaxFGmQXUHQgSiEMHTtKOG1aEldOa42y0ugGgkPt59hqKsbBtaCpEesmI0alVpWXThVbfZCbCUqgVKAA7Z5dC2C/zl5YrUzKR2jOAqcTFz4ltGGq3rq3ITGxWMOwsm84f3wL4dSuy2M8ZLnzw915rTnGTmdRFfx8Zwc5wiaWu0geAz9pqGh0xBgxeH04K/GTrxoO26pxvU02uqhrKiJGhbV3fRWSIenbfXBo24GGYhdZ3fBRFAiu9OPiHV072toULBn6RGN9XSQN9ocV/OCOLzJTFlvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kx091RnYERwEqNyMgCj9IXiKMlpILTpPwha6eC8UQJs=;
 b=gY+r8GONwDF2882UKUXm4Lx+IdmVWFR8JKqGytPr3qJmqrg6rlEIA+NczYTZichbsHwt/XbsCVyYTrbGq24U9EL4/8oMSQxZIvUCRwCh77yD9T13xp+B+QZTyorhiBMhMfEX23HDKV385ePTckQtVofx7Gjx9zYgIetmgzRKum+EHgsehDSKYQi5ousRqXG7DE4J4sBap1eyydShp1Aidm8YLPbgi7rTikTkR92XnX61Gzrq7QcOKoeULxIO+gyo4JcduaJe1z/LQnV1qAi0ZjFy5I5dO7GS0yyg6obgweXdsw0HixcEWEBJUe73mB+lHTD3vNaNoHiOatb8JFDgXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kx091RnYERwEqNyMgCj9IXiKMlpILTpPwha6eC8UQJs=;
 b=YVLcG618vikUEVqRxfLUaiAK+w28RMPz6bRS7SBLQCbTi3b406cfMihc7Tfv4iRodOBXv7AAO2PoTDOXulUzK0bKIVO3jUL5hXoX8YhE3hEoDD/t9em+OxMS4lQGyqnX0sq1vQpFNzHHt4OzwylQZQCzUMDUv+nDgpkEAU4B8yU=
Received: from MW2PR2101MB1052.namprd21.prod.outlook.com (2603:10b6:302:a::16)
 by MWHPR2101MB0730.namprd21.prod.outlook.com (2603:10b6:301:7f::39) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.1; Mon, 6 Jul
 2020 13:28:09 +0000
Received: from MW2PR2101MB1052.namprd21.prod.outlook.com
 ([fe80::fc14:3ca6:8a8:7407]) by MW2PR2101MB1052.namprd21.prod.outlook.com
 ([fe80::fc14:3ca6:8a8:7407%8]) with mapi id 15.20.3174.001; Mon, 6 Jul 2020
 13:28:09 +0000
From:   Michael Kelley <mikelley@microsoft.com>
To:     Wei Liu <wei.liu@kernel.org>, Sasha Levin <sashal@kernel.org>
CC:     Joseph Salisbury <Joseph.Salisbury@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH][v2] Drivers: hv: Change flag to write log level in panic
 msg to false
Thread-Topic: [PATCH][v2] Drivers: hv: Change flag to write log level in panic
 msg to false
Thread-Index: AQHWTAkXmuOBf0oGFkmi/qMqVkrGI6jzJOeAgAdLC4CAAChR4A==
Date:   Mon, 6 Jul 2020 13:28:09 +0000
Message-ID: <MW2PR2101MB10522E9B1B7DF946E3EBA4F5D7690@MW2PR2101MB1052.namprd21.prod.outlook.com>
References: <1593210497-114310-1-git-send-email-joseph.salisbury@microsoft.com>
 <20200701193326.12D69214DB@mail.kernel.org>
 <20200706105549.xum3y7hmviatil2w@liuwe-devbox-debian-v2>
In-Reply-To: <20200706105549.xum3y7hmviatil2w@liuwe-devbox-debian-v2>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-07-06T13:28:07Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=a673552d-20a0-4ba6-a328-7b38009e8fa1;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=microsoft.com;
x-originating-ip: [24.22.167.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c229922e-2ade-4ef0-2769-08d821b06ced
x-ms-traffictypediagnostic: MWHPR2101MB0730:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR2101MB0730E5A2C2B343550D8C2050D7690@MWHPR2101MB0730.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1417;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tyc8QSCKxX6qs5LWXuW6LrWyOL/90DJ3o80fvKFXI7RfmnjiN4A3Y7NAS5tmJjs+VeGm+LBqgcEqzdsvfVdQeFkimdbm29L7Zb+1991TzvVRVw3jjPtZ77dkHHo+/3xfHai0CM0jFcPa24OZ283DALlEleakgDxer4lhrCxs1bQjecUstI/TlMjdE2EWc4HDaIsLLs9+0on5RuzkE6uqW2irREZNxLjL2dJseZzgRH1Dq5aaf1fB1RdOEJNVWUi4Txxr/+dAKgVimOjv6P46GMaJzHFFkaRN368oerjwKLVBB05VtOfpdWeZbhHqIteiTe6kHsCVO/J5sjKOh0JOhg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR2101MB1052.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(376002)(136003)(366004)(346002)(39860400002)(33656002)(55016002)(9686003)(2906002)(110136005)(54906003)(186003)(316002)(66446008)(6506007)(66946007)(26005)(76116006)(64756008)(66476007)(66556008)(86362001)(7696005)(8936002)(8676002)(5660300002)(4326008)(52536014)(8990500004)(10290500003)(71200400001)(478600001)(83380400001)(82960400001)(82950400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: RRf3LMT4vZSI3oPrlVDKl5OntSnKO7qzQOA7i36UwutA2NCMF13Sf+OGcqqamaDdKMJF8aDFYiawIH54vYnzvJ/Vpm7Pm4jVLPTbwdGKiVk06Ea/gAqQKiG4VgdFzwVo1h22FGV+z60Uc6X2tOtzUriFAS8OQhf4CmYQBmQi46/vrRJFGdgMCAxA7JuMUQw5t2Nnfoh1B8UUIOGuiMxkaDpTFhRkt3O7E3vKr4WfVyi2BHjmjeegsKaH4NL90k1JAchJX6AzEq9qvYptfPiXfuo5YUY4jQ0M4iKucWFoRX+jwUgSiEkE7d3ax5JVo67So6Yppw+voIx0JaLdkkgJo5304ht3Ce9Pdjkc0JmCUonjJiruXT1cpua2YsIK2mkH035txYvFyzygDpi6HZ7OavOcZQmKg51tPMTygejxHaYeeyDt9GqT9+Ca0XV4TSQPNGRBsWhvQNVBpRWv8G1/euNLDUWwXGsco4CIgA9Ll5s=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR2101MB1052.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c229922e-2ade-4ef0-2769-08d821b06ced
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jul 2020 13:28:09.7247
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RBo3iVuR30aV5VoYIWYBt8ZOvVbp+CZ+MHzFyDupWkgYqwBSsq32kQ2QdCq7bnWjV4aqwyRtje6uBODan6Cjpmw0sbbdGG/vxL8HWktPLIw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR2101MB0730
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Liu <wei.liu@kernel.org> Sent: Monday, July 6, 2020 3:56 AM
>=20
> On Wed, Jul 01, 2020 at 07:33:25PM +0000, Sasha Levin wrote:
> > Hi
> >
> > [This is an automated email]
> >
> > This commit has been processed because it contains a -stable tag.
> > The stable tag indicates that it's relevant for the following trees: al=
l
> >
> > The bot has tested the following trees: v5.7.6, v5.4.49, v4.19.130, v4.=
14.186, v4.9.228,
> v4.4.228.
> >
> > v5.7.6: Build OK!
> > v5.4.49: Failed to apply! Possible dependencies:
> >     53edce00ceb74 ("Drivers: hv: vmbus: Remove dependencies on guest pa=
ge size")
>=20
> Unrelated, shouldn't be backported.
>=20
> >
> > v4.19.130: Failed to apply! Possible dependencies:
> >     53edce00ceb74 ("Drivers: hv: vmbus: Remove dependencies on guest pa=
ge size")
> >
>=20
> Unrelated, shouldn't be backported.
>=20
> > v4.14.186: Failed to apply! Possible dependencies:
> >     4a5f3cde4d51c ("Drivers: hv: vmbus: Remove x86-isms from arch indep=
endent drivers")
> >     53edce00ceb74 ("Drivers: hv: vmbus: Remove dependencies on guest pa=
ge size")
> >     7ed4325a44ea5 ("Drivers: hv: vmbus: Make panic reporting to be more=
 useful")
> >     81b18bce48af3 ("Drivers: HV: Send one page worth of kmsg dump over =
Hyper-V during
> panic")
> >     8afc06dd75c06 ("Drivers: hv: vmbus: Fix the issue with freeing up h=
v_ctl_table_hdr")
> >     ddcaf3ca4c3c8 ("Drivers: hv: vmus: Fix the check for return value f=
rom kmsg get dump
> buffer")
> >
> > v4.9.228: Failed to apply! Possible dependencies:
> >     4a5f3cde4d51c ("Drivers: hv: vmbus: Remove x86-isms from arch indep=
endent drivers")
> >     6ab42a66d2cc1 ("Drivers: hv: vmbus: Move Hypercall invocation code =
out of common
> code")
> >     73638cddaad86 ("Drivers: hv: vmbus: Move the check for hypercall pa=
ge setup")
> >     76d36ab798204 ("hv: switch to cpuhp state machine for synic init/cl=
eanup")
> >     81b18bce48af3 ("Drivers: HV: Send one page worth of kmsg dump over =
Hyper-V during
> panic")
> >     8730046c1498e ("Drivers: hv vmbus: Move Hypercall page setup out of=
 common code")
> >     d058fa7e98ff0 ("Drivers: hv: vmbus: Move the crash notification fun=
ction")
> >
> > v4.4.228: Failed to apply! Possible dependencies:
> >     4a5f3cde4d51c ("Drivers: hv: vmbus: Remove x86-isms from arch indep=
endent drivers")
> >     619848bd07434 ("drivers:hv: Export a function that maps Linux CPU n=
um onto Hyper-V
> proc num")
> >     6ab42a66d2cc1 ("Drivers: hv: vmbus: Move Hypercall invocation code =
out of common
> code")
> >     73638cddaad86 ("Drivers: hv: vmbus: Move the check for hypercall pa=
ge setup")
> >     75ff3a8a9168d ("Drivers: hv: vmbus: avoid wait_for_completion() on =
crash")
> >     76d36ab798204 ("hv: switch to cpuhp state machine for synic init/cl=
eanup")
> >     81b18bce48af3 ("Drivers: HV: Send one page worth of kmsg dump over =
Hyper-V during
> panic")
> >     8730046c1498e ("Drivers: hv vmbus: Move Hypercall page setup out of=
 common code")
> >     a108393dbf764 ("drivers:hv: Export the API to invoke a hypercall on=
 Hyper-V")
> >     d058fa7e98ff0 ("Drivers: hv: vmbus: Move the crash notification fun=
ction")
>=20
> Just from reading the subject lines it seems to me a lot of the possible
> dependencies aren't really related to this patch functionally. It could
> be that they are touching the same area of code which create some
> contextual dependencies. Some of the listed dependencies should
> definitively _not_ be backported.
>=20
> Michael and Joseph, how far do you want this to be backported? It may be
> easier for us to provide bespoke versions of this patch to the stable
> trees we care about?
>=20

The code being changed was added in 4.19, so that's the earliest kernel ver=
sion
to which it makes sense to backport.  53edce00ceb74 is an unrelated change
to the same line of code (changes PAGE_SIZE to HV_HYP_PAGE_SIZE), so a besp=
oke
version of this patch is needed for the stable trees.  All-in-all, this pat=
ch is a modest
optimization, so backporting is nice but not required.

Michael
