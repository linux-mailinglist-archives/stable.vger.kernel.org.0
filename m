Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ED1730E434
	for <lists+stable@lfdr.de>; Wed,  3 Feb 2021 21:50:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231642AbhBCUmx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Feb 2021 15:42:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231367AbhBCUmw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Feb 2021 15:42:52 -0500
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F6D1C0613D6;
        Wed,  3 Feb 2021 12:42:12 -0800 (PST)
Received: by mail-oi1-x22d.google.com with SMTP id k25so1258963oik.13;
        Wed, 03 Feb 2021 12:42:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=0hq/XOxawxrkvCWXbLlqMYNEZXgnCn4T9t83XrJuetY=;
        b=shDchGnBA4RtoKS9G27DcnNWJ6yI9G1rtwt6sw9pu4CHJWX3szy7cNkYz0ukgcZrWz
         8L+ji8eeePa2/NFTwW+5yC34ocBjjpQRPVHmPD2HUEBg9ZL32lzqPyQTo5NQNP4B1lHq
         K5QmO6OngRiyW6iGflcM/U09GilVPbND0huiRbSrq71zHR5MzM5ULT56gQfNnn0FoDVk
         sxq7b5R495Lion0OgoP+V4W79lTeZnDk/r1o/YwFKlSu2r5Wz57xUGZcm5Q4V09zQOcG
         uNwcXaWcYdAkBInc8I+CbQC32d5q9myKnFe22B7m7cJY/xFQprF8A1o+iO6levNBgDzp
         UGZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=0hq/XOxawxrkvCWXbLlqMYNEZXgnCn4T9t83XrJuetY=;
        b=TjIOVcWHSt5sC8I/gdmPyugN8RSFWejeo2+by+BEcvFk4/Ro3XwfUzfLKqspccFov1
         7hI6XO19trtJyWmPEbvYOnLHOnKNYF9LdFBZ9LGIBmJUQPJJ9TrCq1Ds1/yGiAKo/v4P
         tCovvaz3Ns2iomYiYkOFyUMpTEzW/YUvyaXki8BJPVndrZg3KCWaz4dLyOHFUsi5V/f6
         bsvP4pobbkHJpFVcSa76yx0LL+zuosrQaR+hfKqOMYa1qi8Q29lQKhpbtGg9znYHIK/V
         W5yEvbeMoGbRwRrdrHnpa06ktIGsrMr8bIYW3eMUaiRPmzgJN2n8LsFO2W/AYxYE5YC8
         Pyeg==
X-Gm-Message-State: AOAM533T77QmiRshcDueNGSwJ/36UAOehXIdc6h/NUtnXuiR0oQR8P40
        802qAkQ/d6Ik9FX2+gOo4jw=
X-Google-Smtp-Source: ABdhPJwY+5isWdBPbT94qBSjJvqpTkOk38O8Eoj6q8kcnMJoFG9oB6xQYoRn3SNcfdx9HDEF3O8N8Q==
X-Received: by 2002:a54:4706:: with SMTP id k6mr3167738oik.56.1612384931771;
        Wed, 03 Feb 2021 12:42:11 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id n28sm640786otr.70.2021.02.03.12.42.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 03 Feb 2021 12:42:11 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 3 Feb 2021 12:42:09 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/37] 4.19.173-rc1 review
Message-ID: <20210203204209.GD106766@roeck-us.net>
References: <20210202132942.915040339@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210202132942.915040339@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 02, 2021 at 02:38:43PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.173 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 04 Feb 2021 13:29:33 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 418 pass: 418 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
