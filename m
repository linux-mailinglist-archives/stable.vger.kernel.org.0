Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91D7D5EDC6
	for <lists+stable@lfdr.de>; Wed,  3 Jul 2019 22:45:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726821AbfGCUpK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jul 2019 16:45:10 -0400
Received: from mail-qk1-f176.google.com ([209.85.222.176]:38785 "EHLO
        mail-qk1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726739AbfGCUpK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Jul 2019 16:45:10 -0400
Received: by mail-qk1-f176.google.com with SMTP id a27so3955554qkk.5
        for <stable@vger.kernel.org>; Wed, 03 Jul 2019 13:45:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7jfoJulpZ3av+CWSobOFbw1+FZbkUoS528EhmxChYH0=;
        b=b1e7ZkX9RcyqiFoOm9B3TcspPOtcAgAzNGx7VRSiIQBgAUoCbuO3jAZewzr+veGf+E
         iusG2iF7A3F6oBRxaveGpVwJwlm4kad9lKxLPQfh12FI+aHd0GjcCbG45BtV/Os3qS1M
         9+27BU3kTrYRlZ9FBVmiRKdZmTUK5KQdiKhLoR2bhM2aUpXziJIutMWjmTlWbnYmzgBP
         ztSWoNUMj+7ug919N9sMeTLvZG2AKI0bK89rqPhZXaQruw6sm9M7lZS8IFyZ+0+hooiK
         LpVCXyPh/1J2VKn1WhN9kLI0ESWNNNLD4O5Edg18JaTV6nKfTFS3on+s679JIyHYzkRT
         CJFA==
X-Gm-Message-State: APjAAAVobMrfJyMWYLTfhuZZflP12MBL2VSfTgOOQ5af+YfQM1+CwWto
        P3EPEgn2ioNJPNLrAeAuFRr417+pdU2GlKGHaHTP2GNP
X-Google-Smtp-Source: APXvYqxzN5JgOiKSOuM3qMrBYawgase8nWOhIic7P7UUfkkU99FUfz/1uCohcgHxfglJHBaXApa3LG2k/m1YV5i7gT0=
X-Received: by 2002:a37:5f45:: with SMTP id t66mr21025193qkb.286.1562186709140;
 Wed, 03 Jul 2019 13:45:09 -0700 (PDT)
MIME-Version: 1.0
References: <CAK8P3a2yqf5WK37mud7k4oFn95rTJRqpOdZ+v6zJ-9xM0u11zw@mail.gmail.com>
In-Reply-To: <CAK8P3a2yqf5WK37mud7k4oFn95rTJRqpOdZ+v6zJ-9xM0u11zw@mail.gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Wed, 3 Jul 2019 22:44:51 +0200
Message-ID: <CAK8P3a09fiCLQdOJUC8QofBtHK=nytitDu8y1jFa02bDFEW2cg@mail.gmail.com>
Subject: Re: [STABLE-4.4] proposed backports
To:     "4.4.y backports" <stable@vger.kernel.org>
Cc:     gregkh <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 3, 2019 at 10:17 PM Arnd Bergmann <arnd@arndb.de> wrote:

> 67fc5dc8a541 ("MIPS: VDSO: Include $(ccflags-vdso) in o32,n32 .lds builds")

This one was wrong: the patch is already there, but we still get the
same build warning that it was supposed to fix, same on 4.9 and 4.14

       Arnd
