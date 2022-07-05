Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A260C5669F9
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 13:41:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231181AbiGELlg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 07:41:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231840AbiGELlV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 07:41:21 -0400
Received: from mail-oa1-x34.google.com (mail-oa1-x34.google.com [IPv6:2001:4860:4864:20::34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90464167C1
        for <stable@vger.kernel.org>; Tue,  5 Jul 2022 04:41:20 -0700 (PDT)
Received: by mail-oa1-x34.google.com with SMTP id 586e51a60fabf-10c0e6dd55eso2890155fac.7
        for <stable@vger.kernel.org>; Tue, 05 Jul 2022 04:41:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oYkmYThUmCysQY8MJhgSpC49jZRND9DLg6lYEvAzo/w=;
        b=YRz8s6YI/tRs5LrCDJ+ZMuoXf9GqCKhxsVSby9Zcp4H8uQ5A2yb/0Zyi3ZxmajyUEn
         rXB3+bS0nUj0Uv6o5uuBrmYiERlF81Nvb51KBdR0r7hY7wo8OtX0ed9fwT44QMVXCyRf
         4YRQBDn41ZGe/NaZondIcPTCsWFRsHIT9MEuaGcl0p89eg2mHdNhxisIHwBle5quKFFg
         35tvqmKgSQEAn1tpY6/K6oyI3keIiubOiMPSX+troGgqjZAjKXxJpEfoeDhO5Tbu7xap
         RDBPkrFRJjsrHx9iYILzB65/Q6FmJEmAtjYQ2Knxx62hDotStnXtA60MqHI0J8Ho0UQu
         hoRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oYkmYThUmCysQY8MJhgSpC49jZRND9DLg6lYEvAzo/w=;
        b=HgaRGFjjq1O5kJBLRcfjPpNccEbneQHmIWFHBVeB0xeotXas8dWXHgBLwhDHtCRcMb
         gH+vM0kfvXdlr4XHfVz4r24uzGLg7wgP2fDNz5D7EH6y6ILAr4Pf/0Jod4UtrpBVB2J0
         HADxfsgu1LAhtmR8koQ/mfZTKLqVj7Tg6KO6KtosZ0JzY+zelYhN78i97y8GHV3zyTuk
         iDArwY/QCfecqJieYnZHWgwh4bMN/GSuY8F+a+5kYoBzigpeu4PZMAsDU/MTGV2qJVQx
         /ESmAe/jeyjy5bCJWTm/bg9YMHiSQHEfwx1Mo+uGkfwWtvokfu/IHPKdPURFMRAT3ZjS
         llkA==
X-Gm-Message-State: AJIora9cW5eIi6FXbTHwbpEWcST0IYdzPftFTyh0oNSUpKt2426uE8ii
        nezAtSy3lNqz0S/OiKfcAzMToy493ngM/Lv3MjI1Dmk2
X-Google-Smtp-Source: AGRyM1tv5+FPBNcRuoRK+CO7+QmgXnBvvkogXj4WwkeC9i72oRkBYRCrJ498YrpRaOcOUH+dr/B/x5r4fxEJGDxUfLo=
X-Received: by 2002:a05:6870:559d:b0:fe:3656:9c4f with SMTP id
 n29-20020a056870559d00b000fe36569c4fmr21641266oao.27.1657021279014; Tue, 05
 Jul 2022 04:41:19 -0700 (PDT)
MIME-Version: 1.0
References: <CAHkwnC9408BG+FBPM1NvrivxcPLf2+Sr_cZ74ir7SB5BrtFebw@mail.gmail.com>
In-Reply-To: <CAHkwnC9408BG+FBPM1NvrivxcPLf2+Sr_cZ74ir7SB5BrtFebw@mail.gmail.com>
From:   Fabio Porcedda <fabio.porcedda@gmail.com>
Date:   Tue, 5 Jul 2022 13:41:08 +0200
Message-ID: <CAHkwnC9SRrmTZSP0A86HtF5T0arN9hyzRm7SPf9aZpfWibNmNg@mail.gmail.com>
Subject: Re: Backport support for Telit device IDs to 5.15/5.10/5.4/4.19/4.14/4.9
To:     stable@vger.kernel.org
Cc:     Daniele Palmas <dnlplm@gmail.com>, jorgen.storvist@gmail.com,
        Carlo Lobrano <c.lobrano@gmail.com>
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

Il giorno mar 5 lug 2022 alle ore 13:32 Fabio Porcedda
<fabio.porcedda@gmail.com> ha scritto:
>
> Hi,
> Can you please backport the following commits in order to support new
> Telit device IDs?
>
> The following one just for 4.9:
> commit 1986af16e8ed355822600c24b3d2f0be46b573df
>   qmi_wwan: Added support for Telit LN940 series
>
> The following one just for 4.9:
> commit b4e467c82f8c12af78b6f6fa5730cb7dea7af1b4
>    net: usb: qmi_wwan: add Telit 0x1260 and 0x1261 compositions
>
> The following one just for 4.9:
> commit 5fd8477ed8ca77e64b93d44a6dae4aa70c191396
>     net: usb: qmi_wwan: add Telit LE910Cx 0x1230 composition
>
> The following one for 4.9/4.14/4.19/5.4/5.10:
> commit 8d17a33b076d24aa4861f336a125c888fb918605
>     net: usb: qmi_wwan: add Telit 0x1060 composition
>
> The following one for 4.9/4.14/4.19/5.4/5.10/5.15:
> commit 94f2a444f28a649926c410eb9a38afb13a83ebe0
>     net: usb: qmi_wwan: add Telit 0x1070 composition

Just a clarification,
I've not asked to backport all commits to all versions because some of
them were already backported.
So to have complete support only some of the commits need to be backported.

Regards
-- 
Fabio Porcedda
