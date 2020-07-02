Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90C62211C08
	for <lists+stable@lfdr.de>; Thu,  2 Jul 2020 08:36:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726750AbgGBGgo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jul 2020 02:36:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725774AbgGBGgo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Jul 2020 02:36:44 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46E22C08C5DC
        for <stable@vger.kernel.org>; Wed,  1 Jul 2020 23:36:43 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id r12so26631324wrj.13
        for <stable@vger.kernel.org>; Wed, 01 Jul 2020 23:36:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=SOKqOe4L7TMyuElLZWsmgBtZwav1eGG59T+nolvpwkw=;
        b=JMI02/fsxLotFjWL3uyt16s/4THlU6WMPFpX9H+6IutigtdGcrj61TQkOSgyiMnw0S
         E0wnZ0QEw76P44VUBFbG54XMGl5uGaAHCPNdExh2A55yMxwzS4B36pxJ8VrALTiKhqCW
         UP68v0FdCJ1BmksGnpC3eXPDwixeWOuSKJ+86jibdJsrutXrN9DKNps0ODWYiU9MTlHL
         ip29cO94djYVghdW6MelQHt7HM6D+oT3AbdPqcpTiOGzCRG+z5dG//y+YWxBQgkMCi3q
         wcNtMJS+gBi4bsVuXSze5YmHsJGKbs9AQLAABBIwHh9zamrZQ87lpriGh45J+91287M3
         +ubA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=SOKqOe4L7TMyuElLZWsmgBtZwav1eGG59T+nolvpwkw=;
        b=Gsza+x9odM6ccECJwmumImc2Ts7mD6k7p6l/2s3gH+JObV9EGLbJ5qJNA7pnxDM9Sj
         Tsoo3Is5BAM2jBfwxOeBOdBzJ7nCFJd9v8Elnhz9K14SNpmNLqaR46UyPgaUmDXdVomD
         QdrgdPl5QeFioayXzMF7YPpGC9rMSxFvQfq9Dl+8+yeCWJt5ul0+Lyk6hvmKt/PANnuF
         PGrINpcJhiAGiHF4yMIcQpkE5/Jcenks5ZDEkxEui2jXaslGQNj7T0UFukhtn7APhUJw
         3eXn+BtOIz5VDrS6rytQRNerIuZVURSoPgCr9dM3b6f+412Zzk9OhxC1+G18rHoFvicq
         50IA==
X-Gm-Message-State: AOAM533a6Do+huqwcwCR1yGgbY8OulJcrV+t8PyBARTHvpB9UktuVF1N
        SRgtn43NQLJl0LXHmdhYl90ifg==
X-Google-Smtp-Source: ABdhPJxnBWWH4RISuQvb3jhaqkaVlD9sZGwI4WlnfQJngaPXvUWW/LS69/28os21aHQO2hXiHny4pg==
X-Received: by 2002:adf:dd4a:: with SMTP id u10mr29641330wrm.169.1593671802062;
        Wed, 01 Jul 2020 23:36:42 -0700 (PDT)
Received: from dell ([2.27.35.144])
        by smtp.gmail.com with ESMTPSA id u186sm9670755wmu.10.2020.07.01.23.36.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2020 23:36:41 -0700 (PDT)
Date:   Thu, 2 Jul 2020 07:36:40 +0100
From:   Lee Jones <lee.jones@linaro.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 02/10] mfd: mfd-core: Complete kerneldoc header for
 devm_mfd_add_devices()
Message-ID: <20200702063640.GN1179328@dell>
References: <20200625064619.2775707-3-lee.jones@linaro.org>
 <20200701193313.81C9F20760@mail.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200701193313.81C9F20760@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 01 Jul 2020, Sasha Levin wrote:

> Hi
> 
> [This is an automated email]
> 
> This commit has been processed because it contains a -stable tag.
> The stable tag indicates that it's relevant for the following trees: all
> 
> The bot has tested the following trees: v5.7.6, v5.4.49, v4.19.130, v4.14.186, v4.9.228, v4.4.228.
> 
> v5.7.6: Build OK!
> v5.4.49: Build OK!
> v4.19.130: Build OK!
> v4.14.186: Build OK!
> v4.9.228: Build OK!
> v4.4.228: Failed to apply! Possible dependencies:
>     a8f447be8056d ("mfd: Add resource managed APIs for mfd_add_devices")
> 
> 
> NOTE: The patch will not be queued to stable trees until it is upstream.
> 
> How should we proceed with this patch?

Please drop it.

Greg indicated that these should not be bound for Stable.

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
