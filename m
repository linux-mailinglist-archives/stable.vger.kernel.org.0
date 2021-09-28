Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CEB941B78F
	for <lists+stable@lfdr.de>; Tue, 28 Sep 2021 21:29:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242472AbhI1Tar (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 15:30:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242390AbhI1Tap (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Sep 2021 15:30:45 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FFB2C061745
        for <stable@vger.kernel.org>; Tue, 28 Sep 2021 12:29:05 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id dj4so87926592edb.5
        for <stable@vger.kernel.org>; Tue, 28 Sep 2021 12:29:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5tZgnGnFy4OrV5l11NT8NKhXd/UTimRRQIk4YumiNXk=;
        b=faZQTaoipHpseebYlqhoUULbpYWvW8mhhMQu8ZNIHByfa1QDNuyJn4ifqCp6JIwdtE
         w7YEwmfeX728BUDJjUg3vdMywxIfIvUIm0hN5bb+WWhOtUkMgWYLcpPwH6LaTEWqGzLW
         2gkyqBgbyAqMBD6iOeTp7GP82UnI5YFkp0EDgqGbWDiXxG4FfL3RLsCcEduTKNmWdR18
         gP2FATt2HVoZbFk3UPqmC7G6HRZS+Szin5zStRZtn3EE6HIYJ+iBh1EAvt5/hi9IiEI+
         qdFWrrsKlOnKnHfQkj3hLr2CFznd0oYQL3lUbyF8HOKMzN2Xeqc6RNTDfgXgMUFrAAvZ
         53qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=5tZgnGnFy4OrV5l11NT8NKhXd/UTimRRQIk4YumiNXk=;
        b=lxkyvQml5pf2UB6NjT0n2E9quURFtA1C3gXUn/OnoJbeiLUzd6g/XuM83SFYKoqmNb
         bagSfD3Ntomb6ZCfvqeVu0BtX24hVingrQEau3pCX/l3ioMUg3c7nqLPsFd/C9k4lhTy
         yYk6gVinbYzvVdix8mwvNKB1LOGVaTtsNibP8C8aQuUuzlLsupOgKcLUz5ulaglzpmtl
         PrBTJApo8qvXBJGNdd2BYr906SM6j7VEZncj00+x4KjZKPUq1MIIlvrcKNBrNWf91u+P
         gSFo+Ij666ti3BHZVe7SUtmj9POZzaFCA7rHzTVyt6R84t8RIGU4vT1CD3+/t5JcuhJ/
         Gc1g==
X-Gm-Message-State: AOAM530JFZIjBOhovLYQyVUrs0vxw7u1wpg+0Y9pWoZfjlTSWTtdL6aC
        scFAMj45/BPCQL7S/OCeToFgyv54G1cvdA==
X-Google-Smtp-Source: ABdhPJxK3deca/d5n51mI8RorPMfaHvZM6cCJyY/scBUCtgC6C7Jsq7k8x0ScBUL87BlYlY8RFOUYw==
X-Received: by 2002:a17:906:2e8d:: with SMTP id o13mr3472969eji.513.1632857343752;
        Tue, 28 Sep 2021 12:29:03 -0700 (PDT)
Received: from eldamar (80-218-24-251.dclient.hispeed.ch. [80.218.24.251])
        by smtp.gmail.com with ESMTPSA id s4sm24304eja.23.2021.09.28.12.29.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Sep 2021 12:29:03 -0700 (PDT)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Date:   Tue, 28 Sep 2021 21:29:02 +0200
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     Ovidiu Panait <ovidiu.panait@windriver.com>
Cc:     stable@vger.kernel.org, greg@kroah.com
Subject: Re: [PATCH 5.4 0/3] usb: hso: backport CVE-2021-37159 fix
Message-ID: <YVNs/mLb9YXNz7G+@eldamar.lan>
References: <20210928131523.2314252-1-ovidiu.panait@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210928131523.2314252-1-ovidiu.panait@windriver.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Ovidiu

On Tue, Sep 28, 2021 at 04:15:20PM +0300, Ovidiu Panait wrote:
> All 3 upstream commits apply cleanly:
>    * 5fcfb6d0bfcd ("hso: fix bailout in error case of probe") is a support
>      patch needed for context
>    * a6ecfb39ba9d ("usb: hso: fix error handling code of hso_create_net_device")
>      is the actual fix
>    * dcb713d53e2e ("usb: hso: remove the bailout parameter") is a follow up
>      cleanup commit
> 
> Dongliang Mu (2):
>   usb: hso: fix error handling code of hso_create_net_device
>   usb: hso: remove the bailout parameter
> 
> Oliver Neukum (1):
>   hso: fix bailout in error case of probe
> 
>  drivers/net/usb/hso.c | 33 +++++++++++++++++++++++----------
>  1 file changed, 23 insertions(+), 10 deletions(-)

Noticing you sent this patch series for 4.14, 4.19 and 5.4 but am I
right that the last commit dcb713d53e2e ("usb: hso: remove the bailout
parameter") as cleanup commit should ideally as well be applied to
5.10.y and 5.14.y?

Whilst it's probably not strictly needed it would otherwise leave the
upper 5.10.y and 5.14.y inconsistent with those where these series are
applied.

Regards,
Salvatore
