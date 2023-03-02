Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C5436A794F
	for <lists+stable@lfdr.de>; Thu,  2 Mar 2023 03:07:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbjCBCHc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 21:07:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbjCBCHb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 21:07:31 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 694FA515DD
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 18:07:30 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 321Mfsfl017752;
        Thu, 2 Mar 2023 02:07:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=05So7sSW8nEw1Qu4nEfcO898br1b7jq8b35En1lsOYw=;
 b=Xx1CIhB8YaHNPvCzw5rw/wAwuZ6nuHWvw+N+l6oTiieOgR3tRi+RJjASGsIdK12bxiC0
 AR2tj7yF7PYQkYd8HlXsdNV4wUDkToqCcKtKihe0xzSekP7gS5GFzLjVN22Ob1Ne+bMn
 AajnuMXLDaHij1Gijp7E043QNfki29cs80/HsxdeHkON3GuFIGRCR8aJSPkasFcXvjpJ
 yWcQN0Hhu4xL0vobcZX1BD5vavI2s6Ifqup3B7O66BQkwJicRGpSGMFRPF3ksrwVEGGC
 AlH3bUjpV/qYO+YnoLXWk+50V3bmeWWk+KSC/+olLSP/uzPgOyGGadPKBJpGGJha4ZUM uQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nyba2ajw3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Mar 2023 02:07:24 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 321NpWMC015877;
        Thu, 2 Mar 2023 02:07:23 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ny8s9pg79-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Mar 2023 02:07:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=REOaWBPXcMnoHl7NQMU3e9ExIWOg3ItVok/XG/goMhEqxxuXAGzoS+L0j2OobERFHJdQuEh40kAZAMvKvrg9jhulXBuKB+5dwdHv+pekMplhK2rJIoI91+5BgZcVqdSF34Hni7OnUF/VcuTfIACyApbeqf2qX4ipT1tvwHkmcAH007g/bGyl3nJg+3sXA7zrMCEmGzqWDMNhoIfQOrH5GI21eo91ENTa2NRMMBkeZr6hTSGfxtYj2LIFos0wvuGob6jLedXNXYAtp+c9VAiZuNKH35Z0CmDmw6/nG7JSjEUx2tKfwyc8ma7i6fOeV9F+hkLv9rv2NnKlAhPQbdXENw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=05So7sSW8nEw1Qu4nEfcO898br1b7jq8b35En1lsOYw=;
 b=VxKy5dtmuYG5MGiY3WOseRwTrA3jOvxWCpCphxRN82meXPsuMjfboAygf4NWtmdYbM9TfgmHd/+gGVxa3SV0pZTcp5xiA3HyJLGQmMnKawqwCeH+h4e4TMEbyndaraSPPy/oyTJQ7nPYX2sZaBBSWpgDoKMLTWJvUzy8Lm0E22ySyjbC7L9hKKTGlSUATNkc8JtBBqs0z9xjc+YDq5UETDTZs8qU13/UQjYm7gZ4TUuN1FRGDicqQpVP9VPhSq4VSc3ymZJmQpJNzgUQKzFOV9gSuUDEfciRSwYf2Gdqyodb0EBJULLa51mpNZ1b6014KMhSqU6+2rt9EliDjWr9+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=05So7sSW8nEw1Qu4nEfcO898br1b7jq8b35En1lsOYw=;
 b=B9NR0spqN/yt3aSzIRfBHam02mShb2vY7L+K01WOFIF1ZL2JHj0K5kHQQlkFK4mHgqUfvp2+XIEqebypkM457vqGPmuSfAtXAjrGuoROwcfgFBMfX2xLE5pkjW8CyBbQPqm2Mms1PBCV3Ywx2ly1Pni7ui+kOfKBzqxaBJRPXp8=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by DM6PR10MB4284.namprd10.prod.outlook.com (2603:10b6:5:21f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.19; Thu, 2 Mar
 2023 02:07:21 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::df97:c045:6f0c:974f]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::df97:c045:6f0c:974f%3]) with mapi id 15.20.6156.018; Thu, 2 Mar 2023
 02:07:21 +0000
From:   Tom Saeger <tom.saeger@oracle.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        Tom Saeger <tom.saeger@oracle.com>, stable@vger.kernel.org,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.4 v3 3/6] powerpc/vmlinux.lds: Define RUNTIME_DISCARD_EXIT
Date:   Wed,  1 Mar 2023 19:07:01 -0700
Message-Id: <20230210-tsaeger-upstream-linux-stable-5-4-v3-3-122fc5440d4c@oracle.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230210-tsaeger-upstream-linux-stable-5-4-v3-0-122fc5440d4c@oracle.com>
References: <20230210-tsaeger-upstream-linux-stable-5-4-v3-0-122fc5440d4c@oracle.com>
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.12.1
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR03CA0146.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::31) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|DM6PR10MB4284:EE_
X-MS-Office365-Filtering-Correlation-Id: 66f9b77f-82ee-4200-76f2-08db1ac2db80
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yzeeub2Yp2G3od+E5AxqvW2yNaPk/8BuJqd2Pi+4DcDHFjp6ewnxpBwjtyBxyI8uMDMtu8X4aP49hiyrejhgPG5JOoKtvzAxFakUSlgCCzhXve20G7mg9ka28nisT3fN2yywpHgj5ordxoXuxmnj8ufLjwgQC1HD2cx2/AAvs6cFVVhPfS/HT+pZvWtB2q5q2KAC60A2NtlSyTJEIwLO5bP7WD6so+dcgMijbSAfjMEhjtu/7nkOht+u7NyH2t+epKuzEIBNHm4S6K1k2UmVyj1wCdqd39rQl//nkXM0ddBpuFZc69KXnBE3SMDuNLbD8EZfRuYU28mJD859LtUyjQFq/wWLmZuuBLf/TVVN7rvfMexEfgdt3KtKghU6yivW+u/0Okd8h2fhOb04QT07upHlliW+FD5408eJ6qCDLtMAHI25jU6a3tcs/tdLYgo3Gfy6EvncXWK5S6dlBWt040nVDEQDdHExD5r9+7lqdzhss1LS9I2aQWRnqYJCy3w+nzbAEk36hfDDNzqILz62UJZF/agzH9HtXWQkqbe+KSqbnfLhFdz6yVDEDVlPdAxITsb2D1pkSza35YGK+I/weEm1EtS/+bJ5pQSKDTtkGdIzL9Y7SWQ6wUgkZm+cCAk+9iaa/ecH6YRzTeCzWgAhZZCwXrpG28fhJGYBlfxfOvI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(39860400002)(136003)(366004)(346002)(396003)(451199018)(5660300002)(44832011)(41300700001)(4326008)(6916009)(66476007)(66556008)(8676002)(8936002)(66946007)(316002)(54906003)(38100700002)(966005)(36756003)(2906002)(6486002)(6512007)(86362001)(6506007)(26005)(186003)(6666004)(478600001)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ck1oNjBQL2NRTmJKNnc4WXBCSm1FdTFFTVM1WXFQemJXcFZPendWclVsUXVE?=
 =?utf-8?B?VklrU2kwdTZxdnFBbFVZQ21uMkJ0K2djckdvSmw1K0VrdDVFbUx1N1M1c3li?=
 =?utf-8?B?cklnUEZBMytKK1FnNWtUQm9uZUNNMU1FSC9jaGdXbTNuWGZkamlyeXJRVXpR?=
 =?utf-8?B?eWdaTU1zam8xU0xEbStLZEp2REZLTHZQMSs1ZjkrWDF6ZlVSU215bTJHQlhQ?=
 =?utf-8?B?SUxQd1h1eDJaeWxNT2NEY1pPdTlXTkZBMVhHdmE5VGRMZU10R2xNMGY2cmx6?=
 =?utf-8?B?aE1salI3bGhNem1oalBaSFNHdWFrTGlDOTA4SDFLQWhzVHZhVU9XcktMT1hh?=
 =?utf-8?B?NnB1YUszckhNK2pZVzZkMDRJTXVSc25HUmpnMWFOY3RIN1BsMWVsd0hoQS9P?=
 =?utf-8?B?TWU0b2w5ZjFwTlBqRFdKQlhYR3hxUEhMbzIvd0VLd09jTUczWmd6ZUVxZERx?=
 =?utf-8?B?ZVBzTzBSSjJiMkdBcmVna29KbzBZeUI5ajh4aTAzRWFOMGMrd3BkSitGT0gv?=
 =?utf-8?B?T2o2RndrQzVRaEpOOUVPYUVKY0xMcWdtSG0rTVp0Ky9rZk9nY29zOUhPSnl5?=
 =?utf-8?B?QkpWUkpDdU5BckVpejQ0cmF3SVdQNEwxUnlQcFhyVHhaWkZaMUZGOTRrMSsz?=
 =?utf-8?B?Q3FXU1J6SW1DelcwRXFIK0ZIckZrRUllTEhFU0w4OWNPV1BIQ0RabmhkZ3Bn?=
 =?utf-8?B?UXhDNnpzWko0eWIxV2ZsZHdSTTZaaWpOMHhqeGgzcVBuV01uYVozemxpNHJO?=
 =?utf-8?B?NE1FUmVrK0UyS1htOGZjTGlORW9Jd2M0SXdNNnBwWWVuQVVwUEo5WXd6L3Y1?=
 =?utf-8?B?UkYwZDVUVDIvWDIrb0hDWDc4eWkzc29qYlRnSnZudEhBM2o2OTNUZjJUcVh1?=
 =?utf-8?B?T3JzS0pHcmRna05tdHNMTllGY3JLTEVRaUREU29na0owQmtZNmgybEx1b1Rs?=
 =?utf-8?B?TzRmWE8weHhUbzJHamQ5dzk0VFp0cHVpZCtYTlNSczJ5MVpBZFZZWnBZQ3RG?=
 =?utf-8?B?VGFXZ3JjVVpCSDVSdjJpVmhFWEkvc29laElTVUZneW9zVVhiSjBzcG9pQzFl?=
 =?utf-8?B?L2ozZmJTTVBWTS92cGN4TEE3d3JVb3dRVjVrUnc1K1BKM0N3N1c5dEdJclpO?=
 =?utf-8?B?WTBMRThMT09rV0lJMTNTNUZrOTFKNTVpS3duc2dkYzJ5ZlRvazBISlNjV1N5?=
 =?utf-8?B?S3N2MXV3NU9aUUVTV1lJczlRbWt6RkJ2MHczZForN3Y4T0hJS3crTTNOcDUx?=
 =?utf-8?B?SzRlcXgvOGRWQ3VqUmJhTUVIM2hNVXdFR1FJdXJqRjk0VFlDQlBOOW1GUm8y?=
 =?utf-8?B?Z2ZUc2kvdG5GT0J6c1UyaXUwUEFFaGNoSGdINS91cGQyTWpoTkZESXBkRldh?=
 =?utf-8?B?RXh3M2IzSU9vWUw5dFhDU055dytUaDd0cXo4SjZObmNEQXczYUYyazNLSFBa?=
 =?utf-8?B?a25wNFZyS01CYjNOM3A3NDBERVg4NWV6Q05EWnJBWGhuczJ5UnNYcGNXV1dQ?=
 =?utf-8?B?VDJlZXVVc1N3amZ3a1lCL2tkTzIrUkwrTUdxUVRubEx2L0xGanF5M1Z3NHR1?=
 =?utf-8?B?T3BjYlRYd1YzV3h4Z3VOSlVYL1JBVnhoeVl3bzFzWUwrbHl1VXFzM0tnZXZv?=
 =?utf-8?B?QlFlMFFTOTV0Ni9ETThiWTBGcVV5WFYvcUpTTzFQbktKWEkycHZ2RDg5MnlL?=
 =?utf-8?B?ZlFCc0JYRlMvWC9jTG94UXgyTDdVS0tqNEdPZ0VNT3hLWUhsWEVPU2NRT252?=
 =?utf-8?B?MklSa20wamRPdmRlOWw3UHgrOWJNUXBDZzlYZTFIemlURzFqaEU0S1gzVlVq?=
 =?utf-8?B?YTdXOUlIcnRVS0FoS0FvWmMwVmdWUG5VY2VQcnJUbllzYXhsNWR5Ny8vdHBQ?=
 =?utf-8?B?N2c3NDliVlU5R3hFUEM1L0ZqeGEzRVEvSDlhVzRTV1hKUFVOVC82Y2VveGJs?=
 =?utf-8?B?ZXdEeHZIU2NyMDFkYU92VTMrd1pMTlo3U1c4elNydFNRS2RaN09oZ2tyTGVn?=
 =?utf-8?B?Q1NiVExsa2dQVDhXQkJXSEsvOFBXaURNYWdsbTRka1BQSEZmOFNMT1E4a3A4?=
 =?utf-8?B?NHhvQnEyYUxIdEJPcTdKZmQ1TlAvUTMzZDJZa0JoUXNPcmhZMHJGVmRTYWk0?=
 =?utf-8?B?VE42cWJkTU9NblVpclpSOWxydGdZa2lMRDA0Y203dnVxZmlHQmR3dE0zQW1q?=
 =?utf-8?B?bkE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: cEV069Eu2jxmFFOCKiLhveiWb+Ko3+Jx5D1Yh1oezPoEEcVKDfCRaweU+MkfniZq8dvXQoKZrZRYHrYpsuivrDKwAPnN+pgPSoWIfBlxmokjfKTiTvAMJG0HfNV1pIsFqRu+0siBRIJWN+/l+KUUO0+0ULAQqsxkF/EQMDDD1NOTFa9Iecs2lKEac4qQGvj5F9nCv2fuMKPSmGHobfPr4ex9E5vwElT2FpdSxoE9wMqXK6x2O27kEt6YPRoSBPQQIlV8Djc7bVQulBiZRKR5FjXBYs7NvcF1kwaj6eXsFD9UfTc6UpO8NDaxbr79TDPwPBqxgaHOTJgUZ7nFM2lz4JIsIa6erRY9Aalr/zcmkqVqZwW8u1LA7ErYB72fcDP9DrGUXQGLqIjsux0VZyDkzI31Jr/rK2c+lP+yvzh0lTTyh2y/4Uux+K+ExPa0BWCrvFBPP08o993E4pgbRqiHgE5G8kUJXxv+HYdT70a3jAb/Ys97zjv0Lc3xz5MIfOGkJGVSbtDTMWxlFaQrL628z2HpKRwJPFsK3p3qMMXTrONyQ4mE7+aggZ1DczDlWbZsRNZX9iANd7BX7b/6offoxvn/tBkGjNtqQheVXMwkp2UAIZQKFUpFGEulG3RLPlnnnDWkhIxZA61G/kBFWTGblPfRMbJ/52NZrfmXpB8M+eSYRl7sPH+dCx6LgWrCTeHCb4J/MggyIs3Knzdj0X+Nbd/D7r/a4P2kzYvCkSfkFvPg/1NxyeXn0IVNPa0DyoRPWUmrfMI/mmua0trJERgh9mEz4oiJMfHdmOqM8fObH5W3SzjvRRZ1DIVRjIUQkTIgE7Fcs8HDM8CwkLaFUZxGHbX/cefGDfhppAOc/3RGOthBzc8Nptv0RlMMpT29UvMm
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66f9b77f-82ee-4200-76f2-08db1ac2db80
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2023 02:07:21.3070
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2N2Zzvq8EXelaBtAHCNKVJzy3g6nQ+1kMyPboY4M+boTgF4JpUfVex8rOO1TKV74Q4eGnHFF1AbDKEZM9GC5Ug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4284
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-01_17,2023-03-01_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 adultscore=0
 mlxlogscore=999 suspectscore=0 phishscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303020015
X-Proofpoint-GUID: pTVM901pyWpZ1SZqXethjEh6Ace-64c-
X-Proofpoint-ORIG-GUID: pTVM901pyWpZ1SZqXethjEh6Ace-64c-
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

commit 4b9880dbf3bdba3a7c56445137c3d0e30aaa0a40 upstream.

The powerpc linker script explicitly includes .exit.text, because
otherwise the link fails due to references from __bug_table and
__ex_table. The code is freed (discarded) at runtime along with
.init.text and data.

That has worked in the past despite powerpc not defining
RUNTIME_DISCARD_EXIT because DISCARDS appears late in the powerpc linker
script (line 410), and the explicit inclusion of .exit.text
earlier (line 280) supersedes the discard.

However commit 99cb0d917ffa ("arch: fix broken BuildID for arm64 and
riscv") introduced an earlier use of DISCARD as part of the RO_DATA
macro (line 136). With binutils < 2.36 that causes the DISCARD
directives later in the script to be applied earlier [1], causing
.exit.text to actually be discarded at link time, leading to build
errors:

  '.exit.text' referenced in section '__bug_table' of crypto/algboss.o: defined in
  discarded section '.exit.text' of crypto/algboss.o
  '.exit.text' referenced in section '__ex_table' of drivers/nvdimm/core.o: defined in
  discarded section '.exit.text' of drivers/nvdimm/core.o

Fix it by defining RUNTIME_DISCARD_EXIT, which causes the generic
DISCARDS macro to not include .exit.text at all.

1: https://lore.kernel.org/lkml/87fscp2v7k.fsf@igel.home/

Fixes: 99cb0d917ffa ("arch: fix broken BuildID for arm64 and riscv")
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20230105132349.384666-1-mpe@ellerman.id.au
Signed-off-by: Tom Saeger <tom.saeger@oracle.com>
---
 arch/powerpc/kernel/vmlinux.lds.S | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/kernel/vmlinux.lds.S b/arch/powerpc/kernel/vmlinux.lds.S
index 3ea360cad337..4d5e1662a0ba 100644
--- a/arch/powerpc/kernel/vmlinux.lds.S
+++ b/arch/powerpc/kernel/vmlinux.lds.S
@@ -6,6 +6,7 @@
 #endif
 
 #define BSS_FIRST_SECTIONS *(.bss.prominit)
+#define RUNTIME_DISCARD_EXIT
 
 #include <asm/page.h>
 #include <asm-generic/vmlinux.lds.h>

-- 
2.39.2

