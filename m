Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F281069AAD0
	for <lists+stable@lfdr.de>; Fri, 17 Feb 2023 12:53:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbjBQLxH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Feb 2023 06:53:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjBQLxF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Feb 2023 06:53:05 -0500
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14E221286F;
        Fri, 17 Feb 2023 03:53:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1676634784; x=1708170784;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
  b=mObL0pAYqeKLH3hlTAWiwyygBHjbIsd0zruGLD99BhdUjydQ3eyfXuTq
   o9+2F6w3QeGKuHTXvKutZFIbC2Fq0ci4OpdWLojouttMoBxfSgFRyBeNO
   rihgYlXIym68FW5yjZsNLQPUEtD1LDkPTzlSpzm5e8tKQRlrAUbNapSk5
   5lyMmhDchagYNWFIBW2D7wnbVAYTWVxRPw2fCs0C69eUxSUFY7GvlPnPs
   bSeJRiXTuyi0YWOu3l9epXb3k3Z+gXpE0l6pwJZlFz2+RUD7YRIyUu415
   GzlMKQqZWNiLE/FiYMcqIHJypOtzmcHw9gwGgHtvb4vZ3g7qowVYoIERs
   A==;
X-IronPort-AV: E=Sophos;i="5.97,304,1669046400"; 
   d="scan'208";a="335535415"
Received: from mail-bn8nam12lp2170.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.170])
  by ob1.hgst.iphmx.com with ESMTP; 17 Feb 2023 19:53:03 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gAgI3hnrKfjLaEL/LBdATLM9ZWgXdHpVI5JukdhAbpDVvowmEi6cnngMudkKxBRCBUqkBoVus5DLXkczehHW3bv18LfGXs6PmZWT+0+FmmPaUwhA/M5ER4ysdW6Tzp1ApLqaZzH+Y0kz97V1GeAXK68raVKlZzG/sGKvdWzfUicP5fCsLfxXq4gVdPTY20H3OIJX9wUHcENQFXZSP7UOENq4hlVEQJrIJnNMUyhxRxbX4Id2/qqMi7Ur1c3XGLOxNYp9I9ydkhcK9tNw+zWwf7HdM6R+OHK1BmLyZZggkbEdi+ErXttv0FSX5oxsfl5jpUHdpJcrAFPU28lU9SNZfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=K4P3uJLTH5+TmFDZXT2ImAXtpVUAcv4TcsrimHQw1wKoRhiHwUqNX3ld0Rof9lPKvVIO8zSR3oWhIOgZvFhjPZVwmw7G7AmDUk0fppw0PiCKI4VJl9fw98Ce6IJSfe38QPXajEP3jNjDxH6x6TafHvfgeJIC8rX6WwPBiaXL8WI7uWT9wQLOhYcrzrLMO6hSx/+OjWJQoBqbucbYcH+0YkKpUa3evo4yOupHq5r50AYrTW4lkvyk5J8nTN+HubvlZdZ03hRlOPbKbETYf+Micl0vr8flO6kc1NLp/mpinvZU1cmMPNINYzRWXmWiFeq+m3ox5Elq0apPl8NNtNjCsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=jqAjKT56unkJ7r2vVJu8kjlRGp2WTD9ULRxTl/liyy6n/MdHiKPSZT8QAH1f1QaEj3gS2rbm0t3dDviwCRDJPHbsg0gE8FfLt2mmyCBgdTY1wfoJqum/LpY5Em7nfHcmekoY1p+boWdSxrlxg1yDUVWkttUg/Sic3oFFZlQAku0=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by BN8PR04MB6451.namprd04.prod.outlook.com (2603:10b6:408:de::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.13; Fri, 17 Feb
 2023 11:53:01 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8ed8:3450:1525:c60a]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::8ed8:3450:1525:c60a%7]) with mapi id 15.20.6111.015; Fri, 17 Feb 2023
 11:53:01 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
CC:     "hch@infradead.org" <hch@infradead.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH 2/4] brd: check for REQ_NOWAIT and set correct page
 allocation mask
Thread-Topic: [PATCH 2/4] brd: check for REQ_NOWAIT and set correct page
 allocation mask
Thread-Index: AQHZQhogHIOYX3m9YkG2LbMzwx5M2q7TCI8A
Date:   Fri, 17 Feb 2023 11:53:01 +0000
Message-ID: <baa439e5-6be3-14ca-b0dd-e09d1281e25c@wdc.com>
References: <20230216151918.319585-1-axboe@kernel.dk>
 <20230216151918.319585-3-axboe@kernel.dk>
In-Reply-To: <20230216151918.319585-3-axboe@kernel.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.7.2
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|BN8PR04MB6451:EE_
x-ms-office365-filtering-correlation-id: 35124748-5c52-40f7-cdcd-08db10dd8528
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4CU28MkY+ZbOjsK4FvRThjSTjKFVDW+PUG79ZIAOx4aSpN4FqoPW4ts4RhiHK8N+aIPBQFuWrMus/s9sPiAWUY020BdvUCDz/bIqFgUu2rOd106DIrM/WJdOv/dSuMFEBpMbX/IyJtwzrZ8JLt0GUA2+WwtZNduZdfaPkSAqUsRpjQ8SLVtSiLwbIom8kZtku1UDPkTlGWNX2SPloG6rfRSodLNlqYQEStRy1Z7TlnIv1v89xcxtAj4nm/20+xvj4Zd2d8JWwgL5oQTdSK9Jot9nVvzfhIwZ3IiGCoGiZUHMJr2lAFYtbEb/MhwZ0gAbXVIA3G8mwQYZlWHZIyDpWSLF3aVSKWgeLXEghK2SK+Ykh43WMTEmegm2nAyurIkNDcsWMpukuVoJItNRLtuEXiwMOA/VUM3GqqhVi6qwlHDPMz6KZo0FIU9RL2M0ykpBgxF1ZUKEPZO0pNK90/dppTqMo9/XqFn1Wdl5rKZQKu/XDFQfOq24hE3x1KfjYKERAgmyLS0SVqxR1pPh3tkmvv6HoWAMxBDWaSVTDZcOcs9wqkR+D34iowssTLGNniImOHCRNmWKtzVtpWxF/gP8O5aURRKq9MMgyKbxs0EeFg58qbuN2x6Yjmltlo7z0UiPbMXKHEu8ixy7wJr7ViY4ulw1IPceG5aqZUbZPDtjZ/qxaXf9YTTOMv5RNO/VGom+UjBiP7kcYDMtqeKJLlXblfLRNRmjcWtcEcrbWELugdWfet/qOSRKYpRqDL35kmNXP9mXxuFcYwkFIJZ4KlKySQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(39860400002)(366004)(376002)(346002)(451199018)(31686004)(66946007)(82960400001)(36756003)(110136005)(2906002)(66556008)(76116006)(54906003)(19618925003)(38070700005)(5660300002)(8936002)(558084003)(66446008)(316002)(66476007)(71200400001)(91956017)(8676002)(64756008)(4326008)(41300700001)(478600001)(4270600006)(86362001)(186003)(6506007)(6512007)(31696002)(6486002)(38100700002)(122000001)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NmkzNDZBRFJ6OU1sdkFoQWlnNHdJOUM3dkQ3Q2tZd0VWWjhjMVZDc0UybEpW?=
 =?utf-8?B?dU9VRXdza2Y5SW5CTEg0TUJDV2NLRm9NYTllempKL1FjL1pHZ1lBU0l5eDRE?=
 =?utf-8?B?RVFHZFBlYU80RWpMWlJFK2piQ3huQStpMzhaWVlFZXV0RE5zU2xFQWpCa2tN?=
 =?utf-8?B?OEpTNjY2alNTZ1hnR2k2MXN6S2VJcWtYNXR3VitZaTkvY0VzZlZpbTRkTVND?=
 =?utf-8?B?U0owUTNoV1dBT080V09OYTFRYjlnOE05a0pxUUkzUlZuUnhpRFFWUm5WOWlz?=
 =?utf-8?B?c3RxME5MS3RtamFXSGlrYS8ydnRSUXJGNkNPTHAwTDRUc0RHbFFZejBzVGJI?=
 =?utf-8?B?bUpuUWh2SkNPVWlqNTJtTGZISENYb0ZwVkZnZE8zYUNnMUcxZm1lMzBRY3FO?=
 =?utf-8?B?TDBOa3c5ajljOEtGTUJHc3RMRmNXdjlDN1Z2TUgvU2g2cDNML0pRU29xT0Uw?=
 =?utf-8?B?RlhsZFRWS1ZKS0Fza2VQUC83dlkvczc3dG9wQWxIeE9adEJYREhUczQwV0Uy?=
 =?utf-8?B?aXBuUU1Namw3Um9JR29QUVFVNU1qQ1dFUVd6OVcwZjlrZHFQeExYMTVDYlFo?=
 =?utf-8?B?OHlqb1hkS1JZRXB5ZGZqMGo3V3lYSWxWMExRcEN4YnJKUmREdDFWb0NDdmxi?=
 =?utf-8?B?TG5yL2thNGFpbHNWc0l0NURlb2RXQjQxOTdHQ1crQUVFb09uOFpyQ01hbUlC?=
 =?utf-8?B?RDl6Qi9IbS9INmJkLzJiLzBQdW80YVVhcS96WEtCTjRsVzhCank4SVEyVGpt?=
 =?utf-8?B?SDdpbkZsN3JHK0dQUzAwYzB3UHBzWGVxUzA5dVdsSXNiazcvOW9SSEt3TmZO?=
 =?utf-8?B?RzVsNlk0S3RjRUVtY0JuTnJHcWhOcmNKa0hBek5FNHNxR1l5NS9BYWsyb2U0?=
 =?utf-8?B?Qy8wRFVsejZ3VzNoTjVZalhiZGhsV2phS2p4bjFNMlJwZjRvVWp4bDk1S2xM?=
 =?utf-8?B?aEJyeFBWbUdmcE9iMEdOYWh5VUdZSHE4Unp0NHRoWmFOSFVGZnpZUElreEcy?=
 =?utf-8?B?NnRtZTR2WmFQem5FSU1idUd1YW43SmlZaEUrWllyYTdveUt0N09VTVpnT0JS?=
 =?utf-8?B?anVzUHFhdWl2Sno5Zy96YWZUNEI4OHExb1JUcng3ZGFXRklPcDN6U251b1JV?=
 =?utf-8?B?ZmtRSWdsMlpaUjFmTlRVeGFrUXpYWDZnT3dORDYwQU5DUzd3S3F6ckN6R3Q1?=
 =?utf-8?B?d2Q0My9lWC9wNjFpbzM0OGExUUlMTUVNQ1lJUi93djQwY0svRW5ZanVXRlRU?=
 =?utf-8?B?ZDMvWEZkS2lPbzNaY05xV0NsN0puMUVJZ3M0cUljdUU3cjFQQ2lOVjU3Z3g5?=
 =?utf-8?B?Wi83TXo5dk5VdkJ3WHZnSUFZbHRYMEs3UDlybysyM283RVVWR1JmWmtLZnBH?=
 =?utf-8?B?RGRxdjMxay9NekFlemF2V2RDZTlNR3gza1dNVW0yT1ExK21PSUdFM1A3NkNR?=
 =?utf-8?B?L1lSZFppYitWOHZhRnBmR0o0L2xyZTZlZTNSZU9Eb0pEeWgzR2x3dXRjUzds?=
 =?utf-8?B?RktDcE5tdFNkclp1bDE5Qk5oTmlRYjZCb3pXUENVN2xkMkk3ZXNETjBxSmk4?=
 =?utf-8?B?L0F0VWNBVW9iMnJEMkNiaW9zamJEc21paFJhY3ZhNHd2ekNkN1UzOXFtaHpv?=
 =?utf-8?B?TW1kaDcvNk5KdU83am1nTHZyODBqUHFtaUxpSjI4b3hUK1c0WVVlcitTTHRF?=
 =?utf-8?B?MGgwVnpCeWpvRHdudVpWYk9hSURSWGxsaDBtOWMzMmU1UmlzMThZY2VEMGhz?=
 =?utf-8?B?TTZ3MERFZFRpQVhZYm5qOS9LYmlrOHFqUUFXYUJPa2xNeXZyTkhIMUczQ1Rs?=
 =?utf-8?B?YzRoVTJDbWt6NmJLU0phMGgxKzVDeHQ0ckF2Ti9xL1FNYVZwcGJCTWNYNG1D?=
 =?utf-8?B?MlI2RklPcTFNYmdPY0JCdENLNzJOSTRsRHNxMzdMcmFXYk5pbkhybldMeUpL?=
 =?utf-8?B?b3kxYUlGSlhmQjdiaGxQT1lqOFlLcHluRWxaR0V4MVFTZitFZ0N4QTBOTHFr?=
 =?utf-8?B?cHcyOUJYcXc2UjB0VjI2QlRuMEl1Y0xsKzhVcXBiaVVzT0JNL2FNOTB5RzFu?=
 =?utf-8?B?a21MakxmSzBSNWUxbEhkcndJaW5Cdldad1RZclg1SjhMTk1LWFVGWXZZdGsy?=
 =?utf-8?B?VzBXSVVZN015N0JEK3lvMXZ5ZUhEOE42TXRRR1VIU1VoUUh0Z2k0WStSOFZE?=
 =?utf-8?B?a0p6NjJwWEtUcC94WXNFZTFtb1pSNlpIeENFTk94K2dBcU1VNnVrZktPWVF6?=
 =?utf-8?Q?UVXnciWr2L56/roAN2ZEDScEQDltGJRdXlMAVkxpT0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1DDE3EC62478144387EF47AAE4AE2589@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: kC+MbxKnA16BX9wy9dovfAhtI6rziVyrzxnzkizb768HEfjNjsd59d26AeNa5dI/N2uJakqI9QK9OvKDHwxZVhSAqvBlzEKMewFbb1PyiuXxA42wunR6HI6FYSPT/Z5B0XZFRSYl/k1UxRIbL/5vGUPDhHY0Vt4rDwYhOWp8lKzwf30ecqPYaYHj4obasQ0ertb1rDa5/8EDwMb5/wcbJ/rBrqSs4UxTx8OQEUPXyY7lmVQoRqCbVZfIn5g3CSTrnryUsBXkfiK9Db9irf49uVxtLYY8IoplcGiFjwt7KXwioFN6R3TTap1nQLje+FFXxIxkmNYw2IvN+fuu3to6hzC9MXoSVN0Jkz6xCVXAMjwrVpWJ1NOFtDbAcYSqubUmsQ8iHaxszx8JETHOG0g1aQXvK+y9R1bklEjTb3zmK9BJEqJXJfFJ81jEnTcyI90zpTb87szOTfR0j53rAkB1mlQDNOu8Wn6KPrNu7rM6T2QZgWwZbsuMBr3VH2RKwYEBK1tvbwrARPnPkcG7kVjfW8iungf2uY8hs/veheTQ8TBkYAoQDudSuEcb8efEAXv7brySrTiirptdvdBW1SRDbAu3ug9xH5dnvbmH1R+XmXpi4yttHw119YsX7HuisyPAm8KEKhC245TEtUrBi3q0obh03Ym60oBXdVKMfGNB6Idkr7qVf4zMJQfUaBiqgYvXD2i8ShL0luqz6/7Q6BeLdq4wTztwWw71aSrqYlYmL57Kri7MpzxhLwcWn55xBYOM5wDSbDsUy/j1UetS+y8VIqx5tZK0TuWUxv33FYS6q5GJRvU2tNaVmOUTkw5MnIMi2GTVPih63dgnefBMUqSiX9BOj2/Wf+qDdqiSfV3IisY=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35124748-5c52-40f7-cdcd-08db10dd8528
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Feb 2023 11:53:01.0604
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2dAlDvyoZ0c84sKa3E6SiQX1/MnIyCDlV2+S+tXhEkoP2g46l+UL5alEQla4Njd0RTGOg0Wrrr7Xn/6TZJL12EL2QES6z7o0+WHppSb9Mtk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR04MB6451
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
