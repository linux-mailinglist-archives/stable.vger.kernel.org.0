Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DD4F6BD896
	for <lists+stable@lfdr.de>; Thu, 16 Mar 2023 20:06:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229707AbjCPTGF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Mar 2023 15:06:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229946AbjCPTGD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Mar 2023 15:06:03 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2CB2E4C63;
        Thu, 16 Mar 2023 12:05:45 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32GIiNVE004111;
        Thu, 16 Mar 2023 19:05:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=EegPSvFgMYk3Y9/pnrozDNFWWJH44CcL/3Yi8jqxrF8=;
 b=0Bw/E/fbcozPReP1H6UqP0jEjjHUkNebnZuZ0RJjpEjTiyXVPVGy4W01CQXDk2NVZWzR
 OH4Ulk5PWyG7qIpLasK7I4ld5botil/ty1OeMppjxMQo7ROfmijqQcgfLQZpB3VH67TB
 npMVTZlzZseqZ3X6RJXICCTSFas/pbIkZTHB9OlaaJx/SAYxS730UqFC7nVAq28fLHBN
 LAl8EkcFDVj7an1Ys4TMzkXomdSChSearB37mpS6P1mQTlpnK9X9qbffoGMXvlB8yQ9V
 IIqXaHX4l3YbKC5zZctE6bQat3BDJ02uvfxEtSmDOJ6p5vgc1i0iZzwFinltgVg0UPMe vA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pbs2aj0x6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Mar 2023 19:05:03 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32GIFp0m036887;
        Thu, 16 Mar 2023 19:05:02 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3pbq9j0k02-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Mar 2023 19:05:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cgw3+6hp9mzksgtIeqK/OUXxNRbMmHXlc16wixIcbj9awTlcqkyE/BVkCxE2FS4sT1i+QWYJmsugTk7/kR/tJH71qUlkhkwkrLh03ihb3ETtT68cfcWeIkwlFWQWqQOSVQGV/mSDtzzCWTPLWu3Mn3iyjiCwhGIC3/LlYIzKrHANEs0K2xVuEWaHn0lHC1gBRf4AHrupESfSzCRve8ynGfT+L5Y1EkXBYGtMemzHQ5KUvXfXE0eC7/9qpI+C1o94Gx+y6d4iDsLhmBDv7ChJJAjxX3UE+3bil2geual46WrdA2hw0umER4GrkuLIYCfd5wkbfckgRVes6h8wspSweQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EegPSvFgMYk3Y9/pnrozDNFWWJH44CcL/3Yi8jqxrF8=;
 b=TzmtiA43SYsRZEP99ewtYsyrfxwh8L2+A6v68qlBTJuUfv0lI/uh7VWAfHW1tTaixU5qyz9mjDdyL81DjZsP9hEpgrzrGrjxeEcO1S6FOnlnzeEkwm3a3rXmOqxR1QmLMSzpyww3gcT/rsFJOVPf84l8+lMAzwIHXjgvCUW1tFjZapUgyidBdh/l0Z/DDn2WWAAxTUJSMsZCZkdMtyhtntTUQC2GiHaBglbuTNBJMepbnn8uH1KPzrnV+vLKzxcTZYUUnF4Twmd8jQamOmHn1aLZl5KOD3HDE8OQHCdJpCyLh2w9KMkL6XfCY4mXSGcN85uLcmbJjswKxlwBKf5H0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EegPSvFgMYk3Y9/pnrozDNFWWJH44CcL/3Yi8jqxrF8=;
 b=DXesOKLCuI0B12tuaqeFvCZ9qucaD67vKM/KjFYOAArKjbQHV5XAcEI/nkh/90Kzh+ihF973IwBx6znWQ2iTwIuQ/j4mtYuQQQYfViKy/goPoT/VCabcLsKmRUU46DCvnIodcBcMhwbppPZl41O3ax6cJPLJxYYoT4Jz6I3JPs0=
Received: from PH8PR10MB6290.namprd10.prod.outlook.com (2603:10b6:510:1c1::7)
 by PH7PR10MB6177.namprd10.prod.outlook.com (2603:10b6:510:1f3::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Thu, 16 Mar
 2023 19:04:59 +0000
Received: from PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::ffeb:6d62:6636:6c38]) by PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::ffeb:6d62:6636:6c38%6]) with mapi id 15.20.6178.026; Thu, 16 Mar 2023
 19:04:59 +0000
Message-ID: <4897213c-a727-be5c-8dfc-e97ee101e011@oracle.com>
Date:   Fri, 17 Mar 2023 00:34:46 +0530
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.1
Subject: Re: [PATCH 5.15 000/137] 5.15.103-rc2 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de,
        Vegard Nossum <vegard.nossum@oracle.com>,
        Darren Kenny <darren.kenny@oracle.com>
References: <20230316083443.411936182@linuxfoundation.org>
From:   Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20230316083443.411936182@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: TYAPR01CA0235.jpnprd01.prod.outlook.com
 (2603:1096:404:11e::31) To PH8PR10MB6290.namprd10.prod.outlook.com
 (2603:10b6:510:1c1::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR10MB6290:EE_|PH7PR10MB6177:EE_
X-MS-Office365-Filtering-Correlation-Id: ab5adc87-eccc-4831-beb5-08db2651568e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /I7iGEvf3SKliEJBd1cNpScGzAXujtgy89jK4YUiUgHMXu/j2C8crFhaeztDVxdlgj3msyp38yP2XYlrVnAMsPXAavugKVEo9EKt8ifsqZW3uuhF1d8l1TNZsnaVmMLls+1KdfonNSKIJwbgQfCms/+Zwpxb9iBrr22ss7SIy62Ca4SFNXAH4SO53I3PYyPl3V4xDzA2eZc4yINGUdL3nTySUr8BByBltU1hKfD/Cvk7hkNDrCGqkUR6nTOXU94KEbNqBpGra0Cwj2iDCT5l9zYn3ImzRyrkITdTOe6sL8cJHMZpoHSZxadDNXl7qUCp9bMkNxcA4fhjt9nelnD5LQSIcvA1hxtcP4dwx4KJoNq9kSgC7bdnjfIYQFBxzzh3tLExkdUAeSkg/uWqH4uP4aN0i2T7ksZdIX4HgHi9QxSw2KdLvhxfyED1mazACx8PznOiUVPXUresNh/qLwtoQMka2Ev/kQB00rTYLtYyAacBJkO3YgqpoGSM//yxx1J5LzgAONY0fiBzOKS2ZPukqOlbn2L4sJW/UtxePfjkuORo/D4NWxJul7ee+kY9E0VODBB9ISs5OJgy1NVet6Zfn0c+KzsZSWEP8vgrhsyNox7orI57Xq/78riD0poK4eYlQ7wJX04LgMWCcKkOMsaD1O3QIGoEyt0AVoxNU+dJrVvcNx7NDUfVAme+i0iLYBZPaqgbNs04Q8GSygOteBYV55IMsYxjQfIEng9QsRYmk+o=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR10MB6290.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(396003)(346002)(376002)(136003)(366004)(451199018)(6486002)(53546011)(966005)(6506007)(2906002)(31686004)(30864003)(83380400001)(6666004)(107886003)(26005)(8936002)(41300700001)(5660300002)(7416002)(66946007)(86362001)(66476007)(8676002)(6512007)(31696002)(2616005)(66574015)(66556008)(4326008)(186003)(54906003)(316002)(478600001)(38100700002)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V0g2QS9vTGY2RTZOY0JXbGRteVd2SnhIQis4d0dKdjZxRUVyOURiK05GeWMx?=
 =?utf-8?B?ZVpNc2ZGdzFTUmJsYWgvUHVKQUxtQkQwd3g1TzhqdE5TMHFlOUtjb1VwRG5G?=
 =?utf-8?B?U3FBNDh0eUY5WEN0dHU0NzEvTWwrUDMxeFp6Szg0MFFMYXRyUWN2bSsyWFRQ?=
 =?utf-8?B?OXZEQmlVMlhzbUFJVWl3YWVNbWh4SzRJSFdrQUY3ZGt2Rnl4OHA4cU4wd1FF?=
 =?utf-8?B?L0VORy81WDRjd2F2enVzMFg5MWRPUFZOWUlBYk5aSW1CTWgycE9kRWJWSTdn?=
 =?utf-8?B?US9TYTZ0K1BubEJkclNwL0NQSzlFaXB0S0EycmVndjd3WkppWnQ5blRqTG96?=
 =?utf-8?B?SzhZMTJwMEg0ejRBTlJWQ1pjWDFHL2tzRzJyemgzZTZ1RUp1NkZFdmJCSVkx?=
 =?utf-8?B?ckhTNThPVWhoaVRuK0xxTExiM3ZRQWcraHJCdytscldhNGV0eE9WUkdLY2M4?=
 =?utf-8?B?YldMNUkxaW03b01LNS8zcWtRZjFmYmtsVStOa04zMVZOZHJ6a3BQYW5BVUcr?=
 =?utf-8?B?Vi8yV2RaZEVsdjhsM2l0YUE1R28xYkFDU0xZc2lYd1dEYW5QblpObkJQVnRP?=
 =?utf-8?B?RTgrNEpPdDg4dXVXWk0ybzJ1d1hvb2lvRVprNTl2VDBoWVg1MDN3ZlF4Tk1M?=
 =?utf-8?B?SWZ0dWJCMmhNbWR2UVUzci9PdTJkbWNuTUpyK1ZXVUg4R2xYWDZlVXIrMXJp?=
 =?utf-8?B?czJxZlQvRi9LRis4T3dVZkx0TUhPaUlSanN1UGNUdHZKdVUzaDV0bjk0Ujdw?=
 =?utf-8?B?aGVkVFpUTUpkaFF6YnFURkcwY2dQN3crNUIrOW1SZnNQWkdDeXZBRllWN29q?=
 =?utf-8?B?algvQ0hZYzRiVlptODA4VEY2T2VVdUJ4cDFrWjZ5TUpWWXFacmdDQUJSNjFk?=
 =?utf-8?B?VDdnM2ZFdEpZTjBCWGNvZnVVSzZYdGN2bzFuMWgxNk9nSGtLWnFPSUhuQjE1?=
 =?utf-8?B?RjVtTW53TytXMUxOSysxdDdLT2I3OUt1NGZ3YVN1eEd2YUVScG9oa1pEK0J2?=
 =?utf-8?B?MTdUM3hSemFvbWNrdTdLVTNGVW5UVjJ2QTNXRkhrN1M0UFQ5UCtaWlFURFp4?=
 =?utf-8?B?NXpQVENOSEZGc1M3MEpDczZERVE3cmpzRVlGMlZEcTA1R3pnNndYZmFENVRo?=
 =?utf-8?B?WWZkZ3hrSDM3QUQ0bHhxdFFVL0Z4TURqelpiSHJ2bk43YTdtdGNTZFVMQkx5?=
 =?utf-8?B?SzZjaERJWjIybjgvaDN3Nk9ldnhpOENPOTlRZVFNVnFZbDZhejJ1dk5KNlJo?=
 =?utf-8?B?RFBrTGlYWk50dlFPYmFQbndFNVBNNlVxamJwajlIZXNtMzB2djdUblB5TjNN?=
 =?utf-8?B?M1JFUjFta1hVMDBreGpxODBWK3ZFUmRSbU1FMHkvNGhGWlpUdEJrTEh6RVdk?=
 =?utf-8?B?Z21vWkxYL0s2MGdWcFFnZFhMVFVCajFJMzllREZZVk91T2JyTnFaaVR4dE1N?=
 =?utf-8?B?NDlDUVkzTGZJdmp6M09YaSs5ZFJGYXhOTHJaaWo5UVF5QW1FQWg1UjkxbmpN?=
 =?utf-8?B?NzZTbVYwY240UXhNY1BweE00dThLeElUVk9hRGJGY214dnJvTG4wOWVVanh2?=
 =?utf-8?B?SUdyWGFMbHI2Z1ZHZHBidC9Genc2YWNVMmZFcUlpZnIvcWFQL1hBOWY5cWZq?=
 =?utf-8?B?MjF1UnBpOW9GUGlQcHBrSXhJOHRHWGhZaXlYZ0ZkNEU5UE95ZCtFTTJ3OUV4?=
 =?utf-8?B?cVJpYTNUVURVTm9CVTEyUGhuSEJkM0psamxlWXpmcjc5WkdSa1JPU052aU5a?=
 =?utf-8?B?VkpQNEFhdzc4Yiszek5TOUJWUmw5eTFBWU8vaWIyN2VuRElDcThsQkM2Q1Fu?=
 =?utf-8?B?UitVM09XN292TTRhbkNHVllnYklFazlJN0k3OUJlVHBFQXcvTzRkdklrcWZJ?=
 =?utf-8?B?Ukk5cHhJYzFqaEdLYW5RckswTStzVVJBMFB1em03RFpsNHl5TGtQcHFSczky?=
 =?utf-8?B?Tmh6SGNzeVpxakRpRVdpNHlSTXJLOEs2MmxwUDI2OXNHRk9qS3hmSTVOSmcy?=
 =?utf-8?B?eWduQ1c1WXlkeDNFSWN4N1k5cUoxQ3NJSWxNZ3NqM3ZWVnFZWHUrMGJzaTht?=
 =?utf-8?B?d2lEUnVaRzJ6NC9qWXJxbFNPdUgyc05BUCtNK011TGtwV2dwM3JaMEdOYWtn?=
 =?utf-8?B?cGt6cW5pWmZuMzU4YVF3WVBNYWttTFRsbHBjZ2tVaUM4ZVpYQUJaNFVqQjNE?=
 =?utf-8?Q?RAXAtRbaJqB0DVmnmESzyZ4=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?QlBybjk3czBGdEtaSXhRdThUV1VoVEdIcHZMRzA2UjRGYjJGWEliVkJrTHU1?=
 =?utf-8?B?R0ZsY2VaUm1Wc0ZzNVNaMFBFWmU2ZXl4Zm5oQ1VYUEQxOHMrSXhBeVVBM2tX?=
 =?utf-8?B?UksyWXoxdm14UFo4bTlqQm0zSlhZN1JTR1FnYytjQVJTSU9HNmNreUZFYXpZ?=
 =?utf-8?B?Y1BrbFF4aGpWQkFSWkhHcHVXbnZjNE9tV3RsMTExTW5VZDBFdXVYNUsxYit4?=
 =?utf-8?B?WDZXdkpCUDhnUFl1d3dPN056dUdPQlB4MFgwNWlWS3NzK25PWkdvME9MZ1Uw?=
 =?utf-8?B?eGdKRlljT0R5MDRycVdLQXc4cWxldFlkNnJ2Y1FwdmhKQllzNXlSczRSaU91?=
 =?utf-8?B?TUNaVHNBMjkrdjFMNCtUZW1hMjZZWWE3NXBMRSszUHhGODVMOFh2cXlyWFda?=
 =?utf-8?B?TDMwb1NBb09UNml5V1hlZjMwSFZpcG0vZGZ3YXdtT0ljZ2t5NFV5OXpYQUhE?=
 =?utf-8?B?UVlGQmVCS3VsZHBWS1JaUmEzTTZ4YzlmWTQ3S0dLQUQ2cDNjY3Y0cEZKZzk4?=
 =?utf-8?B?aEZDUUVoY3BqTCthbmlvVHpmMU5Sak9jRDRjbXVVNkNaWkUxSGUwaWhWdnQ3?=
 =?utf-8?B?TEY4TzFUeDJWNWo4YXBrazFWVUZFcE1PZG9haFNvWWtBYXFxbEY1Y1J5UDQw?=
 =?utf-8?B?NzRIUU01M2NCRHF4UHRUV2FjM2wxNTZaUmgwdVVaZTc4MmJyei8ycC9KeUhI?=
 =?utf-8?B?cEZ2RUgzWUtOYmRybDFJUHcyMEwrSWJaTStYS2kzOVhyS1hOVHNIeVJQMkFn?=
 =?utf-8?B?R1AzZk1TVC9OMkEwU3QybnlFV3BwMEhHZE9vaGp4S21QQnYxbDVIUGx3NXVI?=
 =?utf-8?B?OGx0ZTg2emJKamlhSXJCV1U5aU1DUklLN0FYdkZrbGFQa0tjRk04UHZFbTNS?=
 =?utf-8?B?Mm55NFQ3S2g5Q093V3V1YnA1cDRld2RzVlNobnEwWDZZNUlXNzB6OXphUzM1?=
 =?utf-8?B?WnU3ZzA1Z09neUJ6L3lWNUE3anA3emVKbzdLRmRBcGZBUGNFTythdHBaVFZJ?=
 =?utf-8?B?L0kvbUtGVktWK3QzQ283NmtVY3V4THROa2ZxUEtKYWlDWWFEWk9DVkdBM2VK?=
 =?utf-8?B?RTRHRzJldllQckR0dkVld2J0NmhTZjh2ODF4b1pWVFNQZVVGbzQrVDhFQkpx?=
 =?utf-8?B?dUpYSU5ENHh4VHhhT2JYenB4dWdvc0ZWT1RvWTJ1T1ArRXpXeDhQR2dwQU1t?=
 =?utf-8?B?TFFhK2o1akpmU0xyVHBIY1lIR2pPUmNXR3lvQm16MXExZzRqdjdRQ21pYU5D?=
 =?utf-8?B?YlZGcWt1bm1EdTc3Vkk4VUFWTGtMYXhyV1FKSnpWTm5CWm5WSE11SnFjYXRD?=
 =?utf-8?B?ajlucTNSV1ZhSGZXUEhUb0VVd29IeUkwUHptS3o0VW5JV25TOTlDU0R2R3d2?=
 =?utf-8?B?ZFNYUmFLYjhEaUoySTFybzRZbFZtV3ErZkRqYUxnMUJrak9JRy96dEQyaWVE?=
 =?utf-8?B?RjZxdzBTZ2N1S3l3alVIRlgwNDJFMCtoeTFRekFSbEdZMnlRTXV2YWdGZVpy?=
 =?utf-8?B?c2xKQTYzQ21vY3V2VS8vbUJkYjg1RWhxU1V5RjhsTEhCdkxSQlFJQ3dlT1d2?=
 =?utf-8?Q?nuIP7T24EinnupmixXE4+RgkwFqaIa8ngjfOOI8nmdlY7B?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab5adc87-eccc-4831-beb5-08db2651568e
X-MS-Exchange-CrossTenant-AuthSource: PH8PR10MB6290.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2023 19:04:59.2908
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sJQn/Q0vMqqS+uhQJNw8ltK1sKW+3pmkSMciRrehroH4kXB8iQIKA1iLVhkucBBkJRYnjeSC3oEekZ1FKlQQvzpfya/nnpbHazXa4W7lrIJ2x5GcNV/b6SUdJ0XR0+oR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6177
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-16_12,2023-03-16_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0
 mlxlogscore=999 malwarescore=0 mlxscore=0 adultscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303150002 definitions=main-2303160145
X-Proofpoint-GUID: WZz_MbXmgatyYopta-xA5MYroXuDTRX6
X-Proofpoint-ORIG-GUID: WZz_MbXmgatyYopta-xA5MYroXuDTRX6
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On 16/03/23 2:20 pm, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.103 release.
> There are 137 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 

No problems detected on x86_64 and aarch64.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit

> Responses should be made by Sat, 18 Mar 2023 08:33:04 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.103-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
> -------------
> Pseudo-Shortlog of commits:
> 
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>      Linux 5.15.103-rc2
> 
> Nick Desaulniers <ndesaulniers@google.com>
>      Makefile: use -gdwarf-{4|5} for assembler for DEBUG_INFO_DWARF{4|5}
> 
> Alexandru Matei <alexandru.matei@uipath.com>
>      KVM: VMX: Fix crash due to uninitialized current_vmcs
> 
> Vitaly Kuznetsov <vkuznets@redhat.com>
>      KVM: VMX: Introduce vmx_msr_bitmap_l01_changed() helper
> 
> Vitaly Kuznetsov <vkuznets@redhat.com>
>      KVM: nVMX: Don't use Enlightened MSR Bitmap for L3
> 
> Christian Brauner <christian.brauner@ubuntu.com>
>      fs: hold writers when changing mount's idmapping
> 
> Masahiro Yamada <masahiroy@kernel.org>
>      UML: define RUNTIME_DISCARD_EXIT
> 
> Gaosheng Cui <cuigaosheng1@huawei.com>
>      xfs: remove xfs_setattr_time() declaration
> 
> Miaohe Lin <linmiaohe@huawei.com>
>      KVM: fix memoryleak in kvm_init()
> 
> Andres Freund <andres@anarazel.de>
>      tools bpftool: Fix compilation error with new binutils
> 
> Andres Freund <andres@anarazel.de>
>      tools bpf_jit_disasm: Fix compilation error with new binutils
> 
> Andres Freund <andres@anarazel.de>
>      tools perf: Fix compilation error with new binutils
> 
> Andres Freund <andres@anarazel.de>
>      tools include: add dis-asm-compat.h to handle version differences
> 
> Andres Freund <andres@anarazel.de>
>      tools build: Add feature test for init_disassemble_info API changes
> 
> Tom Saeger <tom.saeger@oracle.com>
>      sh: define RUNTIME_DISCARD_EXIT
> 
> Masahiro Yamada <masahiroy@kernel.org>
>      s390: define RUNTIME_DISCARD_EXIT to fix link error with GNU ld < 2.36
> 
> Michael Ellerman <mpe@ellerman.id.au>
>      powerpc/vmlinux.lds: Don't discard .rela* for relocatable builds
> 
> Michael Ellerman <mpe@ellerman.id.au>
>      powerpc/vmlinux.lds: Define RUNTIME_DISCARD_EXIT
> 
> Masahiro Yamada <masahiroy@kernel.org>
>      arch: fix broken BuildID for arm64 and riscv
> 
> Lukas Czerner <lczerner@redhat.com>
>      ext4: block range must be validated before use in ext4_mb_clear_bb()
> 
> Ritesh Harjani <riteshh@linux.ibm.com>
>      ext4: add strict range checks while freeing blocks
> 
> Ritesh Harjani <riteshh@linux.ibm.com>
>      ext4: add ext4_sb_block_valid() refactored out of ext4_inode_block_valid()
> 
> Ritesh Harjani <riteshh@linux.ibm.com>
>      ext4: refactor ext4_free_blocks() to pull out ext4_mb_clear_bb()
> 
> Seth Forshee <sforshee@kernel.org>
>      filelocks: use mount idmapping for setlease permission check
> 
> Li Jun <jun.li@nxp.com>
>      media: rc: gpio-ir-recv: add remove function
> 
> Paul Elder <paul.elder@ideasonboard.com>
>      media: ov5640: Fix analogue gain control
> 
> Masahiro Yamada <masahiroy@kernel.org>
>      scripts: handle BrokenPipeError for python scripts
> 
> Alvaro Karsz <alvaro.karsz@solid-run.com>
>      PCI: Add SolidRun vendor ID
> 
> Nathan Chancellor <nathan@kernel.org>
>      macintosh: windfarm: Use unsigned type for 1-bit bitfields
> 
> Edward Humes <aurxenon@lunos.org>
>      alpha: fix R_ALPHA_LITERAL reloc for large modules
> 
> Rohan McLure <rmclure@linux.ibm.com>
>      powerpc/kcsan: Exclude udelay to prevent recursive instrumentation
> 
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>      powerpc/iommu: fix memory leak with using debugfs_lookup()
> 
> xurui <xurui@kylinos.cn>
>      MIPS: Fix a compilation issue
> 
> Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
>      clk: qcom: mmcc-apq8084: remove spdm clocks
> 
> Christian Brauner <brauner@kernel.org>
>      fs: use consistent setgid checks in is_sxid()
> 
> Christian Brauner <brauner@kernel.org>
>      attr: use consistent sgid stripping checks
> 
> Christian Brauner <brauner@kernel.org>
>      attr: add setattr_should_drop_sgid()
> 
> Christian Brauner <brauner@kernel.org>
>      fs: move should_remove_suid()
> 
> Christian Brauner <brauner@kernel.org>
>      attr: add in_group_or_capable()
> 
> Yang Xu <xuyang2018.jy@fujitsu.com>
>      fs: move S_ISGID stripping into the vfs_*() helpers
> 
> Yang Xu <xuyang2018.jy@fujitsu.com>
>      fs: add mode_strip_sgid() helper
> 
> Dave Chinner <dchinner@redhat.com>
>      xfs: set prealloc flag in xfs_alloc_file_space()
> 
> Dave Chinner <dchinner@redhat.com>
>      xfs: fallocate() should call file_modified()
> 
> Dave Chinner <dchinner@redhat.com>
>      xfs: remove XFS_PREALLOC_SYNC
> 
> Darrick J. Wong <djwong@kernel.org>
>      xfs: use setattr_copy to set vfs inode attributes
> 
> Morten Linderud <morten@linderud.pw>
>      tpm/eventlog: Don't abort tpm_read_log on faulty ACPI address
> 
> David Disseldorp <ddiss@suse.de>
>      watch_queue: fix IOC_WATCH_QUEUE_SET_SIZE alloc error paths
> 
> Hans de Goede <hdegoede@redhat.com>
>      staging: rtl8723bs: Fix key-store index handling
> 
> Hannes Braun <hannesbraun@mail.de>
>      staging: rtl8723bs: fix placement of braces
> 
> Jagath Jog J <jagathjog1996@gmail.com>
>      Staging: rtl8723bs: Placing opening { braces in previous line
> 
> Michael Straube <straube.linux@gmail.com>
>      staging: rtl8723bs: clean up comparsions to NULL
> 
> Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>
>      iommu/amd: Add a length limitation for the ivrs_acpihid command-line parameter
> 
> Kim Phillips <kim.phillips@amd.com>
>      iommu/amd: Fix ill-formed ivrs_ioapic, ivrs_hpet and ivrs_acpihid options
> 
> Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
>      iommu/amd: Add PCI segment support for ivrs_[ioapic/hpet/acpihid] commands
> 
> Christoph Hellwig <hch@lst.de>
>      nbd: use the correct block_device in nbd_bdev_reset
> 
> Johan Hovold <johan+linaro@kernel.org>
>      irqdomain: Fix mapping-creation race
> 
> Jan Kara <jack@suse.cz>
>      ext4: Fix deadlock during directory rename
> 
> Conor Dooley <conor.dooley@microchip.com>
>      RISC-V: Don't check text_mutex during stop_machine
> 
> Heiko Carstens <hca@linux.ibm.com>
>      s390/ftrace: remove dead code
> 
> Alexandre Ghiti <alexghiti@rivosinc.com>
>      riscv: Use READ_ONCE_NOCHECK in imprecise unwinding stack mode
> 
> Eric Dumazet <edumazet@google.com>
>      af_unix: fix struct pid leaks in OOB support
> 
> Kuniyuki Iwashima <kuniyu@amazon.co.jp>
>      af_unix: Remove unnecessary brackets around CONFIG_AF_UNIX_OOB.
> 
> Vladimir Oltean <vladimir.oltean@nxp.com>
>      net: dsa: mt7530: permit port 5 to work without port 6 on MT7621 SoC
> 
> Benjamin Coddington <bcodding@redhat.com>
>      SUNRPC: Fix a server shutdown leak
> 
> Suman Ghosh <sumang@marvell.com>
>      octeontx2-af: Unlock contexts in the queue context cache in case of fault detection
> 
> D. Wythe <alibuda@linux.alibaba.com>
>      net/smc: fix fallback failed while sendmsg with fastopen
> 
> Randy Dunlap <rdunlap@infradead.org>
>      platform: x86: MLX_PLATFORM: select REGMAP instead of depending on it
> 
> Eric Dumazet <edumazet@google.com>
>      netfilter: conntrack: adopt safer max chain length
> 
> Chandrakanth Patil <chandrakanth.patil@broadcom.com>
>      scsi: megaraid_sas: Update max supported LD IDs to 240
> 
> Daniel Golle <daniel@makrotopia.org>
>      net: ethernet: mtk_eth_soc: fix RX data corruption issue
> 
> Heiner Kallweit <hkallweit1@gmail.com>
>      net: phy: smsc: fix link up detection in forced irq mode
> 
> Lukas Wunner <lukas@wunner.de>
>      net: phy: smsc: Cache interrupt mask
> 
> Lorenz Bauer <lorenz.bauer@isovalent.com>
>      btf: fix resolving BTF_KIND_VAR after ARRAY, STRUCT, UNION, PTR
> 
> Florian Westphal <fw@strlen.de>
>      netfilter: tproxy: fix deadlock due to missing BH disable
> 
> Ivan Delalande <colona@arista.com>
>      netfilter: ctnetlink: revert to dumping mark regardless of event type
> 
> Michael Chan <michael.chan@broadcom.com>
>      bnxt_en: Avoid order-5 memory allocation for TPA data
> 
> Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
>      net: phylib: get rid of unnecessary locking
> 
> Rongguang Wei <weirongguang@kylinos.cn>
>      net: stmmac: add to set device wake up flag when stmmac init phy
> 
> Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
>      drm/msm/dpu: fix len of sc7180 ctl blocks
> 
> Liu Jian <liujian56@huawei.com>
>      bpf, sockmap: Fix an infinite loop error when len is 0 in tcp_bpf_recvmsg_parser()
> 
> Petr Oros <poros@redhat.com>
>      ice: copy last block omitted in ice_get_module_eeprom()
> 
> Shigeru Yoshida <syoshida@redhat.com>
>      net: caif: Fix use-after-free in cfusbl_device_notify()
> 
> Yuiko Oshino <yuiko.oshino@microchip.com>
>      net: lan78xx: fix accessing the LAN7800's internal phy specific registers from the MAC driver
> 
> Changbin Du <changbin.du@huawei.com>
>      perf stat: Fix counting when initial delay configured
> 
> Hangbin Liu <liuhangbin@gmail.com>
>      selftests: nft_nat: ensuring the listening side is up before starting the client
> 
> Eric Dumazet <edumazet@google.com>
>      ila: do not generate empty messages in ila_xlat_nl_cmd_get_mapping()
> 
> Vladimir Oltean <vladimir.oltean@nxp.com>
>      powerpc: dts: t1040rdb: fix compatible string for Rev A boards
> 
> Kang Chen <void0red@gmail.com>
>      nfc: fdp: add null check of devm_kmalloc_array in fdp_nci_i2c_read_device_properties
> 
> Rafał Miłecki <rafal@milecki.pl>
>      bgmac: fix *initial* chip reset to support BCM5358
> 
> Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
>      drm/msm/a5xx: fix context faults during ring switch
> 
> Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
>      drm/msm/a5xx: fix the emptyness check in the preempt code
> 
> Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
>      drm/msm/a5xx: fix highest bank bit for a530
> 
> Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
>      drm/msm/a5xx: fix setting of the CP_PREEMPT_ENABLE_LOCAL register
> 
> Rob Clark <robdclark@chromium.org>
>      drm/msm: Fix potential invalid ptr free
> 
> Jiri Slaby (SUSE) <jirislaby@kernel.org>
>      drm/nouveau/kms/nv50: fix nv50_wndw_new_ prototype
> 
> Ben Skeggs <bskeggs@redhat.com>
>      drm/nouveau/kms/nv50-: remove unused functions
> 
> Jan Kara <jack@suse.cz>
>      ext4: Fix possible corruption when moving a directory
> 
> Matthias Kaehlcke <mka@chromium.org>
>      regulator: core: Use ktime_get_boottime() to determine how long a regulator was off
> 
> Christian Kohlschütter <christian@kohlschutter.com>
>      regulator: core: Fix off-on-delay-us for always-on/boot-on regulators
> 
> Mark Brown <broonie@kernel.org>
>      regulator: Flag uncontrollable regulators as always_on
> 
> Bart Van Assche <bvanassche@acm.org>
>      scsi: core: Remove the /proc/scsi/${proc_name} directory earlier
> 
> Liao Chang <liaochang1@huawei.com>
>      riscv: Add header include guards to insn.h
> 
> Mattias Nissler <mnissler@rivosinc.com>
>      riscv: Avoid enabling interrupts in die()
> 
> Palmer Dabbelt <palmer@rivosinc.com>
>      RISC-V: Avoid dereferening NULL regs in die()
> 
> Pierre Gondois <pierre.gondois@arm.com>
>      arm64: efi: Make efi_rt_lock a raw_spinlock
> 
> Jens Axboe <axboe@kernel.dk>
>      brd: mark as nowait compatible
> 
> Luis Chamberlain <mcgrof@kernel.org>
>      block/brd: add error handling support for add_disk()
> 
> Jacob Pan <jacob.jun.pan@linux.intel.com>
>      iommu/vt-d: Fix PASID directory pointer coherency
> 
> Johan Hovold <johan+linaro@kernel.org>
>      irqdomain: Refactor __irq_domain_alloc_irqs()
> 
> Corey Minyard <cminyard@mvista.com>
>      ipmi:ssif: Add a timer between request retries
> 
> Corey Minyard <cminyard@mvista.com>
>      ipmi:ssif: Increase the message retry time
> 
> Jaegeuk Kim <jaegeuk@kernel.org>
>      f2fs: retry to update the inode page given data corruption
> 
> Jaegeuk Kim <jaegeuk@kernel.org>
>      f2fs: do not bother checkpoint by f2fs_get_node_info
> 
> Jaegeuk Kim <jaegeuk@kernel.org>
>      f2fs: avoid down_write on nat_tree_lock during checkpoint
> 
> Jan Kara <jack@suse.cz>
>      udf: Fix off-by-one error when discarding preallocation
> 
> Alexander Aring <aahringo@redhat.com>
>      fs: dlm: start midcomms before scand
> 
> Alexander Aring <aahringo@redhat.com>
>      fs: dlm: add midcomms init/start functions
> 
> Alexander Aring <aahringo@redhat.com>
>      fs: dlm: fix log of lowcomms vs midcomms
> 
> Sean Christopherson <seanjc@google.com>
>      KVM: SVM: Process ICR on AVIC IPI delivery failure due to invalid target
> 
> Sean Christopherson <seanjc@google.com>
>      KVM: SVM: Don't rewrite guest ICR on AVIC IPI virtualization failure
> 
> Sean Christopherson <seanjc@google.com>
>      KVM: Register /dev/kvm as the _very_ last thing during initialization
> 
> Vitaly Kuznetsov <vkuznets@redhat.com>
>      KVM: Pre-allocate cpumasks for kvm_make_all_cpus_request_except()
> 
> Vitaly Kuznetsov <vkuznets@redhat.com>
>      KVM: Optimize kvm_make_vcpus_request_mask() a bit
> 
> Fedor Pchelkin <pchelkin@ispras.ru>
>      nfc: change order inside nfc_se_io error path
> 
> Zhihao Cheng <chengzhihao1@huawei.com>
>      ext4: zero i_disksize when initializing the bootloader inode
> 
> Ye Bin <yebin10@huawei.com>
>      ext4: fix WARNING in ext4_update_inline_data
> 
> Ye Bin <yebin10@huawei.com>
>      ext4: move where set the MAY_INLINE_DATA flag is set
> 
> Darrick J. Wong <djwong@kernel.org>
>      ext4: fix another off-by-one fsmap error on 1k block filesystems
> 
> Eric Whitney <enwlinux@gmail.com>
>      ext4: fix RENAME_WHITEOUT handling for inline directories
> 
> Eric Biggers <ebiggers@google.com>
>      ext4: fix cgroup writeback accounting with fs-layer encryption
> 
> Hans de Goede <hdegoede@redhat.com>
>      staging: rtl8723bs: Pass correct parameters to cfg80211_get_bss()
> 
> Harry Wentland <harry.wentland@amd.com>
>      drm/connector: print max_requested_bpc in state debugfs
> 
> Alex Deucher <alexander.deucher@amd.com>
>      drm/amdgpu: fix error checking in amdgpu_read_mm_registers for soc15
> 
> Andrew Cooper <andrew.cooper3@citrix.com>
>      x86/CPU/AMD: Disable XSAVES on AMD family 0x17
> 
> Tobias Klauser <tklauser@distanz.ch>
>      fork: allow CLONE_NEWTIME in clone3 flags
> 
> Namhyung Kim <namhyung@kernel.org>
>      perf inject: Fix --buildid-all not to eat up MMAP2
> 
> Johannes Thumshirn <johannes.thumshirn@wdc.com>
>      btrfs: fix percent calculation for bg reclaim message
> 
> Theodore Ts'o <tytso@mit.edu>
>      fs: prevent out-of-bounds array speculation when closing a file descriptor
> 
> 
> -------------
> 
> Diffstat:
> 
>   Documentation/admin-guide/kernel-parameters.txt    |  51 ++-
>   Documentation/trace/ftrace.rst                     |   2 +-
>   Makefile                                           |   5 +-
>   arch/alpha/kernel/module.c                         |   4 +-
>   arch/arm64/include/asm/efi.h                       |   6 +-
>   arch/arm64/kernel/efi.c                            |   2 +-
>   arch/mips/include/asm/mach-rc32434/pci.h           |   2 +-
>   arch/powerpc/boot/dts/fsl/t1040rdb-rev-a.dts       |   1 -
>   arch/powerpc/kernel/iommu.c                        |   4 +-
>   arch/powerpc/kernel/time.c                         |   4 +-
>   arch/powerpc/kernel/vmlinux.lds.S                  |   6 +-
>   arch/riscv/include/asm/ftrace.h                    |   2 +-
>   arch/riscv/include/asm/parse_asm.h                 |   5 +
>   arch/riscv/include/asm/patch.h                     |   2 +
>   arch/riscv/kernel/ftrace.c                         |  14 +-
>   arch/riscv/kernel/patch.c                          |  28 +-
>   arch/riscv/kernel/stacktrace.c                     |   2 +-
>   arch/riscv/kernel/traps.c                          |  14 +-
>   arch/s390/kernel/ftrace.c                          |  86 +----
>   arch/s390/kernel/vmlinux.lds.S                     |   2 +
>   arch/sh/kernel/vmlinux.lds.S                       |   1 +
>   arch/um/kernel/vmlinux.lds.S                       |   2 +-
>   arch/x86/kernel/cpu/amd.c                          |   9 +
>   arch/x86/kvm/lapic.c                               |   1 +
>   arch/x86/kvm/svm/avic.c                            |  28 +-
>   arch/x86/kvm/vmx/evmcs.h                           |  11 -
>   arch/x86/kvm/vmx/vmx.c                             |  44 ++-
>   drivers/block/brd.c                                |  10 +-
>   drivers/block/nbd.c                                |  14 +-
>   drivers/char/ipmi/ipmi_ssif.c                      |  34 +-
>   drivers/char/tpm/eventlog/acpi.c                   |   6 +-
>   drivers/clk/qcom/mmcc-apq8084.c                    | 271 ----------------
>   drivers/gpu/drm/amd/amdgpu/soc15.c                 |   5 +-
>   drivers/gpu/drm/drm_atomic.c                       |   1 +
>   drivers/gpu/drm/msm/adreno/a5xx_gpu.c              |   6 +-
>   drivers/gpu/drm/msm/adreno/a5xx_preempt.c          |   4 +-
>   drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c     |   6 +-
>   drivers/gpu/drm/msm/msm_gem_submit.c               |   5 +-
>   drivers/gpu/drm/nouveau/dispnv50/disp.c            |  16 -
>   drivers/gpu/drm/nouveau/dispnv50/wndw.c            |  12 -
>   drivers/gpu/drm/nouveau/dispnv50/wndw.h            |   7 +-
>   drivers/iommu/amd/init.c                           | 105 ++++--
>   drivers/iommu/intel/pasid.c                        |   7 +
>   drivers/macintosh/windfarm_lm75_sensor.c           |   4 +-
>   drivers/macintosh/windfarm_smu_sensors.c           |   4 +-
>   drivers/media/i2c/ov5640.c                         |   2 +-
>   drivers/media/rc/gpio-ir-recv.c                    |  18 ++
>   drivers/net/dsa/mt7530.c                           |  35 +-
>   drivers/net/ethernet/broadcom/bgmac.c              |   8 +-
>   drivers/net/ethernet/broadcom/bgmac.h              |   2 +
>   drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  23 +-
>   drivers/net/ethernet/intel/ice/ice_ethtool.c       |   6 +-
>   drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |   5 +
>   .../ethernet/marvell/octeontx2/af/rvu_debugfs.c    |   7 +-
>   .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    |  16 +-
>   .../net/ethernet/marvell/octeontx2/af/rvu_npa.c    |  58 +++-
>   .../net/ethernet/marvell/octeontx2/af/rvu_reg.h    |   3 +
>   drivers/net/ethernet/mediatek/mtk_eth_soc.c        |   3 +-
>   drivers/net/ethernet/mediatek/mtk_eth_soc.h        |   1 +
>   drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   1 +
>   drivers/net/phy/microchip.c                        |  32 ++
>   drivers/net/phy/phy_device.c                       |   8 +-
>   drivers/net/phy/smsc.c                             |  20 +-
>   drivers/net/usb/lan78xx.c                          |  27 +-
>   drivers/nfc/fdp/i2c.c                              |   4 +
>   drivers/platform/x86/Kconfig                       |   3 +-
>   drivers/regulator/core.c                           |  27 +-
>   drivers/scsi/hosts.c                               |   2 +
>   drivers/scsi/megaraid/megaraid_sas.h               |   2 +
>   drivers/scsi/megaraid/megaraid_sas_fp.c            |   2 +-
>   drivers/staging/rtl8723bs/core/rtw_ap.c            |  20 +-
>   drivers/staging/rtl8723bs/core/rtw_cmd.c           |  96 +++---
>   drivers/staging/rtl8723bs/core/rtw_ioctl_set.c     |   4 +-
>   drivers/staging/rtl8723bs/core/rtw_mlme.c          |   6 +-
>   drivers/staging/rtl8723bs/core/rtw_mlme_ext.c      |  56 ++--
>   drivers/staging/rtl8723bs/core/rtw_security.c      |   6 +-
>   drivers/staging/rtl8723bs/include/rtw_security.h   |   8 +-
>   drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c  | 355 +++++++--------------
>   drivers/staging/rtl8723bs/os_dep/ioctl_linux.c     |  51 +--
>   drivers/staging/rtl8723bs/os_dep/os_intfs.c        |   4 +-
>   fs/attr.c                                          |  72 ++++-
>   fs/btrfs/block-group.c                             |   3 +-
>   fs/dlm/lockspace.c                                 |  21 +-
>   fs/dlm/lowcomms.c                                  |  16 +-
>   fs/dlm/lowcomms.h                                  |   1 +
>   fs/dlm/main.c                                      |   7 +-
>   fs/dlm/midcomms.c                                  |  17 +-
>   fs/dlm/midcomms.h                                  |   3 +
>   fs/ext4/block_validity.c                           |  26 +-
>   fs/ext4/ext4.h                                     |   3 +
>   fs/ext4/fsmap.c                                    |   2 +
>   fs/ext4/inline.c                                   |   1 -
>   fs/ext4/inode.c                                    |   7 +-
>   fs/ext4/ioctl.c                                    |   1 +
>   fs/ext4/mballoc.c                                  | 205 +++++++-----
>   fs/ext4/namei.c                                    |  36 ++-
>   fs/ext4/page-io.c                                  |  11 +-
>   fs/ext4/xattr.c                                    |   3 +
>   fs/f2fs/checkpoint.c                               |   2 +-
>   fs/f2fs/compress.c                                 |   2 +-
>   fs/f2fs/data.c                                     |   8 +-
>   fs/f2fs/f2fs.h                                     |   2 +-
>   fs/f2fs/file.c                                     |   2 +-
>   fs/f2fs/gc.c                                       |   6 +-
>   fs/f2fs/inline.c                                   |   4 +-
>   fs/f2fs/inode.c                                    |  14 +-
>   fs/f2fs/node.c                                     |  23 +-
>   fs/f2fs/recovery.c                                 |   2 +-
>   fs/f2fs/segment.c                                  |   2 +-
>   fs/file.c                                          |   1 +
>   fs/fuse/file.c                                     |   2 +-
>   fs/inode.c                                         |  90 +++---
>   fs/internal.h                                      |  10 +-
>   fs/locks.c                                         |   3 +-
>   fs/namei.c                                         |  82 ++++-
>   fs/namespace.c                                     |  29 +-
>   fs/ocfs2/file.c                                    |   4 +-
>   fs/ocfs2/namei.c                                   |   1 +
>   fs/open.c                                          |   8 +-
>   fs/udf/inode.c                                     |   2 +-
>   fs/xfs/xfs_bmap_util.c                             |   9 +-
>   fs/xfs/xfs_file.c                                  |  24 +-
>   fs/xfs/xfs_iops.c                                  |  56 +---
>   fs/xfs/xfs_iops.h                                  |   1 -
>   fs/xfs/xfs_pnfs.c                                  |   9 +-
>   include/asm-generic/vmlinux.lds.h                  |   5 +
>   include/linux/fs.h                                 |   6 +-
>   include/linux/pci_ids.h                            |   2 +
>   include/net/netfilter/nf_tproxy.h                  |   7 +
>   kernel/bpf/btf.c                                   |   1 +
>   kernel/fork.c                                      |   2 +-
>   kernel/irq/irqdomain.c                             | 152 +++++----
>   kernel/watch_queue.c                               |   1 +
>   net/caif/caif_usb.c                                |   3 +
>   net/ipv4/netfilter/nf_tproxy_ipv4.c                |   2 +-
>   net/ipv4/tcp_bpf.c                                 |   6 +
>   net/ipv4/udp_bpf.c                                 |   3 +
>   net/ipv6/ila/ila_xlat.c                            |   1 +
>   net/ipv6/netfilter/nf_tproxy_ipv6.c                |   2 +-
>   net/netfilter/nf_conntrack_core.c                  |   4 +-
>   net/netfilter/nf_conntrack_netlink.c               |  14 +-
>   net/nfc/netlink.c                                  |   2 +-
>   net/smc/af_smc.c                                   |  13 +-
>   net/sunrpc/svc.c                                   |   6 +-
>   net/unix/af_unix.c                                 |  16 +-
>   net/unix/unix_bpf.c                                |   3 +
>   scripts/checkkconfigsymbols.py                     |  13 +-
>   scripts/clang-tools/run-clang-tools.py             |  21 +-
>   scripts/diffconfig                                 |  16 +-
>   tools/bpf/Makefile                                 |   5 +-
>   tools/bpf/bpf_jit_disasm.c                         |   5 +-
>   tools/bpf/bpftool/Makefile                         |   5 +-
>   tools/bpf/bpftool/jit_disasm.c                     |  42 ++-
>   tools/build/Makefile.feature                       |   1 +
>   tools/build/feature/Makefile                       |   4 +
>   tools/build/feature/test-all.c                     |   4 +
>   .../build/feature/test-disassembler-init-styled.c  |  13 +
>   tools/include/tools/dis-asm-compat.h               |  55 ++++
>   tools/perf/Makefile.config                         |   8 +
>   tools/perf/builtin-inject.c                        |   1 +
>   tools/perf/builtin-stat.c                          |  15 +-
>   tools/perf/util/annotate.c                         |   7 +-
>   tools/perf/util/stat.c                             |   6 +-
>   tools/perf/util/stat.h                             |   1 -
>   tools/perf/util/target.h                           |  12 +
>   tools/testing/selftests/netfilter/nft_nat.sh       |   2 +
>   virt/kvm/kvm_main.c                                | 145 ++++++---
>   167 files changed, 1780 insertions(+), 1461 deletions(-)
> 
> 
