Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77A833B1D4E
	for <lists+stable@lfdr.de>; Wed, 23 Jun 2021 17:12:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbhFWPOa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Jun 2021 11:14:30 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34550 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230061AbhFWPOa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Jun 2021 11:14:30 -0400
Received: from mail-pg1-f197.google.com ([209.85.215.197])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <guilherme.piccoli@canonical.com>)
        id 1lw4Xz-0001sZ-N1
        for stable@vger.kernel.org; Wed, 23 Jun 2021 15:12:11 +0000
Received: by mail-pg1-f197.google.com with SMTP id k193-20020a633dca0000b029021ff326b222so1608376pga.9
        for <stable@vger.kernel.org>; Wed, 23 Jun 2021 08:12:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FQ1lxetv+3BZNbno6lOBPgoS9Kn2GSDJ2QWiqsfxNsw=;
        b=Tj1LSPsm6k6HrPBIPym3jlCOKG4kyFH6IDgEdveNHy6VA6nKYapdrjdujfH9XhtvUm
         +gog9MThQyKspeUlDK1faWbMdQSHFhUGmQeZqzRn0vSLQEjm+WLFkzAfuLiy81VYVd1K
         ieHp/AvD421BfHC0hYwg6xh8xPtuE52j6751JZWKuGFsdqLbXqY89rkQCnbiAoe1yaWk
         d4LGFtHi36yQ4BNGq1D8DTDdfIcDawn1GtPkxzQGyj/X0I3wrS8Pr5UjlQu3EQWHaqxa
         segNTvE50XnknX8vtZwQslmk22qzM+XGiRXU1K1xFws+7LNm/XQGp2cUuRz0O0yW7tF7
         Jwyg==
X-Gm-Message-State: AOAM5313QoKn6tenlrBVnlYg2n4XAXxMu6Rj0kv+nstKseafdIYDDb+7
        fV0n+EA670y+WMLBSt2TCgQnBSpr8kB0fUBiPlQlALCq679KQSt6fyZTJj3rDAeENmMK+Rf5bMg
        BF7/VMBigtnAj70TtHbbLw+poPwypxCWL7bo/QNHGkVQz6i/iow==
X-Received: by 2002:a17:90a:ce09:: with SMTP id f9mr7152458pju.47.1624461130502;
        Wed, 23 Jun 2021 08:12:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJynds0LwqcGSa2Q9vtda3ZO10HZQobfq/y/PyU6qnlmYhEeXwYinuvJqOpYmR/E5aZj6ExoOIOcBBC+y4/QiMs=
X-Received: by 2002:a17:90a:ce09:: with SMTP id f9mr7152399pju.47.1624461129845;
 Wed, 23 Jun 2021 08:12:09 -0700 (PDT)
MIME-Version: 1.0
References: <20210622210622.9925-1-gpiccoli@canonical.com> <20210622210622.9925-2-gpiccoli@canonical.com>
 <YNNL7z4IvnFfDOTT@kroah.com>
In-Reply-To: <YNNL7z4IvnFfDOTT@kroah.com>
From:   Guilherme Piccoli <gpiccoli@canonical.com>
Date:   Wed, 23 Jun 2021 12:11:34 -0300
Message-ID: <CAHD1Q_xuq5MAcdySZAsWR80htsHf=TvuLoNY15VkpuG7J0csxQ@mail.gmail.com>
Subject: Re: [4.14.y][PATCH 2/2] unfuck sysfs_mount()
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     "# v4 . 16+" <stable@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Thanks a lot Greg!
