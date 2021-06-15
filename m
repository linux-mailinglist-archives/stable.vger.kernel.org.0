Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C40C3A7B1A
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 11:48:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231262AbhFOJuu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 05:50:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231431AbhFOJut (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Jun 2021 05:50:49 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F786C061574;
        Tue, 15 Jun 2021 02:48:45 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id v9so1302230wrx.6;
        Tue, 15 Jun 2021 02:48:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Aw8+EDb4tlTTlg2lcwcTx89mdC8E/QIlF63Q9nTOmC0=;
        b=jJr8CBIjZ40kUSGpIqpT4nJQZ0x9L75LlGP3Wke+yHvE+D/OuHLz0E9l0pyJoTP7fN
         27KXHBB/xoEJB7tNVCDpXL5ABlQeZQ/atwcRYYnXamJY0wQuMbmmptcheMxJyC1N808p
         cskUSMu1ETwxnHYSBoj4Hwn65Gni9AbZz2iRP6D6RnD+zRUwMaaQdB6BqHZGi5Nybx8N
         ZQW9dkeurpfaQMNP9UXRjdy7WsXfZcRU8gBxGqv5/3bzjmZJ8OUVQvC1wHme5Q0JOPJj
         nrDRjKlnSwZ6fIfe09u4BUfA7IKQrjoOufG0CR4L/lFHMsXu9LMHUDSnKRQQltb9oBlW
         /fCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Aw8+EDb4tlTTlg2lcwcTx89mdC8E/QIlF63Q9nTOmC0=;
        b=ioKtJ5gYDwr4kVnDLGSLxKiSVKSTtC8am35xpYQfPMcLTRG7ojBSdwYRV6UnuDYAxU
         X3vcTusJMRc+bry39rp4Y1LHTmhAIIjmGrturP3lElRjC0Fh07v7A5OSwJxOMdS+p4/7
         HlN0ImtOGokcgArShYGaC3E/adG+OD/TWgtquM+AQhwPLUvJab58H23YBsj6+1phwFua
         /Dqfl+8Z26n66Yl5W5e8928jHHRN742nmpOBlEl9JvAcy6LQiYIzF5x6Zd02p1I9s3Ut
         sJjLUD/8uQF69p+QnlSxJMOSFRea8lOQQQAoIESFp37hRGj4pV32FQg0ln+zG4map0tk
         w7Lg==
X-Gm-Message-State: AOAM532LhK7IRG9UfakHXGXG69VoHZOiNI1/QN5oxu0YJkgueKbNBeML
        Uyk15oc8DHPKgnJlshbUyuY=
X-Google-Smtp-Source: ABdhPJwXQUwVVKxa21AkqDjodjHlzcKnmr4kjtLJf9jeyxC053jf6bT2t+EWG0xcqJ2yl9jgMGkLTg==
X-Received: by 2002:adf:cd87:: with SMTP id q7mr23897571wrj.370.1623750524102;
        Tue, 15 Jun 2021 02:48:44 -0700 (PDT)
Received: from debian (host-84-13-31-66.opaltelecom.net. [84.13.31.66])
        by smtp.gmail.com with ESMTPSA id r4sm19614305wre.84.2021.06.15.02.48.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Jun 2021 02:48:43 -0700 (PDT)
Date:   Tue, 15 Jun 2021 10:48:42 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/84] 5.4.126-rc1 review
Message-ID: <YMh3ehuU0lUH8lul@debian>
References: <20210614102646.341387537@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210614102646.341387537@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, Jun 14, 2021 at 12:26:38PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.126 release.
> There are 84 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Jun 2021 10:26:30 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.1.1 20210523): 65 configs -> no failure
arm (gcc version 11.1.1 20210523): 107 configs -> no new failure
arm64 (gcc version 11.1.1 20210523): 2 configs -> no failure
x86_64 (gcc version 10.2.1 20210110): 2 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression.


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

