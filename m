Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FDFF4742E1
	for <lists+stable@lfdr.de>; Tue, 14 Dec 2021 13:46:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234121AbhLNMqs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Dec 2021 07:46:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234109AbhLNMqr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Dec 2021 07:46:47 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 666EEC061574;
        Tue, 14 Dec 2021 04:46:47 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id k9so14392124wrd.2;
        Tue, 14 Dec 2021 04:46:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9qy1VNVIFKw+ocL3V2E/XyDrE1EQU9LTRbECYyMNW0o=;
        b=D+nT70GPGcQ061wU0NNUqdVmRJyyJkgnVlfRd6Wp9n44Ih/I7rLcW433d2f6tcDzIl
         2HOEm2wLhmoo+hO17VSNF93lBiK3aOkO79O+8qhOKRIWU8tDV/pqAP4994Q3AtA+vFRJ
         /jYA+P7m4q6ZMtUrKaWPN8ZTU8x/LSNDUWSWNEyx9Ey+V5A0RsCVOH9moQuNs3Evkh9k
         cgca2TMRFWT5QtuW8oY2PPblhMhYdS6Kq+48AhxRy81fYXiYg4erK0eRkkcJs4bon67o
         ospZkKpO3hJ5+iSyYnbuhlouQInE8yt4Vd0lCKVyXwSQTgn+LyWcsWsmbTp+w/hHLMCX
         mFHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9qy1VNVIFKw+ocL3V2E/XyDrE1EQU9LTRbECYyMNW0o=;
        b=ZRmRnyuZb37SVfrThruSsqS5hm+m7QypfrM0nCQAy3CNfqraey94DcDE5dcjcMLd3U
         /SvE21APAlPdashkUOjM6DhHorFdnTnDZHt5pAF2/cMhfht7vu+EzIk9log+deAJVtq+
         zeEtGJcbToK3LlCrwmu5ITtF43Qy4GE4NJ+xO2wUd1kVcGQ905Kznwbv0LwXR6dmPFHS
         10uagUdTq17ucXqlMmQ6Qxxhw46BfRKC0fIaUiDf4zhIjN+cFwV6tkIh94g9FjAz21Z+
         QbniSBtHiwRf0y4mD6lwTdmh2gAa08B1n4RIGZdpnsg4eXhHEdOn5XEWS41GbV7z7Srw
         z5FQ==
X-Gm-Message-State: AOAM533Ylh80azgaOiDFV+FVbuIo+tMD1ONiX4WGFeYsL54GvmFc3TK9
        ADoMTcYB8YjZaOGCrXtlryA=
X-Google-Smtp-Source: ABdhPJygCJuY9SazvNGLL+Ac6ObNwJ+7HZbCcMsdIt33BheTWB8NbAn4DPA76rN1RcYWGx+8KcL62A==
X-Received: by 2002:a5d:64c8:: with SMTP id f8mr5545179wri.435.1639486005936;
        Tue, 14 Dec 2021 04:46:45 -0800 (PST)
Received: from debian (host-2-99-153-109.as13285.net. [2.99.153.109])
        by smtp.gmail.com with ESMTPSA id h15sm10672938wrt.104.2021.12.14.04.46.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 04:46:45 -0800 (PST)
Date:   Tue, 14 Dec 2021 12:46:43 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/132] 5.10.85-rc1 review
Message-ID: <YbiSM7xrgEp08hfo@debian>
References: <20211213092939.074326017@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211213092939.074326017@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, Dec 13, 2021 at 10:29:01AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.85 release.
> There are 132 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Dec 2021 09:29:16 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20211112): 63 configs -> no new failure
arm (gcc version 11.2.1 20211112): 105 configs -> no new failure
arm64 (gcc version 11.2.1 20211112): 3 configs -> no failure
x86_64 (gcc version 11.2.1 20211112): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/509
[2]. https://openqa.qa.codethink.co.uk/tests/510

Note: Initially I had lots of build failure in arm, and I had to modify
my build scripts to disable GCC_PLUGINS for all the configs. Might break
build environment for many people.


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
