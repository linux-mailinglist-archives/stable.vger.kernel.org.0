Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2D144579C7
	for <lists+stable@lfdr.de>; Sat, 20 Nov 2021 00:57:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234192AbhKTAAx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Nov 2021 19:00:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230361AbhKTAAx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Nov 2021 19:00:53 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 172C4C061574;
        Fri, 19 Nov 2021 15:57:51 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id x7so9105626pjn.0;
        Fri, 19 Nov 2021 15:57:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=9xAN12r6LG+eknvXTcqajOQ6nZMF1gNvv1M9Rq6JtWw=;
        b=HJUhz40bg6p86U5DysIOopvcWNPi0sPVx9MpVnQI7RtKGMQseEtgYP+NjQydZYOzaq
         fthDA3E3rBW8ix7IBwspdK78XcEUwA+qTQRGsh4rkUw++CuJVBsBhXtNBJbU/R2mlGri
         HrPWM03n0LpYcG3kahexTC/MEOkSWryVwhoRRYm5Tg62Naj/7Uy/YTHMkxePPnrGLVtm
         KBKQUQqp6Gr13buM0GmISF82h5rnGkq4+W4Kxq8rVEIQUQGsy3FAYGLmxb5HTnEMp3XM
         OZw5ampUmqaz2812WJOBpAcWBR2GztLUINU6M45apR9+dhvA65+2Mwo8EHw9h8iPRipV
         I/dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=9xAN12r6LG+eknvXTcqajOQ6nZMF1gNvv1M9Rq6JtWw=;
        b=0jl425qE4emEG7wzGx3KzNa51iQd4ZcKpo1NbL/7xh3eNM9bfUOUs6uBsKw6SfYm44
         SgKIa9OajttqDf/hhEGzXtaVSvCe7Pbiicb8ersmzK/UUfXd/EhUDH/NbaHGuLFpqL9M
         77gFKjDq/eEs0L05TX9Cy9M7x62LUiQPsPwdSLEb+746mcTpvlHBbRbxqzacudhZ6fTa
         CKdRBSkXvrXuv97oUWMEbOATNtiLgW1nJsbsFOkOQyC1ehj+V2WMB2Tuii0K26rTlGk7
         WrwiJc7T0Ts9O5Y4KYUz3r9KeoIHN6S9sCUm/uvp3zYU4qQKswLIcR+Xr2SYOw1VlQuh
         8iug==
X-Gm-Message-State: AOAM532Q2rESHqQSVvlbRyQt0ma3XzuMBaEYpU0xc8ZO5weY3aFy1XqJ
        pqmsLPcyUHF5fnwd22szDMpRpuE++BJz1gBRYRU=
X-Google-Smtp-Source: ABdhPJyIR1K3AD6craaV0U6iDcLg0TPcPSWtKmMhrzViOc54ppGWYP1pzId34kPNKaX2vp8mE070Dg==
X-Received: by 2002:a17:902:f091:b0:143:b72e:c126 with SMTP id p17-20020a170902f09100b00143b72ec126mr66382890pla.61.1637366270048;
        Fri, 19 Nov 2021 15:57:50 -0800 (PST)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id s3sm580557pjk.41.2021.11.19.15.57.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Nov 2021 15:57:49 -0800 (PST)
Message-ID: <619839fd.1c69fb81.1598b.2863@mx.google.com>
Date:   Fri, 19 Nov 2021 15:57:49 -0800 (PST)
X-Google-Original-Date: Fri, 19 Nov 2021 23:57:48 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20211119171443.724340448@linuxfoundation.org>
Subject: RE: [PATCH 5.14 00/15] 5.14.21-rc1 review
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

On Fri, 19 Nov 2021 18:38:33 +0100, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

5.14.21-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

