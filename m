Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B7134F47E1
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 01:44:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346674AbiDEVWg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 17:22:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1443719AbiDEPkM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 11:40:12 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B2A918501B;
        Tue,  5 Apr 2022 06:58:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1649167104; x=1680703104;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=FdhFYPmfgF3AosyvK2UN1G+ROB61XQxa4sgJO9kh3RA=;
  b=fCD1UOwMErFUX+HvDCxmhq+LNurY+VcYOJAFgIappW3ag49bOGDbk+Xj
   7Lehp1bI6UGY/JJ8snghNOVleqoprPuCeVUDnPgIyctmu0O0wBPzEbaKR
   Pqt+VjVksnBo/HaLWDlcVLjBF8VlmQ1jtwKKzm2L7v4PZt8m2Cs9J3DKP
   PUf6jKKJ/8P6M0DjyL9Oyhal6mT3bqPBZ8/KqK18qpTxUnT+rFbS8RrG8
   W1pjL6+uafKxMC8fxFDL+ZDrPRFbZjvrRCBvBx6OQMuj42ojf4+TaX+jz
   I7Zm9sxCdsHp3JQoSMUOqUrkLYJobd+8rR0CpAeHQZl3pxzfAhVzx/IbJ
   w==;
X-IronPort-AV: E=Sophos;i="5.90,236,1643698800"; 
   d="scan'208";a="91296809"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 05 Apr 2022 06:58:23 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 5 Apr 2022 06:58:23 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17 via Frontend
 Transport; Tue, 5 Apr 2022 06:58:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KfvS30YbJZt4LRAf/ZiTsumGqpVQXAazjmtiBMwlxnVyVedTmmeAC9q58dEaNG8+7PDUPKLFhfYroJSFZLsANlpTXB44h7sf1esGivT8xJ3T5XjqH7lO1LZ6PXaG1v1E7r8qXN+5pGaQC1yEIcwHWagI0z1th8lYzcltjyokjjX3xwEFq0JoYY9tXIkr+Lgy5m0tUtUUAqF671iVuvtHYv0+fdiyvPVKTYwMXeMmHgNr3OHGq52ktAk/plcJv6VQ5R1JOTlW4LMqvUACKw8oCyr+98wTTUOYoD7afhxSjU1UhhMs2JTHdjJF26N5r/+oqoa6xnRBabBhMr9k7j2oTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FdhFYPmfgF3AosyvK2UN1G+ROB61XQxa4sgJO9kh3RA=;
 b=cLS8iQWhMyA6P+cjD4jzLTuFn5d8h/Gv4LWOvANAeQDOR/IqQPrjn+aRLX1izoZmwhJNK/vPRBod82yBBNsjyyGLp94dh9CRny/TOeK5xBEqOEryluoN8Q3yrWpiaP33J81gw6F+Ha8iMcGmIpkHMQEUH6cNw8C3MBB8+fOYUppLGr9hR0/soEkMnVOsOpnI1cR7tmnFgqrTFGj3FOXIN8CCpyzNCcsCPE1We0t5ImVYAr+11aUhOizkXadBrfS8XTdeJO2U67FbTDJ2YXoHXnJffgggrab343EUxUr5cfSO5F6mMFxC78FdHaUka9fPzRZLNbys5bjHLboC58tTkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FdhFYPmfgF3AosyvK2UN1G+ROB61XQxa4sgJO9kh3RA=;
 b=CLgyzJTlXo5u+xjhLqsj0cddwshc4jnLb+qrGS0GDlle8TQ5Ie5UA9SpX0iiUTkF95njxbrpLRFu1vyC+I+BdeSC+F3EtD0SOO3gHSNLZUQDxI98LQZhsYQzsKJXxwkxNtZR54seqSzkOV5AOT58kN5IbiygziSVJq3tBG9V65E=
Received: from DM8PR11MB5687.namprd11.prod.outlook.com (2603:10b6:8:22::7) by
 PH7PR11MB5942.namprd11.prod.outlook.com (2603:10b6:510:13e::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5123.31; Tue, 5 Apr 2022 13:58:21 +0000
Received: from DM8PR11MB5687.namprd11.prod.outlook.com
 ([fe80::fc32:96a4:933f:194f]) by DM8PR11MB5687.namprd11.prod.outlook.com
 ([fe80::fc32:96a4:933f:194f%5]) with mapi id 15.20.5123.031; Tue, 5 Apr 2022
 13:58:21 +0000
From:   <Codrin.Ciubotariu@microchip.com>
To:     <michael@walle.cc>
CC:     <Nicolas.Ferre@microchip.com>, <alexandre.belloni@bootlin.com>,
        <Claudiu.Beznea@microchip.com>, <sumit.semwal@linaro.org>,
        <christian.koenig@amd.com>, <linux-i2c@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>,
        <linaro-mm-sig@lists.linaro.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH] i2c: at91: use dma safe buffers
Thread-Topic: [PATCH] i2c: at91: use dma safe buffers
Thread-Index: AQHYLxo2SrBDkK5iS0KDJl/Ehr5HqazhP32AgAAENQCAAAaigIAAEpYAgAAvSwA=
Date:   Tue, 5 Apr 2022 13:58:20 +0000
Message-ID: <74494dda-e0cd-aa73-7e58-e4359c1ba292@microchip.com>
References: <20220303161724.3324948-1-michael@walle.cc>
 <46e1be55-9377-75b7-634d-9eadbebc98d7@microchip.com>
 <bc32f1107786ebcbfb4952e1a6142304@walle.cc>
 <360914ee-594c-86bc-2436-aa863a67953a@microchip.com>
 <27f124c9adaf8a4fbdfb7a38456c4a2e@walle.cc>
In-Reply-To: <27f124c9adaf8a4fbdfb7a38456c4a2e@walle.cc>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d3e30fbc-d5d5-4c60-e700-08da170c580e
x-ms-traffictypediagnostic: PH7PR11MB5942:EE_
x-microsoft-antispam-prvs: <PH7PR11MB5942230CC46E6F2A3340D98DE7E49@PH7PR11MB5942.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Sgwe0au98jtnb9hu9RLGAQIRxYAUbpudwiDTMqFCcD+AVpo7adhOo20IHNl4vKcvtWIjcBMAMF3MVCePiMRdg1Q9kTJc2DhEgOy48p9OdGiS4GbeX5/Ox9cPkS760icwgaPWcvojoMHt888pjlzrdvC6fBoKL83KYrmL7CjvmqAw67dUN62TA6X2kDmpgobmOuKvKZ0KctwBCaGBaoSN348FsUteDSqdFI5JgHaClgELA7AN++Jii7rg4heqmPLUYbx9XImuzpf59GxjHZPqCJOqf9pwFKv7A7sekZYo3fqYCsyMrKEQ9sdiYDI0LG9UODgasXn49+Zg/MqSPRzSLOq+tF4oWzt/+ldn56YjmIDT6veVxzVb6dv5VHF/owOp2EhtGvAf8IUkLpWoX7F2mtogSw1GAyQWoEmVRqhGjmmMD6j+VmDeON7fRHBFG+Auf+o6MDOPJPPbuPYxDXC+9FVtg8vD58ukqLCHBQ2lPyPpKG0Vf9X3y+K6M887X773zlutZ+/7de+KUFGOIpAznHcROpxHqssEl6q3YshPBtcD6Z4KQ58M9NwtVhWfWCUmksizrLJKmXVg4TuYfIV8ftcoq725LNc9TwXM71QZPkJ+3pR/0fmF3s3AzbwxTiHalE+nnxLtJUofMIic56HzbD2gAM2hjeRBrunYMbxp5L9mKP36OuBgW4JnErKizYCTFJaMq4CGiYrvpj+AIr7md/dZpRYrUde3WziNnHB4zN+6i9Eb+Z7bROgK3LlUfo82gKpXxEtNZklv3BZU02lnpw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5687.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(508600001)(31686004)(76116006)(66946007)(36756003)(38070700005)(6506007)(7416002)(64756008)(66556008)(66476007)(66446008)(86362001)(6512007)(4326008)(91956017)(53546011)(8936002)(31696002)(8676002)(186003)(54906003)(2906002)(2616005)(38100700002)(122000001)(71200400001)(6486002)(5660300002)(316002)(6916009)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?R0tiQWVIWEprQmhzcUhLRENJY3lrQ0R3d3ppc215RDFucjBCTmJPTUlpc2xm?=
 =?utf-8?B?dzN5ZDRXTDYrUERFNm1CZ2ZjZW5nZHpSYTJrUERPK3E4U2ZUUGxMNWt4REcv?=
 =?utf-8?B?cU1qdGNDTXZHcHdUNnNRQjd4NWZwZ1hkdW16eENzYWpJc0E3TW5PbTEwRTMv?=
 =?utf-8?B?VXhCNWZMUVQ2dmJabUZUQU5oWml1OGtjQjJQMklhbWs5bWJudEt4WWtDTU1w?=
 =?utf-8?B?UXRMQThPejllNmF2N3owMU9iV1RaNGdGZjFsTUVnanhWc1VHU25sRGY5L0dH?=
 =?utf-8?B?WEpWNzcvVnc0dTFURytPR3E1M3NrdC9XalZldy9xbGlCenhCSjVsaEhvREZk?=
 =?utf-8?B?K0RHSFl6Y3JQYkVtTWpMcmJsS2Q3ZmNxbFV6aFlrMEYwT1F0SjN5akFmZzBP?=
 =?utf-8?B?UGpVa3EyNUJ6b3BuZkFhNWRtY3VUYi9RL0Jhb2F6KzNPVVpITjdwdnludDdM?=
 =?utf-8?B?NDJSZ1A0UUVsQmV4R1h0VktndVIvdmF2d2krdldEWGdScTZPSm1XOFhTVWU0?=
 =?utf-8?B?Z1BCTG1YYmllSFlXdWpjTVgwZmY2QVgrUmRKSS9wL0o3L3R6eW84MlpxQTY0?=
 =?utf-8?B?NVduN0hQM0hudzlJOGJlcDNRelVZVnlGdVhSMXpneWxpbGRqZlNLcmszdDcv?=
 =?utf-8?B?N3FnSlExd2hDdTRCQzNwOW1nNEh3K2oyTmFubVBKTG13RyszWWVQeDZHbE5m?=
 =?utf-8?B?RHlSTy9zaFBKSXlLUzZjVjUybkkvUTZBMjRuL0c2dHZvUjlxdU9sd08vUlV3?=
 =?utf-8?B?aHdrVWtHVE1jS3JWRXk5T1Y5alZKSGVKUjF2dHdkL3UvZjFleHE4SjFTakMz?=
 =?utf-8?B?U3FncXdHeDVWQW1RYXhhRWF3a054TDB1aVNITURoMmFzV1YwV1JCV1hvZ2dR?=
 =?utf-8?B?aU1TUGY5dzU5bGM3TXZ6U2tXai9Kck9iL2FSZ2YwVWJWVEVReDZQL0xMNnN3?=
 =?utf-8?B?Tkx3OXR3Vm5pU0U5QTJCL0lPTzJGajlPRlN5Z0gxMGdpNEpqNzlHYWtDVXlB?=
 =?utf-8?B?bTNlS09SRW15Nk50dGV4QUwwNmRaNnZYcElZUTR4ZnhxYzdYVmhaMnQxWVVh?=
 =?utf-8?B?NUVBblNTM0pkVVE3T0RSejFDeDAycWtpcUlIUFc1bjYyREU3dVc2L1F3Yk1L?=
 =?utf-8?B?MlE4eTlhVEZGUU16am9VcFQvUkJyMnJLd212UjNLZ2Jrb0V4SFBvNHB4ZUxM?=
 =?utf-8?B?WTlYZ2xOSTNGTTQyVjBnSHFLWXFGbDA1N29pMllQN0ZzTFhkUTZhYUVzV2k2?=
 =?utf-8?B?SVpXUEpwSVZXbWhmKzRONU4wbWVwbngwZ0prUnFaVXVJMU80QklSbjRvMFJn?=
 =?utf-8?B?cjlWTE5nUGR2M0p2cXhaZDdrSnE5NE00bUIvTFVzQmpYQnRDeWs2V2o0eHox?=
 =?utf-8?B?NTR2RXNPVHFjckk5QXBWcURZYk56Sy92dzRWb2wzU2pIZHNmUXFGWWk1ZC9E?=
 =?utf-8?B?ZzdUeXJhQThqKzBnUnJZODRLY1Vsamg5a3N5N1JpdW9TRTF6YVZEclNtckF2?=
 =?utf-8?B?OUhXc2d2Y2JCU1NuVnd2S3RRUTJQY3FxRFZIRm1jOWVKSWU4V2Q3dlJOdC9J?=
 =?utf-8?B?bm1tbjQ1d1JQMTAyMnJNekZ2aG00RVNGaE5MbWcxQVlZaUVwTmlialJHYUs2?=
 =?utf-8?B?R1NLWUg2MlBuMkFRZFRtRzFNanZnSXJiRkNTSVRvMCtyaFd5TmVxUkhnWnZs?=
 =?utf-8?B?VUZ6eGJhOGF1c2U3VU5mOUpPcCtQaEdoS3huMjltNXlIblRkVFBJTFZxbmpH?=
 =?utf-8?B?QkdnRXVvYVdkcFl5Wm9YU2xjUjdyQ3BsbE5ZSWVXc1k3Y0JKdnNQY21XTjFH?=
 =?utf-8?B?VitMNUlVYVFKdFJQMjRCR1BSUVBXdWNHenI0cUlKWDdxbElYUStXTFNidERa?=
 =?utf-8?B?RG9VM0lITEF4OERLaVBKMkUvNitLbEFESU1sVElSTDZpb3RnZzFuOVVSdjI1?=
 =?utf-8?B?ZC9VNU95M3VjbllYK3o1NTJEcEV5dG01Y1BFeGFSVXFUK0VKa2o0MjdRc2tV?=
 =?utf-8?B?cUJQa1RIUVkrNHFsWnl4d00yV21QbUhsc0ljZ0hydzRFbCtqUHJZaHRLaFFX?=
 =?utf-8?B?Tm9yaHpXcndiRjFadmlFMW1wbkptNFFTU20zbUc3WFRHYWlDZldUamh1K3U2?=
 =?utf-8?B?S1RjNlZKL0Z1K3RyRVArZi8yaFAxTnpnOEQ4QUJEU0ZJcmpiVEpJSmt5eDFp?=
 =?utf-8?B?a0J5ditaMjJIanEycXphQUFsRFRpblkzUjlia2RpVGdudTdEKzNiaFljUlAv?=
 =?utf-8?B?bGhvdlNPbVB3cjF3NlN5UnlOcm9TdVdaZFVhcUpoOVJRK3gvdEJwQjUxSlBT?=
 =?utf-8?B?VlVJSFMxYjdVN1JEVTZSeSsxUlFTUytTMFQzaHdnOGlQcldPU085bzB3Q211?=
 =?utf-8?Q?4lzIDAWheTNxWDMveevSgDIyo3VMvzSQ3UUZELe2+6L5o?=
x-ms-exchange-antispam-messagedata-1: ErDyzDcb4XUaqkyemq5Kc+6JhwF1BUk7Nw8=
Content-Type: text/plain; charset="utf-8"
Content-ID: <951C743CC6F63B40BAB01AA030614C5D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR11MB5687.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3e30fbc-d5d5-4c60-e700-08da170c580e
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Apr 2022 13:58:20.9983
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: w84DEoiuxpnKMDr+AwVojeyOi6ambexI62WrcYOVnsGtT29NiLrMnps6Rk2pAMEI3q8z20NSWNvtLz+z4TCd73OlvgJY2CDV/Rl3D5U8O1w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5942
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gMDUuMDQuMjAyMiAxNDowOSwgTWljaGFlbCBXYWxsZSB3cm90ZToNCj4gQW0gMjAyMi0wNC0w
NSAxMjowMiwgc2NocmllYiBDb2RyaW4uQ2l1Ym90YXJpdUBtaWNyb2NoaXAuY29tOg0KPj4gT24g
MDUuMDQuMjAyMiAxMjozOCwgTWljaGFlbCBXYWxsZSB3cm90ZToNCj4+PiBBbSAyMDIyLTA0LTA1
IDExOjIzLCBzY2hyaWViIENvZHJpbi5DaXVib3Rhcml1QG1pY3JvY2hpcC5jb206DQo+Pj4+PiAr
wqDCoMKgwqDCoMKgIGlmIChkZXYtPnVzZV9kbWEpIHsNCj4+Pj4+ICvCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgIGRtYV9idWYgPSBpMmNfZ2V0X2RtYV9zYWZlX21zZ19idWYobV9zdGFydCwg
MSk7DQo+Pj4+DQo+Pj4+IElmIHlvdSB3YW50LCB5b3UgY291bGQganVzdCBkZXYtPmJ1ZiA9IGky
Y19nZXRfZG1hX3NhZmUuLi4NCj4+Pg0KPj4+IEJ1dCB3aGVyZSBpcyB0aGUgZXJyb3IgaGFuZGxp
bmcgaW4gdGhhdCBjYXNlPyBkZXYtPmJ1ZiB3aWxsDQo+Pj4gYmUgTlVMTCwgd2hpY2ggaXMgZXZl
bnR1YWxseSBwYXNzZWQgdG8gZG1hX21hcF9zaW5nbGUoKS4NCj4+Pg0KPj4+IEFsc28sIEkgbmVl
ZCB0aGUgZG1hX2J1ZiBmb3IgdGhlIGkyY19wdXRfZG1hX3NhZmVfbXNnX2J1ZigpDQo+Pj4gY2Fs
bCBhbnl3YXksIGJlY2F1c2UgZGV2LT5idWYgd2lsbCBiZSBtb2RpZmllZCBkdXJpbmcNCj4+PiBw
cm9jZXNzaW5nLg0KPj4NCj4+IFlvdSBzdGlsbDoNCj4+IMKgwqDCoMKgwqAgaWYgKCFkZXYtPmJ1
Zikgew0KPj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcmV0ID0gLUVOT01FTTsNCj4+IMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGdvdG8gb3V0Ow0KPj4gwqDCoMKgwqDCoCB9DQo+Pg0K
Pj4gU28sIGF0OTFfZG9fdHdpX3RyYW5zZmVyKCkvZG1hX21hcF9zaW5nbGUoKSB3aWxsIG5vdCBi
ZSBjYWxsZWQuDQo+IA0KPiBBaGgsIEkgbWlzdW5kZXJzdG9vZCB5b3UuIFllcywgYnV0IGFzIEkg
c2FpZCwgSSBuZWVkIHRoZSBkbWFfYnVmDQo+IHRlbXBvcmFyeSB2YXJpYWJsZSBhbnl3YXksIGJl
Y2F1c2UgZGV2LT5idWYgaXMgbW9kaWZpZWQsIGVnLiBzZWUNCj4gYXQ5MV90d2lfcmVhZF9kYXRh
X2RtYV9jYWxsYmFjaygpLg0KYXQ5MV90d2lfcmVhZF9kYXRhX2RtYV9jYWxsYmFjaygpIGlzIGNh
bGxlZCBhcyBjYWxsYmFjayBpZiANCmRtYV9hc3luY19pc3N1ZV9wZW5kaW5nKGRtYS0+Y2hhbl9y
eCkgaXMgY2FsbGVkLiANCmRtYV9hc3luY19pc3N1ZV9wZW5kaW5nKGRtYS0+Y2hhbl9yeCkgaXMg
Y2FsbGVkIG9uIA0KYXQ5MV90d2lfcmVhZF9kYXRhX2RtYSgpLCB3aGljaCBpcyBjYWxsZWQgaW4g
YXQ5MV9kb190d2lfdHJhbnNmZXIoKSwgDQp3aGljaCB3ZSBkZWNpZGVkIGFib3ZlIHRvIHNraXAg
aW4gY2FzZSBvZiBlcnJvci4NCg==
