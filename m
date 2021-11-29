Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE5E8461A49
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 15:49:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241965AbhK2Ow7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 09:52:59 -0500
Received: from mail-bn7nam10on2043.outbound.protection.outlook.com ([40.107.92.43]:63689
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1345139AbhK2Ou6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Nov 2021 09:50:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OnaVguZdDL+Lg05EZZIT96ZcMaF3tHZjbUPxom/H8Gk6T1tEkRYHYiMBPjKXm4Qyg1Qe3sjvOkypyYDxA4YB5CDYSejYG1cq4Yy8XVhKzYYzL7rt2wutFqL5ILfGJTDZRopaBYPMFXU/52yqnmER11TnxyRt/XdhM9aCEW/EP+rP/2Dvpyt/YYT29Ra3irzUXizSF4LzIVKWmEj7ATKiac7K/JmqqjsA0ZDK3bj0Xb/cDrm0jdMrrjNvF4iP9diIG38YMW3zUD/HTnlFmzyfX88idSvospCyO+P3x0j6NF1giXt+F64yMoTIGbgXYG5o/Xh5d3D8mE57CpxlNjZkLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v12XWVoa3nelabFHIGCp6+aH2dVSEhxF6KX7IQlG5Sg=;
 b=OFnKQYwEbpOm6mOF0bvzkn7tK1B+g141hZ1GLadBvQpIs2XH2qEfN4rqg1hyeMK1WpviVzEruGMVKQB7KMM2PdV/SyUBh/JrdB2JJ2MRyBvdbbnQITHp+/VyxLH3cVMUVmFe2vvDU4n+diVsVnHgpNQEK96bViHKo17C7uEHX7NLA7e3s4XathYt108HF8oA2KXeNtZARUlm+NuzKuLzOt/JM8RubiWrCeFMgR6UU5ADVT7HGITU8qUd58LvOdI+e3Djp6YcVTdnveGoecTgo8cDnQQPzyCVIr6Xg5p59qEgx/VYWX6O1xyY82a4q7mslLDfJ9GXoRdpiT+TTWmCkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v12XWVoa3nelabFHIGCp6+aH2dVSEhxF6KX7IQlG5Sg=;
 b=hUuAlRJAjidd/bvuW8fZoiFoicntKUvP9ynQHLAOLBf/5iSc5eaIPj3JCEIard8Z3xE0rv4QoqcMv1dtCr2oW2Y5z4hVBjpu5ku8trpFoc7WV5I/40GUYCEjJCyyTZ39eEe4Qdz8ZfvM7cnf3aISYklgo10JNnysx6nrhAnWhF0=
Received: from SA0PR12MB4510.namprd12.prod.outlook.com (2603:10b6:806:94::8)
 by SN6PR12MB2784.namprd12.prod.outlook.com (2603:10b6:805:68::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Mon, 29 Nov
 2021 14:47:38 +0000
Received: from SA0PR12MB4510.namprd12.prod.outlook.com
 ([fe80::7cbc:2454:74b9:f4ea]) by SA0PR12MB4510.namprd12.prod.outlook.com
 ([fe80::7cbc:2454:74b9:f4ea%6]) with mapi id 15.20.4734.024; Mon, 29 Nov 2021
 14:47:38 +0000
From:   "Limonciello, Mario" <Mario.Limonciello@amd.com>
To:     Sasha Levin <sashal@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     Joerie de Gram <j.de.gram@gmail.com>,
        "Natikar, Basavaraj" <Basavaraj.Natikar@amd.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "S-k, Shyam-sundar" <Shyam-sundar.S-k@amd.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
Subject: RE: [PATCH AUTOSEL 5.10 10/28] pinctrl: amd: Fix wakeups when IRQ is
 shared with SCI
Thread-Topic: [PATCH AUTOSEL 5.10 10/28] pinctrl: amd: Fix wakeups when IRQ is
 shared with SCI
Thread-Index: AQHX4m4UdZRH6Wi0x0mokfnrOvar9Kwamwvw
Date:   Mon, 29 Nov 2021 14:47:37 +0000
Message-ID: <SA0PR12MB4510E32F459655B6387A8660E2669@SA0PR12MB4510.namprd12.prod.outlook.com>
References: <20211126023343.442045-1-sashal@kernel.org>
 <20211126023343.442045-10-sashal@kernel.org>
In-Reply-To: <20211126023343.442045-10-sashal@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 878ad770-b763-448d-4898-08d9b3473051
x-ms-traffictypediagnostic: SN6PR12MB2784:
x-microsoft-antispam-prvs: <SN6PR12MB27843C5B36DE5469659FED04E2669@SN6PR12MB2784.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: anezeWfCaE9qL7pNCfHcmUnbs27QbrquWCPC7wBPwoO2gfChX+6RmvKlxGcLASlmQb1LmrlwPab6U9B0mSJxOtn2+KTeZZ+NrPlC4hZuQCHjQh9pWNf0ggdFhgOEegGT8K3EWXr4NZXBnAsc3+5QYG3cR9PiUC4py1fGlmZWBDP9fL4NF1vIBiF7g/f8LFZgDY8d2wjA2j46BX2soZkGC0ityNBz+WdqM5FO7Pecd25HAQEfELe9xqzuZcjuEgv9l6/Th+RkNCfVyNG3Ao0g/wM5wbsYonOSwgtbvumpdFXDCDvrOGBUYtS2q/eHLk1m0B6QWx6cgmpOLxWZzqsPMjMVcnsGdYyHU7PYUHJq/+Tgt3tFrMu14qAGPeAo+RYd9ovf1f57GEgMSNs8RE58aDRlGTWWez6WwpdW7UwoyWZvtcKNiccZ+IdqrIK4/Ed/+AhA+wYuxUTV0Yr7rn6WNsADCJ0OOLK6OqgSj6dfraQR6Q58NLM1kayA68v3ye+96+Wd60vjOU1X5lAyuPnOtLnUtnuz/L+TjqT76Yz45WTjO/WgCdEXjyr5zPgulvotvPRFtUcpZQ4gLj4k7kINtSKHx1xJ8wJYTO8ja3wH3tXrB9G2INlxs8/wT1zpL72DzPjFH3lFLD9sxsTMHOHUPZp/rc1dYgNUn+bu+dq7wO6LR7evfh/wWjFkG+VmHEvVBq05VQKwo5DE7a5tVdEz+y4YmQGolKCofj4ZJN7nEk8Wp5l6cqCxIrA+XsRIZRcEm3FBPuuquJELP2y37DcaWgzagBTvFiLNnhnfbZEOth72oVAc4Vaw07qyqseiTvtUprQtcjiViQO+iRz4HqOQhQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR12MB4510.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(508600001)(55016003)(71200400001)(45080400002)(53546011)(5660300002)(7696005)(26005)(52536014)(54906003)(966005)(122000001)(316002)(66946007)(86362001)(8676002)(110136005)(83380400001)(2906002)(66476007)(186003)(4326008)(66556008)(66446008)(76116006)(64756008)(38070700005)(8936002)(33656002)(6506007)(38100700002)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?aDPiN5Q6hPSjsj4DOjqIn2XcPVMzi+SQWOynmyJNnGLlVW2ygGOb2lnJ6JU4?=
 =?us-ascii?Q?/hTdrcrsJ3OWn7YeNUq7JU0njh7BSwpGkNfysQaie8R/oOJ1FljsdhzE/VBp?=
 =?us-ascii?Q?YJ2DT301gknQWLLBGfIlJ2GkTQX4gVQ/xRHNcxXyF5UlAmCB4eLL8VO6l0ZR?=
 =?us-ascii?Q?s+CYUjIWZznMUTatSTaAvNJn050NESVnFkZQouajZXTaWkSuLJ651OTFBiyR?=
 =?us-ascii?Q?gpAQhQ1b7jRUWUlnZD+71oxCdWu+uuKGBOPIGp7JOuUrvpMWPoLyEt9VYzVK?=
 =?us-ascii?Q?/6X1r4fWkskjFtKFGf8oDCS4DIi9r86J7Ex3VREYw4zQ52qOD9m6Zi/KWorm?=
 =?us-ascii?Q?38sNXzh20IWyogwcwoU8LTtsXa6MkwqvvgszS6DhaWqcn1IMosgzioam/ctS?=
 =?us-ascii?Q?jV/uibfMEf96iLsboNcwf7a+/EIK9ps7SNSdScs+KFnBmZ10EiD1v1F4rGgM?=
 =?us-ascii?Q?VveppDk7M/cyzEaMwq7f+X+iH/zwxVjA+foQUH20CkRsAhLT+0Sm78Litmgf?=
 =?us-ascii?Q?Zp7760WQLPOf6gOYiXfbLSMCKvJ/HXCY3d9lwQhO+wf3yxNNJMDdlijDb/fF?=
 =?us-ascii?Q?6j1WOuUCKD86UW0BK4Tdjt/71mK43nATOuZYFvynqMExzNbWn2gqFtUOQNN3?=
 =?us-ascii?Q?zxfA3nnUWzfXJaJl/DNYe6PLjFIT3d4x6d7hfzngJk7+iKzr/msBRe+enElb?=
 =?us-ascii?Q?duD09MAUj+rU0qWtkCdvkuiK/5onmYs2mwaHLcGf62S/5ya0cjIRKlQDnFAW?=
 =?us-ascii?Q?Izsy0V1L8lZP//+zfRLX2aLzBCZ2bWPvGRZ8K/wMDwIhbhr5ONu+aljwePrk?=
 =?us-ascii?Q?OPKRGrUYWDve+e77oRVGdJTkm854bQkBz+lc/rbw/YEb9McFevqukD419LSs?=
 =?us-ascii?Q?F1YeVV3aacysI5wqRJpbQSvCTqZiVsj7avFDJ7S/sSBEV1toI4mZ5Mpw7GnF?=
 =?us-ascii?Q?tfk3HFdimUIv0EFqzo6Zxxkn0KNQgWpmzvFbjUFk2P5XvWSW4dwnT+LtEUGw?=
 =?us-ascii?Q?VoSaO0/cTEWH4U12ywrKxRKvjNSvrt1un0JmVYUw2gkXpZU6tydhJz3aDHHc?=
 =?us-ascii?Q?s9VSITAeZYm5UhOQJg9P1B7Rh/0cGr3yeB5O2gorE10409vO3dyeOEHiJSOf?=
 =?us-ascii?Q?ZOTRMQDHcfboStVsL2oB9Yte2jV1eAh+TtOtbe+V9WEyQb0mqZ+GCQQSkZCz?=
 =?us-ascii?Q?POBr3P2KF8AkHC9N4IxCHNzbHSLC0J4n7gnQH/qGbs79uzPuTKkZWshCJyg8?=
 =?us-ascii?Q?mr3ABy6exaqdG/OYxDOCwh54VqAYT6FGm8cflymm89gDOt/PZuYZwFKc8VMi?=
 =?us-ascii?Q?YkTejqJmeiCpplNK3Zhp8FW5vypDCWg1yWTPTIOZ1M967Lhm1d99uhnoh2iR?=
 =?us-ascii?Q?b3pYOaRJ0xTdEiBjV/0auktouCht5rOq1krwOY9mTSXbNyIXGPr+kQSm9Lkz?=
 =?us-ascii?Q?Jgr+1gPfLux4dYDN5MLayrGElj7yo/eSNLOqCca8/V9qnNj/98sFfIy1jLax?=
 =?us-ascii?Q?JCp+3+3yFh1+AoxJ3aS/TZNN4nsVfLv5Nbn/AaYLjrADaDtEJOpxXtVy6+ae?=
 =?us-ascii?Q?6q7W6e4VLHVHgWzuGi47glN/x8PzTyAGNiuJb83w/GrZO0XEyIFpjJHFSWgf?=
 =?us-ascii?Q?Ew=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA0PR12MB4510.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 878ad770-b763-448d-4898-08d9b3473051
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Nov 2021 14:47:37.9729
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dDdm0zBZHB60YAAf6YgFV1xnzzmuZ3RDG/f8LhvqYHxut7MWqOLKSuKzLllZxgkLPMGAm/fEGPfPXbQxHeuUew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2784
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> -----Original Message-----
> From: Sasha Levin <sashal@kernel.org>
> Sent: Thursday, November 25, 2021 20:33
> To: linux-kernel@vger.kernel.org; stable@vger.kernel.org
> Cc: Limonciello, Mario <Mario.Limonciello@amd.com>; Joerie de Gram
> <j.de.gram@gmail.com>; Natikar, Basavaraj <Basavaraj.Natikar@amd.com>;
> Linus Walleij <linus.walleij@linaro.org>; Sasha Levin <sashal@kernel.org>=
; S-
> k, Shyam-sundar <Shyam-sundar.S-k@amd.com>; linux-
> gpio@vger.kernel.org
> Subject: [PATCH AUTOSEL 5.10 10/28] pinctrl: amd: Fix wakeups when IRQ is
> shared with SCI
>=20
> From: Mario Limonciello <mario.limonciello@amd.com>
>=20
> [ Upstream commit 2d54067fcd23aae61e23508425ae5b29e973573d ]
>=20
> On some Lenovo AMD Gen2 platforms the IRQ for the SCI and pinctrl drivers
> are shared.  Due to how the s2idle loop handling works, this case needs
> an extra explicit check whether the interrupt was caused by SCI or by
> the GPIO controller.
>=20
> To fix this rework the existing IRQ handler function to function as a
> checker and an IRQ handler depending on the calling arguments.
>=20
> BugLink:
> https://nam11.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fgitla
> b.freedesktop.org%2Fdrm%2Famd%2F-
> %2Fissues%2F1738&amp;data=3D04%7C01%7Cmario.limonciello%40amd.com%
> 7Ce14b7ddf8d1143b6649208d9b0853519%7C3dd8961fe4884e608e11a82d994
> e183d%7C0%7C0%7C637734908448086367%7CUnknown%7CTWFpbGZsb3d8
> eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3
> D%7C3000&amp;sdata=3DBHHY3gLu2pQIJ1nvSE0VNQOaioTC0QdBM44ze3HXrtk
> %3D&amp;reserved=3D0
> Reported-by: Joerie de Gram <j.de.gram@gmail.com>
> Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
> Acked-by: Basavaraj Natikar <Basavaraj.Natikar@amd.com>
> Link:
> https://nam11.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Flore.
> kernel.org%2Fr%2F20211101014853.6177-2-
> mario.limonciello%40amd.com&amp;data=3D04%7C01%7Cmario.limonciello%4
> 0amd.com%7Ce14b7ddf8d1143b6649208d9b0853519%7C3dd8961fe4884e608
> e11a82d994e183d%7C0%7C0%7C637734908448086367%7CUnknown%7CTWF
> pbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXV
> CI6Mn0%3D%7C3000&amp;sdata=3DzUkTF851CdUmrY1z3YZbYrnVrjHQaVfb1%
> 2Bg2dx28ZNA%3D&amp;reserved=3D0
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/pinctrl/pinctrl-amd.c | 29 ++++++++++++++++++++++++++---
>  1 file changed, 26 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/pinctrl/pinctrl-amd.c b/drivers/pinctrl/pinctrl-amd.=
c
> index e20bcc835d6a8..54dfa0244422c 100644
> --- a/drivers/pinctrl/pinctrl-amd.c
> +++ b/drivers/pinctrl/pinctrl-amd.c
> @@ -520,14 +520,14 @@ static struct irq_chip amd_gpio_irqchip =3D {
>=20
>  #define PIN_IRQ_PENDING	(BIT(INTERRUPT_STS_OFF) |
> BIT(WAKE_STS_OFF))
>=20
> -static irqreturn_t amd_gpio_irq_handler(int irq, void *dev_id)
> +static bool do_amd_gpio_irq_handler(int irq, void *dev_id)
>  {
>  	struct amd_gpio *gpio_dev =3D dev_id;
>  	struct gpio_chip *gc =3D &gpio_dev->gc;
> -	irqreturn_t ret =3D IRQ_NONE;
>  	unsigned int i, irqnr;
>  	unsigned long flags;
>  	u32 __iomem *regs;
> +	bool ret =3D false;
>  	u32  regval;
>  	u64 status, mask;
>=20
> @@ -549,6 +549,14 @@ static irqreturn_t amd_gpio_irq_handler(int irq, voi=
d
> *dev_id)
>  		/* Each status bit covers four pins */
>  		for (i =3D 0; i < 4; i++) {
>  			regval =3D readl(regs + i);
> +			/* caused wake on resume context for shared IRQ */
> +			if (irq < 0 && (regval & BIT(WAKE_STS_OFF))) {
> +				dev_dbg(&gpio_dev->pdev->dev,
> +					"Waking due to GPIO %d: 0x%x",
> +					irqnr + i, regval);
> +				return true;
> +			}
> +
>  			if (!(regval & PIN_IRQ_PENDING) ||
>  			    !(regval & BIT(INTERRUPT_MASK_OFF)))
>  				continue;
> @@ -574,9 +582,12 @@ static irqreturn_t amd_gpio_irq_handler(int irq, voi=
d
> *dev_id)
>  			}
>  			writel(regval, regs + i);
>  			raw_spin_unlock_irqrestore(&gpio_dev->lock, flags);
> -			ret =3D IRQ_HANDLED;
> +			ret =3D true;
>  		}
>  	}
> +	/* did not cause wake on resume context for shared IRQ */
> +	if (irq < 0)
> +		return false;
>=20
>  	/* Signal EOI to the GPIO unit */
>  	raw_spin_lock_irqsave(&gpio_dev->lock, flags);
> @@ -588,6 +599,16 @@ static irqreturn_t amd_gpio_irq_handler(int irq, voi=
d
> *dev_id)
>  	return ret;
>  }
>=20
> +static irqreturn_t amd_gpio_irq_handler(int irq, void *dev_id)
> +{
> +	return IRQ_RETVAL(do_amd_gpio_irq_handler(irq, dev_id));
> +}
> +
> +static bool __maybe_unused amd_gpio_check_wake(void *dev_id)
> +{
> +	return do_amd_gpio_irq_handler(-1, dev_id);
> +}
> +
>  static int amd_get_groups_count(struct pinctrl_dev *pctldev)
>  {
>  	struct amd_gpio *gpio_dev =3D pinctrl_dev_get_drvdata(pctldev);
> @@ -958,6 +979,7 @@ static int amd_gpio_probe(struct platform_device
> *pdev)
>  		goto out2;
>=20
>  	platform_set_drvdata(pdev, gpio_dev);
> +	acpi_register_wakeup_handler(gpio_dev->irq,
> amd_gpio_check_wake, gpio_dev);
>=20
>  	dev_dbg(&pdev->dev, "amd gpio driver loaded\n");
>  	return ret;
> @@ -975,6 +997,7 @@ static int amd_gpio_remove(struct platform_device
> *pdev)
>  	gpio_dev =3D platform_get_drvdata(pdev);
>=20
>  	gpiochip_remove(&gpio_dev->gc);
> +	acpi_unregister_wakeup_handler(amd_gpio_check_wake,
> gpio_dev);
>=20
>  	return 0;
>  }
> --
> 2.33.0

Sasha,

No concerns for me to 5.10, but would you mind also sending this to 5.14.y =
and 5.15.y too?  I didn't see it sent up for either.

Thanks,
