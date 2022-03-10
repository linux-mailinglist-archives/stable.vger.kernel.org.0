Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FA4E4D46E7
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 13:28:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238904AbiCJM3l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 07:29:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236984AbiCJM3k (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 07:29:40 -0500
Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 178EE81883;
        Thu, 10 Mar 2022 04:28:40 -0800 (PST)
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-2dc242a79beso55617497b3.8;
        Thu, 10 Mar 2022 04:28:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=snZoP7sl7VkI7M5r8Xvt/fOeXGE86JD/60mF+DvOOvE=;
        b=o1pP9lHa6twPddVoWHc5lih7b8sAxVUxEB1pIXX/bk9L+2MatT/Vi6GOdtreiTk186
         wxofuVU06cv5j3FrNRja+6VuhNFC+b0SPoMD8EyzlnLxZXwSPXQHo7/6L2lfaNwGyryB
         B9alEcMzGR6H/iT3I2kFBtt5YeSMqSdrOlY6+rW3PHZj+fKD6pgpB4yY0hWSpvZO1PcK
         g9gL5t1xqIwpDeEpOBhOanYActRXkHXcF3CuH0nyWgwIIKVVc/Yg1ETHDmFkTUPjRDUe
         Rljs/FS0QEtPIu5QPjCh+EkjnAsF9h7uDQwbIh27I/thu4vovP0YaDdCGijyeaCVFZC1
         dxSA==
X-Gm-Message-State: AOAM532j1BBvUgNptAh3UjtM+jIKeu/At0ZzHvSa8JNh9umx/02qnolO
        5mzgT0UmSGN7HDQNSScMnMr+2iN+iuXKuBFqjcE=
X-Google-Smtp-Source: ABdhPJwRPQ257+w8ePKtUjCuOyFrLbnN66vxBQuNF5f9Vh8YvBR+zw4sbhxdSGWoPS9SOmzmFUdt3O1ZYvffGTvPhOs=
X-Received: by 2002:a81:bd0:0:b0:2dc:184b:e936 with SMTP id
 199-20020a810bd0000000b002dc184be936mr3644651ywl.7.1646915319319; Thu, 10 Mar
 2022 04:28:39 -0800 (PST)
MIME-Version: 1.0
References: <CAJZ5v0gE52NT=4kN4MkhV3Gx=M5CeMGVHOF0jgTXDb5WwAMs_Q@mail.gmail.com>
In-Reply-To: <CAJZ5v0gE52NT=4kN4MkhV3Gx=M5CeMGVHOF0jgTXDb5WwAMs_Q@mail.gmail.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Thu, 10 Mar 2022 13:28:28 +0100
Message-ID: <CAJZ5v0h9WObwRMV+8ZeVwp5zA14y0WawYecPrVtrsmXUjN+-hQ@mail.gmail.com>
Subject: Re: Please revert commit 4287509b4d21e34dc492 from 5.16.y
To:     "Rafael J. Wysocki" <rafael@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        "Thorsten Leemhuis (regressions address)" <regressions@leemhuis.info>,
        Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I messed up the stable list address, sorry.

On Thu, Mar 10, 2022 at 1:26 PM Rafael J. Wysocki <rafael@kernel.org> wrote:
>
> Hi Greg & Sasha,
>
> Commit 4287509b4d21e34dc492 that went into 5.16.y as a backport of
> mainline commit dc0075ba7f38 ("ACPI: PM: s2idle: Cancel wakeup before
> dispatching EC GPE") is causing trouble in 5.16.y, but 5.17-rc7
> including the original commit is fine.
>
> This is most likely due to some other changes that commit dc0075ba7f38
> turns out to depend on which have not been backported, but because it
> is not an essential fix (and it was backported, because it carried a
> Fixes tag and not because it was marked for backporting), IMV it is
> better to revert it from 5.16.y than to try to pull all of the
> dependencies in (and risk missing any of them), so please do that.
>
> Please see this thread:
>
> https://lore.kernel.org/linux-pm/31b9d1cd-6a67-218b-4ada-12f72e6f00dc@redhat.com/
>
> for reference.
>
> Cheers!
