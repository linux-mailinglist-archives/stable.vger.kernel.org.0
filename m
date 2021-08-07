Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA2193E34DC
	for <lists+stable@lfdr.de>; Sat,  7 Aug 2021 12:39:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231825AbhHGKkF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Aug 2021 06:40:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231810AbhHGKkD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 7 Aug 2021 06:40:03 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B537C0613CF;
        Sat,  7 Aug 2021 03:39:46 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id n12-20020a05600c3b8cb029025a67bbd40aso10734696wms.0;
        Sat, 07 Aug 2021 03:39:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rgT6F9Fb18vVOl521OU7qV6azJtURIM1TZ+H3/GGY1E=;
        b=QRLIoEnBBGgIfVi3wYGMzXZVQEHFOUO/PmbETx4KldYY+Ow6vbiHefeizZMnYBJiQv
         JmjDu/bNRuhzFbyCK1ISfBRV5TA9SseXomzKxsbUytT/gknKsqnXumNz/1Ozhx/JyhnF
         iz1dnLW5BC03lEtLBcgV5Hyyy/AWc1K/2JQvI0Nn9n8QlNmvY3r24jeqSgsmyTd4z+Ol
         BKFVNaw/yHObRw8maVcDlckUkaRJMPbSzJGwqJZDRZVCMDop0Is3QI4/dVJeUPco3YWk
         FEkq+rcKAH1hUlfIen5EFmJIu60SRSN43RiyblJ0+BfGKGzNVn4AhIKzSTnyBbPOt6tt
         d+Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rgT6F9Fb18vVOl521OU7qV6azJtURIM1TZ+H3/GGY1E=;
        b=tJq7neB10XJMlHr6dGLZ1Dbw+HbKRR0gddQEU9LCjlOfGdXeb+6f4lEeUFwbxBqhPS
         8fjUOe4n4dZKmA8chfT84bpnbiMO58Wnmh1P7ooiEAEOtDghycpPUVbCdbhXd/tMTmvv
         wKPOWHWFnJTOMgktLZ8SbvAXEogz/zFMF8WRRxefDZB3D0T+CHyN7XGrnW/bgEXjosbU
         u8/a79M6kYS1lJeeAmlXbtvk5Na1kH61N8U5GKoojJZMxuD+5Fm8cDu3SjHFJ02iTKJF
         bKjiAvaKRbXigxbk9es6BQnpCUgY+LMWHPFX2B8RVFCp+ljzytQRDkt/TidLekTuVj8K
         w6Cg==
X-Gm-Message-State: AOAM531TkSJ9x15XvAz4xuX8ccXCNfrPmDQ5fkNrg7E9RmDaarwibIQ3
        vM16ZVnWIMYV2rLcRdd4dCahiRFAlxxCVA==
X-Google-Smtp-Source: ABdhPJykQ9Wb/QIEl/zUMSAdDXFlp2DHuRaiUrv5o16YXSZBU2NJ22rmyf+S/nV9SokIhmW9V48W0A==
X-Received: by 2002:a05:600c:1ca4:: with SMTP id k36mr24526647wms.107.1628332785101;
        Sat, 07 Aug 2021 03:39:45 -0700 (PDT)
Received: from debian (host-2-99-153-109.as13285.net. [2.99.153.109])
        by smtp.gmail.com with ESMTPSA id l18sm2180461wmc.30.2021.08.07.03.39.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Aug 2021 03:39:44 -0700 (PDT)
Date:   Sat, 7 Aug 2021 11:39:42 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/30] 5.10.57-rc1 review
Message-ID: <YQ5i7uc3nZ19giKi@debian>
References: <20210806081113.126861800@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210806081113.126861800@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Fri, Aug 06, 2021 at 10:16:38AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.57 release.
> There are 30 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 08 Aug 2021 08:11:03 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.1.1 20210723): 63 configs -> no failure
arm (gcc version 11.1.1 20210723): 105 configs -> no new failure
arm64 (gcc version 11.1.1 20210723): 3 configs -> no failure
x86_64 (gcc version 10.2.1 20210110): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/11
[2]. https://openqa.qa.codethink.co.uk/tests/12


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
