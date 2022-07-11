Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA8C45706A7
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 17:09:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232108AbiGKPJe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 11:09:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232111AbiGKPJc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 11:09:32 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A2005A2E2;
        Mon, 11 Jul 2022 08:09:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657552171; x=1689088171;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version:content-transfer-encoding;
  bh=LU7MpEL9Gsoo8hwHwyC3anQvAgMnrDPdJ5ex919LRag=;
  b=kvUKNChf/DVbFR79PmEtbdSnYPe7gbx//uihP3XA4ms9xV4rSplf15xp
   xLIHlkjjSDvRQy5I9hSGNqE2+QC8nIDH/Oj1S2sPX6urd5bqWPw0fILsT
   hienQDoEA2GBEUxKhEn9CMW7gfx7swtkduXYO7QXnAbXn5ef0Cuy8RV+Z
   TQ98/yDPfTDWPwYuCYpUda/n9k/TfAs2d1366l2mTOmXMNuRkIeKIDeTv
   WEOEtSmO4yKBS00bdevIY/rSiPzMfPmFjOJlYmUgtC+xhGPYSzr8dIq/X
   mIOnc/hMJv9MCIhYykuqPfQ/qhmgKxQ5C2WQIMLBTtK6tX+U7smnZ9Vnu
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10405"; a="264466432"
X-IronPort-AV: E=Sophos;i="5.92,263,1650956400"; 
   d="scan'208";a="264466432"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2022 08:09:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,263,1650956400"; 
   d="scan'208";a="545047351"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by orsmga003.jf.intel.com with ESMTP; 11 Jul 2022 08:09:29 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 11 Jul 2022 08:09:29 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 11 Jul 2022 08:09:28 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Mon, 11 Jul 2022 08:09:28 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.41) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Mon, 11 Jul 2022 08:09:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KrKX7qFWyGcGXdpQxTqEqZrjJei5c9wINXfzwS8l9J1LDSJjoS8ZYtdk5qH7oZE/eLKcpoifzKh0oLxJqNN4MLj2PyQS2AXqX0qx83QNewKR1AHuo1dy5LKUB5p/MwACbPNtoEhprC2bQC5kJ0xphnyWGSIit/1Rixa0kBiZtp7oTx3h3R1sqs3T7JTpN4ntUcF2feB+9x/3gIg8h6/rr6go3WOfl0Z9+tw3jq9Uh/ywjAfAbhGWjfbyr5PCcuE5mMKB4uueEHhw1URjc3iWVGu2WLLZqEO/6WrYebfB5+YoFkWyCEabet7OecAxuNKdemN3zsI+XQ1w1Q0Kri7UWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/n4todnB12Rr3SGNgrsHGa6O8B5rJXrMC+4i+uNpjS8=;
 b=D2a1QoA9nhryGHZedZ1NHrtpY9LjFdJ6qdQpWf4Wx0n+GhqlY94c2Bv9D1aPak4nyhUBNQiof+DWVTK0tav6qiNP6N2mV8y37D2eK/8XLQOmuONaYJyyxq7+6RH90E4/jy7TnC3tVS8WDsCcyNUs+4JYqvzqs4IpY4J9Sn4AzoSriWcLNTe4szmrrVU2eWudmWtDadYD4bXaJPON1AXIsH68/1yvooYuUW+FOLN+DZjeHktWAhfSU+372ZhGYUZuTN8q7OBzHy8e6Q9HYX9iID4jp/nkbNb+oVdZ2HSJaD9HMcn1/q+FA4AoZ34a+HkqDxpWIfzB7HReopAVsc6TqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MW5PR11MB5812.namprd11.prod.outlook.com (2603:10b6:303:193::14)
 by CY4PR1101MB2245.namprd11.prod.outlook.com (2603:10b6:910:1f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.23; Mon, 11 Jul
 2022 15:09:25 +0000
Received: from MW5PR11MB5812.namprd11.prod.outlook.com
 ([fe80::504a:2f0d:997a:a260]) by MW5PR11MB5812.namprd11.prod.outlook.com
 ([fe80::504a:2f0d:997a:a260%3]) with mapi id 15.20.5417.015; Mon, 11 Jul 2022
 15:09:25 +0000
Date:   Mon, 11 Jul 2022 17:09:07 +0200
From:   Lucas Segarra <lucas.segarra.fernandez@intel.com>
To:     Eric Biggers <ebiggers@kernel.org>
CC:     <herbert@gondor.apana.org.au>, <linux-crypto@vger.kernel.org>,
        <qat-linux@intel.com>, <stable@vger.kernel.org>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Marco Chiappero <marco.chiappero@intel.com>,
        "Wojciech Ziemba" <wojciech.ziemba@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
        <dm-devel@redhat.com>
Subject: Re: [PATCH v3 1/3] crypto: qat - use pre-allocated buffers in
 datapath
Message-ID: <Ysw9E2Az2oK4jfCf@lucas-Virtual-Machine>
References: <20220410194707.9746-1-giovanni.cabiddu@intel.com>
 <20220410194707.9746-2-giovanni.cabiddu@intel.com>
 <YlRnVBYl1eJ+zvM5@gmail.com>
 <Yswx1myaFwJR22FQ@silpixa00400314>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <Yswx1myaFwJR22FQ@silpixa00400314>
X-ClientProxiedBy: FR0P281CA0113.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a8::13) To MW5PR11MB5812.namprd11.prod.outlook.com
 (2603:10b6:303:193::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f1ff5716-af0a-4a16-c84d-08da634f57e1
X-MS-TrafficTypeDiagnostic: CY4PR1101MB2245:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j/k1edLFeGSGKi+PdSQLPt5lokGESEiCeoGkwhjXTRkW/KOkS85Oc6LHWCIqs/c23n6v58T1WCdOKSs9h86H72jhOz5IwCXkdXSu5+/lHLPEi1dg7IdXMkCitLrmDNpdE2kOQnPHXMOZJeI6Nwck4PTf7hITG9ovUU5RoUeIiAGN8URFrmAd/6p0cfb/rz/6bM+qYtfeBfbNYjn1gaCoeKoHoukjMb4XuTsBWrAn+vcpLeDM4gaQN8TmsUNtMzylXblgsGPzR5BRIIPP9LZfCwvf6Nym2xubKqnH0tzcAzdP+nnxB1dQP728ZWRHCHs7+QohxojiVbTpKTOMrck+9R4/4XY3iICTgwEqvv+Gb4lDg5sHn4G7jWK7QgeakU1crboABC5QQtAXr6JhKZXCu9GjkW4Wptekhx1bn8fVtIUgKxboxP45urzJ1mk4TizUws1CANTcEuCXnPmGofuKk8o13vWiC7vbd1pCEki2oqbMIFZrBt+jLwmlubONMvcA9WUEkpQquRorGc8Klm0it02XtUWQbHVOoV128rayY2mJouUYM7+fTAnXReQRRvpggF009+KRrlxhsWI1RoQ0k6PcUyovkGf1vYoaz8TD7dMhrRssGIbeChZznAAtaps90PDcsSy3p50rgIJwfw8Aa819/2niVh3OKAlPDOtrhct2UZIjzot9E22XN0W2hcb3mTJeUpZTLKssKhKV0lwNkX1/g6JJXEoTm9ZtQ7c3xXWdGhU0B6CQMsLiBpZ5eKZ9DSqcSG9VOFOoe3gsnBsBQ7htgTZUET9BHaWEGIBqB74=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR11MB5812.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(376002)(346002)(136003)(396003)(366004)(39860400002)(82960400001)(83380400001)(8936002)(186003)(5660300002)(2906002)(66946007)(6512007)(66476007)(66556008)(26005)(54906003)(8676002)(4326008)(6666004)(33716001)(6506007)(9686003)(41300700001)(38100700002)(6486002)(316002)(966005)(86362001)(478600001)(6916009);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R1cwY1g0UFpic1hhTnZHYmNOTW8ydGpFelZwSGtMUVFZcXVzMFFiV1pZaVdX?=
 =?utf-8?B?WU04K3RDbkh4eTl3QjFSbjNrRS9kSG05dzJwY2hqYnNhL1dJcDlBd1JPa1FE?=
 =?utf-8?B?NC9kMzBUd2hKd2dpQWZVYVNUU2lzcDRJc1c0MWNKZWpGZEVwcmFhS3huaE9E?=
 =?utf-8?B?U0FMcTdwZDVXOTMrQUxrZ0xUMGVHU1B2MkV1bzY5bmRIWExZMjloRWdMM2Nm?=
 =?utf-8?B?eW1YL1VKQWtkTXIwRHRISGRaSVFrK3c1WjZibVh2S09Cc21hWEFoZjhKWjFF?=
 =?utf-8?B?MTh4K1JDZ0x1S1NzTFhjQnZBSTNFRXI3WmhZY2xnTFF1TG1DWmpJUURTMTFh?=
 =?utf-8?B?Ukh3UnJQa3pNbG1BbVRvc0daTVQzREMvcDQ2NW1ab0VxR1F2RUR1SENxSERX?=
 =?utf-8?B?cmNXbnlTZ0lvM0ZFbUhJcWx0OVVUN1RoT1hBRmxYSDNyb0RXLzUyaTNYZzEw?=
 =?utf-8?B?T3ZpMDdXTXBTaTVnYXFjNjNUVWdZZTBZb1ZQVm1NenZzMFk3QWk5VWdEc255?=
 =?utf-8?B?TWhDbi9UYjlnbVdhSUlLTklBUXdvS3NlMHRlRW85S3VEaTdPUFFFRWE3OTNo?=
 =?utf-8?B?WHVGVjdGTElTRDBZdjMzQnpoVmpQb1hLQmxxSFpBaEZWMGxzczU1ajljWUFy?=
 =?utf-8?B?RW5TSTBsYVZBUnVFTmcrY3JaYnBlREt5dXR5aEhGd1VUaWJZdm5Pb3RkYnhG?=
 =?utf-8?B?Y3BEN28zTDdybUlaT0RvUDY5K1VvQmNuZkZTRnkxbFliNTJYbE5mcEhiNVhZ?=
 =?utf-8?B?bi9oZjNERnlWSmVsbFpRTURZbmZXRHpEcloza0Rvamh4MkgxS09rOG5RbHFZ?=
 =?utf-8?B?Yit4VmhGTHoyMFQ2b3cwdFZNSmdVRUpuYkgvZ0ZVeHE5V1AvQ21zVnlaSjVp?=
 =?utf-8?B?cmpFRW5oUGFmU1oxZmhtMk1aT0tBMzBnTDZvVjlqUnpTWXRMK2p1N1dGclVp?=
 =?utf-8?B?R3o4Rm1aNFRXcTZVaXdKK1gvR2hXMUViWko2REpXcHplUWRyZWFJdnpZSkZJ?=
 =?utf-8?B?eTd2SWpQSFpnbTY4ZnhJdld6S2pYSStnNGRabXVOZDduSnhhZUNrK0VSbjlo?=
 =?utf-8?B?REJycDNBa1lrVE5hK3M0YnZNWk5ETWQvVkppcTBaVHA2azJQeC84bmZhUnIy?=
 =?utf-8?B?aXJnT0tzNkZsUm82M3BQR0VWV0diNDQwcHB1V3VycjlyckszMGN5OEcyc3JL?=
 =?utf-8?B?cU11dndiMTA1SjFQY0g0VHlGK0luQ2Q0ZnZQYUFObnBPVXRMVDcybVVPQzBC?=
 =?utf-8?B?cVd0MS9yTW1haHV0cGFCT2twdnIrdUlyL21SUjJ3N3pYdEtBdEt0eEtrbzRz?=
 =?utf-8?B?S0JjMElXUjdjbktzSW1hbkhGMlZIWnhZbVVxRTY4YXlZSTI4OWhpN2l6Q1hW?=
 =?utf-8?B?T0FJSUQwVDdRbW1zWlZCYS84THY5S0pWY0I2K0Z2YzBZSjFraTRLWTBHcisz?=
 =?utf-8?B?cS9YbGM5TUpJZkRqVXhCaUo4djBkd0U5TEhUeVpUTE9iL0tNTnV6azRBZ00v?=
 =?utf-8?B?YWMzbHhsRnpmdEtRVG52ODd0ZFdtM2VUbTFYSGxSSGlyQmxPbnY1Z3ZmNXZZ?=
 =?utf-8?B?WFlsdlFUelZPaTQrTnNhajJTOW12NEtJRlpOOXBUUmlXZlJXM24yUkJNTzNC?=
 =?utf-8?B?ZTV2OGRsM1ZzOXFsSlZabGZZdGFlQ2xSakJZNjhFQkZXTGRlczFRV0R0SVpU?=
 =?utf-8?B?c09YMytNUThWSk1EQ05pTzlZeTBwazNWR2VybVdWMlBQU0tpQjFBYTcxUWQv?=
 =?utf-8?B?VWwvMzI2WlBNMDFaM3JCZkZqSVRtTDJxTExNcis4aVl4SnllcHpyYzVUbG5i?=
 =?utf-8?B?eUNxVHdHcU5veFBTOExvRHBEek1WWkMvY0s4N3ZaT3Qvck85bzM0UDFlMDNn?=
 =?utf-8?B?OUZwVGVHRWJZSmxZT2NTbWNTYVhmbkdmcmZRelQyWTdRTU1EaWJYcURJVEpm?=
 =?utf-8?B?TDVuekg2RnY5dGxlRG1xRTVtZ1FqZ2JneHNJZFlkSEpkdWZHbitHUjVYdEtS?=
 =?utf-8?B?RTN4V3ltMDhrdGpzTDlGdUsrOStITEk3bFpJWFpOMXpHMG5jREFBd2VNR0xs?=
 =?utf-8?B?bFRaM3RPQ1kweE81MFRSUmhFOUZEZDE3SjZ1T3ZSazZWMmZZMGt1S05aeVMr?=
 =?utf-8?B?UFRNOTczemZ4QzRyRnoxNE5DWjBmaGpuZHNWT3B5RmFVeDRiYWo0czcwNXJp?=
 =?utf-8?Q?dCl4MmMHeykmwt/bzUWtBQw=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f1ff5716-af0a-4a16-c84d-08da634f57e1
X-MS-Exchange-CrossTenant-AuthSource: MW5PR11MB5812.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2022 15:09:25.7597
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wBl62ZsPIO2PZmf0i4640Y8ksP/y2tn9I2WAvrQNKmBk2K0r88PnsLJD5gY0qwhAXsotqEC28fGicarfjd+MpKdEZB6kZ63eFQFjyAfAEkMRKBbnXkYv5R+FYWEobfOi
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1101MB2245
X-OriginatorOrg: intel.com
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gTW9uLCBKdWwgMTEsIDIwMjIgYXQgMDM6MjE6MzlQTSArMDEwMCwgR2lvdmFubmkgQ2FiaWRk
dSB3cm90ZToKPiBPbiBNb24sIEFwciAxMSwgMjAyMiBhdCAwNTozNzoyNFBNICswMDAwLCBFcmlj
IEJpZ2dlcnMgd3JvdGU6Cj4gPiBPbiBTdW4sIEFwciAxMCwgMjAyMiBhdCAwODo0NzowNVBNICsw
MTAwLCBHaW92YW5uaSBDYWJpZGR1IHdyb3RlOgo+ID4gPiBJZiByZXF1ZXN0cyBleGNlZWQgNCBl
bnRyaWVzIGJ1ZmZlcnMsIG1lbW9yeSBpcyBhbGxvY2F0ZWQgZHluYW1pY2FsbHkuCj4gPiA+IAo+
ID4gPiBJbiBhZGRpdGlvbiwgcmVtb3ZlIHRoZSBDUllQVE9fQUxHX0FMTE9DQVRFU19NRU1PUlkg
ZmxhZyBmcm9tIGJvdGggYWVhZAo+ID4gPiBhbmQgc2tjaXBoZXIgYWxnIHN0cnVjdHVyZXMuCj4g
PiA+IAo+ID4gCj4gPiBUaGVyZSBpcyBub3RoaW5nIHRoYXQgc2F5cyB0aGF0IGFsZ29yaXRobXMg
Y2FuIGlnbm9yZQo+ID4gIUNSWVBUT19BTEdfQUxMT0NBVEVTX01FTU9SWSBpZiB0aGVyZSBhcmUg
dG9vIG1hbnkgc2NhdHRlcmxpc3QgZW50cmllcy4gIFNlZSB0aGUKPiA+IGNvbW1lbnQgYWJvdmUg
dGhlIGRlZmluaXRpb24gb2YgQ1JZUFRPX0FMR19BTExPQ0FURVNfTUVNT1JZLgo+ID4gCj4gPiBJ
ZiB5b3UgbmVlZCB0byBpbnRyb2R1Y2UgdGhpcyBjb25zdHJhaW50LCB0aGVuIHlvdSB3aWxsIG5l
ZWQgdG8gYXVkaXQgdGhlIHVzZXJzCj4gPiBvZiAhQ1JZUFRPX0FMR19BTExPQ0FURVNfTUVNT1JZ
IHRvIHZlcmlmeSB0aGF0IG5vbmUgb2YgdGhlbSBhcmUgaXNzdWluZyByZXF1ZXN0cwo+ID4gdGhh
dCB2aW9sYXRlIHRoaXMgY29uc3RyYWludCwgdGhlbiBhZGQgdGhpcyB0byB0aGUgZG9jdW1lbnRh
dGlvbiBjb21tZW50IGZvcgo+ID4gQ1JZUFRPX0FMR19BTExPQ0FURVNfTUVNT1JZLgo+IEJlbGF0
ZWRseS4uLgo+IAo+IEFkZGluZyB0byB0aGlzIHRocmVhZCBteSBjb2xsZWFndWUgTHVjYXMgd2hv
IGRpZCBhbiBhdWRpdCBvZiB0aGUgdXNlcnMKPiBvZiAhQ1JZUFRPX0FMR19BTExPQ0FURVNfTUVN
T1JZIHRvIHVuZGVyc3RhbmQgaWYgd2UgY2FuIGFkZCBhIGNvbnN0cmFpbnQKPiB0byB0aGUgZGVm
aW5pdGlvbiBvZiBDUllQVE9fQUxHX0FMTE9DQVRFU19NRU1PUlkuCj4gCj4gUmVnYXJkcywKPiAK
PiAtLSAKPiBHaW92YW5uaQoKQW4gYXVkaXQgd2FzIGRvbmUgb24gdXNlcnMgb2YgIUNSWVBUT19B
TEdfQUxMT0NBVEVTX01FTU9SWTogZG0tY3J5cHQgYW5kIGRtLWludGVncml0eS4gZG0tY3J5cHQg
dXNlcyBzY2F0dGVybGlzdHMgd2l0aCBhdCBtb3N0IDQgZW50cmllcywgYnV0IGRtLWludGVncml0
eSBtYXkgYWxsb2NhdGUgbWVtb3J5IGZvciBzY2F0dGVybGlzdCB3aXRoIGFyY2gtZGVwZW5kZW50
IGFuZCBzeXN0ZW0tYm91bmRlZCBudW1iZXIgb2YgZW50cmllcy4gVGhlcmVmb3JlIHRoZSBjb25z
dHJhaW50IGluIGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xpbnV4LWNyeXB0by8yMDIwMDcyMjA3
MjkzMi5HQTI3NTQ0QGdvbmRvci5hcGFuYS5vcmcuYXUvIGNhbm5vdCBiZSBpbnRyb2R1Y2VkLgoK
QSB3YXkgdG8gc29sdmUgdGhlIHByb2JsZW0gbWlnaHQgYmUgdG8gZm9yd2FyZCByZXF1ZXN0cyB3
aXRoIG1vcmUgdGhhbiA0IGVudHJpZXMgaW4gYSBzY2F0dGVybGlzdCB0byBhbiBpbXBsZW1lbnRh
dGlvbiB0aGF0IGRvZXMgbm90IGFsbG9jYXRlIG1lbW9yeS4gVGhpcyB3aWxsIGludHJvZHVjZSBh
bHdheXMgYSBwZXJmb3JtYW5jZSBwZW5hbHR5IGZvciByZXF1ZXN0cyB3aXRoIHNjYXR0ZXJsaXN0
cyBncmVhdGVyIHRoYW4gNCBpbiBhbGdvcml0aG1zIGJhY2tlZCB1cCBieSBIVyBhY2NlbGVyYXRv
cnMsIGV2ZW4gaWYgdGhlIHJlcXVlc3RvciBkb2VzIG5vdCByZXF1aXJlcyB0aGlzIHJlc3RyaWN0
aW9uLiBBIHdheSB0byBzb2x2ZSB0aGlzIG1pZ2h0IGJlIHRvIHJlZ2lzdGVyIHR3byB2ZXJzaW9u
cyBvZiB0aGUgc2FtZSBhbGdvcml0aG0sIG9uZSB3aXRob3V0IENSWVBUT19BTEdfQUxMT0NBVEVT
X01FTU9SWSB0aGF0IGZvcndhcmRzIHRvIFNXIGFuZCBvbmUgd2l0aCBDUllQVE9fQUxHX0FMTE9D
QVRFU19NRU1PUlkgc2V0IHRoYXQgZG9lc27igJl0LiBBbnkgc3VnZ2VzdGlvbnM/CgpBZGRpbmcg
SG9yaWEgR2VhbnTEgyBhbmQgZG0tZGV2ZWwgYmFzZWQgb24gdGhlIHByZXZpb3VzIHRocmVhZC4K
ClRoYW5rcy4KLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tCkludGVsIFRlY2hub2xvZ3kgUG9sYW5kIHNwLiB6IG8uby4K
dWwuIFNsb3dhY2tpZWdvIDE3MyB8IDgwLTI5OCBHZGFuc2sgfCBTYWQgUmVqb25vd3kgR2RhbnNr
IFBvbG5vYyB8IFZJSSBXeWR6aWFsIEdvc3BvZGFyY3p5IEtyYWpvd2VnbyBSZWplc3RydSBTYWRv
d2VnbyAtIEtSUyAxMDE4ODIgfCBOSVAgOTU3LTA3LTUyLTMxNiB8IEthcGl0YWwgemFrbGFkb3d5
IDIwMC4wMDAgUExOLgpUYSB3aWFkb21vc2Mgd3JheiB6IHphbGFjem5pa2FtaSBqZXN0IHByemV6
bmFjem9uYSBkbGEgb2tyZXNsb25lZ28gYWRyZXNhdGEgaSBtb3plIHphd2llcmFjIGluZm9ybWFj
amUgcG91Zm5lLiBXIHJhemllIHByenlwYWRrb3dlZ28gb3RyenltYW5pYSB0ZWogd2lhZG9tb3Nj
aSwgcHJvc2lteSBvIHBvd2lhZG9taWVuaWUgbmFkYXdjeSBvcmF6IHRyd2FsZSBqZWogdXN1bmll
Y2llOyBqYWtpZWtvbHdpZWsgcHJ6ZWdsYWRhbmllIGx1YiByb3pwb3dzemVjaG5pYW5pZSBqZXN0
IHphYnJvbmlvbmUuClRoaXMgZS1tYWlsIGFuZCBhbnkgYXR0YWNobWVudHMgbWF5IGNvbnRhaW4g
Y29uZmlkZW50aWFsIG1hdGVyaWFsIGZvciB0aGUgc29sZSB1c2Ugb2YgdGhlIGludGVuZGVkIHJl
Y2lwaWVudChzKS4gSWYgeW91IGFyZSBub3QgdGhlIGludGVuZGVkIHJlY2lwaWVudCwgcGxlYXNl
IGNvbnRhY3QgdGhlIHNlbmRlciBhbmQgZGVsZXRlIGFsbCBjb3BpZXM7IGFueSByZXZpZXcgb3Ig
ZGlzdHJpYnV0aW9uIGJ5IG90aGVycyBpcyBzdHJpY3RseSBwcm9oaWJpdGVkLgo=

