Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAB285474A3
	for <lists+stable@lfdr.de>; Sat, 11 Jun 2022 14:56:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233413AbiFKM4V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jun 2022 08:56:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233405AbiFKM4V (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Jun 2022 08:56:21 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 130554C7B0
        for <stable@vger.kernel.org>; Sat, 11 Jun 2022 05:56:20 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id l204so2844978ybf.10
        for <stable@vger.kernel.org>; Sat, 11 Jun 2022 05:56:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=/KdWH1L1ADeIuY5k7RqU2jmHtnJKpm5JvBU7o8h1qZY=;
        b=o9zPZsRneVwSPNTHg6uAo72gOrI8EqOVonqFb9mzmEGP5+dL90muHToULmLXOtCOyp
         uOrWkst5BWFCkGxFGYTQBzH8ZlGpqabDKAntguFAS2yZnE4NOGLW/u0u35bg02+0mro7
         CSrxBY8+BHvrDso0EsG46tSlMyVOuusco2vZVQAoduxXqOjllDGEfxk0ITT4o4TYDSJ9
         TompYA9l2IwIScwc7TaqE7jfFhMscsfIdYCEqRuoT3m+eUJGx7882e51vNdkp2OSEY2u
         l6TxD6tqiN8f0XZoOqebT5T31uuBCbVWJaK1XAtB7g2naKa45g9hDc4o7UpJAG/ymPDx
         +uSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=/KdWH1L1ADeIuY5k7RqU2jmHtnJKpm5JvBU7o8h1qZY=;
        b=1qEwnDrI9MvNJ4oRh7ysVE89D55IKQgUkhBgq/ZmZdsIJTCdATfzFBb0Au4hy3enXD
         kgzI06yAPUIy5newqwlE4FbpYC4mvOHjqRTthnaDJLluuKZ9MkPMlMz+B2kxH29DJuUr
         nE5gXZ/MeADiBkkqj7knfeXzd8lW4YFcL0x4oOaBS95RGLTxD2TothBhNTY07GHcV7e2
         Ppas+DQtXgjSAJ8nypp7J8VJs4BWd1i/iJGaYmJ6OsxyessdxQ9QgjcjT6yXPoc0F4gd
         q0Vcsbnh40wAA0oc+Mfi3DSDyOjEQgg8SjH1tzn6rZQceHYFmLxeiodl/7mUM8XKtDsc
         JliA==
X-Gm-Message-State: AOAM532yx/RNwd0IFRckNPW7IPlP+J9DYJoIBwtkEng1nKAavnZ6ohar
        6ZTST9gT0klCtvixYJ9yXAdMyJiCNdTHKBwNnrc=
X-Google-Smtp-Source: ABdhPJyb2AkrN4CiBhlBlVTmNfyXaBFjK4uHXqDjeK1xW/uJwDf9TAFZRm0ysx+FYMh1LwZuOCEjBd0P4wJdqoG3BiI=
X-Received: by 2002:a05:6902:a:b0:65c:b38e:6d9f with SMTP id
 l10-20020a056902000a00b0065cb38e6d9fmr51339830ybh.36.1654952179039; Sat, 11
 Jun 2022 05:56:19 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7010:e38d:b0:2d6:ff68:4ed1 with HTTP; Sat, 11 Jun 2022
 05:56:18 -0700 (PDT)
From:   "mydesk.ceoinfo@barclaysbank.co.uk" <allanjones.secretary@gmail.com>
Date:   Sat, 11 Jun 2022 13:56:18 +0100
Message-ID: <CA+BTBaR2PFGoCxtPmjcYnaB+r=_wvNCSO8pbK7MXm+6U2RZEgA@mail.gmail.com>
Subject: RE PAYMENT NOTIFICATION UPDATE
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.7 required=5.0 tests=BAYES_50,DEAR_BENEFICIARY,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        FROM_2_EMAILS_SHORT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        SUBJ_ALL_CAPS,T_SCC_BODY_TEXT_LINE,UNDISC_MONEY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-- 
Dear Fund Beneficiary,

Refer to my previous emails informing you again and again that your
fund has been released. Please be advised that your long delayed
payment has just been released and loaded onto an ATM Master
Card.Please reconfirm your names and address for delivery.

Looking forward to hearing from you,

Nigel Higgins, (Barclays Group Chairman),
Barclays Bank Plc,
1 Churchill Place, London, ENG E14 5HP,
