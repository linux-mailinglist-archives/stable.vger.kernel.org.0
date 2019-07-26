Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D56C976597
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 14:23:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726434AbfGZMXM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 08:23:12 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:32931 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726277AbfGZMXM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Jul 2019 08:23:12 -0400
Received: by mail-pg1-f194.google.com with SMTP id f20so15487396pgj.0;
        Fri, 26 Jul 2019 05:23:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=9hyjYvg2SOhR1h3z5jY8x3YZyG64TvBUR90jvmGo2zs=;
        b=ckcCvLk9nUedm8Aee0E7hamfIGWSj7fqwKIX4PzIO8tqjaTlIgfzDkJokJf3lf4mn5
         39swBFid2LEqdL8XWkoc2NzZNqm74G/1+31VQFZedpWurkwErJL7Wl3OXmDQhd0g4q2S
         9XB8wGgY2whPuRKdDLYPkBEw3PdDru5FV3Iiqow79ihpyASIsaKte3lyyYjnANIaTiOR
         oA+hMyiSTcIz2ZiwauEnb7rq8YusNExVg++LYeEoneS1SKMizNKC54tgONpYD7DtSkTv
         Nd5BMBcu34XYm5JNLuFwnNihlIFOVMEoVr3VuuP0W3FUMzWTKt4Bn4xYQlK9gOSoajwD
         VdQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=9hyjYvg2SOhR1h3z5jY8x3YZyG64TvBUR90jvmGo2zs=;
        b=Py2/786ESTfeKQODGQug1EZIMfMh7ZLbE9RJkVY/F1yJYxQcVS2E28TnIAK5Oxslrr
         PGKmmJ/s5hseR2Ki3AhKl1kEdM35xmgD3u1CKXvQpp6XtRwXXVYBdIkbZZA5jlL0Txwp
         P6yAh+HsL0OQuRGeRsKBa83ROEKCFrHHRvDGucQimTdKZmjvb5nkB59ZBIWldEgPNwCr
         somQv7yVNlWiFK6woMy04f9TQ/2fakxE5d72QFz2ckx5I8GPfFkMY1X3QFxiWztUFV7c
         bBt/Fqv3HBohncwi1f29vJZ4+95GKLGOglY0w8DScea8Ky2bbZ0Qowa0Klj7VsKaGBuR
         9p6A==
X-Gm-Message-State: APjAAAU7yFenhfCS0LSlticWakezImwqUjkchl9B/P64dvzAt9lQNwZU
        GJazLA7f0iqWSDjQIw0qg/Q=
X-Google-Smtp-Source: APXvYqzO4K96AaGqO98QkzfkfxprJd0bEqKVN8cL8oqAlXnMLGGzafD1WSdywQAu4HPEBBBN27TeDg==
X-Received: by 2002:a63:1020:: with SMTP id f32mr61801236pgl.203.1564143791381;
        Fri, 26 Jul 2019 05:23:11 -0700 (PDT)
Received: from bharath12345-Inspiron-5559 ([103.110.42.33])
        by smtp.gmail.com with ESMTPSA id z19sm45407894pgv.35.2019.07.26.05.23.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Jul 2019 05:23:10 -0700 (PDT)
Date:   Fri, 26 Jul 2019 17:53:04 +0530
From:   Bharath Vedartham <linux.bhar@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 000/271] 4.19.61-stable review
Message-ID: <20190726122304.GA4348@bharath12345-Inspiron-5559>
References: <20190724191655.268628197@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190724191655.268628197@linuxfoundation.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Built and booted on my x86_64 system. No dmesg regressions.

Thank you
Bharath
