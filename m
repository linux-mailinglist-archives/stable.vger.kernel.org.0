Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7945E457750
	for <lists+stable@lfdr.de>; Fri, 19 Nov 2021 20:47:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236315AbhKSTuA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Nov 2021 14:50:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236607AbhKSTto (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Nov 2021 14:49:44 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7565FC061748;
        Fri, 19 Nov 2021 11:46:40 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id m24so8895830pls.10;
        Fri, 19 Nov 2021 11:46:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=MRvHq33o7p9m/i6K88NeRMGJTvgRAkoVuYcTYKu92bY=;
        b=Q7Eu6CwU1JFaseM5zVtQnFdT8cfh/OjzGur1OTZaB8Fxwi7l1AZyNpQWrL2EOyW+vC
         0GhCNCkyiBkYFUmaB7K2tnS+nv2vLt5j699q0RHpPela6MJxVuuD2etMP6A2V4kiiuKO
         PiKzcLOTXzBb1ofdAKn5uY4MsDqLTUP0bGxPMhVbmHJ01f1SVU0bamiM0XBsz6EQkk7Q
         kkIjYUXCMCiznRgnXpOGzAqr/IvELfYIBkf3lsp7CsxVrawQxVNnAcWnadF+DkIvBB63
         pxrCaVixVehN6Rgs2kN//rewS8ssvF0vT4xERZevHMjxDb4cNvrSsdLs62wMUNSB8UiB
         LMYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=MRvHq33o7p9m/i6K88NeRMGJTvgRAkoVuYcTYKu92bY=;
        b=tLVNY17lUDev3egyw0gRveUFtSpwXkGhPfXaLGVJ/IlFworlTofAyJwufy0WhFt+Kd
         3ptTmaop6acn1Txswii4pUUSBcJuUeQ9ceufLzUkPPafPOusVLMnoqQO6+Klf9xbLO4M
         Wlp6ao03TrXQnTq7UhKBR6+r9CAKoWYYlO+Blt0aDJ3V8BJJR2XsC4tuNxqeY6mfhBWd
         Ddj4mbjvucuWQQZ+UPMVa6nr5biEfh3/xB0tMDVLYQTqXB/gp35F1fr/1nrd2WfePAMC
         vuxqohNEnxqrSKB+eu/fo1Qin9sIPL0i10GddsHz5z/bLqrfTwutGtMEM1IYtYPiWw3m
         4UFw==
X-Gm-Message-State: AOAM533M+b9I7FEttQ9phJl4jyPqBUTlRrXLSdaBfqUEWFla8S6o7bHO
        7D6+VpjZdXk6+lZmBuy8gVJ91mbM1oKVJ20brS8=
X-Google-Smtp-Source: ABdhPJwddXKVWTODVFowNEOHQaOmMZ/qtc3KLhZsobFoY0gy9iDDHGsFihmlYUPeUe27iZ5v+wpXuA==
X-Received: by 2002:a17:90a:eb03:: with SMTP id j3mr2690892pjz.149.1637351199437;
        Fri, 19 Nov 2021 11:46:39 -0800 (PST)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id b15sm434536pfv.48.2021.11.19.11.46.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Nov 2021 11:46:38 -0800 (PST)
Message-ID: <6197ff1e.1c69fb81.7719c.1c2f@mx.google.com>
Date:   Fri, 19 Nov 2021 11:46:38 -0800 (PST)
X-Google-Original-Date: Fri, 19 Nov 2021 19:46:37 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20211119171443.892729043@linuxfoundation.org>
Subject: RE: [PATCH 5.10 00/21] 5.10.81-rc1 review
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

On Fri, 19 Nov 2021 18:37:35 +0100, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.10.81 release.
> There are 21 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 21 Nov 2021 17:14:35 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.81-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.10.81-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

