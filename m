Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15980354658
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 19:57:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232453AbhDER5j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 13:57:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232452AbhDER5i (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Apr 2021 13:57:38 -0400
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44400C061756;
        Mon,  5 Apr 2021 10:57:31 -0700 (PDT)
Received: by mail-ot1-x332.google.com with SMTP id 91-20020a9d08640000b0290237d9c40382so12098430oty.12;
        Mon, 05 Apr 2021 10:57:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=g8Z/Axue1/q8ZEpiNX0mDPgO94LbDTOJhockv3AJCE0=;
        b=pRorokI+zn2Lh/9XNH60WSis6Tn19N3ZSb8qFopLpYmmc1Aue3zdX364c/H+bWhClf
         TFZ7MIYJ4i8pGse6T7SAhMlJO3CeVxLA5s23+XSClu29m8bU0q0yVlWGUdg4pIT2Z0k1
         4ahblPjRp9KjKuaRbZL3zHAXfQ3PpvvA9bqm2jOTkUhR9KX+e8eg+diWPh3k9XrB4asd
         cicRiHOA44dJ32PD25uVXTOe5V+KKFLiU189XDWh07LTb+V8T6p9aoBJfKPgIdmfLo0U
         TGrRjtLWmw8r4cTUhv9nhLeEumyxQ3dk9pY2kqkLvQW4TpAsKHuBZoX0kDfjtlWJjI68
         UDLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=g8Z/Axue1/q8ZEpiNX0mDPgO94LbDTOJhockv3AJCE0=;
        b=Fok20sGILp48wZS950Og646uMxWTd2re422N0zfSgfoIMFNrwHbwyFjR2j6TuD5p43
         I+8eJqGZfpsXa/7H0XkQPmqyTbvZ7l3yBBncrT+i+YqJSpe4cfK8yrWze5Nls9NRpsy4
         ihnQ/XOn3m5r/oXdk+NzHjoaY1kyLzO06WhKI59fTHfHuOtQ4FOrV3oBEXtaRIkvFi2r
         VCzdxMVSyLwP+/9Jqlor7eIU0MP0VQFAeUNRXQDcv/Mj/mGUxh5lI1csVpzwUlVaBO2s
         PYDYYnBgW32/JGphGeDToAyucOuI0hSIuaaGwZu1hAyIKGqJzDJNw6Xxl+sV6lCcFOZT
         FN/w==
X-Gm-Message-State: AOAM533VR+ugB8puwVbVac6Iyc/lsjQ1iXMz/Rw6D0gquFY1vvSHaLir
        SH3ZTeg9nh0NVu/FDPoMKfA=
X-Google-Smtp-Source: ABdhPJx/824M4aS7zy1bjGLt7L7Xikh1R4LSLRZRyBJksa4Hgx0XUz1htx2n2Aqk7RGk2U72O9g2Dg==
X-Received: by 2002:a9d:6a91:: with SMTP id l17mr23162197otq.297.1617645450722;
        Mon, 05 Apr 2021 10:57:30 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id a6sm3084785oiw.44.2021.04.05.10.57.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 05 Apr 2021 10:57:30 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 5 Apr 2021 10:57:29 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/56] 4.19.185-rc1 review
Message-ID: <20210405175729.GD93485@roeck-us.net>
References: <20210405085022.562176619@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210405085022.562176619@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 05, 2021 at 10:53:31AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.185 release.
> There are 56 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 07 Apr 2021 08:50:09 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 423 pass: 423 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
