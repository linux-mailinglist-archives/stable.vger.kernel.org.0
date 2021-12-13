Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFB1C472BC4
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 12:48:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234613AbhLMLsi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 06:48:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231452AbhLMLsi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 06:48:38 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF7CCC061574;
        Mon, 13 Dec 2021 03:48:37 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id y8so10997730plg.1;
        Mon, 13 Dec 2021 03:48:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=XJm5xGkf3442dPVinlzvRf5ooWs4SBZadjjoJSQHWbk=;
        b=Ex2RjiCpa2Et9W2nrST6BB6J/c7l6lDwupnXahPSccQauD+cm05PHU1QMuWm4geH0X
         zyknqZcVpYdfTDSBNlFs3bJTMEaGiZGiwjxZcRMEfhrySc8i1IOkgR2JZV/9jiEXQrkI
         v59y5HraDy1pmUVWVGSATJNYU53e7usA+VNr64cALzRHEn0Qcv7aPAssFK5o+2wbuKiE
         LBjNaILQxdcONqqggxDQJ4m2wZOL3QQ5I4/sx5ciodzoP9yhxiHWeS/nFAykdusfe6Gd
         WR5hL8PKadY7j+3UM8IGAJqNQNK0GYU7R/NAnC5taOuDV6a9IeIF/bCqtwQSbSHKy1Lt
         ynaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=XJm5xGkf3442dPVinlzvRf5ooWs4SBZadjjoJSQHWbk=;
        b=XcrFaJeqxNDQIUg/6BepAW6osfC5QjNpgd804RTLeGs8gmxVBq6HgXlZuqfT/A589Q
         fGfxnq9KOd7cCg78apVK2Bqlxi88sbIzcAekf/wW2p+LwyWSwmk9JjNIPZb/mARBsrT8
         veyDqiHCFca0VNqqSXzUr3GQBVoq/XcOAD5YKO25qx5R46lOClPeUwZMNNachD4eSpk+
         31qu4cwfIsHbyhIcebTG6YQ8cWHQaiOzH1KX3X5rqhMrmDFutpOiAjBRqRh87SUBAJPy
         IZMtFgNPgR86ZAUCVW38aUKb0V+g+C6K139DHzSii+ooRlkXbZnlGMDT8TXN24Ld1nRr
         wj9A==
X-Gm-Message-State: AOAM533j2CDDt7xxfC0gpe23nwpGKUzevIoBFVbi14F4tK4iioQ75a8J
        N7P0dm9sJjRHJwasVRuKfC3f1oziLOnf5Y41krw=
X-Google-Smtp-Source: ABdhPJyJaWTkyOzqn2gQhyBX55Wj0wne4hV+/YAIwGpqx2W8JsM6GW7my+DApmT55gGi/EZMKzA+/w==
X-Received: by 2002:a17:90b:4f4c:: with SMTP id pj12mr44171359pjb.218.1639396116838;
        Mon, 13 Dec 2021 03:48:36 -0800 (PST)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [71.19.144.195])
        by smtp.gmail.com with ESMTPSA id s24sm11744034pfm.100.2021.12.13.03.48.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Dec 2021 03:48:35 -0800 (PST)
Message-ID: <61b73313.1c69fb81.fc408.103a@mx.google.com>
Date:   Mon, 13 Dec 2021 03:48:35 -0800 (PST)
X-Google-Original-Date: Mon, 13 Dec 2021 11:48:29 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20211213092939.074326017@linuxfoundation.org>
Subject: RE: [PATCH 5.10 000/132] 5.10.85-rc1 review
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

On Mon, 13 Dec 2021 10:29:01 +0100, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.10.85 release.
> There are 132 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Dec 2021 09:29:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.85-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.10.85-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

