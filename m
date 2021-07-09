Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3F723C29E9
	for <lists+stable@lfdr.de>; Fri,  9 Jul 2021 22:00:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbhGIUDB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 16:03:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbhGIUDA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Jul 2021 16:03:00 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30392C0613DD;
        Fri,  9 Jul 2021 13:00:16 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id y6so10523868ilj.13;
        Fri, 09 Jul 2021 13:00:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=sq/c7pBmpsPdXLFCGKtcaECE0EhoU6nh5mlaTywOHLY=;
        b=iyrIEOLLoBYwvE+N3N5pcYpzLHDfHPNd+IJEbjZJoK1CAwzoMh7tsDmRXumdWxFeee
         edP5ufZioEBfRnKrlig5yh1hmWR20rlcQ6dNNbKM+vA6Z/8tgHLSr4mPoNtRSLlc3drN
         iDWgwJhwYGf7C8Vj0ds49JYdzdShXqBcbg2IJBMVzofuGsz3VmoJHLzIE/Ak94oW+z2u
         W2bvSkZWk3cmBaChmpZxxhO7OmIh8xDhlBPGNRSl4dQtBz6ogH2Gf7MMEuhM1AGOXVAk
         Ieq64w76TFgH8FU5bzrRb2WapWe+tE9fWaw8XQtpKgmtNs18TR25jkQl+9FjDTIf3eDI
         iUeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=sq/c7pBmpsPdXLFCGKtcaECE0EhoU6nh5mlaTywOHLY=;
        b=X9KqgYfKgHm/vBXikxdBJyCOh4AP7Du96+JFrTL0MXmCXeLdKdzs0Nxd0JLRgMbbR7
         kN71nvqh6SuLaZ8MMnfkHQdZruWjsSmDaMMvrq+DnCUesy31a28Sg49O9T2Yz9GpNNEl
         j3mrLiObHT/Gk3LQrD7rdoM5vJpyhFx0QN1/R6Klfp83eGWL415wLRqOZVa1CqUb4Q1F
         2SkzDqsvHKEEizdo+G8dL8QcJJL7+o8ck1Ti5x2WbE4Cy7TIkV8UfzaIOVaCneABjE4I
         P5Tbi5HPic5Fmdc8tk/lNASESN92AQmow/IwbwJ6k+u02kAbqVVth9trIpvI3Vyw1hF0
         7BSA==
X-Gm-Message-State: AOAM531ze+Uv7s5W8ljGY7kHJLRuFmCiWYiOe7kYKy92iWgicvxXea/c
        Lt8uUXYFcMwsUdzMGUWweEVZNp+r+IEyNk53BYlzvg==
X-Google-Smtp-Source: ABdhPJy36mj0Z2W7FZjLfF2OBcX8xRH/fPoklP0iyRcnae8zlRFy5frO5TeWnzfMbykS7kcaUO6q4w==
X-Received: by 2002:a05:6e02:1527:: with SMTP id i7mr13493082ilu.134.1625860815224;
        Fri, 09 Jul 2021 13:00:15 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id x1sm3254165ioa.54.2021.07.09.13.00.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jul 2021 13:00:14 -0700 (PDT)
Message-ID: <60e8aace.1c69fb81.e3e34.5ecf@mx.google.com>
Date:   Fri, 09 Jul 2021 13:00:14 -0700 (PDT)
X-Google-Original-Date: Fri, 09 Jul 2021 20:00:13 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20210709131537.035851348@linuxfoundation.org>
Subject: RE: [PATCH 5.10 0/6] 5.10.49-rc1 review
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

On Fri,  9 Jul 2021 15:21:09 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.10.49 release.
> There are 6 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 11 Jul 2021 13:14:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.49-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.10.49-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

