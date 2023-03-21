Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A0256C2909
	for <lists+stable@lfdr.de>; Tue, 21 Mar 2023 05:14:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbjCUEOk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Mar 2023 00:14:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbjCUEOT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Mar 2023 00:14:19 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A8D91714D;
        Mon, 20 Mar 2023 21:13:08 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32KM4PYO017062;
        Tue, 21 Mar 2023 04:12:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=V1l2bJpU0qLawO7Nh8jMOoOUsUxKtcAg3i/Kb4YZkVc=;
 b=BKo/ZA9hxTWHonDODwoeifZSGgxr0AzVg8kW1pZpHcu8tx8w/tcISpRa6N2tWUbzRGj1
 Jf5yD0/7+448YB3msuo9GDNrgJKIik3M78K6LXQXCAtBwi6iSkxHoeM8bG4zpxFiFXHi
 PUVnijTCH/Lzh3k5jFruQfgETSrLsVwvwYHOTNeemvTnjfufUVpZIcFVaM8EwsVTFHdu
 pFld/sXbEKOKdKY/mhxeg3xbjDG7YuEyoungVNDJULCMJctQNkbt+i69SmyxBbAMoCbw
 Ji1hXLn9jjBVuLuoyMPuArYTXVvsIY8thvDwapEB3+5kcsMBP5JVP1VBYaAMD7pY5pmP Tg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pd5bcd621-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Mar 2023 04:12:39 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32L2CVCD036892;
        Tue, 21 Mar 2023 04:12:38 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2175.outbound.protection.outlook.com [104.47.73.175])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3peg5p6mc1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Mar 2023 04:12:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MBt4yjFi70Oq87E0lYnzwJAMnG1eMOZyLMXEtBSuNIdUH1jnoLCQ8JcQoDma7u7BMqvUzpN6qKBu7KTjcKkpWXI4vmcPgAyO0qnj192JN+/UmoKpHVbMU7NW1eas/6LxVSXzW+oLz9O2I1vg2TiIZc6GwvfH6EefKaVO6bEsKZShCj/51DDOC/3Bjc5QHg9DBb3cfvoEr9kVSwurr6kqWoyC3dELS1aTt+7YvF3LVusc84mWAq+DBkOg+GP62jATiyyomnaiO6QN6ZSb974tb4mtziHG+E7Bs9F+CAyogz+AGP7DOmaagB2b2VL2GkhgXpk11NNJr+Yl1TT7xe52wA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V1l2bJpU0qLawO7Nh8jMOoOUsUxKtcAg3i/Kb4YZkVc=;
 b=YMEAUNXVfzguOdsMjqMh/dfO0nASzlIrOOEnjdvsNrW58UhaBGQ+zudrnim+SD8cpr+E9/2DMkCmbkmjDTcm1NPqinzlIt+8UEUH6IhhdbHKAyH2byiFdbyxW3kfV4XKR6csGz53arSv0nI23pvoZcbRf+Gu+vpFrpCJUCgBbeSdAHNbyv7f/peyzRkIYEEUEVkMxs15J0hGCziKrTg2mqhOY4hKk/llSmS3XbMqLA46jBe8N6/aiLiIJerZSGSYErwCJL/jeUyPSGYL6GvH+dxyvOAL3LKm6vRDn3092+o0RIAKNushAAjPov9rFUCJF4IiR73rGHp30UcxQrXL0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V1l2bJpU0qLawO7Nh8jMOoOUsUxKtcAg3i/Kb4YZkVc=;
 b=vv+XPkbWFebLQ0wXFG/g/ezMB9j4dJV4dWRpXpawKHtciJKEY1RA/aw6r6eVzxI+tUFzxbnZORDxrLt1qRBsIxZ42KQ9Fr0xDscRLqxjqrr9BaRqEFQ4n0kFrH5Ybg4pcsfUiXBtA4Dp5csYeWJrhwm15EsD7wPj2FCuvxz2e5Y=
Received: from PH8PR10MB6290.namprd10.prod.outlook.com (2603:10b6:510:1c1::7)
 by PH8PR10MB6292.namprd10.prod.outlook.com (2603:10b6:510:1c3::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Tue, 21 Mar
 2023 04:12:36 +0000
Received: from PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::ffeb:6d62:6636:6c38]) by PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::ffeb:6d62:6636:6c38%5]) with mapi id 15.20.6178.037; Tue, 21 Mar 2023
 04:12:35 +0000
Message-ID: <87e4e199-1598-776c-4771-ceb2bbb31c83@oracle.com>
Date:   Tue, 21 Mar 2023 09:42:19 +0530
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.1
Subject: Re: [PATCH 5.15 000/115] 5.15.104-rc1 review
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
References: <20230320145449.336983711@linuxfoundation.org>
From:   Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20230320145449.336983711@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0055.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::16) To PH8PR10MB6290.namprd10.prod.outlook.com
 (2603:10b6:510:1c1::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR10MB6290:EE_|PH8PR10MB6292:EE_
X-MS-Office365-Filtering-Correlation-Id: af960ace-4c37-409e-4801-08db29c28026
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KP8g7AHZoHgdAARIQDXZPusVISk1aE4bVLlJpn5ScZ7re3NqAEghU6RHn6Gm5Trs40Sjm4HHnj/lFn7qKJWOnrX8FGXfL2q4Sz/Zp0l2y0nXNvswJHxcYsjiGJKvqv7dCu2X7eWpJkSeT+QBk10x9D0r+ZQq/FcSmz5u+T4y+Sfx/1jE8dfNzqp1OEZKW7iFkBVsPXN3Ok9eW/oCZ5NuoM+pr0Z+W7G95hwRjUm0nmE0HF8cbeH74QCeEnYAZ1yy7Y6Okt6l7wOMcwJHXZLcNfNjSpt1FQilhkMEwoahoPR+uoLfInR3cd2hwVPZnqWT5SmWU923a0gGsD3sm+EJwIZ++dIKTvKBH2VfBUCKYH3nwVfyEi1tl88ywuzzPrqyoHCM4dJdzzFrgff8yTPzIeOq/RJgVg11tavYgbkQnpXEu8DyNaru66QJ0tOnp+zVsFnXXaKCh3r1h8+DyXO83m7mRS4+4m0NNiwRhrgoLiNuoyv091IGQNrrmP0bRzb5thASsDHO7bNQHot5xPRiDllbhL/VNdWOrJWL3vOCqlaoffgFdSccujx8T7f4FAl/aWDXB5+F7AkyhYWZXUjXjqgEjTwr0Gm1RQUK0D+vWjIUryer56MFHw8QiHUqv8QHeUz4zM0TqbsDG0xbh/9RNdKQrhurdSW5137R7iVSnriGSw8app14hXR1ErFTxEMorwZQ4IkXnIGK3sZ98BZRJAxqOortYMnBVPMdsk5hsFQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR10MB6290.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(396003)(376002)(346002)(136003)(39860400002)(451199018)(2906002)(31696002)(83380400001)(6512007)(8936002)(6506007)(5660300002)(36756003)(7416002)(4744005)(53546011)(86362001)(6486002)(2616005)(41300700001)(26005)(6666004)(966005)(107886003)(186003)(316002)(54906003)(31686004)(478600001)(66556008)(66476007)(66946007)(38100700002)(4326008)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YmZ3WVI0aUhDS01zdGdmd1g2eHhocm5wejVZS2g2Y3hqNDgwZzBLRTZvUm1L?=
 =?utf-8?B?OGhNZDNxNzNBNE85U2Q2THlFNmxjOEhPY0thY2lTZi9PL2dVUmljbFZUK29F?=
 =?utf-8?B?Z1hoM1puR0F4UStGcHRtRXpiSW9QVW1Gcm9pMDhUOVE4eFRlaXdzSkJybXhI?=
 =?utf-8?B?b3JJeG0xaW0wZCsrSkdXWDUzZEt6Q3BYQlppa3JEMjhLcU9lZWtKZGxBTVhi?=
 =?utf-8?B?eFNmVmtmbS9zNGlTcXA1dGVpcU56VCtaZ3A2aEcvcjRFaEw0WFJrU3E5WjBy?=
 =?utf-8?B?b3BJQVM3NEtWQi9mNWY3RGdXaGQ3VzUzQ1lHN3pzSGk5cVVFR0lObjFucitM?=
 =?utf-8?B?anRJWngrUkFRSW9IR0hrODlnbHd6NW10bTF4VUViSlJ1cE1YVnAxNVV2NHdH?=
 =?utf-8?B?RE1MS05KQkxBb0tGMlcvSDNTcG4zSi9pQ2FaaXZNc1EwbEJwMHVmaGdmMVhK?=
 =?utf-8?B?TmF6bGlZYVpxeE55eVZkQlZDMWduUTIzZ0hzc2JLUkJHK1RYWmIrUTI2ODlL?=
 =?utf-8?B?NmN2RUdIMGNLejRrY2M4UEJ1NzVEZjBMbTlKOVdGOXZBWDQyQ1NGOFRJcjhG?=
 =?utf-8?B?MWhIa0NwS0lIZlcyMlZ4d1ZaMjFXN2NxSXo4UnBObWRDRUlBSHhUVWw4QXRl?=
 =?utf-8?B?R3psaFBaZXQ3eDBLSXdienIrdHV0b1RwS3dJUlhvb0tZVVhwaXVHWWt3V1pH?=
 =?utf-8?B?TTRJMURSelo5THYrUUw4S28vd2VrQ2xndzVQMC9ON050Vm94YU5rQ0pOTTg2?=
 =?utf-8?B?bUttS1Jya1RoT2lBT0dBTlByRXNyaGV1QTJGZDlucURPcG9qRUNLNFFlM2tM?=
 =?utf-8?B?bkRJQXBwL2lGdVpzU1ZBRnk2cHlQcnFlTmJneFBhd0Jkd1lWTUtuOGR6Y0hY?=
 =?utf-8?B?VDJuMmRWK0ZML3RVTU5SUmhtRDQxLzAwY3BqOWxJNGFDNWpSakd2OTJlQ1lS?=
 =?utf-8?B?bVNJM3k1YUwvR2ZVZDVVVzVIQmFQdzJYTzY4Z3UzdklNb25rTmlBQ09iMnE1?=
 =?utf-8?B?RkpwamFPUWRnbjA3Q0cxQlFEY1l2MWFLZ3IydDRGLzZ2bXZEN0NhWUhpWUhi?=
 =?utf-8?B?TndVYVFubm1NV0pSK0hZUm8xL0VlSEhWVko2SFZPTXJiVlJpN1BQS0hyTkow?=
 =?utf-8?B?d2QzaEJsYVIyc0ora0t3NWxjYkNpUm1XT201V0tGRFhYWGhhakpiUWs2VUgx?=
 =?utf-8?B?WllvOGhqQnR3eTFYT0xGMHZqcU9Sa25hRnRYd3pmeVBtenpkblV6TDZSN3lx?=
 =?utf-8?B?Y1VxbWV5OC95U1ZIajUrS2d2aGFlWUhBYzlqNCtMTThseWpXY0Zhb0puQnRL?=
 =?utf-8?B?YkJQMlRmN0RyYUIrNWYzUUtHa0l3M3hqQnd6QldSbzQ1N2dGRXg5MVNkcTJB?=
 =?utf-8?B?RldFRUpxRFJvSjI2VWo5TkRGT2ZMT0VTOWlGbGlJaXJpcHZNWUhYVTNmWlNQ?=
 =?utf-8?B?M21RVWtqcTU0L1lzTGpOVXlUTVNoSElJMHFMWjdnTkJjb2VZS3ZuclE5NTE2?=
 =?utf-8?B?alVyaTJVd0d5QmVMTU5DeG42NG9iOEZCb05qYmM4SEl5SXMzWHNtVE0xYkhT?=
 =?utf-8?B?YWh3WHFWaDZRT0JvWk9tcTRTRU1yTHZuZjFUeW1idUgvYUEzd1gvdWxTT2Zw?=
 =?utf-8?B?VEk0UkZwTFU5bE5qb05pNUxvVWx5Ylc1MEhCZ1BmWW1YV2ljOVlDa3czVkhI?=
 =?utf-8?B?QUNQSjNpeDM4RFIyN2dOU2xxWVhNa05UY1dSaWtKV1ZSZytlVms0UFFudElm?=
 =?utf-8?B?YzYzbWNGck55QkVwMndsbEhwcm1jcjZjaDhsRFByVW85eEN0QjgyU0o2bHFG?=
 =?utf-8?B?bi9YU0RJczUrSkMwNTFoUWV4elFtQ08yRlBHNTg0UUcvaEIyd2Q1RWE2dm9M?=
 =?utf-8?B?OGoxZHpzRVQ2dnZQaVA4L1hqUWMxZno0VDJENjJoNWJzN04veGVBTUtXSngw?=
 =?utf-8?B?dHNCdkl6QzIxMFZmNG1aUnFpS29Ya3l1Zk8zU0I0V0p6UXA3alFWb2Rpem10?=
 =?utf-8?B?MTV0SURFeEtiTmJ1Nlh4alBTaXRMbnN2dkF1czlsU1JZeUNYNGpMUzVBeHpU?=
 =?utf-8?B?ekFxaU45T3RGZW1yVVloem1Bc1BSai9lMGNXbEFOSmJudHIraHExMUhsSC9h?=
 =?utf-8?B?VHlFRWJxbmJXQlQ5eEtVUGlPZnhlamZETmtvK2Q0aXhvMUFPWlF2QzdmOHMw?=
 =?utf-8?Q?Ri7bdXV9fE2xt9wQeDpQwjY=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?RjFHcnBLNWEzS2h5d1RtRFByL0src0kvRFExM3VKRmRwaDlVL1pJdndMODg4?=
 =?utf-8?B?eCtMWWNWbU9mNXIySUY5WTJqY2FSNXI0K2E4VDA0TjhEMkFOSkFhd1dlb0Iy?=
 =?utf-8?B?M3JqNWQwcTloZG5PRzhNMTJrSHlmL2tEVTBvUyswWDNXNFFDQkFKUDBmb3g4?=
 =?utf-8?B?M0lsYkdkOU5ZNXp4RDNyMktFa3loWGZyVjBlaGpzNHRicWtJam90THk0Rjh2?=
 =?utf-8?B?RE9kcHNwd0tJdnpZN0E5WUxRQWdYRlBJdkI2eGxsMjBLRXp3VU9PKzkvSmNC?=
 =?utf-8?B?L1cvbk9tdk9IVHI3Q2ltMzJJU3BDTEJWNEpveGFTeGVMMmJHbE1vemw0cWs5?=
 =?utf-8?B?eWx6eUZWREZQQmhTaEVReGZNVUhJN1VBREt0TmxLVmV2dGJhVVQ4R0Y2Rndr?=
 =?utf-8?B?ODZhcXVLSVFXV0VRU0tweGlNNHBqZXBYOU41RjRjWDI2YTRtc01WTGhTUW1U?=
 =?utf-8?B?YXZnWUc0L2ZVNUZjdkU0OWlDdXNyYXN4VUNYS2hpMTdiWnliSTNEZm9ZanNM?=
 =?utf-8?B?QVpERmdDdVVNRzFPclZreVFGUHJkQS8vMkNLMVBTclVhZERZSThZckh2Mm54?=
 =?utf-8?B?Q2REUzMvd20vejhRL0k4T083Tlp4bFhtVWdzWWNLekhXTmhCVzNldVh3T0kr?=
 =?utf-8?B?NXdiN3VDMnVyREJPbEltOUMramhadWU2bEkwN29FNXZ3T3FWQ3ZWZmpUMTBm?=
 =?utf-8?B?czB4Q0pJSzI2ZERPRkd1UFU1QXAxT3h6eU5MMEJjejZ3MDF5UG9rQlZCS21k?=
 =?utf-8?B?ejNpY29QMUVZQlp0T0U5MXRRL0tOeG80aXYxSHFWcGpDZmsxZjF6THZmUkhv?=
 =?utf-8?B?aGVvRnJLSWJPUkhiSjkrQ0I4NnhZMTcvczhLdDNCS1g0NjNvcU5raU9sTUR4?=
 =?utf-8?B?dU9OelJ5ajZjMlJ3djFkNjJvU2pmSXFMUWVncG9udVRpK1ZBbjhsTHE5cUhi?=
 =?utf-8?B?eFk0dmxTM1BWWm1WWUZvTDNONzZlNG5yWW9ZczhXQWplaXhkdTI4Y1BPME1q?=
 =?utf-8?B?VHNoTmRQK0RUWnlsbGlSeW5hRXN6TUViZy9xcTI4OXQ3RXFUMVpBbFg0cytK?=
 =?utf-8?B?WTREREp5QVJDUnBaRyt5Y3lzRDYveVNlV1F4ZFdpelhJbDhPTFl1NzZlK0NS?=
 =?utf-8?B?VVczd1JwNC9tUkg1MnZOTUhKZWozdnlhNlNvcVhTbEdoZlZLNHlZZUozM1RQ?=
 =?utf-8?B?VklOZldlVEo1b1RWYWp5ei9OdmlOdzZPVy9NTkViL0lqZTUxR0crNzY3Z0ov?=
 =?utf-8?B?dnFmcU54UjJtL3hUb2ZVUDlUeWNSWk16OGVoNVRrcWhmVGpHUUxkZ0taRXEw?=
 =?utf-8?B?dERRb1BMWXhpVHB1UTVlS1Z6WUlTMC85dUZKcmNoeTJnbVIxZHh1cVpKYkRY?=
 =?utf-8?B?aW9FaXJiSmNaRXlYeEUzckVnNVo5dVZ3Z1RLSExQWGNDSkp3U0lPY0k4VHAx?=
 =?utf-8?B?WTZDUVh2dFZvbXNqUW1JRStneURRMHgvSUVIVExEMzFzcnBKSDJGUWhhaVZD?=
 =?utf-8?B?bGw4VXZELytmV1R5R2R5cEkxc0JTekdicGZiMUNGd0JlL1VGeUwxWTdiUzlB?=
 =?utf-8?Q?IMIU/SGROkdt/pYjStF93JCEMPNcCn7R6a+3fjeoDW8qcK?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af960ace-4c37-409e-4801-08db29c28026
X-MS-Exchange-CrossTenant-AuthSource: PH8PR10MB6290.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2023 04:12:35.7193
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fJuC9NbQKYfHFwbm34tHJze+5iAs3b1BJYadrdErMsYqwTUbdcJDSb5v7j0/vSASTS+gQuuLxEwZpmTd87t0rH82dnUVBSbTbGSEuGEAbVifxI9Ll6IhV1uANS932l1W
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6292
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-20_18,2023-03-20_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 malwarescore=0
 phishscore=0 bulkscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303150002
 definitions=main-2303210032
X-Proofpoint-ORIG-GUID: d7K-rfZfGpImCRqQWLX-N7DMFs_yXqQF
X-Proofpoint-GUID: d7K-rfZfGpImCRqQWLX-N7DMFs_yXqQF
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

On 20/03/23 8:23 pm, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.104 release.
> There are 115 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 

No problems detected on x86_64 and aarch64.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit

> Responses should be made by Wed, 22 Mar 2023 14:54:26 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.104-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
