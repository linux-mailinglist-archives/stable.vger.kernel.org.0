Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFA90506239
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 04:44:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344556AbiDSCq2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 22:46:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229993AbiDSCq1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 22:46:27 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam07on2086.outbound.protection.outlook.com [40.107.95.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F62A1DA6C
        for <stable@vger.kernel.org>; Mon, 18 Apr 2022 19:43:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nw3lKVj1rHGUzcnljur57BmC+1J4qX87LYyvhFhO0lqvLTaHLNk8qXf9JUdUQ0pOMp3B+tEFPHQHaNeejKvExvjbGLAiT4FrTznlTOuMbzlJzVyq2yeu5PZ6AnUi2Ksl63lkHNKqmQhYLW4kloGKGh6zGKSmQujXC3F+TTPFyYX1YyghG5VoOzyxPHcw39yzwsQXHPtm40b/Vi69Ig0kQuT2D4ZGk1IjBngRGWt/mzM02vOYICwcgvMPuor7+UzZAzU0mL0y8K24rTWMGQ73yRw6d/zffoFg8QmPACc13B7Mj2bOzpIFvSLHlR++6FwOtS0fNwIcRGFEPN5tLVeVAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YZZYBmScxDXQruRAkxUTtlCucsfUZTx/twUjEyPQbug=;
 b=jjfgWauqBAN4qmtlcGVHcadGoh4lcdq1a0XwqRLldfp+DVHqv+zicVYzJWBD1t+PUZYTUqiqnv8LnbwVovbK7+L/ITOU+UyDhPj6OH5DYkT6uj8bXnQxZx1o+IDMUIchoURHb4QntQbqJmaQUPBvRE99IJ1z2yug2A9w9eYvQx0rDY1aCSGcZu8bZx7IB0foty00FtO7Sg8TTCGjvktL6PWv2VBFicMNURtXu4qhA9tc9yiNeWgmUrmpRLXkulB2Hc+eSn2ibllxtDtBFzIwTASlVNMdtY2MC+vnapt6CYKPuhWULOhif443UiEHDtWqnITu7jJHzsHBN60jrQ1lTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YZZYBmScxDXQruRAkxUTtlCucsfUZTx/twUjEyPQbug=;
 b=YJOwpPowODMIiC/odGitfSEa/Q7aWW324QspNrPnL8MV23T58AGj4YlAm/MFGriEjsCZ6rRFZaqnzz61MlX5h/jz0Bg4LQ2PgjZTj/nGiXQm7fFnxb19vy+4zpzg2xaSPk1zHmCavXaupAEUJbKDjhZdipRSvQWwWPyVUvDjIBY=
Received: from BL1PR12MB5157.namprd12.prod.outlook.com (2603:10b6:208:308::15)
 by LV2PR12MB5989.namprd12.prod.outlook.com (2603:10b6:408:171::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Tue, 19 Apr
 2022 02:43:44 +0000
Received: from BL1PR12MB5157.namprd12.prod.outlook.com
 ([fe80::3157:3164:59df:b603]) by BL1PR12MB5157.namprd12.prod.outlook.com
 ([fe80::3157:3164:59df:b603%8]) with mapi id 15.20.5186.013; Tue, 19 Apr 2022
 02:43:41 +0000
From:   "Limonciello, Mario" <Mario.Limonciello@amd.com>
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     "Gong, Richard" <Richard.Gong@amd.com>
Subject: amdgpu PSR problem in 5.17.y
Thread-Topic: amdgpu PSR problem in 5.17.y
Thread-Index: AdhTl0HgqP38RZ26Ri6xaMHeuVPfYQ==
Date:   Tue, 19 Apr 2022 02:43:41 +0000
Message-ID: <BL1PR12MB515719844E774D18A381A2D3E2F29@BL1PR12MB5157.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2022-04-19T02:39:46Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=7319104d-3024-4edb-8a0e-b05df1aa88e7;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_enabled: true
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_setdate: 2022-04-19T02:43:39Z
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_method: Privileged
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_name: Public-AIP 2.0
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_actionid: c8b01614-49a4-40b6-9ac2-f96fad50f913
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a22e052c-8714-4e4c-d810-08da21ae69f7
x-ms-traffictypediagnostic: LV2PR12MB5989:EE_
x-microsoft-antispam-prvs: <LV2PR12MB5989C106359DFEA980C0EDA7E2F29@LV2PR12MB5989.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: V46z8gPQqRh1oNVN+r4fqRD2sstboSPOLLTUERoSjalUVWtMZk6dkrA+suUOd18ldKVv1+hzuTwVZY7ZcmQjQa8uMZ6Vc+8b4AjsdmGmpwurmtC5PQcH4GGKHurtw97VqIosUC4s92a4QKLqRWMrS8alN2rNQ6dnCJPwbqcxDNPvOQby2C1pG/7kFNuQ509uAfKuGI1K5cf/PhGANE6KulOhTJXrhrCQ7e9w15TgCZ5qQ0YxMStAZtuAbdu9/cEd1MIlwRvEPuIBVvFSOBpMwiq6Pk8bXlD3KEluLf7tUWKyQm9rT9H5NureiAEnxUeKgouCfJPjsMV7zPnV8Sd3gEiSNr/EEeYeR03ZsjMZxSx2xnx3S5e7crNP3P6uHakiPjt0NDNV9+hQdgkyLiDNFor3+iVBinJBD4RF1RmtPlbNQMd6pOcBLwd8C29K8kCcaDIZSp9/A1jeJWDEWSYRHj3Oa9SgtlTrg2i0UcgA+FzcT4huVsN6NS7zc7j1zean2Fb0eQN6Mz4IR8/c7VVJ7dA+Gl2jHJQZVVbdxM80zQtGAh4hjpsj+sMMJ2SY196sE+wOdZy6apMgf7B/vFLq1p93D+VhTa9s4gxdR1pusu41mdeRMtwbjnLw0vwPhAl3CK2FKikCAdgQAbZ1vgLtx2cQKlb8ErWreqpkIwMAHjuptv4mxOoRCzYPz6XBRpS/12nrapDyu2VRIPV8bzbxeCLuhNkUHuFJivzS3zV6z2Vrj4LCrnvoIsuiLHMdKPNPGQSr78Edt4ph5xzLIJ7wRNh5y7HMdQ/f+NKKtOnWVc0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5157.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(64756008)(66556008)(316002)(38070700005)(4744005)(4326008)(8676002)(8936002)(33656002)(508600001)(122000001)(966005)(52536014)(71200400001)(5660300002)(86362001)(66446008)(66476007)(76116006)(66946007)(26005)(55016003)(38100700002)(186003)(9686003)(7696005)(6506007)(2906002)(6916009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?U8gB5TaJkC7Jzwc4aaRj3K26YjDQuLaUzwQo/LiMQxJJKJzexvuCkJBBrIUV?=
 =?us-ascii?Q?r8b4GQLMxrY7eAzAhfThzHUozgyQsypATRMafy/roLwnuQ2upmAy3eN0zYvX?=
 =?us-ascii?Q?urjqOyFNQWa8rZMLKyoeSvePlOumyRH8L8A/ZVmur+8nrOHeTFMuJq+g345o?=
 =?us-ascii?Q?YrcjpVJgh5MOF0GsRd0J/htiCB/R/N9u6XM4VN4ezEDqQ7j2NSn67BI4leqx?=
 =?us-ascii?Q?OgeAjV0SpSMbYwCQ1wBia6ZCbPf0WJMKukhEhfaEwhcMMAv/fM+tRuHdOwtV?=
 =?us-ascii?Q?zfZSa8pwyV6drMDNVdX7EZwDHw2oVHlpTxoA0HULU9EO2NSzolqN80ZkgqcO?=
 =?us-ascii?Q?iklTtKk6OY/YDh9ootfd43tzxlsqnXHaDQflIhzaMTH02sHkatbULZDi/zIE?=
 =?us-ascii?Q?4XbRqqtGmI7RpGmvQ2sZNDOFOiMfdO7RGuJ7cf93DZDLAe1Wy/KKO3PuLPXo?=
 =?us-ascii?Q?rFGM+fJHdnrhzy/tCH432NQ7IniEnjCLpBCHmMIF02dFWtzS8XUia2LBpkWN?=
 =?us-ascii?Q?Ze/xrTk4q2owfzBB6TQK0ecREUfkYv/KqFUlYSH8hZdeEoeXj7dlOkqwNEmr?=
 =?us-ascii?Q?05alz/1nQv//GFdhYZRxjzvziTCb/XOcwmhUDk2PsEQ44mPtQXvNHi2i0bDs?=
 =?us-ascii?Q?bdn9GsSJD9Ngw3QQF5xwkxtPz8AmQ0Ao7GJCYFM/e0hPdQXj+BHxVzMigRoB?=
 =?us-ascii?Q?mv/7YDIFZu0WqEZ3kQe/CYGZWCXyFvOFXbGj//xSZtuSH5zh4LwnbCSkABf8?=
 =?us-ascii?Q?OMbtyMPOsv//Pts+Z3U0rrr6fxM1SFJOXcpfOqh0SWLiYGMuJtUoidp/Fdj0?=
 =?us-ascii?Q?VN/PTCAe6V0yeaabj9YuoakGzP43fQCjvBOW+HiEU+OS98IVLAMTrIPVQG40?=
 =?us-ascii?Q?9SxeMNlsTMeb7YHE7HDurcmXHZoPuF0e7bvMJCuNqGJW+oYsx5fjktVsbsXf?=
 =?us-ascii?Q?GA4x5x0LwZZ1iyM6uOGK0Qvq0sqZkBG2z4mkB4bi0D3YYyOA0ey7F0pq5wLh?=
 =?us-ascii?Q?NzXXqf+WJEzg9vQGBqFRDo9ByIBKnRlL6qQiTpML0BUco3xmFFcQ+5NNCuNO?=
 =?us-ascii?Q?G2XX4WBl40jZiyT7jbMBFQIBfa6YITvBbNqXz4QirX5B0ycsf2aNAa0m9EeH?=
 =?us-ascii?Q?+vJ5yBAbTkvb3oipIoq5WfZAmSeWJvS3X347lyOWISz1LNphssExiyupB0wa?=
 =?us-ascii?Q?Zyt6eBHrPLAxiHIHFc7GbfpXnTwXBBElb9cBjp9HXaWRDbG2TcTBOe0WFQtk?=
 =?us-ascii?Q?4GvQNbnpHLKuoJI0E/CruFicluja3Ac5NyeYEvEey/3GImDShNnwZRD64P2q?=
 =?us-ascii?Q?Yn0F/HY/qBH/fKkgielhvHlxQ1yvBQY2nxOrBxOfO3pHOc45uQ/j9AL5Xcum?=
 =?us-ascii?Q?XcHbFWHJ/6hhBzdrB7YbUTWsmLC+TJBoC0eW7qg6sMX0ob9QYdbhk2a6++jw?=
 =?us-ascii?Q?15u7PohDE6sYBtbpWyW23JQnVdyuCWeSjcCwqpfrg4ig/Ow6koMwFcBiu6vU?=
 =?us-ascii?Q?xFuZt562UILmLUtY8aZlDutRnen5vOLIZX2wtUS+OFIXb2wZrqtONAKE6qNM?=
 =?us-ascii?Q?9+1iranvq0yKoxqesfef1VU4usbFYeSUUOzc5Xd4RDKKIK8gpdxEZHMR4V88?=
 =?us-ascii?Q?WFgMpSYmDUw2MKXb3A1liV26rwlOPhwZZeycV2/sINSUHOKvRuyjFhQBlpwg?=
 =?us-ascii?Q?awmE3eNcgEa8NtHk6lTUDxSPjwbWdqa9zwy74PW4wL8V8PuMjSdSWqKe546A?=
 =?us-ascii?Q?R1Oo8V700w=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5157.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a22e052c-8714-4e4c-d810-08da21ae69f7
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Apr 2022 02:43:41.1754
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DluJhPqypxWTJI35wc//RKRhsiqDL+s3+HDTap9TG2bqZl8RXzOU5xOr25rg8UqotGBHn4p8Ztuf0W/1GKAKaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5989
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

Can you please bring
commit 1210b17dd4ece454d68a9283f391e3b036aeb010 ("drm/amd/display: Only set=
 PSR version when valid")
to 5.17.y+

This fixes a hang in certain GPU firmware on select panels.

You can also add to the commit log:
Link: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1969407

Thanks,=
