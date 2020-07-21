Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B09652285DA
	for <lists+stable@lfdr.de>; Tue, 21 Jul 2020 18:37:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730141AbgGUQhd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jul 2020 12:37:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729573AbgGUQhd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jul 2020 12:37:33 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42AEAC061794;
        Tue, 21 Jul 2020 09:37:33 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id l6so10484200plt.7;
        Tue, 21 Jul 2020 09:37:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=bdp7aDzfXwdtGJufNVMLlSB4VlwiDJjtWdfHdZ7XNq8=;
        b=Q9+C1kgFZfpW3Tj2HCTUiC1JhFlZ/1lJmUDhLHR4sbgvF730r3a0smRpNg4L0gceI/
         abXOfOELAjDlR+8xYA7qvWzXqkinJLWLdeFGZuVRHpxHrYyenCsiiW4sab5hyN+auH2/
         fueAMfnuBKqzyPa3cRoMUwbZoOrmZ8YXoVKEUYgrST3qTAcDbQvfV77+oSqsTacFxQqx
         lxzMvWAp+a39ZLzE0OBTKzwgU8dJon9U2bq4E7F2jTzu5D2tQWoW4imDctECXA2jBaAO
         yKrtE3SDfH3JU26M/TLyFMphRMQKXQ6arusgtRiuEWZjxN5q96g85wfO1+C2X4dJCFew
         gB1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=bdp7aDzfXwdtGJufNVMLlSB4VlwiDJjtWdfHdZ7XNq8=;
        b=iWArUxgLjdFWxkHCP25Pc40GsAMWIWjhHSR3X7SVJdcV2FOH3uoemL8q1eUxcXdm/X
         /ApVPxKv//+0IB/qTEDdE/zHEcuS9tZeWORa/0KJPPQp3rASCwB2Dz4wq3RLdWpqSRDU
         ltSF/YdBSolBF9hcMpOtubf5yTMLg3KcJn3HbeBNoDGXAI960KC6+S+UoPloqXF+yUC2
         AsiwUUZqehIVuUuWpHeNNQu+v8DU1svdXteundh6/d+mawyCbAzQY2Fz2lqaSEQ9Ea3F
         udUjAYwEFegYbEHbIdcsq455KBt43J81u9WB5m7wTt32Vi2XTyds6wx2svmiFGBUQQG5
         BA1g==
X-Gm-Message-State: AOAM533CuFPre8HIxF+bKFKk0OdZis9/nxoAv2l5BcHBsWzRrbsdFqPh
        ejc3mX8fYpbGCvbYjY8kES8=
X-Google-Smtp-Source: ABdhPJwoPZ4JWHAPBnZe40nasmVcWXwddMu8cxs+31gc4SUeiJ4UGb4UIp/s7Cylq99O8e+CWkoEfQ==
X-Received: by 2002:a17:90a:338a:: with SMTP id n10mr6102489pjb.50.1595349452826;
        Tue, 21 Jul 2020 09:37:32 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id x10sm17861953pgp.47.2020.07.21.09.37.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 21 Jul 2020 09:37:32 -0700 (PDT)
Date:   Tue, 21 Jul 2020 09:37:31 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 000/133] 4.19.134-rc1 review
Message-ID: <20200721163731.GD239562@roeck-us.net>
References: <20200720152803.732195882@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200720152803.732195882@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 20, 2020 at 05:35:47PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.134 release.
> There are 133 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Jul 2020 15:27:31 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 421 pass: 421 fail: 0

Guenter
