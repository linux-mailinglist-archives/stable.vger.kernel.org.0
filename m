Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE1E4555512
	for <lists+stable@lfdr.de>; Wed, 22 Jun 2022 21:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359510AbiFVTtw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jun 2022 15:49:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235098AbiFVTtu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Jun 2022 15:49:50 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2045.outbound.protection.outlook.com [40.107.96.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9505340903
        for <stable@vger.kernel.org>; Wed, 22 Jun 2022 12:49:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KScGZiIayg6oDNnB5cZEonJHN2aLMVimCXiC135sLWQrBh3NGm9Wk3FX/PuorUykv4yw3LxzQyTxgkkhAaknErqRbsxDE0KIviqpflgb7hz4KRI4FKNmGtnyb83kW+VQZmV1zgmglUFCG44RKeqgWS6aSmV0lnCtx6adDbtt4G5Si/tBkbj9Su35Q/JndgWEkFW0TA040sqmRHTNNTYcvVtvGLSa6I8U/PWQfQuLUb7vCDvqIgnqhgLZF7EeIvkikE8Da4dyEEclUVHDGGUzsE8sPaOjCUaH2VdN678I5Fnef+t82DZR8d4SqHLkm7VCqtFQh6jtLP3gzwlI2A44ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kn5WbcSZwHtovKoNgNeSHcpApAtn49Qeuyh3xSNPsk0=;
 b=f2zf0BCzzoudUKGz3QUl5nERnTUEYVuG1XUCfd/xTz3s6zleeWGAakuOxnrZXZz3Q4/ohpHYbPy2FAHdXRHTXd1Wb6gX2ahl3nzBGgZ6HFnzENe8M3CZMmOgHL32vZxCg5169eUv6BE7YSevJBABN6EF0lzPFLoK+49QPOwMqT72ep59SRgFcZsh7ipeUHR3dVp1Lf5kzvTc+D69i1wuh/ScAQDUYdR1T0EV4MtNn5IZlkHaDuWyuhNt+TsoMqoOvqNE3Xl6YVTOZ9h08rNXaxVdzx+N1FhQ1VtpPrtehnfMO97vAdCSPRHPtlvXmT5eeJDVqA9Nyd6IRAd1kD7PRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kn5WbcSZwHtovKoNgNeSHcpApAtn49Qeuyh3xSNPsk0=;
 b=ALF+8LmnQrb6VSGAihttB1YXtzPCAUjpkcZx3hVteZvUVpUEbm9sqdojAjTB6yiNWBPEAMD7HHcj5epiTCqZb5mkFFSv9QBJou/e9qCMMKfimaqvr+Fvm49pcPV+zH/w/z0537xyEXcuROjqYRxjSF/RqOvdZIDMUuE0HQHm2Io=
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by SJ1PR12MB6074.namprd12.prod.outlook.com (2603:10b6:a03:45f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.16; Wed, 22 Jun
 2022 19:49:46 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::1143:10a5:987a:7598]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::1143:10a5:987a:7598%5]) with mapi id 15.20.5353.016; Wed, 22 Jun 2022
 19:49:46 +0000
From:   "Limonciello, Mario" <Mario.Limonciello@amd.com>
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Display corruption on resume
Thread-Topic: Display corruption on resume
Thread-Index: AdiGcTXNxeQALMvbTci4ZSM+D/3dyw==
Date:   Wed, 22 Jun 2022 19:49:46 +0000
Message-ID: <MN0PR12MB6101E7031A343ABD977D723DE2B29@MN0PR12MB6101.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2022-06-22T19:49:43Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=29aa64d3-d5c1-4dee-a1f5-38e580358e31;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_enabled: true
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_setdate: 2022-06-22T19:49:44Z
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_method: Privileged
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_name: Public-AIP 2.0
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_actionid: a91943f6-f472-4a4b-96f7-1f88344880c5
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a4d30b78-8ae0-422d-582f-08da54885bfb
x-ms-traffictypediagnostic: SJ1PR12MB6074:EE_
x-microsoft-antispam-prvs: <SJ1PR12MB6074A13474C3B81CBF624B31E2B29@SJ1PR12MB6074.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: K8W1a4E7XF0GqwAwZmT8+hK/wTPngtgHISHuSTcia8sCb18HQUutjmmD/hhqHSXrZ2K28LcWtQ0xwER3mE7HQkDKGewJci3EpvT1GKWJiq+tFLQXa026ug4/Kd1hUdNOf+XOCp99eqLRP7qnKbYhRFa+mFeeynMLvPKh9kDf+Cx3pYZUe3Ow+iRYHbwzN54BS47/WiG0HX5w0fMB6ymJTA4uC14suvfEh0axG82pwnZcPhsNkWH46hGuWHj4ft0KCXORYapnEuIPTHeYDj2CgOnkRV2OsgTS6FZMr/yq77za9iRcx8+QVhtz6L65jmEN1ShiIVnOu0IgJcSlIU9TV9DlGDZ64TZYn39baOFeP+gM8+R0kzmFUVvtS6RqwnLH12JA2s9jdbz+ky39QbjzvK0cHHHMS8M+iN2upOvpDtwWGQaSGDIFspsvUPvJNVFrCLM92q452g8TrVY8AteZg7Jk/6V3wMWvlGVChXZ+eGacbRilZpeMvIBsYheyqdWo0chcxujbGBxhrMgMMIBZyLRCSVQVNp83ElSciQaVEXi3fijeCIQNcmvjXwbrV1s5u7+uk3xj/GA2x+Jp9XKlg9L2aV5PPqlj6RuCFdwFEOIywTXDatM2Q1eJeCKH6RxhZQ3AToFR+2yvz1rdVix0126guXLEWj59Uf5RTN5SLeaAnBvN6uo865yDEEPwZ+vvXd87f6ZKLkXTxDQCb5WajwC7pAbc9dIksbA0/ybc+klOIBBw0zQGCkzC/EoUzJxGT0MZ4UqRcIzgECAamSK2ZgoIOku/+tN0okMf9srpmts=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(39860400002)(136003)(346002)(376002)(396003)(71200400001)(966005)(3480700007)(38100700002)(66556008)(64756008)(5660300002)(122000001)(66946007)(186003)(8936002)(38070700005)(316002)(55016003)(2906002)(7696005)(478600001)(6916009)(86362001)(66446008)(66476007)(41300700001)(52536014)(4744005)(8676002)(76116006)(9686003)(33656002)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?jwY3rg4edeHWA9sPaLZXOR8pHg+4wDjXQfdTzBPYS60fYWKnZSyi/BxIKDby?=
 =?us-ascii?Q?xyOrVN9dufATie/xLxtFNmMS2yZhd2Rrs6dhzgpm0Fsud7CbROXsmdTIvoXB?=
 =?us-ascii?Q?HNf/ws42T3n588xyfo9aNvf3C0rFlxyuRSAoqplJEKdMdMSMRFNPJWwDfvz8?=
 =?us-ascii?Q?amPa0a6wcp1IG29VKgkLJV6JOQMC3aGygAPu9sBLg9MImf+o8I2tcFEWlHFq?=
 =?us-ascii?Q?phitqN/+piZj/FPMNqavtCUqEO/tTvHm2JH2yuBUmXJr0ReHZPW/Otx+Mhib?=
 =?us-ascii?Q?mJJWnCaFgNg3bTt4t3wbAMA/Iq0AmG6W1pZyCC9+plPkoAFmFuQNt+ot6+8s?=
 =?us-ascii?Q?AFA1YsXhrK4mp+Xj3JqV8kvcPO5b3oGF/DhrRuLo48yddMTbkJi1l7ammsLe?=
 =?us-ascii?Q?AbRJllZuLXE7NePXSXBChx/SDrUCdJpN6zjjjZmCJ4/BvPXPb38Uzth6ejkZ?=
 =?us-ascii?Q?ADvn9Wy3jXnlG7A8zLSG5yHSF3h0dzoRFW+JSZa5DTtkDN0sH0ahkJATMgNb?=
 =?us-ascii?Q?mBUbAEaJqT6qhxb//NeKkCP0W7kfHOD+iDgY4G1JSSBGorEHUurjb+uH4pwA?=
 =?us-ascii?Q?Nfx9dmW+N4R68OpGsrUGqSpxkedt8qk/DYvmsbklXxAcComXiZBgKi/+z+HL?=
 =?us-ascii?Q?Wvao/c8YFAP04VBtwG+yVpYqnAHp31WM8Sn8Q3LJzMFJuKW3eIl10uH+8x6Y?=
 =?us-ascii?Q?iDnG3Qw++kAsfn1wRMJwvlPu1xKtFNbvygQGONd3lF356B0isrmKiIxBPwaE?=
 =?us-ascii?Q?jnbbKmD2eDMY4/GkMhQGeVCuItU9cqYP5Ah2sKQPZ90aOGIvk3Nue6My9bY4?=
 =?us-ascii?Q?luKG30Ahna9pXcc6hhLQ+KNFSGMK/rmvOJYetNxr8bb9dcRSWH0EpyIVxWwh?=
 =?us-ascii?Q?7zsEbQsLf/yLSeHpGjDoziZrZGMeulWOaK8lzLK41QvquSHlxHm+SOLd1jBr?=
 =?us-ascii?Q?TvOhNDbeqe2vIb9d9OMrVTSBdEoUTiN8nNKmBkEKUqRnSkdLtLS7e6bS1G9I?=
 =?us-ascii?Q?HV3uoo3PbTFGpxBZu4GqOlagNimraNVd7XbXwGgo7cm/x5/IQncuMYbm2yW/?=
 =?us-ascii?Q?OWvryx9aPYkeh8ECspedbIpdL7EpC23NL+TOpxiE+InJb7UfkmjYVbhFRBou?=
 =?us-ascii?Q?tjUFE1r26Wid80R2xmQwmRdQAAzOVqkKV3S5CKbMPMJtRoBaauppn20LAKoM?=
 =?us-ascii?Q?oJff0KeDQAWIT48UkRVAjksemkP8ZFxfzEjP3vsDq5FMnyYt2CKyjl1Aeh/B?=
 =?us-ascii?Q?TR9qfmuY5RAHSWjtsWtzBQb3ih6ywoUHulxt7VZxRftoaovw62XCokGijbNL?=
 =?us-ascii?Q?U7AnXxwt/Z+WHbqjm1VGQyzvg4jZKUuVYRqkKooou/ZOIvATFWj+zDuRdwzP?=
 =?us-ascii?Q?DlF2opmnQnjz6TksDlNfv4IPBjm2mpBKL2Gfgb8C9FNLaOt4kk1dBu2vRJiK?=
 =?us-ascii?Q?pztiXQExVUOWwKCzHO7QpzU822V2uMjqtda6GcmPpsV9oD9NFfXckFWqq6mD?=
 =?us-ascii?Q?v0UutDaYzyprVe/RveJxRBWjkSPmhzi0wo3KWo7kDVDc1LZwadSV6nLVgVjD?=
 =?us-ascii?Q?4IpoYljFBXOjw/qBrrsafCB8imL6S+NwWO4rw2ATPKnEMqbX3xKGdL9uv9y1?=
 =?us-ascii?Q?APut8K+fPu2jPK6Ry2JZhdHAgXSp1NpYM7N9I9KVmosMQpj45DFawSE/fAl3?=
 =?us-ascii?Q?hD1u52QLGJAMtgo+c47S5jNx9ZXA3UxyAqD+hM9xsZUooOWkp7fFPrnoxvsC?=
 =?us-ascii?Q?U8BcXF0W6HH0W/onTz+eirwm4saBpP21ReyeaHlE4Vuqp6OK48wY?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6101.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4d30b78-8ae0-422d-582f-08da54885bfb
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jun 2022 19:49:46.1674
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eCI+0QxJCpaZ02yqhie+PkdWNkdOpPEQPP5Irnm3iOYi+WUGokxuIO8+mrEUV008JolXDkgKjCjfvjO0CUqu1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6074
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

Can you please backport this commit to 5.15.y?

commit 79d6b9351f086e0f914a26915d96ab52286ec46c ("drm/amd/display: Don't re=
initialize DMCUB on s0ix resume")

It fixes display corruption that was found during s0ix resume on Ryzen 6000=
.
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1978244

Thanks,
