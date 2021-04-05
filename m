Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDADC35465E
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 19:59:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239656AbhDER7T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 13:59:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232452AbhDER7S (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Apr 2021 13:59:18 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E004C061756;
        Mon,  5 Apr 2021 10:59:12 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id s16-20020a0568301490b02901b83efc84a0so3214772otq.10;
        Mon, 05 Apr 2021 10:59:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Tcazeii8EiNU6rYq/wbn1fDm6B5CdEWETEhcCqw+q10=;
        b=oBZ3v4UeZZyFY4cUe/l/D85rnfx09kc/kZFh0bnYulmyNdEzpsoit0a2M3FRHrh3gh
         KQoVUeX65otXAO2NOlWo9qML2v271+L5jCWlVim2ZBtmsJSjo00dP0EKyIbqbarnL6+u
         tUZaBUpCrTWOAAshulBzMaigM0p+0Fv/xTsgyO6/gYAhcRoIY100Eed+Ae14yi+cke64
         lcccXRaCP2YiWtO8WJWEWKgLkh1g4hg/S0ne+Omg1XCEfeHrXPC9FZ52lemt4K4sqJ3i
         DqegoaPLoJKAXTSKx4MrX/1Szyxl/sDK/G9fr30gZYGTnMyqLMfbFoxSAdzClXGZVccy
         YMHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=Tcazeii8EiNU6rYq/wbn1fDm6B5CdEWETEhcCqw+q10=;
        b=pUzzH5Rc1tUWe28k2Vuuxbs4wvEXe+1WaWnml/R6ZKHe2cl7gWO0nvhIwqRBW5A9+p
         bO13Nga2t3GtMdMAKFh1yPaqdhashU3LvSc7uZXJpv3XPBjAcnurjm/iBkQSED6h560+
         /21ZDrOkSz0V+u50stMZppcrgaYDGdnseNT8BZF58lt3ddvGrpIxVzKMpQw5D1qq2QIk
         zQigf/q5rt5uRTOcyFtacAyTDET+mKNIa5Llxy54K4qiFntdVmCr35DxhZvqZ8sqxEfs
         C5S23gUx2nVp/ASOCzWiJLfLunZaBReZdYLaIvu/xCzdyg7JnTeK0xyph2GEe+sZZ62Y
         41Uw==
X-Gm-Message-State: AOAM532icm1+ZPWy92TIjKMBUVK6cKUofxb7YmjoGB9X2T0E/iy3+jGV
        9oW3AjqFbwR0iEKcIvG77T8=
X-Google-Smtp-Source: ABdhPJzwUMGf7lHoVuwjevPiw0B3N2hHkmKGdyLyv1IPBKVs9CoyHh4TsaZmpYsYBB6hby5ryLFRhw==
X-Received: by 2002:a9d:63d4:: with SMTP id e20mr23378128otl.60.1617645551643;
        Mon, 05 Apr 2021 10:59:11 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id z8sm3189383oih.1.2021.04.05.10.59.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 05 Apr 2021 10:59:11 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 5 Apr 2021 10:59:10 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/126] 5.10.28-rc1 review
Message-ID: <20210405175910.GF93485@roeck-us.net>
References: <20210405085031.040238881@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210405085031.040238881@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 05, 2021 at 10:52:42AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.28 release.
> There are 126 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 07 Apr 2021 08:50:09 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 454 pass: 454 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
