Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87AFA218F3C
	for <lists+stable@lfdr.de>; Wed,  8 Jul 2020 19:52:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726142AbgGHRw3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jul 2020 13:52:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725810AbgGHRw2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jul 2020 13:52:28 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4F68C061A0B;
        Wed,  8 Jul 2020 10:52:28 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id x11so18480062plo.7;
        Wed, 08 Jul 2020 10:52:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=4p1c3euzsHTIfqkiRjF6Y9Z6hsIdKICYRGtGfoB/aF4=;
        b=ntzHxjUO6As7V/H9QldNuvwSgd/MeQ8CyYqkLGeuaQ4vR5D9FNm7F+5vDDW+iQYTww
         2cSspx4/MI+5UTofhfW41ZJ4SQbBhqg7IoNEzNiopbYEOI5JiWJCQbyAyHqQsExf5wUt
         /7XeEET4j+3ck/CVYbamSt36YUXVlNsN4JULxl40a4oQPC+XNl2C5nPR5q6OloxEoYdr
         7eaRY5WwHjg8MY4VzSvXNO2ghnFjdCakpkWrTIpV1evBpfH/TQQppKrCuxeKHXAMNu18
         yiy/YqmusTjtB+6E9KeiaOBG+ya0Wfz2bbPwfEK58Oys++cDbHvcxlLpNIRIxrBDHn3U
         yDMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=4p1c3euzsHTIfqkiRjF6Y9Z6hsIdKICYRGtGfoB/aF4=;
        b=CuS2UlTN/Z+wyx7hLC631wx8LnjAom+PlA0YK3bJRBlQ3Ys62GoZVgqyQwS2qWEw4f
         HufiUegQzceFKBOxlT1gPYOGp/Z4DdNDifrssl8cQq9czTemcvuv8buz5hsI85yyuL5p
         +BMux/RrgvpBtjYP22S3UedaN1N8e8/Xin/HyX5eKKZDg2N3LM1dm5d+YQvdSQRDXcO4
         pb/engv/fdQc+SWgI094sOqcztrguKqV9u6q7WSiuTnm8azqYyuHjdbiESi+aHDmjo3o
         fRcAGLNCmF/1ui3wQF8jNLI7wzdZ+aVQxvy3fXQZBSHkQWog7x4PRZ8Ykm0WCxE4YTdO
         72dw==
X-Gm-Message-State: AOAM531c3u9TRx56lo10RgFRqJpIRsV7JKMo5Ac+Ti8MNt6YaoZHJ2dh
        sgCY9Sc1WY6jTyPGv4jXqwA=
X-Google-Smtp-Source: ABdhPJyL5Jezk/P0PDvtnbKieBSXLt2+CK2JO/Xv6mWt8hh/TVXIykYwzqU+M4xRj6Ts9TUCTfrY/w==
X-Received: by 2002:a17:90a:12c7:: with SMTP id b7mr11079979pjg.137.1594230748456;
        Wed, 08 Jul 2020 10:52:28 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id c27sm395924pfj.163.2020.07.08.10.52.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 08 Jul 2020 10:52:28 -0700 (PDT)
Date:   Wed, 8 Jul 2020 10:52:26 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/27] 4.14.188-rc1 review
Message-ID: <20200708175226.GC224053@roeck-us.net>
References: <20200707145748.944863698@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200707145748.944863698@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 07, 2020 at 05:15:27PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.14.188 release.
> There are 27 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 09 Jul 2020 14:57:34 +0000.
> Anything received after that time might be too late.
> 
Build results:
	total: 171 pass: 171 fail: 0
Qemu test results:
	total: 407 pass: 407 fail: 0

Guenter
