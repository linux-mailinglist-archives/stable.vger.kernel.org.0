Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0379401DC3
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 17:50:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231390AbhIFPvF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Sep 2021 11:51:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231359AbhIFPvE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Sep 2021 11:51:04 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01C6FC061575;
        Mon,  6 Sep 2021 08:50:00 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id u13-20020a17090abb0db0290177e1d9b3f7so4525020pjr.1;
        Mon, 06 Sep 2021 08:49:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=TuDe/riw9YVR+eY57Bb/egxHV7sRrGLSN2rFO3UOF8A=;
        b=JFDrYEBx2UuD8UHurgupeg6IJHWYx1TaKLEAUsJooxo+web+ESEZxTu9lQ6k2B1oVg
         pVdvtbx7ataW/0rVSErfuQCsGtY2FkV1fcSu3/bFbKCn1EXVbheoM4GHevsXf5skUcDT
         1WwcuICoIZLL2FUN38ClErezeJUkp1IsFA9598wcCeKh70/qk0TyXgoF/X16dJs3AB5B
         kBDwkmN5MUx4pfXuCjoyAFKbPE2z8oDG08MOao0NsnOULKXB1rwTGxBFNJvlKQ5gWnaq
         cCIruhRk6AVDk6x2La0HaPExSQ6tR6JRGqVtJuFXwcFim+QDvaUWTWtYufFHn2Z8kQ7p
         Ks6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=TuDe/riw9YVR+eY57Bb/egxHV7sRrGLSN2rFO3UOF8A=;
        b=Ov97TxLzjTtAe9yg0rIlG5oa3yITFI6Q60kFwR9IsGTZiJ36tDvgjur7/1GuTEyRqo
         ylcTMLeVGnawNupFafdjtvBT/Xv5w4kZDNlcF4m4EY6xFqP6qS9cpGMEWVbzjXV9bWVZ
         Ot733185ulMlFQpYgESEWTM0ZGbd0CEB2f0o3jrv0ExRBaGYnu3THFFyCSEHF9Gdbx6K
         CmmHLR9EJ6y5ck8uNCybhm2MljloOCuP45ojQiuxNS/i7lbE0p07p4IATZ73xsJR/aui
         IyIbIp50GNGF6MmnmK9U+lfdBD4Q3a+E0tfER9pCSm7Qvzo7uFKqqncjmEAj5sIJ1Jn1
         tG8Q==
X-Gm-Message-State: AOAM530aQgUkRqoKwP49XKGtFg1OJWzEpEWlVm8n395ISOR9Nak3nzZ5
        nmWV2HH9JqBHI8aYoxnr3xhhuZiW2KEKQa6E4/0=
X-Google-Smtp-Source: ABdhPJyb7y1vH8OYI2yUTixapJtBbLAyAE+bH0TLgpAS8sawKcFla6AEEIsjTjWpwfIodjCpiK1Z1A==
X-Received: by 2002:a17:90a:a791:: with SMTP id f17mr14570407pjq.225.1630943398932;
        Mon, 06 Sep 2021 08:49:58 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id r23sm7774499pjo.3.2021.09.06.08.49.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Sep 2021 08:49:58 -0700 (PDT)
Message-ID: <613638a6.1c69fb81.e54f9.5131@mx.google.com>
Date:   Mon, 06 Sep 2021 08:49:58 -0700 (PDT)
X-Google-Original-Date: Mon, 06 Sep 2021 15:49:56 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20210906125448.160263393@linuxfoundation.org>
Subject: RE: [PATCH 5.14 00/14] 5.14.2-rc1 review
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

On Mon,  6 Sep 2021 14:55:46 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.14.2 release.
> There are 14 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 08 Sep 2021 12:54:40 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.14.2-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

