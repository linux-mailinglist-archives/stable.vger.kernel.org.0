Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC9FF233712
	for <lists+stable@lfdr.de>; Thu, 30 Jul 2020 18:46:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728497AbgG3Qqs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jul 2020 12:46:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726275AbgG3Qqs (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jul 2020 12:46:48 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46CB8C061574;
        Thu, 30 Jul 2020 09:46:48 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id kr4so2778850pjb.2;
        Thu, 30 Jul 2020 09:46:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=pbokGMioFT0glVtsM0zLSYtv5hrIlpy36aUNCyDu4Js=;
        b=e17oSF8ZJgRBWC1ZmmPInRSNo+TqIkHXGV+xR80lhYv++2vMMjKAgbHA1CrfmfYKkj
         2TMlepI1mR7HzqktYjLuHiJ6bAu0dC9MQoyza9wZiK819+Tn68KYBI/NmyrgpjYDQq+H
         1EBY2AX2YyNh2DqbbkkETS6OnpXgc7fdeZ7lfyakf45HzhwtDzUcFJbXptrvwWQVYcXB
         q9+QhMkhnptksK7siAVwucIqs+JDl5h+E7ITqfYiW9kC0Dn7ugmc3Ot4G8q/ecKtRPDJ
         PZsAa3sCrq3zA3F9LGbNNef9ueqOWXoMpYq1QNSLlodd3LXB7b0pQnLVgEJFyBRvbdnJ
         /yxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=pbokGMioFT0glVtsM0zLSYtv5hrIlpy36aUNCyDu4Js=;
        b=UWxUudwXwV5A0qSqI9ekJxF320L6AB7dJ2BeQ1oUkbbagfw3XCnqRXHeY89kdtYxMZ
         xdDhfWK0EaD63t0zL0ZsG6PK0UKc0SXDm1UhIuuBSTjPFzRFQWUf7o5IPqElDGCSwfXA
         nlN3ciVIFTYncrXmzFasUj8jHI7uQE4tYRnuuC4XHNuxUC52bk6nxR2UfOjozrMhfEfj
         V7bGhr3GaLd095r7WWE3XuHGsYCRIw2HhgXYzznBtMEOzPGJqKXSYlkmMsxDzBz9J263
         C5qTURCUI4ISiW3zYDCnkqNwE29y3TXDWZWtoh83cM5Rme5Igv2GSHUINiQRyErw4/rY
         7Umw==
X-Gm-Message-State: AOAM5317/L8TrpExLsXUUF82dTH0a2gQzc7KhHhefStkdjGf9U3EDads
        lcT7olQiRcSXWkQSUhlvLXc=
X-Google-Smtp-Source: ABdhPJwkSjW1ndwBNLK2fr/GVIKM6lVTgotjIPj67Ag1+kt4y7iDnER5WYarTIkdu0sD2SUr7yhbLw==
X-Received: by 2002:a65:6710:: with SMTP id u16mr34979110pgf.45.1596127607862;
        Thu, 30 Jul 2020 09:46:47 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id a13sm7107080pfn.171.2020.07.30.09.46.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 30 Jul 2020 09:46:47 -0700 (PDT)
Date:   Thu, 30 Jul 2020 09:46:46 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.9 00/61] 4.9.232-rc1 review
Message-ID: <20200730164646.GB57647@roeck-us.net>
References: <20200730074420.811058810@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200730074420.811058810@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 30, 2020 at 10:04:18AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.232 release.
> There are 61 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 01 Aug 2020 07:44:05 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 171 pass: 171 fail: 0
Qemu test results:
	total: 386 pass: 386 fail: 0

Guenter
