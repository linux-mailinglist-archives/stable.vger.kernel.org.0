Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D3187FF6D
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 19:21:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404611AbfHBRVA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 13:21:00 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:44608 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404609AbfHBRU7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Aug 2019 13:20:59 -0400
Received: by mail-ed1-f67.google.com with SMTP id k8so73046103edr.11;
        Fri, 02 Aug 2019 10:20:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zhFx69iYesqkuCIeX5oZULk6I2Y9LTp5L/03Nb7z1t8=;
        b=vNon/UxeWt1T0Ri+4vg29KTL6sjs8XKxzb+byna4H3aeaSkdNxj4gdu1OgccG8FOEN
         xXJcDQZdSoA8h05fSbhxLLIA5a8obsbQ/nxgLXr++vJWsg1H+hdw6kENeIZbUGN52NMF
         v6uiTBmI2z6SlF6c3oF/FajTP59ZESOnDUqsOqydw8Ej7Bx95fiUmPr6Z1hJfNrGYDcz
         E2UPDz5NSmuImKtVniZQVLlWDaH1s9GqQemXBiEQZbE7wWK/pGuZCC/n92p8FZvJBsbI
         6fXUXLHVh+x1EGbJGxiPGgJSN9boZ5rG2rJuodPMcuKNbo3VNutKHOps1u94YRbqSFTw
         PWrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zhFx69iYesqkuCIeX5oZULk6I2Y9LTp5L/03Nb7z1t8=;
        b=KENWuGvL+CuC0jJIWL8/jERyTppLxrhDjg2/FmGk8ckok4Y+lj2tLDSXRiWxd9ZgUY
         zt9UJwovOqcBnjVmU4FglfUCHi/H9eyowLGJWFIaY3oxZdrUs4Ifn5XAxFebvZSZqReJ
         LkWp9v3vJyOk1gImxbs2zJXRJH9qBId/btnGipmHkXbi6BjlxuGpUdplkLlVoDt0Qpaf
         EH92iaaNRNqSvY7waL3qPDYFUvfzRb0wktGGrVpETqzBScO7rkXUPfAqQdRYdDkkcllE
         HKX2iPIUJGg5Kp7ynAOR33wh+MwXqKR31aEeVkD+pUBEfyMqn9CPqaWFnS6vMnSqqucJ
         vsow==
X-Gm-Message-State: APjAAAXDMIVOo/BFUoVlIq99813itF9cOsjSqCgftnPWvdN1Rm0giYXs
        JTXGDGMdhXo/DHIY31sUZA0=
X-Google-Smtp-Source: APXvYqwM5hReqfrYiVL7qjhcZ9TuisFY+xnAwe2m+8Qbx+TMAst+LLbnXKL8mLNXktxE1Vc4v9HzMw==
X-Received: by 2002:a17:906:d183:: with SMTP id c3mr18217358ejz.149.1564766457956;
        Fri, 02 Aug 2019 10:20:57 -0700 (PDT)
Received: from localhost (pD9E51890.dip0.t-ipconnect.de. [217.229.24.144])
        by smtp.gmail.com with ESMTPSA id v12sm13353273ejj.52.2019.08.02.10.20.57
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 02 Aug 2019 10:20:57 -0700 (PDT)
From:   Thierry Reding <thierry.reding@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH 4.19 00/32] 4.19.64-stable review
Date:   Fri,  2 Aug 2019 19:20:56 +0200
Message-Id: <20190802172056.18906-1-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092101.913646560@linuxfoundation.org>
References: <20190802092101.913646560@linuxfoundation.org>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

On Fri, 02 Aug 2019 11:39:34 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.64 release.
> There are 32 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun 04 Aug 2019 09:19:34 AM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.64-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v4.19:
    12 builds:	12 pass, 0 fail
    22 boots:	22 pass, 0 fail
    32 tests:	32 pass, 0 fail

Linux version:	4.19.64-rc1-g63a8dab46af2
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra30-cardhu-a04

Thierry

