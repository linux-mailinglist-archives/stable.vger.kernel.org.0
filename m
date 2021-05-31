Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55F9C39674C
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 19:41:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234059AbhEaRmu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 13:42:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233301AbhEaRla (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 May 2021 13:41:30 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20BDDC03546B;
        Mon, 31 May 2021 09:58:13 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id j12so8727251pgh.7;
        Mon, 31 May 2021 09:58:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=D0sTktuwMzaX1rKRz8yLL+fGIpfvYxfTnd1b9do2Dto=;
        b=UX1WeWMflD9PqTwnc72NRimHsqpu2tYLlBOSZ6GIMqBAI1/CxOjVT29oBAaRzDtKR9
         UWmXq6Iov8A1cpmV/9buzrglLkZYv1fdiFaQqmB9QTt3K5+5fLCkXq+rCusBkgVIGqxA
         4bZb9WaObkmp0KL9UWRB/KqEl+O5R4eg1wr9aAryjvyuieIfwOhAF0qWhBVoIRXXPQCh
         8yZ/t/+wo69Wih7J2Nq4RQPJsfUAE9s4lvSa9AK+uy9qdfsTY0IzkIomzQv5VcHyoM4t
         gWdf2/1/2gYUAQHZTZcS6O5FB1p36dwTzeLeAdctNq6N/TABCySR1IGjHX9R/Y08Q0sw
         aCZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=D0sTktuwMzaX1rKRz8yLL+fGIpfvYxfTnd1b9do2Dto=;
        b=OKgQBYuUsPZPe1LnFqlUJBVGSYp88FGpsvDjduA8FayY1y/8sCt3Ce2kxxO0Csrvc3
         qVteqJrnU5QQ+r9h95j+IV8L0XLsQAFwGZ8QvLQXXGLrLs8f/IzeCO/gGjrDPaG4/WRH
         mQrNG2t52fc1pYQuqXfCIjON4+NfKpVnucRoOTwze1uLoaRfeeFhf8oWSydRnumTduHf
         aC5iYAYJljQUJpyesKKB5mCKevSeHuxSxvteea1a3opAgeAHshgZFxjJ0YpSYS8N4NrO
         MogTVzSjEMt+mXMjMeEBzdyPgq3QOq9DiI2v2QCtQlNKIdFCB9mvz9GGsl8qRK5rKq99
         uTFQ==
X-Gm-Message-State: AOAM533hiWgmQrdRQafGXiFrRhXP2lPg0t0eZzaqzEuzc+cAEGzJ9OJD
        OFFceby8QbmdkyZlFREoQZku1psDkpDcWHmE+cs=
X-Google-Smtp-Source: ABdhPJyAiyGF7HUnxXujW8+Z/eB5Z/Ty3s7NmN048xWNMtV35DEBTPftxeChVoAtrc0b1hJlrFAWXg==
X-Received: by 2002:a63:ae01:: with SMTP id q1mr23011378pgf.216.1622480292278;
        Mon, 31 May 2021 09:58:12 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id d131sm11423398pfd.176.2021.05.31.09.58.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 May 2021 09:58:11 -0700 (PDT)
Message-ID: <60b515a3.1c69fb81.6df57.425d@mx.google.com>
Date:   Mon, 31 May 2021 09:58:11 -0700 (PDT)
X-Google-Original-Date: Mon, 31 May 2021 16:58:10 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20210531130657.971257589@linuxfoundation.org>
Subject: RE: [PATCH 5.10 000/252] 5.10.42-rc1 review
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

On Mon, 31 May 2021 15:11:05 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.10.42 release.
> There are 252 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 02 Jun 2021 13:06:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.42-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.10.42-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

