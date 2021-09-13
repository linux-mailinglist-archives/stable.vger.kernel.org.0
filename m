Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B513409A58
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 19:07:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242323AbhIMRJN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 13:09:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242067AbhIMRJL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Sep 2021 13:09:11 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A415BC061574;
        Mon, 13 Sep 2021 10:07:55 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id d17so6253606plr.12;
        Mon, 13 Sep 2021 10:07:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=j5joFQfmpuIKYVq4FNGc92u2MbWnEsDplwU4rw1mhjA=;
        b=fy0vl8AmOj4s3M3DJna3FR5Qme9G9LbD00lIVLAmOdkIEWKrvYWwPtLUyG9m522Eof
         Jkl5y9a37qDWoFZqUjQay/7ozL3RXJbIRfzzbx1BFsdmyNUjml1OjPmYDX+Hhru9NIUb
         KzeFQ9Z/pI6Quoxv+XkgFcAS49Pg6Wh8kHUihnBh8pIJntXDdtLDQNKg8kcHqw8mPDaY
         EX27/6JdMuMpIrgyrms6hoJEBwZ/RW2mmN1cw8y7KJDb+N3ejsgHxlR5j6xF/xPMqd51
         39FUWYUpEpOpqVqgjdhZBCzjvJT2yZWrn6Ow0VcaaqFcwqVvk1MjaTTJu9rnTOHf8OVx
         fNUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=j5joFQfmpuIKYVq4FNGc92u2MbWnEsDplwU4rw1mhjA=;
        b=uxOClq/MGK0mI4YPFokZMxp2Ih9s6PDIuLL2NTWvSzlcK+LTGE5iZkFEwf/tbZekqv
         /m7dSY1QFK9XRvOsYpEFfO2fUjy7FgkYhmevR5ETaqmCVgMpeVBNX+cq/bOHSpK35+cF
         FUPTf/9m24EGh1CZRfE2UrUjlIof0z87WT53n9++1NCZ2PafDm+7n9uSs6MQgiFJ5Hox
         4JIDkoIr1Vb3yC/pPJ5+E8YTn2Fz6qr2BU/ifDLtqM3D3kUZHTOHdtI/TKh2kG8J6ml6
         lJtdMExxmpz/axev/eEPLwpGwfmfXTtJRcaaWfNbttx0Y9r0XifQw/Uv6l4GgNzUPvtB
         G/Rg==
X-Gm-Message-State: AOAM531Qn6RjkRUMZNB84IXhSIMW1qAurc1zSmhENMW//Z/H4PlfUUgV
        xTsp5uddqIgc4jrAWI+fabBpOmze3KuSycdQzrQ=
X-Google-Smtp-Source: ABdhPJyJD4cnJNKIDnyl48WnnxBO//vV82c/WWlcbLkyCRau4AbMFH4KzsIPcM5jp7BavzRKlHAktA==
X-Received: by 2002:a17:902:8647:b0:139:edc9:ed43 with SMTP id y7-20020a170902864700b00139edc9ed43mr11294473plt.23.1631552874571;
        Mon, 13 Sep 2021 10:07:54 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id v7sm7240512pjg.34.2021.09.13.10.07.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 10:07:54 -0700 (PDT)
Message-ID: <613f856a.1c69fb81.51a0e.45ff@mx.google.com>
Date:   Mon, 13 Sep 2021 10:07:54 -0700 (PDT)
X-Google-Original-Date: Mon, 13 Sep 2021 17:07:52 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20210913131100.316353015@linuxfoundation.org>
Subject: RE: [PATCH 5.10 000/236] 5.10.65-rc1 review
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

On Mon, 13 Sep 2021 15:11:45 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.10.65 release.
> There are 236 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Sep 2021 13:10:21 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.65-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.10.65-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

