Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDADD3365E
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 19:17:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726862AbfFCRRb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 13:17:31 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:43094 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726717AbfFCRRa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jun 2019 13:17:30 -0400
Received: by mail-pf1-f194.google.com with SMTP id c6so10980595pfa.10;
        Mon, 03 Jun 2019 10:17:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ckQRX7jIGb4l/cxVq0XKTKehz2Xwu1/odSjdARib/ko=;
        b=s/ZG8ie+uxVPyt/Nusz8m9vVpRRtifco8q6bq/pOU3rqGKKk5aAUhNYKdjeQMl851Y
         FQfAE8c//QbkT/ewIspHIWkaBR1Ran2QDp/oDPummNHlF1EqGLrNeltiUS/xi0aQ8DNU
         dFbqQi957adhmG4VPUydGwETmgW2j9dnDgp2AUsEG2zhTpxF72f/G6PYbO0ZeiEkur2R
         1bxUR9aw/il6i55Ds7HVAkCZRML0tXlu9vRrH3MYpGzozZg5KZ+yVldjOwwlSy367hrg
         sHhmD7+8tTdFIvsZMOiOsRwrRmcNtvPaD0nqtwVLIxzONdBtEsiEfoAwC1sXob9rCanE
         vqMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=ckQRX7jIGb4l/cxVq0XKTKehz2Xwu1/odSjdARib/ko=;
        b=bwy0HhFJRcbgIF/N0J6jbVt9QdrXs1zFEPfj7ogH3E22VEogJvNoCaS8M9DqtozqTf
         +ra5KvBSEYG5Laxw0Kpjjx/Kth30Mzv45sC/QcFOrXbUWxFYFIbJa+i2SIO9uDsfYbQ6
         +4ecfYyoM5PPfgWJh52WP2QOTQuQpOiVNX1f2Bl0nO8waH+3ueV+pNPWVU6tlaUQiwdu
         tJiNHIZR0LZS2fMg4FjH2XnP+0R5KOcC+3M5C5EtG4ZcDkecQKOVxEZuW1SMFoKvImho
         hplQ18Lh799r9zcxx74KltlM6VchHlxZHRnmOHAu2ASIWlLQQxHE85A4/Tih6C5yjihO
         jhGw==
X-Gm-Message-State: APjAAAU5e60MsRuDsx+qbQXC0co/LjgIeDDtMs/dsXkZ/uWje00Qn0YP
        VOx+Zs7wT8qK/tw4+Zg06TE=
X-Google-Smtp-Source: APXvYqyGpqyu8yTa/NDeG/OjFE3MV52NyrkkAGdVdxWuNwtiEZ37W4Pmvk5A0ssfX4cgX/22NQUl1A==
X-Received: by 2002:a17:90a:a00b:: with SMTP id q11mr31661120pjp.108.1559582250204;
        Mon, 03 Jun 2019 10:17:30 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id c21sm1168759pfd.129.2019.06.03.10.17.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 03 Jun 2019 10:17:29 -0700 (PDT)
Date:   Mon, 3 Jun 2019 10:17:28 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.1 00/40] 5.1.7-stable review
Message-ID: <20190603171728.GC4704@roeck-us.net>
References: <20190603090522.617635820@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190603090522.617635820@linuxfoundation.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 03, 2019 at 11:08:53AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.1.7 release.
> There are 40 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 05 Jun 2019 09:04:46 AM UTC.
> Anything received after that time might be too late.
> 
Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 349 pass: 349 fail: 0

Guenter
