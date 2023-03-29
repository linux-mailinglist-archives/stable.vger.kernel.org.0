Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23F0F6CD5B9
	for <lists+stable@lfdr.de>; Wed, 29 Mar 2023 11:00:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbjC2JAx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Mar 2023 05:00:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230047AbjC2JAb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Mar 2023 05:00:31 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B53694EC0;
        Wed, 29 Mar 2023 02:00:00 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32T8j8ds024596;
        Wed, 29 Mar 2023 08:59:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=bDSQfJnOHX6+zXk+ugSZd6nUJuFa/uAtphuot2ZyhrY=;
 b=F8/UquYKCctN4FHrzf65FMnLh3UHeWfQWG1FzdMiL0O0G/+yOvunzN7cqt1l23A11m13
 6ilrnrewDTMZQCLcY/HXO6TyYGUIzKTikPHrY5CutMyUezbXTb5d2jVrfcUZRiSSkY12
 WHTn0C3EXN6zn0iY4BlYvI8J6cjbOqAoOWYXlKZkb9dRiWEVNctrhEJueuJLSXEzIrYJ
 osrWPA5FkQLUNdATp3aXXenij6JIYtjUZf8TCAhFY1x5am+vES9gC6mTK1kWOWIGID9Y
 ZNVi4odL8TFylZX1o3ER4ah519oed46i5pKRn+BS5yLPlE12JSPEXSV/9Nn/q8imTlOT Og== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pmj3b01wy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Mar 2023 08:59:02 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32T7jwDY032282;
        Wed, 29 Mar 2023 08:59:01 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3phqdfame1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Mar 2023 08:59:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hoq0B9P32vAd+NQqmUf00vxcZofS2tedrSovuiA1eIuJNPRh6TKcq4fepH52ZfMHuvJXTq+cY7OnUoSAPjobOop9aeLg5H6YkGcGhJnhrfXrlKHd8Ce1lWKsO+mDV2iURNcyzLGkzZqv5wEFg2gnK0D9mxg0VsT6qqK61u7CV+bdJWtu99ynawWejAYA0pY5/DP5v3naVwgiIBApICfusHKSqDS6XD33oz0nWtz1Gkv5MeDHhBfkg4cnjW75azrEUyIL1sfAhgE/EmY4tir+F+dKLUDQnLPUFRQxsWOfglW4Ixw/yxTAL5TEZ8AgmmI5FVLmn4v6QYle5nQ5fSMtYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bDSQfJnOHX6+zXk+ugSZd6nUJuFa/uAtphuot2ZyhrY=;
 b=cVx2588LN2sYH9d7qi55fmD3sqcPbs+zG8oOSQxWJQA+ao2I9udSW1F6SAjecKBEcjoftPHYKCY5ENSXd3b5ChMPZs90ygZM6dH0TvVOmy/kXWV0g9X5FljxCx89dfoVVvd5VCUswlRv9tjB9SIoC2Xg+k0LKQAmKqRWAT/8h8MBGdSfXldJbON4fuyIzwqLy7MQA2N0dKYp8ndJlXdQqH1LoLKh6yy/cp/8nYDeCFVpSzBi5nzWkxv7IOOMSGAsBCfNRsqN05CGkIaoa3BNXCippp7fDevxRr71FmDZvyOvIarDod0EGxGaWTByRKlL0hgPqwSdWoVJjzylNx9dUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bDSQfJnOHX6+zXk+ugSZd6nUJuFa/uAtphuot2ZyhrY=;
 b=Yef8ak3Cnq7sWssjGhWlXLQX9EVtGwZps6IDOEr1g7KybYOadKRoCYIkpT+BVLNw4UuESkSzmiYjy1HQ+AhY2g9j3rUbecR1mabwg8UroczrCr/VwWkE45W676pWsf/6qATPrAP6FRH/k8q2DobTj2PNTPoyBhoBGXIBDf7+AvI=
Received: from PH8PR10MB6290.namprd10.prod.outlook.com (2603:10b6:510:1c1::7)
 by PH0PR10MB5796.namprd10.prod.outlook.com (2603:10b6:510:da::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.35; Wed, 29 Mar
 2023 08:57:59 +0000
Received: from PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::fb63:990:eeef:ec00]) by PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::fb63:990:eeef:ec00%5]) with mapi id 15.20.6222.028; Wed, 29 Mar 2023
 08:57:59 +0000
Message-ID: <7d7a1630-132c-d5b5-d010-f7f18f2cff5e@oracle.com>
Date:   Wed, 29 Mar 2023 14:27:47 +0530
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.1
Subject: Re: [PATCH 5.15 000/146] 5.15.105-rc1 review
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
References: <20230328142602.660084725@linuxfoundation.org>
From:   Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20230328142602.660084725@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TYAPR01CA0009.jpnprd01.prod.outlook.com (2603:1096:404::21)
 To PH8PR10MB6290.namprd10.prod.outlook.com (2603:10b6:510:1c1::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR10MB6290:EE_|PH0PR10MB5796:EE_
X-MS-Office365-Filtering-Correlation-Id: 7775c4c4-5269-43aa-3b7e-08db3033b202
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a9vSthxBiXZL2ioi21gnwTH1Mmsp4Prxt6fnN0dgKySNc0VB7bjVDM/63s622GD9jukqLMFwsi5n+DWfqjAPzt3POTeqo/hEN8jSLIBftuzU/YmHt1AAGM0ulLEeqj84YC9td1m73z9wQQaT8LA9w8ZuoILSNNUoHjV7n7Maku3R0x5c5Y5L7EJDzCYdXtm9VSI6isEkaSk1Tk+a7hZkNJgTpzXAHxDp+rKDebcmv0SomADiQjwVTq1dseUZJQ7rnDkiSnU/W2Rp88p1DeaJFQvi3DtoRr7EE/Xpv3efTFsnJoCvX3tNklYIjI5JLPQnsK6sCZPMtRxOokBQMN//9YJRYkhiAPllxvBlgOuy4a+KV5wew+JYBWBIVDnq7rJh6WS49h9gVahUN4f45iXg/2RFOabJsQuj9uzZkcodRzawCdAX08kntDS52BQkUt3nSnzlNPZ5MEQZfxFWeNxOywGAaU/itXQn0Mb7sKgTpmvmQoyf/su8n2klBtTdTx6Y76nie6KCDhflQrLpZzdItDQ5795SMf1tmKKxBwSGVY+jt+zyMbWkESA/nfrX6M163OlVxAprcBO/xfpfAEio+2t9Y6JBx/UW9m4n4p7pByh65gveSmVthI9VQI1vgbL+mS4iM8zbMz3wvzLZC3D7FQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR10MB6290.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(346002)(39860400002)(366004)(376002)(396003)(451199021)(4744005)(2906002)(31686004)(2616005)(5660300002)(7416002)(6666004)(8936002)(41300700001)(36756003)(478600001)(54906003)(8676002)(66476007)(66556008)(316002)(4326008)(6486002)(966005)(66946007)(86362001)(186003)(31696002)(107886003)(53546011)(6506007)(6512007)(26005)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R25PYWo2VUU5ZkpCeWx3VldqbW9kYTRabW5aZ1JhVzY3VytXS1EwaGswOXRu?=
 =?utf-8?B?TFlEZTZGMDVvbDJpSlh5SW5sTmpjSFV0M2I5MmpqUTRYVzdoeHViNGhjN28x?=
 =?utf-8?B?eFhqdmpmUnBGOHRwUXNabWpXRnlBaWE0b2FIaDZTYmpXU0ZvYWpweWFGMkFU?=
 =?utf-8?B?Z1FHK1QyU0ZxNDhBMGxmZUpBVEh6QkVrZ3pSNFp2N2l2NFQ5RWRwdHJWUTJC?=
 =?utf-8?B?WXZubWZ5ZmF1YmtZRDRTQk16QmtReFhDNGd3ellKelgrdzhjbWNOaEdWcks5?=
 =?utf-8?B?bDFqVzRIZ2hJNld3QW02bGhoVGxoanY2aUcvSk05eEREQStQd2J6V2I3Q2FZ?=
 =?utf-8?B?Snk0RHI5QTUwR3ZwdHpmNUt4Mm5SdjVGYmpmdy85c2JTNDJlME5YMjduOFBY?=
 =?utf-8?B?aGMvaVU0ZHVNaVo4Y0xvZElwdXJXcnQ1b1U4SlNGcjM1Qkl5ckRYajJTSEpE?=
 =?utf-8?B?N2RSVjA1U2RmQys2VXI2bTlKVnZKN0w0cEhjaEV1RDNuSGNzMHV5bjh2cmwz?=
 =?utf-8?B?M1lZVnVXNjVoQ0cxaVoybFpMbVdHNHlzMDBDUXBJd3g1Qit1amtsSW1tTERz?=
 =?utf-8?B?Q1M2RzN0R2V0T1Z5ZTdZcmhOSlErOHNSRW9nZlJiL1NJUGZ1bXdmUFRUaW1i?=
 =?utf-8?B?MHcvWnRZL0V6eCs2a0VWWi9Ca1VORFlpNW80Y3JvWVFENmtYM2M3eVJKc1d4?=
 =?utf-8?B?SGlCQmJOc1RXb0xRZlBqSTd1bTdBZW44ZWtyZWdPZG9WaVJ0a0Z2aStLODdK?=
 =?utf-8?B?cEp3dExFUFZnUmFNTk4vWjBVRHJ4bmpDTXpicW9sMCtsbUlweGNySW1ram5u?=
 =?utf-8?B?bURqT1Y0MHhiWnJXYmxhYUc3NUpMSmlaUFVXa1RwbVRJUFdNb2NkL3ZCL2p3?=
 =?utf-8?B?KzZzV242RmlGdDJhR1ZuRDVSOHRidnRUUTBBT2tJU3VsSVRwa1c1VElZb0Rp?=
 =?utf-8?B?M3hpdUE4K2tkMXAzRjdKOTVpNmlkQXAxUDJBQ2tzNnNmSHEyS1dnd1JNeEd2?=
 =?utf-8?B?aUZQbGR2TEN4K2NSMmZuUi9ieU1ldUw0ZURMRVFKMjZaYmNiSExPTnAxcFR5?=
 =?utf-8?B?cWdVSUJrY2dkTmRybmpRUERoYXUwM3R0WUdoUnNicHdUVkZuQ1V5d00wOU4v?=
 =?utf-8?B?RjhXeEtVMXRiTWs5aDluVjRZelphbmlwUjNkYjJoZXltczJCbVNqNzRUWWM2?=
 =?utf-8?B?Nk5HRVVmbXdSeU9admNZc3N6RTNSeks4TVdCSGNXcDJJN25BRlpVT1YxZGZn?=
 =?utf-8?B?S3lrRHlZOWJzTHpzWnVCSVQ1Uitub3hhY3lrVkFDVC9QeDd6Rk9jL0h3U2xF?=
 =?utf-8?B?Zi95dHBsL0trNVh5b0JkdFMwS01jTy9yNXdUWFdvWW9kWjNwTFpwUFRwTnNT?=
 =?utf-8?B?bWcxdCtVWmZtZ0kxKzJPZDdPVmw4b3pQWk90QS91K0xIVFpLdi8wRzhvWjRO?=
 =?utf-8?B?eW8wUFNSbDFiRW16Ynk2ZlExTzRxRUZ1RHFwRDZCV3ZITnNxcndSNHJuYjdT?=
 =?utf-8?B?NUpVZUNrczhySUdqOVllZnc3MGNTQjBFdXBndCtMeW5wOXFtU2pxdmc3ZktC?=
 =?utf-8?B?YUZ6aUhlZXN6UXpRbnZZbXRnWExXOGJ1M0N0ZTJVNEVabEJHUVpBSUJFR1dO?=
 =?utf-8?B?cGIxT2lZd3MxOHpCeFRSL3VBOElscDlOd0E1YVZlOTdoYUxzTmZ2STVnU20r?=
 =?utf-8?B?VHZaRUtKT2VwWWc5ajBzTHZlcytvTnJNMWRKTGtJbnZOdDhrblNCQlZmSFlP?=
 =?utf-8?B?eTk3K1hNMVRTQStGYlJiNzIzY1hIUm9aVUtlRUlsMHVIUExIZlVzUS8zc29y?=
 =?utf-8?B?ZFVUMTRVcTRDSzVOMnpEZC9kbUdpOVZzenlNellqVEdzM0t3NjVaYkw2Qnlv?=
 =?utf-8?B?dlNMTVFoSGxzT25sRlBOYUJqVXBUQ2xYU1dJa0ZteUVoTlA5YlZwYTlZRjY3?=
 =?utf-8?B?Q0JGYVJwNjNyVUEyQk1FdFBFTStoTGprSkhwSEFYUHhxLzlZK0FNNDdiNjdt?=
 =?utf-8?B?bFE4ZWVvUllmRTE4RzJpU2ZxbUw3aW03dHJIZkF0R3dtdkNaZXE5VUI4YXVy?=
 =?utf-8?B?U3FCTENYVjZYSFRTTVQ4bjdmdGZXd2tSaFdJVHFraUxHU0xoTzNGalQ4SkVi?=
 =?utf-8?B?NUtCRlhQYUlkbjcwa01UakUrMWVWSDlhWTc3ZUwwTjV0NCtpSWxRVC9wbEFp?=
 =?utf-8?Q?qlR4QQAqeJd8A0AuIQfDxhc=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?cEhIeUZkUWcwd2FJK0MvM1J5YVp5Q05Bb0hUKzNkRWxnOENyK2RITnI3Z2hY?=
 =?utf-8?B?R3dJU0MzMEFWbVloR1pMSjkzTHFEbnNrOGNJWnRMRmk1QzRkeUt3QmRERk8z?=
 =?utf-8?B?dkY5QXdFYUtCUjZpYjNXT0NzOW5TcU1GeEp5VkxReUVzUmc5YjFNWEdnZGFB?=
 =?utf-8?B?U2t6T252dXJTckc1bHZpcHE1VGRWeFpiY3dScjZQTVJlSUg0bW9kQkhkcm1w?=
 =?utf-8?B?Yy9UMTB2RDRWck9XUnNzQXM1L0p4Rm5ESG0rbU5QazQ4WDl6QktBcjBCUTFG?=
 =?utf-8?B?RU5OYWFENEl5VVF0N1M5WWhpNkR1M0VuZDBPekJkdjJqRDMwQnQrUVdxMzIz?=
 =?utf-8?B?NFAxVEFWaStvSUpFUzZnSDM2RDFNN0pJZVRZRGRTUEJUcUpJM1ZheldhWHZ3?=
 =?utf-8?B?RE12VWlLWWN6SnNvUWt4UytSeUNtMDgxbjBwMnFhYXJIaXhrZE4rWk05UXVW?=
 =?utf-8?B?bG1wNnFIejBiT2kreFZ0VFZNOWZnei9VTUVTU01tVFA0UXRZWHBYSnhoNFVv?=
 =?utf-8?B?ajlKdklnWmRlOEc0OUpUaDVDbEllYzUrTzVaSENRZWpPMVVEUDM2ZEl2eGVY?=
 =?utf-8?B?Ynp0Szg2OWcrc2ZmRU5GeFAxU1N5d1c0MHpmWmxHMXU1MXlsSWRxU0NReEpO?=
 =?utf-8?B?ckZiTXlOZlJRVHJVVFBPZXlqeUU2WDFZQnY4V25DZWNwVlJNbGM1ZU54b1Ey?=
 =?utf-8?B?V1JJcG5LUXNUeDROQ0NVSGFudVVRaGdRTEtpdXhKSkE0WHBDSmR3aUdja0tF?=
 =?utf-8?B?aHhTRTZpeFdYNXplUWQxY29aY3AwU0xaQ3Zkd2ExQzh2YVE2NlU2VlBYNHNi?=
 =?utf-8?B?Z0pvajRXVUloNStZa3lPM1hITDRxTFJxZFdkcDJ4M2hWbU1maWZrcDJvcktw?=
 =?utf-8?B?dVRLdkJ5OVB0YkpFQlB2dWVzWVN2N1hKV0k1Z3FjWFpCaS9wMGJGdlBrN25X?=
 =?utf-8?B?UnRkNkRTZ1gyVStYSThudExETmhDYlpvRzNUSnVsdDNKUmU3R0U2TWgzWWJF?=
 =?utf-8?B?cGZ1eWx5ZVpFSkJUR2EyVkRHQVArbkhlQ2V0NWFoQzhYQjVYc3NyMzVnUWVE?=
 =?utf-8?B?UjlWUEVBVXNNb1RzV3Ixc1BqWUgyay8relVITEpTTlkyME1mVUx5UkRGYVdE?=
 =?utf-8?B?OFpHdnN0a0s0VkJYK1R3M1dHbEhZUWJZbkdXT2oydDFyTzNSY2RLcXR3OFpr?=
 =?utf-8?B?UmhodFZHclMyZXhQdWR4QWVRN09BQnVCYXNGaWdGZ0xLWEM5em9EYjFXS2wz?=
 =?utf-8?B?U0Z3TFFMcGxNTTJMZkpIVzJ3MDN1QW05aUZhTXBjaVNEUWdaUDVXbURzSXRJ?=
 =?utf-8?B?dkJ0NDhZcUx0M0ljcHFjYjVQbGFmVVlIeDl6eXZVbWdRQytJMUFmSEVwcW9W?=
 =?utf-8?B?Y1NjNHJGYmVKSjhmeTBIZHVyQ1NRNXVhQXlXQU5IMzZqc3M2cVJLZ3VOdlZm?=
 =?utf-8?B?cE5sM3huclY2QnJaRkpiaHJaZ2NrUWpPaG4xSzlZN2lEeUZ3NC8rUTRRaXlF?=
 =?utf-8?B?ZUtITWd3VDFFbG0xVEFML2ZPbHBVdnFoanUwekN1MjQ5T0dKdC9FN2Z2VkUz?=
 =?utf-8?Q?zM5Q2NibKSD94QwygjwqQHzVemQG8r139dOTe2+qG/KkPO?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7775c4c4-5269-43aa-3b7e-08db3033b202
X-MS-Exchange-CrossTenant-AuthSource: PH8PR10MB6290.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2023 08:57:59.3500
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: InR26elE+TGRBih6v6CBoIN4HSNLikwgY9MeHaxE6B4P96j+p63c3krCOVFiUI1e9Q2C49/70d0nM0shob+1KlwQxPY3vyTpOk8AA3lmhqgsvyWpd311jUPGtRPtIx10
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5796
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-29_02,2023-03-28_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 spamscore=0
 phishscore=0 mlxscore=0 mlxlogscore=957 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2303290074
X-Proofpoint-ORIG-GUID: 9Tkq6GHnySDJBIKgdeB6tCo-LUUj58vD
X-Proofpoint-GUID: 9Tkq6GHnySDJBIKgdeB6tCo-LUUj58vD
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On 28/03/23 8:11 pm, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.105 release.
> There are 146 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 30 Mar 2023 14:25:33 +0000.
> Anything received after that time might be too late.
> 

No problems seen on x86_64 and aarch64.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit

> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.105-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
