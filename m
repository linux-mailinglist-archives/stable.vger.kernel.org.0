Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C2CA35A851
	for <lists+stable@lfdr.de>; Fri,  9 Apr 2021 23:24:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234079AbhDIVYR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 17:24:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233687AbhDIVYR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Apr 2021 17:24:17 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B0F0C061762;
        Fri,  9 Apr 2021 14:24:03 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id f12so6949600wro.0;
        Fri, 09 Apr 2021 14:24:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jp8LfVqRYzpqwlSHSbPZOHYYbrc13e1k9eXJEZuBgoQ=;
        b=aOV2sG3jquHHAcP7LCPC2DUmEkpvDprNw1lUqoXheGowRk4te7aMnNkeziwvMfstlb
         5ZU3KJVGmnAK9xIJF/ORF/0NvQl/DmQVbhRFX8NGfFSG5l0nSLV5CL/cGcOT+uBJ0Ye/
         7mFxZf70l8/RT6xSTzPoG19BGPMEGQ7E4Ymcz0JEC0i4J7oG3Nq4xhqYlp0cSJyfEvWO
         1fmmSvIG2y1aAQMGCk9rZ2ZPY/6t4GNNnFV9cvmMdxq5RV6x56OsHdmGrTWs3u29L70l
         fIGgDUfb2tSV3nOnrOQk1DQcV+IFi56yhsTV6DNd6HUFHg1c3ithPzUx8S6kbPTfz/1I
         +rKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jp8LfVqRYzpqwlSHSbPZOHYYbrc13e1k9eXJEZuBgoQ=;
        b=XIzNsXTQPD0nUJ9BxRnx8IbdXcLcOqUlXqoRwnaZ7QV7CydPMZp+WmWIS7xgOiNeBI
         6zXd2F2UjA+PH6KmSNev5JVjxtWI0FT0+yRQApXaHiJ4KpwnnAo8iaawF/uZeFxR0061
         sC5pHigpi8X8aDxzrodhL4CPkkgKQfnm+hPSsDBTrAgfz89kSoMiqUNkx2ybw5+maU6Z
         YD3wLkeAkW6jmOk2FLZi2AqF1J0WQo7wzldALhJqDJyLp+bd8T1P+sWV4QNe4/F40yUJ
         ZKRanI24x0KhfpIjSrEIEVhtfQbmhbbkp7AVF+hMqTYqJn/QDhBCnk+XK9mOKVRa62RM
         k8Dw==
X-Gm-Message-State: AOAM530hiRvhwPtGK3RjVz2WLxzfILm5YL04K0755GYy/Cnr2tz8GgQu
        RyQZCkXpIt2LdwcvD1d5a6s=
X-Google-Smtp-Source: ABdhPJzrXts7QCdBZoUyCK+CQ48U1nFo3QWT/uevzPXPW16nY0kiMSRanzoINwbyhGyipW4Iel/EJA==
X-Received: by 2002:a5d:6a08:: with SMTP id m8mr11836607wru.57.1618003442389;
        Fri, 09 Apr 2021 14:24:02 -0700 (PDT)
Received: from debian (host-84-13-30-150.opaltelecom.net. [84.13.30.150])
        by smtp.gmail.com with ESMTPSA id v7sm5653757wrs.2.2021.04.09.14.24.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Apr 2021 14:24:02 -0700 (PDT)
Date:   Fri, 9 Apr 2021 22:24:00 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/41] 5.10.29-rc1 review
Message-ID: <YHDF8F//LLoXDoHU@debian>
References: <20210409095304.818847860@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210409095304.818847860@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Fri, Apr 09, 2021 at 11:53:22AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.29 release.
> There are 41 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 11 Apr 2021 09:52:52 +0000.
> Anything received after that time might be too late.

Build test:
mips: 63 configs -> no new failure
arm: 105 configs -> no new failure
x86_64: 2 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>


--
Regards
Sudip
