Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DBE23A6E80
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 21:03:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232975AbhFNTFJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 15:05:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232864AbhFNTFJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Jun 2021 15:05:09 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 109ECC061574;
        Mon, 14 Jun 2021 12:03:06 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id v11so7101275ply.6;
        Mon, 14 Jun 2021 12:03:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=c4vDBA2pQI9Hg281lK4bF+Io/SUS60zAjWWC6JvvRXE=;
        b=NswVS50DD9YLApfMNsn5nSEXFv646/tKu6pvUkAT6OsPE7nal5U7C0y9KYAXiRiaag
         snqXGiJtB/wtr7zUuEPRUZEe6pth+IHd0ZN3s1pXWGHWZN7pcJ3pZ26GLqVlGKKfzCIu
         B+tFIcbELehqu9vkbkByBamZ0DTlZAJ8d0DcZ3UyhuaEKOcRQPaHpxdf2DXEzcPhaHKW
         Dgj5SlccUckuercqnVF4ekTfOQs81WYyzIG0XRKPalcCYumQYYeeqLF2Kgg0eEWiFBhj
         qvV5E/3IshlHQ8629wRcDL/Usj4CsKQgVrHwQy06YKFFrbFH3Qn8aVf6Cf7JrR0v/32P
         zObw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=c4vDBA2pQI9Hg281lK4bF+Io/SUS60zAjWWC6JvvRXE=;
        b=SiishmYv1g8Fa95LXlqwQiExekofJcvHSX0EKe5GSuH7d3NSnez36Jm3gO5pfPDW42
         KPBpQGzRGKKTEtJVzjX91QQQpqzVawvYESJ65nkHosLDoGQz8hFEgB+zq2+4NSEuUYxV
         qpS4WYsRN8a/uic1KRFQoj1KUuKct8hnDqjprcFy6WvXg9FZZR1cpPCZsRe8a/oTGjwz
         YAQus6ZmA3pTTn5ASyextiR3nFaLx6oQosa3yrW31HCglBhoxcpJgJuLT0KkRyd/ie0J
         UypKhbzlWPAC7byF/644vV+o2j27jxF+EVA5bOU3l0if4BtX9WBQFCLYn9VcvdW0xpmb
         bPnw==
X-Gm-Message-State: AOAM533PZj/QeLLcL4Yd6eG5HF0f1VBYkD7bXovpVHdiub5FH5IsuIpT
        fPm3rBzsUoNmnqZnmSEnbN7ecdwB3D9RexRyyyOJ0A==
X-Google-Smtp-Source: ABdhPJwYdV1RMgyR0GrTbSErQ0r24XMhXLrfv5d4AnAqv0tjOwrvJZ39OXgLsLsrXj4CBzrwIeZLig==
X-Received: by 2002:a17:90a:6286:: with SMTP id d6mr624299pjj.87.1623697381872;
        Mon, 14 Jun 2021 12:03:01 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [71.19.144.195])
        by smtp.gmail.com with ESMTPSA id d15sm186287pjr.47.2021.06.14.12.02.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 12:03:01 -0700 (PDT)
Message-ID: <60c7a7e5.1c69fb81.a4ca7.0c60@mx.google.com>
Date:   Mon, 14 Jun 2021 12:03:01 -0700 (PDT)
X-Google-Original-Date: Mon, 14 Jun 2021 19:02:55 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20210614161424.091266895@linuxfoundation.org>
Subject: RE: [PATCH 5.10 000/130] 5.10.44-rc2 review
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

On Mon, 14 Jun 2021 18:15:07 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.10.44 release.
> There are 130 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Jun 2021 16:13:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.44-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.10.44-rc2 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

