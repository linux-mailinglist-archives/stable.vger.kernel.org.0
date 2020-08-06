Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E7E323E193
	for <lists+stable@lfdr.de>; Thu,  6 Aug 2020 20:58:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727936AbgHFS6A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Aug 2020 14:58:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725272AbgHFS57 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Aug 2020 14:57:59 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0F1FC061574;
        Thu,  6 Aug 2020 11:57:59 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id y6so1075047plt.3;
        Thu, 06 Aug 2020 11:57:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=qUNZob6AFKNFM900/HYXN//c8TNBapKdy1HduEHkfz0=;
        b=hCkZMjTdC/O28VwyBwd6yoIqXoPja41+Aqvt1oTU7DKEAdCP21BIF0sfIi5prlm12o
         5uJRDzno4fZXSwbdIyPmCAH5aiPJ++otNyNenc/WGY693xSl9RO3fJy7Es+lmZrMtVez
         1+Ia+w3hdNJpXv4JFTncXar8kzuECSTo+o1QqwObQpa1AjRj+ANZ9KO72U7sXRbcr0qi
         3yZIRvYXi13+9McKMxOoY9nHmvk9pj/CDDnrAEEGzt+hNvq16DZnlnNciXpqD/LsUwkp
         eGuQRdGFbxKrNuf+fhgspAy8LwhTgxQX+TQTlyFPA+Oz3feE6HnfeG8N5SFxkRosy7JQ
         WtJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=qUNZob6AFKNFM900/HYXN//c8TNBapKdy1HduEHkfz0=;
        b=ZrJXWGsEz1a9yNF/N4YB0E4qPhgQtuYV6qeQz0NyXpfs3UN/YwUx5a4McRfcGYn7iP
         uHnsmymoJaDTjVya7fzZ15blXbU/3iKzIVCV/Wzkdlfs15baZ5xujoYejrSilx3eemIg
         Uc/7LYGbtggFZu/ShuXc/85lL94TmAaQ6EK0lq6m9du5RPBCrSTkt7oUQL0ECr152PWh
         ews8acXdwW7s97V5XA9HyoEA+Lge6wnElDhJDSJ+CNYKN6el3ffkuj4zv+R/lvTNrN4x
         1z2yPnvFGeQPn6cwifahHF0fn92DTA+cOa5w/DzYMMfEzYt3887sXSuaPsGtaswaLj+T
         4vfQ==
X-Gm-Message-State: AOAM530pxaFVfgwFFL3qJxTmc6Qh1IVvR1TqCa10B5aCGOhzq4rfGjHY
        2z6hCoRzEbn5Arxrz3Klp+U=
X-Google-Smtp-Source: ABdhPJwoGeYDpRPH//z0I53hYW00ms/LVnOO+Es6iEeiMGQvMFoH4bTzyzqJ+QAodHXoIwuDjrU7og==
X-Received: by 2002:a17:902:d704:: with SMTP id w4mr9332397ply.278.1596740279346;
        Thu, 06 Aug 2020 11:57:59 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id q12sm10096488pfg.135.2020.08.06.11.57.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 06 Aug 2020 11:57:58 -0700 (PDT)
Date:   Thu, 6 Aug 2020 11:57:57 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 0/6] 4.19.138-rc1 review
Message-ID: <20200806185757.GB236944@roeck-us.net>
References: <20200805153505.472594546@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200805153505.472594546@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 05, 2020 at 05:52:59PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.138 release.
> There are 6 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 07 Aug 2020 15:34:53 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 420 pass: 420 fail: 0

Guenter
