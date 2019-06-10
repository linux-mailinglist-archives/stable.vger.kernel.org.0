Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FBE93B79B
	for <lists+stable@lfdr.de>; Mon, 10 Jun 2019 16:41:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389986AbfFJOl6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jun 2019 10:41:58 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:42902 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389520AbfFJOl6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jun 2019 10:41:58 -0400
Received: by mail-pg1-f195.google.com with SMTP id l19so2558229pgh.9;
        Mon, 10 Jun 2019 07:41:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=DmT4zFpGCHDbT7b+onDMUFr36rh1QUjrpAzAJb5BvD0=;
        b=BBcOLWlaDSmuLtBu/XtIWhEHRba2lnPkt0UVeLUf0qCGUS59mm/TB83+8gn81b5OjW
         llo/dGqdqS4X7BqdNa90C1ub3o7kJGTDSJKfHXwOLBjFRH8kZW73d3xh3J6DP5avJcVf
         7uyhfLnPjEEBCb9kzbzrABMgbOvUVY6gkXw4l/UJwlmhJ4g0ZjSVz7VCoJG2Xau2Jrn6
         0/Gjq63xNsDhaCwxXu9BgB1bmyEw+ulWkIuzdlQd5Mi6f26Af5OxbTbTqOQDEB87+7TV
         rwPW9iLlTYAj7cPODV7IzdgYM2Acv0I/zYClyK1EkwdaCiKWfsr28Z8AWGxG+6bgceIj
         A9JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=DmT4zFpGCHDbT7b+onDMUFr36rh1QUjrpAzAJb5BvD0=;
        b=ph9t/CXLD8Cg771pcV8GrxY2QCKYCpJHXY2vTirz3uSuG+aR0Dz0OQQ4gJ1Nwe9n2E
         QtK+dmr3ho147b04PTeSsu/cII+V83gxJiO+HwcU40M+EuBteXb6SbqPNymQAoZeRHUU
         4osLBUvW2aPSOo6LTVdDFhHA5bGP2duQCI8S66jB7mViT+TWapawi0BWHwhl7VZaTX7K
         7+UK6yl6ZsbgHjNHKHp5nlpo8Sgmo+unQyoFGn97RbNye6B43mrba2wfzw5sBok8WciR
         iDmC8b6aHmYxq1sibaaiZFafKnVdfKdE795AQzKh/hD/0EDUrVX/vGg9KncxutLbqULk
         YqwA==
X-Gm-Message-State: APjAAAXBM1vx92lNwgu+QS54YuwpS9qmBGkbdS1jo9qn/xxW9fLW0hmF
        FRRZp6B4rVQRoyPDAQbGe34=
X-Google-Smtp-Source: APXvYqwaFictxZLmDZzyQefOGKQzLAUlcFI0pb+L0RyXCjJP12wwCYpagwabuXDFwb6tlRAvUsRuHA==
X-Received: by 2002:a17:90a:2247:: with SMTP id c65mr20913754pje.24.1560177717761;
        Mon, 10 Jun 2019 07:41:57 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id v190sm8981313pfv.75.2019.06.10.07.41.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 10 Jun 2019 07:41:56 -0700 (PDT)
Date:   Mon, 10 Jun 2019 07:41:55 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.4 000/241] 4.4.181-stable review
Message-ID: <20190610144155.GA7705@roeck-us.net>
References: <20190609164147.729157653@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190609164147.729157653@linuxfoundation.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jun 09, 2019 at 06:39:02PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.181 release.
> There are 241 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue 11 Jun 2019 04:39:53 PM UTC.
> Anything received after that time might be too late.
> 
Build results:
	total: 170 pass: 170 fail: 0
Qemu test results:
	total: 298 pass: 298 fail: 0

Guenter
