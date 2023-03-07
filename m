Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45B0D6AD859
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 08:34:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229582AbjCGHeE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 02:34:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230170AbjCGHeC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 02:34:02 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 365DD33440
        for <stable@vger.kernel.org>; Mon,  6 Mar 2023 23:34:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678174441; x=1709710441;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=YE4XqilQQkLHyeMnz2Rm51NWktDgW0X/WLzYMvbzB3U=;
  b=AXujCL+bMtD38WcrMFCv9XTryh3EHFLmblZ91Fybiw9ylmm0pUPo+LOm
   iWmdyRRFOy/WJWaUit4JixXdUyzL5H2p7vPvhBsY7GKqChY17sjdfbWzj
   wJ+3Gxzj+SvtHu9Hhc3P8Io7S42R3iWiu4zORqcbj53VPPOUUODnacyfz
   BKKqKP7P2gAYT+fVA0r9tP9b4Xx60vrKOTjWkNZcel6zMTGMcMU8gQT2v
   c5+utQjeYgp3XzQ4l2I2K1oZIzx8SVMNGV1aJPBLVxR8lvWJqoUxkwQT8
   uwU5y85W9/fs1dZE/PtY2xwVwfQwXoGB9+QzICrib2sAt5XBT+R9QYMqc
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10641"; a="315438919"
X-IronPort-AV: E=Sophos;i="5.98,240,1673942400"; 
   d="scan'208";a="315438919"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2023 23:34:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10641"; a="800311610"
X-IronPort-AV: E=Sophos;i="5.98,240,1673942400"; 
   d="scan'208";a="800311610"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga004.jf.intel.com with ESMTP; 06 Mar 2023 23:34:00 -0800
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 6 Mar 2023 23:33:59 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Mon, 6 Mar 2023 23:33:59 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.104)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 6 Mar 2023 23:33:59 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D4mre+Ag/DckWFA8BSBa7EGvMmJl53qWfm/4rTmq5y2aEkP4Te+s6eEgVg3ZfaFSbxnu65+FEYQt++oS0d5/Jf11UZi6xkLBgkw6PCElh2DWaciWmA7FesYhiiE9Z7+bmH4sRTRkNZZ0q8KRk65EU0DXuu/xd9TI3Ku9Rx4Ou6NS0wuEyMgKmhmWIHRRyQRjB+Kmtevt3yOzwa0qmUa3UPXr7UOb2OfjdGoeBA90iPPJUdvP8gBLA9Z9HWoB/O0SMVy4AoYUuYXR1W3vgpfvD761IyxMeg0YXwrfIjS7LVo0zeSgi5T4xvkNKBmwSdksgXPWPzNNxTWHpa4CeBzsCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e7cei8S9qD98lXShvKlLO8OOl1nEasR+a5MOmfk95F4=;
 b=Ov+rv2fHiC7pktE9fgQey1HPtNwyru1yo+nfnrsoSJw1aPyluxWuG/povFSDFi3qKpSmG/01l7Cif0EKygRlMaO+32qTkVTrXhhKnf9aLGue5Bgy7p6vJsdLoBU5pjir+P3J0gBOrqaY5IxCTGfktQKwLd0U1S0LMn+8uwwQLf2FnIQ1P83VsKoN6wB40hRwPLSY2YUor5WWGgLb8xUfUep5RPvLkaOMJui54OYQNZGN7WuMNFdbM+yMEbdKeVr2Rr+3Fto2pqH/Fe0e129zzg19Y0eWpiiYhQ+MShD3E5w+p536eMzYtztQecOlCfLGKuFcLJB2EI4PW2BsjJ8XbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH0PR11MB5409.namprd11.prod.outlook.com (2603:10b6:610:d0::7)
 by IA0PR11MB7185.namprd11.prod.outlook.com (2603:10b6:208:443::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.28; Tue, 7 Mar
 2023 07:33:57 +0000
Received: from CH0PR11MB5409.namprd11.prod.outlook.com
 ([fe80::de64:d1fd:cc87:a040]) by CH0PR11MB5409.namprd11.prod.outlook.com
 ([fe80::de64:d1fd:cc87:a040%7]) with mapi id 15.20.6156.029; Tue, 7 Mar 2023
 07:33:57 +0000
Message-ID: <24b04551-8f13-3669-e3b7-d567ca8b35f6@intel.com>
Date:   Tue, 7 Mar 2023 09:33:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [Intel-gfx] [PATCH v3 0/2] Fix error propagation amongst request
Content-Language: en-US
To:     Andi Shyti <andi.shyti@linux.intel.com>,
        <intel-gfx@lists.freedesktop.org>,
        <dri-devel@lists.freedesktop.org>, <stable@vger.kernel.org>
CC:     Chris Wilson <chris.p.wilson@linux.intel.com>,
        Matthew Auld <matthew.auld@intel.com>,
        Maciej Patelczyk <maciej.patelczyk@intel.com>
References: <20230228021142.1905349-1-andi.shyti@linux.intel.com>
From:   Gwan-gyeong Mun <gwan-gyeong.mun@intel.com>
In-Reply-To: <20230228021142.1905349-1-andi.shyti@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0011.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a::21) To CH0PR11MB5409.namprd11.prod.outlook.com
 (2603:10b6:610:d0::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR11MB5409:EE_|IA0PR11MB7185:EE_
X-MS-Office365-Filtering-Correlation-Id: e637dabf-1858-43b0-525f-08db1ede4f4f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nuYbFm2fk+RcTW1MdWSkU4qXRRxGbixP1J9vZJP//9PEbrOjErpXsP2e2PFnfZ7LGbAjwZxDYQHoQ0puT0FHBql15qXS+fjDx4APx9Ju2H/PZg7q3RN1RSzlCfsDzbW5BFR7CVCa83jHTSOnPnVZaBlptBKnetLHPv1Z6tngM+yJ9ae5kaSt5KT5YBsukovMHUtx2y7RR5uedst8isWl6NXI6K7cwqDeMf8YypuZaQDpJYWp7DhGpnNWmnSh+otesk1OvivWKMshUvlF03eC2llgT2FXr3yBlktwfj9Fo3qLmsgZdetpX3RTDmvHNYxtLmKJVDkA0YyHxtCgzGYXiWukNIsW1+jt0ni4g6Ua5AzvWz1nQonX07SaOUooRSJcWcl8x7acefK98yusbyeBbr3uEZ1GlPVldWENAuZ1pulRc8XH6GNxdtcEdLNLK8itQSWnTFbeF45F9zXDOD34dp1+SRD33x3nuF+R2DVNxUkET7crdjLwuy5y33JUZP0UfNTgNb3laSRFiNcqX+jkFC86hHdVpMPhnmNlQR81N21o6Vy0aMn+k3tBoU3k13y1urGI4O8NzhWc4Kx7ixrlMDgKWL01Ryx0QpBaX5Tg/I1440QTAqgl70b2eMjNOQEKHYa3GB5l3r8XOiOstRGWSUL3+Jjg4JWZYEqc1ShCmoeU1xILnPlBTbDi4k/kNJAKF1BumHHY9SCscSTK7alyEA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR11MB5409.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(396003)(39860400002)(376002)(136003)(346002)(451199018)(31686004)(82960400001)(83380400001)(36756003)(478600001)(54906003)(316002)(38100700002)(5660300002)(6486002)(2616005)(966005)(6666004)(6512007)(6506007)(41300700001)(53546011)(26005)(186003)(66476007)(2906002)(8936002)(66946007)(8676002)(31696002)(66556008)(86362001)(4326008)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RzUyQmVFYzFsYWc3L0MydmZqZ3FZUGMrVHNPN25oMDVxa1F3M0xzUFdySVEy?=
 =?utf-8?B?TVZoVU5xbVBsSlE5c2lVVG5UTFZmWGlaM3BzNUdGdFNaMjVnYzlWU0xUUkRZ?=
 =?utf-8?B?ZSt0QmVKZEhEZVhIOTJhSGFwRmtncTIzVVpSd0l1SURsZlNYc28veVMxWUpZ?=
 =?utf-8?B?MmpOTnc3bW5SdkdTa2duZnNpL211OWoybmpwVDE5ditRcVVrSUlHcDFHL0lY?=
 =?utf-8?B?eFNQR210RHFtUW5kVWFtZXJoZmtDaHhnVmk3cjRHaXY5R2xuYXFkeXN5Uy9H?=
 =?utf-8?B?a3ZPMG8vNW5LcFhjWjI1UkJjVFF6dlc5NzZ3MmtmN1ZnVkVTaVhKVDArVHg0?=
 =?utf-8?B?NmFYbW5UVXRpM0E1NEczVVN1WmgyL3pua0c5VWdXbnVyMnFyRktZZkQzdEJB?=
 =?utf-8?B?MFlRMitaYTFvdW9CR2ltL005dWVzS3VKWGZmeUszS3kzTmVVdEpFbk9DMHMw?=
 =?utf-8?B?djhNMzFEMUQxTnFrbnFNL2F4WnoycEhWSGpubTlMa3lndEk1bnhyd2x0T0ow?=
 =?utf-8?B?RkxQcDgycUY3Z3FSbjJsYWdzLzYveU9KVi8yRlZKbndKUkdMVU5oZDZLNi9X?=
 =?utf-8?B?TkQ4cFBKc2FNSCsvTjd6NWpjamJ0anRYVm1jUTR2SktiWjVxZzVLRjdvcldJ?=
 =?utf-8?B?WTFPOFNzRThQTUcvYk82cEp3RmJuNWtUYkZGZHljQWNsK0pkYjJhdndnZ0dW?=
 =?utf-8?B?NjBlR2s2NmEybks1MVQzK2xVTFpqYzVTcmIyUVZ5Ly9Nc3FaTEpJWWlqNkVi?=
 =?utf-8?B?YU9LRXBTQTl4K2RFeHBVVkljUU9zQ3QrWERyNFJVdStmaVREV1A4cThxMXBX?=
 =?utf-8?B?RHdLNklwOTVMdkMzRGQrZTRsemIvUGs2amplWGRhN2lmWVRCbmdTYUdpRDdP?=
 =?utf-8?B?SnliSFdzZTVUWStoUm1jWGY3S3oyN1dNcEt4emFvQjI1RGhJSnBPa0Z2NTFJ?=
 =?utf-8?B?VmlJYUx4SWpsUk94R0doRHBJN2ZIanAxaEh0alVKeDVXZjBaUTREY2VNWUVv?=
 =?utf-8?B?NDE0OWlPQ2IrTSt5cVpRVmdXRnpaOFF6Q2NCcTJEZzMrSlJRWFkvNjJ0TFBW?=
 =?utf-8?B?ZlBOR0xnRnVMMS85WDJmWm9rNHprRnZYWlU2L1J4Ky9TWWZNeTRFMGREdWVz?=
 =?utf-8?B?VVUzR0ZTRVkvSzZQZ2ZMVXVXazh6SkZpRWV1U1k5MlkrK1VDUlRFRmdqNjJQ?=
 =?utf-8?B?YUUxMmkxREFxaUQ5cmEyQVlKQzVUeVFqYnlobThWa0s5VlVkRGlhUU1mVHU2?=
 =?utf-8?B?MzU5cENUb25SaWxvVWNGUzlzTU9LWWtaaldpU2hObGdSY0NPbUMrUlBGSWdu?=
 =?utf-8?B?bUh5alZBNVltTmNMZmZRNUhTQkVid1k5dmtVd0tCYndvTy9OaHc0OGc4dnN5?=
 =?utf-8?B?M1hzcDBoVjRiYVJJWjZha2JUZjVrcDVwZjFFMHlWa1QrSk5ZNjRkQ1BCcUxM?=
 =?utf-8?B?NzRML3g0WklNU3kvSjlVakxwdVN5ZHM0cFVKWDV1dDdqWUtuQlQ2WUhrUndq?=
 =?utf-8?B?SVdpRTAwU1dkWW5kc3RHN1U1QytveWN0SXdKTmpxV2xPamZIdFNqN1JvTWJx?=
 =?utf-8?B?RDIrb2trdllVazYyY3lkODhrMnFXVWZRR0ppaGsvZGoyR0pGaGtENXRIT1A5?=
 =?utf-8?B?Zk8xVUlHTjdIM3IzZGJYci9USHQva2d5ZnZIQjUyQ2J6TWlIQnBYeFI3MmRX?=
 =?utf-8?B?OWE0WjM1emthTjVyYjJSd0dMeDN0Nyt5ZE9JdFRCRU01Q1dMRmJ0d3ZacGNZ?=
 =?utf-8?B?VFVMbXZoeTdFMURFWlJoSGlkeXlnQ0VXQmRUcFQxK2EwcHFuWVBjTm1wYThI?=
 =?utf-8?B?WU5wMlM2WFN5bTBCK3VJSUtHYW5XS0Z5SkU4cFdETFB4aFcwcU9ZQ1pYQzlK?=
 =?utf-8?B?YzJ3VUJuRENXLzN4SVBXTVNidTl1STdvQWtFNU0ySFZob0MwbWp6QnJIZjd1?=
 =?utf-8?B?d0pzd2NmTWVBdXhyQ0VNcnIvc3I4ZFlQMjJyWUNBeVp2bWo2TEEvZXQ1WnFs?=
 =?utf-8?B?b0p4TXJWcThzZVhzeUN5VG1kYjV6VW9kT2JpeG0xbWQyQWFaNC93eSs5VUtT?=
 =?utf-8?B?dFBOODhZQXZ3UTJHM0FpNHFDczZGcUtoM1lDbGVnVFFLOFhveCtiRThCV21N?=
 =?utf-8?B?QVBQU0c0MFRZQm5wN1RYZ0tVN3o5ZnI5QzE5TVNZL3laL1I3N2I0MVdQWS9q?=
 =?utf-8?B?M0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e637dabf-1858-43b0-525f-08db1ede4f4f
X-MS-Exchange-CrossTenant-AuthSource: CH0PR11MB5409.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2023 07:33:57.0540
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: knvXpgXXCk5vdTeMPQSbRuR0cDfnIDIcA1kLcBJ16ANbwDsHfXHzy8lCBn8TUMe13vsz1fqVOyoHcG75ybtYgGvhZCUWD1OWEOnZ/Bva4a0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7185
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Andi,

After applying these two patches, deadlock is being detected in the call 
stack below. Please review whether the patch to update the 
intel_context_migrate_copy() part affected the deadlock.


https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_114451v1/bat-dg2-8/igt@i915_module_load@load.html#dmesg-warnings1037

<4> [33.070967] ============================================
<4> [33.070968] WARNING: possible recursive locking detected
<4> [33.070969] 6.2.0-Patchwork_114451v1-g8589fd9227ca+ #1 Not tainted
<4> [33.070970] --------------------------------------------
<4> [33.070971] i915_module_loa/948 is trying to acquire lock:
<4> [33.070972] ffff8881127f0478 (migrate){+.+.}-{3:3}, at: 
i915_request_create+0x1c6/0x230 [i915]
<4> [33.071215]
but task is already holding lock:
<4> [33.071235] ffff8881127f0478 (migrate){+.+.}-{3:3}, at: 
intel_context_migrate_copy+0x1b3/0xa80 [i915]
<4> [33.071484]
other info that might help us debug this:
<4> [33.071504]  Possible unsafe locking scenario:
<4> [33.071522]        CPU0
<4> [33.071532]        ----
<4> [33.071541]   lock(migrate);
<4> [33.071554]   lock(migrate);
<4> [33.071567]
  *** DEADLOCK ***
<4> [33.071585]  May be due to missing lock nesting notation
<4> [33.071606] 3 locks held by i915_module_loa/948:
<4> [33.071622]  #0: ffffc90001eb7b70 
(reservation_ww_class_acquire){+.+.}-{0:0}, at: 
i915_gem_do_execbuffer+0xae2/0x21c0 [i915]
<4> [33.071893]  #1: ffff8881127b9c28 
(reservation_ww_class_mutex){+.+.}-{3:3}, at: 
__intel_context_do_pin_ww+0x7a/0xa30 [i915]
<4> [33.072133]  #2: ffff8881127f0478 (migrate){+.+.}-{3:3}, at: 
intel_context_migrate_copy+0x1b3/0xa80 [i915]
<4> [33.072384]
stack backtrace:
<4> [33.072399] CPU: 7 PID: 948 Comm: i915_module_loa Not tainted 
6.2.0-Patchwork_114451v1-g8589fd9227ca+ #1
<4> [33.072428] Hardware name: Intel Corporation CoffeeLake Client 
Platform/CoffeeLake S UDIMM RVP, BIOS CNLSFWR1.R00.X220.B00.2103302221 
03/30/2021
<4> [33.072465] Call Trace:
<4> [33.072475]  <TASK>
<4> [33.072486]  dump_stack_lvl+0x5b/0x85
<4> [33.072503]  __lock_acquire.cold+0x158/0x33b
<4> [33.072524]  lock_acquire+0xd6/0x310
<4> [33.072541]  ? i915_request_create+0x1c6/0x230 [i915]
<4> [33.072812]  __mutex_lock+0x95/0xf40
<4> [33.072829]  ? i915_request_create+0x1c6/0x230 [i915]
<4> [33.073093]  ? rcu_read_lock_sched_held+0x55/0x80
<4> [33.073112]  ? __mutex_lock+0x133/0xf40
<4> [33.073128]  ? i915_request_create+0x1c6/0x230 [i915]
<4> [33.073388]  ? intel_context_migrate_copy+0x1b3/0xa80 [i915]
<4> [33.073619]  ? i915_request_create+0x1c6/0x230 [i915]
<4> [33.073876]  i915_request_create+0x1c6/0x230 [i915]
<4> [33.074135]  intel_context_migrate_copy+0x1d0/0xa80 [i915]
<4> [33.074360]  __i915_ttm_move+0x7a8/0x940 [i915]
<4> [33.074538]  ? _raw_spin_unlock_irqrestore+0x41/0x70
<4> [33.074552]  ? dma_resv_iter_next+0x91/0xb0
<4> [33.074564]  ? dma_resv_iter_first+0x42/0xb0
<4> [33.074576]  ? i915_deps_add_resv+0x4c/0xc0 [i915]
<4> [33.074744]  i915_ttm_move+0x2ac/0x430 [i915]
<4> [33.074910]  ttm_bo_handle_move_mem+0xb5/0x140 [ttm]
<4> [33.074930]  ttm_bo_validate+0xe9/0x1a0 [ttm]
<4> [33.074947]  __i915_ttm_get_pages+0x4e/0x190 [i915]
<4> [33.075112]  i915_ttm_get_pages+0xf3/0x160 [i915]
<4> [33.075280]  ____i915_gem_object_get_pages+0x36/0xb0 [i915]
<4> [33.075446]  __i915_gem_object_get_pages+0x95/0xa0 [i915]
<4> [33.075608]  i915_vma_get_pages+0xfa/0x160 [i915]
<4> [33.075779]  i915_vma_pin_ww+0xdc/0xb50 [i915]
<4> [33.075953]  eb_validate_vmas+0x1c6/0xac0 [i915]
<4> [33.076114]  i915_gem_do_execbuffer+0xb2a/0x21c0 [i915]
<4> [33.076276]  ? __stack_depot_save+0x3f/0x4e0
<4> [33.076292]  ? 0xffffffff81000000
<4> [33.076301]  ? _raw_spin_unlock_irq+0x41/0x50
<4> [33.076312]  ? lockdep_hardirqs_on+0xc3/0x140
<4> [33.076325]  ? set_track_update+0x25/0x50
<4> [33.076338]  ? __lock_acquire+0x5f2/0x2130
<4> [33.076356]  i915_gem_execbuffer2_ioctl+0x123/0x2e0 [i915]
<4> [33.076519]  ? __pfx_i915_gem_execbuffer2_ioctl+0x10/0x10 [i915]
<4> [33.076679]  drm_ioctl_kernel+0xb4/0x150
<4> [33.076692]  drm_ioctl+0x21d/0x420
<4> [33.076703]  ? __pfx_i915_gem_execbuffer2_ioctl+0x10/0x10 [i915]
<4> [33.076864]  ? __vm_munmap+0xd3/0x170
<4> [33.076877]  __x64_sys_ioctl+0x76/0xb0
<4> [33.076889]  do_syscall_64+0x3c/0x90
<4> [33.076900]  entry_SYSCALL_64_after_hwframe+0x72/0xdc
<4> [33.076913] RIP: 0033:0x7f304aa903ab
<4> [33.076923] Code: 0f 1e fa 48 8b 05 e5 7a 0d 00 64 c7 00 26 00 00 00 
48 c7 c0 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa b8 10 00 00 00 0f 
05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d b5 7a 0d 00 f7 d8 64 89 01 48
<4> [33.076957] RSP: 002b:00007fffb1424cf8 EFLAGS: 00000246 ORIG_RAX: 
0000000000000010
<4> [33.076975] RAX: ffffffffffffffda RBX: 00007fffb1424da0 RCX: 
00007f304aa903ab
<4> [33.076990] RDX: 00007fffb1424da0 RSI: 0000000040406469 RDI: 
0000000000000005
<4> [33.077004] RBP: 0000000040406469 R08: 0000000000000005 R09: 
0000000100003000
<4> [33.077019] R10: 0000000000000001 R11: 0000000000000246 R12: 
0000000000010000
<4> [33.077034] R13: 0000000000000005 R14: 00000000ffffffff R15: 
00000000000056a0
<4> [33.077052]  </TASK>

Br,

G.G.

On 2/28/23 4:11 AM, Andi Shyti wrote:
> Hi,
> 
> This series of two patches fixes the issue introduced in
> cf586021642d80 ("drm/i915/gt: Pipelined page migration") where,
> as reported by Matt, in a chain of requests an error is reported
> only if happens in the last request.
> 
> However Chris noticed that without ensuring exclusivity in the
> locking we might end up in some deadlock. That's why patch 1
> throttles for the ringspace in order to make sure that no one is
> holding it.
> 
> Version 1 of this patch has been reviewed by matt and this
> version is adding Chris exclusive locking.
> 
> Thanks Chris for this work.
> 
> Andi
> 
> Changelog
> =========
> v1 -> v2
>   - Add patch 1 for ensuring exclusive locking of the timeline
>   - Reword git commit of patch 2.
> 
> Andi Shyti (1):
>    drm/i915/gt: Make sure that errors are propagated through request
>      chains
> 
> Chris Wilson (1):
>    drm/i915: Throttle for ringspace prior to taking the timeline mutex
> 
>   drivers/gpu/drm/i915/gt/intel_context.c | 41 +++++++++++++++++++++++++
>   drivers/gpu/drm/i915/gt/intel_context.h |  2 ++
>   drivers/gpu/drm/i915/gt/intel_migrate.c | 39 +++++++++++++++++------
>   drivers/gpu/drm/i915/i915_request.c     |  3 ++
>   4 files changed, 75 insertions(+), 10 deletions(-)
> 
