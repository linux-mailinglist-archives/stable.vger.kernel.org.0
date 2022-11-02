Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50F3C616351
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 14:04:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230219AbiKBNEz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Nov 2022 09:04:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbiKBNEz (ORCPT
        <rfc822;Stable@vger.kernel.org>); Wed, 2 Nov 2022 09:04:55 -0400
Received: from mail-yw1-x1133.google.com (mail-yw1-x1133.google.com [IPv6:2607:f8b0:4864:20::1133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6164C18B15
        for <Stable@vger.kernel.org>; Wed,  2 Nov 2022 06:04:54 -0700 (PDT)
Received: by mail-yw1-x1133.google.com with SMTP id 00721157ae682-367cd2807f2so165606427b3.1
        for <Stable@vger.kernel.org>; Wed, 02 Nov 2022 06:04:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=77BwqRII9XCweQU8IJul6unijI/BEL+vUJmVmCRLxH4=;
        b=Ar0uot5jl2tZgDuPdZeD8JCsYGzrDmGdFXtm8+Re70IA+SIkohY26dcmw1skHc045l
         S+XlCb9XtVlzguwK3gsrmqjOZnmAASFeEcC8RmTUyG5JW9s+T5hcxYT/8qtJrB4PYkqN
         20Rdj6wxy6Um+G6Cya/7FNeCmQal/MFzFNmZ0/cVke/1c8U5ni4J1lbcEw1wSuoyQCJa
         RZuPjP7Yl3DDrEPc8yUq2GJM5eGbjXvqOnmiUZ+EeKWZNzZ49TuFoANoWofjVqVB6as9
         wSHnTJal3G3q7/Ac8Uicc7bAlaHovjEykEDDFZwnaojcFbhgU+lJlE5JBwp8k6oLCcd0
         Sd3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=77BwqRII9XCweQU8IJul6unijI/BEL+vUJmVmCRLxH4=;
        b=DSBbRnkuvqqyD+zMtYGuAF4SKtJNuC+WGc5oRDjO1FD5x8hAz9Z0n1pIsUj4y8n/27
         ug/MRjX3rt3V4klQ4syadtY++YfGsBNioM0Zd9PMn6grlC1+y09KV6H6P0kYjxLCiKA2
         c6bmGiA/e2igph1A1xln5PFLoS85jR/uKu9S9sA28T5EqBJDYWDgp0EpHdPgzOzizKN8
         JUukmjYbj1M8qoRHkVyD0VtsTFr4Ls6SF2EwzjYaQae0WisoM55tFFheibuf+Pks8C/w
         H5hK+5iDgqCN+ZKQkLW4mHIv5XTA2aHsshIBRJbODId3uoV0oO8GqF7DdeLvsFq3Ktd8
         +dMQ==
X-Gm-Message-State: ACrzQf0vKgu8uO7l1Z66i4r8KUD4swGCpZH15PJkXWvSDJqOAX6d+TV+
        kPwugk2QcUZJJZ9OYA1AioZ9CdyB6NBKp9OoDno=
X-Google-Smtp-Source: AMsMyM4EL2deKmL0QC9g+UTdtUxA71WxMXHlDst5Kxyg9LTgfTziAltRbfZ0D4O8B/QpUuP0cLJNI9NLEU6Yo+ph5I4=
X-Received: by 2002:a81:57c9:0:b0:36c:dd56:ce58 with SMTP id
 l192-20020a8157c9000000b0036cdd56ce58mr21723328ywb.5.1667394293153; Wed, 02
 Nov 2022 06:04:53 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7000:17c5:b0:3da:1e36:e3f4 with HTTP; Wed, 2 Nov 2022
 06:04:52 -0700 (PDT)
Reply-To: rihabmanyang1993@gmail.com
From:   RM <awibrahima34@gmail.com>
Date:   Wed, 2 Nov 2022 13:04:52 +0000
Message-ID: <CAH=ybGFwjjFo406uH-apy0ocFvpyyDOYQOEJsw-YRBAGN0ebNg@mail.gmail.com>
Subject: HI DEAR..
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.1 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:1133 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4998]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [awibrahima34[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [rihabmanyang1993[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [awibrahima34[at]gmail.com]
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  3.0 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-- 
How are you?I am miss.Rihab Manyang i will like to be your friend
please write me back on my email for more details, Thanks.
