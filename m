Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D17C363B1E
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 07:48:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231580AbhDSFtD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 01:49:03 -0400
Received: from mail-eopbgr1320134.outbound.protection.outlook.com ([40.107.132.134]:28352
        "EHLO APC01-PU1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230392AbhDSFtB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 01:49:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nd6GARWKDvUKPAS8yDhOQ1sWdYLXWPzDE3uFkg7ulK4kN05/2amOfVABAcKnn1LF7KoCBOOH/yX4IIuKPxwGkaVXsznMgp8NoyBX9Tc6p806sIX6KnSe7f3DhirHXkghH/JxzanRPrp35DiehS0/GLwcJ8YRK01O42i2Z4BIDqhCkHKY6gbMF8YXAVUoUP6lEha0pgM+9B5ObVuy85o16H9nfnn4YJtcDe7QY7BdJyaA818B63+w/iIP+ukcRHcklXOKADJvN9hX8jPS0Vz4VYecIX2UOzOHp5xuIyBWuAkUTjHUUcpRRyXqRftLCdwcWfqRuFKDw9N5aSV6IFKsTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L7+kh6l0Yo+dsntqsdx3k78syuLWKUN/oU509Ycoyzs=;
 b=MCauyaceMdFAFIezX/IPspUhSICKa0+eYIKAWWtRrUGLfeahRqB57dW5wZ4sPmok10OIuUcLgnbPvHJvo4JnYYXoH0hPl7Skb5q7OLoKQdgvIRKc451mSrdy9uxCO9RYzAQ69MOJ2Gw8kgGO0v+Xw9Ddp/3MGJFEiREiu2+GpK8njTdOczmvKmWGZdcwZMkoYmgAP8cMHiHT9jrZxLzMLFEFTRF2PbwR0U6maJ0AC771b/3pPyH2yB9jGFE+dOEGL4ulZqPHzLaSQQBCaml+F4n/tx4ff5n5zo7Otf85x4iA/XfVQVMJgKl08WPfJTzSiFVMRS3ZxL6cwWXuKw3HkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L7+kh6l0Yo+dsntqsdx3k78syuLWKUN/oU509Ycoyzs=;
 b=R3ZfVRgUZn29Qy8k8kFOC6QQ0J4jlvIK8Igpei2auv9A4hnzV2M1Kbi298XdjLwWnDppQqhvziq19WS10JSzzjNBioLar26OtwE77gt2vvLzwp+P0P3tpiathW80evNi8R+/x8VsN4e7la/0QW6XDu+CMKQ5nQnCRVMTSIaFi10=
Received: from PSAP153MB0422.APCP153.PROD.OUTLOOK.COM (2603:1096:301:38::12)
 by PSAP153MB0407.APCP153.PROD.OUTLOOK.COM (2603:1096:301:3f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.11; Mon, 19 Apr
 2021 05:48:24 +0000
Received: from PSAP153MB0422.APCP153.PROD.OUTLOOK.COM
 ([fe80::9921:b743:c0db:6f50]) by PSAP153MB0422.APCP153.PROD.OUTLOOK.COM
 ([fe80::9921:b743:c0db:6f50%7]) with mapi id 15.20.4087.012; Mon, 19 Apr 2021
 05:48:24 +0000
From:   Shyam Prasad <Shyam.Prasad@microsoft.com>
To:     Salvatore Bonaccorso <carnil@debian.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, pc <pc@cjr.nz>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Aurelien Aptel <aaptel@suse.com>,
        Steven French <Steven.French@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: RE: [EXTERNAL] Re: [PATCH 4.19 013/247] cifs: Set
 CIFS_MOUNT_USE_PREFIX_PATH flag on setting cifs_sb->prepath.
Thread-Topic: [EXTERNAL] Re: [PATCH 4.19 013/247] cifs: Set
 CIFS_MOUNT_USE_PREFIX_PATH flag on setting cifs_sb->prepath.
Thread-Index: AQHXKtl3oEpPTTCadkuXKYVCCMdGI6qnf4aAgAACKFCAABQAgIAC7L2AgAYL/YCACbwcAIABHItw
Date:   Mon, 19 Apr 2021 05:48:24 +0000
Message-ID: <PSAP153MB04224202F4A2BE668533F94794499@PSAP153MB0422.APCP153.PROD.OUTLOOK.COM>
References: <20210301161031.684018251@linuxfoundation.org>
 <20210301161032.337414143@linuxfoundation.org> <YGxIMCsclG4E1/ck@eldamar.lan>
 <YGxlJXv/+IPaErUr@kroah.com>
 <PSAP153MB04220682838AC9D025414B6094769@PSAP153MB0422.APCP153.PROD.OUTLOOK.COM>
 <YGx3u01Wa/DDnjlV@eldamar.lan> <YG7r0UaivWZL762N@eldamar.lan>
 <YHP+XbVWfGv21EL1@kroah.com> <YHwo5prs4MbXEzER@eldamar.lan>
In-Reply-To: <YHwo5prs4MbXEzER@eldamar.lan>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=6df48b93-0723-4cf2-9ac6-1b3cbb76401a;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-04-19T05:39:35Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: debian.org; dkim=none (message not signed)
 header.d=none;debian.org; dmarc=none action=none header.from=microsoft.com;
x-originating-ip: [2404:f801:8028:1:60f6:ca47:5dfc:b1d0]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f84c6797-c648-44f6-5e02-08d902f6bf96
x-ms-traffictypediagnostic: PSAP153MB0407:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <PSAP153MB040785316889D3DC44B32B8494499@PSAP153MB0407.APCP153.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GZaHumfdkedpU9B645zgClgIQ9cwuvsytK+8pqkWekfGCNEmbJzKErjqwTbGxxtAq+rYvPOFgERC5zKgiWp5jQd+p9J6zQP1pP5ZAMOfy+ZTUd8fA6HEvHghefFsstvWLCMpYDqUOYuuTNz1gw5hi7bVFG7WE5t4odF/6C4yiznv1dSaS80Z0cx9N9L79VJ8XmGfViwdKzbiXry7CnV+Hd26MhIy3Ae98h9H0KFlcKMWQ7c6WhLT2ahYiV/gogiJtOESRnbJF1X/XBaO9nFvQuxkWIKpqfbJsLVR7b3xyhCGhgo9lVE2AEAxFjynpuAgaARWHoO9zuStaXq/jCPPy2d7xHtQoOv2ajWTsKRRfq+r4qFyTDFSgrImgjG3Q4QcEBKaMg8f4KdBf/OKJTfjqZHTAPHCvsnNe0u3eeFk7/777RRHWCGuihNOYiCgc/a10CHJitjJQf6GI35ku+mfchWhYarEKvo15PS8gwugUQTmTT/Cic0jOoZ1tFKOyniabNTJA2CuYuB9xCNPxf3TDsCibe8kzE+ajFLMieO4b/tVVfKANAK/yaCQZYXZI+Ci8gxMineXwzdwdIN9PWAhtIX7x1bhFpp28rVLuk0Ezn4nsSpcL8iA2fsmmSyUY6s2XNF8m1cH2W0cJFEMslNwheDPwH3+zCox2TZzAEbUqHFQFfzaAH8vjTEbZGMjkYVA
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAP153MB0422.APCP153.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(396003)(39860400002)(376002)(366004)(10290500003)(8936002)(2906002)(316002)(52536014)(8676002)(99936003)(4326008)(8990500004)(5660300002)(55016002)(7696005)(9686003)(82950400001)(53546011)(82960400001)(83380400001)(38100700002)(186003)(16799955002)(122000001)(6506007)(966005)(76116006)(71200400001)(66946007)(64756008)(66446008)(66556008)(66476007)(66616009)(33656002)(478600001)(86362001)(110136005)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?b7TuwWg9lMyxC7Mk1rd88PB/fiyZQglBLeG4jp69/Qhwc0YCtWbKAg1cEKdq?=
 =?us-ascii?Q?cUOfZ0+X4OUbLztZJXJK2yY0bI+LdNQiqAkP/34kd5HFCfl5OF2PK+1u1s05?=
 =?us-ascii?Q?pMjssXLxIRGCHiuvStx5W/4sZpQf7ODC7N4Dag/h9gC0xBYnigZiYxDTyllq?=
 =?us-ascii?Q?oia8ePWITGkFn+eMF/d7m3rTilDAler5TApiIP16gcdgWNcnEfQCL++4CN6P?=
 =?us-ascii?Q?2kYLAAuUDQxn+OwNXgKnORlNkNExcaIwsZw52Ci7/dtiUerci+TRBMyi+a7y?=
 =?us-ascii?Q?a5zucjnNSTnouuxb8aQvaiUPBQr+Fn6rQNMhx1nCY/JzHNUpmkNX4xTZBKDK?=
 =?us-ascii?Q?nA/IWvm1uRPUO8sif2EaBNh0MT/5aqbwQUUP1D/wkXKNglPgTLcPdpF+tkz0?=
 =?us-ascii?Q?v6jeXpgBNhsf9PPzmrm80C9pmW89JwU9kTicm+Vw4NW0ymd8IBhhhlCTUaRs?=
 =?us-ascii?Q?OHf95dryzBI0pmmPVg3OBnkPQjiiLCwDOG9SrzkmheAuujyv6XDA+9BVj4gW?=
 =?us-ascii?Q?Fd5q4wsz81mjjCuleZe1mxNbjkMOv/7GC3daBdxzP0WNRBorBKjYtvAXZBpe?=
 =?us-ascii?Q?x4LU0BQvjIKsXcStPjTTs4VySGiez/xpVM2O50rh61IwBLpxdU/2OsPTSmKf?=
 =?us-ascii?Q?BDdK8LDR09IqFiODxoCbCPaFGpOlGOo8j7wU628lIc0C5ZMv5MASGUWySkDE?=
 =?us-ascii?Q?thmv5DAJ+2nfqS2tAgRz5LajwZRNtoCaw6GpFJiFGHdFPy9K/2N7xYwtJ2zZ?=
 =?us-ascii?Q?CXgyYbKnfKsi/TLM6lPyD6fEJnc232R7LOp6mBS2Z9VRVeU4gfYzV2ev5/AT?=
 =?us-ascii?Q?yFVD3guTAZqGvFn+YLFCUQSdFfvSGWzTZFeHVeTIZ2SAeny+pajJ04fu6+vA?=
 =?us-ascii?Q?9LUr57VApEMWsQxcjZPYFE35/2IUpH7Qd9ZLr4Orn8udPI4mgmCN0hZ9odxn?=
 =?us-ascii?Q?ZvKfYGjYWPOix+/Q0slX/OnaVRTGhKjl/rZP73sMfQJoFZwI4WwJHKsy+rd4?=
 =?us-ascii?Q?QY2qANb8ohCJxxEBaLZH+I53d4RfHvDxu89zRUmKNj2AOnaezxv3namR3ba+?=
 =?us-ascii?Q?6CLBfSB1APPAGS2sndRcL5svC0YT/xhSy9Ks7eigMSLNZTBRvIA46mXAw4HA?=
 =?us-ascii?Q?5mRjKbloGBjGSSvCj4Cqndjb2ZRFhR2WJv6B4GbwARqsxMzZxFhnV4HJ9tQF?=
 =?us-ascii?Q?JHLnjeM9st+AXr+JP0VPEVHioF5Z5nTjnQUX1VGElaliNH1G93NQDd26Ms3g?=
 =?us-ascii?Q?3mSJDrSbQmEuVjZZNPlE+zneHwdTWXgaP2x1Mjr2QsblOowZxw+fzAFAt8Hf?=
 =?us-ascii?Q?Wjs6tchUbLtmqwaXk5ORJ9t4GLsWNUbtuCuME7GbSkQ0YL2tomV36OSZvnqk?=
 =?us-ascii?Q?EGwAf/M=3D?=
Content-Type: multipart/mixed;
        boundary="_002_PSAP153MB04224202F4A2BE668533F94794499PSAP153MB0422APCP_"
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAP153MB0422.APCP153.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: f84c6797-c648-44f6-5e02-08d902f6bf96
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Apr 2021 05:48:24.6520
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /6Rd4cgRqTauJvKc7HEWQwKCYNWf0ktVzbklV6dWtGXiPTBLziTalBC8xhy281beaXbBbkz5QX/Au9IiT79dQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PSAP153MB0407
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--_002_PSAP153MB04224202F4A2BE668533F94794499PSAP153MB0422APCP_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<Including Paulo in this email thread>

Hi Salvatore,

Attached is a proposed fix from Paulo for older kernels.=20
Can you please confirm that this works for you too?=20

Regards,
Shyam

-----Original Message-----
From: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com> On Behalf Of Sa=
lvatore Bonaccorso
Sent: Sunday, April 18, 2021 6:11 PM
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Shyam Prasad <Shyam.Prasad@microsoft.com>; linux-kernel@vger.kernel.org=
; stable@vger.kernel.org; Aurelien Aptel <aaptel@suse.com>; Steven French <=
Steven.French@microsoft.com>; Sasha Levin <sashal@kernel.org>
Subject: Re: [EXTERNAL] Re: [PATCH 4.19 013/247] cifs: Set CIFS_MOUNT_USE_P=
REFIX_PATH flag on setting cifs_sb->prepath.

Hi Greg,

On Mon, Apr 12, 2021 at 10:01:33AM +0200, Greg Kroah-Hartman wrote:
> On Thu, Apr 08, 2021 at 01:41:05PM +0200, Salvatore Bonaccorso wrote:
> > Hi Shyam,
> >=20
> > On Tue, Apr 06, 2021 at 05:01:17PM +0200, Salvatore Bonaccorso wrote:
> > > Hi,
> > >=20
> > > On Tue, Apr 06, 2021 at 02:00:48PM +0000, Shyam Prasad wrote:
> > > > Hi Greg,
> > > > We'll need to debug this further to understand what's going on.=20
> > >=20
> > > Greg asked it the same happens with 5.4 as well, I do not know I=20
> > > was not able to test 5.4.y (yet) but only 5.10.y and 4.19.y.
> > > >=20
> > > > Hi Salvatore,
> > > > Any chance that you'll be able to provide us the cifsFYI logs from =
the time of mount failure?
> > > > https://nam06.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%
> > > > 2Fwiki.samba.org%2Findex.php%2FLinuxCIFS_troubleshooting%23Enabl
> > > > ing_Debugging&amp;data=3D04%7C01%7CShyam.Prasad%40microsoft.com%7C
> > > > 3f7f5a39dd974cacf6aa08d902674040%7C72f988bf86f141af91ab2d7cd011d
> > > > b47%7C1%7C0%7C637543465194151840%7CUnknown%7CTWFpbGZsb3d8eyJWIjo
> > > > iMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C10
> > > > 00&amp;sdata=3DnH2tcSzqFzzqLZ2RIARR008%2FuvBEdDHEnjKpVXhzIdk%3D&am
> > > > p;reserved=3D0
> > >=20
> > > Please find it attached. Is this enough information?
> > >=20
> > > The mentioned home DFS link 'home' is a DFS link to=20
> > > msdfs:SECONDHOST\REDACTED on a Samba host.
> > >=20
> > > The mount is triggered as
> > >=20
> > > mount -t cifs //HOSTIP/REDACTED/home /mnt --verbose -o username=3D'RE=
DACTED,domain=3DDOMAIN'
> >=20
> > So I can confirm the issue is both present in 4.19.185 and 5.4.110=20
> > upstream (without any Debian patches applied, we do not anyway apply=20
> > any cifs related one on top of the respetive upstream version).
> >=20
> > The issue is not present in 5.10.28.
> >=20
> > So I think there are commits as dependency of a738c93fb1c1 ("cifs:=20
> > Set CIFS_MOUNT_USE_PREFIX_PATH flag on setting cifs_sb->prepath.")=20
> > which are required and not applied in the released before 5.10.y=20
> > which make introducing the regression.
>=20
> Ok, I've dropped this from 5.4 and older kernel trees now, thanks for=20
> the report.

Thanks Greg! Shyam, Steven, now the commit was reverted for the older brnac=
hes. But did you got a chance to find why it breaks for the older series?

Regards,
Salvatore

--_002_PSAP153MB04224202F4A2BE668533F94794499PSAP153MB0422APCP_
Content-Type: application/octet-stream;
	name="0001-cifs-fix-prefix-path-in-dfs-mounts.patch"
Content-Description: 0001-cifs-fix-prefix-path-in-dfs-mounts.patch
Content-Disposition: attachment;
	filename="0001-cifs-fix-prefix-path-in-dfs-mounts.patch"; size=1160;
	creation-date="Mon, 19 Apr 2021 05:42:29 GMT";
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

--_002_PSAP153MB04224202F4A2BE668533F94794499PSAP153MB0422APCP_--
