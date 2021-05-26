Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1464B39104F
	for <lists+stable@lfdr.de>; Wed, 26 May 2021 08:06:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231991AbhEZGHk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 May 2021 02:07:40 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:56794 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbhEZGHk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 May 2021 02:07:40 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14Q6557x120391;
        Wed, 26 May 2021 06:06:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=y0VDe4aUH5uNL3jSPMK/IIH87px7TFQMR+9vmwG1XG8=;
 b=vjB9r86MeLw3E16Qte2ri+s+eTDcHnOKU+AJV7GzmxxkcxkWJt8qCBed3HGBaOc6z6fV
 /itEl9i/QkgpN9gN7w/KhDf6n8dtTj83zvYxvTs/somthOQIiCP69xSOFf8/Ul6VFaeV
 qgSdb0bKMGV8mdGDSR45P2akb7QrBU2DTodgQchtRt+QyvvCpHbLMFLln2evqIkFKPa8
 zUsFN+vasBPOM2NtcJeoVbjvQ7wBW0Mluyc67hgvCz5SIa/2l5HaZ/4DiOUfQMUV5QQK
 eNKYgcRRfITdBJk7K2tB5jdgmnyLBIwyLooK8Mpwv7SLI0r3me2M67IPl1BHrIvKyKMg 1A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 38pqfcfy33-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 May 2021 06:06:06 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14Q6658A167797;
        Wed, 26 May 2021 06:06:06 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2041.outbound.protection.outlook.com [104.47.74.41])
        by aserp3030.oracle.com with ESMTP id 38pr0cep43-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 May 2021 06:06:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GSGG68fOrMSv85IZuwOfWQaD6APXlt86vd9iXvzHML5s616vYtsPjOFPS4ZK32Sbvr8KaxnzbvHLPUCBuEnMAuPcwS+vaPjx2ck7fvyNwlag4hGuA9L7mGIIiGGOMRCN0JhSDnUs9DK/ciwyg3+WTMyeITimR/XAkStT9bWkV6OlaJ5nUiTnfI0Rk6rISvFmfoJoO+YMiiu+QH7Nwgi89FKO6WOMC0bbggp0TM+jmk47vnH1085JGrwYgFwfEzUMCjp5s4viLU8OwHQQXUKKvo4ACeUQDJZFO7F48iK+DlUB3JrZ3QpVHHb1Y8pXGnk0Ngo0DIwamSM1Ktip1OX6Yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y0VDe4aUH5uNL3jSPMK/IIH87px7TFQMR+9vmwG1XG8=;
 b=D8ONr6S8IgE9CqLJzWOzXqsN/INNVMIKATEeJuMCqSjluZbi8qRHpFYuucmBYrQvC7kOlrJiRgXHIsWDlFItH+EerNGiVviWXDqohbKAUOuhVX+uT9lH1022lorOztVn5xwG2ygkqwXOQ5oKuvWbm8hNlJkKib/uLb50ZMcj6vZMZIjtjnqEA7sLHxST2Emgr4BP3jnBusknNjfA52Dm6VLpe3y5mAcT3yQuWfMOO5fa+h0fWSe2iO6cGaUYiIgFXXxsfK/XKxmsRudOWpjZo4DS8NRNMKdbrQB6+KS3uuPxjYE1HGKMQWG74FuR9BECNLqFy0rQKsTArybsrABymg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y0VDe4aUH5uNL3jSPMK/IIH87px7TFQMR+9vmwG1XG8=;
 b=L9FFFd+Twg6koJ2R8VXj+ocjaFQK+ctRddrjY+KowX09R3E2nxGVIlptxi5R6RSs1MZ8Gq6UfP1x3f1YcuXycrh7rhh7PBxiilN01ThPgMx49njY1dc67vA6NVJY+Usk2WFkHW7Cv3El4gV4RZIPa42HA64tjvxjt6ZlDdseQog=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from MN2PR10MB4128.namprd10.prod.outlook.com (2603:10b6:208:1d2::24)
 by MN2PR10MB3837.namprd10.prod.outlook.com (2603:10b6:208:183::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23; Wed, 26 May
 2021 06:06:02 +0000
Received: from MN2PR10MB4128.namprd10.prod.outlook.com
 ([fe80::992c:4b34:d95:def8]) by MN2PR10MB4128.namprd10.prod.outlook.com
 ([fe80::992c:4b34:d95:def8%8]) with mapi id 15.20.4173.021; Wed, 26 May 2021
 06:06:02 +0000
Subject: Re: [PATCH 2/9] btrfs: clear defrag status of a root if starting
 transaction fails
To:     David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Cc:     stable@vger.kernel.org
References: <cover.1621961965.git.dsterba@suse.com>
 <183259751d20f64fa45dab806b7083923e718ceb.1621961965.git.dsterba@suse.com>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <00ba646b-ea26-4a52-fb6c-1d617a2cd235@oracle.com>
Date:   Wed, 26 May 2021 14:05:54 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
In-Reply-To: <183259751d20f64fa45dab806b7083923e718ceb.1621961965.git.dsterba@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2406:3003:2006:2288:c97e:3e12:797:83c8]
X-ClientProxiedBy: SG2PR02CA0042.apcprd02.prod.outlook.com
 (2603:1096:3:18::30) To MN2PR10MB4128.namprd10.prod.outlook.com
 (2603:10b6:208:1d2::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2406:3003:2006:2288:c97e:3e12:797:83c8] (2406:3003:2006:2288:c97e:3e12:797:83c8) by SG2PR02CA0042.apcprd02.prod.outlook.com (2603:1096:3:18::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Wed, 26 May 2021 06:06:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 383a791b-3f96-4e54-5ac7-08d9200c572f
X-MS-TrafficTypeDiagnostic: MN2PR10MB3837:
X-Microsoft-Antispam-PRVS: <MN2PR10MB3837288BFDFC30DBCFD6BF76E5249@MN2PR10MB3837.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YXZbxAgTXtIGRCv9mVt+SkzY3I8GQMKsUO2gNo4ZcnN7yL45Jf7y23KABfg8OuWXeoonjjgGcYJgfoOyWQqWbKfE2hs6a/q8BL55Yz7Bk1kO2UMYHckteNzqrjY56oz9pUAJdLCgMvQSu2WGWIY1A4k/x5ohhmkH0Q2T1Z890/MmSSYy5hutXBtGVhFV9SGwAzVtTsMZDNRyVRiYZzih6EuvYbrswgHpiSXUSEyf8fgjXHR2+/GHqcEP+Dne3lCcjBWeJUEJJ+zrwClTszMPUzXDUcdWSPaaxs8ISLB1+W2YZ2xAdyrZKkAEmdpPtG7AHnI11JB+2rIc0CnSk+CzjiOSHUFF8bly7rYKmrnmqmrEsjVq+dPAvuk4JR3ikk5D1kRjnX8pHxwIp+sWp6kZl1O9KZG+qN4DhR6NU4IqE0bQPRf0grnLoNH5YsaboDSAdr54XDeeDuHBz2wny2zqDHaWtEgiv7uiERykucW2HjCcBPO62aiTwpx1/XqcbF+reDfNIRvhf2hrDLb/oMslxYAwe126sjpOdt8DaBRlTaiBDc3UYLdxUGsnBsrRAHqFc88RXls1KKbzIx0+ptD6XdiCb3Qn8tKOfRXBPAJu7RqpsSp8BIKk8xJqiIgOkVzSqBMZV1sE7wgBzjaCEjTAofgPs56PFf2v3lFHNoerpaVGsw4JhQ2n/AZr7X5jKktE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(376002)(366004)(39860400002)(396003)(38100700002)(31686004)(2616005)(83380400001)(66556008)(6486002)(36756003)(8676002)(16526019)(8936002)(4326008)(53546011)(6666004)(478600001)(66476007)(31696002)(2906002)(86362001)(66946007)(5660300002)(44832011)(316002)(186003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?UDQrT3FIZGhBaTUydnQ0WlpGa2I0andjaHd3enZISm14VHhTd3B3cTFOejZh?=
 =?utf-8?B?Uk1jTC9vRHF0ajlzVGducmkxeG5DZTRzelkrQWVveXA4dmpxeVhYbmp0UDA5?=
 =?utf-8?B?WndBQWp6dTlpMm43bXI3RXNYU1d0SDVpOFB3b2tnVGYwNVNTNFd2Q3YxSS9w?=
 =?utf-8?B?di9USnZEbU8xTWhjRWFVZ1EzazZCL20zdTZCZTJoQjNyWVVRaHNYK0ZmVjNL?=
 =?utf-8?B?ZTZHNlVBUmFrUVR0WTJYSGM4RThMaFIrWEx3bkI3RXZvamR5V0dqYzFjSDNZ?=
 =?utf-8?B?U0JDWE9RaDhKWUp2aUZzTE1tbDNvdUU5SG83NnRzeEJhUER4djM3RlFPdlZl?=
 =?utf-8?B?UnNQS1RjVmxuYklIQTNST1VUcTVRVkRpOTNmTFZGOHBVNExPRWYwaXBPcWNx?=
 =?utf-8?B?cnpwUVVBVFdDSE01eUJ6NFlpSFlqcm80d1hxTUI3WkpUU3lUL09GMWVrd3FY?=
 =?utf-8?B?YXZSTWs0TWlSV21VT0RTdlNVUHQ1YkF3UFlQRDRsM3ZmSno2eno5dmdmNVhF?=
 =?utf-8?B?cnZsUEw4bkZhNWExTjdOZXdJM1hSQW9IRkNzcFp3UkJJZ3JtNkRkMmJ3T3hL?=
 =?utf-8?B?R1JqR01HSFM1SXVuWVM1SU9wK2V6STM0Q3FRWW1mbm5MR1lXRXlWSzcwOHpR?=
 =?utf-8?B?TVNDcE9SY3h3dFh3L1RaQXNxLzVXbVRHZEl4dm9LTkpxOEovQ1R1Zm1XZ1J2?=
 =?utf-8?B?cXBJUFd5ZnM2QW5JbXh6WEV0RjlrTFJHVDU2OFJHL0ZWa0VmMlFHRVNaMmdQ?=
 =?utf-8?B?MmY2a2llVlJtbDBXM0dTNUl6QTlZQ0xoS0MrQ3l2L2JwZk1DM2c3OVpvbUFM?=
 =?utf-8?B?amd4SkltS0hpeEEzTnZZT0NkTGVMNk5KV2t0YU1BVFdjSGI4TzNRcEZtM0gz?=
 =?utf-8?B?N3I2b1J0ZVFsWmxaR2JSQmx2amdHM05la0l0aXZUdk1oZEIwUFFnOWl5THFh?=
 =?utf-8?B?KzhsckRSeVB3TkR4YSs2VGtlSUhjdnZMQmZjbHM3WFpLY1MrUjRyRGtFeTdB?=
 =?utf-8?B?SVlsVFJjMDNLemQ1OEp3L2lRVXQwSlhaWm4xM0Y4dzRoQkZSRXFDdzNRSlUy?=
 =?utf-8?B?SGtIbjEwSFNRR2c4VzBudWE1bHp4YkVmQUVXTXQya3p1RXI3anlhOXArM1dq?=
 =?utf-8?B?Um9SdEtCZ3pQWFV2Q0VHUmRpL2t6Yms2NThwTndCZG1Eb05UNTB1aXVkYXhj?=
 =?utf-8?B?K21JOXdxa2VkQkZ5TFN1Sytrc1lLTDNpQ21MbXRCSTB2cnNXZ3hvdXZqU1Ux?=
 =?utf-8?B?U0EvSDE3NzczbGJZSUNiM0hUUndkOEhGcUxDdE5FNThWMnduTnp5OCttOXlk?=
 =?utf-8?B?QysvVVBlYWlpT1MvNFpNZGlQWTVtZlA0MmVjQnVWc0tCaWxoMXNBQTVwdld2?=
 =?utf-8?B?RUhTME5RVi9qaFBBR054RUpraGx2NDNqRVZvZlZLTDE2RDIrOWVES3R0a1Z0?=
 =?utf-8?B?bU9FdnRJWG14YXZ0RnhYMGZvUjVzcU9DbjRMZnpjQUdOL0EwTC83amdKRnY3?=
 =?utf-8?B?bEVNMWdqNEcwNmtPTVI2aVduRTc0aFlMYnU5S05oV1BiSWk5NGRZUzRVQXZI?=
 =?utf-8?B?anVuaTVuVDdXU3kxRE9SR0xBYWxSVGZaSXNiYVhrRENZU0FiUi9mWGNoR29S?=
 =?utf-8?B?OUp4UVFJeHZPTFNjWkdYRmp6aTZ4ZmlOMk5MaUYzdkdXN0JIUjB0YWtOL0dN?=
 =?utf-8?B?dlN1NFNHVG9hYWZJMjJ2NlVsek1JaTJVc2VRV2VOdzI3YkRxdi9NK2RMT0lC?=
 =?utf-8?B?U3B0dngxd2tVem1iTnpnZEVGNG9LVWVOMk5yRzcyZ3Q2eU4zaUFvaHlFUDRK?=
 =?utf-8?B?dUJIV1dKRkthU2JDZXhtMTFFTTlSSlVjN3dmaTJRM2tubmthTmMzME5wektL?=
 =?utf-8?Q?BaEvquitmoCH1?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 383a791b-3f96-4e54-5ac7-08d9200c572f
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2021 06:06:02.7338
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LJAfZDeP+4OIE77m39JJISFsR8LVwGu/lIqoWYwBLTFuDU2fcZvkVOdchEelFBvgUZcRYD5ZC45TGjhJWTl+TA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3837
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105260040
X-Proofpoint-ORIG-GUID: 6Aqne_xBxLQo_tlb1-XtsJIP1rREc49G
X-Proofpoint-GUID: 6Aqne_xBxLQo_tlb1-XtsJIP1rREc49G
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 malwarescore=0 mlxlogscore=999 lowpriorityscore=0 impostorscore=0
 adultscore=0 phishscore=0 priorityscore=1501 clxscore=1011 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105260040
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 26/05/2021 01:08, David Sterba wrote:
> The defrag loop processes leaves in batches and starting transaction for
> each. The whole defragmentation on a given root is protected by a bit
> but in case the transaction fails, the bit is not cleared
> 
> In case the transaction fails the bit would prevent starting
> defragmentation again, so make sure it's cleared.
> 
> CC: stable@vger.kernel.org # 4.4+
> Signed-off-by: David Sterba <dsterba@suse.com>

Reviewed-by: Anand Jain <anand.jain@oracle.com>

Thanks.

> ---
>   fs/btrfs/transaction.c | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index e0a82aa7da89..22951621363f 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -1406,8 +1406,10 @@ int btrfs_defrag_root(struct btrfs_root *root)
>   
>   	while (1) {
>   		trans = btrfs_start_transaction(root, 0);
> -		if (IS_ERR(trans))
> -			return PTR_ERR(trans);
> +		if (IS_ERR(trans)) {
> +			ret = PTR_ERR(trans);
> +			break;
> +		}
>   
>   		ret = btrfs_defrag_leaves(trans, root);
>   
> 

