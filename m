Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B1A7835A4
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 17:49:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729275AbfHFPtg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 11:49:36 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:36684 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728189AbfHFPtg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Aug 2019 11:49:36 -0400
Received: by mail-pg1-f195.google.com with SMTP id l21so41805331pgm.3;
        Tue, 06 Aug 2019 08:49:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=eWZ+Zix3WY/IdhDeiDO6JTzS4nVuBKfS/clOEc00lJ0=;
        b=kqrwHhsQE+grtuqujjwuEDZV1SZG2D3irQdyW4fKud456yjg3YV4NxTFXAEmS+hCFR
         aQ2NRBBVVXfn4txSLPu6iAg/lhdFYIRnT9fKtG9EZ62d4ExYyhtA28ec99jGUr7EpZno
         qcd2FQBlSOFqFmH+G9maKS950kTQ8NJSCZwPQLru/LSx1n56clAL8UDO98n9Tm8xlbY+
         syQtzdDRCRtdjqIzOVvCm0KMG2oUOgQ5vbVIGkwWwPokMVqRVTcbQXpPnPOyieQNNrZx
         FxOmGWhpH7rWjst6kj51QFwIAT24i0FdtrtPdS+p/KLwXNuxNpJjJ5lN9EnRXaXFXhec
         7BbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=eWZ+Zix3WY/IdhDeiDO6JTzS4nVuBKfS/clOEc00lJ0=;
        b=aT+Eq9BLXRSaU2dMM+o095n3N1Ae93auI/0PJzPvETKYIqeF1SqaCSNBjR2mpNd68K
         HzucDChg2qgJo0+Iq6rHZTnBaYvfeHOYmkGqA3qDe0NgQsWpSOm6AiWQLDPrVoAHUiqB
         3HC2Qutb05oKqX8ztCIwwgEPcDVD7bp7S1UxSjAFmMq3PHO8cs2zXJCgj3+j16xvrE5p
         L+nqoX8xCc8r3olSLOWYP0v0OZ9zPcyNhvSzEPHrtLT2ipvziYEeoaJc27YjIb3bqOFR
         vD1sQKO8OEA3FG1tz2Q6NWJN5owmEnCsTt75YfZxLvazx3/Q8i59FP5YdXDooVZXMnOU
         WQpg==
X-Gm-Message-State: APjAAAWtzNAsfeKQ73hz35YPHE3VK6d5967hBdNhYseyb4Sxgpc0KqDZ
        6anG+9kbuGNMrqdVKsmhd2y88iTs
X-Google-Smtp-Source: APXvYqxExEFkCA5yF6qhl5gZWGXH5SzN1Xh3zg9FqMdZhtGjdYS+34X9Z16e7narvdXvCHl06LAwhA==
X-Received: by 2002:aa7:957c:: with SMTP id x28mr4388928pfq.42.1565106575796;
        Tue, 06 Aug 2019 08:49:35 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id y8sm84693946pfn.52.2019.08.06.08.49.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 06 Aug 2019 08:49:35 -0700 (PDT)
Date:   Tue, 6 Aug 2019 08:49:34 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/53] 4.14.137-stable review
Message-ID: <20190806154934.GC12156@roeck-us.net>
References: <20190805124927.973499541@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190805124927.973499541@linuxfoundation.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 05, 2019 at 03:02:25PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.137 release.
> There are 53 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 07 Aug 2019 12:47:58 PM UTC.
> Anything received after that time might be too late.
> 
Build results:
	total: 172 pass: 172 fail: 0
Qemu test results:
	total: 346 pass: 346 fail: 0

Guenter
