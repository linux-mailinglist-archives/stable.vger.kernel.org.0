Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CED5A105253
	for <lists+stable@lfdr.de>; Thu, 21 Nov 2019 13:35:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbfKUMfZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Nov 2019 07:35:25 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:39928 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726230AbfKUMfY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Nov 2019 07:35:24 -0500
Received: by mail-lf1-f67.google.com with SMTP id f18so2498302lfj.6
        for <stable@vger.kernel.org>; Thu, 21 Nov 2019 04:35:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PBvjvtlJ3gmdO3Q5JhnFS2hqB/M5iofUn1lQwwxOIjE=;
        b=SkYHXvllDV1ADo5PBRcCQG0Vws0MwcwgXWHXjCpL9riuGA8sz7qQ2TlkpOHNFUwPEE
         Mew83iBW7G9NNFavnaLQKuVEB/sf00oyrYY6yQkHjPk33uP6lgdnxDpuNLI9OM8e28wn
         fvOVq2fOKJWKVu0QlEQbgGh3MrViEhN9DTZiFHJ2QnyQhZwDymBAs0JIBWmGVhs5uapW
         b8+wZbQlWGtKlLFQnDkzusY2iRru0fLV8uhACfFfoOjE5VE7lsBrn++DxXUFddfjEl4v
         HlbngJ8t2CPmtI+31NNJuhrER4CUWIdAPgyb81sjIuQmsi7+ns33aHlzys/q7arnfIPt
         Ipkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PBvjvtlJ3gmdO3Q5JhnFS2hqB/M5iofUn1lQwwxOIjE=;
        b=hepv1pHx7Q6Hoa2/iqkkWSNMiM7PdxQ8ZIzHq9ZFXpQgelBgQssKH4NHqGJpm2zC4M
         ai9Ls6UqeLPJep9BZxIKQ/zGMMvBA5QDUu/C+1NG0wUBaDq5OXR4JrAWOEZ4EXVAtpAf
         oXqGL4CG4FxdXExBS8tTbY7v52DPu8Pz+q4rBuDZ7CVtR7u5DGUzaBQPz50lU/k0xiGL
         WxOfXWY1vK+joX3j36daI1FyWkiOZwq4l12qVN+6HVxtMF05ScA+rMaFfNFUWr4PR3wi
         9MTpypY/Wm0YM8Uj0wnagpqZg5ZKP3OUKAAL/WFtS9ATZSFqi+2fyrUkX3nq3QJZSviX
         d8Lg==
X-Gm-Message-State: APjAAAXVIBkRL6XtT/rbyvs2VH+KmxXAH+8r/7fc+/+3QkxHx/pF5gja
        EbOYFCNpi6I9RHmkj0/14aKgd52p3VOePh+vt7ro/Q==
X-Google-Smtp-Source: APXvYqxGJGGj+DEWqGSQXlorg9LyvjDcxFmHWNq+E7FgvjoQ0UR0VT+OsOjfFjvBWfUQyCZqN4LnMCva1+nFoSZK3KM=
X-Received: by 2002:a19:7d02:: with SMTP id y2mr7054946lfc.86.1574339722680;
 Thu, 21 Nov 2019 04:35:22 -0800 (PST)
MIME-Version: 1.0
References: <CACgcjHEHxzBkiE6hH3OEUw6V+PZHX7MAKht61OZPbAyAVRDQiQ@mail.gmail.com>
In-Reply-To: <CACgcjHEHxzBkiE6hH3OEUw6V+PZHX7MAKht61OZPbAyAVRDQiQ@mail.gmail.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Thu, 21 Nov 2019 13:35:10 +0100
Message-ID: <CACRpkdZB4XDTpv9YSdpdaqkAESpw99zw25GsZrNgZeC1GH1NQQ@mail.gmail.com>
Subject: Re: [PATCH 4.4] gpio: make the gpiochip a real device
To:     Yama Modo <zero19850401@gmail.com>
Cc:     stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hu Yama & friends,

thanks for your patch!

On Thu, Nov 21, 2019 at 12:49 PM Yama Modo <zero19850401@gmail.com> wrote:

> Dear Linus Walleij,
>
> I want to backport commit ff2b13592299 "gpio: make the gpiochip a real
> device" to linux 4.4.y. Could you please review the following patch? I
> will improve this later if something need to take care. Thanks!

Super cool, and I bet you have a good reason for wanting the new
GPIO framework on elder kernels, like being able to create drivers
and userspace that can be used on newer kernels seamlessly.

But I think you are confusing Greg, because the stable kernel is
by definition intended for fixing instabilities, I would say make it
publicly available for people who want it and need it, but unless
it is fixing an instability for users, it will not be stable kernel
material.

Yours,
Linus Walleij
