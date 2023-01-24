Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 965BD679DF4
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 16:51:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234363AbjAXPu7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 10:50:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233061AbjAXPu6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 10:50:58 -0500
Received: from mail-yw1-x112a.google.com (mail-yw1-x112a.google.com [IPv6:2607:f8b0:4864:20::112a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED09D360BA
        for <stable@vger.kernel.org>; Tue, 24 Jan 2023 07:50:57 -0800 (PST)
Received: by mail-yw1-x112a.google.com with SMTP id 00721157ae682-50112511ba7so164897767b3.3
        for <stable@vger.kernel.org>; Tue, 24 Jan 2023 07:50:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FocuR5aXn3z28LzYD0rCmA/t4By4lcIW0G986gs+i74=;
        b=UqyT1hbhkVKgeIZmRZxIkMk1pJ6PzFs+7qP6IXkoTDrCqzeBTCONZzi8P3sRhAejCe
         w1NpllGERTcCMOwRGlBXTI3bzITUyP7SFaCwEaRI/23m6Rg6fRuSleaLnmtMjW0Gm7Pj
         3BFU77IyWcIvaPR0hmRQgsPOA25QA0vK88fpDpVRrZVdwsM/h9x9gIfDpphDB8V2qdJq
         /Ln3t2yEhhz7Atbo3wbXZ4kdfUtSVFixFC7XdEhSW8Tdc3WZEaVZWhL8LQFSbBrLtnij
         j/XSRIhVRLLcIHkVqYZy2OLo5qsy2zBL/Jf2t7Kwd394fryrMexDG66WkDrtIglypDQV
         xYuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FocuR5aXn3z28LzYD0rCmA/t4By4lcIW0G986gs+i74=;
        b=r6BtbmGEOWWwxLCxVCW9LKkHdJb6fiwhH+q8AprqQMwi+JE1GkQh/b++9Fu0QHiCqQ
         IY5ULm2sAo1FU2bV0jmZIzDic/JozFxDBHJY1UCFNTs53me82YqA3tFiZ9LWrrlvx8mf
         ydj6bCasmEsi36qqHnWHoYIzjGlaGXpYp8pqbnZAukWAgp9an/EouO/29EoNAdEtaz/C
         GVwCFz1dS8FhnovqBzgO0V/0Ukx+joydpjZl3ZncDjkZqoMLExdbSJtry11i0MUKi+b+
         Ch+cxdLBRkh60SDUe2h1824a7xXCZBZvQtj3Tylw7yDpxQ46Hpd7qhMKtcwb8x9y5OYW
         v8HQ==
X-Gm-Message-State: AFqh2kpgVioSNlxPjkbu9Nwan065wuYc0znlYC9k9B7wlZgFR70dvj41
        KObSrGCiFI2Gi2lzpL0T4rsDq2yzUZ0H9YBrar0=
X-Google-Smtp-Source: AMrXdXt/ZY0mXE1Vwq6kyuEAqOP+SUtuuW/oDEA6CLUg6+JqA7T8ayjndzWSzItOza5+KbJthKKXCmaN9A/kp5j/J+E=
X-Received: by 2002:a81:160a:0:b0:4e3:f87:8c24 with SMTP id
 10-20020a81160a000000b004e30f878c24mr3723774yww.248.1674575457113; Tue, 24
 Jan 2023 07:50:57 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:7010:458f:b0:325:1aff:db4c with HTTP; Tue, 24 Jan 2023
 07:50:56 -0800 (PST)
Reply-To: khalil588577@gmail.com
From:   Abdul Latif <anthoniushermanus1966@gmail.com>
Date:   Tue, 24 Jan 2023 15:50:56 +0000
Message-ID: <CACiMciYLatprG6NscS20CDWq4nFP-mp30n5knF4JV=2qnGAigw@mail.gmail.com>
Subject: GET BACK TO ME
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.4 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,SUBJ_ALL_CAPS,UNDISC_FREEM
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4998]
        * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:112a listed in]
        [list.dnswl.org]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.5 SUBJ_ALL_CAPS Subject is all capitals
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [anthoniushermanus1966[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [khalil588577[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [anthoniushermanus1966[at]gmail.com]
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  2.8 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I am Mr.Abdul Latif i have something to discuss with you
