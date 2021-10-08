Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B6CC4272C8
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 23:03:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231686AbhJHVFu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 17:05:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231506AbhJHVFt (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Oct 2021 17:05:49 -0400
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A87CC061570;
        Fri,  8 Oct 2021 14:03:54 -0700 (PDT)
Received: by mail-ot1-x32c.google.com with SMTP id l16-20020a9d6a90000000b0053b71f7dc83so13148626otq.7;
        Fri, 08 Oct 2021 14:03:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wVEsBJKkXLNBRwpVAx3Ar7L5KRZUthR1itDE2mxQyTw=;
        b=HJ/dXBP/0OXWWsJaJLXHqA/DEEZLtkSxFPQi4Rm/oihuJZCYNJBp9wZKI6BkFjbKY6
         Q7huK52heIPGWX/Cknv22dyzezqcJ10tbnW9AeuR41tvMQff5x1qdAq/mdQ+gz5P8OSt
         bCKoVwn3ix2EQQQwtdPruTnnxgr+EL22WRf1Vi1e/KQqaLqActREeshky9+Kl3iiEX98
         8k3TW5cANvnjPKOpEbNQaBeMbm7YCeJkUJweLXJHi6EV4UC6/wSuPHNbZWzcxxWZWqFh
         UzlW3kn7G6AaItRNSo4Yf4bP+KQd91Xn+/eqcumO/LW9zr/aZ93/Bg9YtVbVqH3IrIff
         TEhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=wVEsBJKkXLNBRwpVAx3Ar7L5KRZUthR1itDE2mxQyTw=;
        b=GKi7frSAi5XlS/xebNBxf/7lHu1ykjxQlmj9GQ9kV2wnp+UO3TUF6r83133S4wEC9A
         8B4VSZx9AqOlYTofQ52/L42GOqLBOqxvtHgaknVdPUbG48lM1Ru90wL7iLbeU1XSfllC
         LyfXdqb47gTElkdvwyjv4XJ4v7FuGmOXiE/uxrq3e5pBTsn2qh1igc/MTahXV/RdLfFU
         nljSHAYHExbbarE28a8+8knvPbWjK1cgZ0i5ZYAVJSlgk3DehznyM6fE0XEw1w4681dp
         cs7OJu/iPlnUfnJorikxQNYiCm9A88yFB3PW667+hNimfUAojdz2G8fx1x6K7h5wngpQ
         a5ag==
X-Gm-Message-State: AOAM5303hwYB51sNFScG1O+AsZJrt8eltaIDNBLqdgYGLvrleQyn6JeK
        +Cbe0kyWWxb9wYVuoWwKgU1UtmlHqNI=
X-Google-Smtp-Source: ABdhPJy4G79ppjfH6KmWPhr2LBkfnTGnrbzJfX649aI9BbHcrleWvzaduGMpNqR0DE5jBzPr0mANcg==
X-Received: by 2002:a05:6830:1442:: with SMTP id w2mr10309095otp.76.1633727033465;
        Fri, 08 Oct 2021 14:03:53 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 63sm82685ooj.7.2021.10.08.14.03.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Oct 2021 14:03:52 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 8 Oct 2021 14:03:51 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/12] 4.19.210-rc1 review
Message-ID: <20211008210351.GD3473085@roeck-us.net>
References: <20211008112714.601107695@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211008112714.601107695@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 08, 2021 at 01:27:48PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.210 release.
> There are 12 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 10 Oct 2021 11:27:07 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 439 pass: 439 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
