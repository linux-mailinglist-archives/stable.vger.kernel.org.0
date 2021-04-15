Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A9C4361143
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 19:41:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233980AbhDORmP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 13:42:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234130AbhDORmO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Apr 2021 13:42:14 -0400
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C3DFC061574
        for <stable@vger.kernel.org>; Thu, 15 Apr 2021 10:41:49 -0700 (PDT)
Received: by mail-ot1-x331.google.com with SMTP id 101-20020a9d0d6e0000b02902816815ff62so17422708oti.9
        for <stable@vger.kernel.org>; Thu, 15 Apr 2021 10:41:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=S97dfkg2gcuPHPopaMERtihQ0lxM6CN8v8PL/3aoSnY=;
        b=bqf03Bh+dm1Kx6/F5WY3BxZ/weVEQr6mV0CpicUG+/I5Leh6QdQVcuj6WzaWY7yyBu
         LdJre4hte0+Td/wEQfKZvGwsgaQuJA7jj6KjQw8vBMSxbsJU6lmeWBvuFZ5YwObc8JOT
         bFtPwZYWKxgR75At2SY+IBqQ8espvDFm96XMuIOW9Z9EzFamBq50Pvm6j3ufivLMTMoM
         T0EC32+7JfgFIzAbf8A553ry9pdUxTOL3zSKNzW8GrkYnFr3G8W/dch1brlDvnPq03g/
         64mkh7RJePxVkhTWj3MHRYkIFRMQ5xd8/uFzxFhrHIOeKHP1/zaRCW9KU70NEXcm/tQr
         gAig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=S97dfkg2gcuPHPopaMERtihQ0lxM6CN8v8PL/3aoSnY=;
        b=taki6+JjErcoCAUiLjoAt8whgXOAuEQGtRSzvHaoekQmUa6bqXdk5j4c3eyaq8CCwa
         7AWTuW2zLZqRxh+duWt9LGPrU6stAqSkDvaC67QMCZNIkGVWzgBrm9TAyv920l6Hba8Y
         RAooko/hTnm6ezb4bJ18cZCHtJVWqkBg8hh/R9NVe1NTkfdumu8/ub0z5NiecFglXZPG
         vVxhJHK4Jw6Q/JpAjdY0DJ/R3zRlVmaekneqoLPW+EP92ewGa8uGfa+dLgWzqJESgAW9
         hYTzJka8TilX630h4vYHwZwlSeyUy3Ce0ZtQ1ZrVt0McdrB5LKmY6L3wFE58rvXoBd46
         KKRw==
X-Gm-Message-State: AOAM5318G5iLEslZduNaGTjpsX2Kqbe1BDMP25MgWoHxMHXEoIa8vZNc
        5ztrLAidt0jzMSksaOnnrPMcIuvgTBk=
X-Google-Smtp-Source: ABdhPJzHqrjQ9cQvNi+RdLC7OLTywgYbKqCofCVoVeJqFHZvL3ZNAKX07JZwpyTMkmW88/K6S8E1kw==
X-Received: by 2002:a9d:34b:: with SMTP id 69mr352017otv.142.1618508509055;
        Thu, 15 Apr 2021 10:41:49 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id x81sm772779oif.37.2021.04.15.10.41.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 15 Apr 2021 10:41:48 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 15 Apr 2021 10:41:46 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable <stable@vger.kernel.org>
Subject: Re: netfilter/x_tables patches for v4.4.y..v4.14.y
Message-ID: <20210415174146.GA30478@roeck-us.net>
References: <1780f159-140b-231f-8af5-ccec049dc8b0@roeck-us.net>
 <YHhr1WuX4/0l+9lP@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YHhr1WuX4/0l+9lP@kroah.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 15, 2021 at 06:37:41PM +0200, Greg Kroah-Hartman wrote:
> On Thu, Apr 15, 2021 at 09:28:15AM -0700, Guenter Roeck wrote:
> > Hi Greg,
> > 
> > please consider applying the following two patches to v4.4.y, v4.9.y, and v4.14.y
> > 
> > 80055dab5de0 ("netfilter: x_tables: make xt_replace_table wait until old rules are not used anymore")
> > 175e476b8cdf ("netfilter: x_tables: Use correct memory barriers.")
> 
> The second patch here says that it's only needed to go back until:
> 	    Fixes: 7f5c6d4f665b ("netfilter: get rid of atomic ops in fast path")
> 
> Which is only backported to 4.19.  So why do older kernels need that, is
> the fixes tag wrong?
> 
Where do you get that from ? 7f5c6d4f665b is, from what I can see, in v3.0.

$ git describe 7f5c6d4f665b
v2.6.39-rc1-159-g7f5c6d4f665b
$ git log --oneline v2.6.39..v3.0 | grep "netfilter: get rid of atomic ops in fast path"
7f5c6d4f665b netfilter: get rid of atomic ops in fast path

Thanks,
Guenter
