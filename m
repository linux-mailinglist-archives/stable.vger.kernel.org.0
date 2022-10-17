Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E2BC601B4A
	for <lists+stable@lfdr.de>; Mon, 17 Oct 2022 23:31:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230179AbiJQVbM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 17:31:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230307AbiJQVbK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 17:31:10 -0400
Received: from mx0a-00230701.pphosted.com (mx0a-00230701.pphosted.com [148.163.156.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E4BD7CAA4;
        Mon, 17 Oct 2022 14:31:07 -0700 (PDT)
Received: from pps.filterd (m0297266.ppops.net [127.0.0.1])
        by mx0a-00230701.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29HIdjkp023942;
        Mon, 17 Oct 2022 14:30:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfptdkimsnps;
 bh=Vc7km8K+CiNLrdn46QJNbYkbCfdQ4EkefMKinbEehIA=;
 b=TIOlIIDXq67UcU6oCvTa+ZBZ1MNh3DAJZotSv+Y8KA2ov5g98jlEOEuw/HYS6i1Gy4M5
 cP54GcWN4WT32dyR7X8WU2wX//ZjVWVE6vuOz65vAmMT9XGntpjOrDf4yOPgHHNGqv/A
 s7cvkUhrbbPHc0vsK+SXiWv6PbpfWWRny1ap0MnpFaQzcVAx2fBZ55c8H1TQymHBo7Cg
 38f7KmBaHstx8eTrR0N0ktcEvipy/26W7b5W57cddfyKehGlX3zDHgH2T4iDSnyeJYRk
 apC5UDgEQuyMCx6T28L957WzOyszQjSKIp1+448kh2m2gN6gYaj0u2xrgY0yqUyenOop HQ== 
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.73.133])
        by mx0a-00230701.pphosted.com (PPS) with ESMTPS id 3k7v454ana-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 Oct 2022 14:30:47 -0700
Received: from mailhost.synopsys.com (sv2-mailhost2.synopsys.com [10.205.2.134])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id D7C5C40087;
        Mon, 17 Oct 2022 21:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1666042246; bh=Vc7km8K+CiNLrdn46QJNbYkbCfdQ4EkefMKinbEehIA=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=ZlB4Bm9ldOComqWM44RMjDZ6Rehbab9lL/I0JDiLR9MyxgPi+hM4lZH+zQUThJY9d
         g7kFSa95JEoVYRMUZJFvyQK5IH0hH9JjMMQY5sLEILdbMHBVyxu4HNGINn2P8WeVoj
         zp0X8AWimHiXWY6GrhZCbx5Ng6MOdlapBzczvaQeIdxo6yoSHuZrgbtZ0/Km7v+sM0
         pqfJP3VFPNNQw01D8yI1AsXa5scsYiOVFoZ+UXARdU1HXgclRefoLmy1M9VUJs/lnQ
         sdGXzFdfORCM4csnmz9AP0uDvPCOQheqZ7v0nUlQWJoF4JQDk2Bd6YLZLmmo8vDcmm
         fLnODe5z/59cQ==
Received: from o365relay-in.synopsys.com (us03-o365relay3.synopsys.com [10.4.161.139])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "o365relay-in.synopsys.com", Issuer "Entrust Certification Authority - L1K" (verified OK))
        by mailhost.synopsys.com (Postfix) with ESMTPS id 963C6A00A9;
        Mon, 17 Oct 2022 21:30:43 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.protection.outlook.com", Issuer "DigiCert Cloud Services CA-1" (verified OK))
        by o365relay-in.synopsys.com (Postfix) with ESMTPS id E9730800B1;
        Mon, 17 Oct 2022 21:30:41 +0000 (UTC)
Authentication-Results: o365relay-in.synopsys.com; dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relay-in.synopsys.com; spf=pass smtp.mailfrom=thinhn@synopsys.com
Authentication-Results: o365relay-in.synopsys.com;
        dkim=pass (1024-bit key; unprotected) header.d=synopsys.com header.i=@synopsys.com header.b="uH/vTIDd";
        dkim-atps=neutral
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lRtyomKDAXAKNztATKP42FN3QyoMmOtTlp3Jx48bH8a4A1aN4uzC2csd4ubO5YBglKqfHFN1/B8OmtRumgUBWeGdknDc2QuSeHHcNZsoWygJHWt4W5C3coykCXQBEaxzK5+zHrqc1aIFbB/a5nX1TYILYyRFxpFFjc3Ttp3lzECKlrfKgPpDv0oEUqyzyR88GRxC4A++ZbTqe2iPWL42eLMMQ61l+eMphNmeynE9IBS9jE4o31Cb4KAdkAtOR3/nbkJd5pFxeT3420ZuW5BOTAfL1qs20SWr6z04C7FxxizxOS9SLH44pKMWe9S1J5XIY7YwXwL4A2h18GeP+ii0wQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vc7km8K+CiNLrdn46QJNbYkbCfdQ4EkefMKinbEehIA=;
 b=J9xRi2Ku2tzqwe684nQuM2iLjKfYBhr2sFJjjvBcoT7xB4JViSRU0nXVlNrCzpYoUKdI3zbX/nBz7uScG5tZFAhm2PLw3iQUbb+AGp7oFNgWZUSjRHvQ2ALJh9caCMo88iYa9YikJfVQdp5YI/zgzJElnMHjEfqtt0EQL78znqrt243RIxkhrbgo3/ZJWxT9b4+S3E34FTPMAFYZQ/Uf09ujssgwttCbtSPNmBPsnuZ9tYwQ8VG7bJ9wxX+TD8S/ZBtzQnDyzbNGqWQKOmwEyRF+IfWEGjGg3flevwejbHLf3HKdhyRdOXoQIkBIkRnuByA0LjGlswPNdQkLDd3Xyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vc7km8K+CiNLrdn46QJNbYkbCfdQ4EkefMKinbEehIA=;
 b=uH/vTIDdnBvUW+bcjLiiS+IXVZBM0fmD1Fg2HlwRm6uDZiv3BpGCDUMh1rssm6pVKhqdccT6urLTmM9jnZdTg9tV3AkQOLH80psveodpCtCfw7Woh2CnMrUL43FYAEBUNEzeNswxxoq49sRXK1O/I5kUm3DdhxTMoKxxfqM6yk8=
Received: from BYAPR12MB4791.namprd12.prod.outlook.com (2603:10b6:a03:10a::12)
 by PH7PR12MB6660.namprd12.prod.outlook.com (2603:10b6:510:212::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.32; Mon, 17 Oct
 2022 21:30:39 +0000
Received: from BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::525b:92b6:eafc:8629]) by BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::525b:92b6:eafc:8629%7]) with mapi id 15.20.5676.031; Mon, 17 Oct 2022
 21:30:39 +0000
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
To:     Dan Vacura <w36195@motorola.com>
CC:     "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Daniel Scally <dan.scally@ideasonboard.com>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Jeff Vanhoof <qjv001@motorola.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Felipe Balbi <balbi@kernel.org>,
        Paul Elder <paul.elder@ideasonboard.com>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH v3 2/6] usb: dwc3: gadget: cancel requests instead of
 release after missed isoc
Thread-Topic: [PATCH v3 2/6] usb: dwc3: gadget: cancel requests instead of
 release after missed isoc
Thread-Index: AQHY4mrMbMdbRPcOxEKXMohPF6Ycjq4TGoiA
Date:   Mon, 17 Oct 2022 21:30:38 +0000
Message-ID: <20221017213031.tqb575hdzli7jlbh@synopsys.com>
References: <20221017205446.523796-1-w36195@motorola.com>
 <20221017205446.523796-3-w36195@motorola.com>
In-Reply-To: <20221017205446.523796-3-w36195@motorola.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR12MB4791:EE_|PH7PR12MB6660:EE_
x-ms-office365-filtering-correlation-id: aa0efca7-edbe-4b8c-dbb4-08dab086d5bd
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CmyMnV+slzlo49r+lYJFQvLL/zi7eWCma/FB8uFicBuywln6ncO/pTnyRtBcvjD8536Ncf3EWFhv+AudlOX24Bli1hSVV/MG0gpx8SLT0Mso0rZK9YVULZlRHCHRNQLNhu9Itw6OAxQOyvyQqCzPmXUgHXqP+BjbLcqsFtmep/ZdD2Bb3Jl9EGdFbzJg+af55K4o1/j8l32660+azQaznG0OdDEZH8HnKjfmA3UkZ/0Sg1mBvJJ3Fd/SXiO7daVzh+wqpVp6xFEDUeJcJeVvbKmnTGHSeSBWRWD2PUsv4MC/tNR0dFCxMwIEmQDgOxROAWPB0tYsVPEMlP47+BXw4Plbw0bmS8wlDIs1a1xy9xEdpgAp3sVdCiC+lwqREFrvWtJbPOPZoPFNQLgBkAvWryLtglhnDH1ssCCVo3nKwoqLEUnDKCVQCMR1AC6zfeczggYVz99WxDdSsneSNuhgXm/4VFw4Gg9IOrW9f0O8pFr3SmGMQFEAWMJnT80/X+OiUwuMi7jyYBVFEbseAx0CRAk2K3CWuRy+ueweH6xkA4DA4o9xvcGpyFZ87sR1DxSg/xdJi8OxAPk3OiqpQzGuO/WEKegO/x2xKU/W7pGqOvMWBv3eZ+X1OEj0893rOHD3mREcop/1U1CUcS0D1WiLkDcgukDyWxFaTdDFPPD1mL74Bxg0ZaRcfLm4QjcYzWVai0B1fx+YpCGieJ8uQeFlQJbCe3q3rrdtTSqwkgavMPF3ZLXQPLENe7+fHlFk2xnQaY7E2vNX02w2zk+IgaE7HA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4791.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(396003)(366004)(376002)(136003)(346002)(451199015)(186003)(36756003)(86362001)(2906002)(66476007)(8936002)(5660300002)(7416002)(41300700001)(66446008)(76116006)(64756008)(66556008)(66946007)(38100700002)(4326008)(8676002)(122000001)(316002)(6486002)(83380400001)(38070700005)(6916009)(54906003)(71200400001)(1076003)(2616005)(6512007)(26005)(6506007)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZlJ3azhYaDE1eXA5VlJjMlJGRDhZTGM5dnNvUUhQeXQvT0ZuSFhLbUtuelB5?=
 =?utf-8?B?UXFHOWZLNUU0WDg2ajlZYi9EU0VTRkVwNWR2SFFLMU9nWDZXR05WWmd2cWJN?=
 =?utf-8?B?eVVBRjl0a0xNaS83QnVRQ0VGTlpVMTdSd01ueDVVWlpXOHNoWVdIYjhybnZv?=
 =?utf-8?B?Y096WDR4R2lSSUFiQUg0elJTdmEvNDUvQ2xBZTJLRHczNEFHQytJZzNhNzlD?=
 =?utf-8?B?T3RqSm43M2VUQlNUVmowUy8xc3d0OTFQRjAxRUdZNFlPVHZTR0RHVmNLSWdK?=
 =?utf-8?B?REFpbWhRMUtYaEhUdURMZ3BxNFJWVUkvYjhxbkJydDZoZ01PRXhRMzBhckdj?=
 =?utf-8?B?MFV0MWFVc01NaVJLT1RJRXFOeE0xaHNlSlZDN3k3TTc0UFhGK3pBeHZBcU04?=
 =?utf-8?B?UFpTSG0wSkkzK1RrZ2ExN0V4VWhUMkduQ0F2a0FWZUpvdi85TENuVW1TVmg1?=
 =?utf-8?B?aHBFTjlkMHppL0pMOUhRYlp1RWJjSjRvakYvTzB3ZktJdThnL0oxbTRVUGxW?=
 =?utf-8?B?RG5iUVVvbXJiWm1tbEVLT3Z6UzVHaGdUT0FBS0EzeU5FYTRlNkdSSVJHTGEy?=
 =?utf-8?B?YWttaEN6QzIrMzJ6OHplRkpVeTd0RitJMGk0aFAyMCtYQUlLWGhFSkdCd1hT?=
 =?utf-8?B?SS96VTZRSXZQb3A3bnRGSEdpQUxHTHVTOUlCd09CSnV5cGQ3eFdIUk56bHh6?=
 =?utf-8?B?SkRRZFlaWTdFNzMvbk1iQmJvZFpxUlpyWDhVSkQ0Ry9SczNvT2R5OTJUaXg1?=
 =?utf-8?B?bm1ab1JPaXkzeS9NWXpVcFZHYkgvTWZzTmtXeTlZZGY2c25IVE0zTWhrcjNZ?=
 =?utf-8?B?bEhIbkJzQy9Lcmh0ZWZCTWt5c1VXTHlLaXNhNzQ3dHh0cWpPaEZITm02L090?=
 =?utf-8?B?azhpMDdKaEtZbHVrc0lwVWFtRmo4VW5TV2ltT3daaW1Pem14WFkyT3FET2pv?=
 =?utf-8?B?VXBoNDVidEZIQTVnaTVGM3AyeWljS2ZjbmdnaFQ3a3dHSG8xSUhoUEhTN0sz?=
 =?utf-8?B?eE55TUs1NThHNUR5TjhmSnBDOFdnSWxYaVZ1Vm1SSllOazVFdjRtMjBLdHB0?=
 =?utf-8?B?T2xSQUg0Q3k2RnY5ZVpnMXFURGRMUGM2S21zbzg1ZXpDR0VyUTMwa2xlQTFu?=
 =?utf-8?B?Ym1yMDRFTlFTQVRIT3RyU0JrYmxkdC9NQ3VaeVFNVG5YTXRsSGRka0VTY2lI?=
 =?utf-8?B?eGNDR3RMc2NpQUhBN2Qzek5mWVQ0OC9Fd3F0cDk0TFQ3NWs2Z3BLdDRTZlhG?=
 =?utf-8?B?U0x5azhGVGE3OUt6WWRsclk5V0lXNHpQMTBQZXRFdTdQOEltU2c5RDl0d3Nl?=
 =?utf-8?B?SWtHVitLSkloUk5PVjhMN2lGUnlkUEZhUWZmVGZIeW1EcmJjbHl6ZDM5cEtj?=
 =?utf-8?B?cWxhUGxWaU53SDRyMmh2c1IrMElCb3Q0bGhpc0dTZ0RFZmJmbDFONzJ6R1Vy?=
 =?utf-8?B?d0ozQnljQWtEOUlHRHpBUU15NDUzYWQ4UGZPYVk4dUF6UUdJb2hheVNVVzRY?=
 =?utf-8?B?RFpnL0RIc05yaVptczJ1MnI1VlVZMUdMSWdaS1d6NzRCbGhTM09BN2RrRHJD?=
 =?utf-8?B?SHhVUVZUWjM0MTUxd3lXcVJLbkdXSEd1V1FnbWpFWUc1eUczTkt6RDgzZk9C?=
 =?utf-8?B?MzI0MHRJenpYRUhKZGx5M1ZOSkZHa0cvV3dEVFprT0dQemE0UkNtL01oOVZ2?=
 =?utf-8?B?cmpOd3liUXNZRmx3NG13UC9sLzF2a3RVajlwMnQ4V0J0RkMrd3pEZkpUS0Ju?=
 =?utf-8?B?bDFCSWtzMWRZV2l6cG4rNEF0MnQzSDlkNUVES0IreWtHeCtscjh1TytQdXBh?=
 =?utf-8?B?UFprbURJbTA0MnRHVXlTcUtiU0JBRkdCWHNWTDFIY3AvSVVJaFhsVjZYOEdk?=
 =?utf-8?B?NXZFL29Sb1h1SWFCeHNlSGRRMWFIM1ovV1psYTJSalNhVEZteVZSU3BxSncv?=
 =?utf-8?B?eXY5Q3krL0UzbE1tOFg2LzJkZTVMWTlQMHk2a2tkWkIraDZzTys2REg4VzFG?=
 =?utf-8?B?Uy9YT0NwQ29ad1pwd0Z3azFkM1pNeWpYdUg4OXB5dGZ2WEtmaFZiVlYyeGpj?=
 =?utf-8?B?RDkyb1J5b2x2MWZLZG51Slh6SWwwU20wck81bEpsdWRNd2h3S0pRVXZ4NWtD?=
 =?utf-8?Q?9MzEcBmRXI0yzI3yGm0UgTxOB?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3ACF114F066D3D4D917FE9A8CE722449@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4791.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa0efca7-edbe-4b8c-dbb4-08dab086d5bd
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Oct 2022 21:30:38.4129
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RcENVT8dqR8fEEJfrMSj631yGSpkRFh7rCC6DsMVxtmcUmYSwF9OE11IBaDvMzyidkQD0shygdOk7d9a9+D2ow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6660
X-Proofpoint-GUID: bAsOmTVcYFR9FLo729Gnoi-pG2vYeKkH
X-Proofpoint-ORIG-GUID: bAsOmTVcYFR9FLo729Gnoi-pG2vYeKkH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-17_13,2022-10-17_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_active_cloned_notspam policy=outbound_active_cloned score=0
 priorityscore=1501 adultscore=0 clxscore=1011 malwarescore=0 bulkscore=0
 mlxlogscore=859 mlxscore=0 lowpriorityscore=0 phishscore=0 spamscore=0
 suspectscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2209130000 definitions=main-2210170123
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gTW9uLCBPY3QgMTcsIDIwMjIsIERhbiBWYWN1cmEgd3JvdGU6DQo+IEZyb206IEplZmYgVmFu
aG9vZiA8cWp2MDAxQG1vdG9yb2xhLmNvbT4NCj4gDQo+IGFybS1zbW11IHJlbGF0ZWQgY3Jhc2hl
cyBzZWVuIGFmdGVyIGEgTWlzc2VkIElTT0MgaW50ZXJydXB0IHdoZW4NCj4gbm9faW50ZXJydXB0
PTEgaXMgdXNlZC4gVGhpcyBjYW4gaGFwcGVuIGlmIHRoZSBoYXJkd2FyZSBpcyBzdGlsbCB1c2lu
Zw0KPiB0aGUgZGF0YSBhc3NvY2lhdGVkIHdpdGggYSBUUkIgYWZ0ZXIgdGhlIHVzYl9yZXF1ZXN0
J3MgLT5jb21wbGV0ZSBjYWxsDQo+IGhhcyBiZWVuIG1hZGUuICBJbnN0ZWFkIG9mIGltbWVkaWF0
ZWx5IHJlbGVhc2luZyBhIHJlcXVlc3Qgd2hlbiBhIE1pc3NlZA0KPiBJU09DIGludGVycnVwdCBo
YXMgb2NjdXJyZWQsIHRoaXMgY2hhbmdlIHdpbGwgYWRkIGxvZ2ljIHRvIGNhbmNlbCB0aGUNCj4g
cmVxdWVzdCBpbnN0ZWFkIHdoZXJlIGl0IHdpbGwgZXZlbnR1YWxseSBiZSByZWxlYXNlZCB3aGVu
IHRoZQ0KPiBFTkRfVFJBTlNGRVIgY29tbWFuZCBoYXMgY29tcGxldGVkLiBUaGlzIGxvZ2ljIGlz
IHNpbWlsYXIgdG8gc29tZSBvZiB0aGUNCj4gY2xlYW51cCBkb25lIGluIGR3YzNfZ2FkZ2V0X2Vw
X2RlcXVldWUuDQoNClRoaXMgZG9lc24ndCBzb3VuZCByaWdodC4gSG93IGRpZCB5b3UgZGV0ZXJt
aW5lIHRoYXQgdGhlIGhhcmR3YXJlIGlzDQpzdGlsbCB1c2luZyB0aGUgZGF0YSBhc3NvY2lhdGVk
IHdpdGggdGhlIFRSQj8gRGlkIHlvdSBjaGVjayB0aGUgVFJCJ3MNCkhXTyBiaXQ/DQoNClRoZSBk
d2MzIGRyaXZlciB3b3VsZCBvbmx5IGdpdmUgYmFjayB0aGUgcmVxdWVzdHMgaWYgdGhlIFRSQnMg
b2YgdGhlDQphc3NvY2lhdGVkIHJlcXVlc3RzIGFyZSBjb21wbGV0ZWQgb3Igd2hlbiB0aGUgZGV2
aWNlIGlzIGRpc2Nvbm5lY3RlZC4NCklmIHRoZSBUUkIgaW5kaWNhdGVkIG1pc3NlZCBpc29jLCB0
aGF0IG1lYW5zIHRoYXQgdGhlIFRSQiBpcyBjb21wbGV0ZWQNCmFuZCBpdHMgc3RhdHVzIHdhcyB1
cGRhdGVkLg0KDQpUaGVyZSdzIGEgc3BlY2lhbCBjYXNlIHdoaWNoIGR3YzMgbWF5IGdpdmUgYmFj
ayByZXF1ZXN0cyBlYXJseSBpcyB0aGUNCmNhc2Ugb2YgdGhlIGRldmljZSBkaXNjb25uZWN0aW5n
LiBUaGUgcmVxdWVzdHMgc2hvdWxkIGJlIHJldHVybmVkIHdpdGgNCi1FU0hVVERPV04sIGFuZCB0
aGUgZ2FkZ2V0IGRyaXZlciBzaG91bGRuJ3QgYmUgcmUtdXNpbmcgdGhlIHJlcXVlc3RzIG9uDQpk
ZS1pbml0aWFsaXphdGlvbiBhbnl3YXkuDQoNCldlIHNob3VsZCBub3QgaXNzdWUgRW5kIFRyYW5z
ZmVyIGNvbW1hbmQganVzdCBiZWNhdXNlIG9mIG1pc3NlZCBpc29jLiBXZQ0KbWF5IHdhbnQgaXNz
dWUgRW5kIFRyYW5zZmVyIGlmIHRoZSBnYWRnZXQgZHJpdmVyIGlzIHRvbyBzbG93IGFuZCB1bmFi
bGUNCnRvIGZlZWQgcmVxdWVzdHMgaW4gdGltZSAoY2F1c2luZyB1bmRlcnJ1biBhbmQgbWlzc2Vk
IGlzb2MpIHRvIHJlc3luYw0Kd2l0aCB0aGUgaG9zdCwgYnV0IHdlIGFscmVhZHkgaGFuZGxlIHRo
YXQuDQoNCkknbSBzdGlsbCBub3QgY2xlYXIgd2hhdCdzIHRoZSBwcm9ibGVtIHlvdSdyZSBzZWVp
bmcuIERvIHlvdSBoYXZlIHRoZQ0KY3Jhc2ggbG9nPyBUcmFjZXBvaW50cz8NCg0KQlIsDQpUaGlu
aA==
