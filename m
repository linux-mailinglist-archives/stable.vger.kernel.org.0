Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D64A2605020
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 21:09:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbiJSTJI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 15:09:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbiJSTJH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 15:09:07 -0400
Received: from mx0a-00230701.pphosted.com (mx0a-00230701.pphosted.com [148.163.156.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80EC01ACABF;
        Wed, 19 Oct 2022 12:09:05 -0700 (PDT)
Received: from pps.filterd (m0297266.ppops.net [127.0.0.1])
        by mx0a-00230701.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29JGisNT010578;
        Wed, 19 Oct 2022 12:08:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfptdkimsnps;
 bh=SfdbjaSt+3ABn0z6ozznMHPPtbs5P4DHetZPOcXS6Eo=;
 b=vuFSBdpeXh6zwtIKxUSv5ynA7aAPlgFffPoATlGiM7pLgsDnU21Bb++fI2BSTgMTqczC
 tBpkUGhoE+YEE7is0TC/+hCEP2Nh5H+Go+TAKMio7hHJgQGeovu90zWrbRTRJn/HX/7D
 1wzX0Y/7OpVRrtUvd2cwDQcYv7W1zMb5T+C6QoIiI38c2avG62N3ujHPaltgyNM2b209
 D7zN6GxiD1K6+MNMoTzK1ya4RsXmE/ZSIPsLd9H/kSFI1rh7EajNvnAZeDhoUn0QQdHd
 tvDuPT6hUkIMuVr7TFlhFkl6h+nv2IoSDYHb2jeROOibKTAYAB3Qgdd+QlrZAR/yTGSC Wg== 
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.87.133])
        by mx0a-00230701.pphosted.com (PPS) with ESMTPS id 3k7v45je31-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Oct 2022 12:08:37 -0700
Received: from mailhost.synopsys.com (badc-mailhost1.synopsys.com [10.192.0.17])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 56EFDC00FA;
        Wed, 19 Oct 2022 19:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1666206517; bh=SfdbjaSt+3ABn0z6ozznMHPPtbs5P4DHetZPOcXS6Eo=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=FhSNBWh91t4Dpe1n7gH3TH02e5JCr0DJUS6M4TdbIogEF3m552q9zkj5Jq60PYZQz
         ev9wZOgzw5hj05uxL7ay9W0ngJV1uCpo9B9yzLuhZD5+APfwPDWHzVhGWu4lHxmKcX
         Tunfiw2aOioK0NkMw2AV1ZBnwRXr9JE2eZJl7QoXCcoWio8ZuEaN0C7JeJ3w7qkRJd
         T4ZfIEkwXA4/lxNcqqgy52Fkbee7uwzrwRO1O4mUueDooTaM9sT1s9kkgcXxUsAJor
         hg9HWZ2TjTJlwesNVa0amA2hcgiq2HN9wFwn3/rZtBM4GmoGdY08rNVNUJX+45zQgp
         ORwJoyLj9i08g==
Received: from o365relay-in.synopsys.com (us03-o365relay1.synopsys.com [10.4.161.137])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "o365relay-in.synopsys.com", Issuer "Entrust Certification Authority - L1K" (verified OK))
        by mailhost.synopsys.com (Postfix) with ESMTPS id BD40AA00CB;
        Wed, 19 Oct 2022 19:08:32 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.protection.outlook.com", Issuer "DigiCert Cloud Services CA-1" (verified OK))
        by o365relay-in.synopsys.com (Postfix) with ESMTPS id C47F180083;
        Wed, 19 Oct 2022 19:08:30 +0000 (UTC)
Authentication-Results: o365relay-in.synopsys.com; dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relay-in.synopsys.com; spf=pass smtp.mailfrom=thinhn@synopsys.com
Authentication-Results: o365relay-in.synopsys.com;
        dkim=pass (1024-bit key; unprotected) header.d=synopsys.com header.i=@synopsys.com header.b="G7awUt1P";
        dkim-atps=neutral
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AKAP+Ac3GbEMjsm7zwyJIo6kCpX+c4MDhdfi6qymq8OLGBn/hQ7g4++rcy7fnLho/sY7Tj0Sw7GRpJBsh3Aa75J/ZdZMaOuy2QVLS5gV9OnkjOpk7b/zORBTd2pYl9z7Fg01ZZXOlGxZ+11Sv/MUAvLJOOHPrrw7BS8O5aBa1bMjHZssxtqg4nbo3D+rjzGox+b8gzPoxs4Ylu/81bFXMm+2MAur1uWgWrMVt72JaCoXxU5+BXJN65RCII9NR+1nyMGNYIE3qkKdP0zlWe74R2+JkFh9FNDVmwjNZ89p5LzYMbXgCg3lhUuOJuUjIeqmw+bo89INu4MoV4s/WEKrwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SfdbjaSt+3ABn0z6ozznMHPPtbs5P4DHetZPOcXS6Eo=;
 b=ktvJNNvzqcxHWogyorxMZhmiTuR34Iqnch2Rf86AJGWdfLAoLPuN8PpHDfmBjqzBmhj/90H69OVx4/Fs0Be+zeaPwA9lqeQFnpb+5uGFxF3bGaAtuW9G2nZYRG9DD1VhkhcwBCj4ETspgoNnHuhJYJo/mZiGyobFt9golLyNR9kKqfsvaypGpq/PMUDu4392gXX0ZzAKYV3JZTK54l+kDhQiDUjK01tLg/4jEDlgoEsYJhg8KZQNnq++QxyFVCZvYygpUXaKRt4ZV8uO0tgcAeNMAqEVdb2FGeRAbe5bUenvaX3RTfy9HTQ8SfepG5BaC79rj+jVMN2sxlzfP9KQng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SfdbjaSt+3ABn0z6ozznMHPPtbs5P4DHetZPOcXS6Eo=;
 b=G7awUt1PX15yVcNMukFNVM6qUm3SUEL8S4iYEg0XyYJdxdTI3bvtdx2biqiQwwGFzivSbVaPshyyBWKCGjly55K5seOOzsI/m0podOtY52a4EOW1Wdq7F/cN2BcSysxs6WGJb7v+x8RFHRtqgZZVyHAkjvS9jDW2hegZcM+fv54=
Received: from BYAPR12MB4791.namprd12.prod.outlook.com (2603:10b6:a03:10a::12)
 by IA1PR12MB6161.namprd12.prod.outlook.com (2603:10b6:208:3eb::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.34; Wed, 19 Oct
 2022 19:08:27 +0000
Received: from BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::525b:92b6:eafc:8629]) by BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::525b:92b6:eafc:8629%7]) with mapi id 15.20.5676.031; Wed, 19 Oct 2022
 19:08:27 +0000
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
To:     Jeff Vanhoof <jdv1029@gmail.com>
CC:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Jeffrey Vanhoof <jvanhoof@motorola.com>,
        "balbi@kernel.org" <balbi@kernel.org>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "dan.scally@ideasonboard.com" <dan.scally@ideasonboard.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "laurent.pinchart@ideasonboard.com" 
        <laurent.pinchart@ideasonboard.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "m.grzeschik@pengutronix.de" <m.grzeschik@pengutronix.de>,
        "paul.elder@ideasonboard.com" <paul.elder@ideasonboard.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Dan Vacura <W36195@motorola.com>
Subject: Re: [PATCH v3 2/6] usb: dwc3: gadget: cancel requests instead of
 release after missed isoc
Thread-Topic: [PATCH v3 2/6] usb: dwc3: gadget: cancel requests instead of
 release after missed isoc
Thread-Index: AQHY4zLbXRUpqdOqTUOotJbe2PZC1K4UvWqAgAAz6gCAAAYCAIAAXncAgADAGYA=
Date:   Wed, 19 Oct 2022 19:08:27 +0000
Message-ID: <20221019190819.m35ai5fm3g5qpgqj@synopsys.com>
References: <PUZPR03MB613101A170B0034F55401121A1289@PUZPR03MB6131.apcprd03.prod.outlook.com>
 <20221018223521.ytiwqsxmxoen5iyt@synopsys.com>
 <20221019014108.GA5732@qjv001-XeonWs>
 <20221019020240.exujmo7uvae4xfdi@synopsys.com>
 <20221019074043.GA19727@qjv001-XeonWs>
In-Reply-To: <20221019074043.GA19727@qjv001-XeonWs>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR12MB4791:EE_|IA1PR12MB6161:EE_
x-ms-office365-filtering-correlation-id: c74d6ba8-425f-4b96-dab4-08dab2054d9f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ypoOUNGrab2Pg0NexnFRJrBorvwAW01F84S3NdUFY20lEg75UdJdSg4nV+XZTxnt7ioHDekB2xzXH+hbqxi4Cd0U8UQ/iHZ2UtkmoR5SYfTBLI5boh0kMzsbXJoSJXNux8thxLdtgNtbnl+82hKhTM8Fwg+voPYDHzYqDlBymfAiJcSOef/k91K1TZwkrJxYDvtbglO6yQvhiizfqVNIK5onzpMppLzUdfbo9NYdh3Tf+rcgWQakGi5i9k4MVedX1RA/aX7ncbNdc9cVYC2dz8rppGRolTbA19/otAFHooIX8o8I44rr7X7kjOe6lvnvOkndVhBpNUco3X7ARVtH1L6NxDVIYQuYQFs8OgYIxr/nb6W+YaFtObAyknMl8o89+E6jTJCP1igzw3XhcNZw1w6m7c67fejOekBIcTvvRW9iFNhOR6nOOTA2lZG6b3tTbEPA3SGdr/2Ed29lGdoMA4AdFvpUHyrf8kVEcd/VeslvsOvEh+aEHwUmLfFwY1TXB6THL3YEYg3dTQxnuRQEJowdvMLCvSRVM72y99RsXLI/dvry5GAHC9CU91uEweFbKDQk8zOPYPfPMFXQQq7ARLPCMi5WYx33fXvMcvC9Zvq4rdqtIj5Kgg7EtDUTvtRnEPSabQKf34fGFChFqPBh2abkd3Juz55M9j6dp1IcD7uQQrZXVDXeBAxKo4z+Qsj54dpEMnNx2HaLjgoNe5cOqRr7wg+tA6en4yry7oQ8KdcIvBIRCpaKnpDZKrrptmG4Db1XDCsK4FK0stDCaz1ALHU7cBLXXP5+AUWjeqdc4XE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4791.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(346002)(376002)(366004)(39860400002)(396003)(451199015)(1076003)(186003)(2906002)(83380400001)(316002)(6916009)(54906003)(2616005)(41300700001)(6506007)(8936002)(36756003)(26005)(5660300002)(6512007)(122000001)(7416002)(30864003)(86362001)(64756008)(66446008)(66476007)(66556008)(66946007)(76116006)(8676002)(38070700005)(4326008)(966005)(6486002)(71200400001)(38100700002)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bjFQVGE4a2JUYXRxNEYra3h2ZEczcFB2dE5LRVZXRytScjZRVnpnTHlrVUt0?=
 =?utf-8?B?Wm9QdDhzRkp5V2xCcXI4ekJONE13QkVIRm94K2xqbWJzMUoxQkRhSGZiRlBh?=
 =?utf-8?B?OTkvYUdmZ0tPL3VYTFAvYzdVNGd3bWFUL0FQYVZmL3lkYTg5aUxhbWZ1YTBx?=
 =?utf-8?B?K3ZmSWl3cFI4OXB4UlAzREY1WGYrZ1NjNGhvOEcrZSsxY0cxcmp0NWJRbHd5?=
 =?utf-8?B?b2g3cGxtS3dLV1FxaEdhcUFYVE1DcENBd01BUWVKdUVEWGFaQXVLalZGK21p?=
 =?utf-8?B?UHZINkJGNWovVVB1SWFabUxhbEsrQUJ2eWFMSG8zV2lKbHZmUFozU3M3MGNy?=
 =?utf-8?B?M3NocmczODBFdVBGaWdyVFcyZmt1a0wvd2ZGZXBkU3JWN25xbXRjbHJmeDBh?=
 =?utf-8?B?VG5zTy8wdFhpd0FQVFJuYlQ3eXNSSWcrUjhhZkhBb1JPWmxtcmtaeTErSnJv?=
 =?utf-8?B?anVEQkxYZDBXNXJkNUgxTVhLaXVPc2ZqUDBzNis1M1pJc2dwN0tteUVNSS85?=
 =?utf-8?B?KzZYSnM3MXRIc0RLVHNnVTI0cnNGWnljMWpoSW9HWWdNMGhEVjJpRG5ZcThs?=
 =?utf-8?B?b0NISFR2QVYyYjE2MjczU1lmeFVPeHJFSkUxeXRIUlRwUDlJSUtzL1RhT0FH?=
 =?utf-8?B?NUJ5TDRHUW9MU2t0dUsyVFhHYVlueHJVbDZSeHZ2aGMyWHNsb0x3cXB2Yi9m?=
 =?utf-8?B?cWhGcmllT2p6UEIzWUVmRnE2amc5NDcxb2syVU1GVzhobnB6Um9GeWJEOFcx?=
 =?utf-8?B?QTR5TWlRd3R1d2dBKzVWWHFMTzJZY1BCbi9GMGk2eG40VGtrY0JlcitMV2s5?=
 =?utf-8?B?NVdZZVk0ODdGbmdYMXpoLzlHQVczTDgvSTBzZGxYMWJoakZXSCs0RDQvN3Qv?=
 =?utf-8?B?dG5JYjRLUmo1QTdyQXVFaGFhU0V4SlVyV3JlMHlnU3Q1YTdYeW9DeUtFVDNy?=
 =?utf-8?B?RURUdmVlYlN3OHBFeW5WRVRmZWdyL2hlWEdYQVQ3ZVZQOHh0TGxVTWpvVFdG?=
 =?utf-8?B?VUNDbWZZY2Z3M0dNNHRCb3Y5L01hcmhNL2VKNzBDUm1nQllpRi9PWWwycDhD?=
 =?utf-8?B?TkhNQnJYaG8wZGpUVlhCRk9Zd0pmZTFnY0NaR0JpOUtzZE5VL0NwVzdoOFdV?=
 =?utf-8?B?YlpOMVFUUEJkaDZwTDFYR0dBY2wvUHJPaU1HTEtpSnEyQWJCRGFDU05BTzFH?=
 =?utf-8?B?YkNFS1VEQ29lWEZ2YVh1OEw1Q1JFWkFjMEQ3emY5V2pzT0crRCs5dElhSG10?=
 =?utf-8?B?RXdvVGd2OVZuUDB5Uk9wT2pQMFhqM0t3Y3lPSU5idnJsY3lOdDBNQ0VJK1FT?=
 =?utf-8?B?V0tkNU1BLzRFbFBJVVp3eCs2TEc4aW1EeHJ5Nko0alVtcUt4VFo4YVovRElo?=
 =?utf-8?B?TmQ0L3pDeEkyc1FwMkxzbDFJV21CeEJvQ3V3R3I2UTZuU3dBVG5hVW5yNEw4?=
 =?utf-8?B?WUM0ZERGMEZqTUVzV01nQXFFVkdxRHZrSU5yd1pqQzZNNkxnNVo0S0F6eEZn?=
 =?utf-8?B?ZlllOW1CUHVjSGIwU3c5NFBUSTlqZlF6dlAwWG5RS1lvN3ZyUnhWV3ZVWTk4?=
 =?utf-8?B?dGd0bkp2VThmWXR6ZHlzcmJIb1NVSFFHYnRWMytJREdHRHNraUhhbFdQaUM5?=
 =?utf-8?B?WkZva1NrSVRneVdtQjcrV0hYMzRibG9YTDlQNHErMzNFZTVuYWp0Tis2eVI0?=
 =?utf-8?B?OWlsVTVTb3g0L3NjdTNRYVJHQjFFa3RHNmNGNHFjb0s4aFhuSkd1RmNlZE5k?=
 =?utf-8?B?Q3FaWVlEUG9GNU9KQ0lMNU5UVnVWMjJ5c1kzYk1MaGpHSjhFc0Zoc05BOTlj?=
 =?utf-8?B?SUhMQ01aWjB6YmN4TnczWUlQVTh1WmVGeWJndHBMU3RqVXRIVmF4N1c2Z0Zx?=
 =?utf-8?B?Nm16aUViSTNsZFAvQWlUUjZRR05EbjJpeTNYZTltd1pSRS9pK0Y5S0VLMFJZ?=
 =?utf-8?B?clJkS2RSNDRSMFpWT2M0amszMTVpc3JSMGN5ckxxNWh2bFJ4ZEtWN1h4cEZj?=
 =?utf-8?B?c2FPblZGWlc5WlFnQWozcmNPRThLUWRLQVNTR1NjTGVvZjBLaFVsWUFVK0FQ?=
 =?utf-8?B?YjNVRFgzRDk5d051QzhEMm9LZ3hTTWtTN3YvYTZSUzRscGFmcjhJWVpxaXEw?=
 =?utf-8?Q?+7yKEc18piUcUJKKeuhWCuJeM?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <209E9CA28BD5AB4DBB7024C123E4D798@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4791.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c74d6ba8-425f-4b96-dab4-08dab2054d9f
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Oct 2022 19:08:27.2780
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YzX0CDMQqACbm9D56uOR28QU0AOt/XLDRmIybE3B/nKFnDthAawrJBxo9yVs03vy8zWaVxXbEBpHJGUGEQiJZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6161
X-Proofpoint-GUID: vMy4X9vrrirRbMtB5uC9yEoJmtP8aEqg
X-Proofpoint-ORIG-GUID: vMy4X9vrrirRbMtB5uC9yEoJmtP8aEqg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-19_11,2022-10-19_04,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_active_cloned_notspam policy=outbound_active_cloned score=0
 priorityscore=1501 adultscore=0 clxscore=1015 malwarescore=0 bulkscore=0
 mlxlogscore=999 mlxscore=0 lowpriorityscore=0 phishscore=0 spamscore=0
 suspectscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2209130000 definitions=main-2210190108
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gV2VkLCBPY3QgMTksIDIwMjIsIEplZmYgVmFuaG9vZiB3cm90ZToNCj4gSGkgVGhpbmgsDQo+
IA0KPiBPbiBXZWQsIE9jdCAxOSwgMjAyMiBhdCAwMjowMjo1M0FNICswMDAwLCBUaGluaCBOZ3V5
ZW4gd3JvdGU6DQo+ID4gT24gVHVlLCBPY3QgMTgsIDIwMjIsIEplZmYgVmFuaG9vZiB3cm90ZToN
Cj4gPiA+IEhpIFRoaW5oLA0KPiA+ID4gDQo+ID4gPiBPbiBUdWUsIE9jdCAxOCwgMjAyMiBhdCAx
MDozNTozMFBNICswMDAwLCBUaGluaCBOZ3V5ZW4gd3JvdGU6DQo+ID4gPiA+IE9uIFR1ZSwgT2N0
IDE4LCAyMDIyLCBKZWZmcmV5IFZhbmhvb2Ygd3JvdGU6DQo+ID4gPiA+ID4gSGkgVGhpbmgsDQo+
ID4gPiA+ID4gDQo+ID4gPiA+ID4gT24gVHVlLCBPY3QgMTgsIDIwMjIgYXQgMDY6NDU6NDBQTSAr
MDAwMCwgVGhpbmggTmd1eWVuIHdyb3RlOg0KPiA+ID4gPiA+ID4gSGkgRGFuLA0KPiA+ID4gPiA+
ID4gDQo+ID4gPiA+ID4gPiBPbiBNb24sIE9jdCAxNywgMjAyMiwgRGFuIFZhY3VyYSB3cm90ZToN
Cj4gPiA+ID4gPiA+ID4gSGkgVGhpbmgsDQo+ID4gPiA+ID4gPiA+IA0KPiA+ID4gPiA+ID4gPiBP
biBNb24sIE9jdCAxNywgMjAyMiBhdCAwOTozMDozOFBNICswMDAwLCBUaGluaCBOZ3V5ZW4gd3Jv
dGU6DQo+ID4gPiA+ID4gPiA+ID4gT24gTW9uLCBPY3QgMTcsIDIwMjIsIERhbiBWYWN1cmEgd3Jv
dGU6DQo+ID4gPiA+ID4gPiA+ID4gPiBGcm9tOiBKZWZmIFZhbmhvb2YgPHFqdjAwMUBtb3Rvcm9s
YS5jb20+DQo+ID4gPiA+ID4gPiA+ID4gPiANCj4gPiA+ID4gPiA+ID4gPiA+IGFybS1zbW11IHJl
bGF0ZWQgY3Jhc2hlcyBzZWVuIGFmdGVyIGEgTWlzc2VkIElTT0MgaW50ZXJydXB0IHdoZW4NCj4g
PiA+ID4gPiA+ID4gPiA+IG5vX2ludGVycnVwdD0xIGlzIHVzZWQuIFRoaXMgY2FuIGhhcHBlbiBp
ZiB0aGUgaGFyZHdhcmUgaXMgc3RpbGwgdXNpbmcNCj4gPiA+ID4gPiA+ID4gPiA+IHRoZSBkYXRh
IGFzc29jaWF0ZWQgd2l0aCBhIFRSQiBhZnRlciB0aGUgdXNiX3JlcXVlc3QncyAtPmNvbXBsZXRl
IGNhbGwNCj4gPiA+ID4gPiA+ID4gPiA+IGhhcyBiZWVuIG1hZGUuICBJbnN0ZWFkIG9mIGltbWVk
aWF0ZWx5IHJlbGVhc2luZyBhIHJlcXVlc3Qgd2hlbiBhIE1pc3NlZA0KPiA+ID4gPiA+ID4gPiA+
ID4gSVNPQyBpbnRlcnJ1cHQgaGFzIG9jY3VycmVkLCB0aGlzIGNoYW5nZSB3aWxsIGFkZCBsb2dp
YyB0byBjYW5jZWwgdGhlDQo+ID4gPiA+ID4gPiA+ID4gPiByZXF1ZXN0IGluc3RlYWQgd2hlcmUg
aXQgd2lsbCBldmVudHVhbGx5IGJlIHJlbGVhc2VkIHdoZW4gdGhlDQo+ID4gPiA+ID4gPiA+ID4g
PiBFTkRfVFJBTlNGRVIgY29tbWFuZCBoYXMgY29tcGxldGVkLiBUaGlzIGxvZ2ljIGlzIHNpbWls
YXIgdG8gc29tZSBvZiB0aGUNCj4gPiA+ID4gPiA+ID4gPiA+IGNsZWFudXAgZG9uZSBpbiBkd2Mz
X2dhZGdldF9lcF9kZXF1ZXVlLg0KPiA+ID4gPiA+ID4gPiA+IA0KPiA+ID4gPiA+ID4gPiA+IFRo
aXMgZG9lc24ndCBzb3VuZCByaWdodC4gSG93IGRpZCB5b3UgZGV0ZXJtaW5lIHRoYXQgdGhlIGhh
cmR3YXJlIGlzDQo+ID4gPiA+ID4gPiA+ID4gc3RpbGwgdXNpbmcgdGhlIGRhdGEgYXNzb2NpYXRl
ZCB3aXRoIHRoZSBUUkI/IERpZCB5b3UgY2hlY2sgdGhlIFRSQidzDQo+ID4gPiA+ID4gPiA+ID4g
SFdPIGJpdD8NCj4gPiA+ID4gPiA+ID4gDQo+ID4gPiA+ID4gPiA+IFRoZSBwcm9ibGVtIHdlJ3Jl
IHNlZWluZyB3YXMgbWVudGlvbmVkIGluIHRoZSBzdW1tYXJ5IG9mIHRoaXMgcGF0Y2gNCj4gPiA+
ID4gPiA+ID4gc2VyaWVzLCBpc3N1ZSAjMS4gQmFzaWNhbGx5LCB3aXRoIHRoZSBmb2xsb3dpbmcg
cGF0Y2gNCj4gPiA+ID4gPiA+ID4gaHR0cHM6Ly91cmxkZWZlbnNlLmNvbS92My9fX2h0dHBzOi8v
cGF0Y2h3b3JrLmtlcm5lbC5vcmcvcHJvamVjdC9saW51eC11c2IvcGF0Y2gvMjAyMTA2MjgxNTUz
MTEuMTY3NjItNi1tLmdyemVzY2hpa0BwZW5ndXRyb25peC5kZS9fXzshIUE0RjJSOUdfcGchYVNO
Wi1Jak1jUGdMNDdBNE5SNXFwOXFoVmxQOTFVR1R1Q3hlajVOUlR2OC1GbVRyTWtLSzdDak5Ub1FR
VkVndHBxYkt6TFUySFhFVDlPMjI2QUVOJCAgDQo+ID4gPiA+ID4gPiA+IGludGVncmF0ZWQgYSBz
bW11IHBhbmljIGlzIG9jY3VycmluZyBvbiBvdXIgQW5kcm9pZCBkZXZpY2Ugd2l0aCB0aGUgNS4x
NQ0KPiA+ID4gPiA+ID4gPiBrZXJuZWwgd2hpY2ggaXM6DQo+ID4gPiA+ID4gPiA+IA0KPiA+ID4g
PiA+ID4gPiAgICAgPDM+WyAgNzE4LjMxNDkwMF1bICBUODAzXSBhcm0tc21tdSAxNTAwMDAwMC5h
cHBzLXNtbXU6IFVuaGFuZGxlZCBhcm0tc21tdSBjb250ZXh0IGZhdWx0IGZyb20gYTYwMDAwMC5k
d2MzIQ0KPiA+ID4gPiA+ID4gPiANCj4gPiA+ID4gPiA+ID4gVGhlIHV2YyBnYWRnZXQgZHJpdmVy
IGFwcGVhcnMgdG8gYmUgdGhlIGZpcnN0IChhbmQgb25seSkgZ2FkZ2V0IHRoYXQNCj4gPiA+ID4g
PiA+ID4gdXNlcyB0aGUgbm9faW50ZXJydXB0PTEgbG9naWMsIHNvIHRoaXMgc2VlbXMgdG8gYmUg
YSBuZXcgY29uZGl0aW9uIGZvcg0KPiA+ID4gPiA+ID4gPiB0aGUgZHdjMyBkcml2ZXIuIEluIG91
ciBjb25maWd1cmF0aW9uLCB3ZSBoYXZlIHVwIHRvIDY0IHJlcXVlc3RzIGFuZCB0aGUNCj4gPiA+
ID4gPiA+ID4gbm9faW50ZXJydXB0PTEgZm9yIHVwIHRvIDE1IHJlcXVlc3RzLiBUaGUgbGlzdCBz
aXplIG9mIGRlcC0+c3RhcnRlZF9saXN0DQo+ID4gPiA+ID4gPiA+IHdvdWxkIGdldCB1cCB0byB0
aGF0IGFtb3VudCB3aGVuIGxvb3BpbmcgdGhyb3VnaCB0byBjbGVhbnVwIHRoZQ0KPiA+ID4gPiA+
ID4gPiBjb21wbGV0ZWQgcmVxdWVzdHMuIEZyb20gdGVzdGluZyBhbmQgZGVidWdnaW5nIHRoZSBz
bW11IHBhbmljIG9jY3Vycw0KPiA+ID4gPiA+ID4gPiB3aGVuIGEgLUVYREVWIHN0YXR1cyBzaG93
cyB1cCBhbmQgcmlnaHQgYWZ0ZXINCj4gPiA+ID4gPiA+ID4gZHdjM19nYWRnZXRfZXBfY2xlYW51
cF9jb21wbGV0ZWRfcmVxdWVzdCgpIHdhcyB2aXNpdGVkLiBUaGUgY29uY2x1c2lvbg0KPiA+ID4g
PiA+ID4gPiB3ZSBoYWQgd2FzIHRoZSByZXF1ZXN0cyB3ZXJlIGdldHRpbmcgcmV0dXJuZWQgdG8g
dGhlIGdhZGdldCB0b28gZWFybHkuDQo+ID4gPiA+ID4gPiANCj4gPiA+ID4gPiA+IEFzIEkgbWVu
dGlvbmVkLCBpZiB0aGUgc3RhdHVzIGlzIHVwZGF0ZWQgdG8gbWlzc2VkIGlzb2MsIHRoYXQgbWVh
bnMgdGhhdA0KPiA+ID4gPiA+ID4gdGhlIGNvbnRyb2xsZXIgcmV0dXJuZWQgb3duZXJzaGlwIG9m
IHRoZSBUUkIgdG8gdGhlIGRyaXZlci4gQXQgbGVhc3QgZm9yDQo+ID4gPiA+ID4gPiB0aGUgcGFy
dGljdWxhciByZXF1ZXN0IHdpdGggLUVYREVWLCBpdHMgVFJCcyBhcmUgY29tcGxldGVkLiBJJ20g
bm90DQo+ID4gPiA+ID4gPiBjbGVhciBvbiB5b3VyIGNvbmNsdXNpb24uDQo+ID4gPiA+ID4gPiAN
Cj4gPiA+ID4gPiA+IERvIHdlIGtub3cgd2hlcmUgZGlkIHRoZSBjcmFzaCBvY2N1cj8gSXMgaXQg
ZnJvbSBkd2MzIGRyaXZlciBvciBmcm9tIHV2Yw0KPiA+ID4gPiA+ID4gZHJpdmVyLCBhbmQgYXQg
d2hhdCBsaW5lPyBJdCdkIGdyZWF0IGlmIHdlIGNhbiBzZWUgdGhlIGRyaXZlciBsb2cuDQo+ID4g
PiA+ID4gPg0KPiA+ID4gPiA+IA0KPiA+ID4gPiA+IFRvIGludGVyamVjdCwgd2hhdCBzaG91bGQg
aGFwcGVuIGluIGR3YzNfZ2FkZ2V0X2VwX3JlY2xhaW1fY29tcGxldGVkX3RyYiBpZiB0aGUNCj4g
PiA+ID4gPiBJT0MgYml0IGlzIG5vdCBzZXQgKGJ1dCB0aGUgSU1JIGJpdCBpcykgYW5kIC1FWERF
ViBzdGF0dXMgaXMgcGFzc2VkIGludG8gaXQ/DQo+ID4gPiA+IA0KPiA+ID4gPiBIbS4uLiB3ZSBt
YXkgaGF2ZSBvdmVybG9va2VkIHRoaXMgY2FzZSBmb3Igbm9faW50ZXJydXB0IHNjZW5hcmlvLiBJ
ZiBJTUkNCj4gPiA+ID4gaXMgc2V0LCB0aGVuIHRoZXJlIHdpbGwgYmUgYW4gaW50ZXJydXB0IHdo
ZW4gdGhlcmUncyBtaXNzZWQgaXNvYw0KPiA+ID4gPiByZWdhcmRsZXNzIG9mIHdoZXRoZXIgbm9f
aW50ZXJydXB0IGlzIHNldCBieSB0aGUgZ2FkZ2V0IGRyaXZlci4NCj4gPiA+ID4gDQo+ID4gPiA+
ID4gSWYgdGhlIGZ1bmN0aW9uIHJldHVybnMgMCwgYW5vdGhlciBhdHRlbXB0IHRvIHJlY2xhaW0g
bWF5IG9jY3VyLiBJZiB0aGlzDQo+ID4gPiA+ID4gaGFwcGVucyBhbmQgdGhlIG5leHQgcmVxdWVz
dCBkaWQgaGF2ZSB0aGUgSFdPIGJpdCBzZXQsIHRoZSBmdW5jdGlvbiB3b3VsZA0KPiA+ID4gPiA+
IHJldHVybiAxIGJ1dCBkd2MzX2dhZGdldF9lcF9jbGVhbnVwX2NvbXBsZXRlZF9yZXF1ZXN0IHdv
dWxkIHN0aWxsIGNhbGwNCj4gPiA+ID4gPiBkd2MzX2dhZGdldF9naXZlYmFjay4NCj4gPiA+ID4g
PiANCj4gPiA+ID4gPiBBcyBhIHRlc3QgKHdpdGhvdXQgdGhpcyBwYXRjaCksIEkgYWRkZWQgYSBj
aGVjayB0byBzZWUgaWYgSFdPIGJpdCB3YXMgc2V0IGluDQo+ID4gPiA+ID4gZHdjM19nYWRnZXRf
ZXBfY2xlYW51cF9jb21wbGV0ZWRfcmVxdWVzdHMoKS4gSWYgdGhlIHVzZWNhc2Ugd2FzIElTT0Mg
YW5kIHRoZQ0KPiA+ID4gPiA+IEhXTyBiaXQgd2FzIHNldCBJIGF2b2lkZWQgY2FsbGluZyBkd2Mz
X2dhZGdldF9lcF9jbGVhbnVwX2NvbXBsZXRlZF9yZXF1ZXN0KCkuDQo+ID4gPiA+ID4gVGhpcyBz
ZWVtZWQgdG8gYWxzbyBhdm9pZCB0aGUgaW9tbXUgcmVsYXRlZCBjcmFzaCBiZWluZyBzZWVuLg0K
PiA+ID4gPiA+IA0KPiA+ID4gPiA+IElzIHRoZXJlIGFuIGlzc3VlIGluIHRoaXMgYXJlYSB0aGF0
IG5lZWRzIHRvIGJlIGNvcnJlY3RlZCBpbnN0ZWFkPyBOb3QgaGF2aW5nDQo+ID4gPiA+ID4gaW50
ZXJydXB0cyBzZXQgZm9yIGVhY2ggcmVxdWVzdCBtYXkgYmUgY2F1c2luZyBzb21lIG5ldyBpc3N1
ZXMgdG8gYmUgdW5jb3ZlcmVkLg0KPiA+ID4gPiA+IA0KPiA+ID4gPiA+IEFzIGZhciBhcyB0aGUg
Y3Jhc2ggc2VlbiB3aXRob3V0IHRoaXMgcGF0Y2gsIG5vIGdvb2Qgc3RhY2t0cmFjZSBpcyBnaXZl
bi4gTGluZQ0KPiA+ID4gPiA+IHByb3ZpZGVkIGZvciBjcmFzaCB2YXJpZWQgYSBiaXQsIGJ1dCB0
ZW5kZWQgdG8gYXBwZWFyIHRvd2FyZHMgdGhlIGVuZCBvZg0KPiA+ID4gPiA+IGR3YzNfc3RvcF9h
Y3RpdmVfdHJhbnNmZXIoKSBvciBkd2MzX2dhZGdldF9lbmRwb2ludF90cmJzX2NvbXBsZXRlKCku
DQo+ID4gPiA+ID4gDQo+ID4gPiA+ID4gU2luY2UgZHdjM19nYWRnZXRfZW5kcG9pbnRfdHJic19j
b21wbGV0ZSgpIGNhbiBiZSBjYWxsZWQgZnJvbSBtdWx0aXBsZQ0KPiA+ID4gPiA+IGxvY2F0aW9u
cywgSSBkdXBsaWNhdGVkIHRoZSBmdW5jdGlvbiB0byBoZWxwIGlkZW50aWZ5IHdoaWNoIHBhdGgg
aXQgd2FzIGxpa2VseQ0KPiA+ID4gPiA+IGJlaW5nIGNhbGxlZCBmcm9tLiBBdCB0aGUgdGltZSBv
ZiB0aGUgY3Jhc2hlcyBzZWVuLA0KPiA+ID4gPiA+IGR3YzNfZ2FkZ2V0X2VuZHBvaW50X3RyYW5z
ZmVyX2luX3Byb2dyZXNzKCkgYXBwZWFyZWQgdG8gYmUgdGhlIGNhbGxlci4NCj4gPiA+ID4gPiAN
Cj4gPiA+ID4gPiBkd2MzX2dhZGdldF9lbmRwb2ludF90cmFuc2Zlcl9pbl9wcm9ncmVzcygpDQo+
ID4gPiA+ID4gLT5kd2MzX2dhZGdldF9lbmRwb2ludF90cmJzX2NvbXBsZXRlKCkgKGNyYXNoZWQg
dG93YXJkcyBlbmQgb2YgaGVyZSkNCj4gPiA+ID4gPiAtPmR3YzNfc3RvcF9hY3RpdmVfdHJhbnNm
ZXIoKSAoc29tZXRpbWVzIGNyYXNoZWQgdG93YXJkcyBlbmQgb2YgaGVyZSkNCj4gPiA+ID4gPiAN
Cj4gPiA+ID4gPiBJIGhvcGUgdGhpcyBjbGFyaWZpZXMgdGhpbmdzIGEgYml0Lg0KPiA+ID4gPiA+
ICANCj4gPiA+ID4gDQo+ID4gPiA+IENhbiB3ZSB0cnkgdGhpcz8gTGV0IG1lIGtub3cgaWYgaXQg
cmVzb2x2ZXMgeW91ciBpc3N1ZS4NCj4gPiA+ID4gDQo+ID4gPiA+IGRpZmYgLS1naXQgYS9kcml2
ZXJzL3VzYi9kd2MzL2dhZGdldC5jIGIvZHJpdmVycy91c2IvZHdjMy9nYWRnZXQuYw0KPiA+ID4g
PiBpbmRleCA2MWZiYTJiNzM4OWIuLjgzNTJmNGI1ZGQ5ZiAxMDA2NDQNCj4gPiA+ID4gLS0tIGEv
ZHJpdmVycy91c2IvZHdjMy9nYWRnZXQuYw0KPiA+ID4gPiArKysgYi9kcml2ZXJzL3VzYi9kd2Mz
L2dhZGdldC5jDQo+ID4gPiA+IEBAIC0zNjU3LDYgKzM2NTcsMTAgQEAgc3RhdGljIGludCBkd2Mz
X2dhZGdldF9lcF9yZWNsYWltX2NvbXBsZXRlZF90cmIoc3RydWN0IGR3YzNfZXAgKmRlcCwNCj4g
PiA+ID4gIAlpZiAoZXZlbnQtPnN0YXR1cyAmIERFUEVWVF9TVEFUVVNfU0hPUlQgJiYgIWNoYWlu
KQ0KPiA+ID4gPiAgCQlyZXR1cm4gMTsNCj4gPiA+ID4gIA0KPiA+ID4gPiArCWlmICh1c2JfZW5k
cG9pbnRfeGZlcl9pc29jKGRlcC0+ZW5kcG9pbnQuZGVzYykgJiYNCj4gPiA+ID4gKwkgICAgKGV2
ZW50LT5zdGF0dXMgJiBERVBFVlRfU1RBVFVTX01JU1NFRF9JU09DKSAmJiAhY2hhaW4pDQo+ID4g
PiA+ICsJCXJldHVybiAxOw0KPiA+ID4gPiArDQo+ID4gPiA+ICAJaWYgKCh0cmItPmN0cmwgJiBE
V0MzX1RSQl9DVFJMX0lPQykgfHwNCj4gPiA+ID4gIAkgICAgKHRyYi0+Y3RybCAmIERXQzNfVFJC
X0NUUkxfTFNUKSkNCj4gPiA+ID4gIAkJcmV0dXJuIDE7DQo+ID4gPiA+DQo+ID4gPiANCj4gPiA+
IFdpdGggdGhpcyBjaGFuZ2UgaXQgZG9lc24ndCBzZWVtIHRvIGNyYXNoIGJ1dCB1bmZvcnR1bmF0
ZWx5IHRoZSBvdXRwdXQNCj4gPiA+IGNvbXBsZXRlbHkgaGFuZ3MgYWZ0ZXIgdGhlIGZpcnN0IG1p
c3NlZCBpc29jLiBBdCB0aGUgbW9tZW50IEkgZG8gbm90IHVuZGVyc3RhbmQNCj4gPiA+IHdoeSB0
aGlzIG1pZ2h0IGhhcHBlbi4gDQo+ID4gPiANCj4gPiANCj4gPiBDYW4geW91IGNhcHR1cmUgdGhl
IGRyaXZlciB0cmFjZXBvaW50cyB3aXRoIHRoZSBjaGFuZ2UgYWJvdmU/DQo+ID4NCj4gDQo+IER1
ZSB0byB0aGUgc2l6ZSBvZiB0aGUgbG9nLCBoYXZlIHNlbnQgaXQgdG8gZGlyZWN0bHkgdG8geW91
Lg0KDQpKdXN0IGdvdCBpdC4gVGhhbmtzLg0KDQo+IA0KPiBGcm9tIHdoYXQgSSBjYW4gZ2F0aGVy
IGZyb20gdGhlIGxvZywgd2l0aCB0aGUgY3VycmVudCBjaGFuZ2VzIGl0IHNlZW1zIHRoYXQNCj4g
YWZ0ZXIgYSBtaXNzZWQgaXNvYyBldmVudCBmZXcgcmVxdWVzdHMgYXJlIHN0YXlpbmcgbG9uZ2Vy
IHRoYW4gZXhwZWN0ZWQgaW4gdGhlDQo+IHN0YXJ0ZWRfbGlzdCAobm90IGdldHRpbmcgcmVjbGFp
bWVkKSBhbmQgdGhpcyBpcyBwcmV2ZW50aW5nIHRoZSB0cmFuc21pc3Npb24NCj4gZnJvbSBzdG9w
cGluZy9zdGFydGluZyBhZ2FpbiwgYW5kIG9wZW5pbmcgdGhlIGRvb3IgZm9yIGNvbnRpbnVvdXMg
c3RyZWFtIG9mDQo+IG1pc3NlZCBpc29jIGV2ZW50cyB0aGF0IGNhdXNlIHdoYXQgYXBwZWFycyB0
byB0aGUgdXNlciBhcyBhIGZyb3plbiB2aWRlby4NCj4gDQo+IFNvIG9uZSB0aG91Z2h0LCBpZiBJ
T0MgYml0IGlzIG5vdCBzZXQgZXZlcnkgZnJhbWUsIGJ1dCBJTUkgYml0IGlzLCB3aGVuIGENCj4g
bWlzc2VkIGlzb2MgcmVsYXRlZCBpbnRlcnJ1cHQgb2NjdXJzIGl0IHNlZW1zIGxpa2VseSB0aGF0
IG1vcmUgdGhhbiBvbmUgdHJiDQo+IHJlcXVlc3Qgd2lsbCBuZWVkIHRvIGJlIHJlY2xhaW1lZCwg
YnV0IHRoZSBjdXJyZW50IHNldCBvZiBjaGFuZ2VzIGlzIG5vdA0KPiBoYW5kbGluZyB0aGlzLg0K
PiANCj4gSW4gdGhlIGdvb2QgdHJhbnNmZXIgY2FzZSB0aGlzIGlzc3VlIHNlZW1zIHRvIGJlIHRh
a2VuIGNhcmUgb2Ygc2luY2UgdGhlIElPQw0KPiBiaXQgaXMgbm90IHNldCBldmVyeSBmcmFtZSBh
bmQgdGhlIHJlY2xhaW1hdGlvbiB3aWxsIGxvb3AgdGhyb3VnaCBldmVyeSBpdGVtIGluDQo+IHRo
ZSBzdGFydGVkX2xpc3QgYW5kIG9ubHkgc3RvcCBpZiB0aGVyZSBhcmUgbm8gYWRkaXRpb25hbCB0
cmJzIG9yIGlmIG9uZSBoYXMNCg0KSXQgc2hvdWxkIHN0b3AgYXQgdGhlIHJlcXVlc3QgdGhhdCBh
c3NvY2lhdGVkIHdpdGggdGhlIGludGVycnVwdCBldmVudCwNCndoZXRoZXIgaXQncyBiZWNhdXNl
IG9mIElNSSBvciBJT0MuDQoNCj4gaXRzIEhXTyBiaXQgc2V0LiBBbHRob3VnaCBJIGFtIGEgYml0
IHN1cnByaXNlZCB0aGF0IHdlIGFyZSBub3QgeWV0IHNlZWluZyBpb21tdQ0KPiByZWxhdGVkIHBh
bmljcyBoZXJlIHRvbyBzaW5jZSB0aGUgdHJiIGlzIGJlaW5nIHJlY2xhaW1lZCBhbmQgZ2l2ZW4g
YmFjayBldmVuDQo+IHRoZSBIV08gYml0IHN0aWxsIHNldCwgYnV0IG1heWJlIEkgYW0gbWlzdW5k
ZXJzdGFuZGluZyBzb21ldGhpbmcuIEluIG15IGVhcmxpZXINCj4gdGVzdGluZywgaWYgYSBtaXNz
ZWQgaXNvYyBldmVudCB3YXMgcmVjZWl2ZWQgYW5kIHdlIGF0dGVtcHRlZCB0bw0KPiByZWNsYWlt
L2dpdmViYWNrIGEgdHJiIHdpdGggaXRzIEhXTyBiaXQgc2V0LCBhIGlvbW11IHJlbGF0ZWQgcGFu
aWMgd291bGQgYmUNCj4gc2Vlbi4NCg0KSWYgdGhlIGNvbnRyb2xsZXIgcHJvY2Vzc2VkIHRoZSBU
UkIsIGl0IHdvdWxkIGNsZWFyIHRoZSBIV08gYml0IGFmdGVyDQpjb21wbGV0aW9uLiBUaGVyZSBh
cmUgY2FzZXMgd2hpY2ggdGhlIEhXTyBiaXQgaXMgc3RpbGwgc2V0IGZvciBzb21lDQpUUkJzLCBi
dXQgdGhlIHJlcXVlc3QgaXMgY29tcGxldGVkIChlLmcuIHNob3J0IHRyYW5zZmVycyBjYXVzaW5n
IHRoZQ0KY29udHJvbGxlciB0byBzdG9wIHByb2Nlc3NpbmcgZnVydGhlcikuIFRoYXQgdGhvc2Ug
Y2FzZXMsIHRoZSBkcml2ZXINCndvdWxkIGNsZWFyIHRoZSBIV08gYml0IG1hbnVhbGx5Lg0KDQo+
IA0KPiBDYW4geW91IHByb3Bvc2UgYW4gYWRkaXRpb25hbCBjaGFuZ2UgdG8gaGFuZGxlIGZyZWVp
bmcgdXAgdGhlIGV4dHJhIHRyYnMgaW4gdGhlDQo+IG1pc3NlZCBpc29jIGNhc2U/IEkgdGhpbmsg
dGhhdCBzb21laG93IHRoZSBIV08gYml0IHNob3VsZCBiZSBjaGVja2VkIGJlZm9yZQ0KPiBlbnRl
cmluZyBkd2MzX2dhZGdldF9lcF9jbGVhbnVwX2NvbXBsZXRlZF9yZXF1ZXN0IGluIG9yZGVyIHRv
IGF2b2lkIHRoZSB0cmINCj4gYmVpbmcgZ2l2ZW4gYmFjayB0b28gc29vbi4NCg0KV2Ugc2hvdWxk
IG5vdCBjaGVjayBmb3IgVFJCcyBvZiByZXF1ZXN0cyBiZXlvbmQgdGhlIHJlcXVlc3QgYXNzb2Np
YXRlZA0Kd2l0aCB0aGUgaW50ZXJydXB0IGV2ZW50Lg0KDQo+IA0KPiBZb3VyIHRob3VnaHRzPw0K
PiANCg0KVGhlIGNhcHR1cmUgc2hvd3MgdW5kZXJydW4sIGFuZCBpdCBjYXVzZXMgbWlzc2VkIGlz
b2MuDQoNCkxldCdzIHRha2UgYSBsb29rIGF0IHRoZSBmaXJzdCBtaXNzZWQgaXNvYyByZXF1ZXN0
IChyZXEgZmZmZmZmODhmODM0ZGIwMCkNCg0KICAgICAgICAgICA8Li4uPi0yMjU1MSAgIFswMDJd
IGQuLjIgMTM5ODUuNzg5Njg0OiBkd2MzX2VwX3F1ZXVlOiBlcDJpbjogcmVxIGZmZmZmZjg4Zjgz
NGRiMDAgbGVuZ3RoIDAvNDkxNTIgenNpID09PiAtMTE1DQogICAgICAgICAgIDwuLi4+LTIyNTUx
ICAgWzAwMl0gZG4uMiAxMzk4NS43ODk3Mjg6IGR3YzNfcHJlcGFyZV90cmI6IGVwMmluOiB0cmIg
ZmZmZmZmYzAxNjA3MTk3MCAoRTE1MjpEMTQ5KSBidWYgMDAwMDAwMDBlYTgwMDAwMCBzaXplIDF4
IDQ5MTUyIGN0cmwgMDAwMDA0NjEgKEhsY3M6U2M6aXNvYy1maXJzdCkNCg0KRWFjaCByZXF1ZXN0
IHVzZXMgYSBvbmUgVFJCLiBGcm9tIGFib3ZlLCB5b3UgY2FuIHNlZSB0aGF0IHRoZXJlIGFyZSBv
bmx5DQozIGludGVydmFscyBwcmVwYXJlZCAoRTE1MiAtIEQxNDkgPSAzKS4NCg0KVGhlIHRpbWVz
dGFtcCBvZiB0aGUgbGFzdCByZXF1ZXN0IGNvbXBsZXRpb24gaXMgMTM5ODUuNzg4OTE5Lg0KVGhl
IHRpbWVzdGFtcCB3aGljaCB0aGUgcXVldWVkIHJlcXVlc3QgaXMgMTM5ODUuNzg5NzI4Lg0KV2Ug
Y2FuIHJvdWdobHkgZXN0aW1hdGUgdGhlIGRpZmYgaXMgYXQgbGVhc3QgODA5dXMuDQoNCjMgaW50
ZXJ2YWxzICgzeDEyNXVzKSBpcyBsZXNzIHRoYW4gODA5dXMuIFNvIG1pc3NlZCBpc29jIGlzIGV4
cGVjdGVkOg0KDQogICAgaXJxLzM5OS1kd2MzLTE1MjY5ICAgWzAwMl0gZC4uMSAxMzk4NS43OTA3
NTQ6IGR3YzNfZXZlbnQ6IGV2ZW50IChmOWFjYzA4YSk6IGVwMmluOiBUcmFuc2ZlciBJbiBQcm9n
cmVzcyBbNjM5MTZdIChzSU0pDQogICAgaXJxLzM5OS1kd2MzLTE1MjY5ICAgWzAwMl0gZC4uMSAx
Mzk4NS43OTA3NTg6IGR3YzNfY29tcGxldGVfdHJiOiBlcDJpbjogdHJiIGZmZmZmZmMwMTYwNzE5
NzAgKEUxNTQ6RDE1MikgYnVmIDAwMDAwMDAwZWE4MDAwMDAgc2l6ZSAxeCA0OTE1MiBjdHJsIDNl
NmEwNDYwIChobGNzOlNjOmlzb2MtZmlyc3QpDQogICAgaXJxLzM5OS1kd2MzLTE1MjY5ICAgWzAw
Ml0gZC4uMSAxMzk4NS43OTA4MDg6IGR3YzNfZ2FkZ2V0X2dpdmViYWNrOiBlcDJpbjogcmVxIGZm
ZmZmZjg4ZjgzNGRiMDAgbGVuZ3RoIDAvNDkxNTIgenNpID09PiAtMTgNCg0KDQpBZnRlciB0aGlz
IHBvaW50LCB0aGUgdXZjIGRyaXZlciBrZWVwcyBwbGF5aW5nIGNhdGNoIHVwIHRvIHN0YXkgaW4g
c3luYw0Kd2l0aCB0aGUgaG9zdC4gSXQgdHJpZXMsIGJ1dCBpdCBjb3VsZG4ndCBjYXRjaCB1cC4g
QWxzbywgb2NjYXNpb25hbGx5DQpzb21ldGhpbmcgc2VlbXMgdG8gYmUgYmxvY2tpbmcgZHdjMywg
Y3JlYXRpbmcgdGltZSBnYXBzLiBNYXliZSBiZWNhdXNlDQpvZiBhIHNwaW5fbG9jayBoZWxkIHNv
bWV3aGVyZT8NCg0KVGhlIGxvZ2ljIHRvIGRldGVjdCB1bmRlcnJ1biBkb2Vzbid0IHRyaWdnZXIg
YmVjYXVzZSB0aGUgcXVldWVkIGxpc3QgaXMNCmFsd2F5cyBub24tZW1wdHksIGJ1dCB0aGUgcXVl
dWVkIHJlcXVlc3RzIGFyZSBleHBlY3RlZCB0byBiZSBtaXNzZWQNCmFscmVhZHkuIFNvIHlvdSBr
ZWVwIHNlZWluZyBtaXNzZWQgaXNvYy4NCg0KVGhlcmUgYXJlIGEgZmV3IHRoaW5ncyB5b3UgY2Fu
IG1pdGlnYXRlIHRoaXMgaXNzdWU6DQoxKSBEb24ndCBzZXQgSU1JIGlmIHRoZSByZXF1ZXN0IGlu
ZGljYXRlcyBub19pbnRlcnJ1cHQuIFRoaXMgcmVkdWNlcyB0aGUNCiAgIHRpbWUgc29mdHdhcmUg
bmVlZHMgdG8gaGFuZGxlIGludGVycnVwdHMuDQoyKSBJbXByb3ZlIHRoZSB1bmRlcnJ1biBkZXRl
Y3Rpb24gbG9naWMuDQozKSBJbmNyZWFzZSB0aGUgcXVldWluZyBmcmVxdWVuY3kgZnJvbSB0aGUg
dXZjIHRvIGtlZXAgdGhlIHJlcXVlc3QgcXVldWUNCiAgIGZ1bGwuIE5vdGUgdGhhdCByZWR1Y2Uv
YXZvaWQgc2V0dGluZyBub19pbnRlcnJ1cHQgd2lsbCBhbGxvdyB0aGUNCiAgIGNvbnRyb2xsZXIg
ZHJpdmVyIHRvIHVwZGF0ZSB1dmMgb2Z0ZW4gdG8ga2VlcCByZXF1ZXVpbmcgbmV3IHJlcXVlc3Rz
Lg0KDQpCZXN0IG9wdGlvbiBpcyAzKSwgYnV0IG1heWJlIHdlIGNhbiBkbyBhbGwgMy4NCg0KRm9y
IDIpLCB5b3UgY2FuIHNldCBJTUkgZm9yIGFsbCBpc29jIHJlcXVlc3QgYXMgaXQgaXMgbm93LiBP
biBtaXNzZWQNCmlzb2MsIGNoZWNrIGZvciB0aGUgVFJCJ3Mgc2NoZWR1bGVkIHVmcmFtZSAoZnJv
bSBUUkIgaW5mbykgYW5kIGNvbXBhcmUNCml0IHRvIHRoZSBjdXJyZW50IHVmcmFtZSAoZnJvbSBE
U1RTKSBmb3IgdGhlIG51bWJlciBvZiBpbnRlcnZhbHMgaW4NCmJldHdlZW4uIFdpdGggdGhlIG51
bWJlciBvZiBxdWV1ZWQgcmVxdWVzdHMsIHlvdSBjYW4gY2FsY3VsYXRlIHdoZXRoZXINCnRoZSBn
YWRnZXQgZHJpdmVyIHF1ZXVlZCBlbm91Z2ggcmVxdWVzdHMuIElmIGl0IGRvZXNuJ3QsIHNlbmQg
RW5kDQpUcmFuc2ZlciBjb21tYW5kIGFuZCBjYW5jZWwgYWxsIHRoZSBxdWV1ZWQgcmVxdWVzdHMu
IFRoZSBuZXh0IHNldCBvZg0KcmVxdWVzdHMgd2lsbCBiZSBpbi1zeW5jIGFnYWluLg0KDQpCUiwN
ClRoaW5oDQoNClBTLiBPbiBhIHNpZGUgbm90ZSwgSSBub3RpY2UgdGhhdCB0aGVyZSBhcmUgcmVw
b3J0cyBvZiBpc3N1ZSB3aGVuIHVzaW5nDQpTRyByaWdodD8gUGxlYXNlIG5vdGUgdGhhdCBkd2Mz
IGRyaXZlciBvbmx5IGFsbG9jYXRlcyAyNTYgVFJCcw0KKGluY2x1ZGluZyBhIGxpbmsgVFJCKS4g
RWFjaCBTRyBlbnRyeSB0YWtlcyBhIFRSQi4gSWYgYSByZXF1ZXN0IGhhcyBtYW55DQpTRyBlbnRy
aWVzLCB0aGF0IGVhdHMgdXAgdGhlIGF2YWlsYWJsZSBUUkJzLiBTbywgZXZlbiB0aG91Z2ggdGhl
IFVWQyBtYXkNCnF1ZXVlIG1hbnkgcmVxdWVzdHMsIG5vdCBhbGwgb2YgdGhlbSBhcmUgcHJlcGFy
ZWQgaW1tZWRpYXRlbHkuIElmIHRoZQ0KVFJCIHJpbmcgaXMgZnVsbCwgdGhlIGRyaXZlciBuZWVk
IHRvIHdhaXQgZm9yIG1vcmUgVFJCcyB0byBmcmVlIHVwDQpiZWZvcmUgcHJlcGFyaW5nIG1vcmUu
IEZyb20gdGhlIGxvZywgSSBzZWUgdGhhdCBpdCdzIHNlbmRpbmcgNDhLQi4gTGV0J3MNCnNheSB0
aGUgdXZjIHNwbGl0cyBpdCBpbnRvIFBBR0VfU0laRSBvZiA0S0IsIHRoYXQgd291bGQgdGFrZSBh
dCBsZWFzdCAxMg0KVFJCIHBlciByZXF1ZXN0LiAoU2lkZSB0aG91Z2h0OiBJJ20gbm90IHN1cmUg
d2h5IFVWQyBuZWVkcyBTRyBpbiB0aGUNCmZpcnN0IHBsYWNlIHdpdGggaXRzIGN1cnJlbnQgaW1w
bGVtZW50YXRpb24p
