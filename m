Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C876240209B
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 22:05:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244553AbhIFT7x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Sep 2021 15:59:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243833AbhIFT7x (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Sep 2021 15:59:53 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E5DCC061575;
        Mon,  6 Sep 2021 12:58:48 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id f65so2773975pfb.10;
        Mon, 06 Sep 2021 12:58:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=K/zi3SRij0ZwbFauXstuSogN5mpzJFji+sCXGA2JmXA=;
        b=qIIQKoJTMVH2Pm9srwabvihDh/6nz/ud4VfzGflUdNO7x9qqcZztnO2LZ0Jh7yedae
         jjd+MqYYkzJ6CWvWNwjFjxMag1XYAWeKZP27BF9BT6oFZ2jdBvaFKxHg/eb5Gu0FfF8a
         i7zXtW385EcT40f8pqm/UDrbETX9wxvMC6huLSqor0kD3z9L4ZiJOYHgC9LU0owDGPjs
         iAbGDKYqQN9tbCIybsJxWf954AkzpZiQHljJs4OrRKuw9iu21ioG16q89YzmAUQiSMOg
         7vg91WiQvQx5BLBiKIXYk5pAzXwd72WiTY3ht5wrNOSucvkNWI+bjmds9yujlA9UHt6A
         ORLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=K/zi3SRij0ZwbFauXstuSogN5mpzJFji+sCXGA2JmXA=;
        b=jL6213YAuiu3dxsuAE9HtlTyIexDaepSpA/yWFYQ5BlO5rrjn5iqEVE4pr1lD0C9cO
         JZtKKVYgMO8rIUwmCcrHWvVRF6DX582mqpaKazNuUOFpfQDfmanQiP7SXVsr5OPZcOyh
         bkVRhmOIF98cyil4rvB5XfV0Wtldnzh2mQCoquYT8ZXj1TIYeAT0tJjZUEyfN3/2wmPk
         SD4AStRDej5zUJ6Z5OIg24m8c2QJ+VNcNTcNTnwYilvOkaow8Bchow0yt8zhi1OCkv54
         jDq4sYWa++FC1y+Xe58DOj4zD2H5adeAlIK/FFjYGcqFtQC1a0cbWZN4DtpYi0YCtXEr
         Ef9g==
X-Gm-Message-State: AOAM530buTamGoI4CoqcPxfDJpnM8mpCWrPMAcy7feAKOLe32zpoUOnV
        HjmtjcF/ebHDJBnEmmB0VNv3R1B9bR+ZZdPjGj4=
X-Google-Smtp-Source: ABdhPJyhUmvWIHCSZbwWtjVTYZPCYA3vHCPeC7y4EU9f9t46RbJbqNDHKiKgJnVqAZJnlL3bkuIxwQ==
X-Received: by 2002:a63:4f0d:: with SMTP id d13mr13598121pgb.169.1630958327135;
        Mon, 06 Sep 2021 12:58:47 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [71.19.144.195])
        by smtp.gmail.com with ESMTPSA id q21sm10170099pgk.71.2021.09.06.12.58.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Sep 2021 12:58:46 -0700 (PDT)
Message-ID: <613672f6.1c69fb81.20894.d917@mx.google.com>
Date:   Mon, 06 Sep 2021 12:58:46 -0700 (PDT)
X-Google-Original-Date: Mon, 06 Sep 2021 19:58:40 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20210906125449.756437409@linuxfoundation.org>
Subject: RE: [PATCH 5.10 00/29] 5.10.63-rc1 review
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

On Mon,  6 Sep 2021 14:55:15 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.10.63 release.
> There are 29 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 08 Sep 2021 12:54:40 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.63-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.10.63-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

