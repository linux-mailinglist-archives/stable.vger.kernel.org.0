Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 07A336D55F
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 21:48:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391754AbfGRTri (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jul 2019 15:47:38 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:42726 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391659AbfGRTri (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Jul 2019 15:47:38 -0400
Received: by mail-pl1-f195.google.com with SMTP id ay6so14402511plb.9;
        Thu, 18 Jul 2019 12:47:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=krzlGymBfNQVsh3pMqLr3oARPpMOHBPeT86nOpKf9+Y=;
        b=Ftglu6wLu1BQme9z46YuDvVeUQgz1r3YSYkwL4qbl4gky1MB5LmwIcEVh0NQvVSx5v
         WFYMkQsNYuTVoi0nhv7eV0vuzLr9ZzVfh/SJt+Y6SmXHWK0BE1VX2hsVYu8LFLLqjGd9
         uaYCL5Nca9Z0WpyR4k7UwFMdI3WW3j/LhyQeYO2OmGLInrpy3Tp2LALS9UgkMLYrbpOq
         B0rVCZhVsvDCqgXPWNuIGVRWOQvEBQKZ2L6yvV3SiQiWUonKTlAH4t55FoOiWSnwWTuT
         Jl01iN7o8Eah2kNMc0vMmnUR/Us0u9eYSHTUKqj5VC3Q0muRr8uSnq/iSiU1N0wUUNRL
         qpuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=krzlGymBfNQVsh3pMqLr3oARPpMOHBPeT86nOpKf9+Y=;
        b=G95FsXLI3260TOM68Z2exPT3dQHm6bqVy0KTqECc9YVsz0lXvk8ZUzCbK7j/f3aNf/
         HauUdwTaYW0x79dgsRxqVIgmA6dwIzdkS0XQL7AeDEUnUmlRgMSxgYvuz+Gfv+e5NSIx
         MCxgGax/jeAphZ4DxZIycXjJ+pmoEHWETMVynwvIg8tc66edF4mT0yew1DCC4vYzSxNI
         mriqsb4uBp4MNFuPuUUfONDMDzfU+LnFWWRfKSDV2dcEkj2f3rmHE94GGnc/UwQ4PSCg
         33CpY6HCRMebNKPU5p/co1fk7XebQ0QavvUcws5+Ddolgtc+Oc7nR1a8KNqpacC7MXNf
         u00g==
X-Gm-Message-State: APjAAAXDOdEfGQ2gTR6jd/TYQS03BqdcsTng0wl5SQXV8P3hIXoZ4n+k
        ZVyLf/isCrIdXgSmIpRUHTI=
X-Google-Smtp-Source: APXvYqxxQVqaIuhJGwwRVIf3+Fj9Ul+FBKGlV4Qa/wJPiKnLK4A0Npi/Ho+GlEnZpMcSz/U0RfOXow==
X-Received: by 2002:a17:902:b20d:: with SMTP id t13mr49532995plr.229.1563479257406;
        Thu, 18 Jul 2019 12:47:37 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id s7sm24397359pjn.28.2019.07.18.12.47.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Jul 2019 12:47:36 -0700 (PDT)
Date:   Thu, 18 Jul 2019 12:47:35 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.9 00/54] 4.9.186-stable review
Message-ID: <20190718194735.GB24320@roeck-us.net>
References: <20190718030048.392549994@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190718030048.392549994@linuxfoundation.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 18, 2019 at 12:01:30PM +0900, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.186 release.
> There are 54 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat 20 Jul 2019 02:59:27 AM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 172 pass: 172 fail: 0
Qemu test results:
	total: 333 pass: 333 fail: 0

Guenter
