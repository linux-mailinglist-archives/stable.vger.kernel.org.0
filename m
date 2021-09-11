Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2228A407972
	for <lists+stable@lfdr.de>; Sat, 11 Sep 2021 18:05:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbhIKQGx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Sep 2021 12:06:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbhIKQGw (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Sep 2021 12:06:52 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C343CC061574;
        Sat, 11 Sep 2021 09:05:39 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id i23so7374542wrb.2;
        Sat, 11 Sep 2021 09:05:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zFN+kWQ8zZi7gQrxC+9TEC6NqA2P8LqFbiCzB4yXRIk=;
        b=Q4YpBI9MrzcIsO1gXF09QBHwQ1msrFKTdO/BfjmQ0sY9BHlwUQVBlvYkJH/yzn6jcW
         U92TDRFhOHaI0wJ0HGVo2b2IIES52GFh10Cp64rZ7pRBin/4H6ytzHio7aWxya7J9fPu
         UruRkAM9BAUpThaL4jb4FJ7luNTphEXBpRhNSCCuO+v7uUEqCGbMKXuWDAvmziCu7Uq4
         cyGbFndNo9uLfx8l9joJ8rPe0BhXUvu6N0az0p+44+U4dAvo2t2qYSvpSH8Sz3o0At1j
         iC0HWY2mC7cLtgzYkhiJV4+rtdcM171KLWHbvkFil9t7PpvtHtW2qzboabi+TjvSVZRo
         8sJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zFN+kWQ8zZi7gQrxC+9TEC6NqA2P8LqFbiCzB4yXRIk=;
        b=E/WCfwXQ2lTypz8iVOyzsDyO7/g3N+DrttuF7ZhTH7FCOtS5qDOP4lC4lzKk3OH1dz
         cvpjJrXxar9L9fHR3b3Vt3OPCiShZo2DRwki1RjJrdIntB+T/bAvxy0xDod1ikckx6zH
         otFxp5hqeMWiQ6ahYvTIsW5XpshJBOaYNnTyMt+lC5i/kE+Qkj3Cott3coG98rsZCdj5
         mRoCLF0EEfdw4ybanX28RN2RpbMsqSKcYGzL7cGgm2jI0GSq6GkOtXOu0CNHxuFJNdsN
         El7OeL/GHC7aw6l94oMBGbl+iy25a4zJ1UxmAnxrm7lxn29nbo3yVsINQvXjuUh7xk+z
         n7wg==
X-Gm-Message-State: AOAM531sruooF5+IFD6D92Ob7oLVv/vANq5qGY5Pf+PfrwG6IvAqGedu
        VMKitOqiivwk02MNO7OGTHd2YHRPS8hMFQ==
X-Google-Smtp-Source: ABdhPJzS8kLQ/17qZ7RVEQ1eg8UJN+QVdEbQhSh+tTIn4zXyPnTG1Pxs4IjyN6qSM306XwiUJU0g7A==
X-Received: by 2002:a05:6000:363:: with SMTP id f3mr3715913wrf.142.1631376338431;
        Sat, 11 Sep 2021 09:05:38 -0700 (PDT)
Received: from [192.168.1.4] (ip-89-176-112-137.net.upcbroadband.cz. [89.176.112.137])
        by smtp.gmail.com with ESMTPSA id i9sm1956466wmi.44.2021.09.11.09.05.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Sep 2021 09:05:37 -0700 (PDT)
From:   Marek Vasut <marek.vasut@gmail.com>
Subject: Re: [PATCH AUTOSEL 5.14 12/32] PCI: rcar: Add L1 link state fix into
 data abort hook
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Marek Vasut <marek.vasut+renesas@gmail.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Wolfram Sang <wsa@the-dreams.de>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        linux-renesas-soc@vger.kernel.org, linux-pci@vger.kernel.org
References: <20210911131149.284397-1-sashal@kernel.org>
 <20210911131149.284397-12-sashal@kernel.org>
Message-ID: <6cbfadee-0d74-fa4c-9ef3-a1bce55632bb@gmail.com>
Date:   Sat, 11 Sep 2021 18:05:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210911131149.284397-12-sashal@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/11/21 3:11 PM, Sasha Levin wrote:
> From: Marek Vasut <marek.vasut+renesas@gmail.com>
> 
> [ Upstream commit a115b1bd3af0c2963e72f6e47143724c59251be6 ]
> 
> When the link is in L1, hardware should return it to L0
> automatically whenever a transaction targets a component on the
> other end of the link (PCIe r5.0, sec 5.2).
> 
> The R-Car PCIe controller doesn't handle this transition correctly.
> If the link is not in L0, an MMIO transaction targeting a downstream
> device fails, and the controller reports an ARM imprecise external
> abort.
> 
> Work around this by hooking the abort handler so the driver can
> detect this situation and help the hardware complete the link state
> transition.
> 
> When the R-Car controller receives a PM_ENTER_L1 DLLP from the
> downstream component, it sets PMEL1RX bit in PMSR register, but then
> the controller enters some sort of in-between state.  A subsequent
> MMIO transaction will fail, resulting in the external abort.  The
> abort handler detects this condition and completes the link state
> transition by setting the L1IATN bit in PMCTLR and waiting for the
> link state transition to complete.

You will also need the following patch, otherwise the build will fail on 
configurations without COMMON_CLK (none where this driver is used, but 
happened on one of the build bots). I'm waiting for PCIe maintainers to 
pick it up:
https://patchwork.kernel.org/project/linux-pci/patch/20210907144512.5238-1-marek.vasut@gmail.com/
