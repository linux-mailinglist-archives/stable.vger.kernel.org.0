Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A97354072A7
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 22:43:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234069AbhIJUo3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Sep 2021 16:44:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233384AbhIJUo0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Sep 2021 16:44:26 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DAA2C061574;
        Fri, 10 Sep 2021 13:43:15 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id u13-20020a17090abb0db0290177e1d9b3f7so2352897pjr.1;
        Fri, 10 Sep 2021 13:43:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=R4w85zjPqPgM+LRfwktg9CkrDzxslzluVbcge0FkBFY=;
        b=YNNOuL7eSsrf7eoHStnzjI4Th8V6QfeagWnRR4gXbFsA1RdjEJu/iYsMCDq8spGSuf
         VqV+5UAHDpWw/wB5dxTqdNx8/5scNgRq+lX5DEpTFis+xyqpoX1ApwfY8stnDBZNlTNL
         6Q0InQNk/8ObjKttJ1HMF6N0nXfmlX0duQQFA1my+7i+cvFGuxD1UXVPhKjT+/493FLu
         vSjmEpWaY5PNchhPRNxrMTwhnPpdtXxs5RNhFly+AzUOoAexh+/MvGqXwFTfbzNtHZNR
         TxpVlnDjEjNvcmZbhaR6hJoVUDBUlN6RywS/QbV5sdgHyIWWGNcEUFg1T+Sh9nvFbJhj
         /Dkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=R4w85zjPqPgM+LRfwktg9CkrDzxslzluVbcge0FkBFY=;
        b=IExek+O3H2m9Akia1eWpd3t+CDPYfM6lZHLXatr+z3hBL8FK2rf2gHTp9+/PBb0hXK
         4E8uxAuCbVFfXdG50APWOlhQgDgZPXWAo9V2f5f9sczRwIyTiOge6Wc78qTubqUuXiXE
         aWn0NzCFX02DFioBE9Mpict60tbqzppAOjwfBEw1BvLx5CMkZam6YbrSd0DzzHGjd+as
         79fujux19kXwTXRGHv7zsSkrCGFFNLjUZnoPG/pkD18+PQWjxOEJ+uuKPo+pWniwJsgg
         r0zTJHIzyNJFUTaAAX89BR4SL/2lo3addcxzuPaNcR+8oPO5n3UmsNcZEkwQd/cOTUGI
         Nksg==
X-Gm-Message-State: AOAM533VE/PYsmMULvpEBQxuEwOouYUNQsmaZYId0NawM9WK/vEkb1Np
        lP3N+NigPMlMGBhCPs8jk1VEaNvlfFBUzWPA2Gw=
X-Google-Smtp-Source: ABdhPJwS+eboeogCPLNYrFYt6F/79NRKqWDN1AAOczEeH0Cx7DAHjzZZd9gQugEMxgrVrrKyz7OMfw==
X-Received: by 2002:a17:902:b696:b0:13a:7871:55f5 with SMTP id c22-20020a170902b69600b0013a787155f5mr8168928pls.60.1631306594121;
        Fri, 10 Sep 2021 13:43:14 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [71.19.144.195])
        by smtp.gmail.com with ESMTPSA id u12sm5955383pgi.21.2021.09.10.13.43.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 13:43:13 -0700 (PDT)
Message-ID: <613bc361.1c69fb81.3f2e3.19b1@mx.google.com>
Date:   Fri, 10 Sep 2021 13:43:13 -0700 (PDT)
X-Google-Original-Date: Fri, 10 Sep 2021 20:43:07 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20210910122916.022815161@linuxfoundation.org>
Subject: RE: [PATCH 5.14 00/23] 5.14.3-rc1 review
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

On Fri, 10 Sep 2021 14:29:50 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.14.3 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 12 Sep 2021 12:29:07 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.3-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.14.3-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

