Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 875824A692F
	for <lists+stable@lfdr.de>; Wed,  2 Feb 2022 01:26:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243322AbiBBA0p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Feb 2022 19:26:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230330AbiBBA0p (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Feb 2022 19:26:45 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C38FC061714;
        Tue,  1 Feb 2022 16:26:45 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id h12so18680772pjq.3;
        Tue, 01 Feb 2022 16:26:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=7VOcx1z2LQk1UVKN1GshLFL3aoPwBOYAHUTpT33dawQ=;
        b=g3xgkZyLby77vQpeK/xLBaf60/4qM/xPAt0hur2nFw7UTOwt2mrv1uCyKISqPPptGF
         NxfUTkUEXc2tMJOd051Jm1cO84TQQ7ybRU7d5dJ9z5fkF/7xsnFRin4yxbny/zulcElO
         5K4XhXlC7lqbHtvMAsSQqB833l01R1T50BRH0qdI37FTCx+lvEyScDafkkG5hBnSF52j
         vaPN07F0GFE1z72uORg7Pf5JGxGjN/jZv2t18u0iNHhKddLlgib1dgzeX8D3SGLhTKev
         Vf8yr6YDWzlGnwl44PLal4xXToTOxQJbJzLOMMLklUsVAyGpMxG1CT4x2pcqcbIzO8Y+
         WTIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=7VOcx1z2LQk1UVKN1GshLFL3aoPwBOYAHUTpT33dawQ=;
        b=SINDnIYzDtwXD5P2am4kynTH9LFE/wNTzI3uqDOMXxLJGgwLnuFtczsMI1CdTBIs2i
         1HlMziSC4GxrpjlbAgdMFIqIQMtmX04PLht+PH3k/1VWKMlexa0x8TMQsxHxyzz/nyut
         VvODxCWn+YTR7G/XobO5Zy4uhT7qBR+unroWOUuYMhyCXzwGnv8mEk2G/2zYhcvW26wS
         R2YCLO9N4WrfNeu8T10du00oYOovshSZXJLGrxFcBO37844mFGN9zhq7Njpkh61DMXtf
         k4LWvhgYL3uKyWJT7v5+wZr/+aYPkA0nCrT0zE5PiBgQDpFRb+uRMs1l1z0/WLHPXKsY
         GKKw==
X-Gm-Message-State: AOAM530U3ooAL9YqK6DT2iSWLxE8LfJNkVlU/hS7xogWJTSbvYzqTmso
        S++9q6682SVMpbn9Ea3VxV8BLTg7/JPZx4EyB8s=
X-Google-Smtp-Source: ABdhPJxQyEYbdz6uT7LBgYyBdxnyeBGMoJKKdxsZmccXRFVAqdje1uJIZo8aWlg/iR4JMHMdhH9x8Q==
X-Received: by 2002:a17:90b:4d82:: with SMTP id oj2mr5315169pjb.170.1643761604074;
        Tue, 01 Feb 2022 16:26:44 -0800 (PST)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [71.19.144.195])
        by smtp.gmail.com with ESMTPSA id l17sm23360760pfu.61.2022.02.01.16.26.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Feb 2022 16:26:43 -0800 (PST)
Message-ID: <61f9cfc3.1c69fb81.a4390.e1fa@mx.google.com>
Date:   Tue, 01 Feb 2022 16:26:43 -0800 (PST)
X-Google-Original-Date: Wed, 02 Feb 2022 00:26:36 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20220131105229.959216821@linuxfoundation.org>
Subject: RE: [PATCH 5.15 000/171] 5.15.19-rc1 review
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, Fox Chen <foxhlchen@gmail.com>
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 31 Jan 2022 11:54:25 +0100, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.15.19 release.
> There are 171 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 02 Feb 2022 10:51:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.19-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.15.19-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

