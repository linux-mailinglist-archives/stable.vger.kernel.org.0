Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F277F142D85
	for <lists+stable@lfdr.de>; Mon, 20 Jan 2020 15:28:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726642AbgATO2H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jan 2020 09:28:07 -0500
Received: from mail-vk1-f196.google.com ([209.85.221.196]:37000 "EHLO
        mail-vk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726626AbgATO2G (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jan 2020 09:28:06 -0500
Received: by mail-vk1-f196.google.com with SMTP id b129so8589472vka.4
        for <stable@vger.kernel.org>; Mon, 20 Jan 2020 06:28:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=benyossef-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Oks3v5r4LX6AsSe/R0iC47ZeQKYFHo5w4hpUercnPGI=;
        b=Kn+yW0NbC92FNLFs0j3ktGOE+Nja3EMth9Q2ArUiVlR9Si1mcW1DL0X+8UEQpOl+Gc
         eV55kxqJ4FN7nGCOxLg4H+Nj39qvZ4SpZy27aVEvpxgdVcvStfKa2oskZMY8lY27thtC
         BmUFNq61Sut0kvCt7oK/F6tOGm3MiAtGs/5x4ZBLbClayE5OKHFs/XFVIVZyo9LsqeTP
         cJ/OM9XCql+RfNZlKsbLvgVgFlIoR397BZJDBqsbVMW3an3pJeh+xO5hEheZn5rQH5Ck
         AZl8hvGfpsB5juQgkaf7mmsjVh+BtvjcLKmSGHpRDHY1ZhYQZ+iWH1zKyCJqho7cQKIJ
         9paA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Oks3v5r4LX6AsSe/R0iC47ZeQKYFHo5w4hpUercnPGI=;
        b=WmpPimQEfGKyeejt9Pxx3pfrN04fAofHFqu4LvnzQ5xu3lZW8Xo+vBQR2HIYz0eOn4
         U0D8qEIBhe0PwASRn0JJVfMkLohzH3jAPFvexzvmVbz+3Ji/YV3RcIoS35KgvVmsHDSf
         baZQ//FPP8S7o5SSoKUmiCQnvJygmStRCUvpY3ASimSJOdJAfcQHaF/dYQLHWcbTFGNu
         VUhADN5EZjwZI0kwyFmAO7Y6XKwpqrRVL1XQ1yYm1k55O2ZKLP8IevzKLiAwnOoBP4No
         sAgGcJYtvxV4a6zZh8WItGPI3ZHLU8i19F8oBfYjGJ1GctZVDz6FO9Y9hwP9L4I6pO6Y
         Bj+A==
X-Gm-Message-State: APjAAAVqptThfJ4nzoboQOkF3ctaT74DJRxFjLUraWUteJ6LyW39Vqtf
        V8S8fUuw7w2xU9bqLqpdsuDhv+fV2T5feTM0hcSa4Q==
X-Google-Smtp-Source: APXvYqy93Q9TGJxGdhUNmkvjv0kKK+3YZVpJNtUTugODqJn5Cbjt+fmBBQ7E6NMR6WKCq9I+k425y0g1IXA8rVJwy6c=
X-Received: by 2002:a1f:2a95:: with SMTP id q143mr1056687vkq.2.1579530485860;
 Mon, 20 Jan 2020 06:28:05 -0800 (PST)
MIME-Version: 1.0
References: <20200116101447.20374-8-gilad@benyossef.com> <20200119152653.6E37B20678@mail.kernel.org>
In-Reply-To: <20200119152653.6E37B20678@mail.kernel.org>
From:   Gilad Ben-Yossef <gilad@benyossef.com>
Date:   Mon, 20 Jan 2020 16:27:52 +0200
Message-ID: <CAOtvUMeJLUhPWP00h6h+LcGSvu+=CsHcbZ7OXzXHwWJd2R0agg@mail.gmail.com>
Subject: Re: [PATCH 07/11] crypto: ccree - fix FDE descriptor sequence
To:     Sasha Levin <sashal@kernel.org>
Cc:     Ofir Drang <ofir.drang@arm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hadar Gat <hadar.gat@arm.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha,

On Sun, Jan 19, 2020 at 5:26 PM Sasha Levin <sashal@kernel.org> wrote:
>
> Hi,
>
> [This is an automated email]
>
> This commit has been processed because it contains a -stable tag.
> The stable tag indicates that it's relevant for the following trees: all
>
> The bot has tested the following trees: v5.4.13, v4.19.97, v4.14.166, v4.9.210, v4.4.210.
>
> v5.4.13: Build OK!
> v4.19.97: Failed to apply! Possible dependencies:


'm looking into making a patch for v4.19.y. The rest are not relevant

Thanks,
Gilad
