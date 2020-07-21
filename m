Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9A582285D4
	for <lists+stable@lfdr.de>; Tue, 21 Jul 2020 18:37:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729168AbgGUQhI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jul 2020 12:37:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728691AbgGUQhH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jul 2020 12:37:07 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB9FFC061794;
        Tue, 21 Jul 2020 09:37:07 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id m22so12169363pgv.9;
        Tue, 21 Jul 2020 09:37:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Xjsz7M1wsLWikvMHNCZOK/jxKpFwPqPJgMeX/pdkZtM=;
        b=CcYBsXY81zb2L+cCr3NjZ6bQiOEZf6jhw5lSGAcHWwJZCT9k5eU8p2suRC6mAnMryT
         LOVg3xTwTS6Ayb2WjB9GMDrNH1pJljrR5XEOyL19nTgiVAOoyttsJfBcaXIl3d4WxGJ8
         PPn8mjJ7Z2vFQX5n4RXluOfaILkz0Ce9sZ8lHwMerWQ7Ec1wfHQcyLX1DTvlF0igHp9s
         FMYJyrzcZ2/puXPyHGxhrdVXEF23oO+cp1nabgkTvsE1EH8YGHooqtdwDfofe3tAq4wV
         7IwTdggvlcM4wClDo+O6QWQC2ZWISFj1B5PpY5TVTCVHC7cE2zkhyNqbJ/GtcDRl4yyB
         8dwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=Xjsz7M1wsLWikvMHNCZOK/jxKpFwPqPJgMeX/pdkZtM=;
        b=YCksx6hZlqEPAIf9CXLbXwnQLBZ0i4fKzVr0oMCYynzzLrsoKzCRKHU6XJ6JVMr/5l
         gOqlKLf7dRAr0dtsdwpr+C4jdXfkk1YH6SrR3Wgu4+Cev/WlZOe16ykIID0wprxiZEBF
         4ByZz9QH+8QJ2SM4H6RMl17ErsbJiTG5XkTXAenRgKNz5mO5W2sq51QKqUXmGCZgHOKy
         YuYdZ0LTNSFEnpsCCgFjJXIYfGrdGkTqvhzxNUTcf1QErLJuG85u/yjth7bm65Zq9R87
         njkOkTuP2kliPaSoWvkHRfAGD7KSPt6wrvnZ/KVVxjzhHaRO1rHY2TbVMhZPb9+JlFZD
         IO7g==
X-Gm-Message-State: AOAM531H2PbAgfWTMPSWqpJgPljhKQnLrjqIfTgS1haFxMiChcofq8z9
        WMfWsEK+lasdqyJ3DwaV+ls=
X-Google-Smtp-Source: ABdhPJyUdsmhtyx3YXX0EjlbHCv7Z1EvOVPI2XqH16lFZaB8WLI+OBIeTMhbq9/raLFoU49w/Wd5hw==
X-Received: by 2002:a65:428d:: with SMTP id j13mr23875002pgp.211.1595349427357;
        Tue, 21 Jul 2020 09:37:07 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id c30sm20764862pfj.213.2020.07.21.09.37.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 21 Jul 2020 09:37:06 -0700 (PDT)
Date:   Tue, 21 Jul 2020 09:37:06 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.14 000/125] 4.14.189-rc1 review
Message-ID: <20200721163706.GC239562@roeck-us.net>
References: <20200720152802.929969555@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200720152802.929969555@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 20, 2020 at 05:35:39PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.189 release.
> There are 125 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Jul 2020 15:27:31 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 171 pass: 171 fail: 0
Qemu test results:
	total: 407 pass: 407 fail: 0

Guenter
