Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 970ED6718FA
	for <lists+stable@lfdr.de>; Wed, 18 Jan 2023 11:32:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbjARKci (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Jan 2023 05:32:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbjARKcC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Jan 2023 05:32:02 -0500
Received: from mail-vs1-xe2c.google.com (mail-vs1-xe2c.google.com [IPv6:2607:f8b0:4864:20::e2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD01DBD16C
        for <stable@vger.kernel.org>; Wed, 18 Jan 2023 01:38:42 -0800 (PST)
Received: by mail-vs1-xe2c.google.com with SMTP id v127so30709965vsb.12
        for <stable@vger.kernel.org>; Wed, 18 Jan 2023 01:38:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oi2CsvU8zgZn29VtRR/8zgZYMbXO0Js76fEjysKPOW0=;
        b=ecHRdvyIsz9xv1wYQhY/jc/o+jb9XjdXQwHM/0Hc59eIouQvga++X83NI4nUrDtMdX
         2wH/b593YjejUUpXOLH0ywCc14gPQb9LlMhNBqM96d3vR0Qrpq2QW9xRVSo7H0Eo5KoX
         QjspGnctEMk5X+EOY/zBMvacIQmJ0EQCmCRAV+4eFYd+0i97W0Cl2nP3mUsvu2AjRp5P
         HEN/03MjBWSG5DKe5CTF4zPkU0T2w5qqHVipXXqiQIhV9sePpXDHxH9i61Aio++qjfLr
         9qq4Y2sosn79NJDdwsmgvlPSrOaw8XxvEqEH2V1uQNt1+MLK1v2ZguYUVJ7qTxJax1iP
         GntQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oi2CsvU8zgZn29VtRR/8zgZYMbXO0Js76fEjysKPOW0=;
        b=TfRLFZnqUm+yBi6rLzsdBOu/AAk4iJKYQQkrIkc9qXb7CMFRh5ncJj25Nc6Ts5I1XR
         /IizUVJSLDUPeBjd0wmm+3FKch2fwI5745WGsazpY9u8qK/Vh50Yg/a3kUM3L3rhYRgO
         1ReSoimc5a0VkPjXfvzl5FaZlUbPepuGw2uND35Ipxd5gp0TaUNa6/AbY3YE2H+k+WqO
         uGL6VnZs85PWBcjynJ0i6mT90cP+fdVxE/V3aBTznPDZ5c8H2TM22pumbostqZtistXa
         xHtWZ+/cT9nfycaD8oBe9YawsP1R3dSt12m1o14O0YINgiFWQtvm11xy6bpCBeXgVR/D
         Jv0A==
X-Gm-Message-State: AFqh2koY3x2vzVrhuhNk+hZmECjU6CHMwckrf1Hnwz669UhrAnbU5STK
        F6F+sVCzyMOZoQoNL/8q9ql4kvsNgSi310fuCLs=
X-Google-Smtp-Source: AMrXdXtkoTEmptARn3YgJcalqv/dqXlho5F+q5tFxFeoMZp9faiNrXODe9ldUYFy2E9cTou+sNfW+HeqWVRIpfXBj3A=
X-Received: by 2002:a05:6102:124d:b0:3ce:8b90:2b1b with SMTP id
 p13-20020a056102124d00b003ce8b902b1bmr744081vsg.42.1674034705876; Wed, 18 Jan
 2023 01:38:25 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a59:c8a2:0:b0:33d:74eb:f817 with HTTP; Wed, 18 Jan 2023
 01:38:25 -0800 (PST)
Reply-To: hustonkarim7712@gmail.com
From:   Huston Karim <hustonali2999@gmail.com>
Date:   Wed, 18 Jan 2023 10:38:25 +0100
Message-ID: <CALe2VC9cHVUE3TQ8WcpMb5F6vsp-g1B8e=TQmnUmP-dKXjppwA@mail.gmail.com>
Subject: Hello,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello, did you receive my email on 17/01/2023?
Please answer .Regards thanks.
