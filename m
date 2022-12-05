Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D77B264281B
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 13:09:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231628AbiLEMJS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 07:09:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231327AbiLEMJF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 07:09:05 -0500
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4811FDF7C;
        Mon,  5 Dec 2022 04:09:03 -0800 (PST)
Received: by mail-qk1-f170.google.com with SMTP id j26so4725340qki.10;
        Mon, 05 Dec 2022 04:09:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6MIB3xvxCZJU4GWFyhSO9TpaK2tmBFBEo8wuA140FSA=;
        b=qYM2jVSoJMRmv1m9t02NFO4W/TeCC9/RAmPXjY9uiXFvXSD+T2odxmesKUykYK5Kqb
         RRBn4FPAoB2qBrjUyUMyx74OSFMvirMbZV+1FWk8CjjuqgTCFf8xTF1N7u48YaUosTMC
         5PIr46uvfkhQl7sk6LdzuTkZWQbEQ/CxWTNLHI8hIylVf+fAs/WiX4nk04xyqDARwMqr
         dOfLW6U2OE55phPWGpsK0yyHCJn+iqCEvv4fUYMh1FpnVDFINPOyRGcMh6VKpKyCirsW
         6ZsEDRc9B2ZThhHz+m8qGYD7pQTGHxWxtk+S2NkPmgM6DRPUfbSxrLGOEDfOotcJpt9p
         nbsg==
X-Gm-Message-State: ANoB5pkTGZSaYV6gYjpsnF2R3CnNSK13bCWY+nkpZvo/DuDX4z0c7cYK
        8n4U5FC7oSudcyvfS4Du6xYWF6UKPQtXEDu0F34=
X-Google-Smtp-Source: AA0mqf7FMTmERIGbZY2w/Q82ozUpwVdcf9Crh6uuy78ifwFCCa0OM9jDIT99xZgX8z/1kHUGB4tv5EJTfgsWNfg0mHM=
X-Received: by 2002:a05:620a:4611:b0:6fa:af7e:927c with SMTP id
 br17-20020a05620a461100b006faaf7e927cmr71338620qkb.443.1670242142398; Mon, 05
 Dec 2022 04:09:02 -0800 (PST)
MIME-Version: 1.0
References: <930778a1-5e8b-6df6-3276-42dcdadaf682@systemli.org>
 <18947e09733a17935af9a123ccf9b6e92faeaf9b.1669958641.git.viresh.kumar@linaro.org>
 <CAJZ5v0ixHocQbu6-zs3dMDsiw8vdPyv=8Re7N4kUckeGkLhUzg@mail.gmail.com>
 <CAJZ5v0hc8CsvqLKxi5iRq7iR0bkt25dRnLBd23mx-zdi2Sjgsw@mail.gmail.com> <20221205043044.bgecubnw7d3xlyi5@vireshk-i7>
In-Reply-To: <20221205043044.bgecubnw7d3xlyi5@vireshk-i7>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Mon, 5 Dec 2022 13:08:47 +0100
Message-ID: <CAJZ5v0gTV5LM_qRKncPq5Z2TRENMgVer6oZiGAKJn6ndrNSKxg@mail.gmail.com>
Subject: Re: [PATCH] Revert "cpufreq: mediatek: Refine mtk_cpufreq_voltage_tracking()"
To:     Viresh Kumar <viresh.kumar@linaro.org>
Cc:     "Rafael J. Wysocki" <rafael@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-pm@vger.kernel.org,
        Vincent Guittot <vincent.guittot@linaro.org>,
        regressions@leemhuis.info, daniel@makrotopia.org,
        thomas.huehn@hs-nordhausen.de, "v5 . 19+" <stable@vger.kernel.org>,
        Nick <vincent@systemli.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 5, 2022 at 5:30 AM Viresh Kumar <viresh.kumar@linaro.org> wrote:
>
> On 02-12-22, 20:46, Rafael J. Wysocki wrote:
> > On Fri, Dec 2, 2022 at 1:17 PM Rafael J. Wysocki <rafael@kernel.org> wrote:
> > >
> > > On Fri, Dec 2, 2022 at 6:26 AM Viresh Kumar <viresh.kumar@linaro.org> wrote:
> > > >
> > > > This reverts commit 6a17b3876bc8303612d7ad59ecf7cbc0db418bcd.
> > > >
> > > > This commit caused regression on Banana Pi R64 (MT7622), revert until
> > > > the problem is identified and fixed properly.
> > > >
> > > > Link: https://lore.kernel.org/all/930778a1-5e8b-6df6-3276-42dcdadaf682@systemli.org/
> > > > Cc: v5.19+ <stable@vger.kernel.org> # v5.19+
> > > > Reported-by: Nick <vincent@systemli.org>
> > > > Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> > >
> > > Do you want me to push this revert for -rc8?
>
> No, I was planning to make it part of my pull request.

Well, this was a bit unclear.

> > After all, I've decided to queue it up for 6.2, thanks!
>
> Can you please drop that ? AngeloGioacchino already reported that
> Reverting the proposed commit will make MT8183 unstable.

OK, dropped now.

> So the right thing to do now is apply the fix, which is on the list
> and getting tested.

Alright then, I'll assume that the proper fix will come in through
your pull request for 6.2 (but please send that one before the merge
window opens), thanks!
