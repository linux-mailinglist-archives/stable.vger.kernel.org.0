Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 474414F6C1A
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 23:06:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235315AbiDFVIc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 17:08:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235406AbiDFVIQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 17:08:16 -0400
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 759947C79D
        for <stable@vger.kernel.org>; Wed,  6 Apr 2022 12:45:52 -0700 (PDT)
Received: by mail-qv1-xf2d.google.com with SMTP id p8so3134598qvv.5
        for <stable@vger.kernel.org>; Wed, 06 Apr 2022 12:45:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QrpjkiliU8wPY1XOQv+OUkzSsJhLMBGEY6gnsrt3l58=;
        b=kxZaaA0a0zGP6wg8qCMsSM7Ow8BFElXrCpRHQgAp5FPFjUto5oZhr7nRL88c+WFvMB
         nIHrrF7qWy8o70ZDCCV6hYbpzfH9cLJgPKx6KqeD+zMoxSg/At62gIKgd4GNdlenfy/N
         CkKP/FGqJungTP3BiUOLrZ/Y9CmzcgKI1Fa4QgTS4gAYAFbPRkgKvXEG4lBDfckmbNMd
         JgFmmojWoLEZ6hr0xSJNzrM6uupJgj2LC6gbj5dv/DLnLWrKCANN7QF5RCOKCmXAUcaI
         6g4AdhPqhH7AJR0v2g5URzDtDsng0hdGf8TMBgeKyCXzRaLpSE6TkByavNh1RYeFcJav
         ZbZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QrpjkiliU8wPY1XOQv+OUkzSsJhLMBGEY6gnsrt3l58=;
        b=vyth1aEaYj+NfuTBGoUlSqNqqf8rmmdFeH5ZoxqN2kDkXgqaxylPpqRnGr7cKlwEGy
         JqpZY8bIfXjt6tftSPb9gIUROQnSVC1IAVA4jXmrqeB6fAzsI+cifIG4aOODCVKAJ3Dw
         6Ax5x8pZWyB0lOpmB+IoPDg6fnYa03aXGtF5+8our7heYCr9WqJibhOsnfB7WI2jVsmR
         IL7u/zI3zpkp6mh4zleF9fz3xY6r7kMoTTSU1RufHgdxWdUJyUM25PRCKouSMxxqTdsm
         dR1bJ3l8wQo79rG6XK/w3m0IEiQe3k2I30fYtsgmMkfIDdmfycYg+JMy9TAMl4S1lEnE
         NGyA==
X-Gm-Message-State: AOAM5308uMHBR3aqXGKLzce0SwdYgIbbB9XhAqlKmV9BHSsKQXLyFnJ5
        6NrjHaVvrMuxIxQn6zQTCis0Sd1FNrA=
X-Google-Smtp-Source: ABdhPJxqpRhrUO4H9DGXkkzURrjwPHHFfQvieqA+rfuUXnZ8vq+kgkzaew1KOY/bQsfGshKaXjfx3g==
X-Received: by 2002:ad4:5c43:0:b0:443:d258:52e1 with SMTP id a3-20020ad45c43000000b00443d25852e1mr8429361qva.85.1649274351636;
        Wed, 06 Apr 2022 12:45:51 -0700 (PDT)
Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com. [209.85.128.171])
        by smtp.gmail.com with ESMTPSA id y24-20020a37e318000000b0067d43d76184sm10110722qki.97.2022.04.06.12.45.50
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Apr 2022 12:45:51 -0700 (PDT)
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-2eafabbc80aso38185987b3.11
        for <stable@vger.kernel.org>; Wed, 06 Apr 2022 12:45:50 -0700 (PDT)
X-Received: by 2002:a81:12c9:0:b0:2eb:83e7:c3fd with SMTP id
 192-20020a8112c9000000b002eb83e7c3fdmr8574499yws.351.1649274349858; Wed, 06
 Apr 2022 12:45:49 -0700 (PDT)
MIME-Version: 1.0
References: <20220406192956.3291614-1-vladimir.oltean@nxp.com> <20220406192956.3291614-2-vladimir.oltean@nxp.com>
In-Reply-To: <20220406192956.3291614-2-vladimir.oltean@nxp.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 6 Apr 2022 15:45:14 -0400
X-Gmail-Original-Message-ID: <CA+FuTSdK4T7DBf9wi3GjXA6P9o+6X-7c5vh9V0BN40GwbKSeGw@mail.gmail.com>
Message-ID: <CA+FuTSdK4T7DBf9wi3GjXA6P9o+6X-7c5vh9V0BN40GwbKSeGw@mail.gmail.com>
Subject: Re: [PATCH 4.14 1/2] ipv6: add missing tx timestamping on IPPROTO_RAW
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 6, 2022 at 3:30 PM Vladimir Oltean <vladimir.oltean@nxp.com> wrote:
>
> From: Willem de Bruijn <willemb@google.com>
>
> [ Upstream commit fbfb2321e950918b430e7225546296b2dcadf725 ]
>
> Raw sockets support tx timestamping, but one case is missing.
>
> IPPROTO_RAW takes a separate packet construction path. raw_send_hdrinc
> has an explicit call to sock_tx_timestamp, but rawv6_send_hdrinc does
> not. Add it.
>
> Fixes: 11878b40ed5c ("net-timestamp: SOCK_RAW and PING timestamping")
> Signed-off-by: Willem de Bruijn <willemb@google.com>
> Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

For 4.14.y cherry-pick:

Acked-by: Willem de Bruijn <willemb@google.com>

Might be good to point out that this is not only a clean cherry-pick
of the one-line patch, but has to include part of commit a818f75e311c
("net: ipv6: Hook into time based transmission") to plumb the
sockcm_cookie. The rest of that patch is not a candidate for stable,
so LGTM.
