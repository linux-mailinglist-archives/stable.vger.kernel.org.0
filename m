Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 074CF37F9DD
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 16:42:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234639AbhEMOn0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 May 2021 10:43:26 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:51498 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234472AbhEMOnY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 May 2021 10:43:24 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14DEf8ba025982;
        Thu, 13 May 2021 14:42:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=FPY79pjMdtwRN/3gYpViLC5jei0OSP4fW2/5mcVJ1W4=;
 b=Vb+3Uw5u6PdZo+soIwnnddmCfVVXkJ1htUl8+shrAdwQXxLaC7a3Ip/2RI7SkiHYZywJ
 dZKbABaRmGqyKdLbujqxT9Iw/q0s7e2EJ8mnnF/l0eHizR/FIQ3wp0co8trqrNoSTmyL
 DKXRUkNhMhv9QlIVtOD8PjuHXYyGVg+vCSpT2tUggiRWvhcGhU2Z2O05RgcpJLFtTEUd
 Se4qIzAQn8MopmVz660O8ew9/6KhwBtpnDR7TyP69Iunsm4dKp2NgIUEwhiL25EFDeOV
 bv5VsaMOr65WxCREBbrpYysSnpP6zpmfFrhQoFMVlqu7YlxapyRWHIo/S7H3f6Bq3vzp tA== 
Received: from oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 38gpqmga8s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 May 2021 14:42:10 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 14DEakPC004301;
        Thu, 13 May 2021 14:42:10 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by aserp3020.oracle.com with ESMTP id 38gppbc1xg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 May 2021 14:42:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lXcg0XJNx7XpcxFJ88F44XWN/xQMsrZSL3MvdrCl7ugdGKB8eTKh1OT6n7d5NWe7ICg+i/KGEKXzhBQoALfuYgCUUrIyzWri2DcIP6R9tReHNZhsQVEt9gGWOiBiqjP5Rk7MfzMwgw0rhP9m1VEKO+YX3BFKTM1wKtv7sE/Oi8n3EigqMVicUSZAtgCHWURnOHai84e6CB2VBGB6I2nUxQ/heYrGQt307YyBmACzFVEvSZdUiijbVAzObsAhcx2UBrj/NaMK66SlvkQ+99ww7KzpDEEUOw6YjPBdrYnb6wlQoC3Cso8KkZBxOeMq56d84A6QodLdEfnCmKIymMebpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FPY79pjMdtwRN/3gYpViLC5jei0OSP4fW2/5mcVJ1W4=;
 b=oPujRDnV7Bc3T6xKuzinEPoAa04W+M9sflgl1ZQIoM1pzSFYMDUPdnn8nZxpbqKDlGxukQ3HCwNloNIT69jos2EbSUYFcBD37le4QV8vwIFjGRP3y/VC9Dg+7RCdmi1Z6nl9sH1AWaS41uveKbMjtC0HtTrb9mGErycqomYcuOok3GIDMjbpvQUzDYwSYoCFmyu0o+mI4lD/9F0cK3+widBdtUNO3YEPOhFajGRVFaA5d/HtEJBbJMd0lxXdnxwX6v5eaRmLkc6PXkVTUe1Mrpbe8LJjEA/D2DJ6+ZxZp4ILdy2byiAEQAntPDF4V0hdxTuXkBj/JKm0TBLjVdxRoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FPY79pjMdtwRN/3gYpViLC5jei0OSP4fW2/5mcVJ1W4=;
 b=tLVPmW2qzGJRzSDbfsj4Igrp7RzK+PtuNLg33eQTtjI53KTGnZ194kv/wKQ+vMqtSivRuunTrCU8mw9gClH+CU3pL7ehr+MWZVZPQ4GrdFr6ZBYx0wrg2W34acd+hJhoT4CPRV3VY/OpkY8aJ7VdKtYpPRxOTIoTivf6G4JmW1U=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SA2PR10MB4425.namprd10.prod.outlook.com (2603:10b6:806:11b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Thu, 13 May
 2021 14:42:08 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::168:1a9:228:46f3]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::168:1a9:228:46f3%6]) with mapi id 15.20.4129.025; Thu, 13 May 2021
 14:42:08 +0000
Subject: Re: [PATCH] nvme-fc: clear q_live at beginning of association
 teardown
To:     James Smart <jsmart2021@gmail.com>, linux-nvme@lists.infradead.org
Cc:     stable@vger.kernel.org
References: <20210511045635.12494-1-jsmart2021@gmail.com>
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle
Message-ID: <93695239-3f4f-f937-cd01-1f17bbd97951@oracle.com>
Date:   Thu, 13 May 2021 09:42:05 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.1
In-Reply-To: <20210511045635.12494-1-jsmart2021@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [70.114.128.235]
X-ClientProxiedBy: SN7PR04CA0047.namprd04.prod.outlook.com
 (2603:10b6:806:120::22) To SN6PR10MB2943.namprd10.prod.outlook.com
 (2603:10b6:805:d4::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.12] (70.114.128.235) by SN7PR04CA0047.namprd04.prod.outlook.com (2603:10b6:806:120::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Thu, 13 May 2021 14:42:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b5a302ea-9adb-46b7-bbff-08d9161d48a2
X-MS-TrafficTypeDiagnostic: SA2PR10MB4425:
X-Microsoft-Antispam-PRVS: <SA2PR10MB44252F2A039AC9D6AFF159DEE6519@SA2PR10MB4425.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vuVScJoMHSS2oTU9bclElOc/9J3ZGdtz3zKIiqq5Oj2zwjsHYvL+K6pyv+5JV7QYmcsKyz1cf80u7DK1Tfhre7ZEXu4XSwxTNSpQQeW5IytLYYDabguEJ5sBj+sSQEuBlUd+1iG0yKYwpCbIbkFa2FnkGtmZjOjiWNIJqrlaz8NVCuu6kB4WDGiMiPJ7/iSh6IpJUARJaMkPTQ/kFYeabM2qQXIPT2hq1jrRFzkDfHwLk+5l//leRspyevW9xQ9RkyXAGethgHbmPL9J/Y+NNYZPpVDkaJFFd2fi5qqw8kRdMQwhFCyXxo/3K+mZ67keXMTwJdcQ9M8EP+GP0Tk6OWAP/5m5vwRG6nmGmyAKnymh/d3+F2pZDrC3QHG04BHdJKBZEs3cCg9Qo3pKS9JWMKJ4DgaVAyVP/ei55jHwShN4BLgSxrHMyroWVF5XUMyMFYloekv3PGexGtxAY5OOFv0px2ssHAO4xlm6jF+pGA/shM6oMLD1WbioUXUfpQ+N/HnKAqEyT9xIseKxTeY6AvD3nzTZfAOW7/UGXVrvdameWUV41/uqARE/Cyzs8VrsX1DqfaM76GNRNfeKSpoMW5n3KeeqRqFahvtJpA2Q09nBtGKuhRlQXHVXpyrMwQAusz6bQpU+Mrqgde0FxPoAN0POofa7DdhimlzSQkVFFYesnop1zeLcW6eIcMnlT4YV
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(366004)(396003)(376002)(39860400002)(66946007)(31696002)(16576012)(66556008)(8936002)(6486002)(44832011)(956004)(2616005)(16526019)(66476007)(316002)(83380400001)(86362001)(5660300002)(38100700002)(8676002)(26005)(4326008)(31686004)(478600001)(36916002)(53546011)(36756003)(186003)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?MUdVUFIvNXEwNFE1ME1yUG5GZXVoU2ZvQ0YxZStpTSsrV00raFpCVXdVWFNw?=
 =?utf-8?B?NThmWFZ3Unl2aVhVTnZYWWt6MGV6NVp5MUdLWW1mZE5oVkRvSzlkS2F3ditC?=
 =?utf-8?B?OG5iSy9ER0ZKaGY0UERqeU5DK1QwR25WenZTVnc5bEUzUUs4dS9FanZJN0Rm?=
 =?utf-8?B?NTdvd2RtZ0JVY0NObm0zUWFjYTBRZUxtdG1PUlFtNGVuVEpoM3lJa2hINk82?=
 =?utf-8?B?SzdNOXpoMjdMTHNXMkxjVTB6dGxqcHFDWjI0T1ZEK1VSNWtTd1dCZlZBeE8r?=
 =?utf-8?B?SThXMlYvV0xCSXZ4ZkJGcU1KdlFmY2g2S1dmeUFVL3phMGZ3Y3lMK0QzcFBE?=
 =?utf-8?B?LzJ0VWNXMURVbEpRRTdxRERBbzhVTmJpQUdvMnJGcG5GZWorc0JTWDJyRDAx?=
 =?utf-8?B?TERNc0NtUFQyM0dpMXFpZllYZEdJZ00yZDVaN0UxcWFURHZybDNzWVpYcHVD?=
 =?utf-8?B?ZjJ5Q0FnRUFJdkhyVnVVK1QydXVSYVRwaTVkUXkrZlpTK09rRGMrK0RLRGQv?=
 =?utf-8?B?ZXVkbmVQWFlYbEx6TnRGVHYrMXc5ODI4QWpoeGJwMVhqUHgybFpQRkxtMVZq?=
 =?utf-8?B?Zjl6REZzNlVHa1JvTEJhNTdWeWNzbWdnT3FiY3VNa3pCeDhjUlZwK05CZVZh?=
 =?utf-8?B?SXlVUGMzUnZYV0IyZllvYTdPa1hHRTZtWGUvQXJNNDZVekxackZRTFo2SnYw?=
 =?utf-8?B?bzBmais5SmMrTkVXcEVJdms1TjhhUy90amk0VDlwT3ZPVk4xRk5rdzhmYUZ2?=
 =?utf-8?B?TXZnaUpua3ozbHNVdTNreUtCKzgzSGVkRDBabkkxRkFEV3pONWNwNE9nd0ZY?=
 =?utf-8?B?TnFYTDU2UmFDZEMzVE9aUHVHb3N0U0wrVWRQVDdsUzBqVi83MnRMb1p6dTdI?=
 =?utf-8?B?NWNSRDFXYVkzMDRXaVNkUG1PYnMvbWVsRjUvYU9EUGJ1N1BnanpjTlkzTjQ3?=
 =?utf-8?B?UlcyaHVHQzZGcDVHeVhReW8raUZoaW1IanVoT2hJaUdnSEdvakk3dExYaVRR?=
 =?utf-8?B?NmIxWXNGMTE3VG1OOExyTlZBK09tMEN1c2c4QW5GWHhRUU9HQndQMk0vWElB?=
 =?utf-8?B?Rld2RERnellXL0UyZUJ3WGNiN1B1MTJOa1N4cXpDMm1sVXU4TGZVb3R5RGEz?=
 =?utf-8?B?TVlXdDdmb0dwUXhnNGlWTjhFZGRMakhobFJvWGFqSUdTbm0weGZQeFBSYzJN?=
 =?utf-8?B?Y0Q1UXU5TnBvN1NKTzBxMnJSWVArbVR1RXhMN2hEdk8weVAzcHRNSnI4OTlO?=
 =?utf-8?B?UVlWR21FZVRmRzNSTjBaOXNPTml4M3lhZ1h3R2w4RlJMK1YvU2V6TjNwZXlB?=
 =?utf-8?B?MSthZXVUV1UyL3JDa0tKR0pMdjJTb3VVYm52UWJSYXNMUVdQRll0UndNaTVE?=
 =?utf-8?B?KzRvbGQyVVFySCsyamNzL0c3ckdlWUM1Q1hBTFF3M2FwS25DcytxNUY3NVdS?=
 =?utf-8?B?dVE3dE05Yjh1aXJPYnRtUmxmVm53UmhBS0NuUXVnRDNNMVVyZU93c2dvTU9E?=
 =?utf-8?B?T0FoQzdDM1VKMDMvSENSbnJ3V0thNjJzUFhvMEFSMzBhUjZnQ1ltYkdsb0NN?=
 =?utf-8?B?UnJPQ09RNUU2czNocitGcjJtWDNML05rK3hBemduNHkwQU9Nc0wrYVB0MEVT?=
 =?utf-8?B?dUNWOFBZOTd1ZkszRG9DSVU4R3hiTFFReUlUV29BOEJub1VDZzZjWC9wMllY?=
 =?utf-8?B?bzk4Z2FqdFF2K3FjN3FQWUp3QkgvT0xjbFRtVFdiZ0lJWG1tUUVsQW1lcHZz?=
 =?utf-8?Q?nDQmZWz+Kb9Ip/3EaPzl7dDI59I7JGbwP2tM+Yu?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5a302ea-9adb-46b7-bbff-08d9161d48a2
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2021 14:42:07.9911
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OE6Z0pjGl0CIJTeADkKOrRgIlPNqLcnAAFeLMl5ymWsa0MhFFpyYao/tGZS8tA5KcyIy+lAngZNRNF4aqwx6LuyrGMe3YMMSzykP8EVSXxQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4425
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9982 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 spamscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105130108
X-Proofpoint-GUID: 7_gmIZELK_aIC5I97MS_XfIMIs0EBEO2
X-Proofpoint-ORIG-GUID: 7_gmIZELK_aIC5I97MS_XfIMIs0EBEO2
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/10/21 11:56 PM, James Smart wrote:
> The __nvmf_check_ready() routine used to bounce all filesystem io if
> the controller state isn't LIVE. However, a later patch changed the
> logic so that it rejection ends up being based on the Q live check.
> The fc transport has a slightly different sequence from rdma and tcp
> for shutting down queues/marking them non-live. FC marks its queue
> non-live after aborting all ios and waiting for their termination,
> leaving a rather large window for filesystem io to continue to hit the
> transport. Unfortunately this resulted in filesystem io or applications
> seeing I/O errors.
> 
> Change the fc transport to mark the queues non-live at the first
> sign of teardown for the association (when i/o is initially terminated).
> 
> Fixes: 73a5379937ec ("nvme-fabrics: allow to queue requests for live queues")
> Cc: <stable@vger.kernel.org> # v5.8+
> Signed-off-by: James Smart <jsmart2021@gmail.com>
> 
> ---
> stable trees for 5.8 and 5.9 will require a slightly modified patch
> ---
>   drivers/nvme/host/fc.c | 12 ++++++++++++
>   1 file changed, 12 insertions(+)
> 
> diff --git a/drivers/nvme/host/fc.c b/drivers/nvme/host/fc.c
> index d9ab9e7871d0..256e87721a01 100644
> --- a/drivers/nvme/host/fc.c
> +++ b/drivers/nvme/host/fc.c
> @@ -2461,6 +2461,18 @@ nvme_fc_terminate_exchange(struct request *req, void *data, bool reserved)
>   static void
>   __nvme_fc_abort_outstanding_ios(struct nvme_fc_ctrl *ctrl, bool start_queues)
>   {
> +	int q;
> +
> +	/*
> +	 * if aborting io, the queues are no longer good, mark them
> +	 * all as not live.
> +	 */
> +	if (ctrl->ctrl.queue_count > 1) {
> +		for (q = 1; q < ctrl->ctrl.queue_count; q++)
> +			clear_bit(NVME_FC_Q_LIVE, &ctrl->queues[q].flags);
> +	}
> +	clear_bit(NVME_FC_Q_LIVE, &ctrl->queues[0].flags);
> +
>   	/*
>   	 * If io queues are present, stop them and terminate all outstanding
>   	 * ios on them. As FC allocates FC exchange for each io, the
> 

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani                               Oracle Linux Engineering
