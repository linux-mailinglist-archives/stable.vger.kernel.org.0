Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BE5A585BAF
	for <lists+stable@lfdr.de>; Sat, 30 Jul 2022 21:10:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbiG3TKR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 Jul 2022 15:10:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234713AbiG3TKO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 30 Jul 2022 15:10:14 -0400
Received: from mail-qv1-xf2f.google.com (mail-qv1-xf2f.google.com [IPv6:2607:f8b0:4864:20::f2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C1CBCD1
        for <stable@vger.kernel.org>; Sat, 30 Jul 2022 12:10:09 -0700 (PDT)
Received: by mail-qv1-xf2f.google.com with SMTP id b7so4425787qvq.2
        for <stable@vger.kernel.org>; Sat, 30 Jul 2022 12:10:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:sender:reply-to:mime-version:from
         :to:cc;
        bh=YeEFrOpnueqp49lpSsCtkyhW66cD5QzqZPU5hyS5TkM=;
        b=fJfnhg35Jd3Lira+lKItfAAJIvf7Nv55p/ettaBDkBnBOGytEhOifiucUYWzljRUJF
         mfiV1eSLr4+VgQcLlFZJcGbEqDEQb0pHZM7mkQnoG4Lso9qmor42dHvMEnG0B/sutWJp
         js/wMH8hTOoUvkC6qaPRhuziReIgR3QLrEVJy4PFtp9EG64Mb3LxbFlbPIwBpz6cf83J
         DGMwhzMP8gu3ZSIy4HBWGWsZpoS9WkfeQMDuCSoIGzJtnOR5q0Gql2vNhIL6k4qj344/
         LuKlTxGjt0FjHUOCSun4H04U/4fEawVyMOqmP53rz9ZU8N3HIonD/NnY06cOr+rJiHLJ
         dydw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:sender:reply-to:mime-version
         :x-gm-message-state:from:to:cc;
        bh=YeEFrOpnueqp49lpSsCtkyhW66cD5QzqZPU5hyS5TkM=;
        b=Vs0KA18ipHGvkjcAhF29MFc25lGaPfQxGfUG84hXTXpPByz8oyY42h/8H/Vrq39I9U
         fyLtJQMLCLIn2iNhjWaYEWsPvg3aw4N7A2gVEXdvGEPrlFLozZfLhGNSymCKdeBUClvS
         slic58i1kpetIKnaWXwtqCG+uM1DVFL1TgVoytsEKeW6cUrHgkYkWWgcJ2lBnPob7F4T
         eRF8F+w5deXY5y8nmReVi6V1rQm0yJfJS+lGMThlhnZUo5kPGlM5TgwpcpHEoUMDsFTm
         RVc6mAjqSqPiADy0tpgV2BsaCLSFbbY2QwbkkImuM1onJRwHck3bSuHPFNBFtIcL0P+n
         yP7w==
X-Gm-Message-State: ACgBeo36NPUKp6CCFkEFT6Ahw3zcSCmxrWNFhuIRT1+HCHJBnkh9+TGi
        Ub1IeA1A1CJmbxWxXzq6Lu/fSAAJl+Dh/dH+Mc0=
X-Google-Smtp-Source: AA6agR6Lj7ELdhRgB1g3amx+t0LQ95Z2hBq8t0XA8zdzi8zIOzyhzEv9dGUdxDVpX6o4F2wzmbrerliboDSNMo2Ef/4=
X-Received: by 2002:a05:6214:226b:b0:474:7c12:ecf9 with SMTP id
 gs11-20020a056214226b00b004747c12ecf9mr8304053qvb.37.1659208208419; Sat, 30
 Jul 2022 12:10:08 -0700 (PDT)
MIME-Version: 1.0
Reply-To: lisawilliams9656@gmail.com
Sender: daniellascottdaniellascott992@gmail.com
Received: by 2002:a05:6214:c67:0:0:0:0 with HTTP; Sat, 30 Jul 2022 12:10:08
 -0700 (PDT)
From:   Lisa Williams <lisawilliams9656@gmail.com>
Date:   Sat, 30 Jul 2022 19:10:08 +0000
X-Google-Sender-Auth: VRgOJzmcAr1JLiUHEumUg_Ywtnw
Message-ID: <CAHhx1_j+qRuV2k4fm=cBDEoduTX6Z3AiEJ0npw6r2e5LUPm_=A@mail.gmail.com>
Subject: Good Day,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=1.1 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Dear,

My name is Dr Lisa Williams from the United States.I am a French and
American nationality (dual) living in the U.S and sometimes in France
for Work Purpose.

I hope you consider my friend request. I will share some of my pics
and more details about myself when I get your response.

Thanks

With love
Lisa
