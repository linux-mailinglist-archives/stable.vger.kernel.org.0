Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A8435F72AF
	for <lists+stable@lfdr.de>; Fri,  7 Oct 2022 04:12:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230498AbiJGCL7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Oct 2022 22:11:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231984AbiJGCL6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Oct 2022 22:11:58 -0400
Received: from mx0a-00230701.pphosted.com (mx0a-00230701.pphosted.com [148.163.156.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D582BB7EE0;
        Thu,  6 Oct 2022 19:11:55 -0700 (PDT)
Received: from pps.filterd (m0098571.ppops.net [127.0.0.1])
        by mx0a-00230701.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 296LDwBu029493;
        Thu, 6 Oct 2022 19:11:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfptdkimsnps;
 bh=qYBYDhAP/5RaP6xLE2mn7+tPWWKUkNmn4q39w8sclbY=;
 b=f9fiWBEh0ALno+eO9DNsikdxZmAkz4AJca+6ezfspp2r28aTp7NjxHOyRPm6AnoL6Iyr
 rIBt7Cj3qlk+Arep/PBMZorO+kVf05rzvnNYAX2lQF4s/LxQTO8ibyBjZuKjk5E9C5co
 nwyFZE8qI0TsRLcZPqhLxSFB9wgm57nfbU0DlyrfQoM2iY6l3aJ4BKzalml6eQJ3nIi7
 RXHUHt0Q2SSFKmn3Rdk42pYRshysgzqxiOjA0zxkd57eH/esUvOG4bMQl3RQQoERoxf3
 KwVJkw+i5lSs/TDz5rnk1msPeC4wW89j1jp6qPA1S4rIcy34EAIRbjPeQtHK7u+Iw82H Nw== 
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.87.133])
        by mx0a-00230701.pphosted.com (PPS) with ESMTPS id 3k1ykhv7uc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 06 Oct 2022 19:11:41 -0700
Received: from mailhost.synopsys.com (badc-mailhost3.synopsys.com [10.192.0.81])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id F1B21C0C56;
        Fri,  7 Oct 2022 02:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1665108701; bh=qYBYDhAP/5RaP6xLE2mn7+tPWWKUkNmn4q39w8sclbY=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=Q/u61XMYd6aUlv3pLdxATswcqqm/MQ7pV8NRALVC66IEFH5siJnWSZWXgaglC2y6V
         bD1HA5rLBOsnCdrO8KoJVE06YiXGrWAJYVPuTZUqjkaRqhSKGT28HwWGFfKL2B7r32
         6G9O04tNp9yjnS+ill48AS9ct9uTDxXsMk1Lg03ENUrsq9moo9C0lYvaV+YH0xsnKJ
         mvcE/kccnfQNExhZOaKrrwFpxrpLhltY+FuZw7nl9tmGMSQ9PPoufW28VcZPcrZGI7
         UAF+/+/byiLmGNu81RvSRUGclMaW6P0L3K1BJQoxBdPkOy31sWAr+6U/PrzlsLHllG
         lEimOV3H/KRJw==
Received: from o365relay-in.synopsys.com (sv2-o365relay3.synopsys.com [10.202.1.139])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "o365relay-in.synopsys.com", Issuer "Entrust Certification Authority - L1K" (verified OK))
        by mailhost.synopsys.com (Postfix) with ESMTPS id 1E0CBA0085;
        Fri,  7 Oct 2022 02:11:40 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2109.outbound.protection.outlook.com [104.47.55.109])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.protection.outlook.com", Issuer "DigiCert Cloud Services CA-1" (verified OK))
        by o365relay-in.synopsys.com (Postfix) with ESMTPS id 48E054006C;
        Fri,  7 Oct 2022 02:11:39 +0000 (UTC)
Authentication-Results: o365relay-in.synopsys.com; dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relay-in.synopsys.com; spf=pass smtp.mailfrom=thinhn@synopsys.com
Authentication-Results: o365relay-in.synopsys.com;
        dkim=pass (1024-bit key; unprotected) header.d=synopsys.com header.i=@synopsys.com header.b="kKCUNGEf";
        dkim-atps=neutral
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OHNAHQl2YS91sIwjr/Hi33ATE81wXsPg1pGaUYoyEX2u338gUSJguZCO00iA+z/d6QDanoXIMJSwoviSNUZz3yklNElPgacqMh8pGczy6O21LtImZwScTd0jpBWVgUhkRHAeSs3VEObKEG4IczqhUWw//eS65JVNw3oWgu/5QAx3E/G5EkhQGmIvOpqEH7hAkMwOYio2WPQtWHf+WrCUvdGA2fb7ocxMFD4oMMipMPiQVF6Aa2NiIn1gyTjogzb4ENyjhLZkpa2kgtzqKtCRo5MSZUXOAnueHbvHtn4qqPQLuXX/gf1IWnspsD0VNOtlVPhxMBwFseSgeY3WM2azWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qYBYDhAP/5RaP6xLE2mn7+tPWWKUkNmn4q39w8sclbY=;
 b=DbxXpAQAfp38T4qSHR7SeIiG5PZj5vjOZQtFGOfSShsEvAdUr91tDzG41St+8aK4dxiqOZVq0yvIqTcbvmO3RFLKxL+QI/iEZew16cjZWbMrmef0ftunGoRSGn5pHGQIkHJcx4d8MODvNrKYDP8poUtxw2ST3eLaz7J0sCApdFasAV2RVFQFIKKK/D4IVIqdBzcl4rAZYqlFcm76uo1CT5N08w8qpyfSL5QbFMFQYnrpKYg2JcBbL5l76oyOzUQz58nANMqoacxy6Jnf7rQ3rTsxdXhbGK9OITKgSRyhQzJlvHlTNxDYh65XG1UfQFUYmgUhzJegQx0rM8Hwm8YVBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qYBYDhAP/5RaP6xLE2mn7+tPWWKUkNmn4q39w8sclbY=;
 b=kKCUNGEfdZJRoHhldYt1Gauplb1gSGFGiuM+9310nOLVyqt/aeqLM1XIWEcMju+auS7Z5Wcz+SgZq0jzLPyIkHOljsCT8nmHDif9lvDeu7fg20TAHHVif0/sKe5wjEUL/Wgoo2Dj25K5Sf7jkqYqR/wrJnb5X1B3LEY2owgl70g=
Received: from BYAPR12MB4791.namprd12.prod.outlook.com (2603:10b6:a03:10a::12)
 by CY8PR12MB7243.namprd12.prod.outlook.com (2603:10b6:930:58::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.24; Fri, 7 Oct
 2022 02:11:37 +0000
Received: from BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::525b:92b6:eafc:8629]) by BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::525b:92b6:eafc:8629%7]) with mapi id 15.20.5676.031; Fri, 7 Oct 2022
 02:11:37 +0000
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
To:     Ferry Toth <fntoth@gmail.com>
CC:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrey Smirnov <andrew.smirnov@gmail.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] Revert "usb: dwc3: Don't switch OTG -> peripheral
 if extcon is present"
Thread-Topic: [PATCH v2 2/2] Revert "usb: dwc3: Don't switch OTG -> peripheral
 if extcon is present"
Thread-Index: AQHY0omsjm4tTlL0CEmkY916+rpAAK39QTUAgACwSgCAALRxgIAAdL8AgABe9QCAATNWAIAArDgAgADl6wA=
Date:   Fri, 7 Oct 2022 02:11:37 +0000
Message-ID: <20221007021122.nnwmqc6sq43e5xbn@synopsys.com>
References: <20220927155332.10762-1-andriy.shevchenko@linux.intel.com>
 <20220927155332.10762-3-andriy.shevchenko@linux.intel.com>
 <20221003215734.7l3cnb2zy57nrxkk@synopsys.com>
 <YzvusOI89ju9e5+0@smile.fi.intel.com>
 <a7724993-6c04-92c5-3a26-3aef6d29c9e3@gmail.com>
 <20221005021212.qwnbmq6p7t26c3a4@synopsys.com>
 <2886b82d-a1f6-d288-e8d1-edae54046b4f@gmail.com>
 <20221006021204.hz7iteao65dgsev6@synopsys.com>
 <d52cc102-6a4f-78e9-6176-b33e2813fd1d@gmail.com>
In-Reply-To: <d52cc102-6a4f-78e9-6176-b33e2813fd1d@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR12MB4791:EE_|CY8PR12MB7243:EE_
x-ms-office365-filtering-correlation-id: 41869a38-4942-4716-f28c-08daa80943f0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lVlYCy7kDDPZOHoNvCPcNiFjSPeJx0ZeWdJU76I1VdqqIExz0djIklATPjitiL9TYLLUqIq9AAj6i/eYrj3n9g27kD7CXE4xATQXh54hchGssGizPLd+IhvZyfDXHQdwbF4cdswCKXLWlGHsYep6qVUUNXAm74oX6NZbCu1tgmCivRaySOoA7WyL4OxF6UGjnrXRp6Y2IrPF/56piMpbIkNZofDTw03SR5PzWOHLByQNnWMpM0PoqmdAnzh8igLr3mM3RBoftl1KwrdbonVCdLmMNIZapGC5V3e/zcV/G/Az/pZEiNTflLaqA1JOWum6e+xiz15idFiBF8R/EydLOXFMgLThsertKA+lkciDfpNDH02rv7F3mr6etpfkYitVulDh366xc0rD03GXPXBgfk0YDGE8k5EDfsDoxf+nxScEwvwStgdU3+xe3M1Iqcysw9LFcz4XB5QX0+uvNdMA12g8OQ3EzNOYG5uS+YMdrQtyF+5wt5poDh0hxXIY5hnG+nwWqCxIRctPkVqSfu3ui09j9cZyAVkA5Vztl28pq4oXQ9paM2w15SyTLZTaWTlZjZTbJ5X57bgJc/ADsYh8K/pShV+sON/7PYI4jBh5LhxIcakDLxd1DQcr85OLg1U+MwjD6QpFR65roDf28MRAnoHSWvTXLkwBoeCs9D7OSdtHtB1lBUq/ZIu+BkPYve6b5MCmKwOF+7JTx3bMKlhE+1x1Z6al5FWrI/ceLs0G4nBZhNrAfRcEc4LwpQB73KM2eKM8vgQtwDolEttrqysRJg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4791.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(376002)(346002)(39860400002)(396003)(136003)(451199015)(478600001)(66946007)(4326008)(6486002)(66476007)(54906003)(64756008)(6916009)(66446008)(8676002)(66556008)(76116006)(41300700001)(122000001)(36756003)(6506007)(38100700002)(316002)(6512007)(83380400001)(26005)(53546011)(86362001)(38070700005)(8936002)(5660300002)(2906002)(1076003)(2616005)(186003)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?a2xEaCtjRmxLV1E3SVRRclJTZXZ5N1hvM1JJbDJQWm9YcDZEdGhRVmY5OCt1?=
 =?utf-8?B?Z0kvTWdYWW1GeDdlVWNGOTFJZ0pFZWdZSzdSZXB1L2hHL0F4MWNXUjI1R204?=
 =?utf-8?B?TWhmL281TUg4MnBMYk1OOXR1WVJ3V0FkV0I3QnV6aUxYYXd0RDJOWmZ1cHpx?=
 =?utf-8?B?MW0vYnZtWThkTklCRjRmQnpaRTVVMWgxTU9RUGFrMk1jN2JmcW1XaitwSkZN?=
 =?utf-8?B?Q0I2ZGJFMVZ0UVBFUGNJNkdoYkpXS3d0bzkzSExVSWVLdlJMODY3NHpVYjhR?=
 =?utf-8?B?a0xSbVRLTGRXUmFzV0tWbWs3TFpwNmJkNkNXclpRQUZaWWlRclNGVGNlWHdS?=
 =?utf-8?B?cTVIamlMR3BqcFhxSndhR2psUm5LRERxbnBTQi9ubzZzRHlMTUpINUVBdWFj?=
 =?utf-8?B?QWFYTWtLQ1JMbnpuWUxiNExacHFRT1pOZkNCb0JSZFBUV1laSHMwM0VNQ2da?=
 =?utf-8?B?VU5nQXRvSmNIZTRxMlpOQnhyUzJTR2NsRnJFOXdTMjR1cTYwVm41MERZVVJi?=
 =?utf-8?B?TElXWkhQbm9GNmlMYnY4dC9oaUxibzg2S05XTWIxUlhkc29jWnI3anNPeCtU?=
 =?utf-8?B?SmNTQWdiRnBHUkJWK0VRQUFYVGd1cHpCRE5ZZWtuZWlKWWpWSW9JelV0Ympa?=
 =?utf-8?B?WEtEUzVsZUVMNW5zTm9TNC9YcHN6Zi8vdUI5Z3d5cUxDNUVMK0VmT0c1RjY0?=
 =?utf-8?B?U3FhOGk4anZKTVROaW5oMkU2bEtvRnFNVEZ2d3oycEN1T3JCaHdXVDVHZlgz?=
 =?utf-8?B?Tzk2d1hpbk9rWE9XTHZlV1NlNHlzNE5lOVBUY1JGOU5PQXhMUDZoVExwU3hr?=
 =?utf-8?B?QThWcmNXNGh1a1NNUEdhZktyUE1vaHUvWmN0aFpnSnJ5K2NJMWVxbldQQmRV?=
 =?utf-8?B?VU5iQjlNUkVkdUEyM0VYakFnbTZmOVJ1NytMdVlLc05WNVNFZTdSeTErZFJ3?=
 =?utf-8?B?NGVQSUQwTFYyOGNDZDNXQ21yVXZObTBnUHk4UXhDK3d1S21zak40MkI4T3Zi?=
 =?utf-8?B?SlVWLzJpd2ludFEyN09UVnFKdVVpOTNxTjhQMWwrZ2VQOGVVTS9jZ0dUaFpi?=
 =?utf-8?B?bVpmcXpuczFyOUFIdHFsamNGM1Fqbmg2Y08yZzVaYmxRd1RYOVpKQ0FOak5B?=
 =?utf-8?B?QTlaQmtteUFPb0JhVnFXY1dWT0xrYkFhVlZHT2M2NXlIU29NeXF5WEh3UWQ0?=
 =?utf-8?B?TEZLSUlBVTE0dFhvUnJmTmJSRzBDTzA3YzV4Z0tjZFgvejJkYWNxM3g3em1W?=
 =?utf-8?B?TVBNeGNQY2xYK1B5ZDVwZi9sMTdCejQwYVoxY0VKY1hIWk5COFpDTzdVYW8y?=
 =?utf-8?B?b1BGOFNld3FvdDVpMkFidmJMK1VOSVRzaFphZGdyZDhUZmMyRTV4cGNwb08y?=
 =?utf-8?B?cjlRemZ6VGY3NnFxY29xSkJEblBxRFNNckhneFJaSm8rd0kxQ2RwRFNORGZ3?=
 =?utf-8?B?ZDJVY0IvV0lqbFJnQUMycGVmRWpxTkVqWkUwNHJUQjBvRy9jbStzc2lrMjF1?=
 =?utf-8?B?RnlYNDByZjJ6U0l6bitPMFhjTHdKdzBrTjhKcnpIZGE0c2htbkEra3ozUS9S?=
 =?utf-8?B?dDFQaHpiSG5PdzdUbVRsM3ZncE9UMEc3OEhzZk1tcVhkZnE2WkRGV0dmYm11?=
 =?utf-8?B?Z1d4MTFBMUJZM3FVQzVQVXBHeFd2NE94YXhxTWkvZFNnWk5ZSWVnc003OGto?=
 =?utf-8?B?QlpZZ21VZnpjZlhKZSt1eHpBMTB0SDF5WmlQZmd0cFI4V2Mxd0w4Ym11TWd2?=
 =?utf-8?B?RzZTYWQxaHM2SWJEb0l0aUlZZG50MVRFYXpSZVRNRGUyRW4rUDd6MnZMWUJF?=
 =?utf-8?B?eWlJZ3JqV0VxamFWeXQ5blhlbWY0ODJSb2plR2pNcEVvdjBpbWNVR1JubExU?=
 =?utf-8?B?UFczMmk1OWxSZTJYV0VHSXVJcmliU0Z1OTR5QkpXV0JVZ09aM2I3UEQ0UUE5?=
 =?utf-8?B?RGk3WFFHZjd1eXcxMXBma2hWUFo4QkNKa3ZjalQ3cGkvems0NGZVcmM2OEpp?=
 =?utf-8?B?K21HSXM4K0xWVFB3cHVlZXN2NnpnWFNwUDZoQU50UlVDUW84NklacXRJN0ZU?=
 =?utf-8?B?RnAxanVsNkhyZVY5cFYvVXR0OXpHUmVJR05pTW1nMnhaRDZZM3dtQzcxdWFt?=
 =?utf-8?Q?dXdrnei9knNt0xn8ZhLeOmbrX?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <02C024E7E1B76E4C80C9A4A1B1BEDF03@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?a3pxbVd0eUZmemhJV2JHaGpTOFIvdlZTWVZ5N29vZHlsOFpsQmYvYnpRVFFy?=
 =?utf-8?B?V3RmdXgwSVpKUnkybEp4UnUvM2lZVGlScjR1M3c2ekxhRXBkc2tGQVYyV3Fi?=
 =?utf-8?B?cnF1N3JVMVZBUFlBQ1lWbC90R3dTaEV1MWVMZ1ZoSmFjY3BBSlczZ1NxWUtl?=
 =?utf-8?B?eWcxTmJ5U0QzRE9wYnhDT0RmdCtWMmYwVStuS0hmdDlMMlUrR1dsekM0elJB?=
 =?utf-8?B?YTNxT21acllIZmk2NjJoVWg2a0kyMWdpaDNhR3R4dDlFK01QeUhBdk1kL0JO?=
 =?utf-8?B?V2NkVlZVQ2pPZW1OYmhhK21zVzhIdTZ5L3RVZmdtbnpLTzJUZmJuaUFLOXo5?=
 =?utf-8?B?eGtxaVBFK2tvZlYrUFVXekFBV2hiZDk1SEVKWjZJdFM4Z1JFOEpibkV6UWlT?=
 =?utf-8?B?WXZzZ0VOK3JXWUsvem5nSi9ZaW55STA4TlNoSjZGaUNRNUhmZTVjSFo3Wi9w?=
 =?utf-8?B?UXFGRG1HNHFKdXFMTlpDUm10akY1SzRHNCtGQlYrSGk5OHMrM01IcXNMUytu?=
 =?utf-8?B?bmY2RmJUaWZRcGR2NDZMc1ZDdGRVL1lVWEZnSTFDdFFvNGZTTHFtajFoY3By?=
 =?utf-8?B?NGxObVZHVU9VNEVLdkhNR2lMeUxwRjNQWUd5RmZkOEhMaHYvMlh1MVArZVls?=
 =?utf-8?B?V0h4Q0VlaXdRMHBadVN5eHlpWjlzQ3lDR0NWZWUvcVFvMlNyYllVbE5JTkkv?=
 =?utf-8?B?d205YkMweS9MdWsxbjEvcHREclF1M0tyRk5ONU9NQVFoYXVpa2FuODQvdjhV?=
 =?utf-8?B?TU5SVmNYZ1NHNWc1elk5a0UvVXpiSW1WTlJQRlYyQkZ2WDV5bWUwbkNwWU4x?=
 =?utf-8?B?Q2UwanFIVjVwdEdwK1IvR2tPV0FNU3NsMURBcmRkSG1VYVRabThUR0ZRb3NJ?=
 =?utf-8?B?VFNEVnp2TENweUpUNEFiWm90cndJU1JSVEZnbWRRTjNvSmY2Y3NhOStML1RD?=
 =?utf-8?B?MXVjMTc4RW95UGlzSDMxSkRiZ3B0VzM2NU1WUnV5SGdvRkVFN2xsODkzdy9x?=
 =?utf-8?B?cXRTL3NUUE1pSkFRaW9OSXFFcUgzL05pT1UzK1FheTBpZFNLR2t3azZvVVE1?=
 =?utf-8?B?bUQ3dkFpeGl5dk1zWGxROGtnNndTcEVuVjFJbzZraEVKdExpS2RHc3hHajNH?=
 =?utf-8?B?cHBRQjlZd01MdE9wNzlQbUtoMkE2VDZ3K3B4NUZuVmpjOWtSdi9BenVhbkE2?=
 =?utf-8?B?SGFhWjdNQnZRWis3YXlTVUhFek9vYWNzMjVHdjAyZUVjdGJldVd4THRkU2Rq?=
 =?utf-8?B?MGlsdGhpZWgzYzZaREY0TWlRaVlZNUtwUFZqd244MVRSR285MnppQ20zSFRX?=
 =?utf-8?B?ckwvdU83WUx6QS9yMGZqeVpwNENWU0tydkdXNm4wc0FJNnIwbTJvS0svSTdP?=
 =?utf-8?B?NGthRk1WS245MDBwM2J1ZWtPdno0bzcvaWJBZ0lraE55aGJ3QlFNU3NmTnFw?=
 =?utf-8?Q?xGV01uYf?=
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4791.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41869a38-4942-4716-f28c-08daa80943f0
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Oct 2022 02:11:37.4226
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JziEmDU912qAfiZpPe0lygdwwUA3VnjNZldl1n4AqpyrhKLC+dFMDg+T8E6ckbf0agHAf1aFbzMD0rdQeFA+TA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7243
X-Proofpoint-GUID: 4HgtG-IyB10BUjLr80GXYBUOYlQIPC2i
X-Proofpoint-ORIG-GUID: 4HgtG-IyB10BUjLr80GXYBUOYlQIPC2i
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-06_05,2022-10-06_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_active_cloned_notspam policy=outbound_active_cloned score=0
 bulkscore=0 clxscore=1015 phishscore=0 adultscore=0 malwarescore=0
 impostorscore=0 lowpriorityscore=0 spamscore=0 priorityscore=1501
 mlxscore=0 mlxlogscore=594 suspectscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210070012
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gVGh1LCBPY3QgMDYsIDIwMjIsIEZlcnJ5IFRvdGggd3JvdGU6DQo+IEhpDQo+IA0KPiBPbiAw
Ni0xMC0yMDIyIDA0OjEyLCBUaGluaCBOZ3V5ZW4gd3JvdGU6DQo+ID4gT24gV2VkLCBPY3QgMDUs
IDIwMjIsIEZlcnJ5IFRvdGggd3JvdGU6DQo+ID4gPiBIaSwNCj4gPiA+IA0KPiA+ID4gICAgICBU
aGFua3MhDQo+ID4gPiANCj4gPiA+ICAgICAgRG9lcyB0aGUgZmFpbHVyZSBvbmx5IGhhcHBlbiB0
aGUgZmlyc3QgdGltZSBob3N0IGlzIGluaXRpYWxpemVkPyBPciBjYW4NCj4gPiA+ICAgICAgaXQg
cmVjb3ZlciBhZnRlciBzd2l0Y2hpbmcgdG8gZGV2aWNlIHRoZW4gYmFjayB0byBob3N0IG1vZGU/
DQo+ID4gPiANCj4gPiA+IEkgY2FuIHN3aXRjaCBiYWNrIGFuZCBmb3J0aCBhbmQgZGV2aWNlIG1v
ZGUgd29ya3MgZWFjaCB0aW1lLCBob3N0IG1vZGUgcmVtYWlucw0KPiA+ID4gZGVhZC4NCj4gPiBP
ay4NCj4gPiANCj4gPiA+ICAgICAgUHJvYmFibHkgdGhlIGZhaWx1cmUgaGFwcGVucyBpZiBzb21l
IHN0ZXAocykgaW4gZHdjM19jb3JlX2luaXQoKSBoYXNuJ3QNCj4gPiA+ICAgICAgY29tcGxldGVk
Lg0KPiA+ID4gDQo+ID4gPiAgICAgIHR1c2IxMjEwIGlzIGEgcGh5IGRyaXZlciByaWdodD8gVGhl
IGlzc3VlIGlzIHByb2JhYmx5IGJlY2F1c2Ugd2UgZGlkbid0DQo+ID4gPiAgICAgIGluaXRpYWxp
emUgdGhlIHBoeSB5ZXQuIFNvLCBJIHN1c3BlY3QgcGxhY2luZyBkd2MzX2dldF9leHRjb24oKSBh
ZnRlcg0KPiA+ID4gICAgICBpbml0aWFsaXppbmcgdGhlIHBoeSB3aWxsIHByb2JhYmx5IHNvbHZl
IHRoZSBkZXBlbmRlbmN5IHByb2JsZW0uDQo+ID4gPiANCj4gPiA+ICAgICAgWW91IGNhbiB0cnkg
c29tZXRoaW5nIGZvciB5b3Vyc2VsZiBvciBJIGNhbiBwcm92aWRlIHNvbWV0aGluZyB0byB0ZXN0
DQo+ID4gPiAgICAgIGxhdGVyIGlmIHlvdSBkb24ndCBtaW5kIChtYXliZSBuZXh0IHdlZWsgaWYg
aXQncyBvaykuDQo+ID4gPiANCj4gPiA+IFllcywgdGhlIGNvZGUgbW92ZSBJIG1lbnRpb25lZCBh
Ym92ZSAibW92ZXMgZHdjM19nZXRfZXh0Y29uKCkgdW50aWwgYWZ0ZXINCj4gPiA+IGR3YzNfY29y
ZV9pbml0KCkgYnV0IGp1c3QgYmVmb3JlIGR3YzNfY29yZV9pbml0X21vZGUoKS4gQUZBSVUgaW5p
dGlhbGx5DQo+ID4gPiBkd2MzX2dldF9leHRjb24oKSB3YXMgY2FsbGVkIGZyb20gd2l0aGluIGR3
YzNfY29yZV9pbml0X21vZGUoKSBidXQgb25seSBmb3INCj4gPiA+IGNhc2UgVVNCX0RSX01PREVf
T1RHLiBTbyB3aXRoIHRoaXMgY2hhbmdlIG9yZGVyIG9mIGV2ZW50cyBpcyBtb3JlIG9yIGxlc3MN
Cj4gPiA+IHVuY2hhbmdlZCIgc29sdmVzIHRoZSBpc3N1ZS4NCj4gPiA+IA0KPiA+IEkgc2F3IHRo
ZSBleHBlcmltZW50IHlvdSBkaWQgZnJvbSB0aGUgbGluayB5b3UgcHJvdmlkZWQuIFdlIHdhbnQg
dG8gYWxzbw0KPiA+IGNvbmZpcm0gZXhhY3RseSB3aGljaCBzdGVwIGluIGR3YzNfY29yZV9pbml0
KCkgd2FzIG5lZWRlZC4NCj4gDQo+IE9rLiBJIGZpcnN0IHRyaWVkIHRoZSBjb2RlIG1vdmUgc3Vn
Z2VzdGVkIGJ5IEFuZHJleSAoZGlkbid0IHdvcmspLiBUaGVuDQo+IGFmdGVyIHJlYWRpbmcgdGhl
IGFjdHVhbCBjb2RlIEkgbW92ZWQgYSBiaXQgZnVydGhlci4NCj4gDQo+IFRoaXMgbW92ZSB3YXMg
b24gdG9wIG9mIC1yYzYgd2l0aG91dCBhbnkgcmV2ZXJ0cy4gSSBkaWQgbm90IG1ha2UgYWRkaXRp
b25hbA0KPiBjaGFuZ2VzIHRvIGR3YzNfY29yZV9pbml0KCkNCj4gDQo+IFNvIGN1cnJlbnQgdjYu
MCBoYXM6IGR3YzNfZ2V0X2V4dGNvbiAtIGR3YzNfZ2V0X2RyX21vZGUgLSAuLi4gLQ0KPiBkd2Mz
X2NvcmVfaW5pdCAtIC4uIC0gZHdjM19jb3JlX2luaXRfbW9kZSAobm90IHdvcmtpbmcpDQo+IA0K
PiBJIGNoYW5nZWQgdG86IGR3YzNfZ2V0X2RyX21vZGUgLSBkd2MzX2dldF9leHRjb24gLSAuLiAt
IGR3YzNfY29yZV9pbml0IC0gLi4NCj4gLSBkd2MzX2NvcmVfaW5pdF9tb2RlIChubyBjaGFuZ2Up
DQo+IA0KPiBUaGVuIHRvOiBkd2MzX2dldF9kcl9tb2RlIC0gLi4gLSBkd2MzX2NvcmVfaW5pdCAt
IC4uIC0gZHdjM19nZXRfZXh0Y29uIC0NCj4gZHdjM19jb3JlX2luaXRfbW9kZSAod29ya3MpDQo+
IA0KPiAuLiBhcmUgd2hhdCBJIGJlbGlldmUgZm9yIHRoaXMgaXNzdWUgaXJyZWxldmFudCBjYWxs
cyB0bw0KPiBkd2MzX2FsbG9jX3NjcmF0Y2hfYnVmZmVycywgZHdjM19jaGVja19wYXJhbXMgYW5k
IGR3YzNfZGVidWdmc19pbml0Lg0KPiANCg0KUmlnaHQuIFRoYW5rcyBmb3IgbmFycm93aW5nIGl0
IGRvd24uIFRoZXJlIGFyZSBzdGlsbCBtYW55IHN0ZXBzIGluDQpkd2MzX2NvcmVfaW5pdCgpLiBX
ZSBoYXZlIHNvbWUgc3VzcGljaW9uLCBidXQgd2Ugc3RpbGwgaGF2ZW4ndCBjb25maXJtZWQNCnRo
ZSBleGFjdCBjYXVzZSBvZiB0aGUgZmFpbHVyZS4gV2UgY2FuIHdyaXRlIGEgcHJvcGVyIHBhdGNo
IG9uY2Ugd2Uga25vdw0KdGhlIHJlYXNvbi4NCg0KVGhhbmtzLA0KVGhpbmg=
