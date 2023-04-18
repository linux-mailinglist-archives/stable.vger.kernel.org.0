Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28A726E6A26
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 18:52:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231304AbjDRQv7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 12:51:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230445AbjDRQv6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 12:51:58 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37FB5C0;
        Tue, 18 Apr 2023 09:51:57 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33IExNih015328;
        Tue, 18 Apr 2023 16:51:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2023-03-30;
 bh=f0m0DWu4xffesDWQkpljk2+MhabJR7oKyMBQpUVsG4I=;
 b=rt9IItIxr7/7VjVf5WpvusYaibIK0bQwALriQHt9rAlgxe7FXQU8KIFIk/q7ZggThSEf
 FlT++XAXa5HZDd5Soy9IglfPoBAfY5baqfIvTVyGA64Tznp/bfXGY1gmOzzRBtQn8YKB
 8OIb7dIpd0lnNkEsQ+TgKZm9ubbw8Vj14QtpuB0efctuzUzx67iop/lVms7TdAg3CISl
 4VG32MA0tKw+nFNfo5CTcvM9nxlQ9E6jysHwM4AsOtKG2MVoN1tj9VHB8VJo7gR3I7ng
 GHqG7Pz48tk+UjGlBu0959LLCUPFj+S10CIRulHkuRQd1EdDJPmWG60fc/8Mo/YXHMou WA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pyjh1p919-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Apr 2023 16:51:16 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33IFTWGH037147;
        Tue, 18 Apr 2023 16:51:15 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2174.outbound.protection.outlook.com [104.47.56.174])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3pyjcbtnsm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Apr 2023 16:51:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fnTUb6yaXcdtrlVrXyTJ8LYfkmci2mXmvvwo7P2at06gLDpOw6M8DUwvfL2d4epzQ3t9z/b0SJOPWXmVwZ4gYB2hgmXJSUPFhpnL/GpsLQf90nxX4tJ6/mwaPDX5Z1xTCOjboPcNjmv1H+yQFMM4waUlBmRsiBEfBtAFcb5rd80lJrXARjC8KDdWx5w08SXdvgt6TDNXy+jRPKT+d2VKAJsE6KV1z+yn+nzfhdiJXqXzze9Vd1eoC+R2SWwNFZwqj7aDY/6f9AOVcElRdKZJbh9JwhNmS01wVs0iP1XHdufL8Irf5RH4uBWaZD37FZznm2K3pCAQJxBqPjhp4qmbnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f0m0DWu4xffesDWQkpljk2+MhabJR7oKyMBQpUVsG4I=;
 b=i0Uer6hYFY7dMcuANB5/wQM8bB5M9aZXCEkVpgQeUWWxXGGM2idMt35Z6J9yRF8+6XiGPASb60ZWU+EgKbPbXjXRYfHFnKWXOMIMJs76VHWwvrC4fLRsGlUhk+qP4ow05I/uIHNs3b24U8s1jgAeIp1FM3UwEeoeO6FwTzzWlykZdCCaViyZFxq0qtLacRCrjLgjV9RMzSzZzqUrr84WyZgYcRWFtYe1q5QUkmUTAbojcmTpFeSejZ3PrUi45auT5k8ciZajUwkTvDMF3KcQcn6ed9F7/XVLtaYOGLAdbreV+E2d3v0VaygEVDle/b84sNKBSmObd6MnDwhJ0CtsQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f0m0DWu4xffesDWQkpljk2+MhabJR7oKyMBQpUVsG4I=;
 b=ANkPPjY3PGrZSnpFqwhq0/YRwv/bJcS0Cxaupl41ehPY4EgFSQc3IAvdPWIvK66Qlkt4FSUvIzBLEP55aDV/ciuXuijOLvVNJKkV1LUDYpu4QF6e4eEODhUn+56AXbSdKrGpHBBEXJ9ndcbzHNVaL626KdjubScs+O4q+Rxi3jY=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by BN0PR10MB4904.namprd10.prod.outlook.com (2603:10b6:408:125::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Tue, 18 Apr
 2023 16:51:11 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::c584:ade9:6e24:4837]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::c584:ade9:6e24:4837%5]) with mapi id 15.20.6298.045; Tue, 18 Apr 2023
 16:51:11 +0000
Date:   Tue, 18 Apr 2023 10:51:05 -0600
From:   Tom Saeger <tom.saeger@oracle.com>
To:     Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Waiman Long <longman@redhat.com>, stable@vger.kernel.org,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de, Tejun Heo <tj@kernel.org>,
        Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>,
        Daniel =?utf-8?B?RMOtYXo=?= <daniel.diaz@linaro.org>,
        Anders Roxell <anders.roxell@linaro.org>,
        Darren Kenny <darren.kenny@oracle.com>,
        Vegard Nossum <vegard.nossum@oracle.com>
Subject: Re: [PATCH 5.15 00/91] 5.15.108-rc1 review
Message-ID: <20230418165105.q5s77yew2imkamsb@oracle.com>
References: <20230418120305.520719816@linuxfoundation.org>
 <CA+G9fYs9sHnfhn4hSFP=AmOfgj-zvoK9vmBejRvzKPj4uXx+VA@mail.gmail.com>
 <bd46521c-a167-2872-fecb-2b0f32855a24@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <bd46521c-a167-2872-fecb-2b0f32855a24@oracle.com>
X-ClientProxiedBy: SN7PR04CA0190.namprd04.prod.outlook.com
 (2603:10b6:806:126::15) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|BN0PR10MB4904:EE_
X-MS-Office365-Filtering-Correlation-Id: d7077dd9-59b8-493c-f305-08db402d1d45
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fzgDURm4mcsmlDB/x6c9sGTBImU/QWDvIdLwfLKBITQME3BWxWfTyJcEX1V46tWnf1H19KtgXKtj8iX8rPL1xmPi3EXVx6TAi/UPsx5kUTVLPsz9qWSXVwpfZj8f6BhqEuho6ySiuKyU2SJOkUU4LPIQrSZu1vikNDfuC1UAKU7/N3HUx82bDFTSyPFB0XgLNrjSVuIPe/2x5anizw5cD1A1IpDqgs4K2ly+e2qEmlN9z1xpZutqcsvYs6oGZiQLTxgOGS1AqYukMviKQjZSgSj2ao3mSCBdilVDzBc0VBXb/QIS5aXPkIwoy7kqfPlXDt62gk9mAbkFC6i7YavQcXPN8ehpRIZ+HMxbO+1jxi91s5BWGJ8xqp6ZnZJdlc5lWmsy9L5/57kI9Q3oChtXsb7gZykJuIxyVS0iObwqg1Lx3tCsCNxkRu7BoZRXcKM0u7r6BjKfItGKcqA8kdADyzf2bAR9MHenUmx4EO7kQouuubrAVVIq5q6QKj8n+ShhSbVoSj/7q+uh4wCMtjr8Zd1GbBtX0eYef4xITAITqqk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(366004)(136003)(39860400002)(346002)(396003)(451199021)(2616005)(37006003)(6512007)(54906003)(6636002)(26005)(107886003)(53546011)(6506007)(1076003)(478600001)(66946007)(66556008)(66476007)(316002)(83380400001)(966005)(6486002)(6666004)(186003)(4326008)(8936002)(8676002)(41300700001)(6862004)(2906002)(5660300002)(7416002)(36756003)(44832011)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WWl0TlNtUlJWOU1rbUJKekJoS3AzZ3FVTVQzbXhUd3VmWXVXVWV6UGxaRzBX?=
 =?utf-8?B?NWNZZnJYMjE0VkRKdEQzdkl5TC9NUTFwYzMrWXdPbXEwa29TYXNtL2JIVkd6?=
 =?utf-8?B?WHREenZFb0JlTlVJa1RDMENsTmFmMmVvbjJ5Wmx1MllIWWNCQ3JoTStoNVA1?=
 =?utf-8?B?M0VKM0FLMnlXaEY4bXBJbFdHUWxaK3piZGNWY1lMUThudXR5dXNYRE94L2x1?=
 =?utf-8?B?eEM4RmVlaWkzTXAyYmJGQmJzbjRvT3UrYlVoTFo1VVpOUjhnVEVwYmpCelVv?=
 =?utf-8?B?MmlOK2tvREVYQXNSWCtseXV6Uk5hMi9zdWd6eHlQRFBOLy9mL1NubFJ3UnJV?=
 =?utf-8?B?dThYZnZQT0ZrYkNWSmtQeXJKaW1NMW15REkwM3YrelFteXNLejduOXJ5Uk1T?=
 =?utf-8?B?S3FNd0RHTmZJR3lXVForMDdDenR0MjFkMGpzdkxlbGFNVktXQzVuczF6SWxy?=
 =?utf-8?B?NkVpbmx2NDAxcWpMVENlMGVhZUMvd3dwKzc3K3hDdURQVGNsWkgrSFBta20w?=
 =?utf-8?B?SGliR1BOckl1R3FoRmNFNUw2TnhTbWJEVnpTdHRGYUpZeXZrQm5mY25xa3V0?=
 =?utf-8?B?S1IyMnVPR3JWOXcvK3kweXdFdUh2eThZWnhPRXl4SXBGNC9KQW1jVWo1ZmpB?=
 =?utf-8?B?MC9nSFpiTUUxcW5hbXZyNFFacHl4RDFqWThHNkNxQWFwaHFoZ3FvcFFOR3Fw?=
 =?utf-8?B?bThOSUY1YTc3T2dETzBMYW53a3NjaUNXa2I4S2hEUHdwRHJIaEI2UDhLQzln?=
 =?utf-8?B?TlZVeGVRamZjS0RwRENJbHl4dXpMaWh0VGdkQ2p2UU1tQ0hPNHoxbVJXS0ZK?=
 =?utf-8?B?WlhPbDYyU2U0dDZERk1YSUh2RE5VYlNoem8zWXU1ekxUanFHUTNmUzEzWlpR?=
 =?utf-8?B?RXUwV3BNUlFYTVR4b0xpdjBVQ0tzTkZvK1Y0Um4zSHpDcVAwM1pNcEN6Q2Rr?=
 =?utf-8?B?blBhaDUrVDRHcUNPWFBJbHdkSlQyS014TTVPbzUxbnF0Q3dEQWdPZ0VPSHZE?=
 =?utf-8?B?VDNQcndzOGJsaXZkZWhkZ0lZYUhKd0tBbzJxSnNmUi80Vk03SnFrYmJLbWJU?=
 =?utf-8?B?dWJNSHRQZHdTYzEvTlUxY2U1ZitsOS91K0NBcnlEL21rRnNQTUNQaTVLZmhN?=
 =?utf-8?B?ZGErWTZUVExBQTl4ZWFVWDdyVnRDSDIxTmhQaXIvb1dncnBTYVc3eDYrOU9i?=
 =?utf-8?B?YmJ4NTZWSXV3Y3NEem9zODN5Mm1weU4rMzlyM1dENEZSWDMzcnB1Ym9iWHNq?=
 =?utf-8?B?V3BhaGUwbHI2TUNQbTllczNETEpUSzZ5Q2JKaWt5ZGZJK1dvRlVQZVc3d0FO?=
 =?utf-8?B?aGdoRlN1ekd2aU1Wd3BPd2ZJd3ArSVZiWjRVNE1KVUc4WTZZOEJWL0pDeEZ6?=
 =?utf-8?B?dTY3T3dOcVJvbUhqUXVDak1hNlVlRHNkQU9jY1F5OUNKamRlL3BrdEMzMlhD?=
 =?utf-8?B?WW5HVVV4c2pOWjVjRFhQNnFEdUxEeTR0bk02aTZiV09OWnpybSs2Z0RIZklp?=
 =?utf-8?B?VWVpMzk5RDdFRnJLaU8yU09iUVZKRGtzamJzWUhEVUthaTNGbXlwQTcwSTlP?=
 =?utf-8?B?QmNwTzgwdG1Rek1wakpnUGFnVUh3WFNsQ2FsdkYzWG5rZ3RjM2pxZWFabjNn?=
 =?utf-8?B?emgxZFUwMUN1RFQva0xnNG5qWUtydVowNW43d05HSDE4ZnNGZUp2TFlCUEVv?=
 =?utf-8?B?MCtlQVQ3ZVZHUUdiK1VMODNEYkh5cVRsc2xvZTBHVnAyZVBLMU5VZDhpSWlW?=
 =?utf-8?B?dlJWR3FwNkdtdlY0ZExjclg1d053ZFEyV0s5RWhmMHZUd0hrbEt2MW9NZ0Rx?=
 =?utf-8?B?VkdJZ2Z2eHlScWxMblZsT2hTZHUzbVJzQTNJNzM3c0pTbDg4eWljYU5MR0xk?=
 =?utf-8?B?cXQ5VVVOMzJqUm9wc0l2eDdNMUcwOG9nZE1OUGhST3N3dWxKcGdxNEM1Qml4?=
 =?utf-8?B?THVIalFkRzRVd0oxczZKejJqQ1J4eHlZeW9ocU5zbFYrenRDM3dsWjc1VXlt?=
 =?utf-8?B?VitOT0hzSzcwOEl2ZlJ6R1lwYmlPRTBPZWxEVjhRK2RBQjRLdzdEYk1ZTTUv?=
 =?utf-8?B?bnlxbnZmNkdlQ2tuOUJyaUpzNUJkZEhtS2tIQmp6OGVKaUJIeGhBeGNWQ2xG?=
 =?utf-8?Q?4Wk43k3jfYb5/7vdhhvbjqYR3?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?S2FZZkRrZ3FrSHZmMWdzZDErRXY5Wjk4dFZKMGxLNXpMV29iRU9IQUUzdDNI?=
 =?utf-8?B?OHowSjRJU0x5SHdnSWIybWNwSElibnBiYmdVRWRjQ1V6emZOSFVDMEtmanJz?=
 =?utf-8?B?VVFUc0piVU5NeEtRY0lURVg0T04xM3VISUxSNnhzUlA0bmVuTHordTFQdGFD?=
 =?utf-8?B?Nzg3YW5TRnVaOU5pbGJFT2xnSGZoS1hSdXFydnBoRjVCTmRiSkFrZlFjQUxm?=
 =?utf-8?B?cVl2NnNxcUx4N0FHYkh1QnFpUHVpeFF1aEhkNFBqdWMveW42eWJ3Vm12WWlm?=
 =?utf-8?B?bmFvRXBzZnk0UEpnbHVxbnpBUWM5TnZVUU03bGRPVjRFcHh2MGppamJIczJU?=
 =?utf-8?B?R0RaOGpXQWNUT0NXOS92cDhFbFp3MmxEYndIUnJFQmY0SmVNNEZvbTZyaFg3?=
 =?utf-8?B?QU5seXp4aXhyajJva2d4OW91akVISTNSSXV2RmxtVXhocFY4eFVoOUJCNEw5?=
 =?utf-8?B?Y1lvSGJrZVJRV2tTSzZUeW1IZWQ2ZEszWDVrUFFjMndLZGE3azlHRGs4NlJw?=
 =?utf-8?B?UTVCZ0RGdXZMTHdmYmFtUVNTUTZnNWozYWVjOTBUQnRBdmRqcVpHTE8yZDRT?=
 =?utf-8?B?aUk5MzR5UEh3M3JxakFLNCtCRDFadEJkV3ZnbU5HVDVMNEVCT1BqZHdHdGFJ?=
 =?utf-8?B?a2QrZWZYd04zeFptYW5IZFM0d0FjUWFOMUFYdTFoSkw2d0d3dXBYOStTcnpa?=
 =?utf-8?B?bXVnRmRwc0thSjBsdTVaSE5waGc3TWFiSGtUWjd5VENZSmVWcWI3TzZhMG5H?=
 =?utf-8?B?b2hNNnVvckw4bGdHWmxab1ZFd3oyenZkNDJBS2ZQNE5sQjRSUWt2cWYyS2V5?=
 =?utf-8?B?aDRYZU9xa1BXVC9rYXEzcVJDMWs3ZG1icFlPWXZ6SjRmMk1SUGU2T2c3NHJO?=
 =?utf-8?B?ZEgrMVRpcGJERkFjRE1QM3d4UUJjU1oyaUhtUWNHZFdkcFlPOWFnNHBheEJq?=
 =?utf-8?B?L2hrOW01a3IvYm9mQ1RVa2x5bEozOFVZTmJuSmJZSTVpRlloU0x1S1AzOGdE?=
 =?utf-8?B?ckJFNGZIYkxCS2ppOGhkY1BiN3FoYTV1WG1GQldGWXpGT3IxZEpsdlRHK0xl?=
 =?utf-8?B?QkM2VnBzRzlUd0xWSGppcENSZU9xV2RmK2Mwak1DN1pZYVBGVWFWNFBpZHAr?=
 =?utf-8?B?N09nV0tlRnBnd290Z0lLVGtPaWlzR2hwam81bEk1bm5iU3AyUllCS1VPNkVr?=
 =?utf-8?B?YndjS2o4UXRDZ3FaRWJ5WmJkUlVPbHo0cllaYjY4RkkwMHFqU2NYQ3R5b0pL?=
 =?utf-8?B?TGVWRS9JNy9lZkpJSnRscFVWQURSRnNJQlpzV2pYRlZHYTIxZWZJbVpacGxm?=
 =?utf-8?B?MTkyOGxHVThWN3ZDd2k4Q011U016UW5BZUlvTFMrYUVEeElvMFo4amhyMUh0?=
 =?utf-8?B?cTE1QUR1VUt1dzFCMGJ6SWNQVVg5QzBBSWVRdE5iL24zODE1MWpIMm1HdllS?=
 =?utf-8?B?ZGZLVis0Z055K3FtdmpTeGs3NUZoNmJGNm43b1NMVFp5UktGN2JPN0pDU1k4?=
 =?utf-8?B?anRTZ1pqNzE3ZGV5SkQ2andHaEwrY2VROVVmdHVBZWw0c202d0VlUkt0Smh4?=
 =?utf-8?B?LzBCZ2ZHbUU5ODA3ZVNGM0NYREpwdUtvSlBaVDV6SXRkVFF3UVZLNjBYNmVi?=
 =?utf-8?B?a1JIcEtFa09kVVhQVjRTeUNOSm5LbGtsQ3R0YlFxOVk0MzFHd1UrUndrVng0?=
 =?utf-8?B?TjhxSXVCZnMrZWhaVnlKS1Bwci9qc2ErVG4vYWw4VXpjYWIvMmhGcVlBPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7077dd9-59b8-493c-f305-08db402d1d45
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2023 16:51:11.5054
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 38LJoge7YUu/bv7y62HEE0qLEOLZ8canEHI9PLBAcasx5Jj9MAdrhVs9pbtV21Rw5sFITV9nMwV2iubdURJULA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4904
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-18_12,2023-04-18_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 bulkscore=0
 mlxscore=0 mlxlogscore=999 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2304180141
X-Proofpoint-GUID: wwTemWMZaDdVFnassZ8W0sC5I--Xw_iF
X-Proofpoint-ORIG-GUID: wwTemWMZaDdVFnassZ8W0sC5I--Xw_iF
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 18, 2023 at 09:47:33PM +0530, Harshit Mogalapalli wrote:
> Hi Greg,
> 
> On 18/04/23 8:17 pm, Naresh Kamboju wrote:
> > On Tue, 18 Apr 2023 at 18:07, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > > 
> > > This is the start of the stable review cycle for the 5.15.108 release.
> > > There are 91 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Thu, 20 Apr 2023 12:02:44 +0000.
> > > Anything received after that time might be too late.
> > > 
> > > The whole patch series can be found in one patch at:
> > >          https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.108-rc1.gz
> > > or in the git tree and branch at:
> > >          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> > > and the diffstat can be found below.
> > > 
> > > thanks,
> > > 
> > > greg k-h
> > 
> > 
> > Following patch causing build break on stable-rc 5.15
> > 
> > 
> > > Waiman Long <longman@redhat.com>
> > >      cgroup/cpuset: Add cpuset_can_fork() and cpuset_cancel_fork() methods
> > 
> > cgroup/cpuset: Add cpuset_can_fork() and cpuset_cancel_fork() methods
> > commit eee87853794187f6adbe19533ed79c8b44b36a91 upstream.
> > 
> > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> > 
> > Build error:
> > kernel/cgroup/cpuset.c: In function 'cpuset_can_fork':
> > kernel/cgroup/cpuset.c:2979:30: error: 'cgroup_mutex' undeclared
> > (first use in this function); did you mean 'cgroup_put'?
> >   2979 |         lockdep_assert_held(&cgroup_mutex);
> >        |                              ^~~~~~~~~~~~
> > include/linux/lockdep.h:415:61: note: in definition of macro
> > 'lockdep_assert_held'
> >    415 | #define lockdep_assert_held(l)                  do {
> > (void)(l); } while (0)
> >        |                                                             ^
> > kernel/cgroup/cpuset.c:2979:30: note: each undeclared identifier is
> > reported only once for each function it appears in
> >   2979 |         lockdep_assert_held(&cgroup_mutex);
> >        |                              ^~~~~~~~~~~~
> > include/linux/lockdep.h:415:61: note: in definition of macro
> > 'lockdep_assert_held'
> >    415 | #define lockdep_assert_held(l)                  do {
> > (void)(l); } while (0)
> >        |                                                             ^
> > make[3]: *** [scripts/Makefile.build:289: kernel/cgroup/cpuset.o] Error 1
> > 
> > 
> 
> We observed same build error.(5.15.108-rc1), and investigated about this.
> 
> Please see the below findings.
> 
> With defconfig --> build breaks.
> With allmodconfig --> build succeeds.
> 
> From the above we know that this is something related to CONFIG.
> 
> In 5.15.y -->
> cgroup_mutex is defined like this in include/linux/cgroup.h
> 
> 	#ifdef CONFIG_PROVE_RCU
> 	extern struct mutex cgroup_mutex;
> 
> In 6.2.y --> include/linux/cgroup.h
> 
> 	extern struct mutex cgroup_mutex;
> 
> -- We don't have that ifdef in 6.2.y.
> 
> Tom Saeger identified that the below commit moves it out of ifdef.
> 
> commit 354ed597442952fb680c9cafc7e4eb8a76f9514c
> Author: Yu Zhao <yuzhao@google.com>
> Date:   Sun Sep 18 02:00:07 2022 -0600
> 
>     mm: multi-gen LRU: kill switch
> 
> Given that we don't have this commit in 5.15.y and 5.10.y we are seeing this
> build problem.
> 
> on allmodconfig:
> 
> ~/linux$ grep "CONFIG_PROVE_RCU" .config
> CONFIG_PROVE_RCU=y
> CONFIG_PROVE_RCU_LIST=y
> 
> on defconfig:
> ~/linux$ grep "CONFIG_PROVE_RCU" .config
> -- No match
> 
> This explains the failure on defconfig and a build success on allmodconfig.
> 
> Thanks,
> Harshit
> 

FWIW - partially backporting (location of cgroup_mutex extern) from:
354ed5974429 ("mm: multi-gen LRU: kill switch")

fixes x86_64 build for me.

Regards,

--Tom

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 45cdb12243e3..460ba084888a 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -433,6 +433,8 @@ static inline void cgroup_put(struct cgroup *cgrp)
        css_put(&cgrp->self);
 }

+extern struct mutex cgroup_mutex;
+
 /**
  * task_css_set_check - obtain a task's css_set with extra access conditions
  * @task: the task to obtain css_set for
@@ -447,7 +449,6 @@ static inline void cgroup_put(struct cgroup *cgrp)
  * as locks used during the cgroup_subsys::attach() methods.
  */
 #ifdef CONFIG_PROVE_RCU
-extern struct mutex cgroup_mutex;
 extern spinlock_t css_set_lock;
 #define task_css_set_check(task, __c)                                  \
        rcu_dereference_check((task)->cgroups,                          \
diff --git a/kernel/cgroup/cgroup-internal.h b/kernel/cgroup/cgroup-internal.h
index d8fcc139ac05..28c32a01da7d 100644
--- a/kernel/cgroup/cgroup-internal.h
+++ b/kernel/cgroup/cgroup-internal.h
@@ -165,7 +165,6 @@ struct cgroup_mgctx {
 #define DEFINE_CGROUP_MGCTX(name)                                              \
        struct cgroup_mgctx name = CGROUP_MGCTX_INIT(name)

-extern struct mutex cgroup_mutex;
 extern spinlock_t css_set_lock;
 extern struct cgroup_subsys *cgroup_subsys[];
 extern struct list_head cgroup_roots;
