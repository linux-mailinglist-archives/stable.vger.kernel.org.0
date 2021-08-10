Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C41F3E55FB
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 10:52:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238357AbhHJIxO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 04:53:14 -0400
Received: from mx0a-0064b401.pphosted.com ([205.220.166.238]:16664 "EHLO
        mx0a-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238361AbhHJIxF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Aug 2021 04:53:05 -0400
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 17A8pNtr017175
        for <stable@vger.kernel.org>; Tue, 10 Aug 2021 01:52:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=subject : from :
 to : references : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=PPS06212021;
 bh=vM9yNFV21wPjQa18rJKSwchtl4hIiJBtdpkkXOzRefw=;
 b=QfhmPuiFt8SSWDdL5TuSexUAp1agi/wge+SgaN2sCbGyN/y7gXiqRqolB6pCCAUJzU8g
 inf5YA9ikfIqSS+Z9sXqMRkeZH+68JPgOKOrD8seWz5RZi/ZQZIrwazTt7OazV3O9e5d
 Yzdf6DX6dd/d82DglhVWYf+cth427QqocR8k5V90Uk+Hgyc2l/CvoaGYZBPNOC4buYIf
 StoqlodGAhxaPVQayRWoeEyQ706M3m5Cl0pxHlxFoBnb+dWSvbSJI1tHJDED6iWjr3cn
 aimdxw+kg4c6N8Q5HEn74dSUk1yjsKVCk/JkpBzcPfeVseR8Sp/mBG7QK3yE5bZ4hPcO 2A== 
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2045.outbound.protection.outlook.com [104.47.57.45])
        by mx0a-0064b401.pphosted.com with ESMTP id 3abjr3g3wn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Tue, 10 Aug 2021 01:52:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OMZkxJLc6o96yZDKC/WnQbfnBJGjfs5wcdjqh6YkGNj9Kr3xl7ySZYZxZQZx6I4tBK/e1cnZICcHLx/LEp+9lEDHGpTGcrv45DZQWOcenadqwa2la9/CRjG1o+IukDnvDerk7C6zUwLciS3NWUffuyUKc3o69aSLSXOEAynTvkM0C33/qQHsnr6KVYI97juGi5MEt0zg0DBn9llz4GJUH+I9itSpm8rTo35zjcOTSTBkm8HgK6IzKnVlXB52uPgLq7EuLRafTlEE89kSvQLNu8pC+zSM0pDIu/bpvHUryx4JBbZ035ZkYDcIhHYMLB1gDoZa9EFE79l1ciXq6uNydg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vM9yNFV21wPjQa18rJKSwchtl4hIiJBtdpkkXOzRefw=;
 b=AhiDx8TAS0qERjpZCUGgNdyhAiCqjh2XYt6T/YalXI1mK54y0OsEgKZ2mTvDj9IG3b3BSwMMg6Zfjk5aQ6rHSgJVkuvSJr1hQjJ1/piNgbH0yLWWnU+CZAO9Bp8EuvtTyIh2sJPQLgbjq6caAVdjL6N3l5fOqjQgsaSKrdrrrLc7/gO0OMjRLT6Rv4xfajuEx0vqVn72ef1TTqapZNtz6OE9boYaN/cQkSY9eQ+2GbPGLgF3p8xrqgzBg/YX+4O0XIeubqWqVJ/F3o2UU1zIzhrxABCkjmXNVJpW0xh1cu1kIUTQA9QjNpvmh+XyyQ9BKJpCYpUx7qohfccIVLfYWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=windriver.com;
Received: from BN9PR11MB5321.namprd11.prod.outlook.com (2603:10b6:408:136::8)
 by BN6PR11MB1891.namprd11.prod.outlook.com (2603:10b6:404:107::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15; Tue, 10 Aug
 2021 08:52:38 +0000
Received: from BN9PR11MB5321.namprd11.prod.outlook.com
 ([fe80::a906:97d1:e9de:5edb]) by BN9PR11MB5321.namprd11.prod.outlook.com
 ([fe80::a906:97d1:e9de:5edb%7]) with mapi id 15.20.4394.023; Tue, 10 Aug 2021
 08:52:38 +0000
Subject: Re: [PATCH 5.4 1/1] bpf, selftests: Adjust few selftest result_unpriv
 outcomes
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     stable@vger.kernel.org
References: <20210804172001.3909228-1-ovidiu.panait@windriver.com>
 <20210804172001.3909228-2-ovidiu.panait@windriver.com>
Message-ID: <cfaedc65-9659-1c78-7bef-bf051c577fc0@windriver.com>
Date:   Tue, 10 Aug 2021 11:53:06 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <20210804172001.3909228-2-ovidiu.panait@windriver.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: VI1PR04CA0119.eurprd04.prod.outlook.com
 (2603:10a6:803:f0::17) To BN9PR11MB5321.namprd11.prod.outlook.com
 (2603:10b6:408:136::8)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [128.224.125.152] (46.97.150.20) by VI1PR04CA0119.eurprd04.prod.outlook.com (2603:10a6:803:f0::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Tue, 10 Aug 2021 08:52:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7eef9396-4749-4856-9b50-08d95bdc347b
X-MS-TrafficTypeDiagnostic: BN6PR11MB1891:
X-Microsoft-Antispam-PRVS: <BN6PR11MB189136B751DFFE3075E6A89BFEF79@BN6PR11MB1891.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3nUamjdFD+8Jg2KjGILuAr9G5ZsrmqiUoFx1nBunorFMAex1moF3IghRI2VxvNqNj/aLTUZZt/hSExyvLjZ7ffms+w//u03UKzs/Q5w4PUT8WYvRIghZXwSBRdpBuqo9gZpaSODxZi2g6zzvf/KGl64y/0L0kDxsOsvNK9cYn+uaICf/Q69rdL7Ej8Wi5PWIcTikde5TMVZqd80DMA3zVdeyjZN7SPvBn8kJkELxdmA3DECHaYUXkb5U9PQCOJhqR/Im1m5GUEcI6CXpq9WnYlKitRdpNIn8PvUkZse68ZrVVe+iGeO9dPxoIA2rpzsok7nAWgBGcM38XIXt7whTcmWp/5L3k5SjyM+ztl7t9dOKkhb9w2dOdimlxYq1RcIa6jhATnMpJbeqUjLXAp2adUWoYrWCaa883OpKaEJ1fMM60R8iNW6bbhS1Mm82RVFXTH1JFg/2GhxS4UGIoAD2+GgWlGd30FEWaGnFnR4slMZ3LOGpdff7BN8MuLpHONR0R+o6zWX7IgV559oS7hDwlNdBGEV3FkbuutZxNEj5oDLfjJJ7B5mFZQmDMQNtjMMcuTX8K4Ph7TU7rCqVvwqA9gZTTPiVDGvtF550eoCni6QMai9HaRWV+rEkYLPuYPlzL80us7o72iBHkNJ4BAnmBItAi3dx2bWZMgxO7HlMS7RN3QUCa2I3i4BqX2J/aoKagaJE8YLTCDKlBWMPwIITeYhTXsbtcr8k9RJVmuqtUrG3jKfmLUH6t9JtU9FKBmsn5VXuvS0I7CcEqhminmkpopFVkbwvLwL61PK39tScAl0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5321.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(396003)(346002)(366004)(376002)(136003)(38100700002)(478600001)(36756003)(38350700002)(5660300002)(31696002)(6706004)(6916009)(83380400001)(316002)(8936002)(8676002)(186003)(66946007)(66476007)(66556008)(44832011)(31686004)(6666004)(86362001)(16576012)(52116002)(26005)(53546011)(6486002)(2906002)(2616005)(956004)(78286007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ejM3SXRJRFhZelJMNE12TnM0cERoellqRG9jS0R5dWhQQlAvU3BEUjNkeHlQ?=
 =?utf-8?B?N0RwdnJFV3haNHh3UWhlTWhyeUhJejV4U05qWUJFQmVBTjdGUDF3YTlPditq?=
 =?utf-8?B?KzdYaER5UlRPdWljK2djTFRYYzBXVDE4MittVU9FWU96N0xQWTF6eXZqTC94?=
 =?utf-8?B?NjhNci9iZnBwK2ZHcGdFbUIvS0ozYS81NEl1K21jNlI0VWRSOGkyQWN5M0pT?=
 =?utf-8?B?NXFxU0d0NWo1RUdaaGlIbkxhQmpMc3dmUS9mOWE4NWF4elNIVTY1Q0lHZ1k5?=
 =?utf-8?B?NzVZbFN0UUc0LzhvNVNCTjloSDkyY1YyTU5Ua2RvYjRUMnRnNmgxeFNmd2pn?=
 =?utf-8?B?N0lqMDZlNTk5RHdBaWcxUkRQYU43ODNzTUxkRGVzOElmRmlNZ2VnUGdvd1hU?=
 =?utf-8?B?c2hTVVgweHloNTljeit1UHR0dHNmVHJBeHlpUk1sSlFSR080aFZ2N2ZRemk2?=
 =?utf-8?B?eDlXQ01VckxkWkJJMXpqSlZ1NXh0cGcvbkM2STh4S2lpSE01WkU0MmZoYnVB?=
 =?utf-8?B?OXA4NHpoc1JPdjdRTUUrc1BtRDlQZjFrT2ZyM29Rc2ttb0ZpVnpDMmdPcGpj?=
 =?utf-8?B?Q3UvUEZROTZvWW1YK2txNDFqNWdNSkl5dVhTSUo0Z1dpU0NVSGFyb1BvQ0tW?=
 =?utf-8?B?cG16RERQZk4zLzlqYzl4ZnM1RHFTYnoxRWUzNnBPWXVyV0szYlNIUU9TZ3ZT?=
 =?utf-8?B?bkNXSXM2UFJVdnNlRi9iMXBNSG9YWjZpUGtHd2pSaXUwZnJWUzY1OHdIZTJM?=
 =?utf-8?B?RnlVa2dpT3VWVlNsWWtpS00relhFM0dEbHlFSXBTUStUMU90YVZuMGVFRk9W?=
 =?utf-8?B?NFlRMFdobFZaMjV3WDhLeEZWblNkMUw1RWRZcy9zVGtEcVRURWJYUVBZU1pV?=
 =?utf-8?B?Z1FGUFo2ZHI2VWtPbVVBVmsyMENoN3dDaFBCMW5nY29GQ0FKRWpEblVWcjlr?=
 =?utf-8?B?bVRPVXp1NFYxTG5NSFliYWtrR0k1cnB4bEVvWkVFcFdiSzkzV1V5R2ljSzFL?=
 =?utf-8?B?OHpyZjhRQWtiR1VTeFA4YWRoa0NxVEVCWGoyMENyVkpBelNGY1JZczlkc2JL?=
 =?utf-8?B?M3RESHRvZTQ3Umk0U3VWZXFrbGFUQjU5bUdiUWZIaVRHN0tmcXZFK0FtNnp1?=
 =?utf-8?B?bGorMnpjdm5wR0h0OVRlb1VlUEQ4OWk0TnhNNzZlUEN4c25WV3I1Z1VYOEgr?=
 =?utf-8?B?RmhaM21Xd2dMNi9zM1Zkb09xam9oM1JEQWpod1VlZDA2RVk1eFpxUUpDWGhx?=
 =?utf-8?B?MGtjdGgyc2NiMnZLVzhoWUVONzBublYyNG44QmhRbS9BMXBMOXZ6emFwM2lj?=
 =?utf-8?B?QzU5Ujk3OGNKcFhYNmFjaExkQ3IxS0JsTE8rN0JMWTFtajFSamc4a0pPM0F4?=
 =?utf-8?B?Rm04d3AwWm9iYVdNNUNrR1UwenZReFVLc3BUUVRFaHVvdHBpZzAzYXBkUFpI?=
 =?utf-8?B?YzBOaVdsYzZoV2t2bitXYVpwVkRHWUthTWlkVmxFRWhKVUdhZ3ZjRXJtTjlk?=
 =?utf-8?B?MHdXejBGOGhIZmhOb1JJZ2h6cjY2ZFpuZi9ESHlRR3VSYVFVeGZkMy94TDNY?=
 =?utf-8?B?NzlKRlloZzZmbDRyQlhLR2U2REVmeURtaFlsTUF4VHFrSkw5ZkJ1ZWNjeGl2?=
 =?utf-8?B?dUtDNGp0MGVjbElZeWt6R1RLa1VrNjdTdzJ1NFBGU2VqZGNla045QnF0MkI2?=
 =?utf-8?B?Q0dXZkpKeTEreVlTclNFUDZMaDhDdTJnOGZyTTM3czNjUlRPRVRMamcxem4r?=
 =?utf-8?Q?N75MSNJtYZw7oSNg7otrkqX1Pzo4ONYNMGzgI0b?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7eef9396-4749-4856-9b50-08d95bdc347b
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5321.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2021 08:52:38.2119
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eahEWHHf0Mr4v8L9RmaB6kT4O0mCyxIpwgGGnwoS/KS0rT5SsvjCkMciKQWXg4oug+sDb/HVIYznj+aYzbSRhG63u1bdjJyKRo4xDFeTC9g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1891
X-Proofpoint-GUID: ikstPcu66Kp4EYe4afbOr_mFiaS0MT57
X-Proofpoint-ORIG-GUID: ikstPcu66Kp4EYe4afbOr_mFiaS0MT57
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-08-10_03,2021-08-06_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501 mlxscore=0
 mlxlogscore=999 bulkscore=0 lowpriorityscore=0 clxscore=1015
 suspectscore=0 malwarescore=0 adultscore=0 spamscore=0 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108100055
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 04.08.2021 20:20, Ovidiu Panait wrote:
> From: Daniel Borkmann <daniel@iogearbox.net>
>
> Given we don't need to simulate the speculative domain for registers with
> immediates anymore since the verifier uses direct imm-based rewrites instead
> of having to mask, we can also lift a few cases that were previously rejected.
>
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> Acked-by: Alexei Starovoitov <ast@kernel.org>
> [OP: backport to 5.4, small context adjustment in stack_ptr.c]
> Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>

Hi Greg,


It seems that this patch was missed for the previous 5.4 release, could 
it be included in the upcoming release?


Thanks!

Ovidiu

> ---
>   tools/testing/selftests/bpf/verifier/stack_ptr.c       | 2 --
>   tools/testing/selftests/bpf/verifier/value_ptr_arith.c | 8 --------
>   2 files changed, 10 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/verifier/stack_ptr.c b/tools/testing/selftests/bpf/verifier/stack_ptr.c
> index 7276620ef242..53d2a5a5ec58 100644
> --- a/tools/testing/selftests/bpf/verifier/stack_ptr.c
> +++ b/tools/testing/selftests/bpf/verifier/stack_ptr.c
> @@ -291,8 +291,6 @@
>   	BPF_LDX_MEM(BPF_B, BPF_REG_0, BPF_REG_1, 0),
>   	BPF_EXIT_INSN(),
>   	},
> -	.result_unpriv = REJECT,
> -	.errstr_unpriv = "invalid stack off=0 size=1",
>   	.result = ACCEPT,
>   	.retval = 42,
>   },
> diff --git a/tools/testing/selftests/bpf/verifier/value_ptr_arith.c b/tools/testing/selftests/bpf/verifier/value_ptr_arith.c
> index 28d44e6aa0b7..f9c91b95080e 100644
> --- a/tools/testing/selftests/bpf/verifier/value_ptr_arith.c
> +++ b/tools/testing/selftests/bpf/verifier/value_ptr_arith.c
> @@ -300,8 +300,6 @@
>   	},
>   	.fixup_map_array_48b = { 3 },
>   	.result = ACCEPT,
> -	.result_unpriv = REJECT,
> -	.errstr_unpriv = "R0 pointer arithmetic of map value goes out of range",
>   	.retval = 1,
>   },
>   {
> @@ -371,8 +369,6 @@
>   	},
>   	.fixup_map_array_48b = { 3 },
>   	.result = ACCEPT,
> -	.result_unpriv = REJECT,
> -	.errstr_unpriv = "R0 pointer arithmetic of map value goes out of range",
>   	.retval = 1,
>   },
>   {
> @@ -472,8 +468,6 @@
>   	},
>   	.fixup_map_array_48b = { 3 },
>   	.result = ACCEPT,
> -	.result_unpriv = REJECT,
> -	.errstr_unpriv = "R0 pointer arithmetic of map value goes out of range",
>   	.retval = 1,
>   },
>   {
> @@ -766,8 +760,6 @@
>   	},
>   	.fixup_map_array_48b = { 3 },
>   	.result = ACCEPT,
> -	.result_unpriv = REJECT,
> -	.errstr_unpriv = "R0 pointer arithmetic of map value goes out of range",
>   	.retval = 1,
>   },
>   {
