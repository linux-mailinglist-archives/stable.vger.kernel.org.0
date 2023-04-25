Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 179D96EE38E
	for <lists+stable@lfdr.de>; Tue, 25 Apr 2023 16:02:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234252AbjDYOCS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Apr 2023 10:02:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234295AbjDYOCR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Apr 2023 10:02:17 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1ECF13FA1;
        Tue, 25 Apr 2023 07:02:14 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33PDi9v2010207;
        Tue, 25 Apr 2023 14:01:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=YCwIXYtrf6yuEQGN9YCOvbNzVtOK+vscfCNRM9VZS88=;
 b=w8neLtl16MJ52M1k1WafasaXREd26a5XqY76KOARGsFWUG89UzJvU/3Dk7CYZLenbh8P
 VwobyCknwqhVV7kelPIzyfxkS2aE/8E6aeE/fLw8dI7ok3jdJjiQOuiRTixgQa5w7j1v
 whlS3FlxEmH3HAmOm74R+xFzik32wPeuEeYO+dHkjeB/6sd3CZ48oJv05n1hF9JbLmZh
 delfyVLa0tVxGj0pl42g1BwKLivvgGWlKN2oLceUVDzkJx1RJUvSM2Y7I6qB/aYKOWbN
 ckHJ4hAdUsN44CW00tj5uPe9BvEaeaKHRvwGAEpe4B7JFyej5s/D/zwLpEjkXuncbJNZ 9w== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3q476twcp6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Apr 2023 14:01:41 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33PDMPhn013311;
        Tue, 25 Apr 2023 14:01:40 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2171.outbound.protection.outlook.com [104.47.73.171])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3q46167vqm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Apr 2023 14:01:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=euAdgpMLPC2AECGTf4sdO2GV4wT8E8mZr3MWJAFM5y/73Aw5ldmUPbLHtAzYRNN5KTFFFsuJxIpp1aR2DZMnAXiVC2C+lb+8EfrenHnSTwgayux/kIlQAWqfVngFjvXBgmAC1SlQGWrrN3I43SgTOL0dvE6y8DHuLrfHmmjmq8TiqdWHm0XV/H32IMr7kGmpGM3zgnb6BmdCHNPO46XJva/4uJr1YR/J8Gr+cbIvtz+dNWLPMFwirOTm9WmgqmTp3L+97CpiRBGC/iW9ScZtnZCvPzfpdnL8YtCPjdSkN4+hVo1aaLrnI/+X7efQi+XAgJKh2CYnu7teUGFavcxCcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YCwIXYtrf6yuEQGN9YCOvbNzVtOK+vscfCNRM9VZS88=;
 b=if5quGfFSFVUd025GQ93kTkzC391Le7Z/zgZ/FnNMhjrX1MzixDJMuTdobresfeK7FOhthNPhJsvL7b5byONntB4Q6dYTl5pCOvguse5nXexWZ5Ipe68UV/PfsSC83fQUif5qRACdZUi9cVOUW8+sHpKJ6FuAYrqvPdKEGsWArQloGwlyc3wi1TDH2m/WPGAWusOGrmDBvcoQ91SpQdoNvc/lcGMiDUVnm8xYQeMZL2wO1GflZro6zGKj9XqlY5vdX4Tx2IHx3d25DzK9OyhPhLCwocmnNeGDxTbsW3zutZQ0cVtTO4pSDrwOOIm/8SvUROEuEKu2BO3XHuQ+LrjUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YCwIXYtrf6yuEQGN9YCOvbNzVtOK+vscfCNRM9VZS88=;
 b=NEuA/aPhKNX1IiJHS51gh3T6GdLev/2f2nma0pA78e/lmqk/qr2WUkWc0yu//5WaM5Zp4owZOlA7K6EcLGT9pJjoCIaXAp7OAp3OrHwA3DLZdSivU9o/dEAs201i1IR+Wqg5S2tNTH+NrCO43wRI9iaUQp/n+YGscs3EaOUr+uE=
Received: from PH8PR10MB6290.namprd10.prod.outlook.com (2603:10b6:510:1c1::7)
 by DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.20; Tue, 25 Apr
 2023 14:01:32 +0000
Received: from PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::68c5:330c:d234:3834]) by PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::68c5:330c:d234:3834%6]) with mapi id 15.20.6319.033; Tue, 25 Apr 2023
 14:01:32 +0000
Message-ID: <b1ce566a-6a47-113c-8e01-498b848914f4@oracle.com>
Date:   Tue, 25 Apr 2023 19:31:20 +0530
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.1
Subject: Re: [PATCH 5.15 00/73] 5.15.109-rc1 review
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
References: <20230424131129.040707961@linuxfoundation.org>
From:   Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20230424131129.040707961@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2P153CA0044.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c6::13)
 To PH8PR10MB6290.namprd10.prod.outlook.com (2603:10b6:510:1c1::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR10MB6290:EE_|DM6PR10MB4313:EE_
X-MS-Office365-Filtering-Correlation-Id: b4eeb9bd-9871-4285-a303-08db4595930a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aESvK4LqeASNNzdlfmyCPZ7rk1h0IWT1dIFaWu2Wd3FXgGIyQgCYGkpjzRikFqt45eYr36XMkenkNmrfOPV8sTqk4df9p6JUv9J4SmF4hFcdSOPuPM5I7Ij+mx4Vfl67ErbyDoOspWqQxPqRgB1e0hsl1Hcj7hk07u+v2PgeWVM8N/NPDWPd9cxGlrjUZRDVz7NZam9O4Dv4h4U3mvaOTfp5noerhspWMpXQ5dqAi1ni/WLYDZ/EsuAp3az1qgZOEQXgwnSe9AteMQSsjTIViaA6oBhWwAcz/XksHAXDFTncsMz5qpww3ZnPx6WLIe5hEu4os2CBYHZ3ORVOXrf8NRK5BHZUtxayajRAHlCOfJz88+ZcYU9nq0Ds/WrCKG8XlCJ329Qxvw+OJfg9BZrnQkB0rYILrsD3HSL4zd86K3YHcEnhk6G5K+6Il8wssJh7lMxBwV/Iuhi1aiu9tFL+W2MEzAIub7/g+Tfgg+ds57rRgFaayehJHM0SeyWNA7/TOXBpCHPO+2swu+xIiMylS/QqaEYHRXPMj6MMhuYYhXIVDifZHcFZ2l6zKiRFzKO+DHqAi1sMR5hEG8u21H2zDiQyKcBckBA4dr8nVHTu95qkWqqanmyvzie5e4OvwK1cwAluasrZEluA+Ljpd0Ydgg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR10MB6290.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(366004)(376002)(396003)(39860400002)(346002)(451199021)(316002)(4326008)(38100700002)(41300700001)(5660300002)(7416002)(8936002)(8676002)(36756003)(31696002)(86362001)(2906002)(4744005)(66476007)(66556008)(966005)(6486002)(6666004)(53546011)(6512007)(6506007)(26005)(107886003)(478600001)(2616005)(186003)(31686004)(54906003)(66946007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cm5qd2lvY3gyeGRLN3VXMUlhaXdkeUVpaEQ2QSs5cTlxRWJjMEVFNm5Temlk?=
 =?utf-8?B?ZmRKcHcrQ05kQkRpMzR0MUNBOXFnRXZob3NVMTRzdzVhaU5iSGl0bWZ5Nlpw?=
 =?utf-8?B?cUgyZjRGbi9MZTYweEhuVjNVdHFzZllqQ2dzK2NyekxLYVBTbVhWdS9oYU1V?=
 =?utf-8?B?SjJ2bGNnNUZ5bDdOaWVReHlabWlEUmI4bmxvYzlJQmg2a1pZQ3VKTVB3QWdo?=
 =?utf-8?B?VTVKZFZPMkVGWmFabUFyUFFJQmJzN2ZJdEg4NExNWTZoMmhBUGlCODJDdERi?=
 =?utf-8?B?bElRVDdWQnNsSlpLQ1JpeTVscngyT3h3ZUNRMXl2bXFlSmsvb0xLRE9vS1NW?=
 =?utf-8?B?Vjl0UmVVMVVsRXVWVWoyNzI3K1FxMVlGR2ZqY3Qrc2RDYldUNzRIRFBrWUJz?=
 =?utf-8?B?WmxyNnd1d2dVSzkvWExmWlR3RFlUQnpnblhpZEhBaVkyZEJlV2tCbUluZHJI?=
 =?utf-8?B?Q0xPVGNKdlNUVTB0d1RWMWF5ZXVUbDRSL2NqSzN3ZGZTU3pLUG8zaWtNaVpM?=
 =?utf-8?B?N2FvQ2t1dkt3Y3pxbzhDY3lsd0UyajlPVDZETDFOY3lBQTlFRWxaYzZEWlNw?=
 =?utf-8?B?Ky93ZGNzRlB1UXJ0elFrdHlodWNlR0VoYzFuNk40dmZkSmN4V293MGVYKzRv?=
 =?utf-8?B?Qk5zT3c2V1l4TTlMR05uWEJ5bk8rd3hHcXI3cFVtV29UaCtGVC9FL1N1OTI0?=
 =?utf-8?B?Z0FLNEk1VG0xMDNUWmdsMjdlYTRHWkYwU1pFQXczUURyV2MzOWFQcGVEUWMw?=
 =?utf-8?B?SE1VSlpkaEQ4RytYV3htNjZkY0xZVzdZM093QUVXVi9xN3dadFo0VzMycFNp?=
 =?utf-8?B?eTR1aEpPNmd1QWNvbVY4RC9aNmJaQWtZVE01R1hXODJFdjkzc3ZWY29GdTFu?=
 =?utf-8?B?bjhjVnVMUWJ6SkcvRHMxMC9xdzIrNlNza0s3NjUxaWVqUnJqVk9QU3d3ay9K?=
 =?utf-8?B?ME1NTVhPWkJ1MmhGbnozZS9jZlBqRTJNY21EOEsxV0Z1MDNwTzJWVmJ4amQ1?=
 =?utf-8?B?eWcrNGlOMnZhTGI5Z2lvZzlFbEkyTWd4T0lSVFdOTnRKV3ZSajQvM2xHaUJ0?=
 =?utf-8?B?em1UV3Rtd0pFSzdReFBvK0NMNkpZZkdhUC84MG10WHB2MDJhQktqbDEwTkhx?=
 =?utf-8?B?L0I2dEY3RHNzOXIyb3lYMGQxU3hpdENyWjA2T1U5S1k4YnpBeGpCTXJTbDNl?=
 =?utf-8?B?QlZMdjB5TENpSTFDZ2Vqc0ROUk9HeTdwMWpFWmppVjFFdjFDQ280MWczU1p0?=
 =?utf-8?B?NXVhbGZFeTQzOEc0TVF0MTY4MWhYVldxbCtRQXVOWVVET0FsKzFMQ0haM2ll?=
 =?utf-8?B?cHFiRUNmWnZLL28wczFpVlQ0Ynp1cDNGQWdtNzJUMVROendOVm1QS28rMjls?=
 =?utf-8?B?UlNGaHZ2Q1ZzWjF2UHBvU2ZLYW1tVUN3eTRpYU9KVU84RnRiZzcrazhUangz?=
 =?utf-8?B?Nis4aDR1eGZFQllqYm4xMUdveGhQU2hmRjg3OXRsQU9qeVNhWGJRVzRTNitH?=
 =?utf-8?B?WGFRUlhPeU1IVmxzRGJpU1lna0wwOGQvUFQyM2hNVlBoUlZOaTVkUE5kWUxH?=
 =?utf-8?B?V1VJKzZhbEMya3ZpTlVoQ1B0STNya0FZMlI1UXl2VXkxZ3J1Qkpzbml1ZEhv?=
 =?utf-8?B?YlFsR1ZQU1Z3Y3NjZ0F5VmliUkhUa2ZIYklVVlJ1RjlLSXJiemdXbnFlZVdm?=
 =?utf-8?B?Qm9FSTNvem5oVGIzSkpCWlgrd2JZZUx2eWhyY1h0S1RlKzlEV1NWMDZhamo1?=
 =?utf-8?B?RnhENDhCRTBCVGRkWmpQTysxUzdsenJkZmovV3NCSEU5eWh3Qk1QaHRGaG9n?=
 =?utf-8?B?SUhHTnFyZjJvWldZa0R4U0JPSHMrNC81aTFBaFE4eUJpUyszNXhCRjk3Qldh?=
 =?utf-8?B?dWJ2ejAzOWhvdnlUMzFrbjAvakdrU2RycG5mQ1NVWjhQQ204bkpCU3hZNGM4?=
 =?utf-8?B?REtiUW5MTGc0RGx5WlFpYjBlTlVCMS8rY1RpZnA4NWRYenY2ZlRDcHlVekEr?=
 =?utf-8?B?aFQzOEFGQUl6WHdodENXWHc4eUlxODlFeVoyZFBTZjhuallyTHZJMmYrdG9l?=
 =?utf-8?B?MDMreUVSdkhwc3ZRZlNBT2RReGFsVjJyWjFOSXJlVi84RWZQRHZWZ0U5R1lV?=
 =?utf-8?B?QmlEaDRBcVE2bVMvWXdZbm56STN2MEZkNnB0RHhHR2VPdG52MmJMV0VmZ1Ja?=
 =?utf-8?Q?KgLjTFQgMwbc80AWGPcobGo=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?RENWSU5kc0NWSnJWdEk1M1RCdjF6dmJHUlVLTE9NMkk0bFpGWVNNcVAxTnBk?=
 =?utf-8?B?WGJvVXlYaXE0SzJrWEZpTldGV29nalBmRG56UDN6cEp1SDBpaHNDTlBXR3ph?=
 =?utf-8?B?Y3RyNEMxNVJ6UnVKQUZWOHpQOXkzbXQzZEc0S1NVVVZsYmUzVm4xZ0xGaHUv?=
 =?utf-8?B?NzRXRXgrcmZoSzEwemsyUDlBR1F0QnNBSEc1NTVyeVp2SXE5cEZJUDh0aXdE?=
 =?utf-8?B?dHNCRDFGUXZFK0dsTENoNkNJS0swNWFWbGZKRVZRZVZDVzd5K0w5N2tKQm5l?=
 =?utf-8?B?OTloZUlMT1dibDBGMUxiZktMR3pHQUlQUWhRSXp6MDlNTUpuV0EzRVJuaDRE?=
 =?utf-8?B?UXJXeDJ0ZlQzdUMyUjlOU0FKbWxDN0VhVUt4dUNBU21qZDlNaUtwU1hPOEc1?=
 =?utf-8?B?NW1vSTRXdnhBM01OR2tRcTVPM29uRUgwVDNJUnRuTno0cU1YYzhXQUNCckRr?=
 =?utf-8?B?OWRFY2F2QVZvKy90MzNPRXdlRmJPQ3QxaWZ2MXlwTmxnZm91WmVSem4vRUY3?=
 =?utf-8?B?VXNRS3ZDRFJoR05ocWczOExEQ1pzcUtSenZlTHh6OTVEUmp5UHJ6M0JqdXZW?=
 =?utf-8?B?eFdUR29HVi94OTJBd0RuTk9zdGthVVY0N1dxenpuK1BtUGRXMXZwMGdiZWth?=
 =?utf-8?B?N3E2Y3psSXFkMHNqZ0w5MmxSNEtSVjBHcUpFM3NMVUE1dGM1SUwyWEREcnZl?=
 =?utf-8?B?NVlKZWx4WjRGWExCRGFQZktyRzJXZ3JjTXoyNzRTeGVIUHJMcGloQjhPaFdl?=
 =?utf-8?B?VVhScldHckFxcGp2Uklqc2Q3N3hyTXcxazdZT00vV1JkdFdsYzlwbkRiNUUy?=
 =?utf-8?B?cFlLV29wL1luc09DVE93TVYvRWg5bTFqdWJjVlhBWXhMelAzRVdGSENNTmtn?=
 =?utf-8?B?d2FlRHFtdU9SUkg2WGpmbVlFcE5hYVhSSDhWWUE4djIrdVZGVFJIczdneFV4?=
 =?utf-8?B?eEFvYjRXLytMeDNodGIzVVVjYnBjRHBObFhhVTA5ZVBFRFlZZVBVV2Z2ODRX?=
 =?utf-8?B?SXQvekpmWXZZQWFQa3RoOVBvZVNlNWl2RklzZ29HVENtREZ1MExDSitJanFw?=
 =?utf-8?B?R1JySVhmR0NrdXRsQzYybUZvY3Y1NFBFS3owVHNDZWlzemJCVytRNjFMTmw1?=
 =?utf-8?B?M0hibGdjVzNmaUhqNFA0cGlYOE5Lb1NsdU1WNnk4SjAvOGhVN201VWpoN3E2?=
 =?utf-8?B?emRFTis5TGtTV1JrdTNHcWp5aEcvd0UrS2lGWUJqc3U5bk53ZXRQc2JyYkU0?=
 =?utf-8?B?czVCb1laOHZGMG1FV3lLM0NITVhvNkkzTzNSN0pwK1VhdWVRVGlGRzJGRmhU?=
 =?utf-8?B?cUN4WTN4OXpzZEZLMUZRbk1qSGN1eXhiK3pjTmIweDZ0SW1JTHQzUXVhdXF6?=
 =?utf-8?B?ckVneVZLNVdSVThNNGNwb3JxVGJTOFNnQ2QvUE9teGMzaVZSbHgvWWZRRDJT?=
 =?utf-8?B?VFZPWFFHK2k1NGJTQUNyNVhIQVRuNUVCY2Y1ZkhTUndHZW5qS0FjRlpaU0lY?=
 =?utf-8?B?U1FWcGNvalFEQzI2dUZBdjZoSENnUTJWU0hYL2crdm9UVXppZGl5N1VlZHY0?=
 =?utf-8?Q?iwJZfaaBP0K9+PKLeS6+fxnjdTAi1FDsjPDJk4Wy7xIrka?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4eeb9bd-9871-4285-a303-08db4595930a
X-MS-Exchange-CrossTenant-AuthSource: PH8PR10MB6290.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2023 14:01:32.5505
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7M2Y56lxGVPhsjnBUNh7aox/farGUHiI4bBmUabLfLmRt9X/yYrq21xrEUoAxlBdJih/DTJeeaLUfUtR0N8ormz+nhh2u/gZQkJQoraLppnI9MS5GLJsy9gbtOrgymju
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4313
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-25_06,2023-04-25_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 adultscore=0 mlxlogscore=975 spamscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2304250126
X-Proofpoint-GUID: qe1FFnU_ijVnRh__sA9tmfqi_9R5eGnR
X-Proofpoint-ORIG-GUID: qe1FFnU_ijVnRh__sA9tmfqi_9R5eGnR
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,


On 24/04/23 6:46 pm, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.109 release.
> There are 73 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 

No problems seen on x86_64 and aarch64.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit

> Responses should be made by Wed, 26 Apr 2023 13:11:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.109-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
