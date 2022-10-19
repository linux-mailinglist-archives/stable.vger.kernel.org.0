Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 699F86053B5
	for <lists+stable@lfdr.de>; Thu, 20 Oct 2022 01:06:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231548AbiJSXGm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 19:06:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230341AbiJSXGl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 19:06:41 -0400
Received: from mx0a-00230701.pphosted.com (mx0a-00230701.pphosted.com [148.163.156.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A436631E7;
        Wed, 19 Oct 2022 16:06:38 -0700 (PDT)
Received: from pps.filterd (m0297266.ppops.net [127.0.0.1])
        by mx0a-00230701.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29JKU2UE017399;
        Wed, 19 Oct 2022 16:06:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfptdkimsnps;
 bh=FQD8y+eX7f8slNlCegg7KGUgxvfQPNrclKL5UEpDUqA=;
 b=i3mQqAAlSzuRANig/6L3v2svGbUfhgeA3EtPkh5Bj/KcrfBFONNL/7576pm1Mmigaw0i
 qgQj4gCh7iLATyiBCbudB6tt5Ar00vpofyG97rjOrHcGwQ5Ro6KWONkJZL+w3NagMS0b
 z1KUi0b+835FHFxzBWJOXbLOi9jVVJ9E4h/id7au8wzVCUvdNRXTvIWovRDfuEon+FrB
 lWcpH1cELpJpBdR7E9UrL9U0QrrVCxpLN7Bb9728XHAJRN/QZOTcKNHiuCZtu5a5K7P3
 Wli2EGvBC7Cdl5ct4a//0vX88uiGLN0vW5cbxzloR3hwgQ1sh40Drud+xfn+2j5Cbt3H 4A== 
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.87.133])
        by mx0a-00230701.pphosted.com (PPS) with ESMTPS id 3k7v45kkqh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Oct 2022 16:06:18 -0700
Received: from mailhost.synopsys.com (badc-mailhost1.synopsys.com [10.192.0.17])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 615ABC0103;
        Wed, 19 Oct 2022 23:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1666220777; bh=FQD8y+eX7f8slNlCegg7KGUgxvfQPNrclKL5UEpDUqA=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=QGSRkdbhkjA0JhSldiLloJa3lX0hCPnzkK3mASGou5eC4SpkPQVZhfa6uiLx8A8U4
         jrvRWRz48eh4DJHv3ugp66rsvgh+WYLUDTQDsgZoSDrMJMe7NmJEQX1Q1ChKeloGUS
         PlRRTIGwr5g5jdhQIwr4wSUjQIY404uKj+mWo9glWqIGsyv1ZxaPxmMRV45rLcnbKU
         XpYoHCS/3ur6CFy3Zy1nELPw3NOeXyGW8TMqhvzfXGUi8E6uqhXweAJ+Bq/EHhrmSl
         dGaq0msv314DgZVxHZJycTXgKtDEevMZPUsc8CzF7gSA+NRp09lekGNDGfgESwPiDo
         cXBrdXSye2vUw==
Received: from o365relay-in.synopsys.com (us03-o365relay1.synopsys.com [10.4.161.137])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "o365relay-in.synopsys.com", Issuer "Entrust Certification Authority - L1K" (verified OK))
        by mailhost.synopsys.com (Postfix) with ESMTPS id F0864A005A;
        Wed, 19 Oct 2022 23:06:13 +0000 (UTC)
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2040.outbound.protection.outlook.com [104.47.57.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.protection.outlook.com", Issuer "DigiCert Cloud Services CA-1" (verified OK))
        by o365relay-in.synopsys.com (Postfix) with ESMTPS id B327C80083;
        Wed, 19 Oct 2022 23:06:11 +0000 (UTC)
Authentication-Results: o365relay-in.synopsys.com; dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relay-in.synopsys.com; spf=pass smtp.mailfrom=thinhn@synopsys.com
Authentication-Results: o365relay-in.synopsys.com;
        dkim=pass (1024-bit key; unprotected) header.d=synopsys.com header.i=@synopsys.com header.b="cZuZFWEy";
        dkim-atps=neutral
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PVwNVFIvzQLyAdw68ksvljLLb2C/Y4eiGrf1CaJ+bpB0wm9NuNR8wD/kJd4UIn2DJoohIK4e9DzEnxoT02+Dvg5md2D3aYiV1+jHztft70VfQDGWVnM1Dp+sfe8gva6xb+5wcP4852DVkbdziv4qTb1yPit2X5e5OPvX7lv51AhFgNw1iaPQzHxfMrRhYFEm0yGZWWue2k1kXt56he0lFvIPj2QbRndRYuGV7lGRZUALxhm5B7xi9LE7ZziMSx7qxa3AYD1ZBV3H6UzqfCS6vYGdZST5xDCWr1g+n2QmhMSXhShRRTa1R2zriJENrNJz0BnUBRwMhoZXxVin8ku4Xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FQD8y+eX7f8slNlCegg7KGUgxvfQPNrclKL5UEpDUqA=;
 b=hHhGNmhEF5j9RD/+cTTkGw0bQwSJPGBXcnla/nM3+XGVNvG7UAFtq2M8yRBOVc4Yko+H1lWMnksuV6isux/uBYilAnu1mxzM+2iDVdsiKYl5XtajrFxHHc/RicJ4S00dTekqhwq4cDVV+thZYGwNZK66qH43MPa50/hywfZctANie0STVy4uWLNVvmdwv6QUGjKSgtlc1viqG0jEc8ffuuPgQFLSCH66h8yteIuD3wjbZjqK7B6VWMX0dGT9y+oOMGWJZGvOe5MGQ+CkARW5fsl2O62fvuOT6LJGqJ5qXDvilJ/q2kCGBl1k/G0rc7gukpO2lNgo8T+R1G4TYyTY8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FQD8y+eX7f8slNlCegg7KGUgxvfQPNrclKL5UEpDUqA=;
 b=cZuZFWEySKuGaQAC/vkSr9AGJRmEcGhcLx+s8XYDRQRH7GROZOO52TGiTAaQfLYtnNP7RQc0qVQla/8QDqgCd8AOuXOgojl6BqyJK+0fA98KMzxyQxUwo4fz0+Dy+Wx14dEdXcJvy7ifIZlLb5NHdShOAD7HzOJqyDQux9FOmDs=
Received: from BYAPR12MB4791.namprd12.prod.outlook.com (2603:10b6:a03:10a::12)
 by PH7PR12MB6634.namprd12.prod.outlook.com (2603:10b6:510:211::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.32; Wed, 19 Oct
 2022 23:06:08 +0000
Received: from BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::525b:92b6:eafc:8629]) by BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::525b:92b6:eafc:8629%7]) with mapi id 15.20.5676.031; Wed, 19 Oct 2022
 23:06:08 +0000
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
Thread-Index: AQHY4zLbXRUpqdOqTUOotJbe2PZC1K4UvWqAgAAz6gCAAAYCAIAAXncAgADAGYCAACjDAIAAGaCA
Date:   Wed, 19 Oct 2022 23:06:08 +0000
Message-ID: <20221019230555.gwovdtmnopwacirt@synopsys.com>
References: <PUZPR03MB613101A170B0034F55401121A1289@PUZPR03MB6131.apcprd03.prod.outlook.com>
 <20221018223521.ytiwqsxmxoen5iyt@synopsys.com>
 <20221019014108.GA5732@qjv001-XeonWs>
 <20221019020240.exujmo7uvae4xfdi@synopsys.com>
 <20221019074043.GA19727@qjv001-XeonWs>
 <20221019190819.m35ai5fm3g5qpgqj@synopsys.com>
 <20221019213410.GA17789@qjv001-XeonWs>
In-Reply-To: <20221019213410.GA17789@qjv001-XeonWs>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR12MB4791:EE_|PH7PR12MB6634:EE_
x-ms-office365-filtering-correlation-id: 164feaab-b1ae-4d99-6ddd-08dab22681dd
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3f5m5NeqE4aCSHZPNOWGid8/m9XWXZCiFasABIabPD74LQhdBkF96BsV3gCwWaUykPOgd0v0rQXtdZXtKrucYNVkH2rQhW1Xm2ocUIkmreJ/PExEsoZCRwZjQEJS2CCOjxLXy5dathRMPbIx3K69cxOoCPZI/1+Ev+gnGd0LZVUekIOS28ybB1hXKrlLW2JwlH2MV4XXS8yT9Z9VTwu5Q39CMkODaeAACqfk3O0R2pn1YKTAfKJyxDH5ykdOW7r9FmVLrV6xObGXOaE3ESnhzhRVFy5CKLlml5oAWu9uHQWIPn6vKvkQ9L8cVAgJbYjd9I9vzqcawklMVeZEOELxz2XJ3qzfCSWV6AeLUQ6KZTqpZuS59IgJo0XWDbg95j6BWRkun/TRjRMzgo12jbt/5rVJ6Y4+K+R7cB8rjX3gABe5f2xey9pEpOdlLNfUWh2UVnjhbUdSiUfs3TACkA+IcGgCCpo3GrT0lUcxIq+by7pT7GcqMGrWRF9fV5If4CLxZer1ndGkjkpYsPQ23QrFQDMGgBzcZtdPzt0DGoE9/nThH+7Gpox0QqB6TirNmnovhMPPoXbN5oIUyuNE1Ozkbx8nnk73TzDqfPWtgieFGJcWri4pcqmnl5X/xk1OaRyB7CY6g0wP9gzoP9WO0pHcGYvke8ezi1/OnREG5uPKUpwycQe5tLEzQWAWRHYFk5mv6X+JNWurUhwIDLq/Rv4oo5oP6JlGogeJsuaOo++YdNzUrGcSTL1EyFmvXHgNoEFszEqAY/HhJtZBWRlI5EbPSjRyM6MAYaL+vxxu0w8Xd0g=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4791.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(376002)(39860400002)(396003)(346002)(366004)(451199015)(6486002)(6916009)(316002)(71200400001)(54906003)(478600001)(26005)(76116006)(66556008)(66446008)(1076003)(186003)(66946007)(4326008)(2906002)(8676002)(64756008)(66476007)(7416002)(8936002)(6512007)(6506007)(41300700001)(5660300002)(2616005)(36756003)(966005)(86362001)(83380400001)(38100700002)(38070700005)(122000001)(3716004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?d3NUV3UvSSt4Uks0TU1YMDhGVTYzMEsvc0dzcTdYTkQyWnlsYk9nN2xvVFBF?=
 =?utf-8?B?Nkh3c0V4dThUM0VyaVB5cTExNzgyLzVUbWtUTm4vck1PY1lKR3pMSEc0cTB4?=
 =?utf-8?B?ZHR6Y05Pb2d6TTZpT3B5ek5ObDRBNVg3cS9MbEozdUYrRTRkSEVlYzB0YXBl?=
 =?utf-8?B?L1QyVk9STWxxRWxLa0Q3bmM5L25yRmRsTjM1cGVEOXIxcDVUREZuVEptYWZr?=
 =?utf-8?B?MjloZ2V2OEtyeXhwdXJpNGpKZ0hPck9oVWROck1DZ2NBZnZxeUsrOGVsMENa?=
 =?utf-8?B?QXUxMnkxY1ZWSGtIbWpMTG9TVWhkNHBXaGkvVk9nRVRYY09GQmlqS3lpK3F5?=
 =?utf-8?B?Ui94aktDeVFxb2Zady9DandkSjBJVXhiQWtsMC9lanN4bkNxazBHOHI5bGZT?=
 =?utf-8?B?WmtGVlJsVFM2ajN4ODFWSUtsYjFkU0p1eGVQM0Q0S1lLNWR4V3dPWHBNOTFV?=
 =?utf-8?B?enRMamJveUtpb0d1bzFwSWM4NzRIbWZSaGM2SzRISVR1aytEbUZnTFA2M1or?=
 =?utf-8?B?VHJUOEpEZzIyNkdMV2RZdkxYdTJucWZVR0tCeEsrVk5SNEVXVWVOdkU4Y3Vy?=
 =?utf-8?B?Q1Fndm5vMjM3TWxLUU13LzNqSmhZcnE0ZTkvaEJYeDZ4UElGTzBuc3JQOHUw?=
 =?utf-8?B?b2hTbDFGQXpJalVDQWxRTmkzQndScUV4cjh5cVZyQ2VzOWhoN0tycklUZFFi?=
 =?utf-8?B?SlZhOURDblZsZGpjbStIK0JKeUhOL2IvN0xmTVRHRVlseDhlUzBMc3JnNndx?=
 =?utf-8?B?TWk3NTJCZnozNFZBdGRRbHVHbWl3OXpYUmhweGxDZlk3Y1lOaTNCL3dZam1n?=
 =?utf-8?B?U1ZkZjFDNDd2Z2VPK0kwU0p4TlZ0QTloVXZYc215cGZjaTErV2NVZ1ZBT1A3?=
 =?utf-8?B?MWhFbFVxOCtzZi8wUEQvVldyZENSdFUwZGtyR1hTNVlDU2h5L2o4R01PQUwv?=
 =?utf-8?B?UTk2SXFEY1Y5T3dZMUhRS09rMVc0VzRndTQ2cW8ySzJ4TEk5d05RbmFhYkZO?=
 =?utf-8?B?U1RZUDJKU1MwdXhiMW9lNmZvdFlVaU9LNmh3N080OUVSVWIvKzAvU0dacFJY?=
 =?utf-8?B?cFZMTG0yZDdyWTJURERiWXZTQXFsR1dRSGUwUHdFNXRLUFplaDEvK01wY1VD?=
 =?utf-8?B?R1BacEhObnVSSXUxTXhzZnFuTjF5ZDVoSFY0TFpEeXdVY0Q2Y3dSSnA4ZitW?=
 =?utf-8?B?bzhpK0RyRkptbmppUHI5RGpCTVBSVy9la3Y0WURNazV2TmZ2UWNmZEQ5bGh0?=
 =?utf-8?B?d1J1a1lHZ1NNWjRiWHZOblhManVMSlRTUkRpTXhxY3UySFREay9oNW16Um1X?=
 =?utf-8?B?enRabG5LY1dxSG1GUWd1OVFMN1plajBSQUpHd25BMjZFVWFxbHNmWW5yNjhH?=
 =?utf-8?B?K1ozdlZmVCtRT2RXcnZFb2lHR3I3M0VSdzF1RGlzTnhYTFB3TnhqcFE4VVR1?=
 =?utf-8?B?N04yY1JpeFUwNy9XaUVyUzNqSGowb01jNGdvVE5hY1lrMTlUZHRzcFVaVGFl?=
 =?utf-8?B?Y3M2MjMzMlFNWUQ5RzVERGxTdnQxalFMYWJ5TjdmOHd1VWZTSXgrVVNDNGFo?=
 =?utf-8?B?L2hWSnhVWUhNZXJKdWdwQmUwRWpoeG1uTDZURkhjTE43c3pXUkZURWJLb0Fs?=
 =?utf-8?B?TUt5aVBSSzE1LzFoRlVDZlNyZ2x3cWJkT3NabmpITzhsYm1Qdk94b3p0OFh3?=
 =?utf-8?B?Z0UvK2NKdHhsdmdkckhrQlFxUDFJcUFsMXhONi9jQXJYaHAzOFpuaTFuNld3?=
 =?utf-8?B?aG5naVNtcE1GVEpJeXpVN0RLQ1NsNVdRM1hKcWZPVkZhakVacGJncjRvUThK?=
 =?utf-8?B?YTJJODdvNWlTVjJ1Zkh0SitvOFpzZ3FkT1ExV25kcmw4ODZUejhVaENqQTZL?=
 =?utf-8?B?RlJHdUxjZS83TnFIWW8rTW9qeVJNSDhIZ05OQktxQmJNMXBMMnBxT1BEdFlB?=
 =?utf-8?B?cXJWZGlmYUdIeWFRVXNvR3cxSDk1VzBUMlgxUTVqK3BOcUVNdkhPTUQ2SFpW?=
 =?utf-8?B?aHpVTnhHQjlIUmlBK0VtT3VqSmUvKzI0OUJuMEt5S2x5QnFTb05OVGlSVEc3?=
 =?utf-8?B?aDloMHV3UWNQRURjRVc2TURjMy9wT0tsVWE5SE9FSHBLb0pSa3h0SmYvNXpH?=
 =?utf-8?Q?9nS/oGu5otgqz73O5Wc8m90l7?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4139778C14BB434484C55024109F1620@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4791.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 164feaab-b1ae-4d99-6ddd-08dab22681dd
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Oct 2022 23:06:08.2995
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ww38qajwbfFg0Ya0MJPyc18kDZxYQmqqtm3KC8o2AwWp03tiJXAy8wFqGKnJZ5KwRxxtHS7A60NK93cj1xA45Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6634
X-Proofpoint-GUID: GqnsOW-TJ32_vQulfXBr9rneiVCu8CHS
X-Proofpoint-ORIG-GUID: GqnsOW-TJ32_vQulfXBr9rneiVCu8CHS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-19_12,2022-10-19_04,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_active_cloned_notspam policy=outbound_active_cloned score=0
 priorityscore=1501 adultscore=0 clxscore=1015 malwarescore=0 bulkscore=0
 mlxlogscore=999 mlxscore=0 lowpriorityscore=0 phishscore=0 spamscore=0
 suspectscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2209130000 definitions=main-2210190129
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGksDQoNCk9uIFdlZCwgT2N0IDE5LCAyMDIyLCBKZWZmIFZhbmhvb2Ygd3JvdGU6DQo+IEhpIFRo
aW5oLA0KPiBPbiBXZWQsIE9jdCAxOSwgMjAyMiBhdCAwNzowODoyN1BNICswMDAwLCBUaGluaCBO
Z3V5ZW4gd3JvdGU6DQo+ID4gT24gV2VkLCBPY3QgMTksIDIwMjIsIEplZmYgVmFuaG9vZiB3cm90
ZToNCg0KPHNuaXA+DQoNCj4gPiA+IA0KPiA+ID4gRnJvbSB3aGF0IEkgY2FuIGdhdGhlciBmcm9t
IHRoZSBsb2csIHdpdGggdGhlIGN1cnJlbnQgY2hhbmdlcyBpdCBzZWVtcyB0aGF0DQo+ID4gPiBh
ZnRlciBhIG1pc3NlZCBpc29jIGV2ZW50IGZldyByZXF1ZXN0cyBhcmUgc3RheWluZyBsb25nZXIg
dGhhbiBleHBlY3RlZCBpbiB0aGUNCj4gPiA+IHN0YXJ0ZWRfbGlzdCAobm90IGdldHRpbmcgcmVj
bGFpbWVkKSBhbmQgdGhpcyBpcyBwcmV2ZW50aW5nIHRoZSB0cmFuc21pc3Npb24NCj4gPiA+IGZy
b20gc3RvcHBpbmcvc3RhcnRpbmcgYWdhaW4sIGFuZCBvcGVuaW5nIHRoZSBkb29yIGZvciBjb250
aW51b3VzIHN0cmVhbSBvZg0KPiA+ID4gbWlzc2VkIGlzb2MgZXZlbnRzIHRoYXQgY2F1c2Ugd2hh
dCBhcHBlYXJzIHRvIHRoZSB1c2VyIGFzIGEgZnJvemVuIHZpZGVvLg0KPiA+ID4gDQo+ID4gPiBT
byBvbmUgdGhvdWdodCwgaWYgSU9DIGJpdCBpcyBub3Qgc2V0IGV2ZXJ5IGZyYW1lLCBidXQgSU1J
IGJpdCBpcywgd2hlbiBhDQo+ID4gPiBtaXNzZWQgaXNvYyByZWxhdGVkIGludGVycnVwdCBvY2N1
cnMgaXQgc2VlbXMgbGlrZWx5IHRoYXQgbW9yZSB0aGFuIG9uZSB0cmINCj4gPiA+IHJlcXVlc3Qg
d2lsbCBuZWVkIHRvIGJlIHJlY2xhaW1lZCwgYnV0IHRoZSBjdXJyZW50IHNldCBvZiBjaGFuZ2Vz
IGlzIG5vdA0KPiA+ID4gaGFuZGxpbmcgdGhpcy4NCj4gPiA+IA0KPiA+ID4gSW4gdGhlIGdvb2Qg
dHJhbnNmZXIgY2FzZSB0aGlzIGlzc3VlIHNlZW1zIHRvIGJlIHRha2VuIGNhcmUgb2Ygc2luY2Ug
dGhlIElPQw0KPiA+ID4gYml0IGlzIG5vdCBzZXQgZXZlcnkgZnJhbWUgYW5kIHRoZSByZWNsYWlt
YXRpb24gd2lsbCBsb29wIHRocm91Z2ggZXZlcnkgaXRlbSBpbg0KPiA+ID4gdGhlIHN0YXJ0ZWRf
bGlzdCBhbmQgb25seSBzdG9wIGlmIHRoZXJlIGFyZSBubyBhZGRpdGlvbmFsIHRyYnMgb3IgaWYg
b25lIGhhcw0KPiA+IA0KPiA+IEl0IHNob3VsZCBzdG9wIGF0IHRoZSByZXF1ZXN0IHRoYXQgYXNz
b2NpYXRlZCB3aXRoIHRoZSBpbnRlcnJ1cHQgZXZlbnQsDQo+ID4gd2hldGhlciBpdCdzIGJlY2F1
c2Ugb2YgSU1JIG9yIElPQy4NCj4gDQo+IEluIHRoaXMgY2FzZSBJIHdhcyBjb25jZXJuZWQgdGhh
dCBpZiBtdWx0aXBsZWQgcXVldWVkIHJlcXMgZGlkIG5vdCBoYXZlIElPQyBiaXQNCj4gc2V0LCBi
dXQgdGhlcmUgd2FzIGEgbWlzc2VkIGlzb2Mgb24gb25lIG9mIHRoZSBsYXN0IHJlcXMsIHdoZXRo
ZXIgb3Igbm90IHdlIHdvdWxkDQo+IHJlY2xhaW0gYWxsIG9mIHRoZSByZXF1ZXN0cyB1cCB0byB0
aGUgbWlzc2VkIGlzb2MgcmVsYXRlZCByZXEuIEknbSBub3Qgc3VyZSBpZg0KPiBteSBjb25jZXJu
IGlzIHZhbGlkIG9yIG5vdC4NCj4gDQoNClRoZXJlIHNob3VsZCBiZSBubyBwcm9ibGVtLiBJZiB0
aGVyZSdzIGFuIGludGVycnVwdCBldmVudCBpbmRpY2F0aW5nIGENClRSQiBjb21wbGV0aW9uLCB0
aGUgZHJpdmVyIHdpbGwgZ2l2ZSBiYWNrIGFsbCB0aGUgcmVxdWVzdHMgdXAgdG8gdGhlDQpyZXF1
ZXN0IGFzc29jaWF0ZWQgd2l0aCB0aGUgaW50ZXJydXB0IGV2ZW50LCBhbmQgdGhlIGNvbnRyb2xs
ZXIgd2lsbA0KY29udGludWUgcHJvY2Vzc2luZyB0aGUgcmVtYWluaW5nIFRSQnMuIE9uIHRoZSBu
ZXh0IFRSQiBjb21wbGV0aW9uDQpldmVudCwgdGhlIGRyaXZlciB3aWxsIGFnYWluIGdpdmUgYmFj
ayBhbGwgdGhlIHJlcXVlc3RzIHVwIHRvIHRoZQ0KcmVxdWVzdCBhc3NvY2lhdGVkIHdpdGggdGhh
dCBldmVudC4NCg0KPiA+IA0KPiA+ID4gaXRzIEhXTyBiaXQgc2V0LiBBbHRob3VnaCBJIGFtIGEg
Yml0IHN1cnByaXNlZCB0aGF0IHdlIGFyZSBub3QgeWV0IHNlZWluZyBpb21tdQ0KPiA+ID4gcmVs
YXRlZCBwYW5pY3MgaGVyZSB0b28gc2luY2UgdGhlIHRyYiBpcyBiZWluZyByZWNsYWltZWQgYW5k
IGdpdmVuIGJhY2sgZXZlbg0KPiA+ID4gdGhlIEhXTyBiaXQgc3RpbGwgc2V0LCBidXQgbWF5YmUg
SSBhbSBtaXN1bmRlcnN0YW5kaW5nIHNvbWV0aGluZy4gSW4gbXkgZWFybGllcg0KPiA+ID4gdGVz
dGluZywgaWYgYSBtaXNzZWQgaXNvYyBldmVudCB3YXMgcmVjZWl2ZWQgYW5kIHdlIGF0dGVtcHRl
ZCB0bw0KPiA+ID4gcmVjbGFpbS9naXZlYmFjayBhIHRyYiB3aXRoIGl0cyBIV08gYml0IHNldCwg
YSBpb21tdSByZWxhdGVkIHBhbmljIHdvdWxkIGJlDQo+ID4gPiBzZWVuLg0KPiA+IA0KPiA+IElm
IHRoZSBjb250cm9sbGVyIHByb2Nlc3NlZCB0aGUgVFJCLCBpdCB3b3VsZCBjbGVhciB0aGUgSFdP
IGJpdCBhZnRlcg0KPiA+IGNvbXBsZXRpb24uIFRoZXJlIGFyZSBjYXNlcyB3aGljaCB0aGUgSFdP
IGJpdCBpcyBzdGlsbCBzZXQgZm9yIHNvbWUNCj4gPiBUUkJzLCBidXQgdGhlIHJlcXVlc3QgaXMg
Y29tcGxldGVkIChlLmcuIHNob3J0IHRyYW5zZmVycyBjYXVzaW5nIHRoZQ0KPiA+IGNvbnRyb2xs
ZXIgdG8gc3RvcCBwcm9jZXNzaW5nIGZ1cnRoZXIpLiBUaGF0IHRob3NlIGNhc2VzLCB0aGUgZHJp
dmVyDQo+ID4gd291bGQgY2xlYXIgdGhlIEhXTyBiaXQgbWFudWFsbHkuDQo+ID4gDQo+ID4gPiAN
Cj4gPiA+IENhbiB5b3UgcHJvcG9zZSBhbiBhZGRpdGlvbmFsIGNoYW5nZSB0byBoYW5kbGUgZnJl
ZWluZyB1cCB0aGUgZXh0cmEgdHJicyBpbiB0aGUNCj4gPiA+IG1pc3NlZCBpc29jIGNhc2U/IEkg
dGhpbmsgdGhhdCBzb21laG93IHRoZSBIV08gYml0IHNob3VsZCBiZSBjaGVja2VkIGJlZm9yZQ0K
PiA+ID4gZW50ZXJpbmcgZHdjM19nYWRnZXRfZXBfY2xlYW51cF9jb21wbGV0ZWRfcmVxdWVzdCBp
biBvcmRlciB0byBhdm9pZCB0aGUgdHJiDQo+ID4gPiBiZWluZyBnaXZlbiBiYWNrIHRvbyBzb29u
Lg0KPiA+IA0KPiA+IFdlIHNob3VsZCBub3QgY2hlY2sgZm9yIFRSQnMgb2YgcmVxdWVzdHMgYmV5
b25kIHRoZSByZXF1ZXN0IGFzc29jaWF0ZWQNCj4gPiB3aXRoIHRoZSBpbnRlcnJ1cHQgZXZlbnQu
DQo+ID4gDQo+ID4gPiANCj4gPiA+IFlvdXIgdGhvdWdodHM/DQo+ID4gPiANCj4gPiANCj4gPiBU
aGUgY2FwdHVyZSBzaG93cyB1bmRlcnJ1biwgYW5kIGl0IGNhdXNlcyBtaXNzZWQgaXNvYy4NCj4g
PiANCj4gPiBMZXQncyB0YWtlIGEgbG9vayBhdCB0aGUgZmlyc3QgbWlzc2VkIGlzb2MgcmVxdWVz
dCAocmVxIGZmZmZmZjg4ZjgzNGRiMDApDQo+ID4gDQo+ID4gICAgICAgICAgICA8Li4uPi0yMjU1
MSAgIFswMDJdIGQuLjIgMTM5ODUuNzg5Njg0OiBkd2MzX2VwX3F1ZXVlOiBlcDJpbjogcmVxIGZm
ZmZmZjg4ZjgzNGRiMDAgbGVuZ3RoIDAvNDkxNTIgenNpID09PiAtMTE1DQo+ID4gICAgICAgICAg
ICA8Li4uPi0yMjU1MSAgIFswMDJdIGRuLjIgMTM5ODUuNzg5NzI4OiBkd2MzX3ByZXBhcmVfdHJi
OiBlcDJpbjogdHJiIGZmZmZmZmMwMTYwNzE5NzAgKEUxNTI6RDE0OSkgYnVmIDAwMDAwMDAwZWE4
MDAwMDAgc2l6ZSAxeCA0OTE1MiBjdHJsIDAwMDAwNDYxIChIbGNzOlNjOmlzb2MtZmlyc3QpDQo+
ID4gDQo+ID4gRWFjaCByZXF1ZXN0IHVzZXMgYSBvbmUgVFJCLiBGcm9tIGFib3ZlLCB5b3UgY2Fu
IHNlZSB0aGF0IHRoZXJlIGFyZSBvbmx5DQo+ID4gMyBpbnRlcnZhbHMgcHJlcGFyZWQgKEUxNTIg
LSBEMTQ5ID0gMykuDQo+ID4gDQo+ID4gVGhlIHRpbWVzdGFtcCBvZiB0aGUgbGFzdCByZXF1ZXN0
IGNvbXBsZXRpb24gaXMgMTM5ODUuNzg4OTE5Lg0KPiA+IFRoZSB0aW1lc3RhbXAgd2hpY2ggdGhl
IHF1ZXVlZCByZXF1ZXN0IGlzIDEzOTg1Ljc4OTcyOC4NCj4gPiBXZSBjYW4gcm91Z2hseSBlc3Rp
bWF0ZSB0aGUgZGlmZiBpcyBhdCBsZWFzdCA4MDl1cy4NCj4gPiANCj4gPiAzIGludGVydmFscyAo
M3gxMjV1cykgaXMgbGVzcyB0aGFuIDgwOXVzLiBTbyBtaXNzZWQgaXNvYyBpcyBleHBlY3RlZDoN
Cj4gPiANCj4gPiAgICAgaXJxLzM5OS1kd2MzLTE1MjY5ICAgWzAwMl0gZC4uMSAxMzk4NS43OTA3
NTQ6IGR3YzNfZXZlbnQ6IGV2ZW50IChmOWFjYzA4YSk6IGVwMmluOiBUcmFuc2ZlciBJbiBQcm9n
cmVzcyBbNjM5MTZdIChzSU0pDQo+ID4gICAgIGlycS8zOTktZHdjMy0xNTI2OSAgIFswMDJdIGQu
LjEgMTM5ODUuNzkwNzU4OiBkd2MzX2NvbXBsZXRlX3RyYjogZXAyaW46IHRyYiBmZmZmZmZjMDE2
MDcxOTcwIChFMTU0OkQxNTIpIGJ1ZiAwMDAwMDAwMGVhODAwMDAwIHNpemUgMXggNDkxNTIgY3Ry
bCAzZTZhMDQ2MCAoaGxjczpTYzppc29jLWZpcnN0KQ0KPiA+ICAgICBpcnEvMzk5LWR3YzMtMTUy
NjkgICBbMDAyXSBkLi4xIDEzOTg1Ljc5MDgwODogZHdjM19nYWRnZXRfZ2l2ZWJhY2s6IGVwMmlu
OiByZXEgZmZmZmZmODhmODM0ZGIwMCBsZW5ndGggMC80OTE1MiB6c2kgPT0+IC0xOA0KPiA+IA0K
PiA+IA0KPiA+IEFmdGVyIHRoaXMgcG9pbnQsIHRoZSB1dmMgZHJpdmVyIGtlZXBzIHBsYXlpbmcg
Y2F0Y2ggdXAgdG8gc3RheSBpbiBzeW5jDQo+ID4gd2l0aCB0aGUgaG9zdC4gSXQgdHJpZXMsIGJ1
dCBpdCBjb3VsZG4ndCBjYXRjaCB1cC4gQWxzbywgb2NjYXNpb25hbGx5DQo+ID4gc29tZXRoaW5n
IHNlZW1zIHRvIGJlIGJsb2NraW5nIGR3YzMsIGNyZWF0aW5nIHRpbWUgZ2Fwcy4gTWF5YmUgYmVj
YXVzZQ0KPiA+IG9mIGEgc3Bpbl9sb2NrIGhlbGQgc29tZXdoZXJlPw0KPiA+DQo+IA0KPiBDb3Vs
ZCB0aGUgdGltZSBnYXBzIGJlIGNyZWF0ZWQgYnkgdGhlIGludGVycnVwdCBmcmVxdWVuY3kgY2hh
bmdlcz8gVGhleQ0KPiBjb21wbGV0ZWx5IGNoYW5nZSB1cCB0aGUgdGltaW5nIG9mIHdoZW4gdGhl
IHRyYW5zZmVycyBhcmUga2lja2VkIGluIGR3YzMgYW5kDQo+IHdoZW4gdXZjX3ZpZGVvX2NvbXBs
ZXRlL3V2Y2dfdmlkZW9fcHVtcCBpcyBjYWxsZWQuDQoNCllvdSBjYW4gY2hlY2sgYWxsIHRoZSAi
ZmFzdHJwY19tc2ciIHRyYWNlcG9pbnRzIGluIHRoZSBsb2cuIFRoZXNlIHN0ZXBzDQpzZWVtIHRv
IHNsb3cgZG93biB0aGUgcXVldWluZyBwcm9jZXNzIGluIHV2Yy4NCg0KPiANCj4gPiBUaGUgbG9n
aWMgdG8gZGV0ZWN0IHVuZGVycnVuIGRvZXNuJ3QgdHJpZ2dlciBiZWNhdXNlIHRoZSBxdWV1ZWQg
bGlzdCBpcw0KPiA+IGFsd2F5cyBub24tZW1wdHksIGJ1dCB0aGUgcXVldWVkIHJlcXVlc3RzIGFy
ZSBleHBlY3RlZCB0byBiZSBtaXNzZWQNCj4gPiBhbHJlYWR5LiBTbyB5b3Uga2VlcCBzZWVpbmcg
bWlzc2VkIGlzb2MuDQo+ID4gDQo+ID4gVGhlcmUgYXJlIGEgZmV3IHRoaW5ncyB5b3UgY2FuIG1p
dGlnYXRlIHRoaXMgaXNzdWU6DQo+ID4gMSkgRG9uJ3Qgc2V0IElNSSBpZiB0aGUgcmVxdWVzdCBp
bmRpY2F0ZXMgbm9faW50ZXJydXB0LiBUaGlzIHJlZHVjZXMgdGhlDQo+ID4gICAgdGltZSBzb2Z0
d2FyZSBuZWVkcyB0byBoYW5kbGUgaW50ZXJydXB0cy4NCj4gDQo+IEkgZGlkIHRyeSB0aGlzIG91
dCBlYXJsaWVyIGFuZCBpdCBkaWQgbm90IHByZXZlbnQgdGhlIHZpZGVvIGZyZWV6ZS4gSXQgZG9l
cw0KPiBtYWtlIHNlbnNlIHdoYXQgeW91IGFyZSBzdWdnZXN0aW5nLCBidXQgYmVjYXVzZSBpdCBk
aWRuJ3Qgd29yayBmb3IgbWUgaXQgbWFkZQ0KPiBtZSB0aGluayB0aGF0IG5vdCBhbGwgcmVxcyBh
cmUgYmVpbmcgcmVjbGFpbWVkIGFmdGVyIGEgbWlzc2VkIGlzb2MgaXMgc2Vlbi4NCj4gSSdsbCBy
ZXZpc2l0IHRoaXMgYXJlYSBhZ2Fpbi4NCg0KSSBkb24ndCBleHBlY3QgdGhpcyB0byBpbXByb3Zl
IG11Y2guDQoNCj4gDQo+ID4gMikgSW1wcm92ZSB0aGUgdW5kZXJydW4gZGV0ZWN0aW9uIGxvZ2lj
Lg0KPiANCj4gSSBsaWtlIHRoaXMgaWRlYSBhIGxvdCBidXQgSSdtIG5vdCB1cCB0byB0aGUgdGFz
ayBqdXN0IHlldC4gV2lsbCBhdHRlbXB0IHRvDQo+IGZvbGxvdyB5b3VyIHJlY29tbWVuZGF0aW9u
cyBiZWxvdyBhbmQgc2VlIHdoZXJlIEkgZ2V0IHdpdGggdGhpcy4NCj4gDQo+ID4gMykgSW5jcmVh
c2UgdGhlIHF1ZXVpbmcgZnJlcXVlbmN5IGZyb20gdGhlIHV2YyB0byBrZWVwIHRoZSByZXF1ZXN0
IHF1ZXVlDQo+ID4gICAgZnVsbC4gTm90ZSB0aGF0IHJlZHVjZS9hdm9pZCBzZXR0aW5nIG5vX2lu
dGVycnVwdCB3aWxsIGFsbG93IHRoZQ0KPiA+ICAgIGNvbnRyb2xsZXIgZHJpdmVyIHRvIHVwZGF0
ZSB1dmMgb2Z0ZW4gdG8ga2VlcCByZXF1ZXVpbmcgbmV3IHJlcXVlc3RzLg0KPiA+IA0KPiA+IEJl
c3Qgb3B0aW9uIGlzIDMpLCBidXQgbWF5YmUgd2UgY2FuIGRvIGFsbCAzLg0KPiA+DQo+IA0KPiBJ
IHRoaW5rIHRoYXQgdGhpcyBpcyBvdXIgYmVzdCBvcHRpb24gdG9vLiBEYW4gcHJvdmlkZWQgYSBw
YXRjaCB0byBtYWtlDQo+IHRoZSBpbnRlcnJ1cHQgc2tpcCBsb2dpYyBjb25maWd1cmFibGUgaW4g
dGhlIHV2YyBkcml2ZXI6DQo+IGh0dHBzOi8vdXJsZGVmZW5zZS5jb20vdjMvX19odHRwczovL3Bh
dGNod29yay5rZXJuZWwub3JnL3Byb2plY3QvbGludXgtdXNiL3BhdGNoLzIwMjIxMDE4MjE1MDQ0
Ljc2NTA0NC02LXczNjE5NUBtb3Rvcm9sYS5jb20vX187ISFBNEYyUjlHX3BnIWVCdTRqOW05Q19Y
SkhjdVRYbVlxbzRDQWU4YmNRMFpDM1VXVDNOSlVaWVlHNlMtVkpwcmlWd2QyUTVObUFPRm5OMlBM
Z1RhdUZEWi1mQk0zNWZ0TyQgIA0KPiBodHRwczovL3VybGRlZmVuc2UuY29tL3YzL19faHR0cHM6
Ly9sb3JlLmtlcm5lbC5vcmcvbGludXgtdXNiLzIwMjIxMDE4MjE1MDQ0Ljc2NTA0NC02LXczNjE5
NUBtb3Rvcm9sYS5jb20vX187ISFBNEYyUjlHX3BnIWVCdTRqOW05Q19YSkhjdVRYbVlxbzRDQWU4
YmNRMFpDM1VXVDNOSlVaWVlHNlMtVkpwcmlWd2QyUTVObUFPRm5OMlBMZ1RhdUZEWi1mQ0xPeHVo
TCQgIA0KPiANCj4gPiBGb3IgMiksIHlvdSBjYW4gc2V0IElNSSBmb3IgYWxsIGlzb2MgcmVxdWVz
dCBhcyBpdCBpcyBub3cuIE9uIG1pc3NlZA0KPiA+IGlzb2MsIGNoZWNrIGZvciB0aGUgVFJCJ3Mg
c2NoZWR1bGVkIHVmcmFtZSAoZnJvbSBUUkIgaW5mbykgYW5kIGNvbXBhcmUNCj4gPiBpdCB0byB0
aGUgY3VycmVudCB1ZnJhbWUgKGZyb20gRFNUUykgZm9yIHRoZSBudW1iZXIgb2YgaW50ZXJ2YWxz
IGluDQo+ID4gYmV0d2Vlbi4gV2l0aCB0aGUgbnVtYmVyIG9mIHF1ZXVlZCByZXF1ZXN0cywgeW91
IGNhbiBjYWxjdWxhdGUgd2hldGhlcg0KPiA+IHRoZSBnYWRnZXQgZHJpdmVyIHF1ZXVlZCBlbm91
Z2ggcmVxdWVzdHMuIElmIGl0IGRvZXNuJ3QsIHNlbmQgRW5kDQo+ID4gVHJhbnNmZXIgY29tbWFu
ZCBhbmQgY2FuY2VsIGFsbCB0aGUgcXVldWVkIHJlcXVlc3RzLiBUaGUgbmV4dCBzZXQgb2YNCj4g
PiByZXF1ZXN0cyB3aWxsIGJlIGluLXN5bmMgYWdhaW4uDQo+ID4gDQo+ID4gQlIsDQo+ID4gVGhp
bmgNCj4gPiANCj4gPiBQUy4gT24gYSBzaWRlIG5vdGUsIEkgbm90aWNlIHRoYXQgdGhlcmUgYXJl
IHJlcG9ydHMgb2YgaXNzdWUgd2hlbiB1c2luZw0KPiA+IFNHIHJpZ2h0PyBQbGVhc2Ugbm90ZSB0
aGF0IGR3YzMgZHJpdmVyIG9ubHkgYWxsb2NhdGVzIDI1NiBUUkJzDQo+ID4gKGluY2x1ZGluZyBh
IGxpbmsgVFJCKS4gRWFjaCBTRyBlbnRyeSB0YWtlcyBhIFRSQi4gSWYgYSByZXF1ZXN0IGhhcyBt
YW55DQo+ID4gU0cgZW50cmllcywgdGhhdCBlYXRzIHVwIHRoZSBhdmFpbGFibGUgVFJCcy4gU28s
IGV2ZW4gdGhvdWdoIHRoZSBVVkMgbWF5DQo+ID4gcXVldWUgbWFueSByZXF1ZXN0cywgbm90IGFs
bCBvZiB0aGVtIGFyZSBwcmVwYXJlZCBpbW1lZGlhdGVseS4gSWYgdGhlDQo+ID4gVFJCIHJpbmcg
aXMgZnVsbCwgdGhlIGRyaXZlciBuZWVkIHRvIHdhaXQgZm9yIG1vcmUgVFJCcyB0byBmcmVlIHVw
DQo+ID4gYmVmb3JlIHByZXBhcmluZyBtb3JlLiBGcm9tIHRoZSBsb2csIEkgc2VlIHRoYXQgaXQn
cyBzZW5kaW5nIDQ4S0IuIExldCdzDQo+ID4gc2F5IHRoZSB1dmMgc3BsaXRzIGl0IGludG8gUEFH
RV9TSVpFIG9mIDRLQiwgdGhhdCB3b3VsZCB0YWtlIGF0IGxlYXN0IDEyDQo+ID4gVFJCIHBlciBy
ZXF1ZXN0LiAoU2lkZSB0aG91Z2h0OiBJJ20gbm90IHN1cmUgd2h5IFVWQyBuZWVkcyBTRyBpbiB0
aGUNCj4gPiBmaXJzdCBwbGFjZSB3aXRoIGl0cyBjdXJyZW50IGltcGxlbWVudGF0aW9uKQ0KPiAN
Cj4gT24gb3VyIHBsYXRmb3JtIEkgYW0gc2VlaW5nIDIgaXRlbXMgaW4gdGhlIHNnIGxpc3QgYmVp
bmcgc2VudCBvdXQgZnJvbSB0aGUgdXZjDQo+IGRyaXZlci4gVGhlIDFzdCBpdGVtIGluIHRoZSBs
aXN0IGlzIGEgMiBieXRlIHV2YyBoZWFkZXIgYW5kIHRoZSAybmQgaXRlbSBpcw0KPiB0aGUgNDhL
QnMgb2YgZGF0YS4gVG8gbWUgdGhpcyBzZWVtcyBpbmVmZmljaWVudCBidXQgc29ydCBvZiBtYWtl
cyBzZW5zZSB3aHkgaXQNCj4gd2FzIGRvbmUsIGxpa2VseSB0byBhdm9pZCBhIG1lbW9yeSBjb3B5
IGp1c3QgZm9yIHRoZSAyIGJ5dGUgaGVhZGVyLiAgQnV0IEkNCg0KVGhhdCBkb2Vzbid0IG1ha2Ug
c2Vuc2UgdG8gbWUsIGJ1dCBJJ20gc3VyZSB0aGVyZSdzIGEgcmVhbCByZWFzb24uIEp1c3QNCmN1
cmlvdXMsIHRoYXQncyBhbGwuIDopDQoNCj4gc2hhcmUgeW91ciBjb25jZXJuIGhlcmUsIGl0J3Mg
cG9zc2libGUgdGhhdCBvdGhlciB1c2VycyB3b250IGJlIHNvIGx1Y2t5IGFuZA0KPiB3aWxsIHdp
bmQgdXAgaGF2aW5nIGEgbG90IG9mIHBhZ2Ugc2l6ZWQgaXRlbXMgaW4gdGhlIHNnIGxpc3QuDQo+
IA0KPiBXZSBhcmUgYWxzbyBob3BpbmcgdG8gbWFrZSB0aGUgdXNlIG9mIHNnIGNvbmZpZ3VyYWJs
ZSB3aXRoIHRoZSBjaGFuZ2U6DQo+IGh0dHBzOi8vdXJsZGVmZW5zZS5jb20vdjMvX19odHRwczov
L3BhdGNod29yay5rZXJuZWwub3JnL3Byb2plY3QvbGludXgtdXNiL3BhdGNoLzIwMjIxMDE4MjE1
MDQ0Ljc2NTA0NC03LXczNjE5NUBtb3Rvcm9sYS5jb20vX187ISFBNEYyUjlHX3BnIWVCdTRqOW05
Q19YSkhjdVRYbVlxbzRDQWU4YmNRMFpDM1VXVDNOSlVaWVlHNlMtVkpwcmlWd2QyUTVObUFPRm5O
MlBMZ1RhdUZEWi1mQWlTbDk1USQgIA0KPiBodHRwczovL3VybGRlZmVuc2UuY29tL3YzL19faHR0
cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGludXgtdXNiLzIwMjIxMDE4MjE1MDQ0Ljc2NTA0NC03LXcz
NjE5NUBtb3Rvcm9sYS5jb20vX187ISFBNEYyUjlHX3BnIWVCdTRqOW05Q19YSkhjdVRYbVlxbzRD
QWU4YmNRMFpDM1VXVDNOSlVaWVlHNlMtVkpwcmlWd2QyUTVObUFPRm5OMlBMZ1RhdUZEWi1mRG9h
Tng2USQgIA0KPiANCg0KT2suDQoNClRoYW5rcywNClRoaW5o
