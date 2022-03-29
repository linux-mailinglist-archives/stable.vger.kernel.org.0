Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC9EC4EA4C7
	for <lists+stable@lfdr.de>; Tue, 29 Mar 2022 03:51:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229840AbiC2Bvx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 21:51:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbiC2Bvw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 21:51:52 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2052.outbound.protection.outlook.com [40.107.93.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ACE73B03F
        for <stable@vger.kernel.org>; Mon, 28 Mar 2022 18:50:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I2w3+SU36m6lZTIyaTQ5xZc1VhPNlNB0VQxFniK+WFGkn4cJH2rYKfr5Ygaq5MXFzVF0qZ/Tup5NmpbZEwdwBt5B/21nATcwDpAmt8Jl/TFf0aeiWEf0R3rNBxgSGAk1xd4YHpZcBGCSU5/knvbe25gv46Ozxf7ud2fHVu13LjMdf8+Xu9JPOOGbIzZwHnNnN/pSrzC4D4AruAXzxYkz4q56IzFmEDMMfSuCvphzEBJ42pvlt7xUi7yVBDSVrLpoN5/z07mAHdQW4qDrWDU6vRlZ+w6c8ThGRgno6mK1ccl7BVV60VyZAZz/77+NJlKUxlCUrf8XJXSU8LQAYhGiKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YUTL+FDjDOX7BTgQiyTU658dxLpaC1RXBuwB8zY3v6M=;
 b=PHcCFwBw1oLmw9HNMjois61+Dgsewu+0WCYDCFj/k255fJiU9fVEC4p/Vfwnexa1bWA3Y56fuXm6hoPwO/3fPkd6+JO5P2io32H8oQF8bSTZD9D8FoS+VXSQzad7FN1/jObX41lAafSIcRXrKmTRfNuYHFNCQu+VViBkEEUGdOyHuWsLTM77KS+kerlio/XkChqjL+NaAnrgQogrWx4UMLzEw0g3VOA+ifYX0ZFBKWoQm6akh1uWNniecxzDe/Po/gIcrfaGZzdcPVkC0FXc3cbQaVrTEWdjeHCAURLqDrhfNhs2PFAbD7nn9YNss/aEfY8Pn50IITMihd4fQObbYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YUTL+FDjDOX7BTgQiyTU658dxLpaC1RXBuwB8zY3v6M=;
 b=E6VT10EHShpbN19GmErQiXUYji9jCTmJB9g4jojW4c20VQpGvp3oQxK6AETK24qsP8UFPOHwL9MQIIGLnTq2DnD0N6dTkCijorpvQ+QvYb2AXYVFbTIPwC80BMq36zTrZUQ5phr1etBoNx38xTvkSrm9fMuBhRAAH+GgnNlJ4xU=
Received: from BL1PR12MB5157.namprd12.prod.outlook.com (2603:10b6:208:308::15)
 by CH2PR12MB4921.namprd12.prod.outlook.com (2603:10b6:610:62::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.18; Tue, 29 Mar
 2022 01:50:03 +0000
Received: from BL1PR12MB5157.namprd12.prod.outlook.com
 ([fe80::70d6:f6dd:3e14:3c2d]) by BL1PR12MB5157.namprd12.prod.outlook.com
 ([fe80::70d6:f6dd:3e14:3c2d%5]) with mapi id 15.20.5102.023; Tue, 29 Mar 2022
 01:50:02 +0000
From:   "Limonciello, Mario" <Mario.Limonciello@amd.com>
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     Mark Pearson <mpearson@lenovo.com>,
        "Gong, Richard" <Richard.Gong@amd.com>
Subject: _PR3 backports for amdgpu in 5.17
Thread-Topic: _PR3 backports for amdgpu in 5.17
Thread-Index: AdhDDWX+TihtrBNKT86yGB3BX8tqeA==
Date:   Tue, 29 Mar 2022 01:50:02 +0000
Message-ID: <BL1PR12MB51575E79E52C3C23B8413CA4E21E9@BL1PR12MB5157.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2022-03-29T01:38:21Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=53d18a7b-aa56-4354-b2b4-9a4c0790eb49;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_enabled: true
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_setdate: 2022-03-29T01:50:01Z
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_method: Privileged
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_name: Public-AIP 2.0
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_actionid: 07ff3632-1375-4c44-bff9-414bc59793cd
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 204b050a-0f5f-4262-b9ec-08da112670e1
x-ms-traffictypediagnostic: CH2PR12MB4921:EE_
x-microsoft-antispam-prvs: <CH2PR12MB4921860246CC8E8833149FB4E21E9@CH2PR12MB4921.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PlK8Sb8giQ7ztTKYl7VYu8zIycBMefZxxsYXxky8x7Sg5gUfeGtE81JF3eRscqVYLCEsW/lRjZ7J5oF0MP8hDQ3fr58Z71Sv1kWoySd5kpuF1pcVYAdP/rpJBzFNZWZs5b/G/dmKwpK6xhvzFAm6LN/9WbUtSG49PXWkbQFYi7Ox0Wiri8ECi4qCCYtp9Pjq1ZXMYhdF+76tSqs0KRZBQtXra2KmbOR8umIeCJo1/E6Huh0vYULz1VA0zaT0z8hY2+D+/JIYwLsz6NhHY4XsIBW62FlXGRip9IvaVQpGpVKE6Y8uje1Jtsdr8heu+dDj6EkyYkrL9+pTS+XJv4V3kSFKpPf+p3T+kyn3a9xp48iC6cQONUmraVeNADpNHkXKO3TR/Spq0fFBD+0wZysVAu5sJjwJujRRZs6y/ahmuTozvZT8IDj7QCDmjIknQ3D7xnVdEKe+n8LcquMsKvKLDCGV0t2X8/4CUDvSSRbXXcrp0g8RFA+PWKMjOz1kDorcDe88x5wng2qOaHZIQC3rHkcFNhPDyEeOCZxtLr3yGGHw3NmXtWKmMs0DlRR0Fou4gsiVHOaz+Elu8qdB89C3CEtzneZlg6+VtQ2H9D+K1FbrGvJMJwyuy/dk/9AE/CaajyHPRP/FzCiq7BdFHtv/5NyQobVB9fbCIVPMdKJbSWVStPzXm6d7+8w0QZ0uq7m69/F0rLS44NR+SMTTpmrhzQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5157.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66476007)(66446008)(64756008)(71200400001)(66556008)(86362001)(4326008)(8936002)(8676002)(508600001)(55016003)(6506007)(6916009)(54906003)(4744005)(316002)(38100700002)(186003)(26005)(9686003)(38070700005)(7696005)(5660300002)(76116006)(66946007)(2906002)(52536014)(33656002)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?yZg8ZV7CPUiEbfhYOEeCImzIAf6aligPrJEUx71+GNZjeTPR2LIFWKA1HlK3?=
 =?us-ascii?Q?//c91VOUoGtn1mmMJ7zYBBT7WWpN/ttMyIszT/koP6IpW9XON0M7qGRIps9f?=
 =?us-ascii?Q?ydfJXO5+D4lAnKUF2pNHox6VWf97YVZlPfYyxoP7wS9GVeEllmDsVI4KYd24?=
 =?us-ascii?Q?4RvSdgB8j1Ymub3E/fi+5ztHH+KJummt/e8Lm9dEmykFO1OeoZJryB7KMqwr?=
 =?us-ascii?Q?gfw5UJ9rVHqIkEjxJ9aAxAfoxCsHricSIbNlwaDsmFKtZtlxuANkUQsggE1S?=
 =?us-ascii?Q?IyvCWBuKOcI+O9/XYk9gfTZe2irSkVdtASVgRB559vDkZzkG+OynRIrsu/4U?=
 =?us-ascii?Q?m9i7np1M4jOPNvDj+wfh7g2ir2vyIyIFS2Jb9QbKOFRFAlQmZbHr+KZVIkG1?=
 =?us-ascii?Q?l3vQyIqk4DidEoaztAo+FFxL2nFbbIGGohNFxANz6qAxcxaeEHj1Ty9Sr3VC?=
 =?us-ascii?Q?jkrN3Odd2pR9jicedY02y2a8QwBVFTvW6R2fTNPClm6XMdlQLMKW1E+d9tMU?=
 =?us-ascii?Q?4jnVAVWvecNsTvMCNSPmhQBxtIjRHXqOBd+E1mXJ8/PG7gu4Nxygw2YzeD9x?=
 =?us-ascii?Q?tx63EQ56oIp0aXYNujNYFw3K5+695jCtfoySKa5zI+3u/00n9k2vbgcWLAy3?=
 =?us-ascii?Q?KrrBWKv0fkgEwcFZX4e+UBWRlzoeKi+tDC68Sb/OILmm1l6sWzlVUE9umB9j?=
 =?us-ascii?Q?2g7NC0sxcU+PSL81VKRMT/obTLhyLp+KGeNnbYWm8ikebBz0x/o1c8D7vlZf?=
 =?us-ascii?Q?vlRWyueAaGRMv+ZT7J6n6xy6UDU3zPDghrxasNIQmi3QOajtPWuyT6ksMmoO?=
 =?us-ascii?Q?o8FICiEbg/1DBsylf2bn6Y3/3en9x7OPtgjxMaFVadFuL9Sfgt/YfynochQ2?=
 =?us-ascii?Q?Bw8E8uJEmOdNNj5elUD4dZLZaILOUhYxVIYjS1DmPamTLn75yzvDbDA0i1yf?=
 =?us-ascii?Q?aC02RSJ2+y51+gQ4PpSILB/TjKLme1ux//3KgoQttQzlebOHEWC6ZXF5qDgN?=
 =?us-ascii?Q?VsAv9xC/TAP4FTnjQmv/cU/VFxEcgXbic+pMCJ0XAjqsG2Hs3o/PWIm4N5KT?=
 =?us-ascii?Q?KgR1VNpHGbmKS3RcIttRACn7rMFwsbrEXKNx2nWPd6REFY5WZrgm1RFjybEo?=
 =?us-ascii?Q?lfeNEPc9JgdzIgxp99xCV4+5KNK5Jiy3YgcbdfeCbKpxN/5qsdmncZslAJTQ?=
 =?us-ascii?Q?MECsq+CShx6z0tYomk9UM9T5WcutncwQ7QlHe5jxppMp0HJyjhVN+ejhaR7N?=
 =?us-ascii?Q?VBlvHdyKzf52SkzH6ukEdhIebcnW7nbNnuL8lNT/XtQU275H+LHIzd3J8IIj?=
 =?us-ascii?Q?a0LTNbG7U+fkFt6jYf62aMNyhNBZErSkVXIWw7fYEllX/1MdFLNLdkbMVCGF?=
 =?us-ascii?Q?4sncD4W+ifv4gdHNdTzQai8dqD8YRBDi0oFJ2ah89EgE4+ZqBfMH2naUU9HT?=
 =?us-ascii?Q?o4bFhPoKDDuRGYWEOcehktkKVn8+WTZI4pjEzAGFCtnJoVn8bE+NC1SXJqb6?=
 =?us-ascii?Q?axFuTViS8D8LukaT8UpkPXTp+kGNAL6B4QCWgiPwovPUbDdX+NQMNCFNQe9N?=
 =?us-ascii?Q?KqP6UGJPwj/iFDQtBlVGW+cAQQgToRG5FFi4rfwV/yvA2ubO4WBrgmDXAjKO?=
 =?us-ascii?Q?f6ISbxpDhn0hvW0MXVnXhqax0+gyWJ8DwFqVyOuv0s3yUMf5XvVPP8JsAYwT?=
 =?us-ascii?Q?/8wbBljYi52Wlak/QCO2H6IRw9ykiRzcSAwcpGVYbaF1vMSbuPJBvOJJiUoo?=
 =?us-ascii?Q?ZCWrQyzK7w=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5157.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 204b050a-0f5f-4262-b9ec-08da112670e1
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Mar 2022 01:50:02.4742
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OpmdHBYyS44Ao1kZJNW8oJG4SgWWcRyePdtMFAWqqlKUBV0mf/4AMsAQtmAcRXzPRezKrislCdpfY0rBiBTBog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4921
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

Some OEM platforms containing AMD APU + AMD dGPU contain ACPI _PR3 objects =
that are mistakenly activating the wrong power management features.
This is fixed in mainline by the following commits that backport cleanly to=
 5.17.y:

commit 901e2be20dc5 ("drm/amdgpu: move PX checking into amdgpu_device_ip_ea=
rly_init")
commit 85ac2021fe3ac ("drm/amdgpu: only check for _PR3 on dGPUs")

Can you please bring these to 5.17.y?  They *do not* backport cleanly to ea=
rlier stable trees, and a separate backport will be submitted for those.

Thanks,=
