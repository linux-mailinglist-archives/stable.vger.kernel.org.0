Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE9DB6D7423
	for <lists+stable@lfdr.de>; Wed,  5 Apr 2023 08:08:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236712AbjDEGIJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Apr 2023 02:08:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236998AbjDEGIB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Apr 2023 02:08:01 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AD6D171B;
        Tue,  4 Apr 2023 23:07:57 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 334KoxPb032101;
        Wed, 5 Apr 2023 06:07:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=0ahR25rEb1I/cJsUl6lLOUiD8/jHVbJ72c+gzIO+aGM=;
 b=nGbx2pDgpXgC2F4DqrQDtHBCfqFIzWw6y+SJAQNjAWBlPwk9wcogAkC34Av+eGrMQRRm
 7d6At0nxWQCh5/uTknZXYJHFn8F8YIQbdfmkVA+HVDVLNVhTDvM4NLutfngGL37xLMWk
 VA4CEZRBQ/EbQZlOF0BQqal+fHD1wTsk751guv25a6Ggrb51FpKu89SiYemVBpQ5XU2C
 lN8Bdo7/JVRtjmeQfMgzSYQSMEnnicI2CzuJ5MUtIylhkwl+TRKwrOxWdEjRWDbGeP9N
 tCcs/mhgJ1bzKFZlO1Fb69qOUNGFDS72OIETaqoNmm11acoICR9NE5klW86IXK3nmRyk Jg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ppbhbyjps-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Apr 2023 06:07:18 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33553xcD013917;
        Wed, 5 Apr 2023 06:07:17 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2046.outbound.protection.outlook.com [104.47.74.46])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ppt3gv0q1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Apr 2023 06:07:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TrJ+sklf+sGTCO1pE9Kbg/t3iSRcfXsK7Ikq2Bn92RWzYtpvELAwvXQIS73/vmzRiJV6BsVmygC+QZBjmPL46CKq68F0y8JxCa2Zb9+BGCEv5kQVarKkBopCjoxv+myp8cY1ff+4qmPd5P8mAKH1BLVS2D0yS3tPtxoPx5XpeRBJzzR7AYK4cIv+ddTMcyehaawQMgOcv6O9VAPyO6xN9o2Y2ocjiGLxEgP2e1j/tjSvdwBFKXTNc5m2HRo5XIOUCWL9Zec5P4nZrnfKsB01UWznmLYREPDCsYSvLTMTgdRgK4/YWQ+dJgoTVCKq84jX5EGPxu0CcRg0FyEfwa3E9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0ahR25rEb1I/cJsUl6lLOUiD8/jHVbJ72c+gzIO+aGM=;
 b=B8GiVQ4m4FuRBDhhC8RFZtcPNn4/+COa2M5mOMegmIV9OKXbK2bG2WjXA/AOLxyARcpKWsHFSEfrEM9Eq8AN82CZrc/RboCnDEf/os0pPoo9lM3H3Mor2oTIOHflqOH6JbmmEm10JKtIJVEEQKEmfzJUAzi5+oqv/6V5Rpe9mL1Pt8lL3j9ypoEURGzgsNHS5W29L6l2carCsFKbpl3S9kWWijT502nAGg5v2OTPS1U05ihjkNOCPZJAWDE5TKoidQA6wwVKBkANCtnN4Z5xJqXRNnlIMGVZPpKJzI1Xu4VA7uxqgAL/tcjCYgY5ShF9aMYSsMu6aJ6vwp7na52w7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0ahR25rEb1I/cJsUl6lLOUiD8/jHVbJ72c+gzIO+aGM=;
 b=Yht0+RjxWBMfj+MR7lnzOvg/U8F+qVGXQvGzgiOYWRWHYkYG/YlD6hruzemv27iDDxrEjs7Gg1Lqmq3O/+CNEPpXi6ISNflSe775Hoei7i72VW0Teka3E4wc+Ir9phnGK3UwAzv16jYgAPbbBOxZBRUJXuMZWeGIcphq1J2QETA=
Received: from PH8PR10MB6290.namprd10.prod.outlook.com (2603:10b6:510:1c1::7)
 by DM4PR10MB6768.namprd10.prod.outlook.com (2603:10b6:8:10c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Wed, 5 Apr
 2023 06:07:15 +0000
Received: from PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::fb63:990:eeef:ec00]) by PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::fb63:990:eeef:ec00%8]) with mapi id 15.20.6254.033; Wed, 5 Apr 2023
 06:07:15 +0000
Message-ID: <291e87ec-7751-030c-2b79-a4a6b21fe71a@oracle.com>
Date:   Wed, 5 Apr 2023 11:36:56 +0530
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.1
Subject: Re: [PATCH 4.14 00/66] 4.14.312-rc1 review
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
References: <20230403140351.636471867@linuxfoundation.org>
From:   Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20230403140351.636471867@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TYCP286CA0190.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:382::10) To PH8PR10MB6290.namprd10.prod.outlook.com
 (2603:10b6:510:1c1::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR10MB6290:EE_|DM4PR10MB6768:EE_
X-MS-Office365-Filtering-Correlation-Id: b5638ebc-d15f-4a82-c2a4-08db359c00d3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BhH41us9apoTEuQWsuumlKIT3G/pOeu+eOg+Z4UMV1W0otiBwRQLEF7MLZCbjNMF+5bF4UiRMaXCk7OPmdSRqn2UA+6ZR/BGNtZYVnqhwdsXprqPBabFzSd9q0uu9Ew2bYWYdWr3ArDprJFROdF0JgKKE61VDbHxZ38EH4lvS3JKUUOSqjcTyLo8Xi7l7y05x/2VR+ArsHj/Wdk/WsSTDldY9Vb6Ye9VKmN+OoXpSeMNzZFWDcZ1ijOTPe1ZYoHksThtJ8mIUxDi70AI1FvrDL5eelz24bvl1y5jUwtEGuvfWMXma1fIdC//Ier1MQmEgJmBL/xh03vz15OUy8FDuF1vLTA7OX0J4lbKqqv4dzVJmmjvO47ky5cz8sbcWIkKVejOo3ISiup3pmrjrYSt7LMXTMPA4ruWXeRrgawGwTyKuCswF2CxFAZM6EHyCJPybZvVMxA25Gs5H7xYpq2xwBU+hpBZxNNMckJaPKkBVkC+Rq0sxFbwdHdqjFaogIVdpD2l0D994P/0nAOaKKXYUWwWS8n3qb7nU3mnx02qoyZnnH6EOL/5zeSJMPOQKAs2IJGANWiPnPB5O6YNiJPAQJ+5kGuzfqUAfeOp4CHuwIVu2tBg2vh2qH7+AiDUkFy2dMd3viX4kSKX6Qc6Eaqyrw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR10MB6290.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(136003)(346002)(376002)(366004)(396003)(451199021)(31686004)(66476007)(6666004)(41300700001)(66946007)(8676002)(66556008)(4326008)(54906003)(36756003)(478600001)(38100700002)(316002)(31696002)(86362001)(6506007)(6512007)(26005)(186003)(107886003)(966005)(6486002)(53546011)(2616005)(5660300002)(7416002)(2906002)(4744005)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eWhneGVRV05jV1plaStJWm5Lc3JCTGhDNG5KMERrZHllL0NhZXBsZFNjRFli?=
 =?utf-8?B?QVFlNWc2dkdGMTIvQWk3eTlkVFI1UUlJb01hTkUrdUJ6NWV4dnhCSUFDaytJ?=
 =?utf-8?B?c0JVMS9wa3FJWEk1YXBCOVRERkJ0dVpnY1doZEFNc0FsRjIrOUp6WGs1NWVY?=
 =?utf-8?B?b3NYSzBXS1V5QmdEcHdIWTFOcXF0d2orclZaRTM5UTl4M1ZhQW81UHdITEN2?=
 =?utf-8?B?OFVwc3IxbVRkaGRFUXRGZFR2aTZwaGRhdkUzZVNEYWhsbGVLeERsN1kxSnpP?=
 =?utf-8?B?a2VDeEI2dE5udFhzQ040K0twVlMxUDMwcjB1QjV4TjdoZUhaRHp2djJkY2pE?=
 =?utf-8?B?MEIzb1FyN3BqaFg4d2I2VmZFa3lSaUxiNTFpWjFQbkUxY1lzM0RnUG00TXpZ?=
 =?utf-8?B?Uy9kNy9yMTB0ckxiWEFpR3hWUitQTytkdEhmZWdYY1d0TGtEWm52K01JWElv?=
 =?utf-8?B?bmQ2bTVpRzF1eXpKMTdLeURXM29FM1FHMGcwT2xQUmN4K2kySmVBMlVheGVP?=
 =?utf-8?B?OGlWZ2RaWjFVRHBHT0k2RHVRNkp5VWkyODBtMFM5bEhoaTBJYVdjTFVMOEdJ?=
 =?utf-8?B?a3NwR0tGLzMzSkVlL04vdTErVGhoenhJQXBwc1AvUWc2bEhqRDR0ckRJakVD?=
 =?utf-8?B?VzUzdyt2REI0UUtPYTlhYUR4QytEOFQrKzJIRlJHWG84SDZNdUJuOVU5VUE0?=
 =?utf-8?B?a0dHMWhVbUM4SG9nKzRDeUZjMUFyV0dMTEU2V1RIK0kvSzVoWk1TLzJIRXVX?=
 =?utf-8?B?cWxVRVV4Ym5qc1dzUjhSejIyK2FHZDBBUXI5cFhLci9QWGJoZHB1T0hzRmlE?=
 =?utf-8?B?SUV2aXBVNE9FY0xCOVB1QVhwUGV6aUdieHBFdzJrRFQvRG1pNFl0dndIN0s2?=
 =?utf-8?B?ODdNWFlzR1Q4UkJEMnd1MG45NnVsK204MXBHVUx2U1ZvN1V2RVFqbldoZG0y?=
 =?utf-8?B?b2daZVFSRHdjdXg2VWViYTVsbk1qZ1VVTURTVTgzV0xZT0VRVUJJVkVjc3pF?=
 =?utf-8?B?ejdVaTliSm9vNWZZb29CRmR3RGljSTNKRnpNY0ZsNVdDdFY2N1Q0QVVEM3ZH?=
 =?utf-8?B?cUNjMnJkVllHQXJCK0kwakN3TFgzSlgzTHZtNVE0eExndzZtV3pSRTdFMWh5?=
 =?utf-8?B?SjRKbWZCbXVsN2l4VmxpU3F0a1VVT0taaE9TWnJXNGk1clRjVEZhRXRXZDRv?=
 =?utf-8?B?Yng1UDZ0K3lmVlBzdGJzNzFxTFpTQ2dmRDg5V0RuV3F0R0JISnE4MVRWajZ4?=
 =?utf-8?B?N2diR3FtdmovQ0FGbmtjdUQrQ3l3K3pPZWJ1eHlCMDlOT1Q5UWN5YUg4ekc5?=
 =?utf-8?B?aExTdEhrb3FCdytUMisvczRWelVBbkN6Nmd2THdvVG1kWFhsNHZzL2s5cmpy?=
 =?utf-8?B?eFRtMGhXZFdqQmdybzBhOTE5VE9LK2lNRGovcXlIQ1dYZEtPeUgzbnFrY3hE?=
 =?utf-8?B?SGRWeWZ1Ny9RSkZQNjBtTzRGaWVUREJnbndubWx3czdNdzYxWUV4VmtWWEo3?=
 =?utf-8?B?MVpIZVRzOERYTmxGU3ozVXVWZ29GdkhEdUhnblJsMzJneklZU2VqSFRBeno2?=
 =?utf-8?B?THhzczZLemxqR3JRR0lmR0VlS05mQmVjUXJvWnNQcjRwWi8vaVRFQXdYeDlB?=
 =?utf-8?B?L0lhT0Fla1VDUHlJMXF6eWJBaWlyeVJUeVpyNmlGS3dEeHdqUUtEeGh4RW92?=
 =?utf-8?B?Y3ZzQU05SVl6N3FEWEpMa0lwOWNEWDdFeXg0Tk1XaVkrNlpnRkhqUENsa2Jk?=
 =?utf-8?B?eWEzYWQyUXF0b3hGMDh5QXJvdmJwNHlDV2Rla0FaOSs0cmxKcG83RDlJd1d2?=
 =?utf-8?B?cmliOEFXMEhxUE1nOFBwRHlva0lKZzM2RFh3bFpEUUcxMjIrQThuSHZOT09K?=
 =?utf-8?B?ZDY4UXdNTUZ2eVk0dXZrSDV2MTAwYlJRZm9qYisyRUlVOGRrSHdLRFowcHdC?=
 =?utf-8?B?bXNPWGRpY0RMMTBLYkdiK1lSRnhlMFYzc0hwcVBoQUR6WERKMTdaSlYvb3FJ?=
 =?utf-8?B?d0d1UkVxQmk3L2VHTmU4R3NFQUtrcU00NnhrTVdUNXcwK1VDNmt2TlpGREtM?=
 =?utf-8?B?N20xaXpnS2kzc05POWJNcGtYWXNCOGpyM3NOZUIzQXRVU3FNeG0vRm9OSm93?=
 =?utf-8?B?bG9LdU5RTGRXQm5LaWRFd3JUamVtbWFmZGczWFd2cld2dFIrU296SXp5WjBx?=
 =?utf-8?Q?4aBZ7nMkslvGrB33cXOXrvc=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?MVNwQ3NBVjVrbVpOSkRCNnVzcGtVT1l0NEpTNXp1b2sxTy91SzliM3JlOWFn?=
 =?utf-8?B?cGdCdWZ6ZitTQUxpWmNMNWQ3TXhvOVVwaDhqb29ZWmFFcUxFQytGUmlqN0tx?=
 =?utf-8?B?TDBnTDBJdEFLK2F2ZXY1cGgyOExXQ08wK1BPaUZVTUV1OSsxVzdDMTZhc1l6?=
 =?utf-8?B?N1cvdVU5TnkvREdYNXBLR1R4TVVYakZKamMwWDF3NWswNWc0eFJ3NlRRK01v?=
 =?utf-8?B?a3VNelVDNFZHbXUra0JnNjEzeHpBSFVJdUJveUh6cUgwZ01nQnNwUEhVa1dV?=
 =?utf-8?B?R3FKMXZrc2NyZm1KUUk4OGd3SVZTdmQ2L3BSY3ZiL2VYL0QzTTRLZFcyaWt2?=
 =?utf-8?B?RHlTSEtaOVRoaFBKVTA1VTl0TjdqTjFqUm5kVERGcm1YRktJalFKb0xUVFhF?=
 =?utf-8?B?U0p6dkpxdm9qd1pqeVhFNVo4SFpjSXYvb1RlRFU4eldUQ2tFQ1RCcWxLc1Fh?=
 =?utf-8?B?Yml3c3lucEhab1N0dU5iTlRKTE9KWnI4U0toaVo4dEFPNXhRNlRhNEgwSWtl?=
 =?utf-8?B?VXpnQXpJNTNLd2JTRUE3Y0RoNU5mSXo2Qm5LZlhZejhYUk5KdFdKYm9kVjNi?=
 =?utf-8?B?NmFLUHk4K3NaMDN2dWdNcTBHbk9OaXF1R2JBd2kxUlFvRUY3eGIycFlCOXRl?=
 =?utf-8?B?L09IQjJxMi9Ca1Yva2hzU2pod3VIMUg3Q0VlaHQ0RXhZbklpSStSdEVVYVRx?=
 =?utf-8?B?cWZublcvdTZxek5seUJmdmpwTXdTVzhjSCs0L0lVaXdHckIxS1VWV3Vva2xC?=
 =?utf-8?B?UWN4dU56b29aQ2FzN1Y5N2l3dXRBdDhiWTh5QTgwWDVRTFlKc3ZUb0xmb1BX?=
 =?utf-8?B?b3VYVVJwUnFDNlBhMXhjcEVGa2ExckhVNGUvYjlyYjZSRDQzV2pqa3NTblhP?=
 =?utf-8?B?MXVqeXo3WmI4N2lnZE9Wa3dudEtJYzl6Tm0zd2xSVnR6ZGNzTHNJbXkyWVBv?=
 =?utf-8?B?d0RkQS9qejFtN09TMzRHM09vQUczREFMS0grK1lkTUhSbktkTHNQMnFWdFhS?=
 =?utf-8?B?TGt1UWRmeld4VFZhVWtQamJUanQ0UWVXRUc2Q2ZNbEQzZ2dwaTdvVGp0VVU0?=
 =?utf-8?B?d2RhNEhrcml6cEs1dEZYc210Uko1N0YyeTVsdWZ5MnBNK204RFdmdDJscGVL?=
 =?utf-8?B?T0ZJcU9jMzkzVHkrZVo1eE95UEJQK3NaSm1pSHVMTDFzUjhTUWgrNEpXR2VS?=
 =?utf-8?B?YzJTM2FreWtRVUU4UkhiekdHZDJ3MUUyNWZ5ZUN0c1FUV1cwY0krbURVZFpx?=
 =?utf-8?B?TG9nbm9tY09UMGFBV251ckJJUnZDMzEzc08rUlA5ZWtrL2syRlNHeXhoQkE2?=
 =?utf-8?B?djNYZ25Mcml1eXdQMmQzdytHdGt2TVRrL3R4QkYvT1JSOElWV3NBYS8vbFBy?=
 =?utf-8?B?T25VYStCRGtlOG1FMFd3Yjl1TXl2NlJJc1JMaGZ4UUZDb3VrNStqamlNb1V6?=
 =?utf-8?B?dmZOc0lYc3RwdnJoVmRiM3FxNVRzSVNBSkJIenVhWjF4dVJMQWtFK2kyM1hj?=
 =?utf-8?B?RDh2YlFDZFdHZmtCQWwrN3kxYkJaSjl1YWloK1lSRWJCMDQySU9wNzRMYkcw?=
 =?utf-8?Q?+OJjK/JCwrwK0N/4Z9KM/ecEsKpy6A+pzB8zt724sl5V1b?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5638ebc-d15f-4a82-c2a4-08db359c00d3
X-MS-Exchange-CrossTenant-AuthSource: PH8PR10MB6290.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2023 06:07:15.0974
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zPdu0J4XtrJpoLl+FktXKtHhnfLdGT3DlfAJajZCpRIfg3pfgKmaQAptMZ+I8I4fKjVy/Ozqs0ZCEiu+K8STNCMK2ayOfbXA+Ivho3CACnCe5UHh1oFx/AG/YaaTMqz4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6768
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-05_02,2023-04-04_05,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=951 mlxscore=0 adultscore=0
 suspectscore=0 spamscore=0 malwarescore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2304050056
X-Proofpoint-GUID: J8hKzpvFJzarzk2nH11AbrzHMC8B2T6b
X-Proofpoint-ORIG-GUID: J8hKzpvFJzarzk2nH11AbrzHMC8B2T6b
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
> This is the start of the stable review cycle for the 4.14.312 release.
> There are 66 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 05 Apr 2023 14:03:18 +0000.
> Anything received after that time might be too late.
> 

No problems seen on aarch64.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit

> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.312-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
