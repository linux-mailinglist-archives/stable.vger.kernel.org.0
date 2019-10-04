Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2229CB98B
	for <lists+stable@lfdr.de>; Fri,  4 Oct 2019 13:55:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729059AbfJDLzu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Oct 2019 07:55:50 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:52923 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726002AbfJDLzu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Oct 2019 07:55:50 -0400
Received: by mail-wm1-f68.google.com with SMTP id r19so5530024wmh.2
        for <stable@vger.kernel.org>; Fri, 04 Oct 2019 04:55:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=hE9gO6iBemQRdrDLgOELHYEQ3kfZDPseTzp8k/zd/0A=;
        b=MkcX+BuxcotutguuloScLvrFR7CC0Ru2WHMu2SU+luqznVO9A274GNcwotoXBjHC/1
         BQKWtuykQJrWtgd1KLPlG873ZIhsxsYrFhH3KK5tzpu9hgPSPtC8FauXfazCvEDaiLxC
         /p0VowPOPlKoc8/MM+M12VlKvfsMuem9iCDKEtDyr8rfxT7g9XjOqwm6O7JDwpv7HAmi
         UpJlD7TR7zgR1sajpwh0CpJnPsmwfn+FPMgRCvYk4RVurm5Jq/rT12HQLrknUhayJ1v6
         KzbE828jvH0fmhUBjjL868gnBhCkOTvtyEiG1q5iKRjxPQWu2LJGJBvsgXOSzQAt7izx
         vQDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=hE9gO6iBemQRdrDLgOELHYEQ3kfZDPseTzp8k/zd/0A=;
        b=ptBmUNeY13vqh/yD+tVvJAQpQZX4NTsVE/EfkM8nDfitZ7Dc3syR03bcOl4fWrwo0s
         8mMNAndC3B9Uq4CYATfBhKW1/nDhvOoqdxczPGxyk+w53o/xBRxOnZOE3ueM35KMjUKW
         i3apSIO5j5oadxumQAkQnNS5txWQGSo8ws+ofpg3lNdN+9MP+nyCPYAckqaJKvfGaVC1
         xIF9Hb6pfzsmLYk9mZTFRFLWpi+qlrPmpKz1JqD9em8KAN5zu0l68XzKYEnobTJTASQs
         XonB0CoPDhFtbSxPPwxhBs8oERH4JsC1qdUGDuKPuhmO6YMy2rW98bsrULlmXpCMDqYO
         J1Tw==
X-Gm-Message-State: APjAAAW2ft5eVE9K1xVBl4AAl5nczxFAifV1+PlZpZJgFFmvhXJf6ZuM
        t51FUrew/yeBQPUVNnP9rBTIkQ==
X-Google-Smtp-Source: APXvYqxtwCiJ7aEpNUZVMoQ2xLV2qEzDkvPWWlvSDWKGJrKh1lNmVkUCeorQOWdoWBP1KOaD0bx0GQ==
X-Received: by 2002:a1c:2397:: with SMTP id j145mr10130361wmj.69.1570190148572;
        Fri, 04 Oct 2019 04:55:48 -0700 (PDT)
Received: from dell ([2.27.167.122])
        by smtp.gmail.com with ESMTPSA id r10sm5120239wml.46.2019.10.04.04.55.47
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 04 Oct 2019 04:55:47 -0700 (PDT)
Date:   Fri, 4 Oct 2019 12:55:46 +0100
From:   Lee Jones <lee.jones@linaro.org>
To:     Heiko Stuebner <heiko@sntech.de>
Cc:     linux-kernel@vger.kernel.org, d.schultz@phytec.de,
        linux-rockchip@lists.infradead.org,
        christoph.muellner@theobroma-systems.com, tony.xie@rock-chips.com,
        stable@vger.kernel.org, Elaine Zhang <zhangqing@rock-chips.com>,
        Joseph Chen <chenjh@rock-chips.com>
Subject: Re: [PATCH 1/4] mfd: rk808: fix rk818 ID template
Message-ID: <20191004115546.GA18429@dell>
References: <20190917081256.24919-1-heiko@sntech.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190917081256.24919-1-heiko@sntech.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 17 Sep 2019, Heiko Stuebner wrote:

> From: Daniel Schultz <d.schultz@phytec.de>
> 
> The Rockchip PMIC driver can automatically detect connected component
> versions by reading the ID_MSB and ID_LSB registers. The probe function
> will always fail with RK818 PMICs because the ID_MSK is 0xFFF0 and the
> RK818 template ID is 0x8181.
> 
> This patch changes this value to 0x8180.
> 
> Fixes: 9d6105e19f61 ("mfd: rk808: Fix up the chip id get failed")
> Cc: stable@vger.kernel.org
> Cc: Elaine Zhang <zhangqing@rock-chips.com>
> Cc: Joseph Chen <chenjh@rock-chips.com>
> Signed-off-by: Daniel Schultz <d.schultz@phytec.de>
> Acked-by: Lee Jones <lee.jones@linaro.org>
> [resend as it seems to have dropped on the floor]
> Signed-off-by: Heiko Stuebner <heiko@sntech.de>
> ---
>  include/linux/mfd/rk808.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied, thanks.

-- 
Lee Jones [李琼斯]
Linaro Services Technical Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
