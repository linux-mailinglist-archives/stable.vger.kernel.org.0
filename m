Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B24C5F63CB
	for <lists+stable@lfdr.de>; Thu,  6 Oct 2022 11:44:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230469AbiJFJou (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Oct 2022 05:44:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231167AbiJFJos (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Oct 2022 05:44:48 -0400
Received: from mail-vs1-xe33.google.com (mail-vs1-xe33.google.com [IPv6:2607:f8b0:4864:20::e33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBA65DE9E
        for <stable@vger.kernel.org>; Thu,  6 Oct 2022 02:44:46 -0700 (PDT)
Received: by mail-vs1-xe33.google.com with SMTP id l127so1463119vsc.3
        for <stable@vger.kernel.org>; Thu, 06 Oct 2022 02:44:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=+s7XQFEXbYCoY2Oukr/x0xh/t3IrCC4WvUBfr0I3CG0=;
        b=H4TxN1f/rgdQ3Mai5UgILBvr6wx0B9fIUW2T5kF5voxE+fdDZzK/5dH9fNqcf9FnNL
         PACKT4fTx3mk1tEK+Tr9Vw69aso5OSQEWek9NVojKV9J3t1zVdFoia91NqY60OpsLIjG
         013K54q8lgqbO575g45lUbvkmUCJ+AWVA1MqpC0VivMakaMcFTMyhrXIUI960mt1uUjI
         rLoXRY7Sj8ZbjaH6kR12H0yu2A4vrxGqdbvZaDGzSap9XV6MU931QCESrSZsIR8asuKi
         kz5Ti/OEKSTCWl1HkIvRR842AdxEEsygMlqEyLlWJd4zALHVsK8W7LpxzToMLALzqGvE
         MzIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+s7XQFEXbYCoY2Oukr/x0xh/t3IrCC4WvUBfr0I3CG0=;
        b=DFZEnZyEmCZCeTY8huPyS15VtQzUsTwPlZgsa5h2QanSkYImOL2uCNOdvSNM/x4Xm0
         cRhu/Lv4rYAjhZDXGcsyUJvFDst/Eq8EjCnC6gOLeSq4VKZHfoNZYCQrZPalEoykvBpM
         20lt18vVtCyTtIAcLW/uC2VVBYAGC5VjRCJdIs+mGgp41we/ULfm+jddfgwsbuLvaZuv
         lJ2E4x2frDvDIdCkOY/qLT37O5t8Gx9IEKn2+atCYXD3+KeQnzbPtdlGgVZIy6I3zX4h
         rkb+E76yQNohUCTwrUdixETToe0C0hoiO2Rzmsl+cGZXbjA58cIXLv+8hvbgVcsrQ/Gh
         X4ng==
X-Gm-Message-State: ACrzQf1S/Blm8AhKisIyTKObnPXaB+Cfzphhrb7P0p/30QYZK6hHGRrm
        E5DRmkibQjaeruAW2tts4FNsm48rfZBc1050zEs=
X-Google-Smtp-Source: AMsMyM6Sx6gv63D0WY1HFzm0j+vluwjrTLbFLGMz3JYOYV4/IYR3ng3YJStGYz6Vlwa1SW94kYZkdGhCzxxyv+5vqGM=
X-Received: by 2002:a67:db06:0:b0:3a6:d700:c84c with SMTP id
 z6-20020a67db06000000b003a6d700c84cmr1982415vsj.50.1665049485611; Thu, 06 Oct
 2022 02:44:45 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6122:901:0:0:0:0 with HTTP; Thu, 6 Oct 2022 02:44:44
 -0700 (PDT)
Reply-To: anwilliam152@citromail.hu
From:   "Anna S. William" <susanwiliam772@gmail.com>
Date:   Thu, 6 Oct 2022 02:44:44 -0700
Message-ID: <CAOzg2W6hTNS8-qp8evVE3o3-oCXYMbrtgnin5CTAif0zs-Zd2Q@mail.gmail.com>
Subject: =?UTF-8?B?0LTQvtCx0YDQvtC1INGD0YLRgNC+?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
X-Spam-Status: Yes, score=5.2 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:e33 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4761]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [susanwiliam772[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [susanwiliam772[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [anwilliam152[at]citromail.hu]
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  3.1 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

0LTQvtCx0YDQvtC1INGD0YLRgNC+DQoNCtCvINC30L3QsNGOLCDRh9GC0L4g0LLRiyDQsdGD0LTQ
tdGC0LUg0YPQtNC40LLQu9C10L3Riywg0L/QvtC70YPRh9C40LIg0Y3RgtC+INC/0LjRgdGM0LzQ
viDQvtGCINC80LXQvdGPINGB0LXQs9C+0LTQvdGPLg0K0K8g0JDQvdC90LAg0KEuINCj0LjQu9GM
0Y/QvCwg0Y8g0YDQsNCx0L7RgtCw0Y4g0LIg0JrQvtGA0L7Qu9C10LLRgdC60L7QvCDQsdCw0L3Q
utC1INCo0L7RgtC70LDQvdC00LjQuC4g0K3RgtC+INC/0LjRgdGM0LzQvg0K0Y/QstC70Y/QtdGC
0YHRjyDQvtGH0LXQvdGMINC/0YDQuNCy0LjQu9C10LPQuNGA0L7QstCw0L3QvdGL0Lwg0Lgg0YLR
gNC10LHRg9C10YIg0LLQsNGI0LXQs9C+INC90LXQvNC10LTQu9C10L3QvdC+0LPQvg0K0LLQvdC4
0LzQsNC90LjRjywg0L/QvtGC0L7QvNGDINGH0YLQviDQvNGLINC/0L7RgtC10YDRj9C70Lgg0L7Q
tNC90L7Qs9C+INC40Lcg0L3QsNGI0LjRhSDQutC70LjQtdC90YLQvtCyLCDQutC+0YLQvtGA0YvQ
uQ0K0YLQvtC20LUg0LjQtyDQstCw0YjQtdC5INGB0YLRgNCw0L3RiyDQuNC80LXQtdGCINGC0YMg
0LbQtSDRhNCw0LzQuNC70LjRjiwg0YfRgtC+INC4INCy0YssINC4INGDINC90LXQs9C+INCx0YvQ
uw0K0YHRgNC+0YfQvdGL0Lkg0LTQtdC/0L7Qt9C40YIg0L3QsCDRgdGD0LzQvNGDIDQsNyDQvNC4
0LvQu9C40L7QvdCwINC00L7Qu9C70LDRgNC+0LIg0LIg0L3QsNGI0LXQvCDQsdCw0L3QutC1INC0
0L4g0YHQstC+0LXQuQ0K0YHQvNC10YDRgtC4Lg0KDQrQo9GH0LjRgtGL0LLQsNGPINCy0LDRiNGD
INC90LDRhtC40L7QvdCw0LvRjNC90L7RgdGC0Ywg0YEg0L3QsNGI0LjQvCDQv9C+0LrQvtC50L3R
i9C8INCX0LDQutCw0LfRh9C40LrQvtC8INCQ0LvQtdC60YHQsNC90LTRgNC+0LwsINGPINGF0L7R
h9GDDQrQv9GA0LXQtNGB0YLQsNCy0LjRgtGMINCy0LDRgSDQsdCw0L3QutGDINCyINC60LDRh9C1
0YHRgtCy0LUg0LHQtdC90LXRhNC40YbQuNCw0YDQsCDQvdCw0YHQu9C10LTRgdGC0LLQtdC90L3Q
vtCz0L4g0YTQvtC90LTQsCDQuA0K0LzRiyDQvtCx0LAg0YDQsNC30LTQtdC70LjQvCDRgdGA0LXQ
tNGB0YLQstCwIDUwJSA1MCUsINC60LDQuiDRgtC+0LvRjNC60L4g0LTQtdC90YzQs9C4INCx0YPQ
tNGD0YIg0L/QtdGA0LXQstC10LTQtdC90YsNCtC90LAg0LLQsNGIINGB0YfQtdGCLg0KDQrQryDR
gSDQvdC10YLQtdGA0L/QtdC90LjQtdC8INC20LTRgyDQstCw0YjQtdCz0L4g0L3QtdC80LXQtNC7
0LXQvdC90L7Qs9C+INC+0YLQstC10YLQsC4NCg0K0KEg0YPQstCw0LbQtdC90LjQtdC8LA0K0JDQ
vdC90LAg0KEuINCj0LjQu9GM0Y/QvC4NCg==
