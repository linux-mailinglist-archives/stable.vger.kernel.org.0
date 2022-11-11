Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FC516261A1
	for <lists+stable@lfdr.de>; Fri, 11 Nov 2022 19:47:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234279AbiKKSrM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Nov 2022 13:47:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233252AbiKKSqy (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Nov 2022 13:46:54 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2045.outbound.protection.outlook.com [40.107.93.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C364A128
        for <stable@vger.kernel.org>; Fri, 11 Nov 2022 10:46:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DQFVSEaCI1CBF+pG8Aj55jAJVMOJ1cJ1ANvs5DYANVZjnqL6PfvohWq1NMpeLWiOYDxEXUp4Hrtk8BPM/jx/W8J8hLFKrjKOI9gDs29lArlDaoKrUZBaq2wjHkSj5xI2X/zdb5cYm5bsWJMerEtuSK7SZXzajmpfHgj3VPaZEr5ch/6I+Gwfvt/YSm5ZgxX9PbaRlpgWKcFlU5KQk2ysjIVc6YrwkeyPz4iT/MeS/FPiYYOeUerT0U0IFPHQuQ1pkSitT7DB2WcMX/feHhrebbsS6dGveG3oaBvxmAizMaKGKy4lyuLANT2HKP92ZzaJBta/+SNTpA42+/gm8Bbf8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1qIZdT+ZWZ0CBv7BigZE8NkgR2OGzaYICQ/z8WOrnOY=;
 b=PB/n0HLnl9iNCAe2JCdPd8rojhdXRsisnHaw9H+pmvKRE91+oiE6ulyu3C55NEpAHiBBcAEyZ1y+DqnIHNoZYBps89V9LJtESYTM8mfU/QO/JmmOc5xhm8T9bj2zPPPbAr0mILWziDWtpvpkyRQDMOlp/VOek9WRT5vpDVrY83fAW3+K0FtOKeyME5CPz5BWbFGTepGHE484UX7FRTktT78I+rngDXnUmuYgTRee7MogtAheWQUysfV7i542pDclsUrni5o815wG4bW6S425qwDEhEK3BdxCPxJOPVHgTOSJ1cc3n8qvSIGkNGN+sOBk3PrKHU9QmTkmOoYlpuvVMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1qIZdT+ZWZ0CBv7BigZE8NkgR2OGzaYICQ/z8WOrnOY=;
 b=2UciJF0AgKxuZs1xYtngXRbglUM6FEifh/YKtuXYBD9MrXB4WodHl3LpwzcoEfOaJthD8lTYrpgxxBzhZDrkLY3mrYs7cAYMIcvfuALlCnWSUzIDQ+X77TTSf/AZEWdWhS6/thwrf8R2stxzCO5eH51NPleUCJFUXOJ1l+nTK40=
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by DM4PR12MB5327.namprd12.prod.outlook.com (2603:10b6:5:39e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.13; Fri, 11 Nov
 2022 18:46:52 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::44a:a337:ac31:d657]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::44a:a337:ac31:d657%4]) with mapi id 15.20.5813.013; Fri, 11 Nov 2022
 18:46:52 +0000
From:   "Limonciello, Mario" <Mario.Limonciello@amd.com>
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Another fix for DRM Buddy regression
Thread-Topic: Another fix for DRM Buddy regression
Thread-Index: Adj1/b3mroL/T2+mSuStT9Ze2/0DDw==
Date:   Fri, 11 Nov 2022 18:46:52 +0000
Message-ID: <MN0PR12MB610140563FB372EB9AE0D046E2009@MN0PR12MB6101.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2022-11-11T18:44:47Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=e5fd94ad-a1dd-4777-b440-3a20e48e5bc7;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_enabled: true
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_setdate: 2022-11-11T18:46:50Z
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_method: Privileged
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_name: Public-AIP 2.0
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_actionid: bf05aec7-f313-4ee0-b57c-923329c77e19
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR12MB6101:EE_|DM4PR12MB5327:EE_
x-ms-office365-filtering-correlation-id: ad153119-201e-46e1-63b6-08dac415191a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5ZW9B+5t8oewP2P1mP9WyiNhik8qqdxevlJRBE9a+t2sKAwqlQNHvUutD/XpZbX8iwZit05UgxjojNPkjpZi3iJipikEZa/RUF/HojT8P43zelIqD2iDndRhzemtaiRC+9FSCDBfN5Hhq1UZ43KO43ReVQ/Q2M7YDHYxGZaBiUqwtKnwPxwHep23wURws5O2XuKwIN4ZzN1Q45dhxjRDryEXB8OSnGmmezO0Greo1+t167w+9PXJz0o/1y89W0ZE/uqknAURxzVw1rtGwEWm9RmHzcmMCBsfmTMUmk5Y/vXkkN8dHWvtEfV95/uCRK63T3Mv1N5kGQqKKDim++LLEBWiYxJX/ymWtkBIESFIga3aYN07ww6gInmdj9KBu466UpGEXo8gYWRBu1vvpSp59FAcgneBFmO/+5gSp0AWryOQeMsbKLHbCxkLkZHPr1Eiy0SVO3aQIZc6loOHxopLvr4Wr4w+hw6+EA+pJIiKKvLT7IHfw8pG73RpdST+WM3d9HofFzR1NgrueF/7U03QSmPdm1lqDYUJLsMbotdgYCK6I9sOc+6AQA7ld4ohitIjR+chj7fs38dc7/RqX9AFPLbj2lGnCoJxk/bzNK7467HYYnttuyS9TfPMZJyPg0C0lyzfwPDHtzbcqRGo7x7p3zIVEp1ydVRbpWjN/SJVSFLPQBeJrgBgOn+ofarXmvwq/Niv0QdM85w9ul44Zlk4oA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(366004)(346002)(39860400002)(136003)(451199015)(6916009)(478600001)(33656002)(316002)(122000001)(66446008)(52536014)(9686003)(76116006)(66476007)(66946007)(8676002)(8936002)(41300700001)(26005)(4744005)(66556008)(7696005)(5660300002)(64756008)(6506007)(71200400001)(83380400001)(86362001)(55016003)(38100700002)(966005)(38070700005)(186003)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?JJvw7T7On8kBQId89i3dYdzC7iWhpMS9Wz8lZ3CDvxdk5oCOnqzRX6ZReCvi?=
 =?us-ascii?Q?UUtPV9EZNvWiR+GU+qZKnBmUL/F/n7Ifg/22iwmzIYSHN6p6eci3a9uqAtG4?=
 =?us-ascii?Q?MB7objhJ4suJWxCMIv8jqXVG1xlbyzURVVW2XoFWCnFOqcJDKvoDZ27zAfJ/?=
 =?us-ascii?Q?Znq7L0h0xGd5bE4wEmLTT+0nDw8c58/Kyb3nQ3BodXjqgvzNxbb2zjckBlKU?=
 =?us-ascii?Q?GC8cGHbYufkUci6TriLhfNewTRcGZWwsOw/k/3BJbfXhQT1ObqO2L/xfgmGl?=
 =?us-ascii?Q?/r07RTF0HlJ1Z34lSdR0d4GeLsiYFjhOAJ8mgsrisKKUtidz2gwaNG+qh6Zs?=
 =?us-ascii?Q?V5y3Tk1tmEij2zZAk2fPFxk7KvmbMZ+AGrOWqcm9JbNYnX/pG9D8X5RTZQrF?=
 =?us-ascii?Q?DNddGcjFQcnJCwmYuxtR9lw31d0xEnF95/Fe58mHBsm4nVcBlzR8YVTfujO8?=
 =?us-ascii?Q?WmDOkFoT2fGSpPPBs0qqgANr6HqI1G/U4lJ4urvTtPWK6H2NQs20IyoqLmyF?=
 =?us-ascii?Q?fHzaW81iOe6ED6O1w4abPVbccbbth+PzdLVJm2l02Tr2K3JEL6vyl9QkdrLf?=
 =?us-ascii?Q?ATIo/KxHbhb7VjwSNgEOD6nttaOPYToO5ct5zUiOed4VoODS0QPKj6z62WHq?=
 =?us-ascii?Q?ZiQLg9/UmOqferSA5bZ8cAt/Gn5TKXpHB0jTiSuCwRKjXe0D732eSRAD/D07?=
 =?us-ascii?Q?uEV1ac22WfKsRI1bkQRnAF6cOezepk3emKUCWntgG8BhIGhKOZ1I4NsNo1bF?=
 =?us-ascii?Q?hn6S1dO/dp4LR+koZ3HErPLq/LaGnwFY9734kHnfBdc1YLv/nCP55e8JDReJ?=
 =?us-ascii?Q?0UooTlcZZPmu1JF921gK8Pz/fXCHa3H4hfprvHXoahYD3RqHf5xXhtDxRMYE?=
 =?us-ascii?Q?8qYLu+bOPCNVaYSdSRd3w63u/ioWYoHS5F6SXvj4dH9oQgu5/nRH6qE276ot?=
 =?us-ascii?Q?mRSbqHOWGpBT6G+3pJfOoZ41/bFoW5lV/is1r5PF33/n+7L9tcD3EF439T/7?=
 =?us-ascii?Q?vfPGcojRGZWfayRI+jIEFr0k1NigfwWjDHWuV7T0QSv8ckGgan9xgFIqXwC3?=
 =?us-ascii?Q?TUws0b88SL8QB2wYHweCq8T+Qe7yC3jgy0TBBQLR0ptPeoaYPLeX4uxJm1Rw?=
 =?us-ascii?Q?IoJoWw4o2ybteAV6j6juLjBYFZvbOSttWc9HIRepAZ3ZHOXMfih75nNE+645?=
 =?us-ascii?Q?2K5QxaAjid7sI/VAgv0CCr8toppqZii9jzNl+G5glkiXhAh4bYW9tJbMcYjN?=
 =?us-ascii?Q?DobtG6GG0tCpv5L+oXip2ZAerM+G9ZjVHwj54b8sO3RpAP3824Enimt2zjvD?=
 =?us-ascii?Q?6Uh8UQFw5vvQgkeVbLw+7YLrioNtOQEwg8OKBBZQntWClnWLvZsiEH57S4RW?=
 =?us-ascii?Q?3u24ZGYWQ2WaXSGCr9L9q/bfVOdjgpUlgRCXpnGOws2cFpwgt1N2Ui6qH11i?=
 =?us-ascii?Q?44HX+JdeJqn7gWt+Cf+Hvb/zLFlEXwHkKgIRFev6ZrafYV+jLiMJt3PJlaKG?=
 =?us-ascii?Q?az3ZLOBtS/Zrr6iBGq0lSKvgEE9Qw2Tchx6q9ZDwO+fbQDpIghMM19ksMbXb?=
 =?us-ascii?Q?r0FgtdTjOx4SeiOaZOg=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6101.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad153119-201e-46e1-63b6-08dac415191a
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2022 18:46:52.0706
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Lk85NOR+eDu4rULLUP/Pv0Ce9itl4G8RkQhAqp/XwrAq0CW7XKdxMWGyTsRiXoEAWayonI1agJFpO7aK/aebwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5327
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

Hi,

One more fix was just merged for the DRM buddy regression from 5.19. =20
This was merged before it got confirmed successful by some of the reporters=
, so it didn't
get the stable tag added directly.

e0b26b948246 ("drm/amdgpu: Fix the lpfn checking condition in drm buddy")

Can you please take it to 6.0.y?  Here are some other tags you can add to i=
t when committed.

Link: https://gitlab.freedesktop.org/drm/amd/-/issues/2213
Fixes: c9cad937c0c5 ("drm/amdgpu: add drm buddy support to amdgpu")

Thanks,=
