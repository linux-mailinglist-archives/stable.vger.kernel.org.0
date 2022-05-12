Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBD56524F68
	for <lists+stable@lfdr.de>; Thu, 12 May 2022 16:05:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350311AbiELOFP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 May 2022 10:05:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354994AbiELOFO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 May 2022 10:05:14 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0585A24C749
        for <stable@vger.kernel.org>; Thu, 12 May 2022 07:05:13 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id x17so9994889ybj.3
        for <stable@vger.kernel.org>; Thu, 12 May 2022 07:05:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pucesi.edu.ec; s=pucesi.edu.ec;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=cHQf0taWrzzojUMeetsoosTbky5/Gzcj47twe36ufso=;
        b=QErWUl6uAPORPyCxvzcAtZIybKJPZngc55wScfqV4vJe1ljglkBfMLDA3Dk+dOi2Qz
         tfJIz1O/OhIwXVE/K3RhHz/60/uoG8XSiBABIyAxh0NWnoo+mT0Smd9HLFgsaywitfWG
         ymCwXArC2PNUPIGzL3e83QWhnDuKRVGEoO/KzDoTSlF4umNCEw5roJRD04nKLCbRfHBS
         IcujQTJAy/MyT2sri8VBPx8Rxv9fHGowkIbYZkYERneAVx/iG6DWRMaLsxW8K2ORbEz5
         lgM13pJIyxCK41vumpnUY5bmj9ZJhWoGNfv2svNFjWHjvFr7dQ9TExL4wKvSk6FfmHQY
         JzMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=cHQf0taWrzzojUMeetsoosTbky5/Gzcj47twe36ufso=;
        b=ou5QN8S6bQKbiD2lTOUghpxgN+AwVAPKc5Jk1CZIpias3SunURCd3xUTpUImUDghJb
         9InvElMsiSoQXiBALkuuAMl+Dx9ZaZELdtpq6qxf+Ec5m1Ky1++FhgAaFOZQoW7kAg8K
         7xkTcOqR+zeHmJ8vMYcz8QHFwz29d7eGxZ5UIDBBZNkmoTfy1QpniU3bjaoO/7D09mts
         uLbnpBsktCo2xZIGmzi2ttzX5bbHmPWs1tQfTKLwH3zxS9kr9mGjrgakfZy901kBFcBH
         CaSXJ4e74vUA5Yw5qtfrTLhdIpNCh5vQxr1a9bSk3CeI9a5vMIXrhAw4LDqWUplzR6IR
         opCg==
X-Gm-Message-State: AOAM532YMI8f14ZCuJEMbwKl3wJgn5IlUZHS6eeSXBDbdAchKPhhOxif
        CbDKDsEwgBdj79f4uugXr/MIgR7cPWn3LsP1Xu+FkQ==
X-Google-Smtp-Source: ABdhPJy8tze1Bq2AiX43LXACGn1SMPGiwlxZqLf0LWXKFVMFj/m1YjndWCdq+IzbTjgDbdeSI9iB1ho8v7HShxBaVbk=
X-Received: by 2002:a25:b6c9:0:b0:64a:9f32:5ac4 with SMTP id
 f9-20020a25b6c9000000b0064a9f325ac4mr22795014ybm.131.1652364311839; Thu, 12
 May 2022 07:05:11 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7108:3983:0:0:0:0 with HTTP; Thu, 12 May 2022 07:05:11
 -0700 (PDT)
Reply-To: kenedyfunding@gmail.com
From:   KENNEDY FUNDING <kpflores@pucesi.edu.ec>
Date:   Thu, 12 May 2022 19:35:11 +0530
Message-ID: <CAEgw-o80tv8ocg6Vn18DE9xfu+DBG1fW+CD9qg9ufAYOQndJ6w@mail.gmail.com>
Subject: Urgent
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.4 required=5.0 tests=BAYES_60,DEAR_SOMETHING,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_FORGED_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:b42 listed in]
        [list.dnswl.org]
        *  1.5 BAYES_60 BODY: Bayes spam probability is 60 to 80%
        *      [score: 0.6009]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  2.0 DEAR_SOMETHING BODY: Contains 'Dear (something)'
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  2.1 FREEMAIL_FORGED_REPLYTO Freemail in Reply-To, but not From
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dear Sir/Madam,

Do you need a loan? If yes contact us today, we offer all kinds of
loan such as Personal Loan, Mortgage Loan, Real Estate Loan, Company
Loan, Investment Loan, Business Loan, Debt Consolidation loan and lot
more at 2% interest rate. If interested contact us for more info


Regards,
Mr. Gregg Wolfer
