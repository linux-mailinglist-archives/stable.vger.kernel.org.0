Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72CF0446462
	for <lists+stable@lfdr.de>; Fri,  5 Nov 2021 14:44:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233092AbhKENqy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Nov 2021 09:46:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233015AbhKENqy (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Nov 2021 09:46:54 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E3D9C061205
        for <stable@vger.kernel.org>; Fri,  5 Nov 2021 06:44:14 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id b12so13825403wrh.4
        for <stable@vger.kernel.org>; Fri, 05 Nov 2021 06:44:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :content-transfer-encoding;
        bh=snx5IdStXoxnNy/JFY0xnDVQNvsxaMatNZgT4R6LL3M=;
        b=vZVA9rVJ8XZERKTGvHfZQ12kX6iTwnrAod7t20ayB+z2mGX/RpTKfRkn5DRBprVi2G
         KVtK3dAnJ+xGxa23dMgWwJauoh3iR9uj6YrHG4a6+j9o9ryFFhUEQjs69mRvrTKX7WvX
         66DQmrOtgSfMkY00Ms1TB4dOm1p6wPxlXUrYfEUwI3G4456fR4Fx/wKgRseBb60pkd2y
         1koDzOwKv5PU0kH76cSDZIyzgOd/yRilOG7hj1fbDTcf9/QFLdPs7ZefAK6M0gLtYqbY
         okFiKtEH1EyqcntDgSr82lG9RPnS4Katns2eQXP+2Vr83NR0ifUweheRkSa5CqiSGIhr
         eI8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:content-transfer-encoding;
        bh=snx5IdStXoxnNy/JFY0xnDVQNvsxaMatNZgT4R6LL3M=;
        b=Jc1RsdgvDpCfaqanKI5kbstiD+UF7SRI2ZDobPTgpjgUnYRR338f2rYIty7o2ZH2PF
         tPISruA8upqnRpuYMS0839JjEfpqN28kCZShzA3jKwoYqUKThDmQKZZRyqYjZaVG3qCb
         hwj1ykeybYpsRIsbNWfzgNvOUy58LDqyFieiT8k8/IhMJ84wavwHnT/pv+K1Koxdz4lK
         vtnCgOlD6U/jVPBtAYzKtk7mYN4BjEn5S/lLJOews+MBQ4cquVnE2oMhJngffobAEJ1V
         nRQGQBgPXI3Pe5k4OdklKMTkJORwdzjt4U+LurhOk1JdfLzr0NWxDVjy+hAmYWxJ5s8E
         KWrA==
X-Gm-Message-State: AOAM531Nt80SEjZcyN1ocopQ+TT+/a706YG2Em+fWgtbQYIXIrYREZwI
        D/Rc4Xe2dP4fZgyorny3CQnY/xPqANLgJg==
X-Google-Smtp-Source: ABdhPJxPFQrGqtZYn0ID0M96jKOyOS8NpAqWb25gZLSXAjK7HFAr1ZKSN2BtbW+zXB/9vbVdTzvCTA==
X-Received: by 2002:a5d:6d8b:: with SMTP id l11mr28556733wrs.178.1636119852910;
        Fri, 05 Nov 2021 06:44:12 -0700 (PDT)
Received: from google.com ([95.148.6.174])
        by smtp.gmail.com with ESMTPSA id p27sm7431639wmi.28.2021.11.05.06.44.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Nov 2021 06:44:12 -0700 (PDT)
Date:   Fri, 5 Nov 2021 13:44:10 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Subject: [v4.4.y and v4.9.y] net: hso: register netdev later to avoid a race
 condition
Message-ID: <YYU1KqvnZLyPbFcb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Stable Maintainers,

Please consider this patch for back-porting to v4.4y and v4.9.y

  4c761daf8bb9a ("net: hso: register netdev later to avoid a race condition")

It should apply cleanly to both branches.

Kind regards,
Lee

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
