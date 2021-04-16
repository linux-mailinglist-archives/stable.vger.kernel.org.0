Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC175362902
	for <lists+stable@lfdr.de>; Fri, 16 Apr 2021 22:02:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239187AbhDPUCY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Apr 2021 16:02:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235153AbhDPUCY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Apr 2021 16:02:24 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D95EC061574;
        Fri, 16 Apr 2021 13:01:59 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id k4-20020a7bc4040000b02901331d89fb83so2692956wmi.5;
        Fri, 16 Apr 2021 13:01:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=58R3m9EghAa2bfOqkxcxnqHcgoRzrK0oqycuK0jDh7s=;
        b=G0OJZliGzIkXmYvMJUcWHTlElUiFF2cSeKFwBKZUoIF+nZQJSAAVTc6yyrc+EILQ46
         6ZmtEZtQ8WTB/zn6Hsdv/lnMGUKk0pgGqukdvkKj6n5iXWvbJ9+4JL1N9FV3kQUScG7h
         QeYRUJvJC7VX3KfJRL3Gg3I9IgPg13L+MnAWa7574GaflbARXcGcZnyYivkWAu8lIT0e
         hntce8PQdF5tUjodFBcq7iIcz2+0wJlQqufj97MELA7w5Rp6ehr73wGo6xancGD4dAHf
         0yU4vtoGiZRcJUGkUK33oSi+Z3A20j3cOYTJ1DpuDDWz9MfD24tOSH/DLPgLhqEwuhtu
         zoCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=58R3m9EghAa2bfOqkxcxnqHcgoRzrK0oqycuK0jDh7s=;
        b=inqFx7iGUospQiTDE4qSMpPKRrfNgc5NNputel+4EMG3ETCuxun0LV3Ljq/GUD56gJ
         QRVqKK889bCDOypMJ4eG8MRGC9G+0pvKWREYA34OZx52lTm6/ERNr2TNL5yRnm8+c+tW
         8Jj1g+xxGVFp8XJwPK0nfvAWM/pcmC8DFo6u+mHEaTG6OvfPHxod7kvK7M1z/GLAa4P6
         GZG74bbPeYojLST8oEMBgEjS3L9drSVZ3d2F6kgKAy/7jCNH3GaKjqlwKxg2In9R8jzn
         T5q/yp5vaSBil6pCIeV3Yy3lyHJz5pvG5rQ9ZLaQejxUNrYxCYinkKpfLCbC5OpIaRU0
         PCow==
X-Gm-Message-State: AOAM532TYzitHhOLQ3886cZND2D4FPRVPFzXvX0ZmSZKTIHiIZIfb0wh
        4wH97AeMQATxtdyPMy/2ktE=
X-Google-Smtp-Source: ABdhPJwb7h0qYf1FKR5hCf9ZSgqcFONEsv1kEO7+gOlpX/IbxRfCgu+I6WZhg6A+VqKjHjyRQTymMQ==
X-Received: by 2002:a1c:9d85:: with SMTP id g127mr9650405wme.62.1618603318017;
        Fri, 16 Apr 2021 13:01:58 -0700 (PDT)
Received: from debian (host-84-13-30-150.opaltelecom.net. [84.13.30.150])
        by smtp.gmail.com with ESMTPSA id 61sm13020802wrm.52.2021.04.16.13.01.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Apr 2021 13:01:57 -0700 (PDT)
Date:   Fri, 16 Apr 2021 21:01:55 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/13] 4.19.188-rc1 review
Message-ID: <YHntM+VmE+7wWFiz@debian>
References: <20210415144411.596695196@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210415144411.596695196@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Thu, Apr 15, 2021 at 04:47:49PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.188 release.
> There are 13 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 17 Apr 2021 14:44:01 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 10.3.1 20210416): 63 configs -> no new failure
arm (gcc version 10.3.1 20210416): 116 configs -> no new failure
x86_64 (gcc version 10.2.1 20210110): 2 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression.
arm: Booted on rpi3b. No regression.

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
