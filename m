Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1991928434F
	for <lists+stable@lfdr.de>; Tue,  6 Oct 2020 02:24:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726127AbgJFAXF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 20:23:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725861AbgJFAXC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Oct 2020 20:23:02 -0400
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96F15C0613A7
        for <stable@vger.kernel.org>; Mon,  5 Oct 2020 17:23:00 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id x69so10693315oia.8
        for <stable@vger.kernel.org>; Mon, 05 Oct 2020 17:23:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=H5z/yv6VQv77ql6CIfbXl9fmLX0Uu/irQQCqwxRc9wM=;
        b=ahLReXHdiWj1Rx80wcBV0IPlhVObew8YzyupNAirXxEjqCPX3kwRJoJcRDaUceY5Cx
         yMjms1gfUhFRkHqtKCtTPuTxIQHVz0Hqy8N7ONREplADDzdeoo4KhP3yVgj5vTsdUrhm
         /tXpgbyW/m0Z5p3cutMD+HNtR8jrd5qr5cwD8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=H5z/yv6VQv77ql6CIfbXl9fmLX0Uu/irQQCqwxRc9wM=;
        b=THY/yp3lio/WNp3ey+5lbOAharBnrJzwgUNrObjQ5S6DuOvgMSDb2ksnM6sriWO+eb
         KQ3ieP5+SCZtQJmpPhfEa/sjfg5EqC/RCL8I/oGR7SmeYFra3V9qP88wzkuvOKZEe5hJ
         nyNbJL/7MElbiVuD/YM5UrZttF7L7Vi2D3N1TTGJvuC8pY74l3iCuYN7mvMoS/5rJGaJ
         dcOrvm32oLw+suvtYrxS28sdjYuqoWoJqJts9pUUVFhCJDrSz/xncqWkz8Gxlzmtt5/M
         LNLkbHgU2+a2N3ykYe5v6uaY5fG7Zkn5u/aSLy079jWkoKxbGMqp5eLOaUNfkTxL1OcG
         TSOA==
X-Gm-Message-State: AOAM530RSbRT1blN8FNlTf03NEJ7KSUG8XnCyIfaX4g5V8Mq4CZieZgu
        S0odY9csuu3eyeYAFa2Xsheufw==
X-Google-Smtp-Source: ABdhPJxrQ9Zb8+Es3KbD1mC3T2olZWRdaJKMT54xHZjKzsmz+k5hu4eLbneyMX3cP31KhFD2z5+bjA==
X-Received: by 2002:aca:603:: with SMTP id 3mr1175661oig.49.1601943779818;
        Mon, 05 Oct 2020 17:22:59 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id a11sm437383oid.18.2020.10.05.17.22.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Oct 2020 17:22:59 -0700 (PDT)
Subject: Re: [PATCH 5.4 00/57] 5.4.70-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        pavel@denx.de, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20201005142109.796046410@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <e10eabc9-854c-8002-3aa1-f34eb219294e@linuxfoundation.org>
Date:   Mon, 5 Oct 2020 18:22:58 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201005142109.796046410@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/5/20 9:26 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.70 release.
> There are 57 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 07 Oct 2020 14:20:55 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.70-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
