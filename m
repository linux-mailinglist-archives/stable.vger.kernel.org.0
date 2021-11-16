Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6228E452A4D
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 07:04:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238796AbhKPGFI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 01:05:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240202AbhKPGFC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Nov 2021 01:05:02 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93124C061198;
        Mon, 15 Nov 2021 22:00:52 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id k4so16432765plx.8;
        Mon, 15 Nov 2021 22:00:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=kcXMO9KgPhHRO0NDx1KZ3LZgnwUMECRLdbdAhSLAVkQ=;
        b=G43gAKWYiY1jpf2bJUu9171dMLBkEZXhuhWEtFJBMloggdNPGLFqRGYNDz0Q1KYa32
         EGokNtSKlzZ9RA6rOqmGKnA2ri4K5OJgZhf+MeXmiANECWc+fSjsMfXIv8bQ/OkEAGIZ
         rJG/8AAwaXTXeYhHlP+XoE/gJiXrllzI1aFpjXbvrK6+jZLRKNxm7Opyp8xxeQhkQiBP
         YsFqQZ6DyVcCVC2ztSVx6zHx1aGqZXwy2B4X9mk0W44ppP3tmWxOw2jOfgMEaaciPCg1
         Y2zVddQNMaFjKT3GzpacD3UjTqRjoGFciRCKxsZNsjQUwlrSbuSYpbydVMoVr0XgtPbA
         fGgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=kcXMO9KgPhHRO0NDx1KZ3LZgnwUMECRLdbdAhSLAVkQ=;
        b=3Fto1Agj+h1TN4PGEbj6beBcBF7pH4rH39UVP8WZcqnxYCZ7N59S08Gby9gwEwUKWF
         bUYVk3nlv7O5K4qUPo7IFKS3zynV50wrVmzK5QvHDldZLNvD3WKpBJrXwtOxkKg3wwGx
         I9EDM1kiiVYfUN//nf05PbiVOoi0eIXEFfSn1VbtVvl6tvLj1/NcjTRj89RaCTVrtk60
         5MP9N72gdn5R/I7N5KuyFoSJliZWej8ZkOkDCvirw4LPaCad+HINVhUoHWR4fe/xkSTw
         ocymNnAN6qLQCrw7Hht8xYsUsfuofxh58Rl9aDK82JJb/ijbj+GbAJVnlazFIjIc1M3R
         FO1Q==
X-Gm-Message-State: AOAM533ds8W3DeT6MBh///JLlo6MnYSJqH4npKpFP+f/nZ8UO1KEC0bU
        DpiTYbI+x3RIcn3cfdy+4UqfVVdkJgAg0GB5scE=
X-Google-Smtp-Source: ABdhPJxmmVoDrU7DIUhmhHoqDz0KUQ9dgdkr9KkqGJH/Hdvka/V8r9vvUU9cx8S2RUB0jyh7vr5SoA==
X-Received: by 2002:a17:902:d4d0:b0:141:c13d:6c20 with SMTP id o16-20020a170902d4d000b00141c13d6c20mr42457577plg.44.1637042451573;
        Mon, 15 Nov 2021 22:00:51 -0800 (PST)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id w17sm13302775pfu.58.2021.11.15.22.00.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 22:00:51 -0800 (PST)
Message-ID: <61934913.1c69fb81.cc6cc.6e89@mx.google.com>
Date:   Mon, 15 Nov 2021 22:00:51 -0800 (PST)
X-Google-Original-Date: Tue, 16 Nov 2021 06:00:49 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
Subject: RE: [PATCH 5.15 000/917] 5.15.3-rc1 review
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

On Mon, 15 Nov 2021 17:51:35 +0100, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.15.3 release.
> There are 917 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 17 Nov 2021 16:52:23 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.3-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.15.3-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

