Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A54D3E2F89
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 20:57:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231816AbhHFS5u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 14:57:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229918AbhHFS5u (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Aug 2021 14:57:50 -0400
Received: from mail-qv1-xf2c.google.com (mail-qv1-xf2c.google.com [IPv6:2607:f8b0:4864:20::f2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F5E2C0613CF;
        Fri,  6 Aug 2021 11:57:33 -0700 (PDT)
Received: by mail-qv1-xf2c.google.com with SMTP id em4so5468923qvb.0;
        Fri, 06 Aug 2021 11:57:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HoLbeTTbQZVD0ezcQl6FigfEYZA+jZ1EgzCffFW5aUU=;
        b=IX+MbFHGhtgZbirStmqhB7qjlQHx2H+Zp2nfnXvpelTvOI/vywCx9aGnEnGEQrbX/p
         YbffPrr3xTmhpVcfWEZE5O5qCslFb8e/gRM3wuYpKmxQz4i6x9NdpaYkU+xJOnHG6h3z
         NqgQzJSibHDgqYL+do+OoGXLsctTGDX9IHFz6/IP1Lcjwqjrscqf3O1knQzaer6xMQqU
         3nMUgLplwS4btSmYsccpXjgxK5xucRJbl7EYEm09EejV70SoiOBZpJSQ+ltgZdWD1xbn
         3MOXeuzLeVYi76IamBd2qTmaUQbFprL9MlKJjNIUu5AVmAAGcB8VuL6hP2mZRL0BRQbU
         i1UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=HoLbeTTbQZVD0ezcQl6FigfEYZA+jZ1EgzCffFW5aUU=;
        b=kis2H/bevYKqyhnfJh/YSGvXv5cSYbG6lncMENcmaGb+xDdvGuodjPJBYrDiERLePa
         mMEHJqCflllWpOyuA6YywNJBeMKlLkvCTt4KBIRur31ikzCf/4PQ6QilL9NLLTXLDS6m
         yJn1B/isk8gZSYtbCiKmuZ+Hsyqp0Q6/U0lisD82mF5Nui+OUIVBsRquGTVheuje5N2Y
         XO+n1jwV0nfEe+X6FkRhlJki+Irr9dhHRBb++Mr2pUNEAXMq8LJlcpp5anLAACSZO7cb
         miiM/NeZjiHWDiRNF+xEyzdJhXCbeE0rgCjtsSqUT3KqYwU8OL0Vi/y9yGQ5mpMvbUTF
         Abaw==
X-Gm-Message-State: AOAM531HGkuij2Wlaoeg+shx67Bc31FOKOBMZjNf9AOAYOJOyPFV359Y
        MWc8GZ6m5t8oNFHR6eHitzY=
X-Google-Smtp-Source: ABdhPJyICH3nixDKojp7XgbHdRUl1XbOxrNxCNkloWMzJ/hpZUCav1e4f5Pa6C5PSZ6cgZTF/5LYlA==
X-Received: by 2002:a05:6214:8c6:: with SMTP id da6mr1433804qvb.18.1628276252386;
        Fri, 06 Aug 2021 11:57:32 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id h7sm3838203qto.22.2021.08.06.11.57.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Aug 2021 11:57:32 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 6 Aug 2021 11:57:30 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.4 0/6] 4.4.279-rc1 review
Message-ID: <20210806185730.GA2680592@roeck-us.net>
References: <20210806081108.939164003@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210806081108.939164003@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 06, 2021 at 10:14:32AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.279 release.
> There are 6 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 08 Aug 2021 08:11:03 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 160 pass: 160 fail: 0
Qemu test results:
	total: 340 pass: 340 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
