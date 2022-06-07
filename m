Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9404B540468
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:10:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345574AbiFGRKO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:10:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345540AbiFGRKM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:10:12 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C26D09270B
        for <stable@vger.kernel.org>; Tue,  7 Jun 2022 10:10:10 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id r1so3602561ybd.4
        for <stable@vger.kernel.org>; Tue, 07 Jun 2022 10:10:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=P/gAWYTYcE9jrOxJP6iVGHeZQzn3G/Awl1C3CYU0ggw=;
        b=VXII/SB83wb/H7vaEllfp+qolXwA53Jspz/m3zQC+mAcIKQGnMclloaomhvdrQ8owB
         vHO+Uly527y09F5DuLehOkJ0mwZ30gZgyk4g+U2wxwHl0Y4mgV7S9RqtLgSETdNyx6OK
         8wsp+Y0MkbwvJsfsXmdr6DrYRUD/m0pnxwbu4ivj1VDOAf7zsCj+Ktal0VQ7rxQPrYRu
         evoywSOsVTSGWCD45fXiF7PxxA2UqM85zCTd9mNp4mxBdN1I/K+pmrs8z9//RXW9UQ6Z
         9+tq5ACnviSi88l2ctFEs/bsJAV9hXkEtq0QnXCfz7aME/5cbdjMuehnAIQURMtCzTDA
         gtAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=P/gAWYTYcE9jrOxJP6iVGHeZQzn3G/Awl1C3CYU0ggw=;
        b=0gHcW7OyNwwydV73o815g/S+rr/J9VRNCL41c0zJ6v5FgYo1pVedEMmTYX7MD+lwBi
         4x8TWqjye266XKGQfLglxWBFvZaIeVF24cFdw+xs9vDbUER1ey3VPzSeWKCX9ZLMYW19
         iR816Oggh2SGIhvP4hLhlIjdXDfcwhBKUk1hz1Ci1FijnUMhSMxcBliKOzklbvHlm9Ov
         9//kl8Bj8DPOo1/3SQoNLK+ESTLEd/nSUe/Zn97SUaTbobL0lNA520n+tDw73lYBtTKa
         Q7MRfiripfaZezYaO7qwzcOaIxJ49roHOAbeOSSTEFtxbjPbXOgqHZI82laliHkdP7eI
         5O/A==
X-Gm-Message-State: AOAM530+LXzx38pPRNh1kFs1sKB2/Y2s3gEPqiQTEFEakljBH5fIAmIs
        sDHaG79kMVaIqpKCqIEt4Vzu66qYJOqbS/USs6cXEhUNdgAVCA==
X-Google-Smtp-Source: ABdhPJxpq/x/7JkNme4htfnqYHKUS7ec2XhW2i49YnLrj8HJECrnh2rhb90mOqlSloG8c/1l1755jAZFUZHfIMAjA2o=
X-Received: by 2002:a25:22d7:0:b0:663:c13a:893a with SMTP id
 i206-20020a2522d7000000b00663c13a893amr7638158ybi.98.1654621809618; Tue, 07
 Jun 2022 10:10:09 -0700 (PDT)
MIME-Version: 1.0
From:   Yongqin Liu <yongqin.liu@linaro.org>
Date:   Wed, 8 Jun 2022 01:09:54 +0800
Message-ID: <CAMSo37WW9veYH6=tHqUR2pa_7YX1UuzHqLBHit60P2QyzQmCEw@mail.gmail.com>
Subject: Please help cherry pick four mmc related changes into the 4.14 stable kernel
To:     stable@vger.kernel.org
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Benjamin Copeland <benjamin.copeland@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        =?UTF-8?B?RGFuaWVsIETDrWF6?= <daniel.diaz@linaro.org>,
        Alistair Delva <adelva@google.com>,
        Steve Muckle <smuckle@google.com>,
        Todd Kjos <tkjos@google.com>,
        "Bajjuri, Praneeth" <praneeth@ti.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Anders Roxell <anders.roxell@linaro.org>,
        linux-mmc@vger.kernel.org, linux-block@vger.kernel.org,
        Ulf Hansson <ulf.hansson@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, All

With the 4.14.281 version[1], there were three mmc related changes merged,
but that causes one boot failure with the X15 Android builds, a problem
similar to one reported before here[2].
After being confirmed with Ulf Hansson, and verified with the X15 Android build,
it needs to have the following four commits cherry-picked to the 4.14
branch as well.

    4f32b45c9a2c mmc: core: Allow host controllers to require R1B for CMD6
    5fc615c1e3eb mmc: core: Respect MMC_CAP_NEED_RSP_BUSY for erase/trim/discard
    d091259b8d7a mmc: core: Respect MMC_CAP_NEED_RSP_BUSY for eMMC sleep command
    23161bed631a mmc: sdhci-omap: Fix busy detection by enabling
MMC_CAP_NEED_RSP_BUSY

The above four commits are from the 4.19 branch, as they are a little
easier to be cherry-picked
into the 4.14 branch, compared to the commits from the mainline branch.
(I have confirmed that the four commits are all in 4.19, 5.4, 5.10 and
mainline branches already).

Saying that, there will be still one merge conflict reported when
cherry picking the commit of
4f32b45c9a2c, it's easy to resolve though.
To avoid the merge conflict, it could be done like this as well:
1. revert the 327b6689898b commit from 4.14 first, so that the commits in step#2
    could be cherry-picked without any problem
        327b6689898b mmc: core: Default to generic_cmd6_time as
timeout in __mmc_switch()
2. git cherry-pick the following commits from 4.19 into the 4.14 branch
        4f32b45c9a2c mmc: core: Allow host controllers to require R1B for CMD6
        5fc615c1e3eb mmc: core: Respect MMC_CAP_NEED_RSP_BUSY for
erase/trim/discard
        d091259b8d7a mmc: core: Respect MMC_CAP_NEED_RSP_BUSY for eMMC
sleep command
        23161bed631a mmc: sdhci-omap: Fix busy detection by enabling
MMC_CAP_NEED_RSP_BUSY
        26c6f614cf02 mmc: mmc: core: Default to generic_cmd6_time as
timeout in __mmc_switch()
    The last commit of 26c6f614cf02 is for the revert in step#1.

I am not sure which way is more convenient for the maintenance work
here, so just list both of them here
for your information.
And please let me know if there is anything else I could help on this
cherry pick work here.

[1]: https://lore.kernel.org/lkml/16534624745741@kroah.com/T/
[2]: https://lore.kernel.org/lkml/CA+G9fYuqAQfhzF2BzHr7vMHx68bo8-jT+ob_F3eHQ3=oFjgYdg@mail.gmail.com/
-- 
Best Regards,
Yongqin Liu
---------------------------------------------------------------
#mailing list
linaro-android@lists.linaro.org
http://lists.linaro.org/mailman/listinfo/linaro-android
