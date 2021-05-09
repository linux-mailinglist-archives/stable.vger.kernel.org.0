Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 689B637762E
	for <lists+stable@lfdr.de>; Sun,  9 May 2021 12:16:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbhEIKR3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 May 2021 06:17:29 -0400
Received: from mail-eopbgr1320101.outbound.protection.outlook.com ([40.107.132.101]:6127
        "EHLO APC01-PU1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229555AbhEIKR2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 May 2021 06:17:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iZP8U3QiypgzpoGHmjD0NHHBVO7j5Op8I1sorSHtLMuNamndhnVmFiuKIg7dts4ZH8pcT1UC4QIdV9xWC/zMUSH4Sap0ZXlWL18QE15CLHbKj7fSrZI8FLVty0ECzMgTMCENVHRi0Xo9A1rjUKlefDKjF+HDe0P4WcH7x9o4DafEijtTcFaX8JkaidD0Q0xhY2leBXWHF2w4DhqbeFRj5Gc9Z5eKnbsKFXgjGwD8KGLXk4knMOYFIPO7bKufEkKXLHDCQgwhLhdi17EnnU7KQ15xuJEMdOr/kip5Xrh62zpFor98cckgQlIFmjgt/onmXAGgK0JCwDsrpTXUzwly3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XyLZ3O2VmPnf6Zv5fUKXqQPBKM8eWFOg6qqH8CtrtOQ=;
 b=m4zMXJTeYWqBC6SMocF2WgQ+vC6NQMSDrXLAYSnWEDJpxIW7rXA547x3uC0uQgBYzL2SUhreX34nHpZ1T25AjCN089ZJoUZ4YjAFWfXKND0UWaU0BTlkaFpdQDA5dvl8y5OL6jOAt/qDlFmYLHBwgGlODLAwnSGxkSTKfAjVeRgBuqjpLzDlXAm/iZ9acKaBAcVlcBH37qbomoN0/uP23JNux9XU8bwcRie8spCJMVZ0B2mrjIYvwvJqWCPeaQd9gDrJ523FMPc9eBWbcHVzFhc9InGx2YKqg0d63OdugXIAsZsoN/SQ8JjbjXkmavGDX3DKZP+y8sL+Fn7GHYWFpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XyLZ3O2VmPnf6Zv5fUKXqQPBKM8eWFOg6qqH8CtrtOQ=;
 b=O/nxkWmi7scuA/G4xq5DMHe2KUJj5usS08Wy3GSXnL9OaBdP8ShIDJOXCYo8mdzH0JCCgHBoDpJ6IzYCCzJyGoaFaX49vkN3pcMAm8mB5PD2is0X2MaysC45ILGL7boZg1nfKt01sqef44PFqLIGlQOhZQ889coKYFOzrxwuhyg=
Received: from KL1P15301MB0343.APCP153.PROD.OUTLOOK.COM (2603:1096:820:17::13)
 by KL1P15301MB0053.APCP153.PROD.OUTLOOK.COM (2603:1096:802:10::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.6; Sun, 9 May
 2021 10:16:07 +0000
Received: from KL1P15301MB0343.APCP153.PROD.OUTLOOK.COM
 ([fe80::1161:67fd:6a15:d3df]) by KL1P15301MB0343.APCP153.PROD.OUTLOOK.COM
 ([fe80::1161:67fd:6a15:d3df%8]) with mapi id 15.20.4150.007; Sun, 9 May 2021
 10:16:07 +0000
From:   Shyam Prasad <Shyam.Prasad@microsoft.com>
To:     Salvatore Bonaccorso <carnil@debian.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paulo Alcantara <palcantara@suse.de>
CC:     pc <pc@cjr.nz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Aurelien Aptel <aaptel@suse.com>,
        Steven French <Steven.French@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: RE: [EXTERNAL] Re: [PATCH 4.19 013/247] cifs: Set
 CIFS_MOUNT_USE_PREFIX_PATH flag on setting cifs_sb->prepath.
Thread-Topic: [EXTERNAL] Re: [PATCH 4.19 013/247] cifs: Set
 CIFS_MOUNT_USE_PREFIX_PATH flag on setting cifs_sb->prepath.
Thread-Index: AQHXKtl3oEpPTTCadkuXKYVCCMdGI6qnf4aAgAACKFCAABQAgIAC7L2AgAYL/YCACbwcAIABHItwgADAs4CABC3psIABfRWAgBfx8ICAAVEjIA==
Date:   Sun, 9 May 2021 10:16:06 +0000
Message-ID: <KL1P15301MB0343C783FAA171868E45619C94559@KL1P15301MB0343.APCP153.PROD.OUTLOOK.COM>
References: <YGxlJXv/+IPaErUr@kroah.com>
 <PSAP153MB04220682838AC9D025414B6094769@PSAP153MB0422.APCP153.PROD.OUTLOOK.COM>
 <YGx3u01Wa/DDnjlV@eldamar.lan> <YG7r0UaivWZL762N@eldamar.lan>
 <YHP+XbVWfGv21EL1@kroah.com> <YHwo5prs4MbXEzER@eldamar.lan>
 <PSAP153MB04224202F4A2BE668533F94794499@PSAP153MB0422.APCP153.PROD.OUTLOOK.COM>
 <YH25PZn5Eb3qC6JA@eldamar.lan>
 <PSAP153MB04225D77E22AFC17C4AEA52E94469@PSAP153MB0422.APCP153.PROD.OUTLOOK.COM>
 <YIJ6a77TVaZGzQIg@kroah.com> <YJaQlVyFoUHyxHM/@eldamar.lan>
In-Reply-To: <YJaQlVyFoUHyxHM/@eldamar.lan>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-Mentions: palcantara@suse.de
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=4f46e4e0-aa1e-47a1-9f23-dc9a16026e67;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-05-09T09:29:08Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: debian.org; dkim=none (message not signed)
 header.d=none;debian.org; dmarc=none action=none header.from=microsoft.com;
x-originating-ip: [2404:f801:8028:3:60f4:ca47:5dfc:b1d0]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bd29c22d-2a23-4c56-78d1-08d912d375b0
x-ms-traffictypediagnostic: KL1P15301MB0053:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <KL1P15301MB00530754051C2676F4626E9B94559@KL1P15301MB0053.APCP153.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jsTHOt6Y1U6HXy4FoPpshG05jghuAnXq2ru3086ubAUejP8u0YMOraOskhJ1Y0m3pjFDDZF4Q2W/LXQ4q2YpZkPAbpO1w78GGXiiO18KpJYmPjQOjAGt+OJMEjG9PpQyR08JVG2tMRS3iAM5pEa0NxnWfZCeZ44E79BKZXjY7dFZiv/p8rAdeixOn58XkVlDQa/pJZg/oLnCm3mHuxuZyxW5W3hysx4dp5N4Q0vvfqt7GMCg0s/qyAWIuYd56YyTnEVOAy6ZG6qWi32EWX6yanen+3L6M2MVZCd8zNDhDHtOsTMajiVT84A1gGs3kdnfg94SFQiyDpEaC+jHq6FfknponJZfoBTh57JQakjgVG/SIyiV/tK3+nFcdeArbUD61MBsLnWlAT7ZlzO99SWk0iB7Wmp/XffL3G1kGyGnEVLWollzDsjSiNzndcVDpo6gYleJ05ga5iDG5k9wXhHR5m9OU4sWMAKpRthYWIYDUadyWhDPK0F2kFai6aUaLJYwzg64F4J/rZx6RB9T2lu8PGV8wRxCW4I8eADFLm2c+WM4QfTDdceGNLnTWnLO503S6rDrs6lyk9f256xB6j5bn9e6V26QhEKkYZsWX2OBuSsROo+Z6ufqxw17hNy+V6GAMCCn7daRjG3BHPmyj+a/rxFkK8FxRk3AlED04w/H4fCKST/uMhvbHRXRFbgovkQ+kqFZy8Q09r2xLyfAnwi8myHh0KCPE8SOL/iIKbZxD/I=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1P15301MB0343.APCP153.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(66946007)(5660300002)(86362001)(2906002)(8676002)(8990500004)(76116006)(71200400001)(186003)(52536014)(64756008)(66476007)(66446008)(966005)(33656002)(55016002)(82960400001)(53546011)(110136005)(316002)(6506007)(7696005)(478600001)(66616009)(82950400001)(66556008)(83380400001)(10290500003)(122000001)(9686003)(38100700002)(54906003)(4326008)(8936002)(99936003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?SZZODOuyAnOVkwR2NPz2/ZI4qpxW0u7puNuRJ34AL9JQWfzvZnhIfsAXa7DJ?=
 =?us-ascii?Q?52Yp7nbmVd0zRtQ8evb03zSQ13igvBpJGOzFPSUL/Y5PC/YngmSMMJm8OTMx?=
 =?us-ascii?Q?lbDcpEEnvSN1rmRDjye3/h7n5oh/By8TeJCGfccgBQBz9dyXU2Y0tNFG6/B0?=
 =?us-ascii?Q?d8Il2xtHa9oNZDFFmT75GvwcRsbu1pGOxyuyfoiiUNgIgh/ofLJYLxEfJmEA?=
 =?us-ascii?Q?eDgFCOBUECAEydUR9OCgg2x9s6TjZ8afoGzkCtYxaJ+aAd1pT9lbxXDMvAmC?=
 =?us-ascii?Q?nJttDrqrFD0zVGdENT0v2WNieIQP7wRKVA0LpZHeZKjqVFoadARUkwa05YI3?=
 =?us-ascii?Q?mTGlFrYOSQdsrhn5yUfew1erDm/IBrAMINNXpO5d8Ng544IGXFO0xmEsklON?=
 =?us-ascii?Q?PcA/pykhDHiuMafjq7iNac8mkmB+H1SSCsiFubqJOLrzoXAoCQAgW3Oimb1r?=
 =?us-ascii?Q?tZnV3YvOFjajZgujQG27jnhaJS3LZA5QVWjrZz+zOJCShPOfj+KZKd+Y6mX0?=
 =?us-ascii?Q?BvBB6SyVMWd0705ALEKwsedIEuM3HpBuW5r3gcssj5mEVQJlsDYKZOAAg/Ed?=
 =?us-ascii?Q?iyhC8N8FkbFvxdqc5qY/und3hcguFB2SSm44sxjbwPFWwBL6SVXEU/T2KzJE?=
 =?us-ascii?Q?lGUj9qxVcLREUKnz6FmLeQMj28aQWdh91iyhoiG4KcVeL075p2XTvqMjdqqO?=
 =?us-ascii?Q?CVjqkhTH/RHU00QZ09YEAep5g7fOkkKpmA3g6dmNdUhvtmYv4FjtY9n3M+6J?=
 =?us-ascii?Q?AhLT3pJnuBgTTOBQyVDiAcfhujH0LHbElcQMYULFZ67HfBggDJfjOgdisTAX?=
 =?us-ascii?Q?IFc6b77r7cmla3w9JsJMrU39JQKVfWydXsQuMVWKTMJYni50r5AJCOsAyxBp?=
 =?us-ascii?Q?ji8w6M7gygtQeH884F0U/CslDAjDk8dXrz9mFGvSLdGYYQ60hAlel/gRH4Wj?=
 =?us-ascii?Q?gqya/mYmDvzbKeO++83a0rheKFMrsWyBYhXLwXjX+BY64Fx0ZIumw2TNBZgz?=
 =?us-ascii?Q?gtO5ymad317QhZSpexyifUgdSLnUqM+g74ebKwDhj5W/dt82ygSW6wkwsmvG?=
 =?us-ascii?Q?+aAahl3OWXDQicLhxa650fj8Vx/q4oAhFgeIPv23sB8FgGDkYjWkIdO0UqZK?=
 =?us-ascii?Q?SzHRHR1VlaoPEKK+SP1msmmiboe10rtsH+tlVAk67pMtBMPY8+F9agdB27Pn?=
 =?us-ascii?Q?hH2FKpX1RyQcDK9g4B/GWUWtmQv0togzNuDE3QwpL/iRJ0pv4NJeXvjt3FBB?=
 =?us-ascii?Q?S+IvAWQbNjti2V2Faa59tWiI2pR6+K5Ng5tpBudSXmdySocxTYFnj821szkg?=
 =?us-ascii?Q?s3Q772BACeDYK1FMm9X0CHQ5zvi2tsOveUA7JSl2EkdoQH9eRD/4TK6q+IaS?=
 =?us-ascii?Q?PPKTOeg=3D?=
Content-Type: multipart/mixed;
        boundary="_002_KL1P15301MB0343C783FAA171868E45619C94559KL1P15301MB0343_"
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: KL1P15301MB0343.APCP153.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: bd29c22d-2a23-4c56-78d1-08d912d375b0
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 May 2021 10:16:06.8716
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2AyJLclQp3vprUIJ3vv6m7na0fUc8zXIzG2Uy3JWRFIuD+Kfn15muYbsK4yqljyhXkMW/QZ3MnUI1EWle53X1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1P15301MB0053
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--_002_KL1P15301MB0343C783FAA171868E45619C94559KL1P15301MB0343_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi Salvatore,

Thanks for reminding me. I had to do some reading to reply to this one.=20
The situation right now is this:
The patch "cifs: Set CIFS_MOUNT_USE_PREFIX_PATH flag on setting cifs_sb->pr=
epath." has been reverted. Which means that the DFS bug which you originall=
y faced will not be seen.=20

Hi Greg,

Here are the two patches which I'm referring to:
1. cifs: Set CIFS_MOUNT_USE_PREFIX_PATH flag on setting cifs_sb->prepath.
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?=
h=3Dv5.12&id=3Da738c93fb1c17e386a09304b517b1c6b2a6a5a8b
This fixed an issue when two cifs mount points shared a common prefix in th=
e path which they mounted from the same server. The patch was marked for CC=
:stable considering that this fix can be important for some users.
However, there was a dependent change for DFS scenario, which is present in=
 the Linus' mainline tree, but were not marked for CC:stable, so missing fr=
om the stable trees.
Due to the missing dependent changes, DFS users faced issues with pre-5.11 =
kernels, and this patch was reverted in the stable trees.

2. Due to a major change that went into the 5.11 kernel (the new mount API =
support), the code differs significantly, and the missing patch cannot be a=
pplied to pre-5.11 trees.
Hence, Paulo submitted the attached patch (cifs: fix prefix path in dfs mou=
nts), which fixes this for pre-5.11 kernels.

I was referring to these two patches to be applied to all stable trees. Sal=
vatore has verified that with both patches applied, the DFS scenario starts=
 working again.=20
@Paulo Alcantara Please add if I missed something here.=20

Regards,
Shyam

-----Original Message-----
From: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com> On Behalf Of Sa=
lvatore Bonaccorso
Sent: Saturday, May 8, 2021 6:52 PM
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Shyam Prasad <Shyam.Prasad@microsoft.com>; pc <pc@cjr.nz>; linux-kernel=
@vger.kernel.org; stable@vger.kernel.org; Aurelien Aptel <aaptel@suse.com>;=
 Steven French <Steven.French@microsoft.com>; Sasha Levin <sashal@kernel.or=
g>
Subject: Re: [EXTERNAL] Re: [PATCH 4.19 013/247] cifs: Set CIFS_MOUNT_USE_P=
REFIX_PATH flag on setting cifs_sb->prepath.

Shyam, Paulo,

On Fri, Apr 23, 2021 at 09:42:35AM +0200, Greg Kroah-Hartman wrote:
> On Thu, Apr 22, 2021 at 03:36:07PM +0000, Shyam Prasad wrote:
> > Hi Salvatore and Santiago,
> >=20
> > Thanks for testing this out.
> >=20
> > @Greg Kroah-Hartman: The reverted patch used in combination with Paulo'=
s fix seems to fix both use cases.=20
> > Can we have both these taken in on stable kernels? Paulo's patch is nee=
ded only for kernels 5.10 and older.
>=20
> I do not know what "both" is here at all.
>=20
> Please resubmit all of the needed commits in a format that I can apply=20
> them in, and I will be glad to review them and queue them up.
>=20
> Note, patches that are not in Linus's tree better be documented really=20
> really really really well for why that is not so...

Did you saw the ping from Greg? Otherwise I think the situation as it is no=
w for the older stable series is probably just as fine as it is now with th=
e repsective original commit reverted.

Regards,
Salvatore

--_002_KL1P15301MB0343C783FAA171868E45619C94559KL1P15301MB0343_
Content-Type: application/octet-stream;
	name="0001-cifs-fix-prefix-path-in-dfs-mounts.patch"
Content-Description: 0001-cifs-fix-prefix-path-in-dfs-mounts.patch
Content-Disposition: attachment;
	filename="0001-cifs-fix-prefix-path-in-dfs-mounts.patch"; size=1160;
	creation-date="Thu, 08 Apr 2021 16:43:48 GMT";
	modification-date="Thu, 08 Apr 2021 16:43:48 GMT"
Content-Transfer-Encoding: base64

RnJvbSBkMzhhM2MxNWQ4ZGQzNWNlNTVmYzEwZTVlZWJkNzIxOTcxODE3OWNmIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQ0KRnJvbTogUGF1bG8gQWxjYW50YXJhIDxwY0BjanIubno+DQpEYXRlOiBU
aHUsIDggQXByIDIwMjEgMTM6MzE6MDMgLTAzMDANClN1YmplY3Q6IFtQQVRDSCA0LjE5XSBjaWZz
OiBmaXggcHJlZml4IHBhdGggaW4gZGZzIG1vdW50cw0KDQpXaGVuIGNoYXNpbmcgZGZzIHJlZmVy
cmFscyB3ZSB1cGRhdGUgdGhlIHZvbHVtZSBpbmZvIGFjY29yZGluZ2x5IHNvIHdlDQpjYW4gYnVp
bGQgbmV3IGRmcyBmdWxsIHBhdGhzIGZyb20gdGhlbSwgYnV0IHdlIG1pc3NlZCB0byB1cGRhdGUg
dGhlDQpmaW5hbCBwcmVmaXggcGF0aCBpbiBzdXBlcmJsb2NrIHRoYXQgaXMgdXNlZCBpbiBtb3N0
IHBsYWNlcy4NCg0KU2lnbmVkLW9mZi1ieTogUGF1bG8gQWxjYW50YXJhIChTVVNFKSA8cGNAY2py
Lm56Pg0KLS0tDQogZnMvY2lmcy9jb25uZWN0LmMgfCAxMCArKysrKysrKysrDQogMSBmaWxlIGNo
YW5nZWQsIDEwIGluc2VydGlvbnMoKykNCg0KZGlmZiAtLWdpdCBhL2ZzL2NpZnMvY29ubmVjdC5j
IGIvZnMvY2lmcy9jb25uZWN0LmMNCmluZGV4IDYzMjI0OWNlNjFlYi4uZTM0MmFiOTRmNzlkIDEw
MDY0NA0KLS0tIGEvZnMvY2lmcy9jb25uZWN0LmMNCisrKyBiL2ZzL2NpZnMvY29ubmVjdC5jDQpA
QCAtNDI4Myw2ICs0MjgzLDE2IEBAIGNpZnNfbW91bnQoc3RydWN0IGNpZnNfc2JfaW5mbyAqY2lm
c19zYiwgc3RydWN0IHNtYl92b2wgKnZvbHVtZV9pbmZvKQ0KIAkJZ290byBtb3VudF9mYWlsX2No
ZWNrOw0KIAl9DQogDQorCWtmcmVlKGNpZnNfc2ItPnByZXBhdGgpOw0KKwljaWZzX3NiLT5wcmVw
YXRoID0gTlVMTDsNCisJaWYgKHZvbHVtZV9pbmZvLT5wcmVwYXRoKSB7DQorCQljaWZzX3NiLT5w
cmVwYXRoID0ga3N0cmR1cCh2b2x1bWVfaW5mby0+cHJlcGF0aCwgR0ZQX0tFUk5FTCk7DQorCQlp
ZiAoIWNpZnNfc2ItPnByZXBhdGgpIHsNCisJCQlyYyA9IC1FTk9NRU07DQorCQkJZ290byBtb3Vu
dF9mYWlsX2NoZWNrOw0KKwkJfQ0KKwl9DQorDQogCXRsaW5rLT50bF91aWQgPSBzZXMtPmxpbnV4
X3VpZDsNCiAJdGxpbmstPnRsX3Rjb24gPSB0Y29uOw0KIAl0bGluay0+dGxfdGltZSA9IGppZmZp
ZXM7DQotLSANCjIuMzAuMg0KDQo=

--_002_KL1P15301MB0343C783FAA171868E45619C94559KL1P15301MB0343_--
