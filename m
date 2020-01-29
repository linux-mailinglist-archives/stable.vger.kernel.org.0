Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 499A114CCB1
	for <lists+stable@lfdr.de>; Wed, 29 Jan 2020 15:43:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726498AbgA2OnV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jan 2020 09:43:21 -0500
Received: from mail-yb1-f195.google.com ([209.85.219.195]:42215 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726178AbgA2OnV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jan 2020 09:43:21 -0500
Received: by mail-yb1-f195.google.com with SMTP id z125so6667008ybf.9;
        Wed, 29 Jan 2020 06:43:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=8jILM82k/2kPoJaKURkx6UpCxtXKCMpJlFrBW4uAve8=;
        b=Lvv4lbGAtLCN2hXTatDdkTqLeJ8nQiFC8V+ue82hWwC+jMcbtJFm968BBrFD96Q+3R
         ueR7CLECLASdMEKiDHRu/JINGApAeZhPDVOkluY8NfcLWPfVjWNhGy14tDh+FJye5cnV
         iHAAKr2rpP1GWnJXm4WfY7wvuBHs1m1vYEcoMdXDq+lfCFxSz8wfiyzyIwXaEfmGKGz5
         vo8pzGmk4vLM3jPrueqBhJAftKBaq+mvh/AY0oCjDZUJuDljSbJc5K4m/xEBk+CumyGn
         18ETPMXMnRjpE3jdSgrAvdbTdVrHKzRJV72zvVs+H8M80sHijNrNV8AKT2iZGIlPCbKu
         Nqbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=8jILM82k/2kPoJaKURkx6UpCxtXKCMpJlFrBW4uAve8=;
        b=Vkx9p9mILCyCeTFzwxA7+/Pp2JlOVoR/q/D3KcVNYrUJrm9pp28YyUE2uDYsxQwtAA
         RDS9OAw+5/kqFNGZdwIuUEcoOrpcWfMoAJ6NHqG/hVQkhPS/38K+GSizHA5XEJZLzhzb
         xQ9VjmNqfIGgIPSutNn1rJi5QfzhkQhixID3NZkkUE7GF5c8m29U9gla2ae+mQBmI8gH
         /0XHKw9Tcithdd84KB1tKjsca7pRfSdf5cgXGRsiUVJ/MHIiACd8C72gPBSkYWYa7bvI
         69Sn5DSkYB63HSBbK6nzPZBL62mt82SOm+vPqU4exj2fwlPkQlmGWy+22IpgT8ZztemQ
         1qbg==
X-Gm-Message-State: APjAAAVJtuMFwlDXW6QQ/EB5nS5XwtjmQca+qYtCwjPe98a1Ww0GJudt
        y7nG3J7mjpI+De3kTN6jXBE=
X-Google-Smtp-Source: APXvYqz2f8ffVFfi2XsEGG6d1Fcpa3XLGmE32WJ1+j5n+ZcTDWLhp6IYAk6ZotJU6qmxMFKYVmt+nA==
X-Received: by 2002:a25:848c:: with SMTP id v12mr20074405ybk.288.1580309000013;
        Wed, 29 Jan 2020 06:43:20 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id p126sm1042578ywe.12.2020.01.29.06.43.18
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 29 Jan 2020 06:43:19 -0800 (PST)
Date:   Wed, 29 Jan 2020 06:43:17 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/92] 4.19.100-stable review
Message-ID: <20200129144317.GB23179@roeck-us.net>
References: <20200128135809.344954797@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200128135809.344954797@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 28, 2020 at 03:07:28PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.100 release.
> There are 92 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 30 Jan 2020 13:57:09 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 382 pass: 382 fail: 0

Guenter
