Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F52A151F27
	for <lists+stable@lfdr.de>; Tue,  4 Feb 2020 18:18:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727484AbgBDRSm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Feb 2020 12:18:42 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:34485 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727440AbgBDRSm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Feb 2020 12:18:42 -0500
Received: by mail-pg1-f196.google.com with SMTP id j4so9987436pgi.1;
        Tue, 04 Feb 2020 09:18:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=hDU430EQXEmT5g+lonqv0TqwpGzvrzCEDnANBtw/LOA=;
        b=AjxlkirO1SnFUQ+ca7unI4lRYrY6IquPWCfi8jU95IUYhnMkxQkRDzOxW9sXbch321
         vZXQ1y0f2qjIb3orwkqdF/kb8RPM4DeAaZUCar8iyy8YPHMSmTqAXZ52Jf9pE+odoDFC
         eX4stRVrTgdv5FH+4xBelXPOjFbJ1mqNIbBEnkyfIHkTEsK2Q2ONkyjV+tlSAsL2TMOG
         cAwfFEkZQAfuxl18mua4KDoYTfCKbDqed5wrcRkoXxXy7y2GX6dagVhEMV4blKnru9b0
         FFKcozo9HwcVBBVlpIuYwGYzj/FIFKEd1EgfZjYiJBzgsOUAT8TlgBrT1rhV9FUwWkEf
         g24w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=hDU430EQXEmT5g+lonqv0TqwpGzvrzCEDnANBtw/LOA=;
        b=DTfb0j8JH8rFntKyNkOYMMGL/IDkNbmtasOsjHP0xdoBhtOsiNWSJZi5G/DamB8+KK
         s4q9zv8ZotVkF+lxGQ4jkVXNTE/x6IECs9qcJVD9HqNVPa0bStZNkr5FOSoJq/5+HLQ6
         vCayn2ncNynW1Cah4taUJx5T9VdIL2+jWh2aLr7WkFjxzxDxH9XKnExB3OjbCqhn4yry
         +DTaWY1lpI2u31KrkJSGiW5CMrBu706WMvbgf2aTGNRwjW7eilC6yzkQJfxnRIFml5QQ
         CCfQyuemiBEmnnsswZqc0kMn4eXMqhNyAssiFEytCV1qTv2TBdj/iG4DjGKZuaA0lODJ
         7bng==
X-Gm-Message-State: APjAAAUMgqPi8ZYHRRP8LvQSS7WZ2qCxF2ge4jerQ97Tj3GgQVzdW6yR
        pwsmRFzQ/iNMj46rfmZ4IDeyWuGw
X-Google-Smtp-Source: APXvYqy3xdhG1cvifYDRp2/YdWyx343KEoihp5hj2YwfsRTf/u48knDi4bO4upVPARnhO432i/Kpyg==
X-Received: by 2002:a62:64d8:: with SMTP id y207mr31207209pfb.208.1580836721870;
        Tue, 04 Feb 2020 09:18:41 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id f13sm25391436pfk.64.2020.02.04.09.18.40
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 04 Feb 2020 09:18:40 -0800 (PST)
Date:   Tue, 4 Feb 2020 09:18:39 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.9 00/68] 4.9.213-stable review
Message-ID: <20200204171839.GB10163@roeck-us.net>
References: <20200203161904.705434837@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200203161904.705434837@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 03, 2020 at 04:18:56PM +0000, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.213 release.
> There are 68 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 05 Feb 2020 16:17:59 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 172 pass: 172 fail: 0
Qemu test results:
	total: 357 pass: 357 fail: 0

Guenter
