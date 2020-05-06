Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E87A1C6C5C
	for <lists+stable@lfdr.de>; Wed,  6 May 2020 11:02:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728679AbgEFJCj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 May 2020 05:02:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728571AbgEFJCi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 May 2020 05:02:38 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F9B0C061A0F
        for <stable@vger.kernel.org>; Wed,  6 May 2020 02:02:38 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id u127so1681724wmg.1
        for <stable@vger.kernel.org>; Wed, 06 May 2020 02:02:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=M5LFU+WBf9mBOsULCJUXdJaTctZwDOegn4WXcf9YPdE=;
        b=CPFwNapJNXwbVdAPM9zkhx0WAnT+xjXzcBjBwWwfYaUvE2fAU4iyhQOAwBO7ZQ4nLz
         n/FGrWLepS0U0xKNKc2BMPPx0rpuGITI2K/W3EIh06VrD0Rcpk4BjqSAZf9uSRQNrkaQ
         8UkxNuwI6+xMEAtUJjsAsGdaBEcPfbeUXH9XodEpRBZr/tBTNzeSolHrrklTn6+kmf/n
         QFXLyN7tbvXVaeqGbJyQ4vusX1qlJ3y7nbvwbbDM5NYdOgVC3qsKjywBl0yMFk8aJM/5
         T0mjFOXPTTsC6emf+kGHWEMcrH2ycxqry4kkdfJCsDQ5AWKBIJGJngFJdXYyLJNtbjav
         m1mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=M5LFU+WBf9mBOsULCJUXdJaTctZwDOegn4WXcf9YPdE=;
        b=qgPg2LkSg1oH5mo1I8ERRYIjVTpiJ+hnWfml8hCBMvQWJ5qV2wi/8uhGJFAiEoF+Zo
         yUlbk0amFxsci+F2P116bfza9W+UsBFshBOvcJogT0yv1rHa5A+HxGLI9jwShr8WFL6p
         LgOsxtM95PjvTBdSWtEJmGM8FAfZ1K302OFg1bKA35PtHm8x8nFtBxzVfPtN9Fd0IQ9g
         hWbGtYGqipVC//KaC3eV6LE1uj/pVc3ZT5IwgNJvMQi5VCXnaGdDUbmoI4KCRPqulO/4
         B2mXAuZd+n7N/sxGNrCz3s9hG9n1GtdbaFNxMVkuqh880n1kvkT+le3UJBjDHrrrLHJS
         qrng==
X-Gm-Message-State: AGi0PubcgevhY83FXafE+gKsMsTOmzMTsVw2GNZ5jci7K9QRpaP/7V3n
        NhmR7d4xyRnK0USciRDxoEBXQ21aTCA=
X-Google-Smtp-Source: APiQypJZ+5VYzzGmmnUlxu6SwIBj0Vprm2edvGd2i/IGqGFYX8/kaXVdJZLGDtKk150SGevjbWi3kw==
X-Received: by 2002:a1c:9852:: with SMTP id a79mr3116947wme.27.1588755757062;
        Wed, 06 May 2020 02:02:37 -0700 (PDT)
Received: from dell ([2.31.163.63])
        by smtp.gmail.com with ESMTPSA id l16sm1626487wrp.91.2020.05.06.02.02.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2020 02:02:36 -0700 (PDT)
Date:   Wed, 6 May 2020 10:02:34 +0100
From:   Lee Jones <lee.jones@linaro.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Yangtao Li <tiny.windzz@gmail.com>
Subject: Re: [PATCH 4.4 08/16] serial/sunsu: add missing of_node_put()
Message-ID: <20200506090234.GC823950@dell>
References: <20200423204014.784944-1-lee.jones@linaro.org>
 <20200423204014.784944-9-lee.jones@linaro.org>
 <20200506082301.GA2492474@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200506082301.GA2492474@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 06 May 2020, Greg Kroah-Hartman wrote:

> On Thu, Apr 23, 2020 at 09:40:06PM +0100, Lee Jones wrote:
> > From: Yangtao Li <tiny.windzz@gmail.com>
> > 
> > [ Upstream commit 20d8e8611eb0596047fd4389be7a7203a883b9bf ]
> > 
> > of_find_node_by_path() acquires a reference to the node
> > returned by it and that reference needs to be dropped by its caller.
> > This place is not doing this, so fix it.
> > 
> > Signed-off-by: Yangtao Li <tiny.windzz@gmail.com>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > ---
> >  drivers/tty/serial/sunsu.c | 20 +++++++++++++++-----
> >  1 file changed, 15 insertions(+), 5 deletions(-)
> 
> What about 4.9.y, 4.14.y, and 4.19.y for this?

Yes, according to my results file, it should have been applied:

  stable/results/vendor-sony-xperia-aosp-LA.UM.7.1.r1-phase-2.txt
    20d8e8611eb0 stable-linux-4.4.y stable-linux-4.9.y \
                 stable-linux-4.14.y stable-linux-4.19.y

I can't think why it was dropped.  Perhaps it didn't apply, although I
usually fight to get them applied if at all possible.

Are you able to apply it?

-- 
Lee Jones [李琼斯]
Linaro Services Technical Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
