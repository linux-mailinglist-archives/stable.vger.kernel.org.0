Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD0CC3E28D7
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 12:44:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231941AbhHFKoZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 06:44:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231765AbhHFKoZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Aug 2021 06:44:25 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C31C0C061798;
        Fri,  6 Aug 2021 03:44:09 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id j1so15978237pjv.3;
        Fri, 06 Aug 2021 03:44:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=roAYVUMp9WAxmVPsD/OSHjWzRPnF3uQ31tcMfrnozE0=;
        b=jIBazFpm2apO6eiXOj345zGD5KTrnuJfxgh83k+EM4ZTk4p8FwVWjIvURxIUr+NxAk
         N+SmPhxrG1+hjSqElRBY+xOuhAGUCVnYDXyU8Lv+gYx67gy8q+e9KwgTVPD8CK+FuYcr
         fO9Ii2dYoYul1sQDXdLAG0Gd0v44+3zKXq1bLGDr2zSQvXljCHGyhj7jzJ5OJ8VilG/x
         10e9oNCHg85rYDOxqRliAQCglCf9Agdtx7IwgJQDzIp/5gA9AoDHqBf22rgmWkYcGrhA
         5maVTD1kO9ti1MQobfo7WZHwfYJjqrP8/H3sfJJEH6ikrY0gk0MKeP42r98jvrbLPYe1
         YFnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=roAYVUMp9WAxmVPsD/OSHjWzRPnF3uQ31tcMfrnozE0=;
        b=t5w3ipKslNz74IW8+6n0KItseCYgLiQj+TkiCUpeKKlfvzAcS+0w2dQ94CCeDBHBy4
         v/eC2crYn+9FGvC9IP6hVN8UB1Joa6GNJ+hfh6jQRL5nIRnMDlUk4dELnwczSyT3+rhP
         Hpt1SOz525pb+STdbLblPshIkXQZbeMpadlArbyay+mUzriDk85HZD9yeHjrmye22IEy
         xFMsBxHVZS2bhOph4DfLLD4IZg+RbT86Rvvt/CWux+++GvEYJXZB1Zg3ZH5ne0Y6XYDT
         X85KIOZdOiUbU8aQINfgLGKCtJT2yBuijNUd7+qRph46E4lv23mf2t+gLvAl2Okf9/IZ
         9XDw==
X-Gm-Message-State: AOAM5308Rs8qulp9l/91XBYUCNuqXK0lYbPzP0pVI3qRPLiOexTiDSfW
        HUcw4vlysmocOni9X+9mpNRTH8/PMKfIU3VLdqA=
X-Google-Smtp-Source: ABdhPJzHn6ooXk3TPW1vtHKO0qNzVlKoF8CvYfpPTHbWhtPhynSy9XRMSCJfrqtkvAhqYV6xedXzKA==
X-Received: by 2002:a17:90b:4393:: with SMTP id in19mr10098346pjb.124.1628246648972;
        Fri, 06 Aug 2021 03:44:08 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [71.19.144.195])
        by smtp.gmail.com with ESMTPSA id l18sm5311662pff.24.2021.08.06.03.44.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Aug 2021 03:44:08 -0700 (PDT)
Message-ID: <610d1278.1c69fb81.3a1e9.e853@mx.google.com>
Date:   Fri, 06 Aug 2021 03:44:08 -0700 (PDT)
X-Google-Original-Date: Fri, 06 Aug 2021 10:44:02 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20210806081113.718626745@linuxfoundation.org>
Subject: RE: [PATCH 5.13 00/35] 5.13.9-rc1 review
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

On Fri,  6 Aug 2021 10:16:43 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.13.9 release.
> There are 35 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 08 Aug 2021 08:11:03 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.9-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.13.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.13.9-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

