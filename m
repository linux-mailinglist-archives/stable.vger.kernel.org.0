Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C99B69AABF
	for <lists+stable@lfdr.de>; Fri, 17 Feb 2023 12:50:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbjBQLu2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Feb 2023 06:50:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbjBQLu0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Feb 2023 06:50:26 -0500
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 749756358F;
        Fri, 17 Feb 2023 03:50:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1676634625; x=1708170625;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
  b=eAnOHXdh736b/9VvxmtEP/ZOkn0a+IXqXXCiFgJdle0Auold3Gp/gy/0
   IW4jMlVNF6RdEa7cxoC0DDzHzuCig+8Nbi246fGzRf3RcNWjBlfBZL2tr
   +43bn9wP73k7tAA7tRfZ9IjDQHCkWbXqJw9cvlmTzpmqeXbP/PRCp+y20
   4EVBNOsB7XmpUwQ2kh3pW/SWTsKWhf7xuV2QCt7xJqxOQIj2VP/o9ZVMI
   3/Fzf1TTNiT0yKcMR8lhCFqLUe8lWL3r2tMST6VHHlqFmdRb+RCxZIpLv
   v4br7g8e/NYVq85BmA9u8hr2Jiv/7QDoIBtklCbZ14QmBKcAXDLuLZp3q
   A==;
X-IronPort-AV: E=Sophos;i="5.97,304,1669046400"; 
   d="scan'208";a="228538974"
Received: from mail-dm6nam11lp2177.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.177])
  by ob1.hgst.iphmx.com with ESMTP; 17 Feb 2023 19:50:24 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eJyoB1604i7vFAi1mgQvKCPkya43HMxuNHe8XNhEa+GLwwjws+CIg2Tf2ErTaEr4zKqiLG3/q4ATfyr2a/0IqOtu7/seS0DA+YlCp7UNaX/YvFtp+nA49LtKjsXu3wrKeedqoCnp893bYzQmzOo91nguckETnlpeoavUDlXIgedo+70ICuklK+kGlQpY3dOH2hZcq4gzUTBuow3N1ft69Ww8Wf5MQ5/kzcECB4EnZJkq1jaANP07hgNLQBjQstdr5bfB+CxtbdlI2gimatabpbixhMX/t/vi5Yq7PhrmkOidhciBmHg576mJ6D0BXTNzVDpK8uJYADTlxm9CfniJiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=FeaY7hAeY9PEj4O+TiaIBRBVnBPbVmYU9cKKDYpIZ2KT5+rE35Zlz9HMY+8NmoPNgkXDUM8rSSfgVaUcc3Ys3lAfFYNxbNd1vnfna8d5VRHhU51L9V/HdVovvC0+pqgacFxFbyCKCMWi3Fw/5JxqzMt0ddRVqluR6SzqE84eSz+lZ0n3yetKTfxVYgVE1yvFK8Qe7O+OQtAze3lRARNcCEJjLbWL9Z4GsCeEHQJ0u5uEcrU69/CY/qg0+iQ4vKo6UUCJVs98wTUqhOSuevNi1tSA4jMY/O9SOOp/L5nJYnRKdVcVLOfHoMRho7yhj7TFsAHfVBFW79KdOFVNqzQxpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=CVe6LdbNMIxqoCPTTc/Qd1xIAaMDhApvSWrr5oNrIxx2mkkQ+12JM6tRvwn2PKJsd9eByCWFUDWAyNxMoXsB/I00vr9T+bEk4BQXsWQZEk7G8fyw5MD7SesSL7c6tlZ4x5empyMvxBT7vrBpqoS+90FKnLXRsoxRyv3gZbVCjxk=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by DM5PR04MB0957.namprd04.prod.outlook.com (2603:10b6:4:46::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.13; Fri, 17 Feb
 2023 11:50:21 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8ed8:3450:1525:c60a]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8ed8:3450:1525:c60a%7]) with mapi id 15.20.6111.015; Fri, 17 Feb 2023
 11:50:20 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
CC:     "hch@infradead.org" <hch@infradead.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH 1/4] brd: return 0/-error from brd_insert_page()
Thread-Topic: [PATCH 1/4] brd: return 0/-error from brd_insert_page()
Thread-Index: AQHZQhoeRCJoxh++A0a6Bti2wuNHZ67TB9EA
Date:   Fri, 17 Feb 2023 11:50:20 +0000
Message-ID: <d7c1d1f7-74e9-0359-415c-81b2238759d0@wdc.com>
References: <20230216151918.319585-1-axboe@kernel.dk>
 <20230216151918.319585-2-axboe@kernel.dk>
In-Reply-To: <20230216151918.319585-2-axboe@kernel.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.7.2
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|DM5PR04MB0957:EE_
x-ms-office365-filtering-correlation-id: 938cefd1-a858-4115-b550-08db10dd2591
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xnZT7D+pN2UZ95uPd9LIsZWyoKHERDWxB3gqBJM2GrCqrW/GLKG7crwE4sIXpUiHfvr4W7QlYD1rZPVEUySlIAqcxo2UNVrJ2PCVyQEfjs7mJLTjq/NY5GKvzzpbMoOhB4YXAICZaDRk4clOd2pDU4nisP9UJ871loSy3vgbD5vcKmtI3FKUIPL2ZN/nmMKPJcsuo0rBpGXAZlqonkwZiVICboqs5hOH0JeQQRZWVvFBMf5gIeHkoLpAyFSmWqz+JzVl5dnsHZCCwvxY7BNgM7muczL0b7sR+WUAe6i993F86P3kf0YaX/4U95LhITs3CWL++IhRpomfzu8M6OcRUZgq6n48g/whmkIJl6SVcqHuqohwSNhZpJxo0vGCUgjFxqRr+YKSBiGCjruD/fAAxvWv3DhtUdvjWzdF3kd4w6HXJWk/ln4SSh2wAyhwnul01GkL72PcHjbGLhFmBg4ohqNLr5CH/ahqGVEXpAH+CGDlMMlJmJ07YvAOMld8Mlro/bdAJ8mnPSnQFBRCTNybSSvjM5h4O9IRQnohMmHaqGzDzeiVm0g6WhsgFYb4NavaUaAQaMgKF6KauiRO+XsNvC+rFw+ENIaE9h996PzfQRNDAo9nmr3Az3it72YVxyTh27OoAWsCgaTNeoAQ10b8pAXZretgWjsJpEu+XOm0JmQ2DMt3NS7M99ev/CavVylJz+GFWNt3TQvY47+h9+TC8a0bD1Jk5nr7n7HVhE1wthqzw8nJWQ8lLC9JdlPC2X9nSjJnmLPfXGeyKVFZ++kYlw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(376002)(39860400002)(366004)(346002)(136003)(451199018)(31686004)(2906002)(8936002)(31696002)(558084003)(36756003)(38070700005)(86362001)(5660300002)(19618925003)(122000001)(82960400001)(38100700002)(110136005)(6486002)(71200400001)(4326008)(66556008)(64756008)(66946007)(66476007)(66446008)(8676002)(54906003)(41300700001)(6512007)(186003)(6506007)(478600001)(76116006)(4270600006)(316002)(91956017)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MXlad3lQYkJBdG1KU0Q1QllRazQrWGovYitkQjVHTlJIM3ROdCtYYlMvYXo2?=
 =?utf-8?B?UEVTdjdFSnA4WVFpd3dwMloxSDZkbW4rN1VDUzRaQzRZVS9rbHl5ZldUMUpo?=
 =?utf-8?B?OVpMVk1MUEtmY0pMU05BeFFKZXpZNDVieGI4Zng2SzZZSlJGL1hjbmNMbXJK?=
 =?utf-8?B?YnB5NUh6bUZMTXY5aElneURKN0MxTy9aTjUrbjR5QXg3TTJYVUU5ZHNtTFYv?=
 =?utf-8?B?TGF5WW1ncHloaUJUTU5FVEJpWVEzcjQ2UFp6Y0hmQ0ZlYVZHOFQ4bUlvYTd2?=
 =?utf-8?B?eG50ekJDTHRpcmpuTjFXdkhlSE5sWHprYU1jQW5YRkNtQnFvTDhvbmpvSXVB?=
 =?utf-8?B?NVN0YmRSOTc3TGxqMjJWbDhzRHQxZTF3UWdNQzNHOXRCN0J1RnA3VS9GeHVX?=
 =?utf-8?B?TFEvNTZxcVRrMXNIcThCTkFRc2s1eVpXWEhDMGVzQlZiUlNwWWpBOFc5d1cw?=
 =?utf-8?B?OUFUUllmZXpTVExLRjFPNU56dVdoRFdGL1FNcll5MlZtUW1yQjNKV3dxL3kz?=
 =?utf-8?B?ZXBzaDdqbmdxLzVFeS9pT1Azd1FOVTVwcEFCUGFqRzFDWjR2akl1Ny9rOGo1?=
 =?utf-8?B?amdnR3NKQW1tWmthNk05WnhUbHlERHNzSDBwMVk4KzlXVVMzSGpTR2kvWTNU?=
 =?utf-8?B?Q3FYNU9rcHhRbis0MGZCc1p6dGJDUXUwcW9oTm1EemV4VnZXMDQza09ydXJP?=
 =?utf-8?B?YUxjVHBFZWZyYm9wZ2RHS3IvWkhvVG9ZMmlXdkF3QzR3M0luYldod3k4OXFz?=
 =?utf-8?B?dDJXZ3RUM3dGMWVvM0E4MzlWM3lHek8ydTltYzNKOVh4OFVRWjZpWTNyOWpK?=
 =?utf-8?B?UDhRYVZrbUVvTnZvaUxRMDhZTlNBeDB6TzhwNDRTQUEyQ1FZQXlmbStNVEtG?=
 =?utf-8?B?MDVnV2ltUTVqeVZUWU1NVWw2QWJEUWp0YnQ2aEdjWngzNnBTRmtEbzlOd1lH?=
 =?utf-8?B?N2dpTzlyaWVLVzFlaHJKd0tsMHBlZHdaemNXaElQVEt2MVplSng5NVhZdWVX?=
 =?utf-8?B?REg5c2lRZ25hMEhpZlZ2RjZpWXNTVkM3S1poR2JLOG1FWW1LeGMxVitBNFhk?=
 =?utf-8?B?cDJ1RzJZYnAwTitKV1RTTTVjcllBczhFWDAyRU5SNTcvZG9CYkFCdHcxMkRH?=
 =?utf-8?B?S3pvT3VjVmI3SWMyUlROSHpKWnBaUTVKanBVVXhjbllkNDR2c1hpL1hWMUpD?=
 =?utf-8?B?TnlBVHB2U2dueG5RSEoveXBsNTg0bEdpTmFVUmpPK25jY01nQ3A1YTU0RCtt?=
 =?utf-8?B?Q3NQS29MR0JWU2lKQVNzMmZqQmNvWDFaV3FYK3RUYkh0cEhCTTk3bHVIN2ph?=
 =?utf-8?B?bkpoNGk5dXBoVjlqM1M2RHN1bGh3VW9HQ09BWElmNU4wNmYxeTJ5cHdqMDVh?=
 =?utf-8?B?UTZvWnRZaFhhWEpkSUJON21yWGppRzVIbmxFTkhQK09yRGtuN0ZNdm00N0Ev?=
 =?utf-8?B?SjJFWVBNcGV4S3pSaXBZcDNzK2h1cWtldGU5Y1g2bDcxUngwNFlBaUFRWGdL?=
 =?utf-8?B?TFAxdzUyRWxlZE9YdktuTUc1TWtTSzBtZFB3akdjNEhmV2RJdEVyNVVCc3RW?=
 =?utf-8?B?SnlITmlOdXpXdzFTQkREckxoMlhnMENtWU10cWR2dzRRRXhlODNabUx1bnVm?=
 =?utf-8?B?VVdFZHMyYkcyYTB0eXV4bXkyb0QwWG5ucUhZSmFIQ0dBV2FUT0dOOGhWWEFK?=
 =?utf-8?B?NjJxYnpTU09EK01IWDdwQ1Z0SUQ1ZU5VbzJZSFJheHhTajJlTndJQnZ3SCtu?=
 =?utf-8?B?c0d1d2puZG1hVnNicGtBaUNmcE85QkVVd1JyeXRoTkIvV3NwRmgzWVdOZTZJ?=
 =?utf-8?B?U0hPU3JSd1Z0QytsekpTWGd2MWZmVElIT2dNNStFdTZBUnhJOFZDYUpZd3BH?=
 =?utf-8?B?WDRFeUxaalZMaXA3TzhKeHUzZ3YyL1hLVHUyU0NGT0ZkSzY3d0ZTTytudEhB?=
 =?utf-8?B?aWh6N0dKS1BGcU9hTXl1OGhkdllmSEVTY2dCSitjdG4rTmNNaHhPb0R4VmJD?=
 =?utf-8?B?S2dtT0ZlUWU0WERoZFQ5MFV5YjhUWWxRcktZczF6YkcyWTd6ZUdLNXE5eHU5?=
 =?utf-8?B?Y2srV2ZNMFVUQURhQTlmZm9pZWordUxra1dqTzh0bnZJYmM1UlFnUmNSczUw?=
 =?utf-8?B?emhMMkVLNXUyY0w5SWQxd0ZKOVluVU1nM2pTUmpYOEhyM0dKd3lMWTBzK1dh?=
 =?utf-8?B?dERETEV4ZUZuV2VlMitTaFo1bFFWN0hQaHZyNWY3WGZ1cTlHMVhIc1dxMzNn?=
 =?utf-8?Q?gnLG+gASADNALAwUIUopzZlNrOWv/BesFGufSlauHI=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D96F8E831245D7418B14D6DCE8BCD3AD@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 3AdLAAWdGKGEEOpFD5R6Fpk4ZakfzBLSdVXYmf3FBPenR8BSnmpOHL/cSGXaYcw8NfrQcqL8FaJgE+yqPP2Xwei1qlDoVXKkHLkvbxdME5a70yDNLD9AOfpUReUA2TUewxgat8EP4/oql75TuEI2LUQ+CLYm220StEH561zlH+Nsrxj6NzWJOSARxm30jmAS/uR8rzazo+VTYyiGYPGKO5BKETF7z5M63VwgFyvaqFpVuqDVZ6HMaaDHncj6G6ltYUFbhZERN1phn+Pz1W5NRqu/mModhEwBFuNiyX6p/T5Q7EdJSE3bCzdaH56BGV3BFRcaBWW0KcXnSzx+yjhaXvh8WipIMghb+VipHu72VomOIXcKuXgyDojO1cfChLudheuHvvi0UoT2SCulaJ3/qHT03Zt0b8qBQAciXcOYDRvAN2KNEFRvxeX9CmI8d92ym9u4j66KY3UT9TsLlCjK28MI7McEuzige72PcqygRcqY4A7DU3pNTcf/qVfY49kui3u/uOEFOg/JY7tLznEMSJFIrwlCgu0DlSsGe3UoVcpXWyiRCO55PlWvPLWxfqmF7xtJ0Fi8WkB9ws8GJU/cr74OY/rI2El7qKRZG+MY1rGok2by5+wzUI6n+yyAyQeeh4L3P7owObRP0VvrIvNDlposNLhu4i611PyUsYTPHCsJ4MEfactx7BLGuSKnlnkcdSSvkmcYYbtwjV7TbMWzAsS12NvhRLS59LbmrsJ2jrc3m04txCwTLJsZlk7jOiq6d8kEuIpcXOuefd2yOKKNJ2A9QfVFBzczH1dtsNBnRinDZTakbNMYoDIzHYjXU7t2uEEYPQNwr+Mo2gBAQk/z4QBNHfT3epSgHnLMpVImL54=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 938cefd1-a858-4115-b550-08db10dd2591
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Feb 2023 11:50:20.7023
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Bf7pfecHL50/GglZn8Z6WIBeVgRCf+ms5Boif6jdeh+40TxtO9O5rxhZnr05Wwg1LOeAqJOSyK1TD5wP8IUq6g+62XfVN8PT/WvKJ4xIzV8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB0957
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

TG9va3MgZ29vZCwNClJldmlld2VkLWJ5OiBKb2hhbm5lcyBUaHVtc2hpcm4gPGpvaGFubmVzLnRo
dW1zaGlybkB3ZGMuY29tPg0K
