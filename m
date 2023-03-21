Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E6366C299C
	for <lists+stable@lfdr.de>; Tue, 21 Mar 2023 06:10:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229798AbjCUFKY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Mar 2023 01:10:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbjCUFKU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Mar 2023 01:10:20 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 705CE36698;
        Mon, 20 Mar 2023 22:09:32 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32KM5VK5031365;
        Tue, 21 Mar 2023 05:07:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=SLF5eYGY8jHa259PGo13SKmGbJC6AN12CJpsI3noJhE=;
 b=fz0qP71kJXvfa6wbLD35dR0GB4F4TK8bHlVQHQVk/KbSxgTODcxF3FSc7qpb01D/CPsO
 ezZSBEI0KkLgYZGFoFHZNmJxzyfuMB0YsA7ut1fe1dpqjJeRYDUJKhXi+hEjqJfD7Se8
 kuF6IemNC9W9hUACYXQHRXBEpLR66ongoIP7nD2Ycs42qy6QFUovS7qd9vg6fheH50mg
 8HxnD+9K95osa0vP8z0iw7Nynu8iN00pu4Rj4eEK0YbkfE8/yPYkdVdNYIgnC3xZEFuM
 oysvCSvIgfct9Rf/7jwffauw7OkhFo+MKh2lscPzvZW+OU3Co8jgkES1W/VoADJBmy3x CQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pd433n8gw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Mar 2023 05:07:29 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32L55pTh038634;
        Tue, 21 Mar 2023 05:07:29 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3pd3rcprhs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Mar 2023 05:07:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ku9NZR0UfCwtqBsbrUu5pp2bU5CSIGlmTBG5w+kNwwUmetf2HkzwSAiqdOXnW+eiwyEHA9Va2z4ziyC8gysO4Fs4fkFxoMjTlRInAyfQmw7q7+FupZIwx5Q/Czlq+JApTQeWdn2eb6SuUR3fM6Dk9Nhwt/Eb2chMS9U1zSlrnXM+T8fy2m+Zi3skRWjjpp6QS3L/+EUT5I9J+E/4Wpnt1rHe4g8S6Phe0ScvAKyZWU5RMuZs/DO9j+H4hXdY1BM78Y8csEGnIe6ekREaxymSWITuqAiBTd72+KDoluk1r8MB3txopfyR51J8OiuzqKPKJRXW+62BrsHRiJk6cAIPdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SLF5eYGY8jHa259PGo13SKmGbJC6AN12CJpsI3noJhE=;
 b=P3+IAeKinFuKgmFQY93Jrj/AL1wAnj41RFaie9prryKmgG6/rp3zq/TsVozvC2/94cZN4qmrxUTVq9mxoECcketqsx+/XD7Chq0zsJBHs9+e4vgLcc4DToxG+Vx3CS32ZwqQ/NkkuxGMoDc3YV5nC+8G6o3IIwQcOlAofZfD+UqsNHlxpIT7d9b/KvXt8bcygZc2NilZdsav3u/VXMy8jtfFHxY2Q3QcB5ZmI79GuGQ93XDQWlA/RBHOmCtL2yNJa/UcCHM/bDl2HleBns0h0EDSgGSq3PDjeXYsqsvLzKw8WlL7XuEj97DPhuGOHH5J2/faemhuEFzAFDhwrb24Sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SLF5eYGY8jHa259PGo13SKmGbJC6AN12CJpsI3noJhE=;
 b=xNkExnsIlNrHi3CewQfQ0gpcvsUjIsgiLqIP1/J6AK2DjBA3BRj6xwltquXBqxQ7jDMEb7EH4Bn13TNowip1aN4x0RG0aCWAX+Lms/P+LjG8uHMKMk+K7pxTUHeH2QuegVAXoNCQ6x0RdDHv21dHZbVx7UK43X80VJWp4q/f+IQ=
Received: from PH8PR10MB6290.namprd10.prod.outlook.com (2603:10b6:510:1c1::7)
 by SN7PR10MB7048.namprd10.prod.outlook.com (2603:10b6:806:347::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.36; Tue, 21 Mar
 2023 05:07:27 +0000
Received: from PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::ffeb:6d62:6636:6c38]) by PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::ffeb:6d62:6636:6c38%5]) with mapi id 15.20.6178.037; Tue, 21 Mar 2023
 05:07:27 +0000
Message-ID: <eb0e4a89-17f8-d6fa-0fe8-5e8f2e400bf5@oracle.com>
Date:   Tue, 21 Mar 2023 10:37:10 +0530
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.1
Subject: Re: [PATCH 5.4 00/60] 5.4.238-rc1 review
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
References: <20230320145430.861072439@linuxfoundation.org>
From:   Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20230320145430.861072439@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TY2PR0101CA0036.apcprd01.prod.exchangelabs.com
 (2603:1096:404:8000::22) To PH8PR10MB6290.namprd10.prod.outlook.com
 (2603:10b6:510:1c1::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR10MB6290:EE_|SN7PR10MB7048:EE_
X-MS-Office365-Filtering-Correlation-Id: 82e59faf-0690-4814-d572-08db29ca29f8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 554LogpfUV6l2jtb/NCJDjYg3Uvp5sGgpt4UTq8/DLwkE5d7owguWhiHEJPMBiMInXS8K0gmElaVjMKINSX+twVqijm9gDwVvUpvo+ZzISKcc5MuEGDbyCUpnxAntBvUlBixqLxEIAkSoCbA4vwab2drG/9ws4EWwUBMwBX+JmJ74fCgc1BFYCVo4hR7V40qJP64tWYHxuerlmBqU4gpUnbRn7wsj7N4L5W2zuc7Aufr8/qysrPtBN4bFx3o3p7IQB0gtB9DFMbcrwN/LoYroEavvmOBuflEy6WG10rwOxQ6DmHeSM8x6ZvI+C7d/ySfDOS4RxA5n8/Qb5Sw+wNigDKVjCV8IR4s/k0jjB1bSDB+fADRvpWOY5S2Ol7tDCR6xztObj74xMp/2qpQx+0GbzoYxEs3u385JHoU7bX81AOKqiM27ZJxIExycjbWjkdzKhx7vKzON9Ssd/66+PkKw5UH5k52TqyfVlvYA9NMvBJZV1eIj9NwubbrEsmtvAo9ad++zPABuCsRtDGFaPCABbRqOM1jphYXbYvlZIrqG8mG5k+I1vw9gmT8A+YdCS4o4CW+uLF0mLCf+TaXQiou+73oVvkIF5A6Esqa6KC4c1ctBv+iIY83LWmwJv7tDZ9OAdoeSVPfVSXdxubAxbj6hGbRLBkozBro6qpm6t/rd+qL+D9jectZoUy9i/kqjX/VwAhSLE7cJUmHdxPzn2ZQtmYyCnUpChMUMPa0V+pTldU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR10MB6290.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(376002)(346002)(136003)(39860400002)(396003)(451199018)(31686004)(31696002)(86362001)(107886003)(6512007)(38100700002)(186003)(36756003)(2616005)(6486002)(83380400001)(6666004)(26005)(6506007)(966005)(478600001)(54906003)(316002)(53546011)(66946007)(4326008)(41300700001)(4744005)(8676002)(8936002)(66476007)(5660300002)(66556008)(2906002)(7416002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cXBnZ1ozbGtnOW05dGx5WWlROFF4eHZJN2I5TDM0eVhwZzVkV0lOYWZwMElD?=
 =?utf-8?B?ZUl0cHVvdm4xdEhIVmlRc1FvU2EyMlRFTXBBV2s1cTlZTFYvZ3k3YllNcHNB?=
 =?utf-8?B?WGhhbEtZSFY1RlRDZDFRcnlaNlhpTGluNnJlbWNlZUdzZXZxdzBWWkJKelBS?=
 =?utf-8?B?dndZeWJLRGFpcDVvM0FkTVR1Vm0rWWswb1hjcWhWVnFhUTZKMzJBaGFsZmw5?=
 =?utf-8?B?c0JaRTNsMWJjOStmRkN4NDRqVmd6UDhWM0Q2K1MzQTRZa2FVb3g3WmtvNWE5?=
 =?utf-8?B?a1N1Y3FCaVVZSkV1Z05Ca2ZCQWNYUVN2Smx4Y1EzR3VEN21YN3Y4akN5cW5q?=
 =?utf-8?B?WTRSWHhRbkJlNk5sV1NjcWVPMHg0YkorLzRLNHFwNjVuYkdsbURyOVQ1UUNm?=
 =?utf-8?B?N3RKemU1MkRtRkwrRHQweGRvZWd6enZKSWgzYnNwNjEwZEhCL3BJZ2MweW9E?=
 =?utf-8?B?ZkdUUjdUWjJBT1NucjZ5eSthWFNBZHNvdzN1UjQrMXZVM2czemJ6Z21Hd1FR?=
 =?utf-8?B?bDJ6UWJ1L0dHeU96Qk4ydW51LzNkdG9ETVE2N1lTc1BXUFBVamVWRXZwdXhP?=
 =?utf-8?B?M0FPbjVTU0p1WXpTK1dyenltTTZTUFBrU1Jad1MxVHUwSmYrc1FGaEtEbENu?=
 =?utf-8?B?V2ZXUTlLdTNvYjZtS2s1eE8xWHJvMVdSTThJYTRGekVZRG9FejcvVHVKY2dk?=
 =?utf-8?B?YjhBWXlLdEc4cEYxSHFRQkxqM2ZrOHNsTDhxL0hPSlhtRnFDQk90a09hZjFE?=
 =?utf-8?B?MTZJbysxNU9BaTdDQlEzVGZ6eGxyY2lka2J0eUxiMUNYTUQvM0s1MUljbzd2?=
 =?utf-8?B?c3UwcTlKV0grT0ZqeWRROGYzZGVPQWliOU9ZbzlMRUcwRko0eHdxYUFDZVpz?=
 =?utf-8?B?dCtoSWZjTFo3OCtaUktkUXU0eWJ3NnVwcXpsaG92VXUwTEhRZ3ZNUklSUmVP?=
 =?utf-8?B?YnlyR09BVzZwNXE2QnkxMzFGOFl3dDFBVSswMTBkcGExNlFqRWRkbnJ0cFlE?=
 =?utf-8?B?M3A5SXZRdjY0T3hkWVFkRTY0M1ptL3JuQy9jSVNoanZRNWtibTNHRGZUK2VM?=
 =?utf-8?B?c0Y2YXFPWmtiNHE4RWRWM1hRS2RqM2FNWUozRkJFQ1Y3aTVVTVRFUDhHeWF2?=
 =?utf-8?B?NFdBeHJld3g5ako2L1RvU3g3Q1k2cHROdlBQVEM4SW5EMmNNdzlxVnZKeTZD?=
 =?utf-8?B?YkhSb0t2ZVRHTWR4UGFDWlFGeXdtR2hLN292QTUyNWU0dGxjd0dnMCtlZ25r?=
 =?utf-8?B?b3U4RE1VU2NrUlVTV1ZDaXpRcHRYVy96OVNJVEozR3dQdDNmNi9QZnFLNUdm?=
 =?utf-8?B?d2ZSazVyWUMyRXhnZTJrVnFGQWJPNzZxOG54TXppd1lyUVVKZGxxOTRBOVhU?=
 =?utf-8?B?aThpQmdJdjFRM1kwZEI3aXM1bElZSHRkRkk5TjIreVBIUUNSUjdhcjZWK1hZ?=
 =?utf-8?B?Z1JCL3lzTyttTzlxbGU2OTBtcUdlU0Rjd2tUdjI2RUpGWnBUbDQySmRPMFlt?=
 =?utf-8?B?YmIyN1NOYWdvaDdXbXIxaWFXbnV6SkVsWGNCSm9tNU9LVUxuMm1pSkR1ZUZo?=
 =?utf-8?B?ZEk1K041TG1xYW5GdXV2VzBFTHMxc082MDY4cTN0MEFxSWFsZHkzV29oYzI3?=
 =?utf-8?B?Tzlab3ZDeWlZNWIrZEJSQUVobE1qbUFqOGRYMjg3bVcxYnJmYkVoUDFQZjAr?=
 =?utf-8?B?TGk5dEE2ZzFPUjB4QW9XQ250QkkrNXBpQ1VqNW9xZ1J6UzVPYTBiS0hHQUpD?=
 =?utf-8?B?OHlFQmhiTVkyL1BRbVVFS3RCTXRDc3FoeTlvbm04RjUrUlU4RXFvWFNlbkla?=
 =?utf-8?B?UENoS2VibG1OQVpmYlpqRE1GZHUwalhvazNINHNFS2FLQVcwZHFoKy9ncmNo?=
 =?utf-8?B?ZUpQc0RDeDBTc1ovTnVCRjBaSnJTcTZiOHJoa01LdHBtU1JHaXJ5TFQremE1?=
 =?utf-8?B?dk1wZ0FSdVhleXpZTUI4a2xrSGsxajFiRTNwZzAvdkxXTnU2dTVMWGRTSXZL?=
 =?utf-8?B?bGFWbnUxRmpiNEpielB4V0pXWkZ2eFBlZW10MTFldGZOU1ZKU2NrdVBXWEpn?=
 =?utf-8?B?Z3RGbGlOeWVvN21SV3Rnc2x2M1dkMXJQU3k2cGFaUVdmRmNJbDI4dmxWd2pt?=
 =?utf-8?B?KzBVZi9jWkZrRkV0eUYrUkJkK1F4S2RUSU1wWXlqWE12VTVlK2NwZWxjcFFs?=
 =?utf-8?Q?NcceDt9rVIgC56QqRL7WeOg=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?VCszaEFWZS9FRnpTWlE4ZmRsR2VEUnNQQ3ZaYjBZTG9IaWs0OEd5Z0svOVpu?=
 =?utf-8?B?MGRqWitocGVNdTdzSTFOV2VLRENJNmxDVkcycURrUnk1bmRPSHh0QkZVOFl6?=
 =?utf-8?B?QW9Mek1Icm1Oa1VQbjBqNklRS0pha2VRdnJwRS9SQlNkVHhTVHEwVFNXaEpY?=
 =?utf-8?B?UHpwVWRtbDlrenI0cENSMDJNcTdIYW11d2owUFdCdUZjK2NGWkFHUFdYNzRS?=
 =?utf-8?B?QjhNNmY4c1phK3gyY2NYL3F0TEdFVTBFVlN3R2M4cXN6R2JabGlhWkRDZW16?=
 =?utf-8?B?bWxIRnpDUlBVTHhQWGdyaDgzZDczVjVKT295WDV5YUd6VzU3V2s5ZG5HM0dv?=
 =?utf-8?B?Y1owMGJhS210TTAzU242cHJoRndSWHB5UjIwMDdoT2N0Mk5hUVJkUXZuM2ha?=
 =?utf-8?B?RGRNaGMvcFcxY0MxYkIwOGU2Nm5jMlVRY1U4V2tFTitFSW50cGduSlJ5YzNy?=
 =?utf-8?B?elgrZXJDcUloTEk0U0swdjNXeFYzNHNWN3FYNXQwRDBqTUxzSzdIUm9rUzFw?=
 =?utf-8?B?U2k3dURFQ2l5REdGK2dVWWJ1WUI4L3NBbXhBL0NVUWl0ZjJHLzkxQUFwOVl4?=
 =?utf-8?B?WUdBaW4yVVZwR093V2ZCbmF0cWdNUUgrSXJqN0xQTzliT0lIV0xlY1NiSGwv?=
 =?utf-8?B?d1hqWkhNUDJ1MXpaTTdCSllTMHhZemxxU1hxUXQybnVaK2dubjNIQ0RrUWNN?=
 =?utf-8?B?dVhZcVdwckVFY3pHeXpERVJIYXFtbHdsamVaSG9ZVHQvV0RQSWlCbWpqVEpM?=
 =?utf-8?B?UExNNk5sRjh4RkFyV29MTnpGR1RvM05vcWJXNCtyYWZxdG5MeXdCYnNqSDJi?=
 =?utf-8?B?bGMrS3l1QS9BTlMyOEZ3MStnVnppSEhIdWVHcGtCeGZMcFNTRlAxWjV1OFg0?=
 =?utf-8?B?UXliMUFPbVlqc0VOTHdxR2t1ZDlWMmdmL1IvRnQvbWhUUHJIWkRwZUV5TG1n?=
 =?utf-8?B?NU9MVXl2Q2NDVEk5VHpJUG4yMmNySTZtSDJvTDhwQ3Y1VERJUGo5c1hCdnk5?=
 =?utf-8?B?ZUdwd0tZZnFqZzBrNWNiczZ0TnlBZDh4TE9aM2JPanI5Ky96SXBweUxuWU1w?=
 =?utf-8?B?L055OWVLam1SVHArYXdPTFRBVGhXcWJ0TVhNck5Mbk1hWlZPUjlMa3pzRG9X?=
 =?utf-8?B?RElObjljNzVpZFhQK3grL1l4OERUNnRGZzdKZ0NsVXB5aTdsUlE1eVNvNUdT?=
 =?utf-8?B?RUZBUDlHMWVLcFBNL2VCVVgrMmkxNW5XT1Vkb2M4R1NNckFTcFpWQ2grUjQ0?=
 =?utf-8?B?NWxHMnJkR2lPc0lYN1ZqYWI4Y2RRYVNaNDV2MEFsWDJyNmdVbkpZbjJoTytI?=
 =?utf-8?B?ZVdjaEVCTlMwSStmcS90cERqcllFZDYvQVBWdUo0ZWtNeHFQdlYrSmVOenJS?=
 =?utf-8?B?YlRPRTIyeWVBc3VjZjhRL29FT2p1UFlLR2ZzNC9takN1cnROTGJnOVo1bHNB?=
 =?utf-8?B?NEFOZ3IyK2hwNFF4U2xJcHJXT1lDclNPNFp3NmtaRzRQVVFFK2plcXp3Z2lW?=
 =?utf-8?B?TGd4aDBKcU9EZWNwSGFCdm85OFl0NU1yZG5EYXRHTFhrZXJUVmFFci9WMGVj?=
 =?utf-8?Q?OYR/q5Eh5dfbAvkSE6wEduw6i8+lbI/ojdSLHBYL5zzeyl?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82e59faf-0690-4814-d572-08db29ca29f8
X-MS-Exchange-CrossTenant-AuthSource: PH8PR10MB6290.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2023 05:07:27.0655
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mypPBEch16sUB0eSInCLFP9GWOho8VQYlsxXfibBIYRMzctYy/dafUare4+7cmIDnSW74h4M4HavPyZw8Y2RfJm8NkEbHXFJYfRjf7CYfcQkf68IsAX2T+YnuLmOibtN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB7048
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-21_02,2023-03-20_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 adultscore=0
 mlxlogscore=999 mlxscore=0 bulkscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303150002
 definitions=main-2303210040
X-Proofpoint-ORIG-GUID: FNtyQRwXYhdFnTM5g7ftcp9ocdyo-XYV
X-Proofpoint-GUID: FNtyQRwXYhdFnTM5g7ftcp9ocdyo-XYV
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

On 20/03/23 8:24 pm, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.238 release.
> There are 60 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 

No problems detected on x86_64 and aarch64.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit

> Responses should be made by Wed, 22 Mar 2023 14:54:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.238-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
