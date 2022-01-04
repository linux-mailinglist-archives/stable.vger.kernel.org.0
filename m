Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 360014839C5
	for <lists+stable@lfdr.de>; Tue,  4 Jan 2022 02:25:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230253AbiADBZF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 20:25:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230227AbiADBZF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 20:25:05 -0500
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E989C061761;
        Mon,  3 Jan 2022 17:25:05 -0800 (PST)
Received: by mail-oi1-x232.google.com with SMTP id u21so44074676oie.10;
        Mon, 03 Jan 2022 17:25:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2/Z0wFajqM8OAe8smkJEaVIYxqtZoBo0AOAnjB4BUKQ=;
        b=CPaiPGF8EnCcJ6UR2yCACEccK0H3J/waIXV/slbh3PyE9ZZL12Y4DDd91vCrkoxwrX
         X27H46ljmEuWd37VM5jBc/qPPR4ryMOH9VpOVTkSjk/xeTkS7h4iMHBKG3eGrl+0716C
         qxUq/9CW8URZHdwHPKgulfxeRovYPyEqGk30uppZPp15c03OqocRKhX/VBti5aMjCQHq
         QWK1g8/fuAcrlYEWL96BRwD0kpVMNjXEtUGzTnz91U5xHVwhRFemoLeuTxY/6on0sr+T
         c89Hi3/qGOgIGnJS80h8iNsujDIfMTw2NC0m8+y/KsG1DgAQgP+7QXz8rpfBLvTmBerA
         i1mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=2/Z0wFajqM8OAe8smkJEaVIYxqtZoBo0AOAnjB4BUKQ=;
        b=sACxVgRNau5bSSslJcM69F6CkJb1eiy+cGE2rBhjNef15FR+xT+AbYzNCszSCgbCb/
         Kl3vQ0BSm7tiB/5jIu9LgmX5onLN1yhOts7KC1daIpwl5b4lme7LJE2i5Wg5lfBX6BLs
         eFM+noo7RyFWPnI5vgIx3hGO46ETuZh/Je97qL8S9jdu5948jHvYt47DcTdhhU6/EPZV
         0PZUxOX9hcX6/cPJXhvSxD3dPIOY5WmcpKbU/IrxzvGh2vdqHyWi4fWq4FrJ+5Vdi/Z9
         t8DQgeiLYcVgCxmpouHs6EniqG1z7DlxTIxySy9EsQoXzAsKh8Nu7zeN+gFh+OoEaYUg
         sKSw==
X-Gm-Message-State: AOAM5319COSHgQGKydH2zm+iGvlp5hViU67e6Hu6SUztTBGlQZt45PSK
        TsG17aq2FXa+85/5UFC67cgk9mffEls=
X-Google-Smtp-Source: ABdhPJy1XUnzsdNdxPT8XGB23K0i6XrkxE44eNA6r6slB4hLRpBxW03DyLlElRkh3SMRxcEV4jFZRQ==
X-Received: by 2002:a05:6808:10c9:: with SMTP id s9mr36656943ois.23.1641259504307;
        Mon, 03 Jan 2022 17:25:04 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id x12sm7367385oom.44.2022.01.03.17.25.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jan 2022 17:25:03 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 3 Jan 2022 17:25:02 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/27] 4.19.224-rc1 review
Message-ID: <20220104012502.GC1572562@roeck-us.net>
References: <20220103142052.162223000@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220103142052.162223000@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 03, 2022 at 03:23:40PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.224 release.
> There are 27 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 05 Jan 2022 14:20:40 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 422 pass: 422 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
