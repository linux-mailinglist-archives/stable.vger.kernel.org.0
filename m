Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D1173FEE90
	for <lists+stable@lfdr.de>; Thu,  2 Sep 2021 15:21:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244365AbhIBNWA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Sep 2021 09:22:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234181AbhIBNWA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Sep 2021 09:22:00 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 934E2C061757
        for <stable@vger.kernel.org>; Thu,  2 Sep 2021 06:21:01 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id i6so2867684edu.1
        for <stable@vger.kernel.org>; Thu, 02 Sep 2021 06:21:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PeIryWcCeZkXTwiSf9pQ7jls9/EfRS26Sz5/IPcRxMk=;
        b=ljxvfTa06S/BzW+viuyp6s4kI4jkFrYai1dI1vsA8OajVAXAa5IaEUOGrgvriBsqHv
         Hs/n0BTurHPWza7sEX/CzRQjH78wrCYxI5ZyyP65Y9Y1gu4iLvtTkwFlpc9/qGDWFu58
         bD/7fYZFiBx1l3qPg2GQYfwt9noEuTAgVOQTZGoriXpVCuOmfR6FFOk4otYD5vexfo3+
         moLx+IWovjGmQPhnreDwewWygSuV7lhophne+mL3XOmPYgSbRgsoYwmMxkssDa5VJfzr
         XsIakbUOVG24yFSd2grGR5S162uJA1k4VhxNR/PR8iL4SU9kXCI23hq4J7CXDDG8JLju
         R8kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PeIryWcCeZkXTwiSf9pQ7jls9/EfRS26Sz5/IPcRxMk=;
        b=g3lUPNvF9KTlJpYZZdBIHl7F5T1eE+rhvJ+ysxiWGXCK+v6YaknbUEASzd2aawRVpq
         4OTakXnHFhQTui+ELwCldBS2ArFzk+dP6aYutD3YzbAcC9oz+qVmoUc5oCp7uy1JJfh9
         ry55V0GVxMi+1G5hKgu7moiMfuee3jxy11NuQbAmi09SuqNQyG8alQCf0zscwEzoe85N
         YimEcBSb0Pkx9MvzqEvzpGsSLRiGOLNsKk3LyYDsVpDpitUEPCH8HGisI39tSNuAmEBL
         ZUfTcUdcC8UU74oHYpsmLjSo+yYJd6y3eAcuU1//RirU1bGiVE/7rT1KeJj7AKv6TWIX
         Ehpg==
X-Gm-Message-State: AOAM532k5ulftV/hlFEfo2X+1u09EZpnN/gXbICjyLIRcX9kqOZeA14+
        bTRz64Do6Z3DdaHaNi1WYDHk3joMfNob6/E72UDvcw==
X-Google-Smtp-Source: ABdhPJwpok/HKYNNaoKpcQK/BFFcLzrSloesjj1IAvo70hlTRvP2+339Mbs+wIXWPV6q9zbGTTTln8keb8RIEm2pAtI=
X-Received: by 2002:a05:6402:152:: with SMTP id s18mr3460597edu.221.1630588859954;
 Thu, 02 Sep 2021 06:20:59 -0700 (PDT)
MIME-Version: 1.0
References: <20210824165607.709387-1-sashal@kernel.org> <20210824165607.709387-127-sashal@kernel.org>
In-Reply-To: <20210824165607.709387-127-sashal@kernel.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 2 Sep 2021 18:50:48 +0530
Message-ID: <CA+G9fYveOoHUydWRjRWtKcF3smTXt3F3ChxuZuDSoxCkDA1rPw@mail.gmail.com>
Subject: Re: [PATCH 5.13 126/127] fs: warn about impending deprecation of
 mandatory locks
To:     Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        linux-stable <stable@vger.kernel.org>,
        Jeff Layton <jlayton@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 24 Aug 2021 at 22:35, Sasha Levin <sashal@kernel.org> wrote:
>
> From: Jeff Layton <jlayton@kernel.org>
>
> [ Upstream commit fdd92b64d15bc4aec973caa25899afd782402e68 ]
>
> We've had CONFIG_MANDATORY_FILE_LOCKING since 2015 and a lot of distros
> have disabled it. Warn the stragglers that still use "-o mand" that
> we'll be dropping support for that mount option.
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  fs/namespace.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/fs/namespace.c b/fs/namespace.c
> index caad091fb204..03770bae9dd5 100644
> --- a/fs/namespace.c
> +++ b/fs/namespace.c
> @@ -1716,8 +1716,12 @@ static inline bool may_mount(void)
>  }
>
>  #ifdef CONFIG_MANDATORY_FILE_LOCKING
> -static inline bool may_mandlock(void)
> +static bool may_mandlock(void)
>  {
> +       pr_warn_once("======================================================\n"
> +                    "WARNING: the mand mount option is being deprecated and\n"
> +                    "         will be removed in v5.15!\n"
> +                    "======================================================\n");

We are getting this error on all devices while running LTP syscalls
ftruncate test cases
on all the stable-rc branches.

- Naresh
