Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85B1A19E43
	for <lists+stable@lfdr.de>; Fri, 10 May 2019 15:34:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727691AbfEJNen (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 May 2019 09:34:43 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:42958 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727258AbfEJNen (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 May 2019 09:34:43 -0400
Received: by mail-pf1-f193.google.com with SMTP id 13so3246850pfw.9;
        Fri, 10 May 2019 06:34:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FhR5+IY9zMW5Wog9pNRXkSIuLrcNsAsDy74ZM0+ZxLI=;
        b=ZIMOlI7IKya3SaKkFCP03AUQeeq3SZV1a3hBib4TchGGBSCOBWEOeJOgDS+Kc7Ex/s
         oTtM7CPH6Y1vOPD5FbhmYSd6tosTDypnw7FSzgHMT5x5Nkp4gBDaesuHG1JaTfYnuoYT
         zzuHTcY3qEinh7bMlOmoqVO7wn9qn/89zlFd+ciRmxVbe/JoTD7tcgmLa88zExkXmR0P
         vmC9cZWDw1T3Q3p5k9pvTVHMsn33T4p1IpG9D/LUfIdd514OKN1sQKfn5sJ5/Qx+pcKs
         j/eaNKN2YPMKVG1On+A5pEcCkv1cuX9GK0Jrrg9iwMhvNM1m6sRBl4tmjk5FSA5Nu2W0
         usNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FhR5+IY9zMW5Wog9pNRXkSIuLrcNsAsDy74ZM0+ZxLI=;
        b=l6/wkFKaacQzyW9FYL8ucEZSmMS/pO1prbcSPGTpyjAOxn0vM05o4nsSjtwjCSGQVN
         E86ktT8XCZAo/414F2LWHrbmZlJBYzpg6eQrTvd6Vgewali7JLAB1HUgnP1PlFc5QcAP
         oKZWy6RadkuH9M7Hixml4yaJtoHmdDoW2SCE3Famyd6/WapG+FWHj7dRKYxCMube0rzb
         KmxKkHwpHe9YCCamzGweA5Jvc8umw9/DRyyCNDjVJ+NLHPsY/XMFYxO4ubI0nlh9O448
         pQ9SCu/PB0uemyLcioIoj7zy/ld6Mec74MRCpF1baFEyAWKzJQOpt0Krd3eG9AymURdf
         InBQ==
X-Gm-Message-State: APjAAAV9TuxD3YZiG9+RDNeNEp4UpPS+w6cMyDCWGek77H+Y1SpIynpl
        3ghwG+QNJ23vOhZU0J9fHLOeIHyA
X-Google-Smtp-Source: APXvYqxnJWeLY9kqX8Qy3G9elQAf/UzxYmUh7/228HOkwYh2FtcGTcOBPSRxz9kMl7+nn3/lobZfmQ==
X-Received: by 2002:a65:64da:: with SMTP id t26mr13607701pgv.322.1557495282332;
        Fri, 10 May 2019 06:34:42 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id c5sm6034048pgh.86.2019.05.10.06.34.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 10 May 2019 06:34:41 -0700 (PDT)
Subject: Re: [PATCH 4.9 00/28] 4.9.175-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20190509181247.647767531@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <d0da463f-216d-717c-8d3d-6001685d77d1@roeck-us.net>
Date:   Fri, 10 May 2019 06:34:39 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190509181247.647767531@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/9/19 11:41 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.175 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat 11 May 2019 06:11:12 PM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 172 pass: 172 fail: 0
Qemu test results:
	total: 320 pass: 320 fail: 0

Guenter
