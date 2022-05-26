Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 076D253499D
	for <lists+stable@lfdr.de>; Thu, 26 May 2022 06:02:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233400AbiEZECg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 May 2022 00:02:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231209AbiEZECf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 May 2022 00:02:35 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 370E2BDA0B;
        Wed, 25 May 2022 21:02:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653537753; x=1685073753;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=LbkJXR8gaLWM337HxByuB0PJXItTCiwbyNWXTXz146A=;
  b=kqkfVI3Q6+Kw2i1077lQYGlgvxQbN55vg9E0lIjv8MUA0XMVzwLoDI18
   IpuFf4jhvED2Xe/qsLGra8TiW+Qz11IP9fN6pK8xiU1XLFbseHKWAg9Jz
   wp3WvDaWRCRCmqCSztSCBeNOMdJwDAEL9u/z2oSpWODMB7HU5QQJgCwNb
   UWJV8tr6i0X7p2tRYE8cxIcTiZ2XjRi2ZXCWCfRENAjTT3oNKU/jSRDmW
   FYe+YSOiLWBqQibdOSIUzsXcm2TodmOSd8zsFz64qFgBN9PqlB0sewk0+
   Tv6hlYBHoma+ehyX5Nx8OFJcoYtef21AZZhuPDv0bUPiGiHEY58txDFyQ
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10358"; a="360413076"
X-IronPort-AV: E=Sophos;i="5.91,252,1647327600"; 
   d="scan'208";a="360413076"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 May 2022 21:02:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,252,1647327600"; 
   d="scan'208";a="630698845"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by fmsmga008.fm.intel.com with ESMTP; 25 May 2022 21:02:31 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 25 May 2022 21:02:31 -0700
Received: from orsmsx605.amr.corp.intel.com (10.22.229.18) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Wed, 25 May 2022 21:02:31 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Wed, 25 May 2022 21:02:31 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Wed, 25 May 2022 21:02:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n+oA6u54yzv/1AL8RMplhP/o5UEDuXt7C8nuFfBrFthaKUhMCw2PZVC+Dw7C5IR3X4RFUMi9q6Rwhj1WHzlqWUC2T4CS/2n0MVokFXP1vXu6QV0bEuXJ0cGBHFRdh6xUoEC0w3Dz1d0K8iVh7Is64InrjQuwFm6CZD+cpNtUBQorD+ABsF3ZcsrnrOzxV1OPfQfUTzuk/Spbe3maBq+RJ2RqEx8yNjQ7OiRjiUTx3+wEhC2QgRYXCHe50IVWSvEXvQwr2+ce1t530vo7wph0+mXcOwBL9afpnzwKWymKGzQMEXWr8ITbEKyYHeJPooEofP8lRrD9lq7haTkzi8hjuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C74dvS2drv/e3p3oT2lTiQI9YJ/9VcAoLTL/Y4eV3TE=;
 b=j9uMwmVHRPUwRYXvBXCfYcjCzOB35vdCtOrQ1/Y2dxXPdECXmG+3TGsVVqhajeAwt/NK3XXPmWxMfjukIEAl3U7yv8bv1MCa/FGf+jNvWkiK1F3ekwxuK1vKJ65UujPsKNzOBextluQlYm/HE0BOLnsvjbNbHRJgqH2x/PQtNFE+fWwIBOl182GO4rFIzM9BPL16rjdowiQ8fA7gFUZyDMRXAeK6fNA4UErzE27ecFDjxdM+DenSJTDzIXvVjX3PsG9xY2IWy6fG0VDrsD2a1MZBj51LrWp4acc+n5v/YSSyHcGdNOj5XKpKVBJODlFsy5IZKhVFPKrF7E1An85spw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM5PR1101MB2235.namprd11.prod.outlook.com (2603:10b6:4:52::15)
 by SN6PR11MB3263.namprd11.prod.outlook.com (2603:10b6:805:c5::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.21; Thu, 26 May
 2022 04:02:29 +0000
Received: from DM5PR1101MB2235.namprd11.prod.outlook.com
 ([fe80::39c6:7b40:e013:1086]) by DM5PR1101MB2235.namprd11.prod.outlook.com
 ([fe80::39c6:7b40:e013:1086%7]) with mapi id 15.20.5273.023; Thu, 26 May 2022
 04:02:28 +0000
Message-ID: <724e0872-0c7a-d83c-8c7d-cfd0cc2222b3@intel.com>
Date:   Thu, 26 May 2022 07:02:23 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.9.1
Subject: Re: [PATCH 5.10 07/97] igc: Update I226_K device ID
Content-Language: en-US
To:     Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        Nechama Kraus <nechamax.kraus@linux.intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>,
        "Neftin, Sasha" <sasha.neftin@intel.com>
References: <20220523165812.244140613@linuxfoundation.org>
 <20220523165813.521480921@linuxfoundation.org>
 <20220525104503.GA30018@duo.ucw.cz>
From:   "Neftin, Sasha" <sasha.neftin@intel.com>
In-Reply-To: <20220525104503.GA30018@duo.ucw.cz>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR05CA0039.namprd05.prod.outlook.com
 (2603:10b6:a03:74::16) To DM5PR1101MB2235.namprd11.prod.outlook.com
 (2603:10b6:4:52::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 34e2da12-6ad5-4eb6-bd3d-08da3ecc8d0e
X-MS-TrafficTypeDiagnostic: SN6PR11MB3263:EE_
X-Microsoft-Antispam-PRVS: <SN6PR11MB32637F0AD8798A72605462C697D99@SN6PR11MB3263.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tUVsox1pcbZ4ZfzZBgcAkNKE+chCPcAv8ezS+G8pLViJdU3FBxvwG+Yo4WnY79cBW6X1iT/hLWYHO2m36fUylPOoPXPdy2CaDjckj2H9CaskUSaxahawUttWlfRlwmRP2pw45EQ5/O+mYios5CbV6oV0k6n5TuZ9oGj77epEhSI8cnEZYT3fZiKclNy/mJvvTy0YxR3WmKJRmSqqpwW8/5t8NEfjKITmfyqfMW4DrFNrAqiJz2Jw6V26x42gyFxpp6EFiRLCtGgp+0P8hxecQwzniIzd29CiuRbmEv+xAYDEeddoE+MBKyi5U4jGTlJURXks6e8p9z/Dvg9ncJCNzP2kaEkD1JWzrMEmUHeayix9d75vnqBNBGJNu0FHeuULx+KqI0+vwoUDlexM4jmHuX/5Klw+vJY1a7PbxRCj79zpLFidTw+frQOf2zuaKbJbR5YtmUtWe54bdqMmVukLVjYn9FIph4WdqKrq5iti1S+vy2nlMPpEMVxbLI7RlhdAL9Pt9oJil4AZ5waAF91nidnzkduBI3x5QXKOSZ8RiOmFsHpto7P7SrIUrNu0uXGKnEh6zWdZVwJUR6FxWaV0mlvi7fZIsBsabO1fIWJLmrRba578RhflHXUt6gUtsKWZ97nuSBUOXkJ1ITw4IhcWHqW4usQfkxuHqI68faWw0ShRowPaX7TNVSkrtfYjqrb7Q70cKU8mxVKDbL0v3hPJ6Qco6hFfCsfOBFVMnBbspBQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1101MB2235.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2616005)(186003)(38100700002)(316002)(6666004)(6506007)(26005)(6512007)(15650500001)(31686004)(8936002)(2906002)(5660300002)(4326008)(8676002)(31696002)(66476007)(86362001)(66946007)(82960400001)(66556008)(54906003)(6486002)(36756003)(508600001)(110136005)(53546011)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SlBWNi9QakZZL2dhS3piM3BEYjVFMi9vQ3NaLzVvOTJLTGgyU0tjUHpSTUJQ?=
 =?utf-8?B?K0RaR1JTYVRQU1g3QlFyN0txVDVpc1VLaTQwK3A4Rlo1b3NHZlNOSEdzcFEx?=
 =?utf-8?B?SGF3dzg2RzNSZjdWMkcyZFBwbS9PLzFWN0hSWVMxN0hWMWFFSE9sbHdGQXlD?=
 =?utf-8?B?d0VUUXo2UjBobjNBU0ZtR2F4bjNlYTJsK0hKc3VhTDVYWDdTSlpNRU9hUWp1?=
 =?utf-8?B?LzNralliVG0yQk40WmY5bFdZMnNXNVMrblExby8wR3FabGNTUmVTSGg2eDRF?=
 =?utf-8?B?cXRUWFF0N3dsbEFHRVREK2xEeEJtSyt5RTBrd3Y2YTUrck9WdTE4WEgzR2Zs?=
 =?utf-8?B?Q0ZraTF1bnUxM1Y0UVNmOTlvbmUzQUplSWgxZTBtN3hkeUIweFN6S0Y4ZVIw?=
 =?utf-8?B?VWFVSUZnZm5nSFU0WHZVV1FJUHNiS2FybzA1cjc0YlhDNWFJME43Qmxlb1Nz?=
 =?utf-8?B?RDlWRG9KVmFaRjBLRVlTeGJ5cnQzQmlyR0hPRHFqMSt1bHd2QjhsSUpKcDc3?=
 =?utf-8?B?aktiR2VGckVtODJ3TUdrTEZwTDdVL3N6YUxPT25JOTg1SG10Rm9UenBDZGxZ?=
 =?utf-8?B?Q0NKS1pTdFFMclFWelZ6UXJTSFl2VUtjVmZqUUhkV3V4ZjhJeUl4QXp5Ulpl?=
 =?utf-8?B?SnhtVjZmUk9wTHB2VUhoZXV6ZFcvbmZxR2FGU2phT0ZoU1lxYjdyL2dXdUlV?=
 =?utf-8?B?Mjk0UW83cHV3L2FISjJZVDFPZ2krVEtJOUtoTUJtUWhqY0l0UEtDU0h3RUhM?=
 =?utf-8?B?ditNV0lSdkdMeThiTjk5VE4zaTllMDgzcWY3RHMzRGFmSkRQVTNNQUlLdktp?=
 =?utf-8?B?aDVXWncxVklxanNGcWpSR3I4cUFpUEIyL1UvU3FrTUF1SzFCc045U2NOVXlr?=
 =?utf-8?B?cXpvNkZlQXBBU2FodXh0K2NySnJ3MEo1VGRQYXJaZW1GSEdnc0k4ZnBlOXhR?=
 =?utf-8?B?S2Vjd2ozcVc4OUVGcDZ1K2Y3RkZxRlJLWThLVG5iZE42QU5idkZLV1JleVdQ?=
 =?utf-8?B?czFMa0xOSlUxNURrTG1OL3ExWkMxUXFnTm54WjJ6V3NMMkNzVlRMME40OVdy?=
 =?utf-8?B?REc0VEFFenpSNENaQ0R3Ky9wYmtoL0dkZ2M0ZTZYZGV3SURnK3RPaG56eUJ0?=
 =?utf-8?B?RGoydStpZHl5SWdCdDZuSEVvMUc2NmRFL2JERDVWMjVYK29MRGFXZ2FzRm1Z?=
 =?utf-8?B?MWhpYlQwVzB4dllZOWFLanptSGpuV1BBTHFSSFJPK25aaVRkQnVscU4wd0pv?=
 =?utf-8?B?eDZXUjV1eThIZzhNL2lZbnlHeUV4UHRBQngrcHlKRUU5UU1YOUt4TmMrK20y?=
 =?utf-8?B?VGx4SzU1NngydktNbnJTaU5YVldIVFh6cnUweHdXSk53di9YWkZ3WE8rWGhj?=
 =?utf-8?B?OWZ1TkZRZlNiZFlRU0xacmI4YXRFSjlpaHpvbkRPRkkrZXMzK2w5ckZPMUZ5?=
 =?utf-8?B?ZjV3Tm9vdjUvSG1kZzdsZEd3MTVxWFpnS1h1UlFreFZFUGdFRkY4eW5CRXhC?=
 =?utf-8?B?bWw0c3J6OEhQYXgxYW5jaXlWNldEajhjQnp3VHIxK0VjRGU1OWhubm5RMUZ1?=
 =?utf-8?B?WGVoRVhjU1A1VmRibHlvZEczRzFWYXM4dm5jc0F5ZytqN1RBRlNjUU5rbUZE?=
 =?utf-8?B?UzRRVWJXNlpqVlN5ZlA1alVEQW9PL2FRSUpSU3Nxc0NzeEFlT3N3d2g1VFB6?=
 =?utf-8?B?MmdLL04xVzNWdjlHVlY3Z3BwemIvSWZXV25GRjJOQVNuRGFEVUJzYnlPK3JT?=
 =?utf-8?B?RmlMQmZ4ZHE0THZXb1pZeWxaWkhVYTN2LzA2Rk9yNkpzZ0pjNjRxQnR0TlJa?=
 =?utf-8?B?b1c0bFNFZ1RBcDNuQVFJU3o5U2c5L3RtTk9ZZnZRU1loMDBqQUFGQU1sY3F4?=
 =?utf-8?B?bFJSTTZIN0tySjFoTHZYOGp2Qkl4Wmk2OVRiNWswTGpycnJra0dvQzd2UVlP?=
 =?utf-8?B?WkIzeEs4UXlPT2ZZUWRuYkVpMC95SGhzd3lIQVRJZjREb0pJRllTZGVJSUdY?=
 =?utf-8?B?V0xqTW9GY1pkL1Z2Nk43emFWMzN5cHFDT3BxZE14QkJYMmhjNHhJUlhOK0gw?=
 =?utf-8?B?bTB4bHM1WWlpMHBKSW9zWG1GSUtUWDRad2lPenJWcHhIblR2d2xacmI0WDJH?=
 =?utf-8?B?Y2JLNXRCVXVGbHBHa3puYjMweU42aUY5c1Y4aGtSSFNvcjI3bHBtWTc1Mmdq?=
 =?utf-8?B?cGdXZkY4Q2RqTDNpNlRkRThRMU04M1g1cEVoZ2YrT2h3dy80Q1FqcFZWc0Nt?=
 =?utf-8?B?LzlTS3laS1hyeE5TMlFiK2FaWVk1U2liNHpMZXNGc2FwMUdFMkN6VWNGSndG?=
 =?utf-8?B?cHV1KytKS0lyRjJqbWl2SHlYdEF2Qk42Y2ZZclM1K0Nkc1VhbW5sSWxXU0J1?=
 =?utf-8?Q?Woc7Wqv9pnYzQPmM=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 34e2da12-6ad5-4eb6-bd3d-08da3ecc8d0e
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1101MB2235.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2022 04:02:28.8869
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rBllYUc8LD9+QB4N55HVQp/ZVnStHratY/za/6LRvf1IE32rdIOAFvEqw9ZCUMT0wCvELlpTt53qO93ZX3vs+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3263
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/25/2022 13:45, Pavel Machek wrote:
> Hi!
> 
>> From: Sasha Neftin <sasha.neftin@intel.com>
>>
>> commit 79cc8322b6d82747cb63ea464146c0bf5b5a6bc1 upstream.
>>
>> The device ID for I226_K was incorrectly assigned, update the device
>> ID to the correct one.
>>
>> Fixes: bfa5e98c9de4 ("igc: Add new device ID")
> 
> I don't see updating the ID, I see adding an unused define. I don't
> think this is suitable for stable. Same thing goes for previous two
> patches, they don't really fix anything.
Pavel,
1. Commit bfa5e98c9de4 added new device ID for i225/226 parts. Commit 
79cc8322b6d8 just fixed number for IGC_DEV_ID_I226_K. This number comes 
from NVM and PCIe configuration space initialized with this number. (In 
case you will use wrong number SW won't work)
2. Regards PHY_ID: here is two things:
i225/i226 parts have only one PHY (there is no option for another PHY)
some unit upon specific power up condition could wrong represent PHY ID 
and we do not want block SW.
3. phy->type - just clean. you indeed can skip it.
> 
> 5106 O   Greg Kroah ├─>[PATCH 5.10 05/97] igc: Remove _I_PHY_ID checking
> 5107 O   Greg Kroah ├─>[PATCH 5.10 06/97] igc: Remove phy->type checking
> 5108     Greg Kroah ├─>[PATCH 5.10 07/97] igc: Update I226_K device ID
> 
> Best regards,
> 								Pavel
> 								
>> +++ b/drivers/net/ethernet/intel/igc/igc_hw.h
>> @@ -22,6 +22,7 @@
>>   #define IGC_DEV_ID_I220_V			0x15F7
>>   #define IGC_DEV_ID_I225_K			0x3100
>>   #define IGC_DEV_ID_I225_K2			0x3101
>> +#define IGC_DEV_ID_I226_K			0x3102
>>   #define IGC_DEV_ID_I225_LMVP			0x5502
>>   #define IGC_DEV_ID_I225_IT			0x0D9F
>>   #define IGC_DEV_ID_I226_LM			0x125B
>>
> 
Thanks, Sasha
