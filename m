Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F000E407939
	for <lists+stable@lfdr.de>; Sat, 11 Sep 2021 17:58:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232566AbhIKQAD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Sep 2021 12:00:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232333AbhIKQAC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Sep 2021 12:00:02 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD2C4C061574;
        Sat, 11 Sep 2021 08:58:49 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id g16so7379015wrb.3;
        Sat, 11 Sep 2021 08:58:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gGpuh0qMHufQCawQIsga8S4zve1lMSOF8KPrtZBPitw=;
        b=mzfy4+aaNTZ3WiEaJfZZCkModRRMMdhm2Mfuz57noPBXRGOwMiUbD0rYejBWLkA+ST
         qkAMLPHYqAw/zDHecVVoeHgkGYSorQEtSO5fmzxjh2sNrkk1Rtw22oAxmK/IygDMC5aH
         2lh9HxkOuraLhdVwYaJTnVsCcRrc8cQpefmBmLrLp/sLOsv/TQirp4FuP2qBlIVDaUxa
         h/4f9yVoJuekrkmeEYU7XOjekybuqKzclWlV2x9ghiCrv/dGQSUJTQEKle/QN2PoHZ+8
         uXWUwRRenH+B+QkbsMDp3bWWaima8Jv8l6Z/JN3dIxHdtgr67bW1b3cT5jfWagGvhB95
         lE6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gGpuh0qMHufQCawQIsga8S4zve1lMSOF8KPrtZBPitw=;
        b=02eiRY8NH3RyrqIEJlvcQNsKHN3EZg/8fBosYCzQZ5p4ZJcq9VsZI1qO0FSc77n1Qx
         qK7g+6BzScgVnU03NDj3BLaOxI0u+IRJmOoanE1U1KwsTpBHlxvd0h/XRiYheSVRlQl3
         4Ns0Rk2rtcy65QrPO1moHqGZDUuLLSVEzY8shiE4EklHTk7h+UZCNctc87TYjNSGttp+
         zxORb6MrM/Byhsbm5Sc+CByw3HwQm4TR2WYmRoqUMKE7+r3kQhEfeNxZurOtxMOFLx05
         dJNQsM6V19B8Tihr3ir5g9hKDWCCnawbO0EkdUiue8UccshBy/qdeGCKSKHmMpVeI0HV
         ehHw==
X-Gm-Message-State: AOAM533BzqajtIN918qH2e0azEAYL788FDg+T78qgiKR6ctnIAfHWEbQ
        f332oDOQALCSG3n1dA6o4RE=
X-Google-Smtp-Source: ABdhPJxEq5+ypEsRLzrYNViuVb5bl7Mtpnms6ATCNn571fx1xSgaMowZQrSJGBD2AUbDqTrCDs1CEQ==
X-Received: by 2002:a5d:49c6:: with SMTP id t6mr2544053wrs.201.1631375928358;
        Sat, 11 Sep 2021 08:58:48 -0700 (PDT)
Received: from debian (host-2-99-153-109.as13285.net. [2.99.153.109])
        by smtp.gmail.com with ESMTPSA id f1sm1944736wri.43.2021.09.11.08.58.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Sep 2021 08:58:48 -0700 (PDT)
Date:   Sat, 11 Sep 2021 16:58:46 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/37] 5.4.145-rc1 review
Message-ID: <YTzSNsAPDEikruYC@debian>
References: <20210910122917.149278545@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210910122917.149278545@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Fri, Sep 10, 2021 at 02:30:03PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.145 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 12 Sep 2021 12:29:07 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.1.1 20210816): 65 configs -> no new failure
arm (gcc version 11.1.1 20210816): 107 configs -> no new failure
arm64 (gcc version 11.1.1 20210816): 2 configs -> no failure
x86_64 (gcc version 10.2.1 20210110): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/118


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

