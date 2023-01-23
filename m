Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AD296786A6
	for <lists+stable@lfdr.de>; Mon, 23 Jan 2023 20:43:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232582AbjAWTnT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Jan 2023 14:43:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232762AbjAWTnS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Jan 2023 14:43:18 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DF192A141;
        Mon, 23 Jan 2023 11:43:14 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30NJOMiG001820;
        Mon, 23 Jan 2023 19:42:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=corp-2022-7-12;
 bh=HiNcYWa2wSmKcS/i5bDlVAxb1ONhF7uR8fO5QQ+vcHg=;
 b=A3W6tXihQcx33hBB4MY5HlwNQumnh6kOsrfwm4M231ZzuDge38s/t4pm9BdfEKv1hCRf
 EYqgu5FiLfQDXPh5N2iWq7jJYw/coB/XXWgKszK89iOJEGBR+sxcr0J9X8lxYbPVNpzy
 1UQ4CpFmvkzP3GmlX7LOMCbj/czikBfOsZxHDwcCVKmnIS+ne8L8dIStwAUQbGaqkzKG
 0zPfWUGzsfXGC5Jya6AMDvt93sIHFcxRoA7NjpPfOwJcEkFwTzHMvwD53CI6oS0Iaw70
 Pyzs7L9nV8zHqf7c6BV7hXcwB/B8NmMA1FnI3ds7pvV+fyeaf6pLrA9sgEa8S+doW8OC uQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n87xa3pu5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Jan 2023 19:42:28 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30NIsT3u011637;
        Mon, 23 Jan 2023 19:42:28 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2170.outbound.protection.outlook.com [104.47.73.170])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3n86g3g942-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Jan 2023 19:42:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=igmR/FXLQVsrngZS3CdhfRpxZFhaDTvscVEInH7ehgfWYY2w97FWblFYO19ZpDVNowoEoui4SDwo0GZHsamOeXJRPjHktWWUqGl4wjwT/YOMHhdsRBJLNbKLTQJru5c2/SlI7iK+IAy4u6ZTRRw8sXomi2YVDZb5+8GrJBG0w7yG1uQLOJe/bVm3Lws2rim7FAAvqpDV7xC99hvEvMxj7pTWiBPBGRdlZRhAvr5z6iyXjk5dca1lvxxr/lgNAsB304M9E2Wxyeoyb2wrVesgJ8Sz/afrBDKs1XH1Y+ACEChxYoKKI1g7qlfFKLgjGoTRZdxz3Rz1HV+Fy4AiVZYkkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HiNcYWa2wSmKcS/i5bDlVAxb1ONhF7uR8fO5QQ+vcHg=;
 b=e2/tS+TR+dZk9q8duY6beAMzIu9MFXC/bO6DEfJjdyH0Oo+tG5L+/9jp/m63hs1u1kGHA6sL4j1IbEaRXVkx0zSqLWiKdwbKB+EFazgJbeL44KLUDzb9QrQnl0+Pk79XzQuinlq55hY9KMfkPSbVOD89AK52s/lRC7VDJKRFbfhUDmjgtUPx47Kff0rylBjaUpACNzNR7D1cQ6xhvlJuFNwdz1at6wjUojswIarnvCxyziTtLEyEYuGkkQ5s0MLlRvCzjBXIeBrqYrRsSYcgfek+ToXTLge1OSngYxo340+m4UD4f/WJAHjAIDPfIvVLsbcNQH7wvv6YAj10UQzUyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HiNcYWa2wSmKcS/i5bDlVAxb1ONhF7uR8fO5QQ+vcHg=;
 b=NY12Rvm/Km+5s/3KEN6knIS/gP/vP7xBf7y45t8yp/Z5dp+0/9uBeOAXzmtML77JOf4nW4AYDlzKzLm6+hDc7YFUP03J+JiYTKD88iesZaNCiujz/WsNU7e5y/C5HN19QVACXLTeQPqlNocXD49jjjO2dUOTiyt+faGmCuliNyQ=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by DS0PR10MB6152.namprd10.prod.outlook.com (2603:10b6:8:c4::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.6; Mon, 23 Jan
 2023 19:42:25 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d%6]) with mapi id 15.20.6043.014; Mon, 23 Jan 2023
 19:42:25 +0000
Date:   Mon, 23 Jan 2023 13:42:18 -0600
From:   Tom Saeger <tom.saeger@oracle.com>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Rich Felker <dalias@libc.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
        Masahiro Yamada <masahiroy@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Dennis Gilmore <dennis@ausil.us>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-sh@vger.kernel.org
Subject: Re: [PATCH 6.1 000/193] 6.1.8-rc1 review
Message-ID: <20230123194218.47ssfzhrpnv3xfez@oracle.com>
References: <20230122150246.321043584@linuxfoundation.org>
 <CA+G9fYsS1GLzMoeh-jz8eOMbomJ=XBg_3FjQ+4w_=Dw1Mwr3rQ@mail.gmail.com>
 <20230123191128.ewfyc5cdbbdx5gtl@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230123191128.ewfyc5cdbbdx5gtl@oracle.com>
X-ClientProxiedBy: SA0PR11CA0142.namprd11.prod.outlook.com
 (2603:10b6:806:131::27) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|DS0PR10MB6152:EE_
X-MS-Office365-Filtering-Correlation-Id: 9304aea8-3966-4429-ac3b-08dafd79f3e6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: izsIZ3F17DVXlgctvqsSEUEYnhPOU9K8KnxnGkG+2hpGnU/Fon8IyEevuTaInXf5fqBIfuBcn8bDp+a2+0Rj8X0Ycw6P4+2k1+W42cha1McY0poKoRsRtAz71CTOw3uS2LJOGgtclxq5X3uJvjW8ovybHQzlC6BhsbsKVIaTY/uenjcooIsKMAFSAIEdEj3Q3tDgGiup6qeMzmQKOYA70Hn5z+jS9oFtuag/4eJ/aqyhu9N8vIoJLylyAAnvZURhbxpAV9bXX+JgEgxEVPfa+TCku53nzSDf1W39u9J20YM5plO5phqJZPHYgcnq+d/Ydhaac2XX0eHgxm5IiibGrl9klM5ZRQIWpwreFPA7Ygz7iAoTksnLEIDRn9Ch0Wx9O6sYcm3utEEaKdqYiGjJxCiK7l9cgYSyaz1j1JxhmMTXoAPBGrDupN1ja3UTF2ji3Y7t23OYFviMvCFiP5KNlBsQdEdAMdZ5iMwGG0tRz1Wv6DWcEIYpMtNQn7uqG1xoZ6uQfUKPj9eDconmM2OF+cxSL0tFNR1YCoZnCfUXfNZlvHGkF6UeIWd7dhtVvZ4fFpgXCCdh0JeYkOutgvpmItepIf6HISA1OAjV5NHHy5ODmHmFOZaanVIPfTTpaE5hjU1tOacPgxNd7ORJm09n2VOZkSo79VElVLYkD841fN8H8xFPyHa+rZssgD/jhNYVIKaslp+9B2Ii6W6NO2exmw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(39860400002)(346002)(396003)(136003)(366004)(451199015)(186003)(26005)(1076003)(6506007)(86362001)(6512007)(966005)(6486002)(478600001)(6666004)(66556008)(2906002)(36756003)(316002)(54906003)(110136005)(2616005)(66946007)(4326008)(8676002)(66476007)(41300700001)(44832011)(38100700002)(5660300002)(7416002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Yzc5MER0WFR2S1dWUzFJZ1BaM0htN1dIK3ZYekx4TVJtcGRaajVjNHRBaVpL?=
 =?utf-8?B?TnBQRnJJMGg4K0tLbTgxdzkxeUtuUGxtNEt4OWFubGpBUkpEV1VXR09FWGM0?=
 =?utf-8?B?WHdSRFZqWUJETldGc0RHRUZZNFVLYUlGdWY3cSs2Tk04QmE4WW1keXBMSlRB?=
 =?utf-8?B?Slp5dCt0TDhtaEVZZm15ZVhmMWlkczdCeFVFK0U3b0RjQnJYUHJCd3pTZFFI?=
 =?utf-8?B?ODFtSXhxNEZXVmNXZkcrSklaUDNBaExDQ21DS0wrVUsya3h4K01CU1UvYWlI?=
 =?utf-8?B?SEk1Y0Y4UGZwUGZtRTZhdkhtRWxTNGRYQWNCcEJOUmpSeVpNbStIRVFkY2cw?=
 =?utf-8?B?WGZQRVpOd2pPWVY3UEN3VWlwcjdQTVpHazk0clQ2VVhRMVRUdFl6anVVR092?=
 =?utf-8?B?Vys4MDBSeVF3dncrNWZScGViLzlPRmQxL0lUOXJIemw1MGZoWjBPdnJMLzlq?=
 =?utf-8?B?QzE2akswVGwrRVk5UG15VWtOMXBTa00vTTRLWHNtQkRvNDBkMEVwOWo2Q0M3?=
 =?utf-8?B?MEQ2VGo5Znp2M0xwZG5Nbll1TFVJT2ZVUUkvS3ZZWXlTTE42NmIzTTRvUWVM?=
 =?utf-8?B?bW45aDdTbDhPWE8zM09pemorQzlCT1JZSVAxeld5MG1Fa0tlT2V4TjRreW8w?=
 =?utf-8?B?KzVvYXV0U1dYbHBUL2R5bUFCNW5iRzdVcVVFTmZuOW1NWDJvTUEyOEpmR3pn?=
 =?utf-8?B?c25oZE1DMXk2QlVLMGtwcGxQMUZYeGsvQzQwS0Y1WFlhS1grWXRzVGx6SDJk?=
 =?utf-8?B?UDM3K05NaTF6bkpaMEFlNlFaSG9Dc1dFMUFGckcrellHd212T0pFOFZqQ1Ez?=
 =?utf-8?B?K2ZycnV4NFFmN214cGxOSEdLSnpsZ0lNSERpV1Y3S3pwcW51S1ZEMVMyUW96?=
 =?utf-8?B?M05ZbnNTR1JPcHo0ZE90ZG5hcmdXOGU0Z0dzM2RJaUYrTGdnQW9sMnJNdk40?=
 =?utf-8?B?UE8zRUoyTS9ZWExSY1ZUYWh5UWN1WVVER0NvZHcvTWZwdzI1TlR6c21QTHlQ?=
 =?utf-8?B?SVRBYWE4WEJ0K3dkeGl2eVBmV2pzZ3hFSXQ1UjdzcnN6Tzl3clBsUVZyeFYv?=
 =?utf-8?B?MzFldDV0WFp6NmhGMFFRM1lXZUFmOXo3aDREQ21Na3hydlZrZWpnVjJ2czhC?=
 =?utf-8?B?ZGd5TTg2TUxPeVNPWDRJdFMvVFZtMkVmMlE4L0NGdXNFbTY4aGZjd3V6b2Iy?=
 =?utf-8?B?bEJBWjg4U3BqVENGZmdML3d5dzZaS2NkZ05lS0tOR2IxZGF6NTlvVkJHek1J?=
 =?utf-8?B?dDJrWTBYWldVeVk3MlBlQ2RZWWZoTG1wNE9Qa0ZWZE1RMWpFd2p3RkFBY3I1?=
 =?utf-8?B?c3BPd0RSaC92SC91QUhLSjBmTVZwMHVobXZzS3BkSHpvMHBtVllMSW5DNGc1?=
 =?utf-8?B?d2hpbFphNXVrVmdUMTFVaTFNRE14VVhTTnh2RG9kT1lSUkhzbTltSUVJRXZw?=
 =?utf-8?B?T08zVE9oeVo0eE9NWlF3eUdUclNjOGVXMWo4bDFTOCsxSzFzNDJlVlIvbEow?=
 =?utf-8?B?aU5jWHJ0QnM4Y1JnYithckcxVUs3bGpEWmlveFd0c2ZScWxPS2RhRWlzRlpq?=
 =?utf-8?B?RCtqSWdrdmYzZDYvVGFTUFlWZUtRSVNFTWVoNjdFYkliKzlhVUdjSmJwM1V2?=
 =?utf-8?B?eXFvZ0xTQ0RSTnlIYmVub0xGZnZlc2xyL0JabXErMWRYSXQwb0EybEhwbTlq?=
 =?utf-8?B?Q1pJcUo1R0NUYWpnQ3dLVXRXdjFQbDR1MEZncThodXY4bUo4YS9TUW1vZXli?=
 =?utf-8?B?TVB1SzB3T291VjN0RFBNc29rbjJiZVUySEhQSWdQdE15R1ptWHRvdUJHazJR?=
 =?utf-8?B?ZEhqRVI3MEVlWnNwbkUzLzBVRHNlL2d3Tnp2TE4wY1EvZ0FsbTZmamVkaE5o?=
 =?utf-8?B?WEpZais3elZHOVhPUVh0cGNBZXdXM1Zkd1NWNWZ4K1FLMVNCWE9nREQyQjN0?=
 =?utf-8?B?TExWMVQwUzVVTEE4SXlPb3FRbHhJMVJ2RVA2Y2VKM3V6RjJFNzZiZGxkRzk4?=
 =?utf-8?B?WGJZVmRxbWdNaGtUaHkxZ3djV2VoY01zVi9DVkl1SmlMd25xL1ZlcEVscFZa?=
 =?utf-8?B?dXB6cHhSOHI2OW5JSnp3RnAveklSdHVSSlpKMFVNcXVJRDlzeURYbmlGelNM?=
 =?utf-8?Q?TbQXgk5uyQCt2xujUKPA5U5HE?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?OU1LaUIvOW9xZ1VGYnVJYWFpZis2dU9ZR2l5dzNlUXptWTBLWXJlVldCbm1M?=
 =?utf-8?B?THlzdEhyN3ptMGpGdnBBb3R6b3ZJSTZvUy94b1U5bFUvaEhGRHlOUFB6RGhx?=
 =?utf-8?B?bVpRdC9OVG0vS1R2ZU1Pc1VvVGp3dVRFTDFBbWJ0Y2NWYzE3cjZOSVltL05W?=
 =?utf-8?B?WW41ajhuUXlSUGhiOE9EQWUvS25VTmxBUkUzUFVTdkRTdUF5R2hOeTRTbXhv?=
 =?utf-8?B?UDNnelp6bVdPTHNJRDFTdE11TjBSeTFLMmNZMUE5VEluNUNaTDdwaDczK2Fz?=
 =?utf-8?B?RG5QWktXVjRaaVViWnBLbnJuWCtsNVVwODFsWEpDM2NRYzBTREp2TFJpcmtk?=
 =?utf-8?B?ZUxrdHFOWmExd1hzZ3hxdU42SVlKcHJiajdSSXI5VkJvaXVicXVwNVdGbFR0?=
 =?utf-8?B?dnUxWGovS0JVRENOeW50Zmo5N2o0UnVVSnpBaVN0eUZMV3NjNVlqWFhRWDFk?=
 =?utf-8?B?ZURZTENvLzVySVM2eUJPQWxEU3R4ZElDZkhOTlVaOWdRWi96N0hJdSt4N3Rq?=
 =?utf-8?B?NFR6a1g0clRPTStEQWF4RUx3VEROUk80QnMyK2cya1hGNXIzQ2NlRzlDUGhp?=
 =?utf-8?B?OW9DZkExbnlpSEpGQkVwdHBrZnlhcHZ2dHRuR1NxQ2p1eDJKakw3RklSdTBP?=
 =?utf-8?B?Q3pFSFp2ZjJiY1VXd2FudExyY1RDQUxWSW5zRkJsbGo1OWYzek9vNkNxMFBw?=
 =?utf-8?B?K0Z0UWFQOUU0dkYxV1pKOU9DVHBVRDNDVUpFbEhuTUtZdk9CNkRDZmFFTDRy?=
 =?utf-8?B?VmxweW41dktTcmxYODdRem9PY1dJV3NrYmtOTzByY1NNTHB5aHZ6QzVxNkdX?=
 =?utf-8?B?RlFlZnloOW1XMStZVDNlaGZhNnNhci9NQzh1akZ5MU9scklWOThPc1pmUXFU?=
 =?utf-8?B?MDA4TFNlYWxBNkdVQUNlbFpOV0JQQUh3Y0lrdVBub2JXL1hvTzc4V2NtWkxS?=
 =?utf-8?B?QUdndEd0dnVybi9Xckc2NmZBOWJwUGIvZjlRcVdQYkgzSytpbmhmaG1rL3VE?=
 =?utf-8?B?OVVmNG1qaC80bU9GczI5OWhvTFFNMUd3aGE2ZEVmNmU3cUlmb2NrODVCQ3JR?=
 =?utf-8?B?d09UdHBUWkQ5RWxGbVVtRVp6N0wwSG9McWpTVGI0UjcrN3FFM1RoWS9hNElo?=
 =?utf-8?B?bW9nRkgvOWNySnU4RmRMS0NEcXlWZkoraDRzUnFUTEFKLzFaK3NRdmsxUUtw?=
 =?utf-8?B?UktHQ0NNOEFnTEphcnRUOTFwMnlTRXhYcGhycWI3RUxWUzlpOEZ0N0hoaWlI?=
 =?utf-8?B?aUZKV0dVS3k2bXZxS0ZEMmF5Q01GWUJiUmdDcVQzSW5sRGpqQUN0WGVIcDdx?=
 =?utf-8?B?ZnZiaEw4VzB4RGdHV1hUYWtLSG5HaFN5ZGxLeUdWMGNyS0VzaGVWTFU3ZUlz?=
 =?utf-8?B?SUVSQzRvS2gyenJuVkFKa2c0QmluZ0RvOTBKSmFzWndsVFRnNE8zcUpaeWlT?=
 =?utf-8?B?OTZpM3pCWDdZVVdJMzcwRUZaME5ybTFCandyS1B5bndyTDZlaVh1d1NpdEZ1?=
 =?utf-8?B?WGNMVFV1NGh2bWZlYWlMM25KV1N2RGF5aGcyUjJwd3d5L0JrZjB1Tm54Nkhw?=
 =?utf-8?B?NHlrd0NycndZMExSRmZJUzBaL3MrUzJpaHg0NXFiSENMR0VPdE1RWjQ0bnpU?=
 =?utf-8?B?czQ3Y1ZJTGFuWWNMMllrZjlLdXI1bUY0bm1ZTEVXQUNrVkxoSWdYemsrNTNN?=
 =?utf-8?B?Ujk1QXpHSGxWaHIzVjl4dWR3dTVtZzkwaDRRRHdpZUY2Y2ZtNlNIVFRYRHY5?=
 =?utf-8?B?a0NiU2oyVHZjK2l6cHBxMkFwNEhqVUlLZFFjV1J2WkFmMHRONW1EbG1JSVNv?=
 =?utf-8?B?SmRjdEZWZkFTUkhxRWRCUT09?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9304aea8-3966-4429-ac3b-08dafd79f3e6
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2023 19:42:25.4478
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yfxxPfDXfEUiWHl6FT8gT2rGGn2ga+GvBpW+tXuECzceJrEapuxWsiLfWeVC6YQ19HRTL/7EDMoPwOhD+7MP2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6152
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-23_12,2023-01-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 malwarescore=0 mlxscore=0 bulkscore=0 adultscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301230189
X-Proofpoint-GUID: sY8fAnZyvu0lGyeHC06LVwzPKGqFXPEe
X-Proofpoint-ORIG-GUID: sY8fAnZyvu0lGyeHC06LVwzPKGqFXPEe
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 23, 2023 at 01:11:32PM -0600, Tom Saeger wrote:
> On Mon, Jan 23, 2023 at 01:39:11PM +0530, Naresh Kamboju wrote:
> > On Sun, 22 Jan 2023 at 20:51, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > This is the start of the stable review cycle for the 6.1.8 release.
> > > There are 193 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> > > Responses should be made by Tue, 24 Jan 2023 15:02:08 +0000.
> > > Anything received after that time might be too late.
> > >
> > > The whole patch series can be found in one patch at:
> > >         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.8-rc1.gz
> > > or in the git tree and branch at:
> > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> > > and the diffstat can be found below.
> > >
> > > thanks,
> > >
> > > greg k-h
> > 
> > 
> > Results from Linaro’s test farm.
> > 
> > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> > 
> > * sh, build
> >   - gcc-8-dreamcast_defconfig
> >   - gcc-8-microdev_defconfig
> 
> Naresh, any chance you could test again adding the following:
> 
> diff --git a/arch/sh/kernel/vmlinux.lds.S b/arch/sh/kernel/vmlinux.lds.S
> index 3161b9ccd2a5..b6276a3521d7 100644
> --- a/arch/sh/kernel/vmlinux.lds.S
> +++ b/arch/sh/kernel/vmlinux.lds.S
> @@ -4,6 +4,7 @@
>   * Written by Niibe Yutaka and Paul Mundt
>   */
>  OUTPUT_ARCH(sh)
> +#define RUNTIME_DISCARD_EXIT
>  #include <asm/thread_info.h>
>  #include <asm/cache.h>
>  #include <asm/vmlinux.lds.h>
> 
> 
> My guess is build environment is using ld < 2.36??
> and this is probably similar to:
> a494398bde27 ("s390: define RUNTIME_DISCARD_EXIT to fix link error with GNU ld < 2.36")
> 4b9880dbf3bd ("powerpc/vmlinux.lds: Define RUNTIME_DISCARD_EXIT")
> 
> 
> Regards,
> 
> --Tom
> 
> > 
> > 
> > Build error logs:
> > `.exit.text' referenced in section `__bug_table' of crypto/algboss.o:
> > defined in discarded section `.exit.text' of crypto/algboss.o
> > `.exit.text' referenced in section `__bug_table' of
> > drivers/char/hw_random/core.o: defined in discarded section
> > `.exit.text' of drivers/char/hw_random/core.o
> > make[2]: *** [/builds/linux/scripts/Makefile.vmlinux:34: vmlinux] Error 1


This is also occurring in latest upstream:

❯ git describe HEAD
v6.2-rc5-13-g2475bf0250de

❯ tuxmake --runtime podman --target-arch sh --toolchain gcc-8 --kconfig microdev_defconfig

`.exit.text' referenced in section `__bug_table' of crypto/algboss.o: defined in discarded section `.exit.text' of crypto/algboss.o
`.exit.text' referenced in section `__bug_table' of drivers/char/hw_random/core.o: defined in discarded section `.exit.text' of drivers/char/hw_random/core.o
make[2]: *** [/home2/tsaeger/linux/linux-upstream/scripts/Makefile.vmlinux:35: vmlinux] Error 1
make[2]: Target '__default' not remade because of errors.
make[1]: *** [/home2/tsaeger/linux/linux-upstream/Makefile:1264: vmlinux] Error 2
make[1]: Target '__all' not remade because of errors.
make: *** [Makefile:242: __sub-make] Error 2
make: Target '__all' not remade because of errors.


FWIW, the above patch resolves this.
How many more architectures need something similar?

> > 
> > Bisection points to this commit,
> >     arch: fix broken BuildID for arm64 and riscv
> >     commit 99cb0d917ffa1ab628bb67364ca9b162c07699b1 upstream.
> > 
> > Ref:
> > upstream discussion thread,
> > https://lore.kernel.org/all/Y7Jal56f6UBh1abE@dev-arch.thelio-3990X/
> > 
> > Steps to reproduce:
> > # To install tuxmake on your system globally:
> > # sudo pip3 install -U tuxmake
> > #
> > # See https://docs.tuxmake.org/ for complete documentation.
> > # Original tuxmake command with fragments listed below.
> > 
> > tuxmake --runtime podman --target-arch sh --toolchain gcc-8 --kconfig
> > microdev_defconfig
> > 
> > Build log links,
> > https://storage.tuxsuite.com/public/linaro/lkft/builds/2KgeCQc3ZdltaEFoi0CwyJlUcuk/
> > 
> > --
> > Linaro LKFT
> > https://lkft.linaro.org
