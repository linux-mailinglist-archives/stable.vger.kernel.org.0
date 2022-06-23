Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 659DA557E89
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 17:24:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231281AbiFWPYN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 11:24:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230508AbiFWPYM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 11:24:12 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2045.outbound.protection.outlook.com [40.107.104.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8D003B56E
        for <stable@vger.kernel.org>; Thu, 23 Jun 2022 08:24:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hTsJPfx8T7R5PZrU7ALS6lFbfiH2mLGWKpBjBKvHkyRNndInun5eaub/+el279pcR+wUjnA75GDKKNckUlf5Wkcl15X0gN6QUyIzwAvRVd54xOqULTqgwAzJgCdof4wMEyOiJGZ624YtI8Dwxd4s+2tUk1s/JmS+gBQS7mFjRoWuAl3jRQiTpNZ1oi144Bk36D8mhRK5NLpadSInC/ZtYmVDRuOe+AZOqv5V1Mh4hk+S7Iujz7NN7F8Tw7C5EHly+4oJyvvh1+uJR32JNde1ztzfg7d1qrDDFELLByf0QLxGqKXblt2rqc+hT/+rDbF0hH3XOS3LkX+AAjXzhYgCfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tKSiGtqXuXqI1OD88Ns89b8RUp1J4UfWQ5dnvdvB1Ec=;
 b=jFA3IRDvS+o8R66rIgGfaMmmVYjssG8qsJ5/U4MCFfj54zaIe47a2+CWJZ87IKbs/b0ZhY/vYDR1ak/Qyh7mRFGHcjsxcF6P4efu5MkG7RPWfMJOpLNZpZiCq68WOAjLWC8fU4GLjyxqzG/9iTgsjhzybSwurcOCxou+F3dcs3tLQaYYqRgDnxVZ+JLB4c9cPUYLDw67ywdLxDrm8jzNt+U938AkfsHibn3Yz9y6qEDcAoPJj1GLMIrgcbwrFTtlCXXPgZXfkdA2xfm4kVWS3rjae31JpdyVV84V0HmXCtVKYClWJk94P8YaImo5ZqfbRbkeltWnPw7AWYqqmH+gyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tKSiGtqXuXqI1OD88Ns89b8RUp1J4UfWQ5dnvdvB1Ec=;
 b=Ln3S8dMgbYkCQeob/g4KUfXZv7tm1t1toezZ8tqA5GGLpChiAyg5u14K/gL8xreFrUKfkDk/3aNc22cq2GymSJY5myP4Y20u593znX8PwLcR8XW87A7S/hVlXCWgP7geeGo9rj82WaFqFN/3A5qrgj6bHh0BBQCFzIBpGZPoSGY=
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com (2603:10a6:150:1e::22)
 by AM5PR0401MB2531.eurprd04.prod.outlook.com (2603:10a6:203:2e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15; Thu, 23 Jun
 2022 15:24:08 +0000
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::4c14:c403:a8a4:b4e4]) by GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::4c14:c403:a8a4:b4e4%4]) with mapi id 15.20.5353.022; Thu, 23 Jun 2022
 15:24:08 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Mathew McBride <matt@traverse.com.au>
CC:     Leo Li <leoyang.li@nxp.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] soc: fsl: select FSL_GUTS driver for DPIO
Thread-Topic: [PATCH] soc: fsl: select FSL_GUTS driver for DPIO
Thread-Index: AQHYhF7Xze/JUEFML0mOoeg4LJ6Dhq1dIdGA
Date:   Thu, 23 Jun 2022 15:24:08 +0000
Message-ID: <20220623152407.ogqejuwpluxonlbq@skbuf>
References: <20220620043243.32235-1-matt@traverse.com.au>
In-Reply-To: <20220620043243.32235-1-matt@traverse.com.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8de6e4b3-ceb0-418c-05fa-08da552c6ae6
x-ms-traffictypediagnostic: AM5PR0401MB2531:EE_
x-microsoft-antispam-prvs: <AM5PR0401MB2531333A016AB92C4F63C7FFE0B59@AM5PR0401MB2531.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ow5GMzGBiUQyXC55H3PWOa6eWB26uXPXmEpHsUdpMuAlWxrTf4OmzilHiOL64QG4RZkuHcw/OPe9b6p2bVGoyXghl1amqBeLA5oY3/WygspX3c4UMV2XvLlAysMVCbBZWKm1VSBqw+bJT27sNwk7iIL74VkALeEByXWav30Qq/0fd5/HS4R/uNxG+KazzvppFT4TsmUV/WDbq+KVy8TkRUiP9vRQGDee0aiKArl9ao6iizmhpTUQ9pjpwfgLccPmyqG9xLjQSMjha8AVHyUEtGBpsIf2tf4Nnxqtzv5MI3VZa3g1hrhpqfuudGupPDPQavhpaNSMwOHg7B56ZakZdoPxiPov328VFMdaiK0fzIytDgsaTEvs7tRcOHTGxa3JbKN2FdG33A/GBqfTHWM85PllM+AtHhsS71LOJB9R1bViuAxaivjtA+8MXwiMolTu3UEBfCZHQbTHHVkAxPKiHwNv201fTgt1hkmd87GBR17jAYv5m/y1hvR2Zc4DWy+aoD7B89HzQ/cYa4ZSSPqlmpdPEu3gZU6/vCLlRCx7aKjqhyudCpUR0I8Oqef5P0PpCla3ZC6PXo+cWmeWMgjvTBS4GsyvFpmxOAkXjcv2QRPd7KXOx1qR4RqpzH5Pp1IrORevgL9zLkozMvf3zX7JJh16STM6dUQpBjYdsjX0tCVkb/TaP0WFQYfeKokVBJj6R5GhQDSqOKaI/c+DOaw0fv4J1i/bVOUabT43t0fu3VTZaopLSQmS58D5xBnZM08Z3siEKuNs8LKtm9L+vPvRyQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR04MB9055.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(346002)(136003)(39860400002)(396003)(376002)(366004)(8936002)(64756008)(8676002)(33716001)(91956017)(66946007)(4326008)(66556008)(76116006)(66476007)(6916009)(316002)(83380400001)(38100700002)(66446008)(2906002)(6506007)(4744005)(71200400001)(6486002)(44832011)(54906003)(3716004)(478600001)(1076003)(5660300002)(26005)(41300700001)(86362001)(186003)(9686003)(6512007)(38070700005)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?NiF/a+l55Ub1GCH97z3wmhJEv75c7CEE9ZSt4Sdlu7YNdiHB2yF7mh5wAX7t?=
 =?us-ascii?Q?n+yOMduT/rpUNTFNbFB2yGgNJoiGt+hxMeY/+/xFjd4izNpb6+CzM4TTOFeX?=
 =?us-ascii?Q?usA9Ihhcb0nGX1xZEPPJ6q8AS9j96Ks1Rdri9BVu2EQtLFbCygS2Q7SWkgZT?=
 =?us-ascii?Q?B4tnMkQU9gm7oPssERSDYktk8ykJVn3s6mDrFLoIxpIApdFXbl/Xh3Fs6vLh?=
 =?us-ascii?Q?PfNvBqSu+b8yZrGNJLV9qJCiaDtIUwqbAErXBc2LFrU9udEzPgb9Q4QvfAGF?=
 =?us-ascii?Q?RhJPgGgfilPtC3kZ/xM/BdIIt/HS55Gk9atuuWLBkM4G6VXFARPm5ku2BXeH?=
 =?us-ascii?Q?iQFfgAcT2j3DjRvls5lhdtG32TIHQ83Z8Y7J3D84LF2Ja7ybbnixPgaKP7Kk?=
 =?us-ascii?Q?4Yw0LQn6DNe+nnr/P6wAozQ/KQzr1lYkzmeXPW2HxdHq8UsC5LJdjqO+cVUA?=
 =?us-ascii?Q?h67IzebIPP131U4atIh1msNgxYm2gGyvrIbBAxfHPBYhCsUj/n5rNWviGzT3?=
 =?us-ascii?Q?ndA2pXhPRFqURR9zFbGHCT2fXXjtvg2ttZ8Q9gDbQ2Ut7uCCFZgexEXeDxeV?=
 =?us-ascii?Q?t11DQn2rDvMMPgrA3sW9xAzlAtH1v6D9oOzCv67biPmYBgRW/PYWL3k3S0Ce?=
 =?us-ascii?Q?zFoxnfKrBiLTMn9vZXR3xa9W3VBFvc3FLoWpQz0AwBWJtQCD8RtOxYOaRML5?=
 =?us-ascii?Q?zwBrIkbmUIzZ7M0mDDEq2CXdb1j9MzpJmHZkKEkeMFDmDrF9b3TIG29LYW/K?=
 =?us-ascii?Q?1OAloV0Ywzqb4SYnUHs1D4faRpuB2sq3aq8pmww7lG3qxCLrcSHGsZr+lvIu?=
 =?us-ascii?Q?OJ3WeDQ5GDLU2J2TA9iNRDtIxjl1ShgUpX0DZ0k9tXc9Zlh5Z9J6kqk7J3mj?=
 =?us-ascii?Q?bAfvKnfqaBtGeIP7wPhjfylP56EnhjNmLDGePdeZs6P8A24y58X3ZNDErj3J?=
 =?us-ascii?Q?onJMZlcYJLCnPpLZ8uMU2kcAX72BNkJFY9JX8QZpCn6EKkGLz3UGLl08LnJj?=
 =?us-ascii?Q?AaJdOrDWNTASALAdqErSRomUeToNsq9L9mOgfgcSMgur/XVj8wxxIIlJqtPz?=
 =?us-ascii?Q?xM5SG14OaMEn1FuukTwWrUwCpNR/jNCpsQ7K+U4k7lUbJMfj8xTi629Bddet?=
 =?us-ascii?Q?XfqjB0TvkXECdJmtKL1cSffjJUtFwbPD39ghb9mNAKeStSHSy5rTAw9j8l+/?=
 =?us-ascii?Q?aeEFhMN05l8HU8/asUqNrXDT7ds+RKtbqvYaInK2uh5XR+FZgb/LZJQAiueR?=
 =?us-ascii?Q?snKiulL2rA02hN/e3TOBuBI6Q/saGAmLWjROG0x4DouoLeHHa4M04k/6JwzT?=
 =?us-ascii?Q?qsxcsfmt1u8qzmNbWHjnDHWjpkJUwtUxn63sVMQz9eNCnwlC95pL89cjss7Z?=
 =?us-ascii?Q?wAhMg2IUvgdZggZxwa3w0L7jZolwjeEoFjHSqzfumRK3KQ3n2Cwkxt+gEI/X?=
 =?us-ascii?Q?T7gfZ07gwQsLh5QpN2jTrd/r8U/cmHgfmU3OgZlzjskJfZZB+b/S6WaFV4vD?=
 =?us-ascii?Q?rdK4+c2V3CHM10qRey6XqAsNlL8wN4YzZefkd32MrozNrqgUzTD6nEd7Vtmw?=
 =?us-ascii?Q?/2KYpEamZ0p9bWK60nwCiVatlrebHjHwDhqSW0EfqxA+XnXSfpRwNVIN9w+4?=
 =?us-ascii?Q?gw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <CA01CF9C8A132F4B92FC5CF362A221E4@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: GV1PR04MB9055.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8de6e4b3-ceb0-418c-05fa-08da552c6ae6
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jun 2022 15:24:08.6571
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0f6pHUq1e431hfOAR3et+GRhyeuyWYnKEq9MMhkBEaLNDGj8k+UeNzqQnFFy3j3yD5HxnuE41Er3xdI0BoWRkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR0401MB2531
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 20, 2022 at 04:32:43AM +0000, Mathew McBride wrote:
> The soc/fsl/dpio driver will perform a soc_device_match()
> to determine the optimal cache settings for a given CPU core.
>=20
> If FSL_GUTS is not enabled, this search will fail and
> the driver will not configure cache stashing for the given
> DPIO, and a string of "unknown SoC" messages will appear:
>=20
> fsl_mc_dpio dpio.7: unknown SoC version
> fsl_mc_dpio dpio.6: unknown SoC version
> fsl_mc_dpio dpio.5: unknown SoC version
>=20
> Signed-off-by: Mathew McBride <matt@traverse.com.au>
> Fixes: 51da14e96e9b ("soc: fsl: dpio: configure cache stashing destinatio=
n")
> Cc: stable@vger.kernel.org

Reviewed-by: Ioana Ciornei <ioana.ciornei@nxp.com>

Thanks!
