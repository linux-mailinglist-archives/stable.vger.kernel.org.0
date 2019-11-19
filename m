Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 310BA102D9F
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 21:35:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726722AbfKSUfO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 15:35:14 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:36666 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726711AbfKSUfO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Nov 2019 15:35:14 -0500
Received: by mail-pg1-f194.google.com with SMTP id k13so11989725pgh.3;
        Tue, 19 Nov 2019 12:35:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=MyZ72sOU/GbkKSWNuwXWUC6lhoUtSg1j1vVFOaJBzTE=;
        b=Uez1BqfjpJKQVsS6R7WhaaXa/4LvtfVGk2RzPB23hzzZadNtv+CkFKk26IxLYHsEOV
         hZCqRaNExq/3y945o+ScorQEthwr1HNSpa993wzeQLuX1KO6Xq+ab6GY6Z45UXUzlBuM
         4mPIyq5Y7G3BZg0Tw/fjk3SO0IQvz0DkFGxp7NDLqWspJMe/kJy2yLEFaHAfRFD6zm5J
         CHQeu1AtpMPL6gHbSgE4c30WNLDgSywkUkicnONSjDq4BLEoC6qsxqLsOuhN5aIpzfHn
         0rIXoqN4Y52CrQ8A/g4A0IsrXoH/NFza49uivBbOyI5bgW4E5ZEMYxIzloa24hgqW1BF
         W25w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=MyZ72sOU/GbkKSWNuwXWUC6lhoUtSg1j1vVFOaJBzTE=;
        b=L+kGgBV1tY+JsxOo9ZoZwU/XqXJxJPWbwqyB18qPJYsMJZfOne6+6pxWUkjBxi+aG2
         0i0G+OmaCPOHucX3EK1eEVR88K9n7nV+7b5dh7DkzAWyXc1Lf5/87sa1LT2Z2qdPVn+0
         wsa2F1xX6yPXu+t1HVJrqhttF7B7CDn/JHT3HLmc7YB7gd2enLWSQ/rAIRjdONOAtSuH
         3B84PCmECcxEpFbaTs7onteSFYa56fTT9rbM9eAT9fFSSgan+Pq8YEcom1kvA1d0gdSt
         vMkx65VIJgpQkcntOilATBmm6Bald2AWbmR2llaRLKZCXkfmrPnMjGzRzd4zRhuEy8Wz
         3GNg==
X-Gm-Message-State: APjAAAU9lhSFcKZsmsIrQdzXLERdl/SsHIQRCiFsYAC+a9U5wKWf8wxB
        tZ2gr3Pr3YWbC3kcQyLqf+A=
X-Google-Smtp-Source: APXvYqy52MiiBfJJ6l1WUKshhm6AI5ASQ39aTb5ChrDCdXI5YRYboHifjOgqOrxnsq9LLCLetVnugw==
X-Received: by 2002:aa7:8207:: with SMTP id k7mr8337812pfi.130.1574195713523;
        Tue, 19 Nov 2019 12:35:13 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id c1sm4720669pjc.23.2019.11.19.12.35.12
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 19 Nov 2019 12:35:12 -0800 (PST)
Date:   Tue, 19 Nov 2019 12:35:12 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 000/422] 4.19.85-stable review
Message-ID: <20191119203511.GB14938@roeck-us.net>
References: <20191119051400.261610025@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 19, 2019 at 06:13:17AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.85 release.
> There are 422 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 21 Nov 2019 05:02:35 +0000.
> Anything received after that time might be too late.
> 

For v4.19.84-420-gd0112da1f7e6:

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 390 pass: 390 fail: 0

Guenter
