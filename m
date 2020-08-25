Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E095C251451
	for <lists+stable@lfdr.de>; Tue, 25 Aug 2020 10:35:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728245AbgHYIfP convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 25 Aug 2020 04:35:15 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:39738 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726365AbgHYIfN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Aug 2020 04:35:13 -0400
Received: by mail-wr1-f67.google.com with SMTP id a5so11832132wrm.6;
        Tue, 25 Aug 2020 01:35:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=1qEjxyiiC2lGzcAr6s2ibTUKc7Z/mlq1zZKoS1Bu9DI=;
        b=PNSZA/Goj2v4wmd9FuxARlrW4a99vKiCV0MYFj55Dew+KgSV/M3e2xWCfNnMhKa5rv
         e/pO7FdiBoXtSISIb1HWeRJqZO1HGtFuqOSv9HbvI9veNin/yiTIeAA3213PoqJMs692
         +POlIWf4MFOnUVu1o1Tm4JkXF81OGVvO5+SE97YA2AEw4K296FYJ+u+1dI2ux17f879C
         sMTjAeb5vlbYQ+vs2yyBDFF/ptW7jxtP2yXdLFgSLAyiV4vbYN+7P6QKYgcw11IUCZMJ
         ajXzXIQcWcF3MqTpQ3m+rryVtYwcBX6MVnw0P3y735xdzIro557/7Rth7H8lCRYWGB5F
         iinA==
X-Gm-Message-State: AOAM5325kqFdTg+UjYrVuI3BovVLWLrosPYqStdVwMIuGHTZ9wZP1thR
        Sfx+KKGlpZoFEOpz0LZG2ak=
X-Google-Smtp-Source: ABdhPJwecYN2rByJF63cxcgAApA/0EZmkurGTClR14WhE+iyH+pK594u9go7TnYRUVxdFwq6fDp6OQ==
X-Received: by 2002:adf:f08a:: with SMTP id n10mr10084799wro.351.1598344511461;
        Tue, 25 Aug 2020 01:35:11 -0700 (PDT)
Received: from kozik-lap ([194.230.155.216])
        by smtp.googlemail.com with ESMTPSA id 188sm12831261wmz.2.2020.08.25.01.35.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 25 Aug 2020 01:35:10 -0700 (PDT)
Date:   Tue, 25 Aug 2020 10:35:08 +0200
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     =?utf-8?B?5ZGo55Cw5p2wIChaaG91IFlhbmppZSk=?= 
        <zhouyanjie@wanyeetech.com>
Cc:     tsbogend@alpha.franken.de, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        zhenwenjin@gmail.com, sernia.zhou@foxmail.com,
        yanfei.li@ingenic.com, rick.tyliu@ingenic.com,
        aric.pzqi@ingenic.com, dongsheng.qiu@ingenic.com,
        hns@goldelico.com, ebiederm@xmission.com, paul@crapouillou.net
Subject: Re: [PATCH 1/1] MIPS: CI20: Update defconfig for EFUSE.
Message-ID: <20200825083508.GA13642@kozik-lap>
References: <20200825075239.17133-1-zhouyanjie@wanyeetech.com>
 <20200825075239.17133-2-zhouyanjie@wanyeetech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20200825075239.17133-2-zhouyanjie@wanyeetech.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 25, 2020 at 03:52:39PM +0800, 周琰杰 (Zhou Yanjie) wrote:
> The commit 19c968222934 ("MIPS: DTS: CI20: make DM9000 Ethernet
> controller use NVMEM to find the default MAC address") add EFUSE
> node for DM9000 in CI20, however, the EFUSE driver is not selected,
> which will cause the DM9000 to fail to read the MAC address from
> EFUSE, causing the following issue:
> 
> [FAILED] Failed to start Raise network interfaces.
> 
> Fix this problem by select CONFIG_JZ4780_EFUSE by default in the
> ci20_defconfig.
> 
> Fixes: 19c968222934 ("MIPS: DTS: CI20: make DM9000 Ethernet
> controller use NVMEM to find the default MAC address").

There is nothing to fix here or to backport to stable. The defconfigs
are just examples, useful for development and for downstream.

If you really think there is a bug which should be fixed, then there
should be dependency on JZ4780_EFUSE by Ethernet driver.

Best regards,
Krzysztof

> 
> Signed-off-by: 周琰杰 (Zhou Yanjie) <zhouyanjie@wanyeetech.com>
> ---
>  arch/mips/configs/ci20_defconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/mips/configs/ci20_defconfig b/arch/mips/configs/ci20_defconfig
> index 0a46199fdc3f..050ee6a17e11 100644
> --- a/arch/mips/configs/ci20_defconfig
> +++ b/arch/mips/configs/ci20_defconfig
> @@ -131,6 +131,7 @@ CONFIG_MEMORY=y
>  CONFIG_JZ4780_NEMC=y
>  CONFIG_PWM=y
>  CONFIG_PWM_JZ4740=m
> +CONFIG_JZ4780_EFUSE=y
>  CONFIG_EXT4_FS=y
>  # CONFIG_DNOTIFY is not set
>  CONFIG_PROC_KCORE=y
> -- 
> 2.11.0
> 
