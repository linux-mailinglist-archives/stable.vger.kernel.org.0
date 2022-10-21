Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC839606CB4
	for <lists+stable@lfdr.de>; Fri, 21 Oct 2022 02:56:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbiJUA43 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Oct 2022 20:56:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiJUA42 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Oct 2022 20:56:28 -0400
Received: from mx0a-00230701.pphosted.com (mx0a-00230701.pphosted.com [148.163.156.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A24191B65E6;
        Thu, 20 Oct 2022 17:56:26 -0700 (PDT)
Received: from pps.filterd (m0098571.ppops.net [127.0.0.1])
        by mx0a-00230701.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29L0bqLf007445;
        Thu, 20 Oct 2022 17:56:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfptdkimsnps;
 bh=hYXau0RL5gsSGJNGiYfgKygPTcXGqQVZXw+QD4LtkxY=;
 b=UN7H/7vimBHorlSg81SNLxqq1Ok/4E6RfM03hA5FwOZIBfasix7O4ruvx+y2NkRKecyH
 zjsHUQ4VSbtsd2PAeZsNflqiYnxJB/n5heGCrJK0YRIFhNbGSs1k+J9ckl/mjEfGZQwj
 a51tfgth55L0gjTVGuYQVpcU6AOeWQQANm2Tc8KnwLA6Tma0qCTEUprrUJlM4WckTqHW
 nQG/VOIocv9MuxBoMKjekUUJdG7JVrbRT25qPRQGuwYmlstHctmFN28DOqSSa9Y3mI01
 oOjLL0SPOpC5O3fnostU8u+HLwyEmjsD+upyJWwLH1N68U1t0464TnNLmtu6h6CNoYW6 Bw== 
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.73.133])
        by mx0a-00230701.pphosted.com (PPS) with ESMTPS id 3k7uvntuyp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Oct 2022 17:56:02 -0700
Received: from mailhost.synopsys.com (us03-mailhost2.synopsys.com [10.4.17.18])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 7BCBA40916;
        Fri, 21 Oct 2022 00:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1666313762; bh=hYXau0RL5gsSGJNGiYfgKygPTcXGqQVZXw+QD4LtkxY=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=Sn3Skr7cl5LygNYX3vqE3np57T+4bsfJoJ9r9YcGNmzp2ulJJE/nLtwHIMv3q1ptI
         HJ6Xx5SDaX3TPoxVdUj5nxW6wYVwsGtOKxHwn7yrJeZno/sEgj/JZ+YwYC1vFjZIuw
         9y2vcjL/bYdU955+TrfWhRU5lCS9LyzjHAmSOxtNVeCxUwtQsL/8K0p/Gx9dH0y+r6
         CXX8zXbX/M6xsA7qJP7dP5g1Vn+B+aok/MLrzlyC5XzzeLuat341SM0H9I5U+r+gjW
         d4qZei4XX2EEt/TeckhNCknwE6gzgCXJF16qGFz3mZfPldhy6HtwxewSRUYItOjXqX
         9pnvDwEd1nTrw==
Received: from o365relay-in.synopsys.com (sv2-o365relay3.synopsys.com [10.202.1.139])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "o365relay-in.synopsys.com", Issuer "Entrust Certification Authority - L1K" (verified OK))
        by mailhost.synopsys.com (Postfix) with ESMTPS id B97A4A00A6;
        Fri, 21 Oct 2022 00:55:59 +0000 (UTC)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11lp2173.outbound.protection.outlook.com [104.47.56.173])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.protection.outlook.com", Issuer "DigiCert Cloud Services CA-1" (verified OK))
        by o365relay-in.synopsys.com (Postfix) with ESMTPS id 5C5224009B;
        Fri, 21 Oct 2022 00:55:58 +0000 (UTC)
Authentication-Results: o365relay-in.synopsys.com; dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relay-in.synopsys.com; spf=pass smtp.mailfrom=thinhn@synopsys.com
Authentication-Results: o365relay-in.synopsys.com;
        dkim=pass (1024-bit key; unprotected) header.d=synopsys.com header.i=@synopsys.com header.b="Cj84w2jF";
        dkim-atps=neutral
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dM3Z+w0XIJ4N4QbSOuYwvvBx9Agb/9HKKU1KAsDBJ5p14iEvyTm2xFga67F3h6tEFOQ5xRq5mWBFKAGEaF8aV5J3hV3tLJMbsytPnG2xIceUKPElkloCSkgcIPlMfv4OSSkxYHdTiYTTIyKkh6fOODvhPmLRF7BlayjD8R4wxd2P5Ba6eQeMX3X6P2XQYV2bOuOIrm5/Q2q3uN0Qsw/TFSCfsqA9Cgobzb+lFcnNeZm2RkKAIbOoFDuY1X/ez22nOiQecKtZnzf0irNLZ56U49rpuGtMBvFvvJ5bpUoMPRfL0G8tUrBLM8eTV/bcIJkq9obtvtzHrCHxk7aeJtvNjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hYXau0RL5gsSGJNGiYfgKygPTcXGqQVZXw+QD4LtkxY=;
 b=SSfzTRA+UaHEzTCtm/kFsiyDEZV/RR8I2yu/mrXuHuq/EDBxFmmP8K3LIR/Skfx6QjVKOwmkBTe9szV0OiMe914ale1zrVLOFA1dVEEzZr2Xdu9cR7cGAtbcufvljQbw/LSqWLpQMLeVrWPemyIjnvvSZVpDucrz6VCF71o9a6rwznQPmt+RiJJfDaydp2E8jWsMRVRaQkr5W493mQnhHdRcAfcPMV8W86w/NhTDq1F10mZzM/Q/KSzmUjJd6q/WRrLs3xB2o+jeMYONQmONgGMJ9FE2vrRp1Sr4ayXRTiALMLcqdtg2P8vnHNaX3kh90ZiGafPoxzyyQ0fVs9ikyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hYXau0RL5gsSGJNGiYfgKygPTcXGqQVZXw+QD4LtkxY=;
 b=Cj84w2jFMP0D4w6WQ5RNBFOx3BCFBzWfUy50my4RoEJs25FXYL7BLk0nUYJiT4LGExn0phhmtRB06Sja39LU82CHUgZn2M0yw8bjtQOtYYzoDFxkE7KrtOHxujpBa7oElx6ha9QjQJ9x1OVBgkhFNIUReuYUMQ9Ma9eFghLcGX4=
Received: from BYAPR12MB4791.namprd12.prod.outlook.com (2603:10b6:a03:10a::12)
 by MN2PR12MB4318.namprd12.prod.outlook.com (2603:10b6:208:1d8::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.34; Fri, 21 Oct
 2022 00:55:51 +0000
Received: from BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::525b:92b6:eafc:8629]) by BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::525b:92b6:eafc:8629%7]) with mapi id 15.20.5676.031; Fri, 21 Oct 2022
 00:55:51 +0000
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
To:     Jeff Vanhoof <jdv1029@gmail.com>
CC:     Jeffrey Vanhoof <jvanhoof@motorola.com>,
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
Thread-Index: AQHY4zLbXRUpqdOqTUOotJbe2PZC1K4UvWqAgAAz6gCAAAYCAIAAXncAgADAGYCAACjDAIAAGaCAgAEonwCAAGR9AIAAI9+A
Date:   Fri, 21 Oct 2022 00:55:51 +0000
Message-ID: <20221021005537.3vbtair35umh6vo2@synopsys.com>
References: <PUZPR03MB613101A170B0034F55401121A1289@PUZPR03MB6131.apcprd03.prod.outlook.com>
 <20221018223521.ytiwqsxmxoen5iyt@synopsys.com>
 <20221019014108.GA5732@qjv001-XeonWs>
 <20221019020240.exujmo7uvae4xfdi@synopsys.com>
 <20221019074043.GA19727@qjv001-XeonWs>
 <20221019190819.m35ai5fm3g5qpgqj@synopsys.com>
 <20221019213410.GA17789@qjv001-XeonWs>
 <20221019230555.gwovdtmnopwacirt@synopsys.com>
 <20221020164732.GA25496@qjv001-XeonWs>
 <20221020224714.6v7djacqvl5xkc2w@synopsys.com>
In-Reply-To: <20221020224714.6v7djacqvl5xkc2w@synopsys.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR12MB4791:EE_|MN2PR12MB4318:EE_
x-ms-office365-filtering-correlation-id: 27e8f64d-f01b-4f2d-f185-08dab2ff0006
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1ubcKietvzELoYncB35Nz6OQvRSaW9UsvhpL8zmmkW2u1E8ZqglANWyphlMyTWtYA5ygML8U2rqOZ1Pi3hVzktVXOM2Yu5/esCMRJ48CyjRcjgDY0z1pxs/tNg5+8bTKhVzZ1RTwpLYeBAGiy8n5ZJ0LMYEGRDiSU+HFvU+RAMtFjnDC+EZffxCBVZSuOni78x/9iK1ODzb6Ws7tZa3YUxpOe++Ax0eHC3p4s9E/jvFzCd2AFEwaj3csZIeEuhjGHkwN9NZXdxANdhK3TMe5WjwW9/BIOoJKX8uEIdbwFY/e/kPYkf18WGw5FOfyTVWfYMZo8qKmhctimXhCgZTgHDHBqLiq8tN3FYc9QDBuZKKDyE/IdlmUXzX9NYOIGP2ZruAbjMUJ2ueKH6xO+bu+UwsUUHbpasxQCqs3CoO7iHJ3QkhPfmgaYwJwqLw6fBorsJrSriMgZb5rCYsKGPPvyhtTaBNR3K856S3pGgzJSgw1fqX9Q9olXGEM7QHtEVYAoV05bn9oM7QYNHZSzHSLShrmqyYwkcrUewGJheEP583SQWVOX9ALOzT3/TeZzTavYhvT1qFAOyzdIEtbiRdbTMxC0iUIAHYwCxE3Dg2gkJOX/+xzSSSmv6XcqBe0IiaHfhCdJEu2dm4NPOucTyWBfVANeSWYOCsqim3he5VuEOTeS/2YHf2e+iQvbpAaR460z0Lmeu8Z8FBPCp99e/XBt5hIq0U/hpiTvH+3wdtgLKdh3GhLvurMzXYk90et9lzN70Qfh4KDYQyseu4tpodkdA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4791.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(376002)(39860400002)(396003)(366004)(346002)(451199015)(36756003)(86362001)(66476007)(66446008)(41300700001)(66556008)(38100700002)(66946007)(38070700005)(2616005)(64756008)(83380400001)(6506007)(1076003)(186003)(5660300002)(478600001)(76116006)(122000001)(2906002)(316002)(6916009)(8936002)(8676002)(4326008)(7416002)(6486002)(26005)(54906003)(6512007)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eFRmSXFDTGZCUk5FdlAwcVo4ejJvUUtad1kzcDlQd0pKazMwNC9MMDJaczRP?=
 =?utf-8?B?SmFWUHpQem8rcEJHbkxVZEpneEdGQlNGWGlDNE5PUFIraDNTR2swV2EyY3dt?=
 =?utf-8?B?Z0ZJNVBxNVM0MUh4S0RBMWUydHJreitmczV0d291bVRUc0RCa3hqNkNtN1lT?=
 =?utf-8?B?ZWIyQmNOZmxGajRKMVdCSmF6cTBpQjI4Y1hYdHJNUzc1dWtaQlI1U3VGMDBX?=
 =?utf-8?B?Q0VsN0RWd3BTVm02dzArRnU3NEN2Y2hyK20za2xhM3gyZElKL3dvZHZNRXFL?=
 =?utf-8?B?V2o1cVlVWUZjeU1VeTB5UXdwZlB2ZGM1ZEhyREVlMnlYcCtYNE9ZUHZoSWtU?=
 =?utf-8?B?emRkOHlVUW9mN1BYWmE0d01QWU1nM2pPaFFGVUpVb05hNGo2SEtOWjFIeXcy?=
 =?utf-8?B?V1hIWElMOTdHdDV1RnZVYU5rSWlGOHUxdGFGK2cyT1VrZHJJcEdYR1ZGRjIx?=
 =?utf-8?B?RkJwOUlySnBOV0tidi9FWTU2YjN4NlVmbEhtUEZUUHYzR3prUGhRLzltOHNy?=
 =?utf-8?B?aFZGTjNiOWw4UkJwbitMODZsOTdGSUtHZ0NLc0s0MVBEbWVuMW1SSkRxZC9i?=
 =?utf-8?B?a0RUdjhDWlY4bUpIMFR5SzFTMVRTaEphSm01SXByY0xvREM4Y1hLZ2oxVGU0?=
 =?utf-8?B?MndNZEhqYi9MNFExZDFSNzdBM0piR2RXd1k4N0lnaHQ5SC9oS3JHcnZEazdB?=
 =?utf-8?B?TzhSU0RVd0NNWjNWMHUwYm9KQ0ZicnhJRSt4bzFWazBmS0ZVNi9UK3FuTzgv?=
 =?utf-8?B?OUZWYkNlWElMdVVGNk82ZEZ4RWRXZEQ0b2FVZ1IzeXBDTjVMQ2M3TXJBQnY1?=
 =?utf-8?B?UmJNWHZrdW1FSEcrVFY4Mlhhc25KYm4xdnVORVA0NEtqeGxESlNxdmM5dlB4?=
 =?utf-8?B?emRFOUtvaThsZjdDL2Vha0kwV2hNamZzZ3l4Rkd6ejNCeGVDc3I3RGg1VHA4?=
 =?utf-8?B?c2EzRlk5enNNWjBFS1hxanRFcy94dGNvcmFpK1d2NkVadUdnWkw5Y2VHdEhX?=
 =?utf-8?B?SDV1NmNkVTZrUnVTaWIrN3lVbWZBZ21WOG56dnRSVHJJOVc1WmVrZHc2MHM4?=
 =?utf-8?B?VnFQNGlRZEVCODlaalVOZGFKZ1pGZStRZWllbnBCOTB5eXJsOStQYU1BNWtu?=
 =?utf-8?B?emVPak9YbUYwWFFFZzNLd1dpd09RZURSaUVGUzdXcjRTR0RodlRsNWNLaTli?=
 =?utf-8?B?VFlDemV0MnN0UnhNdTQ4K1QrRjdEcklpcXRTbnNZUlA5cHlrUmNyTFBDR1p6?=
 =?utf-8?B?OURXdkNQTE1mb3hMUVpnV01SdHdkQ3NEUVRmRkJqQ2hUZTFBR1VubWJ1amZZ?=
 =?utf-8?B?QlJnOUxHdUJoSzB5UW85WlVOWnlsVU9uVmN4SHluUXEraWhaUTVTc0NZbUlm?=
 =?utf-8?B?RVExUEhUYU0rT3FtTW16TExxOGMrSWJ4OGx1K2YwZjdLUFhyTkJOanM3SkJm?=
 =?utf-8?B?MlNQazhwK2VJYU00bkFYVHJ2aWNzYVplZmttMGx2Z28rWktVaDF6SW9sSU0z?=
 =?utf-8?B?SlNsN3p4VEdEK1Nuc1NENWxFcTJRdTlhYmduWkpVSnhNT2Q5SUR6RTVQS0pJ?=
 =?utf-8?B?UmhIeExrakxSZ1pGSSttTjI0NzhUSFh4ays0c1RZRzZVVHI0Nm45YXp5Nkho?=
 =?utf-8?B?ak81dkZ0QUNVK3Zxb05sNTZEMnZ6V2pab3lKSEpqV2EwM1pseCtxV2lCcHVR?=
 =?utf-8?B?bTMrQmtvUElhb09sdllacUZJT0JTYTY0MnBsdW1QdkYxSDZndEFoVTcrci9l?=
 =?utf-8?B?NEhxakVJRGdIRkU5VTlieFlXZzJ0YStFZ3J1aTFKNlAvMlVTYkNhdUJjMUd1?=
 =?utf-8?B?TUhrREE3R0RvZ3JHRFFETDB5TENZYUtrS3pZMzJRODV3VlMySnRDQm12eTVu?=
 =?utf-8?B?SG92N1ova09RSWF2aHRtWFRCQm5ic3hSbkhKVVRVTW92WWE0ODdLSGtSaUll?=
 =?utf-8?B?b1NJYjBtcDRjeE9wWDdnMWxDNjI0VVNMd2IvSnNETXBLaWI3UStsNTdkQ0tM?=
 =?utf-8?B?d200U0p6YU9TdldUM3dPbUxqenlRTm9XblVGR0xoUit6aWZpS2xQN2JQWHpQ?=
 =?utf-8?B?U0pkNjgvYnN3NWdDNU9WY3RPdzNNSkRKSEtMY2V4dzNYdXIxUXpkZEhuS1BD?=
 =?utf-8?Q?aiPbaDtFVzb3RidFULyoiSVnH?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <905B77A74C835F4D85D249556A056F64@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4791.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27e8f64d-f01b-4f2d-f185-08dab2ff0006
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Oct 2022 00:55:51.2893
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: g6vX90f6h0rxllbDcMaZCczxoUQQuQmodzoqWrB6vMVKsHGMN7IvMcaBATJ7FzK9tSrvGgw2QVTaBxkh/nyZxA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4318
X-Proofpoint-ORIG-GUID: sqa_2Q4zt5Xm16NfY8pReFFnTDobpbvm
X-Proofpoint-GUID: sqa_2Q4zt5Xm16NfY8pReFFnTDobpbvm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-20_13,2022-10-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_active_cloned_notspam policy=outbound_active_cloned score=0
 adultscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0 spamscore=0
 clxscore=1015 impostorscore=0 phishscore=0 priorityscore=1501 bulkscore=0
 malwarescore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2209130000 definitions=main-2210210003
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gVGh1LCBPY3QgMjAsIDIwMjIsIFRoaW5oIE5ndXllbiB3cm90ZToNCj4gT24gVGh1LCBPY3Qg
MjAsIDIwMjIsIEplZmYgVmFuaG9vZiB3cm90ZToNCj4gPiBIaSBUaGluaCwNCj4gPiANCj4gPiBP
biBXZWQsIE9jdCAxOSwgMjAyMiBhdCAxMTowNjowOFBNICswMDAwLCBUaGluaCBOZ3V5ZW4gd3Jv
dGU6DQo+ID4gPiBIaSwNCj4gPiA+IA0KPiA+ID4gT24gV2VkLCBPY3QgMTksIDIwMjIsIEplZmYg
VmFuaG9vZiB3cm90ZToNCj4gPiA+ID4gSGkgVGhpbmgsDQo+ID4gPiA+IE9uIFdlZCwgT2N0IDE5
LCAyMDIyIGF0IDA3OjA4OjI3UE0gKzAwMDAsIFRoaW5oIE5ndXllbiB3cm90ZToNCj4gPiA+ID4g
PiBPbiBXZWQsIE9jdCAxOSwgMjAyMiwgSmVmZiBWYW5ob29mIHdyb3RlOg0KPiA+ID4gDQo+ID4g
PiA8c25pcD4NCj4gPiA+IA0KPiA+ID4gPiA+ID4gDQo+ID4gPiA+ID4gPiBGcm9tIHdoYXQgSSBj
YW4gZ2F0aGVyIGZyb20gdGhlIGxvZywgd2l0aCB0aGUgY3VycmVudCBjaGFuZ2VzIGl0IHNlZW1z
IHRoYXQNCj4gPiA+ID4gPiA+IGFmdGVyIGEgbWlzc2VkIGlzb2MgZXZlbnQgZmV3IHJlcXVlc3Rz
IGFyZSBzdGF5aW5nIGxvbmdlciB0aGFuIGV4cGVjdGVkIGluIHRoZQ0KPiA+ID4gPiA+ID4gc3Rh
cnRlZF9saXN0IChub3QgZ2V0dGluZyByZWNsYWltZWQpIGFuZCB0aGlzIGlzIHByZXZlbnRpbmcg
dGhlIHRyYW5zbWlzc2lvbg0KPiA+ID4gPiA+ID4gZnJvbSBzdG9wcGluZy9zdGFydGluZyBhZ2Fp
biwgYW5kIG9wZW5pbmcgdGhlIGRvb3IgZm9yIGNvbnRpbnVvdXMgc3RyZWFtIG9mDQo+ID4gPiA+
ID4gPiBtaXNzZWQgaXNvYyBldmVudHMgdGhhdCBjYXVzZSB3aGF0IGFwcGVhcnMgdG8gdGhlIHVz
ZXIgYXMgYSBmcm96ZW4gdmlkZW8uDQo+ID4gPiA+ID4gPiANCj4gPiA+ID4gPiA+IFNvIG9uZSB0
aG91Z2h0LCBpZiBJT0MgYml0IGlzIG5vdCBzZXQgZXZlcnkgZnJhbWUsIGJ1dCBJTUkgYml0IGlz
LCB3aGVuIGENCj4gPiA+ID4gPiA+IG1pc3NlZCBpc29jIHJlbGF0ZWQgaW50ZXJydXB0IG9jY3Vy
cyBpdCBzZWVtcyBsaWtlbHkgdGhhdCBtb3JlIHRoYW4gb25lIHRyYg0KPiA+ID4gPiA+ID4gcmVx
dWVzdCB3aWxsIG5lZWQgdG8gYmUgcmVjbGFpbWVkLCBidXQgdGhlIGN1cnJlbnQgc2V0IG9mIGNo
YW5nZXMgaXMgbm90DQo+ID4gPiA+ID4gPiBoYW5kbGluZyB0aGlzLg0KPiA+ID4gPiA+ID4gDQo+
ID4gPiA+ID4gPiBJbiB0aGUgZ29vZCB0cmFuc2ZlciBjYXNlIHRoaXMgaXNzdWUgc2VlbXMgdG8g
YmUgdGFrZW4gY2FyZSBvZiBzaW5jZSB0aGUgSU9DDQo+ID4gPiA+ID4gPiBiaXQgaXMgbm90IHNl
dCBldmVyeSBmcmFtZSBhbmQgdGhlIHJlY2xhaW1hdGlvbiB3aWxsIGxvb3AgdGhyb3VnaCBldmVy
eSBpdGVtIGluDQo+ID4gPiA+ID4gPiB0aGUgc3RhcnRlZF9saXN0IGFuZCBvbmx5IHN0b3AgaWYg
dGhlcmUgYXJlIG5vIGFkZGl0aW9uYWwgdHJicyBvciBpZiBvbmUgaGFzDQo+ID4gPiA+ID4gDQo+
ID4gPiA+ID4gSXQgc2hvdWxkIHN0b3AgYXQgdGhlIHJlcXVlc3QgdGhhdCBhc3NvY2lhdGVkIHdp
dGggdGhlIGludGVycnVwdCBldmVudCwNCj4gPiA+ID4gPiB3aGV0aGVyIGl0J3MgYmVjYXVzZSBv
ZiBJTUkgb3IgSU9DLg0KPiA+ID4gPiANCj4gPiA+ID4gSW4gdGhpcyBjYXNlIEkgd2FzIGNvbmNl
cm5lZCB0aGF0IGlmIG11bHRpcGxlZCBxdWV1ZWQgcmVxcyBkaWQgbm90IGhhdmUgSU9DIGJpdA0K
PiA+ID4gPiBzZXQsIGJ1dCB0aGVyZSB3YXMgYSBtaXNzZWQgaXNvYyBvbiBvbmUgb2YgdGhlIGxh
c3QgcmVxcywgd2hldGhlciBvciBub3Qgd2Ugd291bGQNCj4gPiA+ID4gcmVjbGFpbSBhbGwgb2Yg
dGhlIHJlcXVlc3RzIHVwIHRvIHRoZSBtaXNzZWQgaXNvYyByZWxhdGVkIHJlcS4gSSdtIG5vdCBz
dXJlIGlmDQo+ID4gPiA+IG15IGNvbmNlcm4gaXMgdmFsaWQgb3Igbm90Lg0KPiA+ID4gPiANCj4g
PiA+IA0KPiA+ID4gVGhlcmUgc2hvdWxkIGJlIG5vIHByb2JsZW0uIElmIHRoZXJlJ3MgYW4gaW50
ZXJydXB0IGV2ZW50IGluZGljYXRpbmcgYQ0KPiA+ID4gVFJCIGNvbXBsZXRpb24sIHRoZSBkcml2
ZXIgd2lsbCBnaXZlIGJhY2sgYWxsIHRoZSByZXF1ZXN0cyB1cCB0byB0aGUNCj4gPiA+IHJlcXVl
c3QgYXNzb2NpYXRlZCB3aXRoIHRoZSBpbnRlcnJ1cHQgZXZlbnQsIGFuZCB0aGUgY29udHJvbGxl
ciB3aWxsDQo+ID4gPiBjb250aW51ZSBwcm9jZXNzaW5nIHRoZSByZW1haW5pbmcgVFJCcy4gT24g
dGhlIG5leHQgVFJCIGNvbXBsZXRpb24NCj4gPiA+IGV2ZW50LCB0aGUgZHJpdmVyIHdpbGwgYWdh
aW4gZ2l2ZSBiYWNrIGFsbCB0aGUgcmVxdWVzdHMgdXAgdG8gdGhlDQo+ID4gPiByZXF1ZXN0IGFz
c29jaWF0ZWQgd2l0aCB0aGF0IGV2ZW50Lg0KPiA+ID4NCj4gPiANCj4gPiBJIHdhcyB0ZXN0aW5n
IHdpdGggdGhlIGZvbGxvd2luZyBwYXRjaCB5b3Ugc3VnZ2VzdGVkOg0KPiA+IA0KPiA+ID4gZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvdXNiL2R3YzMvZ2FkZ2V0LmMgYi9kcml2ZXJzL3VzYi9kd2MzL2dh
ZGdldC5jDQo+ID4gPiBpbmRleCA2MWZiYTJiNzM4OWIuLjgzNTJmNGI1ZGQ5ZiAxMDA2NDQNCj4g
PiA+IC0tLSBhL2RyaXZlcnMvdXNiL2R3YzMvZ2FkZ2V0LmMNCj4gPiA+ICsrKyBiL2RyaXZlcnMv
dXNiL2R3YzMvZ2FkZ2V0LmMNCj4gPiA+IEBAIC0zNjU3LDYgKzM2NTcsMTAgQEAgc3RhdGljIGlu
dCBkd2MzX2dhZGdldF9lcF9yZWNsYWltX2NvbXBsZXRlZF90cmIoc3RydWN0IGR3YzNfZXAgKmRl
cCwNCj4gPiA+ICAJaWYgKGV2ZW50LT5zdGF0dXMgJiBERVBFVlRfU1RBVFVTX1NIT1JUICYmICFj
aGFpbikNCj4gPiA+ICAJCXJldHVybiAxOw0KPiA+ID4gIA0KPiA+ID4gKwlpZiAodXNiX2VuZHBv
aW50X3hmZXJfaXNvYyhkZXAtPmVuZHBvaW50LmRlc2MpICYmDQo+ID4gPiArCSAgICAoZXZlbnQt
PnN0YXR1cyAmIERFUEVWVF9TVEFUVVNfTUlTU0VEX0lTT0MpICYmICFjaGFpbikNCj4gPiA+ICsJ
CXJldHVybiAxOw0KPiA+ID4gKw0KPiA+ID4gIAlpZiAoKHRyYi0+Y3RybCAmIERXQzNfVFJCX0NU
UkxfSU9DKSB8fA0KPiA+ID4gIAkgICAgKHRyYi0+Y3RybCAmIERXQzNfVFJCX0NUUkxfTFNUKSkN
Cj4gPiA+ICAJCXJldHVybiAxOw0KPiA+ID4NCj4gPiANCj4gPiBBdCB0aGlzIHRpbWUgdGhlIElN
SSBiaXQgd2FzIHNldCBmb3IgZXZlcnkgZnJhbWUuIFdpdGggdGhlc2UgY2hhbmdlcyBpdA0KPiA+
IGFwcGVhcmVkIGluIGNhc2Ugb2YgbWlzc2VkIGlzb2MgdGhhdCBzb21ldGltZXMgbm90IGFsbCBy
ZXF1ZXN0cyB3b3VsZCBiZQ0KPiA+IHJlY2xhaW1lZCAoZW5xdWV1ZWQgIT0gZGVxdWV1ZWQgZXZl
biAxMDBtcyBhZnRlciB0aGUgbGFzdCBpbnRlcnJ1cHQgd2FzDQo+ID4gaGFuZGxlZCkuIElmIHRo
ZSAxc3QgcmVxIGluIHRoZSBzdGFydGVkX2xpc3Qgd2FzIGZpbmUgKElNSSBzZXQsIGJ1dCBub3Qg
SU9DKSwNCj4gPiBhbmQgYSBsYXRlciByZXEgd2FzIHRoZSBvbmUgYWN0dWFsbHkgbWlzc2VkLCBi
ZWNhdXNlIG9mIHRoaXMgc3RhdHVzIGNoZWNrIHRoZQ0KPiA+IHJlY2xhaW1hdGlvbiBjb3VsZCBz
dG9wIGVhcmx5IGFuZCBub3QgY2xlYW4gdXAgdG8gdGhlIGFwcHJvcHJpYXRlIHJlcS4gQXMNCj4g
DQo+IE9vcHMuIFlvdSdyZSByaWdodC4NCj4gDQo+ID4gc3VnZ2VzdGVkIHllc3RlcmRheSwgSSBh
bHNvIHRyaWVkIG9ubHkgc2V0dGluZyB0aGUgSU1JIGJpdCB3aGVuIG5vX2ludGVycnVwdCBpcw0K
PiA+IG5vdCBzZXQsIGhvd2V2ZXIgSSB3YXMgc3RpbGwgc2VlaW5nIHRoZSBjb21wbGV0ZSBmcmVl
emVzLiBBZnRlciBhbmFseXppbmcgdGhpcw0KPiA+IGlzc3VlIGEgYml0LCBJIGhhdmUgdXBkYXRl
ZCB0aGUgZGlmZiB0byBsb29rIG1vcmUgbGlrZSB0aGlzOg0KPiA+IA0KPiA+IGRpZmYgLS1naXQg
YS9kcml2ZXJzL3VzYi9kd2MzL2dhZGdldC5jIGIvZHJpdmVycy91c2IvZHdjMy9nYWRnZXQuYw0K
PiA+IGluZGV4IGRmYWY5YWMyNGM0Zi4uYmI4MDBhODE4MTViIDEwMDY0NA0KPiA+IC0tLSBhL2Ry
aXZlcnMvdXNiL2R3YzMvZ2FkZ2V0LmMNCj4gPiArKysgYi9kcml2ZXJzL3VzYi9kd2MzL2dhZGdl
dC5jDQo+ID4gQEAgLTEyMzAsOCArMTIzMCw5IEBAIHN0YXRpYyB2b2lkIF9fZHdjM19wcmVwYXJl
X29uZV90cmIoc3RydWN0IGR3YzNfZXAgKmRlcCwgc3RydWN0IGR3YzNfdHJiICp0cmIsDQo+ID4g
IAkJCXRyYi0+Y3RybCA9IERXQzNfVFJCQ1RMX0lTT0NIUk9OT1VTOw0KPiA+ICAJCX0NCj4gPiAg
DQo+ID4gLQkJLyogYWx3YXlzIGVuYWJsZSBJbnRlcnJ1cHQgb24gTWlzc2VkIElTT0MgKi8NCj4g
PiAtCQl0cmItPmN0cmwgfD0gRFdDM19UUkJfQ1RSTF9JU1BfSU1JOw0KPiA+ICsJCS8qIGVuYWJs
ZSBJbnRlcnJ1cHQgb24gTWlzc2VkIElTT0MgKi8NCj4gPiArCQlpZiAoKCFub19pbnRlcnJ1cHQg
JiYgIWNoYWluKSB8fCBtdXN0X2ludGVycnVwdCkNCj4gPiArCQkgICAgdHJiLT5jdHJsIHw9IERX
QzNfVFJCX0NUUkxfSVNQX0lNSTsNCj4gPiAgCQlicmVhazsNCj4gDQo+IEVpdGhlciBhbGwgb3Ig
bm9uZSBvZiB0aGUgVFJCcyBvZiBhIHJlcXVlc3QgaXMgc2V0IHdpdGggSU1JLCBhbmQgbm90DQo+
IHNvbWUuDQo+IA0KPiA+ICANCj4gPiAgCWNhc2UgVVNCX0VORFBPSU5UX1hGRVJfQlVMSzoNCj4g
PiBAQCAtMzE5NSw2ICszMTk2LDExIEBAIHN0YXRpYyBpbnQgZHdjM19nYWRnZXRfZXBfcmVjbGFp
bV9jb21wbGV0ZWRfdHJiKHN0cnVjdCBkd2MzX2VwICpkZXAsDQo+ID4gIAlpZiAoZXZlbnQtPnN0
YXR1cyAmIERFUEVWVF9TVEFUVVNfU0hPUlQgJiYgIWNoYWluKQ0KPiA+ICAJCXJldHVybiAxOw0K
PiA+ICANCj4gPiArCWlmICh1c2JfZW5kcG9pbnRfeGZlcl9pc29jKGRlcC0+ZW5kcG9pbnQuZGVz
YykgJiYNCj4gPiArCQkoZXZlbnQtPnN0YXR1cyAmIERFUEVWVF9TVEFUVVNfTUlTU0VEX0lTT0Mp
ICYmICFjaGFpbg0KPiA+ICsJCSYmICh0cmItPmN0cmwgJiBEV0MzX1RSQl9DVFJMX0lTUF9JTUkp
KQ0KPiA+ICsJCXJldHVybiAxOw0KPiA+ICsNCj4gPiAgCWlmICgodHJiLT5jdHJsICYgRFdDM19U
UkJfQ1RSTF9JT0MpIHx8DQo+ID4gIAkgICAgKHRyYi0+Y3RybCAmIERXQzNfVFJCX0NUUkxfTFNU
KSkNCj4gPiAgCQlyZXR1cm4gMTsNCj4gPiANCj4gPiBXaGVyZSB0aGUgdHJiIG11c3QgaGF2ZSB0
aGUgSU1JIHNldCBiZWZvcmUgcmV0dXJuaW5nIGVhcmx5LiBUaGlzIHNlZW1lZCB0byBtYWtlDQo+
ID4gdGhlIGZyZWV6ZXMgcmVjb3ZlcmFibGUuDQo+IA0KPiBDYW4geW91IHRyeSB0aGlzIHJldmlz
ZWQgY2hhbmdlOg0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvdXNiL2R3YzMvZ2FkZ2V0LmMg
Yi9kcml2ZXJzL3VzYi9kd2MzL2dhZGdldC5jDQo+IGluZGV4IDYxZmJhMmI3Mzg5Yi4uYTY5ZDhj
MjhkODZiIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL3VzYi9kd2MzL2dhZGdldC5jDQo+ICsrKyBi
L2RyaXZlcnMvdXNiL2R3YzMvZ2FkZ2V0LmMNCj4gQEAgLTM2NTQsNyArMzY1NCw3IEBAIHN0YXRp
YyBpbnQgZHdjM19nYWRnZXRfZXBfcmVjbGFpbV9jb21wbGV0ZWRfdHJiKHN0cnVjdCBkd2MzX2Vw
ICpkZXAsDQo+ICAJaWYgKCh0cmItPmN0cmwgJiBEV0MzX1RSQl9DVFJMX0hXTykgJiYgc3RhdHVz
ICE9IC1FU0hVVERPV04pDQo+ICAJCXJldHVybiAxOw0KPiAgDQo+IC0JaWYgKGV2ZW50LT5zdGF0
dXMgJiBERVBFVlRfU1RBVFVTX1NIT1JUICYmICFjaGFpbikNCg0KSSBhY2NpZGVudGFsbHkgZGVs
ZXRlZCBhIGNvdXBsZSBvZiBsaW5lcyBoZXJlLg0KDQo+ICsJaWYgKERXQzNfVFJCX1NJWkVfVFJC
U1RTKHRyYi0+c2l6ZSkgPT0gRFdDM19UUkJTVFNfTUlTU0VEX0lTT0MgJiYgIWNoYWluKQ0KPiAg
CQlyZXR1cm4gMTsNCj4gIA0KPiAgCWlmICgodHJiLT5jdHJsICYgRFdDM19UUkJfQ1RSTF9JT0Mp
IHx8DQoNCkkgbWVhbnQgdG8gZG8gdGhpczoNCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvdXNiL2R3
YzMvZ2FkZ2V0LmMgYi9kcml2ZXJzL3VzYi9kd2MzL2dhZGdldC5jDQppbmRleCA2MWZiYTJiNzM4
OWIuLmNiNjUzNzE1NzJlZSAxMDA2NDQNCi0tLSBhL2RyaXZlcnMvdXNiL2R3YzMvZ2FkZ2V0LmMN
CisrKyBiL2RyaXZlcnMvdXNiL2R3YzMvZ2FkZ2V0LmMNCkBAIC0zNjU3LDYgKzM2NTcsOSBAQCBz
dGF0aWMgaW50IGR3YzNfZ2FkZ2V0X2VwX3JlY2xhaW1fY29tcGxldGVkX3RyYihzdHJ1Y3QgZHdj
M19lcCAqZGVwLA0KIAlpZiAoZXZlbnQtPnN0YXR1cyAmIERFUEVWVF9TVEFUVVNfU0hPUlQgJiYg
IWNoYWluKQ0KIAkJcmV0dXJuIDE7DQogDQorCWlmIChEV0MzX1RSQl9TSVpFX1RSQlNUUyh0cmIt
PnNpemUpID09IERXQzNfVFJCU1RTX01JU1NFRF9JU09DICYmICFjaGFpbikNCisJCXJldHVybiAx
Ow0KKw0KIAlpZiAoKHRyYi0+Y3RybCAmIERXQzNfVFJCX0NUUkxfSU9DKSB8fA0KIAkgICAgKHRy
Yi0+Y3RybCAmIERXQzNfVFJCX0NUUkxfTFNUKSkNCiAJCXJldHVybiAxOw0KQEAgLTM2NzMsNiAr
MzY3Niw3IEBAIHN0YXRpYyBpbnQgZHdjM19nYWRnZXRfZXBfcmVjbGFpbV90cmJfc2coc3RydWN0
IGR3YzNfZXAgKmRlcCwNCiAJc3RydWN0IHNjYXR0ZXJsaXN0ICpzOw0KIAl1bnNpZ25lZCBpbnQg
bnVtX3F1ZXVlZCA9IHJlcS0+bnVtX3F1ZXVlZF9zZ3M7DQogCXVuc2lnbmVkIGludCBpOw0KKwli
b29sIG1pc3NlZF9pc29jID0gZmFsc2U7DQogCWludCByZXQgPSAwOw0KIA0KIAlmb3JfZWFjaF9z
ZyhzZywgcywgbnVtX3F1ZXVlZCwgaSkgew0KQEAgLTM2ODEsMTIgKzM2ODUsMTggQEAgc3RhdGlj
IGludCBkd2MzX2dhZGdldF9lcF9yZWNsYWltX3RyYl9zZyhzdHJ1Y3QgZHdjM19lcCAqZGVwLA0K
IAkJcmVxLT5zZyA9IHNnX25leHQocyk7DQogCQlyZXEtPm51bV9xdWV1ZWRfc2dzLS07DQogDQor
CQlpZiAoRFdDM19UUkJfU0laRV9UUkJTVFModHJiLT5zaXplKSA9PSBEV0MzX1RSQlNUU19NSVNT
RURfSVNPQykNCisJCQltaXNzZWRfaXNvYyA9IHRydWU7DQorDQogCQlyZXQgPSBkd2MzX2dhZGdl
dF9lcF9yZWNsYWltX2NvbXBsZXRlZF90cmIoZGVwLCByZXEsDQogCQkJCXRyYiwgZXZlbnQsIHN0
YXR1cywgdHJ1ZSk7DQogCQlpZiAocmV0KQ0KIAkJCWJyZWFrOw0KIAl9DQogDQorCWlmIChtaXNz
ZWRfaXNvYykNCisJCXJldCA9IDE7DQorDQogCXJldHVybiByZXQ7DQogfQ0KIA0KDQpCUiwNClRo
aW5o
