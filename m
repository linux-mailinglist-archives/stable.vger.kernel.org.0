Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AF014B6814
	for <lists+stable@lfdr.de>; Tue, 15 Feb 2022 10:46:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbiBOJqD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Feb 2022 04:46:03 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236100AbiBOJqC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Feb 2022 04:46:02 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2053.outbound.protection.outlook.com [40.107.22.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7BC9E61E1;
        Tue, 15 Feb 2022 01:45:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mWPXejBijOU+K2bL61geziPQo7XO4QL13BBN1RdeyolEBD+12X4C+rm+tOlXuwckZ+blwTcMVBv9IsT3I1wt5JQp8+3uRVeGFtMSKBEIcmHHpUB0uWIEs1r4T1E48PhGnhhkAiGobna1ZTXeDp3b/Ax5km7IRIE7mWcLirkMoGvr5vSECojYk2oYdbtA6GfcCKSJHh+dX0s8AC/W38qpZnB37dOWeV0rrThaYJrgUuoUKB56KsPUiIcuX0BGfs/cSewrj+1AdHKf3dNmzBr5anXEsdQzCNX791e0yLW8l9ChL5FkAe+hhRvON+QH6l7cwtyFVnkTGDgg+xxDqDdaUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bd454CJiropfMkowmW0+BK7L5Fulij95vMOBvmURE0o=;
 b=Q/jOqL9s4+XKbamBEOBwPXfUmNCyue3MSL+HZSohlO6WuokJ3ASp8YVo9WTA+Na9m9KSFzLskeZEHL8ofwLWh+Mod6CuOWKGFAg7JH6Pl23SJv9GW1uCT6RvicxquecS2zFL5u+0/uhf9f631a3VyH6XBXp5n6rBjgGj+2XdtusPSBNQ9GKOuTf+bRL/0zBtDD4E5iTBSTJIB+B6+V6ddGDNUwEpbv/rnEoWwtuO9HF6LjNbhhtXLRvIqyx72PfQQjahKGW8nhokhZN0p4ZAR6qFYyLjTEC67QjRUHwx5DNCV76eXHpbh6dgtEY7AakyNDL+KabcFdL+plXcb1IDXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bd454CJiropfMkowmW0+BK7L5Fulij95vMOBvmURE0o=;
 b=hEE1L4g5WENeUDxREnWRp29DZ/ZNw/8V9bWS2hmFk76v+SksbRfH/m0g4ICN4Zw+rwIU0z4LamGh4Z0dOyVyTCuFgscQ+yBwI31dnrjiuYQ9nUd5du3OT6XV4sOAkXzo+edyliiEmeOCssx+0jCPfao7V2kskL51tLU03Z5uhOY=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR04MB5522.eurprd04.prod.outlook.com (2603:10a6:208:116::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.18; Tue, 15 Feb
 2022 09:45:50 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Tue, 15 Feb 2022
 09:45:50 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Alexey Khoroshilov <khoroshilov@ispras.ru>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 073/116] net: dsa: lantiq_gswip: dont use devres for
 mdiobus
Thread-Topic: [PATCH 5.10 073/116] net: dsa: lantiq_gswip: dont use devres for
 mdiobus
Thread-Index: AQHYIYdYZ2ltgIxviEy60n8vo49ImqyUW8AAgAAC0YA=
Date:   Tue, 15 Feb 2022 09:45:50 +0000
Message-ID: <20220215094549.7no3e2repjvpunyk@skbuf>
References: <20220214092458.668376521@linuxfoundation.org>
 <20220214092501.284425363@linuxfoundation.org>
 <1e75b66a-295b-02bc-b4c5-421aec2cae96@ispras.ru>
In-Reply-To: <1e75b66a-295b-02bc-b4c5-421aec2cae96@ispras.ru>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 45108298-a6e5-48bb-1b9f-08d9f067f341
x-ms-traffictypediagnostic: AM0PR04MB5522:EE_
x-microsoft-antispam-prvs: <AM0PR04MB5522E3B1C7CB6F22A6C7EBF2E0349@AM0PR04MB5522.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kbkx0uq9oTvkvDQDqbnhEEkcTF76CTcbB+9qMevuJGE7jnEs3tM6ke+fCa8c7ejRw/V8uYaNinZ8MvyoHzTpMslcvFH+9aLkRqm9DRRe5zqG+CCj53MHCcHKNIumfZAB2P8Qy+Xe+8V0FME8vpVnNYjQZCTz1E1Y+JtnbbMptBDdGa+fSkAik8+192Zo5GhXmVffb/QVZc1nD4uZUGKtrh4uxDCfeKGeLSXyjfuGiif4h6i26/swRxLEI++di05ItWFZurwKZi2EtgQCvdAWwLwo2mrpCPm7Nq5QEJo8BmLT2Rz1U2qsOWzjLCmtp1EgbDGQHnrWd4rXmJOc9fz3LuTStVz/lOGilWk4xKVejnkWfecmr0lHWaV7/SGI9XG9fb+cZYRbPk3uGj7pOUlOQwmvl27/UloxDOwQntjn9swo8t26uCFCH6wMN/QFCK7XvXklOMwEKnve+98YyCxVuPdx9pT+fRt+1bhVXdPzT023qqFUF1zCfygyYGrV4aMu3A/GmCvZo0n2dXyMopwbbuGmzx5jxLIY16slxwctrENbCadhjFK9UBcyivACjUBmF2QMXZJVyZhpkrQRdT2LIAdhjPTRMy9fFJLwKnIwz/f2DYQDdkERuendcV3gSQ5L3MBBkdAMU7pOmMH6N41KSJDaqA/2f62+BxN8dsBGjN5Jb+1fZWYXR9hktKopMw0cjoLj1P6kB4cLj8lLwXQXxcV0oHIZX7eJ5m07EBlObOQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(186003)(26005)(6486002)(86362001)(122000001)(54906003)(6916009)(508600001)(38070700005)(5660300002)(1076003)(33716001)(316002)(4744005)(8676002)(2906002)(66446008)(66476007)(66946007)(8936002)(4326008)(64756008)(91956017)(76116006)(66556008)(6512007)(44832011)(9686003)(71200400001)(38100700002)(6506007)(192303002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?5oZ1InNrhcsM3Ye11154ot+SNjsBU/JdRYWdxBu1qXfFr9gkLqskgR+ivFyH?=
 =?us-ascii?Q?B6mtBr69qPp1c61PzVPgATgrEWkEeG9tuB0kJiwQiEeRhUgaGPpVBdPpCIl9?=
 =?us-ascii?Q?j2HJaPqfoVWzN+yHexcAmEKgiiuMalsWXqdgHvivAH0XfFcEpJdbsvYmccsa?=
 =?us-ascii?Q?AZq25in8B7KyFRzL1pC1c1TL9NigfsKHy9HS2vaSbkcjKwTq1p3xx65/Xin9?=
 =?us-ascii?Q?5VfOs8fCQrX0YH6RYQQzGHy5mLUHjmB8ZOvVeCohAzOih65ENJgbzO8o+Ea8?=
 =?us-ascii?Q?AgUUGmj9k5EEUPP7OqpIaC0iinWys4QEvKa/zNDiL+v2kN7kO/LtL4FN0dVI?=
 =?us-ascii?Q?j1u+EHRCnxCBFYgbf/FOz3CXCxrdkyW521WUt1h7xnjt4ZLQ3X00Zy39CP1Y?=
 =?us-ascii?Q?xikdnbE8DKXaXd0TxurvDQQnJxgJSt0I3hKpzg1aXfMeRnK/6hvgXhyeD8xD?=
 =?us-ascii?Q?obY/NifNRWl3jQ85DXwlpZKvZNtsZtA5kvCPLb8VMR3+6EdAs00RLohggcUO?=
 =?us-ascii?Q?j3ftVzrTbTLJntDG3xadtbCIfIMX9SKBTu3j/iVbQRy3fy/IjxL2REJRE8w0?=
 =?us-ascii?Q?eCA/A4vrbm2/NweFtteuigZjx5MKzlqTOOu75j89X+lwQKVba1Hy5h+B0w60?=
 =?us-ascii?Q?aUt8xxIq6tSNpCIEC7OCb5H/9bNb4yz0dVR4SBh3xHPatzlo0mlQPIG2r5wu?=
 =?us-ascii?Q?11q+hiM69LfOH36YnTGFGe9pYNnJG08VR5KMkTHS0+eA/EwbgvvYuIZ5FPQs?=
 =?us-ascii?Q?B6iUZmIQ+yPj5GzJ8z0/Uhj5nbK2sTB34s9lCylSdr3BAjBmMfU3GZ5dRod5?=
 =?us-ascii?Q?Qjhn7vGk/tgKhm0qJIu8xGNkhIpVLV1xRSoXj/JkbdeBZgJB8+Ewm8ifRDrS?=
 =?us-ascii?Q?BmYo6Mhd4kqtqglD5AcDDhuRDGJIkM5hrH5tckDOtyncInOf8vzuUCdVRmnR?=
 =?us-ascii?Q?D+UYb+virWs5gxwyKcNWOEYBVPvTGQKP+VjwNtpW9i3DV25rJ3csdrFzByOK?=
 =?us-ascii?Q?GjQlpeL36YYpdYF1SiPwTpusDH7bARqELKoU1UQacQblh/cjHl3zWVjt+/iq?=
 =?us-ascii?Q?gHnpo4OxP/PwDrcYP/F7bvs/fviFHgHZAAT8PgtyMKUfboyF5OiOxvU6L14/?=
 =?us-ascii?Q?mWpIH7yysriTL4zBnys2tx+M3uCjGgR/25I4JgLM5V2DMYkyQTdk0mm4JHI8?=
 =?us-ascii?Q?XrIKBIKW2THGhitMnaqP6cJGbiNX6FcbHFF6DwEUpoVQuebEOiE9kmjgi7dr?=
 =?us-ascii?Q?hyO7xMDbu1uleH/JJyUEO71OKus7ogGImVzXGFGooQgJvz031Eo85ou5dRQy?=
 =?us-ascii?Q?5Huf9rlUvcXE8kan8iIQ3mEV0V8U/+Y3I19IdNTZezhRGSUehEwLRqvYfaXn?=
 =?us-ascii?Q?UlxaQE0Kr5fqCYS8XURcQXbVgZwHm4LCfr7SGbx5J1oBc4HmhATrs0a2n8WS?=
 =?us-ascii?Q?jKnydscjMGU6OmESaouwzcGmns3e7RXm8ZMqR5xMTRxm0bV8vFZxG0kuUKGg?=
 =?us-ascii?Q?CxJZHXgnkL42YvizCAFsUCTXpvHExXuB2tcJj9XWNkzbd7++Y+048HZ05jrY?=
 =?us-ascii?Q?/pP4GoEUbzab80hmOmYZaVj5llYFcndlrc6n6Zd4LKHvg9grJGHdLkGMzLxZ?=
 =?us-ascii?Q?y6hXIyqEFOoIt6gATyEqqXI=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <437CCBA312A88046BB0AE03F915423BE@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45108298-a6e5-48bb-1b9f-08d9f067f341
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Feb 2022 09:45:50.1657
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: E87Lm12gtTW+QNVOEzZf+GbkG4EPyqAAqBfXxRlJ5RE7IoHi6BWRrv8Q6z7GzgshnOT2p1QxAcXEY0IHuk3lxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5522
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 15, 2022 at 12:35:44PM +0300, Alexey Khoroshilov wrote:
> >  	if (priv->ds->slave_mii_bus) {
> >  		mdiobus_unregister(priv->ds->slave_mii_bus);
> > +		mdiobus_free(priv->ds->slave_mii_bus);
> >  		of_node_put(priv->ds->slave_mii_bus->dev.of_node);
> >  	}
>=20
>=20
> Should
>   of_node_put(priv->ds->slave_mii_bus->dev.of_node);
> be here before
>   mdiobus_free(priv->ds->slave_mii_bus);
> ?

Thanks for noticing. Yes, this would avoid a use-after-free.
Do you mind sending a patch to correct this?=
