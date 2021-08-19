Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50D913F2127
	for <lists+stable@lfdr.de>; Thu, 19 Aug 2021 21:56:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229514AbhHST53 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Aug 2021 15:57:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231601AbhHST52 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Aug 2021 15:57:28 -0400
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03446C061575
        for <stable@vger.kernel.org>; Thu, 19 Aug 2021 12:56:52 -0700 (PDT)
Received: by mail-qt1-x82a.google.com with SMTP id d9so5558819qty.12
        for <stable@vger.kernel.org>; Thu, 19 Aug 2021 12:56:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bANW2RCtdy9VBEeiI3j/+3mwESh5TfgXMzY62Tyl/KY=;
        b=MIVsKPsX0m5oGzVZZ9BQazgNSDiHWSb1CCTfuTS8pwpQQx83c8kpTvaGcD194qOFKj
         8vrs6YFwpiNxPZcTD7+7EsCpPXlyABlxuo1ZsAnwHwfMz8SRAfw6SM6n4Gj7ncQLxlYg
         JOIl7OXEXudLAN9TjYPcF/AlO/CNcnedGTGdghxtxVggxtm6Fs5LksyYJqUlPjyIh3T2
         51Gz4VetvAV30nUmBVfOTZsfRwnxYp5K0jV5b4oNZZSZGf746vESMs395+mJ4oYtvNpE
         5OemqCCEh3KUH/xdocg9rR8atH3292fgfkF/ZnJP7GtH1sW6Gvtt86Po2FRD2VxWTFCV
         3I2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bANW2RCtdy9VBEeiI3j/+3mwESh5TfgXMzY62Tyl/KY=;
        b=HPmNhdxOdAhipzW8krjw83CbkGFea8xve4PbCGvfhwhAWHXFStX++QYXrE6sSXu1ty
         CjYrKU0T2aAlkCkdYf+aQ5wbP9npPgROiiCG0zTMfc82hGFgDOGvmwmQ9HO40kRgkrCO
         OgBcLGYuuphHas6kNNS2OWBwKkZN9fXAQz2G8uzorqu5jlILorjwOfWhDf3udon8h8dW
         s5l1wUQv23VhKgon68nqtJ+3Bx5of9cdtdqT8K8sHhsM7Oc0c/0nd/N+/41K7kyCVDXX
         7U4jmxXfdW5vjVevWe4BZl0zBC27MiCkduEUbjnNdzirMLI2JGJx7P6lz33CupVyj7LZ
         QYEg==
X-Gm-Message-State: AOAM530ySulQgK6ZEJ+QO9M2fTuxH4HfdOfMvtwQ5gtTp3CD/nGHsbNy
        aHUzf98ru8mCNDaL+hwSpWyxQESCRQsznR40ZPrGuA==
X-Google-Smtp-Source: ABdhPJwkuAoHR2v85paRVB6WkwhSPnm/ZbeEDoNIM89M/n93VBm5j94D1WVJvgGLl+kXHKm1BP20/nEUykvxwyNYHwU=
X-Received: by 2002:a05:622a:509:: with SMTP id l9mr14447454qtx.355.1629403010889;
 Thu, 19 Aug 2021 12:56:50 -0700 (PDT)
MIME-Version: 1.0
References: <20210819082414.39497-1-lma@semihalf.com> <87736cce-a96f-064e-6d60-71645ba46f13@linux.intel.com>
 <aeb40985-140f-b013-f368-778ad33fc7d0@intel.com> <50eb6c88-5f1a-7a42-adaf-da16f711e5c5@linux.intel.com>
In-Reply-To: <50eb6c88-5f1a-7a42-adaf-da16f711e5c5@linux.intel.com>
From:   Curtis Malainey <cujomalainey@google.com>
Date:   Thu, 19 Aug 2021 12:56:40 -0700
Message-ID: <CAOReqxiYYPgmAcN1RnVnOKziV+cnwD8nRCT_x3k7H3FeUW1SYA@mail.gmail.com>
Subject: Re: [PATCH v2] ASoC: Intel: Fix platform ID matching for kbl_da7219_max98373
To:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Cc:     Cezary Rojewski <cezary.rojewski@intel.com>,
        Lukasz Majczak <lma@semihalf.com>, upstream@semihalf.com,
        ALSA development <alsa-devel@alsa-project.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Curtis Malainey <cujomalainey@chromium.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 19, 2021 at 8:18 AM Pierre-Louis Bossart
<pierre-louis.bossart@linux.intel.com> wrote:
>
>
> >
> > Apart from that, Maxim codecs go by the name of 'max' in
> > sound/soc/codecs/. It's more intuitive to have equivalent shortcut used
> > in board's name.
>
> the ACPI HID start with MX and there's not much consistency in naming,
> is there?
>
>                 .drv_name = "kbl_r5514_5663_max",
>                 .drv_name = "kbl_rt5663_m98927",
>                 .drv_name = "kbl_da7219_mx98357a",
>                 .drv_name = "kbl_da7219_max98927",
>                 .drv_name = "kbl_max98373",
>
> Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

Agreed, it is definitely better to revisit and get it all in one go so
we don't end up with a cherry-picking nightmare

Acked-by: Curtis Malainey <cujomalainey@chromium.org>
