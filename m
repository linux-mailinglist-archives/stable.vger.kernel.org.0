Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21B3513304
	for <lists+stable@lfdr.de>; Fri,  3 May 2019 19:16:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726444AbfECRQM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 May 2019 13:16:12 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:32820 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728801AbfECRQM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 May 2019 13:16:12 -0400
Received: by mail-pl1-f195.google.com with SMTP id y3so3000961plp.0;
        Fri, 03 May 2019 10:16:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=afF0NRRFUMwO/vLjiy0/uazsTBMuTW4kHOqG29VIv80=;
        b=DQqXucbTAzwF8Wn8YJEUWjO/L2zt2jywBmu7zlPrD8pQMfRGfxlBy8kN4MybrY6C3t
         DXDzV59NyCZYWN0Hs7dxFBD/EYiPIdC2W1PEZtmpdyZ3fPpf8BHFijPPc8y8DogdejUr
         SAOllwKd4mcoGSUrk/5grslQpYbmTWfkURN0J4BICA7R6ZSE4xXAUYLRX6PTYZBwiZws
         VxGfoT1Ury8LORJCXQ9J7+jj5WtNd6RT7Gf2jrlNBCdfMwM+B0Id+lFhZVKyC7/uBeb4
         1NIzMeo6Z+2b5ElI+0ElQ9l/O+JCXQZo1t8H3nTKFC1Ihv66aI4q0QTO5BAAyFveSW+C
         3YqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=afF0NRRFUMwO/vLjiy0/uazsTBMuTW4kHOqG29VIv80=;
        b=VwJptKFsBvvNZmpbYivABNwReabXJ52NqqNZbEEVeInYupd36QpRk8kzkKf1ZdiOOz
         /XtXcpBSeUKbkN55XyQNmilm+d22CFXlcnZx8gKLRnKW2DzNFKN8ogjTGmnXEauAHL9P
         cUVCAkoAgqq1n3gG4L97xNYYGMUcYjahv8PuUh7y6iqwhMmfITJdUcYwDEdtG7s81DA9
         vCCTInFcNt9IKTaDnOSvnXyK7amDyewbBzo/aP8o2oXGPRwdNPa6wlneZZ10a5fbTrbv
         ltQ63B3BSpaDH8EohEDasVgv1fHo7EA5HlTBelDpgHam3kfzOwvJQY4K0OIet1ZOoQ8g
         RUaA==
X-Gm-Message-State: APjAAAX1nNS7VMlUTVyPJqcDJGGJmpT6ufL+hRvI1gAHaC8B++oiBUQl
        o3s43Bavl2hD86Rd+1FKfMTXjVz2
X-Google-Smtp-Source: APXvYqycfhVolMj0GcAbcjh0yPw1Y2a1iEte646IooXlqmGESa6/G6H9TykD7z63yoYjvxaY4Lrcyg==
X-Received: by 2002:a17:902:968c:: with SMTP id n12mr12027691plp.105.1556903771458;
        Fri, 03 May 2019 10:16:11 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id r138sm6820448pfr.2.2019.05.03.10.16.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 03 May 2019 10:16:10 -0700 (PDT)
Date:   Fri, 3 May 2019 10:16:09 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/72] 4.19.39-stable review
Message-ID: <20190503171609.GC2359@roeck-us.net>
References: <20190502143333.437607839@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190502143333.437607839@linuxfoundation.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 02, 2019 at 05:20:22PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.39 release.
> There are 72 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat 04 May 2019 02:32:17 PM UTC.
> Anything received after that time might be too late.
> 
Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 349 pass: 349 fail: 0

Guenter
