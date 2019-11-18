Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6213A100B90
	for <lists+stable@lfdr.de>; Mon, 18 Nov 2019 19:37:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726423AbfKRShR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Nov 2019 13:37:17 -0500
Received: from mail-eopbgr80047.outbound.protection.outlook.com ([40.107.8.47]:49894
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726370AbfKRShR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Nov 2019 13:37:17 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MnglyGpZR4uCjti8ILUImd803l3tiG6hkpD4xCHqbznqXRPRGcKJWYmIxruBv7bqxA+peqnps2CJFuHSk1ncmaiCUh1aqXwa4SQax2rwFV3HIRgK+XDrA3ZKwXSKnI3pN1pF3iRyigabXD4krR50ghnA1MUTTdqU+fSO2LM9AY9T2kc5khZWt1Zn4UVZ085gQGPp8Y+WFtxwxwt9uzjX9WyQWCLOdvUPO4cwjXPFIXoXJUOUQp+XlZE/Ild99ArpDZsqRNiczK5Gh5rH8qpTjyteRLCMSN8QK/7rsWIkCkB9xIKXE1JFFbbCiIqfFwWM1jnIoF3ZbVGhAidNiFvCLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0HqzYcaKwuRLEHtEca/v3wZaTNMK3gz5nIUUJXy14uQ=;
 b=oJMU1r7kKgGuj/NHKzcysv+aRU6KYEZVWVLUZXaxDDIIadVIufjYz14w/NzJKmM8aqK/Bc6zY5HPJZbGsDYVJpFyXW2P2POLmkfFTmUqB12WV1MuglPQ5WWtnOaoHD8I+MeO4Wzen1HlTXGC9JmJiKyg5NvkPH2y99ur5GqySbYktqjBNDwcV44Ja8af4Te6LWQUX8Z9D7rhRswrB+rhYuvv6PzklSxx1M7XZ4OA6jjqn0u39ygHwBi1Jx6lHx0nFYutwtEgwo86kVxEbXOp35d6pN3Byo7LL2WKPMJMre5YxR/60xIleKBw+H8X6rQts5H8+UxyqRMw2TuQC+/e0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none (sender ip is
 192.159.106.202) smtp.rcpttodomain=acm.org smtp.mailfrom=int.cggveritas.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=cgg.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=cggservices.onmicrosoft.com; s=selector2-cggservices-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0HqzYcaKwuRLEHtEca/v3wZaTNMK3gz5nIUUJXy14uQ=;
 b=l1fd6DyoRavtIbjqiHc6TfVIlk0maGcPm3rrveiLA8pRpdSWOlTYAbVwhSE+ErQd213J43lb1mBW9Af+ieulN11jZP7JmF5OG1jwQkX+fEmCgkYEWDO5uoysO6j5WCIFY+oH0IQAry//MU6/t8bg8Efz9A599HcI4yMQCl0MwR0=
Received: from VI1P190CA0036.EURP190.PROD.OUTLOOK.COM (2603:10a6:802:2b::49)
 by VI1P190MB0414.EURP190.PROD.OUTLOOK.COM (2603:10a6:802:39::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2451.27; Mon, 18 Nov
 2019 18:37:13 +0000
Received: from DB5EUR01FT042.eop-EUR01.prod.protection.outlook.com
 (2a01:111:f400:7e02::205) by VI1P190CA0036.outlook.office365.com
 (2603:10a6:802:2b::49) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2451.23 via Frontend
 Transport; Mon, 18 Nov 2019 18:37:13 +0000
Authentication-Results: spf=none (sender IP is 192.159.106.202)
 smtp.mailfrom=int.cggveritas.com; acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=fail action=none header.from=cgg.com;
Received-SPF: None (protection.outlook.com: int.cggveritas.com does not
 designate permitted sender hosts)
Received: from Hou-ECH02.int.cggveritas.com (192.159.106.202) by
 DB5EUR01FT042.mail.protection.outlook.com (10.152.5.100) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.2451.23 via Frontend Transport; Mon, 18 Nov 2019 18:37:12 +0000
From:   Andrew Norrie <andrew.norrie@cgg.com>
To:     <jaegeuk@kernel.org>
CC:     <axboe@kernel.dk>, <bvanassche@acm.org>,
        <linux-block@vger.kernel.org>,
        <linux-f2fs-devel@lists.sourceforge.net>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        Andrew Norrie <andrew.norrie@cgg.com>
Subject: Re: loop: avoid EAGAIN, if offset or block_size are changed
Date:   Mon, 18 Nov 2019 11:36:16 -0700
Message-ID: <1574102176-23804-1-git-send-email-andrew.norrie@cgg.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <20190617210848.GB57907@jaegeuk-macbookpro.roam.corp.google.com>
References: <20190617210848.GB57907@jaegeuk-macbookpro.roam.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.159.106.202;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(396003)(346002)(376002)(428003)(249900001)(199004)(189003)(4720700003)(8936002)(54906003)(229853002)(316002)(36736006)(81166006)(25786009)(5660300002)(2906002)(305945005)(498600001)(126002)(47776003)(14444005)(5024004)(486006)(50466002)(48376002)(476003)(446003)(11346002)(2616005)(956004)(8676002)(6506007)(356004)(8746002)(4326008)(6246003)(26005)(336012)(966005)(6486002)(2351001)(70586007)(70206006)(4744005)(44832011)(6916009)(50226002)(36756003)(81156014)(6306002)(76176011)(51416003)(42882007)(6512007);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1P190MB0414;H:Hou-ECH02.int.cggveritas.com;FPR:;SPF:None;LANG:en;PTR:InfoDomainNonexistent;A:0;MX:0;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4fccea7e-1158-4925-2ab4-08d76c56546f
X-MS-TrafficTypeDiagnostic: VI1P190MB0414:
X-MS-Exchange-PUrlCount: 1
X-Microsoft-Antispam-PRVS: <VI1P190MB041463C41AE9AEB742653C03894D0@VI1P190MB0414.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-Forefront-PRVS: 0225B0D5BC
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HpKRPwVn3hXB7+KtmKuE9IwrzCQJly8TD/6FggyA0QZyFicL/k1uhI08KGRfFYZrG9scdYS3F6rVLDvbxRxCajgCh9/8KstF2EsJKDzyreOPxpFUCkicxdpx3Z5fVPCs5VblQYfFOdEoYko+Cmq2Qk3Qp2feqD5aXKMLfiVTSRfg3IWVp00f1lmMYRZPVmI0qhlddajJ/OAAJlp13lQbcgvj6V+MxqLqL0c3O1TZmiUcg5P3ajtuOmQMBaLSY3XrZHWvg9gx44f/87xs3pai7UVYPUwmdQxupYbRoA3uFOaIUtOvePzv8IngOC3xXZ57TtnMkDXA9wvb6tV28dRVlCiH87s8fR7igYBqDTooGQpnoevP1QEVkiDYmchrbm46OVh+wTyYDDQijVky70AR99kX/JJBCtxBp11Bgy6K2W+u0W7pgLLw/GcA3rTbCN3Fug2TC+n2IAXV8RlKa/PfExkSmYrq4czD27yHM+LrYmE=
X-OriginatorOrg: cgg.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2019 18:37:12.9938
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fccea7e-1158-4925-2ab4-08d76c56546f
X-MS-Exchange-CrossTenant-Id: 307ea682-75e1-4701-a114-6c42f9ff0d24
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=307ea682-75e1-4701-a114-6c42f9ff0d24;Ip=[192.159.106.202];Helo=[Hou-ECH02.int.cggveritas.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1P190MB0414
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Any chance to get a review on this patch?

We're running Singularity containers in an mpi environment where multiple
concurrent container image loop mounts occur and we hit this issue as repor=
ted
to Sylabs by us here:

https://github.com/sylabs/singularity/issues/3860

It is affecting our production.
This email and any accompanying attachments are confidential. If you receiv=
ed this email by mistake, please delete
it from your system. Any review, disclosure, copying, distribution, or use =
of the email by others is strictly prohibited.
