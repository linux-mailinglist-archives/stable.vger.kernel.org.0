Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B5BD6DCF2D
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 03:22:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbjDKBWY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Apr 2023 21:22:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbjDKBWX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Apr 2023 21:22:23 -0400
Received: from mx0a-00230701.pphosted.com (mx0a-00230701.pphosted.com [148.163.156.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE02B97;
        Mon, 10 Apr 2023 18:22:21 -0700 (PDT)
Received: from pps.filterd (m0098571.ppops.net [127.0.0.1])
        by mx0a-00230701.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33AJ5oth014444;
        Mon, 10 Apr 2023 18:22:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfptdkimsnps;
 bh=jwneA/Bj+w8724ZjCpxfSPqpZlz8R0i5Ck0eYPDSL8U=;
 b=ZsTG5LiVLn2MVzzNc0JIHn47oS/N6w0/HMsT8qHXP9BV+lzRFbugSowuSGfW4lQYRxrx
 j8lh5y9e+y7dzJhWs2UAgv6l2bL8KaLsFjrCgtUap8CPIDDEbFjU9xU2/phf07RLhwTJ
 UNgESokfAPg7yhz/99KXO3sRX6TVS+JwoIYpgTltFTQ7eb2kxFGb4P0HkzUtsehwOpPy
 6zWtiZjD6C5z2D5KzciGpzxrkWUj8RXoLhkUpsc4o5SXu6XCuw+fvpEG298mudxUw/kV
 tx6UkBS9/E15D2xgK6TFfER8W2sqc0BEIkh8Hf6F/HArBdmAGXujXNG89bhlgFeLg0/m Bw== 
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.73.133])
        by mx0a-00230701.pphosted.com (PPS) with ESMTPS id 3pu79qjhw4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 Apr 2023 18:22:15 -0700
Received: from mailhost.synopsys.com (sv1-mailhost2.synopsys.com [10.205.2.132])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id D12E3400D9;
        Tue, 11 Apr 2023 01:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1681176134; bh=jwneA/Bj+w8724ZjCpxfSPqpZlz8R0i5Ck0eYPDSL8U=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=jcOvApH2DTxbY8Auwzoq+YJLDb0EauBi5od8eJA1XTu0LaRx8VTLq3rMdbZ9Fm7AS
         59rESjp69jC34YEKEo9VXNqpnxurknMWUspN/tPQ5Ej88LKhDsHgeb/iszKe+A4Lf2
         2a+E7qOnqoUKiONEQzDEzQx95f1HfdYiQeWo6La6sw0890m+8xEqXlgzdSUU1iZZJB
         OHV2L8bmTawS0Lut/CMi6Xh91ntzhSMDyhcakbnlBdHFa6YDMFOUQ3ok6Y75R2N6C6
         kVF+ZXSvWAPkAGH4C+qhWSFliKXknfE78aLKISG0rmQx/6ZPaDF19to3u9eppBjf0s
         1io2UnZ/YvOQQ==
Received: from o365relay-in.synopsys.com (sv2-o365relay3.synopsys.com [10.202.1.139])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "o365relay-in.synopsys.com", Issuer "Entrust Certification Authority - L1K" (verified OK))
        by mailhost.synopsys.com (Postfix) with ESMTPS id A8DEAA006F;
        Tue, 11 Apr 2023 01:22:14 +0000 (UTC)
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2176.outbound.protection.outlook.com [104.47.73.176])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.protection.outlook.com", Issuer "DigiCert Cloud Services CA-1" (verified OK))
        by o365relay-in.synopsys.com (Postfix) with ESMTPS id 5C01340084;
        Tue, 11 Apr 2023 01:22:14 +0000 (UTC)
Authentication-Results: o365relay-in.synopsys.com; dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relay-in.synopsys.com; spf=pass smtp.mailfrom=thinhn@synopsys.com
Authentication-Results: o365relay-in.synopsys.com;
        dkim=pass (1024-bit key; unprotected) header.d=synopsys.com header.i=@synopsys.com header.b="WzD2hXdy";
        dkim-atps=neutral
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IRWjQ/FP00MzBtClyNALonWmH0ibV2v4rgG6s217Xsxse/AcZg0sr6I1xO49ZvHfH3lPAbRHQeAPGAlaQDk7dIODAqv52DY7B8WC6ofqxehnXdebt41CYu8xgMwB7MuYVoQ+HjghS10yx7wQ/iASuw6IQlgwTbKNhr3y5o8u0ryGyshY1TtGL+Pysk/RRFGtC85+Njn1dJf360xXMKI1gJGukOEELmBeF+rS6z0Q1RM1BDTjAGLW+0GRcw4al6UKlyhe3uFyP6+r7h6MHqtXNNNFbzASKHRf88KHLlHVGbf/kqkZPl0hE58qFCeTPPWjSY92bSEtkUA9pg5pCXWlJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jwneA/Bj+w8724ZjCpxfSPqpZlz8R0i5Ck0eYPDSL8U=;
 b=mjPm8wyEe/AK1mrJejADLUjZUgsfJMx6YNYxppKyJMAZFYJZ23YCk3kcmGKPA8xOjuHCDz7542DWz03ngFEKFfNi3PmRV/M+ltqv66tpx6R/RNSSP3cOKI+45bk/HM87JsL9fNt8U+WLkL6/fc+Xud83kVwzoyCHQPTNNG0JDbuuP+JBjH1HuG82HQDyat0SgGXraGSpAb5lSSx/w+BJrxusY0zGXqwa/ucgzrmmuhpiaa3NsLzIhljgSvPq5gO8nj1Gaq2mypHo8Rv/UCC6qY3+l/p6P5wPETxYbV/6WlC3B7SR4V/88NPnfKvaPo6Lfw3NsOu+/WHw1WrCi1eKKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jwneA/Bj+w8724ZjCpxfSPqpZlz8R0i5Ck0eYPDSL8U=;
 b=WzD2hXdy0kr0POvc3+qMRJWZc6myVDTszU4MPZbO0lwOJz+WIL0+MALY0mPBfgedEYHzLPNUsjogCvrCAUeIZri548qO5mxPLb7mBllEawlONaMmfU6Av17nZKnF4OphaBqSvmMOv1whJu7C7IVaG/eIQJaPyQRG7/tcXXIAszg=
Received: from BN8PR12MB4787.namprd12.prod.outlook.com (2603:10b6:408:a1::11)
 by SA0PR12MB7002.namprd12.prod.outlook.com (2603:10b6:806:2c0::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Tue, 11 Apr
 2023 01:22:11 +0000
Received: from BN8PR12MB4787.namprd12.prod.outlook.com
 ([fe80::a6ef:a9e2:ad28:f5cf]) by BN8PR12MB4787.namprd12.prod.outlook.com
 ([fe80::a6ef:a9e2:ad28:f5cf%6]) with mapi id 15.20.6277.034; Tue, 11 Apr 2023
 01:22:11 +0000
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
To:     Johan Hovold <johan+linaro@kernel.org>
CC:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Roger Quadros <rogerq@ti.com>
Subject: Re: [PATCH 01/11] USB: dwc3: fix runtime pm imbalance on probe errors
Thread-Topic: [PATCH 01/11] USB: dwc3: fix runtime pm imbalance on probe
 errors
Thread-Index: AQHZZsazfuScof2dEkmZxUv2dWcrP68lWoKA
Date:   Tue, 11 Apr 2023 01:22:11 +0000
Message-ID: <20230411012207.mn4cpxbo5lq73r4n@synopsys.com>
References: <20230404072524.19014-1-johan+linaro@kernel.org>
 <20230404072524.19014-2-johan+linaro@kernel.org>
In-Reply-To: <20230404072524.19014-2-johan+linaro@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN8PR12MB4787:EE_|SA0PR12MB7002:EE_
x-ms-office365-filtering-correlation-id: 0826e3bf-cb19-42dc-fdf0-08db3a2b2cdf
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: W+ZbVJdEGtV+SCboFBVYZWKHb9pCYxcR38M6r+EoSVJiHuufRSbL3d/TIEFc0V72oNK0sEcw9yOXiYoSa+FZfaA7844NkqZv5d/pvgrQ0lRIhKHLSrHzTJC2NJ7+P4m8NHi8dCJ4vm1Tqdmb6LZyZsHYkeVvULdvZlfAez3BKaXYTKmQ1TwAv4tGr6iXm//WYrjgwpUxmVcxKY83bi3/s9l/M56nftN2Ne9pzL7QVAx+YCn8Y89Ny1ll5jsie+ZmASaC9o99Uc9WFEP+ntgAGo26cAgEInIeBAAPCAfsE34TgiEer0yhyAT5l9tS0VIQfsB/9Mo06aZv2rjxnKHv887IWqd6/Z5vVYf632aPU+Z+VVnUw4ADpTw5GDJVSjl5XwEj6Ky3ACHbngNembvHG0Q6rGtiA4bjG42JA3miAYqiZC/41cN+7z7WqH1R5VOvo/OQgepFBjRN41uBE4fbEVdewegzLTdvvo3jemqqb7u43XTMHZyPIwv8aocwnct35pzRxFRepqE0x7FUcxw9NgVZY51oyJlQzXhJQH6JUh0dgqGtG6QsSjw1ilg0OZZR1E3Mt7EDk1+4RELgBS9ZM8OgyzSuIbpnTPSKLa1TxJJXdVg0qaL21Vlcdgr3r+Z2
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR12MB4787.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(136003)(376002)(346002)(366004)(39860400002)(451199021)(38070700005)(2906002)(36756003)(8676002)(8936002)(38100700002)(122000001)(5660300002)(86362001)(478600001)(71200400001)(2616005)(6486002)(186003)(54906003)(316002)(26005)(1076003)(6512007)(6506007)(4326008)(66476007)(66446008)(64756008)(66556008)(76116006)(66946007)(91956017)(83380400001)(41300700001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VjU3TVZWK0NFaXYyZ2lab1p2aWxLRDZXZmU4TldVRDhGTUN3eVNOYU5oVHZl?=
 =?utf-8?B?dmZMQ25JbzBKNnZ4aFdoVDRPNnB5VVVmd1RPcWFRT0xwMUlXTmhaazVhbWVF?=
 =?utf-8?B?R1BZWld0YVp0N2JjcXFwYzFleEpSM1BEQ1pFOWhEUys4Qlkwcmg1WVNWV1Fr?=
 =?utf-8?B?MUozd2VMZGU0NndWWGlidXZvUFp5N0VLRDc2Y0VQUEVDdHVQSjk5SzY1dTFm?=
 =?utf-8?B?OEN5MC9ZbFR5cE1CMzR4Uk1hTDdJbU16dTRJK2RKRHVhcGJGVVFla0xpaTkr?=
 =?utf-8?B?V0w5QW5hMWVjSElKUlFZTE5pWmErUEttUTc5eXl6UEEyakJtbUR5YWx6ZVNF?=
 =?utf-8?B?aklDMVRjZVZWLzVoamtod1BzTzN6RXVHNGtlb3JyWjRDNnp0Q2tidUFFemhP?=
 =?utf-8?B?NHlSeG52eXZnRWNwQ2tNOGgrZHVndTFNVEpUVyt5QTQwUjVFeEFjTncwUEZM?=
 =?utf-8?B?N0ZBSVZGb01FQzFxdkxtbWVsWWpSU1NiMUFzWHlUdGlXbTJuN09QWllTK1B2?=
 =?utf-8?B?K1RnaFVLQmlYcWwzK1dJZVFMNnRjSWhseE8wTkJhYTl5ckp6S1o5aGpmZCt4?=
 =?utf-8?B?QXdpQTdUL3NmQWtsaFF4cEdrcyswNUFkQUprbEVrbEVDbG9leFBXQnhsWUx3?=
 =?utf-8?B?REFtNUhyV08zcUxiMVQwYmg3V3FvK29tN0ZpNkUzekEvTzdDV3RzeGpBVVpS?=
 =?utf-8?B?WmtDNjVxM255RzluREg5L3dyYThIaEs2RGxTZmttM3JkZzZPKzZqRTA2ZW1W?=
 =?utf-8?B?RE9DbnlYbzltbGhhM0dhZXU2dm8rZTkzaTh1d2dMeGtmcVRUaHpvVzdnUytx?=
 =?utf-8?B?NjJGaUZKdk1LZ294cGE1TCt3eDZkQWEwOUI0N2dydXlpVDh5ZkVHMVlqekFv?=
 =?utf-8?B?VmdsaUhBMkMyS3lqK0djbUQ0YUt1UmIweFNpQk1rcEZ0cHhSMmlHVGJDSTl2?=
 =?utf-8?B?MlQ2aTdubmFpS1NVVVQydWtJdlpSWkVnZi9vOVFNeVZ2Mm5HME1OeXdHUnFR?=
 =?utf-8?B?NTJPcUVZNWYyRkNzL2FweWNhaGczWGFzVERBNnNCbFE1YjJ4Yis1cmtuNHE2?=
 =?utf-8?B?Qkh4MExPdlVZY2Q1c1FiT3N6MEZiang3Um9Sc01XeGEyUWcvZW16VFg3RmI1?=
 =?utf-8?B?aUF5alZBcGtoNlZyVUU0d0ZpVURwYlFYWktFM2Y5Z0UrTDg0V0hWY1ZiYStz?=
 =?utf-8?B?VjA1TDN2ZzJoN1JmTkpmRmpTK0RwTUJGOFJlQTdOWk5kZDVUbWsyZGYrK0pn?=
 =?utf-8?B?OTRkU3VKWk5QRFZXeWRWZlRhNUJseDRtaHpPb085SXdNZEJRWE5OeTlKSWF6?=
 =?utf-8?B?bFFvQWpVWlFhakVDY2NzTkY4R2FPNE1sWkIxL0FNTjR5SlR2bVVNU3hMaHEz?=
 =?utf-8?B?KzR3T0llQVFKYUF6b0dsdVFrSmxxdkhUTW9ldFRXR3BHUFhFNitTWnBLM0h1?=
 =?utf-8?B?aXgyU0NDd0VVdEdvbEF0b2V6SVVtVUN3NXl0M1dlVE1SenRWaXNjTTI2Znk2?=
 =?utf-8?B?VGJqekdkNXJvVi9mUHNra1hnUnBWN0dvODRldnlHRXhmMTdic3JqV0NsK3BZ?=
 =?utf-8?B?Nk9wSUpoNEJIY3FMVGtBS1JCd3VxZExUdmJ6enRlYkdTMnZjTHFkZmJjaTVm?=
 =?utf-8?B?UituQXdHSGhBZ3Q2TmRRc0VtODRCYjlXbHBGVkp2ZTQzbHBKQW9nNjZRbmE1?=
 =?utf-8?B?RGFMT1dQdms5ZUIzUDlKQmZCK0M0WE1SMkFvbVBkeEYrZjZjM1h4ZnZRbUVk?=
 =?utf-8?B?SWJkOGFnN1BvZUVjb2V1V2dnN1lCUzNNSE5qZ0xrVkFDVVhVOXhObnRLUWtT?=
 =?utf-8?B?UEJWZ1h0aGZhc21qeEpkZkJkN0hiNmM2OXU0MEI2RFNFVmFFVGRGMDVHdTV6?=
 =?utf-8?B?T3g2bVNNNUwrVkFjZVJNR1AwVUd2OVdXTndSSFZJWkpqODY2djVJZ2JidGNG?=
 =?utf-8?B?UytSQ1NwUThIbW9zdzJ3dmxyNGQrdVcrSGJUSDJKcGNyV21BTGwrRW5hLzJX?=
 =?utf-8?B?TnZHSTFRb3VvVU1RbkhhS1VLNzVCYVZ6cjQxb2QzbUlGQW1HNHhBRUVXMDh1?=
 =?utf-8?B?bHd0dVFRWnRSRkxXMnlQM2ZhQXA2bGNzbjlSbEs0cXVLY2cwL0luNGl4dFFx?=
 =?utf-8?Q?LnsmF8vX2+ebGVkmKym7kJ3PJ?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D101B63AAE32A54782553626B687A7D2@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: U6onC8tczUasOXNN0kQJ9nQ6EbVVOrQ/wRd9r6xyvYcArn0A0XskQ7TMzQJHIV8GOlk9vuo/fSSQY9+RCPbmNHtof+RumxiXrTOwfK3tfgohi/smRbzqKmaeDdGDJ1DhrNCA16zg/PSyXafEiwvoB74lzckLjLvDVKGJwvQsWRn6EwOjXODEYVGB6q8Juaw/5+FSW169d002UrzCrgFihIfCRs+HDse9UJ0QMors1nhyw0DbR2ptDuzJUC+fFQPSLRV0+z19STk2r+vL6zD2415WAHNVBvdokhz6M/wRWfyhTM0C2h6T61cKPnpuJKb0R1HkXBWLZ8XhZL3x/NkLZqpd+ipDV1KQEnRcPRxOSO/2V4KqhH8Oj2+7bZj3hLrNGflZHVNrCbgfTwisHz102llQogASG8FRkRnRvkWfrP20IrDEgwcKupnv5v0Gb02Y6pM8IHvLz+0gYtVrMoQwKRDT61lQmaQHTHhefQ0uca+45Tv8bXPfs8rqiiIgOe0BZjSqOQypCBow1p9k4r5GzvdojOtXwfMdwLaYlE8HUW49sLJ3oCs5HjsC3Fksa09Hfpr98bSXroj7CW8z9QQ26D3xdybgtwfCUxRIACnOnlfFMrz0Dmuqc7a7CPdPK7yO5gqBax3r1sxUss4o5YWEPH/UMxTy10+9XkGFuD09rfz3+OyQj7Xvou2QTwwuiTcfUMdtWfVZkzM4ORC/w5fqKz6VWMaairOH/cUMfxhOREoyWNnRaurJmrFB2sukMlpchqxm91bqvEcUWGJu4Z1x2QjhYwv6fprkCeo0ZlxSgpfezUNuvEldRp7GwS4E3HwPc1rrnYi3vN86GyIQovZVJdffpkEihHy7q3QVryFHO/isNfGjRdnFufBsw7nkowyenbdH/oQER6q8z57PzBZTgw==
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN8PR12MB4787.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0826e3bf-cb19-42dc-fdf0-08db3a2b2cdf
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Apr 2023 01:22:11.3355
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: h5So557zlu3i1FAFSI4vdxxvNoiBzqXM30fpwFAQ8ZCpu5ZDGvXcfIq2/meAXoVSvSFc+1FFvgis4KzPfX+tlg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB7002
X-Proofpoint-ORIG-GUID: 7UFYRaX-NrqD-agjwd5Agi5aJtlFbs2d
X-Proofpoint-GUID: 7UFYRaX-NrqD-agjwd5Agi5aJtlFbs2d
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-10_18,2023-04-06_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_active_cloned_notspam policy=outbound_active_cloned score=0
 bulkscore=0 mlxlogscore=999 impostorscore=0 suspectscore=0 spamscore=0
 priorityscore=1501 mlxscore=0 adultscore=0 clxscore=1011 malwarescore=0
 phishscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2303200000 definitions=main-2304110010
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

T24gVHVlLCBBcHIgMDQsIDIwMjMsIEpvaGFuIEhvdm9sZCB3cm90ZToNCj4gTWFrZSBzdXJlIG5v
dCB0byBzdXNwZW5kIHRoZSBkZXZpY2Ugd2hlbiBwcm9iZSBmYWlscyB0byBhdm9pZCBkaXNhYmxp
bmcNCj4gY2xvY2tzIGFuZCBwaHlzIG11bHRpcGxlIHRpbWVzLg0KPiANCj4gRml4ZXM6IDMyODA4
MjM3NmFlYSAoInVzYjogZHdjMzogZml4IHJ1bnRpbWUgUE0gaW4gZXJyb3IgcGF0aCIpDQo+IENj
OiBzdGFibGVAdmdlci5rZXJuZWwub3JnICAgICAgIyA0LjgNCj4gQ2M6IFJvZ2VyIFF1YWRyb3Mg
PHJvZ2VycUB0aS5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IEpvaGFuIEhvdm9sZCA8am9oYW4rbGlu
YXJvQGtlcm5lbC5vcmc+DQo+IC0tLQ0KPiAgZHJpdmVycy91c2IvZHdjMy9jb3JlLmMgfCAxNCAr
KysrKy0tLS0tLS0tLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDUgaW5zZXJ0aW9ucygrKSwgOSBkZWxl
dGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3VzYi9kd2MzL2NvcmUuYyBiL2Ry
aXZlcnMvdXNiL2R3YzMvY29yZS5jDQo+IGluZGV4IDQ3NmI2MzYxODUxMS4uNTA1OGJkOGQ1NmNh
IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL3VzYi9kd2MzL2NvcmUuYw0KPiArKysgYi9kcml2ZXJz
L3VzYi9kd2MzL2NvcmUuYw0KPiBAQCAtMTg4MywxMyArMTg4MywxMSBAQCBzdGF0aWMgaW50IGR3
YzNfcHJvYmUoc3RydWN0IHBsYXRmb3JtX2RldmljZSAqcGRldikNCj4gIAlzcGluX2xvY2tfaW5p
dCgmZHdjLT5sb2NrKTsNCj4gIAltdXRleF9pbml0KCZkd2MtPm11dGV4KTsNCj4gIA0KPiArCXBt
X3J1bnRpbWVfZ2V0X25vcmVzdW1lKGRldik7DQo+ICAJcG1fcnVudGltZV9zZXRfYWN0aXZlKGRl
dik7DQo+ICAJcG1fcnVudGltZV91c2VfYXV0b3N1c3BlbmQoZGV2KTsNCj4gIAlwbV9ydW50aW1l
X3NldF9hdXRvc3VzcGVuZF9kZWxheShkZXYsIERXQzNfREVGQVVMVF9BVVRPU1VTUEVORF9ERUxB
WSk7DQo+ICAJcG1fcnVudGltZV9lbmFibGUoZGV2KTsNCj4gLQlyZXQgPSBwbV9ydW50aW1lX2dl
dF9zeW5jKGRldik7DQo+IC0JaWYgKHJldCA8IDApDQo+IC0JCWdvdG8gZXJyMTsNCj4gIA0KPiAg
CXBtX3J1bnRpbWVfZm9yYmlkKGRldik7DQo+ICANCj4gQEAgLTE5NTQsMTIgKzE5NTIsMTAgQEAg
c3RhdGljIGludCBkd2MzX3Byb2JlKHN0cnVjdCBwbGF0Zm9ybV9kZXZpY2UgKnBkZXYpDQo+ICAJ
ZHdjM19mcmVlX2V2ZW50X2J1ZmZlcnMoZHdjKTsNCj4gIA0KPiAgZXJyMjoNCj4gLQlwbV9ydW50
aW1lX2FsbG93KCZwZGV2LT5kZXYpOw0KPiAtDQo+IC1lcnIxOg0KPiAtCXBtX3J1bnRpbWVfcHV0
X3N5bmMoJnBkZXYtPmRldik7DQo+IC0JcG1fcnVudGltZV9kaXNhYmxlKCZwZGV2LT5kZXYpOw0K
PiAtDQo+ICsJcG1fcnVudGltZV9hbGxvdyhkZXYpOw0KPiArCXBtX3J1bnRpbWVfZGlzYWJsZShk
ZXYpOw0KPiArCXBtX3J1bnRpbWVfc2V0X3N1c3BlbmRlZChkZXYpOw0KPiArCXBtX3J1bnRpbWVf
cHV0X25vaWRsZShkZXYpOw0KPiAgZGlzYWJsZV9jbGtzOg0KPiAgCWR3YzNfY2xrX2Rpc2FibGUo
ZHdjKTsNCj4gIGFzc2VydF9yZXNldDoNCj4gLS0gDQo+IDIuMzkuMg0KPiANCg0KQWNrZWQtYnk6
IFRoaW5oIE5ndXllbiA8VGhpbmguTmd1eWVuQHN5bm9wc3lzLmNvbT4NCg0KVGhhbmtzLA0KVGhp
bmg=
