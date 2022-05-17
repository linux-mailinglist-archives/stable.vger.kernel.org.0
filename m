Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4885C5299D2
	for <lists+stable@lfdr.de>; Tue, 17 May 2022 08:49:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240547AbiEQGt0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 May 2022 02:49:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240558AbiEQGtH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 May 2022 02:49:07 -0400
Received: from mail-yw1-x112c.google.com (mail-yw1-x112c.google.com [IPv6:2607:f8b0:4864:20::112c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3395047062
        for <stable@vger.kernel.org>; Mon, 16 May 2022 23:48:38 -0700 (PDT)
Received: by mail-yw1-x112c.google.com with SMTP id 00721157ae682-2ff1ed64f82so26069147b3.1
        for <stable@vger.kernel.org>; Mon, 16 May 2022 23:48:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=dcwrPtXldcZQuaUTRubP/TsWaJ05MpxYEGzdke58B18=;
        b=A6nqQ5U5GOEzQxb7zNQtqtZDAsLVKLZL86LMdSqx+lVCmWxvs6Cp1H+lze1FtS2Ki6
         MOwEyKdmnycMz1wXfTbMm4+pL01L1KX0tuXHDl8emYEPLWgjGZT3cxwCiIiXH2Fb/7wc
         tPiW5MMnC8O3FrOj4plvMQtM5FbhuridzDgTxxL+fX7/4p1aHxv6xyFEGYWAQOC1AWyK
         6kks12HOqclN3bEgLnPDrJ5CBtr1WBbhun1ltmnxy4tbIE72ATDy4za2Xxu7omC4ZqvK
         1XqSiE4gTqRAexCdAsKYtf0x8E7afC0+Wqt+LGafHEgZneKmx7atUdCD2ICI+2pXZ7S2
         oMhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=dcwrPtXldcZQuaUTRubP/TsWaJ05MpxYEGzdke58B18=;
        b=MLial909+h2hFizf8ziYWITmFrhnnK7M+E7yFdNwtzJgxZqHUCQ+Lq3vdfPAgrfwbz
         RIJYRxpSw02ZcVr0H5OQAIA0/GCVSuj1ew52AQP8l8pTED1WXfQKMM10xr9VhXXzABfX
         k/zd9wnO5yWEDszMOESoDHz0qE/dnq+Um1mt9gGtHJa7q/vvsZnFXtkVj8MNwJW4ozGT
         1t/T/xrZkySHEFLXW1K6vvF8Une1Oq1U8Iqk3MYCYQ2HuOlvbLZ1aubX7Pz0bq/jNqn4
         Y9hRKakbjVuJNamUXl2rQXNrlFlrW4G2AL+DFa+HdaDCV356tOKPWf65EDJOu0MUAz6D
         /slA==
X-Gm-Message-State: AOAM531EW5K3s4JRhE+1p14/vS81vwYN1aV7bxELMVJ3UamC7GzEUIDO
        SLAMt03VwdnDQ7QKCULr8WoOdCIgkLzsMr39GV4=
X-Google-Smtp-Source: ABdhPJw9xwBUNSNWHSnmZ159pptiP91nWwGVLm999HrgvbKGJPU2gVRWPbyFoF1UzbpN281I1w1SGMZZsE4mmDfLjIY=
X-Received: by 2002:a81:2fc5:0:b0:2fe:d7d1:4315 with SMTP id
 v188-20020a812fc5000000b002fed7d14315mr14296121ywv.87.1652770117692; Mon, 16
 May 2022 23:48:37 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7110:8191:b0:179:888e:1844 with HTTP; Mon, 16 May 2022
 23:48:37 -0700 (PDT)
Reply-To: mrscecillelettytanm@gmail.com
From:   "Mrs.cecille Letty Tan" <kabiroubagna@gmail.com>
Date:   Mon, 16 May 2022 23:48:37 -0700
Message-ID: <CAP-q6B0=r6KhwEPEq6+Oqb5pwm39=3XMUChcb+X8z6RDxyNwgQ@mail.gmail.com>
Subject: Hello
To:     kabiroubagna@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=3.1 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        HK_NAME_FM_MR_MRS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

How are you doing today, I hope you get my message urgently, please.
