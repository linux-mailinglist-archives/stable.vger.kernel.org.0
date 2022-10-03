Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D5615F3286
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 17:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230171AbiJCPaM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 11:30:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230177AbiJCPaF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 11:30:05 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F3FD120AB
        for <stable@vger.kernel.org>; Mon,  3 Oct 2022 08:30:03 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id sd10so23007360ejc.2
        for <stable@vger.kernel.org>; Mon, 03 Oct 2022 08:30:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=d9UrCsDBkzNA3eaVqs/Yvrmvozo9hy+a3Cr3vs3yoy8=;
        b=P3s+UYH6PZ9MielVCA/ELdNcoyPTgLEXS8h0T4mKK2Y+XNh4+2PXgQZpLeaqiTGvjj
         ZTn5rq1t6UY0nkF97/8mTMzNW+l/vhwLS8HBJteqDWD7pxdMSvnm0DB9IpIyTEfsPqgA
         z8MpDWVJTnNQvH8JGxyHi2Bbm+G6Cp1MXQQco=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=d9UrCsDBkzNA3eaVqs/Yvrmvozo9hy+a3Cr3vs3yoy8=;
        b=3lr47wlXOOpEwjwy9bvcQklPpGljIuB+HLngPLTQITb0CyFm14+ONouRN3F/1Z+Z7E
         yBP6B/jrDTTerQhwjI9/9x5UOhshfxRMYsdoKHS7/K06AMfQFDtijN2Dd1j5sKufVX17
         iLNq53o9oZdCR+U4fMZexgOSLP2XHqzI77wMA46woTHMdy8UJ7BzCjI1KHFHgYH1g1j9
         toTLS5K/yvQMjBeo2KgRINLgb+MBqlHskmk80EAwQoHjkCTleJnrQG2PAIBosTB4SgT2
         yt70jVzXgOn53nzsFnc10DLzt5eK+vYy+jhLJMjTPTXN6ZonhlThjzCKegaU8f1aAhDM
         XGcw==
X-Gm-Message-State: ACrzQf2Vz+d5to3KTDqET/NCE1ukaLgawch08DrfUaENiXsxKk1Hj+Wq
        yLYhYrgrfHOI7ebsKVqQneM2byV8g2svq1kW
X-Google-Smtp-Source: AMsMyM5yHMq3aTMSA9a2BYVVoUTHLsCXh+RZCgN+lF3t2mrBDVyvK+TXk+1N9PYxRU1odv53ry59yg==
X-Received: by 2002:a17:907:7704:b0:780:da38:4480 with SMTP id kw4-20020a170907770400b00780da384480mr15543316ejc.64.1664811001445;
        Mon, 03 Oct 2022 08:30:01 -0700 (PDT)
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com. [209.85.221.54])
        by smtp.gmail.com with ESMTPSA id r4-20020aa7cfc4000000b0044f21c69608sm7630309edy.10.2022.10.03.08.29.58
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Oct 2022 08:30:00 -0700 (PDT)
Received: by mail-wr1-f54.google.com with SMTP id j7so11930576wrr.3
        for <stable@vger.kernel.org>; Mon, 03 Oct 2022 08:29:58 -0700 (PDT)
X-Received: by 2002:a5d:522f:0:b0:228:dc7f:b9a8 with SMTP id
 i15-20020a5d522f000000b00228dc7fb9a8mr13932917wra.617.1664810998116; Mon, 03
 Oct 2022 08:29:58 -0700 (PDT)
MIME-Version: 1.0
References: <20220930182212.209804-1-krzysztof.kozlowski@linaro.org>
 <CAD=FV=WHmGi0yxFNbdQ=BXjypDWkW9iS3jBnr2gUhTa5qch90Q@mail.gmail.com> <76b3269a-1e04-1e93-c06e-ec0f28536cc5@linaro.org>
In-Reply-To: <76b3269a-1e04-1e93-c06e-ec0f28536cc5@linaro.org>
From:   Doug Anderson <dianders@chromium.org>
Date:   Mon, 3 Oct 2022 08:29:43 -0700
X-Gmail-Original-Message-ID: <CAD=FV=WPrLNhJHhcutykGsE5rDCvxxPGcgqboWP6Oqs+Kw+M5Q@mail.gmail.com>
Message-ID: <CAD=FV=WPrLNhJHhcutykGsE5rDCvxxPGcgqboWP6Oqs+Kw+M5Q@mail.gmail.com>
Subject: Re: [PATCH 1/3] arm64: dts: qcom: sdm630: fix UART1 pin bias
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

On Sat, Oct 1, 2022 at 2:58 AM Krzysztof Kozlowski
<krzysztof.kozlowski@linaro.org> wrote:
>
> > I would also note that convention on Qualcomm SoCs that I've worked on
> > was that bias shouldn't be specified in the SoC dtsi file and should
> > be left to board files. This is talked a bit about in a previous email
> > thread [1].
>
> Uh, that makes a lot of sense. It is almost always a property of a board.

Right, though it can make sense to have a "default" in the SoC
sometimes. For instance, for i2c you almost always want external
pullups so you can tune them to the speed/trace lengths. Thus having a
default in the SoC file to disable i2c pullups would make a lot of
sense. The problem is the ugly / non-obvious "delete-property" we need
to put in the board.dts file if we ever need to override the SoC's
pull. :(

I actually remember this not being a problem in Rockchip SoCs. I guess
it's because they end up having an extra level of indirection. I guess
there's no great way to do that for Qualcomm without changing the
bindings.


> > That being said, it does look like this was the intention of the
> > original commit, so thus:
> >
> > Reviewed-by: Douglas Anderson <dianders@chromium.org>
>
> Thanks.
>
> I can also drop the property entirely to match existing behavior (not
> the intention).

Hopefully someone who cares about this board can test and let you know
either way.


> > [1] https://lore.kernel.org/lkml/CAD=FV=VUL4GmjaibAMhKNdpEso_Hg_R=XeMaqah1LSj_9-Ce4Q@mail.gmail.com/
