Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A56924F6C29
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 23:08:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235406AbiDFVKK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 17:10:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234594AbiDFVKC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 17:10:02 -0400
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73A981B8FE3
        for <stable@vger.kernel.org>; Wed,  6 Apr 2022 12:49:32 -0700 (PDT)
Received: by mail-qt1-x835.google.com with SMTP id j21so6240940qta.0
        for <stable@vger.kernel.org>; Wed, 06 Apr 2022 12:49:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YALPcXFlHyjJhM5IWic8x8fsXsmFYfOaEejI/INaLqA=;
        b=Y/LXP7pUpQ/mB4D2Bm5PRBF+M9OQHdXqn1VwvqNhpwGTAGnOYEvjaT7gj06TOoXUlA
         Q7JoZlyaXNJXIzIyqVy0C1436BtgV1uvf5vNDam8qufk0kDTp5kRX7+VoTPKNwHHYibO
         mE49Cgi9zQ1+YVg9j0PpdETJD0CebPzxvpx0O7YMQ3qHHW6z5WO4n47LK6Ecoy4zMyq5
         LdvfSN/wS8f9agQoDVjQoXDMc6hwWLpPkNg9NL/h9kVYrIWdxQJcmuPK+7vaHqjZJ2LP
         ob1vZmvXVrvh6KC6diiiDq4HGv29tj0Bh7cZqbu2cJgCsFkyq2aYQYXvvF7VGAAAm1oP
         //7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YALPcXFlHyjJhM5IWic8x8fsXsmFYfOaEejI/INaLqA=;
        b=rQ5MHUqkZVOeqgQzQnpRf5J/WT6wS7Gy039+APmi1cV93F31bguG/JjrvVm7Os5hGy
         xq5tI7UgsUnj4fUoYi/nBYRMMpX2U5f85gsU5OhBseBO+YCvf00vrHh6oJmZKe1OrDtG
         YFAd2r9cQFA1UsXgw1qlyz31TVUADj8b9HAQx2Pu9M57vmk6j5cs7lrNj/B4uRZS4L4/
         ZCg2NxwemsdbY6+TPC5ZE2P3i6V+Vb8wnOri2DlXxwbQaD29MlAM+sPYTS2nqobOx4yn
         kYyKbuKKtm55ALlTzFhZhbK4P0KfnrMEoAHJQj4++0mOqu8o+Hp2XKX58QlXCgh05ZVZ
         8lAw==
X-Gm-Message-State: AOAM532tdy3Ue2S1aUObqxDthIDIX+D/VUfYVwFGeI8lpgYMxdmTyv4V
        tJ9brjWARAQ20uTCJ6aynESybMS1Ty8=
X-Google-Smtp-Source: ABdhPJyUYtpbDvo1uQOE0l74NLr2w60H5GcECitlWr8IhUjPDai0dvwrARWEFkbj6TEgEVA64z13Lw==
X-Received: by 2002:a05:622a:42:b0:2e2:277d:60c7 with SMTP id y2-20020a05622a004200b002e2277d60c7mr9074290qtw.240.1649274571287;
        Wed, 06 Apr 2022 12:49:31 -0700 (PDT)
Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com. [209.85.128.173])
        by smtp.gmail.com with ESMTPSA id bl22-20020a05620a1a9600b00680da570a5dsm11394259qkb.61.2022.04.06.12.49.30
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Apr 2022 12:49:31 -0700 (PDT)
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-2e64a6b20eeso38929007b3.3
        for <stable@vger.kernel.org>; Wed, 06 Apr 2022 12:49:30 -0700 (PDT)
X-Received: by 2002:a81:b04a:0:b0:2eb:6919:f27 with SMTP id
 x10-20020a81b04a000000b002eb69190f27mr8641057ywk.54.1649274570313; Wed, 06
 Apr 2022 12:49:30 -0700 (PDT)
MIME-Version: 1.0
References: <20220406192956.3291614-1-vladimir.oltean@nxp.com> <20220406192956.3291614-3-vladimir.oltean@nxp.com>
In-Reply-To: <20220406192956.3291614-3-vladimir.oltean@nxp.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 6 Apr 2022 15:48:54 -0400
X-Gmail-Original-Message-ID: <CA+FuTSe0YNxNqR5kWSB3+8DLEBz4FDQBXG0w8yTDTKCRtrrR_w@mail.gmail.com>
Message-ID: <CA+FuTSe0YNxNqR5kWSB3+8DLEBz4FDQBXG0w8yTDTKCRtrrR_w@mail.gmail.com>
Subject: Re: [PATCH 4.14 2/2] net: add missing SOF_TIMESTAMPING_OPT_ID support
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
> [ Upstream commit 8f932f762e7928d250e21006b00ff9b7718b0a64 ]
>
> SOF_TIMESTAMPING_OPT_ID is supported on TCP, UDP and RAW sockets.
> But it was missing on RAW with IPPROTO_IP, PF_PACKET and CAN.
>
> Add skb_setup_tx_timestamp that configures both tx_flags and tskey
> for these paths that do not need corking or use bytestream keys.
>
> Fixes: 09c2d251b707 ("net-timestamp: add key to disambiguate concurrent datagrams")
> Signed-off-by: Willem de Bruijn <willemb@google.com>
> Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Acked-by: Willem de Bruijn <willemb@google.com>

Thanks for handling the cherry-pick to stable of this fix, Vladimir.
