Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2EE4446E08
	for <lists+stable@lfdr.de>; Sat,  6 Nov 2021 14:14:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233748AbhKFNQn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Nov 2021 09:16:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233692AbhKFNQm (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 6 Nov 2021 09:16:42 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78BB3C061570;
        Sat,  6 Nov 2021 06:14:01 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id g19so5491783pfb.8;
        Sat, 06 Nov 2021 06:14:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=TsqivY1EGi7cmGUhn/mnv4W1poD6QyUndcvI3/ttO1E=;
        b=W4FGQVmqJLKpPHYM1xJpre3Nm90UqaW3GwvoDx6lMe2nPETgKvY+w+X2TdNyxxLu3w
         w/4xt2kmUpLwlAKwM6qKNnXQZyKgl5V9gXjemSOm1Qv14sk7NFi7fx3GXVLseUar952l
         nkYkE3ybDr0JzsYgYtcGa+FJuzxJ6zVf9DLLwwvhR7y6aHHHq3MH0n9BpJaI9DkrRtbq
         XzlYVXN/a6Z2HWLOOyeG6xCR95JOLaHuWaq/SSxe3f+e75rfpDwtXtQRkNNtSBFulA59
         SJjG9n84/yXgQH6CvWuAywTKazEY88deFZvMUFjNLd5JUppIekfMW+S3ZafmSFi4H6zP
         muzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=TsqivY1EGi7cmGUhn/mnv4W1poD6QyUndcvI3/ttO1E=;
        b=Xi7kKD+0LQgZcWr70m8Lq/RbCeNAk7e4fwD8qSllbMT9pFhRw8BTymTkI2BnskyXYI
         fvrdCVjt6SGsq4R1SKukHK1bpZmiTWB/AwNaWfWuKQD4fvXJd6E4mGtbKp07USYz10oS
         TmUdHfEeUOUEH96KGOq1UPzFhDIZKVKFIqCw8/i+/KpcRemDeka6vmu4+Wa3IDmzuWol
         QKV++VU3/uAPRfZZhOxlkcdowMrEHR4qQt78OqhjuqqnmhaVBLz1DSJ+Qi8lD0Stbp64
         koNK93HMx3v/2tof5NTzwGKSj2wIfPbB6mr10bP58x48irKJ/plNPh8uoG3qXlSuT/46
         mqgA==
X-Gm-Message-State: AOAM532RGzWQbnTu+aOnuCbmvXKt6cpdKPpPVdG20zfIci1FztwPyT3M
        6SFCQe5CG3+b5ICWnQW+frxM6hEyx/RtdNs5O/I=
X-Google-Smtp-Source: ABdhPJyTRicyvyaJcuRjju2WBeKxrpGWLZ65FiZ6ArC3Nvi670s3rqXPvJ4W3dMvXfwIBsGoyLp6NQ==
X-Received: by 2002:a63:1441:: with SMTP id 1mr30128432pgu.66.1636204440469;
        Sat, 06 Nov 2021 06:14:00 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [71.19.144.195])
        by smtp.gmail.com with ESMTPSA id p7sm8036139pgn.52.2021.11.06.06.13.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Nov 2021 06:13:59 -0700 (PDT)
Message-ID: <61867f97.1c69fb81.1cf92.a0e7@mx.google.com>
Date:   Sat, 06 Nov 2021 06:13:59 -0700 (PDT)
X-Google-Original-Date: Sat, 06 Nov 2021 13:13:53 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20211104141159.863820939@linuxfoundation.org>
Subject: RE: [PATCH 5.14 00/16] 5.14.17-rc1 review
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

On Thu,  4 Nov 2021 15:12:31 +0100, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.14.17 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 06 Nov 2021 14:11:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.17-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.14.17-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

