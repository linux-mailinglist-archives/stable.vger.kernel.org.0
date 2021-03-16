Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3601D33E026
	for <lists+stable@lfdr.de>; Tue, 16 Mar 2021 22:15:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231913AbhCPVPP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 17:15:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232778AbhCPVOq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Mar 2021 17:14:46 -0400
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11003C06174A;
        Tue, 16 Mar 2021 14:14:46 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id a17so9313593oto.5;
        Tue, 16 Mar 2021 14:14:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=gSR1wgxV4lHr115FGv+0DVvbWW0vHddXGbofPEjl1Qk=;
        b=kerB0uydCARVGA8Ej15PYphEQvSZA5SC8jcYbp24cH0ytD9tmnmQ+22zsSHE59FIB2
         m+QABXO8ILxPYbNFjCXR/XSahN+JGc10YlZZ3b/ett9NWoRq7Pl/g+rVKE/D7b8+LQ5B
         z1hxZMXv+1QvRM3O0i2kKbW6bH2xevSszfLQpVihfMJJd26Ixq7c1Kt9NA7fggfep7xE
         9zuYRBqRIL6njRlftuw7U1cnB5TT+e7T5EfH8XMksk+ubWj9w7kH0hs69X85z69C70W/
         D2g54sGnoVpj77tBR3Q+hw6I5A0kDETqI73Zx4N1qso3qT3grWOTKESLWV/lHvd34vBZ
         cuUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=gSR1wgxV4lHr115FGv+0DVvbWW0vHddXGbofPEjl1Qk=;
        b=ay2LoRdE0mcK+Gk5KXaNBn2HoRUmMzkjDistivjpsbOcj9DppyNK7sIgHkNwqIHuDf
         hunAw5wzuJucvmrVhQONjtGjzTyi1A0LIOQg8vvdOHTRwIn+tVzV5IGpJYSISvlBLUT0
         Pmmy4RWlxXflMe+ratEQw/SehjbehE6Xaly86HXH0e0FZWvT7+vvS2VCl9eEIeMYplBw
         U56tsfcinJftMTpXumUDcJOWI9NsRBWERJm7Yc5I2MOMiNNFE38vmpBvrQI684UwTs9Y
         9PZJ7x8Y8jNe9b1abBHkb5OLp8gl2wk/yUSlaxsqRrOcnfB+VvcFHaoCmj5VrVe+fF6Q
         rRjA==
X-Gm-Message-State: AOAM530vd2ztRSzdVX5yH2LFfUf8boXYojCJAcIjwYckrnOeIfuZWPnp
        Bjx0Z+jLej9/xM9Cxb8f8pQ=
X-Google-Smtp-Source: ABdhPJwv1MkRPC8XgshXhNh64/E8GrVMizVzfD4AFBo8IBQVsA+/31seYQisEr5bV8ah4F2qT3vt/A==
X-Received: by 2002:a9d:3ef5:: with SMTP id b108mr607875otc.89.1615929285438;
        Tue, 16 Mar 2021 14:14:45 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id v6sm7864019ook.40.2021.03.16.14.14.44
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 16 Mar 2021 14:14:45 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 16 Mar 2021 14:14:43 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     gregkh@linuxfoundation.org
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.11 000/306] 5.11.7-rc1 review
Message-ID: <20210316211443.GD60156@roeck-us.net>
References: <20210315135507.611436477@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 15, 2021 at 02:51:03PM +0100, gregkh@linuxfoundation.org wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> This is the start of the stable review cycle for the 5.11.7 release.
> There are 306 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 17 Mar 2021 13:54:26 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 436 pass: 436 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
