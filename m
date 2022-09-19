Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9024F5BD85B
	for <lists+stable@lfdr.de>; Tue, 20 Sep 2022 01:42:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbiISXmg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Sep 2022 19:42:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbiISXmf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Sep 2022 19:42:35 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04FD1B480;
        Mon, 19 Sep 2022 16:42:35 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id 138so892698iou.9;
        Mon, 19 Sep 2022 16:42:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=H6YHZH+jPDcccemitFjtnmIKNgFF4gCHv4dK5y+d7CU=;
        b=OgAm/NF5dYygMRvGiDjG6n33euz8Woc60hkRM8MQe7E2MjPXdQszKdbDhJbGl9QSQk
         gTMThg/eG/Ydm7bMyH8nUBOY6RJ0awx/Thfjg3+gFBM4Ny3riL7SHHCFVXUOWEnfEFGO
         j/XKOnC81cCwwxTBRGnLYhxtgMdwO5nZXpRGUJGTZHoBA6otbs5iVkF9ClvgojAzzKRR
         cee2XfiNM6JWHY0Nlgj9UqGTOIUhd60DR8QgShQBHh35zNd6rHU/ZVL3Ep8xX0Z69yvp
         dRXsjBVaMGrN461k9PcYw/6h8KwVeaT0+QGQ+Uy2BLaK3BprqqSZvU5t6PopgwYF/eZA
         9AIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=H6YHZH+jPDcccemitFjtnmIKNgFF4gCHv4dK5y+d7CU=;
        b=dNG4atFrTYw1jNOrNyjMUb9ONB7ecKUl340ldvxiF8mMKfuFzQoZ0duPCSFQBwPCen
         /V0s9vu37cUmbZQ7Q1H9yyxKDM2WN8MMAslD5OT6zn1RiM/4UbfWQldGPHCma1fQ8FyO
         npK1+KQKSlqTYRAz3Q43t1+2hAPpiHhvhPGDwAGcv3zzoCXoxWBJyhme78vhBwTfsQJu
         IeumKPWgCzwejsy2DlqHvQOBeoNjDtx6tvcI1fT1WfJQwfvTQPRFy0JZsot934yZgbXe
         BYvZFnVgM8X9mog+Xs4qgpW1zIK07T/bOzusocBgTPae305hjacFSzlsEgyZPntkVSyO
         H59Q==
X-Gm-Message-State: ACrzQf26A8vgo2lWfvXbkyjPOihssH36KBTf1b/YpggMbl/Rqz1gZBxp
        rFWpRmdDST8gIxnYDd2OY+jbgHJmux+3WvGarOc=
X-Google-Smtp-Source: AMsMyM5rQlLxZskd9cq+QRXjkjYUXUxsTLiTx38siVDVmBLHAcYRSX18R8+xAmMyH9khjMfm3rUhfii9rLh750hxDYo=
X-Received: by 2002:a05:6638:4987:b0:358:448d:ec40 with SMTP id
 cv7-20020a056638498700b00358448dec40mr9419320jab.288.1663630954470; Mon, 19
 Sep 2022 16:42:34 -0700 (PDT)
MIME-Version: 1.0
References: <20200527165718.129307-1-briannorris@chromium.org>
 <YmPadTu8CfEARfWs@xps> <CA+ASDXPeJ6fD9hvc0Nq_RY05YRdSP77U_96vUZcTYgkQKY9Bvg@mail.gmail.com>
 <CAG2Q2vXce2V3Y6MnPhV6obcNWyQzyusMTL=5oCQLRNh2_ffNYA@mail.gmail.com>
 <CAG2Q2vXFcSVwF4CbU5o3VP1MWwrdqrZjTHgfBj_Q0t3nNipJRw@mail.gmail.com>
 <CA+ASDXNx30A3=BA9b-tiAQzYHP=nV_eLw1QFpJij=F=JgWZ5sg@mail.gmail.com> <CAJ+vNU38WyC=FFZVgqyKunEnjXid6vXqkorv8a8+ywjJBk_0NA@mail.gmail.com>
In-Reply-To: <CAJ+vNU38WyC=FFZVgqyKunEnjXid6vXqkorv8a8+ywjJBk_0NA@mail.gmail.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Tue, 20 Sep 2022 02:42:27 +0300
Message-ID: <CAHNKnsTEBr4m1SpZxnfFPWiSgxBg5HhqYCdWwm=9gp7qHXg=Pg@mail.gmail.com>
Subject: Re: [PATCH] Revert "ath: add support for special 0x0 regulatory domain"
To:     Tim Harvey <tharvey@gateworks.com>
Cc:     Brian Norris <briannorris@chromium.org>,
        Cale Collins <ccollins@gateworks.com>, kvalo@kernel.org,
        Patrick Steinhardt <ps@pks.im>,
        ath10k <ath10k@lists.infradead.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Stephen McCarthy <stephen.mccarthy@pctel.com>
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

Hello,

I would like to add my 2c.

On Mon, Sep 19, 2022 at 8:25 PM Tim Harvey <tharvey@gateworks.com> wrote:
> I'm not clear if
> there are many other cards that have this same issue.

The list of cards with unprogrammed regdomain can be extended with
several relatively modern models:
  * MikroTik R11e-5HacD (QCA9882 based)
  * MikroTik R11e-5HacT (QCA9880 based)
  * QNAP QWA-AC2600 (QCA9984 based) [1]

As you can see these are powerful and massive cards for WISPs. Or at
least to run as an AP. I also know a bunch of .11a/b/g/n cards with
zero regdomain and the same target audience. Except maybe for the
legacy Wistorn CM9, which is a relatively compact card.

Also, a huge number of wireless routers and access points have
unprogrammed regdomain. But probably this is not the case, since they
anyway can not run a stock kernel.

1. https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1895333

-- 
Sergey
