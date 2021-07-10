Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 037E33C3306
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 07:19:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230165AbhGJFVq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Jul 2021 01:21:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231737AbhGJFVo (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Jul 2021 01:21:44 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F555C0613DD;
        Fri,  9 Jul 2021 22:18:59 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id f9so9396083wrq.11;
        Fri, 09 Jul 2021 22:18:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-transfer-encoding;
        bh=Vo7lv5MfywwryyGYuzzRiQ5PfbXhnF12+ljux8VcByw=;
        b=nkzQjC+wJS3XbdWRczAIpOKDrQ8ZwfZXCW4BWxeDhlrAIk/+UPnnXuYgL7vh7O4de+
         HKtpG4qEBQC9iXbUAKCktKR0vjebiVqeRkSmFDAxCwrkLice2mqUxfSJFhE/rYjro8Yv
         97NX6yl0xQpScqQ09YnlKCNgLpCrbTZC/QD6XBrg0IyP2NNjSTv6iq8s1VvWF7fK6e21
         hhpwSlxHVVluxdvR9j6OVzI16VtF5YsTzva8I0zWj9Aq7qOZjoQnrCm7Y09Bx+ebtnKN
         w9JsfuLFOsX9wUutJFop8q0f8K2ZCKJ5+cSY7qNNG3nlHpos0ob5alvXFzHbYXaIZ9qC
         xaaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:user-agent:mime-version:to
         :cc:subject:references:in-reply-to:content-transfer-encoding;
        bh=Vo7lv5MfywwryyGYuzzRiQ5PfbXhnF12+ljux8VcByw=;
        b=CzpabYX5Bt+92WHiB5SlRyg8RhzNL82VOMMaaQaxwgvv7amTwEgc0IOgMmi79/5fXZ
         K/Ei4L8klZg5P8eV0qYHXrR0fAWKjCw7WWThtKk/BQChCzh8o37Yzhjp3z1jfC4PW4q6
         BGOOpNrCq0rXHSBw3nSyr4qcmSpCeohdZQMxvRjRUIWvR+avqgrbLuXM/CLEFAOJvM0q
         SDD51UnDK9/OV8hVi++5fjHiBf7X2s/KNCQVho9l4MgGqSUfEwi8nDNELbc24m41MLAA
         4m6WMrI7Ntd48zGHlWL+STmTQPfM5/eCr4ebS3/GvTeCn4X2DsHdQxyvnykepGrM/lhQ
         IFYA==
X-Gm-Message-State: AOAM533BUeZLTMm9M847nkK4fG5HO2GW67siOqfgFWErtd9U6O47nUzB
        I5kZ5hSoguJlbptUanYRc6Q=
X-Google-Smtp-Source: ABdhPJzrOX+6HnvL5FtknB9L9G3P7Fko+tOj1gKWDFnns+VLOOl1h2+dI6ai+jrMZLo4TctuXi07nA==
X-Received: by 2002:a5d:6da1:: with SMTP id u1mr45369789wrs.281.1625894337992;
        Fri, 09 Jul 2021 22:18:57 -0700 (PDT)
Received: from [89.139.72.61] (89-139-72-61.bb.netvision.net.il. [89.139.72.61])
        by smtp.gmail.com with ESMTPSA id r3sm7366647wrz.89.2021.07.09.22.18.57
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Fri, 09 Jul 2021 22:18:57 -0700 (PDT)
Message-ID: <60E92D27.2060308@gmail.com>
Date:   Sat, 10 Jul 2021 08:16:23 +0300
From:   Eli Billauer <eli.billauer@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To:     Sasha Levin <sashal@kernel.org>
CC:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH AUTOSEL 5.12 049/104] char: xillybus: Fix condition for
 invoking the xillybus/ subdirectory
References: <20210710022156.3168825-1-sashal@kernel.org> <20210710022156.3168825-49-sashal@kernel.org>
In-Reply-To: <20210710022156.3168825-49-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Sasha,

Thanks for trying, but this is a NACK.

On 10/07/21 05:21, Sasha Levin wrote:
> diff --git a/drivers/char/Makefile b/drivers/char/Makefile
> index ffce287ef415..c7e4fc733a37 100644
> --- a/drivers/char/Makefile
> +++ b/drivers/char/Makefile
> @@ -44,6 +44,6 @@ obj-$(CONFIG_TCG_TPM)		+= tpm/
>
>   obj-$(CONFIG_PS3_FLASH)		+= ps3flash.o
>
> -obj-$(CONFIG_XILLYBUS)		+= xillybus/
> +obj-$(CONFIG_XILLYBUS_CLASS)	+= xillybus/
>   obj-$(CONFIG_POWERNV_OP_PANEL)	+= powernv-op-panel.o
>    
CONFIG_XILLYBUS_CLASS will be introduced in v5.14, so backporting this 
commit will break the kernel's build.

Since this patch was created for three kernel versions, I'm repeating 
this response on all three, just be sure. Hope I'm not being annoying.

    Eli
