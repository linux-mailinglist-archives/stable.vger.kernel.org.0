Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D26A161FAC
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 15:43:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729758AbfGHNnM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 09:43:12 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:34245 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729754AbfGHNnL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Jul 2019 09:43:11 -0400
Received: by mail-pf1-f196.google.com with SMTP id b13so3045301pfo.1;
        Mon, 08 Jul 2019 06:43:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=MuHD1no+XkJjWCRsD7dOvLKQPeDnugWNej1vA/9eJog=;
        b=uJY/jL1Ok1daTMamg3kB1blu/qPZXPVHQjPCob/7xJagg7cqGPQbxK7QayeOkrwq1E
         /ha250Ww+Yp8Z/D4pmw8V94vclilLq5GQ+N2l9V1UDmI2ux5PyVddXd4kCuO0E7vuDtx
         Hwavi+YFxEwaPfuDg3vMmFwQvI3EMMjb9mqyMD8c/boAkPFzcIgMKR34ceHeTmwE/2sa
         7ebRnnev6jZnj1ScWnm+2/7Gxggi0q5oTme2YvKg3X2v1/5X4N1hw7h11lgu6X19KmCI
         wjHBjs1Ps5QVn3BCjpWk6mz26++55eM1x+Guu9A8VFApHBSMtcHzr100bHT063d4BBJX
         P9Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MuHD1no+XkJjWCRsD7dOvLKQPeDnugWNej1vA/9eJog=;
        b=QbWPpm3NxxCJGgtHRuZEmSlSOUkBCQXoY/HZNo0id616ebpxyR+a18oYmUmyLHsMjA
         /NVLdDSgVEWQLk/lkp7f/l3NEYEkT9sVNCGKzJkEagfIMbmcAfbQVEoLHpj3mz0FI2LE
         Ms9w+eAp6/xNvZQTTWDrNjPVqtV5xPfUYP7SlqtOqBOccGKswEgBJXVU+a8PAfNW+hPa
         OZfp75a4nJCf7fomEHkQrskT07TVSYCEfLux7qQQIAI2UnM2iqTSDGaMgqMvs7lJ0PCJ
         Ogo/V7uEWvkB8jr0W5UuJTC15QXvUYqzWZSLRkV35LqeXcMj0M16CITG8KpH9jqwg7G/
         HN+Q==
X-Gm-Message-State: APjAAAVmf/blnH8atGjLUfVbLprTdm59gvn73V4tvdgHXKJoeSPu8qBs
        Y9/giVpXeq9MIofeLAoReWeBws2UUK54YQ==
X-Google-Smtp-Source: APXvYqy3SX4qPsNChq0vnZOlyeirE4w7ZsJnU4D4zAPQsmNHXWLv/6YEkfMH9hxO4EEi1j5obKVL/g==
X-Received: by 2002:a17:90a:246f:: with SMTP id h102mr25427228pje.126.1562593391096;
        Mon, 08 Jul 2019 06:43:11 -0700 (PDT)
Received: from arch ([103.85.10.69])
        by smtp.gmail.com with ESMTPSA id i123sm23944536pfe.147.2019.07.08.06.43.07
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 08 Jul 2019 06:43:10 -0700 (PDT)
Date:   Mon, 8 Jul 2019 19:13:04 +0530
From:   Amol Surati <suratiamol@gmail.com>
To:     Ben Hutchings <ben@decadent.org.uk>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, Guenter Roeck <linux@roeck-us.net>,
        akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        suratiamol@gmail.com
Subject: Re: [PATCH 3.16 000/129] 3.16.70-rc1 review
Message-ID: <20190708134304.GA21832@arch>
References: <lsq.1562518456.876074874@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <lsq.1562518456.876074874@decadent.org.uk>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jul 07, 2019 at 05:54:16PM +0100, Ben Hutchings wrote:
> This is the start of the stable review cycle for the 3.16.70 release.
> There are 129 patches in this series, which will be posted as responses
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue Jul 09 20:00:00 UTC 2019.
> Anything received after that time might be too late.
> 
> All the patches have also been committed to the linux-3.16.y-rc branch of
> https://git.kernel.org/pub/scm/linux/kernel/git/bwh/linux-stable-rc.git .
> A shortlog and diffstat can be found below.
> 
> Ben.


x86_64 (on debian-8.11.1), compiled and booted successfully.
No regressions (between 3.16.69 and 3.16.70-rc1).

Thanks,
-amol
