Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16A036B1E5C
	for <lists+stable@lfdr.de>; Thu,  9 Mar 2023 09:38:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229817AbjCIIiF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Mar 2023 03:38:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbjCIIhg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Mar 2023 03:37:36 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC07538B6D;
        Thu,  9 Mar 2023 00:36:26 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3297eZax010360;
        Thu, 9 Mar 2023 08:35:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=KhMb9/ZLj+Onjn3HB5D6tz/cdRLyIpJ1UYgBUptr4kE=;
 b=HkLjXDYWhf5SMAGwIi65QzQ5tdAunDAT5KX/JtNAh/ArkYFh6WIW74t9Pt2GWhWnfBFq
 RD6fxdSTLps0R2H7GjE5OSLBVYR1RCm7P1tUIPGxwzxD7yK3adkdmNPV/bDkdCW+sxxZ
 JzatIPv791/UWIaH4UaWxKsg4tKNTPGXd489nku0ZqRhGttwapAwLPF5+DvBnjBqEQQL
 XTy8FIdO5CrotAwuN7OzCmeGV4zG9uLWT6f58MK/y1XJA051l0A1L8M2ypQupcMVPTDV
 O1QIomTZHvOpd4ai/a+CPE9R7CxQFUOd/KH9JoMF0umB5x1Aw/lA28fNaotmZFUIQuqe sQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p4162214d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Mar 2023 08:35:41 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32985HLL026602;
        Thu, 9 Mar 2023 08:35:40 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2174.outbound.protection.outlook.com [104.47.56.174])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3p6g9uwdpd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Mar 2023 08:35:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nd92H0+K1kZScYKcH0tShhpfX7MUgThLaS0ZVd0W2irN+2uzxmyjSr+tPsNs7wUdkq/XI12N4NyF01lYCMi/QE5p3EIQhXHE8epBFmMRfYr1Rkckr9idKSf2VPaFT/jzZ9R/0QliKv56Em77ZAicy1tA6WomsMUbXYBmJSwKxQblwfX5VOuNEp0p+TolN5JDPo01yTp2mh1i9VaJBZuy3QHFGwkg4L2JqnU+1Y2bnsGW7uh+8KrM48Zp0QS84UyUAPojp/uJjVNFFRJpPDwJIFOS0ZDUYcJMqyVbp1+2lCawJGx0TijPNWhlLgtwt6v2ZkjaZMyKnzhI/ZbI7azC+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KhMb9/ZLj+Onjn3HB5D6tz/cdRLyIpJ1UYgBUptr4kE=;
 b=m7qYTtRR3PZASNNgviCUdB0u55WeeYLen2iFz/ZXPiFQSEvIVkr6dgf3pH7XXTiCcWTpR+llkgBzTmv7ynoECo+P9JvznjxMNeLNT3O+f+UD7pO5JMmlP1gQArEQaYSfrA4KTOs/fS4kWsOMtqo+QX3LxkAtRyNUVcZx4yybvI88/cdEXxAbFSx5xh2gVH7p/RGGe+N48SH0ge7eZhhgyAprw8XWZkhcKaqECmUpfdEUMx6E+tHOeWr2ywK7ap9xmxFnpyNC/aw3hHzPx+DtM4a0DOztlkNoeF/gyiFPjUOuv2RHqO6YFay1aDfYECr1GwJz9wkc2GJ479g/KFKTaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KhMb9/ZLj+Onjn3HB5D6tz/cdRLyIpJ1UYgBUptr4kE=;
 b=yewqGRYOhgBfS7gxuZogKNHa190Okkm8QPoFieLzLOnv83FRs9K2E/IjxWb+Pg7NF071McmtvjZfcxsEws/1XjhksxKQdODHhlzOWVcLREv8TWjktZ0PAuIBnzqcbRKwCra2ZpMzqf65WIaUCxT1hjJ9Uwzx3/9mMZmz03abWCI=
Received: from PH8PR10MB6290.namprd10.prod.outlook.com (2603:10b6:510:1c1::7)
 by SA1PR10MB7585.namprd10.prod.outlook.com (2603:10b6:806:379::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.17; Thu, 9 Mar
 2023 08:35:38 +0000
Received: from PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::ffeb:6d62:6636:6c38]) by PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::ffeb:6d62:6636:6c38%7]) with mapi id 15.20.6178.019; Thu, 9 Mar 2023
 08:35:38 +0000
Message-ID: <a6664170-6b77-facb-69d0-03bd6de60325@oracle.com>
Date:   Thu, 9 Mar 2023 14:05:23 +0530
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.1
Subject: Re: [PATCH 5.15 000/570] 5.15.99-rc2 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de,
        Vegard Nossum <vegard.nossum@oracle.com>
References: <20230308091759.112425121@linuxfoundation.org>
From:   Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20230308091759.112425121@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0023.apcprd02.prod.outlook.com
 (2603:1096:4:1f4::19) To PH8PR10MB6290.namprd10.prod.outlook.com
 (2603:10b6:510:1c1::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR10MB6290:EE_|SA1PR10MB7585:EE_
X-MS-Office365-Filtering-Correlation-Id: 9aaa0727-fab7-42c0-8243-08db2079422b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BK8mFLaE3AHuGHh4TcWWIEasahFCS+peqY8xgSUKAw1FX+GzdMfhidlMHnsLkp6UcXE+uoG+rFumlbgITQKeKctS8LAWJA9olskgq6MtX9smEYEpkFm7ve7K3KHnMqaQ+vLFRKy1OoJ7jM8SoAIPxwWNonsLSYePOFv2krHtPO7WQryx7IjbCkHgUaH/jpZj3TQS1ZD3gJmnGMFuNNp34JegaF0PFgCLycFliMw/smm9BrNLMV8CkB/Pmwx/K7FgYJ2qU6GuWs7KfM505Ni4jFlWVLB9m4YICborE5P9c7xjyUm3ewSMYEPgfFs1YPdif+pUclNcHEbnAXynK8TPeX21h6IUouY+87RjJlLjcxhbs0NPW/1qnCteOmTI8jxdAkeevD5c0Q5cak46I3lq30NAkwuPyrsCmTYE185fMmlCH7TkFIsEl1unSutWCQi2VAfzQRDzKkVsKMVowlOgmBagZfpnRO3vqbM2UOWhP4rzuMqVMl0MnqaZFum9PTTU+hDfCA06VTjXA3fK60bgSUal2lGI0mTW+S//otreD1ig2PuOZmNdM50XpotSt0uVEx1+NlE8tpkUkNEVDJh8UzDV8dFUKGfRqDMOJTvkEXO/A4WugOO1ZvWIV2ACLxQIONEti61OneN1dmE/d3anq6vUSXD84f2YIhaJztxWftJ5sEjSMAHFHq/uUXLZM5qLRN+gzbHTTus5CBctMmosV+V9QhJS0zTngIRNXg0FT78=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR10MB6290.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(396003)(136003)(346002)(39860400002)(366004)(451199018)(5660300002)(7416002)(4744005)(107886003)(6666004)(6486002)(31696002)(41300700001)(8936002)(86362001)(966005)(316002)(31686004)(38100700002)(478600001)(36756003)(53546011)(6512007)(2616005)(26005)(66946007)(186003)(2906002)(66556008)(66476007)(6506007)(4326008)(8676002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dm1TZEpMLzdsK1ZEblg3QXNtaGRvcWtlbEp2ZWYyYU80S0N3aXM4eUFtVjda?=
 =?utf-8?B?VXlyWVdQQW0wamxjOWxMMUpjWHlGWi9hdkhlSUpsTFV3UjFPOGQzckFoSEt3?=
 =?utf-8?B?RzhXZWFFZ080R0lUaXowZzFLWG9ROXJKbXhZejkrN3N3YnJZM0NoQnlCTngx?=
 =?utf-8?B?WHI3cm95RHE2MkpBRXlZdWtlWGxsTjV0VGxvaGd5NTBlL0pMMEZWc2pPVnNX?=
 =?utf-8?B?NkhxMnFRa0FNeUdzUTFzQmE4NGxCRVl2SWxmcGtsWFdreHZUemU4RG01Y2Zo?=
 =?utf-8?B?SWU3M3Q4cGFCRlJhMEhvRzhHWnArQ3ROckFvZGdIME52ZmVOMlhsU3hjWmNv?=
 =?utf-8?B?Rms0cWdIaGdXMnVVdTRzL09INFNHOU9Odm9UNk5GTHgycW9kNkkrbzErbEs1?=
 =?utf-8?B?eWZ0d25HWHY3dkdnOGk1V0ptYUR6dnc0UGRsQVJIMGtxbmtKZXVsK2xaUXFr?=
 =?utf-8?B?MHU0WHBjZnZXWk5WL1RPYVA4NmZaQWltMzUzVlRoeGtnZjBBbXNsWlpEaVlq?=
 =?utf-8?B?WjRuTGpMbXhpYkh4K3FuYUxiNzN3a25TVXo4TXNkT0tyRlk0UDA5eWFZNEVn?=
 =?utf-8?B?cEwxQ2tyeTJFNlZ5YWY1TXRoY2phbzV3TTdyVlZkR3ZYdFRYNE80NkR4RFY4?=
 =?utf-8?B?N1E0UTRLZTRmMEU4VDUvQ01YODNLOXZUS1dYRkcvMXFWNzJjN2s4dU1Mc1p0?=
 =?utf-8?B?NWRBcTFRRUJWSi8zSVdaMlk1WElma0o4c2VkYnNFYlUzOFZlUWRzMHdHRm4y?=
 =?utf-8?B?bjFvb0s2ZlFqclRQQ05UQm5NdUNCYVFGQk9PamRTNUtJYnNrVkRHbktpZFRK?=
 =?utf-8?B?NnV0aituZ3pHdzZXbTdsb08xQjNORk5qczkyLzVYVmVCbHBmQkZTTEtHZkFF?=
 =?utf-8?B?cUMrMk4xa0pOZ3hhZjNaM2ViL1IwbmhIQmNkN1hnaE0vN21GZ3c0TzRvSVlI?=
 =?utf-8?B?dVlORC9ZeXgzQ0FzQnJTYjdYaStvbm03SWsrcGkzTExpTkFMS2x2Qmt5TGtq?=
 =?utf-8?B?b2pSYkU3UXVNN0NzcUd6TVVPZzR6WHBzUC9memxEYjlVTGdqYk4rT1lreUtJ?=
 =?utf-8?B?ZUN6ZjNZTW43REZGUUhFa2M3aGJpRE5qT0lEUURVVm1NdnEzbG4xZWdaOE1O?=
 =?utf-8?B?ZDNIU1JGR3JGb0xTN2lveVY4WlJsK05TMXJ2ekVKak1sNEFxZ1A0MlgvSmcy?=
 =?utf-8?B?ZXlaM1kyMEJYSmxaRGVuL1l6Y1drVFRpT0V1NFo1bDVrUWlocFNMLzBaMExF?=
 =?utf-8?B?M1o3ZDRVZTZ3M2g1WkM2Z0RoWWNScWVTSFA2b0JlRk1LSVkvbHNLVVBLTUU4?=
 =?utf-8?B?ZXYrVGVNNElrUncxUlN2OXFkQmIzNVNoV2dod25lTDB0cmhkU1Z6c0s0S1JU?=
 =?utf-8?B?SFhsbHlTUFcxUC9Mc09QM2czeXoxU2JxKzFrdkw4dE5BQzBZMk04VXNiemFG?=
 =?utf-8?B?SElBakVZTHBQcnhXRjc3MkUrbWlZcS8renoxbUZzUC9HMm1qQUtMbW5hRy9k?=
 =?utf-8?B?NThoa1NrWmdvQWwzT2ZCTEsxQWlpTHdoNER5T2RubmtYWDMyZnBmNXQvZFZX?=
 =?utf-8?B?LzJCcDZvaDRtV05MQjJxMXdCNFJXVDJjMitDZ3Y4Q1lzY0RuSTNJeEtNQ1dy?=
 =?utf-8?B?aERwak9EQ0crNmYxdmtqeGlHYzFHMFVxcE5wQ1ZDekQrU0VVUkJ0N2FuOFFZ?=
 =?utf-8?B?NEIzUnNQWDJ0Yms1YmwzcFkxM01Cc1VEb0xMOG5hcVBqUWdHUWpuclNDaDg2?=
 =?utf-8?B?TVc0K1d0MEk1NEtNWkNXNndnckVQdGRYSE9vVlJocFpHMFhvUG13QlFqSU95?=
 =?utf-8?B?dzhNaW9DaTRCbWMyZk90Y0ptemJDNGV6ZWdkMmtudFRnZDQzeHM4M2lLYU9U?=
 =?utf-8?B?R0c3VXNranZ6bVp3QklsREErMGdDY25PWnJKSWwyU3BHNzVJcytRNE5tdWVn?=
 =?utf-8?B?MWExb2x0UGU1ZklXTi9vNkZFU3VxNm1lMUV3QzlhRXBuZUdCdVJ2eWE3eWZJ?=
 =?utf-8?B?K0tvck9DUVFHMjhpQ3M1RWhpWUxnaWlNa2RxOGtJQUoyTkE3eG9rQnVIL0VR?=
 =?utf-8?B?bzJncnU4YUFReHhRTTY1d2JuSE1ncUdEZWlCVFRlaXNleDlzUDJacUtFc3Uy?=
 =?utf-8?B?ZHRPbG1nMUMwcUlNbVNBOUI0bGxvdE5oNXVVeENzdEIzdS9OQ1hnc2pkZGd6?=
 =?utf-8?Q?bkdZIhNU9/XKGjCMKX6PthI=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?SEVMRlVjamZkSjRaNUtHaXJidXVFd0VFV1NBOEw0L0RNVHJ3ckphVlRDVnd4?=
 =?utf-8?B?VmY5YjB4WUVYUXk4bng4eEkxMU1XZnhwYVFQczVlT0pacEkxaUFodG5BMC83?=
 =?utf-8?B?ZXNVM3lzWkozZDV4L0ZSUlk1b2VtUGoreGdIS0RvQVcvWk1mOE9oT1hPNFpB?=
 =?utf-8?B?ekJtTjBmSW0rdk1NMTltR3pLOFFibm1XcjU3bThFdG1UOFhIT05URWVHUWo0?=
 =?utf-8?B?ZGNnRG9XWktKM1ZETW5HTUN1eDNacjR1WFRTMDh1aU9Na1drVk52WHVPRHNY?=
 =?utf-8?B?Tlc2UlNCN21xWWNxUlZWVmhnck5FaDFxWHJJTm5JQmlITDhPK2xRMTFEb2Ra?=
 =?utf-8?B?L1FJZHFHeEZjeVhJQU9aaG4zQk9nZ2tXN3BoWFBNOXpuQkljN2crQW8vSThG?=
 =?utf-8?B?TlJzQVlFejBHYjF4K01keEh3WUxmcUU1L1dTS3hZSEFlazhPdXdUM2tVQk5t?=
 =?utf-8?B?ZVZMbW1wL3VyWlh6LzdlRFRHdDhyYkJoWXNZZy95SGpBYTFHRjhHeUtTTHVv?=
 =?utf-8?B?S3VWYkNyR3FyRGFwcXljSUI0L3BjRkg2eXhtdHJwb2pvdVo1bWVlaGpwOHVi?=
 =?utf-8?B?bk1hT1cyOG1CaVNrTHJjdFBWWnVPRGVZVjgzeTdXK0lWUWNZSFJkQWF2MHFr?=
 =?utf-8?B?SzVxdkxSb2x3NDNPT2pOWGkvWVBmajVLcHJield5YjZENS9kRjNHZDRhUG1D?=
 =?utf-8?B?ellFYlBkYXpLQjQzQVVoVVoxb2RwRkZmc0RsMDZlT0Y1VER4ZXdjWGNMSkw4?=
 =?utf-8?B?dnp3bXZac2xjV1VnU0dQMCtFOUhMOXVhQXZrL0hOOG9QcVpSbkl1R0M5REMw?=
 =?utf-8?B?azZLbTAzNGE1QzBjNVlDWWQrdGd6dzFISklOeGRuQzlodUNTZHBDK1hCRFAw?=
 =?utf-8?B?MWdsbUZSdUN3WllyZUxZMmlQSi8zUUw4cFIwb2tEWHVaTmpZRXdONmY0Umly?=
 =?utf-8?B?UW4rY3ZVdm5KUnpnWDV6WVVpZmE2Q09jTmZRVXh2TkJGV0JOUjlpQ0NpS1hk?=
 =?utf-8?B?bzNJaENNQVBTLy91clc3dFZpNTRGNUlidmYzRmJwQk5PclQwRytWWnl3VmJ6?=
 =?utf-8?B?VTlKeS9CRC9Nc2JPazVBS09RNEhtSDNVcHFMRWpsL29aZldOcU51ZHlrUTAx?=
 =?utf-8?B?Qm9zVXo5L0tBZmdOL1dGZWd5bE14cnpLSlZwbzdHSGIrZjJHWkMvUHdNbVd4?=
 =?utf-8?B?d3NFWklCUWFTb1hkZjVMWnVoS2ZFdFd3Rk43Qk5GUXZZQUk5dzBXdHhsV3Jx?=
 =?utf-8?B?dmlUajA4R1lPcU9PeDRVUTg1Yisxd0JzWHVrQktraEE4eUtoYy9TNWl0RGMr?=
 =?utf-8?B?NFp1QTFkelJ1WjBFMUJNUnJjNm03VEpvTWliQVdiRDdoZUhJb2hUbXR1dlJT?=
 =?utf-8?B?M0NtQWJFQ01aSStvamlnQVB3ZVBwVk53OHpqNy8zNkRiSHovOGJaQ2lXNjhZ?=
 =?utf-8?B?WXgwd0ZQYnp6UUdFSlF6UW0rZ21rSHYzaU5WUEZlR3lqb21pRHZqRncybTc4?=
 =?utf-8?B?TTVtRjdoczhOemxBL2grN2I3VUhpRU1pckNjc0JycEVtei8zTy9YWk1yZnAy?=
 =?utf-8?Q?9gPfvaLyE0DG/Mv+IZEvttlDogMjdBdUfE0hOKeF14UFUG?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9aaa0727-fab7-42c0-8243-08db2079422b
X-MS-Exchange-CrossTenant-AuthSource: PH8PR10MB6290.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2023 08:35:37.9304
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PcTyoQPsyCPgGV9mLD+bKk+hFkyQYxkQRYvCE44j7ixQumgBG8SPuxQHfOJByRpOY2YX9emYVcgko++3rMHV6nr7hGPF9N0Ipg9YJmsECqUkhiseq86ZR4vwETsDM/oT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB7585
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-09_04,2023-03-08_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 adultscore=0 bulkscore=0 spamscore=0 malwarescore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303090067
X-Proofpoint-GUID: -XDY42AkwbsdD2nQXSNHnA760pO41odS
X-Proofpoint-ORIG-GUID: -XDY42AkwbsdD2nQXSNHnA760pO41odS
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

On 08/03/23 2:59 pm, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.99 release.
> There are 570 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 10 Mar 2023 09:16:12 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.99-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

> thanks,
> 
> greg k-h

Thanks,
Harshit
