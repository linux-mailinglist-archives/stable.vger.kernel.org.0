Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D57D3C369B
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 21:52:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231314AbhGJTzE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Jul 2021 15:55:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbhGJTzD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Jul 2021 15:55:03 -0400
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C90C7C0613DD;
        Sat, 10 Jul 2021 12:52:16 -0700 (PDT)
Received: by mail-ot1-x32e.google.com with SMTP id 7-20020a9d0d070000b0290439abcef697so13500365oti.2;
        Sat, 10 Jul 2021 12:52:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/U4vAqxvA3gvJIZay/FDTlxJpZzLGq5kLA4m/FeOngw=;
        b=KJvpHW10WXsNO52hO8vKzP6eI9Y3n47p88pCQoajMV2/5RLIzZTkBiQjjT+7jEPsDi
         wl+NNU5X2jNynBDcLnRuEiWWIjMNT5tb1GKaKBeYuIhqL8nXWa02ahKLuVwM4FprMELw
         NP5jt4jjFnf3Kbl/hmmij13D2JjkLtkXRhCzsFm5WC8UnoOcV77qLP14RlTXZXQyQ1rs
         YNSvWkMl1GqlT5sygq1gSwcbGLVk9qYAbK0U0gPtEhX7G4GJ07pfdRSMBB7+2ZNdK5qE
         qg9YFxbYEgAmtCEguMmKceYUTICZ4BEheb18QlsYRPhzllaHQckivHyBSBRgVbZsd1oY
         r9sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=/U4vAqxvA3gvJIZay/FDTlxJpZzLGq5kLA4m/FeOngw=;
        b=E3zBvQoNPW6u90tOZX+laQ6CKAT3QY2aZzOREh5zXJOq7b9iCQ0yHxNsUkKseQggjp
         k3BvG/DcRlHpeYHZXKPzUA5i9uQKhHBAY0iVuEbxpJ0qF8xWy9R0xTPP44Y5B+Amvx8d
         Y3d4/OgZ+2FEkzWIt+kDXiPyaaTm3eDRqvjU3DiEVYqGJg/IThsZiDHo3oK77x4kqyvb
         FLFjF2lEoZWysv09bPcxT4LIjYUd5kQ7ztHa+9Ba0ofGquAwXS5YaPcWW52YxcOTIUCN
         oP9VgOEkX4v0dVjcnoMcq7SLLSXV68ZlAYa1RihPdJDqV5/LCcDuZxaZNdYUK9zZe/fp
         oAyA==
X-Gm-Message-State: AOAM531R91F2LZCGfTQUNSW0BQfyKA5e2xXioqe/upRP4620Oy+kyZNp
        ijvpyU+v5jtJlmxa3uj5Lh4=
X-Google-Smtp-Source: ABdhPJxUGgbaPQz3Qs3nyWMyPscrLZFJRg7sYf3rEK7KUkJSXKwvZ9pr63yCSYrdVk6sTcUh/hOLiQ==
X-Received: by 2002:a9d:3a1:: with SMTP id f30mr622901otf.195.1625946736084;
        Sat, 10 Jul 2021 12:52:16 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id p26sm1941332otp.59.2021.07.10.12.52.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Jul 2021 12:52:15 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sat, 10 Jul 2021 12:52:14 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 0/4] 5.4.131-rc1 review
Message-ID: <20210710195214.GE2105551@roeck-us.net>
References: <20210709131531.277334979@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210709131531.277334979@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 09, 2021 at 03:20:14PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.131 release.
> There are 4 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 11 Jul 2021 13:14:09 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 428 pass: 428 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
