Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 969AA5DB17
	for <lists+stable@lfdr.de>; Wed,  3 Jul 2019 03:43:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727124AbfGCBn4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 21:43:56 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:42473 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727069AbfGCBn4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Jul 2019 21:43:56 -0400
Received: by mail-oi1-f193.google.com with SMTP id s184so655165oie.9;
        Tue, 02 Jul 2019 18:43:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=x+wkNbuegwr6MAyGOrFjJgAp+Ha8Kd7476xycX8VtiU=;
        b=LTdGgq+VERB00MRK+dACf/0Kc4y9+SpmFD6GSkk5ceT3QZnzn3Q8GbTtiGggN0u0FK
         n11Re5m2hk+AAgvN6z7V+UdGbQYIrN5GLeDjpvkc0NuZDNBCgqsB2NkfPpEVN2sfmpHj
         jdNiGP1+gwb+2mi/OTxViaooIHaHq5RtgNnadWkxVWsMrRYbybEvCXkVm9e/6Hbi+LiL
         n3keELMXQUY1wdtJUfsBjCSlw4Rt5/crNwKfFhW479qtbFZ6tlGL9gbFydVKukb8rP4y
         kQomSMikxCHvmsjlX9Y5Ki725CGGKQ7o032HXHwpdVuDQjp0smo1MLuWEyDxR4x4r5rd
         nO1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=x+wkNbuegwr6MAyGOrFjJgAp+Ha8Kd7476xycX8VtiU=;
        b=EDkQr67Lf2RwsKd3wco42amcotmbxEA/2n62+wvqxmuQ66GPEYfFs+gIZqfATuUfoZ
         1ziRMcFZ6gh9B0n2Oei6um5rZsfFQ+v/IrUO/uQ1gwq6URTwpfk4IAyjPrJ/vobt87IW
         LN/VOxyJyU7TG2s8tGuIvWUGEGgIe4E01sncg9sJq42f/nkr0N9/XlOmHamCu6A9qXgn
         l/MORcqWUQDPYoPKQQZNr/SRfENz83lYvAlLuqztUXr1DLGaoxiTNgHJyA/B1fet13Xn
         Jf+xHH6QVbRC/DufkzW0Gc+rm+EtBxE3hTtwFMfeAoaUkRi2SpgNtIeRQ8DpgF7altIo
         8Tpg==
X-Gm-Message-State: APjAAAXImp83PK2RDcr53D4sk1emYhVvpvFQY/Kn+zg8cGhn+jUxRLvM
        a7mZhhkWgCQQajNUhWWil+rHGa5J
X-Google-Smtp-Source: APXvYqwKVXIWxj53hj8kKp5vlcBhx76gnHnMclUvqcx2kFQRomsOjgkIpZ4fihq5UX5nWnGqW8Ro2Q==
X-Received: by 2002:a63:d950:: with SMTP id e16mr34043340pgj.271.1562098961881;
        Tue, 02 Jul 2019 13:22:41 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 135sm15311473pfb.137.2019.07.02.13.22.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Jul 2019 13:22:40 -0700 (PDT)
Date:   Tue, 2 Jul 2019 13:22:39 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/43] 4.14.132-stable review
Message-ID: <20190702202239.GA29128@roeck-us.net>
References: <20190702080123.904399496@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190702080123.904399496@linuxfoundation.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 02, 2019 at 10:01:40AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.132 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu 04 Jul 2019 07:59:45 AM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 172 pass: 172 fail: 0
Qemu test results:
	total: 346 pass: 346 fail: 0

Guenter
