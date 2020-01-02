Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4320512F19A
	for <lists+stable@lfdr.de>; Fri,  3 Jan 2020 00:05:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725900AbgABXFU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 18:05:20 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:38644 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725890AbgABXFU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Jan 2020 18:05:20 -0500
Received: by mail-pf1-f193.google.com with SMTP id x185so22717752pfc.5;
        Thu, 02 Jan 2020 15:05:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ryxK0mpRSxESJVWZudLQb/s67AYldpkB0jSH1Eh1Afw=;
        b=aLeDg29p2KmC/fcmH39b5xWwftAl2vmN2tDI78IvgZ6okRJ5LBdipUUBwbatq4qlgJ
         1aNDo7E/8HYOiiwV6+iY3XlcZ4+tTrQPKH8kXppZaAs3ViSizlVTHQn32A7F8pYo+yxP
         7A9EUxHltGR3cLoMw0+gZWuVT8IuAQRyLXPVAI68sXpVdu+2Vu+mhE03ChwzjPXC7+na
         MEXkHYURiJrTFz6joKR56JNB71mt0ISgWE+/4JTflb7xdoPcHHxPz8HZlnkmsLBKhftm
         F7hlGnTQ90SgE6yzVUUsjaSHYcqHCccfHHNZH2Sc+18odqiYAX2nq3ilFvlob1N+JY8V
         W3/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=ryxK0mpRSxESJVWZudLQb/s67AYldpkB0jSH1Eh1Afw=;
        b=bPzJwnVa0lSw92x1NdO+RLDoesLU5auKqwh5/YB5XZmDJPZ/6tgRKIg6tTYx0Am73v
         LaRBdS4OOCZiK7YWpeTCRg5WrHRMOd6YJiioCst3sAsidY2cIHCAvGlJCYBL/fKWvdtZ
         N6kCN6eHEyX5z3G8Kh/1kVfLdAbXW524HkxkaUf7nEWHX5h6J7gsaURKTPFlXw29Msa0
         w2xF3CJR+dSQMNF4Ju1MJn2ZNvIyEZv2CxGDjdIsCLp60x48V3l+JiS08dBTUirgwwyy
         XbDc9nO1+eoLiLPADQLg2WbGUaoW0HvxepJfC6lSKqWXdyBwFtGpM6UiIyJPSvRbEG1i
         VoFw==
X-Gm-Message-State: APjAAAVL22iarJ8n2E78YyFhAWg308560eXQ05Rot9cSTbemJLmlm2bP
        OERM1h+yjhaDYIDOS8GgObM=
X-Google-Smtp-Source: APXvYqzRWoUbS3Y9gTmH/CRnK1CzA1PLL56ZbDydCwBi6vJWZQmBQydnOJ6BNg36lSEJWkP6r4NRZw==
X-Received: by 2002:aa7:968d:: with SMTP id f13mr88709714pfk.67.1578006319882;
        Thu, 02 Jan 2020 15:05:19 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id q15sm60886561pgi.55.2020.01.02.15.05.18
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 02 Jan 2020 15:05:19 -0800 (PST)
Date:   Thu, 2 Jan 2020 15:05:18 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/91] 4.14.162-stable review
Message-ID: <20200102230518.GA1087@roeck-us.net>
References: <20200102220356.856162165@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200102220356.856162165@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 02, 2020 at 11:06:42PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.162 release.
> There are 91 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 04 Jan 2020 22:01:54 +0000.
> Anything received after that time might be too late.
> 

drivers/pci/switch/switchtec.c: In function 'ioctl_event_summary':
drivers/pci/switch/switchtec.c:901:18: error: implicit declaration of function 'readq'; did you mean 'readl'?

The problem also affects v4.19.y. Seen with various 32-bit builds,
including i386:allmodconfig and arm:allmodconfig.

The backport replaces ioread64 with readq, which may not have been
such a good idea.

Guenter
