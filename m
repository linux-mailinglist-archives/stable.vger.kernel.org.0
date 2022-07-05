Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB07D566AEE
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:03:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233313AbiGEMDG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:03:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233393AbiGEMCg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:02:36 -0400
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81AAA2678
        for <stable@vger.kernel.org>; Tue,  5 Jul 2022 05:02:31 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id r82so15925255oig.2
        for <stable@vger.kernel.org>; Tue, 05 Jul 2022 05:02:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=D+zGmOIGUk0g/OJEteeytXyb/Ac+wRFqlw+yBe19vPQ=;
        b=g7cBSo6BEKXgifjfH+SP2dIfS3UNti/um3XmPbuH+lZYkmCrOaiKxUWITMxC7r3sku
         64ctbDSCqks1f+/y9VhcfvvYK+kuFrWJzF74a7q6H0oB1XTLXvyrZKCccZJLIHaR81ix
         G69ZmdjPqYAmB1xe8NDv7xa91IhJM4D3e9zsNXhc4KYMLn235dycLKswjPfadqjeuPA/
         eL7oiZt73b+CAm+3BdacoAsvdkRwHIwUGde3KsHxvHHTSSwbtGuPzfqcN4fD2HALeYu9
         GLZNuq2KOJ64b/gnhC7rk3fLl/1f7gVJ4zLO5TEnppUkxgnknkd7rDHn/Qy8rZ24xrg0
         gDng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=D+zGmOIGUk0g/OJEteeytXyb/Ac+wRFqlw+yBe19vPQ=;
        b=AKShNMP85ZsNfvpAJDQ4hLsSWl+5g4KPuzwojjg68M1oTDm0F6oDlRxWke47Qb1lZl
         QatyI5DfJ/oO7fijiLWbGv1M6C4aFssXtZOE+ADg8Xo/cb73BMv5mX1lL9N+yLHb/QsA
         H18s9xXVuX/Q2tJsIM5lCSiQlUJquiFpDa6XRUuMnGG7RTN9ksSp/zffEFnTh6yhrYfP
         ufyBreornqiin7qOQE3fgFrlPA2cad69fYwKKQoNOWGj5d/8pT3WNiRIbBC9Zm5Nl4sy
         5XI5gtON26fKA0TjodsnmfLacWJin9o/zY13oLObjJnTzmZK1WBzJuUiLDs6DLCmNyBu
         74Og==
X-Gm-Message-State: AJIora9jT+UiGopJCEpskf9t7j96i9/LpDKw1IrARqR1Ugc2ypvd4S63
        wjIK66Xv3+AELpN3BDeZdMmsxW7Nchs6vPOMFR0=
X-Google-Smtp-Source: AGRyM1svlEoQQC7BadS8adFxWqsyte1RkUSp9znbMC+DOsD3PZIcrtvLQiig85bTOxAEXMKGzDsoiA3qHbpj/qTZDlA=
X-Received: by 2002:a05:6808:bcb:b0:337:9b08:9b79 with SMTP id
 o11-20020a0568080bcb00b003379b089b79mr11175675oik.27.1657022550784; Tue, 05
 Jul 2022 05:02:30 -0700 (PDT)
MIME-Version: 1.0
References: <CAHkwnC9408BG+FBPM1NvrivxcPLf2+Sr_cZ74ir7SB5BrtFebw@mail.gmail.com>
 <YsQj3dIMxZcGYb70@kroah.com>
In-Reply-To: <YsQj3dIMxZcGYb70@kroah.com>
From:   Fabio Porcedda <fabio.porcedda@gmail.com>
Date:   Tue, 5 Jul 2022 14:02:19 +0200
Message-ID: <CAHkwnC8bADw6d=H6XyMYHz0oyfN52nM20MMRoNgh6kbfG8Rvgw@mail.gmail.com>
Subject: Re: Backport support for Telit device IDs to 5.15/5.10/5.4/4.19/4.14/4.9
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Daniele Palmas <dnlplm@gmail.com>,
        jorgen.storvist@gmail.com, Carlo Lobrano <c.lobrano@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Il giorno mar 5 lug 2022 alle ore 13:43 Greg KH
<gregkh@linuxfoundation.org> ha scritto:
>
> On Tue, Jul 05, 2022 at 01:32:34PM +0200, Fabio Porcedda wrote:
> > Hi,
> > Can you please backport the following commits in order to support new
> > Telit device IDs?
> >
> > The following one just for 4.9:
> > commit 1986af16e8ed355822600c24b3d2f0be46b573df
> >   qmi_wwan: Added support for Telit LN940 series
> >
> > The following one just for 4.9:
> > commit b4e467c82f8c12af78b6f6fa5730cb7dea7af1b4
> >    net: usb: qmi_wwan: add Telit 0x1260 and 0x1261 compositions
> >
> > The following one just for 4.9:
> > commit 5fd8477ed8ca77e64b93d44a6dae4aa70c191396
> >     net: usb: qmi_wwan: add Telit LE910Cx 0x1230 composition
> >
> > The following one for 4.9/4.14/4.19/5.4/5.10:
> > commit 8d17a33b076d24aa4861f336a125c888fb918605
> >     net: usb: qmi_wwan: add Telit 0x1060 composition
> >
> > The following one for 4.9/4.14/4.19/5.4/5.10/5.15:
> > commit 94f2a444f28a649926c410eb9a38afb13a83ebe0
> >     net: usb: qmi_wwan: add Telit 0x1070 composition
>
> All queued up now, but you REALLY should move off of 4.9.y at this point
> in time as it is going to be dropped from support pretty soon and you
> should not be using that for any new hardware types.

Thanks for the feedback, I agree with you, I just want to improve the
support as much as possible even for projects that use old versions.

Regads
-- 
Fabio Porcedda
