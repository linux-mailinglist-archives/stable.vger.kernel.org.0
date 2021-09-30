Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 611AD41DC68
	for <lists+stable@lfdr.de>; Thu, 30 Sep 2021 16:36:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350660AbhI3Oii (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Sep 2021 10:38:38 -0400
Received: from mail-db8eur05on2120.outbound.protection.outlook.com ([40.107.20.120]:52321
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1348167AbhI3Oii (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Sep 2021 10:38:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VNLBjlAjhzyuMq0kHI27iLjdM5RKJR6erct+Z65uJGNBEikYSLRm76W6CrlWXKaj53LSk+GqrCx9dAjanfa72hYrUapVnMFYNLZzdvB3F6MQcrDMK9Xzw9CYcBwUfMV42hoYFGKYUnydh+TP3c1m0FXmPglm3NtPIG7p/6EgmuJ0p6+pZbkzu6Z9eh5ltC7SbQlh6yRUwkAHtxNwZ4IOOYXZmDs8rhAvDX1gGPuEpw8G/gLBmOKmCyFdYtC5XIGRrR1gFn6CcP7K6u2WCL41a8ihVwhyBqFg+yFJWXlFanaf+u0R24HHcUo83HHvVIl05z1yzqq4SYwwJ0GuAHgewA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=klIT//nO7OMM4/wM9GpTspKVgKYtnqEPJGQgwuUmmeo=;
 b=i3VBljhgDhib/Okf3so30enh9X0x9mMD9oHwT3Em+ZwmCaDfcuZB/lcsYmDGr7Z6CfTn/+i2nNUyiQ/7Vaz8msNwIvSMbiHrRO0JXLJZfWzbrze7SI1r1edh2629jeG+Pz3/O3GryYK612nvmD+5HJtJo2ZN+vYHrpQo8DY9JyazNl0DH2YVfinm6iIjlpbwOscNC7Ignl9t8ycwRgi4VcC1R0PCNAQQqj5exoEoJykdgHDvxluLHBp0MYdiQk9gFrEkJWTt1WS86ObM1Edw2csdzlqY8aKG7ywHogJCu+WShpMmi6eY4yqW8QIeaWxMhZlUdPPgiKbGN1nRiCzJqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=kontron.de; dmarc=pass action=none header.from=kontron.de;
 dkim=pass header.d=kontron.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mysnt.onmicrosoft.com;
 s=selector2-mysnt-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=klIT//nO7OMM4/wM9GpTspKVgKYtnqEPJGQgwuUmmeo=;
 b=JR2uzPKssGbdl6Csya6qfd0MwfVcjhyeuvwu2JGg0fkzajBIQ8WrfBR5ZTyjd+ym0fan4LKCeLsGBF4p1LKzBoIC/Fjby8LW+L995JSHq8fauW/TbBHzqvrUoDP/xBAb7JnPhXgQxjra9fO/acny3GkDHVM/75VHYq9qQrX2kfM=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=kontron.de;
Received: from AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:157::14)
 by AM0PR10MB2260.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:e4::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.13; Thu, 30 Sep
 2021 14:36:53 +0000
Received: from AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::216b:62be:3272:2560]) by AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::216b:62be:3272:2560%6]) with mapi id 15.20.4566.015; Thu, 30 Sep 2021
 14:36:53 +0000
Message-ID: <7f3b82ad-ff12-ce23-12a3-25b09c767759@kontron.de>
Date:   Thu, 30 Sep 2021 16:36:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.1
Subject: Re: [PATCH v3] usb: chipidea: ci_hdrc_imx: Also search for 'phys'
 phandle
Content-Language: en-US
To:     Fabio Estevam <festevam@gmail.com>, peter.chen@kernel.org
Cc:     shawnguo@kernel.org, marex@denx.de, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, heiko.thiery@gmail.com,
        stable@vger.kernel.org
References: <20210921113754.767631-1-festevam@gmail.com>
From:   Frieder Schrempf <frieder.schrempf@kontron.de>
In-Reply-To: <20210921113754.767631-1-festevam@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM5PR0601CA0072.eurprd06.prod.outlook.com
 (2603:10a6:206::37) To AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:157::14)
MIME-Version: 1.0
Received: from [192.168.10.40] (89.247.44.207) by AM5PR0601CA0072.eurprd06.prod.outlook.com (2603:10a6:206::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.13 via Frontend Transport; Thu, 30 Sep 2021 14:36:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 11697f78-9f1e-4bfd-061d-08d9841fbed0
X-MS-TrafficTypeDiagnostic: AM0PR10MB2260:
X-Microsoft-Antispam-PRVS: <AM0PR10MB2260AC10C2002CDF2B8E9D19E9AA9@AM0PR10MB2260.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:293;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WFEyHgiZgcXZLsFLd6z2knbpTrrdlVV19jnmvTuVHWOb653Shulw5tboo6gFJF+imMQyucr1yc4e2OOpxkRXUzf9mijTSosfeZE7k8HZwkuYfUFH1eOVgz8VD05OO+wWyhcMSlKiJapklVWIfuofBZEvbdnJwNahLAebc5IUkB9RWuwMpzu7bRHDkUuDSiQHOe1PvlyfXdQYh3paI8YYYsRM++hMo33/4CsM05Vt380vpjTB/7ovU88f7LY8TFY1BYS0SJay4QM9ioYi58NOpuXX6tU7TGoiVuQht/L38ASTG0SHTEyHzoietwjG2wjpYc9i7fG7/OwVbENznRqccaGX5ZXUKBWfEmXfSgdhpzetKZuwNWn2dI2Nr31crIylTpo5BL8WCppzOF5FL81Zry2A6YwBuiGuDj2so0stLfALl5V0n8K8BeduFYpr5wNwnLNllEePUp8ZdASkouYUyj0nm0XUTk5A+iV41R4lArRsToUhNCA/oFD61N6D93QtsfW9Pw5vzAelS8YfUllSuEdAQGQuke2/5CVmC6flj1677SxkTJhDQL9Xz3vT7izk0hTDO8v8pph8DYFfOCGFYyCEdhvKgRBZoZb+CkegEn2mCvghrjsOrEbOuxS8Dkx3Oy9k+OXVoFX32QzeUonvfR3nlicunfdDtQZJKNMfDAF/2BY7wTv3rhRWMsgMcktgKO4NbIL4BfYh3+msMlAAvdyCTqLoyhLmPzYhO9fVXyY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(66946007)(86362001)(4326008)(956004)(2616005)(44832011)(5660300002)(36756003)(8936002)(31696002)(83380400001)(66476007)(66556008)(186003)(8676002)(26005)(16576012)(38100700002)(53546011)(31686004)(2906002)(45080400002)(6486002)(508600001)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VUt1TC9FZnpjS0pIN25qelpUOE5rdngzdjlCZlMwNm9XRGRTWG80ZG5SOTFo?=
 =?utf-8?B?WG11RlZKSklocWRiQlhVU3p6TmhoVGE3ZDlwakZ5NkpjcVE2L0V2cWVnNVNG?=
 =?utf-8?B?UlJTd3R4SkU4OFF4a21VNDNlUzVYcHVMdFo4Y01iT0FENmhEUTk3aEY4eURQ?=
 =?utf-8?B?R1E2Zm1UYS90UFg4SmJTQy9iZU13U2Z6TDNXd1BndmFyY3R3TlpWcmFFSDkz?=
 =?utf-8?B?L3lkK2NsakFQNnFvZjB2MHRRY0RJZjhsMFJXNm41OXJwZHZTQktGai9DckRp?=
 =?utf-8?B?eVE0WjU2Umgrc3NoR21ZM2NJeCsxcHhZS28xWDRadmJ0TXQ1bzBvWjNpNHUy?=
 =?utf-8?B?S0NsVytrRFRvVlFFRVBxc0NUVXFiQjdLUCtBeGZVdG1LMG5BTzdsekJ2MGlM?=
 =?utf-8?B?VFBjckY4WUp0ZFU5b1NrQm9rRXNvQ1FqajcyMS9kUHYwTThoOW1zRXp0R25K?=
 =?utf-8?B?VWszMkFUMnRudE1DYWpGbUJlQjMwdGxEb09kMmZzZFA2WkFHMkFYZ29vTGk1?=
 =?utf-8?B?RkV3RGU1KzhNVGNMZzlDRHZhaFBOOFhCZmc5WlduT1JvaDVET2dlczIxRDRI?=
 =?utf-8?B?cko5Y2Z5ZS9KTEFrU3lIWktwRmJZNXVRYTZMQWx5YTFMSnVhK0RhSEtkTFg3?=
 =?utf-8?B?b0h0UWxqRVkzNUNEUS8vN25UMFJlYVVTUmNrZFB6MTFySVFrRmNlOUVJemND?=
 =?utf-8?B?UW13TzdoZkh1MmtWV0VITmNZOHphcHdDbkwxaXdlNFJ2QU1RVWdkQ1d5SG9O?=
 =?utf-8?B?L2k0YjR5KzMwSElTQ29WcDlRcTN1ZThGVGNrYzc2SU9oWkFTLys1Q3owaDZD?=
 =?utf-8?B?cW9SWHh3bFgxdE1vcjd1bVloblFuUllHT2Z1d2ExRkFUM003SGthTXViNFpO?=
 =?utf-8?B?NzNEMnlOVXFTUTBJbm9Qc3B3Z0NFZHBudFI0VVUydi9YK1Jub0VUdzM5Zy9P?=
 =?utf-8?B?a0RPSHZxeWY3TEVvOUlXS3ovMmN2TW84Y3IyU0pGamV5cFZmZW1EUzI2TXp1?=
 =?utf-8?B?eXB6dGJLTHkxK3BCQmE5Z0tZcUsxeWRISlo0NzBDdDRzSVhncHJtUnZ6V3ZM?=
 =?utf-8?B?VVVPN1Z3UldOaVZGUk84WUNaNTRHVzh6bWo4ZnFNWnJ3ank0YWFlYlVybjRj?=
 =?utf-8?B?d2t5UjlQb2ZRalBsUCs0QnBWL2lnaFkwajZQM2JzNXJOQ00yYjVXWUpvRU83?=
 =?utf-8?B?YkZmNWowTjNwbE1weUxQOVNleHRLQlRiRkJUZVhQMGpuWHlrUythRmIzeHQ3?=
 =?utf-8?B?OGJwNEE5djZZVjVzTHZMQ0NFNlZlc1E3OHVFSmVST04xdlZDSFI3c3lweWd1?=
 =?utf-8?B?TS94cjZZZWNYdVUrbkNmK2x4MXQ1VGN2dGpzaFFUL3ZTc1krd293NUszZ3Bz?=
 =?utf-8?B?Z0Q3aW5TSVUzbDluVi9VVTJFeXM5Sk1lQjAzbnR5dXpJQnVoaldPYVN5Wjlq?=
 =?utf-8?B?UDJxRk1LNmxRcnY4QWNxTzAxTURHWHRHbXVpSC9ubTlienRndklXVXNGUkFw?=
 =?utf-8?B?TUQyUlF4dDhVYmZpMEdYdmp0a1YxWGJJN2x6blBqZ21laE5zbmNPbFd5bHUz?=
 =?utf-8?B?NlFpUXRLRkt3bGQ4SG1LalJaakN1djJqaW45NzhpeE5uaDdWdDh0TVc1MWJG?=
 =?utf-8?B?MWZIbXpUQ3Ryb0pKUTNrRk5rajc0Q3c1cU9SKzArcFNuV29Xc216anp6WWRj?=
 =?utf-8?B?Qkt5SHI1QjJvSEk5akszVFlzYW5qSkVMZjQvQzJSREk1bndaUmpzZno1bi9B?=
 =?utf-8?Q?cHPN61gBTtYI70NKZ8mIHm8cHIctcY42lPtECO1?=
X-OriginatorOrg: kontron.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 11697f78-9f1e-4bfd-061d-08d9841fbed0
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB2963.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2021 14:36:53.2291
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8c9d3c97-3fd9-41c8-a2b1-646f3942daf1
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fk8S8jRfntDQABa3MVnSjhYQgPbc4bIL1+/s+i+1mGq7mYRroh8v7WByxru1YF+J+MXaa0XKelsZqX7DnihtCCejHOeE/EfgmtXNq0dsjlo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB2260
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 21.09.21 13:37, Fabio Estevam wrote:
> When passing 'phys' in the devicetree to describe the USB PHY phandle
> (which is the recommended way according to
> Documentation/devicetree/bindings/usb/ci-hdrc-usb2.txt) the
> following NULL pointer dereference is observed on i.MX7 and i.MX8MM:
> 
> [    1.489344] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000098
> [    1.498170] Mem abort info:
> [    1.500966]   ESR = 0x96000044
> [    1.504030]   EC = 0x25: DABT (current EL), IL = 32 bits
> [    1.509356]   SET = 0, FnV = 0
> [    1.512416]   EA = 0, S1PTW = 0
> [    1.515569]   FSC = 0x04: level 0 translation fault
> [    1.520458] Data abort info:
> [    1.523349]   ISV = 0, ISS = 0x00000044
> [    1.527196]   CM = 0, WnR = 1
> [    1.530176] [0000000000000098] user address but active_mm is swapper
> [    1.536544] Internal error: Oops: 96000044 [#1] PREEMPT SMP
> [    1.542125] Modules linked in:
> [    1.545190] CPU: 3 PID: 7 Comm: kworker/u8:0 Not tainted 5.14.0-dirty #3
> [    1.551901] Hardware name: Kontron i.MX8MM N801X S (DT)
> [    1.557133] Workqueue: events_unbound deferred_probe_work_func
> [    1.562984] pstate: 80000005 (Nzcv daif -PAN -UAO -TCO BTYPE=--)
> [    1.568998] pc : imx7d_charger_detection+0x3f0/0x510
> [    1.573973] lr : imx7d_charger_detection+0x22c/0x510
> 
> This happens because the charger functions check for the phy presence
> inside the imx_usbmisc_data structure (data->usb_phy), but the chipidea
> core populates the usb_phy passed via 'phys' inside 'struct ci_hdrc'
> (ci->usb_phy) instead.
> 
> This causes the NULL pointer dereference inside imx7d_charger_detection().
> 
> Fix it by also searching for 'phys' in case 'fsl,usbphy' is not found.
> 
> Tested on a imx7s-warp board.
> 
> Cc: stable@vger.kernel.org
> Fixes: 746f316b753a ("usb: chipidea: introduce imx7d USB charger detection")
> Reported-by: Heiko Thiery <heiko.thiery@gmail.com>
> Signed-off-by: Fabio Estevam <festevam@gmail.com>
> Reviewed-by: Frieder Schrempf <frieder.schrempf@kontron.de>

Tested-by: Frieder Schrempf <frieder.schrempf@kontron.de>

> ---
> Changes since v2:
> 
> - Added Frieder's reviewed-by tag.
> - Cc stable
> - Improved the commit log and fixed typo in 'dereferenced'
> 
>  drivers/usb/chipidea/ci_hdrc_imx.c | 15 ++++++++++-----
>  1 file changed, 10 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/usb/chipidea/ci_hdrc_imx.c b/drivers/usb/chipidea/ci_hdrc_imx.c
> index 8b7bc10b6e8b..f1d100671ee6 100644
> --- a/drivers/usb/chipidea/ci_hdrc_imx.c
> +++ b/drivers/usb/chipidea/ci_hdrc_imx.c
> @@ -420,11 +420,16 @@ static int ci_hdrc_imx_probe(struct platform_device *pdev)
>  	data->phy = devm_usb_get_phy_by_phandle(dev, "fsl,usbphy", 0);
>  	if (IS_ERR(data->phy)) {
>  		ret = PTR_ERR(data->phy);
> -		/* Return -EINVAL if no usbphy is available */
> -		if (ret == -ENODEV)
> -			data->phy = NULL;
> -		else
> -			goto err_clk;
> +		if (ret == -ENODEV) {
> +			data->phy = devm_usb_get_phy_by_phandle(dev, "phys", 0);
> +			if (IS_ERR(data->phy)) {
> +				ret = PTR_ERR(data->phy);
> +				if (ret == -ENODEV)
> +					data->phy = NULL;
> +				else
> +					goto err_clk;
> +			}
> +		}
>  	}
>  
>  	pdata.usb_phy = data->phy;
> 
