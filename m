Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29969426F0F
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 18:35:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230228AbhJHQhu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 12:37:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbhJHQht (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Oct 2021 12:37:49 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AD82C061570;
        Fri,  8 Oct 2021 09:35:53 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id x1so7442235iof.7;
        Fri, 08 Oct 2021 09:35:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=i5ASF9rTok4Q21HGRvD0T6xRrYw6859KrV/aNTHm3Bc=;
        b=FTER52luMFX4ktX3jhA+50oVaIlxm/2YtPH8hR2Py9GNOAEXJ40AiV8sT6QLJMkXNr
         ZTPHuU7rKkKP5SS0/fDqoN4uVnfL+sNouyStaE5ieAiRJ5TJAT9QIHyjxKS3x59yuBD0
         /naqGQEJ3F69W0xfIeO81uS2TywviUp7oXIAK3gLtxvwJ6MfFDHn4vnqzXy0YCBqWbBc
         WuU4h7/e8DLadv+XRruf5PpliKy5VhxQxmlRxwPN2qCGnfxZ9Mx5j3zLEnsRAbszjtsg
         OX4yMVsuCpPSQbdNX/LBDy6wBOW6dEIA/XKutj8D02Bib1ifk6Yz+sqmjOtny7ybWcO9
         P/4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=i5ASF9rTok4Q21HGRvD0T6xRrYw6859KrV/aNTHm3Bc=;
        b=4+vUTPDHY3EB0laRCjXsE9XcZAgtLYdamKUtI0I8cGG3EZtkqzssUrhn73ddYJZaDH
         0IVMO51tDNd4IIAW/rHJ3PQZP2QKbfitiwWMNUKtBJvwaaE27lxu168IAwDRoTZ572VD
         F7v49AabC3ZUVEn84Gjm1ExSLBxl0bLG6nSg0SnzDCcRancwSHeICz0LBWZH23TVi97G
         vyweZWwRg/C4LEjksagHmPNf+8YfR6xnEZv4CmZhHKzcySc0ai4FoPlpDOSlO1fXuvo7
         3Bry7OkrL4+xkhldRyZlSLLK9lTagJ2If8+NSxfcaDmphKj/uBUoc+afoh3PndKDEU08
         j5IA==
X-Gm-Message-State: AOAM531Rvk6osFfGp9jyrGbdLH477tgbI+zLGlMWj11QT+cI86KXsVfQ
        gMnQvuIskuq1jIH2kCBPfvwEZPrbFS6WI3UDeg0=
X-Google-Smtp-Source: ABdhPJz2xjizkTGvAKRu2McI7yIZRLM2tRgUCR7gRH+4VOt4q16PMJHn0+XyDbrt7mou6p3DY16IZw==
X-Received: by 2002:a02:a14d:: with SMTP id m13mr8525135jah.126.1633710952425;
        Fri, 08 Oct 2021 09:35:52 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id m25sm1185124iol.1.2021.10.08.09.35.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Oct 2021 09:35:51 -0700 (PDT)
Message-ID: <61607367.1c69fb81.101e6.ac95@mx.google.com>
Date:   Fri, 08 Oct 2021 09:35:51 -0700 (PDT)
X-Google-Original-Date: Fri, 08 Oct 2021 16:35:50 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20211008112720.008415452@linuxfoundation.org>
Subject: RE: [PATCH 5.14 00/48] 5.14.11-rc1 review
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

On Fri,  8 Oct 2021 13:27:36 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.14.11 release.
> There are 48 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 10 Oct 2021 11:27:07 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.11-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.14.11-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

