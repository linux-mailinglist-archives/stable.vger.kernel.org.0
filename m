Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EFE228D265
	for <lists+stable@lfdr.de>; Tue, 13 Oct 2020 18:39:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727735AbgJMQjr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Oct 2020 12:39:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727639AbgJMQjr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Oct 2020 12:39:47 -0400
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF2F2C0613D0;
        Tue, 13 Oct 2020 09:39:46 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id m11so568093otk.13;
        Tue, 13 Oct 2020 09:39:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=u7Y7aO+e8f8+vDcKCGNOhOpSTpDfEwGJK2yWEa6COhw=;
        b=tDRAD5zyOIruhyrZyAy8duowM4sIcE7dGwYDET3AfrqMnNrL4C9Kja1+wlu/bPlR+9
         BHTSnbLTUnB0qS1W3mMTsDbmdGJ+WFnR8MQHigFZjpZUryiW7SKETZN2G93dq/Yub6sv
         NjM06jtOsDbicMlodnSmvYZmko7Z8wyTKP8ZtgzmnVz9WE50vh6GunbrG/hvF+QfTKav
         ZUGs65q1uqxydzG5VhfNfdH98TqsnITetbRKXENPn5TqJ/7WoJ5ML5f+TjwhpsC0XgqF
         2ChLEoj8lKx80gcB08azh69+IA21z7eMNVv24t6A6gdoULAHQV/yKVacdn100iYR26U8
         sfwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=u7Y7aO+e8f8+vDcKCGNOhOpSTpDfEwGJK2yWEa6COhw=;
        b=azRP3PSlbwF6vp2ueG9AIYfl20+MkQKZB5jLT83fIWBoAR1YnfMyZErNKenyePUKhR
         9dsOdpExNu1V07DEJFwMoKwtHROi9DFbx26SGUVQ4HB0RNUueI1qeXz22aCEG1Drz7+d
         zgJDFoPJAuMCDCxlFNwJCd95UHSeUPOaLXGb3Gkx53kTxudlBZOKObhzh5/4o79/bz7g
         XYiC7EFyv3yb6g7CmE6SIiLol4/d432b1QFv2rhJ4lCVleqAJMKF+fZImIZs2JD/d/e2
         cNYZgkEo/kd5V+e/Exkz0480XSzFmPMEf86FlPv6f6pHxj95af6SWcnd8R8d1O7/rDV6
         OW9g==
X-Gm-Message-State: AOAM5330m4i7UzLuCsMBSYsObDqw13OAjkGxCTEMUrzNYN4wHjPRDWSX
        qVFOU+MzNcu3D9U/qi7dOj8=
X-Google-Smtp-Source: ABdhPJxgE33jl2h5QLqSQ0AcT++1HAzKQRwT52WdlAlQqYmPzjbXEHRbUNrV6y+NvTYJEofC30kSaw==
X-Received: by 2002:a9d:3787:: with SMTP id x7mr353791otb.165.1602607186390;
        Tue, 13 Oct 2020 09:39:46 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id l62sm92009oif.18.2020.10.13.09.39.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 13 Oct 2020 09:39:45 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 13 Oct 2020 09:39:44 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/70] 4.14.201-rc1 review
Message-ID: <20201013163944.GC251780@roeck-us.net>
References: <20201012132630.201442517@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201012132630.201442517@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 12, 2020 at 03:26:16PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.201 release.
> There are 70 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Oct 2020 13:26:14 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 168 fail: 0
Qemu test results:
	total: 408 pass: 408 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
