Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E87B3555E7
	for <lists+stable@lfdr.de>; Tue,  6 Apr 2021 16:00:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344841AbhDFOBE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Apr 2021 10:01:04 -0400
Received: from mail-eopbgr1300108.outbound.protection.outlook.com ([40.107.130.108]:19936
        "EHLO APC01-HK2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234998AbhDFOBD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Apr 2021 10:01:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M2APMvKO0U2g3/ZI6sFcfTwHgPQ1U7VTjtX+XtgfV6+UmQJW5A2XWjFlUSNv255eDCyCYEV22Uj8O2KrV5gcMWKjpXxLDgqhVCQOin9VExRw9C+Uk/byyzGnYj94hRWjbxf83sfNxPl8e5ytdCmQOyvWdAIOlkMfx+ijxs+IpaUcclTQwMvEfaueWAJX1kM2xIBMLNfqpCy7sWWuFJ9S6Zqc3VN85OKvVzW8Ve/6z3VzJlUSkkCd6EbQr+JuEzU02eupHEIICdBVgpC5eC0w+LwUlLrzR9nSkIOL/Pz9l5vc42k2PMhBeYmsS2xub7YmEAY+wS1ddFksmLEg4hVjqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GWtMwK0Bxz6yBz0RrfLhAmLhNXLNekVbNq0Ueh82sAM=;
 b=kD0YTWqPdXs9IyTCYg912VMaZIfA6gdKQvoncILjZU1spIhHu3YjxGgN6t1SpCGJvK/oQeMTbFFitkKthVNkojZUT6iQe/xJ4ebRwiLkTHDbKvfZH2txJeQSzDiZcURqlSxmOqoZmRVvfWTbASZyDjbjyCunNeXCSXlEg/iAUTEL7eO0w9i97SxqFb4tShSC580cNVLcHEAwWjeNsLuIfZq9ZGr27h1N3sysAi0ew7v836rf4LeTMNnreLGg2kuyIh17dcqCtniNvSqdsQt79rOnwkv46mN9V1305elXhhUYrSLRY1REZ7XwuQK6yl5KtMFzhVADdSTCjVHQZaVylw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GWtMwK0Bxz6yBz0RrfLhAmLhNXLNekVbNq0Ueh82sAM=;
 b=Qp7rsHnK+huyoiSEkOY6Bop9DW+L+L/hAglBeWwqRr5+xdH6JLTk583kw+W2L3h9jIDHpIigwZs8XTAaloQaZi67SYmyeUYZi+vb5xzdw0r3J9Xd+VN+nSjHdM8UEhVDjfm0Q26GgNaiOGuBwrtlBXFDMy1wKjmmZB3MW3DlwY0=
Received: from PSAP153MB0422.APCP153.PROD.OUTLOOK.COM (2603:1096:301:38::12)
 by PSAP153MB0407.APCP153.PROD.OUTLOOK.COM (2603:1096:301:3f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.4; Tue, 6 Apr
 2021 14:00:48 +0000
Received: from PSAP153MB0422.APCP153.PROD.OUTLOOK.COM
 ([fe80::24d9:ce8b:8c06:2299]) by PSAP153MB0422.APCP153.PROD.OUTLOOK.COM
 ([fe80::24d9:ce8b:8c06:2299%8]) with mapi id 15.20.4042.004; Tue, 6 Apr 2021
 14:00:48 +0000
From:   Shyam Prasad <Shyam.Prasad@microsoft.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Salvatore Bonaccorso <carnil@debian.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Aurelien Aptel <aaptel@suse.com>,
        Steven French <Steven.French@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: RE: [EXTERNAL] Re: [PATCH 4.19 013/247] cifs: Set
 CIFS_MOUNT_USE_PREFIX_PATH flag on setting cifs_sb->prepath.
Thread-Topic: [EXTERNAL] Re: [PATCH 4.19 013/247] cifs: Set
 CIFS_MOUNT_USE_PREFIX_PATH flag on setting cifs_sb->prepath.
Thread-Index: AQHXKtl3oEpPTTCadkuXKYVCCMdGI6qnf4aAgAACKFA=
Date:   Tue, 6 Apr 2021 14:00:48 +0000
Message-ID: <PSAP153MB04220682838AC9D025414B6094769@PSAP153MB0422.APCP153.PROD.OUTLOOK.COM>
References: <20210301161031.684018251@linuxfoundation.org>
 <20210301161032.337414143@linuxfoundation.org> <YGxIMCsclG4E1/ck@eldamar.lan>
 <YGxlJXv/+IPaErUr@kroah.com>
In-Reply-To: <YGxlJXv/+IPaErUr@kroah.com>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=3cee0850-dbbf-4b06-a840-153b40d04003;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-04-06T13:49:40Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=microsoft.com;
x-originating-ip: [2404:f801:8028:1:60f6:ca47:5dfc:b1d0]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 798d4f63-334e-43a5-7fe6-08d8f90461c1
x-ms-traffictypediagnostic: PSAP153MB0407:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <PSAP153MB0407E7A7BFE274EE4ECCFB3594769@PSAP153MB0407.APCP153.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wH3FqhuHpSMwyXmGGa8/rWVDNuXym51n2HrCzYcgL0kGDfi3Fk7WxX2KIboZMHsljRGirztpJKdRLDwtG6fTBQYDwOp6we09XGs3jxP8uGAHKDnk0QDHQ2fLiwnGX3+Qoljnv+78eiRWPe9Q4iBFP9n5OGfEJ4qj6OHsor9F9AJuWfn5CorABtKWIZml7rw4w1MtXfxwgJ7cLlPUSNn5+29Ku4Zd7R96konQUfBHg1okZ04D2LmcThMKc5cGhl4YLbdQ3fHewTrc3BNWKgtk9CrTKFIG0WKLuSR2kIdWeBvvrRD5HwPXyQLQAhfSlzhEA+iniSbuLeVZjeMjAQeBB5OITryNlFRxUVsjeTVZya0LRRVxlZBz21R6cNAwqsFSBmwJdIIEe4w2fFsrbaCJGVjsZnnkbxe8oTisxk4J+2t9dLLbPf5YrqAVwoegFY44F8pUEPRSQZJgbJuwrbIWYbeocJWlFXPPbYwnz/RG474tNm34hZ/yg2c+sEFIR9RoaGtIQx6qzmi3dkTX2VmXtC4PCcBN36KzPxngWfcirPyaqisjBXrqU2Pzjui3YfdvdgDwFiDcM7iDVdZhILmxTf4yht8ZlarTxeBe5qP1cjQcbNVKShP7pQzmyEIiJ26ilPKYSITO+ShPaxSHtPmsANB5aTphiM7FO1HVrY6TQUOy+sBauVTOq7PgZfkn5znS+VoIpadSp/rS5MVLkrIsxNl/gULX7vSNvs3WFYGc4UkuusfPwc14FR0AhQTxOa3c
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAP153MB0422.APCP153.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(376002)(396003)(39860400002)(136003)(82960400001)(82950400001)(8676002)(53546011)(71200400001)(4326008)(6506007)(186003)(66446008)(76116006)(66476007)(66946007)(86362001)(8936002)(64756008)(66556008)(55016002)(83380400001)(9686003)(7696005)(110136005)(38100700001)(316002)(52536014)(54906003)(8990500004)(16799955002)(33656002)(478600001)(5660300002)(10290500003)(2906002)(966005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?yVO5qEXjv9Fnwm2ZzrNTRGvIOykaaMb1cBvlmJrPqKMxa4WwulYVsxgPNexu?=
 =?us-ascii?Q?BREfDenE+/0h6oVKeZ+TuDLSkOg3b3lo+uzJ4XeFkxzYO7kbjvESO/9Xk2j0?=
 =?us-ascii?Q?LbQkNSqxs6Rs7s2BtqpxEBl1SX2DHLbByBZI+Px7vkC9PDxAMMvwYvHnsMbe?=
 =?us-ascii?Q?s8bfyantgwXgePooWy8wyYBR58Us4toE48/aOPio+E1OWMbtHhSh3JUDhvAN?=
 =?us-ascii?Q?pB4fxAZLxYz5BTSllCsO3AIOHYwKz9h6bl3vfYR5Iy19OTvrVapagXGHSHQ2?=
 =?us-ascii?Q?Ifu5pIpVyAim2Hqpqdia7ZTKkqZarlkZRT8UHN0dgquYZBHvsJCb3GiAucSM?=
 =?us-ascii?Q?bsuVRYFmvyKWe2Z0cbYc5Dsk/wt+7xLn2KAajrt+qUyh2qwuFqECe6hs+ddI?=
 =?us-ascii?Q?9Cm6Hip3pqs0Dw6MoMelrHWclUh+Qb2cD+T6GWzT7TJkC3gVST5zfuEVzw3R?=
 =?us-ascii?Q?C3GDCLXcTTxdyJPP6YdG++okDAxv45C6ia/BLH3cuLiuFfyrunEe+sVTZFiv?=
 =?us-ascii?Q?3X85EZJxZHxeawiwhinvg80kCUAQ0USTsaCiudRSDJh+Yfpqk+xhjJMT71sf?=
 =?us-ascii?Q?9ujN7+vJAkA/8HEdwV1KUXGjLpwRBq1DvWAczEtYi7LvmX2f9VD9b/a6RBvc?=
 =?us-ascii?Q?drw28V4RyeEyFlgOmY0/BO4vjvvTssVltKYunYQSeleDANHmFUjdsoBSC9tq?=
 =?us-ascii?Q?WhkfiJu7YGmM3JXw9IG0DhOJlUvzi42gTkUUi0dqytGVGz8l/U7Xm3uV9uHC?=
 =?us-ascii?Q?heXX0Kimu7t1Bi+jHtpWWvYzCyTgYxFgU/jQXcqB4KwSyzAj6rMHWZbyA8AT?=
 =?us-ascii?Q?HJZ2xA5rIwrFw0wdhq5SElVswl03Jx3iNEqNmbvq6VEP+5czxGNUkzk0cpUG?=
 =?us-ascii?Q?dEw4p5Y/DTFuZSLmLWCIjHI0i1RoPNmxQnw/f8kyi3+e7SiJugtqt37aSPK+?=
 =?us-ascii?Q?9q5o2RlAwpN6+i1Qz/LeVKCgGgT2AfG6QR5LA/STEJnK6wvkCSPHlzPTkdJR?=
 =?us-ascii?Q?vEIKVELU3uVGctEBF3w8QYABsQvzguE8XtBv5VjlR2hyzNs0GQNJsK6M0N6z?=
 =?us-ascii?Q?lBf6T8XTMU9ICvtxzbeF4gPoUrblZNUwGtK0nfD1wfqWhmnhhDOrLQ8Mum7Q?=
 =?us-ascii?Q?UFhEaep4FsdrXn2hwxufyqHEJJeT8ImLoQFUkjOPkG2JEE8XJXhfARhwCTFp?=
 =?us-ascii?Q?AuffoLApWaDPE38/TrQ6JiwImwov96ZPHdOmiE35RUbHKbZGBFuu3UzCPECm?=
 =?us-ascii?Q?uxRVH+ieIZSxEcjsVgeZHuYmupDb/BBVVaGi4Saojj+YpBXKOVLI8k+eUZgM?=
 =?us-ascii?Q?550jywiWfJilgMVS9ztg0afHp3f4n+vnkHzmffQW+0joYDQPZzAIgvMCJbwY?=
 =?us-ascii?Q?uRumM60=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAP153MB0422.APCP153.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 798d4f63-334e-43a5-7fe6-08d8f90461c1
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Apr 2021 14:00:48.6080
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6Rky1u0mzHLP/glQ3W+n/axNQIqPXnWdrhpfkAPbPDYd+28dCd4eIVUJKZiSUpINb7pxPjey1ZePL2WipNbVRg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PSAP153MB0407
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,
We'll need to debug this further to understand what's going on.=20

Hi Salvatore,
Any chance that you'll be able to provide us the cifsFYI logs from the time=
 of mount failure?
https://wiki.samba.org/index.php/LinuxCIFS_troubleshooting#Enabling_Debuggi=
ng

Regards,
Shyam

-----Original Message-----
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>=20
Sent: Tuesday, April 6, 2021 7:12 PM
To: Salvatore Bonaccorso <carnil@debian.org>
Cc: linux-kernel@vger.kernel.org; stable@vger.kernel.org; Shyam Prasad <Shy=
am.Prasad@microsoft.com>; Aurelien Aptel <aaptel@suse.com>; Steven French <=
Steven.French@microsoft.com>; Sasha Levin <sashal@kernel.org>
Subject: [EXTERNAL] Re: [PATCH 4.19 013/247] cifs: Set CIFS_MOUNT_USE_PREFI=
X_PATH flag on setting cifs_sb->prepath.

On Tue, Apr 06, 2021 at 01:38:24PM +0200, Salvatore Bonaccorso wrote:
> Hi,
>=20
> On Mon, Mar 01, 2021 at 05:10:33PM +0100, Greg Kroah-Hartman wrote:
> > From: Shyam Prasad N <sprasad@microsoft.com>
> >=20
> > [ Upstream commit a738c93fb1c17e386a09304b517b1c6b2a6a5a8b ]
> >=20
> > While debugging another issue today, Steve and I noticed that if a=20
> > subdir for a file share is already mounted on the client, any new=20
> > mount of any other subdir (or the file share root) of the same share=20
> > results in sharing the cifs superblock, which e.g. can result in=20
> > incorrect device name.
> >=20
> > While setting prefix path for the root of a cifs_sb,=20
> > CIFS_MOUNT_USE_PREFIX_PATH flag should also be set.
> > Without it, prepath is not even considered in some places, and=20
> > output of "mount" and various /proc/<>/*mount* related options can=20
> > be missing part of the device name.
> >=20
> > Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> > Reviewed-by: Aurelien Aptel <aaptel@suse.com>
> > Signed-off-by: Steve French <stfrench@microsoft.com>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >  fs/cifs/connect.c | 1 +
> >  1 file changed, 1 insertion(+)
> >=20
> > diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c index=20
> > 6285085195c15..632249ce61eba 100644
> > --- a/fs/cifs/connect.c
> > +++ b/fs/cifs/connect.c
> > @@ -3882,6 +3882,7 @@ int cifs_setup_cifs_sb(struct smb_vol *pvolume_in=
fo,
> >  		cifs_sb->prepath =3D kstrdup(pvolume_info->prepath, GFP_KERNEL);
> >  		if (cifs_sb->prepath =3D=3D NULL)
> >  			return -ENOMEM;
> > +		cifs_sb->mnt_cifs_flags |=3D CIFS_MOUNT_USE_PREFIX_PATH;
> >  	}
> > =20
> >  	return 0;
>=20
> A user in Debian reported an issue with mounts of DFS shares after an=20
> update in Debian from 4.19.177 to 4.181:
>=20
> https://nam06.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Flist
> s.debian.org%2Fdebian-user%2F2021%2F04%2Fmsg00062.html&amp;data=3D04%7C0
> 1%7CShyam.Prasad%40microsoft.com%7C0acbccd2643f4d55c6d008d8f901c180%7C
> 72f988bf86f141af91ab2d7cd011db47%7C1%7C0%7C637533133251645484%7CUnknow
> n%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLC
> JXVCI6Mn0%3D%7C1000&amp;sdata=3D9xz2q%2FC1ur%2F3y70L5CJ5YoL%2FLhSci5hJ3U
> pttjbZJas%3D&amp;reserved=3D0
>=20
> In a test setup i was able to reproduce the issue with 4.19.184 itself=20
> (but interestingly not withing the 5.10.y series, checked 5.10.26)=20
> which both contain the above commit.
>=20
> 4.19.184 with a738c93fb1c1 ("cifs: Set CIFS_MOUNT_USE_PREFIX_PATH flag=20
> on setting cifs_sb->prepath.") reverted fixes the issue.
>=20
> Is there probably some missing prerequisites missing in the 4.19.y=20
> brach? I could not test othr versions, but maybe other versions are=20
> affected as well as before 4.19.y, as the commit was backported to
> 4.14.223 as well.

If there is a missing patch, we will be glad to take it, does 5.4 also have=
 this problem?

thanks,

greg k-h
