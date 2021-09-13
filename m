Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E773408AF2
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 14:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237538AbhIMMWL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 08:22:11 -0400
Received: from mail-oi1-f177.google.com ([209.85.167.177]:38856 "EHLO
        mail-oi1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239954AbhIMMWH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Sep 2021 08:22:07 -0400
Received: by mail-oi1-f177.google.com with SMTP id bd1so13741686oib.5;
        Mon, 13 Sep 2021 05:20:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6LkH8BDThjwDkIUVEv4G7HiQl/Op2m1UQzXKeVLvZVY=;
        b=ma69WOLkKY3N/lvfdKwQt+0BdJu/LcwtM/OlgQ4/XX++Id9tDEqc+1iWd+4WFdmUm4
         V8azZRY6GziVJ/fw+dDqt6NPsbMZHidNfurtxDoB/RbY00jH/ZIlD82gj+xIs7ULW1qL
         1DTTYsjssn1UONNlCdpoXy/TDB5+tZNv308+iNxlBiHWMM9JpVPexWvHtxTfvY9ylueq
         h8kfQJR7149stKgtllG1ojjx5zSnpG1csBNATS+kS3nsnq2BhHqTJizwyXkv2JUPojjL
         vgILFqxI6z4oNDK1ddR+Yc7SEJ0yV5dtnY49VH5NdJmAYALb4TYg7FW+K7m3acS3rG3z
         goYw==
X-Gm-Message-State: AOAM532ScLd47GzjMmkCi0tScxMUgxTyAjI2nyqiDi2KrRZjorqBUIxs
        cEJQOR6FEx0JG4lXCxio3DpXySooOtYWoGHSYZabRmdf
X-Google-Smtp-Source: ABdhPJx/9hiTq1jXolVCkmhHWNiQy0NxIAlRexLuKACbIOgNqoBUilaDDEqAUxmlsrQtCOTDiFmH1XeeM81nR7ywEYk=
X-Received: by 2002:aca:afcd:: with SMTP id y196mr7489386oie.71.1631535651501;
 Mon, 13 Sep 2021 05:20:51 -0700 (PDT)
MIME-Version: 1.0
References: <20210909120116.150912-1-sashal@kernel.org> <20210909120116.150912-24-sashal@kernel.org>
 <20210910074535.GA454@amd> <YTy/etsK39d/+Zhh@sashalap>
In-Reply-To: <YTy/etsK39d/+Zhh@sashalap>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Mon, 13 Sep 2021 14:20:35 +0200
Message-ID: <CAJZ5v0hze08S1ORK7Pwa3N5TBX5Jj=jeKqye=wv7dpzDArss3Q@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 4.4 24/35] ACPICA: iASL: Fix for WPBT table with
 no command-line arguments
To:     Sasha Levin <sashal@kernel.org>
Cc:     Pavel Machek <pavel@denx.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        Bob Moore <robert.moore@intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "open list:ACPI COMPONENT ARCHITECTURE (ACPICA)" <devel@acpica.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Sep 11, 2021 at 4:38 PM Sasha Levin <sashal@kernel.org> wrote:
>
> On Fri, Sep 10, 2021 at 09:45:36AM +0200, Pavel Machek wrote:
> >Hi!
> >
> >> Handle the case where the Command-line Arguments table field
> >> does not exist.
> >>
> >> ACPICA commit d6487164497fda170a1b1453c5d58f2be7c873d6
> >
> >I'm not sure what is going on here, but adding unused definition will
> >not make any difference for 4.4 users, so we don't need this in
> >-stable...?
>
> Ugh, dropped, thanks!
>
> I wonder what this patch actually does upstream.

There are AML compiler changes in it, but the compiler is not included
into the Linux kernel.
