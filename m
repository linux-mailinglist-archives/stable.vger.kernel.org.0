Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CEBC441D45
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 16:20:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231893AbhKAPW4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 11:22:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232565AbhKAPWt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Nov 2021 11:22:49 -0400
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52154C061767
        for <stable@vger.kernel.org>; Mon,  1 Nov 2021 08:20:16 -0700 (PDT)
Received: by mail-qv1-xf34.google.com with SMTP id a24so2491651qvb.5
        for <stable@vger.kernel.org>; Mon, 01 Nov 2021 08:20:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jgF4WNQrvefaG8B+tebEp1rynHelm7z/AaepfeRZkXQ=;
        b=fmW0SdYFSg5MtLWL/0zags99pGVnwpgwRm5vDJHb3wYvlYziVYTNWPN8G5zcxLCrqI
         /gx+ROKTFYc//RjoCrzQILaCnKL1DK6gc9qwODjIp9n9Rvf6Ij0kXqEcOrjGebuQX8JE
         DfFDjOwFMvbEtgagQb0eNsT2Nx9xN1GMYcA3Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jgF4WNQrvefaG8B+tebEp1rynHelm7z/AaepfeRZkXQ=;
        b=kUxQxpKsbIeOwfBLcFXZ0tZe13BE717O04nLhlUtT2A7xisJExignw8nv/S6g84MtQ
         PJBQuok9DTsKfWYdnXkYunLft4gmT3UxytUEOn1wras9UXLNECwG/xIyQn06lU4Vlssm
         chT9M71qZwRPfYBHzLYSc6T4bBHq8MnksbowZpsMaqQdtsgrdWPEVGMm5SnCti8MGvJO
         YQnaYfYrL2Ew0OWJb9GP5aB/UXftR/LpsfwNa/vgIWt8R9m3i4R9wuSfKReCQL0dRX/9
         q5Arc5tU1cIdYQROAa1dgZjuSTDxCLMyULdFixFzvNRuVnXG/j1h41d3HkPZ0L0izlkb
         T3OQ==
X-Gm-Message-State: AOAM532sgxYy4sjn3U23qKFIfAzEVKBi4S6g4QqAt8RDboSo4SjBFFNC
        O3a+vBVmm0rcRlkctoFDhaIqVQ==
X-Google-Smtp-Source: ABdhPJzti6ivMZHpWRWC4eMOiW08wSGefivInQ8jGvVwc+y5Hs3FSv3oRUwokVm/W1dIrT+HYGcVfQ==
X-Received: by 2002:ad4:5c4f:: with SMTP id a15mr29155081qva.26.1635780015500;
        Mon, 01 Nov 2021 08:20:15 -0700 (PDT)
Received: from meerkat.local (bras-base-mtrlpq5031w-grc-32-216-209-220-181.dsl.bell.ca. [216.209.220.181])
        by smtp.gmail.com with ESMTPSA id m20sm7761955qkp.57.2021.11.01.08.20.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 08:20:15 -0700 (PDT)
Date:   Mon, 1 Nov 2021 11:20:13 -0400
From:   Konstantin Ryabitsev <konstantin@linuxfoundation.org>
To:     mike chant <mikechant@gmail.com>
Cc:     webmaster@kernel.org, stable@vger.kernel.org
Subject: Re: https://www.kernel.org/category/releases.html possible
 significant typo?
Message-ID: <20211101152013.bbs3siqa5aezy247@meerkat.local>
References: <CALNuP9Eo7nVW2vTm1pWNVQemyxn9GF6TNFgAVPxgXXb_vo5vtA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CALNuP9Eo7nVW2vTm1pWNVQemyxn9GF6TNFgAVPxgXXb_vo5vtA@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 01, 2021 at 02:43:31PM +0000, mike chant wrote:
> Hi,
> The table of LTS releases on this page shows an EOL date of October 2023
> for 5.15. Judging by the other EOL dates, shouldn't this be 2027?

LTS releases are generally supported for 2 years UNLESS someone steps up and
offers to help support it for longer.

With further questions, please email stable@vger.kernel.org.

Regards,
-K
