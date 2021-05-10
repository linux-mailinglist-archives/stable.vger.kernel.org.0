Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B38133797DF
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 21:46:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231672AbhEJTrj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 15:47:39 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55394 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231634AbhEJTri (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 May 2021 15:47:38 -0400
Received: from mail-pf1-f198.google.com ([209.85.210.198])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <alex.hung@canonical.com>)
        id 1lgBqz-0005B2-AX
        for stable@vger.kernel.org; Mon, 10 May 2021 19:46:16 +0000
Received: by mail-pf1-f198.google.com with SMTP id h22-20020aa786d60000b029027d0956e914so11403407pfo.23
        for <stable@vger.kernel.org>; Mon, 10 May 2021 12:46:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QKfTy+lWwzAqXsSuHWUnjfihkvwNwtNKdpNFDfzbbfA=;
        b=lrhYoxjUb26EDnrbkdTtHS6raTDuYX8RGmKtzQtT0DVgbF1HYoP+0gxooiJy/kL50j
         FREYTcqRyVBgoMXCQowB1seoOr3VXlfEhCYaRKT7meNIyjLH90UKv53FM2gn9Q4rSls3
         1szcyl3Q2+HQCkTyjrWglv95TjXbCsd6F9tcXFclUrYBqnrfu6ea1kHOqKxWX4KxduvI
         Ex9Njv6njg4Kht/v/quVMhV9I6QM16Tw/Dm+QdpcFGNcRMpytz1Khg+ZMxZ1gL1lnVWc
         hmdi4z5X0TMMwd8mXRYBnsivr80JLjpucfKsOPAUjVByK8az0eGzlidJX0mOEisTuZp7
         pGkg==
X-Gm-Message-State: AOAM532EsD7UmQtwBkklOuOQZqPJUmVa4UmrkThW7ay7YR53LJ/jngjz
        jTuDif1BAfDcOjWvrHckLnVstE7zXh4lck8CoKt28cQlMkdO3FdSd3Qof6Bkgq2C2ljax0NNWGo
        t1npREUqhI9XVVtGYQGpmMy1aSgnqT+abdw==
X-Received: by 2002:a17:90a:5881:: with SMTP id j1mr1226001pji.122.1620675967405;
        Mon, 10 May 2021 12:46:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyATUABUxZLoPbk8d4KXCqHX9JwplyHKpAeOpowm4VqqwdoURcneNajGkiE3SfShIn01251gA==
X-Received: by 2002:a17:90a:5881:: with SMTP id j1mr1225971pji.122.1620675967067;
        Mon, 10 May 2021 12:46:07 -0700 (PDT)
Received: from [192.168.0.119] (d75-158-101-9.abhsia.telus.net. [75.158.101.9])
        by smtp.gmail.com with ESMTPSA id o7sm265506pjm.39.2021.05.10.12.46.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 May 2021 12:46:06 -0700 (PDT)
Subject: Re: [PATCH] iwlwifi: add new pci id for 6235
To:     luciano.coelho@intel.com, kvalo@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org, matti.gottlieb@intel.com,
        ihab.zhaika@intel.com, johannes.berg@intel.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     stable@vger.kernel.org
References: <20210322071121.265584-1-alex.hung@canonical.com>
From:   Alex Hung <alex.hung@canonical.com>
Message-ID: <5dcc309b-fe0d-263a-33e2-b69bbed71b9e@canonical.com>
Date:   Mon, 10 May 2021 13:46:05 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210322071121.265584-1-alex.hung@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2021-03-22 1:11 a.m., Alex Hung wrote:
> lspci output:
> Network controller [0280]: Intel Corporation Centrino Advanced-N6235
>  [8086:088f] (rev 24)
>  Subsystem: Intel Corporation Centrino Advanced-N 6235 [8086:526a]
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Alex Hung <alex.hung@canonical.com>
> ---
>  drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
> index ffaf973..f85fe36 100644
> --- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
> +++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
> @@ -200,6 +200,7 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
>  	{IWL_PCI_DEVICE(0x088E, 0x446A, iwl6035_2agn_sff_cfg)},
>  	{IWL_PCI_DEVICE(0x088E, 0x4860, iwl6035_2agn_cfg)},
>  	{IWL_PCI_DEVICE(0x088F, 0x5260, iwl6035_2agn_cfg)},
> +	{IWL_PCI_DEVICE(0x088F, 0x526A, iwl6035_2agn_cfg)},
>  
>  /* 105 Series */
>  	{IWL_PCI_DEVICE(0x0894, 0x0022, iwl105_bgn_cfg)},
> 

Hi,

Linux kernel 5.13-rc1 does not include this patch, and I did not see any
reviews on this patch either.

This PCI ID may be old but there is a bug report asking for support.
Please refer to https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1920180
