Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 951D2F9874
	for <lists+stable@lfdr.de>; Tue, 12 Nov 2019 19:19:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727237AbfKLSTu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 13:19:50 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:45059 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727254AbfKLSTu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Nov 2019 13:19:50 -0500
Received: by mail-pf1-f194.google.com with SMTP id z4so13896053pfn.12;
        Tue, 12 Nov 2019 10:19:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=iVaQoUYJREFqWKkAcaiD2YffYfjbgMNwdQKfPsld7Ko=;
        b=lhRrgOFQCXa1mWRZTc8Af5nATg/DNZ0gMtp8HmP2ldOKnqmpK11UP/6mJzhdD/P6qz
         ZY/gpSV3oIA3sK+kY3aqXvKhomeZiQ63Y2wcIdYZm5mmf0L1LLwH8HY5VKkcCmGExDYz
         7gnLyLjJPt8vvn7TY86R+jqHKLyBighI3+v2J6mt3bSFjJB1FunUk+2K6S4BsY+uiQJN
         5ic7YWa5fmqFz85yo8BJdi5FsAs8Bg681Ie2dJFbO3bw54iJodlhaDjUWBx+fG7A87EP
         P0pt99oGf90uqN/wKx6Tb3jR8u3L0KRp/ek8UFuDwQx9o5FyGgnkysf2lJ9+0CwvWCmh
         J8TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=iVaQoUYJREFqWKkAcaiD2YffYfjbgMNwdQKfPsld7Ko=;
        b=nyW2jyx46oCTSKAvvzWZsM3Ybq+08T2ICbYMXg1fltHlOGpA41huLn7pwQUnR2IAcF
         AW7t8V+ui8/6vsor/sjM7limzZoPMW07XvZuUue9K+DyoZbXmSNEG7M9dvpt7G7wqyoN
         X2zgroS/R58YHwGD02NA9x8JVqWh9KuzULBD0nhyqBjeRayrhuu0Ijx8o2ilL5CILzq7
         Kbrknv8bUdWI1tyMEHHbG6edlmyGYMyRaJBddIxs/YShCu7o7NpiqBYQmY3hD24avc4K
         GXw/7izJ736uxSx7ZiW0bJhhY6L02ZRQ7QRU/j7SWiekdX6Yzn4VsJSxeUzvL8HTtopC
         h14w==
X-Gm-Message-State: APjAAAVL6XFk1f6qr46iZ4Qddnjf7wEnqqwtPWsg9Pr0UYEADTDX+ptv
        EXZECbMt1HzzdhYm5LQx71s=
X-Google-Smtp-Source: APXvYqymS9meHolAVICQl+3xJWvRJDxApdOLsSQYC21h/oY7qjxQTnph8sqtwSNCTHcelV12T9aE8Q==
X-Received: by 2002:a62:1d8d:: with SMTP id d135mr38479073pfd.172.1573582789876;
        Tue, 12 Nov 2019 10:19:49 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id n8sm3168076pja.30.2019.11.12.10.19.49
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 12 Nov 2019 10:19:49 -0800 (PST)
Date:   Tue, 12 Nov 2019 10:19:48 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.14 000/105] 4.14.154-stable review
Message-ID: <20191112181948.GD30127@roeck-us.net>
References: <20191111181421.390326245@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191111181421.390326245@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 11, 2019 at 07:27:30PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.154 release.
> There are 105 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 13 Nov 2019 18:08:44 +0000.
> Anything received after that time might be too late.
> 

For -rc2:

Build results:
	total: 172 pass: 172 fail: 0
Qemu test results:
	total: 372 pass: 372 fail: 0

Guenter
