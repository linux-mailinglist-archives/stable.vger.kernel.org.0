Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D382B6BD89B
	for <lists+stable@lfdr.de>; Thu, 16 Mar 2023 20:07:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230060AbjCPTHO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Mar 2023 15:07:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230031AbjCPTHN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Mar 2023 15:07:13 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE342E2517;
        Thu, 16 Mar 2023 12:06:55 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32GIidrm001488;
        Thu, 16 Mar 2023 19:06:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=XyiRiGX+cX1dZNcdb5H572KsJK0VpNq5Hsuq8Ckdz80=;
 b=yGW8+d985uMBo/+D6GL69GR9v2mKuGnw3Z/0xkKiCeMhL8eJkfz0MQ5bX8W01bjdZv00
 D4PcgG2hJJXgXiEEmjy1WbKgPGgjVzIMHnz9XzQrWKHpEbm0uftj0sgQXn7Ppp72DFUN
 6735e/5ceiTqgrbD4Awf/1AaSomHvRO7rkGSVl+RSKxHLOsYLs4EabZXGpWZ2CyhUu7h
 eRnh9sBGOvMYBoHUcvO3sdoPCmVetBWwVnJdqQuACMxYXd9ciuEoYBQ7681K/czhR+8m
 vpLKSOE3BCzMDFDrzoOKykpxFtVAfDKc/i/rXSeCN2S9LEJYkXNix2hS723ocTrGvA9A bg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pbs29a1n3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Mar 2023 19:06:28 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32GILbOC023441;
        Thu, 16 Mar 2023 19:06:27 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2173.outbound.protection.outlook.com [104.47.59.173])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3pbqkyrfwm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Mar 2023 19:06:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fqyo/VBnGgYoL4d5VCmWwwfhDiS39GD5MJpifavAAn8bz/uJqrPca/hyvBGZhdZeMlhmux8wH3nC7Yqn5uH8Bymzary2jIzpflnXLf7ghCtghJAQZmpTwEiId/ZkEVzEk/aHKPis0/dmkLWO1BMVPWKH0EX2JLrajGMvZjImSaDTo4vpL1yCFuitNU3G5yww1rG6FQA8InDVYQd0mx6oPow+pH2A4TNmNUIq1a+rHdDw8QtS2L/gEz2/hUTr9T+qIzCSEW6qDTZSHT7Zj1/I9nV4Pl9cVEMGi271MqEP7zMuoB/eVoqYBktIOTff3+7xc4sWOYiua8BnTVZ8epx5Rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XyiRiGX+cX1dZNcdb5H572KsJK0VpNq5Hsuq8Ckdz80=;
 b=llh1BvjGJgXE3NNW4EEWNKr7s+jfzSxDCHCOkgv+3KbxMJpHUMQ4W0Hdy90lhrC5dgfLn8L/7Ss9KEkwTkmDnMfYpiFCPRReReiGHKYoqD2qeIoF5eUz4mm6Gu9+OMLEdBe3e5sLcW3kk3SrtjC8+JUwzW62eK4fr1npJICEeHnwPXVXce/6q6nrC+ze32lUXThyGGVHZYZv8+48lmW3F93u/MYAbl/UIl7GfW4c1ajiL1cNSlroZy6RLz0bUIhBwgapnUU9Yo34juybEfRqhbiWF3K83A00isndvuJErAiZmnjuNmuu3p1WI6/UJUWwWo/jwyEtZIKJUBzv3wV3qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XyiRiGX+cX1dZNcdb5H572KsJK0VpNq5Hsuq8Ckdz80=;
 b=N4dSuML2yRxe/+HqSnKZxkjCl21TUpCyhzs87JbFMzArfYKHLREckGOxKFFDzmpxnNnQsS4lApotF9Hzy3PivG9byPXxFlsDQBp/NvNTRNthO9Fp+r728kzWWQ/ABMV+vlRVFF0tK7kSXEDYfEHRdN8urHgvNASscuuU+Xba2R0=
Received: from PH8PR10MB6290.namprd10.prod.outlook.com (2603:10b6:510:1c1::7)
 by PH7PR10MB6177.namprd10.prod.outlook.com (2603:10b6:510:1f3::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Thu, 16 Mar
 2023 19:06:24 +0000
Received: from PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::ffeb:6d62:6636:6c38]) by PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::ffeb:6d62:6636:6c38%6]) with mapi id 15.20.6178.026; Thu, 16 Mar 2023
 19:06:24 +0000
Message-ID: <d6c0ca11-c583-f28a-dd0b-6961db1201f0@oracle.com>
Date:   Fri, 17 Mar 2023 00:36:11 +0530
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.1
Subject: Re: [PATCH 5.4 00/55] 5.4.237-rc2 review
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
References: <20230316083403.224993044@linuxfoundation.org>
From:   Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20230316083403.224993044@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TYAPR01CA0222.jpnprd01.prod.outlook.com
 (2603:1096:404:11e::18) To PH8PR10MB6290.namprd10.prod.outlook.com
 (2603:10b6:510:1c1::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR10MB6290:EE_|PH7PR10MB6177:EE_
X-MS-Office365-Filtering-Correlation-Id: c0199bd3-fd6f-4fc5-de5d-08db26518976
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YfSgOL/q6tEoCJBdc2Fi8cJ7LyitiXHj9d3vs+QMYUHp9LT5s9FihPHXwL81EDK+/kZDQggJt3S8Ein6YRxnwjQXVOBx+DHNI+3we4kbz/nSY8QVVErOzV2TdYJq1nEQGDFC4JyDtKzeNPHN0x/b7/xpSrMvBhuPqxguFbN8JE4ZU8Gm+BP99Tlh1r+xIA8YykSdXb2oDXVQDaljqd5GaP8CHslT7s7v648svvRKU7b8ItS31hdf+NV25y1efKYDgCj4SwIWh29TNfq0eO/Tc7Wjq9fsJtwsmoGN7cVPxUdXGfr+sRwPCiMgNH/rp0E1QhKXKyh6QQ2l4y4W/R0ZOQ9Kbpn7y77mwDSaKz43tShfKQhYhJa9nuFHTiFTE/5LZckdHuC3TxATZUJIE20/e7yeF8AMP/Xnl81QomiaGkF7lkjWdlNZRSGnAKyd6NNvezr66Rb/B3zfAAv9ASwahkb1BeAb7AhyB3Pt8bNfFzgTxpKdtDu31FIZlGYOKWnIp2hpgOzjGhfZpoEgni3QvANidUSePLi2TlWl1j3MmcDxjseV3toCn9OrBBaz7vsnCzSg03mmjUqLcaJCDCb1sNzSoAY0Besvg0VOQkIsMfFzFv+EeWRrSDDmVm+/K3ObIL69hGtX4zem1zKIGEcsM0zihIhO5TimXkjb6za5qr8qx+LlGNNuY++3Q6zSOx07xQXXvuSqa5lp3oEqbTKuUsyVUFprtbxo8C03tEPWZ6E=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR10MB6290.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(396003)(346002)(376002)(136003)(366004)(451199018)(6486002)(53546011)(966005)(6506007)(2906002)(31686004)(83380400001)(6666004)(107886003)(26005)(4744005)(8936002)(41300700001)(5660300002)(7416002)(66946007)(86362001)(66476007)(8676002)(6512007)(31696002)(2616005)(66556008)(4326008)(186003)(54906003)(316002)(478600001)(38100700002)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ajdWaUlIcitBRWJaOVlmemhIRHAzWk1GRndtSDJIOUJYR0hlejhMSXFnUFBL?=
 =?utf-8?B?QW9YNXZ5cnltZC9LS1dHZFoxcmpLSVpkdVI2N0RmWnJIVE1pU29qcXR6ek5k?=
 =?utf-8?B?TUVrbjM2Z0t3aWFsNkNIcEw4S09uempqWFhad1RlR0gyVVgvYUdFeGJJS0l4?=
 =?utf-8?B?UTRaMzNLNndKOGQxdkJkMzBkOEVDNDFBU0I2QmlMMk5OYUNoYndOL2ExeTU0?=
 =?utf-8?B?dFh3eDFWUEcxaHpvMHM2T1Y1VDRUV1RoOWtQRDE1Rmg2SnlJYUtsQ1Y2cmJN?=
 =?utf-8?B?dzZuNmIzWHNPUkhObWdSd2tBYkpOcTNSQ0o2U3l2T2RCYi9mNDFnT3VjVEFG?=
 =?utf-8?B?cmtVMU1ZTk1kamw1V3c4TEVIeVl1WVBzNWdoMy8vd3FiN3B4UE5uNHpQWE50?=
 =?utf-8?B?cXd4TG9VSXM2ZjI4NDNQdEN6bDJ3RUltQmlCSVlwTkVYYVNzK2t2S3YxM2E0?=
 =?utf-8?B?VGl0T3p5ZmN1M2ZoaWxQTmc2OTc5R00vNlFJQTMzaGdhQ05Qb3BhdU0rZTd0?=
 =?utf-8?B?MWxZdzV2OUQrSHhkZ3gxbnViZFFHSHRqT2NUU3dFOWdER3NIUm16SndHZUF0?=
 =?utf-8?B?ZjRudkNBMGhxZ2pnT1Q2UjhMRm5PMmNNZGVUdVhocWw5alFVRk9sOGdpZTkw?=
 =?utf-8?B?WVJlNFZuWmh1Um5KTkdKWEhSd1FieVFCVitZSTlJUlJCbDNTMUFuSEVPMTJu?=
 =?utf-8?B?b0c1T3NsZnVQbzRDQXEyR2xBbFJ4YVRtaHJkSk5EcjR3MWx4L3FtSjVGWU5Q?=
 =?utf-8?B?RllXbzBRSUFkVmp4VDJEYjNaaVJlN2gzQ1lqRURZNHNNSGJpUCtyYkgydnFY?=
 =?utf-8?B?UVJnbllReENJV2FHT21ZVDVEcU14dXlDSmZ3clMzU29KWU5DYzMvbTNrZSsw?=
 =?utf-8?B?MkNIbCtPQUExR3g3NXFVRCtpZlJ4UnViazJkU0FsMXlUVHpZZ29xcnJLV2VY?=
 =?utf-8?B?S2xEdU9YaFkrbzVCVnZ4UkxzQ3I1M2czUXNrMGFPMWVVWWlvdVMyakFZYWVn?=
 =?utf-8?B?ekYrNHFKTVRzVkpoMzhHdXZLc2pBQ09FNEovaEh1ZEtENlJWTTFrT3lWUEpT?=
 =?utf-8?B?YnJYVVB5NTBjYjdnOXAydG9DMFhxQnIzdFRwQ3ZQQmswNjU4ZWFtNlhTUzFX?=
 =?utf-8?B?djlQenAxbHM4OWFWejZCVzRBMjZvWXQzMUdJRkZHTVBTbklLaTFiVlQyREZo?=
 =?utf-8?B?bG9KcFcyMVlXakZIcVo3OUc0b01YVS8veDhjQVQ0WFloQ2xXdDNaMDhQb2Rw?=
 =?utf-8?B?Mm5xdXRoYlQwWlIzb05nRXJwM1UrbWY0OWVXRFp5bklabUptbDdnRjNxZkRh?=
 =?utf-8?B?VGNudWFvWE01ZmprRGxsK01HbmUvNklPaXJlNkU4WjJ3ODZYTC9UTDdpbHph?=
 =?utf-8?B?bzFDMkh2dHIxZGJ6SnFvUUxOM25VaW9VTGV6VVoxVzZwNFVzODRYMXliekIv?=
 =?utf-8?B?cjgrZkFlTlhId01pYU91eU11NjB4UG95YkFpTkhsL25YUmNRQWd3aHZxZXdK?=
 =?utf-8?B?TUxmTy83Y0FKdlBkblpSWmkvVjdUY1VLOXBDMVBXK1hNbFpyY3hkWjlLbFVL?=
 =?utf-8?B?OEIvVVJnelppazlsK2hGanY2NklJMHhtVzUwNlRhaUpxcUVJNXhVSm9WZnJv?=
 =?utf-8?B?cXIrbUQ4aGp4b0dia3NEcXd1MW5vVlAwNkJZSHprTWd4NEc5d2VIOGQ1TTM5?=
 =?utf-8?B?Yk93eElKcWRzeXQ5RHBWMCtVdDd4TW1TQzhoSDd1YXZocXFDUVAzbWgxbjBY?=
 =?utf-8?B?a3UvSHR2MFNrTmFwMnBJUGQzbHl2QWlHWW82dHZVd2V3VU1lbCtmSkZQTVNB?=
 =?utf-8?B?NmI0dm9vMkU3WDg5NVlVK0VreGtRZTY4ZDlMYVVRdHA3aTJaOStMUzFTSThF?=
 =?utf-8?B?QzJ0YkpXazhkOXUveExDSEV4ZldGL3JyY0pOVzJmVXljNkZhYjdxbCtSRHpa?=
 =?utf-8?B?aUcreVhBRllhaXNhWlFVd2NUNm5pdnVGNkpXK3NYcFdqbTNwbFAxUzVjbUg0?=
 =?utf-8?B?Nm5CQjJmM3NjYk5BUkMweVVLT3BMVmN4ai8rTlNESk11eHJDK09peVBQVVdV?=
 =?utf-8?B?RnBwWDJJdFhIbUgzU1BOUUdHYjJvRFYwakNYbDVsU2RwMXBIc3AvY2JKTklC?=
 =?utf-8?B?WjZPb09JUVBRMy9zbkVMR1VtUDZSMnNiMVBIa2hmRG1nK05lSTE0UGFIUFB5?=
 =?utf-8?Q?XPquhbSim89FOQAq8j4m3Ag=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?L0hLT0ZPYWRlL0M5SkN0REJUcmh4WkJGVEFjTnVXeXV2VnNlR2NRdXBqL2N6?=
 =?utf-8?B?WlRnOUU2ek4wb0pqRDVMK01pelRpcXYvM2hrMVlSMC9QQnBiQlZ1SVMvcFhm?=
 =?utf-8?B?bzRyRW10eFhPcEV5bzVYZURGWnJJaVNDNDFYZHh6dEV6TjhHMCtOY1pOMkdV?=
 =?utf-8?B?NnFGTkZPWllGZy9PZFFzR0FTQ1lBbXN3ekEwQ2dRNHJSL3l2M0phQWl2VnlG?=
 =?utf-8?B?TGJ1bmxBbFVLUFQ3ZDNTdTB5ZjZzYnpZUDRqR0lBb1RaUytZcHQxZ0ZYNDlG?=
 =?utf-8?B?aXFGYWJQOEN6ZTI0UmFrMWdLYUg0ak5tYzFZYXlrSWw2TGVTQjA2MFYyN0FC?=
 =?utf-8?B?VG0yUE1YUVpPc1BPYTEzV1BTWG1iTk1WMXJsb0RXdDdsM3pBdks0T1dwYWlM?=
 =?utf-8?B?TDFxRDExejBpUDVaWTZ5T1JHZlV2akltQWVMSUV0ZXhRQ0dDNitGVG1mR2FE?=
 =?utf-8?B?blcwektVdjJMbE5zN3pPNUNjaElaeGdOdmZFWmJoYnlIai9HanpYRU96VFBw?=
 =?utf-8?B?SjVUNWl4eWlnM2hJc3ovNzNxUU5qUVZjWGlMaGFNZWN5TW5meVZaUUJlY2Qx?=
 =?utf-8?B?U3YvQVFIdUtVRmNhcVpaUjdzZ3pSVlgvM1RVUjdCbmxicEg0YWFnT2RmWDhS?=
 =?utf-8?B?aWN0d2tyYzg1WEt0bXR5R0owaFYyUFVlMzQ0YW11NDhqRmZUbHhZNStnbnVa?=
 =?utf-8?B?Z2w5d0xKaGl3V2s4TEV1bENBQ3Z6S3dTVjJXbjVUSFMyeDlvaFlqOWtUcTcz?=
 =?utf-8?B?ZERIN3FhdFhsQW1KZVNkY0gzRC9oYjQxT3ZlTjRGcEdydEdRTHNScWRFQm54?=
 =?utf-8?B?Z3NVZ3hTMU45Rjk4ajhrQUl4UHIrbFNRck9pUUhzN1NrQWtRU0FZZmM1cDJj?=
 =?utf-8?B?NnF4NU5HUTdybytlZ05ITjVpMkZRVEc2R01RRGIyM3pJc3lSdk80anhUaVVs?=
 =?utf-8?B?UmtxUS9lM3YzZHByL0FQNFFPeDdzSGlvNHoxdWNqRzAyWTFGcTQzajhWemdy?=
 =?utf-8?B?Z2ZSenRnZ0Q3V0k2UG9xSExSUmk4c0thcUNnMlhodXgvUnMzeGpDTFc2eWZE?=
 =?utf-8?B?bmNZMy9rWFo2NUFzU2oxekpvVStlTGVXTHk0L3pmd2RiOUQyd0VNRWdQNWx2?=
 =?utf-8?B?NWF0ckcwSzVKcEZFMzRXR3lrbDU4NGpVMHBNTzhXemVMYUVoVlFKbmtNV1F5?=
 =?utf-8?B?S0dpN1BIcDRyWlhnY01QVmZxbDBtZHkrUEk1M1BSS1RDQlE2dHlKZTRmYzd3?=
 =?utf-8?B?S0RKTE9zMlV2WTNwL0RUcS9sZHY4QXRTSU5LVDc4b25QSTM5Rml5YWNlTHBG?=
 =?utf-8?B?blZhWjBiQkVGbExnWjUvaDQ4Nm9WMTVlTUo2WUg4M29DYjJmcE8wSE1lb1hZ?=
 =?utf-8?B?ZUxjdThzTXlENlVRVEtLbmlzcVZ6TEFOSUNUelVYcDRUd3pCZDR1T00xKzY3?=
 =?utf-8?B?YWJ2RUdLd1M2VkNqWERXdTRWd2JvNkpnaXNjZEt0V2xscUF5S3NLbWJPR1E3?=
 =?utf-8?B?NW9KY0V6elJOUkoxZ1BNUnZwMyttMFpKRDNKd29haXlsYlFjZXhvQ0RybzBF?=
 =?utf-8?Q?go1jVhFIJP/rBPW5XhJbVqMQ+4QJy1bpCDlW06EK2/93BK?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0199bd3-fd6f-4fc5-de5d-08db26518976
X-MS-Exchange-CrossTenant-AuthSource: PH8PR10MB6290.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2023 19:06:24.6344
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y4KHdPMssrenBZQ0CZBdglJUh+Zvkiuqe49US9fq5Jyb/UjXRQqeVCRIH15WDUixOC+o8HGnZ1WRX73Lyp9TT43wRWLudhwFyASG/7EUnakXRXs9R7TthQ5EHivXMqUj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6177
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-16_12,2023-03-16_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 bulkscore=0
 suspectscore=0 mlxscore=0 mlxlogscore=999 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303150002
 definitions=main-2303160145
X-Proofpoint-GUID: Df_tyvV54W1dyi6rRZ4-_-k6OX73sIwP
X-Proofpoint-ORIG-GUID: Df_tyvV54W1dyi6rRZ4-_-k6OX73sIwP
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

On 16/03/23 2:19 pm, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.237 release.
> There are 55 patches in this series, all will be posted as a response
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
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.237-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
