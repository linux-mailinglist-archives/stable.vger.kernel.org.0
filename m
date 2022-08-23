Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DF2859EC5D
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 21:32:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231849AbiHWTb7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 15:31:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232034AbiHWTbb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 15:31:31 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FC0D105F1E;
        Tue, 23 Aug 2022 11:23:00 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27NIIiQa017138;
        Tue, 23 Aug 2022 18:22:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=CTE7IplM7dE4r2Iy8oCQHKk2buyXzP+a2aMmSaux3Og=;
 b=oQotXJWnsTOwmFl11QidwDm+yJf+eql3H536BwmY2WGnpui3Q489BgUKQ3V1JGYukMhe
 GTuZDOu5Nir2YwsZlwCNij8Qr2E8AA7t4awPyeOJHpgcA7lT+XkSKmHDP0446LmQB+Ig
 +GFWSzYXzZjOWnYjmk375JK9aIVsKRfYuLdoeEC7OUuxpNQYj1rO2CsP9EMqiJkFEWv5
 M1VHxke13+SNkJs8VxsUwiYi0xIHfMWXnVcdlYnXQt4g2vt81X0bwlQ2XKa3zu7urXRW
 dSJENbkhJqjg/dZycVg00sl5H7v8BjeA9AzC9Tfdclk4p4+nusVWnSsxaqi7JdVKfaeU 1w== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3j4eweayt3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Aug 2022 18:22:45 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 27NICCkW024889;
        Tue, 23 Aug 2022 18:22:43 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2103.outbound.protection.outlook.com [104.47.70.103])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3j3mm9yfje-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Aug 2022 18:22:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SZotg1KvbTqOGg00iqaPKblTYPcvpQKbhyVhFWJawU3roJfz4aBgV5O3RO8MoOfjzR9iuMTZc1F6Vkg7HJXBw+ZP5sJhpj/DR8/pWDvJ8BP9KTKqRbdOvgUNNG7agG7kmjXI0k7CstuL9JnOHbWG3/uR0LgQZyK9FlTHutVTbE25G89owJBwzF7jMo7EgNwy525wMMBsw4vXMl7N3jisCjJl9qVdD2YHsDvEWYJiKqtO06SEg/zXi9MjHT8DAPQHnWGbSgx8gu85N8njWDIzPi2lkL8JtskJaPZImgU4Hb23qv6HLSacmioi8DcOtVUSZHfXRLYIwv73/MCSLCakmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CTE7IplM7dE4r2Iy8oCQHKk2buyXzP+a2aMmSaux3Og=;
 b=E4MrV5vzqVd9ravXnhGaeW5Vjb2yL1dKo7mivvHDR8MBaXmfp2rqB1P7TTmWgEyKG8k0hwMOzAN0tW43F62Quusx+XbjiizEfRR8zg7xeE/qLfgblwACnGI1164K/dQ2829a8j79A2MrgH6qwLO03lGTBv8+dwMwDyXR0BN/6qguTCHiyS4MqzwxEjhOgpLDqTIzEtXyp4iEzaVbf8wqf43W0TdYJwI/WSF+S7DL8B436RzI+Gyv3aAsz+7+7/79iMkk4fzKotWjGZyqT6/nqQgerwBMb7/m0n0vLUzJ498Psm7BzYZgKZs/y3WttMONL4N1x1GyERM5jFh02Izcvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CTE7IplM7dE4r2Iy8oCQHKk2buyXzP+a2aMmSaux3Og=;
 b=HRJD3HPW99ypa9Pb9OTz2Aa9hqZQzccoNZzgxRFFmFfuLOk4S4a1KMkGMzu7d3Xi8XRrJdFZEKuZw96lmbaEzIfIVxL9eb52G1iEVh4hwRnOdUixYFcJijdAgdg4s9bNR8TOLpUKeZffOPPKPmqVHhsD6/2pCVAE/TZ9/miX+JA=
Received: from BN7PR10MB2659.namprd10.prod.outlook.com (2603:10b6:406:c5::18)
 by BYAPR10MB3670.namprd10.prod.outlook.com (2603:10b6:a03:124::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.22; Tue, 23 Aug
 2022 18:22:42 +0000
Received: from BN7PR10MB2659.namprd10.prod.outlook.com
 ([fe80::e0f6:5b20:2ab3:fcce]) by BN7PR10MB2659.namprd10.prod.outlook.com
 ([fe80::e0f6:5b20:2ab3:fcce%4]) with mapi id 15.20.5546.019; Tue, 23 Aug 2022
 18:22:42 +0000
Subject: Re: [PATCH 5.19 319/365] swiotlb: panic if nslabs is too small
To:     Yu Zhao <yuzhao@google.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Christoph Hellwig <hch@lst.de>,
        Robin Murphy <robin.murphy@arm.com>,
        stable <stable@vger.kernel.org>, Sasha Levin <sashal@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        iommu@lists.linux.dev
References: <20220823080118.128342613@linuxfoundation.org>
 <20220823080131.532813281@linuxfoundation.org>
 <c49d3b2b-9f5a-4257-9085-f7ac107cff40@oracle.com>
 <CAOUHufagA1x4jyjH9Q0RX65fwF3SyYHUTkNnB0S_t-2GqbiC2A@mail.gmail.com>
From:   Dongli Zhang <dongli.zhang@oracle.com>
Message-ID: <4d963d03-787f-992a-eb78-4719fb82cfae@oracle.com>
Date:   Tue, 23 Aug 2022 11:22:38 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
In-Reply-To: <CAOUHufagA1x4jyjH9Q0RX65fwF3SyYHUTkNnB0S_t-2GqbiC2A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9P223CA0009.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:806:26::14) To BN7PR10MB2659.namprd10.prod.outlook.com
 (2603:10b6:406:c5::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3debda64-38c5-4a1e-acc0-08da853477ac
X-MS-TrafficTypeDiagnostic: BYAPR10MB3670:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FSRgpM408M7kyij9qlyYicXtgscdjk/iPoWn0762/uEu0oUjx6KRHQ8ngCRGMP4HFMl0iBJAi+ZCmoHJtjkDlQ5iw6BKCCME6YoQ6kPv3S4unkFipImnsvGzd3mEmwnLhUx542xmEGN5EcUTL5sRIgemrCBAMryhZdOltKXJdUTcAdUAKe+ViWv2pdHNaG3ZBAeaBDbbXf/Rfiz/QlioJJbwPBHAkQo7ZsivF/LK5sf750bIljvbMrU6eIvAobYr4wgBo7GfhZeIxGm3j6ElnEoQNjXyTeDuJveLk8UdM4zsWgEvXQdMOWdC7NBOIQGtW7ixe9+Vwl5peIEZaD5kbtkbjlNlJ+d77bz4M40qyL7bVo2Z174lW0vV6rAEhCIlRxn8hskMSuu29r2d9yqUSgBzrLGK9g+NqWz6KzBUVmZBSeCGcyNcZ0X2EHrXfwIsHqUMONxCVbyp4QikGPieu8q9JhfTQt1Nb/haYahMuVG7Msd6+MOpPM+E9kB2YaiNetLfi7Zc82rj7/M/EscOJwQRSUp8r68Vb1YvSg/02hxaRPeK6LMmuGhLOCd30XOXNvgL/cHt1Embu08LOtOdIGPkxvMOgK554Gww66v6pHUbeqNRHRU9lRcp4MKuNog5zcn+Fk8VowiRxEMRbHNMvmRxlnnb89C9u2rMCS0LKseyhun3Kh0CCeTqDyoje3MU8rg8r8BrKKnNhxGyUDLTORknnR0u3jsO0argKz97GUJ9rIljq0WBDZdKCJf0gbDXUZfju567NcwTjUE+mZZ0u8vo/R924g9tn9OrE8SaYtfn0lPfYrAerQxuQCGWCBhr8NWjQWhhTEuNA9J7WfvuW/9/vOMFpOUpvlqkphzHneazCVEHlFH4f1vxvskf/oZ5E+n5juml5w1nEKx4gh7MfMN1i+bJrEj8iyl48YwZhOc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN7PR10MB2659.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(396003)(376002)(136003)(346002)(39860400002)(83380400001)(8676002)(36756003)(38100700002)(4326008)(66556008)(66476007)(66946007)(8936002)(6666004)(6506007)(5660300002)(44832011)(6512007)(2616005)(31686004)(478600001)(6916009)(6486002)(316002)(41300700001)(31696002)(86362001)(2906002)(186003)(54906003)(966005)(53546011)(160913001)(15963001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OUpwTlV5K29oTC9wRkFuR3Fzb2NVU3ZHaGhKZ1diTm1ieWFBdFUxcEZPODRs?=
 =?utf-8?B?anlqb3ZoL2JzQllmNlRHN0FmbzlQV2NSYWVSM3YxWVVxM0FvcmkrTW1rMUpk?=
 =?utf-8?B?VjdLY3k4c1gyRzcvOG9TVDZmS0tCZmpjVzNGa2U2TWo0WUYvV3QzQ0VFWTFo?=
 =?utf-8?B?YlhBY0ZlMDBUay9sZ0dOTVVCa2I0a0VabnFydHhYNDBoWWdvNmFLbXdzTktP?=
 =?utf-8?B?WFZVc05VazNFN2dRNTJjZi9WVXMzV0tzcGw3a3p2cHdTbUdPaW0zV2dheTZo?=
 =?utf-8?B?NGc2L3lNV3pETG9TbkZtNjYzZFhiRlRaRnFzK0pSTCtJYXpXOVdBRWZicDlJ?=
 =?utf-8?B?aDZidHpuSmZEL1RlUkJkUnE3VVA3WGtLZXF0QnVnWDlpa25sWWZhK3EvMG9J?=
 =?utf-8?B?TkNmZ0xGT1RxUjV3RG9WbVRBVzI4VnhNL245Y2hGc0tzdnQ3ckRHT2lpQlRi?=
 =?utf-8?B?UkM5SU9kWDc4cWZETUNScG1RVWczRTBVS1g3N2N0a2ZiZjFOcWxiczZjVVV3?=
 =?utf-8?B?WVdWUnlXWXFPT3NHYy8yWWVvRTlVQTR0VkExN0tFMnU4VEIvV1YrVThNN2hR?=
 =?utf-8?B?Q1kvYWxIMVgzQTVjSWZ5V1R3N1R5U3JvM2hVTjBNbHNFWm1hbHg4S1k0aUJC?=
 =?utf-8?B?amZyb3YwRUZhSEhkVTFQUFRxN29WWFVUYjYzRW8wSlZLSjMxNnpzdFlwREZ3?=
 =?utf-8?B?QldnRjVpZTlCdWgvb3QxdmtOWk5iMWxsTmpWYnEvYkF5RlZFT3pSUDFyVnJE?=
 =?utf-8?B?cjVwWG9iMndhRjh0Z3ltcmtxZUNPYVRtNE1lUnZ3YWRyck13azBwaFV6d0ND?=
 =?utf-8?B?VlFNUUl1ZFVQM0kwcCtXNzAzY0lIMlZlOFQ2SnhIYTg5Q1VVUlIxVTBVU1Y4?=
 =?utf-8?B?ZWtxMjhkZ2d1N2RuRXo3OGI2UjFNWUNmS3E5bElqUDZ5eUF0SWQ2VC9WdGRB?=
 =?utf-8?B?Wm94bEZPMncwOEo2d1l3YU9FcVBkOHA4dHltNElkdFUrelhMNUNXK2xFNWF1?=
 =?utf-8?B?R0F6aHhEdzBocmo1ZEZiWTdwa0NsekN3WFlHREdGcjU3Sm1OS3NzcEFzb2ZS?=
 =?utf-8?B?VnJYWDVqaEJvTVpGMnRoZ2tFVlN6RERYZ2lCblkzVzUzSkNHa3hOeTFYd1Er?=
 =?utf-8?B?ZlM5MWE3NDEvdFZzeHAyMmlPbVdXSFl3cGZvajFVMkxOWlFOSXBnVEdYV2hm?=
 =?utf-8?B?N2paSFE0ZnF4WU01RlJkQkdhQWFPc0NwRVVJekdYTDl1UlpPUzZ6azRuSlNF?=
 =?utf-8?B?Sjl4WUhSbHpQVHNmbEJkZmkzek1GTlNHbXR0eGlLTWc4UFNLTHJkeFZQNHp1?=
 =?utf-8?B?cXFvLytjNExDbDRtMjVkaTk1M2FIUnErYk5RUzRPT3g4NmFQKzRoSmorK1h5?=
 =?utf-8?B?VTFmSkM5ODlpL2c5dWlLZm8xS3lTcTk0ellYUm1FVGhCMU82Vlk3ZzY2V3Fo?=
 =?utf-8?B?Y0FDWjdSQmJONkt0UWxSQXpSWVdteHRIS3ZoNEtMdVV6RXQ4Z05LY09hQUtt?=
 =?utf-8?B?d082WGdsNkVQZWJMSkNpcmpTalJkcDVXbERDRCtWaXpydDFYMERPdFFWTjNU?=
 =?utf-8?B?a3ovaXVYajhYdVgyay9iem0zWExOdGhJUW9LNDBkT0N4VlRLREI2RVlGOExV?=
 =?utf-8?B?T3Y4QTRicStjRVpiUEJ6WGVkc0t0R3RBYnhraWE1cGtpYXFVNzZ6SHpwcEdy?=
 =?utf-8?B?aHNTRUhDSEZQT3AzbEpMZFhnMlFzK0plRXcwWUszUXNFcEt0V2F1WlF3Tnl1?=
 =?utf-8?B?eWlTSnFLUHJPN1ZqTEJRMG1raUdmZTdYNEtHZEkxQ1k1aVRXL3YyTFIyVmdL?=
 =?utf-8?B?VmE2ZEw3cVArS1BiNTlwemNCWWxqeWFwTGk3Q0p1aTJQWnBpODJvUEIrU3Ny?=
 =?utf-8?B?cG0zNkF0K0xsUmJxMTdKZElES2g0aStqWkVId2ZacU5DNCtiZjBaem8vd0N3?=
 =?utf-8?B?UEViclRVMGZiS09aWEZYcVpSbmFRdnNoNldnckJCMlJPbFNYUkJLU0owbHVW?=
 =?utf-8?B?QjVNTlBLWHIrd2hFaUI1R0JkU2N4U0pNMFhLck1OZWFaWEFoeFA2K3JRUWZk?=
 =?utf-8?B?d1c2bHdSZXBPK05lWjdTWlRldzQxQVZIRHNqb1ozZHR1RUxQVCtDY2tjY2lw?=
 =?utf-8?B?bTFvZzJ1Nm1UeUN4REpXZiszQTdBbWc5WGxLNXJuWUZ4b1Z0ZjBhOVNUVmkx?=
 =?utf-8?Q?m8Wx3jiJCIOXNF2VUrT1plw=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3debda64-38c5-4a1e-acc0-08da853477ac
X-MS-Exchange-CrossTenant-AuthSource: BN7PR10MB2659.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Aug 2022 18:22:42.0351
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PbJ8xdEdchmrwDvxPaiLdIctLkPIMo0WvzPDuPE5FjHH4GiE5vKM7w8+pRR/mzItqi7G2RD/r1ugInuJxlon6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3670
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-23_07,2022-08-22_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 spamscore=0
 phishscore=0 adultscore=0 mlxscore=0 malwarescore=0 mlxlogscore=935
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2208230071
X-Proofpoint-ORIG-GUID: WR6TGYOlPwf6nxVBidKQMk6FJIYUStIx
X-Proofpoint-GUID: WR6TGYOlPwf6nxVBidKQMk6FJIYUStIx
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 8/23/22 10:51 AM, Yu Zhao wrote:
> On Tue, Aug 23, 2022 at 11:25 AM Dongli Zhang <dongli.zhang@oracle.com> wrote:
>>
>> Adding Robin, Yu and swiotlb list.
> 
> Thanks.
> 
>> There is an on-going discussion whether to revert this patch, because it breaks
>> a corner case in MIPS
> 
> I wouldn't call it a corner case. Cavium Octeon is the major platform
> we use to test Debian MIPS ports [1], and 4 out of 5 best-selling
> Wi-Fi routers are MIPS-based [2].
> 
> [1] https://urldefense.com/v3/__https://wiki.debian.org/MIPSPort__;!!ACWV5N9M2RV99hQ!NDVwU_XfPmfl_OSGxbroJXOjYmdrb-Vmbnx-zq0UIxkYNCetx4ZWdl6KlftLS9F5ORGT4t8F5YapMSSBiA$  
> [2] https://urldefense.com/v3/__https://www.amazon.com/bestsellers/pc/300189__;!!ACWV5N9M2RV99hQ!NDVwU_XfPmfl_OSGxbroJXOjYmdrb-Vmbnx-zq0UIxkYNCetx4ZWdl6KlftLS9F5ORGT4t8F5YacDz0Zlg$  
> 
>> when many kernel CONFIGs are not enabled (related to PCI
>> and device). As a result, MIPS pre-allocates only PAGE_SIZE buffer as swiotlb.
>>
>> https://urldefense.com/v3/__https://lore.kernel.org/all/20220820012031.1285979-1-yuzhao@google.com/__;!!ACWV5N9M2RV99hQ!NDVwU_XfPmfl_OSGxbroJXOjYmdrb-Vmbnx-zq0UIxkYNCetx4ZWdl6KlftLS9F5ORGT4t8F5YbWJyEn2A$  
>>
>> However, the core idea of the patch is to panic on purpose if the swiotlb is
>> configured with <1MB memory, in order to sync with the remap failure handler in
>> swiotlb_init_remap().
>>
>> Therefore, I am waiting for suggestion from Christoph whether (1) to revert this
>> patch, or (2) enforce the restriction to disallow <1MB allocation.
> 
> There are other archs (arm, ppc, riscv, s390, etc.) that call
> swiotlb_init(). Have you verified them all?
> 

The issue is not about swiotlb_init(). It is about swiotlb_adjust_size() where
the 'default_nslabs' is configured to a very small value (e.g., equivalent to
swiotlb=2). I do not see any arch can directly configure 'default_nslabs'.

There are only two callers (archs) of swiotlb_adjust_size(): amd/sev and
mips/cavium-octeon.

About amd/sev, it uses at least IO_TLB_DEFAULT_SIZE so that there is not any issue.

244         size = total_mem * 6 / 100;
245         size = clamp_val(size, IO_TLB_DEFAULT_SIZE, SZ_1G);
246         swiotlb_adjust_size(size);

In this case, only swiotlb=2 is allocated if PAGE_SIZE is 4K.

Thank you very much!

Dongli Zhang
