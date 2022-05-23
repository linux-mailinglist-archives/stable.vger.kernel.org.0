Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F341C5313E3
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 18:24:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236762AbiEWOA4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 10:00:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236761AbiEWOAy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 10:00:54 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2089.outbound.protection.outlook.com [40.107.92.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD0A55715E
        for <stable@vger.kernel.org>; Mon, 23 May 2022 07:00:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cKIvMSgXvoBHI2AcUTjGIAAmCskTs48lPlCAq0wnNA/C5oqER7QutE2xX8dmgzER87iJ10jQseJuxrch1w93SGZ20RYejxUbQLWcvks152mrn1Gl9kZakk1lrxDx3i2Ebs05v8+kJtSnCx0Su3Pdmwavw9hBCJiXlC1MmbKQILyuh0SY2Ll1NW3M5u6tsLLuTZLSD1sMdxO8IQa085hZQnDgi0bhTjWkTrgdA9zlY1N2n5ItXVhJ4RV31b50tLHGRguMQNHc06fCASbLeeEuGIMbnNvvu6Wt5ApCa8bBMxbyBAdfeHpcQW8RTpHiipfpLFp0bhjKfPUu3JHOJO2hLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=es2d1G0h/yMiaNjM3+qqMNYIcDhUosSN1zJzCJqTjSw=;
 b=kfTNLUt63wUqW3hj4X/4afjFOjSTUGPwSzE/mFgWMUSZfrhiOhyluiUzLvJ1SrpVJQueNA5A6d1yHI/XonlbJ5Z8YZ2alrT5WPhATolskt6X809QMSCxdmY3YrZ8H16oFM9Y+sfbuk9feqqGPhjjzycOxqt/n1LiGgbrh+IkEjqZbXy4lAuk0ewH/fm56EonSZ+22ZEMlpYYi8hbHbFDscFlhIqTSY1bOMuhcUIWEl54K5jtHwmfrP9Jool1LIcJu1jAU9Ic+sFHx1+4EqHelDV7jDJuETJUYKVw90PJCwD/sapxWgvB6PBiQbQh3AkcwmJ+OO50xbne7K71GAS++w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=es2d1G0h/yMiaNjM3+qqMNYIcDhUosSN1zJzCJqTjSw=;
 b=BgpJrSY+q5IU3n0mp5Xwam7Yq+DMC8NKnI6O+YCUGOKCLMo9a3MP/033nv92CXyx4EONttO3SdwENHu9RuluD5U8QX7oZbLJlmGLefQ3RSuK85eZcvEnJTf0lgzDGh+5NU3J3OU3+s0kEcqRfBEuSzSfXRyvOk/bMNaK2GhwQps=
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by CY4PR1201MB2534.namprd12.prod.outlook.com (2603:10b6:903:da::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.15; Mon, 23 May
 2022 14:00:47 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::d42b:7413:ba19:e8db]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::d42b:7413:ba19:e8db%6]) with mapi id 15.20.5273.022; Mon, 23 May 2022
 14:00:46 +0000
From:   "Limonciello, Mario" <Mario.Limonciello@amd.com>
To:     Christian Casteyde <casteyde.christian@free.fr>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Thorsten Leemhuis <regressions@leemhuis.info>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: RE: [REGRESSION] Laptop with Ryzen 4600H fails to resume video since
 5.17.4 (works 5.17.3)
Thread-Topic: [REGRESSION] Laptop with Ryzen 4600H fails to resume video since
 5.17.4 (works 5.17.3)
Thread-Index: AQHYabuPQo7dlCpjq0mwll14F3A0P60jViwAgADNTwCAAACrgIAAC92AgAhHWYCAAA/aAA==
Date:   Mon, 23 May 2022 14:00:46 +0000
Message-ID: <MN0PR12MB6101E9BB90129B888C9DC069E2D49@MN0PR12MB6101.namprd12.prod.outlook.com>
References: <941867856.547807110.1652809066335.JavaMail.root@zimbra40-e7.priv.proxad.net>
 <CAAd53p4ddFYE+O6Je8z9XDy54nTiODJsQEn7PncZ95K_PXPtPQ@mail.gmail.com>
 <2ce8f87e-785a-25b2-159a-cca45243b75b@leemhuis.info>
 <2585440.lGaqSPkdTl@geek500.localdomain>
In-Reply-To: <2585440.lGaqSPkdTl@geek500.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2022-05-23T13:59:44Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=1ad2001a-a8f6-4e87-99d0-d141d6112a1a;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_enabled: true
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_setdate: 2022-05-23T14:00:53Z
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_method: Privileged
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_name: Public-AIP 2.0
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_actionid: d81423fd-8045-4d0a-8e16-55b2c4f1df14
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 426a14a0-7c48-459e-ce42-08da3cc4a2b3
x-ms-traffictypediagnostic: CY4PR1201MB2534:EE_
x-microsoft-antispam-prvs: <CY4PR1201MB25349A0DF8D9AFCB33BFBDABE2D49@CY4PR1201MB2534.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: i5zZE+apn+ILC5o3lM7yAeT7lE4Q+1nSq8u/q+8moqS98zTDNZqtxrsIRhJ2kxlqgS5iLG7TDEaTpa8S1+biVtGjUlAV1XlJ6Ata62F0jRmEnhWXxongmrWXTGHrvxTeP/qzvQHjXUaocYDXxBH8Xl3kZljYBupPsIRw3EZUL7mEk2eQCV+htbv+Q5BNltnoLox32UEvvtPA7UxkUpbkwhfmC6lb52JFY02x5ICoc0ThTdqqDC9GxAjXWKSV+vDEfffFgjax9KyiFwG/6fCARq9Bz1Kx7p5yA3UZzrPw1ElgB6A6QS3runwdVFFpOTjxePNNOEVk7kRe9Gpcw4SwmDxMfLGp9axWJUTqFVvSxtn5OKtUKI/LxIM0EmoSVeG3vCgOPCApmBk2ZzjI6EWZLn9vCsizP9F2WoqWDXDxTpen8pzLooy+7R5isQ0o3zFiI3vnK1gIS9npubadKRdy23JzzYYY/qKSZdNAvWaslyNPHgpyn5Kkukb+eN3/p0yWcAKynFkU4eSbFNJUtanZnVuE7at0FByZBBLgFZjpLMt3mN8gYzx5FB/O5RNqqJGBx2pcumoFALp33ktOKtph2smONMGBVgpXH+SBCjkbNI/vAwYsz4so3NFgGROhZvDLtTZfya1utTP3YsaNEhTub7HVs7KBWm6GB7sT9SFrOsnrzPeG2YvXAO7E5cDTvn+9fXPmM6+pO+ArXaBrdhs4C5m0rwgEMaEdH1XiYdnoKladP9bO25GNa+AzDv7BVdIUdKdFhstO1BDTGUU8phzX7w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(508600001)(52536014)(38070700005)(33656002)(966005)(71200400001)(8936002)(55016003)(66574015)(5660300002)(4326008)(76116006)(8676002)(83380400001)(66946007)(66476007)(66446008)(64756008)(66556008)(316002)(54906003)(186003)(7696005)(110136005)(26005)(122000001)(38100700002)(2906002)(9686003)(6506007)(86362001)(53546011)(41080700001)(15866825006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?BtpOc7dT8jUD3zDG41zuK7hOmRc1v+JgJYnFwQg3ICluKF7Hyl4dN0h3ZW?=
 =?iso-8859-1?Q?/dJYofuPI2ZXEd0cpjmmdTs8yq3AV4SRrjGncFSM2OvV60IDhRkMUqhub7?=
 =?iso-8859-1?Q?m/o+5CynPUknNKc6chesXh/Kfu2xg/DEZrUYSewYv9hJirHg5w0T1d5DTA?=
 =?iso-8859-1?Q?eFGyoMbY3rYCA0G9FmaSjjBMw/+wFYwHnePf+eQHAxH9nSoVVvNdUId52j?=
 =?iso-8859-1?Q?Sb91RKYF7vWDlrCEwiBqifMJSAoEyn5J/thzrkouAAGXKh1wVxoy3V3mM+?=
 =?iso-8859-1?Q?rTjCMHqL8HqTRnTII7wAwpaF5IImBFxhJBElAUzZ0/YQ73E8M9ziVOQ/ep?=
 =?iso-8859-1?Q?mVfxb1yAscKMEEko6ZsR2FNH7WVY38tUw3a1AnVZzUUaVIb68967Z7wBb0?=
 =?iso-8859-1?Q?KnyECT0ROwjDSBMvOa8dM8R3dmgL+1c6in+3hAg+hMfGrfXSfUVU7ciVOU?=
 =?iso-8859-1?Q?0MMow+LIEjq0l86Tg2vdyf9vzsDY6jDbLEuRlvDtUmYSzBvtPOHaUMaYB0?=
 =?iso-8859-1?Q?KEJewJFVYU+AJ1EHJ8dqXk5qXL63REH1U5tg5KhoEhEIgdUK+61ksi/W+E?=
 =?iso-8859-1?Q?HKyZV/0fS8gF9qmTCp52ofHoN3KWXix8c3Dp8xurZOqJLm/J7ccC90SbN4?=
 =?iso-8859-1?Q?RznCYhPgORKjovSU2QzDa7AfJqhYVYkGl5QZdRoajaaN0pTOniA8zOK40R?=
 =?iso-8859-1?Q?8u/aH3srlpVbUiErwZKGDZXqMka2GJDWNil2QJaJ+PD1UxSL8oKc1fzmnX?=
 =?iso-8859-1?Q?uVhgLCwTLEJCsZxe8oyi1AcSB9j0JNi19X5mD9HgeXwMtAAbd6yCoIhXI9?=
 =?iso-8859-1?Q?Zi4HbgMOyiuX5wWET5/viPH+kiu1L94AiCYVnyDUa5XgI5TXLlCX6PgnHj?=
 =?iso-8859-1?Q?/MZe28noKfvVsLvhpKYp3VDqWoS0csiiVrftw4NtMmofqAtlihLyX5WkL1?=
 =?iso-8859-1?Q?FXFs5lf4Ps9nfNYcCINM6D/HKPZObEZ4VS2Bz9f4oqq5wWu7gVgstrfgiB?=
 =?iso-8859-1?Q?z0e0X9L67PsjjKd3H+KSLh4+j/fWqmikJoAWl0UyBzWnOkbHZ68jc4DaxH?=
 =?iso-8859-1?Q?bfPrcp+1R8ZC7mK2i4VTD4mS9ObiBTsOGPjIJM3r792hnuC6rtQLvMLX1v?=
 =?iso-8859-1?Q?oP8QprZGboO+Ds4CzNukKFLBzUT1l2dI5U+9t4FAXSbb27prF8MgBQXsvZ?=
 =?iso-8859-1?Q?S8/Rx0nOhK4HA9vSjhyWWRX7XG0APL4M3/pipCoR2Cayu3msJ8Hx45KEFi?=
 =?iso-8859-1?Q?0DnMOc18Q3wNxH4vc1d9Hd9xxWhk4r2Io2vrIZwTNmCP6Ev6UT3AUom67O?=
 =?iso-8859-1?Q?Y0ysjNojOguxXlaEo4iOWBFTKJ3rgfIOwFcSqDB+Spaei1hSPQOVF8dGWw?=
 =?iso-8859-1?Q?PrwNFY3+TKe+8dw5olEi5zaxaVCBN9I894nrlZ63ZbpDis4VY/PNbsg0lm?=
 =?iso-8859-1?Q?1/+IrRRQxrCUzrTLb2Ctew5KLGAJ3eMHoQH82T38J3tbOyQXd4qKGW/+EO?=
 =?iso-8859-1?Q?eVjJsVKRqh21IPigjG59v77xyC0gplqrE0h6HE4Dw2WBi/31Oq+jj4ieFr?=
 =?iso-8859-1?Q?TAfaCzPOA/EfrTyIdo2Xgnwstoyk5nBDAJhEmA3Osk2hjIM1teO+yoEKy2?=
 =?iso-8859-1?Q?Q08Ci+eWCTU1meLD2NiCgdp8KHmmKe3eMgcqtR8EbnFX7D291USu3FjPZ7?=
 =?iso-8859-1?Q?ixGfbsF7/iLalTnBB/mBvuGaOKgkqLX3iZ03B5uPW8OjbZJrqZEBa3oVQ3?=
 =?iso-8859-1?Q?sZlSXEyWSBMxGLHY2e1e09CMLzUrUTDJz1WwMsQL2iy8Ht?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6101.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 426a14a0-7c48-459e-ce42-08da3cc4a2b3
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2022 14:00:46.7139
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Dbe2J8vPfg6SSiHHS+si989J4GxQOXIUebcTKGrL0XgS9JYkUlpYGduIc2o6tNbMJkdKB01mwACNmI6hupeLcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB2534
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[Public]



> -----Original Message-----
> From: Christian Casteyde <casteyde.christian@free.fr>
> Sent: Monday, May 23, 2022 08:03
> To: Kai-Heng Feng <kai.heng.feng@canonical.com>; Thorsten Leemhuis
> <regressions@leemhuis.info>
> Cc: stable@vger.kernel.org; regressions@lists.linux.dev; Deucher, Alexand=
er
> <Alexander.Deucher@amd.com>; gregkh@linuxfoundation.org; Limonciello,
> Mario <Mario.Limonciello@amd.com>
> Subject: Re: [REGRESSION] Laptop with Ryzen 4600H fails to resume video s=
ince
> 5.17.4 (works 5.17.3)
>=20
> Hello
>=20
> I've checked with 5.18 the problem is still there.
> Interestingly, I tried to revert the commit but it was rejected because o=
f the
> change in the test from:
>         if (!adev->in_s0ix)
> to:
>       if (amdgpu_acpi_should_gpu_reset(adev))
>=20
> in amdgpu_pmops_suspend.
>=20
> I fixed the rejection, keeping shoud_gpu_reset, but it still fails.
> Then I changed to restore test of in_s0ix as it was in 5.17, and it works=
.
> I tried with a call to amd_gpu_asic_reset without testing at all in_s0ix,=
 it
> works.
>=20
> Therefore, my APU wants a reset in amdgpu_pmops_suspend.
>=20
> By curiosity, I tried to do the reset in amdgpu_pmops_suspend_noirq as wa=
s
> intended in 5.18 original code, commenting out the test of
> amdgpu_acpi_should_gpu_reset(adev) (since this APU wants a reset).
> This does not work, I got the Fence timeout errors or freezes.
>=20
> If I leave  noirq function unchanged (original 5.18 code), and just add a
> reset in suspend() as was done in 5.17, it works.
>=20
> Therefore, my GPU does NOT want to be reset in noirq, the reset must be i=
n
> suspend.
>=20
> In other words, I modified amdgpu_pmops_suspend (partial revert) like thi=
s and
> this works on my laptop:
>=20
> static int amdgpu_pmops_suspend(struct device *dev)
> {
> 	struct drm_device *drm_dev =3D dev_get_drvdata(dev);
> 	struct amdgpu_device *adev =3D drm_to_adev(drm_dev);
> +	int r;
>=20
> 	if (amdgpu_acpi_is_s0ix_active(adev))
> 		adev->in_s0ix =3D true;
> 	else
> 		adev->in_s3 =3D true;
> -	return amdgpu_device_suspend(drm_dev, true);
> +	r =3D amdgpu_device_suspend(drm_dev, true);
> +	if (r)
> +		return r;
> +	if (!adev->in_s0ix)
> +		return amdgpu_asic_reset(adev);
> 	return 0;
> }
>=20
> static int amdgpu_pmops_suspend_noirq(struct device *dev)
> {
> 	struct drm_device *drm_dev =3D dev_get_drvdata(dev);
> 	struct amdgpu_device *adev =3D drm_to_adev(drm_dev);
>=20
> 	if (amdgpu_acpi_should_gpu_reset(adev))
> 		return amdgpu_asic_reset(adev);
>=20
> 	return 0;
> }
>=20
> I don't know if other APU want a reset, in the same context, and how to
> differentiate all the cases, so I cannot go further, but I can test patch=
es if
> needed.

The core of this problem is that your first suspend fails and the GPU is in=
 a bad
state for the next suspend.

I'm not sure why you're ignoring my other emails, but I did suggest a diffe=
rent
approach in this thread here:

https://patchwork.freedesktop.org/patch/486836/

Thanks,

>=20
> CC
>=20
> Le mercredi 18 mai 2022, 08:37:27 CEST Thorsten Leemhuis a =E9crit :
> > On 18.05.22 07:54, Kai-Heng Feng wrote:
> > > On Wed, May 18, 2022 at 1:52 PM Thorsten Leemhuis
> > >
> > > <regressions@leemhuis.info> wrote:
> > >> On 17.05.22 19:37, casteyde.christian@free.fr wrote:
> > >>> I've tryied to revert the offending commit on 5.18-rc7 (887f75cfd0d=
a
> > >>> ("drm/amdgpu: Ensure HDA function is suspended before ASIC reset"),=
 and
> > >>> the problem disappears so it's really this commit that breaks.
> > >>
> > >> In that case I'll update the regzbot status to make sure it's visibl=
e as
> > >> regression introduced in the 5.18 cycle:
> > >>
> > >> #regzbot introduced: 887f75cfd0da
> > >>
> > >> BTW: obviously would be nice to get this fixed before 5.18 is releas=
ed
> > >> (which might already happen on Sunday), especially as the culprit
> > >> apparently was already backported to stable, but I guess that won't =
be
> > >> easy...
> > >>
> > >> Which made me wondering: is reverting the culprit temporarily in
> > >> mainline (and reapplying it later with a fix) a option here?
> > >
> > > It's too soon to call it's the culprit.
> >
> > Well, sure, the root-cause might be somewhere else. But from the point
> > of kernel regressions (and tracking them) it's the culprit, as that's
> > the change that triggers the misbehavior. And that's how Linus
> > approaches these things as well when it comes to reverting to fix
> > regressions -- and he even might...
> >
> > > The suspend on the system
> > > doesn't work properly at the first place.
> >
> > ...ignore things like this, as long as a revert is unlikely to cause
> > more damage than good.
> >
> > Ciao. Thorsten
> >
> > >> Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' =
hat)
> > >>
> > >> P.S.: As the Linux kernel's regression tracker I deal with a lot of
> > >> reports and sometimes miss something important when writing mails li=
ke
> > >> this. If that's the case here, don't hesitate to tell me in a public
> > >> reply, it's in everyone's interest to set the public record straight=
.
>=20
>=20
>=20
