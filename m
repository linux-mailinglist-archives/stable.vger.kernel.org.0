Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A2C2537298
	for <lists+stable@lfdr.de>; Sun, 29 May 2022 22:46:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230330AbiE2UqG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 May 2022 16:46:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230326AbiE2UqG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 May 2022 16:46:06 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 789407B9F9
        for <stable@vger.kernel.org>; Sun, 29 May 2022 13:46:04 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id h5so4149227wrb.0
        for <stable@vger.kernel.org>; Sun, 29 May 2022 13:46:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=/rL+TycpMQLfB5P4Zn9xgGfUWg8yPCNTwrE46ZNldMM=;
        b=nLb86QZNdqylnjl2fT65sKtxbyhT3QDXnGLcL4hI9DZx/cmA6mO3rWGs8/yuSQE/Wr
         6fE5wT2gMgYZjVBJazgs8pCliTNJf9KMMWWUclLTQgmO95uj8R7MXAtxfY6lHT76klvC
         cXwNQ0ak4+z+x/dKaGbn5nN4lECGRvtrn2rXIu6eQxCcfuHnq4L0ZzVcRbT1LGqIsaEF
         XJ+SQ5B8vw4DD0SxpdczoeqlkKVBs3bobZbS2tEDdNvmdBnOKTYMlhWiA9wgLsXFjcuP
         fdqlJ7O+tElB7tEipXKQNAHjJgYFdwU4gyoVBfZC/Fw2Bl+flRhU1Cgwx2mwSpZY562c
         asiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=/rL+TycpMQLfB5P4Zn9xgGfUWg8yPCNTwrE46ZNldMM=;
        b=PgtjBYeoPt74SwXtzwIDEWewBWNiOPfj+9IqIpSW+DX2FKAOQiF9+WzOELS1e3PImG
         92kFcIEcqCSbzqX/uog7AoB/0Qv36QPbbGk4KdzxU1ZgCgGAOegWT/wMFeatLBhK9Y94
         ooxqPbvkMTKGW3PB3BEstC7ZRpcOVugAEU3ErO6utST9BOZ7P2LHsvjpj3fyp6wUUS18
         a6B0mgokRcwFLffylmnknZy7X4fapfF9tVSYOYjjWJQ9tEncrpTMEzpizy6RNXFKo+vj
         PEHs+AtX17qBCkE6E/JTCYyoOdtpTIvaeOZmaDXCo1bpmNIsqBKaabuXG970aE1F6DHl
         U8zQ==
X-Gm-Message-State: AOAM5332onayiT/MAk7l99n1HoX7DNJ3kiv/06uwaeBt76XS34F8ndnQ
        0N4cN0H3jMczdtn8Ul+M0WyOJMp7XUHu+J3Jcwo=
X-Google-Smtp-Source: ABdhPJy7ERfvZlGReNZvLGoV/5k/jRYkbw1BbZjTB5kHXybqnO007ICehK+QVAxFKCMv5wHApRX3BQGJtVx8YgRJNZU=
X-Received: by 2002:a5d:6509:0:b0:210:8a0:4b94 with SMTP id
 x9-20020a5d6509000000b0021008a04b94mr15476431wru.431.1653857162908; Sun, 29
 May 2022 13:46:02 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6000:1788:0:0:0:0 with HTTP; Sun, 29 May 2022 13:46:02
 -0700 (PDT)
Reply-To: dravasmith27@gmail.com
From:   Dr Ava Smith <avasmith0002@gmail.com>
Date:   Sun, 29 May 2022 13:46:02 -0700
Message-ID: <CAD6OVVvgb4g4n2YkeqXdV=x1fU35AK9AH2gk4=-v5M6OQEr=6A@mail.gmail.com>
Subject: GREETINGS FROM DR AVA SMITH
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.5 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,SUBJ_ALL_CAPS,
        T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:444 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5011]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [avasmith0002[at]gmail.com]
        *  0.5 SUBJ_ALL_CAPS Subject is all capitals
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [avasmith0002[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [dravasmith27[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
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
