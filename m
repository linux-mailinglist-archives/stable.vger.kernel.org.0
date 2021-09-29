Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F5E341BC0A
	for <lists+stable@lfdr.de>; Wed, 29 Sep 2021 03:06:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243510AbhI2BHy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 21:07:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243507AbhI2BHy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Sep 2021 21:07:54 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F171C06161C;
        Tue, 28 Sep 2021 18:06:14 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id y186so979548pgd.0;
        Tue, 28 Sep 2021 18:06:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=4u5jHWkphS+4/JlRddhWTaO63sDbl3kV/Zg7ml3V04s=;
        b=I9d9KlQDlyulIcRQZFDav5vMjJwO5wqdXf4y6ziRYo8UGLIVaFFHhlfUfp3xUp/A8f
         /LQoXcB+iuwx+jbbVZHoB3WtI/2RoQvyy1CBmVaPK2QE/+eF1NV8wuR/xFDld3tWYHZy
         eL/EJksWaKMh44tYjh6bSmMCOtgZAQqb2c+SRuSqqHxr9LhBSZ/hiw/Ka4l0g3e1gHEX
         KY4E2rywN3yNC40qRIQFXdBn3KOENP7eMzePVP1I6w4L2FjDWiOlE6cGbNyyFQi2cYPD
         gOSRq2KvbYzvjORdJvfsqNqEABnVBUCgphOgyDO2tpfIy46eR+U1Smy7g5FymGoNDZvz
         JgZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=4u5jHWkphS+4/JlRddhWTaO63sDbl3kV/Zg7ml3V04s=;
        b=1Tt+9O5ha5QXvagDKyq2lnn5tUk0FVNjEZlFVoVBo9R+/CBrXTSWv1sN1HRjVPPtYL
         SlSDqOTjj0POd3q+uOVsi702R50v/uHXiMRBvBkHos/QXaNj+92jzzhOzWf3Z2tJeTeH
         XrPg+n9Q54JTRjPY8GiSEcExujSZiqUilPe9uoDow35jMSJkzsvOyNnimudAJLxaOZ45
         wTm5j+ZsGVl+TEBji87FS7wb0XQRYQFQ0yYAFXutZAgX2yTH5qL04ML2QScNKsRhDPdT
         Lki6RfgFB3Tdb5buerxk2nA6CAB/whTPG+H/x8F1m/T05CflM5mq6o1eitcvRKiIS/fN
         U0bA==
X-Gm-Message-State: AOAM530/cBHpjAxraxuZcs2OYMvUossnX7Xzgmj2Am9eoFHFoY8sbvHH
        K3KaTKz8DNZMwVbAJc3ynb/S2vV2IcFMIKvwQpg=
X-Google-Smtp-Source: ABdhPJygO4MpCJirEcablYOpzJJCF5P2kD1/CTA7agqVzJX+ZlvQ5CetqEX/GZnW+RsW7H/ak6ub1A==
X-Received: by 2002:a63:b54b:: with SMTP id u11mr7212880pgo.163.1632877572951;
        Tue, 28 Sep 2021 18:06:12 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id p3sm301429pfq.67.2021.09.28.18.06.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Sep 2021 18:06:12 -0700 (PDT)
Message-ID: <6153bc04.1c69fb81.8a6de.1dd4@mx.google.com>
Date:   Tue, 28 Sep 2021 18:06:12 -0700 (PDT)
X-Google-Original-Date: Wed, 29 Sep 2021 01:06:11 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20210928071741.331837387@linuxfoundation.org>
Subject: RE: [PATCH 5.10 000/102] 5.10.70-rc2 review
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

On Tue, 28 Sep 2021 09:18:56 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.10.70 release.
> There are 102 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 30 Sep 2021 07:17:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.70-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.10.70-rc2 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

