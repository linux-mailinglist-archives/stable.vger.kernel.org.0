Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6042D3AF5E4
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 21:16:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230076AbhFUTSz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 15:18:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbhFUTSz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Jun 2021 15:18:55 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00C6BC061574;
        Mon, 21 Jun 2021 12:16:40 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id h4so3426094pgp.5;
        Mon, 21 Jun 2021 12:16:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Zt/GPgC7zXhSZxJ3I3ql8E+KcIIkQFY3WfRusDWFKW4=;
        b=I3ob0m51apj4aZ9Yl40Jwo7+yfUsxrLZZh+sVpURIYa0C5lrDEyagNy/qhTvweD0Hg
         t1aff8ifNjAXmUZ/21cwzrhKAC3yuLAmZNYoBQUzNpIF+kTQ3iOQqx0KvKpWEJLMD86w
         IaqVZPYDIpYtmTaMf8pNVkMQoEPN0/6SmQZadFG5nUeJBoi+vku7xugpGTWwKPwRtdBR
         5QxjCW3Fwz9tY26A12t7aF1rYSIy1mh6gTyKfiYDNpHf0pMwk1vQvuljrrmTLti4QUD9
         DGJJ7tdeMTK/PRKzcWL0fZwG9SCVUlZbSFqPU67Rm9Zb5GZQ4cH3LTNGMD2txukwWDK0
         xtcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Zt/GPgC7zXhSZxJ3I3ql8E+KcIIkQFY3WfRusDWFKW4=;
        b=azF09cdICJ+/43VtgFXW/ngIW+SP0cUjxUvOLmQv0nYrVd/pV+K5w3Vy//F0FjjOgf
         VELQb9OiKWE4Ef+cyjxd2S8CnvO37iWUYZaR0JFsqKK8WpWsHvkiCtrR275m6FXVgvWw
         xLYFembRUCxFbOb+eT5agiDVfoEsLM3o4kauPEeJmBXronAfYNSZTggqrHb361//UXjb
         JyhLfdm69y0DJIgG5a0cYtR72E+Rt9RqgqcfHfJkjOkxNRlf+1i6d535DhbsWA+JI5uB
         HFa/YT/0H5BIlTI1lelfLIO4kG64G0O0FSQafJoH9h/fROlSk7p420mSLNzxIgqS0xLy
         1gsQ==
X-Gm-Message-State: AOAM532J4uG42WB7cq5QGjeY8YmrmbcnTumAACs8BIbF1xfyfTnxVO2q
        7BpNiMMhl4YtNc20LwmtrYud3HANYWs=
X-Google-Smtp-Source: ABdhPJwDKkGXn6QbAkpNpNSx5Gj5iFrYgh2idOAMWCmXrv9SPAtOMpavPLfLaJ5HSMfnPn7qBJYONA==
X-Received: by 2002:aa7:8058:0:b029:2e9:ee0e:b106 with SMTP id y24-20020aa780580000b02902e9ee0eb106mr21248704pfm.4.1624302999974;
        Mon, 21 Jun 2021 12:16:39 -0700 (PDT)
Received: from [10.67.49.104] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id j4sm7960pjv.7.2021.06.21.12.16.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Jun 2021 12:16:39 -0700 (PDT)
Subject: Re: [PATCH 5.4 00/90] 5.4.128-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210621154904.159672728@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <02601ffa-1417-73e2-0608-3eb94fa0e3a7@gmail.com>
Date:   Mon, 21 Jun 2021 12:16:28 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210621154904.159672728@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/21/21 9:14 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.128 release.
> There are 90 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Jun 2021 15:48:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.128-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB, using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
