Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53EAB662DC9
	for <lists+stable@lfdr.de>; Mon,  9 Jan 2023 18:58:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230420AbjAIR6H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Jan 2023 12:58:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237374AbjAIR5k (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Jan 2023 12:57:40 -0500
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 056A539FB3
        for <stable@vger.kernel.org>; Mon,  9 Jan 2023 09:53:38 -0800 (PST)
Received: by mail-lf1-x12a.google.com with SMTP id bp15so14177457lfb.13
        for <stable@vger.kernel.org>; Mon, 09 Jan 2023 09:53:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mV5PeBWjbAt+jdxJk/6pzFPhbIuu2htqwYYpEc7BluY=;
        b=OnAtaMJ2CiVfuMa3W0W//itpCC654rb1tvScXNnRGE/FLvkqU9vvCfD4gQ257dcGS3
         fzVBt1PYNMxhURPvG3iwqXsnEZjmo/0mmmElEsKZNc6YoO0xnWMbdqOaR3wr8bXy+sWg
         tWlMIt7DUuszhYdIpX0PzbCBP+3crQIfEn7r5PRx62ULT6jGeEgrwzYnn7SoM1UsbSR2
         DiUD/zD3aVHTfO2+w8sNL06T6ycV6PdeAh6Mo1DrRhybcqb5T3ZzFiz/pvuJ4A2dziy7
         ozQCjO0bLRXD2VoglVOHILOIj9qoM8vu5CFiSlgc0GV3xUMoNtgxzNJGxg1CS79pO7fP
         irEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mV5PeBWjbAt+jdxJk/6pzFPhbIuu2htqwYYpEc7BluY=;
        b=zg4ak1L6LQDXe8KJ4bUR7Ox3Gt96sipZuYEET2T9hSFKXgZ0L0nGI0Rf365ToHipcv
         FrV09i1lStMdcFCYTVOXKLxcIozgVCzU38MXBTnKMw+LJ1VAfSd21QjszGw65pfKK1Nx
         lorHZVRAVmfnv9D1Me0wt7hzGdOZW4MMfr4tejhCxEwxPiQXZH1lE0dudwrw+VZGgGHx
         8lof85Jv7vDRaVB1GUVOTZRU6Yiorcg5+G6tDWIRxTOoMu5UAqeOEDp9UkKh0wKghiPp
         6EG1o/gPtqpbpIIAZt+XAS9sZ9cLWAN7lIg4pkZIQx3z9/j/UYR2MgQvLg8fcXD/JtU3
         avgg==
X-Gm-Message-State: AFqh2ko98NiZ+adFKmgaIfvjQKzbrz4GvTPUnxx8pjrGpvxZqVwfRZhk
        1sfYXWtxkjYDwR+pwsY6w6OHvZiIeFtnloRcXEw=
X-Google-Smtp-Source: AMrXdXtVELsPrq+UD1babc8Wu049GWSQ/QhIjdHLUvQ4grji8u0Xc2i74mxD4SwQY89NP049Wi2v3HI3fINvTMN2C7o=
X-Received: by 2002:ac2:4851:0:b0:4cc:5a57:ba99 with SMTP id
 17-20020ac24851000000b004cc5a57ba99mr1133675lfy.678.1673286816303; Mon, 09
 Jan 2023 09:53:36 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6022:3122:b0:35:2af5:3578 with HTTP; Mon, 9 Jan 2023
 09:53:34 -0800 (PST)
Reply-To: jb7148425@gmail.com
From:   James b <b248074@gmail.com>
Date:   Mon, 9 Jan 2023 17:53:34 +0000
Message-ID: <CAENsMjNKD7N6chJiJLPPNO=vteMRz3Q3XJ1-VvjZDW-qu6i=vA@mail.gmail.com>
Subject: Greetings to you ///
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.5 required=5.0 tests=BAYES_60,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:12a listed in]
        [list.dnswl.org]
        *  1.5 BAYES_60 BODY: Bayes spam probability is 60 to 80%
        *      [score: 0.6397]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [jb7148425[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [b248074[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [b248074[at]gmail.com]
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  2.7 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greetings and the peace of the Lord be with you. I send this message
with a painful and broken heart. please get back to me as soon as
possible. I have a there is a confidential matter to be discussed with
you.  Regards
