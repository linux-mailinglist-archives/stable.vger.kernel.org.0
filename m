Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8DAE130EB3
	for <lists+stable@lfdr.de>; Mon,  6 Jan 2020 09:36:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726294AbgAFIfw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jan 2020 03:35:52 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:41909 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbgAFIfv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jan 2020 03:35:51 -0500
Received: by mail-wr1-f67.google.com with SMTP id c9so48695648wrw.8
        for <stable@vger.kernel.org>; Mon, 06 Jan 2020 00:35:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=e0KhA/fnqWm6T6Fd1y/ycOP88g1CHs2BTbMCEvSy12Q=;
        b=RbQpLY0JPaeobLbCh36bLbDuItz1p7hIAmNT2oGDYKGS1mgu5Kj3oPlu4mgWSw9v3V
         RRnqMhQkSAZP8VJnl+HJQ2j/nICCe/2u6Jr9uMeBWnZHi0CKpHrVnJH3X1AieSxarvfY
         RMfKwTlVQBKqPcnTAAPuR32zi4ywOv2KxET3xVXJreV42QVohvmVFFev/y7javZBTZyT
         6e7rf8ctUiAhzrJjeFAycyuba+GTeIXAcc8poGc+sxGZq0JGpeHMzvjAD0UcAdgMsbvL
         dk/9SaRwbZjFAIoiFJKp/voDRjXhW2OCJlDenxb0AT1RW+hmZFk7a8vUi4GZNQubEfVq
         iCDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=e0KhA/fnqWm6T6Fd1y/ycOP88g1CHs2BTbMCEvSy12Q=;
        b=EWZ9UC7SFxtu1ulM3BgwOy5LvI7GahWEcY4Xd7QpbMPjmCNU/C+RhlY+z/MgjpqCfr
         woEZ+AM6QS8ZQU0vWQpGBL3La5ICuHCwgQlsYj7OxLFIFMS7T0e6ljKcHIzlKlg5m722
         BtfmOpTmGUEJV/2pmgfmGSBavav/a05R+HqJWlC1oXCQObwUAFxqyOGUSQLdM+yZ8YT0
         oRWkEGm05iD6u3NB4tbAgzRmpZ3QXGmC5PPeUn9+Gcwa5ZLXwgX2jBWn1pcwHUrkeBIJ
         LK2IsQ9Uza6z0PFThlxvoNhD11ii8JAnWDIy+N3NW/Q4h5qHYF4svVTFZVMyPH2xxq5j
         o44Q==
X-Gm-Message-State: APjAAAUVedDMSIulwYC6K9ibkAM6B/Jn2HGzSJNwkSUFoUiaJSLhz6hY
        PskWV1I2F6Z1nqy5f6ZXJdE3aA==
X-Google-Smtp-Source: APXvYqyIiOs7jWQLCFZMnVa3AtUvwaffIrFpTMgoZ+P25QYJI9FKcD+DBcRlTB3YcQs0DsS/7Kd9WQ==
X-Received: by 2002:a5d:45c4:: with SMTP id b4mr67762298wrs.303.1578299749170;
        Mon, 06 Jan 2020 00:35:49 -0800 (PST)
Received: from dell ([2.27.35.135])
        by smtp.gmail.com with ESMTPSA id m3sm70800908wrs.53.2020.01.06.00.35.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jan 2020 00:35:48 -0800 (PST)
Date:   Mon, 6 Jan 2020 08:36:03 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     Samuel Holland <samuel@sholland.org>
Cc:     Chen-Yu Tsai <wens@csie.org>, Sebastian Reichel <sre@kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Oskari Lemmela <oskari@lemmela.net>,
        Quentin Schulz <quentin.schulz@bootlin.com>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/9] mfd: axp20x: Mark AXP20X_VBUS_IPSOUT_MGMT as
 volatile
Message-ID: <20200106083603.GK22390@dell>
References: <20200105012416.23296-1-samuel@sholland.org>
 <20200105012416.23296-2-samuel@sholland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200105012416.23296-2-samuel@sholland.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, 04 Jan 2020, Samuel Holland wrote:

> On AXP288 and newer PMICs, bit 7 of AXP20X_VBUS_IPSOUT_MGMT can be set
> to prevent using the VBUS input. However, when the VBUS unplugged and
> plugged back in, the bit automatically resets to zero.
> 
> We need to set the register as volatile to prevent regmap from caching
> that bit. Otherwise, regcache will think the bit is already set and not
> write the register.
> 
> Fixes: cd53216625a0 ("mfd: axp20x: Fix axp288 volatile ranges")
> Cc: stable@vger.kernel.org
> Signed-off-by: Samuel Holland <samuel@sholland.org>
> ---
>  drivers/mfd/axp20x.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied, thanks.

-- 
Lee Jones [李琼斯]
Linaro Services Technical Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
