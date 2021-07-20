Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DC363CF0DD
	for <lists+stable@lfdr.de>; Tue, 20 Jul 2021 02:43:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352927AbhGTACg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 20:02:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377639AbhGSXfZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Jul 2021 19:35:25 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C348FC0A8885;
        Mon, 19 Jul 2021 17:03:18 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id y3so6190619plp.4;
        Mon, 19 Jul 2021 17:03:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=r7YI+ctucv7NrwDn5uv0fpO4SZ9l5Rpoe6dAMY6PgBM=;
        b=gustnhwaA5GuLXc+MJ/B+JyESfKzRwlZzvIPaTV3tA1eaEGuPdnEg8JKZ1kXExoO5K
         wQzLTRWDyso+AgGyY+y/mvJ6n4vkebzVYISs66QM8tdFAo1xyK+YxHXAs98MecIjqJhw
         YhTJ6SyBueCDTwiHTikE5P/qgCt+mojCiTGBod0DL6iHzViLQuHeuXxx/1oDRlLqfODD
         rtD7vrSoXYjm0zsjILBtc1h+XdDmVpaJ9lV+PABoLVl5lztuY+RyFu873VlALTLAAkge
         npwGXGDauATtHa2gzywS8rVfKUEiWWSOeXQNPhsJiVq2qPan7LoCAfQ6EZKI5fQ24x/8
         BHuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=r7YI+ctucv7NrwDn5uv0fpO4SZ9l5Rpoe6dAMY6PgBM=;
        b=qFbygqQrgnI4mlMuJUl7dQJmVmDg/TjC+ana2S2G5cpDPx17CWpNItBTGhZbpV2o3q
         YEjzWPIMZi4bjybWVFQi7EIj2BpOk7ac9T+o9c4iAma8XM7hFUMmRm9q2cPa+Q+kUb/2
         cXn+ZkePMumkhak0cMJIkgh+j2/V3yCs170sFUb+qoQx7J48fmuSuxr91grCK8VJyfdh
         nKh7M0JDxUG1Myfyc/Xxyj9G/kxxpr8RtRUKNTMqz6VaL9zB75qKxMy/mNucDacviVOe
         MSnh97YE60rkio7iL8yncfEao/cuE4bNXNme+ZqKJO9oE1nF5Rbty1ShV9zY5eoLfP6/
         0QLA==
X-Gm-Message-State: AOAM5321vPSgUBU7u5KaQuA89ui+PVeF4pgvydDpcqOdM/ae6jgdpJCS
        MSiZIOVYCtYSaTw1RV3UvBK67oIApZOY4Va5+N5tVw==
X-Google-Smtp-Source: ABdhPJxh2cdAz33JeIqRaQcjUncRMtlA6iwQLMybPHF+tEsqJirZdnfP15LtrLOnX+hjABMYfDvgNg==
X-Received: by 2002:a17:90a:b28a:: with SMTP id c10mr31926913pjr.59.1626739397863;
        Mon, 19 Jul 2021 17:03:17 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id p3sm23276191pgi.20.2021.07.19.17.03.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jul 2021 17:03:17 -0700 (PDT)
Message-ID: <60f612c5.1c69fb81.376a7.6b75@mx.google.com>
Date:   Mon, 19 Jul 2021 17:03:17 -0700 (PDT)
X-Google-Original-Date: Tue, 20 Jul 2021 00:03:15 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20210719184345.989046417@linuxfoundation.org>
Subject: RE: [PATCH 5.13 000/349] 5.13.4-rc2 review
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

On Mon, 19 Jul 2021 20:44:42 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.13.4 release.
> There are 349 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 21 Jul 2021 18:42:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.4-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.13.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.13.4-rc2 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

