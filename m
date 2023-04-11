Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B26B6DCF30
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 03:22:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229703AbjDKBWu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Apr 2023 21:22:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229780AbjDKBWt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Apr 2023 21:22:49 -0400
Received: from mx0a-00230701.pphosted.com (mx0a-00230701.pphosted.com [148.163.156.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E9311A8;
        Mon, 10 Apr 2023 18:22:42 -0700 (PDT)
Received: from pps.filterd (m0098571.ppops.net [127.0.0.1])
        by mx0a-00230701.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33AJ5sLZ014489;
        Mon, 10 Apr 2023 18:22:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=pfptdkimsnps;
 bh=KT3YPm2Lqn+3wua4ip7BzoFRidm/mncj9aI1GLr2EoU=;
 b=SD4yT4oY0I+03dQFn6QZqMMdc5nwDBSBb6LXRgzzOh+8F2FHqLl5U6WOofv8Oio423lT
 44SIOerBDPaF1Kqp3ffROqLrfeor0Wkd1IEDChuKwVuDBZvoi9vRJxtKUxh9qtnpefbt
 OZi6X0FrGa+0Cwg/jGK3T2T9Cit00ijQbiss7P9CUtglhH/zCZm4w1uSYNurLGzewnYQ
 s8qoIsu1IATluenQEbl9PfeBVPgAIyZ88ZMf2bzBfscLzFbHj6denNC18ZnUJBFZZPyo
 R5jP1+6wRpICeh9TbGj1IZt4Hs+IOvgctSkrqGFKq1FH4fkfQUq/lejlthCbuQ6Hq/Vv JA== 
Received: from smtprelay-out1.synopsys.com (smtprelay-out1.synopsys.com [149.117.87.133])
        by mx0a-00230701.pphosted.com (PPS) with ESMTPS id 3pu79qjhxe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 Apr 2023 18:22:34 -0700
Received: from mailhost.synopsys.com (sv2-mailhost2.synopsys.com [10.205.2.134])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "mailhost.synopsys.com", Issuer "SNPSica2" (verified OK))
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id E4227C00F7;
        Tue, 11 Apr 2023 01:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1681176154; bh=KT3YPm2Lqn+3wua4ip7BzoFRidm/mncj9aI1GLr2EoU=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=Y9zTyHop1g66nCaycQC5yIyrCb7Gfymb5gRtAt+HG7ZvpCgsjOlT+npzKiTWQp0Xg
         NW6oGvlRBSdej+saq0DPFJ6NppXCH5o0QzwW5pAY4cEW2vYfDh3A5NijpINqlMaJV1
         o1inODAJxIyBrz7gjFt2+C3uBtdNZkIZI17rRmHVgov6ITYwv52ct21e7+Qv2M60mS
         w5918HdJ2VmTqgpd/eMsdpeagwoNBDZ1D3XV5fpKyDYo5oqnPS7vHWd23diUw219AB
         3L5kIqJAMy1JcHoFOTECWbfb9TgTeyQMYqwAEPsKuYHrocAqCY+xYQP6K64KpFNJbp
         FmesWB0arLAzA==
Received: from o365relay-in.synopsys.com (us03-o365relay3.synopsys.com [10.4.161.139])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client CN "o365relay-in.synopsys.com", Issuer "Entrust Certification Authority - L1K" (verified OK))
        by mailhost.synopsys.com (Postfix) with ESMTPS id AB72DA00C3;
        Tue, 11 Apr 2023 01:22:33 +0000 (UTC)
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2170.outbound.protection.outlook.com [104.47.73.170])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail.protection.outlook.com", Issuer "DigiCert Cloud Services CA-1" (verified OK))
        by o365relay-in.synopsys.com (Postfix) with ESMTPS id 41F75801AD;
        Tue, 11 Apr 2023 01:22:33 +0000 (UTC)
Authentication-Results: o365relay-in.synopsys.com; dmarc=pass (p=reject dis=none) header.from=synopsys.com
Authentication-Results: o365relay-in.synopsys.com; spf=pass smtp.mailfrom=thinhn@synopsys.com
Authentication-Results: o365relay-in.synopsys.com;
        dkim=pass (1024-bit key; unprotected) header.d=synopsys.com header.i=@synopsys.com header.b="kqAc8lhp";
        dkim-atps=neutral
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AEc3kAjrYkvHOpeqroWIMj5/I22kWN9zvo/2Y0Eq4uUxQwYlMWS3+o+OTtzatSo0cdhr4e2j2fU3Mp0Y7XTxJgUnTekFvb/X9iJN7xOQzH0O6zk9s+yZOKqVgK2yVjwzUSGzfbjHvq8/vII2wwS5pUgvpZsBc6m2sCOWGY+NotlMISF2zuhyuTlMXb7QF6cnNpHemSVAojwb0VqXLX6gzXNaonXeTQoXc4abDp7cwLaDOSM4/and50AKlJEYtCgirXOVMW2yLICLIgT6fQbWGEPE8f+W5N/aHbxQGzo+M4rsMFmZwzOS47pg7wcK4stwtseABPptnTQ1uZA/ZR04pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KT3YPm2Lqn+3wua4ip7BzoFRidm/mncj9aI1GLr2EoU=;
 b=Yut46em/GHjc6fHKE8ZVhtfZQdLW9c+sfK8TPasPCbMTDH/XDMFDITFzb5HXMC24ohHLfbAJx0XiXgQb+MqFTeyYj6heRSg6p5DIyh7SkuFSKcs81PCJUiV0pMfCpiQgLdoRPtZiaba3t8wN1YIxOGPAxIf+IkG6Qd5MXpytIjeOn7Wg5a/HEhhRxBhu3yqC6jKHgoubh++qwBkDJP55U86cDptiWx7BMe0t74qyqXRLLpZ/JTCQmmH2DF75f+jPjHZfGBYQ84Dlyx2QzkP4DVwhg55yYAF5m3v21SDE8Ag5UUE0cuoOPyGghWn1xMF6zD57h7/aLsEG+8DYkEcOkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synopsys.com; dmarc=pass action=none header.from=synopsys.com;
 dkim=pass header.d=synopsys.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=synopsys.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KT3YPm2Lqn+3wua4ip7BzoFRidm/mncj9aI1GLr2EoU=;
 b=kqAc8lhprIojhV/b7gx+5MmnrKrOuAWw+1es/Sy5YztzVpwnMQZCT9HOZIEtThLYoOaIfUvMFyBb0encgIMTFzC+pr+4WOitx0/4TjkrrO/+e47XoGmyMhktLWqnzZPr+2DSJ2k13dfYJ06q/chwh2OIegpMjxbNndHadZb2AzA=
Received: from BN8PR12MB4787.namprd12.prod.outlook.com (2603:10b6:408:a1::11)
 by SA0PR12MB7002.namprd12.prod.outlook.com (2603:10b6:806:2c0::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Tue, 11 Apr
 2023 01:22:30 +0000
Received: from BN8PR12MB4787.namprd12.prod.outlook.com
 ([fe80::a6ef:a9e2:ad28:f5cf]) by BN8PR12MB4787.namprd12.prod.outlook.com
 ([fe80::a6ef:a9e2:ad28:f5cf%6]) with mapi id 15.20.6277.034; Tue, 11 Apr 2023
 01:22:30 +0000
X-SNPS-Relay: synopsys.com
From:   Thinh Nguyen <Thinh.Nguyen@synopsys.com>
To:     Johan Hovold <johan+linaro@kernel.org>
CC:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Li Jun <jun.li@nxp.com>
Subject: Re: [PATCH 02/11] USB: dwc3: fix runtime pm imbalance on unbind
Thread-Topic: [PATCH 02/11] USB: dwc3: fix runtime pm imbalance on unbind
Thread-Index: AQHZZsaxBsNqPdFGwEGiJgVCcDEnN68lWpqA
Date:   Tue, 11 Apr 2023 01:22:30 +0000
Message-ID: <20230411012227.agedhuvuhyqjrgyb@synopsys.com>
References: <20230404072524.19014-1-johan+linaro@kernel.org>
 <20230404072524.19014-3-johan+linaro@kernel.org>
In-Reply-To: <20230404072524.19014-3-johan+linaro@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN8PR12MB4787:EE_|SA0PR12MB7002:EE_
x-ms-office365-filtering-correlation-id: 55ca717f-79bf-45b5-23aa-08db3a2b386c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JNWsHtXRWAqChNE10fjXPcL8aCHEVh5LMAYiqeWV1xdOt84/2Vk5rYYZvabTgJZCdlHaQsuxO85uJ7AyvFEG8dTFE4TbjFrbBci5TYvq5qv6oSKvp2YRL+O7QrwtU4Rdq/6d2g1i+ME6JO4F8+Z2pIPSyRfom4KRoRIb1qnQjrGpOj6NVYwTR1dZ4Xkm82iYKIrJlzjUN9xByask7BvdcgDkLIdb9lrx1FyGpXRumNRccCrtKKACqOMOkXwlHVpnt6zAWy6MXjM8IsmBHNQDBxv5LpTVhwyNaqA25G7IrHOqY7pudLFJ9PZaxDZqaiRV88iExYW6267Sw26LxFrpqrbfU/UKC76DTnDmcnzTEzmecqeTNhJrGTRTBAQ+6iR6UEuoOey+BUvYStyg3le2u3hA6gsVC+IOfywmTW+SkZTq8S7sZcmwZwL6+hF+TWdDqsyrRom1/S45hwcvUPu2nHWj3LCd0uOLjOb3aDGD81UeOWbH/d+aMbEvOmmWl0LqK0kcLVLT8pDGciDR0UPHUTGC88RKzmI/s3tdfr6UJHrjWnQJuAB5DtG4fAqS1F3MkGr7TkrtZXBE9qgjlcDnnLxf4/W5UVJbbzl05SS/R41YXJDH4mIVGuxwDA2KuIyo
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR12MB4787.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(136003)(376002)(346002)(366004)(39860400002)(451199021)(38070700005)(4744005)(2906002)(3716004)(36756003)(8676002)(8936002)(38100700002)(122000001)(5660300002)(86362001)(478600001)(71200400001)(2616005)(6486002)(186003)(54906003)(316002)(26005)(1076003)(6512007)(6506007)(4326008)(66476007)(66446008)(64756008)(66556008)(76116006)(66946007)(91956017)(83380400001)(41300700001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RXJjZXJ6YW95RU1pNHFQTkMxWGIrbDZ1akE2WnNlMzhGWFBZQ0lLMFBTUjJw?=
 =?utf-8?B?Y0tOMGE4Zk42aVB2blFxUGl2dEhOMjUzLzJOcDBicDVMSmdyRml6Ykk0dWh3?=
 =?utf-8?B?OXVOSW1JdHMxaytVUEdnSVZkS2xsSllUNlQ2T21oY3cvQzRzZGdQYW90VXZ4?=
 =?utf-8?B?eFN1bmVEUFZhNm1kN2tIK2FseXRuQjRaV1ZPWDFyVC9hZUhaL2RGcDVKOW14?=
 =?utf-8?B?MVE4dUg4TGt6QnkwZ3hjVk5KMmtHQlo2dXp0czZFYkRRUnBwaE0wSG5qc1h3?=
 =?utf-8?B?dmlHZmJTeTZpUEQ1aXRLRWpXMFVGOTEvMWtHQlVjSXVMUnVuSUt3OXhIS1Qw?=
 =?utf-8?B?eklFVGFTRHRzeGg5aEREemNSc0I3Y04vVkRMOUlTMEIrMitWcEVPTXhKRlRW?=
 =?utf-8?B?NVlublhraGZhTE83bGg2UmpEbytCakdCbW9tazNEaFFYYmZ0bnhiQkllME9E?=
 =?utf-8?B?R2tJTjNVZ0lVWjMzTXpDWlJMWTlFT1NzMGJqWlY3ZmIwMTg3NDlFZytKa2NF?=
 =?utf-8?B?UzNMdmlPb1BDajBPd0wvL1BsV0NvSDBCSFMxZ3g3NnVxME12bmZvbEF2Z1Bm?=
 =?utf-8?B?cDdRYWgrR1ZWUGtTZy9ZSjM2eWdVR2lZV2FxWUdpN0VwK1JzcW56ZmJVaStz?=
 =?utf-8?B?dkRjNlhrTmVsaEl2azBFek9RME8wYms1eFZDNU1qdld4VmxrL1hHUithOUcv?=
 =?utf-8?B?VWsvSDlEbXgyZ01kS2V3aE0xU3h5UEdnMzJ6NnYySVRyQUxvVjRqTTVQQytj?=
 =?utf-8?B?aVJsbGI2WGE1dWp4ZEovNnUvbWpBQU5Jc1hPc0E2bWZHVVo5VUMra1c0b3VF?=
 =?utf-8?B?VGlXRFhaSDBpTzlrUGRVblFwTHFBTFMxOGNNOHl4bWRucXp1R2VTcHNDa2pH?=
 =?utf-8?B?YWVkaEdwSThKZFFXNzRHcjFrU0lVWk5uY3dMTURIS2NRRWxhaHRCYzVmSEFN?=
 =?utf-8?B?aXZ0Ny9SRlh1UGI4YnlQQ0xEeDJ4QW1RSjJWYXA2WHE3R0RTRFBRb0k1Z282?=
 =?utf-8?B?UWxUbnN5MkFHb1pOaHZ0RytzRnlDNC9weDdrTGd5SFRuVU5uc0JyV2JhUzhT?=
 =?utf-8?B?d2tEUmZsMWFod1ZVY0dzdzhndEFKczNLbVN6OEl1cmZQU3puZEhWTzJKTGwx?=
 =?utf-8?B?bjJXekJYZXA3bFNHenB1TWllTERPdUhLdTNPVjdkaWpXdHRBYXJLVkgrVm5j?=
 =?utf-8?B?ZGoyNU45TU80QldiUVhNb1hvelc1MDJUS0xhcVNLVHFqNU53bGdQL05yWW5v?=
 =?utf-8?B?VVQxVlZZV2NhRFBVTyt3NE5rWTgrcVFDd25admlrenFyK2dOcGpNaGlmb2xY?=
 =?utf-8?B?WVZNZU9KelZ4RmcxN25HNENLQlJlWWw0aUlSZGJSZmdKdVphOWRQbGRnZVF4?=
 =?utf-8?B?R0NuZmpOZ1FKTzQ4N2pFdVA0SHpQc1I1SXBSOGFVRi9WaS9JUXBJWjlCZzkw?=
 =?utf-8?B?V0NHVVdxTnJ4RUt6K2lUOWg4ZzM1TEVKTDYrZ0NoMVZrei9DQVVta0xibjE1?=
 =?utf-8?B?OGJMTEdKbjFaMmljYk9vRlFpbkM5aCtXRFJvZWRVNS81Zk8rVFBLdXE2Z2k3?=
 =?utf-8?B?MzRRMUZmYmJ5dlEzSmJUcEQzd1lDaTV5RCtBNmEyTzZmYTBtcGxpUHF2Lzkv?=
 =?utf-8?B?aVFoQnhTZWNvcWZTUVRGKy92c2NnT2hVbzlWbkpXNk5uUmRSalJsdkNZMTlz?=
 =?utf-8?B?T3o0YWQ2bHM0YnV0KzRDTEZwR2tUMnFrcjRKZnVUaDFoRXFBYTlSSEY0bVR4?=
 =?utf-8?B?VHhuWk85RmF3YlB4b0VaZVRGMmg2K05GaERIclRqMXQ0Zjg1WnpJdnRDa0Nr?=
 =?utf-8?B?VU5GL1loTlgyb2FjMnNOWHdQRERFS3dUWENnRU9WR3ovTm5abGxHUC9iRVQz?=
 =?utf-8?B?OUVRZEw5MnI5RjZ4MUlidE14TTJNaThTVGZJMEptMFJIMDVLRXVYK2RjM2Rm?=
 =?utf-8?B?S3B4Qk5PL2NxT3hVQ0xvN3Z2UjZuNlpnTUl3SCtmVTg0di8yT1Z6V1NBVVdX?=
 =?utf-8?B?bEh4UkEvSkEyZEFSSTVLN1FYY2N0aXM1Tk96NU5PUS9BTGhQZEdwMTVqSG5C?=
 =?utf-8?B?eG1UZlo0SmxUYjhMQ0QwamVzd3VERVRDTE5seFArZ2JPVUFDU3Y4OVMrYlp1?=
 =?utf-8?Q?wOXAfvHT2KDfiFjKvMTGbFXxB?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C0EE7E9D4075734D86E743C99281DC50@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: FUIeQvV7AJowKg3jRSdjqBOl9k9szY7QM9lAZADWcBttojCIj8DVUe6D5Iw6L/mfZZGrNWr7IoDW0iCxSgjD2ErNzvYKoPNcQ3DkTv1IHsxIlifA0+1EyqPabv8MlhuOafyomptwHeHPFPLQYzf0R93fZgm3onjpE/BMHzVS6UHZszPEmFctjHhjFVQFn2VL58eu/JJKlwJFGe2Ihfy4FbUfx4FeTEwVaDAJ3hCenDEZJOFkWkZCvwcfTV2MqCvsgeIWkLEG1k4Wus9pFR66UY4gvAbIsCUIgLBFOqUMh97jQZojDCS/lmd00ZevYdosX98ymLx47eb8Xg9BTXqq1/29sAcv7m+phHtOb1xY/0MMVwiSoCeFBxHFmVBKy1xDy3l2TvDKRcl81frQ6bIoz+q5T1GdPgDtCLGgB29a7JszN1lk5iK7RxW3yJRp71noY5VKWrjryzP/fqxJy74NQHWndbyCWfY85zRM4PEd5H8l1S8B6OXM9pAuqgH80OMEarAVp+q5x9dmkdKcIupGXIHK78OIoET8xlThVTxJU/7r1BYtznGP1e1rSyZxeL0af5T2xiGXtpq47EqOhmQpgSHQ98uuvq7+5238hrCpmTx1Nys0HawoiElEbnSdfe/1vHK/+uaSegtVCrrNr0auuyZRSmjBHir2iLzfatnEYtotCmBf+mZQtOYPypThjUPaXjOq1XAZP1vVmVvqB4v2QK04ogZnMy1rhQ+Y346GO14iAb9v8UtlvaBZMtfGR/3T8AhKfbaePcFhcGlO1YT+qkpuAj8q/54yiOgnH0Xt2/HyIXVmJ3fxpY/HFvetp2lRtpRlTxcNNKOADaVHxUj5RxAkK1uZVwvtdoRAAtMuBhKkYZa4QNJOCcpY3jXljDWyPDkOsZ15Jqe0FseEyVsOrg==
X-OriginatorOrg: synopsys.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN8PR12MB4787.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55ca717f-79bf-45b5-23aa-08db3a2b386c
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Apr 2023 01:22:30.7643
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: c33c9f88-1eb7-4099-9700-16013fd9e8aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: G4ejCXJ1oEuXAh+4AGTowO4H1tNVulNEcjwdcoB96H/0kzDgFimUw980k+0NkydPy9hjxB1IXjPZrKuzn1ErXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB7002
X-Proofpoint-ORIG-GUID: tAZ-_EHBlRY-V1b5VZWh_XZjdOPFM-ID
X-Proofpoint-GUID: tAZ-_EHBlRY-V1b5VZWh_XZjdOPFM-ID
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-10_18,2023-04-06_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_active_cloned_notspam policy=outbound_active_cloned score=0
 bulkscore=0 mlxlogscore=876 impostorscore=0 suspectscore=0 spamscore=0
 priorityscore=1501 mlxscore=0 adultscore=0 clxscore=1015 malwarescore=0
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

T24gVHVlLCBBcHIgMDQsIDIwMjMsIEpvaGFuIEhvdm9sZCB3cm90ZToNCj4gTWFrZSBzdXJlIHRv
IGJhbGFuY2UgdGhlIHJ1bnRpbWUgUE0gdXNhZ2UgY291bnQgb24gZHJpdmVyIHVuYmluZCBieQ0K
PiBhZGRpbmcgYmFjayB0aGUgcG1fcnVudGltZV9hbGxvdygpIGNhbGwgdGhhdCBoYWQgYmVlbiBl
cnJvbmVvdXNseQ0KPiByZW1vdmVkLg0KPiANCj4gRml4ZXM6IDI2NmQwNDkzOTAwYSAoInVzYjog
ZHdjMzogY29yZTogZG9uJ3QgdHJpZ2dlciBydW50aW1lIHBtIHdoZW4gcmVtb3ZlIGRyaXZlciIp
DQo+IENjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnCSMgNS45DQo+IENjOiBMaSBKdW4gPGp1bi5s
aUBueHAuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBKb2hhbiBIb3ZvbGQgPGpvaGFuK2xpbmFyb0Br
ZXJuZWwub3JnPg0KPiAtLS0NCj4gIGRyaXZlcnMvdXNiL2R3YzMvY29yZS5jIHwgMSArDQo+ICAx
IGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKykNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJz
L3VzYi9kd2MzL2NvcmUuYyBiL2RyaXZlcnMvdXNiL2R3YzMvY29yZS5jDQo+IGluZGV4IDUwNThi
ZDhkNTZjYS4uOWY4Yzk4OGMyNWNiIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL3VzYi9kd2MzL2Nv
cmUuYw0KPiArKysgYi9kcml2ZXJzL3VzYi9kd2MzL2NvcmUuYw0KPiBAQCAtMTk3OSw2ICsxOTc5
LDcgQEAgc3RhdGljIGludCBkd2MzX3JlbW92ZShzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlICpwZGV2
KQ0KPiAgCWR3YzNfY29yZV9leGl0KGR3Yyk7DQo+ICAJZHdjM191bHBpX2V4aXQoZHdjKTsNCj4g
IA0KPiArCXBtX3J1bnRpbWVfYWxsb3coJnBkZXYtPmRldik7DQo+ICAJcG1fcnVudGltZV9kaXNh
YmxlKCZwZGV2LT5kZXYpOw0KPiAgCXBtX3J1bnRpbWVfcHV0X25vaWRsZSgmcGRldi0+ZGV2KTsN
Cj4gIAlwbV9ydW50aW1lX3NldF9zdXNwZW5kZWQoJnBkZXYtPmRldik7DQo+IC0tIA0KPiAyLjM5
LjINCj4gDQoNCkFja2VkLWJ5OiBUaGluaCBOZ3V5ZW4gPFRoaW5oLk5ndXllbkBzeW5vcHN5cy5j
b20+DQoNClRoYW5rcywNClRoaW5o
