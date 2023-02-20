Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1131269D456
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 20:50:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231455AbjBTTur (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 14:50:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231340AbjBTTuq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 14:50:46 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2062.outbound.protection.outlook.com [40.107.102.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BCFA1C322
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 11:50:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kbbLI3AmSOJLCQ/F0JAn8hJQdX8vrjCSNqOBCGD7++bI3JMIxoD2herDPVuMvt95l9xDqMlaVqoMUq660eNYnHVo9ZMRLbWZGG6YiJ4TfYxKWHXOTDbtIhOsICjNatboMUNIZs4Apf5uqC6BqSwjo1i8Ep8XuAvZn51Wcn65G+j3576Hu+damDfSL9G6SOH0D4SZwOkXBqvUCF0bbDuregNEqlyhefYdwF8t5F1XNvLwggA9iT+5x/UY4tt9rN4bJF8g2k556L86kzKT0zBhBP5KIb1ugFtUa5PbHnNv77dQji5L+UkXQV1x7xhoiYZ0y1GfdyKi30hjJUPqO+9ODg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6yAMuZU1oCxV30tLF2o4DU6K+xHJASFp3o9Gdydc0co=;
 b=AF/skzJmyntyNi5lkb/+ugKnlKU5RPs+XDHST0wSvly3sIuH3p42Y8Pa2Hg1hoi01aazloc0Vk4eGluAe5AHYV9lqsjxZT3kZjL/UuxwXZKwWrjBDkf1tqnMhuduK2aDUh8urSN/y+xMgMopmljFeW0pUfPhd+AFkoTGCMLb/JJwfk7ZHwrISMkUrARMrNqFRrAMUDg1F3EtlgRRhLU9o9KSmpngQBcZBkKeYVXfk9gZCctvPacKqoRIXFKjybgH4xW4wqZL+zkK0etQVmsd6ol4OWu8NDVa5j34Iv8TGe8A6vxLXipfuYUxX24DjRY+UyVFL7Aqf7+5i8Hprzo3OQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6yAMuZU1oCxV30tLF2o4DU6K+xHJASFp3o9Gdydc0co=;
 b=asoLjPA8e2RkMoB4sBC6qT2uPl+CFm8QZqAl8/HMlW7BfDIceBeM8jt9H54tkOJnL440klUtyzQcJTLarWyWQ/upd3/MyEW0PkeGptEmfx4/6hicnv6MnO20woOebEdbcxHDC/SsAvgQdKSB5rwgo7db28KWrxF75mmJF0sOKXA=
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by IA0PR12MB7721.namprd12.prod.outlook.com (2603:10b6:208:433::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.20; Mon, 20 Feb
 2023 19:50:42 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::a59e:bafb:f202:313c]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::a59e:bafb:f202:313c%7]) with mapi id 15.20.6111.019; Mon, 20 Feb 2023
 19:50:42 +0000
From:   "Limonciello, Mario" <Mario.Limonciello@amd.com>
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     "Martinez, Juan" <Juan.Martinez@amd.com>,
        "Gong, Richard" <Richard.Gong@amd.com>
Subject: Missing IDs for WCN6855
Thread-Topic: Missing IDs for WCN6855
Thread-Index: AdlFZGCh3y9oJ5hTSqq/pr498hZ61Q==
Date:   Mon, 20 Feb 2023 19:50:41 +0000
Message-ID: <MN0PR12MB61013F4BA09A9838F86174D0E2A49@MN0PR12MB6101.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2023-02-20T19:50:40Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=4bdef575-fda9-4e01-975c-d343db84daae;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_enabled: true
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_setdate: 2023-02-20T19:50:40Z
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_method: Privileged
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_name: Public-AIP 2.0
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_actionid: 895866d4-790d-4a8d-98a2-a6573a36598d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR12MB6101:EE_|IA0PR12MB7721:EE_
x-ms-office365-filtering-correlation-id: 49ae185c-7188-4f23-e9ef-08db137bbf92
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MAqhQyx21S2II0ca0wHdKQg04NSLORICR8qpdzeXFhKtq6fYI3Gmggo2BW1woPzSyK1SAQZI9bKwa6qbPYHHovyoG2zSGofO7/4XDy1+rMwrUHk4gup7lJj1ADYoQkrQru1wIEqYkhlEXVZk3iuIfa92LYc96bL9LpP6ud7g94zQvoIOsMTQyP/CoyGXUtduPdfWQnDvBIdqeTI19l736LRU9XuitBtIyAm2raMrJf0tuwPOF37YDlhcfzcnOw2KMN9PVmJStDLYyv5/UUUffPUjp3EOGb/vIi4JHPWOVpSJRgLW/VIhu5wLfZzUk08R2PBl2FnSC78MAtQIJ1i0QXxxu31KwRf9H6PVaoYIVCjHXwFxDdGDH0SLR+rMn72dzXwDNBtSSi3PU5ziZ0DRAF/TgEqz51CQ8odfvFmirPaowFMu/tq93b7fq7n3bKSqsB7CG7Zmm4v6V3voKD30CpSvOLLKWD280cXRziAHuFu8zDTgpb5xMZhiesqN0ae0nGeRRRYOBiD/ElPoB2/KWizoPRHgcEBOF1bLpeZjYP8wGMjv5kVmjaPeHWDMf2h11V2qyMIHHhYkKFO4EhG4C20/2UagsUhuMoBnUzYfi3rqiA5yk1YY+QHKjyVRXYQyzNYQubzTPUodZ14zoIvXeQ50MoWa6ByIjypqRimOzoEojV5GKf5Clfn5V/9hXF/7d+hz8UOnevDjRDOzKXECnQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(366004)(376002)(346002)(136003)(396003)(451199018)(33656002)(83380400001)(38070700005)(2906002)(38100700002)(86362001)(41300700001)(52536014)(8936002)(4326008)(5660300002)(6916009)(122000001)(8676002)(66946007)(66476007)(66556008)(66446008)(76116006)(478600001)(7696005)(9686003)(6506007)(186003)(26005)(316002)(71200400001)(54906003)(64756008)(558084003)(55016003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?1lA5ZD58F/3K3IcjpUlXKrYtmrA7SkY4eYj6wF+HCYnlGgk/dto4D5aAvJAD?=
 =?us-ascii?Q?EMMtYCejsA2Q7vEKdVhRHDU/2GI1Hch7Z125SCfjs3q6JJRlcxguQTo9DlI9?=
 =?us-ascii?Q?lM/666wPDZXcPAjp5/5iAjUkLDbNXLx+9A6v4ppXzdFYjtado6gzy7QZYZHq?=
 =?us-ascii?Q?OuceS+q9SxaJt/uJzPlQ1jcuAVHUaSGoHkjfiMe9BRNdbWIhvNioQudPHZqj?=
 =?us-ascii?Q?+sR3504L3QTJJNa9GeJ/8fvYjoJVHUvMrgBezD73owirgHiUcQC1XY/GZH17?=
 =?us-ascii?Q?X+deqbCD4VLD0sSlD662w5IHUEN/ymlucgY3O+sxNvImxtg9mDdO9e3i16WF?=
 =?us-ascii?Q?WSlYVXawrpJhEngOrdVigBOztAVhstA9AFQy9A0SJaCyDTsbsfy2nUUq+2vG?=
 =?us-ascii?Q?qJ4THjb92iOgB2wgrXmtb1a4gehypVWOH+zNUvn3rKmf14PMNWqoOHSSIjnq?=
 =?us-ascii?Q?7gF67gvvgLZaK9UUKz9cO42eONJCtR+YBY9v9/DhCcQPEyb0ZAAHmXaqKFye?=
 =?us-ascii?Q?vlO+ZQVNZht2fXhNtVECpBhjqLB43ypcOQE0DffzTxP8l+LTTYbhqJTUNsDP?=
 =?us-ascii?Q?2DHjG7ishGc9eJuUh+HqT2E+x2kWlA6ciuUvSfe2eQKXqvxaFMMYqKWfysGS?=
 =?us-ascii?Q?mRZWktfTwOe0xnNi/8lQlgJBPwwg/nRRUpKckTU7McwRTdK3y2l6rEhBTz86?=
 =?us-ascii?Q?GWMgArKSzOeq20AlMVilCMMKYH9aWQa0ElTGpYHHBDGhXyorLl0wdn/miTCZ?=
 =?us-ascii?Q?REKbxXL/wpIFs3boY2qBSHzVQeePBXSKChfUjTGJO5nsK8B2eMrPYoN5wgg4?=
 =?us-ascii?Q?B5q3At+SWdSotAIUHxtyqB1OhyJEAUK5+lR82hH9KwVltFhvTZ9KclM5nTmm?=
 =?us-ascii?Q?E3exga9TYPJdUhsD6PUG+vSmlDOn9QXaCMbczgLFc+pQsBgMZ0OJrveTir2e?=
 =?us-ascii?Q?nojwCgxu3w5cMZYe+QAfhNymI5OOCNybsRHy42SMqiHOf5PN8UIJ2FTNcRYo?=
 =?us-ascii?Q?znV/0C5WbR+WuBoRg+AWyNJsixVCvnv8e39/wlLGqhx3MHS+tYwYkKoJxmvy?=
 =?us-ascii?Q?Kgg0W51+H4HWWf6d9T0JC2mimWky6iAr6jErehWXP0SgDG0To8lQVg5k8/KT?=
 =?us-ascii?Q?JwffJaP4Mxak++CCt0RF0W6T/icWtrLTgi43MMadZjwIiH6LePSQode/oEQC?=
 =?us-ascii?Q?wg2ReV+fNFXLpjkHtrjnMCYfQLu/5/WwwuGuq7PJY0PxrChe4qUC3FE6INyX?=
 =?us-ascii?Q?5T4Y6U2VH19byaachxzkmNStme+t9fXNgwE3FoSKrSZ6df2liFc0X2Grvlj8?=
 =?us-ascii?Q?LZmArlKghMsbxQ9M1s5PKNV28hj71iQslpFY7vB6rjBcSvglvYhMETpXLg3T?=
 =?us-ascii?Q?Sx99rIyXdZFpXsO7wVAii3Dfkv6sVoRgS3Yu+HjGI96XSqJeWB1P0KoKHjdT?=
 =?us-ascii?Q?Rty3BzIxZ9KF460t66XFu5qXyOYM6An9O3FQogOo186DnCoUjEt9wxhQXT+4?=
 =?us-ascii?Q?ta0vcXJZs8DKxcPTbM9IaX+t5TzadS0qAFBhsF4NItA1Z5XxIk8z0szTAtF9?=
 =?us-ascii?Q?0sr7GrLe3p7lzvTfC5M=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6101.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49ae185c-7188-4f23-e9ef-08db137bbf92
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Feb 2023 19:50:41.8401
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Bt00lBrU6yiwZIZJmBEntg3Xai2I0n8IvDMbZZOcDOMEWU4H+qC5Berkghyhxrv1RKcw8BqrRF4cDHJ0/VtAPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7721
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[Public]

Hi,

We had noticed some WCN6855 hardware we have BT wasn't working in the LTS k=
ernel.  The IDs for the variants we have were introduced in 6.2.

Can you please add this to 6.1.y?

ca2a99447e17 ("Bluetooth: btusb: Add more device IDs for WCN6855")

Thanks,=
