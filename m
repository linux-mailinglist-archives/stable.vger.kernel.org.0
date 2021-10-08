Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6F3D4272D0
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 23:05:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243219AbhJHVHL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 17:07:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243192AbhJHVHJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Oct 2021 17:07:09 -0400
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72D67C061570;
        Fri,  8 Oct 2021 14:05:13 -0700 (PDT)
Received: by mail-ot1-x32d.google.com with SMTP id e6-20020a9d7306000000b0054e6119fc16so1268869otk.11;
        Fri, 08 Oct 2021 14:05:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wRESRpKwYfyF6v2fW0H8DmskM2ckPoZ+tp5kUYqODDI=;
        b=Uj7/9JNq7wX9VyyIzwB65uYKqhbt1Ou5P4ov2X9mwSMU0oNWmg/jnkIaxnUPsrn8DX
         wb4aem3LZJ+W5FFJ57ZrdIGYbqjsXYjFmv1SvVW6TdZ4ys+iMOA8ZVCYR4dUhsm1pbpm
         LLnh6Tq4vx7quty0Sv60RfvpC5/2YOWOQ7Sixnff66rOMxJ4QWB2U+0Z7bsb1SJQrqwZ
         0rxIecq7YfE2mAXPTTxL0v8N9clpJ0tAPKpv3CaMTc+WOfnEkKXm1bdqQ8nv+p2pt4b0
         z9JBAqLZ7EuN/0I0KQ+tmoUClbIsNxT3MUJW6+0jvcRhc+RXTf1A0hoOfgZXhA7TLj+t
         CASw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=wRESRpKwYfyF6v2fW0H8DmskM2ckPoZ+tp5kUYqODDI=;
        b=bbz/jVgWn6/cBnpn15cOKX4Vy02DvpzZaotdda9gArqs5dS+/6M2BR9mLGDKpnfwei
         uhD/BXoQtftLF4F9j93pUVpX3Ps7K/dtR3AeCECXIryCCVtVdcf+dZO4jrnWKbNZSdQh
         kjlZ81MfdtXBYKNZg4gjoG+1Jy9mORrR9UYLxSjES1aHVoIFp1Z07tbpq3ZwFc9ue96i
         RnywSTtJjaBA41CevfVvqW5MzRFuIvBvX2U0QKNjQPGyyhGiPN3Yg5o/8f8XyyFNzzau
         tcYzmTYI3kJbzceuMfsqxQOtwQuHW6VTwKAFcadYMbtApyzCrDq5cUBDrmK9XPNTYfEk
         3QfA==
X-Gm-Message-State: AOAM531Cuu2pMff/CNU4xiMu6Ro9IiqcvrJuEw5UXkA2lFsGcpCHW5n5
        cCmsagrvEFz7XLmb/u+EEiM=
X-Google-Smtp-Source: ABdhPJznqx1wm8M1UYw5ov6tA6KAvKkDZUh09mZK7/8b8TMruLV6avwOY83nHlH4iKMv+uUgroqrhA==
X-Received: by 2002:a9d:4705:: with SMTP id a5mr10544283otf.237.1633727112850;
        Fri, 08 Oct 2021 14:05:12 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id p18sm108486otk.7.2021.10.08.14.05.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Oct 2021 14:05:12 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 8 Oct 2021 14:05:10 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.14 00/48] 5.14.11-rc1 review
Message-ID: <20211008210510.GG3473085@roeck-us.net>
References: <20211008112720.008415452@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211008112720.008415452@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 08, 2021 at 01:27:36PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.14.11 release.
> There are 48 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 10 Oct 2021 11:27:07 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 480 pass: 480 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
