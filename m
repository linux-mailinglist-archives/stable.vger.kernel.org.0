Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B7896D875C
	for <lists+stable@lfdr.de>; Wed,  5 Apr 2023 21:51:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233533AbjDETvr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Apr 2023 15:51:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233891AbjDETve (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Apr 2023 15:51:34 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7F0D19B;
        Wed,  5 Apr 2023 12:51:15 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 335JGuIn010147;
        Wed, 5 Apr 2023 19:50:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2022-7-12;
 bh=BUM+vPq8yzSs/CU4OwrcXVWuPjq7OaddXAnzyukKDiQ=;
 b=Fq/gyVROptO9voSSsJ1q5SdrwYv+DzhqXLlWJD4uvKEu0j7AoHbC1cb/VrjK/Ho4FG4c
 Z0CIh5+EEY1yFPwEfcz3mOmz7vYONevw0XVhhJF3SI9ZSUfgBPae5PwBkziUNMW6qEHn
 ZBF3nmqhkmL0H/sYaL56ivhOZUOK3o4zhmd7cc/LYT8oxkmt2bA2NTKe7Ws6jcB5dpYD
 VBoG668csdZ5g2Y0apV2XX14CQHout/5jrxO1E9saVEt7HgyXWzAX4z4mtgLEGW9R2hc
 DJ4BP/Xd58wcPzMswLNwRUWyRcOuch3u/xad9gzKsK3dOKA6qAHePy5q/ng5udtCFB5V BQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ppbd41b1y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Apr 2023 19:50:40 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 335JdUpE038319;
        Wed, 5 Apr 2023 19:50:40 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2041.outbound.protection.outlook.com [104.47.57.41])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3pptju56je-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Apr 2023 19:50:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UqoDtTlX9UVw27mL8EB3lcsjKzc4HhwkrHLF48kOSMhov9CKFA4Klmg00rl7vyMHIg02NVmin//yvFdAUBmNv0t0VQ9UUdh3R+DOtdwcFBL+Ak5hSGlahNS1tT3DGp1nACjjAr3TgoGXm6eo9QjxtR8T9FR9irwf3fqLxokVPzlNbV+kccXqug/pSVwmwLuXyIyoBM8kSbASWlpmIA+TjDBw2h2ehl5rNu6pCYiEtb1d/9RcwyD67Pe/5n8rX+A/MYYVtaZiupykmqJswaGGDn5dwWzHo+Yr2ZFLM9lNwxAL5+/B/MdPo7ZCze9HtdYZPJqKwyKSx3V2oNUKNlDg9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BUM+vPq8yzSs/CU4OwrcXVWuPjq7OaddXAnzyukKDiQ=;
 b=GTE0TRAW2kE894H3jA8BdhQC12wRJM9j65TgMwnpBsS5akopGE9FWF2SSDNKSam/jC+IvKQP8hUliO8dVmEwGpUOn0jAArCE39+s8XYTeqfQzQLboltvancPwxJToLRyfr2jTRMZ6JKmMx9J5zlefD5itqssZGwv0wYHYxLTeFkKzs1/13nzNvS7M9O48ecXEtNZ7aQZpVY9iff9wofVTtuMUnR5/peQ3TM2837RmGpJkONW8c3/uYMiHR0sG/I0jgujoaymaQoM8PEoRNBi4LHdVuS53tUUrENHbRl30vSxbUw3Rdph71nzPc97kS0rg9URfoab23IfxtZyzfCrfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BUM+vPq8yzSs/CU4OwrcXVWuPjq7OaddXAnzyukKDiQ=;
 b=JnJVlQ8tsBTaZ8wol3L29tR48N7cW487L2s5ww4Qssa+tiT342u7gJZWmpIOU10m1OWWwX5GdJD6hs44zQS39BFj0oAdyKf7xMFETbcMxj74B4N5Jed6+khOLxBGRzhM0djyDVOBWWz9lv1IgMiV/QCqSV+7kTwTEv+VuhMp3cM=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by IA0PR10MB6866.namprd10.prod.outlook.com (2603:10b6:208:434::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Wed, 5 Apr
 2023 19:50:37 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::df97:c045:6f0c:974f]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::df97:c045:6f0c:974f%3]) with mapi id 15.20.6254.035; Wed, 5 Apr 2023
 19:50:37 +0000
Date:   Wed, 5 Apr 2023 13:50:31 -0600
From:   Tom Saeger <tom.saeger@oracle.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.4 000/104] 5.4.240-rc1 review
Message-ID: <20230405195031.k7rabs6nzosvpl73@oracle.com>
References: <20230403140403.549815164@linuxfoundation.org>
 <20230404203312.2ofkv4jxyvgscxpk@oracle.com>
 <2023040516-flirt-provolone-d254@gregkh>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2023040516-flirt-provolone-d254@gregkh>
X-ClientProxiedBy: SN6PR08CA0024.namprd08.prod.outlook.com
 (2603:10b6:805:66::37) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|IA0PR10MB6866:EE_
X-MS-Office365-Filtering-Correlation-Id: c57f29c3-c1a7-4d0a-972c-08db360f06c1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mE+eg9yeVU5cxlY7BMnr60CEqPi4Wp1ejT3UxbEuNzrWGwKNhN/CF1CwJZelVupokt1H51c8xFBPSUwMVVSCKMMV/xPgXRQxh8+mabbpUkyz6nfMnBWNOZLbxwu9SL413fNLmuyZOtE9ywOGXmbR4YtUuzuAcYPT/KIcAvb8MTox9++AbtoJIhQGEMJQhaAIfk8ak+ag/FMH5lVJSFEf5uPu2NqK3PCPHUIQo0WUq4svYy1blRkzUZ1d5MGeFzcwcmIQoQKiw17sAxw+DZJ4mKOnMVLlYp/H0cDt2X9IuLhwZtWM9foXsph6YujpgLQEQRCBA47hOJt7sq3ofQoLY1WmFU1ZJv16GowQByQ4NbuuxLPMlEYJ60mePFYo9bXL6GRIoz6zHl2SchKwrj+QAsAUlkIg2oKfOzBnz3c1K6FIsnDEFILY2M276UWMHIOSa8OEF/gOrAR1cT8Y41qhC+pFk38dLo+E/DxpVmX42+FvtzH1zq0gQK3dJBhAmAYRG2wp1AAlZXQDq2JCWgLT7luHCyeqd4qK5TvCPxD8kecbplhJbiv7LXW7f9Lxala4lzj4/6uusnzeEVjYxtao3g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(346002)(396003)(136003)(376002)(366004)(451199021)(86362001)(6666004)(66476007)(4326008)(316002)(66946007)(41300700001)(6486002)(6916009)(66556008)(478600001)(966005)(2906002)(7416002)(36756003)(6512007)(44832011)(5660300002)(8676002)(38100700002)(186003)(83380400001)(6506007)(26005)(8936002)(2616005)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?LzNUSy9IS2pJT0J0WENyVDhUL3R0L2NHalpQUUFadW8vaUo3c01tTWhzWHJZ?=
 =?utf-8?B?TXlYKzZkNkxzbStWQnZ2NzNVdlMzR2ZHb2FLNnR0aWlJWk5Sd00rZERVcWVU?=
 =?utf-8?B?RVVWVGVOOGlqdUxGVXJWMCtDWnFBelpiUFlaMS9Ickt1WmE0SmtMZ1hNay9O?=
 =?utf-8?B?eHRjR250cDlQWkVTT3BTSWo4VW1PUTloNXNpVys2UFY3NWNyYUVkejduUFJx?=
 =?utf-8?B?dEczancyai83YUYrVVVjSTN0YXhpNlZueFhweEQySUpubVZLM3k5WWRWaWV1?=
 =?utf-8?B?NVBBRWVxZi9SdFNqRjFVc240cXJ1Z0R6cTJOb3F4aEdhRGlLeVZjUWl6aE5H?=
 =?utf-8?B?WU5nSFo3Q2hMMjBnaWRLRGJHQUdsbE1OeU16cDh1M04rMmhvWlVpRnI1QXJw?=
 =?utf-8?B?MjY3Q0tRcVRWZWtad2Z6WVg1MWpwOFMrSHRxYjlrNCsvbjVJaUdvTU5FQUxT?=
 =?utf-8?B?S3luSHp3V0VUb3FwUjJqdUhCQmdObjRmVlA3VXQydlJ0WGVidEROWGJUWTJ6?=
 =?utf-8?B?OWU0SmUzODE1N0FjY3krQXE0UkNqVG5ZaWk2S1NnRjlhYm9idmNleWlXZ283?=
 =?utf-8?B?Rkt5N3ZuN3pQdFNYMVJoOW5BaWVYQlFVUllWNVMxV3AyY0lEQ2x4OUFZdUJk?=
 =?utf-8?B?RXVwVy9GeVp4UVd2Y2hTZGYzdXFHeFdqNHZLWGc3SG5QdDY3UTFrWEZFSytM?=
 =?utf-8?B?d3U5Z1dCTjVlZTZrM1BPSTRtYTRvUjVQVENER2lhNFN2bGZRVFU3b1d5SXhE?=
 =?utf-8?B?R1dQaDNiRUZIMHBTRTNHTWhwdXRkcHRyT2lQTFZYVzBWNFd4Z2ZTU3RlRTZJ?=
 =?utf-8?B?NVE1dUlJRVFCeDN6MTJxaGd4NkhmdkpoMEk5blpZbk02WEdvRnNXOWFGRWVO?=
 =?utf-8?B?Wms1SGtuVVVZek9vbGtyMTJFQi95cUVGNEc3NDR6SlNoSmJHSUZBUWhYa3dT?=
 =?utf-8?B?U3NaOGpoUGVWWTBNUloya1JNK3ZWUjZnSkV0STI1MmpMbGlYYkVSOVRWUlA4?=
 =?utf-8?B?QnREbUhMRVJCTEl1OGlhMjNlZHptUC9teDFKKzFjbzVoWFRDUTN0M3htRVph?=
 =?utf-8?B?RWFsR0Qrd3B2bWlZOStRU2tadzloMFNmSTBIR2ZOLzVCV25vWDZneTNJdVBq?=
 =?utf-8?B?R2o5Z0EyWWR6dHNXSFAyUTArMExVaWQ5b3gyZHEwampEMXZBNjhBcEFtZzhH?=
 =?utf-8?B?dFlVdEZlelQyOVJhaVRzdDVmYUtJZDg0YktxNTMyby9VSHBwbzRZbDFsbTJi?=
 =?utf-8?B?cWFabmd1b0w4YzJoRGlQcnlxZjlaSnF4MWh6dkpvVkwzNU9sOU5UZGJQeVVm?=
 =?utf-8?B?bGdKUkFYOWVwMUFHSGhMVjZGSW0wOE1yTDcwVVlUYndtV2xiYVY0dlRRNDVL?=
 =?utf-8?B?SUZUZ3kxRXFrZFp1bHJrazZnVXAzN1ZnZ2lxbkk0Vkh4RnRTM1JoaUY0QklJ?=
 =?utf-8?B?U3d0VVZwNExKV3ZiUE5hNTB6RW1DRzBSN0VidmZhVFhqVXBob1FSaWRNcHNh?=
 =?utf-8?B?MG01L216ZzNGdU85bHFubnZHQlNqNDlTOTJVQnNtWDExYVlkajQxZndkcVBV?=
 =?utf-8?B?NWZDeXo2TytLRmt3TjZRdGxiVFY0Ry80ckdBdXFnSVI4VXNNeU5TWWF3WTU5?=
 =?utf-8?B?cnZMbzNhN202QVhVUE9pd01IckhzaDgzcmdTc3RyYkJDbTlhdnVXUHI3eHJs?=
 =?utf-8?B?dzdiNEswbzkydHFNeC9LZVhUc1AwVnRYajV5OW9BalQ1Ym9jQ2xCSTVPb1Ex?=
 =?utf-8?B?T3lDS1EwMkpQQ2N5aHVZdTFna1FCUHdidG5qS05Yem1Ca3gwM0xkcmFXTVE0?=
 =?utf-8?B?OXgvRmFhcjZLV01YTDU3cjljVlRJZXVGNzJWOHN1R2tMaVF4N0MxQlMxQnZD?=
 =?utf-8?B?MDNKSHorUDdQNiszVjVwYWxvSDNBM1RHZmpmSFMzUk5jUEl6MnpLeENFUTAw?=
 =?utf-8?B?aU90Mk5lRFVJMHRobFRKYjRMR3hVR0FocUVLNW1md29MTmlLc1VsdHdWc3lv?=
 =?utf-8?B?ckdlUmM4NE90WXB5QVBtMU1wcHIyOEczczA1dEJ4QWNTZUNMVkRFdUtCZXpT?=
 =?utf-8?B?VEJLemM2YzhuamFmZnBvT21WNTBCMy9NUzg5d01UTjZsY0EzdTBIZmxPUEFi?=
 =?utf-8?Q?eGv5uuPZquUzWvKUycGeMmNG1?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?T2QreDV6OHNtUmZ2dEQvWjY2NExMeCt6bFRTd1VpeW14NHlvcFVudUg2WThx?=
 =?utf-8?B?SnNLMENrRUF4U2lLbUFjTmNxK3BJTkI4NkExeS9YOGVkYlg2cTViVGJYS2Uv?=
 =?utf-8?B?dEs3YWo2aEZ6bFlRWmdSMFBWR3JFRzRoMVNaUnJ1L2dxZGJvSmdRSVl3eVNM?=
 =?utf-8?B?WHZIRnpvYzhPVUtQL3A2WTlqVG1kaGJ0T0lJVDhUODlxeURMZURnWEt3ek1y?=
 =?utf-8?B?UjFvZkRWRFlGTEp5MHh0eXl5MWJTNzJXUDBMbExCTHRHb2IrK3J6NXFsaDVk?=
 =?utf-8?B?WFR5R3NNcitmd2hicGsxSUFQeG1RZC9TMXo4VU9nQWY2YmhZTkJZZ05SSU4y?=
 =?utf-8?B?R2xwTjZCTGxGZ0tWZkRHK1c2OGNCVFk4ejh5L2hzVXN2MzFqWnlyNWkyekxm?=
 =?utf-8?B?OUkyeWphbzRtak1oY2trYUdtRm9McytZUVpqUmhzU3lHSlRwQ3BMTGJCTXhj?=
 =?utf-8?B?M3RKYnZ4WFE2RWFPdHRuNlhqK1VlUGJ1cHVPRm0vVzRXQWZRZjkxTHNibVZD?=
 =?utf-8?B?MCtneGpTMHV2SWZWamxNR3JVQ1RQYlA0NU1OcFk5RUJqTC9WakJTYUkzRi9y?=
 =?utf-8?B?WEpPL0ZxQ0tvMXltQWl5bjlmVWdyQ1dPeXZDYURQQUl2eG5jakhpSWdxeGlH?=
 =?utf-8?B?Q0oyUUZiT2NTbmQ3MUVRWU1ZMVJXRjlsTE01MVR5Yys3SStDeUZmeWZGOUw1?=
 =?utf-8?B?NjZuM3orUzMwaWtCeThHRE91MjFZS2pMTm94clJJSWp6aE5jWVc3UUJnT2Rm?=
 =?utf-8?B?MExHS0ptMDdtVmN3YXpVSFdDUWhSMmphMUlYay9Ydkk3ZWVYeFRqczUyUUlX?=
 =?utf-8?B?N2pPb3BOdndFdERwRkVyc1hPU0VrVWYyQWNMUVBQK0JzUU1FVEwzNzVSMHJH?=
 =?utf-8?B?UW9iMnU5N2h1SHZVaWRacGN6UEw1T1N0bUhvU1VzWmoxUUNuWitVQnNkSkZE?=
 =?utf-8?B?ZmQvVkhUTGJ6MVhHeGpEUllmWndJbENNRWRoTmhEOTl1Vk9LbmQwWEgwRG5G?=
 =?utf-8?B?Vnp1RjBBRmhsODlDVEx6ZkxoWDJMNzd4WmlMcFRCUzlGTXNtdTU3Mmx3Y1Iy?=
 =?utf-8?B?cEZKZ0Fvb2FqdFVCTklyMnJxVkhRUThsNHROOU1rcVlRdi9ha3d0ZXo3VW9m?=
 =?utf-8?B?Q1lZeUZQNVpscU4zVXNoU09GMUJEM0d4WXU1aEVISkE2UU9ENUV6Y1AxN0tP?=
 =?utf-8?B?emZUTUdiZXI5bW1lYVkwNVpmWWNTeU90TVZmbTZneGFYWFZxS2l0OUYvOFFV?=
 =?utf-8?B?WENrOUdjeUtUWEhBWGJFcVlRaE5oZWQ0WkI1WUNQK1lXMGo2em1LSFRMd05h?=
 =?utf-8?B?Tk9xeVdQTEZvZEdPWUhEbnUzWlJRMHFtU3pLRU1Od2FTR0F1eVN4RitqZ0Qy?=
 =?utf-8?B?SVhqejltelNmaWlJaG8wRG5VaUp2RlNLYUFLMWVhcnNXV1NlVmdiYUkwRmYy?=
 =?utf-8?B?MkFDM01YZitPL2QwdjlabTcvR3l2RE5pa0t6MzdKRGtsRHhFd0txWVlxRmtq?=
 =?utf-8?B?S0dVTVhveGhTSHF0SmQ5WTlUUUpKQXFFdXBkQUZVZFc5N1pnbzBQNDZkc0pn?=
 =?utf-8?Q?ZA3GRByOzVAbkMIqprWw8ltTuCpvCeJv8MFFffRSKlQsww?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c57f29c3-c1a7-4d0a-972c-08db360f06c1
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2023 19:50:37.1983
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JMKkwxSULyyqcRLi5cxwHAFOWKXH++ut4vTw+WlDjsXAyOU5LldMDrKEinEvnIq9dadD25Aaqy5ewJZFBI6f4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6866
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-05_13,2023-04-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 phishscore=0 bulkscore=0 mlxscore=0 suspectscore=0 spamscore=0
 mlxlogscore=613 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304050177
X-Proofpoint-ORIG-GUID: l2SMD_uW1ZrxB4muKfLOUd0f-XZM63a6
X-Proofpoint-GUID: l2SMD_uW1ZrxB4muKfLOUd0f-XZM63a6
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 05, 2023 at 11:33:35AM +0200, Greg Kroah-Hartman wrote:
> On Tue, Apr 04, 2023 at 02:33:12PM -0600, Tom Saeger wrote:
> > On Mon, Apr 03, 2023 at 04:07:52PM +0200, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 5.4.240 release.
> > > There are 104 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Wed, 05 Apr 2023 14:03:18 +0000.
> > > Anything received after that time might be too late.
> > > 
> > > The whole patch series can be found in one patch at:
> > > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.240-rc1.gz
> > > or in the git tree and branch at:
> > > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> > > and the diffstat can be found below.
> > > 
> > > thanks,
> > > 
> > > greg k-h
> > > 
> > 
> > Hey Greg,
> > 
> > This still reproduces:
> > 
> > 
> > cp arch/mips/configs/lasat_defconfig .config
> > make ARCH=mips olddefconfig
> > make ARCH=mips
> > 
> > 
> > .../linux-stable-5.4/arch/mips/lasat/picvue_proc.c:42:44: error: expected ')' before '&' token
> >    42 | static DECLARE_TASKLET(pvc_display_tasklet, &pvc_display, 0);
> >       |                                            ^~
> >       |                                            )
> > .../linux-stable-5.4/arch/mips/lasat/picvue_proc.c: In function 'pvc_line_proc_write':
> > .../linux-stable-5.4/arch/mips/lasat/picvue_proc.c:87:20: error: 'pvc_display_tasklet' undeclared (first use in this function)
> >    87 |  tasklet_schedule(&pvc_display_tasklet);
> >       |                    ^~~~~~~~~~~~~~~~~~~
> > .../linux-stable-5.4/arch/mips/lasat/picvue_proc.c:87:20: note: each undeclared identifier is reported only once for each function it appears in
> > At top level:
> > .../linux-stable-5.4/arch/mips/lasat/picvue_proc.c:33:13: error: 'pvc_display' defined but not used [-Werror=unused-function]
> >    33 | static void pvc_display(unsigned long data)
> >       |             ^~~~~~~~~~~
> > cc1: all warnings being treated as errors
> > 
> > Attached is mbox of fixed-up revert/backports.
> 
> Odd that no one else is reporting this.  Thanks for the patches, I've
> queued them up for the next 5.4.y release.
> 
Found it reported most recently here:

https://lore.kernel.org/stable/642d5611.630a0220.6455f.2988@mx.google.com/

Thanks taking them!

--Tom

