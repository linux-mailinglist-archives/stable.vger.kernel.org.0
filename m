Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0677B6E79DD
	for <lists+stable@lfdr.de>; Wed, 19 Apr 2023 14:39:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231825AbjDSMjB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Apr 2023 08:39:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233276AbjDSMi7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Apr 2023 08:38:59 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F269D10E0;
        Wed, 19 Apr 2023 05:38:56 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33JBcBBD006002;
        Wed, 19 Apr 2023 12:38:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=hkKf4jFVTvtRGmCzpUjxImyib3yggEThApp/wkd/e/0=;
 b=hSWyd+JxH+XUdjMegh3TJQUdMYhN62pubUgUJb9LPCG49wUBH0GGT1bWoWFtiYW2NEKx
 G4CizChw3Ty32mLAFsebIrygS3R0tggK6dqY1IFuotktx+OW0MDQY+oW1frkzp+u463o
 vNJv1lKJEVhnSOTqlpLltvXF95w8GQobXlsrZFrCeVN+qieUXROE5AsqohlajZFJa9ex
 XjybFtFhgb/fBeM10lkYDR95XTJdLPhYrQxbpb/OY9CmtpS6AQNs0FKIt6c4hpYY1Wvc
 voWcmkgBQR+wYSI/2L2RC/bcT2efKt9EByNz/6qsvher1olBLb40jk84Ni4Fdsh66Ey0 sA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pyjq486wv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Apr 2023 12:38:19 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33JBweeM015699;
        Wed, 19 Apr 2023 12:38:19 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3pyjccwbs5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 Apr 2023 12:38:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ksO8ZrAJaNaWv1UJD629p+TPKHV8+o7M32TGtDEe3PY5PY/C+bq/v9cThx8rdNOiQasAmixUTIiWcCS4JeC7Jajb15Cl8JAsQBBbgSlc0Nz3AbgJwQmol6KStnfFQXIQI6jvQSGI4p6GhIfjR7IHMEkIX1bP/+v/j01GJSLjhvH49Q527mFKhT5MXkmu7i1qND3Bd7gdLOmkLjLBE9aHA/IJqWdKQ7PowKqa+YO6VNP/gGegcg93OHiOInE1dAMeeKp0jYMZoC8+eJO//4omLNJ8QmSRYW/HjsvcXqdeXU1bswk9EPp4NlSxAmythx/aGfQmjxYYRVD1sXqkGvLuXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hkKf4jFVTvtRGmCzpUjxImyib3yggEThApp/wkd/e/0=;
 b=G+lt1vnUgLYfF+Xb15zQSrmrOcV07btMFUeSgNHPkNqlY5hyDlcX1LJn51rxQK5V/5QxvRU1C31Ja6ePPiMfeBcTlVwbktazERY5ALSwnJ9fGzpirdQ8Qxng5DCO1JTFutERsEGluDEK2IGYx7sYeM4WT1QjtNOLotJhQ0TGJAk4ABaXjtPh7s/WuYIXQq0oJvNb0TCO/ZhqGQCW81s3BPh+qTwv8+gm7L2aXgiJuqOoFXF6hl6DSjM85G3vQi8+Fjb33+nW+0nDpiDogvWclPPmogV4qMQX316RHVZclJC9empkEa1h4Bw64zipDuraCuHVl/E9oYvFuXWnKjY/KQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hkKf4jFVTvtRGmCzpUjxImyib3yggEThApp/wkd/e/0=;
 b=gy5We5hBh4ud1qoWYzM/6UMO3eu/WV7K8W+ofmTUz6BEHn/QYKOJOexKc87nh6drg8saX6biCZC+BknOFGTEYYVzknd2rzO08TmjaexiprKU4SPjOR8UA1WYoUGGdnrv93kAfpfaAtLb+J+ZoMMJ5HDeeRaJiZPvj7YHPfB6pW4=
Received: from PH8PR10MB6290.namprd10.prod.outlook.com (2603:10b6:510:1c1::7)
 by IA1PR10MB6147.namprd10.prod.outlook.com (2603:10b6:208:3a9::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Wed, 19 Apr
 2023 12:38:05 +0000
Received: from PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::68c5:330c:d234:3834]) by PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::68c5:330c:d234:3834%6]) with mapi id 15.20.6319.020; Wed, 19 Apr 2023
 12:38:05 +0000
Message-ID: <ea871b8f-c61b-57df-382a-b61e1377634c@oracle.com>
Date:   Wed, 19 Apr 2023 18:07:53 +0530
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.1
Subject: Re: [PATCH 5.4 00/92] 5.4.241-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
References: <20230418120304.658273364@linuxfoundation.org>
From:   Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20230418120304.658273364@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TYWPR01CA0049.jpnprd01.prod.outlook.com
 (2603:1096:400:17f::20) To PH8PR10MB6290.namprd10.prod.outlook.com
 (2603:10b6:510:1c1::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR10MB6290:EE_|IA1PR10MB6147:EE_
X-MS-Office365-Filtering-Correlation-Id: ab15a9dc-601b-4d99-3d1e-08db40d2ebc7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fW76T4sjN1fZ0olII2zeCqw86DE+wYHQMEXe2F3OBCgTe49i4V2I2+RpsV+FSI6/VTRRUALtu7lszQDr3gGWTDSzhUZVXVFlnNYelW8xnMTwyvihbpyKmfzXe1kdbYxHcWQYIHQ7qkY5Wso631NfRLiZ3zwlAQZUcQwVYmJybQpZUyMAnxoauPMl7RQqH5V8pOlNaxjSaPpQd/USewBdeSoAjF481FaOyURgeHk+oajNSOEbTiGFib6DqzlWyN5F8y6KCEe2llVO0dPjhtBKSc5zLCdpCfM/zQSFpasak6+GdtOWYBKDxwlALBwg0CnM1258iqscHCbsCtg48rnv35jjH5lyNY/HtzjjpQmwP7a9YspRLhuNTCc8RAWNgrRoiHiQZcGTqVklWSRg0uC5d6DTr+4RalZiY17oikLwVMgzBqhiFhWFyvVuOzCWgCutaU9+1Km/tbSaO5tNJ+Y7U2uUJISRP60Gez9A9l0Na+/w6FMPltdlp9lVKrHs/E6c83rd/PffyxU3T/t/wPQbuimHXbHy+hRHfXc6Aaj3A1i93JCH+tseJFsGWYoJfsNVCTAxTBwK2b5NQF0pm/+OqL2KtnJ1oxZGfvTkmAOHXX/pmfgzPzy8BjaybrnzS2xw1iKW2Ez5B5JqmQVW8OlN+g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR10MB6290.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(376002)(346002)(39860400002)(396003)(136003)(451199021)(478600001)(6666004)(38100700002)(8936002)(8676002)(316002)(4326008)(41300700001)(66476007)(66556008)(66946007)(186003)(36756003)(4744005)(2906002)(53546011)(6506007)(6512007)(26005)(86362001)(31686004)(2616005)(5660300002)(966005)(31696002)(6486002)(7416002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bFFiREV4SXZ5QlBtTHJlU0U2bEFmbzg2bUVzc2V2YUdIT0YzMW9WaVpEOGw0?=
 =?utf-8?B?Vnc1TE5zL05aenZKcHJaUnk4cll1UkNTQUxTd3FYS3hKTWt2YUhmdXFObGFV?=
 =?utf-8?B?WkhyR1lTTmFiN1FRMXV3KzdDWWhLaDNGUXRIemdxMDN0OEs4dExsRXU3RWRL?=
 =?utf-8?B?SHp5VXJvWDQ5TGg0ZnVZTFc4eXh5bytXVHROS2tFaHZRdWJQTnd3YkxXOWtu?=
 =?utf-8?B?S0NjT0k3dGtFM1c4dFUvSHllRmJsUDN5VklPVkV0TWt3S2xidHdLMnZRNmty?=
 =?utf-8?B?ejN4SlhNcWhyVGlVS2RYVldiSUh6NzZoclBaK3g1MWF5U0EyazdrS3dCRnpk?=
 =?utf-8?B?L2ZaR2cycTdzbVRxSXlUMUQ1N1JOcWdQSXVYU2ZkaksxK0dldTlOQUhyQkM1?=
 =?utf-8?B?MllHeVdLbXp4bkpCTjVZcHVtRlZ4WitDa1JJNGtjdTFZeGx6aXdwOW1JaXpZ?=
 =?utf-8?B?QVJOL2NEdjZtS0I2ZVVIOTlHUnhDNHNLOU9hY3FEazB4Ykx1Q1c4Ulg1b0VU?=
 =?utf-8?B?bEV6ZnArazN0RnlyN1AyL0hmZGZzUlVjY01ZRFU3aG1TWXhJUy8rRUNwZ1ZD?=
 =?utf-8?B?bjc1aGNjTCtGVytlckFDSTdZYUFiaHQ1Nnlad1hoczFKYWVKcFI2b2tRYXRB?=
 =?utf-8?B?akdBNFhYMk11c0grSEtYNERuNFB6MGx5L0FvU3lpVEcrekpmVFFGWGlVeEVq?=
 =?utf-8?B?R0toRXNUM1YrOFNtQ0R5K1Jmem9nekhtdGxqWGxkanpScXlkeVdxUzhMWU5x?=
 =?utf-8?B?QTk4ZUxBNElHV0d2TWJ6MXRDU1NHQkJNTnB5S0JuTk0xQkI1bDgvVkZ2Q1o5?=
 =?utf-8?B?a2xvOGkvMHp6b1J5WGFWbm1tazFDazlJb0tNWWhlaW9SeFZuaERuMTdIN0ZR?=
 =?utf-8?B?U0RKV0N1MWw2V2JwcDdDM2xDT21TTFN0SmNvN1Qyai9ZZjlQNmFQSkhkeHZ5?=
 =?utf-8?B?RTRuc1d2WHkrZWkxc1h6K2JkMU9FaEJ6a2hwcGlvRTQ4RkZId3F0VjU3YjZW?=
 =?utf-8?B?dkxVYTNaWm80NmJzSUNhNHVxVCtUaWhjSmplZE8wTU8vakMvVHB0OEc2V2w5?=
 =?utf-8?B?RW0zMjd4eU41ZmVpMlZ4bFV3M3IrNzg2cmZjN255Q09oUkV6eWQ1N1JYMFBj?=
 =?utf-8?B?Uk5zYTJudTlKaFpSMitOeEdpd0xmTXltZ0JuOWhTcXJVa1U4d08zSTlLN1Mv?=
 =?utf-8?B?UlhNMXF1ZWdXb3dKeHAzNkQxOEJMT1dsSHVEellTcXk2dEFxTkw0ZklmbGJM?=
 =?utf-8?B?YklGV3RFdnlFemxkdHpQczYxZ0V3Q2dzRWg3Qlp1ZnZkTkNQdjFFTXZmM2Iy?=
 =?utf-8?B?ZStuWjNxM0QwQko0aUFmeHBoRlJjWmlRa0xBZDc1OEd5ZVp2QS80Ly9oNXJt?=
 =?utf-8?B?UUR3NWtYVTVkYmY3TVRsbGtENElacXRUclZJMWQzblhQRklVcWlXRHZLc011?=
 =?utf-8?B?cmtWRHVPb0t4STcvNkk2NkhqVlBTYW1LZStIYkQyWTNBMkJJbW1RVXJxSDNm?=
 =?utf-8?B?ZzZsWTVEK2pNaWVsbkJyMys2U2ZZVU80MkJhTlVsSVBhcHJReVVxQ0NIdEN3?=
 =?utf-8?B?L2JabTNXaUd0emJPRXNqTGpzOGZHamprZXN5ZFVvcVJmS2ZyQkk4Qmt1TDNQ?=
 =?utf-8?B?Z2c0QlpHaDZzSXZzUDZJTjhzSTRMT0JoTjZCOHRkRUw1RHYyVk5CajNxakI4?=
 =?utf-8?B?cFJWRGkzYzJOQ091Zml6bm00clEwMDdDaUhPeXZKNWdBbTFXZ0tQSzZxdzZh?=
 =?utf-8?B?blVRMG5hb01OSzhYcHlZa3hQcGtSSVVldmtGQmxHM1QyMHFXRTFQaUc2Yys5?=
 =?utf-8?B?Q2p1Wjc2dTNtVVVabGFkQ25tZzV0N1QrZEFTeVYyVTk2TGVWWUM2OVFkQTVV?=
 =?utf-8?B?bmpNL0RPYUhmcFZnM25GWVJZN1NiZ2JSOGdLalJXZ3Y1MXQyYXlGSlgxYUVN?=
 =?utf-8?B?OUtqbEpJU0lWR2RsQXBhKzFZcnhqMWk4cmtiODdiRG5NRXhWOVJUSGNNVHJL?=
 =?utf-8?B?REpSb0hLZG1RUjl6Z1hCTjFuY2N2KzJRQTE4UmJrTy8weFY2M0dJek42by9E?=
 =?utf-8?B?WGFFVkdYa2FoSXo5bml4Zndiamwvb1RUR2cwZy9JZFRia01wM0lXMVpFNDht?=
 =?utf-8?B?aVVUcDYrYThIeFdYeEpKYTByd29TRmJSdnRLOEcrN0NIRXI0WGhsOFlUS295?=
 =?utf-8?Q?QmECICHy9duZ0JdtLnxPO2Q=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?bmNNaEEwdXMvQVhpNDBpU2pScWIxYUh3ZHlTK3V6RUhJYklPVmJsWkl0NFZP?=
 =?utf-8?B?ZWpSMk13TFdqdEgycU9YYWEwTEM0a1d0RDFvZUNmSFZHeEgvMmhNWDhweXVh?=
 =?utf-8?B?RlA0TERkbmYzNEJBaDIxR3lwTFErb0VyWFd3MS92SlJaVEhHWmRiMExSY3FX?=
 =?utf-8?B?dXFqcThXdXg5emtSb29TNnYzbGZwb2FJSjJwQWVvTmp1TFVkVnc2NWpuOC9t?=
 =?utf-8?B?VGZqYzNDdWxRRWEyMjArRVkvazlBVFJZTXdLREI1SzZLVmsxcjYyeWVGUTVH?=
 =?utf-8?B?ZVNIcmxuZW5sNUowN0ZlVEd2cmhZS3FJWVViaFM5V2ZuWlB0Kys4NS8zLzBF?=
 =?utf-8?B?b2JJeFdWVTE1Nmc1UldydnZPQmo3VlFNVXhjWmVreUdmQjliRC81dVJmZkE3?=
 =?utf-8?B?OHhhV0hxNkZ4T0llcWk3a3U5YW9UZkY1VXJvL05JcE43Uk43MmVXNTBucHlV?=
 =?utf-8?B?ME9qQkh1MFV0cXA1RkhVR296UjhVempFUHVKOU1RV1AvV3I0cS9ENEYxVTJL?=
 =?utf-8?B?bnJ2eXhjeElNcmkxdmtuUlQ1VHh5TFk3eVVXTXZ2ZWpHZlp3RGY1UGd4dXZi?=
 =?utf-8?B?WTFhTm9jaUYyNnlVQUp3V2J1eXI1NSs1eHVIRndSbGxHelRDZU5BTWhscVUr?=
 =?utf-8?B?bmJYeS9PTjkza1dwZ1UzaE9qeGszamlFYWFoVitGQjVoODkvbWlJVnhoR0Jm?=
 =?utf-8?B?cldkSHVIQ0Y2VUhTS3VVWCtZenBqNm1tK1lUUHFKWHNRR0xvQzVxNmVBV01w?=
 =?utf-8?B?MjhmOXBvdzY3UE14bWFnblZzNmFFRy9va2NkZHE5SzRXeEhrRE9qMllDaitm?=
 =?utf-8?B?Z0pXanJSdmU3T2FYRGFDeFNYQlVwZ1lQTWZyNGdqRjRTN2o0Z1NEQXdqanJt?=
 =?utf-8?B?dEJSaWJBUi9kRDljdUpMYm9MS3FDWjFzUFZ0dEw0RXlWZEwyL2ovZEw0NnBJ?=
 =?utf-8?B?Z0s3VUVlc3FiYTY1c3BnTEFOeW5td0FDY0dZaEtvVUh4Vm9jdnp2MFVxbEp3?=
 =?utf-8?B?YWVScEVIdk1kYk5MUHNRdlI0M0h4ZTRVNVRMTzZnL3BrZ0dOKzZOODZmc3l6?=
 =?utf-8?B?Q0lEeXFkNiszakhsRE1adVdmTHZyS0czVDZXV2IyOEtydkpQbWlodStpR1Rl?=
 =?utf-8?B?aXhVOUtqSmNlcUpzOUp4ZVI3QzAwN2l4MXROa09vSWNtSlVBeFF3WDVEdk9U?=
 =?utf-8?B?VzhrR2d5WjdPV2ZrYTVNRExFUnpkSDBnaDBlYmxhRlV2VnRhYXNoTVdZL3hj?=
 =?utf-8?B?UE5mUTkyeXpJSWlXWUJoL0N5SmRXRmRmVk9UMDBaQytJTDczYWw0Q05pQ1h6?=
 =?utf-8?B?eDZVMGpabjJqSjh0Zkh2cnhWZi9mVDlZaXZSeG1QOW83dHZLL3ZwZ25pMEt1?=
 =?utf-8?B?YkJQbGdoUnByVlIzaGVvUmlVZDBVajdTMmFVR29PUS8zd2VacEY0ZitIdFl2?=
 =?utf-8?B?UXZEVGhTUjVxWHZlMWE1RGthN091QncxV1U2VU81OWRudHJPSkEvZXptSkpH?=
 =?utf-8?B?eEpuOGEwSmZNZTNQV0ZUMkg5MWxuU0Y0Mm5UZ1VKWDFpVSs1VmlxWHJjakJ6?=
 =?utf-8?Q?aVbR/7E2O2GhK1qOjwmw8+WG/4er80nWqyoD5ZwpZr0Aa7?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab15a9dc-601b-4d99-3d1e-08db40d2ebc7
X-MS-Exchange-CrossTenant-AuthSource: PH8PR10MB6290.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2023 12:38:04.9476
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 06NVM3ktZhYYwdsIKImY5cyqtP5Qvf2w0JyNmlmJUVrBFAgauTbtfZMFD/LbLgN1YptmthF3838v9TgSIddgKPJAlF6JIY/23+9RvQ97pUAs7HPZLAvzkvPSIa9Q3W4D
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6147
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-19_08,2023-04-18_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=967 adultscore=0
 phishscore=0 malwarescore=0 spamscore=0 bulkscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304190113
X-Proofpoint-GUID: R3tG0CUxqu8rEGM5h7Z8zwhkiRV0ukMV
X-Proofpoint-ORIG-GUID: R3tG0CUxqu8rEGM5h7Z8zwhkiRV0ukMV
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On 18/04/23 5:50 pm, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.241 release.
> There are 92 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 

No problems seen on x86_64 and aarch64.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit

> Responses should be made by Thu, 20 Apr 2023 12:02:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.241-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
