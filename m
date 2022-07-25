Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60D325803E1
	for <lists+stable@lfdr.de>; Mon, 25 Jul 2022 20:18:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235415AbiGYSSI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jul 2022 14:18:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235189AbiGYSSH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Jul 2022 14:18:07 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2048.outbound.protection.outlook.com [40.107.237.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAF301EEF1
        for <stable@vger.kernel.org>; Mon, 25 Jul 2022 11:18:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B5DvrAQ+NVfoBFTqGk4Cc4BTy8NCZrKjLcYYR9YE7Z3flM1Lvmx3Xe+MyJl2HxnEuTbnvePRXGQ19T+8j0IT+himcri4ckypicHU5gp+vPJoNimJuRYkmmtgjco6KoivjACetW1/V8F4jqKA3rF/vf2wQ3sxAvA0vXNBFRLOaytcSY/PqATDR+HKW8eQBoAgYwkOGk1WS8IG+DhmksPJ5+tdSfsM12Nk/kws//MPv4F+cXifkIUSJQbPkidaltFtTlHEWY1PQi1uDwF7B5qyszdA+a8z0TFKJYUqIzPGwwCTTMnIzwZw7JvB7dk2ILL61Wr/WnhkEa+vwtHBNm/eTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QkXLUEQzv+R1SZsp8FVpwvcug3Y/pY4yNjYTaYu3Utk=;
 b=czMUJHlE9ijyLiCv6O4NXQK+YC+0wPtS8ZMhSLjJ8RcPsxv+6SNe8t6frOxiGiqdvAa3YxIchuwaba12TQAYKG/iCrobglHRdFdMIN4ORDAcypF9fmtBDnQeQF2KiBTT83LPeMISYmeTR8beOLj9KgqR5HYT8wD/Pp6WgKqq9l9NKDKTuMarMfRdwdh5fg8cJWs/hpzrTQiysF75KIDYg+bo4UzcDhS/Ig/7Zi0F8k2NUdbBEj3mGSC4Im1BvzvuvjemsDut94ALiHIGicREpPGo/D+dOSdhU9Ajzc6prRnqUutQT32Ozb8YvH667X7CiTM7eNES0IP87dH0xKCnSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QkXLUEQzv+R1SZsp8FVpwvcug3Y/pY4yNjYTaYu3Utk=;
 b=am6g5HYa0AR3/mTrNEfuQl3rUfFUF21UNaRPea20YsP47FMUc+NGqeeZ4ngQC6vHUm27GWlmRyHH5ZzHkDyU3X/o6BPDNT0JQO5rBQkJA4u+g8YVMHhLMCgmIPtXlvMR2t3wcBH8QLHcPrMa+CniyR+wpdZMCUovpb7HlVqDTIo=
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by CY4PR12MB1286.namprd12.prod.outlook.com (2603:10b6:903:44::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.18; Mon, 25 Jul
 2022 18:18:02 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::1143:10a5:987a:7598]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::1143:10a5:987a:7598%6]) with mapi id 15.20.5438.023; Mon, 25 Jul 2022
 18:18:02 +0000
From:   "Limonciello, Mario" <Mario.Limonciello@amd.com>
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: s0i3 fixes on Yellow Carp
Thread-Topic: s0i3 fixes on Yellow Carp
Thread-Index: AdigUp3uqqp3+v7pQqC/oMBIB4Y86w==
Date:   Mon, 25 Jul 2022 18:18:02 +0000
Message-ID: <MN0PR12MB61011ED7E1F26E842EEDC44AE2959@MN0PR12MB6101.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2022-07-25T18:16:01Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=62f48078-0309-4425-b040-bf917deff63a;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_enabled: true
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_setdate: 2022-07-25T18:18:01Z
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_method: Privileged
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_name: Public-AIP 2.0
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_actionid: 87f2255b-9998-4ce1-ab9a-bcd9fa42a5a3
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7b3b5414-22c3-4e19-468d-08da6e6a0324
x-ms-traffictypediagnostic: CY4PR12MB1286:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ve2VYbd0UVFxVZqYkQ51xbgFRS5CobR8cpWpWx2itY89gJ2BZ7okOxKQoxOd6klJRIaz/Kic5infVR8bRBbLRmBbePG698Rwopxxei9eECP39j2krtI8EnrsI9NWLsqde3l/lx7ZDNUahJOKZIIszJMcRARczMOjtbcXah4AT6o6ABpRkMwuDwpKDTMsSWaIg4goKz11RVExVCghtZZTnSIEf50w5/M0vXVqB4HSpxPh3BLXziEFyZ+Q+EbaFB7hXwSPUgQ5QNviQyHt/hTeahRngRJ7xXN7Hiw3WeCNFJYQBTAOaW1tk7PZFy+tFPa113HU3fiUSEzYXaG5JVeJUJPwZmaxnpqjlBFeTj3KqkS/IpRnJBd8gvSRlxdzKBMD98TIee9qNShT0YMnM8FI0D0qrsDCSYBDEHCsVOe4VqNamuejIXFxPVJv9gxBkPAiNBqPfmO65Tkgp1fBN3zpNpGxSmzJGWPrchD1/XaIIDCVlKLbGpNu15StE9djvFUPK3j+EHu/iZu4H2khNPiJKVvuSf84RGWPwruQNy3cQVhMsHQW7BeZxKznhRg47RVa8jFawbWT+6vLv2nn9bHA+hsY7qyqZ0wH7TUHCud2pVvz70ga7LHVCrlE/ZXQ7eGNJ2pussx2S0NGf9ZBtmoW+ibRNqhP5eFvuOTNhNJ9K0AWJsDhOqh9oyBYbFavqJ2n4pFtR15asKAmL2lV4HYaq0+HLQjLHU2KU+b5rUQ3LBOJO3OIzOZ4SxLt+z3o2IO0BfJewRYadqaFtE8K5glBX1dSgZTdmnDHilsBby9ksuAoLfjxM8Lu5Hta3CKNJLQQ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(366004)(396003)(376002)(346002)(136003)(186003)(8676002)(71200400001)(66946007)(76116006)(66556008)(66476007)(83380400001)(64756008)(6916009)(66446008)(9686003)(55016003)(7696005)(26005)(2906002)(122000001)(38100700002)(86362001)(6506007)(5660300002)(8936002)(41300700001)(4744005)(316002)(38070700005)(478600001)(52536014)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ylwzdzQ/6QjXDNtIAf0oZHQ6I9UmZm2W9wGY/MrPlw09B3lbXtSeKrD2RzAU?=
 =?us-ascii?Q?m2xIy4Rju8qIA6tH3N7aIjvKA0LSntWIe+rAg4lsc/8hZ8q+voXeq1q5ZxrJ?=
 =?us-ascii?Q?tq5TnDJabBhiD7wYkhw83+KR8EZVDEjVFE2W91XDe1r0pxfRianAcos0cSn2?=
 =?us-ascii?Q?8d+FBtUV76h9YbFGhgGv5mRydJygrXE3cxU137KZ0+43Skxr1Q7c2jec5TGD?=
 =?us-ascii?Q?6VFz099/hu4F7z0C3Bk6sy5oH/bqzXpSW6gdwgfX5SBkXgMAaZb8Gm4jBwl2?=
 =?us-ascii?Q?T7X6UdUwDslgI8SgGp/EsC2jpRyXaGWyZWcCZKvjYauqwuiNDZEXeE1Dgs50?=
 =?us-ascii?Q?PbD0nS5XFWvyH45VKM7IlS4aQc7+2/BFqXYI9T0dd4TqHQI5290khqgTtPoW?=
 =?us-ascii?Q?Y46edgGeJ2+GYrYB/uy8N9i3jdakdaehT9uAH7ajfEAeidUwZ299NbzTrA0z?=
 =?us-ascii?Q?+mIQetbh029hIyLRvsrKzgkb2J1KdjJynYSl0FQhOyqMieChYNjfx5qFBVrl?=
 =?us-ascii?Q?qs2Hq8UB4bRvcjAhOMP5ScrkCqJhYmbpdGpnM0FYJ3JQvG9sasnSHEjCVjYU?=
 =?us-ascii?Q?PokqzlLF1CXNNlCKA/9fWMgHQ2unfvq9BfmtHN+puRiGOML3O0wDM/VBsLiR?=
 =?us-ascii?Q?K5m6sdl2/73GZSnkaIWudGOG7HPmxJ/Vdt4egSG4Dnk6Tqmz0K4OBua9qaYp?=
 =?us-ascii?Q?ON2afEGhKBt5D2CwnegzGL9lRJq0VS+oHbRixj+dB2sw9utdHVM9YU61Lhsy?=
 =?us-ascii?Q?lnE8YkGAzfnFQ0tL0CEr/Pm14/lGkkQ53UYLVtQaUhRZBCtR4rPNIDDLX5Vs?=
 =?us-ascii?Q?F40+fBNKZgpU4rk77ggVU4rYD4VuRfeMKJplakf4qtCVnFc5SnDnor8XOptn?=
 =?us-ascii?Q?obx2tigGRDyw4AFZdJvdmSIFjzWNg2ncC/KIo0KQKUBz2Nt8hnU82qxnh+lv?=
 =?us-ascii?Q?LRJuIirN8YHHkAHeU0IVvKyMfEvXB68shPe32KyGZLpZA8yNSAdOuwC8vjXy?=
 =?us-ascii?Q?cAqg2pufZUfKyl7/p77GUhWiaxWQbIRIK3O25sD8S/XVPbqp4zyQqU/PQgqs?=
 =?us-ascii?Q?ZLkejmSKAcjRlcc9BkrwR3HsR5D+VvXOO3AH10bKOhgDTwoYfAfe588kWhZK?=
 =?us-ascii?Q?9r1lVhl1e9BNmT6tmWnbk2KFED4ZvC5p9CeFiRUwQi+BPdmU0pa/VUisJazi?=
 =?us-ascii?Q?SXHQ0HXGEUjpbE3Jl2AzcFEHQ94lMAbfn78MstmsknKGyWqDnCZpl5ts/WrY?=
 =?us-ascii?Q?tG4PTOaeOMb+MkI4JsXs3o4Z0W8+qFSNWL6MVvC3UV5bwELEDPsOGkuw8xOr?=
 =?us-ascii?Q?ezl2pMA4/0GlZD/Sgi5z2PES1OqEYvDDr8qtO3XudSSlJhKhAZmllGSjSAtY?=
 =?us-ascii?Q?ZZOu6PS46qxYZWz5cnXTjQLfUGvTwVhcKi23hTls96KbBrSX+1UOo6+5zR9I?=
 =?us-ascii?Q?IO+rXm139E56Wic2yVKw6Qu6xv3p3gbc3orLeyfTslfLLnbdELhGeaGV1Urm?=
 =?us-ascii?Q?Dwls33dX+6IoBwX1JTWLjJoIVP6FZbTWXNqaxNjJ3r95DPCvcB2ZyLpYOdvW?=
 =?us-ascii?Q?PeKYWLGqRXXj5cntciA=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6101.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b3b5414-22c3-4e19-468d-08da6e6a0324
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jul 2022 18:18:02.4175
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ngNs69UQn9uLcEKszZ5yNUZYE2EMHyl00rMvEwpH5tY2HAtIm/WwlPSnwVf/yQSF9w8L6K2PFrwIOubJvOLfGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1286
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

Can you please backport the following fixes to 5.15.y?

791255ca9fbe3 ("drm/amd/display: Reset DMCUB before HW init")
34316c1e561db ("drm/amd/display: Optimize bandwidth on following fast updat=
e")
62e5a7e2333a9 ("drm/amd/display: Fix surface optimization regression on Car=
rizo")

These help with some s0i3 cases on Yellow Carp (Rembrandt).

Thanks,=
