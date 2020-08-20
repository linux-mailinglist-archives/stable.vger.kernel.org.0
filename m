Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 878F724C682
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 22:03:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727033AbgHTUD5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 16:03:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726908AbgHTUD4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Aug 2020 16:03:56 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80972C061385;
        Thu, 20 Aug 2020 13:03:56 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id h2so1548350plr.0;
        Thu, 20 Aug 2020 13:03:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=/zUKCY9NcnrMbBU/yYjP9Qcii905DVQqeJu5M2py71I=;
        b=Zoi1v0OlWs6jOe7Xv+nmra/pbABp4EttY9wmxW5swk/Vz+F5VhVx4cuyN8LR/RnxQW
         Z46PA6SolXot+70YUrXrM0SMBvD1dKg510g3f6eO1K8dd1ipii5+6dSxI/lrBQoHTPRl
         DTyR+u85ATb5m+nW3AYMlB3rCBDp9pOdacS/zt8VsCIGY86EBtxEx0UwfJe9xcAeFXdU
         EerOkOrrfxIZMPw0J+XYZVKvWdJJL4RwY/nn/WUjjaXBqELCN+Qu5+z5VxIlOSZhsC+s
         XvWnsMk4rMMqaq8v9YMyFcC4QY7g5nJKINhBwmUOd6ypnvfygeEW2fwQ9vs3BoIsO113
         WKVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=/zUKCY9NcnrMbBU/yYjP9Qcii905DVQqeJu5M2py71I=;
        b=j09QGa9ZJpq18PmB68dGSVQuhl7zduJgWgATchIxzNRkUo7kHX6I2yTMNWQK1xsrIQ
         y/8sRJBjMp3OkAPI4e/ae+ElBjxAqrbJFrFdrxOq11uWyyvyIY2kK1X/H+mXCVwmBvau
         AW4vyXgrHEPIdXWedwARzuhfiY/Kw7PRm8lFhTpo/ZOX3tgc1j5QZK61jq+/HW9zVxEc
         ++I2EtH/i6ViuviWULb8Hu66Y60mrHDgqi4GpVLRsODLX/dz+FJnuCn3bAN1OmMkBAe2
         QFm1auCA6/Lg4A89D321Qdkj8krtI5J0x1ZOPAEfOsDF01puMBmJ4Hn5lFUqPXKCkFMJ
         B0+w==
X-Gm-Message-State: AOAM531Mquc1wsKDXdpy4IJACI4ZeTjYqSAdH3oLlmL0vZ+lQM+wsF1r
        PYyg7CXGvpQevQOzbqV0rliviLsXa3I=
X-Google-Smtp-Source: ABdhPJxGaenSTLjq4OGob5VVe+Yams71Igo7n4RDMGj/Q8u+P56oVBqy+K6yDVyrPon/OQ8+kQK5Vw==
X-Received: by 2002:a17:90a:d982:: with SMTP id d2mr265275pjv.68.1597953836160;
        Thu, 20 Aug 2020 13:03:56 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id h24sm3304637pgi.85.2020.08.20.13.03.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 20 Aug 2020 13:03:55 -0700 (PDT)
Date:   Thu, 20 Aug 2020 13:03:55 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/92] 4.19.141-rc1 review
Message-ID: <20200820200355.GD84616@roeck-us.net>
References: <20200820091537.490965042@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200820091537.490965042@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 20, 2020 at 11:20:45AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.141 release.
> There are 92 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 22 Aug 2020 09:15:09 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 421 pass: 421 fail: 0

Guenter
