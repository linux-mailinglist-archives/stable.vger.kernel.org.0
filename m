Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B5DD624610
	for <lists+stable@lfdr.de>; Thu, 10 Nov 2022 16:36:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231366AbiKJPgh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Nov 2022 10:36:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231348AbiKJPgf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Nov 2022 10:36:35 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on20624.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eb2::624])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7A8FF72
        for <stable@vger.kernel.org>; Thu, 10 Nov 2022 07:36:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kt6+fLgS67o/n0Tx00nLOR8QT6tR5Qf5hy4PNq1eKA7/PSOONMBksrwsw1qjTGddGfxWlTfQN8K6y/fMj7iw3V04GJNkGFt2s9ZH/8+rC477pGvG2Oe+ZPfwLio+JdDPAwRuNnGHEjSB+bRdFrgKMYT3YttpbVw8ZeNU6ZPWTr/8CBnEGNlq/S41taHVsy2/+MBmmDsnliP+qvvO87B45E1xN8DhRa4APPg9RoYZgxxcl80XyH3Ref8uQ5y7TIXjcDPdhUGE0bV03XgjmuCq4myicPStMCutIa97DnJL2E4G5PJfipKPXDNFiSO0x7PJgXdaMbUDSK2mkm6GKk7Qeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=psj1Tjz3VG9fi1qJ2QJR9qaNRZpmn1y4ocPYW+Ntd4Q=;
 b=oE0M8Z0qrnFJNDa0s/G82WHY+3yjYTiHD+OsXTXRYeQg0LFIwAe4NQilfCY+tMoSgCB6PM8954MRJviJZySTWDgcoiXkOLnslvkLQ2c+V579UwFtMn4fxU84iUnYH70826DOZSommXH/uj8hzCRgAZ8dhpAHpk2LIf0pLBAQxK9sf6HsZP6uiu2KpIlNMAtjHTJ+gTUcmXL8IOphWH/l9PzJd2kFhCLekOfGxslgoep95j61an8ZTYWBY+K3JyKe94SHikRHQLmyftYsinkNc38+mPMXsNGzLVcP0dis4KAHInXKvS0NcrRdCTubIAMofQ/Yh0biN7oRbYldiIIPGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=psj1Tjz3VG9fi1qJ2QJR9qaNRZpmn1y4ocPYW+Ntd4Q=;
 b=0lOUpmJGaV9pVNJ7HprXrsDYAeaE29I698vwTor80BAYSu+4kud2h7uDn/SujhcudeOyW7hNtNN0CQOay5fM8+AyAwZZvZ5fNCeuieUZyzl/RnCpWoi5nDgXbUYGTNxlY71qgiS8Cpg5vQdM9UKTVdjTWyhYSSk4THmStlJ6fdg=
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.23; Thu, 10 Nov
 2022 15:36:30 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::44a:a337:ac31:d657]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::44a:a337:ac31:d657%4]) with mapi id 15.20.5813.013; Thu, 10 Nov 2022
 15:36:30 +0000
From:   "Limonciello, Mario" <Mario.Limonciello@amd.com>
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: USB4 DP tunneling fix for 6.0.y/5.15.y
Thread-Topic: USB4 DP tunneling fix for 6.0.y/5.15.y
Thread-Index: Adj1GjO0aENRVEtmSsWQWLOBWUcjYQ==
Date:   Thu, 10 Nov 2022 15:36:30 +0000
Message-ID: <MN0PR12MB610143CD05C1230BBE268FC5E2019@MN0PR12MB6101.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2022-11-10T15:29:36Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=f7813ba6-25bf-4a7f-b2f3-22d5e354c217;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_enabled: true
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_setdate: 2022-11-10T15:36:29Z
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_method: Privileged
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_name: Public-AIP 2.0
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_actionid: 5d6a97e5-a957-45e4-a9f4-0b12ad1baf20
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR12MB6101:EE_|DS0PR12MB6583:EE_
x-ms-office365-filtering-correlation-id: 53b5d5d8-380c-453b-7804-08dac3315701
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sWlAEQ/igWD5tSl0P+vs8TNGI6RBza/5s+ai/uAr8Qqg182Zfkg0b8NZqYSKqYZlAk0/XxTDZVDyGA64ZWSArFngMkAoaPcYrHrdaYPX8E+cVbzwRUrOj2/tLGtaeTc/Bm3dkrckmYtf+EE0vH2ShAgnY/bI83YhslfOpFd6qOFQDUntHtYhxV3PxbNQu+oJnFKer49wMTH2aw44YxqckvV5fxFGdLboTpsOQIBph1j5ZwMj5ykNaS/6/N7j3K3qXe6sxEXnIV1oAhs2qwLvD9M7cAibv6eOvXtyCkD8vYOGqGZNCynDcqqO7dNNlmeivD6wqAaPEaHAwA5prmSrZYZqHl5SJMZOB3lFNDf2b1H7l3r6tLsw8SQt5Yqy7HYGKRIOxqU96gMWC9i1ya+ECiwOqmkhS4XtiajT7jNl16MPPCRSLd98/vND7bKTFSYMYTrbn3FWd2lG8W7aHkTmU/9JVPMgVuO9JYZKNPS5iRLhYn+3RqWlImCm1A/i/1lzguhK5PY9fgCu+JMDEZm8d5C18FRlEHRwH/aFMtWyhxODSrkgB3C8K7v1vwqI6GhBO+d0ABzZBO0NEK2AfUG0D1TqCp0S7KUjA8mH2jsnpGzIjiykADpAmAzL8gIAOHcQKO29cwkuOa09vlyUImYHXP1HtrCNTGl5fsg8kTO0Z/qR0Tf073Q8BV2qMnX4ACYSHJ3ZFkJyfQGWIDxHU7AtInxt1Xh6W9X3IlK/aIjgqln8bNhVJ9kPoKuQ/9m/QWbqgFiqim6azGfUyMmPyIcbwA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(39860400002)(376002)(136003)(346002)(396003)(451199015)(6916009)(66476007)(66946007)(8936002)(66556008)(33656002)(38070700005)(71200400001)(478600001)(316002)(9686003)(52536014)(4744005)(26005)(5660300002)(55016003)(6506007)(64756008)(186003)(38100700002)(41300700001)(66446008)(76116006)(86362001)(7696005)(2906002)(8676002)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?QuoCQy5R+OFdBI7LdyFkwN46yQUgCKmdwbn1prItDYWqapgvFIndB/j8XFZq?=
 =?us-ascii?Q?KJNqANrcjtFYR1MB0b5j52+iGlfR9u8JX74h2wg5AWDDitQOURtwdoIQO+41?=
 =?us-ascii?Q?vdyFRz6HMOX2hOZxnbofPyRFgs+0/AvN5XSmP+IAQL8KdUua2+6INVVU1HxI?=
 =?us-ascii?Q?cqaxe27jCA17UKnMEnDheD9+/iwo6uiHQWb07fUUfo6yq7OcNVjrvO5YAjF3?=
 =?us-ascii?Q?Rzyl0pPTyuuPafoNa7ZZBAhShtceZVGYSGmR7EuA0dUtuXBS4SwZIFcVBwaG?=
 =?us-ascii?Q?KIubvbrBOdEVaOBgd4cxnz02y0SJrzAhkB1ULHb9FXBnvpEyUjnDZAPBzIKf?=
 =?us-ascii?Q?hQi8g5463ebr8NMrlBXBxHy6E1r692YoGMC6gUAmY78DD7oWe6BTR1tPN2K3?=
 =?us-ascii?Q?g6m9QTtMngf6yQLNSvBtXelbeAZ1uGg5AjE8FZhfbgGr8AQpSRL2MwnmeGJP?=
 =?us-ascii?Q?lQdFkj46EWmpuHGQwbjs5KrTvEmMdwIMSmvLfAJtvHkib9CRbld7SB27U3g8?=
 =?us-ascii?Q?bhrgrI7b1rV396guazqUyNBLQJk5kMrxqhOTPhhcVmzngJ2ZUfo689ccvnRx?=
 =?us-ascii?Q?3/m3T0Yh2gp1OmN7/7nN3J+cXLJHf9+W3So8i15AvnkthiiMoh51O+xb3w6R?=
 =?us-ascii?Q?75y2zATn1J7SGjgMHCSqRdUHv+jYCX+pzm/LlY9woWCmrzjmDPRl7ckw3peK?=
 =?us-ascii?Q?SelGjefHWWtcHoSVeQX0X+70f/FIpIExUt3Fuiw6KRz+SA5Mkp/JqEuqKrkU?=
 =?us-ascii?Q?JpaAoMR/p+bp5UpSIDirSTLH5BOPeE3Wj1kM90dUI7vNcP4mMpotzxbdYtKu?=
 =?us-ascii?Q?RoUuovM1nGgyuG6Yr43hKsz+mFt/P6iK7tziFS57IwwHM4iAkmCX4eP8KbV2?=
 =?us-ascii?Q?X92uvpNSxQWLyIzeiaB1ukoacrGbSdLryGY5iNmBI1JtLND/iaIRjir8KztG?=
 =?us-ascii?Q?t+ShMk5ODdfUUxFgNOzzTtxnDeZ71g1QJjXO85zlCq+dOsz4LCGVkXXWrMzS?=
 =?us-ascii?Q?zejov9AenmVSAMBoP4ltNnkM/IXe0VWdHWX/pWfF4rXh/dExZwjCcq2Z+xSu?=
 =?us-ascii?Q?Ia27pzwBIS08kvLVmNjyF/xi3pUQKGFEpXB64UUD+r7QK9Vo2+i5gVyZXOSX?=
 =?us-ascii?Q?b6pEuPXnXOcdYS1X/sJym70E+i+HwLqz0yETnlYLMh1GvyhGDOllLKtaMW7I?=
 =?us-ascii?Q?lLZiHC7+dpCmxuBuXrBIBKsI25eZQds7yr4NK9u0fU6ehm5azeKjK4TLEjTC?=
 =?us-ascii?Q?i1LBWaPlKZZg/3tlcPgJOWKJiPzPbDHxUo7uSQ9XtS9BxWxNhQDyvJ9UajBf?=
 =?us-ascii?Q?rzqrTa0+mik+P+aT1jXHprIsTPZbZ7bHUMkwgvHE65RlCuwdRvYSM6JKt0zB?=
 =?us-ascii?Q?5Oao7Xkrn6/qFhEaP7NE7ULuvz8jdh0lXnULHkCobP8jd+FT2kyietyhu1iD?=
 =?us-ascii?Q?v0y/potOqos9LbHUxRNboyiUfN0dGZ/CnnECcCCvkx9jELlvWZhNezva4870?=
 =?us-ascii?Q?lSPqfsOYri7QhuY3keaNBMiAtWldLRFFi9dFiNU6JnSrNDilVWNZoAXKPlqD?=
 =?us-ascii?Q?Gljx1fkt1bha1/dN1D4=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6101.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53b5d5d8-380c-453b-7804-08dac3315701
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Nov 2022 15:36:30.6249
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TnXGYd3OBSMSq+qWPF7rCwF3wGOky+Wy+z8j+bUWKGGstQWJAHL7NAscmpP8YMjpEmjmXK2XLYP0ENBh2vWteA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6583
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[Public]

Hi,

USB4 DP tunneling has a bug in 6.0.y and 5.15.y that was fixed in 6.1.
Basically if the Pre-OS connection manager has set up USB4 DP tunnels they'=
re ignored by the OS so you'll have a "working" display in firmware and onc=
e the Linux kernel boots up you use lose the display.
Hot plugging works around the issue.

For 6.0.y can you please take this commit to fix it:
b60e31bf18a7 ("thunderbolt: Add DP OUT resource when DP tunnel is discovere=
d")

For 5.15.y can you please take these two commits to fix it:
43bddb26e20a ("thunderbolt: Tear down existing tunnels when resuming from h=
ibernate")
b60e31bf18a7 ("thunderbolt: Add DP OUT resource when DP tunnel is discovere=
d")

Thanks,=
