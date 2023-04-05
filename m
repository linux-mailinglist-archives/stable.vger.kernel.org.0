Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86F5A6D7429
	for <lists+stable@lfdr.de>; Wed,  5 Apr 2023 08:09:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237028AbjDEGJO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Apr 2023 02:09:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237038AbjDEGJH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Apr 2023 02:09:07 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 375BB49F1;
        Tue,  4 Apr 2023 23:08:58 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 334Kop4G003966;
        Wed, 5 Apr 2023 06:08:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=QIM8H8yVNOhta2zq1/zW75BfF/+DqX0tcPiwGMjLVQE=;
 b=BdDcoIDLJb4Qhnur8otIaKU9kPJfb1c1p9VKlIMOsxBc7BkXr7yYj81A8g+n/UJeowG9
 /QNEQkRjvjnQC/l2+eEPrwIianO10LQhRT9LcWSMvbmSn4Fooq3b7/qmDBTQPnKfoVtY
 wSFTkGSufEPfoOzT7JiQNS3+G+Kkhum0IPoy1JpsfAJFLrrL8ubxAjdWeQF4nZ2YK4XV
 s/7+T1/HQ+f4X1F4jBuFYkanAjNUrAkTuCd8iuX1XJSZ8Gyr38G1ykSIznnLi9QQsM0D
 1Ff6d0lw5YeLy612iVBMZFbU392O1fPRk5JmclBSAdN/6iWzVrOsivdKERdajQrUTi+X /w== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ppc7tyfvq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Apr 2023 06:08:25 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3353cCoH001606;
        Wed, 5 Apr 2023 06:08:24 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ppt3j461c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Apr 2023 06:08:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ma9BdL4kW7w6LXgcwJx5ltQEoV2OSK0sko7s/62Gi4BuVGi0V11HuOqCnBujrJzB8Hzb99H4LCT7L96AGtuAOJLfOtW3TdiZ5tfCG/C2Y376ndKZzcuR5nfU3u657our9Cr8AfUfiNLXCm/BHz69YH8vBjF/3bFxCmpLw7rkVytGvuCXIPIyV6+9iFl6bYA7T0StQcoMRObctY8Ct1avKN/Dx6dfSxu0iNIsXI+zhjG2KkhEPMe5einf2ZMhRfkwMBg8ilRxHIAFfEenDHcCHtLBNwvMJ4/LqzXdC3fIOPdjUVCZmdhjDrN6TXqJ5PnuCP0UBVGHqU82zsYAEX8PWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QIM8H8yVNOhta2zq1/zW75BfF/+DqX0tcPiwGMjLVQE=;
 b=DXYChBw1N0X3USwKvLMR0VzdpNXccLh7KnesTB9ju0Pc00c43XbLn2cl3Q8z4edpBppHxMjSPp+xrpDbRwCcBrKXOqHrVjVCG/pOeN5m4r+O8Sysk+kafwvgh8f1JAY1WjEkVO7AjWuURwP67ejlhGC3QRQspOkfvmf7OSJ7nHZuhGae4CvN9LwS0LHKODJ5TuCPZSCyqrcx1c/VsANZ0S3nwN7awdVl4TODgcQMs/XWQAlLP+zNYgwpdGVAV5j+HoCnDBhFP1be5SJq1LKwX45/7NbAjtdOyOEfCcn6E5ywl7eDMavpX2V9DpqaZIcBY+MEt+gb9Dq4m6E9bh6Gwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QIM8H8yVNOhta2zq1/zW75BfF/+DqX0tcPiwGMjLVQE=;
 b=QVsfgM7RyARCbhKuAoaNtUVNGe+QLr4amOhrBISkTAlLLvVVuEhnJM/0Wj+Fkkb/yYsI6KpgPTwjJ/Gf/vUy+2o7y+JEMiEuw/QMGwlI3DznA5wuOdvDSo3FV4sd8954hfJblrh7b3a92PViQrtRsMp/fhu1F+OfgovZ2vff0+o=
Received: from PH8PR10MB6290.namprd10.prod.outlook.com (2603:10b6:510:1c1::7)
 by DM4PR10MB6768.namprd10.prod.outlook.com (2603:10b6:8:10c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Wed, 5 Apr
 2023 06:08:21 +0000
Received: from PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::fb63:990:eeef:ec00]) by PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::fb63:990:eeef:ec00%8]) with mapi id 15.20.6254.033; Wed, 5 Apr 2023
 06:08:21 +0000
Message-ID: <17fcbc01-e13d-ed3c-57d6-e027d6ec00f5@oracle.com>
Date:   Wed, 5 Apr 2023 11:38:09 +0530
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.1
Subject: Re: [PATCH 5.4 000/104] 5.4.240-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
References: <20230403140403.549815164@linuxfoundation.org>
From:   Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20230403140403.549815164@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TYCP286CA0195.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:382::13) To PH8PR10MB6290.namprd10.prod.outlook.com
 (2603:10b6:510:1c1::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR10MB6290:EE_|DM4PR10MB6768:EE_
X-MS-Office365-Filtering-Correlation-Id: 7dce71fa-37d2-4143-a071-08db359c2894
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3zDW6vhX4ugSmylpwmHkUY5JcmwbfTaWFwOi1VmTRhxxAhoayx7Xv8A8W7PLZiY9yCa97cnhPD3jWPzrmaquAIdPqaYdI4Gf3uNBuqEWedC32uFBQtUKgyF/OlQUowEHHAFjwNUmQyC9A+s6BlXzDa1dlNZl1YWxMy5zqjtIDfM4wtlPsBX1mQH4EXW7t9N9l2g1QUKTSHT64pHKIFVvri+sLYEeRVQL7cUDBAya9yeNd75DJ41bM78Ttk8xezw2kEkhkXG3n4pU51GpSecso2AYOOHJu6GtQlRADPVtrgYtD3+MaFuVP82w/lZZSXwJvLWdVfj4PQUOIjXzz6NRcx6zxF7icJWCTHpEgTzKOXnuhlGVpC6OApqOwHY/06rFzkQMSZ9th5/bxLVceIlGHbmTr1I2WfqINHd3G4F1YhRRAkoZUk6lNyumQlNVHupeHlJo9ghPwSe8VhbQVnT6c0XcoC4Qee2H1acExOLbzYLwLYTmxorHLQbxWdlCvHU2zs5wAWC/wddQ9v0vDaPDtGpD4kyMMJmcMKbAw0mg5zd2+MK9NzK3D3AeTvJSa1McdJnBy7cIi9w1Mx+LNe3UD2M34V8PoNX0AggVDhOL/2mBlqHuVlZXIe1AVt0QoRzwJWEyjJaunCIePtctPpSy/g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR10MB6290.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(136003)(346002)(376002)(366004)(396003)(451199021)(31686004)(66476007)(6666004)(41300700001)(66946007)(8676002)(66556008)(4326008)(36756003)(478600001)(38100700002)(316002)(31696002)(86362001)(6506007)(6512007)(26005)(186003)(966005)(6486002)(53546011)(2616005)(5660300002)(7416002)(2906002)(4744005)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VTJ1YkZKdWNCSnlEMHRuUVJWZ0R2QzBKVjFVMzFJRUZtRGVWRUJjeXcxWWp4?=
 =?utf-8?B?TWt6ZzNYQ1h2U1o1dnVGODM2RFpBRFZIRnVCM2psTk1TKytWT2dobU1DM0Fv?=
 =?utf-8?B?SkhnWE5HaE9LYXR1MTB1RUI4MFNwM1NtRkhSSEI3UDBTeHJPajZMTEhBQlRV?=
 =?utf-8?B?M2FyMGdFMkRPdEdPMlV0UzFDRDRVWkdGZXNORnZkM3FpUXRLempGd0hvMUhs?=
 =?utf-8?B?RmM2QTkya3MzdzYzQm4ycStWc0lqVVRIcUNlQUcwREk4SGRETmpMbmwwd2NW?=
 =?utf-8?B?VWlFc1NBWVFXM1pqWVJHeXI0QndHcG4yOGtqcnFIeFM2L21HQTJERTRuVmtL?=
 =?utf-8?B?UTdZTmRPemZ5dmVqNStmMDY3U2JlRHQ5Nnhtd1BXSDlRMllseER5RThCMkJK?=
 =?utf-8?B?QU1NZnhLdENNM2NDTnd0YVVhOGZoZWtuZXJ1Z09QQ1NPK2U2Z1V5cGtYNjdq?=
 =?utf-8?B?RVQxWFhMeU12d2dRMkhvbENKY3ZhMXVSSnFoQm9GM2t0N0dKMWM4aWdPbytP?=
 =?utf-8?B?QUZCRW9ob3plN0lKN0lYUkc3VzVPM1dJUFU1UTBhbzZMZUJncWxJQnFpR0JJ?=
 =?utf-8?B?M1pVNTNoTlJpNkF6ZUtGZ2E2VE1jK0o5a0YxbW8vTHgzNjdoR1J3UE96b2V3?=
 =?utf-8?B?aEpkb3ZrVVF5UXg1MlRzSGNGbmtIVHlWMVdMWVBDQjJmKzUyU2Zqb3dnZkg0?=
 =?utf-8?B?WXpxS3prVVVLaFQ1bXgyS3hSN3ZmeWdDNC9JcFRFbEFkd3hpU1ZhbjZpbFRZ?=
 =?utf-8?B?aVN2WWY1UjJTTHpqVmlXMFE2dWR3NWpkeFY1YXcxQk1VN0xpNURBbFgwdm9y?=
 =?utf-8?B?ak43TEFZWXdLMmhUMFc1S0ZDajlEVFdjUms0V2tkMDlOVWhWV0N4NDFzTVE2?=
 =?utf-8?B?UTR5WnJOdGZHWWhlUTdCQkFCajFHd3VsYnZjSE9mZkFqdFUyaU10M2M5Smpr?=
 =?utf-8?B?TVlPVkkrWFZOSjVOT2IrNktVNGdTNTdzM2prdzJMWkhETlE2NTkrMEVoemJv?=
 =?utf-8?B?QzBZNldaMFUrZU1hM2FtdU5GRkpNdFB3YnJmQTRhVExSMVVmQVBKTEdwaFRx?=
 =?utf-8?B?L0JSdEFNc1R6bG1GQ01FaEc0QjNWOUI0UmdtNVZvSzRLUzE2d3FtZ1FkZ3Bl?=
 =?utf-8?B?amlxTVJYZFRiV2pZSmxtcFFjQXVMbXRBaFc1YUJJOFRYK3A3R1hsNmZOQjJM?=
 =?utf-8?B?UkZsdWh5UTh5NkhRd2FmQktncWJGdXZjKzV0bTN1MGN6NHRZTTlWaEhEM0t3?=
 =?utf-8?B?SXV1MVArUzZYR2ZHSGQ3TzBOeDkrSytSaU9iQVF4UXFjSnZBdUNNSjZOTnNF?=
 =?utf-8?B?WnBJNkloMENhT1ZBVEZJRXpnRnBWcnRVWVUvTjd3emlaNEJ4Z0o2d09TY0k0?=
 =?utf-8?B?RzlXdUpYYVdCWkdENFFIdGJHWXJCblIrRXBxa0dBTHgxeE9IcjhkRDk4UFph?=
 =?utf-8?B?cUd5L3hzZDZ5QXMwMUlEYXBzTWFZc0RzTkVKRGpDVGNDNExReldzdmZjYklw?=
 =?utf-8?B?SmlnVzRGclVGQ1YreTZpTi9XOUNFaUZpNy9NN0hlV3lIdHRFcWpxVUttbEFr?=
 =?utf-8?B?RkdxTmlQR29SYkIyZGZId3grTytGMjU3Y25SS21qVkx3RTg4WmFMTlY1bm1L?=
 =?utf-8?B?K2kzTkpGTnUrL3V5bkxwN1N3cDhyUDFpaFIyUXNOTEhhQUQ3RzhiZE1GYTlK?=
 =?utf-8?B?a0J6YXg5cXdaNWV5UUlFQ01LN09tanNIanptemxwM1YwaXU5RVBXR05acmJS?=
 =?utf-8?B?bWN6Z2FpcUVleDVBVHNKU2h2ZGZvdkdGbkx3M05BYTFLdkxHeEFLOEExb25K?=
 =?utf-8?B?MUExRDRQaWsvQnpyWWNQMjAzQ2pBZFJ4VU4yMnFmcHdoT3JMZENaSkpyZTZS?=
 =?utf-8?B?c2crVU00VEJ3bDdhUExxeWtvd3RZc3EvM0szQ25tZlpwQWkvWG1EdGU2L3h4?=
 =?utf-8?B?OU5MWjY4Zk9yWjRQNUpUUXV6aC9kOHRUajlSdWt6aVkvUXRJVXBYZ2srOHBJ?=
 =?utf-8?B?ZHhUME9yWGk5dlpkRzVzZWVFYisxNVlobEdnV1M0WCs5SitWTWt6NFdvZkEw?=
 =?utf-8?B?VUdBUk9oRHdwcythQkx6dkwwcXB3ZjNQdERsYVc1TitHRmNnSjdycU9Db0RT?=
 =?utf-8?B?eTVFdTVrZ1BublZmYnRSSVlYNjlkdXVMU0UzWkxtd1pFUENENVo0WUZsSjlh?=
 =?utf-8?Q?AJcm6UrRV4fkyzBmcxq1SqQ=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?YXlFazlQMXk5THpsUGZlTFliQXUvMEpXTjVLYk1HUUo1bFZQSGtYUHFNQ3h2?=
 =?utf-8?B?ZWlsYldsTUQvZlJDR1NvUXdZWENHNmVZdDhqaGtwU3N2dmc5MkdaMlRzMnNQ?=
 =?utf-8?B?Z0Y3WnlGUVk4QStNVHFtY3JGM2JIWlVFRlBLaExrQ0Fyb2dKMFNoci8rRDJU?=
 =?utf-8?B?ZWxxcnFpUGlrVWh1RE5HckE5THVNRWVzWEtERWFldFdqVGpMdEZRRDZQTFBM?=
 =?utf-8?B?Q0w1Ukh2Z09yVm1kdGsxVjliYm9qUjA0eWwyNUlrd1BmZThSOHFSeGxzTzNB?=
 =?utf-8?B?Z0hVelBMR3VOTVZvMzNOUVJKdDNvYnZ0OGV4SjNEc1FCUGlRZGRLZ1A5Z1Rr?=
 =?utf-8?B?MDF5dGwxWDBjZ0RqK1VjUGJ5U2sxS1B2MGgrRlE1NDRGbWt3b09KNHQwSDE5?=
 =?utf-8?B?QXNnUmdzem50QURrb1NnalRrMFJ2ZzNRYXVSR2JpZkhqYmFtY0c5TnV4R2lD?=
 =?utf-8?B?SHYxMzRoVkN3dFppVnlxWjNnN2sxMnJvUWRKVThnTHVVRUI5NE0wY1YvOW9p?=
 =?utf-8?B?cjgyc0NFbU5FekZBdXcvUG1rY3ZCaThVc09ZdEZVOHkva2NDUTY2dXhVRnlZ?=
 =?utf-8?B?QVZTWHhkbzdFSitObTNyVVExTG9TblpYdUdoSEtMY3A5cldQTFQ5dmFaNEhV?=
 =?utf-8?B?cHRwcjQwN3NRS0d3K3J1aUpyajNXUXU4RHRNWGFmS3FpUFVTNzJZTzEvWGd5?=
 =?utf-8?B?NTRCNzNDUFQ5M3FpbHFpa3BScEl5eHlBcnVObk13dlovTGorNmtPZkNCd2s3?=
 =?utf-8?B?N3MzeU4vdE5pd1dOcXBZY0RLdmlVbG14U1pTdFJ4dVdySFlkUWtubkdiQTNa?=
 =?utf-8?B?WW52a0JmQkVFcCtVcjRFNld6MEZSVFViSE9WRjUwTDFVTnFDSGpBamY0SHJn?=
 =?utf-8?B?STVMQ1lVanQwQkd4NmJENWlLWkRRdXpXMHU3MlBjM3RuSDlHT0ZmdHdkMHFH?=
 =?utf-8?B?TXdXeDhlT0tQbVVOL3RLaEVkeUpYcHR4Vm9aODNmNjNTMHlsK3JzQmU1cHNZ?=
 =?utf-8?B?MGhzRG82b2krSW5ZcWRhUUl1TmJGRzlLRFlPenpHMHYxRjlYNkVCRmxVbjJ3?=
 =?utf-8?B?YWZGdXo2SnpzZ05ydGxtNHl4dnkwNUVtSEhhenBCOS9DZENtTVlrRG5OUklT?=
 =?utf-8?B?NzcxeHVWcXZGbEE0RmxzVXBWWDRRNzNqN0RQL2dMSCt5Tk8wUEd0M1UzK0hv?=
 =?utf-8?B?ZGZTaUwwZUoxQVRITjJVb1ViS0t6RUZZY2oxSXloN0tIZy92V1JlV0tKbC9R?=
 =?utf-8?B?eFdwaE1SMWpnUXVsenh3enBXRGlNcEJlWEVuWlJ4dTAyQ3p2ZDVzMWw4YzNx?=
 =?utf-8?B?anhZOGNSUWdTQmlkSGlRWTVHNDNXcWxYSHFaU2RBN2JveklRMk5LSzlGY2VW?=
 =?utf-8?B?Q2FRZmtHVWt5aUxqQnZscEt6ZjZ4MjNBZWZnRFZ5MzZUdVk4K1ZROGkxVXhG?=
 =?utf-8?B?RmdGeUJaeWFtVzZ1ZitUWEl5OW5zb2dVbG9YK3c4YkFVWWJUUUI2KzNvc2RI?=
 =?utf-8?B?ekJZOTA4Z2dtUTJGUk96SFBSOVZlY1JIYk91TFpxYXRNZUJZZTJOL0cyZWtR?=
 =?utf-8?Q?sYodgFKrfWGOo21mRkGXwi3BEsXf5BsHSbFzRTEGt3Z+wC?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7dce71fa-37d2-4143-a071-08db359c2894
X-MS-Exchange-CrossTenant-AuthSource: PH8PR10MB6290.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2023 06:08:21.7702
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jtDKDmoLfJ5ZcuFllUY4fIsgTFuHFX4Bg3LkdlGtMWYUVOdFpy7mPy2/Pak1xfKjZbVWXpzOFfNtptoYoK0RB1p0FSrqTM7OPt0lSPeiE2nykVtZUvaHBkJo4bZL8bSn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6768
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-05_02,2023-04-04_05,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 phishscore=0 bulkscore=0 mlxscore=0 malwarescore=0 mlxlogscore=951
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304050056
X-Proofpoint-ORIG-GUID: VqrDSX-ZwIujow1hHfGobTCoj3enCvSu
X-Proofpoint-GUID: VqrDSX-ZwIujow1hHfGobTCoj3enCvSu
X-Spam-Status: No, score=-2.8 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On 03/04/23 7:37 pm, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.240 release.
> There are 104 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 05 Apr 2023 14:03:18 +0000.
> Anything received after that time might be too late.
> 

No problems seen on x86_64 and aarch64.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit

> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.240-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
