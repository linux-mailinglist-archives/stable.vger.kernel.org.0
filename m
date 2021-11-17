Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61F17454EA3
	for <lists+stable@lfdr.de>; Wed, 17 Nov 2021 21:35:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232124AbhKQUiK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Nov 2021 15:38:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229899AbhKQUiF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Nov 2021 15:38:05 -0500
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27C79C061570;
        Wed, 17 Nov 2021 12:35:06 -0800 (PST)
Received: by mail-oi1-x22e.google.com with SMTP id m6so9110197oim.2;
        Wed, 17 Nov 2021 12:35:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=iw1Axgfzs7Mc2QH3w42nnClbTvGbEnTPu0EDCK85XYk=;
        b=a9Ej0ha0rswt5N5z9Pn+2amv6T41E0s5xzigPHHm/QwOLhlqQo0aUsYf/clg2F/FaF
         aEJi4tLY14D/NrEGgVlINojRQo0oKitsvdXF0roZucljrBJr+lEOPTBJwlV/kopWXdWN
         XkQComJ/TQvJQhLB99zbuvBgEZDBylLLqBSjM2NYMor6wmPB34e9oXyMtfjKnauPu2ow
         C64k8cBGihVU+sNne68LCWJdupinP1Tk8ho1l7drSOBW8K2AN3uwjuX1AF4SVfWON/HS
         CIcSfR9gHP+B7QGXLveM5jRqfSRgSyAzZvBA0MzIw981x1toXAZIQN0uQnBd52jYe8Vj
         +ptA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=iw1Axgfzs7Mc2QH3w42nnClbTvGbEnTPu0EDCK85XYk=;
        b=uYGweFkr/XViv8iP/mVQcHDfptlBdQw8GDjfT8GGMNz3MZSAcaHR0pXxp410z66Ay8
         7njq9bj/VTaRF/45EZ5jkZLzMlQ72oxBJ1awT+aC1VIM34efg00TGJHw+cH4WTCAlo8k
         3Os2qHHnsUpa91vPPmf5W7IISBJqbRg6RrHVg40fpPkQsMacfEdsY+K5tNPAsP8VdnVi
         z5yO4vYgt5t/XJIWDLxtlHFbaf8x943rkNscwq8KxBhL5FvlAIbqWsn2YWuEvrrpwKKj
         3XLMMDNZ1jfXhJdvsD0XfbATEnpMlTwuLTmVzMBuTzK6xYt/FXvWtclOlv91fpT7SUeN
         J/vA==
X-Gm-Message-State: AOAM531pmn8eMs+W9AIOEjc4SpVSG4O/B96fOKiHxjJj3uMfIgpQ0dqJ
        HGg0CLt+B0nWnsXFJQ6IT2g=
X-Google-Smtp-Source: ABdhPJy670YIXNuT6bSoEcPwfPrcIJujPsawIOie05VRjB6MimOHW6hsell7vTE5ksK8wYhCicGtNw==
X-Received: by 2002:aca:6105:: with SMTP id v5mr2665476oib.20.1637181305468;
        Wed, 17 Nov 2021 12:35:05 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id a13sm208223oiy.9.2021.11.17.12.35.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Nov 2021 12:35:04 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 17 Nov 2021 12:35:03 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/569] 5.10.80-rc4 review
Message-ID: <20211117203503.GA3128294@roeck-us.net>
References: <20211117144602.341592498@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211117144602.341592498@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 17, 2021 at 03:46:44PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.80 release.
> There are 569 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 19 Nov 2021 14:44:50 +0000.
> Anything received after that time might be too late.
> 

Not counting the new build warning reported separately:

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 474 pass: 474 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
