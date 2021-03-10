Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82A0633681B
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 00:53:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233970AbhCJXvb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 18:51:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233927AbhCJXvX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Mar 2021 18:51:23 -0500
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60E5DC061574;
        Wed, 10 Mar 2021 15:51:23 -0800 (PST)
Received: by mail-oi1-x232.google.com with SMTP id u6so13823328oic.2;
        Wed, 10 Mar 2021 15:51:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=bzzFRYMnNsL52a5MAwRJbIgvuX8CIFTgsznWe2hQtRA=;
        b=eaMSDRnB7/wT4gkpFzeoB144EWe/UNxadPjVSx+tUKYy6rvaqxZJDPlfBpx49ZeDch
         q+AK0a80vLviUR11y/FXfkyraFo1Ruq6E8mj6uQA0WQ9HeyQDiSmC+8eDs3wqsSzcB7p
         Yy32LIWkOo/GTeN5hf8pK9sN14h8Kr5Rn1/9DhyUH/wiFhJG4OjFck9BeXYz88zSdnWR
         ovN1AbVoV4Ck4OO6jhkGJJC9jh50/nSYt4dC0SXXITEqJDzRz2rjHRwO0DdSCNc8VEtX
         pn5EjDXZNFQGMZwS0Ant4iJXY23DIbE323QIFACFLBx159YRX9ZtRx8aKnn4STg8qLU9
         esFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=bzzFRYMnNsL52a5MAwRJbIgvuX8CIFTgsznWe2hQtRA=;
        b=GQwr8GGEw/pe1hhkZlkSCpqypZ2OM/X8BzSa0uCkZ3Py7F2Y86RRrqL6kF+flYYq6L
         /42yT8wT4pZ1wsAmfp8BeYJnBlTTndH/DqcslZKAT1y2zvfJzjNHY7JOIDZXix+5hP2f
         j5DsesX729HEkBkUL4PKGC2xn5UbG5R/nMSG46qCHuFNCjMYP3HwstU0e2QTh7sS4ctj
         pPdjndO7ke5ak4kah9MoO1JUPlFngmrdBMpVuOczVY797VPaCQZs523guigISQaqlXxG
         hSGMtrtzGM0QABShEQL9TBdcywGpplkaOAszhUDs39aXIgm0rXJS/D8e38fewJsmNDRn
         CmYA==
X-Gm-Message-State: AOAM533zEVsxpwoAUsSoYtMhszhBUlNcwptB7kHxdSWrycJPrS51eSCb
        EXyXpBtQLuujZuL0oUrkUwRCBSirmhI=
X-Google-Smtp-Source: ABdhPJybv0WU62a62Qj+lOmDQTOmZHbF7slFsyJSUtnMTCD9oikx07Gvc1YkNegdShdEtzYjq8Fk2w==
X-Received: by 2002:aca:4bc5:: with SMTP id y188mr4131077oia.136.1615420282890;
        Wed, 10 Mar 2021 15:51:22 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id s125sm199854oif.56.2021.03.10.15.51.22
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 10 Mar 2021 15:51:22 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 10 Mar 2021 15:51:21 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     gregkh@linuxfoundation.org
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/20] 4.14.225-rc1 review
Message-ID: <20210310235121.GC195769@roeck-us.net>
References: <20210310132320.512307035@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210310132320.512307035@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 10, 2021 at 02:24:37PM +0100, gregkh@linuxfoundation.org wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> This is the start of the stable review cycle for the 4.14.225 release.
> There are 20 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 12 Mar 2021 13:23:09 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 406 pass: 406 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
