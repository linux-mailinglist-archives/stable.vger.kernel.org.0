Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17CE2216CFD
	for <lists+stable@lfdr.de>; Tue,  7 Jul 2020 14:40:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728152AbgGGMkH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jul 2020 08:40:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728094AbgGGMkH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jul 2020 08:40:07 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EA8FC061755
        for <stable@vger.kernel.org>; Tue,  7 Jul 2020 05:40:07 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id h19so49726422ljg.13
        for <stable@vger.kernel.org>; Tue, 07 Jul 2020 05:40:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gBIdGRLf5Cnr5tv5YyMZkrd+hNTUnC4qnI3yzrVPz4s=;
        b=zZbgmRNEN+Cc2hDtQX4Dm++WQhE8xQ1v3PBJo3ZQkSoPi1uYxkQ0Y29tM+h5uKGgxk
         R8up+SY/8shg5vXKAKBYFVvPefxK3DJU2owMhFJAiPknsu5GBf7xv+NAp6iuN1YwAbbx
         JBrdLrAEF0nsFHEocS3BfUTnMuCiln9uvZrgQ5KcOD8dKfletfW5Zmi66OduL8C1mDfd
         aeR0RB0IEkQNAiVbxOhPycMRNU10M38wRQ3fSm4M7bBoT0G0Q6UUdE/qvQevtWiL0jWp
         lsrncyKGCtDTzWPim/17xR0UDZgms1JWq55rkqAn7E74ohJsp382XEzEAd3ELD1v2jrU
         JtOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gBIdGRLf5Cnr5tv5YyMZkrd+hNTUnC4qnI3yzrVPz4s=;
        b=FHgBBtPXkVkMr+LRJBg0jDMQuVNpZHSPvATxtefHGu01gZskSCOseZ76ZC/UTfFsuj
         bW30RsKaY9fVX+1X2LKMHaw1nSkr+mN+w2S44OFUNxLsd4OZC8XMQcj5FN7LN5VMVSQm
         WZ3DqwznLI8RJRqaB3/47xP6LhcekNFelk7aM9hLpQ4w3JlxQc2BNhFTdv9EWgGRZwgu
         r748Dzqtexncq6d2uiahQcbsaPoIvydBc7X/gJJU3ocL2Z6+DipLkpo3y3RITZ3CN0iL
         +aGDtC7LYt9VCv6YRHimrc4I37tqwQgjJEL0082vGcZT1hFxWs7vzrovoLBAE7djWcGA
         pBRQ==
X-Gm-Message-State: AOAM533HNI1TE7mBcRIAo35UUDZb6PWQedGZnNZk9rKjkiKJG/dHp0YY
        U9NqF0yzMFWVLSRsGKd/U8AbN4+gBiULXOoGljTpI0Upcik=
X-Google-Smtp-Source: ABdhPJxDXru6RgwaBVIBtujonT5DdydJbJILVYEaNJo44eej7MQdGO5rlBUNjRspneYJmwhSKBueSL0fK+zw5ir6UWc=
X-Received: by 2002:a2e:810a:: with SMTP id d10mr24438178ljg.144.1594125605584;
 Tue, 07 Jul 2020 05:40:05 -0700 (PDT)
MIME-Version: 1.0
References: <20200625064619.2775707-1-lee.jones@linaro.org> <20200625064619.2775707-5-lee.jones@linaro.org>
In-Reply-To: <20200625064619.2775707-5-lee.jones@linaro.org>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Tue, 7 Jul 2020 14:39:54 +0200
Message-ID: <CACRpkdYPdO94x2dRLgKXioaSi3NbrG_ieDUA00QbdUyhfrCmvg@mail.gmail.com>
Subject: Re: [PATCH 04/10] mfd: db8500-prcmu: Remove incorrect function header
 from .probe() function
To:     Lee Jones <lee.jones@linaro.org>
Cc:     Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 25, 2020 at 8:46 AM Lee Jones <lee.jones@linaro.org> wrote:

> Not only is the current header incorrect, the isn't actually a
> need to document the ubiquitous platform probe call.
>
> Cc: <stable@vger.kernel.org>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
