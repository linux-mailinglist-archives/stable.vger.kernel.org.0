Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2487B6035FF
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 00:36:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230016AbiJRWgW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Oct 2022 18:36:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229928AbiJRWgR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Oct 2022 18:36:17 -0400
Received: from mx0b-00230701.pphosted.com (mx0b-00230701.pphosted.com [148.163.158.9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6C73CC810;
        Tue, 18 Oct 2022 15:36:08 -0700 (PDT)
Received: from pps.filterd (m0297265.ppops.net [127.0.0.1])
        by mx0a-00230701.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29ILBU5o031471;
        Tue, 18 Oct 2022 15:35:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfptdkimsnps;
 bh=bhlrG1CNyA7eEF8JSefJD8CkH0G0u4Ts/hYdjvkmjjo=;
 b=l3qehcrR+5oPcmK/UudUAuEqVyYn67Ex/o/R20NE2GkWkYBdmVkjF6j9Gl+Ci9SOyA+Q
 qlh8lBFSO+S8h1WQCrOJykxXcAWqxeq5txt9LG9kA1SZzgZ95THlay6o/R6Nb8Q2r7GP
 InaiPgz38moiYt50WGWNky3rxe80EXKsl2Pgvs2h6aK7f1y5Rr1h/qxHoDDFXAq6zeYg
 Fr/NWPMvIDb+hsT7wTtzmeSqvtHBNAbwBQiWP2MKZG6YSn4evLv4ieZW6/OMUOGl2tPu
 6RzLwyBPpiW4kDsOJtsfRvVHrQKYTwYQGTDFi+5OmOzy9ccmLqUrczQyitorwM1mOVit tQ== 
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.87.133])
        by mx0a-00230701.pphosted.com (PPS) with ESMTPS id 3k7usuuxnm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Oct 2022 15:35:38 -0700
Received: from mailhost.synopsys.com (badc-mailhost1.synopsys.com [10.192.0.17])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id EB3C8C00FA;
        Tue, 18 Oct 2022 22:35:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1666132537; bh=bhlrG1CNyA7eEF8JSefJD8CkH0G0u4Ts/hYdjvkmjjo=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=dba1VSQtMyuAhqVLcpQJhIwfGY5aAwNdrHg70CGtu7zYKHe6BXfz5ZdeSCNULwskD
         vgiSN7+wZyt86EvigAAD4nToaoIY+a0JUl9v06SF0Iij8LPlmiHJ5fbraquvpmQgsK
         8CAGj2n6YmOlPi5gypLruNFgsEGMBRWKrd4a95M73hGAHMmLmz6GfHpKv/qm4FCXvL
         t3VTL1bpzLhpOA/x+jnraefhYN9/fNTPqWrc3arAs9jRXqdKtcq1MF9kCSTi/D6ZcN
         /3GdZci7fP+w2nMnvETa1tDYOSEy4/eW45MXgZ7/zJ5hc6iCbxswJWQ4Qg2aBn70Um
         calncEblUxaAA==
Received: from o365relay-in.synopsys.com (sv2-o365relay3.synopsys.com [10.202.1.139])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "o365relay-in.synopsys.com", Issuer "Entrust Certification Authority - L1K" (verified OK))
        by mailhost.synopsys.com (Postfix) with ESMTPS id 46155A0085;
        Tue, 18 Oct 2022 22:35:35 +0000 (UTC)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11lp2175.outbound.protection.outlook.com [104.47.56.175])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.protection.outlook.com", Issuer "DigiCert Cloud Services CA-1" (verified OK))
        by o365relay-in.synopsys.com (Postfix) with ESMTPS id C898A40020;
        Tue, 18 Oct 2022 22:35:33 +0000 (UTC)
Authentication-Results: o365relay-in.synopsys.com; dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relay-in.synopsys.com; spf=pass smtp.mailfrom=thinhn@synopsys.com
Authentication-Results: o365relay-in.synopsys.com;
        dkim=pass (1024-bit key; unprotected) header.d=synopsys.com header.i=@synopsys.com header.b="rlYvlbOQ";
        dkim-atps=neutral
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OlG2tjhE/uCden5pxvmOXjGI0tKlqFwaZHtrx/WkpPMKpE8sOuPCBCiCpkODuRxXHOoQVK0e8+qJjA0d1XWB8WhMnIs0cVV6Un5Bbhf8uHwJvhtrgA/uXZ3VJCd3blNYPny87EgdUHuIY9hhGAiEAJyTDlaOKUp69sMG7QYkfaF3wBGVdj2dnKZvJkvg2RKQ3PPpkH3pwJ5COvCO0spl3War0gSUsb3JuwY1uGgtWaPua7Ld+liI9RaGYjxAG7WC9CDi38ms9ClTg/3Jzde822STUqFCJoIfbP1uy1oKbnFXSbxe1UQd12NJTdH9VPtfentPvorIi6H09m2KDp4O9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bhlrG1CNyA7eEF8JSefJD8CkH0G0u4Ts/hYdjvkmjjo=;
 b=CB4JAjTS7gNIMgzrkp/pm4FqRdQhiw+v9/aAxvchmMehXLRjHWCrv6Fc31HsyZMCewI/du3HWzHk7PmUnP+BUJu9c0Y5tIz1fQmaRInjVYfJ1hrt9hOOExU30SdXzZmDoClQ1v622y4OYZkasnBYHlDgYB/hcyibZgU4PZjPd65TWctbn4Yq20V0VSAGYoCL++gSjlJPGQ+ZeCwgcvw1tEISxJc0HUXXx/BRYw31FryLSURBWL/v2kdB1qZ/SQF+tcJEM87zrlss3bimJB7eCCQoHqvZRuQuO/V35nHHyz61Gb9ie4sSt7Z/fs09PVtfvif7yPLnQGtpqC8W2cF/dQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bhlrG1CNyA7eEF8JSefJD8CkH0G0u4Ts/hYdjvkmjjo=;
 b=rlYvlbOQ+7XxzQ3ZL5OU31kR3NEQpU0LMbclLy2G4DbGPHHfsMD2Av+SZUbkzgfSklBc7s/c3plNQb1H4is2FC1z4fRXZTlBB3JxV9cNSyIXHf2wRQq26kQsd4TF1EWGZMUF7Bnc0RWY1YKX7icG9mO/ONccPFe+8uI7xD0kC1g=
Received: from BYAPR12MB4791.namprd12.prod.outlook.com (2603:10b6:a03:10a::12)
 by SJ0PR12MB5501.namprd12.prod.outlook.com (2603:10b6:a03:304::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.32; Tue, 18 Oct
 2022 22:35:31 +0000
Received: from BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::525b:92b6:eafc:8629]) by BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::525b:92b6:eafc:8629%7]) with mapi id 15.20.5676.031; Tue, 18 Oct 2022
 22:35:31 +0000
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
To:     Jeffrey Vanhoof <jvanhoof@motorola.com>
CC:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
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
Thread-Index: AQHY4zLbXRUpqdOqTUOotJbe2PZC1K4UvWqA
Date:   Tue, 18 Oct 2022 22:35:30 +0000
Message-ID: <20221018223521.ytiwqsxmxoen5iyt@synopsys.com>
References: <PUZPR03MB613101A170B0034F55401121A1289@PUZPR03MB6131.apcprd03.prod.outlook.com>
In-Reply-To: <PUZPR03MB613101A170B0034F55401121A1289@PUZPR03MB6131.apcprd03.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR12MB4791:EE_|SJ0PR12MB5501:EE_
x-ms-office365-filtering-correlation-id: 5059af6b-27e4-43f5-70aa-08dab1591054
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: J1TTtNRKSTCvayoe26w1zsN4CuOaMhZNWFNzZPWz22oMLRR8QPhrgZtDJ64voj+KwmnWoHKtEqqGJ2DFuB2WdurC5Rbym7auZp4nJyA6RH5CHKErbH1Cns5Pdew39+mDE63w1XbftkqYbDPbqp0zRMDE0t9J1zz4q/TWhNRZrP8M3zKrRcuzo2FQYk/5YpdHYUircnTLShcIKOGNIx7Eg6sKvdGSMV+cdYTWKocxmL6736cDIAmhj0/8GWzaNvEN09cHQ28zgzO1M6S60sSIgQ8SU4WlKgnphA5ssMxNWE9nf1DTH/PT6fCuaYtwRkHjqi7WrIWcV81RKPelflzJ2kCOvqS69Ld+3Ifu91Bi79j/VrJn7GyZk4/kbtxBIV2HrFQyHkQNmSPRxmwUY+JEyH46A3VBXNWAh++tcC3OWcTqFKOt0HFJHpv3cnTV14TD2nzvQb5zR0m9O9dlDtDXkZYdP038eaDXEaXWTITTtfbiAbmLrRJXyu/W+BRs+zRMtCzRX4NMVdNfWLBMPRk58LifIgP0ojsIo1RDDggBlvOdalawFusXAkHqsB+Px/TuNaYC+7v0xMM5DUp3CU9KFuuXOyT/mw3HtZy1qS1nZRvdCDaMA98EpqiByThDA8geiq0sdqJYtXpVuIqQa8vbY9SXPlsyOVl/PXC815yej83aNXEEysbmWcYdjBxAeRAJsHaB7z0o5UcdLIyUnLrEHRL3y1MGvYIoUiwchbxDk20r5A7Tt9PnAdZPSRY1pp6JjWNKyzwtFquY+RhglLQ/5ATvIY9PTIDpbGuu7mM/tr8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4791.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(376002)(136003)(396003)(366004)(39860400002)(451199015)(966005)(478600001)(6486002)(71200400001)(38100700002)(6916009)(8936002)(54906003)(6512007)(83380400001)(316002)(41300700001)(186003)(26005)(122000001)(6506007)(36756003)(4326008)(38070700005)(2616005)(5660300002)(64756008)(2906002)(1076003)(66476007)(66556008)(66946007)(66446008)(8676002)(86362001)(7416002)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TTU1ckl2cmNHSHkzZDRqQ0VVczB1WkR4NlJLZzIzMTAwNXJjeHhwcm9KZDJ0?=
 =?utf-8?B?eGJZUitkcDZVRTNIanJFQjRlZllNR2ZIdm02bzJmQTN5NnliOHdRbGs3QktP?=
 =?utf-8?B?ckZVUmxOV2VEaEdLNDR0UGRac3p0ZGl1TmlweTRpN0hRdStkeTRERDZieS9S?=
 =?utf-8?B?cUoxaHFkSG1YUGNCTzZsNHBrQXBmRkZGS0RJRkV3bDh6YU5zR2hyOFJ3bnFC?=
 =?utf-8?B?QWtXS1pDVS8ybVRXRWwxRUxTUWdLQkQ1ZmFkNE9rcEVpTmRqRjdPVUM2SElX?=
 =?utf-8?B?ZldVbHZhUWkwVDZ6Wjl0ekhmMTlCUXl6WVN4U2NBQVphSkhuRzdaYXJ0QXpu?=
 =?utf-8?B?bWsxVHJoMzVPSXlHUnRSdkNDUFQ2ZzFlUnpZTE9jVy8vZWtBWUxFV1hJbW1G?=
 =?utf-8?B?ME1qaldMOHllNFkvc0gvT2ZDOHRlYnh0TGNjb1BmMFlPNzFvd0N5dWRPR1h3?=
 =?utf-8?B?VnN1RTdwY3V5MlVKZisrMUg1M09jWTBFM2RtSTdPbDN2QjZlNnA5d2Y3OVV2?=
 =?utf-8?B?VE8wQXNpVk5COVF0YXBoZzArRU1Cbmp2di9aa1Z6ODQ2NlY1YzIxeUZ4QTlt?=
 =?utf-8?B?b3Fsc3hrWG9GL2xxa0pNUXQ0anZnT2I2dDVTQW1EK0p0NkwzaW8rNm5yYmVW?=
 =?utf-8?B?cjFRRldxcHoydGFkeHRnamJBanl5T0ozWTFCUlpYOUowbUoyVXZ0Q2xUMUNT?=
 =?utf-8?B?ZkNSWkZuRXpuME83elJpSk84bExOTmNqRmc2MEM4ZWJHOU8zaldkYmpQb2s3?=
 =?utf-8?B?TGpuSXNubXdvTWFCdTVuVXFhb21YUkhEVVNYdjZZbXFkWFBGNHJDNjdOTXFy?=
 =?utf-8?B?YW9GcDFxKy9vV1l0MTZGMzBEQy9LK3hNVFBXS2sxdEpKZ2dkT29zR1AyOVRj?=
 =?utf-8?B?WGpidnRveEg1dVFtRU16alJleGhVNDJWRm5ERFhiRjhvN2IyM0ZOd0xXTUFO?=
 =?utf-8?B?ZXU5aUo2RWxMaGtyc1pXSG1wT0dVMTg2VXNOVW5CQlgwVjV3OFQ2R002cjdw?=
 =?utf-8?B?RTVLYXVoV2prVFo4WCtTOWZabFFKRHJvcktLandoMUhmaFQxQU9Xa296ZUhC?=
 =?utf-8?B?Y1hKTFYxd2dkaVZtanc4L0N2SGwwcHZDR1JVbzh6WnZ3aDRKcWduMWV6UHlr?=
 =?utf-8?B?ck4yZEYxUHNZVW1qUnNHRDdJd2RWOENZbm9BYWlpUDlEcDZrUm9pNS9tV3Jl?=
 =?utf-8?B?a2Q1Q1ZmS01YbWhmTUZpN0tjdXI5UEp2M21ab3l5UWFrV1didXIwRzUrV2RH?=
 =?utf-8?B?bjh6SXlZSDZUNG1xUnY1bDVqNzdqc2JsYmZMRWFuVVpHc25ZNkJMaFZHN0RR?=
 =?utf-8?B?TXpkSVlvWkc3QVVkRFVBZW8yV2JkUU42dGJ5YjFvTVNBM3hacWpqY2tqOE5n?=
 =?utf-8?B?Rk9TZzRmbk84c1NDcUlvOG4wSytSUzlLcnByRVEvVGpzZXZ2UkFOZjFwaVR3?=
 =?utf-8?B?elpEK1dtVW1sWEY5RzhFYmxRenZUSk5MOXVINFQzTXYyM1pTOHdqUk16bVhS?=
 =?utf-8?B?QkR4UkJBODFTa3YwNWJIb09xRk9SNGdtblpwMGN2SVJHT1ZQSFhrK21QdGdU?=
 =?utf-8?B?a1FsaHpOL2lZTThhUENSUVczK1d6OG1TYlY3ZTQ3RWNuSHlLVm03cU9pU0lJ?=
 =?utf-8?B?c0VxQnNZZmZwbjgyNE5OVngxUHVYQnBxZ0JNV1RoS1BLeDNhaFI1TERncHEv?=
 =?utf-8?B?Tm1mTXhzaDhYakdjTUcyakZXelZub2RzZC8rbU82ZGplK3NMeWFxMVJhU0dG?=
 =?utf-8?B?QVFTMVBWVjMydmloNU1HRkFPR2JvNU9YMHd0RDZ6Wk5DMWlvMXhUL3lwSlBW?=
 =?utf-8?B?R0ZwbGI1UGwvcktUbGsxVkpualhpZmFtOW1Ia1VGeVRUbWJBS2dlcXE0NEZt?=
 =?utf-8?B?Qk43WHJUZGNMamlVTEhsREhNTDl6bWliUVVzYnRQUjJqekp6cEFlMnhLZlBW?=
 =?utf-8?B?a3h2UWFzSmwybW9HeE1DR2I4Z3BlN1I0SVc2Nm1mZlZ5K3IwVFAwUWRTZnZO?=
 =?utf-8?B?aVBTOTJtdzFpT1poQ1Rkc0IrWHNsdmVVNXpvTVUvL3FIcjlZVG9tcXdUWXVn?=
 =?utf-8?B?djBxVkM5MHRRY1VwRGk1c2hmKzJLOU9yVXF6WjQ2SHh4WiszM0NRd21oWVdJ?=
 =?utf-8?Q?uFU7U/yOt1ECEjTMUV1kMiqcr?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4530E785D9CB0041A2B474C84583E0B8@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4791.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5059af6b-27e4-43f5-70aa-08dab1591054
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2022 22:35:31.0209
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Pq9jwMENyAqHoREFgp7wQckXjgKp4b6wa4hK4/FPV91mOHJpn0epnsLXnfmm2oQEsfJnOIobt/lYXXe4h97GBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5501
X-Proofpoint-ORIG-GUID: GVzBnmnMdCp3QAwdAghoTjzhydUNITpz
X-Proofpoint-GUID: GVzBnmnMdCp3QAwdAghoTjzhydUNITpz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-18_07,2022-10-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_active_cloned_notspam policy=outbound_active_cloned score=0
 mlxscore=0 phishscore=0 suspectscore=0 bulkscore=0 priorityscore=1501
 mlxlogscore=999 impostorscore=0 adultscore=0 spamscore=0 malwarescore=0
 lowpriorityscore=0 clxscore=1011 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2209130000 definitions=main-2210180127
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gVHVlLCBPY3QgMTgsIDIwMjIsIEplZmZyZXkgVmFuaG9vZiB3cm90ZToNCj4gSGkgVGhpbmgs
DQo+IA0KPiBPbiBUdWUsIE9jdCAxOCwgMjAyMiBhdCAwNjo0NTo0MFBNICswMDAwLCBUaGluaCBO
Z3V5ZW4gd3JvdGU6DQo+ID4gSGkgRGFuLA0KPiA+IA0KPiA+IE9uIE1vbiwgT2N0IDE3LCAyMDIy
LCBEYW4gVmFjdXJhIHdyb3RlOg0KPiA+ID4gSGkgVGhpbmgsDQo+ID4gPiANCj4gPiA+IE9uIE1v
biwgT2N0IDE3LCAyMDIyIGF0IDA5OjMwOjM4UE0gKzAwMDAsIFRoaW5oIE5ndXllbiB3cm90ZToN
Cj4gPiA+ID4gT24gTW9uLCBPY3QgMTcsIDIwMjIsIERhbiBWYWN1cmEgd3JvdGU6DQo+ID4gPiA+
ID4gRnJvbTogSmVmZiBWYW5ob29mIDxxanYwMDFAbW90b3JvbGEuY29tPg0KPiA+ID4gPiA+IA0K
PiA+ID4gPiA+IGFybS1zbW11IHJlbGF0ZWQgY3Jhc2hlcyBzZWVuIGFmdGVyIGEgTWlzc2VkIElT
T0MgaW50ZXJydXB0IHdoZW4NCj4gPiA+ID4gPiBub19pbnRlcnJ1cHQ9MSBpcyB1c2VkLiBUaGlz
IGNhbiBoYXBwZW4gaWYgdGhlIGhhcmR3YXJlIGlzIHN0aWxsIHVzaW5nDQo+ID4gPiA+ID4gdGhl
IGRhdGEgYXNzb2NpYXRlZCB3aXRoIGEgVFJCIGFmdGVyIHRoZSB1c2JfcmVxdWVzdCdzIC0+Y29t
cGxldGUgY2FsbA0KPiA+ID4gPiA+IGhhcyBiZWVuIG1hZGUuICBJbnN0ZWFkIG9mIGltbWVkaWF0
ZWx5IHJlbGVhc2luZyBhIHJlcXVlc3Qgd2hlbiBhIE1pc3NlZA0KPiA+ID4gPiA+IElTT0MgaW50
ZXJydXB0IGhhcyBvY2N1cnJlZCwgdGhpcyBjaGFuZ2Ugd2lsbCBhZGQgbG9naWMgdG8gY2FuY2Vs
IHRoZQ0KPiA+ID4gPiA+IHJlcXVlc3QgaW5zdGVhZCB3aGVyZSBpdCB3aWxsIGV2ZW50dWFsbHkg
YmUgcmVsZWFzZWQgd2hlbiB0aGUNCj4gPiA+ID4gPiBFTkRfVFJBTlNGRVIgY29tbWFuZCBoYXMg
Y29tcGxldGVkLiBUaGlzIGxvZ2ljIGlzIHNpbWlsYXIgdG8gc29tZSBvZiB0aGUNCj4gPiA+ID4g
PiBjbGVhbnVwIGRvbmUgaW4gZHdjM19nYWRnZXRfZXBfZGVxdWV1ZS4NCj4gPiA+ID4gDQo+ID4g
PiA+IFRoaXMgZG9lc24ndCBzb3VuZCByaWdodC4gSG93IGRpZCB5b3UgZGV0ZXJtaW5lIHRoYXQg
dGhlIGhhcmR3YXJlIGlzDQo+ID4gPiA+IHN0aWxsIHVzaW5nIHRoZSBkYXRhIGFzc29jaWF0ZWQg
d2l0aCB0aGUgVFJCPyBEaWQgeW91IGNoZWNrIHRoZSBUUkIncw0KPiA+ID4gPiBIV08gYml0Pw0K
PiA+ID4gDQo+ID4gPiBUaGUgcHJvYmxlbSB3ZSdyZSBzZWVpbmcgd2FzIG1lbnRpb25lZCBpbiB0
aGUgc3VtbWFyeSBvZiB0aGlzIHBhdGNoDQo+ID4gPiBzZXJpZXMsIGlzc3VlICMxLiBCYXNpY2Fs
bHksIHdpdGggdGhlIGZvbGxvd2luZyBwYXRjaA0KPiA+ID4gaHR0cHM6Ly91cmxkZWZlbnNlLmNv
bS92My9fX2h0dHBzOi8vcGF0Y2h3b3JrLmtlcm5lbC5vcmcvcHJvamVjdC9saW51eC11c2IvcGF0
Y2gvMjAyMTA2MjgxNTUzMTEuMTY3NjItNi1tLmdyemVzY2hpa0BwZW5ndXRyb25peC5kZS9fXzsh
IUE0RjJSOUdfcGchYVNOWi1Jak1jUGdMNDdBNE5SNXFwOXFoVmxQOTFVR1R1Q3hlajVOUlR2OC1G
bVRyTWtLSzdDak5Ub1FRVkVndHBxYkt6TFUySFhFVDlPMjI2QUVOJCAgDQo+ID4gPiBpbnRlZ3Jh
dGVkIGEgc21tdSBwYW5pYyBpcyBvY2N1cnJpbmcgb24gb3VyIEFuZHJvaWQgZGV2aWNlIHdpdGgg
dGhlIDUuMTUNCj4gPiA+IGtlcm5lbCB3aGljaCBpczoNCj4gPiA+IA0KPiA+ID4gICAgIDwzPlsg
IDcxOC4zMTQ5MDBdWyAgVDgwM10gYXJtLXNtbXUgMTUwMDAwMDAuYXBwcy1zbW11OiBVbmhhbmRs
ZWQgYXJtLXNtbXUgY29udGV4dCBmYXVsdCBmcm9tIGE2MDAwMDAuZHdjMyENCj4gPiA+IA0KPiA+
ID4gVGhlIHV2YyBnYWRnZXQgZHJpdmVyIGFwcGVhcnMgdG8gYmUgdGhlIGZpcnN0IChhbmQgb25s
eSkgZ2FkZ2V0IHRoYXQNCj4gPiA+IHVzZXMgdGhlIG5vX2ludGVycnVwdD0xIGxvZ2ljLCBzbyB0
aGlzIHNlZW1zIHRvIGJlIGEgbmV3IGNvbmRpdGlvbiBmb3INCj4gPiA+IHRoZSBkd2MzIGRyaXZl
ci4gSW4gb3VyIGNvbmZpZ3VyYXRpb24sIHdlIGhhdmUgdXAgdG8gNjQgcmVxdWVzdHMgYW5kIHRo
ZQ0KPiA+ID4gbm9faW50ZXJydXB0PTEgZm9yIHVwIHRvIDE1IHJlcXVlc3RzLiBUaGUgbGlzdCBz
aXplIG9mIGRlcC0+c3RhcnRlZF9saXN0DQo+ID4gPiB3b3VsZCBnZXQgdXAgdG8gdGhhdCBhbW91
bnQgd2hlbiBsb29waW5nIHRocm91Z2ggdG8gY2xlYW51cCB0aGUNCj4gPiA+IGNvbXBsZXRlZCBy
ZXF1ZXN0cy4gRnJvbSB0ZXN0aW5nIGFuZCBkZWJ1Z2dpbmcgdGhlIHNtbXUgcGFuaWMgb2NjdXJz
DQo+ID4gPiB3aGVuIGEgLUVYREVWIHN0YXR1cyBzaG93cyB1cCBhbmQgcmlnaHQgYWZ0ZXINCj4g
PiA+IGR3YzNfZ2FkZ2V0X2VwX2NsZWFudXBfY29tcGxldGVkX3JlcXVlc3QoKSB3YXMgdmlzaXRl
ZC4gVGhlIGNvbmNsdXNpb24NCj4gPiA+IHdlIGhhZCB3YXMgdGhlIHJlcXVlc3RzIHdlcmUgZ2V0
dGluZyByZXR1cm5lZCB0byB0aGUgZ2FkZ2V0IHRvbyBlYXJseS4NCj4gPiANCj4gPiBBcyBJIG1l
bnRpb25lZCwgaWYgdGhlIHN0YXR1cyBpcyB1cGRhdGVkIHRvIG1pc3NlZCBpc29jLCB0aGF0IG1l
YW5zIHRoYXQNCj4gPiB0aGUgY29udHJvbGxlciByZXR1cm5lZCBvd25lcnNoaXAgb2YgdGhlIFRS
QiB0byB0aGUgZHJpdmVyLiBBdCBsZWFzdCBmb3INCj4gPiB0aGUgcGFydGljdWxhciByZXF1ZXN0
IHdpdGggLUVYREVWLCBpdHMgVFJCcyBhcmUgY29tcGxldGVkLiBJJ20gbm90DQo+ID4gY2xlYXIg
b24geW91ciBjb25jbHVzaW9uLg0KPiA+IA0KPiA+IERvIHdlIGtub3cgd2hlcmUgZGlkIHRoZSBj
cmFzaCBvY2N1cj8gSXMgaXQgZnJvbSBkd2MzIGRyaXZlciBvciBmcm9tIHV2Yw0KPiA+IGRyaXZl
ciwgYW5kIGF0IHdoYXQgbGluZT8gSXQnZCBncmVhdCBpZiB3ZSBjYW4gc2VlIHRoZSBkcml2ZXIg
bG9nLg0KPiA+DQo+IA0KPiBUbyBpbnRlcmplY3QsIHdoYXQgc2hvdWxkIGhhcHBlbiBpbiBkd2Mz
X2dhZGdldF9lcF9yZWNsYWltX2NvbXBsZXRlZF90cmIgaWYgdGhlDQo+IElPQyBiaXQgaXMgbm90
IHNldCAoYnV0IHRoZSBJTUkgYml0IGlzKSBhbmQgLUVYREVWIHN0YXR1cyBpcyBwYXNzZWQgaW50
byBpdD8NCg0KSG0uLi4gd2UgbWF5IGhhdmUgb3Zlcmxvb2tlZCB0aGlzIGNhc2UgZm9yIG5vX2lu
dGVycnVwdCBzY2VuYXJpby4gSWYgSU1JDQppcyBzZXQsIHRoZW4gdGhlcmUgd2lsbCBiZSBhbiBp
bnRlcnJ1cHQgd2hlbiB0aGVyZSdzIG1pc3NlZCBpc29jDQpyZWdhcmRsZXNzIG9mIHdoZXRoZXIg
bm9faW50ZXJydXB0IGlzIHNldCBieSB0aGUgZ2FkZ2V0IGRyaXZlci4NCg0KPiBJZiB0aGUgZnVu
Y3Rpb24gcmV0dXJucyAwLCBhbm90aGVyIGF0dGVtcHQgdG8gcmVjbGFpbSBtYXkgb2NjdXIuIElm
IHRoaXMNCj4gaGFwcGVucyBhbmQgdGhlIG5leHQgcmVxdWVzdCBkaWQgaGF2ZSB0aGUgSFdPIGJp
dCBzZXQsIHRoZSBmdW5jdGlvbiB3b3VsZA0KPiByZXR1cm4gMSBidXQgZHdjM19nYWRnZXRfZXBf
Y2xlYW51cF9jb21wbGV0ZWRfcmVxdWVzdCB3b3VsZCBzdGlsbCBjYWxsDQo+IGR3YzNfZ2FkZ2V0
X2dpdmViYWNrLg0KPiANCj4gQXMgYSB0ZXN0ICh3aXRob3V0IHRoaXMgcGF0Y2gpLCBJIGFkZGVk
IGEgY2hlY2sgdG8gc2VlIGlmIEhXTyBiaXQgd2FzIHNldCBpbg0KPiBkd2MzX2dhZGdldF9lcF9j
bGVhbnVwX2NvbXBsZXRlZF9yZXF1ZXN0cygpLiBJZiB0aGUgdXNlY2FzZSB3YXMgSVNPQyBhbmQg
dGhlDQo+IEhXTyBiaXQgd2FzIHNldCBJIGF2b2lkZWQgY2FsbGluZyBkd2MzX2dhZGdldF9lcF9j
bGVhbnVwX2NvbXBsZXRlZF9yZXF1ZXN0KCkuDQo+IFRoaXMgc2VlbWVkIHRvIGFsc28gYXZvaWQg
dGhlIGlvbW11IHJlbGF0ZWQgY3Jhc2ggYmVpbmcgc2Vlbi4NCj4gDQo+IElzIHRoZXJlIGFuIGlz
c3VlIGluIHRoaXMgYXJlYSB0aGF0IG5lZWRzIHRvIGJlIGNvcnJlY3RlZCBpbnN0ZWFkPyBOb3Qg
aGF2aW5nDQo+IGludGVycnVwdHMgc2V0IGZvciBlYWNoIHJlcXVlc3QgbWF5IGJlIGNhdXNpbmcg
c29tZSBuZXcgaXNzdWVzIHRvIGJlIHVuY292ZXJlZC4NCj4gDQo+IEFzIGZhciBhcyB0aGUgY3Jh
c2ggc2VlbiB3aXRob3V0IHRoaXMgcGF0Y2gsIG5vIGdvb2Qgc3RhY2t0cmFjZSBpcyBnaXZlbi4g
TGluZQ0KPiBwcm92aWRlZCBmb3IgY3Jhc2ggdmFyaWVkIGEgYml0LCBidXQgdGVuZGVkIHRvIGFw
cGVhciB0b3dhcmRzIHRoZSBlbmQgb2YNCj4gZHdjM19zdG9wX2FjdGl2ZV90cmFuc2ZlcigpIG9y
IGR3YzNfZ2FkZ2V0X2VuZHBvaW50X3RyYnNfY29tcGxldGUoKS4NCj4gDQo+IFNpbmNlIGR3YzNf
Z2FkZ2V0X2VuZHBvaW50X3RyYnNfY29tcGxldGUoKSBjYW4gYmUgY2FsbGVkIGZyb20gbXVsdGlw
bGUNCj4gbG9jYXRpb25zLCBJIGR1cGxpY2F0ZWQgdGhlIGZ1bmN0aW9uIHRvIGhlbHAgaWRlbnRp
Znkgd2hpY2ggcGF0aCBpdCB3YXMgbGlrZWx5DQo+IGJlaW5nIGNhbGxlZCBmcm9tLiBBdCB0aGUg
dGltZSBvZiB0aGUgY3Jhc2hlcyBzZWVuLA0KPiBkd2MzX2dhZGdldF9lbmRwb2ludF90cmFuc2Zl
cl9pbl9wcm9ncmVzcygpIGFwcGVhcmVkIHRvIGJlIHRoZSBjYWxsZXIuDQo+IA0KPiBkd2MzX2dh
ZGdldF9lbmRwb2ludF90cmFuc2Zlcl9pbl9wcm9ncmVzcygpDQo+IC0+ZHdjM19nYWRnZXRfZW5k
cG9pbnRfdHJic19jb21wbGV0ZSgpIChjcmFzaGVkIHRvd2FyZHMgZW5kIG9mIGhlcmUpDQo+IC0+
ZHdjM19zdG9wX2FjdGl2ZV90cmFuc2ZlcigpIChzb21ldGltZXMgY3Jhc2hlZCB0b3dhcmRzIGVu
ZCBvZiBoZXJlKQ0KPiANCj4gSSBob3BlIHRoaXMgY2xhcmlmaWVzIHRoaW5ncyBhIGJpdC4NCj4g
IA0KDQpDYW4gd2UgdHJ5IHRoaXM/IExldCBtZSBrbm93IGlmIGl0IHJlc29sdmVzIHlvdXIgaXNz
dWUuDQoNCmRpZmYgLS1naXQgYS9kcml2ZXJzL3VzYi9kd2MzL2dhZGdldC5jIGIvZHJpdmVycy91
c2IvZHdjMy9nYWRnZXQuYw0KaW5kZXggNjFmYmEyYjczODliLi44MzUyZjRiNWRkOWYgMTAwNjQ0
DQotLS0gYS9kcml2ZXJzL3VzYi9kd2MzL2dhZGdldC5jDQorKysgYi9kcml2ZXJzL3VzYi9kd2Mz
L2dhZGdldC5jDQpAQCAtMzY1Nyw2ICszNjU3LDEwIEBAIHN0YXRpYyBpbnQgZHdjM19nYWRnZXRf
ZXBfcmVjbGFpbV9jb21wbGV0ZWRfdHJiKHN0cnVjdCBkd2MzX2VwICpkZXAsDQogCWlmIChldmVu
dC0+c3RhdHVzICYgREVQRVZUX1NUQVRVU19TSE9SVCAmJiAhY2hhaW4pDQogCQlyZXR1cm4gMTsN
CiANCisJaWYgKHVzYl9lbmRwb2ludF94ZmVyX2lzb2MoZGVwLT5lbmRwb2ludC5kZXNjKSAmJg0K
KwkgICAgKGV2ZW50LT5zdGF0dXMgJiBERVBFVlRfU1RBVFVTX01JU1NFRF9JU09DKSAmJiAhY2hh
aW4pDQorCQlyZXR1cm4gMTsNCisNCiAJaWYgKCh0cmItPmN0cmwgJiBEV0MzX1RSQl9DVFJMX0lP
QykgfHwNCiAJICAgICh0cmItPmN0cmwgJiBEV0MzX1RSQl9DVFJMX0xTVCkpDQogCQlyZXR1cm4g
MTsNCg0KVGhhbmtzLA0KVGhpbmg=
