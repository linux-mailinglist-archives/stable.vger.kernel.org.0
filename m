Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFB5533681F
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 00:53:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233455AbhCJXwG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 18:52:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234090AbhCJXvr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Mar 2021 18:51:47 -0500
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41A61C061574;
        Wed, 10 Mar 2021 15:51:47 -0800 (PST)
Received: by mail-oi1-x22c.google.com with SMTP id u6so13824363oic.2;
        Wed, 10 Mar 2021 15:51:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=/r3tuuRnUDPd9QNvmk9jjYl55fzhy9aCmPyZDJxcQn0=;
        b=WRXS7WqAsrlyzR5kMB4YLX/RRBHDFXgvRRbw23cIfxnU32gDSoyYk6qKLyoqJ9f2ms
         pXQANGFJ+EGriuhNNntq72qcXl69kN76rKVTvba/JkQJ/kCogR7YvseXus9A1FwZ9M7I
         5wclopGCB95oO2o5hRJuGEHnE5oeS7/oWWnli1qCA1pLzTeiYWunXDTFJw2/mu2SVVxf
         zv61VvItrcIAZieAaNcyJ0aJdb9t1Ge13bbSO0AlZfnMVU/8uk01feSQD6+yLUYYcaUp
         4zeShKlNXw1DFFUfyQr7fC0YN6SUf8i8OoqaUqXqr4whzOJrOD7C5v024q/z3Ba8MjCw
         aPhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=/r3tuuRnUDPd9QNvmk9jjYl55fzhy9aCmPyZDJxcQn0=;
        b=RRvUu49KaU+edZE4e86dI1E72v99jC6qgRuh6VBvP/jefczrWqe0RRfg38DLwP1tm9
         H+laayvJNHYPL+Wtu+ifGwCvRH2S6aERPqUEJnGPNEah9wuqq4VhPkzAQ8XozBCwZafq
         zUpby5hgQBIpKxtHiMYjGPqmrkm0Awelz/9gBrCG+wxg6hxd9uCmmlP7oUMyC2RzINVI
         j7uiLX4TzD8x4pd49QkwlXWeFofQuaiA5ji4C5Zg5TqHwnVgX0/1TUPd3QGLGLWlJZlM
         ixAHp1pvvD1nmsCS+TlctoR8hHHX5d0SrnlHkNLNEUqqp+RSiXdwyCAkioJ6TanZfDEy
         HgFQ==
X-Gm-Message-State: AOAM533t6uqG1tSZztBtXiLq/9IMops4rGZ++KxPbqqqVZ3BM4JslyK8
        T/PyocMTj+Kzxo9otjNOqks=
X-Google-Smtp-Source: ABdhPJzjYFxqntjtt2dYHXF4QGL7f7OJXl0j6K0qLhZN9mw3YCzT6DbpSt4/uJ8TDTPUEM11PA3AZQ==
X-Received: by 2002:aca:3058:: with SMTP id w85mr4218111oiw.19.1615420306690;
        Wed, 10 Mar 2021 15:51:46 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id a49sm264554otc.37.2021.03.10.15.51.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 10 Mar 2021 15:51:46 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 10 Mar 2021 15:51:45 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     gregkh@linuxfoundation.org
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/39] 4.19.180-rc1 review
Message-ID: <20210310235145.GD195769@roeck-us.net>
References: <20210310132319.708237392@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210310132319.708237392@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 10, 2021 at 02:24:08PM +0100, gregkh@linuxfoundation.org wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> This is the start of the stable review cycle for the 4.19.180 release.
> There are 39 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 12 Mar 2021 13:23:09 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 420 pass: 420 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
