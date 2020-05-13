Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A9CF1D1439
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 15:13:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387418AbgEMNNR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 09:13:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733113AbgEMNNQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 May 2020 09:13:16 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7D35C061A0C
        for <stable@vger.kernel.org>; Wed, 13 May 2020 06:13:15 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id n5so13540893wmd.0
        for <stable@vger.kernel.org>; Wed, 13 May 2020 06:13:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=bXdwa4Lv7NwJIm4NMLt9HIgu+ayZMpLRbSfhDYetwF0=;
        b=IqiPj/kkoo2qLWhtA/0Kp6XkQuhITmerRhALci1c1K7SG9206qYRlVyRZAwYzFIDWl
         VVHegyZaey5R3jJyOG7GtM6y5IQeTiV2uZcBNKT0MlhlTLItKOK/2MGhtQkNYKV8DkkV
         8gufv8aqTxGanlog56Q9XGSwYWtc3uouk/iOaIsogo9yX+XMxwMjuxGh007uhNVc3s2S
         OQBwdtS+ClbPfZhcXr0UliPVk9UvqJxs3RiZDVh81yATSp2MDfKgxlqjD2NF8dzm7kTV
         +NqpdVGF4QHZ7ujuZeNACqj5vkR0/xL6DHQN05az+K2RAdTARQoQW0DelKRoSNX2Vlpm
         C6ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=bXdwa4Lv7NwJIm4NMLt9HIgu+ayZMpLRbSfhDYetwF0=;
        b=Rp7TrwSalwiZYQ9dNr6UPMJI8nOQbDL0PTMunAPF33zqUIqw0N9JZRFoUmjkSilGQh
         P20HC2w4XLCtfexIXJn0395wL7Uh8SQuz96U8yyMKBRJ+sn7aQKANHyljrA783u7eNVG
         zT1UczAfhLBtiU7PDlN+M6zJ9ib+GFbOfIpk6D610lkz+kTC9rB0DRcPvDXJwbkR7ARD
         vmUa8N3MR4+XbKzlmtkRbS2EG2tvl/DjZSqIEC4d7GQBDKgsb7y38sWpdymTNGCgypEl
         EIBiVXszbPnDF/xJdu1+tkzqG2eW97Lx/00DhfNJm2HOP5ydah96JrbV7Mo3aBzS2zc9
         zrKg==
X-Gm-Message-State: AOAM531sop7cmzPyHM8UGoQNTIWd1llA8A8d3II89cr8SqFEmeG9kgB3
        DPmkpumlcE/B1vIcMYQ1sxMmum115Y4=
X-Google-Smtp-Source: ABdhPJx8vPLavIPIIRwX+Ra8cDXViqR0hHv9EPe6wDvlrVJcuHFOWh6SCkS2Wi+imRrLnfWI8PmZbA==
X-Received: by 2002:a1c:a947:: with SMTP id s68mr8251337wme.25.1589375594394;
        Wed, 13 May 2020 06:13:14 -0700 (PDT)
Received: from dell ([2.31.163.63])
        by smtp.gmail.com with ESMTPSA id u67sm23303497wmu.3.2020.05.13.06.13.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 May 2020 06:13:13 -0700 (PDT)
Date:   Wed, 13 May 2020 14:13:12 +0100
From:   Lee Jones <lee.jones@linaro.org>
To:     Greg KH <greg@kroah.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 4.9 00/21] Backported fixes taken from Sony's Vendor tree
Message-ID: <20200513131312.GB271301@dell>
References: <20200422111957.569589-1-lee.jones@linaro.org>
 <20200513093956.GC831267@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200513093956.GC831267@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 13 May 2020, Greg KH wrote:

> On Wed, Apr 22, 2020 at 12:19:36PM +0100, Lee Jones wrote:
> > A recent review of the Sony Xperia Development kernel tree [0] resulted
> > in the discovery of various patches which have been backported from
> > Mainline in order to fix an array of issues.  These patches should be
> > applied to Stable such that everyone can benefit from them.
> > 
> > Note: The review is still on-going (~50%) - more to follow.
> 
> I think I already took some of these, but not all, and I can't remember
> why.  Can you resend the needed ones please?

Yes.  I sent them for the more recent kernels and you(r scripts) added
them to later ones as part of the normal process.  You said to send
them anyway, saying something like "not applying patches is not hard
for [you] to do".

-- 
Lee Jones [李琼斯]
Linaro Services Technical Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
