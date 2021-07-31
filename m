Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31EF93DC360
	for <lists+stable@lfdr.de>; Sat, 31 Jul 2021 06:43:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233122AbhGaEnZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Jul 2021 00:43:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbhGaEnZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 31 Jul 2021 00:43:25 -0400
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE9DCC06175F;
        Fri, 30 Jul 2021 21:43:18 -0700 (PDT)
Received: by mail-oi1-x22c.google.com with SMTP id u25so16174017oiv.5;
        Fri, 30 Jul 2021 21:43:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9epKkeaI73ufxdcM849R9ioRNB8fulcUUIbBSUQ7Rw4=;
        b=S1H5kDcKFNEOo+a5hClYXq+GlsFu9/HbaDlJ9OFP01wRybfDpWyde/PeNOGDBhlg/D
         uHIueSWoYgbu9jH/kiAN2RfapKeN/gRJhBbnsRMSLBCqjpp7PSb/UFekda2QwRu3ehBh
         BbioVkpr+1YYLECy+01KxSN1+JjlB1Pwp9L6L4iX3EGjQ7/QM/FoClvq8dpzmy06XiOB
         8XcQ+eMBGlyJiWdsF2QQuINYzFq8zVjo1yA2yWBepLqk3FIGK6PlfJmdho4aKjgRv8tF
         KWTglYESY+aw8VagxZKYt5O3KxZYr9kwzVXn3nIxICom10Ut+A+ETzALo0qrrwrELOp6
         D+vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=9epKkeaI73ufxdcM849R9ioRNB8fulcUUIbBSUQ7Rw4=;
        b=kle2eGlBEoNeOfvJrM54sBySpoCd6gmqEX3Krh9Fjj4BxBWjOGn6fyq8NoQ7QOv4sH
         eBkkKcfU6GO/ZafBw4NVZ5Csk7dNnJCtezOPwqziZPHH9aflFD59T/jfTdpJeLgBpd3R
         uMnD4uITVpclcdQnnjbXGZoMWolPp8ykwVkNaVnHZpQX5Uq+egBFmsbngn0r8O0N1lDw
         9J+dPVyK2JFJ0BtlHzMOgxl2/dBhX+fPZuIajwdoeF60TWOfrq6mPbJId6P9r3/TSSL8
         i8WiNkphpghywDQNm+QrSQa886KyPSdfpNkLdtJxHLd6q7ahOJZdzy8HcHxvdVUe1VOc
         eV8w==
X-Gm-Message-State: AOAM530BiGNU4fGhiq0aT3m9a+bTL9Fcb+WNjsRmqXNNZaKpvzbipSVl
        DQp5LOxvGn4KXDregiJ7fJ8=
X-Google-Smtp-Source: ABdhPJwc1XTc+Bs8hROZjhsfW1rU/q4RY720mlRB0XyOqPX/vuG4yg0Wa/DJ8l2cuY3HpG3X+zpInw==
X-Received: by 2002:aca:dd85:: with SMTP id u127mr4118692oig.161.1627706598099;
        Fri, 30 Jul 2021 21:43:18 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id a66sm683028otb.35.2021.07.30.21.43.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Jul 2021 21:43:17 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 30 Jul 2021 21:43:16 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/21] 5.4.137-rc1 review
Message-ID: <20210731044316.GB3455442@roeck-us.net>
References: <20210729135142.920143237@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210729135142.920143237@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 29, 2021 at 03:54:07PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.137 release.
> There are 21 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 31 Jul 2021 13:51:22 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 435 pass: 435 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
