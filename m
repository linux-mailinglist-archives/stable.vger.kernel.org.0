Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 773179F184
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 19:25:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730417AbfH0RZU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 13:25:20 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:34657 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727064AbfH0RZU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Aug 2019 13:25:20 -0400
Received: by mail-pf1-f195.google.com with SMTP id b24so14573832pfp.1;
        Tue, 27 Aug 2019 10:25:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=+7xVpbEXRm4zEOfK9wsTexYHRKLb7L7Zox4RKQmxXXI=;
        b=MhbdVswskht71NoGqlVUUPBcyg9mzc6LxoTYDxBq4j/pEIHUZ37BzLZrzW7nPYzfP/
         HNG4Lk5kDeta2J9ayHPLNaipK2o3z33sLMCPQHcVfm4l2i07FCgGOmbKjIehOaDgwmkK
         ttsrXi/czilGepWQksLiuEvcALegsoblPrn7vm1hybpX4eXOMB5sw3uGsirf369s3zDp
         jJ70lYz+ewggBfIb6VX6G2hShzQAI+zgA9D/vUn0nw9z6r5tCiBV7IQwAw0Xba7JfrLn
         tpjDDyTK/YlWyLJi2HCKAVXtHQOEoZo6Ly25t7CkRU1txBxUU7OjBr7pXmexQRfzEKgC
         tIbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=+7xVpbEXRm4zEOfK9wsTexYHRKLb7L7Zox4RKQmxXXI=;
        b=SxFF4LL66DVsgP/eqfobpbI9tSoYgzqjGWhh+VkcMDHfXOyO9D9r4yYj/LEkH1hksJ
         hoSXSB0LCcYH9xmZOLKLNLP6KQLJUq93gkKJChwaJ+Rzq8zD7LqDsf+4p3CHadkUBlw6
         zu0brtrjhBkobQklvHfvN6e9g+4SFrw1QXgHUs7mTq5qSqchpo2ESjeZ4hOkAuqC/ZXY
         PBAWBR79hQ1iGh7urw+iXxurGXTeT8vbJbrQPFszCqMBOwEhRe2wHtQyTWTcmp8eWu2j
         VEa+6HDNNGb96yW6cyK/H2unB+g5krLWKDOEFAaxbQ+imD/L0jMxUP4OGRtxcJrCABOu
         lygQ==
X-Gm-Message-State: APjAAAX7NZG8x5NbbUSMp5dv0uqo1s9Y+LjP334+1do3pH/cHNPfNqBf
        Zue7AyCdph4Q0c5l3XR60fOATIgz
X-Google-Smtp-Source: APXvYqwh5rldAbTDVFIGKUmLSRE3bbKyYVwr+4x2qgKlhCcFQfXlj54NcoIChmiAPgE281LLYZuA5A==
X-Received: by 2002:a62:cd45:: with SMTP id o66mr11182796pfg.112.1566926719850;
        Tue, 27 Aug 2019 10:25:19 -0700 (PDT)
Received: from localhost (108-223-40-66.lightspeed.sntcca.sbcglobal.net. [108.223.40.66])
        by smtp.gmail.com with ESMTPSA id e13sm19251597pfl.130.2019.08.27.10.25.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Aug 2019 10:25:19 -0700 (PDT)
Date:   Tue, 27 Aug 2019 10:25:18 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/98] 4.19.69-stable review
Message-ID: <20190827172518.GC31588@roeck-us.net>
References: <20190827072718.142728620@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190827072718.142728620@linuxfoundation.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 27, 2019 at 09:49:39AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.69 release.
> There are 98 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu 29 Aug 2019 07:25:02 AM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 390 pass: 390 fail: 0

Guenter
