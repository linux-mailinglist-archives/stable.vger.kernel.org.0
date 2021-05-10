Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 454403799C8
	for <lists+stable@lfdr.de>; Tue, 11 May 2021 00:15:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230186AbhEJWQM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 18:16:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230136AbhEJWQL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 May 2021 18:16:11 -0400
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B3B5C061574;
        Mon, 10 May 2021 15:15:05 -0700 (PDT)
Received: by mail-ot1-x331.google.com with SMTP id n32-20020a9d1ea30000b02902a53d6ad4bdso15842159otn.3;
        Mon, 10 May 2021 15:15:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rfJ5rR6o9K2PaUY+DLKnjrT5H3F8zfYhdNhGHo92Gio=;
        b=iuO3igUc11kURfT8CizWjbElQ0RFGUSKhh9ec6e4CUuP69v6T9Erq5NIjBI1hzsdhZ
         IDem06HH/cNtn8LzGLTz7uA+LrgpL+fioUWiAt0e19uJ513UygKjlVTraP+RCZOi6FFN
         D5RMTY0NAncQr7qh+AiMjlxZ7kf48rJOabrCdAwPl5RCZVcbVg3L8ruhqOXMX/K4u1Xu
         216OGt04fKfCRX+ELla0j/UW4WRc+zbtfqJk8p7DriBrtYf/kdNr+yJa8nQnJjqhRGQS
         exc/ixf3ZErSgA+QFzPC+V/xWJndOvFFCQLO/WJZ3WFMhL/NpkpC28AIIAqPP7xkqwe5
         Xj7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=rfJ5rR6o9K2PaUY+DLKnjrT5H3F8zfYhdNhGHo92Gio=;
        b=ADQPA+w1UT01/rBT4YL1W/BE5NQMq4LnFsHPyOKdgtFxrb1qgw3tjx5lOJHBX8FAJT
         4+A6AUk/ax5+4P1XSI4CxRtmVFTDnKoZ+cC3rjLVY3zf/wnz2AbutyvVOaIwstDYKXoU
         RrxGzCj1DL+Nez7wrESMyhGaQ7/9wxQSr2QEE3PJMU9rPfNVSTWEEIFCMFr1MPTIMeIB
         HK7Iy+AV4q0AfiFHpjCMrFMDPx4CCWynPFyXiaHaVJk3jyTcSPkQXY8d3yw0x+JNGYCg
         rsyIG65hRZGZkXIiP96OFMGV6+qKta3YukIzKLtTcIjERFKUzpc/Qk2wxsEnn4ArDsqr
         TBwQ==
X-Gm-Message-State: AOAM533TWe8sCxanSjnYYBC554t8dJUwo0MDy1XGHacpfKvqaSsUUlVG
        8wfBOb95QAj+Hg0RnuZpMmo=
X-Google-Smtp-Source: ABdhPJyfi5xYPj3EMpxuyfNyuXL2DD4berUehBrvgMQjnpYI87RWknsamhdHh5lEADUaInZZUro/2Q==
X-Received: by 2002:a9d:1d01:: with SMTP id m1mr23577282otm.155.1620684904880;
        Mon, 10 May 2021 15:15:04 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id k7sm2953091ood.36.2021.05.10.15.15.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 May 2021 15:15:04 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 10 May 2021 15:15:03 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/184] 5.4.118-rc1 review
Message-ID: <20210510221503.GA2334827@roeck-us.net>
References: <20210510101950.200777181@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210510101950.200777181@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 10, 2021 at 12:18:14PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.118 release.
> There are 184 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 12 May 2021 10:19:23 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 428 pass: 428 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
