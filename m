Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5C90C283E
	for <lists+stable@lfdr.de>; Mon, 30 Sep 2019 23:07:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731404AbfI3VHr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Sep 2019 17:07:47 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:40261 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730145AbfI3VHq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Sep 2019 17:07:46 -0400
Received: by mail-io1-f66.google.com with SMTP id h144so42077107iof.7;
        Mon, 30 Sep 2019 14:07:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=1JAxk7tyYRwQss6DSI41A5FG1S9HgN+C/lrI/eEfTD4=;
        b=o798wUebGHzcN0wtUwoqOlAUfWkDAEksR50QXMHXWd73EjFtvIXG/KC6GiyTvVaZpm
         /1sPRhDr1uNoG7g5tZawkxfz8MQ/xxg5gjrU7BUo1bV73I1PxZtgLbd8GwgsNNRy4/ZB
         a2Zwwrgd8JFRGXr1+kPBwnp4kZSiKRDcezutk1Tc4uA69z3I1MGIHXjopCehEtqf+6G2
         QcDnnajtOler9Q/x+KSF1TMyOaLk2OJxzent6r7Yw4rfjK9yglQmcJdC6k+BSgF0Yyin
         GJQmNtRQQr1jtikZGl+d3798pNuRzJBWQZ2Dfjg5IKIvZiKcmep4162GaMXY/XTQ9u0i
         7C1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=1JAxk7tyYRwQss6DSI41A5FG1S9HgN+C/lrI/eEfTD4=;
        b=LGW73leQVQtTYXcILUBmlxysr743NKmWiqZR78Gqwi68PpQTj/xqIX/eiLMPGLNRcY
         Lg29nMzDVZb36nyVhjCx3RmxMj0NKO5pjLap+WFNRi4H8TACWVtPYHoSWuGjyEkR4JKG
         A8MkfTji4k4N+yVtGiYfarjfltyZ8k+Rt9Iwdjtis4kOraWp8vaUD4A/gt2crf7n1A3X
         TqEYlRkgMCgqvRGbmdhhQgJZN5uKeAsVyRrFlEUNPy3jqdPGTTN0LDVDpSKrPLe9Q20e
         nWGl0djl7ty5Wxmd/llDcY31TV0ZtFvsBurnkGo9O8+oqsPVsYPAFsRaO64GmJxy8fRx
         Mtdg==
X-Gm-Message-State: APjAAAUAmDSabAnFYPHmKan2N4RIiNUuEkuyy98cCDJ6NTrCh9eGuPL2
        yp3sCAx+/tYR+IeuxZM+hU35hrc5
X-Google-Smtp-Source: APXvYqx3zk39crf/WzXd7tRYyuOhqC9AdUsXFsTJFLvr8Ko4kbO2VPowWzf4245DIyFZKhN+eI2Qhg==
X-Received: by 2002:a65:6885:: with SMTP id e5mr5708pgt.27.1569868234691;
        Mon, 30 Sep 2019 11:30:34 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id g202sm17250506pfb.155.2019.09.30.11.30.33
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 30 Sep 2019 11:30:34 -0700 (PDT)
Date:   Mon, 30 Sep 2019 11:30:33 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.2 00/45] 5.2.18-stable review
Message-ID: <20190930183033.GC22096@roeck-us.net>
References: <20190929135024.387033930@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190929135024.387033930@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Sep 29, 2019 at 03:55:28PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.2.18 release.
> There are 45 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue 01 Oct 2019 01:47:47 PM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 390 pass: 390 fail: 0

Guenter
