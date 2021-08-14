Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C48B3EC248
	for <lists+stable@lfdr.de>; Sat, 14 Aug 2021 13:11:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237914AbhHNLMH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Aug 2021 07:12:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238037AbhHNLMF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Aug 2021 07:12:05 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA2FCC061764;
        Sat, 14 Aug 2021 04:11:36 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id q11-20020a7bce8b0000b02902e6880d0accso11482121wmj.0;
        Sat, 14 Aug 2021 04:11:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=K85MX3+lPcr7rIopQpZ9SXm+IVWgA+4qf0WJLA3gIzI=;
        b=HG4/hzHdMGSBRT32UzUtf9T+XhXoZvaR+pJKXEtkIO5zZvnFOlhtWT8o5ujNhnvH56
         ansD6aSI70JkEMj71ob3CVZUl/Af4K+KaXlEpf+p19pkZz7YEgxIyn40hCQG8XQZDwA5
         YDQDTlI9rsrnjnmRlQeuvqYSjET8Zh4zlheJ0U7KneA/v7qzwbLiUP97I14CVmCg1NA6
         On9wizSamL5h5WF0aN6jYl3jyOB8qMQzatrUtH9DojeAEW/DjgJxJVkMJIe+0GwTGI16
         Ok3l2DN7RtPGbt9vfSfO5h+JcR1AkhNRySJedq6AXHl9vwPkIkOcZUqyyJCx80hCkOBK
         u7cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=K85MX3+lPcr7rIopQpZ9SXm+IVWgA+4qf0WJLA3gIzI=;
        b=owruUNG7IIzcJZc8C1imi0Hj/N6cjzZHZse+7ekcDe6x3IwdNCDMmqQyMY0F3glOh1
         +Pvk6sSwnwQpY7LuJlv8/3AfXdDDB4p3f5Z9114LLvz9wgmA7K2WmOd6SdeyQdYI5plk
         6kq5sxG6WaF1OCyHO/SCnXdNZHcLdf/LQL7prukTUN9XivjLmWf3eOeVPFgFeqU1Yoz+
         3oz4R0kB4AxBLao722lZwOe5EFFY6ruyO0XMk5hSS9BZF9equ//cVgMSJ1Wl8k+VQFwD
         DZ7joILqR0KYOlpV08lasjjn/qJ/gV5oWeAOERGGhHXOnTzE0+JpS691uU0tSM7hL4Sa
         CEOA==
X-Gm-Message-State: AOAM5338XbL2REO80pECO3jcUHeij7qC/2UDT1HTydxMYLwhiWuj9WmL
        dl6Xa8o0Bou1ue3yAC519KA=
X-Google-Smtp-Source: ABdhPJw0e183IQX8G6+WAbr5a49tl+AtBUNS/mc4WMLGaKYtz32oqZxXxUXjhCNMzmX17uG0AjQrRA==
X-Received: by 2002:a05:600c:3656:: with SMTP id y22mr6648869wmq.58.1628939495302;
        Sat, 14 Aug 2021 04:11:35 -0700 (PDT)
Received: from debian (host-2-99-153-109.as13285.net. [2.99.153.109])
        by smtp.gmail.com with ESMTPSA id 18sm4411416wmv.27.2021.08.14.04.11.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Aug 2021 04:11:34 -0700 (PDT)
Date:   Sat, 14 Aug 2021 12:11:33 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/27] 5.4.141-rc1 review
Message-ID: <YRek5SHBNSrZfy+T@debian>
References: <20210813150523.364549385@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210813150523.364549385@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Fri, Aug 13, 2021 at 05:06:58PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.141 release.
> There are 27 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 15 Aug 2021 15:05:12 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.1.1 20210723): 65 configs -> no failure
arm (gcc version 11.1.1 20210723): 107 configs -> no new failure
arm64 (gcc version 11.1.1 20210723): 2 configs -> no failure
x86_64 (gcc version 10.2.1 20210110): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/28


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
