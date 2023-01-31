Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3F2068281C
	for <lists+stable@lfdr.de>; Tue, 31 Jan 2023 10:06:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232343AbjAaJGz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Jan 2023 04:06:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232340AbjAaJGm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Jan 2023 04:06:42 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C9574C0F9;
        Tue, 31 Jan 2023 01:02:39 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30V7wxmF024463;
        Tue, 31 Jan 2023 09:02:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=XlA2OlUolh48l+YaISIY2oIbpuVGR8Ulif+gnwRllQE=;
 b=yJZEbdaQNJ23hPQeANZnQLj1VVM6FkeZTJD7G4FQ1Q6nFRBgIG7XjKgH74bH0ErZ7o+I
 yMuVNcKG11Nl1lxvFa7gln9jR5D74zbCW4diTxBcr3RreibzZOxVMLPuRobjeNrAdTDL
 cXSJkqpiopmi267vMKp+0uja5N1kmdLuerT72lPGc+sMi+zTfCp6RNOcy0Lfevc8dO2t
 pl0FsV41nKq+wfdI++i893LMOa7K3OvoTNWNlP44Hu9Rlfv+FPkJ1hzgTCd7WOYilSfE
 ozOCEoRL9WvT9taHsCgoTPi92SRTWd+Li4Db/BjeZRTSwkbG8hlw0KAO7S8yCIPz5sEq pA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ncvmhmxar-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 31 Jan 2023 09:02:15 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30V71j4T028129;
        Tue, 31 Jan 2023 09:02:14 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3nct5cnqsr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 31 Jan 2023 09:02:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A6x5R8vDfmkFABCzHPhGJ7UkjBIMyq7h2PX9d98NeWKDeyr/45AXeZGiCBxkKCbLAQH9kqIMTgI6cOop1++YmWtYeWB0NsWhWJV/UInFX2m/Ftn8/7swMimPOSAviDi///e2yUD/snTfWilSG2TmfFWoOwUURAosxJIQsmSwTKRHxqiIUFQAINlM7jt9j78K0vZEU2z81Z1THwnq5t2wIzH59zR9fZ6hdA+Jo0us3sX0utKcN0uS2fRBldYiwyL9EP8e4NV16pFR3rz7Aq2tSpX0JCN45NoQuGhe7I/2B9WVVlBzcizW3kpHlti/t4ol0T9kmDkv7eaZRnSD1H8jkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XlA2OlUolh48l+YaISIY2oIbpuVGR8Ulif+gnwRllQE=;
 b=g3dr2Am8MARussTu0PIV28t/agh09XtQn+LYk+OAk6uYWSla3cHrQv+rRhSor6zVDh0SSGGtcDl1mZE7aIzRv0Nq7GGRqxDX/M4CRJS+hfvnfktZ4h/zE3HqRI9efwZnzxpm2YDWaSA0JSs1RqnboaUapLDgR/JVxIAS2IRoemWfuVxIWgeEdxSnChg4PMCUDhXbeItMojv/1xGvbfhA9tVpjy6IICMF7uAnRVekvDMWYS9YQ1ibGLsa1Kob+j0JZIn6HnBTEKSmE71B1r7Hm2cgOTEA0ZiC3gyHDgA4fE1fPfMR8G6+Act0kLFEfNxldHwpxvTYYyGo2H+7tZk1Bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XlA2OlUolh48l+YaISIY2oIbpuVGR8Ulif+gnwRllQE=;
 b=AgG5dSAzXShQ74E0MZ2kPmiDuOgugbSR555M18LDQ8dHreZjtoZI/umJc5dVfWqYA5C5PnFgNxAk3reXUc+OR/YfGm8cmUlWEwszNIVVkM+X8k62ujFK7AiHS1XNGLE5Ic9knvWWcAinySH4KDIYGLYPnR0042OJM8B3+g6+xCg=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by BY5PR10MB4195.namprd10.prod.outlook.com (2603:10b6:a03:201::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.22; Tue, 31 Jan
 2023 09:02:13 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::fff7:981:3ae6:92eb]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::fff7:981:3ae6:92eb%8]) with mapi id 15.20.6064.022; Tue, 31 Jan 2023
 09:02:13 +0000
Message-ID: <e4b04313-20e9-0060-5e29-17fac62a8234@oracle.com>
Date:   Tue, 31 Jan 2023 09:02:07 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH] scsi: aacraid: Allocate cmd_priv with scsicmd
To:     Vegard Nossum <vegard.nossum@oracle.com>,
        Kees Cook <keescook@chromium.org>,
        Bart Van Assche <bvanassche@acm.org>
Cc:     Hannes Reinecke <hare@suse.de>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
References: <20230128000409.never.976-kees@kernel.org>
 <1bb8de35-16ba-6c7c-0ef6-67a7226a0a2d@oracle.com>
Content-Language: en-US
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <1bb8de35-16ba-6c7c-0ef6-67a7226a0a2d@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO2P265CA0503.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:13b::10) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|BY5PR10MB4195:EE_
X-MS-Office365-Filtering-Correlation-Id: 49441b1c-0f00-4469-e9c8-08db0369d791
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1FD54HQgSLiNGnhd8JZwhbNRyYKUEKZuFZ+2xNl1Z3OtGPzhsp4ryhtkgljjC9f9XyQpXdHAJzYbb1+ilkaZNByA84PFznhTh7+TmxI/pXnOv7T7v8n3GRty8AZJdlRf+8yRO64uVubNhWWDnlVtyb6FcKulDDDIA75cT2tkWmeSjm0w/nn5fdm5uybOJXLUR5rxRSXeoUEItnCqoCeH/3CpFB/gFHlRMBxUWzWgrIDeB9YsnBZQk9h2gwhJvD5+dhRA/MuiYbLGIqdiCYLhYIZOCfc5KcgbtXi+DiysSPVTsgzIKZ5SzcvHC46mBGRzeQNZjOKEm5zFFe8Pptth0mGEJRwXC+avdEXgbeluc9dl1gUmaEzrV/67IAvjXSXwirnZd1vITqVumJYD4ndUXZpVCS4oPz1Ym2zv0xp4XCepOawnJYlpWMaqFhen56WNqd5anHMnDcPzwh8846WPFf821dZcKERz1ZR/VIKubr3R00xCXol5IBn/FeJiAVytwKS2LuuvIMjbDbLch0ayciFLC2AzdormA1SdUuD0lhHGKAf6wxe3N4BH7hFcZSWIn0w8IXp7V+Xb3ZYB5AoL51M+fe60wxbfMhUPhSLJwgJxokz/GiuLAxIvGR0rYedXs6KKxm4ojn6HpD5DirDc45/DfICpQdHFtBdJcER5fIX7Ba2uESl1jgldvnzT3+vRLQ4M4QnbbuLx8iLRqJXUXf52o4fAfLanuKX1jUMVIw9xNg8wXsm8p80YUzxjDY3a8mADHdnenWl6yaaUChWmQA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(39860400002)(396003)(136003)(366004)(346002)(451199018)(6666004)(38100700002)(41300700001)(316002)(36916002)(36756003)(8936002)(83380400001)(86362001)(31696002)(4326008)(54906003)(110136005)(66476007)(8676002)(66556008)(66946007)(5660300002)(478600001)(2616005)(6486002)(966005)(186003)(26005)(6506007)(53546011)(31686004)(6512007)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MUJQYnJ1QlB6dGJ3dFBXUXNiWlpwOTczTXFSNlBUeTVJRTF4UlNpUGJEV3hW?=
 =?utf-8?B?L29XOGdzakIrZjdyalJvVlJkYU81dWk0bHdNKzdDbXd2UGY3cVl1azFBUU5m?=
 =?utf-8?B?cFNueGZhdDZlOHJtZHBiSlBuM0ord2ZRL0t1Zmo3V2VIeUhkS2NmbUtJVHIw?=
 =?utf-8?B?QnBTZ2ZCZVlCNUxuaHpBMnAvSjFzeFRpZ2hpbnpYZlRmRFpRS1Erb25HcWpw?=
 =?utf-8?B?QitEdG1iNkVJRXVxUTdGeFJZOE80QmQ4ckRyWThGUHJXOG9sdFBDclVlYlBv?=
 =?utf-8?B?RkhvbFQxeTcxVy9GdXJyaEJya2orZDl0Zi9sZGRyaUhsdnJKRzA0THdQQXZW?=
 =?utf-8?B?YStYOVFxbFkxOWlMYnZ6UDFLU1NQZ2NOaDF5ZmtnQVZnWkcxVDRpZVA3MnQ4?=
 =?utf-8?B?UndqK2YxVDN4amtwNm9WTXpjSnlmcFFDeGM3elprVk1zVEp0eFBjOHdQdXlx?=
 =?utf-8?B?bDVHSkZ6Slk2bHluUHA4eHprWU1qMVJGSFpxT2swdE96YkYxQnIwWVA5SDVq?=
 =?utf-8?B?ZjlRRDU0Rkd2MlNpa3k4RkIrRXQ0cnFmUWw0Nng1TlpYcXZMSzhOT0dJS3hn?=
 =?utf-8?B?Q29SSEFqUEtqQVBrdkRtN1MyRXJQWk1DcnY4cDhxS0liMTB4VHBjbk9wK3lX?=
 =?utf-8?B?aHNOTlFVKzJtZkE4MWh1czJyWkFka2ZmSEtGaU81Zlc0N3FvMlYwWStUV2hZ?=
 =?utf-8?B?b0NLbmVDa0lJdnVCMUk3WlVHdlk1L2RqTVgvZkFNLytPbUs4bnhqbUd1MThP?=
 =?utf-8?B?TzRRMU5nUW94bXloOUlVQXJhNlNtMVkvL3J4d3NRY3E0bExqUGlSa21ZU09M?=
 =?utf-8?B?T2FGR2c2VEoxZEVqZmlDWWRwb0pwc1k1ODR4ZkNjTll6alE3cUMra1NmVXk2?=
 =?utf-8?B?LzFxK0hrUzRjN0dkZldsS2ZyamtGZDl0cHJQeTdGejRIdi9HSlRCMGxOL1dF?=
 =?utf-8?B?SnBNRE5LTXRYZDRrellnVHJWNTFLdG1maHZ5ZWdOK1E2RmRrV0VUUmhXa0FH?=
 =?utf-8?B?VzFoRmhwTms1KzlmVkVVTmFHUUpESEtmaWZkSjk1bVd6VVdLdFVGTTdra1Y1?=
 =?utf-8?B?S05TMHhBN21DNmV4UjNzUEVTUHVpU2xxZjl4b3YvdHcySlozWjN6d2tmREcr?=
 =?utf-8?B?RzVaVVZmbkhOVmVUYmxtZ2ExK1RhbWxiOVV1QTVwekRUYXZIUTh3SUFGeVBC?=
 =?utf-8?B?dGFOWWxqR24ycEZ6Ri9meEx5alIvb2hFbW9xK0VFVitQQ0NzOW1VcjRuRDVC?=
 =?utf-8?B?cWNvMG9EditWREdkZFdzODVtRE9uU0FoL3IrOXJVbGlIVDhpT2NieHprNXhO?=
 =?utf-8?B?b2dUc0VFOXF1eGR4L012Ny9qZk1mb0dNa1dNQnZYRXNEQkVBUzZycUJVa2Nq?=
 =?utf-8?B?VWkxTTF4VW9KRElRd244bmNWZHMwNWNYWWxZeTA0QS9KTHdNMHYvUVg2eGNQ?=
 =?utf-8?B?dUEyOFZXUTRhYmtIZGxXRW4xNjNJRHJMYjh1YUJuc2IrQlRwUXZkellqejRq?=
 =?utf-8?B?TUZzaDZ1dE41TCs2eEtoSWZzQTZpSmRtNkxUSmZtbUpWMGNJYUNDYnVqZHRh?=
 =?utf-8?B?K2pCNVBDalpvQTVDVVVNSDIxcXdwcDN5eStRaHM3aGkwUDBoY0kwY3dOV0xq?=
 =?utf-8?B?UFZ2NUpzS1BDWVB4dTZJaWRySWFjYk5hbDBuN0wvTldaV1FubmRtOWFvRkdN?=
 =?utf-8?B?a1JCbElMdUovRUZGam9vUW8zSllQMDI4enZoT3dMNGRMTE5MRUtEZmVubE50?=
 =?utf-8?B?Tk9kRy9UdStvbG5STVlkekdrSmQ2S3dyMmpuRFdPT1RiL3ZoQllLY2N1U2Ex?=
 =?utf-8?B?c3VHRERRdis1djN1bFA1VnE1QTlPNHppNGxXeHI4Rlh1bzJtV3ZMd3l5OVFI?=
 =?utf-8?B?aVkxbG5KNjJkdG9iZVVFMFJoWjk1bDdYWDRIY1ZGWGJ1NUd5V0pyekxmcmtx?=
 =?utf-8?B?aFhteGNuU2hXK3JXRm4yMjVYL1lpSloxYzlHTXU1OXpFckxmRmM0TFB2bHJl?=
 =?utf-8?B?Z0w5ZU9Gd3RXTTAwUE9FcS9mY0o3SWdIdmplYUdsbFZrb2RONXIweUVoNC9a?=
 =?utf-8?B?c1Nka0FzTVVWVlc2MTJ5Z2VhTkhaY3lSQVRWWlI5WldaR2tGcTJISUlOK3lM?=
 =?utf-8?B?ZlZGUXB5U2QwVDNqajFYTzRuakZGeUt1OWhnNGFSaU9CYVBUM2E0ejJsaGZN?=
 =?utf-8?B?RFE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: xOlp7jZROK9+6GmmMcNLnRiwR5MD+tYo82jBHLAZ/89uBz7+MD3772zLdzjMjd+ljLQqXgTgo88LRzAFP2rUXsug5slrOM79t9K7OWGhvwLYIPcYSj5LKOVdErBFZQLnoFB3HyJF2/D5ak6yJHd6HBCQHmL1L7fRQn3vTTITNCn0a85J4LS/eQKIErrCP4KLhM9oN8x/toheHhdEqS1Q0V7aiJjwG7RQcYPuSNtXDX05RGdt8ktshBUC7qxj9ako+W5gyWpm0hySpPsW+0MYkM0zNQ72RqQ8DRWNpAV79dgaHFWHxSEjmK382QcwCUBEXpgd6eKWqDDeMgC9tESy2G43lRCAtK0jsBiCoL3l27p+jQCkJN9RKlOdTMmizW2fH3jshPZ9lsK1/p9pHa9JisYbuxuBk2Z/uu0uYm8D8k+ORxpKvqR8rL7DPcIa43olZunoFPxBBUA8LU+K2f1axNo+22BJzQDmS6NEn5ns4zP8gLxJd6F9uv3MPnfVsQxpKwIxT0u5b0EdPGOVvpcpelmv94Tbttju6JXUz8j+Ke9RMdRrcjMUEmp+0IGWwscPRfXrVvv14+3K7E5mD4hTrjP8frSeNGQmTDYW02pFHQBVwCYy+PmPGSrMfDXUCV2uU2+ip6CMgqUz0UBMj2n217zxT9DTYK4wiO6W3aNX2xFEtwODNw6KcHRRP7GoLvPOUBllfUSWH2t2Aus7ZSIFfPxKxSmRbf78r3ncNzygUHd+U/PaxgOEY4oXWzh0vx4U/HFoS+wJvmTLnVj1i3nK0HhgXp25ulK1UVq3IVhCBzsh9HSzVsGLffD0QxFuTp5XGpjwbXS0XXoZbPiTjXMpsyBYdp9T9Z1vK9dM0WB/AM8tcLN9bA6Pq6vlmTlgAWec2v7LAHtntSERBttLp11q0uDqBrUImDjDH8TMt6+r0mA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49441b1c-0f00-4469-e9c8-08db0369d791
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2023 09:02:12.9451
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CuPalvBdrg/n5MtV3XRy9/fTJjEJixolLVdkI6unY+y9eL2hrw2iXrqC782I5mFbK9TZN6odTcnDFg5fLmBQFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4195
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-31_03,2023-01-30_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 malwarescore=0 mlxscore=0 adultscore=0 suspectscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301310079
X-Proofpoint-ORIG-GUID: W4O5eK-seLzr491owTUJ5nBILtM88RKf
X-Proofpoint-GUID: W4O5eK-seLzr491owTUJ5nBILtM88RKf
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 28/01/2023 18:40, Vegard Nossum wrote:
> aac_priv() uses scsi_cmd_priv() which has the comment:
> 
> /*
>   * Return the driver private allocation behind the command.
>   * Only works if cmd_size is set in the host template.
>   */
> 
> This is set for this driver:
> 
> static struct scsi_host_template aac_driver_template = {
> [...]
>     .cmd_size                       = sizeof(struct aac_cmd_priv),
> 
> I looked around to see if there was some kind of "allocate cmd" helper,
> but couldn't find it -- scsi_ioctl_reset() allocates one (together with
> struct request) and there are a few uses of ->cmd_size in
> drivers/scsi/scsi_lib.c but there doesn't seem to be a common code path
> for this.
> 
> I guess you could use dev->host->hostt->cmd_size or something, but that
> doesn't seem worth it since this is driver specific and we already know
> what the correct value should be.

How this driver allocates a SCSI cmd in this fashion is not proper, and 
hostt->cmd_size would only apply when the SCSI command is allocated in 
the proper fashion, that being as a request - __scsi_execute() -> 
scsi_alloc_request() being an example.

Hannes did have a conversion for this driver to allocate a request in
https://urldefense.com/v3/__https://lore.kernel.org/linux-scsi/8efc0e24-3000-39d9-7676-e0896145f247@suse.de/__;!!ACWV5N9M2RV99hQ!MealB8BN3q8cxYSaB7yKEbHyDmFTNl0YNVQXpVw8Zd0-iNqQ-k4IFxnqONpixfavb0DqGWnkbDVjBJCE22mYq5Ly8Xs$ 
- hopefully we can progress that work at some stage.

Thanks,
John
