Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D98CA6A46DF
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 17:19:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229605AbjB0QTz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Feb 2023 11:19:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229985AbjB0QTy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Feb 2023 11:19:54 -0500
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3057FF760
        for <stable@vger.kernel.org>; Mon, 27 Feb 2023 08:19:52 -0800 (PST)
Received: by mail-lj1-x22d.google.com with SMTP id b10so7101083ljr.0
        for <stable@vger.kernel.org>; Mon, 27 Feb 2023 08:19:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PAGV2Q8tueB9u6nAu32uT5tMQP/9mkBrRApmZJ0yLwI=;
        b=qw9JCrzW9tn47DSvVIJoaKqMmAI/ZdOy5gVI/AOLhvYQYdczvG3J/OoggZRHEGGYfW
         jW8RC03iWHJaHPpqE0HVIt+RtP4XcWG/TDnhZwSXFOyBnH/e/blelA073AgI0aRLbE3Y
         nwzeqj2I7XTfEWWpi0TXqmC2NzRKWkkCE8DI4zTMkoUnpcfOb+C7K0BtcXAB8WJqtXKa
         HDBrhTgROJsnEkLz0CEBlWByuJ7K5E6md7SQXyRqPj9HjS2gwo/wA7/mVK/MQpyD2ijV
         ZTlFmWRQkiOm/FIP797YVkUaJq8z1zf99plLaOgP0+yNy76plejkf0ndk3GY57lrZudE
         vgiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PAGV2Q8tueB9u6nAu32uT5tMQP/9mkBrRApmZJ0yLwI=;
        b=zuJIiLtH84TRKQ89vXy+JCJ0bAs6+Id/immOeQqtkwlv4p6HnxrbmzwWl2gPB1t2ps
         0x3FK1PKy+egA14tfwaKqkAJFsG+RLTkh7zarqYMVX0mkXjaTldwfZZ+Iit0nJcVL69N
         J4LPXcebzAciST6xUt/OQrvbvg9laV9TtA/t6+URzGPk3pbJvv+lsG0Jk1+tV/B4If0r
         vi+yDYAIkqBgW/Vtnopxbpd6Xb8OQ+dO8k31PQFmwTFNYNBoP7gpbvo1S9C9PJIg1XjI
         k04sLFKK01wn5xhbI7LzNFDvAwyo5YlHzVbTx8ZTW9yG0d6cMtHdch4fIWuFHX1M31ER
         U3Bw==
X-Gm-Message-State: AO0yUKVnfV3vbNzXhYa6eYzu1DgpyYugzpasRHlIVxOmToxvFLLIH33h
        IP5/PjR8pzWXsAa+nixzmtDn8BibGMCScEoBeCg=
X-Google-Smtp-Source: AK7set8XQSlFd90XL3FHqGlBs6612oLCmRSxwAvPLcoySBOnLUDree1vbK0M1koNBSY60+eN7YPz40qodRsszro7yl0=
X-Received: by 2002:a05:651c:895:b0:295:9626:a1d9 with SMTP id
 d21-20020a05651c089500b002959626a1d9mr3805884ljq.1.1677514790394; Mon, 27 Feb
 2023 08:19:50 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6520:190:b0:24f:33ec:eb13 with HTTP; Mon, 27 Feb 2023
 08:19:49 -0800 (PST)
Reply-To: felixdouglas212@gmail.com
From:   Douglas Felix <df894162@gmail.com>
Date:   Mon, 27 Feb 2023 16:19:49 +0000
Message-ID: <CAOCmxksByGzsNDB4Ek5vcMQZ-SHq1y6w_1wx5f5y8ujSaEmpsQ@mail.gmail.com>
Subject: Good Day
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.8 required=5.0 tests=BAYES_60,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: *  1.5 BAYES_60 BODY: Bayes spam probability is 60 to 80%
        *      [score: 0.7660]
        * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:22d listed in]
        [list.dnswl.org]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [df894162[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [felixdouglas212[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [df894162[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
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
A mail was sent to you sometime last week with the expectation of
having a return mail from you but to my surprise you never bothered to replied.
Kindly reply for further explanations.

Respectfully yours,
Barrister. Douglas Felix.
