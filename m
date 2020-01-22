Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E835145C1E
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 19:59:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725933AbgAVS7S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 13:59:18 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:46736 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725884AbgAVS7S (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Jan 2020 13:59:18 -0500
Received: by mail-pf1-f193.google.com with SMTP id n9so255258pff.13;
        Wed, 22 Jan 2020 10:59:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=HQxdX8PTl7oCMbkeLII63nN9RNrnV/YOss11w33YIf8=;
        b=Mf4ceQIHyAGvwfiLFpIgmojwqAr6+OhF5VqI3zhC7ePPX8qWsjfsX/8DB9VSUyIpsb
         pEr3pceCXKipTg2XL5qTQ2vo2jO60bQitjAv8wwmooOxzJRi9cgvCUzRitbSLXNBGO+9
         /P/QZvI5SCgBUKdTp4y1QzI9XI+xFeAfJXyMM57Yc4Hmt2mMEehED0td6BeQ+YbGfc9S
         bD+qi68mp/4/N51HqQJC1fzgXGmNCLnxlEjlEPQdbIZ7L3NvITTyjy8X+3IIszGetPzb
         uY6jhepdQFrXSFd6Gb8yDUdJ4qXn3H9oZE0DROJlEjVeyffd+8PslEDsyvsI1b599Br+
         TrZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=HQxdX8PTl7oCMbkeLII63nN9RNrnV/YOss11w33YIf8=;
        b=pQBj01XZdsPm79phhTkYTeeVbQ5Clw8I7xtlqo2souB8rPyBFwkEG1JhTHFPmFyj+G
         xECY/wlxgVtIBJwl8X6GhEMlMPmA4R4zKNeLTAfnA8rELdqRABUM0uJYDfYvUwyQgbWh
         /JNPbJPNM5rNfp4Xd6U9t7N7F3ctIJ02hXSoNGjugSGV+VEUYZbhsOIw4Fs5Lg0+1WKw
         79L64B9dOq2+eatpqEo4qA/L9lrsfj6Z5Q83o/8e6LhWObEmZrt10DnA3pe0trCg5vEM
         PMczb81otVXzVGeemL9nm6o5KVt5IEkC1oPzqCq1USoH0nESmuv2h2Bj22ANZATs9Oap
         Q3hg==
X-Gm-Message-State: APjAAAVpXpR0Izm/UqhI4MaHyUK24ACtP3MXEd2tv8j2Bo7kRiMKNZv1
        dTcdVjBv8EqVXOCZUVvl0CE=
X-Google-Smtp-Source: APXvYqw6cm5OGqc+QD/QB6T5Q25CpnOFzxW545Nvuuzw+vPDYbWK+zakzkgPDkZZ03z+W/nHQ0CIug==
X-Received: by 2002:a63:d14:: with SMTP id c20mr52583pgl.77.1579719549617;
        Wed, 22 Jan 2020 10:59:09 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id x8sm48994926pfd.76.2020.01.22.10.59.07
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 22 Jan 2020 10:59:08 -0800 (PST)
Date:   Wed, 22 Jan 2020 10:59:07 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/76] 4.4.211-stable review
Message-ID: <20200122185907.GA20093@roeck-us.net>
References: <20200122092751.587775548@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200122092751.587775548@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 22, 2020 at 10:28:16AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.211 release.
> There are 76 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 24 Jan 2020 09:25:24 +0000.
> Anything received after that time might be too late.
> 
Build results:
	total: 170 pass: 170 fail: 0
Qemu test results:
	total: 326 pass: 326 fail: 0

Guenter
