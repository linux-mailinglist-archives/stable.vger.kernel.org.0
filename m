Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DCF742169E
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 20:36:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237863AbhJDSiJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 14:38:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234437AbhJDSiG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Oct 2021 14:38:06 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F099C061745;
        Mon,  4 Oct 2021 11:36:17 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id on12-20020a17090b1d0c00b001997c60aa29so447539pjb.1;
        Mon, 04 Oct 2021 11:36:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=5y2t/ZH+SX9ahuOyLaWvsDdmBwZwjaw92eWd0yfwnhk=;
        b=jnsE7xk7HTOpM7530Pv1ds0IKNpkvzQ1GROQ23dREEuNh5rUhdg6/vFd/ldKod4vjP
         ZMqjuqYEDRJdEz1ba2uwZN1i+7kacosh0Dt33HvNNLf/5jAu3SRl4BoEdCGCInOQL9MS
         RpNlQSfh46rPJ9aSbWaN9g9AkV6ksqcE/UjeReVVFgc9DheVxlcWmeEN7KIegCxJcgBa
         qElivXO6pE86lUevEkRh2kZYOys0ZCfbQkt5B0XfMSY4DaCtY0/rmwfZtLemiiVPnjaj
         XIzDDxKxR7Xo0HzvNu7MqwateU3cmYjLv+hxd5Naiw5K3TeNV0MLymBH/2MqaK3HWQyT
         CoyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=5y2t/ZH+SX9ahuOyLaWvsDdmBwZwjaw92eWd0yfwnhk=;
        b=3tbZ4wnqTA9HRkiOkYR4yNtk9MpbZTM2Tk8swJa4i+ycFYGWP7oCFRpvM0EjT/StTy
         6Wf6sRcbQOZLfbFl2SYbEOhGTAzOnfHBBiE3ysvrngTJHVmt7md16L0/YIRH9ddhoRRk
         T5hXIVabV6MgpYqCGY0UOe77jiedJMQyvmox9FMtIEGPFD+8iZEccwsMB6nJ+VOHyvrQ
         +VjZcCj0pfTr/4qulWnbGy44LuHdG522egVEtpLEdFVAB4Sp85hgcUnst6NNp/VpXamu
         caPIYF3S6GeF1CdtRj5G4qNjBEO/COH9s+8eQiv5sD2ByENKxyso1MRmoSySfhx2K4Fn
         +2jg==
X-Gm-Message-State: AOAM531pCB+nmJXvgfISA8YLjdcoOYYZoS3yTz6rx68udy0bN+erq2Wf
        yIFlV5DYKU3aMfKkbBjeV81IB3/yISoxpdOvShM=
X-Google-Smtp-Source: ABdhPJzihWlBiJVArNdWVgsRWufLxdOM8jmxcyHyfHQzL/9PBQeHqpmUNm67k/9yLQZBak6AU0EcDQ==
X-Received: by 2002:a17:902:7fcf:b0:13e:c994:ee67 with SMTP id t15-20020a1709027fcf00b0013ec994ee67mr1117355plb.12.1633372576307;
        Mon, 04 Oct 2021 11:36:16 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id p16sm15518308pfq.95.2021.10.04.11.36.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 11:36:15 -0700 (PDT)
Message-ID: <615b499f.1c69fb81.97f6b.d6a9@mx.google.com>
Date:   Mon, 04 Oct 2021 11:36:15 -0700 (PDT)
X-Google-Original-Date: Mon, 04 Oct 2021 18:36:14 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20211004125044.945314266@linuxfoundation.org>
Subject: RE: [PATCH 5.14 000/172] 5.14.10-rc1 review
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

On Mon,  4 Oct 2021 14:50:50 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.14.10 release.
> There are 172 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 06 Oct 2021 12:50:17 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.10-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.14.10-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

