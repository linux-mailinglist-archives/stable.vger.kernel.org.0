Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C283534427
	for <lists+stable@lfdr.de>; Wed, 25 May 2022 21:24:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241693AbiEYTYG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 May 2022 15:24:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241555AbiEYTYE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 May 2022 15:24:04 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2046.outbound.protection.outlook.com [40.107.220.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49FF84D25F
        for <stable@vger.kernel.org>; Wed, 25 May 2022 12:24:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CXt8wofr3lwxmob2Ri1X7wUz1gA7MeqxEozSh+aEHhsE2L9hT8JQfGt+wEx+HJWpZFZvLRvaxAqDIYccrvUaQuipfAdxGW54nNS8cJB+ng2uZ61o1M3W5CJ+Ldiw+zgEf9Ix2fPqHf4Des2CtNPVgufKY5BNqIe5T+Exd+1uHzYcL2/3mdMqDQ5CECLtfPra5Qw8L5hrU3BjmdAwn1Fjolxa5ziU0HoTimi8JbSyBmh7CcWmzIRfxJucnIW6Zn1/2sBmSrcJJ8Z6WZiep8ME71/R54aWnCS9fSioerPz4Ac5vLeNIYuIV+X4fvxVouNK0Kf45z+T9HmL2H4OhuPDFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6v/Hq0N0xZa9V9Vs4Lx8TbbBqSgER/NT9NzETohQ1Xo=;
 b=LboIbXhGaSyKbbF13zB6l4nrcSK0kPEDQItgV8zN6hideMQBsYhYNWnpmqJH3yCZxvDwFDxGNt9Bpn2Jc/NtglK9HjfhFZi5yUyCWsu+X4JY5NOth/2tHWWju7WgRvYALmhSeJTB9dYhDOTc9X3DSLGW+6zTX4xuFsBEAwCyyPLLp/es/F3jfJX/2nnk7dl6NaAWIq0Uak2MPFgEjwCPrsmcl6SIvffxLYR9UKGpSbVyvFNUkG22obPRTkcw6xBx4harD1hX0STl/8BTTaAqbfM2/F0XgBFcDWSk/h5F/FfBtx0frWh8BvzojwCOrCqTmtLtvo+v7w5lGxsD897wGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6v/Hq0N0xZa9V9Vs4Lx8TbbBqSgER/NT9NzETohQ1Xo=;
 b=iGeOUdnH4sq5PTvPdyN4TQBi3HOx7pLGhkaRl51qcMIR93vSRuo1PF7fSGpJFPcrx2GBZJ/8vaFL0xxpZVvANRnO4j6GvHI5orqZEopmHfMg2mBxpyx08T5nw1KARGz64csDs3ru69fP8K3Wap0jF9In+LYmEMkKrj2Noqz+UEQ=
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by DM6PR12MB3657.namprd12.prod.outlook.com (2603:10b6:5:149::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.13; Wed, 25 May
 2022 19:23:59 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::d8d9:91c6:819b:7a80]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::d8d9:91c6:819b:7a80%4]) with mapi id 15.20.5293.013; Wed, 25 May 2022
 19:23:59 +0000
From:   "Limonciello, Mario" <Mario.Limonciello@amd.com>
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: AMD SFH sensor discovery 
Thread-Topic: AMD SFH sensor discovery 
Thread-Index: AdhwbBqYnCakJkukTz+QEz9XUjuF5Q==
Date:   Wed, 25 May 2022 19:23:59 +0000
Message-ID: <MN0PR12MB6101243B86EAF100FE859714E2D69@MN0PR12MB6101.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2022-05-25T19:17:50Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=8095aee5-82d1-43e9-92a5-e972712f4108;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_enabled: true
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_setdate: 2022-05-25T19:23:57Z
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_method: Privileged
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_name: Public-AIP 2.0
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_actionid: f51de1b0-3663-4a1e-8ff1-1940011fd626
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bb7daa94-1a32-4e41-757d-08da3e841e93
x-ms-traffictypediagnostic: DM6PR12MB3657:EE_
x-microsoft-antispam-prvs: <DM6PR12MB3657A5F15C5F577C213BC3BAE2D69@DM6PR12MB3657.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BOC6wcKCvMXR+yBRnDAlx0a3aFOdKYLoIixcz75dbC4qlIpADrbnJBOiffV/nqXmao5N+KIsTAIvvSl+96MLSvYb/kILVfsQZtt68LvtmA2qcnzMx038Ahx78A3ImDKSgN/trev11SlzKM9WLUlRFMTTZeDVoryWfG79lwFGyuk8Km2CF3k6BEcQ9NFft06gEYSH1a7cItJrjGoIoMNuhbheF0rZZB2DnUxiX7N3jo+sVSgOZlCsrhtUeVPvJly501IXInNhK8Wj2mI1ZFGfLsXOzOatoKVR+khT+PS8SkAovXbbi96RKyZdk2jIUPiKqetBBXQ/QQcFaJH8brQ5miouAr83klwNb5kaBupBGgx424/926o0itLwsTLqD/tDlwULr3kfd7dvwg12f85UI9y64K2M1y6XNbfNkaG1cMNO3yepvQm3UJZBfyh6ga4tp4CMQFmiJg7kWLKEl3op5r3G//sQbVTBr6ddu4ecZiihgdP+XsPOuO5MHNNaavog581QsPgkEP+g44YGSzR//Mh06EMJqkhhP9k/oXHULdoP4xFYyQfA59YiPMAG7VpUuv37+G/AzwCNhOlVxM21CgQIv0QE7rc6xVpx/mR03ZRZLWvzVegpmBUq0Zm/ccNKppgXJFTJf2MElYERY2lo5wNyEYFiTtm1kF+4x6CAm+JmDL6imS3HJcIXTh16gAOtuoVUiRX7OGThNgM6ybmQ1g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(86362001)(508600001)(33656002)(8676002)(6506007)(9686003)(7696005)(26005)(8936002)(4743002)(76116006)(38070700005)(38100700002)(66446008)(66556008)(64756008)(66946007)(122000001)(66476007)(6916009)(5660300002)(2906002)(316002)(71200400001)(3480700007)(83380400001)(55016003)(4744005)(52536014)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?P0jlve7RaKtSjq7m+IEnWA8JtSHTKJu7GMWe+jLNZEJDnDvEQePP7QjFSE9S?=
 =?us-ascii?Q?az02ARTsec3hKIiqUbo7OKrw1vWSwN/SQNIaC3d3inwThO9QJoUOfURyyIE9?=
 =?us-ascii?Q?3z+sXi2hocYIuPNqgdRsB1gyW2rrkuvAHf09ZLDkJgrGUe2w3UFsQntXogOa?=
 =?us-ascii?Q?YKA7JxHonWM/gF05MIBthMjATaGN+NTOTmeS82Bn22NAYJu88iUEnrXHeDi7?=
 =?us-ascii?Q?x3cM3MO5qPrpRAoe6jQvHA61zqJQfeIEAttLdM7cMkLcirjsfDYiMaRNajxn?=
 =?us-ascii?Q?qovYa5c+CA8+AqoQvx3WHvdSOI9k55gWiSIiqAEUxEz/Ae3w6WFdZPCvrxwF?=
 =?us-ascii?Q?am+KHasOE26FtyKMuJoOlzhCMTgQg3DteXhwl3bEHn+0NqOB5PDfMMwS8t3O?=
 =?us-ascii?Q?rqDqrICmTs340gzBwzeG3ddB4AfNUg3dcco70oEuOG7VdnLjfxc5oSgQHTYf?=
 =?us-ascii?Q?XuvJjIULqFNu7r6tND4dJKMtaV1LIEZ7ZFASIPtnyvJRhdPnMfAsHE1zZI6i?=
 =?us-ascii?Q?rwJtrFI2qTm87iWdN8UmesnOruaH4KE8oNUoxlZw6z8IFntYuVjYRBo+gaBJ?=
 =?us-ascii?Q?74/N7bbstsM6Shnuyp9EbuNjdbX/8G7c9guxXlPRCRzPCyqRGhuSmXnKn8up?=
 =?us-ascii?Q?DwfYO6mHk2PyBPE8Ke0qISv5IbmvMQ4MI4w4uN8ZM8r82axoo5t5e7+o9Apt?=
 =?us-ascii?Q?mjCFQ8kv0EnsWxTTkRFsId2UsptA9WDw2J+J85agAANo69kIpfox8tpCTZV7?=
 =?us-ascii?Q?eCgIuJvle770XLzBpLIlFjW12nCUD++b8aU4BZHau62AogQKev/jW4sd3HdG?=
 =?us-ascii?Q?sY6PiJn7rN4MlaVYDp1Sn4DgB0+KihTFOeePbFsYuq9QCYG9i+08+CMvb8uf?=
 =?us-ascii?Q?y/kKMTpq2D1n0kG5JTc5toJ0r8zyeuyiSG9kdfez+RNz8IT+mVoDcJNgD/vK?=
 =?us-ascii?Q?gEVpgtf9kIIr3p9IqWsyx6IvrnTuigFBVa9uhGwIbJzW6JBhdnRbMI7GmhYr?=
 =?us-ascii?Q?br4SJBBdVWbEWPyszKuClWHrRPAhQe+9qN/xfDgfpDnf/p5QSmHcaKrklO0t?=
 =?us-ascii?Q?pZqlWh7AMDvD1nc/Vf4iPmw4OoYthAQwQyLpxZNG8o5J53idDVCKNd7Fj7Cx?=
 =?us-ascii?Q?1v3u5E8GaaeVkBwEhNgfRjBTCbV+I6iC9DfjrsJkEXi4e/TyfH1N5TMy3NlU?=
 =?us-ascii?Q?VFXPpZMciFwusHGZpfoICN0yf6wi3KkxbXLUr/Hzols9A+p/58DwNGjc83HP?=
 =?us-ascii?Q?1Rsx8aRBybAZ/j5dgwhmUY8dyM4wSzcFmOhNJbw9Dgxu6gsPbwYlP0DZSrkC?=
 =?us-ascii?Q?GMJDu5NFU4eiZk61Wc34GwXkkJIbAonRMwA43REbXfOJ79B3gbD/ISldSGg9?=
 =?us-ascii?Q?Q422sLwY1YaKHf48IVbE09HTiI+gI66GiHdv65iRaufouTpCBB98DN1am/lB?=
 =?us-ascii?Q?9nZ1iAp4p/tMb+48hUIUzfKMyiJfgcQqun4DdkwGjqlRtcyykhvpvq5P/1NI?=
 =?us-ascii?Q?xNOebCF7dvonw1RcoY1bzB3zHfgGhNDp3LcpgHe1sTBBiSItsahNXQv8j3Id?=
 =?us-ascii?Q?IZtzWDCisvvmfKjRZuOpYaCMKgttXLrtFMSU6NgqFeLopDK9yIAItG1qNcms?=
 =?us-ascii?Q?6xiL7ISVaCUlCTbUMyiXe0Xy2kceSVyb1haqHYzvPlLhslKrzBHUqnPxDALp?=
 =?us-ascii?Q?EuAVC+jaxxLvzlUBBeaNtAayEML2/5lDvkfUh+cv2sIlPVKw?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6101.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb7daa94-1a32-4e41-757d-08da3e841e93
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 May 2022 19:23:59.5308
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UgxdYj3aoFwiPgFS5qR4ny5AtuHDvX/+DTRPtDvTaVtiIxpHf4KP2fuZu/o8VW1ZgGPaRd/vxqkD67HJV1mtWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3657
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

Hi,

The firmware on some OEM laptops with AMD SOCs advertise that they have sen=
sors connected to AMD SFH but they really don't
physically have them. In 5.19 a commit has gone in that discovers this case=
 and prevents the driver from advertising this sensor
to userspace.  This might not seem like a big deal to have sensors advertis=
ed that aren't really there, but AMD has observed
that specifically on orientation sensors the random garbage data associated=
 can cause userspace to interpret a screen rotation
during resume from suspend. =20

As GNOME has a daemon running that interprets these events I've seen first =
hand that it can cause the display go upside down
without a lot of recourse other than command line tools or rebooting.

Can you please backport this commit to 5.15.y+ and later to fix this:
commit b5d7f43e97dabfa04a4be5ff027ce7da119332be ("HID: amd_sfh: Add support=
 for sensor discovery")

Thanks,=
