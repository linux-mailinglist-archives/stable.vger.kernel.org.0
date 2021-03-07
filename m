Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF8C5330266
	for <lists+stable@lfdr.de>; Sun,  7 Mar 2021 16:01:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231313AbhCGPAu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Mar 2021 10:00:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231258AbhCGPAZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Mar 2021 10:00:25 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AADF1C06174A;
        Sun,  7 Mar 2021 07:00:24 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id dm26so10807178edb.12;
        Sun, 07 Mar 2021 07:00:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=tK3D7yjk9Hj3Ps1I1v43ujhrrVGQwWkl1RCv5uCMAHQ=;
        b=bspNffffsnVhQBnQUMPaI3cCZPkTCXb8hcB8RzDjVP63YK3mGqzCyDUipFuNESZ0BT
         zyDh6f7zz94zKDq0qTRFj+U7Gx25X22u3VXi70IXEMWFC/joRDQzDkuGE/yFHTF5LK0G
         rUlSBB34D6ZuIbfCQmR9Rb7/GB6oBCQNTO+CfoVC4cgNL8U/icP9/4VUrxXuAP8YWySp
         d2DSRR69g5ztE7ENaM4Itdydc1SyxER823J2+9sFP9tmY+CdrRB7IRrjm8JKhHaWs0tK
         3CnF5/G5IB6C0ESLTZSu8RPDMYOnG7m93ItlIJ8NAHQak6UVkJim3FppzoVNpNM/bNB2
         VwPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=tK3D7yjk9Hj3Ps1I1v43ujhrrVGQwWkl1RCv5uCMAHQ=;
        b=mYlZNEcZcjR+pW3NtO6dn3kuDfUGQmm14qfGmCMFl49VIASetDISi3mWkQy39D4MFw
         VSDrOTDRAB6wCVsYDufQKMXYbMIXmdC83PQVgXVLjfNvIItTy/ZOMP3VapX4R1+gvyQ2
         vvTEyT/G9XuKGQLXokeDgsPt3XxctBrjA3xK80PS0+lW+UIlsiRfCtCRMqEdgYGGrURl
         0btVcrW/+2A0MaZTcKFG/U8bMVa4E1Cf1yf/d7gKIVBitBWYqmcnOZkGnRd8X3w8wRbS
         +MWcdMMXYYUAlDAH+i2L8T4XEgkX9SqYZpVB3qY3y/7wKZWKOhxU0s+0NqKGaJOK8eso
         Dh+g==
X-Gm-Message-State: AOAM533381uQNqlx8kbWjMX6z1MMdcg4ChffZOFeU0ewVCRUod6ZLYYB
        egouM5QeAmwL7PR3lIQp2NE=
X-Google-Smtp-Source: ABdhPJzI0+1FOr6rWPD9DIJ0k7fn0QFArC8QJEQ6604yTyFxtXl0WI89GnWCXXOpg5b058I8maQwoA==
X-Received: by 2002:a05:6402:c0f:: with SMTP id co15mr17775180edb.373.1615129217591;
        Sun, 07 Mar 2021 07:00:17 -0800 (PST)
Received: from [192.168.1.2] (host-87-242-23-58.prtelecom.hu. [87.242.23.58])
        by smtp.gmail.com with ESMTPSA id m7sm5209000ejk.52.2021.03.07.07.00.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 07 Mar 2021 07:00:16 -0800 (PST)
Subject: Re: [PATCH AUTOSEL 5.11 09/12] nvme-pci: mark Kingston SKC2000 as not
 supporting the deepest power state
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-nvme@lists.infradead.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <20210307135746.967418-1-sashal@kernel.org>
 <20210307135746.967418-9-sashal@kernel.org>
From:   =?UTF-8?B?QsO2c3rDtnJtw6lueWkgWm9sdMOhbg==?= <zboszor@gmail.com>
Message-ID: <6333d353-25c2-2cd3-e0c8-0dd39e31bfcd@gmail.com>
Date:   Sun, 7 Mar 2021 16:00:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210307135746.967418-9-sashal@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

2021. 03. 07. 14:57 keltezéssel, Sasha Levin írta:
> From: Zoltán Böszörményi <zboszor@gmail.com>
>
> [ Upstream commit dc22c1c058b5c4fe967a20589e36f029ee42a706 ]
>
> My 2TB SKC2000 showed the exact same symptoms that were provided
> in 538e4a8c57 ("nvme-pci: avoid the deepest sleep state on
> Kingston A2000 SSDs"), i.e. a complete NVME lockup that needed
> cold boot to get it back.
>
> According to some sources, the A2000 is simply a rebadged
> SKC2000 with a slightly optimized firmware.
>
> Adding the SKC2000 PCI ID to the quirk list with the same workaround
> as the A2000 made my laptop survive a 5 hours long Yocto bootstrap
> buildfest which reliably triggered the SSD lockup previously.
>
> Signed-off-by: Zoltán Böszörményi <zboszor@gmail.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Thanks for picking it up for stable.

May I suggest to include it in 5.10.x as well?
Originally this patch was tested on 5.10.17.

Best regards,
Zoltán Böszörményi

> ---
>   drivers/nvme/host/pci.c | 2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
> index 7a38d764b486..14c5b52400ef 100644
> --- a/drivers/nvme/host/pci.c
> +++ b/drivers/nvme/host/pci.c
> @@ -3262,6 +3262,8 @@ static const struct pci_device_id nvme_id_table[] = {
>   		.driver_data = NVME_QUIRK_DISABLE_WRITE_ZEROES, },
>   	{ PCI_DEVICE(0x1d97, 0x2263),   /* SPCC */
>   		.driver_data = NVME_QUIRK_DISABLE_WRITE_ZEROES, },
> +	{ PCI_DEVICE(0x2646, 0x2262),   /* KINGSTON SKC2000 NVMe SSD */
> +		.driver_data = NVME_QUIRK_NO_DEEPEST_PS, },
>   	{ PCI_DEVICE(0x2646, 0x2263),   /* KINGSTON A2000 NVMe SSD  */
>   		.driver_data = NVME_QUIRK_NO_DEEPEST_PS, },
>   	{ PCI_DEVICE(PCI_VENDOR_ID_APPLE, 0x2001),

