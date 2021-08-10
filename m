Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 713DA3E8461
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 22:31:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233150AbhHJUcB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 16:32:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232989AbhHJUcB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Aug 2021 16:32:01 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBB3FC0613C1;
        Tue, 10 Aug 2021 13:31:38 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id lw7-20020a17090b1807b029017881cc80b7so5983628pjb.3;
        Tue, 10 Aug 2021 13:31:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=sCJmRXtAFx1id8n53s1Wlkw7cLGY+3InXPCBq6eP4GQ=;
        b=RPdchWlrUOia0hakEQtgIWRuyEWnhi625eritqjfrZQZekw6TPvh8JLzwj0FVeUdPO
         DOQJ2OdG6ePlAfatLxsOiEDuib9IfJvT2YqLvQDD59oYZC/xq/5viWS+ZZixKxwtuK0f
         S0lutgqSH3mTgj+oQaxr06V9y0BlMtlokw7fISQ1496kjBKvlVN3KOEmKbVy/8MM7W8S
         GgIH27pyfoLdriJ8IeZ7ad7vl8HUN1TfMa2VO5qzx4ImtV/OBa7PiOQwPoTxb+P5sWfg
         6xJzFea1NwVNkdbcT7mx3ytd4Q7LhKpnhzMav3qKmtyJSQARt1Cww2pJWENL92LxivrN
         rADw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=sCJmRXtAFx1id8n53s1Wlkw7cLGY+3InXPCBq6eP4GQ=;
        b=kbUdS2ViwnMK3yazEOYBtr6CWYyWfYyfEBD/HQhyP4ckXJ0IFWT/6kyixPokr7EFNH
         60OBKqjT0STfFQtOL8+Pqa4oBM2SxLOUHk88Fs4owghnAKPc0a/t32mNXqqLuKBYArHG
         OQc7fvMJ5ymkO62XROnbKTHhybzEqid+Xk2686+q/57lMSZG10g/S69/Kdsb+1YVf5cm
         9ElPPqRGJ45oY4E7wheolufX1k64qGZo6USISzM6Oc3Glq4feqE2JmiG6k00hSIJymaQ
         0uoHOES21JCBzw21WrUC3Xk+ckfvFk2xUr9VNodjX3rA3z9BHquAHHoqELjf68hkjJvI
         5kEQ==
X-Gm-Message-State: AOAM533sAOcw6vbrhKgMkL/QnYroUvBYVL1wBeJwgJX5uHjvUmP2hEjg
        czFL4FBnxwilsRVy2qPWRvsZfzwg4v20wZhRVFQ=
X-Google-Smtp-Source: ABdhPJzUSxgZLvt1GPVGmL8+KXa4Q1Dxn1bY3pG/tCjVtQxXyHEeqhME3LkjGz1fcRFRmKNsQOElzQ==
X-Received: by 2002:a63:4f51:: with SMTP id p17mr66817pgl.29.1628627497857;
        Tue, 10 Aug 2021 13:31:37 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id o10sm21843282pjg.34.2021.08.10.13.31.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Aug 2021 13:31:37 -0700 (PDT)
Message-ID: <6112e229.1c69fb81.5a8e1.ee13@mx.google.com>
Date:   Tue, 10 Aug 2021 13:31:37 -0700 (PDT)
X-Google-Original-Date: Tue, 10 Aug 2021 20:31:35 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20210810173000.928681411@linuxfoundation.org>
Subject: RE: [PATCH 5.13 000/175] 5.13.10-rc1 review
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

On Tue, 10 Aug 2021 19:28:28 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.13.10 release.
> There are 175 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 12 Aug 2021 17:29:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.10-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.13.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.13.10-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

