Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8338D43600D
	for <lists+stable@lfdr.de>; Thu, 21 Oct 2021 13:15:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230105AbhJULRu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Oct 2021 07:17:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229765AbhJULRu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Oct 2021 07:17:50 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CB34C06161C
        for <stable@vger.kernel.org>; Thu, 21 Oct 2021 04:15:34 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id 193-20020a1c01ca000000b00327775075f7so942790wmb.5
        for <stable@vger.kernel.org>; Thu, 21 Oct 2021 04:15:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=84PyO+Ug9zsBPcOK6xLng6mGRiOc57s1gDtpbDHQtfU=;
        b=adZscjrDV6eeWWXUzF5qawLrHFvpQocyBLzpJDUl1HrYmmk8uda7RRTpDvki1OQmbU
         sIMFOJgL/AQA4J6FzEx02QlFv86IFipqKv2ec+WbrWEM4ud5Y17LcyCUDMu/45IHkgqO
         bhBabfSfwS/EsyDbmBihDDtbPBXLw8ACowLF8FCIHgJZw3I8pTK2QkYWbSqfg07zTmXr
         wSASVSPDMJMYz558NIEP7+5oqNdpSR/shugszw9TvblShH8VptzsgSdy08e8q25nP4BL
         mnlm3557dxpLmp8IuAa7UCjAV1fPJU5VkrxaPpjIKg6wJlH7pkD3uQDVaKYIvqlt1J7z
         keJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=84PyO+Ug9zsBPcOK6xLng6mGRiOc57s1gDtpbDHQtfU=;
        b=DHOSSAOJOWheXqzRjCOV6dMHgF/2y7RzLCkJgfq3DHCMzVn7tIlqEv3ScMF8IwJJw4
         kPpWWmxxnl+N0aUBfaWgSSu/e0kgxwOfIlXrnGKaXYGBy9yd0sz6EMz4/qfFLBCqPu7c
         /F/zuxO5tx4OjuOpaLfSbshZ8lRhKaIlcxjdVeaLg5/XJV0fCFXZoSKLLPCVn1QVNAB2
         a20uQl+cqvWO9fvI4nAzIgA6cXNaakUvYScqlpO0bzEqJULxRtYif7hgTgSTnD8R+QTn
         q6m8KRkd0RSrpFK//dRrwmgopkZ8QjARphxay3fjiVmgiDvmV6nV1t9AEOeC+gHhYZIf
         ysVg==
X-Gm-Message-State: AOAM531UDMHOUyRHHpCF5VIxO6Yfw/x3JXK/kQrlYQV5uqt+s+4h30xc
        YVvwU3jO5onnwGiSBTynTYuGMqJto3wK7A==
X-Google-Smtp-Source: ABdhPJw+61GLmfQR4ujA9gvIVkhNOfryEo9KzcuFBK5dJc6KKH8TB7IU6OHaNShOANajhvbhT8E2Uw==
X-Received: by 2002:a7b:c007:: with SMTP id c7mr20722827wmb.101.1634814933211;
        Thu, 21 Oct 2021 04:15:33 -0700 (PDT)
Received: from google.com ([95.148.6.207])
        by smtp.gmail.com with ESMTPSA id p12sm5501840wrr.67.2021.10.21.04.15.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Oct 2021 04:15:32 -0700 (PDT)
Date:   Thu, 21 Oct 2021 12:15:31 +0100
From:   Lee Jones <lee.jones@linaro.org>
To:     "andriy.shevchenko@linux.intel.com" 
        <andriy.shevchenko@linux.intel.com>
Cc:     Aditya Garg <gargaditya08@live.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Orlando Chamberlain <redecorating@protonmail.com>
Subject: Re: [PATCHv4] mfd: intel-lpss: Add support for MacBookPro16,2 ICL-N
 UART
Message-ID: <YXFL05vXfoCV/Go/@google.com>
References: <7E63F4C9-6AE9-4E97-9986-B13A397289C5@live.com>
 <YWV4bnbn7VXjYWWy@google.com>
 <FC366D8C-0360-49B2-B641-5A3FD50E3398@live.com>
 <YWg/1zcfMN2+vuiJ@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YWg/1zcfMN2+vuiJ@smile.fi.intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 14 Oct 2021, andriy.shevchenko@linux.intel.com wrote:

> On Thu, Oct 14, 2021 at 04:15:05AM +0000, Aditya Garg wrote:
> 
> Entire message looks like a mess. Are you sure you are using proper tools
> for sending it?

Agreed.

I can't apply this until it's submitted properly.

- Please read Documentation/process/submitting-patches.rst
- Please read Documentation/process/coding-style.rst

If you have any questions, please reach out.  We're happy to help.

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
