Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1DC26E04D
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:44:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726883AbfGSEoH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 00:44:07 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:45032 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726829AbfGSEoH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Jul 2019 00:44:07 -0400
Received: by mail-pg1-f194.google.com with SMTP id i18so13880319pgl.11;
        Thu, 18 Jul 2019 21:44:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=fSM3gEdcksEg3caYoSElmuowtPPLwZxbg+omn70n/40=;
        b=RPWcu7GE9Gq9QCwvSY1L9qrSm+jvlYbepBeIi89GY1VKutXdh2Gd79+RbJQ/8Qlqs/
         oj/L78fye13bx4Hwr9/FY9yILQr6FBvbv9afPRAwkGPlCTk0Pt0/GdwZE7VeGLQejQcq
         JUBuvF54SogIylSuzYy4QOTbB+B6LYpM5rZgafFuuxD+EQw6/pyk/xibHuu4qMJhj8DM
         1V+bExOosM7zkyGF2vhwz9h/KLf0rl1ynN3YTYh5Q8+xSrATFl2RNzhmDfZ+SXkr8uKA
         +4HyDLIkW+TYZD52Bf83UfJ2bwx9ClHO4g96M5aMId1AAzFNWbuz0peavuzFqYJ1cPJ7
         F1xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=fSM3gEdcksEg3caYoSElmuowtPPLwZxbg+omn70n/40=;
        b=Xq0jOJlEY6sm9c7L7ZOIxJkS6vWGS3JbwVujPs+fZMXfmPHeeONOoIXLrUPscccxj9
         o90MrMlQqRyIdHo9iFYI5Kyii2Wk92pbsUs1L739u/f6YjUgqn7P5zox+b8SEaKVoC3H
         9YZArpdnrmg+TprKIk2k5XQT3s3m7PfJ5OLMmjTvFWVePng71vtx2iOvWyBMZ24bHXop
         yQHVwDDe4oWEJqbDAaIaMz9nWrWrBh5qtpLPm8D2OHGgk+4pSjxW81A8qzHkgtUf+0+N
         2wvbzZHvpmEgMGFk2kgKePiufc/gmK1YNmclJoqNvsFFEg9p5PBbJ+LIOxuu93xr1lyt
         0iUg==
X-Gm-Message-State: APjAAAUvGtfguD+3xxWhTQq1jG2jZ5xNxMTdVTK0GAw6qt3OL5HJvPfO
        nRb47ncpXNH+GYVHabej4UgA8TLp
X-Google-Smtp-Source: APXvYqzeBxZq2u0C7En8hTDn8ufsdwl2hThRBbyyv5KE/9KPx76OeSeljmkXVWKbSqoxvl3h+yrTNA==
X-Received: by 2002:a17:90a:1b48:: with SMTP id q66mr53031543pjq.83.1563511447013;
        Thu, 18 Jul 2019 21:44:07 -0700 (PDT)
Received: from bharath12345-Inspiron-5559 ([103.110.42.33])
        by smtp.gmail.com with ESMTPSA id q1sm43646518pfn.178.2019.07.18.21.44.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Jul 2019 21:44:06 -0700 (PDT)
Date:   Fri, 19 Jul 2019 10:14:00 +0530
From:   Bharath Vedartham <linux.bhar@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/80] 4.14.134-stable review
Message-ID: <20190719044400.GB3886@bharath12345-Inspiron-5559>
References: <20190718030058.615992480@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190718030058.615992480@linuxfoundation.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Built and booted on my x86 machine. No dmesg regressions.

Thank you
Bharath
