Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85CB43D4516
	for <lists+stable@lfdr.de>; Sat, 24 Jul 2021 07:22:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbhGXEl2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Jul 2021 00:41:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229730AbhGXEl2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Jul 2021 00:41:28 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BF96C061575;
        Fri, 23 Jul 2021 22:22:00 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id y200so5117215iof.1;
        Fri, 23 Jul 2021 22:22:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=YrKVY9DyHgwqRMMdVNrCbNG/w4+sk5CKWWsJcs7NxLA=;
        b=Unp6Z3C35/AL0LkPbbRC7Z3tLtBcmaDZbsYcbD/fJCq/FAmeDK4nzYzRyX3+TZcKBR
         BDRf/8iR1Mn9ourZFLC+TkSHrRUzyU7IksV5v7iXajyx7E9Z2D0cmzPAijCRJNxX+iF2
         JQ2fLYY7fpHF0Lh5AKdE9nTklZheK55bUv61D9+fPi57gOranFiQXivpk3f1aC3LzET/
         w5MG7vI47gLDt64+2cKUjW+4t4IuOaWyP3sWkuoxKrClaQ/ZUB9hTKO+xflCaXqg2hX/
         ZhRZNOmwKVxX8+MKeFE7y/CV2CCYO/MEw5LJlp6myJQFLuJDzE939FPmnI+/S0a697Bb
         XynQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=YrKVY9DyHgwqRMMdVNrCbNG/w4+sk5CKWWsJcs7NxLA=;
        b=VjoVGnIokMM8BAHV2ITpkaBGROiAx+hSfV0kRejxTHrzv2jUMg39PZUBkMfVTktjNo
         exNhll7LBPvdh1xzNPUwz6mveVq7XW60K1pZQJirnj4u6Ulfp1ipWjQVZ3qO5kgNme7T
         kROXheuu8JnFAdjbXR1swbY4nr+vWZsakQPiR0nox6jA5DtrJaKkCs6t5Fgj09gMzSLZ
         ncPdHu4pN5+tYFsTr8Kxj+GCtEs+efgMWQrq9ZMJ1uOeiUYGvE5TZScUXKHrwG3+Ar71
         171o7IYJ5+Rjke/SKrRbO8qT3Gkz3U0vrpqjUQSSpOkk0+aYMcY39mbPRnn9mPk8wVAB
         pqDQ==
X-Gm-Message-State: AOAM533cTGTsI40iekZzWtSOtFHgYJnItKrSbz6+VEhvxQ7V2xOvhFXq
        YIHNMB6THDXki88P25DRI3Utzd+1AKJRyUzw8Qc=
X-Google-Smtp-Source: ABdhPJxkCwcaBPNjbMxwZpOpXWwryikr8jSYa1xPttDIRDYwJmYtuS4HakxJN4DQBiv5EBLwXfU5wQ==
X-Received: by 2002:a5e:840f:: with SMTP id h15mr6467513ioj.93.1627104119153;
        Fri, 23 Jul 2021 22:21:59 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id w11sm19208155ioj.47.2021.07.23.22.21.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jul 2021 22:21:58 -0700 (PDT)
Message-ID: <60fba376.1c69fb81.3b1cd.fdd5@mx.google.com>
Date:   Fri, 23 Jul 2021 22:21:58 -0700 (PDT)
X-Google-Original-Date: Sat, 24 Jul 2021 05:21:57 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20210722184939.163840701@linuxfoundation.org>
Subject: RE: [PATCH 5.10 000/123] 5.10.53-rc2 review
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

On Thu, 22 Jul 2021 20:50:22 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.10.53 release.
> There are 123 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 24 Jul 2021 18:49:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.53-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.10.53-rc2 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

