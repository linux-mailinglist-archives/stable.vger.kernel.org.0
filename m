Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE2D66B6F98
	for <lists+stable@lfdr.de>; Mon, 13 Mar 2023 07:46:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229524AbjCMGq1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Mar 2023 02:46:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbjCMGq0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Mar 2023 02:46:26 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B35241088
        for <stable@vger.kernel.org>; Sun, 12 Mar 2023 23:46:23 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id m6so14327624lfq.5
        for <stable@vger.kernel.org>; Sun, 12 Mar 2023 23:46:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678689982;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/rL+TycpMQLfB5P4Zn9xgGfUWg8yPCNTwrE46ZNldMM=;
        b=jBKDiCXSggL0lzvuF7hCJUUUChJMCfu2Cnx3IdrrtLlDs9EutqNyJnDewGQ85HaZC/
         dJ5qMQXCoxgHpchlpTaAJ2wW07BKzUHZGDA+uBu+pE7W+/ZRy/wH7c0heQ9M0ki2cvPT
         HHvmesqek74arF1YfyFkIG/iweyW+oxGrXIuuD/VT2lUOy30MdnUBuUnMAfdk6t6EZGS
         D58dqbPZbaZVSwnDXq7SXtEX9yULfGDcjWvibx9m5gclltOeWGHAGOBuSedZX/PKej/+
         L0oXy3JhVxMR8cFPG09uOrgQFNeQQKOOmzCtU1L7W0nQdhX2Bxj3yG+693L7xfKL0LNx
         xOpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678689982;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/rL+TycpMQLfB5P4Zn9xgGfUWg8yPCNTwrE46ZNldMM=;
        b=kiId1JFAAB2hRWhRFiXIDCEFF9w3uxWOxUgTIwLIMZuumPJ8FmH2phqEB5Phk0+7bo
         wGqAA4isslGOF8Gt0Yzduf0NEhiD0oqoKdy0RthfurZuYy3fc4GuuWJLNwrQKL6bCm9b
         5JYdsX72UVAV/9I3QfGWAggwstoZRJYdsa2IPq0ppR+hzxGrOqW2GBRScZbZTtYC6nua
         klU6+BG9b8d/+cx/bR1D9zw2PcFYkQltOdCV8ovkOPv7CnEenOJRQmv1NWH6PMtAhGq8
         +v/GMaIMgdHWxSRlYikqJdEPSbNvlrh2nXtqettt/Nd1WR8GprkoMutYq+N/JtFTHb1w
         Ia8w==
X-Gm-Message-State: AO0yUKWw2WliH+k0QLeN4G6n3lW3Or6GGQ9fIvvI6m3BI8g3FSGmiexT
        ok3lTAegksfe54vQAvqHYA+Mqf6UR+5KIJwX+sg=
X-Google-Smtp-Source: AK7set8jEK2l8rxXy3XkQwdQyXG/dsOtGQDFTuTM3EDf7DO33+uZpbGjRyFOLvVbvMfG538XLATt32d5FgD89tqOhgU=
X-Received: by 2002:ac2:44d1:0:b0:4db:1999:67a3 with SMTP id
 d17-20020ac244d1000000b004db199967a3mr10138207lfm.13.1678689981663; Sun, 12
 Mar 2023 23:46:21 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a2e:a36f:0:0:0:0:0 with HTTP; Sun, 12 Mar 2023 23:46:20
 -0700 (PDT)
Reply-To: dravasmith27@gmail.com
From:   Dr Ava Smith <hde46246@gmail.com>
Date:   Sun, 12 Mar 2023 23:46:21 -0700
Message-ID: <CAC1T3Q_xJ=u2AYK7rTjkM0P+U=c=hnQrcgYDEKdGGKO-q1z0iw@mail.gmail.com>
Subject: GREETINGS FROM DR AVA SMITH
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.5 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,SUBJ_ALL_CAPS,UNDISC_FREEM
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:131 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5144]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [hde46246[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.5 SUBJ_ALL_CAPS Subject is all capitals
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [hde46246[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [dravasmith27[at]gmail.com]
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  2.9 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-- 
Hello Dear,
how are you today?hope you are fine
My name is Dr Ava Smith ,Am an English and French nationalities.
I will give you pictures and more details about me as soon as i hear from you
Thanks
Ava
