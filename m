Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 254094A2AE7
	for <lists+stable@lfdr.de>; Sat, 29 Jan 2022 02:13:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344781AbiA2BNY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jan 2022 20:13:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229812AbiA2BNX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Jan 2022 20:13:23 -0500
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A663AC061714;
        Fri, 28 Jan 2022 17:13:23 -0800 (PST)
Received: by mail-ot1-x332.google.com with SMTP id x52-20020a05683040b400b0059ea92202daso7385856ott.7;
        Fri, 28 Jan 2022 17:13:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TvSgxFQLEA3VYnk/RTIhM+140VXw0EmF4baQiPYNGbE=;
        b=fCzxLwpkdEbkuOh/7bUZbWfw0G6UGuEDUSXt3FgxT2X74jE+DgjqsbdM8ASebPei1F
         Tk/8S99oI2lZMv/acYPSFpNsnCQr1Wgbtn7uPMM+a5y0hgyDmit65xTcNFeGe3pTbKdk
         DCRITMxbDESDswlllDmT94eVT+9e/18YqhZMQ6zLCZsQulSbh4TTxisq2IrVkWV8Hpo3
         M4ifUK2Sv0ZtaVv3Va/vYzao9S5VsLyYWzLlLjanz9ps5+mEi1YrPWSpufBcBQfecFxb
         YdZiGqq66asOFspTHVIyTqPNLaBFUA0hSBRC+NGheNTP6lr/mF/17FxsZX19VyaD96VL
         l8gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=TvSgxFQLEA3VYnk/RTIhM+140VXw0EmF4baQiPYNGbE=;
        b=tlIlHgwe12IiE7Y9JBqDsTl4T1PhWP/d+svdKdpb9cONkNDiPfEaTxQMpOBYHkmnrX
         OP4N5GZnUfgzLTJet6J0sIAtJEORBpfWSn7iD1Tn6w8YXBsL6BsMuzT80n+KUqpMZ4Gh
         uQBi+LPrbQGxZ0t2/rdQrj94KZ+EAYiq9MdWadRrJiK7xd9QkKDDnDvqF9Ri1xVe36p2
         pdglT3f+sRwL3W5jwvZJGcvO89wAD5866k1Lz/xCrjXqgRVBrW+qWMRb1hp6JM8WwdQJ
         5EW9qNQUc7gAfT6h3vXao5FB+5xeZpq8QNpKyiDdM9BI9TQqHHVVz/4IBwyOD+LeWvT8
         NoUQ==
X-Gm-Message-State: AOAM532D7QVo+CywxyYRfvrl2FtuSNSDrqGGiCZnKj0jQ60geKvrQSbS
        13TRGKTfWSmlObnT2ENR2icz6eSb5C+jtw==
X-Google-Smtp-Source: ABdhPJwLUI6Sw/RaxSBfyDQrKUZCT5n/CTULZcOJOHJILujXubb2mpaJ5N+PY3aw00ex5HR2+z6ZIQ==
X-Received: by 2002:a9d:6e0f:: with SMTP id e15mr5999405otr.103.1643418803099;
        Fri, 28 Jan 2022 17:13:23 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id q11sm11804705otl.8.2022.01.28.17.13.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jan 2022 17:13:22 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 28 Jan 2022 17:13:21 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com
Subject: Re: [PATCH 4.14 0/2] 4.14.264-rc1 review
Message-ID: <20220129011321.GA837333@roeck-us.net>
References: <20220127180256.764665162@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220127180256.764665162@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 27, 2022 at 07:08:55PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.264 release.
> There are 2 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 29 Jan 2022 18:02:51 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 424 pass: 424 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
