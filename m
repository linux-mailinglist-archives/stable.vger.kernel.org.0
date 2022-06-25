Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3025055A85F
	for <lists+stable@lfdr.de>; Sat, 25 Jun 2022 11:10:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232446AbiFYJHb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Jun 2022 05:07:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231797AbiFYJH1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Jun 2022 05:07:27 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 463EF37A06
        for <stable@vger.kernel.org>; Sat, 25 Jun 2022 02:07:26 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id z11so6459292edp.9
        for <stable@vger.kernel.org>; Sat, 25 Jun 2022 02:07:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=S6qZgE2uPwn/d1eg70KlTI5Q2QqMPkD9Yhl3y2T9a6U=;
        b=jOpGGDK3YcaVqDoz+cdWDCBxvddvoWE4BCq+EiEPtfxZ3fUolsMaKMW84IZppUciJt
         Xavms6P82tWW+t8/C8ze/Ae++iaKikEdzetUt/VpPRQzPpQCk7HFndkkPXP1h9FsAhc1
         TbOpLPtRIWIwfjXqVkawCTN/DDryeT21GjbAkddScMj8H1Vw6N5Ive0mfb9fJR4Iz4mE
         +oER671T73w53HXpDhVKoflFzqU10F2kp9gDN4GK4lwvTO14dRNPZBl6ezttOnva/QFA
         bbYhIv3+wsEILxS3nXq7qrOXw1LkYUu6QN85eJBAsYOv3jbwdbL4rCddVs5dxulSW7XH
         F4aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=S6qZgE2uPwn/d1eg70KlTI5Q2QqMPkD9Yhl3y2T9a6U=;
        b=zEVLbyM/o7aQ8Z65OxeOR4nd1qe4mIUdrjmfLACrr7qYDnwacwr5QYmkM1YOCI+cgL
         rwTBoIDFWLnkUZljy7VmlkMm/523IkOM9ex0vjg2yBJnmBBL7RKr/EVS1xKCjDyzpt6w
         QbvS3Mddx5EAWxgaasiGgLqvs+KVEmdozE9GARc5e8DeeGA/tfZujH8BD30NujxHOB0Y
         RuR9k4G5MZA1N+4z/9kKQoKdUUlGXF4oy5MsRXnCTSncBHUnMm0y2j6TVMe/HmAPbSTb
         TGkbdPqutrA8cQYGc7BquDXjVaX8FSu9PNPAd1j4u1R89HEr2Lq6LbMolPWH+dMjK14t
         jNKA==
X-Gm-Message-State: AJIora/71ujfMWTCN8JXbmkLcOdq5MGrxXWq3pcqap9i8/Vp8uIhTUui
        aCcn1gLnYKiX0ZfgZkY4LMy/+SsOu4iEnoKuGMY=
X-Google-Smtp-Source: AGRyM1vKpUe7iNpAtOHnRPQTAbSpb8SA+6q12gZ/XjnbQVxh845RyoGK/MbHrcVLW7tsMsybJQWAqtoF0ftQdpkAhO0=
X-Received: by 2002:a05:6402:3808:b0:435:5a6c:9dd9 with SMTP id
 es8-20020a056402380800b004355a6c9dd9mr3943746edb.368.1656148044478; Sat, 25
 Jun 2022 02:07:24 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a50:2309:0:0:0:0:0 with HTTP; Sat, 25 Jun 2022 02:07:23
 -0700 (PDT)
Reply-To: info@nitoscebu.com
From:   Robert Avtandilyan <ekuojo02@gmail.com>
Date:   Sat, 25 Jun 2022 10:07:23 +0100
Message-ID: <CADFEjDh4Hz4nyOcTmc0KhnXojQ2-To8bKaTizionuiojNKznRw@mail.gmail.com>
Subject: Urgent Call to Rescue
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=3.9 required=5.0 tests=ADVANCE_FEE_4_NEW_MONEY,
        BAYES_50,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,LOTS_OF_MONEY,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_MONEY_PERCENT,
        T_SCC_BODY_TEXT_LINE,UNDISC_MONEY,XFER_LOTSA_MONEY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-- 
Hello,

Greetings from Moscow - Russia.

I got your contact from the internet, though I didn't keep record of
the exact website on the internet since I'm not sure if you would be
interested in the deal.

I closed my Oil & Gas deal in Russia because of US, EU & NATO Members
Sanctions on Russia from making wire transfer to all over Europe,
America and Asia due to Russia military invasion on Ukraine. But
before the sanction i have pulled my money $125, 500, 000. 00 USD from
my bank accounts in Russia and i want you to help me and receive the
money cash in suitcases for safe keeping place / account for
investment.

Please the earlier the better. You are entitled to 10% of the total
sum for your help, and another 15% of profit accruing from profit on
investments as your share benefits.

I look forward to your reply for further details ASAP.

Yours truly,

Robert Avtandilyan.
