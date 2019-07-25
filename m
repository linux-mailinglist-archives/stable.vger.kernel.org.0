Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2AB575AB2
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 00:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726847AbfGYWTC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 18:19:02 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:38204 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726757AbfGYWTB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Jul 2019 18:19:01 -0400
Received: by mail-pg1-f196.google.com with SMTP id f5so14890116pgu.5;
        Thu, 25 Jul 2019 15:19:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=+wQa5fLhOl8wnCVHYW83kZDULRwf5iT88UNwiIbICr4=;
        b=OgN0KMqMt0z9md93d6ScBjRyrYybTlKgQG++WP118jaOk3dZHH23jjlN+Oa9oKHDzV
         OBGuKLmaPsxEMOq86zSX4TWISokoHI1DSg5Y+jMNNOZdktf5WciR+91MCKBAcJ5UQapD
         dj7FR8JPf5UOi8W4vHh4Cw2uuFr/Pht3V6bmo/hc+mKLwnBzlmcnK9bljXeLORfPZhZd
         AXES4EVs7pmH0qBFVv1yAmDKdHzyMVHAsRvqOMwKtKrGQU4HXfsZCxX6J5K6WgWvfcz4
         nJkLgbfR6Sg6jAqWVj1ngScFxTRxbwhD6YCh4nCLujJcwxANbp6U5lqUy9+FR98QuH5z
         oioQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=+wQa5fLhOl8wnCVHYW83kZDULRwf5iT88UNwiIbICr4=;
        b=hV6Q3aGwZT+/rmrrNMZdxIWbW3uW+6OFTWyzbutGplMYCRfEWsquSnOdFqVVHeI/Ml
         p05C/xNh9KsVPS7YOCRdm1TqpaUFsBTf5prx3dBupuWqVvwNqwvQUFZ7SUqWBzmDrDMl
         SzciyYueSp2jeIGvUp49Qyw3p7+KAoHeA23lMgSdx4TmNLrZTqPI7UvvwnsjoYRCJTQl
         O0uw7z4206aJ+ZQ5zxqOuC5Q3Z1i8YITyt1NvoB0nW7mLDCckddpCGIvSDPfsD1xPr01
         0TxHhmPol3CaIHMOhQf/5ugoV4Ztal6QMIvtwBEONIMX3cKTwKgTSR3OyJQ9eYF76KWs
         uTSQ==
X-Gm-Message-State: APjAAAWfUeBPm7/l1cP4KGfJl2sK8Hu99UDp37C8wpdbdKaPhQqqCnhc
        rzzru+sE/z9CcOlDA8Z34YM=
X-Google-Smtp-Source: APXvYqznsrBakBi4F82lF4e+Jg00DDvrmT+k9b+BcBBn7Isxj72GXeVusEHD/J0rN5W/nlmZtfnx1w==
X-Received: by 2002:a65:4b8b:: with SMTP id t11mr87905731pgq.130.1564093141437;
        Thu, 25 Jul 2019 15:19:01 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id v18sm46030226pgl.87.2019.07.25.15.19.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 25 Jul 2019 15:19:00 -0700 (PDT)
Date:   Thu, 25 Jul 2019 15:19:00 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.1 000/371] 5.1.20-stable review
Message-ID: <20190725221859.GA31733@roeck-us.net>
References: <20190724191724.382593077@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190724191724.382593077@linuxfoundation.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 24, 2019 at 09:15:52PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.1.20 release.
> There are 371 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri 26 Jul 2019 07:13:35 PM UTC.
> Anything received after that time might be too late.
> 

For v5.1.19-370-gfb6ea525ffcf:

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 364 pass: 364 fail: 0

Guenter
