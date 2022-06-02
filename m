Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 125BE53BE58
	for <lists+stable@lfdr.de>; Thu,  2 Jun 2022 21:05:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238338AbiFBTEb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jun 2022 15:04:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238336AbiFBTE1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Jun 2022 15:04:27 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B42BD46;
        Thu,  2 Jun 2022 12:04:26 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 252IIXq1031068;
        Thu, 2 Jun 2022 19:04:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : from : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=BMlKV0B589TSN4tK97OPy1VfcGu9Zrux/AnHlVXTJpU=;
 b=XEUfRBw8oAjsIil4PHnTzpLcHWpfOAdFSa83s+4fRsw/CT8FpolZVLLNTXMp/CrpsmrQ
 axJ8hmdqjo5EI/jOZbCdsv1CpPJUXgKQYb3Y42RXt6svc72D5Oqhs1B1PSe8yRKs/YuZ
 +d6iRkwFvHV+cLX6TLtvHDpPeV7vXhsukMkuMk6krewwzMc6ET/blN+GragVTo/kCxve
 j/JzqkAMlRVtX6yE6CQPcZ4bCb0MgXdFFxJA7PsYSKzWlM/5Mvfxlb24L+drx5EUuWkn
 S5W/wEmVCeUzs/SqLXuTziXLkygmSoO1KGE5/OimK6GbOkE3mTFuLjMM0/4WXQGZTxdX aQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gbcauue9t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Jun 2022 19:04:06 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 252J1XII034745;
        Thu, 2 Jun 2022 19:04:05 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gc8k1qk4c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Jun 2022 19:04:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bz8GZx7AaxyEHzefSVyeFVMnNjnEIHNIY/Tm+BC6kBC8tBIf1DaID1KIpHGqjngk/+9wuOhA/CofFzad+/VNd+sozEAqsIcZtnpFsiyt5jvGNXsTekre4UiFxFBU/AEa8tiJAPWTJhPR8dRp4a7AB0F7i6T9HdBbEInKv13D3nArpWljHVjagOHrvIENRUVQM8xlDYmuktQ0mqcOH6mJBB4sz0JZvGYC79N///MfJF0sv96ASlLoCCQyCAoE0zcscIZhs7k3C5my3O1Ed9LcYfRzMLKiRbOR8lFhK1wPx+a32InfOfpx5xfPLGA3F54iHz0pvHEABUTScWybheNRwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BMlKV0B589TSN4tK97OPy1VfcGu9Zrux/AnHlVXTJpU=;
 b=Psu4pgWEovqTyQPRm2NBFjyFAJPedgrEs7z/yd+lmUB2sm7eAg9DMFRTrbs5FOn637z027xPQfExf75S+SENjtqEzqTQ9stU53LQNwBN3ghuS1ocLqm1TellPBbvEGzhXF+CJ3J8NUpUoeqM71DDt/HrRhVOvI2F6Ch5WAc4tvopGrr5CVFvzH1cNrgf787r/SgktgalHDwxiN4i6nrknfAeyoMOd66RZBhsFjSMMu8vht2wWc+VXVQY/lOIXAu9LDKBd2LI5lBFsqFFNqV8lmiFzBmL19T0W9AkXQM8Knt1Vdqre7Kwq3bwfjmpGtiYwtexF+H0YJy4qrmdjWnC5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BMlKV0B589TSN4tK97OPy1VfcGu9Zrux/AnHlVXTJpU=;
 b=yfuvJ5JxhAZiAGN6USCAxCQLai+W8nKT8MLC79RGQ3HIz+e2MSWFzXs1EBRkpmQz3ZfGWSh25ln0xqwuqgzziDsxRHPnGFqmEcwEX/VC6BgAtEpU1rUug8kLXi5GLda8Yf+pdzzDrRaCt+GjG1JFEXFLTJKrFCi+nHjFu8sSzEs=
Received: from CO1PR10MB4627.namprd10.prod.outlook.com (2603:10b6:303:9d::24)
 by CH2PR10MB4181.namprd10.prod.outlook.com (2603:10b6:610:ac::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.13; Thu, 2 Jun
 2022 19:04:03 +0000
Received: from CO1PR10MB4627.namprd10.prod.outlook.com
 ([fe80::8477:e4f2:ed5d:8cff]) by CO1PR10MB4627.namprd10.prod.outlook.com
 ([fe80::8477:e4f2:ed5d:8cff%6]) with mapi id 15.20.5314.012; Thu, 2 Jun 2022
 19:04:03 +0000
Message-ID: <b7d5e291-da6b-7634-efde-b0c745bef8e2@oracle.com>
Date:   Thu, 2 Jun 2022 23:03:52 +0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [External] : Re: [PATCH 4.19 01/20] nfc: st21nfca: Fix potential
 buffer overflows in EVT_TRANSACTION
Content-Language: en-US
From:   Denis Efremov <denis.e.efremov@oracle.com>
To:     Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        theflamefire89@gmail.com, Martin Faltesek <mfaltesek@chromium.org>,
        krzysztof.kozlowski@linaro.org
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jordy Zomer <jordy@pwning.systems>,
        "David S. Miller" <davem@davemloft.net>
References: <20220325150417.010265747@linuxfoundation.org>
 <20220325150417.055045556@linuxfoundation.org>
 <20220602161229.GA32444@duo.ucw.cz>
 <05a88b72-a814-1e46-4d77-c93fa6298b96@oracle.com>
In-Reply-To: <05a88b72-a814-1e46-4d77-c93fa6298b96@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DXXP273CA0014.AREP273.PROD.OUTLOOK.COM
 (2603:1086:300:2::26) To CO1PR10MB4627.namprd10.prod.outlook.com
 (2603:10b6:303:9d::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1ceef32f-f58a-489c-c6a6-08da44caa879
X-MS-TrafficTypeDiagnostic: CH2PR10MB4181:EE_
X-Microsoft-Antispam-PRVS: <CH2PR10MB418195A921862071CD71CB65D3DE9@CH2PR10MB4181.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yR51RcvCfxgxpJPXMR15jZMyqtINPwpLxmUj9Y7nMCb+gTPGkrZHWFrIvFBKixvge+LFGUI+8ADtKRGhPFTRyAtduwCuK3i4ZLeXX2Vo2dqMlFtOe6KAJiycjXaHhnOsvOFjvhYWfxza+/2UbMz6h5Ygsge+idmnP4BNiCSrbVvL5bPligJCxIh4zsvk//ay6ITwWuvdw+92r58KNv60GpYocKIjUaIiYYhAOcpDP5WfpkcECTvQeBe77lssfvSLHn8nqU5Bdfc/7NvBOKJoxGaHOZ8hKnR6QPGDL7yHNgye8SqB5RVgVsYPR4TtmyxLDxyw3Q1Z4ud9CCYWyNg4CDaEkZRs5X0q/5P302xDIrpoYjOjDvIFQ9zNXxp9v053oLq/JVBhbq3liUNfgZDUSqOy2mOgbWjbyfbU3b1rdGDX11RFpcQjmIwSfgn8CUwqXd+vi4GCwfC1UITKPlBBvXulbVq1F4MVNuqZWCy7PTCPknS3PiyAAGWEgwbfdSlNz2/1bG3E5nqba0keoZjcrnceO6McaPNDHHSoTA+jWi3PQqFguLiorS9MNboeDN3YDtxSz58OXqiyHBNszpvCZli9M0BdAJ9ZhcccraYZu5qMrhB0qw/lpvsPAk4ZzeJDrMO2nz6u5el7zjozGg/yqwNSSWXcVeV0gAf+PoixYjyShWrzglITcNRWuxFGJ3CjH0uK5fA5VWGtIZfLoXb+QtttzhBogBCmPJor/oxwblKz43/F/S9HTwRNbwY9a8+/gZaoqfV8/MCg9cACAlA/VR7zqqkY29Q8ug/1qp90gbwcLqoVdP4D5SNYRgpcsEN4rRlfbhBPlNqJnobZ6T+bukCSIDMR2PhwROmKr5fVMVk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4627.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(36756003)(186003)(38100700002)(86362001)(31696002)(316002)(2616005)(5660300002)(110136005)(31686004)(54906003)(8936002)(4326008)(66476007)(66556008)(66946007)(8676002)(6666004)(2906002)(53546011)(26005)(6506007)(6512007)(6486002)(966005)(508600001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UzhMZUp4OWp2WFlQdU0vUDlDU04wNU1pU1RtbDBCUmx1UzVjWWNPMHRIeVpk?=
 =?utf-8?B?Y3VUeGFQcXE2RjNVSFVHb1c5V1pPaVIycDFhbDhuMWY1TTBid3VZSjZaQ0Er?=
 =?utf-8?B?TlYrbXplMi9qbm1sSFJsakpYbGQvU2dFN24yckEvdU1KQ3JaUW1TRG1FMGFG?=
 =?utf-8?B?OXlaTVNFRThPSEtQR0VCaVBWNWhiekJkQ0FqQ0c4NDJyQU02U01kTlNsa1Zi?=
 =?utf-8?B?VWc0UlZJTENvREd5ZnBWRlpkb0lpbE4yVTN3QmxJaFVGN29uVmlGRFUyWG1x?=
 =?utf-8?B?YURCSHgrWWlRSG1wRkFJdk5hVDgwMkJFdDliS0hsQm5lSktpNzVBSWtiMWtx?=
 =?utf-8?B?Mkk3NUhNTmdxcXZKaWNtM0ZtNXRkbnFzcVNnWm4vYzY3QVFYSndzS1cyY0ta?=
 =?utf-8?B?NUczanM4b1BVWnZmR2NnelNyNHM3Z1FOeGRpcnBwb2M2Qm8yMWNQazBmNUpy?=
 =?utf-8?B?TUJ3MTZRUUxDNW9MTmZQZUFTc1pDR1JHMUtvcUluL2NIa09KYmZnZ2pxWjIw?=
 =?utf-8?B?WUpuQUZ2eFFjNC9na3BXZzVweXlrSm5PN09FNEhNeHhGRmIvR1RONVJHcGdt?=
 =?utf-8?B?OUdrdmRDc2Z3cmcwekZia3FQQS9udjhhUTFjQzJLSVlHRzdrUyt0NDMwWmhK?=
 =?utf-8?B?QXQ2MjBmd3duR1VndnJGeFBISnhaMW1qN0trSG9yTlErRFcxV1dZK3k1Rm9U?=
 =?utf-8?B?cHdhZi9zUWo2RFl3MHFCU1NxYi9qRzEvakVzdEF5ODYvN0xqVFRDcnVnRmN0?=
 =?utf-8?B?d0VZd25jdjlIUEw5SUxzcU45WE9YK3ZkUnlLQ3VFbVVxTEwrYjZLY2hBYjUx?=
 =?utf-8?B?emFhVEpWUkR1WEU5TVFHd3BvRHlCZGZmMS93dzhJaGZkcCtPdW00bFFVZXFI?=
 =?utf-8?B?N1VFTFJpRzIrSnp6bHBVZHhCTnRBM2Y0bkIxRFdWWlZiQWNZL21DbUxUN3Fm?=
 =?utf-8?B?bkhqSkN2eGNlRm04Y2hUbSswWXhoYVM4ajA5ZE13YXpDQmZvS3JXc1gzdmhS?=
 =?utf-8?B?Z1d5U1R6VFlVTUY1VE8zVGtFNEwzRDJBZ3Y3SkxZdnM5eThwSnV0QnZtbWJG?=
 =?utf-8?B?MldrclZKY3IrSVlKY3ZTa1hUQ1BYVVl5VHFoVXlTdkxoUmlIc3BDeFB4MGJP?=
 =?utf-8?B?U3NJdC9UZnUwdjNtN2ZIeHhnaTY5eGpuTkhzUTRLT2tISlhzdFNMUWVKWWZC?=
 =?utf-8?B?bkZKcmpMc1d6MVBBMFFpUHNORE8zakd4WFZqbnFPSWF4aUh5YWhxS1cwSWtq?=
 =?utf-8?B?bnBLMzJnZ2JQcm1oNTZMN05kMmgzSnJPcmtOMVpETXZtSkFIODVFLzVtRklV?=
 =?utf-8?B?cWpPUVhyZUFMc21Vb0dKRkJYbW5sS2d0NkpPcHZkRFlBcExxcGZrK24rZjhm?=
 =?utf-8?B?WndsUEh5R09TWU1LcGlMVmRJTVZFaitlZTB1cDAydFdtR2NRQTlBTWRMK1py?=
 =?utf-8?B?eHpqYUpodGJMc1pKT2ZDNnZoQVFid1dwWDVVRUVuQ0FlS2dQZEx1UUtkU0p5?=
 =?utf-8?B?SE1KVTk1VFZ0dmNWbmw5bzQzcVEvK2dqaE40KzNNVGRCZEtackd1Y0VDdFRh?=
 =?utf-8?B?aDZlbER1Q0EvRldES0JzT3BNWEJYekZjNGRsRDN6a0N0VUFZTUg0R1M0SlBE?=
 =?utf-8?B?eVhrbTZ1Y1d4QVhzK1BaMWg4SHNrZTBzRi9BNW0xcVJwaVhzTUtCSDhRN21X?=
 =?utf-8?B?R2Q5NFJkMFFsU1JLZlR3TytZdC90SVF6K0pYTk1ydnJhcjdBTzByamZmYkRL?=
 =?utf-8?B?Mi9IdUJ2T2hhM0Iya1hBZXcwWWUvMFBmb1FocDRpbEpRZ1R3TTA3L1VZeFI2?=
 =?utf-8?B?VXFPNHFiTDNJdDYya0xTcjFyc2FZckp2UVcwNlE0WVJqYUJaemNQOGtBb1Q5?=
 =?utf-8?B?TmJVdUI4aXhFZG1jR2I0RnEzRkxQTHJ3c0lYcEdVTkRuN1hISDFTRHJjQ3pP?=
 =?utf-8?B?RHdWRVJPeFFxWFcxNGtRRnp2TDNBc0ZsT2hqajA1bW5vL0FYL2owczZnRnJY?=
 =?utf-8?B?S3VYbkxWeE9DTCt3RUhaVStYMU5YYk10bitOZUtSNnNxYUdJN1Z1NjlKSjlp?=
 =?utf-8?B?V2hoQS9hUjJJN2k4T29rREdxRnNSd2JGZjVnZ3N5a0xqOHBCSmpYWkV1QWxZ?=
 =?utf-8?B?SUZ2TDZ4WjJub0pEZkdSN0NmRlBUZ1ZLbXM4SFBGVDlBOWxZTEVTS2w3Zkxk?=
 =?utf-8?B?cVNXdEx5L2JPcHVCYUV5RmlPdTJ1ZFFzeGJqNzJQTk5QOVFUZVlPVGxidllF?=
 =?utf-8?B?QzNZNUZqTGk2OUt3b0RldlV4dmE5YURhb1RLaGhiMW5TMCtsMmdxbzZxODY5?=
 =?utf-8?B?Vjl2VUxnNnZuaUsya3cvWWhEcHBLelNVa0E3YU5XYWZCSWhUbDExSGZlRnFK?=
 =?utf-8?Q?18Ft1RScB+hn4aHc=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ceef32f-f58a-489c-c6a6-08da44caa879
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4627.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2022 19:04:03.2137
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DPu7sYMoBVnJ1lLkNjtDID8VuEbdB9FWS2mWkXHCu0Dk8U7tMZvX+g2ni5togwoJfEAME4ElXTzuOO1rADmrsthXWeumTK6b1f2N1NiQwF4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4181
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-06-02_05:2022-06-02,2022-06-02 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 spamscore=0 phishscore=0 malwarescore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206020081
X-Proofpoint-ORIG-GUID: FsD8C0UCq7um78KcZzodNpclqnskPQEP
X-Proofpoint-GUID: FsD8C0UCq7um78KcZzodNpclqnskPQEP
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 6/2/22 20:30, Denis Efremov wrote:
> Hi,
> 
> On 6/2/22 20:12, Pavel Machek wrote:
>> Hi!
>>
>>> commit 4fbcc1a4cb20fe26ad0225679c536c80f1648221 upstream.
>>>
>>> It appears that there are some buffer overflows in EVT_TRANSACTION.
>>> This happens because the length parameters that are passed to memcpy
>>> come directly from skb->data and are not guarded in any way.
>>>
>>> Signed-off-by: Jordy Zomer <jordy@pwning.systems>
>>> Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
>>> Signed-off-by: David S. Miller <davem@davemloft.net>
>>> Signed-off-by: Denis Efremov <denis.e.efremov@oracle.com>
>>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>
>> It seems that this patch causes an memory leak, transaction does not
>> seem to be freed in the error paths.
>>
>> (I also wonder if the skb should be freed in the error paths...?)
>>
>> Reported-by: <theflamefire89@gmail.com>
> 
> Same for upstream code and it looks like the problem existed even
> before this patch. I'll prepare an upstream patch and cc it to stable.
> 

I checked and Martin already sent patches upstream to fix this.

https://lore.kernel.org/all/20220401180939.2025819-1-mfaltesek@google.com/
https://lore.kernel.org/all/20220401180955.2025877-1-mfaltesek@google.com/
https://lore.kernel.org/all/20220401181032.2026076-1-mfaltesek@google.com/
https://lore.kernel.org/all/20220401181048.2026145-1-mfaltesek@google.com/

Thanks,
Denis
