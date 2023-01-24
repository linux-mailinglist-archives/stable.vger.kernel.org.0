Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8A87679DC1
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 16:42:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234539AbjAXPmd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 10:42:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232793AbjAXPmT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 10:42:19 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 260344C6D9;
        Tue, 24 Jan 2023 07:42:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i8VyitkTHax2Fcjky720Z1oTK6KlgdcGHNna11L25umsCdEXPbjcG4KshltASveBD7BaGoZBgvN2KTLCWxgvGzajLjhtYaDfdmqzAhz3FXwMX2j9R+V/0fKtgdG3YUxU0VnL4GDy6dhnIcOU8eybUBl3zRwBFuUe1OsWhbBaO5FKrnPNmRXcbRfEXtb021yftYBGvXGBSyy7bI4462oj+3Z8xyQw+sKQl/XriQJnoBQFIUtLbQLr8dtXUUpU25ABKVEgkE+pmpJjLEwhg1eu6lolRPztJAQWIgmZe6L0/ZuHXUNJYxfHIvHJ1q1uwdjh5j+s2EDZsBBwkL57tviO2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2KKc4aytjRN4VRIzf7zu6d9tXlhEuH8ohhmapZJCHwM=;
 b=NPhpCji17nnjK5ib1CRzFy46KamaMHT5ppPIGUsiirmP65kDjxE3HXYptS+pRJGE+EQc+4sP/V07sXPaIs7WNjGeOhbbO+/7tHPK6P5as0GkxyxwYgoBJgJ1E0oFtoClnbk0cHix2GPibNRuo85SDZzlHMOYldsJXsQfQ0buiuARzh9Cdoz7iNPc9G87ZVAWo9t08nk7dUvPpMKVAoYxL1ZlVrsTduVULoJSZu+Nzfbn6p1u8DFICzQfNw+Uilx6oOZ7JWXs7ux4n5XkTBSM8QwYKHAV5z/HON9HvuH4oeu4tIzkLjAeVXtBo/WQOVzerSOTptqw6q5E+HgxnNHpCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2KKc4aytjRN4VRIzf7zu6d9tXlhEuH8ohhmapZJCHwM=;
 b=BwcdMJBU3adE1b4zFZVrIazQYg8aCZ2qd0ViJbfrWkCCZoP4EdaA/QUO+wZYqqmnbeARpChUQILsg8yNDz34gw+tFHNgzaWyz7stWvkT5qHQRB916j8Szs0dB2W/EwPE1gPz9leWDhtLwIlHw7iE6mrd+f0IIxlBnuR+qZvz2dA=
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by PH7PR12MB6587.namprd12.prod.outlook.com (2603:10b6:510:211::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Tue, 24 Jan
 2023 15:42:02 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::a59e:bafb:f202:313c]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::a59e:bafb:f202:313c%7]) with mapi id 15.20.6002.033; Tue, 24 Jan 2023
 15:42:02 +0000
From:   "Limonciello, Mario" <Mario.Limonciello@amd.com>
To:     Mark Pearson <mpearson-lenovo@squebb.ca>
CC:     "hdegoede@redhat.com" <hdegoede@redhat.com>,
        "markgross@kernel.org" <markgross@kernel.org>,
        "platform-driver-x86@vger.kernel.org" 
        <platform-driver-x86@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH] platform/x86: thinkpad_acpi: Fix profile modes on Intel
 platforms
Thread-Topic: [PATCH] platform/x86: thinkpad_acpi: Fix profile modes on Intel
 platforms
Thread-Index: AQHZMAm8Sw652IiK30KstbbLA6CRca6ts6bw
Date:   Tue, 24 Jan 2023 15:42:02 +0000
Message-ID: <MN0PR12MB6101116BB3A356A9A8E846B5E2C99@MN0PR12MB6101.namprd12.prod.outlook.com>
References: <mpearson-lenovo@squebb.ca>
 <20230124153623.145188-1-mpearson-lenovo@squebb.ca>
In-Reply-To: <20230124153623.145188-1-mpearson-lenovo@squebb.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2023-01-24T15:42:01Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=4bc51e3b-2c20-4b73-a79a-5a19ef5e2b34;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_enabled: true
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_setdate: 2023-01-24T15:42:01Z
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_method: Privileged
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_name: Public-AIP 2.0
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_actionid: 7811964b-42ee-4e90-989a-6da05948630a
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR12MB6101:EE_|PH7PR12MB6587:EE_
x-ms-office365-filtering-correlation-id: 652adc92-1d57-4518-c2f7-08dafe2189f5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: U9afcWY2haUVWq/8NS+kOuyt6XtBS5eClCeW+GfHp0VoIukDagyXVpHAnIiWaXK/jtkbmOW12Tc3JNsXHWn1xxd79Vcc+H/rqEw0fJvhlci+88fLIlnIyfU3bQY9b3VGPB7zL32b4Ib5x8A3tZJTdqjvSoZAqLqaxwEeSunTaTRMDOL+uWS9AhuquiiGAKS0ldncsQA/OoV0/3TtR9C9go52nGSZPmF1JbWULSobI+jDvh/IjyToHBDvftaGhK5yOboYTRI7C8Ocxx8g6LBAqrZCSo2QWlYO92Csq19V44s4TCjGE1KMpwFUMjMfDHkMmSwpKzLrCU9gAj5n/76JEl3fKJ4OXT7fborTc1crPH/8QPD09U6Kqo2NWhKNLRgYMxI28s6v6m0oumf2yAE5Z+bC2JRDayhBHl2BLX2sid04+yC6kB8WvYjWZtU+eJemb/KeH32zvVOp+PGIRpQ5prehGyND8IS6DDqpD7MBB8xPlb2WSvJjScdrDaJjU6FVeJmby1UMXzrzVbH9q7Ww2z6K4RSEiId64lG2u91lL0FDSG4ntjUkjBOPbSuNmYSQwwl2fhAcaQCahzHrahYdMraGI1BNEY/S1oeRV1M7tTzQeAsDA79gSHgr0nB667wj2IxUIlPDR85ckfcG8M0izL6EFYB4lmStbTzh6xGjRCMITLhCtDs9ciyzwhMl2Y1j0FmytiLma4giCtjN8beVAYTcxQQYRXren19t6WK+nyg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(39860400002)(366004)(136003)(396003)(376002)(451199015)(86362001)(38070700005)(2906002)(4326008)(8936002)(5660300002)(41300700001)(83380400001)(122000001)(52536014)(33656002)(38100700002)(966005)(7696005)(478600001)(71200400001)(66946007)(9686003)(6916009)(8676002)(26005)(6506007)(55016003)(186003)(66446008)(53546011)(66556008)(76116006)(64756008)(54906003)(66476007)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?/8Z1HceUK1fr84872sq9PipNBEr+z9Jv6ZCl14GFEyx0uDhO6olSE2gYDA7p?=
 =?us-ascii?Q?fVn9kbofEYealKTPLaKeyRJzLvOP3OtdgD4OU2aznoA5CbnbV8V+PE1/NeZ5?=
 =?us-ascii?Q?uPIMBOcTv3WfXMVFvd7NlYmu+svhxshaqEJa4o1z5bp0Hoh5fg30C1ppLLWZ?=
 =?us-ascii?Q?ddCZgnl7yED1/LPBkE4Gis9UPGwgsdIgNU0iRGGo7flA93B3/w1AqEE6XeEZ?=
 =?us-ascii?Q?zgn6nkXoIkO0PDNJoRZClvNM+kuxk2T2qmVn84j6lf9UN3LxWK3kz/B1B9GU?=
 =?us-ascii?Q?5d1DuFvbMsj3UNHr74AfpHEAyER9Ds17clQuQZgrCSnSbAC89qYf8PNiv8mJ?=
 =?us-ascii?Q?66YNyJA8TGORi5p1BSrvxFkznPidBetzhyszcJZuSBUf8T0iWVtnBMmzGnci?=
 =?us-ascii?Q?xIq2M1jofu3R07MqFk+KJM4dOugSPf9iPoK6o6AyIPyDmK9NUxgsVk3ON3fS?=
 =?us-ascii?Q?2nQQoQZ0UJRjuPw98O8uM5uHg0/JxNsptDCWHTNaeJFgUALJRU02OyqbLnb0?=
 =?us-ascii?Q?sy486Gb9v4w/Wk//ertbyM7EoA1+etVUe/u7mufE6rIYAoCM+6oKv+N4ackx?=
 =?us-ascii?Q?D/VpkqssWacoti1lpQJqtK/QOyo0YKeJ6yDuBSmfgPOVfmqxjCqTuDeXsx4B?=
 =?us-ascii?Q?3wTnphkSPoRoYLVloE4yNk8zTueA8K2aYperx8pGgyeRFKC19DV7x9HVCw8f?=
 =?us-ascii?Q?I5z+mtXDUN9ML0hsIaUnCy8yC+/pguHtNzyolbeDxxgKa9Vlc/sxUrbK60sv?=
 =?us-ascii?Q?2hJiUkIAT4GNWgEFUVkRBmimQI4rJYidNvlxUbnFaKQpOWglQbwPKTCvSsLb?=
 =?us-ascii?Q?qi3Q/8uc5pQYXZrAfbj0JDUxVK56UTFgFRl9VXwu50oq8TwFrlhg2BF7nZju?=
 =?us-ascii?Q?M+wZfoiiwkaQfYRU3NVHhfq0pF3rG/yVo/qsFpYKX577M+wYHeKiYicuI9/j?=
 =?us-ascii?Q?Sm5gYevjjFkZq30uEQgRxVPwUb233tqSpq/q9WI0K8FZOwbR6zAH7El8Z57q?=
 =?us-ascii?Q?4sRfcydKj1P0xWgx9BZxP6d07sn5aNtcxENw0/U5IvyyLnUiNimq7Zu2QQYO?=
 =?us-ascii?Q?aZtc72y4xb5kDVEO5LubV+/JYAcDyY+pXoxfphpBaJ7IpXVBSRBXtvL0VQVO?=
 =?us-ascii?Q?UIf1Q8LZ5CYHW5DmodNHEROVaJfYZ2dRODcfoxFzKKMMVmSy4tsweYRW7ak+?=
 =?us-ascii?Q?DpAj92o9PsuHqVLww779RCxmHf6ziwP8QUA1HgIMDuzwrGHOYatSqjRiL6+2?=
 =?us-ascii?Q?CLKcTBYeu2MwBbWgVezPGaqgHX+1CykZJ4JQEr3lz0k8P5mL5c9vza90EYb0?=
 =?us-ascii?Q?UYy6IUyDvhaucSkxvSomUJV89JMP5eq/gyGrqDPN4uO3MoUKmHx40gWYIap8?=
 =?us-ascii?Q?iig799hnW++vF7666bjMP9Ig6kN9Sc4fKMp1uCtxGl+Zt9arKPERoYcIeXQn?=
 =?us-ascii?Q?Tq3KNnM9FnZzPzfGy40d70o02RNUaGFkwWopIZoEp6EaveC7k1AodZxHLshJ?=
 =?us-ascii?Q?o9QATbUMayaQyvNS5FcvuoY7oI98XixQjIO43eOFf8/g8jtizurbyv5VmmjH?=
 =?us-ascii?Q?GK3OC/bqEE1V0WY2TwA=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6101.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 652adc92-1d57-4518-c2f7-08dafe2189f5
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jan 2023 15:42:02.7838
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: s2KqtTlLHAM7M1lKBOnWmIqe6AdhEDWEi1an7opm/aX7Wv5Pu7ysw7yC+n2cHV1VidwLq/bKOj+/Smf8hOsctA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6587
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[Public]



> -----Original Message-----
> From: Mark Pearson <mpearson-lenovo@squebb.ca>
> Sent: Tuesday, January 24, 2023 09:36
> To: mpearson-lenovo@squebb.ca
> Cc: hdegoede@redhat.com; markgross@kernel.org; Limonciello, Mario
> <Mario.Limonciello@amd.com>; platform-driver-x86@vger.kernel.org;
> stable@vger.kernel.org
> Subject: [PATCH] platform/x86: thinkpad_acpi: Fix profile modes on Intel
> platforms
>=20
> My last commit to fix profile mode displays on AMD platforms caused
> an issue on Intel platforms - sorry!
>=20
> In it I was reading the current functional mode (MMC, PSC, AMT) from
> the BIOS but didn't account for the fact that on some of our Intel
> platforms I use a different API which returns just the profile and not
> the functional mode.
>=20
> This commit fixes it so that on Intel platforms it knows the functional
> mode is always MMC.
>=20
> I also fixed a potential problem that a platform may try to set the mode
> for both MMC and PSC - which was incorrect.
>=20
> Tested on X1 Carbon 9 (Intel) and Z13 (AMD).
>=20
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=3D216963
> Fixes: fde5f74ccfc7 ("platform/x86: thinkpad_acpi: Fix profile mode displ=
ay in
> AMT mode")

In order for this to go to stable, it needs this tag in the commit message =
and not
just CC stable in the git send-email command.

(no need to respin for this reason, patchwork or b4 should pick it up when =
Hans grabs it)

Cc: stable@vger.kernel.org

>=20
> Signed-off-by: Mark Pearson <mpearson-lenovo@squebb.ca>

Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>

> ---
>  drivers/platform/x86/thinkpad_acpi.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/platform/x86/thinkpad_acpi.c
> b/drivers/platform/x86/thinkpad_acpi.c
> index a95946800ae9..6668d472df39 100644
> --- a/drivers/platform/x86/thinkpad_acpi.c
> +++ b/drivers/platform/x86/thinkpad_acpi.c
> @@ -10496,8 +10496,7 @@ static int dytc_profile_set(struct
> platform_profile_handler *pprof,
>  			if (err)
>  				goto unlock;
>  		}
> -	}
> -	if (dytc_capabilities & BIT(DYTC_FC_PSC)) {
> +	} else if (dytc_capabilities & BIT(DYTC_FC_PSC)) {
>  		err =3D
> dytc_command(DYTC_SET_COMMAND(DYTC_FUNCTION_PSC, perfmode,
> 1), &output);
>  		if (err)
>  			goto unlock;
> @@ -10525,14 +10524,16 @@ static void dytc_profile_refresh(void)
>  			err =3D dytc_command(DYTC_CMD_MMC_GET,
> &output);
>  		else
>  			err =3D dytc_cql_command(DYTC_CMD_GET, &output);
> -	} else if (dytc_capabilities & BIT(DYTC_FC_PSC))
> +		funcmode =3D DYTC_FUNCTION_MMC;
> +	} else if (dytc_capabilities & BIT(DYTC_FC_PSC)) {
>  		err =3D dytc_command(DYTC_CMD_GET, &output);
> -
> +		/*Check if we are PSC mode, or have AMT enabled */
> +		funcmode =3D (output >> DYTC_GET_FUNCTION_BIT) & 0xF;
> +	}
>  	mutex_unlock(&dytc_mutex);
>  	if (err)
>  		return;
>=20
> -	funcmode =3D (output >> DYTC_GET_FUNCTION_BIT) & 0xF;
>  	perfmode =3D (output >> DYTC_GET_MODE_BIT) & 0xF;
>  	convert_dytc_to_profile(funcmode, perfmode, &profile);
>  	if (profile !=3D dytc_current_profile) {
> --
> 2.38.1
