Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FB9E65CC38
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 04:43:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234222AbjADDnx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 22:43:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230060AbjADDnw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 22:43:52 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2040.outbound.protection.outlook.com [40.107.102.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEB96DEEC
        for <stable@vger.kernel.org>; Tue,  3 Jan 2023 19:43:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DHxCec05VV3ZYQCoKw/rNVSTldtPutrPHpiVD5568uvv6TuIEy/NNR7eMDlEyTQCtyckGh8WYziAZ08gIOAtQohrfgYA07nawFLHU7Do1RK71hDAhw+G+y45YrcDuLCUlMUq35wRdnMiyEK/LkjR8yCcqgYlTd+oVvqGk6P5UMpQdwrdQjt5fHRa7aMxxFOLgtSAj+gwxXQAv4CRoKnieCp7iSIQwiF6c3AGJmJb6AKMG3rEHQDc7Vxb3vpx6wfWNoKb33fBROISyfaqhmVOCSczy4SCqvpIhIu2V4SJsCemWsgcf0Mh4SlOxUuLTHMU3kdosdnuKlHBem+W2kAvqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qvj1CHQq+3jKvJ7syiVnCfNhH/jPx0+knjAQ/6ZohYE=;
 b=AIgeJv6+Vr3NwaZKxuqZ/s37tcUKlze0o8zMoFE1seaZUgN0yk2cm4WYJ5NAcepkMxNhQYSfcE65BgkhrwzVKcz3lcOZdZe1pdmqHv3LTz5b3EllUruHSOmimiyImDeb/St/dysCapBkdytIQx4Aud9a3UWvfw3G3Wv+Nrdgx0bLgViHin8eggf9yuvKbiayx4YyMi0y2BKqs1zPTNCMMq2/sCeQflYLPRnpGXcskM58XoI2kNtGlm5fbXmQDA/jAxna9/ip3wwa69fMdDhav0g36DDGDKKrELGONvw2X719ZP/jOXbvA+SmFJhyPz+KKMvabo270vX3VL5nDwvqxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qvj1CHQq+3jKvJ7syiVnCfNhH/jPx0+knjAQ/6ZohYE=;
 b=ctyxMbXjTcBGU3wcupbaTEuCQgOT/1uUsds67MGbt1xsHcOd3kMGdA+xDpt0bPLb4NJE9KfJIFcCV9Hft5ps515TwjK6G6xhxrs/zXcbQ9sDq1OZqAuLO2c+ebO7H8MxbHBWHbv32wpMEzvWSSe994dt1y+2gKiLQCmeamvFGFg=
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by DM4PR12MB7742.namprd12.prod.outlook.com (2603:10b6:8:102::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Wed, 4 Jan
 2023 03:43:49 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::ff3c:2d37:75f3:442a]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::ff3c:2d37:75f3:442a%6]) with mapi id 15.20.5944.019; Wed, 4 Jan 2023
 03:43:48 +0000
From:   "Limonciello, Mario" <Mario.Limonciello@amd.com>
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Missing 6.0/6.1 stable patch
Thread-Topic: Missing 6.0/6.1 stable patch
Thread-Index: Adkf7iYHa1+ChdeUTUa6jtCjwvdBrQ==
Date:   Wed, 4 Jan 2023 03:43:48 +0000
Message-ID: <MN0PR12MB6101EB028DE354FAE5C1444DE2F59@MN0PR12MB6101.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2023-01-04T03:34:38Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=e09d31e0-de6e-42ee-8c85-23dd598d424e;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_enabled: true
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_setdate: 2023-01-04T03:43:47Z
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_method: Privileged
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_name: Public-AIP 2.0
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_actionid: 1d6e660b-2148-494c-bcfb-83ecb08015a2
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR12MB6101:EE_|DM4PR12MB7742:EE_
x-ms-office365-filtering-correlation-id: 77cdc100-29f5-4b6c-6645-08daee05e3af
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: deIySeu7agRQwU7YFkHNtWZkuDArMRQatMpDsTXOdAnYwxC+kEuMiokfl+z4FrjMHwJ0H3W4AvceGIQTTLRj4cj6d1AVvM6dBOKII1qtLDLB99a5ytjMYLbP2tdQU0uKlFaTNTWmFezojOFH1wALjxudoe4sr+K7L59by+Ty4BuTrdVfxTMRMhfokA/qUEnU39g3w4/8VVk9b/CwSqC7M/klkvchFKt6MuH7+9CPHzqz2M2pnVr7rDYiQS5TVEpQinQJLd8KcjihIyt9OJhnzHRW2r2U5pRM/MHY/MZTHbtUEOI1DEe8SK2EsZdCNBnWJPRHf319Q/E52UIA22GYaXv5JWVLcmp6dlNa7u2Pw1+oEIFHwyBwQESxTRdIh30t4Fxm16qnk6zNsY5RUC6ivIUDXHLP16ze4kSxbGwcmWAd8qr8IDj592xTzT3oR6auWFG93VzodzgvbKzCqlyuS7vs1EgJagkqnoQjTtC6Yg0vU/JavbDPBMG83RDDRzk12hKwMn+wBV8z2sP8rFW5LHCv7eTaBQsMA2LkUKbyTC9+qfLkuOTjfA3jW+DovK8zYAAKgfyOS7rhqnLZK0CY1mOGOZgWc5yOZrNA6py/RXO2gqP4UARcstRZkUpSouT7dO2GEZrvVQa9FMHd7n8UXA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(39860400002)(346002)(376002)(366004)(451199015)(83380400001)(9686003)(26005)(55016003)(7696005)(6506007)(33656002)(38070700005)(86362001)(122000001)(38100700002)(186003)(478600001)(41300700001)(8676002)(2906002)(52536014)(5660300002)(8936002)(4744005)(84970400001)(66556008)(71200400001)(66946007)(76116006)(66476007)(316002)(64756008)(66446008)(6916009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?+DF2+CrAuEzSSJ06leGIlCPmc22hjCt4g+69tl51IVzLz4eTrZU3rQiNI3wf?=
 =?us-ascii?Q?SqBlkjEqkq4aRv1OVe4/65k3PpNKhg426l7CzluDFJcYD58k2i4bBioORsKl?=
 =?us-ascii?Q?OSsGMp6Rna/HP3Nn7V8mJuruOCBa20K01SHO4IU7HBOzCrF/6IXi82HANZf0?=
 =?us-ascii?Q?TjVkNbeS7ldpmvRBHkYYYEyPVCiBD48NRChVvE0ANVyAnsxw3vDoh6FZkf2x?=
 =?us-ascii?Q?GbW54QeILIVy0CQFH/8PmwJW3bmKoDY1tMnmud40qFs1JbKLH8PvECgAwEwS?=
 =?us-ascii?Q?/7EwaC8euM7G31J0MlvYMajOQ4/qG49KvfEdr7B3tTzMisKSbi7D8OE2oBA/?=
 =?us-ascii?Q?k4dEeACZGCdag2kDlzyTkAmgOAKGWx7wEAzcQviWN5xoiIvxeF/YLHe2gRH6?=
 =?us-ascii?Q?Eg94xWdZ4E9R6KJGAIHxSslAlSxKH9cDZUt/5Cnc0qhEAbe1HDjpClMemfzk?=
 =?us-ascii?Q?0SH2nFZKP+jeeXrz4RTY5efrtP/uNP6hjDayBSC8LYCxOBqcEp3BWS+iqsHt?=
 =?us-ascii?Q?ExTA+bj2ou2YXCh8uX6WBzL/99Pidpobi5xWwYN0HjSV1HWi5y034TL/TbrE?=
 =?us-ascii?Q?UI/9OymE3FtdGOKckJi37cfZBLPlmKqmC8Imy+Hs1hkCyOwNfcoGwGssQ69p?=
 =?us-ascii?Q?gsAFGU3PyIERKxDylSXgJGgYbWJM5POWZz6PolHCYhf1Hc7uGGqoChSeNV3Y?=
 =?us-ascii?Q?02v90GuCb9GW3pcFNZLrgGoHrOq9UDEXYyi938YSwfRvGR66KWjhzpCWpYGe?=
 =?us-ascii?Q?1ahjC37hAFCuSabPliyVpq7osdHAxZo7l3D68ruWrH37w299k4x1lUlY13Zt?=
 =?us-ascii?Q?xVCwnaOtCAWGEvP9U8uw+6ax9sKGDfqeZaqjVrfyoysrM+Nbt5j4xOxs6dzM?=
 =?us-ascii?Q?2Xip4SwxJkfj9uxesYLvs8E6CFVjPSpOzONMtle7fNiMqiFTGP+2E9JD5pYY?=
 =?us-ascii?Q?8hXaQ6CgSDE/NDT+CRks5rngv54y3ckTSJd/oxgOWH9KNCtQxle7UDX0laUp?=
 =?us-ascii?Q?/IcXnEyzmgmS3ABjktIvOPAVLrBpEEXku2TXTnL+649CAA5H/yX5D59dkzhi?=
 =?us-ascii?Q?Veia7/wAqmfmn99j1Q0jCY5KmicyWEGjwB/YoSdKgzIIWq8MBK8GXiBowHxG?=
 =?us-ascii?Q?B/DL44IyseKYmYdOOOUylIAEw3eP7Cno40OF5YH98DB8tuaexfAOxhAVSIyE?=
 =?us-ascii?Q?ISBPMUPu7a+L9qiGRQ7QqcX995Foclp2qQIohGfsHAbxsWFpPKUto0D1G8Uz?=
 =?us-ascii?Q?0FgDsar8aCQJUZlthrDLcZzuhJ2JJwe6Xa/BLQqXV8y9iqCTjQR9K+x3fRPt?=
 =?us-ascii?Q?HzysWkLPVi7Bzn6ueFkSQaZ2m2yzuJ4Ky6JYRCDJMdXWm31fUPoY3Sjx2Tzh?=
 =?us-ascii?Q?3VQAVvtRkTKC06O/r143KBcCHhNfP4QePtO6892PYgFtK6JJAkxugjd1V/b3?=
 =?us-ascii?Q?HOkoBpT1+qr/dwI7uPse9BFH9p6hQJ0GINsDiY7njp4C/gE8IBd/6P8T9brk?=
 =?us-ascii?Q?HinLg5VktElb1HWOE52gdZdOzDAitGYRqq8bFOr6WrA7Zmc9+Avkk4WJZVUe?=
 =?us-ascii?Q?qrfGGh5CrWgWvvLQy3Y=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6101.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77cdc100-29f5-4b6c-6645-08daee05e3af
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jan 2023 03:43:48.8361
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /wD8rK+1fcrasuz/XXWQr31oMhi+tpVKZORvTRbPu4fc8AzEgVBIhK6WSl2MSTv/toBKYYuBLGfu8glChm5tiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7742
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

This below patch from 6.2-rc1 was Cc to stable 6.0/6.1:

afa6646b1c5d ("drm/amdgpu: skip MES for S0ix as well since it's part of GFX=
")

However It didn't get picked up for 6.0.16 or 6.1.2.  I also didn't see it =
in stable-queue.git/tree/queue-6.0 or stable-queue.git/tree/queue-6.1.

I double checked and it works on both 6.0.y and 6.1.y, and It fixes a bad s=
uspend problem, so I wanted to double check it didn't get missed with the h=
oliday shuffle.

Thanks!=
