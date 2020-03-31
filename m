Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E9441995C5
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 13:51:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730334AbgCaLvX convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 31 Mar 2020 07:51:23 -0400
Received: from m4a0072g.houston.softwaregrp.com ([15.124.2.130]:48902 "EHLO
        m4a0072g.houston.softwaregrp.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730426AbgCaLvX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Mar 2020 07:51:23 -0400
Received: FROM m4a0072g.houston.softwaregrp.com (15.120.17.147) BY m4a0072g.houston.softwaregrp.com WITH ESMTP;
 Tue, 31 Mar 2020 11:49:58 +0000
Received: from M4W0334.microfocus.com (2002:f78:1192::f78:1192) by
 M4W0335.microfocus.com (2002:f78:1193::f78:1193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10; Tue, 31 Mar 2020 11:45:17 +0000
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (15.124.8.14) by
 M4W0334.microfocus.com (15.120.17.146) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10 via Frontend Transport; Tue, 31 Mar 2020 11:45:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LpNXfnxrzoIfviDdvcAgSpF/27SAhtE/MyyKyMLq2f9r9zhzh21ghBYT1fjkrwcxAwgcU9ceBgSA2QgpwxlYBUWFfMWnVRLrjawwLotYcSBHFBAV5spQ6aXFd8+yjByX4rQxTB4FSfJv1xWxfzSCzqKS/c8juHVu+wsJEzSnAldzQBqkYWMYVyJCx99fpisMghSuznzMPGLabFpa9Bs6QPWfQti4fymT0PXJB74vkNm/lyleqU7S2Rcpxy1mpRGhgNBIohE2eyKq6+TJeErjr50BE9Vyl1/4FQ0kT7Pfwqlhj3yEJNGjvN7ZW2IqQQqg+iFwF630s4uV+Yurwn8sng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yYFzI/P0Zi6C+qTCWxJ/YmZHIyiCzzLw9OGlec9HjAs=;
 b=j42nqKdhSdD6cXgvlr5k0xLXMjbjGEKJFwaNc2db+YtDDRoVQ3qj/HRpm3ji+NrNM4RDWnwgezrHmugqLzJlNnkKw1hnmefxjoH27N6UHQm1AUII1gFAsquJ0Im4clayZfNsq/SK1g1lKgKo6A7klwo3NZGARTFTfS/6YtCb9nqellYLlHOZbYTElNfNuMyjyqsgYiFaPKuyvRW6MR500u561oGp3guq0Go5E/1176gnuQDyoigF4FyxD4vzgqvXG6WvYSXX9PxzaVWpl+Z2nfsIxr+83lV2aDGFoL2KKc04E7SvgszwKAVxCudK8R2rnf3s4hgbCbIymnow/J4O2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=DMueller@suse.com; 
Received: from DM6PR18MB2458.namprd18.prod.outlook.com (2603:10b6:5:188::18)
 by DM6PR18MB3522.namprd18.prod.outlook.com (2603:10b6:5:28e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.19; Tue, 31 Mar
 2020 11:45:16 +0000
Received: from DM6PR18MB2458.namprd18.prod.outlook.com
 ([fe80::f874:3829:ad75:5777]) by DM6PR18MB2458.namprd18.prod.outlook.com
 ([fe80::f874:3829:ad75:5777%3]) with mapi id 15.20.2856.019; Tue, 31 Mar 2020
 11:45:16 +0000
Content-Type: text/plain; charset="us-ascii"
Subject: Re: [PATCH 5.5 102/170] scripts/dtc: Remove redundant YYLOC global
 declaration
From:   =?utf-8?Q?Dirk_M=C3=BCller?= <dmueller@suse.com>
In-Reply-To: <20200331100238.GA1204199@kroah.com>
Date:   Tue, 31 Mar 2020 13:45:09 +0200
CC:     Nathan Chancellor <natechancellor@gmail.com>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Rob Herring <robh@kernel.org>
Content-Transfer-Encoding: 8BIT
Message-ID: <5B6493BE-F9FE-41A4-A88A-5E4DF5BCE098@suse.com>
References: <20200331085423.990189598@linuxfoundation.org>
 <20200331085435.053942582@linuxfoundation.org>
 <20200331095323.GA32667@ubuntu-m2-xlarge-x86>
 <20200331100238.GA1204199@kroah.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
X-ClientProxiedBy: CWXP123CA0024.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:401:73::36) To DM6PR18MB2458.namprd18.prod.outlook.com
 (2603:10b6:5:188::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [172.22.222.25] (95.118.34.218) by CWXP123CA0024.GBRP123.PROD.OUTLOOK.COM (2603:10a6:401:73::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.19 via Frontend Transport; Tue, 31 Mar 2020 11:45:14 +0000
X-Mailer: Apple Mail (2.3608.80.23.2.2)
X-Originating-IP: [95.118.34.218]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2bb521a2-f4a3-4ee0-609d-08d7d568fad6
X-MS-TrafficTypeDiagnostic: DM6PR18MB3522:
X-Microsoft-Antispam-PRVS: <DM6PR18MB352287F8171BF3FC1708DAA2ABC80@DM6PR18MB3522.namprd18.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 0359162B6D
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR18MB2458.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(4636009)(396003)(376002)(39860400002)(346002)(136003)(366004)(81166006)(81156014)(186003)(52116002)(36756003)(66946007)(8676002)(66556008)(66476007)(16526019)(2906002)(54906003)(478600001)(956004)(316002)(26005)(2616005)(5660300002)(4744005)(16576012)(6916009)(33656002)(86362001)(4326008)(8936002)(6666004)(6486002);DIR:OUT;SFP:1102;
Received-SPF: None (protection.outlook.com: suse.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FKsNoZa0ez/sGtsZMGlSC0QmQ4czNh//o3ku2ftuhrsxo5qraHudiwo6Se1qubEkaCTe5ptliGmCkUgmF/+EEP/j7wGXO21IBWLQRSXZzncJ+8D8fsng/RevIvSF2ZqLCdv/4t9Hv0nlG8K3LUEJvY1CEQyI7jL/Bt8JsxaxAnON6jckcHp0fK3TPxsJQv52YT5uTe3nROQY/TDuUXgk9PwZUiUuYR03sSMRlTTndwo7chZVoH2nTtCEg34ZT31LaF6ku1h1i2HtVxOqrdx7R90/s+88QxboXNBzWujK1qQXKwmRoIEsRAZHG8dgHbFOK5S+sNYyfS/XGX/iudF0dtRx7qSqGHoQEYMkFqGnOzSdf5dlSxZ4RCuEIfzwMbggaUhL2DTY6vtxqbPi2Cm491KoXusX8PA+fiDrSlR8N/HJjukqunhhgTdUimwdzRi3
X-MS-Exchange-AntiSpam-MessageData: a7w0j/RBulvroFSHDPU1DMIS/5xz//BdfEgB4Gtomog+IGtaY27Udc+MVK515mFVGu/gNLQB+weUaUzusOYAA+I0J8fgzDKTgJ8/GAjow0d2rpXQGU4oK6YF/+C8OFpMoZjVaV9UzYezG+y7wXxo4A==
X-MS-Exchange-CrossTenant-Network-Message-Id: 2bb521a2-f4a3-4ee0-609d-08d7d568fad6
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2020 11:45:15.9152
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 856b813c-16e5-49a5-85ec-6f081e13b527
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n94kng65UJSdc4bmr9SLVeDdfV3kwRVxwfzzvTDkti+rd7idLxPeJ0huumz3ttHKV1TKhVc9JFnh8OCTf35oSQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR18MB3522
X-OriginatorOrg: suse.com
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

>> $ sed -i 's;scripts/dtc/dtc-lexer.l;scripts/dtc/dtc-lexer.lex.c_shipped;g' \
>> queue-{4.4,4.9,4.14}/scripts-dtc-remove-redundant-yyloc-global-declaration.patch
>> If you would prefer a set of patches, let me know.
> Should I just drop the patch from 4.4, 4.9, and 4.14 instead?

as the original author of the patch, I am not sure why it was backported to the LTS releases (unless enablement for gcc 10.x or
other new toolchains is a requirement, which I'm not aware of). 

However I think the sed above on the *patch* means that the patch will *only* modify the generated sources, not the input sources. I think
it would be better to patch both *input* and *generated* sources, or backport the generate-at-runtime patch as well (which might be
even further outside the stable policy). 

Not knowing why it was backported, I would suggest to just dequeue the patch from the older trees. 

Greetings,
Dirk

