Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EB341FE30
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 05:35:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726319AbfEPDeg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 23:34:36 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:34014 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726218AbfEPDeg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 May 2019 23:34:36 -0400
Received: by mail-pg1-f193.google.com with SMTP id c13so838294pgt.1;
        Wed, 15 May 2019 20:34:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cqOzlRf9o7XfNtXIDp9P8gPS3iWzDikrLCsGnPg0fnA=;
        b=JlBH9zBQ39Q2K901VfwGpFs3nd3zx8tmV3fnM0neMcRN6rq5TubPM+d5S2pT3iSRvl
         8HINjg7nlf6wpdBcgXDhHy+tAdTlo6ecpr8eNeh1LcUwaasxmR8vR71Qq0Z44WVRoUy3
         NDSYQ14lfC5y92T4+tj+mBl8eITp11L05a1Sq3K/CtQE5Mo9PLhkfAPn9hWcWHx5ZKlw
         A9SMaz31yS5AaiV3NsCrKgWkf7wYVQGFfG3Hikr2cTnDabysrVWUwItGZqLxpNNNgydF
         h4TPJMYBvjoZ3w5v2lhINeG7dF15x/q9N7fJXu7VpybjSTlV6x014cP/RVve8BLa+7K5
         3w/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cqOzlRf9o7XfNtXIDp9P8gPS3iWzDikrLCsGnPg0fnA=;
        b=L9+CsjSR0MSeJReY6ZkOY2z4nzUo/rIaux+EYP7JO4VBe7UCcflQx6QU8pNQrfcvXr
         t2yImqMZa8NRmIi/a2wzBShXPyGLDBoNuP79y/Yqm+e/szfdEOS8dMpY8wh7tnXvmBKp
         sed07OGlTmNzaV3rP0CO3Rxg7doj4mzt3XGAM6yBmwg5hefTUX7ymc5LFM/AWvDI18L6
         +Sodg4XXweJnlHxqsR0KREkUDJ8Emia/ca4/GjNllcyA55fzZ/2FoSqjL5hqMlz1UR7W
         0Hgw5eGdZTU0pXcn2P8hZY8Lag7en8/s6hwpha+uj0tLrly2wPRgtpeuD4STvu8ZXBhi
         GIzQ==
X-Gm-Message-State: APjAAAWypC1npJV64I6XkAy88Tpjpe3PeG2mj2qRrUVuwwc31Iw9JNCO
        oyD5mMGFWqwNqfFA3VvgaLpnEMRV
X-Google-Smtp-Source: APXvYqziGqxTrpfGLipi1akijyB+uvRyMDUR3Vzt2a93Y9EzRiIlnvuXbaBlw5tJ48euBxJPjiKUvg==
X-Received: by 2002:a65:63d5:: with SMTP id n21mr48001029pgv.330.1557977675795;
        Wed, 15 May 2019 20:34:35 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 5sm4805285pfh.109.2019.05.15.20.34.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 May 2019 20:34:35 -0700 (PDT)
Subject: Re: [PATCH 4.9 00/51] 4.9.177-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20190515090616.669619870@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <af94337a-c54a-dd1d-9db0-d974a764d55f@roeck-us.net>
Date:   Wed, 15 May 2019 20:34:34 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190515090616.669619870@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/15/19 3:55 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.177 release.
> There are 51 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri 17 May 2019 09:04:42 AM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 172 pass: 172 fail: 0
Qemu test results:
	total: 320 pass: 320 fail: 0

Guenter
