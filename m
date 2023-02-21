Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D25C969EADD
	for <lists+stable@lfdr.de>; Wed, 22 Feb 2023 00:03:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230120AbjBUXDF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Feb 2023 18:03:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230398AbjBUXCy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Feb 2023 18:02:54 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1D6C32E6A
        for <stable@vger.kernel.org>; Tue, 21 Feb 2023 15:02:44 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31LMiCFZ004354;
        Tue, 21 Feb 2023 23:02:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2022-7-12;
 bh=g66PYrUxZEE/wjM+kAW8F2180Li4FI5+UTy7qUbwqXA=;
 b=URxRhielxhXGT3zU6sJjae+QmkxDAIFUy6crHwf6yqVr/GpEaiTJ/EfEzd4kLaXjNftA
 7I3C8WhWbeJnkTluuZxQh1JYD5yGsH5jZ4xRjO0OdI9vaeYMH8rbMRKppRHgN2hlK+x5
 cAITTJ4VNhQQgGMi9OA1WTavB7T7poYhtph6bOAV/zBcFP/88/D1a802w+8aUlxtyRU9
 CJgycBP1F2HgFsbasROd2irQLk2uvS4csv/prt727Vt3EEWYO17csBKiqlFEanp7rSnv
 vb2xu3MUWyBRduSWWS6g09GJQyx0nD/rYfVHcgRXQA3X417Qr19tUjUl4v/6OvHhpXLI uA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ntpja6jef-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Feb 2023 23:02:36 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31LLqouF031212;
        Tue, 21 Feb 2023 23:02:35 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ntn45t93c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Feb 2023 23:02:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=astL2+47q0JXjrI+xsTEIBbX4/S0PYJF+dRXrfbHbVmhSepJolM6aZnFpbvYHEIbJKqYAy9iJ4rDA+0+Q1/9hDuh5UavBTcSj3trEv0iVdYisjXUMGX2uVoEtGTQ0Pt/wWJi3c6b9ORG3TxzCKUXQ7BzlzYU1+zwmR0XjiUjPIHaxK3IkJOFwvSWkzLnTX+C72Tz1d1ZBqV6UUVpV+gomWMYEBYO0V7qcRdxDkGQUcFweQGtymav9Ql7O3q3t5NVZANgeRyvUC9K5MAaV/Qfp/snCZCLEXcnY1q4a60vaJ5pftbHYv7TD+1y2Y8z10V2nv7ENB+qaVqq7/hznYAu6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g66PYrUxZEE/wjM+kAW8F2180Li4FI5+UTy7qUbwqXA=;
 b=lQn+U8pgBGYUV4IKLGNveMPSDoH3Cgd5DHOffhUNj5zBaoKogb4Z06/lL1zgJPBRU6wBld/3kypkjI8rmF148rTCcPWMtUPNW5asOQqG4urBjzC/+UifTATrlTnFrO5l7tmCGtbIPoTb3w8TDxIHerQydeRxcXAucrfctxvvh3uuRt7JrK1TmvjVI6QaHAIeXXkULeuOO50B+dlGm/0Bov6ajS/tNagwQ0J9S5u0h3s9Q9/VOGxzrhQ6FeaQd6eY0ZY2uusIQPVA5yYGndWVvq9kfy+0wZhDNAvW2wuol3fpIjvdZyjqc+eb2mzWb1zHrLiAELedzAlVck2g/IFPJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g66PYrUxZEE/wjM+kAW8F2180Li4FI5+UTy7qUbwqXA=;
 b=PbYCrV9U86M4jqXdaQnJkbh0olLko57syV8Ded/cj6j5pTbCNNquRwI+c+FAwVrMFhe8OJ1OivbuSecVylyDURr0fdomP2jGrQ8QEUF5X/pOXaaSgnd4I5S6x7IbgbKj1xVVEgUU3+6U/x/guyYHu8j4zZ+WjWy53194Cz0XNeM=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by CO1PR10MB4769.namprd10.prod.outlook.com (2603:10b6:303:98::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.18; Tue, 21 Feb
 2023 23:02:33 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d%6]) with mapi id 15.20.6134.017; Tue, 21 Feb 2023
 23:02:33 +0000
Date:   Tue, 21 Feb 2023 17:02:25 -0600
From:   Tom Saeger <tom.saeger@oracle.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.15 v2 0/5] Fix Build ID on arm64 if CONFIG_MODVERSIONS=y
Message-ID: <20230221230225.cll4lfsxhv2s4sms@oracle.com>
References: <20230210-tsaeger-upstream-linux-stable-5-15-v2-0-6c68622745e9@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230210-tsaeger-upstream-linux-stable-5-15-v2-0-6c68622745e9@oracle.com>
X-ClientProxiedBy: LO4P123CA0491.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1ab::10) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|CO1PR10MB4769:EE_
X-MS-Office365-Filtering-Correlation-Id: d5899bd7-e21b-4607-f345-08db145fb734
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: knZjS15w8fo4ui86vvxGv0mhR6Lb99QrvV2EMavCt4TYVWeiancAWRwYx1xfGI8Ee98HMkfP2xXzOZVOMAVIBtPYl98W+j4O4BbJf85sTjF3VtnK8lZPW8NFTOPlG3BxCd9redHF1nE+qK60uQB08SVb449Z9XwPrM53Kmk8LILz9b5SXJFhNvDuu+OhMjJ4x4vmhVD4aFgVh75lAouWd0gHEx8chfzcVC35TqGQQS8EwmxveGK8lxRnVnCGspggXu90CQGWPA/dX9saDMTKeMjVXNWu6VREbz/pdyvsLQUeykg+m+5lSFoHLLhb7Vua/vf+VG6GuBwpU2c3qIuZ8KR2l+rNGAnDD2YYSrQ8XKh5WhU8PPSDJXm4b0RmqPRJRAZg7gHmZXvg1r4L5G1eLXmAonQ/+xqg0sKXbMB7mbbOB2Cj5tkFiWgHU8iuJ/mTZSbQIcGk6t2lGA4emv45wE8pgvxAVHK3EXXU60RFu/H9dqUcCVG/4p4ivjFeOoX5Ut7GXlW1o2jUKzxsMLj1B4xrSYHHidy+lI3bYZEJGojYhktTtxY5kK798aE96wlY7HxE5vLzDv41p4ufhYuunMKOT+JUcyfB7SZS5tfuVBVTLFzpHkXCRY7mPYplsatZIPbqkFLcWfgU/RYorIypLD79sNEoFOwmIY17hqiWg04=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(366004)(396003)(136003)(346002)(376002)(451199018)(44832011)(2906002)(316002)(38100700002)(4326008)(66556008)(5660300002)(8936002)(41300700001)(66476007)(66946007)(8676002)(6486002)(966005)(1076003)(6506007)(6666004)(6512007)(2616005)(26005)(186003)(86362001)(36756003)(478600001)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aFNIUVMxNkNMQWFmdDFMbklqSjMvTVRkR0IwWkJyRXNGZ3BhWWV1SWQ3LytP?=
 =?utf-8?B?aFZ5ekd1aCtIT3lzQWc3NVV6bytLRnNaalkxL1BZaUdKMzYrak1JQy9TK3BX?=
 =?utf-8?B?a091b3Y1dEJaZ05KTi9RSmhyaTlET08zSHZHWE53MDBKSUlxSUVVZHQ1OHBR?=
 =?utf-8?B?SnpyTDZBcG5LbjNITHI0ZnQwVWszR3BCMGI1SWs2T2VOTG56UUYvZTNVeWZ4?=
 =?utf-8?B?Unc1REdWQTNkVXZ2ZXo2TndrTmsvcXBvc3ByOTBkOGcrcUxqbUd1TkhJTWpu?=
 =?utf-8?B?ME0zNVE3OUpLUWRFaVJwT0YyaDIwaG5uVGsrQXV1SllZRGYwbEJxMHM3cUNv?=
 =?utf-8?B?VXNueFpkWUtjd1ZpSys3T3NMNGZMcjVqU0JaS09TNGFwaWNCSDR0RVFiVk1t?=
 =?utf-8?B?MDZaU0ZXZUtxeGVyajFqS1RoVFZSbUxKRk96YmpWdFdXc1FRemVDcGE0ZnBx?=
 =?utf-8?B?NkRiRkplOVo1OGxJbXJzNzd5RVdNTENqd2hNZ2czZmVIL2xkOGRJbEwxY2tP?=
 =?utf-8?B?VEZpZWF2ZUppbTV3UXhtM0VvZnJadmhabG5OaUlQeVA1UXY3U05LYktVMmdz?=
 =?utf-8?B?d1hITXdMSHpVSXNmV1pNbklSQ1paaTExbWtRSVN0NlJqNHRnOEtLMnJJTjZ4?=
 =?utf-8?B?czExNUxtK21Za1phZld6U0k4UWJGSzhqYWNrK1R6S1dGSjZ3bHdwTkVuSE9M?=
 =?utf-8?B?YnVMMVJhelY1eWRqRlRMdTBoWDhzdERMQjdacUN5U2IreHRYUGhZd0thbFEx?=
 =?utf-8?B?SlNRNFF6K3djR256TDBIZ1VuQUsrSS9wUCt5M3dRQS95SGFncGhpUEJTRGZL?=
 =?utf-8?B?RFhYQ1RBZlREd0lJTVdVTVB0akxhbjV3SUJCc2FnaXgxaVYvQytlNlR4UFhU?=
 =?utf-8?B?Wk1SWWFBRUpZN3JrUUhCa2J6ckpBaHQ2TUhVMHFMbWZaUU4yUTdmZEh6TjIw?=
 =?utf-8?B?WmMxVndWQlVtR1VmaVdlU2lqY3dnaVEwWmNhUlBwUm50RlZmdUNJWWJSK05k?=
 =?utf-8?B?bXY4U1IzSU1uaU1TWnFDS3lQd2d0RG9WaktRYW9MUXh2KzlQQThwSmNCL2d4?=
 =?utf-8?B?SU1TZUxSQ05Zb0owd010SGZ1OFpDeXdsZHg0Q1kvVnNrYjhGTTRIUXA5bFVP?=
 =?utf-8?B?eHBXYkN1K0dNQzZrT3QxV3ZhRElTWXkwcys2ZmJsSUU2SW9NRjc2WGVlYXhk?=
 =?utf-8?B?a25pYlJ4ZjJNZ0FOSnROUURKZFRpckJNbFV5eC9Wb3ROL0ZicW5yOHU1Vytv?=
 =?utf-8?B?ZVUzbWJsNzVPMmdJZzBTOTZkMFFraTNHNWFIVERxNWQxRGs1QkwxM3VweXBJ?=
 =?utf-8?B?NTR6UlBRYzlXc1dRVGtYak9nb2phdlJuR2xpbTRRRm9Ca2w1aEw5enRHK0lo?=
 =?utf-8?B?aDdVeCtEQ2QzQ1ZUWkhhckh4ZURrWFp3Yy9lVStpUmg4MFRuVzRnY2RXclNz?=
 =?utf-8?B?SnJSZThVL3M5Z2hPaHZXZ0tSbHlIVUhRNUF3QTh4L1lidEhqNEVUNVdqWDZZ?=
 =?utf-8?B?akVhbnVRSjA2czd6bmFrMUlia2RhWk5nMjdOK0VvSWpsbjJHTzFKU0E4Nmtk?=
 =?utf-8?B?dGdaMlIveTRYNDJoM2tYeVpkYlhlakJlQjhiVGJSTWc3clpSeFZKcGVyVmlz?=
 =?utf-8?B?YkUwYkFmZnpFTy9tNmcrT2czNTJwUndyUHFaaWVjTjltQnRrN2g1MVJPb283?=
 =?utf-8?B?eTY5YkVQS3JRSmxLdnBNc2dzWFpuK1VYOWdaYzFQb29ZVTh3UWwyZTRaWHBS?=
 =?utf-8?B?Qms1TVg3Vk1vQ2pqY3E4Zm9XdjV0Rk1DSVJ5VXRCWlhseHYxSDRQcjR0ZXFN?=
 =?utf-8?B?QnZtektUbTNEbFFiMnJQeHF0ZTY3YlpVa2dTVUZXS3ZjeHNSU2Nnc0VOOVRX?=
 =?utf-8?B?MWZ1WUJkeUtCRHFPZWFUMXZTTWc2aHh5NHN1RmdvLzlUcUpTbWk4cGN4YUtv?=
 =?utf-8?B?UEdRSnI5R0kzUGE4eWt6VHNCbUtnUWhibVk1ZVBLd0ovT3NTbFh1L1hVRnd0?=
 =?utf-8?B?aHFUMkpIQ2xXaGt5anhVampQVHQ0Yk5vZ1NJNVZLeUJXa016b3BLSFNvdVF3?=
 =?utf-8?B?bUhWSUoyZG51WEo0R0d0WU5aR0ZyYmlsM2MyMjVHYXc3Z2NMOUNxSWJaWW0v?=
 =?utf-8?Q?j9OdTPwmemV5JhVDdano9j7ho?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: wnVD9zd+jz4LP7fOOMrLgjUmwvQ6c5Ex0LAAgdmsuRPufrhsqOF+oWb4jrfH4lrL6SXo4l0EJML6xj6uJ6kUXoEe3KWJsVyDpR7MyOzkPNoKF4Uy/PHEoygaozgoOQHlT50p0DeXjxSU4iKO+7C96OvGibZKvdOM0P+/mtmFAjn8ZCKhVO6yyjqHBFBszweMfSXaRICHULRnl4mXUsvsEzgcPWv0E4NsKDS3/MesP9GAKPkCSEQHYBqLA5vcBrhrx4caPEEhWCL/55CnSzMPONGzPPGfMY3urCCI2e6TO+FwVvw+n9C1OmErr9QtgCQa5WJ7PnQj/tVHA6NwF8XJNO/TanlviUgmMiNIbdGIMG5yxjbaLllOyoEBGcVE1+O1KHjKThmBWWmG4eYn6KSYUhuulB9XdyvcXGVgNq3xP2ePFDrp+8byHCwTtQdoI004tA0sbd88DehkpIv9dAzOExYnhPVMr62yk7pM8NOknq/J+1GJ+0LishTdF1G2rZIxx7jWCNqShUrwI+5V0n6kpsN6Rc3KTGb0O0NN7siFg0LY5MWrX6q0wA+M9ofBAzP+185t4K01rKOx9JblflolsVVgEm/KGczTfbq5JY/YS/I72/wSZJ8rVjNv2fOUveQuVg1r/Zmac8hDywAclRJLwENbzg/aPJ4t68YnzpDQCXZhVM+lPbj/pqqUU8LsG0Fld/AHf18Rnti6XnGR8C1+GmwbDAdOsvqW9QL2II8H+wwR7l/OO5dzyRuyOmOyN3BNvZf7j5FRbxv4SkoX7Yvyb6MHsbN0K/1gId3kAQMGcv+2XRoSG9AtoXGAw778p5FyKl/HW1Zya2Bv0EUtZnPH/H1sTIFXRnGdyWrzctvKa3I=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5899bd7-e21b-4607-f345-08db145fb734
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2023 23:02:33.5737
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yf8KxwYly/3QWgsbqoEE0yG3p5cJQJ27lS2N2RJXB8f3tWvkEom7BaxWg1E9sy8sNDVxfqZonzQ3POVwkozzjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4769
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-21_12,2023-02-20_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 phishscore=0
 suspectscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302210198
X-Proofpoint-ORIG-GUID: 5yc1NpWS_4FHFE56WXfL2CE4zlGTpLW4
X-Proofpoint-GUID: 5yc1NpWS_4FHFE56WXfL2CE4zlGTpLW4
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 10, 2023 at 01:18:39PM -0700, Tom Saeger wrote:

I double-checked submission procedures and I believe everything is correct, 
is there anything I still need to do?

Regards,

--Tom


> Build ID is missing for arm64 with CONFIG_MODVERSIONS=y using ld >= 2.36
> on 5.4, 5.10, and 5.15
> 
> Backport BuildID fixes.
> 
> I've build tested this on {x86_64, arm64, riscv, powerpc, s390, sh}.
> 
>   # view Build ID
>   $ readelf -n vmlinux | grep "Build ID"
> 
> Changes for v2:
> - rebase 5/5 c1c551bebf92 ("sh: define RUNTIME_DISCARD_EXIT") from upstream
> 
> Previous threads:
> [1] https://lore.kernel.org/all/cover.1674851705.git.tom.saeger@oracle.com/
> [2] https://lore.kernel.org/all/3df32572ec7016e783d37e185f88495831671f5d.1671143628.git.tom.saeger@oracle.com/
> [3] https://lore.kernel.org/all/cover.1670358255.git.tom.saeger@oracle.com/
> 
> Signed-off-by: Tom Saeger <tom.saeger@oracle.com>
> ---
> Masahiro Yamada (2):
>       arch: fix broken BuildID for arm64 and riscv
>       s390: define RUNTIME_DISCARD_EXIT to fix link error with GNU ld < 2.36
> 
> Michael Ellerman (2):
>       powerpc/vmlinux.lds: Define RUNTIME_DISCARD_EXIT
>       powerpc/vmlinux.lds: Don't discard .rela* for relocatable builds
> 
> Tom Saeger (1):
>       sh: define RUNTIME_DISCARD_EXIT
> 
>  arch/powerpc/kernel/vmlinux.lds.S | 6 +++++-
>  arch/s390/kernel/vmlinux.lds.S    | 2 ++
>  arch/sh/kernel/vmlinux.lds.S      | 1 +
>  include/asm-generic/vmlinux.lds.h | 5 +++++
>  4 files changed, 13 insertions(+), 1 deletion(-)
> ---
> base-commit: 85d7786c66b69d3f07cc149ac2f78d8f330c7c11
> change-id: 20230210-tsaeger-upstream-linux-stable-5-15-f7bf45952c23
> 
> Best regards,
> -- 
> Tom Saeger <tom.saeger@oracle.com>
> 
