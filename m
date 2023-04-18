Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13CBB6E6936
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 18:19:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232117AbjDRQTR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 12:19:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230523AbjDRQTM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 12:19:12 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D29F513C0E;
        Tue, 18 Apr 2023 09:18:39 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33IExSg1015649;
        Tue, 18 Apr 2023 16:17:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=qF1VSp0YpfrMvoNqeELLJaf6rFxgKjwYiieSkuRBIoE=;
 b=CBwQ6snFCwE9HHGfrbioiEbDeqLs/TGJZ6JNmV/LvjbWYbVUdPDSA1hZQDVQStYxhEQV
 +vk0xnEI2krQiVPLAdpQgxpvqG5qvq3CXQ5vvSNHRmSj5X2hQPVNVMtJWD9Qz0sAnWm0
 l7LXhBxNy2nqCYvxwvPrL4uh/AeqHMLg2N0KmfMlj8kYiPy0756ArIpTd1u+TSLkahwt
 IJy4xvm1rukTGqH5UHc2+CWPkWKUW+Acs26m91gpj5z4fPp8hTzZItrXRTTt/Z8nXBgJ
 ZqigRiqqc2LK/SQo2rmyroJ97B0EyGKvYxfoZoxucs0NiPGHkRDJ25ASWEo1fN5+o+EP Tg== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pyjh1p68n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Apr 2023 16:17:52 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33IFUX0U015688;
        Tue, 18 Apr 2023 16:17:50 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2041.outbound.protection.outlook.com [104.47.51.41])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3pyjcbs2gn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Apr 2023 16:17:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ndMQps50VG5EMODG+3m4qzLWgW7XUGhNvilx9E4aVd5XoHI5VUm4JjjQuHT6fk0zRH/CIVa4wY5qb9QwlridbvsUSxTUe3cyhu59hopf+se3dLelrbyX4RUaZddPeQOKe4Jvg4qy9GPlXghJ+SHLe/cQzB86qc4AxwRG+ok0nRlo6jFrIfvCAWEi8SK4SUdoB2FlScFb9w2cGIrGLOWjYgXGKr047s7paLsHhZF7kz1gM0s2UA2xycKup0I4kBtTDwAmnlqe0sFUoY1MgQ3T3lOyOvetBMtKYvfo4sYUCQ47jQS/hdT3raV35JI+Vh8cezJz7FQGlGMgit5IBEo2zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qF1VSp0YpfrMvoNqeELLJaf6rFxgKjwYiieSkuRBIoE=;
 b=gTtUzc90PmvutZHVDPNeVfrWd8kInZh9a/2XPbD/U04CmJQVWnb10/1CY4IBqU/G/XlKXgjOYm2p7leSdUpqApH1m9yqnuah+mI67aMOYPu0xqHCn2w2KNrkl/EVF5NeQq3H7nDxVX/0IFBFOAIYQkuXwzjkBjfcDGjLNIWukLZ4zBG9N9d5GuL1EYYnAOMKe3BHQBK2lf1+LTrFbOLwV3A9br2OSaZ1rlBBXH5zrhRaf7NqiP69Ihn5bPjhcnwvewsokOy6+T+VpSm73uCzJ/WxkkXaKBGL8xKflHr8ZB19XxgG/e3j8y1kMLPLBpHRI99sQ3j8g/s8Vo5Screbzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qF1VSp0YpfrMvoNqeELLJaf6rFxgKjwYiieSkuRBIoE=;
 b=RzETzqCLj9btlwMFAZjUYWjutRkLK9kz9Fc8XprgFeyi5J5pJSIvIHnP+KR1vYj5MIt3+BAKgDS2deKm/1ynzcg8D3EYAVJYObwJuzwHtKRj3v/QUnzkuQQQkQiJLOUi/WDmYP06c6TKF5k9tn3qKfj2jHcMtCC+2Ku9Guf9UwE=
Received: from PH8PR10MB6290.namprd10.prod.outlook.com (2603:10b6:510:1c1::7)
 by IA1PR10MB7287.namprd10.prod.outlook.com (2603:10b6:208:3fa::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Tue, 18 Apr
 2023 16:17:48 +0000
Received: from PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::68c5:330c:d234:3834]) by PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::68c5:330c:d234:3834%6]) with mapi id 15.20.6319.020; Tue, 18 Apr 2023
 16:17:48 +0000
Message-ID: <bd46521c-a167-2872-fecb-2b0f32855a24@oracle.com>
Date:   Tue, 18 Apr 2023 21:47:33 +0530
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.1
Subject: Re: [PATCH 5.15 00/91] 5.15.108-rc1 review
To:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Waiman Long <longman@redhat.com>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
        Tejun Heo <tj@kernel.org>,
        =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>,
        =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>,
        Anders Roxell <anders.roxell@linaro.org>,
        Tom Saeger <tom.saeger@oracle.com>,
        Darren Kenny <darren.kenny@oracle.com>,
        Vegard Nossum <vegard.nossum@oracle.com>
References: <20230418120305.520719816@linuxfoundation.org>
 <CA+G9fYs9sHnfhn4hSFP=AmOfgj-zvoK9vmBejRvzKPj4uXx+VA@mail.gmail.com>
Content-Language: en-US
From:   Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <CA+G9fYs9sHnfhn4hSFP=AmOfgj-zvoK9vmBejRvzKPj4uXx+VA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SGBP274CA0010.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::22)
 To PH8PR10MB6290.namprd10.prod.outlook.com (2603:10b6:510:1c1::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR10MB6290:EE_|IA1PR10MB7287:EE_
X-MS-Office365-Filtering-Correlation-Id: c1cff365-4f65-4a31-3870-08db4028732d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2W03wz53ihAEwatz+7jkaRQ1sboGhiwuC0Zc1Srm0Jg22P1ielBGIKXHF74ufalAJ3cvqp/wycKTEjoW1Rd2xUGfRG8qVXuWxA3dDhoHBsEx+48aYQCpacA7d/cHbUb36J8xouqWwOPZqX45pYvSL0c4PsuM1+711y4kNlakP9TsVnrqZp0uHhIfZZWzmm8EGRGM4G0uS8q2j5Hrp2f8kikjh3li0C+4Jjm+j0wHslviXIxzhCpgPdFGDro6/ygm8wBP4jfwc/0UyucofNgYbUZtzUC+Xy25kVHvLD8V7fjLW+ZDQ9NpgNBwL5WVtP4SmrQrFkl6FByzz8WJHsTtcjZvjgqDZV4sVm2uT0l1HMvmQkf0WFzTFmggBg/8jeqIWwnUHb9iLavFKyJu5TpLlVkTwp1c1s6ZcK0SGBBx+CmwTcUzyFp3A8otBg2Ll7+QFLxqUF2J4kNNLKH2k6Lj8V8la/dgkQclu009A0/VA4huCEYZK1Wl5PFjFvPyIoA9eowKaDW9b3KxXICx7oXLb5kq6xDzA58fbrTGMeLuFsO19qtRCgXfaKbK/yTWQlLLaxh26r23t9Z2OayfTqxddAv4qvIBzbViQumsk6x5A7wnDCyMKCutM6/igfGJdVZAt1J8FGfeFlp455NauT+LBLRy6AJrfvwlCadMPkZiqL0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR10MB6290.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(396003)(346002)(376002)(366004)(39860400002)(451199021)(186003)(41300700001)(86362001)(107886003)(53546011)(31696002)(6506007)(4326008)(26005)(6512007)(66556008)(66476007)(66946007)(316002)(6486002)(110136005)(5660300002)(966005)(54906003)(6666004)(83380400001)(2906002)(478600001)(36756003)(7416002)(38100700002)(31686004)(8936002)(2616005)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TmcyaWkrR2E4YVRTS3JMeStJdXI5SnNidXF1TnJqTm9ibWtDRlJDMnI1bklE?=
 =?utf-8?B?Skk2R2xNc29iUlNmMnM3b1pQL0xwU291ZDBsdXNITDdKUHJic3J3Qi84TENX?=
 =?utf-8?B?dkEvKzZwMGxqSTUremVwdUN5dXZySzNTdGlNdUlTMWdYRnVyaGphMDR2U3dQ?=
 =?utf-8?B?dkF4N2tKVDJSNFl0YzgzbnZudmcwaEZuaFN5RndvTzh0dDRDSVFrQzNZUHhl?=
 =?utf-8?B?alByNTJiZUIrNFJSaXZCb2hhUGNMN20rY0NCaDNkbXJJWDhrbnpxbXBjdVJz?=
 =?utf-8?B?R0tVK244WitqTkEvN0VTTTdNM0RWaW9GY3I0NzI0b0I2YlhoQ3NxdUJHa01V?=
 =?utf-8?B?YS9PTHFwRDZCNW5GRVoyeVVtcmhkWHhaL1pFVkh1UURxYjYvTjhHc2wrV2JW?=
 =?utf-8?B?ZlBMcUFkWG5iaFlhVkxzdXR5MGY2VFNLcVpxQWVVOGpKTnY1ZitYekdmWVlH?=
 =?utf-8?B?MENxMTFNSzhrRjR2V3VYVVNtTnlhcmE0OFdqTjdqNEowRkZ0SENWZ0pYamdW?=
 =?utf-8?B?cUVMaWlUcGFnYXdCTVVHNzlCS215b00wclpNK0dGODFSMTdkcFBoOE9zNUln?=
 =?utf-8?B?WWxvdjJvb2NIRUtyTElYbW4zL1BxSmZoZlZSYW42MEtyVitLN2piQThYblFy?=
 =?utf-8?B?TklIeElHcnlhbyt1bkswU1IyZkFNKzg0VXo1Ym1rd05XTWFMN0hiMmdmamVn?=
 =?utf-8?B?T25KN3dkMEF4YWRtSGw5aVJlZTlUa0FnODlLMzhCUmNuNndoemZCSGNkZUZ1?=
 =?utf-8?B?d3F1cWRoUVJyMU54V3ZJYnNyZTNGaTQyTFRXMTlubDBzdXhHR09FQ1ZnL0Fa?=
 =?utf-8?B?cXpPNW9wYW1GSWptUW1VNEF1dm1lSW5HVGtoZG5WTGN0UzQvRjZubklRdXA5?=
 =?utf-8?B?L1htOEdLaWFrMlFaNlF3c1kxVSs4dVlDeDVzUHdYVXF3cWoyNnFzN29OWTRE?=
 =?utf-8?B?NGxnWUNSSjdQSjVFZ0x1NmowZ1JmRVNXVVJNbURPV0VmT00ycVByeTdyR0gx?=
 =?utf-8?B?T0JSZzdoNUdLb1Z1SERZVXhDQ2NaZ2pnWTFXVi9OeVA2NnhHbjhDaHVBblBP?=
 =?utf-8?B?MDY4V2hxRDYvZzRoZVJhR0RkN1pWczZzY0JBN3pTdTNLendvSU9RQVk5d1la?=
 =?utf-8?B?VUk4azhjSHhCSnhTSE5SUjkzemlJN2RBemRTdEl6a25OSm1KVjlxd1puMTRh?=
 =?utf-8?B?Ui9XdHNneFkzWDlOa2ZuTklxVE5wMmU4QWlibWpTa2N1SFhMb1RxckVJMTdJ?=
 =?utf-8?B?YWUzcC94V3lDbkp2YWtjTXRFbGg1NFJCLzBnVFc3WW5WdWozbmhJeW9ZdTN6?=
 =?utf-8?B?VUNKTTgvWWhCVGt0YWduSy9yYjFZN0Y1QzNQUDIzZlBMaHE1bjZVQ1pIQ3cw?=
 =?utf-8?B?T1JqazVMUXZRN3llNWMvY0hONjlkWUJhaWEzN3dMM0lMUFlodFVnWW9CQTI0?=
 =?utf-8?B?MkM5eG5VQnFQUDlmVGxVT0dNSGdCZnUzeFUvVEdwQWlvV0NIazI2NXBMVkVl?=
 =?utf-8?B?dGRPbXhZSHFzdFZETGZlK1dPYkVremJZb1hmUExKZnRFcEh1SzVwTXVlR3Bx?=
 =?utf-8?B?RVlmeThFMHprWnNETHBxTG8xR0sydFozS1lLcW5WVlBRcGI4SXIydEh2NWd5?=
 =?utf-8?B?Vko1TEF6TFV1cDJxQnVKZVJLbUxQd2FHNU95NDM5aUVKeDlwQWtuZERQdVha?=
 =?utf-8?B?RFI3TTNRWVI3MkhzSmFUQUZveHVRd1htKzN5R1JVM3l3OEtxWkRhS1FzODJv?=
 =?utf-8?B?WGdXY2Z6azRsYmJmSDJiSERBcm5WazQ5Sm9lWm9KQ0hVYXkrT1VwejlXYjZU?=
 =?utf-8?B?bEh0bGFSVUxJRTJQa1doRGVNK3BKQkJoZC95KzNRZlZtNUh0MEU1ZE45dWpS?=
 =?utf-8?B?TzVFaUsxMjlkTFdyeXRkRmxjYjlYbUlVWUIxTFFja1BtS2J1elU3NkZrOFBQ?=
 =?utf-8?B?YnlvVHd3RUEvbkIzaXljTUJrY3pmS1k4bStqRjFDUU43Ympick1lK1JGd3NG?=
 =?utf-8?B?UGhZd05ZSmlLNkRhUFNGSEsySTcyWUQ1Y3BQWUJ6YXZXakFadDdTcDZWcUZw?=
 =?utf-8?B?VTJhRmtYV2NoVVEyT0ljTXo1UzRWVGcvUHNmb0haT3d3ZWlYaG5hc3ZkV3ZE?=
 =?utf-8?B?ajdiZGwyOUxsV0lkQWZrWUcvWjZ5bjlCWnlEaXJvNG16RENHbDFlTlpuMnBo?=
 =?utf-8?Q?WrWdLOuNcox8k48JhzzFLto=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?TzlCSXJQQmw1ZkZnd3o3dTcwRlF2YUNVa3MzbEZhQWtrQ1BKU3FJamR5VXRi?=
 =?utf-8?B?V3NkQUx5cjliQW9scjZwQW9NRThWa210cFE3OU01eDlyYlBza3pJbGJUV2kr?=
 =?utf-8?B?Z2xnZlhYaDQ4MWJpRDlRRnVlNSs5U0dIVW4zM3RIcndTZm9sTFpTVGNZdUxh?=
 =?utf-8?B?S28rcFF4L0pVK0RGM0drWFJhOE01SEV4V05YdjhjcjhaTVM5bktaR1pjanhW?=
 =?utf-8?B?UGR3YVM3U0Vpa0d2Njh1Z0k3TWRycE42UDhRc1hxc1QvdVBpYnB1S0E4RTUv?=
 =?utf-8?B?WkRESHBFb21GWjRlN25JRk13RkdpQ2w3UEF6c2VnT0dQQ1lXYlNlbmRNWWNQ?=
 =?utf-8?B?QjN6QlhQUVgraG1vQU9VV2R3RHF6bW5LbDNiYTFLdkh0cUt5K0c4SWx1RVU2?=
 =?utf-8?B?aUtYLzE0MmlyYzAwaStvTjUvcVBCdzVRSDVOcXR6QUFTWExIUDhReVZYUVdz?=
 =?utf-8?B?ZE5QZDd5UEZtc0k4c3I5dnJraE5QVDczVGVMVHdoU0JXbVhEc3k2WVFCdHlD?=
 =?utf-8?B?YzlYOVB6dXhwa2szNkxDekhielNYRFI4R1FIb1lWakU4VTd5d004WnRNcC8x?=
 =?utf-8?B?UzFyVnE1Tk1XMGFFanpRVXRsVXV6TXNLb1JIcGpMTWZPeXd5S29QRi9BT2pP?=
 =?utf-8?B?ZHJkbVBJZmhoVDF3UUNIR3BMNW1hSlR1cDdudGxNbHhHRHJOOThGVmxwQnNH?=
 =?utf-8?B?NGtOY1lkY2pKd2gzc1FzZ1lieWE5djByR1NTNGlMa1hxNDZ6YlBFSjdCTERG?=
 =?utf-8?B?NGFpZ2pTNDNNa0lWT0wzcGNrbTRiV2s0alZNOFRGdFdQdzBiVm1hbnhNRE9I?=
 =?utf-8?B?cjMrR2FhSjZoMHJQL1BEcjdqY2tScGduRFVGZFNCVHFIQS82YTk4b00yQXF0?=
 =?utf-8?B?U2xIY24rU0dkdFVtUTNuTDQ0Q1lEdXZWbmV6RThIWXFjYmdFdDhBaDlxMVNU?=
 =?utf-8?B?aUVLV1lYS1djVmZmcmZ4WjNhNjVhcTBQaFNqbGJONDZaRVFEWlRtM0xjZDl6?=
 =?utf-8?B?MFA0OTRnSE5pZS8zV1ZhTmpia1gvb0pnTGNRNCtmaGFCcXpQYXg5NUZpWTQy?=
 =?utf-8?B?SWlzMVByMVJ0UVIxS1MrMjRWYXZMRGxtZ1IxNUJzamxSdG9IYkxkb08xem5G?=
 =?utf-8?B?d0tGMktldGhEbk1NQ3ozQ3RWbjVKd1VqaHZUeW52Z0QzL0xOM2ZUL0JTTVdp?=
 =?utf-8?B?TXpLY241TDlXVWlRNnFvVFFWZy8rZklhOUd1dkpmcFZYVzVpdDJ1M0E1MmIy?=
 =?utf-8?B?M1VSTEJ0TjFRbkc1Snd4WHEyOEo0bTU3dmxYTytIR25ScGptczRMWklnbkgv?=
 =?utf-8?B?UmgvQ1lMUGFibEU1Z2dXc0djRTR5OU1JdG44WU8rMlJzL0N2bW1sakd4RDNx?=
 =?utf-8?B?Rnk5YmpZbmpPWldBdS9HL3ZYZWlHeHJnaTlHaEJsWFl0WW1HMmg2RTZMdFVZ?=
 =?utf-8?B?K3Jab083VGhmYUwwM080K2hEckZCWHRDTG14UWQrdTZvWm42c2lUV0pNV0dl?=
 =?utf-8?B?d3FISzllbkZ3RU9vbkVJUmJGclljVjVqdVpUTXlPcU96Tk1mSEt2WFl6T2FN?=
 =?utf-8?B?STFtb3FLZ2xsbUZxUTNhNFZCRExwNTlOWnRBaVFQRU02eVZ0djZTd01HN01M?=
 =?utf-8?B?U1AyV0ZpV280c2IraXg3dS9qdEN1VVFxbWZMRlRiZ1o5SnhONkI2ekE2OFdH?=
 =?utf-8?B?MWlqWGhxdjlwRkswUzl0UFdicldoOEMyendremRBQWJLdFRNZnpEYWpnPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1cff365-4f65-4a31-3870-08db4028732d
X-MS-Exchange-CrossTenant-AuthSource: PH8PR10MB6290.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2023 16:17:48.2584
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AMSez0nXCwBPEhmLeUyp/B54Yig2fV183rKpt0epGzd4zvpwMZbr2rmtPuDPNWUNcou8SKkHYW7y1I78LHHs82gkrDdoSD3v9TJyWLHQApJg5uLeXHJHTCxwXZl5aXw2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7287
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-18_11,2023-04-18_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 malwarescore=0 spamscore=0 bulkscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304180136
X-Proofpoint-GUID: Qvnve6BxB8IeruVOnUEokxM8YWYaAYIS
X-Proofpoint-ORIG-GUID: Qvnve6BxB8IeruVOnUEokxM8YWYaAYIS
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On 18/04/23 8:17 pm, Naresh Kamboju wrote:
> On Tue, 18 Apr 2023 at 18:07, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
>>
>> This is the start of the stable review cycle for the 5.15.108 release.
>> There are 91 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Thu, 20 Apr 2023 12:02:44 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>>          https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.108-rc1.gz
>> or in the git tree and branch at:
>>          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
>> and the diffstat can be found below.
>>
>> thanks,
>>
>> greg k-h
> 
> 
> Following patch causing build break on stable-rc 5.15
> 
> 
>> Waiman Long <longman@redhat.com>
>>      cgroup/cpuset: Add cpuset_can_fork() and cpuset_cancel_fork() methods
> 
> cgroup/cpuset: Add cpuset_can_fork() and cpuset_cancel_fork() methods
> commit eee87853794187f6adbe19533ed79c8b44b36a91 upstream.
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> Build error:
> kernel/cgroup/cpuset.c: In function 'cpuset_can_fork':
> kernel/cgroup/cpuset.c:2979:30: error: 'cgroup_mutex' undeclared
> (first use in this function); did you mean 'cgroup_put'?
>   2979 |         lockdep_assert_held(&cgroup_mutex);
>        |                              ^~~~~~~~~~~~
> include/linux/lockdep.h:415:61: note: in definition of macro
> 'lockdep_assert_held'
>    415 | #define lockdep_assert_held(l)                  do {
> (void)(l); } while (0)
>        |                                                             ^
> kernel/cgroup/cpuset.c:2979:30: note: each undeclared identifier is
> reported only once for each function it appears in
>   2979 |         lockdep_assert_held(&cgroup_mutex);
>        |                              ^~~~~~~~~~~~
> include/linux/lockdep.h:415:61: note: in definition of macro
> 'lockdep_assert_held'
>    415 | #define lockdep_assert_held(l)                  do {
> (void)(l); } while (0)
>        |                                                             ^
> make[3]: *** [scripts/Makefile.build:289: kernel/cgroup/cpuset.o] Error 1
> 
> 

We observed same build error.(5.15.108-rc1), and investigated about this.

Please see the below findings.

With defconfig --> build breaks.
With allmodconfig --> build succeeds.

 From the above we know that this is something related to CONFIG.

In 5.15.y -->
cgroup_mutex is defined like this in include/linux/cgroup.h

	#ifdef CONFIG_PROVE_RCU
	extern struct mutex cgroup_mutex;

In 6.2.y --> include/linux/cgroup.h

	extern struct mutex cgroup_mutex;

-- We don't have that ifdef in 6.2.y.

Tom Saeger identified that the below commit moves it out of ifdef.

commit 354ed597442952fb680c9cafc7e4eb8a76f9514c
Author: Yu Zhao <yuzhao@google.com>
Date:   Sun Sep 18 02:00:07 2022 -0600

     mm: multi-gen LRU: kill switch

Given that we don't have this commit in 5.15.y and 5.10.y we are seeing 
this build problem.

on allmodconfig:

~/linux$ grep "CONFIG_PROVE_RCU" .config
CONFIG_PROVE_RCU=y
CONFIG_PROVE_RCU_LIST=y

on defconfig:
~/linux$ grep "CONFIG_PROVE_RCU" .config
-- No match

This explains the failure on defconfig and a build success on allmodconfig.

Thanks,
Harshit


> build log:
> https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15.105-280-g0b6a5617247c/testrun/16291026/suite/build/test/gcc-11-lkftconfig-kunit/log
> 
> --
> Linaro LKFT
> https://lkft.linaro.org
