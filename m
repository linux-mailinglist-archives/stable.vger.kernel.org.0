Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6A2038F2A3
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 19:56:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233422AbhEXR6C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 13:58:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233244AbhEXR6C (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 May 2021 13:58:02 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44F4CC061756
        for <stable@vger.kernel.org>; Mon, 24 May 2021 10:56:34 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id cu11-20020a17090afa8bb029015d5d5d2175so11665839pjb.3
        for <stable@vger.kernel.org>; Mon, 24 May 2021 10:56:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=JwZQhxTS/GfTPS65+/sRF0tVgmUrlLF3uY9XACHcGco=;
        b=GygAdUsVSiyqP92o7Lw9zI1843h4WnOOMTKkzu2EHd7EEI3DlnBtRAsyqv/kYBdJcw
         91wpCxrpVJe4wjTD92vvNBS2wqLtZHHb9/2ELpB0dmT5ky2656wraOUvpdaqPLxNuUId
         vzuCAdfvZ/092dbGhiW8m/IMYPl3kQfNbRvLs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=JwZQhxTS/GfTPS65+/sRF0tVgmUrlLF3uY9XACHcGco=;
        b=ATZQ7qQHGmFzJQlM1aMdntnvj+7vUUD84/sNfcv/md9RDQKH3MQfRBwhFEaY+LlxCa
         JIn4w1hBJSFDiGWUk7xZDh6vSWa3mIPpA4n5TKfXztwYLztSfwOS+u9LLQZDXS0hI79R
         4ESKw+kAbCvKsHeXaX5RzU5tMnWFKCCzKSyMej8mfxAOhFJCj2CDzPWknpiP5AWdPeG/
         90z2e99wO31CjvlMZmFH0IsX5bq8W70aLk8IJgSogAnDQbJAe86N78YJKE7hxTifaygM
         2FZnkEJlust26l+PF8W9fwUU8KrW82ZnNMrPO0q1QFs4rW+qo0o85slpHs7vX4H7xJ1k
         JY4A==
X-Gm-Message-State: AOAM530MHgE2IpUt4e1E9Eq8/7ydNkcHhMXZDC9jP+PykbGwyiTKS+fR
        5StgVBUQ1x1z0L2Nf77Ix3K/JQ==
X-Google-Smtp-Source: ABdhPJxaiZ+abmCf8hAldTYoDVApchfKY9mlOFcNNegiMaa09f3Nm0kTrELbtuBssTEsbgzYGQpnAg==
X-Received: by 2002:a17:902:b109:b029:ef:1ee:9d02 with SMTP id q9-20020a170902b109b02900ef01ee9d02mr26748191plr.85.1621878993744;
        Mon, 24 May 2021 10:56:33 -0700 (PDT)
Received: from d53f71d6d7f0 (110-175-118-133.tpgi.com.au. [110.175.118.133])
        by smtp.gmail.com with ESMTPSA id gb10sm10434381pjb.57.2021.05.24.10.56.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 24 May 2021 10:56:33 -0700 (PDT)
Date:   Mon, 24 May 2021 17:56:26 +0000
From:   Rudi Heitbaum <rudi@heitbaum.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.12 000/127] 5.12.7-rc1 review
Message-ID: <20210524175622.GA20@d53f71d6d7f0>
References: <20210524152334.857620285@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210524152334.857620285@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 24, 2021 at 05:25:17PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.12.7 release.
> There are 127 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 May 2021 15:23:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.7-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On Tiger Lake x86_64 kernel:
- tested ok.

Tested-by: Rudi Heitbaum <rudi@heitbaum.com>
-- 
Rudi
