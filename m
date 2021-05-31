Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 876FD39685D
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 21:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231228AbhEaTcC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 15:32:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230308AbhEaTb5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 May 2021 15:31:57 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0ECEC061574;
        Mon, 31 May 2021 12:30:15 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id q25so1853518pfh.7;
        Mon, 31 May 2021 12:30:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=I2yhzivGSYJwC2Jt9lkfIkUrKLXKvMaTyAMZKWM7ooo=;
        b=UUn+4vUea7q/bSqwu5h5P7rYN+t0++cugdmEPb5F64WxhFUxdMgqcg+5Io2HKqSaI/
         SNAs27u5G/eraR+E831SrS+UmVCklPVEzidi4prA2wOses/8AMPtAcKXvL3gApYCvoAw
         2s0iRz1YrQOtJOcaesuP/budC1Zq5sFO5/8eNRpblTsZoDVNzAGVaAcqaXUEwY7Rc5tl
         Tnt/QcnwsYOk5E8oWm2IK/KoMCNnPjbWsAYKKdjbotbQg5hx9s9i859hgLmPV+zDa/Lj
         8unMCUEPvt8VIF1ppJZEHTNv6MFO0Mx31rFIbp9T3NGTcC9RtZ7MMCeppa8LksJeDwc3
         VCBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=I2yhzivGSYJwC2Jt9lkfIkUrKLXKvMaTyAMZKWM7ooo=;
        b=FOuepRpjUw+1bkrtMlMrjI1gFlTefb9Obo8lSQllThQGl8dXd78tN6J1ZetXdTmjvX
         Zk8qtfNPXW3P/ZfuyRgKCCQXjZlZT5xamuEchFMapqttqfS5mtt+lqACeApKnvAPiY8c
         HhyFOLnyGrBv6lxixnQjUiU5oacJCPBMB4llEyCof7sj92u1KABhi94RH/3Wrr+MqxAf
         QOxDcE2Jn+20h+9y1vSqQODELAMprWtI4MTlidtFYVIsz68NNhNpn96bvwVJvtClxGqY
         Z+iXzyhWyQPtJXTmYbbyUEdTp2rocMhGyK4e7m9YFVEPkeLdGDCZI306kwDf2xDV0XjC
         n//g==
X-Gm-Message-State: AOAM532mxCgzJu29uy6914j4qlgAfNdCjY1OHegZmmWiYWsyhgUjcX1+
        vgN5Lu8JWE+8KsqfJtmW9tMRtN4RuRoduWSCeg4=
X-Google-Smtp-Source: ABdhPJzJL6bh+NfD86E3MTbBnzMshBap5ysb2bfxntvROnbn8j6gzVTL5+ZvIJ+uKZQfyqou9VTBUQ==
X-Received: by 2002:a63:6f4e:: with SMTP id k75mr24475396pgc.434.1622489415064;
        Mon, 31 May 2021 12:30:15 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id x13sm13210315pja.3.2021.05.31.12.30.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 May 2021 12:30:14 -0700 (PDT)
Message-ID: <60b53946.1c69fb81.ad18b.99e5@mx.google.com>
Date:   Mon, 31 May 2021 12:30:14 -0700 (PDT)
X-Google-Original-Date: Mon, 31 May 2021 19:30:13 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
Subject: RE: [PATCH 5.12 000/296] 5.12.9-rc1 review
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

On Mon, 31 May 2021 15:10:55 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.12.9 release.
> There are 296 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 02 Jun 2021 13:06:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.9-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.12.9-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

