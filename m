Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7AAD578543
	for <lists+stable@lfdr.de>; Mon, 18 Jul 2022 16:24:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235161AbiGROYS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jul 2022 10:24:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235286AbiGROYR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Jul 2022 10:24:17 -0400
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 163BE26FC
        for <stable@vger.kernel.org>; Mon, 18 Jul 2022 07:24:17 -0700 (PDT)
Received: by mail-ot1-x334.google.com with SMTP id g20-20020a9d6a14000000b0061c84e679f5so6597993otn.2
        for <stable@vger.kernel.org>; Mon, 18 Jul 2022 07:24:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=A1wTTiPfmCap2tbmVY87xryQYABdspdwvo9olRvpIZU=;
        b=nYgzeEWhQtnmBHSsWNg/UXiynd7bOTmXtHHn4WWH+myT2QQTfNfXNMRWCBAfa2PiUA
         stCkDMZ6IYCBNYeM1xeyLHY8BbfbMEkMWf6n7UqNr+YkJhAN3geH0cHUxZeE9wtMQY4Y
         qsFVCE7ga7aQcahDi1IMQMuRauf033b5Xre6I3pfLVF7rUipUQHg7z5M+EjLJ6k8z85S
         N9GLIDohyz2wm1mBFevudJJkstHOmIbABkzPbFESGC3Sm8hKFJlPHfEdI0ku11Mz3i+T
         r4+kLyr5fOX+R4qz3jUsua1C+7+rcXhpQ+ItIp5fGhzsdOYk4ZSui9tiF8nXgEuuj4Te
         5Iog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=A1wTTiPfmCap2tbmVY87xryQYABdspdwvo9olRvpIZU=;
        b=YS1orUpzIc3IoSDwFaln9T91POU9PmDsq8YejaP+J6R8V4VE4BkV3an9+0FX3B/JZ4
         gX3wn5mpnMLIKZcOSg4eMFYT2s8Y11aTp6HWB1jJepvpIEBsl2uiepf9aM41yvfzAkNb
         0ib+kc21QLqWZ6bq6khvp3L0H1Bk9CMCSebnYJ19UujDx6ZHqmpoV1ZW7rYxXwnypyr4
         Zu12qm6vGUfYhZ5lCOczChbC0urlvEgacVgJX1JpQlHJPAuPkvsTdbNWrhHWZ8drokpr
         VYRxuoOI0U9ps857e0Rpw36yzV4qnOBPn/zrOakPrmJYDqxROOYAwUPyNv1+EtLIwfRP
         qHiA==
X-Gm-Message-State: AJIora9hv/ulzHYXGGo6nVxjzctLWeiWwa8etTnPBT7ot3DzEN/Upy40
        tKyJUKC+9y2pwUsYB7HPjK6e5i+kpFY62/2Wzz7zL6AyeRU=
X-Google-Smtp-Source: AGRyM1s9KgFLHcQrkNA4wLEeg1r7WOFlhoNCLEghhIuFzibJIDnF6GlJYdL1LHUmrvefSMuIfgUycebwIVAPpmnvstQ=
X-Received: by 2002:a05:6830:6613:b0:61c:acf8:8e41 with SMTP id
 cp19-20020a056830661300b0061cacf88e41mr691258otb.298.1658154256335; Mon, 18
 Jul 2022 07:24:16 -0700 (PDT)
MIME-Version: 1.0
References: <20220718121335.386097-1-Fabio.Porcedda@telit.com> <YtVqtV9UFBaofP/k@kroah.com>
In-Reply-To: <YtVqtV9UFBaofP/k@kroah.com>
From:   Fabio Porcedda <fabio.porcedda@gmail.com>
Date:   Mon, 18 Jul 2022 16:24:05 +0200
Message-ID: <CAHkwnC8PDn_7fsx=_1RS8MkVRgLgn2dTQAgyK64dA_8V1VfjoA@mail.gmail.com>
Subject: Re: [PATCH 0/2] Backport support for Telit FN980 v1 and FN990 for 3.18
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Il giorno lun 18 lug 2022 alle ore 16:14 Greg KH
<gregkh@linuxfoundation.org> ha scritto:
>
> On Mon, Jul 18, 2022 at 02:13:33PM +0200, Fabio Porcedda wrote:
> > Hi,
> > these two patches are the backport for 3.18.y of the following commits:
>
> 3.18.y is long end-of-life, what about all of the newer kernels on the
> front page of www.kernel.org that we currently support?
>

There is a typo, they are for 5.18.y, but please take the newer version:
[PATCH v2 5.18 0/2] Backport support for Telit FN980 v1 and FN990

Thanks

-- 
Fabio Porcedda
