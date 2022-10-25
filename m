Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E44760CBA9
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 14:19:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231259AbiJYMTq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Oct 2022 08:19:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231511AbiJYMTo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Oct 2022 08:19:44 -0400
Received: from CHE01-ZR0-obe.outbound.protection.outlook.com (mail-zr0che01on2114.outbound.protection.outlook.com [40.107.24.114])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD6C63DBC9;
        Tue, 25 Oct 2022 05:19:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qt302slrZzViP8KTrC+8Q6IWA+9M2SL8YXxbh5dDP72+Q86Rgf24xGvtFZUnS00hODMj+9HjWvjvsz+ekkaPj+tFYsSgkmg8D1FN8AsLBnJmjCM9AvJ8PJvfXhqgKIFIFP+xQQL9WMdImxa9vsOSiF5vz51klWXoZhiAvcwEKzjws0a847d/KJ/WdXBP+Izg9FbNvDk2TpsWKZgiaWJthgj7fbSQbBJt98bGBlvAi9ruHPD31OUReFB31RFIcC0N6rslyUzTp671HYZxREzDLG14DVuLdUceH+3DumUKjJoCQC1gAmq/HxCKDvqFHdaMkjT1QNxRKYMaks9EaJyjZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wxc7XeVj8h11OShgFLe2DnXJM8hDZ68mkQeXt0fGhpg=;
 b=ikpwz8+I/ctXkrDf9HMGzYWFddrX2v4Urvu9qJGYKbctQr3Z+Byaux3QXv/hJjIWtCX6USr32PNaFo4muYFbuU28OqoN+wV/XczehR6Z+CFLJ6WyK3o6JJh63AVjVsyGIc3sTr3OERPMhZjMBHdSXTJj4hdmed0hYs7Fqs47mUI2gu3JzpbC3bXrjmXa2+jv4HF1nOb7DMvkI/AGSXuR5VnJCGfXlvBXIAuDptDSqEobqEMGhw5yYkTlYkZeZzLuCX8CUS3cSjog2ZkfGeXuNOoJWk1AwSAvhenNDLSaUa7baooELvQnPO42zhraqf6icj+qI5VxlAel4cs0kd9hyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=scs.ch; dmarc=pass action=none header.from=scs.ch; dkim=pass
 header.d=scs.ch; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=scs.ch; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wxc7XeVj8h11OShgFLe2DnXJM8hDZ68mkQeXt0fGhpg=;
 b=SSEQ4wsO4Qg0wmEA1iPKNn/p/hy1TYojRsE0hbvfAQriLp2b6XMqwJEw3cAGEPDNqgIyaUrnblg/6t7/qxe4y6eqVbeBRZI1IobIi7wm9vLTcuzYPXLqD3hQ+TOUEKkFjtQdw3XN/gsptIT3udPwd/nrILRcp6DNjvkeZGtHmGhJYzgz1eiiXsFlr2sbFXoZxBqVSHmd4Xi7pZ8jLmNAygJqts1NAPgnFgf2oenHUEe4vG2OrY2wC+t4R7cZZEjmmrdsAIwrOav8AV2+ZWz38BPlOETQx1baNBu9XS1OMZ6bup+DuUefwejL2/cumt71YnQ3Imw+pcF7IhfcHBaxMA==
Received: from ZR0P278MB0773.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:4d::10)
 by GV0P278MB0855.CHEP278.PROD.OUTLOOK.COM (2603:10a6:710:54::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.28; Tue, 25 Oct
 2022 12:19:39 +0000
Received: from ZR0P278MB0773.CHEP278.PROD.OUTLOOK.COM
 ([fe80::a72a:1fa7:a789:4222]) by ZR0P278MB0773.CHEP278.PROD.OUTLOOK.COM
 ([fe80::a72a:1fa7:a789:4222%9]) with mapi id 15.20.5746.028; Tue, 25 Oct 2022
 12:19:39 +0000
From:   Christian Bach <christian.bach@scs.ch>
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        "linux@roeck-us.net" <linux@roeck-us.net>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: tcpci module in Kernel 5.15.74 with PTN5110 not working correctly
Thread-Topic: tcpci module in Kernel 5.15.74 with PTN5110 not working
 correctly
Thread-Index: AdjoVYnpyrmyLmxITSiX1bJ23H/1egAFm5rg
Date:   Tue, 25 Oct 2022 12:19:39 +0000
Message-ID: <ZR0P278MB0773072DD153BA902AFE635AEB319@ZR0P278MB0773.CHEP278.PROD.OUTLOOK.COM>
References: <ZR0P278MB0773545F02B32FAF648F968AEB319@ZR0P278MB0773.CHEP278.PROD.OUTLOOK.COM>
In-Reply-To: <ZR0P278MB0773545F02B32FAF648F968AEB319@ZR0P278MB0773.CHEP278.PROD.OUTLOOK.COM>
Accept-Language: en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=scs.ch;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: ZR0P278MB0773:EE_|GV0P278MB0855:EE_
x-ms-office365-filtering-correlation-id: 42807f7b-358a-4f04-0b74-08dab683307a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vsqxuXOr3LmG288eiyMtEhzUubHo9nrHnGX+7GMahK4iTKzz4YCPfMVDmIxU7cCvCK3BUFCpXkap87WS9xBvraj/HVEJukC2in0ddPzooYmxAf6m+bi7cM/HwogimflixLIl4KFo/bFzVKTgGcOrBODLwiiTpBtJ8+b2WE1r2bz3cREEdDJtbrP6y4E35Ppkh008EitzFIqFax5im5Dz0GNE6KyWv5TC3NaZr3CVHiwVSnsvYo/3e+0k4ecc2YrzJXP7aqZODDGpW5am8jbKLyFZWfr9EBMKSOthugIJEEI9myQsy/sehNtIKog1rNgYOKvM1kIQNNr1npJz+VsekIZ7NfLv3bh0wfZJT0/eYNjeep7JJ7rhw8RRAF5Bx8f11TMS/3Y6vXuDvYia9c8dFO8OdJ7pZP1HbNjPdeWE7FJA1T165yH9kMyhJiWCBLR9/7fz1X13ZdVyI0ZQUGzboqzbo1m8z2jJ4ZirnoLLkjlvHmvX0Ih33FCP78mHyu8p3GBeUI3BxpfPUyT6zHeQnCNp/BxyPahTnnrJhfsLnQE+GBqGPwiwtn6QlBm/hr4wI15sIp8mwx4hQrZyvrWwdye+XucP+QqjFLk1MaHWdzZdg9dfyZDpcmNA/3fnydYOswgte8sv23tSlOxn6ieO5wGrk5+Rvx/O4FOQ2J0u6OhAUFmsLYLZvm3oSi0JTm3tBmCl9/lktrJwYKhMmMgf2gExeo23yKCNvhVwYGeoiKSnlH/lpW36BbPv1jDDqqf/RgpXfMmyMyL/lnWB27jPzc4ZMIfPpOSgcal+2tgdiFY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZR0P278MB0773.CHEP278.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(366004)(136003)(396003)(346002)(39840400004)(376002)(451199015)(41300700001)(54906003)(478600001)(5660300002)(966005)(8936002)(33656002)(83380400001)(38070700005)(38100700002)(55016003)(66446008)(44832011)(64756008)(2906002)(8676002)(66946007)(4326008)(66476007)(66556008)(71200400001)(316002)(52536014)(6916009)(76116006)(2940100002)(9686003)(186003)(66574015)(26005)(122000001)(86362001)(6506007)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?SLJ/AtFzocN+ULe1FKZzLaoVlE2zLbKH+GbHYKSPH23TGKQRmScj2HJAsH?=
 =?iso-8859-1?Q?QMOCT6QtemWHdFBo+O9f2VKS91iwLy94xphnLXgzu9tabw/aU4p+gHUFBm?=
 =?iso-8859-1?Q?jmJcEIsiAfHpuaR15cVQZW/0yFhOLKRWjzxaVifD66yTUNAOfVvHaME90F?=
 =?iso-8859-1?Q?qgUjIVFNN3iAd5jQv0Fjj/kptxij7ars2tuM7uQfMWaX62D9FfOUp6qPpp?=
 =?iso-8859-1?Q?xqOcxwVp+kcwB0tcerZK/YwPXYZtGKWzXtDG03ibwbI2KKcbfr8ReKPV7P?=
 =?iso-8859-1?Q?gCpY1xZ6XVLd5xtB4Qp3lgxThaP5mDMRvrUtCVRNuKzqO46Ck7GFa6A6WU?=
 =?iso-8859-1?Q?xQQzXVW0DXe+EVRaTCJHaYkXwtDEeSHsNA/8Yy4AMBZUAHXIXR9eJ2fpt7?=
 =?iso-8859-1?Q?WJk3EwfAKxA39zTQHoSp72PqAFdkb/3fu2ay7iH2oMJu5uwXdTW4ilJgK8?=
 =?iso-8859-1?Q?Dm+fRe6aS2YS9kYqWxkOGKa8WMyiTblQ7KhS6oKDLyQ83vCFNz6Xx5660R?=
 =?iso-8859-1?Q?6XEGuz/u95wNxGRYoEFxQ+ZuY9PiMgXM0JuSUZs49kHjiRc0zP1g9yDh3g?=
 =?iso-8859-1?Q?cUrguL8Y9D23uooFTF7gZeAHnvFSTaOwDnNHtGZ7CuedC3EXhqQfm/37rx?=
 =?iso-8859-1?Q?FOuAJKl2gLRZ2pgTROw+WCKe1lUnSUadQztf69EyNAkkb7ayM558ZS9wGe?=
 =?iso-8859-1?Q?VLxGnTJiM+mDP2a2W3OtSfjH2i77Qtd2jHUfTgDfe56Jd9wNtvZONGViqT?=
 =?iso-8859-1?Q?ixoRJ+6t83C3eGy4qxIkjm+Batr/gpB57TZUeSSkShSorZYfYR4p9Gb/6c?=
 =?iso-8859-1?Q?kv5qO53H1wAmB2A0SNLB2dmdXl4oktHpx9WV+OZAvYCRjt8wUK0yOXesyB?=
 =?iso-8859-1?Q?pfhVduUTF1DVnrUxsIgT6ECa4ni6AaML4YqOE2OQLPtujsQzFPv5/M4J2N?=
 =?iso-8859-1?Q?3oND1lDc94Qs7agErZt5d5ttnHPbZN4nI3jcoH5H3Te7ebO9dd289JNCOV?=
 =?iso-8859-1?Q?kbGMkvvlMF5oWLrFz7rdFi5C4mH4Z6S7UDnkUGKiCuOHFr8r/y7sjaMigS?=
 =?iso-8859-1?Q?6dOiWUx9WjPeHwok4YD0rD7YfiSy+NxXNZmaadMt9cBVbU+bFz+BqDYz8D?=
 =?iso-8859-1?Q?rde99UzpCIspTaE46LkYODuUVuc5XXCgF1uQbdzJmgpRI/wuwVJrejoU8X?=
 =?iso-8859-1?Q?w9MJQlatnvSpMMYv0x4JCV5GsQqSfpyU+Z8+YZzmf0ayZSfGJTCA9MGxrt?=
 =?iso-8859-1?Q?l84a4EZfgfeHUnSq9gppaS9Kc92N+YWMW7lz7KZuS/EGCtjXqBymOpp0Bo?=
 =?iso-8859-1?Q?heTlrmIu48HzU+NeC1u4tJcygWSgKt2QXx6sKPAgu6ThwIp6Lbw2agyWpR?=
 =?iso-8859-1?Q?+9do7pE4kfmZrt7sc/VVu76tVTgb4gSFX+9LBOUliLPk4u4bd/pzknO4sA?=
 =?iso-8859-1?Q?rkdjIgivOG3qRRIub0OS2hn0RUWUmmUAmnU2egux0zoWYA0PsScn7VSkUa?=
 =?iso-8859-1?Q?Bgbk4qG+SuxHwvlvJ6Aqqc4goCwFHLRZrlK1gnU66EHgOwsZQ5coQ0HS4Z?=
 =?iso-8859-1?Q?WHariusqKuszvzPJy/lpj56MqPCIbLaM7sw5cSJP/LQnEpJFNca9sk5dSj?=
 =?iso-8859-1?Q?0MBXc7bPtPGTVJOF97TxPhPT8tWmUGfDtz?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: scs.ch
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: ZR0P278MB0773.CHEP278.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 42807f7b-358a-4f04-0b74-08dab683307a
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Oct 2022 12:19:39.6153
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 1b8c3cb6-94f9-44ce-91ec-7183fd2364b2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /DLwMbtlxzST7LkK0MmscPsHtOFY4QosicSzLBrdz661WE2n3fOtzVlDhH0N2bvIWoJUZk28SDdOevJTFFiEvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV0P278MB0855
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello

For a few weeks now I am trying to make the PTN5110 chip work with the new =
Kernel 5.15.74. The same hardware setup was working with the 4.19.72 Kernel=
. The steps I took so far are as follows:
1. Study the Documentation and look at example Device Tree's in the Kernel
2. Try out different Device Tree configurations derived from the Documentat=
ion and examples
3. I did look on Stackoverflow, the NXP and other forums for any similar is=
sue but could not find any
4. Updating the Kernel to the newest Version I was able to find: 5.15.74 (H=
ash: f0bee94053065c7cb8eacadfdd6bf739a2042b35 in Repo: git://git.yoctoproje=
ct.org/linux-yocto.git;branch=3Dv5.15/standard/base)
5. Downgrade to the earliest Kernel possible: v5.10-rc1 (Hash: 3650b228f83a=
dda7e5ee532e2b90429c03f7b9ec in Repo: git://git.yoctoproject.org/linux-yoct=
o.git;branch=3Dv5.15/standard/base)

None of those steps had any effect. Every time I plug in a USB-A to USB-C c=
able the Kernel gets stuck in the ISR until I unplug the cable. (Attaching =
a full USB-PD capable Power Source over a USB-C cable works fine)
This results in an unreasonable high CPU usage (most of the times the CPU g=
ets blocked completely).

I did analyze the I2C bus and found that the old Kernel did change many con=
figurations after the A-C cable got attached while the new Kernel does noth=
ing (please see logs below).
I also did compare what happens on the I2C bus during chip initialization b=
ut did not find any mentionable differences.

My HW setup is an i.mx6ul with the PTN5110 attached on I2C4.

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
My device tree looks like this:
/ {
=A0=A0=A0=A0=A0=A0=A0=A0 regulators {
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 compatible =3D "simple-bus=
";
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 #address-cells =3D <1>;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 #size-cells =3D <0>;

=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 reg_usb_otg1_vbus: regulat=
or@2 {
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
 compatible =3D "regulator-fixed";
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
 reg =3D <2>;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
 regulator-name =3D "usb_otg1_vbus";
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
 pinctrl-names =3D "default";
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
 pinctrl-0 =3D <&pinctrl_usb_otg1_vbus>;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
 regulator-min-microvolt =3D <5000000>;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
 regulator-max-microvolt =3D <5000000>;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
 gpio =3D <&gpio2 8 GPIO_ACTIVE_HIGH>;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
 enable-active-high;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
 status =3D "okay";
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 };
=A0=A0=A0=A0=A0=A0=A0=A0 };
};

&usbotg1 {
=A0=A0=A0=A0=A0=A0=A0=A0 /*pinctrl-names =3D "default";
=A0=A0=A0=A0=A0=A0=A0=A0 pinctrl-0 =3D <&pinctrl_usbotg1>;*/
=A0=A0=A0=A0=A0=A0=A0=A0 dr_mode =3D "otg";
=A0=A0=A0=A0=A0=A0=A0=A0 status =3D "okay";
=A0=A0=A0=A0=A0=A0=A0=A0 disable-over-current;
=A0=A0=A0=A0=A0=A0=A0=A0 vbus-supply =3D <&reg_usb_otg1_vbus>;
};

&i2c4 {
=A0=A0=A0=A0=A0=A0=A0=A0 clock-frequency =3D <100000>;
=A0=A0=A0=A0=A0=A0=A0=A0 pinctrl-names =3D "default";
=A0=A0=A0=A0=A0=A0=A0=A0 pinctrl-0 =3D <&pinctrl_i2c4>;
=A0=A0=A0=A0=A0=A0=A0=A0 status =3D "okay";

=A0=A0=A0=A0=A0=A0=A0=A0 usb_pd: ptn5110@50 {
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 compatible =3D "nxp,ptn511=
0";
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 reg =3D <0x50>;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 pinctrl-names =3D "default=
";
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 pinctrl-0 =3D <&pinctrl_us=
b_pd>;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 interrupt-parent =3D <&gpi=
o2>;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 interrupts =3D <11 IRQ_TYP=
E_LEVEL_LOW>;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 wakeup-source;

=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 usb_con: connector {
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
 compatible =3D "usb-c-connector";
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
 label =3D "USB-C";
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
 data-role =3D "dual";
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
 power-role =3D "dual";
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
 try-power-role =3D "sink";
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
 source-pdos =3D <PDO_FIXED(VSAFE5V, 2000, PDO_FIXED_USB_COMM | PDO_FIXED_D=
UAL_ROLE)>;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
 sink-pdos =3D <PDO_FIXED(VSAFE5V, 2000, PDO_FIXED_USB_COMM | PDO_FIXED_DUA=
L_ROLE)
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 //PDO_FIXED(VSAFE5V, 3000, 0)
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 //PDO_FIXED(9000, 3000, 0)
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 PDO_FIXED(12000, 3000, 0)
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0PDO_FIXED(20000, 3000, 0)>;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 //PDO_FIXED(20000, 5000, 0)>;
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
 op-sink-microwatt =3D <10000000>;

=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 };
=A0=A0=A0=A0=A0=A0=A0=A0 };
};

&iomuxc {
=A0=A0=A0=A0=A0=A0=A0=A0 pinctrl_i2c4: i2c4grp {
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 fsl,pins =3D <
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
 MX6UL_PAD_UART2_TX_DATA__I2C4_SCL 0x4001b8b0
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
 MX6UL_PAD_UART2_RX_DATA__I2C4_SDA 0x4001b8b0
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 >;
=A0=A0=A0=A0=A0=A0=A0=A0 };

=A0=A0=A0=A0=A0=A0=A0=A0 pinctrl_usb_pd: usbpdgrp {
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 fsl,pins =3D <
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
 MX6UL_PAD_ENET2_TX_DATA0__GPIO2_IO11=A0=A0=A0=A0=A0 0x0001b020 /* Alert In=
terrupt */
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
 MX6UL_PAD_ENET2_TX_CLK__GPIO2_IO14=A0=A0=A0=A0=A0=A0=A0 0x0001b020 /* Faul=
t Interrupt */
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 >;
=A0=A0=A0=A0=A0=A0=A0=A0 };

=A0=A0=A0=A0=A0=A0=A0=A0 pinctrl_usb_otg1_vbus: usbotg1 {
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 fsl,pins =3D <
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
 MX6UL_PAD_ENET2_RX_DATA0__GPIO2_IO08=A0=A0=A0=A0=A0 0x000000b9
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
 MX6UL_PAD_ENET2_RX_DATA1__USB_OTG1_OC=A0=A0=A0=A0 0x000010b0
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 >;
=A0=A0=A0=A0=A0=A0=A0=A0 };
};

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
I2C Log on plug in event of Kernel 5.15.68:
Direction=A0 | Address=A0 | Data
-------------------------------
Read=A0=A0=A0=A0=A0=A0 | 10=A0=A0=A0=A0=A0=A0 | 02 22
Write=A0=A0=A0=A0=A0 | 10=A0=A0=A0=A0=A0=A0 | 02 22
Read=A0=A0=A0=A0=A0=A0 | 14=A0=A0=A0=A0=A0=A0 | 04
Read=A0=A0=A0=A0=A0=A0 | 10=A0=A0=A0=A0=A0=A0 | 02 02
Write=A0=A0=A0=A0=A0 | 10=A0=A0=A0=A0=A0=A0 | 02 02
Read=A0=A0=A0=A0=A0=A0 | 1E=A0=A0=A0=A0=A0=A0 | 0C
Read=A0=A0=A0=A0=A0=A0 | 14=A0=A0=A0=A0=A0=A0 | 04
Read=A0=A0=A0=A0=A0=A0 | 10=A0=A0=A0=A0=A0=A0 | 03 02
Write=A0=A0=A0=A0=A0 | 10=A0=A0=A0=A0=A0=A0 | 03 02
Read=A0=A0=A0=A0=A0=A0 | 1E=A0=A0=A0=A0=A0=A0 | 0C
Read=A0=A0=A0=A0=A0=A0 | 1A=A0=A0=A0=A0=A0=A0 | 4A
Read=A0=A0=A0=A0=A0=A0 | 14=A0=A0=A0=A0=A0=A0 | 04
Read=A0=A0=A0=A0=A0=A0 | 1D=A0=A0=A0=A0=A0=A0 | 11
Read=A0=A0=A0=A0=A0=A0 | 1E=A0=A0=A0=A0=A0=A0 | 0C

Pause for 200ms

Read=A0=A0=A0=A0=A0=A0 | 1A=A0=A0=A0=A0=A0=A0 | 4A
Read=A0=A0=A0=A0=A0=A0 | 1A=A0=A0=A0=A0=A0=A0 | 4A
Read=A0=A0=A0=A0=A0=A0 | 1D=A0=A0=A0=A0=A0=A0 | 11
Write=A0=A0=A0=A0=A0 | 1A=A0=A0=A0=A0=A0=A0 | 0E
Write=A0=A0=A0=A0=A0 | 19=A0=A0=A0=A0 =A0=A0| 00
Write=A0=A0=A0=A0=A0 | 2E=A0=A0=A0=A0=A0=A0 | 02
Write=A0=A0=A0=A0=A0 | 23=A0=A0=A0=A0=A0=A0 | 66
Write=A0=A0=A0=A0=A0 | 23=A0=A0=A0=A0=A0=A0 | 55
Write=A0=A0=A0=A0=A0 | 2F=A0=A0=A0=A0=A0=A0 | 21

Pause for 300ms

Write=A0=A0=A0=A0=A0 | 51=A0=A0=A0=A0=A0=A0 | 02
Write=A0=A0=A0=A0=A0 | 52=A0=A0=A0=A0=A0=A0 | 00 00
Write=A0=A0=A0=A0=A0 | 50=A0=A0=A0=A0=A0=A0 | 25
Read=A0=A0=A0=A0=A0=A0 | 10=A0=A0=A0=A0=A0=A0 | 50 02
Write=A0=A0=A0=A0=A0 | 10=A0=A0=A0=A0=A0=A0 | 50 02
Read=A0=A0=A0=A0=A0=A0 | 10=A0=A0=A0=A0=A0=A0 | 00 02
Write=A0=A0=A0=A0=A0 | 10=A0=A0=A0=A0=A0=A0 | 00 02
Write=A0=A0=A0=A0=A0 | 72=A0=A0=A0=A0=A0=A0 | 8C 00
Read=A0=A0=A0=A0=A0=A0 | 1C=A0=A0=A0=A0=A0=A0 | 60
Read=A0=A0=A0=A0=A0=A0 | 10=A0=A0=A0=A0=A0=A0 | 00 02
Write=A0=A0=A0=A0=A0 | 10=A0=A0=A0=A0=A0=A0 | 00 02
Write=A0=A0=A0=A0=A0 | 2F=A0=A0=A0 =A0=A0=A0| 00
Read=A0=A0=A0=A0=A0=A0 | 1C=A0=A0=A0=A0=A0=A0 | 60
Read=A0=A0=A0=A0=A0=A0 | 10=A0=A0=A0=A0=A0=A0 | 00 02
Write=A0=A0=A0=A0=A0 | 10=A0=A0=A0=A0=A0=A0 | 00 02
Write=A0=A0=A0=A0=A0 | 2E=A0=A0=A0=A0=A0=A0 | 02
Read=A0=A0=A0=A0=A0=A0 | 10=A0=A0=A0=A0=A0=A0 | 00 02
Write=A0=A0=A0=A0=A0 | 10=A0=A0=A0=A0=A0=A0 | 00 02
Read=A0=A0=A0=A0=A0=A0 | 10=A0=A0=A0=A0=A0=A0 | 00 02
Write=A0=A0=A0=A0=A0 | 10=A0=A0=A0=A0=A0=A0 | 00 02
Read=A0=A0=A0=A0=A0=A0 | 10=A0=A0=A0=A0=A0=A0 | 00 02
Write=A0=A0=A0=A0=A0 | 10=A0=A0=A0=A0=A0=A0 | 00 02
Read=A0=A0=A0=A0=A0=A0 | 10=A0=A0=A0=A0=A0=A0 | 00 02
Write=A0=A0=A0=A0=A0 | 10=A0=A0=A0=A0=A0=A0 | 00 02
(It will loop like this until the cable gets detached)


I2C Log on plug in event of Kernel 5.15.68:
Direction=A0 | Address=A0 | Data
-------------------------------
Read=A0=A0=A0=A0=A0=A0 | 10=A0=A0=A0=A0=A0=A0 | 02 22
Write=A0=A0=A0=A0=A0 | 10=A0=A0=A0=A0=A0=A0 | 02 22
Read=A0=A0=A0=A0=A0=A0 | 14=A0=A0=A0=A0=A0=A0 | 04
Read=A0=A0=A0=A0=A0=A0 | 10=A0=A0=A0=A0=A0=A0 | 02 02
Write=A0=A0=A0=A0=A0 | 10=A0=A0=A0=A0=A0=A0 | 02 02
Read=A0=A0=A0=A0=A0=A0 | 1E=A0=A0=A0=A0=A0=A0 | 0C
Read=A0=A0=A0=A0=A0=A0 | 14=A0=A0=A0=A0=A0=A0 | 04
Read=A0=A0=A0=A0=A0=A0 | 10=A0=A0=A0=A0=A0=A0 | 02 02
Write=A0=A0=A0=A0=A0 | 10=A0=A0=A0=A0=A0=A0 | 02 02
Read=A0=A0=A0=A0=A0=A0 | 1E=A0=A0=A0=A0=A0=A0 | 0C
Read=A0=A0=A0=A0=A0=A0 | 14=A0=A0=A0=A0=A0=A0 | 04
Read=A0=A0=A0=A0=A0=A0 | 1E=A0=A0=A0=A0=A0=A0 | 0C

Pause for 200ms

Read=A0=A0=A0=A0=A0=A0 | 10=A0=A0=A0=A0=A0=A0 | 01 02
Write=A0=A0=A0=A0=A0 | 10=A0=A0=A0=A0=A0=A0 | 01 02
Read=A0=A0=A0=A0=A0=A0 | 1D=A0=A0=A0=A0=A0=A0 | 11

Pause for 250ms

Read=A0=A0=A0=A0=A0=A0 | 1A=A0=A0=A0=A0=A0=A0 | 4A
Write=A0=A0=A0=A0=A0 | 1A=A0=A0=A0=A0 =A0=A0| 4E
Write=A0=A0=A0=A0=A0 | 19=A0=A0=A0=A0=A0=A0 | 00
Write=A0=A0=A0=A0=A0 | 2E=A0=A0=A0=A0=A0=A0 | 02
Write=A0=A0=A0=A0=A0 | 23=A0=A0=A0=A0=A0=A0 | 66
Write=A0=A0=A0=A0=A0 | 23=A0=A0=A0=A0=A0=A0 | 55
Write=A0=A0=A0=A0=A0 | 2F=A0=A0=A0=A0=A0=A0 | 21

Pause for 4ms

Write=A0=A0=A0=A0=A0 | 51=A0=A0=A0=A0=A0=A0 | 02
Write=A0=A0=A0=A0=A0 | 52=A0=A0=A0=A0=A0=A0 | 00 00
Write=A0=A0=A0=A0=A0 | 50=A0=A0=A0=A0=A0=A0 | 35
Read=A0=A0=A0=A0=A0=A0 | 10=A0=A0=A0=A0=A0=A0 | 50 02
Write=A0=A0=A0=A0=A0 | 10=A0=A0=A0=A0=A0=A0 | 50 02
Read=A0=A0=A0=A0=A0=A0 | 10=A0=A0=A0=A0=A0=A0 | 00 02
Write=A0=A0=A0=A0=A0 | 10=A0=A0=A0=A0=A0=A0 | 00 02
Write=A0=A0=A0=A0=A0 | 2F=A0=A0=A0=A0=A0=A0 | 00
Read=A0=A0=A0=A0=A0=A0 | 10=A0=A0=A0=A0=A0=A0 | 00 02
Write=A0=A0=A0=A0=A0 | 10=A0=A0=A0=A0=A0=A0 | 00 02
Read=A0=A0=A0=A0=A0=A0 | 1C=A0=A0=A0=A0=A0=A0 | 60
Read=A0=A0=A0=A0=A0=A0 | 10=A0=A0=A0=A0=A0=A0 | 00 02
Write=A0=A0=A0=A0=A0 | 10=A0=A0=A0=A0=A0=A0 | 00 02
Write=A0=A0=A0=A0=A0 | 23=A0=A0=A0=A0=A0=A0 | 66
Read=A0=A0=A0=A0=A0=A0 | 10=A0=A0=A0=A0=A0=A0 | 02 02
Write=A0=A0=A0=A0=A0 | 10=A0=A0=A0=A0=A0=A0 | 02 02
Write=A0=A0=A0=A0=A0 | 23=A0=A0=A0=A0=A0=A0 | 44
Read=A0=A0=A0=A0=A0=A0 | 14=A0=A0=A0=A0=A0=A0 | FF
Write=A0=A0=A0=A0=A0 | 2E=A0=A0=A0=A0=A0=A0 | 02
Read=A0=A0=A0=A0=A0=A0 | 1E=A0=A0=A0=A0=A0=A0 | 0C
Write=A0=A0=A0=A0=A0 | 10=A0=A0=A0=A0=A0=A0 | FF FF
Write=A0=A0=A0=A0=A0 | 14=A0=A0=A0=A0=A0=A0 | 04
Write=A0=A0=A0=A0=A0 | 23=A0=A0=A0=A0=A0=A0 | 33
Write=A0=A0=A0=A0=A0 | 12=A0=A0=A0=A0=A0=A0 | 7F 00
Write=A0=A0=A0=A0=A0 | 2F=A0=A0=A0=A0=A0=A0 | 00
Write=A0=A0=A0=A0=A0 | 23=A0=A0=A0=A0=A0=A0 | 66
Write=A0=A0=A0=A0=A0 | 23=A0=A0=A0=A0=A0=A0 | 44
Read=A0=A0=A0=A0=A0=A0 | 1C=A0=A0=A0=A0=A0=A0 | 60
Read=A0=A0=A0=A0=A0=A0 | 1A=A0=A0=A0=A0=A0=A0 | 4E
Write=A0=A0=A0=A0=A0 | 1A=A0=A0=A0=A0=A0=A0 | 4E
Write=A0=A0=A0=A0=A0 | 19=A0=A0=A0=A0=A0=A0 | 00
Write=A0=A0=A0=A0=A0 | 2E=A0=A0=A0=A0=A0=A0 | 02
Read=A0=A0=A0=A0=A0=A0 | 1E=A0=A0=A0=A0=A0=A0 | 0C
Read=A0=A0=A0=A0=A0=A0 | 1D=A0=A0=A0=A0=A0=A0 | 11
Write=A0=A0=A0=A0=A0 | 2F=A0=A0=A0=A0=A0=A0 | 00
Write=A0=A0=A0=A0=A0 | 23=A0=A0=A0=A0=A0=A0 | 66
Write=A0=A0=A0=A0=A0 | 23=A0=A0=A0=A0=A0=A0 | 44
Read=A0=A0=A0=A0=A0=A0 | 1C=A0=A0=A0=A0=A0=A0 | 60
Read=A0=A0=A0=A0=A0=A0 | 1A=A0=A0=A0=A0=A0=A0 | 4E
Write=A0=A0=A0=A0=A0 | 1A=A0=A0=A0=A0=A0=A0 | 4E
Write=A0=A0=A0=A0=A0 | 19=A0=A0=A0=A0=A0=A0 | 00
Write=A0=A0=A0=A0=A0 | 2E=A0=A0=A0=A0=A0=A0 | 02
Write=A0=A0=A0=A0=A0 | 1A=A0=A0=A0=A0=A0=A0 | 0F
Read=A0=A0=A0=A0=A0=A0 | 10=A0=A0=A0=A0=A0=A0 | 01 02
Write=A0=A0=A0=A0=A0 | 10=A0=A0=A0=A0=A0=A0 | 01 02
Read=A0=A0=A0=A0=A0=A0 | 1D=A0=A0=A0=A0=A0=A0 | 00
Write=A0=A0=A0=A0=A0 | 1A=A0=A0=A0=A0 =A0=A0| 4A
Write=A0=A0=A0=A0=A0 | 23=A0=A0=A0=A0=A0=A0 | 99
Read=A0=A0=A0=A0=A0=A0 | 10=A0=A0=A0=A0=A0=A0 | 01 02
Write=A0=A0=A0=A0=A0 | 10=A0=A0=A0=A0=A0=A0 | 01 02
Read=A0=A0=A0=A0=A0=A0 | 1D=A0=A0=A0=A0=A0=A0 | 11
(no more communication after this point)

--=A0
Dipl. El-Ing. FH Christian Bach, Projektleiter
Direct +41 43 456 16 96=A0 . =A0http://www.scs.ch
Supercomputing Systems AG=A0 . =A0Technoparkstrasse 1=A0 . =A0CH-8005 Z=FCr=
ich=A0

