Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C0784BC54E
	for <lists+stable@lfdr.de>; Sat, 19 Feb 2022 05:09:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241288AbiBSEIc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Feb 2022 23:08:32 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241282AbiBSEIb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Feb 2022 23:08:31 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam08hn2200.outbound.protection.outlook.com [52.100.163.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE92E255A1
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 20:08:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IoUI7D9OZeLUOfN+q55WebqY6F+Y7FPPzUm8Xxqx/4YSReo7bMENVroF7CPlbQCBUULZxz1WGqLy33vQCA7LUBxFe2HefZOk66bFjN15UB+e3FB8Hh0UtAVldSqgTDmYmfcngebdHDl3+aVUfZq2Lc9bY4Pxf/4E8uhVWPo7O7bKgF7iU2H4AoOETIOLtOGFi4z2R28U6bgXmA2vuaakE2sgBcUz1I0GfuhkzBOX4I9m/8982wxFxj9MMWsM14kSDHoEtp41KbGP1j/cAHHD7qijMiUIV8xHUjuJx8OhM1fPB/Q490B2wWOltTDnj5mVzgcjB1U0DzKYa0iYhmyovQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5+iJiA0J6jviS6/j+q9zQZlf+odb/fFUug6nr0gp3M4=;
 b=UOUsmuKIF7BsY/sHpCQNv5PaQqina8XwxoN6zX5SLZRL+CJk+ZMtFelKZCTG1/tmKxT8vaDq8mxndUVmKeUiv2Vn4KG5owA7lscgn8QVCx97eD1EALb4ojRTJ9P2tZrlL2dC1CP79pzUAox3jEfq0uZBxtrJY7pRZZ1psEyS+tM7LnTTcFoYVlAkLOxK3WWwPgvyKdLnp6zsD6CvGk7ei+esreIPfcghCAXnwGQe5KAN0lfJbl6l/I4/tM+Fm3b/P+1f5hZNYHaJIADSJN0T7IWBjRazqRpZhxrBnBVpRrSi7FHyiBI8f7WJz3M8A+XFcZTKKl5vetf/s9Z9YUCnHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=fail (sender ip is
 216.169.5.195) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=u-csd.com;
 dmarc=none action=none header.from=u-csd.com; dkim=none (message not signed);
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ucsd4.onmicrosoft.com;
 s=selector1-ucsd4-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5+iJiA0J6jviS6/j+q9zQZlf+odb/fFUug6nr0gp3M4=;
 b=wnoD74iYTMd8WHtFJ6ynKsOiG7hrHp3jk6kcz59/XAaBIXsfzhzT4PdX8u/5m6H1LYbP5k5+TxUe+goTXYJCKNSLGAhtMfoClq0ShZqh8aU64+C/CYTflKB0x9K0bymAqaSPt7eKQLJazebxr4wlihb5IcqS43KFHc57ofD8EGM=
Received: from BN9PR03CA0111.namprd03.prod.outlook.com (2603:10b6:408:fd::26)
 by SN6PR06MB4910.namprd06.prod.outlook.com (2603:10b6:805:ba::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.17; Sat, 19 Feb
 2022 04:08:02 +0000
Received: from BN7NAM10FT044.eop-nam10.prod.protection.outlook.com
 (2603:10b6:408:fd:cafe::cb) by BN9PR03CA0111.outlook.office365.com
 (2603:10b6:408:fd::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16 via Frontend
 Transport; Sat, 19 Feb 2022 04:08:02 +0000
X-MS-Exchange-Authentication-Results: spf=fail (sender IP is 216.169.5.195)
 smtp.mailfrom=u-csd.com; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=u-csd.com;
Received-SPF: Fail (protection.outlook.com: domain of u-csd.com does not
 designate 216.169.5.195 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.169.5.195; helo=UCSDEX1.u-csd.local;
Received: from UCSDEX1.u-csd.local (216.169.5.195) by
 BN7NAM10FT044.mail.protection.outlook.com (10.13.157.40) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4995.20 via Frontend Transport; Sat, 19 Feb 2022 04:08:01 +0000
Received: from UCSDEX1.u-csd.local (192.168.16.43) by UCSDEX1.u-csd.local
 (192.168.16.43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Fri, 18 Feb
 2022 21:55:11 -0600
Received: from [199.231.186.244] (199.231.186.244) by UCSDEX1.u-csd.local
 (192.168.16.43) with Microsoft SMTP Server id 15.1.2375.18 via Frontend
 Transport; Fri, 18 Feb 2022 21:55:11 -0600
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Description: Mail message body
Subject: HI..
To:     <stable@vger.kernel.org>
From:   "Kristina Pia Johansson " <info@u-csd.com>
Date:   Fri, 18 Feb 2022 22:55:10 -0500
Reply-To: <piakjp2022@gmail.com>
Message-ID: <f5de19a1-8eae-43a9-bf26-52434768b4d8@UCSDEX1.u-csd.local>
X-CrossPremisesHeadersFilteredBySendConnector: UCSDEX1.u-csd.local
X-OrganizationHeadersPreserved: UCSDEX1.u-csd.local
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 07fae3b5-a09e-4fc5-33e1-08d9f35d6c13
X-MS-TrafficTypeDiagnostic: SN6PR06MB4910:EE_
X-Microsoft-Antispam-PRVS: <SN6PR06MB49100A3B0E5810C748A0D17B97389@SN6PR06MB4910.namprd06.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Forefront-Antispam-Report: CIP:216.169.5.195;CTRY:US;LANG:en;SCL:5;SRV:;IPV:NLI;SFV:SPM;H:UCSDEX1.u-csd.local;PTR:InfoDomainNonexistent;CAT:OSPM;SFS:(13230001)(396003)(136003)(346002)(376002)(39860400002)(46966006)(40470700004)(36840700001)(40460700003)(956004)(9686003)(40480700001)(82310400004)(31686004)(47076005)(31696002)(3480700007)(508600001)(26005)(186003)(336012)(36860700001)(2860700004)(16576012)(70206006)(8676002)(6706004)(6916009)(316002)(70586007)(4744005)(7116003)(86362001)(81166007)(356005)(8936002)(5660300002)(82740400003)(2906002)(16900700008);DIR:OUT;SFP:1501;
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?LsYgBUZ+VyN1ZrYE//KxCuM5kg9Bsxfq7pdzZxj2c4F1NRugBXgXbguFrW?=
 =?iso-8859-1?Q?lLq6lpw/jHAHHFmFuzvefftYpcdBLdZuRsXjsgALZ43svWu8Zxp3E0dWba?=
 =?iso-8859-1?Q?c1rLhsi463lSn2oqJt4nrYVh/yU84pu2VSHYlvMzOpQOfRaLYhPPLCOPrf?=
 =?iso-8859-1?Q?ZXfnLeUOuE5ytUxfEWJRd/k1KpHO6LvUB032j5ya9WNkRBvltgHt9SDNaa?=
 =?iso-8859-1?Q?mSblZa5Inf5Dl5M0pUJ30YSVpLDULQ3MYZwxleKevOgKTANjZqK4ecup3z?=
 =?iso-8859-1?Q?1FG6c3t42cn/7rbrtOIQLuAQI3RgQrB4k8kW/ACwYFuJ+HxDX42/YEQyep?=
 =?iso-8859-1?Q?OYsfrYWJrvLIoMljRaa2jJ/foGvudVF/AfWjmzZrM1Gu//ng7XbRLCYkvr?=
 =?iso-8859-1?Q?WZuH15F0Rd83vvAgkO5o1zYwsZgnkFFccqiRIw1UycvsqJ4PnSenULKDnO?=
 =?iso-8859-1?Q?HqB23+EE6sT9OCU2i/xvhmtUJXqtkDM8uZjq3GEhQ1RqNso/b+rMAHaGml?=
 =?iso-8859-1?Q?l0YhQcZ+LSF01M1Qq4knXGKVk8w3ZJu4RU7halgqPbGqRdyPqaeT9Zcfnj?=
 =?iso-8859-1?Q?O6AHaS2jUfrjxWndRXl/o3yFzqdLsVsO67S/2iKHbJhRYbcUPq7XuIMH7g?=
 =?iso-8859-1?Q?0V080pPi5YZxpPgikv0ysOEBXqyQe0l7+AH3cXmLdlIz2JT7MSkBKbFrOt?=
 =?iso-8859-1?Q?eXv4eUM6TgcKy/jH6PCVCy+NyDfguEld/jPh1q97O8vdb1lqYLxYoz3/OW?=
 =?iso-8859-1?Q?KzAJ4+ES/9jydwOnKLg7BYgTVh5Yumzxth8kExTlJGsZO5m5mIyWAS30RV?=
 =?iso-8859-1?Q?TltPRkMk/qq5QfF/hRCKldUuOh2k1E3fhyFQlsNu23Wb9YnxfoJX85u3zW?=
 =?iso-8859-1?Q?2ID9hq+y3ufh3Mi+gE/IwmdcvFTQInQwzFrP8Dy/2Z5CFRKVP7WSv5JM7q?=
 =?iso-8859-1?Q?yo7vXUpGEogJPwHTZeT4eIiD1FCefjjLLBtj/GElmqCyaQOhEUzAz2FmhG?=
 =?iso-8859-1?Q?8tpIp1lYZ60aUMrWcA16a9lPyXFdOHruGrA0Ntnt6YrPQBqx04nFngy0lf?=
 =?iso-8859-1?Q?1TGPMmLGRk225HujxaR9KkA=3D?=
X-OriginatorOrg: u-csd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2022 04:08:01.9560
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 07fae3b5-a09e-4fc5-33e1-08d9f35d6c13
X-MS-Exchange-CrossTenant-Id: 663d4886-a028-4654-8be0-f6e600c88247
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=663d4886-a028-4654-8be0-f6e600c88247;Ip=[216.169.5.195];Helo=[UCSDEX1.u-csd.local]
X-MS-Exchange-CrossTenant-AuthSource: BN7NAM10FT044.eop-nam10.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR06MB4910
X-Spam-Status: No, score=3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FREEMAIL_FORGED_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,RCVD_IN_SBL_CSS,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

I hope that you are at your best and doing well. The purpose of this letter=
 is seeking for a pen pal like friendship and I'd love to and be honored to=
 be friends with you if you do not mind.. If the Idea sounds OK with you, j=
ust say yes and we can take it on from there. I look forward to hear hearin=
g from you.. My name is Kristina From Sweden 36 years , this will mean a lo=
t to me to hear back from you.

Warm Regards.

Kristina
