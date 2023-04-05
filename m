Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71F106D743A
	for <lists+stable@lfdr.de>; Wed,  5 Apr 2023 08:10:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237119AbjDEGKi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Apr 2023 02:10:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231589AbjDEGKQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Apr 2023 02:10:16 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C72534C2B;
        Tue,  4 Apr 2023 23:09:52 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 334KooPl023444;
        Wed, 5 Apr 2023 06:09:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=uLSH7dfXnoRVX6kDmNt3BrlGl0thFo6ZDI1yHjBktkE=;
 b=pWBH3UFJVPul+vv7t+lV38vvVfmUhXO5XiShtCwjMQb4w/f3nrYTQIuno4ION5rfH9Wf
 HG2MGWRoNSpKZ/lezIRGONLtaCR5YhQrNMOcEUWnfcSLvYIDXMc8fxm/etbyDHpghjUg
 zvufPh/pLPtkWbBWNnyf97xZtJ3mgBSnU0zOcEKE+RUfOi4k6nWANr4JWxjZEe+fHOAS
 AuPYPIwvUp81rEq+mHIZkld24yK6A6PGGheWAFbrBxhGV1+q81DyU7BN9UOyZwO2FesK
 M3fM/bRDQrjAO+ZHVcDNpmlkzlftD1HYSdEl5vQhyx6xDf7O6lmpekMi7fwHwdnaUi/a Vw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ppb1dqgaa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Apr 2023 06:09:15 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3355fYJB038565;
        Wed, 5 Apr 2023 06:09:14 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2102.outbound.protection.outlook.com [104.47.58.102])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3pptjt4ygt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Apr 2023 06:09:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UQfoqJayEsv6Dac0XTh4XjNBkZfcKFSz5xTvNS96M48ff364iew29PWTl4yX1cOb7FILgYEgY55z6bRT8Urt4G5goan+XnLrReboR34ms+PZQFBUmY0XCkgxZMjy/EAHnLeXFcDyX3pkWA3hAfcthW+BqiwH3wgqft/ueJxexOa5pWsQGYu8FP3tHHmmzhyPCvgWwaHwcpdzIdDaeEXQps+6GOBPn7j8DAzpxWsbbyp2BYtujBB56C//HUy599dXL2ItcHRbWjcojWgH8dtHGDNYjYFrMKcYkG2mn+cke19jt8H2vdOpWp7AUxMTzhmWw4KypPRb2cwGnpZNZBpGoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uLSH7dfXnoRVX6kDmNt3BrlGl0thFo6ZDI1yHjBktkE=;
 b=GHqvZulgoZ+mRS9TpzCNddNdGAyDBgJCNxEjyJMbgG2PwIlQpSxuQnoH1qX1pHwGOuNVzS007k3lj7c5IUKGLWemP6g3DUr0LzP8E1hJmgATkzeLjDn53SOsCgnNUFUBJaZCV3kv/fUTt/z845gzBrMDcknrHl32shvYxwH1htA4A0TGeuB9BZ3rxP4aWyK9dm8X2iqBGk5E82r/h+Cpq36IbSkJcbdqpZNo02ynHH4YB8pHTKx4EvyHgTXhfNIOlyfItE3ig39Rjunx1g3DyQ8AZrI8qU4Lt04AsZGozyF69i/FzwT2OkE5pV3vdQ8QeJXWKLMjK/SNhtqN1vj8vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uLSH7dfXnoRVX6kDmNt3BrlGl0thFo6ZDI1yHjBktkE=;
 b=Jbg8YDEnt5HnZ6bOJRSBg3ziYy4uJMnbGTu4y7xBQsQ+TM87hfnshB1h6KyBWVvF2yA46OagK8RpkWG5wYbCOUOKAd2czsb91KrIrS9FhZwEKxjyQC9oxWK2HVFh4RI1xQObFAs0EY5I7vU3MfUb2eLcs0auBaGZtvsUtLLQzYY=
Received: from PH8PR10MB6290.namprd10.prod.outlook.com (2603:10b6:510:1c1::7)
 by DM4PR10MB6768.namprd10.prod.outlook.com (2603:10b6:8:10c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Wed, 5 Apr
 2023 06:09:11 +0000
Received: from PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::fb63:990:eeef:ec00]) by PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::fb63:990:eeef:ec00%8]) with mapi id 15.20.6254.033; Wed, 5 Apr 2023
 06:09:11 +0000
Message-ID: <4c0e8944-a893-ba2c-2451-82613bfa2461@oracle.com>
Date:   Wed, 5 Apr 2023 11:38:59 +0530
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.1
Subject: Re: [PATCH 5.15 00/99] 5.15.106-rc1 review
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
References: <20230403140356.079638751@linuxfoundation.org>
From:   Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20230403140356.079638751@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TYCP301CA0003.JPNP301.PROD.OUTLOOK.COM
 (2603:1096:400:386::9) To PH8PR10MB6290.namprd10.prod.outlook.com
 (2603:10b6:510:1c1::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR10MB6290:EE_|DM4PR10MB6768:EE_
X-MS-Office365-Filtering-Correlation-Id: c37764d8-2185-4119-385c-08db359c4656
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Mykmws9bQquSyw6zcNLt71uMeLT1BuqUrZpyLSEhT59igt821En35JRRJDrkv1ChjHO7LqEiMEGhHB5UqdEcFOUrgXX08IsmWHui/EsT01/uskGaXJPtND57t1feCk6BIYOpanYTmSRMiLuS6kY986dqGDSqjPkDhnaGul0IGU+yKxbnfK7VapTuqzUQpOB+virwdr04E3aG0fRv7VjQNN5BSv/VzryCo+DjXwIPZLjJigbu4bkvRBZhMlPdyCPbSqI1IDpF8HWs/Rt/A40k6gD7fYJ85e/EGdaGpOklaQHJ1ebAHJdKI7zrd80PQZw7XyyDWq0KEhvDIlt3pm2JPdKwvIrOuCoDPr1W8Cvdzlcs8ygJ4KrbV9jJ8nXgPBk88DjvXZcpuSeN1bN5tao7coWk/OqPEcWWb96icIOL6MGDUTELaatRgZncW+lDuFnwdsl5LMF+54OKpdsEsZxgWwTuXzzzpZI6hGMD4OYCFQE7LIX2YS9RiwJqiK8tR8n0LQ9XVzNPxi8KrvibA4a/IC6XUS5zs9Hbk60jodk0/LYcIZBR+3kskbyeptLH/R10pjT4Uq7JY0dc+5iZ+rR0TkUzX1+103VZoMOADyy22dPMX+j5pNPYzYtd6DaWzMWyqA5Nkx50xZ0ZyGGDRxVwAQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR10MB6290.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(136003)(346002)(376002)(366004)(396003)(451199021)(31686004)(66476007)(6666004)(41300700001)(66946007)(8676002)(66556008)(4326008)(54906003)(36756003)(478600001)(38100700002)(316002)(31696002)(86362001)(6506007)(6512007)(26005)(186003)(107886003)(966005)(6486002)(53546011)(2616005)(5660300002)(7416002)(2906002)(4744005)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bisxaG55VGZISXNCN21SSTAvcS9FeGZlMzJZME5sL0tMVDcvSmV4aWJscWpu?=
 =?utf-8?B?RG9PWFd6eVlkdUNPb1BGdlc1ZXlyVXZrRHR4b2pwVng1NXM2QVV0N1M5cG9z?=
 =?utf-8?B?ZFE3QTlQRHNrdkNDRjcyc2lhOC9CNnYzYXhPMHJCYlpSNlZyaE04MS9sdVND?=
 =?utf-8?B?VHNRcXBEU0ozMTNtSTNjeTJyc01ySU9ycE1BblpKeVdSSzVDYW9PM1NsR3Bn?=
 =?utf-8?B?MUlXcithZXg1V3BIM2JhcjkxbkNaUHFjY2JjSG9GYTE0ZExVSkJtbjVJdW9v?=
 =?utf-8?B?ZlR1MW0yRE4vNlB4REJmby9ZSjlQbVYxY3U1WEp5UmM4a1lId3dqUXVWU0pW?=
 =?utf-8?B?QUtSdW9lR0h4dDRYRXRoTG5VRG5BK0pwYTZ6WFk2cHJ6WmFDeW93enVoVEhx?=
 =?utf-8?B?R04zNmZMV21kOEVLcmpCKzRNWlZzRXlzdXJBNS9GTVBpaFZGdFJHajFqaUpE?=
 =?utf-8?B?ZXpLQlV1RWtMTEpXSmpBQm5kTmp0Vng0RzZ4OGR2SlAvY2p5UDRzUEFnT2w3?=
 =?utf-8?B?TWR4eXB4RDdjRmhRVjkrNHhSaUxOTm1vWTN5UVR5OE1CTitNNlFzSjdMZXBj?=
 =?utf-8?B?bTJaamdlZWtHSm5BMGNqR0ZUblNML2krWHh2aWVXK2NHVXB4bTVabFhTWmdq?=
 =?utf-8?B?ZmloSHFjQjg0QzBIRGUwRm5jV05xS1F4TEZGUWhkR2JjZWU1ekl5WHJPTURN?=
 =?utf-8?B?UXN6MXJpdzBLT2Zuc29iZzIyeENHSTZWdktVSlVCWUc2eitUL0d3M2QweEpr?=
 =?utf-8?B?T1pzM3VZZ3Y5R3B5OFhsYjRveEhOMTlkbXYrQjg0TzVHQnBNOXZmZUtqd1RG?=
 =?utf-8?B?NEloZnR4ckN1bE1MRm9VNWwvNVR3Wjh6MXFpa3RYNUU0TVpHS3ljYkFKenBt?=
 =?utf-8?B?WDZSN2dQVXhoVkkwamlIUktEd2ljNUV2S1dLTU44bWduNnBvM2xmMlNqSU1B?=
 =?utf-8?B?V3B6a0RvbnJkZkw2RHVqWTAzL3BPcCt3Lzg3VTlyTktFcC8vOGRXUEs2dFRW?=
 =?utf-8?B?ODBQV2NmYWVKOHhRaFc3cFQrVUFpbWtiWmZHYzVpbytSWFVlRkRSSXBxdU15?=
 =?utf-8?B?OS9LbWVUbU53Rys0OG5McmFRK1Q2ck55Z1ZCUWd0YyttQXJRc1NHWmF0NWxL?=
 =?utf-8?B?bjEreVVtRk5OZkdIak5ENGwvQkx6OFhMa3VQZU9ITEVnQVNZWmRvRVZKSnYw?=
 =?utf-8?B?R3dWUlkyNDNWZnJCWXE4emVZWlFxUjlXZ1h4YUloZDVieHdycWJ5bTNwZ0Qx?=
 =?utf-8?B?TE5uRG9KWjRvaGxqV2lKTU9wZlpuWFFmRzNYRXBxT3JlalFtdzFUZjkwcTJq?=
 =?utf-8?B?TnpKaEZEN2lUYWpIZW5IY1dQcjk4WlIwQnkxR3A1TDhNOTJtaWtMbk9SNjd3?=
 =?utf-8?B?RTZDZWQwUWFjYWhVdkJvdDB4ejZNSHFvc2FUSHBJWFZzTmxQMGJFbVdYWmRF?=
 =?utf-8?B?TnlVOGRHOFNEVkZWS01sbXVBcVBwV1BRczJOZW9pZ3lCdmlPdlpnL0JjZjlK?=
 =?utf-8?B?bGhnMzY4aDYvRmpDajJrNnRmdC8weFFFQ0dhSWxaZ1ZZL2dGZ2RXcmxGbzVZ?=
 =?utf-8?B?VTc0bW9PZExQeEgyckFBSmxkcCt0WTY5N0NLZVRiT0FibGNUc0lkbFAxSCsw?=
 =?utf-8?B?YjdpNVZUTUZtZmRBb2hkMnhyelFBS21GUVBqR3BWU2ZUeXdzUEd3YTRFSHJq?=
 =?utf-8?B?S0FYaGV5dU1KRWtseGEyc0pyOE1PaXNjN2dXcTlhRkZNSUVVUWJMZHpLRWt5?=
 =?utf-8?B?bWY5NTE4V3BnODZhanRjNHhnTXpIaUlISEFNYk9uSWtrclNqK0daOWxHUHRT?=
 =?utf-8?B?NzJMUitjdG1GTHBDSUdibXFTbHNVdnpHZkpTOVF5L3hOVnNqWDFmTDAvdlBl?=
 =?utf-8?B?amxneVJEclVjUklOaUVxSjh4enFjcDRmYmVNVXpSTkJUZUhQdW1pM2wvckVD?=
 =?utf-8?B?RGxwOXF3LzYrN1lQTlJNTkhydXE5TUxySXhIQkNVZU5EaDJXazVnRDc4dkkv?=
 =?utf-8?B?YkRkWDlZWUJtZnBadG55WG0rVEtIbnExZDZCNTk2TkNtcGFCWkNia1dOaUxN?=
 =?utf-8?B?Y0Jaa0JHR0tKMi9QbmorTE9NblJRU3gwYWdnYTJ6TGVJR0lDc2dCd0p2VFo5?=
 =?utf-8?B?VWMra2djMDlib2hUNWhlaWZRSm0vdjFyNkxDcE5KYlVFQitzREYxYmg0K01r?=
 =?utf-8?Q?iTrLw7wPaXy1lsTUzeBLLaE=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?K2ZoOVIrQWdXSGRLNFpMNmljazdNLzRxUjNvU1VBaWJLMklYUUNCd0U0T1VM?=
 =?utf-8?B?Zi9BbUpaY1ZBRE5PQ2prWGpUSzRqZWVwM1RweUVFSngxQ0NGNnJvUUt4Mm9O?=
 =?utf-8?B?b1A1SFlCeHlUcVIxRytCY3M2VGROQkM3Ulo3clJiRnljdTgrNlAzd1ErMC9V?=
 =?utf-8?B?TTlscVg3QXZvQjdwWjQ5bEFKWjZjSmJnRC9lUTVxU1dWc0NCWGtQaW1LeDc4?=
 =?utf-8?B?T2d5VDJnRkcxVUNRQ0FtdU1TcTVWL28rVW5FR2VhZ3NnVkVKalA3L21CT04w?=
 =?utf-8?B?Y0grU29ld3NZRkpWbDhva0FkVFBvR3QybFJhaWFkQzU0VGFuMHlQOFNnWEtF?=
 =?utf-8?B?WHZjS2twNEUxMnU3YmJrQVlWRHV2ajdGb0tDM3hrRjlNSzd3TjdnOVFNN2ZN?=
 =?utf-8?B?VmxXY3lDSjhFcS9ZSWV4RlRmOXlVUThxOWlVeitzU0hFSVZXc2JDYVdlalVR?=
 =?utf-8?B?Sno3NHhRM1VUUy9zZ1FLL3VrZzgwQitFck12VEtTV0o0NStMWE9ZbS90aGY0?=
 =?utf-8?B?Wm5xRG1CVEJ5WjBIRzhrTjlvR2orRitsbFQzSDZWMlc5T1NQVFVZT1owV0NO?=
 =?utf-8?B?bkZzN3BHQ3p1L0tqRldTZE43WnVxS2tlbVY1QW9rZi9YTHlDUmlxRFdMT01C?=
 =?utf-8?B?MFlTa1ZWRytObzBCd3pGN0VCYXlRdmtjLytRRlluNzNsY2pvdFRoTTJjTjBP?=
 =?utf-8?B?Vk1iZjJoVDJmdlJrd05kMmZBekhVaXNnRTZzRXE2dGRNalNoeGdXNHMvc054?=
 =?utf-8?B?ZlpJM1o3aVFUNjd3NzVXZ05RMW0xMXlsRDVMSmhuQ3ArN0ZSSkNLNzBnTlZP?=
 =?utf-8?B?NUx1d3NLYlhnZlFTaUdrNFVCN0IzU2JjWnMwbjliVE1qU1RxLzRZM3ZkcVhp?=
 =?utf-8?B?RUpCNGRZRWNadDNTUGRvUHpBeERiUnBEOGwvdmdGZnhjMWprOVZ2K2pnWGhS?=
 =?utf-8?B?aGNSVmNBY2pOL2pESXdZT0NMaVNhZ04vWVp4a0xWYkFJK3RMTkJLaEZmSDNn?=
 =?utf-8?B?ZzVodUhldkk1QjZpYloxak5VekJCYzZReS9FWFRvZ21kUkxNL2VjVkl3ZTJM?=
 =?utf-8?B?bjNsMFNSRnA5a0JMSmg0S1BvMzkzbWoxdzcwekVnMnU2eHd3bUNaTXNNdU0z?=
 =?utf-8?B?c0djeExaY25YS1ljSWxQcHdlOWkyR2dDTkNVWjVTQkM1N3ZmWGlmM0dZb0Zw?=
 =?utf-8?B?ZkhzY2N1Y3I5aG9tdHRaMmQwVmxZSWpqcno4VzU2SXYyV3VSaFBqdlZ2c2s4?=
 =?utf-8?B?Vzc4UFR5U2FsKy84MTg1VFppYXRIRmdGK0VvY3BOc05TVXhFZm53WVFFbVJP?=
 =?utf-8?B?RHlIRnZXMmgzVzJ5U1lSbmZqUXNDNENyZlIzTEFxbG9uV2FXZHoxTThNZmRM?=
 =?utf-8?B?OTVTS3NIUHp3TDloMnFTNjVvYVZsNE1tWlpEMVZBdTFId1hvUVBuMzJkMW41?=
 =?utf-8?B?UlN2VHUvWld5RVFEQnIwRVhJaU04dUIwQ2JuTmpFb0xrbVFCTVZ4L21EQjFx?=
 =?utf-8?B?WUdocnZqTUtiR2EvYzBsU3J1N3lnQkI0MTVPMWx4THNhbUtpVUM5aDZaTzM4?=
 =?utf-8?Q?57IMct3CUdcLwxSr/JChOJpkdp9UbdSptDE7m3F36EDrAv?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c37764d8-2185-4119-385c-08db359c4656
X-MS-Exchange-CrossTenant-AuthSource: PH8PR10MB6290.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2023 06:09:11.7006
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T8nBD6q/eOB/NBlbFjIJpM9MPiofWM1h+0Mur8FcTs4xLsC2wKJNObek1ZK9gPrgeoOwYBmWW/szHkD5wBTSEFy4q2Bq99MMDlVVf8Swn5++31tWOmRBKZrgsXVMLUVP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6768
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-05_02,2023-04-04_05,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 phishscore=0 bulkscore=0 mlxscore=0 suspectscore=0 spamscore=0
 mlxlogscore=951 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304050056
X-Proofpoint-GUID: mTV2EuI-Y5lcwXNXwtgWhkZzPkUePDTy
X-Proofpoint-ORIG-GUID: mTV2EuI-Y5lcwXNXwtgWhkZzPkUePDTy
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

On 03/04/23 7:38 pm, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.106 release.
> There are 99 patches in this series, all will be posted as a response
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
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.106-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
