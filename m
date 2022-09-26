Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8D0E5EB0AC
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 21:00:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230298AbiIZTAl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 15:00:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230016AbiIZTAe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 15:00:34 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 704262A725;
        Mon, 26 Sep 2022 12:00:32 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28QHYQR6012821;
        Mon, 26 Sep 2022 19:00:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=ycT4s05UUQ6nJ8ele8aTLWQjmi80ojrt6fvqww6WR78=;
 b=BDOfsfus18bQC/KOXahtq8N/4WQZdSI9uuCG3wIHJt7Z/y4tPMtzLO7WDk5KGVwl2Qqo
 gl1+QNOCW8pE0BAypGGo3IFBbcg8aDT7btrt6is4MdSY2MeduIf4YIlmkkj2botoalVi
 4L7NNsLiu2fzJcXiR/i+zYn0rtFe7inRHoVccWBdyCeCDYR0GcluQe/sD5K8hekpeHoQ
 rl40PCLWX4m1ohk3Bfk/1isjE095BXop56gYn6EbOOly8N1PsLyA8fYKO3xbLqmATtt9
 6vMcKdXMlrmAqF4cOx4EBLyUVwIIGglrs+rFri9i2khbXzyW3qh2+Bj3uBqmH0UO+TjH fQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jssubckh0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Sep 2022 19:00:29 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28QHi2Mb027947;
        Mon, 26 Sep 2022 19:00:27 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2105.outbound.protection.outlook.com [104.47.70.105])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jtps4hej4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Sep 2022 19:00:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K5XX0aBQD+TEV9Hh327uXvmU989rgTLa8bX4mQUjUPWgm2qzSMijHyic30P7QHe5ISLw5bFn16cJu/510PhuttirUg0281Fdnpu013nrSq+x7m8EDVEX7kjwBTIG6rrjd0XfJSRnRTbWYM8Ot7Jz8O6o8dBfNNHITBAc0yYOV9KcSqboavBaecDCDg5WKfBB1Y75u/S2zSK/kq3yrStdsifHqD8QcoSqdPAWucU1eNCz74cP9dF6/Cuj8wTsYntSprx+IdxnpZxLdIO4XhtzHEe29U2f7L+pJZtPdMOgepblSS6y/pwQw0AfIG2ZQMD4ATJT5UqEaZG17AQXLtoIPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ycT4s05UUQ6nJ8ele8aTLWQjmi80ojrt6fvqww6WR78=;
 b=EAEHfTXT+FbPlpY9Jh19qA/WX3lHYmviZlagQevN5jkJgSNuPAJ3X1Z4rjqBAwkRsbjukMIpDZiwtb142NKIcp7FW+d7RRe2aI3mdKeZrnXryE6W7RVJ5SATckB3JXTuRY5lVQGCpg4/Lx+/NeHexcctKKAGsQuFdV/5J88KEV0WhOG811hEtvaRGsbb+rcvX0dkdsv90GlfiXYkdu0DxAGpywsk/s7fiUwCavwBm7FMBzVDD6mJ4guw+aw2omVVGbzkXaZkdyfqtDqReZIJfPWS9GmbE2BbIaZ4rnBRhLFnVoW3KyVnZXG9N1lhx12C1cS8afp2Jvq3KehEH6sbsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ycT4s05UUQ6nJ8ele8aTLWQjmi80ojrt6fvqww6WR78=;
 b=T6aq0HV1Qez8SSp4GC2O7/ICFPx+MKo9BhIUUnR/TUMSoP8xp/4TPCAn8t7iVvcUTrI4DRF+Glt8MFIFCNHoR5Zx15YO1cQPEzVrw8JD1edJL+3BB4nu2r9URuHbbRySHt/BLv7FtBAoPyVV4iV+wlqnZhS3B9oBCwNFLWm8r30=
Received: from BN0PR10MB5030.namprd10.prod.outlook.com (2603:10b6:408:12a::18)
 by PH7PR10MB6674.namprd10.prod.outlook.com (2603:10b6:510:20c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.24; Mon, 26 Sep
 2022 19:00:25 +0000
Received: from BN0PR10MB5030.namprd10.prod.outlook.com
 ([fe80::9034:820:1811:4ca0]) by BN0PR10MB5030.namprd10.prod.outlook.com
 ([fe80::9034:820:1811:4ca0%5]) with mapi id 15.20.5654.026; Mon, 26 Sep 2022
 19:00:24 +0000
Message-ID: <b0ff4fa1-db7e-2e74-ff73-4d6917b5bbfe@oracle.com>
Date:   Mon, 26 Sep 2022 20:00:16 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.3.0
Subject: Re: [PATCH 5.4 1/1] KVM: SEV: add cache flush to solve SEV cache
 incoherency issues
Content-Language: en-US
To:     Ovidiu Panait <ovidiu.panait@windriver.com>, stable@vger.kernel.org
Cc:     kvm@vger.kernel.org, Mingwei Zhang <mizhang@google.com>,
        Sean Christpherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Liam Merwick <liam.merwick@oracle.com>
References: <20220926145247.3688090-1-ovidiu.panait@windriver.com>
From:   Liam Merwick <liam.merwick@oracle.com>
In-Reply-To: <20220926145247.3688090-1-ovidiu.panait@windriver.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM3PR05CA0112.eurprd05.prod.outlook.com
 (2603:10a6:207:2::14) To BN0PR10MB5030.namprd10.prod.outlook.com
 (2603:10b6:408:12a::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN0PR10MB5030:EE_|PH7PR10MB6674:EE_
X-MS-Office365-Filtering-Correlation-Id: 5d00ee14-3788-49f3-3346-08da9ff15e4c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 69laHSJc0RgCyUcGCPu8O5H4QwlTdTiJvhPmvPNjD0GqZlq/BZmLqcyfjN5iUk4Ck6iKyqHJKI3CKTzNfqmod86OnKS9gTIYsm/Ll6VJl+1UTQ+KXK+e9XsD5On4XKSXHy0CqOzB0INrON/toK98ourt7wSluOZppOlAxW04HW+FjKimZTFbRumbhTqemq0r+NRNXmrJI+yFJLDM8Xiz6vX44fDYw9+5OmF0nrlv4BgP7DWW7JvaBMIwCl/q8aPwRdTiX2L/YMUkRkDnzCgvBv6XhzvBoz2A6EDfmrKQKMtYPXhdvXXsGpmbWVrgpiZDD3jk9XQO+rYTV7UC+ladUBja+WKqr6BfSYOKjvwdPKuT37oLv8jfDhlTUsI3UmrCLlymV9auCHRurKAJi7j4SOPXjap6JN2tETA4hqn+puAco5nKloNT7zzLXXU2YR4mTyrob2KRyGzCgGfeNr3RxyJ5fUcXG80E1EsJ1PhYP1Y0E76NUM1gfzZf1IxM8fRnsGwojdb36/EGzcZuogOLO79lhZm2Eg4RIPEJ/HNoObtkIPAGRdjlQ98JBQmVcRJhDun+8KvOYeW/hP5rnsKDrAP2VSDHow0lUtteB6ZPsZd3oYFbYEn41a0ePnKrTLsQ5olKA7vFh1FLvDvK/rGbZ+lIE/QbGqJ3fyr+C6PbKAckxu9WXYmqfKbj5XnHekLMQV7BYL/Zsu5v5V8pnO4BdReE9VYPMfHxiT4OQsxoHIoCzGnvcx2cwZZFphDVNmcJ/Rh3HtTQCtcqKw1HefuX4U3qYymzT5zAAJshTbF0D5Y=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5030.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(346002)(136003)(376002)(396003)(366004)(451199015)(86362001)(6506007)(8676002)(478600001)(31696002)(44832011)(186003)(41300700001)(316002)(8936002)(5660300002)(2616005)(53546011)(36756003)(6666004)(38100700002)(54906003)(83380400001)(107886003)(6486002)(6512007)(66476007)(26005)(4326008)(2906002)(31686004)(66556008)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y0hKMnR6M0dzb3ZjTGdlYlpyQnpCL2ZRTjRyTEszTVNGOXhwSG9EeHM4dHlx?=
 =?utf-8?B?MHRJenZFR0hybzIwZkpnVVNmVkJ6cnpvSXZtZURFekM5RVRKeUsyS3N6Vm1s?=
 =?utf-8?B?MzdaR0xJeXhSMTZTbGkxRURLLzQ2dVZmUWRkUk1RS1kzRkVKSkNWQmhSNU4y?=
 =?utf-8?B?ZWxBTXk2SFFvRVNMRkdnN1VpcmpLYUcxTVBDWDU3RmxxWjdub29kM0Y0UXQ0?=
 =?utf-8?B?UHJzdUpxNXdPWGJTL2dGMEVmQTVUaGplUnIxTFhxaVlUbm43S09seEtLSWMy?=
 =?utf-8?B?ZUZZN1A3OWJkaVdNZjNHUVM5ak9HaURBYmpMUytMSkpTUjBOM2ROeEJCd1FT?=
 =?utf-8?B?ajc2RjVrSGl4SHk3QlJxL1laMHdOSGxoVVpZWUxxVVpDeFY1a1h6czRPb2x1?=
 =?utf-8?B?VW9QVW9QRWtRN25pTGYxWSszU2NHV3FId09BVVlmV0hPRmhLZW9TdEdheU4x?=
 =?utf-8?B?cUJ3VzJNTkFQc1JvSFJ3TW5uMUNQOGJsQW1oYkgycGpCRjZ1T0dZaFV6bTUz?=
 =?utf-8?B?MTNVNzNrUllINW53bGgyRkNWa09kL2dqN2FvYmt3QlBOcVV6WlpyT1F3MmlS?=
 =?utf-8?B?R1pNSGxyTjNpVk1GbmlwZjNmRXg1MGtrWU5GenhxTEtkVFUySUxSL2dIUGwv?=
 =?utf-8?B?ZFN6QWtZQ3BlTnZPZHpCdXgwYUs5bXNiVEYyWjZoc1E2dHFTNVN1ODJwcHp4?=
 =?utf-8?B?cDZBZEl3d0R4OEppbVlFeEtGcDJWRVRUaFF2b24ya1V3dGNCNThCU1Z6dXhu?=
 =?utf-8?B?Q3lmQisxVHVlVjJLSEJibm5WWXJCUDZEbmt2UEpFd3J3TnRJS05ZTlFjM0dP?=
 =?utf-8?B?Sm8vSWF0bnluZWFQNkMwRWpHcm0zcUw5bXJhTlBzcXF2Y2RPa0oyaDIzRG0x?=
 =?utf-8?B?MGFYbUNmRUhmb2E1TEtKclYrQkVxRFZyazJhQmtFWktINkIyTnZITC9Xekhw?=
 =?utf-8?B?QUQ2eU1SeXRLUmpLSWNQRyswandocks0ZXlyaTZtRVVnaDNPUG1GRHY0c3FQ?=
 =?utf-8?B?WGNrYkhxc3lHZlA5eVFZZ05NVm0zYzNrYnpUeHdRV0lQV1FGSExldUpBdG96?=
 =?utf-8?B?UjFaaGRCSHRUWDZpeWF0cHgvMXpjYXVibHVGYjVzVytSYU40K2Y1cnczVkdC?=
 =?utf-8?B?MmdSUkVRKy9MbWliWjFiUi8rRGdEVDVQanNPNms2WWpRYjIrSFV2b09uTnI5?=
 =?utf-8?B?MnVQY2tDeDNRaXBaUWh2THhncng4c21SWXgrbCtQbHE3WmFuUmh5eHBXVU1m?=
 =?utf-8?B?VHZnbXBLcS8xdVg5UTlTSzRhNHpsc1dtRDB4SEhhTWpRNkxEZGhCWFhDc0RV?=
 =?utf-8?B?NWUxWmVFSXBPb3NmYzM4VEZDcmx2Y3owT1A3c0ZGQU0rcXYwRXpLNzFPM0ts?=
 =?utf-8?B?emRsZmcwTWtxemtjTnBZSGNHTmVoRU85c3Y3UzZxNEZXTG9DMVQyR3ZvMlRX?=
 =?utf-8?B?bnJraEFvOENOWTcwV1d4NWo1Mm55Mk5JVmgxK0c5djg3bTZ3WGhuWmgrWHcv?=
 =?utf-8?B?eUVhYWFvZ2dqdm9EWk5Pb0dZV2l6WnpUWVNueHZtOG1YRlgwQ3JrMkdONU5V?=
 =?utf-8?B?a3RlaHVCNU91L3kyWGFnT1E2R3cwMm1vaG1aTHVpdEdxWEVnRm9uSU5PSHlz?=
 =?utf-8?B?WEgxWGoyNnhsWlZUNXJyZy9aaHJ4aXJiODQrb2oxMW5wOWhZRWFLdEdIdE9u?=
 =?utf-8?B?VGl1ZEhTM1ViZ3JMYytoSTFJeGU5YVV5c3dOZVNYMWN1Mk9WNjhsVHFvWWln?=
 =?utf-8?B?OGg3MUJmczJib1RXUU9SS3JzTGtqODl1WWdacGZzdDRaclJiTERnTkE5UEhD?=
 =?utf-8?B?RmlGbTRmY0R1Z1U3V0lvTk9oZ0dWNEh5VzA5bCtNYjJqU2Nua0NkZHVybkxn?=
 =?utf-8?B?ZFpPMUZaekpIMEpHeEptVGdCNWFGSmZQZmVoQkdhVVQ3VVRjZGR6WEovSXgz?=
 =?utf-8?B?OStKcW4xQmhqMWhBcTB1TEU1Nm0xSnRWVUZWQjBkQ1dFSTVLMVZaUUwxdy9o?=
 =?utf-8?B?TTVVaFVoWVRFZXJ5dnhtSU43SkduL1Q0N1Jza05nbDBnenByZUt6R1hxbmhB?=
 =?utf-8?B?ZDdpZ3hka2xreUx5ejMxb2krZy9yWGhxVHhiLzN4UVdOZWxBTGFIYW9MMjRt?=
 =?utf-8?B?MXVKbExvUWRRRDJDTTFuN3BUZk95RVVkUkRxZ3ZDOTVQd0VBSUJNVlpWTUZF?=
 =?utf-8?B?RkE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d00ee14-3788-49f3-3346-08da9ff15e4c
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5030.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2022 19:00:24.7002
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L/eIisfhthM91H1yEFIlXGgLsX+JgpjK/60B9JgPJ5/SQWbTjgF1BS3k4lfNIitMjOeObsMdVqInT531t7ELaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6674
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-26_09,2022-09-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 suspectscore=0 adultscore=0 bulkscore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209260118
X-Proofpoint-GUID: LqI0rePWrx8v8lez0wO7geOSOp_ee0gK
X-Proofpoint-ORIG-GUID: LqI0rePWrx8v8lez0wO7geOSOp_ee0gK
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 26/09/2022 15:52, Ovidiu Panait wrote:
> From: Mingwei Zhang <mizhang@google.com>
> 
> commit 683412ccf61294d727ead4a73d97397396e69a6b upstream.
> 
> Flush the CPU caches when memory is reclaimed from an SEV guest (where
> reclaim also includes it being unmapped from KVM's memslots).  Due to lack
> of coherency for SEV encrypted memory, failure to flush results in silent
> data corruption if userspace is malicious/broken and doesn't ensure SEV
> guest memory is properly pinned and unpinned.
> 
> Cache coherency is not enforced across the VM boundary in SEV (AMD APM
> vol.2 Section 15.34.7). Confidential cachelines, generated by confidential
> VM guests have to be explicitly flushed on the host side. If a memory page
> containing dirty confidential cachelines was released by VM and reallocated
> to another user, the cachelines may corrupt the new user at a later time.
> 
> KVM takes a shortcut by assuming all confidential memory remain pinned
> until the end of VM lifetime. Therefore, KVM does not flush cache at
> mmu_notifier invalidation events. Because of this incorrect assumption and
> the lack of cache flushing, malicous userspace can crash the host kernel:
> creating a malicious VM and continuously allocates/releases unpinned
> confidential memory pages when the VM is running.
> 
> Add cache flush operations to mmu_notifier operations to ensure that any
> physical memory leaving the guest VM get flushed. In particular, hook
> mmu_notifier_invalidate_range_start and mmu_notifier_release events and
> flush cache accordingly. The hook after releasing the mmu lock to avoid
> contention with other vCPUs.
> 
> Cc: stable@vger.kernel.org
> Suggested-by: Sean Christpherson <seanjc@google.com>
> Reported-by: Mingwei Zhang <mizhang@google.com>
> Signed-off-by: Mingwei Zhang <mizhang@google.com>
> Message-Id: <20220421031407.2516575-4-mizhang@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> [OP: applied kvm_arch_guest_memory_reclaimed() calls in
> __kvm_set_memory_region() and kvm_mmu_notifier_invalidate_range_start();
> OP: adjusted kvm_arch_guest_memory_reclaimed() to not use static_call_cond()]
> Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>

Reviewed-by: Liam Merwick <liam.merwick@oracle.com>

> ---
>   arch/x86/include/asm/kvm_host.h |  1 +
>   arch/x86/kvm/svm.c              |  9 +++++++++
>   arch/x86/kvm/x86.c              |  6 ++++++
>   include/linux/kvm_host.h        |  2 ++
>   virt/kvm/kvm_main.c             | 16 ++++++++++++++--
>   5 files changed, 32 insertions(+), 2 deletions(-)
> 

