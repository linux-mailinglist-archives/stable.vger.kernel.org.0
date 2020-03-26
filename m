Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13239193D84
	for <lists+stable@lfdr.de>; Thu, 26 Mar 2020 12:02:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727959AbgCZLCa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Mar 2020 07:02:30 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:33068 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727590AbgCZLCa (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Mar 2020 07:02:30 -0400
Received: by mail-lj1-f195.google.com with SMTP id f20so5944322ljm.0
        for <stable@vger.kernel.org>; Thu, 26 Mar 2020 04:02:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dBYI2pw9sfGjCi0bzv0yJEEWCyqkyjizmfbFD6llCpw=;
        b=wTmRLYkaXfjcDQz+CdaZDxndUCSZxc+ZmhUW90ynmlTOSPwHaSPR/ClhO/nWxAf7KV
         4qbWZyni701zQEPh+GULzYXBJxAUVIBHjJXNvg5C3+il+bmdr2lje+8Fq7GiQ+0JtyfK
         eHrlGTE66PPY62wp1VinlnBxYkMI9JO103TdN/wSPU6ZndMqYfHMyxZNKAJ96zdibjd4
         d6P/2e2ei6EJUpHWQRRHplaPcdSfQB/WJgmBVQ0EF1EJNGJFGusx7B6eHWAMA+66upts
         /8YOfHxZHJrkiw4F/7IWsJMqiYVYzTsmxEJUtQZNq9RvgaoF57MbAqhJQ90NjUkol4Ii
         5+vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dBYI2pw9sfGjCi0bzv0yJEEWCyqkyjizmfbFD6llCpw=;
        b=i8f+iogfzBfngIqc7VH8bmfcEiE6HQgE31bouTE9WDg3tnTyO3Q2XeZ/DCvv+bcp4a
         FrA7WP0v1SKgyGG/c5HY74t7hyFw33DhnmIsUOeAQOlqBxqiWehnIKBWPnaAmmstkkpn
         iItZdDNPadwX2Aeas+QLrdqso0k5iY3KqrLeN6IZpTRa0iN+gP1+P4fHNkyRhLquGK80
         nBskvdiB0IKOOM9aDGSOZhTaAXuohmoCgLU6xQ9nDcpOKP+cp0WclSI4lRbi6PwrNPZC
         DKOVV3b6C5HB40gyFoQiQyt9vvzf17cUJcpo0W+RQ7KjoplHDWDnZV2yqQOfdaBK8WJB
         QErg==
X-Gm-Message-State: ANhLgQ3xMyfmGJwx9BXAENslDLeoS4K/799a/+Goo/TvXGWFSmACHPd3
        S1gLPs2vjPWhJOeQ56J9SlopmCHTKuGZtM9ffFALng==
X-Google-Smtp-Source: ADFU+vuAu4NKjgOw04+YhFG4R26tuG7+/x5c+7Ylo0beaM6wZX++zLVCej8OOV3pch4cA7VonOGw2KOeqtn4XOjj9jY=
X-Received: by 2002:a05:651c:445:: with SMTP id g5mr4725550ljg.125.1585220547769;
 Thu, 26 Mar 2020 04:02:27 -0700 (PDT)
MIME-Version: 1.0
References: <20200325113407.26996-1-ulf.hansson@linaro.org> <20200325113407.26996-3-ulf.hansson@linaro.org>
In-Reply-To: <20200325113407.26996-3-ulf.hansson@linaro.org>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Thu, 26 Mar 2020 12:02:16 +0100
Message-ID: <CACRpkdYVTyViFk9CWwQsfLxsNRbinJs=wEX=th6QVH-fL_YQ7Q@mail.gmail.com>
Subject: Re: [PATCH 2/2] amba: Initialize dma_parms for amba devices
To:     Ulf Hansson <ulf.hansson@linaro.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@lst.de>,
        Russell King <linux@armlinux.org.uk>,
        Vinod Koul <vkoul@kernel.org>, Haibo Chen <haibo.chen@nxp.com>,
        Ludovic Barre <ludovic.barre@st.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        dmaengine <dmaengine@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 25, 2020 at 12:34 PM Ulf Hansson <ulf.hansson@linaro.org> wrote:

> It's currently the amba driver's responsibility to initialize the pointer,
> dma_parms, for its corresponding struct device. The benefit with this
> approach allows us to avoid the initialization and to not waste memory for
> the struct device_dma_parameters, as this can be decided on a case by case
> basis.
>
> However, it has turned out that this approach is not very practical. Not
> only does it lead to open coding, but also to real errors. In principle
> callers of dma_set_max_seg_size() doesn't check the error code, but just
> assumes it succeeds.
>
> For these reasons, let's do the initialization from the common amba bus at
> the device registration point. This also follows the way the PCI devices
> are being managed, see pci_device_add().
>
> Suggested-by: Christoph Hellwig <hch@lst.de>
> Cc: Russell King <linux@armlinux.org.uk>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
