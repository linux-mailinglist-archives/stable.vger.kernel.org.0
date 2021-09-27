Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B5D541A01D
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 22:29:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236765AbhI0UbK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 16:31:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236529AbhI0UbK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Sep 2021 16:31:10 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31B73C061575;
        Mon, 27 Sep 2021 13:29:32 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id bj3-20020a17090b088300b0019e6603fe89so75293pjb.4;
        Mon, 27 Sep 2021 13:29:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=PNflOBhtWcwbe+fnObC+KsqAK45vtqYTYCHIBYR3xuw=;
        b=HbubGAfy2jxwThiceAkIjejZC/5Z16mjfKqxWrSfbzKqM90mirgAWXandYm0p+chNO
         8/ux0MMKrPIMfLp4pNpMZ2wzleBePqsnKXd7vTF7bmMWGWUT9z93u+vUpx8+H9GzHlE9
         L7k0bXRfbi73nvNSSfzBtmxGrcOZ69rJNeX2Pj7CT6isPlohf7dGTS8zJgaa+T3jbtj2
         ASsJsEieNsXa+GmXOeCzKquwLAO4CyHjagiiK0fGkeMtsjSZmlfkgxcIRXt2pZTcud46
         n+2naK8lMiI40aG6ApHdE/8yAahJrT1aaDA0CXBMInW7MZf9B7HO17l0BM6OBQHs9jSN
         QKhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=PNflOBhtWcwbe+fnObC+KsqAK45vtqYTYCHIBYR3xuw=;
        b=MXX/AwKtfHIGeieYnH2sbWZE8F92pqu5pDLqnjhr/R//+p5q6v3nMqrUL+dJIxTykj
         Mk2peEx0M3KeBgBra3wqnFzcboFoPITBUrY5nKmBSe4Xff/xUNslpjfnh2QZErD5igXj
         PXGn4OixV3M5J8lwIwb+b4gYQ4KzJE7GdjsEv65+rZ926QrV19XSoHITa1fsh6/unIYv
         57wA3HHG7uJwfuc2n7ZGBd4TB5oSQXpXmEhk44ptx8vksWFEd56Lt7++OJKtQver27Jo
         ptLH3XP/7mc3ICL92hyND/23/m6lspVqrmThXdzhc95KkZmObNgv38p6xx8NFgLaVvhr
         dlSw==
X-Gm-Message-State: AOAM5323sirKAu8sN6Q+QK1vwrCRVq0cVUDJjxQaczVKEgUSBq2zDH3N
        PcyVvkT2VRnQzbESuKnAzxkWyCxnlMdyPk4aPGHDyg==
X-Google-Smtp-Source: ABdhPJxTt3YiOwIfmI5ttzzNDXgthpOKgPmC4uKOW+J3dFL8Z1TUAYg2pRDb8oFdmfnxsGOqF4uyrg==
X-Received: by 2002:a17:90a:bb13:: with SMTP id u19mr1145482pjr.42.1632774571116;
        Mon, 27 Sep 2021 13:29:31 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id i7sm19805278pgp.39.2021.09.27.13.29.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Sep 2021 13:29:30 -0700 (PDT)
Message-ID: <615229aa.1c69fb81.8bafc.0c88@mx.google.com>
Date:   Mon, 27 Sep 2021 13:29:30 -0700 (PDT)
X-Google-Original-Date: Mon, 27 Sep 2021 20:29:29 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20210927170233.453060397@linuxfoundation.org>
Subject: RE: [PATCH 5.14 000/162] 5.14.9-rc1 review
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

On Mon, 27 Sep 2021 19:00:46 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.14.9 release.
> There are 162 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 29 Sep 2021 17:02:05 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.9-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.14.9-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

