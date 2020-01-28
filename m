Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84C3A14C1B5
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 21:42:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726384AbgA1UmY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 15:42:24 -0500
Received: from mail-yb1-f196.google.com ([209.85.219.196]:46789 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726266AbgA1UmY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jan 2020 15:42:24 -0500
Received: by mail-yb1-f196.google.com with SMTP id p129so7479199ybc.13;
        Tue, 28 Jan 2020 12:42:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=kqvzjYDCXsxxFfdFIeH5IDpAGyInZFDyIeFEWkopzLM=;
        b=Oy2FIEWp6QBomj9Uzc0gWxsCjTVYAfrZUGa2Dfg3jfdC99lcMJPK8Nv2adN8gDoA+V
         x3Ki+VSYHXvPBTYWQdPsqR4w+GXysOcInFHtiiakicF6E3Tpchc8RunVbqzFl4j0H5/X
         1Hrp7eR6PjWiwAsCIA6SuvOmqvvtF+6JlEtojgNdeXmKv2o/jvJPcVv3T3BLYM3JBQZO
         QkY96Ll5lHwdos/dSKx+WGz1eo1fKggUFbDRCpIYM2WTMdYH1qBdtBACIcWO3gyICw5E
         3minmPOV5DrYSbFurPx8KfGber5y2j07QfNrGl50sFQGaGj37lFBlMqoNj4yPHb3/5jS
         86TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=kqvzjYDCXsxxFfdFIeH5IDpAGyInZFDyIeFEWkopzLM=;
        b=JCLQMC4SBfRooQYyklMPAfhL2zgGHKlKN3bSSK11Wy8bGwfQnKjW6kN6c4UHpKyWtp
         31J3BenHl0XpGiLz9CUAwU7rVQiWcsTEGj+tcAn873n010JsneRrCJtyaGnBGSBw+Q8r
         yWAS3CE/9Nf8GT/tiz33RfCkJUSr9p5eiJ3eoOO0+T04xu+eshHc7ihEDqlBEhy1ajND
         bUhlSnn7ZyeJtFmMrt3CGXKMtV60MnANf2jVE6JMfbF5yd1izh+cLo3rqd59xTTjg+Ii
         ZUr0cnDCvkls5NCcB0HyQq0LOF5v7mvmILM15PIIbcQjwDKkTwadB4/9xwv4O18aYrxD
         43Mg==
X-Gm-Message-State: APjAAAWYWZ1TCy0uzpy3JDbirUq9CuZQuzjRjumZzEIXEsYvuJbu0ixk
        yZQdJxv48o9H40zRk1CDpRc=
X-Google-Smtp-Source: APXvYqycw2V9QsxgD7fCADKVQ6JS5bzUrLeqEB1i6Kti+l+AQxvTHmGcfSJgFn5u2PaETJ44f8+k4Q==
X-Received: by 2002:a25:ca04:: with SMTP id a4mr18004653ybg.295.1580244143439;
        Tue, 28 Jan 2020 12:42:23 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id y17sm8660311ywd.23.2020.01.28.12.42.22
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 28 Jan 2020 12:42:22 -0800 (PST)
Date:   Tue, 28 Jan 2020 12:42:21 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.9 000/271] 4.9.212-stable review
Message-ID: <20200128204221.GB16941@roeck-us.net>
References: <20200128135852.449088278@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200128135852.449088278@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 28, 2020 at 03:02:29PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.212 release.
> There are 271 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 30 Jan 2020 13:57:09 +0000.
> Anything received after that time might be too late.
> 

For v4.9.211-272-g91ff8226a074:

Build results:
	total: 172 pass: 172 fail: 0
Qemu test results:
	total: 357 pass: 357 fail: 0

Guenter
