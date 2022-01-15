Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9056848F433
	for <lists+stable@lfdr.de>; Sat, 15 Jan 2022 02:40:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229470AbiAOBkq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 20:40:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232050AbiAOBkp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 20:40:45 -0500
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95A5EC061574;
        Fri, 14 Jan 2022 17:40:45 -0800 (PST)
Received: by mail-il1-x131.google.com with SMTP id d3so9817503ilr.10;
        Fri, 14 Jan 2022 17:40:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=W50ZckeQoCC0z8xImJgw5j94j3GSLK4e8Lrg1EnOcDU=;
        b=W4LyySCyg2dQREA7aVerDBuP4qXfZmRf1/8C6R+lY0M85eH82ouIsWmcHo1Kp7GqFP
         V9a0JpdCFjDVfXk3SUweWKvk4M1klOhx/H+JUkQJ87B2uNHbEzuvIRJa17kgTmx8cjzs
         kHN8kQxEoCzLjkVasMco88ApSx/hL07IA+Qfn6I+kujoVaBkBGZyYyC5U9eelL8Ymb1X
         Arr3kZJVnjyZvW3ogeyoc0sIkIAjLE9wpyYSB0j9Nv8qzdFoQHI4QBuiljdJsh9hP7F+
         q7PuhCrfP1guUBiWVy9p94nW8yZtooIiPJCwDk0eKjGcw5KziK0yE3gw7JVC7l8z7lT4
         KDiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=W50ZckeQoCC0z8xImJgw5j94j3GSLK4e8Lrg1EnOcDU=;
        b=n/wygxwvbnC43LZDiOEWDv3eEwU+SIznZkmPJiorDVcuFW+VpdvnLPO9Ty/dvvkQHM
         znQiaOAB++5eYpl4tlgusDOo5KE93mw8glnS9+aXycOCQQDc5LuL3LgYE9k5qQNFRfeE
         fm6l8JhBZU+goSe6Gx2JEQUp03iDMp73Zz2PP/EayZ3d+Ln7ZpFa4pUXvIJrQ0SdcZHr
         BWk6eRmkFSrmDGpT92U2dIJWRhkEtzEzHXAIfSLzxfuR42QhAXunh1A7y68pryE4hI0z
         xtn1GHIrpOcfI/5CWJxmqsWomXttkx7/wDo/u+yJDGKJ7KM5B6Zhpyxb504KjcYM7SWN
         eFNw==
X-Gm-Message-State: AOAM5327HiNEc/9OKdGZa3ollOvPBv5VTGBjOHfXTvvm9LVKygBFccRt
        qwvTxt3xf91LdvCfQX97ZeXf1VAL5WkOxYJUj0U=
X-Google-Smtp-Source: ABdhPJzA2z4ehugmgiiu/UTY3j5iXvAY8QcXF1zV8MGwxJX23uyg5k/SsZD0PWzITMRaX8SxFHBXHw==
X-Received: by 2002:a05:6e02:188a:: with SMTP id o10mr560432ilu.81.1642210844600;
        Fri, 14 Jan 2022 17:40:44 -0800 (PST)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id r4sm5264736ilb.4.2022.01.14.17.40.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jan 2022 17:40:44 -0800 (PST)
Message-ID: <61e2261c.1c69fb81.42eb5.73e8@mx.google.com>
Date:   Fri, 14 Jan 2022 17:40:44 -0800 (PST)
X-Google-Original-Date: Sat, 15 Jan 2022 01:40:42 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20220114081544.849748488@linuxfoundation.org>
Subject: RE: [PATCH 5.16 00/37] 5.16.1-rc1 review
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Fox Chen <foxhlchen@gmail.com>
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 14 Jan 2022 09:16:14 +0100, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.16.1 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 16 Jan 2022 08:15:33 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.1-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.16.1-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

