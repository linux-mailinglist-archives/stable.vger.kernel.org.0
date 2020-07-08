Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8386218F46
	for <lists+stable@lfdr.de>; Wed,  8 Jul 2020 19:53:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726387AbgGHRxV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jul 2020 13:53:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726100AbgGHRxU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jul 2020 13:53:20 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8273FC061A0B;
        Wed,  8 Jul 2020 10:53:20 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id p1so9216771pls.4;
        Wed, 08 Jul 2020 10:53:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=q7RtCjX8qOjm7x4acC+/+/CoPtebhwW7+KEvaA7qNaU=;
        b=RQsPCkDxg9CDnHKl7fCuCkCuinCBQLSrBKcRpHPymiaIV9nccp4dNA+MtosyD2bk50
         bDFSjo1PmONYLKw7ARfb8+Y4ZSlM+TumghpQhTPPHMYRur1LIzd52iEgFiUI263YdyDR
         HfC/pYXs7+uIJYMw4L5a6WDw0qsKVzDIn3yg15qnV0Iv0OvM+3h46w8mxx2Kk6Hx5hMu
         +Ddd4/qBPY9Yx0BfgTGvr191SfLiaqzoKzZmiCOsfKvSAreOMZNbYgpVS1Cw23xE1EQV
         ip3vrM1llOwh/Ffsljnwfd4ij/kk3nxwR24gnJXidLRHYPOwcGD6HJ8fGsAKf8O6qeNk
         u1Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=q7RtCjX8qOjm7x4acC+/+/CoPtebhwW7+KEvaA7qNaU=;
        b=ddPuBWno4qa8eHcXMEqpErByFgciwcDxfB4TgPs8PBI2TI47+9B6IBbS4IBXPyleG5
         j2ubcg0zxH9yaXMOQLZw69J6bh7wmGzqUzYiJ0PCBjVmIqJPxdQ+RAwZGNvzdvR9rJz8
         FoSNhfv597peHsKHyfR7VqdD5YnAaUBeJ9dB1GLzvM8xE5o3Ld3FHnaCVwTJLV5/JSBX
         FDyEXki2IQovIAFxqwz048vzNSxho6kEQYi5vQva1sndZ+g36StdqKR9b+k68uzj5hbD
         LymgG+H5sAMHhpWXVjSptmWPr/aLcs1yV5GUfTstGHgXgOGD6WUZT1/0QqUeS+uKnlWF
         C6hg==
X-Gm-Message-State: AOAM533MrxJnbWRRgaeuxHnrYUh70U+wqQ44Pqo0rjj13T14TYwU6H7R
        DzxdkHXtxjs9LCj/XdFaXvw=
X-Google-Smtp-Source: ABdhPJy81vMx0eFjphQNpavyeZFtXTcTBGgMQJv5rikkIacRxeWUn42hBtpc3a2FLhbXpUwVIbjP6w==
X-Received: by 2002:a17:90a:318c:: with SMTP id j12mr10407016pjb.25.1594230800116;
        Wed, 08 Jul 2020 10:53:20 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id s194sm443952pgs.24.2020.07.08.10.53.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 08 Jul 2020 10:53:19 -0700 (PDT)
Date:   Wed, 8 Jul 2020 10:53:18 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/65] 5.4.51-rc1 review
Message-ID: <20200708175318.GE224053@roeck-us.net>
References: <20200707145752.417212219@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200707145752.417212219@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 07, 2020 at 05:16:39PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.51 release.
> There are 65 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 09 Jul 2020 14:57:34 +0000.
> Anything received after that time might be too late.
> 
Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 430 pass: 430 fail: 0

Guenter
