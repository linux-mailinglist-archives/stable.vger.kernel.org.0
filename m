Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 801525F3980
	for <lists+stable@lfdr.de>; Tue,  4 Oct 2022 01:04:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbiJCXD7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 19:03:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbiJCXD6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 19:03:58 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A21B14B0EF
        for <stable@vger.kernel.org>; Mon,  3 Oct 2022 16:03:57 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id w10so3688344edd.4
        for <stable@vger.kernel.org>; Mon, 03 Oct 2022 16:03:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=bf85Y7QWUflPRKNopNNgeEY91n+Y6Cpq/wQC5HOqkXU=;
        b=AOmXi4bRpj8PW6QyiAqysm6jN3Pabej1ANo/kRw3lKF1j1jIaNOb1yCKkhn9B1jek9
         xnv/OzfZFFXmiuHgn5JpSMEuuijzO+wvPpA+cclemXOMSSj+Mt0YEM4QeebiMZYl9oon
         4PxFxKIydZJOYc7PeCbXoACB2IbGV6V+Hgp4Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=bf85Y7QWUflPRKNopNNgeEY91n+Y6Cpq/wQC5HOqkXU=;
        b=lUVGo8/uZWeLg0DE8eBAngLTroYRjCgo8I4jhd3LzTep/BcTjbpKzq/IGj5tvVztmZ
         SwLCaSavgHM2CFv6PGmmHNnarY2QQhNTXqivzyKx1kitI7XwoV1t1500fmfe3ity45CQ
         DGEpaaaUeU1YSbKfpRTFXGYlIACRxzgkmZHPW1wa7vbHtgprDL1OQS1B5vfaU9CMQegY
         eBmO+Glb4NcCgV9eIhN+f0Yed36DBGY900F+5N7iwg64yu/yyC+GeLKPpFmpQg/q0T9o
         NmHMh6WGAKIQLVMV3LALNpIAiZwk3NxzeI8habc3m8TWsAwn/dTqjZ95WtLN5qWjPpWV
         SAmQ==
X-Gm-Message-State: ACrzQf1+eOQSD0HCUrrufuiGR2E5AIcyhhu4aFQt2aaMYn465M8zj7y3
        ByEphNKuaQu0tS0Ec7niedOUupYe8Wcqc/uC
X-Google-Smtp-Source: AMsMyM7ia0RINxOfpBM5JLj28qa9fEoK/CYEy1AXp5OZGVnUkQMjGUgtjcahm0C7zIOCdpLeaxNHpw==
X-Received: by 2002:a05:6402:1686:b0:459:4ddf:8f05 with SMTP id a6-20020a056402168600b004594ddf8f05mr784292edv.375.1664838236021;
        Mon, 03 Oct 2022 16:03:56 -0700 (PDT)
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com. [209.85.128.49])
        by smtp.gmail.com with ESMTPSA id h13-20020a1709063c0d00b0073dbfd33a8dsm551377ejg.21.2022.10.03.16.03.54
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Oct 2022 16:03:55 -0700 (PDT)
Received: by mail-wm1-f49.google.com with SMTP id e18so7883027wmq.3
        for <stable@vger.kernel.org>; Mon, 03 Oct 2022 16:03:54 -0700 (PDT)
X-Received: by 2002:a05:600c:1e18:b0:3b3:b9f8:2186 with SMTP id
 ay24-20020a05600c1e1800b003b3b9f82186mr8614592wmb.151.1664838234177; Mon, 03
 Oct 2022 16:03:54 -0700 (PDT)
MIME-Version: 1.0
References: <20220930182212.209804-1-krzysztof.kozlowski@linaro.org>
 <20220930182212.209804-2-krzysztof.kozlowski@linaro.org> <CAD=FV=WSbpV4aqyHgSX6rwanQmZYG1hdNourjP5DEmsfdq6aDA@mail.gmail.com>
 <11a99a84-47ec-ca3e-5781-0f17ed33dbf9@linaro.org> <CAD=FV=URMX9umJfqYOhnnnjsr09As-6mKAHs0YNZFK8n2K337g@mail.gmail.com>
 <c0bf359a-1ee9-04e2-2c58-9e7e8f3e12f7@linaro.org>
In-Reply-To: <c0bf359a-1ee9-04e2-2c58-9e7e8f3e12f7@linaro.org>
From:   Doug Anderson <dianders@chromium.org>
Date:   Mon, 3 Oct 2022 16:03:42 -0700
X-Gmail-Original-Message-ID: <CAD=FV=WmXbBvnC_phmTNRfYa68TObOYVRQWe-X4kv4aQPD5rFg@mail.gmail.com>
Message-ID: <CAD=FV=WmXbBvnC_phmTNRfYa68TObOYVRQWe-X4kv4aQPD5rFg@mail.gmail.com>
Subject: Re: [PATCH 2/3] arm64: dts: qcom: sdm845-db845c: correct SPI2 pins
 drive strength
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Rob Clark <robdclark@chromium.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "# 4.0+" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Mon, Oct 3, 2022 at 10:57 AM Krzysztof Kozlowski
<krzysztof.kozlowski@linaro.org> wrote:
>
> On 03/10/2022 17:40, Doug Anderson wrote:
> >>>>
> >>>> diff --git a/arch/arm64/boot/dts/qcom/sdm845-db845c.dts b/arch/arm64/boot/dts/qcom/sdm845-db845c.dts
> >>>> index 132417e2d11e..a157eab66dee 100644
> >>>> --- a/arch/arm64/boot/dts/qcom/sdm845-db845c.dts
> >>>> +++ b/arch/arm64/boot/dts/qcom/sdm845-db845c.dts
> >>>> @@ -1123,7 +1123,9 @@ &wifi {
> >>>>
> >>>>  /* PINCTRL - additions to nodes defined in sdm845.dtsi */
> >>>>  &qup_spi2_default {
> >>>> -       drive-strength = <16>;
> >>>> +       pinmux {
> >>>> +               drive-strength = <16>;
> >>>> +       };
> >>>
> >>> The convention on Qualcomm boards of this era is that muxing (setting
> >>> the function) is done under a "pinmux" node and, unless some of the
> >>> pins need to be treated differently like for the UARTs, configuration
> >>> (bias, drive strength, etc) is done under a "pinconf" subnode.
> >>
> >> Yes, although this was not expressed in bindings.
> >>
> >>> I
> >>> believe that the "pinconf" subnode also needs to replicate the list of
> >>> pins, or at least that's what we did everywhere else on sdm845 /
> >>> sc7180.
> >>
> >> Yes.
> >>
> >>>
> >>> Thus to match conventions, I assume you'd do:
> >>>
> >>> &qup_spi2_default {
> >>>   pinconf {
> >>
> >> No, because I want a convention of all pinctrl bindings and drivers, not
> >> convention of old pinctrl ones. The new ones are already moved or being
> >> moved to "-state" and "-pins". In the same time I am also unifying the
> >> requirement of "function" property - enforcing it in each node, thus
> >> "pinconf" will not be valid anymore.
> >
> > Regardless of where we want to end up, it feels like as of ${SUBJECT}
> > patch this should match existing conventions in this file. If a later
> > patch wants to change the conventions in this file then it can, but
> > having just this one patch leaving things in an inconsistent state
> > isn't great IMO...
> >
> > If this really has to be one-off then the subnode shouldn't be called
> > "pinmux". A subnode called "pinmux" implies that it just has muxing
> > information in it. After your patch this is called "pinmux" but has
> > _configuration_ in it.
> >
>
> It is a poor argument to keep some convention which is both
> undocumented, not kept in this file and known only to some folks
> (although that's effect of lack of documentation). Even the bindings do
> not say it should be "pinconf" but they mention "config" in example. The
> existing sdm845.dts uses config - so why now there should be "pinconf"?
> By this "convention" we have both "pinmux" and "mux", perfect. Several
> other pins do not have pinmux/mux/config at all.
>
> This convention was never implemented, so there is nothing to keep/match.
>
> Changing it to "config" (because this is the most used "convention" in
> the file and bindings) would also mean to add useless "pins" which will
> be in next patch removed.

I certainly won't make the argument that the old convention was great
or even that consistently followed. That's why it changed. ...but to
me it's more that a patch should stand on its own and not only make
sense in the context of future patches. After applying ${SUBJECT}
patch you end up with a node called "pinmux" that has more than just
muxing information in it. That seems less than ideal.

-Doug
