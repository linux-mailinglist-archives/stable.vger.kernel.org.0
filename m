Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27A0E643DEC
	for <lists+stable@lfdr.de>; Tue,  6 Dec 2022 08:57:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230317AbiLFH52 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Dec 2022 02:57:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230289AbiLFH51 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Dec 2022 02:57:27 -0500
Received: from mail-vs1-xe30.google.com (mail-vs1-xe30.google.com [IPv6:2607:f8b0:4864:20::e30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA2A914D31
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 23:57:26 -0800 (PST)
Received: by mail-vs1-xe30.google.com with SMTP id t5so13427003vsh.8
        for <stable@vger.kernel.org>; Mon, 05 Dec 2022 23:57:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=OGpiz7DrXLbyEGUvGioYWcGeQmimAIgmZsGGAj7dQSA=;
        b=EiZgJgCj2VIorRffMTajrX8FNBahVEhF72HtbDSe9uL9Bt5PxTcGTS591rm5nTxN2u
         rlN4qbgin5uT1tcS5bnmQZI9dva07WKctoL3J4SKxLTEwtDo1b4jJ+6mL37h48sNo8Fm
         FmraS/hp5ya5Fyc0f8azOHFQgNXIeZ6KpIxVy73j9Urzp9OQX7Dy3//D7+9Hab1LqgQS
         f1Uml99FyzZAyHB2hhDXxr/kfpxCuDwr1giT6ymyw9Yuzt4etFwC3MNFj8O7GTmQSTbL
         fhtfNGB+vedB8dcMnhVHUjI/Xn+AldqUuHF989kW5rHtqoEYHZ7df0hhV+J2fjJKrsPX
         Erbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OGpiz7DrXLbyEGUvGioYWcGeQmimAIgmZsGGAj7dQSA=;
        b=AZ3guzSnbjGYlyEkdeqz3VWv8v6M0lUwtmfoOmcUSEP3Q5DalmePaEYHIUAcQkS+AI
         Eo0RidpITUDd+3JbpxW1qgQJEkN3d20/egdUxdnDjnRsb/s5YdQnI0rAocQMrrXoamAZ
         WwiC3ADyBRoTBVcnCQzWa5VBhQrMLF943K82zA4U3KWg6yltkCMuTTeS0smVNmctEcJm
         nWuZyU2bQKVhUe1Yyq68TJH8vcg1fNqMDlLR3kEFhOxGYlJV+X+ss2WW1Afyp9ngmtBY
         DLlijXv70NDGB9skcXw1JDiAD+c0JEIJJ7P2EStU5Sgkdwmzgk3gibf+k19nISorUTLq
         58sA==
X-Gm-Message-State: ANoB5pknUe88t+Z1K0lk/wDhZS+yELU+IkOzCG9xfr2QC6Sibl6d1O7j
        3JPhVLuQ1nz9egpaBVTUv4r4863JaU7rDkAZaHSTZFyN5lI=
X-Google-Smtp-Source: AA0mqf6+55HuwnxehNQitvwklHtJwZmqx+Tgin1/x+3kYVbjBjV9iRvCmddJ1g64HuVBAIwmbqVczVKThWs1m7NIjJg=
X-Received: by 2002:a67:c792:0:b0:3aa:9c4:a9a9 with SMTP id
 t18-20020a67c792000000b003aa09c4a9a9mr36281184vsk.75.1670313445665; Mon, 05
 Dec 2022 23:57:25 -0800 (PST)
MIME-Version: 1.0
References: <20221205190808.422385173@linuxfoundation.org>
In-Reply-To: <20221205190808.422385173@linuxfoundation.org>
From:   Fenil Jain <fkjainco@gmail.com>
Date:   Tue, 6 Dec 2022 13:27:14 +0530
Message-ID: <CAHokDBkWNSt2QFCua=LuZkLEm2q65=CYyr29gBn8i=6d4WtA9g@mail.gmail.com>
Subject: Re: [PATCH 6.0 000/124] 6.0.12-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
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

Hey Greg,

Ran tests and boot tested on my system, no regressions found

Tested-by: Fenil Jain <fkjainco@gmail.com>
