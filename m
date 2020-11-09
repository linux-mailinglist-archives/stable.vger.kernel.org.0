Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86D942AC90C
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 00:08:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730005AbgKIXH7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 18:07:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729452AbgKIXH7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Nov 2020 18:07:59 -0500
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CA46C0613CF;
        Mon,  9 Nov 2020 15:07:58 -0800 (PST)
Received: by mail-ot1-x343.google.com with SMTP id n11so10700239ota.2;
        Mon, 09 Nov 2020 15:07:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=GiVLGJUBf06VkEVGDUKx2JBFPhPEliJw1SxUpU6vYlE=;
        b=qWJjCrr5J6lEFjegZWKoHPacIKMjmEri48OIblEsIwauRupnENgusA9wK3S4FtYFnK
         ieYFRDvBbCFS1RwAo5FIDSjIUZ+7FUWVlWfcmVJ4ONkPNmW1izHPlpiQBVuZOsQ1dCs2
         Ox4w0jJeJeh2boXdLaQBU+SOeCMbBlxzyCqwC+J5mrAbMJbaFlW3C0KNyXiAhX+ilLvk
         jrfqbhESJRkYpBtKU84SSL/Nfpo/5c55sMzN09YtpnTWq9F/FHTDp5lu84S2M9VPkMQD
         XzglU1TTpFgriZ7GjNbe3vD56D4nrv0tBvsqIO9fmgriYEq+Fc377sBBLqCmL6eRvOYD
         iTJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=GiVLGJUBf06VkEVGDUKx2JBFPhPEliJw1SxUpU6vYlE=;
        b=ERgFuMwpP4tWSnys2+4HdyWthI7LrClRzy8upiUwZnl1sIzhOG88yXFpaZ3xOVs9JY
         ubGQxQUcpWctnZp1xp6vjZd7tH8gEOx3tY5isGTHIJqBdq12GztZOaGAl8Vr5sFl964M
         Y/1G5yjC95Un+MBFy+Kk3j/WWYfl6NlU3YNYJvh+8XQymqd1uOooySa9khOa15i+ZwCx
         KfgwosTbCEGSLsZXaoLCMh2zZgtpCeWBOoGGij6fhCYl4sDBYJ+cWHhSNGwOBRjkfTeu
         CCfWyE9F6t9b/8rzF04Dm1byYVaSmqpwX8pUwQ9aGe9h4JpOM9q6y1ghdSVCSzxlSWcD
         62iw==
X-Gm-Message-State: AOAM5334gJyE7rDdyYzaYigLGc81SLph9gN0D2egvLiJADOnAfI5K+po
        9SbdNbIhcnZZKLwjOo3Somo=
X-Google-Smtp-Source: ABdhPJx8ESi4LlfV0Db8cULKM2p6gZfTcQYogn86icrI5/3AACCvJM4R6DZF9NC+7f1Q72rqjF/dMw==
X-Received: by 2002:a9d:4b81:: with SMTP id k1mr9141443otf.371.1604963277573;
        Mon, 09 Nov 2020 15:07:57 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id p17sm2738571oov.1.2020.11.09.15.07.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 09 Nov 2020 15:07:57 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 9 Nov 2020 15:07:56 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/71] 4.19.156-rc1 review
Message-ID: <20201109230756.GA92971@roeck-us.net>
References: <20201109125019.906191744@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201109125019.906191744@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 09, 2020 at 01:54:54PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.156 release.
> There are 71 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 11 Nov 2020 12:50:04 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 417 pass: 417 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
