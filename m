Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CB3135433B
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 17:16:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237729AbhDEPQb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 11:16:31 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:56494 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236175AbhDEPQb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Apr 2021 11:16:31 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 135F8kql129860;
        Mon, 5 Apr 2021 15:16:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=1E4dRrQp/Ppx5b/XxbdCQRr/KVGa6JuHR5EpDWyFPec=;
 b=i4FsoMmMA7CpRUjypKSY0gXnVzCy87Kzw1I2V7qfrBrAu73P0LSeOJFdvRdiqxQi5sqg
 pJ6AMBFytr2q7/KxDkMCsmEAPN/iGD+zdYPcD/DRerVU0FOjC6GzQJwJsdK3NJC3ozag
 47gKnFkXTajvAVYH0r0lBgsKprTMgTz42rQytRSkX14SdS+q1p4eCmZ70q7HYVDoERhQ
 3RpBTHqnTVXn8Ay29h2Z/X2hgDMuBVd8pYZm4ZOVlFA7TQgVEu3bbQc0+J54r40V7puZ
 p08xcA1BXErLhOEP/+5Ef6jq0viuxCnHOu0PqsWq/sr38/DOLKdojD/RU1iOeqyw3jr9 NQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 37q3f2ad6f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 05 Apr 2021 15:16:24 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 135F61pr058312;
        Mon, 5 Apr 2021 15:16:24 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2108.outbound.protection.outlook.com [104.47.55.108])
        by aserp3030.oracle.com with ESMTP id 37q2pbc8hx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 05 Apr 2021 15:16:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eET9fvBOjBFlac5bpo81q5ECKSMJm1ytRAYhYzT7U/KoUs5eJEpZKwcYBoksPjHZwNixz2Wh3F7wZngm8F9JfWHE0tsRmLcb909/TAhm7AxpGAOpjRTsDtIlo7pa0TJme6ax18oVWJwrVR4YXlP+3ns3pqdlJ5FeB3B9UMLyzFD64rKRp/99Zekge1eZIkH2DNee323yIps34soSiqFdSDKGZRfvm8OX/4KL9iQ6Z4azkHpBMZ+R3YSqOwhrF4izQ4DNNS3tFmUOecfZw5u2/BCqVsoeYhZUMMwha22z1RFD7I7SfNaBruT32LMOniFuHTFk5uZa+kbbjia6Nz4guA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1E4dRrQp/Ppx5b/XxbdCQRr/KVGa6JuHR5EpDWyFPec=;
 b=Ljrqa933mK+47EZdoU/zYcPod49WaAiBA2hQpb5WPM0Xx7puxRkiQxnbzxZ3oyCtXOwoPaHy3AsZWc9BV39toYBqpUFhPuuWfYV1CHwGJUd8D4Jl00bJi2S8G3j/VsFzx8jf4LWC9UHSvgHdJQn1egbFjZMnshJGLFwFFaY0X5wB8NgLZHxBAY8mYeSQy3xS6aZOcTOMfkvFHBaG9sxyjD6uC5RQB31Dt0nEML1+l+enGFwcMktNP920fYUEH274gH+OPv6614ioNCu5RaN0IZkpbVWlSX+JtiRxwBSG50L49YHoRFG/YIe8ff2CL33YdEunUpXhIURneKgtpHU1qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1E4dRrQp/Ppx5b/XxbdCQRr/KVGa6JuHR5EpDWyFPec=;
 b=BZFSo6DS7VMYbHdf+yB+p3t7LaNT1YoOiHJ7k5Pc5BzqM8QwscjomqBo7Hi0qrW8eMoepMahc7byOKjvBCbjXl+X/VyuCPG9WRTjZBC+B2Tlx/fY286z0ErmCgUHNkyn/dtUnVQSkUFPZMOfMJsM7i0ujcTf7RgNlqDdFdqrGyE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by SJ0PR10MB4480.namprd10.prod.outlook.com (2603:10b6:a03:2d7::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Mon, 5 Apr
 2021 15:16:21 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.3999.032; Mon, 5 Apr 2021
 15:16:21 +0000
Subject: Re: [PATCH] target: iscsi: Fix zero tag inside a trace event
To:     Roman Bolshakov <r.bolshakov@yadro.com>,
        martin.petersen@oracle.com, target-devel@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org, linux@yadro.com, stable@vger.kernel.org
References: <20210403215415.95077-1-r.bolshakov@yadro.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <641b798b-5f65-997f-ef8a-fea07a764edf@oracle.com>
Date:   Mon, 5 Apr 2021 10:16:18 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
In-Reply-To: <20210403215415.95077-1-r.bolshakov@yadro.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM5PR13CA0025.namprd13.prod.outlook.com
 (2603:10b6:3:7b::11) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [20.15.0.204] (73.88.28.6) by DM5PR13CA0025.namprd13.prod.outlook.com (2603:10b6:3:7b::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.9 via Frontend Transport; Mon, 5 Apr 2021 15:16:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fa7c3a84-cfa1-4b77-3b85-08d8f845c4c3
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4480:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4480F89C03D3D11CDE84476DF1779@SJ0PR10MB4480.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w2Y4LWsKbOgTo+ivkmtbJkMzXZJodTPorsp6B0B3DQ5EZauTQYEysVFDYWu0V2MsQOyro2wjTPXeBp3OyquAuFF23IwzpWgV+ig1u80WaSSaK/ttqHwqPg21CrjDUjsaDBFjutMxTWvT5lbFFXlZaT81DiMn86bsxw3ZZEuhCxtfic92s7rICqCjs6OwEQYNKkMLkYflUGc+f5KNrt1+pzStdSIKtN/3/VSB5DSJK8IALP5yC4zf0/zKkb/gBL26o66+xI1GimJAo992Sk3S+P1LFt2Ax6gzTuTf5tehfinFzYXkHtzsiCtdoGdHbmj5h871fRuZvnExou/3kmJksz+acdKSGNebDBMvWdbmV68Dy5W4ZfiRy+dqvQYGAINW7W+RCFMZxE5G/+yhJhL260s/T1xtFV4KyQRUzrCAXKbCABO0p2Yl+xpEKtyq/Gto1d0/Nylzi3e5D9nd2ap5Wa70o9U/DrO7giQQxh4O2/bQUbp1NGJIcD9lDajoU1vJUIiQZb4OPs5AK/Gy9Q+ZwreG4kRMPwUzyWMpbrjWEQrGFmWWe/4Id4xyCLl+fz8uUoCSICOZZh/WBIsluUbAJgm04UVUQgrgV08nMCRbG140hZQekycpDJLZq2bEbWhRYMc/7T/WRmFiYeuNoQfb1Ib8r2lSlv0RT3DqC+Na4hNGnNsaq/SGucAE1FfBTX+Elrpehf82EmjHcdT4jUiKmgD11eBSr5N+N+PrM68JqRC4H//3Oq1s/KP3b1JTjFi/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(396003)(39860400002)(376002)(136003)(16526019)(66946007)(66476007)(38100700001)(66556008)(31696002)(6486002)(31686004)(316002)(8936002)(4326008)(36756003)(956004)(2616005)(2906002)(83380400001)(86362001)(8676002)(53546011)(478600001)(5660300002)(26005)(186003)(16576012)(6706004)(78286007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?SHVvZllsM0tnNm1yN3B6RlNpZ0Z3SEdFVCtabTRPVFF6ZUhXTisrUE9ySUV6?=
 =?utf-8?B?VElQbEgyNlI5U1ZHWGlEdVJ0RGRZOWhKY2tQMkpxdWllQzR2QmdYL1FVZGZs?=
 =?utf-8?B?alY4ZFVvSjJyU3ZqTjRyNFJZcjROZjBnb2ZQRldwc3RnWDlBMjNybVVNQUZp?=
 =?utf-8?B?NDdFcFZlVGhtaGo2eWtrV25vVUhwR0RXdXBwS3NhcEgzWGVqaDA2TW1ocDRh?=
 =?utf-8?B?eUJmZXlXMndjakRjekxNV00rMkNXbTJqUWNpcEwyRWhnNW92Q25ITmhTTXNm?=
 =?utf-8?B?RjErUmIwalllZVZJaEoxUnU4ZUtrOUJ6WFRVWmdZSlNPVDY1NVV0djVWUXlC?=
 =?utf-8?B?THJBV1NBeHI1OEtpQlVNT2p0cVZadTl1L0dDTGRsN09OajIvMFJvZytLUnpq?=
 =?utf-8?B?L2gyTXV4Vno0YTlGY01XY0RNNkE1dzVMcWdKWHlxY1lSZVhONjRVYU9TTHAr?=
 =?utf-8?B?QWgvV01mQjNlOTBkbDFMVFliUVlZNTFzYjJwRFhGUlFLRmxZMlR3cjVsV0U0?=
 =?utf-8?B?SHlHVDJEUlcvSHFEcEhjVzVIb1Fvc1Z4VVRrR2ErK2FKSzJoOVFuZTZia1Zk?=
 =?utf-8?B?Z0hOeDd0ZEE2b3FWLzlsMmZBVFpYUWNyNXRIdjFqUHFsdmRPUndLQ1VIdFpm?=
 =?utf-8?B?UVhDRVBhZHpHSXF3NjFzWnJrekM4ZDJJdHBEY0RWUWJLcXBOTzlSbnlrQzdy?=
 =?utf-8?B?MlFIRm4rTWR5bWZ5SEU0OFd6aWRGYlRNYmduRGlGL3NKU2R3M1lMQXRlVWRt?=
 =?utf-8?B?ZzlkMnZ3bnZjN0pId1pRQUl6MENDUmt0VThVNEkyYU92TENDYTdRSkpqR2lj?=
 =?utf-8?B?MzcxN2hUMU1NbW1yUnpVdGl0Z3phSGhLRk9YRDVtcGwwcjdFSHU3alpLVXZv?=
 =?utf-8?B?MFpZTU92QmpuOHNNTk9kQ2VVUVUrSUtEcnZjWHg3Rmc1bmh4S09ZMUpUd1RM?=
 =?utf-8?B?dys3K3k2TjhRK1JKTzI3T3JQdDBTaU5naU5nOGMyWWlHM2R1Z3dOc0g2dHpX?=
 =?utf-8?B?N05rNnAzN3dRdXJsMzl5eUo4NXJ0dmkzQm00RDJRUVIrNFZjN2RlcG9LZ1R4?=
 =?utf-8?B?ZWQ4U3RQS016Q0F5bEJWdStiN2s5Q2tHWWZva0xhazVFUFJqVHowQkREN1VM?=
 =?utf-8?B?MWRqTlBuUVJCYmdFYjU1SXZYblRLNFJCWDM3Sy9PK0F1aUZWcUhlY1Ixd05Q?=
 =?utf-8?B?WmFaeW9jMTd5U01jWGxrdXFpTGFGTkxUMEc1U1hrUSszSXpNYU94c01takwr?=
 =?utf-8?B?aXhuTW1xOGtYWjh4NkhKSTcwcGJ4bWZxT25Mb1NSTUR3T2pocnlFeUlxOHpo?=
 =?utf-8?B?QUxneVdkN0lXNy9XOXdwMG02SFBLSUhSbzROOUx3SGtQc1VHMm5iSkJ2S1dC?=
 =?utf-8?B?cG53S2IzelRJdjRKQzlEQmRSZXNDMnJqYnoxSDdjOVErZlFjd0FmUzE4RndJ?=
 =?utf-8?B?VzJhNGZXN1E1eUt6cVl6WFprdWRJVHVJMkF0WjlYT1piWFBhdHIrd0RCZGNR?=
 =?utf-8?B?WDZha2hOa3VPZVN3Z2xGSEpNKzVhWkYvNjdwUUJtbHlRdytENXhGTnV6cXdq?=
 =?utf-8?B?VzdxeDFoZlk5N2lBU3drREltUGwwc2N2WUNaYklpeEt1Sk9MTXhkK3dkNWRB?=
 =?utf-8?B?TEJLSjJpN2QveWtOYUIySTJZaUJkenNCamtsRENhNUZvb1p6VWl1RlhjbGdy?=
 =?utf-8?B?R2lZZENST2MwMFlkRGpuK0gwLzNIZ01JMGJ1UVBsam15MXRWNWx3cUtqWnor?=
 =?utf-8?Q?hZIQqcHFNDFlplaa/oioLRiGZRnuQ8vWo9gWnR+?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa7c3a84-cfa1-4b77-3b85-08d8f845c4c3
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2021 15:16:21.2844
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /g3/Qa5+FoTcG0GUSucVuKUQfxod1rDtcaoWxKktAZ8qKsTjNi7qa31ZU1AhMpbRXDJVVBN7AU6Lym9zYFJKZmSAHeeUFgFE1RzRDHPkI08=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4480
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9945 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104030000
 definitions=main-2104050105
X-Proofpoint-GUID: hTfUGk4sRKt6eQCndqxks6nv5mVDgt-U
X-Proofpoint-ORIG-GUID: hTfUGk4sRKt6eQCndqxks6nv5mVDgt-U
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9945 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 suspectscore=0
 spamscore=0 impostorscore=0 mlxlogscore=999 malwarescore=0 adultscore=0
 lowpriorityscore=0 clxscore=1011 priorityscore=1501 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104030000
 definitions=main-2104050105
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/3/21 4:54 PM, Roman Bolshakov wrote:
> target_sequencer_start event is triggered inside target_cmd_init_cdb().
> se_cmd.tag is not initialized with ITT at the moment so the event always
> prints zero tag.
> 
> Cc: stable@vger.kernel.org # 5.10+
> Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
> ---
>  drivers/target/iscsi/iscsi_target.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
> index d0e7ed8f28cc..e5c443bfbdf9 100644
> --- a/drivers/target/iscsi/iscsi_target.c
> +++ b/drivers/target/iscsi/iscsi_target.c
> @@ -1166,6 +1166,7 @@ int iscsit_setup_scsi_cmd(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
>  
>  	target_get_sess_cmd(&cmd->se_cmd, true);
>  
> +	cmd->se_cmd.tag = (__force u32)cmd->init_task_tag;
>  	cmd->sense_reason = target_cmd_init_cdb(&cmd->se_cmd, hdr->cdb);
>  	if (cmd->sense_reason) {
>  		if (cmd->sense_reason == TCM_OUT_OF_RESOURCES) {
> @@ -1180,8 +1181,6 @@ int iscsit_setup_scsi_cmd(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
>  	if (cmd->sense_reason)
>  		goto attach_cmd;
>  
> -	/* only used for printks or comparing with ->ref_task_tag */
> -	cmd->se_cmd.tag = (__force u32)cmd->init_task_tag;
>  	cmd->sense_reason = target_cmd_parse_cdb(&cmd->se_cmd);
>  	if (cmd->sense_reason)
>  		goto attach_cmd;
> 

Reviewed-by: Mike Christie <michael.christie@oracle.com>
