Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 305865A0D46
	for <lists+stable@lfdr.de>; Thu, 25 Aug 2022 11:53:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240839AbiHYJx2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Aug 2022 05:53:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240886AbiHYJxG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Aug 2022 05:53:06 -0400
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10077.outbound.protection.outlook.com [40.107.1.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4266EABF0A;
        Thu, 25 Aug 2022 02:50:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ss9MezrMRiy9KviHtIlLuACS85pEn3ZY0dmHYBmXZtVTpirhKEo8b3XuQjzzlfj/ogvxT8sADksLVMLcHp1hIZdEurOx3HXI2ma4V5XvhUESujI9XqbYQCHz4Ua0/X62l42s81PBWBWpmpy8Ba4ZvyjKVLelgM05xA039OYCa2N2Q2gE/A67rN5vxGYIxrmi3OTNNF47f6BGhEpuScLcyHBoSRNW2uRcq0UmzfBEyoKVMkbT/SxKxufHtkZQOTR6Vx6RlicOtSu6zwJrJxrnVVv82S/flb3veGwYBbSuu5rIz8atmpwobnLAMRnssIYMwEvlTgNZk93AdgxCeD7qoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LxT+5NAiXocn1FHo46V4cbpVzJwy9brM9OUlwqFBq0s=;
 b=YQEDVx+aOMm3MrTQUVb/ovJo8qyMDZaO6GxXa4VcTdEvO+c0lqMGJaNJQ/o3PZGt3sSyFV0dxYTNPBIyBKDFa5xbEsye3JHrgKqqiqjxLWOIYECPrb2lLc6BueH8wkxEI9j5eFQZivXXJey3sXkaYNB4A7IYVeDTTZyNlCQgVmmkPFX8KcVXUqJjP6/VqCiSK8n1KGx1Luj6lo0V9tpEBHQtL8A4TTT/JWx9VSXc+OU6KbQAaAYMQ88bi5LhUD7W4J+GRnKtzDsD1npy96vOqF0M5Z7i9p+jf/Arnz7UM2Ie1J28T/F837uD21C2mrF+gbvtF3RUqcQaxCil9bap1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LxT+5NAiXocn1FHo46V4cbpVzJwy9brM9OUlwqFBq0s=;
 b=Fz+atXaDGjk63vVpQpZGqT2w4JajL49PnfnJANRudVtQ/wWi7nU5GBiqErsbFBHv2qXVhDICYp6XGkfsFz/E4dAShpBEh6kugiyzZWoC9huDj3EuyO21egVB/jJ/fALzsbR2X9jlPU7DPQRcRiLez1YqS7O+Nq1fodghQX6gl2fhZ5+2deVpgYC3fb6V76y7tYML80L8+kChiRvwLiookRUAB1L1r7ta1dega5EZP650EjQ4KIB27NtoqGQcccDfrhmHk1Lq1xWAgebehbx2MKlpayzB3IG7v6V4DZair22am+7P5U9nPI7KDcUQ/7+noo9iaaeXFofXjjWyk3P2tw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VE1PR04MB6560.eurprd04.prod.outlook.com (2603:10a6:803:122::25)
 by AM5PR0402MB2737.eurprd04.prod.outlook.com (2603:10a6:203:95::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Thu, 25 Aug
 2022 09:50:27 +0000
Received: from VE1PR04MB6560.eurprd04.prod.outlook.com
 ([fe80::2d5d:bae0:430f:70ad]) by VE1PR04MB6560.eurprd04.prod.outlook.com
 ([fe80::2d5d:bae0:430f:70ad%4]) with mapi id 15.20.5566.015; Thu, 25 Aug 2022
 09:50:27 +0000
Message-ID: <2c762b15-fd7e-f14e-fcc9-a083af683e4f@suse.com>
Date:   Thu, 25 Aug 2022 11:50:25 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v2] xen/privcmd: fix error exit of privcmd_ioctl_dm_op()
Content-Language: en-US
To:     Juergen Gross <jgross@suse.com>
Cc:     Stefano Stabellini <sstabellini@kernel.org>,
        Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
        stable@vger.kernel.org,
        Rustam Subkhankulov <subkhankulov@ispras.ru>,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org
References: <20220825092600.7188-1-jgross@suse.com>
From:   Jan Beulich <jbeulich@suse.com>
In-Reply-To: <20220825092600.7188-1-jgross@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0086.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1f::13) To VE1PR04MB6560.eurprd04.prod.outlook.com
 (2603:10a6:803:122::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f97a8ffe-43bb-448f-282c-08da867f3d60
X-MS-TrafficTypeDiagnostic: AM5PR0402MB2737:EE_
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SrjBX1g7hR85KPEdSEI6Sl54n7xgh217Djq5wgtLKURnP2TDlyPvHv7ZJHo7o9xaAK7HWYpE4YCTDKaziPoz8uf7QT2JRByJ0GbaPmmLQvqfE+4U32GVegJTPoXL7eI7sXaUwVvkc0q2yCpvKco7KEpN+Sj/QZv6xUoPXdUOyrPmnCUoam6XPLkGZyf06s9i01N/0awWjgfDsUo6jfOFNFUH/tLpGyKDe4XYT68cRyMga4RFKatLnCFRDB8jMeA091vb8M6MbCiVo/gwTVUAyNRkwJSlYAsFfYbSWXTzGQq3Cxy8nLmg0CrxDzicr6rmdKpbn6V/5HCEJTAleAPs458inQnZmF0BLlnf5ydUKI2SzOfyXeYpl2w/yfdYkX7no3e2UhbGP+P/PWqFJ4yUl0sY337DoG/E+hcXPbKv/hOr3Bq8Fysp41qPUOZnyMPsksWkgTY1DjE0tKy3wWIFn7c41YXXd80TqIxn/+0zrjjjLhV5CuN2Ouv4NkKiqkt2ld+B5hiBAEZwzm/xRQU5NFCRj6ChsNLCQQXXoGM9CDNmnhdgMDDW/bXCjRPUtdHYklk72MctJPtt/SR/2BJD6H/DJ9/hLgsz41eh+f5dJeFXcidISNjOkMxRoQZZzc8RtIDw7kccfgHjEKdMnx918aS0b/yBC+w0sp1CipbH6cf2kQ02Yy4TYMDebxtsL/3PCdJLPA95yrkj9N5VUGmSCb0sir82ZiNgL2dIkrCU+FJc7KCVBPWDMe6C7h5Qpdxcu5yD7d0ljUsv2pgAF/LndIyfHfvLVwCf8MnHGN5gJaI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6560.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(136003)(396003)(39860400002)(376002)(366004)(66556008)(38100700002)(4326008)(6486002)(66946007)(66476007)(8676002)(5660300002)(41300700001)(26005)(6862004)(8936002)(86362001)(53546011)(478600001)(6512007)(6506007)(316002)(83380400001)(31696002)(36756003)(31686004)(37006003)(6636002)(54906003)(2616005)(2906002)(186003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ekVOb1ArYUxRZFpFa1dYNnQwclBoeDlSSlcxSXNaOWZWV3BQOTAxN2xzZ3Ez?=
 =?utf-8?B?cUgxd2ZUUFB0NnhDRzlzOHd4MllYaUVpZWRmd3ZnRnZCbXFBa29ZbTJuNEhz?=
 =?utf-8?B?RWM1RjVXQ1daMzRVWm1aNEFkeDlsaUFEbjhOYmRRYm1wRDN5TnRrdksxRElF?=
 =?utf-8?B?VTdwV0hiSldNeTFYR3RDRDBxODYrZnV5Yk5HVG80N2NrdFFHZkFOSWdpOTRD?=
 =?utf-8?B?bGR2dkVUeVE5Q3IrV1RQTmVZK2drenNhek1UOEw4eHlCdHZ3RHFVNHRKR0FE?=
 =?utf-8?B?Zy9Va1dmQWZqSTBEVEdkL1ExMGdoeFlQWDBpOVg4S1lBczN5V0REQm92VFhp?=
 =?utf-8?B?cEVaQjFyVXBmem9HYitmRm1vUGtabFI5SmQrS2JYWGpPenkxbkRwZlJHcUtL?=
 =?utf-8?B?NHg0RGk5WUYvRlhiTU1PWnRXL3psdWtEL3VIWDdXaTNyVFN3UXBlOSszRkU1?=
 =?utf-8?B?V2xxUVY2am9MME4vTUoyT0FLd1J6UDVYS21wclhpWmtGWjE4SFprN2xPM1ZH?=
 =?utf-8?B?ODRueXp1TnJlWWVtNlRXVUZGR1JFTlBVYUVoRng3WXM5akVpRTd6aFNraDM0?=
 =?utf-8?B?aFc0cTlvaGNmbUxjOTh0a0k3OXJNWStGV291NzNJUlNHdnBZZWFPb3pzUno1?=
 =?utf-8?B?Q1R0TktCclJPNDRqVTNSUk90UXNxaTJNZXlaT1pmQVhpS2xQK1dOaHdjQU9s?=
 =?utf-8?B?TCtEUlJVcTZEZmpHSWZKMWVxc1JYYTNBdUZkN0dXNGFQbWo3RGhIL3BrQmRu?=
 =?utf-8?B?eVEzWjRyZjlRSmZIbi9OSHhIaVZtYXp5NmpneGcxQm5kRmN5RDM0NFYwTmJT?=
 =?utf-8?B?Nzg5eGJ5UkVuTXpzZmVNbnMxL0J5UlI2M2dCSVI2TnpCTk5ZeW5yZ1g1UVJK?=
 =?utf-8?B?bDh5SFZRdnpaZDYyOThnYVozUFo0a1BibkVFOE1jSENxcjQzMzhrejUrZEgr?=
 =?utf-8?B?OEdjWmRNOTNrWElINngrS2kzZU04dTFkVWg5NDYzWnE2bGE5QmY3dnRqUi9D?=
 =?utf-8?B?RG5BcWJMNnRBK3NBTWR0alg0REdWMVdhSGRHVTVSSTg4bGE3YkNoWEt0UC82?=
 =?utf-8?B?SW5sam55RGVXYmxnNHcvbE1CS3VBNVpqQm93YnZGd3FySVUrdTJJN1RZLzhZ?=
 =?utf-8?B?aXJTUzJNTDJjcHRSNytjWkxwSmUzWExBaVJtRkcyejI1QnFqSEF4YUJwQ0xL?=
 =?utf-8?B?T0pwZUVMOUlGcjRFTnhLWXBEYUVGY0tkV3J6VDZMYnRjMS9QdmNnd0pLUXNx?=
 =?utf-8?B?ZjNXT1hraXV6ZWQySzhZbG9ZSnJoODlKTUpQenMxTlowL0JSL0hJTm1yZWt4?=
 =?utf-8?B?akMxNWhEbXJUMk11WDVTSDdJWXZLbXVxbW9yV096T0pEVjR0R3VxVmZLcWMw?=
 =?utf-8?B?b2UxRXlXVFlEdHFCajduL3BlNklvOStBWDRGZE50UjJxdDAxeUEvNXNPL0FH?=
 =?utf-8?B?RG1NZGlIL3JWZGdkSG82YysxK25Eb2t5Um9aR0prNzh4ZFdZdkRFNFVJNnpM?=
 =?utf-8?B?VHNQamJ1NzdWNDF1RFptcWsydHJUbWEzOGFzelpOWGlmTTAreFN1Umpla1o0?=
 =?utf-8?B?Yk01RURoYmg4N3k0SzhrTER5ZHJXaUxpbmRBWk9wSHBlbUZpUTNSRjlPb3Ir?=
 =?utf-8?B?MGJPQitlNnd0Mk9FQUMxdzJabUNQTTF6dHVpSmRUMkVaNk9BaXloRnNjM3M4?=
 =?utf-8?B?WXRRTG1rS1lPcC9lZndRSndabnpBUGxaNGpYOEdGS3RWUzZvYjZPOUNxZ0xq?=
 =?utf-8?B?Z3VGS2RBN3FTYXEzVU9XdWdMWFowcUJMWE40MDNNNWtqZ1UvR3ZmUVM0ZGZ4?=
 =?utf-8?B?cGk2RCtJSnJHeE9rYjZGbFkzWnAzYS8vcllZVCtKbTd5VzlPOWhyY251T3Iw?=
 =?utf-8?B?N0wzcDF4SDFZWDVKVjhUYVN5d080TVk5SGxRci9MZWc2T1VudzNvZEZUZTU4?=
 =?utf-8?B?cVFRSjZnN1QreVRHcFJ4dVppd09ybnd5ZFFFWmZLem1kWU4yK2dWeHR0a0hn?=
 =?utf-8?B?bHU4OHBhaGY4MTRhQW5ZblM2dUh4V2ZaZi9iUkcybll2SzVoWkhZQitDdnoz?=
 =?utf-8?B?aElzWnkrKzk4L09xWmZEdFl3TmxPYzRoMVJlTkk3OE5zUXZmUDFqME96MFMy?=
 =?utf-8?Q?09A5vrtdjHtnoyIGp8OitZJno?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f97a8ffe-43bb-448f-282c-08da867f3d60
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB6560.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2022 09:50:27.7058
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eFseiJNM2EyK04kOXO0WoAMstTmnVQX2gsWzdHdjngHzKgBJslyU5kW8Xq6gUmOapOvZaT1t1WRrO/212h9zEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM5PR0402MB2737
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 25.08.2022 11:26, Juergen Gross wrote:
> The error exit of privcmd_ioctl_dm_op() is calling unlock_pages()
> potentially with pages being NULL, leading to a NULL dereference.
> 
> Additionally lock_pages() doesn't check for pin_user_pages_fast()
> having been completely successful, resulting in potentially not
> locking all pages into memory. This could result in sporadic failures
> when using the related memory in user mode.
> 
> Fix all of that by calling unlock_pages() always with the real number
> of pinned pages, which will be zero in case pages being NULL, and by
> checking the number of patches pinned by pin_user_pages_fast()

Nit: s/patches/pages/

> matching the expected number of pages.
> 
> Cc: <stable@vger.kernel.org>
> Fixes: ab520be8cd5d ("xen/privcmd: Add IOCTL_PRIVCMD_DM_OP")
> Reported-by: Rustam Subkhankulov <subkhankulov@ispras.ru>
> Signed-off-by: Juergen Gross <jgross@suse.com>

Reviewed-by: Jan Beulich <jbeulich@suse.com>

I have a question / suggestion, though:

> --- a/drivers/xen/privcmd.c
> +++ b/drivers/xen/privcmd.c
> @@ -602,6 +602,10 @@ static int lock_pages(
>  		*pinned += page_count;
>  		nr_pages -= page_count;
>  		pages += page_count;
> +
> +		/* Exact reason isn't known, EFAULT is one possibility. */
> +		if (page_count < requested)
> +			return -EFAULT;
>  	}

I don't really know the inner workings of pin_user_pages_fast()
nor what future plans there are with it. To be as independent of
its behavior as possible, how about bailing here only when
page_count actually is zero (i.e. no forward progress)?

Jan
