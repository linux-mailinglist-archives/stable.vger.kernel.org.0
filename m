Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A02C6390B69
	for <lists+stable@lfdr.de>; Tue, 25 May 2021 23:26:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233130AbhEYV2W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 May 2021 17:28:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233125AbhEYV2V (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 May 2021 17:28:21 -0400
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D401AC061574;
        Tue, 25 May 2021 14:26:50 -0700 (PDT)
Received: by mail-ot1-x332.google.com with SMTP id n3-20020a9d74030000b029035e65d0a0b8so8619939otk.9;
        Tue, 25 May 2021 14:26:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=WOHN53TtYAkKmFbySvXR26nU4ULHgaiw/p/j9KXY8hQ=;
        b=dPqbTt7EBovGcexiUHXfi/WzFYRgP70wiVx2KHISV/ICSFK3aggZW5bvQEJn6F7+ws
         Ar7Vww/dQHW83waJOS3+Tgw4sn7Z7NMpcUiUH9vmNNENPRBm+WyChcUW8QvoJwgx/TCH
         HEGzzXCaYVPhRwriCsAALgXo1zza0eP95g0vS9nlss1MIbCD5nXtAU2LhFBzi/Wpj1e6
         nN7o6p6EmKR4Hh/i9qYHTUW18fPedd+cUwtdVImtC+dmhRJLnoopntpZkF2qdMTbhVQ4
         J5ulMNX65qbYayg8Zth1hcpkHlNkYeWi3kVh1n8hTvRxUYtI5+RaPBx8cejlGV/KnDKp
         4ygA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=WOHN53TtYAkKmFbySvXR26nU4ULHgaiw/p/j9KXY8hQ=;
        b=Au5rwZF9vdPQ1IIdpgB4qGhrgfUamOTFDe16ReIxTl8DHc4sorIa6nWfKvSyN9MDTd
         JPPM3/Wj3N88AHJ1nfNSlpWuKMhKqbi0GHEtZiSuL/GDvzT7uNpgwpnkPYv/D4s4QbTt
         ggOfmfwgPqofUb3yaWrWfjA6NJEcW3dfZtjpNCRnCQDEv4i6yTVK3N5zB10xdYSpuG5j
         0KF72RZOYgjGm3f/jzlUM+H4gmPQCVMc2UpEXOLbLBCGLspQucb10qTQy6envJTXHQ21
         pGxY1aNVwRBzmbMrGVSjghCjKO99hby0axsvtINHFMrBtndsugEOmJl3xK/L3YSYG/Qp
         7PSg==
X-Gm-Message-State: AOAM532aAl06qdB9Zbux0VIsdTFtmpF7HTUAb1hRe8gTc9Qf3wi5QuUN
        Pfg9p6hksU5dYBXeE7BNiC4=
X-Google-Smtp-Source: ABdhPJwb5OSYcqLIobVSeeuWcftL0gxaXL+WSxrW6GrDzIywUHjV9Zn7UAVequy+snFU0v7vodX70Q==
X-Received: by 2002:a9d:6048:: with SMTP id v8mr25204093otj.30.1621978010301;
        Tue, 25 May 2021 14:26:50 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id k7sm3786803ood.36.2021.05.25.14.26.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 May 2021 14:26:49 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 25 May 2021 14:26:48 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/104] 5.10.40-rc1 review
Message-ID: <20210525212648.GF921026@roeck-us.net>
References: <20210524152332.844251980@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210524152332.844251980@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 24, 2021 at 05:24:55PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.40 release.
> There are 104 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 May 2021 15:23:11 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 455 pass: 455 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
