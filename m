Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43978554244
	for <lists+stable@lfdr.de>; Wed, 22 Jun 2022 07:27:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347664AbiFVF0i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jun 2022 01:26:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357005AbiFVF0f (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Jun 2022 01:26:35 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11DB336336;
        Tue, 21 Jun 2022 22:26:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655875593; x=1687411593;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+LZviGXzr1kB7ZjZg3XSFexz3Ota/CQX6Kmv0qJPBIc=;
  b=PZJnCh/3GdXQBnZxVS9TQT5h6Wqm/lJs8Mtb2UefcAn81AytyBNiCJUp
   qJ735DVN0j/IgHZlriWwDqNheWSQrD+E4e+0m6EeODLCAcTpZdi28lUP8
   tryKvPSieSsGmYlcoaGOR9iGTJY97uMhf4THXBcE2l7a7k6nmHvQrLr6Z
   MrZhhdLxkTjWZhbYrDIMy+du/ZVSfWkM3p/cZHMqfKqfuYLGv6CDmwSPr
   yRAUEQ7RgYezHjQ5dlvNW12Gm/1MlOp+GFxZEN03O7133gcGiGZW2vMlI
   6mQT0tUAYlxxK314sLDZP+ycld7csAC79wqCxl1f+C0xKi7S+xIAKMfSJ
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10385"; a="281390372"
X-IronPort-AV: E=Sophos;i="5.92,211,1650956400"; 
   d="scan'208";a="281390372"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2022 22:26:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,211,1650956400"; 
   d="scan'208";a="914470492"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga005.fm.intel.com with ESMTP; 21 Jun 2022 22:26:31 -0700
Received: from orsmsx606.amr.corp.intel.com (10.22.229.19) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 21 Jun 2022 22:26:31 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Tue, 21 Jun 2022 22:26:31 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.103)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Tue, 21 Jun 2022 22:26:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A/uLP8Uja5ap+AoYZNdBYmeTGla82UNueRlDFrb2xraziaO9lJKI7k2UmvOE3Pih0L/WnXMPKbPnF2C3Y5paLGJb9RK8YQm9dsUrJSwkfkYusLzzOeM57ySNUHxfZKD4WBOgivj4C5m1K+QNO3AgsgHG8cbIfV13xHGyFsdpfwRBul8HeAZIMtTn+nYJz8iCaWS1aooQhKMXxoXGYdGcJDZtBVBy5u9eLw4lIIh3cGuAynxc6HweXR8qsxnBDL0grS1P/kiFq2NsszfCNvJOpXTtnGP9uZTYLuJqHL8J62IUveeeFG/gsmZF4IGyCViUMY7cJH/aiEEqIVZBnQvdiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+LZviGXzr1kB7ZjZg3XSFexz3Ota/CQX6Kmv0qJPBIc=;
 b=e8US3O7dxZC4i7A+taTAnaqcxyJeLBgZNgA9yFbxlRyOkRfYWtbiU1n88gSRxdJyLvb3I5VkEzd00FRZh7Se4X5NdtvJ0xK13XAI3IME9iVSnRytATyKWfgW3moZ9Hy1IGgVZlZY9LuXH21F4FQBz5EIMWdUQZ4EgQqrUMr6Aeee4sjbKKUVhrqNwN1V9NMh9x+Lh1QtsCo3+O2f4F19CAEowUsdlmGRwh8ekjDaVJvFGvvVedK3iQ/rqFspzn1WIKQFodQgLqKSVy+SqL7TCmAJ9WU74bJGaHoq6pRZIg4UkARpVDk5xXFqhVGjoLsulgIKUksQ2tQhZNjgCqwPbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CY5PR11MB6535.namprd11.prod.outlook.com (2603:10b6:930:41::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.16; Wed, 22 Jun
 2022 05:26:23 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::8435:5a99:1e28:b38c]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::8435:5a99:1e28:b38c%2]) with mapi id 15.20.5353.022; Wed, 22 Jun 2022
 05:26:23 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Raj, Ashok" <ashok.raj@intel.com>
CC:     "Qiang, Chenyi" <chenyi.qiang@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v2 1/1] iommu/vt-d: Fix RID2PASID setup failure
Thread-Topic: [PATCH v2 1/1] iommu/vt-d: Fix RID2PASID setup failure
Thread-Index: AQHYhfLuXUM1xHXjNk+lf4Dn9CxC1a1a5TUQ
Date:   Wed, 22 Jun 2022 05:26:23 +0000
Message-ID: <BN9PR11MB52769E1D6C180FA0BBF820128CB29@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220622044120.21813-1-baolu.lu@linux.intel.com>
In-Reply-To: <20220622044120.21813-1-baolu.lu@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4bd0bd8f-7313-4a4f-6f19-08da540fbf53
x-ms-traffictypediagnostic: CY5PR11MB6535:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <CY5PR11MB65351F39FEE7822CF689CC6B8CB29@CY5PR11MB6535.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JjSGWFVCAlm2pJVRuend60PxmjJIe8x2qYFPPbQ9NGRXtjBTHk3vpbHlw4V9VQr/tlmVYuD4cRMeW2p8bgjV4/eihE7kSNgaVSBvgcP1xCIz8sDbsB4aH5NzYl6BOTe+Tc5EGqM5pWfPfwYsRSjqjvn9NyqW4ZSkOdXpk+P87SQDNqy2NcelLYpbsWCIWZR1clYBFI5hAhTVqDAQ4xmsk6MVm18ecBaf3WRfPRLWnfnzhwPU8Vt94s/qLww5apZ9mNbgahi4RsFXCyOExwZAWF5+gHRKlGp3oeQE8YZSHE8s9cgOdDZR8jd9XSVrHLaKaBQbK0Jqiy5ts8ruXbJTi8eTTyOWPswuWa6/op/Svun0sDuodP3GMi+o/RrHEE8UKcyY0UTrqybvbz2t3afZWwNdCIZis9JEI7hE7LNI+nr3jQkmXDlxYJCsDC9pv0F3yI+FVPsSvtkYXsggbNJC0TWMxQE3cO6kgDmbohbKjQ/4vRvDwh/6NylupRlxEnWsKsMkK+/iEIcUMPSla6+wPhNR3Ds7SfnVwq30Vmma0/oLbv4GjfE56kGYVxa/jP0Hf3lUhR+RoQlUyYRJo9T2LHLqBjrGRWZ5JCs9tdJaa6DHuJ34Z3txnuY2RRdKd2cTcpPlMLJHbOlcOe2WHl8bWAVNGZqbuU7BHVxaINQhoiQ8HkgqkWxQq9qSzEttDJpkulC1HNRzj2KrvZHOVMcLIQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(39860400002)(376002)(366004)(346002)(136003)(54906003)(66476007)(110136005)(71200400001)(66446008)(41300700001)(122000001)(66556008)(38100700002)(5660300002)(38070700005)(26005)(6506007)(86362001)(7696005)(186003)(478600001)(55016003)(6636002)(8676002)(8936002)(9686003)(4326008)(83380400001)(52536014)(33656002)(82960400001)(76116006)(316002)(66946007)(2906002)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?01MF1DX4zhq3gtVNmmTM4Tv4EQ/pMDwI9u4dIaEG7Hy/SGLl8f0dU9YQ9D/f?=
 =?us-ascii?Q?CKYz9+pbHaVrf34mj/tAyI4savNTadqsVBaqdQGtSyvIrl34KH/Calb0Mht2?=
 =?us-ascii?Q?4AIwS946K3palANeIAjqZkDsb2Zit+9QTuJFOYKGYVC9XX3sOfEe3ZyAVVoh?=
 =?us-ascii?Q?iE1j6tmGWT95MGuQEW8KfmYxfGui0KmwtyFpUFlmukLwTAF9nV1opUJLfn5D?=
 =?us-ascii?Q?w6iXBlFyxqHc9MdBS4h4sN2W3op6z/t2PMtaAzOG0uBvJu+tG5rjlqoKUd2q?=
 =?us-ascii?Q?z9o21xoXkNBXAUYpmPb2f9oQxnUOtdu9fygdn/TICbNHSv4LwOyTITCtCGoO?=
 =?us-ascii?Q?9WeWBfE/ZocVM9S7yRe+IA11hFoYZnhWn2ILN623BKm1wF0iYojRMDqpoFGi?=
 =?us-ascii?Q?OYxXfxxwKkPrFfJBERQF1IXJLih/53sYW5nRU6Z0Wi1lykbvTYiAjjSlg3+Q?=
 =?us-ascii?Q?DDpMTPadR2PrSwYuaUG90f7ZN3uvFRiCHHTQkBzQQRKgXT5I7GdownoFKxbm?=
 =?us-ascii?Q?ZxiZ+X+Ah/E8BgzhaKBtneUiC++zHaaFfezcsQ3wBIb9YjsV9Jdeazm5Q6Ht?=
 =?us-ascii?Q?WBHp9nwgzsliJ7p7SgWWcB3Wyx693NyQlr3Athsp/+0XW9v3UGN7dkxUmZNc?=
 =?us-ascii?Q?hEPLtqv+lwFp5wmJ+7RoVx/gt/q8W+II1B+Z3YgOtK3XwgZHqfemh/3GdntT?=
 =?us-ascii?Q?9ja2tTiFD7J6Deqe7nca4mmg+5tKc0Ed0ljXNoUNiP6YRLY507Kf3vnMulj/?=
 =?us-ascii?Q?+vxiyc8ucXK8/E40Pda4RmMTZhyqqFvNz9hAwXITU/VWLVkHKBD5iySom907?=
 =?us-ascii?Q?hIPZO1Bk9a/KbxZcea4p4lp56LETZC01wCfwJLMDDyT5rxfyXRrs/c6YAsT7?=
 =?us-ascii?Q?a9KsNIyG0nCdqieNaKBCnXcMtF0hHpD/tna8U0NJcco+hF2GYE0phG3YI39B?=
 =?us-ascii?Q?IR4u48yUmN/hjffyh+kB9sfZa8quRZPFV5L0sv1SW1biiCvqWZdSIRi15WUD?=
 =?us-ascii?Q?wvv3+fBsnXgzp+LUBna2E1EbJYhpIMmEIzjOvcyYS8Wtx7XLWDFZlhgBlLWF?=
 =?us-ascii?Q?5ElAphOgKE9NRMgAR8bzKFfO4czSH3cNQypc1NvHGvO8bZFHgbrQQezsPwxc?=
 =?us-ascii?Q?TdFc0Y3rtKOY61Cc0CNERjGvRRE8ZatxjnnG+31JZaV1FYWza0XrRcklb87e?=
 =?us-ascii?Q?Oq0jk0pvlGOR2oJiS0puYKYoakCDBmIzGs2Cm8ADuueAMAQJVqJeIRe4rnLa?=
 =?us-ascii?Q?5MYNrIIF7mNNsdeuOPv7QH2oADxCuyzfFPF/WSaa790SBNKaYBznWcKKzmmJ?=
 =?us-ascii?Q?4k0FOiIYDmjZFPLmvi4SwldSPiZRndBQSifDQbVhaZXZju1M2OT27Bu9qZiP?=
 =?us-ascii?Q?4c04J5spb87IDvopoVaoVmwmlOLY4gn3kzFmN9nHLjtVl/pDtwq/pCuWrF0T?=
 =?us-ascii?Q?LXhAyz04tFyiWO9wK5kDHGqZ38nO5AqCVgp3kOXEQ6bYSupSY+mCh8zmjtbs?=
 =?us-ascii?Q?6vCkbtqMWdyN7tkWzBn4t2mDMWOgAGO3cbT9+KJA9JiqalzlUxNAOgt19YZt?=
 =?us-ascii?Q?8ZQXeuG/g8cbMgbvnrgts2dQaa+QT5KpY3am0+af8RSiYP2zKf4E/j1BvIIc?=
 =?us-ascii?Q?T9oag0stx4VijQ9fOFLOMEpADidIhVsBIwzJii6UjatQomn/eWmDA8rxH7Cg?=
 =?us-ascii?Q?0lRX2rCZWbyQp2GTbfpIk2Oz+JzTAbqZFCgR7PhM8N5dOS3fN+crJLA3YN4b?=
 =?us-ascii?Q?QJP/5jxnPA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4bd0bd8f-7313-4a4f-6f19-08da540fbf53
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jun 2022 05:26:23.7348
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cFHC9mkviygOhTLLXucit6/4jpSYBCuoHHcGSywGx0kFjEfUXQCjMuMP9NCc+A90HjpAsvDS8q4tx9ruV5pOGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6535
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> From: Lu Baolu <baolu.lu@linux.intel.com>
> Sent: Wednesday, June 22, 2022 12:41 PM
>=20
> The IOMMU driver shares the pasid table for PCI alias devices. When the
> RID2PASID entry of the shared pasid table has been filled by the first
> device, the subsequent devices will encounter the "DMAR: Setup RID2PASID
> failed" failure as the pasid entry has already been marked as present. As
> the result, the IOMMU probing process will be aborted.
>=20
> This fixes it by skipping RID2PASID setting if the pasid entry has been
> populated. This works because the IOMMU core ensures that only the same
> IOMMU domain can be attached to all PCI alias devices at the same time.
> Therefore the subsequent devices just try to setup the RID2PASID entry
> with the same domain, which is negligible. This also adds domain validity
> checks for more confidence anyway.
>=20
> Fixes: ef848b7e5a6a0 ("iommu/vt-d: Setup pasid entry for RID2PASID
> support")
> Reported-by: Chenyi Qiang <chenyi.qiang@intel.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
