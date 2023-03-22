Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E89616C58EA
	for <lists+stable@lfdr.de>; Wed, 22 Mar 2023 22:41:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229964AbjCVVlI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Mar 2023 17:41:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229995AbjCVVlG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Mar 2023 17:41:06 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2065.outbound.protection.outlook.com [40.107.237.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA93C2C649
        for <stable@vger.kernel.org>; Wed, 22 Mar 2023 14:41:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aorgj92NJj9nxUeFwkJcZJPJVmhVhbaUqpvA6ka86wqysHFG5JVjbabLfPDekENrw0nz9jZrVyhGeI/dkzK5zjXhJwV388zkv/ITxZqtL5wB2pIzK0PYjYGYZCPiirM7biQCBeQQfoDUvzk4DdNJBL3F1HoZCWGUSDZH+NbN14hWXzxF+wGNtuw5zWwkM4uJwWjaACn3wa9IZOBb0kWTWlLnRam+56txe25vtKNhDf/oiiwTDy2/S5LZ4knwdOoaoYigkrlSEsrfNrNr8eBw26KPo8CqplpozzJruOcyLpujFJS+dBlCdS2Sxv4CLE38dzC/hDuX4M1NuxumZLPmhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4AHIXNWlwuJYBPZiNE9tNlTYt4pcYQSXOkOk8HM4nhw=;
 b=Kruf9m3q7OI15lfHaCuHgbVlk0ZUDJ//YFh62zrM8O28eSA0Avm7x/tiWz1d8AP/y/1lTyDczbDPAIWc8k0FwrLJ9U5uORCQBT1QWTcl7s0z2z7wrwTYqvE+HWkxuWx1BVj3a1qSDtg4Rz+lynCp0K99uhsY3m8AbUDpTUyClgwBX14Bjb1KtW5H6W8hkNDWLm3FEuY0SM2gHr/nWxiNv/wtSqB64DOuNYZ/a1+Uxs1I9Lm5EdSX/CsWrCA7WFT0uPXAPrxdzA3zDUVAMLM1R4HCqg0JXoLCwrFHMFoOcHdLujQ3vVQgvEiq2tY2o3kTv/0Krb4DvzA9qBbONIu7YQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4AHIXNWlwuJYBPZiNE9tNlTYt4pcYQSXOkOk8HM4nhw=;
 b=NUuILgwyU6644c8B9Ncp7yNlWbPmvkeji8Z0z2Oos91ceuQJN9R94x3I/wVc0xyf8TpfAwvPXhm4AaqXgw0lKF3UaFt7P7/fEYRxD3t9ieZgXC56xiLhMe5oHsl/xZUZ6i9gfYgGg3of+eXZM0Q/IQxaBa2D5jLu7X+AWvt+Tso=
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by MW3PR12MB4443.namprd12.prod.outlook.com (2603:10b6:303:2d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Wed, 22 Mar
 2023 21:41:00 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::a4e:62dd:d463:5614]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::a4e:62dd:d463:5614%9]) with mapi id 15.20.6178.037; Wed, 22 Mar 2023
 21:41:00 +0000
From:   "Limonciello, Mario" <Mario.Limonciello@amd.com>
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Fixups for failed stable backport of "Remove OTG DIV register write
 for Virtual"
Thread-Topic: Fixups for failed stable backport of "Remove OTG DIV register
 write for Virtual"
Thread-Index: AdldBs93uxw0fV2iSMCpO6jXqmLv5w==
Date:   Wed, 22 Mar 2023 21:41:00 +0000
Message-ID: <MN0PR12MB610170899EAB526C383CB75EE2869@MN0PR12MB6101.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2023-03-22T21:40:58Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=0cff46c3-5bdd-4ab8-a5e8-162a47bd60c3;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_enabled: true
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_setdate: 2023-03-22T21:40:58Z
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_method: Privileged
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_name: Public-AIP 2.0
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_actionid: c49acf29-7134-4ad9-bf7d-73892ae04b63
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR12MB6101:EE_|MW3PR12MB4443:EE_
x-ms-office365-filtering-correlation-id: 0a6404c2-c9ba-4044-c060-08db2b1e20df
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kC8StX5YhNNxRwsynolkoWe+hyI7CZmG2qog3hHRvnl5m8Gu8LwQbieESzFwZDmwf4/HSHkWNAtXTwoL7cjKYdTA5gYW9tzSzeo+eT13pF1nKK9E2SF3aIpLMQhJyGTmJu4FKvwTpqyxwmg2KI1uU86n9piH7z4KGMV5/B/DDi9fkk+cVajiXZWTympn5+R3N8oArRwUUVhYC4JfgaDZ9DzyDcmqYTJBcX3L18m4bT6CSRMvBYSvil94UVjpD7ymv2at1dO78HsPQxD7atoasBASffsf0tv9m/a5+1OxamHRKWDa7Kw4IpXGzFa+P06Iws26Zq/Txz4l8VRK+RVrOycMJqOGtN17+igAKOm1e69R78uofWKFprN2qOjPTaIZRj0/ZYnesuDON6+KVAOMCJgnaHoEvfq0Lq89vUneZSGOnpmihiLFsEVWhEsEoP/t1u+RippSYZWqjHEf6HOZbQAGSek9FHsSdhReJySHyxeg3ltj6kdsGp1oKExGFmBFBL6WQJTkHNGZaLa+aAtqhLsdq/V3Knrf/6MvKm6Yz2bP9gznqoNV6pLHS2RME5KGXAaOXTswOOJMqPpV9lI7IX7GqQZbOE1WIIsMfQEo6d5QNKqmpR2FHFhwDlOjN9qJReKfGvhln4MEfyJU9xGh0Vtp28SnSPia1Vn38ZAP74V6RdMV5BbiwQrmd9GDBrEnryLXHXOV1VdhUG7CcUwmVA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(39860400002)(346002)(136003)(376002)(366004)(451199018)(6506007)(9686003)(478600001)(66556008)(316002)(64756008)(186003)(66446008)(26005)(8676002)(6916009)(66946007)(4744005)(122000001)(2906002)(8936002)(41300700001)(52536014)(5660300002)(66476007)(38070700005)(7696005)(71200400001)(38100700002)(76116006)(86362001)(33656002)(55016003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?zfX8iGc7WBXV3uuQ0OZqGPen/BUKnlLVUgdHZuZHA9TTtfDflLOg9IB5IfwB?=
 =?us-ascii?Q?+/L3Sb18y89PJOub66B3hVFs543ctVI+ZN1W8P3BEmf4tkD6OqcfeZkBP4Mw?=
 =?us-ascii?Q?IycicFeShZsz+IHX/xXr471asCb0zvVplH4cV1RBXihapxWXKCF0/yLIZePy?=
 =?us-ascii?Q?7h8OQYyBJxcz6QGnAdYt5Gkmfa/L2HitYlR2LSd1rAKVqV2mZn9NXZPTQS/o?=
 =?us-ascii?Q?TRhyl1e2C84TmIImA+h//aAVy9Ho6nZwx4YHG/ajBXCyTuF0b2c5LtLFE6DZ?=
 =?us-ascii?Q?SpH/OhZS2LlYpyOmeCpXV6346AUJlhr4rFDoYpbCBZM3vY6VcsHI/mzT4OSU?=
 =?us-ascii?Q?EFtQNvpffvpqXBig8UJ675y7SY4fbzKIri0ZIlJHQj/jELBAhNMFZkbrSmSO?=
 =?us-ascii?Q?z40SeYniCP5esYaTHiVQO/JPyp1dw8xTnodSxdYvOQ7JtVZwkuyB1AgdUe0i?=
 =?us-ascii?Q?aSa+T2vfaDWdXtuEVM9s8G10Q/TARGwtrYReE2sZYZB4pdSpL4SSsoshUsxK?=
 =?us-ascii?Q?mQra13Zf4yDE0dh3TAzNy9f6BZ/nE9hwBVQpCC1kQG9FGzS6Hi8ITsiDCbPS?=
 =?us-ascii?Q?e6qTrlmDvkfGC2PaD8zWVr/B/HpBDPg0cf+Arl7dYUnfu5eXtFwo/Q7lI7LL?=
 =?us-ascii?Q?qg9ZU3d3rjxWgJOtTiPit1AH+H6X7xqkUYgd/n6Iavhx5QstgXxBSuByRFor?=
 =?us-ascii?Q?C0YBQz5GOtwaEHZR6RKDoMTaMktCPieUhJEpJwTgQvR4OAv0c8Ch7hQbcZPI?=
 =?us-ascii?Q?WEq/YbXjvx1ROBd/yEXBO/GLMWe9OLWEavck+AyGoMaQ8EPoBuCxZajIF47w?=
 =?us-ascii?Q?polUQdd+yt/YFrGCc7CK8w58CRXBWYk1k1erLY6eJfaVzG64yktb/Lg6+fZe?=
 =?us-ascii?Q?uIpUhht0gDjsrtt5vjutMiB5MHHd3aQMu87qlb5KUg/5KhIPa5h6h2wm2uTZ?=
 =?us-ascii?Q?eUdPuC1rSRsxdoR5g5uK6XHaDC1ts7SUqSBQkHKssO2XkUEY27qZ3FfWcvmm?=
 =?us-ascii?Q?AeeCpOl62bcfjKx1Es+qenmzs/SV5lSIGlqqSdNFGsuhDeS9fsXaLPf3qJED?=
 =?us-ascii?Q?tpG5z1gx2h9GYgbj63Pove6tWaD8DLRXj48I/ldFQ4FceX+NNlotsDnf3A8c?=
 =?us-ascii?Q?sZmhvHrE3mXLjdhn5g9bs/ljr4LTISsg9FVn+tlfy0FTOYXDi3E0UYAV3QUV?=
 =?us-ascii?Q?TkT9D8YTklJvmnjts3wMA8GFo6vMmGz0cAz/E5KcESafS9zu0nAC8nLYWsAh?=
 =?us-ascii?Q?qsF8eAzJtFQ+AKeQbKcAw1V0NpWt+1v6FJELPazMn8IAAZElXz/O8uwzi4bE?=
 =?us-ascii?Q?xdPsfBxoHx8FUMUNINVfvif1oY0OWOph4T/X7Uzo4opm7XNEPVh25zqSTTDQ?=
 =?us-ascii?Q?nT6nGcY/3EglkkWBX+wvZIEag3z7BeAJdmtOsY8cTzeO2XqdAqEiQHHNaNvJ?=
 =?us-ascii?Q?/0c2kzeRyrbXJz8TrfGuazpNq8YZ7rINneD1PJiRUcrI4hYtWFjFBLmqV609?=
 =?us-ascii?Q?lwfnmoSTAIAH0qMhu/WMRnq7JWJ6Zw7IsuOy43RoBxY0MLmopTz9pT2cwyNN?=
 =?us-ascii?Q?qHNKTdtLRn3t/8v5S+c=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6101.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a6404c2-c9ba-4044-c060-08db2b1e20df
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Mar 2023 21:41:00.3292
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iiKMjU/GtomzeTNs3rE+mVou+gncp6AROrAbzlu3Uwq7idIQMXFCdjInv7x+rb4qoD/375Qiy1gJxc1/x1d3aQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4443
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[Public]

Hi,

The commit "Remove OTG DIV register write for Virtual" was CC to stable but=
 failed to apply 6.2.y and 6.1.y due to some small missing dependencies.

Here is the series of commits for 6.2.y needed:

3b214bb7185d ("drm/amd/display: fix k1 k2 divider programming for phantom s=
treams")
709671ffb15d ("drm/amd/display: Remove OTG DIV register write for Virtual s=
ignals.")

Here is the series of commits for 6.1.y needed:

368307cef69c ("drm/amd/display: Include virtual signal to set k1 and k2 val=
ues")
3b214bb7185d ("drm/amd/display: fix k1 k2 divider programming for phantom s=
treams")
709671ffb15d ("drm/amd/display: Remove OTG DIV register write for Virtual s=
ignals.")

Can you please apply for a future stable release?

Thanks!=
