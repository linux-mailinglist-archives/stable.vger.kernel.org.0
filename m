Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2BE85ABEF1
	for <lists+stable@lfdr.de>; Sat,  3 Sep 2022 14:25:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231156AbiICMZk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Sep 2022 08:25:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231183AbiICMZi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 3 Sep 2022 08:25:38 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19B224B4A6;
        Sat,  3 Sep 2022 05:25:34 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 283B5TNW008299;
        Sat, 3 Sep 2022 12:25:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=8an2hkUFnUB8/5SILpGYcl3MQNQiD3HrUcUYGoVnKbw=;
 b=FGIzn9HV1yHN0JFs0KZh1rCMmHzBKuEsK9yalsK7d0zTh0ih1EIUo94n6sh0XyI4X3JH
 TbXrRcpPZ160YnEA1jnoGgy5SWAFgSRwH+Jtawla8ORwtu0RZDOuVOk/DrVU0p9w3mtJ
 fZ03mKNxxmUTrzlec6DeWAMiVmiJvAYvvj0EOEf96uBf1DZq6llPbd3YTLhRp4Gh5cZI
 h8Y5MY2Fyu6xcOorU/6IVyDNnyQuPAN5PikVqME3T0Ky19EBRGt/CteD1BZlaEWlquH9
 Opapbshu82YX2nc3OjbHlmumHn47bHpuFD4PAsntYJtZzpZXlvxLfo8aRn0hmbG24fIm hg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jbyftgjex-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Sep 2022 12:25:30 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2838HGYh027860;
        Sat, 3 Sep 2022 12:25:29 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jbwc6r104-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 03 Sep 2022 12:25:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oODhWSwQx2r5J9klt2Elb2oc8hltB4BuMsndcQsy8E67kV6A7DVisSqZIN1epiH7KQjLxhnG/4OWrCQrOqBo00fZix64Qpr7QD/NneOV6erLo2ABwPOt3MAXVUZ7keZEQ82tF735+mfc/9HfbYEM5ZwqBpunnGd5hl1TK76/GCPIngWWBInZIfdG9NYYxq029mBS9PfzLeEryvVCB2bcCcIWhQwYHbBWDK7wxG/R6GS7oRzjH0bdmlOfnlZJOSjf6EYoZzbi0rUaEIzkkAFKPc5fJv+2Y+S1vxvsoP6oyL9qNCzpAMnHGgPgLR3sNhPLe4Enenr6TZtKQRNUDGd0SA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8an2hkUFnUB8/5SILpGYcl3MQNQiD3HrUcUYGoVnKbw=;
 b=DCtoL1De35G/NzqRgOCJirGUUkJKL6qbmNv7ulM2gCTxTNaLPl1+CRJ4m3JjhUO4+BnQJws2F26MgtfJMjve+Qth6Wzu9ShAhETiQiJW0kOtuNhS+7QxHjXWsKLTciAxog1tvFeVZm6kDKaoUnTMD3HDZQuaRTh0ybsYtjEjD/P79FRh1wi9rzOMyuHU/g1lmzm5B3Jz1R+hOJ1mHeZXPfqGVdz16ojTPs3HK7qG2ORE+FPfOiNOj0RRQdl0XoOyebliCR416ckFZc3Chu2eC0zITUSwBY4JZWpb7pHOhfU0nihZ8Fn5j6BMkQxLHdzQR01vqMXhie1tiJdXqD+PMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8an2hkUFnUB8/5SILpGYcl3MQNQiD3HrUcUYGoVnKbw=;
 b=Ec/1W5V31bzgFSdxOMqxSKdA2T215HzSBO4xDDpjsr52WCYjiUignf4tjfCJ0D2lg9emJC832eRaaGtOr7d+OwEkqyLVvOJm3JyHP7KNKtQBWId8a8RAPiYUILr35VRD5N42tQyXkbFiIK6PGjTPI1rzPpieR7UvWqtEZ8CDIww=
Received: from PH0PR10MB5706.namprd10.prod.outlook.com (2603:10b6:510:148::10)
 by MW4PR10MB6347.namprd10.prod.outlook.com (2603:10b6:303:1eb::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Sat, 3 Sep
 2022 12:25:28 +0000
Received: from PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::f164:f811:6e47:b7cd]) by PH0PR10MB5706.namprd10.prod.outlook.com
 ([fe80::f164:f811:6e47:b7cd%2]) with mapi id 15.20.5566.021; Sat, 3 Sep 2022
 12:25:27 +0000
Message-ID: <0c060fb0-5b43-c868-940c-221cc48e9889@oracle.com>
Date:   Sat, 3 Sep 2022 20:25:12 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:95.0)
 Gecko/20100101 Thunderbird/95.0
Subject: Re: [PATCH STABLE 5.4] btrfs: harden identification of a stale device
To:     Greg KH <gregkh@linuxfoundation.org>,
        Anand Jain <anand.jain@oracle.com>
Cc:     stable@vger.kernel.org, linux-btrfs@vger.kernel.org,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
References: <73979e98c7edc6690959f1d5e9e8d2bb678a8101.1661473186.git.anand.jain@oracle.com>
 <YxHLiLPd0IfKrpT5@kroah.com>
From:   Anand Jain <anand.jain@oracle.com>
In-Reply-To: <YxHLiLPd0IfKrpT5@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR02CA0007.apcprd02.prod.outlook.com
 (2603:1096:4:194::23) To PH0PR10MB5706.namprd10.prod.outlook.com
 (2603:10b6:510:148::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 27eb6b13-86f3-42b2-3ef0-08da8da7626d
X-MS-TrafficTypeDiagnostic: MW4PR10MB6347:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: F33nAokjS1G9kgjtk3eh1kPRemP76aC26T5/2SAQLz9GPwGMlcoROen6EhXgbKsrMATANO1jFVQPuV+QTr9HDRGmYx46NCkoZfLuGuWmMjdjs+UEs+r7WbslT6EIswpF6ET+Jdl+MW8yKd6YyVsX8ly8qJsaw2HkQmdIx0ldv2wjWiWkuKSkgbyBZ5l54pqCI2FvsISPbxwluuSk5sgu1qhhvx9sT4mBy0gP1jMLh9VrP3CTWgJw6GaxLkpq4u3CiGiSxyzLS4/voz98O1+7A/qUFE6l8CEXE+13Fz0kMcS/QQzDNusShKbQBuJnetJVcq09hZvFA05PMac0gMWqpE1vkX5ubYPKYqRp+a+zrtcCgf+sOQ8tlSHx2Dc/ibgKgAOeQdcGY5sy+aek6z/YPv2qU1wBZo3nXTAddvjr+ZEYxyEhM8QHYQeHrHdvjP0S7VH9pYucthK7CoLB5h3PoN7BHkOttA8AUlzcKQlYXr0+Y8KhV7icxxj1L3nq79FRMZknPasBNu9pory71C+e4U08Bw+HykAeM49YpUCERzeeKueHpElaSV4QRXyrMbHnM5Qyrxv5stZeafdmlbcsLkm+rmONL6LaXiLNy85B2TAtHl/CgrBsCL3QVnwE34UeSrxg5DLch2n3fWxnYq/P/XO9U0PNoOXGcPZ9vda2psloBBIo5VORuLUfa0nETTwGUvDJFloeo87o5Zhv8vsbhsI03MHUdylMLo618654Ql2DWBY/6rxddgCdKXV69Z1Vo7jvxjiNadRx70fEy0pVU9CYaSgTvHm6C+p1F4odTPQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5706.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(346002)(396003)(39860400002)(376002)(366004)(36756003)(66946007)(8676002)(66556008)(4326008)(31686004)(44832011)(186003)(66476007)(5660300002)(2906002)(316002)(8936002)(110136005)(54906003)(53546011)(478600001)(6486002)(31696002)(6666004)(41300700001)(86362001)(2616005)(6506007)(6512007)(38100700002)(83380400001)(26005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aHhodWRyK2w4SzNEV2ljWU9MUlIyTzVvcGdWeDgxVHFNWS80bjlCU29DOGFC?=
 =?utf-8?B?cVJ3Y1NxOGJWcm5jWXU3djc5bktoNS9LZDFydGhFc0V4Ym9rZXRjNE9FWEty?=
 =?utf-8?B?RmpiNDZyWnFxZ1RCSWpmTUpSR0pZMk9MUExxWk9tRTUzdjNPWXIxRXJqK0Za?=
 =?utf-8?B?cjdxS1pZRHhJWnNJUlVMWWRiTTkzeWgxdmhlN2w5MkY1aDZtOWFiTFVYUERY?=
 =?utf-8?B?dWtxc0lHVyszdk91UW5KY3BWaVEzcXVySHpnUVl3b2xxcHhPK0lyNWhJeTNV?=
 =?utf-8?B?aytybTlQb2dNNmpLb290YXFaM0JsSVg5NnZsZnB1NG5DTzRsdnFYSXd0emNq?=
 =?utf-8?B?UVNTNlJjMDlYQ3VXUmwweWlaL2pGWkdkcDQzdWpXNVpKVEVObDJNNHRGTmtj?=
 =?utf-8?B?YkZOdzU2Ni9UZ1cya21lWUdOYXBBeDEyQXV1TzBjcHNyL0Q1Zi82ZVF1RkZQ?=
 =?utf-8?B?RlZpOVF6em42TEwzVFRiNFBJUDhielI5RTI5T0pTeTE2eUlLbTlYczNNcnRH?=
 =?utf-8?B?VGRtUlVwU1c3aTN2ZEh0V0hpUENRUzhIN1RiaFp6ZWhHdVJhL2hWcWtvNGJj?=
 =?utf-8?B?dStVeUZ2dkllWXR0QnB5WUNZU2JmdVVMdzRTQmp5M0ppTGhaOG1aU3FyWHhm?=
 =?utf-8?B?ZGV2R29yNVVPOWpSYUtSaGZ5aWJwb3NTc2k1NlVOQUlwbXkydGdYSEZzM2c2?=
 =?utf-8?B?dloydXM1YzJ4VFczclh2Tm5tRnBsMTJQY0Y4SnpIdTVFSkRjYmVSbGZ2ODdH?=
 =?utf-8?B?amYwSWNtbTRtc2o4TldNN3pRd2ZVWnRpZ0NuSG9IdjdCNmk5eEhJTVNsZVMx?=
 =?utf-8?B?bS8vcXRRVWNFeFE3NkU4dm52ekdZcjRKM2k1WnpSRXFvZk9EWFkvL2RCdXFC?=
 =?utf-8?B?RHZHekgyL2NvczhRTDlabGxDYlpSWHh6a25aME55RDhGeVRYeEZQOWszamNs?=
 =?utf-8?B?Qi80WHh6RXpOc3ZiMVU4WjQvaXlmWXd4QXdsQmY3VTlOWEtIbUVUY0xNT0lO?=
 =?utf-8?B?RmFETkJYTkZ2clRFVkR0R0xuZERSNDg5Ylk1RUY4aU1uKzVZUDNEUVhyRnNp?=
 =?utf-8?B?RmZkRWJ4QkJyQ1A0a3JPQktBbUdmcUZuK0Y4NnJZeld4OVg3cHFlOXZVVFZ1?=
 =?utf-8?B?dVJRSWlkRG9lZ3NoZmJxN0dsVWFBUWFCZEhEVHBGZ1BzR0I4MWEzaGZIelFY?=
 =?utf-8?B?d2N4dVJuRndXWmZrRVB1c1RaU084Rm1sWndVcjg5WVBCZ3pFaVFSajNoTU5E?=
 =?utf-8?B?c2k0RFRaaTA1M2EwaDZSYkpNazNlVlNlS0w1S0FvTGZtNFlFM2RTcEg2MjJo?=
 =?utf-8?B?VGFobXVJTHNwczNkL2I2eTJza20zOEpTalNKOVNIRlI1VDYxMjRueHI1VHNl?=
 =?utf-8?B?OHNTTkJJKzBhaE5DdXZKcUV4ZDdpS3FyNTJzTEZ1aVVtRUlkWnJaS2VPZ0tu?=
 =?utf-8?B?UlBQWGMzNFVsWms2VmhpSHFzWHhBQ043eTA5SklzaXoyZnNXWHY3bTJOSnNo?=
 =?utf-8?B?QzlwRS8vbkZaVXFHK0FTanB2NEF2SURFdkJjc0VOWGdzZW5FaElUK0gzK2t3?=
 =?utf-8?B?YUxOaWlEck5jcW5IM2E0ck1SMTJ3STJRQm9ITkd3YjF4WEgyNjUwdEkwTzRr?=
 =?utf-8?B?RUJFRnljUVlTZVJiWkdpNFZsa2o0UGtkSDJRdTJMc3dKWjFBTEpvcmtCMTl0?=
 =?utf-8?B?Mm5zQTdsVVptZW4xQ09TWjRwNnhmem85cGVIVFM5aVR1eTV6ZmZMQWpuZStm?=
 =?utf-8?B?ak1Ja2xtNkNaeCtLSnVOUkpaQTJQMlZLQ0g4TmM3b1JkQmRKbmdtNDFIUXcz?=
 =?utf-8?B?dHpEWGNSR3J5VTZCcVBYU3ErbEJYMGhtbWhDRXpPNGV1S0d3NlkrTlpNT0FV?=
 =?utf-8?B?NWZhWnduN3B2RVRHUnB3VXpJeGxqbEVqNXFmZzVJa2p2eFF1KzVtUFVSMVVI?=
 =?utf-8?B?SnRlQkZmUlhKMldIeGl6UGVvRTdsam9kNUJyRjA5MUdOUGJsRVQ4dmo4U0x3?=
 =?utf-8?B?M1prMEhJaE9WRGYvaGlQQmNPa0dtRzNzQmdhMEdZVXdMckp5U1A5TDh4TTJo?=
 =?utf-8?B?RUorRUlDWStEN3BERnlpOUV2NkxSZlRDek9na1d4OXU4TitYZGZkTGxaSTht?=
 =?utf-8?Q?14GEuoR/mtCL4V5cwUA0qjF55?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27eb6b13-86f3-42b2-3ef0-08da8da7626d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5706.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2022 12:25:27.9227
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O00Fa6l1Hz+JYIV5cmofb75oANagitkHqW9f6W5F5B9c6IGVvIFf1atgio6vqfp7t1OiFYam7aTHXF/veULc8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6347
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-09-03_05,2022-08-31_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 phishscore=0 mlxscore=0 spamscore=0 malwarescore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209030063
X-Proofpoint-ORIG-GUID: IGeOttgpNSpNXwYAAvZa3pvrPmCHuUZN
X-Proofpoint-GUID: IGeOttgpNSpNXwYAAvZa3pvrPmCHuUZN
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/2/22 17:23, Greg KH wrote:
> On Fri, Sep 02, 2022 at 05:09:38PM +0800, Anand Jain wrote:
>> commit 770c79fb65506fc7c16459855c3839429f46cb32 upstream
>>
>> Identifying and removing the stale device from the fs_uuids list is done
>> by btrfs_free_stale_devices().  btrfs_free_stale_devices() in turn
>> depends on device_path_matched() to check if the device appears in more
>> than one btrfs_device structure.
>>
>> The matching of the device happens by its path, the device path. However,
>> when device mapper is in use, the dm device paths are nothing but a link
>> to the actual block device, which leads to the device_path_matched()
>> failing to match.
>>
>> Fix this by matching the dev_t as provided by lookup_bdev() instead of
>> plain string compare of the device paths.
>>
>> CC: stable@vger.kernel.org #5.4
>> Reported-by: Josef Bacik <josef@toxicpanda.com>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>> Signed-off-by: David Sterba <dsterba@suse.com>
>> ---
>>   fs/btrfs/volumes.c | 44 +++++++++++++++++++++++++++++++++++++-------
>>   1 file changed, 37 insertions(+), 7 deletions(-)
> 
> What about the same change for 5.10.y?
> 

Thanks for reminding me.
I have sent a separate patch for 5.10 as this patch won't apply to 5.10.

- Anand

> thanks,
> 
> greg k-h

