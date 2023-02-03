Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F887688FC1
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 07:38:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231465AbjBCGih (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 01:38:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231436AbjBCGhI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 01:37:08 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A16D8E040;
        Thu,  2 Feb 2023 22:36:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675406195; x=1706942195;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Qw7+2Vp/TObBVX8YZfww0/P/RlVFb0RfMHbrP8BLtJ4=;
  b=O9RJ2uPhcOBRqqPG4iZjDDwvHBNKd/uf9SNPo7uMUPy5p1Tip3+iYbIV
   OfLyLTIHhAjgpjYdyZKmmI9ukmDJ/JdGqB4OGzb0RJeoyGT2/9InSriXS
   x/yWqR3/AMRC9wMxZi3CWvJlBifts/oLru8m+LPpBmCTH2xP2S9J4oclD
   EOCiGux8sIDZFSuM0O80Cr6y/FhPI3rwR3ur7VkG2zmDt7Xj4l18p3ruK
   6g796BksbNJzu04oebB4byLCQTHU6qfNFkQUqx4M02QQXjNVu2HmSfN9r
   SV7GA/T9M9mIUhOHrUFzpNpT6xAmoSnVvz9daZceLv6slioK7cSFbbhat
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10609"; a="393262987"
X-IronPort-AV: E=Sophos;i="5.97,269,1669104000"; 
   d="scan'208";a="393262987"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2023 22:36:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10609"; a="808239894"
X-IronPort-AV: E=Sophos;i="5.97,269,1669104000"; 
   d="scan'208";a="808239894"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga001.fm.intel.com with ESMTP; 02 Feb 2023 22:36:34 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 2 Feb 2023 22:36:33 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 2 Feb 2023 22:36:33 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.170)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 2 Feb 2023 22:36:33 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EzMr5NOkejJ8DZfJG+EMxcqEFH48tnALcSN6B1x+XO2qeUEXdgrw0pi8kg56iBBT0tZL4LAHZ6yscMh6O8QRjOxqL9FuuM9lzfF6HQmsfh4en8XM2hiCeZjXQ5Te5wHZU/h0wuxFsbkS6Gi0hwangn1JDAyNFCAGeSsup8Spn66JYWmUntKGb59rfxg5GP8sHvBPhHp7072tOclQ/tjUNjYjWwSd0Ht2ilNS7jCWJ3YESqhih3LYXNeMzpwUfe7Zn5RBcKWZEyfFnBbPYINisj25QrYukGSoJKcuXyqre2t3CmHk6m8Htk6Y8GZP83f3Cl2xsEaxg8xG3Dq8qFCuBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LSCALiqOlKLgvzcermANw/n6+0snitfdYK2lMvtuXsQ=;
 b=H62YjMgrGrnZsb4fHs+db08zAJTf3UpV6e+F+/H+BAt+WLdBHrvAnjfhk+dtWhRSngNugC5ZWd+bcd0Qc8GBd68uPX2IJHpZ7C3MTYegca7jkYQOwbAk1zCTWKpkAHQgBmbT/kmqlzUq3iwmuHnXCoVoYjMhDCmdp1oYXgHj1PK/ixu4Nx0JtZ5JO4HRXAG3sdJIT57exRcEhh/oLQq7Z1f5lLN/wPEo4kNdsjuuR7Ht6ydOE2VXdpLLWIb0lv7x5YUrRyxrOrTnLeYZxucrkDih0raejbxM+1V6LReDOZO0Am8CTAxd04yzFr3bYKTZIqv3VnBMLBUG6xuerV5KIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CY5PR11MB6366.namprd11.prod.outlook.com (2603:10b6:930:3a::8)
 by PH7PR11MB6331.namprd11.prod.outlook.com (2603:10b6:510:1fd::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38; Fri, 3 Feb
 2023 06:36:31 +0000
Received: from CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::4b3:1ff:221:2525]) by CY5PR11MB6366.namprd11.prod.outlook.com
 ([fe80::4b3:1ff:221:2525%6]) with mapi id 15.20.6064.024; Fri, 3 Feb 2023
 06:36:31 +0000
Date:   Fri, 3 Feb 2023 06:36:22 +0000
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     <linux-crypto@vger.kernel.org>, <qat-linux@intel.com>,
        <stable@vger.kernel.org>, Vladis Dronov <vdronov@redhat.com>,
        Fiona Trahe <fiona.trahe@intel.com>
Subject: Re: [PATCH] crypto: qat - fix out-of-bounds read
Message-ID: <Y9yrZk9KnICxqkZp@gcabiddu-mobl1.ger.corp.intel.com>
References: <20230201155944.23379-1-giovanni.cabiddu@intel.com>
 <Y9xduyjbaxFdaCUT@gondor.apana.org.au>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Y9xduyjbaxFdaCUT@gondor.apana.org.au>
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 -
 Collinstown Industrial Park, Leixlip, County Kildare - Ireland
X-ClientProxiedBy: LO4P123CA0367.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18e::12) To CY5PR11MB6366.namprd11.prod.outlook.com
 (2603:10b6:930:3a::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR11MB6366:EE_|PH7PR11MB6331:EE_
X-MS-Office365-Filtering-Correlation-Id: b8e5f7b6-96ef-4440-6821-08db05b0fc70
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: F3ighR2AB/3xPXeyf9hhj7y2Qg67dxPcGe6kzN2ErbJPnNVwPlK+iORdiiDRsvV+bwpNkrPySs0S3idvsL0cqOMf2QwHhobocjJ5tOsgG9HyshyONSRwbY7CUn4ZVYAbQxzkuLPKuH6h109RCyLWEnCU4C9572HNmIonXF17plvHHj7wI40M2b7OP5a+79aDtlKSDUGPm3xeVGttfVkLqqqvbRTU2WYulJpzF6yv0mJK4p0itYEYprwf8VgTpRGwZrTKftfZ3AaL0GktqtSFe+ZsLGyhhpO6UXkZS+PwI3j8FF5z7OhU0KK62EY7aPUAntNoesE4QOYdLWZlYsr2vadihCrOPVARk77Bht4z6m5kji1+uyOSRAmSLaG8lyP1b4bs1juw3JCb1Z3AL3WgBWLD5sDkcQ9r10qcuCrXD5m68vECfZmhDCTp/1LmtHPAvMfBabMfiCf0ITX9OHuR70zPP02BCiH6sewXxg/YJ8hNeHGYufhnKZIVVveNHvDypZHHrMiDoC0UPO2nEz8n2g3Ah6vNEzyc5FO7mWxmM+lHseRK/elXSz7oxwPIRN/YRJNiopkVOD+6p//vqL/vELllxRjhkcxV5KWMdJwvDRC+03JnW6zRTv4wCoqZP3z+ylsQ3QaoCu4w76+lufgIrQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR11MB6366.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(366004)(39860400002)(396003)(136003)(346002)(451199018)(66946007)(6506007)(54906003)(5660300002)(36916002)(6486002)(82960400001)(316002)(38100700002)(186003)(26005)(6512007)(6666004)(41300700001)(8936002)(6916009)(107886003)(478600001)(8676002)(86362001)(66556008)(66476007)(4326008)(2906002)(4744005)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KFpTnlrR5ZMwe+YAlk/8K1FB7qZHSLFhqDTvjlnO2l/XgD8nTKCp98XLy3J1?=
 =?us-ascii?Q?6iOm15CQmKJXeKrT0WaI1iYB7eHlTmtr9ZWyMKoNp/AuZ1vWPF1NVAaUAls+?=
 =?us-ascii?Q?hW9iMK/h1d/aDCy52YlhSMvOkMHNf3jby4eNAaP7PJfEnEBCqIV/M/+cdV/q?=
 =?us-ascii?Q?NdVg3JyDXomr7RwADSGPOkZC0hnrrk4x7tc8ZoEzDJ6+KxwaY4oapBH2IZLC?=
 =?us-ascii?Q?ssBGvL6TBrkpHTIZUCGEiMW9DPaUccebH0OPutG7qDk/H3mJrjV+80RjO9R0?=
 =?us-ascii?Q?AMGWfOt4VGeE51XGPf3IfdF7IW3uts7TAIF3jq3Ovwz+wpBJ17AvGrGgO/k8?=
 =?us-ascii?Q?0jHOCmaejw+4sgUHT8EMdF+gz94FRfP72Vb202f3iu27BzQBv+Yg64l5hAgj?=
 =?us-ascii?Q?/c1vrei6tic54q1woDmKz2A2GKqCEgFVsUhB7O1UgtI78Jq117hLFXNQqbIK?=
 =?us-ascii?Q?BRLl3SZ/Mh3MhkTCV5Xtpsp7mJ4LM4t/2++MceOWLCjdbbyNQDAgTbjbiMZE?=
 =?us-ascii?Q?1j7+Sye2G5IBFf57Hkx7NetGp3SslCtQ1yTv2tfJr4M5d67jX0dkFWa0bPCb?=
 =?us-ascii?Q?DcMpYtjNEopI8lVHwS9LAk13j+/NrrvQoUJq4AC0f+wBnGhspZ1vvK3b7IAC?=
 =?us-ascii?Q?ySavJr/bR6asTGsVkKLZCFT4BV/LrcQmtUvOE1dWSwWZxs1pyH40kaHnidA/?=
 =?us-ascii?Q?mIiCZmOOZc8/dNRBmsOTLY288FfXNEffnVGv3YOYKaNBNZbycDcB1vDSvZac?=
 =?us-ascii?Q?MnA4XsEECW8fg+dfNtgV+ihLqx4g7mrG2gDTKgLM93bVfj54QOM7+uwbdOn5?=
 =?us-ascii?Q?PDq9yi2iPpOEaaSyrwSr93a7Cx5fgUVWQ0YFmOJt7EbzoG0Pdep+qeoF74Wv?=
 =?us-ascii?Q?UAA1Qdztq74sEy8da3N/J/Djaikepc/v9reL6dj0JHYu0n+Uzo0ZkbdiLopo?=
 =?us-ascii?Q?wT9crjLRFan8c7F35BA06YclgngyZ+iuyJ1S9Vs1h7lF7ivbsJDk81hDleoi?=
 =?us-ascii?Q?5Pjg7G/ikb2wdS16JEaQhGOWJvy3yHgqVyEa+cq1RpuTL2vfKu8zAvno/j6W?=
 =?us-ascii?Q?aRwi7lSQThSKoKTjyI1FlGfp5uwm725w5kOP+qTVLZbqOzKJmCU/HoVikkv2?=
 =?us-ascii?Q?QJfpRUP4WrqM1xdSNJDhuqMNnpiw0EbrgpFc4q6x1LVPx9LdHVEVi+h4aPq+?=
 =?us-ascii?Q?B+c4QLmSWCMDnttDgZl9VwyvKRtdgBXSpPSrJXCS2AdSU5/c5PlCHAyter+s?=
 =?us-ascii?Q?FMzm2azfBtl2MzywYGVxD8HoGujolKt4SdW/7P1HwIKAaVZ1VDoRCcMryvC9?=
 =?us-ascii?Q?MKo95mj3rO5TbYbAXKWlgJXuHcTaEH3d7fo0u0MZ8RRfYJNqdlJQ1Wo/rH4f?=
 =?us-ascii?Q?10W2vjRHKYkUtC4lWLxW1d5Go/x7EFGx7agPxOoB+ngwSI5MRzjGZtQNmIp8?=
 =?us-ascii?Q?B9j8vk+HOUFu9pwIeRKcVyIaWa42MIQiu3syc3rTJgbZobdn5GOXn6UiVj1Q?=
 =?us-ascii?Q?IMWeBJg2PcK87VktZMnRfFpYOa7HD1PB3OTLejzW8grxQp+jbGiaLOtII3md?=
 =?us-ascii?Q?R8C0dn0w/IfV09CZePNikqIfIbvI8wbl+c1/vWZl3DhIfzpEb8vWiyC+5nU7?=
 =?us-ascii?Q?TA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b8e5f7b6-96ef-4440-6821-08db05b0fc70
X-MS-Exchange-CrossTenant-AuthSource: CY5PR11MB6366.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2023 06:36:31.2852
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kkewUD5lyvTAHpDg8zT8MIK5aVJfijsyuvtgBTayxwU72DmF4iB13iG4+lXVS/mxgQaai6/5Or0fBeYbTkL61zRB8o0hyevNB2k5X3/vhS8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6331
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 03, 2023 at 09:04:59AM +0800, Herbert Xu wrote:
> On Wed, Feb 01, 2023 at 03:59:44PM +0000, Giovanni Cabiddu wrote:
> .
> > @@ -435,8 +435,8 @@ static void qat_alg_skcipher_init_com(struct qat_alg_skcipher_ctx *ctx,
> >  	} else if (aes_v2_capable && mode == ICP_QAT_HW_CIPHER_CTR_MODE) {
> >  		ICP_QAT_FW_LA_SLICE_TYPE_SET(header->serv_specif_flags,
> >  					     ICP_QAT_FW_LA_USE_UCS_SLICE_TYPE);
> > -		keylen = round_up(keylen, 16);
> >  		memcpy(cd->ucs_aes.key, key, keylen);
> > +		keylen = round_up(keylen, 16);
> 
> Now cd->ucs_aes.key contains potentially unitialised data, should
> we zero them?
The content descriptor structure (cd) is already initialized to zero
before the function qat_alg_skcipher_init_com() is called.
This is done in
  (1) qat_alg_skcipher_newkey() implicitly by dma_alloc_coherent(),
      the first time setkey() is called for a tfm or
  (2) qat_alg_skcipher_rekey() explicitly, for subsequent calls to
      sekey().

Regards,

-- 
Giovanni
