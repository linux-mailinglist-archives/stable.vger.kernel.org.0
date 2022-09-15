Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 889805BA0DC
	for <lists+stable@lfdr.de>; Thu, 15 Sep 2022 20:36:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229545AbiIOSgN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Sep 2022 14:36:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbiIOSgM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Sep 2022 14:36:12 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2089.outbound.protection.outlook.com [40.107.94.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 339214A104
        for <stable@vger.kernel.org>; Thu, 15 Sep 2022 11:36:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NF6xUPm/Pr3fcTD4uK9oe+KkRx1+smqOchP9UnTaBRpVNR84LvNtEeVUWTmG/oY1wvnfDR+qWYzbjaYrswn7BfI4jy+4viNDO7uutxqciYjtw1YKmmRuQDjfVUFVU6sXjTklEuyonf1nV/J/7Oiis5oIkzf1LZ9/jJJBQ9fvwBqukECrikD8odXaTCshYuftvwqzFs5HVrib+/9mOf4PXdy48uM1WTZMPrg/l+rR3CMpsHb8gtAhrUpkazBJht4zWVDopA6xU4M2tN+7gVkyeVYG94tIt4OTT2QjXVcGenIvlAT6/+bJpPQ8Tjbw4h7EH2hiXgO9CQTyKa2DD7Nxgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZhFMr/MbxY4l2Bk9AChqsJ22U9zxBUBj5BVMGyYTaG8=;
 b=P2HyZxQ/v3DEm/xU5O9gAFh6vYoXg+RIILCgy79y/uUdSDbknLukZshZwCYml7Eru7hXNWe/PjyukooPftJgmieRjOWS9J2FvGxe+GErZ6AJJDPkyymFy0Br9hPuTxwgLH7QuwHitEXX7R7Xa+X9OTwnT8TfBIsZnGAAefhlNg/0n/aM4QXFubDpF5WTqhYfsLvEqiKCJiSx4MO9kR+8XAfqif3XPpqMYQoX2lPoVA1EwvVvwO8nu3Hwry2eoLmCajBUXCwkFN9gdedRS+50kdf0Cnnaxu67vCXTOeVZWo1HdofxCBpBVRLpdbboe0aAejCxBWtLAVi3CPMLeX7eFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZhFMr/MbxY4l2Bk9AChqsJ22U9zxBUBj5BVMGyYTaG8=;
 b=hbd8p27ls7d2G9eu2tG3EgC62FBa6XOck3CTQXYZzFFTAzmRX0emgezH1QxDDt4F91/Epw6FiPuYjo25JBmPMXIlMvZv58L/L6iJZQrsQFvKn6veuftNVqxHSFXOOcFZ1GC0UAZmzkQK630k2NEweIsP/4wGiDxZLUHHVHkZlNE=
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by CH3PR12MB7642.namprd12.prod.outlook.com (2603:10b6:610:14a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Thu, 15 Sep
 2022 18:36:09 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::3565:585c:3431:216c]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::3565:585c:3431:216c%7]) with mapi id 15.20.5612.022; Thu, 15 Sep 2022
 18:36:09 +0000
From:   "Limonciello, Mario" <Mario.Limonciello@amd.com>
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Fix for keyboard on a number of Ryzen 6000 laptops
Thread-Topic: Fix for keyboard on a number of Ryzen 6000 laptops
Thread-Index: AdjJMcxtoOWTZW39RgWiB8cdmce4wA==
Date:   Thu, 15 Sep 2022 18:36:09 +0000
Message-ID: <MN0PR12MB610183C836B0337551D307DBE2499@MN0PR12MB6101.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2022-09-15T18:35:54Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=9f974cab-277a-425e-b88a-edd07dfeb6b2;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_enabled: true
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_setdate: 2022-09-15T18:36:07Z
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_method: Privileged
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_name: Public-AIP 2.0
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_actionid: ee893d0b-d02a-4531-8d98-bc2f6a8ca57d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR12MB6101:EE_|CH3PR12MB7642:EE_
x-ms-office365-filtering-correlation-id: c54bfc27-9fff-489d-b6ce-08da97492851
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 40wK0foKp7QTtqswvqKrX3f9Uy6WVgupO8KpSr7bLgt0I0mDFvAKIOEVEd/qw13OLHK1Y+gAWfn6gXouflOzuow6osO4ttlecfoxW8oTBZL89r9aOOzOpcROzL+wA1EinYxrxW8XExkF/0FZbJGeUKxaVKg2D0lWhGXCm7MkiGiexBVV2zCXIxmqBt3VpDysSX53/s7vSO6k1njfcHK+WtZ5mYHAVntr/BFtFK9UUlvZU6t67+iGJZB63u3O9LL8ZmpX7i7cdOJ8CQOGoDlNEuntFeOW29HWRDYwnDKzwOpT59xmw9hr4uXpIdtAVthE4j8m3I79S7SxYI36Z/2k7OLKiqJ17ug5DNMJs4Kq5ryX6kMXtiz7+MbYL4lhiVmu4/CARRvbTSSm40+lnO9fQ5kVI6IlMxacPFPWJ8WvNBHPw9WHPCzFAxBoA3+zTSjMlhNQRJVFx+o371qnHpqsR4ULwMAy31opDmxag5WQBv+ZQ0NFoBiaX5qRWkIcmzd6nNasGkokgCprXNhasbWVBHiIw+b+kTaibbrme+8NExxEggz706zenfmZlVQ/4JrCEaD7JsC5rjhdPN8cq4171E3HSXxEqsmTvi+KTvdiWPnKYyJZQZeEs3JUcK0XOb16Tz3qc0ITP0GBbOBqjx7oJP2gfxzM9LlXQPEXIqQ+FlALQfoxzoJypC0ccxf7Z/9yeAw+6A+1Kcfvq5iSLj+kF2ahtsCfRUuK9MMjzPpN64iXXHvRrxFb26+SUwI3r5AVsF5JwCJAbcNBqqHbWHZDRQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(346002)(376002)(136003)(366004)(451199015)(52536014)(26005)(122000001)(55016003)(76116006)(316002)(86362001)(33656002)(66556008)(5660300002)(38070700005)(478600001)(66446008)(8676002)(66476007)(71200400001)(7696005)(64756008)(38100700002)(6506007)(558084003)(186003)(8936002)(66946007)(41300700001)(9686003)(6916009)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?/mgXjeF11Pk9JlhxZDRVx4clIqc/52XTffhgGCPqERoOvb3rlHSg/lJit193?=
 =?us-ascii?Q?vRMO7HJF+pSx7aI0lAYnu7Lbjf8bYt+M2+3d7v49PWDKxMW8hYW/zlHHcU5L?=
 =?us-ascii?Q?qL+Efnq6l/is3ongs5GzT5SY+Ug7TVtbCuIZ8+jkJTT2pGFeH6pvojnIA/cu?=
 =?us-ascii?Q?n+uvusI9V6O5bq0zYK6PqMX79Kwfv2Q0PgkfwuOc7CuRMyD5iVsgYr6ZlA21?=
 =?us-ascii?Q?JAnoSDWLb+qZUXGsUSdwmsLMZKqrb/gZKhNYyxQLOAHjFgU3J1vtKMtPljwV?=
 =?us-ascii?Q?+8k+lLqqk+fNL7xjQL0u3EJEhiPx3D+hidDGhoY/eCKBb4eP5P3uzkcUVN6G?=
 =?us-ascii?Q?0Syj7uncdXvZYEme4fuGCyXv7ZWRIQ/ZLNPDyBbwpExBZWTDQFHlYneGIbj+?=
 =?us-ascii?Q?ak9StLf/fNGmv90R6YNbWTapPZXIKs/VP4qN30pVLmbETCHzRLs2tSC2VDbm?=
 =?us-ascii?Q?4PFo9QZKmEEjhX7dEAvjc49z8zLMJKX1/b29i+BuDUPJI23O9e21C8X9sa0n?=
 =?us-ascii?Q?nMKdIdGAH5Rc0kiAbd0gHrQun1Ikj62MQX1AbIUfLwl5VMGjFLKYlASzIvYX?=
 =?us-ascii?Q?V+Je/+l0RqbmZUERXm4OfhqxQI6mQdllJUqr+GSDvEtrx75tK6V0slKy1s2o?=
 =?us-ascii?Q?Q7smlOTeUx3R32wl41trbKiDh1xxW3gk1ZFPhsUfP4R6LRzbCL4CGERasE8R?=
 =?us-ascii?Q?OuHxoI/MgYR5JCO+u8DY4B2VJ4ZKgZjfYJjtn4uDo5JAopUA+EkiL4Ys4N32?=
 =?us-ascii?Q?GOQAMFokOk8ZHNirFT3jcCAJ/q0irwasBMi4hx0PLj4GBw/W6qLHm7qY35BU?=
 =?us-ascii?Q?2RH+OaP8yPQnPN7y54yl5dEwoPveM9ax0Bp7EBSP30kYQWRyjnLL+zOjyYO5?=
 =?us-ascii?Q?zhlh7OQXHjTCa8MyMn427pkUMNffWXmpwfVtMHte9Fkv6WepJW++xq/8pScF?=
 =?us-ascii?Q?9gu0BHoCCGu9+YfpLXbdnb7Uo0iM98mcjNcCaxVdOmamBPM0xgf/KwOthHQA?=
 =?us-ascii?Q?KVHIDWVUrxS6ZmLaWmUhqXqRhTqGD51HXpV7VjU4IfUlh7Nhh+V+E64/AuhB?=
 =?us-ascii?Q?B7u9yHtYzU9rp7MnsRhPeb4ayggwDo5rwX0k78zfLxJRkKWs+wL3pAkQugCV?=
 =?us-ascii?Q?56nI4N3zBTBSaCP8RK3vnFDSxcdAjFUE+/YwFrFgHDn66sqALqvcsA7M/XTD?=
 =?us-ascii?Q?UM+oB/mMLfsMI/g1c4DDyhFUJ4IIvBkbk6lWYODNz//TYMVEpmbdF1qtkAgV?=
 =?us-ascii?Q?iQQO9wPDwug3yxHmqd/5yif+ihttWUl6DTJzAq4bgLNZ44D0uFkbnztd9aLd?=
 =?us-ascii?Q?lmDa8Tw+GeWo4vx7ovnwz0nEge0r90hmUi2BAt4egm59c62MdmVI32kw7KQ7?=
 =?us-ascii?Q?TvS2pyJOaTnKgjf2op5etunZjBdg1K+YlwheYFYRT73y/97fp2r4WdbBCT2z?=
 =?us-ascii?Q?sX85ocXfxP5LnPsRYNss5Ykws8NkHqVLL8kFIYh1hCP1WsCBum1K0vBp0Uii?=
 =?us-ascii?Q?twJ1CXsyGex08AiCryCFQiUf5SzwCfgXmARrknsI6wEQX1fxGtuCSMnt8s9b?=
 =?us-ascii?Q?IS26Fmnp9nfFnria3Iw=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6101.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c54bfc27-9fff-489d-b6ce-08da97492851
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Sep 2022 18:36:09.0727
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XXheUOE0SNiSP93SMBOJPELq6oM01ZrcPt+09OE8ZPWcBEIj7Yd5J0nLCqy1xAyABdjnuniIfbn9FRfbuhdM5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7642
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

Can you please bring in this commit to 5.15.y and later?

9946e39fe8d0 ("ACPI: resource: skip IRQ override on AMD Zen platforms")

It fixes internal keyboard problems either on startup or resume on a number=
 of Rembrandt based laptops.

Thanks,=
