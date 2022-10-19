Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8E4B6037D5
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 04:03:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229916AbiJSCDr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Oct 2022 22:03:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229894AbiJSCDl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Oct 2022 22:03:41 -0400
Received: from mx0b-00230701.pphosted.com (mx0b-00230701.pphosted.com [148.163.158.9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 012F2E09CE;
        Tue, 18 Oct 2022 19:03:21 -0700 (PDT)
Received: from pps.filterd (m0098572.ppops.net [127.0.0.1])
        by mx0b-00230701.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29INjmgC030245;
        Tue, 18 Oct 2022 19:03:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfptdkimsnps;
 bh=2OA9ei5Gpm/wm4+UrXanTRT6GShiKsKRTM8/uJFRkj8=;
 b=fDszkEIIO3wJ3NHUhqAfBQAbze8VwmAAzhHfkBOZd727ArqpS4C9pcoVjrn/lMAP545d
 cPhFOgUXrlNbSEIgKXfEgEWbNCZOhZIr/ciXpe9t17XckG+r97OTiVq2eF7wgEsslTFk
 ctzRCK/cvAPIcfItJeHmU/BirzrRBslhR9Hdj0gung6tFMSsW8dmGpt+xee+jNFJK2pQ
 NZZXftTf15gvZkqKdqwMuetNyDjA9Ir4rckXQ6fyT8D8jZwC2sWLYpKLhyg7AUq2B80q
 D+QyKUtY+8nGbra63D+Qy/EKbhEintaL4BnsdV0x4zKlfoy1019Uifa/yUqOywTeS7+G zA== 
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.87.133])
        by mx0b-00230701.pphosted.com (PPS) with ESMTPS id 3k7ughn0a2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Oct 2022 19:03:02 -0700
Received: from mailhost.synopsys.com (badc-mailhost1.synopsys.com [10.192.0.17])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 9A351C00FA;
        Wed, 19 Oct 2022 02:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1666144981; bh=2OA9ei5Gpm/wm4+UrXanTRT6GShiKsKRTM8/uJFRkj8=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=blXrqJE4/F9bOUxlNAyGnf4wkuo1nqR027LxAPNKDdgt8tz5NQb9MhJVoiG0mxkZC
         VHAzmUbjj/KiPqD/jI6ZCBcC7eNjPla8WTzaqp1GwKj/3eZ/WRwja5mQnm9kqPVkno
         Dy5ANLHJMgNBfM3dqveiHnMqz2lRGVk70iaLzQhJWwX07UhnosahKdhl5VvIZdfR8F
         ujOCIAiuiF1oR+Mk+EGB/XUdCS2yKARTIac8U7oy6WLBd9dxe8ld5Biegm0DFDHRmB
         dewFiznAeGCe5xaX6exmvU3jxfQbP3UhKmcERT9rmT3X5B8iX3uCp2QBUp4/lAtc3U
         pHaTqNDfnOOrg==
Received: from o365relay-in.synopsys.com (us03-o365relay1.synopsys.com [10.4.161.137])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "o365relay-in.synopsys.com", Issuer "Entrust Certification Authority - L1K" (verified OK))
        by mailhost.synopsys.com (Postfix) with ESMTPS id 22A8BA00AE;
        Wed, 19 Oct 2022 02:02:58 +0000 (UTC)
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.protection.outlook.com", Issuer "DigiCert Cloud Services CA-1" (verified OK))
        by o365relay-in.synopsys.com (Postfix) with ESMTPS id 51D4A800B4;
        Wed, 19 Oct 2022 02:02:56 +0000 (UTC)
Authentication-Results: o365relay-in.synopsys.com; dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relay-in.synopsys.com; spf=pass smtp.mailfrom=thinhn@synopsys.com
Authentication-Results: o365relay-in.synopsys.com;
        dkim=pass (1024-bit key; unprotected) header.d=synopsys.com header.i=@synopsys.com header.b="mTlQMzhA";
        dkim-atps=neutral
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=leD4WZFTrF7MhT/vcbQ6wOipo2NMG1EVfUVGtYjV1jbzqNRaThLXxAtHOKdCSvYDWWt3WgZUzMvhbbJtpuGQ2JLpTUT8gdnCSEXvshpGmw0m3dkUZlTymle+VytNXt2QGCIT8NKRhpq6mVsNSWSUs9116rRsudLh7AIuLLIbCLP6p8LXojZjs+zm0KIjP7hYSudCsDAaso9RqxjXRgyfIcLovvJCfBACzS7JJCjVDG/ZftLhlHcbVqZiU7VGwLVIF7xNyOPUE3HQPqC/VnbQ8klpmRiwo7v0bCAgkXkiBfUnNdHqZ9zYxApjM7N8ZQQEq1kRB4NpSK74ZQRcaDRRtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2OA9ei5Gpm/wm4+UrXanTRT6GShiKsKRTM8/uJFRkj8=;
 b=DbK8dTl/rHdseGcgsXHADvf/ZgLifHtlvwh4TxdFpYrpnsHm+w9wSoD9fbjMl8NbWLlb/nnd5RdyqjcWFWGyzkCWjpDk1u3VNZtGxvzAReaQhh5nb2YwGip70ujsh0tsbOFE2uIf9kmW9EclUFX3ixSsrPR9uj/RWRC1bTsz6nwBqVMY2NZgx3P/wtgQR4Q8FWMZCx0kD+6NJBzTSa8pHmWFvjnHQvblzgmjkIy7ndTj5HA89S2g5j9zT/Bq/kyKa+u8Hce1reB0Dam17EN1EHo1hgTep5qFQL/eiAPtwM/1cUT9j/bgEUsRW+XGtrZw0b5O3n4VGxAMLFN21Txc8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2OA9ei5Gpm/wm4+UrXanTRT6GShiKsKRTM8/uJFRkj8=;
 b=mTlQMzhAA6gX3gRSW8nNN3D790WhYAj96ODnMqm3Sth2MzzxRL9o3/GySGc4MMKgKXXS8sKPDpjkpO967PcGfbzPZcyB8MuIQi7vND4r3TSi0I0JjciUQMI2PQX8vBno57e28vQv8cPBMzM+LKI6U8Bi0u+BfR5hnfu9EriL3a0=
Received: from BYAPR12MB4791.namprd12.prod.outlook.com (2603:10b6:a03:10a::12)
 by BN9PR12MB5066.namprd12.prod.outlook.com (2603:10b6:408:133::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.34; Wed, 19 Oct
 2022 02:02:53 +0000
Received: from BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::525b:92b6:eafc:8629]) by BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::525b:92b6:eafc:8629%7]) with mapi id 15.20.5676.031; Wed, 19 Oct 2022
 02:02:53 +0000
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
Thread-Index: AQHY4zLbXRUpqdOqTUOotJbe2PZC1K4UvWqAgAAz6gCAAAYCAA==
Date:   Wed, 19 Oct 2022 02:02:53 +0000
Message-ID: <20221019020240.exujmo7uvae4xfdi@synopsys.com>
References: <PUZPR03MB613101A170B0034F55401121A1289@PUZPR03MB6131.apcprd03.prod.outlook.com>
 <20221018223521.ytiwqsxmxoen5iyt@synopsys.com>
 <20221019014108.GA5732@qjv001-XeonWs>
In-Reply-To: <20221019014108.GA5732@qjv001-XeonWs>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR12MB4791:EE_|BN9PR12MB5066:EE_
x-ms-office365-filtering-correlation-id: 29095e42-9a8e-43d1-2447-08dab17608b3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LgMF7NlC7fCyulqUpP/zk4Lvr7m7JaKLqkT7DPPp7ebvCqK/PlxIi+NNheEWKKFvqUNbl3ZcxjsZCR7icUpe5Dyb2RRdydakvjW4iDdZf9jdU5HDujIfp/UGV7mm0o+ApdLr0uGypTnVwydf5cczGbbnkoOLLkMuH0qlwztXfmGxXMC1Cdiv4/WQKELlbH1bXr0Op7s3vF/fYLxrqV21ArajWQTyElDEP+ZrMCs5Ow9Q9+XTolo2jTsCUcSoLWQjVl4HT/PdVMmVjz58I/Q+plawpGztMuU08vVSfXAD9rvxAgQ05K78HIriNlYH19ysY9R2BU5eN1uyxs1Ew/wZXTxa5O4BH+tUhIkblM9xjfD1F+h2Mkcn0ih8/VdQ6KIGC9X1mqOfuBPqaPycUJ+uWrqU3yVowVqnsekgTyuZ2l2xriSl9PJfA3WKX34U47mhRgcAJI2o3xZ8iQSbI762CnROVb/Cgn6rkO+l7msxhLf9mSBZzBMhboZOL1IPWZHS3JFPshcAfozpcv216Tv2YRJvKBrBKS0pVC7G/z9h2RSjeJqEAaGvlzL9Z5v6xn76LGdQ8q4wcDPamWSPc5+IsasTeFJr6X0RZZ/V1jIG1YSGmsTrXPR54uhzB0lqCthgRverD7iWDMI5mZTR1aeDNThuirZueEen6tW4LnMO2WKu7uDAsISI+BNT6FxPpYF0/KkIB9+UoCDy7qXE4Hw0fxHc/DH04XzivJHlVig2S4gR4d1JwXgxD9qMJbLS3kxmfiCEu0fLq0Ug+kPtDNvHPzxiM+IaDhkx8t/y9PADSvg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4791.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(39860400002)(346002)(376002)(396003)(451199015)(86362001)(36756003)(41300700001)(2906002)(966005)(478600001)(71200400001)(8936002)(5660300002)(7416002)(316002)(54906003)(6916009)(8676002)(4326008)(64756008)(66556008)(66946007)(6486002)(76116006)(66476007)(66446008)(38070700005)(38100700002)(26005)(6512007)(122000001)(2616005)(6506007)(83380400001)(1076003)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?R2owREpkUGZjVnBzZGtJUW4rbXI3b2xWYXRUUzJzRnVpTjhJYWY0T0tYTUto?=
 =?utf-8?B?cDdPQzgzZnFEckR3M2l3YzIvMElDODJTQUIxVmZnL3M1blMyeTMzdlJtUGgx?=
 =?utf-8?B?YmlLcndOeWxCWmxHVVByU2tZUXczNzkwaVpFZUhLa2N1aG5RZGNzOG5COGpV?=
 =?utf-8?B?Y3pranBWQVYvZ0tHbm9sUzlVT0lVZ1JwVDBOVVBQVkxQemZFdjAzQllqamJ4?=
 =?utf-8?B?ck1sOHZMRVFteFpFQUhsWm50djdYYTJxa21wNTVpWWtyaEtocWNLb1VVMGJx?=
 =?utf-8?B?dFEvTW5EUGg2SmpYZjB6SitBdTJBZmRzc0hrbTA2YWllZ3Zpblpvck05WVdu?=
 =?utf-8?B?Q0pzLzBnMzllb2ZPY1d4dS85TXd3dTJxcTFHd0ZtSlNnREFsMXhEQk1sWEJC?=
 =?utf-8?B?cDdGMDFPbG5rNGI4Yk5GSXNqK3pyR2dIT0NsZWJmMnA0OTV2RHVWU0xVQlFY?=
 =?utf-8?B?Z2NiRjVTLzhEanhpczF3c292QjVMbGt3UW5nc2R4M1FybCsvR2trallGa0Zy?=
 =?utf-8?B?RzVwRUQxNVdsVVMzKzVtSXVJazdnSzJPZFJvM0JmdXhxcHBodjU4VjdKRDI5?=
 =?utf-8?B?TjVxMzR1NU9NaTlDaG5UeGwxTDkwdXRINE5COHozdlZwOFBSbXNQT0hPQVVH?=
 =?utf-8?B?QjRhVzVibk5keFBnZm8zNFVRQXdRZjkzL1FlVTU1czJ3ak1iYytROFZlQjk5?=
 =?utf-8?B?WU82Uy9KcGxBM1UyNHlOQjBRZDhCUi96Um96cjBTbndMM3g0aXhNM2RwRGMx?=
 =?utf-8?B?aTNnV1Z4RmZkRHpETERYVWF3dXE0cjlIVjRCdWR2UlpqRmJiVFhFY3hKS1VR?=
 =?utf-8?B?dTNzWGtlalNodDF0TDRxYnJKbEpiL1VvclQ5dThKYStvMU5LWklKMGE1SndM?=
 =?utf-8?B?OHRKaSs3ZkczdFRYNHFmQUhZL1BFSWNoN3JjM29oWGdwSmFFcmozQ2tvUWRm?=
 =?utf-8?B?eUdGcGR3RnFzY2FDZHJuQnVJdGNWdjFiemViZjVYeHBESGNBNHJPN2Q1SXNN?=
 =?utf-8?B?aVJEanVCKzFMTCtIVFVSdEZLbU9hTjl2T0tSdnZ4Si9RdGx6bFZFZTFjQjgz?=
 =?utf-8?B?N1d4bVptc25NbE4xenRHc1BxM1VwYkFPSW1Wa1V4bHBtdzZ2cEFyWmJZbTBR?=
 =?utf-8?B?ZTZxN0hhSnd0Ukd2STg1Y29qa0lrYUZaa1JzVmpEM1krMGhhOVFCZ2dBdWE3?=
 =?utf-8?B?Q2MzY05XbWl3U2tHN2dMU3BvUVloMkdCSjdCbGtWaURvMm8yeXQzY3hJNlpk?=
 =?utf-8?B?VTdCeVpnN0hOdmhEMVhNNU44VVlaMlpTeDBtSytmTzNUbVp6VHJhV291ekFR?=
 =?utf-8?B?WmZoeU9BNXNNdFE1Z3ZGa1Vyc1d3aFNkakRCcnk4YWU5aVoraDZ5d204R2x3?=
 =?utf-8?B?NEQ2MGsxQnM4eXFXQTVVUGpqeXJFKzM5T2FiYm4vdlhHcDAreTIyeVJtVG1R?=
 =?utf-8?B?RmtGa3BVTEdsSEpEaDg3eEc5RmtPbVV6cS9jbll5VEVCK0tCcUdxQzJQbjFG?=
 =?utf-8?B?R1hJbmpFWWF3aEZUbXB6a2F5bnFhREdCNlBNZ0s5T2tmSjdNL3pDOWhrYytp?=
 =?utf-8?B?SjNab0kzWm5wQm9lWFprbXBzN1lpWlZkY0xWRDhUMmdqeTl2aVVCa0l1cEV6?=
 =?utf-8?B?bVhramF5c0grd0tiMHl5c21ta3FTcitCWUhTY3ZkMXVBZEF1R2l4MkNFK0hQ?=
 =?utf-8?B?U0VSeHlWLzB2cFRZcC8wN01Hd2h5MHRCSmlBVlpkWFFtblZOaE5qWTIxVWo2?=
 =?utf-8?B?TGdsa3lYNlhLZ0FBK0ttUGQzRFhrb0xlWWZncjhSRGlDM284MU95MFNmMmY2?=
 =?utf-8?B?aTltZ0laZXIxYUdQTHpaNWVBZ2h3a1VRRzNLcnpDeENMekJ5cmVGazlWZkRM?=
 =?utf-8?B?OElOcFBIYk9aSkNrdGRUVFpXSmljQitkaU1JNVkxdnA0bDlEV1hsRThlMUto?=
 =?utf-8?B?aHZScFFkTzJGK1lTcjQvL2JIZGFEMHdVNU5HT1NjRlZ6alI4dHhXeldrVGNw?=
 =?utf-8?B?RjJCbi9NMTdhM2Z1eXQ3MWliZ3F3VXY2MytHdVhaaCtqbStHNmkyY0FWdGM3?=
 =?utf-8?B?VEVSYUlrL2owSHRGUTNRSzl1WU9OZjhFZ0VwbFc4WTdiMkJ6MktlQTgyaWZh?=
 =?utf-8?Q?knv2XWwwQDDD8iGuBr5ZdLpL7?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7889DC11145631419B957EF6BAD93DF7@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4791.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29095e42-9a8e-43d1-2447-08dab17608b3
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Oct 2022 02:02:53.6093
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HvjoNpB+cz0RUyc1vFTRbGBwqpxEc6WCMrPoUZIUC79IzkN8A7iqArF2KWFmb2iEw84H9Go/L9Gre2H02ljh0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5066
X-Proofpoint-GUID: Dwsa63VwRBZPbri246d5bHcxgD4Rf9VF
X-Proofpoint-ORIG-GUID: Dwsa63VwRBZPbri246d5bHcxgD4Rf9VF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-18_10,2022-10-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_active_cloned_notspam policy=outbound_active_cloned score=0
 impostorscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 adultscore=0 clxscore=1011 mlxscore=0 lowpriorityscore=0
 priorityscore=1501 spamscore=0 phishscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210190009
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gVHVlLCBPY3QgMTgsIDIwMjIsIEplZmYgVmFuaG9vZiB3cm90ZToNCj4gSGkgVGhpbmgsDQo+
IA0KPiBPbiBUdWUsIE9jdCAxOCwgMjAyMiBhdCAxMDozNTozMFBNICswMDAwLCBUaGluaCBOZ3V5
ZW4gd3JvdGU6DQo+ID4gT24gVHVlLCBPY3QgMTgsIDIwMjIsIEplZmZyZXkgVmFuaG9vZiB3cm90
ZToNCj4gPiA+IEhpIFRoaW5oLA0KPiA+ID4gDQo+ID4gPiBPbiBUdWUsIE9jdCAxOCwgMjAyMiBh
dCAwNjo0NTo0MFBNICswMDAwLCBUaGluaCBOZ3V5ZW4gd3JvdGU6DQo+ID4gPiA+IEhpIERhbiwN
Cj4gPiA+ID4gDQo+ID4gPiA+IE9uIE1vbiwgT2N0IDE3LCAyMDIyLCBEYW4gVmFjdXJhIHdyb3Rl
Og0KPiA+ID4gPiA+IEhpIFRoaW5oLA0KPiA+ID4gPiA+IA0KPiA+ID4gPiA+IE9uIE1vbiwgT2N0
IDE3LCAyMDIyIGF0IDA5OjMwOjM4UE0gKzAwMDAsIFRoaW5oIE5ndXllbiB3cm90ZToNCj4gPiA+
ID4gPiA+IE9uIE1vbiwgT2N0IDE3LCAyMDIyLCBEYW4gVmFjdXJhIHdyb3RlOg0KPiA+ID4gPiA+
ID4gPiBGcm9tOiBKZWZmIFZhbmhvb2YgPHFqdjAwMUBtb3Rvcm9sYS5jb20+DQo+ID4gPiA+ID4g
PiA+IA0KPiA+ID4gPiA+ID4gPiBhcm0tc21tdSByZWxhdGVkIGNyYXNoZXMgc2VlbiBhZnRlciBh
IE1pc3NlZCBJU09DIGludGVycnVwdCB3aGVuDQo+ID4gPiA+ID4gPiA+IG5vX2ludGVycnVwdD0x
IGlzIHVzZWQuIFRoaXMgY2FuIGhhcHBlbiBpZiB0aGUgaGFyZHdhcmUgaXMgc3RpbGwgdXNpbmcN
Cj4gPiA+ID4gPiA+ID4gdGhlIGRhdGEgYXNzb2NpYXRlZCB3aXRoIGEgVFJCIGFmdGVyIHRoZSB1
c2JfcmVxdWVzdCdzIC0+Y29tcGxldGUgY2FsbA0KPiA+ID4gPiA+ID4gPiBoYXMgYmVlbiBtYWRl
LiAgSW5zdGVhZCBvZiBpbW1lZGlhdGVseSByZWxlYXNpbmcgYSByZXF1ZXN0IHdoZW4gYSBNaXNz
ZWQNCj4gPiA+ID4gPiA+ID4gSVNPQyBpbnRlcnJ1cHQgaGFzIG9jY3VycmVkLCB0aGlzIGNoYW5n
ZSB3aWxsIGFkZCBsb2dpYyB0byBjYW5jZWwgdGhlDQo+ID4gPiA+ID4gPiA+IHJlcXVlc3QgaW5z
dGVhZCB3aGVyZSBpdCB3aWxsIGV2ZW50dWFsbHkgYmUgcmVsZWFzZWQgd2hlbiB0aGUNCj4gPiA+
ID4gPiA+ID4gRU5EX1RSQU5TRkVSIGNvbW1hbmQgaGFzIGNvbXBsZXRlZC4gVGhpcyBsb2dpYyBp
cyBzaW1pbGFyIHRvIHNvbWUgb2YgdGhlDQo+ID4gPiA+ID4gPiA+IGNsZWFudXAgZG9uZSBpbiBk
d2MzX2dhZGdldF9lcF9kZXF1ZXVlLg0KPiA+ID4gPiA+ID4gDQo+ID4gPiA+ID4gPiBUaGlzIGRv
ZXNuJ3Qgc291bmQgcmlnaHQuIEhvdyBkaWQgeW91IGRldGVybWluZSB0aGF0IHRoZSBoYXJkd2Fy
ZSBpcw0KPiA+ID4gPiA+ID4gc3RpbGwgdXNpbmcgdGhlIGRhdGEgYXNzb2NpYXRlZCB3aXRoIHRo
ZSBUUkI/IERpZCB5b3UgY2hlY2sgdGhlIFRSQidzDQo+ID4gPiA+ID4gPiBIV08gYml0Pw0KPiA+
ID4gPiA+IA0KPiA+ID4gPiA+IFRoZSBwcm9ibGVtIHdlJ3JlIHNlZWluZyB3YXMgbWVudGlvbmVk
IGluIHRoZSBzdW1tYXJ5IG9mIHRoaXMgcGF0Y2gNCj4gPiA+ID4gPiBzZXJpZXMsIGlzc3VlICMx
LiBCYXNpY2FsbHksIHdpdGggdGhlIGZvbGxvd2luZyBwYXRjaA0KPiA+ID4gPiA+IGh0dHBzOi8v
dXJsZGVmZW5zZS5jb20vdjMvX19odHRwczovL3BhdGNod29yay5rZXJuZWwub3JnL3Byb2plY3Qv
bGludXgtdXNiL3BhdGNoLzIwMjEwNjI4MTU1MzExLjE2NzYyLTYtbS5ncnplc2NoaWtAcGVuZ3V0
cm9uaXguZGUvX187ISFBNEYyUjlHX3BnIWFTTlotSWpNY1BnTDQ3QTROUjVxcDlxaFZsUDkxVUdU
dUN4ZWo1TlJUdjgtRm1Uck1rS0s3Q2pOVG9RUVZFZ3RwcWJLekxVMkhYRVQ5TzIyNkFFTiQgIA0K
PiA+ID4gPiA+IGludGVncmF0ZWQgYSBzbW11IHBhbmljIGlzIG9jY3VycmluZyBvbiBvdXIgQW5k
cm9pZCBkZXZpY2Ugd2l0aCB0aGUgNS4xNQ0KPiA+ID4gPiA+IGtlcm5lbCB3aGljaCBpczoNCj4g
PiA+ID4gPiANCj4gPiA+ID4gPiAgICAgPDM+WyAgNzE4LjMxNDkwMF1bICBUODAzXSBhcm0tc21t
dSAxNTAwMDAwMC5hcHBzLXNtbXU6IFVuaGFuZGxlZCBhcm0tc21tdSBjb250ZXh0IGZhdWx0IGZy
b20gYTYwMDAwMC5kd2MzIQ0KPiA+ID4gPiA+IA0KPiA+ID4gPiA+IFRoZSB1dmMgZ2FkZ2V0IGRy
aXZlciBhcHBlYXJzIHRvIGJlIHRoZSBmaXJzdCAoYW5kIG9ubHkpIGdhZGdldCB0aGF0DQo+ID4g
PiA+ID4gdXNlcyB0aGUgbm9faW50ZXJydXB0PTEgbG9naWMsIHNvIHRoaXMgc2VlbXMgdG8gYmUg
YSBuZXcgY29uZGl0aW9uIGZvcg0KPiA+ID4gPiA+IHRoZSBkd2MzIGRyaXZlci4gSW4gb3VyIGNv
bmZpZ3VyYXRpb24sIHdlIGhhdmUgdXAgdG8gNjQgcmVxdWVzdHMgYW5kIHRoZQ0KPiA+ID4gPiA+
IG5vX2ludGVycnVwdD0xIGZvciB1cCB0byAxNSByZXF1ZXN0cy4gVGhlIGxpc3Qgc2l6ZSBvZiBk
ZXAtPnN0YXJ0ZWRfbGlzdA0KPiA+ID4gPiA+IHdvdWxkIGdldCB1cCB0byB0aGF0IGFtb3VudCB3
aGVuIGxvb3BpbmcgdGhyb3VnaCB0byBjbGVhbnVwIHRoZQ0KPiA+ID4gPiA+IGNvbXBsZXRlZCBy
ZXF1ZXN0cy4gRnJvbSB0ZXN0aW5nIGFuZCBkZWJ1Z2dpbmcgdGhlIHNtbXUgcGFuaWMgb2NjdXJz
DQo+ID4gPiA+ID4gd2hlbiBhIC1FWERFViBzdGF0dXMgc2hvd3MgdXAgYW5kIHJpZ2h0IGFmdGVy
DQo+ID4gPiA+ID4gZHdjM19nYWRnZXRfZXBfY2xlYW51cF9jb21wbGV0ZWRfcmVxdWVzdCgpIHdh
cyB2aXNpdGVkLiBUaGUgY29uY2x1c2lvbg0KPiA+ID4gPiA+IHdlIGhhZCB3YXMgdGhlIHJlcXVl
c3RzIHdlcmUgZ2V0dGluZyByZXR1cm5lZCB0byB0aGUgZ2FkZ2V0IHRvbyBlYXJseS4NCj4gPiA+
ID4gDQo+ID4gPiA+IEFzIEkgbWVudGlvbmVkLCBpZiB0aGUgc3RhdHVzIGlzIHVwZGF0ZWQgdG8g
bWlzc2VkIGlzb2MsIHRoYXQgbWVhbnMgdGhhdA0KPiA+ID4gPiB0aGUgY29udHJvbGxlciByZXR1
cm5lZCBvd25lcnNoaXAgb2YgdGhlIFRSQiB0byB0aGUgZHJpdmVyLiBBdCBsZWFzdCBmb3INCj4g
PiA+ID4gdGhlIHBhcnRpY3VsYXIgcmVxdWVzdCB3aXRoIC1FWERFViwgaXRzIFRSQnMgYXJlIGNv
bXBsZXRlZC4gSSdtIG5vdA0KPiA+ID4gPiBjbGVhciBvbiB5b3VyIGNvbmNsdXNpb24uDQo+ID4g
PiA+IA0KPiA+ID4gPiBEbyB3ZSBrbm93IHdoZXJlIGRpZCB0aGUgY3Jhc2ggb2NjdXI/IElzIGl0
IGZyb20gZHdjMyBkcml2ZXIgb3IgZnJvbSB1dmMNCj4gPiA+ID4gZHJpdmVyLCBhbmQgYXQgd2hh
dCBsaW5lPyBJdCdkIGdyZWF0IGlmIHdlIGNhbiBzZWUgdGhlIGRyaXZlciBsb2cuDQo+ID4gPiA+
DQo+ID4gPiANCj4gPiA+IFRvIGludGVyamVjdCwgd2hhdCBzaG91bGQgaGFwcGVuIGluIGR3YzNf
Z2FkZ2V0X2VwX3JlY2xhaW1fY29tcGxldGVkX3RyYiBpZiB0aGUNCj4gPiA+IElPQyBiaXQgaXMg
bm90IHNldCAoYnV0IHRoZSBJTUkgYml0IGlzKSBhbmQgLUVYREVWIHN0YXR1cyBpcyBwYXNzZWQg
aW50byBpdD8NCj4gPiANCj4gPiBIbS4uLiB3ZSBtYXkgaGF2ZSBvdmVybG9va2VkIHRoaXMgY2Fz
ZSBmb3Igbm9faW50ZXJydXB0IHNjZW5hcmlvLiBJZiBJTUkNCj4gPiBpcyBzZXQsIHRoZW4gdGhl
cmUgd2lsbCBiZSBhbiBpbnRlcnJ1cHQgd2hlbiB0aGVyZSdzIG1pc3NlZCBpc29jDQo+ID4gcmVn
YXJkbGVzcyBvZiB3aGV0aGVyIG5vX2ludGVycnVwdCBpcyBzZXQgYnkgdGhlIGdhZGdldCBkcml2
ZXIuDQo+ID4gDQo+ID4gPiBJZiB0aGUgZnVuY3Rpb24gcmV0dXJucyAwLCBhbm90aGVyIGF0dGVt
cHQgdG8gcmVjbGFpbSBtYXkgb2NjdXIuIElmIHRoaXMNCj4gPiA+IGhhcHBlbnMgYW5kIHRoZSBu
ZXh0IHJlcXVlc3QgZGlkIGhhdmUgdGhlIEhXTyBiaXQgc2V0LCB0aGUgZnVuY3Rpb24gd291bGQN
Cj4gPiA+IHJldHVybiAxIGJ1dCBkd2MzX2dhZGdldF9lcF9jbGVhbnVwX2NvbXBsZXRlZF9yZXF1
ZXN0IHdvdWxkIHN0aWxsIGNhbGwNCj4gPiA+IGR3YzNfZ2FkZ2V0X2dpdmViYWNrLg0KPiA+ID4g
DQo+ID4gPiBBcyBhIHRlc3QgKHdpdGhvdXQgdGhpcyBwYXRjaCksIEkgYWRkZWQgYSBjaGVjayB0
byBzZWUgaWYgSFdPIGJpdCB3YXMgc2V0IGluDQo+ID4gPiBkd2MzX2dhZGdldF9lcF9jbGVhbnVw
X2NvbXBsZXRlZF9yZXF1ZXN0cygpLiBJZiB0aGUgdXNlY2FzZSB3YXMgSVNPQyBhbmQgdGhlDQo+
ID4gPiBIV08gYml0IHdhcyBzZXQgSSBhdm9pZGVkIGNhbGxpbmcgZHdjM19nYWRnZXRfZXBfY2xl
YW51cF9jb21wbGV0ZWRfcmVxdWVzdCgpLg0KPiA+ID4gVGhpcyBzZWVtZWQgdG8gYWxzbyBhdm9p
ZCB0aGUgaW9tbXUgcmVsYXRlZCBjcmFzaCBiZWluZyBzZWVuLg0KPiA+ID4gDQo+ID4gPiBJcyB0
aGVyZSBhbiBpc3N1ZSBpbiB0aGlzIGFyZWEgdGhhdCBuZWVkcyB0byBiZSBjb3JyZWN0ZWQgaW5z
dGVhZD8gTm90IGhhdmluZw0KPiA+ID4gaW50ZXJydXB0cyBzZXQgZm9yIGVhY2ggcmVxdWVzdCBt
YXkgYmUgY2F1c2luZyBzb21lIG5ldyBpc3N1ZXMgdG8gYmUgdW5jb3ZlcmVkLg0KPiA+ID4gDQo+
ID4gPiBBcyBmYXIgYXMgdGhlIGNyYXNoIHNlZW4gd2l0aG91dCB0aGlzIHBhdGNoLCBubyBnb29k
IHN0YWNrdHJhY2UgaXMgZ2l2ZW4uIExpbmUNCj4gPiA+IHByb3ZpZGVkIGZvciBjcmFzaCB2YXJp
ZWQgYSBiaXQsIGJ1dCB0ZW5kZWQgdG8gYXBwZWFyIHRvd2FyZHMgdGhlIGVuZCBvZg0KPiA+ID4g
ZHdjM19zdG9wX2FjdGl2ZV90cmFuc2ZlcigpIG9yIGR3YzNfZ2FkZ2V0X2VuZHBvaW50X3RyYnNf
Y29tcGxldGUoKS4NCj4gPiA+IA0KPiA+ID4gU2luY2UgZHdjM19nYWRnZXRfZW5kcG9pbnRfdHJi
c19jb21wbGV0ZSgpIGNhbiBiZSBjYWxsZWQgZnJvbSBtdWx0aXBsZQ0KPiA+ID4gbG9jYXRpb25z
LCBJIGR1cGxpY2F0ZWQgdGhlIGZ1bmN0aW9uIHRvIGhlbHAgaWRlbnRpZnkgd2hpY2ggcGF0aCBp
dCB3YXMgbGlrZWx5DQo+ID4gPiBiZWluZyBjYWxsZWQgZnJvbS4gQXQgdGhlIHRpbWUgb2YgdGhl
IGNyYXNoZXMgc2VlbiwNCj4gPiA+IGR3YzNfZ2FkZ2V0X2VuZHBvaW50X3RyYW5zZmVyX2luX3By
b2dyZXNzKCkgYXBwZWFyZWQgdG8gYmUgdGhlIGNhbGxlci4NCj4gPiA+IA0KPiA+ID4gZHdjM19n
YWRnZXRfZW5kcG9pbnRfdHJhbnNmZXJfaW5fcHJvZ3Jlc3MoKQ0KPiA+ID4gLT5kd2MzX2dhZGdl
dF9lbmRwb2ludF90cmJzX2NvbXBsZXRlKCkgKGNyYXNoZWQgdG93YXJkcyBlbmQgb2YgaGVyZSkN
Cj4gPiA+IC0+ZHdjM19zdG9wX2FjdGl2ZV90cmFuc2ZlcigpIChzb21ldGltZXMgY3Jhc2hlZCB0
b3dhcmRzIGVuZCBvZiBoZXJlKQ0KPiA+ID4gDQo+ID4gPiBJIGhvcGUgdGhpcyBjbGFyaWZpZXMg
dGhpbmdzIGEgYml0Lg0KPiA+ID4gIA0KPiA+IA0KPiA+IENhbiB3ZSB0cnkgdGhpcz8gTGV0IG1l
IGtub3cgaWYgaXQgcmVzb2x2ZXMgeW91ciBpc3N1ZS4NCj4gPiANCj4gPiBkaWZmIC0tZ2l0IGEv
ZHJpdmVycy91c2IvZHdjMy9nYWRnZXQuYyBiL2RyaXZlcnMvdXNiL2R3YzMvZ2FkZ2V0LmMNCj4g
PiBpbmRleCA2MWZiYTJiNzM4OWIuLjgzNTJmNGI1ZGQ5ZiAxMDA2NDQNCj4gPiAtLS0gYS9kcml2
ZXJzL3VzYi9kd2MzL2dhZGdldC5jDQo+ID4gKysrIGIvZHJpdmVycy91c2IvZHdjMy9nYWRnZXQu
Yw0KPiA+IEBAIC0zNjU3LDYgKzM2NTcsMTAgQEAgc3RhdGljIGludCBkd2MzX2dhZGdldF9lcF9y
ZWNsYWltX2NvbXBsZXRlZF90cmIoc3RydWN0IGR3YzNfZXAgKmRlcCwNCj4gPiAgCWlmIChldmVu
dC0+c3RhdHVzICYgREVQRVZUX1NUQVRVU19TSE9SVCAmJiAhY2hhaW4pDQo+ID4gIAkJcmV0dXJu
IDE7DQo+ID4gIA0KPiA+ICsJaWYgKHVzYl9lbmRwb2ludF94ZmVyX2lzb2MoZGVwLT5lbmRwb2lu
dC5kZXNjKSAmJg0KPiA+ICsJICAgIChldmVudC0+c3RhdHVzICYgREVQRVZUX1NUQVRVU19NSVNT
RURfSVNPQykgJiYgIWNoYWluKQ0KPiA+ICsJCXJldHVybiAxOw0KPiA+ICsNCj4gPiAgCWlmICgo
dHJiLT5jdHJsICYgRFdDM19UUkJfQ1RSTF9JT0MpIHx8DQo+ID4gIAkgICAgKHRyYi0+Y3RybCAm
IERXQzNfVFJCX0NUUkxfTFNUKSkNCj4gPiAgCQlyZXR1cm4gMTsNCj4gPg0KPiANCj4gV2l0aCB0
aGlzIGNoYW5nZSBpdCBkb2Vzbid0IHNlZW0gdG8gY3Jhc2ggYnV0IHVuZm9ydHVuYXRlbHkgdGhl
IG91dHB1dA0KPiBjb21wbGV0ZWx5IGhhbmdzIGFmdGVyIHRoZSBmaXJzdCBtaXNzZWQgaXNvYy4g
QXQgdGhlIG1vbWVudCBJIGRvIG5vdCB1bmRlcnN0YW5kDQo+IHdoeSB0aGlzIG1pZ2h0IGhhcHBl
bi4gDQo+IA0KDQpDYW4geW91IGNhcHR1cmUgdGhlIGRyaXZlciB0cmFjZXBvaW50cyB3aXRoIHRo
ZSBjaGFuZ2UgYWJvdmU/DQoNCj4gDQo+IE5vdGUgdGhhdCBJIGhhdmVuJ3QgcXVpdGUgbGVhcm5l
ZCBjb3JyZWN0bHkgaG93IHRvIHJlcGx5IGNvcnJlY3QgdG8gdGhlIG1haWxpbmcNCj4gbGlzdC4g
IEkgYXBwb2xvZ2l6ZSBmb3IgbWVzc2luZyB1cCB0aGUgdGhyZWFkIGEgYml0Lg0KPiANCg0KU2Vl
bXMgZmluZSB0byBtZS4gQXMgbG9uZyBhcyBJIGNhbiByZWFkIGFuZCB1bmRlcnN0YW5kLCBJJ3Zl
IG5vIGlzc3VlLiA6KQ0KDQpUaGFua3MsDQpUaGluaA==
