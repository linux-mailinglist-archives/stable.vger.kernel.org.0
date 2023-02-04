Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4648168A8C2
	for <lists+stable@lfdr.de>; Sat,  4 Feb 2023 08:18:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbjBDHSF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Feb 2023 02:18:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjBDHSE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Feb 2023 02:18:04 -0500
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C46176192
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 23:18:02 -0800 (PST)
Received: by mail-lf1-x12c.google.com with SMTP id f34so10797027lfv.10
        for <stable@vger.kernel.org>; Fri, 03 Feb 2023 23:18:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cOHIOI4OxEN1TJWX0PBgQazav4FZYOgAtN8Of+8pSvQ=;
        b=iijzzVMeesA6mvRtYllkCOB7ZZ61ImNvVXrmBj6jQgmnqf96PrHRcUzfoVCzdjJgC2
         D+/XsW8/J76xptQ3P1h7qpkNyRPnju42pxDX6cOAbqPo4fNwrCa5sB4goJMJRDr8OLqZ
         COcULTdu/e7qkoLJY9uZYEQL9BI2+R55/TQZN4Kjp01D98nZXrUQpwpOUkXs9nLpetmX
         cF4/HpW0LugxBPGF40BTMoBFTy9XPSWv3uy7FrYPorLr12eUxqatck3QoktMc852AKSR
         Df79lJTH1zomNGkvwEpyirmKRC1TpzJI/iH8ZDa95oqUltuPSzxM9LKwElfFY1snz9Mr
         7+pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cOHIOI4OxEN1TJWX0PBgQazav4FZYOgAtN8Of+8pSvQ=;
        b=fVuxK3Gg89ny5Tvm18vVSGG10Mu5I4xQat/5vtZNxgZqrntjrO6rVpxvCcxLq9od60
         KVRwcaSCtx0TdcHnBy3hrRfyOrwouSBvz+39Uo34uoo9mKjQlG/0+txzOkNar8vm5/wR
         tiA3tkzL0WZzlgqWc8kLUgv/V7mM77alB4mtcKqqF6HaZZ0Uo+n2alTpvW5TAig74Rxv
         8RhmNdOf3Ki//Pg7IJfzXUxIe7HZ4K+y/mmVMCJ/Vbf2r3DQlgDPauMVh29hkLXHlYbc
         UV61DnbOyrcm7/wiciW07otK7MfNpMh+iJTa3jFklIzgf0sgz0P1GlbODUhvszvNSKde
         bXDg==
X-Gm-Message-State: AO0yUKX2FurWGRtaTTpv1kY4RVTKMvR5ToV+VjIzbVm/13ojvphw9Khm
        b5WMV51R2fkhalq2wbwj41aTi2N0Qye462gIb0o=
X-Google-Smtp-Source: AK7set9ZDJ53mYsQkcvId2A0x/krgZNB7ZeWbV9GWNDesKhn+NEO+KB0VqkLXbhudoBPG5/v7JKYWEhYzRzNyANAmpo=
X-Received: by 2002:a19:7005:0:b0:4d8:7552:2c19 with SMTP id
 h5-20020a197005000000b004d875522c19mr1916799lfc.34.1675495080940; Fri, 03 Feb
 2023 23:18:00 -0800 (PST)
MIME-Version: 1.0
Sender: mohammedaahil30@gmail.com
Received: by 2002:ab3:7303:0:0:0:0:0 with HTTP; Fri, 3 Feb 2023 23:18:00 -0800 (PST)
From:   Anain kaimova <anainkaimova93@gmail.com>
Date:   Sat, 4 Feb 2023 07:18:00 +0000
X-Google-Sender-Auth: R533U2cm3ZuuesdPzga9kZQHyoQ
Message-ID: <CALoWANjGW6RSG-UhadDdZwcAALpvhhHWKuSx9iinPYYtJm=kaw@mail.gmail.com>
Subject: HELLO
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.2 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,LOTS_OF_MONEY,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        UNDISC_MONEY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dear.Friend
I am Mrs. Anain kaimova. I am sending this brief letter to solicit
your partnership to transfer a sum of 11.9 Million Dollars into your
reliable account as my business partner. However, it's my urgent need
for foreign partner that made me to contact you for this transaction.
Further details of the transfer will be forwarded to you if you are
ready to assist me.
Best Regards.
Mrs.Anain kaimova
