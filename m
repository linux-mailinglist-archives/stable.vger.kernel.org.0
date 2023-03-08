Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 764AB6B008B
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 09:11:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229468AbjCHILF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Mar 2023 03:11:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjCHILD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Mar 2023 03:11:03 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDA17474E3;
        Wed,  8 Mar 2023 00:11:02 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32888L4Z029220;
        Wed, 8 Mar 2023 08:10:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : from : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=Poyxy8CD2DCZjaZs2KsTEhzPtR1WAlMX9n3J+0QtfXU=;
 b=btmyJ0m7ZHiXNBmrvjdRA8WKc5G/VCeXLYm2XZtlj9UeoD1P8e6ZZI7G/M7sJFUwezD4
 kb6QGGR2ZfriHpqFEpxT9mmviEzHRTa2nZcCn9hpsyPMaTiB5snxvTBmgYPWP37Oebod
 muT32r0E0JVjfcfuoAQnzW1snyykBRc0fsqPqlrr4LlAoOX5d9xlQd5hUKLNKHU65WPL
 LEOQAVG1KFnu6ftJqqYjTcyVNiSdVGx6e6e9Wvfq6OIDjvCmu07upBv3ZY1Nryj5Xr+I
 TQ9rr0vgypujzg7mwDrtNEJct1pN2PmpYepo6N9ePcUWpBtG9dom8rtyCkrd5+98DDqr eQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p415hyjme-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Mar 2023 08:10:53 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 3286g4U8026601;
        Wed, 8 Mar 2023 08:10:52 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3p6g9tc9nk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Mar 2023 08:10:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WmHN6rsrI0K59Kh6CFTxRyPtmZ9VemBI0RrO86FTOSPdbcsXmmfr6avWIiv/nNJcmJ1Spe9mJMOTCzVtDh1F5TLN1OvOnUMk6Hb5UhPbee3UYUTHPbHqxraHVS7if0VJki+d+cian7XhSLJTFWPniGiTcSodOHjZm0A3KFGtrmKy7534AHY9x5Y0dUI10gEg/REeUv5GplA5Ft0CxBI1HkJblcHxFQ2QpPkDOnQGk1t/8D8TcpyEbSl7ZN0wDhe4Go6+HEBomc6DdEhopEPR6sT9JNcFVUVpOBfvOxV6F/ysBbse7cAo5xet/bYXgZQfRUzT6e6Js3KPSfyzlJsXYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Poyxy8CD2DCZjaZs2KsTEhzPtR1WAlMX9n3J+0QtfXU=;
 b=nTVvTFwgFVQkAUWA12qi+oNBrivnwudeO72WQhjuPW4FVYp49CBuIHRYcWBaAjcCAqrXj2UtytBuDNz4i2H4NSmiqLUh42SEIiwD7XJbqJ7gBoRbk4sBXu1ADJH1sK31KJdCgBQw9zj0qURNfhF/fRiYk39F9y8ka2Ko0GzCSGCxeeCulJ3eNdkL1HNZhsGEF+RvyqEHy2A6TaueGl1wJJjIi5dCIxJbV7CNWCnqU+PYoHlU7ZzwM9ldMWvazvuJFUdEnao1DPOdbHn+9jWaWluTSbePRFrpabNBMHNSQjIIi0OW2EOsLSV8KPaUV3t1aMFt2+kWnNdUfMZGVoU90w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Poyxy8CD2DCZjaZs2KsTEhzPtR1WAlMX9n3J+0QtfXU=;
 b=oQgC0dTd4QJ3KnTomdaIrzcyotTXiAhPMbG2AtwGKXg5au/cjNSK8E9Ql/QobwdNWQzL3r/zit8wh+c7qY+ah9DIIOZgmdYmaEUsvLkd3PwDVTqOG0XC4Q8uKeLLD0nL+OkzpSUwzq9cv1E++xjy26ID0n+8qCbKcIXcBtcGoq4=
Received: from PH0PR10MB5433.namprd10.prod.outlook.com (2603:10b6:510:e0::9)
 by PH0PR10MB4599.namprd10.prod.outlook.com (2603:10b6:510:39::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.29; Wed, 8 Mar
 2023 08:10:49 +0000
Received: from PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::a0c1:677d:5394:bf43]) by PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::a0c1:677d:5394:bf43%6]) with mapi id 15.20.6156.029; Wed, 8 Mar 2023
 08:10:49 +0000
Message-ID: <62fda799-7418-eeb9-4702-2fedc78c8e45@oracle.com>
Date:   Wed, 8 Mar 2023 09:10:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH] docs: add backporting and conflict resolution document
Content-Language: en-US
From:   Vegard Nossum <vegard.nossum@oracle.com>
To:     Bagas Sanjaya <bagasdotme@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, backports@vger.kernel.org,
        Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>
References: <20230303162553.17212-1-vegard.nossum@oracle.com>
 <ZAQUkbxQxCanh+9c@debian.me>
 <e70bf38e-af6a-dc63-3249-adbf168a1233@oracle.com>
In-Reply-To: <e70bf38e-af6a-dc63-3249-adbf168a1233@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PR3P189CA0073.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:102:b4::18) To PH0PR10MB5433.namprd10.prod.outlook.com
 (2603:10b6:510:e0::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5433:EE_|PH0PR10MB4599:EE_
X-MS-Office365-Filtering-Correlation-Id: 88b62718-3e31-4ec8-505b-08db1faca09d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 05kBKGDYbdQLH3/WM9kmUzf3kbnI0XRWAwF8VrMEUHhvFNGDkiN6zRTpvgGts6Y3wyUq1UAEJKyuot7Gn2Lvx6gqxLyI0YWjYy5xdRx0jXmHjebK6epH1nD7weJIX7Kj1zu6QI19426P8e4aeHsdT+F3a1UfNpk/xVvsAEeF9Mz/W+dps4sN0JOPCtBdO4ap3HqlPuU7wygycAStoGMxKY0aRImt+Q/luFZ20hmd2pAQxjoZbdLkkT/uVcdu9wfbRSm4qqODL5/FnaSFFkfN+S7rEdA9eoZooZ+Oq/AuH7pgX2fYrEcfvQyNsNcWqL7HegO27JEadhAVUQnJcMVb8zFYqPLl+gjDgpHlG+yh/zZ/rWGqwLDpiFl8v/QGETShYaYyc+XgIzk5fz0yG8kgmjn1BJX5ljSu9ht9oVeuHb3ASBPC/2zz2eni2yUHOlSNuAyBv9vMPA60loS/Ace24VXHXROBsvl0xn4Yq37JUDppZ+o+vdeWpF8kuQYxZN00CI2hVqDEQ6Zz62WwlO3JMu7ZqBJfln1ViGB1nS7gM3BcXbGmIPDt2rqvjaRCMgz7GmZInQgiYeQ3ZpQ2eR6JGm2EX0WVCP+yaptfvoZVSMIXjNBVDwwajQn6pwLRpqnugEPWChuc6ro+F3v1LYo9zvKKw4yqzoWbpxliUoQvg+eQizs0VRoogAkFcDVn0OVmztSkTyJ8QNTu0lzpuN8Q9R3Dj733U4sHssdZc36mWhk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5433.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(346002)(376002)(396003)(366004)(39860400002)(451199018)(5660300002)(478600001)(86362001)(31696002)(186003)(6512007)(26005)(36756003)(4744005)(6506007)(2906002)(2616005)(53546011)(6486002)(44832011)(31686004)(66476007)(66556008)(66946007)(8676002)(4326008)(38100700002)(6666004)(8936002)(316002)(41300700001)(110136005)(54906003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dlpmeWN2YXMyalg3aXU5OXpKUldPRkcwRWpxTERCMlNhMHdicWlabzI5Nmda?=
 =?utf-8?B?a2NKam1Ocit6UGd0LzNweWdEYmRscGxrMURVdzNSZ2ZxYkd1K0hwL3lkY0NE?=
 =?utf-8?B?aVNlRXlDOHdkd1hJN1VhZ0ppZ21yb3VoTEVFUy9hdWtwM2hxQm9EZHk5WHlv?=
 =?utf-8?B?dlB5MnhDY3BQalB2RXJkaHB6R3BQRTFGalp3ZEF5L09xM1Z6QWpEL2V2dFdM?=
 =?utf-8?B?b1BaWEx4RGJmRlJEVTdSY3ZiOVJZdExOUG9OMXdHSmFCMGhjcHM5OHhjdlRC?=
 =?utf-8?B?eTgyQWZyVDVOMzAvT3cydy93RHY4a0JxSzVUMFh5LzJEblR2cS9BQUQxaTFT?=
 =?utf-8?B?RE5lYm83TmVaUksrWkt0TWdHYUtNVG0xUktKaG9XRTYyR2Vndkp3YUFvZVNa?=
 =?utf-8?B?UFdBZkFmV2xYMmovR2h5N0wvSWVoWGdYZGNDak5JSFZJL2lnQTE4ZUc5Wmh2?=
 =?utf-8?B?bHNIOVFVTFBCQzF4b0lHRXJ4WkMzSGt1dW9vdmhKVncrU09mNzJURExKQldi?=
 =?utf-8?B?aVUxQzI3VHo1OFIycnYxaVY5dVljUmJyalpWSmNkamVOcXdIdVkxM1JhM3NY?=
 =?utf-8?B?QnRkQmtrZU1ZZGdpTDgwMERhc2FCZStkZTVLWFQ5WERvWkFKTmlLOHdGaitP?=
 =?utf-8?B?NXE4bFNhcENaQklHSWlQZXdMaTJIK3ZLVGtDN09pUTY3K1JSN1VPZ3ZkTlhh?=
 =?utf-8?B?Z29lRXEyODdoMlp5Q1paZTV5emJjNG15VXZTa1V3b1JlSmgzcjBHcGVGalVp?=
 =?utf-8?B?TjZDSEdNaDFUN1FmM2ZrcVZId09pU2Q4cGFmYjF5OHFyQ012MXAxNUdWQzI2?=
 =?utf-8?B?N05yQm9sZ05ZRVhXSTd1VFZmS2M1c2drMDk3NTVDR0dhdU9GSTljWjBQRHB1?=
 =?utf-8?B?ZUU4RjNsakxNSlBrcGVGSklTd0dsME13bE9tUzFWZjkzdThobGIxdHZLbHA2?=
 =?utf-8?B?VHFxK3NYN0hLZ2tmVHphT0RVYytKVzJWNkhwcXRsTzFFSU5qdTUvTmxtMXlC?=
 =?utf-8?B?MXFhbjhRYzhHYzdRZDJ3KzBiZXFyNlNOUnBVVkU1TTdZYlBCTEg1dm4vZnIr?=
 =?utf-8?B?SDNVOU9ubDVWdlFMQ0pLV29MRGdPaExtMHpGUEI2UWJ5UlFmUUg3OHdxUEdV?=
 =?utf-8?B?WERPcTJWMnNGMVpRTDNXS1daY1E3VzcvR2NLTGRBMllJaEtwK1R2YXoxRTVx?=
 =?utf-8?B?UW9KcWd1dllERnJEeVU0bzlCQ2tDRGVtY2pCNVBjR2kvbWFjeUtaMldDbXpD?=
 =?utf-8?B?SlU5Smd5M3lIV0JZNERnZHpkOTVSYm1UVGFqSTZvQU9hQmZLTXZsbndLYy9M?=
 =?utf-8?B?NGpKZVVDZ0JwODBEaHo3VU5HTjdkQlBLd2hjdWlXNXJPT3FxSkpiV0tCNHpy?=
 =?utf-8?B?UWxiL3dRMGhTRkhlbFpwbW9YMG55Uzh3U2ZHWitYemt2WCtyN1dPMFZsbFhM?=
 =?utf-8?B?blVYb0Y5Q3RIS2hkMXBQaSswbTRnN2VXdzZuUEN5OFlHbDd6RkxodEc1QU96?=
 =?utf-8?B?Q1B1RGZMTUFBVmswRnNkTEZUUnV0T09mYkEyd0tWQThvRHRNcXJTZ0YwVU1n?=
 =?utf-8?B?c3NiRDN2OURSSHZlTkpCNVZndnRhWk5uRjY0VkloN1RzQjEyR2FGc3NFaVEz?=
 =?utf-8?B?QzBJdnFBUGoxaTJQa0pSUWdmMndObUNhNnZJbm14QkUrekpVd3dxRVNzK3lz?=
 =?utf-8?B?U2RtR3MxWGpSSlBENHZlSWE0YnBZdlg1UlZsblNIdTBIUWhwUGZ3em5qNSs0?=
 =?utf-8?B?d01iTktaOG5lNkhMcmIzOWlFR3hVaXRzOWZDWXlsN0llVEJWTDQxV1laSWI3?=
 =?utf-8?B?UGxDUzhvZU16b1h2SE9LQXdZQUovNVZvTVpyV3JyZjdhUGdrYjJDMktKYWdv?=
 =?utf-8?B?MEkwOFFYUHgzdWtCZnRZUWJTbGRPOUtZZ1RVWjVZSWY5UkszczJsUm01YUkr?=
 =?utf-8?B?Vm9QdEQyNGZnbmxRTEJRRUs3ckFyUk9oSzJFTFZVSVdRQzUwaUk2dHZsM0NT?=
 =?utf-8?B?N3ExRUlJbnVkWXhudXh4RVcrbHp3Y1BRR0hDMDM1NXpueXNsdTdyaVJjNkc1?=
 =?utf-8?B?ZlhLOVhpbnVpbTNkc0cyQjVMejFvaDFKRHlldHlwN3UyTVZ4bXFyeGNBMDBu?=
 =?utf-8?B?VUkwQnY5V1pheUZCQ0xZK202cUF6WW4zR3VjamlrUHVZamZHTWxpUkx2NVd2?=
 =?utf-8?B?N0E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?N3BHb2RBdW5GQ3pxN05kUnFUTnZnN2trc3FUb2FRVURLeGU2VkZMOFBBL1l5?=
 =?utf-8?B?ekZFemV2MmNyV0tCQmR2dHVBNFQ4NVBpOVBpdjBhbnBTQnFMQ1p1ZkFwTXVw?=
 =?utf-8?B?dGh1WDFLMVRzRXAwL0Z1REpoTXg5TUR6WEg0ZGt0SHZoUnRCZkZlcUc2WUIw?=
 =?utf-8?B?bmVoK1JpN1M2UXNVZURycmxHL1ZETFhTQnlvcWhPTlVCL0puTTQ0aDhnb0NQ?=
 =?utf-8?B?ZmxhUENrTXYyZ2cwV3p4eEF6OVp0TmtId2lmK2R1ZzV5c043ZGRNbkplVkQx?=
 =?utf-8?B?TTh6OEdGdE1OSlB6MS9MaEk2bWNZMXZWVVVNaWRLYjA1WEl5L05LWDVXODBa?=
 =?utf-8?B?NEcrV09NMUhPUENaaisxQ3VQWUdleHZ5YkRFWmowMDZmdVZPR080eW9SWE41?=
 =?utf-8?B?Q2t0RTdkT0pSdVg3R2pzS1Q0TFlrVGJyeDZOLzhRRDJmbGEwa1k3YVQ4Zzla?=
 =?utf-8?B?WXFrenRZOXhOWldsY2VwRzFGYXA1bDdsVkRXLzJwOXFoeXZVRUsrNFVZejcx?=
 =?utf-8?B?dXRCVERaZ1BxZk1zWCtQWUdyamZZTVJ6SWR5UURYUWU3cTQzYllhRjlMQ1g0?=
 =?utf-8?B?c1JXL1A1aldoYS9uS2xBYnorajRSM1VJV093UmRpV0Q5aDI5L1IwOFFWcWh2?=
 =?utf-8?B?N256MnBjNXNGK0pJdm5WejliU1F6bjFrVGlSc0xCaU9YanV1aFFtUHRJcmov?=
 =?utf-8?B?YzBlQlNQb0FxZGxpaXNYbWo2M3h5NVpFMFp2N1JoSFp0VmJkSkwzcWxaVC9Q?=
 =?utf-8?B?L2Z5TlBuVXo5ajd3RmtEQk1RSjFIWW94OVYzOEVyT3lXMEpIRmRFbkF1cHJE?=
 =?utf-8?B?OElvSTNxYzljWXBOOTdlK052MldCakdXaUpWR25YTVVXbkI3Nm9keHhWSWF0?=
 =?utf-8?B?V2lhNmJTKzlyWVVDS1lEWGpVUDF5SUM5MkN4NUppVjN2cGlzQmU2S0xQWUJR?=
 =?utf-8?B?alRqeVVDSDVyZmd4MW5OTHRVN1FQcUNGUGhwWWd6QW9QUXRzNGJiYkJPWS9I?=
 =?utf-8?B?SzdkdmxLMUdSN0VtZk8rRGg0V241cXNMdVNNS3I4bStab3F5b1lvRkxTcTNv?=
 =?utf-8?B?d0NDSlZQb0ROeFVNQzJiMXNHT1VHSGhWU1QrL2hDdnh4bnRwM0F0d2FtVW9E?=
 =?utf-8?B?Ly9hL1V0SngrV1VuZi9rUW01RkdQQ284cUdFRmFVdnRlQTljbU9maWtBRFlj?=
 =?utf-8?B?VHZBTU5YUDcyUE5Zb2oxcUhGTGtXV0hyZ1hJUFNkTms4bGQvWkNkNjhaQ1Yz?=
 =?utf-8?Q?wmtXGquUkj8VMId?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88b62718-3e31-4ec8-505b-08db1faca09d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5433.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2023 08:10:49.7087
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xoZk1kIYGI+oLMKcvramwghc/+cfYJTMmDQBB9C4b8XCDdhes4vwLIo1nR3DT+7F1yUE3wyawNFQXAGM5t0JZhnSzJ/rYzTneV4N/kkXnCE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4599
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-08_04,2023-03-08_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=838
 adultscore=0 bulkscore=0 spamscore=0 malwarescore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303080070
X-Proofpoint-GUID: llS9EsjUX7qF7yhpH0E24tBIYQ3GZSjM
X-Proofpoint-ORIG-GUID: llS9EsjUX7qF7yhpH0E24tBIYQ3GZSjM
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 3/7/23 12:43, Vegard Nossum wrote:
> We can probably do that, but it doesn't seem to be used much in existing
> kernel documentation, I find no existing instances of it:
> 
> $ git grep '\.\._.*: http' Documentation/
> $
> 
> I know that lots of people really prefer to minimize the amount of
> markup in these files (as they consume them in source form), so I'd
> really like an ack from others before doing this.

Oops, bad regex (missing a space).

$ git grep '\.\. _.*: http' Documentation/

does indeed find a bunch of places where this is used, so I guess it's
fine to do it here too.


Vegard
