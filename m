Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34D1263B1F9
	for <lists+stable@lfdr.de>; Mon, 28 Nov 2022 20:15:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233284AbiK1TO5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Nov 2022 14:14:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233258AbiK1TOv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Nov 2022 14:14:51 -0500
Received: from mx0b-00230701.pphosted.com (mx0b-00230701.pphosted.com [148.163.158.9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBE081B9E0;
        Mon, 28 Nov 2022 11:14:49 -0800 (PST)
Received: from pps.filterd (m0098572.ppops.net [127.0.0.1])
        by mx0b-00230701.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ASIbMtj032568;
        Mon, 28 Nov 2022 11:14:35 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfptdkimsnps;
 bh=HRbttxVzsGksA47N5iuEO/z2qI7w3gb5rnGaGkH7p30=;
 b=I9TwtCLMMni2LyNz5OcqayA5sZSGCF0X7BrbuwSeoJhYBygm4J7jaN/OlXkogosG6Mns
 ku8Q0hXe/2v8H4m0pSH5h8JsVGE2VttW6FuWt8V+zhUR/KRtrCSPrEa13zato1lYsh/4
 etmmWS2pwcbkiSVjhxWXhW6CvzeCJGXnWOsC8dGC7qfKRTbHqLIjCEPvbMGBMy0oc3E5
 O9RAnHnzZLRMugHrXi+p1mOX9ODPe39ILd3hbvzeEl97QpKL206GPkFtAoRLINi38lBo
 E2zEE1YLNfrpAaN+Ne6LtcYj1q4WUVZq5Nv3aelehrDnBOZf8H6ieeIhBSsV6xEJXAd5 WQ== 
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.87.133])
        by mx0b-00230701.pphosted.com (PPS) with ESMTPS id 3m3jamr9bq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Nov 2022 11:14:35 -0800
Received: from mailhost.synopsys.com (sv2-mailhost2.synopsys.com [10.205.2.134])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id B4002C00FD;
        Mon, 28 Nov 2022 19:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1669662865; bh=HRbttxVzsGksA47N5iuEO/z2qI7w3gb5rnGaGkH7p30=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=H6WUDf6FdvzDL0gZGg/Y/J5gALYIp+57HbEdNFtwXbDBaTstN30qnx7SYpYAkRJNa
         CSaf/CNDjCRqgm9QAWT3Cb7NIAkNe072qGJwBeK+/vLZXT/IN5D9a1pmBYMJoAKrk8
         CQy0qKrYfXBq9HfsHrKVf06UhLUMlcNR5XGL/fk41MBWcARm7SaRgPBJdop1V1Glnr
         YRIhW8PJHA9WXVPfblvn82gxaI/kdJlW36cG5lCW3NdrAuLjWSmzAS2yRCAAhTTgFN
         +AU3D3OtXFIb2zuq4mEwetCWgUEbAYXa0GqPHWehRYDk9o/MYJa/R3ZIAafq2ZrUP3
         9/mzLqXaH2dxA==
Received: from o365relay-in.synopsys.com (us03-o365relay1.synopsys.com [10.4.161.137])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "o365relay-in.synopsys.com", Issuer "Entrust Certification Authority - L1K" (verified OK))
        by mailhost.synopsys.com (Postfix) with ESMTPS id 6F6C8A0099;
        Mon, 28 Nov 2022 19:14:22 +0000 (UTC)
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2048.outbound.protection.outlook.com [104.47.51.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.protection.outlook.com", Issuer "DigiCert Cloud Services CA-1" (verified OK))
        by o365relay-in.synopsys.com (Postfix) with ESMTPS id 47353801A6;
        Mon, 28 Nov 2022 19:14:19 +0000 (UTC)
Authentication-Results: o365relay-in.synopsys.com; dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relay-in.synopsys.com; spf=pass smtp.mailfrom=thinhn@synopsys.com
Authentication-Results: o365relay-in.synopsys.com;
        dkim=pass (1024-bit key; unprotected) header.d=synopsys.com header.i=@synopsys.com header.b="FpQT4JpF";
        dkim-atps=neutral
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DcA3f4j98BlnJYz2ztak30cG6XTl0Gjghoo8X3K8kcEMXgBZ80mcIySRVcQ9EWtZLAeCLGkSYxSPS+qkoxP6/tFk8uXy3PGppUufSYQHY6NUeZoh6TZfbAE2m4Ja7sXt5PtK5M+dlcHIZzc/2eKP/+Iyg4gqvcmlZOTL0fVB9h/oZh6thx9bmpsSKAQyV+yTSa+3BBZEclWn9zk/cVTobLJ7BC1WZiomQhWa3ssofPknd0JV+ctSMcPAfyYgKTGcMK7JN4QjHvCJxg6U5YCqCGjdOGMHjSM1vyerkYt0Eb+c0Sx+XBObY5yxJ7LJz5rqFrkQVgCOOG6DOA9AGyTItg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HRbttxVzsGksA47N5iuEO/z2qI7w3gb5rnGaGkH7p30=;
 b=JPVDASL7mvrJwxU0osA87so0RkfOUoNAIKzZKTs2LECro/p43w/t9IhRGPeQB7pie2ZtAu+Bv3MISsXfSCAGIhlcyFnhBOD6123DqWjl+tbcRWuXgsCMx3P+Sg3071G/yC+bbK9kebZ9lmCYKJMTulFOWH8+I59wwPV6ldA6UE7hsAXJCBBXNhHkk7OUuHua9VmEU80WtPp7v6765PnlV7+6uo2OuoNZqhU1GW4MwXBLxMZTrfuDjG78JCdq262gy0Md8AVgauGiXSPnoxdKNTmZjwQtjXi1R6xyKYNVJx5zbN27wqI4Swe1RC9VFdL0HfcpFbqhqbXvDbssIKIFYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HRbttxVzsGksA47N5iuEO/z2qI7w3gb5rnGaGkH7p30=;
 b=FpQT4JpFWBlReofnpBCjNxvcXxTIieZTPZ4QNcRGEpll8kHO/UILnDFgL4LCW9yGAaqMAvWTGuxzgrfwO1CqJUEqOxVJ2lSNqnTLP5gU6RD8ks3+/LvYbyiYsEKLDupSnYzVGSgC9tAOiUzEv4+iBpaRb7FX7j+8AgbfgWNx1xU=
Received: from BYAPR12MB4791.namprd12.prod.outlook.com (2603:10b6:a03:10a::12)
 by CY8PR12MB7243.namprd12.prod.outlook.com (2603:10b6:930:58::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.22; Mon, 28 Nov
 2022 19:14:16 +0000
Received: from BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::e395:902b:2e90:b7ee]) by BYAPR12MB4791.namprd12.prod.outlook.com
 ([fe80::e395:902b:2e90:b7ee%4]) with mapi id 15.20.5857.022; Mon, 28 Nov 2022
 19:14:16 +0000
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
To:     Sven Peter <sven@svenpeter.dev>
CC:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        Janne Grunau <j@jannau.net>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "asahi@lists.linux.dev" <asahi@lists.linux.dev>
Subject: Re: [PATCH] usb: dwc3: Fix race between dwc3_set_mode and
 __dwc3_set_mode
Thread-Topic: [PATCH] usb: dwc3: Fix race between dwc3_set_mode and
 __dwc3_set_mode
Thread-Index: AQHZA0SqgmV2kv5VLUW7EPm4cAMrk65UtKeA
Date:   Mon, 28 Nov 2022 19:14:16 +0000
Message-ID: <20221128191411.b57fmzppso2xdnna@synopsys.com>
References: <20221128161526.79730-1-sven@svenpeter.dev>
In-Reply-To: <20221128161526.79730-1-sven@svenpeter.dev>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR12MB4791:EE_|CY8PR12MB7243:EE_
x-ms-office365-filtering-correlation-id: 30983e90-44eb-43ec-1792-08dad174be25
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9NHv+yJp8ORWvdD5DAcz+B0kxVymFnLzqftp8TKJWq8EfDjKDTtApQXRjzsepmze8DH+9k4q79U/b2O1cKVibOXJwn35SSjYkYadIWUC69fgUkNAQqy1Gq1LayBGGWix9RT0kSWjLxz4Iqv0wlCEnLwg5L8gDqFebTdrOcCyyIhklqd9G1AamXYI+nvy0gPcOTbXKNmhXimN/mFV/cVuRpOznldPW5dwRnHODUYy9rsHEF0O7CkbPlB39iixTcuD07cBXJ/ZFDaXyJwIRRYz2x/rctfUOZS/zXzQncaAh/v0Z6Hy9yblZrUwZYAPNkBNUSYMk8qwY2grRztYXBfJpwgZHTzd81PknHDV/dtxuKrS63edj2bkbnEwdxBYSVvhlqdYCyqVW3Do7V4K9mB/X/+FX84ztuPNvl0JHGOcxNQXBoZNn/7dSLLwQReMOZvLp4C8+AiM6NRd2uvPHKokcF0/+IzxjTHrIGyaRPz+vNzHL2wI2kuN0k6QgXIg7FSLbtxt5zBRgXhotWS/8f2TKzt6IVNBcfoxF60/6LZIaFWkSMpI2cspSaZmj88Z8/JprfuRJUHk4j6lLDN05Cn3CTON5vOYQIsbbbPLOKSEQMMDbjC52EMcGUIjd2ukouvVhDgEGlGX9XZSBPcAy0+K7FialK/Zg/9b3JYfE3ALqXWLprYQBAB5HkMRCD/W+/i7
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB4791.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(39860400002)(396003)(376002)(136003)(346002)(451199015)(86362001)(36756003)(186003)(316002)(41300700001)(54906003)(66446008)(1076003)(66946007)(66476007)(76116006)(66556008)(83380400001)(64756008)(6512007)(71200400001)(26005)(2616005)(5660300002)(4326008)(6506007)(8676002)(478600001)(38070700005)(6916009)(6486002)(8936002)(122000001)(38100700002)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?anBJOWFDR3NidUt2MDVFWnhUd0t2bDB4aXVlRnNiQTJhMGYvMnBZZE1Ibnpn?=
 =?utf-8?B?Q0g2WDh2dEVodGVoOXdBYVBVR2pxamplazZINkV4TEVSaTF5bURQdFJUcW5D?=
 =?utf-8?B?czV1Mi9abEh5UkJmQzF2THhTdDY5K2pNdnRpbmZyU2dsSi9UbnZ3dEdvQjRT?=
 =?utf-8?B?NkU4WEkrbXY5TGNsTGhBT0VFYkQxYmdaeUtodDluV28zWlR3RENNMzZaS1BI?=
 =?utf-8?B?QkROblUzZUVxMUJjU3ZrT3lRZGFCZ3FLMjVoR0dBSkYxRDVhdlQza0lQY1py?=
 =?utf-8?B?cUp6MDFkZVZndTFCQWY4eDEzdGp5ZXFQeWI0WmpDSTFQSmdVOUVHb0lBY3R6?=
 =?utf-8?B?R1RHMURIbHRObXVsd1lZd3NiZ1NKdmVLbHc0MjNaWEdJNlp2TGZ3WDEwdWQ2?=
 =?utf-8?B?SlJvQWh2NjhqMzRZK3kyU1gzV3B0ZmcxV0I1bTZMbzBRNnphQlI4ZlNoNGtv?=
 =?utf-8?B?NFE3U3BFSHVlQXVrSkNhRGlENUtGVnpYV09PUkpPa2wxMmxRQ2YzbzRKWWU5?=
 =?utf-8?B?UndhRzR4eVFuaDRnY0ZGR29rSzhuRndndi9ZeUt1ZFZvVkFFWEkxRmtQSjZh?=
 =?utf-8?B?Z1ZDcTREU2ZXdEpyeUFYQll3Z05kTEFLSkxhcWszZGZ1V2VVYm9BRUVxbXJ0?=
 =?utf-8?B?b2YrdFhNZVZlNWNhVGF1R2w3aUNGcnAvZjhhSGpMNWlib25XQUE1bGd5K0ty?=
 =?utf-8?B?NXY3Q3ZoWkJ5N0ZCTjlrOGRqL1BiWmxIYmxKYnhhWUNKSW10V29wc0l3WUFw?=
 =?utf-8?B?K1c1eG5mdE9va3RTSWR5cmdKSFhEYjlVYWc2VUI0Rnp6R2dqT0VwWlFENWds?=
 =?utf-8?B?YndCMXNYcFRGdzlJNVFsRXRseHNuODRrbjVydSttTGl5OG5BVzh0WXpXRC9v?=
 =?utf-8?B?OVhOVFY2c0xFcUpqWEE5SDlBbnRCMVBjSXBaTUNwQXFSTVdXdEhuRWkvQzdr?=
 =?utf-8?B?ZzhoaVBxdnZlc2pQSW1oT1I3aEQ5bDZpRG4wS0lscDhnTFZnK2NvWnZGVk1s?=
 =?utf-8?B?MXVET2l1eXNlb1VrKzUxclBONG9yYU53T0UxTEJ2UXVJeERoYllGS2VCbXFy?=
 =?utf-8?B?Z29qNWhjbCtCQnord2Zick1LYkhIM2tUQ2VXVWFKMVhHMHpBYmJOWXB2MnlH?=
 =?utf-8?B?dFFkZVBMMGt5ajFRck9ENDh1aDFzQ1h5MGE1MGdtanVycXNCWGZVSVFwbUhG?=
 =?utf-8?B?OUVUQVFBOEhVeXdEL0hFRGFvaVM5VTYwaWZjdWhFNGRCN3ByQ1pFblpQaFh0?=
 =?utf-8?B?K2QxUnJaZHN2SStwM2VBNE5zT2xVaWUvMjAydm5yRE4remFTUXpuTDBXbC9Y?=
 =?utf-8?B?NjNnaVRjVEdtY040OHlzTE5YNER5SVl6TGYrSU8wTi96YjZ4WC9kM1JyUVhC?=
 =?utf-8?B?RHpJc1Rqd09xNlFmRU9EeUE1UTBzZ2dmb1lKeEZzRDl3cXZIQVZLYmMxczkx?=
 =?utf-8?B?ZnpJOFZVTWhwWC9GelB5Qks0U3lSZzJBdVJNUmpSb2EzZ1NtYitkUFFjMEd2?=
 =?utf-8?B?RmYrQ0g5N1AyY1c0ZWNjZVNhTlpTN0c3TzFUak5rWG9nSEt1bjNHYmVldG1Y?=
 =?utf-8?B?emxrZFA2ZDZ1TEpHMkZ6M3lRVE13N2NpdHJmbVo0bkVhN3RZZTVRY2xJKzNi?=
 =?utf-8?B?cDlJS3BqM3B1QU5DRThMNG1pVFFrOFFDdWdkNDhmRkZTMzVpK0FFOGZPUFV1?=
 =?utf-8?B?TDk4N2hWZW9pSC9kWlJTTUVWdE9OSkE5OGgxNGxjL1RlWXJBVWxOWVcwNEtM?=
 =?utf-8?B?bWIwQ2ltS1E4blZlZWFwY1pYbzhGMTBDdlRiRTRFNGlleHpiQWFQUnFFRC9w?=
 =?utf-8?B?dkw3WHNQKzBnZG9idytRYW9Ba3k3d0Z3THRTM3ZFSm1TMUV2V2RiTFJaeVlZ?=
 =?utf-8?B?VTVFNlB4YmlHWXBtM0I4QVBjQks3M0NiaGsvN2JoRE12dXZxZzYrMHlOL1JY?=
 =?utf-8?B?RkUyb1hNWDVBVTkzU2NuKytrV0NqbVg4VXJTU2s5MENVTkdqK2F3U2MwVUZE?=
 =?utf-8?B?a1J0ekVrZVovQWFNWVFXbWxIb3lKeE5tbGduZTF4VkVyVjdzL1RRbzFscU5M?=
 =?utf-8?B?VlZ5WkI0ZlZ3SjFSL25ncjArTzJlS2s3VFhrQUNOSVJjQ0h4Yno0aEMzUjg1?=
 =?utf-8?Q?8870yVISKyq+nfoaqtutFgT4U?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <25D00FA4BB3ECA43AE5D0770C8416F11@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?alBvTTRyMWR0YmorVXBmbG9TbkJZWUE5S1FXNWxQSllTR0grckwxOFcrc01v?=
 =?utf-8?B?VTJyUnZTNytqTlJzS3RqK1dkTWlmdFliNFc4VzN0Ujc3V0l3elVyU0YxaDhq?=
 =?utf-8?B?cjd4cHFaamw2Q0tYSFZrYWdrbldMMXU2VXY0VGE0b3dOdzZockhvMW1mWEQy?=
 =?utf-8?B?dVhpRGRQd1JaYmpoM25Oa09NMVJaMjJFL3VROHBrMlFJekRBaXljbFpqUmkw?=
 =?utf-8?B?czYyYWFtSE5nNXVvZlJ6Q0FnU0ZXVUxJcEwzWEx5Zy9yRVFnM0JDYXpPc1dZ?=
 =?utf-8?B?VG9lR0tnaFBsK3BRQWN6LzM5QVFoRldQbFBnSlViUVRGVlNyTldvY3FZaVVq?=
 =?utf-8?B?L2lIZG1iRUFZYml2L1hxcTlmNWV6L0syajZlVDROY09kbUwydGp3d1VTN1or?=
 =?utf-8?B?blVWRUJDbGpxR3d1UUU0cmhlbU82Nm1PQWJHMEIwaVJEQTE2Szl3S2NtSXdk?=
 =?utf-8?B?Wk1CRHNVdXcxN2I3QllsNWR1K09aS0pZeTRNM3FBbXBrYXhsRmJHMGxNZFZQ?=
 =?utf-8?B?UnYrUmx5SUZMOVdaVGkyblphTmRsanVTMkhvV0ZSMjhiREl4ZnFiODF4bmJo?=
 =?utf-8?B?TUU1UEdGeHRuR2hZTmVtSzFISzRCYUNQd0lrdU9vcnRUTUdKanAwejZ3b0pJ?=
 =?utf-8?B?emJkZFhXQy9VY0Ntcnh1VDRZcEFkUWVaQXIwdWc3b1FUTThDUU5TMHRSUTRa?=
 =?utf-8?B?VHd2ZUhtZ0VRSWwvYmhLZjMzSjJMdW5BVTJDUWk0YVRLV1NYU0FBdld6eXNi?=
 =?utf-8?B?bmV6NTN3S1d6TWFLeVdLTExRWXFUcXlFVnFhTkdveDlWWjBsNDVuV28zVGU5?=
 =?utf-8?B?bHg1WmhUOEEvQVRyMmRuTG9kMXJxdlNxd3AvTjFJZzdQVGJsQVdjall4V3hn?=
 =?utf-8?B?QWgwTWRDeWJSd1RoSnVLclo1L2xjUVJEYVZBak5HZFJ0WVpkQU9vajZWUGtP?=
 =?utf-8?B?c2xrTzBNMUtadzhJRHBQc3h1cUJlNUlqWjFyM0ZUeW5mTTUydm9SK0kzSXFs?=
 =?utf-8?B?TUZMTzFhVjV3NjVOMmRlanhpZU5LRlhiZTZrcXJwRTBySmlPVjBJeksrYmw0?=
 =?utf-8?B?L3NUU2hSNzJyTzZNQVlVL05tZGJPQS9TZ0F0N3pzcWMvbklIeU1KUUZyYmlu?=
 =?utf-8?B?c3dvT3RDckZ3NUlVTVcxcDhrRzRTdlB1T2MvY0NBVTNkVmhlUEJlaXNQY21Y?=
 =?utf-8?B?N1ZKaThCaDZMTHFyUkR5NEJTdUx6bm1yS1g5Nm9JK2JFU2c2a3BIQy9tMFFH?=
 =?utf-8?B?U3hUVEd3SnhmZkh2Y1JaWHNIZlJ5dzNPclMxRkNKdEhSMGFRVkhoaDkrYmx5?=
 =?utf-8?B?N0dyQWU0Y0FFMDVnazh3eHQ1RldzdFBUTE1hUUxWODZ3aGFSM2tNTDVhelRM?=
 =?utf-8?B?NWp5OGlYVHBsUTZJS1l4ZlRMRng1cXg4eGQ4bG13disxOGZkWGhLaVh3djVx?=
 =?utf-8?B?NVZQVHNkRis5SW9makxnajFPcnMrNVgzT2o3VEpBPT0=?=
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB4791.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30983e90-44eb-43ec-1792-08dad174be25
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Nov 2022 19:14:16.2391
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AeAyUBx32A2HefEv5wHn3qlZje6KutP2NAnOIikRYQBM3qxDcjbaxDhd1TDHy/vPUEuqcd7CAJE9nhgnYFX4qA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7243
X-Proofpoint-GUID: ICi1I86IZV-wzoD597BbqpiIrBu7ey6r
X-Proofpoint-ORIG-GUID: ICi1I86IZV-wzoD597BbqpiIrBu7ey6r
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-28_17,2022-11-28_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_active_cloned_notspam policy=outbound_active_cloned score=0
 suspectscore=0 mlxlogscore=999 phishscore=0 spamscore=0 lowpriorityscore=0
 malwarescore=0 impostorscore=0 clxscore=1011 adultscore=0 bulkscore=0
 priorityscore=1501 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2210170000 definitions=main-2211280140
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGksDQoNCk9uIE1vbiwgTm92IDI4LCAyMDIyLCBTdmVuIFBldGVyIHdyb3RlOg0KPiBkd2MtPmRl
c2lyZWRfZHJfcm9sZSBpcyBjaGFuZ2VkIGJ5IGR3YzNfc2V0X21vZGUgaW5zaWRlIGEgc3Bpbmxv
Y2sgYnV0DQo+IHRoZW4gcmVhZCBieSBfX2R3YzNfc2V0X21vZGUgb3V0c2lkZSBvZiB0aGF0IGxv
Y2suIFRoaXMgY2FuIGxlYWQgdG8gYQ0KPiByYWNlIGNvbmRpdGlvbiB3aGVuIHZlcnkgcXVpY2sg
c3VjY2Vzc2l2ZSByb2xlIHN3aXRjaCBldmVudHMgaGFwcGVuOg0KPiANCj4gQ1BVIEENCj4gCWR3
YzNfc2V0X21vZGUoRFdDM19HQ1RMX1BSVENBUF9IT1NUKSAvLyBmaXJzdCByb2xlIHN3aXRjaCBl
dmVudA0KPiAJCXNwaW5fbG9ja19pcnFzYXZlKCZkd2MtPmxvY2ssIGZsYWdzKTsNCj4gCQlkd2Mt
PmRlc2lyZWRfZHJfcm9sZSA9IG1vZGU7IC8vIERXQzNfR0NUTF9QUlRDQVBfSE9TVA0KPiAJCXNw
aW5fdW5sb2NrX2lycXJlc3RvcmUoJmR3Yy0+bG9jaywgZmxhZ3MpOw0KPiAJCXF1ZXVlX3dvcmso
c3lzdGVtX2ZyZWV6YWJsZV93cSwgJmR3Yy0+ZHJkX3dvcmspOw0KPiANCj4gQ1BVIEINCj4gCV9f
ZHdjM19zZXRfbW9kZQ0KPiAJCS8vIC4uLi4NCj4gCQlzcGluX2xvY2tfaXJxc2F2ZSgmZHdjLT5s
b2NrLCBmbGFncyk7DQo+IAkJLy8gZGVzaXJlZF9kcl9yb2xlIGlzIERXQzNfR0NUTF9QUlRDQVBf
SE9TVA0KPiAJCWR3YzNfc2V0X3BydGNhcChkd2MsIGR3Yy0+ZGVzaXJlZF9kcl9yb2xlKTsNCj4g
CQlzcGluX3VubG9ja19pcnFyZXN0b3JlKCZkd2MtPmxvY2ssIGZsYWdzKTsNCj4gDQo+IENQVSBB
DQo+IAlkd2MzX3NldF9tb2RlKERXQzNfR0NUTF9QUlRDQVBfREVWSUNFKSAvLyBzZWNvbmQgZXZl
bnQNCj4gCQlzcGluX2xvY2tfaXJxc2F2ZSgmZHdjLT5sb2NrLCBmbGFncyk7DQo+IAkJZHdjLT5k
ZXNpcmVkX2RyX3JvbGUgPSBtb2RlOyAvLyBEV0MzX0dDVExfUFJUQ0FQX0RFVklDRQ0KPiAJCXNw
aW5fdW5sb2NrX2lycXJlc3RvcmUoJmR3Yy0+bG9jaywgZmxhZ3MpOw0KPiANCj4gQ1BVIEIgKGNv
bnRpbnVlcyBydW5uaW5nIF9fZHdjM19zZXRfbW9kZSkNCj4gCXN3aXRjaCAoZHdjLT5kZXNpcmVk
X2RyX3JvbGUpIHsgLy8gRFdDM19HQ1RMX1BSVENBUF9ERVZJQ0UNCj4gCS8vIC4uLi4NCj4gCWNh
c2UgRFdDM19HQ1RMX1BSVENBUF9ERVZJQ0U6DQo+IAkJLy8gLi4uLg0KPiAJCXJldCA9IGR3YzNf
Z2FkZ2V0X2luaXQoZHdjKTsNCj4gDQo+IFdlIHRoZW4gaGF2ZSBEV0MzX0dDVEwuRFdDM19HQ1RM
X1BSVENBUERJUiA9IERXQzNfR0NUTF9QUlRDQVBfSE9TVCBhbmQNCj4gZHdjLT5jdXJyZW50X2Ry
X3JvbGUgPSBEV0MzX0dDVExfUFJUQ0FQX0hPU1QgYnV0IGluaXRpYWxpemVkIHRoZQ0KPiBjb250
cm9sbGVyIGluIGRldmljZSBtb2RlLiBJdCdzIGFsc28gcG9zc2libGUgdG8gZ2V0IGludG8gYSBz
dGF0ZQ0KPiB3aGVyZSBib3RoIGhvc3QgYW5kIGRldmljZSBhcmUgaW50aWFsaXplZCBhdCB0aGUg
c2FtZSB0aW1lLg0KPiBGaXggdGhpcyByYWNlIGJ5IGNyZWF0aW5nIGEgbG9jYWwgY29weSBvZiBk
ZXNpcmVkX2RyX3JvbGUgaW5zaWRlDQo+IF9fZHdjM19zZXRfbW9kZSB3aGlsZSBob2xkaW5nIGR3
Yy0+bG9jay4NCj4gDQo+IEZpeGVzOiA0MWNlMTQ1NmUxZGIgKCJ1c2I6IGR3YzM6IGNvcmU6IG1h
a2UgZHdjM19zZXRfbW9kZSgpIHdvcmsgcHJvcGVybHkiKQ0KPiBTaWduZWQtb2ZmLWJ5OiBTdmVu
IFBldGVyIDxzdmVuQHN2ZW5wZXRlci5kZXY+DQo+IC0tLQ0KPiAgZHJpdmVycy91c2IvZHdjMy9j
b3JlLmMgfCAxNiArKysrKysrKysrLS0tLS0tDQo+ICAxIGZpbGUgY2hhbmdlZCwgMTAgaW5zZXJ0
aW9ucygrKSwgNiBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3VzYi9k
d2MzL2NvcmUuYyBiL2RyaXZlcnMvdXNiL2R3YzMvY29yZS5jDQo+IGluZGV4IDFmMzQ4YmM4Njdj
Mi4uZmMzOGE4YjEzZWZhIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL3VzYi9kd2MzL2NvcmUuYw0K
PiArKysgYi9kcml2ZXJzL3VzYi9kd2MzL2NvcmUuYw0KPiBAQCAtMTIyLDIxICsxMjIsMjUgQEAg
c3RhdGljIHZvaWQgX19kd2MzX3NldF9tb2RlKHN0cnVjdCB3b3JrX3N0cnVjdCAqd29yaykNCj4g
IAl1bnNpZ25lZCBsb25nIGZsYWdzOw0KPiAgCWludCByZXQ7DQo+ICAJdTMyIHJlZzsNCj4gKwl1
MzIgZGVzaXJlZF9kcl9yb2xlOw0KPiAgDQo+ICAJbXV0ZXhfbG9jaygmZHdjLT5tdXRleCk7DQo+
ICsJc3Bpbl9sb2NrX2lycXNhdmUoJmR3Yy0+bG9jaywgZmxhZ3MpOw0KPiArCWRlc2lyZWRfZHJf
cm9sZSA9IGR3Yy0+ZGVzaXJlZF9kcl9yb2xlOw0KPiArCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUo
JmR3Yy0+bG9jaywgZmxhZ3MpOw0KPiAgDQo+ICAJcG1fcnVudGltZV9nZXRfc3luYyhkd2MtPmRl
dik7DQo+ICANCj4gIAlpZiAoZHdjLT5jdXJyZW50X2RyX3JvbGUgPT0gRFdDM19HQ1RMX1BSVENB
UF9PVEcpDQo+ICAJCWR3YzNfb3RnX3VwZGF0ZShkd2MsIDApOw0KPiAgDQo+IC0JaWYgKCFkd2Mt
PmRlc2lyZWRfZHJfcm9sZSkNCj4gKwlpZiAoIWRlc2lyZWRfZHJfcm9sZSkNCj4gIAkJZ290byBv
dXQ7DQo+ICANCj4gLQlpZiAoZHdjLT5kZXNpcmVkX2RyX3JvbGUgPT0gZHdjLT5jdXJyZW50X2Ry
X3JvbGUpDQo+ICsJaWYgKGRlc2lyZWRfZHJfcm9sZSA9PSBkd2MtPmN1cnJlbnRfZHJfcm9sZSkN
Cj4gIAkJZ290byBvdXQ7DQo+ICANCj4gLQlpZiAoZHdjLT5kZXNpcmVkX2RyX3JvbGUgPT0gRFdD
M19HQ1RMX1BSVENBUF9PVEcgJiYgZHdjLT5lZGV2KQ0KPiArCWlmIChkZXNpcmVkX2RyX3JvbGUg
PT0gRFdDM19HQ1RMX1BSVENBUF9PVEcgJiYgZHdjLT5lZGV2KQ0KPiAgCQlnb3RvIG91dDsNCj4g
IA0KPiAgCXN3aXRjaCAoZHdjLT5jdXJyZW50X2RyX3JvbGUpIHsNCj4gQEAgLTE2NCw3ICsxNjgs
NyBAQCBzdGF0aWMgdm9pZCBfX2R3YzNfc2V0X21vZGUoc3RydWN0IHdvcmtfc3RydWN0ICp3b3Jr
KQ0KPiAgCSAqLw0KPiAgCWlmIChkd2MtPmN1cnJlbnRfZHJfcm9sZSAmJiAoKERXQzNfSVBfSVMo
RFdDMykgfHwNCj4gIAkJCURXQzNfVkVSX0lTX1BSSU9SKERXQzMxLCAxOTBBKSkgJiYNCj4gLQkJ
CWR3Yy0+ZGVzaXJlZF9kcl9yb2xlICE9IERXQzNfR0NUTF9QUlRDQVBfT1RHKSkgew0KPiArCQkJ
ZGVzaXJlZF9kcl9yb2xlICE9IERXQzNfR0NUTF9QUlRDQVBfT1RHKSkgew0KPiAgCQlyZWcgPSBk
d2MzX3JlYWRsKGR3Yy0+cmVncywgRFdDM19HQ1RMKTsNCj4gIAkJcmVnIHw9IERXQzNfR0NUTF9D
T1JFU09GVFJFU0VUOw0KPiAgCQlkd2MzX3dyaXRlbChkd2MtPnJlZ3MsIERXQzNfR0NUTCwgcmVn
KTsNCj4gQEAgLTE4NCwxMSArMTg4LDExIEBAIHN0YXRpYyB2b2lkIF9fZHdjM19zZXRfbW9kZShz
dHJ1Y3Qgd29ya19zdHJ1Y3QgKndvcmspDQo+ICANCj4gIAlzcGluX2xvY2tfaXJxc2F2ZSgmZHdj
LT5sb2NrLCBmbGFncyk7DQo+ICANCj4gLQlkd2MzX3NldF9wcnRjYXAoZHdjLCBkd2MtPmRlc2ly
ZWRfZHJfcm9sZSk7DQo+ICsJZHdjM19zZXRfcHJ0Y2FwKGR3YywgZGVzaXJlZF9kcl9yb2xlKTsN
Cj4gIA0KPiAgCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJmR3Yy0+bG9jaywgZmxhZ3MpOw0KPiAg
DQo+IC0Jc3dpdGNoIChkd2MtPmRlc2lyZWRfZHJfcm9sZSkgew0KPiArCXN3aXRjaCAoZGVzaXJl
ZF9kcl9yb2xlKSB7DQo+ICAJY2FzZSBEV0MzX0dDVExfUFJUQ0FQX0hPU1Q6DQo+ICAJCXJldCA9
IGR3YzNfaG9zdF9pbml0KGR3Yyk7DQo+ICAJCWlmIChyZXQpIHsNCj4gLS0gDQo+IDIuMjUuMQ0K
PiANCg0KVGhpcyBsb29rcyBnb29kIHRvIG1lLiBUaGlzIHNob3VsZCBhbHNvIGdvIG9uIHN0YWJs
ZS4NCg0KQWNrZWQtYnk6IFRoaW5oIE5ndXllbiA8VGhpbmguTmd1eWVuQHN5bm9wc3lzLmNvbT4N
Cg0KVGhhbmtzIQ0KVGhpbmg=
