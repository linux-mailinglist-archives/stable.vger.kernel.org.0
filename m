Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AD7565EF88
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 15:59:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231843AbjAEO7O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 09:59:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234367AbjAEO6u (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 09:58:50 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2064.outbound.protection.outlook.com [40.107.92.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 385A441008
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 06:58:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mwTE0vH/aV2HjBThFB0YTx6QMDNPUzrEqs/eB+EpIuD2rmWDllnZLxnEbsbOwNOGFgR7qkrfHP9QUcq1CdcjsxQUpl7st4uvDr5p52WjJff6JgBAvO0pum1Hl72yHljrJNgARqMfbJMa9muSPHwt374obvz/gDVqTAr6k6MEe8JyPEPGtMNs49XL9QXSL3l+l3A/d8l1A4KzwdjpISolzXf13Xc7R1biikt912BLSRWRZrgfdmHIMxRnCSPM9zmUNUsZEmnwwQP3Oow0XwRK0f6kKfej34DjBMmJtp6skUrICh/0jjF75iDwe13ylDYKmhqQ2H6stAJ8GzwoNW+BRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hOK5a6q6fKotjpV3Wjhv5QPSlKmDqXbjOjCILt+I8XI=;
 b=D66LvUi3IfL5aTF6j5czBaqfNXM1CU5uYYeSEYk5rPHKaVb3zmT3EAjypUkhJwExvwPgI+pvdGeHOb5sNeCt4grDKPONyxRNfGTFWxJQ8QO6UHPbFGwBEctc1I7RkrhesRM2kJrnrNx3/Iak+JsNEO6/MFgO8wA1A9J5lG1cXD7K57C2ETduAjqB4KJhuM2rokPyYCSByasI2w+1Ctqy3G/DNkWXarLS15BuzlL8ksdyb0vjqpVQMxrLA61w+V2Ezu7ymAcgeJH4HNecVlLKQUtnrv+epB2nNJYnYAuuLVvt7mHnbM1ytb4yzj5PwkQ7TGSP69yqoLQ/I20tWLWFpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hOK5a6q6fKotjpV3Wjhv5QPSlKmDqXbjOjCILt+I8XI=;
 b=ruYIF49dVF8GlAbmJTs4yCiKP1NtWhXWlrAYrgWMCvfbIXZGQJAVwQ/fnkaE09bfAm6CRridsVqUQUs9QKbGVpg5kC0+U/xRxn/7F6V3IJI6T/6V0Kyie/xepu70Z97FuLcae0HHnJnn9K7XVGAtY4ZqtmdrMP/j/cWxqEBktEs=
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by MN2PR12MB4126.namprd12.prod.outlook.com (2603:10b6:208:199::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Thu, 5 Jan
 2023 14:58:45 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::ff3c:2d37:75f3:442a]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::ff3c:2d37:75f3:442a%6]) with mapi id 15.20.5944.019; Thu, 5 Jan 2023
 14:58:45 +0000
From:   "Limonciello, Mario" <Mario.Limonciello@amd.com>
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     Mark Pearson <mpearson@lenovo.com>,
        "Pananchikkal, Renjith" <Renjith.Pananchikkal@amd.com>
Subject: WoWLAN issue under s0i3 w/ some Qualcomm cards
Thread-Topic: WoWLAN issue under s0i3 w/ some Qualcomm cards
Thread-Index: AdkhFY+O6i5jLfJuT8O0SO4i7d5mdA==
Date:   Thu, 5 Jan 2023 14:58:45 +0000
Message-ID: <MN0PR12MB6101476B9F5D767D1BAE8A1DE2FA9@MN0PR12MB6101.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2023-01-05T14:55:38Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=693b8621-9817-4816-a3c7-a3f3c8d98f31;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_enabled: true
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_setdate: 2023-01-05T14:58:45Z
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_method: Privileged
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_name: Public-AIP 2.0
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_actionid: 7c507d36-2c8a-4f8f-b105-7319fb757e9f
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR12MB6101:EE_|MN2PR12MB4126:EE_
x-ms-office365-filtering-correlation-id: 306a4665-e6d8-43e0-f2f8-08daef2d57dc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 18sjKDNYeXY923oCWtJqFC5Oka/siGo8vXI6Cwdy5v+rOwP3vGT78pFdBL7w4fH7+iZkFUtQ9FH0mIC6jfhlhJBQYfC2WP1Q6UpdkhNNlO/FF9Cqz7CJ+8FQPRmPqgBIkWG2PudRR1wwJEBfWjj6lmWTRaGtjrdN+5jGSaBi5Wg6oXe8dLCNwBF4KFbwqvFWkAT2oXhiMjz5dGETOrXRKZvUdy8vThd8CKazV6gM0E8bzvP+hDWq7Jks0FJTJWTCObCEszktiZQJD6jyeAEq7MNwJdB7zrcVyzOOg3YOidpnJc4YtxLzBV/kOaDHDHaSDUePxQiZT4fcDatjCqjOZ+jdcscxhaxUFI0t54Voxd4/HCLu7xB4O0u9hDGJoRtjTONm06OJyVXwQ0tQfoFK8nR15lpHVxpsiB5CMHS59Ac6Gj1tNNfnUlW7GSAbW0waG2zaoj2Vb38reIii68YLtOcDz1ifUeeEZQM5P1J7kfLlj2VdwhnEfGhXieMws+CxrqYJbfAmEnRYvxbYteyVKeh/2P4XNgaXGEIwaI1JZp5eBhveaqsPleFM7vV7dzILprX1FsPFZlJwPwZliVu8v4hF8ObizQchaUr2MqQvsFUt0aFOOcgzvOZjgi169sBpT1bV8+2UgZL3KxeACWdGa4UG6lIrXCgwWD2HuNlwPzlU9jPxpYSoLnEVk+3gWBa5ZJ5oe71D09MjmmRdy8WsFw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(376002)(39860400002)(366004)(396003)(451199015)(6506007)(71200400001)(478600001)(86362001)(55016003)(38070700005)(122000001)(38100700002)(9686003)(558084003)(7696005)(26005)(186003)(83380400001)(33656002)(76116006)(5660300002)(52536014)(64756008)(66476007)(66946007)(8936002)(8676002)(4326008)(66446008)(6916009)(41300700001)(316002)(66556008)(2906002)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?L3Xcw3KFXuitsKiiA3GbAGxi+z9Dv20Nlirc4zGOqWMeNs+NIuZvaYtiIQ+j?=
 =?us-ascii?Q?Qyj33gJi/ydXPd4BR6u27PIJiHVxcmA3nrs63p0AFjtPwdCw7DZ4wQsg1yA1?=
 =?us-ascii?Q?fugHDKJqx9rkkL0i/5sSs9kRQmZsKXg1Zjj+f9jWBJASROivEI97y0Oxe0f+?=
 =?us-ascii?Q?Qg8v/HFhnc4FRzcOh9gQgU+BAUj+R7BbgnuLZ4M97hM7uvvk9ppCiTCBAAyL?=
 =?us-ascii?Q?8xNdSg49DPE3XOoH/k946JAs/t+/jSTU1ILbbGkhx76j7DZJSGx6Iw9mlz45?=
 =?us-ascii?Q?SRemh2dXhsngtlT1euXpfsa1jD0HxaJXorJ1bJvVtH5txRgvCxE/ROIU5acj?=
 =?us-ascii?Q?ewSP4PqNQKmIqdTRaCU2aW0q+ZlP0UuJldlMjhAtdZnrUvfy1JVEeC59NICS?=
 =?us-ascii?Q?U29I1nV0lwGUOR/kj8jskLScs6KWdmGiJkeLSmXrW8jofmOzD9mdFLjov8+n?=
 =?us-ascii?Q?Wq0QmgTvhWuIujeYZQbNkVYo7GOOiIG3x8SerUE8spopXwvAANzli+DXrAiF?=
 =?us-ascii?Q?2Q404+iBATl3ZCw8glDxShAtnByc+I7E1rMt5B5tgWOlEdSUdeiLVCg9HnmQ?=
 =?us-ascii?Q?xQJOYbqcxmp6VdACYYdoNX+YLf5kh4d9SE+RROe+SEi9p3bxL/7frmBcTIiR?=
 =?us-ascii?Q?AMXPMrkMAkhnDcJYRKXxRkcDmZF7ccqXJId7c1rBPXiC+DCwpjnBmhx2sR34?=
 =?us-ascii?Q?nm2RDJTvhSl5lZRj0/Rbjlr9uAf8LwfYZdOAabq+5aEMPwcSGIECU08hKaEx?=
 =?us-ascii?Q?C+esLlRj/zacuIgFlTp+6x58tuJTgcZsuCAap+dhBVftpp87dfsKvDBsHi1n?=
 =?us-ascii?Q?j1n/5ztYoYIdLgFiy60MXRJyVhCGThyyirlnFhKdB74WFi3jdv/gJJhOQRu+?=
 =?us-ascii?Q?JpjarUXQzncMjgBhqcuTx7ugTiTgVMS6rdGPujGGRcUB3wT6nrHgx5GM7+10?=
 =?us-ascii?Q?TX4BDjBoJfU99Ifnmck88mCi3Cbn04UKt9NcPpA7utb7/DsCTEmAM4C4+ZE4?=
 =?us-ascii?Q?onD0YeHMRUJOhZ7JEzK9t7sX+0VnsnV0AM6kJJPfRjqss1xpWBKMQsmhWalq?=
 =?us-ascii?Q?wa6e8NlR6o/yKbeYqBKNbgrXnS5tVLNm2nS5zEU5STr8Q/E3CVj2RDJKc61T?=
 =?us-ascii?Q?6BteR4pgQa70s40xVsSVOhPEbBqYiVScNYy/AhjRGxJ0d9w7OE9KPoDB4/I4?=
 =?us-ascii?Q?NWOWlv8Pe7yeXiC9i7nkTlmkhoonmPZOoe3Y+OSc/uL7x/yIiWvNIR+GHfIJ?=
 =?us-ascii?Q?JRf6II4sYSkcjGDUZ45twiC2ZDEHNKs081iANLYlY5EPHKtspU8hCyIgTdN7?=
 =?us-ascii?Q?gDII9jcDl0wKM3iCJ6AqwQxHy4XC3Cr2EeWoOVNAOjkXAzP9bLP3T80oiReH?=
 =?us-ascii?Q?QadHjzqxXZ80aS0MPti7iVioFC81ixMyAJECHG4mjg0XmoTTQGjFML5lq2BA?=
 =?us-ascii?Q?W8WeZ9agDVRcHPDfL6n3T+sjYe0X0PBrv9FexPP5TnLMl1CUIKi43LUYRxEY?=
 =?us-ascii?Q?Lbn+jVX8yU1puGMNSN9uBRJF0a0Lmczrw/nbBAKLA72hCOYroCrRRTS0gkm+?=
 =?us-ascii?Q?lVPkeVJaSiBnzLenzzw=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6101.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 306a4665-e6d8-43e0-f2f8-08daef2d57dc
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jan 2023 14:58:45.2698
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: elPT9iwgHgNAMrOZAf84I2w1U2islb59YPmEQMaYizl1xYrA68D9dhZG37esaKTafoprASzzB9qgqSpOCu622w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4126
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

The following commit fixes some s2idle wakeup problems with certain firmwar=
e on AMD Rembrandt systems with Qualcomm WLAN cards.

3f9b09ccf7d5 ("wifi: ath11k: Send PME message during wakeup from D3cold")

Can you please bring this to 6.1.y?

Thanks,=
