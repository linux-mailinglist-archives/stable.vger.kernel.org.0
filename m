Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6F3F15E34B
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 17:29:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387937AbgBNQ2u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:28:50 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:50526 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393337AbgBNQ1r (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Feb 2020 11:27:47 -0500
Received: by mail-pj1-f67.google.com with SMTP id r67so4084825pjb.0;
        Fri, 14 Feb 2020 08:27:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=nAhSvO3+VVyEJsVC6AzlFZt2C+N0Z9D928qmp9v5sFQ=;
        b=W6sGnpI5sAakmIaTlpekD2eX0YdmSd2RJBUtZFK2Ag01smkqXLjg8iUHKUJHbSJrt8
         pLdcBzHoaer7Uysk+Fbe9/3veHqru5mKYcVMmM5M/DO2aHlVRnu2kEnv3cNfFcH/Ao09
         pKqC8fzo7VVIouqGAQ0KJHx/8MH4qGywkgjOfp3w93cZuxgEvdDqoigJUazgnzRJP/r6
         by+CNVNbcO+uzVHvjgaZ5R8ieNAtK9p1mhFvb/IwnGc1TJiHMfeXFz0JsmGs/r1CKaiG
         6f7/xfiuZkQt9fgA9S2VvFwTac6ux0iX27TM1x00Z7E5NvKqbwqIryHxAp46GxRnLj5V
         sQpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=nAhSvO3+VVyEJsVC6AzlFZt2C+N0Z9D928qmp9v5sFQ=;
        b=BKNcrFd/xiRmWb0jUrGhtbkFU87u6YxD/AnpOrzBv9djxvgeu3/HtBigy2e03nGoSx
         +UnOJ4NGJ6RZGIM46JNZJx/V/YeJ48mFASrR1P5xANK5xTcAUqXf0JjI0QT/h4UFFELq
         vxoIgVGCgE/RGsSK/mNcBbma28w8+njrSQVECbEH14tJODD6Ht5mA7Ap/2fBFWx1y+TR
         2QI6d53ZBT+7cNCzpIivZW7YH+YECtlYSZ3Xj8mt66Awde7pVA5rVazdmwn5dvvgsOrr
         qrGyHPJi7Zq7AmK9xcWB2Q9lVAzAgmwJOZ+gxsSDiz+bQSePL54qY44etV07JGLHsG9D
         4FOw==
X-Gm-Message-State: APjAAAVxBV8P8DdVuzgI4GYR9dZ9I5m3ATzslVOjs7O36snX2a2ppnu+
        mgVxfQZv8ONBxm/UwLuvubg=
X-Google-Smtp-Source: APXvYqwVg54dZ3LnsOfmyDzL0iApl+dGU3iBAiBOSlRupksulxeTSCl0Lh6gDiCUKcwGA4uPc51ytQ==
X-Received: by 2002:a17:902:7b89:: with SMTP id w9mr4238105pll.46.1581697667074;
        Fri, 14 Feb 2020 08:27:47 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id e18sm4371462pfm.24.2020.02.14.08.27.46
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 14 Feb 2020 08:27:46 -0800 (PST)
Date:   Fri, 14 Feb 2020 08:27:45 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/96] 5.4.20-stable review
Message-ID: <20200214162745.GC18488@roeck-us.net>
References: <20200213151839.156309910@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200213151839.156309910@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 13, 2020 at 07:20:07AM -0800, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.20 release.
> There are 96 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 15 Feb 2020 15:16:40 +0000.
> Anything received after that time might be too late.
> 

For v5.4.19-97-gb06b66d0f2c4:

Build results:
	total: 158 pass: 158 fail: 0
Qemu test results:
	total: 399 pass: 399 fail: 0

Guenter
