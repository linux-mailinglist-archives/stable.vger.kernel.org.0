Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61AB9549E3B
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 21:59:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346569AbiFMT7q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 15:59:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232462AbiFMT7h (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 15:59:37 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2068.outbound.protection.outlook.com [40.107.102.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 681A7AFAC1
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 11:30:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jt4VXCAXdG0MFnE8toWXvaELVjcWF0OnMyRCvCSZmtwCCEPCWg6f+ITPnj5rIKxHUNz6dX4ZR+wz4ZwquM8QU9UsX/h89jCYfzh5Xo4e1Ds2qGQvATinamm+LR0Pz/uPFrpPxpPMZ/BgkCHSDbCBmu7HwOglsDfs6gssIOqzkuIfIv4gOdxgJOuQgLuVOz4XVq36h8kXwOeKiWrfQ78umNjr2WOwbQMsg3eZ2TVUYDOs3csYLl/SZGXKa++wGjQnATIMw/xd47ONMFRrtZAFQU021S3ltRdg0X4pmL8snqdmB5uGRueQj9ERkCXwPWLwgFnJY1WtB7QUQVlrp0AbuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w9pZpXQfI3nb14vZQp3n+JYcFEkQ+FyhnQ5to/59FDI=;
 b=TG+/gKLwuntzdu6Cj07EDdt+ol2/bGeV0ShBkfMOHAaTxblGDg+2fogqUklPfVXawt7tt+rQS7fJmWdvI9Bd8viKRFHNKDbgDsmCnu8NLCy1GlSAOUZBUb3I/fLX6vg74iKxUdic5+Cd85NrHusAEraVvVYcoAWhSUsaA4lXHou/ccmrtp4IufhL23oPVwJZkhoScpxOEntCOUtJvcItBXpHObC8pHXhsbV7aIR109dsJONBbmOS7gzqmPZ5nwRFcqe4tvs1+SW90VfOK2kQwn+PmFo453iqPDz0kAdBvhdLbjffMDJVWzanX4UWJLz51RcLddKcMAq0YAL6zFdwqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w9pZpXQfI3nb14vZQp3n+JYcFEkQ+FyhnQ5to/59FDI=;
 b=bjP75fK+SGlfS4R2aiqXKFyenJI09Yh5xZ8IjLdMcakT3vLb+sbqCnuRW/NBOerukClPMUpSm2gRWUdatoZyogZq5PMeNGNfR9h13rIQ5ViJ7AWDQEaJBVGhzRId0RZdiOsB8aSgtS4BDMCKpah9MwkOvUQds08UQ3HeG0jKa34=
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by CH0PR12MB5348.namprd12.prod.outlook.com (2603:10b6:610:d7::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.13; Mon, 13 Jun
 2022 18:30:26 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::3839:4183:6783:b1d1]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::3839:4183:6783:b1d1%5]) with mapi id 15.20.5332.020; Mon, 13 Jun 2022
 18:30:20 +0000
From:   "Limonciello, Mario" <Mario.Limonciello@amd.com>
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Fix multiple USB-C displays on Ryzen 6000
Thread-Topic: Fix multiple USB-C displays on Ryzen 6000
Thread-Index: Adh/UsUAET1afTi7QKq+yEVPvaFaXg==
Date:   Mon, 13 Jun 2022 18:30:20 +0000
Message-ID: <MN0PR12MB6101AF53F2455B1B46F4F3C8E2AB9@MN0PR12MB6101.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2022-06-13T18:29:41Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=152e3b74-2758-4371-b675-103adc7624f8;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_enabled: true
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_setdate: 2022-06-13T18:30:19Z
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_method: Privileged
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_name: Public-AIP 2.0
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_actionid: ff4d4ef9-bf12-4ec4-9d0d-acfd7947c5e2
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e2188a39-d6cf-4028-b22d-08da4d6ac5f9
x-ms-traffictypediagnostic: CH0PR12MB5348:EE_
x-microsoft-antispam-prvs: <CH0PR12MB53484689709011FEED2B9873E2AB9@CH0PR12MB5348.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FF+hfmFSmnPwe6PWp7MWFx9+jQ1tzqad4j2H4mJdKOIX/14akxXveexeRcJN6/EzuuVc4vSqkFOl5N4HYpDcLQJNaTTZw7acTDIstPgu3uJay75aXz3XF0+crWL9x+rT6e6+6wweUGB75FXQxQ41+CaZBsN2ch7w7izT055YMbqXarjudC2LQsz1z2hI2YDXEAjD+ZQFkM+EYErb2YcQM/rC7lBpKC3xG/8l+I3EoM1ttGetZ3OIkf0C1qAEn6NuoQ/C/y8RKrVEhbODDIkgCX+zdW23n7VL60FG634lKaxSWNZFvoZiH5U90ujN8/9gFSdCPncfFFsjTZSRCAqLs1SG0pkErqSokyLCAx2qslgcMLZ9i1GpnTUwTv7Fhrgp/KPuza0dJynYCO/KvOfRmhPrNhT38sDdBKe0/DYsuJ5KJheydmsYFujrrhNzGMTS15izKOy71hg1JsytqeQ8F0sRrCXeissFmm0JXSBcqMessAYg6YEDdkpx+CH+mpnmnHIWmnL86GiV3SNYfl2eASljYHyFhAtX1ZEyFdTcVJ5XDQKEFR+9c2t1zKo6N3zpHpj2u1JD9/ixnB4qYRHMxKkO6irfbON0Lxi/p7iK1okk0Hr8w2l/wJmR33HNZeW5tqZA0YXlbMQ6BHC54RMC2XtUXn2BDhUs+bWefbGdWb4kFoUhu7TmqrVXrixjBaGqcmnBJSTGCxMHOqrc7zbt6g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(316002)(6916009)(55016003)(558084003)(122000001)(71200400001)(66446008)(66476007)(38070700005)(66946007)(76116006)(2906002)(8676002)(38100700002)(33656002)(64756008)(86362001)(66556008)(8936002)(9686003)(52536014)(26005)(5660300002)(508600001)(6506007)(7696005)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?22nwStmJj6cmISNqAPmxYYoOVJALQ4YKDjiHpJFeuVeQpQf/frWi11/T0E+i?=
 =?us-ascii?Q?LoFwBpFnsBnPBGFJDcYsiP4rlFrPg/FVD9ltzWyapIw4m9oD7mJuvbhgC/fK?=
 =?us-ascii?Q?HIAslncdZuk18/5aMa7doY0TuvGCkkUEuvrJsQWOthK9/wJ2CSY96d78/5Dj?=
 =?us-ascii?Q?A+eItCCIx50IWIETu+orp5IZ+ur/l8GY2nfd1uMpyLMwLEa1Dp072yY6hVg0?=
 =?us-ascii?Q?D5Z2ijWMelPAQy+tnU+V9ulB167kf3j6aJapX7Fu/l0G8PwFCaeymwtS9Oy+?=
 =?us-ascii?Q?mRmuSO0nIQGiQbYCqwlaV0ERV7fdSrYC1zVbyXip+6FXt0CfkSB28rhFFdOq?=
 =?us-ascii?Q?te9hrs+GP43jOhZvRRv4xNH7BhNhBdfmsaxVi6KhaAnvvsmElzUd4wMeXbRO?=
 =?us-ascii?Q?UekC87TdE0CdvhZCETGg7w4s/AqWKx+vJ6sBObYhEsC3eBznXHFRQxi7375W?=
 =?us-ascii?Q?dsmSVgEpIMEWLT8JLshdUF80cfWi8NkJxY5dNUf/ODlZY25UTgRwUjBGgHH/?=
 =?us-ascii?Q?ReKsVnnuXOr2aVpbuRkN8Xnv44LoCrtDhTLJ0NYxqWFJzBTZsMwv+XvBELBH?=
 =?us-ascii?Q?NAQBR7UPIBI93VugEhOX1GWtaDcAJh8qjun4Z9NJXty79wwKmoL0jOOUjxUe?=
 =?us-ascii?Q?7HPSuo9+WWDOlS5ppUA9xLcuwREQojnFwsSQgpOhb/43IpVcKUOLuRqj/HGl?=
 =?us-ascii?Q?87Jx3eN5IWBDJ3ymd7AugJ01eUKUDvy9S5oGmEg5QOxSflv3CogbUsRXoOJz?=
 =?us-ascii?Q?691Ki9q2JYbcauVTOQcgiNovndhlggi0WUOwUttM+oA0A5UZr3I001GuRwCv?=
 =?us-ascii?Q?PJIFylDcNkTLXLYNb/Z4Kua/KX8DmASv9nF8xdHRnSScj/Bkycq3hqijqRcE?=
 =?us-ascii?Q?pW6qfr1l1j/NjnoT0hDAr/WeEPTSZbfWgMHgZ7kYS0ourCdjzLdVgOaNXP9h?=
 =?us-ascii?Q?iY+rPXco8uc198TRVdZHaC+Vz0uHa2wBFXh35CvohfzxakiZ8qv8mHNTHMTM?=
 =?us-ascii?Q?F6v2kgackFvM8hNkWbBMctej7umDTKafN6Cu8lUOBsl9LoKvfLX1pWVEWoRH?=
 =?us-ascii?Q?Dg2/7gZVP09CxvxV4Y6b1Wug54SdIQk9/g2sC8Knktn981U4IizrwCN4BCfo?=
 =?us-ascii?Q?iM+4VEoI5rQY5WeBb2YKfiqVt5xFV0sGcczSr6o12waR9/zFY/0joiZYhcni?=
 =?us-ascii?Q?eF0ZwA810Cd7JN/jfLXCxs6cVNXEfEpeLpZUYBkWY3kUlYY4frNEnOcvyC+J?=
 =?us-ascii?Q?ZV5DU22tmJODycUo6DbIVM0IEE5ljFcVrxaiG3D97s7hvURr9QLEKTEK2bZR?=
 =?us-ascii?Q?l8l59DCzJUPwzKR1A5SSn1cybGRqF6po9MYPR0tfJVIyAPdXt5bzZcqDPGlK?=
 =?us-ascii?Q?Ms6h6s/95oXe+s16Sp4A7s0C/zo33aQiITI6/LbPbz/erEC1pwFsNeFNBMiD?=
 =?us-ascii?Q?X3gYCMwn+cvRXpSMcP0FbYwjegEgvt6Ynf5vh/5LK8Mf+CxBZnaAYFuLdEOz?=
 =?us-ascii?Q?MQU/zVPLxDjNlJUo8F8n/JvBwoh2YNp4nFVyqrr6haCYEHczNBhrrWW8gu1N?=
 =?us-ascii?Q?uXKpGzw7q4UUTGy/aWDjlMbJ9VxVs//m+qhDI2C3FlCgVlI81WDLVkL7j/dU?=
 =?us-ascii?Q?XHg18uK9Lle3yPLDrhrd5m/FqSbr9g4vxlg5GQQBG324NTf6pk8dDbI3cpZF?=
 =?us-ascii?Q?jGsrm+07/wVubqTC/EGXYWwBNk/sV9aQQ6QuqpYXPbCLZcKk?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6101.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2188a39-d6cf-4028-b22d-08da4d6ac5f9
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jun 2022 18:30:20.9225
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1r6GKm7kO7xIEgokNHAyE2QBLOBTRoe1jLIC3pqaqpLRQEU5bfCNkSb7KwMeETdHX7DoYo/dsS4S1Crvvl5LJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5348
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

The following revert commit went into 5.19:

commit 1039188806d4 ("Revert "drm/amd/display: Fix DCN3 B0 DP Alt Mapping")

The original commit was mistaken and causes USB-C monitors and monitors beh=
ind docks to not light up properly.
Can you please bring this into 5.15.y and later?

Thanks,=
