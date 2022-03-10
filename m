Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36A304D4F44
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 17:29:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238997AbiCJQaa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 11:30:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238779AbiCJQa3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 11:30:29 -0500
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 685C6546B2;
        Thu, 10 Mar 2022 08:29:28 -0800 (PST)
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22AFHIUM024012;
        Thu, 10 Mar 2022 08:29:27 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=HxPk0wfg5sk3XAWqXY0MSvuOqUN6KRflbQNuojo1ofc=;
 b=E7/UKBH96HEzNtgBPN4ytflFdTJSyBgLJXNiAN7JjLOmWpdU1WlLC5AwDHYwYM15XRbQ
 KJIj3inRqmSHOCNdx1A+XqZWt/rcQsUc1PG5lCowmLp/1K73CGTkS+hZArwHsGZqXdS0
 tSiggxwzgR+fGz6/SxICF0iZ55Jw9mnkcx4= 
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2045.outbound.protection.outlook.com [104.47.73.45])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3eqkue0hwv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Mar 2022 08:29:27 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CzYcS5cxtNnLN6H4fQNYzJSU44iOVwMAGIf1oaGjq1I0AulgynBRQ8aSr797CSDhMRqixFGlvaNJBSqiTcG+1wKveaV5m4Rx1Nso3FNmZ/MjJiXbbODWGx740u/AP2BU5FoV0thCWwObKoXK2TK0FxzKHDaUljsqvHP79Jv0NrMb5u96upyjRksHJufmnu+oachi/P0hKCcn8/bFeRSElk58uDX3ayqTvcAt2kqodDoqb802KHL/RdWx9U1Gk+d5ebGa0RlNuLvoOxoURm5uVrWc0JlXzjfyMRTb2pp+mnn4lT/81ZJ8wpE7OaJJeCYRJqoXtjiu5e2GLBAeIpl3KA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HxPk0wfg5sk3XAWqXY0MSvuOqUN6KRflbQNuojo1ofc=;
 b=duoaDAFuqf8KXJBt4w84BJkTxHSMTGOE5DbVgsgemCYzuBljYtQHJ6wb9ZrS9Hn/J/uxlwv7aUvDrAy1Gjfz6yvfgPV0iJQmXuEoVe0aCT3noPcHuRJPXBeKBXG2lVW3XjmddCw37VY118bGwd2tT+hyZHwxI5Yy5OKUppUjezGTdhdEqG/Rb+KPGHFRjqLDt45ycKqeFXQWM4Iw4uiuX0B7oC/IOB0mOGG3RB+P6SDwBOL2d3aM4NxRA7qwBt1+1r3adeYoWXya/HFsuKDDlj0vdjqbqiOZ0Y7aacoP597LI2cxM3pY549ddO6W8buTp5PsBgwKm4iopUsdle52DQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by PH0PR15MB4688.namprd15.prod.outlook.com (2603:10b6:510:8d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Thu, 10 Mar
 2022 16:29:25 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::c5c7:1f39:edaf:9d48]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::c5c7:1f39:edaf:9d48%4]) with mapi id 15.20.5061.022; Thu, 10 Mar 2022
 16:29:25 +0000
Message-ID: <177156e5-32c9-c0d7-f1b1-ec9fadc968e7@fb.com>
Date:   Thu, 10 Mar 2022 08:29:22 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.2
Subject: Re: [PATCH bpf-next] bpf: Fix comment for helper
 bpf_current_task_under_cgroup()
Content-Language: en-US
To:     Hengqi Chen <hengqi.chen@gmail.com>, bpf@vger.kernel.org
Cc:     stable@vger.kernel.org
References: <20220310155335.1278783-1-hengqi.chen@gmail.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <20220310155335.1278783-1-hengqi.chen@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P221CA0025.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:303:8b::30) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 68c5b0c7-8d7a-40af-a746-08da02b323fe
X-MS-TrafficTypeDiagnostic: PH0PR15MB4688:EE_
X-Microsoft-Antispam-PRVS: <PH0PR15MB4688F0CD3F9F1B13AB4A6AD5D30B9@PH0PR15MB4688.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mX1HkIP8NqEOltVK+3IfoBJmXw9dfcBdSfP8CcBJBjnyM6boJF92coNMcAeNMpz0dDCK/YYHfc4EmxYs1sycxW7zNc7uRpIQ28hgYBDoCEt3KqPRrAqZMIjiKzxtrIiUwoi0ITde7oCeCCgCOK/MuuTBfraeefqnBV6p9siw49DuvWRUfbhhzk65e74URXDmSytXMXbviK5Fdtvj7Xb7OZ3YOWzIcRlHu17NhS7NlH/rLr3BVQ4MJAF5Wjh17p8CeuOVZPLjWb+SzZ1z8V1BmC2yX/WhZlmylWkHAVw46SLOgPXUYCV7q3JEVwWfIeliuVaR01EjUfQfPaadvTr5pSjnR4cWZc1e+bvyyd1IAsjZ5ZR13AKcOwLQZxMZmQBxLNzjrhyoUFmsyk57LDYEdpb90Z/1ud3ZLoiu5H2f2VBSc+zPq7t9IAXdTLDnvX+ivxkzOatVbHKELeJBZGu40x/b1nq+s4v0sTJ7gkW9hO2hMMlO6t2UZOrrbMTe3kNR3FssaesxHSsIjIQcDbEP+ECvuHtEsT9LFORmEa6m3yGkWDnla7Z77nEw1H7JmswXWWIdjNqEobonCHgNpk4xmgGOZ5o7k/N2QkbPRjEpoZIelNcjrSTcp0JRU6gRmLwTcHVddlHgdsQm2IulopdhCe8QU3U5y6an0dtdnkQgX9IUlF/v4mNwfzoCSphLbmUvVJQ2pNlx06gWqRBGdOcALrIceV0748+40hWjx88nju4Nox3IV/ra/qKCsMqyrM8h
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8936002)(6506007)(86362001)(6666004)(8676002)(31696002)(36756003)(2616005)(2906002)(6512007)(66476007)(66946007)(66556008)(31686004)(316002)(52116002)(4744005)(186003)(5660300002)(6486002)(508600001)(4326008)(38100700002)(53546011)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NWRIYkhtOWRIQ085RjY2ZGd1RVoxOTA5ZUd3TXdCb3lwQ29RU2p5Yzdqb3Z0?=
 =?utf-8?B?Y21ITmJhdXp5WHVlVm5Ra0Vac1dZam9iWmdQM21BdzRXRXJyb3lPTFdEMFls?=
 =?utf-8?B?MlozeVBHcUVsZTk3N2gzYUM0VEdWVDdkYThadXUrOVVNRkVXRUV1bmg2Tmpz?=
 =?utf-8?B?ekZWcTM3NkxVdmVJamdUNEVMOGJiZEpxYTM1WlpBTHFJVnhFOXVjTnh3R2Nu?=
 =?utf-8?B?Q29FdmF0cFNhY0loSFFYQUt3U3h6dXI2cnVPTFpDekRGRFM1UXFYQ0xBME5S?=
 =?utf-8?B?YVVCOURGSEVENkJDckxGYStsUHJpMXFXMFFUdU81R1ptaGk3TVo5bjMvUXRh?=
 =?utf-8?B?S2s5WHpacWROQXF3TGo5dnpkZHM0dzdZOVl6aUt4d1RKb3hiOSt5ZjVwdTJS?=
 =?utf-8?B?Vm5OcVQxaUdxbGFHckNCdW8zd2R3WnNpdUNRV3JMQnZlYTIxLzRHZ2VDc0xM?=
 =?utf-8?B?QmZGTDIzZW1adVVVdk1xTnRtUDNCaHVPTkd6UWtoVmQzeldEeENsS29GaWdl?=
 =?utf-8?B?cGdUT2JvUHBZZlhQMERpOHlMaWFJMTZKemZ6QURNbDJHTXY1b0NkSS9aeGNR?=
 =?utf-8?B?UnhpNkttOWhqK1MyWFNieUJCcXRicitRTjA2NDg2U2JHQ1NwdXlqaEJFbk1i?=
 =?utf-8?B?dE9sVVBhTCtLM2NHdVdiaW41Zm44ZUlCYmVtMUNsTXBQWUlDaXkvRDVkc3ph?=
 =?utf-8?B?VEFoUDB4SHlkNUhkRFdiVjRCKy9zWjdzUUVIbFpOdTFJbHBzVGRFQzUvWkxu?=
 =?utf-8?B?YU5FY29CZERPU29pL29IK2pPQkdMbmljd1g1QjRYYUxWVVhaWVFlTFJBVjJv?=
 =?utf-8?B?Y3liVFY2ZURoTXdWeEpzUHFocXVXZ0NZa0VoVUcyY0VkOUNvVkZhL2l6eEVZ?=
 =?utf-8?B?RVdadDAxTC9qOEh0WXc2TERaM3JneHlpM3NQeWFrMnYvazdCTWxoNy9BdnEr?=
 =?utf-8?B?N1FLMmk2RG45UTFnSXEybm5rb0tGUkg2cU1QKytBK1V1d3A5L2EwUmFlaEhn?=
 =?utf-8?B?aFhvMkY1Y1JRRGFxeHpFMVVqVzVNVUowVHNRV0UrN1dzdHUwN01kY2dwbGhC?=
 =?utf-8?B?dVJaOW0wZWRuOEZEOS9VWktiRjBWTTBEaTJDc3E4U0ovY2ZvZFVZUkNRUXRU?=
 =?utf-8?B?dG5kU1VLRVUwbTJJRTVJUUpIZVFhZWRnZkRHbGl2bzJ6OEE0aVZqcEYxQUpD?=
 =?utf-8?B?VnRscXNacmdRQXRwODFXWklYM3hhZi8xdVh4TURQM1F5M3FGRnlYY1ltY1li?=
 =?utf-8?B?c0dwQU9Lb0xHY2FPN3ZOZzV4NFkzT29jTzMyMENTMmhtOUJybmNIM1haSnc4?=
 =?utf-8?B?V2xoSzArUzNwSU1adnplZFRVUjRXRVFJdjlFaU1IdEFNZXczQnJwN2gwaHhm?=
 =?utf-8?B?aEVzL3luY0pmQnY4YklFSEZsZDlGdGF1UWk5bXFGbWd2eWQvM1VVeFRGZXQ3?=
 =?utf-8?B?bk9wTW1KWmxaMzFIbDJtWklHdWRZaGhqekNHUnZUbTQ4NnVRbVVQNDVOMUp4?=
 =?utf-8?B?WGtTRjdab3RNa2RSUkJjOFFKam5yZUtQT0xIYXJxNUhSN2ZFaytHSTdNQ3pY?=
 =?utf-8?B?QzV0M1BUL09sOTdObmtNM08rRkZUeUsvbG1mYzhYbTF5Q2NhMVFLUS9jQ2xk?=
 =?utf-8?B?U2dmZzVZS3puNTZScXF1OFBQd015aWxnODdQVHdpemZwZkxyRDk2TDRTcXAy?=
 =?utf-8?B?cmNFNUU3UGV0d0dMRjlvWTh2ZERRbmtYOE9EUEpYRjNMV2Q2dHJYQmdmVkZX?=
 =?utf-8?B?RXYvYlJ2bUdiQks0Q3MrWGRqYlQzdTJieFVZUTg0NGxtN2ZFZTZUdXZOZnBj?=
 =?utf-8?B?TmlkaUJLQUN2Z1VWM3B0b1pHREtVZXVwNHd0NEZuMXhDOTkweWZFMzViQlVr?=
 =?utf-8?B?SnhqL1hyeldneHArV3dPR2k0bVVRVTVEMStUK0dpQXQ4Sm1jYVo0VnJkSEh3?=
 =?utf-8?B?UW45OHg2Tk5RekNVcVBzZHdJMG55WVlITmhabmlSbDJvSThERHdYNjhBRmJT?=
 =?utf-8?B?YmFtRmNoaDA2aXF6TXd0aHRlamJPdEs4bWp4cFdnQ0tRQWFiOUhzbGFxb1J2?=
 =?utf-8?B?dnR5RjJUUmcvRUM4c2VkclFCcm1mYnIrdlk4QUVIa1ZTZkwrZ24vVVFUTVZ5?=
 =?utf-8?B?eHUzUXJ2V0NXUzd4Nkt1Q1BxSTV5U3cwUEE3enZldFhSV0ltTXJJTngrbUtR?=
 =?utf-8?B?aXc9PQ==?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68c5b0c7-8d7a-40af-a746-08da02b323fe
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2022 16:29:25.4983
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IsjWDKfsxGJS36bqhwPW1DUYk+buh/7NKSL2Yzdcov5IOGAveiSVeTrXIXaWwBdA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR15MB4688
X-Proofpoint-GUID: PNAVa_Qk_IPHItTAZR023DkzgzNCmlUY
X-Proofpoint-ORIG-GUID: PNAVa_Qk_IPHItTAZR023DkzgzNCmlUY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-10_06,2022-03-09_01,2022-02-23_01
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 3/10/22 7:53 AM, Hengqi Chen wrote:
> Fix the descriptions of the return values of helper
> bpf_current_task_under_cgroup().
> 
> Fixes: c6b5fb8690fa ("bpf: add documentation for eBPF helpers (42-50)")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Hengqi Chen <hengqi.chen@gmail.com>

Acked-by: Yonghong Song <yhs@fb.com>
