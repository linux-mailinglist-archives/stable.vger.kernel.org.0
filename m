Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 164CC67BA08
	for <lists+stable@lfdr.de>; Wed, 25 Jan 2023 19:59:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235879AbjAYS7o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Jan 2023 13:59:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235850AbjAYS7m (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Jan 2023 13:59:42 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E204C46146;
        Wed, 25 Jan 2023 10:59:38 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30PFPfLv012719;
        Wed, 25 Jan 2023 18:59:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=nl7cPRhE5sys4m6mi5oSmRyykNuebv/jmAd2aAeRP6M=;
 b=dserWzlkg+W2HXPOW5uQJyKgU7YGHjUSQ7tKo5G3DjI2O0gZqg+6DoLImGEzvgoeFKKz
 5eKYTScUX4osNqt9jrEB6pD758j7+iOwn6dofNmeMXcq+5WrdmR95wi0dyqOiaKoQGuC
 2EkkVLGcy7o7zkZdI21AyPOgFu9Yk+ffYZmlSbZbQHFriVuSW+5KtO6fxiroxNh8Rgmp
 wYDZZxa/PzBYmVjDAzjmkbjc6I2j8QgMYdWnEyw7GJc6V+VueHPPTSheUAza1AgRGXhH
 Ggipgh3jhZjW1Tbfuml2vH03U2PD7lusSLW9NEoS80xHHiNSCNc3yVZhAHr8nPnosGyE vQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n87xa8s0d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Jan 2023 18:59:33 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30PHeUNf019389;
        Wed, 25 Jan 2023 18:59:31 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2104.outbound.protection.outlook.com [104.47.55.104])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3n86gdas7r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 25 Jan 2023 18:59:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jmXQ4Y7gyrl+YfeGEZlfP31BDvdKgFyzuEy4Ivf4+gKZWfg3TphXlr1uDXZoWgk+SM++ctLSaFE8SHEJh6zYNvjgwYxuQN+WZogWBGeRweUAwm8hcqXX4w9R3Ph9z16doOc/7fZQGKlLb0OxdYoepV6I0w0TMCyCMdjn9m4BV1D8WGFLUaAaJWS1tajQc4JG/vhNNbFbdEvvAd6oymCu+0fHa31FkZEtySZHwDaTAnro3Va9iFA9y2uWlZ8eXvGUDQbNreRfqlTK3tXnJy8Kw2+kRgKglykyyBos5r/9+WcsVwF3f53jk0DESEMR6y+DsKAy6uVmPv5XXj+UeHSN7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nl7cPRhE5sys4m6mi5oSmRyykNuebv/jmAd2aAeRP6M=;
 b=KJBHh74uLOtXZtu5IKCEqVDtZUKJF9sbCYXJNtz5p6Khv38MBfGuAZCRzO7FjUT37xWJD2sYcpeEUHaJbBM+lVrLoXSaAkkMLkyQ7IuLwXICXxmg09gTym8WTgcyldeQA0+atE6TunkINq4FJNOvQJsvamtR5OXX0zNdyNfne/m+6ZR5T+/Lsm531+Z49ymDJjec1B0vVhiY46zY8lpI4p8ahQmbCYjlsKwfGhtDQAkbtt+q/f3Aq4J4VIuh2Y81GDIGOzUlOKAirmYlG+rym0GFNHM1FvgK98+CcKuajkWyYZo4AZJCq+ubMkccF0YheEycN7JvfQMthvVErh/LtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nl7cPRhE5sys4m6mi5oSmRyykNuebv/jmAd2aAeRP6M=;
 b=P5+60rj2aXenRJ5Fu9WbSva0Uhk7u8RunmPghhDOFnijDXeY9mygOlA5sDdndluHqdhRRAJvFN0jNoJjR/0xTT8zF1Vo3UA1wB/Fq06zJ5jbAosyVzQcCNWhK7tcMi2g8Iro450N26XwWJTS9CDTEj5ZgCbkSigD5OD2/DMPuOs=
Received: from PH8PR10MB6290.namprd10.prod.outlook.com (2603:10b6:510:1c1::7)
 by CY8PR10MB6468.namprd10.prod.outlook.com (2603:10b6:930:60::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.20; Wed, 25 Jan
 2023 18:59:28 +0000
Received: from PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::554f:d29d:4f76:7c5e]) by PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::554f:d29d:4f76:7c5e%7]) with mapi id 15.20.6043.020; Wed, 25 Jan 2023
 18:59:28 +0000
Message-ID: <f9566605-c4f8-0306-7f07-86b9e0abebfd@oracle.com>
Date:   Thu, 26 Jan 2023 00:29:11 +0530
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.1
Subject: Re: [PATCH 5.15 13/20] exit: Put an upper limit on how often we can
 oops
Content-Language: en-US
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>,
        SeongJae Park <sj@kernel.org>,
        Seth Jenkins <sethjenkins@google.com>,
        Jann Horn <jannh@google.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org,
        Luis Chamberlain <mcgrof@kernel.org>,
        Vegard Nossum <vegard.nossum@oracle.com>,
        Darren Kenny <darren.kenny@oracle.com>
References: <20230124185110.143857-1-ebiggers@kernel.org>
 <20230124185110.143857-14-ebiggers@kernel.org>
 <033ca877-5091-cbfb-6e6c-e49c4adb9a10@oracle.com>
 <Y9F4hxtZnE2GssUo@sol.localdomain>
From:   Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <Y9F4hxtZnE2GssUo@sol.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TYCP286CA0077.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:2b3::9) To PH8PR10MB6290.namprd10.prod.outlook.com
 (2603:10b6:510:1c1::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR10MB6290:EE_|CY8PR10MB6468:EE_
X-MS-Office365-Filtering-Correlation-Id: a5d0b3b7-ed6f-4c0f-b01b-08daff0648d7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WYAjfOXgcSo0D4nK3H1amXuenXzIwo1AneTj2b30rVKk4qA8QjzNK2HWyysIPuYKMrDvbq4kvsPen4t7J7ASRGcByT/Hfx2nwug9znij56eJl5OyEqpWLhZ4zXC0bB5e3zLty91xHitboFwjFCCaS/QWFDC1ZZpCcrjU8MMq1UBv6qnCQnyrvgS+g+vLGjZh52chH+pS4TW0cya3viThXAap+6kj/Z0uZllo5JhGTxr7S6/vYSX+V/BxTM44eGkt1NGaZmWNRTRXCQH4WBDMbIA+hDa5yNYa1gimwxONymqEQ7CR4NtoxGX/pKWLuPNWT6CGkE6Vmt1wkTI2mgyYUed8qc6occkAkcQkdU62AkdGKRCceWpI9MDsSbAs3T5iSW/XdXi1vPR0zvycYt2wtRmgdfaXEDqrPrSN2h52iA3t7fiBHprIHuQI12JINGiUORw+3MLK+ctkF9r9J650qdmBo783z5SOrZr1E5j7wZcM+dIJ9RS2xh1/8+c5qdhKJy7QloLTqNuP8XopAJvpnuTI3uYjxCMSWh+F0plIgFRNW/dT/tK8Hz+d4JVjzZlYUO877lpFBkTS30Sg4tlsB9i3oXf44GSnERs9Jsr1u71Z21PfGxhAXjTuiNa/lwFtwTJ6TOTTPRTOnu75P4WuUf0b/fSjIiHdcGpG39ZlGWJt7phN01UdDVV8pxYyyQujNprIihEBT2+2WIYEUvrwKppUx9wEu1Sv5WjQhPeR0z0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR10MB6290.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(39860400002)(346002)(366004)(136003)(396003)(451199018)(53546011)(26005)(186003)(6506007)(36756003)(2906002)(38100700002)(31696002)(6512007)(86362001)(8936002)(6486002)(7416002)(41300700001)(5660300002)(31686004)(316002)(54906003)(6666004)(107886003)(2616005)(478600001)(66476007)(4326008)(66946007)(66556008)(6916009)(8676002)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M3ZCVE9XVzd0RWY2MjZzMm1JMUxmSmlMcjV2NmUzaXYrYVVaN0lCdG52cmJu?=
 =?utf-8?B?NVM5R05PNzBlaVRPRVh0a1Z6S3Y4eE9rQ0ltU3FNdkFabDBUd1Vvb1hLaVRH?=
 =?utf-8?B?Wkl2UloyL3V5NTJhZkttTCt2K2Z3dEgvSWhUM25FUFlHVUdrM092bi9yUTlv?=
 =?utf-8?B?dEN1WjdpbkkrV2dlbHBZNUJNTHNpaXJRTHlsc2pVRkVEemdGcE1aSjY5THJs?=
 =?utf-8?B?WTZXQU5HbmhYL0pidk5aY3JWUEMwdHlRVkdCM21HMEVaYVA1d2VPYlJsNis3?=
 =?utf-8?B?aE9kRkV6UWFWdkRrRDhKak9oVERXbW9IRzBBamNGMjVmbURKTzBaOW01V3No?=
 =?utf-8?B?VkYvT3QvMzVYOHcwd3IvN3l5Tm82cCtLaC81Tm5xMWJpeU5kRkxUWmlIa2N5?=
 =?utf-8?B?OEUxTmMvdC9BM3FDSklNdzhweUpzaUh2cER4d2Y3Z1JSb2FjRGp2cTRGYXJB?=
 =?utf-8?B?dXhlb0hFMm1yWEl2Z2FNVThNRGxuZk1tUGFvN25pOEw5NmpWSGZGeGZITkFa?=
 =?utf-8?B?Z1htV3c5amk0TXdhd20rSmV5NTlOSmVsU0pwSi9obWdLdUw0TStnQW4xbEQv?=
 =?utf-8?B?Q3gyY0VzM2NNMlM3cjhUK25ZTmZmRUQ3WlhPK0VldHFoZE9sNHdKc3lPTDlS?=
 =?utf-8?B?QUtKSS9DVXFvaHMvbnVLSGMvS0RjMWNmdWJkOE45R2p2b2poM1FSY2tRcFdt?=
 =?utf-8?B?NDUxTHoxSThoWTdXTGx6d0QzV0l6Kytic3dkcGhzSGdzaHd6SU9TeHhmL2Zx?=
 =?utf-8?B?cU55TmNtS1o4ZWZlbG9uYlowUE5xVjh6akdqSGdMRjhqdmFHN3VqQ0tPWXNV?=
 =?utf-8?B?L0RZSnlqUjUvdFRpL2plMk56UjczSFFFMys0WVdvQXNSS1JKbkR3S0c5aTAx?=
 =?utf-8?B?OU1sQ1NGNC9kbkxEOW43a1JqRUFtbnhyT0dIY1pFTmVIa2xyOGk4dkxtbXRY?=
 =?utf-8?B?N1Z6QXJBRkFwSUhjUWZ2bkI1djV4cFZvWHU5dVBDUlRnenVRMTBQN2tsdksr?=
 =?utf-8?B?WjhmQ01JdkNtMEVISzdMSy9WaEZTYzFWYWUwZUJmdXJQdlJKNlpWaXY0Z1JH?=
 =?utf-8?B?RGovbEtSTGxkQzBiYUJRN05GMnBPQ1F0KzJJaVF1cmhVY0VxZm9Ncno2ZFFn?=
 =?utf-8?B?WmxpbnNnTnhyMVF6YzJEUVB0dlpabkxlSjJxcDQxOFNEZkswNnpJejFQeC9W?=
 =?utf-8?B?RURyQUk1TU5XRDYrTVNQQzVPVThSTjlRSWcvSXVSUlV6UERmMWJnWWZJcHdZ?=
 =?utf-8?B?RDM5eUVRYUNMYmhYUW55VHVPeGFnRHNGd2VyN2hzZ2hPRnFUM2dkKzU2aTJM?=
 =?utf-8?B?YmYxNXgydjl6UjRPOXlCY0dxaEpqbVlJOHVFU3B0MW15eVIyYUlVSGJEbGQ1?=
 =?utf-8?B?b2V1REdURmlHSFFRNHArbUdBNnBLMXlrSHQ1dXVTQ0VhbFBZa3FFWnhTbEtL?=
 =?utf-8?B?TUFPODI4emNzUnI4UnhKV1h1Z2lIaEtrMXkyWFR2VXQ3NkRsK0VTcFBieWh2?=
 =?utf-8?B?YVQyemtNNVBsUEdmWkNsOVFBN0N2QTgxMnlmY0FaYU9zbUdqSjA3bGtOSVVh?=
 =?utf-8?B?Yk5RNXJTMGJPV2x2SllqTXVncUFjVTl3ZjlsUEpwQ2taTS9ITnIyOHQ5MklS?=
 =?utf-8?B?aVpSc2p2RmFuQVcxVVZ3YVNoWUZ1c0pKTm5ZaFJUTldNWFcrUUw3dHlpcU1m?=
 =?utf-8?B?ZHIvUkZ3Wk9FSUJ0UlBpWVZVbDdKK3N2eGxYdTEyTHltVWJBZ2NwYldQSVp1?=
 =?utf-8?B?a0Nya2oyWk1LRUliMStxZno3SnJhbUIzM0hJZTZFT0NEUmxmb1l1VXRXY2py?=
 =?utf-8?B?OFA1WEp1RWppbkxtYmhvaWh1ME9pdmRsa0RVUnFrMHJ5bkJrRWF6b2ZHMXV1?=
 =?utf-8?B?NDBiZFdwc3RQSE5uUnp6QkdlaWNINWNLUlJ6c2pnL3A4U0N2a2tGT1h6WGxT?=
 =?utf-8?B?OXQvZTkvVUd2eUhjdGdwY3MvWVN4YVBLempsaEpLTVpVYmw0bXV5RGVFTHNV?=
 =?utf-8?B?N0FQNGRkR25ZVUFkdnBES3Zaek1YUjd6VS91SmlpcW1qcVRaZjdpTmhvbzAv?=
 =?utf-8?B?Y1JFaEJZM3h1QVZnN1hIcllVUzE5UnhhaU5PSm9JeElrZExHRmtoVUFTclpJ?=
 =?utf-8?B?MThBOHB4QmVUbnhkdnd2ZnlJVVB1ZmhxdkRzZEluRG80djVxZmxRVGgyeW5q?=
 =?utf-8?Q?KQkuVQn2P5yQIGITAnrN/nQ=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?SjV6SjVKeUVyTnVXM3pUTFVnZGJBUnRsTWdCaUdKMmJaWm1BQm9MUHhSV3VP?=
 =?utf-8?B?WlpmeUt6UW5VZTY1eUxHTnhwYkdxNTdHZEdpekNNbjhYaUgwS0puaGNhNFhu?=
 =?utf-8?B?K0FueXAvdm5wcE9pV0FTV2dPRUFxbVpKc0dhdVo4Y2N1K1g2K0dvenBJUm5C?=
 =?utf-8?B?MXBNVXNSQ3VEeTA5VE9QQnhmOWxpQk5rdlhBZkF3a3lUWUZKSmZJSGJSMSsz?=
 =?utf-8?B?cHZyMXp6Z294WDRoLy8vM0JnSTV5SFNxTEw0OUFhWGEwcGczUmhZMmhNb0dM?=
 =?utf-8?B?c1B2TU1WSVNMRzZtSTArSy9rYlRIcHRTRVBYMXdBNzR2NnAyWURxbnYyN01W?=
 =?utf-8?B?NW9KVTh1VStwSmlac1VwL2xlLzBubzN2YnMyTEc4L3FPRWdCem1DeWk0N3Qz?=
 =?utf-8?B?b3pLT2JZYlM3SFpXZVUvM1FpbkVlWkxkeWZhWlN0bjhBZTVvbkhGWlpOREFW?=
 =?utf-8?B?YXJZMkhaRWx4ZllwQ3BFVTdIeTdUNEZKSDJIa0RwVVk3dGVNcm9tS0NIVXNI?=
 =?utf-8?B?d2srU2IzMW9GaENmeU5KellVN01HZDkxQnE5Y3Z4ZHNFUUd0emg5NjJUbTVJ?=
 =?utf-8?B?UmJBMnJvWnRLWnV1aVp1NVF1S0kwTkszVnVBMk0rbk5PRGJWWHhiSHltaTBY?=
 =?utf-8?B?aTRpaTJGdGp0RHBONEJZOGhCL25tOWxza3ZXT2dvVThxQjFhUUJCdFdPNU5i?=
 =?utf-8?B?Wk0vcXptV29xUjNnSzJiMEh3QVk5cTBpbkJOU1kweTZwZE8rSDI0a2YrZzFo?=
 =?utf-8?B?bklweG94cWFEMkhIV0JGRWNFd3lTZGQyQ2thYkhYSktBdE9Cckgwd2pwSDU5?=
 =?utf-8?B?TkZhTHVJRnJuekpiV05TQ1JhQ2hhb0h1RHllL1hnd2pwWXJ4TmZFanFXcW1N?=
 =?utf-8?B?TWVOZG9lYlRhRm5lQ2V0NzJaTm9YRnFOV2pFdXVUbU9wang3NXFTeGQzYjlo?=
 =?utf-8?B?N2pmZWFUUFhwTHByVzF3bmhhc1ZQZk90dmRiZ2VxMmh0WWQ0d0k3NDBjeE96?=
 =?utf-8?B?aEd0eDEwTml3TXo5L0U3L1pCOFdyYWVwQk8rRGFoM3JSalhHSU5PQmpUL2gx?=
 =?utf-8?B?SXNveTU0aWxHdW9jcmJoYm5qQ09pWnBDMlk1NUNKbTBQSzd5MER6M3dBODVO?=
 =?utf-8?B?YWZyOGt1Zko1Ly9ELyt3Qjk4YWkyRTVoa21HOFljY3NkZ1NUYjhpUlcrSTNm?=
 =?utf-8?B?alR5bncxanBjNDZsbFFRazVJclB4ck9iRFNwMDVKVkx0L1EyQU4rcUFWeEVH?=
 =?utf-8?Q?tIknm9mVYqDU36A?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5d0b3b7-ed6f-4c0f-b01b-08daff0648d7
X-MS-Exchange-CrossTenant-AuthSource: PH8PR10MB6290.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2023 18:59:28.6139
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dqLUgXoFLOkud3nY5FRMq2lUYm6AvDgEE+gPzJ4PWwLPd1AABNmUDWZB75Di+iqMIplpiwponEdGiBNNRwHZS5lusVIR2qJVMgvXUTaKDfLmL3LvPsaR8zmvLhbkS9bM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6468
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-25_12,2023-01-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 mlxscore=0 suspectscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301250168
X-Proofpoint-GUID: 4KDu0CNmIFRXkrCQzSUSMn5-znP7sC9W
X-Proofpoint-ORIG-GUID: 4KDu0CNmIFRXkrCQzSUSMn5-znP7sC9W
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Eric,

On 26/01/23 12:14 am, Eric Biggers wrote:
> Hi Harshit,
> 
> On Wed, Jan 25, 2023 at 07:39:10PM +0530, Harshit Mogalapalli wrote:
>>
>> Thanks for the backports.
>>
>> I have tried backporting the oops_limit patches to LTS 5.15.y and had a
>> similar set of patches, just want to add a note here on an alternate way for
>> backporting this patch without resolving conflicts manually:
>>
>> Here is the sequence:
>>
>> * Patch 12:  [panic: Separate sysctl logic from CONFIG_SMP]
>> --> Cherry-pick Commit: 05ea0424f0e2 ("exit: Move oops specific logic from
>> do_exit into make_task_dead") upstream
>> --> Cherry-pick Commit: de77c3a5b95c ("exit: Move force_uaccess back into
>> do_exit") upstream
>> * Patch 13 which is Commit: d4ccd54d28d3 ("exit: Put an upper limit on how
>> often we can oops") upstream, will be a clean cherry-pick.
>>
>> The benefit may be making future backports simpler in make_task_dead().
>>
>> This was the only difference, so your backport looks good to me.
>>
> 
> It's certainly an option.  The reason why I didn't do it that way is to reduce
> the impact of any potential bugs where do_exit() is still called when the new
> make_task_dead() function should be used instead.  With my series, the effect is
> just that oops_limit won't take effect in such cases.  If we also backported
> commit 05ea0424f0e2 ("exit: Move oops specific logic from do_exit into
> make_task_dead"), then do_exit() will lose various other things, such as
> panicing when called from an interrupt handler.  That would increase the chance
> of regressions, unless we made absolutely sure that everywhere that should be
> using make_task_dead() is indeed using it instead of do_exit().
> 
> Commit 0e25498f8cd4 ("exit: Add and use make_task_dead."), which I backported,
> did the vast majority of conversions to make_task_dead().
> 
> Some architectures still have uses of do_exit() that got cleaned up later,
> though.  It seems it was mostly unreachable code, and some cases that should
> have been doing something else such as BUG() or sending a signal to userspace.
> So, generally not super important cases.
> 

Thanks a lot for explaining!

> Still, getting all that would bring in many more patches.  We could do that, but
> since this is already a 20-patch series, I wanted to limit the scope a bit.
> These extra patches could always be backported later on top of this if desired.
> 

Sure.

Regards,
Harshit
> - Eric
