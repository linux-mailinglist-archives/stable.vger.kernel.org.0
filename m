Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48369634C02
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 02:05:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235417AbiKWBFo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Nov 2022 20:05:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235479AbiKWBFa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Nov 2022 20:05:30 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D804BDEAEF
        for <stable@vger.kernel.org>; Tue, 22 Nov 2022 17:05:26 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AN0tRCP014550;
        Wed, 23 Nov 2022 01:05:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=corp-2022-7-12;
 bh=cpgY6YVXF21/I5q/VnqYG1JuekkRi3SUr7wqFb6k17g=;
 b=Ib1kvDDMZU0/rXa9a4/yLRpaIrwuwJ4PB7Tt4tsZFrnBBpw+MmKAgn/ZX9PEHGDOXh6D
 qwR7EVwuOklzPMGNiDk4mZEpnvHaAw0C+AOg2WWRorR0sdsejOdo9O4ovbt6uFMkK8Un
 4lc4GmZWEaIIElK4yxD6fUJ75UGSU9GhbgWy80OKJQwE+SOsjJO+kR5C/dFmQDrq2fZA
 Dw065HziBsheUOVljb3AC97Hp463ckPx6kNSMU1Xfl70JsgLZiR9z6nPbHQM+3jIyPAJ
 dM90XC/NYCzsDAj48m6qSKQxwKICAmZlF3FGRSWgUsXmRpbY6d2z90GbHLVmidvnFwod BQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m16950cby-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Nov 2022 01:05:12 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AN0wg8K007504;
        Wed, 23 Nov 2022 01:05:12 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2106.outbound.protection.outlook.com [104.47.55.106])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kxnk6dvra-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Nov 2022 01:05:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BO2T2ukIUwPZnp7BwudYJc9C8i/JhLgB5pxOH2HO4kBMbcEQoURsvhmtg8cK2nLEy5ujzB9cTeISU6dnzhbqnoYQ8TJ06MIk0Fb1yEc0r4jRiO/8EMwENUamDoMI4vY9yfXF8AFsfPiEafj4MsvXP1UrEJaXq/lq514IhHleznXr+Lgb5mnHvcHAvSq4S3tp78d9JNpSD1+553vVYxL9xi4seIsXwGft/SVFNoLAWHfs+B3itscdVgtxSoiOHDzEN4uj7f98PjZPS1JDQ8zRbyfDUwV+VrVRo3ioVNpX9V4oSrnOgMCNxYsU6erWfJP4yBmkZLrvymXsUNGMDQ0pWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cpgY6YVXF21/I5q/VnqYG1JuekkRi3SUr7wqFb6k17g=;
 b=iCH5CCZrTJNvEDmUM69ktH7bfNcBYgbc7zrAgJDFXe6GEj43II++a223bsogwcof3uvGXhqP2ZY0M2dznCkSdHy2k2QrD9JqtysNtY2dm8C+voT91D7LU8wC6bnrVQKaUZd6JW+sD7Vab4sDzmphDQnlJMu7E6mnpCffiT4U1wE7DSyqvXFAyFb5I2AoSjBSdInMBG6NOXagf8ukJkMS2Gs2VOLBfPyZhM/D8TibQpMRmOV8zi9fkmTzG9HrHUwm36mNlB+jluodS3IrAWCFOdbpllXVesKKcRP/dEmumAAMaTSFsdJHRLzLScPKI6zmzU6LQSWnNnf7vyVrbq5zog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cpgY6YVXF21/I5q/VnqYG1JuekkRi3SUr7wqFb6k17g=;
 b=Q/vRhE77/HTZwkymGFWoFZb2/B0krQDqWydW/5bE0taisNZcD9/L3LqzJbUY9+IcU45NMMnYPMkKUtai7oAtZaMA4IbxnZrdtDZ7fmL/BLae2iR6aSvaj6cspLY+WhvwpWeNFnu0x6CTwJxq8jutdfnqhxu3fNICnpYI9Sihl2A=
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by CH2PR10MB4247.namprd10.prod.outlook.com (2603:10b6:610:7a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Wed, 23 Nov
 2022 01:05:10 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::8d67:8c42:d124:3721]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::8d67:8c42:d124:3721%4]) with mapi id 15.20.5834.015; Wed, 23 Nov 2022
 01:05:09 +0000
Date:   Tue, 22 Nov 2022 17:05:07 -0800
From:   Mike Kravetz <mike.kravetz@oracle.com>
To:     HORIGUCHI =?utf-8?B?TkFPWUEo5aCA5Y+j44CA55u05LmfKQ==?= 
        <naoya.horiguchi@nec.com>
Cc:     Naoya Horiguchi <naoya.horiguchi@linux.dev>,
        Greg KH <gregkh@linuxfoundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Yang Shi <shy828301@gmail.com>,
        James Houghton <jthoughton@google.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: hwpoison, shmem: fix data lost issue for 5.15.y
Message-ID: <Y31xw1DcqXGx86Fz@monkey>
References: <20221114131403.GA3807058@u2004>
 <Y3JotyM0Flj5ijVW@kroah.com>
 <20221114223900.GA3883066@u2004>
 <Y3LG/+wWSSj6ZYzl@monkey>
 <20221115011646.GA767662@hori.linux.bs1.fc.nec.co.jp>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221115011646.GA767662@hori.linux.bs1.fc.nec.co.jp>
X-ClientProxiedBy: MW4P222CA0016.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:303:114::21) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4196:EE_|CH2PR10MB4247:EE_
X-MS-Office365-Filtering-Correlation-Id: d1e3bb35-944a-4a4a-341d-08dacceec46c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: elfRo6pIieU1VaszsiJj/RFO+c4pqA6vj+AipfmLgak8J0mctqdwbwqnfCzRdFUmuzXVdUbNxrbiaDtlPp6hnYJwfDUuyZm12VOhTriH7hYMX/c89JotQ/yK3/QB/NQyXi0nrnjvzKizGnWeaulUVIYEJNnvtd4nHZFrRJhCUgb+vve6yEvxZcWBXCHEHGzvPCRFE6ml6QiWXqy2Yd1w1fkXXFwvt9iZ6ZtFEzSqmU9flswsUkclOxV32d7kmN9uMRVEyp005uFuA7SYXKnFo2O06ulg+QpjE320JVhynq4NXgHh0UPFEcXr7ZuZvuWvuGo76ETAnrt4bMtG3PxJ/ypwE81y/JB7P/zNpD2vJZUC2t1Lq8qAOr9Lt8/Up57Hp0tKD25uPtUiiMpA0eG9zs0tQA73q2ktYCCSImNV324hOQrIphApoqwYhL8FhqIek7/bAJTEqA64QNvfVb2ImljJJg1SsrvoM0nlr182A6Hblau4vsUQRfUArnMeTedTnJp7UZi3O9VolgaVhB3SJ4HCVfkqU9zCKtPADsqZ165lTSF71RlhQAr1XNaLlMZHo1PAB8IynAskV343/rcQEvmCCje7D7WqwtdjE2H5PrSI9lxx7vziuXOXRwoCVC47
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(346002)(396003)(39860400002)(376002)(136003)(366004)(451199015)(6512007)(9686003)(83380400001)(53546011)(2906002)(186003)(26005)(38100700002)(44832011)(5660300002)(33716001)(6506007)(6916009)(66556008)(54906003)(6486002)(41300700001)(8676002)(316002)(66946007)(478600001)(8936002)(4326008)(66476007)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WGYwM2xtZEU5RmR3V2Joc0wwWmlJZWJ0OGxTZkdGU0JPdjdLeU9MZjRUUE0y?=
 =?utf-8?B?cWlPUzErbmNqb3NpYWRKOTJrTVlyR3dsMXZDYnYwTlo0bFQxQ2FBSC9VUk9w?=
 =?utf-8?B?a0lybGh3Z3JrOG13UTFNeWNGTFhxM2VqeFpnWEYxOFlzdEF5R1d0elczdzlR?=
 =?utf-8?B?VHg1OHJaakR2S1hCTmNuYVlyZTRoa2ZtV1ZuNk5CTmdlSExKQmlKQWsxTVpP?=
 =?utf-8?B?VnRuQVp3d1hBMjhsYTkzUlBnZGl2NXB1MHI1dnY3UC9KVzU1cUtIOVVpbGYw?=
 =?utf-8?B?aEc1YWwwRmFrbzZ1aEs5TTBHdDdidStzRS9taUZwZ05CV1p4UFVaOUZvU1Zi?=
 =?utf-8?B?R1RJT21iK2Y1Vm82NHBaVWRkSi80MDIxSmthNlFIY28rZ3ViZm5QcEw3YXNB?=
 =?utf-8?B?Y3Z0cVhBZEpEQ29KUm15a1hTYmVhaVhvbWl0dkFlMGlsZlNWc2ozQVhEMTBs?=
 =?utf-8?B?cGVJQWs3dG9QVTZJeUNyUW82ZGZMOWFYeEZmemd0dHJKdVN3bm1Ldld4Mk1Q?=
 =?utf-8?B?VjNONEZjWEx0THo2L0YvZ2hGdjFSVzZTNjVjSjdDTnYweWxSRG1pZUFwSUk1?=
 =?utf-8?B?TVFMeUYzdDBEUTJyUkFONitIZVJhQ0dScVh4TC9LTTBBRUVCVE9QdWJRQTZ3?=
 =?utf-8?B?dTM4Sk5EdDhvWGU2OXl4Q3hESlBHQldJSGowOWNJTEtjSTJlQWJ0K2VLa1hv?=
 =?utf-8?B?VWY5eEt3MG9PYXE0Ukg3VEhKQVF0L3oyZllLWVh0bHBWTWRIVGl2SEJKUmMv?=
 =?utf-8?B?RXV1VnZncHY1cHkxY0Zmd1g2TVdQTDl3YWdJckk1ZzlYdml2TlU1TEpQNFdH?=
 =?utf-8?B?NWMvb3dCZHdYb2hzZW9QVFdVeHlialBabXBQbE9GTEZnbFpralltTmVYVWVJ?=
 =?utf-8?B?VSt3QVZkb3F3aGhSN25KaDBIU0xneUVsU245ZUZVQ1ZrMzcydVcyS1pqZVVm?=
 =?utf-8?B?VkxMVHZvQk9wWnBwQjJIZVNjcVBFUUlJMHpEZDdYVVJmYnEvbXVHUW8zQ1N4?=
 =?utf-8?B?Wi9veFE4eUZMcVR4cFZ2TXFHL2dGWlJNRlk1Sk1sQVExdmlkeTRWMzQxSkFL?=
 =?utf-8?B?aFljeldKVFZlLy96OFN3NFVZVXFkTGtxU1krOTNNQ0Z3SmF0TnZ6bk1nbUlv?=
 =?utf-8?B?UTZGUGFSL1IwVy9MUlprcG5CaWZNN1c2alJsV3JreCt0a2s5dUlJSVRIRUlS?=
 =?utf-8?B?OXlETlM5bkZPZUZUcEVONkEzT3F1aUtsTHJXZzduclVUdDdWWnI3NUh6aitp?=
 =?utf-8?B?b2Jad2pYcHBNQkJ3eGJWaEJwVGYwS2JETGJRcDVmNDZhR1pWR2pDVjhLMm1U?=
 =?utf-8?B?bkJGWTBPd2NwUUV1M25HVDdjY1BOREVxNGllYzVuZWowWVNJSHhaSCtCVGdx?=
 =?utf-8?B?dE5UbHVHNVBvdFRYaEhxOTZxenU1S0xnMzEvWnZ4TTN1ZUtsaDhwcStkZURD?=
 =?utf-8?B?WmwwZnFCd3ZjY2NGb0R5MXF5MWFwOU9oa1RSRVFTb1lhTW91Sk5wcFNGRkkv?=
 =?utf-8?B?YndERDlvMWx0eit3dmZidzdZbnQrYnYwMTlBd3ZBYnBsdXlRZHZORzNiV1ow?=
 =?utf-8?B?WlRGUUNqc1FyU2Y2dmNQcVJ2RlpOanlEYVh1MXBjdkx1aCtzSEtkZUtpSVpq?=
 =?utf-8?B?ZlBSS2hXbms5RUZkc21xay9TeXVyZ3dLejhjYmdlNUtoaVpUakN4UE9XcjFQ?=
 =?utf-8?B?VWJwYXMweStteWVNS09yMnhDclRIN2l0bWhPWkY4L1BsQjR2OXRraDNldGNp?=
 =?utf-8?B?WnBGdzNlbnBEUmV6RnZLdDJmbzhTK05TK21CUUUrb1pKMU14R09nUmpYcm1N?=
 =?utf-8?B?NmZLZU1ZZGlwOVpnYnBtcDJrVzFWK3ZJQVd6OUNCZkowUmRFd3VOb2RBSndW?=
 =?utf-8?B?YXJud2xZNGMzVzdQRUhwNnVZdjVSRW1Sa3NBbm5tK29veGFpOFJOMUZ3NWZ6?=
 =?utf-8?B?S1BLMmlzTnRET24xbUVrOU92Z3FJMlpWWklSaWdnb2gyMHVHVjRhMDdpZmNZ?=
 =?utf-8?B?SmZZK2d1VWQ0Q3hXMmdWbDVKcTgzUVRZT1dTQXZCeUVOYy9PZ0FPQ1dCQWlM?=
 =?utf-8?B?SXZkRkZnQlBEaFhHZFYyNVlQblE1UDRmM3llQ3dLM1BETmp1OHAyUDVCcS9H?=
 =?utf-8?B?T0FYQTdFaHlrVENOZzJZRHRXcStDdXZvYWJxY1p1SEVjRGpwdWpPYzI0L25R?=
 =?utf-8?B?dGc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?cTJqd3p0TlczdGF0eWF2NFpIYUZlZjg4ZzRCT3RITEN3bFZscWllTUZ5RzBV?=
 =?utf-8?B?WVNmSUEzQXRnZnVwaWgzaGU3Y3U5cnp0azczNGZMb3NVclZBWWQxRlZ5VWk1?=
 =?utf-8?B?VEdIY3lFWWtKdFJKTm1xMXA2Z2R3VWdGMmJrVVRGb3pza25LYkF0djVtOXlT?=
 =?utf-8?B?U3RsVjh4NGMxOTBTZGwyK3RMWUV4YXFaOUVONTR6c3ZyTjFXbjUzZVdZNUdx?=
 =?utf-8?B?SDRXR001NnpVNGtXQ082K1ZWUkNqTlA2YVRkUEwzWTNUNElONEpTV3BSQzdC?=
 =?utf-8?B?NVozNk84UmRocDBkSTVYQTNnaVRRNCtLdlR3Tm9YWHF4aFJZT1JnTjZ2bEIw?=
 =?utf-8?B?emFacVExUkV6ZSswV1RMWU1qSDY4M0RjVTJINThWU2p1SWRUVW15S0JabllR?=
 =?utf-8?B?U3djaXlGMmhaR3VzNkpaOWhVeG5QVmw1TlhJRUJ2WEtVanZEazV4ZzE0THRr?=
 =?utf-8?B?aXp5MHJ4bk1VQzhKNXdUVU84Vzk0cmZ4OHRHR0lYNjFaRVN3T3ZWcFlCT3NG?=
 =?utf-8?B?QVd2M2JkNXAwUlF6ZHE2eHowaDBvNWxrTGZpbVQ0Y0xXcCtud2ttNUIwRWht?=
 =?utf-8?B?NUtncFVzNVNLbEwvMHRrVzRJMU5QWW5EUnp3OFg2clhsUWFlMHRCWHZ0eDc0?=
 =?utf-8?B?SGZEd0xIVDhVcjJXeko5b1l5V3Y3LzFBZ3Y1KzdHdGtLY1N5YzliWU8xSHlH?=
 =?utf-8?B?QTFsYVJtVnVnZ3FZQm1vYWE2akhFY0JyUUlzcFkvcUxSQlNUUzZyaWdNY3pt?=
 =?utf-8?B?VVo2VUI1TDl5YkR3ZmNTUUR2TGx4bXlrbC9DYmxzNUdrdFRVTU1mVGRQRytB?=
 =?utf-8?B?MW1PRjdmNlVIeWh3QUkxeDBRMDZZTk9XZ0UzZ2FBSnVtQjNsaWFoc2NtUE1x?=
 =?utf-8?B?S2VJQmZ2REVLSVMyMTh2YTdiYzE0VmUwQi96bHc4T0hmU3p6emdmSURtTm9H?=
 =?utf-8?B?VjIxaHo3eWZLTjgydUFDVU5IVjdkMEQrVVhFMktKL29la2crMDgrQjkvZ0dN?=
 =?utf-8?B?cFpiOGpFNGo0dlpGYUJ4WTdQbVB3YnpnM3lROFIxTzc3eXhUSDVaWFVyU3Fu?=
 =?utf-8?B?aU9laFNlYnFPakNQN3NiNitFam56aVVTV25NMFp3OWxPNEdOc3hheTA3bWFp?=
 =?utf-8?B?U2lwdmUxMjFhenNjZUtLYWtTdmdjVWc4OHkrVUU5Q0lQYUk5SGtmVTBCSnhz?=
 =?utf-8?B?ajZWanNoV3hRZTRZN3RKbkFFWUI5eUg1SFlyTStnaFJFdHN1ME4yLzVNalph?=
 =?utf-8?B?Yy8vbnFmTERaS1lETFVFNHo2NFZMR2U3V05HY0hjVUFKVisrZmZ2NHRJaFEw?=
 =?utf-8?B?SFpOMGZPTk1SUjFZMFh5ZGZuZDhlZUZRNWY3RWpEN2RLTFZWelM1cmh0Sk13?=
 =?utf-8?Q?8B/mhRW/B9pzMlSzBQYA0OI6bQOTjop8=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1e3bb35-944a-4a4a-341d-08dacceec46c
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2022 01:05:09.8866
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v/I7csq//QwsegkE73ndVgGZGtLQdS8i5c4EdNTxc3ZXGP1IkRJsb99A9frZfcB0EIld3OsFmBnlw/7ISxdIHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4247
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-22_13,2022-11-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 malwarescore=0
 phishscore=0 mlxlogscore=939 bulkscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211230006
X-Proofpoint-GUID: QUAn3HdMjzUt8GsGLwlUK9AQ_0jOHwok
X-Proofpoint-ORIG-GUID: QUAn3HdMjzUt8GsGLwlUK9AQ_0jOHwok
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/15/22 01:16, HORIGUCHI NAOYA(堀口 直也) wrote:
> On Mon, Nov 14, 2022 at 02:53:51PM -0800, Mike Kravetz wrote:
> > On 11/15/22 07:39, Naoya Horiguchi wrote:
> > > On Mon, Nov 14, 2022 at 05:11:35PM +0100, Greg KH wrote:
> > > > On Mon, Nov 14, 2022 at 10:14:03PM +0900, Naoya Horiguchi wrote:
> > > > > Hi,
> > > > > 
> > > > > I'd like to request the follow commits to be backported to 5.15.y.
> > > > > 
> > > > > - dd0f230a0a80 ("mm: hwpoison: refactor refcount check handling")
> > > > > - 4966455d9100 ("mm: hwpoison: handle non-anonymous THP correctly")
> > > > > - a76054266661 ("mm: shmem: don't truncate page if memory failure happens")
> > > > > 
> > > > > These patches fixed a data lost issue by preventing shmem pagecache from
> > > > > being removed by memory error.  These were not tagged for stable originally,
> > > > > but that's revisited recently.
> > > > 
> > > > And have you tested that these all apply properly (and in which order?)
> > > 
> > > Yes, I've checked that these cleanly apply (without any change) on
> > > 5.15.78 in the above order (i.e. dd0f23 is first, 496645 comes next,
> > > then a76054).
> > > 
> > > > and work correctly?
> > > 
> > > Yes, I ran related testcases in my test suite, and their status changed
> > > FAIL to PASS with these patches.
> > 
> > Hi Naoya,
> > 
> > Just curious if you have plans to do backports for earlier releases?
> 
> I didn't have a clear plan.  I just thought that we should backport to
> earlier kernels if someone want and the patches are applicable easily
> enough and well-tested.
> 
> > 
> > If not, I can start that effort.  We have seen data loss/corruption because of
> > this on a 4.14 based release.   So, I would go at least that far back.
> 
> Thank you for raising hand, that's really helpful.
> 
> Maybe dd0f230a0a80 ("[PATCH] hugetlbfs: don't delete error page from
> pagecbache") should be considered to backport together, because it's
> the similar issue and reported (a while ago) to fail to backport.
> dd0f230a0a80 does not apply cleanly on top of 5.15.78 + the above 3 patches.
> So I need check more and will update my current proposal for 5.15.y.

When working with 5.10.y, I noticed that commit eac96c3efdb5 ("mm: filemap:
check if THP has hwpoisoned subpage for PMD page fault") as well as the
prereq commit c7cb42e94473 ("mm: hwpoison: remove the unnecessary THP check")
were not backported to 5.10.y.  Without those patches, THP testing will
fail.

Naoya and Yang Shi, does that sound right?

I have backports for those as well but want to check if you think
anything else is needed.
-- 
Mike Kravetz
