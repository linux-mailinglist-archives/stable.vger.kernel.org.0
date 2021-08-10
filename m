Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D0583E52A6
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 07:17:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237183AbhHJFRc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 01:17:32 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:48840 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235424AbhHJFRb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Aug 2021 01:17:31 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17A5B3N3010431;
        Tue, 10 Aug 2021 05:17:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=8KuevLnfnKS8OJsA5HeGFwqvJ5fsRD3A8Bk9muDxQEM=;
 b=Rm5nW2rSOlRs2xtZyQOI02aQApCGvEcecUIctaYCZ4csE/ChuoXaeGrqBHKSXeSnv4U4
 WDdU4c/OkPbilYXVqyPALK3UHrgG09oKIIfEFd7lTBvV+O3lzP/XM8FLEa/m4yvdkTOs
 uoXZ/NrBJHtbQZ1r1CwYQ4jimGqMbWVw/9mDp8pVhUvnRyjKG7pCJ7X+3/lcBB8qoGlc
 ThRrGVvB8VYpaaIivbNMbMec27v9Ikn5pvE34g6GluZi9hQHeRWcIrXOETTnpajN4SVI
 Kau5gzIp/nfxlX4ae19PKf0jwZgT50aj+l5lq+FoPKc38uL5sPZjMnVkLJ6t68rKwqCZ 9g== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=8KuevLnfnKS8OJsA5HeGFwqvJ5fsRD3A8Bk9muDxQEM=;
 b=xo5CLFZIxBTJ3o/i80chZh79CYevgiI4u64QPoV387xsbiry+2RyLH4NVUiUHr3HiJNh
 bTHBgc0ipbd4Mp/rZcPLJoWxJ6Y3NdmqNh+8ks0amlyZRKKWnJgtCKPwCMDa1YmW3QsZ
 nNfYVIiH4dkA1w65UKNiTlbUy2BRLY37/jGaj8GZyjfgGbhEAx90+SeJKup1krHiVH7Q
 Xqo8qqS7bTSwgGA/o7K7nvI9uJ+lU4/K9aY8cHRAoNnhe0sqjiIPoDQYdpgZkKsVPt0i
 NgZtrXmqOHlPv7IfKgNmYWMTBwsPnIDSDUT6/i4NsXTXqfjEZtrYfEZtFamhWj2Z9Fel gg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3aaqmuu041-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Aug 2021 05:17:07 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17A5ALhV101125;
        Tue, 10 Aug 2021 05:17:06 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2102.outbound.protection.outlook.com [104.47.70.102])
        by aserp3020.oracle.com with ESMTP id 3a9vv42xmf-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Aug 2021 05:17:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hMb+tBDt0gL+T4tJ5+/j328ZU2P/L2/fXajNf+4a+nP8geztLVDFuEx5yV5oK2nUepVPYLab57uIlGjbC2rPXfUeZFmJYQdtlentJbuVOUhKBJyJbCah0jcUO/n2nVAj7p7SZABslOtHJ0o7aoAo2iEBrc7WSjTyyrMaMILVcEUzqfktgEvGUXGfEctPo1uOtuwvlwEhFQy2c3N4I9O1TzL/vt6wsDg0roLmE7EFVDoE3LbCjee30q4cl6E0V9CPO0nAbshCjPxAEXhtvcHVOpJP4+4+q8TFpkD3z+OxI/hldA2TOGUiF9i4f6yDf5AiIq0CvTjAAce1PgbDHSxo1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8KuevLnfnKS8OJsA5HeGFwqvJ5fsRD3A8Bk9muDxQEM=;
 b=OZeq278Xbvcq+vhRltTQfBAx75PH68MXc9k4eCOHJTGIQsJsl5Rt1Ox38f7y4OSLHGQy6Dv/QjmZvYirhATpdVSSvOEAm5hmYoVFaJKrd3HRwxqsCMxALW6h2FxdyH5OkPYdNEdfq/3GOJZy18PkFCJMr2/16BqvWQEkP73f0oA8+SVyC4UeAXt2SLG+guDv95snFfCFd3N3QaHxKle+t8tEdCTqZ9296Wd66dMFlDGr5QnBWSJA/wiiSKFOiskBMJTiheEJDyJ1H118Fjx055f7iY4auG9hLLrygl++jwrEO7Jr0onseN84xZMz5UTBTdF17OAN6xH3Pn9Ks29g7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8KuevLnfnKS8OJsA5HeGFwqvJ5fsRD3A8Bk9muDxQEM=;
 b=axiAmfXtgV8aUfu49kbmcJob1NzwZgMZxECuZRf1DvoaH7dQcGxtVssMfFHCt2QQIBlequQG4Q7at7WmzGy4QttG3HByXb4kLX+p6JBXxWZhXwVweI6CmkTiHq5tqc7Bs1/0e0TI2pT/YITE6bxG/lUvw9tuZ4W9fDRLwm4G6B4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5580.namprd10.prod.outlook.com (2603:10b6:510:f4::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15; Tue, 10 Aug
 2021 05:17:05 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%6]) with mapi id 15.20.4394.023; Tue, 10 Aug 2021
 05:17:05 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, "Ewan D. Milne" <emilne@redhat.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        stable@vger.kernel.org, james.smart@broadcom.com,
        dick.kennedy@broadcom.com
Subject: Re: [PATCH] lpfc: move initialization of phba->poll_list earlier to avoid crash
Date:   Tue, 10 Aug 2021 01:16:59 -0400
Message-Id: <162857260239.5447.2919372898873792061.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210809150947.18104-1-emilne@redhat.com>
References: <20210809150947.18104-1-emilne@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA0PR11CA0112.namprd11.prod.outlook.com
 (2603:10b6:806:d1::27) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SA0PR11CA0112.namprd11.prod.outlook.com (2603:10b6:806:d1::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.13 via Frontend Transport; Tue, 10 Aug 2021 05:17:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ad7af629-1dd1-42fc-02bf-08d95bbe17a7
X-MS-TrafficTypeDiagnostic: PH0PR10MB5580:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB55804822F32362965BC738358EF79@PH0PR10MB5580.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pvz9e6yQRbGVcO2kwpvkaJO1XiNRRLwV0YzRbvFPWJeGsr3axSLeNha0MM/INCtnVtnMmoli2Q4uJD5edXi/bhxVsZNUw9NZU7fPf8J+7WTpzMo2roI8J5OuvgrH1iYr23c+tFbfLP6sdczsAsRwnfx9ZFeNs4HbnUCI2lm7CtYFF2Wbbfcxx/IBbpXjJcQmGaNKjXS3gvgQPjvGCf0SHvZqSjyZHn6ih9rbvTHCN6MaCnjacrsQS3ZHdwySfi4aLEc6IluSJ5U3yrLegankdBwcuO6e6ExSHreaVAdyRyCyRfqcUtpXQ1Q5hGuDqrn/17QZ15gXUlTUee8GAfti/3OwlOWWQ9XrNaB+vf/Vli08oGYoHQpEm82TDsld3hGESSoMKsuDfHXohfO4jF8tFTiF9VrzLssEo4S2Rj57X/wlHd3xJKeMcrtGvhQvJ1cqiKIQo3iMWLN+2ZyCx0KsWALj1Qu3MixNQXu9ZMc93Y8fx+fjHrR6CQhXzfF2sPNEn11DjwDEHvMtbDtftRVtYSLQXTWEd9GVJ86FDsDaG8rEDR6puLdfq27V3mMCnLaumxgbY7vgJAU8ns77qRE8LaYehX1heHQOvNmAVWS6v/wL47D/+lcpA2oxH0MbLlNpEYWTu6WWYZo0lEXBBg5O7UTBMWNpKHL7UCnGOj1qmbEKbL498KGHjWE1V4YfWj4PrYthdXD9LSY0GY9h9q9HyrBnkA+uAG29yIQNBj7RUBK9P9bAb93dknq5C0UHb+SmbVA2RmwJYpJKeMjGjZT8ETxA+qDE150VD4L9hxM6UfQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(396003)(39860400002)(376002)(346002)(38100700002)(83380400001)(8676002)(316002)(6486002)(36756003)(38350700002)(103116003)(2906002)(956004)(2616005)(45080400002)(8936002)(4326008)(966005)(66946007)(478600001)(186003)(6916009)(52116002)(6666004)(7696005)(66556008)(86362001)(5660300002)(66476007)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RzB2Sy9pMS9VcFJudUNmVUhpV1I2Z0hPQXFTOXdOcjROQ1IvS2E3UWdaV0Ry?=
 =?utf-8?B?elF2YTV4bVlqWnRzU0Uwck5PREc4eGovQXdycUdFeE8yTGtySWVmTk1JbTJK?=
 =?utf-8?B?a3pQS3pNK3pYeWh5Q0ZsaktmTWZ3L0pidU5BK0FsOUhKVEI3OU1lTVRJSnBo?=
 =?utf-8?B?NzlTc2U2VnhVVDVjbzNYRkIrK3RWM25yeXd4UkFiRkJEak1mVFR0ZkZlV3NX?=
 =?utf-8?B?dFAyRCt1V2RmUFFwK3lwbUVvRm4rTFovTjc4dEFweUpJSzJTR2FyOXR2dzBP?=
 =?utf-8?B?YnBMWW1NWXZ6NkljWUl3dThFdWNlWGVhM1Q2b0tSbFRPOUxtd1pJYXlrUUJ6?=
 =?utf-8?B?WjFucHNmOXNPSkovZjIxdFVFZzl5cWFzbk5aelRwQzhyME12V0lPKzBOMXFu?=
 =?utf-8?B?QitRNXJFbUNEdTlKZklSZkVoVjNVUkhYNERLODJtcFBycHRrTFJ1RUVCZUtv?=
 =?utf-8?B?citwMG1SWlFvMktHa3lYRDhodFJrL3R1S09qT25mVnlkeGkwTjhYSE5kYjlv?=
 =?utf-8?B?dWNoZElvV3FucXhLQ2tnR29JQWhCdTdiVlFJUEkxV2tBSWFKL3ArSFRBeFRF?=
 =?utf-8?B?am84RUIrWk0weVVYQ0sxclJYNktwbkhFKzlmbUZaRWt3ZUVERjArVGoxQm5D?=
 =?utf-8?B?SGVrVHBRTUR4Y2FvejZGZ1FCVmYra1dUSVE1RFJlNGQ4WDdBb2pXNGp4anh1?=
 =?utf-8?B?R1pSV2E3RklRN01PbGUxbWZFRUdZRlc0bG4zQURuS3BWeW8xSi92SXF5am1m?=
 =?utf-8?B?RUhrU1BKZ3ZKODhwSkhET1RNdUw3eFIyeTZwYzVvQnBCYy9FdG12eHozQTho?=
 =?utf-8?B?Q252WENpcU1jVzNqeWYvNVhNZW9yV1ROUmhLMmlzTVRXU1NPQmNnMys2TzRU?=
 =?utf-8?B?ZXhUeW1PN3F1Ym4rN05XVzdrVWJGZDJKMDZjc0xhUnNDMWZZOW9aTTE3djZT?=
 =?utf-8?B?VzQrby9kQWR0bU9iZjZORHlXVmpGWkpxRytPNDVRQ1VZTlhvRlo3ZVdHYURV?=
 =?utf-8?B?RzBXQVN3bStCOFhwN0NXc0tqdmN6K28wQzJ2Q2VTeGkrUHpIZGRFZU1sME5G?=
 =?utf-8?B?YlZQZm9HRmxuU2lKbmxVc0xxRVlmOElUcjlJWXRWWFpBZWtwYk9Ob2VrRlBG?=
 =?utf-8?B?SzRFVW5FSnIzZ3kzTG5SYUF5T0prdVFsNHBqNWZDek5UdksxdjRRVjNzZ0hz?=
 =?utf-8?B?TTZ3bHVHNlBCK1lIbXBFdzZrQUdwc05LaUo0SmRwbFNnbS93ckN0UUVOSnhV?=
 =?utf-8?B?Q3Z5R0Fob1Q4TjdqUUpnMytjTEFJMGEyQnI4bE96dTIyVWgxbzJJS21qR1M0?=
 =?utf-8?B?YXB6OUY4RGxuSVZyelhyMkFkdHZCTnpDUVZpaVdqRFVBL1NKWEd1Y252WjVV?=
 =?utf-8?B?VGwxUWw3eEM1d0pEaEtsVG9lb2F3cjZxcG9kNCtFZDBkOUVzU1FxamZWMU1p?=
 =?utf-8?B?YVFnU3Y0eGpVeTU5dlFKaURhUTlheWhzbUpxZzVnZE9DNDhuZUc1L1hWWk9y?=
 =?utf-8?B?UjBRa2UvMVFFeGZoeTA3Q05NREZ2aUVqbDA3T0JRdjBZV2RxeFlYNjROY0h6?=
 =?utf-8?B?bjVqeTlNbVczNmoyWHU1WXJEYXRVSGJkSjFVVHR3SjI3bTlsOGZxQTIvYmlz?=
 =?utf-8?B?aWhXclFEamdob0pJQlUrRVRwTDlKdUg5QmpjK1BGZHYxWURjd292Nld4aHRY?=
 =?utf-8?B?NFltMVFkdUF4bFVBVjA4TEkzK2NlSXdLTTVZdFYxTUlyelpveHFFNW1SR1lQ?=
 =?utf-8?Q?KlWG9TmO+Va6JSBmSV7UAni7l7gJNF5s9X0hkkm?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad7af629-1dd1-42fc-02bf-08d95bbe17a7
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2021 05:17:04.9943
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JwiVx4q3ovq+kbEmjzbpDXxksceX51mOXOr60BwR8HtBzuOOaBSCBWOyPYkTUnoSQWDTkjbdzO2rrghkxyRBf/QL2pAt1a8wgefH+V30Ung=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5580
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10071 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 mlxscore=0
 phishscore=0 spamscore=0 mlxlogscore=802 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108100033
X-Proofpoint-GUID: MTtxqUdYM4pXayhpqcDT7XuK2HFFL1Ik
X-Proofpoint-ORIG-GUID: MTtxqUdYM4pXayhpqcDT7XuK2HFFL1Ik
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 9 Aug 2021 11:09:47 -0400, Ewan D. Milne wrote:

> The phba->poll_list is traversed in case of an error in lpfc_sli4_hba_setup(),
> so it must be initialized earlier in case the error path is taken.
> 
> [  490.030738] lpfc 0000:65:00.0: 0:1413 Failed to init iocb list.
> [  490.036661] BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
> [  490.044485] PGD 0 P4D 0
> [  490.047027] Oops: 0000 [#1] SMP PTI
> [  490.050518] CPU: 0 PID: 7 Comm: kworker/0:1 Kdump: loaded Tainted: G          I      --------- -  - 4.18.
> [  490.060511] Hardware name: Dell Inc. PowerEdge R440/0WKGTH, BIOS 1.4.8 05/22/2018
> [  490.067994] Workqueue: events work_for_cpu_fn
> [  490.072371] RIP: 0010:lpfc_sli4_cleanup_poll_list+0x20/0xb0 [lpfc]
> [  490.078546] Code: cf e9 04 f7 fe ff 0f 1f 40 00 0f 1f 44 00 00 41 57 49 89 ff 41 56 41 55 41 54 4d 8d a79
> [  490.097291] RSP: 0018:ffffbd1a463dbcc8 EFLAGS: 00010246
> [  490.102518] RAX: 0000000000008200 RBX: ffff945cdb8c0000 RCX: 0000000000000000
> [  490.109649] RDX: 0000000000018200 RSI: ffff9468d0e16818 RDI: 0000000000000000
> [  490.116783] RBP: ffff945cdb8c1740 R08: 00000000000015c5 R09: 0000000000000042
> [  490.123915] R10: 0000000000000000 R11: ffffbd1a463dbab0 R12: ffff945cdb8c25c0
> [  490.131049] R13: 00000000fffffff4 R14: 0000000000001800 R15: ffff945cdb8c0000
> [  490.138182] FS:  0000000000000000(0000) GS:ffff9468d0e00000(0000) knlGS:0000000000000000
> [  490.146267] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  490.152013] CR2: 0000000000000000 CR3: 000000042ca10002 CR4: 00000000007706f0
> [  490.159146] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  490.166277] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [  490.173409] PKRU: 55555554
> [  490.176123] Call Trace:
> [  490.178598]  lpfc_sli4_queue_destroy+0x7f/0x3c0 [lpfc]
> [  490.183745]  lpfc_sli4_hba_setup+0x1bc7/0x23e0 [lpfc]
> [  490.188797]  ? kernfs_activate+0x63/0x80
> [  490.192721]  ? kernfs_add_one+0xe7/0x130
> [  490.196647]  ? __kernfs_create_file+0x80/0xb0
> [  490.201020]  ? lpfc_pci_probe_one_s4.isra.48+0x46f/0x9e0 [lpfc]
> [  490.206944]  lpfc_pci_probe_one_s4.isra.48+0x46f/0x9e0 [lpfc]
> [  490.212697]  lpfc_pci_probe_one+0x179/0xb70 [lpfc]
> [  490.217492]  local_pci_probe+0x41/0x90
> [  490.221246]  work_for_cpu_fn+0x16/0x20
> [  490.224994]  process_one_work+0x1a7/0x360
> [  490.229009]  ? create_worker+0x1a0/0x1a0
> [  490.232933]  worker_thread+0x1cf/0x390
> [  490.236687]  ? create_worker+0x1a0/0x1a0
> [  490.240612]  kthread+0x116/0x130
> [  490.243846]  ? kthread_flush_work_fn+0x10/0x10
> [  490.248293]  ret_from_fork+0x35/0x40
> [  490.251869] Modules linked in: lpfc(+) xt_CHECKSUM ipt_MASQUERADE xt_conntrack ipt_REJECT nf_reject_ipv4i
> [  490.332609] CR2: 0000000000000000
> 
> [...]

Applied to 5.14/scsi-fixes, thanks!

[1/1] lpfc: move initialization of phba->poll_list earlier to avoid crash
      https://git.kernel.org/mkp/scsi/c/9977d880f7a3

-- 
Martin K. Petersen	Oracle Linux Engineering
