Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9798432323
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 17:41:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232357AbhJRPnm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 11:43:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232209AbhJRPnl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Oct 2021 11:43:41 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA39FC06161C;
        Mon, 18 Oct 2021 08:41:30 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id r2so16625423pgl.10;
        Mon, 18 Oct 2021 08:41:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=e2c2jS2FrJNz2g2mQLqY/djnjI6hageyLGZiZ51JrFA=;
        b=B0yNCsmlEjlEqqJmYDGGVX8eRBpnA0UZ72+fIvTAr/QDkkAEqiP7otU2dPnhkxNZYX
         TbaxREVIC7ERaYt28ELhLfVJSDTBvpQ6d14thJDO1z5vAfS0KvPFCuRKS6DkA5C2AH4n
         kbStD9ta7eYbxylYHF7tJl35XMrF9rt5ZNHhCa53MIS+nOJO7z6YgcjudqDthWQ5CvD+
         JX7yxaljn08B/LbSHLsLQSY/IWuecSyAsBHReiJt1j30uLQ0u+iQkFjya1Dr2xgGyWu+
         5WGTNEQ2EGqAqTsmbz6G4g958nCSSCSunx9aXVHQuGnUK8VDLCqr9CVrsCcZ7d3qjV15
         Ij6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=e2c2jS2FrJNz2g2mQLqY/djnjI6hageyLGZiZ51JrFA=;
        b=4jzClMs+pPDQHI7Gw5gCJAS7N5QJTZ+oOrbUe23AocLHaqXtQseAJWC+KwY3k21ylF
         llq19rsa2HSkQdQpDflXo8c/Ni4IwzcfL+V5/7kFsuynJa62JqQLkrC368UeTaDz0Nxn
         M6m9hbB/aj0TiviFxpVyiUoPCzEig0RW/4Zvhc50XBQzRi7fZhPvatqdi189xaIZdl6M
         fh/06O3DDPqVtqE65TdrDJbsUs338W+R5nQkQMEgsBsXZz898FOyFX2257/grvOmme9k
         8mJCDrrn0BvCDd7grgTwD+vsEAITzT6JJT218xjwt2oGI9S11r17kt+HEdAaU7Dqs5N0
         59Vg==
X-Gm-Message-State: AOAM531FmyIWXc2Mt/meACJ/lZmNg6oXSYamaAld3cmffeYB+DdongVZ
        JZ0f4RV16RtSRbPMEQNdzdryYsFoZLayo8sZ6II=
X-Google-Smtp-Source: ABdhPJwBZYesskDJVr40zrVeAU2kr9mjJC+H1ix1FsMLMfOj2fcaGrteLU/CUoaMOqhpqtKHZ6iQ6A==
X-Received: by 2002:a65:6389:: with SMTP id h9mr24542202pgv.83.1634571689597;
        Mon, 18 Oct 2021 08:41:29 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id v7sm13137233pjk.37.2021.10.18.08.41.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Oct 2021 08:41:28 -0700 (PDT)
Message-ID: <616d95a8.1c69fb81.cffcf.451d@mx.google.com>
Date:   Mon, 18 Oct 2021 08:41:28 -0700 (PDT)
X-Google-Original-Date: Mon, 18 Oct 2021 15:41:27 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20211018132340.682786018@linuxfoundation.org>
Subject: RE: [PATCH 5.14 000/151] 5.14.14-rc1 review
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

On Mon, 18 Oct 2021 15:22:59 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.14.14 release.
> There are 151 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 20 Oct 2021 13:23:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.14-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.14.14-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

