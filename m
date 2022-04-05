Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A9DA4F3A74
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 17:01:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381426AbiDELph (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:45:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354775AbiDEKPs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:15:48 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2668D6C912;
        Tue,  5 Apr 2022 03:02:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1649152961; x=1680688961;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=VORuvUcXD13ZliYbk8TG754YbpojIQPkDo32f0QO5UQ=;
  b=YsALiN4Tzy2atbgxlrfwgUphqDa25UriJFC8b/18GI0KnPSoaijab+94
   zWEiRFrJtZi0TNwKmS1JN8ei3ZEz+AJm7nAo2l9iCWjTui83+Vuv7Zz/0
   z2vu8siZmLI6fE9AELhKt5ubmNtEbrKU8pbAOi8EQI4it0DA2mJrZl5o8
   Sf+pRki/dHDsQgvqT7W17NPmVn8MgU+Bfc35WawOPt1r7ltgEoaaTY23c
   g/K/8cJcO7ZNfAN7ss8PcC6IYUbuF+zJFrJ5edkLoY7LRFSMPl0bmnmVb
   wLoZ2fZnEO9y86x5GaCZKWRv9E0ELXjhMMQjNtcN4WZgb0f0ABKDYajFd
   Q==;
X-IronPort-AV: E=Sophos;i="5.90,236,1643698800"; 
   d="scan'208";a="168391913"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 05 Apr 2022 03:02:41 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 5 Apr 2022 03:02:40 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17 via Frontend Transport; Tue, 5 Apr 2022 03:02:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GA/yWmYO57IPsZA4n0LwIoTFqrmxOLc6xDXUmB0XpdtiBfmtIdlo1MD0pIGo++/0W7LII0u6mEvOJFkzd2s67suRrH9a9DvphhadCtN65gMZR2ddvY2KSjjuWF8hTBv4sdDl8CQScObi8lsA3U8FZOzCaHGSz+9dfawEwIYvkPCUv+tVmoeYJKhyCc8F10GrV4dQhvERuoqOMqslVIqA+8YyD4o6vtMJ+UWMm/tcPa9AiVrXSWmoDF5f3yqSyjhGGIiYNS17t6Wq8TGtucpqObp/nQIbBqGvrizd0/WOy6c2DQA5GRcdlUtqZ8+dGDl5U2Y67iMrxOA2sRhW0kfq8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VORuvUcXD13ZliYbk8TG754YbpojIQPkDo32f0QO5UQ=;
 b=MP8EkgyzUaYPKlrXXkrAuaO3T4V59GIrooFGld4xPRLZszNGl1NfYMk+D3qXklUKIwwgtosGzwViadkbRdkHGTkzJsy7uNd5bfaY9lYDyS+aj1jcmjkHTfpZ2daRrFfFrV0Jg5U5SqE2u0D44c9DiCKLmaC/Ifat39FxcZrT6OLZTtqKUz0EOdppPUX7zGaQjmUAvU1BcLRzFR/JN7LQThur4mV1bBz1L7R10pm4J+Alamc4UED5O35a8EHNIxr94sMG/o6yFV02JDK/TV5RjQJScWTEg1EzcsHaKdJGBhM2/9TDapV9VCyaIrDPZCU2QTDiSBCBgW1dZBDnx4Arew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VORuvUcXD13ZliYbk8TG754YbpojIQPkDo32f0QO5UQ=;
 b=H+idqSJOFCLCe98skupnYCwDad2d7EO0FU6twGeWtxe2KIWFkgWRaL3Z32XlWqMbE3/MW9SmrQpwRVi109A6cBipYAxvOa1DteDksSqHHydNmkImgA6GiMoyD0g1pXDiJ0F6uz8BbZr2iDcqfTonxiEnLUlM+WzJB9tKHDLD23o=
Received: from DM8PR11MB5687.namprd11.prod.outlook.com (2603:10b6:8:22::7) by
 CH2PR11MB4230.namprd11.prod.outlook.com (2603:10b6:610:3b::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5123.31; Tue, 5 Apr 2022 10:02:34 +0000
Received: from DM8PR11MB5687.namprd11.prod.outlook.com
 ([fe80::fc32:96a4:933f:194f]) by DM8PR11MB5687.namprd11.prod.outlook.com
 ([fe80::fc32:96a4:933f:194f%5]) with mapi id 15.20.5123.031; Tue, 5 Apr 2022
 10:02:34 +0000
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
Thread-Index: AQHYLxo2SrBDkK5iS0KDJl/Ehr5HqazhP32AgAAENQCAAAaigA==
Date:   Tue, 5 Apr 2022 10:02:34 +0000
Message-ID: <360914ee-594c-86bc-2436-aa863a67953a@microchip.com>
References: <20220303161724.3324948-1-michael@walle.cc>
 <46e1be55-9377-75b7-634d-9eadbebc98d7@microchip.com>
 <bc32f1107786ebcbfb4952e1a6142304@walle.cc>
In-Reply-To: <bc32f1107786ebcbfb4952e1a6142304@walle.cc>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f00a1dad-ba4a-4984-8e16-08da16eb6806
x-ms-traffictypediagnostic: CH2PR11MB4230:EE_
x-microsoft-antispam-prvs: <CH2PR11MB423092DD7F3B1FEB99903643E7E49@CH2PR11MB4230.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KEk903fQEanIXPI1kUi5DgMSySDtM8eb7mCM11SXdRF3bhzvrte5hl6x5wVpGI8EWi63NmXZmFxs0KmtLh34B/Pvz7cKkhSD3fWLv8MPoaShj8byK8a1byjvdtaNNi9YVUz9pUp4qDhKePIcsxIJlXMWjH7BTOTNX0gf7lm9osnIYDMhrGrPeX8havraS8nXkr3110YpdT/HluhgJKhlq49T0B+WN6bF5Jz04rIfEcZdCiCf8qPf14eHdxvG7MpPtC6wYI4+HUE56ivPUroYSkejPNDbreva9Mb9vjVFJD4vh654eoiQvhMMZMvFecq/I9E0NyuzgJp6OcJF0u7n18Xbyp46kWFv2h2j6wasC0rp03vPOvnw3dSos0melf/hkRHIXNLaFrGvFfFIq+xyWiTR5Mo7HOnexny2DQiy/VABnM1rWLIuPSaXHOJROR00kskVTxbv+6IIOAkNZZHrqxZOTsRxvderCtGlYUo3mCOYxfMOLSqGZY6Dh4C2jH1jbhhCWD26uZ5ejZS1gx1uDYVZY5LgLjm3TltmDZGsynA/Xq74ExoniXF+yBF+cHjFdcFlTeYiqTNxU/D5iCLx/eBMhA6pdooiT+fxLl02rXqQ/MDprQi6a8pofrN8dyuTUY9RJXw6ymJtKrahBDTRuLymdxmwgnuji8RIo8QQvoBn0CAf/arQCXAhMuqAsS3BTNzxge+7iGY9vA7lyG6C54ryfQ/8IT8BPa8gMQ/c2z3uq+oCBR3dNPJmATRLrlG1thHnexIRGQ8EJe/xO1jFaw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5687.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(31696002)(4744005)(5660300002)(8936002)(6916009)(71200400001)(7416002)(316002)(2906002)(64756008)(66946007)(4326008)(6486002)(508600001)(2616005)(186003)(8676002)(66556008)(66476007)(66446008)(31686004)(38070700005)(91956017)(76116006)(86362001)(54906003)(6512007)(6506007)(122000001)(36756003)(38100700002)(53546011)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZVM4YzY4ZU5PcjRVS3lVSG1QR0hVMXQ2eDRpN3lZcDhVK0JDQ1hGU0dpamF3?=
 =?utf-8?B?OTlHTEdXZ0JkekdQTVczcit6SWhFK1NqRldKTFEvN3ZFbGVNM0NrNEc1eU1J?=
 =?utf-8?B?LzhibGVqNm90ZVBoVlJ2aUtzMk1vWEVHTEFyellTM2RDeEloRkpMZlJXeFl2?=
 =?utf-8?B?Z2RveU5seThCV1RUaWo4Skk2N3QrVmcrTDRCc1VPWWFLSVdxTHFmclMrZ095?=
 =?utf-8?B?VUZnTFc5SFdVSFBXYnprUnJBSWRtTmx1U1diMTVsRnVzbVgzQ2VPeUxwUVQ1?=
 =?utf-8?B?c0sxV0F2elZpbDZWOTY2cGYxV1JCaTdwT1Nza1NsQVJsdlZRWUdFRFhjWWl5?=
 =?utf-8?B?bWRlTHFISjZlck05bkR1MkdlYTZZWllkVXVKQmtacjNwcW9XNkxjQjZRRVVV?=
 =?utf-8?B?TllVTGRMejVDT1g0RVhkbmVqZ3BFV05XZ2M0RVhva1NrcDY5Qm9wNEtjUUJ6?=
 =?utf-8?B?VllWYURuaUpaZFByZFpzNUhUa3FqdWlDNnZNTktpblU0czhQRmIwQlc0SkNR?=
 =?utf-8?B?OThzTlVVZjFBd1NQTFpEd0Qrc0I4cDU0RG1Vd1dTTk9Mc3AxRDB1Yi9VSWNv?=
 =?utf-8?B?TjlDeE43d0Y3L3hyb0xnMWIvODlDVUpyZ21sRmxtdTlrSjVheEdOcWc1UjRB?=
 =?utf-8?B?SnhNS2lCV2pZdW4zMFlGbkhES3FiNTY5Q09rZkhzUlRHQmxHUGZPdVo3c1NY?=
 =?utf-8?B?dFcyQXQ5NmRUS0dad3JMcmF3VSt4dzJFTHNJdWRJQjZ1S1FWbVhWMHMzWEZy?=
 =?utf-8?B?Zll3RjRvRFdvdVNwOHFFRUtiVDRvcGtabnNWeWxndTFHRGI5bmFVQzh5K1Av?=
 =?utf-8?B?WnY4TnA2bExHaXI1KzdBT1pYYzIySjdsNXVBVTV1SW5QSm1MNTIzNlh6OFBR?=
 =?utf-8?B?TnZlZEtWNnM0MGZza21ONVRuZnAwV2c5UU9tSWRTSFliNHlIN01DSzJEV1FF?=
 =?utf-8?B?MWI0T3ZzTGFYSHlnOXFnYTRBa3FiRXJneHJmbU1XeVNFdHIvS1F3Q0xmc3Aw?=
 =?utf-8?B?ZURlTUFhSCtKclpEdEhRVGR2QUdqUHZEc2xoY2d5SmdldEs3U0I4MjZBRStE?=
 =?utf-8?B?SDFSc2xJYVo1ZzYycGl5TXEwbFRZQmRzMXhmQVJvS0hiMXd0SUtCUTJGUC9Z?=
 =?utf-8?B?Y08rZlNheXpON0U5Q3dDMUJ2cFFMTXVhTWsyTXhWekUrajZQMzI0WUVnNi90?=
 =?utf-8?B?TGxhWFJoaXNLa1JCN1VxRElKYzg4SVZqWjhEd1M3bGJTOFJUNEJFaXk3aUdu?=
 =?utf-8?B?ZGE5T1VwdDZ6TEhFSElUdyt6L09ZdWpxU2UyQzF5cjcvQklqZ0pxaTBFUlVv?=
 =?utf-8?B?TXEyTm5id0Izb3lSNGRTbGVGMWwyeFh0bUw3V05DTnRNcGl6bkdFZzlLWDhD?=
 =?utf-8?B?Mmh5MlV3amFDSWYwbWJNUzNvK2Q1REdLaER4M2N3aGt2cnpjZ1cza09OYWhw?=
 =?utf-8?B?SzdDZDRJVmpzdTQvQXdUV2FmVzQ3d24vUkIweVBNRkdCK2JrUDJsU2JKZmtu?=
 =?utf-8?B?TE9WSDlNWHBNeXozUlFzNjZnTFN5eXVYcDQ0NzhVbEhsbVB5L05pQWJFY0JH?=
 =?utf-8?B?Y1ZDd044Mmk4dWtmTHNYYklOUXJJcHNuQy9CMEZoZjltVDZTcUg0dEhzTUJs?=
 =?utf-8?B?Rk1FOG9sLzZqRGZlY3pUdWdSR2VQd3E4b2F6Mm9xWkRGVVVIR001dGdzU0c1?=
 =?utf-8?B?Mk41SGtuOHgyMHE4Rk5BZGVQc2ZzNWUrYXZWREsrc3FXY1ZFRnZtOHpMSjBh?=
 =?utf-8?B?cmh5Y0tUcFE1d3F5aEtwbmdZTTF1bWNWK2RsT0xIdDBNb3ZZOEt0Y3ZPUlV1?=
 =?utf-8?B?bE12dUxmZnJjUUp6dHEyYWUyZ2w4cUFKU3lNcHM4QjZSSCs5TmZSSGZkOEJ4?=
 =?utf-8?B?T3h6ckc2RytLTnpzdUlDeWpHd1I2cGExSWxVRi9YU3RVWWVKRFNFaVZiQ2RC?=
 =?utf-8?B?Qmsza05GYzIxcEFHV2JEM0EwUE9HdnpaTWZzc0QxK0pnWTlyUGtyRitRVjFP?=
 =?utf-8?B?Z25CR2s5VnVoUUErVDZOT2ROeld0TU4wSkcrbEpvbzhqU2tJUDBWRnArK2d4?=
 =?utf-8?B?RVBQaDR5NTZDbjZLOGVmd0RRZXlaTmY3NUt0dkpYeUFsL1JkeWF1TG81dlMr?=
 =?utf-8?B?cW5PUFdlWEFzUnhhSUV2NzA0aldwa0hQdndpS3d3dzhlQUhYTEFkZVIvL2F6?=
 =?utf-8?B?MTFOMW1OcEthUVRhbGVIc1FxRTAyRDMzaG1UMUFNdWM5R01qY1MycmRnN29u?=
 =?utf-8?B?c1NSZWNOVWdtSWM3RDhTdWppZW5oZ1h0RVczSVB6TC9oSS9lTmxqeFJOMFBV?=
 =?utf-8?B?S1VkYVFxZDliK0JwaFpLb2VyREUrYlFsR2pCcUtQZDRtS1FWUG03MTVSbmZK?=
 =?utf-8?Q?CL5Fa2xHIXxOn6BQ7zm2vDPXqtnR6ESPy7UIc0kJ5/QAW?=
x-ms-exchange-antispam-messagedata-1: LcfES7letNMbJQUvRNuWIA2rIvK1DQ3jM6c=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B00B091D7328594FBA60C3FAE36AA92E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR11MB5687.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f00a1dad-ba4a-4984-8e16-08da16eb6806
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Apr 2022 10:02:34.3794
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: h6YDl8U3CYsQD5074IwjnZo2t/f4XejexA2/EAwYTruzPJrg9YrWl56s+NxruLLC0jier2er6dOEnFESfqih17+Mc+GHNujSQUNMe9IVh6k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR11MB4230
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gMDUuMDQuMjAyMiAxMjozOCwgTWljaGFlbCBXYWxsZSB3cm90ZToNCj4gQW0gMjAyMi0wNC0w
NSAxMToyMywgc2NocmllYiBDb2RyaW4uQ2l1Ym90YXJpdUBtaWNyb2NoaXAuY29tOg0KPj4+ICvC
oMKgwqDCoMKgwqAgaWYgKGRldi0+dXNlX2RtYSkgew0KPj4+ICvCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgIGRtYV9idWYgPSBpMmNfZ2V0X2RtYV9zYWZlX21zZ19idWYobV9zdGFydCwgMSk7
DQo+Pg0KPj4gSWYgeW91IHdhbnQsIHlvdSBjb3VsZCBqdXN0IGRldi0+YnVmID0gaTJjX2dldF9k
bWFfc2FmZS4uLg0KPiANCj4gQnV0IHdoZXJlIGlzIHRoZSBlcnJvciBoYW5kbGluZyBpbiB0aGF0
IGNhc2U/IGRldi0+YnVmIHdpbGwNCj4gYmUgTlVMTCwgd2hpY2ggaXMgZXZlbnR1YWxseSBwYXNz
ZWQgdG8gZG1hX21hcF9zaW5nbGUoKS4NCj4gDQo+IEFsc28sIEkgbmVlZCB0aGUgZG1hX2J1ZiBm
b3IgdGhlIGkyY19wdXRfZG1hX3NhZmVfbXNnX2J1ZigpDQo+IGNhbGwgYW55d2F5LCBiZWNhdXNl
IGRldi0+YnVmIHdpbGwgYmUgbW9kaWZpZWQgZHVyaW5nDQo+IHByb2Nlc3NpbmcuDQoNCllvdSBz
dGlsbDoNCglpZiAoIWRldi0+YnVmKSB7DQoJCXJldCA9IC1FTk9NRU07DQoJCWdvdG8gb3V0Ow0K
CX0NCg0KU28sIGF0OTFfZG9fdHdpX3RyYW5zZmVyKCkvZG1hX21hcF9zaW5nbGUoKSB3aWxsIG5v
dCBiZSBjYWxsZWQuDQoNCkJlc3QgcmVnYXJkcywNCkNvZHJpbg0KDQo=
