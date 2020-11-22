Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B3E12BC731
	for <lists+stable@lfdr.de>; Sun, 22 Nov 2020 17:43:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728089AbgKVQmx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Nov 2020 11:42:53 -0500
Received: from mail-bn7nam10on2077.outbound.protection.outlook.com ([40.107.92.77]:21184
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728074AbgKVQmw (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Nov 2020 11:42:52 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e/gEREBSPqo4ivg8wvnZ/N50tQQGsRNWreAzdcCD680Hgnx4bGm75ysLhHwOAjsPxzTbvinSKU+g+l+7IYJ2PvwHF1HAfCrDDkqqyAW92stp6G2HKHQwWfFiuRgZ4woVBp49hfZjpBq2TuGi2UX4ZSlaGzkSdzF77J4KAN4bJLCkBlw5apnkjoVr8TlSd+lEK4UOmh5txIJoojtzmr7eGwxHaL+TrvJFBWMIyiGHjNvbuuyw3f3E6O9Pk54ScyeFyFlQSi3HI+xDV0Sn1JsYK5PCloTy0ADcrwh9RxA+FHCfVUT+dIGF0qncltJZ2HnL8Ar1zg1ajAtAcgP2fISMrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wK8LbihOJOL6c3KTsiWjSogOLnDKsTrm+afyIEpVmiM=;
 b=nPVCIqA2aOzxNjPjBrPNdHyincL+uMkyJ0d58aMBDYtHhwtolwQY5jKARXI2fLNLGK68RNei0SRtcIaxUzy4UR6m6VCxMkSC9wu//ZnWu1f7LVEUF9hRqEjpv0D6Pi/FDsRhn39NcOaHW1zkhnT3CA2ISi2todP3/LIX3vQUi4dFD5FFcAtY81sfKof8Qf2YWTVSn64QsNYmi2gw+FcTKrCOtB7nwrOdD83weAq5gt7oD27VLY25Qem+7TzEHqo1Az9Nnw6FZjch78GGa5a/Uo69PrFSpIs3cmW1RoGCPzSn6YwYzE896u2K3tG5bcta1FtoKGtiHzv9xmLDKCDgXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wK8LbihOJOL6c3KTsiWjSogOLnDKsTrm+afyIEpVmiM=;
 b=ThD/+4p2WYsxdViOu2Qe8FySaRyA5zX1mz0y3woJsXuc0ti7+z3eRxyKguzhD0uIlEBlnk3ylrdUoVdKSUxRGFiCjWc5DZ005+T7tKmad7UvBQnBmtyzq+T2H2T1FJd44cQt3PZRY5ohQ+96b7cuOSCmlfOEBvH8n30SgpkHkUw=
Received: from DM6PR12MB4388.namprd12.prod.outlook.com (2603:10b6:5:2a9::10)
 by DM6PR12MB3116.namprd12.prod.outlook.com (2603:10b6:5:38::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20; Sun, 22 Nov
 2020 16:42:47 +0000
Received: from DM6PR12MB4388.namprd12.prod.outlook.com
 ([fe80::84e9:dd44:12cf:bdb3]) by DM6PR12MB4388.namprd12.prod.outlook.com
 ([fe80::84e9:dd44:12cf:bdb3%4]) with mapi id 15.20.3589.030; Sun, 22 Nov 2020
 16:42:47 +0000
From:   "Chatradhi, Naveen Krishna" <NaveenKrishna.Chatradhi@amd.com>
To:     Guenter Roeck <linux@roeck-us.net>
CC:     Salvatore Bonaccorso <carnil@debian.org>,
        "linux-hwmon@vger.kernel.org" <linux-hwmon@vger.kernel.org>,
        "naveenkrishna.ch@gmail.com" <naveenkrishna.ch@gmail.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] hwmon: amd_energy: modify the visibility of the counters
Thread-Topic: [PATCH] hwmon: amd_energy: modify the visibility of the counters
Thread-Index: AQHWuRhfPkP7JZ+0TkWLTfmjzaPqdanEvyEAgAFY1QCADa3pgIAAbySAgAAyaVA=
Date:   Sun, 22 Nov 2020 16:42:47 +0000
Message-ID: <DM6PR12MB438839666CD2BA3524D80E24E8FD0@DM6PR12MB4388.namprd12.prod.outlook.com>
References: <20201112172159.8781-1-nchatrad@amd.com>
 <238e3cf7-582f-a265-5300-9b44948107b0@roeck-us.net>
 <20201113135834.GA354992@eldamar.lan>
 <DM6PR12MB438866557FEE8F42C0F6AF26E8FD0@DM6PR12MB4388.namprd12.prod.outlook.com>
 <20201122133011.GA48943@roeck-us.net>
In-Reply-To: <20201122133011.GA48943@roeck-us.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_c3918902-4ff3-42f6-8eb5-e5d9c71daf16_Enabled=true;
 MSIP_Label_c3918902-4ff3-42f6-8eb5-e5d9c71daf16_SetDate=2020-11-22T16:41:35Z;
 MSIP_Label_c3918902-4ff3-42f6-8eb5-e5d9c71daf16_Method=Privileged;
 MSIP_Label_c3918902-4ff3-42f6-8eb5-e5d9c71daf16_Name=Internal Use Only -
 Restricted;
 MSIP_Label_c3918902-4ff3-42f6-8eb5-e5d9c71daf16_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_c3918902-4ff3-42f6-8eb5-e5d9c71daf16_ActionId=033416b9-264a-4ca8-a19e-00006888cc28;
 MSIP_Label_c3918902-4ff3-42f6-8eb5-e5d9c71daf16_ContentBits=1
msip_label_76546daa-41b6-470c-bb85-f6f40f044d7f_enabled: true
msip_label_76546daa-41b6-470c-bb85-f6f40f044d7f_setdate: 2020-11-22T16:41:24Z
msip_label_76546daa-41b6-470c-bb85-f6f40f044d7f_method: Standard
msip_label_76546daa-41b6-470c-bb85-f6f40f044d7f_name: Internal Use Only -
 Unrestricted
msip_label_76546daa-41b6-470c-bb85-f6f40f044d7f_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_76546daa-41b6-470c-bb85-f6f40f044d7f_actionid: d398964b-1fee-4c7c-9827-00009e55998b
msip_label_76546daa-41b6-470c-bb85-f6f40f044d7f_contentbits: 0
msip_label_c3918902-4ff3-42f6-8eb5-e5d9c71daf16_enabled: true
msip_label_c3918902-4ff3-42f6-8eb5-e5d9c71daf16_setdate: 2020-11-22T16:41:37Z
msip_label_c3918902-4ff3-42f6-8eb5-e5d9c71daf16_method: Privileged
msip_label_c3918902-4ff3-42f6-8eb5-e5d9c71daf16_name: Internal Use Only -
 Restricted
msip_label_c3918902-4ff3-42f6-8eb5-e5d9c71daf16_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_c3918902-4ff3-42f6-8eb5-e5d9c71daf16_actionid: 5f1cc869-6b80-4be7-b580-0000c29d9a0b
msip_label_c3918902-4ff3-42f6-8eb5-e5d9c71daf16_contentbits: 0
authentication-results: roeck-us.net; dkim=none (message not signed)
 header.d=none;roeck-us.net; dmarc=none action=none header.from=amd.com;
x-originating-ip: [175.101.104.2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: bc6b75ed-8c93-496a-9584-08d88f05a48d
x-ms-traffictypediagnostic: DM6PR12MB3116:
x-microsoft-antispam-prvs: <DM6PR12MB3116147554E942C753F5C6E4E8FD0@DM6PR12MB3116.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 65YjAoK0tbcRppn//Ui9QmxPeFYATCdu0JLC85w3vdp26+Ta97EgMFXOpoX8uPJl4IRg3ug77zSKWnJbQmYdY4NkMzIwAUm3vz6Wn5Nq9mtjVCBR3gxXFByA2U6DudAuc84NbveKY6olKhU+8KH/ZegGXYTvJOov9Rx3SOKjF2HubFc+Dobl1z2XXPV934Kir8tMmhZSSiFDrlm1lVbDQIn8j/2hYWO3uLHJDtUN4SvrP71EUBpQlFZCgY0KDovuyaWeW7eDldM+mRaHFNiMDz0fg53Hovmw5tr9SEg7HAiDdRR645UzH3VWqwhiH94uXCc1orcCT1gnY1VYJgALYg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4388.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(346002)(136003)(376002)(39850400004)(9686003)(86362001)(55016002)(83380400001)(316002)(6916009)(26005)(54906003)(71200400001)(53546011)(6506007)(52536014)(33656002)(478600001)(5660300002)(7696005)(66556008)(66476007)(66446008)(64756008)(66946007)(186003)(4326008)(8676002)(76116006)(8936002)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: Y1qZCPGg2ez3XCcTpHtn+R2cb1lvop57C9Pqy+Ex1lSMjVkVZ7dNNGeqYz0yI9aFRckVt3JrmIObwNjpLaHJtmOjwprUT+Od5x4RdGEAak/96ly82UWRPIy1E6yUzW7htnSABLz9SeFqs3qgq2UufAwtAd7ii/ImeEXbY4hxA61850QnO4OWUjvNEy9+m7beTqHEYCwKAwVynO8pcq42R6U9RpQpdLvSW1EUSeXIlINp6fLPm8Uk30RfXwkbT7HIlMGkRrWIUpwo9d6cnW5E1LP0aoz1OAQ9LfDEVO/XDksbZ48i0a5bs5C/r+vkK1JyWaHJJujxXmNaCBrTCDzNDtTAnZPnMd7ple6lw5nmL9AD7YZDOyeNOCniMkDiPjlFUMCI5nXp6GDeAJqX8uAPcpWXt5dYchH2isNTQnSXETQANYDtej9ahihtkXMDBJwznZPTbXAHpxB6I8KqvpBv6hDIqiFH/fb390tKiAKzRBf8899hIvkLOMKyUr9abzajXfa3OJZkEB6k0K14xSGm7BWwob94mGVOCTvQeiI6HbuCrq6nFSK6bBJwuAOivOX2GEw84ZIpbvJ+unGvaf3XTi9eSSOSqA2o68zcMQlrh77Tmz8C/ogi76SWPSlATBzpKlIAOnIv5UWD227/I66Maw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4388.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc6b75ed-8c93-496a-9584-08d88f05a48d
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Nov 2020 16:42:47.0260
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HNowbI9IW992OOXbr+VY5TUEmX2dm25RnBOzM7Ale/WrWCqoqQ3skoca85Qqv3dgOD7tMmMFRf8oTikRM7cHYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3116
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[AMD Official Use Only - Approved for External Use]

Hi Guenter,

> A much better fix would have been to cache RAPL data for a short period o=
f time. To avoid any possibility of attacks, maybe add some random interval=
. Something like this:
Thanks for the tip, I will check this out.

> In accumulate_delta():
>        accums->next_update =3D jiffies + HZ / 2 + get_random_int % HZ;

> In amd_energy_read():
>        accum =3D &data->accums[channel];
>        if (time_after(accum->next_update))
Do you mean if (time_after(jiffies, accum->next_update))

>                accumulate_delta(data, channel, cpu, reg);
>        *val =3D div64_ul(accum->energy_ctr * 1000000UL, BIT(data->energy_=
units));

> and drop amd_add_delta().

Regards,
Naveenk

-----Original Message-----
From: Guenter Roeck <linux@roeck-us.net>=20
Sent: Sunday, November 22, 2020 7:00 PM
To: Chatradhi, Naveen Krishna <NaveenKrishna.Chatradhi@amd.com>
Cc: Salvatore Bonaccorso <carnil@debian.org>; linux-hwmon@vger.kernel.org; =
naveenkrishna.ch@gmail.com; stable@vger.kernel.org
Subject: Re: [PATCH] hwmon: amd_energy: modify the visibility of the counte=
rs

[CAUTION: External Email]

On Sun, Nov 22, 2020 at 06:56:24AM +0000, Chatradhi, Naveen Krishna wrote:
> [AMD Official Use Only - Approved for External Use]
>
> Hi Guenter, Salvatore
>
> > This is very unusual, and may mess up the "sensors" command.
> > What problem is this trying to solve ?
> Guenter, sorry for the delayed response.
> This fix is required to address the possible side channel attack reported=
 in CVE-2020-12912.
>
[ ... ]
>
> >> ?
> Yes, Salvatore, thanks for bringing the links.
>
A much better fix would have been to cache RAPL data for a short period of =
time. To avoid any possibility of attacks, maybe add some random interval. =
Something like this:

In accumulate_delta():
        accums->next_update =3D jiffies + HZ / 2 + get_random_int % HZ;

In amd_energy_read():
        accum =3D &data->accums[channel];
        if (time_after(accum->next_update))
                accumulate_delta(data, channel, cpu, reg);
        *val =3D div64_ul(accum->energy_ctr * 1000000UL, BIT(data->energy_u=
nits));

and drop amd_add_delta().

Guenter
