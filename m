Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 116FF65B91
	for <lists+stable@lfdr.de>; Thu, 11 Jul 2019 18:30:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728463AbfGKQak (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Jul 2019 12:30:40 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:35005 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728405AbfGKQak (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Jul 2019 12:30:40 -0400
Received: by mail-io1-f65.google.com with SMTP id m24so13934458ioo.2
        for <stable@vger.kernel.org>; Thu, 11 Jul 2019 09:30:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=s1PNfjIv4q2GKA580mQ1tu3y5QbK1n3IiJClY5acdEk=;
        b=emCfsojTl6dG/z/5g7abKUQutN+YQtndfLO3yBka4B3iPwm5jW1o05k2OwxAUygHu9
         10yxZTFEN29FWIFogXE0kbIKpvoECgnzre+66+JWLypIfUitA2mBnQoAs2rwOXAiz2jb
         tkYL7hPVTfvxi497J2aaes2OP3OVFCWa3b+sM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=s1PNfjIv4q2GKA580mQ1tu3y5QbK1n3IiJClY5acdEk=;
        b=K8ec4fzumf+PesnXjmCd83JRkxxVhIyUlceE0K2ddPJ0IHcNmX/rpgxcNM48YbkNGT
         0A0hGTt77Y4yBtHVWDAo+FJWwXfh7w7waDvdlxcXXaw04g+4qiW8KoOfEIlTUVlCCQQC
         giAXdyLPEZ6T3UOg2rZBAqG2lX3mWXGDnCVXfR5Nqzp6tLKiS0+LJtZ1o+qsk0aYxYB0
         O9OT14NyODBJr4u2pmve3F46dyatwGwQ31M3FAABvUc4EFFKOq+2jw/TNmnvp6qhYiBb
         hW7grRjwhQtbsE4MjF5pARrWwuBDMjFMEe0EVzTH7+6Lc5M/6OniAT20Mcm1owFuWyS2
         gJzA==
X-Gm-Message-State: APjAAAVufuVVhpcNCr2Ati/ZfKIT37QrbVdv9VpgX+irXk9y3z4FVb4I
        y9ZuC1qRBPY43TJljVN1Ya9C9RlsY/s=
X-Google-Smtp-Source: APXvYqxE8fwcd1raFim5LV8QMa67zQ1LZ/Y1ocG+xFyumWgKX74IhBWttzYnmK6pa0kYYXiMhn/N6Q==
X-Received: by 2002:a6b:621a:: with SMTP id f26mr870491iog.127.1562862639305;
        Thu, 11 Jul 2019 09:30:39 -0700 (PDT)
Received: from mail-io1-f54.google.com (mail-io1-f54.google.com. [209.85.166.54])
        by smtp.gmail.com with ESMTPSA id c81sm7763805iof.28.2019.07.11.09.30.38
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Jul 2019 09:30:39 -0700 (PDT)
Received: by mail-io1-f54.google.com with SMTP id s7so13812311iob.11
        for <stable@vger.kernel.org>; Thu, 11 Jul 2019 09:30:38 -0700 (PDT)
X-Received: by 2002:a5d:885a:: with SMTP id t26mr1922506ios.218.1562862638257;
 Thu, 11 Jul 2019 09:30:38 -0700 (PDT)
MIME-Version: 1.0
References: <1562844916142167@kroah.com>
In-Reply-To: <1562844916142167@kroah.com>
From:   Doug Anderson <dianders@chromium.org>
Date:   Thu, 11 Jul 2019 09:30:25 -0700
X-Gmail-Original-Message-ID: <CAD=FV=XEE1J6Kx28eV_zi8_oV68qQsmKW8Os2A3_ade1KsBFdg@mail.gmail.com>
Message-ID: <CAD=FV=XEE1J6Kx28eV_zi8_oV68qQsmKW8Os2A3_ade1KsBFdg@mail.gmail.com>
Subject: Re: FAILED: patch "[PATCH] tpm: Fix TPM 1.2 Shutdown sequence to
 prevent future TPM" failed to apply to 4.19-stable tree
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Vadim Sukhomlinov <sukhomlinov@google.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        "# 4.0+" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Thu, Jul 11, 2019 at 4:35 AM <gregkh@linuxfoundation.org> wrote:
>
>
> The patch below does not apply to the 4.19-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
>
> thanks,
>
> greg k-h
>
> ------------------ original commit in Linus's tree ------------------
>
> From db4d8cb9c9f2af71c4d087817160d866ed572cc9 Mon Sep 17 00:00:00 2001
> From: Vadim Sukhomlinov <sukhomlinov@google.com>
> Date: Mon, 10 Jun 2019 15:01:18 -0700
> Subject: [PATCH] tpm: Fix TPM 1.2 Shutdown sequence to prevent future TPM
>  operations

Posted at:

https://lkml.kernel.org/r/20190711162919.23813-1-dianders@chromium.org
