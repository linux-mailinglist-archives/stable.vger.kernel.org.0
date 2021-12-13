Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6B71473554
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 20:55:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242555AbhLMTzF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 14:55:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236471AbhLMTzE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 14:55:04 -0500
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76696C061574;
        Mon, 13 Dec 2021 11:55:04 -0800 (PST)
Received: by mail-oi1-x232.google.com with SMTP id 7so24564136oip.12;
        Mon, 13 Dec 2021 11:55:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=oS945DCBfPxm++Q2/d4Q8gvalqYm0ZeuYmXgOdqLEW0=;
        b=IERRpzLfAX6M522QsRG/Al8M2etww7n/qPbY9Dv9iY4yL+69u6Zwpi5Eud1wnHDBR1
         OTHrzw2jS9e1TrT705HuFDMimF7crwmTHreqc7YZwry9s6LmHLwTP/JLqbyK8n/xkmT0
         EzjyeWWxEoh81rHA4dAL9X7wZsLzaRYQSHUQ9k9jVzCljmlged3NrSnXxQOAhWILfhgc
         bQ7iw7d6fItgE7wiDDvpVFiyribV+1DB3xU+GdfIaAx0OD5EuPjCvDuiRt8hQFugkN9t
         bLWgRTsBO+u8ir1NJS3Pbd/rCivj6MMVhdfiLUT9teQ+cLNZKqnSFXUkG0pn++6tbDgk
         UGfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=oS945DCBfPxm++Q2/d4Q8gvalqYm0ZeuYmXgOdqLEW0=;
        b=asekDS+mODqf+wrJLaJFJTzQGOmtKXUr2KkBE9pN2Rdd4ftzmY3oT8y7tRqK68Rka8
         gJoJ1v1VnujQwIxjxvkmFmsCu0+gOPfLzYzLvfEWtsSV9HSt+dXEvPOUxJ323MToHWiv
         nwHwRBTRRjPjjPl7AnRh1QacaCe2aH2ifZ5kvA0vko/b1Y3HnSO3ppG9fW1ckpxH/MuK
         FCZKNwtpOTPu9QCoqb+MWTpK1wLirCeO2BTYhYp7K+lqGQWwVDvqqu2GocqZihhEg4WT
         JqnET44gzlKRGAAHEgeojQ+CVqicYh6YxR3ArGaV47t25d2uOisjAgOYLZ9lG345Uvnd
         YKhA==
X-Gm-Message-State: AOAM531qwL6+sRmhWIW4FNdiGyVNKRA9Bem4Xz+2FLjyM/lqhxiYB8qU
        Cz28+kUe6Sr3LyPJHPGoN9S48ZTDIyA=
X-Google-Smtp-Source: ABdhPJwtEWI/e2yPWFugpz2eALa45twCV/hyj3m9Ohs5DJCHDDvwcQBjV4h+3xwCJJMNNu3cho2rhA==
X-Received: by 2002:a05:6808:2186:: with SMTP id be6mr30052963oib.115.1639425303899;
        Mon, 13 Dec 2021 11:55:03 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id h26sm2243109oor.17.2021.12.13.11.55.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Dec 2021 11:55:03 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 13 Dec 2021 11:55:02 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/53] 4.14.258-rc1 review
Message-ID: <20211213195502.GC2950232@roeck-us.net>
References: <20211213092928.349556070@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211213092928.349556070@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 13, 2021 at 10:29:39AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.258 release.
> There are 53 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Dec 2021 09:29:16 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 421 pass: 421 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
