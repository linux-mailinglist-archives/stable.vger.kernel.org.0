Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57AE7693F34
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 08:55:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229878AbjBMHzz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 02:55:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjBMHzy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 02:55:54 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3E8A422A;
        Sun, 12 Feb 2023 23:55:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1676274953; x=1707810953;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
  b=nMdi2ZNXDYbqJSD6JExpmyx1wDPnPYMBfCz1bDfMnKnXyFHl5yr67CB2
   GWOSHqrejGVmECN3/ae4CR9Mx9Rd6ui+b+uJyE6Cun/P9RsLgcjuJjEya
   rcPs4AZ9GgBExfxekLZrmTvc9yGNFF1dAVRqjPgXLonnOav7JDERTJOek
   zb1FxCwoWZ8MGFEkKr24PjA/zs/U+JQYT+g5KT6RPktxR3Vko0KsvPeea
   AoLWTDz0py076pXbvCymVEizfQZObuGOaytviOYYttm6DZmIEKHw/dATj
   JSKSXYdbZISrAWNt0gcvSU2zCFCiN18oiwdJj/WXaCsZDmLeHSP5X5zxW
   A==;
X-IronPort-AV: E=Sophos;i="5.97,293,1669046400"; 
   d="scan'208";a="327459335"
Received: from mail-dm6nam12lp2171.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.171])
  by ob1.hgst.iphmx.com with ESMTP; 13 Feb 2023 15:55:52 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XSgSw9wb9zt9ema2IcmjEtqS0cDDNgW/kJnPRkcmCmYIQTjuclBmCleviLbl7ZebkMSMVYJR7zDnssHsm0SXOQa2q2Zuvxnk/XCF0Nn325pLRWFPqVEjFKFsDkAG6JXJrrkZVFql7OkpfC6wlhMv1ttshwMQ/WFAxwZCLnSzycuYcEloLo42+ZfrukMQbjQMp1PZcJZUlFGLohKzG5Tsi5Md3IbmVN1XDaWFL5cE+V62Gr6hu2DgyfBD2SUAMKrUgfEryVAPaWncUoI3mafqRNDEWmJxQAwZQ/Y6nS+rB5d5eIvmXmvWaH6JmBZtVabA8f/xZ48zz62cifbq1w5p/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=SVnCGITeUssA3FEmpRrukiwZCZTUKLe5W2/US5GURzAfhlsXNr1NKwQvjfc3cV4LlgGmVDyPj0a6K/XKZm5X7cyy8hboZIK97kLdhZRm6aX/LJJWDLMXYTbrW+m8ARChk7sS+Gp6GzjwYN2ZWCMAYUFMd9P/fr9YJec49mfap23szlA+OqyTzgcJ/rlP8vHu6zr8uRNcfM4pSyDUlX89OQZcsmAxSTylzOLX7k9bVOsh5vzuZrsvyT88icWtqRTvGoFlDlnryS+3OZT6jfTFuZD77dCOyY0y/FoOeZZp7ExTJ0RnIVwNRT+k3HsMMniw6Yp7N8gxdYko/ECThs8YeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=QrgMmTNK6d5rrx7iKHzoWpr3gBN4uH57CXZmwnM+0dLzTY3qHz45DLItiLoe4NZdHzhx59W53oIzDeT1rI6PkpR+kTrewpup17sF/EB44Q6oNFVMDcFYfkZcSuPKoncdWUl290dFANzH+Tl4RrvaMC7xvYQ+wCY+YNw7nGTwfMU=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by MN2PR04MB7008.namprd04.prod.outlook.com (2603:10b6:208:1ed::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Mon, 13 Feb
 2023 07:55:50 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8ed8:3450:1525:c60a]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8ed8:3450:1525:c60a%6]) with mapi id 15.20.6086.024; Mon, 13 Feb 2023
 07:55:50 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Naohiro Aota <Naohiro.Aota@wdc.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] btrfs: fix unnecessary increment of read error stat on
 write error
Thread-Topic: [PATCH] btrfs: fix unnecessary increment of read error stat on
 write error
Thread-Index: AQHZP2mR3q9lKXZYmE6SvwwMPD4TKa7MgliA
Date:   Mon, 13 Feb 2023 07:55:50 +0000
Message-ID: <eb006416-e47f-b264-e059-8cd8338475ef@wdc.com>
References: <29145a990313cb8759b8131b07f29694cc183ab3.1676265001.git.naohiro.aota@wdc.com>
In-Reply-To: <29145a990313cb8759b8131b07f29694cc183ab3.1676265001.git.naohiro.aota@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|MN2PR04MB7008:EE_
x-ms-office365-filtering-correlation-id: 13d35143-3381-4b3d-e84e-08db0d97b955
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1+7bOA+XUHPW4j6kWPBhcCbbDvzKv8kPwBHyI0kgZTnDblovLCCoRN8Fg68e6wtg7YANxT1UfR8SdKr9sEL4HT2mC8HpCkSZkd8WfnZ9Hpga9RWlMsbrMhc5dupTaRBgteckV4hXBuS4kXz526iEH0Z5uULO0Sd+y21Sb6eQrQPo10LnAv5vG6qdL5OdBzLHfiM2kkVdj2FsaKJ1atS+oA0U630CBzBrfGhK2TDo0Ka1R/aQwJcp/W5c1h4efrXaFnfyyrcx7eG3GrwsoG49ZOXRIKzdFh6f2R6fttiFTDUrgWvq+COL8raUX/gbl8jIbzKARzVVyEctOJACK34hjfTszA3Nr508pbVejOcyTxpmyBPTBaBKEI4vQVko4Vfqlz3pa96m1PZEbwgbmlQwKjvk103c49md+jlVq8oONv8kWMRqyZPW8lnu8M2oGCX5eeYlnNEw7uhiWz2Txiw/nu/XOAQimNX03BVk4hhYV+OFNHX6VtziKH/Vn+MtFy03SNrqZqJwOWMwjiGDIon7YSW2ev40Hne787RErz31+OHo/G0z142S3WVhESSDoaXjlxc4GbnQGKWeu09MaklJuIoN25Zr9L2NzngoeNQVMZ/C93LbtocCgaiVxzv93bv8SO/dOCp8t248DMtLt36PyFzWEgTyAr/0yQkJeaVZtzNlLMOTHHgibTEAAQY85N3E8n/7e2EWw0reCXLmIte3pfDOj3sIgI2dvd1ATBM3XArIe72uIOtBffH71Z458UVS9sAcSgbo7FNe0q6lhnrq2A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(346002)(136003)(396003)(39860400002)(376002)(451199018)(2906002)(31696002)(86362001)(19618925003)(82960400001)(38100700002)(122000001)(31686004)(6486002)(71200400001)(6512007)(6506007)(4270600006)(186003)(558084003)(36756003)(38070700005)(91956017)(316002)(76116006)(450100002)(110136005)(8676002)(2616005)(4326008)(478600001)(41300700001)(66556008)(66446008)(66946007)(66476007)(64756008)(8936002)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?L2tBeDl3ZDVKb09FTHMzWkJPT3lPTW5GZWpjemV2RUNZcUw5UkJ4M2kzL1Bw?=
 =?utf-8?B?VUF5Vk5zQnFjQ2toaWo4SGoxakNpWG5XUXA5V1U1cStzZU5HSE5CNnZIeEZ3?=
 =?utf-8?B?WnpHMGxNRXp5WVlBWFVhTlFxUmFVcWFTanJxUWFGL1VIb2twQUhYYnJteGxq?=
 =?utf-8?B?TmIvUzI5QXpWT3VQenlyZGpyRExsYkY5bXcxYmIwQnMzY2RYVGV6bW00TmdI?=
 =?utf-8?B?Q3JNU0xHZjByRWEyZTNpNDdiclpzQTdDY1dNMUgxWUhLK3JCVmdQSmVVekFH?=
 =?utf-8?B?TXF3bGFZWTUrWUhSeElxZEgwbkswUS9GYzd3WUNKMzhseTExOEcrWExVNTFa?=
 =?utf-8?B?c3ZqVE03VUlFb2dJNEFQRUx1YTYveUxyT1g1akExSTdUZ2JxT3VST29pMTly?=
 =?utf-8?B?LzVpbUZKVlNSdkd4azZkeWd4aGp4QmhQVGhRVEpTU1Zoa0p1M2duR05pR00r?=
 =?utf-8?B?SUo5eHp4ZHh6N3JYWG16a0pFNnNxWXlEZEdxSnJ3VWVCeHdLWGlscG51bmVu?=
 =?utf-8?B?ZVBFQVlLL203WXdpY2N2T09LSVBqbjJFbmJwL0tsdVFLbVh5L3ZuZno3L3E2?=
 =?utf-8?B?VTl5ejB2bExDak5JbWJMZVlxLzBlb1BOVEtxbDNMM0pma3hPNll4Sk45eVZ1?=
 =?utf-8?B?SzJ4bGRvb2N0aEk0YVhGNU0wY29UUTU4RW1yKzZGNHh6djA4NDJuWjUvUm15?=
 =?utf-8?B?MjZjQzBJK3VnWS9jekcxRXNSU1k4VVhHVlI2YkNJNVJDc2w5MFhpY29CRUR4?=
 =?utf-8?B?Q3l2RWFEdVNRVnZ2bHFSZEVSRTBYQ3VzNVZGbXlNeGsrbGliQUtOUjRoanMx?=
 =?utf-8?B?M2FUbEVic1ZKM29ncnMyQTZUUmNoMERDUUVYU1czeGxiMkZJVDU5WnZRY0p6?=
 =?utf-8?B?VE5nN1BkS1djeVIrd1VIanN3RkVzbmZMOTNuUTJ4T0VLVGU0MDdlYTBLWjBv?=
 =?utf-8?B?eVR3UnhwcDkwQTFKdEhEc1hwUk5UV25ERE8vL29ia3lpaVlubDh4MjB0c1lk?=
 =?utf-8?B?QUovdzVabEdQeEoxZlRhMlJQVzVJQmM5K1Vzam9BWFAzamRaTVd6SndjRmNu?=
 =?utf-8?B?dUQzMGw0Q2NCR2pWWENpTVQ3K1BBaGhSK0RMUlo5L090NTJTcVhHTGlXdE13?=
 =?utf-8?B?TTA0Y29rTDF0TS8xbmh1K2M3dEg0dzNBdTN3c1hsYWhjd2xJMjlrdHFXMmlY?=
 =?utf-8?B?SDZGRTF0eGcrUndYbDN3VWduTE1IMWRFRXpsT1hxTWxvV1B2aVNRMVBSYWk4?=
 =?utf-8?B?NjgrdFUxQUdYbjRXNzU2OU5obWF5ZDBhMVozZWltdThDanRTaXhWS1IxbDVk?=
 =?utf-8?B?T0did0dXajhhOGg5TEVLYWZUdXhYWFZab2M1VEZZbE5lbTFhc0ErWmQxc3hn?=
 =?utf-8?B?NGVFVGFkSThzNXgwaDFQN2QyME1mLzQvcUtHL2JUVkpEMmJzTDVMZERCWDgy?=
 =?utf-8?B?cklieitVenZ1SjhCUjhkL2swRGk5bEMrbW1BdTZWK1RYY2RuMnAvakpPM2tk?=
 =?utf-8?B?SWdObVJweUYya2tTby9ocTRLc1p3RTF3eDNPQkdCaEVzMzNuaU9iSFdSY1NL?=
 =?utf-8?B?dlV5THhBcENpdkE3MjBFYUVtK09Jd1E3M082ZnZFTmtGdlR2MmR3MDZxUEhl?=
 =?utf-8?B?SE1SUndzSWptZXhINGlKb21aV1JkUnNFU0gzaGljMTg5Nk1keFQ3cmRTRDRM?=
 =?utf-8?B?Z3EzQXFNa2sxa3BIYW5xWmMzMVM4eG9rWmQxWHpCa3MxSURFRXN4SlN3R1d1?=
 =?utf-8?B?N0lTVm5UbDl0SjJGVksrQjFpdU1yRUhYYTZwbjFQM0FWb3RVV1dTRnIya2lG?=
 =?utf-8?B?cmJaVlhLb1dXRDRhKzBJV2U3TkJuZmtiY042a3pWVG5PZE1NaUMvZEVJMEU4?=
 =?utf-8?B?R0ZDWU9xS0dFdmkrYThtdDMwUTJ6c0NWb2lhbFJ0UEhib29KdE5mUlRXTEdi?=
 =?utf-8?B?NW0yZ0lxZDl1ZXBVU3dNZGpUTkZFOVkxQm9RMzJFM1lUdC9SVUtmV2drdmJ1?=
 =?utf-8?B?bmNZMVVqTm82bVRKUFFjM3hBQjlXMldycHJXRWx3YklEazc3WnFwU1Q0ZFNx?=
 =?utf-8?B?dEM1TDJXdjFYVzFVUEJLK2F0RjRGSVBmemp1VjZIZzBYVldoalB0dlhYdzlJ?=
 =?utf-8?B?OU9ZVDMyY3JOUlVXbUYySlBrUUo5RDNaejZ1N3BlTlo0T0tUODlnYWYvREd2?=
 =?utf-8?B?L2ZiZ3FjWm5PcDJCclZmVmxSVFlCeWlwOTh5OUZPcDRBVEQ4cmo4M25tSnBm?=
 =?utf-8?Q?oZ4523V1S6gQ5BOjMISuRuRgZ6gOicCEb4iVQep4+U=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <08BFC3EDD9C9804F9306174457A599C8@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: piR/MJvcKi0BVbiuKq/RexXvu1drhSffF3qs5e43/brdBwDv1SCFJEm22BH9qFEi4r0uPOXwPzkwLVP8SUeorzJedj6PlbS9Yfod5K3LO/0vIG8GICnOi6NAj/douCkxCMcdJguZTAvI3f4KkabFFI0nq/V2oauj+oUfXY9lZvvPQRH5sGYAvSSlsQyEVU9lsiLZIKYusSTOZDX39GMdHRx0TM2v8IY5TD9hc9jrL+z4JH/S6nXDvqHa8NyQihTP5bhth90or9I+46VDy8g0z3mULx5FmAr6S7CwSgLyHGwZSAqHF/irRVKBnNrr62E6Y6IfeGfmlBhmCGu5OGjukdyQfkKv7fTGpVCC7h4+3Bha4mCfMsOvyZaKaugOUcBp3DAlsVTsh9wfwt520cFIxXibIi1cpYl04xihs13CT5FrqyYgqCI5KD/NHEa3azMdsFGDoqumJ/DKasrQ3GgTV+x6R5piG4wkTMvxmmjr776YRDIqqx00ppk/eHcGq8RlxLN++iN1vs4JAIXpsi6MVKKVVrhhe+Jpgk0EkTzYCVVP1wnUjgoNfep7Vcv18wJqfOQhBw3Ptc64vkSqJncJxYkEhu0/9sFOl0odGWCsR/pb7+KMJjyHx3dDQFrzpW0GyGs7SGU1Z+wcwcQruUQ4TvXKTdS10cBS6xlIDG0KOyBwx1W0VWjmD6jxExd5nLICZTCCHjflIXHxaMMURJDQYdeUghp4cUi5iMsvKbdI4rhDJRIIl9RK/7XLUixsyOaAct32AGu1iRRjHUUa9hraxw==
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13d35143-3381-4b3d-e84e-08db0d97b955
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Feb 2023 07:55:50.3538
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RyPuYJ+T/cgY2zz99nGeuGEGreZf0fLvqcMGh6n+4Q5yrVwulA8PmdN7XxU+tHJUyATqmigy1XEBDUlW/cJgHnMscQUd6Y2PjV9+XDH7vyA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB7008
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

TG9va3MgZ29vZCwNClJldmlld2VkLWJ5OiBKb2hhbm5lcyBUaHVtc2hpcm4gPGpvaGFubmVzLnRo
dW1zaGlybkB3ZGMuY29tPg0K
