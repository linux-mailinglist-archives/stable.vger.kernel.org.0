Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5789C14CCAF
	for <lists+stable@lfdr.de>; Wed, 29 Jan 2020 15:42:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726184AbgA2Omq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jan 2020 09:42:46 -0500
Received: from mail-yw1-f65.google.com ([209.85.161.65]:41654 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726178AbgA2Omq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jan 2020 09:42:46 -0500
Received: by mail-yw1-f65.google.com with SMTP id l22so8475655ywc.8;
        Wed, 29 Jan 2020 06:42:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=6aMcXGpBcnwaHLGsgGBHtnVysmTOI48xZtfxRV3mRrc=;
        b=RJvnUVt2ixBbIcI/CU7pVru8iplyQlCITUdKsH3JB54ZQAsPTSJEcYlz2OOc/SOFGh
         5o7aux1a6AgFIavq0KhB4h35pd8JLaLO5ZpIKu0jiU5k1G+LO/Y9hd8z2GlPM+62um2n
         hY1hNX9DjCiRpPMuG/3cy8B+pMdtsc1QuKXcFELHpxbo+wakp1Gzo1xJUQP6AExjnKo0
         E5Xt9PhObdeg3ipWvXsXCFIRKZqAHM0t2nwH6/lXjz5ibnkHqT3vXZGh7tt9EC5wcI+g
         eHHKNvbwt/YMvAd5cD543+h881D6PckLrr5YDhu3ETJQ19rcra81EZ6rEgkk5hsHTQ1o
         TT3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=6aMcXGpBcnwaHLGsgGBHtnVysmTOI48xZtfxRV3mRrc=;
        b=CkNIadV05oFRpNqq4dgiRtnhEP51wDrw9xACuPvE6RK5frnCa7bySqRABxq6iFw7lF
         +069lMwlXqBnyfODHj9kJRFtJiaC68jN/+wBwCJ3ZxXP5PafaGmzkQlweNS/WC9nkOGM
         FjehaQdKGflPzLwIWcaA41z4kWWuqGURYFX89auuoflGyrwwfOGJRa2t16oEVL1IFn3w
         oNTQERyEVRnNVvhKzd16HDLGYhSmCPAOwHF+88bnFnoNLEFs3E4QtcQjeais0AHR6+wO
         fL12Ox+MqRIUGZcTyx+4aXe94s+SfSBjU7duWWqIYu5Q+zOifGi+TEbjRU2iyOeazmCo
         L86w==
X-Gm-Message-State: APjAAAUnHvs60akppcepamha/s4MI8Ew1BfpQmT72tV2BH9QWoYh++Ns
        AZh91u/TxXoxP8Aug6H2jXet+eki
X-Google-Smtp-Source: APXvYqyCzLblsgdAWAmz9RSckMMEbZPBRQFhRiLkeQI/TCmeIfwItcMnCeQsxlOH+P1BEap5t4YtAQ==
X-Received: by 2002:a0d:d602:: with SMTP id y2mr19182887ywd.441.1580308965353;
        Wed, 29 Jan 2020 06:42:45 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id j184sm1036124ywa.39.2020.01.29.06.42.43
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 29 Jan 2020 06:42:44 -0800 (PST)
Date:   Wed, 29 Jan 2020 06:42:40 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/46] 4.14.169-stable review
Message-ID: <20200129144240.GA23179@roeck-us.net>
References: <20200128135749.822297911@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200128135749.822297911@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 28, 2020 at 02:57:34PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.169 release.
> There are 46 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 30 Jan 2020 13:57:09 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 172 pass: 172 fail: 0
Qemu test results:
	total: 374 pass: 374 fail: 0

Guenter
