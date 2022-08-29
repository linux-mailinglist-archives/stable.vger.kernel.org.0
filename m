Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F6E85A4EEC
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 16:14:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229875AbiH2OOC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 10:14:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230176AbiH2OOB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 10:14:01 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B97E9350F
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 07:14:00 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id y29so4242189pfq.0
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 07:14:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version:from:to:cc;
        bh=5SGZXXm779vUUr1cqzGV/gRigE4jlSEMeyxYIdb55pM=;
        b=SHVuF+4K2TtFMEx01Baqi1sdYPqg4gVVvGwkHlnJOSQd89KVePbMqvO3e1sk/H0eU6
         a58HJSwhl88/V6a3BNltidDnBs9rllVuM+Tq2NyTcgX8Ecb5Ew80Vxg3qgLtumzVijM9
         WGhRYnd10PCNtEppgF33IirPsxtDSZ2ntSsW3lxge6QqPdaLyloe3lF0zHwAnLzmY/Kf
         qSkvXrcgrc2cG228SviSj7L8PPVi0lAAVQZZ50YV/EVS7He1LONnLI0flutcVWrdlJsZ
         J8nxXmRkyTyxn1sD3mAD3WWHimC/9rMKu7C5k8LgguKv8o15IrzGRpCyrn2EFkbG09zD
         NpnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version
         :x-gm-message-state:from:to:cc;
        bh=5SGZXXm779vUUr1cqzGV/gRigE4jlSEMeyxYIdb55pM=;
        b=qU2BxNESr9iCnNiIqGObzi0SyG+hiK/qrUdN/288TmbfZLTVXakTvLalYiAtH/VyR9
         qYzk9M0862ycm79034IHNwZLAIERHnxpZL1peIXzxsYmrs7H94FZE01QWHE/uAE/9+Z8
         mvaneJry/Bds40GlVy5mcB1U5wNWEXEK29SUr9TYn7OClzV1xYgjUjA1qmgR0iSkZKPb
         sOB3TLr97ul3/UyrWiUeSoaO1bpWdWeVY4eoK8ZNMrLyFcUk1wqN1vXGM2oTNkny8IVR
         jIpMsQuPJU2jOUcvmcrb8+CAK2wDNCYzwhd8KDuF6ydqqdlab4WVouLZ7YhmCeUtE+61
         +ddA==
X-Gm-Message-State: ACgBeo0dpPSrXpkp2cnW7KGDaKU45yk+VDFQKIE8rIamig+Ocxi2NONO
        BoyGsc8cLrMr0HNweVzMyyGBfAsYW9oefpCFbpk=
X-Google-Smtp-Source: AA6agR6Um4gsdnwRfc+QXbhyK3tvB1F086vW4REqIUniVnAQf6JxPuX8ZMtORQccqGkWQFa2F5yhJ4ladCoIGyisCgE=
X-Received: by 2002:a63:81c1:0:b0:42b:7aca:ddeb with SMTP id
 t184-20020a6381c1000000b0042b7acaddebmr12573326pgd.201.1661782439598; Mon, 29
 Aug 2022 07:13:59 -0700 (PDT)
MIME-Version: 1.0
Sender: bamounipatrick@gmail.com
Received: by 2002:a05:6a10:cc92:b0:2d5:2b65:3a5a with HTTP; Mon, 29 Aug 2022
 07:13:58 -0700 (PDT)
From:   sofiaoleksander <sofiaoleksander2@gmail.com>
Date:   Mon, 29 Aug 2022 15:13:58 +0100
X-Google-Sender-Auth: _Tpl7G5cY65P1C7rzkbA3oz4E00
Message-ID: <CAD+XN94-3uJ9TepqYzNee7d7qxXKe9MsZ8KRtBLeF9rY0zvvAw@mail.gmail.com>
Subject: Hello my dear,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=1.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,LOTS_OF_MONEY,
        MILLION_USD,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNDISC_MONEY autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello my dear,

    My Name is, sofia oleksander, a 20 years old girl from Ukraine and
I'm presently in a refugee camp here in Poland. I lost my parents in
the recent war in Ukraine, right now I'm in a refugee camp in Poland.
Please I'm in great need of your help in transferring my late father
deposited fund, the sum of $3.5 MILLION UNITED STATES DOLLAR, he
deposited  in a bank in United State.

the deposited money was from the sale of the company shares death
benefits payment, and entitlements of my deceased father by his
company.  i have every necessary document for the fund, i seek for an
honest foreigner who will stand as my foreign partner and investor. i
just need this fund to be transferred to your bank account so that I
will come over to your country and complete my education over there in
your country. as you know, my country has been in a deep crisis due to
the recent war and I cannot go back.

Please I need your urgent,
sofia oleksander,
