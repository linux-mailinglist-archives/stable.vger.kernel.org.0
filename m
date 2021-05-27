Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A2AD3938B2
	for <lists+stable@lfdr.de>; Fri, 28 May 2021 00:28:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234391AbhE0WaN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 May 2021 18:30:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233848AbhE0WaM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 May 2021 18:30:12 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42538C061574;
        Thu, 27 May 2021 15:28:38 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id ep16-20020a17090ae650b029015d00f578a8so1348415pjb.2;
        Thu, 27 May 2021 15:28:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=WZv67PcQASMRPC3zYPpa0x61J6yRtgH6SH+gS6OFGJg=;
        b=ksHshNVcH908wYnIOm5PkZkUQyH6u42i70piZvaefxdKwleGWI8JLx6OHO2tXRnLVj
         Plr+0wcMUAaWa70gC0G2IyEWSgUO78bD620TJYuKQb49gEGnXHvNnvdOtdpSGManrbH/
         jx+ConpSAQ+Rflpa0alZQ85BX6QRQyQBd0mR+zmTj8MANZVei2v+//bs5Ci2UzjAxx6t
         BmGvBQsldG6cb5vJE0sOZ0FhNfKK9M8z4UWkyFBieBIWuknf3U+7XLG97AXksrO3lNox
         YX8usXDlx7FDRI+fnq5o9QSDLT0wi0mkhqk0gw93ppqeujAgiTUyZ57Yah1FTF7tceYm
         6ZUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=WZv67PcQASMRPC3zYPpa0x61J6yRtgH6SH+gS6OFGJg=;
        b=By640MziOdje2q+n3f+fzwBlkYrGEUM6ueOLLdgI3iykP3qYH5+gAe2XStZHtp4MZg
         48Y4y+pW07fIKTe/sLVLodFSWJy3dnqMP8N5rG3sWvH1dU7buQA6LMnSxxFeU/RQuoW4
         Nt2ttSga4hMhheGLO1L0O72IhENpJKnKqC8Y6eNp7iXQPkmNOxxNRrw6C6XpfXdhwbh8
         9oS581QEN1ebThkRrB5Yx5XY2/WIKT2fF9bZlT8k0P1AS4oghVEakBqoDreY+eXJIIu9
         XyvTv/tC+VCYR3x1iup+u/6FATVjgMKEOAFPOl06ozJ60AefsNP0WOZel17XJf73N9WA
         P8DQ==
X-Gm-Message-State: AOAM5321Fifs2wbF5WsJB4fmgUYpDHyNvgGubLMCNw/ILouEwvWzNear
        GipDLq5SGS63fe6y4I80Tvv9Cb/FQtJWnf1c6dxVFQ==
X-Google-Smtp-Source: ABdhPJyI3X6zEYmNHlWkicXSEGNEDyUICcM8BIXkyZqV6+KHaok071hsBNBwtp+bugASQmJncZftEw==
X-Received: by 2002:a17:90b:350a:: with SMTP id ls10mr714574pjb.181.1622154517315;
        Thu, 27 May 2021 15:28:37 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id f17sm2669636pgm.37.2021.05.27.15.28.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 May 2021 15:28:36 -0700 (PDT)
Message-ID: <60b01d14.1c69fb81.b1e96.974f@mx.google.com>
Date:   Thu, 27 May 2021 15:28:36 -0700 (PDT)
X-Google-Original-Date: Thu, 27 May 2021 22:28:34 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20210527151139.241267495@linuxfoundation.org>
Subject: RE: [PATCH 5.12 0/7] 5.12.8-rc1 review
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

On Thu, 27 May 2021 17:13:01 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.12.8 release.
> There are 7 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 29 May 2021 15:11:29 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.8-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.12.8-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

