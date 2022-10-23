Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 657CF609539
	for <lists+stable@lfdr.de>; Sun, 23 Oct 2022 19:44:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229756AbiJWRoT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Oct 2022 13:44:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbiJWRoT (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Oct 2022 13:44:19 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C91B6C948
        for <stable@vger.kernel.org>; Sun, 23 Oct 2022 10:44:18 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id i65so6180945ioa.0
        for <stable@vger.kernel.org>; Sun, 23 Oct 2022 10:44:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kRRj4eOpcx9QQmAcY2ZoIhCt6zVq2yNSzXo4XWr0HlQ=;
        b=eUEcNW/nuX3qgS1phZYH7wyyXsywkKdKnDhS83G0eYy50sJsn9reT+TpYiTyHRS8Hz
         5lDazxC1TtV9MwB/+UA6xk6mm2pFMzvHZ+cjmpCxenO3GOWPucLsznBGPSiCcY/WmvO9
         5H5i6N33IvnqHI3WEDCNEvKm6sPy6odmUDHcQXY6dpFrVDmNlEi/5tIWqu3rxuPtAzzc
         XF8c6rl0FyBBuhPBpFqMT6QU9aqr+zPGai8xN+pf8/z5WEnwriU9uSiAgvFD9FyB98GF
         ekW129KjdR4tsv0YuVG9gBT3USb/EVhfZJMo8Y4FxX0CFESjnVQ6nPWe4wauxwXZGNPc
         JlLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kRRj4eOpcx9QQmAcY2ZoIhCt6zVq2yNSzXo4XWr0HlQ=;
        b=rMvcvxvZxlrShFcqgXpyMFsq1eF80qgm3hl8/WgJpRjjAwVKgKvBIR7pCzW46uExJq
         VyUVmqsvcwn/OWpvG6/fF4Ek8HwPxBrHeGNtuw0j+4T5JMDKi1GajNp5EP3dchmNxbZx
         W9FiJ0YBeEzrtr7rJWTIbg7NPFQQDdoHegha5B9RPvfQOHDMiMImlWUcDXD3qu3q+kAC
         XB0qSZzX9DsCokVa8rYjpz8kraq+/K6iTz7Ox2mg1+9MBR2vawPInXXJMjX3s4EmQmjk
         Q+WhQBBLv94pvMbwMC5AD46kzPvGBFsy1/yZNKcmHX/k7Alsr5ATnQ+JKw/uHOFcYpTi
         rTBQ==
X-Gm-Message-State: ACrzQf1XR3jzW4sEQUgA/VHhGwj+bXinwI4X0eYKFLL5voXarkSnPDL3
        R44Dl8w9PS3Rq7tnNexSHkKlAprPuGW4QyZHAxY=
X-Google-Smtp-Source: AMsMyM6cpEsSmWB12UXRVOIZ0xiJ0jnqHBvArdjRkjReKo6zGF0ymZNPGDQP5uwTkUt0l+u/PwZKf+wgD+TpB2cgpeQ=
X-Received: by 2002:a05:6638:470a:b0:374:17a5:cee6 with SMTP id
 cs10-20020a056638470a00b0037417a5cee6mr868037jab.161.1666547057846; Sun, 23
 Oct 2022 10:44:17 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a4f:f337:0:0:0:0:0 with HTTP; Sun, 23 Oct 2022 10:44:17
 -0700 (PDT)
Reply-To: wijh555@gmail.com
From:   "Prof. Do-Young Byun" <scsd7622@gmail.com>
Date:   Sun, 23 Oct 2022 10:44:17 -0700
Message-ID: <CACguRjKC4mnnajgOti6z1KJC6tteGH-ShkVbKgeZs9B7a1ReQg@mail.gmail.com>
Subject: Good Day,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=7.8 required=5.0 tests=BAYES_99,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:d2c listed in]
        [list.dnswl.org]
        *  3.5 BAYES_99 BODY: Bayes spam probability is 99 to 100%
        *      [score: 0.9985]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [scsd7622[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [wijh555[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [scsd7622[at]gmail.com]
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  3.0 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-- 
Good Day,
Hope This Email Finds You Well, the Board Director are waiting to know
if you have it in your possession", Hope that this mail will meet you
in good condition, We are privileged and delighted to reach you via
email" And we are urgently waiting to hear from you. and again your
number is not connecting.

Best regards,
Prof. Do-Young Byun
