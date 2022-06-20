Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C00355512C7
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 10:31:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239260AbiFTIbp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 04:31:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234950AbiFTIbm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 04:31:42 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B11F12771;
        Mon, 20 Jun 2022 01:31:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655713902; x=1687249902;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=5ExLkoADJQNiJTLQTfaaKmAoJw5X+6XTmEJ0dDzMtno=;
  b=TRtPAXWWjj0UTYcqhEkroYnd6ievi+ex+6Vc/FociLjb6V4DDy1abWJX
   1d3JAZTrDETGhEm600u78c8w7DcFvh+KyREEvRjbL6+A7sRGbCYw2eZ/y
   wNKjk2CpO6zA8lBvmW7lix//NJxHSBh2ymMU4CQbyIhEdPxlpxKcXXUsp
   JaIeOgNzKCdjcqJaY3g8N7km1uTzswehE678WPG543pLK/ci+8IO4LqOQ
   8B5NOzsHmePxMPnURcbfOPMw1Zc78yHhqTneiQxjBgnaAD0Oh6ALJl5Xi
   EJRkNCLoC0TCJo/S6ekIax3tg2fBILvmpQRCnwjr0524Q6oamL/uP19rj
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10380"; a="343830982"
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="343830982"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2022 01:31:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="561851172"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by orsmga006.jf.intel.com with ESMTP; 20 Jun 2022 01:31:41 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 20 Jun 2022 01:31:41 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Mon, 20 Jun 2022 01:31:41 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.173)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Mon, 20 Jun 2022 01:31:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DcNdgV98M3IPsFJs122hTHe0RI5TwTlszLvY0Z3lZzlo2HYpsw4EarBbDfFd5SQS1QWkOYA5SZryoLjHttHt2hwX60MTLGwnAtXzmZoxpXbRQaKtR6AOVIOHxCm7DJvvV24gjG9NkFn9danFT6e8DMhU42Js/PmxyfBtEojAQ7vTG+v0BdbevLfhPiNTn30sYBWSBgeC2gCnUOJFsOnzrYpM9ZeqTT0FVz+z5k+mvlabrHHzgbTr85x/8QArqmYxCJrV2OZVFhh2LdoIxJjfyGEXdg9gsucr1RL6PSeL8nvgRLQHjWwjWAmh4YODDiozNMdNp9Zv6GwMeuD1apQzRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z4iJF/z7Dtl8yOYyb9xKs2EwYa1yDCTQjZh9DvCCbYY=;
 b=Uuy6LAnIEpyn4vLRLwPZ6Zf0sGbKgUQu05JqEKlPPE0Y/aXLBHYFGehKzwWI2j96wq3MRcHRHE2Ezyej4vdfJvtnHJeJK8E87DwEXEU3sSOPvRXPAC6IZmMmHJXYeBh+fEO6IJJ16oIBHQx0Mzv88tY5grAlW6dodl+7U2bc/Vq8Fv2m4s5IfdeuIUMOqwaAywMK0PI2RaWaEIFzHqGK51+4lXn7TlyGTVWbF6a+4o8SiHd1jQoANzSf5bnrwTfBqsuVQgzreil2fhqby4b659Z65drAeIiYiRg+mZX2FmaKyExsYZgXszmrps6mS3YwpVxFGKoTIlFiiMy6lwhNqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB5658.namprd11.prod.outlook.com (2603:10b6:510:e2::23)
 by BL1PR11MB5509.namprd11.prod.outlook.com (2603:10b6:208:31f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.14; Mon, 20 Jun
 2022 08:31:38 +0000
Received: from PH0PR11MB5658.namprd11.prod.outlook.com
 ([fe80::10cf:116a:e4c:f0f5]) by PH0PR11MB5658.namprd11.prod.outlook.com
 ([fe80::10cf:116a:e4c:f0f5%7]) with mapi id 15.20.5353.021; Mon, 20 Jun 2022
 08:31:38 +0000
Message-ID: <03e70268-aadc-7ad2-276b-bf029487a5de@intel.com>
Date:   Mon, 20 Jun 2022 16:31:31 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.7.0
Subject: Re: [PATCH 1/1] iommu/vt-d: Fix RID2PASID setup failure
Content-Language: en-US
To:     Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Kevin Tian" <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>
CC:     Chenyi Qiang <chenyi.qiang@intel.com>,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
References: <20220620081729.4610-1-baolu.lu@linux.intel.com>
From:   Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <20220620081729.4610-1-baolu.lu@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR02CA0047.apcprd02.prod.outlook.com
 (2603:1096:3:18::35) To PH0PR11MB5658.namprd11.prod.outlook.com
 (2603:10b6:510:e2::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 39a4571f-4b79-4df8-ec6c-08da52974b51
X-MS-TrafficTypeDiagnostic: BL1PR11MB5509:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-Microsoft-Antispam-PRVS: <BL1PR11MB550998C47F0084E485D3FE30C3B09@BL1PR11MB5509.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uJqP3OnY78rB2MFp03DSudl1AhMifu6rLqUFakp0Za2q1lIEGLBabS/unSSesZyTAPGtPIOSBJVmICgzCSvaowXk3yzZCPqLWVxhsf+1RK1ewUtbRWk8g1Gxqt02njWdFjcphqG1f/a90QbmTt0zmw56J3WhWMZUY2kOQptATanOiVBUoAzCLVygcTYxQpfs11PoHnpplFpb2WSlMEEGhNowGCH6CyRdKI74bDroPm5MvjNJFLZ+F+nxE5AjEplaqHugkNKjnvRX8olGbEkbktNqWkmpA8s5lrZla32X8d1VXL97Xy/q29anZN1TIX5nteXGpwk9q8c8UFx1DK7Fnne9Y60VfWyVUg/BZXa1XoVFH3g1IDx2Qj9deu/V76ZDYGNsLPy3SbrlwDHdg1wG7Y8w5g/ZT5O50WlX48qJF/k63V07ywjer7iur2GNa75eSMDaMeXuc0ptjVDX945IyA349KA3reNqz25L3SVrSLM2gbDKLcQKJFJhyXbTrePScQA71odGlr241GneqSI2YOXSikfmxEmsusND3CCEX9CNR8NwynF/yOsi/d1XBtOdwvC4vdsPEbLavJ6Q9kt3v+0T6/ZltdH2xKfgLiscSlOo82HLDT8//l91P7kLf31IPwNpQ557l8f3qvSjXOSD9x7oNlN8J9/uHxfBocIRls818SgDhQ0HR710AUmAdJd78QS/bvHT67tdhO1hDZGN0kF3WxFFi93+6n596WER+Gc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5658.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(39860400002)(366004)(136003)(376002)(346002)(53546011)(6506007)(6666004)(6512007)(26005)(186003)(82960400001)(38100700002)(2616005)(31696002)(86362001)(41300700001)(8936002)(83380400001)(36756003)(54906003)(478600001)(110136005)(6486002)(5660300002)(66476007)(316002)(4326008)(66946007)(8676002)(2906002)(6636002)(66556008)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YXJmNFVKcVgxRm1HSmR2dTlQV1dyazIvNCtkUnJyZDUvbHJqSHZYcGFmZTcz?=
 =?utf-8?B?cHNRRHhDbWMwZEQ4VGExSVROaUhOTUFsY2ZteXc2c0tCZU9VbkpUNnoyeXdn?=
 =?utf-8?B?K1BQTFplcmd2QlVmNTJqYlRPcHBveVN1RUdESU5jSy80eHVUR1MwSzZnSkdR?=
 =?utf-8?B?bFJSZG9nd3d2RGVHVnAwY0p2NTRjWVVOVTFobVY3aUtEUVYyb21vbUFJM0VV?=
 =?utf-8?B?cFZ5bGxYL3BXQllBVjU1dnlUcmJKMWdMMm5lODl5alhTM3ltVFJCTkhsVG53?=
 =?utf-8?B?V2tiemNaV1NlRVlHQ0NWeENMYi9EOFRYNzBaWWtSVTh4d2ZJcUJMYUY1Szkv?=
 =?utf-8?B?aWNUMzJvdGVVMFV4Qm5tV0lycSs5RXM3REg3MWdyVzNTeG54L2tuTWdMajlv?=
 =?utf-8?B?UTcxd20yblYxaXdkU0cwT3ZHdmIzaCs0bTd5OGhEcjJ4VkVwc2VBUEg5anpH?=
 =?utf-8?B?amhQMjlrbEhXZytIZW1CZFc5TWhzckRBZlI0ZGhPVFZ4V3ZIWm9vVjRGNFJC?=
 =?utf-8?B?bUd5SS9mend1WlVIbCs4T1JwODNVR2d6TVJjZG93ZzUrQm9yeEgrWVBjUHBh?=
 =?utf-8?B?RFRDdWhiSmNOU3dYd3NEVDBVZUJ2MDEwekdZdDZIbmJiN3k5VStVL0VOSTVr?=
 =?utf-8?B?WnJwSmIxT3RCRWE3cW9aY3RhckJ6a0xMQWZBcEVlaHdLNThMZjhYZ3BrcU5w?=
 =?utf-8?B?TjdseiswRGdNOGMwdFl2Y1NMdlRoYnBIUTQ0WWM2MmhZVVF6WTB1R1phTm92?=
 =?utf-8?B?bjllMU5IM2diRXp3bTJvYkFQUWtET0x0TktKK24rd25qSU4xUCtYYW9RcDND?=
 =?utf-8?B?eFZ2YVE1T2kwbkU3M3NneXc0SzQxZXVuZzFPRTRHUURCQjlzeWd1TzVldzR0?=
 =?utf-8?B?c1RkaVFEZkRScHBjNS91dUIwcUg0R09FMHN1ZDl4bmVzQmlNaEhzdnVVWWFB?=
 =?utf-8?B?SGxmOTVhaGlHMXY2cjR1bGhvYXkxeUZ6S1RPQzlCVGtheEM5NkhLVDV3azVI?=
 =?utf-8?B?cjAvNVFHZkV6SzNBMVJzWWFZZG43TnpZYUp4L3lIT1o3dUJKRjlLR3g5Vkhp?=
 =?utf-8?B?V0orZEgwN2ZrdHFCVHpLYzNOYnpEeVgrRE1SZmxNclozNlZwQ3NwQUhIRkJQ?=
 =?utf-8?B?R1hyRUxHUkJabVpmS0pBa1lSRlloM3JXbHIzK1FEZ2FielFlTzR1bVRoWmdN?=
 =?utf-8?B?cVhIa0tVUllrUm9sWEpXQjhCb2R5QjJGNnFIbEJBNFRnMHhaWHEzbUJDSUh0?=
 =?utf-8?B?bms5RDUrRlMyZjhicHVnYm9rWHBndTlyUGt1TDFQN2xpaWQzQ2RJQkhOdGg5?=
 =?utf-8?B?WVhRbjZyRmFwOVJuaFBnMlNLOER0OXN2Y05QeTA1c2tJcGtUVWZqU05RcnZ5?=
 =?utf-8?B?YTFjanZlZUw2aWtyWkQvOWlNVjFnS25qMi9FUUw5WHM1S1UvZ2JQV3F1ejR6?=
 =?utf-8?B?TThXbVNpSUkxRUI5TDUxKzZYSHhacXBmd3RUOFRsMnZRZU9BWDFCbElCcnFD?=
 =?utf-8?B?eWlvMjlxRG5saE4zcTBZU1dFWk1Xdm04L1pVenE5bytYKzh6d1d6a0RoS2F1?=
 =?utf-8?B?dkZtRUI0VW1lNElYNHV6UElSUXo1ZmhVYThNMWNnOUQrWUh1NFpRanRJUCt2?=
 =?utf-8?B?RHlmQ0hSS3ZYTWlyTHdtTXZ1VmV6SXdzRnRJNFFmOUljbno2VW1ua0pRd1No?=
 =?utf-8?B?aE5ZSDk4bHdBaU12dnhaSWhDVE54dnVqeEptWXA4bk9ianZqOVF5d0dvNUFu?=
 =?utf-8?B?WkRPaWs0MmZIZXhPLzNCdVRZcEp4QVN2NHhqODMyK09KcFBSOUpvMzJNUHNo?=
 =?utf-8?B?UlVSdjl4eTNkanhtSiswR1FhMEppSU03YWsxZHFtTzBPZHpFTHljOEVvMGVl?=
 =?utf-8?B?cmlpN2VSY01RNTBzQmh1VHBkMGNRQnJOZVlFWS9wWTFyL3lLYlk3WUFUVmVl?=
 =?utf-8?B?UE5vUXhHcUFhbkg2MXdBdEN2WU05TklmMXhCS3VqK2hRb0w4MFAwNWxtQlhE?=
 =?utf-8?B?QVVjUVRXZGsvb3hvdzh1VDlxb3hXWVREdnhCay9lREY4VERtejh1UXRCZTU0?=
 =?utf-8?B?SzhpbFdNUmFSSUl6Q1VIZU4xbnA1eWZXZzc2aVc3SVUva1VYVjh6ZUdOTVl1?=
 =?utf-8?B?THdFMncraklmbHlPblI0dEc4SXFJaTUzQVYzdXQyRTRoMzlkUXlnOGFNbWY2?=
 =?utf-8?B?dVV3eVFvYWozNFJDd0JkVzJTYmRGT2VhdmJMa1B3eVYrVVdPNHhYcDRtU1gz?=
 =?utf-8?B?bE56MmxTY1BYYUdaWmdwaG1udnpPd0xTMjNLOFVsSFhHaWlOSE1kemdCZGVS?=
 =?utf-8?B?M3Rjcmx2QjlsT3Q0cmhabU5zOXVtS1VVSi9YVW1YM3VoK0hKeUIwdz09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 39a4571f-4b79-4df8-ec6c-08da52974b51
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5658.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2022 08:31:38.4952
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ERxgYYFEyJkeScxfvmZvI3NyPYfYKta15a6vrDmT3D1LAdRq8DcdaO6Py07Hzlf3WLyiJJ3AOfyPQrDOwX4NEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5509
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Baolu,

On 2022/6/20 16:17, Lu Baolu wrote:
> The IOMMU driver shares the pasid table for PCI alias devices. When the
> RID2PASID entry of the shared pasid table has been filled by the first
> device, the subsequent devices will encounter the "DMAR: Setup RID2PASID
> failed" failure as the pasid entry has already been marke as present. As

s/marke/marked/

> the result, the IOMMU probing process will be aborted.
> 
> This fixes it by skipping RID2PASID setting if the pasid entry has been
> populated. This works because the IOMMU core ensures that only the same
> IOMMU domain can be attached to all PCI alias devices at the same time.

nit. this sentence is a little bit to interpret. :-) I guess what you want
to describe is the PCI alias devices should be attached to the same domain
instead of different domain. right?

also, does it apply to all domain types? e.g. the SVA domains introduced in 
"iommu: SVA and IOPF refactoring"

> Therefore the subsequent devices just try to setup the RID2PASID entry
> with the same domain, which is negligible.
> 
> Fixes: ef848b7e5a6a0 ("iommu/vt-d: Setup pasid entry for RID2PASID support")
> Reported-by: Chenyi Qiang <chenyi.qiang@intel.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> ---
>   drivers/iommu/intel/iommu.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
> index 44016594831d..b9966c01a2a2 100644
> --- a/drivers/iommu/intel/iommu.c
> +++ b/drivers/iommu/intel/iommu.c
> @@ -2564,7 +2564,7 @@ static int domain_add_dev_info(struct dmar_domain *domain, struct device *dev)
>   			ret = intel_pasid_setup_second_level(iommu, domain,
>   					dev, PASID_RID2PASID);
>   		spin_unlock_irqrestore(&iommu->lock, flags);
> -		if (ret) {
> +		if (ret && ret != -EBUSY) {
>   			dev_err(dev, "Setup RID2PASID failed\n");
>   			dmar_remove_one_dev_info(dev);
>   			return ret;

-- 
Regards,
Yi Liu
