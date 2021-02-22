Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB1FE32215D
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 22:28:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231969AbhBVV2b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 16:28:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231899AbhBVV2Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Feb 2021 16:28:24 -0500
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60ED7C061574;
        Mon, 22 Feb 2021 13:27:44 -0800 (PST)
Received: by mail-ot1-x329.google.com with SMTP id l16so4501837oti.12;
        Mon, 22 Feb 2021 13:27:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=XQwQDSd+RHDPSrosZkhBahbLp2DZMYK/Upk8L/MCW0U=;
        b=kKUj87NsI4klHWfo+iQYwwU/MJvUpdZvdpDb91y7H4T5keT6BnYI3fLSdPs3CgZnAq
         s6g+HUcTicwWOWOCWK5UiPIT0qHtTLa2ZnYLSh2qcOV6ufe4nxLqDKi0YUHfUQV1loNQ
         XtknoROu1OhsmyCarjDDaWEtKkJSrm35zqdwdrOyq0OaBTcRG0OznSKIIsTnR7gD9qtd
         PrzuriHkJ4hShjIxQZsOkTetLkZo29ySsc8XUfVorPnFCR+Eq3b/xGTaHisqT5G7xbKy
         x554cm4WtHiS2psU9AMVWrrxxa0vMyiIf0VCaxnQUJ/ghRMhDoBwDgwmqzkMtUMEMycn
         1bAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=XQwQDSd+RHDPSrosZkhBahbLp2DZMYK/Upk8L/MCW0U=;
        b=IGCTZKX/sXZJaxyG8iqOk4Wvwd8ogcwk0uc2ZGSulpBhS+S7St6eLwVwcfDZaXkz96
         HUjfMs0UjdNtvOmhI6YgJmknU4il4Nt5OCy0MnbdUIRznWiMvpW3ZqUbnvNwF6AAB3aG
         HFG3mBgIz7wkFEXVF7+cUXOke1kUreCbCFc7jge3Yd5C1333AKdOMVUqFA34fp16vFfS
         r4lmYdAy3MdbF8tssMU2eu3iqsjvPuXv9PO7fJrYutLjH2cfDJ98WusIOTh0she1WJH6
         hQB2p7aE9WNyCnLmbZgS3+zwZEAvh02LYoBQKTNFWUTzsxE1+95qbrnTLHqJQRkAa6hZ
         CHdg==
X-Gm-Message-State: AOAM5338itch2pcY/kBypmGC08eFQjWzrpkYHVoBoLRv8WuySjKgR0++
        GJYND/EowckuWnc0DmFe49I=
X-Google-Smtp-Source: ABdhPJyi4klPoemvITE5dhYTUKf3XnvigxLEsSEXoiMD2G4Fx3wDX8TXswLI4ZHkBm8ne4HhHBAlCQ==
X-Received: by 2002:a05:6830:1ae2:: with SMTP id c2mr16958951otd.221.1614029263895;
        Mon, 22 Feb 2021 13:27:43 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id s6sm506192oon.46.2021.02.22.13.27.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 22 Feb 2021 13:27:43 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 22 Feb 2021 13:27:42 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/57] 4.14.222-rc1 review
Message-ID: <20210222212742.GC98612@roeck-us.net>
References: <20210222121027.174911182@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210222121027.174911182@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 22, 2021 at 01:35:26PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.222 release.
> There are 57 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 24 Feb 2021 12:07:46 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 406 pass: 406 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
