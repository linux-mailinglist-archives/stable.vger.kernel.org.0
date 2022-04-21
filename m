Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE1AF50963B
	for <lists+stable@lfdr.de>; Thu, 21 Apr 2022 07:07:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238462AbiDUFKR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 Apr 2022 01:10:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237190AbiDUFKQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 Apr 2022 01:10:16 -0400
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CAE7B7CC
        for <stable@vger.kernel.org>; Wed, 20 Apr 2022 22:07:27 -0700 (PDT)
Received: by mail-qt1-x82a.google.com with SMTP id bb21so2533494qtb.3
        for <stable@vger.kernel.org>; Wed, 20 Apr 2022 22:07:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=fpB6qSK6He8nmDtW3/jQ3g5RtQpSiSeXerc3l836tv8=;
        b=P/////9Z93XBvvT0Mn/dBtHqvaNWx+H+IVT2ZELxYxNokeVeXeuxW7DnjaeWMTcdwi
         Tq9nY1tv/IWav6lEgMw4xLXGshp1XMYmlp5jDVX5liZu823EjYY88TXmsXnF5xLeNdwY
         3HnQa7rBy0O3plQdUuCqQtAnPCccyed0yVrxyiQuzJKSj2DyXU+ioInKuQ9f8v1AAPKT
         vjXUMlYf3yyKtLGXuEzKtOnWXnDZcp7zgun3MkfTjaSKgL3+g+mSTkbS6hhJDcjYUpvH
         zjdq2iAj+HZJM2lkKXTQ1fREuo9wJntd/VnMZMysagfw4L04H06lXQSMAyalOkkezf4n
         enZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=fpB6qSK6He8nmDtW3/jQ3g5RtQpSiSeXerc3l836tv8=;
        b=Ld83+v4MYBHmt1PZOq3o2Pf6RDXtyUVciWRqO9Wp8OZdjfqYMIcYpfMZIva9B6JV/p
         dv5ByGmNCtMwYzPjiZFwgWZEXVzIDNmoq2JOoxLaNv65QtEfNKP4ecL2fONMTIDYSy1B
         F7jDdmvOYcViQH2WDmzPvhp5FFrJQQdwoVgFMDRoiGsDmegrf2369BTpWe8PDIWDrewV
         Idzpf78xSxYaY61PIYpZN4MUwgclsvM4ju+1MNnHJnr9I8Y3mzUBpAnkD9h8o805+Yov
         nqzqU+6JTeg5VD++Fhme1sUw+41hzX1JYOTqc0zR+iuGCgRxgSRgLLn4mfAxRnWpK3og
         p6xg==
X-Gm-Message-State: AOAM533x+ZjkIkgfLFWoPUPGdkekE9EH1pavl5S/hUIbZs4gd6b/aTj1
        QpqvhAJGly8VgJw7oZvLYQZDQMvE+DeGjekzzc9J0xuaRr3ak9pj
X-Google-Smtp-Source: ABdhPJz3JtNKVecEdJ3xzjfJlqkeEmRs9uWltySmWgPtk/bji0Y9u/ZiMsoaBrnU0Gx3WfLG/CwUl+kR8Yjah1AoOUQ=
X-Received: by 2002:a05:622a:1904:b0:2f3:41d8:84e2 with SMTP id
 w4-20020a05622a190400b002f341d884e2mr3812505qtc.429.1650517646756; Wed, 20
 Apr 2022 22:07:26 -0700 (PDT)
MIME-Version: 1.0
From:   Atul Khare <atulkhare@rivosinc.com>
Date:   Wed, 20 Apr 2022 22:07:15 -0700
Message-ID: <CABMhjYrheOjEYfH7WjmdUj4X=aSbQuUADQ7NNpk0hAjE0LpSxw@mail.gmail.com>
Subject: [PATCH 0/4] dt-bindings: sifive: fix dt-schema errors
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The patch series fixes dt-schema validation errors that can be reproduced
using the following: make ARCH=riscv defconfig; make ARCH=riscv
dt_binding_check dtbs_check


Atul Khare (4):
  dt-bindings: sifive: Support 1024 hart contexts
  dt-bindings: sifive: add cache-set value of 2048
  dt-bindings: sifive: delete 'clock' / 'status'
  dt-bindings: sifive: add gpio-line-names

 Documentation/devicetree/bindings/gpio/sifive,gpio.yaml      | 3 +++
 Documentation/devicetree/bindings/riscv/sifive-l2-cache.yaml | 4 +++-
 Documentation/devicetree/bindings/timer/sifive,clint.yaml    | 2 ++
 arch/riscv/boot/dts/microchip/microchip-mpfs-icicle-kit.dts  | 4 ----
 4 files changed, 8 insertions(+), 5 deletions(-)

--
2.35.1
