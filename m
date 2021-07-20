Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3BB23CF364
	for <lists+stable@lfdr.de>; Tue, 20 Jul 2021 06:42:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241605AbhGTD44 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 23:56:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239282AbhGTD4i (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Jul 2021 23:56:38 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D57CC061574;
        Mon, 19 Jul 2021 21:37:15 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id h1so10846316plf.6;
        Mon, 19 Jul 2021 21:37:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=YuEAFSJVQV9M/EiWu3gH1Ut0VVIy3FnGsqSgvd/0/9A=;
        b=orjUIwlXr6CbBLFXW7ONt2TCnXZOuj2XktWoQrwEy+segu4Jg3nHJ/s9jg/WL/mYB/
         1AovcR0LvhuzCYbNNG7vf3zJ9+BedEI4A3fWkE7MBwT3DfIZqO87PhDshQLtheP6lMBZ
         A8LM3pT4U7GX6L8rTBBJX1HATQyNQHD2uF1KJepEejRllmX7Qj7dfrctyNbFkQSO41WJ
         pFgN0qcKhuBbEUhX0fgF4GGqJiH6NY5tbz6wnPiv39JSFzENjOFsWNmmREYw4s93hpMf
         HWUBCv6C7UQBjHo67wI/aZR+FP8n2oN8U2m1ilzuQG/OILe2rL8mshUnoFJeu03eDyUU
         8W4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=YuEAFSJVQV9M/EiWu3gH1Ut0VVIy3FnGsqSgvd/0/9A=;
        b=K8NZzHdK2zlQIEMy+FAe4C/gpqLHAj2E6wtq3RgGWxNRvAVmlwzQbAVi+/4Ate/E6D
         MtCzkHsLEX205/csstIXErhYSia+fIJoC06VJ4ZLsZ9ZcTmD0kFJ5QaX27WI7BCTol3K
         flbsIjwHeqNJfRWllFUvoAcEtrHmChvoUx63JSGUe6t4qsNb5s1XabLK3UPZ7+KTzVl+
         EIKCIVl4LYhDqR74IjR/eG3TuBaRI5ID+Y5nYLLPepYBCcHFG3cEgvoYuCv7HS73yoZT
         /4x2HuypuS11xq1eRxXSTlzXch6K94P1VB9aapwUif2xPIPYv+F4S7sW0IZrLzlahnFA
         O+uw==
X-Gm-Message-State: AOAM531z0gMQrB+yvOjfRdk4biadDQDBhp21hw0GDjAzsHeTnuNJJCx6
        4hZ4JYHyU3iHhygxrp1b2bz1ZeOC2JMi9xmDEA5WLw==
X-Google-Smtp-Source: ABdhPJxkD0dc2t0lsHQEKqBx+UdUgbM1p8DRh9jvd1RydQIwl5vjqbXcwqoUYUsKPH7zxp+oejfuYQ==
X-Received: by 2002:a17:90b:fd6:: with SMTP id gd22mr34030971pjb.37.1626755834416;
        Mon, 19 Jul 2021 21:37:14 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [71.19.144.195])
        by smtp.gmail.com with ESMTPSA id m24sm23751431pgv.24.2021.07.19.21.37.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jul 2021 21:37:13 -0700 (PDT)
Message-ID: <60f652f9.1c69fb81.2969a.9994@mx.google.com>
Date:   Mon, 19 Jul 2021 21:37:13 -0700 (PDT)
X-Google-Original-Date: Tue, 20 Jul 2021 04:37:07 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20210719184320.888029606@linuxfoundation.org>
Subject: RE: [PATCH 5.10 000/239] 5.10.52-rc2 review
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

On Mon, 19 Jul 2021 20:45:28 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.10.52 release.
> There are 239 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 21 Jul 2021 18:42:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.52-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.10.52-rc2 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

