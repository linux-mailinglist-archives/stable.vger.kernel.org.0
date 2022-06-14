Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC97654BE10
	for <lists+stable@lfdr.de>; Wed, 15 Jun 2022 01:02:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237349AbiFNW7u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 18:59:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232358AbiFNW7t (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jun 2022 18:59:49 -0400
Received: from mail-vk1-xa31.google.com (mail-vk1-xa31.google.com [IPv6:2607:f8b0:4864:20::a31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6856252E59
        for <stable@vger.kernel.org>; Tue, 14 Jun 2022 15:59:47 -0700 (PDT)
Received: by mail-vk1-xa31.google.com with SMTP id x6so1854361vkn.2
        for <stable@vger.kernel.org>; Tue, 14 Jun 2022 15:59:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vM3hUIqV6GzTZw2JQdHrr/xY9WsFc8Ipd1pHHNgip50=;
        b=LAyJM/PbEC+8sejshSsCJDFIq2MgElScjKmgVuFCSHaWwpkVWNz7rRE4MZLGwzK9DP
         TGfbqq2dmJ2qYuJUuIjVwRdxlRLNLXzPmuhE044asJG7toE+/xTvZgD+olRdOwcpmar2
         wAvijV7m5YK0Qu0oP1NkyZirYZTs8U93/TO4XSUV02+z2EfMejcEaN/5wqET3YAqGmKu
         eK+MjSTOI+WJ7o0c6Vy8LlrzuMgpyl5ZkFvQSRfk4WhRKCCD9clDov9lCo8l67P7mcZc
         jBpbYe/0vtog47h2NZx4U5501d4OjaoDpmDlmHh276JYRG9+YcsYDr2JfF6YGYUCQMy3
         oo8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vM3hUIqV6GzTZw2JQdHrr/xY9WsFc8Ipd1pHHNgip50=;
        b=uiKi5vuYDE/lM8iWWBPMzwVN+kTFfEHPw86ZxpAkk55EyGiDbrKuW1xbQfA5WCC9lt
         jPhk2Fxn7qz3BS/KR+n79BsiNHKCxjXXG2ZxjWRhnEsDnc+IuIiglp35xUSr+EAkNn9U
         uYx1wlg0PVB+BS69pXlSl4DaUy2j6nVLQN1DspY+aj4bVU+ufQ+FuKyyu0O/etdzicWr
         qSzBOdY1R44PD/kYwGLuRxtC4nul4GV2p4lFTcweRpsSExmX6DxqwomQ7Kh463tgIwI2
         30aX2EBqgCM7rD3/dfW7IvpoM9Ba2eMWhE5FZ8XpmViXZK86Z58Zd7SPDFZMEd9+QnLX
         BWDQ==
X-Gm-Message-State: AJIora+B3d7HA84gSIkT5awlxIb7bXBVxAUJLlcazq9FRb+nWdyc6ZQ4
        B6fanh60777E7j6roWEjZIeAuUC5CW2QNIbwUYspEPSXlEo=
X-Google-Smtp-Source: AGRyM1uAs3vwRPBd+RlRHuy/v3MHoVDmhD46wInIdKxQuolYSn2hw6a21TIgppNd0RiqCUzaAhIT6DuaGIMSAUmunDA=
X-Received: by 2002:a05:6122:11a6:b0:35d:ae2d:7b6 with SMTP id
 y6-20020a05612211a600b0035dae2d07b6mr3357170vkn.16.1655247586414; Tue, 14 Jun
 2022 15:59:46 -0700 (PDT)
MIME-Version: 1.0
References: <165510566839171@kroah.com>
In-Reply-To: <165510566839171@kroah.com>
From:   Martin Faltesek <mfaltesek@google.com>
Date:   Tue, 14 Jun 2022 17:59:35 -0500
Message-ID: <CAOiWkA_DGb6f06X1y06eQ_Ap_U6YJ+sJrjaSu87d7wrsKy5JMw@mail.gmail.com>
Subject: Re: FAILED: patch "[PATCH] nfc: st21nfca: fix incorrect sizing
 calculations in" failed to apply to 5.4-stable tree
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     groeck@chromium.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 13, 2022 at 2:34 AM <gregkh@linuxfoundation.org> wrote:
>
>
> The patch below does not apply to the 5.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

I'm working on this.
