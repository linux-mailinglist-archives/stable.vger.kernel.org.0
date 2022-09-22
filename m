Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B3195E68B2
	for <lists+stable@lfdr.de>; Thu, 22 Sep 2022 18:41:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231889AbiIVQlg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Sep 2022 12:41:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231896AbiIVQlI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Sep 2022 12:41:08 -0400
Received: from mail-yw1-x1130.google.com (mail-yw1-x1130.google.com [IPv6:2607:f8b0:4864:20::1130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3A62103FC5
        for <stable@vger.kernel.org>; Thu, 22 Sep 2022 09:40:23 -0700 (PDT)
Received: by mail-yw1-x1130.google.com with SMTP id 00721157ae682-346cd4c3d7aso104744307b3.8
        for <stable@vger.kernel.org>; Thu, 22 Sep 2022 09:40:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version:from:to:cc
         :subject:date;
        bh=8rveiCO2s2ifRGP5UYnMLmArTRslMD6kGGFT4wMrtos=;
        b=Qs7hWntWvNqkqgf4jx23y1x6jjhihtRtGlVfAysro84zIHu04oNB+UaHDxl6BEYqbC
         bBm/1nzf7h1Kpw/bZcdZgvUg0I1L4yuJbuXc3yFPsF1fG+ay/ApCwP703afwboL5bMRs
         VAToGLY8HRilCxahHUEbkx5vq49jmMMdmrNP75Q7584nddcMpspKek9YzhG9wALFOrMF
         8UhXvIXRxniWI3z850dGlX0TAKdTUn7ElaKHBPRXZzQorkMUVTWQlu77KIIsO3jXHnj/
         S0Mdx9m2ZI5rIo5Yju3ML0v5+ryWU94HoBdEYTxQz/ANIoRBLipY5DVkVZAR51dw7WB5
         +FvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version
         :x-gm-message-state:from:to:cc:subject:date;
        bh=8rveiCO2s2ifRGP5UYnMLmArTRslMD6kGGFT4wMrtos=;
        b=rfE/8zgfLDdCD5DEG0wevkD5sJE9Vycv1TVLWGZcE7KbPH7htpEr4nlnUuOK0Ec/5z
         6dVw7tirBnpBGFciGGp0nHIIzfouv+Xhhi8mzDTUf2okAeAxjBU/+IiCe19aTg8ohhos
         LzUJ7YHArxe5WynQ6LIka+OxsqtL8kBlrKqqKyBohnbPEBE9KBms1E7Bl3h/Q6wiejqR
         yohde8Q1GYIobIlbI6ga//BZhwKEH2tjb+vA9EI++8huqFYSu3NLocbVyNVE15omn7dI
         tv2rCl0ahjyWyOe3Bg+VQHH/28b/cB8tDKoJ5oCkjWgt2eLHskl6kT26s8U0N60z7TrS
         8iIQ==
X-Gm-Message-State: ACrzQf1qVYrAd4GlPyc9VI3C5qbZ0HPBMgFtNqjD44n3zLD19Afd4Q14
        yClIWFYAUiVMCJjAAyDkc7F7kwAfsQNq+j61SJ4=
X-Google-Smtp-Source: AMsMyM5qNq5yTz6FRLj4J4b9QK2CXknUlKGJ+W/QxyLJwqJidAA8mApzVFTXEYUq/+rDGGuiSuu0tsvTe6r5MeOvg3Y=
X-Received: by 2002:a81:6ed4:0:b0:345:2c35:a203 with SMTP id
 j203-20020a816ed4000000b003452c35a203mr4208245ywc.262.1663864814364; Thu, 22
 Sep 2022 09:40:14 -0700 (PDT)
MIME-Version: 1.0
Sender: criseoteng@gmail.com
Received: by 2002:a05:7010:8329:b0:305:f362:9d8b with HTTP; Thu, 22 Sep 2022
 09:40:11 -0700 (PDT)
From:   Pavillion Tchi <tchipavillion7@gmail.com>
Date:   Thu, 22 Sep 2022 16:40:11 +0000
X-Google-Sender-Auth: fRgeeouYmpZZfMmai6ZwXk9df5I
Message-ID: <CAGFgH3miL_a_AdgrQ+aOemtMXDCn9Ex-hvGOiSQZiYzc+nYQiw@mail.gmail.com>
Subject: Inheritance
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=3.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_SCAM,
        LOTS_OF_MONEY,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_MONEY
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-- 
Greeting
I wrote to you before, but you did not answer my mail.
How are you today and your family? I hope you are fine! With Due
respect, I am attorney Pavillion Tchi, I sent you a letter last month,
but you did not get back to me with response.& I have an important
information about your heritage worth $5.5 million, which has been
entrusted to you by your late cousin, from your country. I seek your
consent to present you as the next of kin for the claim of this fund,
because the bank has mandated me to present to them the next of kin to
enable them start the legal process for the transfer of this fund to
your bank account.

Your prompt response will be appreciated for more details.
Sincerely,
Pavillion Tchi
