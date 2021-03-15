Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E817633C86A
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 22:29:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231321AbhCOV3G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 17:29:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230205AbhCOV3E (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Mar 2021 17:29:04 -0400
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 454B4C06174A;
        Mon, 15 Mar 2021 14:29:04 -0700 (PDT)
Received: by mail-ot1-x32d.google.com with SMTP id e45so7653374ote.9;
        Mon, 15 Mar 2021 14:29:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=qauLXcBI4U2xuKNwXWWr1Y24ibM4+yYT3FTQgkMlDKw=;
        b=hHjvRy2hh8Dfq9hVxeebovgQa3D8X2IThZAA+nU1pxn2EGDq3YqcGZ3w8XfYdInM6B
         oCj10iwziZB90dPrrPrpfHxEkZWn/hFT/qEAh2s58nUzaRJBhyKF4SgjCHJd5YX8AmS2
         NyhMH27n/CN98sJM2vjS4JEs2/cEeGeTN0nuCgeSxaaOenMFxVOcCaowXHkMZl/dk7s0
         7o+8BfXzQZ0R1en9/trAcmuWutILtivI8mm9cGzcfMLWd0uTnKhhCXGR/EsE6691uE6l
         oDMeJ36NYiDXcadqnL7H6ZQP4H+XFOTj0EaTbqbmlO19vP4aXDq0Xh6uUzW9MxLc3/yb
         FwDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=qauLXcBI4U2xuKNwXWWr1Y24ibM4+yYT3FTQgkMlDKw=;
        b=U1Elb0rik5F1erkiFGzXOu4+ZIwhlh6E25ODUGSR+PJSGlv3F7vTgL6pIT0mGZogxG
         MUFNli51pc037HWeHqKSKzR5WRiJWhETsVCNbEf5XIkm8GcjiiKomo4IRClGOCqqI4ed
         OgW69s/2bFYs2yzDi7C/VZgK62fVlzPE+b2VYZbRws786QsxKaZAVQtWF1Vah9HucmOT
         7DxVzmlaxSzNmD34MoUxaPPTrspAPtXdn2ovA5IQz/Cu6w3CVkvFWeW+JjbLedmzUvAk
         3Z8Ikg5Ca4jY04QysQzlC6JNc64yF9Ipi8M9rIRyNnXJ+kdlkCvtTbwNAUc1EgfVv3rN
         a0Qw==
X-Gm-Message-State: AOAM532wUgeI7+s9mhaewviuLu2UhrfUveX+QVEBju11qySoLPr2gtuk
        XWOVf4WGybn1HSTSzg7WtvXKdEudwgM=
X-Google-Smtp-Source: ABdhPJy5Vgld0qhelFkeSChaN70ob+Ni9ybPXGokbkCKj60y/tqq7QBwq/mYjlYle2lKT1mk2+MPvg==
X-Received: by 2002:a9d:6e8d:: with SMTP id a13mr835044otr.287.1615843743737;
        Mon, 15 Mar 2021 14:29:03 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id p64sm3058675oib.57.2021.03.15.14.29.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 15 Mar 2021 14:29:02 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 15 Mar 2021 14:29:01 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     gregkh@linuxfoundation.org
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/75] 4.4.262-rc1 review
Message-ID: <20210315212901.GA69496@roeck-us.net>
References: <20210315135208.252034256@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210315135208.252034256@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 15, 2021 at 02:51:14PM +0100, gregkh@linuxfoundation.org wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> This is the start of the stable review cycle for the 4.4.262 release.
> There are 75 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 17 Mar 2021 13:51:52 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 165 pass: 165 fail: 0
Qemu test results:
	total: 328 pass: 328 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
