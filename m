Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A180A43BB31
	for <lists+stable@lfdr.de>; Tue, 26 Oct 2021 21:47:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237168AbhJZTtp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Oct 2021 15:49:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237048AbhJZTto (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Oct 2021 15:49:44 -0400
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D87FC061570;
        Tue, 26 Oct 2021 12:47:20 -0700 (PDT)
Received: by mail-ot1-x330.google.com with SMTP id 107-20020a9d0a74000000b00553bfb53348so334617otg.0;
        Tue, 26 Oct 2021 12:47:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DXWMMLn1jRLTu6/iftH1kZac+MY/G0+LGV82jEMyIzQ=;
        b=DfSvMh8oGMNhkknTuesBLCsCbyP6xR1SWzr6ieYfkqYyro+eguJh0REOPnpkf2UiFg
         jKXj2Kgy8WfpEelumWYQRCHI4G6Xz0evCldAcOYFZNZinZ03p/hJqVrOlTk4COBpRtif
         eZ+isA3rGUJuyZbrYezA8rJgnzNbsG1pHV2vdgeBoPxvvS4s6VHvOCXbwr92VAYXyKdU
         6Jezgm0EEMOE64O6ZPA/G0ZzdiljN9NkJyDFiBKSBEJvE3HPGcA0CPyQcs8c27Q0SD68
         pkeeGG+tRVkPROV+2bq6IZ65mTdKtmtiactBr5VVUTAy4VvQvKfxra6f/TUBFvm0iLRL
         Uorw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=DXWMMLn1jRLTu6/iftH1kZac+MY/G0+LGV82jEMyIzQ=;
        b=7QdccM7CB/x7FefipWeWxMnA8P2xfxIWOsK3br3r9NdckU6ElTiwHLJ3LXJ+VeJ4LT
         WsvBBbxquCR3bDmqV2cgtPS5KZxq5SYDgjjKI4oKG9WpnayInKpHIa7GCxK0M5CRochX
         PIE7yl18oEvSk0dtcyT4rCxfq6wwEirIdtOTs3t4MiGnVZNcJumofi9Duu4FnFO92kvR
         ZVTQNfhIdR9qbUGLa2EoR5kjGOsTP9yslt7K1VaLxZ7OYSGE/GacVlXtDpTrSdjZfx/u
         rzicIVyGvno4r5YfBt2j/oytbgSqB8DLVFUEtOIFLx+RJuXjQm+rwmMc+mrdhqLD2kLd
         SEdw==
X-Gm-Message-State: AOAM530l7cJHz7Ilfwy25d74/HeEiNciH9YRIFgjte4xIXJ+3guvXwNu
        WQSYWpUgJkD2c6ENmKhhNlY=
X-Google-Smtp-Source: ABdhPJxvYYcpzF7mjIi+fVdMWP+2NrOQVXSHQZe9+ExtMZPJrcyg+VPZDkoGy0JknnI6bmZwEB3GoA==
X-Received: by 2002:a05:6830:402c:: with SMTP id i12mr21038074ots.319.1635277639804;
        Tue, 26 Oct 2021 12:47:19 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id c17sm5169133ots.35.2021.10.26.12.47.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Oct 2021 12:47:19 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 26 Oct 2021 12:47:17 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/44] 4.4.290-rc1 review
Message-ID: <20211026194717.GA2041460@roeck-us.net>
References: <20211025190928.054676643@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211025190928.054676643@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 25, 2021 at 09:13:41PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.290 release.
> There are 44 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 27 Oct 2021 19:07:44 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 160 pass: 160 fail: 0
Qemu test results:
	total: 339 pass: 339 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
