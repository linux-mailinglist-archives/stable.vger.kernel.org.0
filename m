Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1483322159
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 22:28:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231970AbhBVV17 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 16:27:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231624AbhBVV1c (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Feb 2021 16:27:32 -0500
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4E4CC061574;
        Mon, 22 Feb 2021 13:26:51 -0800 (PST)
Received: by mail-ot1-x32a.google.com with SMTP id c16so13547060otp.0;
        Mon, 22 Feb 2021 13:26:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=zaJGZVdWYhx6pYkLkRmSFtJpbY7PuqWAI5ylr9y3vXY=;
        b=ZuOh5szYiXqqVtdi7pynNynvmCc3R9f7+Qkcu5AmztfPU08JNOv8tuFv4T32qQbcpW
         JuJtwuktw/ouu7/venfpmhEzzhQ89UE3aPIO7IfJK1SXj2/JapkTm6mHZRcUmPGGfoVD
         9tXn8S7ykGWCB/3E/EiDzbi6C88erMzQ38YUAQg6sJOSVfte6aBUjuOKfqUl3IkwdO49
         0EUiefW0BOfDb1BhCA6SGhwFVca7jjsYXNzm0YHMMUzLgKgSaNWbumLlY+dsHRqh5JUC
         7uTdD5XNUyY5l4whCc0kig0YiIM73Qqg7gb9q6m3PkBuV7FXEDGQaRlNquuJYtKo+idO
         ZQhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=zaJGZVdWYhx6pYkLkRmSFtJpbY7PuqWAI5ylr9y3vXY=;
        b=lI9gqIYOvtfBFV3kfb7Inpkq/erI3+v93dINMgLCRPyzDayYUqga+MJCm3UEV1S6t/
         YmULtnnF+Jv3E4nJJUSztNZ2mE5rG9ApI5+7ffEpctFCt+1MWMMmt3OZ5obtI8w2rU0W
         5ahnaCUwUjRudMcLIb4a2RZGVcLjJ7m15zDycT1leJkM9gxkA0+aGcjzX5Reojn+H7OD
         3sBO+gerXcFx+7pj24AKaMln03gz7eusf2cfEX0ZxRpfIGZlT8+es3D0WKehOfXOQpd4
         dFoVrEEbZXbcR65DB2NaH10OhONcswQQBIx8MdTmLAF5cxoywJcXF2FnXLkdm2QKHlRo
         edaA==
X-Gm-Message-State: AOAM531Hv28vXb10vJdc6FbTJChKrv3o4O4rt82O+YBm6q7JHq8hx5x5
        51Dleiv/GXyhyE0KR2yrmCE=
X-Google-Smtp-Source: ABdhPJyJwYZyciyRBM8pgnjte/Oo6wPCpbc+Zvk67jbVhXh656XPv/scZWioinFj6TCDYGzshfzuOQ==
X-Received: by 2002:a9d:6317:: with SMTP id q23mr17739027otk.301.1614029211312;
        Mon, 22 Feb 2021 13:26:51 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id n11sm979438oij.51.2021.02.22.13.26.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 22 Feb 2021 13:26:50 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 22 Feb 2021 13:26:49 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/35] 4.4.258-rc1 review
Message-ID: <20210222212649.GA98612@roeck-us.net>
References: <20210222121013.581198717@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210222121013.581198717@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 22, 2021 at 01:35:56PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.258 release.
> There are 35 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 24 Feb 2021 12:07:46 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 165 pass: 165 fail: 0
Qemu test results:
	total: 329 pass: 329 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
