Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CE94107F1E
	for <lists+stable@lfdr.de>; Sat, 23 Nov 2019 16:46:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726760AbfKWPqg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Nov 2019 10:46:36 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:33530 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726705AbfKWPqg (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Nov 2019 10:46:36 -0500
Received: by mail-ot1-f66.google.com with SMTP id q23so3032514otn.0;
        Sat, 23 Nov 2019 07:46:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0ibVY5ijfSNAQqr6MkO+fpC/kqmnu7Rl35afJGb+3jg=;
        b=IfrNp9P0r4hArkY6s7pKgzY4orNwNim9YiAuSBa7BFEkLcUH49hoNEnEn8doVQUej8
         fup4ov2BSNu2/Wu8BPay5AVXz5SNqirA4dUIaDETOxilWTxxK3Nc7P0rnDhUH/ZAjo2B
         rKUPkmU+uqX4WanvY1vFfFeZldBDH1pO4BpHuy63d101d4hnGyyTbiqHWcXBOZBOaP7I
         pMc+hiKqgEO8fU9S878fILXuan/42U8MvXXPIkIYlKXvAJBeTNiVJw5sKtqBgiMh5PdX
         cCsXM7U5T451Y8PL+ljBmKmK1VBK3etOVJRoA5JZdwe6ZXG3EQXEiUtxS26md3BY6ZPO
         WxYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0ibVY5ijfSNAQqr6MkO+fpC/kqmnu7Rl35afJGb+3jg=;
        b=eqAkf9SxZShlj1MHRbdQ6VkqzFgffpo6lJSxJg32LqQF6lZb7rdRqh/eQqkEcfo2bB
         DoRc3xDlUONC4QkP6fKBa20JE6tGl3ziQ/oOwTWx5i2oaYFdrLCPeQD7xVL221Tzk6Wt
         CRhNmzyi3jbXPnRwXhSdtP8M3QopfGrJLQsvrnMteFhBXR0SV+JcfrG1m0T6ujHHOSqS
         1qYpZwkBDJTMLmkhrLiXIZdT4553IaAGiANvtYjuF9EUqLbUNlKijH8guhMPTrBam6Mm
         HkDYKDFD3mg0HDYv/j/9NtvBk12dk9R46vjPv1LGzqvjfyzU57zglUc81PGjQ4XI1A+R
         cWJw==
X-Gm-Message-State: APjAAAUAwd8pf+qsQXkizorLYOO2lp2L8BKKlDBuckr3wvgW2iW1bREN
        7JeIbDaq4kpvZwMnLgf9u1twVEZa
X-Google-Smtp-Source: APXvYqwqg8jdfUuN6xTtlenQnqojGc1uhvh7rPsvna4sqOkyZL/E3MIgzKVj0VltMqlLehccxm88bA==
X-Received: by 2002:a9d:27c6:: with SMTP id c64mr14343440otb.307.1574523993282;
        Sat, 23 Nov 2019 07:46:33 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id v8sm366959oto.52.2019.11.23.07.46.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 23 Nov 2019 07:46:31 -0800 (PST)
Subject: Re: [PATCH 4.4 000/159] 4.4.203-stable review
To:     Jon Hunter <jonathanh@nvidia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, linux-tegra <linux-tegra@vger.kernel.org>
References: <20191122100704.194776704@linuxfoundation.org>
 <f0f505ae-5113-1abd-d4f7-0c3535c83de4@nvidia.com>
 <20191122133931.GA2033651@kroah.com> <20191122134131.GA2050590@kroah.com>
 <20191122134627.GB2050590@kroah.com>
 <9f976044-2dbc-6c19-11e7-210cd7ab35ea@nvidia.com>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <a5d68f07-5f9a-2809-404d-bcd8ca593d70@roeck-us.net>
Date:   Sat, 23 Nov 2019 07:46:29 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <9f976044-2dbc-6c19-11e7-210cd7ab35ea@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/22/19 6:48 AM, Jon Hunter wrote:

[ ... ]

> Error: arch/arm/boot/dts/omap5-board-common.dtsi:636.1-6 Label or path dwc3 not found
> FATAL ERROR: Syntax error parsing input tree
> scripts/Makefile.lib:293: recipe for target 'arch/arm/boot/dts/omap5-igep0050.dtb' failed
> make[1]: *** [arch/arm/boot/dts/omap5-igep0050.dtb] Error 1
> arch/arm/Makefile:338: recipe for target 'dtbs' failed
> make: *** [dtbs] Error 2
> 
> 
> This is caused by the following commit ...
> 
> commit d0abc07b3d752cbe2a8d315f662c53c772caed0f
> Author: H. Nikolaus Schaller <hns@goldelico.com>
> Date:   Fri Sep 28 17:54:00 2018 +0200
> 
>      ARM: dts: omap5: enable OTG role for DWC3 controller
> 

On top of the breakage caused by this patch, I would also argue
that it is not a bug fix and should not have been included
in the first place.

The dwc3 label was added with commit 4c387984618fe ("ARM: dts: omap5:
Add l4 interconnect hierarchy and ti-sysc data"). Given the size of
that patch, I highly doubt that a backport to 4.4 would work.

Guenter
